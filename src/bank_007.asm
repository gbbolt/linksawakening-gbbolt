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
;>     SetEntitySpriteVariant(wEntityPrivate4[slot] ^ 1)  # sprite variant of the plain object
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
;> SetEntitySpriteVariant(wEntityPrivate4[slot] ^ 1)
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
;>         SetEntitySpriteVariant((hFrameCounter >> 3) & 1)   # wiggle every 8 frames
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
;> SetEntitySpriteVariant((hFrameCounter >> 3) & 1)
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
;>         return IncrementEntityState()               # state 1: wait for the answer
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
;> return SetEntitySpriteVariant(frame)
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
;> mem[0xC10B] = 1
	ld a, $01
	ld [$c10b], a
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
;> return SetEntitySpriteVariant(frame)
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
;>     mem[0xC10B] = 0
	ld [$c10b], a
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
;> SetEntitySpriteVariant(3)
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
;> return IncrementEntityState()                  # wEntityState += 1
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
;> SetEntitySpriteVariant(xdir)                      # face Link
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
;> return IncrementEntityState()
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
;>     SetEntitySpriteVariant(0xFF)                  # hidden
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
;> SetEntitySpriteVariant(frame)
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
;>     SetEntitySpriteVariant(frame)
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
;>     SetEntitySpriteVariant(0xFF)
	ld a, $ff
	call SetEntitySpriteVariant
;>     return IncrementEntityState()
	jp IncrementEntityState

.diving
;> frame = 2 if t >= 8 else 3
	ld e, $02
	cp $08
	jr nc, .setFrame
	inc e
.setFrame
;> SetEntitySpriteVariant(frame)
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
;> SetEntitySpriteVariant(facing)
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
;> return IncrementEntityState()
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
;> SetEntitySpriteVariant(frame)
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
;>     SetEntitySpriteVariant(frame)
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
;>     SetEntitySpriteVariant(0)
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
;> SetEntitySpriteVariant(frame)
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
;>     return IncrementEntityState()
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
;> SetEntitySpriteVariant(frame)
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
;> SetEntitySpriteVariant(0)
	xor a
	call SetEntitySpriteVariant
;> ReturnIfNonInteractive()
	call ReturnIfNonInteractive
;> SetEntitySpriteVariant(hFrameCounter & 0x20)          # turns his head every 32 frames
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
;>     return IncrementEntityState()                   # state 1: wait for the answer
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
;>     return IncrementEntityState()
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
;>     return IncrementEntityState()
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
;> SetEntitySpriteVariant(frame)
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
;>     return IncrementEntityState()
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
;> SetEntitySpriteVariant(2)
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
;>     return IncrementEntityState()
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
;>     return SetEntitySpriteVariant(8)
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
;>         return IncrementEntityState()
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
;> SetEntitySpriteVariant(frame)
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
;> SetEntitySpriteVariant(frame)
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
;>         return IncrementEntityState()
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
;> SetEntitySpriteVariant(frame)
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
;@ Turns the vector (hMultiPurpose0 = x, hMultiPurpose1 = y; signed, length up to about $1F, as
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
;> SetEntitySpriteVariant(0)
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
;>     SetEntitySpriteVariant(wEntityPrivate3[slot])          # the head, looking along the lunge
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
;>     return IncrementEntityState()
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
;> SetEntitySpriteVariant(1)
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
;>     SetEntitySpriteVariant(0)
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
;> SetEntitySpriteVariant(frame)
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
;> SetEntitySpriteVariant(3)
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
;>     return IncrementEntityState()
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
;>     SetEntitySpriteVariant(4)
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
;> SetEntitySpriteVariant(3)
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
;>@f SetEntitySpriteVariant(4 if wEntitySpeedY[slot] & 0x80 else 2)
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
;> SetEntitySpriteVariant(3)
	ld a, $03
	call SetEntitySpriteVariant
;> UpdateEntityPosWithSpeed(slot)
	call UpdateEntityPosWithSpeed
	ret


Kiki_Idle::
	ret


BlooperSprites::
	db $6a, $00, $6a, $20, $68, $00, $68, $20

BlooperHandler::
	ld de, $5974
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ld hl, wEntityGroundStatus
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_59ad

	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $10
	ldh a, [hActiveEntityX]
	ld hl, wEntityX
	add hl, bc
	ld [hl], a
	ldh a, [hActiveEntityY]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a

jr_007_59ad:
	xor a
	call SetEntitySpriteVariant
	ldh a, [hActiveEntityState]
	rst $00

BlooperStates::
	dw Blooper_Sink
	dw Blooper_Swim

Blooper_Sink::
	call GetEntityTimer
	jr nz, jr_007_59db

	call EntityLinkDiffY
	ld a, e
	cp $03
	jr z, jr_007_59db

	call ClearEntitySpeed
	call GetEntityTimer
	ld [hl], $25
	call EntityLinkDiffX
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	call IncrementEntityState
	ld [hl], $01
	ret


jr_007_59db:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub $04
	jr z, jr_007_59eb

	and $80
	jr z, jr_007_59ea

	inc [hl]
	inc [hl]

jr_007_59ea:
	dec [hl]

jr_007_59eb:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_59fa

	and $80
	jr z, jr_007_59f9

	inc [hl]
	inc [hl]

jr_007_59f9:
	dec [hl]

jr_007_59fa:
	ret


BlooperSwimAccelX::
	db $01, $ff

Blooper_Swim::
	call GetEntityTimer
	jr nz, jr_007_5a09

	ld [hl], $40
	call IncrementEntityState
	ld [hl], b
	ret


jr_007_5a09:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_007_5a25

	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $59fb
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a

jr_007_5a25:
	ld a, $01
	call SetEntitySpriteVariant
	ret


DrawPillarSprites::
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	jr z, jr_007_5a7a

	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	pop hl

jr_007_5a3e:
	ldh a, [hActiveEntityDrawY]
	add [hl]
	cp $7e
	jr c, jr_007_5a46

	xor a

jr_007_5a46:
	ld [de], a
	inc hl
	inc de
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityX]
	add [hl]
	sub c
	ld [de], a
	inc hl
	inc de
	ldh a, [hActiveEntityTileOffset]
	ld c, a
	ld a, [hli]
	push af
	add c
	ld [de], a
	pop af
	cp $ff
	jr nz, jr_007_5a65

	dec de
	xor a
	ld [de], a
	inc de

jr_007_5a65:
	pop bc
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_007_5a3e

	ld a, [wActiveEntitySlot]
	ld c, a
	ld a, $0a
	call ReserveOAMEntriesFar
	ret


jr_007_5a7a:
	ld a, [wActiveEntitySlot]
	ld c, a
	ret


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

PillarHandler::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, PillarDebris

	and a
	jp nz, PillarDust

	ldh a, [hRoomStatus]
	and $20
	jp nz, ClearEntityStatus

	ld a, [wRoomTransitionState]
	and a
	jr nz, jr_007_5b6c

	ld hl, wEntityRoom
	add hl, bc
	ldh a, [hMapRoom]
	cp [hl]
	jp nz, ClearEntityStatus

jr_007_5b6c:
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr nc, jr_007_5b89

	rla
	rla
	and $fc
	sla a
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $5a7f
	add hl, de
	ld c, $0a
	call DrawPillarSprites

jr_007_5b89:
	call DecrementEntityIgnoreHitsTimer
	call EntityCheckWeaponHits
	call PushLinkOutOfEntity
	ldh a, [hActiveEntityState]
	rst $00

PillarStates::
	dw Pillar_Idle
	dw Pillar_Shake
	dw Pillar_Crumble
	dw Pillar_TowerShake
	dw Pillar_Collapse
	dw Pillar_Quake

Pillar_Idle::
	ret


Pillar_Shake::
	call HoldLinkStill
	call GetEntityTimer
	jr nz, SetScreenShakeFromTimer

	jp IncrementEntityState


SetScreenShakeFromTimer::
	ld e, $00
	and $04
	jr z, jr_007_5bb5

	ld e, $02

jr_007_5bb5:
	ld a, e
	ld [wScreenShakeX], a
	ret


Pillar_Crumble::
	call HoldLinkStill
	ldh a, [hFrameCounter]
	call SetScreenShakeFromTimer
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_007_5bde

	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $05
	jp z, Jump_007_5c1e

	call GetRandomByte
	and $03
	jr z, jr_007_5bde

	call SpawnPillarDebris

jr_007_5bde:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_007_5c1d

	ld a, $a7
	call SpawnEntity
	jr c, jr_007_5c1d

	call GetRandomByte
	and $07
	sub $04
	ld hl, hMultiPurpose1
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	call GetRandomByte
	and $1f
	sub $10
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $10
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $01

jr_007_5c1d:
	ret


Jump_007_5c1e:
	ld a, $00
	ld [wScreenShakeX], a
	ld a, [wTowerPillarsDestroyed]
	inc a
	ld [wTowerPillarsDestroyed], a
	cp $04
	jr c, jr_007_5c37

	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState
	ret


jr_007_5c37:
	call MarkRoomEventDone
	jp ClearEntityStatus


Pillar_TowerShake::
	call GetEntityTimer
	jr nz, jr_007_5c57

	ld [hl], $20
	ld a, $08
	ld [wGameplayType], a
	xor a
	ld [wTransitionSequenceCounter], a
	ld [wTransitionFrameCounter], a
	ld [wGameplaySubtype], a
	call IncrementEntityState
	ret


jr_007_5c57:
	ld e, $00
	and $04
	jr z, jr_007_5c5f

	ld e, $02

jr_007_5c5f:
	ld a, e
	ld [wScreenShakeX], a

HoldLinkStill::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkPoseLock], a
	ret


Pillar_Collapse::
	xor a
	ld [wScreenShakeX], a
	call GetEntityTimer
	jr nz, jr_007_5c80

	call MarkRoomEventDone
	ld hl, wDungeon7Flags
	set 2, [hl]
	call ClearEntityStatus
	ret


jr_007_5c80:
	call HoldLinkStill
	ret


PillarQuakeOffsets::
	db $00, $02, $04, $06, $06, $04, $02, $00

Pillar_Quake::
	xor a
	ld [wScreenShakeY], a
	call GetEntityTimer
	jr nz, jr_007_5c98

	jp ClearEntityStatus


jr_007_5c98:
	push af
	and $07
	ld e, a
	ld d, b
	ld hl, $5c84
	add hl, de
	ld a, [hl]
	ld [wScreenShakeY], a
	pop af
	cp $20
	jr nc, jr_007_5cb2

	and $03
	jr nz, jr_007_5cb2

	call SpawnPillarDebris
	xor a

