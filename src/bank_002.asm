; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

;@ path: sound/music
;@ Music track of every overworld room, one byte per room: index = room number (row * 16 + column of the
;@ 16x16 overworld grid), value = music track number. Read by SelectAreaMusic (when Link has a sword) and
;@ by the room transition when it checks whether the track changes. Tracks used: $04, $05 (most of the
;@ island), $06 (the top two rows), $08, $09, $0B.
OverworldMusicTracks::
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0b, $0b, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0b, $0b, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
;@ path: sound/music
;@ Music track of every indoor map, one byte per map ($00-$1F, index = hMapId): $00-$07 the eight
;@ dungeons ($14 $15 $16 $17 $4B $58 $5B $5A), $08 and later the houses, caves and special areas ($26 is
;@ the common house theme). $00 = no track of its own. Read by SelectAreaMusic.
IndoorMusicTracks::
	db $14, $15, $16, $17, $4b, $58, $5b, $5a, $12, $26, $26, $26, $26, $26, $07, $02
	db $0a, $26, $0a, $53, $13, $3e, $1f, $00, $00, $00, $00, $00, $00, $0a, $48, $26
;@ path: sound/music
;@ One flag per music track $00-$25 (index = track number; the last byte is never read): 1 = this track
;@ keeps playing while a Piece of Power or Guardian Acorn is active, 0 = the power-up theme ($49) replaces
;@ it. Set for tracks $02, $04, $07, $0A, $0B, $0C, $0E, $22 and $24. Read by SelectAreaMusic and by the
;@ room transition.
MusicTrackBeatsPowerUp::
	db $00, $00, $01, $00, $01, $00, $00, $01, $00, $00, $01, $01, $01, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $01, $00

;@ def SelectAreaMusic()
;@ path: sound/music
;@ Starts the music of the area Link is in: track $1D before he has a sword, else the overworld room's
;@ track or the indoor map's track (indoors $18 while wIndoorAltMusic is set, $21 in the side-view rooms
;@ of the dungeons). While a power-up is active the power-up theme $49 plays instead, unless the track is
;@ one of those marked in MusicTrackBeatsPowerUp. Skipped once when hSkipMusicSelection is set.
SelectAreaMusic::
;> if hSkipMusicSelection:
	ldh a, [hSkipMusicSelection]
	and a
	jr z, .select

;>     hSkipMusicSelection = 0
	xor a
	ldh [hSkipMusicSelection], a
;>     return
	ret


.select
;> track = 0x1D                                 # the island's theme before the sword
	ld d, $1d
;> if wSwordLevel == 0:
	ld a, [wSwordLevel]
	and a
	jp z, .clearAltMusic

;>@clr1     wIndoorAltMusic = 0
;> else:
;>     track = OverworldMusicTracks[hMapRoom]
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, OverworldMusicTracks
	add hl, de
	ld d, [hl]
;>     hNextDefaultMusicTrack = 0               # (a = track, then cleared: the request is dropped)
	ld a, d
	xor a
	ldh [hNextDefaultMusicTrack], a
;>     if wIsIndoor == 0:
	ld a, [wIsIndoor]
	and a
	jr z, .clearAltMusic

;>@clr2         wIndoorAltMusic = 0
;>     else:
;>         track = 0x18
	ld d, $18
;>         if not wIndoorAltMusic:
	ld a, [wIndoorAltMusic]
	and a
	jr nz, .play

;>             track = IndoorMusicTracks[hMapId]
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, IndoorMusicTracks
	add hl, de
	ld d, [hl]
;>             if hIsSideScrolling and hMapId < 0x0A:   # side-view rooms of the dungeons
	ldh a, [hIsSideScrolling]
	and a
	jr z, .play

	ld a, e
	cp $0a
	jr nc, .play

;>                 track = 0x21
	ld a, $21
	jr .start

.clearAltMusic
;=@clr1
;=@clr2
	xor a
	ld [wIndoorAltMusic], a

.play
;> hDefaultMusicTrack = track
	ld a, d

.start
	ld e, a
	ld d, $00
	ldh [hDefaultMusicTrack], a
;> PlayMusic(track)                             # start the track
	call PlayMusic
;> if track < 0x25:
	ld a, e
	cp $25
	jr nc, .powerUp

;>     if MusicTrackBeatsPowerUp[track]:
	ld hl, MusicTrackBeatsPowerUp
	add hl, de
	ld a, [hl]
	and a
;>         return
	jr nz, .done

.powerUp
;> if wActivePowerUp:
	ld a, [wActivePowerUp]
	and a
	jr z, .done

;>     wMusicTrackToPlay = 0x49                 # power-up theme
	ld a, $49
	ld [wMusicTrackToPlay], a
;>     hDefaultMusicTrackAlt = 0x49
	ldh [hDefaultMusicTrackAlt], a
;>     hLastMusicTrack = 0x49
	ldh [hLastMusicTrack], a
;>     wRestoreMusicAfterTransition = 0
	xor a
	ld [wRestoreMusicAfterTransition], a

.done
	ret


;@ def SpawnChestContents()
;@ path: item/chest
;@ Spawns the entity that rises out of an opened chest (type $07) centred on the chest's square
;@ (hBGPosX / hBGPosY), with the item number from hMultiPurpose8 as its sprite variant.
SpawnChestContents::
;> slot = Call_3C01(0x07)                       # spawn entity type 7; carry = no free slot
	push bc
	ld a, $07
	call Call_3C01
;> if not carry:
	jr c, .done

;>     wEntityStatus[slot] -= 1
	ld hl, wEntityStatus
	add hl, de
	dec [hl]
;>     wEntityX[slot] = (hBGPosX & 0xF0) + 8
	ldh a, [hBGPosX]
	and $f0
	add $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[slot] = (hBGPosY & 0xF0) + 0x10
	ldh a, [hBGPosY]
	and $f0
	add $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[slot] = hMultiPurpose8   # which item
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hMultiPurpose8]
	ld [hl], a

.done
	pop bc
	ret


;@ def UseOcarina()
;@ path: item/ocarina
;@ The ocarina's button. Unless Link is in the air or already playing, he starts the song selected
;@ in the menu: wOcarinaSongState gets the song's length in frames and the tune starts on the wave
;@ channel (Ballad of the Wind Fish $DC frames / tune $09, Manbo's Mambo $D0 / $0B, Frog's Song of Soul
;@ $BB / $0A). Without any learnt song he plays a short tune of his own ($D0 / $15).
UseOcarina::
;> if wIsLinkInTheAir or wOcarinaSongState:
	ld hl, wIsLinkInTheAir
	ld a, [wOcarinaSongState]
	or [hl]
;>     return
	jr nz, .done

;> wOcarinaNoteTimer = 0
	ld [wOcarinaNoteTimer], a
;> wOcarinaNotePhase = 0
	ld [wOcarinaNotePhase], a
;> RestoreLinkPosition()                                  # Link stays where he was
	call RestoreLinkPosition
;> if (wOcarinaSongFlags & 7) == 0:             # no song learnt yet
	ld a, [wOcarinaSongFlags]
	and $07
	jr z, .noSong

;>@n1     wOcarinaSongState = 0xD0
;>@n2     hWaveSfx = 0x15
;> elif wSelectedSong == 1:                     # Manbo's Mambo
	ld a, [wSelectedSong]
	cp $01
	jr z, .mambo

;>@m1     wOcarinaSongState = 0xD0
;>@m2     hWaveSfx = 0x0B
;> elif wSelectedSong == 2:                     # Frog's Song of Soul
	cp $02
	jr z, .frog

;>@f1     wOcarinaSongState = 0xBB
;>@f2     hWaveSfx = 0x0A
;> else:                                        # Ballad of the Wind Fish
;>     wOcarinaSongState = 0xDC
	ld a, $dc
	ld [wOcarinaSongState], a
;>     hWaveSfx = 0x09
	ld a, $09
	ldh [hWaveSfx], a
	ret

.mambo
;=@m1
	ld a, $d0
	ld [wOcarinaSongState], a
;=@m2
	ld a, $0b
	ldh [hWaveSfx], a
	ret

.frog
;=@f1
	ld a, $bb
	ld [wOcarinaSongState], a
;=@f2
	ld a, $0a
	ldh [hWaveSfx], a
	ret

.noSong
;=@n1
	ld a, $d0
	ld [wOcarinaSongState], a
;=@n2
	ld a, $15
	ldh [hWaveSfx], a

.done
	ret

	ret                                         ; never reached

;@ path: item/hookshot
;@ Starting x speed of the hookshot chain per Link direction (0 right, 1 left, 2 up, 3 down), signed
;@ 1/16 pixel per frame: $30 = 3 pixels right, $D0 = 3 pixels left. Read by UseHookshot.
HookshotSpeedX::
	db $30, $d0, $00
	db $00

;@ path: item/hookshot
;@ Starting y speed of the hookshot chain per Link direction (0 right, 1 left, 2 up, 3 down), signed
;@ 1/16 pixel per frame ($D0 = up, $30 = down). Read by UseHookshot.
HookshotSpeedY::
	db $00, $00, $d0, $30

;@ def UseHookshot()
;@ path: item/hookshot
;@ The hookshot's button: unless Link is in the air, spawns the hookshot chain (Link's projectile type
;@ $03) in front of him and sends it off in his direction at 3 pixels per frame for $2A frames.
UseHookshot::
;> if wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
;>     return
	jr nz, .done

;> slot = Call_10EB(0x03)                       # spawn Link's projectile type 3 (carry = none free)
	ld a, $03
	call Call_10EB
;> if carry:
;>     return
	jr c, .done

;> wEntityTimer[slot] = 0x2A                    # how long it flies out
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $2a
;> wEntitySpriteVariant[slot] = 0
	ld hl, wEntitySpriteVariant
	add hl, de
	xor a
	ld [hl], a
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00
;> wEntitySpeedX[slot] = HookshotSpeedX[d]
	ld hl, HookshotSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[slot] = HookshotSpeedY[d]
	ld hl, HookshotSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

.done
;> return
	ret

;@ def LinkMotionInteractive()
;@ path: link/motion
;@ Link's normal motion state (wLinkMotionState 0, run every frame from bank 0): counts down the item
;@ timers, moves Link (walking, dashing, jumping, recoil), runs the sword and the items in use, then
;@ handles the sword charge: holding the swing button with the sword out (state 5) charges it, and
;@ releasing a full charge ($28 frames) starts the spin attack.
LinkMotionInteractive::
;> if wArrowCooldown:
	ld a, [wArrowCooldown]
	and a
	jr z, .squash

;>     wArrowCooldown -= 1
	dec a
	ld [wArrowCooldown], a

.squash
;> if wLinkJumpSquashTimer:
	ld a, [wLinkJumpSquashTimer]
	and a
	jr z, .bombArrow

;>     wLinkJumpSquashTimer -= 1
	dec a
	ld [wLinkJumpSquashTimer], a

.bombArrow
;> if wBombArrowWindow:
	ld a, [wBombArrowWindow]
	and a
	jr z, .move

;>     wBombArrowWindow -= 1
	dec a
	ld [wBombArrowWindow], a

.move
;> UpdateLinkMovement()                               # walking / dashing: speeds from the joypad
	call UpdateLinkMovement
;> if wSwordCooldown:
	ld a, [wSwordCooldown]
	and a
	jr z, .frozen

;>     wSwordCooldown -= 1
	dec a
	ld [wSwordCooldown], a

.frozen
;> if hLinkInteractiveMotionBlocked == 2:       # frozen by a cutscene
	ldh a, [hLinkInteractiveMotionBlocked]
	cp $02
	jr nz, .active

;>     hLinkInteractiveMotionBlocked = 0
	xor a
	ldh [hLinkInteractiveMotionBlocked], a
;>     hLinkSpeedX = 0
	ldh [hLinkSpeedX], a
;>     hLinkSpeedY = 0
	ldh [hLinkSpeedY], a
;>     hLinkSpeedZ = 0
	ldh [hLinkSpeedZ], a
;>     LinkPlayingOcarina()                           # the ocarina still plays
	call LinkPlayingOcarina
;>     return Jump_002_77fa()                   # ground check
	jp Jump_002_77fa


.active
;> UpdateLinkAnimationState()                                  # walking pose
	call UpdateLinkAnimationState
;> hLinkInteractiveMotionBlocked = 0
	xor a
	ldh [hLinkInteractiveMotionBlocked], a
;> Call_1E73()
	call Call_1E73
;> Call_0D68()                                  # use the items on A / B
	call Call_0D68
;> UpdateLinkInAir()                               # in the air: steering and landing
	call UpdateLinkInAir
;> UpdateItemUsePose()                               # item use pose
	call UpdateItemUsePose
;> UpdateSword()                               # sword swing
	call UpdateSword
;> UpdateDigging()                               # digging with the shovel
	call UpdateDigging
;> Call_149B()                                  # ground check, sword sprite
	call Call_149B
;> UpdateLiftPose()                               # carry pose
	call UpdateLiftPose
;> LinkPlayingOcarina()                               # playing the ocarina
	call LinkPlayingOcarina
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	jr nz, .done

;> wSwordAnimationStatePrev = wSwordAnimationState
	ld a, [wSwordAnimationState]
	ld [wSwordAnimationStatePrev], a
;> if wSwordAnimationState == 5:                # sword held out: charge it
	cp $05
	jr nz, .released

;>     if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .clearCharge

;>         wSwordAnimationState = 0             # set again next frame while the button is held
	xor a
	ld [wSwordAnimationState], a
;>         if wSwordCharge != 0x28:
	ld a, [wSwordCharge]
	cp $28
	jr z, .done

;>             wSwordCharge += 1
	inc a
	ld [wSwordCharge], a
;>             if wSwordCharge == 0x28:
	cp $28
	jr nz, .done

;>                 hJingle = 0x04               # fully charged
	ld a, $04
	ldh [hJingle], a

.done
;>         return
	ret


.released
;> elif wCanTalkToEntity != 1 and wSwordCharge == 0x28:   # released a full charge
	ld a, [wCanTalkToEntity]
	cp $01
	jr z, .clearCharge

	ld a, [wSwordCharge]
	cp $28
	jr nz, .clearCharge

;>     if wSwordCooldown:
	ld a, [wSwordCooldown]
	and a
;>         return
	jr nz, .keep

;>     wSpinAttackTimer = 0x20
	ld a, $20
	ld [wSpinAttackTimer], a
;>     hNoiseSfx = 0x03
	ld a, $03
	ldh [hNoiseSfx], a

.clearCharge
;> wSwordCharge = 0
	xor a
	ld [wSwordCharge], a

.keep
	ret


;@ def UpdateLiftPose()
;@ path: link/carry
;@ While Link is lifting an object, wIsCarryingLiftedObject holds the lifting pose (2 and up): show it
;@ and keep him from walking this frame.
UpdateLiftPose::
;> if wIsCarryingLiftedObject >= 2:
	ld a, [wIsCarryingLiftedObject]
	cp $02
	jr c, .done

;>     hLinkAnimationState = wIsCarryingLiftedObject
	ldh [hLinkAnimationState], a
;>     hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a

.done
	ret


;@ path: link/items
;@ Link's pose while he uses an item (throwing, swinging the magic rod, ...), one pose number per
;@ direction (0 right, 1 left, 2 up, 3 down). Read by UpdateItemUsePose.
ItemUsePoses::
	db $11, $10, $0f, $0e

;@ def UpdateItemUsePose()
;@ path: link/items
;@ Counts down wItemUsePoseTimer and shows Link's item-use pose for his direction while it runs; at 0
;@ the timer (with its magic-rod bit) is cleared.
;@ test: hLinkDirection = rand(0, 3)
UpdateItemUsePose::
;> if wItemUsePoseTimer & 0x7F:
	ld a, [wItemUsePoseTimer]
	and $7f
	jr z, .clear

;>     wItemUsePoseTimer -= 1
	ld a, [wItemUsePoseTimer]
	dec a
	ld [wItemUsePoseTimer], a
	and $7f
;>     d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;>     hLinkAnimationState = ItemUsePoses[d]
	ld hl, ItemUsePoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;>     return
	ret


.clear
;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
	ret


;@ def UpdateLinkMovement()
;@ path: link/walk
;@ Moves Link on foot: side-view rooms have their own routine; otherwise the recoil after a hit takes
;@ over, a dash with the Pegasus Boots keeps going (turning away stops it), and walking takes the speed
;@ from the joypad (faster with a Piece of Power, twice as fast in the free-movement mode). Sinking sand,
;@ water, ripples and carrying the rooster make Link move only on some frames. Then the walls of the
;@ room are checked.
;@ test: skip pops the caller's return address (recoil)
UpdateLinkMovement::
;> if hIsSideScrolling and not wDebugToggle:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .topView

	ld a, [wDebugToggle]
	and a
	jr nz, .topView

;>     return Call_02_6BEF()                    # side-view movement
	call Call_02_6BEF
	ret


.topView
;> wMinimapLinkCell = wIndoorRoom
;> dashing = False
	ld a, [wIndoorRoom]
	ld [wMinimapLinkCell], a
;> UpdateLinkRecoil()                               # recoil: while it runs, this routine ends there
;> mask = None                                  # frames on which Link moves (None: not decided yet)
	call UpdateLinkRecoil
;> if hLinkPositionZ == 0 and hLinkInteractiveMotionBlocked:
;>     mask = 0x80                              # no move this frame; only the walls are checked
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .controls

	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jp nz, Jump_002_445c

.controls
;> else:
;>     if wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .walk

;>         pressed = hJoypadPressed & 0x0F
	ldh a, [hJoypadPressed]
	and $0f
;>         turned = pressed != 0
	jr z, .dash

;>         if turned:
;>             turned = JoypadToDirection[pressed] != hLinkDirection
	ld e, a
	ld d, $00
	ld hl, JoypadToDirection
	add hl, de
	ldh a, [hLinkDirection]
	cp [hl]
;>         if not turned:                       # keep dashing
	jr nz, .turn

.dash
;>             wLinkWalkingFrameCount += 2
	ld a, [wLinkWalkingFrameCount]
	add $02
	ld [wLinkWalkingFrameCount], a
;>             Call_145D()                      # dust / splash under the feet
	call Call_145D
;>             dashing = True
	jr jr_002_440a

.turn
;>         else:                                # pressed another direction: the dash stops
;>             wPegasusTurnButtons = pressed
	ld [wPegasusTurnButtons], a
;>             wPegasusDustTimer += 0x0C
	ld a, [wPegasusDustTimer]
	add $0c
	ld [wPegasusDustTimer], a
;>             ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash

.walk
;>     if not dashing and not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_002_440a

;>         e = 0x10 if wActivePowerUp == 1 else 0    # Piece of Power: second half of the tables
	ld e, $00
	ld a, [wActivePowerUp]
	cp $01
	jr nz, .speeds

	ld e, $10

.speeds
;>         e |= hJoypadHeld & 0x0F
	ldh a, [hJoypadHeld]
	and $0f
	or e
	ld e, a
	ld d, $00
;>         hLinkSpeedX = WalkSpeedX[e]
	ld hl, WalkSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>         hLinkSpeedY = WalkSpeedY[e]
	ld hl, WalkSpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;>         if wDebugToggle:                     # free movement: twice as fast
	ld a, [wDebugToggle]
	and a
	jr z, .facing

;>             hLinkSpeedX *= 2
	ld hl, hLinkSpeedX
	sla [hl]
;>             hLinkSpeedY *= 2
	ld hl, hLinkSpeedY
	sla [hl]

.facing
;>         e &= 0x0F
	ld a, e
	and $0f
	ld e, a
;>         if e:
	jr z, .standing

;>             wLinkWalkingFrameCount += 1
	ld hl, wLinkWalkingFrameCount
	inc [hl]
;>             d = JoypadToDirection[e]
	ld hl, JoypadToDirection
	add hl, de
	ld a, [hl]
;>             if d != 0x0F:                    # $0F: opposite buttons pressed
	cp $0f
	jr z, jr_002_440a

;>                 if not wSwordCooldown:       # no turning during a swing
	ld e, a
	ld a, [wSwordCooldown]
	and a
	ld a, e
	jr nz, .facingDone

;>                     hLinkDirection = d
	ldh [hLinkDirection], a

.facingDone
	jr jr_002_440a

.standing
;>         elif not wPegasusBootsChargeMeter:
	ld a, [wPegasusBootsChargeMeter]
	and a
	jr nz, jr_002_440a

;>             wLinkWalkingFrameCount = 7           # standing pose
	ld a, $07
	ld [wLinkWalkingFrameCount], a

jr_002_440a:
;> if mask is None:
;>     mask = 3
	ld e, $03
;>     if not wLinkSlowAnimation:
	ld a, [wLinkSlowAnimation]
	and a
	jr nz, .throttle

;>         mask = 1
	ld e, $01
;>         rooster = wIsCarryingLiftedObject and wCarriedEntityType == 0xD5
	ld a, [wIsCarryingLiftedObject]
	and a
	jr z, .notRooster

	ld a, [wCarriedEntityType]
	cp $d5
	jr nz, .notRooster

;>         if not (rooster and wIsLinkInTheAir) and not hLinkInWater:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .throttle

.notRooster
	ldh a, [hLinkInWater]
	and a
	jr nz, .throttle

;>             vfx = wLinkGroundVfx
	ld hl, wLinkGroundVfx
	ld a, [hl]
;>             if vfx == 0:
;>                 mask = 0
	and a
	jr z, MoveLinkAndCollide

;>             elif vfx != 7:                   # ripples: move only when frame & vfx is nonzero
	cp $07
	jr nz, .ripple

;>@rip                 if (hFrameCounter & vfx) == 0:
;>@ripret                     return
;>                 mask = 0
;>             elif wDebugToggle:
	ld a, [wDebugToggle]
	and a
;>                 mask = 0
	jr nz, MoveLinkAndCollide

;>             else:                            # sinking sand: slower after $18 frames
;>                 mask = 1 if wSinkingSandCounter < 0x18 else 7
	ld e, $01
	ld a, [wSinkingSandCounter]
	cp $18
	jr c, .throttle

	ld e, $07

.throttle
;> if (mask & 0x80) == 0 and (hFrameCounter & mask) == 0:
	ldh a, [hFrameCounter]
	and e
	jr nz, Jump_002_445c

	jr MoveLinkAndCollide

.ripple
;=@rip
	ldh a, [hFrameCounter]
	and [hl]
;=@ripret
	jr z, jr_002_4469

MoveLinkAndCollide:
;>     if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>         return
	ret nz

;>     ApplyLinkSpeed()
	call ApplyLinkSpeed

Jump_002_445c:
;> wLinkGroundVfxPrev = wLinkGroundVfx
	ld a, [wLinkGroundVfx]
	ld [wLinkGroundVfxPrev], a
;> wLinkGroundVfx = 0
	xor a
	ld [wLinkGroundVfx], a
;> Call_02_6FB1()                               # walls, room edges
	call Call_02_6FB1

jr_002_4469:
	ret


;@ def UpdateLinkRecoil()
;@ path: link/damage
;@ While Link is thrown back (wLinkPushedTimer), moves him with his recoil speed and checks the walls;
;@ against a wall the speed along the other axis is dropped. Then it draws him and returns from the
;@ caller as well (the normal movement is skipped).
;@ test: skip pops the caller's return address
UpdateLinkRecoil::
;> if wLinkPushedTimer:
	ld a, [wLinkPushedTimer]
	and a
	jr z, .done

;>     wLinkPushedTimer -= 1
	dec a
	ld [wLinkPushedTimer], a
;>     ApplyLinkSpeed()
	call ApplyLinkSpeed
;>     Call_02_6FB1()
	call Call_02_6FB1
;>     if wLinkCollisionFlags:
	ld a, [wLinkCollisionFlags]
	and a
	jr z, .draw

;>         if wLinkCollisionFlags & 3:
	and $03
	jr z, .vertical

;>             hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
	jr .draw

.vertical
;>         else:
;>             hLinkSpeedX = 0
	xor a
	ldh [hLinkSpeedX], a

.draw
;>     drop_caller_frame()                      # the caller (UpdateLinkMovement) ends here too
	pop af
;>     Call_149B()
	call Call_149B

.done
	ret


;@ path: link/jump
;@ Target y speed while Link steers a jump, by the up/down buttons ((hJoypadHeld >> 2) & 3: 0 none,
;@ 1 up, 2 down, 3 both): signed 1/16 pixel per frame ($F0 = 1 pixel up, $10 = 1 down). The two last
;@ bytes ($FF, $01) are not read. Read by UpdateLinkInAir; the x speeds come from SideViewSpeedX.
AirSteerSpeedY::
	db $00, $f0, $10, $00, $ff, $01

;@ def UpdateLinkInAir()
;@ path: link/jump
;@ While Link is in the air on a top-view screen: moves his height with gravity (2 per frame), lets him
;@ steer (the speeds move one step per frame toward the target of the held buttons; not while jumping
;@ down a ledge or dashing), and on landing resets the jump, checks the ground and makes the landing
;@ sound (a splash in shallow water, nothing in deep water or sinking sand).
UpdateLinkInAir::
;> if not wIsLinkInTheAir or hIsSideScrolling:
	ld a, [wIsLinkInTheAir]
	and a
	jp z, LinkFallWithGravity.done

	ldh a, [hIsSideScrolling]
	and a
;>     return
	jp nz, LinkFallWithGravity.done

LinkFallWithGravity:
;> ApplyLinkSpeedZ()                            # (LinkFallWithGravity: entry used by the ledge jump)
	call ApplyLinkSpeedZ

;> hLinkSpeedZ -= 2                             # gravity
	ldh a, [hLinkSpeedZ]
	sub $02
	ldh [hLinkSpeedZ], a
;> wLinkWalkingFrameCount = 0xFF
	ld a, $ff
	ld [wLinkWalkingFrameCount], a
;> if not wIsJumpingDownLedge and not wIsUsingPegasusBoots:
	ld a, [wIsJumpingDownLedge]
	ld hl, wIsUsingPegasusBoots
	or [hl]
	jr nz, .height

;>     if wIsSpinningInHole or wCanTalkToEntity == 0x80:
	ld a, [wIsSpinningInHole]
	and a
	jr nz, .stop

	ld a, [wCanTalkToEntity]
	cp $80
	jr nz, .steer

.stop
;>         Call_1495()                          # no steering: speeds 0
	call Call_1495
	jr .height

.steer
;>     else:
;>         if hJoypadHeld & 3:
	ldh a, [hJoypadHeld]
	and $03
	jr z, .steerY

;>             diff = hLinkSpeedX - SideViewSpeedX[hJoypadHeld & 3]
	ld e, a
	ld d, $00
	ld hl, SideViewSpeedX
	add hl, de
	ldh a, [hLinkSpeedX]
	sub [hl]
;>             if diff:
	jr z, .steerY

;>                 step = 1 if diff & 0x80 else -1   # one step toward the target
	ld e, $01
	bit 7, a
	jr nz, .addX

	ld e, $ff

.addX
;>                 hLinkSpeedX += step
	ldh a, [hLinkSpeedX]
	add e
	ldh [hLinkSpeedX], a

.steerY
;>         if (hJoypadHeld >> 2) & 3:
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
	jr z, .height

;>             diff = hLinkSpeedY - AirSteerSpeedY[(hJoypadHeld >> 2) & 3]
	ld e, a
	ld d, $00
	ld hl, AirSteerSpeedY
	add hl, de
	ldh a, [hLinkSpeedY]
	sub [hl]
;>             if diff:
	jr z, .height

;>                 step = 1 if diff & 0x80 else -1
	ld e, $01
	bit 7, a
	jr nz, .addY

	ld e, $ff

.addY
;>                 hLinkSpeedY += step
	ldh a, [hLinkSpeedY]
	add e
	ldh [hLinkSpeedY], a

.height
;> if hLinkPositionZ != 0 and (hLinkPositionZ & 0x80) == 0:   # still above the ground
	ldh a, [hLinkPositionZ]
	and a
	jr z, .landed

	and $80
;>     return
	jr z, .done

.landed
;> ResetPegasusBoots()                                  # stop the boots dash
	call ResetPegasusBoots
;> hLinkPositionZ = 0
	ldh [hLinkPositionZ], a
;> wLinkSubpixelZ = 0
	ld [wLinkSubpixelZ], a
;> hLinkSpeedZ = 0
	ldh [hLinkSpeedZ], a
;> wIsLinkInTheAir = 0
	ld [wIsLinkInTheAir], a
;> wJumpAnimationFrame = 0
	ld [wJumpAnimationFrame], a
;> wJumpAnimationCounter = 0
	ld [wJumpAnimationCounter], a
;> wIsJumpingDownLedge = 0
	ld [wIsJumpingDownLedge], a
;> if hLinkY >= 0x88:                           # off the bottom of the play area
	ldh a, [hLinkY]
	cp $88
;>     return
	jr nc, .done

;> Call_02_787D()                               # check the ground he lands on
	call Call_02_787D
;> if hObjectUnderLink == 0x61:
	ldh a, [hObjectUnderLink]
	cp $61
;>     return
	jr z, .done

;> if wLinkGroundType == 5:                     # shallow water: splash
	ld a, [wLinkGroundType]
	cp $05
	jr z, .splash

;>@spl1     hMultiPurpose1 = hLinkY
;>@spl2     hMultiPurpose0 = hLinkX
;>@spl3     hJingle = 0x0E
;>@spl4     AddTransientVfx(0x0C)                      # splash effect at Link's feet
;> elif wLinkGroundType in (0x07, 0x0B):        # deep water: no sound
;>     return
	cp $07
	jr z, .done

	cp $0b
	jr z, .done

;> elif wLinkGroundType in (0x50, 0x51):        # sinking sand: no sound
;>     return
	cp $50
	jr z, .done

	cp $51
	jr z, .done

;> else:
;>     hNoiseSfx = 0x07                         # landing thud
	ld a, $07
	ldh [hNoiseSfx], a

.done
	ret


.splash
;=@spl1
	ldh a, [hLinkY]
	ldh [hMultiPurpose1], a
;=@spl2
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;=@spl3
	ld a, $0e
	ldh [hJingle], a
;=@spl4
	ld a, $0c
	call AddTransientVfx
	ret


;@ path: link/sword
;@ Sword tables, all 24 bytes: index = direction * 6 + sword state (direction 0 right, 1 left, 2 up,
;@ 3 down; state = wSwordAnimationState: 0 none, 1 raised behind, 2 diagonal, 3 straight out, 4 end of
;@ the swing, 5 held out while charging). Read by UpdateSwordPose.
;@ SwordHitboxDX: x offset of the sword hitbox centre, added to wSwordSpriteDX + hLinkX; 0 = this state
;@ has no hitbox (the sword cannot hit anything).
SwordHitboxDX::
	db $00, $00, $08, $06, $00, $06, $00, $00, $08, $0a, $00, $0a, $00, $00, $08, $10
	db $00, $10, $00, $00, $08, $08, $00, $08

;@ path: link/sword
;@ Half width (pixels) of the sword hitbox per direction * 6 + state (see SwordHitboxDX).
SwordHitboxWidth::
	db $00, $00, $05, $0a, $00, $0a, $00, $00
	db $05, $0a, $00, $0a, $00, $00, $05, $08, $00, $08, $00, $00, $05, $08, $00, $08
