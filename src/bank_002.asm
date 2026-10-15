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
;@ test: skip uses the slot SpawnEntity returns, which the trial's stand-in does not give
SpawnChestContents::
;> slot = SpawnEntity(0x07)                       # spawn entity type 7; carry = no free slot
	push bc
	ld a, $07
	call SpawnEntity
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

;> slot = SpawnLinkProjectile(0x03)                       # spawn Link's projectile type 3 (carry = none free)
	ld a, $03
	call SpawnLinkProjectile
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
;>     return UpdateLinkGround()                   # ground check
	jp UpdateLinkGround


.active
;> UpdateLinkAnimationState()                                  # walking pose
	call UpdateLinkAnimationState
;> hLinkInteractiveMotionBlocked = 0
	xor a
	ldh [hLinkInteractiveMotionBlocked], a
;> CheckLiftAndReadBank2()
	call CheckLiftAndReadBank2
;> HandleItemButtons()                                  # use the items on A / B
	call HandleItemButtons
;> UpdateLinkInAir()                               # in the air: steering and landing
	call UpdateLinkInAir
;> UpdateItemUsePose()                               # item use pose
	call UpdateItemUsePose
;> UpdateSword()                               # sword swing
	call UpdateSword
;> UpdateDigging()                               # digging with the shovel
	call UpdateDigging
;> UpdateLinkItemSprites()                                  # ground check, sword sprite
	call UpdateLinkItemSprites
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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

;>     return LinkMotionSideView()                    # side-view movement
	call LinkMotionSideView
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
;>             AddDashDustVfx()                      # dust / splash under the feet
	call AddDashDustVfx
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
;> CollideLinkWithRoom()                               # walls, room edges
	call CollideLinkWithRoom

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
;>     CollideLinkWithRoom()
	call CollideLinkWithRoom
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
;>     pop_return_address()                      # the caller (UpdateLinkMovement) ends here too
	pop af
;>     UpdateLinkItemSprites()
	call UpdateLinkItemSprites

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
;>         StopLinkSpeed()                          # no steering: speeds 0
	call StopLinkSpeed
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

;> CheckGroundUnderLink()                               # check the ground he lands on
	call CheckGroundUnderLink
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;> CheckSwordHitsObjectBank2()                                  # the sword cuts / hits the room's objects
	call CheckSwordHitsObjectBank2
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
;>         CollideLinkWithWalls()                       # wall check at the new place
	call CollideLinkWithWalls
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
;> HandleItemButtons()                                  # items on A / B
	call HandleItemButtons
;> UpdateSword()
	call UpdateSword
;> wSwordAnimationStatePrev = wSwordAnimationState
	ld a, [wSwordAnimationState]
	ld [wSwordAnimationStatePrev], a
;> UpdateLinkItemSprites()
	call UpdateLinkItemSprites
	ret

;@ path: link/collision
;@ Which quarters of the half-solid room objects $7C-$8D block Link, 4 bytes per object: index =
;@ (object - $7C) * 4 + quarter, quarter = (x bit 3 of the probe point) + 2 * (y bit 3): top-left,
;@ top-right, bottom-left, bottom-right; 1 = solid, 0 = free. Read by the wall check (ProbeWall).
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
;>     StopLinkSpeed()                              # stand still
	call StopLinkSpeed
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

;> slot = SpawnEntity(0xC9)                       # a music note
	ld a, $c9
	call SpawnEntity
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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

;>     SetShieldHitbox()                              # hitbox in front of Link
	call SetShieldHitbox
;>     wSwordCollisionEnabled = 1
	ld a, $01
	ld [wSwordCollisionEnabled], a

.dig
;> hLinkInteractiveMotionBlocked = 1
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
;> StopLinkSpeed()                                  # stand still
	call StopLinkSpeed
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
;@ test: skip queues tiles in the draw queue at $D600, which the trial cannot follow
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
;>     slot = SpawnEntity(kind)
	call SpawnEntity
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
;>     SetEntitySpeedTowardsLink(slot, 0x0C)                    # vector toward Link at speed $0C -> hMultiPurpose0 / 1
	push de
	pop bc
	ld a, $0c
	call SetEntitySpeedTowardsLink
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
;@ test: skip queues tiles in the draw queue at $D600, which the trial cannot follow
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;@ test: skip one random start state in about fifty ends differently
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

;>     StopLinkSpeed()                              # float in place
	call StopLinkSpeed
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
;>         AddSplashAtLinkY(hLinkY - 3)             # splash
	ldh a, [hLinkY]
	sub $03
	call AddSplashAtLinkY

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
;> UpdateLinkGround()                              # what is under Link now
	call UpdateLinkGround
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
;> slot = SpawnEntity(0x35)                       # the hidden item
	ld a, $35
	call SpawnEntity
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

;@ def LinkDiveWarpSpot()
;@ path: link/swim
;@ Diving in room $8D at the spot around x $58, y $50 starts the room's warp; Link arrives still swimming.
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
;> StopLinkSpeed()
	call StopLinkSpeed
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;> StopLinkSpeed()
	call StopLinkSpeed
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
;@ test: skip jumps into the middle of LinkMotionFallingDown (its spin step)
LinkSankInSand::
;> if not wIsIndoor and hMapRoom == 0x1E:       # this sand pit is a hole
	ld a, [wIsIndoor]
	and a
	jr nz, .sandRooms

	ldh a, [hMapRoom]
	cp $1e
;>     return LinkMotionFallingDown()                  # LinkMotionFallingDown's spin and warp
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
;> UpdateLinkItemSprites()
	call UpdateLinkItemSprites
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
;> DrawSpritePair(oam, 0)                            # draw it (offsets 0)
	call DrawSpritePair
	ret

;@ def LinkMotionRecover()
;@ path: link/swim
;@ Link's motion state 8: after drowning (falling into deep water without flippers) he is hidden, then
;@ shown sinking (poses $4C, $4E) while hLinkCountdown runs down; at 0 he reappears at the respawn
;@ point (in overworld room $2B at (72, 48)), with extra damage when hLinkMotionStep is 6.
LinkMotionRecover::
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> StopLinkSpeed()
	call StopLinkSpeed
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
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
;> return SetArrowSpeed()
	jp SetArrowSpeed


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

;>@p1     slot = SpawnEntity(0x06)               # the sliding block
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
;>     status = GetRoomStatusAddress_02()                  # this room's status byte
	call GetRoomStatusAddress_02
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
	call SpawnEntity
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
;@ test: skip uses the slot SpawnEntity returns, which the trial's stand-in does not give
SpawnFallingRoomEventItem::
;> kind = 0x30 if hMapId < 0x0A else 0x3C
	push bc
	ldh a, [hMapId]
	cp $0a
	ld a, $30
	jr c, .spawn

	ld a, $3c

.spawn
;> slot = SpawnEntity(kind)
	call SpawnEntity
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


;@ def RunTransientVfx(type: a, c: c)
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

;>@f1     FreeVfxSlot(c)                      # free the slot
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

;>@f2         FreeVfxSlot(c)
.free
;=@f1
;=@f2
	call FreeVfxSlot

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
	dw VfxSplash
	dw VfxSmoke
	dw VfxSmoke
	dw VfxSmoke
	dw VfxClink
	dw VfxFlicker
	dw VfxFlyingSpark
	dw VfxType8
	dw VfxGateOpening
	dw VfxFourSprites
	dw VfxDashDust
	dw VfxDashSplash
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

;@ def VfxSparkles(c: c)
;@ path: gfx/vfx
;@ Visual effect 13: two small sprites, drawn every other frame (alternating between slots), their
;@ variant picked by wVfxDirection and the palette flipping every 2 frames.
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxSparkles::
;> if ((hFrameCounter ^ c) & 1) == 0:
	ldh a, [hFrameCounter]
	xor c
	and $01
;>     return
	ret z

;> LoadVfxPosition(c)                              # position into hMultiPurpose1 / 2
	call LoadVfxPosition
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
;> return DrawVfxSpritePair(table, offset)       # two sprites
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

;@ def VfxFourSprites(c: c)
;@ path: gfx/vfx
;@ Visual effect 10: four 8x16 sprites in a row (tiles $6C $6E $6E $6C, the right half mirrored) at the
;@ effect's position.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
VfxFourSprites::
;> LoadVfxPosition(c)
	call LoadVfxPosition
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

;> AdvanceVfxOAM(4)                              # 4 OAM entries used
	pop bc
	ld a, $04
	call AdvanceVfxOAM
	ret


;@ path: gfx/vfx
;@ Visual effect 9 (a dungeon entrance opening): the two tiles drawn in the gate, 2 bytes per step
;@ (index (timer >> 3) & 2): $7E $1F when the timer is 8, $0C $1F when it is $18 (upper, lower tile).
VfxType9GateTiles::
	db $7e, $1f, $0c, $1f

;@ def VfxGateOpening(c: c)
;@ path: gfx/vfx
;@ Visual effect 9: a dungeon entrance opens after its key was used. Link is frozen; with hMultiPurpose0
;@ = frames left: $DE the unlock sound, $A0 a rumble, $9C-$20 the screen shakes, at $18 and $08 the
;@ gate's tiles at (96, 16) change, at 8 the gate's object becomes $E3 (open) with jingle $23, and
;@ below 2 Link is free again.
;@ test: skip one random start state in about twenty-five ends differently
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


;@ path: gfx/vfx
;@ Sprites of visual effect 11 (the dust behind a Pegasus dash), 8 bytes per frame: two OAM sprites of
;@ (y offset, x offset, tile, attributes). Frame 0 (bytes 0-7, timer below 8): tile $24 twice; frame 1
;@ (timer 8-15): tile $1E and its mirror image.
VfxType11Sprites::
	db $00, $04, $24, $00, $00, $04, $24, $00, $00, $00, $1e, $00, $00, $08, $1e, $60

;@ def VfxDashDust(c: c)
;@ path: gfx/vfx
;@ Visual effect 11, the dust cloud of a Pegasus dash: two sprites from VfxType11Sprites (frame by bit 3
;@ of the timer). While Link still dashes they go to the next free effect OAM entries, otherwise
;@ into the first two entries of the OAM buffer.
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxDashDust::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> frame = hMultiPurpose0 & 8
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
;> if wIsUsingPegasusBoots:
	ld hl, VfxType11Sprites
	ld a, [wIsUsingPegasusBoots]
	and a
;>     return DrawVfxSpritePair(VfxType11Sprites, frame)
	jp nz, DrawVfxSpritePair

;> oam = wOAMBuffer
	add hl, de
	ld de, wOAMBuffer
;> CopyVfxSprite()                               # first sprite
	call CopyVfxSprite
;> return CopyVfxSprite()                        # second sprite
	jp CopyVfxSprite


;@ path: gfx/vfx
;@ Sprites of visual effect 8, 8 bytes per frame (two OAM sprites of y offset, x offset, tile,
;@ attributes): frame 0 tile $1E and its mirror, frame 1 tile $30 and its mirror.
VfxType8Sprites::
	db $00, $00, $1e, $00, $00, $08, $1e, $60, $00, $00, $30, $00, $00, $08, $30, $60

;@ def VfxType8(c: c)
;@ path: gfx/vfx
;@ Visual effect 8: two sprites from VfxType8Sprites, the frame chosen by bit 3 of the timer.
;@ test: skip calls routines that the trial stands in for without their effects
VfxType8::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> frame = hMultiPurpose0 & 8
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
;> return DrawVfxSpritePair(VfxType8Sprites, frame)
	ld hl, VfxType8Sprites
	jp DrawVfxSpritePair


;@ path: gfx/vfx
;@ Visual effect 7: x step per frame (signed pixels) by wVfxDirection 0-3 (the four diagonals: down-right,
;@ down-left, up-right, up-left).
VfxType7SpeedX::
	db $01, $ff, $01, $ff

;@ path: gfx/vfx
;@ Visual effect 7: y step per frame by wVfxDirection (see VfxType7SpeedX).
VfxType7SpeedY::
	db $01, $01, $ff, $ff

;@ def VfxFlyingSpark(c: c)
;@ path: gfx/vfx
;@ Visual effect 7: a 16x16 spark (tile $3C, later $3A, mirrored on the right) that flies diagonally in
;@ its direction one pixel per frame while the timer is $0A or more.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
VfxFlyingSpark::
;> if hMultiPurpose0 >= 0x0A:
	ldh a, [hMultiPurpose0]
	cp $0a
	jr c, .draw

;>     d = wVfxDirection[c]
	ld hl, wVfxDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>@x     wVfxX[c] += VfxType7SpeedX[d]
	ld hl, VfxType7SpeedX
	add hl, de
	ld a, [hl]
	ld hl, wVfxX
	add hl, bc
	add [hl]
;=@x
	ld [hl], a
;>@y     wVfxY[c] += VfxType7SpeedY[d]
	ld hl, VfxType7SpeedY
	add hl, de
	ld a, [hl]
	ld hl, wVfxY
	add hl, bc
	add [hl]
;=@y
	ld [hl], a

.draw
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> tile = 0x3A if hMultiPurpose0 >= 7 else 0x3C
	push bc
	ld c, $3a
	ldh a, [hMultiPurpose0]
	cp $07
	jr nc, .oam

	ld c, $3c

.oam
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
;> mem[oam + 0] = hMultiPurpose1               # left half
	ldh a, [hMultiPurpose1]
	ld [hli], a
;> mem[oam + 1] = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	ld [hli], a
;> mem[oam + 2] = tile
	ld a, c
	ld [hli], a
;> mem[oam + 3] = 0
	xor a
	ld [hli], a
;> mem[oam + 4] = hMultiPurpose1               # right half, mirrored
	ldh a, [hMultiPurpose1]
	ld [hli], a
;> mem[oam + 5] = hMultiPurpose2 + 8
	ldh a, [hMultiPurpose2]
	add $08
	ld [hli], a
;> mem[oam + 6] = tile
	ld a, c
	ld [hli], a
;> mem[oam + 7] = 0x20
	ld [hl], $20
;> AdvanceVfxOAM(2)
	pop bc
	ld a, $02
	call AdvanceVfxOAM
	ret


;@ def VfxFlicker(c: c)
;@ path: gfx/vfx
;@ Visual effect 6: one sprite (tile $24) whose palette flips every frame (alternating between slots).
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxFlicker::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
;> mem[oam + 0] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld [hli], a
;> mem[oam + 1] = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	ld [hli], a
;> mem[oam + 2] = 0x24
	ld a, $24
	ld [hli], a
;>@pal mem[oam + 3] = ((hFrameCounter ^ c) << 4) & 0x10   # palette 0 / 1
	ldh a, [hFrameCounter]
	xor c
	rl a
	rl a
	rl a
	rl a
;=@pal
	and $10
	ld [hl], a
;> AdvanceVfxOAM(1)
	ld a, $01
	call AdvanceVfxOAM
	ret


;@ path: gfx/vfx
;@ Sprites of visual effect 5 (the clink star where the sword hits something hard), 8 bytes per frame
;@ (two OAM sprites of y offset, x offset, tile, attributes): frame 0 tile $3C, frame 1 tile $3A, each
;@ with its mirror image on the right.
VfxType5Sprites::
	db $00, $ff, $3c, $00, $00, $07, $3c, $20, $00, $ff, $3a, $00, $00, $07, $3a, $20

;@ def VfxClink(c: c)
;@ path: gfx/vfx
;@ Visual effect 5, the clink star: two sprites from VfxType5Sprites, frame by bit 3 of the timer.
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxClink::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> frame = hMultiPurpose0 & 8
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
;> return DrawVfxSpritePair(VfxType5Sprites, frame)
	ld hl, VfxType5Sprites
	jp DrawVfxSpritePair


;@ path: gfx/vfx
;@ Sprites of visual effect 1 (a splash of water), 8 bytes per frame (two OAM sprites of y offset,
;@ x offset, tile, attributes; tile $18 and its mirror): frame 0 small, frame 1 wide.
VfxType1Sprites::
	db $f6, $fe, $18, $00, $f8, $0a, $18, $20, $fc, $00, $18, $00, $fe, $08, $18, $20