jr_007_5cb2:
	cp $40
	jr c, jr_007_5cbf

	and $07
	jr nz, jr_007_5cbf

	ld hl, hNoiseSfx
	ld [hl], $0c

jr_007_5cbf:
	ret


PillarDustSprites::
	db $30, $00, $30, $20, $32, $00, $32, $20

PillarDust::
	ld de, $5cc0
	call DrawEntity16x16
	call GetEntityTimer
	jp z, ClearEntityStatus

	cp $04
	jr nz, jr_007_5cdd

	ld a, $01
	call SetEntitySpriteVariant

jr_007_5cdd:
	ret


SpawnPillarDebris::
	ld a, $a7
	call SpawnEntity
	jr c, jr_007_5d17

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $d1
	ld hl, wEntityZ
	add hl, de
	ld [hl], $70
	call GetRandomByte
	and $3f
	sub $20
	ld hl, hMultiPurpose0
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	call GetRandomByte
	and $3f
	sub $20
	ld hl, hMultiPurpose1
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a

jr_007_5d17:
	ret


PillarDebrisSprites::
	db $16, $00, $16, $20

PillarDebrisBounceSpeeds::
	db $18, $10, $0c, $08

PillarDebrisSpeedX::
	db $0c, $f4, $0c, $f4

PillarDebrisSpeedY::
	db $f4, $f4, $0c, $0c

PillarDebris::
	ldh a, [hActiveEntityDrawY]
	add $08
	ldh [hActiveEntityDrawY], a
	ld de, $5d18
	call DrawEntity8x16
	call UpdateEntityPosWithSpeed
	call AddEntityZSpeedToPos
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_5d82

	ld [hl], b
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $04
	jp z, ClearEntityStatus

	ld e, a
	ld d, b
	ld hl, $5d1c
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $5d20
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $5d24
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld a, e
	and $01
	call SetEntitySpriteVariant

jr_007_5d82:
	ret


HeavyBallSprites::
	db $4e, $00, $4e, $20

Call_07_5D87::
	ldh a, [hActiveEntityStatus]
	cp $07
	jr nz, jr_007_5daa

	ld a, [wLinkMotionState]
	cp $05
	jr nz, jr_007_5d99

	ld a, $10
	ld [$c5ae], a

jr_007_5d99:
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

jr_007_5daa:
	ld de, $5d83
	call DrawEntity16x16
	ld a, [wRoomTransitionState]
	and a
	ret nz

	ldh a, [hMapRoom]
	ld [wIronBallRoom], a
	ldh a, [hActiveEntityX]
	ld [wIronBallX], a
	ldh a, [hActiveEntityY]
	ld [wIronBallY], a
	ld a, [wDialogState]
	and a
	ret nz

	ldh a, [hActiveEntityStatus]
	cp $02
	ret z

	call DecrementEntityIgnoreHitsTimer
	call EntityCheckWeaponHits
	call UpdateEntityPosWithSpeed
	call AddEntityZSpeedToPos
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_007_5e10

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	cp $07
	jr c, jr_007_5e02

	push af
	ld a, $17
	ldh [hNoiseSfx], a
	pop af
	jr jr_007_5e03

jr_007_5e02:
	xor a

jr_007_5e03:
	ld [hl], a
	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]

jr_007_5e10:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
	ld e, $03
	ld a, e
	ldh [hActiveEntityFlipAttribute], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	ldh a, [hActiveEntityY]
	add e
	ldh [hActiveEntityY], a
	call EntityCheckWalls
	ldh a, [hActiveEntityFlipAttribute]
	ld e, a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	ldh a, [hActiveEntityY]
	sub e
	ldh [hActiveEntityY], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_5E3C::
	dw Jump_07_5E42
	dw Jump_07_5EB5
	dw Jump_07_5EB6

Jump_07_5E42::
	ldh a, [hMultiPurposeH]
	dec a
	and $80
	jr z, jr_007_5e5e

	ld hl, wEntitySpeedY
	call Call_07_5E52
	ld hl, wEntitySpeedX

Call_07_5E52::
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5e5e

	and $80
	jr z, jr_007_5e5d

	inc [hl]
	inc [hl]

jr_007_5e5d:
	dec [hl]

jr_007_5e5e:
	call EntityTouchesLink
	jr nc, jr_007_5eb4

	ld a, [wItemUsePoseTimer]
	and a
	jr nz, jr_007_5eb4

	ld a, [wItemB]
	cp $03
	jr nz, jr_007_5e78

	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_007_5e85

	jr jr_007_5eb4

jr_007_5e78:
	ld a, [wItemA]
	cp $03
	jr nz, jr_007_5eb4

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_007_5eb4

jr_007_5e85:
	ld a, [wLinkIsCarrying]
	and a
	jr nz, jr_007_5eb4

	inc a
	ld [wLinkIsCarrying], a
	ldh a, [hActiveEntityStatus]
	cp $07
	jr z, jr_007_5eb4

	call IncrementEntityState
	ld [hl], $02
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
	call GetEntityTimer
	ld [hl], $02
	ld hl, hWaveSfx
	ld [hl], $02

jr_007_5eb4:
	ret


Jump_07_5EB5::
	ret


Jump_07_5EB6::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr nz, jr_007_5edb

	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5ee6

Call_07_5EC3::
	ld a, $07
	ldh [hJingle], a
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a

jr_007_5edb:
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
	call IncrementEntityState
	ld [hl], b
	ret


jr_007_5ee6:
	call ReturnIfNonInteractive
	ld a, $0b
	ld [wProjectileWeaponType], a
	call EntityHitOtherEntities
	ld e, $0f
	ld d, b

jr_007_5ef4:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_007_5f0a

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $a7
	jr nz, jr_007_5f0a

	push de
	call Call_07_5F11
	pop de

jr_007_5f0a:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_007_5ef4

	ret


Call_07_5F11::
	call GetEntityTimer
	jr nz, jr_007_5f4f

	ld hl, wEntityX
	add hl, de
	ldh a, [hActiveEntityX]
	sub [hl]
	add $10
	cp $20
	jr nc, jr_007_5f4f

	ld hl, wEntityY
	add hl, de
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	add $18
	cp $28
	jr nc, jr_007_5f4f

	call Call_07_5EC3
	ld a, $25
	ldh [hNoiseSfx], a
	ld a, $0b
	ldh [hJingle], a
	call GetEntityTimer
	ld [hl], $10
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_007_5f4f

	inc [hl]
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $50

jr_007_5f4f:
	ret


	db $50, $00, $50, $20

Call_07_5F54::
	ld de, $5f50
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call Call_07_6103
	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	ld e, a
	and a
	jr nz, jr_007_5f7c

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5fcd

	call Call_07_6081
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $f0
	ld e, $10

jr_007_5f7c:
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_007_5f91

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub e
	jr z, jr_007_5f91

	and $80
	jr z, jr_007_5f90

	inc [hl]
	inc [hl]

jr_007_5f90:
	dec [hl]

jr_007_5f91:
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $02
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	push hl
	push af
	ld [hl], e
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	push hl
	push af
	call EntityCheckWalls
	pop af
	pop hl
	ld [hl], a
	pop af
	pop hl
	ld [hl], a
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $30
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5fcb

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	call Call_07_6081
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $00

jr_007_5fcb:
	jr jr_007_5fe5

jr_007_5fcd:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5fdc

	and $80
	jr z, jr_007_5fdb

	inc [hl]
	inc [hl]

jr_007_5fdb:
	dec [hl]

jr_007_5fdc:
	call Call_07_6081
	ld hl, wEntityPrivate3
	add hl, de
	ld [hl], $00

jr_007_5fe5:
	ldh a, [hActiveEntityY]
	and $0f
	cp $00
	jr nz, jr_007_6047

	ldh a, [hActiveEntityY]
	sub $10
	ldh [hBGPosY], a
	and $f0
	ld e, a
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
	swap a
	and $0f
	or e
	ld e, a
	ld d, b
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6047

	and $80
	jr nz, jr_007_6048

	ld hl, wRoomObjects
	add hl, de
	ld [hl], $4d
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
	ld a, $44
	ld [hli], a
	ld a, $54
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $45
	ld [hli], a
	ld a, $55
	ld [hli], a
	ld [hl], b

jr_007_6047:
	ret


jr_007_6048:
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $04
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
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld [hl], b
	ret


Call_07_6081::
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	xor $01
	ldh [hMultiPurpose0], a
	ld e, b
	ld d, b

jr_007_608c:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_007_60a6

	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $a6
	jr nz, jr_007_60a6

	ld hl, wEntityLoadOrder
	add hl, de
	ldh a, [hMultiPurpose0]
	cp [hl]
	jr z, jr_007_60ac

jr_007_60a6:
	inc e
	ld a, e
	cp $10
	jr nz, jr_007_608c

jr_007_60ac:
	ret


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20

Call_07_60BD::
	ld hl, $60ad
	ld c, $04
	call DrawEntitySprites
	call ReturnIfNonInteractive
	call GetEntityTimer
	ld e, a
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $03
	or e
	jr nz, Call_07_6103

	ldh a, [hActiveEntityType]
	cp $a4
	jp z, Jump_007_6160

	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $615c
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $615e
	add hl, de
	cp [hl]
	jr nz, Call_07_6103

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call GetEntityTimer
	ld [hl], $6a

Call_07_6103::
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], b
	ldh a, [hActiveEntityX]
	push af
	call UpdateEntityPosWithSpeed
	pop af
	ld e, a
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	sub e
	ldh [hBGTilesRequestCopy], a
	call EntityCheckWalls
	call EntityTouchesLink
	jr nc, jr_007_615b

	ldh a, [hLinkSpeedY]
	and $80
	jr nz, jr_007_615b

	call EntityLinkDiffY
	add $08
	bit 7, a
	jr z, jr_007_615b

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [hLinkY], a
	ldh a, [hLinkSpeedX]
	push af
	ldh a, [hBGTilesRequestCopy]
	ldh [hLinkSpeedX], a
	ld hl, hLinkX
	add [hl]
	ld [hl], a
	push bc
	call Call_3E49
	pop bc
	pop af
	ldh [hLinkSpeedX], a
	ld a, $02
	ldh [hLinkSpeedY], a
	ld a, $01
	ld [wLinkOnPlatform], a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], $10

jr_007_615b:
	ret


	db $01, $ff, $06, $fa

Jump_007_6160:
	ld hl, wEntityPrivate1
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $615c
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $615e
	add hl, de
	cp [hl]
	jr nz, jr_007_6185

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call GetEntityTimer
	ld [hl], $6a

jr_007_6185:
	jp Call_07_6103


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20

Call_07_6198::
	call GetEntityTimer1
	jr z, jr_007_61a1

	ld a, $04
	ldh [hActiveEntityTileOffset], a