;@ path: link/sword
;@ Y offset of the sword hitbox centre per direction * 6 + state, added to wSwordSpriteDY + wLinkDrawY.
SwordHitboxDY::
	db $00, $00, $08, $08, $00, $08, $00, $00, $08, $08, $00, $08, $00, $00, $08, $08
	db $00, $08, $00, $00, $08, $08, $00, $08

;@ path: link/sword
;@ Half height (pixels) of the sword hitbox per direction * 6 + state.
SwordHitboxHeight::
	db $00, $00, $05, $08, $00, $08, $00, $00
	db $05, $08, $00, $08, $00, $00, $05, $08, $00, $08, $00, $00, $05, $08, $00, $08
;@ path: link/sword
;@ Sword sprite frame (0-7, stored in wSwordSpriteFrame and drawn by bank 0) per direction * 6 + state.
SwordSpriteFrames::
	db $00, $06, $07, $00, $01, $00, $00, $06, $05, $04, $03, $04, $00, $00, $07, $06
	db $05, $06, $00, $04, $03, $02, $01, $02

;@ path: link/sword
;@ Link's pose (hLinkAnimationState) during the swing per direction * 6 + state; $FF = keep the pose
;@ (state 5, sword held out while walking). Poses $0E-$19 are the sword poses.
SwordLinkPoses::
	db $00, $18, $19, $11, $11, $ff, $00, $16
	db $17, $10, $10, $ff, $00, $14, $15, $0f, $0f, $ff, $00, $12, $13, $0e, $0e, $ff
;@ path: link/sword
;@ X offset (signed pixels) of the sword sprite from Link per direction * 6 + state.
SwordSpriteDX::
	db $00, $00, $0d, $13, $10, $0b, $00, $f8, $f3, $ed, $f0, $f5, $00, $10, $0d, $f8
	db $f5, $f8, $00, $f0, $f3, $00, $0c, $00

;@ path: link/sword
;@ Y offset (signed pixels) of the sword sprite from Link per direction * 6 + state.
SwordSpriteDY::
	db $00, $f0, $f3, $00, $0c, $00, $00, $f0
	db $f3, $00, $0c, $00, $00, $f8, $f3, $f0, $f3, $f5, $00, $00, $0d, $10, $0d, $0d
;@ path: link/sword
;@ X offset (signed pixels) of Link's own sprite during the swing (he lunges 3 pixels forward in states
;@ 3-4) per direction * 6 + state; stored in wLinkSpriteDX.
SwordLinkDX::
	db $00, $00, $00, $03, $03, $00, $00, $00, $00, $fd, $fd, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00

;@ path: link/sword
;@ Y offset (signed pixels) of Link's own sprite during the swing per direction * 6 + state; stored in
;@ wLinkSpriteDY.
SwordLinkDY::
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $fd, $fd, $00, $00, $00, $00, $03, $03, $00
;@ path: link/sword
;@ Frames each swing state lasts, index = state - 1: state 1 3 frames (set where the swing starts),
;@ state 2 3 frames, state 3 8 frames; the last four bytes are not used. Read by UpdateSword when the
;@ swing moves to the next state.
SwordStateDurations::
	db $03, $03, $08, $01, $01, $01, $01

;@ path: link/jump
;@ Link's poses while jumping with the feather, index = direction * 4 + frame (0-2, wJumpAnimationFrame;
;@ the 4th byte is unused): right $61-$63, left $5E-$60, up $67-$69, down $64-$66. Read by UpdateSword.
JumpPoses::
	db $61, $62, $63, $00, $5e, $5f, $60, $00, $67
	db $68, $69, $00, $64, $65, $66, $00

;@ path: link/fall
;@ Directions Link faces in turn while he spins down a hole to the floor below, index = (frame >> 2) & 3:
;@ right, down, left, up. Read by UpdateSword.
SpinFallDirections::
	db $00, $03, $01, $02

;@ path: link/sword
;@ Sword state (2 diagonal, 3 straight, 4 end) shown during the spin attack, index = direction * 8 +
;@ (wSpinAttackTimer >> 2), the timer running down from $1F: the sword sweeps around Link. Read by
;@ UpdateSpinAttack.
SpinAttackSwordStates::
	db $03, $02, $03, $02, $03
	db $02, $03, $04, $03, $04, $03, $02, $03, $04, $03, $04, $03, $02, $03, $04, $03
	db $04, $03, $04, $03, $04, $03, $04, $03, $02, $03, $04

;@ path: link/sword
;@ Direction the sword points at during the spin attack, same index as SpinAttackSwordStates (0 right,
;@ 1 left, 2 up, 3 down). Read by UpdateSpinAttack.
SpinAttackDirections::
	db $00, $02, $02, $01, $01
	db $03, $03, $00, $01, $02, $02, $00, $00, $03, $03, $01, $02, $00, $00, $03, $03
	db $01, $01, $02, $03, $01, $01, $02, $02, $00, $00, $03

;@ def UpdateSpinAttack(timer: a)
;@ path: link/sword
;@ One frame of the spin attack (entered from UpdateSword with wSpinAttackTimer in a): the sword sweeps
;@ once around Link, its pose taken from SpinAttackSwordStates / SpinAttackDirections; the timer runs
;@ down a little faster every 4th frame. Meanwhile the hitbox is a square of 24 pixels around Link.
UpdateSpinAttack::
;> wSpinAttackTimer = timer - 1
	dec a
	ld [wSpinAttackTimer], a
;> hLinkInteractiveMotionBlocked = 1
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
;>@i i = hLinkDirection * 8 + (wSpinAttackTimer >> 2)
	srl a
	srl a
	ld e, a
	ld d, $00
	ldh a, [hLinkDirection]
	sla a
;=@i
	sla a
	sla a
	add e
	ld e, a
;> wSwordAnimationState = SpinAttackSwordStates[i]
	ld hl, SpinAttackSwordStates
	add hl, de
	ld a, [hl]
	ld [wSwordAnimationState], a
;> facing = hLinkDirection
	ld hl, SpinAttackDirections
	add hl, de
	ldh a, [hLinkDirection]
	push af
;> hLinkDirection = SpinAttackDirections[i]   # pose the sword in that direction
	ld a, [hl]
	ldh [hLinkDirection], a
;> UpdateSwordPose()
	call UpdateSwordPose
;> hLinkDirection = facing
	pop af
	ldh [hLinkDirection], a
;> if (hFrameCounter & 3) == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .check

;>     wSpinAttackTimer -= 1
	ld hl, wSpinAttackTimer
	dec [hl]

.check
;> if wSpinAttackTimer == 0 or wSpinAttackTimer & 0x80:
	ld a, [wSpinAttackTimer]
	and a
	jp z, EndSwordAction

	rla
;>     return EndSwordAction()                    # spin over
	jp c, EndSwordAction

;> wSwordHitboxX = hLinkX + 8
	ldh a, [hLinkX]
	add $08
	ld [wSwordHitboxX], a
;> wSwordHitboxWidth = 0x18
	ld a, $18
	ld [wSwordHitboxWidth], a
;> wSwordHitboxHeight = 0x18
	ld [wSwordHitboxHeight], a
;> wSwordHitboxY = wLinkDrawY + 8
	ld a, [wLinkDrawY]
	add $08
	ld [wSwordHitboxY], a
;> wSwordCollisionEnabled = wSwordHitboxY      # nonzero
	ld [wSwordCollisionEnabled], a
	ret


;@ def UpdateSwordPoke(timer: a)
;@ path: link/sword
;@ One frame of the poke of the held-out sword against a wall (entered from UpdateSword with
;@ wSwordPokeTimer in a): the sword is shown straight out (state 3) until the timer ends.
UpdateSwordPoke::
;> wSwordPokeTimer = timer - 1
	dec a
	ld [wSwordPokeTimer], a
;> if wSwordPokeTimer == 0:
;>     return EndSwordAction()
	jp z, EndSwordAction

;> wSwordCooldown = 4
	ld hl, wSwordCooldown
	ld [hl], $04
;> if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .pose

;>     hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a

.pose
;> wSwordAnimationState = 3
	ld a, $03
	ld [wSwordAnimationState], a
;> return UpdateSwordPose()
	jp UpdateSwordPose


;@ def SwordHeldOutPose()
;@ path: link/sword
;@ Sword states 5 and up (held out): only the pose and offsets are set (UpdateSword jumps here).
SwordHeldOutPose::
;> UpdateSwordPose()
	call UpdateSwordPose

jr_002_4737:
	ret


;@ def UpdateSword()
;@ path: link/sword
;@ Runs every frame of the normal motion: spins Link while he falls down a hole, animates the feather
;@ jump, and advances the sword: the spin attack, the poke against a wall, or the swing (states 1-3 with
;@ the frame counts of SwordStateDurations, the swing ending when state 4 is reached). While a swing
;@ runs Link cannot walk (except when dashing) and does not turn.
UpdateSword::
;> if wIsSpinningInHole:
	ld a, [wIsSpinningInHole]
	and a
	jr z, .jump

;>@spin     hLinkDirection = SpinFallDirections[(hFrameCounter >> 2) & 3]
	ldh a, [hFrameCounter]
	rra
	rra
	and $03
	ld e, a
	ld d, $00
;=@spin
	ld hl, SpinFallDirections
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a
;>     return
	ret


.jump
;> if wIsLinkInTheAir == 1:                     # feather jump
	ld a, [wIsLinkInTheAir]
	cp $01
	jr nz, .sword

;>   if not wLinkIsCarrying and not wSwordAnimationState:
	ld a, [wLinkIsCarrying]

	ld hl, wSwordAnimationState
	or [hl]
	jr nz, .sword

;>     row = hLinkDirection * 4
	ldh a, [hLinkDirection]
	rla
	rla
	and $0c
	ld c, a
	ld b, $00
;>     if wJumpAnimationFrame < 3:
	ld a, [wJumpAnimationFrame]
	cp $03
	jr nc, .sword

;>@jp         hLinkAnimationState = JumpPoses[row + wJumpAnimationFrame]
	ld e, a
	ld d, $00
	ld hl, JumpPoses
	add hl, de
	add hl, bc
	ld a, [hl]
;=@jp
	ldh [hLinkAnimationState], a
;>         wJumpAnimationCounter += 1
	ld a, [wJumpAnimationCounter]
	inc a
	ld [wJumpAnimationCounter], a
;>         if (wJumpAnimationCounter & 7) == 0:  # next frame every 8 frames
	and $07
	jr nz, .sword

;>             wJumpAnimationFrame += 1
	ld a, [wJumpAnimationFrame]
	inc a
	ld [wJumpAnimationFrame], a

.sword
;> if wSpinAttackTimer:
	ld a, [wSpinAttackTimer]
	and a
;>     return UpdateSpinAttack(wSpinAttackTimer)
	jp nz, UpdateSpinAttack

;> if wSwordPokeTimer:
	ld a, [wSwordPokeTimer]
	and a
;>     return UpdateSwordPoke(wSwordPokeTimer)
	jp nz, UpdateSwordPoke

;> if wSwordAnimationState == 0:
	ld a, [wSwordAnimationState]
	and a
;>     return
	jr z, jr_002_4737

;> wSwordCooldown = 4
	ld hl, wSwordCooldown
	ld [hl], $04
;> if wSwordAnimationState >= 5:
	ld a, [wSwordAnimationState]
	cp $05
;>     return SwordHeldOutPose()
	jr nc, SwordHeldOutPose

;> if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .timer

;>     hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a

.timer
;> if wSwordStateTimer == 0:                    # next state of the swing
	ld a, [wSwordStateTimer]
	and a
	jr nz, .countDown

;>     wSwordAnimationState += 1
	ld a, [wSwordAnimationState]
	inc a
	ld [wSwordAnimationState], a
;>     if wSwordAnimationState == 4:
	cp $04
;>         return EndSwordAction()                # swing over
	jp z, EndSwordAction

;>     wSwordStateTimer = SwordStateDurations[wSwordAnimationState - 1]
	ld c, a
	ld b, $00
	ld hl, SwordStateDurations - 1
	add hl, bc
	ld a, [hl]

.countDown
;> wSwordStateTimer -= 1
	dec a
	ld [wSwordStateTimer], a
;> UpdateSwordPose()                               # (falls through into it)

;@ def UpdateSwordPose()
;@ path: link/sword
;@ Sets everything that depends on Link's direction and the sword state (index direction * 6 + state):
;@ the sword sprite frame and offsets, Link's pose and sprite offsets, and the sword hitbox (none in
;@ some states; with the shield up only on every other frame). Then the sword hits the room's objects.
;@ test: hLinkDirection = rand(0, 3); wSwordAnimationState = rand(0, 5)
UpdateSwordPose::
;>@i6 i = hLinkDirection * 6 + wSwordAnimationState
	ld hl, wSwordAnimationState
	ldh a, [hLinkDirection]
	ld e, a
	sla a
	sla a
	add e
;=@i6
	add e
	add [hl]
	ld c, a
	ld b, $00
;> wSwordSpriteFrame = SwordSpriteFrames[i]
	ld hl, SwordSpriteFrames
	add hl, bc
	ld a, [hl]
	ld [wSwordSpriteFrame], a
;> if SwordLinkPoses[i] != 0xFF:
	ld hl, SwordLinkPoses
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, .offsets

;>     hLinkAnimationState = SwordLinkPoses[i]
	ldh [hLinkAnimationState], a

.offsets
;> wSwordSpriteDX = SwordSpriteDX[i]
	ld hl, SwordSpriteDX
	add hl, bc
	ld a, [hl]
	ld [wSwordSpriteDX], a
;> wSwordSpriteDY = SwordSpriteDY[i]
	ld hl, SwordSpriteDY
	add hl, bc
	ld a, [hl]
	ld [wSwordSpriteDY], a
;> wLinkSpriteDX = SwordLinkDX[i]
	ld hl, SwordLinkDX
	add hl, bc
	ld a, [hl]
	ld [wLinkSpriteDX], a
;> wLinkSpriteDY = SwordLinkDY[i]
	ld hl, SwordLinkDY
	add hl, bc
	ld a, [hl]
	ld [wLinkSpriteDY], a
;>@hb if SwordHitboxDX[i] and (not wIsUsingShield or (hFrameCounter & 1) == 0):
	ld hl, SwordHitboxDX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .rooms

	ld a, [wIsUsingShield]
;=@hb
	and a
	jr z, .hitbox

	ldh a, [hFrameCounter]
	and $01
	jr nz, .rooms

.hitbox
;>     wSwordHitboxX = wSwordSpriteDX + SwordHitboxDX[i] + hLinkX
	ld a, [wSwordSpriteDX]
	add [hl]
	ld hl, hLinkX
	add [hl]
	ld [wSwordHitboxX], a
;>     wSwordHitboxWidth = SwordHitboxWidth[i]
	ld hl, SwordHitboxWidth
	add hl, bc
	ld a, [hl]
	ld [wSwordHitboxWidth], a
;>@hy     wSwordHitboxY = wSwordSpriteDY + SwordHitboxDY[i] + wLinkDrawY
	ld a, [wSwordSpriteDY]
	ld hl, SwordHitboxDY
	add hl, bc
	add [hl]
	ld hl, wLinkDrawY
	add [hl]
;=@hy
	ld [wSwordHitboxY], a
;>     wSwordHitboxHeight = SwordHitboxHeight[i]
	ld hl, SwordHitboxHeight
	add hl, bc
	ld a, [hl]
	ld [wSwordHitboxHeight], a
;>     wSwordCollisionEnabled = 1
	ld a, $01
	ld [wSwordCollisionEnabled], a

.rooms
;> Call_12AE()                                  # the sword cuts / hits the room's objects
	call Call_12AE
	ret


;@ def EndSwordAction()
;@ path: link/sword
;@ Ends the swing, spin or poke: clears the sword state (kept while dashing, where the sword stays out).
EndSwordAction::
;> wSwordDirectionLocked = 0
	xor a
	ld [wSwordDirectionLocked], a
;> if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .done

;>     wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;>     wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;>     wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a

.done
	ret


;@ path: link/walk
;@ Link's walking speed, 32 bytes: index = (16 with a Piece of Power, else 0) + (hJoypadHeld & $0F)
;@ (bit 0 right, 1 left, 2 up, 3 down). WalkSpeedX holds the x speed, signed 1/16 pixel per frame:
;@ straight $10 (1 pixel per frame), diagonal $0C; with the power-up $14 / $0F. Opposite buttons give 0.
;@ Read by UpdateLinkMovement.
WalkSpeedX::
	db $00, $10, $f0, $00, $00, $0c, $f4, $00, $00, $0c, $f4, $00, $00, $00, $00, $00
	db $00, $14, $ec, $00, $00, $0f, $f1, $00, $00, $0f, $f1, $00, $00, $00, $00, $00
;@ path: link/walk
;@ Link's walking y speed, same index and units as WalkSpeedX (negative = up).
WalkSpeedY::
	db $00, $00, $00, $00, $f0, $f4, $f4, $00, $10, $0c, $0c, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $ec, $f1, $f1, $00, $14, $0f, $0f, $00, $00, $00, $00, $00
;@ path: link/walk
;@ Facing direction for each combination of held direction buttons (index = hJoypadHeld & $0F, entries
;@ 0-10): 0 right, 1 left, 2 up, 3 down; $0F = keep the current direction (no button, opposite buttons,
;@ and the diagonals, where Link keeps the way he faced). Read by UpdateLinkMovement and the swimming
;@ and dashing code.
JoypadToDirection::
	db $0f, $00, $01, $0f, $02, $0f, $0f, $0f, $03, $0f, $0f

;@ path: link/animation
;@ Link's walking poses, 8 bytes: index = direction * 2 + walk frame (bit 3 of wLinkWalkingFrameCount);
;@ the values are hLinkAnimationState pose numbers. Read by bank 0's UpdateLinkAnimationState, which
;@ picks this table or one of the following ones.
LinkWalkPoses::
	db $0a, $0b, $06, $07, $04
	db $05, $00, $01

;@ path: link/animation
;@ Walking poses with the shield (wShieldLevelEquipped 1), 16 bytes: the first 8 with the shield down,
;@ the next 8 while it is held up (wIsUsingShield); index = direction * 2 + walk frame.
LinkShieldWalkPoses::
	db $2c, $2d, $06, $07, $34, $35, $22, $23, $2a, $2b, $28, $29, $30
	db $31, $24, $25

;@ path: link/animation
;@ Walking poses with the mirror shield (wShieldLevelEquipped 2), same layout as LinkShieldWalkPoses.
LinkMirrorShieldWalkPoses::
	db $2e, $2f, $06, $07, $34, $35, $22, $23, $2a, $2b, $28, $29, $32
	db $33, $26, $27

;@ path: link/animation
;@ Poses while Link pushes against a wall or block (wLinkPushingTimer), index = direction * 2 + frame.
LinkPushPoses::
	db $20, $21, $1e, $1f, $1c, $1d, $1a, $1b

;@ path: link/animation
;@ Poses while Link walks carrying an object over his head, index = direction * 2 + frame.
LinkCarryPoses::
	db $3e, $3f, $40, $41, $42
	db $43, $44, $45

;@ path: link/animation
;@ Swimming poses (motion state 1), index = direction * 2 + frame.
LinkSwimPoses::
	db $46, $47, $48, $49, $4a, $4b, $4c, $4d

;@ path: link/animation
;@ Poses while diving under water (motion state 1 with hLinkMotionStep set): the same two poses in
;@ every direction.
LinkDivePoses::
	db $4e, $4f, $4e, $4f, $4e
	db $4f, $4e, $4f

;@ path: link/animation
;@ Poses in the water of a side-view room (hLinkMotionStep 2), index = direction * 2 + frame.
LinkSideViewWaterPoses::
	db $5b, $5c, $58, $59, $5b, $5c, $58, $59

;@ def LinkMotionJumping()
;@ path: link/jump
;@ Link's motion state 2: jumping down a ledge. On the first frame Link is moved down 16 pixels and as
;@ many higher (he stays where he is on screen), then 8 more at a time while he is still over a ledge or
;@ against a wall, and 3 pixels back up. After that he falls with gravity until he lands and the normal
;@ motion takes over; items and the sword keep working meanwhile.
LinkMotionJumping::
;> wLinkJumpSquashTimer = 2
	ld a, $02
	ld [wLinkJumpSquashTimer], a
;> if hLinkMotionStep == 0:                     # first frame: find the landing place
	ldh a, [hLinkMotionStep]
	and a
	jr nz, .fall

;>     hLinkY += 0x10
	ldh a, [hLinkY]
	add $10
	ldh [hLinkY], a
;>     hLinkPrevY = hLinkY
	ldh [hLinkPrevY], a
;>     hLinkPositionZ += 0x10
	ldh a, [hLinkPositionZ]
	add $10
	ldh [hLinkPositionZ], a

.further
;>     while True:
;>         hLinkSpeedY = 0xFF
	ld a, $ff
	ldh [hLinkSpeedY], a
;>         hLinkSpeedX = 0
	xor a
	ldh [hLinkSpeedX], a
;>         hLinkY += 8
	ldh a, [hLinkY]
	add $08
	ldh [hLinkY], a
;>         hLinkPrevY = hLinkY
	ldh [hLinkPrevY], a
;>         hLinkPositionZ += 8
	ldh a, [hLinkPositionZ]
	add $08
	ldh [hLinkPositionZ], a
;>         Call_02_7180()                       # wall check at the new place
	call Call_02_7180
;>         if hRoomObjectType == 0xE1:          # still over the ledge
;>             continue
	ldh a, [hRoomObjectType]
	cp $e1
	jr z, .further

;>         if hRoomObjectType != 0x61 and wLinkCollisionFlags:
;>             continue
	cp $61
	jr z, .landingFound

	ld a, [wLinkCollisionFlags]
	and a
	jr nz, .further

.landingFound
;>         break
;>     hLinkMotionStep = 1
	ld a, $01
	ldh [hLinkMotionStep], a
;>     hLinkY -= 3
	ldh a, [hLinkY]
	sub $03
	ldh [hLinkY], a

.fall
;> LinkFallWithGravity()                        # height, gravity, landing
	call LinkFallWithGravity
;> if hLinkPositionZ == 0:
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .inAir

;>     wLinkMotionState = 0                     # landed: back to normal
	xor a
	ld [wLinkMotionState], a

.inAir
;> wIsLinkInTheAir = 1
	ld a, $01
	ld [wIsLinkInTheAir], a
;> Call_0D68()                                  # items on A / B
	call Call_0D68
;> UpdateSword()
	call UpdateSword
;> wSwordAnimationStatePrev = wSwordAnimationState
	ld a, [wSwordAnimationState]
	ld [wSwordAnimationStatePrev], a
;> Call_149B()
	call Call_149B
	ret

;@ path: link/collision
;@ Which quarters of the half-solid room objects $7C-$8D block Link, 4 bytes per object: index =
;@ (object - $7C) * 4 + quarter, quarter = (x bit 3 of the probe point) + 2 * (y bit 3): top-left,
;@ top-right, bottom-left, bottom-right; 1 = solid, 0 = free. Read by the wall check (Call_02_726A).
HalfSolidObjectQuadrants::
	db $01, $00, $01, $00, $00, $01, $00, $01, $01, $01
	db $00, $00, $00, $00, $01, $01, $01, $00, $01, $00, $00, $01, $00, $01, $01, $01
	db $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $01, $01, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $01, $00, $01, $01, $00, $01, $00, $00, $01

;@ path: item/ocarina
;@ X offset (signed pixels) from Link of each music note that rises while he plays, by wOcarinaNotePhase
;@ (0: right of him, 1: left). Read by LinkPlayingOcarina.
OcarinaNoteDX::
	db $08, $f8
;@ path: item/ocarina
;@ Starting x speed (1/16 pixel per frame) of those notes by wOcarinaNotePhase. Read by LinkPlayingOcarina.
OcarinaNoteSpeedX::
	db $06, $01

;@ def LinkPlayingOcarina()
;@ path: item/ocarina
;@ While a song plays (wOcarinaSongState), Link is frozen in his playing pose, swaying every $38 frames,
;@ and music notes (entity $C9) rise beside him. At the end Marin comments (she is with Link outdoors),
;@ a player without songs gets a message, and Manbo's Mambo starts the warp effect. State $FF is the
;@ long performance with a listening character (until $08D0 frames, or A / B), after which that
;@ character's state is reset and the area music returns.
LinkPlayingOcarina::
;> if wOcarinaSongState == 0:
	ld a, [wOcarinaSongState]
	and a
;>     return
	ret z

;> hLinkInteractiveMotionBlocked = 2
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $02
;> if wOcarinaSongState == 0xFF:                # the long performance
	cp $ff
	jr nz, .song

;>     stop = False
;>     wSongShowTimer += 1                      # 16-bit
	ld a, [wSongShowTimer]
	add $01
	ld [wSongShowTimer], a
	ld a, [wSongShowTimer + 1]
	adc $00
	ld [wSongShowTimer + 1], a
;>     if wSongShowTimer == 0x08D0:
	cp $08
	jr nz, .playing

	ld a, [wSongShowTimer]
	cp $d0
	jr nz, .playing

;>         wOcarinaSongState = 0
	xor a
	ld [wOcarinaSongState], a
;>         wLinkFrozen = 0
	ld [wLinkFrozen], a
;>         wOcarinaEndEffect = 3
	ld a, $03
	ld [wOcarinaEndEffect], a
;>         if wSongListenerType == 0x47:
	ld a, [wSongListenerType]
	cp $47
;>             return
	ret z

;>         stop = True
	jr .release

.playing
;>     elif wSongListenerType != 0x47 and hJoypadPressed & 0x30:   # A or B stops it
	ld a, [wSongListenerType]
	cp $47
	jr z, .animate

	ldh a, [hJoypadPressed]
	and $30
	jr z, .animate

;>         wOcarinaSongState = 0
	xor a
	ld [wOcarinaSongState], a
;>         wLinkFrozen = 0
	ld [wLinkFrozen], a
;>         wOcarinaEndEffect = 3
;>         stop = True
	ld a, $03
	ld [wOcarinaEndEffect], a

.release
;>     if stop:                                 # the performance ends
;>         wEntityState[wSongListenerSlot] = 0  # release the listening character
	ld a, [wSongListenerSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld [hl], $00
;>         return SelectAreaMusicFar()
	jp SelectAreaMusicFar


.animate
;> # otherwise: on with the playing animation below
	jr .noteAnimation

.song
;> else:
;>     Call_1495()                              # stand still
	call Call_1495
;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>     wOcarinaSongState -= 1
	ld hl, wOcarinaSongState
	dec [hl]
;>     if wOcarinaSongState == 0:               # the song is over
	jr nz, .noteAnimation

;>       if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .noMarin

;>           if wSelectedSong != 1 and not wIsIndoor:
	ld a, [wSelectedSong]
	cp $01
	jr z, .songEnd

	ld a, [wIsIndoor]
	and a
	jr nz, .songEnd

;>               OpenDialogTable2(0x77)         # Marin comments on the song
	ld a, $77
	call OpenDialogTable2
	jr .songEnd

.noMarin
;>       elif not wOcarinaSongFlags:            # no song learnt
	ld a, [wOcarinaSongFlags]
	and a
	jr nz, .songEnd

;>           OpenDialog(0x8E)
	ld a, $8e
	call OpenDialog
;>           wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>           return
	ret


.songEnd
;>       wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>       if wSelectedSong == 1:                 # Manbo's Mambo: warp to the pond
	ld a, [wSelectedSong]
	cp $01
	jr nz, .done

;>           wTransitionGfx = 2
	ld a, $02
	ld [wTransitionGfx], a
;>           wTransitionGfxFrameCount = 0
	xor a
	ld [wTransitionGfxFrameCount], a
;>           wTransitionSequenceCounter = 0
	ld [wTransitionSequenceCounter], a
;>           wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>           hJingle = 0x2C
	ld a, $2c
	ldh [hJingle], a

.done
;>       return
	ret


.noteAnimation
;> # the playing animation: Link sways, notes rise
;> wOcarinaNoteTimer += 1
	ld a, [wOcarinaNoteTimer]
	inc a
	ld [wOcarinaNoteTimer], a
;> if wOcarinaNoteTimer >= 0x38:
	cp $38
	jr c, .pose

;>     wOcarinaNoteTimer = 0
	xor a
	ld [wOcarinaNoteTimer], a
;>     wOcarinaNotePhase ^= 1
	ld a, [wOcarinaNotePhase]
	xor $01
	ld [wOcarinaNotePhase], a

.pose
;> pose = 0x75 if wOcarinaNotePhase else 0x76
	ld a, [wOcarinaNotePhase]
	ld e, $75
	and a
	jr nz, .setPose

	inc e

.setPose
;> hLinkAnimationState = pose
	ld a, e

	ldh [hLinkAnimationState], a
;> wLinkFrozen = 2
	ld a, $02
	ld [wLinkFrozen], a
;> wLinkPoseLock = 2
	ld [wLinkPoseLock], a
;> if wOcarinaSongState < 0x10 or wOcarinaNoteTimer != 0x14:
	ld a, [wOcarinaSongState]
	cp $10
	ret c

	ld a, [wOcarinaNoteTimer]
	cp $14
;>     return
	jr nz, .noNote

;> slot = Call_3C01(0xC9)                       # a music note
	ld a, $c9
	call Call_3C01
;> if carry:
;>     return
	jr c, .noNote

;> wEntityY[slot] = hLinkY - 8
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	sub $08
	ld [hl], a
;> p = wOcarinaNotePhase
	ld a, [wOcarinaNotePhase]
	ld c, a
	ld b, d
;>@nx wEntityX[slot] = hLinkX + OcarinaNoteDX[p]

	ld hl, OcarinaNoteDX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@nx
	ld [hl], a
;> wEntitySpeedX[slot] = OcarinaNoteSpeedX[p]
	ld hl, OcarinaNoteSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[slot] = 0xFC                   # rising
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fc
;> wEntityPrivateCounter[slot] = 0x40
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], $40

.noNote
	ret


;@ path: item/shovel
;@ Link's poses while digging, index = direction * 2 + phase (bit 4 of wDigCounter: the shovel goes in,
;@ then comes out). Read by UpdateDigging.
DigPoses::
	db $71, $72, $6f, $70, $73, $74, $6d, $6e

