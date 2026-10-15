; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

;@ path: npc/bowwow
;@ BowWow's sprites while it is chained at Madam MeowMeow's house (its tiles sit at $70-$7C there).
;@ 7 sprite variants of 4 bytes, drawn by Call_3C3B as two 8x16 sprites side by side: tile and
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

;> Call_3C3B(sprites)                  # draw BowWow (two 8x16 sprites)
jr_005_4060:
	call Call_3C3B
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

;>     DrawBowWowChain()                 # while the screen scrolls only the chain is kept up
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

;>@chain     DrawBowWowChain()
;>@chain     return
;> if wTransitionSequenceCounter != 4:  # screen still fading in
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	ret nz

;> SetBowWowSpriteFromSpeed()
	call SetBowWowSpriteFromSpeed
;> DecrementEntityIgnoreHitsTimer()                        # count down wEntityIgnoreHitsTimer
	call DecrementEntityIgnoreHitsTimer
;> if wIsBowWowFollowingLink == 0:
	ld a, [wIsBowWowFollowingLink]
	and a
	jr nz, jr_005_40a1

;>     Call_3BEB()                    # at home it can be hit with the sword
	call Call_3BEB

;> BowWowDispatch(slot)
jr_005_40a1:
	call BowWowDispatch

;> DrawBowWowChain()
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

;> Call_3B9E()                        # walls and ground under the entity
jr_005_4163:
	call Call_3B9E
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
;>@attack     Call_3C25(0x20)                    # speed $20 towards Link
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
	call Call_3B8D
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
	call Call_3B8D
	ld [hl], $02
;=@attack
	ld a, $20
	call Call_3C25
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
	call Call_3B8D
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

;>     Call_3DAF()                    # stop
jr_005_41ff:
	call Call_3DAF
;>     wEntityState[slot] = 3
	call Call_3B8D
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
	call Call_3B8D
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

;> Call_3DD0(3)                      # reserve 3 sprite entries
	pop bc
	ld a, $03
	call Call_3DD0
	ret