jr_007_61a1:
	ld hl, $6188
	ld c, $04
	call DrawEntitySprites
	call ReturnIfNonInteractive
	call Call_07_6103
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_61f0

	ld e, $04
	ldh a, [hMapRoom]
	cp $3b
	jr z, jr_007_61cc

	call GetEntityTimer1
	ld [hl], $08
	ld a, [wLinkIsCarrying]
	and a
	jr z, jr_007_61f0

	ld e, $04

jr_007_61cc:
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_007_61de

	inc [hl]
	cp $03
	jr nz, jr_007_61de

	ld a, $11
	ldh [hNoiseSfx], a

jr_007_61de:
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_007_61ef

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	sub e
	and $80
	jr z, jr_007_61ef

	inc [hl]

jr_007_61ef:
	ret


jr_007_61f0:
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ld hl, wEntityPrivate4
	add hl, bc
	ld [hl], b
	ret


Call_07_61FB::
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld [hl], b
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld [hl], b
	call Call_07_6331
	call ReturnIfNonInteractive
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_621b

	inc [hl]
	ldh a, [hActiveEntityY]
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a

jr_007_621b:
	call ApplyRecoilIfNeeded
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_6221::
	dw Jump_07_6229
	dw Jump_07_624D
	dw Jump_07_627A
	dw Jump_07_62A3

Jump_07_6229::
	call GetEntityTimer
	jr nz, jr_007_623c

	ld [hl], $40
	call EntityLinkDiffX
	add $10
	cp $20
	jr c, jr_007_623c

	call IncrementEntityState

jr_007_623c:
	ret


	db $04, $04, $03, $02, $01, $00, $00, $00, $e0, $e0, $e8, $f0, $00, $00, $00, $00

Jump_07_624D::
	call EntityCheckHits
	call GetEntityTimer
	jr nz, jr_007_625b

	ld [hl], $80
	call IncrementEntityState
	ret


jr_007_625b:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $623d
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ld hl, $6245
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


Jump_07_627A::
	call EntityCheckHits
	call GetEntityTimer
	jr nz, jr_007_6287

	ld [hl], $40
	call IncrementEntityState

jr_007_6287:
	ld e, $04
	and $10
	jr nz, jr_007_628e

	inc e

jr_007_628e:
	ld a, e
	call SetEntitySpriteVariant
	ret


	db $00, $00, $00, $00, $01, $02, $03, $05, $00, $00, $00, $00, $00, $f0, $e8, $e0

Jump_07_62A3::
	call EntityCheckHits
	call GetEntityTimer
	jr nz, jr_007_62b2

	ld [hl], $40
	call IncrementEntityState
	ld [hl], b
	ret


jr_007_62b2:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6293
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ld hl, $629b
	add hl, de
	ld a, [hl]
	ld hl, wEntityPrivate1
	add hl, bc
	add [hl]
	ld hl, wEntityY
	add hl, bc
	ld [hl], a
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f0, $00, $74, $00, $f0, $08, $74, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $70, $00, $00, $08, $70, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $00, $74, $00, $f8, $08, $74, $20, $08, $00, $76, $00, $08, $08, $76, $20
	db $00, $00, $70, $00, $00, $08, $70, $20, $10, $00, $72, $00, $10, $08, $72, $20
	db $00, $00, $78, $00, $00, $08, $78, $20, $10, $00, $72, $00, $10, $08, $72, $20

Call_07_6331::
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $62d1
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ret


	db $98, $00, $53, $7f, $98, $20, $53, $7f, $98, $40, $53, $7f, $98, $60, $53, $7f
	db $98, $80, $53, $7f, $98, $a0, $53, $7f, $98, $c0, $53, $7f, $98, $e0, $53, $7f
	db $99, $00, $53, $7f, $99, $20, $53, $7f, $99, $40, $53, $7f, $99, $60, $53, $7f
	db $99, $80, $53, $7f, $99, $a0, $53, $7f, $99, $c0, $53, $7f, $99, $e0, $53, $7f
	db $9a, $00, $53, $7f, $9a, $20, $53, $7f

Jump_007_638d:
	xor a
	ldh [hBaseScrollX], a
	ldh [hBaseScrollY], a
	ld [wBGOriginLow], a
	ld [wBGOriginHigh], a
	ld hl, wLCDControl
	res 5, [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $09
	jr z, jr_007_63d2

	ld a, [wDrawCommandsSize]
	ld e, a
	add $08
	ld [wDrawCommandsSize], a
	ld d, b
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld c, [hl]
	inc [hl]
	sla c
	sla c
	sla c
	ld hl, $6345
	add hl, bc
	push hl
	pop bc
	ld hl, wDrawCommand
	add hl, de
	ld e, $08

jr_007_63c9:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_007_63c9

	ld [hl], b
	pop bc
	ret


jr_007_63d2:
	call GetEntityTimer
	ret nz

	ldh a, [hMapId]
	add $50
	call OpenDialogTable1
	ld a, $e4
	ld [wBGPalette], a
	jp ClearEntityStatus


	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

Call_07_63F1::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_007_638d

	ld de, $63e5
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	ldh a, [hIsSideScrolling]
	and a
	jp nz, Jump_007_64ad

	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_640F::
	dw Jump_07_641D
	dw Jump_07_6461
	dw Jump_07_6484

	db $08, $f8, $00, $00, $00, $00, $f8, $08

Jump_07_641D::
	call EntityCheckWeaponHits
	call Call_07_650E
	call GetEntityTimer
	jr nz, jr_007_645f

	call GetRandomByte
	and $3f
	add $30
	ld [hl], a
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr nz, jr_007_6441

	ld [hl], b
	call GetEntityDirectionToLink
	jr jr_007_6447

jr_007_6441:
	call GetRandomByte
	and $03
	ld e, a

jr_007_6447:
	ld d, b
	ld hl, $6415
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $6419
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call IncrementEntityState

jr_007_645f:
	jr jr_007_6478

Jump_07_6461::
	call EntityCheckWeaponHits
	call Call_07_650E
	call GetEntityTimer
	jr nz, jr_007_6472

	ld [hl], $20
	call IncrementEntityState
	ld [hl], b

jr_007_6472:
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls

Jump_007_6478:
jr_007_6478:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_07_6484::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
	call GetEntityTimer
	jr nz, jr_007_64a7

	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $2d
	ld hl, wEntityDyingTimer
	add hl, bc
	ld [hl], $0c
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $01
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $04

jr_007_64a7:
	ld a, $02
	call SetEntitySpriteVariant
	ret


Jump_007_64ad:
	ldh a, [hActiveEntityState]
	cp $02
	jr z, Jump_07_6484

	call EntityCheckWeaponHits
	call Call_07_651A
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_64BC::
	dw Jump_07_64C0
	dw Jump_07_64D2

Jump_07_64C0::
	call EntityLinkDiffX
	ld a, $08
	dec e
	jr nz, jr_007_64ca

	ld a, $f8

jr_007_64ca:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	jp IncrementEntityState


Jump_07_64D2::
	call UpdateEntityPosWithSpeed
	ld hl, wEntitySpeedY
	add hl, bc
	inc [hl]
	inc [hl]
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_007_64ef

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_007_64ef:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $08
	jr z, jr_007_650a

	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	and $f0
	add $03
	ld [hl], a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	jp Jump_007_6478


jr_007_650a:
	xor a
	jp SetEntitySpriteVariant


Call_07_650E::
	ldh a, [hLinkPositionZ]
	and a
	jp z, EntityTouchesLink

	cp $08
	jp c, EntityTouchesLink

	ret


Call_07_651A::
	jp EntityTouchesLink


	db $40, $00, $40, $20, $42, $00, $42, $20

Call_07_6525::
	ld de, $651d
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call AddEntityZSpeedToPos
	call EntityCheckWalls
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	set 6, [hl]
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_654C::
	dw Jump_07_6552
	dw Jump_07_65AD
	dw Jump_07_65F5

Jump_07_6552::
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6563

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_007_656f

	dec [hl]
	jr jr_007_656f

jr_007_6563:
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]

jr_007_656f:
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_007_6593

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6584

	and $80
	jr z, jr_007_6583

	inc [hl]
	inc [hl]

jr_007_6583:
	dec [hl]

jr_007_6584:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6593

	and $80
	jr z, jr_007_6592

	inc [hl]
	inc [hl]

jr_007_6592:
	dec [hl]

jr_007_6593:
	call GetEntityDropTimer
	jr nz, jr_007_659b

	call IncrementEntityState

jr_007_659b:
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_65aa

	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_007_65aa

	dec [hl]

jr_007_65aa:
	jp Call_07_65CB


Jump_07_65AD::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	cp $08
	jr c, jr_007_65c4

	call GetEntityDropTimer
	call GetRandomByte
	and $1f
	add $80
	ld [hl], a
	jp IncrementEntityState


jr_007_65c4:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, Call_07_65CB

	inc [hl]

Call_07_65CB::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
	ld [hl], a
	rra
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d

Jump_07_65F5::
	call Call_07_65CB
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $10
	jr z, jr_007_6609

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_007_6608

	inc [hl]

jr_007_6608:
	ret


jr_007_6609:
	call GetEntityDropTimer
	jr nz, jr_007_6614

	ld [hl], $60
	call IncrementEntityState
	ld [hl], b

jr_007_6614:
	ld hl, wEntityPrivate3
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $18
	jr c, jr_007_665c

	ld [hl], b
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate4
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, wEntityPrivate4
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $65e1
	add hl, de
	ld a, [hl]
	sra a
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $65e5
	add hl, de
	ld a, [hl]
	sra a
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $07
	jr nz, jr_007_665c

	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

jr_007_665c:
	ret


	db $44, $00, $46, $00, $44, $00, $48, $00, $46, $20, $44, $20, $48, $20, $44, $20

Call_07_666D::
	ld hl, wEntityDirection
	add hl, bc
	ldh a, [hActiveEntitySpriteVariant]
	add [hl]
	ldh [hActiveEntitySpriteVariant], a
	ld de, $665d
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_66a1

	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $08
	call GetEntityTimer1
	ld [hl], $20

jr_007_66a1:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_66A4::
	dw Jump_07_66B6
	dw Jump_07_66F8
	dw Jump_07_674B

	db $08, $f8, $00, $00, $00, $00, $f8, $08, $02, $00, $ff, $ff

Jump_07_66B6::
	call GetEntityTimer
	jr nz, jr_007_66f0

	call IncrementEntityState
	call GetEntityTimer
	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	and $03
	ld e, a

