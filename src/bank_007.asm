; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

;@ def PlayNoiseSfx04()
;@ path: sound/sfx
;@ Requests noise sound effect 4.
PlayNoiseSfx04::
;> hNoiseSfx = 4
	ld a, $04
	ldh [hNoiseSfx], a
	ret


;@ path: enemy/bush_crawler
;@ Sprite frames of the bush crawler itself, drawn by DrawEntity16x16 as two 8x16 sprites side by side.
;@ 2 frames of 4 bytes: tile and attributes of the left half, then of the right half. Frame 1 is
;@ frame 0 mirrored (attribute bit 5 = flip x), so the crawler wiggles as it moves. Tiles $7C/$7E.
BushCrawlerSprites::
	db $7c, $00, $7e, $00, $7e, $20, $7c, $20

;@ path: enemy/bush_crawler
;@ Sprite frames of the cover the bush crawler hides under (same format as BushCrawlerSprites,
;@ palette OBP1): frame 0 = tiles $F4/$F6, frame 1 = tiles $F0/$F2. Which one a crawler uses
;@ (wEntityPrivate4) comes from bit 4 of its starting x position.
BushCrawlerCoverSprites::
	db $f4, $10, $f6, $10, $f0, $10, $f2, $10

;@ def BushCrawlerHandler(slot: c)
;@ path: enemy/bush_crawler
;@ Entity $BB, a small enemy that hides under a bush-like cover. While covered (wEntityPrivate1 = 1)
;@ it cannot be hurt; when Link is in its row, or in its column below it, the cover slides at him
;@ for $30 frames with the crawler peeking out (raised by wEntityPrivate2 = 4 pixels). Hitting the
;@ cover, or lifting it with the power bracelet, turns the cover into an ordinary liftable object
;@ (type $05) and releases the crawler as a second $BB entity in its uncovered form
;@ (wEntityPrivate1 = 2, BushCrawlerUncovered). Its health is kept at 4 while covered.
;@ test: skip draws sprites and calls entity engine routines in bank 3
BushCrawlerHandler::
;> if wEntityPrivate1[slot] == 2:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
;>     return BushCrawlerUncovered(slot)
	jp z, BushCrawlerUncovered
;> if wEntityPrivate1[slot] == 0:          # first frame
	and a
	jr nz, .draw
;>     wEntityPrivate1[slot] = 1
	inc [hl]
;>     flag = 0x40 if hActiveEntityX & 0x10 else 0
	ldh a, [hActiveEntityX]
	rla
	rla
	and $40
;>     wEntityOptions1[slot] |= flag
	push af
	ld hl, wEntityOptions1
	add hl, bc
	or [hl]
	ld [hl], a
;>     wEntityHitboxFlags[slot] |= flag << 1
	pop af
	sla a
	ld hl, wEntityHitboxFlags
	add hl, bc
	or [hl]
	ld [hl], a
;>     picture = (hActiveEntityX >> 4) & 1    # which cover picture
	ldh a, [hActiveEntityX]
	rra
	rra
	rra
	rra
	and $01
;>     wEntityPrivate4[slot] = picture
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], a
.draw
;> hActiveEntityDrawY -= wEntityPrivate2[slot]        # the cover is lifted while it dashes
	ld hl, wEntityPrivate2
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	ldh [hActiveEntityDrawY], a
;> hActiveEntitySpriteVariant = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(BushCrawlerCoverSprites)
	ld de, BushCrawlerCoverSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)                     # back to the real position
	call LoadEntityPosition
;> if wEntityPrivate2[slot] != 0:      # cover raised: draw the crawler under it
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .update
;>     hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(BushCrawlerSprites)
	ld de, BushCrawlerSprites
	call DrawEntity16x16
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wEntityHealth[slot] = 4
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $04
;> if wEntityFlashTimer[slot] != 0:      # the cover was hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .notHit
;>     wEntityFlashTimer[slot] = 0
	ld [hl], b
;>     SetEntitySpriteVariant(slot, wEntityPrivate4[slot] ^ 1)  # sprite variant of the plain object
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	xor $01
	call SetEntitySpriteVariant
;>     wEntityType[slot] = 0x05           # the cover becomes a plain liftable object
	ld hl, wEntityType
	add hl, bc
	ld [hl], $05
;>     hNoiseSfx = 0x05
	ld hl, hNoiseSfx
	ld [hl], $05
;>     wEntityTimer1[slot] = 0x1F
	call GetEntityTimer1
	ld [hl], $1f
;>     wEntityPhysicsFlags[slot] += 2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld a, [hl]
	add $02
	ld [hl], a
;>     return BushCrawlerSpawnCrawler()
	call BushCrawlerSpawnCrawler
	ret

.notHit
;> DecrementEntityIgnoreHitsTimer(slot)                     # count down the hit timer
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckHits()                         # touch damage / weapon hits
	call EntityCheckHits
;> return BushCrawlerStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/bush_crawler
;@ States of the covered bush crawler (wEntityState): 0 hidden, 1 dashing.
BushCrawlerStates::
	dw BushCrawler_Hidden
	dw BushCrawler_Dash

;@ path: enemy/bush_crawler
;@ x speed of the dash for each direction towards Link (0 right, 1 left, 2 up, 3 down), signed,
;@ 1/16 pixel per frame.
BushCrawlerDashSpeedX::
	db $10, $f0, $00, $00

;@ path: enemy/bush_crawler
;@ y speed of the dash for each direction towards Link (0 right, 1 left, 2 up, 3 down).
BushCrawlerDashSpeedY::
	db $00, $00, $f0, $10

;@ def BushCrawler_Hidden(slot: c)
;@ path: enemy/bush_crawler
;@ State 0: sits still under its cover, untouchable. When the rest time is over and Link is in the
;@ same row, or in the same column below, it dashes towards him for $30 frames. Meanwhile Link can
;@ lift the cover with the power bracelet (item 3) on A or B.
;@ test: skip calls entity engine routines in bank 3
BushCrawler_Hidden::
;> wEntityPrivate2[slot] = 0             # cover down
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .covered
;>     dy, ydir = EntityLinkDiffY(slot)
	call EntityLinkDiffY
;>     row = (dy + 8) & 0xFF < 0x10                 # Link in the same row
	add $08
	cp $10
;>     if not row:
	jr c, .dash
;>         dx, xdir = EntityLinkDiffX(slot)
	push de
	call EntityLinkDiffX
;>         column = (dx + 8) & 0xFF < 0x10 and ydir != 2   # same column, Link below
	add $08
	pop de
	cp $10
	jr nc, .covered
	ld a, e
	cp $02
;>     if row or column:
	jr z, .covered
.dash
;>         wEntityState[slot] += 1             # dash
	call IncrementEntityState
;>         dir = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
	ld d, b
;>         wEntitySpeedX[slot] = BushCrawlerDashSpeedX[dir]
	ld hl, BushCrawlerDashSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>         wEntitySpeedY[slot] = BushCrawlerDashSpeedY[dir]
	ld hl, BushCrawlerDashSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>         wEntityPhysicsFlags[slot] &= ~0x80   # can touch Link
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 7, [hl]
;>         wEntityHitboxFlags[slot] &= ~0x04
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 2, [hl]
;>         LoadEntityHitbox(slot)                      # set up the hitbox
	call LoadEntityHitbox
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         return
	ret

.covered
;> wEntityPhysicsFlags[slot] |= 0x80
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 7, [hl]
;> wEntityHitboxFlags[slot] |= 0x04
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 2, [hl]
;> LoadEntityHitbox(slot)
	call LoadEntityHitbox
;> if not EntityTouchesLink():                  # Link not up against the cover
	call EntityTouchesLink
;>     return
	ret nc
;> if mem[0xC19B]:                      # Link busy with an item
	ld a, [$c19b]
	and a
;>     return
	ret nz
;> if wItemB == 3:                      # power bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .tryA
;>     if not hJoypadPressed & 0x20:
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift
;>         return
	ret

;> else:
.tryA
;>     if wItemA != 3:
	ld a, [wItemA]
	cp $03
;>         return
	ret nz
;>     if not hJoypadPressed & 0x10:
	ldh a, [hJoypadPressed]
	and $10
;>         return
	jr z, BushCrawler_Return
.lift
;> if wLinkIsCarrying:
	ld a, [wLinkIsCarrying]
	and a
;>     return
	ret nz
;> wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> wEntityStatus[slot] = 7                # lifted
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
;> wEntityPrivate5[slot] = 1
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], $01
;> mem[0xC490 + slot] = 0
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
;> wEntityType[slot] = 0x05               # the cover becomes a plain liftable object
	ld hl, wEntityType
	add hl, bc
	ld [hl], $05
;> SetEntitySpriteVariant(slot, wEntityPrivate4[slot] ^ 1)
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	xor $01
	call SetEntitySpriteVariant
;> BushCrawlerSpawnCrawler()              # falls through

;@ def BushCrawlerSpawnCrawler()
;@ path: enemy/bush_crawler
;@ Spawns the uncovered bush crawler (entity $BB with wEntityPrivate1 = 2) where the cover is; it
;@ starts wandering after $40 frames.
;@ test: skip spawns an entity through bank 3
BushCrawlerSpawnCrawler::
;> new = SpawnEntity(0xBB)
	ld a, $bb
	call SpawnEntity
;> if new is None:                         # no free slot (carry)
;>     return
	ret c
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
;> wEntityPrivate1[new] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;> wEntityTimer[new] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
BushCrawler_Return:
	ret


;@ def BushCrawler_Dash(slot: c)
;@ path: enemy/bush_crawler
;@ State 1: the cover slides at Link with the crawler wiggling under it, until the time is up or it
;@ hits a wall; then it rests $20 frames hidden.
;@ test: skip calls entity engine routines in bank 3
BushCrawler_Dash::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr nz, .move
.stop
;=@s1
	call GetEntityTimer
	ld [hl], $20
;=@s2
	call IncrementEntityState
	ld [hl], b
	ret

.move
;>     UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;>     EntityCheckWalls()                           # stop at walls
	call EntityCheckWalls
;>     if not wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .stop
;>         wEntityPrivate2[slot] = 4             # cover raised 4 pixels
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $04
;>         SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)   # wiggle every 8 frames
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;>         return
	ret
;>@s1 wEntityTimer[slot] = 0x20          # time up or wall: rest hidden
;>@s2 wEntityState[slot] = 0


;@ path: enemy/bush_crawler
;@ Wander speeds of the uncovered bush crawler, read as a sine table: for direction d (0-7, in
;@ steps of 45 degrees) the y speed is byte d and the x speed is byte d + 2 (signed, 1/16 pixel per
;@ frame; $10 = 1 pixel, $0C on the diagonals).
BushCrawlerWanderSpeeds::
	db $f0, $f4, $00, $0c, $10, $0c, $00, $f4, $f0, $f4

;@ def BushCrawlerUncovered(slot: c)
;@ path: enemy/bush_crawler
;@ The released bush crawler (wEntityPrivate1 = 2): wiggles about in one of 8 directions, picking a
;@ new random direction every $20-$3F frames, and can be hit and knocked back.
;@ test: skip draws sprites and calls entity engine routines in bank 3
BushCrawlerUncovered::
;> DrawEntity16x16(BushCrawlerSprites)
	ld de, BushCrawlerSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()                         # walls
	call EntityCheckWalls
;> EntityCheckHits()                         # touch damage / weapon hits
	call EntityCheckHits
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     r = GetRandomByte()
	call GetRandomByte
;>     wEntityTimer[slot] = (r & 0x1F) + 0x20
	and $1f
	add $20
	ld [hl], a
;>     dir = wEntityTimer[slot] & 7
	and $07
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = BushCrawlerWanderSpeeds[dir + 2]
	ld hl, BushCrawlerWanderSpeeds + 2
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     speed_y = BushCrawlerWanderSpeeds[dir]
	ld hl, BushCrawlerWanderSpeeds
	add hl, de
	ld a, [hl]
;>     wEntitySpeedY[slot] = speed_y
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
.done
	ret


;@ path: npc/fisherman_under_bridge
;@ Sprite frames of the fisherman under the bridge, drawn by DrawFisherman with DrawEntitySprites. 5 frames
;@ of 4 sprites; each sprite is 4 bytes: y offset, x offset (signed, from the entity position),
;@ tile, attributes. 0 and 1 = sitting with the rod (head tiles $78/$7A or $7C/$7E), 2 = talking,
;@ 3 = pulling the line (raised 4 pixels, tiles $60-$66), 4 = pulling and talking.
FishermanSprites::
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $7c, $00, $00, $f8, $7e, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $fc, $f0, $64, $00, $fc, $f8, $66, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $fc, $f0, $64, $00, $fc, $f8, $66, $00, $00, $00, $74, $00, $00, $08, $76, $00

;@ def FishermanUnderBridgeHandler(slot: c)
;@ path: npc/fisherman_under_bridge
;@ Entity $B8, the fisherman who sits in a boat under the bridge (a side-view room). On the first
;@ frame he moves 8 pixels down and spawns his boat (a second $B8 with wEntityPrivate1 = 2,
;@ FishermanBoat). In the trading sequence he takes the fishing hook (trade item $0B), fishes and
;@ pulls out the necklace (trade item $0C). States (wEntityState): 0 idle, 1 answer, 2 fishing,
;@ 3 pulling out, 4 back to idle.
;@ test: skip spawns entities, draws sprites and opens dialogue through other banks
FishermanUnderBridgeHandler::
;> if wEntityPrivate1[slot] == 2:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
;>     return FishermanBoat(slot)
	jp z, FishermanBoat
;> if wEntityPrivate1[slot] == 0:           # first frame
	and a
	jr nz, .running
;>     wEntityPrivate1[slot] = 1
	inc [hl]
;>     wEntityY[slot] += 8
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
;>     boat = SpawnEntity(0xB8)               # spawn the boat
	ld a, $b8
	call SpawnEntity
;>     wEntityX[boat] = hMultiPurpose0 + 6
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	add $06
	ld [hl], a
;>     wEntityY[boat] = hMultiPurpose1 + 0x10
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $10
	ld [hl], a
;>     wEntityPrivate1[boat] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>     wEntityHitboxFlags[boat] = 0xAC
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $ac
;>     LoadEntityHitbox(boat)                      # set up the boat's hitbox
	push bc
	push de
	pop bc
	call LoadEntityHitbox
	pop bc
.running
;> if wDialogState:                         # talking frames while a box is open
	ld a, [wDialogState]
	and a
	jr z, .draw
;>     if hActiveEntitySpriteVariant == 3:
	ldh a, [hActiveEntitySpriteVariant]
	cp $03
	ld a, $02
	jr nz, .setFrame
;>         hActiveEntitySpriteVariant = 4  # pulling and talking
	ld a, $04
;>     else:
;>         hActiveEntitySpriteVariant = 2  # talking
.setFrame
	ldh [hActiveEntitySpriteVariant], a
.draw
;> DrawFisherman()
	call DrawFisherman
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> return FishermanStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/fisherman_under_bridge
;@ States of the fisherman under the bridge (wEntityState), see FishermanUnderBridgeHandler.
FishermanStates::
	dw Fisherman_Idle
	dw Fisherman_Answer
	dw Fisherman_Fishing
	dw Fisherman_PullOut
	dw Fisherman_Done

;@ def Fisherman_Idle(slot: c)
;@ path: npc/fisherman_under_bridge
;@ State 0: sits fishing. Talked to with the fishing hook (trade item $0B) he asks for it (text
;@ $E8, then state 1); before that he chats (text $E7), after the trade he says text $ED.
;@ test: skip opens dialogue through another bank
Fisherman_Idle::
;> if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, Fisherman_IdleAnimation
;>     if wTradeSequenceItem == 0x0B:       # the fishing hook
	ld a, [wTradeSequenceItem]
	cp $0b
	jr nz, .notHook
;>         OpenDialogTable1(0xE8)           # asks for the hook
	ld a, $e8
	call OpenDialogTable1
;>         return IncrementEntityState(slot)               # state 1: wait for the answer
	jp IncrementEntityState

.notHook
;>     if wTradeSequenceItem < 0x0C:
	cp $0c
	jr nc, .afterTrade
;>         return OpenDialogTable1(0xE7)
	ld a, $e7
	jp OpenDialogTable1

.afterTrade
;>     return OpenDialogTable1(0xED)
	ld a, $ed
	jp OpenDialogTable1

Fisherman_IdleAnimation:
;> frame = 1 if hFrameCounter & 0x30 else 0     # frame 0 for 16 of every 64 frames
	ldh a, [hFrameCounter]
	and $30
	ld e, b
	jr z, .frame0
	inc e
.frame0
;> return SetEntitySpriteVariant(slot, frame)
	ld a, e
	jp SetEntitySpriteVariant


;@ def Fisherman_Answer(slot: c)
;@ path: npc/fisherman_under_bridge
;@ State 1: if Link agreed to give the hook (first answer), freezes Link and fishes for $D0
;@ frames (text $E9, state 2); otherwise text $EA and back to idle.
;@ test: skip opens dialogue through another bank
Fisherman_Answer::
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer == 0:                   # "yes"
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>     mem[0xDB7F] = 1
	ld a, $01
	ld [wTradeSceneState], a
;>     wLinkFrozen = 1
	ld [wLinkFrozen], a
;>     wEntityTimer[slot] = 0xD0
	call GetEntityTimer
	ld [hl], $d0
;>     return OpenDialogTable1(0xE9)
	ld a, $e9
	jp OpenDialogTable1

.no
;> wEntityState[slot] = 0
	ld [hl], b
;> OpenDialogTable1(0xEA)
	ld a, $ea
	call OpenDialogTable1
	ret


;@ def Fisherman_Fishing(slot: c)
;@ path: npc/fisherman_under_bridge
;@ State 2: Link must stand still while the fisherman fishes: for the first $50 frames he sits
;@ normally, then the line twitches (frames 0/1 every $18 frames), and for the last $30 frames he
;@ pulls (frame 3). When the time is up he shouts (text $EB) and goes to state 3 for $20 frames.
;@ test: skip opens dialogue through another bank
Fisherman_Fishing::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wMusicSpeed = 1
	ld a, $01
	ld [wMusicSpeed], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .animate
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     OpenDialogTable1(0xEB)
	ld a, $eb
	call OpenDialogTable1
;>     wEntityState[slot] += 1
	call IncrementEntityState
.animate
;> frame = 3                                 # pulling
	ld e, $03
;> if t >= 0x30:
	cp $30
	jr c, .setFrame
;>     if t >= 0x80:
	cp $80
;>         return Fisherman_IdleAnimation()
	jr nc, Fisherman_IdleAnimation
;>     frame = 1 if hFrameCounter & 0x18 else 0  # the line twitches
	ldh a, [hFrameCounter]
	and $18
	ld e, b
	jr z, .setFrame
	inc e
.setFrame
;> return SetEntitySpriteVariant(slot, frame)
	ld a, e
	jp SetEntitySpriteVariant


;@ def Fisherman_PullOut(slot: c)
;@ path: npc/fisherman_under_bridge
;@ State 3: after $20 frames the catch flies out of the water: entity $54 (the fishing catch, with
;@ wEntityPrivate4 = 1) appears $20 pixels left and 8 below with an upward hop, with an appearing
;@ effect and jingle $08. Link's trade item becomes the necklace ($0C).
;@ test: skip spawns an entity through bank 3
Fisherman_PullOut::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .pulling
;>     wMusicSpeed = 0
	ld [wMusicSpeed], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     catch = SpawnEntity(0x54)
	ld a, $54
	call SpawnEntity
;>     wEntityX[catch] = hMultiPurpose0 - 0x20
	ldh a, [hMultiPurpose0]
	sub $20
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     hActiveEntityX = wEntityX[catch]
	ldh [hActiveEntityX], a
;>     wEntityY[catch] = hMultiPurpose1 + 8
	ldh a, [hMultiPurpose1]
	add $08
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     hActiveEntityDrawY = wEntityY[catch]  # the effect appears there
	ldh [hActiveEntityDrawY], a
;>     wEntitySpeedZ[catch] = 0x20
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $20
;>     wEntityPrivate4[catch] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;>     SetEntitySpeedTowardsLink(catch, 0x0A)
	push bc
	push de
	pop bc
	ld a, $0a
	call SetEntitySpeedTowardsLink
	pop bc
;>     SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;>     wTradeSequenceItem = 0x0C            # the necklace
	ld a, $0c
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
.pulling
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
	ret


;@ def Fisherman_Done(slot: c)
;@ path: npc/fisherman_under_bridge
;@ State 4: back to idle (state 0), still holding Link for this frame.
;@ test: c = rand(0, 15)
Fisherman_Done::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret


;@ def DrawFisherman()
;@ path: npc/fisherman_under_bridge
;@ Draws the fisherman's frame hActiveEntitySpriteVariant (4 sprites of FishermanSprites).
;@ test: skip draws sprites through DrawEntitySprites
DrawFisherman::
;> offset = (hActiveEntitySpriteVariant * 16) & 0xF0     # 16 bytes per frame
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;> frame = FishermanSprites + offset
	ld e, a
	ld d, b
	ld hl, FishermanSprites
	add hl, de
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
	ret


;@ path: unused
;@ 72 bytes of small signed offsets (-2..+2) that no code reads, left between the fisherman's
;@ routines.
FishermanUnusedOffsets::
	db $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $01, $00, $00, $ff, $fe, $fe, $01, $01, $01, $00, $00, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $00, $01, $01, $01
	db $fe, $fe, $ff, $00, $00, $01, $02, $02

;@ path: npc/fisherman_under_bridge
;@ How far the boat is drawn below its position as it bobs on the water: 8 steps of 8 frames
;@ (pixels, 0-2), indexed by (wEntityPrivateCounter >> 3) & 7.
FishermanBoatBobOffsets::
	db $00, $00, $01, $02, $02, $02, $01, $00

;@ def FishermanBoat(slot: c)
;@ path: npc/fisherman_under_bridge
;@ The fisherman's boat ($B8 with wEntityPrivate1 = 2). It bobs on the water, carries the
;@ fisherman (the entity in slot 0) 16 pixels above it, and is a platform: Link landing on it from
;@ above stands on it. It drifts to y $48, or $4B (sinking a little) while Link stands on it, one
;@ pixel every 8 frames.
;@ test: skip draws sprites and checks Link collision through bank 3
FishermanBoat::
;> counter = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
;> step = (counter >> 3) & 7
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;> bob = FishermanBoatBobOffsets[step]
	ld hl, FishermanBoatBobOffsets
	add hl, de
;> hActiveEntityDrawY += bob
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
;> wEntityY[0] = hActiveEntityDrawY - 0x10    # the fisherman sits in it
	sub $10
	ld [wEntityY], a
;> DrawFishermanBoat()
	call DrawFishermanBoat
;> if EntityTouchesLink() and not hLinkSpeedY & 0x80:   # Link touches it, not moving up
	call EntityTouchesLink
	jr nc, .update
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, .update
;>     dy, ydir = EntityLinkDiffY(slot)
	call EntityLinkDiffY
;>     if (dy + 8) & 0x80:                  # Link is above the boat
	add $08
	bit 7, a
	jr z, .update
;>         hLinkY = hActiveEntityDrawY - 0x0F  # stand on it
	ldh a, [hActiveEntityDrawY]
	sub $0f
	ldh [hLinkY], a
;>         hLinkSpeedY = 2
	ld a, $02
	ldh [hLinkSpeedY], a
;>         wLinkOnPlatform = 1
	ld a, $01
	ld [wLinkOnPlatform], a
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if wEntityPrivateCounter[slot] & 7 == 0:
	ld a, [hl]
	and $07
	jr nz, .done
;>     target = 0x4B if wLinkOnPlatform else 0x48
	ld e, $48
	ld a, [wLinkOnPlatform]
	and a
	jr z, .target
	ld e, $4b
.target
;>     diff = wEntityY[slot] - target
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub e
;>     if diff != 0:
	jr z, .done
;>         wEntityY[slot] += 1 if diff & 0x80 else -1   # one pixel towards the target
	and $80
	jr z, .up
	inc [hl]
	inc [hl]
.up
	dec [hl]
.done
	ret


;@ path: npc/fisherman_under_bridge
;@ The boat: 5 sprites of 4 bytes (y offset, x offset, tile, attributes) in a row from x -8 to
;@ +$18: tile $68 (stern), three times $6A, then $6C (bow).
FishermanBoatSprites::
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $00, $00, $10, $6a, $00
	db $00, $18, $6c, $00

;@ def DrawFishermanBoat()
;@ path: npc/fisherman_under_bridge
;@ Draws the boat (the 5 sprites of FishermanBoatSprites).
;@ test: skip draws sprites through DrawEntitySprites
DrawFishermanBoat::
;> DrawEntitySprites(FishermanBoatSprites, 5)
	ld hl, FishermanBoatSprites
	ld c, $05
	call DrawEntitySprites
	ret


;@ path: npc/mermaid
;@ The mermaid swimming, drawn by DrawEntity16x16 as two 8x16 sprites side by side; 4 frames of 4 bytes
;@ (tile and attributes of the left half, then of the right half): 0 = facing right (tiles
;@ $70/$72 mirrored), 1 = facing left, 2 and 3 = diving (tiles $76/$78, the second mirrored).
MermaidSprites::
	db $72, $20, $70, $20, $70, $00, $72, $00, $76, $00, $78, $00, $78, $20, $76, $20
;@ path: npc/mermaid
;@ The ripple around the swimming mermaid (same format as MermaidSprites): frame 0 = tile $74 and
;@ its mirror image; frame 1 (palette OBP1, also flipped upside down) is not used.
MermaidRippleSprites::
	db $74, $00, $74, $20, $74, $10, $74, $30

;@ path: npc/mermaid
;@ The mermaid's tail as she jumps over the water (sprite frames 4 and 5): 3 sprites of 4 bytes
;@ each (y offset, x offset, tile, attributes) per frame. Frame 4 = tiles $7A/$7C/$7E from x -4 to
;@ +$0C, frame 5 = the same mirrored.
MermaidTailSprites::
	db $00, $fc, $7a, $00, $00, $04, $7c, $00
	db $00, $0c, $7e, $00, $00, $fc, $7e, $20, $00, $04, $7c, $20, $00, $0c, $7a, $20
;@ path: npc/mermaid
;@ How far the swimming mermaid is drawn lower as she bobs: 8 steps of 8 frames (pixels, 0-2),
;@ indexed by (hFrameCounter >> 3) & 7.
MermaidBobOffsets::
	db $00, $00, $01, $02, $02, $02, $01, $00

;@ def MermaidHandler(slot: c)
;@ path: npc/mermaid
;@ Entity $B7, the mermaid in Martha's Bay. She swims and bobs, dives away when Link swims too
;@ close and comes up $30 pixels away on the other side. In the trading sequence she takes the
;@ necklace (trade item $0C) and gives the scale ($0D), then leaps out of the water a few times and
;@ leaves. Once the room's event flag (hRoomStatus bit 5) is set she is replaced by her after-trade
;@ form (wEntityPrivate3 = 1, MermaidAfterTrade). States (wEntityState): 0 init, 1 swim, 2-4 dive
;@ and resurface, 5 answer, 6 take the necklace, 7-10 leap away.
;@ test: skip draws sprites through bank 0 routines
MermaidHandler::
;> if wEntityPrivate3[slot] != 0:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
;>     return MermaidAfterTrade(slot)
	jp nz, MermaidAfterTrade
;> if hActiveEntityState < 2:
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .draw
;>     if hRoomStatus & 0x20:           # the trade already happened
	ldh a, [hRoomStatus]
	and $20
	jr z, .bob
;>         wEntityPrivate3[slot] = 1
	inc [hl]
;>         return
	ret

.bob
;>     step = (hFrameCounter >> 3) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	ld e, a
;>     hActiveEntityDrawY += MermaidBobOffsets[step]
	ld d, b
	ld hl, MermaidBobOffsets
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
.draw
;> if hActiveEntitySpriteVariant >= 4:      # the leaping tail
	ldh a, [hActiveEntitySpriteVariant]
	cp $04
	jr c, .swimming
;>     four = ((hActiveEntitySpriteVariant - 4) * 4) & 0xFF
	sub $04
	rla
	rla
	and $fc
	ld e, a
;>     offset = four * 3                # 12 bytes per frame
	rla
	and $f8
	add e
;>     frame = MermaidTailSprites + offset
	ld e, a
	ld d, b
	ld hl, MermaidTailSprites
	add hl, de
;>     DrawEntitySprites(frame, 3)
	ld c, $03
	call DrawEntitySprites
	jr .ripple
;> else:
.swimming
;>     DrawEntity16x16(MermaidSprites)
	ld de, MermaidSprites
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
.ripple
;> if hActiveEntityState == 5 or hActiveEntityState < 3:   # in the water: draw the ripple
	ldh a, [hActiveEntityState]
	cp $05
	jr z, .drawRipple
	cp $03
	jr nc, .update
.drawRipple
;>     hActiveEntityDrawY += 0x0B
	ldh a, [hActiveEntityDrawY]
	add $0b
	ldh [hActiveEntityDrawY], a
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(MermaidRippleSprites)
	ld de, MermaidRippleSprites
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> return MermaidStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mermaid
;@ States of the mermaid (wEntityState), see MermaidHandler.
MermaidStates::
	dw Mermaid_Init
	dw Mermaid_Wait
	dw Mermaid_StartDive
	dw Mermaid_Dive
	dw Mermaid_Resurface
	dw Mermaid_Answer
	dw Mermaid_TakeNecklace
	dw Mermaid_JumpStart
	dw Mermaid_Jump
	dw Mermaid_Splash
	dw Mermaid_NextJump

;@ def Mermaid_Init(slot: c)
;@ path: npc/mermaid
;@ State 0: her diving jump is $30 pixels (wEntityPrivate1, flipped each dive); go to state 1.
;@ test: c = rand(0, 15)
Mermaid_Init::
;> wEntityPrivate1[slot] = 0x30
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $30
;> return IncrementEntityState(slot)                  # wEntityState += 1
	jp IncrementEntityState


;@ def Mermaid_Wait(slot: c)
;@ path: npc/mermaid
;@ State 1: faces Link and blocks his way. When Link swims within $12 pixels she says text $F1 and
;@ dives (state 2, $14 frames). Talked to with the necklace she asks for it (text $F2, state 5);
;@ otherwise text $F0.
;@ test: skip opens dialogue through another bank
Mermaid_Wait::
;> dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;> SetEntitySpriteVariant(slot, xdir)                      # face Link
	ld a, e
	call SetEntitySpriteVariant
;> PushLinkOutOfEntity()                       # Link cannot walk through her
	call PushLinkOutOfEntity
;> near = (EntityLinkDiffX(slot)[0] + 0x12) & 0xFF < 0x24
	call EntityLinkDiffX
	add $12
	cp $24
	jr nc, .talk
;> near = near and (EntityLinkDiffY(slot)[0] + 0x12) & 0xFF < 0x24
	call EntityLinkDiffY
	add $12
	cp $24
	jr nc, .talk
;> if near and hLinkMotionStep:          # Link swims up close
	ldh a, [hLinkMotionStep]
	and a
	jr z, .talk
;>     wEntityState[slot] += 1          # dive
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x14
	call GetEntityTimer
	ld [hl], $14
;>     OpenDialogTable1(0xF1)
	ld a, $f1
	call OpenDialogTable1
;>     return
	ret

.talk
;> if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .done
;>     if wTradeSequenceItem == 0x0C:   # the necklace
	ld a, [wTradeSequenceItem]
	cp $0c
	jr nz, .chat
;>         OpenDialogTable1(0xF2)
	ld a, $f2
	call OpenDialogTable1
;>         wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>         return
	ret

.chat
;>     OpenDialogTable1(0xF0)
	ld a, $f0
	call OpenDialogTable1
.done
	ret


;@ def Mermaid_StartDive(slot: c)
;@ path: npc/mermaid
;@ State 2: one frame, then state 3.
;@ test: c = rand(0, 15)
Mermaid_StartDive::
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def Mermaid_Dive(slot: c)
;@ path: npc/mermaid
;@ State 3: once the text is closed she dives (frames 3, then 2, over the last $10 frames) and
;@ disappears for $40 frames with a splash effect (state 4).
;@ test: skip spawns an effect through bank 0
Mermaid_Dive::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .diving
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SetEntitySpriteVariant(slot, 0xFF)                  # hidden
	ld a, $ff
	call SetEntitySpriteVariant
;>     return
	ret

.diving
;> frame = 0xFF
	ld e, $ff
;> if t < 0x10:
	cp $10
	jr nc, .setFrame
;>     frame = 3 if t >= 8 else 2
	ld e, $02
	cp $08
	jr c, .setFrame
	inc e
.setFrame
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
.done
	ret


;@ def Mermaid_Resurface(slot: c)
;@ path: npc/mermaid
;@ State 4: when the time is up she comes up on the other side: x moves by wEntityPrivate1 (which
;@ flips between +$30 and -$30), back to state 1.
;@ test: skip spawns an effect through bank 0
Mermaid_Resurface::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityPrivate1[slot] = -wEntityPrivate1[slot] & 0xFF
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     wEntityX[slot] += wEntityPrivate1[slot]
	ld hl, wEntityX
	add hl, bc
	add [hl]
	ld [hl], a
;>     hActiveEntityX = wEntityX[slot]
	ldh [hActiveEntityX], a
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
.done
	ret


;@ def Mermaid_Answer(slot: c)
;@ path: npc/mermaid
;@ State 5: if Link agreed to give the necklace, $C0 frames of the exchange follow (state 6);
;@ otherwise text $F4 and back to state 0.
;@ test: skip opens dialogue through another bank
Mermaid_Answer::
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer == 0:               # "yes"
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>     wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>     return
	ret

.no
;> wEntityState[slot] = 0
	ld [hl], b
;> return OpenDialogTable1(0xF4)
	ld a, $f4
	jp OpenDialogTable1


;@ def Mermaid_TakeNecklace(slot: c)
;@ path: npc/mermaid
;@ State 6, the exchange: Link holds still in his item pose (hLinkMotionStep 1 from timer $8F down
;@ to $20); at timer $90 a sparkle appears on Link, at $70 she thanks him (text $F3). At the end
;@ Link's trade item becomes the scale ($0D), shown above him (SpawnHeldItemEntity); then state 7 after $30
;@ frames.
;@ test: skip opens dialogue and spawns effects through other banks
Mermaid_TakeNecklace::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
	jr z, .give
;>     if t == 0x70:
	cp $70
	jr nz, .notText
;>         wEntityTimer[slot] -= 1          # only once
	dec [hl]
;>         OpenDialogTable1(0xF3)
	push af
	ld a, $f3
	call OpenDialogTable1
	pop af
.notText
;>     if t == 0x90:
	cp $90
	jr nz, .pose
;>         hMultiPurpose1 = hLinkY - 3
	ldh a, [hLinkY]
	sub $03
	ldh [hMultiPurpose1], a
;>         hMultiPurpose0 = hLinkX
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;>         hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;>         AddTransientVfx(1)                    # sparkle on Link
	ld a, $01
	call AddTransientVfx
;>         t = wEntityTimer[slot]
	call GetEntityTimer
.pose
;>     pose = 1 if 0x20 <= t < 0x90 else 0
	ld e, $00
	cp $20
	jr c, .setPose
	cp $90
	jr nc, .setPose
	ld e, $01
.setPose
;>     hLinkMotionStep = pose
	ld a, e
	ldh [hLinkMotionStep], a
;>     hLinkInteractiveMotionBlocked = 2
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $02
;>     wLinkSpriteDY = 4
	ld a, $04
	ld [wLinkSpriteDY], a
;>     return
	ret

.give
;> wTradeSequenceItem = 0x0D             # the scale
	ld a, $0d
	ld [wTradeSequenceItem], a
;> hBGChangeRequest = 0x0D
	ldh [hBGChangeRequest], a
;> SpawnHeldItemEntity()                           # show the new item above Link
	call SpawnHeldItemEntity
;> wEntityState[slot] += 1
	call IncrementEntityState
;> wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
.done
	ret


;@ def Mermaid_JumpStart(slot: c)
;@ path: npc/mermaid
;@ State 7: after the wait she leaps out of the water: the tail frame (4 or 5 for her facing), x
;@ speed -8 or +8, upward speed $20, a splash effect and jingle $24.
;@ test: skip spawns an effect through bank 0
Mermaid_JumpStart::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     frame = hActiveEntitySpriteVariant + 4
	ldh a, [hActiveEntitySpriteVariant]
	add $04
;>     SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;>     speed = 0xF8 if frame == 4 else 0x08
	ld e, $08
	cp $04
	jr nz, .setSpeed
	ld e, $f8
.setSpeed
;>     wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
;>     wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;>     SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
;>     PlayJingle24()                    # jingle $24
	call PlayJingle24
.done
	ret


;@ def Mermaid_Jump(slot: c)
;@ path: npc/mermaid
;@ State 8: flies in an arc (gravity 2 per frame) until she is back in the water, then splashes
;@ (state 9, $10 frames).
;@ test: skip spawns an effect through bank 0
Mermaid_Jump::
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:            # below the water line
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
.done
	ret


;@ def Mermaid_Splash(slot: c)
;@ path: npc/mermaid
;@ State 9: dives in (frame 2, then 3 for the last 8 frames), then hidden for $20 frames (state 10).
;@ test: c = rand(0, 15)
Mermaid_Splash::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .diving
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     SetEntitySpriteVariant(slot, 0xFF)
	ld a, $ff
	call SetEntitySpriteVariant
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.diving
;> frame = 2 if t >= 8 else 3
	ld e, $02
	cp $08
	jr nc, .setFrame
	inc e
.setFrame
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def Mermaid_NextJump(slot: c)
;@ path: npc/mermaid
;@ State 10: after the wait, comes up $10 pixels above or below with a random facing and leaps
;@ again (state 7); after her fourth leap (wEntityPrivate5 = 3) she is gone.
;@ test: skip draws on random numbers
Mermaid_NextJump::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz
;> if wEntityPrivate5[slot] == 3:
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	cp $03
;>     return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;> wEntityPrivate5[slot] += 1
	inc [hl]
;> facing = GetRandomByte() & 1
	call GetRandomByte
	and $01
;> SetEntitySpriteVariant(slot, facing)
	call SetEntitySpriteVariant
;> dy = 0x10 if facing == 0 else 0xF0
	ld e, $10
	and a
	jr z, .move
	ld e, $f0
.move
;> wEntityY[slot] = (wEntityY[slot] + dy) & 0xFF
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
;> wEntityState[slot] = 7
	call IncrementEntityState
	ld [hl], $07
	ret


;@ def SpawnAppearEffectAtEntity()
;@ path: entity/helpers
;@ Shows transient effect 1 (a splash / puff) where the entity is drawn and plays jingle $0E.
;@ test: skip spawns an effect through bank 0
SpawnAppearEffectAtEntity::
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> AddTransientVfx(1)
	ld a, $01
	call AddTransientVfx
;> hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
	ret


;@ def MermaidAfterTrade(slot: c)
;@ path: npc/mermaid
;@ The mermaid after the trade (wEntityPrivate3 = 1): she waits out of sight until Link wades in,
;@ then leaps up onto the shore and sits there to chat. States (wEntityState): 0 wait, 1 leap,
;@ 2 in the air, 3 sitting.
;@ test: skip dispatches through a jump table
MermaidAfterTrade::
;> return MermaidAfterTradeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/mermaid
;@ States of MermaidAfterTrade (wEntityState).
MermaidAfterTradeStates::
	dw MermaidAfterTrade_Wait
	dw MermaidAfterTrade_Leap
	dw MermaidAfterTrade_Jump
	dw MermaidAfterTrade_Sit

;@ def MermaidAfterTrade_Wait(slot: c)
;@ path: npc/mermaid
;@ State 0: stays at ($58, $80) out of sight until Link makes a splash in the water
;@ (wLinkGroundVfxPrev nonzero).
;@ test: skip may return from its caller
MermaidAfterTrade_Wait::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wEntityX[slot] = 0x58
	ld hl, wEntityX
	add hl, bc
	ld [hl], $58
;> wEntityY[slot] = 0x80
	ld hl, wEntityY
	add hl, bc
	ld [hl], $80
;> if wLinkGroundVfxPrev:
	ld a, [wLinkGroundVfxPrev]
	and a
	jr z, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def MermaidAfterTrade_Leap(slot: c)
;@ path: npc/mermaid
;@ State 1: jumps up (height speed $20, moving up the screen at 4/16 pixel per frame) with a
;@ splash.
;@ test: skip may return from its caller
MermaidAfterTrade_Leap::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wEntitySpeedZ[slot] = 0x20
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $20
;> wEntitySpeedY[slot] = 0xFC
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fc
;> SpawnAppearEffectAtEntity()
	call SpawnAppearEffectAtEntity
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def MermaidAfterTrade_Jump(slot: c)
;@ path: npc/mermaid
;@ State 2: in the air (gravity 1 per frame, frame 0/1 every 16 frames) until she lands (state 3).
;@ test: skip draws sprites, may return from its caller
MermaidAfterTrade_Jump::
;> DrawMermaidSitting()
	call DrawMermaidSitting
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> if wEntityZ[slot] & 0x80:             # landed
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .animate
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntityState[slot] += 1
	call IncrementEntityState
.animate
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def MermaidAfterTrade_Sit(slot: c)
;@ path: npc/mermaid
;@ State 3: sits facing Link (frame 2 or 3) and chats when talked to (text $F6).
;@ test: skip draws sprites and opens dialogue
MermaidAfterTrade_Sit::
;> dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;> hActiveEntitySpriteVariant = xdir + 2
	ld a, e
	add $02
	ldh [hActiveEntitySpriteVariant], a
;> DrawMermaidSitting()
	call DrawMermaidSitting
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .done
;>     OpenDialogTable1(0xF6)
	ld a, $f6
	call OpenDialogTable1
.done
	ret


;@ path: npc/mermaid
;@ The mermaid out of the water, 16x32 pixels: 4 frames of 4 sprites, each sprite 4 bytes (y offset,
;@ x offset, tile, attributes); the top row is at y -$10. 0 and 1 = flying in the leap (tiles
;@ $70-$76, the second mirrored), 2 and 3 = sitting facing right or left (tiles $70/$72/$78/$7A).
MermaidSittingSprites::
	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $f0, $00, $72, $20, $f0, $08, $70, $20, $00, $00, $76, $20, $00, $08, $74, $20
	db $f0, $ff, $72, $20, $f0, $07, $70, $20, $00, $00, $7a, $20, $00, $08, $78, $20
	db $f0, $01, $70, $00, $f0, $09, $72, $00, $00, $00, $78, $00, $00, $08, $7a, $00

;@ def DrawMermaidSitting()
;@ path: npc/mermaid
;@ Draws frame hActiveEntitySpriteVariant of MermaidSittingSprites (4 sprites).
;@ test: skip draws sprites through DrawEntitySprites
DrawMermaidSitting::
;> offset = (hActiveEntitySpriteVariant * 16) & 0xF0
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;> frame = MermaidSittingSprites + offset
	ld e, a
	ld d, b
	ld hl, MermaidSittingSprites
	add hl, de
;> return DrawEntitySprites(frame, 4)
	ld c, $04
	jp DrawEntitySprites


;@ path: npc/papahl
;@ Papahl at home, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 2 frames of 4 bytes (tile and
;@ attributes of the left half, then of the right half). 0 = facing right (tiles $6C/$6E mirrored),
;@ 1 = facing left.
PapahlSprites::
	db $6e, $20, $6c, $20, $6c, $00, $6e, $00

;@ path: npc/papahl
;@ Papahl lost in the mountains, facing left (same format as PapahlSprites): frames 0 and 1 =
;@ sitting (tiles $70-$76), 2 and 3 = eating (tiles $78-$7C).
PapahlLeftSprites::
	db $70, $00, $72, $00, $74, $00, $76, $00
	db $78, $00, $7a, $00, $7c, $00, $76, $00

;@ path: npc/papahl
;@ The same four frames as PapahlLeftSprites mirrored, facing right. Also used at home after the
;@ trade.
PapahlRightSprites::
	db $72, $20, $70, $20, $76, $20, $74, $20
	db $7a, $20, $78, $20, $76, $20, $7c, $20

;@ path: npc/papahl
;@ A small symbol drawn above and to the right of Papahl while he waits for food: tile $7E and its
;@ mirror image (same format as PapahlSprites, one frame).
PapahlSymbolSprite::
	db $7e, $00, $7e, $20

;@ def PapahlHandler(slot: c)
;@ path: npc/papahl
;@ Entity $B6, Papahl. At home (indoors) he is away while he is lost (story flag $DB66 bit 1, before
;@ the trade) and chats otherwise (text $27 of the second table before the trade, $76 after). In the
;@ mountains he sits hungry, and gives the hibiscus (trade item $08) for the pineapple ($07); he is
;@ gone there once the room's event flag (hRoomStatus bit 5) is set. States in the mountains
;@ (wEntityState): 0 wait, 1 answer, 2 eat, 3 give the item, 4 done.
;@ test: skip draws sprites and opens dialogue through other banks
PapahlHandler::
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .outdoors
;>     if wTradeSequenceItem < 0x08 and mem[0xDB66] & 0x02:    # still lost in the mountains
	ld a, [wTradeSequenceItem]
	cp $08
	jr nc, .atHome
	ld a, [wHasInstrument2]
	and $02
;>         return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
.atHome
;>     sprites = PapahlRightSprites
	ld de, PapahlRightSprites
;>     if wTradeSequenceItem < 0x08:
	ld a, [wTradeSequenceItem]
	cp $08
	jr nc, .drawHome
;>         dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;>         hActiveEntitySpriteVariant = xdir   # face Link
	ld a, e
	ldh [hActiveEntitySpriteVariant], a
;>         sprites = PapahlSprites
	ld de, PapahlSprites
.drawHome
;>     DrawEntity16x16(sprites)
	call DrawEntity16x16
;>     frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;>     SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;>     PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;>     if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .doneHome
;>         if wTradeSequenceItem < 0x08:
	ld a, [wTradeSequenceItem]
	cp $08
	jr nc, .afterTrade
;>             return OpenDialog(0x27)
	ld a, $27
	jp OpenDialog

.afterTrade
;>         OpenDialogTable1(0x76)
	ld a, $76
	call OpenDialogTable1
.doneHome
;>     return
	ret

.outdoors
;> if hRoomStatus & 0x20:                    # already back home
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;> sprites = PapahlLeftSprites
	ld de, PapahlLeftSprites
;> if wEntityDirection[slot] == 0:
;>     sprites = PapahlRightSprites
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
	ld de, PapahlRightSprites
.draw
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> if wTradeSequenceItem < 0x08:
	ld a, [wTradeSequenceItem]
	cp $08
	jr nc, .update
;>     hActiveEntityX += 0x10
	ldh a, [hActiveEntityX]
	add $10
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY -= 0x10
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     DrawEntity16x16(PapahlSymbolSprite)
	ld de, PapahlSymbolSprite
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> return PapahlStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/papahl
;@ States of Papahl in the mountains (wEntityState), see PapahlHandler.
PapahlStates::
	dw Papahl_Wait
	dw Papahl_Answer
	dw Papahl_Eat
	dw Papahl_GiveItem
	dw Papahl_Done

;@ def Papahl_Wait(slot: c)
;@ path: npc/papahl
;@ State 0: looks towards Link. While Link is within $24 pixels he sits still (frame 0) and can be
;@ talked to: with the pineapple (trade item $07) he asks for it (text $70), otherwise text $77;
;@ then state 1. Farther away he sways (frames 0/1 every 8 frames).
;@ test: skip opens dialogue through another bank
Papahl_Wait::
;> dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;> wEntityDirection[slot] = xdir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> near = (dx + 0x24) & 0xFF < 0x48
	add $24
	cp $48
	jr nc, .far
;> if near and (EntityLinkDiffY(slot)[0] + 0x24) & 0xFF < 0x48:
	call EntityLinkDiffY
	add $24
	cp $48
	jr nc, .far
;>     if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .still
;>         OpenDialogTable1(0x70 if wTradeSequenceItem == 0x07 else 0x77)
	ld a, [wTradeSequenceItem]
	cp $07
	ld a, $70
	jr z, .open
	ld a, $77
.open
	call OpenDialogTable1
;>         wEntityState[slot] += 1
	call IncrementEntityState
.still
;>     SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;>     return
	ret

.far
;> frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def Papahl_Answer(slot: c)
;@ path: npc/papahl
;@ State 1: if Link agreed to give the pineapple he thanks him (text $72) and eats for $C0 frames
;@ (state 2); otherwise text $71 and back to state 0.
;@ test: skip opens dialogue through another bank
Papahl_Answer::
;> if wDialogAnswer == 0 and wTradeSequenceItem == 0x07:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
	ld a, [wTradeSequenceItem]
	cp $07
	jr nz, .no
;>     OpenDialogTable1(0x72)
	ld a, $72
	call OpenDialogTable1
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>     return
	ret

.no
;> OpenDialogTable1(0x71)
	ld a, $71
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret


;@ def Papahl_Eat(slot: c)
;@ path: npc/papahl
;@ State 2: eats the pineapple while Link waits (the music plays faster, wMusicSpeed = 1). When the
;@ time is up: normal music speed, text $73, Link's trade item becomes the hibiscus ($08), state 3.
;@ test: skip opens dialogue through another bank
Papahl_Eat::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return PapahlEatAnimation()
	jr nz, PapahlEatAnimation
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .eating
;>     wMusicSpeed = 0
	ld [wMusicSpeed], a
;>     OpenDialogTable1(0x73)
	ld a, $73
	call OpenDialogTable1
;>     wTradeSequenceItem = 0x08         # the hibiscus
	ld a, $08
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.eating
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wMusicSpeed = 1
	ld a, $01
	ld [wMusicSpeed], a
;> PapahlEatAnimation()                   # falls through

;@ def PapahlEatAnimation()
;@ path: npc/papahl
;@ Shows the eating frames 2 and 3, switching every 8 frames.
;@ test: skip writes the sprite variant of the slot in c
PapahlEatAnimation::
;> frame = ((hFrameCounter >> 3) & 1) + 2
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $02
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def Papahl_GiveItem(slot: c)
;@ path: npc/papahl
;@ State 3: once the text is closed, the hibiscus is shown above Link (SpawnHeldItemEntity); state 4.
;@ test: skip spawns an entity through bank 3
Papahl_GiveItem::
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>     wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def Papahl_Done(slot: c)
;@ path: npc/papahl
;@ State 4: keeps eating and says text $75 when talked to.
;@ test: skip opens dialogue through another bank
Papahl_Done::
;> PapahlEatAnimation()
	call PapahlEatAnimation
;> if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .done
;>     OpenDialogTable1(0x75)
	ld a, $75
	call OpenDialogTable1
.done
	ret


;@ path: npc/bear
;@ The bear cook of Animal Village, 32x32 pixels: 8 sprites of 4 bytes (y offset, x offset, tile,
;@ attributes), two rows of four at y -6 and +10, x 0 to +$18. Frame 0; BearSprites2 is frame 1
;@ (the top middle tiles swapped and mirrored: he turns his head).
BearSprites::
	db $fa, $00, $70, $00, $fa, $08, $72, $00, $fa, $10, $74, $00, $fa, $18, $70, $20
	db $0a, $00, $76, $00, $0a, $08, $78, $00, $0a, $10, $78, $20, $0a, $18, $76, $20
;@ path: npc/bear
;@ Frame 1 of the bear (see BearSprites).
BearSprites2::
	db $fa, $00, $70, $00, $fa, $08, $74, $20, $fa, $10, $72, $20, $fa, $18, $70, $20
	db $0a, $00, $76, $00, $0a, $08, $78, $00, $0a, $10, $78, $20, $0a, $18, $76, $20
;@ path: npc/bear
;@ One 8x16 sprite (tile $7E, attributes 0), drawn by DrawEntity8x16 at ($74, $38) while Link carries
;@ the honeycomb.
BearThoughtSprite::
	db $7e, $00

;@ path: npc/bear
;@ The bear's counter, drawn by DrawEntity16x16 as two 8x16 sprites side by side (4 bytes: tile and
;@ attributes of the left half, then of the right half): the left end (tiles $7A/$7C) at the
;@ bear's x, and from offset 4 the mirrored right end at x $68.
BearCounterSprites::
	db $7a, $00, $7c, $00, $7c, $20, $7a, $20

;@ def BearHandler(slot: c)
;@ path: npc/bear
;@ Entity $B5, the bear cook in Animal Village, behind his counter. He trades the pineapple (trade
;@ item $07) for the honeycomb ($06). States (wEntityState): 0 wait, 1 answer, 2 thanks.
;@ test: skip draws sprites and opens dialogue through other banks
BearHandler::
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityDrawY = 0x4A
	ld a, $4a
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(BearCounterSprites)            # left end of the counter
	ld de, BearCounterSprites
	call DrawEntity16x16
;> hActiveEntityX = 0x68
	ld a, $68
	ldh [hActiveEntityX], a
;> DrawEntity16x16(BearCounterSprites + 4)        # right end
	ld de, BearCounterSprites + 4
	call DrawEntity16x16
;> if wTradeSequenceItem == 0x06:           # Link has the honeycomb
	ld a, [wTradeSequenceItem]
	cp $06
	jr nz, .drawBear
;>     hActiveEntityX = 0x74
	ld a, $74
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY = 0x38
	ld a, $38
	ldh [hActiveEntityDrawY], a
;>     DrawEntity8x16(BearThoughtSprite)
	ld de, BearThoughtSprite
	call DrawEntity8x16
.drawBear
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> sprites = BearSprites
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ld hl, BearSprites
;> if wEntitySpriteVariant[slot] != 0:
;>     sprites = BearSprites2
	and a
	jr z, .draw
	ld hl, BearSprites2
.draw
;> DrawEntitySprites(sprites, 8)
	ld c, $08
	call DrawEntitySprites
;> ReserveOAMEntriesFar(6)                             # bank $15 helper for the 8-sprite entity
	ld a, $06
	call ReserveOAMEntriesFar
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> SetEntitySpriteVariant(slot, hFrameCounter & 0x20)          # turns his head every 32 frames
	ldh a, [hFrameCounter]
	and $20
	call SetEntitySpriteVariant
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> return BearStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/bear
;@ States of the bear (wEntityState), see BearHandler.
BearStates::
	dw Bear_Wait
	dw Bear_Answer
	dw Bear_Thanks

;@ def Bear_Wait(slot: c)
;@ path: npc/bear
;@ State 0: talked to across the counter: text $D3 once the event of overworld room $FD is done
;@ ($D8FD bits 4-5); with the honeycomb he asks for it (text $CF, state 1); with Marin along text
;@ $D4; after the trade (pineapple) text $D2; otherwise text $CE.
;@ test: skip opens dialogue through another bank
Bear_Wait::
;> if not ShouldLinkTalkToEntity_Wide(slot):
	call ShouldLinkTalkToEntity_Wide
;>     return
	jr nc, BearReturn
;> text = 0xD3
	ld e, $d3
;> if mem[0xD8FD] & 0x30:
	ld a, [$d8fd]
	and $30
;>     return BearSayText(text)
	jr nz, BearSayText
;> if wTradeSequenceItem == 0x06:           # the honeycomb
	ld a, [wTradeSequenceItem]
	cp $06
	jr nz, .noHoneycomb
;>     BearOpenDialog(0xCF)
	ld a, $cf
	call BearOpenDialog
;>     return IncrementEntityState(slot)                   # state 1: wait for the answer
	jp IncrementEntityState

.noHoneycomb
;> text = 0xD4
	ld e, $d4
;> if wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
;>     return BearSayText(text)
	jr nz, BearSayText
;> text = 0xCE
	ld e, $ce
;> if wTradeSequenceItem != 0x07:
	ld a, [wTradeSequenceItem]
	cp $07
;>     return BearSayText(text)
	jr nz, BearSayText
;> return BearSayThanks()                   # falls through

;@ def BearSayThanks()
;@ path: npc/bear
;@ Says the bear's after-trade text $D2. BearSayText inside it says the text in e.
;@ test: skip opens dialogue through another bank
BearSayThanks::
;> text = 0xD2
	ld e, $d2
BearSayText:
;> BearOpenDialog(text)
	ld a, e
	call BearOpenDialog
BearReturn:
	ret


;@ def Bear_Answer(slot: c)
;@ path: npc/bear
;@ State 1: once the question is closed: "no" gives text $D1 and back to state 0; "yes" makes
;@ Link's trade item the pineapple ($07), shows it above him and waits $70 frames (state 2).
;@ test: skip opens dialogue and spawns an entity through other banks
Bear_Answer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer != 0:                   # "no"
	ld a, [wDialogAnswer]
	and a
	jr z, .yes
;>     wEntityState[slot] = 0
	ld [hl], b
;>     BearOpenDialog(0xD1)
	ld a, $d1
	call BearOpenDialog
;>     return
	ret

.yes
;> wTradeSequenceItem = 0x07                # the pineapple
	ld a, $07
	ld [wTradeSequenceItem], a
;> hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;> SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;> wEntityTimer[slot] = 0x70
	call GetEntityTimer
	ld [hl], $70
.done
	ret


;@ def Bear_Thanks(slot: c)
;@ path: npc/bear
;@ State 2: when the time is up and no text is open, thanks Link (text $D2) and goes back to
;@ state 0.
;@ test: skip opens dialogue through another bank
Bear_Thanks::
;> if wEntityTimer[slot] == 0 and not wDialogState:
	call GetEntityTimer
	jr nz, .done
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     BearSayThanks()
	call BearSayThanks
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.done
	ret


;@ def BearOpenDialog(text: a)
;@ path: npc/bear
;@ Opens text a of the first table as if Link stood at the top of the screen (hLinkY = $10), so the
;@ box appears at the bottom and does not cover the counter.
;@ test: skip opens dialogue through another bank
BearOpenDialog::
;> saved_y = hLinkY
	ld e, a
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x10
	ld a, $10
	ldh [hLinkY], a
;> OpenDialogTable1(text)
	ld a, e
	call OpenDialogTable1
;> hLinkY = saved_y
	pop af
	ldh [hLinkY], a
	ret


;@ path: npc/honeycomb
;@ The honeycomb, drawn by DrawEntity16x16: tile $70 and its mirror image (one frame, 4 bytes: tile and
;@ attributes of the left half, then of the right half).
HoneycombSprites::
	db $70, $00, $70, $20

;@ def HoneycombHandler(slot: c)
;@ path: npc/honeycomb
;@ Entity $B3, the honeycomb in the tree on Ukuku Prairie and its bees (wEntityPrivate4 = 1,
;@ BeeHandler). Tarin pokes it with his stick: it shakes, the bees chase him, it drops, and Link
;@ picks it up (trade item $06). It stays away once the room's event flag (hRoomStatus bit 5) is
;@ set. wSmasherBallSlot keeps the honeycomb's slot and wSmasherSlot is set when the bees swarm.
;@ States (wEntityState): 0 init, 1 wait, 2 bees come out, 3 idle, 4 fall.
;@ test: skip draws sprites through bank 0
HoneycombHandler::
;> if hRoomStatus & 0x20:
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;> if wEntityPrivate4[slot] != 0:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	and a
;>     return BeeHandler(slot)
	jp nz, BeeHandler
;> wSmasherBallSlot = slot
	ld a, c
	ld [wSmasherBallSlot], a
;> if GetEntityTimer() & 0x20:               # shaking
	call GetEntityTimer
	and $20
	jr z, .draw
;>     hActiveEntityX -= 1
	ld hl, hActiveEntityX
	dec [hl]
.draw
;> DrawEntity16x16(HoneycombSprites)
	ld de, HoneycombSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> return HoneycombStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/honeycomb
;@ States of the honeycomb (wEntityState), see HoneycombHandler.
HoneycombStates::
	dw Honeycomb_Init
	dw Honeycomb_Wait
	dw Honeycomb_SpawnBees
	dw Honeycomb_Idle
	dw Honeycomb_Fall

;@ def Honeycomb_Init(slot: c)
;@ path: npc/honeycomb
;@ State 0: if Tarin already knocked it down (wTradeSceneState 2) it lies 16 pixels lower and falls
;@ the last bit at once (state 4); otherwise one bee starts buzzing around it (state 1).
;@ test: skip spawns an entity through bank 3
Honeycomb_Init::
;> if wTradeSceneState == 2:
	ld a, [wTradeSceneState]
	cp $02
	jr nz, .inTree
;>     wEntityY[slot] += 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
;>     wEntityZ[slot] = 0x10
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $10
;>     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>     return
	ret

.inTree
;> wSmasherSlot = 0                          # the bees are calm
	xor a
	ld [wSmasherSlot], a
;> wEntityState[slot] += 1
	call IncrementEntityState
;> SpawnBee()                                # falls through

;@ def SpawnBee() -> carry
;@ path: npc/honeycomb
;@ Spawns a bee ($B3 with wEntityPrivate4 = 1) at the honeycomb, x speed $0E, no hitbox. Returns
;@ carry if there was no free slot; de = the bee's slot.
;@ test: skip spawns an entity through bank 3
SpawnBee::
;> bee = SpawnEntity(0xB3)
	ld a, $b3
	call SpawnEntity
;> if bee is None:
;>@fail     return True
	jr c, .failed
;> wEntityX[bee] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[bee] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPrivate4[bee] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;> wEntitySpeedX[bee] = 0x0E
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $0e
;> wEntityPhysicsFlags[bee] = 0xC1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c1
;> wEntityHitboxFlags[bee] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;> return False
	and a
	ret

.failed
;=@fail
	scf
	ret


;@ def Honeycomb_Wait(slot: c)
;@ path: npc/honeycomb
;@ State 1: waits until Tarin's poke makes the bees swarm (wSmasherSlot set).
;@ test: c = rand(0, 15)
Honeycomb_Wait::
;> if wSmasherSlot:
	ld a, [wSmasherSlot]
	and a
;>     return IncrementEntityState(slot)
	jp nz, IncrementEntityState
	ret


;@ def Honeycomb_SpawnBees(slot: c)
;@ path: npc/honeycomb
;@ State 2: five more bees come out, one every 8 frames, numbered 1-5 in their
;@ wEntityPrivateCounter (their place in the swarm); then state 3.
;@ test: skip spawns entities through bank 3
Honeycomb_SpawnBees::
;> if wEntityPrivateCounter[slot] == 5:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
;>     return IncrementEntityState(slot)
	jp z, IncrementEntityState
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .done
;>     bee = SpawnBee()
	call SpawnBee
;>     if bee is not None:
	jr c, .done
;>         wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>         wEntityPrivateCounter[bee] = wEntityPrivateCounter[slot]
	ld a, [hl]
	ld hl, wEntityPrivateCounter
	add hl, de
	ld [hl], a
;>         wEntitySpeedX[bee] = 0
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], b
.done
	ret


;@ def Honeycomb_Idle(slot: c)
;@ path: npc/honeycomb
;@ State 3: nothing; Tarin moves it on to state 4 when he runs off.
;@ test: c = rand(0, 15)
Honeycomb_Idle::
;> return
	ret


;@ def Honeycomb_Fall(slot: c)
;@ path: npc/honeycomb
;@ State 4: after the timer it falls (gravity 2 per frame) to the ground; when Link touches it he
;@ gets it: trade item $06 (the honeycomb), shown above him, and the scene is over.
;@ test: skip checks Link collision and spawns an entity through bank 3
Honeycomb_Fall::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                 # on the ground
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
;>     if EntityTouchesLink():                        # Link touches it
	call EntityTouchesLink
	jr nc, .done
;>         wTradeSceneState = 0
	xor a
	ld [wTradeSceneState], a
;>         wTradeSequenceItem = 0x06
	ld a, $06
	ld [wTradeSequenceItem], a
;>         hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
;>         SpawnHeldItemEntity()
	call SpawnHeldItemEntity
;>         ClearEntityStatus(slot)
	call ClearEntityStatus
.done
	ret


;@ path: npc/honeycomb
;@ The bee: one 8x16 sprite, drawn by DrawEntity8x16; 2 frames of 2 bytes (tile, attributes): tile $72,
;@ then the same flipped upside down (wings flapping).
BeeSprites::
	db $72, $00, $72, $40

;@ def BeeHandler(slot: c)
;@ path: npc/honeycomb
;@ A bee of the honeycomb ($B3 with wEntityPrivate4 = 1), flapping every 4 frames. States
;@ (wEntityState): 0 buzz around the honeycomb, 1 chase Tarin, 2 idle.
;@ test: skip draws sprites through bank 0
BeeHandler::
;> DrawEntity8x16(BeeSprites)
	ld de, BeeSprites
	call DrawEntity8x16
;> frame = (hFrameCounter >> 2) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> return BeeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/honeycomb
;@ States of a bee (wEntityState), see BeeHandler.
BeeStates::
	dw Bee_Buzz
	dw Bee_Chase
	dw Bee_Idle

;@ path: npc/honeycomb
;@ Speed change per step of the buzzing bee, indexed by its current turn direction
;@ (wEntityPrivate1 for x, wEntityPrivate2 for y): +1, -1.
BeeSpeedSteps::
	db $01, $ff

;@ path: npc/honeycomb
;@ The x speed at which a buzzing bee turns around, for turn direction 0 / 1: +$10, -$10.
BeeSpeedXLimits::
	db $10, $f0

;@ path: npc/honeycomb
;@ The y speed at which a buzzing bee turns around, for turn direction 0 / 1: +$0B, -$0B.
BeeSpeedYLimits::
	db $0b, $f5

;@ def Bee_Buzz(slot: c)
;@ path: npc/honeycomb
;@ State 0: on every second frame the x and y speeds swing one step towards their limit and turn
;@ around there, so the bee loops around the honeycomb. When the bees swarm (wSmasherSlot) it
;@ goes after Tarin (state 1).
;@ test: c = rand(0, 15)
Bee_Buzz::
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .move
;>     turn = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>     step = BeeSpeedSteps[turn]
	ld hl, BeeSpeedSteps
	add hl, de
	ld a, [hl]
;>     wEntitySpeedX[slot] = (wEntitySpeedX[slot] + step) & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a
;>     if wEntitySpeedX[slot] == BeeSpeedXLimits[turn]:
	ld hl, BeeSpeedXLimits
	add hl, de
	cp [hl]
	jr nz, .yAxis
;>         wEntityPrivate1[slot] ^= 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
.yAxis
;>     turn = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld e, [hl]
	ld d, b
;>     step = BeeSpeedSteps[turn]
	ld hl, BeeSpeedSteps
	add hl, de
	ld a, [hl]
;>     wEntitySpeedY[slot] = (wEntitySpeedY[slot] + step) & 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
	ld [hl], a
;>     if wEntitySpeedY[slot] == BeeSpeedYLimits[turn]:
	ld hl, BeeSpeedYLimits
	add hl, de
	cp [hl]
	jr nz, .move
;>         wEntityPrivate2[slot] ^= 1
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
.move
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> if wSmasherSlot:                           # the swarm goes after Tarin
	ld a, [wSmasherSlot]
	and a
;>     return IncrementEntityState(slot)
	jp nz, IncrementEntityState
	ret


;@ path: npc/honeycomb
;@ Where each bee of the swarm flies relative to Tarin: x offsets (signed pixels), 6 bees for each
;@ of Tarin's directions (index = direction * 6 + bee number; directions 0 right, 1 left, 2 up,
;@ 3 down). The bees trail 16-40 pixels behind him in a zigzag.
BeeSwarmOffsetX::
	db $f0, $e8, $e8, $e0, $e0, $d8, $10, $18, $18, $20, $20, $28, $00, $f8, $08, $f8
	db $08, $00, $00, $08, $f8, $08, $f8, $00

;@ path: npc/honeycomb
;@ The y offsets of the swarm, laid out like BeeSwarmOffsetX.
BeeSwarmOffsetY::
	db $00, $f8, $08, $f8, $08, $00, $00, $08
	db $f8, $08, $f8, $00, $10, $18, $18, $20, $20, $28, $f0, $e8, $e8, $e0, $e0, $d8

;@ def Bee_Chase(slot: c)
;@ path: npc/honeycomb
;@ State 1: buzzes (jingle $22) and, on its own frame of every 8 (its bee number), steers at speed
;@ $24 towards its place in the swarm behind Tarin. When Tarin is gone, the bee is too.
;@ test: skip aims through a bank 3 routine
Bee_Chase::
;> hJingle = 0x22
	ld a, $22
	ldh [hJingle], a
;> tarin = wTarinSlot
	ld a, [wTarinSlot]
	ld e, a
	ld d, b
;> if wEntityStatus[tarin] == 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
;>     return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;> if hFrameCounter & 7 == wEntityPrivateCounter[slot]:
	ldh a, [hFrameCounter]
	and $07
	ld hl, wEntityPrivateCounter
	add hl, bc
	cp [hl]
	jr nz, .move
;>     dir = wEntityDirection[tarin]
	ld a, [wTarinSlot]
	ld e, a
	ld d, b
	ld hl, wEntityDirection
	add hl, de
	ld a, [hl]
;>     four = (dir * 4) & 0xFC
	ld e, a
	ld hl, wEntityPrivateCounter
	add hl, bc
	rla
	rla
	and $fc
;>     i = four + dir * 2 + wEntityPrivateCounter[slot]     # dir * 6 + bee number
	add e
	add e
	add [hl]
	ld e, a
	ld d, b
;>     saved_x = hLinkX
	ldh a, [hLinkX]
	push af
;>     saved_y = hLinkY
	ldh a, [hLinkY]
	push af
;>     dx = BeeSwarmOffsetX[i]
	push bc
	ld a, [wTarinSlot]
	ld c, a
	ld hl, BeeSwarmOffsetX
	add hl, de
	ld a, [hl]
;>     hLinkX = (wEntityX[tarin] + dx) & 0xFF   # the aiming routine aims at Link's position
	ld hl, wEntityX
	add hl, bc
	add [hl]
	ldh [hLinkX], a
;>     dy = BeeSwarmOffsetY[i]
	ld hl, BeeSwarmOffsetY
	add hl, de
	ld a, [hl]
;>     hLinkY = (wEntityY[tarin] + dy) & 0xFF
	ld hl, wEntityY
	add hl, bc
	add [hl]
	ldh [hLinkY], a
	pop bc
;>     SetEntitySpeedTowardsLink(0x24)                           # set the speed towards that point
	ld a, $24
	call SetEntitySpeedTowardsLink
;>     hLinkY = saved_y
	pop af
	ldh [hLinkY], a
;>     hLinkX = saved_x
	pop af
	ldh [hLinkX], a
.move
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
	ret


;@ def Bee_Idle(slot: c)
;@ path: npc/honeycomb
;@ State 2: nothing.
;@ test: c = rand(0, 15)
Bee_Idle::
;> return
	ret

;@ path: npc/tarin
;@ Tarin in the honeycomb scene, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 9 frames of 4
;@ bytes (tile and attributes of the left half, then of the right half). 0/1 = walking right
;@ (tiles $58-$5E mirrored), 2/3 = walking left, 4/5 = walking up (tiles $54/$56), 6/7 = walking
;@ down (tiles $50/$52), 8 = holding the stick up (tiles $74/$76).
TarinStickSceneSprites::
	db $5a, $20, $58, $20, $5e, $20, $5c, $20, $58, $00, $5a, $00, $5c, $00, $5e, $00
	db $54, $00, $56, $00, $56, $20, $54, $20, $50, $00, $52, $00, $52, $20, $50, $20
	db $74, $00, $76, $00

;@ def TarinHoneycombHandler(slot: c)
;@ path: npc/tarin
;@ Entity $B4, Tarin under the honeycomb tree on Ukuku Prairie (he is there after story flag $DB67
;@ bit 1, and gone once the room's flag hRoomStatus bit 6 is set). Asked, he pokes the honeycomb
;@ down with his stick, the bees come out and chase him round in circles, he runs off the screen
;@ and the honeycomb drops. He has gravity (height speed -2 per frame). Keeps his slot in
;@ wTarinSlot for the bees. States (wEntityState): 0 wait, 1 answer, 2 raise the stick, 3 poke,
;@ 4 flee, 5 run off, 6 leave.
;@ test: skip draws sprites through bank 0
TarinHoneycombHandler::
;> wTarinSlot = slot
	ld a, c
	ld [wTarinSlot], a
;> if hRoomStatus & 0x40:
	ldh a, [hRoomStatus]
	and $40
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;> if not mem[0xDB67] & 0x02:
	ld a, [$db67]
	and $02
;>     return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;> DrawEntity16x16(TarinStickSceneSprites)
	ld de, TarinStickSceneSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                  # on the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .dispatch
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.dispatch
;> return TarinHoneycombStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/tarin
;@ States of Tarin in the honeycomb scene (wEntityState), see TarinHoneycombHandler.
TarinHoneycombStates::
	dw TarinHoneycomb_Wait
	dw TarinHoneycomb_Answer
	dw TarinHoneycomb_RaiseStick
	dw TarinHoneycomb_Poke
	dw TarinHoneycomb_Flee
	dw TarinHoneycomb_RunOff
	dw TarinHoneycomb_Leave

;@ def TarinHoneycomb_Wait(slot: c)
;@ path: npc/tarin
;@ State 0: stands at ($60, $58) facing left; talked to he asks whether to get the honeycomb down
;@ (text $C0, state 1).
;@ test: skip opens dialogue through another bank
TarinHoneycomb_Wait::
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
;> wEntityX[slot] = 0x60
	ld hl, wEntityX
	add hl, bc
	ld [hl], $60
;> wEntityY[slot] = 0x58
	ld hl, wEntityY
	add hl, bc
	ld [hl], $58
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> if ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
	jr nc, .done
;>     OpenDialogTable1(0xC0)
	ld a, $c0
	call OpenDialogTable1
;>     wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def TarinHoneycomb_Answer(slot: c)
;@ path: npc/tarin
;@ State 1: once the question is closed: "yes" starts the scene (wTradeSceneState = 2, bit 6 of
;@ overworld room $87's flags, jingle 1, $A0 frames, state 2); "no" gives text $C2 and back to
;@ state 0.
;@ test: skip opens dialogue through another bank
TarinHoneycomb_Answer::
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done
;> if wDialogAnswer == 0:                    # "yes"
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>     wTradeSceneState = 2
	ld a, $02
	ld [wTradeSceneState], a
;>     mem[0xD887] |= 0x40
	ld hl, $d887
	set 6, [hl]
;>     wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;>     hJingle = 1
	ld a, $01
	ldh [hJingle], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.no
;> OpenDialogTable1(0xC2)
	ld a, $c2
	call OpenDialogTable1
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.done
	ret


;@ path: npc/tarin
;@ Tarin's stick (same format as TarinStickSceneSprites): frame 0 = held upright (tile $78 and an
;@ empty right half, tile $FF), frame 1 = pointing sideways (tiles $7A/$7C).
TarinStickSprites::
	db $78, $00, $ff, $00, $7a, $00, $7c, $00

;@ def TarinHoneycomb_RaiseStick(slot: c)
;@ path: npc/tarin
;@ State 2 (Link frozen): for $70 frames Tarin holds the stick over his head (frame 8, the stick 16
;@ pixels up); then he holds it sideways (frames 2/3) and for the last $18 frames walks up and to
;@ the left with Link watching. Then the scene music $34 starts and state 3 gets $C0 frames.
;@ test: skip draws sprites through bank 0
TarinHoneycomb_RaiseStick::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 1
	ld [wLinkFrozen], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t >= 0x30:
	cp $30
	jr c, .lowered
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     hActiveEntityDrawY -= 0x10
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
;>     DrawEntity16x16(TarinStickSprites)        # the stick above his head
	ld de, TarinStickSprites
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
;>     return SetEntitySpriteVariant(slot, 8)
	ld a, $08
	call SetEntitySpriteVariant
	ret

.lowered
;> if t < 0x18:
	cp $18
	jr nc, .sideways
;>     hLinkDirection = 2                   # Link looks up
	ld a, $02
	ldh [hLinkDirection], a
;>     wEntitySpeedX[slot] = 0xFE
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $fe
;>     wEntitySpeedY[slot] = 0xF4
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f4
;>     UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;>     if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .sideways
;>         wMusicTrackToPlay = 0x34
	ld a, $34
	ld [wMusicTrackToPlay], a
;>         hDefaultMusicTrack = 0x34
	ldh [hDefaultMusicTrack], a
;>         wEntityTimer[slot] = 0xC0
	call GetEntityTimer
	ld [hl], $c0
;>         return IncrementEntityState(slot)
	call IncrementEntityState
	ret

.sideways
;> hActiveEntitySpriteVariant = 1
	ld a, $01
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityX -= 0x0C
	ldh a, [hActiveEntityX]
	sub $0c
	ldh [hActiveEntityX], a
;> DrawEntity16x16(TarinStickSprites)            # the stick held out to the left
	ld de, TarinStickSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> frame = ((t >> 4) & 1) + 2
	rra
	rra
	rra
	rra
	and $01
	add $02
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def TarinHoneycomb_Poke(slot: c)
;@ path: npc/tarin
;@ State 3 ($C0 frames): Tarin pokes the honeycomb, swinging the stick every $20 frames. At timer
;@ $A0 the honeycomb starts shaking, at $60 the bees swarm (wSmasherSlot), at $20 Tarin jumps
;@ (height speed $18, jingle $24). Then he flees (state 4).
;@ test: skip draws sprites through bank 0
TarinHoneycomb_Poke::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .events
;>     wEntityTimer[slot] = 0x0C
	ld [hl], $0c
;>     wEntityState[slot] += 1
	call IncrementEntityState
.events
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0x20:
	cp $20
	jr nz, .not20
;>     wEntitySpeedZ[slot] = 0x18          # jumps in fright
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;>     PlayJingle24()
	call PlayJingle24
;>     t = 0
	xor a
.not20
;> if t == 0x60:
	cp $60
	jr nz, .not60
;>     wSmasherSlot += 1                    # the bees swarm out
	ld hl, wSmasherSlot
	inc [hl]
.not60
;> if t == 0xA0:
	cp $a0
	jr nz, .stick
;>     wEntityTimer[wSmasherBallSlot] = 0xA0   # the honeycomb shakes
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $a0
.stick
;> if t & 0x20:                            # stick swung up against the honeycomb
	and $20
	jr z, .stickUp
;>     hActiveEntitySpriteVariant = 1
	ld a, $01
	ldh [hActiveEntitySpriteVariant], a
;>     hActiveEntityX -= 0x0E
	ldh a, [hActiveEntityX]
	sub $0e
	ldh [hActiveEntityX], a
;>     hActiveEntityDrawY -= 8
	ldh a, [hActiveEntityDrawY]
	sub $08
	ldh [hActiveEntityDrawY], a
	jr .draw
;> else:
.stickUp
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     hActiveEntityDrawY -= 0x10
	ldh a, [hActiveEntityDrawY]
	sub $10
	ldh [hActiveEntityDrawY], a
.draw
;> DrawEntity16x16(TarinStickSprites)
	ld de, TarinStickSprites
	call DrawEntity16x16
;> LoadEntityPosition(slot)
	call LoadEntityPosition
;> frame = 3 if wEntityTimer[slot] & 0x20 else 2
	call GetEntityTimer
	ld e, $02
	and $20
	jr z, .setFrame
	inc e
.setFrame
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ path: npc/tarin
;@ x speed of each leg of Tarin's flight from the bees (leg = wEntityPrivateCounter & 3): right,
;@ none, left, none ($20 = 2 pixels per frame).
TarinFleeSpeedX::
	db $20, $00, $e0, $00

;@ path: npc/tarin
;@ y speed of each leg of Tarin's flight: none, up, none, down.
TarinFleeSpeedY::
	db $00, $e0, $00, $20

;@ path: npc/tarin
;@ Tarin's facing on each leg of his flight (0 right, 2 up, 1 left, 3 down).
TarinFleeDirections::
	db $00, $02, $01, $03

;@ path: npc/tarin
;@ Length in frames of legs 1-11 of Tarin's flight (read at count - 1): $16 for the first, $28 for
;@ the others.
TarinFleeDurations::
	db $16, $28, $28, $28
	db $28, $28, $28, $28, $28, $28, $28, $28

;@ path: npc/tarin
;@ First frame of Tarin's walk for each facing (0 right, 1 left, 2 up, 3 down), into
;@ TarinStickSceneSprites; the second frame is one higher.
TarinRunFrames::
	db $00, $02, $04, $06

;@ def TarinHoneycomb_Flee(slot: c)
;@ path: npc/tarin
;@ State 4: Tarin runs round in a square with the bees behind him - right, up, left, down - for
;@ ten legs while Link turns to watch him; then he runs off (state 5).
;@ test: skip
TarinHoneycomb_Flee::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> if wEntityTimer[slot] == 0:               # next leg
	call GetEntityTimer
	jr nz, .run
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntityPrivateCounter[slot] == 0x0B:
	cp $0b
;>         return IncrementEntityState(slot)
	jp z, IncrementEntityState
;>     duration = TarinFleeDurations[wEntityPrivateCounter[slot] - 1]
	ld e, a
	ld d, b
	ld hl, TarinFleeDurations - 1
	add hl, de
	ld e, [hl]
;>     wEntityTimer[slot] = duration
	call GetEntityTimer
	ld [hl], e
.run
;> leg = wEntityPrivateCounter[slot] & 3
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	and $03
	ld e, a
	ld d, b
;> wEntitySpeedX[slot] = TarinFleeSpeedX[leg]
	ld hl, TarinFleeSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = TarinFleeSpeedY[leg]
	ld hl, TarinFleeSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> wEntityDirection[slot] = TarinFleeDirections[leg]
	ld hl, TarinFleeDirections
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> link_dir = GetEntityDirectionToLink(slot) ^ 1     # Link turns towards Tarin
	call GetEntityDirectionToLink
	ld a, e
	xor $01
;>@run return TarinHoneycombRunAnimation(link_dir)   # face Link, move, walk frames
TarinHoneycombRunAnimation:
	ldh [hLinkDirection], a
	call UpdateEntityPosWithSpeed
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;=@run
	ld hl, TarinRunFrames
	add hl, de
	ldh a, [hFrameCounter]
	rra
	rra
	rra
;=@run
	and $01
	or [hl]
	jp SetEntitySpriteVariant


;@ def TarinHoneycomb_RunOff(slot: c)
;@ path: npc/tarin
;@ State 5: runs off to the left and down (twice as fast: TarinHoneycombRunAnimation moves him
;@ again), Link facing left. Once he is past the left edge (x $C0-$C3), Link may move again and
;@ state 6 follows.
;@ test: skip
TarinHoneycomb_RunOff::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> wEntityDirection[slot] = 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, $01
	ld [hl], a
;> wEntitySpeedX[slot] = 0xE4
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $e4
;> wEntitySpeedY[slot] = 0x08
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $08
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> if 0xC0 <= hActiveEntityX < 0xC4:          # wrapped past the left edge
	ldh a, [hActiveEntityX]
	cp $c0
	jr c, .animate
	cp $c4
	jp nc, .animate
;>     wLinkFrozen = 0
	xor a
	ld [wLinkFrozen], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
.animate
;> return TarinHoneycombRunAnimation(1)      # Link faces left
	ld a, $01
	jr TarinHoneycombRunAnimation

;@ def TarinHoneycomb_Leave(slot: c)
;@ path: npc/tarin
;@ State 6: lets the honeycomb fall (its state 4, after $50 frames, from 16 pixels lower and a
;@ height of 16) and removes Tarin.
;@ test: skip
TarinHoneycomb_Leave::
;> comb = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;> wEntityState[comb] += 1
	ld hl, wEntityState
	add hl, de
	inc [hl]
;> wEntityTimer[comb] = 0x50
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $50
;> wEntityY[comb] += 0x10
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	add $10
	ld [hl], a
;> wEntityZ[comb] = 0x10
	ld hl, wEntityZ
	add hl, de
	ld [hl], $10
;> return ClearEntityStatus(slot)
	jp ClearEntityStatus


;@ path: object/hole_filler
;@ The hole filler block, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 2 frames of 4 bytes
;@ (tile and attributes of the left half, then of the right half), tile $40 or $42 with its mirror
;@ image, switching every 16 frames.
HoleFillerSprites::
	db $40, $00, $40, $20, $42, $00, $42, $20

;@ def HoleFillerHandler(slot: c)
;@ path: object/hole_filler
;@ Entity $B1, a block that fills holes. Link pushes it for 16 frames to set it rolling away from
;@ him; while it rolls he cannot move and steers it with the D-pad (any way but straight back).
;@ Every tile it rolls onto becomes floor; it rolls on as long as the next tile is a hole
;@ (physics $50/$51) or of physics $0B, otherwise it vanishes in a puff. If the room's event is
;@ "fill all holes" ($0E) and no hole is left, the event fires. States (wEntityState): 0 wait,
;@ 1 roll.
;@ test: skip draws sprites through bank 0
HoleFillerHandler::
;> DrawEntity16x16(HoleFillerSprites)
	ld de, HoleFillerSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> frame = (hFrameCounter >> 4) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> return HoleFillerStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/hole_filler
;@ States of the hole filler (wEntityState), see HoleFillerHandler.
HoleFillerStates::
	dw HoleFiller_Wait
	dw HoleFiller_Roll

;@ path: object/hole_filler
;@ x speed of the rolling block for each direction (0 right, 1 left, 2 up, 3 down), signed 1/16
;@ pixel per frame: half a pixel per frame.
HoleFillerSpeedX::
	db $08, $f8, $00, $00

;@ path: object/hole_filler
;@ y speed of the rolling block for each direction (0 right, 1 left, 2 up, 3 down).
HoleFillerSpeedY::
	db $00, $00, $f8, $08

;@ def HoleFiller_Wait(slot: c)
;@ path: object/hole_filler
;@ State 0: while Link pushes against it (touching it with the D-pad held) Link shows his pushing
;@ pose; after 16 frames of pushing it starts rolling away from him (state 1).
;@ test: skip checks Link collision through bank 3
HoleFiller_Wait::
;> if not PushLinkOutOfEntity() or not hJoypadHeld & 0x0F:
	call PushLinkOutOfEntity
	jr nc, HoleFillerResetPush
	ldh a, [hJoypadHeld]
	and $0f
;>     return HoleFillerResetPush(slot)
	jr z, HoleFillerResetPush
;> wLinkPushingTimer = 1
	ld a, $01
	ld [wLinkPushingTimer], a
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] != 0x10:
	cp $10
;>     return
	jr nz, HoleFiller_Return
;> wEntityState[slot] += 1
	call IncrementEntityState
;> dir = GetEntityDirectionToLink(slot) ^ 1     # away from Link
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
	xor $01
	ld e, a
;> wEntityDirection[slot] = dir
	ld [hl], e
;> HoleFillerSetSpeed(slot, dir)                  # falls through

;@ def HoleFillerSetSpeed(slot: c, dir: e)
;@ path: object/hole_filler
;@ Sets the block's speed for direction dir (HoleFillerSpeedX / HoleFillerSpeedY).
;@ test: c = rand(0, 15); e = rand(0, 3)
HoleFillerSetSpeed::
;> speed = HoleFillerSpeedX[dir]
	ld d, b
	ld hl, HoleFillerSpeedX
	add hl, de
	ld a, [hl]
;> wEntitySpeedX[slot] = speed
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;> speed = HoleFillerSpeedY[dir]
	ld hl, HoleFillerSpeedY
	add hl, de
	ld a, [hl]
;> wEntitySpeedY[slot] = speed
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ret


;@ def HoleFillerResetPush(slot: c)
;@ path: object/hole_filler
;@ Link stopped pushing: the push count starts over.
;@ test: c = rand(0, 15)
HoleFillerResetPush::
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], b
HoleFiller_Return:
	ret


;@ path: object/hole_filler
;@ x offset (pixels) from the tile the block is on to the tile ahead, for each direction (0 right,
;@ 1 left, 2 up, 3 down).
HoleFillerAheadX::
	db $10, $f0, $00, $00

;@ path: object/hole_filler
;@ y offset (pixels) from the block's tile to the tile ahead, for each direction.
HoleFillerAheadY::
	db $00, $00, $f0, $10

;@ def HoleFiller_Roll(slot: c)
;@ path: object/hole_filler
;@ State 1: rolls (Link held still, rolling sound $3E); a D-pad press turns it, except straight
;@ back. Each time it is exactly on a tile, that tile becomes floor (room object $0D, background
;@ tiles $10-$13 drawn through the draw command list), and the tile ahead is looked at: unless it
;@ is a hole or of physics $0B the block vanishes in a puff (effect 2, jingle $2F). With the room
;@ event $0E (fill all holes), the event fires when no hole is left among the room's objects.
;@ test: skip edits the room and draws through bank 0 routines
HoleFiller_Roll::
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> hJingle = 0x3E
	ld a, $3e
	ldh [hJingle], a
;> pad = hJoypadPressed & 0x0F
	ldh a, [hJoypadPressed]
	and $0f
	ld d, a
;> if pad:
	jr z, .move
;>     if pad & 0x03:                          # left or right
	and $03
	jr z, .vertical
;>         new = 0 if pad & 0x01 else 1
	ld e, $00
	and $01
	jr nz, .horizontalDone
	inc e
.horizontalDone
	jr .turn
;>     else:
.vertical
;>         new = 2 if pad & 0x04 else 3
	ld e, $02
	bit 2, d
	jr nz, .turn
	inc e
.turn
;>     if wEntityDirection[slot] ^ new != 1:   # not a reversal
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor e
	cp $01
	jr z, .move
;>         wEntityDirection[slot] = new
	ld [hl], e
.move
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> cx = wEntityX[slot] - 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
;> if (cx | wEntityY[slot]) & 0x0F:             # not exactly on a tile
	ld hl, wEntityY
	add hl, bc
	or [hl]
;>     return
	and $0f
	jp nz, .done
;> hBGPosY = wEntityY[slot] - 0x10
	ld a, [hl]
	sub $10
	ldh [hBGPosY], a
;> hBGPosX = wEntityX[slot] - 8
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub $08
	ldh [hBGPosX], a
;> tile = (hBGPosY & 0xF0) | (hBGPosX >> 4)
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
;> wRoomObjects[tile] = 0x0D                   # the block fills it: floor
	ld e, a
	ld d, b
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $0d
;> GetBGAddress()                              # hBGAddrHigh/Low of that tile
	call GetBGAddress
;> n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize = n + 10
	add $0a
	ld [wDrawCommandsSize], a
;> p = wDrawCommand + n
	ld d, $00
	add hl, de
;>@c1 copy(p, [hBGAddrHigh, hBGAddrLow, 0x81, 0x10, 0x12])   # left column: 2 tiles down
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@c1
	ld a, $10
	ld [hli], a
	ld a, $12
	ld [hli], a
;>@c2 copy(p + 5, [hBGAddrHigh, hBGAddrLow + 1, 0x81, 0x11, 0x13])   # right column
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c2
	ld [hli], a
	ld a, $11
	ld [hli], a
	ld a, $13
	ld [hli], a
;> mem[p + 10] = 0                            # end of the list
	ld [hl], b
;> HoleFillerSetSpeed(slot, wEntityDirection[slot])   # take the new direction
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	call HoleFillerSetSpeed
;> dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;> column = ((hBGPosX + HoleFillerAheadX[dir]) >> 4) & 0x0F
	ld hl, HoleFillerAheadX
	add hl, de
	ldh a, [hBGPosX]
	add [hl]
	swap a
	and $0f
;>@ah ahead = ((hBGPosY + HoleFillerAheadY[dir]) & 0xF0) | column
	push af
	ld hl, HoleFillerAheadY
	add hl, de
	pop af
	ld e, a
	ldh a, [hBGPosY]
;=@ah
	add [hl]
	and $f0
	or e
;>@ph physics = GetObjectPhysics(wRoomObjects[ahead])
	ld e, a
	ld d, b
	ld hl, wRoomObjects
	add hl, de
	ld e, [hl]
	ld d, $01
;=@ph
	call GetObjectPhysics
;> if physics in (0x0B, 0x50, 0x51):          # a hole: keep rolling
	cp $0b
	jr z, .done
	cp $50
	jr z, .done
	cp $51
;>     return
	jr z, .done
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> hJingle = 0x2F
	ld a, $2f
	ldh [hJingle], a
;> puff = AddTransientVfx(2)
	ld a, $02
	call AddTransientVfx
;> wVfxTimer[puff] = 0x0F
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f
;> ClearEntityStatus(slot)
	call ClearEntityStatus
;> if wRoomEvent & 0x0F == 0x0E:               # event: fill all holes
	ld a, [wRoomEvent]
	and $0f
	cp $0e
	jr nz, .done
;>@loop     for obj in wRoomObjectsArea[0:256]:
	push bc
	ld c, b
	ld hl, wRoomObjectsArea
.scan
;>@hole         if GetObjectPhysics(obj) in (0x50, 0x51):
	ld a, [hli]
	push hl
	ld e, a
	ld d, $01
	call GetObjectPhysics
	pop hl
;=@hole
	cp $50
	jr z, .holeLeft
	cp $51
;>             break                     # a hole is left
	jr z, .holeLeft
;=@loop
	dec c
	jr nz, .scan
;>     else:
;>         TriggerRoomEvent()
	call TriggerRoomEvent
.holeLeft
	pop bc
.done
	ret


;@ path: entity/helpers
;@ Direction (0-15, a sixteenth of a turn each) for a vector whose minor axis is the x axis
;@ (hMultiPurpose0) - read by GetDirection16FromVector. 4 quadrants of 8 bytes (quadrant = sign of
;@ x + 2 * sign of y; index within it = |x| / 4). With y positive, direction 0 is straight along y;
;@ 4 is along +x, 8 along -y, 12 along -x.
Direction16Steep::
	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
;@ path: entity/helpers
;@ The same for a vector whose minor axis is y (index within the quadrant = |y| / 4).
Direction16Flat::
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

;@ def GetDirection16FromVector() -> a
;@ path: entity/helpers
;@ Turns the vector (hMultiPurpose0 = y, hMultiPurpose1 = x; signed, length up to about $1F, as
;@ left by the aiming routine SetEntitySpeedTowardsLink) into a direction 0-15 using Direction16Steep /
;@ Direction16Flat.
;@ test: hMultiPurpose0 = rand(0xE1, 0x11E) & 0xFF; hMultiPurpose1 = rand(0xE1, 0x11E) & 0xFF
GetDirection16FromVector::
;> sx = hMultiPurpose0 >> 7
	ldh a, [hMultiPurpose0]
	rlca
	and $01
	ld e, a
;> quadrant = sx | ((hMultiPurpose1 >> 7) << 1)
	ldh a, [hMultiPurpose1]
	rlca
	rla
	and $02
	or e
;> base = quadrant * 8
	rla
	rla
	rla
	and $18
	ld h, a
;> ay = hMultiPurpose1 if hMultiPurpose1 < 0x80 else 0x100 - hMultiPurpose1
	ldh a, [hMultiPurpose1]
	bit 7, a
	jr z, .yPositive
	cpl
	inc a
.yPositive
	ld d, a
;> ax = hMultiPurpose0 if hMultiPurpose0 < 0x80 else 0x100 - hMultiPurpose0
	ldh a, [hMultiPurpose0]
	bit 7, a
	jr z, .xPositive
	cpl
	inc a
.xPositive
;> if ax < ay:
	cp d
	jr nc, .flat
;>     i = base + (ax >> 2)
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;>     return Direction16Steep[i]
	ld hl, Direction16Steep
	add hl, de
	ld a, [hl]
	ret

.flat
;> i = base + (ay >> 2)
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
;> return Direction16Flat[i]
	ld hl, Direction16Flat
	add hl, de
	ld a, [hl]
	ret


;@ def PincerHandler(slot: c)
;@ path: enemy/pincer
;@ Entity $B0, the pincer: a snake-like head that hides in a hole in the floor. When Link comes
;@ within $20 pixels it peeks out, aims at him and lunges out on a neck of three segments, then
;@ pulls back into its hole. It cannot be knocked back. States (wEntityState): 0 init, 1 hidden,
;@ 2 peek and aim, 3 lunge, 4 extended, 5 pull back.
;@ test: skip draws sprites through bank 0
PincerHandler::
;> wEntityGroundStatus[slot] = 0
	ld hl, wEntityGroundStatus
	add hl, bc
	ld [hl], b
;> wEntityRecoilSpeedX[slot] = 0                # no knockback
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], b
;> wEntityRecoilSpeedY[slot] = 0
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], b
;> DrawPincer(slot)
	call DrawPincer
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> return PincerStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/pincer
;@ States of the pincer (wEntityState), see PincerHandler.
PincerStates::
	dw Pincer_Init
	dw Pincer_Hidden
	dw Pincer_Peek
	dw Pincer_Lunge
	dw Pincer_Extended
	dw Pincer_Retract

;@ def Pincer_Init(slot: c)
;@ path: enemy/pincer
;@ State 0: remembers its hole (wEntityPrivate1 = x, wEntityPrivate2 = y).
;@ test: c = rand(0, 15)
Pincer_Init::
;> wEntityPrivate1[slot] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
;> wEntityPrivate2[slot] = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ def Pincer_Hidden(slot: c)
;@ path: enemy/pincer
;@ State 1: hidden in the hole (frame 0, physics bit 6 set). After its rest, Link coming within
;@ $20 pixels on both axes wakes it: $30 frames of peeking (state 2).
;@ test: c = rand(0, 15)
Pincer_Hidden::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityPhysicsFlags[slot] |= 0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	set 6, [hl]
;>     near = (EntityLinkDiffX(slot)[0] + 0x20) & 0xFF < 0x40
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, .done
;>     if near and (EntityLinkDiffY(slot)[0] + 0x20) & 0xFF < 0x40:
	call EntityLinkDiffY
	add $20
	cp $40
	jr nc, .done
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         wEntityState[slot] += 1
	call IncrementEntityState
.done
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
	ret


;@ def Pincer_Peek(slot: c)
;@ path: enemy/pincer
;@ State 2: its eyes show in the hole (frame 1). At timer $10 it aims at Link and picks the head
;@ frame for that direction (wEntityPrivate3 = 2-9, one of 8 directions), leaving the lunge speed
;@ at $18. When the time is up it shows the head and lunges for $18 frames (state 3).
;@ test: skip aims through a bank 3 routine
Pincer_Peek::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .waiting
;>     SetEntitySpriteVariant(slot, wEntityPrivate3[slot])          # the head, looking along the lunge
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	call SetEntitySpriteVariant
;>     wEntityTimer[slot] = 0x18
	call GetEntityTimer
	ld [hl], $18
;>     wEntityPhysicsFlags[slot] &= ~0x40
	ld hl, wEntityPhysicsFlags
	add hl, bc
	res 6, [hl]
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.waiting
;> if t == 0x10:
	cp $10
	jr nz, .eyes
;>     SetEntitySpeedTowardsLink(0x1F)                            # aim at Link (leaves the vector in hMultiPurpose0/1)
	ld a, $1f
	call SetEntitySpeedTowardsLink
;>     wEntityPrivate3[slot] = (GetDirection16FromVector() >> 1) + 2
	call GetDirection16FromVector
	sra a
	add $02
	ld hl, wEntityPrivate3
	add hl, bc
	ld [hl], a
;>     SetEntitySpeedTowardsLink(0x18)                            # the lunge speed
	ld a, $18
	call SetEntitySpeedTowardsLink
.eyes
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
	ret


;@ def Pincer_Lunge(slot: c)
;@ path: enemy/pincer
;@ State 3: shoots out towards Link; when the time is up it stays out $20 frames (state 4).
;@ test: skip checks Link collision through bank 3
Pincer_Lunge::
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .touch
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
.touch
;> EntityCheckHits()                                  # touch damage / weapon hits
	call EntityCheckHits
	ret


;@ def Pincer_Extended(slot: c)
;@ path: enemy/pincer
;@ State 4: stays stretched out until the time is up (then state 5).
;@ test: skip checks Link collision through bank 3
Pincer_Extended::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .touch
;>     wEntityState[slot] += 1
	call IncrementEntityState
.touch
;> EntityCheckHits()
	call EntityCheckHits
	ret


;@ def Pincer_Retract(slot: c)
;@ path: enemy/pincer
;@ State 5: heads back to its hole at speed $10 (aiming at the hole by putting its position in
;@ hLinkX/hLinkY for the aiming routine). Within 2 pixels it snaps into the hole, hides (frame 0)
;@ and rests $20 frames in state 1.
;@ test: skip aims through a bank 3 routine
Pincer_Retract::
;> saved_x = hLinkX
	ldh a, [hLinkX]
	push af
;> saved_y = hLinkY
	ldh a, [hLinkY]
	push af
;> hLinkX = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
;> hLinkY = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x10)                              # aim at the hole
	ld a, $10
	call SetEntitySpeedTowardsLink
;> home = (EntityLinkDiffX(slot)[0] + 2) & 0xFF < 4
	call EntityLinkDiffX
	add $02
	cp $04
	jr nc, .move
;> if home and (EntityLinkDiffY(slot)[0] + 2) & 0xFF < 4:
	call EntityLinkDiffY
	add $02
	cp $04
	jr nc, .move
;>     wEntityX[slot] = hLinkX
	ld hl, wEntityX
	add hl, bc
	ldh a, [hLinkX]
	ld [hl], a
;>     wEntityY[slot] = hLinkY
	ld hl, wEntityY
	add hl, bc
	ldh a, [hLinkY]
	ld [hl], a
;>     SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
.move
;> hLinkY = saved_y
	pop af
	ldh [hLinkY], a
;> hLinkX = saved_x
	pop af
	ldh [hLinkX], a
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckHits()
	call EntityCheckHits
	ret


;@ path: enemy/pincer
;@ The pincer's head, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 10 frames of 4 bytes
;@ (tile and attributes of the left half, then of the right half). 0 = nothing (tile $FF), 1 = eyes
;@ in the hole (tile $6C and its mirror), 2-9 = the open jaws in 8 directions (tiles $60-$68,
;@ flipped as needed).
PincerSprites::
	db $ff, $00, $ff, $20, $6c, $00, $6c, $20, $64, $20, $62, $20, $68, $20, $66, $20
	db $60, $00, $60, $20, $66, $00, $68, $00, $62, $00, $64, $00, $66, $40, $68, $40
	db $60, $40, $60, $60, $68, $60, $66, $60

;@ def DrawPincer(slot: c)
;@ path: enemy/pincer
;@ Draws the head; from state 3 on also the neck: three sprites (tile $6A) evenly spaced between
;@ the hole and the head, written straight into the OAM buffer.
;@ test: skip draws sprites through bank 0
DrawPincer::
;> DrawEntity16x16(PincerSprites)
	ld de, PincerSprites
	call DrawEntity16x16
;> if hActiveEntityState < 3:
	ldh a, [hActiveEntityState]
	cp $03
;>     return
	ret c
;> step_x = (hActiveEntityX - wEntityPrivate1[slot]) >> 2      # signed quarter of the way
	ldh a, [hActiveEntityX]
	ld hl, wEntityPrivate1
	add hl, bc
	sub [hl]
	sra a
	sra a
;> hMultiPurpose0 = step_x
	ldh [hMultiPurpose0], a
;> hMultiPurpose2 = step_x
	ldh [hMultiPurpose2], a
;> step_y = (hActiveEntityDrawY - wEntityPrivate2[slot]) >> 2
	ldh a, [hActiveEntityDrawY]
	ld hl, wEntityPrivate2
	add hl, bc
	sub [hl]
	sra a
	sra a
;> hMultiPurpose1 = step_y
	ldh [hMultiPurpose1], a
;> hMultiPurpose3 = step_y
	ldh [hMultiPurpose3], a
;>@oam oam = 0xC030 + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
;=@oam
	pop de
;>@seg for hMultiPurpose4 in (3, 2, 1):
	ld a, $03
.segment
	ldh [hMultiPurpose4], a
;>     mem[oam] = wEntityPrivate2[slot] + hMultiPurpose1     # y
	ld hl, wEntityPrivate2
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld [de], a
	inc de
;>@x     mem[oam + 1] = wEntityPrivate1[slot] + hMultiPurpose0 + 4   # x
	ld hl, wEntityPrivate1
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	add $04
	ld [de], a
;=@x
	inc de
;>     mem[oam + 2] = 0x6A                        # neck tile
	ld a, $6a
	ld [de], a
	inc de
;>     mem[oam + 3] = 0                           # attributes
	ld a, $00
	ld [de], a
	inc de
;>     oam += 4
;>     hMultiPurpose0 += hMultiPurpose2            # one step further
	ldh a, [hMultiPurpose0]
	ld hl, hMultiPurpose2
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 += hMultiPurpose3
	ldh a, [hMultiPurpose1]
	ld hl, hMultiPurpose3
	add [hl]
	ldh [hMultiPurpose1], a
;=@seg
	ldh a, [hMultiPurpose4]
	dec a
	jr nz, .segment
;> ReserveOAMEntriesFar(3)                                  # account for the 3 sprites
	ld a, $03
	call ReserveOAMEntriesFar
	ret

;@ path: item/trade
;@ Text shown when Link holds up a new trading-sequence item, one byte per item ($01 Yoshi doll ...
;@ $0E magnifying lens), read at wTradeSequenceItem - 1. Texts $44 and $9D are in the first text
;@ table (OpenDialog), all others in the second (OpenDialogTable1).
TradeItemTexts::
	db $44, $29, $82, $cb, $64, $c1, $d0, $74, $6a, $36, $5e, $ec, $f5, $9d

;@ path: item/trade
;@ The trading item, drawn by DrawEntity16x16 as two 8x16 sprites side by side (tile and attributes of the
;@ left half, then of the right half): tiles $9A/$9C with palette OBP1. (The item sprite tiles
;@ themselves are loaded for the current item.)
TradeItemSprites::
	db $9a, $10, $9c, $10

;@ path: item/trade
;@ The stick (tiles $74/$76), drawn instead while Link's trade item is $04 (the bananas).
TradeItemStickSprites::
	db $74, $00, $76, $00

;@ def TradeItemHandler(slot: c)
;@ path: item/trade
;@ Entity $AF, a trading-sequence item. Either it lies in the world until Link touches it, or
;@ SpawnHeldItemEntity puts it on Link after a trade. When touched: the item fanfare (music $10),
;@ Link freezes and holds the item over his head for $68 frames; at timer $10 its text appears
;@ (TradeItemTexts). At the end the room's event flag (bit 5) is set, so it does not come back. In
;@ the outdoor rooms $6B, $7A, $7B and $8B it only shows up once bit 4 of room $7B's flags is set.
;@ test: skip draws sprites, opens dialogue and checks Link collision through other banks
TradeItemHandler::
;>@g if not wIsIndoor and hMapRoom in (0x6B, 0x7A, 0x8B, 0x7B):
	ld a, [wIsIndoor]
	and a
	jr nz, .present
	ldh a, [hMapRoom]
	cp $6b
	jr z, .gated
;=@g
	cp $7a
	jr z, .gated
	cp $8b
	jr z, .gated
;=@g
	cp $7b
	jr nz, .present
.gated
;>     if not mem[0xD87B] & 0x10:
	ld a, [$d87b]
	and $10
;>         return
	ret z
.present
;> if hRoomStatus & 0x20:                   # already taken
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;> sprites = TradeItemStickSprites
	ld de, TradeItemStickSprites
;> if wTradeSequenceItem != 0x04:
	ld a, [wTradeSequenceItem]
	cp $04
	jr z, .draw
;>     if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .normal
;>         hActiveEntityDrawY += 2
	ldh a, [hActiveEntityDrawY]
	add $02
	ldh [hActiveEntityDrawY], a
.normal
;>     sprites = TradeItemSprites
	ld de, TradeItemSprites
.draw
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:                               # lying there
	jr nz, .held
;>     if EntityTouchesLink():                      # Link touches it
	call EntityTouchesLink
	jr nc, .done
;>         wMusicTrackToPlay = 0x10         # item fanfare
	ld a, $10
	ld [wMusicTrackToPlay], a
;>         wLinkFrozen = 0x10
	ld [wLinkFrozen], a
;>         hDefaultMusicTrack = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ldh [hDefaultMusicTrack], a
;>         wEntityTimer[slot] = 0x68
	call GetEntityTimer
	ld a, $68
	ld [hl], a
;>         wLinkPoseLock = 0x68
	ld [wLinkPoseLock], a
;>         return ResetSpinAttackAndDash()
	jp ResetSpinAttackAndDash

.done
;>     return
	ret

.held
;> if t == 0x10:
	cp $10
	jr nz, .countdown
;>     wEntityTimer[slot] -= 1
	dec [hl]
;>     text = TradeItemTexts[wTradeSequenceItem - 1]
	ld a, [wTradeSequenceItem]
	ld e, a
	ld d, b
	ld hl, TradeItemTexts - 1
	add hl, de
	ld a, [hl]
;>     if text in (0x9D, 0x44):
	cp $9d
	jr z, .table0
	cp $44
	jr nz, .table1
.table0
;>         OpenDialog(text)
	call OpenDialog
	jr .opened
;>     else:
.table1
;>         OpenDialogTable1(text)
	call OpenDialogTable1
.opened
;>     t = 0
	xor a
.countdown
;> if t == 1:                               # the end
	dec a
	jr nz, .holdUp
;>     wTradeSceneState = 0
	xor a
	ld [wTradeSceneState], a
;>     wLinkFrozen = 0
	ld [wLinkFrozen], a
;>     status = GetRoomStatusAddress()
	call GetRoomStatusAddress
;>     mem[status] |= 0x20                  # taken: does not come back
	or $20
	ld [hl], a
;>     return ClearEntityStatus(slot)
	jp ClearEntityStatus

.holdUp
;> wEntityX[slot] = hLinkX                  # above Link's head
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;> if hMapRoom == 0xC9:
	ldh a, [hMapRoom]
	cp $c9
	jr nz, .notC9
;>     wLinkSpriteDY = 4
	ld a, $04
	ld [wLinkSpriteDY], a
.notC9
;>@y wEntityY[slot] = hLinkY + wLinkSpriteDY - 0x10
	ld hl, wLinkSpriteDY
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, bc
	sub $10
;=@y
	ld [hl], a
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> hLinkAnimationState = 0x6C               # Link holds the item up
	ld a, $6c
	ldh [hLinkAnimationState], a
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> hLinkDirection = 3                       # facing the player
	ld a, $03
	ldh [hLinkDirection], a
;> wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> wSpinAttackTimer = 0
	ld [wSpinAttackTimer], a
	ret


;@ def GetRoomStatusAddress() -> hl
;@ path: world/room_status
;@ hl = the current room's entry in wRoomStatus (the overworld page, or one of the two indoor
;@ pages; maps $06-$19 use the second one), a = its value.
;@ test: skip returns an address
GetRoomStatusAddress::
;> page = wIsIndoor
	ld hl, wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
;> if 0x06 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .add
	cp $06
	jr c, .add
;>     page += 1
	inc d
.add
;> return wRoomStatus + page * 256 + hMapRoom
	add hl, de
	ld a, [hl]
	ret


;@ path: enemy/winged_octorok
;@ x speed of the walking winged octorok per direction (0 right, 1 left, 2 up, 3 down), signed 1/16
;@ pixel per frame.
WingedOctorokSpeedX::
	db $08, $f8, $00, $00

;@ path: enemy/winged_octorok
;@ y speed of the walking winged octorok per direction.
WingedOctorokSpeedY::
	db $00, $00, $f8, $08

;@ path: enemy/winged_octorok
;@ The winged octorok's body, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 8 frames of 4
;@ bytes (tile and attributes of the left half, then of the right half), two walking frames per
;@ facing: 0/1 down (tiles $50/$52 mirrored), 2/3 up (the same upside down), 4/5 left (tiles
;@ $54-$5A), 6/7 right (mirrored). UpdateWalkFrame picks them.
WingedOctorokSprites::
	db $50, $00, $50, $20, $52, $00, $52, $20
	db $50, $40, $50, $60, $52, $40, $52, $60, $54, $00, $56, $00, $58, $00, $5a, $00
	db $56, $20, $54, $20, $5a, $20, $58, $20

;@ def WingedOctorokHandler(slot: c)
;@ path: enemy/winged_octorok
;@ Entity $AE, the winged octorok. It walks in a random direction (every fourth time towards Link)
;@ for $20-$3F frames, then pauses $10-$1F frames; in a pause facing Link it spits a rock. When
;@ Link swings his sword (item 1) near it and is not behind it, it flutters up and jumps at him
;@ (state 2); a hit makes it pause $40 frames. Gravity pulls it down 1/16 per frame. States
;@ (wEntityState): 0 walk, 1 pause, 2 jump.
;@ test: skip draws sprites and calls entity engine routines in bank 3
WingedOctorokHandler::
;> DrawEntity16x16(WingedOctorokSprites)
	ld de, WingedOctorokSprites
	call DrawEntity16x16
;> DrawWingedOctorokWings(slot)
	call DrawWingedOctorokWings
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> if wEntityIgnoreHitsTimer[slot]:           # was hit
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .physics
;>     wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld a, $01
	ld [hl], a
;>     hActiveEntityState = 1
	ldh [hActiveEntityState], a
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
.physics
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 1
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;> hBGTilesRequestCopy = landed              # (borrowed as a scratch flag for the jump state)
	ldh [hBGTilesRequestCopy], a
;> if landed:
	jr z, .walls
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     wEntityPrivate2[slot] = 0                # wings folded
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
.walls
;> EntityCheckWalls()
	call EntityCheckWalls
;> if hActiveEntityState == 2:
	ldh a, [hActiveEntityState]
	cp $02
;>     return WingedOctorok_Jump(slot)
	jp z, WingedOctorok_Jump
;> if hActiveEntityState != 0:               # pause
	and a
	jr z, .walk
;>     t = wEntityTimer[slot]
	call GetEntityTimer
;>     if t != 0:
	jr z, .newWalk
;>@shoot         if t == 0x0A and GetEntityDirectionToLink(slot) == wEntityDirection[slot]:
	cp $0a
	jr nz, .stand
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld a, e
;=@shoot
	cp [hl]
	jr nz, .stand
;>             WingedOctorokShootRock()
	call WingedOctorokShootRock
.stand
;>         ClearEntitySpeed()                          # stand still
	call ClearEntitySpeed
	jp .dodge
;>     else:
.newWalk
;>         wEntityTimer[slot] = (GetRandomByte() & 0x1F) | 0x20
	call GetRandomByte
	and $1f
	or $20
	ld [hl], a
;>         wEntityState[slot] = 0
	ld hl, wEntityState
	add hl, bc
	ld [hl], $00
;>         wEntityPrivate1[slot] = (wEntityPrivate1[slot] + 1) & 3
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
;>         if wEntityPrivate1[slot] == 0:        # every fourth walk goes towards Link
	cp $00
	jr nz, .randomDir
;>             r = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
	jr .setDir
;>         else:
.randomDir
;>             r = GetRandomByte()
	call GetRandomByte
.setDir
;>         dir = r & 3
	and $03
;>         wEntityDirection[slot] = dir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;>@sx         wEntitySpeedX[slot] = WingedOctorokSpeedX[dir]
	ld e, a
	ld d, b
	ld hl, WingedOctorokSpeedX
	add hl, de
	ld a, [hl]
;=@sx
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>@sy         wEntitySpeedY[slot] = WingedOctorokSpeedY[dir]
	ld hl, WingedOctorokSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;=@sy
	jp .dodge
;> else:                                     # walk
.walk
;>@p     if wEntityCollisions[slot] & 0x0F or wEntityTimer[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, .pause
	call GetEntityTimer
;=@p
	jr nz, .animate
.pause
;>         wEntityTimer[slot] = (GetRandomByte() & 0x0F) | 0x10
	call GetRandomByte
	and $0f
	or $10
	ld [hl], a
;>         wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;>         ClearEntitySpeed()
	call ClearEntitySpeed
.animate
;>     UpdateWalkFrame(slot)
	call UpdateWalkFrame
.dodge
;> if wEntityTimer2[slot] == 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .touch
;>     near = (EntityLinkDiffX(slot)[0] + 0x20) & 0xFF < 0x40
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, .touch
;>     near = near and (EntityLinkDiffY(slot)[0] + 0x20) & 0xFF < 0x40
	call EntityLinkDiffY
	add $20
	cp $40
	jr nc, .touch
;>     if wItemB == 1:                        # sword on B
	ld a, [wItemB]
	cp $01
	jr nz, .swordOnA
;>         swing = hJoypadPressed & 0x20
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .swing
	jr .touch
;>     else:
.swordOnA
;>         swing = wItemA == 1 and hJoypadPressed & 0x10
	ld a, [wItemA]
	cp $01
	jr nz, .touch
	ldh a, [hJoypadPressed]
	and $10
	jr z, .touch
.swing
;>@j     if near and swing and wEntityDirection[slot] ^ 1 != GetEntityDirectionToLink(slot):
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	cp e
;=@j
	jr z, .touch
;>         wEntitySpeedZ[slot] = 0x18              # flutter up
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;>         SetEntitySpeedTowardsLink(0x10)                          # and jump at Link
	ld a, $10
	call SetEntitySpeedTowardsLink
;>         wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>         PlayJingle24()
	call PlayJingle24
;>         return
	ret

.touch
;> EntityCheckHits()                                # touch damage / weapon hits
	call EntityCheckHits
	ret


;@ def WingedOctorok_Jump(slot: c)
;@ path: enemy/winged_octorok
;@ State 2: in the air it flaps its wings (every 4 frames) and faces Link; on landing it pauses
;@ $20 frames (state 1).
;@ test: skip
WingedOctorok_Jump::
;>@w wEntityPrivate2[slot] = (hFrameCounter >> 2) & 1     # wing frame
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	ld hl, wEntityPrivate2
	add hl, bc
;=@w
	ld [hl], a
;> dir = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
;> wEntityDirection[slot] = dir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> UpdateWalkFrame(slot)
	call UpdateWalkFrame
;> if hBGTilesRequestCopy:                    # landed this frame
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .done
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
.done
	ret


;@ path: enemy/winged_octorok
;@ x offset of a spat rock from the octorok, per direction (0 right, 1 left, 2 up, 3 down), pixels.
OctorokRockOffsetX::
	db $08, $f8, $00, $00

;@ path: enemy/winged_octorok
;@ y offset of a spat rock from the octorok, per direction.
OctorokRockOffsetY::
	db $00, $00, $f8, $08

;@ path: enemy/winged_octorok
;@ x speed of a spat rock per direction ($20 = 2 pixels per frame).
OctorokRockSpeedX::
	db $20, $e0, $00, $00

;@ path: enemy/winged_octorok
;@ y speed of a spat rock per direction.
OctorokRockSpeedY::
	db $00, $00, $e0, $20

;@ def WingedOctorokShootRock() -> carry
;@ path: enemy/winged_octorok
;@ Spits a rock (entity $0A, sprite frame 1) in the octorok's direction (hMultiPurpose2 as left by
;@ the spawn routine), a little in front of it, at 2 pixels per frame. Carry if no slot was free.
;@ test: skip spawns an entity through bank 3
WingedOctorokShootRock::
;> rock = SpawnEntity(0x0A)
	ld a, $0a
	call SpawnEntity
;> if rock is None:
;>     return True
	jr c, .done
;> wEntitySpriteVariant[rock] = 1
	push bc
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $01
;> dir = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	ld hl, wEntityDirection
	add hl, de
;> wEntityDirection[rock] = dir
	ld [hl], a
	ld c, a
;>@rx wEntityX[rock] = hMultiPurpose0 + OctorokRockOffsetX[dir]
	ld hl, OctorokRockOffsetX
	add hl, bc
	ldh a, [hMultiPurpose0]
	add [hl]
	ld hl, wEntityX
	add hl, de
;=@rx
	ld [hl], a
;>@ry wEntityY[rock] = hMultiPurpose1 + OctorokRockOffsetY[dir]
	ld hl, OctorokRockOffsetY
	add hl, bc
	ldh a, [hMultiPurpose1]
	add [hl]
	ld hl, wEntityY
	add hl, de
;=@ry
	ld [hl], a
;>@rs wEntitySpeedX[rock] = OctorokRockSpeedX[dir]
	ld hl, OctorokRockSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
;=@rs
	ld [hl], a
;>@rt wEntitySpeedY[rock] = OctorokRockSpeedY[dir]
	ld hl, OctorokRockSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
;=@rt
	ld [hl], a
;> return False
	pop bc
	and a
.done
	ret


;@ path: enemy/winged_octorok
;@ The winged octorok's wings: 2 frames of 2 sprites, each 4 bytes (y offset, x offset, tile,
;@ attributes): tile $22 at x -4 and mirrored at x +$0C. Frame 0 = wings down (flipped upside
;@ down), frame 1 = wings up.
WingedOctorokWingSprites::
	db $00, $fc, $22, $40, $00, $0c, $22, $60, $00, $fc, $22, $00, $00, $0c, $22, $20

;@ def DrawWingedOctorokWings(slot: c)
;@ path: enemy/winged_octorok
;@ Draws the wing frame wEntityPrivate2 (2 sprites of WingedOctorokWingSprites).
;@ test: skip draws sprites through bank 0
DrawWingedOctorokWings::
;>@o offset = (wEntityPrivate2[slot] * 8) & 0xF8
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
;=@o
	and $f8
;> frame = WingedOctorokWingSprites + offset
	ld e, a
	ld d, b
	ld hl, WingedOctorokWingSprites
	add hl, de
;> DrawEntitySprites(frame, 2)
	ld c, $02
	call DrawEntitySprites
	ret


;@ path: npc/kiki
;@ Kiki the monkey (and his friends) facing left, drawn by DrawEntity16x16 as two 8x16 sprites side by
;@ side: 5 frames of 4 bytes (tile and attributes of the left half, then of the right half).
;@ 0/1 = sitting (tiles $78/$7A over $72), 2 = arms up (tile $70), 3 = jumping (tiles $7C/$7E),
;@ 4 = falling (tiles $74/$76).
KikiSprites::
	db $78, $00, $72, $00, $7a, $00, $72, $00, $70, $00, $72, $00, $7c, $00, $7e, $00
	db $74, $00, $76, $00

;@ path: npc/kiki
;@ The same five frames facing right (mirrored).
KikiSpritesRight::
	db $72, $20, $78, $20, $72, $20, $7a, $20, $72, $20, $70, $20
	db $7e, $20, $7c, $20, $76, $20, $74, $20

;@ def KikiHandler(slot: c)
;@ path: npc/kiki
;@ Entity $AD, Kiki the monkey by the river on Kanalet's side (and, in states 7-8, the other
;@ monkeys). With Bow-Wow along he is scared and hops away; otherwise he trades the bananas (trade
;@ item $04) for the stick ($05): he eats them, his six friends come and build a bridge of three
;@ tiles, and they all leave (bit 4 of overworld room $7B's flags; gone once hRoomStatus bit 4 is
;@ set). While wEntityDyingTimer runs the bananas are drawn above his head. Gravity -2 per frame.
;@ States (wEntityState): 0 wait, 1 answer, 2 take the bananas, 3 eat, 4 build the bridge, 5-6 hop
;@ (away from Bow-Wow, or off the screen), 7-8 a friend jumping to its spot, 9 nothing.
;@ test: skip draws sprites through bank 0
KikiHandler::
;> if hRoomStatus & 0x10:
	ldh a, [hRoomStatus]
	and $10
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;>@spr sprites = KikiSprites if wEntityDirection[slot] != 0 else KikiSpritesRight
	ld de, KikiSprites
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .draw
;=@spr
	ld de, KikiSpritesRight
.draw
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> if wEntityDyingTimer[slot]:               # holding the bananas up
	ld hl, wEntityDyingTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .update
;>     hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;>     hActiveEntityDrawY -= 0x0E
	ldh a, [hActiveEntityDrawY]
	sub $0e
	ldh [hActiveEntityDrawY], a
;>     DrawEntity16x16(KikiBananasSprite)
	ld de, KikiBananasSprite
	call DrawEntity16x16
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
;> hBGTilesRequestCopy = landed              # (borrowed as a scratch flag for the hop states)
	ldh [hBGTilesRequestCopy], a
;> if landed:
	jr z, .dispatch
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.dispatch
;> return KikiStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: npc/kiki
;@ States of Kiki and his friends (wEntityState), see KikiHandler.
KikiStates::
	dw Kiki_Wait
	dw Kiki_Answer
	dw Kiki_TakeBananas
	dw Kiki_Eat
	dw Kiki_BuildBridge
	dw Kiki_HopStart
	dw Kiki_Hop
	dw Monkey_JumpToSpot
	dw Monkey_Land
	dw Kiki_Idle

;@ def Kiki_Wait(slot: c)
;@ path: npc/kiki
;@ State 0: with Bow-Wow following Link, Kiki panics (text $60) as soon as he is hit or Link comes
;@ within $18 pixels, and starts hopping about (state 5). Without Bow-Wow see Kiki_WaitNoBowWow.
;@ test: skip opens dialogue through another bank
Kiki_Wait::
;> if wIsBowWowFollowingLink != 1:
	ld a, [wIsBowWowFollowingLink]
	cp $01
;>     return Kiki_WaitNoBowWow(slot)
	jr nz, Kiki_WaitNoBowWow
;> if not wEntityFlashTimer[slot]:
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .panic
;>     if (EntityLinkDiffX(slot)[0] + 0x18) & 0xFF >= 0x30:
	call EntityLinkDiffX
	add $18
	cp $30
;>         return
	jr nc, KikiReturn
;>     if (EntityLinkDiffY(slot)[0] + 0x18) & 0xFF >= 0x30:
	call EntityLinkDiffY
	add $18
	cp $30
;>         return
	jr nc, KikiReturn
.panic
;> wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;> wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;> return KikiSay(0x60)                      # falls into KikiSay
	ld a, $60

;@ def KikiSay(text: a)
;@ path: npc/kiki
;@ Opens text a of the second table with the monkey chatter sound ($14) for the letters.
;@ test: skip opens dialogue through another bank
KikiSay::
;> OpenDialogTable1(text)
	call OpenDialogTable1
;> wDialogSfx = 0x14
	ld a, $14
	ld [wDialogSfx], a
KikiReturn:
	ret


;@ def Kiki_WaitNoBowWow(slot: c)
;@ path: npc/kiki
;@ State 0 without Bow-Wow: Kiki blocks the way and fidgets. Talked to with the bananas (trade item
;@ $04) he asks for them (text $65, state 1); otherwise text $61.
;@ test: skip opens dialogue through another bank
Kiki_WaitNoBowWow::
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> if not ShouldLinkTalkToEntity(slot):
	call ShouldLinkTalkToEntity
;>     return KikiIdleAnimation(slot)
	jr nc, KikiIdleAnimation
;> if wTradeSequenceItem == 0x04:             # the bananas
	ld a, [wTradeSequenceItem]
	cp $04
	jr nz, .chat
;>     KikiSay(0x65)
	ld a, $65
	call KikiSay
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.chat
;> KikiSay(0x61)
	ld a, $61
	call KikiSay
;> KikiIdleAnimation(slot)                    # falls through

;@ def KikiIdleAnimation(slot: c)
;@ path: npc/kiki
;@ Sitting frames 0/1 every 8 frames; every 32 frames he turns round with a 50% chance.
;@ test: skip draws on random numbers
KikiIdleAnimation::
;> frame = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
;> if hFrameCounter & 0x1F == 0 and GetRandomByte() & 1 == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .done
	call GetRandomByte
	and $01
	jr nz, .done
;>     wEntityDirection[slot] ^= 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
.done
	ret


;@ def Kiki_Answer(slot: c)
;@ path: npc/kiki
;@ State 1: once the question is closed: "yes" takes the bananas after $10 frames (state 2); "no"
;@ says text $61 and back to state 0.
;@ test: skip opens dialogue through another bank
Kiki_Answer::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .no
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     return
	ret

.no
;> wEntityState[slot] = 0
	ld [hl], b
;> KikiSay(0x61)
	ld a, $61
	call KikiSay
.done
	ret


;@ def Kiki_TakeBananas(slot: c)
;@ path: npc/kiki
;@ State 2 (Link held): after the wait Kiki holds the bananas up for $80 frames (jingle 1,
;@ state 3).
;@ test: c = rand(0, 15)
Kiki_TakeBananas::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .hold
;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wEntityDyingTimer[slot] = 0x80           # the bananas shown above him
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $80
;>     hJingle = 1
	ld a, $01
	ldh [hJingle], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
.hold
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


;@ path: npc/kiki
;@ The bananas above Kiki's head (same format as KikiSprites): tiles $9A/$9C, palette OBP1 (the trade
;@ item tiles).
KikiBananasSprite::
	db $9a, $10, $9c, $10

;@ def Kiki_Eat(slot: c)
;@ path: npc/kiki
;@ State 3: Kiki eats (frame 3); at timer $10 he calls his friends (text $62). Then the monkey
;@ music ($36) starts and the bridge building takes $80 frames (wEntityDropTimer, state 4).
;@ test: skip opens dialogue through another bank
Kiki_Eat::
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .eating
;>     wMusicTrackToPlay = 0x36
	ld a, $36
	ld [wMusicTrackToPlay], a
;>     hDefaultMusicTrack = 0x36
	ldh [hDefaultMusicTrack], a
;>     wEntityDropTimer[slot] = 0x80
	call GetEntityDropTimer
	ld [hl], $80
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.eating
;> if t == 0x10:
	cp $10
	jr nz, .hold
;>     KikiSay(0x62)
	ld a, $62
	call KikiSay
.hold
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ret


;@ path: npc/kiki
;@ x of the spot each of the 7 helper monkeys jumps to (all $48: they line up in a column).
MonkeySpotX::
	db $48, $48, $48, $48, $48, $48, $48

;@ path: npc/kiki
;@ y of each helper monkey's spot: $18 to $48 in steps of 8.
MonkeySpotY::
	db $18, $20, $28, $30, $38, $40, $48

;@ path: npc/kiki
;@ x where each helper monkey appears.
MonkeyStartX::
	db $00, $78, $28, $58, $40, $30, $60

;@ path: npc/kiki
;@ y where each helper monkey appears ($00 at the top edge or $80 at the bottom).
MonkeyStartY::
	db $00, $00, $80, $80, $00, $80, $00

;@ path: npc/kiki
;@ y (screen pixels) of the three bridge tiles the monkeys lay in column x $40, in the order they
;@ appear.
BridgeRowsY::
	db $10, $30, $20

;@ def Kiki_BuildBridge(slot: c)
;@ path: npc/kiki
;@ State 4 (Link held, $80 frames): every 32 frames a helper monkey jumps in (up to 7, jingle $24)
;@ and heads for its spot; in the last $40 frames every 64 frames one tile of the bridge appears
;@ (background tiles $0C/$1C/$0D/$1D, room objects $DB at column 4, rows 1-3). Near the end Link
;@ gets the stick (trade item $05). At the end: jingle 2, room $7B's flag bit 4, the scene state 1,
;@ the monkeys leave (wMonkeysLeaving) with text $63, and Kiki hops off (state 5, counter 6).
;@ test: skip spawns entities and edits the room through other banks
Kiki_BuildBridge::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> KikiIdleAnimation(slot)
	call KikiIdleAnimation
;> t = wEntityDropTimer[slot]
	call GetEntityDropTimer
;> if t == 0:                                # done
	jr nz, .building
;>     hJingle = 2
	ld a, $02
	ldh [hJingle], a
;>     mem[0xD87B] |= 0x10                    # the bridge stays built
	ld a, [$d87b]
	or $10
	ld [$d87b], a
;>     wTradeSceneState = 1
	ld a, $01
	ld [wTradeSceneState], a
;>     wMonkeysLeaving = 0x63
	ld a, $63
	ld [wMonkeysLeaving], a
;>     KikiSay(0x63)
	call KikiSay
;>     wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>     wEntityPrivateCounter[slot] = 6           # hop off the screen
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $06
;>     return
	ret

.building
;> if t == 1:
	cp $01
	jr nz, .monkeys
;>     wTradeSequenceItem = 0x05              # the stick
	ld a, $05
	ld [wTradeSequenceItem], a
;>     hBGChangeRequest = 0x0D
	ld a, $0d
	ldh [hBGChangeRequest], a
.monkeys
;>@m if hFrameCounter & 0x1F == 0 and wEntityPrivate3[slot] != 7:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .bridge
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
;=@m
	cp $07
	jr z, .bridge
;>     monkey = SpawnEntity(0xAD)
	ld a, $ad
	call SpawnEntity
;>     if monkey is not None:
	jr c, .bridge
;>         PlayJingle24()
	push bc
	call PlayJingle24
;>         n = wEntityPrivate3[slot]
	ld hl, wEntityPrivate3
	add hl, bc
	ld c, [hl]
;>         wEntityPrivate3[slot] += 1
	inc [hl]
;>         wEntityPrivate1[monkey] = MonkeySpotX[n]
	ld hl, MonkeySpotX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], a
;>         wEntityPrivate2[monkey] = MonkeySpotY[n]
	ld hl, MonkeySpotY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, de
	ld [hl], a
;>         wEntityX[monkey] = MonkeyStartX[n]
	ld hl, MonkeyStartX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[monkey] = MonkeyStartY[n]
	ld hl, MonkeyStartY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         wEntityState[monkey] = 7
	ld hl, wEntityState
	add hl, de
	ld [hl], $07
;>         wEntityTimer2[monkey] = 0x80
	ld hl, wEntityTimer2
	add hl, de
	ld [hl], $80
	pop bc
.bridge
;>@b if GetEntityDropTimer() < 0x40 and hFrameCounter & 0x3F == 0 and wEntityPrivate4[slot] < 3:
	call GetEntityDropTimer
	cp $40
	jr nc, .done
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .done
;=@b
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $03
	jr nc, .done
;>     piece = wEntityPrivate4[slot]
	ld e, a
	ld d, b
;>     wEntityPrivate4[slot] += 1
	inc [hl]
;>     hBGPosY = BridgeRowsY[piece]
	ld hl, BridgeRowsY
	add hl, de
	ld a, [hl]
	ldh [hBGPosY], a
;>     hBGPosX = 0x40
	ld a, $40
	ldh [hBGPosX], a
;>     GetBGAddress()
	call GetBGAddress
;>     n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;>     wDrawCommandsSize = n + 10
	add $0a
	ld [wDrawCommandsSize], a
;>     p = wDrawCommand + n
	ld d, $00
	add hl, de
;>@c1     copy(p, [hBGAddrHigh, hBGAddrLow, 0x81, 0x0C, 0x1C])   # left column of the bridge tile
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@c1
	ld a, $0c
	ld [hli], a
	ld a, $1c
	ld [hli], a
;>@c2     copy(p + 5, [hBGAddrHigh, hBGAddrLow + 1, 0x81, 0x0D, 0x1D])   # right column
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c2
	ld [hli], a
	ld a, $0d
	ld [hli], a
	ld a, $1d
	ld [hli], a
;>     mem[p + 10] = 0
	ld [hl], b
;>     wRoomObjects[0x14] = 0xDB                 # the bridge column: rows 1-3 of column 4
	ld hl, wRoomObjects + $14
	ld [hl], $db
;>     wRoomObjects[0x24] = 0xDB
	ld hl, wRoomObjects + $24
	ld [hl], $db
;>     wRoomObjects[0x34] = 0xDB
	ld hl, wRoomObjects + $34
	ld [hl], $db
.done
	ret


;@ def Kiki_HopStart(slot: c)
;@ path: npc/kiki
;@ State 5: waits (fidgeting; arms up while wEntityTimer1 runs), then jumps (state 6). Scared of
;@ Bow-Wow (counter below 5) he leaps towards Bow-Wow at speed $14 with height speed $18; when
;@ leaving (counter 5 and more) he jumps up the screen ($F0) with a random height speed $10-$1F
;@ and x speed +-$10. He faces the way he moves.
;@ test: skip aims through a bank 3 routine
Kiki_HopStart::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return KikiHopWait(slot)
	jr nz, KikiHopWait
;> wEntityState[slot] += 1
	call IncrementEntityState
;> if wEntityPrivateCounter[slot] >= 5:       # leaving
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, .scared
;>@z     wEntitySpeedZ[slot] = (GetRandomByte() & 0x0F) + 0x10
	call GetRandomByte
	and $0f
	add $10
	ld hl, wEntitySpeedZ
	add hl, bc
;=@z
	ld [hl], a
;>@sx     wEntitySpeedX[slot] = 0x10 if wEntitySpeedZ[slot] & 1 == 0 else 0xF0
	ld e, $10
	and $01
	jr z, .setX
	ld e, $f0
.setX
	ld hl, wEntitySpeedX
;=@sx
	add hl, bc
	ld [hl], e
;>     wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
;>     KikiFaceSpeed(slot)
	call KikiFaceSpeed
;>     return
	ret

.scared
;> wEntitySpeedZ[slot] = 0x18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;> saved_x = hLinkX
	ldh a, [hLinkX]
	push af
;> saved_y = hLinkY
	ldh a, [hLinkY]
	push af
;>@bx hLinkX = wEntityX[wBowWowSlot]            # aim at Bow-Wow
	ld a, [wBowWowSlot]
	ld e, a
	ld d, b
	ld hl, wEntityX
	add hl, de
	ld a, [hl]
;=@bx
	ldh [hLinkX], a
;> hLinkY = wEntityY[wBowWowSlot]
	ld hl, wEntityY
	add hl, de
	ld a, [hl]
	ldh [hLinkY], a
;> SetEntitySpeedTowardsLink(0x14)
	ld a, $14
	call SetEntitySpeedTowardsLink
;> hLinkY = saved_y
	pop af
	ldh [hLinkY], a
;> hLinkX = saved_x
	pop af
	ldh [hLinkX], a
;> KikiFaceSpeed(slot)                         # falls through

;@ def KikiFaceSpeed(slot: c)
;@ path: npc/kiki
;@ Faces the monkey the way it moves along x (0 right, 1 left), then shows the waiting frames
;@ (KikiHopWait: fidgeting, or arms up while wEntityTimer1 runs).
;@ test: skip draws on random numbers
KikiFaceSpeed::
;>@d wEntityDirection[slot] = 1 if wEntitySpeedX[slot] & 0x80 else 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	ld e, $00
	and $80
	jr z, .setDir
;=@d
	inc e
.setDir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
KikiHopWait:
;> KikiIdleAnimation(slot)
	call KikiIdleAnimation
;> if GetEntityTimer1() != 0:
	call GetEntityTimer1
	jr z, .done
;>     SetEntitySpriteVariant(slot, 4)
	ld a, $04
	call SetEntitySpriteVariant
.done
	ret


;@ def Kiki_Hop(slot: c)
;@ path: npc/kiki
;@ State 6: in the air (frame 3). Above y 8 he is gone. While scared (counter below 5) walls stop
;@ him. On landing: back to state 5, resting $30-$6F frames - or, when leaving, $10 frames with
;@ $10 frames of arms up.
;@ test: skip draws on random numbers
Kiki_Hop::
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> if hActiveEntityY < 8:                     # off the top of the screen
	ldh a, [hActiveEntityY]
	cp $08
;>     return ClearEntityStatus(slot)
	jp c, ClearEntityStatus
;> if wEntityPrivateCounter[slot] < 5:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, .landing
;>     EntityCheckWalls()
	call EntityCheckWalls
.landing
;> if hBGTilesRequestCopy:                    # landed this frame
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .inAir
;>     wEntityState[slot] = 5
	call IncrementEntityState
	ld [hl], $05
;>     if wEntityPrivateCounter[slot] >= 5:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, .rest
;>         wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>         wEntityTimer1[slot] = 0x10
	call GetEntityTimer1
	ld [hl], $10
;>         return
	ret

.rest
;>     wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
.inAir
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
	ret


;@ def Monkey_JumpToSpot(slot: c)
;@ path: npc/kiki
;@ State 7 (a helper monkey): each time it lands it jumps again towards its spot (wEntityPrivate1/2)
;@ - speed and height speed $10 while just arrived (wEntityTimer2) or leaving, else 8. When the
;@ monkeys leave, the jump goes the opposite way and they vanish below y $90. Frame 2 while moving
;@ down, 4 while moving up.
;@ test: skip aims through a bank 3 routine
Monkey_JumpToSpot::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame
;>     saved_x = hLinkX
	ldh a, [hLinkX]
	push af
;>     saved_y = hLinkY
	ldh a, [hLinkY]
	push af
;>     hLinkX = wEntityPrivate1[slot]          # aim at the spot
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ldh [hLinkX], a
;>     hLinkY = wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ldh [hLinkY], a
;>@sp     speed = 0x10 if wMonkeysLeaving or wEntityTimer2[slot] else 0x08
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [wMonkeysLeaving]
	or [hl]
	ld a, $10
	ld e, $10
;=@sp
	jr nz, .aim
	ld a, $08
	ld e, $08
.aim
;>     SetEntitySpeedTowardsLink(speed)
	push de
	call SetEntitySpeedTowardsLink
	pop de
;>     wEntitySpeedZ[slot] = speed
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], e
;>     if wMonkeysLeaving:                    # run away instead
	ld a, [wMonkeysLeaving]
	and a
	jr z, .restore
;>         wEntitySpeedY[slot] = -hMultiPurpose0 & 0xFF
	ldh a, [hMultiPurpose0]
	ld hl, wEntitySpeedY
	add hl, bc
	cpl
	inc a
	ld [hl], a
;>         wEntitySpeedX[slot] = -hMultiPurpose1 & 0xFF
	ldh a, [hMultiPurpose1]
	ld hl, wEntitySpeedX
	add hl, bc
	cpl
	inc a
	ld [hl], a
;>         if hActiveEntityY >= 0x90:
	ldh a, [hActiveEntityY]
	cp $90
	jr c, .restore
;>             ClearEntityStatus(slot)
	call ClearEntityStatus
.restore
;>     hLinkY = saved_y
	pop af
	ldh [hLinkY], a
;>     hLinkX = saved_x
	pop af
	ldh [hLinkX], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     KikiFaceSpeed(slot)
	call KikiFaceSpeed
.frame
;>@f SetEntitySpriteVariant(slot, 4 if wEntitySpeedY[slot] & 0x80 else 2)
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and $80
	ld a, $02
	jr z, .setFrame
;=@f
	ld a, $04
.setFrame
	call SetEntitySpriteVariant
	ret


;@ def Monkey_Land(slot: c)
;@ path: npc/kiki
;@ State 8: a helper monkey in the air (frame 3); on landing it waits 8 frames in state 7.
;@ test: c = rand(0, 15)
Monkey_Land::
;> if hBGTilesRequestCopy:                   # landed this frame
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .move
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     wEntityState[slot] -= 1
	call IncrementEntityState
	dec [hl]
	dec [hl]
.move
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
	ret


;@ def Kiki_Idle(slot: c)
;@ path: npc/kiki
;@ State 9: nothing.
;@ test: c = rand(0, 15)
Kiki_Idle::
;> return
	ret


;@ path: enemy/blooper
;@ The blooper, drawn by DrawEntity16x16 as two 8x16 sprites side by side: 2 frames of 4 bytes
;@ (tile and attributes of the left half, then of the right half): 0 = drifting (tile $6A and its
;@ mirror), 1 = pushing off (tile $68).
BlooperSprites::
	db $6a, $00, $6a, $20, $68, $00, $68, $20

;@ def BlooperHandler(slot: c)
;@ path: enemy/blooper
;@ Entity $A9, the blooper (a squid of the side-view underwater rooms). It sinks slowly and, when
;@ Link is above it, pushes off upwards towards him in strokes. It cannot leave the water: outside
;@ it (wEntityGroundStatus 0) it is put back where it was this frame. States (wEntityState):
;@ 0 sink, 1 swim up.
;@ test: skip draws sprites and calls entity engine routines in bank 3
BlooperHandler::
;> DrawEntity16x16(BlooperSprites)
	ld de, BlooperSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> if wEntityGroundStatus[slot] == 0:          # out of the water
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .inWater
;>     wEntityDyingTimer[slot] = 0x10
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $10
;>     wEntityX[slot] = hActiveEntityX          # undo this frame's move
	ldh a, [hActiveEntityX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
;>     wEntityY[slot] = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
.inWater
;> SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
;> return BlooperStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/blooper
;@ States of the blooper (wEntityState), see BlooperHandler.
BlooperStates::
	dw Blooper_Sink
	dw Blooper_Swim

;@ def Blooper_Sink(slot: c)
;@ path: enemy/blooper
;@ State 0: drifts - the y speed eases towards +4 (sinking), the x speed towards 0. After the rest,
;@ if Link is not below it, it stops and swims up for $25 frames on Link's side (state 1).
;@ test: c = rand(0, 15)
Blooper_Sink::
;> if wEntityTimer[slot] == 0 and EntityLinkDiffY(slot)[1] != 3:   # Link is above
	call GetEntityTimer
	jr nz, .drift
	call EntityLinkDiffY
	ld a, e
	cp $03
	jr z, .drift
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityTimer[slot] = 0x25
	call GetEntityTimer
	ld [hl], $25
;>     dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;>     wEntityDirection[slot] = xdir
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     wEntityState[slot] = 1
	call IncrementEntityState
	ld [hl], $01
;>     return
	ret

.drift
;> if wEntitySpeedY[slot] != 4:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub $04
	jr z, .xSpeed
;>     wEntitySpeedY[slot] += 1 if (wEntitySpeedY[slot] - 4) & 0x80 else -1
	and $80
	jr z, .yDown
	inc [hl]
	inc [hl]
.yDown
	dec [hl]
.xSpeed
;> if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1
	and $80
	jr z, .xDown
	inc [hl]
	inc [hl]
.xDown
	dec [hl]
.done
	ret


;@ path: enemy/blooper
;@ x speed change per stroke for the blooper's direction (0 right: +1, 1 left: -1).
BlooperSwimAccelX::
	db $01, $ff

;@ def Blooper_Swim(slot: c)
;@ path: enemy/blooper
;@ State 1 (frame 1): on every second frame it speeds up upwards by 1 and sideways towards Link by 1;
;@ after the time it drifts again for $40 frames (state 0).
;@ test: c = rand(0, 15)
Blooper_Swim::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .swim
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret

.swim
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .frame
;>     wEntitySpeedY[slot] -= 1
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
;>     dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>     step = BlooperSwimAccelX[dir]
	ld hl, BlooperSwimAccelX
	add hl, de
	ld a, [hl]
;>     wEntitySpeedX[slot] = (wEntitySpeedX[slot] + step) & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a
.frame
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
	ret


;@ def DrawPillarSprites(sprites: hl, count: c)
;@ path: object/tower_pillar
;@ Draws count sprites from a list of 4-byte entries (y offset, x offset, tile, attributes) at the
;@ entity, like DrawEntitySprites, but: the screen shake (wScreenShakeX) is applied, sprites below
;@ y $7E are dropped (y 0), and tile $FF means an empty place (y 0). Then reserves 10 OAM entries
;@ and restores c to the active slot. Nothing when the sprite variant is $FF.
;@ test: skip writes the OAM buffer through pointers
DrawPillarSprites::
;> if hActiveEntitySpriteVariant == 0xFF:
	ldh a, [hActiveEntitySpriteVariant]
	inc a
;>@hid     return wActiveEntitySlot
	jr z, .hidden
;>@oam oam = 0xC030 + wOAMNextIndex
	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
;=@oam
	push hl
	pop de
	pop hl
;>@loop for n in range(count):
.sprite
;>     y = hActiveEntityDrawY + mem[sprites]
	ldh a, [hActiveEntityDrawY]
	add [hl]
;>     if y >= 0x7E:
	cp $7e
	jr c, .yOk
;>         y = 0                               # below the play area: hidden
	xor a
.yOk
;>     mem[oam] = y
	ld [de], a
	inc hl
	inc de
;>@x     mem[oam + 1] = hActiveEntityX + mem[sprites + 1] - wScreenShakeX
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityX]
	add [hl]
	sub c
;=@x
	ld [de], a
	inc hl
	inc de
;>     tile = mem[sprites + 2]
	ldh a, [hActiveEntityTileOffset]
	ld c, a
	ld a, [hli]
;>     mem[oam + 2] = tile + hActiveEntityTileOffset
	push af
	add c
	ld [de], a
;>     if tile == 0xFF:                       # empty place
	pop af
	cp $ff
	jr nz, .tileOk
;>         mem[oam] = 0
	dec de
	xor a
	ld [de], a
	inc de
.tileOk
;>@a     mem[oam + 3] = mem[sprites + 3] ^ hActiveEntityFlipAttribute   # then oam and sprites move on 4 bytes
	pop bc
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
;=@a
	inc de
;
;
;=@loop
	dec c
	jr nz, .sprite
;> c = wActiveEntitySlot
	ld a, [wActiveEntitySlot]
	ld c, a
;> ReserveOAMEntriesFar(10)
	ld a, $0a
	call ReserveOAMEntriesFar
	ret

.hidden
;=@hid
	ld a, [wActiveEntitySlot]
	ld c, a
	ret


;@ path: object/tower_pillar
;@ The crumbling pillar of Eagle's Tower: 5 frames of 10 sprites, each sprite 4 bytes (y offset,
;@ x offset, tile, attributes). A frame is a column two sprites wide of five rows at y 0, -$10,
;@ -$20, -$30, -$40: frame 0 the whole pillar (base tile $4C, shaft $4A, top $48), each later frame
;@ one row lower (tile $FF = empty).
PillarSprites::
	db $00, $00, $4c, $00, $00, $08, $4c, $20, $f0, $00, $4a, $00, $f0, $08, $4a, $20
	db $e0, $00, $4a, $00, $e0, $08, $4a, $20, $d0, $00, $4a, $00, $d0, $08, $4a, $20
	db $c0, $00, $48, $00, $c0, $08, $48, $20, $00, $00, $4a, $00, $00, $08, $4a, $20
	db $f0, $00, $4a, $00, $f0, $08, $4a, $20, $e0, $00, $4a, $00, $e0, $08, $4a, $20
	db $d0, $00, $48, $00, $d0, $08, $48, $20, $c0, $00, $ff, $00, $c0, $08, $ff, $20
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $f0, $00, $4a, $00, $f0, $08, $4a, $20
	db $e0, $00, $48, $00, $e0, $08, $48, $20, $d0, $00, $ff, $00, $d0, $08, $ff, $20
	db $c0, $00, $ff, $00, $c0, $08, $ff, $20, $00, $00, $4a, $00, $00, $08, $4a, $20
	db $f0, $00, $48, $00, $f0, $08, $48, $20, $e0, $00, $ff, $00, $e0, $08, $ff, $20
	db $d0, $00, $ff, $00, $d0, $08, $ff, $20, $c0, $00, $ff, $00, $c0, $08, $ff, $20
	db $00, $00, $48, $00, $00, $08, $48, $20, $f0, $00, $ff, $00, $f0, $08, $ff, $20
	db $e0, $00, $ff, $00, $e0, $08, $ff, $20, $d0, $00, $ff, $00, $d0, $08, $ff, $20
	db $c0, $00, $ff, $00, $c0, $08, $ff, $20

;@ def PillarHandler(slot: c)
;@ path: object/tower_pillar
;@ Entity $A7, a pillar of Eagle's Tower (dungeon 7) that the iron ball can smash; also its dust
;@ puffs (wEntityPrivate1 = 1, PillarDust) and falling debris (wEntityPrivate1 = 2, PillarDebris).
;@ A smashed pillar crumbles away row by row; once four are down (wTowerPillarsDestroyed) the tower's
;@ top floor collapses (the picture game mode 8, then dungeon 7 flag bit 2). It is gone if the
;@ room's event flag (bit 5) is set, or if it is no longer in its own room. States (wEntityState):
;@ 0 standing, 1 shaking, 2 crumbling, 3 the tower shakes, 4 collapse, 5 quake.
;@ test: skip draws sprites and calls entity engine routines in bank 3
PillarHandler::
;> if wEntityPrivate1[slot] == 2:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
;>     return PillarDebris(slot)
	jp z, PillarDebris
;> if wEntityPrivate1[slot] != 0:
	and a
;>     return PillarDust(slot)
	jp nz, PillarDust
;> if hRoomStatus & 0x20:                       # already smashed
	ldh a, [hRoomStatus]
	and $20
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;>@room if not wRoomTransitionState and wEntityRoom[slot] != hMapRoom:
	ld a, [wRoomTransitionState]
	and a
	jr nz, .draw
	ld hl, wEntityRoom
	add hl, bc
	ldh a, [hMapRoom]
;=@room
	cp [hl]
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
.draw
;> if hActiveEntitySpriteVariant < 5:
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nc, .update
;>@off     offset = hActiveEntitySpriteVariant * 40     # 10 sprites of 4 bytes per frame
	rla
	rla
	and $fc
	sla a
	ld e, a
	sla a
;=@off
	sla a
	add e
;>     DrawPillarSprites(PillarSprites + offset, 10)
	ld e, a
	ld d, b
	ld hl, PillarSprites
	add hl, de
	ld c, $0a
	call DrawPillarSprites
.update
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> PushLinkOutOfEntity()
	call PushLinkOutOfEntity
;> return PillarStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/tower_pillar
;@ States of the pillar (wEntityState), see PillarHandler.
PillarStates::
	dw Pillar_Idle
	dw Pillar_Shake
	dw Pillar_Crumble
	dw Pillar_TowerShake
	dw Pillar_Collapse
	dw Pillar_Quake

;@ def Pillar_Idle(slot: c)
;@ path: object/tower_pillar
;@ State 0: stands; the iron ball starts the shaking (state 1, IronBallCheckPillarHit).
;@ test: c = rand(0, 15)
Pillar_Idle::
;> return
	ret


;@ def Pillar_Shake(slot: c)
;@ path: object/tower_pillar
;@ State 1: the screen shakes sideways while the timer runs (Link held still); then it crumbles
;@ (state 2).
;@ test: c = rand(0, 15); wEntityTimer[c] = rand(0, 255)
Pillar_Shake::
;> HoldLinkStill()
	call HoldLinkStill
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
;>     return SetScreenShakeFromTimer(t)
	jr nz, SetScreenShakeFromTimer
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def SetScreenShakeFromTimer(t: a)
;@ path: object/tower_pillar
;@ Shakes the screen sideways: wScreenShakeX = 2 when bit 2 of t is set, else 0.
;@ test: a = rand(0, 255)
SetScreenShakeFromTimer::
;> shake = 2 if t & 0x04 else 0
	ld e, $00
	and $04
	jr z, .set
	ld e, $02
.set
;> wScreenShakeX = shake
	ld a, e
	ld [wScreenShakeX], a
	ret


;@ def Pillar_Crumble(slot: c)
;@ path: object/tower_pillar
;@ State 2: shaking, the pillar loses a row every $20 frames (sprite variant + 1), with debris
;@ falling (3 times in 4) and dust puffing up every 4 frames. When it is gone the pillar count goes
;@ up: at four the whole tower shakes ($20 frames, state 3); otherwise the room's event flag is set
;@ and the pillar removed.
;@ test: skip spawns entities through bank 3
Pillar_Crumble::
;> HoldLinkStill()
	call HoldLinkStill
;> SetScreenShakeFromTimer(hFrameCounter)
	ldh a, [hFrameCounter]
	call SetScreenShakeFromTimer
;> if hFrameCounter & 0x1F == 0:
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .dust
;>     wEntitySpriteVariant[slot] += 1             # one row less
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntitySpriteVariant[slot] == 5:
	cp $05
;>         return PillarGone(slot)
	jp z, PillarGone
;>     if GetRandomByte() & 3:
	call GetRandomByte
	and $03
	jr z, .dust
;>         SpawnPillarDebris()
	call SpawnPillarDebris
.dust
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;>     dust = SpawnEntity(0xA7)
	ld a, $a7
	call SpawnEntity
;>     if dust is not None:
	jr c, .done
;>@dy         wEntityY[dust] = hMultiPurpose1 + (GetRandomByte() & 7) - 4
	call GetRandomByte
	and $07
	sub $04
	ld hl, hMultiPurpose1
	add [hl]
	ld hl, wEntityY
;=@dy
	add hl, de
	ld [hl], a
;>@dx         wEntityX[dust] = hMultiPurpose0 + (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
;=@dx
	add hl, de
	ld [hl], a
;>         wEntityPhysicsFlags[dust] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>         wEntityTimer[dust] = 0x10
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $10
;>         wEntityPrivate1[dust] = 1
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01
.done
	ret

PillarGone:
;> wScreenShakeX = 0                            # PillarGone: the pillar is down
	ld a, $00
	ld [wScreenShakeX], a
;> wTowerPillarsDestroyed += 1
	ld a, [wTowerPillarsDestroyed]
	inc a
	ld [wTowerPillarsDestroyed], a
;> if wTowerPillarsDestroyed >= 4:
	cp $04
	jr c, .notLast
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.notLast
;> MarkRoomEventDone()
	call MarkRoomEventDone
;> return ClearEntityStatus(slot)
	jp ClearEntityStatus


;@ def Pillar_TowerShake(slot: c)
;@ path: object/tower_pillar
;@ State 3 (the fourth pillar): the screen shakes; then the game switches to the picture mode (8)
;@ showing the top of the tower falling, and the pillar waits $20 frames in state 4.
;@ test: skip changes the game mode
Pillar_TowerShake::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .shake
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wGameplayType = 8
	ld a, $08
	ld [wGameplayType], a
;>     wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>     wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>     wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.shake
;> wScreenShakeX = 2 if t & 0x04 else 0
	ld e, $00
	and $04
	jr z, .set
	ld e, $02
.set
	ld a, e
	ld [wScreenShakeX], a
;> HoldLinkStill()                              # falls through

;@ def HoldLinkStill()
;@ path: object/tower_pillar
;@ Keeps Link from moving and holds his pose this frame.
;@ test: skip
HoldLinkStill::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkPoseLock = 2
	ld [wLinkPoseLock], a
	ret


;@ def Pillar_Collapse(slot: c)
;@ path: object/tower_pillar
;@ State 4: after the picture, sets the room's event flag and dungeon 7 flag bit 2 (the tower's top
;@ has fallen) and removes the pillar.
;@ test: skip
Pillar_Collapse::
;> wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .wait
;>     MarkRoomEventDone()
	call MarkRoomEventDone
;>     wDungeon7Flags |= 0x04
	ld hl, wDungeon7Flags
	set 2, [hl]
;>     ClearEntityStatus(slot)
	call ClearEntityStatus
;>     return
	ret

.wait
;> HoldLinkStill()
	call HoldLinkStill
	ret


;@ path: object/tower_pillar
;@ Vertical screen shake of the quake (state 5), pixels, indexed by timer & 7.
PillarQuakeOffsets::
	db $00, $02, $04, $06, $06, $04, $02, $00

;@ def Pillar_Quake(slot: c)
;@ path: object/tower_pillar
;@ State 5, a quake: the screen bobs up and down (PillarQuakeOffsets) while the timer runs, with
;@ rumbling (noise $0C every 8 frames) above $40 and falling debris every 4 frames below $20.
;@ test: skip spawns entities through bank 3
Pillar_Quake::
;> wScreenShakeY = 0
	xor a
	ld [wScreenShakeY], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .quake
;>     return ClearEntityStatus(slot)
	jp ClearEntityStatus

.quake
;>@q wScreenShakeY = PillarQuakeOffsets[t & 7]
	push af
	and $07
	ld e, a
	ld d, b
	ld hl, PillarQuakeOffsets
	add hl, de
;=@q
	ld a, [hl]
	ld [wScreenShakeY], a
;> if t < 0x20 and t & 3 == 0:
	pop af
	cp $20
	jr nc, .rumble
	and $03
	jr nz, .rumble
;>     SpawnPillarDebris()
	call SpawnPillarDebris
;>     t = 0
	xor a
.rumble
;> if t >= 0x40 and t & 7 == 0:
	cp $40
	jr c, .done
	and $07
	jr nz, .done
;>     hNoiseSfx = 0x0C
	ld hl, hNoiseSfx
	ld [hl], $0c
.done
	ret


;@ path: object/tower_pillar
;@ A dust puff, drawn by DrawEntity16x16: 2 frames of 4 bytes (tile and attributes of the left
;@ half, then of the right half): tile $30, then $32, each with its mirror image.
PillarDustSprites::
	db $30, $00, $30, $20, $32, $00, $32, $20

;@ def PillarDust(slot: c)
;@ path: object/tower_pillar
;@ A dust puff of a crumbling pillar ($A7 with wEntityPrivate1 = 1): frame 1 for its last 4 frames,
;@ gone when its timer runs out.
;@ test: skip draws sprites through bank 0
PillarDust::
;> DrawEntity16x16(PillarDustSprites)
	ld de, PillarDustSprites
	call DrawEntity16x16
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;> if t == 4:
	cp $04
	jr nz, .done
;>     SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
.done
	ret


;@ def SpawnPillarDebris()
;@ path: object/tower_pillar
;@ Drops a piece of debris ($A7 with wEntityPrivate1 = 2) from a height of $70 at a random spot up
;@ to 32 pixels around the pillar.
;@ test: skip spawns an entity through bank 3
SpawnPillarDebris::
;> rock = SpawnEntity(0xA7)
	ld a, $a7
	call SpawnEntity
;> if rock is None:
;>     return
	jr c, .done
;> wEntityPrivate1[rock] = 2
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;> wEntityPhysicsFlags[rock] = 0xD1
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $d1
;> wEntityZ[rock] = 0x70
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70
;>@rx wEntityX[rock] = hMultiPurpose0 + (GetRandomByte() & 0x3F) - 0x20
	call GetRandomByte
	and $3f
	sub $20
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
;=@rx
	add hl, de
	ld [hl], a
;>@ry wEntityY[rock] = hMultiPurpose1 + (GetRandomByte() & 0x3F) - 0x20
	call GetRandomByte
	and $3f
	sub $20
	ld hl, hMultiPurpose1
	add [hl]
	ld hl, wEntityY
;=@ry
	add hl, de
	ld [hl], a
.done
	ret


;@ path: object/tower_pillar
;@ A piece of debris, drawn by DrawEntity8x16 as one 8x16 sprite: 2 frames of 2 bytes (tile,
;@ attributes): tile $16, then mirrored.
PillarDebrisSprites::
	db $16, $00, $16, $20

;@ path: object/tower_pillar
;@ Height speed of the debris after each of its 4 bounces.
PillarDebrisBounceSpeeds::
	db $18, $10, $0c, $08

;@ path: object/tower_pillar
;@ x speed of a bouncing piece of debris, one of 4 diagonals chosen at random.
PillarDebrisSpeedX::
	db $0c, $f4, $0c, $f4

;@ path: object/tower_pillar
;@ y speed of a bouncing piece of debris, for the same 4 diagonals.
PillarDebrisSpeedY::
	db $f4, $f4, $0c, $0c

;@ def PillarDebris(slot: c)
;@ path: object/tower_pillar
;@ A piece of debris ($A7 with wEntityPrivate1 = 2): falls (gravity 2), drawn 8 pixels lower, and
;@ bounces off the floor four times, each time lower and in a random diagonal; then it is gone.
;@ wEntityState counts the bounces.
;@ test: skip draws sprites through bank 0
PillarDebris::
;> hActiveEntityDrawY += 8
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hActiveEntityDrawY], a
;> DrawEntity8x16(PillarDebrisSprites)
	ld de, PillarDebrisSprites
	call DrawEntity8x16
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> if wEntityZ[slot] & 0x80:                   # hits the floor
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .done
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     bounce = wEntityState[slot]
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
;>     wEntityState[slot] += 1
	inc [hl]
;>     if bounce == 4:
	cp $04
;>         return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;>@bz     wEntitySpeedZ[slot] = PillarDebrisBounceSpeeds[bounce]
	ld e, a
	ld d, b
	ld hl, PillarDebrisBounceSpeeds
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedZ
;=@bz
	add hl, bc
	ld [hl], a
;>     r = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
;>     wEntitySpeedX[slot] = PillarDebrisSpeedX[r]
	ld hl, PillarDebrisSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
;>     wEntitySpeedY[slot] = PillarDebrisSpeedY[r]
	ld hl, PillarDebrisSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     SetEntitySpriteVariant(slot, r & 1)
	ld a, e
	and $01
	call SetEntitySpriteVariant
.done
	ret


;@ path: object/iron_ball
;@ The iron ball of Eagle's Tower, drawn by DrawEntity16x16: one frame of 4 bytes (tile and
;@ attributes of the left half, then of the right half), tile $4E and its mirror image.
IronBallSprites::
	db $4e, $00, $4e, $20

;@ def IronBallHandler(slot: c)
;@ path: object/iron_ball
;@ Entity $A8, the iron ball in Eagle's Tower (dungeon 7). Link lifts it with the power bracelet
;@ and throws it; it hits enemies, bounces off walls and smashes the tower's pillars ($A7). It
;@ keeps falling and bouncing (gravity 2; each bounce halves the speeds), and while carried it
;@ follows Link from room to room (wIronBallRoom / X / Y remember where it is). States
;@ (wEntityState): 0 lying, 1 carried, 2 thrown.
;@ test: skip draws sprites and calls entity engine routines in bank 3
IronBallHandler::
;> if hActiveEntityStatus == 7:                 # carried by Link
	ldh a, [hActiveEntityStatus]
	cp $07
	jr nz, .draw
;>     if wLinkMotionState == 5:
	ld a, [wLinkMotionState]
	cp $05
	jr nz, .follow
;>         mem[0xC5AE] = 0x10
	ld a, $10
	ld [$c5ae], a
.follow
;>     wEntityRoom[slot] = hMapRoom              # it comes along into the next room
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
.draw
;> DrawEntity16x16(IronBallSprites)
	ld de, IronBallSprites
	call DrawEntity16x16
;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return
	ret nz
;> wIronBallRoom = hMapRoom
	ldh a, [hMapRoom]
	ld [wIronBallRoom], a
;> wIronBallX = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [wIronBallX], a
;> wIronBallY = hActiveEntityY
	ldh a, [hActiveEntityY]
	ld [wIronBallY], a
;> if wDialogState or hActiveEntityStatus == 2:
	ld a, [wDialogState]
	and a
	ret nz
	ldh a, [hActiveEntityStatus]
	cp $02
;>     return
	ret z
;> DecrementEntityIgnoreHitsTimer(slot)
	call DecrementEntityIgnoreHitsTimer
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
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
;> landed = wEntityZ[slot] & 0x80
	and $80
;> hBGTilesRequestCopy = landed                 # (borrowed as a scratch flag for the states)
	ldh [hBGTilesRequestCopy], a
;> if landed:
	jr z, .walls
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     bounce = ~(wEntitySpeedZ[slot] >> 1) & 0xFF   # half the speed, upwards
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
;>     if bounce < 7:
	cp $07
	jr c, .stop
;>         hNoiseSfx = 0x17                     # thud
	push af
	ld a, $17
	ldh [hNoiseSfx], a
	pop af
	jr .setBounce
;>     else:
.stop
;>         bounce = 0
	xor a
.setBounce
;>     wEntitySpeedZ[slot] = bounce
	ld [hl], a
;>     wEntitySpeedX[slot] >>= 1                   # signed halving
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
;>     wEntitySpeedY[slot] >>= 1
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
.walls
;> wEntityIgnoreHitsTimer[slot] = 3
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
;> hActiveEntityFlipAttribute = 3                # (scratch: the wall check is done 3 pixels lower)
	ld e, $03
	ld a, e
	ldh [hActiveEntityFlipAttribute], a
;> wEntityY[slot] += 3
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
;> hActiveEntityY += 3
	ldh a, [hActiveEntityY]
	add e
	ldh [hActiveEntityY], a
;> EntityCheckWalls()
	call EntityCheckWalls
;>@y wEntityY[slot] -= hActiveEntityFlipAttribute
	ldh a, [hActiveEntityFlipAttribute]
	ld e, a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub e
;=@y
	ld [hl], a
;> hActiveEntityY -= hActiveEntityFlipAttribute
	ldh a, [hActiveEntityY]
	sub e
	ldh [hActiveEntityY], a
;> return IronBallStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/iron_ball
;@ States of the iron ball (wEntityState), see IronBallHandler.
IronBallStates::
	dw IronBall_OnGround
	dw IronBall_Held
	dw IronBall_Thrown

;@ def IronBall_OnGround(slot: c)
;@ path: object/iron_ball
;@ State 0: on the ground it slides to a stop (friction 1 per frame). Link touching it with the
;@ power bracelet (item 3) and pressing its button lifts it (status 7, state 2 once thrown).
;@ test: skip checks Link collision through bank 3
IronBall_OnGround::
;> if (hMultiPurposeH - 1) & 0x80:              # on the ground (height 0)
	ldh a, [hMultiPurposeH]
	dec a
	and $80
	jr z, IronBallTryLift
;>     SlowDownEntitySpeed(wEntitySpeedY)
	ld hl, wEntitySpeedY
	call SlowDownEntitySpeed
;>     SlowDownEntitySpeed(wEntitySpeedX)         # falls into the helper
	ld hl, wEntitySpeedX

;@ def SlowDownEntitySpeed(speeds: hl, slot: c)
;@ path: object/iron_ball
;@ Moves the speed speeds[slot] one step towards 0, then goes on with the lifting check
;@ (IronBallTryLift) - so the first of IronBall_OnGround's two calls runs that check too.
;@ test: skip continues into IronBallTryLift
SlowDownEntitySpeed::
;> if mem[speeds + slot] != 0:
	add hl, bc
	ld a, [hl]
	and a
	jr z, IronBallTryLift
;>     mem[speeds + slot] += 1 if mem[speeds + slot] & 0x80 else -1
	and $80
	jr z, .down
	inc [hl]
	inc [hl]
.down
	dec [hl]
;> IronBallTryLift(slot)                         # falls through

;@ def IronBallTryLift(slot: c)
;@ path: object/iron_ball
;@ Link touching the ball with the power bracelet (item 3) and pressing its button lifts it:
;@ status 7 (carried), state 2 (thrown when he lets go).
;@ test: skip checks Link collision through bank 3
IronBallTryLift::
;> if not EntityTouchesLink() or wItemUsePoseTimer:
	call EntityTouchesLink
	jr nc, .done
	ld a, [wItemUsePoseTimer]
	and a
;>     return
	jr nz, .done
;> if wItemB == 3:                             # power bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .tryA
;>     if not hJoypadPressed & 0x20:
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift
;>         return
	jr .done
;> else:
.tryA
;>     if wItemA != 3 or not hJoypadPressed & 0x10:
	ld a, [wItemA]
	cp $03
	jr nz, .done
	ldh a, [hJoypadPressed]
	and $10
;>         return
	jr z, .done
.lift
;> if wLinkIsCarrying:
	ld a, [wLinkIsCarrying]
	and a
;>     return
	jr nz, .done
;> wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;> if hActiveEntityStatus == 7:
	ldh a, [hActiveEntityStatus]
	cp $07
;>     return
	jr z, .done
;> wEntityState[slot] = 2                      # thrown once Link lets go
	call IncrementEntityState
	ld [hl], $02
;> wEntityStatus[slot] = 7                     # carried
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


;@ def IronBall_Held(slot: c)
;@ path: object/iron_ball
;@ State 1: nothing.
;@ test: c = rand(0, 15)
IronBall_Held::
;> return
	ret


;@ def IronBall_Thrown(slot: c)
;@ path: object/iron_ball
;@ State 2, flying: it hits enemies (as weapon $0B) and every pillar it reaches. Hitting a wall it
;@ bounces back at half speed (jingle 7); on landing it lies again (state 0).
;@ test: skip calls entity engine routines in bank 3
IronBall_Thrown::
;> if hBGTilesRequestCopy:                    # landed this frame
	ldh a, [hBGTilesRequestCopy]
	and a
;>     return IronBallStop(slot)
	jr nz, IronBallStop
;> if not wEntityCollisions[slot]:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     return IronBall_Fly(slot)
	jr z, IronBall_Fly
;> IronBallBounceBack(slot)                    # hit a wall: falls through

;@ def IronBallBounceBack(slot: c)
;@ path: object/iron_ball
;@ The ball rebounds: both speeds reversed and halved, jingle 7; then it lies still (IronBallStop:
;@ $C5D0 + slot = $FF, state 0).
;@ test: c = rand(0, 15)
IronBallBounceBack::
;> hJingle = 7
	ld a, $07
	ldh [hJingle], a
;>@bx wEntitySpeedX[slot] = (-wEntitySpeedX[slot] & 0xFF) >> 1     # signed
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
;=@bx
	ld [hl], a
;>@by wEntitySpeedY[slot] = (-wEntitySpeedY[slot] & 0xFF) >> 1
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
;=@by
	ld [hl], a
IronBallStop:
;> mem[0xC5D0 + slot] = 0xFF
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
	ret


;@ def IronBall_Fly(slot: c)
;@ path: object/iron_ball
;@ The thrown ball in flight: it hits enemies (as weapon $0B) and checks every pillar ($A7) in the
;@ room with IronBallCheckPillarHit.
;@ test: skip calls entity engine routines in bank 3
IronBall_Fly::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wProjectileWeaponType = 0x0B
	ld a, $0b
	ld [wProjectileWeaponType], a
;> EntityHitOtherEntities()
	call EntityHitOtherEntities
;>@loop for other in range(15, -1, -1):
	ld e, $0f
	ld d, b
.scan
;>@p     if wEntityStatus[other] and wEntityType[other] == 0xA7:   # a pillar
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;=@p
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $a7
	jr nz, .next
;>         IronBallCheckPillarHit(other)
	push de
	call IronBallCheckPillarHit
	pop de
.next
;=@loop
	dec e
	ld a, e
	cp $ff
	jr nz, .scan
	ret


;@ def IronBallCheckPillarHit(pillar: de, slot: c)
;@ path: object/iron_ball
;@ If the ball (not just bounced, its timer 0) is within 16 pixels across and close above or below
;@ the pillar, it rebounds (noise $25, jingle $0B, $10 frames before the next hit) and a standing
;@ pillar starts shaking (its state 1, timer $50).
;@ test: skip
IronBallCheckPillarHit::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done
;> if (hActiveEntityX - wEntityX[pillar] + 0x10) & 0xFF >= 0x20:
	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $10
	cp $20
;>     return
	jr nc, .done
;> if (hActiveEntityDrawY - wEntityY[pillar] + 0x18) & 0xFF >= 0x28:
	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $18
	cp $28
;>     return
	jr nc, .done
;> IronBallBounceBack(slot)
	call IronBallBounceBack
;> hNoiseSfx = 0x25
	ld a, $25
	ldh [hNoiseSfx], a
;> hJingle = 0x0B
	ld a, $0b
	ldh [hJingle], a
;> wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;> if wEntityState[pillar] == 0:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, .done
;>     wEntityState[pillar] = 1                 # it starts to shake
	inc [hl]
;>     wEntityTimer[pillar] = 0x50
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $50
.done
	ret


;@ path: object/side_view_platform
;@ A weight of the side-view pulley, drawn by DrawEntity16x16: one frame of 4 bytes (tile and
;@ attributes of the left half, then of the right half), tile $50 and its mirror image.
SideViewWeightSprites::
	db $50, $00, $50, $20

;@ def SideViewWeightsHandler(slot: c)
;@ path: object/side_view_platform
;@ Entity $A6, one of two weights hanging on a pulley in a side-view room (the pair is found by
;@ wEntityLoadOrder, which differs only in bit 0). Link standing on one makes it sink at speed $10
;@ while the other rises at $F0 (it gets that speed in wEntityPrivate3); when he steps off both
;@ slow to a stop. Moving down a weight lays chain (room object $4D, background tiles
;@ $44/$54/$45/$55) at each tile, moving up it clears it again (object $04, tile $7E). A wall in
;@ the way stops both.
;@ test: skip draws sprites and edits the room through other banks
SideViewWeightsHandler::
;> DrawEntity16x16(SideViewWeightSprites)
	ld de, SideViewWeightSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> CarryLinkOnPlatform(slot)
	call CarryLinkOnPlatform
;> target = wEntityPrivate3[slot]                 # speed the other weight asks for
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld e, a
;> link_on = wEntityPrivate2[slot] != 0
	and a
	jr nz, .approach
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
;> if target == 0 and link_on:                    # Link just stepped on: this one sinks
	jr z, .release
;>     other = FindOtherWeight(slot)
	call FindOtherWeight
;>     wEntityPrivate3[other] = 0xF0              # the other one rises
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $f0
;>     target = 0x10
	ld e, $10
.approach
;> if target != 0 or link_on:
;>@ap     if hFrameCounter & 1 == 0 and wEntitySpeedY[slot] != target:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .probe
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;=@ap
	sub e
	jr z, .probe
;>         wEntitySpeedY[slot] += 1 if (wEntitySpeedY[slot] - target) & 0x80 else -1
	and $80
	jr z, .down
	inc [hl]
	inc [hl]
.down
	dec [hl]
.probe
;>     wEntityHitboxFlags[slot] = 0x02            # probe the way it is going
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $02
;>     saved_speed = wEntitySpeedY[slot]
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push hl
	push af
;>     wEntitySpeedY[slot] = target
	ld [hl], e
;>     saved_y = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push hl
	push af
;>     EntityCheckWalls()
	call EntityCheckWalls
;>     wEntityY[slot] = saved_y
	pop af
	pop hl
	ld [hl], a
;>     wEntitySpeedY[slot] = saved_speed
	pop af
	pop hl
	ld [hl], a
;>     wEntityHitboxFlags[slot] = 0x30
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $30
;>     if wEntityCollisions[slot]:                # blocked: both stop
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .moved
;>         wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;>         other = FindOtherWeight(slot)
	call FindOtherWeight
;>         wEntitySpeedY[other] = 0
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $00
.moved
	jr .chain
;> else:                                         # nobody on it: slow down
.release
;>     if wEntitySpeedY[slot] != 0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, .stopped
;>         wEntitySpeedY[slot] += 1 if wEntitySpeedY[slot] & 0x80 else -1
	and $80
	jr z, .slower
	inc [hl]
	inc [hl]
.slower
	dec [hl]
.stopped
;>     other = FindOtherWeight(slot)
	call FindOtherWeight
;>     wEntityPrivate3[other] = 0
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $00
.chain
;> if hActiveEntityY & 0x0F != 0:               # chain only on whole tiles
	ldh a, [hActiveEntityY]
	and $0f
	cp $00
;>     return
	jr nz, .done
;> hBGPosY = hActiveEntityY - 0x10
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hBGPosY], a
;> row = hBGPosY & 0xF0
	and $f0
	ld e, a
;> hBGPosX = hActiveEntityX - 8
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
;> tile = row | (hBGPosX >> 4)
	swap a
	and $0f
	or e
	ld e, a
	ld d, b
;> if wEntitySpeedY[slot] == 0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, .done
;> if not wEntitySpeedY[slot] & 0x80:            # moving down: lay chain
	and $80
	jr nz, .up
;>     wRoomObjects[tile] = 0x4D
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $4d
;>     GetBGAddress()
	call GetBGAddress
;>     n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;>     wDrawCommandsSize = n + 10
	add $0a
	ld [wDrawCommandsSize], a
;>     p = wDrawCommand + n
	ld d, $00
	add hl, de
;>@c1     copy(p, [hBGAddrHigh, hBGAddrLow, 0x81, 0x44, 0x54])
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@c1
	ld a, $44
	ld [hli], a
	ld a, $54
	ld [hli], a
;>@c2     copy(p + 5, [hBGAddrHigh, hBGAddrLow + 1, 0x81, 0x45, 0x55])
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c2
	ld [hli], a
	ld a, $45
	ld [hli], a
	ld a, $55
	ld [hli], a
;>     mem[p + 10] = 0
	ld [hl], b
.done
	ret

;> else:                                         # moving up: clear it
.up
;>     wRoomObjects[tile] = 0x04
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $04
;>     GetBGAddress()
	call GetBGAddress
;>     n = wDrawCommandsSize
	ld hl, wDrawCommand
	ld a, [wDrawCommandsSize]
	ld e, a
;>     wDrawCommandsSize = n + 10
	add $0a
	ld [wDrawCommandsSize], a
;>     p = wDrawCommand + n
	ld d, $00
	add hl, de
;>@c3     copy(p, [hBGAddrHigh, hBGAddrLow, 0x81, 0x7E, 0x7E])
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $81
	ld [hli], a
;=@c3
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
;>@c4     copy(p + 5, [hBGAddrHigh, hBGAddrLow + 1, 0x81, 0x7E, 0x7E])
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
;=@c4
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
;>     mem[p + 10] = 0
	ld [hl], b
	ret


;@ def FindOtherWeight(slot: c) -> de
;@ path: object/side_view_platform
;@ Returns in de the slot of the other weight of the pair: the active $A6 whose wEntityLoadOrder
;@ is this one's with bit 0 flipped (de = 16 if there is none).
;@ test: c = rand(0, 15)
FindOtherWeight::
;> hMultiPurpose0 = wEntityLoadOrder[slot] ^ 1
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	xor $01
	ldh [hMultiPurpose0], a
;>@loop for other in range(16):
	ld e, b
	ld d, b
.scan
;>@if     if wEntityStatus[other] and wEntityType[other] == 0xA6 and wEntityLoadOrder[other] == hMultiPurpose0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;=@if
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $a6
	jr nz, .next
;=@if
	ld hl, wEntityLoadOrder
	add hl, de
	ldh a, [hMultiPurpose0]
	cp [hl]
;>         return other
	jr z, .done
.next
;=@loop
	inc e
	ld a, e
	cp $10
	jr nz, .scan
.done
	ret


;@ path: object/side_view_platform
;@ The moving platform of side-view rooms: 4 sprites of 4 bytes (y offset, x offset, tile,
;@ attributes) in a row from x 0 to +$18: tiles $50, $52, $52 mirrored, $50 mirrored.
MovingPlatformSprites::
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20

;@ def MovingPlatformHandler(slot: c)
;@ path: object/side_view_platform
;@ Entities $A3 (moving sideways) and $A4 (moving up and down), the moving platforms of side-view
;@ rooms. Every 4 frames the speed swings one step towards +6 or -6; at the limit the platform turns
;@ and pauses $6A frames. Link standing on it is carried along.
;@ test: skip draws sprites and calls entity engine routines in bank 3
MovingPlatformHandler::
;> DrawEntitySprites(MovingPlatformSprites, 4)
	ld hl, MovingPlatformSprites
	ld c, $04
	call DrawEntitySprites
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> t = wEntityTimer[slot]
	call GetEntityTimer
	ld e, a
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;> if (wEntityPrivateCounter[slot] & 3) or t:
	ld a, [hl]
	and $03
	or e
;>     return CarryLinkOnPlatform(slot)
	jr nz, CarryLinkOnPlatform
;> if hActiveEntityType == 0xA4:
	ldh a, [hActiveEntityType]
	cp $a4
;>     return MovingPlatformVertical(slot)
	jp z, MovingPlatformVertical
;> dir = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>@sx wEntitySpeedX[slot] = (wEntitySpeedX[slot] + PlatformAccel[dir]) & 0xFF
	ld hl, PlatformAccel
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
;=@sx
	ld [hl], a
;> if wEntitySpeedX[slot] == PlatformSpeedLimits[dir]:
	ld hl, PlatformSpeedLimits
	add hl, de
	cp [hl]
	jr nz, CarryLinkOnPlatform
;>     wEntityPrivate1[slot] ^= 1                  # turn
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
;>     wEntityTimer[slot] = 0x6A                   # and pause
	call GetEntityTimer
	ld [hl], $6a
;> CarryLinkOnPlatform(slot)                       # falls through

;@ def CarryLinkOnPlatform(slot: c)
;@ path: object/side_view_platform
;@ Moves the platform by its speed (stopped by walls) and, when Link stands on it (touching it from
;@ above while not jumping up), keeps him on top and moves him along with it; then
;@ wEntityPrivate2 = $10 and wLinkOnPlatform = 1.
;@ test: skip checks Link collision through bank 3
CarryLinkOnPlatform::
;> wEntityPrivate2[slot] = 0
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
;> x0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	push af
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> dx = wEntityX[slot] - x0
	pop af
	ld e, a
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub e
;> hBGTilesRequestCopy = dx                       # (scratch: how far it moved)
	ldh [hBGTilesRequestCopy], a
;> EntityCheckWalls()
	call EntityCheckWalls
;> if EntityTouchesLink() and not hLinkSpeedY & 0x80:
	call EntityTouchesLink
	jr nc, .done
	ldh a, [hLinkSpeedY]
	and $80
	jr nz, .done
;>     dy, ydir = EntityLinkDiffY(slot)
	call EntityLinkDiffY
;>     if (dy + 8) & 0x80:                         # Link is on top
	add $08
	bit 7, a
	jr z, .done
;>         hLinkY = wEntityY[slot] - 0x10
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
;>         saved = hLinkSpeedX
	ldh a, [hLinkSpeedX]
	push af
;>         hLinkSpeedX = hBGTilesRequestCopy
	ldh a, [hBGTilesRequestCopy]
	ldh [hLinkSpeedX], a
;>         hLinkX += hLinkSpeedX                   # ride along
	ld hl, hLinkX
	add [hl]
	ld [hl], a
;>         CheckLinkLeavesRoomFar()                             # Link's wall check for that move (bank 2)
	push bc
	call CheckLinkLeavesRoomFar
	pop bc
;>         hLinkSpeedX = saved
	pop af
	ldh [hLinkSpeedX], a
;>         hLinkSpeedY = 2
	ld a, $02
	ldh [hLinkSpeedY], a
;>         wLinkOnPlatform = 1
	ld a, $01
	ld [wLinkOnPlatform], a
;>         wEntityPrivate2[slot] = 0x10
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $10
.done
	ret


;@ path: object/side_view_platform
;@ Speed change per step for the platform's turn direction (wEntityPrivate1): +1, -1.
PlatformAccel::
	db $01, $ff

;@ path: object/side_view_platform
;@ The speed at which the platform turns, for turn direction 0 / 1: +6, -6.
PlatformSpeedLimits::
	db $06, $fa

;@ def MovingPlatformVertical(slot: c)
;@ path: object/side_view_platform
;@ The $A4 platform's speed step: the same as MovingPlatformHandler, on the y speed.
;@ test: skip checks Link collision through bank 3
MovingPlatformVertical::
;> dir = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
;>@sy wEntitySpeedY[slot] = (wEntitySpeedY[slot] + PlatformAccel[dir]) & 0xFF
	ld hl, PlatformAccel
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;=@sy
	ld [hl], a
;> if wEntitySpeedY[slot] == PlatformSpeedLimits[dir]:
	ld hl, PlatformSpeedLimits
	add hl, de
	cp [hl]
	jr nz, .carry
;>     wEntityPrivate1[slot] ^= 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
;>     wEntityTimer[slot] = 0x6A
	call GetEntityTimer
	ld [hl], $6a
.carry
;> return CarryLinkOnPlatform(slot)
	jp CarryLinkOnPlatform


;@ path: object/side_view_platform
;@ The sinking platform, laid out like MovingPlatformSprites (tiles $50, $52, $52, $50).
SinkingPlatformSprites::
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20

;@ def SinkingPlatformHandler(slot: c)
;@ path: object/side_view_platform
;@ Entity $A5, a platform that sinks under Link (speed up to 4, one step every 4 frames, with a
;@ creak - noise $11 - on the fourth frame). In room $3B it always sinks; elsewhere only while
;@ Link carries something heavy, and then it flashes (wEntityTimer1, tiles offset by 4). Without
;@ Link on it, it stops.
;@ test: skip draws sprites and calls entity engine routines in bank 3
SinkingPlatformHandler::
;> if GetEntityTimer1():
	call GetEntityTimer1
	jr z, .draw
;>     hActiveEntityTileOffset = 4                 # flashing
	ld a, $04
	ldh [hActiveEntityTileOffset], a
.draw
;> DrawEntitySprites(SinkingPlatformSprites, 4)
	ld hl, SinkingPlatformSprites
	ld c, $04
	call DrawEntitySprites
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> CarryLinkOnPlatform(slot)
	call CarryLinkOnPlatform
;> sink = wEntityPrivate2[slot] != 0             # Link stands on it
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, .stop
;> max_speed = 4
	ld e, $04
;> if sink and hMapRoom != 0x3B:
	ldh a, [hMapRoom]
	cp $3b
	jr z, .sink
;>     wEntityTimer1[slot] = 8
	call GetEntityTimer1
	ld [hl], $08
;>     sink = wLinkIsCarrying != 0               # only under a load
	ld a, [wLinkIsCarrying]
	and a
	jr z, .stop
;>     max_speed = 4
	ld e, $04
.sink
;> if sink:
;>     if wEntityPrivate4[slot] != 4:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, .speed
;>         wEntityPrivate4[slot] += 1
	inc [hl]
;>         if wEntityPrivate4[slot] == 4:         # creak
	cp $03
	jr nz, .speed
;>             hNoiseSfx = 0x11
	ld a, $11
	ldh [hNoiseSfx], a
.speed
;>@sp     if hFrameCounter & 3 == 0 and (wEntitySpeedY[slot] - max_speed) & 0x80:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;=@sp
	sub e
	and $80
	jr z, .done
;>         wEntitySpeedY[slot] += 1
	inc [hl]
.done
;>     return
	ret

.stop
;> wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;> wEntityPrivate4[slot] = 0
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
	ret


;@ def PiranhaPlantHandler(slot: c)
;@ path: enemy/piranha_plant
;@ Entity $A2, the piranha plant of the side-view pipes. It hides in its pipe while Link stands
;@ within 16 pixels across; otherwise it rises 32 pixels out of it, snaps for $80 frames and sinks
;@ again. It cannot be knocked back. wEntityPrivate1 keeps the y of the pipe (taken on the first
;@ frame, wEntityPrivate2 = 1). States (wEntityState): 0 hidden, 1 rise, 2 bite, 3 sink.
;@ test: skip draws sprites and calls entity engine routines in bank 3
PiranhaPlantHandler::
;> wEntityRecoilSpeedX[slot] = 0
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], b
;> wEntityRecoilSpeedY[slot] = 0
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], b
;> DrawPiranhaPlant()
	call DrawPiranhaPlant
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> if wEntityPrivate2[slot] == 0:             # first frame
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .update
;>     wEntityPrivate2[slot] = 1
	inc [hl]
;>     wEntityPrivate1[slot] = hActiveEntityY  # the pipe
	ldh a, [hActiveEntityY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
.update
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> return PiranhaPlantStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/piranha_plant
;@ States of the piranha plant (wEntityState), see PiranhaPlantHandler.
PiranhaPlantStates::
	dw PiranhaPlant_Hidden
	dw PiranhaPlant_Rise
	dw PiranhaPlant_Bite
	dw PiranhaPlant_Sink

;@ def PiranhaPlant_Hidden(slot: c)
;@ path: enemy/piranha_plant
;@ State 0: every $40 frames it looks whether Link is at least 16 pixels away across; then it
;@ rises (state 1, $40 frames).
;@ test: c = rand(0, 15)
PiranhaPlant_Hidden::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     if (EntityLinkDiffX(slot)[0] + 0x10) & 0xFF >= 0x20:   # Link not right above / below
	call EntityLinkDiffX
	add $10
	cp $20
	jr c, .done
;>         wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ path: enemy/piranha_plant
;@ Sprite frame of the rising plant for each 8-frame step of the timer, read at (timer >> 3) & 7
;@ while the timer counts down from $40 (so from the end of the table back to the start).
PiranhaRiseFrames::
	db $04, $04, $03, $02, $01, $00, $00, $00

;@ path: enemy/piranha_plant
;@ y offset from the pipe of the rising plant for the same steps (signed pixels; up to -$20).
PiranhaRiseOffsets::
	db $e0, $e0, $e8, $f0, $00, $00, $00, $00

;@ def PiranhaPlant_Rise(slot: c)
;@ path: enemy/piranha_plant
;@ State 1: comes out of the pipe in steps (PiranhaRiseFrames / PiranhaRiseOffsets); then bites for
;@ $80 frames (state 2).
;@ test: skip checks Link collision through bank 3
PiranhaPlant_Rise::
;> EntityCheckHits()
	call EntityCheckHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rising
;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.rising
;> step = (t >> 3) & 7
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;> SetEntitySpriteVariant(slot, PiranhaRiseFrames[step])
	ld hl, PiranhaRiseFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>@y wEntityY[slot] = wEntityPrivate1[slot] + PiranhaRiseOffsets[step]
	ld hl, PiranhaRiseOffsets
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@y
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


;@ def PiranhaPlant_Bite(slot: c)
;@ path: enemy/piranha_plant
;@ State 2: out of the pipe it snaps its jaws (frames 4 and 5, $10 frames each); then it sinks
;@ (state 3, $40 frames).
;@ test: skip checks Link collision through bank 3
PiranhaPlant_Bite::
;> EntityCheckHits()
	call EntityCheckHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .bite
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] += 1
	call IncrementEntityState
.bite
;> frame = 4 if t & 0x10 else 5
	ld e, $04
	and $10
	jr nz, .set
	inc e
.set
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ path: enemy/piranha_plant
;@ Sprite frame of the sinking plant for each 8-frame step, read at (timer >> 3) & 7 (counting
;@ down from $40).
PiranhaSinkFrames::
	db $00, $00, $00, $00, $01, $02, $03, $05

;@ path: enemy/piranha_plant
;@ y offset from the pipe of the sinking plant for the same steps (signed pixels).
PiranhaSinkOffsets::
	db $00, $00, $00, $00, $00, $f0, $e8, $e0

;@ def PiranhaPlant_Sink(slot: c)
;@ path: enemy/piranha_plant
;@ State 3: goes back down into the pipe; then waits hidden (state 0, $40 frames).
;@ test: skip checks Link collision through bank 3
PiranhaPlant_Sink::
;> EntityCheckHits()
	call EntityCheckHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .sinking
;>     wEntityTimer[slot] = 0x40
	ld [hl], $40
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return
	ret

.sinking
;> step = (t >> 3) & 7
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
;> SetEntitySpriteVariant(slot, PiranhaSinkFrames[step])
	ld hl, PiranhaSinkFrames
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
;>@y wEntityY[slot] = wEntityPrivate1[slot] + PiranhaSinkOffsets[step]
	ld hl, PiranhaSinkOffsets
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
;=@y
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


;@ path: enemy/piranha_plant
;@ The piranha plant: 6 frames of 4 sprites, each sprite 4 bytes (y offset, x offset, tile,
;@ attributes; y $FF = unused). 0 = nothing, 1 = leaves at the rim (tile $74, y -$10), 2 = the head
;@ (tile $70), 3 = leaves above and below (tiles $74/$76), 4 = head open over the stem (tiles
;@ $70/$72), 5 = head closed over the stem (tiles $78/$72). Each tile with its mirror image.
PiranhaPlantSprites::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f0, $00, $74, $00, $f0, $08, $74, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $70, $00, $00, $08, $70, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $00, $74, $00, $f8, $08, $74, $20, $08, $00, $76, $00, $08, $08, $76, $20
	db $00, $00, $70, $00, $00, $08, $70, $20, $10, $00, $72, $00, $10, $08, $72, $20
	db $00, $00, $78, $00, $00, $08, $78, $20, $10, $00, $72, $00, $10, $08, $72, $20

;@ def DrawPiranhaPlant()
;@ path: enemy/piranha_plant
;@ Draws frame hActiveEntitySpriteVariant of PiranhaPlantSprites (4 sprites).
;@ test: skip draws sprites through bank 0
DrawPiranhaPlant::
;> offset = (hActiveEntitySpriteVariant * 16) & 0xF0
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
;> frame = PiranhaPlantSprites + offset
	ld e, a
	ld d, b
	ld hl, PiranhaPlantSprites
	add hl, de
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
	ret


;@ path: enemy/goomba
;@ Draw commands (for DrawCommands) that clear the background: 18 commands of 4 bytes, one per row
;@ of the 20x18 screen in the BG map at $9800: address high, address low, $53 (20 tiles, all the
;@ same), tile $7F.
;@ asset: drawcommands
ClearScreenRowCommands::
	db $98, $00, $53, $7f, $98, $20, $53, $7f, $98, $40, $53, $7f, $98, $60, $53, $7f
	db $98, $80, $53, $7f, $98, $a0, $53, $7f, $98, $c0, $53, $7f, $98, $e0, $53, $7f
	db $99, $00, $53, $7f, $99, $20, $53, $7f, $99, $40, $53, $7f, $99, $60, $53, $7f
	db $99, $80, $53, $7f, $99, $a0, $53, $7f, $99, $c0, $53, $7f, $99, $e0, $53, $7f
	db $9a, $00, $53, $7f, $9a, $20, $53, $7f

;@ def ClearScreenAndShowMapText(slot: c)
;@ path: enemy/goomba
;@ The $9F entity with wEntityPrivate1 set: resets the scroll and hides the window, clears the
;@ background two rows per frame (ClearScreenRowCommands); then, when its timer is up, opens text
;@ $50 + map number, sets the normal palette ($E4) and disappears.
;@ test: skip queues draw commands and opens dialogue
ClearScreenAndShowMapText::
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wBGOriginLow = 0
	ld [wBGOriginLow], a
;> wBGOriginHigh = 0
	ld [wBGOriginHigh], a
;> wLCDControl &= ~0x20                       # window off
	ld hl, wLCDControl
	res 5, [hl]
;> if wEntityPrivateCounter[slot] != 9:      # rows still to clear (9 x 2 = 18)
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $09
	jr z, .showText
;>     n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
;>     wDrawCommandsSize = n + 8
	add $08
	ld [wDrawCommandsSize], a
;>@src     src = ClearScreenRowCommands + wEntityPrivateCounter[slot] * 8     # two rows
	ld d, b
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld c, [hl]
;>     wEntityPrivateCounter[slot] += 1
	inc [hl]
;=@src
	sla c
	sla c
	sla c
	ld hl, ClearScreenRowCommands
	add hl, bc
;=@src
	push hl
	pop bc
;>     dst = wDrawCommand + n
	ld hl, wDrawCommand
	add hl, de
;>     for i in range(8):
	ld e, $08
.copy
;>         mem[dst + i] = mem[src + i]
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, .copy
;>     mem[dst + 8] = 0
	ld [hl], b
	pop bc
;>     return
	ret

.showText
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz
;> OpenDialogTable1(hMapId + 0x50)
	ldh a, [hMapId]
	add $50
	call OpenDialogTable1
;> wBGPalette = 0xE4
	ld a, $e4
	ld [wBGPalette], a
;> return ClearEntityStatus(slot)
	jp ClearEntityStatus


;@ path: enemy/goomba
;@ The goomba, drawn by DrawEntity16x16: 3 frames of 4 bytes (tile and attributes of the left
;@ half, then of the right half): 0/1 = walking (tiles $4A/$4C, the second mirrored), 2 =
;@ squashed flat (tile $4E).
GoombaSprites::
	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

;@ def GoombaHandler(slot: c)
;@ path: enemy/goomba
;@ Entity $9F, the goomba. In top view it wanders (pause, walk); in side view it walks towards Link
;@ and falls with gravity, turning at walls. Jumped on it is squashed (state 2) and leaves a heart
;@ ($2D). With wEntityPrivate1 set this entity instead clears the screen and shows a text
;@ (ClearScreenAndShowMapText). States (wEntityState): 0 pause, 1 walk, 2 squashed.
;@ test: skip draws sprites and calls entity engine routines in bank 3
GoombaHandler::
;> if wEntityPrivate1[slot] != 0:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
;>     return ClearScreenAndShowMapText(slot)
	jp nz, ClearScreenAndShowMapText
;> DrawEntity16x16(GoombaSprites)
	ld de, GoombaSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
;>     return GoombaSideView(slot)
	jp nz, GoombaSideView
;> return GoombaStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/goomba
;@ States of the top-view goomba (wEntityState), see GoombaHandler.
GoombaStates::
	dw Goomba_Pause
	dw Goomba_Walk
	dw Goomba_Squashed

;@ path: enemy/goomba
;@ x speed of the walking goomba per direction (0 right, 1 left, 2 up, 3 down), 1/16 pixel per frame.
GoombaSpeedX::
	db $08, $f8, $00, $00

;@ path: enemy/goomba
;@ y speed of the walking goomba per direction.
GoombaSpeedY::
	db $00, $00, $f8, $08

;@ def Goomba_Pause(slot: c)
;@ path: enemy/goomba
;@ State 0: stands; after the pause it walks $30-$6F frames in a random direction (every fourth
;@ time towards Link).
;@ test: skip draws on random numbers
Goomba_Pause::
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> GoombaTouchLink()
	call GoombaTouchLink
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate
;>     wEntityTimer[slot] = (GetRandomByte() & 0x3F) + 0x30
	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
;>     wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntityPrivateCounter[slot] == 4:
	cp $04
	jr nz, .random
;>         wEntityPrivateCounter[slot] = 0
	ld [hl], b
;>         dir = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
	jr .setDir
;>     else:
.random
;>         dir = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
.setDir
;>@sx     wEntitySpeedX[slot] = GoombaSpeedX[dir]
	ld d, b
	ld hl, GoombaSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
;=@sx
	ld [hl], a
;>     wEntitySpeedY[slot] = GoombaSpeedY[dir]
	ld hl, GoombaSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
.animate
;> return GoombaWalkAnimation()
	jr GoombaWalkAnimation

;@ def Goomba_Walk(slot: c)
;@ path: enemy/goomba
;@ State 1: walks (stopped by walls); after the time it pauses $20 frames (state 0).
;@ test: skip checks Link collision through bank 3
Goomba_Walk::
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> GoombaTouchLink()
	call GoombaTouchLink
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .walk
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.walk
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
GoombaWalkAnimation:
;> frame = (hFrameCounter >> 4) & 1          # GoombaWalkAnimation: frames 0/1 every 16 frames
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def Goomba_Squashed(slot: c)
;@ path: enemy/goomba
;@ State 2: lies flat (frame 2, no collision with Link); when the time is up it dies (status 1,
;@ dying for $0C frames) and leaves a heart (drop $2D).
;@ test: c = rand(0, 15)
Goomba_Squashed::
;> wEntityPhysicsFlags[slot] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .flat
;>     wEntityDropType[slot] = 0x2D             # a heart
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $2d
;>     wEntityDyingTimer[slot] = 0x0C
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $0c
;>     wEntityStatus[slot] = 1                  # dying
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
;>     wEntityPhysicsFlags[slot] = 0x04
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $04
.flat
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ def GoombaSideView(slot: c)
;@ path: enemy/goomba
;@ The goomba in a side-view room: squashed (state 2) as in top view; otherwise it can be hit, hurts
;@ Link on touch, and runs GoombaSideViewStates (0 start, 1 walk).
;@ test: skip calls entity engine routines in bank 3
GoombaSideView::
;> if hActiveEntityState == 2:
	ldh a, [hActiveEntityState]
	cp $02
;>     return Goomba_Squashed(slot)
	jr z, Goomba_Squashed
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> GoombaSideViewTouchLink()
	call GoombaSideViewTouchLink
;> return GoombaSideViewStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/goomba
;@ States of the side-view goomba (wEntityState).
GoombaSideViewStates::
	dw GoombaSideView_Start
	dw GoombaSideView_Walk

;@ def GoombaSideView_Start(slot: c)
;@ path: enemy/goomba
;@ State 0: sets off towards Link at half a pixel per frame (state 1).
;@ test: c = rand(0, 15)
GoombaSideView_Start::
;> dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
;>@s wEntitySpeedX[slot] = 0x08 if xdir != 1 else 0xF8
	ld a, $08
	dec e
	jr nz, .set
	ld a, $f8
.set
	ld hl, wEntitySpeedX
	add hl, bc
;=@s
	ld [hl], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def GoombaSideView_Walk(slot: c)
;@ path: enemy/goomba
;@ State 1: walks with gravity (+2 per frame); a wall turns it round; standing on the floor it is
;@ put on the tile edge (+3) and walks (frames 0/1), in the air it shows frame 0.
;@ test: skip checks walls through bank 3
GoombaSideView_Walk::
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> wEntitySpeedY[slot] += 2                     # gravity
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	inc [hl]
;> EntityCheckWalls()
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 0x03:          # a wall left or right
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, .floor
;>     wEntitySpeedX[slot] = -wEntitySpeedX[slot] & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.floor
;> if wEntityCollisions[slot] & 0x08:          # standing on the floor
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $08
	jr z, .inAir
;>     wEntityY[slot] = (wEntityY[slot] & 0xF0) + 3
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	and $f0
	add $03
	ld [hl], a
;>     wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
;>     return GoombaWalkAnimation()
	jp GoombaWalkAnimation

.inAir
;> return SetEntitySpriteVariant(slot, 0)
	xor a
	jp SetEntitySpriteVariant


;@ def GoombaTouchLink()
;@ path: enemy/goomba
;@ The touch check with Link (EntityTouchesLink) unless Link is jumping 8 pixels or more above the
;@ ground - so he can jump over it.
;@ test: skip checks Link collision through bank 3
GoombaTouchLink::
;> if hLinkPositionZ == 0:
	ldh a, [hLinkPositionZ]
	and a
;>     return EntityTouchesLink()
	jp z, EntityTouchesLink
;> if hLinkPositionZ < 8:
	cp $08
;>     return EntityTouchesLink()
	jp c, EntityTouchesLink
	ret


;@ def GoombaSideViewTouchLink()
;@ path: enemy/goomba
;@ In side view the goomba always checks touching Link.
;@ test: skip checks Link collision through bank 3
GoombaSideViewTouchLink::
;> return EntityTouchesLink()
	jp EntityTouchesLink

;@ path: enemy/peahat
;@ The peahat, drawn by DrawEntity16x16: 2 frames of 4 bytes (tile and attributes of the left
;@ half, then of the right half; each half is the mirror image of the other): tiles $40 and $42, the
;@ two positions of its spinning leaves.
PeahatSprites::
	db $40, $00, $40, $20, $42, $00, $42, $20

;@ def PeahatHandler(slot: c)
;@ path: enemy/peahat
;@ Entity $A0, the peahat: a flying plant that spins its leaves, rises 16 pixels and drifts in
;@ slow curves, then lands and stops spinning. Only on the ground can it be hit: the handler sets
;@ bit 7 of wEntityHitboxFlags and bit 6 of wEntityOptions1 every frame, and the landing state
;@ clears them once it touches down. wEntityPrivate1 is the spin speed, wEntityPrivateCounter the
;@ spin phase; in flight wEntityPrivate4 is its heading (0-15), wEntityPrivate2 the turn (+1/-1)
;@ and wEntityPrivate3 counts the frames to the next turn step. States (wEntityState): 0 land,
;@ 1 spin up, 2 fly.
;@ test: skip draws sprites and calls entity engine routines in bank 3
PeahatHandler::
;> DrawEntity16x16(PeahatSprites)
	ld de, PeahatSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntityHitboxFlags[slot] |= 0x80            # cannot be hit (cleared again on the ground)
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
;> wEntityOptions1[slot] |= 0x40
	ld hl, wEntityOptions1
	add hl, bc
	set 6, [hl]
;> return PeahatStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/peahat
;@ States of the peahat (wEntityState), see PeahatHandler.
PeahatStates::
	dw Peahat_Land
	dw Peahat_SpinUp
	dw Peahat_Fly

;@ def Peahat_Land(slot: c)
;@ path: enemy/peahat
;@ State 0: sinks 1 pixel every 8 frames; on the ground it can be hit. Every 8 frames its speed
;@ slows by 1 towards 0, every 32 frames the spin slows by 1. When the drop timer is up it starts
;@ to spin up (state 1).
;@ test: skip calls entity engine routines in bank 3
Peahat_Land::
;> if wEntityZ[slot] != 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .landed
;>     if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .slowDown
;>         wEntityZ[slot] -= 1
	dec [hl]
	jr .slowDown
;> else:
.landed
;>     wEntityHitboxFlags[slot] &= ~0x80        # can be hit now
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
;>     wEntityOptions1[slot] &= ~0x40
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
.slowDown
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .timer
;>     if wEntitySpeedX[slot] != 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, .speedY
;>         wEntitySpeedX[slot] += 1 if wEntitySpeedX[slot] & 0x80 else -1
	and $80
	jr z, .slowerX
	inc [hl]
	inc [hl]
.slowerX
	dec [hl]
.speedY
;>     if wEntitySpeedY[slot] != 0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, .timer
;>         wEntitySpeedY[slot] += 1 if wEntitySpeedY[slot] & 0x80 else -1
	and $80
	jr z, .slowerY
	inc [hl]
	inc [hl]
.slowerY
	dec [hl]
.timer
;> if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .spin
;>     wEntityState[slot] += 1
	call IncrementEntityState
.spin
;>@p if wEntityPrivate1[slot] != 0 and hFrameCounter & 0x1F == 0:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, .animate
;=@p
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .animate
;>     wEntityPrivate1[slot] -= 1               # spin slower
	dec [hl]
.animate
;> return PeahatSpin(slot)
	jp PeahatSpin


;@ def Peahat_SpinUp(slot: c)
;@ path: enemy/peahat
;@ State 1: the spin speeds up by 1 every 16 frames; at speed 8 it takes off (state 2) for $80-$9F
;@ frames (drop timer).
;@ test: skip draws on random numbers
Peahat_SpinUp::
;> if wEntityPrivate1[slot] >= 8:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $08
	jr c, .faster
;>     wEntityDropTimer[slot] = (GetRandomByte() & 0x1F) + 0x80
	call GetEntityDropTimer
	call GetRandomByte
	and $1f
	add $80
	ld [hl], a
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.faster
;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, PeahatSpin
;>     wEntityPrivate1[slot] += 1
	inc [hl]
;> return PeahatSpin(slot)                      # runs on into it

;@ def PeahatSpin(slot: c)
;@ path: enemy/peahat
;@ Turns the leaves: adds the spin speed (wEntityPrivate1) to the phase (wEntityPrivateCounter);
;@ bit 5 of the phase picks sprite frame 0 or 1.
;@ test: c = rand(0, 15)
PeahatSpin::
;> phase = (wEntityPrivateCounter[slot] + wEntityPrivate1[slot]) & 0xFF
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
;> wEntityPrivateCounter[slot] = phase
	ld [hl], a
;> frame = (phase >> 5) & 1
	rra
	rra
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ path: enemy/peahat
;@ A sine wave in 16 steps (signed, amplitude $0E), followed by the first 4 steps again so that
;@ PeahatSine + 4 reads the cosine. The peahat's flight speed is y = PeahatSine[heading] / 2 and
;@ x = PeahatSine[heading + 4] / 2.
PeahatSine::
	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d

;@ def Peahat_Fly(slot: c)
;@ path: enemy/peahat
;@ State 2: rises 1 pixel every 8 frames up to 16 pixels. Up there it flies a curve: every $18
;@ frames the heading turns one step (wEntityPrivate2) and the speed follows PeahatSine; now and
;@ then (1 in 8) the turn direction is picked again. When the drop timer is up it lands (state 0)
;@ and keeps its last speed, which slows down there; the next flight comes after $60 frames.
;@ test: skip draws on random numbers
Peahat_Fly::
;> PeahatSpin(slot)
	call PeahatSpin
;> if wEntityZ[slot] != 0x10:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $10
	jr z, .high
;>     if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .done
;>         wEntityZ[slot] += 1
	inc [hl]
.done
;>     return
	ret

.high
;> if wEntityDropTimer[slot] == 0:
	call GetEntityDropTimer
	jr nz, .steer
;>     wEntityDropTimer[slot] = 0x60
	ld [hl], $60
;>     wEntityState[slot] = 0                   # land
	call IncrementEntityState
	ld [hl], b
.steer
;> wEntityPrivate3[slot] += 1
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
;> if wEntityPrivate3[slot] >= 0x18:
	ld a, [hl]
	cp $18
	jr c, .return
;>     wEntityPrivate3[slot] = 0
	ld [hl], b
;>@h     wEntityPrivate4[slot] = (wEntityPrivate4[slot] + wEntityPrivate2[slot]) & 0x0F
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate4
	add hl, bc
	add [hl]
;=@h
	and $0f
	ld [hl], a
;>     heading = wEntityPrivate4[slot]
	ld hl, wEntityPrivate4
	add hl, bc
	ld e, [hl]
	ld d, b
;>@sy     wEntitySpeedY[slot] = (PeahatSine[heading] >> 1) | (PeahatSine[heading] & 0x80)   # half, keeping the sign
	ld hl, PeahatSine
	add hl, de
	ld a, [hl]
	sra a
	ld hl, wEntitySpeedY
	add hl, bc
;=@sy
	ld [hl], a
;>@sx     wEntitySpeedX[slot] = (PeahatSine[heading + 4] >> 1) | (PeahatSine[heading + 4] & 0x80)
	ld hl, PeahatSine + 4
	add hl, de
	ld a, [hl]
	sra a
	ld hl, wEntitySpeedX
	add hl, bc
;=@sx
	ld [hl], a
;>     if GetRandomByte() & 7 == 0:
	call GetRandomByte
	and $07
	jr nz, .return
;>         wEntityPrivate2[slot] = (GetRandomByte() & 2) - 1    # turn left or right
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a
.return
;> return
	ret


;@ path: enemy/snake
;@ The snake, drawn by DrawEntity16x16: 4 frames of 4 bytes (tile and attributes of the left half,
;@ then of the right half). Frames 0/1 face left (head tile $44, body $46 or $48 as it wriggles),
;@ frames 2/3 are the same mirrored to face right. The facing (0 or 2, wEntityDirection) is added
;@ to the animation frame.
SnakeSprites::
	db $44, $00, $46, $00, $44, $00, $48, $00, $46, $20, $44, $20, $48, $20, $44, $20

;@ def SnakeHandler(slot: c)
;@ path: enemy/snake
;@ Entity $A1, the snake: it crawls about in short random runs, and when Link comes into its row or
;@ column it darts at him at double speed. Running into a wall makes it stop and rest (state 0,
;@ 8 frames) and look for Link only after $20 frames. States (wEntityState): 0 rest, 1 crawl,
;@ 2 dart.
;@ test: skip draws sprites and calls entity engine routines in bank 3
SnakeHandler::
;> hActiveEntitySpriteVariant += wEntityDirection[slot]      # facing
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	ldh [hActiveEntitySpriteVariant], a
;> DrawEntity16x16(SnakeSprites)
	ld de, SnakeSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> if wEntityCollisions[slot] != 0:            # ran into a wall
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .states
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 8
	call GetEntityTimer
	ld [hl], $08
;>     wEntityTimer1[slot] = 0x20
	call GetEntityTimer1
	ld [hl], $20
.states
;> return SnakeStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/snake
;@ States of the snake (wEntityState), see SnakeHandler.
SnakeStates::
	dw Snake_Rest
	dw Snake_Crawl
	dw Snake_Dart

;@ path: enemy/snake
;@ x speed of the snake per direction (0 right, 1 left, 2 up, 3 down), 1/16 pixel per frame.
SnakeSpeedX::
	db $08, $f8, $00, $00

;@ path: enemy/snake
;@ y speed of the snake per direction.
SnakeSpeedY::
	db $00, $00, $f8, $08

;@ path: enemy/snake
;@ Facing (wEntityDirection, added to the sprite frame) per direction: 2 = right, 0 = left, $FF =
;@ up and down keep the facing it had.
SnakeFacing::
	db $02, $00, $ff, $ff

;@ def Snake_Rest(slot: c)
;@ path: enemy/snake
;@ State 0: rests (SnakeStand) while the timer runs; then crawls (state 1) for $30-$4F frames in
;@ the direction given by the low 2 bits of that time.
;@ test: skip draws on random numbers
Snake_Rest::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return SnakeStand(slot)
	jr nz, SnakeStand
;> wEntityState[slot] += 1
	call IncrementEntityState
;> t = (GetRandomByte() & 0x1F) + 0x30
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
;> wEntityTimer[slot] = t
	ld [hl], a
;> dir = t & 3
	and $03
	ld e, a
;> return SetSnakeDirection(slot, dir)          # runs on into it

;@ def SetSnakeDirection(slot: c, dir: e)
;@ path: enemy/snake
;@ Sets the snake's speed for direction dir (0 right, 1 left, 2 up, 3 down) from SnakeSpeedX /
;@ SnakeSpeedY and, for left and right, its facing (SnakeFacing).
;@ test: c = rand(0, 15); e = rand(0, 3)
SetSnakeDirection::
;>@sx wEntitySpeedX[slot] = SnakeSpeedX[dir]
	ld d, b
	ld hl, SnakeSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
;=@sx
	ld [hl], a
;> wEntitySpeedY[slot] = SnakeSpeedY[dir]
	ld hl, SnakeSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;> if SnakeFacing[dir] != 0xFF:
	ld hl, SnakeFacing
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, .done
;>     wEntityDirection[slot] = SnakeFacing[dir]
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
.done
	ret


;@ def SnakeStand(slot: c)
;@ path: enemy/snake
;@ The resting snake: stands still, keeps watching for Link and wriggles (SnakeCrawlAnimation).
;@ test: skip checks Link position through other routines
SnakeStand::
;> ClearEntitySpeed()
	call ClearEntitySpeed
;> SnakeLookForLink(slot)
	call SnakeLookForLink
;> return SnakeCrawlAnimation()
	jr SnakeCrawlAnimation

;@ def Snake_Crawl(slot: c)
;@ path: enemy/snake
;@ State 1: crawls in its direction; after the time it rests $18 frames (state 0). Meanwhile it
;@ watches for Link.
;@ test: skip checks Link position through other routines
Snake_Crawl::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .look
;>     wEntityTimer[slot] = 0x18
	ld [hl], $18
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.look
;> SnakeLookForLink(slot)
	call SnakeLookForLink
SnakeCrawlAnimation:
;> frame = (hFrameCounter >> 3) & 1            # SnakeCrawlAnimation: wriggles every 8 frames
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ def SnakeLookForLink(slot: c)
;@ path: enemy/snake
;@ Unless it is still resting after a wall (wEntityTimer1), checks whether Link is within 8 pixels
;@ of its column or row; if so it darts at him (state 2) at double speed for $30 frames.
;@ test: skip checks Link position through other routines
SnakeLookForLink::
;> if wEntityTimer1[slot] != 0:
	call GetEntityTimer1
;>     return
	jr nz, SnakeLookReturn
;> if (EntityLinkDiffX(slot)[0] + 8) & 0xFF < 0x10:          # Link in its column
	call EntityLinkDiffX
	add $08
	cp $10
	jr nc, SnakeLookRow
;>     dir = EntityLinkDiffY(slot)[1]                         # up or down at him
	call EntityLinkDiffY
SnakeDartAtLink:
;>     SetSnakeDirection(slot, dir)                           # SnakeDartAtLink(slot, dir):
	call SetSnakeDirection
;>     wEntitySpeedX[slot] <<= 1
	ld hl, wEntitySpeedX
	add hl, bc
	sla [hl]
;>     wEntitySpeedY[slot] <<= 1
	ld hl, wEntitySpeedY
	add hl, bc
	sla [hl]
;>     wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
SnakeLookReturn:
;>     return
	ret

SnakeLookRow:
;> if (EntityLinkDiffY(slot)[0] + 8) & 0xFF < 0x10:          # Link in its row
	call EntityLinkDiffY
	add $08
	cp $10
	jr nc, .done
;>     dir = EntityLinkDiffX(slot)[1]                         # left or right at him
	call EntityLinkDiffX
;>     return SnakeDartAtLink(slot, dir)                      # the same dart as above
	jr SnakeDartAtLink

.done
	ret


;@ def Snake_Dart(slot: c)
;@ path: enemy/snake
;@ State 2: darts at Link with its tongue flicking fast (frames every 4 frames); after the time it
;@ rests $20 frames (state 0) and ignores Link for $40 frames.
;@ test: c = rand(0, 15)
Snake_Dart::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .animate
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer1[slot] = 0x40
	call GetEntityTimer1
	ld [hl], $40
.animate
;> frame = (hFrameCounter >> 2) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ path: world/angler_tunnel_entrance
;@ Background tiles of the Angler's Tunnel entrance, 10 rows of 10 tiles (the object columns 2-6,
;@ rows 0-4 of the room): the doorway at the top, the rock face and the ground below it. Drawn
;@ row by row by AnglerTunnelOpening_Build, every other frame swapped with
;@ AnglerTunnelBlankTiles so that the new row flickers into place.
;@ asset: bgtiles 10x10
AnglerTunnelEntranceTiles::
	db $55, $56, $0a, $0b, $0c, $0d, $0e, $0f, $55, $56, $55, $56, $1a, $1b, $1c, $1d
	db $1e, $1f, $55, $56, $55, $56, $04, $05, $64, $65, $06, $07, $55, $56, $55, $56
	db $14, $15, $66, $67, $16, $17, $55, $56, $76, $76, $72, $73, $76, $76, $72, $73
	db $68, $69, $76, $76, $73, $72, $76, $76, $73, $72, $77, $4b, $6c, $6c, $6c, $6c
	db $76, $76, $76, $76, $72, $73, $6c, $6c, $6c, $6c, $76, $76, $76, $76, $73, $72
	db $6d, $6d, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6d, $6d, $6c, $6c, $6c, $6c
	db $6c, $6c, $6c, $6c

;@ path: world/angler_tunnel_entrance
;@ The same 10 x 10 tiles before the entrance appears: the plain wall (tile $6E between the edge
;@ tiles $55/$56) and the ground (tile $6D).
;@ asset: bgtiles 10x10
AnglerTunnelBlankTiles::
	db $55, $56, $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $55, $56, $6e, $6e, $6e, $6e
	db $6e, $6e, $55, $56, $55, $56, $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $55, $56
	db $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d

;@ path: world/angler_tunnel_entrance
;@ The room objects of the entrance, 5 rows of 5 objects, written into wRoomObjects as the rows
;@ appear (so the doorway can be entered and the rock is solid).
AnglerTunnelEntranceObjects::
	db $3a, $d5, $d6, $d7, $3a
	db $3a, $cd, $e1, $ce, $3a
	db $03, $09, $03, $09, $c6
	db $1b, $1b, $03, $03, $09
	db $0e, $1b, $1b, $1b, $1b

;@ path: world/angler_tunnel_entrance
;@ Index in wRoomObjects of the first object of each of the 5 rows (column 2, rows 0-4).
AnglerTunnelObjectRows::
	db $02, $12, $22, $32, $42

;@ path: world/angler_tunnel_entrance
;@ y (pixels) in the room of each of the 10 tile rows, read as AnglerTunnelRowY - 1 + row number
;@ (1-10).
AnglerTunnelRowY::
	db $00, $08, $10, $18, $20, $28, $30, $38, $40, $48

;@ def AnglerTunnelOpening(slot: c)
;@ path: world/angler_tunnel_entrance
;@ Entity $5F started with wEntityPrivate4 = $FF: the scene in overworld room $2B when Link has
;@ the Angler Key (bank 2 spawns it). The ground rumbles, the music changes ($4C) and with the
;@ screen shaking the Angler's Tunnel entrance rises out of the rock, one tile row every 32 frames.
;@ Link cannot move meanwhile. States (wEntityState): 0 rumble, 1 music, 2 quake, 3 build.
;@ test: skip plays sounds and edits the background
AnglerTunnelOpening::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wLinkFrozen = 2
	ld [wLinkFrozen], a
;> return AnglerTunnelOpeningStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: world/angler_tunnel_entrance
;@ States of the Angler's Tunnel opening scene (wEntityState).
AnglerTunnelOpeningStates::
	dw AnglerTunnelOpening_Rumble
	dw AnglerTunnelOpening_Music
	dw AnglerTunnelOpening_Quake
	dw AnglerTunnelOpening_Build

;@ def AnglerTunnelOpening_Rumble(slot: c)
;@ path: world/angler_tunnel_entrance
;@ State 0: a rumbling noise, then $28 frames of waiting (state 1).
;@ test: skip plays a sound
AnglerTunnelOpening_Rumble::
;> PlayNoiseSfx04()
	call PlayNoiseSfx04
;> wEntityTimer[slot] = 0x28
	call GetEntityTimer
	ld [hl], $28
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def AnglerTunnelOpening_Music(slot: c)
;@ path: world/angler_tunnel_entrance
;@ State 1: when the wait is over, starts music track $4C (state 2).
;@ test: c = rand(0, 15)
AnglerTunnelOpening_Music::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz
;> wMusicTrackToPlay = 0x4C
	ld a, $4c
	ld [wMusicTrackToPlay], a
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def AnglerTunnelOpening_Quake(slot: c)
;@ path: world/angler_tunnel_entrance
;@ State 2: the quake sound ($1D), then $80 frames of shaking before the building starts (state 3).
;@ test: c = rand(0, 15)
AnglerTunnelOpening_Quake::
;> hNoiseSfx = 0x1D
	ld a, $1d
	ldh [hNoiseSfx], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> return IncrementEntityState(slot)
	jp IncrementEntityState


;@ def AnglerTunnelOpening_Build(slot: c)
;@ path: world/angler_tunnel_entrance
;@ State 3: shakes the screen 2 pixels sideways (every 8 frames). Once the timer is up, every frame
;@ it redraws the current tile row (wEntityPrivateCounter, 1-10) - from AnglerTunnelEntranceTiles
;@ on even frames, AnglerTunnelBlankTiles on odd ones - and writes the matching row of room
;@ objects; every 32 frames (wEntityPrivate1 counts the frames) it moves on to the next row.
;@ After row 10 the shaking stops, Link can move, the area music returns and the entity is gone.
;@ test: skip edits the background and the room objects
AnglerTunnelOpening_Build::
;>@sh wScreenShakeX = 2 if hFrameCounter & 8 else 0
	ldh a, [hFrameCounter]
	ld e, $00
	and $08
	jr z, .shake
	ld e, $02
.shake
;=@sh
	ld a, e
	ld [wScreenShakeX], a
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	ret nz
;> frames = wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
;> wEntityPrivate1[slot] = frames + 1
	inc a
	ld [hl], a
;> hBGTilesRequestCopy = frames + 1          # used here as a scratch byte
	ldh [hBGTilesRequestCopy], a
;> if frames & 0x1F == 0:                     # next row
	ld a, e
	and $1f
	jp nz, .drawRow
;>     if wEntityPrivateCounter[slot] == 10:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $0a
;>         return AnglerTunnelOpeningDone(slot)
	jp z, AnglerTunnelOpeningDone
;>     wEntityPrivateCounter[slot] += 1
	inc a
	ld [hl], a
.drawRow
;> row = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	push hl
	ld a, [hl]
	ld e, a
	ld d, b
;> hBGPosY = AnglerTunnelRowY[row - 1]
	ld hl, AnglerTunnelRowY - 1
	add hl, de
	ld a, [hl]
	ldh [hBGPosY], a
;> hBGPosX = 0x20
	ld a, $20
	ldh [hBGPosX], a
;> GetBGAddress()
	call GetBGAddress
;>@o offset = (row - 1) * 10
	pop hl
	ld a, [hl]
	dec a
	ld e, a
	sla a
	sla a
;=@o
	sla a
	add e
	add e
	ld e, a
	ld d, b
;> tiles = AnglerTunnelBlankTiles if hBGTilesRequestCopy & 1 else AnglerTunnelEntranceTiles
	ld hl, AnglerTunnelEntranceTiles
	ldh a, [hBGTilesRequestCopy]
	and $01
	jr z, .tiles
	ld hl, AnglerTunnelBlankTiles
.tiles
;> src = tiles + offset
	add hl, de
	push hl
;> n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, b
;> wDrawCommandsSize = n + 13
	add $0d
	ld [wDrawCommandsSize], a
;> p = wDrawCommand + n
	ld hl, wDrawCommand
	add hl, de
;> p[0:3] = [hBGAddrHigh, hBGAddrLow, 0x09]  # 10 tiles in a row
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $09
	ld [hli], a
;> for i in range(10):
	pop de
	push bc
	ld c, $0a
.copyTiles
;>     p[3 + i] = src[i]
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copyTiles
;> p[13] = 0
	ld [hl], b
	pop bc
;>@r r = ((row - 1) >> 1) & 7                   # object row
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	dec a
	rra
;=@r
	and $07
	push af
;>@d dst = wRoomObjects + AnglerTunnelObjectRows[r]
	ld e, a
	ld d, b
	ld hl, AnglerTunnelObjectRows
	add hl, de
	ld e, [hl]
	ld hl, wRoomObjects
;=@d
	add hl, de
	push hl
	pop bc
;>@j objects = AnglerTunnelEntranceObjects + r * 5
	pop af
	ld e, a
	sla a
	sla a
	add e
	ld e, a
;=@j
	ld d, $00
	ld hl, AnglerTunnelEntranceObjects
	add hl, de
;> for i in range(5):
	ld e, $05
.copyObjects
;>     dst[i] = objects[i]
	ld a, [hli]
	ld [bc], a
	inc bc
	dec e
	jr nz, .copyObjects
	pop bc
;> return
	ret

AnglerTunnelOpeningDone:
;> wScreenShakeX = 0                          # AnglerTunnelOpeningDone: the entrance is complete
	xor a
	ld [wScreenShakeX], a
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> SelectAreaMusicFar()
	call SelectAreaMusicFar
;> return ClearEntityStatus(slot)
	jp ClearEntityStatus


;@ def MasterStalfosHandler(slot: c)
;@ path: boss/master_stalfos
;@ Entity $5F, the Master Stalfos (mini-boss of dungeon 5), a big skeleton with sword and shield
;@ built from separate parts (torso, legs, shield, sword; their frames and offsets are
;@ wMasterStalfosSwordFrame..wMasterStalfosLegsY). He drops from the ceiling, walks at Link, slashes
;@ when Link is close and leaps at him otherwise. A hit makes him collapse into a heap of bones;
;@ hits on the heap count up (wEntityPrivateCounter), and after enough of them (2 or 3 depending on
;@ the room) he says his line and flees through the ceiling. In the last room ($80) he never
;@ flees and has to be beaten. With wEntityPrivate4 = $FF the entity is the Angler's Tunnel
;@ opening scene instead (AnglerTunnelOpening). States (wEntityState): 0 wait on the ceiling,
;@ 1 drop, 2 speak, 3 look around, 4 decide, 5 walk, 6 slash, 7 crouch, 8 leap, 9 knocked down,
;@ 10 crumble, 11 rattle, 12 reassemble, 13 flee.
;@ test: skip draws sprites and calls entity engine routines in bank 3
MasterStalfosHandler::
;> if wEntityPrivate4[slot] == 0xFF:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $ff
;>     return AnglerTunnelOpening(slot)
	jp z, AnglerTunnelOpening
;> if wEntityPrivate4[slot] == 0:              # first frame
	and a
	jr nz, .draw
;>     wEntityPrivate4[slot] = 1
	inc [hl]
;>     MasterStalfosInit(slot)
	call MasterStalfosInit
.draw
;> DrawMasterStalfos(slot)
	call DrawMasterStalfos
;> if hActiveEntityStatus != 5:               # defeated
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return BossDefeatedHandler(slot)
	jp nz, BossDefeatedHandler
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ConfineLinkToArena()
	call ConfineLinkToArena
;> StartBossMusic()
	call StartBossMusic
;> if wEntityFlashTimer[slot] == 0x16:         # just hit
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, .physics
;>     if hActiveEntityState < 9:              # standing: he collapses
	ldh a, [hActiveEntityState]
	cp $09
	jr nc, .heapHit
;>         wEntityFlashTimer[slot] = 0
	ld [hl], b
;>         wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>         wEntityState[slot] = 9
	call IncrementEntityState
	ld a, $09
	ld [hl], a
;>         hActiveEntityState = 9
	ldh [hActiveEntityState], a
	jr .physics
;>     else:
.heapHit
;>         wEntityPrivateCounter[slot] += 1    # a hit on the heap of bones
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
.physics
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2                    # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80             # kept in hBGTilesRequestCopy for the states
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if landed:
	jr z, .states
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.states
;> if hActiveEntityState < 9:
	ldh a, [hActiveEntityState]
	cp $09
	jr nc, .run
;>     EntityCheckSwordClash()                  # the shield blocks Link's sword
	call EntityCheckSwordClash
;>     if wLinkPushedTimer | wEntityIgnoreHitsTimer[slot] == 0:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [wLinkPushedTimer]
	or [hl]
	and a
	jr nz, .run
;>         EntityTouchesLink()
	call EntityTouchesLink
;>         EntityCheckWeaponHits()
	call EntityCheckWeaponHits
.run
;> return MasterStalfosStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: boss/master_stalfos
;@ States of the Master Stalfos (wEntityState), see MasterStalfosHandler.
MasterStalfosStates::
	dw MasterStalfos_Wait
	dw MasterStalfos_Drop
	dw MasterStalfos_Speak
	dw MasterStalfos_LookAround
	dw MasterStalfos_Decide
	dw MasterStalfos_Walk
	dw MasterStalfos_Slash
	dw MasterStalfos_Crouch
	dw MasterStalfos_Leap
	dw MasterStalfos_KnockedDown
	dw MasterStalfos_Crumble
	dw MasterStalfos_Rattle
	dw MasterStalfos_Reassemble
	dw MasterStalfos_Flee

;@ def MasterStalfos_Wait(slot: c)
;@ path: boss/master_stalfos
;@ State 0: hidden high above the room (height $7F) until the timer is up; then he comes into view
;@ at height $6F and hangs there $30 frames (state 1).
;@ test: c = rand(0, 15)
MasterStalfos_Wait::
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityZ[slot] = 0x6F
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $6f
.done
	ret


;@ def MasterStalfos_Drop(slot: c)
;@ path: boss/master_stalfos
;@ State 1: hangs while the timer runs (the boss jingle 8 on its last frame), then falls; on
;@ landing he speaks after $40 frames (state 2).
;@ test: c = rand(0, 15)
MasterStalfos_Drop::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
	jr z, .falling
;>     if t == 1:
	cp $01
	jr nz, .hang
;>         hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
.hang
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
;>     return
	ret

.falling
;> if hBGTilesRequestCopy != 0:               # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, MasterStalfosDoNothing
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     wEntityState[slot] += 1
	call IncrementEntityState
;> return MasterStalfosDoNothing()            # runs on into it

;@ def MasterStalfosDoNothing()
;@ path: boss/master_stalfos
;@ Just returns.
;@ test: c = 0
MasterStalfosDoNothing::
;> return
	ret


;@ def MasterStalfos_Speak(slot: c)
;@ path: boss/master_stalfos
;@ State 2: crouched from the fall, he straightens up after $20 frames. Just before the end he
;@ speaks: text $12 in rooms $92 and $84, text $14 in room $80, nothing elsewhere. Then he looks
;@ around for $A0 frames in room $95, $20 frames elsewhere (state 3).
;@ test: skip opens dialogue
MasterStalfos_Speak::
;> if wEntityTimer[slot] == 1:
	call GetEntityTimer
	cp $01
	jr nz, .timer
;>     text = 0x12
	ld e, $12
;>@room     if hMapRoom in (0x92, 0x84, 0x80):
	ldh a, [hMapRoom]
	cp $92
	jr z, .say
	cp $84
	jr z, .say
;=@room
	cp $80
	jr nz, .timer
;>         text = 0x14 if hMapRoom == 0x80 else text
	ld e, $14
.say
;>         OpenDialogTable1(text)
	ld a, e
	call OpenDialogTable1
.timer
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .stance
;>     wEntityTimer[slot] = 0xA0 if hMapRoom == 0x95 else 0x20
	ld [hl], $a0
	ldh a, [hMapRoom]
	cp $95
	jr z, .next
	ld [hl], $20
.next
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.stance
;> wMasterStalfosTorsoY = 0xF0
	ld hl, wMasterStalfosTorsoY
	ld [hl], $f0
;> wMasterStalfosShieldY = 0xF8
	ld hl, wMasterStalfosShieldY
	ld [hl], $f8
;> wMasterStalfosSwordY = 0xF0
	ld hl, wMasterStalfosSwordY
	ld [hl], $f0
;> if t >= 0x20:                               # still crouched, 2 pixels lower
	cp $20
	jr c, .done
;>     wMasterStalfosTorsoY = 0xF2
	ld hl, wMasterStalfosTorsoY
	ld [hl], $f2
;>     wMasterStalfosShieldY = 0xFA
	ld hl, wMasterStalfosShieldY
	ld [hl], $fa
;>     wMasterStalfosSwordY = 0xF2
	ld hl, wMasterStalfosSwordY
	ld [hl], $f2
.done
	ret


;@ def MasterStalfos_LookAround(slot: c)
;@ path: boss/master_stalfos
;@ State 3: turns to face left and right in turns (64 frames each) until the timer is up; then the
;@ fight starts (state 4, $20 frames).
;@ test: c = rand(0, 15)
MasterStalfos_LookAround::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .look
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     return IncrementEntityState(slot)
	jp IncrementEntityState

.look
;> t & 0x3F                                    # (has no effect)
	and $3f
	jr nz, .turn
.turn
;> if wEntityTimer[slot] & 0x40:
	call GetEntityTimer
	and $40
;>     return MasterStalfosPoseRight()
	jr z, MasterStalfosPoseRight
;> return MasterStalfosPoseLeft()               # runs on into it

;@ def MasterStalfosPoseLeft()
;@ path: boss/master_stalfos
;@ Puts the parts in the stance facing left: torso frame 1, shield in front (x -16, y -8), sword
;@ held up behind (frame 0 at x +16, y -13).
;@ test: c = 0
MasterStalfosPoseLeft::
;> MasterStalfosResetParts()
	call MasterStalfosResetParts
;> wMasterStalfosTorsoFrame = 1
	ld hl, wMasterStalfosTorsoFrame
	ld [hl], $01
;> wMasterStalfosLegsFrame = 0
	ld hl, wMasterStalfosLegsFrame
	ld [hl], b
;> wMasterStalfosShieldX = 0xF0
	ld hl, wMasterStalfosShieldX
	ld [hl], $f0
;> wMasterStalfosShieldY = 0xF8
	ld hl, wMasterStalfosShieldY
	ld [hl], $f8
;> wMasterStalfosSwordY = 0xF3
	ld hl, wMasterStalfosSwordY
	ld [hl], $f3
;> wMasterStalfosSwordX = 0x10
	ld hl, wMasterStalfosSwordX
	ld [hl], $10
;> wMasterStalfosSwordFrame = 0
	ld hl, wMasterStalfosSwordFrame
	ld [hl], $00
	ret


;@ def MasterStalfosPoseRight()
;@ path: boss/master_stalfos
;@ Puts the parts in the stance facing right: torso frame 0, shield at x -8, y -8, sword frame 0
;@ at x +16, y -16.
;@ test: c = 0
MasterStalfosPoseRight::
;> MasterStalfosResetParts()
	call MasterStalfosResetParts
;> wMasterStalfosTorsoFrame = 0
	ld hl, wMasterStalfosTorsoFrame
	ld [hl], b
;> wMasterStalfosLegsFrame = 0
	ld hl, wMasterStalfosLegsFrame
	ld [hl], b
;> wMasterStalfosShieldX = 0xF8
	ld hl, wMasterStalfosShieldX
	ld [hl], $f8
;> wMasterStalfosShieldY = 0xF8
	ld hl, wMasterStalfosShieldY
	ld [hl], $f8
;> wMasterStalfosSwordY = 0xF0
	ld hl, wMasterStalfosSwordY
	ld [hl], $f0
;> wMasterStalfosSwordX = 0x10
	ld hl, wMasterStalfosSwordX
	ld [hl], $10
;> wMasterStalfosSwordFrame = 0
	ld hl, wMasterStalfosSwordFrame
	ld [hl], $00
	ret


;@ def MasterStalfos_Decide(slot: c)
;@ path: boss/master_stalfos
;@ State 4: MasterStalfosCheckLeap may start a leap. When the timer is up he walks at Link (speed
;@ 8) for $30-$4F frames (state 5). He always turns to face Link.
;@ test: skip draws on random numbers
MasterStalfos_Decide::
;> MasterStalfosCheckLeap(slot)
	call MasterStalfosCheckLeap
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, MasterStalfosSetPose.done
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>     SetEntitySpeedTowardsLink(8)
	ld a, $08
	call SetEntitySpeedTowardsLink
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return MasterStalfosFaceLink(slot)       # runs on into it

;@ def MasterStalfosFaceLink(slot: c)
;@ path: boss/master_stalfos
;@ Turns towards Link (wEntityDirection = 0 if Link is to the right, 1 to the left) and takes the
;@ matching stance.
;@ test: c = rand(0, 15)
MasterStalfosFaceLink::
;> wEntityDirection[slot] = EntityLinkDiffX(slot)[1]
	call EntityLinkDiffX
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;> return MasterStalfosSetPose(slot)          # runs on into it

;@ def MasterStalfosSetPose(slot: c)
;@ path: boss/master_stalfos
;@ Takes the stance for his facing (wEntityDirection): MasterStalfosPoseRight for 0, else
;@ MasterStalfosPoseLeft.
;@ test: c = rand(0, 15)
MasterStalfosSetPose::
;> MasterStalfosPoseLeft()
	call MasterStalfosPoseLeft
;> if wEntityDirection[slot] == 0:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .done
;>     MasterStalfosPoseRight()
	call MasterStalfosPoseRight
.done
	ret


;@ def MasterStalfos_Walk(slot: c)
;@ path: boss/master_stalfos
;@ State 5: walks at Link (legs frame toggled every 16 frames). MasterStalfosCheckLeap may start a
;@ leap; when Link is within 32 pixels across and 28 up or down he slashes (state 6, $30 frames);
;@ when the walking time is up he decides again (state 4) after $10-$1F frames.
;@ test: skip draws on random numbers
MasterStalfos_Walk::
;> MasterStalfosCheckLeap(slot)
	call MasterStalfosCheckLeap
;>@near if (EntityLinkDiffX(slot)[0] + 0x20) & 0xFF < 0x40 and (EntityLinkDiffY(slot)[0] + 0x1C) & 0xFF < 0x38:
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, .walk
;=@near
	call EntityLinkDiffY
	add $1c
	cp $38
	jr nc, .walk
;>     wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>     wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>     return
	ret

.walk
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .step
;>     wEntityTimer[slot] = (GetRandomByte() & 0x0F) + 0x10
	call GetRandomByte
	and $0f
	add $10
	ld [hl], a
;>     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>     return
	ret

.step
;> if t & 0x0F == 0:
	and $0f
	jr nz, MasterStalfosMove
;>     wMasterStalfosLegsFrame ^= 1
	ld a, [wMasterStalfosLegsFrame]
	xor $01
	ld [wMasterStalfosLegsFrame], a
;> return MasterStalfosMove(slot)              # runs on into it

;@ def MasterStalfosMove(slot: c)
;@ path: boss/master_stalfos
;@ Moves him by his speed, stopped by walls.
;@ test: skip checks walls through bank 3
MasterStalfosMove::
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
	ret


;@ def MasterStalfos_Slash(slot: c)
;@ path: boss/master_stalfos
;@ State 6: a sword stroke towards Link over $30 frames: until timer $18 the sword is raised, at
;@ $17 it comes down with a swish (noise $27) and the blade sweep (wEntityTimer2 = $10,
;@ DrawMasterStalfosSlash) that hurts Link, below $10 the sword rests low in front. Then
;@ MasterStalfosRecover.
;@ test: skip plays sounds
MasterStalfos_Slash::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0: return MasterStalfosSwing(slot)
	jr nz, MasterStalfosSwing
;> return MasterStalfosRecover(slot)            # runs on into it

;@ def MasterStalfosRecover(slot: c)
;@ path: boss/master_stalfos
;@ Back to deciding (state 4, $20 frames), with bit 7 of wEntityHitboxFlags set and bit 6 of
;@ wEntityOptions1 cleared.
;@ test: c = rand(0, 15)
MasterStalfosRecover::
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;> wEntityHitboxFlags[slot] |= 0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
;> wEntityOptions1[slot] &= ~0x40
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
	ret


;@ def MasterStalfosSwing(slot: c)
;@ path: boss/master_stalfos
;@ The stroke of MasterStalfos_Slash for the current timer, on his facing side: sword raised
;@ (timer $18 and up), the downward stroke with the sweep ($10-$17; at $17 noise $27 and
;@ wEntityTimer2 = $10), then the sword low in front (below $10).
;@ test: skip plays sounds
MasterStalfosSwing::
;> if wEntityDirection[slot] == 0:             # facing right
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .left
;>     t = wEntityTimer[slot]
	call GetEntityTimer
;>     if t >= 0x18:                           # sword raised
	cp $18
	jr c, .rightDown
;>         MasterStalfosPoseRight()
	call MasterStalfosPoseRight
;>         wMasterStalfosSwordX = 0x08
	ld a, $08
	ld [wMasterStalfosSwordX], a
;>         wMasterStalfosSwordY = 0xE0
	ld a, $e0
	ld [wMasterStalfosSwordY], a
;>         wMasterStalfosSwordFrame = 1
	ld a, $01
	ld [wMasterStalfosSwordFrame], a
;>         return
	ret

.rightDown
;>     if t >= 0x10:                           # the stroke
	cp $10
	jr c, .rightLow
;>         if t == 0x17:
	cp $17
	jr nz, .rightSweep
;>             hNoiseSfx = 0x27
	ld a, $27
	ldh [hNoiseSfx], a
;>             wEntityTimer2[slot] = 0x10
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $10
.rightSweep
;>         wMasterStalfosSwordFrame = 0xFF     # only the sweep is drawn
	ld a, $ff
	ld [wMasterStalfosSwordFrame], a
;>         wMasterStalfosShieldX = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldX], a
;>         wMasterStalfosShieldY = 0xF4
	ld a, $f4
	ld [wMasterStalfosShieldY], a
;>         wMasterStalfosTorsoFrame = 1
	ld a, $01
	ld [wMasterStalfosTorsoFrame], a
;>         return
	ret

.rightLow
;>     wMasterStalfosSwordFrame = 3             # sword low in front
	ld a, $03
	ld [wMasterStalfosSwordFrame], a
;>     wMasterStalfosSwordX = 0xF8
	ld a, $f8
	ld [wMasterStalfosSwordX], a
;>     wMasterStalfosSwordY = 0x08
	ld a, $08
	ld [wMasterStalfosSwordY], a
;>     wMasterStalfosShieldX = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldX], a
;>     wMasterStalfosShieldY = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldY], a
;>     return
	ret

.left
;> else:                                       # facing left
;>     t = wEntityTimer[slot]
	call GetEntityTimer
;>     if t >= 0x18:
	cp $18
	jr c, .leftDown
;>         MasterStalfosPoseLeft()
	call MasterStalfosPoseLeft
;>         wMasterStalfosLegsFrame = 1
	ld a, $01
	ld [wMasterStalfosLegsFrame], a
;>         wMasterStalfosSwordX = 0xF8
	ld a, $f8
	ld [wMasterStalfosSwordX], a
;>         wMasterStalfosSwordY = 0xE8
	ld a, $e8
	ld [wMasterStalfosSwordY], a
;>         wMasterStalfosSwordFrame = 0
	ld a, $00
	ld [wMasterStalfosSwordFrame], a
;>         return
	ret

.leftDown
;>     if t >= 0x10:
	cp $10
	jr c, .leftLow
;>         if t == 0x17:
	cp $17
	jr nz, .leftSweep
;>             hNoiseSfx = 0x27
	ld a, $27
	ldh [hNoiseSfx], a
;>             wEntityTimer2[slot] = 0x10
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $10
.leftSweep
;>         wMasterStalfosSwordFrame = 0xFF
	ld a, $ff
	ld [wMasterStalfosSwordFrame], a
;>         wMasterStalfosShieldX = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldX], a
;>         wMasterStalfosShieldY = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldY], a
;>         wMasterStalfosTorsoFrame = 0
	ld a, $00
	ld [wMasterStalfosTorsoFrame], a
;>         return
	ret

.leftLow
;>     wMasterStalfosSwordFrame = 2
	ld a, $02
	ld [wMasterStalfosSwordFrame], a
;>     wMasterStalfosSwordX = 0x10
	ld a, $10
	ld [wMasterStalfosSwordX], a
;>     wMasterStalfosSwordY = 0x08
	ld a, $08
	ld [wMasterStalfosSwordY], a
;>     wMasterStalfosShieldX = 0xF0
	ld a, $f0
	ld [wMasterStalfosShieldX], a
;>     wMasterStalfosShieldY = 0xEC
	ld a, $ec
	ld [wMasterStalfosShieldY], a
	ret


;@ def MasterStalfos_Crouch(slot: c)
;@ path: boss/master_stalfos
;@ State 7: faces Link, crouched 2 pixels, until the timer is up; then leaps (state 8, jingle $24):
;@ straight at Link (height speed $28, speed $18), or - when Link is close above him
;@ (wEntityPrivate1) - higher (height speed $30) at speed 8 and upwards on screen.
;@ test: skip plays sounds
MasterStalfos_Crouch::
;> MasterStalfosSetPose(slot)
	call MasterStalfosSetPose
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return MasterStalfosLowerParts()
	jr nz, MasterStalfosLowerParts
;> wEntityState[slot] += 1
	call IncrementEntityState
;> PlayJingle24()
	call PlayJingle24
;> wEntitySpeedZ[slot] = 0x30
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $30
;> if wEntityPrivate1[slot] == 0:
	and a
	jr nz, .upwards
;>     wEntitySpeedZ[slot] = 0x28
	ld [hl], $28
;>     return SetEntitySpeedTowardsLink(0x18)
	ld a, $18
	jp SetEntitySpeedTowardsLink

.upwards
;> SetEntitySpeedTowardsLink(8)
	ld a, $08
	call SetEntitySpeedTowardsLink
;> wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	ret


;@ def MasterStalfosLowerParts()
;@ path: boss/master_stalfos
;@ Moves torso, shield and sword 2 pixels down (crouching).
;@ test: c = 0
MasterStalfosLowerParts::
;> wMasterStalfosTorsoY += 2
	ld a, [wMasterStalfosTorsoY]
	add $02
	ld [wMasterStalfosTorsoY], a
;> wMasterStalfosShieldY += 2
	ld a, [wMasterStalfosShieldY]
	add $02
	ld [wMasterStalfosShieldY], a
;> wMasterStalfosSwordY += 2
	ld a, [wMasterStalfosSwordY]
	add $02
	ld [wMasterStalfosSwordY], a
	ret


;@ def MasterStalfos_Leap(slot: c)
;@ path: boss/master_stalfos
;@ State 8: flies through the air; on landing he crouches for $10 frames, then decides again
;@ (MasterStalfosRecover).
;@ test: skip checks walls through bank 3
MasterStalfos_Leap::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:                                  # landed, crouching
	jr z, .inAir
;>     if t == 1:
	dec a
	jr nz, .crouch
;>         MasterStalfosRecover(slot)
	call MasterStalfosRecover
.crouch
;>     MasterStalfosSetPose(slot)
	call MasterStalfosSetPose
;>     MasterStalfosLowerParts()
	call MasterStalfosLowerParts
	ret

.inAir
;> MasterStalfosMove(slot)
	call MasterStalfosMove
;> if hBGTilesRequestCopy != 0:                # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .done
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     MasterStalfosDoNothing()
	call MasterStalfosDoNothing
.done
	ret


;@ def MasterStalfos_KnockedDown(slot: c)
;@ path: boss/master_stalfos
;@ State 9: hit, he drops to the ground; there he falls apart (state 10, $20 frames, jingle $28),
;@ and from now on his bones can be hit (bit 7 of wEntityHitboxFlags cleared, bit 6 of
;@ wEntityOptions1 set).
;@ test: skip checks walls through bank 3
MasterStalfos_KnockedDown::
;> if hBGTilesRequestCopy != 0:                # on the ground
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .move
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityHitboxFlags[slot] &= ~0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
;>     wEntityOptions1[slot] |= 0x40
	ld hl, wEntityOptions1
	add hl, bc
	set 6, [hl]
;>     hJingle = 0x28
	ld a, $28
	ldh [hJingle], a
.move
;> MasterStalfosMove(slot)
	call MasterStalfosMove
	ret


;@ def MasterStalfos_Crumble(slot: c)
;@ path: boss/master_stalfos
;@ State 10: shield and sword sink to the floor (y offset 3, 1 pixel per frame); in the last $14
;@ frames the torso sinks onto the legs (y offset towards 0, which hides the legs). Then he lies
;@ as a heap for $C0 frames (state 11).
;@ test: c = rand(0, 15)
MasterStalfos_Crumble::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .crumble
;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.crumble
;> if wMasterStalfosShieldY != 3:
	ld hl, wMasterStalfosShieldY
	ld a, [hl]
	sub $03
	jr z, .sword
;>     wMasterStalfosShieldY += 1 if (wMasterStalfosShieldY - 3) & 0x80 else -1
	bit 7, a
	jr z, .shieldDown
	inc [hl]
	inc [hl]
.shieldDown
	dec [hl]
.sword
;> if wMasterStalfosSwordY != 3:
	ld hl, wMasterStalfosSwordY
	ld a, [hl]
	sub $03
	jr z, .torso
;>     wMasterStalfosSwordY += 1 if (wMasterStalfosSwordY - 3) & 0x80 else -1
	bit 7, a
	jr z, .swordDown
	inc [hl]
	inc [hl]
.swordDown
	dec [hl]
.torso
;> if wEntityTimer[slot] < 0x14 and wMasterStalfosTorsoY != 0:
	call GetEntityTimer
	cp $14
	jr nc, .done
	ld a, [wMasterStalfosTorsoY]
	and a
	jr z, .done
;>     wMasterStalfosTorsoY += 1
	inc a
	ld [wMasterStalfosTorsoY], a
.done
	ret


;@ def MasterStalfos_Rattle(slot: c)
;@ path: boss/master_stalfos
;@ State 11: lies as a heap of bones; at the very end the torso jerks up and down (every 4
;@ frames). Then he pulls himself together (state 12, $30 frames).
;@ test: c = rand(0, 15)
MasterStalfos_Rattle::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rattle
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.rattle
;> if t < 0x30 and t & 3 == 0:
	cp $30
	jr nc, .done
	and $03
	jr nz, .done
;>     wMasterStalfosTorsoY = -(wMasterStalfosTorsoY + 2) & 0xFF
	ld a, [wMasterStalfosTorsoY]
	add $02
	cpl
	inc a
	ld [wMasterStalfosTorsoY], a
.done
	ret


;@ def MasterStalfos_Reassemble(slot: c)
;@ path: boss/master_stalfos
;@ State 12: the torso rises back to 16 pixels above the legs, shield and sword go back up (in
;@ the last $24 frames). When the time is up: if his bones were hit fewer times than the room's
;@ limit (2, 3 in room $95, unlimited in room $80) he fights on (MasterStalfosRecover); otherwise
;@ he cannot be hit any more, says text $13 and flees (state 13).
;@ test: skip opens dialogue
MasterStalfos_Reassemble::
;> if wMasterStalfosTorsoY != 0xF0:
	ld a, [wMasterStalfosTorsoY]
	cp $f0
	jr z, .timer
;>     wMasterStalfosTorsoY -= 1
	dec a
	ld [wMasterStalfosTorsoY], a
.timer
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .rise
;>@lim     limit = 0xFF if hMapRoom == 0x80 else 3 if hMapRoom == 0x95 else 2
	ld e, $ff
	ldh a, [hMapRoom]
	cp $80
	jr z, .check
	ld e, $03
	cp $95
;=@lim
	jr z, .check
	ld e, $02
.check
;>     if wEntityPrivateCounter[slot] < limit:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp e
;>         return MasterStalfosRecover(slot)
	jr c, .fightOn
;>     wEntityHitboxFlags[slot] |= 0x80
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     OpenDialogTable1(0x13)
	ld a, $13
	call OpenDialogTable1
;>     wEntityTimer[slot] = 4
	call GetEntityTimer
	ld [hl], $04
;>     return
	ret

.fightOn
	jp MasterStalfosRecover

.rise
;> if t < 0x24:
	cp $24
	jr nc, .done
;>     if wMasterStalfosShieldY != 0xF8:
	ld hl, wMasterStalfosShieldY
	ld a, [hl]
	sub $f8
	jr z, .sword
;>         wMasterStalfosShieldY += 1 if (wMasterStalfosShieldY - 0xF8) & 0x80 else -1
	bit 7, a
	jr z, .shieldUp
	inc [hl]
	inc [hl]
.shieldUp
	dec [hl]
.sword
;>     if wMasterStalfosSwordY != 0xF0:
	ld hl, wMasterStalfosSwordY
	ld a, [hl]
	sub $f0
	jr z, .done
;>         wMasterStalfosSwordY += 1 if (wMasterStalfosSwordY - 0xF0) & 0x80 else -1
	bit 7, a
	jr z, .swordUp
	inc [hl]
	inc [hl]
.swordUp
	dec [hl]
.done
	ret


;@ def MasterStalfos_Flee(slot: c)
;@ path: boss/master_stalfos
;@ State 13: crouches for a moment (noise $3F), then jumps up out of the room; above height $78 the
;@ area music returns, the entity is gone and the room is marked as done (MarkRoomEventDone).
;@ test: skip plays sounds and changes the room status
MasterStalfos_Flee::
;> MasterStalfosSetPose(slot)
	call MasterStalfosSetPose
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
	jr z, .jump
;>     if t == 1:
	dec a
	jr nz, .crouch
;>         hNoiseSfx = 0x3F
	ld a, $3f
	ldh [hNoiseSfx], a
.crouch
;>     MasterStalfosLowerParts()
	call MasterStalfosLowerParts
;>     return
	ret

.jump
;> wEntitySpeedZ[slot] = 0x30
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $30
;> if wEntityZ[slot] >= 0x78:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $78
	jr c, MarkRoomEventDone.done
;>     SelectAreaMusicFar()
	call SelectAreaMusicFar
;>     ClearEntityStatus(slot)
	call ClearEntityStatus
;>     return MarkRoomEventDone()                # runs on into it

;@ def MarkRoomEventDone()
;@ path: world/room_status
;@ Sets bit 5 (event done) in the status byte of the current indoor room (wRoomStatus + $100 +
;@ room; the second indoor group, + $200, for maps 6-$19) and in hRoomStatus.
;@ test: c = 0
MarkRoomEventDone::
;> p = wRoomStatus + 0x100 + hMapRoom
	ld hl, wRoomStatus + $100
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
;> if 6 <= hMapId < 0x1A:
	ldh a, [hMapId]
	cp $1a
	jr nc, .add
	cp $06
	jr c, .add
;>     p += 0x100
	inc d
.add
;> mem[p] |= 0x20
	add hl, de
	ld a, [hl]
	or $20
	ld [hl], a
;> hRoomStatus = mem[p]
	ldh [hRoomStatus], a
.done
	ret


;@ def MasterStalfosCheckLeap(slot: c)
;@ path: boss/master_stalfos
;@ Starts a leap (state 7, crouching $20 frames, facing Link) when Link is more than 48 pixels
;@ away on either axis, or close and above him (then wEntityPrivate1 = 1 for the higher jump).
;@ Close with Link below him nothing happens.
;@ test: skip checks Link position through other routines
MasterStalfosCheckLeap::
;> wEntityPrivate1[slot] = 0
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
;>@n if (EntityLinkDiffX(slot)[0] + 0x30) & 0xFF < 0x60 and (EntityLinkDiffY(slot)[0] + 0x30) & 0xFF < 0x60:
	call EntityLinkDiffX
	add $30
	cp $60
	jr nc, .leap
;=@n
	call EntityLinkDiffY
	add $30
	cp $60
	jr nc, .leap
;>     if EntityLinkDiffY(slot)[1] != 2: return    # Link close below: no leap
	ld a, e
	cp $02
	jr nz, .done
;>     wEntityPrivate1[slot] = 1
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01
.leap
;> wEntityState[slot] = 7
	call IncrementEntityState
	ld [hl], $07
;> wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;> MasterStalfosFaceLink(slot)
	call MasterStalfosFaceLink
.done
	ret


;@ def MasterStalfosInit(slot: c)
;@ path: boss/master_stalfos
;@ First frame: high above the room (height $7F) for $80 frames, the room's music saved in
;@ wEntityPrivate5, health $FF ($C0 in room $80), parts in the starting stance.
;@ test: c = rand(0, 15)
MasterStalfosInit::
;> wEntityZ[slot] = 0x7F
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $7f
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityPrivate5[slot] = hDefaultMusicTrack
	ldh a, [hDefaultMusicTrack]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
;> wEntityHealth[slot] = 0xFF
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
;> if hMapRoom == 0x80:
	ldh a, [hMapRoom]
	cp $80
	jr nz, MasterStalfosResetParts
;>     wEntityHealth[slot] = 0xC0
	ld [hl], $c0
;> return MasterStalfosResetParts()            # runs on into it

;@ def MasterStalfosResetParts()
;@ path: boss/master_stalfos
;@ The starting stance of the parts: shield at x -8, y -8, torso 16 pixels above the legs, all
;@ frames 0, sword at x +16, y -16.
;@ test: c = 0
MasterStalfosResetParts::
;> wMasterStalfosShieldX = 0xF8
	ld a, $f8
	ld [wMasterStalfosShieldX], a
;> wMasterStalfosShieldY = 0xF8
	ld a, $f8
	ld [wMasterStalfosShieldY], a
;> wMasterStalfosTorsoY = 0xF0
	ld a, $f0
	ld [wMasterStalfosTorsoY], a
;> wMasterStalfosSwordFrame = 0
	ld a, $00
	ld [wMasterStalfosSwordFrame], a
;> wMasterStalfosTorsoFrame = 0
	ld [wMasterStalfosTorsoFrame], a
;> wMasterStalfosLegsFrame = 0
	ld [wMasterStalfosLegsFrame], a
;> wMasterStalfosSwordX = 0x10
	ld a, $10
	ld [wMasterStalfosSwordX], a
;> wMasterStalfosSwordY = 0xF0
	ld a, $f0
	ld [wMasterStalfosSwordY], a
	ret


;@ path: boss/master_stalfos
;@ The shield, drawn by DrawEntity16x16: one frame of 4 bytes (tile $70 and its mirror image).
MasterStalfosShieldSprites::
	db $70, $00, $70, $20

;@ path: boss/master_stalfos
;@ The torso (skull, ribs and arms): 2 frames of 4 sprites, each sprite 4 bytes (y offset, x
;@ offset, tile, attributes), side by side from x -8 to +16. Frame 0 = tiles $60-$66, frame 1 the
;@ same mirrored.
MasterStalfosTorsoSprites::
	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $00, $10, $66, $00
	db $00, $f8, $66, $20, $00, $00, $64, $20, $00, $08, $62, $20, $00, $10, $60, $20

;@ path: boss/master_stalfos
;@ The legs, same format: frame 0 = tiles $68-$6E, frame 1 the same mirrored (the walking step).
MasterStalfosLegsSprites::
	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6c, $00, $00, $10, $6e, $00
	db $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $08, $6a, $20, $00, $10, $68, $20

;@ path: boss/master_stalfos
;@ The sword: 4 frames of 2 sprites (y offset, x offset, tile, attributes), blade tile $72 and
;@ hilt tile $74: 0 = pointing up-left, 1 = up-right (mirrored), 2/3 = the same flipped upside down.
MasterStalfosSwordSprites::
	db $00, $00, $72, $00, $f8, $08, $74, $00, $f8, $00, $74, $20, $00, $08, $72, $20
	db $00, $00, $72, $40, $08, $08, $74, $40, $08, $00, $74, $60, $00, $08, $72, $60

;@ path: boss/master_stalfos
;@ The sweep of the sword stroke to the right: 5 sprites (y offset, x offset, tile, attributes),
;@ tiles $76-$7E in an arc in front of him.
MasterStalfosSlashRightSprites::
	db $10, $00, $76, $00, $10, $08, $78, $00, $10, $10, $7a, $00, $08, $18, $7c, $00
	db $f8, $18, $7e, $00

;@ path: boss/master_stalfos
;@ The same sweep to the left (mirrored).
MasterStalfosSlashLeftSprites::
	db $10, $08, $76, $20, $10, $00, $78, $20, $10, $f8, $7a, $20, $08, $f0, $7c, $20
	db $f8, $f0, $7e, $20

;@ path: boss/master_stalfos
;@ His shadow while in the air: 4 sprites of tile $26 in a row, 12 pixels down.
MasterStalfosShadowSprites::
	db $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

;@ def DrawMasterStalfos(slot: c)
;@ path: boss/master_stalfos
;@ Draws nothing while he is above height $70 (out of sight); otherwise sword, sword sweep, shield,
;@ torso and legs, and in the air his shadow.
;@ test: skip draws sprites through bank 0
DrawMasterStalfos::
;> if wEntityZ[slot] >= 0x70:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $70
;>     return
	jr nc, DrawMasterStalfosSword.done
;> DrawMasterStalfosSword()
	call DrawMasterStalfosSword
;> DrawMasterStalfosSlash(slot)
	call DrawMasterStalfosSlash
;> DrawMasterStalfosShield()
	call DrawMasterStalfosShield
;> DrawMasterStalfosTorso()
	call DrawMasterStalfosTorso
;> DrawMasterStalfosLegs()
	call DrawMasterStalfosLegs
;> if wEntityZ[slot] != 0:
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done
;>     hActiveEntityDrawY = hActiveEntityY - 2
	ldh a, [hActiveEntityY]
	sub $02
	ldh [hActiveEntityDrawY], a
;>     DrawEntitySprites(MasterStalfosShadowSprites, 4)
	ld hl, MasterStalfosShadowSprites
	ld c, $04
	call DrawEntitySprites
;>     ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
.done
;> return LoadEntityPosition()
	jp LoadEntityPosition


;@ def DrawMasterStalfosSword()
;@ path: boss/master_stalfos
;@ Draws the sword (frame wMasterStalfosSwordFrame, $FF = none) at its offset
;@ (wMasterStalfosSwordX/Y).
;@ test: skip draws sprites through bank 0
DrawMasterStalfosSword::
;> hActiveEntityX += wMasterStalfosSwordX
	ld a, [wMasterStalfosSwordX]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;> hActiveEntityDrawY += wMasterStalfosSwordY
	ld a, [wMasterStalfosSwordY]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> if wMasterStalfosSwordFrame != 0xFF:
	ld a, [wMasterStalfosSwordFrame]
	cp $ff
	jr z, .none
;>@f     frame = MasterStalfosSwordSprites + (wMasterStalfosSwordFrame * 8) & 0xF8
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
;=@f
	ld hl, MasterStalfosSwordSprites
	add hl, de
;>     DrawEntitySprites(frame, 2)
	ld c, $02
	call DrawEntitySprites
;>     return FinishMasterStalfosPart(2)
	ld a, $02
	jp FinishMasterStalfosPart

.none
;> LoadEntityPosition()
	call LoadEntityPosition
.done
	ret


;@ def DrawMasterStalfosSlash(slot: c)
;@ path: boss/master_stalfos
;@ While wEntityTimer2 runs (just after a stroke): checks the sweep against Link
;@ (MasterStalfosSlashHitsLink) and draws it on his facing side.
;@ test: skip draws sprites through bank 0
DrawMasterStalfosSlash::
;> if wEntityTimer2[slot] == 0:
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, FinishMasterStalfosPart.done
;> MasterStalfosSlashHitsLink(slot)
	call MasterStalfosSlashHitsLink
;>@s sprites = MasterStalfosSlashRightSprites if wEntityDirection[slot] == 0 else MasterStalfosSlashLeftSprites
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, MasterStalfosSlashRightSprites
	and a
	jr z, .draw
;=@s
	ld hl, MasterStalfosSlashLeftSprites
.draw
;> DrawEntitySprites(sprites, 5)
	ld c, $05
	call DrawEntitySprites
;> count = 5
	ld a, $05
;> return FinishMasterStalfosPart(count)      # runs on into it

;@ def FinishMasterStalfosPart(count: a)
;@ path: boss/master_stalfos
;@ After drawing a part: reserves its count of OAM entries and restores the entity position for
;@ the next part.
;@ test: skip draws sprites through bank 0
FinishMasterStalfosPart::
;> ReserveOAMEntriesFar(count)
	call ReserveOAMEntriesFar
;> LoadEntityPosition()
	call LoadEntityPosition
.done
	ret


;@ def DrawMasterStalfosShield()
;@ path: boss/master_stalfos
;@ Draws the shield at its offset (wMasterStalfosShieldX/Y) and puts the sword clash box there
;@ (centre +12/+8, half size 8 x 6), so Link's sword bounces off it.
;@ test: skip draws sprites through bank 0
DrawMasterStalfosShield::
;> hActiveEntityX += wMasterStalfosShieldX
	ld a, [wMasterStalfosShieldX]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;> wClashBoxX = wMasterStalfosShieldX + 0x0C
	ld a, [wMasterStalfosShieldX]
	add $0c
	ld [wClashBoxX], a
;> hActiveEntityDrawY += wMasterStalfosShieldY
	ld a, [wMasterStalfosShieldY]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> wClashBoxY = wMasterStalfosShieldY + 8
	ld a, [wMasterStalfosShieldY]
	add $08
	ld [wClashBoxY], a
;> wClashBoxHalfWidth = 8
	ld a, $08
	ld [wClashBoxHalfWidth], a
;> wClashBoxHalfHeight = 6
	ld a, $06
	ld [wClashBoxHalfHeight], a
;> DrawEntity16x16(MasterStalfosShieldSprites)
	ld de, MasterStalfosShieldSprites
	call DrawEntity16x16
;> return FinishMasterStalfosPart(2)
	ld a, $02
	jp FinishMasterStalfosPart


;@ def DrawMasterStalfosTorso()
;@ path: boss/master_stalfos
;@ Draws the torso (frame wMasterStalfosTorsoFrame) wMasterStalfosTorsoY pixels above the legs.
;@ test: skip draws sprites through bank 0
DrawMasterStalfosTorso::
;> hActiveEntityDrawY += wMasterStalfosTorsoY
	ld a, [wMasterStalfosTorsoY]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;>@t frame = MasterStalfosTorsoSprites + (wMasterStalfosTorsoFrame * 16) & 0xF0
	ld a, [wMasterStalfosTorsoFrame]
	rla
	rla
	rla
	rla
	and $f0
;=@t
	ld e, a
	ld d, b
	ld hl, MasterStalfosTorsoSprites
	add hl, de
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
;> return FinishMasterStalfosPart(4)
	ld a, $04
	jp FinishMasterStalfosPart


;@ def DrawMasterStalfosLegs()
;@ path: boss/master_stalfos
;@ Draws the legs (frame wMasterStalfosLegsFrame) at wMasterStalfosLegsY - not while the torso has
;@ sunk onto them (wMasterStalfosTorsoY = 0, the heap of bones).
;@ test: skip draws sprites through bank 0
DrawMasterStalfosLegs::
;> if wMasterStalfosTorsoY == 0:
	ld a, [wMasterStalfosTorsoY]
	cp $00
;>     return
	ret z
;> hActiveEntityDrawY += wMasterStalfosLegsY
	ld a, [wMasterStalfosLegsY]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;>@l frame = MasterStalfosLegsSprites + (wMasterStalfosLegsFrame * 16) & 0xF0
	ld a, [wMasterStalfosLegsFrame]
	rla
	rla
	rla
	rla
	and $f0
;=@l
	ld e, a
	ld d, b
	ld hl, MasterStalfosLegsSprites
	add hl, de
;> DrawEntitySprites(frame, 4)
	ld c, $04
	call DrawEntitySprites
;> return FinishMasterStalfosPart(4)
	ld a, $04
	jp FinishMasterStalfosPart


;@ def MasterStalfosSlashHitsLink(slot: c)
;@ path: boss/master_stalfos
;@ Unless Link is in the air or invincible: if Link is inside the sweep (in front of him, 8 pixels
;@ to his facing side, within 26 across and 12 up or down of the blade's line 24 below his drawn
;@ y), Link is thrown back away from him (speed $28, into the air with height speed $13), takes
;@ 8 damage and is invincible for $20 frames.
;@ test: skip changes Link's state
MasterStalfosSlashHitsLink::
;> if wInvincibilityCounter | wIsLinkInTheAir != 0:
	ld hl, wIsLinkInTheAir
	ld a, [wInvincibilityCounter]
	or [hl]
;>     return
	jr nz, .done
;> line = (hActiveEntityDrawY + 0x18) & 0xFF
	ldh a, [hActiveEntityDrawY]
	add $18
	ld e, a
;>@y if (hLinkY - hLinkPositionZ + 8 - line + 0x0C) & 0xFF >= 0x18: return
	ldh a, [hLinkY]
	ld hl, hLinkPositionZ
	sub [hl]
	add $08
	sub e
	add $0c
;=@y
	cp $18
	jr nc, .done
;>@side side = 8 if wEntityDirection[slot] == 0 else 0xF8
	ld hl, wEntityDirection
	add hl, bc
	ld e, $08
	ld a, [hl]
	and a
	jr z, .side
;=@side
	ld e, $f8
.side
;> if (hActiveEntityX + side - hLinkX + 0x1A) & 0xFF >= 0x34:
	ldh a, [hActiveEntityX]
	add e
	ld hl, hLinkX
	sub [hl]
	add $1a
	cp $34
;>     return
	jr nc, .done
;> GetVectorTowardsLink(0x28)
	ld a, $28
	call GetVectorTowardsLink
;> hLinkSpeedY = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
;> hLinkSpeedX = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
;> wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
;> hLinkSpeedZ = 0x13
	ld a, $13
	ldh [hLinkSpeedZ], a
;> wSubtractHealthBuffer = 8
	ld a, $08
	ld [wSubtractHealthBuffer], a
;> wInvincibilityCounter = 0x20
	ld a, $20
	ld [wInvincibilityCounter], a
;> hWaveSfx = 3
	ld a, $03
	ldh [hWaveSfx], a
.done
	ret


;@ path: object/fireball_shooter
;@ Speed of the shots for each map 0-9 (the dungeons), meant to be passed to
;@ SetEntitySpeedTowardsLink. Never read: FireballShooterHandler compares the constant $14
;@ instead of the map number, so every shot flies at speed $14.
FireballShooterSpeeds::
	db $12, $14, $16, $18, $19, $1a, $1a, $1a, $1a, $1a

;@ def FireballShooterHandler(slot: c)
;@ path: object/fireball_shooter
;@ Entity $9E, an invisible shooter on a statue of the room: every 128 frames, while any ordinary
;@ enemy is still alive in the room (not another shooter, not a shot $7D, not type $82, not an
;@ entity with physics bit 7) and the room's event is not done, it fires a shot ($7D, the
;@ Goponga flower's fireball) at Link. It holds fire while Link is within 32 pixels.
;@ wEntitySpriteVariant serves as its frame counter.
;@ test: skip spawns entities
FireballShooterHandler::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;>@near if (EntityLinkDiffX(slot)[0] + 0x20) & 0xFF < 0x40 and (EntityLinkDiffY(slot)[0] + 0x20) & 0xFF < 0x40:
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, .count
;=@near
	call EntityLinkDiffY
	add $20
	cp $40
;>     return                                  # Link too close
	jr c, FireballShooterReturn
.count
;> wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntitySpriteVariant[slot] & 0x7F != 0:
	and $7f
;>     return
	ret nz
;>@for for e in range(15, -1, -1):             # any enemy left?
	ld e, $0f
	ld d, b
.loop
;>@skip     if wEntityType[e] in (0x82, 0x9E, 0x7D):
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $82
	jr z, .next
	cp $9e
;=@skip
	jr z, .next
	cp $7d
	jr z, .next
;>         continue
;>     if wEntityPhysicsFlags[e] & 0x80:
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $80
	jr nz, .next
;>         continue
;>     if wEntityStatus[e] == 5:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
;>         return FireballShooterFire(slot)
	jr z, FireballShooterFire
.next
;=@for
	dec e
	ld a, e
	cp $ff
	jr nz, .loop
;> return
	ret

FireballShooterFire:
;> if wRoomEventDone:                          # FireballShooterFire: shoot at Link
	ld a, [wRoomEventDone]
	and a
;>     return
	ret nz
;> shot = SpawnEntity(0x7D)
	ld a, $7d
	call SpawnEntity
;> if carry: return
	jr c, FireballShooterReturn
;> wEntityX[shot] = hMultiPurpose0              # at the shooter
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[shot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>@sp speed = 0x14                             # (FireballShooterSpeeds[hMapId] is never used)
	push bc
	push de
	pop bc
	ldh a, [hMapId]
	ld e, a
	ld a, $14
;=@sp
	cp $0a
	jr nc, .aim
	ld hl, FireballShooterSpeeds
	add hl, de
	ld a, [hl]
.aim
;> SetEntitySpeedTowardsLink(speed)            # for the shot (its slot in bc meanwhile)
	call SetEntitySpeedTowardsLink
	pop bc
FireballShooterReturn:
	ret


;@ def HiddenSwordMoblinHandler(slot: c)
;@ path: enemy/sword_moblin
;@ Entity $94, invisible, sitting on a pot-like object of the room. Once a hit knocks it
;@ (wEntityIgnoreHitsTimer set), the object shatters like a pot (BreakIntoPiecesFar), the room
;@ object under it becomes $91 (background tiles $08-$0B) and a sword moblin ($14) jumps out, 8
;@ pixels lower, carrying its drop ($3C). If the room's bit 4 is set it is already gone.
;@ test: skip spawns entities and edits the room
HiddenSwordMoblinHandler::
;> if wEntityLoadOrder[slot] == 0:              # first frame
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	cp $00
	jr nz, .active
;>     if hRoomStatus & 0x10:
	ldh a, [hRoomStatus]
	and $10
;>         return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
;>     wEntityLoadOrder[slot] = 0xFF
	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
;>     wEntityDropType[slot] = 0x3C
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c
.active
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> wEntitySpriteVariant[slot] = 0
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], b
;> if wEntityIgnoreHitsTimer[slot] == 0:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, HiddenMoblinDrawColumn.done
;> moblin = SpawnEntity(0x14)
	ld a, $14
	call SpawnEntity
;> if carry: return
	jr c, HiddenMoblinDrawColumn.done
;> wEntityDropType[moblin] = wEntityDropType[slot]
	ld hl, wEntityDropType
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDropType
	add hl, de
	ld [hl], a
;> wEntityX[moblin] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[moblin] = hMultiPurpose1 + 8
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $08
	ld [hl], a
;> BreakIntoPiecesFar()
	call BreakIntoPiecesFar
;> hBGPosX = hActiveEntityX - 8
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
;> hBGPosY = hActiveEntityY - 0x10
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hBGPosY], a
;>@t tile = (hBGPosY & 0xF0) | (hBGPosX >> 4)
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
;=@t
	or e
	ld e, a
	ld d, b
;> wRoomObjects[tile] = 0x91
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $91
;> GetBGAddress()
	call GetBGAddress
;> n = wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
;> p = wDrawCommand + n
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize = n + 10
	add $0a
	ld [wDrawCommandsSize], a
;> p = HiddenMoblinDrawColumn(p, 0x08)             # left column: tiles $08/$0A
	ld e, $08
	call HiddenMoblinDrawColumn
;> return HiddenMoblinDrawColumn(p, 0x09)          # right column: tiles $09/$0B; runs on into it
	ld e, $09

;@ def HiddenMoblinDrawColumn(p: hl, tile: e) -> hl
;@ path: enemy/sword_moblin
;@ Writes a draw command at p for one column of a room object: 2 tiles downwards (tile, tile + 2)
;@ at hBGAddrHigh/hBGAddrLow, which then moves on by one tile; ends the list with 0 (overwritten
;@ by a following command).
;@ test: skip writes draw commands
HiddenMoblinDrawColumn::
;> p[0] = hBGAddrHigh
	ldh a, [hBGAddrHigh]
	ld [hli], a
;> p[1] = hBGAddrLow
	ldh a, [hBGAddrLow]
	ld [hli], a
;> hBGAddrLow += 1
	inc a
	ldh [hBGAddrLow], a
;> p[2] = 0x81                                  # 2 tiles downwards
	ld a, $81
	ld [hli], a
;> p[3] = tile
	ld a, e
	ld [hli], a
;> p[4] = tile + 2
	inc a
	inc a
	ld [hli], a
;> p[5] = 0
	xor a
	ld [hl], a
.done
;> return p + 5
	ret


;@ path: enemy/star
;@ The star, drawn by DrawEntity16x16: 5 frames of 4 bytes (tile and attributes of the left
;@ half, then of the right half). Frames 0-3 (tiles $74-$7A) are the spinning star, frame 4 (tile
;@ $7C) is not used.
StarSprites::
	db $74, $00, $74, $20, $76, $00, $78, $00, $7a, $00, $7a, $20, $78, $20, $76, $20
	db $7c, $00, $7c, $00

;@ def StarHandler(slot: c)
;@ path: enemy/star
;@ Entity $9C, the star: flies in a straight line and bounces off walls, turning over (frames 0-3,
;@ every 8 frames).
;@ test: skip draws sprites and calls entity engine routines in bank 3
StarHandler::
;> DrawEntity16x16(StarSprites)
	ld de, StarSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> bounce_x = wEntityCollisions[slot] & 0x03 != 0               # wall left or right
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, .bounceX
;> bounce_y = not bounce_x and wEntityCollisions[slot] & 0x0C != 0   # wall above or below
	ld a, [hl]
	and $0c
	jr nz, .bounceY
	jr .animate
.bounceX
;> if bounce_x:
;>     wEntitySpeedX[slot] = -wEntitySpeedX[slot] & 0xFF
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
;>     pass                                     # on to the animation
	jr .animate
.bounceY
;> if bounce_y:
;>     wEntitySpeedY[slot] = -wEntitySpeedY[slot] & 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
.animate
;> frame = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;> SetEntitySpriteVariant(slot, frame)
	call SetEntitySpriteVariant
	ret


;@ path: enemy/hiding_zol
;@ The zol, drawn by DrawEntity16x16: 4 frames of 4 bytes (tile and attributes of the left half,
;@ then of the right half; each half the mirror image of the other). Frames 0 and 1 are empty
;@ ($FF; frame 1 is drawn by HidingZolSmallSprites instead), 2 = coming out (tile $54), 3 = the
;@ whole zol (tile $52).
HidingZolSprites::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $54, $00, $54, $20, $52, $00, $52, $20
;@ path: enemy/hiding_zol
;@ Frame 1 of the zol, a small bump in the ground, drawn by DrawEntity8x16 (tile and attributes of
;@ one 8x16 sprite per frame; frames 0 and 1 both tile $56).
HidingZolSmallSprites::
	db $56, $00, $56, $00

;@ def HidingZolHandler(slot: c)
;@ path: enemy/hiding_zol
;@ Entity $9B, a zol hidden in the floor. When Link comes within 32 pixels it rises out and hops
;@ at him 3 to 6 times (wEntityPrivate1), quivering between hops, then sinks back into the floor
;@ for $50 frames. It falls with gravity (2 per frame); the landed flag goes to
;@ hBGTilesRequestCopy for the states. States (wEntityState): 0 hidden, 1 emerge, 2 land, 3
;@ quiver, 4 hop, 5 in the air, 6 sink.
;@ test: skip draws sprites and calls entity engine routines in bank 3
HidingZolHandler::
;> if hActiveEntitySpriteVariant == 1:
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, .big
;>     DrawEntity8x16(HidingZolSmallSprites)
	ld de, HidingZolSmallSprites
	call DrawEntity8x16
	jr .update
;> else:
.big
;>     DrawEntity16x16(HidingZolSprites)
	ld de, HidingZolSprites
	call DrawEntity16x16
.update
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> wEntitySpeedZ[slot] -= 2                     # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> landed = wEntityZ[slot] & 0x80
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
;> if landed:
	jr z, .states
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.states
;> return HidingZolStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/hiding_zol
;@ States of the hiding zol (wEntityState), see HidingZolHandler.
HidingZolStates::
	dw HidingZol_Hidden
	dw HidingZol_Emerge
	dw HidingZol_Land
	dw HidingZol_Quiver
	dw HidingZol_Hop
	dw HidingZol_InAir
	dw HidingZol_Sink

;@ def HidingZol_Hidden(slot: c)
;@ path: enemy/hiding_zol
;@ State 0: once its timer is up, waits for Link to come within 32 pixels; then it comes out
;@ ($20 frames, state 1) and will hop 3-6 times.
;@ test: skip draws on random numbers
HidingZol_Hidden::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done
;>@near if (EntityLinkDiffX(slot)[0] + 0x20) & 0xFF < 0x40 and (EntityLinkDiffY(slot)[0] + 0x20) & 0xFF < 0x40:
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, .done
;=@near
	call EntityLinkDiffY
	add $20
	cp $40
	jr nc, .done
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityPrivate1[slot] = (GetRandomByte() & 3) + 3      # hops
	call GetRandomByte
	and $03
	add $03
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
.done
;> return
	ret


;@ def HidingZol_Emerge(slot: c)
;@ path: enemy/hiding_zol
;@ State 1: shows the bump (frame 1) and then the zol half out (frame 2, last $10 frames); then it
;@ jumps out (height 8, height speed 8, frame 3, physics flags $12, jingle $24) and waits to land
;@ (state 2).
;@ test: skip plays sounds
HidingZol_Emerge::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return HidingZolEmergeFrame(slot)
	jr nz, HidingZolEmergeFrame
;> wEntityZ[slot] = 8
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $08
;> wEntitySpeedZ[slot] = 8
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
;> wEntityPhysicsFlags[slot] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $12
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
;> wEntityState[slot] += 1
	call IncrementEntityState
;> return PlayJingle24()                         # runs on into it

;@ def PlayJingle24()
;@ path: sound/jingle
;@ Requests jingle $24 (a jump).
;@ test: c = 0
PlayJingle24::
;> hJingle = 0x24
	ld a, $24
	ldh [hJingle], a
	ret


;@ def HidingZolEmergeFrame(slot: c, timer: a)
;@ path: enemy/hiding_zol
;@ Frame 1 (the bump) while the timer is $10 or more, frame 2 (half out) below.
;@ test: a = rand(1, 32); c = rand(0, 15)
HidingZolEmergeFrame::
;> frame = 1 if timer >= 0x10 else 2
	ld e, $01
	cp $10
	jr nc, .set
	ld e, $02
.set
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def HidingZol_Land(slot: c)
;@ path: enemy/hiding_zol
;@ State 2: once landed, quivers $20 frames (state 3).
;@ test: c = rand(0, 15)
HidingZol_Land::
;> if hBGTilesRequestCopy != 0:                 # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .done
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
.done
	ret


;@ def HidingZol_Quiver(slot: c)
;@ path: enemy/hiding_zol
;@ State 3: can be hit; jiggles left and right (half a pixel, switching every 4 frames); then it
;@ stops and hops after $10 frames (state 4).
;@ test: skip checks weapon hits through bank 3
HidingZol_Quiver::
;> EntityCheckWeaponHits()
	call EntityCheckWeaponHits
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .jiggle
;>     wEntityTimer[slot] = 0x10
	ld [hl], $10
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return
	ret

.jiggle
;>@j wEntitySpeedX[slot] = 0xF8 if t & 4 else 0x08
	ld e, $08
	and $04
	jr z, .set
	ld e, $f8
.set
	ld hl, wEntitySpeedX
	add hl, bc
;=@j
	ld [hl], e
;> AddEntitySpeedToPosX(slot)
	call AddEntitySpeedToPosX
	ret


;@ def HidingZol_Hop(slot: c)
;@ path: enemy/hiding_zol
;@ State 4: when the timer is up it hops at Link (speed $0C, height speed $18, jingle $24; state 5).
;@ Frame 3.
;@ test: skip checks Link collision through bank 3
HidingZol_Hop::
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> HidingZolCheckWalls(slot)
	call HidingZolCheckWalls
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .frame
;>     SetEntitySpeedTowardsLink(0x0C)
	ld a, $0c
	call SetEntitySpeedTowardsLink
;>     wEntitySpeedZ[slot] = 0x18
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;>     PlayJingle24()
	call PlayJingle24
;>     wEntityState[slot] += 1
	call IncrementEntityState
.frame
;> SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
	ret


;@ def HidingZol_InAir(slot: c)
;@ path: enemy/hiding_zol
;@ State 5: in the air (frame 2). On landing it stops; after $20 frames it hops again (state 4),
;@ or after the last hop it sinks into the floor (state 6, $30 frames, physics flags $D2).
;@ test: skip checks Link collision through bank 3
HidingZol_InAir::
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> HidingZolCheckWalls(slot)
	call HidingZolCheckWalls
;> if hBGTilesRequestCopy != 0:                 # landed
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, .frame
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityState[slot] = 4
	call IncrementEntityState
	ld [hl], $04
;>     wEntityTimer[slot] = 0x20
	call GetEntityTimer
	ld [hl], $20
;>     wEntityPrivate1[slot] -= 1
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
;>     if wEntityPrivate1[slot] == 0:          # last hop
	jr nz, .frame
;>         wEntityState[slot] = 6
	call IncrementEntityState
	ld [hl], $06
;>         wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
;>         wEntityPhysicsFlags[slot] = 0xD2
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $d2
.frame
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
	ret


;@ def HidingZol_Sink(slot: c)
;@ path: enemy/hiding_zol
;@ State 6: sinks into the floor (frames 3, 2, 1 for $10 frames each); then lies hidden (state 0,
;@ frame 0) and stays put for $50 frames.
;@ test: c = rand(0, 15)
HidingZol_Sink::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .sinking
;>     wEntityTimer[slot] = 0x50
	ld [hl], $50
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     return SetEntitySpriteVariant(slot, 0)
	xor a
	call SetEntitySpriteVariant
	ret

.sinking
;>@f frame = 3 if t >= 0x20 else 2 if t >= 0x10 else 1
	ld e, $03
	cp $20
	jr nc, .set
	ld e, $01
	cp $10
	jr c, .set
;=@f
	inc e
.set
;> SetEntitySpriteVariant(slot, frame)
	ld a, e
	call SetEntitySpriteVariant
	ret


;@ def HidingZolCheckWalls(slot: c)
;@ path: enemy/hiding_zol
;@ The wall check with wEntityIgnoreHitsTimer set to 3 for its duration (then 0).
;@ test: skip checks walls through bank 3
HidingZolCheckWalls::
;> wEntityIgnoreHitsTimer[slot] = 3
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


;@ def FlyingTilesHandler(slot: c)
;@ path: enemy/flying_tiles
;@ Entity $9A, the invisible starter of a flying floor tiles trap: one after another 16 floor
;@ tiles lift off and fly at Link (each a Facade entity $5A in its flying tile form,
;@ wEntityPrivate1 = 2), in the order of one of 8 patterns (FlyingTilesOrder), picked by the
;@ starter's x position. The pattern start is kept in wSmasherBallSlot (shared scratch).
;@ States (wEntityState): 0 start, 1 launch.
;@ test: skip spawns entities
FlyingTilesHandler::
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> return FlyingTilesStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/flying_tiles
;@ States of the flying tiles starter (wEntityState), see FlyingTilesHandler.
FlyingTilesStates::
	dw FlyingTiles_Start
	dw FlyingTiles_Launch

;@ def FlyingTiles_Start(slot: c)
;@ path: enemy/flying_tiles
;@ State 0: the pattern is (x & $70) / 16, i.e. the 16-byte block of FlyingTilesOrder at x & $70;
;@ the first tile flies after $80 frames (state 1).
;@ test: c = rand(0, 15)
FlyingTiles_Start::
;> wSmasherBallSlot = hActiveEntityX & 0x70     # start of the pattern in FlyingTilesOrder
	ldh a, [hActiveEntityX]
	and $70
	ld [wSmasherBallSlot], a
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> wEntityState[slot] += 1
	call IncrementEntityState
	ret


;@ path: enemy/flying_tiles
;@ 8 patterns of 16 floor tiles, the order in which the tiles fly; each byte is the tile's place
;@ in the room, $YX (high nibble = row, low nibble = column of 16-pixel tiles). Patterns 3-7 are
;@ all the same as pattern 0.
FlyingTilesOrder::
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $21, $28, $53, $56, $34, $45, $35, $44, $31, $48, $38, $41, $14, $66, $15, $63
	db $31, $45, $38, $44, $13, $56, $16, $53, $27, $42, $47, $22, $65, $33, $64, $36
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
;@ path: enemy/flying_tiles
;@ Frames between two flying tiles for each map 0-8 (the dungeons): $30, in maps 7 and 8 $28.
FlyingTilesDelays::
	db $30, $30, $30, $30, $30, $30, $30, $28, $28

;@ def FlyingTiles_Launch(slot: c)
;@ path: enemy/flying_tiles
;@ State 1: every FlyingTilesDelays[map] frames the next tile (wEntityPrivateCounter, 0-15) flies:
;@ a Facade entity in its tile form at the tile's place (x = column * 16 + 8, y = row * 16 + 16),
;@ physics flags $12, no hitbox flags, options or health group. Its wEntityPrivate4 gets the
;@ starter's row ((y - 16) & $F0, if not 0); the last tile of pattern 0 gets 1 there instead when
;@ the room's event is of kind 3. After 16 tiles the starter is gone.
;@ test: skip spawns entities
FlyingTiles_Launch::
;> if wEntityPrivateCounter[slot] == 0x10:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $10
;>     return ClearEntityStatus(slot)
	jp z, ClearEntityStatus
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
;>     return
	jr nz, .done
;>@d wEntityTimer[slot] = FlyingTilesDelays[hMapId]
	push hl
	ldh a, [hMapId]
	ld e, a
	ld d, b
	ld hl, FlyingTilesDelays
	add hl, de
;=@d
	ld a, [hl]
	pop hl
	ld [hl], a
;> tile = SpawnEntity(0x5A)
	ld a, $5a
	call SpawnEntity
;> if carry: return
	jr c, .done
;> wEntityPrivate1[tile] = 2                     # flying tile form
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;>@i i = wSmasherBallSlot + wEntityPrivateCounter[slot]
	push bc
	ld a, [wSmasherBallSlot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
;> wEntityPrivateCounter[slot] += 1
	inc [hl]
;=@i
	ld c, a
;> row = (hActiveEntityY - 0x10) & 0xF0
	ld hl, wEntityPrivate4
	add hl, de
	ldh a, [hActiveEntityY]
	sub $10
	and $f0
;> if row != 0:
	jr z, .last
;>     wEntityPrivate4[tile] = row
	ld [hl], a
.last
;>@l if i == 0x0F and wRoomEvent & 0x1F == 3:
	ld a, c
	cp $0f
	jr nz, .place
	ld a, [wRoomEvent]
	and $1f
	cp $03
;=@l
	jr nz, .place
;>     wEntityPrivate4[tile] = 1
	ld [hl], $01
.place
;> place = FlyingTilesOrder[i]
	ld hl, FlyingTilesOrder
	add hl, bc
	ld a, [hl]
	push af
;> wEntityX[tile] = ((place << 4) & 0xF0) | 8
	swap a
	and $f0
	or $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[tile] = (place & 0xF0) + 0x10
	pop af
	and $f0
	add $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityPhysicsFlags[tile] = 0x12
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
;> wEntityHitboxFlags[tile] = 0
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
;> wEntityOptions1[tile] = 0
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
;> wEntityHealthGroup[tile] = 0
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $00
	pop bc
.done
	ret


;@ path: enemy/water_tektite
;@ The water tektite, drawn by DrawEntity16x16: 2 frames of 4 bytes (tile and attributes of the
;@ left half, then of the right half; each half the mirror image of the other), tiles $70 and $72.
WaterTektiteSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20

;@ def WaterTektiteHandler(slot: c)
;@ path: enemy/water_tektite
;@ Entity $99, the water tektite: skates over the water in spurts - it speeds up for $20 frames in
;@ a random diagonal (wEntityPrivate1/2 = +1 or -1 per axis), then glides to a stop and pauses $10
;@ frames. Hitting the edge of the water (any wall) stops it at once. Its legs move every 16
;@ frames. States (wEntityState): 0 pause, 1 speed up, 2 slow down.
;@ test: skip draws sprites and calls entity engine routines in bank 3
WaterTektiteHandler::
;> DrawEntity16x16(WaterTektiteSprites)
	ld de, WaterTektiteSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> if wEntityCollisions[slot] & 0x0F:            # at the edge
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, .hits
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityState[slot] = 0
	call IncrementEntityState
	xor a
	ld [hl], a
;>     hActiveEntityState = 0
	ldh [hActiveEntityState], a
.hits
;> EntityCheckHits()
	call EntityCheckHits
;> return WaterTektiteStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/water_tektite
;@ States of the water tektite (wEntityState), see WaterTektiteHandler.
WaterTektiteStates::
	dw WaterTektite_Pause
	dw WaterTektite_SpeedUp
	dw WaterTektite_SlowDown

;@ def WaterTektite_Pause(slot: c)
;@ path: enemy/water_tektite
;@ State 0: after the pause it picks a random diagonal and speeds up for $20 frames (state 1).
;@ test: skip draws on random numbers
WaterTektite_Pause::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0x20
	ld [hl], $20
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>@p1     wEntityPrivate1[slot] = (GetRandomByte() & 2) - 1
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate1
	add hl, bc
;=@p1
	ld [hl], a
;>@p2     wEntityPrivate2[slot] = (GetRandomByte() & 2) - 1
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
;=@p2
	ld [hl], a
.done
	ret


;@ def WaterTektite_SpeedUp(slot: c)
;@ path: enemy/water_tektite
;@ State 1: every other frame adds wEntityPrivate1 to the x speed and wEntityPrivate2 to the y
;@ speed; when the time is up it slows down (state 2).
;@ test: c = rand(0, 15)
WaterTektite_SpeedUp::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
;>     return IncrementEntityState(slot)
	jp z, IncrementEntityState
;> if t & 1 == 0:
	and $01
	jr nz, .done
;>@x     wEntitySpeedX[slot] += wEntityPrivate1[slot]
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
;=@x
	ld [hl], a
;>@y     wEntitySpeedY[slot] += wEntityPrivate2[slot]
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
;=@y
	ld [hl], a
.done
	ret


;@ def WaterTektite_SlowDown(slot: c)
;@ path: enemy/water_tektite
;@ State 2: every other frame both speeds step 1 towards 0; once the x speed is 0 it pauses $10
;@ frames (state 0).
;@ test: c = rand(0, 15)
WaterTektite_SlowDown::
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
;>     return
	jr nz, WaterTektiteStepToZero.done
;> if wEntitySpeedX[slot] == 0:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .slow
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntityTimer[slot] = 0x10
	call GetEntityTimer
	ld [hl], $10
;>     return
	ret

.slow
;> WaterTektiteStepToZero(wEntitySpeedX, slot)
	call WaterTektiteStepToZero
;> return WaterTektiteStepToZero(wEntitySpeedY, slot)          # runs on into it
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]

;@ def WaterTektiteStepToZero(p: hl, value: a)
;@ path: enemy/water_tektite
;@ mem[p] += 1 if value is negative, else -= 1 (so a speed of 0 becomes -1).
;@ test: skip writes through a pointer
WaterTektiteStepToZero::
;> mem[p] += 1 if value & 0x80 else -1
	bit 7, a
	jr z, .down
	inc [hl]
	inc [hl]
.down
	dec [hl]
.done
	ret


;@ path: object/horse_head
;@ A horse head statue piece, drawn by DrawEntity16x16: 5 frames of 4 bytes (tile and attributes
;@ of the left half, then of the right half): 0 = standing upright (tiles $60/$62), 1 = lying on
;@ its side (tiles $64/$66), 2 = upside down (frame 0 flipped both ways), 3 = frame 1 flipped
;@ both ways, 4 = lying on the other side (frame 1 mirrored). Frames 0-3 make the tumble.
HorseHeadSprites::
	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $60, $60, $60, $66, $60, $64, $60
	db $66, $20, $64, $20

;@ def HorseHeadHandler(slot: c)
;@ path: object/horse_head
;@ Entity $98, one of the two horse head pieces in the Face Shrine (dungeon 6) room: Link lifts
;@ and throws them; a thrown piece bounces and tumbles about, then comes to rest showing a random
;@ side. Only when both stand upright (frame 0) does the room's event happen; otherwise a buzzer
;@ sounds and after $40 frames they topple over (frame 1) and can be thrown again. The second
;@ piece (wEntityLoadOrder != 0) keeps its slot in wSmasherBallSlot so that the first one can
;@ check it. Height falls with gravity (2 per frame); landing bounces it back up with half the
;@ speed (less than 7 is dropped); the landing speed is kept in hMultiPurposeH and the height in
;@ hBGTilesRequestCopy. States (wEntityState): 0/1 lying, 2 tumbling, 3 at rest, 4 judged.
;@ test: skip draws sprites and calls entity engine routines in bank 3
HorseHeadHandler::
;> if wEntityLoadOrder[slot] != 0:
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	and a
	jr z, .draw
;>     wSmasherBallSlot = slot                    # the second piece
	ld a, c
	ld [wSmasherBallSlot], a
.draw
;> DrawEntity16x16(HorseHeadSprites)
	ld de, HorseHeadSprites
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntitySpeedZ[slot] -= 2
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;> hBGTilesRequestCopy = wEntityZ[slot]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
;> if (wEntityZ[slot] - 1) & 0x80:              # on the ground
	dec a
	and $80
	jr z, .states
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     hMultiPurposeH = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
;>     bounce = ~((wEntitySpeedZ[slot] >> 1) | (wEntitySpeedZ[slot] & 0x80)) & 0xFF
	sra a
	cpl
;>     wEntitySpeedZ[slot] = bounce if bounce >= 7 else 0
	cp $07
	jr nc, .bounce
	xor a
.bounce
	ld [hl], a
.states
;> return HorseHeadStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: object/horse_head
;@ States of a horse head piece (wEntityState), see HorseHeadHandler.
HorseHeadStates::
	dw HorseHead_Lying
	dw HorseHead_Lying
	dw HorseHead_Tumble
	dw HorseHead_AtRest
	dw HorseHead_Judged

;@ def HorseHead_Lying(slot: c)
;@ path: object/horse_head
;@ States 0 and 1: waits to be picked up (HorseHeadCheckLift).
;@ test: skip checks Link collision through bank 3
HorseHead_Lying::
;> HorseHeadCheckLift(slot)
	call HorseHeadCheckLift
	ret


;@ path: object/horse_head
;@ x speed of a tumbling piece for each of 8 directions (0 = up, then clockwise in 45 degree
;@ steps), 1/16 pixel per frame.
HorseHeadSpeedX::
	db $00, $0c, $10, $0c, $00, $f4, $f0, $f4

;@ path: object/horse_head
;@ y speed for the same 8 directions.
HorseHeadSpeedY::
	db $f0, $f4, $00, $0c, $10, $0c, $00, $f4
;@ path: object/horse_head
;@ The side a piece comes to rest on, picked at random: frame 0 (upright) with chance 2 in 4, frame
;@ 1 or frame 4 (on one side or the other) 1 in 4 each.
HorseHeadRestFrames::
	db $00, $01, $04, $00

;@ def HorseHead_Tumble(slot: c)
;@ path: object/horse_head
;@ State 2 (thrown): tumbles (frames 0-3, every 8 frames). On the ground it turns one step left
;@ or right at random (at once after a hard landing, otherwise every 8 frames) and takes the
;@ speed of its new direction. A wall turns it round with half the speed and halves the time
;@ left. When the time is up it stops on a random side (HorseHeadRestFrames, state 3).
;@ test: skip draws on random numbers
HorseHead_Tumble::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .tumble
;>     ClearEntitySpeed()
	call ClearEntitySpeed
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>@rest     SetEntitySpriteVariant(slot, HorseHeadRestFrames[GetRandomByte() & 3])
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, HorseHeadRestFrames
	add hl, de
;=@rest
	ld a, [hl]
	call SetEntitySpriteVariant
;>     return
	ret

.tumble
;> if t & 7 == 0:
	and $07
	jr nz, .ground
;>     wEntitySpriteVariant[slot] = (wEntitySpriteVariant[slot] + 1) & 3
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
.ground
;> if (hBGTilesRequestCopy - 1) & 0x80:         # on the ground
	ldh a, [hBGTilesRequestCopy]
	dec a
	and $80
	jr z, .walls
;>     HorseHeadMark(slot)
	call HorseHeadMark
;>@hard     if (hMultiPurposeH - 0xFC) & 0x80 == 0 and hFrameCounter & 7 != 0:     # soft landing: not every frame
	ldh a, [hMultiPurposeH]
	sub $fc
	and $80
	jr nz, .turn
	ldh a, [hFrameCounter]
	and $07
;=@hard
	jr nz, .walls
;>         pass
.turn
;>     else:
;>         turn = 1 if GetRandomByte() & 1 == 0 else 0xFF
	call GetRandomByte
	and $01
	ld e, $01
	jr z, .dir
	ld e, $ff
.dir
;>         dir = (wEntityDirection[slot] + turn) & 7
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	add e
	and $07
;>         wEntityDirection[slot] = dir
	ld [hl], a
;>@sx         wEntitySpeedX[slot] = HorseHeadSpeedX[dir]
	ld e, a
	ld d, b
	ld hl, HorseHeadSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@sx
	add hl, bc
	ld [hl], a
;>         wEntitySpeedY[slot] = HorseHeadSpeedY[dir]
	ld hl, HorseHeadSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
;>         HorseHeadMark(slot)
	call HorseHeadMark
.walls
;> if wEntityCollisions[slot] != 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr z, HorseHeadMark.done
;> wEntityDirection[slot] ^= 4                   # turn round
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
;> wEntityTimer[slot] >>= 1
	call GetEntityTimer
	srl [hl]
;> HorseHeadTurnSpeed(wEntitySpeedX, slot)
	ld hl, wEntitySpeedX
	call HorseHeadTurnSpeed
;> return HorseHeadTurnSpeed(wEntitySpeedY, slot)       # runs on into it
	ld hl, wEntitySpeedY

;@ def HorseHeadTurnSpeed(array: hl, slot: c)
;@ path: object/horse_head
;@ array[slot] = (~array[slot] >> 1 (signed)) + 1 - turns a speed round at about half of it - and
;@ then HorseHeadMark.
;@ test: skip writes through a pointer
HorseHeadTurnSpeed::
;> p = array + slot
	add hl, bc
;> mem[p] = ((((~mem[p] & 0xFF) >> 1) | (~mem[p] & 0x80)) + 1) & 0xFF
	ld a, [hl]
	cpl
	sra a
	inc a
	ld [hl], a
;> return HorseHeadMark(slot)                   # runs on into it

;@ def HorseHeadMark(slot: c)
;@ path: object/horse_head
;@ Sets the piece's wEntityLedgeDirection to $FF.
;@ test: c = rand(0, 15)
HorseHeadMark::
;> wEntityLedgeDirection[slot] = 0xFF
	ld hl, wEntityLedgeDirection
	add hl, bc
	ld [hl], $ff
.done
	ret


;@ def HorseHead_AtRest(slot: c)
;@ path: object/horse_head
;@ State 3: the first piece waits until the second (slot wSmasherBallSlot) is at rest too; then
;@ both are judged (state 4). Both upright: TriggerRoomEvent. Otherwise both wait $40 frames and
;@ the buzzer sounds.
;@ test: skip triggers the room event
HorseHead_AtRest::
;> if wEntityLoadOrder[slot] != 0:              # only the first piece judges
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	and a
;>     return
	jr nz, .done
;> other = wSmasherBallSlot
	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
;> if wEntityState[other] != 3:
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $03
;>     return
	jr nz, .done
;> wEntityState[other] += 1
	inc [hl]
;> wEntityState[slot] += 1
	call IncrementEntityState
;>@up if hActiveEntitySpriteVariant == 0 and wEntitySpriteVariant[other] == 0:
	ldh a, [hActiveEntitySpriteVariant]
	cp $00
	jr nz, .wrong
	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [hl]
;=@up
	cp $00
;>     return TriggerRoomEvent()
	jp z, TriggerRoomEvent
.wrong
;> wEntityTimer[other] = 0x40
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
;> wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;> return PlayNoAmmoSound()                      # the buzzer
	jp PlayNoAmmoSound

.done
	ret


;@ def HorseHead_Judged(slot: c)
;@ path: object/horse_head
;@ State 4: on the last frame of the wait the piece falls over (frame 1); it can be picked up
;@ again.
;@ test: skip checks Link collision through bank 3
HorseHead_Judged::
;> if wEntityTimer[slot] == 1:
	call GetEntityTimer
	cp $01
	jr nz, .lift
;>     SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
.lift
;> HorseHeadCheckLift(slot)
	call HorseHeadCheckLift
	ret


;@ def HorseHeadCheckLift(slot: c)
;@ path: object/horse_head
;@ When Link touches the piece and presses the button of the power bracelet (item 3 on B or A),
;@ not already carrying something and not in an item pose: he lifts it (status 7 = carried,
;@ state 2 for when it is thrown, wLinkIsCarrying = 1, wLiftDirection = his direction, lift sound).
;@ test: skip checks Link collision through bank 3
HorseHeadCheckLift::
;> if not EntityTouchesLink():
	call EntityTouchesLink
;>     return
	jr nc, .done
;> if wItemUsePoseTimer:
	ld a, [wItemUsePoseTimer]
	and a
;>     return
	jr nz, .done
;> if wItemB == 3:                               # power bracelet on B
	ld a, [wItemB]
	cp $03
	jr nz, .itemA
;>     if not hJoypadPressed & 0x20: return      # B not pressed
	ldh a, [hJoypadPressed]
	and $20
	jr nz, .lift
	jr .done
.itemA
;> else:
;>@a     if wItemA != 3 or not hJoypadPressed & 0x10: return
	ld a, [wItemA]
	cp $03
	jr nz, .done
	ldh a, [hJoypadPressed]
	and $10
;=@a
	jr z, .done
.lift
;> if wLinkIsCarrying:
	ld a, [wLinkIsCarrying]
	and a
;>     return
	jr nz, .done
;> wLinkIsCarrying = 1
	inc a
	ld [wLinkIsCarrying], a
;> wEntityState[slot] = 2
	call IncrementEntityState
	ld [hl], $02
;> wEntityStatus[slot] = 7                       # carried
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


;@ path: enemy/spiked_beetle
;@ The spiked beetle, drawn by DrawEntity16x16: 4 frames of 4 bytes (tile and attributes of the
;@ left half, then of the right half; each half the mirror image of the other): 0/1 = walking
;@ (tiles $70/$72), 2/3 = lying on its back, kicking (tiles $74/$76).
SpikedBeetleSprites::
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20
;@ path: enemy/spiked_beetle
;@ The same 4 frames with the tiles used in map 3 (tiles $60-$66).
SpikedBeetleSpritesMap3::
	db $60, $00, $60, $20, $62, $00, $62, $20, $64, $00, $64, $20, $66, $00, $66, $20

;@ def SpikedBeetleHandler(slot: c)
;@ path: enemy/spiked_beetle
;@ Entity $2C, the spiked beetle: wanders, and when Link comes in line with it (within 6 pixels of
;@ its row or column) it charges at him. Its spiked front cannot be hurt (hitbox flags $80,
;@ options $48); turned on its back (state 3, e.g. by a shield bash) it kicks helplessly and can
;@ be hit, then flips back onto its feet with a hop. Knocked back it stops. It falls with gravity
;@ (2 per frame); on its back it bounces when landing. States (wEntityState): 0 pause, 1 walk,
;@ 2 charge, 3 on its back.
;@ test: skip draws sprites and calls entity engine routines in bank 3
SpikedBeetleHandler::
;> sprites = SpikedBeetleSpritesMap3 if hMapId == 3 else SpikedBeetleSprites
	ld de, SpikedBeetleSprites
	ldh a, [hMapId]
	cp $03
	jr nz, .draw
	ld de, SpikedBeetleSpritesMap3
.draw
;> DrawEntity16x16(sprites)
	call DrawEntity16x16
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> if wEntityIgnoreHitsTimer[slot] != 0:         # knocked back
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .recoil
;>     ClearEntitySpeed()
	call ClearEntitySpeed
.recoil
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckHits()
	call EntityCheckHits
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> AddEntityZSpeedToPos(slot)
	call AddEntityZSpeedToPos
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntitySpeedZ[slot] -= 2                      # gravity
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
;>@g if wEntityZ[slot] & 0x80 or wEntityZ[slot] == 0:      # on the ground
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, .ground
	and a
;=@g
	jr nz, .states
.ground
;>     wEntityZ[slot] = 0
	ld [hl], b
;>     if hActiveEntityState == 3:               # on its back: bounce
	ldh a, [hActiveEntityState]
	cp $03
	jr nz, .stopZ
;>         wEntitySpeedX[slot] = (wEntitySpeedX[slot] >> 1) | (wEntitySpeedX[slot] & 0x80)
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
;>         wEntitySpeedY[slot] = (wEntitySpeedY[slot] >> 1) | (wEntitySpeedY[slot] & 0x80)
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
;>         wEntitySpeedZ[slot] = ~((wEntitySpeedZ[slot] >> 1) | (wEntitySpeedZ[slot] & 0x80)) & 0xFF
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
;>         if wEntitySpeedZ[slot] < 7:           # too weak: lies still
	cp $07
	jr nc, .bounce
;>             wEntitySpeedZ[slot] = 0
	ld [hl], b
;>             ClearEntitySpeed()
	call ClearEntitySpeed
	jr .states
.bounce
	jr .states
;>     else:
.stopZ
;>         wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
.states
;> if hActiveEntityState >= 4:
	ldh a, [hActiveEntityState]
	cp $04
	jr c, .run
;>     return
	ret

.run
;> return SpikedBeetleStates[hActiveEntityState](slot)
	rst $00

;@ path: enemy/spiked_beetle
;@ States of the spiked beetle (wEntityState), see SpikedBeetleHandler.
SpikedBeetleStates::
	dw SpikedBeetle_Pause
	dw SpikedBeetle_Walk
	dw SpikedBeetle_Charge
	dw SpikedBeetle_OnBack

;@ path: enemy/spiked_beetle
;@ x speed of the walking beetle per direction (0 right, 1 left, 2 up, 3 down), 1/16 pixel per frame.
SpikedBeetleSpeedX::
	db $06, $fa, $00, $00

;@ path: enemy/spiked_beetle
;@ y speed of the walking beetle per direction.
SpikedBeetleSpeedY::
	db $00, $00, $fa, $06

;@ def SpikedBeetle_Pause(slot: c)
;@ path: enemy/spiked_beetle
;@ State 0: stands; then walks for $30-$4F frames (state 1) in a random direction, 1 time in 4
;@ towards Link. Watches for Link (SpikedBeetleLookForLink).
;@ test: skip draws on random numbers
SpikedBeetle_Pause::
;> ClearEntitySpeed()
	call ClearEntitySpeed
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .look
;>     wEntityTimer[slot] = (GetRandomByte() & 0x1F) + 0x30
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     if GetRandomByte() & 6 == 0:
	call GetRandomByte
	and $06
	jr nz, .random
;>         dir = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
	jr .setDir
;>     else:
.random
;>         dir = GetRandomByte() & 3
	call GetRandomByte
	and $03
	ld e, a
.setDir
;>@sx     wEntitySpeedX[slot] = SpikedBeetleSpeedX[dir]
	ld d, b
	ld hl, SpikedBeetleSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
;=@sx
	ld [hl], a
;>     wEntitySpeedY[slot] = SpikedBeetleSpeedY[dir]
	ld hl, SpikedBeetleSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
.look
;> return SpikedBeetleLookForLink(slot)
	jr SpikedBeetleLookForLink

;@ def SpikedBeetle_Walk(slot: c)
;@ path: enemy/spiked_beetle
;@ State 1: walks; after the time it pauses $18 frames (state 0). Watches for Link: when Link is
;@ within 6 pixels of its column or row it charges at him (state 2, timer $FF).
;@ test: skip checks Link position through other routines
SpikedBeetle_Walk::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .walk
;>     wEntityTimer[slot] = 0x18
	ld [hl], $18
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.walk
;> SpikedBeetleWalkFrame()
	call SpikedBeetleWalkFrame
SpikedBeetleLookForLink:
;> wEntityHitboxFlags[slot] = 0x80               # SpikedBeetleLookForLink: spikes to the front
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $80
;> wEntityOptions1[slot] = 0x48
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $48
;>@line if (EntityLinkDiffX(slot)[0] + 6) & 0xFF < 0x0A or (EntityLinkDiffY(slot)[0] + 6) & 0xFF < 0x0A:
	call EntityLinkDiffX
	add $06
	cp $0a
	jr c, .charge
;=@line
	call EntityLinkDiffY
	add $06
	cp $0a
	jr nc, .done
.charge
;>     wEntityDirection[slot] = GetEntityDirectionToLink(slot)
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
.done
	ret


;@ path: enemy/spiked_beetle
;@ Top speed of the charge per direction (0 right, 1 left, 2 up, 3 down): x speeds.
SpikedBeetleChargeSpeedX::
	db $18, $e8, $00, $00

;@ path: enemy/spiked_beetle
;@ Top speed of the charge per direction: y speeds.
SpikedBeetleChargeSpeedY::
	db $00, $00, $e8, $18

;@ def SpikedBeetle_Charge(slot: c)
;@ path: enemy/spiked_beetle
;@ State 2: speeds up by 1 per frame towards the charge speed in its direction until it hits a
;@ wall or the time runs out; then it pauses (state 0).
;@ test: c = rand(0, 15)
SpikedBeetle_Charge::
;> if wEntityTimer[slot] != 0:
	call GetEntityTimer
	jr z, .stop
;>     dir = wEntityDirection[slot]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
;>     target = SpikedBeetleChargeSpeedX[dir]
	ld hl, SpikedBeetleChargeSpeedX
	add hl, de
	ld a, [hl]
;>     if target != wEntitySpeedX[slot]:
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	jr z, .speedY
;>         wEntitySpeedX[slot] += 1 if not (target - wEntitySpeedX[slot]) & 0x80 else -1
	and $80
	jr nz, .slowerX
	inc [hl]
	inc [hl]
.slowerX
	dec [hl]
.speedY
;>@ty     if SpikedBeetleChargeSpeedY[dir] != wEntitySpeedY[slot]:
	ld hl, SpikedBeetleChargeSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
;=@ty
	jr z, .wall
;>         wEntitySpeedY[slot] += 1 if not (SpikedBeetleChargeSpeedY[dir] - wEntitySpeedY[slot]) & 0x80 else -1
	and $80
	jr nz, .slowerY
	inc [hl]
	inc [hl]
.slowerY
	dec [hl]
.wall
;>     if wEntityCollisions[slot] == 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
;>         return SpikedBeetleWalkFrame()
	jr z, SpikedBeetleWalkFrame
.stop
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;> return SpikedBeetleWalkFrame()               # runs on into it

;@ def SpikedBeetleWalkFrame(slot: c)
;@ path: enemy/spiked_beetle
;@ Walking frames 0/1, switching every 16 frames.
;@ test: c = rand(0, 15)
SpikedBeetleWalkFrame::
;>@wf SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@wf
	call SetEntitySpriteVariant
	ret


;@ def SpikedBeetle_OnBack(slot: c)
;@ path: enemy/spiked_beetle
;@ State 3: on its back it can be hurt (options $08, no hitbox flags) and kicks its legs (frames
;@ 2/3). In the last $60 frames it wriggles left and right (switching every 4 frames; the wall
;@ check runs with wEntityIgnoreHitsTimer set to 1). When the time is up it hops back onto its
;@ feet (height speed $18) and pauses (state 0).
;@ test: skip checks walls through bank 3
SpikedBeetle_OnBack::
;> wEntityOptions1[slot] = 0x08
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $08
;> wEntityHitboxFlags[slot] = 0
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
;>@f SetEntitySpriteVariant(slot, ((hFrameCounter >> 4) & 1) + 2)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@f
	inc a
	inc a
	call SetEntitySpriteVariant
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t == 0:
	jr nz, .struggle
;>     wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
;>     wEntitySpeedZ[slot] = 0x18                # hop
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
;>     wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
;>     return
	ret

.struggle
;> if t < 0x60:
	cp $60
	jr nc, .walls
;>@w     wEntitySpeedX[slot] = 0x08 if t & 4 else 0xF8
	and $04
	ld a, $08
	jr nz, .set
	ld a, $f8
.set
	ld hl, wEntitySpeedX
	add hl, bc
;=@w
	ld [hl], a
.walls
;> saved = wEntityIgnoreHitsTimer[slot]
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push af
;> wEntityIgnoreHitsTimer[slot] = 1
	ld [hl], $01
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntityIgnoreHitsTimer[slot] = saved
	pop af
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], a
	ret


;@ path: unused
;@ A copy of WalkBaseFrames (base sprite frame per direction) that nothing reads.
UnusedWalkBaseFrames::
	db $06, $04, $02, $00

;@ def SwordMoblinHandler(slot: c)
;@ path: enemy/sword_moblin
;@ Entity $14, the moblin with a sword (and shield, which Link's sword bounces off). It patrols
;@ left and right; when it notices Link (close and not facing away, or a sword clash, or a hit)
;@ it charges at him. In the moblins' hideout (map $15) it only appears while Bow-Wow is held
;@ there (wIsBowWowFollowingLink = $80), is on guard at once, and on entering its room speaks (text
;@ $190). States (wEntityState): 0 pause, 1 patrol, 2 charge.
;@ test: skip draws sprites and calls entity engine routines in bank 3
SwordMoblinHandler::
;> if hMapId == 0x15 and wIsBowWowFollowingLink != 0x80:
	ldh a, [hMapId]
	cp $15
	jr nz, .draw
	ld a, [wIsBowWowFollowingLink]
	cp $80
;>     return ClearEntityStatus(slot)
	jp nz, ClearEntityStatus
.draw
;> DrawSwordMoblin(slot)
	call DrawSwordMoblin
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;>@al if hMapId == 0x15 or wEntityIgnoreHitsTimer[slot] != 0:
	ldh a, [hMapId]
	cp $15
	jr z, .alert
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
;=@al
	and a
	jr z, .checks
.alert
;>     SwordMoblinAlert(slot)
	call SwordMoblinAlert
.checks
;> ApplyRecoilIfNeeded(slot)
	call ApplyRecoilIfNeeded
;> EntityCheckSwordClash()
	call EntityCheckSwordClash
;> EntityCheckHits()
	call EntityCheckHits
;> return SwordMoblinStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: enemy/sword_moblin
;@ States of the sword moblin (wEntityState), see SwordMoblinHandler.
SwordMoblinStates::
	dw SwordMoblin_Pause
	dw SwordMoblin_Patrol
	dw SwordMoblin_Charge

;@ path: enemy/sword_moblin
;@ x speed of the patrol per direction (0 right, 1 left, 2 up, 3 down), 1/16 pixel per frame.
SwordMoblinSpeedX::
	db $06, $fa, $00, $00

;@ path: enemy/sword_moblin
;@ y speed of the patrol per direction.
SwordMoblinSpeedY::
	db $00, $00, $fa, $06

;@ def SwordMoblin_Pause(slot: c)
;@ path: enemy/sword_moblin
;@ State 0: stands and looks out for Link; then turns round and patrols $80 frames (state 1).
;@ test: skip checks Link position through other routines
SwordMoblin_Pause::
;> EntityCheckWalls()
	call EntityCheckWalls
;> wEntityPrivateCounter[slot] = 0
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $00
;> SwordMoblinLookForLink(slot)
	call SwordMoblinLookForLink
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, SwordMoblinTurnAround.done
;>     wEntityTimer[slot] = 0x80
	ld [hl], $80
;>     wEntityState[slot] += 1
	call IncrementEntityState
;>     return SwordMoblinTurnAround(slot)       # runs on into it

;@ def SwordMoblinTurnAround(slot: c)
;@ path: enemy/sword_moblin
;@ Turns to the other direction (bit 0 of wEntityDirection) and takes its patrol speed.
;@ test: c = rand(0, 15)
SwordMoblinTurnAround::
;> dir = wEntityDirection[slot] ^ 1
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
;> wEntityDirection[slot] = dir
	ld [hl], a
;>@sx wEntitySpeedX[slot] = SwordMoblinSpeedX[dir]
	ld e, a
	ld d, b
	ld hl, SwordMoblinSpeedX
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
;=@sx
	add hl, bc
	ld [hl], a
;> wEntitySpeedY[slot] = SwordMoblinSpeedY[dir]
	ld hl, SwordMoblinSpeedY
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
.done
;> return
	ret


;@ def SwordMoblin_Patrol(slot: c)
;@ path: enemy/sword_moblin
;@ State 1: walks to and fro (turning at walls) and looks out for Link; after the time it pauses
;@ $30 frames (state 0).
;@ test: skip checks walls through bank 3
SwordMoblin_Patrol::
;> SwordMoblinLookForLink(slot)
	call SwordMoblinLookForLink
;> if wEntityCollisions[slot] != 0:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, .walk
;>     SwordMoblinTurnAround(slot)
	call SwordMoblinTurnAround
.walk
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> UpdateWalkFrame(slot)
	call UpdateWalkFrame
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, SwordMoblinResetState.done
;>     wEntityTimer[slot] = 0x30
	ld [hl], $30
;>     return SwordMoblinResetState()           # runs on into it

;@ def SwordMoblinResetState(slot: c)
;@ path: enemy/sword_moblin
;@ Back to state 0.
;@ test: c = rand(0, 15)
SwordMoblinResetState::
;> wEntityState[slot] = 0
	call IncrementEntityState
	ld [hl], b
.done
	ret


;@ def SwordMoblin_Charge(slot: c)
;@ path: enemy/sword_moblin
;@ State 2: after noticing Link it stands facing him for $10 frames (wEntityTimer1; in the
;@ hideout, once the room scroll has finished, it says text $190 the first time,
;@ wEntityPrivate3). Then it runs at Link with fast steps, aiming again every 16 frames
;@ (speed $0A), for $80 frames; then it pauses $18 frames (state 0).
;@ test: skip opens dialogue
SwordMoblin_Charge::
;>@talk if wEntityTimer1[slot] != 0 and wTransitionSequenceCounter == 4 and hMapId == 0x15:
	call GetEntityTimer1
	jr z, .standing
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .standing
	ldh a, [hMapId]
;=@talk
	cp $15
	jr nz, .standing
;>     if wEntityPrivate3[slot] == 0:
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, SwordMoblinFaceLink
;>         wEntityPrivate3[slot] = 1
	inc [hl]
;>         OpenDialogTable1(0x90)
	ld a, $90
	call OpenDialogTable1
;>     return SwordMoblinFaceLink(slot)
	jr SwordMoblinFaceLink

.standing
;> if wEntityTimer1[slot] != 0:                  # still standing
	ld a, [hl]
	and a
;>     return SwordMoblinFaceLink(slot)
	jr nz, SwordMoblinFaceLink
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .run
;>     wEntityTimer[slot] = 0x18
	ld [hl], $18
;>     SwordMoblinResetState()
	call SwordMoblinResetState
.run
;> UpdateWalkFrame(slot)
	call UpdateWalkFrame
;> UpdateWalkFrame(slot)
	call UpdateWalkFrame
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> EntityCheckWalls()
	call EntityCheckWalls
;> if (hFrameCounter ^ slot) & 0x0F != 0:
	ldh a, [hFrameCounter]
	xor c
	and $0f
;>     return
	jr nz, SwordMoblinFaceLink.done
;> SetEntitySpeedTowardsLink(0x0A)
	ld a, $0a
	call SetEntitySpeedTowardsLink
SwordMoblinFaceLink:
;> wEntityDirection[slot] = GetEntityDirectionToLink(slot)       # SwordMoblinFaceLink: turn to Link
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
;> UpdateWalkFrame(slot)
	call UpdateWalkFrame
.done
	ret


;@ path: enemy/sword_moblin
;@ The opposite of each direction (0 right, 1 left, 2 up, 3 down).
SwordMoblinOppositeDirections::
	db $01, $00, $03, $02

;@ def SwordMoblinLookForLink(slot: c)
;@ path: enemy/sword_moblin
;@ The moblin notices Link (SwordMoblinAlert) after a sword clash (wClinkTimer), or when Link is
;@ within 48 pixels on both axes unless the moblin faces straight away from him.
;@ test: skip checks Link position through other routines
SwordMoblinLookForLink::
;> if wClinkTimer:
	ld a, [wClinkTimer]
	and a
;>     return SwordMoblinAlert(slot)
	jr nz, SwordMoblinAlert
;>@near if (EntityLinkDiffX(slot)[0] + 0x30) & 0xFF >= 0x60 or (EntityLinkDiffY(slot)[0] + 0x30) & 0xFF >= 0x60: return
	call EntityLinkDiffX
	add $30
	cp $60
	jr nc, SwordMoblinAlert.done
;=@near
	call EntityLinkDiffY
	add $30
	cp $60
	jr nc, SwordMoblinAlert.done
;>@away if SwordMoblinOppositeDirections[GetEntityDirectionToLink(slot)] == wEntityDirection[slot]: return   # facing away
	call GetEntityDirectionToLink
	ld d, b
	ld hl, SwordMoblinOppositeDirections
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
;=@away
	add hl, bc
	cp [hl]
	jr z, SwordMoblinAlert.done
;> return SwordMoblinAlert(slot)                 # runs on into it

;@ def SwordMoblinAlert(slot: c)
;@ path: enemy/sword_moblin
;@ Starts the charge (state 2, $80 frames); coming from another state it first stands $10 frames
;@ (wEntityTimer1).
;@ test: c = rand(0, 15)
SwordMoblinAlert::
;> if wEntityState[slot] != 2:
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	cp $02
	jr z, .charge
;>     wEntityTimer1[slot] = 0x10
	push hl
	call GetEntityTimer1
	ld [hl], $10
	pop hl
.charge
;> wEntityState[slot] = 2
	ld [hl], $02
;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
.done
	ret


;@ path: enemy/sword_moblin
;@ x offset of the sword for each sprite frame (0/1 down, 2/3 up, 4/5 left, 6/7 right; the second
;@ frame of each pair thrusts it further).
SwordMoblinSwordX::
	db $00, $00, $f9, $f9, $f8, $f2, $08, $0e

;@ path: enemy/sword_moblin
;@ y offset of the sword for each sprite frame.
SwordMoblinSwordY::
	db $08, $0e, $f8, $f2, $00, $00, $00, $00
;@ path: enemy/sword_moblin
;@ Sword sprite (frame of SwordSpriteTiles, as for Link's sword) for each sprite frame.
SwordMoblinSwordFrames::
	db $02, $02, $06, $06, $04, $04, $00, $00

;@ path: enemy/sword_moblin
;@ x of the sword's clash box (relative to the moblin) for each sprite frame.
SwordMoblinClashX::
	db $0c, $0c, $04, $04, $fc, $fc, $14, $14
;@ path: enemy/sword_moblin
;@ y of the sword's clash box for each sprite frame.
SwordMoblinClashY::
	db $14, $14, $fc, $fc, $0c, $0c, $0c, $0c

;@ path: enemy/sword_moblin
;@ The moblin's body, drawn by DrawEntity16x16: 8 frames of 4 bytes (tile and attributes of the
;@ left half, then of the right half): 0/1 facing down (tiles $60/$62, the step mirrored), 2/3
;@ facing up ($64/$66), 4/5 facing left ($68-$6E), 6/7 facing right (the same mirrored).
SwordMoblinSprites::
	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

;@ def DrawSwordMoblin(slot: c)
;@ path: enemy/sword_moblin
;@ Draws the moblin: facing down also its sword hilt sprite (DrawSwordMoblinHilt), then the sword
;@ (DrawSpritePair, 2 sprites at the offset for its frame) with a 4x4 clash box on it, then the
;@ body.
;@ test: skip draws sprites through bank 0
DrawSwordMoblin::
;> SkipDrawIfOffscreen()
	call SkipDrawIfOffscreen
;> frame = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
;> if frame < 2:                                  # facing down
	cp $02
	jr nc, .sword
;>     DrawSwordMoblinHilt(frame)
	call DrawSwordMoblinHilt
.sword
;> hMultiPurpose0 = hActiveEntityDrawY
	push bc
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose1], a
;>@cx wClashBoxX = SwordMoblinClashX[frame]
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, SwordMoblinClashX
	add hl, de
	ld a, [hl]
;=@cx
	ld [wClashBoxX], a
;> wClashBoxY = SwordMoblinClashY[frame]
	ld hl, SwordMoblinClashY
	add hl, de
	ld a, [hl]
	ld [wClashBoxY], a
;> wClashBoxHalfWidth = 2
	ld a, $02
	ld [wClashBoxHalfWidth], a
;> wClashBoxHalfHeight = 2
	ld [wClashBoxHalfHeight], a
;> hMultiPurpose2 = SwordMoblinSwordFrames[frame]
	ld hl, SwordMoblinSwordFrames
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose2], a
;>@o offset = (SwordMoblinSwordY[frame] << 8) | SwordMoblinSwordX[frame]
	ld hl, SwordMoblinSwordY
	add hl, de
	ld a, [hl]
	ld hl, SwordMoblinSwordX
	add hl, de
	ld l, [hl]
;=@o
	ld h, a
	push hl
;>@oam oam = wOAMBuffer + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de
	push hl
;=@oam
	pop bc
;> hMultiPurpose3 = 0
	xor a
	ldh [hMultiPurpose3], a
;> DrawSpritePair(oam, offset)
	pop hl
	call DrawSpritePair
	pop bc
;> ReserveOAMEntriesFar(2)
	ld a, $02
	call ReserveOAMEntriesFar
;> DrawEntity16x16(SwordMoblinSprites)
	ld de, SwordMoblinSprites
	call DrawEntity16x16
	ret


;@ def DrawSwordMoblinHilt(frame: a)
;@ path: enemy/sword_moblin
;@ One sprite (tile $86, palette 1) at the moblin's x - 2 and its drawn y + 4, one pixel lower on
;@ frame 0 than on frame 1.
;@ test: skip draws sprites through bank 0
DrawSwordMoblinHilt::
;> bob = frame ^ 1
	xor $01
	push af
;> p = wOAMBuffer + wOAMNextIndex
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld de, wOAMBuffer + $30
	add hl, de
	pop de
;> p[0] = hActiveEntityDrawY + bob + 4
	ldh a, [hActiveEntityDrawY]
	add d
	add $04
	ld [hli], a
;> p[1] = hActiveEntityX - 2
	ldh a, [hActiveEntityX]
	add $fe
	ld [hli], a
;> p[2] = 0x86
	ld a, $86
	ld [hli], a
;> p[3] = 0x10
	ld [hl], $10
;> ReserveOAMEntriesFar(1)
	ld a, $01
	call ReserveOAMEntriesFar
	ret


;@ path: object/chest_item
;@ The item rising out of an opened chest, drawn by DrawEntity8x16: tile and attributes (palette 1)
;@ of one 8x16 sprite for each chest content 0-$20 (the sprite variant; e.g. 0 = power bracelet,
;@ 1 = shield, $0B = sword).
ChestItemSprites::
	db $82, $10, $86, $10, $88, $10, $8a, $10, $8c, $10, $98, $10, $90, $10, $92, $10
	db $96, $10, $8e, $10, $80, $10, $84, $10, $94, $10, $9a, $10, $ae, $10, $9c, $10
	db $a0, $10, $c0, $10, $c2, $10, $c4, $10, $c6, $10, $ca, $10, $c0, $10, $c2, $10
	db $c4, $10, $c6, $10, $ca, $10, $a6, $10, $a6, $10, $a6, $10, $a6, $10, $a6, $10
	db $9e, $10

;@ path: object/chest_item
;@ Text (dialogue number in the first table) shown for each chest content 0-$21.
ChestItemTexts::
	db $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f
	db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ac, $ab, $ad, $ae, $ae
	db $ef, $06

;@ path: object/chest_item
;@ Sound for each chest content 0-$21, started 8 frames after the item appears: 1 = jingle 1 (for
;@ the smaller finds), any other value = the music track to play (always $10 here); 0 = none.
ChestItemMusic::
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $01, $10, $10, $10, $10, $10
	db $01, $10, $10, $10, $10, $10, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $00

;@ def ChestItemHandler(slot: c)
;@ path: object/chest_item
;@ Entity $07, the content of an opened chest (the sprite variant says which). Link is held
;@ still. The item rises out of the chest for 16 frames; at frame 8 the item's sound starts
;@ (ChestItemMusic), at frame $26 its text opens (ChestItemTexts; the second-level shield $ED,
;@ sword $9F and power bracelet $EE have their own texts; content $21 in room $96 shows text $111
;@ and nothing is drawn for it); at frame $28 it is gone. Content $22 is a trap: a zol ($1B)
;@ jumps out of the chest instead (jingle $1D).
;@ test: skip spawns entities and opens dialogue
ChestItemHandler::
;> hLinkInteractiveMotionBlocked = 2
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
;> wSwordAnimationState = 0
	xor a
	ld [wSwordAnimationState], a
;> wSwordAnimationStatePrev = 0
	ld [wSwordAnimationStatePrev], a
;> if hActiveEntitySpriteVariant == 0x22:        # a zol in the chest
	ldh a, [hActiveEntitySpriteVariant]
	cp $22
	jr nz, .item
;>     zol = SpawnEntity(0x1B)
	ld a, $1b
	call SpawnEntity
;>     if carry: return ClearEntityStatus(slot)
	jp c, ClearEntityStatus
;>     wEntityX[zol] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[zol] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntitySpeedZ[zol] = 0x18
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $18
;>     wEntityZ[zol] = 6
	ld hl, wEntityZ
	add hl, de
	ld [hl], $06
;>     wEntityTimer1[zol] = 0x50
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $50
;>     wEntitySpeedX[zol] = 8
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $08
;>     wEntityState[zol] = 3
	ld hl, wEntityState
	add hl, de
	ld [hl], $03
;>     hJingle = 0x1D
	ld a, $1d
	ldh [hJingle], a
;>     return ClearEntityStatus(slot)
	jp ClearEntityStatus

.item
;> if hActiveEntitySpriteVariant != 0x21:
	cp $21
	jr z, .update
;>     DrawEntity8x16(ChestItemSprites)
	ld de, ChestItemSprites
	call DrawEntity8x16
.update
;> if wDialogState != 0:
	ld a, [wDialogState]
	and a
;>     return
	jp nz, .done
;> UpdateEntityPosWithSpeed(slot)                 # rises
	call UpdateEntityPosWithSpeed
;> n = wEntityPrivateCounter[slot] + 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
;> wEntityPrivateCounter[slot] = n
	ld [hl], a
;> if n == 0x10:
	cp $10
	jr nz, .sound
;>     wEntitySpeedY[slot] = 0                    # stops rising
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $00
.sound
;> if n == 8:
	cp $08
	jr nz, .text
;>     sound = ChestItemMusic[hActiveEntitySpriteVariant]
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, ChestItemMusic
	add hl, de
	ld a, [hl]
;>     if sound == 1:
	and a
	jr z, .text
	cp $01
	jr nz, .music
;>         hJingle = 1
	ld a, $01
	ldh [hJingle], a
	jr .text
;>     elif sound != 0:
.music
;>         wMusicTrackToPlay = sound
	ld [wMusicTrackToPlay], a
.text
;> if wEntityPrivateCounter[slot] == 0x26:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $26
	jr nz, .end
;>     item = hActiveEntitySpriteVariant
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
;>     if item == 0x21 and hMapRoom == 0x96:
	cp $21
	jr nz, .levels
	ldh a, [hMapRoom]
	cp $96
	jr nz, .levels
;>         OpenDialogTable1(0x11)
	ld a, $11
	call OpenDialogTable1
	jr .opened
.levels
;>@sh     elif item == 1 and wShieldLevel == 2:
	ld a, e
	cp $01
	jr nz, .sword
	ld a, [wShieldLevel]
	cp $02
;=@sh
	jr nz, .sword
;>         OpenDialog(0xED)
	ld a, $ed
	jr .open
.sword
;>@sw     elif item == 0x0B and wSwordLevel == 2:
	ld a, e
	cp $0b
	jr nz, .bracelet
	ld a, [wSwordLevel]
	cp $02
;=@sw
	jr nz, .bracelet
;>         OpenDialog(0x9F)
	ld a, $9f
	jr .open
.bracelet
;>@br     elif item == 0 and wPowerBraceletLevel == 2:
	ld a, e
	cp $00
	jr nz, .normal
	ld a, [wPowerBraceletLevel]
	cp $02
;=@br
	jr nz, .normal
;>         OpenDialog(0xEE)
	ld a, $ee
	jr .open
.normal
;>     else:
;>         OpenDialog(ChestItemTexts[item])
	ld hl, ChestItemTexts
	add hl, de
	ld a, [hl]
.open
	call OpenDialog
.opened
;>     return                                     # (a = 0 never matches $28)
	xor a
.end
;> if wEntityPrivateCounter[slot] == 0x28:
	cp $28
	jr nz, .done
;>     ClearEntityStatus(slot)
	call ClearEntityStatus
.done
	ret


;@ def PushLinkOutOfEntity(slot: c) -> carry
;@ path: entity/helpers
;@ For solid entities: when Link touches it, he is put back where he was and his dash stops; a
;@ hookshot chain on its way (an entity of type 3 in slot wHookshotChainSlot - 1) is reset to state
;@ 0. Returns carry when Link was touching.
;@ test: skip checks Link collision through bank 3
PushLinkOutOfEntity::
;> if not EntityTouchesLink():
	call EntityTouchesLink
;>     return False
	jr nc, .no
;> RestoreLinkPosition()
	call RestoreLinkPosition
;> ResetPegasusBoots()
	call ResetPegasusBoots
;> chain = wHookshotChainSlot                     # slot + 1, 0 = none
	ld a, [wHookshotChainSlot]
	and a
;>@ch if chain != 0 and wEntityType[chain - 1] == 3:
	jr z, .yes
	ld e, a
	ld d, b
	ld hl, wEntityType - 1
	add hl, de
	ld a, [hl]
;=@ch
	cp $03
	jr nz, .yes
;>     wEntityState[chain - 1] = 0
	ld hl, wEntityState - 1
	add hl, de
	ld [hl], $00
.yes
;> return True
	scf
	ret

.no
	and a
	ret


;@ path: entity/helpers
;@ Base sprite frame for each direction (0 right, 1 left, 2 up, 3 down) used by UpdateWalkFrame:
;@ right 6, left 4, up 2, down 0; the step (0/1) is added to it.
WalkBaseFrames::
	db $06, $04, $02, $00

;@ def UpdateWalkFrame(slot: c)
;@ path: entity/helpers
;@ Advances the walk counter (wEntityPrivateCounter) and sets the sprite frame to
;@ WalkBaseFrames[wEntityDirection] plus the step (bit 4 of the counter).
;@ test: c = rand(0, 15); wEntityDirection[c] = rand(0, 3)
UpdateWalkFrame::
;>@b base = WalkBaseFrames[wEntityDirection[slot]]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, WalkBaseFrames
	add hl, de
;=@b
	push hl
;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
;>@s step = (wEntityPrivateCounter[slot] >> 4) & 1
	ld a, [hl]
	rra
	rra
	rra
	rra
	pop hl
;=@s
	and $01
;> return SetEntitySpriteVariant(slot, step | base)
	or [hl]
	jp SetEntitySpriteVariant


;@ def ShouldLinkTalkToEntity_Wide(slot: c) -> carry
;@ path: entity/helpers
;@ Same check as ShouldLinkTalkToEntity, but Link may stand up to twice as far above or below the
;@ character (used by a character behind a counter).
;@ test: skip continues inside ShouldLinkTalkToEntity
ShouldLinkTalkToEntity_Wide::
;> dy = (hLinkY - hActiveEntityY + 0x14) & 0xFF     # vertical distance, shifted to be positive
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
;> return ShouldLinkTalkToEntity_CheckRange(dy < 0x38)   # the rest of the check is shared
	cp $38
	jr ShouldLinkTalkToEntity_CheckRange

;@ def ShouldLinkTalkToEntity(slot: c) -> carry
;@ path: entity/helpers
;@ Returns carry when Link should start talking to the character being handled: he stands close in
;@ front of it facing it, nothing else is going on (no dialogue, not in the air, the status bar is
;@ shown normally) and A was just pressed. Close enough already sets wCanTalkToEntity, which keeps
;@ the A-button item from being used. The bear (type $B5) can be talked to from any side.
ShouldLinkTalkToEntity::
;> dy = (hLinkY - hActiveEntityY + 0x14) & 0xFF     # vertical distance, shifted to be positive
	ld e, b
	ldh a, [hLinkY]
	ld hl, hActiveEntityY
	sub [hl]
	add $14
;> if dy >= 0x28:
;>@no     return False
	cp $28
ShouldLinkTalkToEntity_CheckRange:
	jr nc, .no
;> dx = (hLinkX - hActiveEntityX + 0x10) & 0xFF     # horizontal distance, shifted
	ldh a, [hLinkX]
	ld hl, hActiveEntityX
	sub [hl]
	add $10
;> if dx >= 0x20:
;>     return False
	cp $20
	jr nc, .no
;> if hActiveEntityType != 0xB5:
	inc e
	ldh a, [hActiveEntityType]
	cp $b5
	jr z, .inPlace
;>     if hLinkDirection ^ 1 != GetEntityDirectionToLink(slot):   # Link must face the character
	push de
	call GetEntityDirectionToLink
	ldh a, [hLinkDirection]
	xor $01
	cp e
	pop de
;>         return False
	jr nz, .no
.inPlace
;> wCanTalkToEntity = 1
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
;> if wWindowY != 0x80:          # status bar not in its normal place
	ld a, [wWindowY]
	cp $80
;>     return False
	jr nz, .no
;> if not hJoypadPressed & 0x10:   # A not pressed
	ldh a, [hJoypadPressed]
	and $10
;>     return False
	jr z, .no
;> return True
	scf
	ret

.no
;=@no
	and a
	ret


;@ def ReturnIfNonInteractive()
;@ path: entity/helpers
;@ Called at the start of an entity's update: unless the entity is active (status 5) and the game
;@ is running normally (see ReturnIfPaused), it drops its caller's return address, so the handler
;@ ends for this frame right after drawing the entity.
;@ test: skip returns from its caller (pops the return address)
ReturnIfNonInteractive::
;> if hActiveEntityStatus != 5:
	ldh a, [hActiveEntityStatus]
	cp $05
;>     return_from_caller()      # pops the caller's return address
	jr nz, ReturnIfPaused.exitCaller
;> ReturnIfPaused()              # falls through

;@ def ReturnIfPaused()
;@ path: entity/helpers
;@ Ends the calling handler for this frame (drops its return address) while the map screen is up
;@ (game mode 7), a dialogue box is open, the inventory is sliding in or out, or the room is
;@ scrolling to the next one.
;@ test: skip returns from its caller (pops the return address)
ReturnIfPaused::
;> if wGameplayType == 7:
	ld a, [wGameplayType]
	cp $07
;>@exit     return_from_caller()   # pops the caller's return address
	jr z, .exitCaller
;> if wDialogState or wLinkShowItemPoseActive or wInventoryAppearing:
	ld a, [wDialogState]
	ld hl, wLinkShowItemPoseActive
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


;@ def ApplyRecoilIfNeeded(slot: c)
;@ path: entity/helpers
;@ While the entity's knockback timer runs, moves it one step with its knockback speed instead of
;@ its own speed (bumping into walls unless option bit 5 says otherwise) and ends the calling
;@ handler for this frame.
;@ test: skip returns from its caller (pops the return address)
ApplyRecoilIfNeeded::
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
;> AddPowerHitTrailVfx()                   # trail effect for entities that leave one
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
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
;> if not wEntityOptions1[slot] & 0x20:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, .restore
;>     EntityCheckWalls()               # stop at walls
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


;@ def UpdateEntityPosWithSpeed(slot: c)
;@ path: entity/helpers
;@ Moves the entity by its speed: x by wEntitySpeedX, then y by wEntitySpeedY (the y arrays lie
;@ 16 bytes after the x arrays, so the same routine runs with slot + 16).
;@ test: c = rand(0, 15)
UpdateEntityPosWithSpeed::
;> AddEntitySpeedToPosX(slot)
	call AddEntitySpeedToPosX
;> y_slot = slot + 16                 # the same arrays 16 bytes on: y, speed y, fraction y
	push bc
	ld a, c
	add $10
	ld c, a
;> AddEntitySpeedToPosX(y_slot)
	call AddEntitySpeedToPosX
	pop bc
	ret


;@ def AddEntitySpeedToPosX(slot: c)
;@ path: entity/helpers
;@ Adds the signed speed (1/16 pixel units) to the x position: the low nibble goes into the
;@ fraction wEntitySpeedXAcc, the high nibble and the carry out of the fraction into wEntityX.
;@ test: c = rand(0, 31)
AddEntitySpeedToPosX::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
	jr z, AddEntitySpeedToPos_Done
;> frac = wEntitySpeedXAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
;> wEntitySpeedXAcc[slot] = frac & 0xFF
	ld [hl], a
	rl d
	ld hl, wEntityX
AddEntitySpeedToPos_Add:
;> sign = 0xF0 if speed & 0x80 else 0
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive
	ld e, $f0
.positive
;> step = (speed >> 4) | sign        # signed whole pixels
	swap a
	and $0f
	or e
;> wEntityX[slot] = (wEntityX[slot] + step + (frac >> 8)) & 0xFF
	rr d
	adc [hl]
	ld [hl], a
AddEntitySpeedToPos_Done:
	ret


;@ def AddEntityZSpeedToPos(slot: c)
;@ path: entity/helpers
;@ Adds the signed height speed to the height, the same way AddEntitySpeedToPosX does for x.
;@ test: skip shares its second half with AddEntitySpeedToPosX
AddEntityZSpeedToPos::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
	jr z, AddEntitySpeedToPos_Done
;> frac = wEntitySpeedZAcc[slot] + ((speed << 4) & 0xF0)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
;> wEntitySpeedZAcc[slot] = frac & 0xFF
	ld [hl], a
	rl d
;> wEntityZ[slot] += signed(speed >> 4) + (frac >> 8)    # same tail as AddEntitySpeedToPosX
	ld hl, wEntityZ
	jr AddEntitySpeedToPos_Add

;@ def EntityLinkDiffX(slot: c) -> (d, e)
;@ path: entity/helpers
;@ d = Link's x minus the entity's x; e = the direction from the entity to Link along x
;@ (0 = right, 1 = left).
;@ test: c = rand(0, 15)
EntityLinkDiffX::
;> e = 0                          # right
	ld e, $00
;> d = (hLinkX - wEntityX[slot]) & 0xFF
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, bc
	sub [hl]
;> if d & 0x80:
	bit 7, a
	jr z, .done
;>     e = 1                      # left
	inc e
.done
;> return d, e
	ld d, a
	ret


;@ def EntityLinkDiffY(slot: c) -> (d, e)
;@ path: entity/helpers
;@ d = Link's y minus the entity's y; e = the direction from the entity to Link along y
;@ (2 = up, 3 = down).
;@ test: c = rand(0, 15)
EntityLinkDiffY::
;> e = 2                          # up
	ld e, $02
;> d = (hLinkY - wEntityY[slot]) & 0xFF
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, bc
	sub [hl]
;> if not d & 0x80:
	bit 7, a
	jr nz, .done
;>     e = 3                      # down
	inc e
.done
;> return d, e
	ld d, a
	ret


;@ def GetEntityDirectionToLink(slot: c) -> e
;@ path: entity/helpers
;@ Returns in e the direction (0 right, 1 left, 2 up, 3 down) from the entity towards Link along
;@ the axis on which Link is farther away. hMultiPurpose0 keeps the x direction, hMultiPurpose1
;@ the y direction.
;@ test: c = rand(0, 15)
GetEntityDirectionToLink::
;> dx, xdir = EntityLinkDiffX(slot)
	call EntityLinkDiffX
	ld a, e
;> hMultiPurpose0 = xdir
	ldh [hMultiPurpose0], a
;> dx = dx if dx < 0x80 else 0x100 - dx      # distance
	ld a, d
	bit 7, a
	jr z, .xPositive
	cpl
	inc a
.xPositive
	push af
;> dy, ydir = EntityLinkDiffY(slot)
	call EntityLinkDiffY
	ld a, e
;> hMultiPurpose1 = ydir
	ldh [hMultiPurpose1], a
;> dy = dy if dy < 0x80 else 0x100 - dy
	ld a, d
	bit 7, a
	jr z, .yPositive
	cpl
	inc a
.yPositive
;> if dy < dx:
	pop de
	cp d
	jr nc, .vertical
;>     return hMultiPurpose0      # mostly sideways
	ldh a, [hMultiPurpose0]
	jr .done
;> return hMultiPurpose1          # mostly above or below
.vertical
	ldh a, [hMultiPurpose1]
.done
	ld e, a
	ret


;@ def ClearEntityStatus(slot: c)
;@ path: entity/helpers
;@ Frees the entity's slot (status 0): it disappears.
;@ test: c = rand(0, 15)
ClearEntityStatus::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def BossDefeatedHandler(slot: c)
;@ path: boss/defeat
;@ Plays a defeated boss's end, stepped by wEntityPrivate2: flashing, a burst of explosions, then
;@ the drop.
;@ test: skip dispatches through a jump table
BossDefeatedHandler::
;> return BossDefeatedStates[wEntityPrivate2[slot]](slot)
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: boss/defeat
;@ The steps of BossDefeatedHandler (index wEntityPrivate2): 0 start, 1 flash, 2 explode.
BossDefeatedStates::
	dw BossDefeated_Start
	dw BossDefeated_Flash
	dw BossDefeated_Explode

;@ def BossDefeated_Start(slot: c)
;@ path: boss/defeat
;@ Starts the defeat: $A0 frames of flashing.
;@ test: c = rand(0, 15)
BossDefeated_Start::
;> wEntityTimer[slot] = 0xA0
	call GetEntityTimer
	ld [hl], $a0
;> wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;> IncrementEntityPrivate2(slot)      # falls through

;@ def IncrementEntityPrivate2(slot: c)
;@ path: entity/helpers
;@ Moves the entity on to its next sub-step (wEntityPrivate2 + 1).
;@ test: c = rand(0, 15)
IncrementEntityPrivate2::
;> wEntityPrivate2[slot] += 1
	ld hl, wEntityPrivate2
	add hl, bc
	inc [hl]
	ret


;@ def BossDefeated_Flash(slot: c)
;@ path: boss/defeat
;@ Waits for the flashing to end, then gives the explosions $C0 frames.
;@ test: c = rand(0, 15)
BossDefeated_Flash::
;> if wEntityTimer[slot] == 0:
	call GetEntityTimer
	jr nz, .done
;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     wEntityFlashTimer[slot] = 0xFF
	ld hl, wEntityFlashTimer
	add hl, bc
	ld [hl], $ff
;>     IncrementEntityPrivate2(slot)
	call IncrementEntityPrivate2
.done
	ret


;@ def BossDefeated_Explode(slot: c)
;@ path: boss/defeat
;@ Explosions burst around the boss while the timer runs. Then Master Stalfos (type $5F) drops the
;@ item entity $30 with a small hop and restores the area's music; any other boss shakes the
;@ screen, triggers the boss-defeated handling and is removed like a killed enemy.
;@ test: skip spawns entities through bank 3
BossDefeated_Explode::
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t != 0:
;>@ex     return BossDefeatedExplosions(t)
	jr nz, .exploding
;> if hActiveEntityType == 0x5F:
	ldh a, [hActiveEntityType]
	cp $5f
	jr nz, .otherBoss
;>     new = SpawnEntity(0x30)          # spawn the dropped item
	ld a, $30
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
;>     wEntitySpeedZ[new] = 0x18      # it hops up
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $18
;>     wEntityTimer1[new] = 0x20
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $20
;>     hDefaultMusicTrack = wEntityPrivate5[slot]
	ld hl, wEntityPrivate5
	add hl, bc
	ld a, [hl]
	ldh [hDefaultMusicTrack], a
;>     return DespawnEntityWithSfx(slot)
	jp DespawnEntityWithSfx

.otherBoss
;> PlayClinkNoise()                        # explosion noise
	call PlayClinkNoise
;> SelectAreaMusicFar()                        # boss-defeated handling (bank 2)
	call SelectAreaMusicFar
;> return DefeatEntityWithDrop(slot)             # removed like a killed enemy
	jp DefeatEntityWithDrop

.exploding
;=@ex
	call BossDefeatedExplosions
	ret


;@ def BossDefeatedExplosions(t: a)
;@ path: boss/defeat
;@ Every 8th frame of the countdown t, an explosion appears at a random spot around the entity
;@ (x -16..+15, y -20..+11).
;@ test: skip draws on random numbers
BossDefeatedExplosions::
;> if t & 7:
	and $07
;>     return
	jr nz, .done
;> dx = (GetRandomByte() & 0x1F) - 0x10
	call GetRandomByte
	and $1f
	sub $10
	ld e, a
;> hActiveEntityX = (hActiveEntityX + dx) & 0xFF
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
;> dy = (GetRandomByte() & 0x1F) - 0x14
	call GetRandomByte
	and $1f
	sub $14
	ld e, a
;> hActiveEntityDrawY = (hActiveEntityDrawY + dy) & 0xFF
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
;> SpawnExplosionAtEntity()
	call SpawnExplosionAtEntity
.done
	ret


;@ def SpawnExplosionAtEntity()
;@ path: entity/helpers
;@ Shows an explosion cloud (transient effect 2) where the entity is drawn and plays noise effect
;@ $13 - unless the game is paused.
;@ test: skip may return from its caller
SpawnExplosionAtEntity::
;> ReturnIfPaused()
	call ReturnIfPaused
;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> AddTransientVfx(2)                       # transient effect: explosion
	ld a, $02
	call AddTransientVfx
;> hNoiseSfx = 0x13
	ld a, $13
	ldh [hNoiseSfx], a
	ret


;@ def UnusedSpawnHeartContainer(slot: c)
;@ path: unused
;@ Nothing jumps here. Spawns a heart container (type $36) at hMultiPurpose0/1; in a side-view room
;@ it gives the handled entity an upward speed, otherwise the heart container a hop from a height of
;@ 8. Then removes the handled entity (falls into DespawnEntityWithSfx).
;@ test: skip unused, spawns entities through bank 3
UnusedSpawnHeartContainer::
;> new = SpawnEntity(0x36)
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
	ldh a, [$fff9]
	and a
	jr z, .topView
;>     wEntitySpeedY[slot] = 0xF0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	jr DespawnEntityWithSfx
;> else:
.topView
;>     wEntitySpeedZ[new] = 0x10
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
;>     wEntityZ[new] = 8
	ld hl, wEntityZ
	add hl, de
	ld [hl], $08
;> DespawnEntityWithSfx(slot)         # falls through

;@ def DespawnEntityWithSfx(slot: c)
;@ path: entity/helpers
;@ Removes the entity and plays noise effect $1A.
;@ test: c = rand(0, 15)
DespawnEntityWithSfx::
;> ClearEntityStatus(slot)
	call ClearEntityStatus
;> hNoiseSfx = 0x1A
	ld hl, hNoiseSfx
	ld [hl], $1a
	ret


;@ path: unused
;@ Unused space at the end of bank 7, filled with $FF.
Bank07FreeSpace::
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
	db $ff, $ff, $ff