;@ def BowWowLookForFood(slot: bc)
;@ path: npc/bowwow
;@ While following Link: searches the slots (from a random end) for an entity BowWow can eat (its
;@ type's byte in the table read by Call_37E6 is nonzero) that is within 47 pixels of Link. If one is
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

;>     elif Call_37E6(wEntityType[other]) == 0:   # not something BowWow eats
	push de
	ld hl, wEntityType
	add hl, de
	ld e, [hl]
	call Call_37E6
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
;>         Call_3C25(0x30)                # speed $30 towards it
	ld a, $30
	call Call_3C25
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
	call Call_3B8D
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
;@ counts up its wEntityPrivateCounter. Anything else is eaten (Call_3F7A kills it).
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


;> Call_3F7A(other)                    # eaten: the entity dies
jr_005_43a9:
	push bc
	push de
	pop bc
	call Call_3F7A
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

;>     Call_3B87(6)                    # wEntitySpriteVariant = 6
;>     return
	ld a, $06
	jp Call_3B87


;> SetTwoFrameSpriteVariant_05(0)       # down
jr_005_4511:
	ld e, $00

;@ def SetTwoFrameSpriteVariant_05(base: e)
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
;> Call_3B87(base + frame)            # wEntitySpriteVariant
	add e
	jp Call_3B87


;@ path: npc/cucco
;@ The cucco's sprites: 4 variants of 4 bytes for Call_3C3B (tile and attributes of the left 8x16
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

;> Call_3C3B(CuccoSprites)
jr_005_4542:
	ld de, CuccoSprites
	call Call_3C3B
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

;>     Call_3B87((hFrameCounter >> 2) & 1)  # flap its wings
;>     return
jr_005_4558:
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	jp Call_3B87


;> if ReturnIfNonInteractive_05():
jr_005_4561:
	call ReturnIfNonInteractive_05
;>     return
;> Call_3BEB()                            # the sword can hit it
	call Call_3BEB
;> DecrementEntityIgnoreHitsTimer()
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
	call Call_3B8D
	ld a, $02
	ld [hl], a
;>     hActiveEntityState = 2
	ldh [hActiveEntityState], a

;> if Call_3BD5():                        # Link touches it
jr_005_45c9:
	call Call_3BD5
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
;> Call_3B87(0)
	xor a
	call Call_3B87
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
	call Call_3B8D

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
;> Call_3B9E()
	call Call_3B9E
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
	call Call_3B8D
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
;> Call_3B87(frame)
	call Call_3B87
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

;>     Call_3C30(0x0C)                     # vector of speed $0C towards Link
	ld a, $0c
	call Call_3C30
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
;> Call_3B9E()
	call Call_3B9E
;> Call_3B87((hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call Call_3B87
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

;>         new = Call_3C13(0x6C, 7)        # spawn a cucco in slots 0-7 (carry: none free)
	ld a, $6c
	ld e, $07
	call Call_3C13
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
;>             Call_3C25(0x18)             # (for the new cucco) speed $18 towards Link
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_005_475a:
	ret


;@ def CuccoRevengeState(slot: bc)
;@ path: npc/cucco
;@ State 3, a revenge cucco: flies straight on through walls, hurts Link when it touches him and
;@ disappears once it leaves the screen. Flaps every 4 frames and makes a noise.
CuccoRevengeState::
;> Call_3BBF()                            # hurts Link on contact
	call Call_3BBF
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

;> Call_3B87((hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call Call_3B87
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
;@ The witch's sprites: 4 variants of 4 sprites for Call_3D26, each sprite 4 bytes: y offset, x offset,
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
;>@draw Call_3D26(WitchSprites + 16 * hActiveEntitySpriteVariant, 4)
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
	call Call_3D26
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
;>@anim Call_3B87((wEntityPrivateCounter[slot] >> 4) & 3)
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $03
;=@anim
	call Call_3B87
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
	jp Call_3B8D


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
	call Call_3B8D
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
	call Call_3B8D

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
	call Call_3B8D

;@ def WitchDoneState(slot: bc)
;@ path: npc/witch
;@ State 4: nothing more to do.
WitchDoneState::
;> return
	ret


;@ path: npc/tarin
;@ Sprites of the raccoon (Tarin under the mushroom's spell) for Call_3C3B: 8 variants of 4 bytes
;@ (tile and attributes of the left 8x16 half, then of the right half; $20 = mirrored).
;@ 0-1 sitting (the picture flips), 2-3 alarmed, 4-7 the four steps of its spin. Variants 8-12 run
;@ on into TarinStandingSprites and TarinSleepingSprite (Tarin himself after the spell breaks).
TarinSprites::
	db $78, $00, $7a, $00,  $7a, $20, $78, $20,  $7c, $00, $7e, $00,  $78, $00, $7a, $00
	db $70, $00, $72, $00,  $74, $00, $76, $00,  $76, $20, $74, $20,  $72, $20, $70, $20
;@ path: npc/tarin
;@ Tarin standing, one variant per facing (Call_3C3B format): 0 right, 1 left, 2 up, 3 down (up and
;@ down use the same picture).
TarinStandingSprites::
	db $5a, $20, $58, $20,  $58, $00, $5a, $00,  $50, $00, $52, $00,  $50, $00, $52, $00
;@ path: npc/tarin
;@ Tarin lying asleep in his bed (one Call_3C3B variant).
TarinSleepingSprite::
	db $54, $00, $56, $00

;@ path: npc/tarin
;@ The ending picture of this character, first form: 4 sprites for Call_3D26 (y offset, x offset, tile,
;@ attributes). The same 16x16 picture (tiles $20/$22) is listed twice.
TarinEndingSprites1::
	db $00, $00, $20, $00,  $00, $08, $22, $00,  $00, $00, $20, $00,  $00, $08, $22, $00

;@ path: npc/tarin
;@ The ending picture, second form (after $70 frames): tile $2A twice above (the second mirrored),
;@ tiles $24/$28 below. Call_3D26 format as TarinEndingSprites1.
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

;>     Call_3D26(sprites, 4)
jr_005_4931:
	ld c, $04
	call Call_3D26
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

;>@sit     Call_3B87((hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@sit
	call Call_3B87
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
;>         Call_3B87(frame + 2)          # alarmed
	add $02
	call Call_3B87
	jr jr_005_497c

;>     else:
;>         wEntityPrivate4[slot] = 0     # its remark may come again
jr_005_4977:
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b

;> Call_3C3B(TarinSprites)
jr_005_497c:
	ld de, TarinSprites
	call Call_3C3B
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

;>@spin Call_3B87(RaccoonSpinFrames[wEntityPrivate5[slot]])
jr_005_49f1:
	ld hl, wEntityPrivate5
	add hl, bc
	ld e, [hl]
	ld d, b
;=@spin
	ld hl, RaccoonSpinFrames
	add hl, de
	ld a, [hl]
	call Call_3B87
;> if GetEntityDropTimer() == 0:         # the spell breaks
	call GetEntityDropTimer
	jr nz, jr_005_4a49

;>     new = Call_3C01(0x02)             # an entity of type $02 at its place
	ld a, $02
	call Call_3C01
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
;>     Call_3B87(9)                      # now Tarin
	ld a, $09
	call Call_3B87
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     wEntityState[slot] += 1
	call Call_3B8D
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
;> Call_3B9E()
	call Call_3B9E
;> t = GetEntityDropTimer()
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

;> if GetEntityDropTimer() < 0x60 and hFrameCounter & 3 == 0:
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
;>     Call_3B87(GetEntityDirectionToLink_05(slot) + 8)    # Tarin facing Link
	call GetEntityDirectionToLink_05
	add $08
	call Call_3B87
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
	call Call_3B8D

jr_005_4b31:
	ret


;@ def TarinCuredState(slot: bc)
;@ path: npc/tarin
;@ State 3: when wEntityTimer reaches 1 Tarin speaks (text $00A); afterwards he turns to Link every
;@ 32 frames, blocks him (unless he landed next to him) and talking shows text $00B.
TarinCuredState::
;> t = GetEntityTimer()
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

;>     Call_3B87(GetEntityDirectionToLink_05(slot) + 8)
	call GetEntityDirectionToLink_05
	add $08
	call Call_3B87

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
;@ The bubble rising from sleeping Tarin: one 8x16 sprite for Call_3CD0 (tile, attributes).
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

;>     Call_3CD0(TarinSnoreBubbleSprite)
	ld de, TarinSnoreBubbleSprite
	call Call_3CD0
;>     if ReturnIfNonInteractive_05():
	call ReturnIfNonInteractive_05
;>         return
;>     UpdateEntityPosWithSpeed_05(slot)
	call UpdateEntityPosWithSpeed_05
;>     t = GetEntityTimer()
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
;>     Call_3DBA()                       # copy the position to hActiveEntityX / Y
	call Call_3DBA
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

;> Call_3C3B(sprites)
jr_005_4bf3:
	call Call_3C3B
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
	call Call_3B8D
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
	call Call_3B8D

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
	call Call_3B8D

jr_005_4c45:
	ret


;@ path: npc/tarin
;@ The shield Link holds over his head: one 8x16 sprite for Call_3CD0 (tile $86, attributes $10 =
;@ sprite palette 1).
ShieldHeldUpSprite::
	db $86, $10

;@ def TarinGiveShieldState(slot: bc)
;@ path: npc/tarin
;@ State 2: while wEntityTimer runs Link stands in his item pose ($6C) facing down with the shield
;@ drawn above his head. Then he gets the shield (item 4, wShieldLevel 1), text $091, state 3.
TarinGiveShieldState::
;> if GetEntityTimer() == 0:
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
	jp Call_3B8D


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
;> Call_3CD0(ShieldHeldUpSprite)          # the shield over Link's head
	ld de, ShieldHeldUpSprite
	call Call_3CD0
;> Call_3DBA()                           # back to Tarin's own position
	call Call_3DBA
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

;>     new = Call_3C01(0x3F)             # another Tarin entity: a snore bubble
	ld a, $3f
	call Call_3C01
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
	call Call_3B8D
	ld [hl], b

jr_005_4d49:
	ret


;@ path: npc/tarin
;@ An object drawn next to Tarin at home while wTarinState is 2 and the trade item is below 4 (one
;@ Call_3C3B variant, tiles $74/$76), at x $78.
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
;> Call_3C3B(sprites)
	call Call_3C3B
;> Call_3DBA()                           # back to Tarin's own position
	call Call_3DBA
;> hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ret


;@ path: npc/marin
;@ Marin's sprites in her house, for Call_3C3B (4 bytes a variant: tile and attributes of the left
;@ 8x16 half, then of the right half; $20 = mirrored), as chosen by AnimateNpcFacing_05: 0-1 facing
;@ down, 2-3 up, 4-5 left, 6-7 right (two walking frames each).
MarinSprites::
	db $60, $00, $62, $00,  $62, $20, $60, $20,  $64, $00, $66, $00,  $66, $20, $64, $20
	db $68, $00, $6a, $00,  $6c, $00, $6e, $00,  $6a, $20, $68, $20,  $6e, $20, $6c, $20
;@ path: npc/marin
;@ Marin's sprites outdoors (Call_3C3B format): 0-7 as in MarinSprites (down, up, left, right with
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
;>     sing = wMarinSinging == 1 and GetEntityTimer1() == 0
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

;>         new = Call_3C01(0xC9)         # a music note
	ld a, $c9
	call Call_3C01
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
;> Call_3C3B(MarinOutdoorSprites)
	ld de, MarinOutdoorSprites
	call Call_3C3B
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
	call Call_3B8D

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
	call Call_3B8D
;>     wSongShowTimer = 0
	xor a
	ld [wSongShowTimer], a
	ld [wSongShowTimer + 1], a
;>     return
	ret


;> wEntityState[slot] = 0
jr_005_4fb8:
	call Call_3B8D
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
	jp Call_3B8D


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

;>     new = Call_3C01(0xC9)             # a music note from Link
	ld a, $c9
	call Call_3C01
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
	call Call_3B8D
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
	call Call_3B8D
	ld [hl], $01
;> wEntityPrivate3[slot] = 0              # the song starts again
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], b

jr_005_50b5:
	ret


;@ path: npc/marin
;@ The ocarina held over Link's head while he learns the song: one 8x16 sprite for Call_3CD0 (tile
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
;> t = GetEntityTimer()
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
	call Call_3B8D
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
;> Call_3CD0(OcarinaHeldUpSprite)
	call Call_3CD0
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
;@ Marin's picture in her house late in the game (trade item 7 on): one Call_3C3B variant, tile $5C
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
;>     Call_3C3B(MarinLateSprite)
	ld de, MarinLateSprite
	call Call_3C3B
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
	call Call_3B8D
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
;> Call_3C3B(MarinSprites)
	ld de, MarinSprites
	call Call_3C3B
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
;@ Link in Marin's bed (Call_3C3B format, 5 variants): 0-1 asleep (the picture flips), 2 stirring,
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
;> t = GetEntityDropTimer()
	call GetEntityDropTimer
;> if t == 0:
	jr nz, jr_005_51ee

;>     OpenDialog(0x01)                  # text $001
	ld a, $01
	call OpenDialog
;>     mem[hl] = 0x40                    # through the pointer OpenDialog leaves in hl
	ld [hl], $40
;>     wEntityState[slot] += 1
	call Call_3B8D
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

;@ def DrawLinkInBed(variant: a)
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
;> Call_3C3B(LinkInBedSprites)
	ld de, LinkInBedSprites
	call Call_3C3B
;> Call_3DBA()                           # back to Marin's own position
	call Call_3DBA
	ret


;@ def LinkInBedState(slot: bc)
;@ path: npc/marin
;@ State 2: Link lies awake in bed (variant 3). When the text is closed and a direction is held, he
;@ jumps out of bed to the right (a small hop like jumping down a ledge) and Marin's state 3 starts.
LinkInBedState::
;> DrawLinkInBed(3)
	ld a, $03
	call DrawLinkInBed
;> if GetEntityTimer() or wDialogState:
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
	call Call_3B8D
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
;@ The raft shop owner's sprites (Call_3C3B format: tile and attributes of the left 8x16 half, then of
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
;> Call_3C3B(RaftOwnerSprites)
	ld de, RaftOwnerSprites
	call Call_3C3B
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
	call Call_3B8D

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
	call Call_3B8D
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
;@ The raft's sprites (Call_3C3B format): two variants, tile $5C and $5E each with its mirror (the
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

;>     Call_3C3B(RaftSprites)
	ld de, RaftSprites
	call Call_3C3B
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
;> Call_3B87(frame)
	call Call_3B87
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
	call Call_3B8D
	ld [hl], b
;>     Call_3DBA(); Call_3C3B(RaftSprites); return    # the drawing at the end of RaftBoardState
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
	call Call_3B8D

;> Call_3DBA()
;> Call_3C3B(RaftSprites)
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
	call Call_3B8D
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

;> Call_3DBA()
jr_005_53cd:
	call Call_3DBA
;> Call_3C3B(RaftSprites)
	ld de, RaftSprites
	jp Call_3C3B


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

;> hLinkInWater = 1; Call_3DBA(); Call_3C3B(RaftSprites)    # the end of RaftBoardState
jr_005_5407:
	jr jr_005_53c9

;@ def MakeEntitySolid_05()
;@ path: entity/collision
;@ Makes the active entity a solid obstacle: if Link touches it he is put back where he was this
;@ frame (and a Pegasus Boots dash ends), and a hookshot chain that reached it goes back to its
;@ first state.
MakeEntitySolid_05::
;> if not Call_3BD5():                    # Link does not touch it
	call Call_3BD5
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
;> Call_3B87(base | frame)
	or [hl]
	jp Call_3B87


;@ def ShouldLinkTalkToEntity_05() -> carry
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

;>     if GetEntityDirectionToLink_05() != hLinkDirection ^ 1:   # Link must face it
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
;> Call_3F12()
	call Call_3F12
;> DrawAnglerFish()
	call DrawAnglerFish
;> if hActiveEntityStatus == 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     AnglerFishAlive(slot)
;>     return
	jr z, AnglerFishAlive

;> mem[0xC1C6] = hActiveEntityStatus
	ld [$c1c6], a
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
;@ Death step 0: $FF frames of flashing, then the shared step code at Jump_005_6294.
AnglerFishDeathStart::
;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> Jump_005_6294()
	jp Jump_005_6294


;@ def AnglerFishDeathExplode(slot: bc)
;@ path: boss/angler_fish
;@ Death step 1: it flashes as long as wEntityTimer runs, with explosions (Call_05_7476) in the last
;@ $80 frames; at the end Call_05_74AD spawns the next entity with an 8-frame death timer.
AnglerFishDeathExplode::
;> t = GetEntityTimer()
;> if t == 0:
	call GetEntityTimer
	jp z, Jump_005_54f2

;>@end     new = Call_05_74AD()
;>@end     wEntityDyingTimer[new] = 8
;>@end     return
;> wEntityFlashTimer[slot] = t
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
;> if t < 0x80:
	cp $80
	jr nc, jr_005_54f1

;>     Call_05_7476()                    # explosions
	call Call_05_7476

jr_005_54f1:
	ret


Jump_005_54f2:
;=@end
	call Call_05_74AD
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

;>     new = Call_3C13(0x65, 4)          # a falling rock (slots 0-4)
	ld a, $65
	ld e, $04
	call Call_3C13
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

;>         new = Call_3C13(0x65, 4)      # a bubble
	ld a, $65
	ld e, $04
	call Call_3C13
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

;>         new = Call_3C13(0x65, 4)      # an angler fry
	ld a, $65
	ld e, $04
	call Call_3C13
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

;> DecrementEntityIgnoreHitsTimer()
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
;> Call_3B65()                            # load that hitbox
	call Call_3B65
;> Call_3BEB()                            # sword hits on it
	call Call_3BEB
;> Call_3DBA()                            # its real position again
	call Call_3DBA
;> wEntityHitboxFlags[slot] = 0x14
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $14
;> Call_3B65()
	call Call_3B65
;> Call_3BBF()                            # hurts Link on contact
	call Call_3BBF
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
;> if GetEntityDropTimer() == 0:
	call GetEntityDropTimer
	jr nz, jr_005_5649

;>     wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;>     wEntityState[slot] += 1
	call Call_3B8D
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
;> t = GetEntityTimer()
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
	call Call_3B8D

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
	call Call_3B8D
	ld [hl], b

jr_005_56d5:
	ret


;@ path: boss/angler_fish
;@ The Angler Fish, sprite list set A: 2 variants of 20 entries of 4 bytes for Call_3D26 (y offset, x
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

;> Call_3D26(sprites + offset, 19)
jr_005_582c:
	add hl, de
	ld c, $13
	call Call_3D26
;> Call_3DD0(19)
	ld a, $13
	call Call_3DD0
	ret


;@ path: boss/angler_fish
;@ A bubble from the Angler Fish's mouth: 2 variants for Call_3CD0 (tile, attributes): tile $72 and
;@ its mirror.
AnglerBubbleSprites::
	db $72, $00,  $72, $20

;@ def AnglerBubble(slot: bc)
;@ path: boss/angler_fish
;@ Part 2, a bubble: it wobbles (mirrored every 8 frames) and rises in spurts (speed -8 for 48 of
;@ every 64 frames) until it reaches the top (drawn y < $10).
AnglerBubble::
;> Call_3CD0(AnglerBubbleSprites)
	ld de, AnglerBubbleSprites
	call Call_3CD0
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@wob Call_3B87((wEntityPrivateCounter[slot] >> 3) & 1)
	ld a, [hl]
	rra
	rra
	rra
	and $01
;=@wob
	call Call_3B87
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
;@ A rock falling from the ceiling: 2 Call_3C3B variants (tiles $74/$76, then mirrored).
AnglerRockSprites::
	db $74, $00, $76, $00,  $76, $20, $74, $20

;@ def AnglerFallingRock(slot: bc)
;@ path: boss/angler_fish
;@ Part 1, a falling rock: falls at speed $0C, swaying left and right (x speed -4 / +4 for 16 frames
;@ each, mirrored with it), hurts Link and can be hit; gone at the bottom (drawn y >= $8B).
AnglerFallingRock::
;> Call_3C3B(AnglerRockSprites)
	ld de, AnglerRockSprites
	call Call_3C3B
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> n = wEntityPrivateCounter[slot]
	ld a, [hl]
	push af
;> Call_3B87((n >> 4) & 1)
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
;> Call_3BB4()                            # touches Link / sword hits
	call Call_3BB4
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
;@ An angler fry: 2 Call_3C3B variants (tiles $78/$7A and $7C/$7E), mirrored by AnglerFry when it
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
;> Call_3C3B(AnglerFrySprites)
	ld de, AnglerFrySprites
	call Call_3C3B
;> if ReturnIfNonInteractive_05(): return
	call ReturnIfNonInteractive_05
;> DecrementEntityIgnoreHitsTimer()
	call DecrementEntityIgnoreHitsTimer
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> Call_3B87(frame)
	call Call_3B87
;> Call_3BB4()
	call Call_3BB4
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
	call Call_3B8D

;> UpdateEntityPosWithSpeed_05(slot)
jr_005_5909:
	call UpdateEntityPosWithSpeed_05
;> if GetEntityTimer() == 0:
	call GetEntityTimer
	jr nz, jr_005_5918

;>     if hActiveEntityX >= 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>         ClearEntityStatus_05(slot)
	jp nc, ClearEntityStatus_05

jr_005_5918:
	ret


BGChangeTilesA::
	db $07, $00, $0f, $07, $1e, $0f, $3f, $18, $3f, $10, $3f, $14, $3f, $10, $27, $1b
	db $e0, $00, $f0, $e0, $18, $f0, $8c, $78, $8c, $70, $3f, $c0, $ff, $3e, $ef, $f1
BGChangeTilesB::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $07, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $00, $ff, $3e, $ef, $f1
EvilEagleArenaSetup::
	db $21, $30, $c4, $09, $7e, $e6, $7f, $77, $1e, $0f, $50, $21, $80, $c2, $19, $70
	db $1d, $7b, $fe, $01, $20, $f5, $fa, $78, $d4, $a7, $28, $23, $3e, $05, $cd, $b9
	db $07, $cd, $3f, $5a, $21, $90, $c2, $19, $36, $07, $21, $e0, $c2, $19, $36, $60
	db $3e, $01, $e0, $a5, $cd, $8d, $3b, $36, $04, $3e, $c0, $ea, $10, $c2, $c9, $3e
	db $02, $e0, $a5, $ea, $78, $d4, $cd, $91, $08, $36, $80, $1e, $0c, $af, $21, $90
	db $d7, $22, $1d, $20, $fc, $3e, $02, $ea, $05, $d2, $3e, $5c, $ea, $68, $d3, $c9
EvilEagleSpawnOffsetX::
	db $10, $f0

EvilEagleEntityHandler::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

EvilEagleParts::
	dw GrimCreeper
	dw EvilEagle
	dw GrimCreeperBat
	dw EvilEagleFeather

GrimCreeper::
	ldh a, [hActiveEntityState]
	rst $00

GrimCreeperStates::
	dw GrimCreeperArriveState
	dw GrimCreeperCallEagleState
	dw GrimCreeperWaitState
	dw GrimCreeperFallState
	dw GrimCreeperGoneState

jr_005_59d6:
	ret


GrimCreeperArriveState::
	call DrawGrimCreeper
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, jr_005_59d6

	ld a, $02

jr_005_59e2:
	ldh [hBGTilesRequestCopy], a
	ld a, $63
	call Call_3C01
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $59b8
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	sub $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	pop bc
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ldh a, [hBGTilesRequestCopy]
	dec a
	jr nz, jr_005_59e2

	call GetEntityTimer
	ld [hl], $43
	jp Call_3B8D


GrimCreeperCallEagleState::
	call DrawGrimCreeper
	call ReturnIfNonInteractive_05
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	and a
	jr z, jr_005_5a3a

	cp $20
	jr nz, jr_005_5a75

	ldh a, [hLinkY]
	push af
	ld a, $10
	ldh [hLinkY], a
	ld a, $ba
	call OpenDialog
	pop af
	ldh [hLinkY], a
	ret


jr_005_5a3a:
	ld a, $54
	ld [wMusicTrackToPlay], a
	ld a, $63
	call Call_3C01
	ld hl, wEntityHealth
	add hl, de
	ld [hl], $0c
	ld hl, wEntityX
	add hl, de
	ld [hl], $d0
	ld hl, wEntityY
	add hl, de
	ld [hl], $18
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $e0
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $00
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $80
	call EvilEagleScreech
	call Call_3B8D
	ret


jr_005_5a75:
	ret


GrimCreeperWaitState::
	call DrawGrimCreeper
	ret


GrimCreeperFallState::
	call DrawGrimCreeper
	call ReturnIfNonInteractive_05
	call UpdateEntityPosWithSpeed_05
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	inc [hl]
	ret


GrimCreeperGoneState::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
	ret


GrimCreeperSprites::
	db $7e, $00, $7e, $20, $7e, $40, $7e, $60

DrawGrimCreeper::
	ld de, $5a91
	call Call_3C3B
	ret


EvilEagleAttackByHits::
	db $02, $02, $02, $00, $01, $00, $01, $04, $04, $04, $04

EvilEagle::
	call DrawEvilEagle
	ldh a, [hActiveEntityStatus]
	cp $05
	jp nz, BossDefeatedHandler_05

	call ReturnIfNonInteractive_05
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	cp $0e
	jr z, jr_005_5af7

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5af7

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $50
	call Call_3DAF
	call Call_3B8D
	ld [hl], $0e
	ld a, $31
	ldh [hNoiseSfx], a
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $42
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $08
	jr nz, jr_005_5aec

	dec [hl]

jr_005_5aec:
	ld e, a
	ld d, b
	ld hl, $5aa0
	add hl, de
	ld a, [hl]
	ld [wEvilEagleAttack], a
	ret


jr_005_5af7:
	ldh a, [hActiveEntityState]
	rst $00

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

EvilEagleFlyInState::
	call UpdateEntityPosWithSpeed_05
	call GetEntityTimer
	jr nz, jr_005_5b2d

	call Call_3B8D
	call GetEntityTimer
	ld [hl], $20
	ld a, $ff
	call Call_3B87

jr_005_5b2d:
	ret


EvilEagleTurnState::
	call GetEntityTimer
	jr nz, jr_005_5b66

	xor a
	call Call_3B87
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $14
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $02
	jr z, jr_005_5b67

	call Call_3B8D
	ld [hl], b
	call GetEntityTimer
	ld [hl], $80

EvilEagleScreech::
	ld a, $22
	ldh [hNoiseSfx], a

jr_005_5b66:
	ret


jr_005_5b67:
	call Call_3B8D
	call GetEntityTimer
	ld [hl], $30
	ld a, $30
	ldh [hNoiseSfx], a
	ret


EvilEagleSlowDownState::
	call UpdateEntityPosWithSpeed_05
	call GetEntityTimer
	cp $01
	jr nz, jr_005_5b83

	ld hl, hJingle
	ld [hl], $30

jr_005_5b83:
	and a
	jr nz, jr_005_5b9e

	ld hl, wEntitySpeedX
	add hl, bc
	inc [hl]
	jr nz, jr_005_5b9b

	call Call_3B8D
	call GetEntityTimer
	ld [hl], $40
	ld hl, $c29e
	inc [hl]
	inc hl
	inc [hl]

jr_005_5b9b:
	call EvilEagleFlap

jr_005_5b9e:
	ret


EvilEagleGustState::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	jr nz, EvilEagleFlap

	ld [hl], $28
	ld a, $d0
	ld [wEntitySpeedY], a
	ld a, $24
	ldh [hJingle], a
	ld a, $12
	ld [wEntitySpeedX], a
	ld hl, wEntityState
	inc [hl]
	call Call_3B8D

EvilEagleFlap::
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $04
	ld a, $01
	jr z, jr_005_5bcc

	inc a

jr_005_5bcc:
	call Call_3B87
	ret


EvilEagleClearTowerState::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	jr nz, jr_005_5beb

	ld a, $01
	ldh [hBGChangeRequest], a
	ld [hl], $20
	call Call_3B8D
	ld hl, wEntityState
	inc [hl]
	ld a, $c0
	ld [wEntityY], a

jr_005_5beb:
	jp EvilEagleFlap


EvilEagleFlapFrames::
	db $01, $02, $03, $02

EvilEagleHoverState::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	call GetEntityTimer
	jr nz, EvilEagleFlapWings

	call Call_3B8D

EvilEagleFlapWings::
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	nop
	and $03
	ld e, a
	ld d, b
	ld hl, $5bee
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


EvilEagleLeaveState::
	call UpdateEntityPosWithSpeed_05
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $d4
	jr nz, jr_005_5c42

	ldh a, [hActiveEntityX]
	and $f8
	cp $c0
	jr nz, jr_005_5c32

	call Call_3B8D
	call GetEntityTimer
	ld [hl], $80
	ret


jr_005_5c32:
	ldh a, [hFrameCounter]
	and $00
	jr nz, jr_005_5c3d

	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

jr_005_5c3d:
	xor a
	call Call_3B87
	ret


jr_005_5c42:
	dec [hl]
	dec [hl]
	call EvilEagleFlapWings
	call EvilEagleFlapWings
	jp EvilEagleFlapWings


EvilEagleAttackTable::
	db $f8, $a8, $30, $d0, $30, $70, $dc, $24, $f8, $a8, $20, $e0, $04, $00

EvilEagleChooseAttack::
	call GetEntityTimer
	jr nz, jr_005_5caf

	ld a, [wEvilEagleAttack]
	rst $00

EvilEagleAttacks::
	dw EvilEagleStartSwoop
	dw EvilEagleStartDrop
	dw EvilEagleStartBlow
	dw EvilEagleStartBlow
	dw EvilEagleStartDrop

EvilEagleStartSwoop::
	call GetRandomByte
	and $03
	ld [wEvilEagleAttack], a
	ld e, $00
	ldh a, [hLinkX]
	cp $50
	jr nc, jr_005_5c7f

	inc e

jr_005_5c7f:
	ld d, b
	ld hl, $5c4d
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, $5c4f
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ld [hl], $00
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $20
	call Call_3B8D
	ld [hl], $08

jr_005_5caf:
	ret


EvilEagleStartDrop::
	ld e, $00
	ldh a, [hLinkX]
	cp $50
	jr nc, jr_005_5cb9

	inc e

jr_005_5cb9:
	ld d, b
	ld hl, $5c51
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ld [hl], $f0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
	call Call_3B8D
	ld [hl], $0b
	call GetEntityTimer
	ld [hl], $30
	ret


EvilEagleStartBlow::
	call GetRandomByte
	and $01
	ld e, a
	ld d, b
	ld hl, $5c55
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, $5c57
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $3f
	add $18
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ldh a, [hLinkMotionStep]
	and a
	jr z, jr_005_5d28

	ldh a, [hLinkY]
	ld [hl], a

jr_005_5d28:
	call Call_3B8D
	ld [hl], $0d
	call GetEntityTimer
	ld [hl], $70
	ret


EvilEagleSwoopState::
	ld a, $01
	call Call_3B87
	call UpdateEntityPosWithSpeed_05
	ld hl, wEntitySpeedY
	call SlowSpeedTowardsZero_05
	ld a, [hl]
	and a
	jr z, jr_005_5d55

	ld hl, wEntitySpeedX

SlowSpeedTowardsZero_05::
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5d54

	and $80
	jr nz, jr_005_5d53

	dec [hl]
	dec [hl]

jr_005_5d53:
	inc [hl]

jr_005_5d54:
	ret


jr_005_5d55:
	call Call_3B8D
	call GetEntityTimer
	ld [hl], $ff
	ret


EvilEagleGustTable::
	db $ee, $12, $d0, $30, $10, $f0, $d8, $d4, $d0, $cc, $c8, $c4, $c0, $bc, $28, $2c
	db $30, $34, $38, $3c, $40, $44, $30, $2e, $2c, $2a, $28, $26, $24, $22, $30, $2e
	db $2c, $2a, $28, $26, $24, $22

EvilEagleBlowState::
	call GetEntityTimer
	jp z, Jump_005_5e77

	ld hl, wEntityY
	add hl, bc
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_5d9d

	ldh a, [hFrameCounter]
	and $20
	jr z, jr_005_5d9c

	inc [hl]
	inc [hl]

jr_005_5d9c:
	dec [hl]

jr_005_5d9d:
	call EvilEagleFlapWings
	call EvilEagleFlapWings
	ldh a, [hLinkMotionStep]
	and a
	jr nz, jr_005_5dd1

	ld a, [wIsLinkInTheAir]
	and a
	jr z, jr_005_5dd1

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $01
	ld e, a
	ld d, b
	ld hl, $5d60
	add hl, de
	ld a, [hl]
	ld hl, hLinkSpeedX
	sub [hl]
	and a
	jr z, jr_005_5dea

	and $80
	jr nz, jr_005_5dcd

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_005_5dcd:
	dec [hl]
	dec [hl]
	jr jr_005_5dea

jr_005_5dd1:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5d5e
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	push bc
	call ApplyLinkSpeedX
	call Call_3E49
	pop bc

jr_005_5dea:
	ld a, [wSongShowTimer]
	inc a
	cp $22
	jr c, jr_005_5df7

	ld a, $32
	ldh [hNoiseSfx], a
	xor a

jr_005_5df7:
	ld [wSongShowTimer], a
	call GetEntityTimer
	cp $c0
	jr nc, jr_005_5e76

	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_005_5e76

	ld a, $63
	ld e, $03
	call Call_3C13
	jr c, jr_005_5e76

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
	push bc
	ld hl, wEntityDirection
	add hl, bc
	ld c, [hl]
	srl c
	srl c
	ld hl, $5d62
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $0c
	ld [hl], a
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, c
	xor $01
	ld [hl], a
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	sla c
	sla c
	sla c
	call GetRandomByte
	and $07
	add c
	ld c, a
	ld hl, $5d74
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ld hl, $5d64
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	pop bc
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $02
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $02

jr_005_5e76:
	ret


Jump_005_5e77:
	call Call_3B8D
	call GetEntityTimer
	ld [hl], $50
	ret


EvilEagleLeaveSpeedX::
	db $e0, $20

EvilEagleFlyOffState::
	call UpdateEntityPosWithSpeed_05
	call GetEntityTimer
	jr z, jr_005_5ec0

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $01
	ld e, a
	ld d, b
	ld hl, $5e80
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	and a
	jr z, jr_005_5eb0

	and $80
	jr nz, jr_005_5ea8

	inc [hl]
	inc [hl]

jr_005_5ea8:
	dec [hl]
	call EvilEagleFlapWings
	call EvilEagleFlapWings
	ret


jr_005_5eb0:
	xor a
	call Call_3B87
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_005_5ebf

	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

jr_005_5ebf:
	ret


EvilEagleEndAttack::
jr_005_5ec0:
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $02
	call Call_3B8D
	ld [hl], $07
	call GetEntityTimer
	ld a, [wEvilEagleAttack]
	cp $04
	jr nz, jr_005_5ed8

	ld [hl], $10
	ret


jr_005_5ed8:
	ld [hl], $80
	ret


EvilEagleDropState::
	call UpdateEntityPosWithSpeed_05
	call GetEntityTimer
	jr nz, jr_005_5eeb

	ld [hl], $30
	call Call_3B8D
	call Call_3DAF

jr_005_5eeb:
	call EvilEagleFlapWings
	ret


EvilEagleKnockSpeedX::
	db $e0, $20

EvilEagleDiveState::
	call UpdateEntityPosWithSpeed_05
	call GetEntityTimer
	jr nz, jr_005_5f33

	ldh a, [hActiveEntityDrawY]
	cp $b0
	jp nc, EvilEagleEndAttack

	ld a, $01
	call Call_3B87
	ld a, [wLinkPushedTimer]
	and a
	jr nz, jr_005_5f32

	call Call_3BB4
	ld a, [wLinkPushedTimer]
	and a
	jr z, jr_005_5f32

	ld a, $10
	ld [wLinkPushedTimer], a
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5eef
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld a, $f0
	ldh [hLinkSpeedY], a
	ld hl, hLinkY
	dec [hl]

jr_005_5f32:
	ret


jr_005_5f33:
	cp $01
	jr nz, jr_005_5f51

	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $34

jr_005_5f51:
	call EvilEagleFlapWings
	call GetEntityTimer
	cp $40
	jr nc, jr_005_5f61

	call EvilEagleFlapWings
	call EvilEagleFlapWings

jr_005_5f61:
	ret


EvilEagleCrossState::
	xor a
	call Call_3B87
	call UpdateEntityPosWithSpeed_05
	call Call_3BB4
	call GetEntityTimer
	jp z, EvilEagleEndAttack

	ret


EvilEagleHurtState::
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5f8d

	cp $30
	jr nc, jr_005_5f8c

	dec a
	jr nz, jr_005_5f86

	ld a, $31
	ldh [hNoiseSfx], a

jr_005_5f86:
	call EvilEagleFlapWings
	call EvilEagleFlapWings

jr_005_5f8c:
	ret


jr_005_5f8d:
	call EvilEagleFlapWings
	call EvilEagleFlapWings
	call EvilEagleFlapWings
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $d0
	jr z, jr_005_5fa0

	dec [hl]

jr_005_5fa0:
	call UpdateEntityPosWithSpeed_05
	ldh a, [hActiveEntityDrawY]
	and $f0
	cp $c0
	jr nz, jr_005_5fae

	jp EvilEagleEndAttack


jr_005_5fae:
	ret


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
EvilEagleHitboxes::
	db $1c, $1c, $08, $0c, $14, $10, $10, $10, $f4, $1c, $08, $0c, $fc, $10, $10, $10

DrawEvilEagle::
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	ld hl, $5faf
	cp $04
	jr c, jr_005_6152

	sub $04
	ld hl, $606f

jr_005_6152:
	ld e, a
	ld d, b
	sla e
	sla e
	sla e
	sla e
	ld a, e
	sla e
	add e
	ld e, a
	add hl, de
	ld c, $0c
	call Call_3D26
	ld a, $0a
	call Call_3DD0
	ld e, $00
	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, jr_005_6175

	ld e, $04

jr_005_6175:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6181

	ld a, e
	add $08
	ld e, a

jr_005_6181:
	ld d, b
	ld hl, $612f
	add hl, de
	push hl
	pop de
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	ld c, $04

jr_005_6193:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_005_6193

	pop bc
	ret


GrimCreeperBatSprites::
	db $7c, $00, $7c, $20, $7c, $40, $7c, $60

GrimCreeperBat::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld de, $619b
	call Call_3C3B
	call ReturnIfNonInteractive_05
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [hActiveEntityState]
	rst $00

GrimCreeperBatStates::
	dw BatHoverState
	dw BatFlyAwayState

BatHoverState::
	ld hl, wEntityY
	add hl, bc
	ld e, $07
	call BatJitter
	ld hl, wEntityX
	add hl, bc
	ld e, $00

BatJitter::
	ldh a, [hFrameCounter]
	add e
	ld d, a
	and $03
	jr nz, jr_005_61e5

	ld a, d
	rra
	rra
	rra
	rra
	xor c
	and $01
	jr z, jr_005_61e4

	inc [hl]
	inc [hl]

jr_005_61e4:
	dec [hl]

jr_005_61e5:
	ret


BatFlyAwayState::
	call UpdateEntityPosWithSpeed_05
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cp $c0
	jr z, jr_005_61f3

	dec [hl]

jr_005_61f3:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $f0
	jr z, jr_005_61fd

	dec [hl]

jr_005_61fd:
	ldh a, [hActiveEntityX]
	cp $e0
	jp nc, ClearEntityStatus_05

	ret


EvilEagleFeatherSprites::
	db $7a, $20, $78, $20, $78, $00, $7a, $00, $7a, $60, $78, $60, $78, $40, $7a, $40

EvilEagleFeather::
	ld de, $6205
	call Call_3C3B
	call ReturnIfNonInteractive_05
	call UpdateEntityPosWithSpeed_05
	ldh a, [hActiveEntityState]
	rst $00

EvilEagleFeatherStates::
	dw FeatherFlyState
	dw FeatherBouncedState

FeatherFlyState::
	call Call_3BCA
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6242

	call Call_3B8D
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $e0
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]
	inc [hl]

jr_005_6242:
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]

FeatherBouncedState::
	ldh a, [hActiveEntityX]
	cp $a8
	jp nc, ClearEntityStatus_05

	ret


HideEntityWithFullHealth_05::
	db $cd, $91, $08, $36, $40, $21, $b0, $c3, $09, $36, $ff, $21, $60, $c3, $09, $36
	db $ff, $c9

Call_05_6261::
	call Call_380E
	call Call_3F12
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_627c

	cp $01
	jp z, Jump_005_66cf

	cp $02
	jp z, Jump_005_66f2

	jp Jump_005_6746


jr_005_627c:
	call Call_05_665A
	ldh a, [hActiveEntityStatus]
	cp $01
	jr nz, jr_005_62c4

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_628B::
	dw Jump_05_628F
	dw Jump_05_629A

Jump_05_628F::
	call GetEntityTimer
	ld [hl], $ff

Jump_005_6294:
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


Jump_05_629A::
	call GetEntityTimer
	jp z, Jump_005_62ad

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_005_62ac

	call Call_05_7476

jr_005_62ac:
	ret


Jump_005_62ad:
	call Call_05_74AD
	ld hl, wEntityX
	add hl, de
	ldh a, [hLinkX]
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ld [hl], $70
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70
	ret


jr_005_62c4:
	call ReturnIfNonInteractive_05
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_62CD::
	dw Jump_05_62F7
	dw Jump_05_633C
	dw Jump_05_63DF
	dw Jump_05_6488
	dw Jump_05_64CE

	db $28, $38, $58, $68, $28, $38, $58, $68, $38, $30, $30, $38, $50, $58, $58, $50
	db $10, $10, $f0, $f0, $10, $10, $f0, $f0, $fd, $03, $03, $fd, $03, $fd, $fd, $03

Jump_05_62F7::
	call GetEntityTimer
	jr nz, jr_005_633b

	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, $62d7
	add hl, de
	ld a, [hl]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, $62df
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld hl, $62e7
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $62ef
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
	ld a, $16
	ldh [hWaveSfx], a
	call Call_05_652E
	call Call_3B8D

jr_005_633b:
	ret


Jump_05_633C::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6395

	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $0b
	jr c, jr_005_6395

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_005_6394

	call Call_3B8D
	call GetEntityTimer
	ld [hl], $40
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $18
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	call GetEntityDropTimer
	ld [hl], $40
	ldh a, [hActiveEntityX]
	add $f8
	ldh [hMultiPurpose0], a
	call Call_05_6383
	ldh a, [hActiveEntityX]
	add $08
	ldh [hMultiPurpose0], a

Call_05_6383::
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f

jr_005_6394:
	ret


jr_005_6395:
	call UpdateEntityPosWithSpeed_05
	call AddEntityZSpeedToPos_05
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_63c2

	ld [hl], b
	call GetEntityTimer
	ld [hl], $40
	call Call_3B8D
	ld [hl], b
	call Call_05_6566
	call Call_05_652E
	ld a, $32
	ldh [hJingle], a
	ld a, $ff
	jp Call_3B87


jr_005_63c2:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jp nc, Jump_005_64c1

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_63de

	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	jp Call_3B87


jr_005_63de:
	ret


Jump_05_63DF::
	ld a, $02
	call Call_3B87
	call GetEntityTimer
	jr z, jr_005_6400

	and $02
	ld e, $08
	jr z, jr_005_63f1

	ld e, $f8

jr_005_63f1:
	ld hl, wEntitySpeedX
	add hl, bc
	push hl
	ld a, [hl]
	push af
	ld [hl], e
	call AddEntitySpeedToPosX_05
	pop af
	pop hl
	ld [hl], a
	ret


jr_005_6400:
	call Call_3BB4
	call GetEntityDropTimer
	jr nz, jr_005_641d

	ldh a, [hActiveEntityX]
	cp $70
	jr nc, jr_005_641d

	ldh a, [hActiveEntityDrawY]
	cp $50
	jr nc, jr_005_641d

	call Call_3DAF
	call Call_3B8D
	ld [hl], $01
	ret


jr_005_641d:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_005_6448

	ldh a, [hActiveEntityX]
	cp $70
	jr nc, jr_005_6448

	ldh a, [hActiveEntityDrawY]
	cp $50
	jr nc, jr_005_6448

	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $05
	jr c, jr_005_6448

	call Call_3B8D
	call Call_3DAF
	call GetEntityTimer
	ld [hl], $80
	ret


jr_005_6448:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $0b
	jr nc, jr_005_6487

	call UpdateEntityPosWithSpeed_05
	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	push af
	and $03
	jr z, jr_005_6467

	ld hl, wEntitySpeedX
	call Call_05_646F

jr_005_6467:
	pop af
	and $0c
	jr z, jr_005_6474

	ld hl, wEntitySpeedY

Call_05_646F::
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_005_6474:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_6487

	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $0a
	call AddTransientVfx

jr_005_6487:
	ret


Jump_05_6488::
	call GetEntityTimer
	cp $40
	jr c, jr_005_64af

	jr nz, jr_005_6498

	ld a, $29
	ldh [hNoiseSfx], a
	call Call_05_64D4

jr_005_6498:
	and $02
	ld e, $10
	jr z, jr_005_64a0

	ld e, $f0

jr_005_64a0:
	ld hl, wEntitySpeedX
	add hl, bc
	push hl
	ld a, [hl]
	push af
	ld [hl], e
	call AddEntitySpeedToPosX_05
	pop af
	pop hl
	ld [hl], a
	ret


jr_005_64af:
	and a
	jr nz, jr_005_64c1

	call Call_3B8D
	ld [hl], $01
	call Call_3DAF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $08
	ret


Jump_005_64c1:
jr_005_64c1:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $03
	call Call_3B87
	ret


Jump_05_64CE::
	ret


	db $c9, $f8, $08, $f8, $08

Call_05_64D4::
	ld a, $02

jr_005_64d6:
	ldh [hBGTilesRequestCopy], a
	ld a, $62
	call Call_3C01
	jr c, jr_005_6528

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $64cf
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
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
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hBGTilesRequestCopy]
	dec a
	ld [hl], a
	ld hl, $64d1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $04
	pop bc
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $08
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42

jr_005_6528:
	ldh a, [hBGTilesRequestCopy]
	dec a
	jr nz, jr_005_64d6

	ret


Call_05_652E::
	ld a, $62
	call Call_3C01
	jr c, jr_005_6555

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $14
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c4

jr_005_6555:
	ret


	db $f8, $08, $f8, $08, $fc, $fc, $04, $04, $f4, $0c, $f4, $0c, $f4, $f4, $0c, $0c

Call_05_6566::
	ld a, $04

jr_005_6568:
	ldh [hBGTilesRequestCopy], a
	ld a, $62
	call Call_3C01
	jr c, jr_005_65b4

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	push bc
	ldh a, [hBGTilesRequestCopy]
	ld c, a
	ld hl, $6555
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $6559
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, $655d
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $6561
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	pop bc
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $13
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $42

jr_005_65b4:
	ldh a, [hBGTilesRequestCopy]
	dec a
	jr nz, jr_005_6568

	ret


	db $f0, $f8, $60, $00, $f0, $00, $62, $00, $f0, $08, $64, $00, $f0, $10, $66, $00
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $68, $20
	db $f0, $f8, $66, $20, $f0, $00, $64, $20, $f0, $08, $62, $20, $f0, $10, $60, $20
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $68, $20
	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $08, $6e, $20, $00, $10, $6c, $20
	db $00, $fc, $7c, $00, $00, $04, $7e, $00, $00, $0c, $7c, $20, $00, $00, $ff, $00
	db $00, $fc, $7c, $00, $00, $04, $7e, $20, $00, $0c, $7c, $20, $00, $00, $ff, $00
	db $00, $f8, $74, $00, $00, $00, $76, $00, $00, $08, $76, $20, $00, $10, $74, $20
	db $00, $f8, $70, $00, $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $70, $20
	db $0a, $fb, $26, $00, $0a, $01, $26, $00, $0a, $06, $26, $00, $0a, $0c, $26, $00

Call_05_665A::
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nc, Call_05_66AC

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $65ba
	add hl, de
	ld c, $08
	call Call_3D26
	nop

Call_05_667F::
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nc, jr_005_66ab

	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	dec a
	cp $08
	jr c, jr_005_66ab

	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ldh a, [hActiveEntityY]
	ldh [hActiveEntityDrawY], a
	xor a
	ldh [hActiveEntitySpriteVariant], a
	ld hl, $664a
	ld c, $04
	call Call_3D26
	call Call_3DBA

jr_005_66ab:
	ret


Call_05_66AC::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ldh a, [hActiveEntitySpriteVariant]
	dec a
	dec a
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $65fa
	add hl, de
	ld c, $04
	call Call_3D26
	call Call_05_667F
	ret


Jump_005_66cf:
	call GetEntityTimer
	jp z, ClearEntityStatus_05

	cp $0a
	ld a, $05
	jr c, jr_005_66dc

	inc a

jr_005_66dc:
	ldh [hActiveEntitySpriteVariant], a
	call Call_05_66AC
	ret


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $7a, $00, $7a, $20, $78, $00, $78, $20

Jump_005_66f2:
	ld de, $66e2
	call Call_3C3B
	call ReturnIfNonInteractive_05
	call Call_3BBF
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_6701::
	dw Jump_05_6705
	dw Jump_05_672D

Jump_05_6705::
	call UpdateEntityPosWithSpeed_05
	call AddEntityZSpeedToPos_05
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6722

	ld [hl], b
	call Call_3B8D
	call GetEntityTimer
	ld [hl], $0f

jr_005_6722:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_05_672D::
	call GetEntityTimer
	jp z, ClearEntityStatus_05

	rra
	rra
	rra
	and $01
	inc a
	inc a
	call Call_3B87
	ret


	db $6c, $00, $6e, $00, $6e, $20, $6c, $20

Jump_005_6746:
	ld de, $673e
	call Call_3C3B
	call ReturnIfNonInteractive_05
	call UpdateEntityPosWithSpeed_05
	call AddEntityZSpeedToPos_05
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6775

	xor a
	ld [hl], a
	call GetEntityTimer
	ld [hl], $0f
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $02
	ld a, $ff
	call Call_3B87

jr_005_6775:
	ret


	db $21, $60, $c4, $09, $5e, $cb, $23, $cb, $23, $cb, $23, $cb, $23, $cb, $23, $cb
	db $23, $50, $21, $00, $d0, $19, $d5, $1e, $20, $af, $22, $1d, $7b, $fe, $00, $20
	db $f8, $d1, $21, $00, $d1, $19, $1e, $20, $af, $22, $1d, $7b, $fe, $00, $20, $f8
	db $21, $50, $c2, $09, $36, $06, $cd, $91, $08, $36, $40, $cd, $8c, $08, $36, $40
	db $21, $b0, $c3, $09, $36, $03, $c9, $06, $fa, $00, $00, $00, $00, $fa, $06, $02
	db $01, $00, $01, $21, $22, $23, $22

Call_05_67CD::
	ldh a, [hMapId]
	cp $07
	jr nz, jr_005_67d7

	ld a, $10
	ldh [$fff5], a

jr_005_67d7:
	call Call_05_699A
	call ReturnIfNonInteractive_05
	call Call_3F12
	call DecrementEntityIgnoreHitsTimer
	call Call_3BB4
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_67E9::
	dw Jump_05_67EF
	dw Jump_05_68B5
	dw Jump_05_690F

Jump_05_67EF::
	call GetEntityTimer
	jr nz, jr_005_67f9

	ld [hl], $00
	call Call_3B8D

jr_005_67f9:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	and $3f
	ld [hl], a
	ldh [hMultiPurpose0], a
	rra
	rra
	nop
	and $03
	ld e, a
	ld d, $00
	ld hl, $67c5
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ld hl, $67c9
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
	sla e
	sla e
	sla e
	ld d, $00
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
	ldh a, [hActiveEntityX]
	ld [hl], a
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	ld e, a
	add hl, de
	ldh a, [hActiveEntityDrawY]
	ld [hl], a
	call UpdateEntityPosWithSpeed_05
	call Call_3B9E
	ld e, $0f
	ld d, b

jr_005_6854:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_005_68b1

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_005_68b1

	ld hl, wEntityTimer
	add hl, de
	ld a, [hl]
	cp $38
	jr c, jr_005_68b1

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_005_68b1

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_005_68b1

	ld hl, wEntityZ
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_005_68b1

	ld hl, wEntityStatus
	add hl, de
	ld [hl], b
	call Call_3B8D
	ld [hl], $02
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $60
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $0c
	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ld a, $2a
	ldh [hJingle], a
	ret


jr_005_68b1:
	dec e
	jr nz, jr_005_6854

	ret


Jump_05_68B5::
	call GetEntityTimer
	jr nz, jr_005_68fe

	call GetRandomByte
	and $1f
	add $40
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
	jr nz, jr_005_68d6

	call GetEntityDirectionToLink_05
	jr jr_005_68dc

jr_005_68d6:
	call GetRandomByte
	and $03
	ld e, a

jr_005_68dc:
	ld hl, hActiveEntitySpriteVariant
	xor [hl]
	and $02
	jr z, jr_005_68d6

	ld d, b
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], e
	ld hl, $67bd
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $67c1
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_005_68fe:
	ret


	db $f3, $0d, $00, $00, $00, $00, $0d, $f3, $0c, $f4, $00, $00, $00, $00, $f4, $0c

Jump_05_690F::
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_6922

	call GetEntityTimer
	ld [hl], $30
	call Call_3B8D
	ld [hl], $01
	ret


jr_005_6922:
	cp $24
	jr nz, jr_005_6929

	call PlayClinkNoise

jr_005_6929:
	cp $04
	jr nz, jr_005_6949

	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $6907
	add hl, de
	ldh a, [hActiveEntityX]
	add [hl]
	ldh [hMultiPurpose0], a
	ld hl, $690b
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	xor a

jr_005_6949:
	cp $20
	jr nz, jr_005_6985

	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_005_6985

	ld a, $02
	call Call_3C01
	jr c, jr_005_6985

	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
	push bc
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld c, [hl]
	ld hl, $68ff
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $6903
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	pop bc
	call Call_05_7DC0

jr_005_6985:
	ret


	db $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20, $60, $00, $60, $20
	db $68, $00, $68, $20

Call_05_699A::
	call GetEntityTimer1
	ld hl, wRoomTransitionState
	or [hl]
	ld hl, wEntityTimer2
	add hl, bc
	or [hl]
	jp nz, Jump_005_6bda

	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nz, jr_005_69b8

	call Call_05_6A08
	call Call_05_69C1
	jp Call_3DBA


jr_005_69b8:
	call Call_05_69C1
	call Call_05_6A08
	jp Call_3DBA


Call_05_69C1::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	push bc
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	ld c, [hl]
	sla e
	sla e
	sla e
	sla e
	sla e
	sla e
	ld d, b
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	pop bc
	ld de, $6986
	call Call_3C3B
	ret


Call_05_6A08::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
	push bc
	ld hl, wEntityLoadOrder
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld c, [hl]
	sla e
	sla e
	sla e
	sla e
	sla e
	sla e
	ld d, b
	push de
	ld hl, wEntityWorkRAM
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
	pop de
	ld hl, wEntityWorkRAM2
	add hl, de
	ldh a, [hMultiPurpose0]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	pop bc
	ld a, $04
	ldh [hActiveEntitySpriteVariant], a
	ld de, $6986
	call Call_3C3B
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ret


	db $00, $00, $66, $20, $00, $08, $64, $20, $00, $f3, $68, $00, $00, $fb, $68, $20
	db $00, $00, $64, $00, $00, $08, $66, $00, $00, $0d, $68, $00, $00, $15, $68, $20
	db $00, $00, $62, $00, $00, $08, $62, $20, $0d, $00, $68, $00, $0d, $08, $68, $20
	db $00, $00, $60, $00, $00, $08, $60, $20, $f3, $00, $68, $00, $f3, $08, $68, $20
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

Jump_005_6bda:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	cp $08
	jr c, jr_005_6c12

	cp $28
	jr nc, jr_005_6c12

	ld hl, $6b3a
	cp $0e
	jr c, jr_005_6bf5

	cp $22
	jr nc, jr_005_6bf5

	ld hl, $6a9a

jr_005_6bf5:
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	sla e
	sla e
	sla e
	ld a, e
	sla e
	sla e
	add e
	ld e, a
	add hl, de
	ld c, $0a
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


jr_005_6c12:
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $6a5a
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ret


	db $cd, $91, $08, $36, $80, $af, $ea, $00, $d2, $ea, $03, $d2, $ea, $04, $d2, $21
	db $90, $c3, $09, $36, $01, $c9

Call_05_6C41::
	call Call_380E
	call Call_3F12
	call DecrementEntityIgnoreHitsTimer
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_6C50::
	dw Jump_05_6C56
	dw Jump_05_7207
	dw Jump_05_74F9

Jump_05_6C56::
	ld a, c
	ld [wSmasherBallSlot], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_6C5D::
	dw Jump_05_6C65
	dw Jump_05_6CA9
	dw Jump_05_6D95
	dw Call_05_700B

Jump_05_6C65::
	call GetEntityTimer
	jr nz, jr_005_6c80

	ld [hl], $80
	ld a, $ff
	ld [wBumpShakeTimer], a
	ld a, $3e
	ldh [hNoiseSfx], a
	ld [$d3e8], a
	ld a, $04
	ld [wBumpShakeAxis], a
	call Call_3B8D

jr_005_6c80:
	ret


	db $20, $60, $20, $60, $00, $00, $70, $70, $08, $08, $08, $08, $09, $0b, $0b, $0a
	db $08, $08, $08, $08, $09, $0b, $0b, $0a, $05, $07, $07, $06, $04, $04, $04, $04
	db $05, $07, $07, $06, $04, $04, $04, $04

Jump_05_6CA9::
	ld a, $38
	ldh [hBGPosX], a
	add $10
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld a, $30
	ldh [hBGPosY], a
	add $18
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	call GetEntityTimer
	jp nz, Jump_005_6d48

	ld [hl], $ff
	xor a
	ld [$d3e8], a
	call Call_3B8D
	ld a, $af
	ld [$d745], a
	ld a, $af
	ld [$d746], a
	ld a, $b0
	ld [$d755], a
	ld a, $b0
	ld [$d756], a
	call GetEntityTimer1
	ld [hl], $1f
	call GetEntityDropTimer
	ld [hl], $b0
	call Call_3E64
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	call Call_3E64
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
	call Call_3E64
	call PlayClinkNoise
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $1c
	ld [wDrawCommandsSize], a
	call Call_05_6D2D
	call Call_05_6D2D
	call Call_05_6D2D

Call_05_6D2D::
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $76
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $77
	ld [hli], a
	xor a
	ld [hl], a
	ret


Jump_005_6d48:
	cp $40
	jp nz, Jump_005_6d94

	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $1c
	ld [wDrawCommandsSize], a
	call Call_05_6D62

Call_05_6D62::
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ld a, $1e
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ld a, $1e
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ldh [hBGAddrLow], a
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $1d
	ld [hli], a
	ld a, $1f
	ld [hli], a
	ld a, $1d
	ld [hli], a
	ld a, $1f
	ld [hli], a
	xor a
	ld [hl], a

Jump_005_6d94:
	ret


Jump_05_6D95::
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	push af
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push af
	call Call_05_700B
	pop af
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	pop af
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	call Call_3DBA
	call GetEntityTimer
	jr nz, jr_005_6dbc

	call Call_3B8D
	ret


jr_005_6dbc:
	cp $98
	jr z, jr_005_6dcd

	cp $68
	jr z, jr_005_6dcd

	cp $38
	jr z, jr_005_6dcd

	cp $08
	jp nz, Jump_005_6ea8

jr_005_6dcd:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $04
	jp z, Jump_005_6ea8

	inc [hl]
	ld e, a
	ld d, b
	ld hl, $6c81
	add hl, de
	ld a, [hl]
	ldh [hBGPosX], a
	ld hl, $6c85
	add hl, de
	ld a, [hl]
	ldh [hBGPosY], a
	sla e
	sla e
	sla e
	ld hl, $6c89
	add hl, de
	push hl
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0e
	ld [wDrawCommandsSize], a
	pop de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $03
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
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
	add $20
	ld [hli], a
	ld a, $03
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hl], a
	ld a, $d5
	ld [$d713], a
	ld [$d717], a
	ld a, $d6
	ld [$d714], a
	ld [$d718], a
	ld a, $d7
	ld [$d783], a
	ld [$d787], a
	ld a, $d8
	ld [$d784], a
	ld [$d788], a
	ld a, $5d
	call Call_3C01
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $10
	ld [hl], a
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	add $08
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $2f
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $03
	ld a, $00
	jr c, jr_005_6e97

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	ld a, $01

jr_005_6e97:
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	call Call_3E64
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $05
	call PlayClinkNoise

Jump_005_6ea8:
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
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff, $00, $00, $01, $02, $03, $04, $04, $04
	db $04, $04, $04, $03, $02, $01, $00, $00, $00, $00, $ff, $fe, $fd, $fc, $fc, $fc
	db $fc, $fc, $fc, $fd, $fe, $ff, $00, $00, $00, $00, $01, $01, $02, $02, $03, $03
	db $03, $03, $03, $02, $02, $01, $01, $00, $00, $00, $ff, $ff, $fe, $fe, $fd, $fd
	db $fd, $fd, $fd, $fe, $fe, $ff, $ff, $00, $00, $00, $01, $01, $01, $02, $02, $02
	db $02, $02, $02, $02, $01, $01, $01, $00, $00, $00, $ff, $ff, $ff, $fe, $fe, $fe
	db $fe, $fe, $fe, $fe, $ff, $ff, $ff, $00, $00, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $49, $6f, $21, $6f, $f9, $6e, $d1, $6e
	db $a9, $6e, $04, $03, $02, $01, $30, $70, $30, $70, $10, $10, $80, $80, $00, $00
	db $01, $01

Call_05_700B::
	call GetEntityDropTimer
	ld a, [$d200]
	and a
	jr z, jr_005_7016

	ld [hl], $20

jr_005_7016:
	ld a, [hl]
	and a
	jr nz, jr_005_7071

	ld [hl], $2c
	ld a, $5d
	call Call_3C01
	jr c, jr_005_7071

	ld hl, wEntityHealth
	add hl, de
	ld [hl], $ff
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $ff
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
	push bc
	call GetRandomByte
	and $03
	ld c, a
	ld hl, $6fff
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate2
	add hl, de
	ld [hl], a
	ld hl, $7003
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $5f
	ld hl, $7007
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	pop bc

jr_005_7071:
	call GetEntityTimer1
	jr z, jr_005_7087

	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $6ffb
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a

jr_005_7087:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and $07
	ld hl, $d200
	or [hl]
	jr nz, jr_005_70a8

	ldh a, [hActiveEntityState]
	cp $03
	jr nz, jr_005_70a8

	ld hl, wEntityPrivate5
	add hl, bc
	ld e, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	add e
	and $1f
	ld [hl], a

jr_005_70a8:
	ld a, [$d200]
	and a
	ld a, $00
	jr nz, jr_005_70ba

	ld hl, wEntityPrivate4
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	and $1f

jr_005_70ba:
	ldh [hBGTilesRequestCopy], a
	ld hl, wEntityX
	add hl, bc
	ld [hl], $50
	ld hl, wEntityY
	add hl, bc
	ld [hl], $48
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, $6f71
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	sla e
	ld d, b
	ld hl, $6ff1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, $02
	call Call_05_71A3
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, $6f91
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
	ld a, e
	cp $f0
	jp nc, Jump_005_71ea

	sla e
	ld d, b
	ld hl, $6ff1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, $01
	call Call_05_71A3
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, $6fb1
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
	dec e
	ld a, e
	cp $f0
	jp nc, Jump_005_71ea

	sla e
	ld d, b
	ld hl, $6ff1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, $01
	call Call_05_71A3
	ldh a, [hBGTilesRequestCopy]
	ld e, a
	ld d, b
	ld hl, $6fd1
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
	dec e
	dec e
	ld a, e
	cp $f0
	jp nc, Jump_005_71ea

	sla e
	ld d, b
	ld hl, $6ff1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, $01
	call Call_05_71A3
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
	push de
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	dec e
	dec e
	dec e
	dec e
	ld a, e
	cp $f0
	jp nc, Jump_005_71ea

	sla e
	ld d, b
	ld hl, $6ff1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	ld a, $00

Call_05_71A3::
	ldh [hActiveEntitySpriteVariant], a
	add hl, de
	ld a, $48
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a
	ld a, $50
	add [hl]
	ldh [hActiveEntityX], a
	call Call_05_7200
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

	ld a, [wLinkMotionState]
	and a
	jr nz, jr_005_71e9

	call Call_3B93
	ld a, $18
	call Call_3C30
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a

jr_005_71e9:
	ret


Jump_005_71ea:
	pop de
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $7c, $00, $7c, $20
	db $7e, $00, $7e, $20

Call_05_7200::
	ld de, $71ec
	call Call_3C3B
	ret


Jump_05_7207::
	call Call_05_78AC
	call ReturnIfNonInteractive_05
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_7210::
	dw Jump_05_7226
	dw Jump_05_7285
	dw Jump_05_7348
	dw Jump_05_73D5
	dw Jump_05_7460

	db $09, $0a, $0b, $0b, $0b, $0b, $0c, $0d, $0e, $0e, $0e, $0e

Jump_05_7226::
	call GetEntityTimer
	jp z, Call_05_7459

	ld e, a
	cp $18
	jr nz, jr_005_7235

	ld a, $16
	ldh [hWaveSfx], a

jr_005_7235:
	ld a, e
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld hl, $721a
	jr z, jr_005_724b

	ld hl, $7220

jr_005_724b:
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $09, $09, $0a, $0a, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0a, $0a, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $0c, $0c, $0d, $0d, $0e, $0e, $0e, $0e
	db $0e, $0e, $0e, $0e, $0d, $0d, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
	db $18, $d8, $04, $0c

Jump_05_7285::
	call GetEntityTimer
	jp z, Call_05_7459

	ld e, a
	cp $20
	jr nz, jr_005_7294

	ld a, $16
	ldh [hWaveSfx], a

jr_005_7294:
	ld a, e
	rra
	rra
	and $1f
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld hl, $7251
	jr z, jr_005_72a9

	ld hl, $7269

jr_005_72a9:
	add hl, de
	ld a, [hl]
	call Call_3B87
	cp $0b
	jr z, jr_005_72b7

	cp $0e
	jp nz, Jump_005_7347

jr_005_72b7:
	ldh a, [hLinkDirection]
	and $02
	jp z, Jump_005_7347

	ld a, [wHookshotChainSlot]
	and a
	jp z, Jump_005_7347

	dec a
	ld [wSmasherSlot], a
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7347

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_005_7347

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_7347

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_005_7347

	ld a, [$d203]
	inc a
	ld [$d203], a
	cp $04
	jr c, jr_005_7337

	call GetRandomByte
	and $01
	jr nz, jr_005_7337

	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $02
	call GetEntityDropTimer
	ld [hl], $30
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $20
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7281
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $7283
	add hl, de
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	ld [hl], a
	call Call_05_76A1
	ret


jr_005_7337:
	call Call_3B8D
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate5
	add hl, de
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

Jump_005_7347:
jr_005_7347:
	ret


Jump_05_7348::
	call Call_05_78D2
	ld a, $01
	ld [$d200], a
	ld a, [wSmasherSlot]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_739c

	ld a, [wInvincibilityCounter]
	and a
	jr nz, jr_005_739c

	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	cp $00
	jr z, jr_005_7382

	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_005_7382

	dec [hl]

jr_005_7382:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_738c

	ld a, $29
	ldh [hJingle], a

jr_005_738c:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $00
	jr z, jr_005_7398

	ld a, $01

jr_005_7398:
	call Call_3B87
	ret


jr_005_739c:
	call Call_3B8D
	call GetEntityTimer
	ld [hl], $5f
	ret


	db $10, $10, $0c, $08, $04, $03, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $03, $1f, $1f, $3f, $3f, $3f, $3f, $3f
	db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

Jump_05_73D5::
	call Call_05_78D2
	ld a, $01
	ld [$d200], a
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	ld a, $08
	jr z, jr_005_73e9

	ld a, $0f

jr_005_73e9:
	call Call_3B87
	ldh a, [hLinkX]
	push af
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
	ldh a, [hLinkY]
	push af
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
	call GetEntityTimer
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $73a5
	add hl, de
	ld a, [hl]
	call Call_3C30
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call UpdateEntityPosWithSpeed_05
	ldh a, [hLinkY]
	ld hl, hActiveEntityDrawY
	sub [hl]
	add $03
	cp $06
	jr nc, jr_005_7431

	call Call_05_7459

jr_005_7431:
	pop af
	ldh [hLinkY], a
	pop af
	ldh [hLinkX], a
	call GetEntityTimer
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $73bd
	add hl, de
	ldh a, [hFrameCounter]
	and [hl]
	jr nz, jr_005_7458

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	cp $04
	jr z, jr_005_7458

	inc [hl]

jr_005_7458:
	ret


Call_05_7459::
	xor a
	ld [$d200], a
	jp ClearEntityStatus_05


Jump_05_7460::
	call Call_05_78D2
	call GetEntityTimer
	jp z, Call_05_74AD

	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_005_7475

	call Call_05_7476

jr_005_7475:
	ret


Call_05_7476::
	and $07
	jr nz, jr_005_7497

	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	call Call_05_7498

jr_005_7497:
	ret


Call_05_7498::
	call ReturnIfPaused_05
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $02
	call AddTransientVfx
	ld a, $13
	ldh [hNoiseSfx], a
	ret


Call_05_74AD::
	ld a, $36
	call Call_3C01
	jr jr_005_74c1

Jump_005_74b4:
	ld a, $36
	call Call_3C01
	ld a, $48
	ldh [hMultiPurpose0], a
	ld a, $10
	ldh [hMultiPurpose1], a

jr_005_74c1:
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_005_74dc

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr jr_005_74e8

jr_005_74dc:
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08

jr_005_74e8:
	call ClearEntityStatus_05
	ld hl, hNoiseSfx
	ld [hl], $1a
	ret


	db $03, $05, $00, $04, $02, $06, $01, $07

Jump_05_74F9::
	call Call_05_7597
	call Call_3DBA
	call ReturnIfNonInteractive_05
	ld a, $01
	ld [$d200], a
	call GetEntityDropTimer
	cp $10
	jr nc, jr_005_7549

	and a
	jr nz, jr_005_7541

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $1f
	ld a, $02
	call Call_3C01
	call PlayClinkNoise
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
	jp Call_05_7459


jr_005_7541:
	ldh a, [hFrameCounter]
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], a
	ret


jr_005_7549:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_005_755d

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityPrivate3
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_755d

	dec [hl]

jr_005_755d:
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
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7583

	call UpdateEntityPosWithSpeed_05
	jr jr_005_7586

jr_005_7583:
	call Call_05_762C

jr_005_7586:
	ld hl, wEntityState
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, $74f1
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Call_05_7597::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $76ac
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
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
	ld de, $71ec
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
	ld de, $71ec
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
	ld a, $02
	ldh [hActiveEntitySpriteVariant], a
	ld de, $71ec
	call Call_3C3B
	ret


	db $00, $06, $0c, $0e, $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e

Call_05_762C::
	call UpdateEntityPosWithSpeed_05
	call Call_3BBF
	call Call_3B9E
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_765a

	call GetRandomByte
	rra
	jr c, jr_005_764b

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_005_764b:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	add $08
	and $0f
	ld [hl], a
	call GetEntityTimer
	ld [hl], $10

jr_005_765a:
	call GetEntityTimer1
	jr nz, jr_005_7688

	ld [hl], $04
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityState
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, wEntityState
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7618
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $761c
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

jr_005_7688:
	call GetEntityTimer
	jr nz, jr_005_76a0

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

jr_005_76a0:
	ret


Call_05_76A1::
	ld e, $80
	ld hl, wEntityWorkRAM2

jr_005_76a6:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_005_76a6

	ret


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

Call_05_78AC::
	ldh a, [hActiveEntitySpriteVariant]
	ld d, b
	rla
	rl d
	rla
	rl d
	rla
	rl d
	rla
	rl d
	rla
	rl d
	and $e0
	ld e, a
	ld hl, $76ac
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $f2, $0e

Call_05_78D2::
	ldh a, [hFrameCounter]
	and $10
	ld a, $03
	jr z, jr_005_78db

	inc a

jr_005_78db:
	ldh [hActiveEntitySpriteVariant], a
	nop

jr_005_78de:
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $78d0
	add hl, de
	ld a, [hl]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	cp $14
	jr c, jr_005_794a

	cp $7c
	jr nc, jr_005_794a

	ld de, $71ec
	call Call_3C3B
	ldh a, [hActiveEntityState]
	cp $04
	jr nc, jr_005_7948

	ldh a, [hActiveEntitySpriteVariant]
	and a
	jr z, jr_005_7945

	xor a
	ldh [hActiveEntitySpriteVariant], a
	call Call_3BEB
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, jr_005_7945

	ld hl, wTarinSlot
	inc [hl]
	ld a, [hl]
	cp $08
	jr nz, jr_005_7945

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityStatus
	add hl, de
	ld [hl], b
	call Call_3B8D
	ld [hl], $04
	call GetEntityTimer
	ld [hl], $ff
	call ResetSoundEngine
	ld a, $03
	ld [$c5a7], a
	ld a, $5e
	ld [wMusicTrackToPlay], a
	ld a, $b5
	call OpenDialog

jr_005_7945:
	call Call_3BBF

jr_005_7948:
	jr jr_005_78de

jr_005_794a:
	call Call_3DBA
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_7964

	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $c0
	call Call_3BEB
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $80

jr_005_7964:
	ret


ReturnIfNonInteractive_05::
	ldh a, [hActiveEntityStatus]
	cp $05
	jr nz, jr_005_7985

ReturnIfPaused_05::
	ld a, [wGameplayType]
	cp $07
	jr z, jr_005_7985

	ld hl, wLinkShowItemPoseActive
	ld a, [wDialogState]
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, jr_005_7985

	ld a, [wRoomTransitionState]
	and a
	jr z, jr_005_7986

jr_005_7985:
	pop af

jr_005_7986:
	ret


ApplyRecoilIfNeeded_05::
	db $21, $10, $c4, $09, $7e, $a7, $28, $41, $3d, $77, $cd, $b8, $3e, $21, $40, $c2
	db $09, $7e, $f5, $21, $50, $c2, $09, $7e, $f5, $21, $f0, $c3, $09, $7e, $21, $40
	db $c2, $09, $77, $21, $00, $c4, $09, $7e, $21, $50, $c2, $09, $77, $cd, $d1, $79
	db $21, $30, $c4, $09, $7e, $e6, $20, $20, $03, $cd, $9e, $3b, $21, $50, $c2, $09
	db $f1, $77, $21, $40, $c2, $09, $f1, $77, $f1, $c9

UpdateEntityPosWithSpeed_05::
	call AddEntitySpeedToPosX_05

AddEntitySpeedToPosY_05::
	push bc
	ld a, c
	add $10
	ld c, a
	call AddEntitySpeedToPosX_05
	pop bc
	ret


AddEntitySpeedToPosX_05::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7a09

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityX

jr_005_79f6:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_005_7a00

	ld e, $f0

jr_005_7a00:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_005_7a09:
	ret


AddEntityZSpeedToPos_05::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7a09

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityZ
	jr jr_005_79f6

EntityLinkDiffX_05::
	ld e, $00
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_005_7a32

	inc e

jr_005_7a32:
	ld d, a
	ret


EntityLinkDiffY_05::
	ld e, $02
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_005_7a42

	inc e

jr_005_7a42:
	ld d, a
	ret


GetEntityDirectionToLink_05::
	call EntityLinkDiffX_05
	ld a, e
	ldh [hMultiPurpose0], a
	ld a, d
	bit 7, a
	jr z, jr_005_7a51

	cpl
	inc a

jr_005_7a51:
	push af
	call EntityLinkDiffY_05
	ld a, e
	ldh [hMultiPurpose1], a
	ld a, d
	bit 7, a
	jr z, jr_005_7a5f

	cpl
	inc a

jr_005_7a5f:
	pop de
	cp d
	jr nc, jr_005_7a67

	ldh a, [hMultiPurpose0]
	jr jr_005_7a69

jr_005_7a67:
	ldh a, [hMultiPurpose1]

jr_005_7a69:
	ld e, a
	ret


ClearEntityStatus_05::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


	db $10, $f0, $18, $e8, $00, $f0, $64, $00, $00, $f8, $66, $00, $00, $00, $60, $00
	db $00, $08, $60, $20, $00, $10, $6a, $20, $00, $18, $68, $20, $00, $f0, $6c, $00
	db $00, $f8, $6e, $00, $00, $00, $60, $00, $00, $08, $60, $20, $00, $10, $6e, $20
	db $00, $18, $6c, $20, $00, $f0, $68, $00, $00, $f8, $6a, $00, $00, $00, $60, $00
	db $00, $08, $60, $20, $00, $10, $66, $20, $00, $18, $64, $20, $00, $f0, $64, $00
	db $00, $f8, $66, $00, $00, $00, $62, $00, $00, $08, $62, $20, $00, $10, $6a, $20
	db $00, $18, $68, $20, $00, $f0, $6c, $00, $00, $f8, $6e, $00, $00, $00, $62, $00
	db $00, $08, $62, $20, $00, $10, $6e, $20, $00, $18, $6c, $20, $00, $f0, $68, $00
	db $00, $f8, $6a, $00, $00, $00, $62, $00, $00, $08, $62, $20, $00, $10, $66, $20
	db $00, $18, $64, $20

Call_05_7B05::
	ld a, [wOcarinaSongState]
	cp $01
	jr nz, jr_005_7b16

	call Call_05_7BF5
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a

jr_005_7b16:
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	and $f8
	ld c, a
	rla
	and $f0
	add c
	ld e, a
	ld d, b
	ld hl, $7a75
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ldh a, [hActiveEntityStatus]
	cp $05
	jp nz, BossDefeatedHandler_05

	call ReturnIfNonInteractive_05
	call Call_3F12
	call Call_3BB4
	call UpdateEntityPosWithSpeed_05
	call Call_3B9E
	call DecrementEntityIgnoreHitsTimer
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_05_7B4E::
	dw Jump_05_7B56
	dw Jump_05_7B72
	dw Jump_05_7C83
	dw Jump_05_7D2B

Jump_05_7B56::
	call GetRandomByte
	and $01
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7a71
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ld [hl], $01
	ret


Jump_05_7B72::
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	call GetEntityTimer1
	jp nz, Jump_005_7c09

	call GetEntityTimer
	jr z, jr_005_7ba9

	cp $01
	jr nz, jr_005_7bbc

	call EntityLinkDiffX_05
	ld d, b
	ld hl, $7a73
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	call GetEntityTimer1
	call GetRandomByte
	and $3f
	add $60
	ld [hl], a
	jp Jump_005_7c09


jr_005_7ba9:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, hLinkY
	cp [hl]
	jp c, Jump_005_7bd3

	call GetEntityTimer
	ld [hl], $60

jr_005_7bbc:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, jr_005_7bce

	ld [hl], $08
	jp Jump_005_7c61


jr_005_7bce:
	ld [hl], $f8
	jp Jump_005_7c61


Jump_005_7bd3:
	ld hl, wEntityY
	add hl, bc
	ldh a, [hLinkY]
	sub [hl]
	cp $28
	jr nc, jr_005_7c09

	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_7c09

	call GetRandomByte
	and $7f
	add $40
	ld [hl], a
	and $03
	jr z, jr_005_7c42

	dec a
	jr nz, jr_005_7c09

Call_05_7BF5::
	call Call_3B8D
	ld [hl], $03
	call Call_3DAF
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $40
	ld a, $01
	call Call_05_7C80
	ret


Jump_005_7c09:
jr_005_7c09:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_005_7c2a

	call GetEntityTimer1
	jr z, jr_005_7c22

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jp Jump_005_7c61


jr_005_7c22:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_005_7c2a:
	call GetEntityTimer1
	jr nz, jr_005_7c61

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $7a71
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	jr jr_005_7c69

jr_005_7c42:
	call GetEntityTimer
	ld [hl], $60
	call GetEntityTimer1
	ld [hl], b
	call Call_3B8D
	ld [hl], $02
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a
	jr jr_005_7c69

Jump_005_7c61:
jr_005_7c61:
	ldh a, [hFrameCounter]
	and $07
	jr z, jr_005_7c6f

	jr jr_005_7c7b

jr_005_7c69:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_005_7c7b

jr_005_7c6f:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_005_7c7b

	ld [hl], $00

jr_005_7c7b:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]