Call_07_66CC::
	ld d, b
	ld hl, $66aa
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $66ae
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	ld hl, $66b2
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, jr_007_66ef

	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a

jr_007_66ef:
	ret


jr_007_66f0:
	call ClearEntitySpeed
	call Call_07_6711
	jr jr_007_6706

Jump_07_66F8::
	call GetEntityTimer
	jr nz, jr_007_6703

	ld [hl], $18
	call IncrementEntityState
	ld [hl], b

jr_007_6703:
	call Call_07_6711

jr_007_6706:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Call_07_6711::
	call GetEntityTimer1
	jr nz, jr_007_673b

	call EntityLinkDiffX
	add $08
	cp $10
	jr nc, jr_007_673c

	call EntityLinkDiffY

jr_007_6722:
	call Call_07_66CC
	ld hl, wEntitySpeedX
	add hl, bc
	sla [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sla [hl]
	call IncrementEntityState
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $30

jr_007_673b:
	ret


jr_007_673c:
	call EntityLinkDiffY
	add $08
	cp $10
	jr nc, jr_007_674a

	call EntityLinkDiffX
	jr jr_007_6722

jr_007_674a:
	ret


Jump_07_674B::
	call GetEntityTimer
	jr nz, jr_007_675b

	ld [hl], $20
	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer1
	ld [hl], $40

jr_007_675b:
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


	db $55, $56, $0a, $0b, $0c, $0d, $0e, $0f, $55, $56, $55, $56, $1a, $1b, $1c, $1d
	db $1e, $1f, $55, $56, $55, $56, $04, $05, $64, $65, $06, $07, $55, $56, $55, $56
	db $14, $15, $66, $67, $16, $17, $55, $56, $76, $76, $72, $73, $76, $76, $72, $73
	db $68, $69, $76, $76, $73, $72, $76, $76, $73, $72, $77, $4b, $6c, $6c, $6c, $6c
	db $76, $76, $76, $76, $72, $73, $6c, $6c, $6c, $6c, $76, $76, $76, $76, $73, $72
	db $6d, $6d, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6d, $6d, $6c, $6c, $6c, $6c
	db $6c, $6c, $6c, $6c, $55, $56, $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $55, $56
	db $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $55, $56, $6e, $6e, $6e, $6e, $6e, $6e
	db $55, $56, $55, $56, $6e, $6e, $6e, $6e, $6e, $6e, $55, $56, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
	db $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $3a, $d5, $d6, $d7, $3a, $3a, $cd, $e1
	db $ce, $3a, $03, $09, $03, $09, $c6, $1b, $1b, $03, $03, $09, $0e, $1b, $1b, $1b
	db $1b, $02, $12, $22, $32, $42, $00, $08, $10, $18, $20, $28, $30, $38, $40, $48

Jump_007_6855:
	call ReturnIfNonInteractive
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	ld [wLinkFrozen], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_6862::
	dw Jump_07_686A
	dw Jump_07_6875
	dw Jump_07_6881
	dw Jump_07_688D

Jump_07_686A::
	call PlayNoiseSfx04
	call GetEntityTimer
	ld [hl], $28
	jp IncrementEntityState


Jump_07_6875::
	call GetEntityTimer
	ret nz

	ld a, $4c
	ld [wMusicTrackToPlay], a
	jp IncrementEntityState


Jump_07_6881::
	ld a, $1d
	ldh [hNoiseSfx], a
	call GetEntityTimer
	ld [hl], $80
	jp IncrementEntityState


Jump_07_688D::
	ldh a, [hFrameCounter]
	ld e, $00
	and $08
	jr z, jr_007_6897

	ld e, $02

jr_007_6897:
	ld a, e
	ld [wScreenShakeX], a
	call GetEntityTimer
	ret nz

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld e, a
	inc a
	ld [hl], a
	ldh [hBGTilesRequestCopy], a
	ld a, e
	and $1f
	jp nz, Jump_007_68bb

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $0a
	jp z, Jump_007_6940

	inc a
	ld [hl], a

Jump_007_68bb:
	ld hl, wEntityPrivateCounter
	add hl, bc
	push hl
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $684a
	add hl, de
	ld a, [hl]
	ldh [hBGPosY], a
	ld a, $20
	ldh [hBGPosX], a
	call GetBGAddress
	pop hl
	ld a, [hl]
	dec a
	ld e, a
	sla a
	sla a
	sla a
	add e
	add e
	ld e, a
	ld d, b
	ld hl, $6765
	ldh a, [hBGTilesRequestCopy]
	and $01
	jr z, jr_007_68eb

	ld hl, $67c9

jr_007_68eb:
	add hl, de
	push hl
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, b
	add $0d
	ld [wDrawCommandsSize], a
	ld hl, wDrawCommand
	add hl, de
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	ld a, $09
	ld [hli], a
	pop de
	push bc
	ld c, $0a

jr_007_6908:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_007_6908

	ld [hl], b
	pop bc
	push bc
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	dec a
	rra
	and $07
	push af
	ld e, a
	ld d, b
	ld hl, $6846
	add hl, de
	ld e, [hl]
	ld hl, wRoomObjects
	add hl, de
	push hl
	pop bc
	pop af
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $682d
	add hl, de
	ld e, $05

jr_007_6938:
	ld a, [hli]
	ld [bc], a
	inc bc
	dec e
	jr nz, jr_007_6938

	pop bc
	ret


Jump_007_6940:
	xor a
	ld [wScreenShakeX], a
	ld [wLinkFrozen], a
	call SelectAreaMusicFar
	jp ClearEntityStatus


Call_07_694D::
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	cp $ff
	jp z, Jump_007_6855

	and a
	jr nz, jr_007_695e

	inc [hl]
	call Call_07_6DE1

jr_007_695e:
	call Call_07_6EC2
	ldh a, [hActiveEntityStatus]
	cp $05
	jp nz, BossDefeatedHandler

	call ReturnIfNonInteractive
	call ConfineLinkToArena
	call Call_3F12
	ld hl, wEntityFlashTimer
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, jr_007_6995

	ldh a, [hActiveEntityState]
	cp $09
	jr nc, jr_007_6990

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	call IncrementEntityState
	ld a, $09
	ld [hl], a
	ldh [hActiveEntityState], a
	jr jr_007_6995

jr_007_6990:
	ld hl, wEntityPrivateCounter
	add hl, bc
	inc [hl]

jr_007_6995:
	call ApplyRecoilIfNeeded
	call AddEntityZSpeedToPos
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_007_69b2

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_007_69b2:
	ldh a, [hActiveEntityState]
	cp $09
	jr nc, jr_007_69cc

	call EntityCheckSwordClash
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [wLinkPushedTimer]
	or [hl]
	and a
	jr nz, jr_007_69cc

	call EntityTouchesLink
	call EntityCheckWeaponHits

jr_007_69cc:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_69CF::
	dw Jump_07_69EB
	dw Jump_07_6A01
	dw Jump_07_6A22
	dw Jump_07_6A74
	dw Jump_07_6AD4
	dw Jump_07_6B03
	dw Jump_07_6B49
	dw Jump_07_6C28
	dw Jump_07_6C70
	dw Jump_07_6C93
	dw Jump_07_6CB4
	dw Jump_07_6CEF
	dw Jump_07_6D0D
	dw Jump_07_6D6F

Jump_07_69EB::
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	call GetEntityTimer
	jr nz, jr_007_6a00

	ld [hl], $30
	call IncrementEntityState
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $6f

jr_007_6a00:
	ret


Jump_07_6A01::
	call GetEntityTimer
	jr z, jr_007_6a14

	cp $01
	jr nz, jr_007_6a0e

	ld a, $08
	ldh [hJingle], a

jr_007_6a0e:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b
	ret


jr_007_6a14:
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, Call_07_6A21

	call GetEntityTimer
	ld [hl], $40
	call IncrementEntityState

Call_07_6A21::
	ret


Jump_07_6A22::
	call GetEntityTimer
	cp $01
	jr nz, jr_007_6a3f

	ld e, $12
	ldh a, [hMapRoom]
	cp $92
	jr z, jr_007_6a3b

	cp $84
	jr z, jr_007_6a3b

	cp $80
	jr nz, jr_007_6a3f

	ld e, $14

jr_007_6a3b:
	ld a, e
	call OpenDialogTable1

jr_007_6a3f:
	call GetEntityTimer
	jr nz, jr_007_6a51

	ld [hl], $a0
	ldh a, [hMapRoom]
	cp $95
	jr z, jr_007_6a4e

	ld [hl], $20

jr_007_6a4e:
	jp IncrementEntityState


jr_007_6a51:
	ld hl, $d20e
	ld [hl], $f0
	ld hl, $d20b
	ld [hl], $f8
	ld hl, $d20d
	ld [hl], $f0
	cp $20
	jr c, jr_007_6a73

	ld hl, $d20e
	ld [hl], $f2
	ld hl, $d20b
	ld [hl], $fa
	ld hl, $d20d
	ld [hl], $f2

jr_007_6a73:
	ret


Jump_07_6A74::
	call GetEntityTimer
	jr nz, jr_007_6a7e

	ld [hl], $20
	jp IncrementEntityState


jr_007_6a7e:
	and $3f
	jr nz, jr_007_6a82

jr_007_6a82:
	call GetEntityTimer
	and $40
	jr z, Call_07_6AAF

Call_07_6A89::
	call Call_07_6E01
	ld hl, $d208
	ld [hl], $01
	ld hl, $d209
	ld [hl], b
	ld hl, $d20a
	ld [hl], $f0
	ld hl, $d20b
	ld [hl], $f8
	ld hl, $d20d
	ld [hl], $f3
	ld hl, $d20c
	ld [hl], $10
	ld hl, $d207
	ld [hl], $00
	ret


Call_07_6AAF::
	call Call_07_6E01
	ld hl, $d208
	ld [hl], b
	ld hl, $d209
	ld [hl], b
	ld hl, $d20a
	ld [hl], $f8
	ld hl, $d20b
	ld [hl], $f8
	ld hl, $d20d
	ld [hl], $f0
	ld hl, $d20c
	ld [hl], $10
	ld hl, $d207
	ld [hl], $00
	ret


Jump_07_6AD4::
	call Call_07_6DB1
	call GetEntityTimer
	jr nz, jr_007_6b02

	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	ld a, $08
	call SetEntitySpeedTowardsLink
	call IncrementEntityState

Call_07_6AEC::
	call EntityLinkDiffX
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e

Call_07_6AF4::
	call Call_07_6A89
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_6b02

	call Call_07_6AAF

jr_007_6b02:
	ret


Jump_07_6B03::
	call Call_07_6DB1
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, jr_007_6b23

	call EntityLinkDiffY
	add $1c
	cp $38
	jr nc, jr_007_6b23

	call IncrementEntityState
	ld [hl], $06
	call GetEntityTimer
	ld [hl], $30
	ret


jr_007_6b23:
	call GetEntityTimer
	jr nz, jr_007_6b36

	call GetRandomByte
	and $0f
	add $10
	ld [hl], a
	call IncrementEntityState
	ld [hl], $04
	ret


jr_007_6b36:
	and $0f
	jr nz, Call_07_6B42

	ld a, [$d209]
	xor $01
	ld [$d209], a

Call_07_6B42::
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ret


Jump_07_6B49::
	call GetEntityTimer
	jr nz, jr_007_6b65

Call_07_6B4E::
	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState
	ld [hl], $04
	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	res 6, [hl]
	ret


jr_007_6b65:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_6bc8

	call GetEntityTimer
	cp $18
	jr c, jr_007_6b87

	call Call_07_6AAF
	ld a, $08
	ld [$d20c], a
	ld a, $e0
	ld [$d20d], a
	ld a, $01
	ld [$d207], a
	ret


jr_007_6b87:
	cp $10
	jr c, jr_007_6bae

	cp $17
	jr nz, jr_007_6b99

	ld a, $27
	ldh [hNoiseSfx], a
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $10

jr_007_6b99:
	ld a, $ff
	ld [$d207], a
	ld a, $f0
	ld [$d20a], a
	ld a, $f4
	ld [$d20b], a
	ld a, $01
	ld [$d208], a
	ret


jr_007_6bae:
	ld a, $03
	ld [$d207], a
	ld a, $f8
	ld [$d20c], a
	ld a, $08
	ld [$d20d], a
	ld a, $f0
	ld [$d20a], a
	ld a, $f0
	ld [$d20b], a
	ret


jr_007_6bc8:
	call GetEntityTimer
	cp $18
	jr c, jr_007_6be7

	call Call_07_6A89
	ld a, $01
	ld [$d209], a
	ld a, $f8
	ld [$d20c], a
	ld a, $e8
	ld [$d20d], a
	ld a, $00
	ld [$d207], a
	ret


jr_007_6be7:
	cp $10
	jr c, jr_007_6c0e

	cp $17
	jr nz, jr_007_6bf9

	ld a, $27
	ldh [hNoiseSfx], a
	ld hl, wEntityTimer2
	add hl, bc
	ld [hl], $10

jr_007_6bf9:
	ld a, $ff
	ld [$d207], a
	ld a, $f0
	ld [$d20a], a
	ld a, $f0
	ld [$d20b], a
	ld a, $00
	ld [$d208], a
	ret


jr_007_6c0e:
	ld a, $02
	ld [$d207], a
	ld a, $10
	ld [$d20c], a
	ld a, $08
	ld [$d20d], a
	ld a, $f0
	ld [$d20a], a
	ld a, $ec
	ld [$d20b], a
	ret


Jump_07_6C28::
	call Call_07_6AF4
	call GetEntityTimer
	jr nz, Call_07_6C57

	call IncrementEntityState
	call PlayJingle24
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $30
	and a
	jr nz, jr_007_6c4b

	ld [hl], $28
	ld a, $18
	jp SetEntitySpeedTowardsLink


jr_007_6c4b:
	ld a, $08
	call SetEntitySpeedTowardsLink
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $f0
	ret


Call_07_6C57::
	ld a, [$d20e]
	add $02
	ld [$d20e], a
	ld a, [$d20b]
	add $02
	ld [$d20b], a
	ld a, [$d20d]
	add $02
	ld [$d20d], a
	ret


Jump_07_6C70::
	call GetEntityTimer
	jr z, jr_007_6c82

	dec a
	jr nz, jr_007_6c7b

	call Call_07_6B4E

jr_007_6c7b:
	call Call_07_6AF4
	call Call_07_6C57
	ret


jr_007_6c82:
	call Call_07_6B42
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_007_6c92

	call GetEntityTimer
	ld [hl], $10
	call Call_07_6A21

jr_007_6c92:
	ret


Jump_07_6C93::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_007_6cb0

	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $20
	ld hl, wEntityHitboxFlags
	add hl, bc
	res 7, [hl]
	ld hl, wEntityOptions1
	add hl, bc
	set 6, [hl]
	ld a, $28
	ldh [hJingle], a

jr_007_6cb0:
	call Call_07_6B42
	ret


Jump_07_6CB4::
	call GetEntityTimer
	jr nz, jr_007_6cbf

	ld [hl], $c0
	call IncrementEntityState
	ret


jr_007_6cbf:
	ld hl, $d20b
	ld a, [hl]
	sub $03
	jr z, jr_007_6cce

	bit 7, a
	jr z, jr_007_6ccd

	inc [hl]
	inc [hl]

jr_007_6ccd:
	dec [hl]

jr_007_6cce:
	ld hl, $d20d
	ld a, [hl]
	sub $03
	jr z, jr_007_6cdd

	bit 7, a
	jr z, jr_007_6cdc

	inc [hl]
	inc [hl]

jr_007_6cdc:
	dec [hl]

jr_007_6cdd:
	call GetEntityTimer
	cp $14
	jr nc, jr_007_6cee

	ld a, [$d20e]
	and a
	jr z, jr_007_6cee

	inc a
	ld [$d20e], a

jr_007_6cee:
	ret


Jump_07_6CEF::
	call GetEntityTimer
	jr nz, jr_007_6cfa

	ld [hl], $30
	call IncrementEntityState
	ret


jr_007_6cfa:
	cp $30
	jr nc, jr_007_6d0c

	and $03
	jr nz, jr_007_6d0c

	ld a, [$d20e]
	add $02
	cpl
	inc a
	ld [$d20e], a

jr_007_6d0c:
	ret


Jump_07_6D0D::
	ld a, [$d20e]
	cp $f0
	jr z, jr_007_6d18

	dec a
	ld [$d20e], a

jr_007_6d18:
	call GetEntityTimer
	jr nz, jr_007_6d4c

	ld e, $ff
	ldh a, [hMapRoom]
	cp $80
	jr z, jr_007_6d2d

	ld e, $03
	cp $95
	jr z, jr_007_6d2d

	ld e, $02

jr_007_6d2d:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp e
	jr c, jr_007_6d49

	ld hl, wEntityHitboxFlags
	add hl, bc
	set 7, [hl]
	call IncrementEntityState
	ld a, $13
	call OpenDialogTable1
	call GetEntityTimer
	ld [hl], $04
	ret


jr_007_6d49:
	jp Call_07_6B4E


jr_007_6d4c:
	cp $24
	jr nc, jr_007_6d6e

	ld hl, $d20b
	ld a, [hl]
	sub $f8
	jr z, jr_007_6d5f

	bit 7, a
	jr z, jr_007_6d5e

	inc [hl]
	inc [hl]

jr_007_6d5e:
	dec [hl]

jr_007_6d5f:
	ld hl, $d20d
	ld a, [hl]
	sub $f0
	jr z, jr_007_6d6e

	bit 7, a
	jr z, jr_007_6d6d

	inc [hl]
	inc [hl]

jr_007_6d6d:
	dec [hl]

jr_007_6d6e:
	ret


Jump_07_6D6F::
	call Call_07_6AF4
	call GetEntityTimer
	jr z, jr_007_6d82

	dec a
	jr nz, jr_007_6d7e

	ld a, $3f
	ldh [hNoiseSfx], a

jr_007_6d7e:
	call Call_07_6C57
	ret


jr_007_6d82:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $30
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $78
	jr c, jr_007_6db0

	call SelectAreaMusicFar
	call ClearEntityStatus

MarkRoomEventDone::
	ld hl, $d900
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_007_6da9

	cp $06
	jr c, jr_007_6da9

	inc d

jr_007_6da9:
	add hl, de
	ld a, [hl]
	or $20
	ld [hl], a
	ldh [hRoomStatus], a

jr_007_6db0:
	ret


Call_07_6DB1::
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], b
	call EntityLinkDiffX
	add $30
	cp $60
	jr nc, jr_007_6dd3

	call EntityLinkDiffY
	add $30
	cp $60
	jr nc, jr_007_6dd3

	ld a, e
	cp $02
	jr nz, jr_007_6de0

	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], $01