;@ def UpdateDigging()
;@ path: item/shovel
;@ While Link digs (wDigState set by the shovel's button): he stands still in the digging poses for $18
;@ frames; at frame $10 the square in front of him is dug up if it can be. When something was dug
;@ (state 2) and Marin is with him, she comments. In map 8, while $D219 is 2, the shovel also hits like
;@ a sword.
UpdateDigging::
;> if wDigState == 0:
	ld a, [wDigState]
	and a
;>     return
	jr z, .done

;> if hMapId == 8 and mem[0xD219] == 2:
	ldh a, [hMapId]
	cp $08
	jr nz, .dig

	ld a, [$d219]
	cp $02
	jr nz, .dig

;>     Call_0F3F()                              # hitbox in front of Link
	call Call_0F3F
;>     wSwordCollisionEnabled = 1
	ld a, $01
	ld [wSwordCollisionEnabled], a

.dig
;> hLinkInteractiveMotionBlocked = 1
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
;> Call_1495()                                  # stand still
	call Call_1495
;> wSwordAnimationState = 0
	ld [wSwordAnimationState], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> wDigCounter += 1
	ld a, [wDigCounter]
	inc a
	ld [wDigCounter], a
;> if wDigCounter == 0x10:
	cp $10
	jr nz, .end

;>     DigHole()                           # dig the square in front of Link
	push af
	call DigHole
	pop af

.end
;> if wDigCounter == 0x18:                      # done
	cp $18
	jr nz, .pose

;>@mc     if wDigState == 2 and wIsMarinFollowingLink and not wDialogState:
	ld a, [wDigState]
	cp $02
	jr nz, .stop

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .stop

;=@mc
	ld a, [wDialogState]
	and a
	jr nz, .stop

;>         OpenDialogTable2(0x79)               # Marin comments
	ld a, $79
	call OpenDialogTable2

.stop
;>     wDigState = 0
	xor a
	ld [wDigState], a
;>     wSwordDirectionLocked = 0
	ld [wSwordDirectionLocked], a
;>     return
	ret


.pose
;>@dp hLinkAnimationState = DigPoses[hLinkDirection * 2 + ((wDigCounter >> 4) & 1)]
	rra
	rra
	rra
	rra
	and $01
	ld e, a
;=@dp
	ldh a, [hLinkDirection]
	sla a
	add e
	ld e, a
	ld d, $00
;=@dp
	ld hl, DigPoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a

.done
	ret


;@ path: item/shovel
;@ X offset from Link of the point that picks the square to dig, per direction (0 right, 1 left, 2 up,
;@ 3 down), signed pixels. Read by FindDigSpot.
DigSpotDX::
	db $14, $fc, $08, $08

;@ path: item/shovel
;@ Y offset from Link of that point per direction, signed pixels. Read by FindDigSpot.
DigSpotDY::
	db $0a, $0a, $fc, $14

;@ def DigHole()
;@ path: item/shovel
;@ The shovel goes into the ground: when the square in front of Link can be dug, it becomes a hole and
;@ wDigState becomes 2 ("something was dug").
DigHole::
;> if not FindDigSpot():                       # carry = cannot dig there
	call FindDigSpot
	jr c, .done

;>     wDigState = 2
	ld a, $02
	ld [wDigState], a
;>     DigUpSquare()
	call DigUpSquare

.done
	ret


;@ def DigUpSquare()
;@ path: item/shovel
;@ Turns the square found by FindDigSpot (index in hMultiPurpose1) into a dug hole: room object $CC,
;@ and its four background tiles are queued for drawing (indoors $04 $06 / $05 $07, outdoors $6A $7A /
;@ $6B $7B). One time in eight a rupee (entity $2E) or a heart ($2D) pops out and flies away from Link.
DigUpSquare::
;> wRoomObjects[hMultiPurpose1] = 0xCC
	ldh a, [hMultiPurpose1]
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $cc
;> GetBGAddress()                                  # BG address of the square -> hBGAddrHigh / Low
	call GetBGAddress
;>@cmd cmd = wDrawCommand + wDrawCommandsSize   # append a draw command of $0A bytes
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;=@cmd
	add $0a
	ld [wDrawCommandsSize], a
	ld d, $00
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh                   # left column: 2 tiles downward ($81)
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x81
	ld a, $81
	ld [hli], a
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .outdoor

;>     mem[cmd + 3] = 0x04
	ld a, $04
	ld [hli], a
;>     mem[cmd + 4] = 0x06
	ld a, $06
	ld [hli], a
;>     mem[cmd + 5] = hBGAddrHigh               # right column
	ldh a, [hBGAddrHigh]
	ld [hli], a
;>     mem[cmd + 6] = hBGAddrLow + 1
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;>     mem[cmd + 7] = 0x81
	ld a, $81
	ld [hli], a
;>     mem[cmd + 8] = 0x05
	ld a, $05
	ld [hli], a
;>     mem[cmd + 9] = 0x07
	ld a, $07
	jr .last

.outdoor
;> else:
;>     mem[cmd + 3] = 0x6A
	ld a, $6a
	ld [hli], a
;>     mem[cmd + 4] = 0x7A
	ld a, $7a
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
;>     mem[cmd + 8] = 0x6B
	ld a, $6b
	ld [hli], a
;>     mem[cmd + 9] = 0x7B
	ld a, $7b

.last
	ld [hli], a
;> mem[cmd + 10] = 0                            # end of the queue
	ld a, $00
	ld [hli], a
;> if (GetRandomByte() & 7) == 0:                   # random byte
	call GetRandomByte
	and $07
	jr nz, .done

;>     kind = 0x2D if GetRandomByte() & 1 else 0x2E     # heart or rupee
	call GetRandomByte
	rra
	ld a, $2e
	jr nc, .spawn

	ld a, $2d

.spawn
;>     slot = Call_3C01(kind)
	call Call_3C01
;>     if carry:
;>         return
	jr c, .done

;>     wEntityX[slot] = hBGPosX + 8
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
;>     wEntityY[slot] = hBGPosY + 0x10
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
;>     wEntityDropTimer[slot] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;>     wEntityTimer1[slot] = 0x18
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $18
;>     wEntitySpeedZ[slot] = 0x20               # pops up
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
;>     Call_3C25(slot, 0x0C)                    # vector toward Link at speed $0C -> hMultiPurpose0 / 1
	push de
	pop bc
	ld a, $0c
	call Call_3C25
;>     wEntitySpeedY[slot] = -hMultiPurpose0    # away from Link
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

.done
;> return
	ret


;@ def FindDigSpot() -> carry
;@ path: item/shovel
;@ Finds the square in front of Link for the shovel (hBGPosX / hBGPosY, index in hMultiPurpose1, object
;@ in hMultiPurpose0) and tells whether it can be dug: not while carrying, jumping, in a special motion
;@ or in a side-view room; the square must be floor (collision type 0) and outdoors not one of the
;@ objects $0C, $0D, $B9; indoors only object $05 can be dug. Returns with carry clear when it can.
FindDigSpot::
;>@busy if wIsCarryingLiftedObject or hLinkPositionZ or wLinkMotionState or hIsSideScrolling:
	ld a, [wIsCarryingLiftedObject]
	ld hl, hLinkPositionZ
	or [hl]
	ld hl, wLinkMotionState
	or [hl]
	ld hl, hIsSideScrolling
;=@busy
	or [hl]
;>@busyret     return True
	jp nz, .cannot

;>@px hBGPosX = (hLinkX + DigSpotDX[hLinkDirection] - 8) & 0xF0
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, DigSpotDX
	add hl, de
	ldh a, [hLinkX]
;=@px
	add [hl]
	sub $08
	and $f0
	ldh [hBGPosX], a
;> column = hBGPosX >> 4
	swap a
	ld c, a
;>@py hBGPosY = (hLinkY + DigSpotDY[hLinkDirection] - 0x10) & 0xF0
	ld hl, DigSpotDY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	sub $10
	and $f0
;=@py
	ldh [hBGPosY], a
;> square = hBGPosY | column
	or c
	ld e, a
;> hMultiPurpose1 = square
	ldh [hMultiPurpose1], a
;> if wRoomObjects + square > 0xD7FF:          # outside the room
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
;>     return True
	jp nz, .cannot

;> hMultiPurpose0 = wRoomObjects[square]
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> if GetObjectPhysics(wIsIndoor, hMultiPurpose0) != 0:   # collision type of the object: 0 = floor
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	cp $00
;>     return True
	jr nz, .cannot

;> if wIsIndoor == 0:
	ld a, d
	and a
	jr nz, .indoor

;>@ow     if hMultiPurpose0 in (0x0C, 0x0D, 0xB9):
;>         return True
	ldh a, [hMultiPurpose0]
	cp $0c
	jr z, .cannot

	cp $0d
	jr z, .cannot

;=@ow
	cp $0c
	jr z, .cannot

	cp $0d
	jr z, .cannot

	cp $b9
	jr z, .cannot

;>     return False
	jr .can

.indoor
;> elif hMultiPurpose0 != 0x05:
	ldh a, [hMultiPurpose0]
	cp $05
;>     return True
	jr nz, .cannot

.can
;> return False
	and a
	ret


.cannot
;=@busyret
	scf
	ret


;@ def CollapseFloorUnderLink()
;@ path: object/floor
;@ The crumbling floor Link stood on too long (object $DF, see CheckGroundUnderLink) gives way: the
;@ square at hMultiPurpose0 / hMultiPurpose1 (its left and top pixel) becomes a hole (object $AE) and its
;@ four tiles ($76 $77 twice) are queued for drawing.
CollapseFloorUnderLink::
;> hBGPosX = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hBGPosX], a
;> column = hMultiPurpose0 >> 4
	swap a
	and $0f
	ld e, a
;> hBGPosY = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hBGPosY], a
;> square = (hMultiPurpose1 & 0xF0) | column
	and $f0
	or e
	ld e, a
	ld d, $00
;> wRoomObjects[square] = 0xAE                  # a hole
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $ae
;> GetBGAddress()
	call GetBGAddress
;>@cmd cmd = wDrawCommand + wDrawCommandsSize   # append a draw command of $0A bytes

	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;=@cmd
	add $0a
	ld [wDrawCommandsSize], a
	ld d, $00
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh                   # left column: tiles $76, $77 downward
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x81
	ld a, $81
	ld [hli], a
;> mem[cmd + 3] = 0x76
	ld a, $76
	ld [hli], a
;> mem[cmd + 4] = 0x77
	ld a, $77
	ld [hli], a
;> mem[cmd + 5] = hBGAddrHigh                   # right column
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 6] = hBGAddrLow + 1
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
;> mem[cmd + 7] = 0x81
	ld a, $81
	ld [hli], a
;> mem[cmd + 8] = 0x76
	ld a, $76
	ld [hli], a
;> mem[cmd + 9] = 0x77
	ld a, $77
	ld [hli], a
;> mem[cmd + 10] = 0
	ld [hl], $00
	ret


;@ path: link/motion
;@ Link's poses while a revolving door turns him around, index = (wLinkMotionCounter >> 3) & 7 (7 used).
;@ Read by LinkMotionRevolvingDoor.
RevolvingDoorPoses::
	db $50, $51, $52, $53, $53, $54, $52

;@ def LinkMotionRevolvingDoor()
;@ path: link/motion
;@ Link's motion state 5: a revolving door carries him round. He is held at (80, 16) in the turning
;@ poses for $38 frames, then shown facing up off the top edge, and at frame $48 the screen scrolls to
;@ the room above and the normal motion resumes.
LinkMotionRevolvingDoor::
;> hLinkY = 0x10
	ld a, $10
	ldh [hLinkY], a
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;> wLinkFrozen = 0x50
	ld [wLinkFrozen], a
;>@pose hLinkAnimationState = RevolvingDoorPoses[(wLinkMotionCounter >> 3) & 7]
	ld a, [wLinkMotionCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;=@pose
	ld d, $00
	ld hl, RevolvingDoorPoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;> wLinkMotionCounter += 1
	ld a, [wLinkMotionCounter]
	inc a
	ld [wLinkMotionCounter], a
;> if wLinkMotionCounter >= 0x38:               # through the door
	cp $38
	jr c, .scroll

;>     hLinkY = 0xFB
	ld a, $fb
	ldh [hLinkY], a
;>     hLinkDirection = 2
	ld a, $02
	ldh [hLinkDirection], a
;>     hLinkAnimationState = 4
	ld a, $04
	ldh [hLinkAnimationState], a

.scroll
;> if wLinkMotionCounter == 0x48:
	ld a, [wLinkMotionCounter]
	cp $48
	jr nz, EndLinkScriptedMotion.done

;>     wRoomTransitionDirection = 2             # scroll up
	ld a, $02
	ld [wRoomTransitionDirection], a
;>     wRoomTransitionState = 1
	ld a, $01
	ld [wRoomTransitionState], a

;>     EndLinkScriptedMotion()                  # (falls through)

;@ def EndLinkScriptedMotion()
;@ path: link/motion
;@ Ends a scripted motion: Link is free again and back in the normal motion state.
EndLinkScriptedMotion::
;> wLinkMotionCounter = 0
	xor a
	ld [wLinkMotionCounter], a
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> wLinkMotionState = 0
	ld a, $00
	ld [wLinkMotionState], a

.done
	ret

;@ path: link/swim
;@ Swimming speeds, 16 bytes each: index = hJoypadHeld & $0F (bit 0 right, 1 left, 2 up, 3 down);
;@ signed 1/16 pixel per frame. SwimSpeedX: x speed of normal swimming ($08 straight, $06 diagonal);
;@ SwimFastSpeedX: during the first part of a stroke ($10 / $0C). SwimSpeedY / SwimFastSpeedY: the same
;@ for y (negative = up). Link's speed moves one step per two frames toward the value. Read by
;@ LinkMotionSwimming.
SwimSpeedX::
	db $00, $08, $f8, $00, $00, $06, $fa, $00, $00, $06, $fa, $00, $00, $00, $00, $00

;@ path: link/swim
;@ Swimming x speed during a stroke (wSwimStrokeTimer >= $10), index = hJoypadHeld & $0F.
SwimFastSpeedX::
	db $00, $10, $f0, $00, $00, $0c, $f4, $00, $00, $0c, $f4, $00, $00, $00, $00, $00

;@ path: link/swim
;@ Swimming y speed, index = hJoypadHeld & $0F.
SwimSpeedY::
	db $00, $00, $00, $00, $f8, $fa, $fa, $00, $08, $06, $06, $00, $00, $00, $00, $00

;@ path: link/swim
;@ Swimming y speed during a stroke, index = hJoypadHeld & $0F.
SwimFastSpeedY::
	db $00, $00, $00, $00, $f0, $f4, $f4, $00, $10, $0c, $0c, $00, $00, $00, $00, $00

;@ def LinkMotionSwimming()
;@ path: link/swim
;@ Link's motion state 1: swimming in deep water. B dives / surfaces (a dive lasts $A0 frames), A
;@ makes a stroke ($20 frames, faster for the first half). The speed eases toward the held direction.
;@ Diving at the spot (88, 80) of overworld room $78 or of room $F2 in map $1F finds a hidden item
;@ (entity $35, once per room); in room $8D it starts a warp.
LinkMotionSwimming::
;> if wDebugToggle:                             # free movement mode: no swimming
	ld a, [wDebugToggle]
	and a
	jr z, .swim

;>     wLinkMotionState = 0
	ld a, $00
	ld [wLinkMotionState], a
;>     return
	ret


.swim
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hLinkPositionZ = 0
	ldh [hLinkPositionZ], a
;> wIsLinkInTheAir = 0
	ld [wIsLinkInTheAir], a
;> wItemUsePoseTimer = 0
	ld [wItemUsePoseTimer], a
;> wSwordAnimationState = 0
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wSwordPokeTimer = 0
	ld [wSwordPokeTimer], a
;> if hLinkInteractiveMotionBlocked or wDialogState:
	ld hl, wDialogState
	ldh a, [hLinkInteractiveMotionBlocked]
	or [hl]
	jp z, .controls

;>     Call_1495()                              # float in place
	call Call_1495
;>     hLinkInteractiveMotionBlocked = 0
	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jr z, .pose

	xor a
	ldh [hLinkInteractiveMotionBlocked], a

.pose
;>     return UpdateLinkAnimationState()
	jp UpdateLinkAnimationState

.controls
;> if hJoypadPressed & 0x20:                    # B: dive or come up
	ldh a, [hJoypadPressed]
	and $20
	jr z, .stroke

;>     hLinkMotionStep ^= 1
	ldh a, [hLinkMotionStep]
	xor $01
	ldh [hLinkMotionStep], a
;>     if hLinkMotionStep:
	jr z, .stroke

;>         hLinkCountdown = 0xA0                # dive length
	ld a, $a0
	ldh [hLinkCountdown], a
;>         Call_02_571D(hLinkY - 3)             # splash
	ldh a, [hLinkY]
	sub $03
	call Call_02_571D

.stroke
;> if wSwimStrokeTimer:
	ld a, [wSwimStrokeTimer]
	and a
	jr z, .newStroke

;>     wSwimStrokeTimer -= 1
	dec a
	ld [wSwimStrokeTimer], a
	jr .steer

.newStroke
;> elif hJoypadPressed & 0x10:                  # A: a stroke
	ldh a, [hJoypadPressed]
	and $10
	jr z, .steer

;>     hJingle = 0x0F
	ld a, $0f
	ldh [hJingle], a
;>     wSwimStrokeTimer = 0x20
	ld a, $20
	ld [wSwimStrokeTimer], a

.steer
;> if (hFrameCounter & 1) == 0:                 # every other frame
	ldh a, [hFrameCounter]
	and $01
	jr nz, .animate

;>     e = hJoypadHeld & 0x0F
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, $00
;>     table = SwimFastSpeedX if wSwimStrokeTimer >= 0x10 else SwimSpeedX
	ld hl, SwimSpeedX
	ld a, [wSwimStrokeTimer]
	cp $10
	jr c, .slowX

	ld hl, SwimFastSpeedX

.slowX
;>     diff = table[e] - hLinkSpeedX
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedX
	sub [hl]
;>     if diff:
	jr z, .speedY

;>         hLinkSpeedX += 1 if (diff & 0x80) == 0 else -1
	inc [hl]
	bit 7, a
	jr z, .speedY

	dec [hl]
	dec [hl]

.speedY
;>     table = SwimFastSpeedY if wSwimStrokeTimer >= 0x10 else SwimSpeedY
	ld hl, SwimSpeedY
	ld a, [wSwimStrokeTimer]
	cp $10
	jr c, .slowY

	ld hl, SwimFastSpeedY

.slowY
;>     diff = table[e] - hLinkSpeedY
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedY
	sub [hl]
;>     if diff:
	jr z, .moving

;>         hLinkSpeedY += 1 if (diff & 0x80) == 0 else -1
	inc [hl]
	bit 7, a
	jr z, .moving

	dec [hl]
	dec [hl]

.moving
;>     if hLinkSpeedX or hLinkSpeedY or hLinkMotionStep:
	ldh a, [hLinkSpeedX]
	or [hl]
	ld hl, hLinkMotionStep
	or [hl]
	jr z, .still

;>         wLinkWalkingFrameCount += 1
	ld hl, wLinkWalkingFrameCount
	inc [hl]
	jr .facing

.still
;>     else:
;>         wLinkWalkingFrameCount = 3
	ld a, $03
	ld [wLinkWalkingFrameCount], a

.facing
;>     if JoypadToDirection[e] != 0x0F:
	ld hl, JoypadToDirection
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, .animate

;>         hLinkDirection = JoypadToDirection[e]
	ldh [hLinkDirection], a

.animate
;> UpdateLinkAnimationState()
	call UpdateLinkAnimationState
;> if hLinkInteractiveMotionBlocked:
	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jr z, .move

;>     hLinkInteractiveMotionBlocked = 0
	xor a
	ldh [hLinkInteractiveMotionBlocked], a
	jr .ground

.move
;> else:
;>     MoveLinkAndCollide()
	call MoveLinkAndCollide

.ground
;> Jump_002_77fa()                              # what is under Link now
	call Jump_002_77fa
;> if not hLinkMotionStep:                      # not diving
	ldh a, [hLinkMotionStep]
	and a
;>     return
	jr z, .done

;> if hLinkCountdown == 0:                      # out of breath: come up
	ldh a, [hLinkCountdown]
	and a
	jr nz, .where

;>     hLinkMotionStep = 0
	ldh [hLinkMotionStep], a

.where
;> if hMapId == 0:
	ldh a, [hMapId]
	and a
	jr z, .overworld

;>@ow1     if hMapRoom != 0x78:
;>@ow2         return
;> elif hMapId != 0x1F:                         # other maps
;>     return LinkDiveWarpSpot()
	cp $1f
	jr nz, LinkDiveWarpSpot

;> elif hMapRoom != 0xF2:
;>     return
	ldh a, [hMapRoom]
	cp $f2
	jr nz, .done

	jr .itemSpot

.overworld
;=@ow1
	ldh a, [hMapRoom]
	cp $78
;=@ow2
	jr nz, .done

.itemSpot
;> if abs(hLinkY - 0x50) >= 8:                  # the spot at (88, 80)

;>     return
	ldh a, [hLinkY]
	sub $50
	add $08
	cp $10
	jr nc, LinkDiveWarpSpot.ret

;> if abs(hLinkX - 0x58) >= 8:
;>     return
	ldh a, [hLinkX]
	sub $58
	add $08
	cp $10
	jr nc, LinkDiveWarpSpot.ret

;> if hRoomStatus & 0x20:                       # found already
	ld hl, hRoomStatus
	bit 5, [hl]
;>     return
	jr nz, .done

;> hRoomStatus |= 0x20
	set 5, [hl]
;> slot = Call_3C01(0x35)                       # the hidden item
	ld a, $35
	call Call_3C01
;> if carry:
;>     return
	jr c, .done

;> wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityZ[slot] = 3
	ld hl, wEntityZ
	add hl, de
	ld [hl], $03
;> wEntityPhysicsFlags[slot] &= ~0x10
	ld hl, wEntityPhysicsFlags
	add hl, de
	res 4, [hl]

.done
	ret


;@ def LinkDiveWarpSpot()
;@ path: link/swim
;@ Diving at (88, 80) in room $8D starts a warp (Link arrives swimming: his motion state is kept in
;@ wSavedLinkMotionState). Jumped to by LinkMotionSwimming in maps other than 0 and $1F.

LinkDiveWarpSpot::
;> if hMapRoom != 0x8D:
	ldh a, [hMapRoom]
	cp $8d
;>     return
	jr nz, .ret

;>@spot2 if abs(hLinkY - 0x50) < 8 and abs(hLinkX - 0x58) < 8:
	ldh a, [hLinkY]

	sub $50
	add $08
	cp $10
	jr nc, .ret

	ldh a, [hLinkX]
;=@spot2
	sub $58
	add $08
	cp $10
	jr nc, .ret

;>     wWarpDestX = hLinkX
	ldh a, [hLinkX]
	ld [wWarpDestX], a
;>     wSavedLinkMotionState = wLinkMotionState     # he arrives swimming
	ld a, [wLinkMotionState]
	ld [wSavedLinkMotionState], a
;>     return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise

.ret
	ret

;@ def LinkMotionCarriedUp()
;@ path: link/motion
;@ Link's motion state $0A: he rises and moves with his speeds (without control) until he is past the
;@ right edge (x $E0-$EF) or $78 pixels high; then a warp starts after $70 frames.
LinkMotionCarriedUp::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> ApplyLinkSpeedZ()
	call ApplyLinkSpeedZ
;> if (hLinkX & 0xF0) != 0xE0 and hLinkPositionZ < 0x78:
	ldh a, [hLinkX]
	and $f0
	cp $e0
	jr z, .away

	ldh a, [hLinkPositionZ]
	cp $78
;>     return
	ret c

.away
;> StartWarpFadeOutMusic()
	call StartWarpFadeOutMusic
;> Call_1495()
	call Call_1495
;> hLinkPositionZ = 0
	ldh [hLinkPositionZ], a
;> hLinkSpeedZ = 0
	ldh [hLinkSpeedZ], a
;> wWarpTimer = 0x70
	ld a, $70
	ld [wWarpTimer], a
	ret

;@ path: link/fall
;@ Link's poses while he falls into a hole, index = wLinkMotionCounter >> 4 (0-5; at 6 the fall is
;@ over): getting smaller, then $FF (not drawn). Read by LinkMotionFallingDown.
FallInHolePoses::
	db $55, $56, $57, $57, $ff, $ff, $ff, $ff, $ff, $ff

;@ def LinkMotionFallingDown()
;@ path: link/fall
;@ Link's motion state 6: falling into a hole or sinking sand. After the falling poses ($60 frames):
;@ in four overworld rooms ($01, $95, $2C, $EC) he falls to another place (motion state 9); a hole
;@ indoors leads (spinning) to the floor below through the warp record; sinking sand in the rooms
;@ $7A-$7D of map $0A takes him to overworld room $1A; other sinking sand puts him back where he
;@ stood, with half a heart of damage.
LinkMotionFallingDown::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> wLinkMotionCounter += 1
	ld a, [wLinkMotionCounter]
	inc a
	ld [wLinkMotionCounter], a
;> i = (wLinkMotionCounter >> 4) & 0x0F
	rra
	rra
	rra
	rra
	nop
	and $0f
;> if i != 6:
	cp $06
	jr z, .fallen

;>     hLinkAnimationState = FallInHolePoses[i]
	ld e, a
	ld d, $00
	ld hl, FallInHolePoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;>     return
	ret


.fallen
;> wLinkPushedTimer = 0
	xor a
	ld [wLinkPushedTimer], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> RearmStairs()
	call RearmStairs
;>@rooms if not wIsIndoor and hMapRoom in (0x01, 0x95, 0x2C, 0xEC):
	ld a, [wIsIndoor]
	and a
	jr nz, .hole

	ldh a, [hMapRoom]
	cp $01
	jr z, .fallElsewhere

;=@rooms
	cp $95
	jr z, .fallElsewhere

	cp $2c
	jr z, .fallElsewhere

;=@rooms
	cp $ec
	jr nz, .hole

.fallElsewhere
;>     wLinkMotionState = 9
	ld a, $09
	ld [wLinkMotionState], a
;>     hLinkCountdown = 0x40
	ld a, $40
	ldh [hLinkCountdown], a
;>     hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a
;>     hLinkAnimationState = 0xFF               # hidden
	dec a
	ldh [hLinkAnimationState], a
;>     return
	ret


.hole
;> timer = None
;> if wHoleCollisionType == 0x50:               # sinking sand
	ld a, [wHoleCollisionType]
	cp $50
;>     return LinkSankInSand()
	jr z, LinkSankInSand

;> if wHoleCollisionType != 0xFF:
	cp $ff
	jr z, .spin

;>     if wWarpType == 2:                       # side-view destination
	ld a, [wWarpType]
	cp $02
	jr nz, .square

;>         wWarpDestX = hLinkY
	ldh a, [hLinkY]
	ld [wWarpDestX], a
;>         timer = 0
	xor a
	jr .warp

.square
;>     else:                                    # arrive on the same square of the room below
;>         wWarpDestX = (hLinkX & 0xF0) + 8
	ldh a, [hLinkX]
	and $f0
	add $08
	ld [wWarpDestX], a
;>         wWarpDestY = hLinkY & 0xF0
	ldh a, [hLinkY]
	and $f0
	ld [wWarpDestY], a

.spin
;> if timer is None:                            # spinning down to the floor below
;>     wIsSpinningInHole = 1
	ld a, $01
	ld [wIsSpinningInHole], a
;>     timer = 0x70
	ld a, $70

.warp
;> wWarpTimer = timer
	ld [wWarpTimer], a
;> Call_1495()
	call Call_1495
;> hLinkSpeedZ = 0
	ldh [hLinkSpeedZ], a
;> wIsLinkInTheAir = 0
	ld [wIsLinkInTheAir], a
;> return StartWarpFadeOutMusic()
	jp StartWarpFadeOutMusic

;@ def LinkSankInSand()
;@ path: link/fall
;@ End of a fall into sinking sand (from LinkMotionFallingDown): the pit of overworld room $1E works like
;@ a hole; in the rooms $7A-$7D of map $0A Link comes out in overworld room $1A at (104, 86); anywhere
;@ else he is put back where he stood and loses half a heart.
LinkSankInSand::
;> if not wIsIndoor and hMapRoom == 0x1E:       # this sand pit is a hole
	ld a, [wIsIndoor]
	and a
	jr nz, .sandRooms

	ldh a, [hMapRoom]
	cp $1e
;>     return fall_like_hole()                  # LinkMotionFallingDown's spin and warp
	jr z, LinkMotionFallingDown.spin

.sandRooms
;>@sr if hMapId == 0x0A and hMapRoom in (0x7A, 0x7B, 0x7C, 0x7D):
	ldh a, [hMapId]
	cp $0a
	jr nz, .putBack

	ldh a, [hMapRoom]
	cp $7a
	jr z, .toRoom1A

;=@sr
	cp $7b
	jr z, .toRoom1A

	cp $7c
	jr z, .toRoom1A

;=@sr
	cp $7d
	jr nz, .putBack

.toRoom1A
;>     wWarpType = 0                            # overworld room $1A, at (104, 86)
	ld a, $00
	ld hl, wWarpType
	ld [hli], a
;>     wWarpMap = 0
	ld a, $00
	ld [hli], a
;>     wWarpRoom = 0x1A
	ld a, $1a
	ld [hli], a
;>     wWarpDestX = 0x68
	ld a, $68
	ld [hli], a
;>     wWarpDestY = 0x56
	ld a, $56
	ld [hli], a
;>     wWarpTimer = 0x24
	ld a, $24
	ld [wWarpTimer], a
;>     hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
;>     return StartWarpFadeOutMusic()
	jp StartWarpFadeOutMusic

.putBack
;> RespawnLink()                                # back where he stood
	call RespawnLink
;> wSubtractHealthBuffer += 4                   # half a heart
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a
;> wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
	ret

;@ def LinkHoldItemUp()
;@ path: link/items
;@ Link's item-showing pose, kind 1 or 5 (wLinkShowItemPose; called from bank 0 every frame of the
;@ pose): on the frame wLinkShowItemTimer is $2E the jingle $17 plays, then as LinkHoldItemUpQuiet.
LinkHoldItemUp::
;> if wLinkShowItemTimer == 0x2E:
	ld a, [wLinkShowItemTimer]
	cp $2e
	jr nz, LinkHoldItemUpQuiet

;>     hJingle = 0x17
	ld a, $17
	ldh [hJingle], a
;> LinkHoldItemUpQuiet()                        # (falls through)