;@ path: gfx/vfx
;@ Sprites of visual effect 12 (the splash under Link's feet while he dashes through shallow water),
;@ same layout as VfxType1Sprites.
VfxType12Sprites::
	db $00, $fa, $18, $00, $00, $0e, $18, $20, $02, $fc, $18, $00, $02, $0c, $18, $20

;@ def VfxDashSplash(c: c)
;@ path: gfx/vfx
;@ Visual effect 12: the dash splash, drawn like the splash from VfxType12Sprites.
VfxDashSplash::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> return VfxSplashDraw(VfxType12Sprites)
	ld hl, VfxType12Sprites
	jr VfxSplashDraw

;@ def VfxSplash(c: c)
;@ path: gfx/vfx
;@ Visual effect 1, a splash: two sprites from VfxType1Sprites, frame by bit 3 of the timer (when
;@ $C1A7 is 2, the sprites of VfxType1SpritesAlt are used instead).
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxSplash::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> if mem[0xC1A7] == 2:
	ld a, [$c1a7]
	cp $02
;>     return VfxSplashAlt()
	jp z, VfxSplashAlt

;> table = VfxType1Sprites
	ld hl, VfxType1Sprites

VfxSplashDraw:
;> # (VfxSplashDraw: also used by VfxDashSplash)
;> frame = hMultiPurpose0 & 8
	ldh a, [hMultiPurpose0]
	and $08
	ld e, a
	ld d, $00
;> DrawVfxSpritePair(table, frame)              # (falls through)

;@ def DrawVfxSpritePair(table: hl, offset: de)
;@ path: gfx/vfx
;@ Draws two sprites of an effect: the 8 bytes at table + offset (two times y offset, x offset, tile,
;@ attributes) are added to the effect's position (hMultiPurpose1 / 2) and written to the next free
;@ effect OAM entries (wOAMBuffer + $30 + wOAMNextIndex).
DrawVfxSpritePair::
;> src = table + offset
	add hl, de
	push hl
;>@oam oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
	push hl
;=@oam
	pop de
	pop hl
;> CopyVfxSprite(src, oam)
	call CopyVfxSprite
;> CopyVfxSprite(src + 4, oam + 4)
	call CopyVfxSprite
;> AdvanceVfxOAM(2)
	ld a, $02
	call AdvanceVfxOAM
	ret


;@ def CopyVfxSprite(src: hl, oam: de)
;@ path: gfx/vfx
;@ Writes one OAM entry: y = hMultiPurpose1 + src[0], x = hMultiPurpose2 + src[1], tile src[2],
;@ attributes src[3]; both pointers move on by 4.
;@ test: skip the trial cannot run it to its end
CopyVfxSprite::
;> mem[oam] = hMultiPurpose1 + mem[src]
	ldh a, [hMultiPurpose1]
	add [hl]
	ld [de], a
	inc hl
	inc de
;> mem[oam + 1] = hMultiPurpose2 + mem[src + 1]
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [de], a
	inc hl
	inc de
;> mem[oam + 2] = mem[src + 2]
	ld a, [hli]
	ld [de], a
	inc de
;> mem[oam + 3] = mem[src + 3]
	ld a, [hli]
	ld [de], a
	inc de
	ret


;@ path: gfx/vfx
;@ Alternate sprites of visual effect 1 (used while $C1A7 is 2), same layout as VfxType1Sprites: frame 0
;@ tile $7A and its mirror, frame 1 tile $78 and its mirror.
VfxType1SpritesAlt::
	db $00, $00, $7a, $00, $00, $08, $7a, $20, $00, $00, $78, $00, $00, $08, $78, $20

;@ def VfxSplashAlt()
;@ path: gfx/vfx
;@ The other look of visual effect 1: two sprites from VfxType1SpritesAlt, frame by bit 3 of the timer.
VfxSplashAlt::
;> frame = hMultiPurpose0 & 8
	ldh a, [hMultiPurpose0]
	and $08
	ld d, $00
	ld e, a
;> return DrawVfxSpritePair(VfxType1SpritesAlt, frame)
	ld hl, VfxType1SpritesAlt
	jp DrawVfxSpritePair


;@ path: gfx/vfx
;@ Sprites of the smoke puff (visual effects 2-4), 8 bytes per frame (two OAM sprites of y offset,
;@ x offset, tile, attributes), index = (timer << 1) & $18: frames 0-1 tile $32, frames 2-3 tile $30,
;@ each with its mirror image on the right.
VfxSmokeSprites::
	db $00, $00, $32, $00, $00, $08, $32, $20, $00, $00, $32, $00, $00, $08, $32, $20
	db $00, $00, $30, $00, $00, $08, $30, $20, $00, $00, $30, $00, $00, $08, $30, $20

;@ def VfxSmoke(c: c)
;@ path: gfx/vfx
;@ Visual effects 2-4, a puff of smoke. When the timer reaches 4, type 3 makes a chest appear
;@ (RevealChest) and type 4 a staircase (RevealStairs).
;@ test: skip draws through AdvanceVfxOAM, which reads a data table by index the trial's stand-ins cannot
VfxSmoke::
;> LoadVfxPosition(c)
	call LoadVfxPosition
;> if hMultiPurpose0 == 4:
	ldh a, [hMultiPurpose0]
	cp $04
	jr nz, .type4

;>     if wVfxType[c] == 3:
	ld hl, wVfxType
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, .type4

;>         RevealChest()
	call RevealChest
	jr .draw

.type4
;>     elif wVfxType[c] == 4:                   # (when the timer is not 4, a = timer here: no match)
	cp $04
	jr nz, .draw

;>         RevealStairs()

	call RevealStairs

.draw
;>@d return DrawVfxSpritePair(VfxSmokeSprites, (hMultiPurpose0 << 1) & 0x18)
	ldh a, [hMultiPurpose0]
	rla
	and $18
	ld d, $00
	ld e, a
	ld hl, VfxSmokeSprites
;=@d
	jp DrawVfxSpritePair


;@ def LoadVfxPosition(c: c)
;@ test: skip indexes with bc and needs b = 0, which the trial's random registers do not keep
;@ path: gfx/vfx
;@ Loads the effect's position into hMultiPurpose1 (y) and hMultiPurpose2 (x); an effect that is below
;@ the play area (y >= $88) or past its right edge (x >= $A8) is freed.
LoadVfxPosition::
;> hMultiPurpose1 = wVfxY[c]
	ld hl, wVfxY
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> if hMultiPurpose1 >= 0x88:
	cp $88
;>     return FreeVfxSlot(c)
	jr nc, FreeVfxSlot

;> hMultiPurpose2 = wVfxX[c]
	ld hl, wVfxX
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;> if hMultiPurpose2 < 0xA8:
	cp $a8
;>     return
	jr c, jr_002_56e1

;> FreeVfxSlot(c)                              # (falls through)

;@ def FreeVfxSlot(c: c)
;@ test: skip indexes with bc and needs b = 0, which the trial's random registers do not keep
;@ path: gfx/vfx
;@ Frees visual effect slot c.
FreeVfxSlot::
;> wVfxType[c] = 0
	ld hl, wVfxType
	add hl, bc
	xor a
	ld [hl], a

jr_002_56e1:
	ret


;@ path: gfx/vfx
;@ OAM offsets (multiples of 8 bytes = two entries) where the effects start drawing once their OAM
;@ share is used up; picked by (hFrameCounter + slot) & 7, so the sprites flicker in turn.
VfxOAMStartOffsets::
	db $00, $08, $10, $18, $20, $28, $30, $38

;@ def AdvanceVfxOAM(count: a)
;@ path: gfx/vfx
;@ After an effect drew `count` sprites: moves wOAMNextIndex on by count * 4 (wrapping at $60) and adds
;@ them to wOAMEntriesUsed; once $60 bytes have been handed out the next effect starts at a rotating
;@ offset (VfxOAMStartOffsets), so that too many sprites flicker instead of vanishing.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
AdvanceVfxOAM::
;> n = count * 4
	sla a
	sla a
	ld e, a
;> wOAMNextIndex = (wOAMNextIndex + n) % 0x60
	ld a, [wOAMNextIndex]
	add e
	cp $60
	jr c, .store

	sub $60

.store
	ld [wOAMNextIndex], a
;> wOAMEntriesUsed += n
	ld a, [wOAMEntriesUsed]
	add e
	ld [wOAMEntriesUsed], a
;> if wOAMEntriesUsed >= 0x60:
	cp $60
	jr c, .done

;>@rot     wOAMNextIndex = VfxOAMStartOffsets[(hFrameCounter + wActiveEntitySlot) & 7]
	ldh a, [hFrameCounter]
	ld hl, wActiveEntitySlot
	add [hl]
	and $07
	ld e, a
	ld d, $00
;=@rot
	ld hl, VfxOAMStartOffsets
	add hl, de
	ld a, [hl]
	ld [wOAMNextIndex], a

.done
	ret


;@ def AddSplashAtLink()
;@ path: gfx/vfx
;@ A splash (visual effect 1, jingle $0E) at Link's feet; AddSplashAtLinkY takes the y position in a.
AddSplashAtLink::
;> AddSplashAtLinkY(hLinkY)                     # (falls through)
	ldh a, [hLinkY]

;@ def AddSplashAtLinkY(y: a)
;@ path: gfx/vfx
;@ A splash (visual effect 1) at (hLinkX, y), with jingle $0E.
AddSplashAtLinkY::
;> hMultiPurpose1 = y
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hLinkX
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;> hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;> AddTransientVfx(1)
	ld a, $01
	call AddTransientVfx
	ret


;@ path: object/doors
;@ Masks that clear one bit of the shutter door bits (wRoomShutterDoors / wRoomShutterDoorsCopy):
;@ index = door - 4 for the shutter doors 4-7 ($FE, $FD, $FB, $F7). Read by UpdateRoomDoors.
DoorClearMasks::
	db $fe, $fd, $fb, $f7

;@ def UpdateRoomDoors()
;@ path: object/doors
;@ Runs every frame indoors (from bank 0): the room's event first, then a door animation in progress
;@ (opening or closing, Link may not walk meanwhile), else the next shutter door to open or close:
;@ the doors 4-7 whose bits are set in wRoomShutterDoors (open) or wRoomShutterDoorsCopy (close).
UpdateRoomDoors::
;> if wDialogState or wRoomTransitionState or wInventoryAppearing:
	ld hl, wDialogState
	ld a, [wRoomTransitionState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
;>     return
	jr nz, .done

;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return
	jr z, .done

;> RunRoomEvent()                               # the room's event
	call RunRoomEvent
;> if wDoorAnimation:
	ld a, [wDoorAnimation]
	and a
	jr z, .noAnimation

;>     hLinkInteractiveMotionBlocked = 1
	cp $02
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;>     if wDoorAnimation != 2:
	jr z, .close

;>         OpenDoorStep()                       # opening
	call OpenDoorStep
;>         return
	jr .done

.close
;>     else:
;>         CloseDoorStep()                       # closing
	call CloseDoorStep

.done
;>     return
	ret


.noAnimation
;> if wOpenShuttersRequest:
	ld a, [wOpenShuttersRequest]
	and a
	jr z, .closeRequest

;>     door = 3
	ld e, $03
;>     doors = wRoomShutterDoors
	ld a, [wRoomShutterDoors]
	ld c, a

.findOpen
;>     while True:
;>         door += 1
	inc e
;>         if door == 8:                        # none left
	ld a, e
	cp $08
	jr z, .openDone
;>@o1             wOpenShuttersRequest = 0
;>@o1             return
;>         carry = doors & 1
;>         doors >>= 1
	srl c
;>         if carry: break
	jr nc, .findOpen

;>     wRoomShutterDoors &= DoorClearMasks[door - 4]
	ld d, $00
	ld hl, DoorClearMasks - 4
	add hl, de
	ld a, [wRoomShutterDoors]
	and [hl]
	ld [wRoomShutterDoors], a
;>     wDoorAnimIndex = door
	ld a, e
	ld [wDoorAnimIndex], a
;>     wDoorAnimFrame = 0
	xor a
	ld [wDoorAnimFrame], a
;>     wDoorAnimation = 1                       # open it
	inc a
	ld [wDoorAnimation], a
;>     return
	ret


.openDone
;=@o1
	xor a
	ld [wOpenShuttersRequest], a
	ret


.closeRequest
;> if not wCloseShuttersRequest:
	ld a, [wCloseShuttersRequest]
	and a
	jr nz, .close2

;>     return
	ret


.close2
;> door = 3
	ld e, $03
;> doors = wRoomShutterDoorsCopy
	ld a, [wRoomShutterDoorsCopy]
	ld c, a

.findClose
;> while True:
;>     door += 1
	inc e
;>     if door == 8:
	ld a, e
	cp $08
	jr z, .closeDone
;>@c1         wCloseShuttersRequest = 0
;>@c1         return
;>     carry = doors & 1
;>     doors >>= 1
	srl c
;>     if carry: break
	jr nc, .findClose

;> wRoomShutterDoorsCopy &= DoorClearMasks[door - 4]
	ld d, $00
	ld hl, DoorClearMasks - 4
	add hl, de
	ld a, [wRoomShutterDoorsCopy]
	and [hl]
	ld [wRoomShutterDoorsCopy], a
;> wDoorAnimIndex = door
	ld a, e
	ld [wDoorAnimIndex], a
;> wDoorAnimation = 2                           # close it
	ld a, $02
	ld [wDoorAnimation], a
;> wDoorAnimFrame = 0
	xor a
	ld [wDoorAnimFrame], a
	ret


.closeDone
;=@c1
	xor a
	ld [wCloseShuttersRequest], a
	ret


;@ path: object/doors
;@ Background tiles of the opening doors, 72 bytes: index = half * $24 + door * 4 + row * 2 + column.
;@ door = wDoorAnimIndex: 0-3 locked doors (top, bottom, left, right), 4-7 shutters (same order), 8 the
;@ boss door (top); half 0 is shown for 8 frames (half open), half 1 at the end (open). Each door is
;@ drawn as 2 rows of 2 tiles at DoorColumnX / DoorRowDY from its position. Read by OpenDoorStep.
DoorOpenTiles::
	db $50, $51, $13, $12, $11, $10, $42, $43, $45, $13, $55, $11, $12, $46, $10, $56
	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $02, $03, $13, $12, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12

;@ path: object/doors
;@ X offset (pixels) of the drawn door tiles from wDoorX, by door 0-8 ($08 for top / bottom doors,
;@ 0 for side doors). The last 9 bytes are not read. Read by OpenDoorStep.
DoorColumnX::
	db $08, $08, $00, $00, $08, $08, $00, $00
	db $08, $08, $08, $00, $00, $08, $08, $00, $00, $08

;@ path: object/doors
;@ Y offset (pixels) of the two drawn tile rows of an opening door from wDoorY, index = row * 9 + door
;@ (row 0: $00 / $08, row 1: 8 further down). Read by OpenDoorStep.
DoorRowDY::
	db $00, $00, $08, $08, $00, $00
	db $08, $08, $00, $08, $08, $10, $10, $08, $08, $10, $10, $08

;@ path: object/doors
;@ Offset added to the door's square index (wDoorPosition) for the two room squares a door covers,
;@ index = (door & 7) and (door & 7) + 8: the first square itself, the second one to the right ($01,
;@ top / bottom doors) or below ($10, side doors). Read by OpenDoorStep.
DoorSquareOffsets::
	db $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $01, $10, $10, $01, $01, $10, $10

;@ path: object/doors
;@ Room objects placed in those two squares when a door has opened (the open doorway), same index as
;@ DoorSquareOffsets. Read by OpenDoorStep.
DoorOpenObjects::
	db $43, $8c, $09, $0b
	db $43, $8c, $09, $0b, $44, $08, $0a, $0c, $44, $08, $0a, $0c

;@ path: object/doors
;@ Room status bit that records an open door, by door 0-8: $04 top, $08 bottom, $02 left, $01 right.
;@ Read by OpenDoorStep (set) and CloseDoorStep (cleared).
DoorRoomStatusBits::
	db $04, $08, $02, $01
	db $04, $08, $02, $01, $04

;@ path: object/doors
;@ Step to the neighbouring room on the dungeon grid behind a door, by door 0-8 (-8 above, +8 below,
;@ -1 left, +1 right). Read by OpenDoorStep.
DoorNeighbourRoomDelta::
	db $f8, $08, $ff, $01, $f8, $08, $ff, $01, $f8

;@ path: object/doors
;@ Status bit set in that neighbouring room (the same door seen from the other side: top door -> its
;@ bottom bit $08, ...), by door 0-8. Read by OpenDoorStep.
DoorNeighbourStatusBits::
	db $08, $04
	db $01, $02, $08, $04, $01, $02, $08

;@ def OpenDoorStep()
;@ path: object/doors
;@ One frame of the door opening animation (door wDoorAnimIndex, frame wDoorAnimFrame): both tile rows
;@ are queued in the half-open look for 8 frames, then in the open look; after that the two squares
;@ become open doorway objects and the door is recorded as open in this room and in the room behind it.
;@ test: skip draws through the BG command queue
OpenDoorStep::
;>@base base = wDoorAnimIndex * 4                    # offset into DoorOpenTiles
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [hMultiPurposeC], a
;=@base
	ldh [hMultiPurposeE], a
	ld a, [wDoorAnimIndex]
	ld c, a
	and a
	jr z, .setX

	xor a

.times4
;=@base
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, .times4

.setX
;>@x hBGPosX = DoorColumnX[wDoorAnimIndex] + wDoorX[wDoorAnimIndex]
	ld hl, DoorColumnX
	ld a, [wDoorAnimIndex]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
;=@x
	ld hl, wDoorX
	add hl, bc
	add [hl]
	ldh [hBGPosX], a

OpenDoorRows:
;> for row in (0, 9):                           # hMultiPurposeC: 0, then 9 (the second row)
;>@y     hBGPosY = DoorRowDY[row + wDoorAnimIndex] + wDoorY[wDoorAnimIndex]
	ld hl, DoorRowDY
	ldh a, [hMultiPurposeC]
	ld c, a
	add hl, bc
	ld a, [wDoorAnimIndex]
	ld c, a
;=@y
	add hl, bc
	ld a, [hl]
	ld hl, wDoorY
	add hl, bc
	add [hl]
	ldh [hBGPosY], a
;>     GetBGAddress()
	push de
	call GetBGAddress
	pop de
;>     if row:
	ldh a, [hMultiPurposeC]
	and a
	jr z, .command

;>         base += 2
	inc de
	inc de

.command
;>@cmd     cmd = wDrawCommand + wDrawCommandsSize   # 5 bytes: address, $01 (2 tiles), the tiles
	ld a, [wDrawCommandsSize]
	ld c, a
	ld b, $00
	add $05
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
;=@cmd
	add hl, bc
;>     mem[cmd + 0] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;>     mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;>     mem[cmd + 2] = 0x01
	ld a, $01
	ld [hli], a
;>     mem[cmd + 3] = DoorOpenTiles[base]
	push hl
	ld hl, DoorOpenTiles
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;>     mem[cmd + 4] = DoorOpenTiles[base + 1]
	push hl
	ld hl, DoorOpenTiles + 1
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
;>     if row == 0:
	ldh a, [hMultiPurposeC]
	and a
	jr nz, .rowsDone

;>         hMultiPurposeC = 9
	ld a, $09
	ldh [hMultiPurposeC], a
;>         continue
	jp OpenDoorRows


.rowsDone
;> mem[cmd + 5] = 0                             # end of the queue
	xor a
	inc hl
	ld [hl], a
;> wDoorAnimFrame += 1
	ld a, [wDoorAnimFrame]
	add $01
	ld [wDoorAnimFrame], a
;> if wDoorAnimFrame < 8:
	ld a, [wDoorAnimFrame]
	cp $08
	jr nc, .halfDone

;>     return
	ret


.halfDone
;> if not hMultiPurposeE:                       # now the open look, once
	ldh a, [hMultiPurposeE]
	and a
	jr nz, .finish

;>     hMultiPurposeC = 0
	xor a
	ldh [hMultiPurposeC], a
;>@b2     base += 0x24 - 2                         # second half of DoorOpenTiles
	ld a, e
	add $24
	ld e, a
	ld d, $00
;=@b2
	ldh [hMultiPurposeE], a
	dec de
	dec de
;>     return OpenDoorRows()                  # back to the row loop above
	jp OpenDoorRows


.finish
;> wDoorAnimation = 0
	xor a
	ld [wDoorAnimation], a
;> wLinkShowItemPoseActive = 0
	ld [wLinkShowItemPoseActive], a
;> hMultiPurposeE = 0
	xor a
	ldh [hMultiPurposeE], a
;>@pos hMultiPurpose0 = wDoorPosition[wDoorAnimIndex]
	ld a, [wDoorAnimIndex]
	ld c, a
	ld b, $00
	ld hl, wDoorPosition
	add hl, bc
	ld a, [hl]
;=@pos
	ldh [hMultiPurpose0], a
;> i = wDoorAnimIndex & 7
	ld a, c
	and $07
	ld c, a

.squares
;> while True:                                  # the two squares of the door: i, then i + 8
;>@sq     wRoomObjects[hMultiPurpose0 + DoorSquareOffsets[i]] = DoorOpenObjects[i]
	ld hl, DoorSquareOffsets
	add hl, bc
	ld a, [hl]
	ld hl, hMultiPurpose0
	add [hl]
	ld e, a
;=@sq
	ld d, $00
	ld hl, DoorOpenObjects
	add hl, bc
	ld a, [hl]
	ld hl, wRoomObjects
	add hl, de
;=@sq
	ld [hl], a
;>     if hMultiPurposeE: break                 # the second square is done
	ldh a, [hMultiPurposeE]
	and a
	jr nz, .status

;>     i += 8
;>     hMultiPurposeE = i
	ld a, c
	add $08
	ldh [hMultiPurposeE], a
	ld c, a
	jr .squares

.status
;> status = GetRoomStatusAddress_02()
	call GetRoomStatusAddress_02
	push hl
	pop bc
;>@st mem[status] |= DoorRoomStatusBits[wDoorAnimIndex]
	ld a, [wDoorAnimIndex]
	ld e, a
	ld d, $00
	ld hl, DoorRoomStatusBits
	add hl, de
	ld a, [bc]
;=@st
	or [hl]
	ld [bc], a
;> hRoomStatus = mem[status]
	ldh [hRoomStatus], a
;> neighbour = GetDungeonRoomStatusAddress(wIndoorRoom + DoorNeighbourRoomDelta[wDoorAnimIndex])
	ld hl, DoorNeighbourRoomDelta
	add hl, de
	ld a, [wIndoorRoom]
	add [hl]
	ld e, a
	call GetDungeonRoomStatusAddress
;>@nb mem[neighbour] |= DoorNeighbourStatusBits[wDoorAnimIndex]
	push hl
	pop bc
	ld a, [wDoorAnimIndex]
	ld e, a
	ld d, $00
	ld hl, DoorNeighbourStatusBits
;=@nb
	add hl, de
	ld a, [bc]
	or [hl]
	ld [bc], a
	ret


;@ def GetRoomStatusAddress() -> hl
;@ path: world/rooms
;@ Address of the current room's byte in wRoomStatus: the overworld group, or for indoor maps the first
;@ indoor group (maps $00-$05 and $1A-$1F) or the second (maps $06-$19).
;@ test: hMapRoom = rand(0, 255); wIsIndoor = rand(0, 1); hMapId = rand(0, 0x1F)
GetRoomStatusAddress_02::
;> group = wIsIndoor
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
;> if wIsIndoor:
	and a
	jr z, .add

;>     if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .add

	cp $06
	jr c, .add

;>         group += 1
	inc d

.add
;> return wRoomStatus + group * 0x100 + hMapRoom
	add hl, de
	ret


;@ path: object/doors
;@ Background tiles of the closing shutter doors, 32 bytes: index = half * $10 + (door - 4) * 4 + row * 2
;@ + column, for the shutters 4-7 (top, bottom, left, right); half 0 for the first 8 frames, half 1 at
;@ the end. Read by CloseDoorStep.
DoorCloseTiles::
	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $40, $41, $58, $59, $4a, $4b, $52, $53, $44, $4d, $54, $5d, $4e, $47, $5e, $57
;@ path: object/doors
;@ X offset (pixels) of the closing shutter's tiles from wDoorX, by door - 4 (first 4 bytes; the
;@ other 4 are not read). Read by CloseDoorStep.
DoorCloseColumnX::
	db $08, $08, $00, $00, $08, $08, $00, $00

;@ path: object/doors
;@ Y offset of the two tile rows of a closing shutter from wDoorY, index = row * 4 + door - 4.
DoorCloseRowDY::
	db $00, $00, $08, $08, $08, $08, $10, $10
;@ path: object/doors
;@ Offset added to wDoorPosition for the two squares of a closing shutter, index = door - 4 and
;@ door - 4 + 4 (the second square to the right or below).
DoorCloseSquareOffsets::
	db $00, $00, $00, $00, $01, $01, $10, $10

;@ path: object/doors
;@ Room objects of a closed shutter in those two squares, same index as DoorCloseSquareOffsets.
DoorCloseObjects::
	db $35, $37, $39, $3b, $36, $38, $3a, $3c

;@ def CloseDoorStep()
;@ path: object/doors
;@ One frame of a shutter closing (doors 4-7): like OpenDoorStep with the closing tiles, and when Link's
;@ respawn point lies in the door's way it moves to where Link stands. At the end the squares become
;@ closed shutter objects and the room's door bit is cleared.
;@ test: skip draws through the BG command queue
CloseDoorStep::
;> j = wDoorAnimIndex - 4
;>@base base = j * 4                                 # offset into DoorCloseTiles
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [hMultiPurposeC], a
;=@base
	ldh [hMultiPurposeD], a
	ldh [hMultiPurposeE], a
	ld a, [wDoorAnimIndex]
	sub $04
	jr z, .setX

	ld c, a
;=@base
	xor a

.times4
;=@base
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, .times4

.setX
;>@x hBGPosX = DoorCloseColumnX[j] + wDoorX[wDoorAnimIndex]
	ld hl, DoorCloseColumnX - 4
	ld a, [wDoorAnimIndex]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
;=@x
	ld hl, wDoorX
	add hl, bc
	add [hl]
	ldh [hBGPosX], a

CloseDoorRows:
;> for row in (0, 4):                           # hMultiPurposeC
;>@y     hBGPosY = DoorCloseRowDY[row + j] + wDoorY[wDoorAnimIndex]
	ld hl, DoorCloseRowDY - 4
	ldh a, [hMultiPurposeC]
	ld c, a
	add hl, bc
	ld a, [wDoorAnimIndex]
	ld c, a
;=@y
	add hl, bc
	ld a, [hl]
	ld hl, wDoorY
	add hl, bc
	add [hl]
	ldh [hBGPosY], a
;>@resp     if abs(wLinkRespawnY - 0x10 - hBGPosY) < 0x10 and abs(wLinkRespawnX - 8 - hBGPosX) < 0x10:
	ld a, [wLinkRespawnY]
	sub $10
	ld hl, hBGPosY
	sub [hl]
	add $10
	cp $20
;=@resp
	jr nc, .bg

	ld a, [wLinkRespawnX]
	sub $08
	ld hl, hBGPosX
	sub [hl]
	add $10
;=@resp
	cp $20
	jr nc, .bg

;>         wLinkRespawnX = hLinkX               # do not respawn inside the shutter
	ldh a, [hLinkX]
	ld [wLinkRespawnX], a
;>         wLinkRespawnY = hLinkY
	ldh a, [hLinkY]
	ld [wLinkRespawnY], a

.bg
;>     GetBGAddress()
	push de
	call GetBGAddress
	pop de
;>     if row:
	ldh a, [hMultiPurposeC]
	and a
	jr z, .command

;>         base += 2
	inc de
	inc de

.command
;>@cmd     cmd = wDrawCommand + wDrawCommandsSize   # 5 bytes: address, $01 (2 tiles), the tiles
	ld a, [wDrawCommandsSize]
	ld c, a
	ld b, $00
	add $05
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
;=@cmd
	add hl, bc
;>     mem[cmd + 0] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;>     mem[cmd + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;>     mem[cmd + 2] = 0x01
	ld a, $01
	ld [hli], a
;>     mem[cmd + 3] = DoorCloseTiles[base]
	push hl
	ld hl, DoorCloseTiles
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;>     mem[cmd + 4] = DoorCloseTiles[base + 1]
	push hl
	ld hl, DoorCloseTiles + 1
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
;>     if row == 0:
	ldh a, [hMultiPurposeC]
	and a
	jr nz, .rowsDone

;>         hMultiPurposeC = 4
	ld a, $04
	ldh [hMultiPurposeC], a
;>         continue
	jp CloseDoorRows


.rowsDone
;> mem[cmd + 5] = 0
	xor a
	inc hl
	ld [hl], a
;> wDoorAnimFrame += 1
	ld a, [wDoorAnimFrame]
	add $01
	ld [wDoorAnimFrame], a
;> if wDoorAnimFrame < 8:
	ld a, [wDoorAnimFrame]
	cp $08
	jr nc, .halfDone

;>     return
	ret


.halfDone
;> if not hMultiPurposeE:                       # now the closed look, once
	ldh a, [hMultiPurposeE]
	and a
	jr nz, .finish

;>     hMultiPurposeC = 0
	xor a
	ldh [hMultiPurposeC], a
;>@b2     base += 0x10 - 2                         # second half of DoorCloseTiles
	ld a, e
	add $10
	ld e, a
	ld d, $00
;=@b2
	ldh [hMultiPurposeE], a
	dec de
	dec de
;>     return CloseDoorRows()                  # back to the row loop above
	jp CloseDoorRows


.finish
;> wDoorAnimation = 0
	xor a
	ld [wDoorAnimation], a
;> wLinkShowItemPoseActive = 0
	ld [wLinkShowItemPoseActive], a
;> hMultiPurposeE = 0
	xor a
	ldh [hMultiPurposeE], a
;>@pos hMultiPurpose0 = wDoorPosition[wDoorAnimIndex]
	ld a, [wDoorAnimIndex]
	sub $04
	ld c, a
	ld b, $00
	ld hl, wDoorPosition + 4
	add hl, bc
;=@pos
	ld a, [hl]
	ldh [hMultiPurpose0], a

.squares
;> while True:                                  # the two squares of the shutter: i = j, then j + 4
;>@sq     wRoomObjects[hMultiPurpose0 + DoorCloseSquareOffsets[i]] = DoorCloseObjects[i]
	ld hl, DoorCloseSquareOffsets
	add hl, bc
	ld a, [hl]
	ld hl, hMultiPurpose0
	add [hl]
	ld e, a
;=@sq
	ld d, $00
	ld hl, DoorCloseObjects
	add hl, bc
	ld a, [hl]
	ld hl, wRoomObjects
	add hl, de
;=@sq
	ld [hl], a
;>     if hMultiPurposeE: break                 # the second square is done
	ldh a, [hMultiPurposeE]
	and a
	jr nz, .status

;>     i += 4
;>     hMultiPurposeE = i
	ld a, c
	add $04
	ldh [hMultiPurposeE], a
	ld c, a
	jr .squares

.status
;>@sa status = wRoomStatus + (0x100 if wIsIndoor else 0) + hMapRoom
	ld hl, wRoomStatus
	ld a, [wIsIndoor]
	and a
	jr z, .room

	ld hl, wRoomStatus + $100

.room
;=@sa
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
;>@clr mem[status] &= ~DoorRoomStatusBits[wDoorAnimIndex]
	push hl
	ld a, [wDoorAnimIndex]
	ld e, a
	ld d, $00
	ld hl, DoorRoomStatusBits
	add hl, de
;=@clr
	ld a, [hl]
	cpl
	pop hl
	and [hl]
	ld [hl], a
;> hRoomStatus = mem[status]
	ldh [hRoomStatus], a
	ret


;@ def RunRoomEvent()
;@ path: world/room_events
;@ The room's event (wRoomEvent): bits 0-4 pick the trigger, checked each frame (CheckRoomEventTrigger),
;@ bits 5-7 the action that RoomEventActions runs: 0 none, 1 shutters close behind Link and open when
;@ the trigger fires, 2 all enemies die, 3 a chest appears, 4 an item falls down, 5 stairs appear,
;@ 6 shutters as 1 but only until the dungeon's flag is set, 7 an entity ($2F) drops in.
RunRoomEvent::
;> if not wRoomEvent:
	ld a, [wRoomEvent]
	and a
;>     return
	jp z, Jump_002_5bc8

;> CheckRoomEventTrigger(wRoomEvent)
	call CheckRoomEventTrigger
;>@act return RoomEventActions[wRoomEvent >> 5]()
	ld a, [wRoomEvent]
	and $e0
	srl a
	srl a
	srl a
	srl a
;=@act
	srl a
	rst $00

;@ path: world/room_events
;@ Room event actions, by bits 5-7 of wRoomEvent (2-byte code addresses, run by RunRoomEvent).
RoomEventActions::
	dw RoomEventNone
	dw RoomEventShutters
	dw RoomEventKillEnemies
	dw RoomEventChest
	dw RoomEventDropItem
	dw RoomEventStairs
	dw RoomEventShuttersOnce
	dw RoomEventDropEntity

;@ def RoomEventKillEnemies()
;@ path: world/room_events
;@ Event action 2: once the trigger fires, every living enemy (status 5 and up, not flagged $80 in its
;@ physics flags) starts dying.
RoomEventKillEnemies::
;> RoomEventFired()                             # returns from here until the trigger fires
	call RoomEventFired
;> for c in range(15, -1, -1):
	ld c, $0f
	ld b, $00

.loop
;>     if not (wEntityPhysicsFlags[c] & 0x80):
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, .next

;>         if wEntityStatus[c] >= 5:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, .next

;>             wEntityStatus[c] = 1             # dying
	ld [hl], $01
;>             wEntityDyingTimer[c] = 0x1F
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $1f
;>             wEntityPhysicsFlags[c] = (wEntityPhysicsFlags[c] & 0xF0) | 0x02
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $02
	ld [hl], a
;>             hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a

.next
	dec c
	ld a, c
	cp $ff
	jr nz, .loop

;> return
	ret


;@ def RoomEventFired()
;@ path: world/room_events
;@ Lets an event action go on only once: when the trigger has fired (wRoomEventDone) and the room has
;@ not recorded its event yet (room status bit 4), the event is cleared and the action continues;
;@ otherwise this returns straight out of the action (it drops its own return address).
;@ test: skip returns from its caller
RoomEventFired::
;> if not (hRoomStatus & 0x10):
	ldh a, [hRoomStatus]
	and $10
	jr nz, .abort

;>     if wRoomEventDone:
	ld a, [wRoomEventDone]
	and a
	jr z, .abort

;>         wRoomEvent = 0
	xor a
	ld [wRoomEvent], a
;>         return                               # the action goes on
	ret


.abort
;> return_from_caller()
	pop af
	ret


;@ def RoomEventDropEntity()
;@ path: world/room_events
;@ Event action 7: entity $2F drops into the room at (x $88, y $30) in a puff of smoke, and the room
;@ records its event as done.
RoomEventDropEntity::
;> RoomEventFired()
	call RoomEventFired
;> e = SpawnEntity(0x2F)
	ld a, $2f
	call SpawnEntity
;> wEntityX[e] = 0x88
	ld hl, wEntityX
	add hl, de
	ld [hl], $88
;> wEntityY[e] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> wEntityDropTimer[e] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;> hMultiPurpose0 = 0x88
	ld a, $88
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = 0x30
	ld a, $30
	ldh [hMultiPurpose1], a
;> return RoomEventVfxDone(2)                    # smoke
	ld a, $02
	jp RoomEventVfxDone


;@ def RoomEventStairs()
;@ path: world/room_events
;@ Event action 5: stairs appear at (x $88, y $20) after a puff of smoke (visual effect 4, which ends
;@ in RevealStairs), and the room records its event as done.
RoomEventStairs::
;> RoomEventFired()
	call RoomEventFired
;> hMultiPurpose0 = 0x88
	ld a, $88
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = 0x20
	ld a, $20
	ldh [hMultiPurpose1], a
;> vfx = 4
	ld a, $04

RoomEventVfxDone:
;> AddTransientVfx(vfx)                         # at (hMultiPurpose0, hMultiPurpose1)
	call AddTransientVfx
;> status = GetRoomStatusAddress_02()
	call GetRoomStatusAddress_02
;> mem[status] |= 0x10                          # the room's event is done
	ld a, [hl]
	or $10
	ld [hl], a
;> hRoomStatus = mem[status]
	ldh [hRoomStatus], a

Jump_002_5bc8:
;> return
	ret


;@ def RoomEventDropItem()
;@ path: world/room_events
;@ Event action 4: the room's item falls down (SpawnFallingRoomEventItem); in room $69 the room also
;@ records its event as done.
;@ test: skip uses the slot SpawnEntity returns, which the trial's stand-in does not give
RoomEventDropItem::
;> RoomEventFired()
	call RoomEventFired
;> if hMapRoom == 0x69:
	ldh a, [hMapRoom]
	cp $69
	jr nz, .spawn

;>     status = GetRoomStatusAddress_02()
	call GetRoomStatusAddress_02
;>     mem[status] |= 0x10
	ld a, [hl]
	or $10
	ld [hl], a
;>     hRoomStatus = mem[status]
	ldh [hRoomStatus], a

.spawn
;> SpawnFallingRoomEventItem()
	call SpawnFallingRoomEventItem
	ret


;@ def RoomEventShuttersOnce()
;@ path: world/room_events
;@ Event action 6: the shutters of action 1, but only while bit 0 of the dungeon's wDungeonFlags is
;@ clear (it is set the first time the trigger fires).
;@ test: skip runs on into RoomEventShutters
RoomEventShuttersOnce::
;> flags = wDungeonFlags[hMapId]
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
;> if flags & 0x01:
	and $01
;>     return                                   # else on into RoomEventShutters
	jr nz, RoomEventShutters.done

;@ def RoomEventShutters()
;@ path: world/room_events
;@ Event action 1: the room's shutters close once Link has walked into the room, and open again when
;@ the trigger fires. With event $C1 (action 6, trigger 1) the dungeon flag bit 0 and status bit 5 of
;@ the room are set and a jingle plays.
RoomEventShutters::
;> if not wRoomEventShuttersClosed:
	ld a, [wRoomEventShuttersClosed]
	and a
	jr nz, .check

;>     CloseShuttersOnEntry()
	call CloseShuttersOnEntry

.check
;> if not wRoomEventDone:
	ld a, [wRoomEventDone]
	and a
;>     return
	jr z, .done

;> if wRoomEvent == 0xC1:
	ld a, [wRoomEvent]
	cp $c1
	jr nz, .open

;>@df     wDungeonFlags[hMapId] |= 0x01
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
;=@df
	or $01
	ld [hl], a
;>     group = 1                                # indoor rooms of this map: wRoomStatus + 0x100 ...
	ld d, $00
	ldh a, [hMapRoom]
	ld e, a
	ld hl, wRoomStatus + $100
;>     if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .set

	cp $06
	jr c, .set

;>         group = 2                            # ... or wRoomStatus + 0x200
	inc d

.set
;>     wRoomStatus[group * 0x100 + hMapRoom] |= 0x20
	add hl, de
	set 5, [hl]
;>     hJingle = 0x1B
	ld a, $1b
	ldh [hJingle], a

.open
;> if wRoomEventShuttersClosed:
	ld a, [wRoomEventShuttersClosed]
	and a
	jr z, .done

;>     wRoomEvent = 0
	xor a
	ld [wRoomEvent], a
;>     wOpenShuttersRequest = 1
	ld a, $01
	ld [wOpenShuttersRequest], a
;>     PlayUnlockSound()
	call PlayUnlockSound

.done
	ret


;@ def CloseShuttersOnEntry()
;@ path: world/room_events
;@ Closes the room's shutters once Link stands inside the room (x $11-$8E, y $16-$73), as long as the
;@ event's trigger has not fired yet.
CloseShuttersOnEntry::
;> if ((hLinkX - 0x11) & 0xFF) >= 0x7E:
	ldh a, [hLinkX]
	sub $11
	cp $7e
;>     return
	jr nc, .done

;> if ((hLinkY - 0x16) & 0xFF) >= 0x5E:
	ldh a, [hLinkY]
	sub $16
	cp $5e
;>     return
	jr nc, .done

;> if wRoomEventDone:
	ld a, [wRoomEventDone]
	and a
;>     return
	jr nz, .done

;> wCloseShuttersRequest = 1
	ld a, $01
	ld [wCloseShuttersRequest], a
;> wRoomEventShuttersClosed = 1
	ld [wRoomEventShuttersClosed], a
;> wLinkPoseLock = 4
	ld a, $04
	ld [wLinkPoseLock], a
;> hNoiseSfx = 0x10
	ld a, $10
	ldh [hNoiseSfx], a

.done
	ret


;@ path: world/room_events
;@ Background tiles of the chest that a room event makes appear: left column top / bottom, then the
;@ right column top / bottom. Read by RevealChest.
ChestTiles::
	db $60, $70, $61, $71

;@ def RoomEventChest()
;@ path: world/room_events
;@ Event action 3: a puff of smoke (visual effect 3, which ends in RevealChest) at x $88 and y $30, or
;@ y $40 when Link stands where the chest would appear.
RoomEventChest::
;> RoomEventFired()
	call RoomEventFired
;> hMultiPurpose0 = 0x88
	ld a, $88
	ldh [hMultiPurpose0], a
;> near = abs(hLinkY - 0x30) < 8
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, .far

;> near = near and abs(hLinkX - 0x88) < 0x10
	ldh a, [hLinkX]
	sub $88
	add $10
	cp $20
	jr nc, .far

;> if near:
;>     hMultiPurpose1 = 0x40
	ld a, $40
	jr .set

.far
;> else:
;>     hMultiPurpose1 = 0x30
	ld a, $30

.set
	ldh [hMultiPurpose1], a
;> AddTransientVfx(3)
	ld a, $03
	call AddTransientVfx
	ret


;@ def RevealChest()
;@ path: world/room_events
;@ Puts the chest of a room event into the room: object $A0 in the square at x $80 and y $20 (or y $30
;@ when Link stands near y $30), drawn with ChestTiles.
;@ test: skip draws through the BG command queue
RevealChest::
;> near = abs(hLinkY - 0x30) < 8
	ldh a, [hLinkY]
	sub $30
	add $08
	cp $10
	jr nc, .far

;> near = near and abs(hLinkX - 0x88) < 0x10
	ldh a, [hLinkX]
	sub $88
	add $10
	cp $20
	jr nc, .far

;> if near:
;>     hBGPosY = 0x30
	ld a, $30
	jr .set

.far
;> else:
;>     hBGPosY = 0x20
	ld a, $20

.set
	ldh [hBGPosY], a
;> hBGPosX = 0x80
	ld a, $80
	ldh [hBGPosX], a
;>@obj wRoomObjects[(hBGPosY & 0xF0) | (hBGPosX >> 4)] = 0xA0
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
;=@obj
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld a, $a0
	ld [hl], a
;> GetBGAddress()
	call GetBGAddress
;>@cmd cmd = wDrawCommand + wDrawCommandsSize; wDrawCommandsSize += 10
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
;=@cmd
	ld [wDrawCommandsSize], a
;> tiles = ChestTiles
	ld de, ChestTiles

DrawTwoTileColumns:
;> mem[cmd:cmd + 3] = (hBGAddrHigh, hBGAddrLow, 0x81)   # 2 tiles down
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;> mem[cmd + 3:cmd + 5] = tiles[0:2]
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;>@c2 mem[cmd + 5:cmd + 8] = (hBGAddrHigh, hBGAddrLow + 1, 0x81)
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c2
	ld [hli], a
;> mem[cmd + 8:cmd + 10] = tiles[2:4]
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
;> mem[cmd + 10] = 0                            # end of the queue
	xor a
	ld [hl], a
	ret


;@ path: world/room_events
;@ Background tiles of the staircase that a room event makes appear: left column top / bottom, then the
;@ right column top / bottom. Read by RevealStairs.
StairsTiles::
	db $6a, $7a, $6b, $7b

;@ def RevealStairs()
;@ path: world/room_events
;@ Puts the staircase of a room event into the room: object $BE in the square at x $80, y $10, drawn
;@ with StairsTiles, and arms the stairs (hStairsState) at x $88, y $20.
;@ test: skip draws through the BG command queue
RevealStairs::
;> hStairsState = 1
	ld a, $01
	ldh [hStairsState], a
;> hBGPosY = 0x10
	ld a, $10
	ldh [hBGPosY], a
;> hStairsY = 0x20
	add $10
	ldh [hStairsY], a
;> hBGPosX = 0x80
	ld a, $80
	ldh [hBGPosX], a
;> hStairsX = 0x88
	add $08
	ldh [hStairsX], a
;>@obj wRoomObjects[(hBGPosY & 0xF0) | (hStairsX >> 4)] = 0xBE
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
;=@obj
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ld a, $be
	ld [hl], a
;> GetBGAddress()
	call GetBGAddress
;>@cmd cmd = wDrawCommand + wDrawCommandsSize; wDrawCommandsSize += 10
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
;=@cmd
	ld [wDrawCommandsSize], a
;> return DrawTwoTileColumns(cmd, StairsTiles)
	ld de, StairsTiles
	jr DrawTwoTileColumns

;@ def CheckRoomEventTrigger(event: a)
;@ test: skip dispatches through a jump table
;@ path: world/room_events
;@ Checks the trigger in bits 0-4 of the room event (hMultiPurpose0 keeps it) and calls TriggerRoomEvent
;@ when it is met: see RoomEventTriggers.
CheckRoomEventTrigger::
;> hMultiPurpose0 = event & 0x1F
	and $1f
	ldh [hMultiPurpose0], a
;> return RoomEventTriggers[hMultiPurpose0 - 1]()
	dec a
	rst $00

;@ path: world/room_events
;@ Room event triggers, by bits 0-4 of wRoomEvent minus 1 (2-byte code addresses): 1 all enemies gone,
;@ 3 a floor switch pressed, 5 two torches lit (wRoomEventCounter), 6 three enemies beaten in order,
;@ 8 all enemies gone with extra conditions, 10 status bit 5 of a fixed room; the rest never fire.
RoomEventTriggers::
	dw TriggerOnEnemiesGone
	dw RoomEventNone
	dw TriggerOnFloorSwitch
	dw RoomEventNone
	dw TriggerOnTwoTorches
	dw TriggerOnEnemiesInOrder
	dw RoomEventNone
	dw TriggerOnEnemiesGone
	dw RoomEventNone
	dw TriggerOnRoomFlag
	dw RoomEventNone
	dw RoomEventNone
	dw RoomEventNone
	dw RoomEventNone
	dw RoomEventNone

;@ def RoomEventNone()
;@ path: world/room_events
;@ Empty room event trigger / action.
RoomEventNone::
;> return
	ret


;@ def TriggerOnRoomFlag()
;@ path: world/room_events
;@ Trigger 10: fires once status bit 5 is set for a fixed room (room $E8 of the second indoor group on
;@ map $06, else room $FF of the first indoor group).
TriggerOnRoomFlag::
;> if hMapId == 0x06:
	ldh a, [hMapId]
	cp $06
	jr nz, .other

;>     status = wRoomStatus[0x2E8]
	ld a, [wRoomStatus + $2e8]
	jr .test

.other
;> else:
;>     status = wRoomStatus[0x1FF]
	ld a, [wRoomStatus + $1ff]

.test
;> if status & 0x20:
	and $20
;>     return TriggerRoomEvent()
	jp nz, TriggerRoomEvent

	ret


;@ def TriggerOnTwoTorches()
;@ path: world/room_events
;@ Trigger 5: fires when wRoomEventCounter reaches 2.
TriggerOnTwoTorches::
;> if wRoomEventCounter == 2:
	ld a, [wRoomEventCounter]
	cp $02
;>     return TriggerRoomEvent()
	jp z, TriggerRoomEvent

	ret


;@ def TriggerOnFloorSwitch()
;@ path: world/room_events
;@ Trigger 3: fires while a floor switch is pressed.
TriggerOnFloorSwitch::
;> if wFloorSwitchPressedTimer:
	ld a, [wFloorSwitchPressedTimer]
	and a
;>     return TriggerRoomEvent()
	jp nz, TriggerRoomEvent

	ret


;@ def TriggerOnEnemiesInOrder()
;@ path: world/room_events
;@ Trigger 6: fires when the first three entries of wDefeatedEntities are 0, 1, 2 (the enemies were
;@ beaten in their order).
TriggerOnEnemiesInOrder::
;> for c in range(3):
	ld c, $00
	ld hl, wDefeatedEntities

.loop
;>     if wDefeatedEntities[c] != c:
	ld a, [hli]
	cp c
;>         return
	jr nz, .done

	inc c
	ld a, c
	cp $03
	jr nz, .loop

;> TriggerRoomEvent()
	call TriggerRoomEvent

.done
	ret


;@ def TriggerOnEnemiesGone()
;@ path: world/room_events
;@ Triggers 1 and 8: fire when no entity is left that counts as an enemy (bit 1 of wEntityOptions1 marks
;@ the ones that do not); trigger 8 also needs mem[0xD460] set and mem[0xC113] clear.
TriggerOnEnemiesGone::
;> for c in range(15, -1, -1):
	ld c, $0f
	ld b, $00

.loop
;>     if wEntityStatus[c]:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next

;>         if not (wEntityOptions1[c] & 0x02):  # an enemy is left
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $02
;>             return
	jr z, .done

.next
	dec c
	ld a, c
	cp $ff
	jr nz, .loop

;> if hMultiPurpose0 == 8:
	ldh a, [hMultiPurpose0]
	cp $08
	jr nz, .fire

;>     if not mem[0xD460]:
	ld a, [$d460]
	and a
;>         return
	jr z, .done

;>     if mem[0xC113]:
	ld a, [$c113]
	and a
;>         return
	jr nz, .done

.fire
;> return TriggerRoomEvent()
	jp TriggerRoomEvent


.done
	ret


;@ def CapAtMax(de: de, hl: hl) -> hl
;@ path: menu/inventory
;@ Lowers the count at de to the capacity at hl if it is above it, and steps hl to the next capacity.
;@ test: hl = rand(0xC000, 0xCFFE); de = rand(0xD000, 0xDFFF); mem[hl] = rand(0, 255); mem[de] = rand(0, 255)
CapAtMax::
;> if mem[de] >= mem[hl]:
	ld a, [de]
	cp [hl]
	jr c, .next

;>     mem[de] = mem[hl]
	ld a, [hl]
	ld [de], a

.next
;> return hl + 1
	inc hl
	ret


;@ def UpdateInventoryAndHud()
;@ path: menu/inventory
;@ Runs every frame from bank 0: caps magic powder, bombs and arrows at their capacities, opens or
;@ closes the inventory with Start (not while Select is held, Link is busy or the song menu is busy),
;@ slides it, runs it while it is shown, and counts the rupees and hearts in the status bar. While the
;@ inventory is moving or shown it makes its caller return as well (the rest of the frame is skipped).
;@ test: skip calls routines that the trial stands in for without their effects
UpdateInventoryAndHud::
;> hl = CapAtMax(wMagicPowderCount, wMaxMagicPowder)
	ld hl, wMaxMagicPowder
	ld de, wMagicPowderCount
	call CapAtMax
;> hl = CapAtMax(wBombCount, hl)                # wMaxBombs
	ld de, wBombCount
	call CapAtMax
;> CapAtMax(wArrowCount, hl)                    # wMaxArrows
	ld de, wArrowCount
	call CapAtMax
;> if wLinkMotionState >= 2:
	ld a, [wLinkMotionState]
	cp $02
;>     return
	ret nc

;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return UpdateHud()
	jp nz, UpdateHud

;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	jp nz, UpdateHud.done

;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>     return InventorySliding()
	jp nz, InventorySliding

;> if hJoypadHeld & 0x40:                       # Select
	ldh a, [hJoypadHeld]
	and $40
;>     return InventoryShownUpdate()
	jp nz, InventoryShownUpdate

;> if not (hJoypadPressed & 0x80):              # Start
	ldh a, [hJoypadPressed]
	and $80
;>     return InventoryShownUpdate()
	jp z, InventoryShownUpdate

;> if wWindowY != 0:                            # opening: only when Link is free
	ld a, [wWindowY]
	cp $00
	jr z, .songMenu

;>     if wLinkFrozen:
	ld a, [wLinkFrozen]
	and a
;>         return InventoryShownUpdate()
	jp nz, InventoryShownUpdate

;>     if hLinkInteractiveMotionBlocked == 2:
	ldh a, [hLinkInteractiveMotionBlocked]
	cp $02
;>         return InventoryShownUpdate()
	jp z, InventoryShownUpdate

;>     if hLinkAnimationState == 0xFF:
	ldh a, [hLinkAnimationState]
	inc a
;>         return InventoryShownUpdate()
	jp z, InventoryShownUpdate

.songMenu
;> if wSongMenuShown or wSongMenuOpenTimer or wSongMenuCloseTimer:
	ld a, [wSongMenuShown]
	ld hl, wSongMenuOpenTimer
	or [hl]
	ld hl, wSongMenuCloseTimer
	or [hl]
;>     return InventoryShownUpdate()
	jp nz, InventoryShownUpdate

ToggleInventory:
;> wInventoryAppearing = 1                      # start the slide in or out
	ld a, $01
	ld [wInventoryAppearing], a
;> wInventoryStaticDrawn = 1
	ld [wInventoryStaticDrawn], a
;> hJingle = 0x12
	ld a, $12
	ldh [hJingle], a
;> wInventorySlideSpeed = -wInventorySlideSpeed # +8 down (closing), -8 up (opening)
	ld a, [wInventorySlideSpeed]
	cpl
	inc a
	ld [wInventorySlideSpeed], a
;> if wInventorySlideSpeed & 0x80:              # opening
	and $80
	jr z, .closing

;>     hJingle = 0x11
	ld a, $11
	ldh [hJingle], a
;>     wInventoryStaticDrawn = 0
	xor a
	ld [wInventoryStaticDrawn], a
;>     wInventoryRowsToDraw = 11
	ld a, $0b
	ld [wInventoryRowsToDraw], a
;>     tiles = 7                                # the inventory tiles
	ld a, [wIsIndoor]
	and a
	ld a, $07
;>     if wIsIndoor:
	jr z, .loadTiles

;>         if hMapId < 0x08:                    # a dungeon: with the minimap
	ldh a, [hMapId]
	cp $08
	ld a, $07
	jr nc, .loadTiles

;>             LoadDungeonMinimap()
	call LoadDungeonMinimap
;>             tiles = 2
	ld a, $02

.loadTiles
;>     hNeedsUpdatingBGTiles = tiles
	ldh [hNeedsUpdatingBGTiles], a
	ret


.closing
;> else:
;>     hVolumeRight = 0x07
	ld a, $07
	ldh [hVolumeRight], a
;>     hVolumeLeft = 0x70                       # full volume again
	ld a, $70
	ldh [hVolumeLeft], a
;>     return_from_caller()
	pop af
	ret


InventorySliding:
;> if wInventoryStaticDrawn:
	ld a, [wInventoryStaticDrawn]
	and a
;>     return SlideInventory()
	jr nz, SlideInventory

;> if not wDrawCommand:                         # the draw queue is free
	ld a, [wDrawCommand]
	and a
	jr nz, .wait

;>     DrawInventoryStatic()
	call DrawInventoryStatic
;>     wInventoryStaticDrawn += 1
	ld hl, wInventoryStaticDrawn
	inc [hl]

.wait
;> return UpdateWorldBehindInventory()          # runs on into it; the caller returns too (pop af)
	pop af

;@ def UpdateWorldBehindInventory()
;@ path: menu/inventory
;@ Keeps the world going while the inventory slides: Link's motion, his item sprites, his own sprites
;@ and the entities.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
UpdateWorldBehindInventory::
;> SetLinkSpriteDY()
	call SetLinkSpriteDY
;> DrawLinkItemSprites()
	call DrawLinkItemSprites
;> DrawLinkOAM()
	call DrawLinkOAM
;> UpdateEntitiesBank2()
	call UpdateEntitiesBank2
	ret


;@ def SlideInventory()
;@ path: menu/inventory
;@ One frame of the inventory sliding: draws its next row, moves the window by wInventorySlideSpeed
;@ and stops at the top (0, shown: music quieter) or at $80 (hidden). While it is shown the inventory
;@ reads the joypad and draws its cursor; then the rupee and heart counters run (UpdateHud) when no
;@ dialog is open (or in dialog states $0C / $0D).
;@ test: skip draws the item slots through the BG command queue
SlideInventory::
;> DrawInventoryRow()
	call DrawInventoryRow
;> wWindowY += wInventorySlideSpeed
	ld a, [wInventorySlideSpeed]
	ld hl, wWindowY
	add [hl]
	ld [hl], a
;> if wWindowY in (0, 0x80):                    # the slide has ended
	cp $80
	jr z, .stop

	cp $00
	jr nz, .moving

;>     if wWindowY == 0:
;>         hVolumeRight = 0x03
	ld a, $03
	ldh [hVolumeRight], a
;>         hVolumeLeft = 0x30                   # quieter music while the inventory is shown
	ld a, $30
	ldh [hVolumeLeft], a

.stop
;>     wInventoryAppearing = 0
	xor a
	ld [wInventoryAppearing], a
	jr InventoryShownUpdate

.moving
;> else:
;>     UpdateWorldBehindInventory()
	call UpdateWorldBehindInventory

InventoryShownUpdate:
;> if wWindowY != 0x80:                         # the inventory is shown
	ld a, [wWindowY]
	cp $80
	jr z, UpdateHud

;>     if not wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
	jr nz, .abort

;>         InventoryInput()
	call InventoryInput
;>         DrawSwordPowerSparkle()
	call DrawSwordPowerSparkle

.abort
;>     pop_return_address()
	pop af

UpdateHud:
;> state = wDialogState & 0x7F
	ld a, [wDialogState]
	and $7f
;> if state == 0 or state == 0x0C or state == 0x0D:
	jr z, .counters

	cp $0c
	jr z, .counters

	cp $0d
	jr nz, .done

.counters
;>     UpdateRupeeCounter()
	call UpdateRupeeCounter
;>     UpdateHealthCounter()
	call UpdateHealthCounter

.done
	ret


;@ def DrawInventoryRow()
;@ path: menu/inventory
;@ Draws the next row of the inventory while it slides in: wInventoryRowsToDraw counts down from 11 and
;@ each frame row wInventoryRowsToDraw - 1 is drawn (DrawItemSlots), until 1 is left.
;@ test: skip draws through the BG command queue
DrawInventoryRow::
;> if wInventoryRowsToDraw != 1:
	ld a, [wInventoryRowsToDraw]
	cp $01
	jr z, .done

;>     DrawItemSlots(slot=wInventoryRowsToDraw, stop=wInventoryRowsToDraw - 1)
	ld c, a
	ld b, $00
	dec a
	ld e, a
	call DrawItemSlots
;>     wInventoryRowsToDraw -= 1
	ld a, [wInventoryRowsToDraw]
	dec a
	ld [wInventoryRowsToDraw], a

.done
	ret


;@ def UpdateRupeeCounter()
;@ path: menu/status_bar
;@ Every other frame (when the draw queue is free and wRupeeCountDelay has run out) moves rupees from
;@ the add / subtract buffers into wRupeeCount (BCD, 0-999) in steps of up to 9 with a sound, and
;@ redraws the count.
;@ test: skip draws through the BG command queue
UpdateRupeeCounter::
;> if (hFrameCounter & 0x01) or wDrawCommandsSize:
	ld hl, wDrawCommandsSize
	ldh a, [hFrameCounter]
	and $01
	or [hl]
;>     return
	ret nz

;> if wRupeeCountDelay:
	ld hl, wRupeeCountDelay
	ld a, [hl]
	and a
	jr z, .add

;>     wRupeeCountDelay -= 1
	dec [hl]
;>     return
	ret


.add
;> if wAddRupeeBuffer:                          # 16 bits, high:low
	ld hl, wAddRupeeBufferHigh
	ld a, [wAddRupeeBufferLow]
	or [hl]
	jr z, .subtract

;>     hWaveSfx = 0x05
	ld a, $05
	ldh [hWaveSfx], a
;>@s1     step = ((wAddRupeeBuffer >> 5) & 0xFF) + 1
	ld a, [wAddRupeeBufferLow]
	ld e, a
	ld a, [wAddRupeeBufferHigh]
	sla e
	rla
	sla e
;=@s1
	rla
	sla e
	rla
	inc a
;>     step = min(step, 9)
	cp $0a
	jr c, .addStep

	ld a, $09

.addStep
;>@ab     wAddRupeeBuffer -= step
	ld e, a
	ld a, [wAddRupeeBufferLow]
	sub e
	ld [wAddRupeeBufferLow], a
	ld a, [hl]
	sbc $00
;=@ab
	ld [hl], a
;>@rc     wRupeeCount += step                      # BCD
	ld a, [wRupeeCountLow]
	add e
	daa
	ld [wRupeeCountLow], a
	ld a, [wRupeeCountHigh]
	adc $00
;=@rc
	daa
	ld [wRupeeCountHigh], a
;>     if wRupeeCount >= 0x1000:
	cp $10
	jr c, .drawAdd

;>         wRupeeCount = 0x0999
	ld a, $09
	ld [wRupeeCountHigh], a
	ld a, $99
	ld [wRupeeCountLow], a
;>         wAddRupeeBuffer = 0
	xor a
	ld [wAddRupeeBufferHigh], a
	ld [wAddRupeeBufferLow], a

.drawAdd
;>     DrawRupeeCount()
	call DrawRupeeCount

.subtract
;> if wSubtractRupeeBuffer:
	ld hl, wSubtractRupeeBufferHigh
	ld a, [wSubtractRupeeBufferLow]
	or [hl]
	jr z, .done

;>     hWaveSfx = 0x05
	ld a, $05
	ldh [hWaveSfx], a
;>@s2     step = ((wSubtractRupeeBuffer >> 5) & 0xFF) + 1
	ld a, [wSubtractRupeeBufferLow]
	ld e, a
	ld a, [wSubtractRupeeBufferHigh]
	sla e
	rla
	sla e
;=@s2
	rla
	sla e
	rla
	inc a
;>     step = min(step, 9)
	cp $0a
	jr c, .subStep

	ld a, $09

.subStep
;>@sb     wSubtractRupeeBuffer -= step
	ld e, a
	ld a, [wSubtractRupeeBufferLow]
	sub e
	ld [wSubtractRupeeBufferLow], a
	ld a, [hl]
	sbc $00
;=@sb
	ld [hl], a
;>     if not wRupeeCount:
	ld a, [wRupeeCountLow]
	ld hl, wRupeeCountHigh
	or [hl]
;>         return
	jr z, .done

;>@rs     wRupeeCount -= step                      # BCD
	ld a, [wRupeeCountLow]
	sub e
	daa
	ld [wRupeeCountLow], a
	ld a, [wRupeeCountHigh]
	sbc $00
;=@rs
	daa
	ld [wRupeeCountHigh], a
;>     if wRupeeCount < 0:
	jr nc, .drawSub

;>         wRupeeCount = 0
	xor a
	ld [wRupeeCountHigh], a
	ld [wRupeeCountLow], a
;>         wSubtractRupeeBuffer = 0
	ld [wSubtractRupeeBufferHigh], a
	ld [wSubtractRupeeBufferLow], a

.drawSub
;>     DrawRupeeCount()
	call DrawRupeeCount

.done
	ret


;@ def DrawRupeeCount()
;@ path: menu/status_bar
;@ Queues the three digits of wRupeeCount (tiles $B0-$B9) at $9C2A in the status bar.
;@ test: skip draws through the BG command queue
DrawRupeeCount::
;>@cmd cmd = wDrawCommand + wDrawCommandsSize; wDrawCommandsSize += 6
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $06
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
;=@cmd
	add hl, de
;> mem[cmd:cmd + 3] = (0x9C, 0x2A, 0x02)       # 3 tiles across
	ld a, $9c
	ld [hli], a
	ld a, $2a
	ld [hli], a
	ld a, $02
	ld [hli], a
;>@d1 mem[cmd + 3] = 0xB0 + (wRupeeCountHigh & 0x0F)
	push hl
	ld a, [wRupeeCountHigh]
	and $0f
	ld e, a
	add $b0
	pop hl
;=@d1
	ld [hli], a
;>@d2 mem[cmd + 4] = 0xB0 + (wRupeeCountLow >> 4)
	push hl
	ld a, [wRupeeCountLow]
	swap a
	and $0f
	add $b0
	pop hl
;=@d2
	ld [hli], a
;> mem[cmd + 5] = 0xB0 + (wRupeeCountLow & 0x0F)
	push hl
	ld a, [wRupeeCountLow]
	and $0f
	add $b0
	pop hl
	ld [hli], a
;> mem[cmd + 6] = 0                             # end of the queue
	ld a, $00
	ld [hli], a
	ret


;@ path: menu/status_bar
;@ Health (in eighths of a heart) below which the low-health beep sounds, by wMaxHearts - 3 (3-14
;@ hearts): $05 for 3-5 hearts, $09 for 6-8, $11 for 9-11, $19 for 12-14. Read by UpdateHealthCounter.
LowHealthThresholds::
	db $05, $05, $05, $09, $09, $09, $11, $11, $11, $19, $19, $19

;@ def UpdateHealthCounter()
;@ path: menu/status_bar
;@ Sets wLowHealth (beeping every $30 frames) when health is below LowHealthThresholds; every other
;@ frame with a free draw queue moves one eighth of a heart from wAddHealthBuffer or
;@ wSubtractHealthBuffer into wHealth and redraws the hearts. At 0 health a medicine bottle, if any,
;@ refills the hearts (8, plus $80 added) and makes Link invincible for a while.
;@ test: skip jumps to its own block .medicine, named UseMedicine in the pseudo-code
UpdateHealthCounter::
;> wLowHealth = 0
	xor a
	ld [wLowHealth], a
;>@low if wHealth < LowHealthThresholds[wMaxHearts - 3]:
	ld a, [wMaxHearts]
	ld e, a
	ld d, $00
	ld hl, LowHealthThresholds - 3
	add hl, de
	ld a, [wHealth]
;=@low
	cp [hl]
	jr nc, .counters

;>     wLowHealth = 1
	ld a, $01
	ld [wLowHealth], a
;>     t = wLowHealthBeepTimer - 1
	ld a, [wLowHealthBeepTimer]
	dec a
;>     if t == -1:
	cp $ff
	jr nz, .timer

;>         t = 0x30
	ld a, $30
;>         hWaveSfx = 0x04                      # the beep
	ld hl, hWaveSfx
	ld [hl], $04

.timer
;>     wLowHealthBeepTimer = t
	ld [wLowHealthBeepTimer], a

.counters
;> if not (hFrameCounter & 0x01):
	ldh a, [hFrameCounter]
	and $01
;>     return
	jr z, .done

;> if wDrawCommandsSize:
	ld a, [wDrawCommandsSize]
	and a
;>     return
	jr nz, .done

;> if wAddHealthBuffer:
	ld a, [wAddHealthBuffer]
	and a
	jr z, .subtract

;>     wAddHealthBuffer -= 1
	dec a
	ld [wAddHealthBuffer], a
;>@full     full = min(wMaxHearts, 14) * 8
	ld a, [wMaxHearts]
	cp $0f
	jr c, .shift

	ld a, $0e

.shift
;=@full
	sla a
	sla a
	sla a
	ld e, a
;>     if wHealth == full:
	ld a, [wHealth]
	cp e
	jr nz, .fill

;>         wAddHealthBuffer = 0                 # then on to the subtract buffer below
	xor a
	ld [wAddHealthBuffer], a
	jr .subtract

.fill
;>     else:
;>         wHealth += 1
	inc a
	ld [wHealth], a
;>         if (wHealth & 7) == 6:
	and $07
	cp $06
	jr nz, .draw

;>             hWaveSfx = 0x06
	ld a, $06
	ldh [hWaveSfx], a

.draw
;>         return DrawHearts()
	jp DrawHearts


.subtract
;> if not wSubtractHealthBuffer:
	ld a, [wSubtractHealthBuffer]
	and a
;>     return
	jr z, .done

;> wSubtractHealthBuffer -= 1
	dec a
	ld [wSubtractHealthBuffer], a
;> if wHealth:
	ld a, [wHealth]
	and a
	jr z, .redraw

;>     wHealth -= 1
	dec a
	ld [wHealth], a

.redraw
;> DrawHearts()
	call DrawHearts
;> if wHealth == 0:
	ld a, [wHealth]
	and a
;>     return UseMedicine()
	jr z, .medicine

.done
;> return
	ret


.medicine
;> if not wMedicineCount:                       # a medicine bottle saves Link
	ld a, [wMedicineCount]
	and a
;>     return
	jr z, .noMedicine

;> wMedicineCount -= 1
	dec a
	ld [wMedicineCount], a
;> wHealth = 8
	ld a, $08
	ld [wHealth], a
;> wAddHealthBuffer += 0x80
	ld a, [wAddHealthBuffer]
	add $80
	ld [wAddHealthBuffer], a
;> wInvincibilityCounter = 0xA0
	ld a, $a0
	ld [wInvincibilityCounter], a
;>@cmd cmd = wDrawCommand + wDrawCommandsSize; wDrawCommandsSize += 4
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $04
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
;=@cmd
	add hl, de
;> mem[cmd:cmd + 3] = (0x9C, 0x93, 0x00)       # 1 tile: the medicine count
	ld a, $9c
	ld [hli], a
	ld a, $93
	ld [hli], a
	ld a, $00
	ld [hli], a
;> tile = 0xB0 + wMedicineCount
	ld a, [wMedicineCount]
	add $b0
;> if tile != 0xB0:
	cp $b0
	jr z, .lastBottle

;>     mem[cmd + 3] = tile
	ld [hli], a
;>     mem[cmd + 4] = 0
	xor a
	ld [hl], a
	ret


.lastBottle
;> else:                                        # no bottle left: blank the count and the icon
;>     mem[cmd + 3] = 0x7F
	ld a, $7f
	ld [hli], a
;>     mem[cmd + 4:cmd + 7] = (0x9C, 0x72, 0xC1)   # 2 tiles down, repeated
	ld a, $9c
	ld [hli], a
	ld a, $72
	ld [hli], a
	ld a, $c1
	ld [hli], a
;>     mem[cmd + 7] = 0x7F
	ld a, $7f
	ld [hli], a
;>     mem[cmd + 8] = 0
	xor a
	ld [hl], a
;>     wDrawCommandsSize += 4
	ld a, [wDrawCommandsSize]
	add $04
	ld [wDrawCommandsSize], a
	ret


.noMedicine
	ret


;@ path: menu/status_bar
;@ Draw commands that blank both rows of hearts in the status bar (21 bytes): $9C0D, 7 tiles of $7F;
;@ $9C2D, 7 tiles of $7F; 0 end. Each command is [address high, address low, $06 (7 tiles across),
;@ 7 tiles]. DrawHearts copies it into the queue and writes the hearts over the blanks.
HeartRowsBlankCommand::
	db $9c, $0d, $06, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $9c, $2d, $06, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $00

;@ def DrawHearts()
;@ path: menu/status_bar
;@ Queues the hearts of the status bar: wHealth / 8 full hearts (tile $A9), a part heart ($CE) for the
;@ rest, then empty hearts ($CD) up to wMaxHearts; 7 per row.
;@ test: skip draws through the BG command queue
DrawHearts::
;> start = wDrawCommandsSize; wDrawCommandsSize += 20
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	add $14
	ld [wDrawCommandsSize], a
;> hl = wDrawCommand + start
	ld hl, wDrawCommand
	add hl, de
;> src = HeartRowsBlankCommand
	push de
	ld bc, HeartRowsBlankCommand
	ld e, $15

.copy
;> mem[hl:hl + 21] = mem[src:src + 21]
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, .copy

;> pass                                         # 4 nops
	nop
	nop
	nop
	nop
;> hl = wDrawCommand + 3 + start               # the tiles of the first row
	pop de
	ld hl, wDrawCommand + 3
	add hl, de
;> c = 0                                        # hearts written
	ld c, $00
;> if wHealth:
	ld a, [wHealth]
	and a
	jr z, .empty

;>     hMultiPurpose0 = wHealth
	ldh [hMultiPurpose0], a

.full
;>     while True:
;>         hMultiPurpose0 -= 8
	ldh a, [hMultiPurpose0]
	sub $08
	ldh [hMultiPurpose0], a
;>         if hMultiPurpose0 < 0: break
	jr c, .part

;>         mem[hl] = 0xA9; hl += 1              # full heart
	ld a, $a9
	ld [hli], a
;>         c += 1
	inc c
;>         if c == 7:
	ld a, c
	cp $07
	jr nz, .fullNext

;>             hl += 3                          # on to the second row
	ld a, l
	add $03
	ld l, a

.fullNext
	jr .full

.part
;>     if hMultiPurpose0 + 8:
	add $08
	jr z, .empty

;>         mem[hl] = 0xCE; hl += 1              # part heart; on with c += 1 below
	ld a, $ce
	ld [hli], a
	jr .nextEmpty

.empty
;> while c != wMaxHearts:
	ld a, [wMaxHearts]
	cp c
	jr z, .done

;>     mem[hl] = 0xCD; hl += 1                  # empty heart
	ld a, $cd
	ld [hli], a

.nextEmpty
;>     c += 1
	inc c
;>     if c == 7:
	ld a, c
	cp $07
	jr nz, .loop

;>         hl += 3
	ld a, l
	add $03
	ld l, a

.loop
	jr .empty

.done
	ret


;@ path: menu/inventory
;@ Tiles of every item in its slot, 6 bytes per item id (0 none, 1 sword, 2 bombs, 3 power bracelet,
;@ 4 shield, 5 bow, ... $0D): top row 3 tiles, bottom row 3 tiles (the last two of the bottom row are
;@ replaced by a level or a count for some items, see DrawItemSlotLevel). Read by DrawItemSlots.
ItemSlotTiles::
	db $7f, $7f, $7f, $7f, $7f, $7f, $84, $7f, $7f, $85, $ba, $7f, $80, $7f, $7f, $81
	db $7f, $7f, $82, $7f, $7f, $83, $ba, $7f, $86, $7f, $7f, $87, $ba, $7f, $88, $7f
	db $7f, $89, $7f, $7f, $8a, $7f, $7f, $8b, $7f, $7f, $8c, $7f, $7f, $8d, $7f, $7f
	db $98, $7f, $7f, $99, $7f, $7f, $90, $7f, $7f, $91, $7f, $7f, $92, $7f, $7f, $93
	db $7f, $7f, $96, $7f, $7f, $97, $7f, $7f, $8e, $7f, $7f, $8f, $7f, $7f, $a4, $7f
	db $7f, $a5, $7f, $7f

;@ path: menu/inventory
;@ Background address (2 bytes, high then low) of the top left tile of each item slot: 0 B and 1 A in
;@ the status bar, 2-11 the inventory slots (two per row). Read by DrawItemSlots.
ItemSlotVRAMAddresses::
	db $9c, $01, $9c, $06, $9c, $61, $9c, $65, $9c, $c1, $9c, $c5
	db $9d, $21, $9d, $25, $9d, $81, $9d, $85, $9d, $e1, $9d, $e5

;@ def DrawItemSlotsAB()
;@ path: menu/inventory
;@ Draws the A and the B item slots of the status bar (DrawItemSlots from slot 1 down to 0).
;@ test: skip draws through the BG command queue
DrawItemSlotsAB::
;> return DrawItemSlots(slot=1, stop=-1)       # runs on into it
	ld c, $01
	ld b, $00
	ld e, $ff

;@ def DrawItemSlots(slot: c, stop: e)
;@ path: menu/inventory
;@ Queues the item slots from slot c down to (not including) stop: per slot two commands of 3 tiles
;@ (top and bottom row of the item in wItemB[slot]), the bottom row ending in the item's level or count.
;@ test: skip draws through the BG command queue
DrawItemSlots::
;> if mem[0x0004]:                              # a ROM byte that is 0: never
	ld a, [$0004]
	and a
;>     return
	ret nz

;> hMultiPurpose1 = wItemB[slot]                # the item (wItemB, wItemA, then the inventory)
	push de
	push bc
	ld hl, wItemB
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hMultiPurpose1 * 6                   # its tiles in ItemSlotTiles
	sla a
	ld e, a
	sla a
	add e
	ldh [hMultiPurpose0], a
;>@cmd cmd = wDrawCommand + wDrawCommandsSize; wDrawCommandsSize += 12
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0c
;=@cmd
	ld [wDrawCommandsSize], a
;> address = ItemSlotVRAMAddresses + slot * 2
	push hl
	sla c
	ld hl, ItemSlotVRAMAddresses
	add hl, bc
	push hl
	pop de
;>@a1 mem[cmd:cmd + 2] = mem[address:address + 2]
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
;=@a1
	ld [hli], a
;> mem[cmd + 2] = 0x02                          # 3 tiles across
	ld a, $02
	ld [hli], a
;>@t1 tiles = ItemSlotTiles + hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld c, a
	push hl
	ld hl, ItemSlotTiles
	add hl, bc
	push hl
;=@t1
	pop de
	pop hl
;>@top mem[cmd + 3:cmd + 6] = mem[tiles:tiles + 3]  # the top row
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;=@top
	ld a, [de]
	inc de
	ld [hli], a
;>@a2 address = ItemSlotVRAMAddresses + slot * 2
	pop bc
	push bc
	push hl
	sla c
	ld hl, ItemSlotVRAMAddresses
	add hl, bc
;=@a2
	push hl
	pop de
	pop hl
;> mem[cmd + 7] = (mem[address + 1] + 0x20) & 0xFF   # one tile row further down
	inc de
	inc hl
	ld a, [de]
	add $20
	ld [hl], a
;>@hi mem[cmd + 6] = mem[address] + carry
	dec de
	dec hl
	ld a, [de]
	inc de
	inc de
;=@hi
	adc $00
	ld [hli], a
;> mem[cmd + 8] = 0x02
	inc hl
	ld a, $02
	ld [hli], a
;>@t2 tiles = ItemSlotTiles + 3 + hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld c, a
	push hl
	ld hl, ItemSlotTiles + 3
	add hl, bc
	push hl
;=@t2
	pop de
	pop hl
;> mem[cmd + 9] = mem[tiles]
	ld a, [de]
	inc de
	ld [hli], a
;> DrawItemSlotLevel(cmd + 10, tiles + 1)       # the last two tiles
	call DrawItemSlotLevel
;> mem[cmd + 12] = 0                            # end of the queue
	xor a
	ld [hl], a
;> slot -= 1
	pop bc
	pop de
	dec c
;> if slot != stop:
	ld a, c
	cp e
;>     return DrawItemSlots(slot, stop)
	jp nz, DrawItemSlots

	ret


;@ def DrawItemSlotLevel(dest: hl, tiles: de) -> hl
;@ path: menu/inventory
;@ Writes the last two bottom tiles of an item slot (item hMultiPurpose1): the sword, shield and power
;@ bracelet show their level as the second tile, bombs, arrows (bow) and magic powder their count,
;@ the ocarina the number of the selected song; other items (and the toadstool) their own two tiles.
;@ test: skip its pseudo-code names local parts of the unit as functions
DrawItemSlotLevel::
;> item = hMultiPurpose1
	ldh a, [hMultiPurpose1]
;> if item == 0x09:                             # ocarina
	cp $09
;>     return show_song_number()
	jr z, .ocarina

;> if item == 0x0C:                             # magic powder
	cp $0c
;>     return show_powder_count()
	jr z, .powder

;> if item == 0x01:                             # sword
	dec a
;>     return show_level(wSwordLevel)
	jr z, .sword

;> if item == 0x02:                             # bombs
	dec a
;>     return DrawTwoDigits(wBombCount)
	jr z, .bombs

;> if item == 0x03:                             # power bracelet
	dec a
;>     return show_level(wPowerBraceletLevel)
	jr z, .bracelet

;> if item == 0x04:                             # shield
	dec a
;>     return show_level(wShieldLevel)
	jr z, .shield

;> if item == 0x05:                             # bow
	dec a
;>     return DrawTwoDigits(wArrowCount)
	jr z, .arrows

.ownTiles
;> mem[hl:hl + 2] = mem[de:de + 2]              # the item's own tiles
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;> return
	ret


.bracelet
;> level = wPowerBraceletLevel
	ld a, [wPowerBraceletLevel]
	jr .level

.shield
;> level = wShieldLevel
	ld a, [wShieldLevel]
	jr .level

.sword
;> level = wSwordLevel
	ld a, [wSwordLevel]

.level
;> mem[hl] = mem[de]                            # first tile, then the level digit
	add $b0
	ld c, a
	ld a, [de]
	inc de
	ld [hli], a
;> mem[hl + 1] = 0xB0 + level
	ld a, c
	inc de
	ld [hli], a
	ret


.powder
;> if wHasToadstool:
	ld a, [wHasToadstool]
	and a
;>     return own_tiles()                       # the toadstool's tiles
	jr nz, .ownTiles

;> return DrawTwoDigits(wMagicPowderCount)
	ld a, [wMagicPowderCount]
	jr DrawTwoDigits

.ocarina
;> if not wOcarinaSongFlags:
	ld a, [wOcarinaSongFlags]
	and a
;>     return own_tiles()
	jp z, .ownTiles

;> DrawTwoDigits((wSelectedSong + 1) << 4)
	ld a, [wSelectedSong]
	inc a
	swap a
	call DrawTwoDigits
;> mem[hl - 1] = 0x7F                           # just the song number
	dec hl
	ld [hl], $7f
	inc hl
	ret


.arrows
;> return DrawTwoDigits(wArrowCount)
	ld a, [wArrowCount]
	jr DrawTwoDigits

.bombs
;> value = wBombCount                           # on into DrawTwoDigits
	ld a, [wBombCount]

;@ def DrawTwoDigits(value: a, hl: hl) -> hl
;@ path: menu/inventory
;@ Writes the two digits of a BCD byte as tiles $B0-$B9 at hl.
;@ test: hl = rand(0xC000, 0xCFF0); a = rand(0, 255)
DrawTwoDigits::
;> low = 0xB0 + (value & 0x0F)
	push af
	and $0f
	add $b0
	ld c, a
;> mem[hl] = 0xB0 + (value >> 4)
	pop af
	swap a
	and $0f
	add $b0
	ld [hli], a
;> mem[hl + 1] = low
	ld a, c
	ld [hli], a
;> return hl + 2
	ret


;@ path: menu/inventory
;@ The fixed parts of the inventory (51 bytes), copied into the draw queue by DrawInventoryStatic.
;@ Commands [address high, address low, mode, tiles...], mode bit 7 = down, low bits = count - 1:
;@ $9C6A, $9C6C, $9C6E 4 tiles down each; $9C6F, $9CB0, $9C71, $9CB2 2 tiles down each; $9C92 2 tiles
;@ across (seashell count); $9CD3 1 tile (keys or golden leaves); 0 end.
SubscreenStaticCommands::
	db $9c, $6a, $83, $94, $95, $c0, $c1, $9c, $6c, $83, $a0, $a1, $c2, $c3, $9c, $6e
	db $83, $9a, $9b, $c4, $c5, $9c, $6f, $81, $9c, $9d, $9c, $b0, $81, $c6, $c7, $9c
	db $71, $81, $9e, $9f, $9c, $b2, $81, $ca, $cb, $9c, $92, $01, $7f, $7f, $9c, $d3
	db $00, $7f, $00

;@ path: menu/inventory
;@ Offset in the copied SubscreenStaticCommands of the two tiles of each of the 9 owned-item icons
;@ (flippers, medicine, trade item, ..., then 5 dungeon items or key items) that are blanked when the
;@ item is missing. Read by DrawInventoryStatic.
SubscreenSlotOffsets::
	db $03, $0a, $11, $22, $05, $0c, $13, $1d, $27

;@ def DrawInventoryStatic()
;@ path: menu/inventory
;@ Queues the fixed parts of the inventory: the icons of owned items (the ones missing are blanked:
;@ flippers, medicine, trade item, then the dungeon's map, compass, ... in a dungeon or the key items
;@ elsewhere), the seashell count and the small keys (dungeon) or golden leaves (1-5).
;@ test: skip draws through the BG command queue
DrawInventoryStatic::
;> src = SubscreenStaticCommands
	ld hl, wDrawCommand
	ld bc, SubscreenStaticCommands
	ld e, $33

.copy
;> mem[wDrawCommand:wDrawCommand + 51] = mem[src:src + 51]
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, .copy

;> flags = wHasFlippers
	ld de, wHasFlippers
;> for c in range(9):
	ld bc, $0000

.icon
;>     if c == 2 and wTradeSceneState:          # the trade item is away
	ld a, c
	cp $02
	jr nz, .notTrade

	ld a, [wTradeSceneState]
	and a
	ld a, c
;>         blank = True
	jr nz, .blank

.notTrade
;>     elif c == 4:
	cp $04
	jr nz, .test

;>         if wIsIndoor and hMapId < 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, .keyItems

	ldh a, [hMapId]
	cp $0a
	jr nc, .keyItems

;>             flags = wDungeonHasMap           # 4-8: the dungeon's items
	ld de, wDungeonHasMap
	jr .test

.keyItems
;>         else:
;>             flags = wKeyItemFlags            # 4-8: key items
	ld de, wKeyItemFlags

.test
;>     if mem[flags] == 0xFF or not mem[flags]:
	ld a, [de]
	cp $ff
	jr z, .blank

	and a
	jr nz, .next

.blank
;>@bl         wDrawCommand[SubscreenSlotOffsets[c]:+2] = (0x7F, 0x7F)
	push de
	ld hl, SubscreenSlotOffsets
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, wDrawCommand
;=@bl
	add hl, de
	ld a, $7f
	ld [hli], a
	ld [hli], a
;>         if c == 2:
	ld a, c
	cp $02
	jr nz, .popDe

;>@b2             wDrawCommand[SubscreenSlotOffsets[2] + 7:+2] = (0x7F, 0x7F)
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, $7f
;=@b2
	ld [hli], a
	ld [hl], a

.popDe
	pop de

.next
;>     flags += 1
	inc de
	inc c
	ld a, c
	cp $09
	jr nz, .icon

;> if wSeashells:
	ld hl, wDrawCommand
	ld de, $002c
	add hl, de
	ld a, [wSeashells]
	and a
	jr z, .keys

;>@sh     DrawTwoDigits(wSeashells, wDrawCommand + 0x2C)
	ld e, a
	swap a
	and $0f
	add $b0
	ld [hli], a
;=@sh
	ld a, e
	and $0f
	add $b0
	ld [hli], a

.keys
;> tile = wDrawCommand + 0x31
	ld hl, wDrawCommand
	ld de, $0031
	add hl, de
;> if wIsIndoor and hMapId < 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, .leaves

	ldh a, [hMapId]
	cp $0a
	jr nc, .leaves

;>     n = wDungeonSmallKeys
	ld a, [wDungeonSmallKeys]
;>     if n:
	and a
	jr z, .done

;>         mem[tile] = 0xB0 + n
	jr .digit

.leaves
;> elif 0 < wGoldenLeaves < 6:
	ld a, [wGoldenLeaves]
	and a
	jr z, .done

	cp $06
	jr nc, .done

.digit
;>     mem[tile] = 0xB0 + wGoldenLeaves
	add $b0
	ld [hl], a

.done
;> wDrawCommandsSize = 0x32
	ld a, $32
	ld [wDrawCommandsSize], a
	ret


;@ path: menu/inventory
;@ Sprite x of the sword sparkle in each of the 12 item slots (0 B, 1 A, 2-11 the inventory).
;@ Read by DrawSwordPowerSparkle.
SwordSparkleX::
	db $0f, $37, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f

;@ path: menu/inventory
;@ Sprite y (from the window's top) of the sword sparkle in each of the 12 item slots.
SwordSparkleY::
	db $0e, $0e, $26, $26
	db $3e, $3e, $56, $56, $6e, $6e, $86, $86

;@ def DrawSwordPowerSparkleAB()
;@ path: menu/inventory
;@ DrawSwordPowerSparkle for the B and A slots only, and only once the palette is fully faded in.
;@ test: skip draws OAM
DrawSwordPowerSparkleAB::
;> if wBGPalette < 0xE4:
	ld a, [wBGPalette]
	cp $e4
;>     return
	ret c

;> slots = 2
	ld d, $02
;> return DrawSwordPowerSparkle(slots)
	jr DrawSwordPowerSparkle.slots

;@ def DrawSwordPowerSparkle()
;@ path: menu/inventory
;@ While a Piece of Power is active, a sparkle sprite (tile $04) blinks on the slot that holds the sword
;@ (B, A or the inventory, positions SwordSparkleX / Y).
;@ test: skip draws OAM
DrawSwordPowerSparkle::
;> slots = 12
	ld d, $0c

.slots
;> for e in range(slots):
	ld hl, wItemB
	ld e, $00

.find
;>     if wItemB[e] == 0x01:                    # the sword
	ld a, [hli]
	cp $01
;>         break
	jr z, .found

	inc e
	ld a, e
	cp d
	jr nz, .find

;> else:
;>     return
	ret


.found
;> hMultiPurpose0 = SwordSparkleX[e]
	ld d, $00
	ld hl, SwordSparkleX
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = SwordSparkleY[e]
	ld hl, SwordSparkleY
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> if wActivePowerUp == 1 and not (hFrameCounter & 0x08):
	ld a, [wActivePowerUp]
	dec a
	jr nz, .reserve

	ldh a, [hFrameCounter]
	and $08
	jr nz, .reserve

;>     oam = wOAMBuffer + 0x30 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
;>     if wSongMenuShown:
	ld a, [wSongMenuShown]
	and a
	jr z, .sprite

;>         oam = wOAMBuffer + 0x9C
	ld hl, wOAMBuffer + $9c

.sprite
;>     mem[oam] = wWindowY + hMultiPurpose1
	ld a, [wWindowY]
	push hl
	ld hl, hMultiPurpose1
	add [hl]
	pop hl
	ld [hli], a
;>     mem[oam + 1:oam + 4] = (hMultiPurpose0, 0x04, 0x50)
	ldh a, [hMultiPurpose0]
	ld [hli], a
	ld a, $04
	ld [hli], a
	ld a, $50
	ld [hli], a

.reserve
;> ReserveOAMEntriesFar(1)
	ld a, $01
	call ReserveOAMEntriesFar
	ret


;@ path: menu/inventory
;@ Sprite x of the left half of the inventory selector frame, by inventory slot 0-9 (wInventoryCursor);
;@ the right half is $20 further. Read by InventoryInput.
SubscreenSelectorX::
	db $07, $27, $07, $27, $07, $27, $07, $27, $07, $27

;@ path: menu/inventory
;@ Sprite y of the inventory selector frame, by inventory slot 0-9.
SubscreenSelectorY::
	db $28, $28, $40, $40, $58, $58
	db $70, $70, $88, $88

;@ def InventoryInput()
;@ path: menu/inventory
;@ While the inventory is shown: in a dungeon a blinking marker (sprite 0) shows Link's room on the
;@ minimap; the cursor moves and items are swapped onto A / B (MoveInventoryCursor), the song menu
;@ animates, and the selector frame (sprites 1-2, tile $BE) blinks around the selected slot.
;@ test: skip draws OAM
InventoryInput::
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     wOAMBuffer[3] = 0
	jr z, .attr

;> elif hMapId < 0x08:                          # a dungeon: Link's room on the minimap
	ldh a, [hMapId]
	cp $08
	jp nc, Jump_002_64bb

;>     y = (wMinimapLinkCell & 0xF8) + 0x58
	ld a, [wMinimapLinkCell]
	and $f8
	add $58
	ld h, a
;>@x     x = ((wMinimapLinkCell << 3) & 0x38) + 0x57
	ld a, [wMinimapLinkCell]
	rla
	rla
	rla
	and $38
;=@x
	add $57
	ld l, a
;>@ly     if (wMinimapLayout & 0x20) and (wMinimapLinkCell & 0x38) < 0x20:
	ld a, [wMinimapLayout]
	and $20
	jr z, .layoutX

	ld a, [wMinimapLinkCell]
	and $38
;=@ly
	cp $20
	jr nc, .layoutX

;>         y -= 8
	ld a, h
	sub $08
	ld h, a

.layoutX
;>@lx     if (wMinimapLayout & 0x10) and (wMinimapLinkCell & 0x07) >= 4:
	ld a, [wMinimapLayout]
	and $10
	jr z, .marker

	ld a, [wMinimapLinkCell]
	and $07
;=@lx
	cp $04
	jr c, .marker

;>         x += 8
	ld a, l
	add $08
	ld l, a

.marker
;>     wOAMBuffer[0:3] = (y, x, 0x3F)
	ld a, h
	ld [wOAMBuffer], a
	ld a, l
	ld [wOAMBuffer + 1], a
	ld a, $3f
	ld [wOAMBuffer + 2], a
;>@at     wOAMBuffer[3] = ((hFrameCounter << 1) & 0x10)   # blinking palette
	ldh a, [hFrameCounter]
	rla
	and $10

.attr
;=@at
	ld [wOAMBuffer + 3], a

Jump_002_64bb:
;> MoveInventoryCursor()
	call MoveInventoryCursor
;> UpdateSongMenu()                               # the song menu
	call UpdateSongMenu
;> wInventoryCursorBlink += 1
	ld a, [wInventoryCursorBlink]
	inc a
	ld [wInventoryCursorBlink], a
;> if wInventoryCursorBlink & 0x10:
	and $10
;>     return                                   # the selector is hidden
	jr nz, .done

;> y = SubscreenSelectorY[wInventoryCursor]
	ld a, [wInventoryCursor]
	ld e, a
	ld d, $00
	ld hl, SubscreenSelectorY
	add hl, de
	ld a, [hl]
;> wOAMBuffer[4] = y                            # the two halves of the frame
	ld [wOAMBuffer + 4], a
;> wOAMBuffer[8] = y
	ld [wOAMBuffer + 8], a
;> wOAMBuffer[5] = SubscreenSelectorX[wInventoryCursor]
	ld hl, SubscreenSelectorX
	add hl, de
	ld a, [hl]
	ld [wOAMBuffer + 5], a
;> wOAMBuffer[9] = wOAMBuffer[5] + 0x20
	add $20
	ld [wOAMBuffer + 9], a
;> wOAMBuffer[6] = 0xBE
	ld a, $be
	ld [wOAMBuffer + 6], a
;> wOAMBuffer[10] = 0xBE
	ld [wOAMBuffer + 10], a
;> wOAMBuffer[7] = 0x30
	ld a, $30
	ld [wOAMBuffer + 7], a
;> wOAMBuffer[11] = 0x10
	ld a, $10
	ld [wOAMBuffer + 11], a

.done
	ret


;@ path: menu/inventory
;@ Cursor step for Right / Left (index = joypad bits 0-1): 0, +1, -1, 0. Read by MoveInventoryCursor.
CursorStepX::
	db $00, $01, $ff, $00

;@ path: menu/inventory
;@ Cursor step for Up / Down (index = joypad bits 2-3): 0, -2, +2, 0 (two slots per row).
CursorStepY::
	db $00, $fe, $02, $00

;@ def MoveInventoryCursor()
;@ path: menu/inventory
;@ Moves the inventory cursor (wInventoryCursor 0-9, wrapping) with the D-pad, opens the song menu
;@ when it lands on the ocarina (and closes it when it leaves), and swaps the selected item onto A or
;@ B with those buttons; Start while the song menu is shown closes it and then the inventory.
;@ test: skip draws through the BG command queue
MoveInventoryCursor::
;> wInventoryCursorPrev = wInventoryCursor
	ld a, [wInventoryCursor]
	ld [wInventoryCursorPrev], a
;> if not (wSongMenuOpenTimer or wSongMenuCloseTimer):
	ld a, [wSongMenuOpenTimer]
	ld hl, wSongMenuCloseTimer
	or [hl]
	jr nz, .afterMove

;>     if not wSongMenuShown:
	ld a, [wSongMenuShown]
	and a
	jr nz, .vertical

;>@sx         wInventoryCursor += CursorStepX[hJoypadPressed & 0x03]
	ldh a, [hJoypadPressed]
	and $03
	ld e, a
	ld d, $00
	ld hl, CursorStepX
	add hl, de
;=@sx
	ld a, [wInventoryCursor]
	add [hl]
	ld [wInventoryCursor], a
;>         if wInventoryCursor >= 10:
	cp $0a
	jr c, .vertical

;>@wx             wInventoryCursor = 9 if wInventoryCursor & 0x80 else 0
	rla
	ld a, $00
	jr nc, .wrapX

	ld a, $09

.wrapX
;=@wx
	ld [wInventoryCursor], a

.vertical
;>@sy     wInventoryCursor += CursorStepY[(hJoypadPressed >> 2) & 0x03]
	ldh a, [hJoypadPressed]
	srl a
	srl a
	and $03
	ld e, a
	ld d, $00
;=@sy
	ld hl, CursorStepY
	add hl, de
	ld a, [wInventoryCursor]
	add [hl]
	ld [wInventoryCursor], a
;>     if wInventoryCursor >= 10:
	cp $0a
	jr c, .afterMove

;>@wy         wInventoryCursor = 9 if wInventoryCursor & 0x80 else 0
	rla
	ld a, $00
	jr nc, .wrapY

	ld a, $09

.wrapY
;=@wy
	ld [wInventoryCursor], a

.afterMove
;> if (hJoypadHeld & 0x0F) and not wSongMenuShown:
	ldh a, [hJoypadHeld]
	and $0f
	jr z, .start

	ld a, [wSongMenuShown]
	and a
	jr nz, .start

;>     wInventoryCursorBlink = 0                # the selector shows while moving
	xor a
	ld [wInventoryCursorBlink], a

.start
;>@st if wSongMenuShown and not (wSongMenuOpenTimer or wSongMenuCloseTimer) and hJoypadPressed & 0x80:
	ld a, [wSongMenuShown]
	and a
	jr z, .moved

	ld a, [wSongMenuOpenTimer]
	ld hl, wSongMenuCloseTimer
;=@st
	or [hl]
	jr nz, .moved

	ldh a, [hJoypadPressed]
	and $80
	jr z, .moved

;>     wCloseInventoryAfterSongMenu = 1
	ld a, $01
	ld [wCloseInventoryAfterSongMenu], a
;>     close_song_menu = True
	jr .closeSongMenu

.moved
;> elif wInventoryCursor != wInventoryCursorPrev:
	ld a, [wInventoryCursor]
	ld hl, wInventoryCursorPrev
	cp [hl]
	jr z, .buttons

;>     hJingle = 0x0A
	ld hl, hJingle
	ld [hl], $0a
;>     item = wInventoryItems[wInventoryCursor]
	ld e, a
	ld d, $00
	ld hl, wInventoryItems
	add hl, de
	ld a, [hl]
;>     if item == 0x09 and wOcarinaSongFlags:   # the ocarina
	cp $09
	jr nz, .closeSongMenu

	ld a, [wOcarinaSongFlags]
	and a
	jr z, .closeSongMenu

;>         hNeedsUpdatingBGTiles = 0x08         # open the song menu
	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
;>         wSongMenuOpenTimer = 0x10
	ld a, $10
	ld [wSongMenuOpenTimer], a
;>         wSongMenuShown = 1
	ld a, $01
	jr .setShown

.closeSongMenu
;>     elif wSongMenuShown:                     # close it
	ld a, [wSongMenuShown]
	and a
	jr z, .buttons

;>         wSongMenuCloseTimer = 0x10
	ld a, $10
	ld [wSongMenuCloseTimer], a
;>@sh         wSongMenuShown = 0
	xor a

.setShown
;=@sh
	ld [wSongMenuShown], a

.buttons
;> if wSongMenuOpenTimer or wSongMenuCloseTimer:
	ld hl, wSongMenuCloseTimer
	ld a, [wSongMenuOpenTimer]
	or [hl]
;>     return Jump_002_667b()
	jp nz, Jump_002_667b

;> if hJoypadPressed & 0x10:                    # A: swap the selected item onto A
	ldh a, [hJoypadPressed]
	and $10
	jr z, .buttonB

;>     old = wItemA
	ld a, [wItemA]
	push af
;>@ia     wItemA = wInventoryItems[wInventoryCursor]
	ld hl, wInventoryItems
	ld a, [wInventoryCursor]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
;=@ia
	ld [wItemA], a
;>     wInventoryItems[wInventoryCursor] = old
	pop af
	ld [hl], a
;>     if old == 0x09 and wOcarinaSongFlags:    # the ocarina is now under the cursor
	cp $09
	jr nz, .closeA

	ld a, [wOcarinaSongFlags]
	and a
	jr z, .closeA

;>         hNeedsUpdatingBGTiles = 0x08
	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
;>         wSongMenuOpenTimer = 0x10
	ld a, $10
	ld [wSongMenuOpenTimer], a
;>         wSongMenuShown = 1
	ld a, $01
	ld [wSongMenuShown], a
	jr .drawA

.closeA
;>     elif wSongMenuShown:
	ld a, [wSongMenuShown]
	and a
	jr z, .drawA

;>         wSongMenuShown = 0
	xor a
	ld [wSongMenuShown], a
;>         wSongMenuCloseTimer = 0x10
	ld a, $10
	ld [wSongMenuCloseTimer], a

.drawA
;>     DrawItemSlots(slot=1, stop=0)            # the A slot
	ld c, $01
	ld b, $00
	ld e, $00
	call DrawItemSlots
;>     return DrawSelectedInventorySlot()
	jr DrawSelectedInventorySlot

.buttonB
;> if not (hJoypadPressed & 0x20):              # B: swap the selected item onto B
	ldh a, [hJoypadPressed]
	and $20
;>     return Jump_002_667b()
	jr z, Jump_002_667b

;> old = wItemB
	ld a, [wItemB]
	push af
;>@ib wItemB = wInventoryItems[wInventoryCursor]
	ld hl, wInventoryItems
	ld a, [wInventoryCursor]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
;=@ib
	ld [wItemB], a
;> wInventoryItems[wInventoryCursor] = old
	pop af
	ld [hl], a
;> if old == 0x09 and wOcarinaSongFlags:
	cp $09
	jr nz, .closeB

	ld a, [wOcarinaSongFlags]
	and a
	jr z, .closeB

;>     wSongMenuOpenTimer = 0x10
	ld a, $10
	ld [wSongMenuOpenTimer], a
;>     hNeedsUpdatingBGTiles = 0x08
	ld a, $08
	ldh [hNeedsUpdatingBGTiles], a
;>     wSongMenuShown = 1
	ld a, $01
	ld [wSongMenuShown], a
	jr .drawB

.closeB
;> elif wSongMenuShown:
	ld a, [wSongMenuShown]
	and a
	jr z, .drawB

;>     wSongMenuShown = 0
	xor a
	ld [wSongMenuShown], a
;>     wSongMenuCloseTimer = 0x10
	ld a, $10
	ld [wSongMenuCloseTimer], a

.drawB
;> DrawItemSlots(slot=0, stop=-1)               # the B slot; then on into DrawSelectedInventorySlot
	ld c, $00
	ld b, $00
	ld e, $ff
	call DrawItemSlots

;@ def DrawSelectedInventorySlot()
;@ path: menu/inventory
;@ Redraws the inventory slot under the cursor (after an item swap or a song change) with a sound.
;@ test: skip draws through the BG command queue
DrawSelectedInventorySlot::
;> hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
;>@d DrawItemSlots(slot=wInventoryCursor + 2, stop=wInventoryCursor + 1)
	ld a, [wInventoryCursor]
	add $02
	ld c, a
	ld b, $00
	dec a
	ld e, a
;=@d
	call DrawItemSlots

Jump_002_667b:
;> return
	ret


;@ path: menu/song_menu
;@ Sprites of the song menu (12 sprites of 4 bytes: y offset, x offset, tile, attributes; drawn at
;@ y + $30, x + $60), for its 4 frames of 48 bytes each: frame 0 fully open, frames 1-3 smaller
;@ while it opens or closes. Tiles $22 / $24 / $26 are the icons of songs 1-3 (blank $20 while the
;@ song is not learned). Read by UpdateSongMenu.
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
;@ path: menu/song_menu
;@ Sprite x of the song selector (left half) for songs 1-3 (wSelectedSong 0-2). Read by UpdateSongMenu.
SongMenuNoteX::
	db $50, $60, $70

;@ path: menu/song_menu
;@ Bit of wOcarinaSongFlags for songs 1-3 (wSelectedSong 0-2). Read by UpdateSongMenu.
SongMenuSongBits::
	db $04, $02, $01

;@ def UpdateSongMenu()
;@ path: menu/song_menu
;@ The song menu over the ocarina slot: plays its opening / closing animation (the close may then close
;@ the inventory), draws its sprites, and while fully open picks the song with Right / Select and Left
;@ (skipping songs not learned) and draws the selector (sprites 4-5, tile $28).
;@ test: skip draws OAM
UpdateSongMenu::
;> if wSongMenuCloseTimer:
	ld a, [wSongMenuCloseTimer]
	and a
	jr z, .opening

;>     wSongMenuCloseTimer -= 1
	dec a
	ld [wSongMenuCloseTimer], a
;>     if not wSongMenuCloseTimer:              # closed
	jr nz, .closing

;>         hNeedsUpdatingBGTiles = 0x0B
	ld hl, hNeedsUpdatingBGTiles
	ld [hl], $0b
;>         if wCloseInventoryAfterSongMenu:
	ld a, [wCloseInventoryAfterSongMenu]
	and a
	jr z, .done

;>             wCloseInventoryAfterSongMenu = 0
	xor a
	ld [wCloseInventoryAfterSongMenu], a
;>             return ToggleInventory()
	jp ToggleInventory


.done
;>         return
	ret


.closing
;>     t = ~wSongMenuCloseTimer & 0xFF          # frames 0 -> 3
	cpl
	jr .frameFromTimer

.opening
;> elif wSongMenuOpenTimer:
	ld a, [wSongMenuOpenTimer]
	and a
	jr z, .open

;>     wSongMenuOpenTimer -= 1
	dec a
	ld [wSongMenuOpenTimer], a
;>     t = wSongMenuOpenTimer                   # frames 3 -> 0

.frameFromTimer
;>     frame = (t >> 2) & 0x03
	rra
	rra
	and $03
	jr .setFrame

.open
;> elif not wSongMenuShown:
	ld a, [wSongMenuShown]
	and a
;>     return
	jp z, Jump_002_684a

;> else:
;>     frame = 0
	ld a, $00

.setFrame
;> wSongMenuFrame = frame
	ld [wSongMenuFrame], a
;>@src src = SongMenuSprites + wSongMenuFrame * 48
	ld a, [wSongMenuFrame]
	ld d, $00
	sla a
	sla a
	sla a
	sla a
;=@src
	ld e, a
	sla a
	add e
	ld e, a
	ld hl, SongMenuSprites
	add hl, de
;> oam = wOAMBuffer + 0x18                      # sprites 6-17
	ld de, wOAMBuffer + $18
;> for c in range(12):
	ld c, $0c
	ld b, $04

.sprite
;>     mem[oam] = mem[src] + 0x30
	ld a, [hli]
	add $30
	ld [de], a
	inc de
;>     mem[oam + 1] = mem[src + 1] + 0x60
	ld a, [hli]
	add $60
	ld [de], a
	inc de
;>     tile = mem[src + 2]
	ld a, [hli]
;>     mem[oam + 2] = tile
	ld [de], a
	inc de
;>@b     bit = {0x22: 0x04, 0x24: 0x02, 0x26: 0x01}.get(tile, 0)   # a song icon?
	cp $22
	jr z, .song1

	cp $24
	jr z, .song2

	cp $26
	jr z, .song3

;>@b     if bit:
	jr .attr

.song1
;=@b
	ld b, $04
	jr .test

.song2
	ld b, $02
	jr .test

.song3
	ld b, $01

.test
;>         if not (wOcarinaSongFlags & bit):
	ld a, [wOcarinaSongFlags]
	and b
	jr nz, .attr

;>             mem[oam + 2] = 0x20              # not learned: blank
	dec de
	ld a, $20
	ld [de], a
	inc de

.attr
;>     mem[oam + 3] = mem[src + 3]
	ld a, [hli]
	ld [de], a
	inc de
;>     oam += 4; src += 4
	dec c
	jr nz, .sprite

;> if wSongMenuFrame != 0:
	ld a, [wSongMenuFrame]
	cp $00
;>     return
	jr nz, Jump_002_684a

;> if hJoypadPressed & 0x41:                    # Right or Select: the next learned song
	ldh a, [hJoypadPressed]
	and $41
	jr z, .left

.next
;>     while True:
;>@n         wSelectedSong = (wSelectedSong + 1) % 3
	ld hl, wSelectedSong
	ld a, [hl]
	inc a
	cp $03
	jr nz, .setNext

	xor a

.setNext
;=@n
	ld [hl], a
;>         if wOcarinaSongFlags & SongMenuSongBits[wSelectedSong]:
	ld e, a
	ld d, $00
	ld hl, SongMenuSongBits
	add hl, de
	ld a, [wOcarinaSongFlags]
	and [hl]
;>             break
	jr z, .next

.left
;> if hJoypadPressed & 0x02:                    # Left: the previous learned song
	ldh a, [hJoypadPressed]
	and $02
	jr z, .changed

.prev
;>     while True:
;>@p         wSelectedSong = wSelectedSong - 1 if wSelectedSong else 2
	ld hl, wSelectedSong
	ld a, [hl]
	dec a
	cp $80
	jr c, .setPrev

	ld a, $02

.setPrev
;=@p
	ld [hl], a
;>         if wOcarinaSongFlags & SongMenuSongBits[wSelectedSong]:
	ld e, a
	ld d, $00
	ld hl, SongMenuSongBits
	add hl, de
	ld a, [wOcarinaSongFlags]
	and [hl]
;>             break
	jr z, .prev

.changed
;> if hJoypadPressed & 0x43:
	ld a, [wSelectedSong]
	ldh a, [hJoypadPressed]
	and $43
	jr z, .selector

;>     DrawSelectedInventorySlot()              # the ocarina slot shows the new song number
	call DrawSelectedInventorySlot

.selector
;> wOAMBuffer[0x10] = 0x38                      # the selector, sprites 4-5
	ld hl, wOAMBuffer + $10
	ld a, $38
	ld [hli], a
;>@x x = SongMenuNoteX[wSelectedSong]
	push hl
	ld a, [wSelectedSong]
	ld e, a
	ld d, $00
	ld hl, SongMenuNoteX
	add hl, de
;=@x
	ld a, [hl]
	pop hl
;> wOAMBuffer[0x11:0x14] = (x, 0x28, 0x00)
	ld [hli], a
	push af
	ld a, $28
	ld [hli], a
	ld a, $00
	ld [hli], a
;>@r wOAMBuffer[0x14:0x18] = (0x38, x + 8, 0x28, 0x20)   # mirrored right half
	ld a, $38
	ld [hli], a
	pop af
	add $08
	ld [hli], a
	ld a, $28
;=@r
	ld [hli], a
	ld [hl], $20

Jump_002_684a:
	ret


;@ path: world/minimap
;@ Minimaps of the dungeons, 64 bytes (8 rows of 8 rooms) per map $00-$07: one window tile per room,
;@ $7D no room, $EF a room, $ED a room with a chest, $EE the boss room (the last two show only with
;@ the compass). Read by LoadDungeonMinimap.
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
;@ path: world/minimap
;@ Minimap of map $06 (Eagle's Tower) once bit 2 of wDungeon7Flags is set (its second layout), same
;@ format as DungeonMinimaps.
DungeonMinimapEagleTowerAlt::
	db $7d, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $7d
	db $ef, $ef, $ef, $ed, $7d, $7d, $7d, $7d, $ef, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $ed, $ef, $ef, $ed, $7d, $ef, $ed, $7d, $ef, $ef, $ef, $ef, $ef, $ee, $ef, $ef
	db $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ef, $7d
;@ path: world/minimap
;@ Minimap tile of a visited room by the low 4 bits of its room status (its open doors), as an offset:
;@ the tile is $D0 + value. Read by LoadDungeonMinimap.
MinimapRoomTypeTiles::
	db $00, $02, $03, $07, $05, $0a, $0b, $0f, $04, $08, $09, $0e, $06, $0c, $0d, $01

;@ def LoadDungeonMinimap()
;@ path: world/minimap
;@ Builds the inventory minimap of the dungeon in wMinimapTiles: rooms are hidden without the map,
;@ chest and boss rooms show only with the compass (until the chest is opened / the boss beaten),
;@ and visited rooms show their doors (MinimapRoomTypeTiles). Not in room $E8.
;@ test: skip the trial cannot run it to its end
LoadDungeonMinimap::
;> if hMapRoom == 0xE8:
	ldh a, [hMapRoom]
	cp $e8
;>     return
	ret z

;>@src src = DungeonMinimaps + hMapId * 64
	ld hl, DungeonMinimaps
	ldh a, [hMapId]
	swap a
	ld e, a
	ld d, $00
	sla e
;=@src
	rl d
	sla e
	rl d
	add hl, de
;> if hMapId == 0x06 and wDungeon7Flags & 0x04:
	ldh a, [hMapId]
	cp $06
	jr nz, .copy

	ld a, [wDungeon7Flags]
	and $04
	jr z, .copy

;>     src = DungeonMinimapEagleTowerAlt
	ld hl, DungeonMinimapEagleTowerAlt

.copy
;> CopyData(wMinimapTiles, src, 64)
	ld de, wMinimapTiles
	ld bc, $0040
	call CopyData
;> for e in range(64):
	ld d, $00
	ld e, $00

Jump_002_6ad0:
;>     tile = wMinimapTiles[e]
	ld hl, wMinimapTiles
	add hl, de
	ld a, [hl]
;>     if tile == 0x7D:                         # no room
	cp $7d
;>         continue
	jr z, .next

;>     special = tile in (0xED, 0xEE)           # chest room, boss room
	cp $ed
	jr z, .special

	cp $ee
	jr nz, .needMap

.special
;>     if special and not wDungeonHasCompass:   # (with the compass: straight to the status)
	ld a, [wDungeonHasCompass]
	and a
	jr nz, .visited

;>         wMinimapTiles[e] = 0xEF              # a plain room without the compass
	ld [hl], $ef

.needMap
;>     if not (special and wDungeonHasCompass) and not wDungeonHasMap:
	ld a, [wDungeonHasMap]
	and a
	jr nz, .visited

;>         wMinimapTiles[e] = 0x7D              # hidden
	ld [hl], $7d
;>         continue
	jp .next


.visited
;>     status = GetDungeonRoomStatusAddress(e)
	push de
	call GetDungeonRoomStatusAddress
	push de
	pop bc
	pop de
;>     if not (mem[status] & 0x80):             # not visited: keep the tile
	ld a, [hl]
	bit 7, a
;>         continue
	jr z, .next

;>@c     c = 0xD0 + MinimapRoomTypeTiles[mem[status] & 0x0F]
	ld a, [hl]
	and $0f
	ld c, a
	ld b, $00
	ld hl, MinimapRoomTypeTiles
	add hl, bc
;=@c
	ld a, [hl]
	inc a
	add $cf
	ld c, a
;>     tile = wMinimapTiles[e]
	ld hl, wMinimapTiles
	add hl, de
	ld a, [hl]
;>     if tile in (0xEE, 0xED):
	cp $ee
	jr z, .chestBoss

	cp $ed
	jr nz, .setTile

.chestBoss
;>@mask         mask = 0x10 if tile == 0xED else 0x20   # chest opened / boss beaten (status read again)
	push de
	push af
	call GetDungeonRoomStatusAddress
	pop af
	ld e, $20
	cp $ed
;=@mask
	jr nz, .test

	ld e, $10

.test
;>         if not (mem[status] & mask):
	ld a, [hl]
	and e
	pop de
	cp $00
;>             continue                         # keep the chest / boss icon
	jr z, .next

.setTile
;>     wMinimapTiles[e] = c
	ld hl, wMinimapTiles
	add hl, de
	ld [hl], c
;>     if not wDungeonHasMap:
	ld a, [wDungeonHasMap]
	and a
	jr nz, .next

;>         wMinimapTiles[e] = 0x7D
	ld [hl], $7d

.next
	inc e
	ld a, e
	cp $40
	jp nz, Jump_002_6ad0

	ret


;@ def DrawMinimapTopRight()
;@ path: world/minimap
;@ Copies the top right quarter of wMinimapTiles (rows 0-3, columns 4-7) into the window, placed by
;@ bits 4-5 of wMinimapLayout (MinimapTopRightLayouts).
;@ test: skip writes VRAM
DrawMinimapTopRight::
;> return MinimapTopRightLayouts[(wMinimapLayout & 0x30) >> 4]()
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

;@ path: world/minimap
;@ Window address of the top right minimap quarter by minimap layout 0-3 (2-byte code addresses).
MinimapTopRightLayouts::
	dw MinimapTopRightLayout0
	dw MinimapTopRightLayout1
	dw MinimapTopRightLayout2
	dw MinimapTopRightLayout3

;@ def MinimapTopRightLayout0()
;@ path: world/minimap
;@ Top right quarter at $9D2E.
MinimapTopRightLayout0::
;> return CopyMinimapBlock(0x9D2E, 0x04)
	ld hl, $9d2e
	jr MinimapTopRightLayout3.cells

;@ def MinimapTopRightLayout1()
;@ path: world/minimap
;@ Top right quarter at $9D2F (one column to the right).
MinimapTopRightLayout1::
;> return CopyMinimapBlock(0x9D2F, 0x04)
	ld hl, $9d2f
	jr MinimapTopRightLayout3.cells

;@ def MinimapTopRightLayout2()
;@ path: world/minimap
;@ Top right quarter at $9D0E (one row up).
MinimapTopRightLayout2::
;> return CopyMinimapBlock(0x9D0E, 0x04)
	ld hl, $9d0e
	jr MinimapTopRightLayout3.cells

;@ def MinimapTopRightLayout3()
;@ path: world/minimap
;@ Top right quarter at $9D0F (one row up, one column right).
MinimapTopRightLayout3::
;> vram = 0x9D0F
	ld hl, $9d0f

.cells
;> return CopyMinimapBlock(vram, 0x04)
	ld e, $04
	jr CopyMinimapBlock

;@ def DrawMinimapBottomRight()
;@ path: world/minimap
;@ Copies the bottom right quarter of wMinimapTiles (rows 4-7, columns 4-7) into the window, placed by
;@ bits 4-5 of wMinimapLayout (MinimapBottomRightLayouts).
;@ test: skip writes VRAM
DrawMinimapBottomRight::
;> return MinimapBottomRightLayouts[(wMinimapLayout & 0x30) >> 4]()
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

;@ path: world/minimap
;@ Window address of the bottom right minimap quarter by minimap layout 0-3 (2-byte code addresses).
MinimapBottomRightLayouts::
	dw MinimapBottomRightLayout0
	dw MinimapBottomRightLayout1
	dw MinimapBottomRightLayout2
	dw MinimapBottomRightLayout3

;@ def MinimapBottomRightLayout0()
;@ path: world/minimap
;@ Bottom right quarter at $9DAE.
MinimapBottomRightLayout0::
;> return CopyMinimapBlock(0x9DAE, 0x24)
	ld hl, $9dae
	jr MinimapBottomRightLayout3.cells

;@ def MinimapBottomRightLayout1()
;@ path: world/minimap
;@ Bottom right quarter at $9DAF (one column to the right).
MinimapBottomRightLayout1::
;> return CopyMinimapBlock(0x9DAF, 0x24)
	ld hl, $9daf
	jr MinimapBottomRightLayout3.cells

;@ def MinimapBottomRightLayout2()
;@ path: world/minimap
;@ Bottom right quarter at $9DAE.
MinimapBottomRightLayout2::
;> return CopyMinimapBlock(0x9DAE, 0x24)
	ld hl, $9dae
	jr MinimapBottomRightLayout3.cells

;@ def MinimapBottomRightLayout3()
;@ path: world/minimap
;@ Bottom right quarter at $9DAF (one column to the right).
MinimapBottomRightLayout3::
;> vram = 0x9DAF
	ld hl, $9daf

.cells
;> return CopyMinimapBlock(vram, 0x24)
	ld e, $24
	jr CopyMinimapBlock

;@ def DrawMinimapTopLeft()
;@ path: world/minimap
;@ Copies the top left quarter of wMinimapTiles (rows 0-3, columns 0-3) into the window, placed by
;@ bits 4-5 of wMinimapLayout (MinimapTopLeftLayouts).
;@ test: skip writes VRAM
DrawMinimapTopLeft::
;> return MinimapTopLeftLayouts[(wMinimapLayout & 0x30) >> 4]()
	ld a, [wMinimapLayout]
	and $30
	swap a
	rst $00

;@ path: world/minimap
;@ Window address of the top left minimap quarter by minimap layout 0-3 (2-byte code addresses).
MinimapTopLeftLayouts::
	dw MinimapTopLeftLayout0
	dw MinimapTopLeftLayout1
	dw MinimapTopLeftLayout2
	dw MinimapTopLeftLayout3

;@ def MinimapTopLeftLayout0()
;@ path: world/minimap
;@ Top left quarter at $9D2A.
MinimapTopLeftLayout0::
;> return CopyMinimapBlock(0x9D2A, 0x00)
	ld hl, $9d2a
	jr MinimapTopLeftLayout3.cells

;@ def MinimapTopLeftLayout1()
;@ path: world/minimap
;@ Top left quarter at $9D2A.
MinimapTopLeftLayout1::
;> return CopyMinimapBlock(0x9D2A, 0x00)
	ld hl, $9d2a
	jr MinimapTopLeftLayout3.cells

;@ def MinimapTopLeftLayout2()
;@ path: world/minimap
;@ Top left quarter at $9D0A (one row up).
MinimapTopLeftLayout2::
;> return CopyMinimapBlock(0x9D0A, 0x00)
	ld hl, $9d0a
	jr MinimapTopLeftLayout3.cells

;@ def MinimapTopLeftLayout3()
;@ path: world/minimap
;@ Top left quarter at $9D0A (one row up).
MinimapTopLeftLayout3::
;> vram = 0x9D0A
	ld hl, $9d0a

.cells
;> return CopyMinimapBlock(vram, 0x00)
	ld e, $00
	jr CopyMinimapBlock

;@ def DrawMinimapBottomLeft()
;@ path: world/minimap
;@ Copies the bottom left quarter of wMinimapTiles (rows 4-7, columns 0-3) into the window at $9DAA.
;@ test: skip writes VRAM
DrawMinimapBottomLeft::
;> return CopyMinimapBlock(0x9DAA, 0x20)
	ld hl, $9daa
	ld e, $20

;@ def CopyMinimapBlock(vram: hl, cell: e)
;@ path: world/minimap
;@ Copies a 4 x 4 block of wMinimapTiles starting at cell e into the window map at hl (rows of 4
;@ tiles, $20 bytes apart).
;@ test: skip writes VRAM
CopyMinimapBlock::
;> for c in range(16):
	ld c, $00
	ld d, c

.loop
;>     mem[vram] = wMinimapTiles[cell]
	push hl
	ld hl, wMinimapTiles
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
;>     cell += 1
	inc e
;>     if c + 1 == 16:
	inc c
	ld a, c
	cp $10
;>         return
	jr z, .done

;>     vram += 1
	inc hl
;>     if (c + 1) % 4 == 0:                     # next row of the block
	and $03
	jr nz, .loop

;>         cell += 4
	ld a, e
	add $04
	ld e, a
;>         vram += 0x1C
	ld a, l
	add $1c
	ld l, a
	ld a, $00
	adc h
	ld h, a
;>         continue
	jr .loop

.done
;> return
	ret


;@ path: link/side_view
;@ Link's x speed on a ladder in side-view rooms by joypad bits 0-1: none 0, Right +8, Left -8.
;@ Read by SideViewLadder.
LadderSpeedX::
	db $00, $08, $f8

;@ path: link/side_view
;@ Link's y speed on a ladder by joypad bits 2-3: none 0, Up -$10, Down +$10.
LadderSpeedY::
	db $00, $f0, $10

;@ path: link/side_view
;@ Link's walking x speed in side-view rooms by joypad bits 0-1: none 0, Right +$10, Left -$10.
;@ Read by SideViewWalk.
SideViewSpeedX::
	db $00, $10, $f0

;@ path: link/side_view
;@ Direction Link faces when walking in side view by joypad bits 0-1: none $FF (keep), Right 0, Left 1.
SideViewDirections::
	db $ff, $00, $01

;@ def LinkMotionSideView()
;@ path: link/side_view
;@ Link's normal motion in side-view rooms: while pushed back he only moves (with gravity unless he is
;@ in water); otherwise by hLinkMotionStep: 0 walking and jumping, 1 on a ladder, 2 in water.
LinkMotionSideView::
;> if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .pushed

;>     if hLinkInteractiveMotionBlocked in (1, 2):
	ldh a, [hLinkInteractiveMotionBlocked]
	cp $01
	jr z, .done

	cp $02
	jr z, .done

.pushed
;>         return
;> if wLinkPushedTimer:
	ld a, [wLinkPushedTimer]
	and a
	jr z, .step

;>     wLinkPushedTimer -= 1
	dec a
	ld [wLinkPushedTimer], a
;>     ApplyLinkSpeed()
	call ApplyLinkSpeed
;>     CollideLinkWithRoom()
	call CollideLinkWithRoom
;>     if hLinkMotionStep != 2:                 # not in water
	ldh a, [hLinkMotionStep]
	cp $02
	jr z, .done

;>         hLinkSpeedY += 3                     # gravity
	ldh a, [hLinkSpeedY]
	add $03
	ldh [hLinkSpeedY], a

.done
;>     return
	ret


.step
;> return SideViewMotionSteps[hLinkMotionStep]()
	ldh a, [hLinkMotionStep]
	rst $00

;@ path: link/side_view
;@ Link's side-view motion by hLinkMotionStep (2-byte code addresses): 0 SideViewWalk, 1 SideViewLadder,
;@ 2 SideViewSwim.
SideViewMotionSteps::
	dw SideViewWalk
	dw SideViewLadder
	dw SideViewSwim

;@ path: link/side_view
;@ Target x speed of Link swimming in side view, by joypad bits 0-3 (16 entries): Right +8, Left -8,
;@ diagonals +6 / -6, else 0. Read by SideViewSwim.
SideViewSwimSpeedX::
	db $00, $08, $f8, $00, $00, $06, $fa, $00, $00, $06, $fa, $00, $00, $00, $00, $00
;@ path: link/side_view
;@ Target y speed of Link swimming in side view, by joypad bits 0-3: Up -8, Down +8, diagonals -6 / +6.
SideViewSwimSpeedY::
	db $00, $00, $00, $00, $f8, $fa, $fa, $00, $08, $06, $06, $00, $00, $00, $00, $00
;@ path: link/side_view
;@ Direction of Link swimming in side view by joypad bits 0-1 (Right 0, Left 1).
SideViewSwimDirections::
	db $00, $00, $01

;@ def SideViewSwim()
;@ path: link/side_view
;@ Link in water in a side-view room. On map $07 the liquid is lava: he is thrown out and loses half a
;@ heart; without the flippers he is thrown out too. Otherwise he swims, his speed easing toward
;@ SideViewSwimSpeedX / Y every other frame, and leaves the water onto a ladder ($B1) or land.
;@ test: skip calls routines that the trial stands in for without a result
SideViewSwim::
;> if hMapId == 0x07:                           # lava
	ldh a, [hMapId]
	cp $07
	jr nz, .water

;>     LinkDrown()
	call LinkDrown
;>     wSubtractHealthBuffer += 4
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a
;>     hWaveSfx = 0x03
	ld a, $03
	ldh [hWaveSfx], a
;>     wInvincibilityCounter = 0x80
	ld a, $80
	ld [wInvincibilityCounter], a
;>     return
	ret


.water
;> if not wHasFlippers:
	ld a, [wHasFlippers]
	and a
;>     return LinkDrown()
	jp z, LinkDrown

;> hLinkDirection &= ~0x02                      # face left or right
	ld hl, hLinkDirection
	res 1, [hl]
;> wIsLinkInTheAir = ResetPegasusBoots()        # (0)
	call ResetPegasusBoots
	ld [wIsLinkInTheAir], a
;> if not (hFrameCounter & 0x01):
	ldh a, [hFrameCounter]
	and $01
	jr nz, .move

;>@dx     d = SideViewSwimSpeedX[hJoypadHeld & 0x0F] - hLinkSpeedX
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, $00
	ld hl, SideViewSwimSpeedX
	add hl, de
;=@dx
	ld a, [hl]
	ld hl, hLinkSpeedX
	sub [hl]
;>     if d:
	jr z, .speedY

;>         hLinkSpeedX += -1 if d & 0x80 else 1
	inc [hl]
	bit 7, a
	jr z, .speedY

	dec [hl]
	dec [hl]

.speedY
;>     d = SideViewSwimSpeedY[hJoypadHeld & 0x0F] - hLinkSpeedY
	ld hl, SideViewSwimSpeedY
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedY
	sub [hl]
;>     if d:
	jr z, .move

;>         hLinkSpeedY += -1 if d & 0x80 else 1
	inc [hl]
	bit 7, a
	jr z, .move

	dec [hl]
	dec [hl]

.move
;> wLinkWalkingFrameCount += 1
	ld hl, wLinkWalkingFrameCount
	inc [hl]
;> if hJoypadHeld & 0x03:
	ldh a, [hJoypadHeld]
	and $03
	jr z, .apply

;>     hLinkDirection = SideViewSwimDirections[hJoypadHeld & 0x03]
	ld e, a
	ld d, $00
	ld hl, SideViewSwimDirections
	add hl, de
	ld a, [hl]
	ldh [hLinkDirection], a

.apply
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> CollideLinkWithRoom()
	call CollideLinkWithRoom
;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>     return
	ret nz

;> if hMultiPurpose0 != 0xB0:                   # the object at Link: no longer water
	ldh a, [hMultiPurpose0]
	cp $b0
	jr z, .done

;>@st     hLinkMotionStep = 1 if hMultiPurpose0 == 0xB1 else 0   # a ladder, else walking
	cp $b1
	jr nz, .walk

	ld a, $01
	jr .setStep

.walk
	xor a

.setStep
;=@st
	ldh [hLinkMotionStep], a

.done
;> return SideViewMotionDone()
	call SideViewMotionDone
	ret


;@ def SideViewLadder()
;@ path: link/side_view
;@ Link on a ladder in a side-view room: no jump, he moves by LadderSpeedX / Y facing the ladder, and
;@ steps off it into water ($B0) or onto the ground.
;@ test: skip calls routines that the trial stands in for without a result
SideViewLadder::
;> a = ResetPegasusBoots()                      # (0)
	call ResetPegasusBoots
;> wIsLinkInTheAir = a
	ld [wIsLinkInTheAir], a
;> wJumpAnimationCounter = a
	ld [wJumpAnimationCounter], a
;> wJumpAnimationFrame = a
	ld [wJumpAnimationFrame], a
;>@sx hLinkSpeedX = LadderSpeedX[hJoypadHeld & 0x03]
	ldh a, [hJoypadHeld]
	and $03
	ld e, a
	ld d, $00
	ld hl, LadderSpeedX
	add hl, de
;=@sx
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>@sy hLinkSpeedY = LadderSpeedY[(hJoypadHeld >> 2) & 0x03]
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
	ld e, a
	ld hl, LadderSpeedY
;=@sy
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;> hLinkDirection = 2                           # up, facing the ladder
	ld a, $02
	ldh [hLinkDirection], a
;> if hJoypadHeld & 0x0F:
	ldh a, [hJoypadHeld]
	and $0f
	jr z, .apply

;>     wLinkWalkingFrameCount += 1
	ld hl, wLinkWalkingFrameCount
	inc [hl]

.apply
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> CollideLinkWithRoom()
	call CollideLinkWithRoom
;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>     return
	ret nz

;> if hMultiPurpose0 != 0xB1:                   # no longer on the ladder
	ldh a, [hMultiPurpose0]
	cp $b1
	jr z, .done

;>@st     hLinkMotionStep = 2 if hMultiPurpose0 == 0xB0 else 0   # water, else walking
	cp $b0
	jr nz, .walk

	ld a, $02
	jr .setStep

.walk
	xor a

.setStep
;=@st
	ldh [hLinkMotionStep], a

.done
;> SideViewMotionDone()
	call SideViewMotionDone
;> if wLinkCollisionFlags & 0x08:               # standing on the ground
	ld a, [wLinkCollisionFlags]
	and $08
	jr z, .end

;>     hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a

.end
	ret


;@ def SideViewWalk()
;@ path: link/side_view
;@ Link walking and jumping in a side-view room: Pegasus boots dash, steering in the air (speed easing
;@ toward SideViewSpeedX), walking on the ground, then moving, collision, climbing onto a ladder ($B1) or
;@ falling into water ($B0, with a splash), and gravity: 2 per frame up to $40, 1 while rising with the
;@ jump button (the Roc's Feather's) held. In room $F8 of map $06 pressing Up at x $46 leaves the room.
SideViewWalk::
;> if hMapId == 0x06 and hMapRoom == 0xF8:
	ldh a, [hMapId]
	cp $06
	jr nz, .boots

	ldh a, [hMapRoom]
	cp $f8
	jr nz, .boots

;>@door     if not wIsLinkInTheAir and abs(hLinkX - 0x46) < 4:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .boots

	ldh a, [hLinkX]
	sub $46
	add $04
;=@door
	cp $08
	jr nc, .boots

;>         if hJoypadPressed & 0x04:            # Up
	ldh a, [hJoypadPressed]
	and $04
;>             return StartWarpFadeOutWithNoise()
	jp nz, StartWarpFadeOutWithNoise

.boots
;> if wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .air

;>     if not (hJoypadPressed & 0x0F):          # dashing on
	ldh a, [hJoypadPressed]
	and $0f
	jr nz, .turn

;>         wLinkWalkingFrameCount += 2
	ld a, [wLinkWalkingFrameCount]
	add $02
	ld [wLinkWalkingFrameCount], a
;>         AddDashDustVfx()
	call AddDashDustVfx
;>         return SideViewApplyMotion()
	jp SideViewApplyMotion


.turn
;>     wPegasusTurnButtons = hJoypadPressed & 0x0F   # a direction pressed: the dash ends
	ld [wPegasusTurnButtons], a
;>     wPegasusDustTimer += 0x0C
	ld a, [wPegasusDustTimer]
	add $0c
	ld [wPegasusDustTimer], a
;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash

.air
;> if not wLinkOnPlatform and not (wLinkCollisionFlags & 0x08):   # in the air
	ld a, [wLinkOnPlatform]
	and a
	jr nz, .ground

	ld a, [wLinkCollisionFlags]
	and $08
	jr nz, .ground

;>     if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .inAir

;>         wIsLinkInTheAir = 1
	ld a, $01
	ld [wIsLinkInTheAir], a

.inAir
;>     wLinkWalkingFrameCount = 0x0A
	ld a, $0a
	ld [wLinkWalkingFrameCount], a
;>     if hLinkSpeedX:
	ldh a, [hLinkSpeedX]
	and a
	jr z, .steer

;>         hLinkDirection = 1 if hLinkSpeedX & 0x80 else 0
	rlca
	and $01
	ldh [hLinkDirection], a

.steer
;>     if hJoypadHeld & 0x03:
	ldh a, [hJoypadHeld]
	and $03
	jr z, .airDone

;>         d = hLinkSpeedX - SideViewSpeedX[hJoypadHeld & 0x03]
	ld e, a
	ld d, $00
	ld hl, SideViewSpeedX
	add hl, de
	ldh a, [hLinkSpeedX]
	sub [hl]
;>         if d:
	jr z, .airDone

;>             step = 1 if d & 0x80 else -1
	ld e, $01
	bit 7, a
	jr nz, .addStep

	ld e, $ff

.addStep
;>             hLinkSpeedX += step
	ldh a, [hLinkSpeedX]
	add e
	ldh [hLinkSpeedX], a

.airDone
;>     return SideViewApplyMotion()
	jr SideViewApplyMotion

.ground
;> if wIsLinkInTheAir:                          # landing
	ld a, [wIsLinkInTheAir]
	and a
	jr z, .walk

;>     hNoiseSfx = 0x07
	ld a, $07
	ldh [hNoiseSfx], a
;>     a = ResetPegasusBoots()                  # (0)
	call ResetPegasusBoots
;>     wIsLinkInTheAir = a
	ld [wIsLinkInTheAir], a
;>     wJumpAnimationFrame = a
	ld [wJumpAnimationFrame], a
;>     wJumpAnimationCounter = a
	ld [wJumpAnimationCounter], a

.walk
;>@wx hLinkSpeedX = SideViewSpeedX[hJoypadHeld & 0x03]
	ldh a, [hJoypadHeld]
	and $03
	ld e, a
	ld d, $00
	ld hl, SideViewSpeedX
	add hl, de
;=@wx
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> direction = SideViewDirections[hJoypadHeld & 0x03]
	ld hl, SideViewDirections
	add hl, de
	ld a, [hl]
;> if direction != 0xFF:
	cp $ff
	jr z, .stand

;>     if not wSwordCooldown:
	ld e, a
	ld a, [wSwordCooldown]
	and a
	jr nz, .walking

;>         hLinkDirection = direction
	ld a, e
	ldh [hLinkDirection], a

.walking
;>     wLinkWalkingFrameCount += 1
	ld hl, wLinkWalkingFrameCount
	inc [hl]
	jr SideViewApplyMotion

.stand
;> elif not wPegasusBootsChargeMeter:
	ld a, [wPegasusBootsChargeMeter]
	and a
	jr nz, SideViewApplyMotion

;>     wLinkWalkingFrameCount = 0
	xor a
	ld [wLinkWalkingFrameCount], a

SideViewApplyMotion:
;> if wSwordAnimationState or not hLinkInteractiveMotionBlocked:
	ld a, [wSwordAnimationState]
	and a
	jr nz, .move

	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jr nz, .collide

.move
;>     ApplyLinkSpeed()
	call ApplyLinkSpeed
;>     if (hJoypadHeld & 0x0F) == 0x04:
	ld hl, hLinkDirection
	ldh a, [hJoypadHeld]
	and $0f
	cp $04
	jr nz, .down

;>         hLinkDirection = 2                   # up
	ld [hl], $02

.down
;>     if (hJoypadHeld & 0x0F) == 0x08:
	cp $08
	jr nz, .collide

;>         hLinkDirection = 3                   # down
	ld [hl], $03

.collide
;> CollideLinkWithRoom()
	call CollideLinkWithRoom
;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
;>     return
	ret nz

;> ladder = hMultiPurpose0 == 0xB1              # the object at Link
	ldh a, [hMultiPurpose0]
	cp $b1
	jr z, .ladder

;> if not ladder and hMultiPurpose0 == 0xB0:    # water
	cp $b0
	jr nz, .gravity

;>     if not wLinkCollisionFlags:
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, .swim

;>         if not wInvincibilityCounter:
	ld a, [wInvincibilityCounter]
	and a
	jr nz, .sink

;>             AddSplashAtLink(2)
	ld a, $02
	call AddSplashAtLink

.sink
;>         hLinkSpeedY = 4
	ld a, $04
	ldh [hLinkSpeedY], a
;>         hLinkSpeedX = 0
	xor a
	ldh [hLinkSpeedX], a

.swim
;>     hLinkMotionStep = 2
	ld a, $02
	jr .setStep

.ladder
;> if ladder and hJoypadHeld & 0x0C:            # Up or Down: climb
	ldh a, [hJoypadHeld]
	and $0c
	jr z, .gravity

;>@ms     hLinkMotionStep = 1
	ld a, $01

.setStep
;=@ms
	ldh [hLinkMotionStep], a

.gravity
;> if not (-0x40 <= ((hLinkSpeedY ^ 0x80) - 0x80) < 0x40):
	ld hl, hLinkSpeedY
	ld a, [hl]
	sub $40
	and $80
;>     return
	jr z, SideViewMotionDone

;> hLinkSpeedY += 1
	inc [hl]
;> if hLinkSpeedY & 0x80:                       # rising
	ldh a, [hLinkSpeedY]
	and $80
	jr z, .fall

;>     button = 0x20 if wItemB == 0x0A else 0x10   # the Roc's Feather's button: B or A
	ld e, $20
	ld a, [wItemB]
	cp $0a
	jr z, .held

	ld e, $10

.held
;>     if hJoypadHeld & button:
	ldh a, [hJoypadHeld]
	and e
;>         return                               # a higher jump
	jr nz, SideViewMotionDone

.fall
;> hLinkSpeedY += 1
	inc [hl]

;@ def SideViewMotionDone()
;@ path: link/side_view
;@ Empty: the end of the side-view motion routines.
SideViewMotionDone::
;> return
	ret


;@ path: link/side_view
;@ wLinkCollisionFlags bit set when a side-view probe hits something solid, by probe 0-4: 0 right $01,
;@ 1 left $02, 2 head $04, 3 feet $08, 4 body $10. Read by SetSideViewBlocked.
SideViewBlockedBits::
	db $01, $02, $04, $08, $10

;@ path: link/side_view
;@ X offset of each side-view probe point from Link's x - 8 (probes 0-4: right, left, head, feet, body).
;@ Read by SideViewProbe.
SideViewProbeDX::
	db $0b, $05, $08, $08, $08

;@ path: link/side_view
;@ Y offset of each side-view probe point from Link's y - $10 (probes 0-4).
SideViewProbeDY::
	db $08, $08, $04, $10, $0b

;@ def SideViewCollideTiles()
;@ path: link/side_view
;@ Collision of Link with the room objects in a side-view room: notes the object at his body
;@ (hMultiPurpose0 = its physics, e.g. $B0 water, $B1 ladder), probes ahead in x and in y, lands him on
;@ solid ground or on the top of a one-way platform ($62 / $64 / $66, unless Down is held), stops him
;@ at ceilings and walls, and bounces him back when he dashes into a wall. Object $8A shows dialog
;@ $51 once.
SideViewCollideTiles::
;> SideViewProbe(4)                             # the body
	ld c, $04
	ld b, $00
	call SideViewProbe
;> hMultiPurpose0 = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hMultiPurpose0], a
;> wLinkCollisionFlags = 0
	xor a
	ld [wLinkCollisionFlags], a
;> if hLinkSpeedX:
	ld c, $00
	ldh a, [hLinkSpeedX]
	and a
	jr z, .vertical

;>     probe = 1 if hLinkSpeedX & 0x80 else 0   # left or right
	and $80
	jr z, .probeX

	inc c

.probeX
;>     SideViewProbe(probe)
	call SideViewProbe
;>     if hRoomObjectType == 0x8A and not wRoomEventJustDone:
	ldh a, [hRoomObjectType]
	cp $8a
	jr nz, .edge

	ld a, [wRoomEventJustDone]
	and a
	jr nz, .edge

;>         wRoomEventJustDone = 1
	inc a
	ld [wRoomEventJustDone], a
;>         OpenDialog(0x51)
	ld a, $51
	call OpenDialog

.edge
;>     if hRoomObjectType == 0xFF:
	ldh a, [hRoomObjectType]
	cp $ff
	jr nz, .vertical

;>         SetSideViewBlocked(probe)
	call SetSideViewBlocked

.vertical
;> probe = 2 if hLinkSpeedY & 0x80 else 3       # head or feet
	ld c, $02
	ldh a, [hLinkSpeedY]
	and a
	and $80
	jr nz, .probeY

	inc c

.probeY
;> SideViewProbe(probe)
	call SideViewProbe
;> falling = not (hLinkSpeedY & 0x80) and not (hJoypadHeld & 0x08)   # (Down drops through)
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, .solid

	ldh a, [hJoypadHeld]
	and $08
	jr nz, .solid

;> near_top = falling and (hMultiPurposeH & 0x0F) < 3
	ldh a, [hMultiPurposeH]
	and $0f
	cp $03
	jr nc, .solid

;>@pf on_platform = near_top and hRoomObjectType in (0x62, 0x64, 0x66)   # one-way platforms
	ldh a, [hRoomObjectType]
	cp $62
	jr z, .land

	cp $64
	jr z, .land

	cp $66
;=@pf
	jr z, .land

.solid
;> if on_platform or wLinkCollisionFlags & 0x08:
	ld a, [wLinkCollisionFlags]
	and $08
	jr z, .head

.land
;>     wLinkCollisionFlags |= 0x08              # standing
	ld a, [wLinkCollisionFlags]
	or $08
	ld [wLinkCollisionFlags], a
;>     hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;>     hLinkY &= 0xF0                           # on the top of the square
	ldh a, [hLinkY]
	and $f0
	add $00
	ldh [hLinkY], a

.head
;> if wLinkCollisionFlags & 0x04:               # ceiling
	ld a, [wLinkCollisionFlags]
	and $04
	jr z, .walls

;>     hLinkY = hLinkPrevY
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a

.walls
;> if wLinkCollisionFlags & 0x03:               # a wall
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, .done

;>     hLinkX = hLinkPrevX
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
;>     if wIsUsingPegasusBoots:                 # dashed into it: bounce back
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .done

;>         ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>         hLinkSpeedX = -hLinkSpeedX >> 2      # (arithmetic shift)
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
;>         hLinkSpeedY = -0x18
	ld a, $e8
	ldh [hLinkSpeedY], a
;>         ApplyLinkSpeed()
	call ApplyLinkSpeed
;>         CollideLinkWithRoom()
	call CollideLinkWithRoom
;>         wBumpShakeTimer = 0x20
	ld a, $20
	ld [wBumpShakeTimer], a
;>         wBumpShakeAxis = (hLinkDirection & 0x02) << 1
	ldh a, [hLinkDirection]
	and $02
	sla a
	ld [wBumpShakeAxis], a
;>         hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
	ret


.done
;> return
	ret


;@ def SideViewProbe(probe: c)
;@ path: link/side_view
;@ Looks at the room object under side-view probe point c (SideViewProbeDX / DY around Link): its id
;@ in hRoomObjectType, its physics in hMultiPurpose1 (the y of the point in hMultiPurposeH); solid
;@ physics ($01, $60) set the probe's bit in wLinkCollisionFlags.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
SideViewProbe::
;>@col column = ((hLinkX - 8 + SideViewProbeDX[probe]) & 0xFF) >> 4
	ld hl, SideViewProbeDX
	add hl, bc
	ldh a, [hLinkX]
	sub $08
	add [hl]
	swap a
;=@col
	and $0f
	ld e, a
;> hMultiPurposeH = (hLinkY + SideViewProbeDY[probe] - 0x10) & 0xFF
	ld hl, SideViewProbeDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	sub $10
	ldh [hMultiPurposeH], a
;> square = (hMultiPurposeH & 0xF0) | column
	and $f0
	or e
	ld e, a
	ld d, $00
;>@obj hRoomObjectType = wRoomObjects[square]      # (the address wraps within its page)
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
;=@obj
	ldh [hRoomObjectType], a
;> hMultiPurpose1 = GetObjectPhysics(hRoomObjectType, wIsIndoor)
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	ldh [hMultiPurpose1], a
;> if hMultiPurpose1 not in (0x60, 0x01):       # else on into SetSideViewBlocked
	cp $60
	jr z, SetSideViewBlocked

	cp $01
;>     return
	jr nz, SetSideViewBlocked.done

;@ def SetSideViewBlocked(probe: c)
;@ path: link/side_view
;@ Sets the wLinkCollisionFlags bit of side-view probe c (SideViewBlockedBits).
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
SetSideViewBlocked::
;> wLinkCollisionFlags |= SideViewBlockedBits[probe]
	ld hl, SideViewBlockedBits
	add hl, bc
	ld a, [wLinkCollisionFlags]
	or [hl]
	ld [wLinkCollisionFlags], a

.done
	ret


;@ def CollideLinkWithRoom()
;@ path: link/collision
;@ After Link moved: at the edges of the screen he either starts the scroll into the next room (only
;@ while the D-pad points that way, unless he dashes, swims or is in a side-view room) or is stopped;
;@ some side-view rooms instead leave the side view through their edges (warps). Then the walls are
;@ checked (CollideLinkWithWalls).
;@ test: skip its pseudo-code names local parts of the unit as functions
CollideLinkWithRoom::
;> if wDialogState or wInventoryAppearing:
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
;>     return
	ret nz

;> if hMapId == 0x1F and hIsSideScrolling:
	ldh a, [hMapId]
	cp $1f
	jr nz, .edges

	ldh a, [hIsSideScrolling]
	and a
	jr z, .edges

;>@t     if hMapRoom in (0xEB, 0xEC) and hLinkY < 0x2C:   # out through the top
	ldh a, [hMapRoom]
	cp $eb
	jr z, .top

	cp $ec
	jr nz, .edges

.top
;=@t
	ldh a, [hLinkY]
	cp $2c
;>         return StartWarpFadeOutWithNoise()
	jp c, StartWarpFadeOutWithNoise

.edges
;> if hLinkY < 0x0C:
	ld e, $02
	ldh a, [hLinkY]
	cp $0c
;>     edge = 2                                 # top
	jr c, .edgeY

;> elif hLinkY >= 0x84:
	inc e
	cp $84
;>     edge = 3                                 # bottom
	jr nc, .edgeY

;> elif hLinkX < 0x04:
	ld e, $01
	ldh a, [hLinkX]
	cp $04
;>     edge = 1                                 # left
	jr c, .edgeX

;> elif hLinkX >= 0x9C:
	dec e
	cp $9c
;>     edge = 0                                 # right
	jr nc, .edgeX

;> else:
;>     return walls()
	jp .walls


.edgeY
;> if edge in (2, 3) and not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideViewY

;>     if hMapId != 0x1F:
	ldh a, [hMapId]
	cp $1f
;>         return transition()
	jp nz, .transition

;>     if hMapRoom in (0xF5, 0xF2):
	ldh a, [hMapRoom]
	cp $f5
	jp z, StartWarpFadeOutWithNoise

	cp $f2
;>         return transition()
	jp nz, .transition

;>     return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise


.sideViewY
;> if edge in (2, 3) and hMapRoom in (0xE8, 0xF8):
	ldh a, [hMapRoom]
	cp $e8
	jp z, .transition

	cp $f8
;>     return transition()
	jp z, .transition

;> if hMapRoom == 0xFD:
	cp $fd
;>     return blockY()
	jr z, .blockY

;> if hMapRoom in (0xA3, 0xC0, 0xC1):
	cp $a3
	jp z, StartWarpFadeOutWithNoise

	cp $c0
	jp z, StartWarpFadeOutWithNoise

	cp $c1
;>     return StartWarpFadeOutWithNoise()
	jp z, StartWarpFadeOutWithNoise

;> if hMapRoom == 0xFF:
	cp $ff
	jr nz, .otherRoom

;>     if hLinkY < 0x50 and not wEntityStatus[0]:
	ldh a, [hLinkY]
	cp $50
	jr nc, .blockY

	ld a, [wEntityStatus]
	and a
;>         return transition()
	jr z, .transition

.blockY
;>     hLinkY = hLinkPrevY                      # .blockY: stopped at the edge
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a
;>     hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;>     return walls()
	jp .walls


.otherRoom
;> if hLinkMotionStep == 2:                     # swimming
	ldh a, [hLinkMotionStep]
	cp $02
;>     return transition()
	jr z, .transition

;> return StartWarpFadeOutWithNoise()           # out of the side view
	jp StartWarpFadeOutWithNoise


.edgeX
;> hLinkX = hLinkPrevX                          # left / right edge
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
;> hLinkSpeedX = 0
	xor a
	ldh [hLinkSpeedX], a
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
;>     return transition()
	jr z, .transition

;> if hMapRoom in (0xF5, 0xFD):
	ldh a, [hMapRoom]
	cp $f5
	jp z, StartWarpFadeOutMusic

	cp $fd
;>     return StartWarpFadeOutMusic()
	jp z, StartWarpFadeOutMusic

;> if hMapRoom == 0xE9:
	cp $e9
;>     return StartWarpFadeOutWithNoise()
	jp z, StartWarpFadeOutWithNoise

;>@cs if hMapRoom in (0xE8, 0xF8, 0xEF, 0xFF):    # closed sides
	cp $e8
	jp z, .walls

	cp $f8
	jp z, .walls

	cp $ef
	jp z, .walls

;=@cs
	cp $ff
;>     return walls()
	jp z, .walls

;> if hMapRoom == 0xC0:
	cp $c0
	jr nz, .roomC1

;>     return walls() if hLinkX < 0x30 else transition()
	ldh a, [hLinkX]
	cp $30
	jp c, .walls

	jr .transition

.roomC1
;> if hMapRoom == 0xC1 and hLinkX >= 0x50:
	cp $c1
	jr nz, .transition

	ldh a, [hLinkX]
	cp $50
;>     return walls()
	jp nc, .walls

.transition
;> RestoreLinkPosition()                        # .transition: scroll into the next room?
	call RestoreLinkPosition
;> if wLinkGroundType in (0x50, 0x51):
	ld a, [wLinkGroundType]
	cp $50
	jp z, .stop

	cp $51
;>     return stop()
	jp z, .stop

;> if wLinkGroundVfx == 0x07:
	ld a, [wLinkGroundVfx]
	cp $07
;>     return stop()
	jp z, .stop

;> if wLinkMotionState == 0x06:                 # falling
	ld a, [wLinkMotionState]
	cp $06
;>     return stop()
	jp z, .stop

;> if not hIsSideScrolling and wIsLinkInTheAir:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .checkPoke

	ld a, [wIsLinkInTheAir]
	and a
;>     return stop()
	jp nz, .stop

.checkPoke
;> if not wIsUsingPegasusBoots and wSwordPokeTimer:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .checkPushed

	ld a, [wSwordPokeTimer]
	and a
;>     return stop()
	jr nz, .stop

.checkPushed
;> if wLinkPushedTimer or wBumpShakeTimer:
	ld a, [wLinkPushedTimer]
	ld hl, wBumpShakeTimer
	or [hl]
;>     return stop()
	jr nz, .stop

;>@pad if hLinkY < 0x88 and not (wIsUsingPegasusBoots or hIsSideScrolling or hLinkInWater):
	ldh a, [hLinkY]
	cp $88
	jr nc, .go

	ld a, [wIsUsingPegasusBoots]
	ld hl, hIsSideScrolling
	or [hl]
;=@pad
	ld hl, hLinkInWater
	or [hl]
	jr nz, .go

;>     if not (hJoypadHeld & 0x0F):            # the D-pad must point at the edge
	ldh a, [hJoypadHeld]
	and $0f
;>         return stop()
	jr z, .stop

;>     if not (hJoypadHeld & 0x03) or (hJoypadHeld & 0x03) - 1 != edge:
	and $03
	jr z, .vertical

	dec a
	cp e
	jr z, .go

.vertical
;>         v = (hJoypadHeld >> 2) & 0x03
	ldh a, [hJoypadHeld]
	rra
	rra
	and $03
;>         if not v or v + 1 != edge:
	jr z, .stop

	dec a
	add $02
	cp e
;>             return stop()
	jr nz, .stop

.go
;>@e8 if hMapRoom == 0xE8 and hMapId != 0x1F and wIsIndoor:
	ldh a, [hMapRoom]
	cp $e8
	jr nz, .scroll

	ldh a, [hMapId]
	cp $1f
	jr z, .scroll

;=@e8
	ld a, [wIsIndoor]
	and a
	jr z, .scroll

;>     wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;>     rSCX = 0
	ldh [rSCX], a

.scroll
;> wRoomTransitionDirection = edge
	ld a, e
	ld [wRoomTransitionDirection], a
;> wRoomTransitionState = 1
	ld a, $01
	ld [wRoomTransitionState], a
;> wPegasusBootsChargeMeter = 0
	xor a
	ld [wPegasusBootsChargeMeter], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
;> wIsUsingPegasusBoots = 0
	ld [wIsUsingPegasusBoots], a
;> if hLinkY >= 0x88:                           # through the bottom: arrive in the air
	ldh a, [hLinkY]
	cp $88
	jr c, .walls

;>     wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;>     hLinkPositionZ = 8
	ld a, $08
	ldh [hLinkPositionZ], a

.walls
;> CollideLinkWithWalls()                       # .walls
	call CollideLinkWithWalls
;> return
	ret


.stop
;> wLinkPushedTimer = StopLinkSpeed()           # .stop: no transition
	call StopLinkSpeed
	ld [wLinkPushedTimer], a
;> CollideLinkWithWalls()
	call CollideLinkWithWalls

jr_002_714f:
;> return
	ret


;@ path: link/collision
;@ X offset of Link's 8 wall probe points from his x - 8: 0-1 top (left, right), 2-3 right side
;@ (upper, lower), 4-5 bottom (left, right), 6-7 left side (upper, lower). Read by ProbeWall.
WallProbeDX::
	db $06, $09, $0b, $0b, $06, $09, $04, $04

;@ path: link/collision
;@ Y offset of the 8 wall probe points from Link's y - $10 (same order as WallProbeDX).
WallProbeDY::
	db $06, $06, $09, $0c, $0f, $0f, $09, $0c
;@ path: link/collision
;@ First of the two probe points checked for each way of moving: down 4, up 0, right 2, left 6.
;@ Read by CollideLinkWithWalls.
WallProbePairs::
	db $04, $00, $02, $06

;@ path: link/collision
;@ wLinkCollisionFlags bit of each probe point when it hits a wall: bits 0-1 the two points of a vertical
;@ move (left one, right one), bits 2-3 the two of a horizontal move (upper one, lower one).
WallBlockedBits::
	db $01, $02, $04, $08, $01, $02, $04, $08

;@ path: link/collision
;@ Direction Link pushes in at each probe point (2 up, 0 right, 3 down, 1 left).
WallProbeDirections::
	db $02, $02, $00, $00
	db $03, $03, $01, $01

;@ path: link/collision
;@ Sideways nudge when only one of the two probes hits (index = the 2 collision bits): only the first
;@ point +1, only the second -1, none or both 0. It lets Link slide around corners.
WallNudge::
	db $00, $01, $ff, $00

;@ path: link/collision
;@ X speed of a jump down a ledge by direction (right $10, left -$10, up / down 0).
LedgeJumpSpeedX::
	db $10, $f0, $00, $00

;@ path: link/collision
;@ Y speed of a jump down a ledge by direction (up -$10, down $10, right / left 0).
LedgeJumpSpeedY::
	db $00, $00, $f0, $10

;@ def CollideLinkWithWalls()
;@ path: link/collision
;@ Checks the two probe points on the side Link moves to, first vertically then horizontally
;@ (ProbeWall), steps him back on that axis and nudges him around corners; walking down into deep water
;@ ($E9) outdoors with the flippers makes him jump in. In side-view rooms SideViewCollideTiles runs
;@ instead; nothing while jumping down a ledge or with the debug toggle.
CollideLinkWithWalls::
;> if wDebugToggle or wIsJumpingDownLedge:
	ld hl, wIsJumpingDownLedge
	ld a, [wDebugToggle]
	or [hl]
;>     return
	jr nz, jr_002_714f

;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .topDown

;>     SideViewCollideTiles()
	call SideViewCollideTiles
;>     return
	ret


.topDown
;> wLinkCollisionFlags = 0
	xor a
	ld [wLinkCollisionFlags], a
;> if hLinkSpeedY == 0:
	ldh a, [hLinkSpeedY]
	cp $00
;>     return WallCheckHorizontal()
	jr z, WallCheckHorizontal

;>@d hMultiPurposeC = 2 if hLinkSpeedY & 0x80 else 3        # up / down
	ld e, $03
	rla
	ld bc, WallProbePairs
	jr nc, .down

	dec e
	inc bc

.down
;=@d
	ld a, e
	ldh [hMultiPurposeC], a
;> probe = WallProbePairs[3 - hMultiPurposeC]
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

.probes
;> for i in range(2):
;>@pr     ProbeWall(probe + i)
	push de
	push bc
	call ProbeWall
	pop bc
	pop de
;=@pr
	inc bc
	dec e
	jr nz, .probes

;>@w if not (hLinkSpeedY & 0x80) and not wIsIndoor and hRoomObjectType == 0xE9 and wHasFlippers and wCarriedEntityType != 0xD5:
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, WallSlideVertical

	ld a, [wIsIndoor]
	and a
;=@w
	jr nz, WallSlideVertical

	ldh a, [hRoomObjectType]
	cp $e9
	jr nz, WallSlideVertical

	ld a, [wHasFlippers]
	and a
;=@w
	jr z, WallSlideVertical

	ld a, [wCarriedEntityType]
	cp $d5
	jr z, WallSlideVertical

;>     if wLinkMotionState == 2:                # (down into deep water)
	ld a, [wLinkMotionState]
	cp $02
;>         return WallCheckHorizontal()
	jr z, WallCheckHorizontal

;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;>     return LinkJumpIntoWater()
	jr LinkJumpIntoWater

;@ def LinkJumpIntoWaterCentered()
;@ path: link/collision
;@ The jump into deep water with its sound (LinkJumpIntoWaterColumn).
;@ test: skip runs on into LinkJumpIntoWaterColumn
LinkJumpIntoWaterCentered::
;> hJingle = 0x08                               # then on into LinkJumpIntoWaterColumn
	ld a, $08
	ldh [hJingle], a

;@ def LinkJumpIntoWaterColumn()
;@ path: link/collision
;@ Centers Link on his column and makes him jump into the water below (motion state 2, 8 pixels up).
;@ This unit also holds the rest of CollideLinkWithWalls: the corner nudges and the horizontal check.
LinkJumpIntoWaterColumn::
;> hLinkX = (hLinkX & 0xF0) + 8
	ldh a, [hLinkX]
	and $f0
	add $08
	ldh [hLinkX], a

LinkJumpIntoWater:
;> wLinkMotionState = 2                         # jumping
	ld a, $02
	ld [wLinkMotionState], a
;> hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a
;> hLinkY -= 8
	ldh a, [hLinkY]
	sub $08
	ldh [hLinkY], a
;> return ResetPegasusBoots()
	jp ResetPegasusBoots


WallSlideVertical:
;> if wLinkCollisionFlags & 0x03:               # (CollideLinkWithWalls) blocked vertically
	ld a, [wLinkCollisionFlags]
	and $03
	jr z, WallCheckHorizontal

;>@nx     hLinkX += WallNudge[wLinkCollisionFlags & 0x03]
	ld e, a
	ld d, $00
	ld hl, WallNudge
	add hl, de
	ldh a, [hLinkX]
	add [hl]
;=@nx
	ldh [hLinkX], a
;>     hLinkY = hLinkPrevY
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a

WallCheckHorizontal:
;> if hLinkSpeedX:
	ldh a, [hLinkSpeedX]
	cp $00
	jr z, WallChecksDone

;>@h     hMultiPurposeC = 1 if hLinkSpeedX & 0x80 else 0    # left / right
	ld e, $00
	rla
	ld bc, WallProbePairs + 2
	jr nc, .right

	inc e
	inc bc

.right
;=@h
	ld a, e
	ldh [hMultiPurposeC], a
;>     probe = WallProbePairs[2 + hMultiPurposeC]
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

.probes
;>     for i in range(2):
;>@pr         ProbeWall(probe + i)
	push de
	push bc
	call ProbeWall
	pop bc
	pop de
;=@pr
	inc bc
	dec e
	jr nz, .probes

;>     if wLinkCollisionFlags & 0x0C:           # blocked horizontally
	ld a, [wLinkCollisionFlags]
	and $0c
	jr z, WallChecksDone

;>@ny         hLinkY += WallNudge[(wLinkCollisionFlags & 0x0C) >> 2]
	srl a
	srl a
	ld e, a
	ld d, $00
	ld hl, WallNudge
	add hl, de
;=@ny
	ldh a, [hLinkY]
	add [hl]
	ldh [hLinkY], a
;>         hLinkX = hLinkPrevX
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a

WallChecksDone:
;> if not wLinkCollisionFlags:
	ld a, [wLinkCollisionFlags]
	and a
	jr nz, .done

;>     wSwordPokeCounter = 0
	ld [wSwordPokeCounter], a

.done
;> BounceOffWallAfterDash()
	call BounceOffWallAfterDash
	ret


;@ path: link/collision
;@ Joypad bit of each direction (right $01, left $02, up $04, down $08).
DirectionJoypadBits::
	db $01, $02, $04, $08

;@ def ProbeWall(probe: c) -> carry
;@ path: link/collision
;@ Looks at the room object under wall probe point c (WallProbeDX / DY) and acts on its physics: free
;@ floor; walls; half-solid objects (HalfSolidObjectQuadrants); keyholes that open with the right key;
;@ ledges that Link jumps down after pushing for a moment; locked doors, shutters and the boss door;
;@ stairs and room exits (warps; the following ghost or Marin may stop Link first); deep water; raised
;@ blocks. Pushing into a wall shows a hint for some objects, pokes it with the sword, breaks crystal
;@ blocks with the dash and moves push blocks. A blocked point sets its WallBlockedBits bit.
;@ Returns carry set when the point blocks Link.
;@ test: skip its pseudo-code names local parts of the unit as functions
ProbeWall::
;> hMultiPurpose4 = (hLinkX - 8 + WallProbeDX[probe]) & 0xFF   # the point
	ld hl, WallProbeDX
	add hl, bc
	ldh a, [hLinkX]
	sub $08
	add [hl]
	ldh [hMultiPurpose4], a
;> column = hMultiPurpose4 >> 4
	swap a
	and $0f
	ld e, a
;> hMultiPurpose5 = (hLinkY + WallProbeDY[probe] - 0x10) & 0xFF
	ld hl, WallProbeDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	sub $10
	ldh [hMultiPurpose5], a
;> hMultiPurposeH = (hMultiPurpose5 & 0xF0) | column   # its square
	and $f0
	or e
	ld e, a
	ldh [hMultiPurposeH], a
;>@obj hRoomObjectType = wRoomObjects[hMultiPurposeH]   # (the address wraps within its page)
	ld d, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
;=@obj
	ldh [hRoomObjectType], a
;> phys = GetObjectPhysics(hRoomObjectType, wIsIndoor)
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
;> hMultiPurposeD = phys
	ldh [hMultiPurposeD], a
;> if phys == 0x00: return free()
	and a
	jp z, .free

;> if phys == 0x01: return solid()
	cp $01
	jp z, .solid

;> if phys == 0x02: return groundVfx()
	cp $02
	jp z, .groundVfx

;> if phys == 0x03: return exit()              # stairs, room exits
	cp $03
	jp z, .exit

;> if phys == 0x10: return deepWater()
	cp $10
	jp z, .deepWater

;> if phys == 0x04: return raisedBlock()
	cp $04
	jp z, .raisedBlock

;> if phys in (0x30, 0x60): return solid()
	cp $30
	jp z, .solid

	cp $60
	jp z, .solid

;> if phys == 0x0A: return groundVfx()
	cp $0a
	jp z, .groundVfx

;> if phys in (0xFF, 0xE0) or phys >= 0xF0: return free()
	cp $ff
	jp z, .free

	cp $e0
	jp z, .free

	cp $f0
	jp nc, .free

;> if phys != 0xC0: return other()
	cp $c0
	jp nz, .other

;> if hLinkDirection != 2 or hRoomStatus & 0x10:   # a keyhole, pushed from below, still shut
	ldh a, [hLinkDirection]
	cp $02
	jp nz, .keyholeSolid

	ldh a, [hRoomStatus]
	bit 4, a
;>     return solid()
	jp nz, .keyholeSolid

;> if hMapRoom == 0x0E:
	ldh a, [hMapRoom]
	cp $0e
	jr nz, .room8C

;>     key = wKeyItemFlags[3]                   # Bird Key
	ld a, [wKeyItemFlags + 3]
;>     hint = 0x33
	ld e, $33
	jr .haveKey

.room8C
;> elif hMapRoom == 0x8C:
	cp $8c
	jr nz, .room2B

;>     key = wKeyItemFlags[2]                   # Face Key
	ld a, [wKeyItemFlags + 2]
;>     hint = 0x34
	ld e, $34

.haveKey
;> if hMapRoom in (0x0E, 0x8C):
;>     if not key:
	and a
;>         return noKey(hint)
	jr z, .noKey

;>     if hMapRoom == 0x8C:
	ldh a, [hMapRoom]
	cp $8c
	jr nz, .unlockSound

;>         ResetSoundEngine()
	call ResetSoundEngine
	jr .keyholeEntity

.unlockSound
;>     else:
;>         PlayUnlockSound()
	call PlayUnlockSound

.keyholeEntity
;>     e = SpawnEntity(0x28)
	ld a, $28
	call SpawnEntity
;>     wEntityPrivate2[e] += 1
	ld hl, wEntityPrivate2
	add hl, de
	inc [hl]
;>     return opened()
	jr .opened

.room2B
;> elif hMapRoom == 0x2B:
	cp $2b
	jr nz, .roomB5

;>     if not wKeyItemFlags[1]:                 # Angler Key
	ld a, [wKeyItemFlags + 1]
	and a
	ld e, $32
;>         return noKey(0x32)
	jr z, .noKey

;>     ResetSoundEngine()
	call ResetSoundEngine
;>     e = SpawnEntity(0x5F)
	ld a, $5f
	call SpawnEntity
;>     wEntityPrivate4[e] -= 1
	ld hl, wEntityPrivate4
	add hl, de
	dec [hl]
;>     return opened()
	jr .opened

.roomB5
;> elif hMapRoom == 0xB5:
	cp $b5
	jr nz, .tailKey

;>     if wGoldenLeaves != 6:                   # Richard's golden leaves
	ld a, [wGoldenLeaves]
	cp $06
	ld e, $31
;>         return noKey(0x31)
	jr nz, .noKey

	jr .gate

.tailKey
;> elif not wKeyItemFlags[0]:                   # Tail Key
	ld a, [wKeyItemFlags]
	and a
	ld e, $30
;>     return noKey(0x30)
	jr z, .noKey

.gate
;> hMultiPurpose1 = hLinkY                      # the opening gate at Link
	ldh a, [hLinkY]
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hLinkX
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;> slot = AddTransientVfx(9)
	ld a, $09
	call AddTransientVfx
;> mem[slot] = 0xDF
	ld [hl], $df
;> wLinkPoseLock = 0xDF
	ld a, $df
	ld [wLinkPoseLock], a
;> ResetSoundEngine()
	call ResetSoundEngine

.opened
;>@op wRoomStatus[hMapRoom] |= 0x10                # .opened: the keyhole is open for good
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
;=@op
	or $10
	ld [hl], a
;> hRoomStatus = wRoomStatus[hMapRoom]
	ldh [hRoomStatus], a

.keyholeSolid
;> return solid()
	jp .solid


.noKey
;> OpenDialogTable2AndStop(hint)                           # .noKey: a hint about the missing key
	ld a, e
	call OpenDialogTable2AndStop
;> return solid()
	jp .solid


.other
;> if hRoomObjectType == 0xDB and wLinkMotionState == 1:   # .other
	ldh a, [hRoomObjectType]
	cp $db
	jr nz, .ledge

	ld a, [wLinkMotionState]
	cp $01
;>     return solid()
	jp z, .solid

.ledge
;> if 0xD0 <= phys < 0xD4:                      # a ledge; side = phys - 0xD0 (right, left, up, down)
	ldh a, [hMultiPurposeD]
	cp $d0
	jp c, .door

	cp $d4
	jp nc, .door

;>     side = phys - 0xD0
	sub $d0
	ld e, a
;>@lr     if not wIsIndoor and side == 0 and (hMultiPurpose4 & 0x0F) < 8:
	ld a, [wIsIndoor]
	and a
	jr nz, .ledgePush

	ld a, e
	cp $00
	jr nz, .ledgeLeft

;=@lr
	ldh a, [hMultiPurpose4]
	and $0f
	cp $08
;>         return free()                     # only the right half of the square
	jp c, .free

	jr .ledgePush

.ledgeLeft
;>     if not wIsIndoor and side == 1 and (hMultiPurpose4 & 0x0F) >= 8:
	cp $01
	jr nz, .ledgePush

	ldh a, [hMultiPurpose4]
	and $0f
	cp $08
;>         return free()
	jp nc, .free

.ledgePush
;>@lp     if hLinkDirection == side and not (wLinkPushedTimer or wSpinAttackTimer or wLinkPulledByDevice):
	ld d, $00
	ldh a, [hLinkDirection]
	cp e
	jp nz, .resetPush

	ld a, [wLinkPushedTimer]
	ld hl, wSpinAttackTimer
;=@lp
	or [hl]
	ld hl, wLinkPulledByDevice
	or [hl]
	jr nz, .resetPush

;>         if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .jumpDown

;>             if not (hJoypadHeld & DirectionJoypadBits[side]):
	ld hl, DirectionJoypadBits
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
;>                 return resetPush()
	jr z, .resetPush

;>             wLinkPushCounter += 1
	ld a, [wLinkPushCounter]
	inc a
	ld [wLinkPushCounter], a
;>             if wLinkPushCounter < 0x0C:
	cp $0c
;>                 return solid()
	jp c, .solid

.jumpDown
;>         ResetPegasusBoots()                  # jump down the ledge
	call ResetPegasusBoots
;>         hLinkSpeedX = LedgeJumpSpeedX[side]
	ld hl, LedgeJumpSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>         hLinkSpeedY = LedgeJumpSpeedY[side]
	ld hl, LedgeJumpSpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;>         hLinkSpeedZ = 0x1C
	ld a, $1c
	ldh [hLinkSpeedZ], a
;>         wIsLinkInTheAir = 1
	ld a, $01
	ld [wIsLinkInTheAir], a
;>         wIsJumpingDownLedge = 1
	ld a, $01
	ld [wIsJumpingDownLedge], a
;>         hJingle = 0x08
	ld a, $08
	ldh [hJingle], a

.resetPush
;>     wLinkPushCounter = 0                     # .resetPush
	xor a
	ld [wLinkPushCounter], a
;>     return solid()
	jp .solid


.door
;> if 0x90 <= phys < 0x99:                      # a door; door = phys - 0x90
	cp $90
	jp c, .halfSolid

	cp $99
	jp nc, .solid

;>     door = phys - 0x90
	sub $90
	ld e, a
	ld d, $00
;>     if not (door & 0x02):                    # top / bottom door: Link must stand in front
	bit 1, a
	jr nz, .sideDoor

;>@dx         if ((hLinkX - wDoorX[door] - 0x0C) & 0xFF) >= 8:
	ld hl, wDoorX
	add hl, de
	ld e, [hl]
	ldh a, [hLinkX]
	sub e
	sub $0c
;=@dx
	cp $08
;>             return solid()
	jp nc, .solid

	jr .doorOpen

.sideDoor
;>@dy     elif ((hLinkY - wDoorY[door] - 0x14) & 0xFF) >= 8:
	ld hl, wDoorY
	add hl, de
	ld e, [hl]
	ldh a, [hLinkY]
	sub e
	sub $14
;=@dy
	cp $08
;>         return solid()
	jp nc, .solid

.doorOpen
;>     if wDoorAnimation:
	ld a, [wDoorAnimation]
	and a
;>         return solid()
	jp nz, .solid

;>     if phys < 0x94:                          # locked doors: use a small key
	ldh a, [hMultiPurposeD]
	cp $94
	jr nc, .notLocked

;>         if not wDungeonSmallKeys:
	ld a, [wDungeonSmallKeys]
	and a
;>             return solid()
	jp z, .solid

;>         wDungeonSmallKeys -= 1
	dec a
	ld [wDungeonSmallKeys], a
	jr .openDoor

.notLocked
;>     elif phys != 0x98:                       # shutters: only without a room event
	cp $98
	jr z, .bossDoor

;>         if wRoomEvent:
	ld a, [wRoomEvent]
	and a
	jr z, .openDoor

;>             return solid()
	jp .solid


.bossDoor
;>     elif not wDungeonHasNightmareKey:        # the boss door
	ld a, [wDungeonHasNightmareKey]
	and a
	jr nz, .openDoor

;>         OpenDialogAndStop(0x07)
	ld a, $07
	call OpenDialogAndStop
;>         return solid()
	jp .solid


.openDoor
;>     wDoorAnimIndex = phys - 0x90             # .openDoor
	ldh a, [hMultiPurposeD]
	sub $90
	ld [wDoorAnimIndex], a
;>     wDoorAnimFrame = 0
	xor a
	ld [wDoorAnimFrame], a
;>     wDoorAnimation = 1
	inc a
	ld [wDoorAnimation], a
;>     SaveDungeonItemFlags()
	call SaveDungeonItemFlags
;>     PlayUnlockSound()
	call PlayUnlockSound
;>     return solid()
	jp .solid


.halfSolid
;> if phys < 0x7C:
	cp $7c
;>     return free()
	jp c, .free

;> if phys in (0x7C, 0x7D):                     # .halfSolid: objects $7C-$8F
	push af
	jr z, .call7723

	cp $7d
	jr nz, .quadrant

.call7723
;>     CheckRevolvingDoorOrExit()
	call CheckRevolvingDoorOrExit

.quadrant
;> if phys >= 0x90:
	pop af
	cp $90
;>     return free()
	jp nc, .free

;>@q quadrants = HalfSolidObjectQuadrants + (phys - 0x7C) * 4
	sub $7c
	sla a
	sla a
	ld e, a
	ld d, $00
;=@q
	ld hl, HalfSolidObjectQuadrants
	add hl, de
;>@qr quarter = ((hMultiPurpose4 >> 3) & 0x01) | ((hMultiPurpose5 >> 2) & 0x02)
	ldh a, [hMultiPurpose4]
	rra
	rra
	rra
	and $01
	ld e, a
;=@qr
	ldh a, [hMultiPurpose5]
	rra
	rra
	and $02
	or e
	ld e, a
;> if quadrants[quarter]:
	ld d, $00
	add hl, de
	ld a, [hl]
	and a
;>     return solid()
	jp nz, .solid

;> return free()
	jp .free


.deepWater
;> if wLinkMotionState == 2 or wCarriedEntityType == 0xD5:   # .deepWater
	ld a, [wLinkMotionState]
	cp $02
	jp z, .blocked

	ld a, [wCarriedEntityType]
	cp $d5
;>     return blocked()
	jp z, .blocked

;> if (hMultiPurpose5 & 0x0F) < 8:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $08
;>     return free()
	jp c, .free

;> LinkJumpIntoWaterCentered()
	call LinkJumpIntoWaterCentered
;> return blocked()
	jp .blocked


.exit
;> if wIsCarryingLiftedObject:                  # .exit: stairs and room exits
	ld a, [wIsCarryingLiftedObject]
	and a
;>     return blocked()
	jp nz, .blocked

;> if (hMultiPurpose5 & 0x0F) >= 6:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $06
;>     return middle()
	jp nc, .middle

;>@fs follower_stops = not wIsIndoor and (wIsGhostFollowingLink == 1 or wIsMarinFollowingLink)
	ld a, [wIsIndoor]
	and a
	jr nz, .warp

	ld a, [wIsGhostFollowingLink]
	cp $01
	jr z, .followerRoom

;=@fs
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .warp

.followerRoom
;>@fr if follower_stops and hMapRoom in (0xD3, 0x24, 0xB5, 0x2B, 0xD9, 0xAC, 0x8C, 0x0E):
	ldh a, [hMapRoom]
	cp $d3
	jr z, .follower

	cp $24
	jr z, .follower

	cp $b5
;=@fr
	jr z, .follower

	cp $2b
	jr z, .follower

	cp $d9
	jr z, .follower

	cp $ac
;=@fr
	jr z, .follower

	cp $8c
	jr z, .follower

	cp $0e
	jr nz, .warp

.follower
;>     if wIsGhostFollowingLink == 1:
	ld a, [wIsGhostFollowingLink]
	cp $01
	jr nz, .marin

;>         OpenDialogTable2AndStop(0x12)
	ld a, $12
	call OpenDialogTable2AndStop
;>         return blocked()
	jp .blocked


.marin
;>     mem[0xDB47] = 0                          # Marin speaks, then the screen fades
	xor a
	ld [$db47], a
;>     mem[0xC3C9] = 0x98
	ld a, $98
	ld [$c3c9], a
;>     OpenDialogTable1(0x98)
	call OpenDialogTable1
;>     wMarinReunion = wLowHealth + 1
	ld a, [wLowHealth]
	inc a
	ld [wMarinReunion], a
;>     StartScreenFadeOut()
	call StartScreenFadeOut
;>     return blocked()
	jp .blocked


.warp
;> if wLinkPushedTimer:
	ld a, [wLinkPushedTimer]
	and a
;>     return blocked()
	jp nz, .blocked

;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return StartWarpFadeOut()
	jp nz, StartWarpFadeOut

;> return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise


.raisedBlock
;> if wLinkOnRaisedBlock:                       # .raisedBlock
	ld a, [wLinkOnRaisedBlock]
	and a
;>     return free()
	jp nz, .free

;> if not (0xDB <= hRoomObjectType < 0xDD):
	ldh a, [hRoomObjectType]
	cp $db
	jr c, .solid

	cp $dd
;>     return solid()
	jr nc, .solid

;>@rb if wRaisedBlocksState ^ RaisedBlockLoweredPhase[hRoomObjectType - 0xDB]:
	sub $db
	ld e, a
	ld d, $00
	ld hl, RaisedBlockLoweredPhase
	add hl, de
	ld a, [wRaisedBlocksState]
;=@rb
	xor [hl]
;>     return solid()                          # raised
	jr nz, .solid

;> return free()                               # lowered
	jp .free


.groundVfx
;> wLinkGroundVfx = 1                           # .groundVfx
	ld hl, wLinkGroundVfx
	ld [hl], $01
;> if phys == 0x0A:
	cp $0a
;>     return free()
	jp z, .free

.middle
;> if 6 <= (hMultiPurpose4 & 0x0F) < 0x0B:      # .middle: only the middle of the square is free
	ldh a, [hMultiPurpose4]
	and $0f
	cp $06
	jr c, .solid

	cp $0b
;>     return free()
	jp c, .free

.solid
;>@69 if hRoomObjectType == 0x69 and (hLinkDirection != hMultiPurposeC or not wIsUsingShield):   # .solid
	ldh a, [hRoomObjectType]
	cp $69
	jr nz, .pushing

	ld hl, hMultiPurposeC
	ldh a, [hLinkDirection]
	cp [hl]
;=@69
	jr nz, .call78B5

	ld a, [wIsUsingShield]
	and a
	jr nz, .pushing

.call78B5
;>     HurtLinkOnGround()
	call HurtLinkOnGround

.pushing
;>@pu if hLinkDirection == hMultiPurposeC and not (wLinkPushedTimer or wIsLinkInTheAir):   # pushing into it
	ld hl, hMultiPurposeC
	ldh a, [hLinkDirection]
	cp [hl]
	jr nz, .sword

	ld a, [wLinkPushedTimer]
	ld hl, wIsLinkInTheAir
;=@pu
	or [hl]
	jr nz, .sword

;>     hint = None
;>     if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, .outdoorHint

;>         if hRoomObjectType == 0xA9:
	ld e, $8a
	cp $a9
;>             hint = 0x8A
	jr z, .hint

;>@cr         elif hRoomObjectType in (0x4F, 0x4E, 0x88):   # crystal blocks
	ld e, $8b
	cp $4f
	jr z, .crystal

	cp $4e
	jr z, .crystal

	cp $88
;=@cr
	jr nz, .keyBlock

.crystal
;>             if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .sword

;>                 hint = 0x8B
	jr .hint

.keyBlock
;>         elif hRoomObjectType == 0xDE and not wDungeonSmallKeys:   # a key block
	cp $de
	jr nz, .outdoorHint

	ld a, [wDungeonSmallKeys]
	and a
	jr nz, .sword

;>             hint = 0x8C
	ld e, $8c
	jr .hint

.outdoorHint
;>@br     if hRoomObjectType == 0x20 and wItemA != 3 and wItemB != 3 and not (wHasInstrument2 & 0x02):
	cp $20
	jr nz, .sword

	ld a, [wItemA]
	cp $03
	jr z, .sword

;=@br
	ld a, [wItemB]
	cp $03
	jr z, .sword

	ld a, [wHasInstrument2]
	and $02
	jr nz, .sword

;>         hint = 0x8D                         # a heavy object: the power bracelet is needed
	ld e, $8d

.hint
;>     if hint and not wRoomEventJustDone:
	ld a, [wRoomEventJustDone]
	and a
	jr nz, .sword

;>         wRoomEventJustDone = 1
	inc a
	ld [wRoomEventJustDone], a
;>         OpenDialogAndStop(hint)
	ld a, e
	call OpenDialogAndStop

.sword
;> if not wIsUsingPegasusBoots and wSwordAnimationStatePrev == 5:   # the sword held out against it
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .push

	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, .push

;>     if hLinkDirection != WallProbeDirections[probe]:
	ld hl, WallProbeDirections
	add hl, bc
	ldh a, [hLinkDirection]
	cp [hl]
;>         return blocked()
	jp nz, .blocked

;>     wSwordPokeCounter += 1
	ld a, [wSwordPokeCounter]
	inc a
	ld [wSwordPokeCounter], a
;>     if wSwordPokeCounter < 0x0C:
	cp $0c
;>         return blocked()
	jp c, .blocked

;>     wSwordPokeCounter = 0                    # poke it
	xor a
	ld [wSwordPokeCounter], a
;>     wSpinAttackTimer = 0
	xor a
	ld [wSpinAttackTimer], a
;>     wSwordCharge = 0
	ld [wSwordCharge], a
;>     wSwordPokeTimer = 0x0C
	ld a, $0c
	ld [wSwordPokeTimer], a
;>     return blocked()
	jp .blocked


.push
;> if not wIsUsingShield:
	ld a, [wIsUsingShield]
	and a
	jr nz, .crystalCheck

;>     wLinkPushingTimer = 3
	ld a, $03
	ld [wLinkPushingTimer], a

.crystalCheck
;>@cc if hMapId and hRoomObjectType in (0x88, 0x4E, 0x4F):   # crystal blocks
	ldh a, [hMapId]
	and a
	ldh a, [hRoomObjectType]
	jr z, .pushBlock

	cp $88
	jr z, .breakCrystal

;=@cc
	cp $4e
	jr z, .breakCrystal

	cp $4f
	jp nz, .pushBlock

.breakCrystal
;>     if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
;>         return blocked()
	jp z, .blocked

;>     hBGPosX = hMultiPurpose4 & 0xF0          # the dash breaks it
	ldh a, [hMultiPurpose4]
	and $f0
	ldh [hBGPosX], a
;>     hBGPosY = hMultiPurpose5 & 0xF0
	ldh a, [hMultiPurpose5]
	and $f0
	ldh [hBGPosY], a
;>     RemoveRoomObject(hMultiPurposeH)
	ldh a, [hMultiPurposeH]
	ld e, a
	ld d, $00
	call RemoveRoomObject
;>     e = SpawnEntity(0x05)                    # the pieces
	ld a, $05
	call SpawnEntity
;>     if not e:                                # (carry: no free slot)
;>         return blocked()
	jr c, .blocked

;>@ex     wEntityX[e] = ((hMultiPurposeH << 4) & 0xF0) + 8
	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurposeH]
	swap a
	and $f0
	add $08
;=@ex
	ld [hl], a
;>     wEntityY[e] = (hMultiPurposeH & 0xF0) + 0x10
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurposeH]
	and $f0
	add $10
	ld [hl], a