jr_007_6dd3:
	call IncrementEntityState
	ld [hl], $07
	call GetEntityTimer
	ld [hl], $20
	call Call_07_6AEC

jr_007_6de0:
	ret


Call_07_6DE1::
	ld hl, wEntityZ
	add hl, bc
	ld [hl], $7f
	call GetEntityTimer
	ld [hl], $80
	ldh a, [hDefaultMusicTrack]
	ld hl, wEntityPrivate5
	add hl, bc
	ld [hl], a
	ld hl, wEntityHealth
	add hl, bc
	ld [hl], $ff
	ldh a, [hMapRoom]
	cp $80
	jr nz, Call_07_6E01

	ld [hl], $c0

Call_07_6E01::
	ld a, $f8
	ld [$d20a], a
	ld a, $f8
	ld [$d20b], a
	ld a, $f0
	ld [$d20e], a
	ld a, $00
	ld [$d207], a
	ld [$d208], a
	ld [$d209], a
	ld a, $10
	ld [$d20c], a
	ld a, $f0
	ld [$d20d], a
	ret


	db $70, $00, $70, $20, $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00
	db $00, $10, $66, $00, $00, $f8, $66, $20, $00, $00, $64, $20, $00, $08, $62, $20
	db $00, $10, $60, $20, $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6c, $00
	db $00, $10, $6e, $00, $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $08, $6a, $20
	db $00, $10, $68, $20, $00, $00, $72, $00, $f8, $08, $74, $00, $f8, $00, $74, $20
	db $00, $08, $72, $20, $00, $00, $72, $40, $08, $08, $74, $40, $08, $00, $74, $60
	db $00, $08, $72, $60, $10, $00, $76, $00, $10, $08, $78, $00, $10, $10, $7a, $00
	db $08, $18, $7c, $00, $f8, $18, $7e, $00, $10, $08, $76, $20, $10, $00, $78, $20
	db $10, $f8, $7a, $20, $08, $f0, $7c, $20, $f8, $f0, $7e, $20, $0c, $fb, $26, $00
	db $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

Call_07_6EC2::
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_007_6f27

	call Call_07_6EF8
	call Call_07_6F28
	call Call_07_6F4F
	call Call_07_6F84
	call Call_07_6FA5
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6ef5

	ldh a, [hActiveEntityY]
	sub $02
	ldh [hActiveEntityDrawY], a
	ld hl, $6eb2
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	call ReserveOAMEntriesFar

jr_007_6ef5:
	jp LoadEntityPosition