;@ def LinkHoldItemUpQuiet()
;@ path: link/items
;@ Link stands (landing if he was in the air) holding something over his head (pose $6B). The thing
;@ is drawn with two sprites at OAM $C010: for kind 1 the sword (bank 0's sprite drawer, blinking palette),
;@ else one 8x16 object: tile $AE for kind 5, $8C for kind 4, $8E otherwise.
LinkHoldItemUpQuiet::
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wSwordAnimationState = 0
	ld [wSwordAnimationState], a
;> wLinkPushedTimer = 0
	ld [wLinkPushedTimer], a
;> Call_149B()
	call Call_149B
;> ApplyLinkSpeedZ()
	call ApplyLinkSpeedZ
;> hLinkSpeedZ -= 2
	ldh a, [hLinkSpeedZ]
	sub $02
	ldh [hLinkSpeedZ], a
;> if hLinkPositionZ & 0x80:                    # landed
	ldh a, [hLinkPositionZ]
	and $80
	jr z, .pose

;>     hLinkPositionZ = 0
	xor a
	ldh [hLinkPositionZ], a
;>     wLinkSubpixelZ = 0
	ld [wLinkSubpixelZ], a
;>     hLinkSpeedZ = 0
	ldh [hLinkSpeedZ], a

.pose
;> hLinkAnimationState = 0x6B
	ld a, $6b
	ldh [hLinkAnimationState], a
;> oam = 0xC010
	ld bc, wOAMBuffer + $10
;>@y hMultiPurpose0 = hLinkY - hLinkPositionZ + wLinkSpriteDY - 0x10
	ldh a, [hLinkY]
	ld hl, hLinkPositionZ
	sub [hl]
	ld hl, wLinkSpriteDY
	add [hl]
	sub $10
;=@y
	ldh [hMultiPurpose0], a
;> if wLinkShowItemPose != 1:
	ld a, [wLinkShowItemPose]
	cp $01
	jr z, .sword

;>     mem[oam + 0] = hMultiPurpose0 + 2
	ldh a, [hMultiPurpose0]
	add $02
	ld [bc], a
	inc bc
;>     mem[oam + 1] = hLinkX
	ldh a, [hLinkX]
	add $00
	ld [bc], a
;>@tile     tile = 0xAE if wLinkShowItemPose == 5 else (0x8C if wLinkShowItemPose == 4 else 0x8E)
	ld a, [wLinkShowItemPose]
	ld e, $ae
	cp $05
	jr z, .tile

;=@tile
	cp $04
	ld e, $8e
	jr nz, .tile

	ld e, $8c

.tile
;>     mem[oam + 2] = tile
	inc bc
	ld a, e
	ld [bc], a
;>     mem[oam + 3] = 0x10
	ld a, $10
	inc bc
	ld [bc], a
;>     return
	ret


.sword
;> hMultiPurpose1 = hLinkX - 8
	ldh a, [hLinkX]
	sub $08
	ldh [hMultiPurpose1], a
;> hMultiPurpose3 = (hFrameCounter << 2) & 0x10  # blinking palette
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ldh [hMultiPurpose3], a
;> hMultiPurpose2 = 6                           # the sword's sprite
	xor a
	ld h, a
	ld l, a
	ld a, $06
	ldh [hMultiPurpose2], a
;> Call_1540(oam, 0)                            # draw it (offsets 0)
	call Call_1540
	ret

;@ def LinkMotionRecover()
;@ path: link/swim
;@ Link's motion state 8: after drowning (falling into deep water without flippers) he is hidden, then
;@ shown sinking (poses $4C, $4E) while hLinkCountdown runs down; at 0 he reappears at the respawn
;@ point (in overworld room $2B at (72, 48)), with extra damage when hLinkMotionStep is 6.
LinkMotionRecover::
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> Call_1495()
	call Call_1495
;> if hLinkCountdown == 0:
	ldh a, [hLinkCountdown]
	and a
	jr nz, .sinking

;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     if hLinkMotionStep == 6:
	ldh a, [hLinkMotionStep]
	cp $06
	jr nz, .back

;>         wSubtractHealthBuffer += 4
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a

.back
;>     hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a
;>     if not wIsIndoor and hMapRoom == 0x2B:
	ld a, [wIsIndoor]
	and a
	jr nz, .respawn

	ldh a, [hMapRoom]
	cp $2b
	jr nz, .respawn

;>         wLinkRespawnX = 0x48
	ld a, $48
	ld [wLinkRespawnX], a
;>         wLinkRespawnY = 0x30
	ld a, $30
	ld [wLinkRespawnY], a

.respawn
;>     return RespawnLink()
	jp RespawnLink

.sinking
;> pose = 0xFF                                  # hidden at first
	ld e, $ff
	ldh a, [hLinkCountdown]
	cp $30
	jr c, .setPose

;> if hLinkCountdown >= 0x30:
;>     pose = 0x4E
	ld e, $4e
;>     if hLinkCountdown >= 0x40:
	cp $40
	jr c, .setPose

;>         if hLinkCountdown == 0x40:
;>             hWaveSfx = 0x03
	jr nz, .high

	ld a, $03
	ldh [hWaveSfx], a

.high
;>         pose = 0x4C
	ld e, $4c

.setPose
;> hLinkAnimationState = pose
	ld a, e
	ldh [hLinkAnimationState], a
	ret

;@ def RespawnLink()
;@ path: link/fall
;@ Puts Link back at the respawn point (wLinkRespawnX / Y) after a fall, invincible for $40 frames,
;@ ends his scripted motion and re-arms a staircase that appeared.
RespawnLink::
;> wInvincibilityCounter = 0x40
	ld a, $40
	ld [wInvincibilityCounter], a
;> hLinkX = wLinkRespawnX
	ld a, [wLinkRespawnX]
	ldh [hLinkX], a
;> hLinkPrevX = wLinkRespawnX
	ldh [hLinkPrevX], a
;> hLinkY = wLinkRespawnY
	ld a, [wLinkRespawnY]
	ldh [hLinkY], a
;> hLinkPrevY = wLinkRespawnY
	ldh [hLinkPrevY], a
;> wLinkDrawY = hLinkY - hLinkPositionZ
	ld hl, hLinkPositionZ
	sub [hl]
	ld [wLinkDrawY], a
;> EndLinkScriptedMotion()
	call EndLinkScriptedMotion
;> RearmStairs()                                # (falls through)

;@ def RearmStairs()
;@ path: object/stairs
;@ A staircase that appeared in the room (hStairsState set) waits again for Link to step off it.
RearmStairs::
;> if hStairsState:
	ldh a, [hStairsState]
	and a
	jr z, .done

;>     hStairsState = 1
	ld a, $01
	ldh [hStairsState], a

.done
	ret

;@ path: item/magic-rod
;@ Magic rod sprite in Link's hand, index = direction (0 right, 1 left, 2 up, 3 down) + 4 in the second
;@ half of the swing (wItemUsePoseTimer & $7F >= 8). MagicRodSpriteDX: x offset of the first of the two
;@ 8x16 sprites from Link (signed pixels; the second is 8 further right). Read by DrawMagicRod.
MagicRodSpriteDX::
	db $0d, $f3, $00, $ff, $08, $f8, $0c, $f5

;@ path: item/magic-rod
;@ Y offset of the magic rod sprites from Link's drawn position, same index as MagicRodSpriteDX.
MagicRodSpriteDY::
	db $00, $00, $f3, $0e, $f3, $f3, $fc, $00

;@ path: item/magic-rod
;@ Tiles of the two magic rod sprites, 2 bytes per index (left, right; $FF = that sprite is not shown).
MagicRodSpriteTiles::
	db $06, $08, $08, $06, $04, $ff, $ff, $04, $04, $ff, $ff, $04, $06, $08, $08, $06

;@ path: item/magic-rod
;@ OAM attributes of the two magic rod sprites, 2 bytes per index (bit 5 x flip, bit 6 y flip).
MagicRodSpriteAttrs::
	db $00, $00, $20, $20, $20, $00, $00, $40, $20, $00, $00, $20, $00, $00, $20, $20

;@ def DrawMagicRod()
;@ path: item/magic-rod
;@ Draws the magic rod in Link's hand (OAM $C010 and $C014) while he swings it (called from bank 0).
;@ test: hLinkDirection = rand(0, 3)
DrawMagicRod::
;> e = hLinkDirection + (4 if (wItemUsePoseTimer & 0x7F) >= 8 else 0)
	ld a, [wItemUsePoseTimer]
	and $7f
	cp $08
	ldh a, [hLinkDirection]
	jr c, .first

	add $04

.first
;> hMultiPurpose0 = MagicRodSpriteDY[e]
	ld e, a
	ld d, $00
	ld hl, MagicRodSpriteDY
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = MagicRodSpriteDX[e]
	ld hl, MagicRodSpriteDX
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = MagicRodSpriteTiles[e * 2]
	sla e
	ld hl, MagicRodSpriteTiles
	add hl, de
	ld a, [hli]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = MagicRodSpriteTiles[e * 2 + 1]
	ld a, [hl]
	ldh [hMultiPurpose3], a
;> hMultiPurpose4 = MagicRodSpriteAttrs[e * 2]
	ld hl, MagicRodSpriteAttrs
	add hl, de
	ld a, [hli]
	ldh [hMultiPurpose4], a
;> hMultiPurpose5 = MagicRodSpriteAttrs[e * 2 + 1]
	ld a, [hl]
	ldh [hMultiPurpose5], a
;>@y hMultiPurpose0 += wLinkDrawY + wLinkSpriteDY  # sprite y
	ld de, wOAMBuffer + $10
	ld bc, wOAMBuffer + $14
	ld a, [wLinkDrawY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, hMultiPurpose0
;=@y
	add [hl]
	ld [hl], a
;> if hMultiPurpose2 != 0xFF:
	ldh a, [hMultiPurpose2]
	cp $ff
	jr z, .second

;>     wOAMBuffer[0x10] = hMultiPurpose0
	ld a, [hl]
	ld [de], a

.second
;> if hMultiPurpose3 != 0xFF:
	ldh a, [hMultiPurpose3]
	cp $ff
	jr z, .x

;>     wOAMBuffer[0x14] = hMultiPurpose0
	ld a, [hl]
	ld [bc], a

.x
;> wOAMBuffer[0x11] = hMultiPurpose1 + hLinkX
	inc de
	inc bc
	ldh a, [hMultiPurpose1]
	ld hl, hLinkX
	add [hl]
	ld [de], a
;> wOAMBuffer[0x15] = wOAMBuffer[0x11] + 8
	add $08
	ld [bc], a
;> wOAMBuffer[0x12] = hMultiPurpose2
	inc de
	inc bc
	ldh a, [hMultiPurpose2]
	ld [de], a
;> wOAMBuffer[0x16] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld [bc], a
;> wOAMBuffer[0x13] = hMultiPurpose4
	inc de
	inc bc
	ldh a, [hMultiPurpose4]
	ld [de], a
;> wOAMBuffer[0x17] = hMultiPurpose5
	ldh a, [hMultiPurpose5]
	ld [bc], a
	ret


;@ path: item/magic-rod
;@ Where the magic rod's fireball starts, by Link's direction (0 right, 1 left, 2 up, 3 down):
;@ MagicRodFireballDX = x offset from Link, MagicRodFireballDY = y offset (signed pixels). Read by
;@ PlaceMagicRodFireball.
MagicRodFireballDX::
	db $04, $fc, $fc, $04

;@ path: item/magic-rod
;@ Y offset from Link of the starting fireball by direction (see MagicRodFireballDX).
MagicRodFireballDY::
	db $04, $04, $fc, $04

;@ def PlaceMagicRodFireball(slot: de)
;@ path: item/magic-rod
;@ Puts the magic rod's freshly spawned fireball (entity slot de) in front of Link and gives it its
;@ speed (bank 0).
PlaceMagicRodFireball::
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00
;>@x wEntityX[slot] = hLinkX + MagicRodFireballDX[d]
	ld hl, MagicRodFireballDX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@x
	ld [hl], a
;>@yy wEntityY[slot] = hLinkY + MagicRodFireballDY[d]

	ld hl, MagicRodFireballDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@yy
	ld [hl], a
;> wEntitySpriteVariant[slot] = 0
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], d
;> return Jump_000_10cb()
	jp Jump_000_10cb


;@ def OpenLockedOrPushBlock(kind: hBGTilesRequestCopy)
;@ path: object/blocks
;@ Link has pushed long enough against a key block or a movable block (called from the wall check with
;@ $20 or $40 in hBGTilesRequestCopy, used here as a scratch byte; the square's probe point in
;@ hMultiPurpose4 / 5). $40: the block starts sliding (entity $06 spawned on its square). $20: if Link has
;@ a small key of this dungeon, one is used, the block disappears in a puff of smoke and the room
;@ remembers it (room status bit 6).
OpenLockedOrPushBlock::
;> if hBGTilesRequestCopy == 0x40:             # movable block
	push bc
	push de
	ldh a, [hBGTilesRequestCopy]
	cp $40
	jr z, .push

;>@p1     slot = Call_3C01(0x06)               # the sliding block
;>@p2     if not carry:
;>@p3         wEntityStatus[slot] -= 1
;>@p4         wEntityX[slot] = (hMultiPurpose4 & 0xF0) + 8
;>@p5         wEntityY[slot] = (hMultiPurpose5 & 0xF0) + 0x10
;> elif wDungeonSmallKeys:                      # key block
	ld a, [wDungeonSmallKeys]
	and a
	jr z, .done

;>     wDungeonSmallKeys -= 1
	dec a
	ld [wDungeonSmallKeys], a
;>     SaveDungeonItemFlags()
	call SaveDungeonItemFlags
;>     PlayUnlockSound()                           # unlock sound
	call PlayUnlockSound
;>     status = Call_02_5987()                  # this room's status byte
	call Call_02_5987
;>     mem[status] |= 0x40                      # the block stays open
	ld a, [hl]
	or $40
	ld [hl], a
;>     hRoomStatus = mem[status]
	ldh [hRoomStatus], a
;>     hBGPosX = hMultiPurpose4 & 0xF0
	ldh a, [hMultiPurpose4]
	and $f0
	ldh [hBGPosX], a
;>     column = hBGPosX >> 4
	swap a
	ld e, a
;>     hBGPosY = hMultiPurpose5 & 0xF0
	ldh a, [hMultiPurpose5]
	and $f0
	ldh [hBGPosY], a
;>     RemoveRoomObject(hBGPosY | column)
	or e
	ld e, a
	ld d, $00
	call RemoveRoomObject
;>     hMultiPurpose0 = hBGPosX + 8
	ldh a, [hBGPosX]
	add $08
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hBGPosY + 0x10
	ldh a, [hBGPosY]
	add $10
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(2)                       # puff of smoke
	ld a, $02
	call AddTransientVfx
	jp .done


.push
;=@p1
	ld a, $06
	call Call_3C01
;=@p2
	jr c, .done

;=@p3
	ld hl, wEntityStatus
	add hl, de
	dec [hl]
;=@p4
	ldh a, [hMultiPurpose4]
	and $f0
	add $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;=@p5
	ldh a, [hMultiPurpose5]
	and $f0
	add $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a

.done
;> return
	pop de
	pop bc
	ret


;@ def PlayUnlockSound()
;@ path: sound/sfx
;@ Noise effect $04 (a lock opens, a secret is revealed).
PlayUnlockSound::
;> hNoiseSfx = 0x04
	ld a, $04
	ldh [hNoiseSfx], a
	ret


;@ def SpawnFallingRoomEventItem()
;@ path: event/room
;@ Room event "an item appears": drops entity $30 (in the dungeons, hMapId < $0A) or $3C (elsewhere)
;@ from $70 pixels above the point (40, 60).
SpawnFallingRoomEventItem::
;> kind = 0x30 if hMapId < 0x0A else 0x3C
	push bc
	ldh a, [hMapId]
	cp $0a
	ld a, $30
	jr c, .spawn

	ld a, $3c

.spawn
;> slot = Call_3C01(kind)
	call Call_3C01
;> if not carry:
	jr c, .done

;>     wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;>     wEntityY[slot] = 0x3C
	ld hl, wEntityY
	add hl, de
	ld [hl], $3c
;>     wEntityZ[slot] = 0x70
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70

.done
	pop bc
	ret


;@ path: unused/debug
;@ Destination rooms of the debug warp (B + Select, disabled in this version): 11 entries, index =
;@ wDebugWarpIndex; the map of each is in DebugWarpMaps. Read only by the unreachable code in
;@ UpdateVfxAndStairs.
DebugWarpRooms::
	db $30, $33, $81, $01, $28, $56, $68, $87, $b3, $e6, $0a

;@ path: unused/debug
;@ Destination maps of the debug warp, same index as DebugWarpRooms.
DebugWarpMaps::
	db $01, $01, $04, $00, $01
	db $02, $03, $04, $05, $06, $07

;@ def UpdateVfxAndStairs()
;@ path: gfx/vfx
;@ Runs every frame from bank 0: keeps room 0 of both indoor status groups clear, counts down the
;@ dialog cooldown, runs the 16 visual effect slots (dust, splashes, smoke, sparks...), and handles a
;@ staircase that appeared: once Link has stepped off it, stepping back on it (on the ground, carrying
;@ nothing) starts a warp. The B + Select debug warp is disabled (its jump is unconditional).
UpdateVfxAndStairs::
;> wRoomStatus[0x100] = 0
	xor a
	ld [wRoomStatus + $100], a
;> wRoomStatus[0x200] = 0
	ld [wRoomStatus + $200], a
;> if wDialogCooldown:
	ld a, [wDialogCooldown]
	and a
	jr z, .debug

;>     wDialogCooldown -= 1
	dec a
	ld [wDialogCooldown], a

.debug
;> if hJoypadHeld & 0x20:                       # B held
	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_002_52ed

;>     select = hJoypadPressed & 0x40           # not used: the jump below is unconditional
	ldh a, [hJoypadPressed]
	and $40
	jr jr_002_52ed

;> if False:                                    # the disabled debug warp (never reached)
;>     wWarpType = 1
	ld a, $01
	ld [wWarpType], a
;>     e = wDebugWarpIndex
	ld a, [wDebugWarpIndex]
	ld e, a
;>     wDebugWarpIndex = (e + 1) % 11
	inc a
	cp $0b
	jr c, .keep

	xor a

.keep
	ld [wDebugWarpIndex], a
;>     wWarpRoom = DebugWarpRooms[e]
	ld d, $00
	ld hl, DebugWarpRooms
	add hl, de
	ld a, [hl]
	ld [wWarpRoom], a
;>     wWarpMap = DebugWarpMaps[e]
	ld hl, DebugWarpMaps
	add hl, de
	ld a, [hl]
	ld [wWarpMap], a
;>     wWarpDestX = 0x50
	ld a, $50
	ld [wWarpDestX], a
;>     wWarpDestY = 0x70
	ld a, $70
	ld [wWarpDestY], a
;>     hJingle = 0x02
	ld hl, hJingle
	ld [hl], $02
;>     return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise

jr_002_52ed:
;> for c in range(15, -1, -1):
	ld b, $00
	ld c, $0f

.loop
;>     wActiveEntitySlot = c
	ld a, c
	ld [wActiveEntitySlot], a
;>     if wVfxType[c]:
	ld hl, wVfxType
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next

;>         RunTransientVfx(wVfxType[c], c)
	call RunTransientVfx

.next
	dec c
	ld a, c
	cp $ff
	jr nz, .loop

;> if wRoomTransitionState or not hStairsState:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .done

	ldh a, [hStairsState]
	and a
;>     return
	jr z, .done

;> if hStairsState == 1:                        # wait until Link is off the stairs
	cp $01
	jr nz, .armed

;>@off     if abs(hLinkX - hStairsX) >= 6 or abs(hLinkY - hStairsY) >= 6:
	ld hl, hStairsX
	ldh a, [hLinkX]
	sub [hl]
	add $06
	cp $0c
	jr nc, .stepOff

;=@off
	ld hl, hStairsY
	ldh a, [hLinkY]
	sub [hl]
	add $06
	cp $0c
	jr c, .done

.stepOff
;>         hStairsState = 2
	ldh a, [hStairsState]
	inc a
	ldh [hStairsState], a

.done
;>     return
	ret


.armed
;>@on if hLinkPositionZ == 0 and abs(hLinkX - hStairsX) < 5 and abs(hLinkY - hStairsY) < 5 and not wIsCarryingLiftedObject:
	ldh a, [hLinkPositionZ]
	and a
	jr nz, .ret

	ld hl, hStairsX
	ldh a, [hLinkX]
	sub [hl]
;=@on
	add $05
	cp $0a
	jr nc, .ret

	ld hl, hStairsY
	ldh a, [hLinkY]
	sub [hl]
;=@on
	add $05
	cp $0a
	jr nc, .ret

	ld a, [wIsCarryingLiftedObject]
	and a
	jr nz, .ret

;>     StartWarpFadeOut()                       # down the stairs
	call StartWarpFadeOut
;>     hStairsState = 0
	xor a
	ldh [hStairsState], a

.ret
	ret


;@ def RunTransientVfx(type: a, slot: c)
;@ path: gfx/vfx
;@ Runs the visual effect in slot c: counts its timer down (hMultiPurpose0 = frames left; at 0 the slot
;@ is freed, and every effect is freed during a room transition) and jumps to its type's handler
;@ (types 1-13, table below), which still draws it this frame.
;@ test: skip dispatches through a jump table
RunTransientVfx::
;> if wRoomTransitionState:
	push af
	ld a, [wRoomTransitionState]
	and a
	jr nz, .free

;>@f1     Call_02_56DB(c)                      # free the slot
;> elif wVfxTimer[c]:
	ld hl, wVfxTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .run

;>     wVfxTimer[c] -= 1
	dec a
	ld [hl], a
;>     hMultiPurpose0 = wVfxTimer[c]
	ldh [hMultiPurpose0], a
;>     if wVfxTimer[c] == 0:
	jr nz, .run

;>@f2         Call_02_56DB(c)
.free
;=@f1
;=@f2
	call Call_02_56DB

.run
;> TransientVfxHandlers[type - 1]()                # the type's handler
	pop af
	dec a
	rst $00

;@ path: gfx/vfx
;@ Handlers of the visual effect types 1-13 (index = type - 1), jumped to by RunTransientVfx: 1 splash,
;@ 2-4 smoke puffs (3 and 4 reveal something when they end), 5 clink spark, 6 one flickering sprite,
;@ 7 a sprite flying in a direction, 8, 9 the opening of a dungeon entrance, 10 a row of four sprites,
;@ 11 dash dust, 12 dash splash, 13 small sparkles.
TransientVfxHandlers::
	dw Jump_02_5619
	dw Jump_02_5699
	dw Jump_02_5699
	dw Jump_02_5699
	dw Jump_02_55E1
	dw Jump_02_55A7
	dw Jump_02_5550
	dw Jump_02_5538
	dw VfxGateOpening
	dw VfxFourSprites
	dw Jump_02_550A
	dw Jump_02_5611
	dw VfxSparkles

;@ path: gfx/vfx
;@ Sprites of visual effect 13, 8 bytes per variant (index = wVfxDirection * 8, variants 0-3): two OAM
;@ sprites of (y offset, x offset, tile, attributes), offsets added to the effect's position. Shown on
;@ frames with bit 1 clear; VfxType13SpritesAlt (the same with palette bit 4 set) on the others.
VfxType13Sprites::
	db $00, $00, $08, $20, $00, $08, $06, $20, $00, $00, $06, $00, $00, $08, $08, $00
	db $00, $04, $04, $40, $00, $04, $04, $40, $00, $04, $04, $00, $00, $04, $04, $00
;@ path: gfx/vfx
;@ Visual effect 13, the alternate frames (same layout as VfxType13Sprites, other palette).
VfxType13SpritesAlt::
	db $00, $00, $08, $30, $00, $08, $06, $30, $00, $00, $06, $10, $00, $08, $08, $10
	db $00, $04, $04, $50, $00, $04, $04, $50, $00, $04, $04, $10, $00, $04, $04, $10

;@ def VfxSparkles(slot: c)
;@ path: gfx/vfx
;@ Visual effect 13: two small sprites, drawn every other frame (alternating between slots), their
;@ variant picked by wVfxDirection and the palette flipping every 2 frames.
VfxSparkles::
;> if ((hFrameCounter ^ c) & 1) == 0:
	ldh a, [hFrameCounter]
	xor c
	and $01
;>     return
	ret z

;> Call_02_56C5(c)                              # position into hMultiPurpose1 / 2
	call Call_02_56C5
;>@off offset = wVfxDirection[c] * 8
	ld hl, wVfxDirection
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@off
	and $f8
	ld e, a
	ld d, b
;> table = VfxType13SpritesAlt if hFrameCounter & 2 else VfxType13Sprites
	ld hl, VfxType13Sprites
	ldh a, [hFrameCounter]
	and $02
	jr z, .draw

	ld hl, VfxType13SpritesAlt

.draw
;> return DrawVfxSpritePair(table + offset)       # two sprites
	jp DrawVfxSpritePair


;@ path: gfx/vfx
;@ Visual effect 10, four sprites in a row: x offset of each (index 1-4 = sprite drawn 4th to 1st),
;@ signed pixels.
VfxType10DX::
	db $f8, $00, $08, $10

;@ path: gfx/vfx
;@ Visual effect 10: tile of each of the four sprites (same index as VfxType10DX).
VfxType10Tiles::
	db $6c, $6e, $6e, $6c

;@ path: gfx/vfx
;@ Visual effect 10: OAM attributes of each of the four sprites (the right half is x-flipped).
VfxType10Attrs::
	db $00, $00, $20, $20

;@ def VfxFourSprites(slot: c)
;@ path: gfx/vfx
;@ Visual effect 10: four 8x16 sprites in a row (tiles $6C $6E $6E $6C, the right half mirrored) at the
;@ effect's position.
VfxFourSprites::
;> Call_02_56C5(c)
	call Call_02_56C5
;>@oam oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
	push hl
;=@oam
	pop de
;> for i in range(4, 0, -1):
	push bc
	ld c, $04

.loop
;>     mem[oam] = hMultiPurpose1                # y
	ldh a, [hMultiPurpose1]
	ld [de], a
	inc de
;>     mem[oam + 1] = hMultiPurpose2 + VfxType10DX[i - 1]
	ldh a, [hMultiPurpose2]
	ld hl, VfxType10DX - 1
	add hl, bc
	add [hl]
	ld [de], a
	inc de
;>     mem[oam + 2] = VfxType10Tiles[i - 1]
	ld hl, VfxType10Tiles - 1
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
;>     mem[oam + 3] = VfxType10Attrs[i - 1]
	ld hl, VfxType10Attrs - 1
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
;>     # (next sprite)
	dec c
	jr nz, .loop

;> Call_02_56EA(4)                              # 4 OAM entries used
	pop bc
	ld a, $04
	call Call_02_56EA
	ret


;@ path: gfx/vfx
;@ Visual effect 9 (a dungeon entrance opening): the two tiles drawn in the gate, 2 bytes per step
;@ (index (timer >> 3) & 2): $7E $1F when the timer is 8, $0C $1F when it is $18 (upper, lower tile).
VfxType9GateTiles::
	db $7e, $1f, $0c, $1f

;@ def VfxGateOpening(slot: c)
;@ path: gfx/vfx
;@ Visual effect 9: a dungeon entrance opens after its key was used. Link is frozen; with hMultiPurpose0
;@ = frames left: $DE the unlock sound, $A0 a rumble, $9C-$20 the screen shakes, at $18 and $08 the
;@ gate's tiles at (96, 16) change, at 8 the gate's object becomes $E3 (open) with jingle $23, and
;@ below 2 Link is free again.
VfxGateOpening::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;> t = hMultiPurpose0
	ldh a, [hMultiPurpose0]
;> if t < 2:
	cp $02
	jr nc, .t1

;>     wLinkFrozen = 0
	ld hl, wLinkFrozen
	ld [hl], b

.t1
;> if t == 0xDE:
	cp $de
	jr nz, .t2

;>     PlayUnlockSound()                           # unlock sound
	call PlayUnlockSound
	ld a, $de

.t2
;> if t == 0xA0:
	cp $a0
	jr nz, .t3

;>     hNoiseSfx = 0x2A                         # rumble
	ld hl, hNoiseSfx
	ld [hl], $2a

.t3
;> if t == 0x0A:
	cp $0a
	jr nz, .t4

;>     wRestartMusicTimer = 0x50
	ld a, $50
	ld [wRestartMusicTimer], a
	ld a, $0a

.t4
;> if t >= 0x20:
	cp $20
	jr c, .gate

;>     if t >= 0x9C:
;>         return
	cp $9c
	ret nc

;>     wScreenShakeX = 0xFE if t & 4 else 1     # shake
	ld e, $01
	and $04
	jr z, .shake

	ld e, $fe

.shake
	ld a, e
	ld [wScreenShakeX], a
;>     return
	ret


.gate
;> if (t & 0x0F) != 8:
	and $0f
	cp $08
;>     return
	jp nz, .done

;>@i i = (hMultiPurpose0 >> 3) & 2
	ldh a, [hMultiPurpose0]
	rra
	rra
	rra
	and $02
;=@i
	ld e, a
	ld d, b
;> hMultiPurpose0 = VfxType9GateTiles[i]
	ld hl, VfxType9GateTiles
	add hl, de
	ld a, [hli]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = VfxType9GateTiles[i + 1]
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hBGPosX = 0x60
	ld a, $60
	ldh [hBGPosX], a
;> if hMapRoom == 0xB5:                         # (the same values)
	ldh a, [hMapRoom]
	cp $b5
	ld a, $10
	jr nz, .posY

;>     hBGPosX = 0x60
	ld a, $60

	ldh [hBGPosX], a
	ld a, $10

.posY
;> hBGPosY = 0x10
	ldh [hBGPosY], a
;> GetBGAddress()
	call GetBGAddress
;> cmd = wDrawCommand + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, b
	ld hl, wDrawCommand
	add hl, de
;> mem[cmd + 0] = hBGAddrHigh                   # upper tile ($41: one tile)
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[cmd + 2] = 0x41
	ld a, $41
	ld [hli], a
;> mem[cmd + 3] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld [hli], a
;> mem[cmd + 4] = hBGAddrHigh                   # lower tile, one row down
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[cmd + 5] = hBGAddrLow + 0x20
	ldh a, [hBGAddrLow]
	add $20
	ld [hli], a
;> mem[cmd + 6] = 0x41
	ld a, $41
	ld [hli], a
;> mem[cmd + 7] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld [hli], a
;> mem[cmd + 8] = 0
	ld [hl], b
;> wDrawCommandsSize += 8
	ld a, e
	add $08
	ld [wDrawCommandsSize], a
;> if wVfxTimer[c] == 8:                        # the gate is open
	ld hl, wVfxTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, .done

;>     wRoomObjects[0x16] = 0xE3                # (the same for room $B5)
	ld hl, wRoomObjects + $16
	ldh a, [hMapRoom]
	cp $b5
	jr nz, .open

	ld hl, wRoomObjects + $16

.open
	ld [hl], $e3
;>     hJingle = 0x23
	ld a, $23
	ldh [hJingle], a

.done
	ret


VfxType11Sprites::
	db $00, $04, $24, $00, $00, $04, $24, $00, $00, $00, $1e, $00, $00, $08, $1e, $60

Jump_02_550A::
	call Call_02_56C5
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
	ld hl, $54fa
	ld a, [wIsUsingPegasusBoots]
	and a
	jp nz, DrawVfxSpritePair

	add hl, de
	ld de, wOAMBuffer
	call Call_02_5649
	jp Call_02_5649


VfxType8Sprites::
	db $00, $00, $1e, $00, $00, $08, $1e, $60, $00, $00, $30, $00, $00, $08, $30, $60

Jump_02_5538::
	call Call_02_56C5
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
	ld hl, $5528
	jp DrawVfxSpritePair


VfxType7SpeedX::
	db $01, $ff, $01, $ff

VfxType7SpeedY::
	db $01, $01, $ff, $ff

Jump_02_5550::
	ldh a, [hMultiPurpose0]
	cp $0a
	jr c, jr_002_5572

	ld hl, wVfxDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5548
	add hl, de
	ld a, [hl]
	ld hl, wVfxX
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $554c
	add hl, de
	ld a, [hl]
	ld hl, wVfxY
	add hl, bc
	add [hl]
	ld [hl], a

jr_002_5572:
	call Call_02_56C5
	push bc
	ld c, $3a
	ldh a, [hMultiPurpose0]
	cp $07
	jr nc, jr_002_5580

	ld c, $3c

jr_002_5580:
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hli], a
	ldh a, [hMultiPurpose2]
	ld [hli], a
	ld a, c
	ld [hli], a
	xor a
	ld [hli], a
	ldh a, [hMultiPurpose1]
	ld [hli], a
	ldh a, [hMultiPurpose2]
	add $08
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], $20
	pop bc
	ld a, $02
	call Call_02_56EA
	ret