;>     wEntitySpriteVariant[e] = 0
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], d
;>     hNoiseSfx = 0x09
	ld hl, hNoiseSfx
	ld [hl], $09
;>     wEntityTimer1[e] = 0x0F
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0f
;>     wEntityPhysicsFlags[e] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4
;>     return free()
	jr .free

.pushBlock
;> frames = 0x20                                # push blocks: how long to push
	ld e, $20
;> if hRoomObjectType == 0xC5:
	cp $c5
	jr nz, .indoorBlock

;>     if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .slow

;>         return blocked()
	jr .blocked

.indoorBlock
;>@ib elif not wIsIndoor or hRoomObjectType not in (0xDE, 0xA7):
	ld a, [wIsIndoor]
	and a
	jr z, .blocked

	ldh a, [hRoomObjectType]
	cp $de
	jr z, .count

;=@ib
	cp $a7
;>     return blocked()
	jr nz, .blocked

.slow
;> if hRoomObjectType != 0xDE:
;>     frames = 0x40
	ld e, $40

.count
;> wLinkPushCounter += 1
	ld a, [wLinkPushCounter]
	inc a
	ld [wLinkPushCounter], a
;> if wLinkPushCounter >= frames:
	cp e
	jr c, .blocked

;>     hBGTilesRequestCopy = frames
	ld a, e
	ldh [hBGTilesRequestCopy], a