Call_07_6EF8::
	ld a, [$d20c]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	ld a, [$d20d]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld a, [$d207]
	cp $ff
	jr z, jr_007_6f24

	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $6e6a
	add hl, de
	ld c, $02
	call DrawEntitySprites
	ld a, $02
	jp Jump_007_6f48


jr_007_6f24:
	call LoadEntityPosition

jr_007_6f27:
	ret


Call_07_6F28::
	ld hl, wEntityTimer2
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6f4e

	call Call_07_6FCC
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	ld hl, $6e8a
	and a
	jr z, jr_007_6f41

	ld hl, $6e9e

jr_007_6f41:
	ld c, $05
	call DrawEntitySprites
	ld a, $05

Jump_007_6f48:
	call ReserveOAMEntriesFar
	call LoadEntityPosition

jr_007_6f4e:
	ret


Call_07_6F4F::
	ld a, [$d20a]
	ld hl, hActiveEntityX
	add [hl]
	ld [hl], a
	ld a, [$d20a]
	add $0c
	ld [wClashBoxX], a
	ld a, [$d20b]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld a, [$d20b]
	add $08
	ld [wClashBoxY], a
	ld a, $08
	ld [wClashBoxHalfWidth], a
	ld a, $06
	ld [wClashBoxHalfHeight], a
	ld de, $6e26
	call DrawEntity16x16
	ld a, $02
	jp Jump_007_6f48


Call_07_6F84::
	ld a, [$d20e]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld a, [$d208]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $6e2a
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	jp Jump_007_6f48


Call_07_6FA5::
	ld a, [$d20e]
	cp $00
	ret z

	ld a, [$d20f]
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld a, [$d209]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $6e4a
	add hl, de
	ld c, $04
	call DrawEntitySprites
	ld a, $04
	jp Jump_007_6f48


Call_07_6FCC::
	ld hl, wIsLinkInTheAir
	ld a, [wInvincibilityCounter]
	or [hl]
	jr nz, jr_007_7026

	ldh a, [hActiveEntityDrawY]
	add $18
	ld e, a
	ldh a, [hLinkY]
	ld hl, hLinkPositionZ
	sub [hl]
	add $08
	sub e
	add $0c
	cp $18
	jr nc, jr_007_7026

	ld hl, wEntityDirection
	add hl, bc
	ld e, $08
	ld a, [hl]
	and a
	jr z, jr_007_6ff5

	ld e, $f8

jr_007_6ff5:
	ldh a, [hActiveEntityX]
	add e
	ld hl, hLinkX
	sub [hl]
	add $1a
	cp $34
	jr nc, jr_007_7026

	ld a, $28
	call GetVectorTowardsLink
	ldh a, [hMultiPurpose0]
	ldh [hLinkSpeedY], a
	ldh a, [hMultiPurpose1]
	ldh [hLinkSpeedX], a
	ld a, $02
	ld [wIsLinkInTheAir], a
	ld a, $13
	ldh [hLinkSpeedZ], a
	ld a, $08
	ld [wSubtractHealthBuffer], a
	ld a, $20
	ld [wInvincibilityCounter], a
	ld a, $03
	ldh [hWaveSfx], a

jr_007_7026:
	ret


	db $12, $14, $16, $18, $19, $1a, $1a, $1a, $1a, $1a

Call_07_7031::
	call ReturnIfNonInteractive
	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, jr_007_7046

	call EntityLinkDiffY
	add $20
	cp $40
	jr c, jr_007_70ac

jr_007_7046:
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $7f
	ret nz

	ld e, $0f
	ld d, b

jr_007_7053:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $82
	jr z, jr_007_7076

	cp $9e
	jr z, jr_007_7076

	cp $7d
	jr z, jr_007_7076

	ld hl, wEntityPhysicsFlags
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_007_7076

	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $05
	jr z, jr_007_707d

jr_007_7076:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_007_7053

	ret


jr_007_707d:
	ld a, [wRoomEventDone]
	and a
	ret nz

	ld a, $7d
	call SpawnEntity
	jr c, jr_007_70ac

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
	ldh a, [hMapId]
	ld e, a
	ld a, $14
	cp $0a
	jr nc, jr_007_70a8

	ld hl, $7027
	add hl, de
	ld a, [hl]

jr_007_70a8:
	call SetEntitySpeedTowardsLink
	pop bc

jr_007_70ac:
	ret


Call_07_70AD::
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	cp $00
	jr nz, jr_007_70c9

	ldh a, [hRoomStatus]
	and $10
	jp nz, ClearEntityStatus

	ld hl, wEntityLoadOrder
	add hl, bc
	ld [hl], $ff
	ld hl, wEntityDropType
	add hl, bc
	ld [hl], $3c

jr_007_70c9:
	call ReturnIfNonInteractive
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], b
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7149

	ld a, $14
	call SpawnEntity
	jr c, jr_007_7149

	ld hl, wEntityDropType
	add hl, bc
	ld a, [hl]
	ld hl, wEntityDropType
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	add $08
	ld [hl], a
	call Call_3E64
	ldh a, [hActiveEntityX]
	sub $08
	ldh [hBGPosX], a
	ldh a, [hActiveEntityY]
	sub $10
	ldh [hBGPosY], a
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
	ld e, a
	ld d, b
	ld hl, wRoomObjects
	add hl, de
	ld [hl], $91
	call GetBGAddress
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
	add $0a
	ld [wDrawCommandsSize], a
	ld e, $08
	call Call_07_7136
	ld e, $09

Call_07_7136::
	ldh a, [hBGAddrHigh]
	ld [hli], a
	ldh a, [hBGAddrLow]
	ld [hli], a
	inc a
	ldh [hBGAddrLow], a
	ld a, $81
	ld [hli], a
	ld a, e
	ld [hli], a
	inc a
	inc a
	ld [hli], a
	xor a
	ld [hl], a

jr_007_7149:
	ret


	db $74, $00, $74, $20, $76, $00, $78, $00, $7a, $00, $7a, $20, $78, $20, $76, $20
	db $7c, $00, $7c, $00

Call_07_715E::
	ld de, $714a
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_007_7183

	ld a, [hl]
	and $0c
	jr nz, jr_007_718d

	jr jr_007_7195

jr_007_7183:
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_007_7195

jr_007_718d:
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_007_7195:
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	call SetEntitySpriteVariant
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $54, $00, $54, $20, $52, $00, $52, $20
	db $56, $00, $56, $00

Call_07_71B4::
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr nz, jr_007_71c2

	ld de, $71b0
	call DrawEntity8x16
	jr jr_007_71c8

jr_007_71c2:
	ld de, $71a0
	call DrawEntity16x16

jr_007_71c8:
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	call AddEntityZSpeedToPos
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	and $80
	ldh [hBGTilesRequestCopy], a
	jr z, jr_007_71e8

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_007_71e8:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_71EB::
	dw Jump_07_71F9
	dw Jump_07_7225
	dw Jump_07_7256
	dw Jump_07_7264
	dw Jump_07_7286
	dw Jump_07_72AB
	dw Jump_07_72E3

Jump_07_71F9::
	call GetEntityTimer
	jr nz, jr_007_7224

	call EntityLinkDiffX
	add $20
	cp $40
	jr nc, jr_007_7224

	call EntityLinkDiffY
	add $20
	cp $40
	jr nc, jr_007_7224

	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $20
	call GetRandomByte
	and $03
	add $03
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a

jr_007_7224:
	ret


Jump_07_7225::
	call GetEntityTimer
	jr nz, jr_007_7249

	ld hl, wEntityZ
	add hl, bc
	ld [hl], $08
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $08
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $12
	ld a, $03
	call SetEntitySpriteVariant
	call IncrementEntityState

PlayJingle24::
	ld a, $24
	ldh [hJingle], a
	ret


jr_007_7249:
	ld e, $01
	cp $10
	jr nc, jr_007_7251

	ld e, $02

jr_007_7251:
	ld a, e
	call SetEntitySpriteVariant
	ret


Jump_07_7256::
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_007_7263

	call GetEntityTimer
	ld [hl], $20
	call IncrementEntityState

jr_007_7263:
	ret


Jump_07_7264::
	call EntityCheckWeaponHits
	call GetEntityTimer
	jr nz, jr_007_7275

	ld [hl], $10
	call ClearEntitySpeed
	call IncrementEntityState
	ret


jr_007_7275:
	ld e, $08
	and $04
	jr z, jr_007_727d

	ld e, $f8

jr_007_727d:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], e
	call AddEntitySpeedToPosX
	ret


Jump_07_7286::
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call Call_07_7305
	call GetEntityTimer
	jr nz, jr_007_72a5

	ld a, $0c
	call SetEntitySpeedTowardsLink
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
	call PlayJingle24
	call IncrementEntityState

jr_007_72a5:
	ld a, $03
	call SetEntitySpriteVariant
	ret


Jump_07_72AB::
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call Call_07_7305
	ldh a, [hBGTilesRequestCopy]
	and a
	jr z, jr_007_72dd

	call ClearEntitySpeed
	call IncrementEntityState
	ld [hl], $04
	call GetEntityTimer
	ld [hl], $20
	ld hl, wEntityPrivate1
	add hl, bc
	dec [hl]
	jr nz, jr_007_72dd

	call IncrementEntityState
	ld [hl], $06
	call GetEntityTimer
	ld [hl], $30
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $d2

jr_007_72dd:
	ld a, $02
	call SetEntitySpriteVariant
	ret


Jump_07_72E3::
	call GetEntityTimer
	jr nz, jr_007_72f3

	ld [hl], $50
	call IncrementEntityState
	ld [hl], b
	xor a
	call SetEntitySpriteVariant
	ret


jr_007_72f3:
	ld e, $03
	cp $20
	jr nc, jr_007_7300

	ld e, $01
	cp $10
	jr c, jr_007_7300

	inc e

jr_007_7300:
	ld a, e
	call SetEntitySpriteVariant
	ret


Call_07_7305::
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], $03
	call EntityCheckWalls
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b
	ret


Call_07_7314::
	call ReturnIfNonInteractive
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_731A::
	dw Jump_07_731E
	dw Jump_07_73B7

Jump_07_731E::
	ldh a, [hActiveEntityX]
	and $70
	ld [wSmasherBallSlot], a
	call GetEntityTimer
	ld [hl], $80
	call IncrementEntityState
	ret


	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $21, $28, $53, $56, $34, $45, $35, $44, $31, $48, $38, $41, $14, $66, $15, $63
	db $31, $45, $38, $44, $13, $56, $16, $53, $27, $42, $47, $22, $65, $33, $64, $36
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $23, $56, $26, $53, $32, $47, $42, $37, $33, $46, $43, $36, $24, $55, $25, $54
	db $30, $30, $30, $30, $30, $30, $30, $28, $28