Jump_02_55A7::
	call Call_02_56C5
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ldh a, [hMultiPurpose1]
	ld [hli], a
	ldh a, [hMultiPurpose2]
	ld [hli], a
	ld a, $24
	ld [hli], a
	ldh a, [hFrameCounter]
	xor c
	rl a
	rl a
	rl a
	rl a
	and $10
	ld [hl], a
	ld a, $01
	call Call_02_56EA
	ret


VfxType5Sprites::
	db $00, $ff, $3c, $00, $00, $07, $3c, $20, $00, $ff, $3a, $00, $00, $07, $3a, $20

Jump_02_55E1::
	call Call_02_56C5
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
	ld hl, $55d1
	jp DrawVfxSpritePair


VfxType1Sprites::
	db $f6, $fe, $18, $00, $f8, $0a, $18, $20, $fc, $00, $18, $00, $fe, $08, $18, $20
VfxType12Sprites::
	db $00, $fa, $18, $00, $00, $0e, $18, $20, $02, $fc, $18, $00, $02, $0c, $18, $20

Jump_02_5611::
	call Call_02_56C5
	ld hl, $5601
	jr jr_002_5627

Jump_02_5619::
	call Call_02_56C5
	ld a, [$c1a7]
	cp $02
	jp z, Jump_002_566c

	ld hl, $55f1

jr_002_5627:
	ldh a, [hMultiPurpose0]
	and $08
	ld e, a
	ld d, $00

DrawVfxSpritePair::
	add hl, de
	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	pop hl
	call Call_02_5649
	call Call_02_5649
	ld a, $02
	call Call_02_56EA
	ret


Call_02_5649::
	ldh a, [hMultiPurpose1]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ret


VfxType1SpritesAlt::
	db $00, $00, $7a, $00, $00, $08, $7a, $20, $00, $00, $78, $00, $00, $08, $78, $20

Jump_002_566c::
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
	ld hl, $565c
	jp DrawVfxSpritePair


VfxSmokeSprites::
	db $00, $00, $32, $00, $00, $08, $32, $20, $00, $00, $32, $00, $00, $08, $32, $20
	db $00, $00, $30, $00, $00, $08, $30, $20, $00, $00, $30, $00, $00, $08, $30, $20

Jump_02_5699::
	call Call_02_56C5
	ldh a, [hMultiPurpose0]
	cp $04
	jr nz, jr_002_56b0

	ld hl, wVfxType
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_002_56b0

	call Call_02_5C92
	jr jr_002_56b7

jr_002_56b0:
	cp $04
	jr nz, jr_002_56b7

	call Call_02_5D00

jr_002_56b7:
	ldh a, [hMultiPurpose0]
	rla
	and $18
	ld d, $00
	ld e, a
	ld hl, $5679
	jp DrawVfxSpritePair


Call_02_56C5::
	ld hl, wVfxY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
	cp $88
	jr nc, Call_02_56DB

	ld hl, wVfxX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
	cp $a8
	jr c, jr_002_56e1

Call_02_56DB::
	ld hl, wVfxType
	add hl, bc
	xor a
	ld [hl], a

jr_002_56e1:
	ret


VfxOAMStartOffsets::
	db $00, $08, $10, $18, $20, $28, $30, $38

Call_02_56EA::
	sla a
	sla a
	ld e, a
	ld a, [wOAMNextIndex]
	add e
	cp $60
	jr c, jr_002_56f9

	sub $60

jr_002_56f9:
	ld [wOAMNextIndex], a
	ld a, [wOAMEntriesUsed]
	add e
	ld [wOAMEntriesUsed], a
	cp $60
	jr c, jr_002_571a

	ldh a, [hFrameCounter]
	ld hl, wActiveEntitySlot
	add [hl]
	and $07
	ld e, a
	ld d, $00
	ld hl, $56e2
	add hl, de
	ld a, [hl]
	ld [wOAMNextIndex], a

jr_002_571a:
	ret


Call_02_571B::
	ldh a, [hLinkY]

Call_02_571D::
	ldh [hMultiPurpose1], a
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
	ld a, $0e
	ldh [hJingle], a
	ld a, $01
	call AddTransientVfx
	ret


DoorClearMasks::
	db $fe, $fd, $fb, $f7

	ld hl, wDialogState
	ld a, [wRoomTransitionState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_002_575d

	ld a, [wIsIndoor]
	and a
	jr z, jr_002_575d

	call Call_02_5B15
	ld a, [$c188]
	and a
	jr z, jr_002_575e

	cp $02
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
	jr z, jr_002_575a

	call Call_02_5871
	jr jr_002_575d

jr_002_575a:
	call Call_02_59E1

jr_002_575d:
	ret


jr_002_575e:
	ld a, [$c18c]
	and a
	jr z, jr_002_5793

	ld e, $03
	ld a, [wRoomShutterDoors]
	ld c, a

jr_002_576a:
	inc e
	ld a, e
	cp $08
	jr z, jr_002_578e

	srl c
	jr nc, jr_002_576a

	ld d, $00
	ld hl, $5729
	add hl, de
	ld a, [wRoomShutterDoors]
	and [hl]
	ld [wRoomShutterDoors], a
	ld a, e
	ld [$c189], a
	xor a
	ld [$dbac], a
	inc a
	ld [$c188], a
	ret


jr_002_578e:
	xor a
	ld [$c18c], a
	ret


jr_002_5793:
	ld a, [$c18d]
	and a
	jr nz, jr_002_579a

	ret


jr_002_579a:
	ld e, $03
	ld a, [wRoomShutterDoorsCopy]
	ld c, a

jr_002_57a0:
	inc e
	ld a, e
	cp $08
	jr z, jr_002_57c5

	srl c
	jr nc, jr_002_57a0

	ld d, $00
	ld hl, $5729
	add hl, de
	ld a, [wRoomShutterDoorsCopy]
	and [hl]
	ld [wRoomShutterDoorsCopy], a
	ld a, e
	ld [$c189], a
	ld a, $02
	ld [$c188], a
	xor a
	ld [$dbac], a
	ret


jr_002_57c5:
	xor a
	ld [$c18d], a
	ret


DoorOpenTiles::
	db $50, $51, $13, $12, $11, $10, $42, $43, $45, $13, $55, $11, $12, $46, $10, $56
	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $02, $03, $13, $12, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12

DoorColumnX::
	db $08, $08, $00, $00, $08, $08, $00, $00
	db $08, $08, $08, $00, $00, $08, $08, $00, $00, $08

DoorRowDY::
	db $00, $00, $08, $08, $00, $00
	db $08, $08, $00, $08, $08, $10, $10, $08, $08, $10, $10, $08

DoorSquareOffsets::
	db $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $01, $10, $10, $01, $01, $10, $10

DoorOpenObjects::
	db $43, $8c, $09, $0b
	db $43, $8c, $09, $0b, $44, $08, $0a, $0c, $44, $08, $0a, $0c

DoorRoomStatusBits::
	db $04, $08, $02, $01
	db $04, $08, $02, $01, $04

DoorNeighbourRoomDelta::
	db $f8, $08, $ff, $01, $f8, $08, $ff, $01, $f8

DoorNeighbourStatusBits::
	db $08, $04
	db $01, $02, $08, $04, $01, $02, $08

Call_02_5871::
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [hMultiPurposeC], a
	ldh [hMultiPurposeE], a
	ld a, [$c189]
	ld c, a
	and a
	jr z, jr_002_588b

	xor a

jr_002_5883:
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, jr_002_5883

jr_002_588b:
	ld hl, $5812
	ld a, [$c189]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld hl, wDoorX
	add hl, bc
	add [hl]
	ldh [hBGPosX], a

Jump_002_589d:
	ld hl, $5824
	ldh a, [hMultiPurposeC]
	ld c, a
	add hl, bc
	ld a, [$c189]
	ld c, a
	add hl, bc
	ld a, [hl]
	ld hl, wDoorY
	add hl, bc
	add [hl]
	ldh [hBGPosY], a
	push de
	call GetBGAddress
	pop de
	ldh a, [hMultiPurposeC]
	and a
	jr z, jr_002_58bd

	inc de
	inc de

jr_002_58bd:
	ld a, [wDrawCommandsSize]
	ld c, a
	ld b, $00
	add $05
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, bc
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $01
	ld [hli], a
	push hl
	ld hl, $57ca
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld hl, $57cb
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ldh a, [hMultiPurposeC]
	and a
	jr nz, jr_002_58f1

	ld a, $09
	ldh [hMultiPurposeC], a
	jp Jump_002_589d


jr_002_58f1:
	xor a
	inc hl
	ld [hl], a
	ld a, [$dbac]
	add $01
	ld [$dbac], a
	ld a, [$dbac]
	cp $08
	jr nc, jr_002_5904

	ret


jr_002_5904:
	ldh a, [hMultiPurposeE]
	and a
	jr nz, jr_002_5919

	xor a
	ldh [hMultiPurposeC], a
	ld a, e
	add $24
	ld e, a
	ld d, $00
	ldh [hMultiPurposeE], a
	dec de
	dec de
	jp Jump_002_589d


jr_002_5919:
	xor a
	ld [$c188], a
	ld [wLinkShowItemPoseActive], a
	xor a
	ldh [hMultiPurposeE], a
	ld a, [$c189]
	ld c, a
	ld b, $00
	ld hl, wDoorPosition
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld a, c
	and $07
	ld c, a

jr_002_5934:
	ld hl, $5836
	add hl, bc
	ld a, [hl]
	ld hl, hMultiPurpose0
	add [hl]
	ld e, a
	ld d, $00
	ld hl, $5846
	add hl, bc
	ld a, [hl]
	ld hl, wRoomObjects
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurposeE]
	and a
	jr nz, jr_002_5957

	ld a, c
	add $08
	ldh [hMultiPurposeE], a
	ld c, a
	jr jr_002_5934

jr_002_5957:
	call Call_02_5987
	push hl
	pop bc
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5856
	add hl, de
	ld a, [bc]
	or [hl]
	ld [bc], a
	ldh [hRoomStatus], a
	ld hl, $585f
	add hl, de
	ld a, [wIndoorRoom]
	add [hl]
	ld e, a
	call GetDungeonRoomStatusAddress
	push hl
	pop bc
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5868
	add hl, de
	ld a, [bc]
	or [hl]
	ld [bc], a
	ret


Call_02_5987::
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	and a
	jr z, jr_002_599f

	ldh a, [hMapId]
	cp $1a
	jr nc, jr_002_599f

	cp $06
	jr c, jr_002_599f

	inc d

jr_002_599f:
	add hl, de
	ret


DoorCloseTiles::
	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $40, $41, $58, $59, $4a, $4b, $52, $53, $44, $4d, $54, $5d, $4e, $47, $5e, $57
DoorCloseColumnX::
	db $08, $08, $00, $00, $08, $08, $00, $00

DoorCloseRowDY::
	db $00, $00, $08, $08, $08, $08, $10, $10
DoorCloseSquareOffsets::
	db $00, $00, $00, $00, $01, $01, $10, $10

DoorCloseObjects::
	db $35, $37, $39, $3b, $36, $38, $3a, $3c

Call_02_59E1::
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [hMultiPurposeC], a
	ldh [hMultiPurposeD], a
	ldh [hMultiPurposeE], a
	ld a, [$c189]
	sub $04
	jr z, jr_002_59fe

	ld c, a
	xor a

jr_002_59f6:
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, jr_002_59f6

jr_002_59fe:
	ld hl, $59bd
	ld a, [$c189]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld hl, wDoorX
	add hl, bc
	add [hl]
	ldh [hBGPosX], a

Jump_002_5a10:
	ld hl, $59c5
	ldh a, [hMultiPurposeC]
	ld c, a
	add hl, bc
	ld a, [$c189]
	ld c, a
	add hl, bc
	ld a, [hl]
	ld hl, wDoorY
	add hl, bc
	add [hl]
	ldh [hBGPosY], a
	ld a, [wLinkRespawnY]
	sub $10
	ld hl, hBGPosY
	sub [hl]
	add $10
	cp $20
	jr nc, jr_002_5a4c

	ld a, [wLinkRespawnX]
	sub $08
	ld hl, hBGPosX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_002_5a4c

	ldh a, [hLinkX]
	ld [wLinkRespawnX], a
	ldh a, [hLinkY]
	ld [wLinkRespawnY], a

jr_002_5a4c:
	push de
	call GetBGAddress
	pop de
	ldh a, [hMultiPurposeC]
	and a
	jr z, jr_002_5a58

	inc de
	inc de

jr_002_5a58:
	ld a, [wDrawCommandsSize]
	ld c, a
	ld b, $00
	add $05
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, bc
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $01
	ld [hli], a
	push hl
	ld hl, $59a1
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld hl, $59a2
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ldh a, [hMultiPurposeC]
	and a
	jr nz, jr_002_5a8c

	ld a, $04
	ldh [hMultiPurposeC], a
	jp Jump_002_5a10


jr_002_5a8c:
	xor a
	inc hl
	ld [hl], a
	ld a, [$dbac]
	add $01
	ld [$dbac], a
	ld a, [$dbac]
	cp $08
	jr nc, jr_002_5a9f

	ret


jr_002_5a9f:
	ldh a, [hMultiPurposeE]
	and a
	jr nz, jr_002_5ab4

	xor a
	ldh [hMultiPurposeC], a
	ld a, e
	add $10
	ld e, a
	ld d, $00
	ldh [hMultiPurposeE], a
	dec de
	dec de
	jp Jump_002_5a10


jr_002_5ab4:
	xor a
	ld [$c188], a
	ld [wLinkShowItemPoseActive], a
	xor a
	ldh [hMultiPurposeE], a
	ld a, [$c189]
	sub $04
	ld c, a
	ld b, $00
	ld hl, $c1f4
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a

jr_002_5acd:
	ld hl, $59d1
	add hl, bc
	ld a, [hl]
	ld hl, hMultiPurpose0
	add [hl]
	ld e, a
	ld d, $00
	ld hl, $59d9
	add hl, bc
	ld a, [hl]
	ld hl, wRoomObjects
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurposeE]
	and a
	jr nz, jr_002_5af0

	ld a, c
	add $04
	ldh [hMultiPurposeE], a
	ld c, a
	jr jr_002_5acd

jr_002_5af0:
	ld hl, wRoomStatus
	ld a, [wIsIndoor]
	and a
	jr z, jr_002_5afc

	ld hl, $d900

jr_002_5afc:
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
	push hl
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5856
	add hl, de
	ld a, [hl]
	cpl
	pop hl
	and [hl]
	ld [hl], a
	ldh [hRoomStatus], a
	ret


Call_02_5B15::
	ld a, [wRoomEvent]
	and a
	jp z, Jump_002_5bc8

	call Call_02_5D3F
	ld a, [wRoomEvent]
	and $e0
	srl a
	srl a
	srl a
	srl a
	srl a
	rst $00

JumpTable_02_5B2F::
	dw Jump_02_5D63
	dw Jump_02_5BED
	dw Jump_02_5B3F
	dw Jump_02_5C69
	dw Jump_02_5BC9
	dw Jump_02_5BAF
	dw Jump_02_5BDF
	dw Jump_02_5B88

Jump_02_5B3F::
	call Call_02_5B75
	ld c, $0f
	ld b, $00

jr_002_5b46:
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_002_5b6e

	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, jr_002_5b6e

	ld [hl], $01
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $02
	ld [hl], a
	ld a, $13
	ldh [hNoiseSfx], a

jr_002_5b6e:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_002_5b46

	ret


Call_02_5B75::
	ldh a, [hRoomStatus]
	and $10
	jr nz, jr_002_5b86

	ld a, [wRoomEventDone]
	and a
	jr z, jr_002_5b86

	xor a
	ld [wRoomEvent], a
	ret


jr_002_5b86:
	pop af
	ret


Jump_02_5B88::
	call Call_02_5B75
	ld a, $2f
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $88
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
	ld a, $88
	ldh [hMultiPurpose0], a
	ld a, $30
	ldh [hMultiPurpose1], a
	ld a, $02
	jp Jump_002_5bbc


Jump_02_5BAF::
	call Call_02_5B75
	ld a, $88
	ldh [hMultiPurpose0], a
	ld a, $20
	ldh [hMultiPurpose1], a
	ld a, $04

Jump_002_5bbc:
	call AddTransientVfx
	call Call_02_5987
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [hRoomStatus], a

Jump_002_5bc8:
	ret


Jump_02_5BC9::
	call Call_02_5B75
	ldh a, [hMapRoom]
	cp $69
	jr nz, jr_002_5bdb

	call Call_02_5987
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [hRoomStatus], a

jr_002_5bdb:
	call SpawnFallingRoomEventItem
	ret


Jump_02_5BDF::
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	and $01
	jr nz, jr_002_5c3c

Jump_02_5BED::
	ld a, [$c190]
	and a
	jr nz, jr_002_5bf6

	call Call_02_5C3D

jr_002_5bf6:
	ld a, [wRoomEventDone]
	and a
	jr z, jr_002_5c3c

	ld a, [wRoomEvent]
	cp $c1
	jr nz, jr_002_5c2a

	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	or $01
	ld [hl], a
	ld d, $00
	ldh a, [hMapRoom]
	ld e, a
	ld hl, $d900
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_002_5c23

	cp $06
	jr c, jr_002_5c23

	inc d

jr_002_5c23:
	add hl, de
	set 5, [hl]
	ld a, $1b
	ldh [hJingle], a

jr_002_5c2a:
	ld a, [$c190]
	and a
	jr z, jr_002_5c3c

	xor a
	ld [wRoomEvent], a
	ld a, $01
	ld [$c18c], a
	call PlayUnlockSound

jr_002_5c3c:
	ret


Call_02_5C3D::
	ldh a, [hLinkX]
	sub $11
	cp $7e
	jr nc, jr_002_5c64

	ldh a, [hLinkY]
	sub $16
	cp $5e
	jr nc, jr_002_5c64

	ld a, [wRoomEventDone]
	and a
	jr nz, jr_002_5c64

	ld a, $01
	ld [$c18d], a
	ld [$c190], a
	ld a, $04
	ld [wLinkPoseLock], a
	ld a, $10
	ldh [hNoiseSfx], a

jr_002_5c64:
	ret


StairsAppearTiles::
	db $60, $70, $61, $71

Jump_02_5C69::
	call Call_02_5B75
	ld a, $88
	ldh [hMultiPurpose0], a
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, jr_002_5c88

	ldh a, [hLinkX]
	sub $88
	add $10
	cp $20
	jr nc, jr_002_5c88

	ld a, $40
	jr jr_002_5c8a

jr_002_5c88:
	ld a, $30

jr_002_5c8a:
	ldh [hMultiPurpose1], a
	ld a, $03
	call AddTransientVfx
	ret


Call_02_5C92::
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, jr_002_5caa

	ldh a, [hLinkX]
	sub $88
	add $10
	cp $20
	jr nc, jr_002_5caa

	ld a, $30
	jr jr_002_5cac

jr_002_5caa:
	ld a, $20

jr_002_5cac:
	ldh [hBGPosY], a
	ld a, $80
	ldh [hBGPosX], a
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld a, $a0
	ld [hl], a
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
	ld [wDrawCommandsSize], a
	ld de, $5c65

jr_002_5cdb:
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


StairsBlockTiles::
	db $6a, $7a, $6b, $7b

Call_02_5D00::
	ld a, $01
	ldh [hStairsState], a
	ld a, $10
	ldh [hBGPosY], a
	add $10
	ldh [hStairsY], a
	ld a, $80
	ldh [hBGPosX], a
	add $08
	ldh [hStairsX], a
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld a, $be
	ld [hl], a
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
	ld [wDrawCommandsSize], a
	ld de, $5cfc
	jr jr_002_5cdb

Call_02_5D3F::
	and $1f
	ldh [hMultiPurpose0], a
	dec a
	rst $00

JumpTable_02_5D45::
	dw Jump_02_5D9C
	dw Jump_02_5D63
	dw Jump_02_5D81
	dw Jump_02_5D63
	dw Jump_02_5D78
	dw Jump_02_5D89
	dw Jump_02_5D63
	dw Jump_02_5D9C
	dw Jump_02_5D63
	dw Jump_02_5D64
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63

Jump_02_5D63::
	ret


Jump_02_5D64::
	ldh a, [hMapId]
	cp $06
	jr nz, jr_002_5d6f

	ld a, [$dae8]
	jr jr_002_5d72

jr_002_5d6f:
	ld a, [$d9ff]

jr_002_5d72:
	and $20
	jp nz, TriggerRoomEvent

	ret


Jump_02_5D78::
	ld a, [$c1a2]
	cp $02
	jp z, TriggerRoomEvent

	ret


Jump_02_5D81::
	ld a, [wFloorSwitchPressedTimer]
	and a
	jp nz, TriggerRoomEvent

	ret


Jump_02_5D89::
	ld c, $00
	ld hl, wDefeatedEntities

jr_002_5d8e:
	ld a, [hli]
	cp c
	jr nz, jr_002_5d9b

	inc c
	ld a, c
	cp $03
	jr nz, jr_002_5d8e

	call TriggerRoomEvent

jr_002_5d9b:
	ret


Jump_02_5D9C::
	ld c, $0f
	ld b, $00

jr_002_5da0:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_002_5db1

	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $02
	jr z, jr_002_5dcc

jr_002_5db1:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_002_5da0

	ldh a, [hMultiPurpose0]
	cp $08
	jr nz, jr_002_5dc9

	ld a, [$d460]
	and a
	jr z, jr_002_5dcc

	ld a, [$c113]
	and a
	jr nz, jr_002_5dcc

jr_002_5dc9:
	jp TriggerRoomEvent


jr_002_5dcc:
	ret


Call_02_5DCD::
	ld a, [de]
	cp [hl]
	jr c, jr_002_5dd3

	ld a, [hl]
	ld [de], a

jr_002_5dd3:
	inc hl
	ret


	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount
	call Call_02_5DCD
	ld de, wBombCount
	call Call_02_5DCD
	ld de, wArrowCount
	call Call_02_5DCD
	ld a, [wLinkMotionState]
	cp $02
	ret nc

	ld a, [wDialogState]
	and a
	jp nz, Jump_002_5edc

	ld a, [wRoomTransitionState]
	and a
	jp nz, Jump_002_5ef1

	ld a, [wInventoryAppearing]
	and a
	jp nz, Jump_002_5e83

	ldh a, [hJoypadHeld]
	and $40
	jp nz, Jump_002_5ec8

	ldh a, [hJoypadPressed]
	and $80
	jp z, Jump_002_5ec8

	ld a, [wWindowY]
	cp $00
	jr z, jr_002_5e2e

	ld a, [wLinkFrozen]
	and a
	jp nz, Jump_002_5ec8

	ldh a, [hLinkInteractiveMotionBlocked]
	cp $02
	jp z, Jump_002_5ec8

	ldh a, [hLinkAnimationState]
	inc a
	jp z, Jump_002_5ec8

jr_002_5e2e:
	ld a, [$c1b5]
	ld hl, $c1b8
	or [hl]
	ld hl, $c1b9
	or [hl]
	jp nz, Jump_002_5ec8

Jump_002_5e3c:
	ld a, $01
	ld [wInventoryAppearing], a
	ld [$c151], a
	ld a, $12
	ldh [hJingle], a
	ld a, [$c150]
	cpl
	inc a
	ld [$c150], a
	and $80
	jr z, jr_002_5e79

	ld a, $11
	ldh [hJingle], a
	xor a
	ld [$c151], a
	ld a, $0b
	ld [$c154], a
	ld a, [wIsIndoor]
	and a
	ld a, $07
	jr z, jr_002_5e76

	ldh a, [hMapId]
	cp $08
	ld a, $07
	jr nc, jr_002_5e76

	call Call_02_6A9B
	ld a, $02

jr_002_5e76:
	ldh [hNeedsUpdatingBGTiles], a
	ret


jr_002_5e79:
	ld a, $07
	ldh [hVolumeRight], a
	ld a, $70
	ldh [hVolumeLeft], a
	pop af
	ret


Jump_002_5e83:
	ld a, [$c151]
	and a
	jr nz, jr_002_5ea4

	ld a, [wDrawCommand]
	and a
	jr nz, jr_002_5e96

	call Call_02_631F
	ld hl, $c151
	inc [hl]

jr_002_5e96:
	pop af

Call_02_5E97::
	call Call_02_781B
	call Call_149E
	call Call_1CCC
	call UpdateEntitiesBank2
	ret


jr_002_5ea4:
	call Call_02_5EF2
	ld a, [$c150]
	ld hl, wWindowY
	add [hl]
	ld [hl], a
	cp $80
	jr z, jr_002_5ebf

	cp $00
	jr nz, jr_002_5ec5

	ld a, $03
	ldh [hVolumeRight], a
	ld a, $30
	ldh [hVolumeLeft], a

jr_002_5ebf:
	xor a
	ld [wInventoryAppearing], a
	jr jr_002_5ec8

jr_002_5ec5:
	call Call_02_5E97

Jump_002_5ec8:
jr_002_5ec8:
	ld a, [wWindowY]
	cp $80
	jr z, jr_002_5edc

	ld a, [wInventoryAppearing]
	and a
	jr nz, jr_002_5edb

	call Call_02_645E
	call Call_02_63F0

jr_002_5edb:
	pop af

Jump_002_5edc:
jr_002_5edc:
	ld a, [wDialogState]
	and $7f
	jr z, jr_002_5eeb

	cp $0c
	jr z, jr_002_5eeb

	cp $0d
	jr nz, jr_002_5ef1

jr_002_5eeb:
	call Call_02_5F09
	call Call_02_601A

Jump_002_5ef1:
jr_002_5ef1:
	ret


Call_02_5EF2::
	ld a, [$c154]
	cp $01
	jr z, jr_002_5f08

	ld c, a
	ld b, $00
	dec a
	ld e, a
	call Call_02_61ED
	ld a, [$c154]
	dec a
	ld [$c154], a

jr_002_5f08:
	ret


Call_02_5F09::
	ld hl, wDrawCommandsSize
	ldh a, [hFrameCounter]
	and $01
	or [hl]
	ret nz

	ld hl, $c3ce
	ld a, [hl]
	and a
	jr z, jr_002_5f1b

	dec [hl]
	ret


jr_002_5f1b:
	ld hl, wAddRupeeBufferHigh
	ld a, [wAddRupeeBufferLow]
	or [hl]
	jr z, jr_002_5f74

	ld a, $05
	ldh [hWaveSfx], a
	ld a, [wAddRupeeBufferLow]
	ld e, a
	ld a, [wAddRupeeBufferHigh]
	sla e
	rla
	sla e
	rla
	sla e
	rla
	inc a
	cp $0a
	jr c, jr_002_5f3f

	ld a, $09

jr_002_5f3f:
	ld e, a
	ld a, [wAddRupeeBufferLow]
	sub e
	ld [wAddRupeeBufferLow], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	ld a, [wRupeeCountLow]
	add e
	daa
	ld [wRupeeCountLow], a
	ld a, [wRupeeCountHigh]
	adc $00
	daa
	ld [wRupeeCountHigh], a
	cp $10
	jr c, jr_002_5f71

	ld a, $09
	ld [wRupeeCountHigh], a
	ld a, $99
	ld [wRupeeCountLow], a
	xor a
	ld [wAddRupeeBufferHigh], a
	ld [wAddRupeeBufferLow], a

jr_002_5f71:
	call Call_02_5FD1

jr_002_5f74:
	ld hl, wSubtractRupeeBufferHigh
	ld a, [wSubtractRupeeBufferLow]
	or [hl]
	jr z, jr_002_5fd0

	ld a, $05
	ldh [hWaveSfx], a
	ld a, [wSubtractRupeeBufferLow]
	ld e, a
	ld a, [wSubtractRupeeBufferHigh]
	sla e
	rla
	sla e
	rla
	sla e
	rla
	inc a
	cp $0a
	jr c, jr_002_5f98

	ld a, $09

jr_002_5f98:
	ld e, a
	ld a, [wSubtractRupeeBufferLow]
	sub e
	ld [wSubtractRupeeBufferLow], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	ld a, [wRupeeCountLow]
	ld hl, wRupeeCountHigh
	or [hl]
	jr z, jr_002_5fd0

	ld a, [wRupeeCountLow]
	sub e
	daa
	ld [wRupeeCountLow], a
	ld a, [wRupeeCountHigh]
	sbc $00
	daa
	ld [wRupeeCountHigh], a
	jr nc, jr_002_5fcd

	xor a
	ld [wRupeeCountHigh], a
	ld [wRupeeCountLow], a
	ld [wSubtractRupeeBufferHigh], a
	ld [wSubtractRupeeBufferLow], a

jr_002_5fcd:
	call Call_02_5FD1

jr_002_5fd0:
	ret


Call_02_5FD1::
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $06
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, de
	ld a, $9c
	ld [hli], a
	ld a, $2a
	ld [hli], a
	ld a, $02
	ld [hli], a
	push hl
	ld a, [wRupeeCountHigh]
	and $0f
	ld e, a
	add $b0
	pop hl
	ld [hli], a
	push hl
	ld a, [wRupeeCountLow]
	swap a
	and $0f
	add $b0
	pop hl
	ld [hli], a
	push hl
	ld a, [wRupeeCountLow]
	and $0f
	add $b0
	pop hl
	ld [hli], a
	ld a, $00
	ld [hli], a
	ret


LowHealthThresholds::
	db $05, $05, $05, $09, $09, $09, $11, $11, $11, $19, $19, $19

Call_02_601A::
	xor a
	ld [wLowHealth], a
	ld a, [wMaxHearts]
	ld e, a
	ld d, $00
	ld hl, $600b
	add hl, de
	ld a, [wHealth]
	cp [hl]
	jr nc, jr_002_6045

	ld a, $01
	ld [wLowHealth], a
	ld a, [wLowHealthBeepTimer]
	dec a
	cp $ff
	jr nz, jr_002_6042

	ld a, $30
	ld hl, hWaveSfx
	ld [hl], $04

jr_002_6042:
	ld [wLowHealthBeepTimer], a

jr_002_6045:
	ldh a, [hFrameCounter]
	and $01
	jr z, jr_002_60a5

	ld a, [wDrawCommandsSize]
	and a
	jr nz, jr_002_60a5

	ld a, [wAddHealthBuffer]
	and a
	jr z, jr_002_6088

	dec a
	ld [wAddHealthBuffer], a
	ld a, [wMaxHearts]
	cp $0f
	jr c, jr_002_6064

	ld a, $0e

jr_002_6064:
	sla a
	sla a
	sla a
	ld e, a
	ld a, [wHealth]
	cp e
	jr nz, jr_002_6077

	xor a
	ld [wAddHealthBuffer], a
	jr jr_002_6088

jr_002_6077:
	inc a
	ld [wHealth], a
	and $07
	cp $06
	jr nz, jr_002_6085

	ld a, $06
	ldh [hWaveSfx], a

jr_002_6085:
	jp Call_02_6117


jr_002_6088:
	ld a, [wSubtractHealthBuffer]
	and a
	jr z, jr_002_60a5

	dec a
	ld [wSubtractHealthBuffer], a
	ld a, [wHealth]
	and a
	jr z, jr_002_609c

	dec a
	ld [wHealth], a

jr_002_609c:
	call Call_02_6117
	ld a, [wHealth]
	and a
	jr z, jr_002_60a6