Call_05_7C80::
	jp Call_3B87


Jump_05_7C83::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_005_7cfd

	call GetEntityTimer
	cp $02
	jr nc, jr_005_7ced

	cp $00
	jr z, jr_005_7cc9

	ld hl, hLinkY
	ld a, [hl]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $02
	jr z, jr_005_7cb3

	call Call_3DAF
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $10
	jp Jump_005_7cb8


jr_005_7cb3:
	ld a, $10
	call Call_3C25

Jump_005_7cb8:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, hLinkY
	cp [hl]
	jp nc, Jump_005_7d09

	jp Jump_005_7d11


jr_005_7cc9:
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	sub $08
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jp nc, Jump_005_7d11

	ld hl, wEntityPrivate1
	add hl, bc
	inc [hl]
	call Call_3DAF
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	ld a, $16
	ldh [hWaveSfx], a
	jp Jump_005_7d11


jr_005_7ced:
	ld hl, wEntitySpeedX
	add hl, bc
	and $04
	jr nz, jr_005_7cf9

	ld [hl], $08
	jr jr_005_7d11

jr_005_7cf9:
	ld [hl], $f8
	jr jr_005_7d11

Jump_005_7cfd:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, bc
	cp [hl]
	jr c, jr_005_7d11

Jump_005_7d09:
	call Call_3DAF
	call Call_3B8D
	ld [hl], $01