Jump_07_73B7::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $10
	jp z, ClearEntityStatus

	call GetEntityTimer
	jr nz, jr_007_743b

	push hl
	ldh a, [hMapId]
	ld e, a
	ld d, b
	ld hl, $73ae
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ld a, $5a
	call SpawnEntity
	jr c, jr_007_743b

	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	push bc
	ld a, [wSmasherBallSlot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	add [hl]
	inc [hl]
	ld c, a
	ld hl, wEntityPrivate4
	add hl, de
	ldh a, [hActiveEntityY]
	sub $10
	and $f0
	jr z, jr_007_73f7

	ld [hl], a

jr_007_73f7:
	ld a, c
	cp $0f
	jr nz, jr_007_7407

	ld a, [wRoomEvent]
	and $1f
	cp $03
	jr nz, jr_007_7407

	ld [hl], $01

jr_007_7407:
	ld hl, $732e
	add hl, bc
	ld a, [hl]
	push af
	swap a
	and $f0
	or $08
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	pop af
	and $f0
	add $10
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $12
	ld hl, wEntityHitboxFlags
	add hl, de
	ld [hl], $00
	ld hl, wEntityOptions1
	add hl, de
	ld [hl], $00
	ld hl, wEntityHealthGroup
	add hl, de
	ld [hl], $00
	pop bc

jr_007_743b:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20

Call_07_7444::
	ld de, $743c
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call ApplyRecoilIfNeeded
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, jr_007_7479

	call GetEntityTimer
	ld [hl], $10
	call ClearEntitySpeed
	call IncrementEntityState
	xor a
	ld [hl], a
	ldh [hActiveEntityState], a

jr_007_7479:
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_747F::
	dw Jump_07_7485
	dw Jump_07_74A6
	dw Jump_07_74C7

Jump_07_7485::
	call GetEntityTimer
	jr nz, jr_007_74a5

	ld [hl], $20
	call IncrementEntityState
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate1
	add hl, bc
	ld [hl], a
	call GetRandomByte
	and $02
	dec a
	ld hl, wEntityPrivate2
	add hl, bc
	ld [hl], a

jr_007_74a5:
	ret


Jump_07_74A6::
	call GetEntityTimer
	jp z, IncrementEntityState

	and $01
	jr nz, jr_007_74c6

	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	add [hl]
	ld [hl], a

jr_007_74c6:
	ret


Jump_07_74C7::
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_007_74ee

	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_74df

	call IncrementEntityState
	ld [hl], b
	call GetEntityTimer
	ld [hl], $10
	ret


jr_007_74df:
	call Call_07_74E7
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]

Call_07_74E7::
	bit 7, a
	jr z, jr_007_74ed

	inc [hl]
	inc [hl]

jr_007_74ed:
	dec [hl]

jr_007_74ee:
	ret


	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $60, $60, $60, $66, $60, $64, $60
	db $66, $20, $64, $20

Call_07_7503::
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_750f

	ld a, c
	ld [wSmasherBallSlot], a

jr_007_750f:
	ld de, $74ef
	call DrawEntity16x16
	call ReturnIfNonInteractive
	call UpdateEntityPosWithSpeed
	call AddEntityZSpeedToPos
	call EntityCheckWalls
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
	dec a
	and $80
	jr z, jr_007_7544

	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurposeH], a
	sra a
	cpl
	cp $07
	jr nc, jr_007_7543

	xor a

jr_007_7543:
	ld [hl], a

jr_007_7544:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_7547::
	dw Jump_07_7551
	dw Jump_07_7551
	dw Jump_07_7569
	dw Jump_07_7602
	dw Jump_07_763B

Jump_07_7551::
	call Call_07_764B
	ret


	db $00, $0c, $10, $0c, $00, $f4, $f0, $f4, $f0, $f4, $00, $0c, $10, $0c, $00, $f4
	db $00, $01, $04, $00

Jump_07_7569::
	call GetEntityTimer
	jr nz, jr_007_7584

	call ClearEntitySpeed
	call IncrementEntityState
	call GetRandomByte
	and $03
	ld e, a
	ld d, b
	ld hl, $7565
	add hl, de
	ld a, [hl]
	call SetEntitySpriteVariant
	ret


jr_007_7584:
	and $07
	jr nz, jr_007_7591

	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

jr_007_7591:
	ldh a, [hBGTilesRequestCopy]
	dec a
	and $80
	jr z, jr_007_75d6

	call Call_07_75FB
	ldh a, [hMultiPurposeH]
	sub $fc
	and $80
	jr nz, jr_007_75a9

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_007_75d6

jr_007_75a9:
	call GetRandomByte
	and $01
	ld e, $01
	jr z, jr_007_75b4

	ld e, $ff

jr_007_75b4:
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	add e
	and $07
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7555
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $755d
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a
	call Call_07_75FB

jr_007_75d6:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7601

	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
	call GetEntityTimer
	srl [hl]
	ld hl, wEntitySpeedX
	call Call_07_75F4
	ld hl, wEntitySpeedY

Call_07_75F4::
	add hl, bc
	ld a, [hl]
	cpl
	sra a
	inc a
	ld [hl], a

Call_07_75FB::
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff

jr_007_7601:
	ret


Jump_07_7602::
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_763a

	ld a, [wSmasherBallSlot]
	ld e, a
	ld d, b
	ld hl, wEntityState
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_007_763a

	inc [hl]
	call IncrementEntityState
	ldh a, [hActiveEntitySpriteVariant]
	cp $00
	jr nz, jr_007_762c

	ld hl, wEntitySpriteVariant
	add hl, de
	ld a, [hl]
	cp $00
	jp z, TriggerRoomEvent

jr_007_762c:
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $40
	call GetEntityTimer
	ld [hl], $40
	jp PlayNoAmmoSound


jr_007_763a:
	ret


Jump_07_763B::
	call GetEntityTimer
	cp $01
	jr nz, jr_007_7647

	ld a, $01
	call SetEntitySpriteVariant

jr_007_7647:
	call Call_07_764B
	ret


Call_07_764B::
	call EntityTouchesLink
	jr nc, jr_007_769b

	ld a, [wItemUsePoseTimer]
	and a
	jr nz, jr_007_769b

	ld a, [wItemB]
	cp $03
	jr nz, jr_007_7665

	ldh a, [hJoypadPressed]
	and $20
	jr nz, jr_007_7672

	jr jr_007_769b

jr_007_7665:
	ld a, [wItemA]
	cp $03
	jr nz, jr_007_769b

	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_007_769b

jr_007_7672:
	ld a, [wLinkIsCarrying]
	and a
	jr nz, jr_007_769b

	inc a
	ld [wLinkIsCarrying], a
	call IncrementEntityState
	ld [hl], $02
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], $07
	ld hl, wEntityLiftStep
	add hl, bc
	ld [hl], b
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
	call GetEntityTimer
	ld [hl], $02
	ld hl, hWaveSfx
	ld [hl], $02

jr_007_769b:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20
	db $60, $00, $60, $20, $62, $00, $62, $20, $64, $00, $64, $20, $66, $00, $66, $20

Call_07_76BC::
	ld de, $769c
	ldh a, [hMapId]
	cp $03
	jr nz, jr_007_76c8

	ld de, $76ac

jr_007_76c8:
	call DrawEntity16x16
	call ReturnIfNonInteractive
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_76d9

	call ClearEntitySpeed

jr_007_76d9:
	call ApplyRecoilIfNeeded
	call EntityCheckHits
	call UpdateEntityPosWithSpeed
	call AddEntityZSpeedToPos
	call EntityCheckWalls
	ld hl, wEntitySpeedZ
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, wEntityZ
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_007_76fa

	and a
	jr nz, jr_007_7727

jr_007_76fa:
	ld [hl], b
	ldh a, [hActiveEntityState]
	cp $03
	jr nz, jr_007_7722

	ld hl, wEntitySpeedX
	add hl, bc
	sra [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sra [hl]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_007_7720

	ld [hl], b
	call ClearEntitySpeed
	jr jr_007_7727

jr_007_7720:
	jr jr_007_7727

jr_007_7722:
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], b

jr_007_7727:
	ldh a, [hActiveEntityState]
	cp $04
	jr c, jr_007_772e

	ret


jr_007_772e:
	rst $00

JumpTable_07_772F::
	dw Jump_07_773F
	dw Jump_07_777B
	dw Jump_07_77C0
	dw Jump_07_7809

	db $06, $fa, $00, $00, $00, $00, $fa, $06

Jump_07_773F::
	call ClearEntitySpeed
	call GetEntityTimer
	jr nz, jr_007_7779

	call GetRandomByte
	and $1f
	add $30
	ld [hl], a
	call IncrementEntityState
	call GetRandomByte
	and $06
	jr nz, jr_007_775e

	call GetEntityDirectionToLink
	jr jr_007_7764

jr_007_775e:
	call GetRandomByte
	and $03
	ld e, a

jr_007_7764:
	ld d, b
	ld hl, $7737
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $773b
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_007_7779:
	jr jr_007_7789

Jump_07_777B::
	call GetEntityTimer
	jr nz, jr_007_7786

	ld [hl], $18
	call IncrementEntityState
	ld [hl], b

jr_007_7786:
	call Call_07_77FD

jr_007_7789:
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $80
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $48
	call EntityLinkDiffX
	add $06
	cp $0a
	jr c, jr_007_77a7

	call EntityLinkDiffY
	add $06
	cp $0a
	jr nc, jr_007_77b7

jr_007_77a7:
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], e
	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $ff

jr_007_77b7:
	ret


	db $18, $e8, $00, $00, $00, $00, $e8, $18

Jump_07_77C0::
	call GetEntityTimer
	jr z, jr_007_77f9

	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $77b8
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	sub [hl]
	jr z, jr_007_77de

	and $80
	jr nz, jr_007_77dd

	inc [hl]
	inc [hl]

jr_007_77dd:
	dec [hl]

jr_007_77de:
	ld hl, $77bc
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	sub [hl]
	jr z, jr_007_77f1

	and $80
	jr nz, jr_007_77f0

	inc [hl]
	inc [hl]

jr_007_77f0:
	dec [hl]

jr_007_77f1:
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, Call_07_77FD

jr_007_77f9:
	call IncrementEntityState
	ld [hl], b

Call_07_77FD::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_07_7809::
	ld hl, wEntityOptions1
	add hl, bc
	ld [hl], $08
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld [hl], $00
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	inc a
	inc a
	call SetEntitySpriteVariant
	call GetEntityTimer
	jr nz, jr_007_7837

	call IncrementEntityState
	ld [hl], b
	ld hl, wEntitySpeedZ
	add hl, bc
	ld [hl], $18
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
	ret