jr_002_60a5:
	ret


jr_002_60a6:
	ld a, [wMedicineCount]
	and a
	jr z, jr_002_6101

	dec a
	ld [wMedicineCount], a
	ld a, $08
	ld [wHealth], a
	ld a, [wAddHealthBuffer]
	add $80
	ld [wAddHealthBuffer], a
	ld a, $a0
	ld [wInvincibilityCounter], a
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $04
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, de
	ld a, $9c
	ld [hli], a
	ld a, $93
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, [wMedicineCount]
	add $b0
	cp $b0
	jr z, jr_002_60e7

	ld [hli], a
	xor a
	ld [hl], a
	ret


jr_002_60e7:
	ld a, $7f
	ld [hli], a
	ld a, $9c
	ld [hli], a
	ld a, $72
	ld [hli], a
	ld a, $c1
	ld [hli], a
	ld a, $7f
	ld [hli], a
	xor a
	ld [hl], a
	ld a, [wDrawCommandsSize]
	add $04
	ld [wDrawCommandsSize], a
	ret


jr_002_6101:
	ret


HeartRowsBlankCommand::
	db $9c, $0d, $06, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $9c, $2d, $06, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $00

Call_02_6117::
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $14
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, de
	push de
	ld bc, $6102
	ld e, $15

jr_002_612c:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_002_612c

	nop
	nop
	nop
	nop
	pop de
	ld hl, $d604
	add hl, de
	ld c, $00
	ld a, [wHealth]
	and a
	jr z, jr_002_6165

	ldh [hMultiPurpose0], a

jr_002_6145:
	ldh a, [hMultiPurpose0]
	sub $08
	ldh [hMultiPurpose0], a
	jr c, jr_002_615c

	ld a, $a9
	ld [hli], a
	inc c
	ld a, c
	cp $07
	jr nz, jr_002_615a

	ld a, l
	add $03
	ld l, a

jr_002_615a:
	jr jr_002_6145

jr_002_615c:
	add $08
	jr z, jr_002_6165

	ld a, $ce
	ld [hli], a
	jr jr_002_616e

jr_002_6165:
	ld a, [wMaxHearts]
	cp c
	jr z, jr_002_617a

	ld a, $cd
	ld [hli], a

jr_002_616e:
	inc c
	ld a, c
	cp $07
	jr nz, jr_002_6178

	ld a, l
	add $03
	ld l, a

jr_002_6178:
	jr jr_002_6165

jr_002_617a:
	ret


ItemSlotTiles::
	db $7f, $7f, $7f, $7f, $7f, $7f, $84, $7f, $7f, $85, $ba, $7f, $80, $7f, $7f, $81
	db $7f, $7f, $82, $7f, $7f, $83, $ba, $7f, $86, $7f, $7f, $87, $ba, $7f, $88, $7f
	db $7f, $89, $7f, $7f, $8a, $7f, $7f, $8b, $7f, $7f, $8c, $7f, $7f, $8d, $7f, $7f
	db $98, $7f, $7f, $99, $7f, $7f, $90, $7f, $7f, $91, $7f, $7f, $92, $7f, $7f, $93
	db $7f, $7f, $96, $7f, $7f, $97, $7f, $7f, $8e, $7f, $7f, $8f, $7f, $7f, $a4, $7f
	db $7f, $a5, $7f, $7f

ItemSlotVRAMAddresses::
	db $9c, $01, $9c, $06, $9c, $61, $9c, $65, $9c, $c1, $9c, $c5
	db $9d, $21, $9d, $25, $9d, $81, $9d, $85, $9d, $e1, $9d, $e5

Call_02_61E7::
	ld c, $01
	ld b, $00
	ld e, $ff

Call_02_61ED::
	ld a, [$0004]
	and a
	ret nz

	push de
	push bc
	ld hl, wItemB
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
	sla a
	ld e, a
	sla a
	add e
	ldh [hMultiPurpose0], a
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0c
	ld [wDrawCommandsSize], a
	push hl
	sla c
	ld hl, $61cf
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, $02
	ld [hli], a
	ldh a, [hMultiPurpose0]
	ld c, a
	push hl
	ld hl, $617b
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	pop bc
	push bc
	push hl
	sla c
	ld hl, $61cf
	add hl, bc
	push hl
	pop de
	pop hl
	inc de
	inc hl
	ld a, [de]
	add $20
	ld [hl], a
	dec de
	dec hl
	ld a, [de]
	inc de
	inc de
	adc $00
	ld [hli], a
	inc hl
	ld a, $02
	ld [hli], a
	ldh a, [hMultiPurpose0]
	ld c, a
	push hl
	ld hl, $617e
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	call Call_02_6273
	xor a
	ld [hl], a
	pop bc
	pop de
	dec c
	ld a, c
	cp e
	jp nz, Call_02_61ED

	ret


Call_02_6273::
	ldh a, [hMultiPurpose1]
	cp $09
	jr z, jr_002_62b5

	cp $0c
	jr z, jr_002_62aa

	dec a
	jr z, jr_002_629d

	dec a
	jr z, jr_002_62cf

	dec a
	jr z, jr_002_6293

	dec a
	jr z, jr_002_6298

	dec a
	jr z, jr_002_62ca

Jump_002_628c:
jr_002_628c:
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ret


jr_002_6293:
	ld a, [wPowerBraceletLevel]
	jr jr_002_62a0

jr_002_6298:
	ld a, [wShieldLevel]
	jr jr_002_62a0

jr_002_629d:
	ld a, [wSwordLevel]

jr_002_62a0:
	add $b0
	ld c, a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, c
	inc de
	ld [hli], a
	ret


jr_002_62aa:
	ld a, [wHasToadstool]
	and a
	jr nz, jr_002_628c

	ld a, [wMagicPowderCount]
	jr Call_02_62D2

jr_002_62b5:
	ld a, [wOcarinaSongFlags]
	and a
	jp z, Jump_002_628c

	ld a, [wSelectedSong]
	inc a
	swap a
	call Call_02_62D2
	dec hl
	ld [hl], $7f
	inc hl
	ret


jr_002_62ca:
	ld a, [wArrowCount]
	jr Call_02_62D2

jr_002_62cf:
	ld a, [wBombCount]

Call_02_62D2::
	push af
	and $0f
	add $b0
	ld c, a
	pop af
	swap a
	and $0f
	add $b0
	ld [hli], a
	ld a, c
	ld [hli], a
	ret


SubscreenStaticCommands::
	db $9c, $6a, $83, $94, $95, $c0, $c1, $9c, $6c, $83, $a0, $a1, $c2, $c3, $9c, $6e
	db $83, $9a, $9b, $c4, $c5, $9c, $6f, $81, $9c, $9d, $9c, $b0, $81, $c6, $c7, $9c
	db $71, $81, $9e, $9f, $9c, $b2, $81, $ca, $cb, $9c, $92, $01, $7f, $7f, $9c, $d3
	db $00, $7f, $00

SubscreenSlotOffsets::
	db $03, $0a, $11, $22, $05, $0c, $13, $1d, $27

Call_02_631F::
	ld hl, wDrawCommand
	ld bc, $62e3
	ld e, $33

jr_002_6327:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_002_6327

	ld de, wHasFlippers
	ld bc, $0000

jr_002_6333:
	ld a, c
	cp $02
	jr nz, jr_002_633f

	ld a, [wTradeSceneState]
	and a
	ld a, c
	jr nz, jr_002_635f

jr_002_633f:
	cp $04
	jr nz, jr_002_6357

	ld a, [wIsIndoor]
	and a
	jr z, jr_002_6354

	ldh a, [hMapId]
	cp $0a
	jr nc, jr_002_6354

	ld de, wDungeonHasMap
	jr jr_002_6357

jr_002_6354:
	ld de, $db11

jr_002_6357:
	ld a, [de]
	cp $ff
	jr z, jr_002_635f

	and a
	jr nz, jr_002_637e

jr_002_635f:
	push de
	ld hl, $6316
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	ld a, $7f
	ld [hli], a
	ld [hli], a
	ld a, c
	cp $02
	jr nz, jr_002_637d

	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, $7f
	ld [hli], a
	ld [hl], a

jr_002_637d:
	pop de

jr_002_637e:
	inc de
	inc c
	ld a, c
	cp $09
	jr nz, jr_002_6333

	ld hl, wDrawCommand
	ld de, $002c
	add hl, de
	ld a, [$db0f]
	and a
	jr z, jr_002_63a0

	ld e, a
	swap a
	and $0f
	add $b0
	ld [hli], a
	ld a, e
	and $0f
	add $b0
	ld [hli], a

jr_002_63a0:
	ld hl, wDrawCommand
	ld de, $0031
	add hl, de
	ld a, [wIsIndoor]
	and a
	jr z, jr_002_63bb

	ldh a, [hMapId]
	cp $0a
	jr nc, jr_002_63bb

	ld a, [wDungeonSmallKeys]
	and a
	jr z, jr_002_63c8

	jr jr_002_63c5

jr_002_63bb:
	ld a, [wGoldenLeaves]
	and a
	jr z, jr_002_63c8

	cp $06
	jr nc, jr_002_63c8

jr_002_63c5:
	add $b0
	ld [hl], a

jr_002_63c8:
	ld a, $32
	ld [wDrawCommandsSize], a
	ret


SubscreenCursorX::
	db $0f, $37, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f

SubscreenCursorY::
	db $0e, $0e, $26, $26
	db $3e, $3e, $56, $56, $6e, $6e, $86, $86

Call_02_63E6::
	ld a, [wBGPalette]
	cp $e4
	ret c

	ld d, $02
	jr jr_002_63f2

Call_02_63F0::
	ld d, $0c

jr_002_63f2:
	ld hl, wItemB
	ld e, $00

jr_002_63f7:
	ld a, [hli]
	cp $01
	jr z, jr_002_6402

	inc e
	ld a, e
	cp d
	jr nz, jr_002_63f7

	ret


jr_002_6402:
	ld d, $00
	ld hl, $63ce
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld hl, $63da
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
	ld a, [wActivePowerUp]
	dec a
	jr nz, jr_002_6444

	ldh a, [hFrameCounter]
	and $08
	jr nz, jr_002_6444

	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ld a, [$c1b5]
	and a
	jr z, jr_002_6431

	ld hl, $c09c

jr_002_6431:
	ld a, [wWindowY]
	push hl
	ld hl, hMultiPurpose1
	add [hl]
	pop hl
	ld [hli], a
	ldh a, [hMultiPurpose0]
	ld [hli], a
	ld a, $04
	ld [hli], a
	ld a, $50
	ld [hli], a

jr_002_6444:
	ld a, $01
	call Call_3DD0
	ret


SubscreenSelectorX::
	db $07, $27, $07, $27, $07, $27, $07, $27, $07, $27

SubscreenSelectorY::
	db $28, $28, $40, $40, $58, $58
	db $70, $70, $88, $88

Call_02_645E::
	ld a, [wIsIndoor]
	and a
	jr z, jr_002_64b8

	ldh a, [hMapId]
	cp $08
	jp nc, Jump_002_64bb

	ld a, [wMinimapLinkCell]
	and $f8
	add $58
	ld h, a
	ld a, [wMinimapLinkCell]
	rla
	rla
	rla
	and $38
	add $57
	ld l, a
	ld a, [wMinimapLayout]
	and $20
	jr z, jr_002_6492

	ld a, [wMinimapLinkCell]
	and $38
	cp $20
	jr nc, jr_002_6492

	ld a, h
	sub $08
	ld h, a

jr_002_6492:
	ld a, [wMinimapLayout]
	and $10
	jr z, jr_002_64a6

	ld a, [wMinimapLinkCell]
	and $07
	cp $04
	jr c, jr_002_64a6

	ld a, l
	add $08
	ld l, a

jr_002_64a6:
	ld a, h
	ld [wOAMBuffer], a
	ld a, l
	ld [$c001], a
	ld a, $3f
	ld [$c002], a
	ldh a, [hFrameCounter]
	rla
	and $10

jr_002_64b8:
	ld [$c003], a

Jump_002_64bb:
	call Call_02_6505
	call Call_02_6742
	ld a, [$c159]
	inc a
	ld [$c159], a
	and $10
	jr nz, jr_002_64fc

	ld a, [$dba3]
	ld e, a
	ld d, $00
	ld hl, $6454
	add hl, de
	ld a, [hl]
	ld [$c004], a
	ld [$c008], a
	ld hl, $644a
	add hl, de
	ld a, [hl]
	ld [$c005], a
	add $20
	ld [$c009], a
	ld a, $be
	ld [$c006], a
	ld [$c00a], a
	ld a, $30
	ld [$c007], a
	ld a, $10
	ld [$c00b], a

jr_002_64fc:
	ret


CursorStepX::
	db $00, $01, $ff, $00

CursorStepY::
	db $00, $fe, $02, $00

Call_02_6505::
	ld a, [$dba3]
	ld [$c1b6], a
	ld a, [$c1b8]
	ld hl, $c1b9
	or [hl]
	jr nz, jr_002_655e

	ld a, [$c1b5]
	and a
	jr nz, jr_002_653a

	ldh a, [hJoypadPressed]
	and $03
	ld e, a
	ld d, $00
	ld hl, $64fd
	add hl, de
	ld a, [$dba3]
	add [hl]
	ld [$dba3], a
	cp $0a
	jr c, jr_002_653a

	rla
	ld a, $00
	jr nc, jr_002_6537

	ld a, $09

jr_002_6537:
	ld [$dba3], a

jr_002_653a:
	ldh a, [hJoypadPressed]
	srl a
	srl a
	and $03
	ld e, a
	ld d, $00
	ld hl, $6501
	add hl, de
	ld a, [$dba3]
	add [hl]
	ld [$dba3], a
	cp $0a
	jr c, jr_002_655e

	rla
	ld a, $00
	jr nc, jr_002_655b

	ld a, $09

jr_002_655b:
	ld [$dba3], a

jr_002_655e:
	ldh a, [hJoypadHeld]
	and $0f
	jr z, jr_002_656e

	ld a, [$c1b5]
	and a
	jr nz, jr_002_656e

	xor a
	ld [$c159], a

jr_002_656e:
	ld a, [$c1b5]
	and a
	jr z, jr_002_658a

	ld a, [$c1b8]
	ld hl, $c1b9
	or [hl]
	jr nz, jr_002_658a

	ldh a, [hJoypadPressed]
	and $80
	jr z, jr_002_658a

	ld a, $01
	ld [$c1ba], a
	jr jr_002_65b7

jr_002_658a:
	ld a, [$dba3]
	ld hl, $c1b6
	cp [hl]
	jr z, jr_002_65c6

	ld hl, hJingle
	ld [hl], $0a
	ld e, a
	ld d, $00
	ld hl, $db02
	add hl, de
	ld a, [hl]
	cp $09
	jr nz, jr_002_65b7

	ld a, [wOcarinaSongFlags]
	and a
	jr z, jr_002_65b7

	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
	ld a, $10
	ld [$c1b8], a
	ld a, $01
	jr jr_002_65c3

jr_002_65b7:
	ld a, [$c1b5]
	and a
	jr z, jr_002_65c6

	ld a, $10
	ld [$c1b9], a
	xor a

jr_002_65c3:
	ld [$c1b5], a

jr_002_65c6:
	ld hl, $c1b9
	ld a, [$c1b8]
	or [hl]
	jp nz, Jump_002_667b

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_002_661e

	ld a, [wItemA]
	push af
	ld hl, $db02
	ld a, [$dba3]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [wItemA], a
	pop af
	ld [hl], a
	cp $09
	jr nz, jr_002_6604

	ld a, [wOcarinaSongFlags]
	and a
	jr z, jr_002_6604

	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
	ld a, $10
	ld [$c1b8], a
	ld a, $01
	ld [$c1b5], a
	jr jr_002_6613

jr_002_6604:
	ld a, [$c1b5]
	and a
	jr z, jr_002_6613

	xor a
	ld [$c1b5], a
	ld a, $10
	ld [$c1b9], a

jr_002_6613:
	ld c, $01
	ld b, $00
	ld e, $00
	call Call_02_61ED
	jr Call_02_666A

jr_002_661e:
	ldh a, [hJoypadPressed]
	and $20
	jr z, jr_002_667b

	ld a, [wItemB]
	push af
	ld hl, $db02
	ld a, [$dba3]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [wItemB], a
	pop af
	ld [hl], a
	cp $09
	jr nz, jr_002_6652

	ld a, [wOcarinaSongFlags]
	and a
	jr z, jr_002_6652

	ld a, $10
	ld [$c1b8], a
	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
	ld a, $01
	ld [$c1b5], a
	jr jr_002_6661

jr_002_6652:
	ld a, [$c1b5]
	and a
	jr z, jr_002_6661

	xor a
	ld [$c1b5], a
	ld a, $10
	ld [$c1b9], a

jr_002_6661:
	ld c, $00
	ld b, $00
	ld e, $ff
	call Call_02_61ED

Call_02_666A::
	ld a, $13
	ldh [hJingle], a
	ld a, [$dba3]
	add $02
	ld c, a
	ld b, $00
	dec a
	ld e, a
	call Call_02_61ED

Jump_002_667b:
jr_002_667b:
	ret


SongMenuSprites::
	db $f8, $f0, $22, $00, $f8, $f8, $22, $20, $f8, $00, $24, $00, $f8, $08, $24, $20
	db $f8, $10, $26, $00, $f8, $18, $26, $20, $08, $f0, $20, $00, $08, $f8, $20, $00
	db $08, $00, $20, $00, $08, $08, $20, $00, $08, $10, $20, $00, $08, $18, $20, $00
	db $fb, $f4, $20, $00, $fb, $fc, $20, $20, $fb, $00, $20, $00, $fb, $08, $20, $20
	db $fb, $0c, $20, $00, $fb, $14, $20, $20, $05, $f4, $20, $00, $05, $fc, $20, $00
	db $05, $00, $20, $00, $05, $08, $20, $00, $05, $0c, $20, $00, $05, $14, $20, $00
	db $fd, $f8, $20, $00, $fd, $10, $20, $20, $fd, $00, $20, $00, $fd, $08, $20, $20
	db $fd, $08, $20, $00, $fd, $10, $20, $20, $03, $f8, $20, $00, $03, $10, $20, $00
	db $03, $00, $20, $00, $03, $08, $20, $00, $03, $08, $20, $00, $03, $10, $20, $00
	db $00, $00, $20, $00, $00, $08, $20, $20, $00, $00, $20, $00, $00, $08, $20, $20
	db $00, $00, $20, $00, $00, $08, $20, $20, $00, $00, $20, $00, $00, $08, $20, $00
	db $00, $00, $20, $00, $00, $08, $20, $00, $00, $00, $20, $00, $00, $08, $20, $00
SongMenuNoteX::
	db $50, $60, $70

SongMenuSongBits::
	db $04, $02, $01

Call_02_6742::
	ld a, [$c1b9]
	and a
	jr z, jr_002_6764

	dec a
	ld [$c1b9], a
	jr nz, jr_002_6761

	ld hl, hNeedsUpdatingBGTiles
	ld [hl], $0b
	ld a, [$c1ba]
	and a
	jr z, jr_002_6760

	xor a
	ld [$c1ba], a
	jp Jump_002_5e3c


jr_002_6760:
	ret


jr_002_6761:
	cpl
	jr jr_002_676e

jr_002_6764:
	ld a, [$c1b8]
	and a
	jr z, jr_002_6774

	dec a
	ld [$c1b8], a

jr_002_676e:
	rra
	rra
	and $03
	jr jr_002_677d

jr_002_6774:
	ld a, [$c1b5]
	and a
	jp z, Jump_002_684a

	ld a, $00

jr_002_677d:
	ld [$c1b7], a
	ld a, [$c1b7]
	ld d, $00
	sla a
	sla a
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld hl, $667c
	add hl, de
	ld de, $c018
	ld c, $0c
	ld b, $04

jr_002_679d:
	ld a, [hli]
	add $30
	ld [de], a
	inc de
	ld a, [hli]
	add $60
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	cp $22
	jr z, jr_002_67b8

	cp $24
	jr z, jr_002_67bc

	cp $26
	jr z, jr_002_67c0

	jr jr_002_67cd

jr_002_67b8:
	ld b, $04
	jr jr_002_67c2

jr_002_67bc:
	ld b, $02
	jr jr_002_67c2

jr_002_67c0:
	ld b, $01

jr_002_67c2:
	ld a, [wOcarinaSongFlags]
	and b
	jr nz, jr_002_67cd

	dec de
	ld a, $20
	ld [de], a
	inc de

jr_002_67cd:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_002_679d

	ld a, [$c1b7]
	cp $00
	jr nz, jr_002_684a

	ldh a, [hJoypadPressed]
	and $41
	jr z, jr_002_67f8

jr_002_67e0:
	ld hl, wSelectedSong
	ld a, [hl]
	inc a
	cp $03
	jr nz, jr_002_67ea

	xor a

jr_002_67ea:
	ld [hl], a
	ld e, a
	ld d, $00
	ld hl, $673f
	add hl, de
	ld a, [wOcarinaSongFlags]
	and [hl]
	jr z, jr_002_67e0

jr_002_67f8:
	ldh a, [hJoypadPressed]
	and $02
	jr z, jr_002_6817

jr_002_67fe:
	ld hl, wSelectedSong
	ld a, [hl]
	dec a
	cp $80
	jr c, jr_002_6809

	ld a, $02

jr_002_6809:
	ld [hl], a
	ld e, a
	ld d, $00
	ld hl, $673f
	add hl, de
	ld a, [wOcarinaSongFlags]
	and [hl]
	jr z, jr_002_67fe

jr_002_6817:
	ld a, [wSelectedSong]
	ldh a, [hJoypadPressed]
	and $43
	jr z, jr_002_6823

	call Call_02_666A

jr_002_6823:
	ld hl, $c010
	ld a, $38
	ld [hli], a
	push hl
	ld a, [wSelectedSong]
	ld e, a
	ld d, $00
	ld hl, $673c
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push af
	ld a, $28
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $38
	ld [hli], a
	pop af
	add $08
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld [hl], $20

Jump_002_684a:
jr_002_684a:
	ret


DungeonMinimaps::
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $7d, $7d, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ef, $ef, $ef, $7d, $7d, $ee, $7d
	db $ed, $7d, $ef, $ed, $ef, $ed, $ef, $7d, $ef, $ef, $ed, $ed, $ef, $ef, $ef, $7d
	db $ef, $7d, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ed, $ed, $ef, $ef, $ef, $7d
	db $7d, $7d, $ed, $7d, $7d, $ed, $7d, $7d, $7d, $ef, $ef, $7d, $7d, $ef, $ee, $7d
	db $7d, $ef, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ed, $7d, $7d, $7d, $7d, $ef, $7d
	db $7d, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $ed, $ed, $ed, $ed, $7d, $7d
	db $ef, $ef, $ed, $ef, $7d, $7d, $7d, $7d, $ed, $ef, $ed, $ed, $7d, $7d, $7d, $7d
	db $ef, $ef, $ef, $ef, $7d, $7d, $ef, $7d, $7d, $ed, $ef, $7d, $7d, $ef, $ef, $ef
	db $7d, $ed, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ed, $ed, $7d, $7d, $7d, $ef, $7d
	db $7d, $ed, $7d, $7d, $7d, $7d, $ee, $7d, $7d, $ef, $ed, $7d, $7d, $7d, $ef, $ef
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ef, $7d, $7d, $7d
	db $7d, $ef, $7d, $ef, $ef, $7d, $ed, $7d, $7d, $ee, $ef, $ed, $ef, $ed, $ef, $7d
	db $7d, $ef, $ed, $ed, $ef, $ef, $ed, $7d, $7d, $7d, $ef, $ef, $ef, $ed, $7d, $7d
	db $7d, $7d, $ed, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ed, $7d, $7d, $7d
	db $7d, $ef, $ef, $ef, $ed, $ef, $7d, $7d, $7d, $7d, $7d, $ee, $7d, $ef, $ed, $7d
	db $7d, $ef, $ef, $ef, $ef, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef
	db $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $ed, $ef, $ef, $ef, $7d, $7d
	db $7d, $7d, $7d, $ed, $ef, $ef, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ef, $ed, $ef
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $7d, $7d, $7d, $7d, $7d, $7d, $ed
	db $ef, $ed, $7d, $ef, $ef, $7d, $ed, $ef, $ef, $ed, $ef, $ef, $ee, $ef, $ed, $ef
	db $ed, $ef, $7d, $ef, $ef, $7d, $ef, $ef, $7d, $ef, $ed, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ed, $7d, $7d, $ef, $ed, $7d, $7d, $ef, $ef, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $ee, $ef, $7d
	db $ef, $ef, $ef, $ed, $7d, $ef, $ef, $7d, $ef, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $ed, $ef, $ef, $ed, $7d, $ef, $ed, $7d, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ed
	db $ed, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ef, $7d
	db $7d, $7d, $7d, $ef, $ef, $7d, $7d, $7d, $ed, $7d, $7d, $ee, $ed, $7d, $7d, $ed
	db $ef, $ef, $ed, $ef, $ef, $ed, $ef, $ef, $7d, $ed, $ef, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ed, $ef, $ed, $ef, $ef, $ef, $ef
	db $ef, $ed, $ef, $ef, $ef, $ed, $ef, $ef, $ed, $7d, $7d, $ef, $ef, $7d, $7d, $ed
DungeonMinimapEagleTowerAlt::
	db $7d, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $7d
	db $ef, $ef, $ef, $ed, $7d, $7d, $7d, $7d, $ef, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $ed, $ef, $ef, $ed, $7d, $ef, $ed, $7d, $ef, $ef, $ef, $ef, $ef, $ee, $ef, $ef
	db $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ef, $7d
MinimapRoomTypeTiles::
	db $00, $02, $03, $07, $05, $0a, $0b, $0f, $04, $08, $09, $0e, $06, $0c, $0d, $01

Call_02_6A9B::
	ldh a, [hMapRoom]
	cp $e8
	ret z

	ld hl, $684b
	ldh a, [hMapId]
	swap a
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	add hl, de
	ldh a, [hMapId]
	cp $06
	jr nz, jr_002_6ac3

	ld a, [wDungeon7Flags]
	and $04
	jr z, jr_002_6ac3

	ld hl, $6a4b

jr_002_6ac3:
	ld de, $d480
	ld bc, $0040
	call CopyData
	ld d, $00
	ld e, $00

Jump_002_6ad0:
	ld hl, $d480
	add hl, de
	ld a, [hl]
	cp $7d
	jr z, jr_002_6b3e

	cp $ed
	jr z, jr_002_6ae1

	cp $ee
	jr nz, jr_002_6ae9

jr_002_6ae1:
	ld a, [wDungeonHasCompass]
	and a
	jr nz, jr_002_6af4

	ld [hl], $ef

jr_002_6ae9:
	ld a, [wDungeonHasMap]
	and a
	jr nz, jr_002_6af4

	ld [hl], $7d
	jp Jump_002_6b3e


jr_002_6af4:
	push de
	call GetDungeonRoomStatusAddress
	push de
	pop bc
	pop de
	ld a, [hl]
	bit 7, a
	jr z, jr_002_6b3e

	ld a, [hl]
	and $0f
	ld c, a
	ld b, $00
	ld hl, $6a8b
	add hl, bc
	ld a, [hl]
	inc a
	add $cf
	ld c, a
	ld hl, $d480
	add hl, de
	ld a, [hl]
	cp $ee
	jr z, jr_002_6b1c

	cp $ed
	jr nz, jr_002_6b31

jr_002_6b1c:
	push de
	push af
	call GetDungeonRoomStatusAddress
	pop af
	ld e, $20
	cp $ed
	jr nz, jr_002_6b2a

	ld e, $10

jr_002_6b2a:
	ld a, [hl]
	and e
	pop de
	cp $00
	jr z, jr_002_6b3e

jr_002_6b31:
	ld hl, $d480
	add hl, de
	ld [hl], c
	ld a, [wDungeonHasMap]
	and a
	jr nz, jr_002_6b3e

	ld [hl], $7d

Jump_002_6b3e:
jr_002_6b3e:
	inc e
	ld a, e
	cp $40
	jp nz, Jump_002_6ad0

	ret


Call_02_6B46::
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

JumpTable_02_6B4E::
	dw Jump_02_6B56
	dw Jump_02_6B5B
	dw Jump_02_6B60
	dw Jump_02_6B65

Jump_02_6B56::
	ld hl, $9d2e
	jr jr_002_6b68

Jump_02_6B5B::
	ld hl, $9d2f
	jr jr_002_6b68

Jump_02_6B60::
	ld hl, $9d0e
	jr jr_002_6b68

Jump_02_6B65::
	ld hl, $9d0f

jr_002_6b68:
	ld e, $04
	jr jr_002_6bbd

Call_02_6B6C::
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

JumpTable_02_6B74::
	dw Jump_02_6B7C
	dw Jump_02_6B81
	dw Jump_02_6B86
	dw Jump_02_6B8B

Jump_02_6B7C::
	ld hl, $9dae
	jr jr_002_6b8e

Jump_02_6B81::
	ld hl, $9daf
	jr jr_002_6b8e

Jump_02_6B86::
	ld hl, $9dae
	jr jr_002_6b8e

Jump_02_6B8B::
	ld hl, $9daf

jr_002_6b8e:
	ld e, $24
	jr jr_002_6bbd

Call_02_6B92::
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

JumpTable_02_6B9A::
	dw Jump_02_6BA2
	dw Jump_02_6BA7
	dw Jump_02_6BAC
	dw Jump_02_6BB1

Jump_02_6BA2::
	ld hl, $9d2a
	jr jr_002_6bb4

Jump_02_6BA7::
	ld hl, $9d2a
	jr jr_002_6bb4

Jump_02_6BAC::
	ld hl, $9d0a
	jr jr_002_6bb4

Jump_02_6BB1::
	ld hl, $9d0a

jr_002_6bb4:
	ld e, $00
	jr jr_002_6bbd

Call_02_6BB8::
	ld hl, $9daa
	ld e, $20

jr_002_6bbd:
	ld c, $00
	ld d, c

jr_002_6bc0:
	push hl
	ld hl, $d480
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	inc e
	inc c
	ld a, c
	cp $10
	jr z, jr_002_6be2

	inc hl
	and $03
	jr nz, jr_002_6bc0

	ld a, e
	add $04
	ld e, a
	ld a, l
	add $1c
	ld l, a
	ld a, $00
	adc h
	ld h, a
	jr jr_002_6bc0

jr_002_6be2:
	ret


LadderSpeedX::
	db $00, $08, $f8

LadderSpeedY::
	db $00, $f0, $10

SideViewSpeedX::
	db $00, $10, $f0

SideViewDirections::
	db $ff, $00, $01

Call_02_6BEF::
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_002_6bff

	ldh a, [hLinkInteractiveMotionBlocked]
	cp $01
	jr z, jr_002_6c1b

	cp $02
	jr z, jr_002_6c1b

jr_002_6bff:
	ld a, [wLinkPushedTimer]
	and a
	jr z, jr_002_6c1c

	dec a
	ld [wLinkPushedTimer], a
	call ApplyLinkSpeed
	call Call_02_6FB1
	ldh a, [hLinkMotionStep]
	cp $02
	jr z, jr_002_6c1b

	ldh a, [hLinkSpeedY]
	add $03
	ldh [hLinkSpeedY], a