Jump_005_7d11:
jr_005_7d11:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_005_7d23

	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_005_7d23

	ld [hl], $00

jr_005_7d23:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	jp Call_3B87


Jump_05_7D2B::
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7d34

	ret


jr_005_7d34:
	call GetEntityTimer1
	cp $02
	jr nc, jr_005_7d5b

	cp $00
	jr z, jr_005_7d56

	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $80
	ld a, $01
	call Call_3B87
	call Call_3B8D
	ld [hl], $01
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $40
	ret


jr_005_7d56:
	call GetEntityTimer1
	ld [hl], $30

jr_005_7d5b:
	cp $18
	jr nz, jr_005_7d82

	ld a, $7d
	call Call_3C01
	jr c, jr_005_7d82

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
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_005_7d82:
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
	ld a, $04
	jp Call_3B87


BossDefeatedHandler_05::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

BossDefeatedStates_05::
	dw BossDefeated_Start_05
	dw BossDefeated_Flash_05
	dw BossDefeated_Explode_05

BossDefeated_Start_05::
	call GetEntityTimer
	ld [hl], $a0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff

IncrementEntityPrivate2_05::
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


BossDefeated_Flash_05::
	call GetEntityTimer
	jr nz, jr_005_7dba

	ld [hl], $c0
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
	call IncrementEntityPrivate2_05

jr_005_7dba:
	ret


BossDefeated_Explode_05::
	call GetEntityTimer
	jr nz, jr_005_7df8

Call_05_7DC0::
	ld a, $1a
	ldh [hNoiseSfx], a
	ldh a, [hActiveEntityType]
	cp $63
	jp z, Jump_005_74b4

	call Call_3F7A
	ld e, $0f
	ld d, b

jr_005_7dd1:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7de2

	ld hl, wEntityOptions1
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_005_7df0

jr_005_7de2:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_7dd1

	xor a
	ld [wRestoreMusicAfterTransition], a
	call SelectAreaMusicFar
	ret


jr_005_7df0:
	ldh a, [hMapId]
	cp $05
	ret nc

	jp Jump_005_7dfc


jr_005_7df8:
	call Call_05_7476
	ret


Jump_005_7dfc:
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_005_7e0b

	cp $06
	jr c, jr_005_7e0b

	inc d

jr_005_7e0b:
	ld hl, $d900
	add hl, de
	set 5, [hl]
	ret


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