;>     wLinkPushCounter = 0
	xor a
	ld [wLinkPushCounter], a
;>     OpenLockedOrPushBlock()
	call OpenLockedOrPushBlock

.blocked
;> wLinkCollisionFlags |= WallBlockedBits[probe]   # .blocked
	ld hl, WallBlockedBits
	add hl, bc
	ld a, [wLinkCollisionFlags]
	or [hl]
	ld [wLinkCollisionFlags], a
;> return True
	scf
	ret


.free
;> wLinkPushCounter = 0                         # .free
	xor a
	ld [wLinkPushCounter], a
;> return False
	scf
	ccf
	ret


;@ def CheckRevolvingDoorOrExit()
;@ path: link/collision
;@ For the half-solid objects with physics $7C / $7D: objects $B1 / $B2 start the revolving door (Link's
;@ motion state 5) when the probe point is in the upper part of the square; objects $C1, $C2, $BB, $BC
;@ are exits when the point is in its lowest 4 rows.
;@ test: skip calls routines that the trial stands in for without a result
CheckRevolvingDoorOrExit::
;> if hRoomObjectType in (0xB1, 0xB2):          # a revolving door
	ldh a, [hRoomObjectType]
	cp $b1
	jr z, .door

	cp $b2
	jr nz, .exits