jr_002_6c1b:
	ret


jr_002_6c1c:
	ldh a, [hLinkMotionStep]
	rst $00

JumpTable_02_6C1F::
	dw Jump_02_6D3A
	dw Jump_02_6CDA
	dw Jump_02_6C48

SideViewSwimSpeedX::
	db $00, $08, $f8, $00, $00, $06, $fa, $00, $00, $06, $fa, $00, $00, $00, $00, $00
SideViewSwimSpeedY::
	db $00, $00, $00, $00, $f8, $fa, $fa, $00, $08, $06, $06, $00, $00, $00, $00, $00
SideViewSwimDirections::
	db $00, $00, $01

Jump_02_6C48::
	ldh a, [hMapId]
	cp $07
	jr nz, jr_002_6c63

	call Call_02_79D9
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a
	ld a, $03
	ldh [hWaveSfx], a
	ld a, $80
	ld [wInvincibilityCounter], a
	ret


jr_002_6c63:
	ld a, [wHasFlippers]
	and a
	jp z, Call_02_79D9

	ld hl, hLinkDirection
	res 1, [hl]
	call ResetPegasusBoots
	ld [wIsLinkInTheAir], a
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_002_6ca6

	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $6c25
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedX
	sub [hl]
	jr z, jr_002_6c94

	inc [hl]
	bit 7, a
	jr z, jr_002_6c94

	dec [hl]
	dec [hl]

jr_002_6c94:
	ld hl, $6c35
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedY
	sub [hl]
	jr z, jr_002_6ca6

	inc [hl]
	bit 7, a
	jr z, jr_002_6ca6

	dec [hl]
	dec [hl]

jr_002_6ca6:
	ld hl, wLinkWalkingFrameCount
	inc [hl]
	ldh a, [hJoypadHeld]
	and $03
	jr z, jr_002_6cba

	ld e, a
	ld d, $00
	ld hl, $6c45
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a

jr_002_6cba:
	call ApplyLinkSpeed
	call Call_02_6FB1
	ld a, [wInventoryAppearing]
	and a
	ret nz

	ldh a, [hMultiPurpose0]
	cp $b0
	jr z, jr_002_6cd6

	cp $b1
	jr nz, jr_002_6cd3

	ld a, $01
	jr jr_002_6cd4

jr_002_6cd3:
	xor a

jr_002_6cd4:
	ldh [hLinkMotionStep], a

jr_002_6cd6:
	call Call_02_6E8F
	ret


Jump_02_6CDA::
	call ResetPegasusBoots
	ld [wIsLinkInTheAir], a
	ld [wJumpAnimationCounter], a
	ld [wJumpAnimationFrame], a
	ldh a, [hJoypadHeld]
	and $03
	ld e, a
	ld d, $00
	ld hl, $6be3
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
	ld e, a
	ld hl, $6be6
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	ld a, $02
	ldh [hLinkDirection], a
	ldh a, [hJoypadHeld]
	and $0f
	jr z, jr_002_6d10

	ld hl, wLinkWalkingFrameCount
	inc [hl]

jr_002_6d10:
	call ApplyLinkSpeed
	call Call_02_6FB1
	ld a, [wInventoryAppearing]
	and a
	ret nz

	ldh a, [hMultiPurpose0]
	cp $b1
	jr z, jr_002_6d2c

	cp $b0
	jr nz, jr_002_6d29

	ld a, $02
	jr jr_002_6d2a

jr_002_6d29:
	xor a

jr_002_6d2a:
	ldh [hLinkMotionStep], a

jr_002_6d2c:
	call Call_02_6E8F
	ld a, [wLinkCollisionFlags]
	and $08
	jr z, jr_002_6d39

	xor a
	ldh [hLinkMotionStep], a

jr_002_6d39:
	ret


Jump_02_6D3A::
	ldh a, [hMapId]
	cp $06
	jr nz, jr_002_6d5d

	ldh a, [hMapRoom]
	cp $f8
	jr nz, jr_002_6d5d

	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_002_6d5d

	ldh a, [hLinkX]
	sub $46
	add $04
	cp $08
	jr nc, jr_002_6d5d

	ldh a, [hJoypadPressed]
	and $04
	jp nz, StartWarpFadeOutWithNoise

jr_002_6d5d:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_002_6d85

	ldh a, [hJoypadPressed]
	and $0f
	jr nz, jr_002_6d77

	ld a, [wLinkWalkingFrameCount]
	add $02
	ld [wLinkWalkingFrameCount], a
	call Call_145D
	jp Jump_002_6e14


jr_002_6d77:
	ld [wPegasusTurnButtons], a
	ld a, [wPegasusDustTimer]
	add $0c
	ld [wPegasusDustTimer], a
	call ResetSpinAttackAndDash

jr_002_6d85:
	ld a, [wLinkOnPlatform]
	and a
	jr nz, jr_002_6dcd

	ld a, [wLinkCollisionFlags]
	and $08
	jr nz, jr_002_6dcd

	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_002_6d9d

	ld a, $01
	ld [wIsLinkInTheAir], a

jr_002_6d9d:
	ld a, $0a
	ld [wLinkWalkingFrameCount], a
	ldh a, [hLinkSpeedX]
	and a
	jr z, jr_002_6dac

	rlca
	and $01
	ldh [hLinkDirection], a

jr_002_6dac:
	ldh a, [hJoypadHeld]
	and $03
	jr z, jr_002_6dcb

	ld e, a
	ld d, $00
	ld hl, $6be9
	add hl, de
	ldh a, [hLinkSpeedX]
	sub [hl]
	jr z, jr_002_6dcb

	ld e, $01
	bit 7, a
	jr nz, jr_002_6dc6

	ld e, $ff

jr_002_6dc6:
	ldh a, [hLinkSpeedX]
	add e
	ldh [hLinkSpeedX], a

jr_002_6dcb:
	jr jr_002_6e14

jr_002_6dcd:
	ld a, [wIsLinkInTheAir]
	and a
	jr z, jr_002_6de3

	ld a, $07
	ldh [hNoiseSfx], a
	call ResetPegasusBoots
	ld [wIsLinkInTheAir], a
	ld [wJumpAnimationFrame], a
	ld [wJumpAnimationCounter], a

jr_002_6de3:
	ldh a, [hJoypadHeld]
	and $03
	ld e, a
	ld d, $00
	ld hl, $6be9
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $6bec
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, jr_002_6e0a

	ld e, a
	ld a, [wSwordCooldown]
	and a
	jr nz, jr_002_6e04

	ld a, e
	ldh [hLinkDirection], a

jr_002_6e04:
	ld hl, wLinkWalkingFrameCount
	inc [hl]
	jr jr_002_6e14

jr_002_6e0a:
	ld a, [wPegasusBootsChargeMeter]
	and a
	jr nz, jr_002_6e14

	xor a
	ld [wLinkWalkingFrameCount], a

Jump_002_6e14:
jr_002_6e14:
	ld a, [wSwordAnimationState]
	and a
	jr nz, jr_002_6e1f

	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jr nz, jr_002_6e35

jr_002_6e1f:
	call ApplyLinkSpeed
	ld hl, hLinkDirection
	ldh a, [hJoypadHeld]
	and $0f
	cp $04
	jr nz, jr_002_6e2f

	ld [hl], $02

jr_002_6e2f:
	cp $08
	jr nz, jr_002_6e35

	ld [hl], $03

jr_002_6e35:
	call Call_02_6FB1
	ld a, [wInventoryAppearing]
	and a
	ret nz

	ldh a, [hMultiPurpose0]
	cp $b1
	jr z, jr_002_6e63

	cp $b0
	jr nz, jr_002_6e6d

	ld a, [wLinkCollisionFlags]
	and a
	jr nz, jr_002_6e5f

	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_002_6e58

	ld a, $02
	call Call_02_571B

jr_002_6e58:
	ld a, $04
	ldh [hLinkSpeedY], a
	xor a
	ldh [hLinkSpeedX], a

jr_002_6e5f:
	ld a, $02
	jr jr_002_6e6b

jr_002_6e63:
	ldh a, [hJoypadHeld]
	and $0c
	jr z, jr_002_6e6d

	ld a, $01

jr_002_6e6b:
	ldh [hLinkMotionStep], a

jr_002_6e6d:
	ld hl, hLinkSpeedY
	ld a, [hl]
	sub $40
	and $80
	jr z, Call_02_6E8F

	inc [hl]
	ldh a, [hLinkSpeedY]
	and $80
	jr z, jr_002_6e8e

	ld e, $20
	ld a, [wItemB]
	cp $0a
	jr z, jr_002_6e89

	ld e, $10

jr_002_6e89:
	ldh a, [hJoypadHeld]
	and e
	jr nz, Call_02_6E8F

jr_002_6e8e:
	inc [hl]

Call_02_6E8F::
	ret


SideViewBlockedBits::
	db $01, $02, $04, $08, $10

SideViewProbeDX::
	db $0b, $05, $08, $08, $08

SideViewProbeDY::
	db $08, $08, $04, $10, $0b

Call_02_6E9F::
	ld c, $04
	ld b, $00
	call Call_02_6F6B
	ldh a, [hMultiPurpose1]
	ldh [hMultiPurpose0], a
	xor a
	ld [wLinkCollisionFlags], a
	ld c, $00
	ldh a, [hLinkSpeedX]
	and a
	jr z, jr_002_6edb

	and $80
	jr z, jr_002_6eba

	inc c

jr_002_6eba:
	call Call_02_6F6B
	ldh a, [hRoomObjectType]
	cp $8a
	jr nz, jr_002_6ed2

	ld a, [wRoomEventJustDone]
	and a
	jr nz, jr_002_6ed2

	inc a
	ld [wRoomEventJustDone], a
	ld a, $51
	call OpenDialog

jr_002_6ed2:
	ldh a, [hRoomObjectType]
	cp $ff
	jr nz, jr_002_6edb

	call Call_02_6FA5

jr_002_6edb:
	ld c, $02
	ldh a, [hLinkSpeedY]
	and a
	and $80
	jr nz, jr_002_6ee5

	inc c

jr_002_6ee5:
	call Call_02_6F6B
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, jr_002_6f0a

	ldh a, [hJoypadHeld]
	and $08
	jr nz, jr_002_6f0a

	ldh a, [hMultiPurposeH]
	and $0f
	cp $03
	jr nc, jr_002_6f0a

	ldh a, [hRoomObjectType]
	cp $62
	jr z, jr_002_6f11

	cp $64
	jr z, jr_002_6f11

	cp $66
	jr z, jr_002_6f11

jr_002_6f0a:
	ld a, [wLinkCollisionFlags]
	and $08
	jr z, jr_002_6f24

jr_002_6f11:
	ld a, [wLinkCollisionFlags]
	or $08
	ld [wLinkCollisionFlags], a
	xor a
	ldh [hLinkSpeedY], a
	ldh a, [hLinkY]
	and $f0
	add $00
	ldh [hLinkY], a

jr_002_6f24:
	ld a, [wLinkCollisionFlags]
	and $04
	jr z, jr_002_6f2f

	ldh a, [hLinkPrevY]
	ldh [hLinkY], a

jr_002_6f2f:
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, jr_002_6f6a

	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_002_6f6a

	call ResetSpinAttackAndDash
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
	ld a, $e8
	ldh [hLinkSpeedY], a
	call ApplyLinkSpeed
	call Call_02_6FB1
	ld a, $20
	ld [wBumpShakeTimer], a
	ldh a, [hLinkDirection]
	and $02
	sla a
	ld [wBumpShakeAxis], a
	ld a, $0b
	ldh [hJingle], a
	ret


jr_002_6f6a:
	ret


Call_02_6F6B::
	ld hl, $6e95
	add hl, bc
	ldh a, [hLinkX]
	sub $08
	add [hl]
	swap a
	and $0f
	ld e, a
	ld hl, $6e9a
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	sub $10
	ldh [hMultiPurposeH], a
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
	ldh [hMultiPurpose1], a
	cp $60
	jr z, Call_02_6FA5

	cp $01
	jr nz, jr_002_6fb0

Call_02_6FA5::
	ld hl, $6e90
	add hl, bc
	ld a, [wLinkCollisionFlags]
	or [hl]
	ld [wLinkCollisionFlags], a

jr_002_6fb0:
	ret


Call_02_6FB1::
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ret nz

	ldh a, [hMapId]
	cp $1f
	jr nz, jr_002_6fd5

	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_002_6fd5

	ldh a, [hMapRoom]
	cp $eb
	jr z, jr_002_6fce

	cp $ec
	jr nz, jr_002_6fd5

jr_002_6fce:
	ldh a, [hLinkY]
	cp $2c
	jp c, StartWarpFadeOutWithNoise

jr_002_6fd5:
	ld e, $02
	ldh a, [hLinkY]
	cp $0c
	jr c, jr_002_6ff2

	inc e
	cp $84
	jr nc, jr_002_6ff2

	ld e, $01
	ldh a, [hLinkX]
	cp $04
	jr c, jr_002_704f

	dec e
	cp $9c
	jr nc, jr_002_704f

	jp Jump_002_7142


jr_002_6ff2:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_002_700d

	ldh a, [hMapId]
	cp $1f
	jp nz, Jump_002_7098

	ldh a, [hMapRoom]
	cp $f5
	jp z, StartWarpFadeOutWithNoise

	cp $f2
	jp nz, Jump_002_7098

	jp StartWarpFadeOutWithNoise


jr_002_700d:
	ldh a, [hMapRoom]
	cp $e8
	jp z, Jump_002_7098

	cp $f8
	jp z, Jump_002_7098

	cp $fd
	jr z, jr_002_703c

	cp $a3
	jp z, StartWarpFadeOutWithNoise

	cp $c0
	jp z, StartWarpFadeOutWithNoise

	cp $c1
	jp z, StartWarpFadeOutWithNoise

	cp $ff
	jr nz, jr_002_7046

	ldh a, [hLinkY]
	cp $50
	jr nc, jr_002_703c

	ld a, [wEntityStatus]
	and a
	jr z, jr_002_7098

jr_002_703c:
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a
	xor a
	ldh [hLinkSpeedY], a
	jp Jump_002_7142


jr_002_7046:
	ldh a, [hLinkMotionStep]
	cp $02
	jr z, jr_002_7098

	jp StartWarpFadeOutWithNoise


jr_002_704f:
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
	xor a
	ldh [hLinkSpeedX], a
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_002_7098

	ldh a, [hMapRoom]
	cp $f5
	jp z, StartWarpFadeOutMusic

	cp $fd
	jp z, StartWarpFadeOutMusic

	cp $e9
	jp z, StartWarpFadeOutWithNoise

	cp $e8
	jp z, Jump_002_7142

	cp $f8
	jp z, Jump_002_7142

	cp $ef
	jp z, Jump_002_7142

	cp $ff
	jp z, Jump_002_7142

	cp $c0
	jr nz, jr_002_708d

	ldh a, [hLinkX]
	cp $30
	jp c, Jump_002_7142

	jr jr_002_7098

jr_002_708d:
	cp $c1
	jr nz, jr_002_7098

	ldh a, [hLinkX]
	cp $50
	jp nc, Jump_002_7142

Jump_002_7098:
jr_002_7098:
	call RestoreLinkPosition
	ld a, [wLinkGroundType]
	cp $50
	jp z, Jump_002_7146

	cp $51
	jp z, Jump_002_7146

	ld a, [wLinkGroundVfx]
	cp $07
	jp z, Jump_002_7146

	ld a, [wLinkMotionState]
	cp $06
	jp z, Jump_002_7146

	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_002_70c4

	ld a, [wIsLinkInTheAir]
	and a
	jp nz, Jump_002_7146

jr_002_70c4:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_002_70d0

	ld a, [wSwordPokeTimer]
	and a
	jr nz, jr_002_7146

jr_002_70d0:
	ld a, [wLinkPushedTimer]
	ld hl, wBumpShakeTimer
	or [hl]
	jr nz, jr_002_7146

	ldh a, [hLinkY]
	cp $88
	jr nc, jr_002_7108

	ld a, [wIsUsingPegasusBoots]
	ld hl, hIsSideScrolling
	or [hl]
	ld hl, hLinkInWater
	or [hl]
	jr nz, jr_002_7108

	ldh a, [hJoypadHeld]
	and $0f
	jr z, jr_002_7146

	and $03
	jr z, jr_002_70fa

	dec a
	cp e
	jr z, jr_002_7108

jr_002_70fa:
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
	jr z, jr_002_7146

	dec a
	add $02
	cp e
	jr nz, jr_002_7146

jr_002_7108:
	ldh a, [hMapRoom]
	cp $e8
	jr nz, jr_002_7120

	ldh a, [hMapId]
	cp $1f
	jr z, jr_002_7120

	ld a, [wIsIndoor]
	and a
	jr z, jr_002_7120

	xor a
	ld [wScrollXOffset], a
	ldh [rSCX], a

jr_002_7120:
	ld a, e
	ld [wRoomTransitionDirection], a
	ld a, $01
	ld [wRoomTransitionState], a
	xor a
	ld [wPegasusBootsChargeMeter], a
	ld [wSpinAttackTimer], a
	ld [wIsUsingPegasusBoots], a
	ldh a, [hLinkY]
	cp $88
	jr c, jr_002_7142

	ld a, $02
	ld [wIsLinkInTheAir], a
	ld a, $08
	ldh [hLinkPositionZ], a

Jump_002_7142:
jr_002_7142:
	call Call_02_7180
	ret


Jump_002_7146:
jr_002_7146:
	call Call_1495
	ld [wLinkPushedTimer], a
	call Call_02_7180

jr_002_714f:
	ret


WallProbeDX::
	db $06, $09, $0b, $0b, $06, $09, $04, $04

WallProbeDY::
	db $06, $06, $09, $0c, $0f, $0f, $09, $0c
WallProbePairs::
	db $04, $00, $02, $06

WallBlockedBits::
	db $01, $02, $04, $08, $01, $02, $04, $08

WallProbeDirections::
	db $02, $02, $00, $00
	db $03, $03, $01, $01

WallNudge::
	db $00, $01, $ff, $00

LedgeJumpSpeedX::
	db $10, $f0, $00, $00

LedgeJumpSpeedY::
	db $00, $00, $f0, $10

Call_02_7180::
	ld hl, wIsJumpingDownLedge
	ld a, [wDebugToggle]
	or [hl]
	jr nz, jr_002_714f

	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_002_7192

	call Call_02_6E9F
	ret


jr_002_7192:
	xor a
	ld [wLinkCollisionFlags], a
	ldh a, [hLinkSpeedY]
	cp $00
	jr z, jr_002_721a

	ld e, $03
	rla
	ld bc, $7160
	jr nc, jr_002_71a6

	dec e
	inc bc

jr_002_71a6:
	ld a, e
	ldh [hMultiPurposeC], a
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

jr_002_71af:
	push de
	push bc
	call Call_02_726A
	pop bc
	pop de
	inc bc
	dec e
	jr nz, jr_002_71af

	ldh a, [hLinkSpeedY]
	and $80
	jr nz, jr_002_7203

	ld a, [wIsIndoor]
	and a
	jr nz, jr_002_7203

	ldh a, [hRoomObjectType]
	cp $e9
	jr nz, jr_002_7203

	ld a, [wHasFlippers]
	and a
	jr z, jr_002_7203

	ld a, [wCarriedEntityType]
	cp $d5
	jr z, jr_002_7203

	ld a, [wLinkMotionState]
	cp $02
	jr z, jr_002_721a

	ld a, $08
	ldh [hJingle], a
	jr jr_002_71f2

Call_02_71E6::
	ld a, $08
	ldh [hJingle], a

Call_02_71EA::
	ldh a, [hLinkX]
	and $f0
	add $08
	ldh [hLinkX], a

jr_002_71f2:
	ld a, $02
	ld [wLinkMotionState], a
	xor a
	ldh [hLinkMotionStep], a
	ldh a, [hLinkY]
	sub $08
	ldh [hLinkY], a
	jp ResetPegasusBoots


jr_002_7203:
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, jr_002_721a

	ld e, a
	ld d, $00
	ld hl, $7174
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hLinkX], a
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a

jr_002_721a:
	ldh a, [hLinkSpeedX]
	cp $00
	jr z, jr_002_7259

	ld e, $00
	rla
	ld bc, $7162
	jr nc, jr_002_722a

	inc e
	inc bc

jr_002_722a:
	ld a, e
	ldh [hMultiPurposeC], a
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

jr_002_7233:
	push de
	push bc
	call Call_02_726A
	pop bc
	pop de
	inc bc
	dec e
	jr nz, jr_002_7233

	ld a, [wLinkCollisionFlags]
	and $0c
	jr z, jr_002_7259

	srl a
	srl a
	ld e, a
	ld d, $00
	ld hl, $7174
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hLinkY], a
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a

jr_002_7259:
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, jr_002_7262

	ld [wSwordPokeCounter], a

jr_002_7262:
	call Call_02_7769
	ret


DirectionJoypadBits::
	db $01, $02, $04, $08

Call_02_726A::
	ld hl, $7150
	add hl, bc
	ldh a, [hLinkX]
	sub $08
	add [hl]
	ldh [hMultiPurpose4], a
	swap a
	and $0f
	ld e, a
	ld hl, $7158
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	sub $10
	ldh [hMultiPurpose5], a
	and $f0
	or e
	ld e, a
	ldh [hMultiPurposeH], a
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
	ldh [hMultiPurposeD], a
	and a
	jp z, Jump_002_771c

	cp $01
	jp z, Jump_002_75b1

	cp $02
	jp z, Jump_002_759a

	cp $03
	jp z, Jump_002_74f9

	cp $10
	jp z, Jump_002_74da

	cp $04
	jp z, Jump_002_7577

	cp $30
	jp z, Jump_002_75b1

	cp $60
	jp z, Jump_002_75b1

	cp $0a
	jp z, Jump_002_759a

	cp $ff
	jp z, Jump_002_771c

	cp $e0
	jp z, Jump_002_771c

	cp $f0
	jp nc, Jump_002_771c

	cp $c0
	jp nz, Jump_002_7383

	ldh a, [hLinkDirection]
	cp $02
	jp nz, Jump_002_7379

	ldh a, [hRoomStatus]
	bit 4, a
	jp nz, Jump_002_7379

	ldh a, [hMapRoom]
	cp $0e
	jr nz, jr_002_72fb

	ld a, [$db14]
	ld e, $33
	jr jr_002_7304

jr_002_72fb:
	cp $8c
	jr nz, jr_002_7321

	ld a, [$db13]
	ld e, $34

jr_002_7304:
	and a
	jr z, jr_002_737c

	ldh a, [hMapRoom]
	cp $8c
	jr nz, jr_002_7312

	call ResetSoundEngine
	jr jr_002_7315

jr_002_7312:
	call PlayUnlockSound

jr_002_7315:
	ld a, $28
	call Call_3C01
	ld hl, wEntityPrivate2
	add hl, de
	inc [hl]
	jr jr_002_736a

jr_002_7321:
	cp $2b
	jr nz, jr_002_733c

	ld a, [$db12]
	and a
	ld e, $32
	jr z, jr_002_737c

	call ResetSoundEngine
	ld a, $5f
	call Call_3C01
	ld hl, wEntityPrivate4
	add hl, de
	dec [hl]
	jr jr_002_736a

jr_002_733c:
	cp $b5
	jr nz, jr_002_734b

	ld a, [wGoldenLeaves]
	cp $06
	ld e, $31
	jr nz, jr_002_737c

	jr jr_002_7353

jr_002_734b:
	ld a, [$db11]
	and a
	ld e, $30
	jr z, jr_002_737c

jr_002_7353:
	ldh a, [hLinkY]
	ldh [hMultiPurpose1], a
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
	ld a, $09
	call AddTransientVfx
	ld [hl], $df
	ld a, $df
	ld [wLinkPoseLock], a
	call ResetSoundEngine

jr_002_736a:
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [hRoomStatus], a

Jump_002_7379:
	jp Jump_002_75b1


jr_002_737c:
	ld a, e
	call Call_02_77C4
	jp Jump_002_75b1


Jump_002_7383:
	ldh a, [hRoomObjectType]
	cp $db
	jr nz, jr_002_7391

	ld a, [wLinkMotionState]
	cp $01
	jp z, Jump_002_75b1

jr_002_7391:
	ldh a, [hMultiPurposeD]
	cp $d0
	jp c, Jump_002_741d

	cp $d4
	jp nc, Jump_002_741d

	sub $d0
	ld e, a
	ld a, [wIsIndoor]
	and a
	jr nz, jr_002_73c3

	ld a, e
	cp $00
	jr nz, jr_002_73b6

	ldh a, [hMultiPurpose4]
	and $0f
	cp $08
	jp c, Jump_002_771c

	jr jr_002_73c3

jr_002_73b6:
	cp $01
	jr nz, jr_002_73c3

	ldh a, [hMultiPurpose4]
	and $0f
	cp $08
	jp nc, Jump_002_771c

jr_002_73c3:
	ld d, $00
	ldh a, [hLinkDirection]
	cp e
	jp nz, Jump_002_7416

	ld a, [wLinkPushedTimer]
	ld hl, wSpinAttackTimer
	or [hl]
	ld hl, $d45e
	or [hl]
	jr nz, jr_002_7416

	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_002_73f3

	ld hl, $7266
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
	jr z, jr_002_7416

	ld a, [wLinkPushCounter]
	inc a
	ld [wLinkPushCounter], a
	cp $0c
	jp c, Jump_002_75b1

jr_002_73f3:
	call ResetPegasusBoots
	ld hl, $7178
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $717c
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	ld a, $1c
	ldh [hLinkSpeedZ], a
	ld a, $01
	ld [wIsLinkInTheAir], a
	ld a, $01
	ld [wIsJumpingDownLedge], a
	ld a, $08
	ldh [hJingle], a

Jump_002_7416:
jr_002_7416:
	xor a
	ld [wLinkPushCounter], a
	jp Jump_002_75b1


Jump_002_741d:
	cp $90
	jp c, Jump_002_749d

	cp $99
	jp nc, Jump_002_75b1

	sub $90
	ld e, a
	ld d, $00
	bit 1, a
	jr nz, jr_002_7441

	ld hl, wDoorX
	add hl, de
	ld e, [hl]
	ldh a, [hLinkX]
	sub e
	sub $0c
	cp $08
	jp nc, Jump_002_75b1

	jr jr_002_7450

jr_002_7441:
	ld hl, wDoorY
	add hl, de
	ld e, [hl]
	ldh a, [hLinkY]
	sub e
	sub $14
	cp $08
	jp nc, Jump_002_75b1

jr_002_7450:
	ld a, [$c188]
	and a
	jp nz, Jump_002_75b1

	ldh a, [hMultiPurposeD]
	cp $94
	jr nc, jr_002_746a

	ld a, [wDungeonSmallKeys]
	and a
	jp z, Jump_002_75b1

	dec a
	ld [wDungeonSmallKeys], a
	jr jr_002_7485

jr_002_746a:
	cp $98
	jr z, jr_002_7477

	ld a, [wRoomEvent]
	and a
	jr z, jr_002_7485

	jp Jump_002_75b1


jr_002_7477:
	ld a, [wDungeonHasNightmareKey]
	and a
	jr nz, jr_002_7485

	ld a, $07
	call Call_02_77BE
	jp Jump_002_75b1


jr_002_7485:
	ldh a, [hMultiPurposeD]
	sub $90
	ld [$c189], a
	xor a
	ld [$dbac], a
	inc a
	ld [$c188], a
	call SaveDungeonItemFlags
	call PlayUnlockSound
	jp Jump_002_75b1


Jump_002_749d:
	cp $7c
	jp c, Jump_002_771c

	push af
	jr z, jr_002_74a9

	cp $7d
	jr nz, jr_002_74ac

jr_002_74a9:
	call Call_02_7723

jr_002_74ac:
	pop af
	cp $90
	jp nc, Jump_002_771c

	sub $7c
	sla a
	sla a
	ld e, a
	ld d, $00
	ld hl, $4979
	add hl, de
	ldh a, [hMultiPurpose4]
	rra
	rra
	rra
	and $01
	ld e, a
	ldh a, [hMultiPurpose5]
	rra
	rra
	and $02
	or e
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	and a
	jp nz, Jump_002_75b1

	jp Jump_002_771c


Jump_002_74da:
	ld a, [wLinkMotionState]
	cp $02
	jp z, Jump_002_770f

	ld a, [wCarriedEntityType]
	cp $d5
	jp z, Jump_002_770f

	ldh a, [hMultiPurpose5]
	and $0f
	cp $08
	jp c, Jump_002_771c

	call Call_02_71E6
	jp Jump_002_770f


Jump_002_74f9:
	ld a, [wIsCarryingLiftedObject]
	and a
	jp nz, Jump_002_770f

	ldh a, [hMultiPurpose5]
	and $0f
	cp $06
	jp nc, Jump_002_75a4

	ld a, [wIsIndoor]
	and a
	jr nz, jr_002_7566

	ld a, [wIsGhostFollowingLink]
	cp $01
	jr z, jr_002_751c

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_002_7566

jr_002_751c:
	ldh a, [hMapRoom]
	cp $d3
	jr z, jr_002_753e

	cp $24
	jr z, jr_002_753e

	cp $b5
	jr z, jr_002_753e

	cp $2b
	jr z, jr_002_753e

	cp $d9
	jr z, jr_002_753e

	cp $ac
	jr z, jr_002_753e

	cp $8c
	jr z, jr_002_753e

	cp $0e
	jr nz, jr_002_7566

jr_002_753e:
	ld a, [wIsGhostFollowingLink]
	cp $01
	jr nz, jr_002_754d

	ld a, $12
	call Call_02_77C4
	jp Jump_002_770f


jr_002_754d:
	xor a
	ld [$db47], a
	ld a, $98
	ld [$c3c9], a
	call OpenDialogTable1
	ld a, [wLowHealth]
	inc a
	ld [wMarinReunion], a
	call StartScreenFadeOut
	jp Jump_002_770f


jr_002_7566:
	ld a, [wLinkPushedTimer]
	and a
	jp nz, Jump_002_770f

	ld a, [wIsIndoor]
	and a
	jp nz, StartWarpFadeOut

	jp StartWarpFadeOutWithNoise


Jump_002_7577:
	ld a, [wLinkOnRaisedBlock]
	and a
	jp nz, Jump_002_771c

	ldh a, [hRoomObjectType]
	cp $db
	jr c, jr_002_75b1

	cp $dd
	jr nc, jr_002_75b1

	sub $db
	ld e, a
	ld d, $00
	ld hl, $7b35
	add hl, de
	ld a, [wRaisedBlocksState]
	xor [hl]
	jr nz, jr_002_75b1

	jp Jump_002_771c


Jump_002_759a:
	ld hl, wLinkGroundVfx
	ld [hl], $01
	cp $0a
	jp z, Jump_002_771c

Jump_002_75a4:
	ldh a, [hMultiPurpose4]
	and $0f
	cp $06
	jr c, jr_002_75b1

	cp $0b
	jp c, Jump_002_771c