jr_007_7837:
	cp $60
	jr nc, jr_007_7848

	and $04
	ld a, $08
	jr nz, jr_007_7843

	ld a, $f8

jr_007_7843:
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a

jr_007_7848:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	call EntityCheckWalls
	pop af
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], a
	ret


	db $06, $04, $02, $00

Call_07_785E::
	ldh a, [hMapId]
	cp $15
	jr nz, jr_007_786c

	ld a, [wIsBowWowFollowingLink]
	cp $80
	jp nz, ClearEntityStatus

jr_007_786c:
	call Call_07_79D5
	call ReturnIfNonInteractive
	ldh a, [hMapId]
	cp $15
	jr z, jr_007_7880

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7883

jr_007_7880:
	call Call_07_7975

jr_007_7883:
	call ApplyRecoilIfNeeded
	call EntityCheckSwordClash
	call EntityCheckHits
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_07_788F::
	dw Jump_07_789D
	dw Jump_07_78D2
	dw Jump_07_78F5

	db $06, $fa, $00, $00, $00, $00, $fa, $06

Jump_07_789D::
	call EntityCheckWalls
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld [hl], $00
	call Call_07_794D
	call GetEntityTimer
	jr nz, jr_007_78d1

	ld [hl], $80
	call IncrementEntityState

Call_07_78B3::
	ld hl, wEntityDirection
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7895
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], a
	ld hl, $7899
	add hl, de
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], a

jr_007_78d1:
	ret


Jump_07_78D2::
	call Call_07_794D
	ld hl, wEntityCollisions
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_78e0

	call Call_07_78B3

jr_007_78e0:
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	call UpdateWalkFrame
	call GetEntityTimer
	jr nz, jr_007_78f4

	ld [hl], $30

Call_07_78F0::
	call IncrementEntityState
	ld [hl], b

jr_007_78f4:
	ret


Jump_07_78F5::
	call GetEntityTimer1
	jr z, jr_007_7917

	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_007_7917

	ldh a, [hMapId]
	cp $15
	jr nz, jr_007_7917

	ld hl, wEntityPrivate3
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_793d

	inc [hl]
	ld a, $90
	call OpenDialogTable1
	jr jr_007_793d

jr_007_7917:
	ld a, [hl]
	and a
	jr nz, jr_007_793d

	call GetEntityTimer
	jr nz, jr_007_7925

	ld [hl], $18
	call Call_07_78F0

jr_007_7925:
	call UpdateWalkFrame
	call UpdateWalkFrame
	call UpdateEntityPosWithSpeed
	call EntityCheckWalls
	ldh a, [hFrameCounter]
	xor c
	and $0f
	jr nz, jr_007_7948

	ld a, $0a
	call SetEntitySpeedTowardsLink

jr_007_793d:
	call GetEntityDirectionToLink
	ld hl, wEntityDirection
	add hl, bc
	ld [hl], a
	call UpdateWalkFrame

jr_007_7948:
	ret


	db $01, $00, $03, $02

Call_07_794D::
	ld a, [wClinkTimer]
	and a
	jr nz, Call_07_7975

	call EntityLinkDiffX
	add $30
	cp $60
	jr nc, jr_007_798c

	call EntityLinkDiffY
	add $30
	cp $60
	jr nc, jr_007_798c

	call GetEntityDirectionToLink
	ld d, b
	ld hl, $7949
	add hl, de
	ld a, [hl]
	ld hl, wEntityDirection
	add hl, bc
	cp [hl]
	jr z, jr_007_798c

Call_07_7975::
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	cp $02
	jr z, jr_007_7985

	push hl
	call GetEntityTimer1
	ld [hl], $10
	pop hl

jr_007_7985:
	ld [hl], $02
	call GetEntityTimer
	ld [hl], $80

jr_007_798c:
	ret


	db $00, $00, $f9, $f9, $f8, $f2, $08, $0e, $08, $0e, $f8, $f2, $00, $00, $00, $00
	db $02, $02, $06, $06, $04, $04, $00, $00, $0c, $0c, $04, $04, $fc, $fc, $14, $14
	db $14, $14, $fc, $fc, $0c, $0c, $0c, $0c, $60, $00, $62, $00, $62, $20, $60, $20
	db $64, $00, $66, $00, $66, $20, $64, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_07_79D5::
	call SkipDrawIfOffscreen
	ldh a, [hActiveEntitySpriteVariant]
	cp $02
	jr nc, jr_007_79e1

	call Call_07_7A39

jr_007_79e1:
	push bc
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose1], a
	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $79a5
	add hl, de
	ld a, [hl]
	ld [wClashBoxX], a
	ld hl, $79ad
	add hl, de
	ld a, [hl]
	ld [wClashBoxY], a
	ld a, $02
	ld [wClashBoxHalfWidth], a
	ld [wClashBoxHalfHeight], a
	ld hl, $799d
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose2], a
	ld hl, $7995
	add hl, de
	ld a, [hl]
	ld hl, $798d
	add hl, de
	ld l, [hl]
	ld h, a
	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop bc
	xor a
	ldh [hMultiPurpose3], a
	pop hl
	call DrawSpritePair
	pop bc
	ld a, $02
	call ReserveOAMEntriesFar
	ld de, $79b5
	call DrawEntity16x16
	ret


Call_07_7A39::
	xor $01
	push af
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld de, $c030
	add hl, de
	pop de
	ldh a, [hActiveEntityDrawY]
	add d
	add $04
	ld [hli], a
	ldh a, [hActiveEntityX]
	add $fe
	ld [hli], a
	ld a, $86
	ld [hli], a
	ld [hl], $10
	ld a, $01
	call ReserveOAMEntriesFar
	ret


	db $82, $10, $86, $10, $88, $10, $8a, $10, $8c, $10, $98, $10, $90, $10, $92, $10
	db $96, $10, $8e, $10, $80, $10, $84, $10, $94, $10, $9a, $10, $ae, $10, $9c, $10
	db $a0, $10, $c0, $10, $c2, $10, $c4, $10, $c6, $10, $ca, $10, $c0, $10, $c2, $10
	db $c4, $10, $c6, $10, $ca, $10, $a6, $10, $a6, $10, $a6, $10, $a6, $10, $a6, $10
	db $9e, $10, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d
	db $9e, $9f, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ac, $ab, $ad
	db $ae, $ae, $ef, $06, $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $01, $10
	db $10, $10, $10, $10, $01, $10, $10, $10, $10, $10, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $00

Call_07_7AE3::
	ld a, $02
	ldh [hLinkInteractiveMotionBlocked], a
	xor a
	ld [wSwordAnimationState], a
	ld [wSwordAnimationStatePrev], a
	ldh a, [hActiveEntitySpriteVariant]
	cp $22
	jr nz, jr_007_7b2f

	ld a, $1b
	call SpawnEntity
	jp c, ClearEntityStatus

	ldh a, [hMultiPurpose0]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ldh a, [hMultiPurpose1]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $18
	ld hl, wEntityZ
	add hl, de
	ld [hl], $06
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $50
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $08
	ld hl, wEntityState
	add hl, de
	ld [hl], $03
	ld a, $1d
	ldh [hJingle], a
	jp ClearEntityStatus


jr_007_7b2f:
	cp $21
	jr z, jr_007_7b39

	ld de, $7a5d
	call DrawEntity8x16

jr_007_7b39:
	ld a, [wDialogState]
	and a
	jp nz, Jump_007_7bcf

	call UpdateEntityPosWithSpeed
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $10
	jr nz, jr_007_7b54

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $00

jr_007_7b54:
	cp $08
	jr nz, jr_007_7b71

	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	ld hl, $7ac1
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_007_7b71

	cp $01
	jr nz, jr_007_7b6e

	ld a, $01
	ldh [hJingle], a
	jr jr_007_7b71

jr_007_7b6e:
	ld [wMusicTrackToPlay], a

jr_007_7b71:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	cp $26
	jr nz, jr_007_7bc8

	ldh a, [hActiveEntitySpriteVariant]
	ld e, a
	ld d, b
	cp $21
	jr nz, jr_007_7b8f

	ldh a, [hMapRoom]
	cp $96
	jr nz, jr_007_7b8f

	ld a, $11
	call OpenDialogTable1
	jr jr_007_7bc7

jr_007_7b8f:
	ld a, e
	cp $01
	jr nz, jr_007_7b9f

	ld a, [wShieldLevel]
	cp $02
	jr nz, jr_007_7b9f

	ld a, $ed
	jr jr_007_7bc4

jr_007_7b9f:
	ld a, e
	cp $0b
	jr nz, jr_007_7baf

	ld a, [wSwordLevel]
	cp $02
	jr nz, jr_007_7baf

	ld a, $9f
	jr jr_007_7bc4

jr_007_7baf:
	ld a, e
	cp $00
	jr nz, jr_007_7bbf

	ld a, [wPowerBraceletLevel]
	cp $02
	jr nz, jr_007_7bbf

	ld a, $ee
	jr jr_007_7bc4

jr_007_7bbf:
	ld hl, $7a9f
	add hl, de
	ld a, [hl]

jr_007_7bc4:
	call OpenDialog

jr_007_7bc7:
	xor a

jr_007_7bc8:
	cp $28
	jr nz, jr_007_7bcf

	call ClearEntityStatus

Jump_007_7bcf:
jr_007_7bcf:
	ret


PushLinkOutOfEntity::
	call EntityTouchesLink
	jr nc, jr_007_7bf4

	call RestoreLinkPosition
	call ResetPegasusBoots
	ld a, [wHookshotChainSlot]
	and a
	jr z, jr_007_7bf2

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_007_7bf2

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_007_7bf2:
	scf
	ret


jr_007_7bf4:
	and a
	ret


	db $06, $04, $02, $00

UpdateWalkFrame::
	ld hl, wEntityDirection
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7bf6
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
	ld hl, $c14f
	or [hl]
;> busy |= wLinkInAir | mem[0xC134]
	ld hl, $c146
	or [hl]
	ld hl, $c134
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
;> if wDialogState or mem[0xC1A8] or wInventoryAppearing:
	ld a, [wDialogState]
	ld hl, wLinkShowItemPoseActive
	or [hl]
	ld hl, $c14f
	or [hl]
;>     return_from_caller()
	jr nz, .exitCaller
;> if wRoomTransitionState:
	ld a, [$c124]
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
;> Call_3EB8()                   # trail effect for entities that leave one
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
;> return Call_3F7A(slot)             # removed like a killed enemy
	jp Call_3F7A

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