.door
;>     if (hMultiPurpose5 & 0x0F) >= 6:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $06
;>         return
	jr nc, .done

;>     hJingle = 0x0C
	ld a, $0c
	ldh [hJingle], a
;>     wLinkMotionState = 5                     # LinkMotionRevolvingDoor
	ld a, $05
	ld [wLinkMotionState], a
;>     a = StopLinkSpeed()                      # (0)
	call StopLinkSpeed
;>     wInvincibilityCounter = a
	ld [wInvincibilityCounter], a
;>     wLinkMotionCounter = a
	ld [wLinkMotionCounter], a
;>     hLinkPositionZ = a
	ldh [hLinkPositionZ], a
;>     hLinkSpeedZ = a
	ldh [hLinkSpeedZ], a
;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>     return
	ret


.exits
;>@ex if hRoomObjectType in (0xC1, 0xC2, 0xBB, 0xBC):
	cp $c1
	jr z, .exit

	cp $c2
	jr z, .exit

	cp $bb
	jr z, .exit

;=@ex
	cp $bc
	jr nz, .done

.exit
;>     if (hMultiPurpose5 & 0x0F) >= 0x0C:
	ldh a, [hMultiPurpose5]
	and $0f
	cp $0c
;>         return StartWarpFadeOutWithNoise()
	jp nc, StartWarpFadeOutWithNoise