Jump_002_75b1:
jr_002_75b1:
	ldh a, [hRoomObjectType]
	cp $69
	jr nz, jr_002_75c8

	ld hl, hMultiPurposeC
	ldh a, [hLinkDirection]
	cp [hl]
	jr nz, jr_002_75c5

	ld a, [wIsUsingShield]
	and a
	jr nz, jr_002_75c8

jr_002_75c5:
	call Call_02_78B5

jr_002_75c8:
	ld hl, hMultiPurposeC
	ldh a, [hLinkDirection]
	cp [hl]
	jr nz, jr_002_7634

	ld a, [wLinkPushedTimer]
	ld hl, wIsLinkInTheAir
	or [hl]
	jr nz, jr_002_7634

	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, jr_002_760b

	ld e, $8a
	cp $a9
	jr z, jr_002_7626

	ld e, $8b
	cp $4f
	jr z, jr_002_75f5

	cp $4e
	jr z, jr_002_75f5

	cp $88
	jr nz, jr_002_75fd

jr_002_75f5:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_002_7634

	jr jr_002_7626

jr_002_75fd:
	cp $de
	jr nz, jr_002_760b

	ld a, [wDungeonSmallKeys]
	and a
	jr nz, jr_002_7634

	ld e, $8c
	jr jr_002_7626

jr_002_760b:
	cp $20
	jr nz, jr_002_7634

	ld a, [wItemA]
	cp $03
	jr z, jr_002_7634

	ld a, [wItemB]
	cp $03
	jr z, jr_002_7634

	ld a, [$db66]
	and $02
	jr nz, jr_002_7634

	ld e, $8d

jr_002_7626:
	ld a, [wRoomEventJustDone]
	and a
	jr nz, jr_002_7634

	inc a
	ld [wRoomEventJustDone], a
	ld a, e
	call Call_02_77BE

jr_002_7634:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_002_766a

	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, jr_002_766a

	ld hl, $716c
	add hl, bc
	ldh a, [hLinkDirection]
	cp [hl]
	jp nz, Jump_002_770f

	ld a, [wSwordPokeCounter]
	inc a
	ld [wSwordPokeCounter], a
	cp $0c
	jp c, Jump_002_770f

	xor a
	ld [wSwordPokeCounter], a
	xor a
	ld [wSpinAttackTimer], a
	ld [wSwordCharge], a
	ld a, $0c
	ld [wSwordPokeTimer], a
	jp Jump_002_770f


jr_002_766a:
	ld a, [wIsUsingShield]
	and a
	jr nz, jr_002_7675

	ld a, $03
	ld [wLinkPushingTimer], a

jr_002_7675:
	ldh a, [hMapId]
	and a
	ldh a, [hRoomObjectType]
	jr z, jr_002_76db

	cp $88
	jr z, jr_002_7689

	cp $4e
	jr z, jr_002_7689

	cp $4f
	jp nz, Jump_002_76db

jr_002_7689:
	ld a, [wIsUsingPegasusBoots]
	and a
	jp z, Jump_002_770f

	ldh a, [hMultiPurpose4]
	and $f0
	ldh [hBGPosX], a
	ldh a, [hMultiPurpose5]
	and $f0
	ldh [hBGPosY], a
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, $00
	call RemoveRoomObject
	ld a, $05
	call Call_3C01
	jr c, jr_002_770f

	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurposeH]
	swap a
	and $f0
	add $08
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurposeH]
	and $f0
	add $10
	ld [hl], a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], d
	ld hl, hNoiseSfx
	ld [hl], $09
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4
	jr jr_002_771c

Jump_002_76db:
jr_002_76db:
	ld e, $20
	cp $c5
	jr nz, jr_002_76e9

	ld a, [wIsIndoor]
	and a
	jr z, jr_002_76f9

	jr jr_002_770f

jr_002_76e9:
	ld a, [wIsIndoor]
	and a
	jr z, jr_002_770f

	ldh a, [hRoomObjectType]
	cp $de
	jr z, jr_002_76fb

	cp $a7
	jr nz, jr_002_770f

jr_002_76f9:
	ld e, $40

jr_002_76fb:
	ld a, [wLinkPushCounter]
	inc a
	ld [wLinkPushCounter], a
	cp e
	jr c, jr_002_770f

	ld a, e
	ldh [hBGTilesRequestCopy], a
	xor a
	ld [wLinkPushCounter], a
	call OpenLockedOrPushBlock

Jump_002_770f:
jr_002_770f:
	ld hl, $7164
	add hl, bc
	ld a, [wLinkCollisionFlags]
	or [hl]
	ld [wLinkCollisionFlags], a
	scf
	ret


Jump_002_771c:
jr_002_771c:
	xor a
	ld [wLinkPushCounter], a
	scf
	ccf
	ret


Call_02_7723::
	ldh a, [hRoomObjectType]
	cp $b1
	jr z, jr_002_772d

	cp $b2
	jr nz, jr_002_774f

jr_002_772d:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $06
	jr nc, jr_002_7768

	ld a, $0c
	ldh [hJingle], a
	ld a, $05
	ld [wLinkMotionState], a
	call Call_1495
	ld [wInvincibilityCounter], a
	ld [wLinkMotionCounter], a
	ldh [hLinkPositionZ], a
	ldh [hLinkSpeedZ], a
	call ResetSpinAttackAndDash
	ret


jr_002_774f:
	cp $c1
	jr z, jr_002_775f

	cp $c2
	jr z, jr_002_775f

	cp $bb
	jr z, jr_002_775f

	cp $bc
	jr nz, jr_002_7768

jr_002_775f:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $0c
	jp nc, StartWarpFadeOutWithNoise

jr_002_7768:
	ret


Call_02_7769::
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_002_77bd

	ld a, [wCurrentBank]
	cp $02
	jr nz, jr_002_77bd

	ld a, [wLinkCollisionFlags]
	and $03
	cp $03
	jr z, jr_002_7788

	ld a, [wLinkCollisionFlags]
	and $0c
	cp $0c
	jr nz, jr_002_77bd

jr_002_7788:
	call ResetSpinAttackAndDash
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
	ldh a, [hLinkSpeedY]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedY], a
	ld a, $18
	ldh [hLinkSpeedZ], a
	ld a, $02
	ld [wIsLinkInTheAir], a
	ld a, $20
	ld [wBumpShakeTimer], a
	ldh a, [hLinkDirection]
	and $02
	sla a
	ld [wBumpShakeAxis], a
	ld a, $0b
	ldh [hJingle], a
	call Call_1594

jr_002_77bd:
	ret


Call_02_77BE::
	call OpenDialog
	jp Call_1495


Call_02_77C4::
	call OpenDialogTable2
	jp Call_1495


SwimEntrySpeedX::
	db $08, $f8, $00, $00

SwimEntrySpeedY::
	db $00, $00, $f8, $08

Call_02_77D2::
	ldh a, [hLinkX]
	and $f0
	ldh [hMultiPurpose0], a
	swap a
	ld e, a
	ldh a, [hLinkY]
	sub $04
	and $f0
	ldh [hMultiPurpose1], a
	or e
	ld e, a
	ldh [hLinkSquare], a
	ld d, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [wIsIndoor]
	ld d, a
	ld a, [hl]
	ldh [hObjectUnderLink], a
	ldh [hRoomObjectType], a
	ld e, a
	ret


Jump_002_77fa:
	ld a, [wLinkMotionState]
	cp $01
	jr nz, jr_002_7809

	ld a, [wLinkSpriteDY]
	add $04
	ld [wLinkSpriteDY], a

jr_002_7809:
	ld a, [wHookshotInUse]
	and a
	jr z, jr_002_7847

	ld hl, wIsLinkInTheAir
	ld a, [wIsUsingPegasusBoots]
	or [hl]
	jr nz, Call_02_781B

	call Call_1495

Call_02_781B::
	call Call_02_77D2
	ld c, $04
	ld a, [wSavedLinkMotionState]
	cp $01
	jr z, jr_002_7842

	ld c, $fc
	ld a, [wLinkOnRaisedBlock]
	and a
	jr nz, jr_002_7842

	call GetObjectPhysics
	ld c, $02
	cp $05
	jr z, jr_002_7842

	cp $09
	jr z, jr_002_7842

	cp $08
	jr nz, jr_002_7846

	ld c, $fd

jr_002_7842:
	ld a, c
	ld [wLinkSpriteDY], a

jr_002_7846:
	ret


jr_002_7847:
	ldh a, [hLinkSquare]
	ldh [hLinkSquarePrev], a
	ld a, [wDebugToggle]
	and a
	ret nz

	ldh a, [hLinkPositionZ]
	and a
	jr z, jr_002_7872

	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_002_7871

	ld hl, wOAMBuffer
	ldh a, [hLinkY]
	add $0b
	cp $88
	jr nc, jr_002_7871

	ld [hli], a
	ldh a, [hLinkX]
	add $04
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld [hl], $00

jr_002_7871:
	ret


jr_002_7872:
	xor a
	ld [wIsSpinningInHole], a
	ld a, [wLinkMotionState]
	cp $02
	jr z, jr_002_7871

Call_02_787D::
	ld a, [wRoomTransitionState]
	ld hl, wDialogState
	or [hl]
	jp nz, Jump_002_7980

	call Call_02_77D2
	ld c, a
	ld a, [wIsIndoor]
	and a
	jr nz, jr_002_7899

	ld a, c
	cp $61
	jp z, Jump_002_796a

	jr jr_002_78a7

jr_002_7899:
	ld a, c
	cp $4c
	jr nz, jr_002_78a7

	ldh a, [hLinkY]
	dec a
	and $0f
	cp $0c
	jr nc, Call_02_78B5

jr_002_78a7:
	call GetObjectPhysics
	ld [wLinkGroundType], a
	and a
	jp z, Jump_002_7a5c

	cp $e0
	jr nz, jr_002_78f5

Call_02_78B5::
	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_002_78f4

	call ResetSpinAttackAndDash
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	ldh [hLinkSpeedX], a
	ldh a, [hLinkSpeedY]
	cpl
	inc a
	ldh [hLinkSpeedY], a
	ld a, $02
	ld [wIsLinkInTheAir], a
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_002_78de

	ld a, $10
	ldh [hLinkSpeedZ], a
	ldh a, [hLinkPositionZ]
	add $02
	ldh [hLinkPositionZ], a

jr_002_78de:
	ld a, $10
	ld [wLinkPushedTimer], a
	ld a, $30
	ld [wInvincibilityCounter], a
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a
	ld a, $03
	ldh [hWaveSfx], a

jr_002_78f4:
	ret


jr_002_78f5:
	ld a, [wLinkGroundType]
	cp $ff
	jp z, Jump_002_7a5c

	cp $f0
	jr c, jr_002_7904

	jp Jump_002_7e6e


jr_002_7904:
	cp $51
	jr z, jr_002_790c

	cp $50
	jr nz, jr_002_7980

jr_002_790c:
	call ResetSpinAttackAndDash
	ld a, $07
	ld [wLinkGroundVfx], a
	ld hl, wSinkingSandCounter
	inc [hl]
	ld hl, wDebugToggle
	ldh a, [hFrameCounter]
	and $03
	or [hl]
	jr nz, jr_002_797f

	ldh a, [hLinkX]
	sub $08
	ld hl, hMultiPurpose0
	sub [hl]
	bit 7, a
	ld a, $ff
	jr z, jr_002_7932

	ld a, $01

jr_002_7932:
	ld hl, hLinkX
	add [hl]
	ld [hl], a
	ldh a, [hMultiPurpose1]
	add $10
	ld hl, hLinkY
	sub [hl]
	bit 7, a
	ld a, $ff
	jr nz, jr_002_7947

	ld a, $01

jr_002_7947:
	ld hl, hLinkY
	add [hl]
	ld [hl], a
	ldh a, [hLinkX]
	sub $08
	add $02
	and $0f
	cp $04
	jr nc, jr_002_797f

	ldh a, [hLinkY]
	sub $10
	add $02
	and $0f
	cp $04
	jr nc, jr_002_797f

	ldh a, [hLinkY]
	add $03
	ldh [hLinkY], a

Jump_002_796a:
	ld a, $06
	ld [wLinkMotionState], a
	call ResetSpinAttackAndDash
	ld [wLinkMotionCounter], a
	ld a, [wLinkGroundType]
	ld [wHoleCollisionType], a
	ld a, $0c
	ldh [hWaveSfx], a

jr_002_797f:
	ret


Jump_002_7980:
jr_002_7980:
	ld hl, wOAMBuffer
	ld a, [wLinkGroundType]
	cp $08
	jr nz, jr_002_7995

	ld a, [wLinkSpriteDY]
	add $fd
	ld [wLinkSpriteDY], a
	jp Jump_002_7a5c


jr_002_7995:
	cp $09
	jr nz, jr_002_79a4

	ld a, [wLinkSpriteDY]
	add $02
	ld [wLinkSpriteDY], a
	jp Jump_002_7a5c


jr_002_79a4:
	cp $0b
	jr z, jr_002_79ac

	cp $07
	jr nz, jr_002_7a10

jr_002_79ac:
	ldh a, [hLinkInWater]
	and a
	jr z, jr_002_79b4

	jp Jump_002_7eaa


jr_002_79b4:
	ld a, [wCanTalkToEntity]
	cp $80
	jr z, jr_002_7a10

	ld a, [wLinkMotionState]
	cp $08
	jr z, jr_002_7a0f

	cp $01
	jr z, jr_002_7a0f

	ldh a, [hLinkY]
	add $fe
	call Call_02_571D
	ldh a, [hRoomObjectType]
	cp $06
	jr z, Call_02_79D9

	ld a, [wHasFlippers]
	and a
	jr nz, jr_002_79f2

Call_02_79D9::
	ld a, $50
	ldh [hLinkCountdown], a
	ld a, $08
	ld [wLinkMotionState], a
	ldh a, [hRoomObjectType]
	ldh [hLinkMotionStep], a
	ldh a, [hLinkY]
	add $02
	ldh [hLinkY], a
	ld a, $01
	ld [wLinkFrozen], a
	ret


jr_002_79f2:
	ld a, $01
	ld [wLinkMotionState], a
	xor a
	ldh [hLinkMotionStep], a
	call Call_1495
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $77ca
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $77ce
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a

jr_002_7a0f:
	ret


jr_002_7a10:
	cp $06
	jp z, Jump_002_7b37

	cp $05
	jr nz, jr_002_7a5c

	ldh a, [hLinkY]
	add $0c
	ld [hli], a
	ldh a, [hLinkX]
	add $00
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	push af
	ld [hli], a
	ldh a, [hLinkY]
	add $0c
	ld [hli], a
	ldh a, [hLinkX]
	add $08
	ld [hli], a
	ld a, $1c
	ld [hli], a
	pop af
	or $20
	ld [hl], a
	ld a, $03
	ld [wLinkGroundVfx], a
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_002_7a54

	ldh a, [hJoypadHeld]
	and $0f
	jr z, jr_002_7a54

	ld a, $0e
	ldh [hJingle], a

jr_002_7a54:
	ld a, [wLinkSpriteDY]
	add $02
	ld [wLinkSpriteDY], a

Jump_002_7a5c:
jr_002_7a5c:
	xor a
	ld [wSinkingSandCounter], a
	ld a, [wLinkMotionState]
	cp $01
	jr nz, jr_002_7a6c

	ld a, $00
	ld [wLinkMotionState], a

jr_002_7a6c:
	ld a, [wLinkGroundType]
	cp $04
	jr nz, jr_002_7aa3

	ldh a, [hRoomObjectType]
	cp $db
	jr c, jr_002_7aa3

	cp $dd
	jr nc, jr_002_7aa3

	sub $db
	ld e, a
	ld d, $00
	ld hl, $7b35
	add hl, de
	ld a, [wRaisedBlocksState]
	xor [hl]
	jr z, jr_002_7aa3

	ld a, [wRaisedBlockStep]
	ld e, a
	ld d, $00
	ld hl, $7b29
	add hl, de
	ld a, [wLinkSpriteDY]
	add [hl]
	ld [wLinkSpriteDY], a
	ld a, $01
	ld [wLinkOnRaisedBlock], a
	ret


jr_002_7aa3:
	ld a, [wLinkOnRaisedBlock]
	and a
	jr z, jr_002_7ab1

	ld a, $07
	ldh [hNoiseSfx], a
	xor a
	ld [wLinkOnRaisedBlock], a

jr_002_7ab1:
	ld a, [wIsIndoor]
	and a
	jp z, Jump_002_7b28

	ld a, [wRoomTransitionState]
	and a
	jr nz, jr_002_7b28

	ldh a, [hRoomObjectType]
	cp $aa
	jr nz, jr_002_7af6

	ld a, [wFloorSwitchPressedTimer]
	and a
	jr nz, jr_002_7af6

	ld a, [wFloorSwitchStandFrames]
	inc a
	ld [wFloorSwitchStandFrames], a
	cp $18
	jr nz, jr_002_7aed

	ld a, $60
	ld [wFloorSwitchPressedTimer], a
	ld a, $0e
	ldh [hWaveSfx], a
	ld a, $03
	ldh [hBGChangeRequest], a
	ldh a, [hMapRoom]
	cp $c3
	jr nz, jr_002_7aed

	ld hl, $d879
	set 4, [hl]

jr_002_7aed:
	ld a, [wLinkSpriteDY]
	add $fd
	ld [wLinkSpriteDY], a
	ret


jr_002_7af6:
	xor a
	ld [wFloorSwitchStandFrames], a
	ldh a, [hLinkSquare]
	ld hl, hLinkSquarePrev
	cp [hl]
	ld hl, $c1c9
	jr nz, jr_002_7b26

	ldh a, [hRoomObjectType]
	cp $df
	jr nz, jr_002_7b26

	ldh a, [hLinkInteractiveMotionBlocked]
	ld e, a
	ld a, [wLinkShowItemPose]
	ld d, a
	ld a, [wDialogState]
	or e
	or d
	jr nz, jr_002_7b26

	inc [hl]
	ld a, [hl]
	cp $28
	jr c, jr_002_7b28

	ld a, $2b
	ldh [hNoiseSfx], a
	jp CollapseFloorUnderLink


jr_002_7b26:
	ld [hl], $00

Jump_002_7b28:
jr_002_7b28:
	ret


RaisedBlockLinkDY::
	db $fc, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fc, $fc, $fc

RaisedBlockLoweredPhase::
	db $00, $02

Jump_002_7b37:
	ldh a, [hLinkY]
	add $08
	ld [hli], a
	ldh a, [hLinkX]
	add $ff
	ld [hli], a
	ld a, $1a
	ld [hli], a
	ld a, [wLinkWalkingFrameCount]
	rla
	rla
	and $20
	push af
	ld [hli], a
	ldh a, [hLinkY]
	add $08
	ld [hli], a
	ldh a, [hLinkX]
	add $07
	ld [hli], a
	ld a, $1a
	ld [hli], a
	pop af
	xor $20
	ld [hl], a
	ld a, $03
	ld [wLinkGroundVfx], a
	ret


RoomScrollLinkSpeedX::
	db $c6, $3a, $00, $00

RoomScrollLinkSpeedY::
	db $00, $00, $3a, $c6

RoomScrollCameraDX::
	db $04, $fc, $00, $00

RoomScrollCameraDY::
	db $00, $00, $fc, $04

Call_02_7B74::
	ld a, [wRoomTransitionState]
	cp $00
	jp z, Jump_002_7c5d

	push af
	cp $03
	jp c, Jump_002_7c50

	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
	ld hl, $7b64
	add hl, bc
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $7b68
	add hl, bc
	ld a, [hl]
	ldh [hLinkSpeedY], a
	push bc
	call ApplyLinkSpeed
	pop bc
	ld hl, $7b6c
	add hl, bc
	ldh a, [hBaseScrollX]
	add [hl]
	ldh [hBaseScrollX], a
	ld hl, $7b70
	add hl, bc
	ldh a, [hBaseScrollY]
	add [hl]
	ldh [hBaseScrollY], a
	ld hl, wRoomScrollTargetY
	cp [hl]
	jp nz, Jump_002_7c50

	ldh a, [hBaseScrollX]
	ld hl, wRoomScrollTargetX
	cp [hl]
	jp nz, Jump_002_7c50

	pop af
	ldh a, [hNextDefaultMusicTrack]
	and a
	jr z, jr_002_7bc9

	call PlayMusic
	xor a
	ldh [hNextDefaultMusicTrack], a

jr_002_7bc9:
	call Call_1495
	ldh [hLinkSpeedZ], a
	ld [wRoomTransitionState], a
	ldh a, [hLinkX]
	ld [wLinkRespawnX], a
	ldh a, [hLinkY]
	ld [wLinkRespawnY], a
	ld a, [wRoomTransitionDirection]
	cp $03
	jr nz, jr_002_7c06

	ld a, $01
	ldh [hLinkSpeedY], a
	call Call_02_7180
	ldh a, [hRoomObjectType]
	cp $db
	jr z, jr_002_7c06

	cp $dc
	jr z, jr_002_7c06

	cp $e1
	jr z, jr_002_7bfd

	ld a, [wLinkCollisionFlags]
	and a
	jr z, jr_002_7c06

jr_002_7bfd:
	ld a, [wDebugToggle]
	and a
	jr nz, jr_002_7c06

	call Call_02_71EA

jr_002_7c06:
	ld a, [wJingleAfterTransition]
	and a
	jr z, jr_002_7c12

	ldh [hJingle], a
	xor a
	ld [wJingleAfterTransition], a

jr_002_7c12:
	call Call_3819
	ld a, $ff
	ldh [hAnimatedTilesFrameCount], a
	ld a, [wIsIndoor]
	and a
	ret z

	ld d, a
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_002_7c2a

	cp $06
	jr c, jr_002_7c2a

	inc d

jr_002_7c2a:
	ldh a, [hMapRoom]
	ld e, a
	call GetRoomInfo
	cp $1a
	jr z, jr_002_7c40

	cp $19
	jr z, jr_002_7c40

	ld a, [wRoomEvent]
	and $e0
	cp $80
	ret nz

jr_002_7c40:
	ld a, [wDungeonHasCompass]
	and a
	ret z

	ldh a, [hRoomStatus]
	and $10
	ret nz

	ld a, $0c
	ld [wCompassChimeDelay], a
	ret


Jump_002_7c50:
	pop af
	dec a
	rst $00

JumpTable_02_7C53::
	dw Jump_02_7C7E
	dw Jump_02_7DA1
	dw Jump_02_7DE2
	dw Jump_02_7E59
	dw Jump_02_7E5D

Jump_002_7c5d:
	ret


MazeRoomPaths::
	db $01, $01, $02, $00, $00, $02, $01, $02, $00, $02, $02, $00, $02, $02, $00, $02
	db $01, $02, $00, $02, $01, $02, $00, $02, $00, $00, $00, $00, $02, $02, $02, $02

Jump_02_7C7E::
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
	ld a, [wIsIndoor]
	and a
	jr z, jr_002_7ced

	ldh a, [hMapId]
	cp $0b
	jr nc, jr_002_7ced

	cp $08
	jr nz, jr_002_7cc8

	ldh a, [hMapRoom]
	cp $71
	jr nz, jr_002_7cc8

	ld a, c
	cp $03
	jr z, jr_002_7cc8

	ld a, [wFaceShrineHint]
	ld e, a
	ld d, $00
	ld hl, $7c5e
	add hl, de
	ld a, [$c5aa]
	ld e, a
	inc a
	ld [$c5aa], a
	add hl, de
	ld a, c
	cp [hl]
	jr z, jr_002_7cbd

	xor a
	ld [$c5aa], a
	jp Jump_002_7d25


jr_002_7cbd:
	ld a, e
	cp $07
	jp nz, Jump_002_7d25

	ld a, $02
	ld [wJingleAfterTransition], a

jr_002_7cc8:
	xor a
	ld [$c5aa], a
	ld hl, $7dde
	add hl, bc
	ld a, c
	cp $02
	jr nz, jr_002_7ce7

	ldh a, [hMapId]
	cp $05
	jr nz, jr_002_7ce7

	ld a, [wIndoorRoom]
	cp $1d
	jr nz, jr_002_7ce7

	ld a, $35
	ld [wIndoorRoom], a

jr_002_7ce7:
	ld a, [hl]
	ld hl, wIndoorRoom
	jr jr_002_7d0c

jr_002_7ced:
	ld a, [wRaccoonLoopsExit]
	and a
	jr z, jr_002_7d04

	ld a, c
	cp $02
	jr nz, jr_002_7d04

	ld a, $1e
	ld [wJingleAfterTransition], a
	ld a, $63
	ld hl, hMapRoom
	jr jr_002_7d0d

jr_002_7d04:
	ld hl, $7dda
	add hl, bc
	ld a, [hl]
	ld hl, hMapRoom

jr_002_7d0c:
	add [hl]

jr_002_7d0d:
	ld [hl], a
	cp $41
	jr nz, jr_002_7d25

	ld a, c
	cp $02
	jr nz, jr_002_7d25

	ld hl, $d841
	bit 6, [hl]
	jr nz, jr_002_7d25

	set 6, [hl]
	ld a, $02
	ld [wJingleAfterTransition], a

Jump_002_7d25:
jr_002_7d25:
	call LoadRoom
	call LoadRoomEntities
	call Call_1CCC
	call Call_149B
	ld a, [wRestoreMusicAfterTransition]
	and a
	jr z, jr_002_7d4c

	xor a
	ld [wRestoreMusicAfterTransition], a
	ld a, [wActivePowerUp]
	and a
	ldh a, [hDefaultMusicTrack]
	jr z, jr_002_7d45

	ld a, $49

jr_002_7d45:
	ldh [hNextDefaultMusicTrack], a
	call FadeOutVolume
	jr jr_002_7d99

jr_002_7d4c:
	ld a, [wIsIndoor]
	and a
	jr nz, jr_002_7d99

	ld a, [wSwordLevel]
	and a
	jr z, jr_002_7d99

	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, $4000
	add hl, de
	ld a, [hl]
	ld hl, hDefaultMusicTrack
	cp [hl]
	jr z, jr_002_7d99

	ld c, a
	cp $25
	jr nc, jr_002_7d77

	ld b, $00
	ld hl, $4120
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_002_7d8d

jr_002_7d77:
	ld a, [wActivePowerUp]
	and a
	jr z, Call_02_7D90

	ldh a, [hDefaultMusicTrackAlt]
	cp $49
	jr z, jr_002_7d96

	call Call_02_7D90
	ld a, $49
	ldh [hNextDefaultMusicTrack], a
	ldh [hDefaultMusicTrackAlt], a
	ret


jr_002_7d8d:
	ld a, c
	ldh [hDefaultMusicTrackAlt], a

Call_02_7D90::
	ld a, c
	ldh [hNextDefaultMusicTrack], a
	call FadeOutVolume

jr_002_7d96:
	ld a, c
	ldh [hDefaultMusicTrack], a

Jump_002_7d99:
jr_002_7d99:
	ld a, [wRoomTransitionState]
	inc a
	ld [wRoomTransitionState], a
	ret


Jump_02_7DA1::
	call LoadRoomTilesets
	ld a, [$d6fa]
	cp $02
	jr nz, jr_002_7daf

	ld a, $02
	ldh [hTileSwapFinishCount], a

jr_002_7daf:
	jp Jump_002_7d99


RoomScrollDrawRowHigh::
	db $00, $00, $02, $02

RoomScrollDrawRowLow::
	db $14, $0c, $00, $00

RoomScrollDrawColHigh::
	db $00, $00, $03, $02

RoomScrollDrawColLow::
	db $14, $1e, $c0, $00
RoomScrollDrawCount::
	db $08, $08, $0a, $0a

RoomScrollDrawStep::
	db $0a, $0a, $08, $08

RoomScrollDrawMode::
	db $00, $09, $70, $00, $40, $40, $02, $02
RoomScrollTargetDX::
	db $a0, $60, $00, $00

RoomScrollTargetDY::
	db $00, $00, $80, $80

OverworldRoomStep::
	db $01, $ff, $f0, $10

IndoorRoomStep::
	db $01, $ff, $f8, $08

Jump_02_7DE2::
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
	ld hl, $7dd2
	add hl, bc
	ld a, [wRoomScrollTargetX]
	add [hl]
	ld [wRoomScrollTargetX], a
	ld hl, $7dd6
	add hl, bc
	ld a, [wRoomScrollTargetY]
	add [hl]
	ld [wRoomScrollTargetY], a
	ld hl, $7dbe
	add hl, bc
	ld a, [wBGOriginLow]
	add [hl]
	rl d
	and $df
	ld [wTransitionDrawLow], a
	ld hl, $7dba
	add hl, bc
	ld a, [wBGOriginHigh]
	rr d
	adc [hl]
	and $03
	ld [wTransitionDrawHigh], a
	ld hl, $7db6
	add hl, bc
	ld a, [wBGOriginLow]
	add [hl]
	rl d
	and $df
	ld [wBGOriginLow], a
	ld hl, $7db2
	add hl, bc
	ld a, [wBGOriginHigh]
	rr d
	adc [hl]
	and $03
	ld [wBGOriginHigh], a
	ld hl, $7dc2
	add hl, bc
	ld a, [hl]
	ld [wTransitionStripLength], a
	ld hl, $7dc6
	add hl, bc
	ld a, [hl]
	ld [wTransitionStripsLeft], a
	ld hl, $7dca
	add hl, bc
	ld a, [hl]
	ld [wTransitionObjectIndex], a
	xor a
	ld [wTransitionDrawDelay], a
	jp Jump_002_7d99


Jump_02_7E59::
	call DrawTransitionStrip
	ret


Jump_02_7E5D::
	ret


ConveyorSpeedX::
	db $00, $00, $ff, $01, $01, $ff, $01, $ff

ConveyorSpeedY::
	db $01, $ff, $00, $00, $01, $01, $ff, $ff

Jump_002_7e6e:
	ldh a, [hFrameCounter]
	and $03
	ld hl, wLinkFrozen
	or [hl]
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
	ld hl, wLinkShowItemPose
	or [hl]
	ret nz

	ld a, [wLinkGroundType]
	sub $f0
	ld e, a
	ld d, $00
	ld hl, $7e5e
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hLinkX], a
	ld hl, $7e66
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hLinkY], a
	ret


WaterCurrentSpeedX::
	db $fc, $fa, $f8, $f6, $0c, $00, $00, $f4

WaterCurrentSpeedY::
	db $00, $00, $00, $00, $00, $f4, $0c, $00

Jump_002_7eaa:
	ldh a, [hFrameCounter]
	and $00
	ld hl, wRoomTransitionState
	or [hl]
	ld hl, wLinkShowItemPose
	or [hl]
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
	ld hl, wDialogState
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_002_7efd

	ld e, $01
	ldh a, [hRoomObjectType]
	cp $0e
	jr nz, jr_002_7ee4

	ldh a, [hMapRoom]
	cp $3e
	jr z, jr_002_7ee7

	inc e
	cp $3d
	jr z, jr_002_7ee7

	inc e
	cp $3c
	jr z, jr_002_7ee7

	cp $3f
	jr nz, jr_002_7efd

	ld e, $00
	jr jr_002_7ee7

jr_002_7ee4:
	sub $e7
	ld e, a

jr_002_7ee7:
	ld d, $00
	ld hl, $7e9a
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $7ea2
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	call ApplyLinkSpeed
	call Call_02_7180

jr_002_7efd:
	ret


Bank2FreeSpace::
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
