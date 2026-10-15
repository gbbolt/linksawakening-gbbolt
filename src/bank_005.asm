; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

;@ path: npc/bowwow
;@ BowWow's sprites while it is chained at Madam MeowMeow's house (its tiles sit at $70-$7C there).
;@ 7 sprite variants of 4 bytes, drawn by DrawEntity16x16 as two 8x16 sprites side by side: tile and
;@ attributes of the left half, then tile and attributes of the right half (attribute $20 = mirrored).
;@ Variants 0-1 facing down (two frames), 2-3 facing left, 4-5 facing right (2-3 mirrored), 6 facing up.
;@ Chosen by SetBowWowSpriteFromSpeed.
BowWowSpritesHome::
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $76, $00, $78, $00, $7a, $00
	db $76, $20, $74, $20, $7a, $20, $78, $20, $7c, $00, $7c, $20

;@ path: npc/bowwow
;@ BowWow's sprites everywhere else (held in the Moblins' cave, or following Link): the same 7 variants
;@ as BowWowSpritesHome, with the tiles at $40-$4C where the game loads them outside the house area.
BowWowSpritesAway::
	db $40, $00, $40, $20
	db $42, $00, $42, $20, $44, $00, $46, $00, $48, $00, $4a, $00, $46, $20, $44, $20
	db $4a, $20, $48, $20, $4c, $00, $4c, $20

;@ def BowWowEntityHandler(slot: bc)
;@ path: npc/bowwow
;@ Entity handler of BowWow (type $6D): the chain chomp that hops around its stake, lunges at Link
;@ while it is at home and, once Link has rescued it, follows him on its chain and eats enemies.
;@ Draws BowWow, runs its stages (BowWowStages) and draws the chain.
BowWowEntityHandler::
;> wBowWowSlot = slot
	ld a, c
	ld [wBowWowSlot], a
;> if wIsBowWowFollowingLink == 1:
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jr nz, jr_005_4054

;>     wEntityRoom[slot] = hMapRoom      # it travels with Link: always belongs to the current room
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
;>     wEntityPosXHigh[slot] = 0
	ld hl, wEntityPosXHigh
	add hl, bc
	ld [hl], b
;>     wEntityPosYHigh[slot] = 0
	ld hl, wEntityPosYHigh
	add hl, bc
	ld [hl], b

;> sprites = BowWowSpritesAway
jr_005_4054:
	ld de, BowWowSpritesAway
;> if wIsBowWowFollowingLink == 0:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr nz, jr_005_4060

;>     sprites = BowWowSpritesHome
	ld de, BowWowSpritesHome

;> DrawEntity16x16(slot, sprites)                  # draw BowWow (two 8x16 sprites)
jr_005_4060:
	call DrawEntity16x16
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
	jr z, jr_005_407e

;>     if wIsBowWowFollowingLink != 1:
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jp z, Jump_005_40a4

;>         if wEntityRoom[slot] == hMapRoom:
	ld hl, wEntityRoom
	add hl, bc
	ldh a, [hMapRoom]
	cp [hl]
;>             return
	jp z, Jump_005_40a7

;>     DrawBowWowChain(slot)                 # while the screen scrolls only the chain is kept up
;>     return
	jp Jump_005_40a4


;> if mem[0xC1A8] or wDialogState or wInventoryAppearing:
jr_005_407e:
	ld a, [wLinkShowItemPoseActive]
	ld hl, wDialogState
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jp nz, Jump_005_40a4

;>@chain     DrawBowWowChain(slot)
;>@chain     return
;> if wTransitionSequenceCounter != 4:  # screen still fading in
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	ret nz

;> SetBowWowSpriteFromSpeed(slot)
	call SetBowWowSpriteFromSpeed
;> DecrementEntityIgnoreHitsTimer(slot)                        # count down wEntityIgnoreHitsTimer
	call DecrementEntityIgnoreHitsTimer
;> if wIsBowWowFollowingLink == 0:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr nz, jr_005_40a1

;>     EntityCheckWeaponHits(slot)                    # at home it can be hit with the sword
	call EntityCheckWeaponHits

;> BowWowDispatch(slot)
jr_005_40a1:
	call BowWowDispatch

;> DrawBowWowChain(slot)
Jump_005_40a4:
;=@chain
	call DrawBowWowChain

Jump_005_40a7:
	ret


;@ def BowWowDispatch(slot: bc)
;@ path: npc/bowwow
;@ Runs BowWow's stage from wEntityPrivate4: 0 = set up the chain once, 1 = normal behaviour.
BowWowDispatch::
;> BowWowStages[wEntityPrivate4[slot]](slot)
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: npc/bowwow
;@ BowWow's stages (wEntityPrivate4), dispatched by BowWowDispatch.
BowWowStages::
	dw BowWowInit
	dw BowWowMain

;@ def BowWowInit(slot: bc)
;@ path: npc/bowwow
;@ First frame: moves BowWow 4 pixels right and 8 down onto its stake, remembers that point as the
;@ chain's anchor (wEntityPrivate1/2) and puts all chain links (wEntityWorkRAM2 / wSegmentY) on it.
BowWowInit::
;> wEntityX[slot] = (wEntityX[slot] + 4) & 0xFF
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
;> wEntityPrivate1[slot] = wEntityX[slot]     # anchor x
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> for i in range(16): wEntityWorkRAM2[i] = wEntityX[slot]
	ld e, $10
	ld hl, wEntityWorkRAM2

jr_005_40c4:
	ld [hli], a
	dec e
	jr nz, jr_005_40c4

;> wEntityY[slot] = (wEntityY[slot] + 8) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;> wEntityPrivate2[slot] = wEntityY[slot]     # anchor y
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> y = (wEntityY[slot] - wEntityZ[slot]) & 0xFF
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
;> for i in range(16): wSegmentY[i] = y
	ld e, $10
	ld hl, wSegmentY

jr_005_40df:
	ld [hli], a
	dec e
	jr nz, jr_005_40df

;> wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ret


;@ def BowWowMain(slot: bc)
;@ path: npc/bowwow
;@ BowWow's normal frame. Following Link, the chain's anchor moves with Link. Held in the Moblins'
;@ cave ($80), it waits for Link to bump into it near (x $88, y $40): then the music changes, the
;@ text $16C opens and it starts following him. Then the hop physics (height falls 2 per frame,
;@ hBGTilesRequestCopy is used as a "just landed" flag) and the state from BowWowStates.
BowWowMain::
;> if wIsBowWowFollowingLink != 0:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, jr_005_413a

;>     if wIsBowWowFollowingLink != 0x80:
	cp $80
	jr z, jr_005_40fd

;>         wEntityPrivate1[slot] = hLinkX       # the chain is held by Link
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;>@anchor         wEntityPrivate2[slot] = hLinkDrawYAtFrameStart
	ldh a, [hLinkDrawYAtFrameStart]
	ldh [hMultiPurpose1], a
	jr jr_005_412c

;>     elif (hLinkY - 0x40 + 0x10) & 0xFF < 0x20:
jr_005_40fd:
	ldh a, [hLinkY]
	sub $40
	add $10
	cp $20
	jr nc, jr_005_412a

;>         if (hLinkX - 0x88 + 0x10) & 0xFF < 0x20:
	ldh a, [hLinkX]
	sub $88
	add $10
	cp $20
	jr nc, jr_005_412a

;>             if wLinkCollisionFlags:              # Link bumps into it: rescued
	ld a, [wLinkCollisionFlags]
	and a
	jr z, jr_005_412a

;>                 wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>                 OpenDialogTable1(0x6C)           # text $16C
	ld a, $6c
	call OpenDialogTable1
;>                 hWaveSfx = 0x18
	ld a, $18
	ldh [hWaveSfx], a
;>                 wIsBowWowFollowingLink = 1
	ld a, $01
	ld [wIsBowWowFollowingLink], a

jr_005_412a:
	jr jr_005_413a

jr_005_412c:
;=@anchor
	ldh a, [hMultiPurpose0]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose1]
;=@anchor
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

;> wBowWowAnchorX = wEntityPrivate1[slot]
jr_005_413a:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wBowWowAnchorX], a
;> wBowWowAnchorY = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld [wBowWowAnchorY], a
;> AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;> wEntitySpeedZ[slot] = (wEntitySpeedZ[slot] - 2) & 0xFF    # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	push hl
	pop de
;> hBGTilesRequestCopy = wEntityZ[slot] & 0x80             # below the ground: it just landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if hBGTilesRequestCopy:
	jr z, jr_005_4163

;>     wEntityZ[slot] = 0
;>     wEntitySpeedZ[slot] = 0
	xor a
	ld [hl], a
	ld [de], a

;> EntityCheckWalls(slot)                        # walls and ground under the entity
jr_005_4163:
	call EntityCheckWalls
;> BowWowStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/bowwow
;@ BowWow's states (wEntityState), dispatched by BowWowMain: 0 idle, 1 hop, 2 lunge at Link,
;@ 3 rest, 4 lunge at an enemy to eat it.
BowWowStates::
	dw BowWowIdleState
	dw BowWowHopState
	dw BowWowLungeState
	dw BowWowRestState
	dw BowWowLungeState

;@ path: npc/bowwow
;@ x speeds of BowWow's 8 random hop directions (signed, 1/16 pixel per frame), indexed together with
;@ BowWowHopSpeedY by a random number 0-7. Read by BowWowIdleState.
BowWowHopSpeedX::
	db $04, $08, $0c, $08, $fc, $f8, $f4, $f8

;@ path: npc/bowwow
;@ y speeds of BowWow's 8 hop directions (signed, 1/16 pixel per frame), see BowWowHopSpeedX.
BowWowHopSpeedY::
	db $f4, $f8, $04, $08, $0c, $08, $fc, $f8

;@ def BowWowIdleState(slot: bc)
;@ path: npc/bowwow
;@ State 0. While wEntityTimer runs, starts a hop in a random direction whenever wEntityTimer1 has
;@ run out. When wEntityTimer runs out: following Link it looks for something to eat; at home it
;@ jumps at Link (state 2).
BowWowIdleState::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr z, jr_005_41b4

;>@attack     wEntityTimer[slot] = 0x28
;>@attack     if wIsBowWowFollowingLink:
;>@attack         BowWowLookForFood(slot)
;>@attack         return
;>@attack     wEntitySpeedZ[slot] = 0x20
;>@attack     wEntityState[slot] = 2
;>@attack     SetEntitySpeedTowardsLink(slot, 0x20)                    # speed $20 towards Link
;>@attack     return
;> if wEntityTimer1[slot] != 0:
	call GetEntityTimer1
;>     return
	jr nz, jr_005_41b3

;> wEntityTimer1[slot] = (GetRandomByte() & 0x3F) + 0x20      # hop for 32-95 frames
	call GetRandomByte
	and $3f
	add $20
	ld [hl], a
;> wEntityState[slot] += 1             # hop
	call IncrementEntityState
;> d = GetRandomByte() & 7                 # random direction
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = BowWowHopSpeedX[d]
	ld hl, BowWowHopSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = BowWowHopSpeedY[d]
	ld hl, BowWowHopSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

;> return
jr_005_41b3:
	ret


jr_005_41b4:
;=@attack
	call GetEntityTimer
	ld [hl], $28
;=@attack
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, jr_005_41c3

;=@attack
	call BowWowLookForFood
;=@attack
	ret


jr_005_41c3:
;=@attack
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;=@attack
	call IncrementEntityState
	ld [hl], $02
;=@attack
	ld a, $20
	call SetEntitySpeedTowardsLink
;=@attack
	ret


;@ def BowWowHopState(slot: bc)
;@ path: npc/bowwow
;@ State 1: hops along (a small jump each time it lands) until wEntityTimer1 runs out, kept within
;@ reach of its chain; then back to idle with wEntityTimer1 = $20.
BowWowHopState::
;> if wEntityTimer1[slot] == 0:
	call GetEntityTimer1
	jr nz, jr_005_41df

;>     wEntityTimer1[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

;> if hBGTilesRequestCopy:              # landed: hop again
jr_005_41df:
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_005_41ea

;>     wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_41ea:
	call UpdateEntityPosWithSpeed_05
;> BowWowKeepInChainRange(slot)
	call BowWowKeepInChainRange
	ret


;@ def BowWowLungeState(slot: bc)
;@ path: npc/bowwow
;@ States 2 and 4: flies at its target until wEntityTimer runs out or the chain stops it, then rests
;@ (state 3) for $10 frames. While following Link it bites the enemy it lunged at.
BowWowLungeState::
;> stop = True
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, jr_005_41ff

;>     UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;>     stop = BowWowKeepInChainRange(slot) != 1     # the chain held it back
	call BowWowKeepInChainRange
	dec e
;> if stop:
	jr z, jr_005_420c

;>     ClearEntitySpeed(slot)                    # stop
jr_005_41ff:
	call ClearEntitySpeed
;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10

;> if wIsBowWowFollowingLink:
jr_005_420c:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, jr_005_4215

;>     BowWowBiteTarget(slot)
	call BowWowBiteTarget

jr_005_4215:
	ret


;@ def BowWowRestState(slot: bc)
;@ path: npc/bowwow
;@ State 3: sits still until wEntityTimer runs out, then idles again with a new wEntityTimer of
;@ 48-111 frames at home, 16 frames while following Link.
BowWowRestState::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_005_422f

;>     wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x30
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
;>     if wIsBowWowFollowingLink:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr z, jr_005_422b

;>         wEntityTimer[slot] = 0x10
	ld [hl], $10

;>     wEntityState[slot] = 0
jr_005_422b:
	call IncrementEntityState
	ld [hl], b

jr_005_422f:
	ret


;@ def BowWowKeepInChainRange(slot: bc) -> e
;@ path: npc/bowwow
;@ The chain is 32 pixels long: if this frame's move took BowWow 32 or more pixels away from the
;@ anchor on an axis, it is put back on that axis to where it was (hActiveEntityX / Y). Returns 1 +
;@ the number of axes that were held back.
BowWowKeepInChainRange::
;> e = 1
	ld e, $01
;> dx = (wEntityPrivate1[slot] - wEntityX[slot]) & 0xFF
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if (dx + 0x20) & 0xFF >= 0x40:          # 32+ pixels from the anchor
	add $20
	cp $40
	jr c, jr_005_4246

;>     wEntityX[slot] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [hl], a
;>     e += 1
	inc e

;> dy = (wEntityPrivate2[slot] - wEntityY[slot]) & 0xFF
jr_005_4246:
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if (dy + 0x20) & 0xFF >= 0x40:
	add $20
	cp $40
	jr c, jr_005_425a

;>     wEntityY[slot] = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld [hl], a
;>     e += 1
	inc e

;> return e
jr_005_425a:
	ret


;@ def DrawBowWowChain(slot: bc)
;@ path: npc/bowwow
;@ Moves BowWow's chain links (BowWowChainFollow, BowWowDragChain) and draws links 1-5 as single
;@ 8x16 sprites (tile $7E at home, $4E elsewhere). Each link shows only every other frame, odd and
;@ even links taking turns, so the chain needs only 3 sprite entries a frame.
DrawBowWowChain::
;> BowWowChainFollow(slot)
	call BowWowChainFollow
;> BowWowDragChain(slot)
	call BowWowDragChain
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex      # the entities' part of the sprite table
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
	push hl
;>@loop for link in range(5, 0, -1):
	pop de
	push bc
	ld c, $05

;>     if (hFrameCounter ^ link) & 1 == 0:
jr_005_4270:
	ldh a, [hFrameCounter]
	xor c
	rra
	jr c, jr_005_4296

;>         mem[oam] = wSegmentY[link]
	ld hl, wSegmentY
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
;>         mem[oam + 1] = (wEntityWorkRAM2[link] + 4) & 0xFF
	ld hl, wEntityWorkRAM2
	add hl, bc
	ld a, [hl]
	add $04
	ld [de], a
	inc de
;>         mem[oam + 2] = 0x4E if wIsBowWowFollowingLink else 0x7E
	ld a, [wIsBowWowFollowingLink]
	and a
	ld a, $4e
	jr nz, jr_005_4290

	ld a, $7e

jr_005_4290:
	ld [de], a
;>         mem[oam + 3] = 0
	inc de
	ld a, $00
	ld [de], a
;>         oam += 4
	inc de

jr_005_4296:
;=@loop
	dec c
	jr nz, jr_005_4270

;> ReserveOAMEntriesFar(3)                      # reserve 3 sprite entries
	pop bc
	ld a, $03
	call ReserveOAMEntriesFar
	ret


;@ def BowWowLookForFood(slot: bc)
;@ path: npc/bowwow
;@ While following Link: searches the slots (from a random end) for an entity BowWow can eat (its
;@ type's byte in the table read by GetEntityTypeByte14 is nonzero) that is within 47 pixels of Link. If one is
;@ found, BowWow remembers it in wBowWowTargetSlot and jumps at it (speed $30, state 4). Otherwise
;@ it waits another $10 frames. Held in the Moblins' cave it never looks.
BowWowLookForFood::
;> if wIsBowWowFollowingLink == 0x80:
	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp z, Jump_005_4338

;>@wait     wEntityTimer[slot] = 0x10
;>@wait     return
;> if GetRandomByte() & 1 == 0:
	call GetRandomByte
	ld d, b
	and $01
	jr nz, jr_005_42b8

;>     other, step, end = 0x0F, -1, 0xFF  # search downwards
	ld e, $0f
	ld a, $ff
	ldh [hMultiPurpose0], a
	jr jr_005_42c0

;> else:
;>     other, step, end = 0, 1, 0x10      # search upwards
jr_005_42b8:
	ld e, $00
	ld a, $01
	ldh [hMultiPurpose0], a
	ld a, $10

jr_005_42c0:
	ldh [hMultiPurpose1], a

;>@search while other != end:
;>     if other == slot:
jr_005_42c2:
	ld a, e
	cp c
;>         pass
	jr z, jr_005_432c

;>     elif wEntityStatus[other] in (0, 1):   # free slot or dying
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_432c

	cp $01
;>         pass
	jr z, jr_005_432c

;>     elif wEntitySpriteVariant[other] == 1:
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [hl]
	dec a
;>         pass
	jr z, jr_005_432c

;>     elif GetEntityTypeByte14(wEntityType[other]) == 0:   # not something BowWow eats
	push de
	ld hl, wEntityType
	add hl, de
	ld e, [hl]
	call GetEntityTypeByte14
	pop de
;>         pass
	and a
	jr z, jr_005_432c

;>     elif (hLinkX - wEntityX[other] + 0x2F) & 0xFF >= 0x5E:   # too far from Link
	ld hl, wEntityX
	add hl, de
	ldh a, [hLinkX]
	sub [hl]
	add $2f
	cp $5e
;>         pass
	jr nc, jr_005_432c

;>     elif (hLinkY - wEntityY[other] + 0x2F) & 0xFF >= 0x5E:
	ld hl, wEntityY
	add hl, de
	ldh a, [hLinkY]
	sub [hl]
	add $2f
	cp $5e
;>         pass
	jr nc, jr_005_432c

;>     else:
;>         wBowWowTargetSlot = other
	ld a, e
	ld [wBowWowTargetSlot], a
;>         link_x, link_y = hLinkX, hLinkY
	ldh a, [hLinkY]
	push af
	ldh a, [hLinkX]
	push af
;>         hLinkY = wEntityY[other]       # aim at the target as if it were Link
	ld a, [hl]
	ldh [hLinkY], a
;>         hLinkX = wEntityX[other]
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
	ldh [hLinkX], a
;>         SetEntitySpeedTowardsLink(slot, 0x30)                # speed $30 towards it
	ld a, $30
	call SetEntitySpeedTowardsLink
;>         hLinkX = link_x
	pop af
	ldh [hLinkX], a
;>         hLinkY = link_y
	pop af
	ldh [hLinkY], a
;>         wEntitySpeedZ[slot] = 0x10
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $10
;>         wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>         return
	ret


;>     other = (other + step) & 0xFF
jr_005_432c:
	ld hl, hMultiPurpose0
	ld a, e
	add [hl]
	ld e, a
;=@search
	ld hl, hMultiPurpose1
	cp [hl]
	jr nz, jr_005_42c2

Jump_005_4338:
;=@wait
	call GetEntityTimer
	ld [hl], $10
;=@wait
	ret


;@ def BowWowBiteTarget(slot: bc)
;@ path: npc/bowwow
;@ BowWow's bite at the end of a lunge, if the target (wBowWowTargetSlot) still exists and is within
;@ reach of BowWow's mouth. Type $3D is not eaten: it shows text $115 instead (at most every $80
;@ frames, wEntityTimer2). Type $AD takes several bites: each makes it flash for $18 frames and
;@ counts up its wEntityPrivateCounter. Anything else is eaten (DefeatEntityWithDrop kills it).
BowWowBiteTarget::
;> other = wBowWowTargetSlot
	ld a, [wBowWowTargetSlot]
	ld e, a
	ld d, b
;> if wEntityStatus[other] == 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
;>     return
	ret z

;> if (hActiveEntityX - wEntityX[other] + 0x0E) & 0xFF >= 0x1A:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $0e
	cp $1a
;>     return
	ret nc

;> if (hActiveEntityDrawY - wEntityY[other] + 0x10) & 0xFF >= 0x20:
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $10
	cp $20
;>     return
	ret nc

;> if wEntityType[other] == 0x3D:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $3d
	jr nz, jr_005_4389

;>     if wEntityPrivate4[other] == 0:
	ld hl, wEntityPrivate4
	add hl, de
	ld a, [hl]
	and a
;>         return
	ret z

;>     if wDialogState:
	ld a, [wDialogState]
	and a
;>         return
	ret nz

;>     wEntityTimer[slot] = 0
	call GetEntityTimer
	ld [hl], b
;>     if wEntityTimer2[slot]:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
;>         return
	ret nz

;>     wEntityTimer2[slot] = 0x80
	ld [hl], $80
;>     OpenDialogTable1(0x15)             # text $115
;>     return
	ld a, $15
	jp OpenDialogTable1


;> if wEntityFlashTimer[other]:           # it was just bitten
jr_005_4389:
	ld hl, wEntityFlashTimer
	add hl, de
	ld a, [hl]
	and a
;>     return
	ret nz

;> hJingle = 3
	ld a, $03
	ldh [hJingle], a
;> if wEntityType[other] == 0xAD:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $ad
	jr nz, jr_005_43a9

;>     wEntityFlashTimer[other] = 0x18
	ld hl, wEntityFlashTimer
	add hl, de
	ld [hl], $18
;>     wEntityPrivateCounter[other] += 1
	ld hl, wEntityPrivateCounter
	add hl, de
	inc [hl]
;>     return
	ret


;> DefeatEntityWithDrop(other)                    # eaten: the entity dies
jr_005_43a9:
	push bc
	push de
	pop bc
	call DefeatEntityWithDrop
	pop bc
	ret


;@ def BowWowChainFollow(slot: bc)
;@ path: npc/bowwow
;@ Link 0 of the chain is BowWow itself (its drawn position). Each further link 1-5 that is more
;@ than 7 pixels away from the link before it moves 2 pixels towards it, on x and on y separately.
BowWowChainFollow::
;> wEntityWorkRAM2[0] = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ld [wEntityWorkRAM2], a
;> y = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
;> wSegmentY[0] = (y - wEntityZ[slot]) & 0xFF
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
	ld [wSegmentY], a
;>@fx for i in range(1, 6):
	ld de, wEntityWorkRAM2
	ld hl, wEntityWorkRAM2 + 1
	push bc
	ld c, $05

;>     d = (wEntityWorkRAM2[i - 1] - wEntityWorkRAM2[i] + 7) & 0xFF
jr_005_43cf:
	ld a, [de]
	sub [hl]
	add $07
;>     if d >= 0x0E:                     # more than 7 pixels apart
	cp $0e
	jr c, jr_005_43e1

;>         if d < 0x80:
	bit 7, a
	jr nz, jr_005_43df

;>             wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] + 4) & 0xFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

;>         wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] - 2) & 0xFF      # net: 2 pixels towards it
jr_005_43df:
	dec [hl]
	dec [hl]

jr_005_43e1:
;=@fx
	inc hl
	inc de
	dec c
	jr nz, jr_005_43cf

;>@fy for i in range(1, 6):
	ld de, wSegmentY
	ld hl, wSegmentY + 1
	ld c, $05

;>     d = (wSegmentY[i - 1] - wSegmentY[i] + 7) & 0xFF
jr_005_43ee:
	ld a, [de]
	sub [hl]
	add $07
;>     if d >= 0x0E:
	cp $0e
	jr c, jr_005_4400

;>         if d < 0x80:
	bit 7, a
	jr nz, jr_005_43fe

;>             wSegmentY[i] = (wSegmentY[i] + 4) & 0xFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

;>         wSegmentY[i] = (wSegmentY[i] - 2) & 0xFF
jr_005_43fe:
	dec [hl]
	dec [hl]

jr_005_4400:
;=@fy
	inc hl
	inc de
	dec c
	jr nz, jr_005_43ee

	pop bc
	ret


;@ def BowWowDragChain(slot: bc)
;@ path: npc/bowwow
;@ While BowWow follows Link and Link moves, the chain is pulled from Link's end: the anchor counts
;@ as link 6, and from link 5 down to link 0 (BowWow) each link more than 7 pixels from the next one
;@ moves 3 pixels towards it. If BowWow itself had to be dragged on one axis, the whole chain also
;@ moves 1 pixel towards the anchor on the other axis (it straightens out), and BowWow is put on
;@ link 0 (BowWowSnapToChainHead).
BowWowDragChain::
;> if wIsBowWowFollowingLink == 0:
	ld a, [wIsBowWowFollowingLink]
	and a
;>     return
	ret z

;> if wIsBowWowFollowingLink == 0x80:
	cp $80
;>     return
	ret z

;> if hLinkSpeedY | hLinkSpeedX | hLinkSpeedZ == 0:    # Link stands still
	ldh a, [hLinkSpeedY]
	ld hl, hLinkSpeedX
	or [hl]
	ld hl, hLinkSpeedZ
	or [hl]
;>     return
	jp z, Jump_005_44d3

;> wEntityWorkRAM2[6] = wEntityPrivate1[slot]       # the anchor is link 6
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld [wEntityWorkRAM2 + 6], a
;> wSegmentY[6] = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld [wSegmentY + 6], a
;> flags = 0
;>@dx for i in range(5, -1, -1):
	ld de, wEntityWorkRAM2 + 6
	ld hl, wEntityWorkRAM2 + 5
	push bc
	ld bc, $0006

;>     d = (wEntityWorkRAM2[i + 1] - wEntityWorkRAM2[i] + 7) & 0xFF
jr_005_4436:
	ld a, [de]
	sub [hl]
	add $07
;>     if d >= 0x0E:
	cp $0e
	jr c, jr_005_4451

;>         if d < 0x80:
	bit 7, a
	jr nz, jr_005_4448

;>             wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] + 6) & 0xFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

;>         wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] - 3) & 0xFF      # net: 3 pixels towards it
jr_005_4448:
	dec [hl]
	dec [hl]
	dec [hl]
;>         if i == 0:
	ld a, c
	cp $01
	jr nz, jr_005_4451

;>             flags |= 1                # BowWow was dragged on x
	inc b

jr_005_4451:
;=@dx
	dec hl
	dec de
	dec c
	jr nz, jr_005_4436

;>@dy for i in range(5, -1, -1):
	ld de, wSegmentY + 6
	ld hl, wSegmentY + 5
	ld c, $06

;>     d = (wSegmentY[i + 1] - wSegmentY[i] + 7) & 0xFF
jr_005_445e:
	ld a, [de]
	sub [hl]
	add $07
;>     if d >= 0x0E:
	cp $0e
	jr c, jr_005_447c

;>         if d < 0x80:
	bit 7, a
	jr nz, jr_005_4470

;>             wSegmentY[i] = (wSegmentY[i] + 6) & 0xFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

;>         wSegmentY[i] = (wSegmentY[i] - 3) & 0xFF
jr_005_4470:
	dec [hl]
	dec [hl]
	dec [hl]
;>         if i == 0:
	ld a, c
	cp $01
	jr nz, jr_005_447c

;>             flags |= 2                # BowWow was dragged on y
	ld a, b
	or $02
	ld b, a

jr_005_447c:
;=@dy
	dec hl
	dec de
	dec c
	jr nz, jr_005_445e

;> hMultiPurpose0 = flags
	ld a, b
	ldh [hMultiPurpose0], a
	pop bc
;> if flags & 1:
	and $01
	jr z, jr_005_44a2

;>@sy     for i in range(6):           # straighten the chain on y
	ld hl, wSegmentY
	ld e, $06

;>         d = (wBowWowAnchorY - wSegmentY[i]) & 0xFF
jr_005_448e:
	ld a, [wBowWowAnchorY]
	sub [hl]
;>         if d != 0:
	jr z, jr_005_449b

;>             if d < 0x80:
	bit 7, a
	jr nz, jr_005_449a

;>                 wSegmentY[i] = (wSegmentY[i] + 2) & 0xFF
	inc [hl]
	inc [hl]

;>             wSegmentY[i] = (wSegmentY[i] - 1) & 0xFF
jr_005_449a:
	dec [hl]

jr_005_449b:
;=@sy
	inc hl
	dec e
	jr nz, jr_005_448e

;>     BowWowSnapToChainHead(slot)
	call BowWowSnapToChainHead

;> if hMultiPurpose0 & 2:
jr_005_44a2:
	ldh a, [hMultiPurpose0]
	and $02
	jr z, jr_005_44d3

;>@sx     for i in range(6):           # straighten the chain on x
	ld hl, wEntityWorkRAM2
	ld e, $06

;>         d = (wBowWowAnchorX - wEntityWorkRAM2[i]) & 0xFF
jr_005_44ad:
	ld a, [wBowWowAnchorX]
	sub [hl]
;>         if d != 0:
	jr z, jr_005_44ba

;>             if d < 0x80:
	bit 7, a
	jr nz, jr_005_44b9

;>                 wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] + 2) & 0xFF
	inc [hl]
	inc [hl]

;>             wEntityWorkRAM2[i] = (wEntityWorkRAM2[i] - 1) & 0xFF
jr_005_44b9:
	dec [hl]

jr_005_44ba:
;=@sx
	inc hl
	dec e
	jr nz, jr_005_44ad

;>     BowWowSnapToChainHead(slot)     # runs on into it

;@ def BowWowSnapToChainHead(slot: bc)
;@ path: npc/bowwow
;@ Puts BowWow on chain link 0 (its y is the link's drawn y plus its height).
BowWowSnapToChainHead::
;> y = (wSegmentY[0] + wEntityZ[slot]) & 0xFF
	ld a, [wSegmentY]
	ld hl, wEntityZ
	add hl, bc
	add [hl]
;> wEntityY[slot] = y
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityX[slot] = wEntityWorkRAM2[0]
	ld a, [wEntityWorkRAM2]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a

Jump_005_44d3:
jr_005_44d3:
	ret


;@ def SetBowWowSpriteFromSpeed(slot: bc)
;@ path: npc/bowwow
;@ Picks BowWow's sprite variant from its speed (none when it stands): the faster axis decides the
;@ facing; down (0-1), left (2-3) and right (4-5) alternate two frames every 8 frames, up is 6.
SetBowWowSpriteFromSpeed::
;> if wEntitySpeedX[slot] | wEntitySpeedY[slot] == 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	or [hl]
;>     return
	ret z

;> sx = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld d, a
;> ax = (-sx) & 0xFF if sx & 0x80 else sx
	bit 7, a
	jr z, jr_005_44eb

	cpl
	inc a

jr_005_44eb:
	ld e, a
;> sy = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;> ay = (-sy) & 0xFF if sy & 0x80 else sy
	bit 7, a
	jr z, jr_005_44f7

	cpl
	inc a

;> if ay < ax:                         # moving sideways
jr_005_44f7:
	cp e
	jr nc, jr_005_4508

;>     if sx & 0x80 == 0:
	bit 7, d
	jr nz, jr_005_4502

;>         SetTwoFrameSpriteVariant_05(4)   # right
;>         return
	ld e, $04
	jr SetTwoFrameSpriteVariant_05

;>     SetTwoFrameSpriteVariant_05(2)       # left
;>     return
jr_005_4502:
	ld e, $02
	call SetTwoFrameSpriteVariant_05
	ret


;> if sy & 0x80:                       # moving up
jr_005_4508:
	bit 7, [hl]
	jr z, jr_005_4511

;>     SetEntitySpriteVariant(slot, 6)                    # wEntitySpriteVariant = 6
;>     return
	ld a, $06
	jp SetEntitySpriteVariant


;> SetTwoFrameSpriteVariant_05(0)       # down
jr_005_4511:
	ld e, $00

;@ def SetTwoFrameSpriteVariant_05(slot: bc, base: e)
;@ path: entity/sprite
;@ Sets the entity's sprite variant to base or base + 1, switching every 8 frames (a two-frame
;@ walking animation).
SetTwoFrameSpriteVariant_05::
;> frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, base + frame)            # wEntitySpriteVariant
	add e
	jp SetEntitySpriteVariant


;@ path: npc/cucco
;@ The cucco's sprites: 4 variants of 4 bytes for DrawEntity16x16 (tile and attributes of the left 8x16
;@ half, then of the right half; attribute $20 = mirrored). 0-1 walking / flapping facing left,
;@ 2-3 the same facing right (mirrored).
CuccoSprites::
	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

;@ def CuccoEntityHandler(slot: bc)
;@ path: npc/cucco
;@ Entity handler of the cucco (type $6C), the village chicken. It wanders in little hops. Link can
;@ lift and carry it with the Power Bracelet (it flaps and clucks). Hit, it flees from Link; after
;@ 35 hits (wEntityPrivate1) on the overworld it calls a flock of revenge cuccos that fly in from
;@ the screen edges at Link. If Marin walks with Link she comments on the hits.
CuccoEntityHandler::
;> wEntityHealth[slot] = 0x4C              # topped up every frame: it cannot be killed
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $4c
;> if wEntityDirection[slot] == 0:         # facing right: the mirrored frames
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_4542

;>     hActiveEntitySpriteVariant += 2
	ldh a, [hActiveEntitySpriteVariant]
	add $02
	ldh [hActiveEntitySpriteVariant], a

;> DrawEntity16x16(slot, CuccoSprites)
jr_005_4542:
	ld de, CuccoSprites
	call DrawEntity16x16
;> if hActiveEntityStatus == 7:            # carried by Link
	ldh a, [hActiveEntityStatus]
	cp $07
	jr nz, jr_005_4561

;>     if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_4558

;>         hWaveSfx = 0x13                 # cluck
	ld a, $13
	ldh [hWaveSfx], a

;>     SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)  # flap its wings
;>     return
jr_005_4558:
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	jp SetEntitySpriteVariant


;> if ReturnIfNonInteractive_05():
jr_005_4561:
	call ReturnIfNonInteractive_05
;>     return
;> EntityCheckWeaponHits(slot)                            # the sword can hit it
	call EntityCheckWeaponHits
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if hActiveEntityState != 3:            # revenge cuccos fly level
	ldh a, [hActiveEntityState]
	cp $03
	jr z, jr_005_458a

;>     AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;>     wEntitySpeedZ[slot] = (wEntitySpeedZ[slot] - 1) & 0xFF
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;>     hBGTilesRequestCopy = wEntityZ[slot] & 0x80     # scratch: just landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;>     if hBGTilesRequestCopy:
	jr z, jr_005_458a

;>         wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>         wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a

;> if wEntityFlashTimer[slot]:             # it was hit
jr_005_458a:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_45c9

;>     if wEntityFlashTimer[slot] == 8:
	cp $08
	jr nz, jr_005_45c1

;>         if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_005_45b7

;>             wEntityFlashTimer[slot] -= 1
	dec [hl]
;>             if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_005_45b7

;>                 if GetRandomByte() & 0x3F == 0:
	call GetRandomByte
	and $3f
	jr nz, jr_005_45b2

;>                     OpenDialogTable2(0x76)   # Marin's rare remark, text $276
	ld a, $76
	call OpenDialogTable2
	jr jr_005_45b7

;>                 else:
;>                     OpenDialog(0x8F)         # text $08F
jr_005_45b2:
	ld a, $8f
	call OpenDialog

;>         if wEntityPrivate1[slot] != 0x23:   # count the hits, up to 35
jr_005_45b7:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $23
	jr z, jr_005_45c1

;>             wEntityPrivate1[slot] += 1
	inc [hl]

;>     wEntityState[slot] = 2              # angry: flee
jr_005_45c1:
	call IncrementEntityState
	ld a, $02
	ld [hl], a
;>     hActiveEntityState = 2
	ldh [hActiveEntityState], a

;> if EntityTouchesLink(slot):                        # Link touches it
jr_005_45c9:
	call EntityTouchesLink
	jr nc, jr_005_461b

;>     if hActiveEntityState != 3:
	ldh a, [hActiveEntityState]
	cp $03
	jr z, jr_005_461b

;>         if wItemUsePoseTimer == 0:
	ld a, [wItemUsePoseTimer]
	and a
	jr nz, jr_005_461b

;>             lift = False
;>             if wItemB == 3:             # Power Bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, jr_005_45e9

;>                 lift = hJoypadPressed & 0x20
	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_005_45f6

	jr jr_005_461b

;>             elif wItemA == 3:
jr_005_45e9:
	ld a, [wItemA]
	cp $03
	jr nz, jr_005_461b

;>                 lift = hJoypadPressed & 0x10
	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_005_461b

;>             if lift and wLinkIsCarrying == 0:
jr_005_45f6:
	ld a, [wLinkIsCarrying]
	and a
	jr nz, jr_005_461b

;>                 wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;>                 wEntityStatus[slot] = 7     # lifted
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;>                 wEntityLiftStep[slot] = 0
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
;>                 wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
;>                 wEntityTimer[slot] = 2
	call GetEntityTimer
	ld [hl], $02
;>                 hWaveSfx = 2
	ld hl, hWaveSfx
	ld [hl], $02
;>                 return
	ret


;> CuccoStates[hActiveEntityState](slot)
jr_005_461b:
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/cucco
;@ The cucco's states (wEntityState): 0 idle, 1 hopping, 2 angry (fleeing from Link), 3 revenge
;@ cucco flying at Link.
CuccoStates::
	dw CuccoIdleState
	dw CuccoHopState
	dw CuccoAngryState
	dw CuccoRevengeState

;@ path: npc/cucco
;@ Speeds for a cucco's hop (signed, 1/16 pixel per frame): CuccoIdleState picks the x speed and the
;@ y speed with two separate random indices 0-7. Indices 0-3 are 0 or positive, 4-7 0 or negative.
CuccoHopSpeeds::
	db $00, $04, $06, $04, $00, $fc, $fa, $fc

;@ def CuccoIdleState(slot: bc)
;@ path: npc/cucco
;@ State 0: stands (variant 0) until wEntityTimer runs out, then picks a random hop: x and y speed
;@ from CuccoHopSpeeds, facing from the x index (0-3 right, 4-7 left), 48-79 frames, state 1.
CuccoIdleState::
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, jr_005_466e

;> i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = CuccoHopSpeeds[i]
	ld hl, CuccoHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntityDirection[slot] = i & 4         # 0 = facing right
	ld a, e
	and $04
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> i = GetRandomByte() & 7
	call GetRandomByte
	and $07
	ld e, a
;> wEntitySpeedY[slot] = CuccoHopSpeeds[i]
	ld hl, CuccoHopSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;> wEntityState[slot] += 1
	call IncrementEntityState

jr_005_466e:
	ret


;@ def CuccoHopState(slot: bc)
;@ path: npc/cucco
;@ State 1: moves with its speed in small hops (height speed 5 each time it lands) until
;@ wEntityTimer has run out at a landing; then it stands for $30 frames (state 0). Walks with
;@ variants 0/1 every 8 frames.
CuccoHopState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if hBGTilesRequestCopy:                 # landed this frame
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_005_4691

;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, jr_005_4686

;>         wEntityTimer[slot] = 0x30
	ld [hl], $30
;>         wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>         return
	ret


;>     wEntitySpeedZ[slot] = 5             # next hop
jr_005_4686:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $05
;>     wEntityZ[slot] += 1
	ld hl, wEntityZ
	add hl, bc
	inc [hl]

;> frame = (hFrameCounter >> 3) & 1
jr_005_4691:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ path: npc/cucco
;@ x positions of the 16 points revenge cuccos start from (indexed with CuccoRevengeSpawnY by a
;@ random number 0-15): 0-3 along the top edge, 4-7 along the bottom edge, 8-11 on the left edge
;@ (x 0), 12-15 on the right edge (x $A0).
CuccoRevengeSpawnX::
	db $28, $48, $68, $88, $18, $38, $58, $78, $00, $00, $00, $00, $a0, $a0, $a0, $a0
;@ path: npc/cucco
;@ y positions of the 16 revenge cucco start points (see CuccoRevengeSpawnX): 0-3 y 0 (top edge),
;@ 4-7 y $90 (bottom edge), 8-15 y $20-$80 down the side edges.
CuccoRevengeSpawnY::
	db $00, $00, $00, $00, $90, $90, $90, $90, $20, $40, $60, $80, $20, $40, $60, $80

;@ def CuccoAngryState(slot: bc)
;@ path: npc/cucco
;@ State 2, after a hit: on the ground, every 32 frames it turns to run away from Link (speed $0C),
;@ flapping fast and facing away from him. After 35 hits, outdoors, every 16 frames it summons a
;@ revenge cucco (another type $6C in state 3) at a random screen-edge point, flying at Link with
;@ speed $18.
CuccoAngryState::
;> z = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
;> if (hFrameCounter ^ slot) & 0x1F == 0 and z == 0:
	ldh a, [hFrameCounter]
	xor c
	and $1f
	or [hl]
	jr nz, jr_005_46df

;>     GetVectorTowardsLink(slot, 0x0C)                     # vector of speed $0C towards Link
	ld a, $0c
	call GetVectorTowardsLink
;>     wEntitySpeedY[slot] = (-hMultiPurpose0) & 0xFF     # ... reversed: away from him
	ldh a, [hMultiPurpose0]
	cpl
	inc a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = (-hMultiPurpose1) & 0xFF
	ldh a, [hMultiPurpose1]
	cpl
	inc a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_46df:
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> wEntityDirection[slot] = EntityLinkDiffX_05(slot) ^ 1     # face away from Link
	call EntityLinkDiffX_05
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	xor $01
	ld [hl], a
;> if wEntityPrivate1[slot] == 0x23:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $23
	jr nz, jr_005_475a

;>     if hFrameCounter & 0x0F == 0 and not wIsIndoor:
	ld hl, wIsIndoor
	ldh a, [hFrameCounter]
	and $0f
	or [hl]
	jr nz, jr_005_475a

;>         new = SpawnEntityFromSlot(0x6C, 7)        # spawn a cucco in slots 0-7 (carry: none free)
	ld a, $6c
	ld e, $07
	call SpawnEntityFromSlot
;>         if new is not None:
	jr c, jr_005_475a

;>             hWaveSfx = 0x13
	ld a, $13
	ldh [hWaveSfx], a
;>             wEntityState[new] = 3       # revenge cucco
	ld hl, wEntityState
	add hl, de
	ld [hl], $03
;>             wEntityZ[new] = 0x10
	ld hl, wEntityZ
	add hl, de
	ld [hl], $10
;>             wEntityPhysicsFlags[new] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;>             wEntityHitboxFlags[new] = 0x80
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $80
;>             wEntityOptions1[new] = 0x40
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $40
;>             p = GetRandomByte() & 0x0F
	push bc
	call GetRandomByte
	and $0f
	ld c, a
;>             wEntityX[new] = CuccoRevengeSpawnX[p]
	ld hl, CuccoRevengeSpawnX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[new] = CuccoRevengeSpawnY[p]
	ld hl, CuccoRevengeSpawnY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             SetEntitySpeedTowardsLink(slot, 0x18)             # (for the new cucco) speed $18 towards Link
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc

jr_005_475a:
	ret


;@ def CuccoRevengeState(slot: bc)
;@ path: npc/cucco
;@ State 3, a revenge cucco: flies straight on through walls, hurts Link when it touches him and
;@ disappears once it leaves the screen. Flaps every 4 frames and makes a noise.
CuccoRevengeState::
;> EntityCheckContactDamage(slot)                            # hurts Link on contact
	call EntityCheckContactDamage
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if hActiveEntityX >= 0xA9 or hActiveEntityDrawY >= 0x91:   # off screen
	ldh a, [hActiveEntityX]
	cp $a9
	jp nc, ClearEntityStatus_05

	ldh a, [hActiveEntityDrawY]
	cp $91
;>     ClearEntityStatus_05(slot)
;>     return
	jp nc, ClearEntityStatus_05

;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> e = 0
	ld e, $00
;> if wEntitySpeedX[slot] & 0x80:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_4784

;>     e = 1
	inc e

;> wEntityDirection[slot] = e             # 1 = flying left
jr_005_4784:
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> PlayPeriodicNoiseSfx()                            # noise effect $2D
	jp PlayPeriodicNoiseSfx


	db $c9                               ; a stray `ret` byte, never reached

;@ path: npc/witch
;@ The witch's sprites: 4 variants of 4 sprites for DrawEntitySprites, each sprite 4 bytes: y offset, x offset,
;@ tile, attributes ($20 = mirrored). A 16x32 figure stirring her pot: variant 0 and its mirror 2,
;@ with 1 and 3 (the same picture) between them.
WitchSprites::
	db $f0, $00, $60, $00,  $f0, $08, $62, $00,  $00, $00, $64, $00,  $00, $08, $66, $00
	db $f0, $00, $68, $00,  $f0, $08, $6a, $00,  $00, $00, $6c, $00,  $00, $08, $6e, $00
	db $f0, $00, $62, $20,  $f0, $08, $60, $20,  $00, $00, $66, $20,  $00, $08, $64, $20
	db $f0, $00, $68, $00,  $f0, $08, $6a, $00,  $00, $00, $6c, $00,  $00, $08, $6e, $00

;@ def DrawWitch()
;@ path: npc/witch
;@ Draws the witch: the 4 sprites of her current variant in WitchSprites.
DrawWitch::
;>@draw DrawEntitySprites(4, WitchSprites + 16 * hActiveEntitySpriteVariant)
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;=@draw
	ld e, a
	ld d, b
	ld hl, WitchSprites
	add hl, de
	ld c, $04
	call DrawEntitySprites
;=@draw
	ret


;@ def WitchEntityHandler(slot: bc)
;@ path: npc/witch
;@ Entity handler of the witch (type $40) in her hut: she stirs her pot (a new picture every 16
;@ frames), blocks Link like a wall and turns the Sleepy Toadstool into magic powder.
WitchEntityHandler::
;> DrawWitch()
	call DrawWitch
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@anim SetEntitySpriteVariant(slot, (wEntityPrivateCounter[slot] >> 4) & 3)
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $03
;=@anim
	call SetEntitySpriteVariant
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> WitchStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/witch
;@ The witch's states (wEntityState): 0 waiting for the toadstool, 1 short pause, 2 brewing,
;@ 3 handing over the powder, 4 done.
WitchStates::
	dw WitchWaitForToadstoolState
	dw WitchStartBrewingState
	dw WitchBrewingState
	dw WitchGivePowderState
	dw WitchDoneState

;@ def WitchWaitForToadstoolState(slot: bc)
;@ path: npc/witch
;@ State 0. If Link carries the toadstool and stands in front of her with it on B or A, pressing
;@ that button hands it over (the item slot is emptied, wHasToadstool cleared) and she starts
;@ (state 1 after 4 frames). Otherwise talking to her (A) shows text $00C.
WitchWaitForToadstoolState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_4844

;> if wHasToadstool:
	ld a, [wHasToadstool]
	and a
	jr z, jr_005_483b

;>     talk, in_front = ShouldLinkTalkToEntity_05()
	call ShouldLinkTalkToEntity_05
;>     if not in_front:
	ld a, e
	and a
;>         return
	jr z, jr_005_4844

;>     if wItemB == 0x0C:                  # toadstool on B
	ld hl, wItemB
	ld a, [hl]
	cp $0c
	jr nz, jr_005_482d

;>         if hJoypadPressed & 0x20 == 0:
	ldh a, [hJoypadPressed]
	and $20
;>             return
	jr z, jr_005_4844

;>         wLinkShowItemPose = 0
	xor a
	ld [wLinkShowItemPose], a
;>         wLinkShowItemPoseActive = 0
	ld [wLinkShowItemPoseActive], a
;>@give         wItemB = 0
	jr jr_005_4838

;>     elif wItemA == 0x0C:                # toadstool on A
jr_005_482d:
	inc hl
	ld a, [hl]
	cp $0c
	jr nz, jr_005_483b

;>         if hJoypadPressed & 0x10 == 0:
	ldh a, [hJoypadPressed]
	and $10
;>             return
	ret z

;>@give         wItemA = 0
jr_005_4838:
;=@give
	ld [hl], b
	jr jr_005_4845

;>@talk     else:
;>@talk         if ShouldLinkTalkToEntity_05():
;>@talk             OpenDialog(0x0C)        # text $00C
;>@talk         return
;>@talk     wHasToadstool = 0
;>@talk     wEntityTimer[slot] = 4
;>@talk     wEntityState[slot] += 1
;>@talk     return
;> elif ShouldLinkTalkToEntity_05():
jr_005_483b:
;=@talk
	call ShouldLinkTalkToEntity_05
	ret nc

;>     OpenDialog(0x0C)                    # text $00C
	ld a, $0c
	call OpenDialog

jr_005_4844:
	ret


jr_005_4845:
;=@talk
	xor a
	ld [wHasToadstool], a
;=@talk
	call GetEntityTimer
	ld [hl], $04
;=@talk
	jp IncrementEntityState


;@ def WitchStartBrewingState(slot: bc)
;@ path: npc/witch
;@ State 1: when wEntityTimer has run out, text $009 and $C0 frames of brewing (state 2).
WitchStartBrewingState::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz

;> OpenDialog(0x09)                       # text $009
	ld a, $09
	call OpenDialog
;> wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def WitchBrewingState(slot: bc)
;@ path: npc/witch
;@ State 2, once the text is closed: the area music restarts at double speed, Link cannot move and
;@ she stirs 5 times as fast, until wEntityTimer runs out; then normal music, text $0FE, state 3.
WitchBrewingState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_4897

;> if wMusicSpeed == 0:
	ld a, [wMusicSpeed]
	and a
	jr nz, jr_005_4879

;>     wMusicTrackToPlay = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld [wMusicTrackToPlay], a
;>     wMusicSpeed = 1                     # music updated twice a frame
	ld a, $01
	ld [wMusicSpeed], a

;> hLinkInteractiveMotionBlocked = wMusicSpeed
jr_005_4879:
	ldh [hLinkInteractiveMotionBlocked], a
;> wEntityPrivateCounter[slot] = (wEntityPrivateCounter[slot] + 4) & 0xFF   # stir faster
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz

;> wMusicSpeed = 0
	ld [wMusicSpeed], a
;> wMusicTrackToPlay = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld [wMusicTrackToPlay], a
;> OpenDialog(0xFE)                       # text $0FE
	ld a, $fe
	call OpenDialog
;> wEntityState[slot] += 1
	call IncrementEntityState

jr_005_4897:
	ret


;@ def WitchGivePowderState(slot: bc)
;@ path: npc/witch
;@ State 3, after the text: Link holds up the magic powder (pose 3 for $2A frames), gets the powder
;@ item ($0C) and 20 doses, with a jingle; state 4.
WitchGivePowderState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	ret nz

;> wLinkShowItemTimer = 0x2A
	ld a, $2a
	ld [wLinkShowItemTimer], a
;> wLinkShowItemPose = 3
	ld a, $03
	ld [wLinkShowItemPose], a
;> GiveInventoryItem_05(0x0C)             # magic powder
	ld d, $0c
	call GiveInventoryItem_05
;> wMagicPowderCount = bcd_add(wMagicPowderCount, 0x20)
	ld a, [wMagicPowderCount]
	add $20
	daa
	ld [wMagicPowderCount], a
;> hBGChangeRequest = 0x0B
	ld a, $0b
	ldh [hBGChangeRequest], a
;> hJingle = 1
	ld a, $01
	ldh [hJingle], a
;> wEntityState[slot] += 1
	call IncrementEntityState

;@ def WitchDoneState(slot: bc)
;@ path: npc/witch
;@ State 4: nothing more to do.
WitchDoneState::
;> return
	ret


;@ path: npc/tarin
;@ Sprites of the raccoon (Tarin under the mushroom's spell) for DrawEntity16x16: 8 variants of 4 bytes
;@ (tile and attributes of the left 8x16 half, then of the right half; $20 = mirrored).
;@ 0-1 sitting (the picture flips), 2-3 alarmed, 4-7 the four steps of its spin. Variants 8-12 run
;@ on into TarinStandingSprites and TarinSleepingSprite (Tarin himself after the spell breaks).
TarinSprites::
	db $78, $00, $7a, $00,  $7a, $20, $78, $20,  $7c, $00, $7e, $00,  $78, $00, $7a, $00
	db $70, $00, $72, $00,  $74, $00, $76, $00,  $76, $20, $74, $20,  $72, $20, $70, $20
;@ path: npc/tarin
;@ Tarin standing, one variant per facing (DrawEntity16x16 format): 0 right, 1 left, 2 up, 3 down (up and
;@ down use the same picture).
TarinStandingSprites::
	db $5a, $20, $58, $20,  $58, $00, $5a, $00,  $50, $00, $52, $00,  $50, $00, $52, $00
;@ path: npc/tarin
;@ Tarin lying asleep in his bed (one DrawEntity16x16 variant).
TarinSleepingSprite::
	db $54, $00, $56, $00

;@ path: npc/tarin
;@ The ending picture of this character, first form: 4 sprites for DrawEntitySprites (y offset, x offset, tile,
;@ attributes). The same 16x16 picture (tiles $20/$22) is listed twice.
TarinEndingSprites1::
	db $00, $00, $20, $00,  $00, $08, $22, $00,  $00, $00, $20, $00,  $00, $08, $22, $00

;@ path: npc/tarin
;@ The ending picture, second form (after $70 frames): tile $2A twice above (the second mirrored),
;@ tiles $24/$28 below. DrawEntitySprites format as TarinEndingSprites1.
TarinEndingSprites2::
	db $f1, $fa, $2a, $00,  $f1, $02, $2a, $20,  $00, $00, $24, $00,  $00, $08, $28, $00

;@ def TarinEntityHandler(slot: bc)
;@ path: npc/tarin
;@ Entity handler of type $3F: Tarin. In the ending it shows TarinEndingSprites1, then 2. Indoors it
;@ is Tarin at home (TarinIndoors). On the overworld it is the raccoon in the forest, gone for good
;@ once its room has bit 4 set: it sits and twitches, and when Link walks up past it (y < $30) it gets
;@ alarmed and makes the next exit upwards loop back (wRaccoonLoopsExit). Magic powder (state 1)
;@ makes it spin and bounce around until the spell breaks and Tarin drops down (states 2-3).
TarinEntityHandler::
;> if wGameplayType == 1:                # the ending
	ld a, [wGameplayType]
	cp $01
	jr nz, jr_005_4940

;>     wEntityPhysicsFlags[slot] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c4
;>     sprites = TarinEndingSprites1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld hl, TarinEndingSprites1
;>     if wEntityPrivateCounter[slot] == 0x70:
	cp $70
	jr nz, jr_005_4931

;>         sprites = TarinEndingSprites2
	ld hl, TarinEndingSprites2

;>     DrawEntitySprites(4, sprites)
jr_005_4931:
	ld c, $04
	call DrawEntitySprites
;>     if wEntityPrivateCounter[slot] != 0x70:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $70
	ret z

;>         wEntityPrivateCounter[slot] += 1
	inc [hl]
;>     return
	ret


;> if wIsIndoor:
jr_005_4940:
	ld a, [wIsIndoor]
	and a
;>     TarinIndoors(slot)
;>     return
	jp nz, TarinIndoors

;> if hRoomStatus & 0x10:                # the spell was broken here already
	ldh a, [hRoomStatus]
	and $10
;>     ClearEntityStatus_05(slot)
;>     return
	jp nz, ClearEntityStatus_05

;> if hActiveEntityState == 0:
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_005_497c

;>@sit     SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@sit
	call SetEntitySpriteVariant
;>     if hLinkY < 0x30:                 # Link walks past it
	ldh a, [hLinkY]
	cp $30
	jr nc, jr_005_4977

;>         wRaccoonLoopsExit = 1
	ld a, $01
	ld [wRaccoonLoopsExit], a
;>         frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;>         SetEntitySpriteVariant(slot, frame + 2)          # alarmed
	add $02
	call SetEntitySpriteVariant
	jr jr_005_497c

;>     else:
;>         wEntityPrivate4[slot] = 0     # its remark may come again
jr_005_4977:
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b

;> DrawEntity16x16(slot, TarinSprites)
jr_005_497c:
	ld de, TarinSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>     return
;> RaccoonStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/tarin
;@ States of the raccoon / Tarin outdoors (wEntityState): 0 raccoon sitting, 1 spinning after the
;@ magic powder, 2 Tarin falling down, 3 Tarin cured.
RaccoonStates::
	dw RaccoonIdleState
	dw RaccoonSpinState
	dw TarinFallState
	dw TarinCuredState

;@ def RaccoonIdleState(slot: bc)
;@ path: npc/tarin
;@ State 0: the raccoon blocks the way. When Link gets above y $20 it says text $021 once (until he
;@ walks back down); talking to it shows text $00D.
RaccoonIdleState::
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> if hLinkY < 0x20:
	ldh a, [hLinkY]
	cp $20
	jr nc, jr_005_49a8

;>     if wEntityPrivate4[slot] == 0:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_49a8

;>         wEntityPrivate4[slot] = 1
	ld [hl], $01
;>         OpenDialog(0x21)              # text $021
;>         return
	ld a, $21
	jp OpenDialog


;> if ShouldLinkTalkToEntity_05():
jr_005_49a8:
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_49b7

;>     if wItemUsePoseTimer:
	ld a, [wItemUsePoseTimer]
	and a
;>         return
	ret nz

;>     OpenDialog(0x0D)                  # text $00D
;>     return
	ld a, $0d
	jp OpenDialog


;> wCanTalkToEntity = 0
jr_005_49b7:
	ld hl, wCanTalkToEntity
	ld [hl], b
	ret


;@ path: npc/tarin
;@ The raccoon's spin: the sprite variants (TarinSprites) of its 6 spin steps, in order.
RaccoonSpinFrames::
	db $00, $04, $05, $06, $07, $01

;@ def RaccoonSpinState(slot: bc)
;@ path: npc/tarin
;@ State 1, set when magic powder hits the raccoon (its wEntityDropTimer then runs): Link stands
;@ still facing it. It spins ever faster (wEntityPrivate3 is added to the phase wEntityPrivate2; each
;@ overflow is a spin step) and bounces off the walls with speeds that grow up to $30, then slows down
;@ near the end. When the drop timer runs out an entity of type $02 is spawned at its place, it
;@ turns into Tarin (variant 9), the room gets bit 4 and wTarinState becomes 1.
RaccoonSpinState::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
;> hLinkDirection = GetEntityDirectionToLink_05(slot) ^ 1    # Link faces it
	call GetEntityDirectionToLink_05
	ld a, e
	xor $01
	ldh [hLinkDirection], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;> speed = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
;> phase = wEntityPrivate2[slot] + speed
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	add e
;> wEntityPrivate2[slot] = phase & 0xFF
	ld [hl], a
;> if phase > 0xFF:                      # next spin step
	jr nc, jr_005_49f1

;>     step = wEntityPrivate5[slot] + 1
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	inc a
;>     if step == 6:
	cp $06
	jr nz, jr_005_49f0

;>         step = 0
	xor a

;>     wEntityPrivate5[slot] = step
jr_005_49f0:
	ld [hl], a

;>@spin SetEntitySpriteVariant(slot, RaccoonSpinFrames[wEntityPrivate5[slot]])
jr_005_49f1:
	ld hl, wEntityPrivate5
	add hl, bc
	ld e, [hl]
	ld d, b
;=@spin
	ld hl, RaccoonSpinFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;> if GetEntityDropTimer(slot) == 0:         # the spell breaks
	call GetEntityDropTimer
	jr nz, jr_005_4a49

;>     new = SpawnEntity(0x02)             # an entity of type $02 at its place
	ld a, $02
	call SpawnEntity
;>     wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[new] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>     wEntityPrivate4[new] = 0x4C
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $4c
;>     wEntityTimer[new] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;>     SetEntitySpriteVariant(slot, 9)                      # now Tarin
	ld a, $09
	call SetEntitySpriteVariant
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>@room     wRoomStatus[hMapRoom] |= 0x10
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld hl, wRoomStatus
	add hl, de
;=@room
	ld a, [hl]
	or $10
	ld [hl], a
;>     wTarinState = 1
	ld a, $01
	ld [wTarinState], a
;>     return
	ret


;> if hFrameCounter & 1 == 0:
jr_005_4a49:
	ld hl, wEntityPrivate3
	add hl, bc
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_005_4a59

;>     if wEntityPrivate3[slot] < 0xF0:
	ld a, [hl]
	cp $f0
	jr nc, jr_005_4a59

;>         wEntityPrivate3[slot] += 1    # spin faster
	inc [hl]

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_4a59:
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> t = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if t < 6:                              # the end of the spin
	cp $06
	jr nc, jr_005_4a97

;>     if hActiveEntityY < 0x30:         # not before it is low enough on the screen
	ldh a, [hActiveEntityY]
	cp $30
	jr nc, jr_005_4a70

;>         wEntityDropTimer[slot] = 8
	ld [hl], $08
	jr jr_005_4a97

;>     else:
;>         wEntitySpeedZ[slot] += 1      # rise
jr_005_4a70:
	ld hl, wEntitySpeedZ
	add hl, bc
	inc [hl]
	nop
;>         if wEntitySpeedX[slot] != 0:  # slow down by 1 towards 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4a85

;>             if wEntitySpeedX[slot] & 0x80:
	and $80
	jr z, jr_005_4a84

;>                 wEntitySpeedX[slot] += 2
	inc [hl]
	inc [hl]

;>             wEntitySpeedX[slot] -= 1
jr_005_4a84:
	dec [hl]

;>         if wEntitySpeedY[slot] != 0:
jr_005_4a85:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4a94

;>             if wEntitySpeedY[slot] & 0x80:
	and $80
	jr z, jr_005_4a93

;>                 wEntitySpeedY[slot] += 2
	inc [hl]
	inc [hl]

;>             wEntitySpeedY[slot] -= 1
jr_005_4a93:
	dec [hl]

;>         AddEntityZSpeedToPos_05(slot)
;>         return
jr_005_4a94:
	jp AddEntityZSpeedToPos_05


;> if wEntityCollisions[slot] & 0x03:     # hit a wall left or right: bounce
jr_005_4a97:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_005_4aac

;>     wEntitySpeedX[slot] = (-wEntitySpeedX[slot]) & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     hJingle = 9
	ld a, $09
	ldh [hJingle], a

;> if wEntityCollisions[slot] & 0x0C:     # above or below
jr_005_4aac:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_005_4ac1

;>     wEntitySpeedY[slot] = (-wEntitySpeedY[slot]) & 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     hJingle = 9
	ld a, $09
	ldh [hJingle], a

;> if GetEntityDropTimer(slot) < 0x60 and hFrameCounter & 3 == 0:
jr_005_4ac1:
	call GetEntityDropTimer
	cp $60
	jr nc, jr_005_4aeb

	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_4aeb

;>     RaccoonSpeedUpAxis(wEntitySpeedX, slot)
	ld hl, wEntitySpeedX
	call RaccoonSpeedUpAxis
;>     RaccoonSpeedUpAxis(wEntitySpeedY, slot)   # runs on into it
	ld hl, wEntitySpeedY

;@ def RaccoonSpeedUpAxis(table: hl, slot: bc)
;@ path: npc/tarin
;@ Makes the slot's speed in the given speed table 1 faster in its direction (0 counts as positive),
;@ until it reaches $30 / -$30.
RaccoonSpeedUpAxis::
;> speed = mem[table + slot]
	add hl, bc
	ld a, [hl]
;> if speed == 0x30 or speed == 0xD0:
	cp $30
	jr z, jr_005_4aeb

	cp $d0
;>     return
	jr z, jr_005_4aeb

;> step = 1
	ld e, $01
;> if speed & 0x80:
	bit 7, a
	jr z, jr_005_4ae9

;>     step = 0xFF
	ld e, $ff

;> mem[table + slot] = (speed + step) & 0xFF
jr_005_4ae9:
	add e
	ld [hl], a

jr_005_4aeb:
	ret


;@ def TarinFallState(slot: bc)
;@ path: npc/tarin
;@ State 2: Tarin falls to the ground. On landing: Link is free again, a jingle, the area music,
;@ Tarin faces Link and waits $40 frames (state 3). If he landed right next to Link (within 18
;@ pixels) he does not block him afterwards (wEntityPrivate1 = 1).
TarinFallState::
;> AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;> wEntitySpeedZ[slot] = (wEntitySpeedZ[slot] - 1) & 0xFF
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:              # reached the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_4b31

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     hJingle = 0x23
	ld a, $23
	ldh [hJingle], a
;>     SelectAreaMusicFar()
	call SelectAreaMusicFar
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     SetEntitySpriteVariant(slot, GetEntityDirectionToLink_05(slot) + 8)    # Tarin facing Link
	call GetEntityDirectionToLink_05
	add $08
	call SetEntitySpriteVariant
;>     if (EntityLinkDiffX_05(slot) + 0x12) & 0xFF < 0x24:
	call EntityLinkDiffX_05
	add $12
	cp $24
	jr nc, jr_005_4b2e

;>         if (EntityLinkDiffY_05(slot) + 0x12) & 0xFF < 0x24:
	call EntityLinkDiffY_05
	add $12
	cp $24
	jr nc, jr_005_4b2e

;>             wEntityPrivate1[slot] = 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01

;>     wEntityState[slot] += 1
jr_005_4b2e:
	call IncrementEntityState

jr_005_4b31:
	ret


;@ def TarinCuredState(slot: bc)
;@ path: npc/tarin
;@ State 3: when wEntityTimer reaches 1 Tarin speaks (text $00A); afterwards he turns to Link every
;@ 32 frames, blocks him (unless he landed next to him) and talking shows text $00B.
TarinCuredState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 1:
	cp $01
	jr nz, jr_005_4b3f

;>     OpenDialog(0x0A)                  # text $00A
	ld a, $0a
	call OpenDialog
;>     return
	ret


;> if t != 0:
jr_005_4b3f:
	and a
;>     return
	jr nz, jr_005_4b65

;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_4b50

;>     SetEntitySpriteVariant(slot, GetEntityDirectionToLink_05(slot) + 8)
	call GetEntityDirectionToLink_05
	add $08
	call SetEntitySpriteVariant

;> if wEntityPrivate1[slot] == 0:
jr_005_4b50:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_4b5b

;>     MakeEntitySolid_05()
	call MakeEntitySolid_05

;> if ShouldLinkTalkToEntity_05():
jr_005_4b5b:
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_4b65

;>     OpenDialog(0x0B)                  # text $00B
	ld a, $0b
	call OpenDialog

jr_005_4b65:
	ret


;@ path: npc/tarin
;@ The bubble rising from sleeping Tarin: one 8x16 sprite for DrawEntity8x16 (tile, attributes).
TarinSnoreBubbleSprite::
	db $78, $00

;@ def TarinIndoors(slot: bc)
;@ path: npc/tarin
;@ Tarin in his house. An entity with wEntityPrivate2 set is one of his snore bubbles instead: it drifts
;@ up, swaying left and right, for $30 frames. Tarin is gone once dungeon 3's instrument is taken or
;@ the trade sequence is past item 3 (unless Marin walks with Link), and before his spell (wTarinState
;@ 0) also once Link has a sword. With Marin following, or after the spell (state 1), he sleeps in his
;@ bed at (x $18, y $34); otherwise he stands and turns to Link every 32 frames.
TarinIndoors::
;> if wEntityPrivate2[slot]:             # a snore bubble
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4b98

;>     DrawEntity8x16(slot, TarinSnoreBubbleSprite)
	ld de, TarinSnoreBubbleSprite
	call DrawEntity8x16
;>     if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>         return
;>     UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;>     t = GetEntityTimer(slot)
;>     if t == 0:
	call GetEntityTimer
;>         ClearEntityStatus_05(slot)
;>         return
	jp z, ClearEntityStatus_05

;>     step = 1 if t & 0x10 == 0 else 0xFF
	and $10
	ld e, $01
	jr z, jr_005_4b8a

	ld e, $ff

;>     if hFrameCounter & 1 == 0:
jr_005_4b8a:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_005_4b97

;>         wEntitySpeedX[slot] = (wEntitySpeedX[slot] + step) & 0xFF   # sway
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a

;>     return
jr_005_4b97:
	ret


;> if not wIsMarinFollowingLink:
jr_005_4b98:
	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, jr_005_4bae

;>     if wDungeonFlags[2] & 0x02:        # dungeon 3's instrument taken
	ld a, [wDungeonFlags + 2]
	and $02
;>         ClearEntityStatus_05(slot)
;>         return
	jp nz, ClearEntityStatus_05

;>     if wTradeSequenceItem >= 4:
	ld a, [wTradeSequenceItem]
	cp $04
;>         ClearEntityStatus_05(slot)
;>         return
	jp nc, ClearEntityStatus_05

;> if wTarinState == 0 and wSwordLevel:   # he has gone to the forest
jr_005_4bae:
	ld a, [wTarinState]
	and a
	jr nz, jr_005_4bbb

	ld a, [wSwordLevel]
	and a
;>     ClearEntityStatus_05(slot)
;>     return
	jp nz, ClearEntityStatus_05

;> if wIsMarinFollowingLink or wTarinState == 1:
jr_005_4bbb:
	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, jr_005_4bcb

;>     # (the state test)
	ld a, [wTarinState]
	and a
	jr z, jr_005_4bdf

	cp $01
	jr nz, jr_005_4bdf

;>     wEntityX[slot] = 0x18             # in his bed
jr_005_4bcb:
	ld hl, wEntityX
	add hl, bc
	ld [hl], $18
;>     wEntityY[slot] = 0x34
	ld hl, wEntityY
	add hl, bc
	ld [hl], $34
;>     LoadEntityPosition(slot)                       # copy the position to hActiveEntityX / Y
	call LoadEntityPosition
;>     sprites = TarinSleepingSprite
	ld de, TarinSleepingSprite
	jr jr_005_4bf3

;> else:
;>     DrawTarinTradeObject(slot)
jr_005_4bdf:
	call DrawTarinTradeObject
;>     if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_4bf0

;>         wEntitySpriteVariant[slot] = GetEntityDirectionToLink_05(slot)
	call GetEntityDirectionToLink_05
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], e

;>     sprites = TarinStandingSprites
jr_005_4bf0:
	ld de, TarinStandingSprites

;> DrawEntity16x16(slot, sprites)
jr_005_4bf3:
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>     return
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> TarinHouseStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/tarin
;@ States of Tarin at home (wEntityState), dispatched by TarinIndoors: 0 waiting to hand Link the
;@ shield, 1 fanfare, 2 Link holds up the shield, 3 normal talk, 4 the answer to his trade offer.
TarinHouseStates::
	dw TarinOfferShieldState
	dw TarinShieldFanfareState
	dw TarinGiveShieldState
	dw TarinTalkState
	dw TarinTradeAnswerState

;@ def TarinOfferShieldState(slot: bc)
;@ path: npc/tarin
;@ State 0, the start of the game: Link may not leave the house without the shield. If he walks down
;@ to the door (y $7B) he is pushed back and Tarin calls him (text $000); talking to Tarin (text $054)
;@ starts the hand-over. Once Link has a shield, state 3.
TarinOfferShieldState::
;> if wShieldLevel:
	ld a, [wShieldLevel]
	and a
	jr z, jr_005_4c15

;>     wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;>     return
	ret


;> if hLinkY >= 0x7B:                    # at the door
jr_005_4c15:
	ldh a, [hLinkY]
	cp $7b
	jr c, jr_005_4c24

;>     hLinkY -= 2
	sub $02
	ldh [hLinkY], a
;>     OpenDialog(0x00)                  # text $000
;>     return
	ld a, $00
	jp OpenDialog


;> if ShouldLinkTalkToEntity_05():
jr_005_4c24:
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_4c31

;>     OpenDialog(0x54)                  # text $054
	ld a, $54
	call OpenDialog
;>     wEntityState[slot] += 1
	call IncrementEntityState

jr_005_4c31:
	ret


;@ def TarinShieldFanfareState(slot: bc)
;@ path: npc/tarin
;@ State 1: after the text, the item fanfare (music $10) and $80 frames of showing the shield.
TarinShieldFanfareState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_4c45

;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;> wEntityState[slot] += 1
	call IncrementEntityState

jr_005_4c45:
	ret


;@ path: npc/tarin
;@ The shield Link holds over his head: one 8x16 sprite for DrawEntity8x16 (tile $86, attributes $10 =
;@ sprite palette 1).
ShieldHeldUpSprite::
	db $86, $10

;@ def TarinGiveShieldState(slot: bc)
;@ path: npc/tarin
;@ State 2: while wEntityTimer runs Link stands in his item pose ($6C) facing down with the shield
;@ drawn above his head. Then he gets the shield (item 4, wShieldLevel 1), text $091, state 3.
TarinGiveShieldState::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_4c66

;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     GiveInventoryItem_05(4)           # the shield
	ld d, $04
	call GiveInventoryItem_05
;>     wShieldLevel = 1
	ld a, $01
	ld [wShieldLevel], a
;>     hLinkAnimationState = 0x22
	ld a, $22
	ldh [hLinkAnimationState], a
;>     OpenDialog(0x91)                  # text $091
	ld a, $91
	call OpenDialog
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


;> hActiveEntityX = hLinkX
jr_005_4c66:
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = (hLinkY - 12) & 0xFF
	ldh a, [hLinkY]
	sub $0c
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity8x16(slot, ShieldHeldUpSprite)          # the shield over Link's head
	ld de, ShieldHeldUpSprite
	call DrawEntity8x16
;> LoadEntityPosition(slot)                           # back to Tarin's own position
	call LoadEntityPosition
;> hLinkAnimationState = 0x6C             # Link holds it up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkDirection = 3
	ld a, $03
	ldh [hLinkDirection], a
	ret


;@ def TarinTalkState(slot: bc)
;@ path: npc/tarin
;@ State 3, what Tarin says. wTarinState 0: text $055. 1 (asleep in bed): text $011, or $010 once
;@ dungeon 1's instrument is taken, and snore bubbles rise. 2: text $1DD while Marin walks with Link
;@ (bubbles too), otherwise his trade question $1C5.
TarinTalkState::
;> if wTarinState == 0:
	ld a, [wTarinState]
	and a
	jr z, jr_005_4cce

;>@s0     if ShouldLinkTalkToEntity_05():
;>@s0         OpenDialog(0x55)              # text $055
;>@s0     return
;> elif wTarinState == 1:
	cp $01
	jr z, jr_005_4cb9

;>@s1     if ShouldLinkTalkToEntity_05():
;>@s1         OpenDialog(0x10 if wDungeonFlags[0] & 0x02 else 0x11)
;>@s1     snore = True
;> else:
;>@m     snore = bool(wIsMarinFollowingLink)
;>     if ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_4cac

;>         if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
	ld a, $dd
;>             OpenDialogTable1(0xDD)    # text $1DD
;>             return
	jr nz, jr_005_4cb5

;>         if wTradeSequenceItem != 3:
	ld a, [wTradeSequenceItem]
	cp $03
;>@ask             OpenDialogTable1(0xC5)    # text $1C5, the trade question
;>@ask             return
	jr nz, jr_005_4cb3

;>         OpenDialogTable1(0xC5)
	ld a, $c5
	call OpenDialogTable1

jr_005_4cac:
;=@m
	ld a, [wIsMarinFollowingLink]
	and a
	jr nz, jr_005_4ce0

;=@m
	ret


jr_005_4cb3:
;=@ask
	ld a, $c5

jr_005_4cb5:
;=@ask
	call OpenDialogTable1
	ret


jr_005_4cb9:
;=@s1
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_4ccc

;=@s1
	ld a, [wDungeonFlags]
	bit 1, a
	ld a, $11
	jr z, jr_005_4cc9

	ld a, $10

jr_005_4cc9:
;=@s1
	call OpenDialog

jr_005_4ccc:
	jr jr_005_4cd9

jr_005_4cce:
;=@s0
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_4cd8

;=@s0
	ld a, $55
	call OpenDialog

jr_005_4cd8:
;=@s0
	ret


;> if not snore:
jr_005_4cd9:
	ld a, [wTarinState]
	cp $01
;>     return
	jr nz, jr_005_4d25

;> wEntityPrivateCounter[slot] += 7       # a new bubble every 37 frames or so
jr_005_4ce0:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	add $07
	ld [hl], a
;> if wEntityPrivateCounter[slot] < 7:    # it wrapped round: time for a bubble
	jr nc, jr_005_4d25

;>     new = SpawnEntity(0x3F)             # another Tarin entity: a snore bubble
	ld a, $3f
	call SpawnEntity
;>     wEntityX[new] = (hMultiPurpose0 + 6) & 0xFF
	ldh a, [hMultiPurpose0]
	add $06
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = (hMultiPurpose1 - 3) & 0xFF
	ldh a, [hMultiPurpose1]
	sub $03
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityPrivate2[new] = 1          # marks it as a bubble
	ld hl, wEntityPrivate2
	add hl, de
	ld [hl], $01
;>     wEntitySpeedX[new] = 0xFF
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $ff
;>     wEntitySpeedY[new] = 0xFD
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fd
;>     wEntityTimer[new] = 0x30
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30
;>     wEntityPhysicsFlags[new] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
;>     wEntityHitboxFlags[new] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00

jr_005_4d25:
	ret


;@ def TarinTradeAnswerState(slot: bc)
;@ path: npc/tarin
;@ State 4, after the trade question: yes (answer 0) makes the trade item 4, with background change
;@ $0D and the new item shown in Link's hands (SpawnHeldItemEntity); no shows text $1C9. Back to state 0.
TarinTradeAnswerState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_4d49

;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, jr_005_4d40

;>     wTradeSequenceItem = 4
	ld a, $04
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
	jr jr_005_4d45

;> else:
;>     OpenDialogTable1(0xC9)            # text $1C9
jr_005_4d40:
	ld a, $c9
	call OpenDialogTable1

;> wEntityState[slot] = 0
jr_005_4d45:
	call IncrementEntityState
	ld [hl], b

jr_005_4d49:
	ret


;@ path: npc/tarin
;@ An object drawn next to Tarin at home while wTarinState is 2 and the trade item is below 4 (one
;@ DrawEntity16x16 variant, tiles $74/$76), at x $78.
TarinTradeObjectSpriteA::
	db $74, $00, $76, $00

;@ path: npc/tarin
;@ The object drawn instead from trade item 4 on, once the room has bit 5 (tiles $70/$72), at x $7C.
TarinTradeObjectSpriteB::
	db $70, $00, $72, $00

;@ def DrawTarinTradeObject(slot: bc)
;@ path: npc/tarin
;@ With wTarinState 2, draws the object of TarinTradeObjectSpriteA / B at y $5C beside Tarin (and with
;@ the second one moves Tarin to y $4B), then restores his own position and sprite variant.
DrawTarinTradeObject::
;> if wTarinState != 2:
	ld a, [wTarinState]
	cp $02
;>     return
	ret nz

;> if wTradeSequenceItem < 4:
	ld a, [wTradeSequenceItem]
	cp $04
	jr nc, jr_005_4d66

;>     x, sprites = 0x78, TarinTradeObjectSpriteA
	ld a, $78
	ld de, TarinTradeObjectSpriteA
	jr jr_005_4d76

;> else:
;>     if hRoomStatus & 0x20 == 0:
jr_005_4d66:
	ldh a, [hRoomStatus]
	and $20
;>         return
	ret z

;>     wEntityY[slot] = 0x4B
	ld hl, wEntityY
	add hl, bc
	ld [hl], $4b
;>     x, sprites = 0x7C, TarinTradeObjectSpriteB
	ld de, TarinTradeObjectSpriteB
	ld a, $7c

;> hActiveEntityX = x
jr_005_4d76:
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = 0x5C
	ld a, $5c
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, sprites)
	call DrawEntity16x16
;> LoadEntityPosition(slot)                           # back to Tarin's own position
	call LoadEntityPosition
;> hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ret


;@ path: npc/marin
;@ Marin's sprites in her house, for DrawEntity16x16 (4 bytes a variant: tile and attributes of the left
;@ 8x16 half, then of the right half; $20 = mirrored), as chosen by AnimateNpcFacing_05: 0-1 facing
;@ down, 2-3 up, 4-5 left, 6-7 right (two walking frames each).
MarinSprites::
	db $60, $00, $62, $00,  $62, $20, $60, $20,  $64, $00, $66, $00,  $66, $20, $64, $20
	db $68, $00, $6a, $00,  $6c, $00, $6e, $00,  $6a, $20, $68, $20,  $6e, $20, $6c, $20
;@ path: npc/marin
;@ Marin's sprites outdoors (DrawEntity16x16 format): 0-7 as in MarinSprites (down, up, left, right with
;@ two frames each), 8-10 singing (see MarinSingFrames).
MarinOutdoorSprites::
	db $68, $00, $6a, $00,  $6a, $20, $68, $20,  $66, $00, $66, $20,  $66, $00, $66, $20
	db $6c, $00, $6e, $00,  $6c, $00, $6e, $00,  $6e, $20, $6c, $20,  $6e, $20, $6c, $20
	db $60, $00, $62, $00,  $64, $00, $64, $20,  $62, $20, $60, $20

;@ path: npc/marin
;@ Marin's singing animation: the MarinOutdoorSprites variant for each 16-frame step (8 steps).
MarinSingFrames::
	db $08, $08, $08, $09, $0a, $0a, $0a, $09

;@ path: npc/marin
;@ x offset (signed) of a new music note from the singer, for notes on the right (0) and left (1);
;@ a note rises to every other side every 32 frames.
MusicNoteOffsetX::
	db $08, $f8

;@ path: npc/marin
;@ Starting x speed (1/16 pixel per frame) of a new music note, for the same two sides.
MusicNoteSpeedX::
	db $06, $01

;@ def MarinEntityHandler(slot: bc)
;@ path: npc/marin
;@ Entity handler of type $3E: Marin. Indoors see MarinIndoors. Outdoors she appears once Link has
;@ the sword (in the village rooms only until the trade sequence reaches item 7, unless room 8 has
;@ bit 4), faces down, turning to Link when he is near, and sings: while wMarinSinging is 1 (and in
;@ the ending) she plays the singing frames and a music note (type $C9) rises every 32 frames.
MarinEntityHandler::
;> sing = True
;> if wGameplayType != 1:                # in the ending she just sings
	ld a, [wGameplayType]
	cp $01
	jp z, Jump_005_4e4e

;>     if wIsMarinFollowingLink:         # then the follower entity shows her
	ld a, [wIsMarinFollowingLink]
	and a
;>         ClearEntityStatus_05(slot)
;>         return
	jp nz, ClearEntityStatus_05

;>     if wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>         MarinIndoors(slot)
;>         return
	jp nz, MarinIndoors

;>     if wSwordLevel == 0:
	ld a, [wSwordLevel]
	and a
;>         ClearEntityStatus_05(slot)
;>         return
	jp z, ClearEntityStatus_05

;>     if hMapRoom < 0xC0 and wRoomStatus[0x08] & 0x10 == 0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, jr_005_4e0a

	jr jr_005_4e19

jr_005_4e0a:
;>         # (room 8's flag)
	ld a, [wRoomStatus + $08]
	and $10
	jr nz, jr_005_4e19

;>         if wTradeSequenceItem >= 7:
	ld a, [wTradeSequenceItem]
	cp $07
;>             ClearEntityStatus_05(slot)
;>             return
	jp nc, ClearEntityStatus_05

;>     if hFrameCounter & 0x1F == 0:
jr_005_4e19:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_4e3f

;>         wEntityDirection[slot] = 3    # facing down
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $03
;>         if (EntityLinkDiffX_05(slot) + 0x14) & 0xFF < 0x28:
	call EntityLinkDiffX_05
	add $14
	cp $28
	jr nc, jr_005_4e3f

;>             if (EntityLinkDiffY_05(slot) + 0x14) & 0xFF < 0x28:
	call EntityLinkDiffY_05
	add $14
	cp $28
	jr nc, jr_005_4e3f

;>                 wEntityDirection[slot] = GetEntityDirectionToLink_05(slot)
	call GetEntityDirectionToLink_05
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

;>     AnimateNpcFacing_05(slot)
jr_005_4e3f:
	call AnimateNpcFacing_05
;>     sing = wMarinSinging == 1 and GetEntityTimer1(slot) == 0
	ld a, [wMarinSinging]
	cp $01
	jr nz, jr_005_4ea7

	call GetEntityTimer1
	jr nz, jr_005_4ea7

;> if sing:
;>@frame     hActiveEntitySpriteVariant = MarinSingFrames[(hFrameCounter >> 4) & 7]
Jump_005_4e4e:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
;=@frame
	ld e, a
	ld d, b
	ld hl, MarinSingFrames
	add hl, de
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     if (hFrameCounter + 0x10) & 0x1F == 0:
	ldh a, [hFrameCounter]
	add $10
	and $1f
	jr nz, jr_005_4ea7

;>         new = SpawnEntity(0xC9)         # a music note
	ld a, $c9
	call SpawnEntity
;>         if new is not None:
	jr c, jr_005_4ea7

;>             wEntityY[new] = (hMultiPurpose1 - 8) & 0xFF
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	sub $08
	ld [hl], a
;>@side             side = ((hFrameCounter + 0x10) >> 5) & 1
	push bc
	ldh a, [hFrameCounter]
	add $10
	rra
	rra
	rra
;=@side
	rra
	rra
	and $01
	ld c, a
;>@nx             wEntityX[new] = (hMultiPurpose0 + MusicNoteOffsetX[side]) & 0xFF
	ld hl, MusicNoteOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@nx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntitySpeedX[new] = MusicNoteSpeedX[side]
	ld hl, MusicNoteSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>             wEntitySpeedY[new] = 0xFC
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fc
;>             wEntityPrivateCounter[new] = 0x40
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], $40
	pop bc

;> wSingingMarinSlot = slot
jr_005_4ea7:
	ld a, c
	ld [wSingingMarinSlot], a
;> DrawEntity16x16(slot, MarinOutdoorSprites)
	ld de, MarinOutdoorSprites
	call DrawEntity16x16
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> MarinStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/marin
;@ Marin's states outdoors (wEntityState): 0 waiting to be talked to, 1 starting her song, 2 singing
;@ the Ballad of the Wind Fish for Link, 3 his answer, 4 Link learns the song, 5 done.
MarinStates::
	dw MarinIdleState
	dw MarinStartSongState
	dw MarinSingState
	dw MarinSongAnswerState
	dw MarinTeachSongState
	dw MarinDoneState

;@ def MarinIdleState(slot: bc)
;@ path: npc/marin
;@ State 0: talking to Marin (not while she sings, except in rooms $C0 and up). With room 8's bit 4
;@ (she is at the beach) she first says text $194 once (room $92 bit 6), then text $195 unless Link
;@ carries the ocarina (item 9) and has not learnt the Ballad yet. Otherwise her text depends on
;@ wTarinState and the ocarina: $003, $006, $005 or $192, and $004 when Link has the ocarina but not
;@ the Ballad - then the song she starts next (wEntityPrivate4) is the Ballad ($4A) instead of her
;@ normal song ($2F). Then state 1.
MarinIdleState::
;> if hMapRoom < 0xC0 and wMarinSinging:
	ldh a, [hMapRoom]
	cp $c0
	jr nc, jr_005_4ed0

	ld a, [wMarinSinging]
	and a
;>     return
	jp nz, Jump_005_4f83

;> if not ShouldLinkTalkToEntity_05():
jr_005_4ed0:
	call ShouldLinkTalkToEntity_05
;>     return
	jp nc, Jump_005_4f83

;> if wRoomStatus[0x08] & 0x10:
	ld a, [wRoomStatus + $08]
	and $10
	jr z, jr_005_4f0a

;>     if wRoomStatus[0x92] & 0x40 == 0:
	ld hl, wRoomStatus + $92
	ld a, [hl]
	and $40
	jr nz, jr_005_4eec

;>         wRoomStatus[0x92] |= 0x40
	set 6, [hl]
;>         OpenDialogTable1(0x94)        # text $194
;>         return
	ld a, $94
	jp OpenDialogTable1


;>     if wOcarinaSongFlags & 0x04:      # knows the Ballad
jr_005_4eec:
	ld a, [wOcarinaSongFlags]
	and $04
	jr z, jr_005_4ef8

;>@no         OpenDialogTable1(0x95)        # text $195
;>@no         return
jr_005_4ef3:
;=@no
	ld a, $95
	jp OpenDialogTable1


;>@oc     for item in wItemB[0:12]:
jr_005_4ef8:
	ld e, $0b
	ld hl, wItemB

;>         if item == 9:                 # the ocarina
jr_005_4efd:
	ld a, [hli]
	cp $09
;>             break
	jr z, jr_005_4f0a

;=@oc
	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_4efd

;>     else:                             # no ocarina
;>         OpenDialogTable1(0x95)
;>         return
	jr jr_005_4ef3

;> wEntityTimer1[slot] = 0x10
jr_005_4f0a:
	call GetEntityTimer1
	ld [hl], $10
;> song, text = 0x2F, 0x03
	ld d, $2f
	ld e, $03
;> if wTarinState != 0:
	ld a, [wTarinState]
	and a
	jr z, jr_005_4f5e

;>     text = 0x06
	ld e, $06
;>     if wTarinState == 2:
	cp $02
	jr nz, jr_005_4f33

;>         text = 0x05
	ld e, $05
;>         if hMapRoom >= 0xC0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, jr_005_4f33

;>             SelectAreaMusicFar()
	push de
	call SelectAreaMusicFar
	pop de
;>             wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
;>             text = 0x92
	ld e, $92

;>@scan     for item in wItemB[0:12]:
jr_005_4f33:
	push bc
	ld c, $0b
	ld hl, wItemB

;>         if item == 9:                 # the ocarina
jr_005_4f39:
	ld a, [hli]
	cp $09
	jr nz, jr_005_4f57

;>             text, song = 0x04, 0x4A   # she will teach the Ballad
	ld e, $04
	ld d, $4a
;>             if wOcarinaSongFlags & 0x04:
	ld a, [wOcarinaSongFlags]
	and $04
	jr z, jr_005_4f5d

;>                 text, song = 0x05, 0x2F
	ld e, $05
	ld d, $2f
;>                 if hMapRoom >= 0xC0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, jr_005_4f5d

;>                     text = 0x92
	ld e, $92
;>             break
	jr jr_005_4f5d

jr_005_4f57:
;=@scan
	dec c
	ld a, c
	cp $ff
	jr nz, jr_005_4f39

jr_005_4f5d:
	pop bc

;> if text >= 0x80:
jr_005_4f5e:
	ld a, e
	cp $80
	jr c, jr_005_4f68

;>     OpenDialogTable1(text)            # text $100 + text
	call OpenDialogTable1
	jr jr_005_4f6b

;> else:
;>     OpenDialog(text)
jr_005_4f68:
	call OpenDialog

;> if hMapRoom >= 0xC0:
jr_005_4f6b:
	ldh a, [hMapRoom]
	cp $c0
	jr c, jr_005_4f7b

;>     wEntityPrivate3[slot] = 0
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b
;>     SelectAreaMusicFar()
	push de
	call SelectAreaMusicFar
	pop de

;> wEntityPrivate4[slot] = song
jr_005_4f7b:
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], d
;> wEntityState[slot] += 1
	call IncrementEntityState

Jump_005_4f83:
	ret


;@ def MarinStartSongState(slot: bc)
;@ path: npc/marin
;@ State 1: on its first frame starts her song (wEntityPrivate4) as the area music and sets
;@ wMarinSinging. If it is the Ballad and Link does not know it yet, she sings it to him (state 2),
;@ otherwise she goes back to state 0.
MarinStartSongState::
;> if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>     return
;> song = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld d, [hl]
;> if wEntityPrivate3[slot] == 0:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	ld a, d
	jr nz, jr_005_4fa2

;>     wEntityPrivate3[slot] = 1
	inc [hl]
;>     wMusicTrackToPlay = song
	ld [wMusicTrackToPlay], a
;>     hDefaultMusicTrack = song
	ldh [hDefaultMusicTrack], a
;>     hDefaultMusicTrackAlt = song
	ldh [hDefaultMusicTrackAlt], a
;>     wMarinSinging = 1
	ld hl, wMarinSinging
	ld [hl], $01

;> if song == 0x4A and wOcarinaSongFlags & 0x04 == 0:
jr_005_4fa2:
	cp $4a
	jr nz, jr_005_4fb8

	ld a, [wOcarinaSongFlags]
	and $04
	jr nz, jr_005_4fb8

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wSongShowTimer = 0
	xor a
	ld [wSongShowTimer], a
	ld [wSongShowTimer + 1], a
;>     return
	ret


;> wEntityState[slot] = 0
jr_005_4fb8:
	call IncrementEntityState
	ld [hl], b
	ret


;@ def MarinSingState(slot: bc)
;@ path: npc/marin
;@ State 2: Marin sings the Ballad to Link, who stands facing her. wSongShowTimer counts the frames;
;@ from step $1D (of 16 frames) Link plays along on the ocarina (poses $75/$76) and notes rise from
;@ him every 32 frames; wMarinSinging is 2 between steps $1D and $3B. At frame $7E0 the singing flag
;@ goes off, at $7E8 she asks (text $016), the sound engine is reset and state 3 follows.
MarinSingState::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;> if wSongShowTimer == 0x07E8:          # the song is over
	ld a, [wSongShowTimer + 1]
	cp $07
	jr nz, jr_005_4feb

	ld a, [wSongShowTimer]
	cp $e8
	jr nz, jr_005_4feb

;>     OpenDialog(0x16)                  # text $016
	ld a, $16
	call OpenDialog
;>     UpdateLinkAnimationStateFar()
	push bc
	call UpdateLinkAnimationStateFar
	pop bc
;>     wSongShowTimer = 0
	xor a
	ld [wSongShowTimer], a
	ld [wSongShowTimer + 1], a
;>     ResetSoundEngine()
	call ResetSoundEngine
;>     wEntityState[slot] += 1
;>     return
	jp IncrementEntityState


;> hLinkDirection = GetEntityDirectionToLink_05(slot) ^ 1
jr_005_4feb:
	call GetEntityDirectionToLink_05
	ld a, e
	xor $01
	ldh [hLinkDirection], a
;>@t wSongShowTimer = (wSongShowTimer + 1) & 0xFFFF
	ld a, [wSongShowTimer]
	add $01
	ld [wSongShowTimer], a
	ld e, a
;=@t
	ld a, [wSongShowTimer + 1]
	adc $00
	ld [wSongShowTimer + 1], a
	ld d, a
;> if wSongShowTimer >> 8 == 7 and wSongShowTimer & 0xFF >= 0xE0:
	ld a, [wSongShowTimer + 1]
	cp $07
	jr nz, jr_005_5018

	ld a, [wSongShowTimer]
	cp $e0
	jr c, jr_005_5018

;>     wMarinSinging = 0
	xor a
	ld [wMarinSinging], a
;>     return
	ret


;> wMarinSinging = 1
jr_005_5018:
	ld hl, wMarinSinging
	ld [hl], $01
;>@step step = (wSongShowTimer >> 4) & 0xFF
	ld a, e
	srl d
	rra
	srl d
	rra
;=@step
	srl d
	rra
	srl d
	rra
;> if 0x1D <= step < 0x3B:
	cp $1d
	jr c, jr_005_5033

	cp $3b
	jr nc, jr_005_5033

;>     wMarinSinging = 2
	inc [hl]

;> if step < 0x1D:
jr_005_5033:
	cp $1d
;>     return
	ret c

;> hLinkAnimationState = 0
	ld a, $00
	ldh [hLinkAnimationState], a
;> pose = 0x75                           # Link plays the ocarina
	ldh a, [hFrameCounter]
	ld e, $75
;> if hFrameCounter & 0x40:
	and $40
	jr z, jr_005_5043

;>     pose = 0x76
	inc e

;> hLinkAnimationState = pose
jr_005_5043:
	ld a, e
	ldh [hLinkAnimationState], a
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_508b

;>     new = SpawnEntity(0xC9)             # a music note from Link
	ld a, $c9
	call SpawnEntity
;>     if new is not None:
	jr c, jr_005_508b

;>         wEntityY[new] = (hLinkY - 8) & 0xFF
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	sub $08
	ld [hl], a
;>@side2         side = (hFrameCounter >> 5) & 1
	push bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@side2
	rra
	and $01
	ld c, a
	ld b, d
;>@nx2         wEntityX[new] = (hLinkX + MusicNoteOffsetX[side]) & 0xFF
	ld hl, MusicNoteOffsetX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
;=@nx2
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntitySpeedX[new] = MusicNoteSpeedX[side]
	ld hl, MusicNoteSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[new] = 0xFC
	pop bc
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $fc
;>         wEntityPrivateCounter[new] = 0x40
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], $40

jr_005_508b:
	ret


;@ def MarinSongAnswerState(slot: bc)
;@ path: npc/marin
;@ State 3, after her question: yes (answer 0) plays the fanfare (music $10) and Link learns the song
;@ for $80 frames (state 4); no gets text $015 and she sings again (state 1).
MarinSongAnswerState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_50b5

;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, jr_005_50a6

;>     wMusicTrackToPlay = 0x10
	ld a, $10
	ld [wMusicTrackToPlay], a
;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     return
	ret


;> OpenDialog(0x15)                       # text $015
jr_005_50a6:
	ld a, $15
	call OpenDialog
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> wEntityPrivate3[slot] = 0              # the song starts again
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b

jr_005_50b5:
	ret


;@ path: npc/marin
;@ The ocarina held over Link's head while he learns the song: one 8x16 sprite for DrawEntity8x16 (tile
;@ $90, attributes $10 = sprite palette 1).
OcarinaHeldUpSprite::
	db $90, $10

;@ def MarinTeachSongState(slot: bc)
;@ path: npc/marin
;@ State 4: while wEntityTimer runs Link holds up the ocarina (pose $6C) and at 8 frames before the
;@ end text $013 opens. Then, after the text, the Ballad of the Wind Fish is learnt (wOcarinaSongFlags
;@ bit 2) and selected, and Marin says text $014 (state 5) - in rooms $C0 and up text $193 and back
;@ to state 0.
MarinTeachSongState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, jr_005_50e5

;>     if wDialogState:
	ld a, [wDialogState]
	and a
;>         return
	ret nz

;>     wOcarinaSongFlags |= 0x04         # the Ballad of the Wind Fish
	ld hl, wOcarinaSongFlags
	set 2, [hl]
;>     wSelectedSong = 0
	xor a
	ld [wSelectedSong], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     if hMapRoom >= 0xC0:
	ldh a, [hMapRoom]
	cp $c0
	jr c, jr_005_50d5

;>         wEntityState[slot] = 0
	ld [hl], b

;>     if hMapRoom < 0xC0:
jr_005_50d5:
	ldh a, [hMapRoom]
	cp $c0
	jr nc, jr_005_50e0

;>         OpenDialog(0x14)              # text $014
;>         return
	ld a, $14
	jp OpenDialog


;>     OpenDialogTable1(0x93)            # text $193
;>     return
jr_005_50e0:
	ld a, $93
	jp OpenDialogTable1


;> if t == 8:
jr_005_50e5:
	cp $08
	jr nz, jr_005_50ef

;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     OpenDialog(0x13)                  # text $013
	ld a, $13
	call OpenDialog

;> hLinkAnimationState = 0x6C             # holding the ocarina up
jr_005_50ef:
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hActiveEntityX = hLinkX
	ldh a, [hLinkX]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = (hLinkY - 12) & 0xFF
	ldh a, [hLinkY]
	sub $0c
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	ld de, OcarinaHeldUpSprite
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity8x16(slot, OcarinaHeldUpSprite)
	call DrawEntity8x16
	ret


;@ def MarinDoneState(slot: bc)
;@ path: npc/marin
;@ State 5: talking to her shows text $197.
MarinDoneState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	ret nz

;> if not ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
;>     return
	ret nc

;> OpenDialogTable1(0x97)                 # text $197
	ld a, $97
	jp OpenDialogTable1


;@ path: npc/marin
;@ Marin's picture in her house late in the game (trade item 7 on): one DrawEntity16x16 variant, tile $5C
;@ and its mirror.
MarinLateSprite::
	db $5c, $00, $5c, $20

;@ def MarinIndoors(slot: bc)
;@ path: npc/marin
;@ Marin in her house. From trade item 7 on she stands at (x $7A, y $60) until room $FD has bit 4 or 5,
;@ and talking shows text $1D7. Before Link has the sword she runs the opening: on the first frame
;@ she moves 8 pixels up-left, faces left and freezes Link in bed (wEntityDropTimer $7F); then Link
;@ wakes up (MarinWatchLinkWakeState), gets out of bed (LinkInBedState) and can talk to her. Once Link
;@ has the shield she goes straight to the talking state.
MarinIndoors::
;> if wTradeSequenceItem >= 7:
	ld a, [wTradeSequenceItem]
	cp $07
	jr c, jr_005_514c

;>     if wRoomStatus[0xFD] & 0x30:
	ld a, [wRoomStatus + $fd]
	and $30
;>         ClearEntityStatus_05(slot)
;>         return
	jp nz, ClearEntityStatus_05

;>     wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, bc
	ld [hl], $60
;>     wEntityX[slot] = 0x7A
	ld hl, wEntityX
	add hl, bc
	ld [hl], $7a
;>     DrawEntity16x16(slot, MarinLateSprite)
	ld de, MarinLateSprite
	call DrawEntity16x16
;>     if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>         return
;>     if ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_514b

;>         OpenDialogTable1(0xD7)        # text $1D7
	ld a, $d7
	call OpenDialogTable1

;>     return
jr_005_514b:
	ret


;> if wSwordLevel:
jr_005_514c:
	ld a, [wSwordLevel]
	and a
;>     ClearEntityStatus_05(slot)
;>     return
	jp nz, ClearEntityStatus_05

;> if wShieldLevel:
	ld a, [wShieldLevel]
	and a
	jr z, jr_005_5162

;>     wEntityState[slot] = 3
	ld hl, wEntityState
	add hl, bc
	ld a, $03
	ld [hl], a
;>     hActiveEntityState = 3
	ldh [hActiveEntityState], a

;> if hActiveEntityState == 0:            # first frame of the opening
jr_005_5162:
	ldh a, [hActiveEntityState]
	and a
	jr nz, jr_005_5189

;>     wEntityDropTimer[slot] = 0x7F     # Link wakes up during this
	call GetEntityDropTimer
	ld [hl], $7f
;>     wEntityDirection[slot] = 1        # facing left, to the bed
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], $01
;>     wEntityX[slot] = (wEntityX[slot] - 8) & 0xFF
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;>     wEntityY[slot] = (wEntityY[slot] - 8) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;>     wLinkFrozen = wEntityY[slot]      # any nonzero value
	ld [wLinkFrozen], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


;> if hFrameCounter & 0x1F == 0:
jr_005_5189:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_5197

;>     wEntityDirection[slot] = GetEntityDirectionToLink_05(slot)
	call GetEntityDirectionToLink_05
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

;> AnimateNpcFacing_05(slot)
jr_005_5197:
	call AnimateNpcFacing_05
;> DrawEntity16x16(slot, MarinSprites)
	ld de, MarinSprites
	call DrawEntity16x16
;> MarinHouseStates[hActiveEntityState - 1](slot)
	ldh a, [hActiveEntityState]
	dec a
	rst $00

;@ path: npc/marin
;@ Marin's states in the opening (wEntityState 1-3, the table is indexed with state - 1): watching
;@ Link wake up, Link still in bed, talking.
MarinHouseStates::
	dw MarinWatchLinkWakeState
	dw LinkInBedState
	dw MarinHouseTalkState

;@ path: npc/marin
;@ Link in Marin's bed (DrawEntity16x16 format, 5 variants): 0-1 asleep (the picture flips), 2 stirring,
;@ 3 eyes open, 4 a further waking frame. LinkWakeUpFrames picks them.
LinkInBedSprites::
	db $40, $00, $42, $00,  $42, $20, $40, $20,  $44, $00, $46, $00,  $48, $00, $4a, $00
	db $48, $00, $4c, $00

;@ path: npc/marin
;@ The wake-up animation: the LinkInBedSprites variant for each 4 frames of Marin's wEntityDropTimer,
;@ indexed with (timer >> 2) & $1F. The timer counts down from $7F, so the table is read from the end:
;@ asleep (0/1 alternating) first, then 2, and 3 / 4 when Link opens his eyes.
LinkWakeUpFrames::
	db $03, $03, $03, $03, $03, $04, $03, $04, $03, $03, $03, $02, $02, $02, $02, $02
	db $00, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $01

;@ def MarinWatchLinkWakeState(slot: bc)
;@ path: npc/marin
;@ State 1: Link wakes up in bed while wEntityDropTimer runs; then Marin speaks (text $001) and
;@ state 2 follows.
MarinWatchLinkWakeState::
;> t = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if t == 0:
	jr nz, jr_005_51ee

;>     OpenDialog(0x01)                  # text $001
	ld a, $01
	call OpenDialog
;>     mem[hl] = 0x40                    # through the pointer OpenDialog leaves in hl
	ld [hl], $40
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     t = 0
	xor a

;>@bed DrawLinkInBed(LinkWakeUpFrames[(t >> 2) & 0x1F])
jr_005_51ee:
	rra
	rra
	and $1f
;=@bed
	ld e, a
	ld d, b
	ld hl, LinkWakeUpFrames
	add hl, de
	ld a, [hl]

;@ def DrawLinkInBed(slot: bc, variant: a)
;@ path: npc/marin
;@ Draws Link lying in the bed at (x $38, y $34) with the given LinkInBedSprites variant; Link is held
;@ there and his own sprite is hidden.
DrawLinkInBed::
;> hActiveEntitySpriteVariant = variant
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX = 0x38
;> hLinkX = 0x38
	ld a, $38
	ldh [hActiveEntityX], a
	ldh [hLinkX], a
;> hActiveEntityDrawY = 0x34
;> hLinkY = 0x34
	ld a, $34
	ldh [hActiveEntityDrawY], a
	ldh [hLinkY], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkAnimationState = 0xFF             # Link not drawn: the bed picture shows him
	ld a, $ff
	ldh [hLinkAnimationState], a
;> DrawEntity16x16(slot, LinkInBedSprites)
	ld de, LinkInBedSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)                           # back to Marin's own position
	call LoadEntityPosition
	ret


;@ def LinkInBedState(slot: bc)
;@ path: npc/marin
;@ State 2: Link lies awake in bed (variant 3). When the text is closed and a direction is held, he
;@ jumps out of bed to the right (a small hop like jumping down a ledge) and Marin's state 3 starts.
LinkInBedState::
;> DrawLinkInBed(3)
	ld a, $03
	call DrawLinkInBed
;> if GetEntityTimer(slot) or wDialogState:
	call GetEntityTimer
	ld hl, wDialogState
	or [hl]
;>     return
	jr nz, jr_005_524f

;> if hJoypadHeld & 0x0F == 0:            # no direction held
	ldh a, [hJoypadHeld]
	and $0f
;>     return
	jr z, jr_005_524f

;> wEntityState[slot] += 1
	call IncrementEntityState
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
;> hLinkInteractiveMotionBlocked = 0
	ldh [hLinkInteractiveMotionBlocked], a
;> wIsJumpingDownLedge = 1
	ld a, $01
	ld [wIsJumpingDownLedge], a

jr_005_524f:
	ret


;@ def MarinHouseTalkState(slot: bc)
;@ path: npc/marin
;@ State 3: Marin blocks Link like a wall; talking to her shows text $002.
MarinHouseTalkState::
;> if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>     return
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> if ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_5260

;>     OpenDialog(0x02)                  # text $002
	ld a, $02
	call OpenDialog

jr_005_5260:
	ret


;@ def GiveInventoryItem_05(item: d)
;@ path: item/inventory
;@ Puts an item into the inventory: nothing happens if one of the 12 item slots (wItemB, wItemA and
;@ the 10 subscreen slots after them) already holds it, otherwise it goes into the first empty slot.
GiveInventoryItem_05::
;>@have for i in range(12):
	ld hl, wItemB
	ld e, $0c

;>     if wItemB[i] == item:             # already there
jr_005_5266:
	ld a, [hli]
	cp d
;>         return
	jr z, jr_005_527d

;=@have
	dec e
	jr nz, jr_005_5266

;>@free for i in range(12):
	ld hl, wItemB

;>     if wItemB[i] == 0:
jr_005_5270:
	ld a, [hl]
	and a
	jr nz, jr_005_5276

;>         wItemB[i] = item
	ld [hl], d
;>         return
	ret


jr_005_5276:
;=@free
	inc hl
	inc e
	ld a, e
	cp $0c
	jr nz, jr_005_5270

jr_005_527d:
	ret


;@ path: npc/raft_owner
;@ The raft shop owner's sprites (DrawEntity16x16 format: tile and attributes of the left 8x16 half, then of
;@ the right half; $20 = mirrored), as chosen by AnimateNpcFacing_05: 0-1 down, 2-3 up, 4-5 left,
;@ 6-7 right.
RaftOwnerSprites::
	db $60, $00, $62, $00,  $62, $20, $60, $20,  $64, $00, $66, $00,  $66, $20, $64, $20
	db $68, $00, $6a, $00,  $6c, $00, $6e, $00,  $6a, $20, $68, $20,  $6e, $20, $6c, $20

;@ def RaftOwnerEntityHandler(slot: bc)
;@ path: npc/raft_owner
;@ Entity handler of type $6A. Indoors it is the owner of the raft shop by the rapids, who rents the
;@ raft for 100 rupees; on the overworld it is the raft itself (RaftEntity).
RaftOwnerEntityHandler::
;> if not wIsIndoor:
	ld a, [wIsIndoor]
	and a
;>     RaftEntity(slot)
;>     return
	jr z, RaftEntity

;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_005_52b2

;>     wEntityDirection[slot] = GetEntityDirectionToLink_05(slot)
	call GetEntityDirectionToLink_05
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

;> AnimateNpcFacing_05(slot)
jr_005_52b2:
	call AnimateNpcFacing_05
;> DrawEntity16x16(slot, RaftOwnerSprites)
	ld de, RaftOwnerSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>     return
;> MakeEntitySolid_05()
	call MakeEntitySolid_05
;> RaftOwnerStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/raft_owner
;@ The raft owner's states (wEntityState): 0 offering the raft, 1 the answer, 2 paid.
RaftOwnerStates::
	dw RaftOwnerIdleState
	dw RaftOwnerAnswerState
	dw RaftOwnerPaidState

;@ def RaftOwnerIdleState(slot: bc)
;@ path: npc/raft_owner
;@ State 0: once the raft is paid he acts as in state 2; otherwise talking to him asks the question
;@ (text $0F0) and state 1 waits for the answer.
RaftOwnerIdleState::
;> if wRaftRented:
	ld a, [wRaftRented]
	and a
;>     RaftOwnerPaidState(slot)
;>     return
	jr nz, RaftOwnerPaidState

;> if ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_52dd

;>     OpenDialog(0xF0)                  # text $0F0: rent the raft?
	ld a, $f0
	call OpenDialog
;>     wEntityState[slot] += 1
	call IncrementEntityState

jr_005_52dd:
	ret


;@ def RaftOwnerAnswerState(slot: bc)
;@ path: npc/raft_owner
;@ State 1, after the question: "no" goes back to state 0. "Yes" with fewer than 100 rupees gets
;@ text $04E and state 0; with enough, 100 rupees are taken (counted down by the rupee display),
;@ wRaftRented is set and he answers text $0F1 (state 2).
RaftOwnerAnswerState::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, jr_005_5308

;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer != 0:                 # no
	ld a, [wDialogAnswer]
	and a
	jr z, jr_005_52ef

;>     wEntityState[slot] = 0
	ld [hl], b
;>     return
	ret


;> if (wRupeeCountHigh << 8 | wRupeeCountLow) < 0x0100:    # BCD: fewer than 100 rupees
jr_005_52ef:
	ld a, [wRupeeCountLow]
	sub $00
	ld a, [wRupeeCountHigh]
	sbc $01
	jr c, jr_005_5309

;>@poor     wEntityState[slot] = 0
;>@poor     OpenDialog(0x4E)                  # text $04E
;>@poor     return
;> wSubtractRupeeBufferLow = 100
	ld a, $64
	ld [wSubtractRupeeBufferLow], a
;> wRaftRented = 0xF1
	ld a, $f1
	ld [wRaftRented], a
;> OpenDialog(0xF1)                       # text $0F1
	call OpenDialog

jr_005_5308:
	ret


jr_005_5309:
;=@poor
	ld [hl], b
	ld a, $4e
	jp OpenDialog


;@ def RaftOwnerPaidState(slot: bc)
;@ path: npc/raft_owner
;@ State 2 (and state 0 while the raft is paid for): talking shows text $0F1.
RaftOwnerPaidState::
;> if ShouldLinkTalkToEntity_05():
	call ShouldLinkTalkToEntity_05
	jr nc, jr_005_5319

;>     OpenDialog(0xF1)                  # text $0F1
	ld a, $f1
	call OpenDialog

jr_005_5319:
	ret


;@ path: npc/raft_owner
;@ The raft's sprites (DrawEntity16x16 format): two variants, tile $5C and $5E each with its mirror (the
;@ water around it changes).
RaftSprites::
	db $5c, $00, $5c, $20,  $5e, $00, $5e, $20

;@ def RaftEntity(slot: bc)
;@ path: npc/raft_owner
;@ The raft on the river. Until it is paid for (wRaftRented) or ridden (wEntityPrivate4) it lies still
;@ as an obstacle, and only one raft may exist in a room. Once rented it bobs; when Link stands right
;@ on it he cannot talk (wCanTalkToEntity $80) and it lines up with him; it then carries him (states
;@ 1-2). Whenever wLinkGroundVfx is set it falls back to state 0.
RaftEntity::
;> if wRaftRented == 0 and wEntityPrivate4[slot] == 0:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [wRaftRented]
	or [hl]
	jr nz, jr_005_5357

;>@dup     for other in range(15, -1, -1):
	ld e, $0f
	ld d, b

;>         if other != slot:
jr_005_532f:
	ld a, e
	cp c
	jr z, jr_005_5345

;>             if wEntityStatus[other]:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_5345

;>                 if wEntityType[other] == 0x6A:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $6a
;>                     ClearEntityStatus_05(slot)  # there is a raft already
;>                     return
	jp z, ClearEntityStatus_05

jr_005_5345:
;=@dup
	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_532f

;>     DrawEntity16x16(slot, RaftSprites)
	ld de, RaftSprites
	call DrawEntity16x16
;>     if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;>     MakeEntitySolid_05()
;>     return
	jp MakeEntitySolid_05


;> frame = (hFrameCounter >> 4) & 1
jr_005_5357:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> if (hLinkX - hActiveEntityX + 0x10) & 0xFF < 0x20:
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
	jr nc, jr_005_5386

;>     if (hLinkY - hActiveEntityY + 0x14) & 0xFF < 0x1C:
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $1c
	jr nc, jr_005_5386

;>         wCanTalkToEntity = 0x80
	ld a, $80
	ld [wCanTalkToEntity], a
;>         wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a

;> if wLinkGroundVfx:
jr_005_5386:
	ld a, [wLinkGroundVfx]
	and a
	jr z, jr_005_5392

;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     LoadEntityPosition(slot); DrawEntity16x16(slot, RaftSprites); return    # the drawing at the end of RaftBoardState
	jr jr_005_53cd

;> RaftStates[hActiveEntityState](slot)
jr_005_5392:
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/raft_owner
;@ The raft's states (wEntityState): 0 waiting for Link to step on, 1 boarding, 2 carrying him.
RaftStates::
	dw RaftWaitState
	dw RaftBoardState
	dw RaftRideState

;@ def RaftWaitState(slot: bc)
;@ path: npc/raft_owner
;@ State 0: when Link stands on the raft (within 8 pixels across, 9 along), boarding starts.
RaftWaitState::
;> if (EntityLinkDiffX_05(slot) + 8) & 0xFF < 0x10:
	call EntityLinkDiffX_05
	add $08
	cp $10
	jr nc, jr_005_53b0

;>     if (EntityLinkDiffY_05(slot) + 9) & 0xFF < 0x12:
	call EntityLinkDiffY_05
	add $09
	cp $12
	jr nc, jr_005_53b0

;>         wEntityState[slot] += 1
	call IncrementEntityState

;> LoadEntityPosition(slot)
;> DrawEntity16x16(slot, RaftSprites)
jr_005_53b0:
	jr jr_005_53cd

;@ def RaftBoardState(slot: bc)
;@ path: npc/raft_owner
;@ State 1: Link is put on the raft (5 pixels above its drawn position), the rental is used up and
;@ the raft is now ridden (wEntityPrivate4).
RaftBoardState::
;> hLinkX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hLinkX], a
;> hLinkY = (hActiveEntityDrawY - 5) & 0xFF
	ldh a, [hActiveEntityDrawY]
	sub $05
	ldh [hLinkY], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityPrivate4[slot] = 1
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], $01
;> wRaftRented = 0
	xor a
	ld [wRaftRented], a

;> hLinkInWater = 1                       # Link counts as on the water
jr_005_53c9:
	ld a, $01
	ldh [hLinkInWater], a

;> LoadEntityPosition(slot)
jr_005_53cd:
	call LoadEntityPosition
;> DrawEntity16x16(slot, RaftSprites)
	ld de, RaftSprites
	jp DrawEntity16x16


;@ def RaftRideState(slot: bc)
;@ path: npc/raft_owner
;@ State 2: the raft carries Link: it moves with him from room to room, stays under him (5 pixels
;@ below his y) and bobs him up and down by a pixel every 16 frames; when Link jumps (motion state 2)
;@ it takes his height.
RaftRideState::
;>@bob wLinkSpriteDY = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@bob
	ld [wLinkSpriteDY], a
;> wEntityRoom[slot] = hMapRoom
	ldh a, [hMapRoom]
	ld hl, wEntityRoom
	add hl, bc
	ld [hl], a
;> wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = (hLinkY + 5) & 0xFF
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	add $05
	ld [hl], a
;> wEntityZ[slot] = 0
	ld hl, wEntityZ
	add hl, bc
	ld [hl], b
;> if wLinkMotionState == 2:
	ld a, [wLinkMotionState]
	cp $02
	jr nz, jr_005_5407

;>     wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld [hl], a

;> hLinkInWater = 1; LoadEntityPosition(slot); DrawEntity16x16(slot, RaftSprites)    # the end of RaftBoardState
jr_005_5407:
	jr jr_005_53c9

;@ def MakeEntitySolid_05(slot: bc)
;@ path: entity/collision
;@ Makes the active entity a solid obstacle: if Link touches it he is put back where he was this
;@ frame (and a Pegasus Boots dash ends), and a hookshot chain that reached it goes back to its
;@ first state.
MakeEntitySolid_05::
;> if not EntityTouchesLink(slot):                    # Link does not touch it
	call EntityTouchesLink
;>     return
	jr nc, jr_005_542b

;> RestoreLinkPosition()
	call RestoreLinkPosition
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> chain = wHookshotChainSlot             # slot + 1, 0 = none
	ld a, [wHookshotChainSlot]
	and a
;> if chain and wEntityType[chain - 1] == 3:   # the hookshot chain
	jr z, jr_005_542b

	ld e, a
	ld d, b
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
;>     # (type 3?)
	cp $03
	jr nz, jr_005_542b

;>     wEntityState[chain - 1] = 0       # the chain starts over (it pulls back)
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00

jr_005_542b:
	ret


;@ path: entity/sprite
;@ First sprite variant of a character's walking pair for each facing (index wEntityDirection):
;@ right 6, left 4, up 2, down 0. Read by AnimateNpcFacing_05.
NpcFacingVariants_05::
	db $06, $04, $02, $00

;@ def AnimateNpcFacing_05(slot: bc)
;@ path: entity/sprite
;@ Sets a character's sprite variant from its facing (NpcFacingVariants_05) and a two-frame walking
;@ animation that changes every 16 frames (wEntityPrivateCounter counts them).
AnimateNpcFacing_05::
;> base = NpcFacingVariants_05[wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, NpcFacingVariants_05
	add hl, de
;> wEntityPrivateCounter[slot] += 1
	push hl
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@frame frame = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
;=@frame
	pop hl
	and $01
;> SetEntitySpriteVariant(slot, base | frame)
	or [hl]
	jp SetEntitySpriteVariant


;@ def ShouldLinkTalkToEntity_05(slot: bc) -> carry
;@ path: npc/talk
;@ Whether Link talks to the active character now: he must stand within 20 pixels above / below and
;@ 16 pixels beside it and face it (any facing for BowWow, type $6D); then wCanTalkToEntity is set
;@ (e = 1 tells the caller he is in place) and carry means A was just pressed while no text box,
;@ inventory, jump or talk cooldown is in the way and the window is hidden.
ShouldLinkTalkToEntity_05::
;> e = 0
	ld e, b
;> if (hLinkY - hActiveEntityY + 0x14) & 0xFF >= 0x28:
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
	cp $28
;>     return False
	jr nc, jr_005_549d

;> if (hLinkX - hActiveEntityX + 0x10) & 0xFF >= 0x20:
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
	cp $20
;>     return False
	jr nc, jr_005_549d

;> e = 1                                  # Link is in place
	inc e
;> if hActiveEntityType != 0x6D:          # BowWow may be talked to from any side
	ldh a, [hActiveEntityType]
	cp $6d
	jr z, jr_005_5478

;>     if GetEntityDirectionToLink_05(slot) != hLinkDirection ^ 1:   # Link must face it
	push de
	call GetEntityDirectionToLink_05
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
;>         return False
	jr nz, jr_005_549d

;> wCanTalkToEntity = 1
jr_005_5478:
	ld hl, wCanTalkToEntity
	ld [hl], $01
;>@busy if wDialogState or wInventoryAppearing or wIsLinkInTheAir or wDialogCooldown:
	ld a, [wDialogState]
	ld hl, wInventoryAppearing
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
;=@busy
	ld hl, wDialogCooldown
	or [hl]
;>     return False
	jr nz, jr_005_549d

;> if wWindowY != 0x80:                   # the window is showing
	ld a, [wWindowY]
	cp $80
;>     return False
	jr nz, jr_005_549d

;> return hJoypadPressed & 0x10 != 0      # A pressed
	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_005_549d

	scf
	ret


;> return False
jr_005_549d:
	and a
	ret


;@ def AnglerRoomHelperEntityHandler(slot: bc)
;@ path: boss/angler_fish
;@ Entity handler of type $67, an invisible helper in the Angler Fish's room: every frame it keeps
;@ its own wEntityDropTimer at $C0 and sets the x where the next falling rock appears ($D202, shared
;@ RAM here called wSmasherSlot) back to $18.
AnglerRoomHelperEntityHandler::
;> wEntityDropTimer[slot] = 0xC0
	call GetEntityDropTimer
	ld [hl], $c0
;> wSmasherSlot = 0x18                    # x of the next falling rock
	ld a, $18
	ld [wSmasherSlot], a
	ret


;@ def AnglerFishEntityHandler(slot: bc)
;@ path: boss/angler_fish
;@ Entity handler of type $65, the Angler Fish (boss of dungeon 4) and its parts, chosen by
;@ wEntityPrivate3: 0 the fish, 1 a falling rock, 2 a bubble, 3 an angler fry.
AnglerFishEntityHandler::
;> AnglerFishParts[wEntityPrivate3[slot]](slot)
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/angler_fish
;@ The Angler Fish's parts (wEntityPrivate3), dispatched by AnglerFishEntityHandler.
AnglerFishParts::
	dw AnglerFishBody
	dw AnglerFallingRock
	dw AnglerBubble
	dw AnglerFry

;@ def AnglerFishBody(slot: bc)
;@ path: boss/angler_fish
;@ The fish itself: draws it (DrawAnglerFish). While it dies (status not 5) it flashes and explodes
;@ (AnglerFishDeathSteps, step in wEntityPrivate2); alive see AnglerFishAlive.
AnglerFishBody::
;> StartBossMusic()
	call StartBossMusic
;> DrawAnglerFish()
	call DrawAnglerFish
;> if hActiveEntityStatus == 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     AnglerFishAlive(slot)
;>     return
	jr z, AnglerFishAlive

;> mem[0xC1C6] = hActiveEntityStatus
	ld [wHookshotOut], a
;> AnglerFishDeathSteps[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/angler_fish
;@ The Angler Fish's death (wEntityPrivate2): 0 start, 1 flashing and exploding.
AnglerFishDeathSteps::
	dw AnglerFishDeathStart
	dw AnglerFishDeathExplode

;@ def AnglerFishDeathStart(slot: bc)
;@ path: boss/angler_fish
;@ Death step 0: $FF frames of flashing, then the shared step code at HotHeadNextDeathStep.
AnglerFishDeathStart::
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> HotHeadNextDeathStep()
	jp HotHeadNextDeathStep


;@ def AnglerFishDeathExplode(slot: bc)
;@ path: boss/angler_fish
;@ Death step 1: it flashes as long as wEntityTimer runs, with explosions (BossExplosionPuffs_05) in the last
;@ $80 frames; at the end SpawnHeartContainer_05 spawns the next entity with an 8-frame death timer.
AnglerFishDeathExplode::
;> t = GetEntityTimer(slot)
;> if t == 0:
	call GetEntityTimer
	jp z, Jump_005_54f2

;>@end     new = SpawnHeartContainer_05(slot)
;>@end     wEntityDyingTimer[new] = 8
;>@end     return
;> wEntityFlashTimer[slot] = t
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> if t < 0x80:
	cp $80
	jr nc, jr_005_54f1

;>     BossExplosionPuffs_05(t)                   # explosions
	call BossExplosionPuffs_05

jr_005_54f1:
	ret


Jump_005_54f2:
;=@end
	call SpawnHeartContainer_05
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $08
	ret


;@ path: boss/angler_fish
;@ Start x of an angler fry, by side: 0 off the left edge ($F8), 1 off the right edge ($A8).
AnglerFryStartX::
	db $f8, $a8

;@ path: boss/angler_fish
;@ Starting x speed of an angler fry, by side: 0 to the right (+8), 1 to the left (-8).
AnglerFrySpeedX::
	db $08, $f8

;@ def AnglerFishAlive(slot: bc)
;@ path: boss/angler_fish
;@ The living Angler Fish. After it hit the wall (wEntityTimer2 running) a rock falls from the ceiling
;@ every 64 frames, at x $18, $38, ... $98 in turn ($D202). Every 128 frames (counter in $D201) a
;@ bubble rises from its mouth; below 10 health, every 256 frames a fry swims in from a random side.
;@ The sword is checked against a hitbox 16 pixels up-left of it (hitbox 0), Link's contact against
;@ hitbox $14. Then the state from AnglerFishStates.
AnglerFishAlive::
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> skip = False
;> if wEntityTimer2[slot] and wEntityTimer2[slot] & 0x3F == 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5554

;>     # (the second half of the test)
	and $3f
	jr nz, jr_005_5554

;>     new = SpawnEntityFromSlot(0x65, 4)          # a falling rock (slots 0-4)
	ld a, $65
	ld e, $04
	call SpawnEntityFromSlot
;>     if new is None:
;>         skip = True                   # no free slot: straight on to the fry check
	jr c, jr_005_5586

;>     else:
;>         wEntityPhysicsFlags[new] = 0x02
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
;>         wEntityHitboxFlags[new] = 0x80
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $80
;>         wEntityOptions1[new] = 0x40
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $40
;>         wEntityPrivate3[new] = 1
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $01
;>         wEntityX[new] = wSmasherSlot  # x of this rock
	ld hl, wEntityX
	add hl, de
	ld a, [wSmasherSlot]
	ld [hl], a
;>         wSmasherSlot = (wSmasherSlot + 0x20) & 0xFF
	add $20
	ld [wSmasherSlot], a
;>         if wSmasherSlot >= 0xA8:
	cp $a8
	jr c, jr_005_5546

;>             wSmasherSlot = 0x08
	ld a, $08
	ld [wSmasherSlot], a

;>         wEntityPrivateCounter[new] = GetRandomByte()
jr_005_5546:
	call GetRandomByte
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], a
;>         wEntityY[new] = 0
	ld hl, wEntityY
	add hl, de
	ld [hl], $00

;> if not skip:
;>     wSmasherBallSlot = (wSmasherBallSlot + 1) & 0xFF     # here a frame counter
jr_005_5554:
	ld a, [wSmasherBallSlot]
	inc a
	ld [wSmasherBallSlot], a
;>     if wSmasherBallSlot & 0x7F == 0:
	and $7f
	jr nz, jr_005_5586

;>         new = SpawnEntityFromSlot(0x65, 4)      # a bubble
	ld a, $65
	ld e, $04
	call SpawnEntityFromSlot
;>         if new is not None:
	jr c, jr_005_5586

;>             wEntityPhysicsFlags[new] = 0x41
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $41
;>             wEntityPrivate3[new] = 2
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $02
;>             wEntityX[new] = (hMultiPurpose0 - 0x14) & 0xFF   # at its mouth
	ldh a, [hMultiPurpose0]
	sub $14
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[new] = (hMultiPurpose1 - 4) & 0xFF
	ldh a, [hMultiPurpose1]
	sub $04
	ld hl, wEntityY
	add hl, de
	ld [hl], a

;> if wEntityHealth[slot] < 0x0A:
jr_005_5586:
	ld hl, wEntityHealth
	add hl, bc
	ld a, [hl]
	cp $0a
	jr nc, jr_005_55e7

;>     if (wSmasherBallSlot + 0x40) & 0xFF == 0:
	ld a, [wSmasherBallSlot]
	add $40
	and $ff
	jr nz, jr_005_55e7

;>         new = SpawnEntityFromSlot(0x65, 4)      # an angler fry
	ld a, $65
	ld e, $04
	call SpawnEntityFromSlot
;>         if new is not None:
	jr c, jr_005_55e7

;>             wEntityHealthGroup[new] = 0
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], d
;>             wEntityPhysicsFlags[new] = 0x02
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
;>             wEntityOptions1[new] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], d
;>             wEntityHealth[new] = 0
	ld hl, wEntityHealth
	add hl, de
	ld [hl], d
;>             wEntityPrivate3[new] = 3
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $03
;>             y = (GetRandomByte() & 0x3F) + 0x20
	call GetRandomByte
	and $3f
	add $20
;>             wEntityY[new] = y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             side = y & 1
	push bc
	and $01
	ld c, a
;>             wEntityX[new] = AnglerFryStartX[side]
	ld hl, AnglerFryStartX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntitySpeedX[new] = AnglerFrySpeedX[side]
	ld hl, AnglerFrySpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>             wEntityTimer[new] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
	pop bc

;> DecrementEntityIgnoreHitsTimer(slot)
jr_005_55e7:
	call DecrementEntityIgnoreHitsTimer
;>@anim wEntitySpriteVariant[slot] = (wEntityPrivateCounter[slot] >> 4) & 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;=@anim
	inc [hl]
	rra
	rra
	rra
	rra
	and $01
;=@anim
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;> wEntityPrivateCounter[slot] += 1
;> hActiveEntityX = (hActiveEntityX - 0x10) & 0xFF
	ldh a, [hActiveEntityX]
	sub $10
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = (hActiveEntityDrawY - 0x10) & 0xFF
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;> wEntityHitboxFlags[slot] = 0x00
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
;> LoadEntityHitbox(slot)                            # load that hitbox
	call LoadEntityHitbox
;> EntityCheckWeaponHits(slot)                            # sword hits on it
	call EntityCheckWeaponHits
;> LoadEntityPosition(slot)                            # its real position again
	call LoadEntityPosition
;> wEntityHitboxFlags[slot] = 0x14
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $14
;> LoadEntityHitbox(slot)
	call LoadEntityHitbox
;> EntityCheckContactDamage(slot)                            # hurts Link on contact
	call EntityCheckContactDamage
;> AnglerFishStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/angler_fish
;@ The Angler Fish's states (wEntityState): 0 swimming up and down, 1 charging at the left wall,
;@ 2 swimming back.
AnglerFishStates::
	dw AnglerSwimState
	dw AnglerChargeState
	dw AnglerReturnState

;@ path: boss/angler_fish
;@ The Angler Fish's y speed by its swimming direction (wEntityDirection 0 down +8, 1 up -8).
AnglerSwimSpeedY::
	db $08, $f8

;@ path: boss/angler_fish
;@ The drawn y at which it turns, by direction: going down it turns at $60, going up at $18.
AnglerTurnY::
	db $60, $18

;@ def AnglerSwimState(slot: bc)
;@ path: boss/angler_fish
;@ State 0: swims up and down between y $18 and $60 until wEntityDropTimer runs out; then it remembers
;@ an x of $60-$7F to come back to (wEntityPrivate1) and charges (state 1, wEntityTimer $80).
AnglerSwimState::
;> if GetEntityDropTimer(slot) == 0:
	call GetEntityDropTimer
	jr nz, jr_005_5649

;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>@back     wEntityPrivate1[slot] = (GetRandomByte() & 0x1F) + 0x60
	call GetRandomByte
	and $1f
	add $60
	ld hl, wEntityPrivate1
	add hl, bc
;=@back
	ld [hl], a
;>     return
	ret


;> d = wEntityDirection[slot]
jr_005_5649:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;> if hActiveEntityDrawY == AnglerTurnY[d]:
	ld hl, AnglerTurnY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	cp [hl]
	jr nz, jr_005_5660

;>     wEntityDirection[slot] = d ^ 1    # turn round
	ld a, e
	xor $01
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

;> wEntitySpeedY[slot] = AnglerSwimSpeedY[d]
jr_005_5660:
	ld hl, AnglerSwimSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> AddEntitySpeedToPosY_05(slot)
	call AddEntitySpeedToPosY_05
	ret


;@ def AnglerChargeState(slot: bc)
;@ path: boss/angler_fish
;@ State 1: it opens and shuts its mouth fast; at wEntityTimer $60 it roars, then darts left at speed
;@ -$30 until x < $18: it hits the wall, the screen shakes for $30 frames with a clink, and rocks
;@ start falling (wEntityTimer2 $FF). State 2.
AnglerChargeState::
;> wEntityPrivateCounter[slot] += 2
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0x60:
	cp $60
	jr nz, jr_005_5681

;>     hWaveSfx = 0x0D                   # roar
	ld hl, hWaveSfx
	ld [hl], $0d

;> if t >= 0x60:
jr_005_5681:
;>     return
	jr nc, jr_005_56a7

;> wEntitySpeedX[slot] = 0xD0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $d0
;> AddEntitySpeedToPosX_05(slot)
	call AddEntitySpeedToPosX_05
;> if hActiveEntityX < 0x18:              # hit the wall
	ldh a, [hActiveEntityX]
	cp $18
	jr nc, jr_005_56a7

;>     wBumpShakeTimer = 0x30
	ld a, $30
	ld [wBumpShakeTimer], a
;>     wBumpShakeAxis = 0
	xor a
	ld [wBumpShakeAxis], a
;>     PlayClinkNoise()
	call PlayClinkNoise
;>     wEntityTimer2[slot] = 0xFF        # rocks fall
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $ff
;>     wEntityState[slot] += 1
	call IncrementEntityState

jr_005_56a7:
	ret


;@ def AnglerReturnState(slot: bc)
;@ path: boss/angler_fish
;@ State 2: once the screen stops shaking it swims back right (speed $20) to its x in
;@ wEntityPrivate1, then swims up and down again for 64-95 frames (state 0).
AnglerReturnState::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc [hl]
;> if wBumpShakeTimer:
	ld a, [wBumpShakeTimer]
	and a
;>     return
	jr nz, jr_005_56d5

;> wEntitySpeedX[slot] = 0x20
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $20
;> AddEntitySpeedToPosX_05(slot)
	call AddEntitySpeedToPosX_05
;> if hActiveEntityX >= wEntityPrivate1[slot]:
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hActiveEntityX]
	cp [hl]
	jr c, jr_005_56d5

;>     wEntityDropTimer[slot] = (GetRandomByte() & 0x1F) + 0x40
	call GetEntityDropTimer
	call GetRandomByte
	and $1f
	add $40
	ld [hl], a
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b

jr_005_56d5:
	ret


;@ path: boss/angler_fish
;@ The Angler Fish, sprite list set A: 2 variants of 20 entries of 4 bytes for DrawEntitySprites (y offset, x
;@ offset, tile, attributes; $10 = sprite palette 1), drawn 19 entries at a time; the 20th entry of
;@ variant 0 is a hidden one (tile $FF). A 56x48 picture of 7 x 3 tiles of 8x16. The two variants
;@ differ in 4 tiles (mouth and fins): $40/$4C/$58/$64 against $66/$68/$6A/$6C.
AnglerFishSpritesA::
	db $f0, $f0, $40, $00,  $f0, $f8, $42, $00,  $f0, $00, $44, $00,  $f0, $08, $46, $10
	db $f0, $10, $48, $10,  $f0, $18, $4a, $10,  $00, $f0, $4c, $00,  $00, $f8, $4e, $00
	db $00, $00, $50, $10,  $00, $08, $52, $10,  $00, $10, $54, $10,  $00, $18, $56, $10
	db $00, $20, $58, $10,  $10, $f8, $5a, $10,  $10, $00, $5c, $10,  $10, $08, $5e, $10
	db $10, $10, $60, $10,  $10, $18, $62, $10,  $10, $20, $64, $10,  $00, $00, $ff, $00
	db $f0, $f0, $66, $00,  $f0, $f8, $42, $00,  $f0, $00, $44, $00,  $f0, $08, $46, $10
	db $f0, $10, $48, $10,  $f0, $18, $4a, $10,  $00, $f0, $68, $00,  $00, $f8, $4e, $00
	db $00, $00, $50, $10,  $00, $08, $52, $10,  $00, $10, $54, $10,  $00, $18, $56, $10
	db $00, $20, $6a, $10,  $10, $f8, $5a, $10,  $10, $00, $5c, $10,  $10, $08, $5e, $10
	db $10, $10, $60, $10,  $10, $18, $62, $10,  $10, $20, $6c, $10

;@ path: boss/angler_fish
;@ The Angler Fish, sprite list set B: the same 2 pictures as AnglerFishSpritesA with the entries in
;@ another order (DrawAnglerFish alternates the sets every frame, so that when too many sprites share
;@ a line a different part flickers each frame). Variant 0's 20th entry is hidden.
AnglerFishSpritesB::
	db $f0, $18, $4a, $10
	db $f0, $08, $46, $10,  $f0, $10, $48, $10,  $f0, $f8, $42, $00,  $f0, $00, $44, $00
	db $f0, $f0, $40, $00,  $00, $20, $58, $10,  $00, $08, $52, $10,  $00, $10, $54, $10
	db $00, $18, $56, $10,  $00, $f8, $4e, $00,  $00, $00, $50, $10,  $00, $f0, $4c, $00
	db $10, $20, $64, $10,  $10, $10, $60, $10,  $10, $18, $62, $10,  $10, $00, $5c, $10
	db $10, $08, $5e, $10,  $10, $f8, $5a, $10,  $00, $00, $ff, $00,  $f0, $18, $4a, $10
	db $f0, $08, $46, $10,  $f0, $10, $48, $10,  $f0, $f8, $42, $00,  $f0, $00, $44, $00
	db $f0, $f0, $66, $00,  $00, $20, $6a, $10,  $00, $08, $52, $10,  $00, $10, $54, $10
	db $00, $18, $56, $10,  $00, $f8, $4e, $00,  $00, $00, $50, $10,  $00, $f0, $68, $00
	db $10, $20, $6c, $10,  $10, $10, $60, $10,  $10, $18, $62, $10,  $10, $00, $5c, $10
	db $10, $08, $5e, $10,  $10, $f8, $5a, $10

;@ def DrawAnglerFish()
;@ path: boss/angler_fish
;@ Draws the Angler Fish's current variant (80 bytes each) from sprite set A on even frames and B on
;@ odd frames: 19 sprites, and reserves 19 sprite entries.
DrawAnglerFish::
;>@off offset = 80 * hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
	sla a
	sla a
	sla a
	sla a
	ld e, a
;=@off
	sla a
	sla a
	add e
	ld e, a
	ld d, b
;> sprites = AnglerFishSpritesA
	ld hl, AnglerFishSpritesA
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
	jr z, jr_005_582c

;>     sprites = AnglerFishSpritesB
	ld hl, AnglerFishSpritesB

;> DrawEntitySprites(19, sprites + offset)
jr_005_582c:
	add hl, de
	ld c, $13
	call DrawEntitySprites
;> ReserveOAMEntriesFar(19)
	ld a, $13
	call ReserveOAMEntriesFar
	ret


;@ path: boss/angler_fish
;@ A bubble from the Angler Fish's mouth: 2 variants for DrawEntity8x16 (tile, attributes): tile $72 and
;@ its mirror.
AnglerBubbleSprites::
	db $72, $00,  $72, $20

;@ def AnglerBubble(slot: bc)
;@ path: boss/angler_fish
;@ Part 2, a bubble: it wobbles (mirrored every 8 frames) and rises in spurts (speed -8 for 48 of
;@ every 64 frames) until it reaches the top (drawn y < $10).
AnglerBubble::
;> DrawEntity8x16(slot, AnglerBubbleSprites)
	ld de, AnglerBubbleSprites
	call DrawEntity8x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@wob SetEntitySpriteVariant(slot, (wEntityPrivateCounter[slot] >> 3) & 1)
	ld a, [hl]
	rra
	rra
	rra
	and $01
;=@wob
	call SetEntitySpriteVariant
;> if wEntityPrivateCounter[slot] & 0x30:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $30
	jr z, jr_005_5865

;>     wEntitySpeedY[slot] = 0xF8
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f8
;>     AddEntitySpeedToPosY_05(slot)
	call AddEntitySpeedToPosY_05

;> if hActiveEntityDrawY < 0x10:
jr_005_5865:
	ldh a, [hActiveEntityDrawY]
	cp $10
;>     ClearEntityStatus_05(slot)
	jp c, ClearEntityStatus_05

	ret


;@ path: boss/angler_fish
;@ A rock falling from the ceiling: 2 DrawEntity16x16 variants (tiles $74/$76, then mirrored).
AnglerRockSprites::
	db $74, $00, $76, $00,  $76, $20, $74, $20

;@ def AnglerFallingRock(slot: bc)
;@ path: boss/angler_fish
;@ Part 1, a falling rock: falls at speed $0C, swaying left and right (x speed -4 / +4 for 16 frames
;@ each, mirrored with it), hurts Link and can be hit; gone at the bottom (drawn y >= $8B).
AnglerFallingRock::
;> DrawEntity16x16(slot, AnglerRockSprites)
	ld de, AnglerRockSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> n = wEntityPrivateCounter[slot]
	ld a, [hl]
	push af
;> SetEntitySpriteVariant(slot, (n >> 4) & 1)
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> EntityCheckHits(slot)                            # touches Link / sword hits
	call EntityCheckHits
;> sx = 0xFC
	pop af
	ld e, $fc
;> if n & 0x10:
	and $10
	jr z, jr_005_589d

;>     sx = 0x04
	ld e, $04

;> wEntitySpeedX[slot] = sx
jr_005_589d:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;> wEntitySpeedY[slot] = 0x0C
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $0c
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if hActiveEntityDrawY >= 0x8B:
	ldh a, [hActiveEntityDrawY]
	cp $8b
;>     ClearEntityStatus_05(slot)
	jp nc, ClearEntityStatus_05

	ret


;@ path: boss/angler_fish
;@ An angler fry: 2 DrawEntity16x16 variants (tiles $78/$7A and $7C/$7E), mirrored by AnglerFry when it
;@ swims right.
AnglerFrySprites::
	db $78, $00, $7a, $00,  $7c, $00, $7e, $00

;@ path: boss/angler_fish
;@ How much an angler fry's y speed changes every 4 frames, by wEntityState & 1 (0: +1, 1: -1).
AnglerFrySpeedStep::
	db $01, $ff

;@ path: boss/angler_fish
;@ The y speed at which a fry turns its wave round, by wEntityState & 1 (0: +8, 1: -8).
AnglerFrySpeedLimit::
	db $08, $f8

;@ def AnglerFry(slot: bc)
;@ path: boss/angler_fish
;@ Part 3, an angler fry: swims across the screen in a wave (y speed swinging between -8 and +8),
;@ facing its way, flapping every 16 frames; it hurts Link and can be hit. Once its wEntityTimer has
;@ run out it disappears at the right edge (x >= $A8).
AnglerFry::
;>@flip hActiveEntityFlipAttribute = 0x20 if wEntitySpeedX[slot] & 0x80 == 0 else 0    # mirrored when going right
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	rra
	rra
;=@flip
	and $20
	ldh [hActiveEntityFlipAttribute], a
;> DrawEntity16x16(slot, AnglerFrySprites)
	ld de, AnglerFrySprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_5909

;>     w = wEntityState[slot] & 1
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	and $01
	ld e, a
	ld d, b
;>@sy     wEntitySpeedY[slot] = (wEntitySpeedY[slot] + AnglerFrySpeedStep[w]) & 0xFF
	ld hl, AnglerFrySpeedStep
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
;=@sy
	add [hl]
	ld [hl], a
;>     if wEntitySpeedY[slot] == AnglerFrySpeedLimit[w]:
	ld hl, AnglerFrySpeedLimit
	add hl, de
	cp [hl]
	jr nz, jr_005_5909

;>         wEntityState[slot] += 1       # swing the other way
	call IncrementEntityState

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_5909:
	call UpdateEntityPosWithSpeed_05
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_5918

;>     if hActiveEntityX >= 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>         ClearEntityStatus_05(slot)
	jp nc, ClearEntityStatus_05

jr_005_5918:
	ret


;@ path: gfx/tiles
;@ Two background tiles (2 bits per pixel) for a background change: the routine at Jump_000_3fbd
;@ copies the first to $8460 and the second to $8480 (BGChangeTilesB is the other form).
;@ asset: tiles bpp=2 length=$20
BGChangeTilesA::
	db $07, $00, $0f, $07, $1e, $0f, $3f, $18, $3f, $10, $3f, $14, $3f, $10, $27, $1b
	db $e0, $00, $f0, $e0, $18, $f0, $8c, $78, $8c, $70, $3f, $c0, $ff, $3e, $ef, $f1
;@ path: gfx/tiles
;@ The other form of the two tiles at $8460 / $8480, copied by Jump_000_3fd3.
;@ asset: tiles bpp=2 length=$20
BGChangeTilesB::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $07, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $00, $ff, $3e, $ef, $f1
;@ def EvilEagleArenaSetup(slot: bc)
;@ path: boss/evil_eagle
;@ Called from bank 0 (through a trampoline there) when the fight on top of Eagle's Tower is set
;@ up again: all other entities (slots 2-15) are removed and this one becomes non-hittable. If the
;@ fight had started already (wEvilEagleFightStarted) the Evil Eagle is spawned at once in its
;@ "choose an attack" state with $60 frames to wait, this entity goes to state 4 and slot 0 is put
;@ off screen. Otherwise the fight is marked started, 12 bytes at $D790 are cleared, the attack is set
;@ to 2 and music $5C starts.
EvilEagleArenaSetup::
;> wEntityOptions1[slot] &= 0x7F
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $7f
	ld [hl], a
;>@clr for other in range(15, 1, -1):
	ld e, $0f
	ld d, b

;>     wEntityStatus[other] = 0
.clear
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b
;=@clr
	dec e
	ld a, e
	cp $01
	jr nz, .clear

;> if wEvilEagleFightStarted:
	ld a, [wEvilEagleFightStarted]
	and a
	jr z, .first

;>     SwitchBank(5)
	ld a, $05
	call SwitchBank
;>     new = EvilEagleSpawn()
	call EvilEagleSpawn
;>     wEntityState[new] = 7
	ld hl, wEntityState
	add hl, de
	ld [hl], $07
;>     wEntityTimer[new] = 0x60
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60
;>     hBGChangeRequest = 1
	ld a, $01
	ldh [hBGChangeRequest], a
;>     wEntityState[slot] = 4            # (EvilEagleSpawn advanced it already)
	call IncrementEntityState
	ld [hl], $04
;>     wEntityY[0] = 0xC0
	ld a, $c0
	ld [wEntityY], a
;>     return
	ret

;> hBGChangeRequest = 2
.first
	ld a, $02
	ldh [hBGChangeRequest], a
;> wEvilEagleFightStarted = 2
	ld [wEvilEagleFightStarted], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> for i in range(12): mem[0xD790 + i] = 0
	ld e, $0c
	xor a
	ld hl, $d790

.zero
	ld [hli], a
	dec e
	jr nz, .zero

;> wEvilEagleAttack = 2
	ld a, $02
	ld [wEvilEagleAttack], a
;> wMusicTrackToPlay = 0x5C
	ld a, $5c
	ld [wMusicTrackToPlay], a
	ret
;@ path: boss/evil_eagle
;@ x offsets of the Grim Creeper's two bats from him, read as EvilEagleSpawnOffsetX[n - 1] for bat
;@ n = 1, 2: +16 and -16.
EvilEagleSpawnOffsetX::
	db $10, $f0

;@ def EvilEagleEntityHandler(slot: bc)
;@ path: boss/evil_eagle
;@ Entity handler of type $63, the fight on top of Eagle's Tower, by wEntityPrivate1: 0 the Grim
;@ Creeper who calls the Evil Eagle, 1 the Evil Eagle, 2 one of the Grim Creeper's bats, 3 a
;@ feather shot by the eagle.
EvilEagleEntityHandler::
;> EvilEagleParts[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/evil_eagle
;@ The parts of the Eagle's Tower fight (wEntityPrivate1).
EvilEagleParts::
	dw GrimCreeper
	dw EvilEagle
	dw GrimCreeperBat
	dw EvilEagleFeather

;@ def GrimCreeper(slot: bc)
;@ path: boss/evil_eagle
;@ The Grim Creeper on the tower top: runs his state.
GrimCreeper::
;> GrimCreeperStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ def GrimCreeperStates(slot: bc)
;@ path: boss/evil_eagle
;@ The Grim Creeper's states (wEntityState): 0 arriving with his bats, 1 calling the eagle, 2 waiting,
;@ 3 blown off the tower (falling), 4 gone. States 3 and 4 are set by the Evil Eagle. The `ret` after
;@ the table is the early exit of GrimCreeperArriveState.
GrimCreeperStates::
	dw GrimCreeperArriveState
	dw GrimCreeperCallEagleState
	dw GrimCreeperWaitState
	dw GrimCreeperFallState
	dw GrimCreeperGoneState

;> return                                 # early exit of GrimCreeperArriveState
jr_005_59d6:
	ret


;@ def GrimCreeperArriveState(slot: bc)
;@ path: boss/evil_eagle
;@ State 0: drawn; on his first active frame he spawns his two bats (type $63, part 2) 16 pixels to
;@ either side and above him, then waits $43 frames (state 1).
GrimCreeperArriveState::
;> DrawGrimCreeper()
	call DrawGrimCreeper
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return
	jr nz, jr_005_59d6

;>@bat for n in (2, 1):
	ld a, $02

;>     new = SpawnEntity(0x63)
jr_005_59e2:
	ldh [hBGTilesRequestCopy], a
	ld a, $63
	call SpawnEntity
;>@bx     wEntityX[new] = (hMultiPurpose0 + EvilEagleSpawnOffsetX[n - 1]) & 0xFF
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, EvilEagleSpawnOffsetX - 1
	add hl, bc
;=@bx
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[new] = (hMultiPurpose1 - 0x10) & 0xFF
	ldh a, [hMultiPurpose1]
	sub $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	pop bc
;>     wEntityPrivate1[new] = 2          # a bat
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;=@bat
	ldh a, [hBGTilesRequestCopy]
	dec a
	jr nz, jr_005_59e2

;> wEntityTimer[slot] = 0x43
	call GetEntityTimer
	ld [hl], $43
;> wEntityState[slot] += 1
	jp IncrementEntityState


;@ def GrimCreeperCallEagleState(slot: bc)
;@ path: boss/evil_eagle
;@ State 1: Link cannot move. At wEntityTimer $20 the Grim Creeper speaks (text $0BA, with Link's y
;@ set to $10 for that moment so that the box opens at the bottom). When the timer runs out the boss
;@ music ($54) starts and the Evil Eagle arrives from the right; state 2.
GrimCreeperCallEagleState::
;> DrawGrimCreeper()
	call DrawGrimCreeper
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t != 0:
	and a
	jr z, jr_005_5a3a

;>     if t != 0x20:
	cp $20
;>         return
	jr nz, jr_005_5a75

;>     link_y = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkY = 0x10
	ld a, $10
	ldh [hLinkY], a
;>     OpenDialog(0xBA)                  # text $0BA
	ld a, $ba
	call OpenDialog
;>     hLinkY = link_y
	pop af
	ldh [hLinkY], a
;>     return
	ret


;> wMusicTrackToPlay = 0x54
jr_005_5a3a:
	ld a, $54
	ld [wMusicTrackToPlay], a
; EvilEagleArenaSetup calls in here too: it spawns the Evil Eagle and advances this entity's state.
EvilEagleSpawn:
;> new = SpawnEntity(0x63)                 # (EvilEagleSpawn starts here)
	ld a, $63
	call SpawnEntity
;> wEntityHealth[new] = 0x0C
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $0c
;> wEntityX[new] = 0xD0                   # off the right edge
	ld hl, wEntityX
	add hl, de
	ld [hl], $d0
;> wEntityY[new] = 0x18
	ld hl, wEntityY
	add hl, de
	ld [hl], $18
;> wEntityPrivate1[new] = 1               # the eagle
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntitySpeedX[new] = 0xE0
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e0
;> wEntityDirection[new] = 0
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $00
;> wEntityTimer[new] = 0x80
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $80
;> EvilEagleScreech()
	call EvilEagleScreech
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


jr_005_5a75:
	ret


;@ def GrimCreeperWaitState(slot: bc)
;@ path: boss/evil_eagle
;@ State 2: just drawn, while the eagle makes its first passes.
GrimCreeperWaitState::
;> DrawGrimCreeper()
	call DrawGrimCreeper
	ret


;@ def GrimCreeperFallState(slot: bc)
;@ path: boss/evil_eagle
;@ State 3: the eagle's gust blows him off the tower: he moves with his speed and falls faster and
;@ faster (y speed + 2 a frame).
GrimCreeperFallState::
;> DrawGrimCreeper()
	call DrawGrimCreeper
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> wEntitySpeedY[slot] = (wEntitySpeedY[slot] + 2) & 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	inc [hl]
	ret


;@ def GrimCreeperGoneState(slot: bc)
;@ path: boss/evil_eagle
;@ State 4: off the screen; only its physics flags are set to $C2.
GrimCreeperGoneState::
;> wEntityPhysicsFlags[slot] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
	ret


;@ path: boss/evil_eagle
;@ The Grim Creeper's picture: 2 DrawEntity16x16 variants, each tile $7E twice (left and mirrored right);
;@ variant 1 is the same upside down (attributes $40 / $60).
GrimCreeperSprites::
	db $7e, $00, $7e, $20,  $7e, $40, $7e, $60

;@ def DrawGrimCreeper(slot: bc)
;@ path: boss/evil_eagle
;@ Draws the Grim Creeper (GrimCreeperSprites).
DrawGrimCreeper::
;> DrawEntity16x16(slot, GrimCreeperSprites)
	ld de, GrimCreeperSprites
	call DrawEntity16x16
	ret


;@ path: boss/evil_eagle
;@ The Evil Eagle's next attack after each hit (index = hits taken 1-7, wEntityPrivate3; entry 0 is
;@ the first attack), stored in wEvilEagleAttack: 0 swoop down from the top, 1 / 4 drop from above,
;@ 2 / 3 fly across and blow (the gust with feathers). Read by EvilEagle and EvilEagleChooseAttack.
EvilEagleAttackByHits::
	db $02, $02, $02, $00, $01, $00, $01, $04, $04, $04, $04

;@ def EvilEagle(slot: bc)
;@ path: boss/evil_eagle
;@ The Evil Eagle (boss of Eagle's Tower). Drawn by DrawEvilEagle; once defeated BossDefeatedHandler_05
;@ runs. A hit (wEntityFlashTimer set) outside its hurt state makes it flash for $50 frames and
;@ shriek, stop, and go to the hurt state $0E; the hit count (wEntityPrivate3, up to 7) picks its next
;@ attack from EvilEagleAttackByHits. Otherwise the state from EvilEagleStates.
EvilEagle::
;> DrawEvilEagle(slot)
	call DrawEvilEagle
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     BossDefeatedHandler_05(slot)
;>     return
	jp nz, BossDefeatedHandler_05

;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> if hActiveEntityState != 0x0E and wEntityFlashTimer[slot]:     # just hit
	ldh a, [hActiveEntityState]
	cp $0e
	jr z, jr_005_5af7

	ld hl, wEntityFlashTimer
	add hl, bc
;>     # (the flash timer)
	ld a, [hl]
	and a
	jr z, jr_005_5af7

;>     wEntityFlashTimer[slot] = 0x50
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $50
;>     ClearEntitySpeed(slot)                       # stop
	call ClearEntitySpeed
;>     wEntityState[slot] = 0x0E
	call IncrementEntityState
	ld [hl], $0e
;>     hNoiseSfx = 0x31
	ld a, $31
	ldh [hNoiseSfx], a
;>     wEntityPhysicsFlags[slot] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
;>     hits = wEntityPrivate3[slot] + 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld a, [hl]
;>     wEntityPrivate3[slot] = min(hits, 7)
	cp $08
	jr nz, jr_005_5aec

	dec [hl]

;>     wEvilEagleAttack = EvilEagleAttackByHits[hits]
jr_005_5aec:
	ld e, a
	ld d, b
	ld hl, EvilEagleAttackByHits
	add hl, de
	ld a, [hl]
	ld [wEvilEagleAttack], a
;>     return
	ret


;> EvilEagleStates[hActiveEntityState](slot)
jr_005_5af7:
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/evil_eagle
;@ The Evil Eagle's states (wEntityState): 0-1 the two passes over the tower, 2 slowing down, 3 the
;@ gust that blows the Grim Creeper away, 4-5 hovering, 6 flying off, 7 choosing an attack, 8 swoop,
;@ 9 blowing wind and feathers, $0A flying off after it, $0B drop from above, $0C dive at Link,
;@ $0D flying across, $0E hurt.
EvilEagleStates::
	dw EvilEagleFlyInState
	dw EvilEagleTurnState
	dw EvilEagleSlowDownState
	dw EvilEagleGustState
	dw EvilEagleClearTowerState
	dw EvilEagleHoverState
	dw EvilEagleLeaveState
	dw EvilEagleChooseAttack
	dw EvilEagleSwoopState
	dw EvilEagleBlowState
	dw EvilEagleFlyOffState
	dw EvilEagleDropState
	dw EvilEagleDiveState
	dw EvilEagleCrossState
	dw EvilEagleHurtState

;@ def EvilEagleFlyInState(slot: bc)
;@ path: boss/evil_eagle
;@ State 0: flies across the screen; when wEntityTimer runs out it hides (variant $FF) for $20 frames
;@ (state 1).
EvilEagleFlyInState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_5b2d

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     SetEntitySpriteVariant(slot, 0xFF)                   # not drawn
	ld a, $ff
	call SetEntitySpriteVariant

jr_005_5b2d:
	ret


;@ def EvilEagleTurnState(slot: bc)
;@ path: boss/evil_eagle
;@ State 1: after the pause it comes back the other way 20 pixels lower (speed and facing reversed).
;@ After the second pass (wEntityPrivate2 = 2) it slows down (state 2, $30 frames, noise $30);
;@ otherwise another pass (state 0, $80 frames) with its screech.
EvilEagleTurnState::
;> if GetEntityTimer(slot) != 0:
	call GetEntityTimer
;>     return
	jr nz, jr_005_5b66

;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> wEntityY[slot] = (wEntityY[slot] + 0x14) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $14
	ld [hl], a
;> wEntitySpeedX[slot] = (-wEntitySpeedX[slot]) & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> wEntityDirection[slot] ^= 4
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
;> wEntityPrivate2[slot] += 1             # passes made
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
;> if wEntityPrivate2[slot] == 2:
	ld a, [hl]
	cp $02
	jr z, jr_005_5b67

;>     wEntityState[slot] += 1; wEntityTimer[slot] = 0x30; hNoiseSfx = 0x30; return   # code after EvilEagleScreech
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> EvilEagleScreech()                     # runs on into it

;@ def EvilEagleScreech(slot: bc)
;@ path: boss/evil_eagle
;@ The Evil Eagle's screech (noise effect $22).
EvilEagleScreech::
;> hNoiseSfx = 0x22
	ld a, $22
	ldh [hNoiseSfx], a

jr_005_5b66:
	ret


jr_005_5b67:
;> # second pass of the Evil Eagle's turn (EvilEagleTurnState)
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;> hNoiseSfx = 0x30
	ld a, $30
	ldh [hNoiseSfx], a
;> return
	ret


;@ def EvilEagleSlowDownState(slot: bc)
;@ path: boss/evil_eagle
;@ State 2: keeps flying (a jingle 1 frame before the timer ends), then brakes (x speed +1 a frame)
;@ until it hovers; then the Grim Creeper's bats (slots 14 and 15) leave and the gust comes after
;@ $40 frames (state 3). Flaps meanwhile.
EvilEagleSlowDownState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 1:
	cp $01
	jr nz, jr_005_5b83

;>     hJingle = 0x30
	ld hl, hJingle
	ld [hl], $30

;> if t != 0:
jr_005_5b83:
	and a
;>     return
	jr nz, jr_005_5b9e

;> wEntitySpeedX[slot] = (wEntitySpeedX[slot] + 1) & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	inc [hl]
;> if wEntitySpeedX[slot] == 0:
	jr nz, jr_005_5b9b

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     wEntityState[14] += 1             # the bats fly away
	ld hl, wEntityState + 14
	inc [hl]
;>     wEntityState[15] += 1
	inc hl
	inc [hl]

;> EvilEagleFlap(slot)
jr_005_5b9b:
	call EvilEagleFlap

jr_005_5b9e:
	ret


;@ def EvilEagleGustState(slot: bc)
;@ path: boss/evil_eagle
;@ State 3: Link cannot move; when the timer runs out the wing beat blows the Grim Creeper (slot 0)
;@ off the tower (speed x $12, y -$30, his state 3) with jingle $24, and $28 frames follow (state 4).
EvilEagleGustState::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if GetEntityTimer(slot) != 0:
	call GetEntityTimer
;>     EvilEagleFlap(slot)
;>     return
	jr nz, EvilEagleFlap

;> wEntityTimer[slot] = 0x28
	ld [hl], $28
;> wEntitySpeedY[0] = 0xD0                # the Grim Creeper
	ld a, $d0
	ld [wEntitySpeedY], a
;> hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
;> wEntitySpeedX[0] = 0x12
	ld a, $12
	ld [wEntitySpeedX], a
;> wEntityState[0] += 1                   # falls
	ld hl, wEntityState
	inc [hl]
;> wEntityState[slot] += 1
	call IncrementEntityState
;> EvilEagleFlap(slot)                    # runs on into it

;@ def EvilEagleFlap(slot: bc)
;@ path: boss/evil_eagle
;@ Slow wing beat: sprite variant 1 or 2, changing every 4 frames.
EvilEagleFlap::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> v = 1
	ld a, [hl]
	and $04
	ld a, $01
;> if wEntityPrivateCounter[slot] & 4:
	jr z, jr_005_5bcc

;>     v = 2
	inc a

;> SetEntitySpriteVariant(slot, v)
jr_005_5bcc:
	call SetEntitySpriteVariant
	ret


;@ def EvilEagleClearTowerState(slot: bc)
;@ path: boss/evil_eagle
;@ State 4: when the timer runs out the background changes (request 1), the Grim Creeper goes to his
;@ last state and off screen (y $C0); $20 more frames (state 5).
EvilEagleClearTowerState::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_5beb

;>     hBGChangeRequest = 1
	ld a, $01
	ldh [hBGChangeRequest], a
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityState[0] += 1
	ld hl, wEntityState
	inc [hl]
;>     wEntityY[0] = 0xC0
	ld a, $c0
	ld [wEntityY], a

;> EvilEagleFlap(slot)
jr_005_5beb:
	jp EvilEagleFlap


;@ path: boss/evil_eagle
;@ The Evil Eagle's fast wing beat: the sprite variant for each 8-frame step (EvilEagleFlapWings).
EvilEagleFlapFrames::
	db $01, $02, $03, $02

;@ def EvilEagleHoverState(slot: bc)
;@ path: boss/evil_eagle
;@ State 5: Link still cannot move; hovers flapping until the timer runs out (state 6).
EvilEagleHoverState::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, EvilEagleFlapWings

;>     wEntityState[slot] += 1
	call IncrementEntityState

;> EvilEagleFlapWings(slot)               # runs on into it

;@ def EvilEagleFlapWings(slot: bc)
;@ path: boss/evil_eagle
;@ Fast wing beat: each call advances wEntityPrivateCounter and shows the EvilEagleFlapFrames step
;@ (callers call it 2 or 3 times a frame to beat faster).
EvilEagleFlapWings::
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> step = (wEntityPrivateCounter[slot] >> 3) & 3
	ld a, [hl]
	rra
	rra
	rra
	nop
	and $03
;> f = EvilEagleFlapFrames[step]
	ld e, a
	ld d, b
	ld hl, EvilEagleFlapFrames
	add hl, de
	ld a, [hl]
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
	ret


;@ def EvilEagleLeaveState(slot: bc)
;@ path: boss/evil_eagle
;@ State 6: accelerates to the left (x speed down by 2 a frame, beating fast) up to -$2C, then glides
;@ climbing until its x is $C0-$C7 (off the left edge); then it waits $80 frames (state 7).
EvilEagleLeaveState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if wEntitySpeedX[slot] == 0xD4:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $d4
	jr nz, jr_005_5c42

;>     if hActiveEntityX & 0xF8 == 0xC0:
	ldh a, [hActiveEntityX]
	and $f8
	cp $c0
	jr nz, jr_005_5c32

;>         wEntityState[slot] += 1
	call IncrementEntityState
;>         wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>         return
	ret


;>     wEntitySpeedY[slot] -= 1          # (the frame test `& 0` is always true)
jr_005_5c32:
	ldh a, [hFrameCounter]
	and $00
	jr nz, jr_005_5c3d

	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

;>     SetEntitySpriteVariant(slot, 0)
;>     return
jr_005_5c3d:
	xor a
	call SetEntitySpriteVariant
	ret


;> wEntitySpeedX[slot] -= 2
jr_005_5c42:
	dec [hl]
	dec [hl]
;> EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;> EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;> EvilEagleFlapWings(slot)
	jp EvilEagleFlapWings


;@ path: boss/evil_eagle
;@ Start values of the Evil Eagle's attacks, 7 pairs indexed by side 0/1 (the side is chosen from
;@ Link's x or at random): +0 swoop start x ($F8 left edge / $A8 right edge), +2 swoop x speed ($30 /
;@ -$30), +4 drop x ($30 / $70), +6 dive x speed ($DC / $24, by the facing), +8 blow start x ($F8 /
;@ $A8), +10 blow x speed ($20 / -$20), +12 facing (4 = to the right, 0 = to the left).
EvilEagleAttackTable::
	db $f8, $a8,  $30, $d0,  $30, $70,  $dc, $24,  $f8, $a8,  $20, $e0,  $04, $00

;@ def EvilEagleChooseAttack(slot: bc)
;@ path: boss/evil_eagle
;@ State 7: when the timer runs out, starts the attack in wEvilEagleAttack (EvilEagleAttacks).
EvilEagleChooseAttack::
;> if GetEntityTimer(slot) != 0:
	call GetEntityTimer
;>     return
	jr nz, jr_005_5caf

;> EvilEagleAttacks[wEvilEagleAttack](slot)
	ld a, [wEvilEagleAttack]
	rst $00

;@ path: boss/evil_eagle
;@ The attacks by wEvilEagleAttack: 0 swoop, 1 drop from above, 2 / 3 blow, 4 drop from above.
EvilEagleAttacks::
	dw EvilEagleStartSwoop
	dw EvilEagleStartDrop
	dw EvilEagleStartBlow
	dw EvilEagleStartBlow
	dw EvilEagleStartDrop

;@ def EvilEagleStartSwoop(slot: bc)
;@ path: boss/evil_eagle
;@ Attack 0: the next attack is random (0-3). It comes in from the top corner away from Link, x speed
;@ $30 towards him and y speed $20 (state 8).
EvilEagleStartSwoop::
;> wEvilEagleAttack = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld [wEvilEagleAttack], a
;> side = 1 if hLinkX < 0x50 else 0
	ld e, $00
	ldh a, [hLinkX]
	cp $50
	jr nc, jr_005_5c7f

	inc e

;>@x wEntityX[slot] = EvilEagleAttackTable[0 + side]
jr_005_5c7f:
	ld d, b
	ld hl, EvilEagleAttackTable
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
;=@x
	ld [hl], a
;> wEntitySpeedX[slot] = EvilEagleAttackTable[2 + side]
	ld hl, EvilEagleAttackTable + 2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntityDirection[slot] = EvilEagleAttackTable[12 + side]
	ld hl, EvilEagleAttackTable + 12
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = 0
	ld hl, wEntityY
	add hl, bc
	ld [hl], $00
;> wEntitySpeedY[slot] = 0x20
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $20
;> wEntityState[slot] = 8
	call IncrementEntityState
	ld [hl], $08

jr_005_5caf:
	ret


;@ def EvilEagleStartDrop(slot: bc)
;@ path: boss/evil_eagle
;@ Attacks 1 and 4: it drops from above the screen (y $F0, y speed $10, no x speed) at x $30 or $70,
;@ on the half away from Link; state $0B for $30 frames.
EvilEagleStartDrop::
;> side = 1 if hLinkX < 0x50 else 0
	ld e, $00
	ldh a, [hLinkX]
	cp $50
	jr nc, jr_005_5cb9

	inc e

;>@x2 wEntityX[slot] = EvilEagleAttackTable[4 + side]
jr_005_5cb9:
	ld d, b
	ld hl, EvilEagleAttackTable + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
;=@x2
	ld [hl], a
;> wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
;> wEntityDirection[slot] = EvilEagleAttackTable[12 + side]
	ld hl, EvilEagleAttackTable + 12
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = 0xF0
	ld hl, wEntityY
	add hl, bc
	ld [hl], $f0
;> wEntitySpeedY[slot] = 0x10
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
;> wEntityState[slot] = 0x0B
	call IncrementEntityState
	ld [hl], $0b
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
	ret


;@ def EvilEagleStartBlow(slot: bc)
;@ path: boss/evil_eagle
;@ Attacks 2 and 3: from a random side it flies in level (x speed $20) at a random height $18-$57,
;@ or at Link's height while his motion step is running; state $0D for $70 frames.
EvilEagleStartBlow::
;> side = GetRandomByte() & 1
	call GetRandomByte
	and $01
	ld e, a
	ld d, b
;>@x3 wEntityX[slot] = EvilEagleAttackTable[8 + side]
	ld hl, EvilEagleAttackTable + 8
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
;=@x3
	ld [hl], a
;> wEntitySpeedX[slot] = EvilEagleAttackTable[10 + side]
	ld hl, EvilEagleAttackTable + 10
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;> wEntityDirection[slot] = EvilEagleAttackTable[12 + side]
	ld hl, EvilEagleAttackTable + 12
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@y3 wEntityY[slot] = (GetRandomByte() & 0x3F) + 0x18
	call GetRandomByte
	and $3f
	add $18
	ld hl, wEntityY
	add hl, bc
;=@y3
	ld [hl], a
;> if hLinkMotionStep:
	ldh a, [hLinkMotionStep]
	and a
	jr z, jr_005_5d28

;>     wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld [hl], a

;> wEntityState[slot] = 0x0D
jr_005_5d28:
	call IncrementEntityState
	ld [hl], $0d
;> wEntityTimer[slot] = 0x70
	call GetEntityTimer
	ld [hl], $70
	ret


;@ def EvilEagleSwoopState(slot: bc)
;@ path: boss/evil_eagle
;@ State 8, the swoop: wings spread (variant 1), it brakes both speeds by 1 a frame towards 0; once
;@ the y speed is 0 it blows (state 9, $FF frames).
EvilEagleSwoopState::
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> SlowSpeedTowardsZero_05(wEntitySpeedY, slot)
	ld hl, wEntitySpeedY
	call SlowSpeedTowardsZero_05
;> if wEntitySpeedY[slot] == 0:
	ld a, [hl]
	and a
	jr z, jr_005_5d55

;>     wEntityState[slot] += 1; wEntityTimer[slot] = 0xFF; return   # code after SlowSpeedTowardsZero_05
;> SlowSpeedTowardsZero_05(wEntitySpeedX, slot)   # runs on into it
	ld hl, wEntitySpeedX

;@ def SlowSpeedTowardsZero_05(table: hl, slot: bc)
;@ path: entity/movement
;@ Moves the slot's value in the given speed table 1 towards 0 (leaves hl on it).
SlowSpeedTowardsZero_05::
;> speed = mem[table + slot]
	add hl, bc
	ld a, [hl]
;> if speed != 0:
	and a
	jr z, jr_005_5d54

;>     if speed & 0x80 == 0:
	and $80
	jr nz, jr_005_5d53

;>         mem[table + slot] = (speed - 2) & 0xFF
	dec [hl]
	dec [hl]

;>     mem[table + slot] = (mem[table + slot] + 1) & 0xFF   # net: 1 towards 0
jr_005_5d53:
	inc [hl]

jr_005_5d54:
	ret


jr_005_5d55:
;> # the swoop has braked: the Evil Eagle blows (EvilEagleSwoopState)
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> return
	ret


;@ path: boss/evil_eagle
;@ Values for the Evil Eagle's gust (state 9), by its facing f (0 to the left, 1 to the right; from
;@ wEntityDirection >> 2) and a random r 0-7:
;@ +0 [2] Link's x speed while he stands in the wind ($EE / $12); +2 [2] the x speed his speed is
;@ steered to while he jumps ($D0 / $30); +4 [2] x offset of a new feather from the eagle ($10 / $F0);
;@ +6 [16] the feather's x speed, at 6 + 8 * side + r (side = f ^ 1... see EvilEagleBlowState):
;@ $D8-$BC to the left, $28-$44 to the right; +22 [16] the feather's y speed, same index ($30 down
;@ to $22).
EvilEagleGustTable::
	db $ee, $12
	db $d0, $30
	db $10, $f0
	db $d8, $d4, $d0, $cc, $c8, $c4, $c0, $bc, $28, $2c, $30, $34, $38, $3c, $40, $44
	db $30, $2e, $2c, $2a, $28, $26, $24, $22, $30, $2e, $2c, $2a, $28, $26, $24, $22

;@ def EvilEagleBlowState(slot: bc)
;@ path: boss/evil_eagle
;@ State 9: the eagle hovers (bobbing a pixel every 4 frames) and beats its wings fast. Link is
;@ pushed by the wind (EvilEagleGustTable +0, moved at once with his collisions) - while he jumps,
;@ his x speed is steered towards the wind speed (+2) instead. Wind noise $32 every 34 frames
;@ (counted in wSongShowTimer). From timer $C0 on a feather (part 3) flies out every 16 frames. When
;@ the timer runs out, state $0A for $50 frames.
EvilEagleBlowState::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
;>     wEntityState[slot] += 1; wEntityTimer[slot] = 0x50; return   # code at the end of this function
	jp z, Jump_005_5e77

;> if hFrameCounter & 3 == 0:             # bob
	ld hl, wEntityY
	add hl, bc
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_5d9d

;>     if hFrameCounter & 0x20:
	ldh a, [hFrameCounter]
	and $20
	jr z, jr_005_5d9c

;>         wEntityY[slot] += 2
	inc [hl]
	inc [hl]

;>     wEntityY[slot] -= 1
jr_005_5d9c:
	dec [hl]

;> EvilEagleFlapWings(slot)
jr_005_5d9d:
	call EvilEagleFlapWings
;> EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;> if hLinkMotionStep == 0 and wIsLinkInTheAir:     # Link jumps
	ldh a, [hLinkMotionStep]
	and a
	jr nz, jr_005_5dd1

	ld a, [wIsLinkInTheAir]
	and a
	jr z, jr_005_5dd1

;>@f     f = (wEntityDirection[slot] >> 2) & 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $01
;=@f
	ld e, a
	ld d, b
;>     d = (EvilEagleGustTable[2 + f] - hLinkSpeedX) & 0xFF
	ld hl, EvilEagleGustTable + 2
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedX
	sub [hl]
;>     if d != 0:
	and a
	jr z, jr_005_5dea

;>         if d & 0x80 == 0:
	and $80
	jr nz, jr_005_5dcd

;>             hLinkSpeedX = (hLinkSpeedX + 4) & 0xFF
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

;>         hLinkSpeedX = (hLinkSpeedX - 2) & 0xFF      # net: 2 towards the wind
jr_005_5dcd:
	dec [hl]
	dec [hl]
	jr jr_005_5dea

;> else:
;>@push     hLinkSpeedX = EvilEagleGustTable[0 + (wEntityDirection[slot] >> 2)]
jr_005_5dd1:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
;=@push
	ld d, b
	ld hl, EvilEagleGustTable
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>     ApplyLinkSpeedX()
	push bc
	call ApplyLinkSpeedX
;>     CheckLinkLeavesRoomFar()                       # his collisions
	call CheckLinkLeavesRoomFar
	pop bc

;> wSongShowTimer = (wSongShowTimer + 1) & 0xFF       # here the wind noise counter
jr_005_5dea:
	ld a, [wSongShowTimer]
	inc a
;> if wSongShowTimer >= 0x22:
	cp $22
	jr c, jr_005_5df7

;>     hNoiseSfx = 0x32                  # wind
	ld a, $32
	ldh [hNoiseSfx], a
;>     wSongShowTimer = 0
	xor a

jr_005_5df7:
	ld [wSongShowTimer], a
;> if GetEntityTimer(slot) < 0xC0 and hFrameCounter & 0x0F == 0:
	call GetEntityTimer
	cp $c0
	jr nc, jr_005_5e76

	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_005_5e76

;>     new = SpawnEntityFromSlot(0x63, 3)          # a feather, in slots 0-3
	ld a, $63
	ld e, $03
	call SpawnEntityFromSlot
;>     if new is not None:
	jr c, jr_005_5e76

;>         wEntityPrivate1[new] = 3
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
;>         f = wEntityDirection[slot] >> 2
	push bc
	ld hl, wEntityDirection
	add hl, bc
	ld c, [hl]
	srl c
	srl c
;>@fx         wEntityX[new] = (hMultiPurpose0 + EvilEagleGustTable[4 + f]) & 0xFF
	ld hl, EvilEagleGustTable + 4
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@fx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = (hMultiPurpose1 + 0x0C) & 0xFF
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $0c
	ld [hl], a
;>         wEntitySpriteVariant[new] = f ^ 1
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, c
	xor $01
	ld [hl], a
;>         wEntityDirection[new] = f ^ 1
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;>@i         i = 8 * f + (GetRandomByte() & 7)
	sla c
	sla c
	sla c
	call GetRandomByte
	and $07
	add c
;=@i
	ld c, a
;>         wEntitySpeedY[new] = EvilEagleGustTable[22 + i]
	ld hl, EvilEagleGustTable + 22
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>         wEntitySpeedX[new] = EvilEagleGustTable[6 + i]
	ld hl, EvilEagleGustTable + 6
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntityPhysicsFlags[new] = 0x02
	pop bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
;>         wEntityOptions1[new] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
;>         wEntityHealthGroup[new] = 2
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $02

jr_005_5e76:
	ret


Jump_005_5e77:
;> # the gust is over
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x50
	call GetEntityTimer
	ld [hl], $50
;> return
	ret


;@ path: boss/evil_eagle
;@ The x speed the Evil Eagle accelerates to when it flies off after its gust, by facing (wEntityDirection
;@ >> 2): 0 left -$20, 1 right +$20.
EvilEagleLeaveSpeedX::
	db $e0, $20

;@ def EvilEagleFlyOffState(slot: bc)
;@ path: boss/evil_eagle
;@ State $0A: speeds up (by 1 a frame, beating fast) to EvilEagleLeaveSpeedX, then glides climbing
;@ (y speed -1 every other frame) until the timer ends the attack (EvilEagleEndAttack).
EvilEagleFlyOffState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
;>     EvilEagleEndAttack(slot)
;>     return
	jr z, jr_005_5ec0

;>@f2 f = (wEntityDirection[slot] >> 2) & 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $01
;=@f2
	ld e, a
	ld d, b
;>@d2 d = (EvilEagleLeaveSpeedX[f] - wEntitySpeedX[slot]) & 0xFF
	ld hl, EvilEagleLeaveSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
;=@d2
	sub [hl]
;> if d != 0:
	and a
	jr z, jr_005_5eb0

;>     if d & 0x80 == 0:
	and $80
	jr nz, jr_005_5ea8

;>         wEntitySpeedX[slot] += 2
	inc [hl]
	inc [hl]

;>     wEntitySpeedX[slot] -= 1
jr_005_5ea8:
	dec [hl]
;>     EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;>     EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;>     return
	ret


;> SetEntitySpriteVariant(slot, 0)
jr_005_5eb0:
	xor a
	call SetEntitySpriteVariant
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_005_5ebf

;>     wEntitySpeedY[slot] -= 1
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

jr_005_5ebf:
	ret


;@ def EvilEagleEndAttack(slot: bc)
;@ path: boss/evil_eagle
;@ The end of an attack: physics flags $02, back to choosing (state 7) after $80 frames, or only $10
;@ when the next attack is 4.
EvilEagleEndAttack::
jr_005_5ec0:
;> wEntityPhysicsFlags[slot] = 0x02
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $02
;> wEntityState[slot] = 7
	call IncrementEntityState
	ld [hl], $07
;> if wEvilEagleAttack == 4:
	call GetEntityTimer
	ld a, [wEvilEagleAttack]
	cp $04
	jr nz, jr_005_5ed8

;>     wEntityTimer[slot] = 0x10
	ld [hl], $10
;>     return
	ret


;> wEntityTimer[slot] = 0x80
jr_005_5ed8:
	ld [hl], $80
	ret


;@ def EvilEagleDropState(slot: bc)
;@ path: boss/evil_eagle
;@ State $0B: drops into view (beating fast); after the timer it stops and dives (state $0C, $30
;@ frames).
EvilEagleDropState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_5eeb

;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     ClearEntitySpeed(slot)                       # stop
	call ClearEntitySpeed

;> EvilEagleFlapWings(slot)
jr_005_5eeb:
	call EvilEagleFlapWings
	ret


;@ path: boss/evil_eagle
;@ Link's x speed when the diving eagle knocks him away, by its facing: 0 left -$20, 1 right +$20.
EvilEagleKnockSpeedX::
	db $e0, $20

;@ def EvilEagleDiveState(slot: bc)
;@ path: boss/evil_eagle
;@ State $0C: hangs in the air beating its wings (faster near the end); one frame before the timer
;@ runs out it dives (x speed from EvilEagleAttackTable +6, y speed $34). Diving (variant 1) it
;@ knocks Link away when it hits him (his speed EvilEagleKnockSpeedX / -$10, pushed for $10
;@ frames); the attack ends once it is below the screen (drawn y >= $B0).
EvilEagleDiveState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, jr_005_5f33

;>     if hActiveEntityDrawY >= 0xB0:
	ldh a, [hActiveEntityDrawY]
	cp $b0
;>         EvilEagleEndAttack(slot)
;>         return
	jp nc, EvilEagleEndAttack

;>     SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;>     if wLinkPushedTimer == 0:
	ld a, [wLinkPushedTimer]
	and a
	jr nz, jr_005_5f32

;>         EntityCheckHits(slot)                   # contact with Link
	call EntityCheckHits
;>         if wLinkPushedTimer:          # it hit him
	ld a, [wLinkPushedTimer]
	and a
	jr z, jr_005_5f32

;>             wLinkPushedTimer = 0x10
	ld a, $10
	ld [wLinkPushedTimer], a
;>@k             hLinkSpeedX = EvilEagleKnockSpeedX[wEntityDirection[slot] >> 2]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
;=@k
	ld d, b
	ld hl, EvilEagleKnockSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;>             hLinkSpeedY = 0xF0
	ld a, $f0
	ldh [hLinkSpeedY], a
;>             hLinkY -= 1
	ld hl, hLinkY
	dec [hl]

jr_005_5f32:
	ret


;> if t == 1:                             # dive
jr_005_5f33:
	cp $01
	jr nz, jr_005_5f51

;>@dv     wEntitySpeedX[slot] = EvilEagleAttackTable[6 + (wEntityDirection[slot] >> 2)]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
;=@dv
	ld d, b
	ld hl, EvilEagleAttackTable + 6
	add hl, de
	ld a, [hl]
;=@dv
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = 0x34
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $34

;> EvilEagleFlapWings(slot)
jr_005_5f51:
	call EvilEagleFlapWings
;> if GetEntityTimer(slot) < 0x40:
	call GetEntityTimer
	cp $40
	jr nc, jr_005_5f61

;>     EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;>     EvilEagleFlapWings(slot)
	call EvilEagleFlapWings

jr_005_5f61:
	ret


;@ def EvilEagleCrossState(slot: bc)
;@ path: boss/evil_eagle
;@ State $0D: flies straight across (variant 0), hurting Link on contact, until the timer ends the
;@ attack.
EvilEagleCrossState::
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckHits(slot)
	call EntityCheckHits
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
;>     EvilEagleEndAttack(slot)
	jp z, EvilEagleEndAttack

	ret


;@ def EvilEagleHurtState(slot: bc)
;@ path: boss/evil_eagle
;@ State $0E, after a hit: hangs flashing and beating its wings (another shriek when the flash is
;@ nearly over); when the flash has ended it climbs away (y speed down to -$30, beating very fast)
;@ and the attack ends once it is above the screen (drawn y $C0-$CF).
EvilEagleHurtState::
;> flash = wEntityFlashTimer[slot]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
;> if flash:
	and a
	jr z, jr_005_5f8d

;>     if flash < 0x30:
	cp $30
	jr nc, jr_005_5f8c

;>         if flash == 1:
	dec a
	jr nz, jr_005_5f86

;>             hNoiseSfx = 0x31
	ld a, $31
	ldh [hNoiseSfx], a

;>         EvilEagleFlapWings(slot)
jr_005_5f86:
	call EvilEagleFlapWings
;>         EvilEagleFlapWings(slot)
	call EvilEagleFlapWings

;>     return
jr_005_5f8c:
	ret


;> EvilEagleFlapWings(slot)
jr_005_5f8d:
	call EvilEagleFlapWings
;> EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;> EvilEagleFlapWings(slot)
	call EvilEagleFlapWings
;> if wEntitySpeedY[slot] != 0xD0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $d0
	jr z, jr_005_5fa0

;>     wEntitySpeedY[slot] -= 1
	dec [hl]

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_5fa0:
	call UpdateEntityPosWithSpeed_05
;> if hActiveEntityDrawY & 0xF0 == 0xC0:
	ldh a, [hActiveEntityDrawY]
	and $f0
	cp $c0
	jr nz, jr_005_5fae

;>     EvilEagleEndAttack(slot)
	jp EvilEagleEndAttack


jr_005_5fae:
	ret


;@ path: boss/evil_eagle
;@ The Evil Eagle facing left: 4 variants of 12 sprites for DrawEntitySprites, 4 bytes each (y offset, x
;@ offset, tile, attributes); unused entries are $FF $FF $FF $FF (hidden). Variant 0 wings spread
;@ (10 sprites), 1-3 wing beat (12, 9 and 9 sprites). The body is 4 tiles of 8x16 wide.
EvilEagleSprites::
	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $44, $00, $f8, $18, $46, $00
	db $f8, $20, $48, $00, $f8, $28, $4a, $00, $08, $18, $4c, $00, $08, $20, $4e, $00
	db $08, $28, $50, $00, $00, $30, $52, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $5a, $00, $00, $18, $5c, $00
	db $00, $20, $5e, $00, $10, $08, $60, $00, $10, $10, $62, $00, $10, $18, $64, $00
	db $10, $20, $66, $00, $f0, $18, $54, $00, $f0, $20, $56, $00, $f0, $28, $58, $00
	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $5a, $00, $00, $18, $68, $00
	db $00, $20, $6a, $00, $10, $08, $60, $00, $10, $10, $62, $00, $10, $18, $64, $00
	db $10, $20, $66, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $6c, $00, $00, $18, $6e, $00
	db $00, $20, $70, $00, $10, $08, $60, $00, $10, $10, $72, $00, $10, $18, $74, $00
	db $10, $20, $76, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: boss/evil_eagle
;@ The Evil Eagle facing right: the same 4 variants as EvilEagleSprites, mirrored (attribute $20,
;@ x offsets negated).
EvilEagleSpritesRight::
	db $00, $08, $40, $20, $00, $00, $42, $20, $00, $f8, $44, $20, $f8, $f0, $46, $20
	db $f8, $e8, $48, $20, $f8, $e0, $4a, $20, $08, $f0, $4c, $20, $08, $e8, $4e, $20
	db $08, $e0, $50, $20, $00, $d8, $52, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $08, $40, $20, $00, $00, $42, $20, $00, $f8, $5a, $20, $00, $f0, $5c, $20
	db $00, $e8, $5e, $20, $10, $00, $60, $20, $10, $f8, $62, $20, $10, $f0, $64, $20
	db $10, $e8, $66, $20, $f0, $f0, $54, $20, $f0, $e8, $56, $20, $f0, $e0, $58, $20
	db $00, $08, $40, $20, $00, $00, $42, $20, $00, $f8, $5a, $20, $00, $f0, $68, $20
	db $00, $e8, $6a, $20, $10, $00, $60, $20, $10, $f8, $62, $20, $10, $f0, $64, $20
	db $10, $e8, $66, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $08, $40, $20, $00, $00, $42, $20, $00, $f8, $6c, $20, $00, $f0, $6e, $20
	db $00, $e8, $70, $20, $10, $00, $60, $20, $10, $f8, $72, $20, $10, $f0, $74, $20
	db $10, $e8, $76, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: boss/evil_eagle
;@ The Evil Eagle's hitboxes, copied into wEntityHitbox by DrawEvilEagle (4 bytes: x offset, half
;@ width, y offset, half height): +0 wings spread facing left, +4 beating facing left, +8 spread
;@ facing right, +12 beating facing right.
EvilEagleHitboxes::
	db $1c, $1c, $08, $0c,  $14, $10, $10, $10,  $f4, $1c, $08, $0c,  $fc, $10, $10, $10

;@ def DrawEvilEagle(slot: bc)
;@ path: boss/evil_eagle
;@ Draws the Evil Eagle: variant + facing (wEntityDirection 0 or 4) picks the 48-byte picture in
;@ EvilEagleSprites (0-3) or EvilEagleSpritesRight (4-7); 12 sprites drawn, 10 sprite entries
;@ reserved. Then sets its hitbox from EvilEagleHitboxes (spread or beating, by facing).
DrawEvilEagle::
;> v = hActiveEntitySpriteVariant + wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
;> sprites = EvilEagleSprites
	ld hl, EvilEagleSprites
;> if v >= 4:
	cp $04
	jr c, jr_005_6152

;>     v -= 4
	sub $04
;>     sprites = EvilEagleSpritesRight
	ld hl, EvilEagleSpritesRight

;>@v48 DrawEntitySprites(12, sprites + 48 * v)
jr_005_6152:
	ld e, a
	ld d, b
	sla e
	sla e
	sla e
	sla e
;=@v48
	ld a, e
	sla e
	add e
	ld e, a
	add hl, de
	ld c, $0c
;=@v48
	call DrawEntitySprites
;> ReserveOAMEntriesFar(10)
	ld a, $0a
	call ReserveOAMEntriesFar
;> e = 0 if hActiveEntitySpriteVariant == 0 else 4
	ld e, $00
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, jr_005_6175

	ld e, $04

;> if wEntityDirection[slot]:
jr_005_6175:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6181

;>     e += 8
	ld a, e
	add $08
	ld e, a

;>@hb for i in range(4): wEntityHitbox[4 * slot + i] = EvilEagleHitboxes[e + i]
jr_005_6181:
	ld d, b
	ld hl, EvilEagleHitboxes
	add hl, de
	push hl
	pop de
	push bc
;=@hb
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	ld c, $04

jr_005_6193:
;=@hb
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_005_6193

;> return
	pop bc
	ret


;@ path: boss/evil_eagle
;@ A Grim Creeper bat: 2 DrawEntity16x16 variants, tile $7C with its mirror, the second upside down.
GrimCreeperBatSprites::
	db $7c, $00, $7c, $20,  $7c, $40, $7c, $60

;@ def GrimCreeperBat(slot: bc)
;@ path: boss/evil_eagle
;@ Part 2, one of the Grim Creeper's two bats (Link cannot move meanwhile): flutters (the picture
;@ flips every 8 frames) and runs its state: 0 hovering beside him, 1 (set by the eagle) flying away.
GrimCreeperBat::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> DrawEntity16x16(slot, GrimCreeperBatSprites)
	ld de, GrimCreeperBatSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> GrimCreeperBatStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/evil_eagle
;@ The bat's states (wEntityState): 0 hovering, 1 flying away.
GrimCreeperBatStates::
	dw BatHoverState
	dw BatFlyAwayState

;@ def BatHoverState(slot: bc)
;@ path: boss/evil_eagle
;@ State 0: the bat hovers in place, jittering a pixel on y and on x (BatJitter, y with a phase of 7).
BatHoverState::
;> BatJitter(wEntityY + slot, 7, slot)
	ld hl, wEntityY
	add hl, bc
	ld e, $07
	call BatJitter
;> BatJitter(wEntityX + slot, 0, slot)        # runs on into it
	ld hl, wEntityX
	add hl, bc
	ld e, $00

;@ def BatJitter(pos: hl, phase: e, slot: bc)
;@ path: boss/evil_eagle
;@ Every 4th frame (counting from phase) moves the position byte 1 pixel; the direction flips every 16
;@ frames, and the two bats (slot parity) move opposite ways.
BatJitter::
;> t = (hFrameCounter + phase) & 0xFF
	ldh a, [hFrameCounter]
	add e
	ld d, a
;> if t & 3 == 0:
	and $03
	jr nz, jr_005_61e5

;>@j     if ((t >> 4) ^ slot) & 1:
	ld a, d
	rra
	rra
	rra
	rra
;=@j
	xor c
	and $01
	jr z, jr_005_61e4

;>         mem[pos] = (mem[pos] + 2) & 0xFF
	inc [hl]
	inc [hl]

;>     mem[pos] = (mem[pos] - 1) & 0xFF
jr_005_61e4:
	dec [hl]

jr_005_61e5:
	ret


;@ def BatFlyAwayState(slot: bc)
;@ path: boss/evil_eagle
;@ State 1: the bat flies off up-left, speeding up to x speed -$40 and y speed -$10, and is gone at
;@ the left edge (x $E0 and up after wrapping).
BatFlyAwayState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if wEntitySpeedX[slot] != 0xC0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $c0
	jr z, jr_005_61f3

;>     wEntitySpeedX[slot] -= 1
	dec [hl]

;> if wEntitySpeedY[slot] != 0xF0:
jr_005_61f3:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $f0
	jr z, jr_005_61fd

;>     wEntitySpeedY[slot] -= 1
	dec [hl]

;> if hActiveEntityX >= 0xE0:
jr_005_61fd:
	ldh a, [hActiveEntityX]
	cp $e0
;>     ClearEntityStatus_05(slot)
	jp nc, ClearEntityStatus_05

	ret


;@ path: boss/evil_eagle
;@ A feather shot by the Evil Eagle: 4 DrawEntity16x16 variants (tiles $78/$7A): 0 pointing right, 1 left,
;@ 2 and 3 the same upside down (after bouncing off a wall).
EvilEagleFeatherSprites::
	db $7a, $20, $78, $20,  $78, $00, $7a, $00,  $7a, $60, $78, $60,  $78, $40, $7a, $40

;@ def EvilEagleFeather(slot: bc)
;@ path: boss/evil_eagle
;@ Part 3, a feather from the eagle's gust: moves with its speed; state 0 flying (it hurts Link, and
;@ curves upwards), state 1 after bouncing off a wall. Gone at the right edge (x >= $A8).
EvilEagleFeather::
;> DrawEntity16x16(slot, EvilEagleFeatherSprites)
	ld de, EvilEagleFeatherSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EvilEagleFeatherStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/evil_eagle
;@ The feather's states (wEntityState): 0 flying, 1 bounced.
EvilEagleFeatherStates::
	dw FeatherFlyState
	dw FeatherBouncedState

;@ def FeatherFlyState(slot: bc)
;@ path: boss/evil_eagle
;@ State 0: hurts Link when it touches him; when it hits a wall it bounces up (y speed -$20, the
;@ upside-down picture, state 1). Its y speed falls by 1 a frame (it curves upwards).
FeatherFlyState::
;> EntityCheckTouchLink(slot)                            # touches Link
	call EntityCheckTouchLink
;> if wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6242

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntitySpeedY[slot] = 0xE0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $e0
;>     wEntitySpriteVariant[slot] += 2
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]
	inc [hl]

;> wEntitySpeedY[slot] = (wEntitySpeedY[slot] - 1) & 0xFF
jr_005_6242:
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

;> FeatherBouncedState(slot)              # runs on into it

;@ def FeatherBouncedState(slot: bc)
;@ path: boss/evil_eagle
;@ State 1 (and the end of state 0): the feather disappears at the right edge (x >= $A8).
FeatherBouncedState::
;> if hActiveEntityX >= 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>     ClearEntityStatus_05(slot)
	jp nc, ClearEntityStatus_05

	ret


;@ def HideEntityWithFullHealth_05(slot: bc)
;@ path: entity/spawn
;@ Called from bank 0 (through a trampoline there): gives the entity $40 frames of wEntityTimer,
;@ hides it (sprite variant $FF) and sets its health to $FF.
HideEntityWithFullHealth_05::
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntitySpriteVariant[slot] = 0xFF
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $ff
;> wEntityHealth[slot] = 0xFF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
	ret

;@ def HotHeadEntityHandler(slot: bc)
;@ path: boss/hot_head
;@ Entity $62, Hot Head, the lava boss, and its parts (by wEntityPrivate1): 0 Hot Head itself,
;@ 1 a lava splash, 2 a fireball, 3 a half of its broken shell. Hot Head draws itself, then runs its
;@ death steps while dying (status 1) or else its states.
HotHeadEntityHandler::
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> StartBossMusic()                            # starts the boss music
	call StartBossMusic
;> part = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
;> if part != 0:
	and a
	jr z, jr_005_627c

;>     if part == 1: return HotHeadSplash(slot)
	cp $01
	jp z, HotHeadSplash

;>     if part == 2: return HotHeadFireball(slot)
	cp $02
	jp z, HotHeadFireball

;>     return HotHeadShellHalf(slot)
	jp HotHeadShellHalf


;> DrawHotHead(slot)
jr_005_627c:
	call DrawHotHead
;> if hActiveEntityStatus != 1: return HotHeadAlive(slot)
	ldh a, [hActiveEntityStatus]
	cp $01
	jr nz, HotHeadAlive

;> HotHeadDeathStates[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/hot_head
;@ Hot Head's death steps, by wEntityPrivate2.
HotHeadDeathStates::
	dw HotHeadDeathStart
	dw HotHeadExplodeState

;@ def HotHeadDeathStart(slot: bc)
;@ path: boss/hot_head
;@ Death step 0: $FF frames of explosions follow (step 1).
HotHeadDeathStart::
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff

HotHeadNextDeathStep:
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
;> return
	ret


;@ def HotHeadExplodeState(slot: bc)
;@ path: boss/hot_head
;@ Death step 1: Hot Head flashes and, in the last $80 frames, gives off explosion puffs. At the end it
;@ is replaced by the heart container, which falls from high up (z $70) at Link's x, y $70.
HotHeadExplodeState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t != 0:
	jp z, Jump_005_62ad

;>     wEntityFlashTimer[slot] = t
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;>     if t < 0x80:
	cp $80
	jr nc, jr_005_62ac

;>         BossExplosionPuffs_05(t)
	call BossExplosionPuffs_05

;>     return
jr_005_62ac:
	ret


;> # the timer has run out
;> new = SpawnHeartContainer_05(slot)
Jump_005_62ad:
	call SpawnHeartContainer_05
;> wEntityX[new] = hLinkX
	ld hl, wEntityX
	add hl, de
	ldh a, [hLinkX]
	ld [hl], a
;> wEntityY[new] = 0x70
	ld hl, wEntityY
	add hl, de
	ld [hl], $70
;> wEntityZ[new] = 0x70
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70
;> return
	ret


;@ def HotHeadAlive(slot: bc)
;@ path: boss/hot_head
;@ Hot Head while alive: runs its state (HotHeadStates).
HotHeadAlive::
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> HotHeadStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/hot_head
;@ Hot Head's states, by wEntityState.
HotHeadStates::
	dw HotHeadLavaState
	dw HotHeadJumpState
	dw HotHeadShellState
	dw HotHeadShellBreakState
	dw HotHeadUnusedState

;@ path: boss/hot_head
;@ Start x of Hot Head's leap out of the lava, for each of its 8 jumps (chosen at random): $28, $38,
;@ $58, $68, $28, $38, $58, $68.
HotHeadJumpX::
	db $28, $38, $58, $68, $28, $38, $58, $68

;@ path: boss/hot_head
;@ Start y of each of the 8 jumps: $38, $30, $30, $38, $50, $58, $58, $50.
HotHeadJumpY::
	db $38, $30, $30, $38, $50, $58, $58, $50
;@ path: boss/hot_head
;@ X speed of each of the 8 jumps: +$10 for jumps 0, 1, 4, 5 and -$10 for jumps 2, 3, 6, 7.
HotHeadJumpSpeedX::
	db $10, $10, $f0, $f0, $10, $10, $f0, $f0

;@ path: boss/hot_head
;@ Y speed of each of the 8 jumps: -3 or +3 ($FD, $03, $03, $FD, $03, $FD, $FD, $03).
HotHeadJumpSpeedY::
	db $fd, $03, $03, $fd, $03, $fd, $fd, $03

;@ def HotHeadLavaState(slot: bc)
;@ path: boss/hot_head
;@ State 0: Hot Head waits in the lava until its timer runs out, then leaps out at one of 8 random
;@ spots (HotHeadJumpX/Y, speeds HotHeadJumpSpeedX/Y, z speed $18) with a lava splash and wave
;@ sound $16 (state 1).
HotHeadLavaState::
;> if GetEntityTimer(slot) != 0: return
	call GetEntityTimer
	jr nz, jr_005_633b

;>@r r = GetRandomByte() & 7
	call GetRandomByte
	and $07
;=@r
	ld e, a
	ld d, b
;> wEntityX[slot] = HotHeadJumpX[r]
	ld hl, HotHeadJumpX
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[slot] = HotHeadJumpY[r]
	ld hl, HotHeadJumpY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntitySpeedX[slot] = HotHeadJumpSpeedX[r]
	ld hl, HotHeadJumpSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = HotHeadJumpSpeedY[r]
	ld hl, HotHeadJumpSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntitySpeedZ[slot] = 0x18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;> hWaveSfx = 0x16
	ld a, $16
	ldh [hWaveSfx], a
;> SpawnHotHeadSplash()
	call SpawnHotHeadSplash
;> wEntityState[slot] += 1
	call IncrementEntityState

;> return
jr_005_633b:
	ret


;@ def HotHeadJumpState(slot: bc)
;@ path: boss/hot_head
;@ State 1, the leap: if Hot Head is hit (flash timer $0B or more) while leaping sideways with its
;@ flames still on (fewer than 5 counted hits), the flames go out with two puffs: it becomes a bare
;@ shell that bounces around (state 2, speeds $18/$18, $40 frames shaking, $40 frames before it may
;@ sink). Otherwise it flies on (HotHeadJumpMove).
HotHeadJumpState::
;> if wEntitySpeedX[slot] == 0: return HotHeadJumpMove(slot)
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, HotHeadJumpMove

;> if wEntityFlashTimer[slot] < 0x0B: return HotHeadJumpMove(slot)
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $0b
	jr c, HotHeadJumpMove

;> if wEntityPrivateCounter[slot] >= 5: return     # its shell is already broken
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_005_6394

;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntitySpeedX[slot] = 0x18
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $18
;> wEntitySpeedY[slot] = 0x18
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $18
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;> wEntityDropTimer[slot] = 0x40
	call GetEntityDropTimer
	ld [hl], $40
;> hMultiPurpose0 = (hActiveEntityX - 8) & 0xFF
	ldh a, [hActiveEntityX]
	add $f8
	ldh [hMultiPurpose0], a
;> HotHeadPuff()
	call HotHeadPuff
;> hMultiPurpose0 = (hActiveEntityX + 8) & 0xFF
	ldh a, [hActiveEntityX]
	add $08
	ldh [hMultiPurpose0], a
;> HotHeadPuff()                          # runs on into it

;@ def HotHeadPuff()
;@ path: boss/hot_head
;@ A puff (transient effect 2, $0F frames) at x hMultiPurpose0, $10 above Hot Head's drawn y.
HotHeadPuff::
;> hMultiPurpose1 = (hActiveEntityDrawY - 0x10) & 0xFF
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hMultiPurpose1], a
;> v = AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> wVfxTimer[v] = 0x0F
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f

;> return
jr_005_6394:
	ret


;@ def HotHeadJumpMove(slot: bc)
;@ path: boss/hot_head
;@ Hot Head flies on its jump arc (z speed down by 1 a frame). When it lands it goes back under the
;@ lava (state 0, hidden, $40 frames) with 4 fireballs, a splash and jingle $32. In the air it shows
;@ its flaming frames 0/1 (every 8 frames) while moving sideways, or its bare frames once the shell is
;@ broken.
HotHeadJumpMove::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:              # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_63c2

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     SpawnHotHeadFireballs()
	call SpawnHotHeadFireballs
;>     SpawnHotHeadSplash()
	call SpawnHotHeadSplash
;>     hJingle = 0x32
	ld a, $32
	ldh [hJingle], a
;>     return SetEntitySpriteVariant(slot, 0xFF)             # hidden
	ld a, $ff
	jp SetEntitySpriteVariant


;> if wEntityPrivateCounter[slot] >= 5: return HotHeadBareFrame(slot)
jr_005_63c2:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jp nc, HotHeadBareFrame

;> if wEntitySpeedX[slot] == 0: return
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_63de

;> return SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	jp SetEntitySpriteVariant


;> return
jr_005_63de:
	ret


;@ def HotHeadShellState(slot: bc)
;@ path: boss/hot_head
;@ State 2, the bare shell (frame 2): first it shakes for its timer. Then it can be hit and hurts
;@ Link. Once its drop timer is over and it is inside x < $70, y < $50 it sinks back into the lava
;@ (state 1 without speed). A hit there (flash timer 8) is counted; the 5th breaks the shell (state 3,
;@ $80 frames). Otherwise, unless just hit, it bounces off the walls and leaves a trail.
HotHeadShellState::
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t != 0:                            # shake
	jr z, jr_005_6400

;>     e = 8
	and $02
	ld e, $08
;>     if t & 2:
	jr z, jr_005_63f1

;>         e = -8
	ld e, $f8

;>     s = wEntitySpeedX[slot]
jr_005_63f1:
	ld hl, wEntitySpeedX
	add hl, bc
	push hl
	ld a, [hl]
	push af
;>     wEntitySpeedX[slot] = e
	ld [hl], e
;>     AddEntitySpeedToPosX_05(slot)
	call AddEntitySpeedToPosX_05
;>     wEntitySpeedX[slot] = s
	pop af
	pop hl
	ld [hl], a
;>     return
	ret


;> EntityCheckHits(slot)                            # sword hits and contact damage
jr_005_6400:
	call EntityCheckHits
;> if GetEntityDropTimer(slot) == 0 and hActiveEntityX < 0x70:
	call GetEntityDropTimer
	jr nz, jr_005_641d

	ldh a, [hActiveEntityX]
	cp $70
	jr nc, jr_005_641d

;>     if hActiveEntityDrawY < 0x50:
	ldh a, [hActiveEntityDrawY]
	cp $50
	jr nc, jr_005_641d

;>         ClearEntitySpeed(slot)                    # stop
	call ClearEntitySpeed
;>         wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>         return
	ret


;> if wEntityFlashTimer[slot] == 8:
jr_005_641d:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_005_6448

;>     if hActiveEntityX < 0x70 and hActiveEntityDrawY < 0x50:
	ldh a, [hActiveEntityX]
	cp $70
	jr nc, jr_005_6448

	ldh a, [hActiveEntityDrawY]
	cp $50
	jr nc, jr_005_6448

;>         wEntityPrivateCounter[slot] += 1             # hits counted
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>         if wEntityPrivateCounter[slot] >= 5:
	ld a, [hl]
	cp $05
	jr c, jr_005_6448

;>             wEntityState[slot] += 1
	call IncrementEntityState
;>             ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>             wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>             return
	ret


;> if wEntityFlashTimer[slot] >= 0x0B: return    # just hit
jr_005_6448:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $0b
	jr nc, jr_005_6487

;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)                            # background collisions
	call EntityCheckWalls
;> col = wEntityCollisions[slot]
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	push af
;> if col & 0x03:                         # hit a side wall
	and $03
	jr z, jr_005_6467

;>     NegateEntityValue_05(wEntitySpeedX, slot)
	ld hl, wEntitySpeedX
	call NegateEntityValue_05

;> if col & 0x0C == 0: return HotHeadTrail()
jr_005_6467:
	pop af
	and $0c
	jr z, HotHeadTrail

;> NegateEntityValue_05(wEntitySpeedY, slot)     # runs on into it
	ld hl, wEntitySpeedY

;@ def NegateEntityValue_05(table: hl, slot: bc)
;@ path: entity/movement
;@ Negates the slot's value in the given table (reverses a speed), then runs on into HotHeadTrail.
NegateEntityValue_05::
;> mem[table + slot] = -mem[table + slot] & 0xFF
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;> HotHeadTrail()                         # runs on into it

;@ def HotHeadTrail()
;@ path: boss/hot_head
;@ Every 8 frames a trail effect (transient effect $0A) at the shell's position.
HotHeadTrail::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_6487

;>     hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(0x0A)
	ld a, $0a
	call AddTransientVfx

;> return
jr_005_6487:
	ret


;@ def HotHeadShellBreakState(slot: bc)
;@ path: boss/hot_head
;@ State 3: the shell shakes ($10 wide) for $40 frames and at timer $40 bursts in two halves (noise
;@ $29). Then the bare Hot Head shows (frames 3/4) until the timer runs out; it gets 8 health and
;@ goes back to state 1.
HotHeadShellBreakState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t >= 0x40:
	cp $40
	jr c, jr_005_64af

;>     if t == 0x40:
	jr nz, jr_005_6498

;>         hNoiseSfx = 0x29
	ld a, $29
	ldh [hNoiseSfx], a
;>         SpawnHotHeadShellHalves()      # leaves 0 in a
	call SpawnHotHeadShellHalves

;>     e = 0x10
jr_005_6498:
	and $02
	ld e, $10
;>     if t & 2:
	jr z, jr_005_64a0

;>         e = -0x10
	ld e, $f0

;>     s = wEntitySpeedX[slot]
jr_005_64a0:
	ld hl, wEntitySpeedX
	add hl, bc
	push hl
	ld a, [hl]
	push af
;>     wEntitySpeedX[slot] = e
	ld [hl], e
;>     AddEntitySpeedToPosX_05(slot)
	call AddEntitySpeedToPosX_05
;>     wEntitySpeedX[slot] = s
	pop af
	pop hl
	ld [hl], a
;>     return
	ret


;> # t < 0x40
;> if t != 0: return HotHeadBareFrame(slot)
jr_005_64af:
	and a
	jr nz, HotHeadBareFrame

;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> wEntityHealth[slot] = 8
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $08
;> return
	ret


;@ def HotHeadBareFrame(slot: bc)
;@ path: boss/hot_head
;@ Shows the bare Hot Head, frames 3 and 4 changing every 8 frames.
HotHeadBareFrame::
;> f = ((hFrameCounter >> 3) & 1) + 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $03
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
	ret


;@ def HotHeadUnusedState(slot: bc)
;@ path: boss/hot_head
;@ State 4: never set; does nothing. A second ret follows that is never reached.
HotHeadUnusedState::
;> return
	ret


;> return
	ret

;@ path: boss/hot_head
;@ X offset from Hot Head of each shell half (SpawnHotHeadShellHalves, index half - 1): -8, +8.
HotHeadShellOffsetX::
	db $f8, $08

;@ path: boss/hot_head
;@ X speed of each shell half, same index: -8, +8.
HotHeadShellSpeedX::
	db $f8, $08

;@ def SpawnHotHeadShellHalves()
;@ path: boss/hot_head
;@ The broken shell: two halves (entity $62, part 3), 8 to the left and right of Hot Head at its
;@ height, flying apart (x speed -8/+8, y speed 4, z speed 8). Half 1 is frame 0, half 2 frame 1.
;@ hBGTilesRequestCopy is used as the loop counter.
SpawnHotHeadShellHalves::
;> n = 2
	ld a, $02

;> while True:
;>     hBGTilesRequestCopy = n
jr_005_64d6:
	ldh [hBGTilesRequestCopy], a
;>     new = SpawnEntity(0x62)
	ld a, $62
	call SpawnEntity
;>     if new is not None:
	jr c, jr_005_6528

;>         wEntityPrivate1[new] = 3
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
	push bc
;>@x         wEntityX[new] = (hMultiPurpose0 + HotHeadShellOffsetX[n - 1]) & 0xFF   # Hot Head's x
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, HotHeadShellOffsetX - 1
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityZ[new] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>         wEntitySpriteVariant[new] = n - 1
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hBGTilesRequestCopy]
	dec a
	ld [hl], a
;>         wEntitySpeedX[new] = HotHeadShellSpeedX[n - 1]
	ld hl, HotHeadShellSpeedX - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[new] = 4
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $04
	pop bc
;>         wEntitySpeedZ[new] = 8
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $08
;>         wEntityPhysicsFlags[new] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42

;>     n = hBGTilesRequestCopy - 1
jr_005_6528:
	ldh a, [hBGTilesRequestCopy]
	dec a
;>     if n == 0: break
	jr nz, jr_005_64d6

;> return
	ret


;@ def SpawnHotHeadSplash()
;@ path: boss/hot_head
;@ A lava splash (entity $62, part 1) where Hot Head is (hMultiPurpose0/1), lasting $14 frames.
SpawnHotHeadSplash::
;> new = SpawnEntity(0x62)
	ld a, $62
	call SpawnEntity
;> if new is None: return
	jr c, jr_005_6555

;> wEntityPrivate1[new] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
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
;> wEntityTimer[new] = 0x14
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
;> wEntityPhysicsFlags[new] = 0xC4
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4

;> return
jr_005_6555:
	ret


;@ path: boss/hot_head
;@ X offset from Hot Head of each of the 4 fireballs (SpawnHotHeadFireballs, index n - 1): -8, +8,
;@ -8, +8.
HotHeadFireballOffsetX::
	db $f8, $08, $f8, $08

;@ path: boss/hot_head
;@ Y offset of each fireball: -4, -4, +4, +4.
HotHeadFireballOffsetY::
	db $fc, $fc, $04, $04

;@ path: boss/hot_head
;@ X speed of each fireball: -$0C, +$0C, -$0C, +$0C.
HotHeadFireballSpeedX::
	db $f4, $0c, $f4, $0c

;@ path: boss/hot_head
;@ Y speed of each fireball: -$0C, -$0C, +$0C, +$0C (so the 4 fly out diagonally).
HotHeadFireballSpeedY::
	db $f4, $f4, $0c, $0c

;@ def SpawnHotHeadFireballs()
;@ path: boss/hot_head
;@ Four fireballs (entity $62, part 2) around Hot Head, flying out diagonally with z speed $13
;@ (HotHeadFireballOffsetX/Y, HotHeadFireballSpeedX/Y). hBGTilesRequestCopy is the loop counter.
SpawnHotHeadFireballs::
;> n = 4
	ld a, $04

;> while True:
;>     hBGTilesRequestCopy = n
jr_005_6568:
	ldh [hBGTilesRequestCopy], a
;>     new = SpawnEntity(0x62)
	ld a, $62
	call SpawnEntity
;>     if new is not None:
	jr c, jr_005_65b4

;>         wEntityPrivate1[new] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	push bc
;>@x         wEntityX[new] = (hMultiPurpose0 + HotHeadFireballOffsetX[n - 1]) & 0xFF
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, HotHeadFireballOffsetX - 1
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@y         wEntityY[new] = (hMultiPurpose1 + HotHeadFireballOffsetY[n - 1]) & 0xFF
	ld hl, HotHeadFireballOffsetY - 1
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;=@y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntitySpeedX[new] = HotHeadFireballSpeedX[n - 1]
	ld hl, HotHeadFireballSpeedX - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>         wEntitySpeedY[new] = HotHeadFireballSpeedY[n - 1]
	ld hl, HotHeadFireballSpeedY - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>         wEntitySpeedZ[new] = 0x13
	pop bc
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $13
;>         wEntityPhysicsFlags[new] = 0x42
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42

;>     n = hBGTilesRequestCopy - 1
jr_005_65b4:
	ldh a, [hBGTilesRequestCopy]
	dec a
;>     if n == 0: break
	jr nz, jr_005_6568

;> return
	ret


;@ path: boss/hot_head
;@ Hot Head with its flames, 32x32: 2 DrawEntitySprites lists of 8 sprites (dy, dx, tile, attr), frame 0 and
;@ frame 1 (the top row mirrored). Top row tiles $60-$66 at dy -$10, bottom row $68, $6A and their
;@ mirrors at dy 0; dx -8 to +$10.
HotHeadSprites::
	db $f0, $f8, $60, $00, $f0, $00, $62, $00, $f0, $08, $64, $00, $f0, $10, $66, $00
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $68, $20
	db $f0, $f8, $66, $20, $f0, $00, $64, $20, $f0, $08, $62, $20, $f0, $10, $60, $20
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $68, $20
;@ path: boss/hot_head
;@ Hot Head's one-row frames 2-6, 5 DrawEntitySprites lists of 4 sprites (dy, dx, tile, attr) at dy 0:
;@ 2 the bare shell ($6C, $6E and mirrors, dx -8 to +$10); 3 and 4 the bare Hot Head ($7C, $7E, $7C
;@ mirrored at dx -4, 4, $0C, the 4th sprite hidden with tile $FF; frame 4 also mirrors the middle);
;@ 5 and 6 the lava splash ($74, $76 and $70, $72 with mirrors).
HotHeadSmallSprites::
	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $08, $6e, $20, $00, $10, $6c, $20
	db $00, $fc, $7c, $00, $00, $04, $7e, $00, $00, $0c, $7c, $20, $00, $00, $ff, $00
	db $00, $fc, $7c, $00, $00, $04, $7e, $20, $00, $0c, $7c, $20, $00, $00, $ff, $00
	db $00, $f8, $74, $00, $00, $00, $76, $00, $00, $08, $76, $20, $00, $10, $74, $20
	db $00, $f8, $70, $00, $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $70, $20
;@ path: boss/hot_head
;@ Hot Head's shadow: a DrawEntitySprites list of 4 sprites, tile $26 at dy $0A, dx -5, 1, 6, $0C.
HotHeadShadowSprites::
	db $0a, $fb, $26, $00, $0a, $01, $26, $00, $0a, $06, $26, $00, $0a, $0c, $26, $00

;@ def DrawHotHead(slot: bc)
;@ path: boss/hot_head
;@ Draws Hot Head: frames 0/1 as 8 sprites (HotHeadSprites), the others with DrawHotHeadSmall; then its
;@ shadow.
DrawHotHead::
;> if hActiveEntitySpriteVariant >= 2: return DrawHotHeadSmall(slot)
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nc, DrawHotHeadSmall

;> wEntityPhysicsFlags[slot] = (wEntityPhysicsFlags[slot] & 0xF0) | 8    # 8 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
;>@e e = (hActiveEntitySpriteVariant << 5) & 0xE0
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
;=@e
	rla
	rla
	and $e0
;> DrawEntitySprites(8, HotHeadSprites + e)
	ld e, a
	ld d, b
	ld hl, HotHeadSprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> DrawHotHeadShadow(slot)               # runs on into it
	nop

;@ def DrawHotHeadShadow(slot: bc)
;@ path: boss/hot_head
;@ For frames below 5, draws the shadow (HotHeadShadowSprites) at Hot Head's ground position when
;@ its z is 0 or above 8.
DrawHotHeadShadow::
;> if hActiveEntitySpriteVariant >= 5: return
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nc, jr_005_66ab

;> if (wEntityZ[slot] - 1) & 0xFF < 8: return
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	dec a
	cp $08
	jr c, jr_005_66ab

;> wEntityPhysicsFlags[slot] = (wEntityPhysicsFlags[slot] & 0xF0) | 4
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
;> hActiveEntityDrawY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntitySprites(4, HotHeadShadowSprites)
	ld hl, HotHeadShadowSprites
	ld c, $04
	call DrawEntitySprites
;> LoadEntityPosition(slot)                            # restore the active vars
	call LoadEntityPosition

;> return
jr_005_66ab:
	ret


;@ def DrawHotHeadSmall(slot: bc)
;@ path: boss/hot_head
;@ Draws one of the 4-sprite frames 2-6 (HotHeadSmallSprites), then the shadow.
DrawHotHeadSmall::
;> wEntityPhysicsFlags[slot] = (wEntityPhysicsFlags[slot] & 0xF0) | 4
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
;>@e e = ((hActiveEntitySpriteVariant - 2) << 4) & 0xF0
	ldh a, [hActiveEntitySpriteVariant]
	dec a
	dec a
	rla
;=@e
	rla
	rla
	rla
	and $f0
;> DrawEntitySprites(4, HotHeadSmallSprites + e)
	ld e, a
	ld d, b
	ld hl, HotHeadSmallSprites
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> DrawHotHeadShadow(slot)
	call DrawHotHeadShadow
	ret


;@ def HotHeadSplash(slot: bc)
;@ path: boss/hot_head
;@ Part 1, a lava splash: frame 6 for its first $0A frames, then frame 5; gone when its timer runs out.
HotHeadSplash::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return ClearEntityStatus_05(slot)
	jp z, ClearEntityStatus_05

;> f = 5
	cp $0a
	ld a, $05
;> if t >= 0x0A:
	jr c, jr_005_66dc

;>     f = 6
	inc a

;> hActiveEntitySpriteVariant = f
jr_005_66dc:
	ldh [hActiveEntitySpriteVariant], a
;> DrawHotHeadSmall(slot)
	call DrawHotHeadSmall
	ret


;@ path: boss/hot_head
;@ Fireball sprite pairs for DrawEntity16x16 (tile, attr for the left and right half), 4 frames: 0 and 1 the
;@ ball (tile $1E flipped 4 ways), 2 and 3 its burst ($7A, $78 with their mirrors).
HotHeadFireballSprites::
	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $7a, $00, $7a, $20, $78, $00, $78, $20

;@ def HotHeadFireball(slot: bc)
;@ path: boss/hot_head
;@ Part 2, a fireball: drawn from HotHeadFireballSprites, hurts Link on contact, then runs its state.
HotHeadFireball::
;> DrawEntity16x16(slot, HotHeadFireballSprites)
	ld de, HotHeadFireballSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> EntityCheckContactDamage(slot)                            # hurts Link on contact
	call EntityCheckContactDamage
;> HotHeadFireballStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/hot_head
;@ A fireball's states, by wEntityState.
HotHeadFireballStates::
	dw FireballFlyState
	dw FireballBurstState

;@ def FireballFlyState(slot: bc)
;@ path: boss/hot_head
;@ State 0: the fireball flies on its arc (z speed down by 1 a frame), spinning (frames 0/1 every 8
;@ frames); when it lands it bursts for $0F frames (state 1).
FireballFlyState::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:              # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6722

;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x0F
	call GetEntityTimer
	ld [hl], $0f

;> f = (hFrameCounter >> 3) & 1
jr_005_6722:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
	ret


;@ def FireballBurstState(slot: bc)
;@ path: boss/hot_head
;@ State 1: the burst, frames 2 and 3 (by timer bit 3); gone when the timer runs out.
FireballBurstState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return ClearEntityStatus_05(slot)
	jp z, ClearEntityStatus_05

;> f = ((t >> 3) & 1) + 2
	rra
	rra
	rra
	and $01
	inc a
	inc a
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
	ret


;@ path: boss/hot_head
;@ Shell half sprite pairs for DrawEntity16x16 (tile, attr), 2 frames: 0 the left half ($6C, $6E), 1 the
;@ right half (the same mirrored).
HotHeadShellSprites::
	db $6c, $00, $6e, $00, $6e, $20, $6c, $20

;@ def HotHeadShellHalf(slot: bc)
;@ path: boss/hot_head
;@ Part 3, a half of the broken shell: flies on its arc (z speed down by 1 a frame); when it lands it
;@ turns into a fireball (part 2, hidden for now) that, still in state 0, at once bursts for $0F
;@ frames.
HotHeadShellHalf::
;> DrawEntity16x16(slot, HotHeadShellSprites)
	ld de, HotHeadShellSprites
	call DrawEntity16x16
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> AddEntityZSpeedToPos_05(slot)
	call AddEntityZSpeedToPos_05
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:              # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6775

;>     wEntityZ[slot] = 0
	xor a
	ld [hl], a
;>     wEntityTimer[slot] = 0x0F
	call GetEntityTimer
	ld [hl], $0f
;>     wEntityPrivate1[slot] = 2
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $02
;>     SetEntitySpriteVariant(slot, 0xFF)
	ld a, $ff
	call SetEntitySpriteVariant

;> return
jr_005_6775:
	ret


;@ def DodongoSnakeInit(slot: bc)
;@ path: boss/dodongo_snake
;@ Sets up a Dodongo Snake (entity $60) when it appears; reached through a bank-0 trampoline. Each
;@ snake keeps a 64-entry trail of its past x and y (in wEntityWorkRAM and wEntityWorkRAM2, 64 bytes
;@ per snake by wEntityLoadOrder); this clears the first 32 entries of both. The snake starts moving
;@ down (y speed 6, frame 3) with its timer and timer 1 at $40.
DodongoSnakeInit::
;>@b base = (wEntityLoadOrder[slot] << 6) & 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	sla e
	ld d, b
;>@x for i in range(32): wEntityWorkRAM[base + i] = 0      # x trail
	ld hl, wEntityWorkRAM
	add hl, de
	push de
	ld e, $20
.clearX:
;=@x
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, .clearX
;>@y for i in range(32): wEntityWorkRAM2[base + i] = 0     # y trail
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ld e, $20
.clearY:
;=@y
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, .clearY
;> wEntitySpeedY[slot] = 6
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $06
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> wEntityTimer1[slot] = 0x40
	call GetEntityTimer1
	ld [hl], $40
;> wEntitySpriteVariant[slot] = 3        # facing down
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], $03
;> return
	ret

;@ path: boss/dodongo_snake
;@ Dodongo Snake x speed by direction (its sprite variant): 0 right +6, 1 left -6, 2 up 0, 3 down 0.
DodongoSpeedX::
	db $06, $fa, $00, $00

;@ path: boss/dodongo_snake
;@ Dodongo Snake y speed by direction: 0 right 0, 1 left 0, 2 up -6, 3 down +6.
DodongoSpeedY::
	db $00, $00, $fa, $06

;@ path: boss/dodongo_snake
;@ How many frames behind on the trail the head is drawn, by the 4-frame phase of the trail counter
;@ (wEntityPrivateCounter >> 2 & 3): 2, 1, 0, 1 - the head bobs back and forth. Copied to
;@ wEntityPrivate1.
DodongoHeadLag::
	db $02, $01, $00, $01

;@ path: boss/dodongo_snake
;@ How many frames behind on the trail the tail ball is drawn, same index: $21, $22, $23, $22.
;@ Copied to wEntityPrivate2.
DodongoTailLag::
	db $21, $22, $23, $22

;@ def DodongoSnakeEntityHandler(slot: bc)
;@ path: boss/dodongo_snake
;@ Entity $60, a Dodongo Snake: a head and a tail ball that follow its trail. It crawls in straight
;@ lines and turns by a quarter every $40-$5F frames (towards Link every 4th turn). It swallows a
;@ bomb lying in front of its mouth; the third one blows it up from inside.
DodongoSnakeEntityHandler::
;> if hMapId == 7:
	ldh a, [hMapId]
	cp $07
	jr nz, jr_005_67d7

;>     hActiveEntityTileOffset = 0x10    # its tiles lie elsewhere in this dungeon
	ld a, $10
	ldh [hActiveEntityTileOffset], a

;> DrawDodongoSnake(slot)
jr_005_67d7:
	call DrawDodongoSnake
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> StartBossMusic()                            # starts the boss music
	call StartBossMusic
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits(slot)                            # sword hits and contact damage
	call EntityCheckHits
;> DodongoSnakeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/dodongo_snake
;@ The Dodongo Snake's states, by wEntityState.
DodongoSnakeStates::
	dw DodongoCrawlState
	dw DodongoTurnState
	dw DodongoSwallowState

;@ def DodongoCrawlState(slot: bc)
;@ path: boss/dodongo_snake
;@ State 0: crawls on until the timer runs out (then state 1). Every frame it records its position in
;@ its trail (entry wEntityPrivateCounter, 0-$3F), sets the head and tail lags (DodongoHeadLag /
;@ DodongoTailLag) and moves. An active bomb (entity 2, status 5) lying on the ground less than 6 pixels
;@ from it (x and y), with timer $38 or more, is swallowed: state 2 with timer 2 at $60, flashing $0C frames,
;@ wEntityPrivate4 (bombs swallowed) + 1, jingle $2A.
DodongoCrawlState::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_67f9

;>     wEntityTimer[slot] = 0
	ld [hl], $00
;>     wEntityState[slot] += 1
	call IncrementEntityState

;> n = (wEntityPrivateCounter[slot] + 1) & 0x3F
jr_005_67f9:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $3f
;> wEntityPrivateCounter[slot] = n
	ld [hl], a
;> hMultiPurpose0 = n
	ldh [hMultiPurpose0], a
;> phase = (n >> 2) & 3
	rra
	rra
	nop
	and $03
	ld e, a
	ld d, $00
;> wEntityPrivate1[slot] = DodongoHeadLag[phase]
	ld hl, DodongoHeadLag
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wEntityPrivate2[slot] = DodongoTailLag[phase]
	ld hl, DodongoTailLag
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;>@b base = (wEntityLoadOrder[slot] << 6) & 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	sla e
	ld d, $00
;>@x wEntityWorkRAM[base + n] = hActiveEntityX        # x trail
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
;=@x
	ldh a, [hActiveEntityX]
	ld [hl], a
;>@y wEntityWorkRAM2[base + n] = hActiveEntityDrawY   # y trail
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
;=@y
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)                            # background collisions
	call EntityCheckWalls
;> for e in range(15, 0, -1):             # look for a bomb at its mouth
	ld e, $0f
	ld d, b

;>     if wEntityStatus[e] != 5: continue
jr_005_6854:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_005_68b1

;>     if wEntityType[e] != 2: continue  # not a bomb
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_005_68b1

;>     if wEntityTimer[e] < 0x38: continue
	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	cp $38
	jr c, jr_005_68b1

;>     dx = (hActiveEntityX - wEntityX[e] + 6) & 0xFF
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $06
;>     if dx >= 0x0C: continue
	cp $0c
	jr nc, jr_005_68b1

;>     dy = (hActiveEntityDrawY - wEntityY[e] + 6) & 0xFF
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $06
;>     if dy >= 0x0C: continue
	cp $0c
	jr nc, jr_005_68b1

;>     if wEntityZ[e] != 0: continue
	ld hl, wEntityZ
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_005_68b1

;>     wEntityStatus[e] = 0               # swallowed
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer2[slot] = 0x60
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $60
;>     wEntityFlashTimer[slot] = 0x0C
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $0c
;>     wEntityPrivate4[slot] += 1        # bombs swallowed
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
;>     hJingle = 0x2A
	ld a, $2a
	ldh [hJingle], a
;>     return
	ret


;>     # next slot
jr_005_68b1:
	dec e
	jr nz, jr_005_6854

;> return
	ret


;@ def DodongoTurnState(slot: bc)
;@ path: boss/dodongo_snake
;@ State 1: waits for its timer (after a swallow), then turns by a quarter: towards Link every 4th
;@ turn (wEntityPrivate3 counts them) if that is a quarter turn, else a random one. It sets the
;@ direction's frame and speed (DodongoSpeedX/Y) and crawls on for $40-$5F frames (state 0).
DodongoTurnState::
;> if GetEntityTimer(slot) != 0: return
	call GetEntityTimer
	jr nz, jr_005_68fe

;> wEntityTimer[slot] = 0x40 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $40
	ld [hl], a
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> wEntityPrivate3[slot] = (wEntityPrivate3[slot] + 1) & 3
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
;> if wEntityPrivate3[slot] == 0:
	jr nz, jr_005_68d6

;>     e = GetEntityDirectionToLink_05(slot)
	call GetEntityDirectionToLink_05
	jr jr_005_68dc

;> else:
;>     e = GetRandomByte() & 3
jr_005_68d6:
	call GetRandomByte
	and $03
	ld e, a

;> while (e ^ hActiveEntitySpriteVariant) & 2 == 0:     # not a quarter turn
;>     e = GetRandomByte() & 3
jr_005_68dc:
	ld hl, hActiveEntitySpriteVariant
	xor [hl]
	and $02
	jr z, jr_005_68d6

;> wEntitySpriteVariant[slot] = e
	ld d, b
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], e
;> wEntitySpeedX[slot] = DodongoSpeedX[e]
	ld hl, DodongoSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = DodongoSpeedY[e]
	ld hl, DodongoSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

;> return
jr_005_68fe:
	ret


;@ path: boss/dodongo_snake
;@ X offset of the explosion of the third bomb from the snake, by direction (0 right, 1 left, 2 up,
;@ 3 down): -13, +13, 0, 0 - at its tail end.
DodongoBombOffsetX::
	db $f3, $0d, $00, $00

;@ path: boss/dodongo_snake
;@ Y offset of that explosion, same index: 0, 0, +13, -13.
DodongoBombOffsetY::
	db $00, $00, $0d, $f3

;@ path: boss/dodongo_snake
;@ X offset of the puff out of its mouth after a swallow, by direction: +12, -12, 0, 0.
DodongoPuffOffsetX::
	db $0c, $f4, $00, $00

;@ path: boss/dodongo_snake
;@ Y offset of the puff, same index: 0, 0, -12, +12.
DodongoPuffOffsetY::
	db $00, $00, $f4, $0c

;@ def DodongoSwallowState(slot: bc)
;@ path: boss/dodongo_snake
;@ State 2, a swallowed bomb (timer 2 counting down from $60; the body swells meanwhile, see
;@ DrawDodongoWhole): a clink at $24; with the third bomb it blows up at $20 (an explosion at its
;@ tail and EndBossFight_05); a puff out of its mouth at 4. When timer 2 runs out it waits $30 frames
;@ (state 1).
DodongoSwallowState::
;> t2 = wEntityTimer2[slot]
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
;> if t2 == 0:
	and a
	jr nz, jr_005_6922

;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     return
	ret


;> if t2 == 0x24:
jr_005_6922:
	cp $24
	jr nz, jr_005_6929

;>     PlayClinkNoise()
	call PlayClinkNoise

;> if t2 == 4:
jr_005_6929:
	cp $04
	jr nz, jr_005_6949

;>     v = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
;>     hMultiPurpose0 = (hActiveEntityX + DodongoPuffOffsetX[v]) & 0xFF
	ld hl, DodongoPuffOffsetX
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = (hActiveEntityDrawY + DodongoPuffOffsetY[v]) & 0xFF
	ld hl, DodongoPuffOffsetY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hMultiPurpose1], a
;>     AddTransientVfx(2)                 # a puff
	ld a, $02
	call AddTransientVfx
;>     t2 = 0
	xor a

;> if t2 == 0x20:
jr_005_6949:
	cp $20
	jr nz, jr_005_6985

;>     if wEntityPrivate4[slot] == 3:    # the third bomb
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_005_6985

;>         new = SpawnEntity(2)             # a bomb, at the snake (hMultiPurpose0/1)
	ld a, $02
	call SpawnEntity
;>         if new is not None:
	jr c, jr_005_6985

;>             wEntityTimer[new] = 0x17   # bursts at once
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
;>             v = wEntitySpriteVariant[slot]
	push bc
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld c, [hl]
;>@x             wEntityX[new] = (hMultiPurpose0 + DodongoBombOffsetX[v]) & 0xFF
	ld hl, DodongoBombOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
;=@x
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@y             wEntityY[new] = (hMultiPurpose1 + DodongoBombOffsetY[v]) & 0xFF
	ld hl, DodongoBombOffsetY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
;=@y
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             EndBossFight_05(slot)
	pop bc
	call EndBossFight_05

;> return
jr_005_6985:
	ret


;@ path: boss/dodongo_snake
;@ Dodongo Snake part sprite pairs for DrawEntity16x16 (tile, attr for the left and right half), 5 frames:
;@ the head facing 0 right ($66, $64 mirrored), 1 left ($64, $66), 2 up ($62 and its mirror), 3 down
;@ ($60 and its mirror); 4 the tail ball ($68 and its mirror).
DodongoSegmentSprites::
	db $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20, $60, $00, $60, $20
	db $68, $00, $68, $20

;@ def DrawDodongoSnake(slot: bc)
;@ path: boss/dodongo_snake
;@ Draws the snake: as one sprite group (DrawDodongoWhole) while timer 1 or timer 2 runs or during a
;@ room transition; otherwise head and tail ball from its trail (facing up, the tail first).
DrawDodongoSnake::
;>@w w = GetEntityTimer1(slot) | wRoomTransitionState | wEntityTimer2[slot]
	call GetEntityTimer1
	ld hl, wRoomTransitionState
	or [hl]
;=@w
	ld hl, wEntityTimer2
	add hl, bc
	or [hl]
;> if w != 0: return DrawDodongoWhole(slot)
	jp nz, DrawDodongoWhole

;> if hActiveEntitySpriteVariant == 2:
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, jr_005_69b8

;>     DrawDodongoTail(slot)
	call DrawDodongoTail
;>     DrawDodongoHead(slot)
	call DrawDodongoHead
;>     return LoadEntityPosition(slot)                 # restore the active vars
	jp LoadEntityPosition


;> DrawDodongoHead(slot)
jr_005_69b8:
	call DrawDodongoHead
;> DrawDodongoTail(slot)
	call DrawDodongoTail
;> return LoadEntityPosition(slot)
	jp LoadEntityPosition


;@ def DrawDodongoHead(slot: bc)
;@ path: boss/dodongo_snake
;@ Draws the head (DodongoSegmentSprites, the snake's frame) where the snake was wEntityPrivate1
;@ frames ago on its trail.
DrawDodongoHead::
;> hMultiPurpose0 = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>@b base = (wEntityLoadOrder[slot] << 6) & 0xFF
	push bc
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
;> lag = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld c, [hl]
;=@b
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	sla e
	ld d, b
;>@x hActiveEntityX = wEntityWorkRAM[base + ((hMultiPurpose0 - lag) & 0x3F)]
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
;=@x
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>@y hActiveEntityDrawY = wEntityWorkRAM2[base + ((hMultiPurpose0 - lag) & 0x3F)]
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
;=@y
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(slot, DodongoSegmentSprites)
	pop bc
	ld de, DodongoSegmentSprites
	call DrawEntity16x16
	ret


;@ def DrawDodongoTail(slot: bc)
;@ path: boss/dodongo_snake
;@ Draws the tail ball (DodongoSegmentSprites frame 4) where the snake was wEntityPrivate2 frames
;@ ago on its trail.
DrawDodongoTail::
;> hMultiPurpose0 = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>@b base = (wEntityLoadOrder[slot] << 6) & 0xFF
	push bc
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
;> lag = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld c, [hl]
;=@b
	sla e
	sla e
	sla e
;=@b
	sla e
	sla e
	sla e
	ld d, b
;>@x hActiveEntityX = wEntityWorkRAM[base + ((hMultiPurpose0 - lag) & 0x3F)]
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
;=@x
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;>@y hActiveEntityDrawY = wEntityWorkRAM2[base + ((hMultiPurpose0 - lag) & 0x3F)]
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
;=@y
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = 4
	pop bc
	ld a, $04
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, DodongoSegmentSprites)
	ld de, DodongoSegmentSprites
	call DrawEntity16x16
;> hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> return
	ret


;@ path: boss/dodongo_snake
;@ The Dodongo Snake in one piece (DrawDodongoWhole outside the swelling), 4 DrawEntitySprites lists of 4
;@ sprites (dy, dx, tile, attr), by direction: the head (2 sprites at dx 0 and 8) with the tail ball
;@ ($68 and its mirror) right behind it - 0 right: ball at dx -13/-5; 1 left: at +13/+21; 2 up: at
;@ dy +13; 3 down: at dy -13.
DodongoShortSprites::
	db $00, $00, $66, $20, $00, $08, $64, $20, $00, $f3, $68, $00, $00, $fb, $68, $20
	db $00, $00, $64, $00, $00, $08, $66, $00, $00, $0d, $68, $00, $00, $15, $68, $20
	db $00, $00, $62, $00, $00, $08, $62, $20, $0d, $00, $68, $00, $0d, $08, $68, $20
	db $00, $00, $60, $00, $00, $08, $60, $20, $f3, $00, $68, $00, $f3, $08, $68, $20
;@ path: boss/dodongo_snake
;@ The Dodongo Snake fully swollen by a bomb, 4 DrawEntitySprites lists of 10 sprites (dy, dx, tile, attr)
;@ by direction: the head (2 sprites) and behind it a 32x32 body ball of tiles $6A, $6C, $6E,
;@ mirrored into 4 quarters (dy -8 and +8, dx -$14 to +4 for direction 0).
DodongoSwollenSprites::
	db $00, $04, $66, $20, $00, $0c, $64, $20, $f8, $ec, $6c, $00, $f8, $f4, $6a, $00
	db $f8, $fc, $6a, $20, $f8, $04, $6c, $20, $08, $ec, $6c, $40, $08, $f4, $6e, $40
	db $08, $fc, $6e, $60, $08, $04, $6c, $60, $00, $fc, $64, $00, $00, $04, $66, $00
	db $f8, $04, $6c, $00, $f8, $0c, $6a, $00, $f8, $14, $6a, $20, $f8, $1c, $6c, $20
	db $08, $04, $6c, $40, $08, $0c, $6e, $40, $08, $14, $6e, $60, $08, $1c, $6c, $60
	db $04, $f8, $6c, $00, $04, $00, $6a, $00, $04, $08, $6a, $20, $04, $10, $6c, $20
	db $14, $f8, $6c, $40, $14, $00, $6e, $40, $14, $08, $6e, $60, $14, $10, $6c, $60
	db $fc, $00, $62, $00, $fc, $08, $62, $20, $04, $00, $60, $00, $04, $08, $60, $20
	db $ec, $f8, $6c, $00, $ec, $00, $6a, $00, $ec, $08, $6a, $20, $ec, $10, $6c, $20
	db $fc, $f8, $6c, $40, $fc, $00, $6e, $40, $fc, $08, $6e, $60, $fc, $10, $6c, $60
;@ path: boss/dodongo_snake
;@ The Dodongo Snake half swollen (as the bomb goes in and as it shrinks again), 4 DrawEntitySprites lists
;@ of 10 sprites by direction, laid out like DodongoSwollenSprites but with the body quarters
;@ overlapping (a 26x26 ball: dy -5 and +5, dx -$11 to +1 for direction 0).
DodongoHalfSwollenSprites::
	db $00, $02, $66, $20, $00, $0a, $64, $20, $fb, $ef, $6c, $00, $fb, $f7, $6e, $00
	db $fb, $f9, $6e, $20, $fb, $01, $6c, $20, $05, $ef, $6c, $40, $05, $f7, $6e, $40
	db $05, $f9, $6e, $60, $05, $01, $6c, $60, $00, $fe, $64, $00, $00, $02, $66, $00
	db $fb, $07, $6c, $00, $fb, $0f, $6e, $00, $fb, $11, $6e, $20, $fb, $19, $6c, $20
	db $05, $07, $6c, $40, $05, $0f, $6e, $40, $05, $11, $6e, $60, $05, $19, $6c, $60
	db $07, $fb, $6c, $00, $07, $03, $6e, $00, $07, $05, $6e, $20, $07, $0d, $6c, $20
	db $11, $fb, $6c, $40, $11, $03, $6e, $40, $11, $05, $6e, $60, $11, $0d, $6c, $60
	db $fe, $00, $62, $00, $fe, $08, $62, $20, $02, $00, $60, $00, $02, $08, $60, $20
	db $ef, $fb, $6c, $00, $ef, $03, $6e, $00, $ef, $05, $6e, $20, $ef, $0d, $6c, $20
	db $f9, $fb, $6c, $40, $f9, $03, $6e, $40, $f9, $05, $6e, $60, $f9, $0d, $6c, $60

;@ def DrawDodongoWhole(slot: bc)
;@ path: boss/dodongo_snake
;@ Draws the snake in one piece at its position, by timer 2 (the swallow): from $27 down to $22 and
;@ from $0D down to 8 half swollen, from $21 down to $0E fully swollen (10 sprites each), otherwise
;@ the short form (DodongoShortSprites).
DrawDodongoWhole::
;> t2 = wEntityTimer2[slot]
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
;> if 8 <= t2 < 0x28:
	cp $08
	jr c, jr_005_6c12

	cp $28
	jr nc, jr_005_6c12

;>     sprites = DodongoHalfSwollenSprites
	ld hl, DodongoHalfSwollenSprites
;>     if 0x0E <= t2 < 0x22:
	cp $0e
	jr c, jr_005_6bf5

	cp $22
	jr nc, jr_005_6bf5

;>         sprites = DodongoSwollenSprites
	ld hl, DodongoSwollenSprites

;>@o     e = hActiveEntitySpriteVariant * 40
jr_005_6bf5:
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	sla e
	sla e
	sla e
;=@o
	ld a, e
	sla e
	sla e
	add e
	ld e, a
;>     DrawEntitySprites(10, sprites + e)
	add hl, de
	ld c, $0a
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
;>     return
	ret


;> e = (hActiveEntitySpriteVariant << 4) & 0xF0
jr_005_6c12:
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;> DrawEntitySprites(4, DodongoShortSprites + e)
	ld e, a
	ld d, b
	ld hl, DodongoShortSprites
	add hl, de
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> return
	ret


;@ def SlimeEelInit(slot: bc)
;@ path: boss/slime_eel
;@ Sets up the Slime Eel (entity $5D) when it appears; reached through a bank-0 trampoline. The quake
;@ starts after $80 frames; the shared boss bytes are cleared: wEntityWorkRAM3[0] (a head is out),
;@ [3] (times a head was hooked) and [4] (hits on its weak spot). The tail turns with step +1.
SlimeEelInit::
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityWorkRAM3[0] = 0
	xor a
	ld [wEntityWorkRAM3], a
;> wEntityWorkRAM3[3] = 0
	ld [wEntityWorkRAM3 + 3], a
;> wEntityWorkRAM3[4] = 0
	ld [wEntityWorkRAM3 + 4], a
;> wEntityPrivate5[slot] = 1
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], $01
;> return
	ret

;@ def SlimeEelEntityHandler(slot: bc)
;@ path: boss/slime_eel
;@ Entity $5D, the Slime Eel of the fifth dungeon, and its parts (by wEntityPrivate1): 0 the spiked
;@ tail spinning in the middle of the room (the first entity, it runs the fight), 1 a head looking out
;@ of one of the 4 wall holes, 2 the eel pulled out of its hole, crawling around.
SlimeEelEntityHandler::
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> StartBossMusic()                            # starts the boss music
	call StartBossMusic
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> SlimeEelParts[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/slime_eel
;@ The Slime Eel's parts, by wEntityPrivate1.
SlimeEelParts::
	dw SlimeEelTail
	dw SlimeEelHead
	dw SlimeEelLoose

;@ def SlimeEelTail(slot: bc)
;@ path: boss/slime_eel
;@ Part 0, the tail: remembers its slot in wEntityWorkRAM3[1] (for the other parts) and runs its state.
SlimeEelTail::
;> wEntityWorkRAM3[1] = slot
	ld a, c
	ld [wEntityWorkRAM3 + 1], a
;> SlimeEelTailStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/slime_eel
;@ The tail's states, by wEntityState.
SlimeEelTailStates::
	dw SlimeEelQuakeState
	dw SlimeEelRiseState
	dw SlimeEelOpenHolesState
	dw SlimeEelSpinTail

;@ def SlimeEelQuakeState(slot: bc)
;@ path: boss/slime_eel
;@ State 0: when the timer runs out the room quakes (bump shake for $FF frames, axis 4, rumble noise
;@ $3E, also put in the sound byte $D3E8) and $80 frames follow (state 1).
SlimeEelQuakeState::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_6c80

;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wBumpShakeTimer = 0xFF
	ld a, $ff
	ld [wBumpShakeTimer], a
;>     hNoiseSfx = 0x3E
	ld a, $3e
	ldh [hNoiseSfx], a
;>     mem[0xD3E8] = 0x3E
	ld [wHoldNoiseSfx3E], a
;>     wBumpShakeAxis = 4
	ld a, $04
	ld [wBumpShakeAxis], a
;>     wEntityState[slot] += 1
	call IncrementEntityState

;> return
jr_005_6c80:
	ret


;@ path: boss/slime_eel
;@ X of the 4 wall holes as used for their background tiles (hBGPosX): $20, $60 (top wall), $20,
;@ $60 (bottom wall).
SlimeEelHoleX::
	db $20, $60, $20, $60

;@ path: boss/slime_eel
;@ Y of the 4 wall holes for their background tiles (hBGPosY): 0, 0, $70, $70.
SlimeEelHoleY::
	db $00, $00, $70, $70

;@ path: boss/slime_eel
;@ Background tiles of each opened hole, 4 x 8 bytes: a row of 4 tiles at the hole's position, then
;@ the 4 tiles of the row below. Holes 0-1 (top wall): $08 x 4 / $09, $0B, $0B, $0A; holes 2-3
;@ (bottom wall): $05, $07, $07, $06 / $04 x 4.
SlimeEelHoleTiles::
	db $08, $08, $08, $08, $09, $0b, $0b, $0a
	db $08, $08, $08, $08, $09, $0b, $0b, $0a, $05, $07, $07, $06, $04, $04, $04, $04
	db $05, $07, $07, $06, $04, $04, $04, $04

;@ def SlimeEelRiseState(slot: bc)
;@ path: boss/slime_eel
;@ State 1: the tail sits in the middle (x $48, y $48; background position $38, $30). At timer $40
;@ the floor there changes (SlimeEelCrackFloor). When the timer runs out a pit opens in the middle
;@ (4 columns of tiles $76, $7E, $7E, $77; its 4 squares become objects $AF / $B0) with rubble and a
;@ clink: the tail grows out (timer 1 $1F), the first head comes after $B0 frames and the holes open
;@ during the next $FF frames (state 2).
SlimeEelRiseState::
;> hBGPosX = 0x38
	ld a, $38
	ldh [hBGPosX], a
;> wEntityX[slot] = 0x48
	add $10
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> hBGPosY = 0x30
	ld a, $30
	ldh [hBGPosY], a
;> wEntityY[slot] = 0x48
	add $18
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t != 0: return SlimeEelCrackFloor(t)
	jp nz, SlimeEelCrackFloor

;> wEntityTimer[slot] = 0xFF
	ld [hl], $ff
;> mem[0xD3E8] = 0
	xor a
	ld [wHoldNoiseSfx3E], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wRoomObjects[0x34] = 0xAF
	ld a, $af
	ld [wRoomObjects + $34], a
;> wRoomObjects[0x35] = 0xAF
	ld a, $af
	ld [wRoomObjects + $35], a
;> wRoomObjects[0x44] = 0xB0
	ld a, $b0
	ld [wRoomObjects + $44], a
;> wRoomObjects[0x45] = 0xB0
	ld a, $b0
	ld [wRoomObjects + $45], a
;> wEntityTimer1[slot] = 0x1F             # the tail grows out
	call GetEntityTimer1
	ld [hl], $1f
;> wEntityDropTimer[slot] = 0xB0          # frames until the first head
	call GetEntityDropTimer
	ld [hl], $b0
;> BreakIntoPiecesFar()                            # rubble flies (BreakIntoPieces, bank 3)
	call BreakIntoPiecesFar
;> wEntityStatus[slot] = 5                # stays active
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> wEntityX[slot] += 0x10
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
;> BreakIntoPiecesFar()
	call BreakIntoPiecesFar
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> BreakIntoPiecesFar()
	call BreakIntoPiecesFar
;> PlayClinkNoise()
	call PlayClinkNoise
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> GetBGAddress()                         # of hBGPosX/Y
	call GetBGAddress
;> n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
;> p = wDrawCommand + n
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize = n + 0x1C           # 4 commands of 7 bytes
	add $1c
	ld [wDrawCommandsSize], a
;> p = SlimeEelPitColumn(p)
	call SlimeEelPitColumn
;> p = SlimeEelPitColumn(p)
	call SlimeEelPitColumn
;> p = SlimeEelPitColumn(p)
	call SlimeEelPitColumn
;> SlimeEelPitColumn(p)                   # runs on into it

;@ def SlimeEelPitColumn(p: hl)
;@ path: boss/slime_eel
;@ Adds a draw command for the next background column (hBGAddrLow + 1): 4 tiles down, $76, $7E,
;@ $7E, $77, and ends the list after it. Returns the end of the command.
SlimeEelPitColumn::
;> mem[p] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> hBGAddrLow = (hBGAddrLow + 1) & 0xFF
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
;> mem[p + 1] = hBGAddrLow
	ld [hli], a
;> mem[p + 2] = 0x83                      # 4 tiles, going down
	ld a, $83
	ld [hli], a
;> mem[p + 3] = 0x76
	ld a, $76
	ld [hli], a
;> mem[p + 4] = 0x7E
	ld a, $7e
	ld [hli], a
;> mem[p + 5] = 0x7E
	ld a, $7e
	ld [hli], a
;> mem[p + 6] = 0x77
	ld a, $77
	ld [hli], a
;> mem[p + 7] = 0                         # end of the list
	xor a
	ld [hl], a
;> return p + 7
	ret


;@ def SlimeEelCrackFloor(t: a)
;@ path: boss/slime_eel
;@ At timer $40 of the rise, draws 4 background columns in the middle with tiles $1C/$1E and $1D/$1F
;@ (SlimeEelCrackColumns twice).
SlimeEelCrackFloor::
;> if t != 0x40: return
	cp $40
	jp nz, Jump_005_6d94

;> GetBGAddress()
	call GetBGAddress
;> n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
;> p = wDrawCommand + n
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize = n + 0x1C
	add $1c
	ld [wDrawCommandsSize], a
;> p = SlimeEelCrackColumns(p)
	call SlimeEelCrackColumns
;> SlimeEelCrackColumns(p)                # runs on into it

;@ def SlimeEelCrackColumns(p: hl)
;@ path: boss/slime_eel
;@ Adds draw commands for the next 2 background columns, 4 tiles down each: $1C, $1E, $1C, $1E and
;@ $1D, $1F, $1D, $1F; ends the list after them. Returns the end.
SlimeEelCrackColumns::
;> mem[p] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> hBGAddrLow = (hBGAddrLow + 1) & 0xFF
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
;> mem[p + 1] = hBGAddrLow
	ld [hli], a
;> mem[p + 2] = 0x83
	ld a, $83
	ld [hli], a
;> mem[p + 3] = 0x1C
	ld a, $1c
	ld [hli], a
;> mem[p + 4] = 0x1E
	ld a, $1e
	ld [hli], a
;> mem[p + 5] = 0x1C
	ld a, $1c
	ld [hli], a
;> mem[p + 6] = 0x1E
	ld a, $1e
	ld [hli], a
;> mem[p + 7] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> hBGAddrLow = (hBGAddrLow + 1) & 0xFF
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
;> mem[p + 8] = hBGAddrLow
	ld [hli], a
;> mem[p + 9] = 0x83
	ld a, $83
	ld [hli], a
;> mem[p + 10] = 0x1D
	ld a, $1d
	ld [hli], a
;> mem[p + 11] = 0x1F
	ld a, $1f
	ld [hli], a
;> mem[p + 12] = 0x1D
	ld a, $1d
	ld [hli], a
;> mem[p + 13] = 0x1F
	ld a, $1f
	ld [hli], a
;> mem[p + 14] = 0                        # end of the list
	xor a
	ld [hl], a

;> return p + 14
Jump_005_6d94:
	ret


;@ def SlimeEelOpenHolesState(slot: bc)
;@ path: boss/slime_eel
;@ State 2: the tail spins (SlimeEelSpinTail, its own position kept). At timer $98, $68, $38 and 8
;@ the next of the 4 wall holes breaks open: its background tiles (SlimeEelHoleTiles), the room
;@ objects of all 4 holes ($D5, $D6 in the top wall, $D7, $D8 in the bottom wall), a head looking
;@ out of it ($2F frames), rubble and a clink. When the timer runs out the fight goes on (state 3).
SlimeEelOpenHolesState::
;> x = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	push af
;> y = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push af
;> SlimeEelSpinTail(slot)
	call SlimeEelSpinTail
;> wEntityY[slot] = y
	pop af
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;> wEntityX[slot] = x
	pop af
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> LoadEntityPosition(slot)                            # active vars from the entity
	call LoadEntityPosition
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0:
	jr nz, jr_005_6dbc

;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret


;> if t != 0x98 and t != 0x68 and t != 0x38 and t != 0x08: return
jr_005_6dbc:
	cp $98
	jr z, jr_005_6dcd

	cp $68
	jr z, jr_005_6dcd

;>     # (the other two values)
	cp $38
	jr z, jr_005_6dcd

	cp $08
	jp nz, Jump_005_6ea8

;> n = wEntityPrivateCounter[slot]        # holes opened so far
jr_005_6dcd:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> if n == 4: return
	cp $04
	jp z, Jump_005_6ea8

;> wEntityPrivateCounter[slot] = n + 1
	inc [hl]
;> hBGPosX = SlimeEelHoleX[n]
	ld e, a
	ld d, b
	ld hl, SlimeEelHoleX
	add hl, de
	ld a, [hl]
	ldh [hBGPosX], a
;> hBGPosY = SlimeEelHoleY[n]
	ld hl, SlimeEelHoleY
	add hl, de
	ld a, [hl]
	ldh [hBGPosY], a
;> tiles = SlimeEelHoleTiles + 8 * n
	sla e
	sla e
	sla e
	ld hl, SlimeEelHoleTiles
	add hl, de
	push hl
;> GetBGAddress()
	call GetBGAddress
;> m = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
;> p = wDrawCommand + m
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize = m + 0x0E           # 2 commands of 7 bytes
	add $0e
	ld [wDrawCommandsSize], a
;> mem[p] = hBGAddrHigh
	pop de
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[p + 1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> mem[p + 2] = 3                         # 4 tiles across
	ld a, $03
	ld [hli], a
;>@r1 for i in range(4): mem[p + 3 + i] = tiles[i]
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;=@r1
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;> mem[p + 7] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> mem[p + 8] = (hBGAddrLow + 0x20) & 0xFF            # the row below
	ldh a, [hBGAddrLow]
	add $20
	ld [hli], a
;> mem[p + 9] = 3
	ld a, $03
	ld [hli], a
;>@r2 for i in range(4): mem[p + 10 + i] = tiles[4 + i]
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
;=@r2
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
;> mem[p + 14] = 0                        # end of the list
	xor a
	ld [hl], a
;> wRoomObjects[0x02] = 0xD5
;> wRoomObjects[0x06] = 0xD5
	ld a, $d5
	ld [wRoomObjects + $02], a
	ld [wRoomObjects + $06], a
;> wRoomObjects[0x03] = 0xD6
;> wRoomObjects[0x07] = 0xD6
	ld a, $d6
	ld [wRoomObjects + $03], a
	ld [wRoomObjects + $07], a
;> wRoomObjects[0x72] = 0xD7
;> wRoomObjects[0x76] = 0xD7
	ld a, $d7
	ld [wRoomObjects + $72], a
	ld [wRoomObjects + $76], a
;> wRoomObjects[0x73] = 0xD8
;> wRoomObjects[0x77] = 0xD8
	ld a, $d8
	ld [wRoomObjects + $73], a
	ld [wRoomObjects + $77], a
;> new = SpawnEntity(0x5D)                # a head in the new hole
	ld a, $5d
	call SpawnEntity
;> wEntityPrivate1[new] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;> wEntityX[new] = (hBGPosX + 0x10) & 0xFF
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $10
	ld [hl], a
;> wEntityX[slot] = wEntityX[new]         # the tail goes there for the rubble
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> wEntityY[new] = (hBGPosY + 0x10) & 0xFF
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
;> wEntityY[slot] = (wEntityY[new] + 8) & 0xFF
	ld hl, wEntityY
	add hl, bc
	add $08
	ld [hl], a
;> wEntityTimer[new] = 0x2F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $2f
;> wall = 0                               # top wall
;> if wEntityPrivateCounter[slot] >= 3:   # holes 2 and 3 are in the bottom wall
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $03
	ld a, $00
	jr c, jr_005_6e97

;>     wEntityY[slot] -= 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
;>     wall = 1
	ld a, $01

;> wEntityDirection[new] = wall
jr_005_6e97:
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;> BreakIntoPiecesFar()                            # rubble
	call BreakIntoPiecesFar
;> wEntityStatus[slot] = 5
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
;> PlayClinkNoise()
	call PlayClinkNoise

;> return
Jump_005_6ea8:
	ret


;@ path: boss/slime_eel
;@ Circle of radius $30 for the tail's segments: 40 signed offsets; for an angle i of 32 steps the y
;@ offset is [i] and the x offset [i + 8] (so [0] = -$30 is straight up). Same layout for
;@ SlimeEelRing3 to SlimeEelRing0.
SlimeEelRing4::
	db $d0, $d1, $d4, $d9, $df, $e6, $ee, $f7, $00, $09, $12, $1a, $21, $27, $2c, $2f
	db $30, $2f, $2c, $27, $21, $1a, $12, $09, $00, $f7, $ee, $e6, $df, $d9, $d4, $d1
	db $d0, $d1, $d4, $d9, $df, $e6, $ee, $f7

;@ path: boss/slime_eel
;@ Circle of radius $26 (40 bytes, laid out like SlimeEelRing4).
SlimeEelRing3::
	db $da, $db, $dd, $e1, $e6, $eb, $f2, $f9
	db $00, $07, $0e, $15, $1a, $1f, $23, $25, $26, $25, $23, $1f, $1a, $15, $0e, $07
	db $00, $f9, $f2, $eb, $e6, $e1, $dd, $db, $da, $db, $dd, $e1, $e6, $eb, $f2, $f9
;@ path: boss/slime_eel
;@ Circle of radius $1C (40 bytes, laid out like SlimeEelRing4).
SlimeEelRing2::
	db $e4, $e5, $e7, $e9, $ed, $f1, $f6, $fb, $00, $05, $0a, $0f, $13, $17, $19, $1b
	db $1c, $1b, $19, $17, $13, $0f, $0a, $05, $00, $fb, $f6, $f1, $ed, $e9, $e7, $e5
	db $e4, $e5, $e7, $e9, $ed, $f1, $f6, $fb

;@ path: boss/slime_eel
;@ Circle of radius $12 (40 bytes, laid out like SlimeEelRing4).
SlimeEelRing1::
	db $ee, $ef, $f0, $f2, $f4, $f6, $fa, $fd
	db $00, $03, $06, $0a, $0c, $0e, $10, $11, $12, $11, $10, $0e, $0c, $0a, $06, $03
	db $00, $fd, $fa, $f6, $f4, $f2, $f0, $ef, $ee, $ef, $f0, $f2, $f4, $f6, $fa, $fd
;@ path: boss/slime_eel
;@ Circle of radius 8 (40 bytes, laid out like SlimeEelRing4).
SlimeEelRing0::
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff, $00, $01, $03, $04, $05, $05, $06, $07
	db $08, $07, $06, $05, $05, $04, $03, $01, $00, $ff, $fd, $fc, $fb, $fb, $fa, $f9
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff

;@ path: boss/slime_eel
;@ The whip of the tail: angle offset of its outer segment for each of 32 wobble steps (up to +-4
;@ angle steps, a smooth back and forth). SlimeEelWobble2-4 do the same with +-3, +-2 and +-1 for
;@ the segments further in; the innermost one does not wobble.
SlimeEelWobble1::
	db $00, $00, $01, $02, $03, $04, $04, $04
	db $04, $04, $04, $03, $02, $01, $00, $00, $00, $00, $ff, $fe, $fd, $fc, $fc, $fc
	db $fc, $fc, $fc, $fd, $fe, $ff, $00, $00

;@ path: boss/slime_eel
;@ Angle offset of the second segment of the tail for each of 32 wobble steps (up to +-3).
SlimeEelWobble2::
	db $00, $00, $01, $01, $02, $02, $03, $03
	db $03, $03, $03, $02, $02, $01, $01, $00, $00, $00, $ff, $ff, $fe, $fe, $fd, $fd
	db $fd, $fd, $fd, $fe, $fe, $ff, $ff, $00

;@ path: boss/slime_eel
;@ Angle offset of the third segment of the tail for each of 32 wobble steps (up to +-2).
SlimeEelWobble3::
	db $00, $00, $01, $01, $01, $02, $02, $02
	db $02, $02, $02, $02, $01, $01, $01, $00, $00, $00, $ff, $ff, $ff, $fe, $fe, $fe
	db $fe, $fe, $fe, $fe, $ff, $ff, $ff, $00

;@ path: boss/slime_eel
;@ Angle offset of the fourth segment of the tail for each of 32 wobble steps (up to +-1).
SlimeEelWobble4::
	db $00, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $00, $00

;@ path: boss/slime_eel
;@ The circles by ring number (0 innermost, radius 8, to 4, radius $30; 10 more per ring). The tail's
;@ outer segment is drawn on ring wEntityPrivate3, each further segment one ring further in.
SlimeEelRings::
	dw SlimeEelRing0
	dw SlimeEelRing1
	dw SlimeEelRing2
	dw SlimeEelRing3
	dw SlimeEelRing4

;@ path: boss/slime_eel
;@ The tail's length (wEntityPrivate3) while it grows back, by (timer 1 >> 3) & 3: 4, 3, 2, 1 - so
;@ counting timer 1 down from $1F it grows 1, 2, 3, 4.
SlimeEelTailGrowth::
	db $04, $03, $02, $01

;@ path: boss/slime_eel
;@ X of a head looking out of each of the 4 holes: $30, $70, $30, $70.
SlimeEelHeadSpawnX::
	db $30, $70, $30, $70

;@ path: boss/slime_eel
;@ Y of a head in each hole: $10, $10 (top wall), $80, $80 (bottom wall).
SlimeEelHeadSpawnY::
	db $10, $10, $80, $80

;@ path: boss/slime_eel
;@ The wall of each hole, kept in the head's wEntityDirection: 0 top, 0, 1 bottom, 1.
SlimeEelHeadSpawnWall::
	db $00, $00, $01, $01

;@ def SlimeEelSpinTail(slot: bc)
;@ path: boss/slime_eel
;@ State 3 (and drawing in state 2): every $2C frames, while no head is out (else it waits $20
;@ frames more), a head looks out of a random hole ($5F frames). While timer 1 runs the tail grows
;@ (SlimeEelTailGrowth). In state 3 with no head out it turns by wEntityPrivate5 angle steps every
;@ 8 frames. It draws its 5 segments around the middle ($50, $48): the outer one on ring
;@ wEntityPrivate3, each further one a ring further in (stopping below ring 0), whipping with
;@ SlimeEelWobble1-4 (the step advances every 4 frames, frozen while a head is out).
SlimeEelSpinTail::
;> GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if wEntityWorkRAM3[0] != 0:            # a head is out
	ld a, [wEntityWorkRAM3]
	and a
	jr z, jr_005_7016

;>     wEntityDropTimer[slot] = 0x20
	ld [hl], $20

;> if wEntityDropTimer[slot] == 0:
jr_005_7016:
	ld a, [hl]
	and a
	jr nz, jr_005_7071

;>     wEntityDropTimer[slot] = 0x2C
	ld [hl], $2c
;>     new = SpawnEntity(0x5D)
	ld a, $5d
	call SpawnEntity
;>     if new is not None:
	jr c, jr_005_7071

;>         wEntityHealth[new] = 0xFF
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $ff
;>         wEntitySpriteVariant[new] = 0xFF
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $ff
;>         wEntityPrivate1[new] = 1       # a head
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
;>         wEntityState[new] = 1
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;>         r = GetRandomByte() & 3        # the hole
	push bc
	call GetRandomByte
	and $03
	ld c, a
;>         wEntityX[new] = SlimeEelHeadSpawnX[r]
	ld hl, SlimeEelHeadSpawnX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityPrivate2[new] = SlimeEelHeadSpawnX[r]       # its hole
	ld hl, wEntityPrivate2
	add hl, de
	ld [hl], a
;>         wEntityY[new] = SlimeEelHeadSpawnY[r]
	ld hl, SlimeEelHeadSpawnY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityPrivate3[new] = SlimeEelHeadSpawnY[r]
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], a
;>         wEntityTimer[new] = 0x5F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $5f
;>@d         wEntityDirection[new] = SlimeEelHeadSpawnWall[r]
	ld hl, SlimeEelHeadSpawnWall
	add hl, bc
	ld a, [hl]
;=@d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	pop bc

;> t1 = GetEntityTimer1(slot)
jr_005_7071:
	call GetEntityTimer1
;> if t1 != 0:
	jr z, jr_005_7087

;>@g     wEntityPrivate3[slot] = SlimeEelTailGrowth[(t1 >> 3) & 3]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
;=@g
	ld hl, SlimeEelTailGrowth
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a

;>@q q = (wEntityPrivate4[slot] & 7) | wEntityWorkRAM3[0]
jr_005_7087:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and $07
;=@q
	ld hl, wEntityWorkRAM3
	or [hl]
;> if q == 0 and hActiveEntityState == 3:
	jr nz, jr_005_70a8

	ldh a, [hActiveEntityState]
	cp $03
	jr nz, jr_005_70a8

;>@r     wEntityPrivate2[slot] = (wEntityPrivate2[slot] + wEntityPrivate5[slot]) & 0x1F     # turn
	ld hl, wEntityPrivate5
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
;=@r
	add e
	and $1f
	ld [hl], a

;> k = 0
;> if wEntityWorkRAM3[0] == 0:
jr_005_70a8:
	ld a, [wEntityWorkRAM3]
	and a
	ld a, $00
	jr nz, jr_005_70ba

;>     wEntityPrivate4[slot] += 1
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
;>     k = (wEntityPrivate4[slot] >> 2) & 0x1F
	ld a, [hl]
	rra
	rra
	and $1f

;> hBGTilesRequestCopy = k                # the wobble step
jr_005_70ba:
	ldh [hBGTilesRequestCopy], a
;> wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
;> wEntityY[slot] = 0x48
	ld hl, wEntityY
	add hl, bc
	ld [hl], $48
;>@i1 i = (SlimeEelWobble1[k] + wEntityPrivate2[slot]) & 0x1F
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, SlimeEelWobble1
	add hl, de
	ld a, [hl]
;=@i1
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
;>@t1 table = SlimeEelRings[wEntityPrivate3[slot]]
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	sla e
	ld d, b
;=@t1
	ld hl, SlimeEelRings
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
;> DrawSlimeEelSegment(2, table, i)      # the outer segment
	ld a, $02
	call DrawSlimeEelSegment
;>@i2 i = (SlimeEelWobble2[k] + wEntityPrivate2[slot]) & 0x1F
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, SlimeEelWobble2
	add hl, de
	ld a, [hl]
;=@i2
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
;> ring = wEntityPrivate3[slot] - 1
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
;> if ring < 0: return                    # (ring >= 0xF0)
	ld a, e
	cp $f0
	jp nc, SlimeEelStopSegments

;>@t2 table = SlimeEelRings[ring]
	sla e
	ld d, b
	ld hl, SlimeEelRings
	add hl, de
	ld a, [hli]
	ld h, [hl]
;=@t2
	ld l, a
	pop de
;> DrawSlimeEelSegment(1, table, i)
	ld a, $01
	call DrawSlimeEelSegment
;>@i3 i = (SlimeEelWobble3[k] + wEntityPrivate2[slot]) & 0x1F
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, SlimeEelWobble3
	add hl, de
	ld a, [hl]
;=@i3
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
;> ring = wEntityPrivate3[slot] - 2
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
	dec e
;> if ring < 0: return
	ld a, e
	cp $f0
	jp nc, SlimeEelStopSegments

;>@t3 table = SlimeEelRings[ring]
	sla e
	ld d, b
	ld hl, SlimeEelRings
	add hl, de
	ld a, [hli]
	ld h, [hl]
;=@t3
	ld l, a
	pop de
;> DrawSlimeEelSegment(1, table, i)
	ld a, $01
	call DrawSlimeEelSegment
;>@i4 i = (SlimeEelWobble4[k] + wEntityPrivate2[slot]) & 0x1F
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, SlimeEelWobble4
	add hl, de
	ld a, [hl]
;=@i4
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
;>@r3 ring = wEntityPrivate3[slot] - 3
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
;=@r3
	dec e
	dec e
	dec e
;> if ring < 0: return
	ld a, e
	cp $f0
	jp nc, SlimeEelStopSegments

;>@t4 table = SlimeEelRings[ring]
	sla e
	ld d, b
	ld hl, SlimeEelRings
	add hl, de
	ld a, [hli]
	ld h, [hl]
;=@t4
	ld l, a
	pop de
;> DrawSlimeEelSegment(1, table, i)
	ld a, $01
	call DrawSlimeEelSegment
;> i = wEntityPrivate2[slot]                # the innermost segment does not wobble
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
;>@r4 ring = wEntityPrivate3[slot] - 4
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
;=@r4
	dec e
	dec e
	dec e
	dec e
;> if ring < 0: return
	ld a, e
	cp $f0
	jp nc, SlimeEelStopSegments

;>@t5 table = SlimeEelRings[ring]
	sla e
	ld d, b
	ld hl, SlimeEelRings
	add hl, de
	ld a, [hli]
	ld h, [hl]
;=@t5
	ld l, a
	pop de
;> DrawSlimeEelSegment(0, table, i)      # runs on into it
	ld a, $00

;@ def DrawSlimeEelSegment(slot: bc, frame: a, table: hl, i: de)
;@ path: boss/slime_eel
;@ Draws a tail segment (SlimeEelSegmentSprites frame) at angle i of the circle table around the
;@ middle ($50, $48). Link touching it (within 8 pixels, while walking normally) is bounced back,
;@ pushed away from the middle at speed $18.
DrawSlimeEelSegment::
;> hActiveEntitySpriteVariant = frame
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityDrawY = (0x48 + mem[table + i]) & 0xFF
	add hl, de
	ld a, $48
	add [hl]
	ldh [hActiveEntityDrawY], a
;>@x hActiveEntityX = (0x50 + mem[table + i + 8]) & 0xFF
	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a
;=@x
	ld a, $50
	add [hl]
	ldh [hActiveEntityX], a
;> DrawSlimeEelSegmentSprite()
	call DrawSlimeEelSegmentSprite
;> if (hLinkX - hActiveEntityX + 8) & 0xFF >= 0x10: return
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

;> if (hLinkY - hActiveEntityDrawY + 8) & 0xFF >= 0x10: return
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

;> if wLinkMotionState != 0: return
	ld a, [wLinkMotionState]
	and a
	jr nz, jr_005_71e9

;> BounceLinkBack()
	call BounceLinkBack
;> GetVectorTowardsLink(slot, 0x18)            # from the tail
	ld a, $18
	call GetVectorTowardsLink
;> hLinkSpeedY = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

;> return
jr_005_71e9:
	ret


;@ def SlimeEelStopSegments()
;@ path: boss/slime_eel
;@ End of SlimeEelSpinTail when the next segment would be inside ring 0: drops the angle it saved and
;@ returns.
SlimeEelStopSegments::
;> return
	pop de
	ret


;@ path: boss/slime_eel
;@ Slime Eel segment sprite pairs for DrawEntity16x16 (tile, attr for the left and right half), 5 frames:
;@ 0 $70, 1 $72, 2 $74 (the tail's segments, inner to outer), 3 $7C and 4 $7E (the pulsing weak spot
;@ of the body); each tile with its mirror.
SlimeEelSegmentSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $7c, $00, $7c, $20
	db $7e, $00, $7e, $20

;@ def DrawSlimeEelSegmentSprite(slot: bc)
;@ path: boss/slime_eel
;@ Draws a SlimeEelSegmentSprites frame at the active position.
DrawSlimeEelSegmentSprite::
;> DrawEntity16x16(slot, SlimeEelSegmentSprites)
	ld de, SlimeEelSegmentSprites
	call DrawEntity16x16
	ret


;@ def SlimeEelHead(slot: bc)
;@ path: boss/slime_eel
;@ Part 1, a head in one of the wall holes (wEntityDirection 0 top wall, 1 bottom wall;
;@ wEntityPrivate2/3 the hole's x and y): drawn with DrawSlimeEelHead, then its state.
SlimeEelHead::
;> DrawSlimeEelHead()
	call DrawSlimeEelHead
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> SlimeEelHeadStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/slime_eel
;@ A head's states, by wEntityState.
SlimeEelHeadStates::
	dw SlimeEelPeekState
	dw SlimeEelLungeState
	dw SlimeEelHookedState
	dw SlimeEelRetractState
	dw SlimeEelDefeatedState

;@ path: boss/slime_eel
;@ Head frames while it looks out of a top-wall hole (state 0), by (timer >> 3): $09, $0A, $0B, $0B,
;@ $0B, $0B - as the timer runs down it sinks back in.
SlimeEelPeekFramesTop::
	db $09, $0a, $0b, $0b, $0b, $0b

;@ path: boss/slime_eel
;@ The same for a bottom-wall hole: $0C, $0D, $0E, $0E, $0E, $0E.
SlimeEelPeekFramesBottom::
	db $0c, $0d, $0e, $0e, $0e, $0e

;@ def SlimeEelPeekState(slot: bc)
;@ path: boss/slime_eel
;@ State 0 (the heads of the opening holes): shows SlimeEelPeekFrames by its timer (wave sound $16 at
;@ $18) and goes when the timer runs out.
SlimeEelPeekState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return RemoveSlimeEelHead(slot)
	jp z, RemoveSlimeEelHead

;> if t == 0x18:
	ld e, a
	cp $18
	jr nz, jr_005_7235

;>     hWaveSfx = 0x16
	ld a, $16
	ldh [hWaveSfx], a

;>@s step = (t >> 3) & 7
jr_005_7235:
	ld a, e
	rra
	rra
	rra
;=@s
	and $07
	ld e, a
	ld d, b
;> wall = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
;> frames = SlimeEelPeekFramesTop
;> if wall != 0:
	and a
	ld hl, SlimeEelPeekFramesTop
	jr z, jr_005_724b

;>     frames = SlimeEelPeekFramesBottom
	ld hl, SlimeEelPeekFramesBottom

;> SetEntitySpriteVariant(slot, frames[step])
jr_005_724b:
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


;@ path: boss/slime_eel
;@ Head frames while it lunges out of a top-wall hole (state 1), by (timer >> 2), 24 steps: $09 x 4
;@ steps... read from the end as the timer runs down: $09 x 10, $0A x 2, $0B x 8 (fully out, it can
;@ be hooked), $0A x 2, $09 x 2.
SlimeEelLungeFramesTop::
	db $09, $09, $0a, $0a, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0a, $0a, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09

;@ path: boss/slime_eel
;@ The same for a bottom-wall hole, with frames $0C, $0D and $0E (fully out).
SlimeEelLungeFramesBottom::
	db $0c, $0c, $0d, $0d, $0e, $0e, $0e, $0e
	db $0e, $0e, $0e, $0e, $0d, $0d, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
;@ path: boss/slime_eel
;@ Y speed of the eel pulled out of its hole, by wall: top +$18 (down), bottom -$28 (up).
SlimeEelPullSpeedY::
	db $18, $d8

;@ path: boss/slime_eel
;@ Heading (0-15, see SlimeEelSpeeds) of the eel pulled out, by wall: top 4 (down), bottom $0C (up).
SlimeEelPullHeading::
	db $04, $0c

;@ def SlimeEelLungeState(slot: bc)
;@ path: boss/slime_eel
;@ State 1: lunges out of its hole and back (SlimeEelLungeFrames, wave sound $16 at timer $20) and
;@ goes when the timer runs out. While fully out it can be caught by the hookshot head (entity 3,
;@ x within 8 and y within 12) if Link faces up or down: it is hooked (state 2) and the tail turns the
;@ other way. From the 4th hook on, at random one time in two, it is pulled right out instead and
;@ becomes part 2 (SlimeEelLoose), moving away from the wall.
SlimeEelLungeState::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return RemoveSlimeEelHead(slot)
	jp z, RemoveSlimeEelHead

;> if t == 0x20:
	ld e, a
	cp $20
	jr nz, jr_005_7294

;>     hWaveSfx = 0x16
	ld a, $16
	ldh [hWaveSfx], a

;> step = (t >> 2) & 0x1F
jr_005_7294:
	ld a, e
	rra
	rra
	and $1f
	ld e, a
	ld d, b
;> wall = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
;> frames = SlimeEelLungeFramesTop
;> if wall != 0:
	and a
	ld hl, SlimeEelLungeFramesTop
	jr z, jr_005_72a9

;>     frames = SlimeEelLungeFramesBottom
	ld hl, SlimeEelLungeFramesBottom

;> f = frames[step]
jr_005_72a9:
	add hl, de
	ld a, [hl]
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
;> if f != 0x0B and f != 0x0E: return     # not fully out
	cp $0b
	jr z, jr_005_72b7

	cp $0e
	jp nz, Jump_005_7347

;> if hLinkDirection & 2 == 0: return     # Link faces left or right
jr_005_72b7:
	ldh a, [hLinkDirection]
	and $02
	jp z, Jump_005_7347

;> if wHookshotChainSlot == 0: return
	ld a, [wHookshotChainSlot]
	and a
	jp z, Jump_005_7347

;> hook = wHookshotChainSlot - 1
	dec a
;> wEntityWorkRAM3[2] = hook
	ld [wEntityWorkRAM3 + 2], a
	ld e, a
	ld d, b
;> if wEntityStatus[hook] == 0: return
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7347

;> if wEntityType[hook] != 3: return      # not the hookshot's head
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_005_7347

;> dx = (hActiveEntityX - wEntityX[hook] + 8) & 0xFF
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $08
;> if dx >= 0x10: return
	cp $10
	jr nc, jr_005_7347

;> dy = (hActiveEntityDrawY - wEntityY[hook] + 0x0C) & 0xFF
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
;> if dy >= 0x18: return
	cp $18
	jr nc, jr_005_7347

;> wEntityWorkRAM3[3] = (wEntityWorkRAM3[3] + 1) & 0xFF        # times hooked
	ld a, [wEntityWorkRAM3 + 3]
	inc a
	ld [wEntityWorkRAM3 + 3], a
;> if wEntityWorkRAM3[3] >= 4 and GetRandomByte() & 1 == 0:   # pulled out
	cp $04
	jr c, jr_005_7337

	call GetRandomByte
	and $01
	jr nz, jr_005_7337

;>     wEntityPrivate1[slot] = 2
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $02
;>     wEntityDropTimer[slot] = 0x30
	call GetEntityDropTimer
	ld [hl], $30
;>     wEntityTimer2[slot] = 0x20         # straight out of the hole first
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $20
;>     wall = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>     wEntitySpeedY[slot] = SlimeEelPullSpeedY[wall]
	ld hl, SlimeEelPullSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityState[slot] = SlimeEelPullHeading[wall]      # part 2 keeps its heading here
	ld hl, SlimeEelPullHeading
	add hl, de
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	ld [hl], a
;>     ClearSlimeEelTrailY()
	call ClearSlimeEelTrailY
;>     return
	ret


;> wEntityState[slot] += 1                # hooked
jr_005_7337:
	call IncrementEntityState
;> tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;> wEntityPrivate5[tail] = -wEntityPrivate5[tail] & 0xFF        # the tail turns the other way
	ld hl, wEntityPrivate5
	add hl, de
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

;> return
Jump_005_7347:
jr_005_7347:
	ret


;@ def SlimeEelHookedState(slot: bc)
;@ path: boss/slime_eel
;@ State 2: the head hangs on the hookshot and is pulled along (its y follows the hook head) with
;@ its body showing behind it (DrawSlimeEelBody); meanwhile the tail draws in (length - 1 every 4
;@ frames) and jingle $29 sounds every 8 frames. When the hook is gone or Link is hurt, it goes back
;@ into its hole ($5F frames, state 3).
SlimeEelHookedState::
;> DrawSlimeEelBody(slot)
	call DrawSlimeEelBody
;> wEntityWorkRAM3[0] = 1                 # a head is out
	ld a, $01
	ld [wEntityWorkRAM3], a
;> hook = wEntityWorkRAM3[2]
	ld a, [wEntityWorkRAM3 + 2]
	ld e, a
	ld d, b
;> if wEntityStatus[hook] != 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_739c

;>     if wInvincibilityCounter == 0:
	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_005_739c

;>         wEntityY[slot] = wEntityY[hook]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
;>         tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;>         if wEntityPrivate3[tail] != 0:
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	cp $00
	jr z, jr_005_7382

;>             if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_7382

;>                 wEntityPrivate3[tail] -= 1
	dec [hl]

;>         if hFrameCounter & 7 == 0:
jr_005_7382:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_738c

;>             hJingle = 0x29
	ld a, $29
	ldh [hJingle], a

;>         f = 0
;>         if wEntityDirection[slot] != 0:
jr_005_738c:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $00
	jr z, jr_005_7398

;>             f = 1
	ld a, $01

;>         SetEntitySpriteVariant(slot, f)
jr_005_7398:
	call SetEntitySpriteVariant
;>         return
	ret


;> wEntityState[slot] += 1                # let go
jr_005_739c:
	call IncrementEntityState
;> wEntityTimer[slot] = 0x5F
	call GetEntityTimer
	ld [hl], $5f
;> return
	ret


;@ path: boss/slime_eel
;@ Speed of a head going back into its hole (state 3), by (timer >> 2), 24 steps (read from the end
;@ as the timer runs down from $5F): 1 for most of the way, then 2, 3, 4, 8, $0C, $10, $10.
SlimeEelRetractSpeed::
	db $10, $10, $0c, $08, $04, $03, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01

;@ path: boss/slime_eel
;@ While a head goes back, the tail grows by 1 when (frame counter & mask) is 0, mask by
;@ (timer >> 2): $3F (every 64 frames) for most of the way, then $1F, $1F, 3.
SlimeEelRegrowMasks::
	db $03, $1f, $1f, $3f, $3f, $3f, $3f, $3f
	db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

;@ def SlimeEelRetractState(slot: bc)
;@ path: boss/slime_eel
;@ State 3: the head (frame 8 or $0F) moves back to its hole (SlimeEelRetractSpeed, aimed by putting
;@ the hole's position in hLinkX/Y for GetVectorTowardsLink) and goes once it is within 2 pixels of
;@ it vertically. The tail grows back meanwhile (up to 4, SlimeEelRegrowMasks).
SlimeEelRetractState::
;> DrawSlimeEelBody(slot)
	call DrawSlimeEelBody
;> wEntityWorkRAM3[0] = 1
	ld a, $01
	ld [wEntityWorkRAM3], a
;> f = 8
;> if wEntityDirection[slot] != 0:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $08
	jr z, jr_005_73e9

;>     f = 0x0F
	ld a, $0f

;> SetEntitySpriteVariant(slot, f)
jr_005_73e9:
	call SetEntitySpriteVariant
;> link_x = hLinkX
	ldh a, [hLinkX]
	push af
;> hLinkX = wEntityPrivate2[slot]         # the hole
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
;> link_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkY = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;>@s s = SlimeEelRetractSpeed[(GetEntityTimer(slot) >> 2) & 0x3F]
	call GetEntityTimer
	rra
	rra
	and $3f
	ld e, a
	ld d, b
;=@s
	ld hl, SlimeEelRetractSpeed
	add hl, de
	ld a, [hl]
;> GetVectorTowardsLink(slot, s)
	call GetVectorTowardsLink
;> wEntitySpeedX[slot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if (hLinkY - hActiveEntityDrawY + 3) & 0xFF < 6:    # back in the hole
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $03
	cp $06
	jr nc, jr_005_7431

;>     RemoveSlimeEelHead(slot)
	call RemoveSlimeEelHead

;> hLinkY = link_y
jr_005_7431:
	pop af
	ldh [hLinkY], a
;> hLinkX = link_x
	pop af
	ldh [hLinkX], a
;>@m m = SlimeEelRegrowMasks[(GetEntityTimer(slot) >> 2) & 0x3F]
	call GetEntityTimer
	rra
	rra
	and $3f
	ld e, a
	ld d, b
;=@m
	ld hl, SlimeEelRegrowMasks
	add hl, de
;> if hFrameCounter & m == 0:
	ldh a, [hFrameCounter]
	and [hl]
	jr nz, jr_005_7458

;>     tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;>     if wEntityPrivate3[tail] != 4:
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	cp $04
	jr z, jr_005_7458

;>         wEntityPrivate3[tail] += 1
	inc [hl]

;> return
jr_005_7458:
	ret


;@ def RemoveSlimeEelHead(slot: bc)
;@ path: boss/slime_eel
;@ A head (or the loose eel) leaves: no head is out any more (wEntityWorkRAM3[0] = 0) and the slot is
;@ freed.
RemoveSlimeEelHead::
;> wEntityWorkRAM3[0] = 0
	xor a
	ld [wEntityWorkRAM3], a
;> return ClearEntityStatus_05(slot)
	jp ClearEntityStatus_05


;@ def SlimeEelDefeatedState(slot: bc)
;@ path: boss/slime_eel
;@ State 4, set by the 8th hit on the weak spot: the hooked head flashes for $FF frames, with
;@ explosion puffs in the last $80; then the heart container appears where it is.
SlimeEelDefeatedState::
;> DrawSlimeEelBody(slot)
	call DrawSlimeEelBody
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 0: return SpawnHeartContainer_05(slot)
	jp z, SpawnHeartContainer_05

;> wEntityFlashTimer[slot] = t
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> if t < 0x80:
	cp $80
	jr nc, jr_005_7475

;>     BossExplosionPuffs_05(t)
	call BossExplosionPuffs_05

;> return
jr_005_7475:
	ret


;@ def BossExplosionPuffs_05(t: a)
;@ path: boss/common
;@ Every 8 frames (t & 7 = 0) an explosion puff at a random spot within 16 pixels of the active
;@ entity (this moves the active position for the frame).
BossExplosionPuffs_05::
;> if t & 7 != 0: return
	and $07
	jr nz, jr_005_7497

;>@x hActiveEntityX = (hActiveEntityX + (GetRandomByte() & 0x1F) - 0x10) & 0xFF
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
;=@x
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;>@y hActiveEntityDrawY = (hActiveEntityDrawY + (GetRandomByte() & 0x1F) - 0x10) & 0xFF
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
;=@y
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> BossExplosionPuff_05()
	call BossExplosionPuff_05

;> return
jr_005_7497:
	ret


;@ def BossExplosionPuff_05()
;@ path: boss/common
;@ An explosion puff (transient effect 2) at the active position, with noise $13; not while paused.
BossExplosionPuff_05::
;> if ReturnIfPaused_05(): return
	call ReturnIfPaused_05
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
;> return
	ret


;@ def SpawnHeartContainer_05(slot: bc)
;@ path: boss/common
;@ The heart container (entity $36) appears where the defeated boss is (SpawnEntity puts the
;@ spawner's position in hMultiPurpose0/1); the boss's slot is freed.
SpawnHeartContainer_05::
;> new = SpawnEntity(0x36)
	ld a, $36
	call SpawnEntity
;> return PlaceHeartContainer_05(slot, new)
	jr PlaceHeartContainer_05

;@ def SpawnEvilEagleHeartContainer_05(slot: bc)
;@ path: boss/evil_eagle
;@ The Evil Eagle's heart container, at a fixed place: x $48, y $10.
SpawnEvilEagleHeartContainer_05::
;> new = SpawnEntity(0x36)
	ld a, $36
	call SpawnEntity
;> hMultiPurpose0 = 0x48
	ld a, $48
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = 0x10
	ld a, $10
	ldh [hMultiPurpose1], a
;> PlaceHeartContainer_05(slot, new)      # runs on into it

;@ def PlaceHeartContainer_05(slot: bc, new: de)
;@ path: boss/common
;@ Puts the new heart container at hMultiPurpose0/1, hopping up (z 8, z speed $10); in a
;@ side-scrolling room the y speed -$10 is set on the boss's slot instead. Frees the boss's slot,
;@ noise $1A.
PlaceHeartContainer_05::
;> wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_005_74dc

;>     wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr jr_005_74e8

;> else:
;>     wEntitySpeedZ[new] = 0x10
jr_005_74dc:
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityZ[new] = 8
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08

;> ClearEntityStatus_05(slot)
jr_005_74e8:
	call ClearEntityStatus_05
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
;> return
	ret


;@ path: boss/slime_eel
;@ Frame of the loose eel's head (SlimeEelHeadSprites) by heading / 2 (heading 0-15: 0 right, 4 down,
;@ 8 left, $0C up): 3, 5, 0, 4, 2, 6, 1, 7.
SlimeEelHeadingFrames::
	db $03, $05, $00, $04, $02, $06, $01, $07

;@ def SlimeEelLoose(slot: bc)
;@ path: boss/slime_eel
;@ Part 2, the eel pulled out of its hole: it first moves straight out (while timer 2 runs), then
;@ wanders around (SlimeEelWander), its body following on its trail (128 entries in wEntityWorkRAM /
;@ wEntityWorkRAM2) while the tail draws in. When its drop timer is below $10 it flickers; at 0 it
;@ bursts (an exploding bomb, entity 2, where it is) and goes, and the tail grows back.
SlimeEelLoose::
;> DrawSlimeEelLoose(slot)
	call DrawSlimeEelLoose
;> LoadEntityPosition(slot)                            # active vars from the entity
	call LoadEntityPosition
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> wEntityWorkRAM3[0] = 1
	ld a, $01
	ld [wEntityWorkRAM3], a
;> d = GetEntityDropTimer(slot)
	call GetEntityDropTimer
;> if d < 0x10:
	cp $10
	jr nc, jr_005_7549

;>     if d == 0:
	and a
	jr nz, jr_005_7541

;>         tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;>         wEntityTimer1[tail] = 0x1F     # the tail grows back
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $1f
;>         new = SpawnEntity(2)           # a bomb, at the eel
	ld a, $02
	call SpawnEntity
;>         PlayClinkNoise()
	call PlayClinkNoise
;>         wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityTimer[new] = 0x17       # bursts at once
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
;>         wEntityPrivate4[new] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;>         return RemoveSlimeEelHead(slot)
	jp RemoveSlimeEelHead


;>     wEntityFlashTimer[slot] = hFrameCounter
jr_005_7541:
	ldh a, [hFrameCounter]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;>     return
	ret


;> if hFrameCounter & 7 == 0:
jr_005_7549:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_755d

;>     tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;>     if wEntityPrivate3[tail] != 0:
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_755d

;>         wEntityPrivate3[tail] -= 1     # the tail draws in
	dec [hl]

;> n = (wEntityPrivateCounter[slot] + 1) & 0x7F
jr_005_755d:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $7f
;> wEntityPrivateCounter[slot] = n
	ld [hl], a
	ld e, a
	ld d, b
;> wEntityWorkRAM[n] = hActiveEntityX
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
;> wEntityWorkRAM2[n] = hActiveEntityDrawY
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
;> if wEntityTimer2[slot] != 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7583

;>     UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
	jr jr_005_7586

;> else:
;>     SlimeEelWander(slot)
jr_005_7583:
	call SlimeEelWander

;>@f f = SlimeEelHeadingFrames[wEntityState[slot] >> 1]
jr_005_7586:
	ld hl, wEntityState
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
;=@f
	ld hl, SlimeEelHeadingFrames
	add hl, de
	ld a, [hl]
;> SetEntitySpriteVariant(slot, f)
	call SetEntitySpriteVariant
	ret


;@ def DrawSlimeEelLoose(slot: bc)
;@ path: boss/slime_eel
;@ Draws the loose eel: the head (8 sprites, SlimeEelHeadSprites) and 3 body segments where it was
;@ $0C, $18 and $24 frames ago on its trail (SlimeEelSegmentSprites frames 0, 0 and 2).
DrawSlimeEelLoose::
;>@e e = (hActiveEntitySpriteVariant << 5) & 0xE0
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
;=@e
	rla
	rla
	and $e0
;> DrawEntitySprites(8, SlimeEelHeadSprites + e)
	ld e, a
	ld d, b
	ld hl, SlimeEelHeadSprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
;> n = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> i = (n - 0x0C) & 0x7F
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
;> DrawEntity16x16(slot, SlimeEelSegmentSprites)
	ld de, SlimeEelSegmentSprites
	call DrawEntity16x16
;> i = (n - 0x18) & 0x7F
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
;> DrawEntity16x16(slot, SlimeEelSegmentSprites)
	ld de, SlimeEelSegmentSprites
	call DrawEntity16x16
;> i = (n - 0x24) & 0x7F
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
;> hActiveEntitySpriteVariant = 2
	ld a, $02
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(slot, SlimeEelSegmentSprites)
	ld de, SlimeEelSegmentSprites
	call DrawEntity16x16
	ret


;@ path: boss/slime_eel
;@ Speeds of the loose eel by heading h (0-15: 0 right, 4 down, 8 left, $0C up): y speed [h], x speed
;@ [h + 4]; a circle of radius $10 (20 bytes).
SlimeEelSpeeds::
	db $00, $06, $0c, $0e, $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e

;@ def SlimeEelWander(slot: bc)
;@ path: boss/slime_eel
;@ The loose eel crawls about: it hurts Link on contact and turns around at walls (and may change its
;@ turning direction); every 4 frames its heading (wEntityState) turns by wEntityPrivate2 (+1 or -1,
;@ chosen anew every $10-$2F frames) and its speed follows (SlimeEelSpeeds).
SlimeEelWander::
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckContactDamage(slot)
	call EntityCheckContactDamage
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> if wEntityCollisions[slot] != 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_765a

;>     if GetRandomByte() & 1 == 0:
	call GetRandomByte
	rra
	jr c, jr_005_764b

;>         wEntityPrivate2[slot] = -wEntityPrivate2[slot] & 0xFF
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

;>     wEntityState[slot] = (wEntityState[slot] + 8) & 0x0F     # turn around
jr_005_764b:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	add $08
	and $0f
	ld [hl], a
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10

;> if GetEntityTimer1(slot) == 0:
jr_005_765a:
	call GetEntityTimer1
	jr nz, jr_005_7688

;>     wEntityTimer1[slot] = 4
	ld [hl], $04
;>@h     wEntityState[slot] = (wEntityState[slot] + wEntityPrivate2[slot]) & 0x0F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
;=@h
	and $0f
	ld [hl], a
;>     h = wEntityState[slot]
	ld hl, wEntityState
	add hl, bc
	ld e, [hl]
	ld d, b
;>     wEntitySpeedY[slot] = SlimeEelSpeeds[h]
	ld hl, SlimeEelSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntitySpeedX[slot] = SlimeEelSpeeds[h + 4]
	ld hl, SlimeEelSpeeds + 4
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

;> if GetEntityTimer(slot) == 0:
jr_005_7688:
	call GetEntityTimer
	jr nz, jr_005_76a0

;>     wEntityTimer[slot] = 0x10 + (GetRandomByte() & 0x1F)
	call GetRandomByte
	and $1f
	add $10
	ld [hl], a
;>     wEntityPrivate2[slot] = ((GetRandomByte() & 2) - 1) & 0xFF   # +1 or -1
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

;> return
jr_005_76a0:
	ret


;@ def ClearSlimeEelTrailY()
;@ path: boss/slime_eel
;@ Clears the 128 y entries of the loose eel's trail (wEntityWorkRAM2).
ClearSlimeEelTrailY::
;> for i in range(0x80): wEntityWorkRAM2[i] = 0
	ld e, $80
	ld hl, wEntityWorkRAM2

jr_005_76a6:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_005_76a6

;> return
	ret


;@ path: boss/slime_eel
;@ The Slime Eel's head, 16 DrawEntitySprites lists of 8 sprites (dy, dx, tile, attr; a 32x32 head of tiles
;@ $60-$6E, $76-$7A): frames 0-7 the loose eel by heading (see SlimeEelHeadingFrames: 0 down, 1 up,
;@ 2 left, 3 right, 4-7 the diagonals); 8 and $0F the head with open mouth at a top / bottom wall
;@ hole (hooked or going back); 9-$0B looking out of a top-wall hole and $0C-$0E out of a bottom-wall
;@ hole (only the tip, half the head, the open mouth; unused entries repeat a sprite).
SlimeEelHeadSprites::
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6c, $00, $08, $00, $6e, $00, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6e, $20, $08, $10, $6c, $20
	db $f8, $f8, $6c, $40, $f8, $00, $6e, $40, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6e, $60, $f8, $10, $6c, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $78, $00, $08, $00, $7a, $00, $08, $08, $7a, $20, $08, $10, $78, $20
	db $08, $00, $76, $00, $08, $08, $76, $20, $08, $08, $76, $20, $08, $08, $76, $20
	db $08, $08, $76, $20, $08, $08, $76, $20, $08, $08, $76, $20, $08, $08, $76, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $08, $f8, $78, $00, $08, $00, $7a, $00, $08, $08, $7a, $20, $08, $10, $78, $20
	db $08, $f8, $78, $00, $08, $00, $7a, $00, $08, $08, $7a, $20, $08, $10, $78, $20
	db $f8, $00, $76, $40, $f8, $08, $76, $60, $f8, $08, $76, $60, $f8, $08, $76, $60
	db $f8, $08, $76, $60, $f8, $08, $76, $60, $f8, $08, $76, $60, $f8, $08, $76, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $f8, $f8, $78, $40, $f8, $00, $7a, $40, $f8, $08, $7a, $60, $f8, $10, $78, $60
	db $f8, $f8, $78, $40, $f8, $00, $7a, $40, $f8, $08, $7a, $60, $f8, $10, $78, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $78, $40, $f8, $00, $7a, $40, $f8, $08, $7a, $60, $f8, $10, $78, $60

;@ def DrawSlimeEelHead()
;@ path: boss/slime_eel
;@ Draws the head's frame from SlimeEelHeadSprites (8 sprites; the offset frame * 32 needs 16 bits).
DrawSlimeEelHead::
;>@e e = hActiveEntitySpriteVariant * 32
	ldh a, [hActiveEntitySpriteVariant]
	ld d, b
	rla
	rl d
	rla
	rl d
;=@e
	rla
	rl d
	rla
	rl d
;=@e
	rla
	rl d
	and $e0
	ld e, a
;> DrawEntitySprites(8, SlimeEelHeadSprites + e)
	ld hl, SlimeEelHeadSprites
	add hl, de
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar
	ret


;@ path: boss/slime_eel
;@ Y step from one body segment to the next behind a head, by wall: top -14 (up into the wall),
;@ bottom +14.
SlimeEelBodyStepY::
	db $f2, $0e

;@ def DrawSlimeEelBody(slot: bc)
;@ path: boss/slime_eel
;@ Draws the body behind a head that is out (states 2-4): segments every 14 pixels towards its wall
;@ until the wall ($14 <= y < $7C). The first one is the weak spot, pulsing between frames 3 and 4:
;@ it takes weapon hits (before state 4) and the 8th hit (wEntityWorkRAM3[4]) beats the eel - the
;@ tail goes, this head is in state 4 for $FF frames, the music changes (track $5E) and dialog $B5
;@ opens. The segments hurt Link on contact. Then hits on the head itself are checked with option
;@ flags $C0 (bit 6 added), unless it is flashing.
DrawSlimeEelBody::
;> v = 3
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	ld a, $03
	jr z, jr_005_78db

;>     v = 4
	inc a

;> hActiveEntitySpriteVariant = v
jr_005_78db:
	ldh [hActiveEntitySpriteVariant], a
	nop

;> while True:
;>@s     hActiveEntityDrawY = (hActiveEntityDrawY + SlimeEelBodyStepY[wEntityDirection[slot]]) & 0xFF
jr_005_78de:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, SlimeEelBodyStepY
	add hl, de
;=@s
	ld a, [hl]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;>     if not 0x14 <= hActiveEntityDrawY < 0x7C: break
	cp $14
	jr c, jr_005_794a

	cp $7c
	jr nc, jr_005_794a

;>     DrawEntity16x16(slot, SlimeEelSegmentSprites)
	ld de, SlimeEelSegmentSprites
	call DrawEntity16x16
;>     if hActiveEntityState < 4:
	ldh a, [hActiveEntityState]
	cp $04
	jr nc, jr_005_7948

;>         if hActiveEntitySpriteVariant != 0:        # the first segment, the weak spot
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, jr_005_7945

;>             hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>             EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;>             if wEntityFlashTimer[slot] == 0x16:    # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, jr_005_7945

;>                 wEntityWorkRAM3[4] = (wEntityWorkRAM3[4] + 1) & 0xFF
	ld hl, wEntityWorkRAM3 + 4
	inc [hl]
;>                 if wEntityWorkRAM3[4] == 8:
	ld a, [hl]
	cp $08
	jr nz, jr_005_7945

;>                     tail = wEntityWorkRAM3[1]
	ld a, [wEntityWorkRAM3 + 1]
	ld e, a
	ld d, b
;>                     wEntityStatus[tail] = 0
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b
;>                     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>                     wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;>                     ResetSoundEngine()
	call ResetSoundEngine
;>                     wDelayedWaveSfxTimer = 3
	ld a, $03
	ld [wDelayedWaveSfxTimer], a
;>                     wMusicTrackToPlay = 0x5E
	ld a, $5e
	ld [wMusicTrackToPlay], a
;>                     OpenDialog(0xB5)
	ld a, $b5
	call OpenDialog

;>         EntityCheckContactDamage(slot)
jr_005_7945:
	call EntityCheckContactDamage

;>     # next segment
jr_005_7948:
	jr jr_005_78de

;> LoadEntityPosition(slot)                            # active vars from the entity
jr_005_794a:
	call LoadEntityPosition
;> if wEntityFlashTimer[slot] == 0:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_7964

;>     wEntityOptions1[slot] = 0xC0
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $c0
;>     EntityCheckWeaponHits(slot)
	call EntityCheckWeaponHits
;>     wEntityOptions1[slot] = 0x80
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $80

;> return
jr_005_7964:
	ret


;@ def ReturnIfNonInteractive_05()
;@ path: entity/helpers
;@ Called at the start of an entity's update: unless the entity is active (status 5) and the game is
;@ running normally (see ReturnIfPaused_05), it drops its caller's return address, so the handler
;@ ends for this frame.
;@ test: skip returns from its caller (pops the return address)
ReturnIfNonInteractive_05::
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return_from_caller()               # pops the caller's return address
	jr nz, ReturnIfPaused_05.exitCaller
;> ReturnIfPaused_05()                    # runs on into it

;@ def ReturnIfPaused_05()
;@ path: entity/helpers
;@ Ends the calling handler for this frame (drops its return address) while the map screen is up
;@ (game mode 7), a dialogue box is open, Link shows an item, the inventory is sliding in or out,
;@ or the room is scrolling to the next one.
;@ test: skip returns from its caller (pops the return address)
ReturnIfPaused_05::
;> if wGameplayType == 7:
	ld a, [wGameplayType]
	cp $07
;>@exit     return_from_caller()
	jr z, .exitCaller
;> if wDialogState or wLinkShowItemPoseActive or wInventoryAppearing:
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


;@ def ApplyRecoilIfNeeded_05(slot: bc)
;@ path: entity/helpers
;@ While the entity's ignore-hits timer runs after a hit, moves it one step with its knockback speed
;@ instead of its own speed (stopping at walls unless option bit 5 is set) and ends the calling
;@ handler for this frame. Not called from this bank.
;@ test: skip returns from its caller (pops the return address)
ApplyRecoilIfNeeded_05::
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
;> AddPowerHitTrailVfx()
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
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore
;>     EntityCheckWalls(slot)                 # stop at walls
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
;> return_from_caller()                   # pops the caller's return address
	pop af
.done
	ret

;@ def UpdateEntityPosWithSpeed_05(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its x and y speeds (AddEntitySpeedToPosX_05, then AddEntitySpeedToPosY_05).
UpdateEntityPosWithSpeed_05::
;> AddEntitySpeedToPosX_05(slot)
	call AddEntitySpeedToPosX_05
;> AddEntitySpeedToPosY_05(slot)         # runs on into it

;@ def AddEntitySpeedToPosY_05(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its y speed: the y arrays lie $10 bytes after the x arrays, so this runs
;@ AddEntitySpeedToPosX_05 with slot + $10.
AddEntitySpeedToPosY_05::
;> AddEntitySpeedToPosX_05(slot + 0x10)
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPosX_05
	pop bc
;> return
	ret


;@ def AddEntitySpeedToPosX_05(slot: bc)
;@ path: entity/helpers
;@ Moves the entity by its x speed, a signed value in 1/16 pixel: the low 4 bits go into the fraction
;@ (wEntitySpeedXAcc, high nibble), the high 4 bits (sign-extended) plus the fraction's carry into
;@ wEntityX.
AddEntitySpeedToPosX_05::
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

.addWhole
;>@w whole = (speed >> 4) | (0xF0 if speed & 0x80 else 0)
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive

	ld e, $f0

.positive
;=@w
	swap a
	and $0f
	or e
;> wEntityX[slot] = (wEntityX[slot] + whole + (acc >> 8)) & 0xFF
	rr d
	adc [hl]
	ld [hl], a

.done
;> return
	ret


;@ def AddEntityZSpeedToPos_05(slot: bc)
;@ path: entity/helpers
;@ Moves the entity's height by its z speed, the same way AddEntitySpeedToPosX_05 does for x (it
;@ ends in that routine's code).
;@ test: skip shares its second half with AddEntitySpeedToPosX_05
AddEntityZSpeedToPos_05::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0: return
	and a
	jr z, AddEntitySpeedToPosX_05.done

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
;> whole = (speed >> 4) | (0xF0 if speed & 0x80 else 0)     # (in AddEntitySpeedToPosX_05's code)
;> wEntityZ[slot] = (wEntityZ[slot] + whole + (acc >> 8)) & 0xFF
	ld hl, wEntityZ
	jr AddEntitySpeedToPosX_05.addWhole

;@ def EntityLinkDiffX_05(slot: bc) -> (d, e)
;@ path: entity/helpers
;@ d = Link's x minus the entity's x (signed); e = the direction towards Link along x (0 right,
;@ 1 left).
EntityLinkDiffX_05::
;> e = 0
	ld e, $00
;> d = (hLinkX - wEntityX[slot]) & 0xFF
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if d & 0x80:
	bit 7, a
	jr z, jr_005_7a32

;>     e = 1
	inc e

;> return d, e
jr_005_7a32:
	ld d, a
	ret


;@ def EntityLinkDiffY_05(slot: bc) -> (d, e)
;@ path: entity/helpers
;@ d = Link's y minus the entity's y (signed); e = the direction towards Link along y (2 up,
;@ 3 down).
EntityLinkDiffY_05::
;> e = 2
	ld e, $02
;> d = (hLinkY - wEntityY[slot]) & 0xFF
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if d & 0x80 == 0:
	bit 7, a
	jr nz, jr_005_7a42

;>     e = 3
	inc e

;> return d, e
jr_005_7a42:
	ld d, a
	ret


;@ def GetEntityDirectionToLink_05(slot: bc) -> e
;@ path: entity/helpers
;@ The direction from the entity towards Link along the axis where he is farther away (0 right,
;@ 1 left, 2 up, 3 down; y when the distances are equal). Also returned in a.
GetEntityDirectionToLink_05::
;> dx, ex = EntityLinkDiffX_05(slot)
	call EntityLinkDiffX_05
;> hMultiPurpose0 = ex
	ld a, e
	ldh [hMultiPurpose0], a
;> adx = abs(dx)
	ld a, d
	bit 7, a
	jr z, jr_005_7a51

	cpl
	inc a

jr_005_7a51:
;> dy, ey = EntityLinkDiffY_05(slot)
	push af
	call EntityLinkDiffY_05
;> hMultiPurpose1 = ey
	ld a, e
	ldh [hMultiPurpose1], a
;> ady = abs(dy)
	ld a, d
	bit 7, a
	jr z, jr_005_7a5f

	cpl
	inc a

;> if ady < adx:
jr_005_7a5f:
	pop de
	cp d
	jr nc, jr_005_7a67

;>     e = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	jr jr_005_7a69

;> else:
;>     e = hMultiPurpose1
jr_005_7a67:
	ldh a, [hMultiPurpose1]

;> return e
jr_005_7a69:
	ld e, a
	ret


;@ def ClearEntityStatus_05(slot: bc)
;@ path: entity/helpers
;@ Frees the entity's slot (status 0).
ClearEntityStatus_05::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;> return
	ret


;@ path: boss/gohma
;@ Gohma's walking x speed by wEntityPrivate1: 0 right +$10, 1 left -$10.
GohmaWalkSpeedX::
	db $10, $f0

;@ path: boss/gohma
;@ Gohma's dash speed by the side Link is on (EntityLinkDiffX_05): 0 right +$18, 1 left -$18.
GohmaDashSpeedX::
	db $18, $e8

;@ path: boss/gohma
;@ Gohma, 48x16: 6 DrawEntitySprites lists of 6 sprites (dy, dx, tile, attr; dx -$10 to +$18): a claw on
;@ each side and the eye in the middle. Frames 0-2 walk with the eye shut (tile $60), 3-5 the same
;@ claw poses with the eye open ($62). Claws: frame 0/3 $64, $66 (right claw $6A, $68 mirrored),
;@ 1/4 $6C, $6E (mirrored), 2/5 $68, $6A (right $66, $64 mirrored).
GohmaSprites::
	db $00, $f0, $64, $00, $00, $f8, $66, $00, $00, $00, $60, $00
	db $00, $08, $60, $20, $00, $10, $6a, $20, $00, $18, $68, $20, $00, $f0, $6c, $00
	db $00, $f8, $6e, $00, $00, $00, $60, $00, $00, $08, $60, $20, $00, $10, $6e, $20
	db $00, $18, $6c, $20, $00, $f0, $68, $00, $00, $f8, $6a, $00, $00, $00, $60, $00
	db $00, $08, $60, $20, $00, $10, $66, $20, $00, $18, $64, $20, $00, $f0, $64, $00
	db $00, $f8, $66, $00, $00, $00, $62, $00, $00, $08, $62, $20, $00, $10, $6a, $20
	db $00, $18, $68, $20, $00, $f0, $6c, $00, $00, $f8, $6e, $00, $00, $00, $62, $00
	db $00, $08, $62, $20, $00, $10, $6e, $20, $00, $18, $6c, $20, $00, $f0, $68, $00
	db $00, $f8, $6a, $00, $00, $00, $62, $00, $00, $08, $62, $20, $00, $10, $66, $20
	db $00, $18, $64, $20

;@ def GohmaEntityHandler(slot: bc)
;@ path: boss/gohma
;@ Entity $5E, Gohma: a one-eyed crab, 48 pixels wide, that walks from side to side, dashes along
;@ the row towards Link, lunges down at him, or stops and opens its eye to shoot (entity $7D). Its
;@ hitbox flags are 0 while the eye is open and $80 after it shuts. While the ocarina's song state
;@ is 1 it is made to open its eye.
;@ Once beaten (status no longer 5) it runs the shared defeat steps (BossDefeatedHandler_05).
GohmaEntityHandler::
;> if wOcarinaSongState == 1:
	ld a, [wOcarinaSongState]
	cp $01
	jr nz, jr_005_7b16

;>     GohmaOpenEye(slot)
	call GohmaOpenEye
;>     hActiveEntityState = wEntityState[slot]
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a

;>@o e = 24 * hActiveEntitySpriteVariant
jr_005_7b16:
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld c, a
;=@o
	rla
	and $f0
	add c
	ld e, a
	ld d, b
;> DrawEntitySprites(6, GohmaSprites + e)
	ld hl, GohmaSprites
	add hl, de
	ld c, $06
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)
	ld a, $06
	call ReserveOAMEntriesFar
;> if hActiveEntityStatus != 5: return BossDefeatedHandler_05(slot)
	ldh a, [hActiveEntityStatus]
	cp $05
	jp nz, BossDefeatedHandler_05

;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> StartBossMusic()                            # starts the boss music
	call StartBossMusic
;> EntityCheckHits(slot)
	call EntityCheckHits
;> UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;> EntityCheckWalls(slot)
	call EntityCheckWalls
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> GohmaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/gohma
;@ Gohma's states, by wEntityState.
GohmaStates::
	dw GohmaStartState
	dw GohmaWalkState
	dw GohmaLungeState
	dw GohmaEyeState

;@ def GohmaStartState(slot: bc)
;@ path: boss/gohma
;@ State 0: starts walking to a random side (state 1).
GohmaStartState::
;> wEntityPrivate1[slot] = GetRandomByte() & 1
	call GetRandomByte
	and $01
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;>@gs wEntitySpeedX[slot] = GohmaWalkSpeedX[wEntityPrivate1[slot]]
	ld e, a
	ld d, b
	ld hl, GohmaWalkSpeedX
	add hl, de
	ld a, [hl]
;=@gs
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> return
	ret


;@ def GohmaWalkState(slot: bc)
;@ path: boss/gohma
;@ State 1: waits while timer 2 runs (after an attack). While dashing (timer 1) it goes on with
;@ GohmaWalkOn. Its timer counts a shuffle (x speed +8 or -8 every 4 frames); at 1 it dashes along
;@ the row towards Link (speed $18 for $60-$9F frames). At 0, if Link is more than 8 and less than
;@ $28 pixels below, and its attack cooldown (wEntityDyingTimer, set to $40-$BF) is over, it attacks:
;@ one time in 4 a lunge (GohmaStartLunge), one in 4 the eye (GohmaOpenEye); otherwise it shuffles
;@ for $60 more frames.
GohmaWalkState::
;> if wEntityTimer2[slot] != 0: return
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	ret nz

;> if GetEntityTimer1(slot) != 0: return GohmaWalkOn(slot)      # dashing
	call GetEntityTimer1
	jp nz, GohmaWalkOn

;> t = GetEntityTimer(slot)
;>@z if t == 0:
;>@z     if (wEntityY[slot] + 8) & 0xFF < hLinkY: return GohmaChooseAttack(slot)
;>@z     wEntityTimer[slot] = 0x60
	call GetEntityTimer
	jr z, jr_005_7ba9

;> elif t == 1:
	cp $01
	jr nz, jr_005_7bbc

;>     dx, side = EntityLinkDiffX_05(slot)
	call EntityLinkDiffX_05
	ld d, b
;>     wEntitySpeedX[slot] = GohmaDashSpeedX[side]
	ld hl, GohmaDashSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;>     wEntityTimer1[slot] = 0x60 + (GetRandomByte() & 0x3F)
	call GetEntityTimer1
	call GetRandomByte
	and $3f
	add $60
	ld [hl], a
;>     return GohmaWalkOn(slot)
	jp GohmaWalkOn


jr_005_7ba9:
;=@z
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, hLinkY
	cp [hl]
;=@z
	jp c, GohmaChooseAttack

	call GetEntityTimer
	ld [hl], $60

;> wEntitySpeedY[slot] = 0                # shuffle (t is 0 here or above 1)
jr_005_7bbc:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;> if t & 4 == 0:
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, jr_005_7bce

;>     wEntitySpeedX[slot] = 8
	ld [hl], $08
;>     return GohmaAnimateFast(slot)
	jp GohmaAnimateFast


;> wEntitySpeedX[slot] = 0xF8
jr_005_7bce:
	ld [hl], $f8
;> return GohmaAnimateFast(slot)
	jp GohmaAnimateFast


GohmaChooseAttack:
;> # Link is below it
;> if (hLinkY - wEntityY[slot]) & 0xFF >= 0x28: return GohmaWalkOn(slot)
	ld hl, wEntityY
	add hl, bc
	ldh a, [hLinkY]
	sub [hl]
	cp $28
	jr nc, GohmaWalkOn

;> if wEntityDyingTimer[slot] != 0: return GohmaWalkOn(slot)      # attack cooldown
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, GohmaWalkOn

;> wEntityDyingTimer[slot] = 0x40 + (GetRandomByte() & 0x7F)
	call GetRandomByte
	and $7f
	add $40
	ld [hl], a
;> r = wEntityDyingTimer[slot] & 3
	and $03
;> if r == 0: return GohmaStartLunge(slot)
	jr z, GohmaStartLunge

;> if r != 1: return GohmaWalkOn(slot)
	dec a
	jr nz, GohmaWalkOn

;> GohmaOpenEye(slot)                     # runs on into it

;@ def GohmaOpenEye(slot: bc)
;@ path: boss/gohma
;@ Gohma stops and opens its eye: state 3, frame 1, $40 frames before it shoots.
GohmaOpenEye::
;> wEntityState[slot] = 3
	call IncrementEntityState
	ld [hl], $03
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> wEntityTimer2[slot] = 0x40
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $40
;> GohmaShowFrame(1)
	ld a, $01
	call GohmaShowFrame
;> return
	ret


;@ def GohmaWalkOn(slot: bc)
;@ path: boss/gohma
;@ Walking and dashing: at a side wall a dash bounces back (x speed ^ $F0) and a walk turns round;
;@ when not dashing the walking speed is set (GohmaWalkSpeedX). The claws move every 16 frames
;@ (every 8 while dashing or shuffling): frames 0, 1, 2.
GohmaWalkOn::
;> if wEntityCollisions[slot] & 3:        # a side wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_005_7c2a

;>     if GetEntityTimer1(slot) != 0:         # dashing: bounce back
	call GetEntityTimer1
	jr z, jr_005_7c22

;>         wEntitySpeedX[slot] ^= 0xF0
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
;>         return GohmaAnimateFast(slot)
	jp GohmaAnimateFast


;>     wEntityPrivate1[slot] ^= 1         # walk the other way
jr_005_7c22:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

;> if GetEntityTimer1(slot) != 0: return GohmaAnimateFast(slot)
jr_005_7c2a:
	call GetEntityTimer1
	jr nz, GohmaAnimateFast

;>@sx wEntitySpeedX[slot] = GohmaWalkSpeedX[wEntityPrivate1[slot]]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
;=@sx
	ld hl, GohmaWalkSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> return GohmaAnimateSlow(slot)
	jr GohmaAnimateSlow

GohmaStartLunge:
;> # the lunge (GohmaChooseAttack)
;> wEntityTimer[slot] = 0x60
	call GetEntityTimer
	ld [hl], $60
;> wEntityTimer1[slot] = 0
	call GetEntityTimer1
	ld [hl], b
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> wEntityPrivate1[slot] = 0              # going down
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;> wEntityPrivate3[slot] = wEntityY[slot]  # its row, to come back to
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a
;> return GohmaAnimateSlow(slot)
	jr GohmaAnimateSlow

GohmaAnimateFast:
;> if hFrameCounter & 7 == 0: return GohmaAnimateStep(slot)
	ldh a, [hFrameCounter]
	and $07
	jr z, GohmaAnimateStep

;> return GohmaShowStep(slot)
	jr GohmaShowStep

GohmaAnimateSlow:
;> if hFrameCounter & 0x0F != 0: return GohmaShowStep(slot)
	ldh a, [hFrameCounter]
	and $0f
	jr nz, GohmaShowStep

GohmaAnimateStep:
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] == 3:
	ld a, [hl]
	cp $03
	jr nz, GohmaShowStep

;>     wEntityPrivateCounter[slot] = 0
	ld [hl], $00

GohmaShowStep:
;> GohmaShowFrame(wEntityPrivateCounter[slot])      # runs on into it
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]

;@ def GohmaShowFrame(slot: bc, f: a)
;@ path: boss/gohma
;@ Sets Gohma's frame.
GohmaShowFrame::
;> return SetEntitySpriteVariant(slot, f)
	jp SetEntitySpriteVariant


;@ def GohmaLungeState(slot: bc)
;@ path: boss/gohma
;@ State 2, the lunge: it shuffles while the timer is above 1; at 1 it aims at Link's row (straight
;@ down or towards Link at speed $10, at random) and stops (state 1) if it is not above Link; at 0
;@ it goes on until 8 pixels above that row, then turns back up (y speed -$10, wave sound $16) to
;@ its own row (wEntityPrivate3) and walks on (state 1). The claws move every 16 frames.
GohmaLungeState::
;> if wEntityPrivate1[slot] != 0:         # coming back up
;>@b     if wEntityPrivate3[slot] < wEntityY[slot]: return GohmaAnimateLunge(slot)
;>@b     return GohmaEndLunge(slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_005_7cfd

;> t = GetEntityTimer(slot)
;> if t >= 2:
;>@s     wEntitySpeedX[slot] = 8 if t & 4 == 0 else 0xF8     # shuffle
;>@s     return GohmaAnimateLunge(slot)
	call GetEntityTimer
	cp $02
	jr nc, jr_005_7ced

;> elif t == 0:
;>@d     if (wEntityPrivate5[slot] - 8) & 0xFF >= wEntityY[slot]: return GohmaAnimateLunge(slot)
;>@d     wEntityPrivate1[slot] += 1         # back up
;>@d     ClearEntitySpeed(slot)
;>@d     wEntitySpeedY[slot] = 0xF0
;>@d     hWaveSfx = 0x16
;>@d     return GohmaAnimateLunge(slot)
	cp $00
	jr z, jr_005_7cc9

;> else:                                   # t == 1
;>     wEntityPrivate5[slot] = hLinkY       # the row to reach
	ld hl, hLinkY
	ld a, [hl]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
;>     if GetRandomByte() & 2:
	call GetRandomByte
	and $02
	jr z, jr_005_7cb3

;>         ClearEntitySpeed(slot)
	call ClearEntitySpeed
;>         wEntitySpeedY[slot] = 0x10     # straight down
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
	jp Jump_005_7cb8


;>     else:
;>         SetEntitySpeedTowardsLink(slot, 0x10)
jr_005_7cb3:
	ld a, $10
	call SetEntitySpeedTowardsLink

;>     if (wEntityY[slot] + 8) & 0xFF >= hLinkY: return GohmaEndLunge(slot)
Jump_005_7cb8:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, hLinkY
	cp [hl]
;>     # (continued)
	jp nc, GohmaEndLunge

;>     return GohmaAnimateLunge(slot)
	jp GohmaAnimateLunge


jr_005_7cc9:
;=@d
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	sub $08
	ld hl, wEntityY
	add hl, bc
;=@d
	cp [hl]
	jp nc, GohmaAnimateLunge

	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
;=@d
	call ClearEntitySpeed
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
;=@d
	ld a, $16
	ldh [hWaveSfx], a
	jp GohmaAnimateLunge


jr_005_7ced:
;=@s
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, jr_005_7cf9

	ld [hl], $08
	jr GohmaAnimateLunge

jr_005_7cf9:
;=@s
	ld [hl], $f8
	jr GohmaAnimateLunge

Jump_005_7cfd:
;=@b
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
;=@b
	cp [hl]
	jr c, GohmaAnimateLunge

;@ def GohmaEndLunge(slot: bc)
;@ path: boss/gohma
;@ End of the lunge: stops and walks on (state 1), then GohmaAnimateLunge.
GohmaEndLunge::
;> ClearEntitySpeed(slot)
	call ClearEntitySpeed
;> wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;> GohmaAnimateLunge(slot)                # runs on into it

;@ def GohmaAnimateLunge(slot: bc)
;@ path: boss/gohma
;@ Moves the claws every 16 frames (frames 0, 1, 2) and shows the frame.
GohmaAnimateLunge::
;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_005_7d23

;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>     if wEntityPrivateCounter[slot] == 3:
	ld a, [hl]
	cp $03
	jr nz, jr_005_7d23

;>         wEntityPrivateCounter[slot] = 0
	ld [hl], $00

;> return SetEntitySpriteVariant(slot, wEntityPrivateCounter[slot])
jr_005_7d23:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	jp SetEntitySpriteVariant


;@ def GohmaEyeState(slot: bc)
;@ path: boss/gohma
;@ State 3: after timer 2 ($40 frames, eye opening) the eye stays open for $30 frames (timer 1;
;@ frame 4, hitbox flags 0) and at $18 it shoots: entity $7D from Gohma's position
;@ towards Link at speed $18. At the end the eye shuts (hitbox flags $80, frame 1) and it walks on
;@ after $40 frames (state 1).
GohmaEyeState::
;> if wEntityTimer2[slot] != 0: return
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7d34

	ret


;> t1 = GetEntityTimer1(slot)
jr_005_7d34:
	call GetEntityTimer1
;> if t1 < 2:
	cp $02
	jr nc, jr_005_7d5b

;>     if t1 != 0:                        # the eye shuts
	cp $00
	jr z, jr_005_7d56

;>         wEntityHitboxFlags[slot] = 0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $80
;>         SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;>         wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>         wEntityTimer2[slot] = 0x40
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $40
;>         return
	ret


;>     wEntityTimer1[slot] = 0x30         # the eye opens; t1 stays 0
jr_005_7d56:
	call GetEntityTimer1
	ld [hl], $30

;> if t1 == 0x18:
jr_005_7d5b:
	cp $18
	jr nz, jr_005_7d82

;>     new = SpawnEntity(0x7D)            # its shot, at Gohma (hMultiPurpose0/1)
	ld a, $7d
	call SpawnEntity
;>     if new is not None:
	jr c, jr_005_7d82

;>         wEntityX[new] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[new] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityPrivate1[new] += 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;>         SetEntitySpeedTowardsLink(slot, 0x18)  # for the shot's slot
	push bc
	push de
	pop bc
	ld a, $18
	call SetEntitySpeedTowardsLink
	pop bc

;> wEntityHitboxFlags[slot] = 0           # the open eye can be hit
jr_005_7d82:
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
;> return SetEntitySpriteVariant(slot, 4)
	ld a, $04
	jp SetEntitySpriteVariant


;@ def BossDefeatedHandler_05(slot: bc)
;@ path: boss/common
;@ The defeat of a boss of this bank that is no longer active, in steps by wEntityPrivate2
;@ (BossDefeatedStates_05): it flashes for $A0 frames, then $C0 more frames with explosion puffs,
;@ then EndBossFight_05.
BossDefeatedHandler_05::
;> BossDefeatedStates_05[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/common
;@ The defeat steps, by wEntityPrivate2.
BossDefeatedStates_05::
	dw BossDefeated_Start_05
	dw BossDefeated_Flash_05
	dw BossDefeated_Explode_05

;@ def BossDefeated_Start_05(slot: bc)
;@ path: boss/common
;@ Step 0: $A0 frames of flashing.
BossDefeated_Start_05::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> IncrementEntityPrivate2_05(slot)       # runs on into it

;@ def IncrementEntityPrivate2_05(slot: bc)
;@ path: entity/helpers
;@ wEntityPrivate2 + 1 (the next step).
IncrementEntityPrivate2_05::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
;> return
	ret


;@ def BossDefeated_Flash_05(slot: bc)
;@ path: boss/common
;@ Step 1: when the timer runs out, $C0 more frames (flashing) follow (step 2).
BossDefeated_Flash_05::
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, jr_005_7dba

;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     IncrementEntityPrivate2_05(slot)
	call IncrementEntityPrivate2_05

;> return
jr_005_7dba:
	ret


;@ def BossDefeated_Explode_05(slot: bc)
;@ path: boss/common
;@ Step 2: explosion puffs while the timer runs (BossExplosionPuffs_05), then EndBossFight_05.
BossDefeated_Explode_05::
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t != 0: return BossDefeated_Puffs_05(t)
	jr nz, BossDefeated_Puffs_05

;> EndBossFight_05(slot)                  # runs on into it

;@ def EndBossFight_05(slot: bc)
;@ path: boss/common
;@ A boss of this bank is beaten (noise $1A). The Evil Eagle leaves its heart container at a fixed
;@ place (SpawnEvilEagleHeartContainer_05); the others die with their drop (DefeatEntityWithDrop). Then, if a
;@ slot still holds an entity with option bit 7 (a boss), the room is marked (bit 5 of its
;@ wRoomStatus entry) in dungeon maps from 5 on; if none is left, the area music comes back.
EndBossFight_05::
;> hNoiseSfx = 0x1A
	ld a, $1a
	ldh [hNoiseSfx], a
;> if hActiveEntityType == 0x63: return SpawnEvilEagleHeartContainer_05(slot)
	ldh a, [hActiveEntityType]
	cp $63
	jp z, SpawnEvilEagleHeartContainer_05

;> DefeatEntityWithDrop()                            # dies with its drop
	call DefeatEntityWithDrop
;> for e in range(15, -1, -1):
	ld e, $0f
	ld d, b

;>     if wEntityStatus[e] == 0: continue
jr_005_7dd1:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7de2

;>     opts = wEntityOptions1[e]
;>@m     if opts & 0x80:                    # a boss
;>@m         if hMapId < 5: return
;>@m         return MarkBossRoomBeaten_05()
	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_005_7df0

;>     # next slot
jr_005_7de2:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_7dd1

;> wRestoreMusicAfterTransition = 0
	xor a
	ld [wRestoreMusicAfterTransition], a
;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> return
	ret


jr_005_7df0:
;=@m
	ldh a, [hMapId]
	cp $05
	ret nc

;=@m
	jp MarkBossRoomBeaten_05


;@ def BossDefeated_Puffs_05(t: a)
;@ path: boss/common
;@ Explosion puffs during the last defeat step (BossExplosionPuffs_05).
BossDefeated_Puffs_05::
;> BossExplosionPuffs_05(t)
	call BossExplosionPuffs_05
;> return
	ret


;@ def MarkBossRoomBeaten_05()
;@ path: boss/common
;@ Sets bit 5 of the current room's wRoomStatus entry: $D900 + room for dungeon maps below 6 and from
;@ $1A on, $DA00 + room for maps 6-$19.
MarkBossRoomBeaten_05::
;> e = hMapRoom
	ldh a, [hMapRoom]
	ld e, a
;> d = 0
	ld d, b
;> if 6 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_005_7e0b

	cp $06
	jr c, jr_005_7e0b

;>     d = 1
	inc d

;> wRoomStatus[0x100 + 0x100 * d + e] |= 0x20
jr_005_7e0b:
	ld hl, wRoomStatus + $100
	add hl, de
	set 5, [hl]
;> return
	ret


;@ path: unused/padding
;@ The unused end of bank 5 ($7E12-$7FFF): 494 bytes of $FF.
Bank05Padding::
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