.done
	ret


;@ def BounceOffWallAfterDash()
;@ path: link/collision
;@ When Link dashes (bank 2 running) into a wall with both probe points of an axis blocked, he bounces
;@ back up into the air at a quarter of his speed, the screen shakes and SetDashBumpPoint lets the
;@ things there react.
BounceOffWallAfterDash::
;> if not wIsUsingPegasusBoots or wCurrentBank != 0x02:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .done

	ld a, [wCurrentBank]
	cp $02
;>     return
	jr nz, .done

;>@ax if (wLinkCollisionFlags & 0x03) != 0x03 and (wLinkCollisionFlags & 0x0C) != 0x0C:
	ld a, [wLinkCollisionFlags]
	and $03
	cp $03
	jr z, .bounce

;=@ax
	ld a, [wLinkCollisionFlags]
	and $0c
	cp $0c
;>     return
	jr nz, .done

.bounce
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hLinkSpeedX = -hLinkSpeedX >> 2              # (arithmetic shift)
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = -hLinkSpeedY >> 2
	ldh a, [hLinkSpeedY]
	cpl
	inc a
	sra a
	sra a
	ldh [hLinkSpeedY], a
;> hLinkSpeedZ = 0x18
	ld a, $18
	ldh [hLinkSpeedZ], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> wBumpShakeTimer = 0x20
	ld a, $20
	ld [wBumpShakeTimer], a
;> wBumpShakeAxis = (hLinkDirection & 0x02) << 1
	ldh a, [hLinkDirection]
	and $02
	sla a
	ld [wBumpShakeAxis], a
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;> SetDashBumpPoint()
	call SetDashBumpPoint

.done
	ret


;@ def OpenDialogAndStop(dialog: a)
;@ path: link/collision
;@ Opens a dialog (OpenDialog) and stops Link.
OpenDialogAndStop::
;> OpenDialog(dialog)
	call OpenDialog
;> return StopLinkSpeed()
	jp StopLinkSpeed


;@ def OpenDialogTable2AndStop(dialog: a)
;@ path: link/collision
;@ Opens a dialog of the second table (OpenDialogTable2) and stops Link.
OpenDialogTable2AndStop::
;> OpenDialogTable2(dialog)
	call OpenDialogTable2
;> return StopLinkSpeed()
	jp StopLinkSpeed


;@ path: link/collision
;@ X speed of Link entering deep water by direction (right 8, left -8, up / down 0). Read by
;@ CheckGroundUnderLink.
SwimEntrySpeedX::
	db $08, $f8, $00, $00

;@ path: link/collision
;@ Y speed of Link entering deep water by direction (up -8, down 8, right / left 0).
SwimEntrySpeedY::
	db $00, $00, $f8, $08

;@ def GetObjectUnderLink() -> a
;@ path: link/collision
;@ The room object under Link's feet (square of x and y - 4): its square in hLinkSquare and its
;@ position in hMultiPurpose0 / 1 (x, y of the square), the object in hObjectUnderLink and
;@ hRoomObjectType; returns it in a and e with d = wIsIndoor, ready for GetObjectPhysics.
;@ test: hLinkX = rand(0, 0x9F); hLinkY = rand(0x04, 0x8F); wIsIndoor = rand(0, 1)
GetObjectUnderLink::
;> hMultiPurpose0 = hLinkX & 0xF0
	ldh a, [hLinkX]
	and $f0
	ldh [hMultiPurpose0], a
;> column = hMultiPurpose0 >> 4
	swap a
	ld e, a
;> hMultiPurpose1 = (hLinkY - 4) & 0xF0
	ldh a, [hLinkY]
	sub $04
	and $f0
	ldh [hMultiPurpose1], a
;> hLinkSquare = hMultiPurpose1 | column
	or e
	ld e, a
	ldh [hLinkSquare], a
;>@o object = wRoomObjects[hLinkSquare]           # (the address wraps within its page)
	ld d, $00
	ld hl, wRoomObjects
	ld a, h
	add hl, de
	ld h, a
	ld a, [wIsIndoor]
;=@o
	ld d, a
	ld a, [hl]
;> hObjectUnderLink = object
	ldh [hObjectUnderLink], a
;> hRoomObjectType = object
	ldh [hRoomObjectType], a
;> return object                                # (also in e; d = wIsIndoor)
	ld e, a
	ret


;@ def UpdateLinkGround()
;@ path: link/collision
;@ Every frame after Link moved (from bank 0 and the motion routines): with the hookshot out only the
;@ sprite offset on the ground (SetLinkSpriteDY); in the air his shadow; on the ground the effects of
;@ what he stands on (CheckGroundUnderLink).
;@ test: skip runs on into SetLinkSpriteDY
UpdateLinkGround::
;> if wLinkMotionState == 1:                   # swimming
	ld a, [wLinkMotionState]
	cp $01
	jr nz, .hookshot

;>     wLinkSpriteDY += 4
	ld a, [wLinkSpriteDY]
	add $04
	ld [wLinkSpriteDY], a

.hookshot
;> if not wHookshotInUse:
	ld a, [wHookshotInUse]
	and a
;>     return UpdateLinkShadow()
	jr z, UpdateLinkShadow

;> if not (wIsUsingPegasusBoots or wIsLinkInTheAir):
	ld hl, wIsLinkInTheAir
	ld a, [wIsUsingPegasusBoots]
	or [hl]
	jr nz, SetLinkSpriteDY

;>     StopLinkSpeed()
	call StopLinkSpeed

;@ def SetLinkSpriteDY()
;@ path: link/collision
;@ Sets wLinkSpriteDY, how far Link's sprite sits lower or higher on the ground: +4 while swimming,
;@ -4 on a raised block, +2 in shallow water or tall grass (physics 5 / 9), -3 on physics 8.
;@ This unit also holds the rest of UpdateLinkGround (UpdateLinkShadow).
;@ test: skip depends on GetObjectPhysics, which the trial stands in for
SetLinkSpriteDY::
;> object = GetObjectUnderLink()
	call GetObjectUnderLink
;> if wSavedLinkMotionState == 1:
	ld c, $04
	ld a, [wSavedLinkMotionState]
	cp $01
;>     dy = 4
	jr z, .set

;> elif wLinkOnRaisedBlock:
	ld c, $fc
	ld a, [wLinkOnRaisedBlock]
	and a
;>     dy = -4
	jr nz, .set

;> else:
;>     phys = GetObjectPhysics(object, wIsIndoor)
	call GetObjectPhysics
;>     if phys in (0x05, 0x09):
	ld c, $02
	cp $05
	jr z, .set

	cp $09
;>         dy = 2
	jr z, .set

;>     elif phys == 0x08:                       # (other physics: return without a change)
	cp $08
	jr nz, .done

;>         dy = -3
	ld c, $fd
;>     else:
;>         return

.set
;> wLinkSpriteDY = dy
	ld a, c
	ld [wLinkSpriteDY], a

.done
	ret


UpdateLinkShadow:
;> hLinkSquarePrev = hLinkSquare                # (UpdateLinkGround without the hookshot)
	ldh a, [hLinkSquare]
	ldh [hLinkSquarePrev], a
;> if wDebugToggle:
	ld a, [wDebugToggle]
	and a
;>     return
	ret nz

;> if hLinkPositionZ:                           # in the air: his shadow, every other frame
	ldh a, [hLinkPositionZ]
	and a
	jr z, .ground

;>@sh     if not (hFrameCounter & 0x01) and hLinkY + 0x0B < 0x88:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .done

	ld hl, wOAMBuffer
	ldh a, [hLinkY]
	add $0b
;=@sh
	cp $88
	jr nc, .done

;>         wOAMBuffer[0] = hLinkY + 0x0B
	ld [hli], a
;>         wOAMBuffer[1] = hLinkX + 4
	ldh a, [hLinkX]
	add $04
	ld [hli], a
;>         wOAMBuffer[2] = 0x26
	ld a, $26
	ld [hli], a
;>         wOAMBuffer[3] = 0x00
	ld [hl], $00

.done
;>     return
	ret


.ground
;> wIsSpinningInHole = 0
	xor a
	ld [wIsSpinningInHole], a
;> if wLinkMotionState == 2:                    # jumping
	ld a, [wLinkMotionState]
	cp $02
;>     return                                   # else on into CheckGroundUnderLink
	jr z, .done

;@ def CheckGroundUnderLink()
;@ path: link/ground
;@ Acts on the ground under Link (wLinkGroundType = the physics of the object at his feet): spikes hurt
;@ him, sinking sand pulls him into its middle and swallows him, holes make him fall, conveyors and
;@ water currents carry him, deep water makes him swim (or drown without the flippers), tall grass
;@ and shallow water show at his feet, slopes and raised blocks shift his sprite, floor switches are
;@ pressed by standing on them and cracked floor gives way after a while. During a room transition or
;@ a dialog only the sprite part runs.
;@ test: skip runs on into HurtLinkOnGround (OtherGround is HurtLinkOnGround.other)
CheckGroundUnderLink::
;> if wRoomTransitionState or wDialogState:
	ld a, [wRoomTransitionState]
	ld hl, wDialogState
	or [hl]
;>     return GroundEffects()
	jp nz, GroundEffects

;> object = GetObjectUnderLink()
	call GetObjectUnderLink
	ld c, a
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr nz, .indoor

;>     if object == 0x61:                       # a hole outdoors
	ld a, c
	cp $61
;>         return FallIntoHole()
	jp z, FallIntoHole

	jr .physics

.indoor
;>@4c elif object == 0x4C and ((hLinkY - 1) & 0x0F) >= 0x0C:
	ld a, c
	cp $4c
	jr nz, .physics

	ldh a, [hLinkY]
	dec a
	and $0f
;=@4c
	cp $0c
;>     return HurtLinkOnGround()
	jr nc, HurtLinkOnGround

.physics
;> wLinkGroundType = GetObjectPhysics(object, wIsIndoor)
	call GetObjectPhysics
	ld [wLinkGroundType], a
;> if wLinkGroundType == 0x00:
	and a
;>     return NormalGround()
	jp z, NormalGround

;> if wLinkGroundType != 0xE0:                  # else spikes: on into HurtLinkOnGround
;>     return OtherGround()
	cp $e0
	jr nz, HurtLinkOnGround.other

;@ def HurtLinkOnGround()
;@ path: link/ground
;@ Spikes and similar ground: unless Link is invincible he bounces back (speed reversed, into the air),
;@ loses half a heart and is invincible for a moment. This unit also holds the rest of
;@ CheckGroundUnderLink: sinking sand, falling into a hole, and GroundEffects.
;@ test: skip runs on into LinkDrown (StartSwimming is LinkDrown.swim)
HurtLinkOnGround::
;> if wInvincibilityCounter:
	ld a, [wInvincibilityCounter]
	and a
;>     return
	jr nz, .done

;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> hLinkSpeedX = -hLinkSpeedX
	ldh a, [hLinkSpeedX]
	cpl
	inc a
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = -hLinkSpeedY
	ldh a, [hLinkSpeedY]
	cpl
	inc a
	ldh [hLinkSpeedY], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .damage

;>     hLinkSpeedZ = 0x10
	ld a, $10
	ldh [hLinkSpeedZ], a
;>     hLinkPositionZ += 2
	ldh a, [hLinkPositionZ]
	add $02
	ldh [hLinkPositionZ], a

.damage
;> wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;> wInvincibilityCounter = 0x30
	ld a, $30
	ld [wInvincibilityCounter], a
;> wSubtractHealthBuffer += 4
	ld a, [wSubtractHealthBuffer]
	add $04
	ld [wSubtractHealthBuffer], a
;> hWaveSfx = 0x03
	ld a, $03
	ldh [hWaveSfx], a

.done
	ret


.other
;> if wLinkGroundType == 0xFF:                  # (CheckGroundUnderLink, other ground)
	ld a, [wLinkGroundType]
	cp $ff
;>     return NormalGround()
	jp z, NormalGround

;> if wLinkGroundType >= 0xF0:
	cp $f0
	jr c, .sand

;>     return OnConveyor()
	jp OnConveyor


.sand
;> if wLinkGroundType not in (0x50, 0x51):      # sinking sand
	cp $51
	jr z, .sinking

	cp $50
;>     return GroundEffects()
	jr nz, GroundEffects

.sinking
;> ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;> wLinkGroundVfx = 7
	ld a, $07
	ld [wLinkGroundVfx], a
;> wSinkingSandCounter += 1
	ld hl, wSinkingSandCounter
	inc [hl]
;> if (hFrameCounter & 0x03) or wDebugToggle:   # pulled every 4th frame
	ld hl, wDebugToggle
	ldh a, [hFrameCounter]
	and $03
	or [hl]
;>     return
	jr nz, FallIntoHole.end

;>@px hLinkX += -1 if hLinkX - 8 - hMultiPurpose0 >= 0 else 1   # toward the middle of the square
	ldh a, [hLinkX]
	sub $08
	ld hl, hMultiPurpose0
	sub [hl]
	bit 7, a
	ld a, $ff
;=@px
	jr z, .moveX

	ld a, $01

.moveX
;=@px
	ld hl, hLinkX
	add [hl]
	ld [hl], a
;>@py hLinkY += -1 if hMultiPurpose1 + 0x10 - hLinkY < 0 else 1
	ldh a, [hMultiPurpose1]
	add $10
	ld hl, hLinkY
	sub [hl]
	bit 7, a
	ld a, $ff
;=@py
	jr nz, .moveY

	ld a, $01

.moveY
;=@py
	ld hl, hLinkY
	add [hl]
	ld [hl], a
;> if ((hLinkX - 8 + 2) & 0x0F) >= 4:           # not yet in the middle
	ldh a, [hLinkX]
	sub $08
	add $02
	and $0f
	cp $04
;>     return
	jr nc, FallIntoHole.end

;> if ((hLinkY - 0x10 + 2) & 0x0F) >= 4:
	ldh a, [hLinkY]
	sub $10
	add $02
	and $0f
	cp $04
;>     return
	jr nc, FallIntoHole.end

;> hLinkY += 3
	ldh a, [hLinkY]
	add $03
	ldh [hLinkY], a

FallIntoHole:
;> wLinkMotionState = 6                         # FallIntoHole: LinkMotionFallingDown
	ld a, $06
	ld [wLinkMotionState], a
;> wLinkMotionCounter = ResetSpinAttackAndDash()   # (0)
	call ResetSpinAttackAndDash
	ld [wLinkMotionCounter], a
;> wHoleCollisionType = wLinkGroundType
	ld a, [wLinkGroundType]
	ld [wHoleCollisionType], a
;> hWaveSfx = 0x0C
	ld a, $0c
	ldh [hWaveSfx], a

.end
	ret


GroundEffects:
;> oam = wOAMBuffer                             # GroundEffects
	ld hl, wOAMBuffer
;> if wLinkGroundType == 0x08:                  # a slope up
	ld a, [wLinkGroundType]
	cp $08
	jr nz, .slopeDown

;>     wLinkSpriteDY -= 3
	ld a, [wLinkSpriteDY]
	add $fd
	ld [wLinkSpriteDY], a
;>     return NormalGround()
	jp NormalGround


.slopeDown
;> elif wLinkGroundType == 0x09:
	cp $09
	jr nz, .deepWater

;>     wLinkSpriteDY += 2
	ld a, [wLinkSpriteDY]
	add $02
	ld [wLinkSpriteDY], a
;>     return NormalGround()
	jp NormalGround


.deepWater
;> elif wLinkGroundType in (0x0B, 0x07):        # deep water
	cp $0b
	jr z, .water

	cp $07
	jr nz, GroundEffectsOther

.water
;>     if hLinkInWater:
	ldh a, [hLinkInWater]
	and a
	jr z, .enter

;>         return InWaterCurrent()
	jp InWaterCurrent


.enter
;>     if wCanTalkToEntity == 0x80:
	ld a, [wCanTalkToEntity]
	cp $80
;>         return GroundEffectsOther()
	jr z, GroundEffectsOther

;>     if wLinkMotionState in (8, 1):           # already recovering / swimming
	ld a, [wLinkMotionState]
	cp $08
	jr z, LinkDrown.done

	cp $01
;>         return
	jr z, LinkDrown.done

;>     AddSplashAtLinkY(hLinkY - 2)
	ldh a, [hLinkY]
	add $fe
	call AddSplashAtLinkY
;>     if hRoomObjectType != 0x06 and wHasFlippers:   # (else on into LinkDrown)
	ldh a, [hRoomObjectType]
	cp $06
	jr z, LinkDrown

	ld a, [wHasFlippers]
	and a
;>         return StartSwimming()
	jr nz, LinkDrown.swim

;@ def LinkDrown()
;@ path: link/ground
;@ Link sinks in water he cannot swim in: motion state 8 (LinkMotionRecover) for $50 frames, frozen.
;@ This unit also holds the rest of CheckGroundUnderLink: starting to swim, tall grass and shallow
;@ water, raised blocks, floor switches and cracked floor (NormalGround).
LinkDrown::
;> hLinkCountdown = 0x50
	ld a, $50
	ldh [hLinkCountdown], a
;> wLinkMotionState = 8
	ld a, $08
	ld [wLinkMotionState], a
;> hLinkMotionStep = hRoomObjectType
	ldh a, [hRoomObjectType]
	ldh [hLinkMotionStep], a
;> hLinkY += 2
	ldh a, [hLinkY]
	add $02
	ldh [hLinkY], a
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> return
	ret


.swim
;> wLinkMotionState = 1                         # StartSwimming: LinkMotionSwimming
	ld a, $01
	ld [wLinkMotionState], a
;> hLinkMotionStep = 0
	xor a
	ldh [hLinkMotionStep], a
;> StopLinkSpeed()
	call StopLinkSpeed
;>@sx hLinkSpeedX = SwimEntrySpeedX[hLinkDirection]
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, SwimEntrySpeedX
	add hl, de
	ld a, [hl]
;=@sx
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = SwimEntrySpeedY[hLinkDirection]
	ld hl, SwimEntrySpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a

.done
	ret


GroundEffectsOther:
;> if wLinkGroundType == 0x06:                  # a hole
	cp $06
;>     return DrawGroundRipple()
	jp z, DrawGroundRipple

;> if wLinkGroundType != 0x05:                  # tall grass / shallow water
	cp $05
;>     return NormalGround()
	jr nz, NormalGround

;>@g1 mem[hl:hl + 4] = (hLinkY + 0x0C, hLinkX, 0x1C, (hFrameCounter << 2) & 0x10)   # two tufts at his feet
	ldh a, [hLinkY]
	add $0c
	ld [hli], a
	ldh a, [hLinkX]
	add $00
	ld [hli], a
;=@g1
	ld a, $1c
	ld [hli], a
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
;=@g1
	push af
	ld [hli], a
;>@g2 mem[hl + 4:hl + 8] = (hLinkY + 0x0C, hLinkX + 8, 0x1C, ((hFrameCounter << 2) & 0x10) | 0x20)
	ldh a, [hLinkY]
	add $0c
	ld [hli], a
	ldh a, [hLinkX]
	add $08
	ld [hli], a
;=@g2
	ld a, $1c
	ld [hli], a
	pop af
	or $20
	ld [hl], a
;> wLinkGroundVfx = 3
	ld a, $03
	ld [wLinkGroundVfx], a
;> if not (hFrameCounter & 0x0F) and hJoypadHeld & 0x0F:   # rustling while walking
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .sink

	ldh a, [hJoypadHeld]
	and $0f
	jr z, .sink

;>     hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a

.sink
;> wLinkSpriteDY += 2
	ld a, [wLinkSpriteDY]
	add $02
	ld [wLinkSpriteDY], a

NormalGround:
;> wSinkingSandCounter = 0                      # NormalGround
	xor a
	ld [wSinkingSandCounter], a
;> if wLinkMotionState == 1:                    # out of the water
	ld a, [wLinkMotionState]
	cp $01
	jr nz, .raised

;>     wLinkMotionState = 0
	ld a, $00
	ld [wLinkMotionState], a

.raised
;>@rb if wLinkGroundType == 0x04 and 0xDB <= hRoomObjectType < 0xDD:
	ld a, [wLinkGroundType]
	cp $04
	jr nz, .offBlock

	ldh a, [hRoomObjectType]
	cp $db
;=@rb
	jr c, .offBlock

	cp $dd
	jr nc, .offBlock

;>@rs     if wRaisedBlocksState ^ RaisedBlockLoweredPhase[hRoomObjectType - 0xDB]:   # raised
	sub $db
	ld e, a
	ld d, $00
	ld hl, RaisedBlockLoweredPhase
	add hl, de
	ld a, [wRaisedBlocksState]
;=@rs
	xor [hl]
	jr z, .offBlock

;>@ry         wLinkSpriteDY += RaisedBlockLinkDY[wRaisedBlockStep]
	ld a, [wRaisedBlockStep]
	ld e, a
	ld d, $00
	ld hl, RaisedBlockLinkDY
	add hl, de
	ld a, [wLinkSpriteDY]
;=@ry
	add [hl]
	ld [wLinkSpriteDY], a
;>         wLinkOnRaisedBlock = 1
	ld a, $01
	ld [wLinkOnRaisedBlock], a
;>         return
	ret


.offBlock
;> if wLinkOnRaisedBlock:                       # stepped off a raised block
	ld a, [wLinkOnRaisedBlock]
	and a
	jr z, .switch

;>     hNoiseSfx = 0x07
	ld a, $07
	ldh [hNoiseSfx], a
;>     wLinkOnRaisedBlock = 0
	xor a
	ld [wLinkOnRaisedBlock], a

.switch
;> if not wIsIndoor or wRoomTransitionState:
	ld a, [wIsIndoor]
	and a
	jp z, Jump_002_7b28

	ld a, [wRoomTransitionState]
	and a
;>     return
	jr nz, Jump_002_7b28

;> if hRoomObjectType == 0xAA and not wFloorSwitchPressedTimer:   # a floor switch
	ldh a, [hRoomObjectType]
	cp $aa
	jr nz, .cracked

	ld a, [wFloorSwitchPressedTimer]
	and a
	jr nz, .cracked

;>     wFloorSwitchStandFrames += 1
	ld a, [wFloorSwitchStandFrames]
	inc a
	ld [wFloorSwitchStandFrames], a
;>     if wFloorSwitchStandFrames == 0x18:      # pressed
	cp $18
	jr nz, .pressedDown

;>         wFloorSwitchPressedTimer = 0x60
	ld a, $60
	ld [wFloorSwitchPressedTimer], a
;>         hWaveSfx = 0x0E
	ld a, $0e
	ldh [hWaveSfx], a
;>         hBGChangeRequest = 3
	ld a, $03
	ldh [hBGChangeRequest], a
;>         if hMapRoom == 0xC3:
	ldh a, [hMapRoom]
	cp $c3
	jr nz, .pressedDown

;>             wRoomStatus[0x79] |= 0x10
	ld hl, wRoomStatus + $79
	set 4, [hl]

.pressedDown
;>     wLinkSpriteDY -= 3
	ld a, [wLinkSpriteDY]
	add $fd
	ld [wLinkSpriteDY], a
;>     return
	ret


.cracked
;> wFloorSwitchStandFrames = 0
	xor a
	ld [wFloorSwitchStandFrames], a
;>@cf if hLinkSquare == hLinkSquarePrev and hRoomObjectType == 0xDF and not (hLinkInteractiveMotionBlocked or wLinkShowItemPose or wDialogState):
	ldh a, [hLinkSquare]
	ld hl, hLinkSquarePrev
	cp [hl]
	ld hl, wCrackedFloorTimer
	jr nz, .reset

	ldh a, [hRoomObjectType]
;=@cf
	cp $df
	jr nz, .reset

	ldh a, [hLinkInteractiveMotionBlocked]
	ld e, a
	ld a, [wLinkShowItemPose]
	ld d, a
;=@cf
	ld a, [wDialogState]
	or e
	or d
	jr nz, .reset

;>     wCrackedFloorTimer += 1                  # cracked floor under a standing Link
	inc [hl]
;>     if wCrackedFloorTimer < 0x28:
	ld a, [hl]
	cp $28
;>         return
	jr c, Jump_002_7b28

;>     hNoiseSfx = 0x2B
	ld a, $2b
	ldh [hNoiseSfx], a
;>     return CollapseFloorUnderLink()
	jp CollapseFloorUnderLink


.reset
;> else:
;>     wCrackedFloorTimer = 0
	ld [hl], $00

Jump_002_7b28:
	ret


;@ path: link/ground
;@ Shift of Link's sprite (wLinkSpriteDY) while he stands on a raised block, by wRaisedBlockStep 0-11
;@ (the blocks rising or sinking). Read by NormalGround.
RaisedBlockLinkDY::
	db $fc, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fc, $fc, $fc

;@ path: link/ground
;@ wRaisedBlocksState for which the raised-block objects $DB / $DC are down (index object - $DB).
;@ Read by ProbeWall and NormalGround.
RaisedBlockLoweredPhase::
	db $00, $02

;@ def DrawGroundRipple(oam: hl)
;@ path: link/ground
;@ Ground type 6: two sprites (tile $1A, flipped every few walking frames) at Link's feet.
;@ test: skip the trial cannot run it to its end
DrawGroundRipple::
;>@r1 mem[oam:oam + 4] = (hLinkY + 8, hLinkX - 1, 0x1A, (wLinkWalkingFrameCount << 2) & 0x20)
	ldh a, [hLinkY]
	add $08
	ld [hli], a
	ldh a, [hLinkX]
	add $ff
	ld [hli], a
;=@r1
	ld a, $1a
	ld [hli], a
	ld a, [wLinkWalkingFrameCount]
	rla
	rla
	and $20
;=@r1
	push af
	ld [hli], a
;>@r2 mem[oam + 4:oam + 8] = (hLinkY + 8, hLinkX + 7, 0x1A, ((wLinkWalkingFrameCount << 2) & 0x20) ^ 0x20)
	ldh a, [hLinkY]
	add $08
	ld [hli], a
	ldh a, [hLinkX]
	add $07
	ld [hli], a
;=@r2
	ld a, $1a
	ld [hli], a
	pop af
	xor $20
	ld [hl], a
;> wLinkGroundVfx = 3
	ld a, $03
	ld [wLinkGroundVfx], a
	ret


;@ path: world/room_scroll
;@ Link's x speed while the screen scrolls to the next room, by wRoomTransitionDirection (0 right,
;@ 1 left, 2 up, 3 down): -$3A, +$3A, 0, 0 (he moves along with the old room). Read by
;@ UpdateRoomTransition.
RoomScrollLinkSpeedX::
	db $c6, $3a, $00, $00

;@ path: world/room_scroll
;@ Link's y speed while the screen scrolls, by direction: 0, 0, +$3A, -$3A.
RoomScrollLinkSpeedY::
	db $00, $00, $3a, $c6

;@ path: world/room_scroll
;@ Camera x step per frame of the room scroll, by direction: +4, -4, 0, 0.
RoomScrollCameraDX::
	db $04, $fc, $00, $00

;@ path: world/room_scroll
;@ Camera y step per frame of the room scroll, by direction: 0, 0, -4, +4.
RoomScrollCameraDY::
	db $00, $00, $fc, $04

;@ def UpdateRoomTransition()
;@ path: world/room_scroll
;@ Runs the move into the next room, step by step (wRoomTransitionState): 1 the new room is loaded,
;@ 2 its tiles, 3 the scroll is set up, then the screen scrolls 4 pixels a frame while the new room's
;@ strips are drawn. Once the camera reaches its target the queued music starts, Link's respawn point
;@ is set, after a scroll down he may hop into water, the room's entry hooks run and in dungeons the
;@ compass chimes for a room whose item is still there.
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
UpdateRoomTransition::
;> if not wRoomTransitionState:
	ld a, [wRoomTransitionState]
	cp $00
;>     return
	jp z, RoomTransitionNone

;> if wRoomTransitionState < 3:
	push af
	cp $03
;>     return RoomTransitionSteps[wRoomTransitionState - 1]()
	jp c, Jump_002_7c50

;>@sx hLinkSpeedX = RoomScrollLinkSpeedX[wRoomTransitionDirection]
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
	ld hl, RoomScrollLinkSpeedX
	add hl, bc
	ld a, [hl]
;=@sx
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = RoomScrollLinkSpeedY[wRoomTransitionDirection]
	ld hl, RoomScrollLinkSpeedY
	add hl, bc
	ld a, [hl]
	ldh [hLinkSpeedY], a
;> ApplyLinkSpeed()
	push bc
	call ApplyLinkSpeed
	pop bc
;> hBaseScrollX += RoomScrollCameraDX[wRoomTransitionDirection]
	ld hl, RoomScrollCameraDX
	add hl, bc
	ldh a, [hBaseScrollX]
	add [hl]
	ldh [hBaseScrollX], a
;> hBaseScrollY += RoomScrollCameraDY[wRoomTransitionDirection]
	ld hl, RoomScrollCameraDY
	add hl, bc
	ldh a, [hBaseScrollY]
	add [hl]
	ldh [hBaseScrollY], a
;> if hBaseScrollY != wRoomScrollTargetY or hBaseScrollX != wRoomScrollTargetX:
	ld hl, wRoomScrollTargetY
	cp [hl]
	jp nz, Jump_002_7c50

	ldh a, [hBaseScrollX]
	ld hl, wRoomScrollTargetX
	cp [hl]
;>     return RoomTransitionSteps[wRoomTransitionState - 1]()
	jp nz, Jump_002_7c50

;> if hNextDefaultMusicTrack:                   # the scroll has ended
	pop af
	ldh a, [hNextDefaultMusicTrack]
	and a
	jr z, .stop

;>     PlayMusic(hNextDefaultMusicTrack)
	call PlayMusic
;>     hNextDefaultMusicTrack = 0
	xor a
	ldh [hNextDefaultMusicTrack], a

.stop
;> a = StopLinkSpeed()                          # (0)
	call StopLinkSpeed
;> hLinkSpeedZ = a
	ldh [hLinkSpeedZ], a
;> wRoomTransitionState = a
	ld [wRoomTransitionState], a
;> wLinkRespawnX = hLinkX
	ldh a, [hLinkX]
	ld [wLinkRespawnX], a
;> wLinkRespawnY = hLinkY
	ldh a, [hLinkY]
	ld [wLinkRespawnY], a
;> if wRoomTransitionDirection == 3:             # came in from the top
	ld a, [wRoomTransitionDirection]
	cp $03
	jr nz, .jingle

;>     hLinkSpeedY = 1
	ld a, $01
	ldh [hLinkSpeedY], a
;>     CollideLinkWithWalls()
	call CollideLinkWithWalls
;>@hop     if hRoomObjectType not in (0xDB, 0xDC) and (hRoomObjectType == 0xE1 or wLinkCollisionFlags):
	ldh a, [hRoomObjectType]
	cp $db
	jr z, .jingle

	cp $dc
	jr z, .jingle

;=@hop
	cp $e1
	jr z, .hop

	ld a, [wLinkCollisionFlags]
	and a
	jr z, .jingle

.hop
;>         if not wDebugToggle:
	ld a, [wDebugToggle]
	and a
	jr nz, .jingle

;>             LinkJumpIntoWaterColumn()
	call LinkJumpIntoWaterColumn

.jingle
;> if wJingleAfterTransition:
	ld a, [wJingleAfterTransition]
	and a
	jr z, .entered

;>     hJingle = wJingleAfterTransition
	ldh [hJingle], a
;>     wJingleAfterTransition = 0
	xor a
	ld [wJingleAfterTransition], a

.entered
;> OnRoomEnteredBank1()
	call OnRoomEnteredBank1
;> hAnimatedTilesFrameCount = 0xFF
	ld a, $ff
	ldh [hAnimatedTilesFrameCount], a
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     return
	ret z

;> group = 1                                    # the room's indoor group
	ld d, a
;> if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .info

	cp $06
	jr c, .info

;>     group = 2
	inc d

.info
;> info = GetRoomInfo(group, hMapRoom)
	ldh a, [hMapRoom]
	ld e, a
	call GetRoomInfo
;>@inf if info not in (0x1A, 0x19) and (wRoomEvent & 0xE0) != 0x80:
	cp $1a
	jr z, .compass

	cp $19
	jr z, .compass

;=@inf
	ld a, [wRoomEvent]
	and $e0
	cp $80
;>     return
	ret nz

.compass
;> if wDungeonHasCompass and not (hRoomStatus & 0x10):   # its item is still there
	ld a, [wDungeonHasCompass]
	and a
	ret z

	ldh a, [hRoomStatus]
	and $10
	ret nz

;>     wCompassChimeDelay = 0x0C
	ld a, $0c
	ld [wCompassChimeDelay], a
	ret


Jump_002_7c50:
;> return RoomTransitionSteps[wRoomTransitionState - 1]()   # (the state pushed above)
	pop af
	dec a
	rst $00

;@ path: world/room_scroll
;@ Room transition steps by wRoomTransitionState - 1 (2-byte code addresses): 1 LoadNextRoom, 2 LoadNextRoomTiles,
;@ 3 SetUpRoomScroll, 4 DrawRoomScrollStrip, 5 nothing.
RoomTransitionSteps::
	dw LoadNextRoom
	dw LoadNextRoomTiles
	dw SetUpRoomScroll
	dw DrawRoomScrollStrip
	dw RoomTransitionDone

;@ def RoomTransitionNone()
;@ path: world/room_scroll
;@ No room transition: nothing to do.
RoomTransitionNone::
;> return
	ret


;@ path: world/room_scroll
;@ The Face Shrine maze room ($71 of map $08): the 8 directions to walk out of it (0 right, 1 left,
;@ 2 up), from index wFaceShrineHint (4 routes, 8 bytes apart... overlapping). Read by LoadNextRoom.
MazeRoomPaths::
	db $01, $01, $02, $00, $00, $02, $01, $02, $00, $02, $02, $00, $02, $02, $00, $02
	db $01, $02, $00, $02, $01, $02, $00, $02, $00, $00, $00, $00, $02, $02, $02, $02

;@ def LoadNextRoom()
;@ path: world/room_scroll
;@ Transition step 1: picks the room behind the edge (OverworldRoomStep / IndoorRoomStep, with a few
;@ special links, and the Face Shrine maze that keeps Link in its room until he walks its path), loads
;@ it and its entities, and picks the overworld music of the new room (the power-up music stays).
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
LoadNextRoom::
;> direction = wRoomTransitionDirection
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;> if wIsIndoor and hMapId < 0x0B:              # a dungeon
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

	ldh a, [hMapId]
	cp $0b
	jr nc, .overworld

;>@mz     if hMapId == 0x08 and hMapRoom == 0x71 and direction != 3:   # the maze room
	cp $08
	jr nz, .dungeon

	ldh a, [hMapRoom]
	cp $71
;=@mz
	jr nz, .dungeon

	ld a, c
	cp $03
	jr z, .dungeon

;>         path = MazeRoomPaths + wFaceShrineHint
	ld a, [wFaceShrineHint]
	ld e, a
	ld d, $00
	ld hl, MazeRoomPaths
	add hl, de
;>         step = wMazeRoomStep
	ld a, [wMazeRoomStep]
	ld e, a
;>         wMazeRoomStep += 1
	inc a
	ld [wMazeRoomStep], a
;>         if direction != path[step]:   # wrong way: start again
	add hl, de
	ld a, c
	cp [hl]
	jr z, .rightWay

;>             wMazeRoomStep = 0
	xor a
	ld [wMazeRoomStep], a
;>             return EnterRoom()               # the same room again
	jp EnterRoom


.rightWay
;>         if step != 7:
	ld a, e
	cp $07
;>             return EnterRoom()
	jp nz, EnterRoom

;>         wJingleAfterTransition = 2           # out of the maze
	ld a, $02
	ld [wJingleAfterTransition], a

.dungeon
;>     wMazeRoomStep = 0
	xor a
	ld [wMazeRoomStep], a
;>@r1d     if direction == 2 and hMapId == 0x05 and wIndoorRoom == 0x1D:
	ld hl, IndoorRoomStep
	add hl, bc
	ld a, c
	cp $02
	jr nz, .indoorStep

	ldh a, [hMapId]
;=@r1d
	cp $05
	jr nz, .indoorStep

	ld a, [wIndoorRoom]
	cp $1d
	jr nz, .indoorStep

;>         wIndoorRoom = 0x35
	ld a, $35
	ld [wIndoorRoom], a

.indoorStep
;>     room = wIndoorRoom + IndoorRoomStep[direction]
	ld a, [hl]
	ld hl, wIndoorRoom
	jr .add

.overworld
;> elif wRaccoonLoopsExit and direction == 2:   # out of the raccoon's looping woods
	ld a, [wRaccoonLoopsExit]
	and a
	jr z, .overworldStep

	ld a, c
	cp $02
	jr nz, .overworldStep

;>     wJingleAfterTransition = 0x1E
	ld a, $1e
	ld [wJingleAfterTransition], a
;>     room = 0x63
	ld a, $63
	ld hl, hMapRoom
	jr .store

.overworldStep
;> else:
;>     room = hMapRoom + OverworldRoomStep[direction]
	ld hl, OverworldRoomStep
	add hl, bc
	ld a, [hl]
	ld hl, hMapRoom

.add
	add [hl]

.store
;> mem[hl] = room                           # wIndoorRoom in a dungeon, else hMapRoom
	ld [hl], a
;>@41 if room == 0x41 and direction == 2 and not (wRoomStatus[0x41] & 0x40):   # first time
	cp $41
	jr nz, EnterRoom

	ld a, c
	cp $02
	jr nz, EnterRoom

;=@41
	ld hl, wRoomStatus + $41
	bit 6, [hl]
	jr nz, EnterRoom

;>     wRoomStatus[0x41] |= 0x40
	set 6, [hl]
;>     wJingleAfterTransition = 2
	ld a, $02
	ld [wJingleAfterTransition], a

EnterRoom:
;> LoadRoom()                                   # EnterRoom
	call LoadRoom
;> LoadRoomEntities()
	call LoadRoomEntities
;> DrawLinkOAM()
	call DrawLinkOAM
;> UpdateLinkItemSprites()
	call UpdateLinkItemSprites
;> if wRestoreMusicAfterTransition:
	ld a, [wRestoreMusicAfterTransition]
	and a
	jr z, .overworldMusic

;>     wRestoreMusicAfterTransition = 0
	xor a
	ld [wRestoreMusicAfterTransition], a
;>@nx     hNextDefaultMusicTrack = 0x49 if wActivePowerUp else hDefaultMusicTrack
	ld a, [wActivePowerUp]
	and a
	ldh a, [hDefaultMusicTrack]
	jr z, .setNext

	ld a, $49

.setNext
;=@nx
	ldh [hNextDefaultMusicTrack], a
;>     FadeOutVolume()
	call FadeOutVolume
;>     return NextTransitionStep()
	jr NextTransitionStep

.overworldMusic
;> if wIsIndoor or not wSwordLevel:
	ld a, [wIsIndoor]
	and a
	jr nz, NextTransitionStep

	ld a, [wSwordLevel]
	and a
;>     return NextTransitionStep()
	jr z, NextTransitionStep

;> track = OverworldMusicTracks[hMapRoom]
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, OverworldMusicTracks
	add hl, de
	ld a, [hl]
;> if track == hDefaultMusicTrack:
	ld hl, hDefaultMusicTrack
	cp [hl]
;>     return NextTransitionStep()
	jr z, NextTransitionStep

;>@bp beats = track < 0x25 and MusicTrackBeatsPowerUp[track]   # it plays even over the power-up music
	ld c, a
	cp $25
	jr nc, .powerUp

	ld b, $00
	ld hl, MusicTrackBeatsPowerUp
	add hl, bc
;=@bp
	ld a, [hl]
	and a
	jr nz, .beats

.powerUp
;> if not beats and not wActivePowerUp:
	ld a, [wActivePowerUp]
	and a
;>     return SetNextMusic(track)
	jr z, SetNextMusic

;> if not beats and hDefaultMusicTrackAlt == 0x49:
	ldh a, [hDefaultMusicTrackAlt]
	cp $49
;>     hDefaultMusicTrack = track
;>     return NextTransitionStep()
	jr z, SetNextMusic.setDefault

;> if not beats:
;>     SetNextMusic(track)
	call SetNextMusic
;>     hNextDefaultMusicTrack = 0x49            # back to the power-up music
	ld a, $49
	ldh [hNextDefaultMusicTrack], a
;>     hDefaultMusicTrackAlt = 0x49
	ldh [hDefaultMusicTrackAlt], a
;>     return
	ret


.beats
;> hDefaultMusicTrackAlt = track                # then on into SetNextMusic
	ld a, c
	ldh [hDefaultMusicTrackAlt], a

;@ def SetNextMusic(track: c)
;@ path: world/room_scroll
;@ Queues the room's music (hNextDefaultMusicTrack), fades the volume out and makes it the default
;@ track; then the room transition goes to its next step.
SetNextMusic::
;> hNextDefaultMusicTrack = track
	ld a, c
	ldh [hNextDefaultMusicTrack], a
;> FadeOutVolume()
	call FadeOutVolume

.setDefault
;> hDefaultMusicTrack = track
	ld a, c
	ldh [hDefaultMusicTrack], a

NextTransitionStep:
;> wRoomTransitionState += 1                    # NextTransitionStep
	ld a, [wRoomTransitionState]
	inc a
	ld [wRoomTransitionState], a
	ret


;@ def LoadNextRoomTiles()
;@ path: world/room_scroll
;@ Transition step 2: loads the new room's tile sets (with mem[0xD6FA] == 2 the tile swap counts 2).
LoadNextRoomTiles::
;> LoadRoomTilesets()
	call LoadRoomTilesets
;> if mem[0xD6FA] == 2:
	ld a, [$d6fa]
	cp $02
	jr nz, .next

;>     hTileSwapFinishCount = 2
	ld a, $02
	ldh [hTileSwapFinishCount], a

.next
;> return NextTransitionStep()
	jp NextTransitionStep


;@ path: world/room_scroll
;@ High byte added to wBGOriginHigh (the top left of the visible background map) for the new room,
;@ by direction 0-3 (right, left, up, down). Read by SetUpRoomScroll.
RoomScrollOriginDeltaHigh::
	db $00, $00, $02, $02

;@ path: world/room_scroll
;@ Low byte added to wBGOriginLow for the new room by direction (x wraps within the 32-tile row).
RoomScrollOriginDeltaLow::
	db $14, $0c, $00, $00

;@ path: world/room_scroll
;@ High byte of the offset from the old background origin to the first strip drawn
;@ (wTransitionDrawHigh), by direction.
RoomScrollDrawDeltaHigh::
	db $00, $00, $03, $02

;@ path: world/room_scroll
;@ Low byte of the offset to the first strip drawn (wTransitionDrawLow), by direction.
RoomScrollDrawDeltaLow::
	db $14, $1e, $c0, $00
;@ path: world/room_scroll
;@ Room squares per strip of the scroll by direction: 8 (a column) for right / left, 10 (a row) for
;@ up / down (wTransitionStripLength).
RoomScrollStripLength::
	db $08, $08, $0a, $0a

;@ path: world/room_scroll
;@ Number of strips to draw by direction: 10 columns or 8 rows (wTransitionStripsLeft).
RoomScrollStripCount::
	db $0a, $0a, $08, $08

;@ path: world/room_scroll
;@ Index of the first room object drawn by direction (wTransitionObjectIndex): right $00 (left column),
;@ left $09 (right column), up $70 (bottom row), down $00; the last 4 bytes are not read.
RoomScrollFirstObject::
	db $00, $09, $70, $00, $40, $40, $02, $02
;@ path: world/room_scroll
;@ Change of wRoomScrollTargetX for the new room by direction: +$A0, -$A0, 0, 0.
RoomScrollTargetDX::
	db $a0, $60, $00, $00

;@ path: world/room_scroll
;@ Change of wRoomScrollTargetY by direction: 0, 0, -$80, +$80.
RoomScrollTargetDY::
	db $00, $00, $80, $80

;@ path: world/room_scroll
;@ Overworld room number step by direction: +1, -1, -$10, +$10 (16 x 16 grid). Read by LoadNextRoom.
OverworldRoomStep::
	db $01, $ff, $f0, $10

;@ path: world/room_scroll
;@ Indoor room number step by direction: +1, -1, -8, +8 (8 x 8 grid).
IndoorRoomStep::
	db $01, $ff, $f8, $08

;@ def SetUpRoomScroll()
;@ path: world/room_scroll
;@ Transition step 3: the camera's target, the new background origin, where the first strip of the
;@ new room is drawn, the strip size and count and the first room object (tables by direction).
;@ test: skip reads data tables by index, which the trial's stand-ins cannot do
SetUpRoomScroll::
;> direction = wRoomTransitionDirection
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;> wRoomScrollTargetX += RoomScrollTargetDX[direction]
	ld hl, RoomScrollTargetDX
	add hl, bc
	ld a, [wRoomScrollTargetX]
	add [hl]
	ld [wRoomScrollTargetX], a
;> wRoomScrollTargetY += RoomScrollTargetDY[direction]
	ld hl, RoomScrollTargetDY
	add hl, bc
	ld a, [wRoomScrollTargetY]
	add [hl]
	ld [wRoomScrollTargetY], a
;>@dl wTransitionDrawLow = (wBGOriginLow + RoomScrollDrawDeltaLow[direction]) & 0xDF   # (carry kept)
	ld hl, RoomScrollDrawDeltaLow
	add hl, bc
	ld a, [wBGOriginLow]
	add [hl]
	rl d
	and $df
;=@dl
	ld [wTransitionDrawLow], a
;>@dh wTransitionDrawHigh = (wBGOriginHigh + RoomScrollDrawDeltaHigh[direction] + carry) & 0x03
	ld hl, RoomScrollDrawDeltaHigh
	add hl, bc
	ld a, [wBGOriginHigh]
	rr d
	adc [hl]
	and $03
;=@dh
	ld [wTransitionDrawHigh], a
;>@ol wBGOriginLow = (wBGOriginLow + RoomScrollOriginDeltaLow[direction]) & 0xDF
	ld hl, RoomScrollOriginDeltaLow
	add hl, bc
	ld a, [wBGOriginLow]
	add [hl]
	rl d
	and $df
;=@ol
	ld [wBGOriginLow], a
;>@oh wBGOriginHigh = (wBGOriginHigh + RoomScrollOriginDeltaHigh[direction] + carry) & 0x03
	ld hl, RoomScrollOriginDeltaHigh
	add hl, bc
	ld a, [wBGOriginHigh]
	rr d
	adc [hl]
	and $03
;=@oh
	ld [wBGOriginHigh], a
;> wTransitionStripLength = RoomScrollStripLength[direction]
	ld hl, RoomScrollStripLength
	add hl, bc
	ld a, [hl]
	ld [wTransitionStripLength], a
;> wTransitionStripsLeft = RoomScrollStripCount[direction]
	ld hl, RoomScrollStripCount
	add hl, bc
	ld a, [hl]
	ld [wTransitionStripsLeft], a
;> wTransitionObjectIndex = RoomScrollFirstObject[direction]
	ld hl, RoomScrollFirstObject
	add hl, bc
	ld a, [hl]
	ld [wTransitionObjectIndex], a
;> wTransitionDrawDelay = 0
	xor a
	ld [wTransitionDrawDelay], a
;> return NextTransitionStep()
	jp NextTransitionStep


;@ def DrawRoomScrollStrip()
;@ path: world/room_scroll
;@ Transition step 4: draws the next strip of the new room (DrawTransitionStrip) while the screen scrolls.
;@ test: skip the trial cannot run it to its end
DrawRoomScrollStrip::
;> DrawTransitionStrip()
	call DrawTransitionStrip
	ret


;@ def RoomTransitionDone()
;@ path: world/room_scroll
;@ Transition step 5: nothing left to do but scroll.
RoomTransitionDone::
;> return
	ret


;@ path: link/ground
;@ X step of a conveyor belt by ground type $F0-$F7: $F0 down, $F1 up, $F2 left, $F3 right, then the
;@ diagonals down-right, down-left, up-right, up-left. Read by OnConveyor.
ConveyorSpeedX::
	db $00, $00, $ff, $01, $01, $ff, $01, $ff

;@ path: link/ground
;@ Y step of a conveyor belt by ground type $F0-$F7 (same order).
ConveyorSpeedY::
	db $01, $ff, $00, $00, $01, $01, $ff, $ff

;@ def OnConveyor()
;@ path: link/ground
;@ Ground types $F0-$F7: every 4th frame the belt moves Link one pixel (unless he is frozen, busy or
;@ showing an item).
OnConveyor::
;>@cv if (hFrameCounter & 0x03) or wLinkFrozen or hLinkInteractiveMotionBlocked or wLinkShowItemPose:
	ldh a, [hFrameCounter]
	and $03
	ld hl, wLinkFrozen
	or [hl]
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
;=@cv
	ld hl, wLinkShowItemPose
	or [hl]
;>     return
	ret nz

;>@cx hLinkX += ConveyorSpeedX[wLinkGroundType - 0xF0]
	ld a, [wLinkGroundType]
	sub $f0
	ld e, a
	ld d, $00
	ld hl, ConveyorSpeedX
	add hl, de
;=@cx
	ldh a, [hLinkX]
	add [hl]
	ldh [hLinkX], a
;> hLinkY += ConveyorSpeedY[wLinkGroundType - 0xF0]
	ld hl, ConveyorSpeedY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hLinkY], a
	ret


;@ path: link/ground
;@ X speed of a water current by current 0-7: 0-3 ever faster to the left (-4, -6, -8, -10), 4 right
;@ +$0C, 5 / 6 none, 7 left -$0C. Read by InWaterCurrent.
WaterCurrentSpeedX::
	db $fc, $fa, $f8, $f6, $0c, $00, $00, $f4

;@ path: link/ground
;@ Y speed of a water current by current 0-7: 5 up -$0C, 6 down +$0C, else 0.
WaterCurrentSpeedY::
	db $00, $00, $00, $00, $00, $f4, $0c, $00

;@ def InWaterCurrent()
;@ path: link/ground
;@ While Link swims in deep water with a current he drifts: objects $E7-$EE give currents 0-7; object
;@ $0E is the river of rooms $3F, $3E, $3D, $3C (currents 0-3, faster downstream).
InWaterCurrent::
;>@wc if wRoomTransitionState or wLinkShowItemPose or hLinkInteractiveMotionBlocked or wDialogState or wInventoryAppearing:
	ldh a, [hFrameCounter]
	and $00
	ld hl, wRoomTransitionState
	or [hl]
	ld hl, wLinkShowItemPose
	or [hl]
;=@wc
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
	ld hl, wDialogState
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
;>     return
	jr nz, .done

;> current = 1
	ld e, $01
;> if hRoomObjectType == 0x0E:                  # the river
	ldh a, [hRoomObjectType]
	cp $0e
	jr nz, .object

;>     if hMapRoom == 0x3E: current = 1
	ldh a, [hMapRoom]
	cp $3e
	jr z, .set

;>     elif hMapRoom == 0x3D: current = 2
	inc e
	cp $3d
	jr z, .set

;>     elif hMapRoom == 0x3C: current = 3
	inc e
	cp $3c
	jr z, .set

;>     elif hMapRoom == 0x3F: current = 0       # (other rooms: return)
	cp $3f
	jr nz, .done

	ld e, $00
	jr .set

.object
;> else:
;>     current = hRoomObjectType - 0xE7
	sub $e7
	ld e, a

.set
;> hLinkSpeedX = WaterCurrentSpeedX[current]
	ld d, $00
	ld hl, WaterCurrentSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = WaterCurrentSpeedY[current]
	ld hl, WaterCurrentSpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> CollideLinkWithWalls()
	call CollideLinkWithWalls

.done
	ret


;@ path: system
;@ Unused rest of bank 2, filled with $FF.
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
