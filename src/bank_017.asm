; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $017", ROMX[$4000], BANK[$17]

;@ path: ending/memories
;@ The order in which DissolveIslandTilesStep erases the 64 pixels of a tile: 64 bytes, a shuffled list
;@ of 0-63 (each value once). Bits 3-5 = pixel row (0-7), bits 0-2 = pixel column (0 = leftmost);
;@ entry n is the pixel cleared in step n.
DissolvePixelOrder::
	db $18, $05, $37, $20, $36, $0e, $1e, $2b, $25, $14, $1f, $12, $15, $2c, $31, $3f
	db $0c, $30, $01, $33, $04, $27, $08, $1d, $38, $17, $3e, $28, $11, $00, $3a, $3d
	db $2a, $0b, $1b, $0a, $34, $07, $22, $0f, $1c, $23, $2f, $3b, $2d, $16, $3c, $32
	db $10, $29, $02, $2e, $0d, $19, $09, $26, $24, $06, $13, $21, $1a, $03, $39, $35
;@ path: ending/memories
;@ AND masks that clear one pixel of a tile row: 8 bytes, entry n clears pixel column n (bit 7 - n) in
;@ both bit planes, which turns that pixel into color 0. Read by DissolveIslandTilesStep.
DissolvePixelMasks::
	db $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe

;@ path: ending/memories
;@ The 12 background tiles that DissolveIslandTilesStep erases, as VRAM addresses (12 words). In the
;@ signed $8800 tile numbering of the background these are tiles $15, $06-$0A, $1F and $16-$1A: the
;@ island drawn by the last memory scene (screen layout $01 with tile set $1E).
DissolveTilePointers::
	dw $9150, $9060, $9070, $9080, $9090, $90a0
	dw $91f0, $9160, $9170, $9180, $9190, $91a0

;@ def DissolveIslandTilesStep()
;@ path: ending/memories
;@ One step of the island dissolving away: run by the VBlank handler when hBGChangeRequest is $0E
;@ (requested every 4 frames by MemoryDissolveIsland). Step wSceneVarB (0-63) picks one pixel from
;@ DissolvePixelOrder and clears it in each of the 12 island tiles; after 64 steps they are blank.
DissolveIslandTilesStep::
;> pixel = DissolvePixelOrder[wSceneVarB]
	ld a, [wSceneVarB]
	ld e, a
	ld d, $00
	ld hl, DissolvePixelOrder
	add hl, de
	ld a, [hl]
;> row = (pixel >> 3) * 2               # byte offset of that pixel row in a tile (2 bytes per row)
	rra
	rra
	and $0e
	ld b, a
;> mask = DissolvePixelMasks[pixel & 7]
	ld a, [hl]
	and $07
	ld e, a
	ld hl, DissolvePixelMasks
	add hl, de
	ld c, [hl]
;>@tile for i in range(12):
	xor a
	ld d, a

.tileLoop
;>     hMultiPurpose2 = i
	ldh [hMultiPurpose2], a
;>     tile = mem16[DissolveTilePointers + i * 2]
	sla a
	ld e, a
	ld hl, DissolveTilePointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
;>     addr = tile + row
	add b
	ld l, a
;>     mem[addr] &= mask                # bit plane 0
	ld a, [hl]
	and c
	ld [hli], a
;>     mem[addr + 1] &= mask            # bit plane 1
	ld a, [hl]
	and c
	ld [hl], a
;=@tile
	ldh a, [hMultiPurpose2]
	inc a
	cp $0c
	jr nz, .tileLoop

;> hBGChangeRequest = 0                 # request done
	xor a
	ldh [hBGChangeRequest], a
;> return
	ret


;@ path: ending/roll
;@ The role titles of the credits roll: 12 texts of 18 ASCII characters (upper-case letters and
;@ spaces), indexed by wCreditsRole and drawn as sprites by DrawCreditsRole. Title 11 is blank (shown
;@ with THE END).
CreditsRoleTitles::
	db "     DIRECTOR     "   ; 0
	db " DUNGEON DESIGNER "   ; 1
	db "  SCRIPT WRITER   "   ; 2
	db "    PROGRAMMER    "   ; 3
	db "CHARACTER DESIGNER"   ; 4
	db "  SOUND COMPOSER  "   ; 5
	db "   ILLUSTRATOR    "   ; 6
	db " SPECIAL THANKS TO"   ; 7
	db "     PRODUCER     "   ; 8
	db "EXECUTIVE PRODUCER"   ; 9
	db "  ENGLISH SCRIPT  "   ; 10
	db "                  "   ; 11

;@ path: ending/roll
;@ The names of the credits roll: 22 texts of 18 ASCII characters, indexed by wCreditsName and drawn as
;@ two rows of sprites by DrawCreditsName. Name 13 (KEIZO KATO) is not used by CreditsEntryNames;
;@ name 21 is the closing THE END, the only text drawn with all 18 characters side by side.
CreditsNames::
	db "  TAKASHI TEZUKA  "   ; 0
	db " YASUHISA YAMAMURA"   ; 1
	db "  KENSUKE TANABE  "   ; 2
	db " YOSHIAKI KOIZUMI "   ; 3
	db "  KAZUAKI MORITA  "   ; 4
	db "TAKAMITSU KUZUHARA"   ; 5
	db "  MASANAO ARIMOTO "   ; 6
	db "  SHIGEFUMI HINO  "   ; 7
	db "   KAZUMI TOTAKA  "   ; 8
	db "   MINAKO HAMANO  "   ; 9
	db "  KOZUE ISHIKAWA  "   ; 10
	db "  YOUICHI KOTABE  "   ; 11
	db " TOSHIHIKO NAKAGO "   ; 12
	db "    KEIZO KATO    "   ; 13
	db "    KOJI KONDO    "   ; 14
	db "  TOMOAKI KUROUME "   ; 15
	db " SHIGERU MIYAMOTO "   ; 16
	db " HIROSHI YAMAUCHI "   ; 17
	db "     DAN OWSEN    "   ; 18
	db " MASAICHI OKUMURA "   ; 19
	db "    KANAE WADA    "   ; 20
	db "THE  END          "   ; 21

;@ def CreditsRoll()
;@ path: ending/roll
;@ The staff credits over the last scene (credits subtype 8), once per frame after a first wait of
;@ wSceneSlowTimer: draws the current role title and name as sprites and runs the roll's steps
;@ (pick an entry, fade it in, show it, fade it out; at the end THE END and a last bird).
CreditsRoll::
;> if wSceneSlowTimer:
	ld a, [wSceneSlowTimer]
	and a
;>     return                           # still the quiet start of the scene
	ret nz

;> DrawCreditsRole()
	call DrawCreditsRole
;> DrawCreditsName()
	call DrawCreditsName
;> CreditsRollSteps[wCreditsRollStep]()
	ld a, [wCreditsRollStep]
	rst $00

;@ path: ending/roll
;@ The steps of the credits roll (6 words), indexed by wCreditsRollStep.
CreditsRollSteps::
	dw CreditsRollPickEntry
	dw CreditsRollFadeIn
	dw CreditsRollWait
	dw CreditsRollFadeOut
	dw CreditsRollSendBird
	dw CreditsRollDone

;@ path: ending/roll
;@ The role title of each credits entry: 21 bytes, entry n (wSceneFadeStep during the roll) shows role
;@ title CreditsRoleTitles[CreditsEntryRoles[n]] together with name CreditsEntryNames[n].
;@ Entries: 0 director, 1 dungeon designer, 2-3 script writers, 4-5 programmers, 6-7 character
;@ designers, 8-10 sound composers, 11 illustrator, 12 English script, 13-17 special thanks,
;@ 18 producer, 19 executive producer, 20 blank title (THE END).
CreditsEntryRoles::
	db $00, $01, $02, $02, $03, $03, $04, $04, $05, $05, $05, $06, $0a, $07, $07, $07
	db $07, $07, $08, $09, $0b

;@ path: ending/roll
;@ The name of each credits entry: 21 bytes, indexes into CreditsNames (see CreditsEntryRoles).
CreditsEntryNames::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a
	db $0b, $12, $0c, $0e, $0f, $13, $14, $10, $11, $15

;@ def CreditsRollPickEntry()
;@ path: ending/roll
;@ Credits roll step 0: once wSceneTimer3 has run out, takes entry wSceneFadeStep: its role title and
;@ name. wSceneVar5 notes whether the title is the one already shown.
CreditsRollPickEntry::
;> if wSceneTimer3:
	ld a, [wSceneTimer3]
	and a
;>     return
	ret nz

;> same = 0
	ld c, $00
;> entry = wSceneFadeStep
	ld a, [wSceneFadeStep]
	ld e, a
	ld d, $00
;> if CreditsEntryRoles[entry] == wCreditsRole:
	ld hl, CreditsEntryRoles
	add hl, de
	ld a, [wCreditsRole]
	cp [hl]
	jr nz, .store

;>     same = 1
	inc c

;> wSceneVar5 = same
.store
	ld a, c
	ld [wSceneVar5], a
;> wCreditsRole = CreditsEntryRoles[entry]
	ld a, [hl]
	ld [wCreditsRole], a
;> wCreditsName = CreditsEntryNames[entry]
	ld hl, CreditsEntryNames
	add hl, de
	ld a, [hl]
	ld [wCreditsName], a
;> wEntityWorkRAM = 0                   # fade step
	xor a
	ld [wEntityWorkRAM], a
;> CreditsRollNextStep()
	jp CreditsRollNextStep


;@ path: ending/roll
;@ Sprite palette 1 fading in from white for the credits text: 16 bytes, 4 levels of 4 equal values
;@ ($00, $04, $19, $1E). The fades read entry step + (frame & 3) with step 0-12, so neighbouring levels
;@ alternate from frame to frame for an in-between shade.
CreditsFadeInPalettes::
	db $00, $00, $00, $00, $04, $04, $04, $04, $19, $19, $19, $19, $1e, $1e, $1e, $1e
;@ path: ending/roll
;@ Sprite palette 1 fading in from black for THE END (entry 20): 16 bytes, levels $FF, $AF, $5A, $1E,
;@ read like CreditsFadeInPalettes.
TheEndFadeInPalettes::
	db $ff, $ff, $ff, $ff, $af, $af, $af, $af, $5a, $5a, $5a, $5a, $1e, $1e, $1e, $1e
;@ path: ending/roll
;@ Sprite palette 1 fading the credits text out to white: 16 bytes, levels $1E, $19, $04, $00.
CreditsFadeOutPalettes::
	db $1e, $1e, $1e, $1e, $19, $19, $19, $19, $04, $04, $04, $04, $00, $00, $00, $00
;@ path: ending/roll
;@ Background (and sprite palette 1) fading to black after the last names (entries 19 and up):
;@ 16 bytes, levels $1E, $6F, $BF, $FF.
CreditsBGFadeOutPalettes::
	db $1e, $1e, $1e, $1e, $6f, $6f, $6f, $6f, $bf, $bf, $bf, $bf, $ff, $ff, $ff, $ff

;@ def CreditsRollFadeIn()
;@ path: ending/roll
;@ Credits roll step 1: fades the text in (sprite palette 1), one level every 8 frames over 12 steps.
;@ Then the entry stays for $7C frames; after THE END the roll goes on to step 4 (the last bird).
CreditsRollFadeIn::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wEntityWorkRAM += 1
	ld a, [wEntityWorkRAM]
	inc a
	ld [wEntityWorkRAM], a
;>     if wEntityWorkRAM == 12:
	cp $0c
	jr nz, .palette

;>         wSceneTimer3 = 0x7C          # how long the name stays
	ld a, $7c
	ld [wSceneTimer3], a
;>         CreditsRollNextStep()
	call CreditsRollNextStep
;>         if wSceneFadeStep == 20:
	ld a, [wSceneFadeStep]
	cp $14
	jr nz, .palette

;>             wCreditsRollStep = 4     # THE END stays: send the bird instead
	ld [hl], $04

;> i = wEntityWorkRAM + (hFrameCounter & 3)
.palette
	ld a, [wEntityWorkRAM]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;> fade = CreditsFadeInPalettes
	ld d, $00
	ld hl, CreditsFadeInPalettes
;> if wSceneFadeStep == 20:
	ld a, [wSceneFadeStep]
	cp $14
	jr nz, .set

;>     fade = TheEndFadeInPalettes
	ld hl, TheEndFadeInPalettes

;> wOBJ1Palette = fade[i]
.set
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def CreditsRollWait()
;@ path: ending/roll
;@ Credits roll step 2: waits until wSceneTimer3 has run out, notes in wSceneVar5 whether the next
;@ entry keeps the same title, and goes on to the fade-out.
CreditsRollWait::
;> if wSceneTimer3:
	ld a, [wSceneTimer3]
	and a
;>     return
	ret nz

;> same = 0
	ld c, $00
;> next = wSceneFadeStep + 1
	ld a, [wSceneFadeStep]
	inc a
	ld e, a
	ld d, $00
;> if CreditsEntryRoles[next] == wCreditsRole:
	ld hl, CreditsEntryRoles
	add hl, de
	ld a, [wCreditsRole]
	cp [hl]
	jr nz, .store

;>     same = 1
	inc c

;> wSceneVar5 = same
.store
	ld a, c
	ld [wSceneVar5], a
;> wEntityWorkRAM = 0
	xor a
	ld [wEntityWorkRAM], a
;> return CreditsRollNextStep()          # falls through

;@ def CreditsRollNextStep() -> hl
;@ path: ending/roll
;@ Advances the credits roll to its next step; returns hl = the address of wCreditsRollStep.
CreditsRollNextStep::
;> wCreditsRollStep += 1
	ld hl, wCreditsRollStep
	inc [hl]
;> return addr(wCreditsRollStep)
	ret


;@ def CreditsRollFadeOut()
;@ path: ending/roll
;@ Credits roll step 3: fades the text out to white, one level every 8 frames over 12 steps; from entry
;@ 19 on the background fades to black at the same time. Then the next entry follows after $10 frames
;@ ($80 after the last names).
CreditsRollFadeOut::
;> entry = wSceneFadeStep
	ld a, [wSceneFadeStep]
	ldh [hMultiPurposeD], a
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wEntityWorkRAM += 1
	ld a, [wEntityWorkRAM]
	inc a
	ld [wEntityWorkRAM], a
;>     if wEntityWorkRAM == 12:
	cp $0c
	jr nz, .palette

;>         timer = 0x80 if entry >= 19 else 0x10
	ldh a, [hMultiPurposeD]
	cp $13
	ld a, $10
	jr c, .setTimer

	ld a, $80

;>         wSceneTimer3 = timer         # pause before the next entry
.setTimer
	ld [wSceneTimer3], a
;>         wCreditsRollStep = 0
	ld a, $00
	ld [wCreditsRollStep], a
;>         wSceneFadeStep += 1          # next entry
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a

;> i = wEntityWorkRAM + (hFrameCounter & 3)
.palette
	ld a, [wEntityWorkRAM]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;> wOBJ1Palette = CreditsFadeOutPalettes[i]
	ld d, $00
	ld hl, CreditsFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> if entry >= 19:
	ldh a, [hMultiPurposeD]
	cp $13
	jr c, .done

;>     wBGPalette = CreditsBGFadeOutPalettes[i]     # the last names take the picture with them
	ld hl, CreditsBGFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;>     wOBJ1Palette = CreditsBGFadeOutPalettes[i]
	ld [wOBJ1Palette], a

;> return
.done
	ret


;@ def CreditsRollSendBird()
;@ path: ending/roll
;@ Credits roll step 4 (after THE END has faded in): spawns one more ending object (entity $E8, part
;@ $10: the bird that crosses the screen at the very end, see EndingLastBird) just off the left edge
;@ (x $E0, y $10), flying to the right.
CreditsRollSendBird::
;> slot = SpawnEntity(0xE8)               # spawn an ending object
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0xE0
	ld hl, wEntityX
	add hl, de
	ld [hl], $e0
;> wEntityY[slot] = 0x10
	ld hl, wEntityY
	add hl, de
	ld [hl], $10
;> wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $08
;> wEntitySpeedY[slot] = 8
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $08
;> wEntityPrivate1[slot] = 0x10        # ending object part $10
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $10
;> CreditsRollNextStep()
	jp CreditsRollNextStep


;@ def CreditsRollDone()
;@ path: ending/roll
;@ Credits roll step 5: nothing more to do; THE END stays on screen.
CreditsRollDone::
;> return
	ret


;@ path: ending/roll
;@ Sprite tile of each letter of a role title: 26 bytes for A-Z (entry = character - 'A'), read by
;@ DrawCreditsRole. 0 for the letters no title uses (B, F, J, Q, X, Y, Z); a space is tile $0F.
CreditsTitleLetterTiles::
	db $40, $00, $41, $42, $43, $00, $44, $45, $46, $00, $47, $48, $49, $4a, $4b, $50
	db $00, $51, $52, $53, $54, $55, $2f, $3f, $00, $00

;@ def DrawCreditsRole()
;@ path: ending/roll
;@ Draws the role title of the credits roll (CreditsRoleTitles[wCreditsRole]) as a row of 8x8 sprites
;@ at y $40, OAM entries 12-20. Only 9 of its 18 letters fit the sprite budget of a line, so even
;@ frames draw the even letters and odd frames the odd ones (x $10 / $18, every 16 pixels): the title
;@ flickers into one line of 8-pixel letters.
;@ test: wCreditsRole = rand(0, 11)
DrawCreditsRole::
;> if wCreditsRole == 0xFF:
	ld a, [wCreditsRole]
	cp $ff
;>     return                           # no entry yet
	ret z

;> offset = wCreditsRole * 2
	rla
	and $fe
	ld e, a
;> offset += wCreditsRole * 16         # 18 characters per title
	rla
	rla
	rla
	and $f0
	add e
	ld e, a
;> text = CreditsRoleTitles + offset
	ld d, $00
	ld hl, CreditsRoleTitles
	add hl, de
;> oam = addr(wOAMBuffer) + 0x30
	ld de, wOAMBuffer + $30
;> x = 0x10
	ldh a, [hFrameCounter]
	and $01
	ld a, $10
	jr z, .even

;> if hFrameCounter & 1:
;>     text += 1                        # odd frame: the odd letters
	inc hl
;>     x = 0x18
	ld a, $18

;>@char for n in range(9):
.even
	ldh [hMultiPurpose0], a
	ld c, $09

.loop
;>     mem[oam] = 0x40                  # y
	ld a, $40
	ld [de], a
	inc de
;>     mem[oam + 1] = x
	ldh a, [hMultiPurpose0]
	ld [de], a
	inc de
;>     x += 0x10
	add $10
	ldh [hMultiPurpose0], a
;>     ch = mem[text]
;>     text += 2
	ld a, [hli]
	inc hl
;>     if ch == 0x20:                   # space
	push hl
	push de
	cp $20
	jr nz, .letter

;>         tile = 0x0F
	ld a, $0f
	jr .store

;>     else:
;>         tile = CreditsTitleLetterTiles[ch - 0x41]
.letter
	sub $41
	ld e, a
	ld d, $00
	ld hl, CreditsTitleLetterTiles
	add hl, de
	ld a, [hl]

;>     mem[oam + 2] = tile
.store
	pop de
	pop hl
	ld [de], a
	inc de
;>     mem[oam + 3] = 0x10              # sprite palette 1
;>     oam += 4
	ld a, $10
	ld [de], a
	inc de
;=@char
	dec c
	jr nz, .loop

;> return
	ret


;@ path: ending/roll
;@ Sprite tiles of the tall letters of the credits names: 52 bytes, two per letter A-Z (entry =
;@ (character - 'A') * 2 + half, half 0 = upper tile, 1 = lower tile), read by DrawCreditsNameRow.
;@ 0 for letters no name uses (L, Q, V, X). Several halves reuse a tile mirrored by CreditsNameLetterAttrs.
CreditsNameLetterTiles::
	db $20, $30, $21, $31, $22, $22, $23, $33, $24, $34, $24, $35, $22, $32, $36, $30
	db $27, $27, $28, $38, $29, $39, $00, $00, $2a, $3a, $2b, $3b, $20, $20, $21, $35
	db $00, $00, $21, $26, $2c, $3c, $2d, $3d, $36, $20, $00, $00, $2e, $3e, $00, $00
	db $36, $25, $37, $37

;@ path: ending/roll
;@ OAM attributes of the letter halves in CreditsNameLetterTiles (same 52 entries): $10 = sprite
;@ palette 1, $50 = palette 1 flipped upside down, $70 = palette 1 flipped both ways.
CreditsNameLetterAttrs::
	db $10, $10, $10, $10, $10, $50, $10, $10, $10, $10, $10, $10
	db $10, $10, $50, $10, $10, $50, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $50, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $50, $50, $10, $10
	db $10, $10, $10, $10, $50, $10, $10, $70

;@ def DrawCreditsName()
;@ path: ending/roll
;@ Draws the name of the credits roll (CreditsNames[wCreditsName]) in tall letters: the upper halves as
;@ sprites at y $55 (OAM from entry 21), the lower halves at y $5D (OAM from entry 30).
;@ test: wCreditsName = rand(0, 21)
DrawCreditsName::
;> double = wCreditsName * 2
	ld a, [wCreditsName]
	rla
	and $fe
	ld e, a
	ld d, $00
;> offset = wCreditsName * 16           # shifted on into d
	rla
	rl d
	rla
	rl d
	rla
	rl d
;> offset += double                     # 18 characters per name
	and $f0
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
;> text = CreditsNames + offset
	ld hl, CreditsNames
	add hl, de
;> hMultiPurpose1 = 0                   # upper halves
	push hl
	xor a
	ldh [hMultiPurpose1], a
;> DrawCreditsNameRow(text, addr(wOAMBuffer) + 0x54, 0x55)
	ld de, wOAMBuffer + $54
	ld a, $55
	call DrawCreditsNameRow
;> hMultiPurpose1 = 1                   # lower halves
	ld hl, hMultiPurpose1
	inc [hl]
	pop hl
;> DrawCreditsNameRow(text, addr(wOAMBuffer) + 0x78, 0x5D)
	ld de, wOAMBuffer + $78
	ld a, $5d

;@ def DrawCreditsNameRow(text: hl, oam: de, y: a)
;@ path: ending/roll
;@ Draws one row of a credits name (half hMultiPurpose1 of each letter) at height y into OAM from oam.
;@ Normal names flicker like the role titles: 9 sprites, even letters on even frames and odd letters
;@ on odd frames, 16 pixels apart. THE END (name 21) is drawn with all 18 letters 8 pixels apart from
;@ x $38; its upper row then runs into the OAM entries of the lower row, which overwrites the second
;@ half (only spaces there).
;@ test: wCreditsName = rand(0, 21); hMultiPurpose1 = rand(0, 1); text = 0x4171 + wCreditsName * 18; oam = 0xC054
DrawCreditsNameRow::
;> hMultiPurposeH = y
	ldh [hMultiPurposeH], a
;> count = 18
;> step = 8
	ld c, $12
	ld b, $08
;> x = 0x38
	ld a, [wCreditsName]
	cp $15
	ld a, $38
;> if wCreditsName != 21:               # a normal name: half the letters per frame
	jr z, .start

;>     count = 9
	ld c, $09
;>     step = 0x10
	ld b, $10
;>     x = 0x10
	ldh a, [hFrameCounter]
	and $01
	ld a, $10
	jr z, .start

;>     if hFrameCounter & 1:
;>         text += 1
	inc hl
;>         x = 0x18
	ld a, $18

;>@char for n in range(count):
.start
	ldh [hMultiPurpose0], a

.loop
;>     mem[oam] = hMultiPurposeH        # y
	ldh a, [hMultiPurposeH]
	ld [de], a
	inc de
;>     mem[oam + 1] = x
	ldh a, [hMultiPurpose0]
	ld [de], a
	inc de
;>     x += step
	add b
	ldh [hMultiPurpose0], a
;>     ch = mem[text]
;>     text += 1 if wCreditsName == 21 else 2
	ld a, [wCreditsName]
	cp $15
	ld a, [hli]
	jr z, .next

	inc hl

;>     if ch == 0x20:                   # space: blank tile, the attributes of the previous letter
.next
	push hl
	push de
	cp $20
	jr nz, .letter

;>         tile = 0x0F
	ld a, $0f
	jr .store

;>     else:
;>         i = (ch - 0x41) * 2 + hMultiPurpose1
.letter
	sub $41
	sla a
	ld hl, hMultiPurpose1
	add [hl]
	ld e, a
	ld d, $00
;>         hBGTilesRequestCopy = CreditsNameLetterAttrs[i]     # (used as scratch here)
	ld hl, CreditsNameLetterAttrs
	add hl, de
	ld a, [hl]
	ldh [hBGTilesRequestCopy], a
;>         tile = CreditsNameLetterTiles[i]
	ld hl, CreditsNameLetterTiles
	add hl, de
	ld a, [hl]

;>     mem[oam + 2] = tile
.store
	pop de
	pop hl
	ld [de], a
	inc de
;>     mem[oam + 3] = hBGTilesRequestCopy
;>     oam += 4
	ldh a, [hBGTilesRequestCopy]
	ld [de], a
	inc de
;=@char
	dec c
	jr nz, .loop

;> return
	ret


;@ def PlaySeaSounds()
;@ path: ending/sea
;@ The sounds of the open sea in the sea scenes: the waves (noise $0F) every $C0 frames and a seagull's
;@ cry (square $21) at random intervals of 80-207 frames.
PlaySeaSounds::
;> wSeaWavesSoundTimer += 1
	ld a, [wSeaWavesSoundTimer]
	inc a
;> if wSeaWavesSoundTimer >= 0xC0:
	cp $c0
	jr c, .store

;>     hNoiseSfx = 0x0F                 # waves
	ld a, $0f
	ldh [hNoiseSfx], a
;>     wSeaWavesSoundTimer = 0
	xor a

.store
	ld [wSeaWavesSoundTimer], a
;> if wSeagullCryTimer == 0:
	ld a, [wSeagullCryTimer]
	and a
	jr nz, .count

;>     hJingle = 0x21                   # a seagull cries
	ld a, $21
	ldh [hJingle], a
;>     wSeagullCryTimer = (GetRandomByte() & 0x7F) + 0x50
	call GetRandomByte
	and $7f
	add $50
	ld [wSeagullCryTimer], a

;> wSeagullCryTimer -= 1
.count
	dec a
	ld [wSeagullCryTimer], a
;> return
	ret


;@ path: ending/sea
;@ Background tiles of the moving water row (21 bytes: tiles $92 and $93 alternating), read by
;@ AnimateWaterRows from the first or the second byte (20 tiles) to shift the pattern by one tile.
;@ asset: tilemap width=21 height=1 addressing=8800
WaterTilesLower::
	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93, $92

;@ path: ending/sea
;@ Background tiles of the water row above it (21 bytes: tiles $82 and $83 alternating), read like
;@ WaterTilesLower.
;@ asset: tilemap width=21 height=1 addressing=8800
WaterTilesUpper::
	db $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82
	db $83, $82, $83, $82, $83, $82, $83, $82, $83, $82

;@ def AnimateWaterRows(dest: de)
;@ path: ending/sea
;@ Animates two rows of water in the background: every 16 frames queues two background draw commands,
;@ 20 tiles of WaterTilesLower at the map address dest and 20 tiles of WaterTilesUpper on the row above,
;@ both shifted by one tile every other time so the waves roll.
AnimateWaterRows::
;> if hFrameCounter & 0x0F != 2:
	ldh a, [hFrameCounter]
	and $0f
	cp $02
;>     return
	jr nz, .done

;> wDrawCommand[0] = dest >> 8          # command 1: address, 20 tiles, data
	push de
	ld hl, wDrawCommand
	ld a, d
	ld [hli], a
;> wDrawCommand[1] = dest & 0xFF
	ld a, e
	ld [hli], a
;> wDrawCommand[2] = 0x13
	ld a, $13
	ld [hli], a
;> src = WaterTilesLower
	ld de, WaterTilesLower
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr z, .copy1

;>     src += 1
	inc de

;> copy(addr(wDrawCommand) + 3, src, 20)
.copy1
	ld c, $14

.loop1
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop1

;> wDrawCommand[23] = dest >> 8         # command 2: the row above
	pop de
	ld a, d
	ld [hli], a
;> wDrawCommand[24] = (dest & 0xFF) - 0x20
	ld a, e
	sub $20
	ld [hli], a
;> wDrawCommand[25] = 0x13
	ld a, $13
	ld [hli], a
;> src = WaterTilesUpper
	ld de, WaterTilesUpper
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr z, .copy2

;>     src += 1
	inc de

;> copy(addr(wDrawCommand) + 26, src, 20)
.copy2
	ld c, $14

.loop2
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop2

;> wDrawCommand[46] = 0                 # end of the commands
	ld [hl], c

.done
	ret


;@ path: ending/windfish
;@ Vertical screen offsets for the gentle up-and-down of the wave effect: 16 signed bytes (-12 to -8),
;@ one per 8 frames; WaveEffectFrame sets SCY to the value minus 5.
ScreenBobOffsets::
	db $f4, $f4, $f5, $f6, $f7, $f7, $f8, $f8, $f8, $f8, $f7, $f7, $f6, $f5, $f4, $f4

;@ def WaveEffectFrame()
;@ path: ending/windfish
;@ The wavy dream effect around the Wind Fish, run from the main loop while wTransitionGfx is $FF (or
;@ $FE: only the up-and-down). Sets this frame's vertical offset, then follows the first 80 scan
;@ lines one by one (busy-waiting for each HBlank) and shifts every line sideways (and a little up or
;@ down) along a sine wave from WaveLineOffsets, whose strength is wSceneVar5 ($00 strong ... $E0 weak).
;@ test: skip follows the LCD scan lines
WaveEffectFrame::
;> i = (hFrameCounter >> 3) & 0x0F
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	nop
	and $0f
;> base = u8(ScreenBobOffsets[i] - 5)
	ld e, a
	ld d, $00
	ld hl, ScreenBobOffsets
	add hl, de
	ld a, [hl]
	sub $05
;> rSCY = base
	ldh [rSCY], a
;> hBGTilesRequestCopy = base           # (used as scratch here)
	ldh [hBGTilesRequestCopy], a
;> if wTransitionGfx == 0xFE:
	ld a, [wTransitionGfx]
	cp $fe
;>     return
	ret z

;> wTransitionGfxFrameCount += 1        # phase of the wave
	ld a, [wTransitionGfxFrameCount]
	inc a
	ld [wTransitionGfxFrameCount], a
;> hMultiPurpose1 = wSceneVar5          # strength: picks a 32-byte row of WaveLineOffsets
	ld a, [wSceneVar5]
	ldh [hMultiPurpose1], a
;> wRasterLine = 0
;> wRasterDelay = 0
	ld hl, wRasterLine
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a

;>@line while True:
.nextLine
;>     wait_hblank()
	ldh a, [rSTAT]
	and $03
	jr nz, .nextLine

;>     wRasterDelay += 2 - (wRasterDelay & 1)      # a short pause (1 or 2 passes)
	ld d, $00

.delay
	ld a, [wRasterDelay]
	inc a
	ld [wRasterDelay], a
	and $01
	jr nz, .delay

;>     wRasterLine += 1
	ld a, [wRasterLine]
	add $01
	ld [wRasterLine], a
	ld a, [wRasterLine + 1]
	adc $00
	ld [wRasterLine + 1], a
;>     if wRasterLine & 0xFF == 0x50:
	ld a, [wRasterLine]
	cp $50
;>         break
	jp z, .done

;>     i = ((wRasterLine + wTransitionGfxFrameCount) & 0x1F) | hMultiPurpose1
	ld hl, wTransitionGfxFrameCount
	ld a, [wRasterLine]
	add [hl]
	and $1f
	ld hl, hMultiPurpose1
	or [hl]
;>     off = WaveLineOffsets[i]
	ld e, a
	ld hl, WaveLineOffsets
	add hl, de
	ld a, [hl]
;>     rSCX = (off + hBaseScrollX) & 0xFF
	push af
	ld hl, hBaseScrollX
	add [hl]
	ldh [rSCX], a
;>     rSCY = u8((((off ^ 0x80) - 0x80) >> 1) + hBGTilesRequestCopy)   # half the swing, signed
	pop af
	sra a
	ld hl, hBGTilesRequestCopy
	add [hl]
	ldh [rSCY], a
;=@line
	jp .nextLine


;> rSCX = 0                             # the rest of the screen stands still
.done
	xor a
	ldh [rSCX], a
;> return
	ret


;@ path: ending/windfish
;@ The sine waves of the wave effect: 256 signed bytes, 8 rows of 32 (one full wave over 32 scan
;@ lines). Row r (offset r * $20 = wSceneVar5) swings by about 15, 13, 11, 9, 7, 5, 3 and 1 pixels.
;@ Read by WaveEffectFrame with (line + phase) & $1F within the row.
WaveLineOffsets::
	db $00, $05, $09, $0c, $0d, $0e, $0e, $0f, $0f, $0f, $0e, $0e, $0d, $0c, $09, $05
	db $00, $fb, $f7, $f4, $f3, $f2, $f2, $f1, $f1, $f1, $f2, $f2, $f3, $f4, $f7, $fb
	db $00, $04, $07, $09, $0b, $0c, $0c, $0d, $0d, $0d, $0c, $0c, $0b, $09, $07, $04
	db $00, $fc, $f9, $f7, $f5, $f4, $f4, $f3, $f3, $f3, $f4, $f4, $f5, $f7, $f9, $fc
	db $00, $03, $05, $07, $08, $09, $0a, $0b, $0b, $0b, $0a, $09, $08, $07, $05, $03
	db $00, $fd, $fb, $f9, $f8, $f7, $f6, $f5, $f5, $f5, $f6, $f7, $f8, $f9, $fb, $fd
	db $00, $03, $05, $06, $07, $08, $08, $09, $09, $09, $08, $08, $07, $06, $05, $03
	db $00, $fd, $fb, $fa, $f9, $f8, $f8, $f7, $f7, $f7, $f8, $f8, $f9, $fa, $fb, $fd
	db $00, $02, $04, $05, $05, $06, $06, $07, $07, $07, $06, $06, $05, $05, $04, $02
	db $00, $fe, $fc, $fb, $fb, $fa, $fa, $f9, $f9, $f9, $fa, $fa, $fb, $fb, $fc, $fe
	db $00, $01, $02, $03, $03, $04, $04, $05, $05, $05, $04, $04, $03, $03, $02, $01
	db $00, $ff, $fe, $fd, $fd, $fc, $fc, $fb, $fb, $fb, $fc, $fc, $fd, $fd, $fe, $ff
	db $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $02, $02, $02, $01, $01, $01
	db $00, $ff, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff
	db $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00

;@ def CreditsHandler()
;@ path: ending/credits
;@ Game mode 1, the ending and the staff credits, once per frame (called from the mode dispatcher in
;@ bank 0). Counts down the scene timers and runs the current part of the ending (wGameplaySubtype).
;@ When the ROM byte at $0004 is not zero (a development switch; 0 in the released game), Up/Down
;@ restart the ending and Right/Left skip to the next scene.
CreditsHandler::
;> if hJoypadPressed & 0x0C and mem[0x0004]:     # debug: Up or Down
	ldh a, [hJoypadPressed]
	and $0c
	jr z, .noRestart

	ld a, [$0004]
	and a
	jr z, .noRestart

;>     wGameplaySubtype = 0             # start the ending again
	xor a
	ld [wGameplaySubtype], a

;> if hJoypadPressed & 0x03 and mem[0x0004]:     # debug: Right or Left
.noRestart
	ldh a, [hJoypadPressed]
	and $03
	jr z, .timers

	ld a, [$0004]
	and a
	jr z, .timers

;>     CreditsNextScene()
	call CreditsNextScene

;> if wSceneTimer:
.timers
	ld a, [wSceneTimer]
	and a
	jr z, .timer2

;>     wSceneTimer -= 1
	dec a
	ld [wSceneTimer], a

;> if wSceneTimer2:
.timer2
	ld a, [wSceneTimer2]
	and a
	jr z, .timer3

;>     wSceneTimer2 -= 1
	dec a
	ld [wSceneTimer2], a

;> if wSceneTimer3:
.timer3
	ld a, [wSceneTimer3]
	and a
	jr z, .slowTimer

;>     wSceneTimer3 -= 1
	dec a
	ld [wSceneTimer3], a

;> if hFrameCounter & 3 == 0 and wSceneSlowTimer:
.slowTimer
	ldh a, [hFrameCounter]
	and $03
	jr nz, .verySlowTimer

	ld a, [wSceneSlowTimer]
	and a
	jr z, .verySlowTimer

;>     wSceneSlowTimer -= 1
	dec a
	ld [wSceneSlowTimer], a

;> if hFrameCounter & 0x0F == 0 and wSceneVerySlowTimer:
.verySlowTimer
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .dispatch

	ld a, [wSceneVerySlowTimer]
	and a
	jr z, .dispatch

;>     wSceneVerySlowTimer -= 1
	dec a
	ld [wSceneVerySlowTimer], a

;> CreditsSubtypes[wGameplaySubtype]()
.dispatch
	ld a, [wGameplaySubtype]
	rst $00

;@ path: ending/credits
;@ The parts of the ending (9 words), indexed by wGameplaySubtype while wGameplayType is 1:
;@ 0 init, 1 fade out of the last room, 2 the ending on the mountain (owl, Wind Fish, instruments, the
;@ island's memories, Link waking at sea), 3-7 the sea scenes, 8 the last scene with the staff credits.
CreditsSubtypes::
	dw CreditsInit
	dw CreditsFadeOut
	dw CreditsEndingScene
	dw CreditsSkyView
	dw CreditsFarLog
	dw CreditsLinkWakes
	dw CreditsWindFishFlies
	dw CreditsLinkPortrait
	dw CreditsFinalScene

;@ path: ending/credits
;@ The room objects of the ending: 128 bytes copied by CreditsFadeOut to wRoomObjectsArea ($D700, 8 rows
;@ of 16 squares starting with the border row above wRoomObjects). 0 = free square, 1 = solid; the
;@ first two rows are free, the third solid, the rest a frame of solid squares with a few gaps.
CreditsRoomObjects::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00
;@ path: ending/credits
;@ Background palette (and sprite palette 1) fading the last room out to white at the start of the
;@ ending: 16 bytes, levels $E4, $94, $40, $00 (step + (frame & 3) blends neighbouring levels).
CreditsFadeOutBGP::
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
;@ path: ending/credits
;@ Sprite palette 0 for the same fade: 16 bytes, levels $1C, $18, $04, $00.
CreditsFadeOutOBP::
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00

;@ def CreditsInit()
;@ path: ending/credits
;@ Ending part 0: clears the scene variables and goes on.
CreditsInit::
;> ResetSceneVars()
	call ResetSceneVars
;> CreditsNextSubtype()
	jp CreditsNextSubtype


;@ def CreditsFadeOut()
;@ path: ending/credits
;@ Ending part 1: the room where the ending started fades out to white (13 steps, one every 4 frames)
;@ while its entities keep running; then CreditsSetUp.
;@ test: skip runs the entities (bank 3)
CreditsFadeOut::
;> UpdateEntitiesBank17()                          # run the entities (bank 3)
	call UpdateEntitiesBank17
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .palette

;>     wSceneVar1 += 1
	ld a, [wSceneVar1]
	inc a
	ld [wSceneVar1], a
;>     if wSceneVar1 == 13:
	cp $0d
	jr nz, .palette

;>         return CreditsSetUp()
	jp CreditsSetUp


;> i = wSceneVar1 + (hFrameCounter & 3)                    # (b is 0 here)
.palette
	ld a, [wSceneVar1]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;> wBGPalette = CreditsFadeOutBGP[i]
	ld d, b
	ld hl, CreditsFadeOutBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ1Palette = CreditsFadeOutBGP[i]
	ld [wOBJ1Palette], a
;> wOBJ0Palette = CreditsFadeOutOBP[i]
	ld hl, CreditsFadeOutOBP
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> return
	ret


;@ def CreditsSetUp()
;@ path: ending/credits
;@ The end of ending part 1: clears $C000-$D5FF (the OAM buffer, the entities and most of the work
;@ RAM), copies CreditsRoomObjects into the room, stops the
;@ sound, allows only the VBlank interrupt, selects the background map at $9800, starts music $59 and
;@ waits $40 frames before part 2.
;@ test: skip stops the sound engine (bank $1F)
CreditsSetUp::
;> ClearWRAM1600()                          # clear $C000-$D5FF
	call ClearWRAM1600
;> dst = addr(wRoomObjectsArea)
;> src = CreditsRoomObjects
	ld hl, wRoomObjectsArea
	ld de, CreditsRoomObjects
;>@copy for n in range(0x80):
	ld c, $80
	ld a, $01

.copy
;>     mem[dst + n] = mem[src + n]
	ld a, [de]
	inc de
	ld [hli], a
;=@copy
	dec c
	jr nz, .copy

;> ResetSoundEngine()                          # stop the sound
	call ResetSoundEngine
;> rIE = 0x01                           # VBlank only
	ld a, $01
	ldh [rIE], a
;> rLYC = 0
	ld a, $00
	ldh [rLYC], a
;> wLCDControl &= ~0x08                 # background map at $9800
	ld hl, wLCDControl
	res 3, [hl]
;> ResetSceneVars()
	call ResetSceneVars
;> CreditsNextSubtype()
	call CreditsNextSubtype
;> wMusicTrackToPlay = 0x59
	ld a, $59
	ld [wMusicTrackToPlay], a
;> wSceneTimer = 0x40
	ld a, $40
	ld [wSceneTimer], a
;> wTransitionSequenceCounter = 4       # no screen fade running
	ld a, $04
	ld [wTransitionSequenceCounter], a
;> return
	ret


;@ def CreditsNextSubtype()
;@ path: ending/credits
;@ Goes on to the next part of the ending.
CreditsNextSubtype::
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]
;> return
	ret


;@ def CreditsEndingScene()
;@ path: ending/scene
;@ Ending part 2, the long scene on Koholint: every frame keeps the world quiet (BowWow away, outdoors,
;@ room $92, Link invincible), runs the entities and the current step of EndingSceneSteps.
;@ test: skip runs the entities (bank 3)
CreditsEndingScene::
;> wIsBowWowFollowingLink = 0x80
	ld a, $80
	ld [wIsBowWowFollowingLink], a
;> wIsIndoor = 0
	xor a
	ld [wIsIndoor], a
;> hRoomStatus = 0
	ldh [hRoomStatus], a
;> mem[0xC3C8] = 1
	ld a, $01
	ld [wMarinSinging], a
;> hMapRoom = 0x92
	ld a, $92
	ldh [hMapRoom], a
;> wInvincibilityCounter = 0xFF
	ld a, $ff
	ld [wInvincibilityCounter], a
;> UpdateEntitiesBank17()                          # run the entities
	call UpdateEntitiesBank17
;> EndingSceneSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/scene
;@ The steps of ending part 2 (25 words), indexed by wSceneStep: 0-3 the first picture fades in and
;@ scrolls, 4-5 the screen is cleared while the owl talks, 6-8 a flash and the Wind Fish appears, 9-15
;@ the Wind Fish speaks in the wavy dream picture, 16-18 the instruments, 19 the island's memories,
;@ 20-24 Link adrift at sea.
EndingSceneSteps::
	dw EndingInit
	dw EndingSpawnStairway
	dw EndingFadeInSky
	dw EndingScrollSky
	dw EndingClearScreen
	dw EndingWaitForOwl
	dw EndingPrepareFlash
	dw EndingFlash
	dw EndingDrawWindFish
	dw EndingWindFishAppears
	dw EndingWindFishSpeaks
	dw EndingWaitDialog
	dw EndingWindFishWavesAgain
	dw EndingWindFishFades
	dw EndingEraseWindFish
	dw EndingAfterLastWords
	dw EndingCopyInstrumentTiles
	dw EndingSpawnInstruments
	dw EndingWaitInstruments
	dw EndingIslandMemories
	dw EndingPillarScroll
	dw EndingPillarBob
	dw EndingPillarSink
	dw EndingPillarFadeOut
	dw EndingPartDone

;@ def EndingInit()
;@ path: ending/scene
;@ Step 0 of ending part 2: hides the window, requests tile set $1F, puts the scroll and the screen
;@ shake to 0 and clears the 12 bytes from wRoomTransitionState on.
EndingInit::
;> wWindowY = 0xFF                      # no window
	ld a, $ff
	ld [wWindowY], a
;> wTileMapToLoad = 0x1F
	ld a, $1f
	ld [wTileMapToLoad], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> wScreenShakeX = 0
	ld [wScreenShakeX], a
;> wScreenShakeY = 0
	ld [wScreenShakeY], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;>@clear for i in range(12):
	ld hl, wRoomTransitionState
	ld e, $00

.clear
;>     mem[addr(wRoomTransitionState) + i] = 0
	xor a
	ld [hli], a
;=@clear
	inc e
	ld a, e
	cp $0c
	jr nz, .clear

;> EndingNextStep()                     # falls through

;@ def EndingNextStep() -> hl
;@ path: ending/scene
;@ Goes on to the next step of the current ending part; returns hl = the address of wSceneStep.
EndingNextStep::
;> wSceneStep += 1
	ld hl, wSceneStep
	inc [hl]
;> return addr(wSceneStep)
	ret


;@ def EndingSpawnLightColumn()
;@ path: ending/scene
;@ Step 1 of ending part 2: requests screen layout $16 (the night sky above the egg) and spawns two
;@ ending objects (entity $E8): part 0, the stairway that comes down to Link (EndingStairway), at x $40
;@ above the screen (y $E0), and part 1, the twinkling stars (EndingStars); Link stands at ($50, $98).
EndingSpawnStairway::
;> wBGMapToLoad = 0x16
	ld a, $16
	ld [wBGMapToLoad], a
;> slot = SpawnEntity(0xE8)               # ending object, part 0
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x40
	ld hl, wEntityX
	add hl, de
	ld [hl], $40
;> wEntityY[slot] = 0xE0
	ld hl, wEntityY
	add hl, de
	ld [hl], $e0
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityPrivate1[slot] += 1           # part 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;> hLinkY = 0x98
	ld a, $98
	ldh [hLinkY], a
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/scene
;@ Background palette fading in from white for the first picture of ending part 2: 16 bytes, levels
;@ $00, $01, $16, $27 (read at step + (frame & 3)).
SkyFadeInBGP::
	db $00, $00, $00, $00, $01, $01, $01, $01, $16, $16, $16, $16, $27, $27, $27, $27
;@ path: ending/scene
;@ Sprite palette 0 for the same fade: 16 bytes, levels $00, $04, $18, $1C.
SkyFadeInOBP0::
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
;@ path: ending/scene
;@ Sprite palette 1 for the same fade: 16 bytes, levels $00, $00, $50, $90.
SkyFadeInOBP1::
	db $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $50, $90, $90, $90, $90

;@ def EndingFadeInSky()
;@ path: ending/scene
;@ Step 2 of ending part 2: once wSceneTimer has run out, fades the picture in (one level every 8
;@ frames, 12 steps), and already scrolls it like step 3 (EndingScrollSky).
EndingFadeInSky::
;> if wSceneTimer == 0 and hFrameCounter & 7 == 0:
	ld a, [wSceneTimer]
	ld e, a
	ldh a, [hFrameCounter]
	and $07
	or e
	jr nz, .palette

;>     wSceneVar1 += 1
	ld a, [wSceneVar1]
	inc a
	ld [wSceneVar1], a
;>     if wSceneVar1 == 12:
	cp $0c
	jr nz, .palette

;>         EndingNextStep()
	call EndingNextStep

;> i = wSceneVar1 + (hFrameCounter & 3)                    # (b is 0 here)
.palette
	ld a, [wSceneVar1]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;> wBGPalette = SkyFadeInBGP[i]
	ld d, b
	ld hl, SkyFadeInBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = SkyFadeInOBP0[i]
	ld hl, SkyFadeInOBP0
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = SkyFadeInOBP1[i]
	ld hl, SkyFadeInOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> EndingScrollSky()                    # falls through

;@ def EndingScrollSky()
;@ path: ending/scene
;@ Step 3 of ending part 2: scrolls the picture slowly: the background up by 1 pixel every 4 frames
;@ (hBaseScrollY counts down) until hBaseScrollY is $90, and the object in entity slot 14 down by
;@ 1 pixel every 32/3 frames. Then clears the scene variables and goes on.
EndingScrollSky::
;> wSceneVar3 += 0x18
	ld a, [wSceneVar3]
	add $18
	ld [wSceneVar3], a
;> if wSceneVar3 < 0x18:                # it wrapped (carry)
	jr nc, .scroll

;>     wEntityY[14] += 1
	ld hl, wEntityY + 14
	inc [hl]

;> wSceneVar2 += 0x40
.scroll
	ld a, [wSceneVar2]
	add $40
	ld [wSceneVar2], a
;> if wSceneVar2 >= 0x40:               # no wrap (no carry)
;>     return
	jr nc, jr_017_4b16

;> hBaseScrollY -= 1
	ldh a, [hBaseScrollY]
	dec a
	ldh [hBaseScrollY], a
;> if hBaseScrollY != 0x90:
;>     return
	cp $90
	jr nz, jr_017_4b16

;> EndingNextStep()
	call EndingNextStep
;> ResetSceneVars()                     # falls through

;@ def ResetSceneVars()
;@ path: ending/credits
;@ Clears the scene variables of the ending: wEntityWorkRAM, wSceneVar1-5, wSceneFadeStep, wSceneVarB-D
;@ and the four scene timers (wSceneStep, wSceneVarF and the credits roll keep their values).
ResetSceneVars::
;> wEntityWorkRAM = 0
	xor a
	ld [wEntityWorkRAM], a
;> wSceneVar1 = 0
	ld [wSceneVar1], a
;> wSceneVar2 = 0
	ld [wSceneVar2], a
;> wSceneVar3 = 0
	ld [wSceneVar3], a
;> wSceneVar4 = 0
	ld [wSceneVar4], a
;> wSceneVar5 = 0
	ld [wSceneVar5], a
;> wSceneFadeStep = 0
	ld [wSceneFadeStep], a
;> wSceneVarB = 0
	ld [wSceneVarB], a
;> wSceneVarC = 0
	ld [wSceneVarC], a
;> wSceneVarD = 0
	ld [wSceneVarD], a
;> wSceneTimer = 0
	ld [wSceneTimer], a
;> wSceneTimer2 = 0
	ld [wSceneTimer2], a
;> wSceneTimer3 = 0
	ld [wSceneTimer3], a
;> wSceneSlowTimer = 0
	ld [wSceneSlowTimer], a

;> return
jr_017_4b16:
	ret


;@ path: ending/scene
;@ Background draw commands that blank the screen, two rows at a time: 9 entries of 8 bytes, each two
;@ commands of 4 bytes (BG map address high, low; $53 = 20 times the next byte; tile $A0, the blank
;@ tile). Entry n blanks map rows 2n and 2n+1 ($9800-$9A3F). Copied one entry per frame into
;@ wDrawCommand by EndingClearScreen. Draw command format: address (2 bytes, big endian), then a byte
;@ with bit 7 = go down a column instead of along a row, bit 6 = repeat one data byte, bits 0-5 =
;@ count - 1, then the data; a 0 ends the list.
ClearScreenCommands::
	db $98, $00, $53, $a0, $98, $20, $53, $a0
	db $98, $40, $53, $a0, $98, $60, $53, $a0
	db $98, $80, $53, $a0, $98, $a0, $53, $a0
	db $98, $c0, $53, $a0, $98, $e0, $53, $a0
	db $99, $00, $53, $a0, $99, $20, $53, $a0
	db $99, $40, $53, $a0, $99, $60, $53, $a0
	db $99, $80, $53, $a0, $99, $a0, $53, $a0
	db $99, $c0, $53, $a0, $99, $e0, $53, $a0
	db $9a, $00, $53, $a0, $9a, $20, $53, $a0

;@ def EndingClearScreen()
;@ path: ending/scene
;@ Step 4 of ending part 2 (the owl is flying down meanwhile): blanks the background two rows per
;@ frame (ClearScreenCommands, 9 frames), then scrolls the map to y $F0 and goes on.
EndingClearScreen::
;> if wEntityWorkRAM == 9:
	ld a, [wEntityWorkRAM]
	cp $09
	jr nz, .draw

;>     hBaseScrollY = 0xF0
	ld a, $f0
	ldh [hBaseScrollY], a
;>     return EndingNextStep()
	jp EndingNextStep


;> n = wEntityWorkRAM
.draw
	ld e, a
;> wEntityWorkRAM += 1
	inc a
	ld [wEntityWorkRAM], a
;> src = ClearScreenCommands + n * 8
	sla e
	sla e
	sla e
	ld d, $00
	ld hl, ClearScreenCommands
	add hl, de
;>@copy copy(addr(wDrawCommand), src, 8)
	ld de, wDrawCommand
	ld c, $08

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> wDrawCommand[8] = 0                  # end of the commands
	xor a
	ld [de], a
;> return
	ret


;@ def EndingWaitForOwl()
;@ path: ending/scene
;@ Step 5 of ending part 2: nothing to do; the owl (EndingOwl) talks to Link and moves the ending on
;@ when it has flown away.
EndingWaitForOwl::
;> return
	ret


;@ def EndingPrepareFlash()
;@ path: ending/scene
;@ Step 6 of ending part 2: clears the scene variables and starts the flash 8 frames later.
EndingPrepareFlash::
;> ResetSceneVars()
	call ResetSceneVars
;> wSceneTimer = 8
	ld a, $08
	ld [wSceneTimer], a
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/scene
;@ Background palettes of the flash before the Wind Fish appears: 6 bytes, read at step + (frame & 1)
;@ with step 0-4, so the background flickers between $27 and $EB and then goes black ($FF).
FlashPalettes::
	db $27, $27, $eb, $ff, $ff, $ff

;@ def EndingFlash()
;@ path: ending/scene
;@ Step 7 of ending part 2: the sky flashes and turns black (FlashPalettes, a step every 8 frames,
;@ 5 steps).
EndingFlash::
;> i = wSceneFadeStep + (hFrameCounter & 1)
	ldh a, [hFrameCounter]
	and $01
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = FlashPalettes[i]
	ld d, $00
	ld hl, FlashPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> wSceneTimer = 8
	ld a, $08
	ld [wSceneTimer], a
;> wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
;> if wSceneFadeStep == 5:
	cp $05
	jr nz, .done

;>     ResetSceneVars()
	call ResetSceneVars
;>     EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ path: ending/windfish
;@ The picture of the Wind Fish as 10 background draw commands of 24 bytes: BG map address (2 bytes,
;@ big endian), $13 (20 tiles follow), 20 tile numbers, 0 (end). Rows $9BC0 and $9BE0 (map rows 30-31)
;@ and $9800-$98E0 (rows 0-7): with the map scrolled to y $F0 they are screen rows 0-9. Tile $A0 is
;@ blank; the picture uses tiles $05-$7E and $AF of tile set $1F. Drawn one row per frame by
;@ EndingDrawWindFish.
WindFishPictureRows::
	db $9b, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $72, $73, $74
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9b, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $a0, $a0, $a0, $a0, $7b, $7c, $7d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $98, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $05, $06, $07, $08, $09, $0a
	db $0b, $0c, $0d, $0e, $a0, $a0, $a0, $00, $98, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $a0, $a0, $00
	db $98, $40, $13, $a0, $a0, $a0, $a0, $22, $23, $24, $25, $26, $27, $28, $29, $2a
	db $2b, $2c, $2d, $2e, $2f, $a0, $a0, $00, $98, $60, $13, $a0, $a0, $a0, $31, $32
	db $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $a0, $a0, $00
	db $98, $80, $13, $a0, $a0, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a
	db $4b, $4c, $4d, $4e, $4f, $a0, $a0, $00, $98, $a0, $13, $a0, $a0, $50, $51, $52
	db $53, $54, $55, $56, $57, $58, $59, $a0, $5b, $5c, $5d, $5e, $5f, $a0, $a0, $00
	db $98, $c0, $13, $a0, $a0, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a
	db $a0, $6c, $6d, $6e, $6f, $a0, $a0, $00, $98, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $a0, $75, $76, $77, $78, $79, $7a, $a0, $a0, $a0, $7e, $af, $a0, $a0, $00

;@ def EndingDrawWindFish()
;@ path: ending/windfish
;@ Step 8 of ending part 2: draws the Wind Fish into the black sky, one row per frame (10 frames).
;@ Then turns on the wave effect (wTransitionGfx $FF, see WaveEffectFrame) with the first fade step
;@ 12 frames later, sets LYC to $56 and plays the wave sound $1F.
EndingDrawWindFish::
;> if wEntityWorkRAM == 10:
	ld a, [wEntityWorkRAM]
	cp $0a
	jr nz, .draw

;>     hBaseScrollY = 0xF0
	ld a, $f0
	ldh [hBaseScrollY], a
;>     ResetSceneVars()
	call ResetSceneVars
;>     rIE = 0x01                       # VBlank only
	ld a, $01
	ldh [rIE], a
;>     rLYC = 0x56
	ld a, $56
	ldh [rLYC], a
;>     wSceneTimer = 0x0C
	ld a, $0c
	ld [wSceneTimer], a
;>     wTransitionGfx = 0xFF            # wave effect on
	ld a, $ff
	ld [wTransitionGfx], a
;>     wSceneStep = 9
	ld a, $09
	ld [wSceneStep], a
;>     hWaveSfx = 0x1F
	ld a, $1f
	ldh [hWaveSfx], a
;>     return
	ret


;> n = wEntityWorkRAM
.draw
	ld e, a
;> wEntityWorkRAM += 1
	inc a
	ld [wEntityWorkRAM], a
;> offset = n * 24
	sla e
	sla e
	sla e
	ld a, e
	sla e
	add e
;> src = WindFishPictureRows + offset
	ld e, a
	ld d, $00
	ld hl, WindFishPictureRows
	add hl, de
;>@copy copy(addr(wDrawCommand), src, 24)
	ld de, wDrawCommand
	ld c, $18

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> return
	ret


;@ path: ending/windfish
;@ Background palette fading the Wind Fish in from black: 16 bytes, levels $FF, $BF, $6B, $27
;@ (read at step + (frame & 3)).
WindFishFadeInBGP::
	db $ff, $ff, $ff, $ff, $bf, $bf, $bf, $bf, $6b, $6b, $6b, $6b, $27, $27, $27, $27

;@ def EndingWindFishAppears()
;@ path: ending/windfish
;@ Step 9 of ending part 2: the Wind Fish fades in (a step every 12 frames, 12 steps) inside the wave
;@ effect; from step 7 on the waves calm down (wSceneVar5 + $20 every 16 frames). When they have
;@ calmed completely the effect stops (only the up-and-down stays, wTransitionGfx $FE), the STAT
;@ interrupt is allowed again and the Wind Fish speaks $40 frames later.
EndingWindFishAppears::
;> i = wSceneFadeStep + (hFrameCounter & 3)
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = WindFishFadeInBGP[i]
	ld d, $00
	ld hl, WindFishFadeInBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> if wSceneTimer == 0 and wSceneFadeStep != 12:
	ld a, [wSceneTimer]
	and a
	jr nz, .waves

	ld a, [wSceneFadeStep]
	cp $0c
	jr z, .waves

;>     wSceneFadeStep += 1
	inc a
	ld [wSceneFadeStep], a
;>     wSceneTimer = 0x0C
	ld a, $0c
	ld [wSceneTimer], a

;> if wSceneFadeStep < 7:
.waves
	ld a, [wSceneFadeStep]
	cp $07
;>     return
	jr c, .done

;> wSceneVarB += 1
	ld a, [wSceneVarB]
	inc a
	ld [wSceneVarB], a
;> if wSceneVarB & 0x0F:
	and $0f
;>     return
	jr nz, .done

;> wSceneVar5 += 0x20                   # weaker waves
	ld a, [wSceneVar5]
	add $20
	ld [wSceneVar5], a
;> if wSceneVar5 != 0:
;>     return
	jr nz, .done

;> wTransitionGfx = 0xFE                # waves off, only the up-and-down
	ld a, $fe
	ld [wTransitionGfx], a
;> ResetSceneVars()
	call ResetSceneVars
;> wSceneTimer = 0x40
	ld a, $40
	ld [wSceneTimer], a
;> rIE = 0x03                           # VBlank and STAT
	ld a, $03
	ldh [rIE], a
;> return EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ def EndingWindFishSpeaks()
;@ path: ending/windfish
;@ Step 10 of ending part 2: once wSceneTimer has run out, the Wind Fish speaks (dialog $D0).
EndingWindFishSpeaks::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, jr_017_4d88

;> EndingNextStep()
	call EndingNextStep
;> OpenWindFishDialog(0xD0)             # falls through
	ld a, $d0

;@ def OpenWindFishDialog(dialog: a)
;@ path: ending/windfish
;@ Opens a dialog of the Wind Fish (with the box at the bottom, see OpenEndingDialog) and plays the
;@ wave sound $17.
OpenWindFishDialog::
;> OpenEndingDialog(dialog)
	call OpenEndingDialog
;> hWaveSfx = 0x17
	ld a, $17
	ldh [hWaveSfx], a

;> return
jr_017_4d88:
	ret


;@ def EndingWaitDialog()
;@ path: ending/windfish
;@ Step 11 of ending part 2: waits until the dialog is closed.
EndingWaitDialog::
;> if wDialogState == 0:
	ld a, [wDialogState]
	and a
	jr nz, .done

;>     EndingNextStep()
	call EndingNextStep

.done
	ret


;@ def EndingWindFishWavesAgain()
;@ path: ending/windfish
;@ Step 12 of ending part 2: when no dialog is open, the wave effect comes back (weakest strength
;@ $E0), with the fade-out $50 frames later, and the wave sound $1F plays.
EndingWindFishWavesAgain::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> rIE = 0x01                           # VBlank only
	ld a, $01
	ldh [rIE], a
;> wTransitionGfx = 0xFF                # wave effect on
	ld a, $ff
	ld [wTransitionGfx], a
;> wSceneVar5 = 0xE0                    # weakest waves
	ld a, $e0
	ld [wSceneVar5], a
;> wSceneTimer = 0x50
	ld a, $50
	ld [wSceneTimer], a
;> hWaveSfx = 0x1F
	ld a, $1f
	ldh [hWaveSfx], a
;> EndingNextStep()
	call EndingNextStep

.done
	ret


;@ path: ending/windfish
;@ Background palette fading the Wind Fish out to black: 16 bytes, levels $27, $6B, $BF, $FF.
WindFishFadeOutBGP::
	db $27, $27, $27, $27, $6b, $6b, $6b, $6b, $bf, $bf, $bf, $bf, $ff, $ff, $ff, $ff

;@ def EndingWindFishFades()
;@ path: ending/windfish
;@ Step 13 of ending part 2: the waves grow stronger again (wSceneVar5 - $20 every 16 frames down to
;@ 0); once they are strong enough (below $A0) the Wind Fish fades to black, a step every 12 frames
;@ (13 steps). Then the effect stops and the next step follows $30 frames later.
EndingWindFishFades::
;> i = wSceneFadeStep + (hFrameCounter & 3)
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = WindFishFadeOutBGP[i]
	ld d, $00
	ld hl, WindFishFadeOutBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> if wSceneVar5 < 0xA0 and wSceneTimer == 0:
	ld a, [wSceneVar5]
	cp $a0
	jr nc, .waves

	ld a, [wSceneTimer]
	and a
	jr nz, .waves

;>     wSceneTimer = 0x0C
	ld a, $0c
	ld [wSceneTimer], a
;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
;>     if wSceneFadeStep == 13:
	cp $0d
	jr nz, .waves

;>         wTransitionGfx = 0           # wave effect off
	xor a
	ld [wTransitionGfx], a
;>         ResetSceneVars()
	call ResetSceneVars
;>         wSceneTimer = 0x30
	ld a, $30
	ld [wSceneTimer], a
;>         rIE = 0x01
	ld a, $01
	ldh [rIE], a
;>         return EndingNextStep()
	jp EndingNextStep


;> wSceneVarB += 1
.waves
	ld a, [wSceneVarB]
	inc a
	ld [wSceneVarB], a
;> if wSceneVarB & 0x0F == 0 and wSceneVar5:
	and $0f
	jr nz, .done

	ld a, [wSceneVar5]
	and a
	jr z, .done

;>     wSceneVar5 -= 0x20               # stronger waves
	sub $20
	ld [wSceneVar5], a

.done
	ret


;@ path: ending/windfish
;@ Background draw commands that blank the 10 rows of the Wind Fish picture: 10 commands of 4 bytes
;@ (BG map address high, low; $53 = 20 times the next byte; blank tile $A0), rows $9BC0, $9BE0 and
;@ $9800-$98E0. Copied one per frame by EndingEraseWindFish.
EraseWindFishCommands::
	db $9b, $c0, $53, $a0, $9b, $e0, $53, $a0, $98, $00, $53, $a0, $98, $20, $53, $a0
	db $98, $40, $53, $a0, $98, $60, $53, $a0, $98, $80, $53, $a0, $98, $a0, $53, $a0
	db $98, $c0, $53, $a0, $98, $e0, $53, $a0

;@ def EndingEraseWindFish()
;@ path: ending/windfish
;@ Step 14 of ending part 2: after the wait, blanks the Wind Fish picture one row per frame (10 frames);
;@ then the Wind Fish's last words (dialog $D2) appear over the night sky (background palette $27).
EndingEraseWindFish::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	ret nz

;> if wEntityWorkRAM == 10:
	ld a, [wEntityWorkRAM]
	cp $0a
	jr nz, .draw

;>     OpenWindFishDialog(0xD2)
	ld a, $d2
	call OpenWindFishDialog
;>     wBGPalette = 0x27
	ld a, $27
	ld [wBGPalette], a
;>     return EndingNextStep()
	jp EndingNextStep


;> n = wEntityWorkRAM
.draw
	ld e, a
;> wEntityWorkRAM += 1
	inc a
	ld [wEntityWorkRAM], a
;> src = EraseWindFishCommands + n * 4
	sla e
	sla e
	ld d, $00
	ld hl, EraseWindFishCommands
	add hl, de
;>@copy copy(addr(wDrawCommand), src, 4)
	ld de, wDrawCommand
	ld c, $04

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> wDrawCommand[4] = 0
	xor a
	ld [de], a
;> return
	ret


;@ def EndingAfterLastWords()
;@ path: ending/instruments
;@ Step 15 of ending part 2: when the dialog is closed, Link takes pose 3 and the first block of the
;@ instruments' tiles is requested (hBGChangeRequest $0C, see EndingCopyInstrumentTiles).
EndingAfterLastWords::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> ResetSceneVars()
	call ResetSceneVars
;> hLinkAnimationState = 3
	ld a, $03
	ldh [hLinkAnimationState], a
;> hBGChangeRequest = 0x0C              # copy tile block wEntityWorkRAM (0)
	ld a, $0c
	ldh [hBGChangeRequest], a
;> EndingNextStep()
	call EndingNextStep

.done
	ret


;@ def EndingCopyInstrumentTiles()
;@ path: ending/instruments
;@ Step 16 of ending part 2: requests the other 7 blocks of the instruments' sprite tiles, one per
;@ frame: with hBGChangeRequest $0C the VBlank handler copies $40 bytes (4 tiles) from bank $11
;@ $5000 + n * $40 to VRAM $8D00 + n * $40 (n = wEntityWorkRAM), so tiles $D0-$EF hold the eight
;@ instruments. Then the instruments appear $80 frames later.
EndingCopyInstrumentTiles::
;> if wEntityWorkRAM == 7:
	ld a, [wEntityWorkRAM]
	cp $07
	jr nz, .next

;>     ResetSceneVars()
	call ResetSceneVars
;>     wSceneTimer = 0x80
	ld a, $80
	ld [wSceneTimer], a
;>     return EndingNextStep()
	jp EndingNextStep


;> wEntityWorkRAM += 1
.next
	inc a
	ld [wEntityWorkRAM], a
;> hBGChangeRequest = 0x0C
	ld a, $0c
	ldh [hBGChangeRequest], a
;> return
	ret


;@ path: ending/instruments
;@ Start x of the eight instruments (8 bytes, instrument 0-7), on a ring around Link.
InstrumentStartX::
	db $48, $58, $60, $60, $58, $48, $40, $40

;@ path: ending/instruments
;@ Start y of the eight instruments (8 bytes; EndingSpawnInstruments subtracts $20).
InstrumentStartY::
	db $40, $40, $48, $58, $60, $60, $58, $48
;@ path: ending/instruments
;@ Horizontal speed of each instrument (8 signed bytes, 1/16 pixel per frame), pointing away from the
;@ middle of the ring: the ring widens for 32 frames.
InstrumentSpeedX::
	db $ff, $01, $02, $02, $01, $ff, $fe, $fe

;@ path: ending/instruments
;@ Vertical speed of each instrument (8 signed bytes, 1/16 pixel per frame).
InstrumentSpeedY::
	db $fe, $fe, $ff, $01, $02, $02, $01, $ff
;@ path: ending/instruments
;@ Sprite variant of each instrument (8 bytes, 0-7: which instrument of InstrumentFrames it shows).
InstrumentKinds::
	db $00, $01, $02, $03, $04, $05, $06, $07

;@ path: ending/instruments
;@ OAM offset of each instrument's two sprites (8 bytes; EndingInstrument adds $50, i.e. OAM entries
;@ 20-35).
InstrumentOAMOffsets::
	db $00, $08, $10, $18, $20, $28, $30, $38

;@ def EndingSpawnInstruments()
;@ path: ending/instruments
;@ Step 17 of ending part 2: after the wait, Link takes pose 4, music $3F starts and the eight
;@ instruments appear (ending objects, part 3) on a ring around him, moving outwards for 32 frames.
EndingSpawnInstruments::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> hLinkAnimationState = 4
	ld a, $04
	ldh [hLinkAnimationState], a
;> wMusicTrackToPlay = 0x3F
	ld a, $3f
	ld [wMusicTrackToPlay], a

;>@each while True:
.spawn
;>     slot = SpawnEntity(0xE8)           # ending object
	ld a, $e8
	call SpawnEntity
;>     i = wEntityWorkRAM
	ld a, [wEntityWorkRAM]
	ld c, a
	ld b, $00
;>     wEntityX[slot] = InstrumentStartX[i]
	ld hl, InstrumentStartX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     y = InstrumentStartY[i]
	ld hl, InstrumentStartY
	add hl, bc
	ld a, [hl]
;>     wEntityY[slot] = y - 0x20
	ld hl, wEntityY
	add hl, de
	sub $20
	ld [hl], a
;>     wEntitySpeedX[slot] = InstrumentSpeedX[i]
	ld hl, InstrumentSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>     wEntitySpeedY[slot] = InstrumentSpeedY[i]
	ld hl, InstrumentSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;>     wEntitySpriteVariant[slot] = InstrumentKinds[i]
	ld hl, InstrumentKinds
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;>     wEntityPrivate2[slot] = InstrumentOAMOffsets[i]
	ld hl, InstrumentOAMOffsets
	add hl, bc
	ld a, [hl]
	ld hl, wEntityPrivate2
	add hl, de
	ld [hl], a
;>     wEntityPrivate1[slot] = 3        # part 3: an instrument
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $03
;>     wEntityPhysicsFlags[slot] = 0xC2
	ld hl, wEntityPhysicsFlags
	add hl, de
	ld [hl], $c2
;>     wEntityDropTimer[slot] = 0x20    # frames it moves
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $20
;>     wEntityWorkRAM = i + 1
	ld a, c
	inc a
	ld [wEntityWorkRAM], a
;>     if wEntityWorkRAM == 8:
;>         break
	cp $08
	jr nz, .spawn

;> ResetSceneVars()
	call ResetSceneVars
;> wSceneTimer = 0xA0
	ld a, $a0
	ld [wSceneTimer], a
;> EndingNextStep()
	call EndingNextStep

.done
	ret


;@ def EndingWaitInstruments()
;@ path: ending/instruments
;@ Step 18 of ending part 2: plays jingle $34 two frames into the wait and goes on when wSceneTimer
;@ has run out.
EndingWaitInstruments::
;> if wSceneTimer == 0x9E:
	ld a, [wSceneTimer]
	cp $9e
	jr nz, .check

;>     hJingle = 0x34
	ld hl, hJingle
	ld [hl], $34

;> if wSceneTimer == 0:
.check
	and a
	jr nz, .done

;>     EndingNextStep()
	call EndingNextStep

.done
	ret


;@ def EndingIslandMemories()
;@ path: ending/memories
;@ Step 19 of ending part 2: while the instruments play, Koholint's inhabitants appear one last time in
;@ five pictures that fade in and out, then the island itself dissolves. Runs the sub-step
;@ wEntityWorkRAM of IslandMemorySteps.
EndingIslandMemories::
;> IslandMemorySteps[wEntityWorkRAM]()
	ld a, [wEntityWorkRAM]
	rst $00

;@ path: ending/memories
;@ The sub-steps of the island's memories (18 words), indexed by wEntityWorkRAM: fade to white, five
;@ pictures (each: fade out the last one, draw and populate the next, fade it in), the island picture
;@ and its dissolve, then the cloud pillar with Link.
IslandMemorySteps::
	dw MemoryFadeToWhite
	dw MemoryScene1
	dw MemoryFadeIn1
	dw MemoryScene2
	dw MemoryFadeIn2
	dw MemoryScene3
	dw MemoryFadeIn3
	dw MemoryScene4
	dw MemoryFadeIn4
	dw MemoryScene5
	dw MemoryFadeIn5
	dw MemoryLoadIsland
	dw MemoryDrawIsland
	dw MemoryFadeInIsland
	dw MemoryDissolveIsland
	dw MemoryLoadPillar
	dw MemoryShowPillar
	dw MemoryPillarShake

;@ def MemoryNextStep()
;@ path: ending/memories
;@ Goes on to the next sub-step of the island's memories.
MemoryNextStep::
;> wEntityWorkRAM += 1
	ld hl, wEntityWorkRAM
	inc [hl]
;> return
	ret


;@ def ClearAllEntities()
;@ path: ending/memories
;@ Frees all 16 entity slots (wEntityStatus = 0).
ClearAllEntities::
;>@clear for slot in range(16):
	ld e, $10
	ld hl, wEntityStatus
	xor a

.loop
;>     wEntityStatus[slot] = 0
	ld [hli], a
;=@clear
	dec e
	jr nz, .loop

;> return
	ret


;@ path: ending/memories
;@ Background palette fading the night sky with the instruments to white: 16 bytes, levels $FF, $AA,
;@ $55, $00 (read at step + (frame & 3)).
WhiteFadeBGP::
	db $ff, $ff, $ff, $ff, $aa, $aa, $aa, $aa, $55, $55, $55, $55, $00, $00, $00, $00
;@ path: ending/memories
;@ Sprite palette 0 for the same fade: 16 bytes, levels $1C, $18, $04, $00.
WhiteFadeOBP0::
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00
;@ path: ending/memories
;@ Sprite palette 1 for the same fade: 16 bytes, levels $90, $50, $00, $00.
WhiteFadeOBP1::
	db $90, $90, $90, $90, $50, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00

;@ def MemoryFadeToWhite()
;@ path: ending/memories
;@ Memories sub-step 0: fades everything to white (a step every 8 frames, 12 steps), then requests
;@ tile set $1D for the pictures, resets the scroll and removes all entities.
MemoryFadeToWhite::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
;>     if wSceneFadeStep == 12:
	cp $0c
	jr nz, .palette

;>         wTileMapToLoad = 0x1D
	ld a, $1d
	ld [wTileMapToLoad], a
;>         hBaseScrollY = 0
	xor a
	ldh [hBaseScrollY], a
;>         ClearAllEntities()
	call ClearAllEntities
;>         return MemoryNextStep()
	jp MemoryNextStep


;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = WhiteFadeBGP[i]
	ld d, $00
	ld hl, WhiteFadeBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = WhiteFadeOBP0[i]
	ld hl, WhiteFadeOBP0
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = WhiteFadeOBP1[i]
	ld hl, WhiteFadeOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def ShakeScreenSideways()
;@ path: ending/memories
;@ Shakes the screen sideways: wScreenShakeX is 1 or -2, switching every 4 frames.
ShakeScreenSideways::
;> shake = 1
	ldh a, [hFrameCounter]
	ld e, $01
;> if hFrameCounter & 4:
	and $04
	jr z, .store

;>     shake = 0xFE
	ld e, $fe

;> wScreenShakeX = shake
.store
	ld hl, wScreenShakeX
	ld [hl], e
;> return
	ret


;@ def MemoryScene1()
;@ path: ending/memories
;@ Memories sub-step 1: the first picture (screen layout $20, BowWow in front of a house) with
;@ BowWow (entity $6D) at ($48, $50), entity $6F at ($68, $30) and two entities $78 at ($2C, $58)
;@ and ($60, $52), the second one with wEntityPrivate1 = 1.
MemoryScene1::
;> wSceneFadeStep = 0
	xor a
	ld [wSceneFadeStep], a
;> wBGMapToLoad = 0x20
	ld a, $20
	ld [wBGMapToLoad], a
;> slot = SpawnEntity(0x6D)
	ld a, $6d
	call SpawnEntity
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = SpawnEntity(0x6F)
	ld a, $6f
	call SpawnEntity
;> wEntityX[slot] = 0x68
	ld hl, wEntityX
	add hl, de
	ld [hl], $68
;> wEntityY[slot] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> slot = SpawnEntity(0x78)
	ld a, $78
	call SpawnEntity
;> wEntityX[slot] = 0x2C
	ld hl, wEntityX
	add hl, de
	ld [hl], $2c
;> wEntityY[slot] = 0x58
	ld hl, wEntityY
	add hl, de
	ld [hl], $58
;> slot = SpawnEntity(0x78)
	ld a, $78
	call SpawnEntity
;> wEntityX[slot] = 0x60
	ld hl, wEntityX
	add hl, de
	ld [hl], $60
;> wEntityY[slot] = 0x52
	ld hl, wEntityY
	add hl, de
	ld [hl], $52
;> wEntityPrivate1[slot] += 1
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> MemoryNextStep()
	jp MemoryNextStep


;@ def MemoryFadeIn1()
;@ path: ending/memories
;@ Memories sub-step 2: fades the first picture in; it stays $50 frames.
MemoryFadeIn1::
;> if FadeInMemory():
	call FadeInMemory
	jr nz, .done

;>     wSceneTimer = 0x50
	ld a, $50
	ld [wSceneTimer], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def CheckMemorySkip()
;@ path: ending/memories
;@ Looks at the A and B buttons but does the same either way: a leftover of a way to skip the
;@ memories (it returns at once when one is held, otherwise after a nop).
CheckMemorySkip::
;> if hJoypadHeld & 0x30:
	ldh a, [hJoypadHeld]
	and $30
;>     return
	ret nz

;> return
	nop
	ret


;@ def MemoryScene2()
;@ path: ending/memories
;@ Memories sub-step 3: after the wait, fades the picture out; then the second picture (screen layout
;@ $1E, two children playing): entity $71 at ($48, $50) (state 1, timer $20, facing up) and entity
;@ $72 at ($78, $50).
MemoryScene2::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> CheckMemorySkip()
	call CheckMemorySkip
;> if not FadeOutMemory():
;>     return
	call FadeOutMemory
	jr nz, .done

;> wBGMapToLoad = 0x1E
	ld a, $1e
	ld [wBGMapToLoad], a
;> ClearAllEntities()
	call ClearAllEntities
;> slot = SpawnEntity(0x71)
	ld a, $71
	call SpawnEntity
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> wEntityState[slot] += 1
	ld hl, wEntityState
	add hl, de
	inc [hl]
;> wEntityTimer[slot] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;> wEntityDirection[slot] = 2          # up
	ld hl, wEntityDirection
	add hl, de
	ld [hl], $02
;> slot = SpawnEntity(0x72)
	ld a, $72
	call SpawnEntity
;> wEntityX[slot] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryFadeIn2()
;@ path: ending/memories
;@ Memories sub-step 4: fades the second picture in; it stays $50 frames.
MemoryFadeIn2::
;> if FadeInMemory():
	call FadeInMemory
	jr nz, .done

;>     wSceneTimer = 0x50
	ld a, $50
	ld [wSceneTimer], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryScene3()
;@ path: ending/memories
;@ Memories sub-step 5: fades out, then the third picture (screen layout $22) with entity $C5 at
;@ ($28, $40) and two entities $09 at ($48, $50) and ($68, $60).
MemoryScene3::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> CheckMemorySkip()
	call CheckMemorySkip
;> if not FadeOutMemory():
;>     return
	call FadeOutMemory
	jr nz, .done

;> wBGMapToLoad = 0x22
	ld a, $22
	ld [wBGMapToLoad], a
;> ClearAllEntities()
	call ClearAllEntities
;> slot = SpawnEntity(0xC5)
	ld a, $c5
	call SpawnEntity
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x40
	ld hl, wEntityY
	add hl, de
	ld [hl], $40
;> slot = SpawnEntity(0x09)
	ld a, $09
	call SpawnEntity
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = SpawnEntity(0x09)
	ld a, $09
	call SpawnEntity
;> wEntityX[slot] = 0x68
	ld hl, wEntityX
	add hl, de
	ld [hl], $68
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryFadeIn3()
;@ path: ending/memories
;@ Memories sub-step 6: fades the third picture in; it stays $50 frames.
MemoryFadeIn3::
;> if FadeInMemory():
	call FadeInMemory
	jr nz, .done

;>     wSceneTimer = 0x50
	ld a, $50
	ld [wSceneTimer], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryScene4()
;@ path: ending/memories
;@ Memories sub-step 7: fades out, then the fourth picture (screen layout $21, a pond among flowers)
;@ with entity $3F at ($78, $50).
MemoryScene4::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> CheckMemorySkip()
	call CheckMemorySkip
;> if not FadeOutMemory():
;>     return
	call FadeOutMemory
	jr nz, .done

;> wBGMapToLoad = 0x21
	ld a, $21
	ld [wBGMapToLoad], a
;> ClearAllEntities()
	call ClearAllEntities
;> slot = SpawnEntity(0x3F)
	ld a, $3f
	call SpawnEntity
;> wEntityX[slot] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryFadeIn4()
;@ path: ending/memories
;@ Memories sub-step 8: fades the fourth picture in; it stays $50 frames.
MemoryFadeIn4::
;> if FadeInMemory():
	call FadeInMemory
	jr nz, .done

;>     wSceneTimer = 0x50
	ld a, $50
	ld [wSceneTimer], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryScene5()
;@ path: ending/memories
;@ Memories sub-step 9: fades out, then the fifth picture (screen layout $1F, Marin singing): entity
;@ $3E at ($28, $50), three entities $6E (the music notes) at ($18, $4C), ($38, $54) and ($28, $30),
;@ and entity $6F at ($78, $60).
MemoryScene5::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> CheckMemorySkip()
	call CheckMemorySkip
;> if not FadeOutMemory():
;>     return
	call FadeOutMemory
	jr nz, .done

;> wBGMapToLoad = 0x1F
	ld a, $1f
	ld [wBGMapToLoad], a
;> ClearAllEntities()
	call ClearAllEntities
;> slot = SpawnEntity(0x3E)
	ld a, $3e
	call SpawnEntity
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = SpawnEntity(0x6E)
	ld a, $6e
	call SpawnEntity
;> wEntityX[slot] = 0x18
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
;> wEntityY[slot] = 0x4C
	ld hl, wEntityY
	add hl, de
	ld [hl], $4c
;> slot = SpawnEntity(0x6E)
	ld a, $6e
	call SpawnEntity
;> wEntityX[slot] = 0x38
	ld hl, wEntityX
	add hl, de
	ld [hl], $38
;> wEntityY[slot] = 0x54
	ld hl, wEntityY
	add hl, de
	ld [hl], $54
;> slot = SpawnEntity(0x6E)
	ld a, $6e
	call SpawnEntity
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> slot = SpawnEntity(0x6F)
	ld a, $6f
	call SpawnEntity
;> wEntityX[slot] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryFadeIn5()
;@ path: ending/memories
;@ Memories sub-step 10: fades the fifth picture in; it stays $C0 frames.
MemoryFadeIn5::
;> if FadeInMemory():
	call FadeInMemory
	jr nz, .done

;>     wSceneTimer = 0xC0
	ld a, $c0
	ld [wSceneTimer], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryLoadIsland()
;@ path: ending/memories
;@ Memories sub-step 11: fades the last picture out, then requests tile set $1E (the island) and removes
;@ all entities.
MemoryLoadIsland::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> CheckMemorySkip()
	call CheckMemorySkip
;> if not FadeOutMemory():
;>     return
	call FadeOutMemory
	jr nz, .done

;> wTileMapToLoad = 0x1E
	ld a, $1e
	ld [wTileMapToLoad], a
;> ClearAllEntities()
	call ClearAllEntities
;> MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryDrawIsland()
;@ path: ending/memories
;@ Memories sub-step 12: requests screen layout $01, the island of Koholint seen from the sea.
MemoryDrawIsland::
;> wBGMapToLoad = 0x01
	ld a, $01
	ld [wBGMapToLoad], a
;> MemoryNextStep()
	jp MemoryNextStep


;@ def MemoryFadeInIsland()
;@ path: ending/memories
;@ Memories sub-step 13: fades the island in; $A0 frames later it starts to dissolve (wSceneVarB = $FF,
;@ so the first dissolve step is 0).
MemoryFadeInIsland::
;> if FadeInIsland():
	call FadeInIsland
	jr nz, .done

;>     wSceneTimer = 0xA0
	ld a, $a0
	ld [wSceneTimer], a
;>     wSceneVarB = 0xFF
	ld a, $ff
	ld [wSceneVarB], a
;>     MemoryNextStep()
	jp MemoryNextStep


.done
	ret


;@ def MemoryDissolveIsland()
;@ path: ending/memories
;@ Memories sub-step 14: the island vanishes. Plays noise $35 as the wait ends, then every 4 frames
;@ requests the next dissolve step (hBGChangeRequest $0E: DissolveIslandTilesStep in VBlank) until all
;@ 64 pixels of the island tiles are gone; the next sub-step follows $40 frames later.
MemoryDissolveIsland::
;> if wSceneTimer == 1:
	ld a, [wSceneTimer]
	cp $01
	jr nz, .wait

;>     hNoiseSfx = 0x35
	ld hl, hNoiseSfx
	ld [hl], $35

;> if wSceneTimer or hFrameCounter & 3:
;>     return
.wait
	and a
	jr nz, jr_017_5279

	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_5279

;> if wSceneVarB != 0x3F:
	ld a, [wSceneVarB]
	cp $3f
	jr z, .done

;>     wSceneVarB += 1
	inc a
	ld [wSceneVarB], a
;>     hBGChangeRequest = 0x0E          # dissolve one more pixel in VBlank
	ld a, $0e
	ldh [hBGChangeRequest], a
;>     return
	ret


;> wSceneTimer = 0x40
.done
	ld a, $40
	ld [wSceneTimer], a
;> MemoryNextStep()
	jp MemoryNextStep


;@ def MemoryLoadPillar()
;@ path: ending/memories
;@ Memories sub-step 15: after the wait, all palettes go white and tile set $15 is requested (the
;@ cloud pillar with Link on top).
MemoryLoadPillar::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	ret nz

;> wBGPalette = 0
	xor a
	ld [wBGPalette], a
;> wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> wTileMapToLoad = 0x15
	ld a, $15
	ld [wTileMapToLoad], a
;> MemoryNextStep()
	jp MemoryNextStep


jr_017_5279:
	ret


;@ path: ending/memories
;@ Background palette fading the memory pictures in from white: 16 bytes, levels $00, $40, $94, $E4
;@ (read at step + (frame & 3)).
MemoryFadeInBGP::
	db $00, $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4
;@ path: ending/memories
;@ Sprite palette 0 for the same fade: 16 bytes, levels $00, $04, $18, $1C.
MemoryFadeInOBP0::
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c

;@ def FadeInMemory() -> zero
;@ path: ending/memories
;@ One frame of a memory picture fading in from white (a step every 2 frames, background and sprite
;@ palette 0). Returns True (zero flag) when the 12 steps are done (wSceneFadeStep is then 0 again).
;@ test: wSceneFadeStep = rand(0, 11)
FadeInMemory::
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = MemoryFadeInBGP[i]
	ld d, $00
	ld hl, MemoryFadeInBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> return FadeSetOBJ0(MemoryFadeInOBP0, i)
	ld hl, MemoryFadeInOBP0
	jp FadeSetOBJ0


;@ def FadeInIsland() -> zero
;@ path: ending/memories
;@ One frame of the island fading in from white (background palette from FinalFadeIn, a step every
;@ 4 frames). Returns True (zero flag) when the 12 steps are done.
;@ test: wSceneFadeStep = rand(0, 11)
FadeInIsland::
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = FinalFadeIn[i]
	ld d, $00
	ld hl, FinalFadeIn
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> return FadeCheckDone()
	jr FadeCheckDone

;@ path: ending/memories
;@ Background palette fading a memory picture out to white: 16 bytes, levels $E4, $94, $40, $00.
MemoryFadeOutBGP::
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
;@ path: ending/memories
;@ Sprite palette 0 for the same fade: 16 bytes, levels $1C, $18, $04, $00.
MemoryFadeOutOBP0::
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00

;@ def FadeOutMemory() -> zero
;@ path: ending/memories
;@ One frame of a memory picture fading out to white (a step every 16 frames). Returns True (zero
;@ flag) when the 12 steps are done.
;@ test: wSceneFadeStep = rand(0, 11)
FadeOutMemory::
;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = MemoryFadeOutBGP[i]
	ld d, $00
	ld hl, MemoryFadeOutBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> return FadeSetOBJ0(MemoryFadeOutOBP0, i)   # falls through
	ld hl, MemoryFadeOutOBP0

;@ def FadeSetOBJ0(table: hl, i: de) -> zero
;@ path: ending/memories
;@ The shared end of the memory fades: sprite palette 0 = table[i]; then FadeCheckDone: once
;@ wSceneFadeStep has reached 12 it is set back to 0 and True (zero flag) is returned.
;@ test: wSceneFadeStep = rand(0, 12); i = rand(0, 15)
FadeSetOBJ0::
;> wOBJ0Palette = mem[table + i]
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a

;> if wSceneFadeStep != 12:              # (FadeCheckDone)
FadeCheckDone:
	ld a, [wSceneFadeStep]
	cp $0c
;>     return False
	jr nz, .done

;> wSceneFadeStep = 0
	xor a
	ld [wSceneFadeStep], a
;> return True

.done
	ret


;@ def UnusedFadeOut() -> zero
;@ path: unused/ending
;@ A fade that nothing calls: one step every 8 frames with the background palette from
;@ SceneFadeOutPalettes, ending like the other fades in FadeCheckDone.
;@ test: wSceneFadeStep = rand(0, 11)
UnusedFadeOut::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = SceneFadeOutPalettes[i]
	ld d, $00
	ld hl, SceneFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> return FadeCheckDone()
	jr FadeCheckDone

;@ def MemoryShowPillar()
;@ path: ending/memories
;@ Memories sub-step 16: sets the palettes of the cloud pillar ($C9, $1C, $90) and, with the wait
;@ already over, sets it up: the map at $9C00 (tile set $15), Link (pose 0) at ($50, $5C) on the
;@ stairway object (ending object part 0, already in its state 2) at ($40, $60), the stars (part 1),
;@ a black background for now, $A0 frames of rumbling (noise $34) and screen shake.
MemoryShowPillar::
;> wBGPalette = 0xC9
	ld a, $c9
	ld [wBGPalette], a
;> wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0x90
	ld a, $90
	ld [wOBJ1Palette], a
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return ShakeScreenSideways()
	jp nz, ShakeScreenSideways

;> wScreenShakeX = 0
	ld a, $00
	ld [wScreenShakeX], a
;> hLinkAnimationState = 0
	ld a, $00
	ldh [hLinkAnimationState], a
;> wTileMapToLoad = 0x15
	ld a, $15
	ld [wTileMapToLoad], a
;> slot = SpawnEntity(0xE8)               # ending object, part 0
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x40
	ld hl, wEntityX
	add hl, de
	ld [hl], $40
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> wEntityState[slot] = 2
	ld hl, wEntityState
	add hl, de
	ld [hl], $02
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityPrivate1[slot] += 1           # part 1: the stars
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;> hLinkX = 0x50
	ld a, $50
	ldh [hLinkX], a
;> wLCDControl |= 0x08                  # background map at $9C00
	ld hl, wLCDControl
	set 3, [hl]
;> wSceneTimer = 0xA0
	ld a, $a0
	ld [wSceneTimer], a
;> wBGPalette = 0xFF
	ld a, $ff
	ld [wBGPalette], a
;> hLinkY = 0x5C
	ld a, $5c
	ldh [hLinkY], a
;> hNoiseSfx = 0x34
	ld a, $34
	ldh [hNoiseSfx], a
;> MemoryNextStep()
	jp MemoryNextStep


;@ def MemoryPillarShake()
;@ path: ending/memories
;@ Memories sub-step 17: shakes the screen until wSceneTimer runs out, then ends the memories and goes
;@ on with step 20 of ending part 2.
MemoryPillarShake::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return ShakeScreenSideways()
	jp nz, ShakeScreenSideways

;> wScreenShakeX = 0
	ld [wScreenShakeX], a
;> ResetSceneVars()
	call ResetSceneVars
;> EndingNextStep()
	jp EndingNextStep


;@ def EndingPillarScroll()
;@ path: ending/pillar
;@ Step 20 of ending part 2: the view of the cloud pillar scrolls (the background 8 pixels per frame,
;@ Link up 2) until the map is at y $60; then the stairway object in entity slot 15 starts to fade
;@ (its state 3) and the bobbing follows for $40 x 4 frames.
EndingPillarScroll::
;> hLinkY -= 2
	ldh a, [hLinkY]
	sub $02
	ldh [hLinkY], a
;> hBaseScrollY += 8
	ldh a, [hBaseScrollY]
	add $08
	ldh [hBaseScrollY], a
;> if hBaseScrollY == 0x60:
	cp $60
	jr nz, .animate

;>     wEntityState[15] += 1            # the stairway fades away
	ld a, [wEntityState + 15]
	inc a
	ld [wEntityState + 15], a
;>     wSceneSlowTimer = 0x40
	ld a, $40
	ld [wSceneSlowTimer], a
;>     EndingNextStep()
	call EndingNextStep

;> AnimatePillarScene()
.animate
	call AnimatePillarScene
;> return
	ret


;@ path: unused/ending
;@ 9 bytes before PillarShimmerPalettes that nothing reads ($43, $13, $07, $83, $23, $0B, $53, $17, $47:
;@ they look like palette values).
UnusedPaletteBytes::
	db $43, $13, $07, $83, $23, $0b, $53, $17, $47

;@ path: ending/pillar
;@ The three background palettes that the pillar scene cycles through, one every 3 frames (3 bytes:
;@ $27, $4B, $93): the clouds shimmer. Read by AnimatePillarScene.
PillarShimmerPalettes::
	db $27, $4b, $93

;@ path: ending/pillar
;@ Map y positions for the gentle bobbing of the pillar view: 16 bytes ($60-$65 and back), one per
;@ 8 frames. Read by EndingPillarBob.
PillarBobScroll::
	db $60, $60, $61, $62
	db $63, $64, $65, $65, $65, $65, $64, $63, $62, $61, $60, $60

;@ def EndingPillarBob()
;@ path: ending/pillar
;@ Step 21 of ending part 2: while wSceneSlowTimer runs, the view bobs gently up and down
;@ (PillarBobScroll), Link keeps his place on the map and the stars (entity slot 14) drift down.
EndingPillarBob::
;> AnimatePillarScene()
	call AnimatePillarScene
;> if wSceneSlowTimer == 0:
	ld a, [wSceneSlowTimer]
	and a
	jr nz, .bob

;>     return EndingNextStep()
	jp EndingNextStep


;> wEntityY[14] += 8
.bob
	ld a, [wEntityY + 14]
	add $08
	ld [wEntityY + 14], a
;> wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
;> i = (wSceneFadeStep >> 3) & 0x0F
	rra
	rra
	rra
	nop
	and $0f
;> hBaseScrollY = PillarBobScroll[i]
	ld e, a
	ld d, $00
	ld hl, PillarBobScroll
	add hl, de
	ld a, [hl]
	ldh [hBaseScrollY], a
;> LinkFollowsScroll()
	call LinkFollowsScroll
;> return
	ret


;@ def AnimatePillarScene()
;@ path: ending/pillar
;@ Every frame of the pillar scene: Link's pose cycles through 5-12 (one every 8 frames) and the
;@ background palette through PillarShimmerPalettes (one every 3 frames, counted in wEntityWorkRAM).
;@ test: wEntityWorkRAM = rand(0, 2)
AnimatePillarScene::
;>@pose hLinkAnimationState = ((hFrameCounter >> 3) & 7) + 5
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $07
	add $05
;=@pose
	ldh [hLinkAnimationState], a
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, .palette

;>     wSceneTimer = 3
	ld a, $03
	ld [wSceneTimer], a
;>     wEntityWorkRAM += 1
	ld a, [wEntityWorkRAM]
	inc a
	ld [wEntityWorkRAM], a
;>     if wEntityWorkRAM == 3:
	cp $03
	jr nz, .palette

;>         wEntityWorkRAM = 0
	xor a
	ld [wEntityWorkRAM], a

;>@pal wBGPalette = PillarShimmerPalettes[wEntityWorkRAM]
.palette
	ld a, [wEntityWorkRAM]
	ld e, a
	ld d, $00
	ld hl, PillarShimmerPalettes
	add hl, de
	ld a, [hl]
;=@pal
	ld [wBGPalette], a
;> return
	ret


;@ def LinkFollowsScroll()
;@ path: ending/pillar
;@ Keeps Link at map y $9C while the view scrolls: hLinkY = $9C - hBaseScrollY.
LinkFollowsScroll::
;> hLinkY = u8(-hBaseScrollY - 0xA0 + 0x3C)
	ldh a, [hBaseScrollY]
	cpl
	inc a
	sub $a0
	add $3c
	ldh [hLinkY], a
;> return
	ret


;@ path: ending/pillar
;@ The trunk of the cloud pillar, drawn row by row below the picture as the view sinks: 32 background
;@ draw commands of 24 bytes (BG map address $9C00 + n * $20, $13 = 20 tiles, the tiles, 0). Each
;@ row has the blank tile $A0 around 8 trunk tiles in the middle, alternating rows of $80/$81 and
;@ $90/$91. Copied one per 2 frames by EndingPillarSink.
PillarRowCommands::
	db $9c, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $20, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $60, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $a0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $e0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $20, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $60, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $a0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $e0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $20, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $60, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $a0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $e0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $20, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $60, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $a0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80, $81, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $e0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00

;@ def EndingPillarSink()
;@ path: ending/pillar
;@ Step 22 of ending part 2: the view sinks down along the pillar faster and faster (speed + 1 every
;@ 8 frames up to 8 pixels per frame) while the trunk is drawn on below (one row of PillarRowCommands
;@ every 2 frames, 32 rows); Link stays on top and is removed once he is off the screen.
EndingPillarSink::
;> AnimatePillarScene()
	call AnimatePillarScene
;> wEntityY[14] += 4                    # the stars
	ld a, [wEntityY + 14]
	add $04
	ld [wEntityY + 14], a
;> wSceneVarB += 1
	ld a, [wSceneVarB]
	inc a
	ld [wSceneVarB], a
;> if wSceneVarB & 7 == 0 and wSceneVarC != 8:
	and $07
	jr nz, .scroll

	ld a, [wSceneVarC]
	cp $08
	jr z, .scroll

;>     wSceneVarC += 1                  # speed up
	inc a
	ld [wSceneVarC], a

;> hBaseScrollY += wSceneVarC
.scroll
	ld a, [wSceneVarC]
	ld e, a
	ldh a, [hBaseScrollY]
	add e
	ldh [hBaseScrollY], a
;> LinkFollowsScroll()
	call LinkFollowsScroll
;> if hLinkY >= 0xF0:
	ldh a, [hLinkY]
	cp $f0
	jr c, .rows

;>     wEntityStatus[15] = 0            # Link's object has left the screen
	xor a
	ld [wEntityStatus + 15], a

;> if wSceneVarB & 1:
.rows
	ld a, [wSceneVarB]
	and $01
;>     return
	ret nz

;> if wSceneVar1 == 32:
	ld a, [wSceneVar1]
	cp $20
	jr nz, .draw

;>     ResetSceneVars()
	call ResetSceneVars
;>     EndingNextStep()
	call EndingNextStep
;>     return
	ret


;> n = wSceneVar1
.draw
	ld e, a
;> wSceneVar1 += 1
	inc a
	ld [wSceneVar1], a
;>@mul offset = n * 8
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
;=@mul
	rl d
;> double = offset * 2
	ld a, e
	sla e
	rl d
;> offset += double                     # 24 bytes per row
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
;> src = PillarRowCommands + offset
	ld hl, PillarRowCommands
	add hl, de
;>@copy copy(addr(wDrawCommand), src, 24)
	ld de, wDrawCommand
	ld c, $18

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> return
	ret


;@ path: ending/pillar
;@ Background palette fading the pillar scene out to white: 16 bytes, levels $27, $16, $01, $00
;@ (read at step + (frame & 3)).
PillarFadeOutBGP::
	db $27, $27, $27, $27, $16, $16, $16, $16, $01, $01, $01, $01, $00, $00, $00, $00
;@ path: ending/pillar
;@ Sprite palette 0 for the same fade: 16 bytes, $1C, $18, $08, $00 (the first level six entries long).
PillarFadeOutOBP0::
	db $1c, $1c, $1c, $1c, $1c, $1c, $18, $18, $08, $08, $08, $08, $00, $00, $00, $00
;@ path: ending/pillar
;@ Sprite palette 1 for the same fade: 16 bytes, levels $90, $50, $00, $00.
PillarFadeOutOBP1::
	db $90, $90, $90, $90, $50, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00

;@ def EndingPillarFadeOut()
;@ path: ending/pillar
;@ Step 23 of ending part 2: keeps sinking (4 pixels per frame) and fades to white, a step every
;@ 8 frames (12 steps); the next step follows $C0 frames later.
EndingPillarFadeOut::
;> wEntityY[14] += 2
	ld a, [wEntityY + 14]
	add $02
	ld [wEntityY + 14], a
;> hBaseScrollY += 4
	ldh a, [hBaseScrollY]
	add $04
	ldh [hBaseScrollY], a
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     if wSceneFadeStep == 12:
	ld a, [wSceneFadeStep]
	cp $0c
	jr nz, .step

;>         ResetSceneVars()
	call ResetSceneVars
;>         wSceneTimer = 0xC0
	ld a, $c0
	ld [wSceneTimer], a
;>         return EndingNextStep()
	jp EndingNextStep


;>     wSceneFadeStep += 1
.step
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = PillarFadeOutBGP[i]
	ld d, $00
	ld hl, PillarFadeOutBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = PillarFadeOutOBP0[i]
	ld hl, PillarFadeOutOBP0
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = PillarFadeOutOBP1[i]
	ld hl, PillarFadeOutOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def EndingPartDone()
;@ path: ending/pillar
;@ Step 24 of ending part 2: after the wait, removes the objects of slots 14-15, prepares the sea
;@ sounds (the first seagull cry in $80 frames), selects the background map at $9800 again and goes on
;@ to ending part 3 (the sky seen from above).
EndingPartDone::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> wSceneStep = 0
	xor a
	ld [wSceneStep], a
;> wEntityStatus[14] = 0
	ld [wEntityStatus + 14], a
;> wEntityStatus[15] = 0
	ld [wEntityStatus + 15], a
;> wSeaWavesSoundTimer = 0
	ld [wSeaWavesSoundTimer], a
;> wSeagullCryTimer = 0x80
	ld a, $80
	ld [wSeagullCryTimer], a
;> wLCDControl &= ~0x08                 # background map at $9800
	ld hl, wLCDControl
	res 3, [hl]
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]

.done
	ret


;@ def CreditsFarLog()
;@ path: ending/sea
;@ Ending part 4: far out at sea, Link drifts on his log among floating driftwood while the waves
;@ (map row $98E0 and the one above) roll and the sea sounds play. Runs FarLogSteps.
;@ test: skip runs the entities (bank 3)
CreditsFarLog::
;> PlaySeaSounds()
	call PlaySeaSounds
;> AnimateWaterRows(0x98E0)
	ld de, $98e0
	call AnimateWaterRows
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> FarLogSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/sea
;@ The steps of ending part 4 (4 words), indexed by wSceneStep.
FarLogSteps::
	dw FarLogInit
	dw FarLogSpawn
	dw FarLogHold
	dw FarLogDone

;@ def FarLogInit()
;@ path: ending/sea
;@ Step 0 of ending part 4: requests tile set $16.
FarLogInit::
;> wTileMapToLoad = 0x16
	ld a, $16
	ld [wTileMapToLoad], a
;> ResetSceneVars()
	call ResetSceneVars
;> EndingNextStep()
	jp EndingNextStep


;@ def FarLogSpawn()
;@ path: ending/sea
;@ Step 1 of ending part 4: requests screen layout $17 (the sea with clouds on the horizon) and spawns
;@ three ending objects: Link on his log far away (part 4) at ($48, $60) and two pieces of driftwood
;@ (part 5) at ($28, $68) and ($78, $60), the second with sprite variant 1.
FarLogSpawn::
;> wBGMapToLoad = 0x17
	ld a, $17
	ld [wBGMapToLoad], a
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> wEntityPrivate1[slot] = 4            # Link on the log
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $04
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x68
	ld hl, wEntityY
	add hl, de
	ld [hl], $68
;> wEntityPrivate1[slot] = 5            # driftwood
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $05
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> wEntityPrivate1[slot] = 5
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $05
;> wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, de
	inc [hl]
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/sea
;@ Background palette and sprite palette 0 fading in from white for the sea scene of ending part 6
;@ (read by WindFishFliesFadeIn): 16 bytes, levels $00, $05, $19/$1A, $1E.
SeaFadeInPalettes::
	db $00, $00, $00, $00, $05, $05, $05, $05, $19, $19, $1a, $1a, $1e, $1e, $1e, $1e
;@ path: ending/sea
;@ Sprite palette 1 for the same fade: 16 bytes, levels $00, $01, $51/$52, $92.
SeaFadeInOBP1::
	db $00, $00, $00, $00, $00, $01, $01, $01, $51, $51, $52, $52, $92, $92, $92, $92

;@ def FarLogHold()
;@ path: ending/sea
;@ Step 2 of ending part 4: the scene stays for $60 x 4 frames.
FarLogHold::
;> ResetSceneVars()
	call ResetSceneVars
;> wSceneSlowTimer = 0x60
	ld a, $60
	ld [wSceneSlowTimer], a
;> EndingNextStep()
	jp EndingNextStep


;@ def FarLogDone()
;@ path: ending/sea
;@ Step 3 of ending part 4: when the wait is over, removes the objects in slots 12-15 and goes on to
;@ ending part 5.
FarLogDone::
;> if wSceneSlowTimer:
	ld a, [wSceneSlowTimer]
	and a
;>     return
	jr nz, .done

;> wSceneStep = 0
	xor a
	ld [wSceneStep], a
;> wEntityStatus[12] = 0
	ld [wEntityStatus + 12], a
;> wEntityStatus[13] = 0
	ld [wEntityStatus + 13], a
;> wEntityStatus[14] = 0
	ld [wEntityStatus + 14], a
;> wEntityStatus[15] = 0
	ld [wEntityStatus + 15], a
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]

.done
	ret


;@ def CreditsSkyView()
;@ path: ending/sky
;@ Ending part 3: the sea seen from high above, with clouds, two seagulls flying across and a gleam
;@ of light, and the sea sounds. Runs SkyViewSteps.
;@ test: skip runs the entities (bank 3)
CreditsSkyView::
;> PlaySeaSounds()
	call PlaySeaSounds
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> SkyViewSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/sky
;@ The steps of ending part 3 (5 words), indexed by wSceneStep.
SkyViewSteps::
	dw SkyViewInit
	dw SkyViewSpawn
	dw SkyViewFadeIn
	dw SkyViewWait
	dw SkyViewDone

;@ def SkyViewInit()
;@ path: ending/sky
;@ Step 0 of ending part 3: requests tile set $17, resets the scroll and the shake and starts
;@ music $3D.
SkyViewInit::
;> wTileMapToLoad = 0x17
	ld a, $17
	ld [wTileMapToLoad], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wScreenShakeX = 0
	ld [wScreenShakeX], a
;> wScreenShakeY = 0
	ld [wScreenShakeY], a
;> wMusicTrackToPlay = 0x3D
	ld a, $3d
	ld [wMusicTrackToPlay], a
;> ResetSceneVars()
	call ResetSceneVars
;> EndingNextStep()
	jp EndingNextStep


;@ def SkyViewSpawn()
;@ path: ending/sky
;@ Step 1 of ending part 3: requests screen layout $18 and spawns two seagulls (ending object part 6)
;@ at ($18, $20) flying right and at ($78, $78) flying left (sprite variant 3), and the gleam (part 7)
;@ at ($68, $60); the fade-in starts $60 x 4 frames later.
SkyViewSpawn::
;> wBGMapToLoad = 0x18
	ld a, $18
	ld [wBGMapToLoad], a
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x18
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
;> wEntityY[slot] = 0x20
	ld hl, wEntityY
	add hl, de
	ld [hl], $20
;> wEntityPrivate1[slot] = 6            # seagull
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $06
;> wEntitySpeedX[slot] = 3
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $03
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x78
	ld hl, wEntityX
	add hl, de
	ld [hl], $78
;> wEntityY[slot] = 0x78
	ld hl, wEntityY
	add hl, de
	ld [hl], $78
;> wEntityPrivate1[slot] = 6
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $06
;> wEntitySpeedX[slot] = 0xFD           # -3: to the left
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $fd
;> wEntitySpriteVariant[slot] = 3
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $03
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x68
	ld hl, wEntityX
	add hl, de
	ld [hl], $68
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> wEntityPrivate1[slot] = 7            # the gleam
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $07
;> wSceneSlowTimer = 0x60
	ld a, $60
	ld [wSceneSlowTimer], a
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/sky
;@ Background palette and sprite palette 0 fading the sky view in from white: 20 bytes, read at
;@ step + (frame & 3) with step 0-16 (a step every 16 frames): $00, $05 (8 entries), $19/$1A, $1E.
CloudsFadeInPalettes::
	db $00, $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $19, $19, $1a, $1a
	db $1e, $1e, $1e, $1e

;@ path: ending/sky
;@ Sprite palette 1 for the same fade: 21 bytes, $00, $01, $51/$52, $92.
CloudsFadeInOBP1::
	db $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01
	db $51, $51, $51, $52, $52, $92, $92, $92, $92

;@ def SkyViewFadeIn()
;@ path: ending/sky
;@ Step 2 of ending part 3: fades the sky view in, a step every 16 frames (16 steps); it then stays
;@ $60 x 4 frames.
SkyViewFadeIn::
;> if hFrameCounter & 0x0F == 0:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .palette

;>     if wSceneFadeStep == 16:
	ld a, [wSceneFadeStep]
	cp $10
	jr nz, .step

;>         ResetSceneVars()
	call ResetSceneVars
;>         wSceneSlowTimer = 0x60
	ld a, $60
	ld [wSceneSlowTimer], a
;>         return EndingNextStep()
	jp EndingNextStep


;>     wSceneFadeStep += 1
.step
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = CloudsFadeInPalettes[i]
	ld d, $00
	ld hl, CloudsFadeInPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = CloudsFadeInPalettes[i]
	ld hl, CloudsFadeInPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = CloudsFadeInOBP1[i]
	ld hl, CloudsFadeInOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def SkyViewWait()
;@ path: ending/sky
;@ Step 3 of ending part 3: waits for wSceneSlowTimer.
SkyViewWait::
;> if wSceneSlowTimer == 0:
	ld a, [wSceneSlowTimer]
	and a
	jr nz, .done

;>     ResetSceneVars()
	call ResetSceneVars
;>     EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ def SkyViewDone()
;@ path: ending/sky
;@ Step 4 of ending part 3: removes the objects in slots 13-15 and goes on to ending part 4.
SkyViewDone::
;> ResetSceneVars()
	call ResetSceneVars
;> wSceneStep = 0
	xor a
	ld [wSceneStep], a
;> wEntityStatus[13] = 0
	ld [wEntityStatus + 13], a
;> wEntityStatus[14] = 0
	ld [wEntityStatus + 14], a
;> wEntityStatus[15] = 0
	ld [wEntityStatus + 15], a
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]
;> return
	ret


;@ def CreditsLinkWakes()
;@ path: ending/wakes
;@ Ending part 5: close up, Link lies on his log in the waves and opens his eyes. Besides the sea sounds
;@ and the rolling water rows, the sea surface heaves: every 5 frames the next value of
;@ WaveRasterScroll (43 steps) goes to wEntityWorkRAM, which the LCD STAT handler uses as the vertical
;@ scroll of the screen below the LYC line ($42) in this part. Then runs LinkWakesSteps.
;@ test: skip runs the entities (bank 3)
CreditsLinkWakes::
;> PlaySeaSounds()
	call PlaySeaSounds
;> AnimateWaterRows(0x98E0)
	ld de, $98e0
	call AnimateWaterRows
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> wSceneVarF += 1
	ld a, [wSceneVarF]
	inc a
	ld [wSceneVarF], a
;> if wSceneVarF >= 5:
	cp $05
	jr c, .raster

;>     wSceneVarF = 0
	xor a
	ld [wSceneVarF], a
;>     wSceneFadeStep = (wSceneFadeStep + 1) % 43
	ld a, [wSceneFadeStep]
	inc a
	cp $2b
	jr nz, .store

	xor a

.store
	ld [wSceneFadeStep], a

;>@raster wEntityWorkRAM = WaveRasterScroll[wSceneFadeStep]      # scroll of the lower screen part
.raster
	ld a, [wSceneFadeStep]
	ld e, a
	ld d, $00
	ld hl, WaveRasterScroll
	add hl, de
	ld a, [hl]
;=@raster
	add $00
	ld [wEntityWorkRAM], a
;> LinkWakesSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/wakes
;@ The steps of ending part 5 (5 words), indexed by wSceneStep.
LinkWakesSteps::
	dw LinkWakesInit
	dw LinkWakesSpawn
	dw LinkWakesAnimate
	dw LinkWakesFadeOut
	dw LinkWakesDone

;@ def LinkWakesInit()
;@ path: ending/wakes
;@ Step 0 of ending part 5: requests tile set $18.
LinkWakesInit::
;> wTileMapToLoad = 0x18
	ld a, $18
	ld [wTileMapToLoad], a
;> EndingNextStep()
	jp EndingNextStep


;@ def LinkWakesSpawn()
;@ path: ending/wakes
;@ Step 1 of ending part 5: requests screen layout $19 (Link on his log, close up), allows the STAT
;@ interrupt with LYC $42 for the heaving sea, and spawns three pieces of driftwood riding the waves
;@ (ending object part 8, sprite variants 2, 1 and 0) at ($18, $55), ($68, $58) and ($88, $60) and a
;@ seagull (part 9) at ($08, $50) flying up to the right; the face animation starts $50 x 4 frames
;@ later.
LinkWakesSpawn::
;> wBGMapToLoad = 0x19
	ld a, $19
	ld [wBGMapToLoad], a
;> rIE |= 0x02                          # STAT interrupt
	ld hl, $ffff
	set 1, [hl]
;> rLYC = 0x42
	ld a, $42
	ldh [rLYC], a
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x18
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
;> wEntityY[slot] = 0x55
	ld hl, wEntityY
	add hl, de
	ld [hl], $55
;> wEntityPrivate1[slot] = 8            # driftwood on the waves
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $08
;> wEntitySpriteVariant[slot] = 2
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], $02
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x68
	ld hl, wEntityX
	add hl, de
	ld [hl], $68
;> wEntityY[slot] = 0x58
	ld hl, wEntityY
	add hl, de
	ld [hl], $58
;> wEntityPrivate1[slot] = 8
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $08
;> wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, de
	inc [hl]
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x88
	ld hl, wEntityX
	add hl, de
	ld [hl], $88
;> wEntityY[slot] = 0x60
	ld hl, wEntityY
	add hl, de
	ld [hl], $60
;> wEntityPrivate1[slot] = 8
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $08
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x08
	ld hl, wEntityX
	add hl, de
	ld [hl], $08
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> wEntityPrivate1[slot] = 9            # seagull
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $09
;> wEntitySpeedX[slot] = 8
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], $08
;> wEntitySpeedY[slot] = 0xF8           # -8: upwards
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $f8
;> ResetSceneVars()
	call ResetSceneVars
;> wSceneSlowTimer = 0x50
	ld a, $50
	ld [wSceneSlowTimer], a
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/wakes
;@ The heaving of the sea in ending part 5: vertical scroll values for the lower part of the screen,
;@ 48 bytes of which 43 are used (0 rising to 12 and back; the last 5 are zeros). One step every
;@ 5 frames (CreditsLinkWakes); EndingWaveDebris reads it too, so the driftwood rides the waves.
WaveRasterScroll::
	db $00, $00, $00, $00, $01, $01, $01, $02, $02, $03, $03, $04, $05, $06, $07, $08
	db $09, $0a, $0a, $0b, $0b, $0c, $0c, $0c, $0b, $0b, $0a, $0a, $09, $08, $07, $06
	db $05, $04, $03, $03, $02, $02, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00
;@ path: ending/wakes
;@ The four frames of the wave line behind Link (map row $9A23, 14 tiles): 4 entries of 16 bytes,
;@ each the rest of a background draw command: $0D (14 tiles follow), the 14 tiles, 0 (end).
;@ LinkWakesAnimate writes the address and copies one entry per 8 frames.
WaveRowCommands::
	db $0d, $4c, $4d, $4e, $4f, $4c, $4d, $4e, $4f, $4c, $4d, $4e, $4f, $4c, $4d, $00
	db $0d, $5c, $5d, $5e, $5f, $5c, $5d, $5e, $5f, $5c, $5d, $5e, $5f, $5c, $5d, $00
	db $0d, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $00
	db $0d, $7c, $7d, $7e, $7f, $7c, $7d, $7e, $7f, $7c, $7d, $7e, $7f, $7c, $7d, $00

;@ def LinkWakesAnimate()
;@ path: ending/wakes
;@ Step 2 of ending part 5: every 8 frames the wave line behind Link moves on (WaveRowCommands), on
;@ the other odd frames Link's face is redrawn (DrawLinkWakingFrame); then runs the face's sub-step
;@ wSceneVar1 (LinkFaceSteps).
LinkWakesAnimate::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .face

;>     wDrawCommand[0] = 0x9A           # map address $9A23
	ld hl, wDrawCommand
	ld a, $9a
	ld [hli], a
;>     wDrawCommand[1] = 0x23
	ld a, $23
	ld [hli], a
;>     wSceneVarB = (wSceneVarB + 1) & 3
	ld a, [wSceneVarB]
	inc a
	and $03
	ld [wSceneVarB], a
;>@src     src = WaveRowCommands + wSceneVarB * 16
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
;=@src
	ld d, $00
	ld hl, WaveRowCommands
	add hl, de
;>@copy     copy(addr(wDrawCommand) + 2, src, 16)
	ld de, wDrawCommand + 2
	ld c, $10

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

	jr .steps

;> else:
;>     DrawLinkWakingFrame()
.face
	call DrawLinkWakingFrame

;> LinkFaceSteps[wSceneVar1]()
.steps
	ld a, [wSceneVar1]
	rst $00

;@ path: ending/wakes
;@ The sub-steps of Link's face in ending part 5 (3 words), indexed by wSceneVar1.
LinkFaceSteps::
	dw LinkFaceWait
	dw LinkFaceAnimate
	dw LinkFaceDone

;@ def LinkFaceWait()
;@ path: ending/wakes
;@ Face sub-step 0: waits for wSceneSlowTimer, then goes on (LinkFaceNextStep).
LinkFaceWait::
;> if wSceneSlowTimer:
	ld a, [wSceneSlowTimer]
	and a
;>     return
	jr nz, jr_017_5c02

;> wSceneVar1 += 1                      # (LinkFaceNextStep)
LinkFaceNextStep:
	ld hl, wSceneVar1
	inc [hl]

jr_017_5c02:
	ret


;@ path: ending/wakes
;@ The frames Link's face shows one after the other (12 bytes, indexes into LinkWakingFramePointers):
;@ 1, 0, 1, 2, 1, 2 (the eyes flutter), 3-6 (they open), 7, 8.
LinkWakingSequence::
	db $01, $00, $01, $02, $01, $02, $03, $04, $05, $06, $07, $08

;@ path: ending/wakes
;@ How long each frame of LinkWakingSequence stays, in frames (12 bytes).
LinkWakingDurations::
	db $20, $18, $20, $18
	db $18, $18, $20, $40, $0c, $0c, $0c, $40

;@ def LinkFaceAnimate()
;@ path: ending/wakes
;@ Face sub-step 1: whenever wSceneTimer runs out, shows the next frame of LinkWakingSequence (in
;@ wSceneVar2) for its duration; after the 12th frame goes on.
LinkFaceAnimate::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> n = wSceneVarD
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
;> wSceneVar2 = LinkWakingSequence[n]
	ld hl, LinkWakingSequence
	add hl, de
	ld a, [hl]
	ld [wSceneVar2], a
;> wSceneTimer = LinkWakingDurations[n]
	ld hl, LinkWakingDurations
	add hl, de
	ld a, [hl]
	ld [wSceneTimer], a
;> wSceneVarD = n + 1
	ld a, e
	inc a
	ld [wSceneVarD], a
;> if wSceneVarD == 12:
	cp $0c
	jr nz, .done

;>     return LinkFaceNextStep()
	jp LinkFaceNextStep


.done
	ret


;@ def LinkFaceDone()
;@ path: ending/wakes
;@ Face sub-step 2: when the last frame's time is over, starts the fade-out (step 3 of ending part 5).
LinkFaceDone::
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, .done

;>     wSceneVar5 = 0                   # fade step
	xor a
	ld [wSceneVar5], a
;>     EndingNextStep()
	call EndingNextStep
;>     return
	ret


.done
	ret


;@ path: ending/wakes
;@ Background palette and sprite palette 0 fading a sea scene out to white (ending parts 5 and 7):
;@ 16 bytes, $1E, $1A/$19, $05, $00 (read at step + (frame & 3)).
SceneFadeOutPalettes::
	db $1e, $1e, $1e, $1e, $1a, $1a, $19, $19, $05, $05, $05, $05, $00, $00, $00, $00
;@ path: ending/wakes
;@ Sprite palette 1 for the same fade: 16 bytes, $92, $51, $41, $00.
SceneFadeOutOBP1::
	db $92, $92, $92, $92, $92, $92, $51, $51, $41, $41, $00, $00, $00, $00, $00, $00

;@ def LinkWakesFadeOut()
;@ path: ending/wakes
;@ Step 3 of ending part 5: fades to white, a step every 8 frames (12 steps); then all palettes white
;@ and the next part follows $C0 frames later.
LinkWakesFadeOut::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     if wSceneVar5 == 12:
	ld a, [wSceneVar5]
	cp $0c
	jr nz, .step

;>         wSceneTimer = 0xC0
	ld a, $c0
	ld [wSceneTimer], a
;>         wBGPalette = 0
	xor a
	ld [wBGPalette], a
;>         wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;>         wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;>         return EndingNextStep()
	jp EndingNextStep


;>     wSceneVar5 += 1
.step
	inc a
	ld [wSceneVar5], a

;> i = wSceneVar5 + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVar5]
	add e
	ld e, a
;> wBGPalette = SceneFadeOutPalettes[i]
	ld d, $00
	ld hl, SceneFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = SceneFadeOutPalettes[i]
	ld hl, SceneFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = SceneFadeOutOBP1[i]
	ld hl, SceneFadeOutOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def LinkWakesDone()
;@ path: ending/wakes
;@ Step 4 of ending part 5: after the wait, goes on to the next part (CreditsNextScene).
LinkWakesDone::
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, jr_017_5d00

;> CreditsNextScene()                   # falls through

;@ def CreditsNextScene()
;@ path: ending/credits
;@ Ends a part of the ending: removes the objects in slots 7-15, resets the scroll and the scene
;@ variables, turns the STAT interrupt off, selects 8x16 sprites and goes on to the next part (after
;@ the last one back to part 0). The debug skip of CreditsHandler calls it too.
CreditsNextScene::
;> wSceneStep = 0
	xor a
	ld [wSceneStep], a
;>@slots for slot in range(7, 16):
;>     wEntityStatus[slot] = 0
	ld [wEntityStatus + 7], a
	ld [wEntityStatus + 8], a
	ld [wEntityStatus + 9], a
	ld [wEntityStatus + 10], a
	ld [wEntityStatus + 11], a
	ld [wEntityStatus + 12], a
;=@slots
	ld [wEntityStatus + 13], a
	ld [wEntityStatus + 14], a
	ld [wEntityStatus + 15], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wSceneVarF = 0
	ld [wSceneVarF], a
	ld [wSceneVarF], a
;> ResetSceneVars()
	call ResetSceneVars
;> rIE &= ~0x02                         # STAT interrupt off
	ld hl, $ffff
	res 1, [hl]
;> wLCDControl |= 0x04                  # 8x16 sprites
	ld hl, wLCDControl
	set 2, [hl]
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]
;> if wGameplaySubtype == 9:
	ld a, [hl]
	cp $09
	jr nz, jr_017_5d00

;>     wGameplaySubtype = 0
	ld [hl], $00

;> return
jr_017_5d00:
	ret


;@ path: ending/wakes
;@ The 9 frames of Link's face in ending part 5: each 54 bytes, six background draw commands of
;@ 9 bytes for a 6 x 6 tile block at map $9946 (rows 10-15, columns 6-11): BG map address (2 bytes,
;@ big endian), $05 (6 tiles follow), the 6 tiles. Frames 0-6 share the face and differ only in the
;@ eyes (rows 4-5): closed, fluttering, opening; frames 7 and 8 are new drawings of the whole face
;@ (tiles $00-$4A). Tile $AC is blank. Chosen through LinkWakingFramePointers.
LinkWakingFrames::
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 0
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $b6, $b7, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $c6, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 1
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $8a, $8b, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $9a, $9b, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 2
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $8c, $8d, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $9c, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 3
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $8e, $8f, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $9e, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 4
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $e9, $ea, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $f9, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 5
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $eb, $ec, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $fb, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 6
	db $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99
	db $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $ed, $ee, $b8, $b9
	db $99, $e6, $05, $c4, $c5, $fb, $c7, $c8, $c9
	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac   ; frame 7
	db $99, $66, $05, $00, $01, $02, $03, $04, $ac
	db $99, $86, $05, $10, $11, $12, $13, $14, $15
	db $99, $a6, $05, $20, $21, $22, $23, $24, $25
	db $99, $c6, $05, $30, $31, $32, $33, $34, $35
	db $99, $e6, $05, $40, $41, $42, $43, $44, $c9
	db $99, $46, $05, $0c, $0d, $1c, $1d, $ac, $ac   ; frame 8
	db $99, $66, $05, $06, $07, $08, $09, $0a, $ac
	db $99, $86, $05, $16, $17, $18, $19, $1a, $1b
	db $99, $a6, $05, $26, $27, $28, $29, $2a, $2b
	db $99, $c6, $05, $36, $37, $38, $39, $3a, $3b
	db $99, $e6, $05, $46, $47, $48, $49, $4a, $c9

;@ path: ending/wakes
;@ Address of each frame of LinkWakingFrames (9 words, 54 bytes apart).
LinkWakingFramePointers::
	dw LinkWakingFrames + $00, LinkWakingFrames + $36, LinkWakingFrames + $6c
	dw LinkWakingFrames + $a2, LinkWakingFrames + $d8, LinkWakingFrames + $10e
	dw LinkWakingFrames + $144, LinkWakingFrames + $17a, LinkWakingFrames + $1b0

;@ def DrawLinkWakingFrame()
;@ path: ending/wakes
;@ On odd frames queues the 6 rows of Link's face frame wSceneVar2 (LinkWakingFrames) as background
;@ draw commands.
DrawLinkWakingFrame::
;> if hFrameCounter & 1 != 1:
	ldh a, [hFrameCounter]
	and $01
	cp $01
;>     return
	jr nz, .done

;>@src src = mem16[LinkWakingFramePointers + wSceneVar2 * 2]
	ld a, [wSceneVar2]
	sla a
	ld e, a
	ld d, $00
	ld hl, LinkWakingFramePointers
	add hl, de
;=@src
	ld a, [hli]
	ld h, [hl]
	ld l, a
;>@copy copy(addr(wDrawCommand), src, 54)
	ld de, wDrawCommand
	ld c, $36

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> wDrawCommand[54] = 0
	xor a
	ld [de], a

.done
	ret


;@ def CreditsWindFishFlies()
;@ path: ending/windfish_flies
;@ Ending part 6: Link sits on his log and looks up; the view tilts up from the sea into the sky,
;@ where the Wind Fish flies. Runs WindFishFliesSteps.
;@ test: skip runs the entities (bank 3)
CreditsWindFishFlies::
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> WindFishFliesSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/windfish_flies
;@ The steps of ending part 6 (9 words), indexed by wSceneStep.
WindFishFliesSteps::
	dw WindFishFliesInit
	dw WindFishFliesSpawn
	dw WindFishFliesFadeIn
	dw WindFishFliesWait
	dw WindFishFliesFadeInOBP0
	dw WindFishFliesCount
	dw WindFishFliesWait2
	dw WindFishFliesTiltUp
	dw WindFishFliesFadeOut

;@ def WindFishFliesInit()
;@ path: ending/windfish_flies
;@ Step 0 of ending part 6: requests tile set $19.
WindFishFliesInit::
;> wTileMapToLoad = 0x19
	ld a, $19
	ld [wTileMapToLoad], a
;> EndingNextStep()
	jp EndingNextStep


;@ def WindFishFliesSpawn()
;@ path: ending/windfish_flies
;@ Step 1 of ending part 6: requests screen layout $1A (Link sitting on his log) and spawns the Wind
;@ Fish high in the sky (ending object part $0A) at x $40, y $4E. It is spawned into slot 0, whose x
;@ position WindFishFliesTiltUp later uses as the vertical scroll.
WindFishFliesSpawn::
;> wBGMapToLoad = 0x1A
	ld a, $1a
	ld [wBGMapToLoad], a
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x40
	ld hl, wEntityX
	add hl, de
	ld [hl], $40
;> wEntityY[slot] = 0x4E
	ld hl, wEntityY
	add hl, de
	ld [hl], $4e
;> wEntityPrivate1[slot] = 0x0A         # the Wind Fish in the sky
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0a
;> EndingNextStep()
	jp EndingNextStep


;@ def WindFishFliesFadeIn()
;@ path: ending/windfish_flies
;@ Step 2 of ending part 6: the water rows at $9960 roll; fades the picture in, a step every 4 frames
;@ (12 steps); it then stays $60 x 4 frames.
WindFishFliesFadeIn::
;> AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .palette

;>     if wSceneFadeStep == 12:
	ld a, [wSceneFadeStep]
	cp $0c
	jr nz, .step

;>         ResetSceneVars()
	call ResetSceneVars
;>         wSceneSlowTimer = 0x60
	ld a, $60
	ld [wSceneSlowTimer], a
;>         return EndingNextStep()
	jp EndingNextStep


;>     wSceneFadeStep += 1
.step
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wBGPalette = SeaFadeInPalettes[i]
	ld d, $00
	ld hl, SeaFadeInPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = SeaFadeInPalettes[i]  # (written twice)
	ld [wOBJ0Palette], a
	ld hl, SeaFadeInPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = SeaFadeInOBP1[i]
	ld hl, SeaFadeInOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def WindFishFliesWait()
;@ path: ending/windfish_flies
;@ Step 3 of ending part 6: the water rolls until wSceneSlowTimer runs out.
WindFishFliesWait::
;> AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows
;> if wSceneSlowTimer == 0:
	ld a, [wSceneSlowTimer]
	and a
	jr nz, .done

;>     ResetSceneVars()
	call ResetSceneVars
;>     EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ path: ending/windfish_flies
;@ Sprite palette 0 for step 4 of ending part 6: 12 bytes, levels $1E, $2E, $6E (read at
;@ step + (frame & 3), step 0-8).
SittingFadeInOBP0::
	db $1e, $1e, $1e, $1e, $2e, $2e, $2e, $2e, $6e, $6e, $6e, $6e

;@ def WindFishFliesFadeInOBP0()
;@ path: ending/windfish_flies
;@ Step 4 of ending part 6: changes sprite palette 0 through SittingFadeInOBP0, a step every 8
;@ frames (8 steps); the next step follows $20 frames later.
WindFishFliesFadeInOBP0::
;> AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     if wSceneFadeStep == 8:
	ld a, [wSceneFadeStep]
	cp $08
	jr nz, .step

;>         ResetSceneVars()
	call ResetSceneVars
;>         wSceneTimer = 0x20
	ld a, $20
	ld [wSceneTimer], a
;>         return EndingNextStep()
	jp EndingNextStep


;>     wSceneFadeStep += 1
.step
	inc a
	ld [wSceneFadeStep], a

;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wOBJ0Palette = SittingFadeInOBP0[i]
	ld d, $00
	ld hl, SittingFadeInOBP0
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> return
	ret


;@ def WindFishFliesCount()
;@ path: ending/windfish_flies
;@ Step 5 of ending part 6: every $0A frames the Wind Fish shows its next frame (wEntityWorkRAM, read
;@ by EndingWindFishHigh) up to frame 2; the next step follows $20 frames later.
WindFishFliesCount::
;> AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows
;> if wSceneTimer:
	ld a, [wSceneTimer]
	and a
;>     return
	jr nz, .done

;> wSceneTimer = 0x0A
	ld a, $0a
	ld [wSceneTimer], a
;> wEntityWorkRAM += 1
	ld a, [wEntityWorkRAM]
	inc a
	ld [wEntityWorkRAM], a
;> if wEntityWorkRAM == 2:
	cp $02
	jr nz, .done

;>     wSceneTimer = 0x20
	ld a, $20
	ld [wSceneTimer], a
;>     EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ def WindFishFliesWait2()
;@ path: ending/windfish_flies
;@ Step 6 of ending part 6: the water rolls until wSceneTimer runs out.
WindFishFliesWait2::
;> AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, .done

;>     EndingNextStep()
	jp EndingNextStep


.done
	ret


;@ path: ending/windfish_flies
;@ The sky above Link, drawn row by row upwards as the view tilts up in ending part 6: 90 background
;@ draw commands of 24 bytes (BG map address, $13 = 20 tiles, the tiles, 0), row n at $9BE0 - n * $20
;@ (wrapping around the 32-row map). Tile $AC is empty sky, $AE solid cloud, the others cloud edges.
;@ Command n is copied by WindFishFliesTiltUp when the view has moved on by one tile row.
SkyRowCommands::
	db $9b, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $60, $61, $62, $63, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $50, $51, $52, $53, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $60, $61, $62, $63, $ac, $ac, $ac, $00, $9a, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $50, $51, $52, $53, $ac, $ac, $ac, $00
	db $9a, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $60, $61, $00, $9a, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $50, $51, $00
	db $9a, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $00, $13, $6b, $6c, $6d, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $e0, $13, $5b, $5c, $5d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $68
	db $69, $6a, $6b, $6c, $6d, $ac, $ac, $00, $99, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $58, $59, $5a, $5b, $5c, $5d, $ac, $ac, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $68, $69, $00, $99, $40, $13, $ac, $ac, $ac, $ac, $68
	db $69, $6a, $6b, $6c, $6d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $58, $59, $00
	db $99, $20, $13, $ac, $ac, $ac, $ac, $58, $59, $5a, $5b, $5c, $5d, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $40, $41, $42, $43, $00, $98, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $1b, $2e, $2e, $2e, $00
	db $9b, $e0, $13, $41, $42, $43, $54, $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $9c, $9e, $be, $e9, $00, $9b, $c0, $13, $2e, $2e, $2e, $2e, $2f
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $9e, $be, $e9, $f9, $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $43, $54, $55, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $2e, $2e, $2f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $00, $13, $e9, $f9, $fb, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $40, $41, $42, $43, $54, $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $1b, $2e, $2e, $2e, $2e, $2f
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $9c, $9e, $be, $e9, $f9, $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $40, $41, $42, $43, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $1b, $2e, $2e, $2e, $00, $99, $40, $13, $40, $41, $42, $43, $54
	db $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $9c, $9e, $be, $e9, $00
	db $99, $20, $13, $1b, $2e, $2e, $2e, $2e, $2f, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $00, $13, $9c, $9e, $be, $e9, $f9
	db $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $2c, $2d, $ac, $ac, $ac
	db $ac, $ac, $ac, $78, $79, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $ae, $ae, $3d, $3f, $ac, $ac, $ac, $ac, $45, $ae, $2c, $2d, $ac
	db $ac, $ac, $7b, $3d, $3f, $78, $79, $00, $9b, $00, $13, $ae, $ae, $ae, $3e, $ac
	db $ac, $ac, $ac, $72, $ae, $ae, $75, $ac, $ac, $7a, $4b, $ae, $3e, $45, $ae, $00
	db $9a, $e0, $13, $ae, $ae, $ae, $ae, $3d, $3f, $ac, $ac, $56, $73, $74, $67, $ac
	db $ac, $72, $ae, $ae, $ae, $ae, $ae, $00, $9a, $c0, $13, $ae, $ae, $ae, $ae, $ae
	db $3e, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $56, $73, $ae, $ae, $ae, $ae, $00
	db $9a, $a0, $13, $ae, $ae, $ae, $ae, $ae, $75, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $70, $71, $ae, $ae, $00, $9a, $80, $13, $ae, $ae, $ae, $ae, $74
	db $67, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $57, $ae, $ae, $00
	db $9a, $60, $13, $72, $ae, $76, $77, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $7b, $ae, $ae, $00, $9a, $40, $13, $56, $73, $66, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $7a, $4b, $ae, $ae, $00
	db $9a, $20, $13, $ac, $ac, $ac, $7b, $3d, $3f, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $72, $ae, $ae, $ae, $00, $9a, $00, $13, $ac, $ac, $7a, $4b, $ae
	db $3e, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $56, $73, $ae, $ae, $00
	db $99, $e0, $13, $ac, $ac, $72, $ae, $ae, $75, $ac, $ac, $fe, $ff, $05, $0b, $ac
	db $ac, $ac, $ac, $ac, $ac, $70, $71, $00, $99, $c0, $13, $ac, $ac, $56, $73, $74
	db $67, $ac, $ac, $f8, $fa, $fc, $fd, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $57, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $a2, $a3, $bf, $f0, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $84, $85, $9d, $9f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $20, $13, $3c, $ac, $78, $79, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $7b, $3d, $3f, $ac, $ac, $00, $99, $00, $13, $2c, $2d, $45, $ae, $2c
	db $2d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $7a, $4b, $ae, $3e, $ac, $ac, $00
	db $98, $e0, $13, $ae, $ae, $ae, $ae, $ae, $75, $ac, $ac, $ac, $ac, $ac, $ac, $78
	db $79, $ae, $ae, $ae, $ae, $3c, $ac, $00, $98, $c0, $13, $ae, $ae, $ae, $ae, $74
	db $67, $ac, $ac, $ac, $ac, $ac, $ac, $45, $ae, $ae, $ae, $ae, $ae, $2c, $2d, $00
;@ path: ending/windfish_flies
;@ The speed of the tilt for each row of SkyRowCommands: 96 bytes (90 used), in 1/32 pixel per frame
;@ (WindFishFliesTiltUp doubles them into a speed in 1/16 pixel): it speeds up from 2 to $28, holds,
;@ slows down to 4.
SkyScrollSpeeds::
	db $02, $04, $06, $08, $0a, $0c, $0e, $10, $12, $14, $16, $18, $1a, $1c, $1e, $20
	db $22, $24, $26, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $27, $26, $25, $24, $23, $22, $21, $20, $1f, $1e, $1d, $1c, $1b
	db $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10, $0f, $0e, $0d, $0c, $0b
	db $0a, $09, $08, $07, $06, $05, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00
;@ path: ending/windfish_flies
;@ The step into SkyFadeBGP for each row of the tilt: 96 bytes, 0 for the first 22 rows, then 1, 2,
;@ 3 and 4: the sky changes its shades as the view rises.
SkyFadeSteps::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
;@ path: ending/windfish_flies
;@ Background palettes of the sky in ending part 6: 40 bytes, read at step + (frame & 3). Steps 0-4
;@ (during the tilt, from SkyFadeSteps): $1E, $1F, $1A, $15, $10; WindFishFliesFadeOut then counts the
;@ step on to 36 through $10, $15, $19/$1A and back to $1E.
SkyFadeBGP::
	db $1e, $1e, $1e, $1e, $1f, $1f, $1f, $1f, $1a, $1a, $1a, $1a, $15, $15, $15, $15
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $15, $15, $15, $15
	db $19, $19, $1a, $1a, $1e, $1e, $1e, $1e

;@ def WindFishFliesTiltUp()
;@ path: ending/windfish_flies
;@ Step 7 of ending part 6: the view tilts up into the sky. The vertical scroll is the x position of
;@ entity slot 0 (the Wind Fish), moved by UpdateEntityPosX with the speed of the current row; each
;@ time it crosses a tile row the next sky row is drawn (wSceneVarD counts the rows, 89 in all). At
;@ row $44 the glow (part $0B) appears and sprite palette 1 becomes $E3. The water rows roll for the
;@ first 14 rows. Ends with the view at $30 after the last row: then $FF frames of rest before the
;@ fade-out.
WindFishFliesTiltUp::
;> if wSceneVarD < 0x0E:
	ld a, [wSceneVarD]
	cp $0e
	jr nc, .palette

;>     AnimateWaterRows(0x9960)
	ld de, $9960
	call AnimateWaterRows

;>@step wSceneVarC = SkyFadeSteps[wSceneVarD]
.palette
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
	ld hl, SkyFadeSteps
	add hl, de
	ld a, [hl]
;=@step
	ld [wSceneVarC], a
;> i = wSceneVarC + (hFrameCounter & 3)
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVarC]
	add e
	ld e, a
;> wBGPalette = SkyFadeBGP[i]
	ld d, $00
	ld hl, SkyFadeBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> row = wSceneVarD
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
;> if row == 0x59 and hBaseScrollY == 0x30:
	cp $59
	jr nz, .move

	ldh a, [hBaseScrollY]
	cp $30
	jr nz, .move

;>     wSceneTimer3 = 0xFF
	ld a, $ff
	ld [wSceneTimer3], a
;>     wSceneSlowTimer = 0xA8
	ld a, $a8
	ld [wSceneSlowTimer], a
;>     return EndingNextStep()
	jp EndingNextStep


;>@speed wEntitySpeedX[0] = u8(-SkyScrollSpeeds[row] * 2)
.move
	ld hl, SkyScrollSpeeds
	add hl, de
	ld a, [hl]
	cpl
	inc a
	sla a
;=@speed
	ld [wEntitySpeedX], a
;> before = wEntityX[0]
	ld bc, $0000
	ld a, [wEntityX]
	push af
;> UpdateEntityPosX(0)
	call UpdateEntityPosX
;> hBaseScrollY = wEntityX[0]
	ld a, [wEntityX]
	ldh [hBaseScrollY], a
;> if wEntityX[0] & 0xF8 == before & 0xF8:     # still in the same tile row
	and $f8
	ld e, a
	pop af
	and $f8
	cp e
;>     return
	jr z, .done

;> if wSceneVarD == 0x59:
	ld a, [wSceneVarD]
	cp $59
;>     return
	jr z, .done

;> wSceneVarD += 1
	inc a
	ld [wSceneVarD], a
;> if wSceneVarD == 0x44:
	cp $44
	jr nz, .draw

;>     wOBJ1Palette = 0xE3
	ld a, $e3
	ld [wOBJ1Palette], a
;>     slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;>     wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;>     wEntityY[slot] = 0x80
	ld hl, wEntityY
	add hl, de
	ld [hl], $80
;>     wEntityPrivate1[slot] = 0x0B     # the glow
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0b
;>     wEntityTimer[slot] = 0xA8
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $a8

;> n = wSceneVarD
.draw
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
;>@mul offset = n * 8
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
;=@mul
	ld a, e
	ld l, d
;>@add offset += offset * 2                 # 24 bytes per row
	sla e
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
;=@add
	add l
	ld d, a
;> src = SkyRowCommands + offset
	ld hl, SkyRowCommands
	add hl, de
;>@copy copy(addr(wDrawCommand), src, 24)
	ld de, wDrawCommand
	ld c, $18

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

.done
	ret


;@ def WindFishFliesFadeOut()
;@ path: ending/windfish_flies
;@ Step 8 of ending part 6: after $FF frames the sky's palette steps on every 8 frames (SkyFadeBGP up
;@ to step 36); at step 5 the streak of light (part $0C) appears at ($62, $5A) and sprite palette 0
;@ becomes $1E. When wSceneSlowTimer has run out the background goes white and the next part follows.
WindFishFliesFadeOut::
;> if wSceneSlowTimer == 0:
	ld a, [wSceneSlowTimer]
	and a
	jr nz, .palette

;>     wBGPalette = 0
	xor a
	ld [wBGPalette], a
;>     return CreditsNextScene()
	jp CreditsNextScene


;> i = wSceneVarC + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVarC]
	add e
	ld e, a
;> wBGPalette = SkyFadeBGP[i]
	ld d, $00
	ld hl, SkyFadeBGP
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> if wSceneTimer3:
	ld a, [wSceneTimer3]
	and a
;>     return
	jr nz, .done

;> wSceneVarB += 1
	ld a, [wSceneVarB]
	inc a
	ld [wSceneVarB], a
;> if wSceneVarB & 7 or wSceneVarC == 0x24:
;>     return
	and $07
	jr nz, .done

	ld a, [wSceneVarC]
	cp $24
	jr z, .done

;> wSceneVarC += 1
	inc a
	ld [wSceneVarC], a
;> if wSceneVarC == 5:
	cp $05
	jr nz, .done

;>     wOBJ0Palette = 0x1E
	ld a, $1e
	ld [wOBJ0Palette], a
;>     slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;>     wEntityX[slot] = 0x62
	ld hl, wEntityX
	add hl, de
	ld [hl], $62
;>     wEntityY[slot] = 0x5A
	ld hl, wEntityY
	add hl, de
	ld [hl], $5a
;>     wEntityPrivate1[slot] = 0x0C     # the streak
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0c
;>     wEntityTimer[slot] = 0x60
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60

.done
	ret


;@ def CreditsLinkPortrait()
;@ path: ending/portrait
;@ Ending part 7: a large portrait of Link against the sky; he smiles. Runs PortraitSteps.
;@ test: skip runs the entities (bank 3)
CreditsLinkPortrait::
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> PortraitSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/portrait
;@ The steps of ending part 7 (7 words), indexed by wSceneStep.
PortraitSteps::
	dw PortraitInit
	dw PortraitSpawn
	dw PortraitWait
	dw PortraitFadeIn
	dw PortraitSmile
	dw PortraitFadeOut
	dw PortraitDone

;@ def PortraitInit()
;@ path: ending/portrait
;@ Step 0 of ending part 7: requests tile set $1A.
PortraitInit::
;> wTileMapToLoad = 0x1A
	ld a, $1a
	ld [wTileMapToLoad], a
;> EndingNextStep()
	jp EndingNextStep


;@ def PortraitSpawn()
;@ path: ending/portrait
;@ Step 1 of ending part 7: requests screen layout $1B (the sky), sets the palettes ($1E, sprite
;@ palette 0 $6E: the portrait still pale) and spawns the portrait (ending object part $0D) at
;@ ($38, $50).
PortraitSpawn::
;> wBGMapToLoad = 0x1B
	ld a, $1b
	ld [wBGMapToLoad], a
;> ResetSceneVars()
	call ResetSceneVars
;> wBGPalette = 0x1E
	ld a, $1e
	ld [wBGPalette], a
;> wOBJ0Palette = 0x6E
	ld a, $6e
	ld [wOBJ0Palette], a
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x38
	ld hl, wEntityX
	add hl, de
	ld [hl], $38
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> wEntityPrivate1[slot] = 0x0D         # Link's portrait
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0d
;> wSceneTimer = 0x20
	ld a, $20
	ld [wSceneTimer], a
;> EndingNextStep()
	jp EndingNextStep


;@ def PortraitWait()
;@ path: ending/portrait
;@ Step 2 of ending part 7: the sky bobs (BobPortraitScroll) until wSceneTimer runs out.
PortraitWait::
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, BobPortraitScroll

;>     EndingNextStep()
	call EndingNextStep

;> BobPortraitScroll()                  # falls through

;@ def BobPortraitScroll()
;@ path: ending/portrait
;@ The slow up-and-down of the sky behind the portrait: every 4 frames the next of the 49 values of
;@ SeaBobOffsets (wSceneVarF), halved, becomes the vertical scroll.
;@ test: wSceneVarF = rand(0, 48)
BobPortraitScroll::
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .scroll

;>     wSceneVarF = (wSceneVarF + 1) % 49
	ld a, [wSceneVarF]
	inc a
	cp $31
	jr nz, .store

	xor a

.store
	ld [wSceneVarF], a

;>@scroll hBaseScrollY = SeaBobOffsets[wSceneVarF] >> 1           # (b is 0 here)
.scroll
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, SeaBobOffsets
	add hl, de
	ld a, [hl]
;=@scroll
	sra a
	ldh [hBaseScrollY], a
;> return
	ret


;@ path: ending/portrait
;@ Sprite palette 0 bringing the portrait to full strength: 8 bytes, $6E then $1E (read at step +
;@ (frame & 3), step 0-4).
PortraitFadeInOBP0::
	db $6e, $6e, $6e, $6e, $1e, $1e, $1e, $1e

;@ def PortraitFadeIn()
;@ path: ending/portrait
;@ Step 3 of ending part 7: the portrait's palette changes to $1E, a step every 8 frames (4 steps);
;@ then the portrait stays for $FF frames.
PortraitFadeIn::
;> BobPortraitScroll()
	call BobPortraitScroll
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wSceneFadeStep += 1
	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
;>     if wSceneFadeStep == 4:
	cp $04
	jr nz, .palette

;>         wSceneTimer = 0xFF
	ld a, $ff
	ld [wSceneTimer], a
;>         return EndingNextStep()
	jp EndingNextStep


;> i = wSceneFadeStep + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
;> wOBJ0Palette = PortraitFadeInOBP0[i]
	ld d, $00
	ld hl, PortraitFadeInOBP0
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> return
	ret


;@ def PortraitSmile()
;@ path: ending/portrait
;@ Step 4 of ending part 7: while wSceneTimer runs down from $FF, Link's face changes twice (at $50
;@ and $44: wSceneVar3, the frame of LinkFaceSprites); then the fade-out starts $E0 frames later.
PortraitSmile::
;> BobPortraitScroll()
	call BobPortraitScroll
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, .face

;>     wSceneTimer = 0xE0
	ld a, $e0
	ld [wSceneTimer], a
;>     return EndingNextStep()
	jp EndingNextStep


	db $c9                              ; a ret that is never reached

;> if wSceneTimer == 0x44 or wSceneTimer == 0x50:
.face
	cp $44
	jr z, .next

	cp $50
	jr nz, .done

;>     wSceneVar3 += 1                  # next expression
.next
	ld hl, wSceneVar3
	inc [hl]

.done
	ret


;@ def PortraitFadeOut()
;@ path: ending/portrait
;@ Step 5 of ending part 7: after the wait, fades to white with SceneFadeOutPalettes, a step every
;@ 8 frames (12 steps); the next part follows $40 frames later.
PortraitFadeOut::
;> BobPortraitScroll()
	call BobPortraitScroll
;> if hFrameCounter & 7 == 0 and wSceneTimer == 0:
	ld hl, wSceneTimer
	ldh a, [hFrameCounter]
	and $07
	or [hl]
	jr nz, .palette

;>     wSceneVar2 += 1
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
;>     if wSceneVar2 == 12:
	cp $0c
	jr nz, .palette

;>         wSceneTimer = 0x40
	ld a, $40
	ld [wSceneTimer], a
;>         EndingNextStep()
	call EndingNextStep

;> i = wSceneVar2 + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVar2]
	add e
	ld e, a
;> wBGPalette = SceneFadeOutPalettes[i]
	ld d, $00
	ld hl, SceneFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = SceneFadeOutPalettes[i]
	ld hl, SceneFadeOutPalettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = SceneFadeOutOBP1[i]
	ld hl, SceneFadeOutOBP1
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
;> return
	ret


;@ def PortraitDone()
;@ path: ending/portrait
;@ Step 6 of ending part 7: after the wait, goes on to the last part.
PortraitDone::
;> if wSceneTimer == 0:
	ld a, [wSceneTimer]
	and a
	jr nz, .done

;>     return CreditsNextScene()
	jp CreditsNextScene


.done
	ret


;@ def CreditsFinalScene()
;@ path: ending/final
;@ Ending part 8, the last: Link drifts far away on his log, the staff credits roll over the sea
;@ (CreditsRoll), then the view rises into the sky where the Wind Fish flies off, and THE END. Runs
;@ FinalSteps; the water rows at $99A0 keep rolling.
;@ test: skip runs the entities (bank 3)
CreditsFinalScene::
;> AnimateWaterRows(0x99A0)
	ld de, $99a0
	call AnimateWaterRows
;> CreditsRoll()
	call CreditsRoll
;> UpdateEntitiesBank17()
	call UpdateEntitiesBank17
;> FinalSteps[wSceneStep]()
	ld a, [wSceneStep]
	rst $00

;@ path: ending/final
;@ The steps of ending part 8 (6 words), indexed by wSceneStep; the last two do nothing.
FinalSteps::
	dw FinalInit
	dw FinalSpawn
	dw FinalSceneFadeIn
	dw FinalScrollUp
	dw FinalEnd
	dw FinalUnusedStep

;@ def FinalInit()
;@ path: ending/final
;@ Step 0 of ending part 8: requests tile set $1B and selects 8x8 sprites (for the credits letters).
FinalInit::
;> wTileMapToLoad = 0x1B
	ld a, $1b
	ld [wTileMapToLoad], a
;> wLCDControl &= ~0x04                 # 8x8 sprites
	ld hl, wLCDControl
	res 2, [hl]
;> EndingNextStep()
	jp EndingNextStep


;@ def FinalSpawn()
;@ path: ending/final
;@ Step 1 of ending part 8: requests screen layout $1C (sea and clouds), spawns Link on his log (ending
;@ object part $0E) at ($50, $78) and prepares the credits roll (step 0, no title yet), which starts
;@ $B0 x 4 frames later. Restarts the frame counter.
FinalSpawn::
;> wBGMapToLoad = 0x1C
	ld a, $1c
	ld [wBGMapToLoad], a
;> ResetSceneVars()
	call ResetSceneVars
;> slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityX[slot] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;> wEntityY[slot] = 0x78
	ld hl, wEntityY
	add hl, de
	ld [hl], $78
;> wEntityPrivate1[slot] = 0x0E         # Link on his log
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0e
;> wCreditsRollStep = 0
	xor a
	ld [wCreditsRollStep], a
;> wCreditsRole = 0xFF
	dec a
	ld [wCreditsRole], a
;> wSceneSlowTimer = 0xB0
	ld a, $b0
	ld [wSceneSlowTimer], a
;> hFrameCounter = 0
	xor a
	ldh [hFrameCounter], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> EndingNextStep()
	jp EndingNextStep


;@ path: ending/final
;@ Background palette and sprite palette 0 fading in from white: 16 bytes, levels $00, $04, $19, $1E
;@ (read at step + (frame & 3)). Used by FinalSceneFadeIn and FadeInIsland.
FinalFadeIn::
	db $00, $00, $00, $00, $04, $04, $04, $04, $19, $19, $19, $19, $1e, $1e, $1e, $1e

;@ def FinalSceneFadeIn()
;@ path: ending/final
;@ Step 2 of ending part 8: fades the scene in, a step every 8 frames (12 steps); then the view stays
;@ on the sea for $FF x 16 frames while the credits roll.
FinalSceneFadeIn::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette

;>     wSceneVar2 += 1
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
;>     if wSceneVar2 == 12:
	cp $0c
	jr nz, .palette

;>         wSceneVerySlowTimer = 0xFF
	ld a, $ff
	ld [wSceneVerySlowTimer], a
;>         hFrameCounter = 0
	xor a
	ldh [hFrameCounter], a
;>         EndingNextStep()
	call EndingNextStep

;> i = wSceneVar2 + (hFrameCounter & 3)
.palette
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVar2]
	add e
	ld e, a
;> wBGPalette = FinalFadeIn[i]
	ld d, $00
	ld hl, FinalFadeIn
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = FinalFadeIn[i]
	ld [wOBJ0Palette], a
;> return
	ret


;@ def FinalScrollUp()
;@ path: ending/final
;@ Step 3 of ending part 8: after the long wait the view rises by 1 pixel every 8 frames. At map y
;@ $C0 the Wind Fish appears flying off (part $0F) at ($18, $B0); at $A0 Link's log (slot 15) is gone
;@ and a patch of clouds is drawn (DrawFinalPatch); at $70 the view stops (step 4).
FinalScrollUp::
;> if wSceneVerySlowTimer or hFrameCounter & 7:
;>     return
	ld a, [wSceneVerySlowTimer]
	and a
	jr nz, .done

	ldh a, [hFrameCounter]
	and $07
	jr nz, .done

;> hBaseScrollY -= 1
	ld hl, hBaseScrollY
	dec [hl]
;> if hBaseScrollY == 0x70:
	ld a, [hl]
	cp $70
	jr nz, .notTop

;>     return EndingNextStep()
	jp EndingNextStep


;> if hBaseScrollY == 0xA0:
.notTop
	cp $a0
	jr nz, .notPatch

;>     wEntityStatus[15] = 0
	ld hl, wEntityStatus + 15
	ld [hl], $00
;>     return DrawFinalPatch()
	jp DrawFinalPatch


;> if hBaseScrollY == 0xC0:
.notPatch
	cp $c0
	jr nz, .done

;>     slot = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;>     wEntityX[slot] = 0x18
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
;>     wEntityY[slot] = 0xB0
	ld hl, wEntityY
	add hl, de
	ld [hl], $b0
;>     wEntityPrivate1[slot] = 0x0F     # the Wind Fish flying away
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0f

.done
	ret


;@ def FinalEnd()
;@ path: ending/final
;@ Step 4 of ending part 8: the end; nothing more happens (THE END stays until the power is turned
;@ off).
FinalEnd::
;> return
	ret


;@ def FinalUnusedStep()
;@ path: ending/final
;@ Step 5 of ending part 8: never reached, does nothing.
FinalUnusedStep::
;> return
	ret


;@ path: ending/final
;@ Background draw commands (36 bytes, 0 at the end) that patch a group of cloud tiles into the sky
;@ when the view has risen: $99C1 6 tiles ($58-$5D), $99E1 6 tiles ($68-$6D), $99F1 3 tiles
;@ ($58-$5A), $9A11 3 tiles ($68-$6A), $9A20 2 tiles ($5C-$5D). Each command: BG map address (big
;@ endian), count - 1, the tiles.
FinalPatchCommands::
	db $99, $c1, $05, $58, $59, $5a, $5b, $5c, $5d
	db $99, $e1, $05, $68, $69, $6a, $6b, $6c, $6d
	db $99, $f1, $02, $58, $59, $5a
	db $9a, $11, $02, $68, $69, $6a
	db $9a, $20, $01, $5c, $5d
	db $00

;@ def DrawFinalPatch()
;@ path: ending/final
;@ Queues FinalPatchCommands (36 bytes) as the background draw commands.
DrawFinalPatch::
;>@copy copy(addr(wDrawCommand), FinalPatchCommands, 36)
	ld hl, FinalPatchCommands
	ld de, wDrawCommand
	ld c, $24

.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@copy
	dec c
	jr nz, .copy

;> return
	ret


;@ path: ending/objects
;@ The Wind Fish flying away at the very end (ending object part $0F): 4 frames of 10 sprites, each
;@ sprite 4 bytes (y offset, x offset, tile, attributes) relative to the object's position; frame n at
;@ offset n * 40. 8x8 sprites (the last part uses them for the credits).
;@ asset: oam length=$A0
WindFishAwaySprites::
	db $08, $00, $5c, $00, $10, $00, $5d, $00, $00, $08, $c0, $00, $08, $08, $c1, $00
	db $00, $10, $ce, $00, $08, $10, $cf, $00, $00, $18, $de, $00, $08, $18, $df, $00
	db $00, $20, $ea, $00, $08, $20, $eb, $00, $08, $00, $5e, $00, $10, $00, $5f, $00
	db $00, $08, $c0, $00, $08, $08, $c1, $00, $00, $10, $ce, $00, $08, $10, $cf, $00
	db $00, $18, $de, $00, $08, $18, $df, $00, $00, $20, $ea, $00, $08, $20, $eb, $00
	db $08, $00, $ec, $00, $10, $00, $ed, $00, $00, $08, $d0, $00, $08, $08, $d1, $00
	db $00, $10, $ce, $00, $08, $10, $cf, $00, $00, $18, $de, $00, $08, $18, $df, $00
	db $00, $20, $ea, $00, $08, $20, $eb, $00, $08, $00, $ee, $00, $10, $00, $ef, $00
	db $00, $08, $d0, $00, $08, $08, $d1, $00, $00, $10, $ce, $00, $08, $10, $cf, $00
	db $00, $18, $de, $00, $08, $18, $df, $00, $00, $20, $ea, $00, $08, $20, $eb, $00

;@ def EndingWindFishAway(slot: bc)
;@ path: ending/objects
;@ Ending object part $0F: the small Wind Fish that flies away over the clouds after the credits,
;@ drawn relative to the view, flapping (a frame every 32 frames). Every other frame it moves right
;@ and up (speed 4, -1); once past x $A8 it ends the scene (EndingNextStep) and removes itself.
EndingWindFishAway::
;> wOAMNextIndex = 0x3C
	ld a, $3c
	ld [wOAMNextIndex], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY - hBaseScrollY)
	ldh a, [hBaseScrollY]
	ld e, a
	ldh a, [hActiveEntityDrawY]
	sub e
	ldh [hActiveEntityDrawY], a
;>@frame frame = (hFrameCounter >> 5) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@frame
	rra
	and $03
;> offset = frame * 8
	rla
	rla
	rla
	and $f8
	ld e, a
;> offset += frame * 32                 # 40 bytes per frame
	rla
	rla
	and $e0
	add e
	ld e, a
;> DrawEntitySpritesAtOAMStart(WindFishAwaySprites + offset, 10)     # draw 10 sprites at the start of the OAM buffer
	ld d, b
	ld hl, WindFishAwaySprites
	add hl, de
	ld c, $0a
	call DrawEntitySpritesAtOAMStart
;> ReserveOAMEntriesFar(10)                        # reserve the OAM entries
	ld a, $0a
	call ReserveOAMEntriesFar
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
;>     return
	jr nz, .done

;> wEntitySpeedX[slot] = 4
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $04
;> wEntitySpeedY[slot] = 0xFF
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $ff
;> UpdateEntityPosition(slot)
	call UpdateEntityPosition
;> if hActiveEntityX < 0xA8:
	ldh a, [hActiveEntityX]
	cp $a8
;>     return
	ret c

;> EndingNextStep()
	call EndingNextStep
;> return RemoveEndingObject(slot)
	jp RemoveEndingObject


.done
	ret


;@ path: ending/objects
;@ The seagull of the very end (ending object part $10): 4 frames of 8 sprites (y offset, x offset,
;@ tile, attributes), frame n at offset n * 32.
;@ asset: oam length=$80
LastSeagullSprites::
	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60

;@ def EndingLastSeagull(slot: bc)
;@ path: ending/objects
;@ Ending object part $10, sent after THE END (CreditsRollSendBird): a seagull that flies across the
;@ sky, rising more and more steeply, and cries every 128 frames. It is only drawn when wDeathCount is
;@ 0 - a reward for finishing the game without dying; otherwise only its cries are heard.
EndingLastSeagull::
;> if wDeathCount == 0:
	ld hl, wDeathCount
	ld a, [hli]
	or [hl]
	jr nz, .move

;>     wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;>     wOAMNextIndex = 0x3C
	ld a, $3c
	ld [wOAMNextIndex], a
;>     frame = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;>     offset = frame * 32
	rla
	rla
	rla
	rla
	rla
	and $e0
;>     DrawEntitySpritesAtOAMStart(LastSeagullSprites + offset, 8)
	ld e, a
	ld d, b
	ld hl, LastSeagullSprites
	add hl, de
	ld c, $08
	call DrawEntitySpritesAtOAMStart
;>     ReserveOAMEntriesFar(8)
	ld a, $08
	call ReserveOAMEntriesFar

;> UpdateEntityPosition(slot)
.move
	call UpdateEntityPosition
;>@cond if hFrameCounter & 0x0F == 0 and wEntitySpeedY[slot] != 0xFC:
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .edge

;=@cond
	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $fc
	jr z, .edge

;>     wEntitySpeedY[slot] -= 1         # rise faster
	dec [hl]

;> if hActiveEntityX == 0xA8:
.edge
	ldh a, [hActiveEntityX]
	cp $a8
;>     return RemoveEndingObject(slot)
	jp z, RemoveEndingObject

;> wEntityPrivateCounter[slot] += 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityPrivateCounter[slot] & 0x7F == 0:
	and $7f
	jr nz, .done

;>     hJingle = 0x21                   # the seagull cries
	ld a, $21
	ldh [hJingle], a

.done
	ret


;@ path: ending/objects
;@ Link on his log, far away on the sea, during the credits (ending object part $0E): 4 frames of
;@ 12 sprites (y offset, x offset, tile, attributes), frame n at offset n * 48.
;@ asset: oam length=$C0
LinkOnLogSprites::
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $60, $00, $18, $f8, $61, $00, $10, $00, $62, $00, $18, $00, $63, $00
	db $10, $08, $64, $00, $18, $08, $65, $00, $10, $10, $66, $00, $18, $10, $67, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $68, $00, $18, $f8, $69, $00, $10, $00, $6a, $00, $18, $00, $6b, $00
	db $10, $08, $6c, $00, $18, $08, $6d, $00, $10, $10, $6e, $00, $18, $10, $6f, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $70, $00, $18, $f8, $71, $00, $10, $00, $72, $00, $18, $00, $73, $00
	db $10, $08, $74, $00, $18, $08, $75, $00, $10, $10, $76, $00, $18, $10, $77, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $78, $00, $18, $f8, $79, $00, $10, $00, $7a, $00, $18, $00, $7b, $00
	db $10, $08, $7c, $00, $18, $08, $7d, $00, $10, $10, $7e, $00, $18, $10, $7f, $00

;@ def EndingLinkOnLog(slot: bc)
;@ path: ending/objects
;@ Ending object part $0E: Link on his log during the credits, bobbing with the waves (SeaBobOffsets,
;@ a step every 4 frames), drawn relative to the view, 4 frames of animation (one every 8 frames).
EndingLinkOnLog::
;> wOAMNextIndex = 0x3C
	ld a, $3c
	ld [wOAMNextIndex], a
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .draw

;>     wSceneVarF = (wSceneVarF + 1) % 49
	ld a, [wSceneVarF]
	inc a
	cp $31
	jr c, .store

	xor a

.store
	ld [wSceneVarF], a

;>@bob bob = SeaBobOffsets[wSceneVarF] >> 1
.draw
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, SeaBobOffsets
	add hl, de
;=@bob
	ldh a, [hBaseScrollY]
	ld d, a
	ld a, [hl]
	sra a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + bob - hBaseScrollY)
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
	sub d
	ldh [hActiveEntityDrawY], a
;> frame = (hFrameCounter >> 3) & 3
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
;> offset = frame * 16
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
;> offset += frame * 32                 # 48 bytes per frame
	rla
	and $e0
	add e
	ld e, a
;> DrawEntitySpritesAtOAMStart(LinkOnLogSprites + offset, 12)
	ld d, b
	ld hl, LinkOnLogSprites
	add hl, de
	ld c, $0c
	call DrawEntitySpritesAtOAMStart
;> ReserveOAMEntriesFar(12)
	ld a, $0c
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: ending/objects
;@ Link's portrait in ending part 7 (ending object part $0D): 27 sprites of 8x16 (y offset, x offset,
;@ tile, attributes) forming the picture, 108 bytes; the face is drawn on top from LinkFaceSprites.
;@ asset: oam length=$6C
LinkPortraitSprites::
	db $00, $00, $00, $00, $00, $08, $02, $00, $00, $10, $04, $00, $00, $18, $06, $00
	db $00, $20, $08, $00, $00, $28, $0a, $00, $10, $20, $14, $00, $10, $28, $16, $00
	db $20, $20, $1e, $00, $20, $28, $20, $00, $30, $00, $50, $00, $30, $08, $22, $00
	db $30, $10, $24, $00, $30, $18, $26, $00, $30, $20, $28, $00, $30, $28, $2a, $00
	db $30, $30, $2c, $00, $30, $38, $2e, $00, $40, $00, $30, $00, $40, $08, $32, $00
	db $40, $10, $34, $00, $40, $18, $36, $00, $40, $20, $38, $00, $40, $28, $3a, $00
	db $40, $30, $3c, $00, $40, $38, $3e, $00, $40, $40, $40, $00

;@ path: ending/objects
;@ The face of Link's portrait: 3 expressions of 7 sprites (y offset, x offset, tile, attributes) plus
;@ 4 unused bytes ($FF), 32 bytes each; wSceneVar3 picks the expression (PortraitSmile).
;@ asset: oam length=$60
LinkFaceSprites::
	db $10, $00, $0c, $00
	db $10, $08, $0e, $00, $10, $10, $10, $00, $10, $18, $12, $00, $20, $08, $18, $00
	db $20, $10, $1a, $00, $20, $18, $1c, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $42, $00, $10, $10, $44, $00, $10, $18, $46, $00, $20, $08, $18, $00
	db $20, $10, $48, $00, $20, $18, $4a, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $56, $00, $20, $08, $18, $00
	db $20, $10, $58, $00, $20, $18, $5a, $00, $ff, $ff, $ff, $ff

;@ def EndingLinkPortrait(slot: bc)
;@ path: ending/objects
;@ Ending object part $0D: Link's portrait, bobbing like the sky behind it (SeaBobOffsets[wSceneVarF]
;@ halved): the 27 picture sprites at the start of the OAM buffer and the 7 face sprites of expression
;@ wSceneVar3 from OAM offset $40.
EndingLinkPortrait::
;>@bob bob = SeaBobOffsets[wSceneVarF] >> 1
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, SeaBobOffsets
	add hl, de
	ld a, [hl]
;=@bob
	sra a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY + bob)
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
	ldh [hActiveEntityDrawY], a
;> DrawEntitySpritesAtOAMStart(LinkPortraitSprites, 27)
	ld hl, LinkPortraitSprites
	ld c, $1b
	call DrawEntitySpritesAtOAMStart
;> ReserveOAMEntriesFar(27)
	ld a, $1b
	call ReserveOAMEntriesFar
;>@face offset = wSceneVar3 * 32
	ld a, [wSceneVar3]
	rla
	rla
	rla
	rla
	rla
;=@face
	and $e0
;> list = LinkFaceSprites + offset
	ld e, a
	ld d, b
	ld hl, LinkFaceSprites
	add hl, de
;> wOAMNextIndex = 0x40
	ld c, $07
	ld a, $40
	ld [wOAMNextIndex], a
;> DrawEntitySprites(list, 7)                   # draw 7 sprites at wOAMNextIndex
	call DrawEntitySprites
;> ReserveOAMEntriesFar(7)
	ld a, $07
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: ending/objects
;@ The streak of light (ending object part $0C): 3 frames of 3 sprites (y offset, x offset, tile,
;@ attributes), 12 bytes each, by sprite variant.
;@ asset: oam length=$24
StreakSprites::
	db $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00
	db $08, $08, $5c, $00, $08, $08, $5c, $00, $00, $00, $70, $00, $08, $08, $5e, $00
	db $08, $10, $60, $00

;@ def EndingStreak(slot: bc)
;@ path: ending/objects
;@ Ending object part $0C, the streak of light at the end of ending part 6: draws its 3 sprites of the
;@ current variant and moves on to the next frame when its timer reads $30 and 1.
EndingStreak::
;> wEntityPhysicsFlags[slot] = 0xC3     # 3 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
;>@offset offset = hActiveEntitySpriteVariant * 12
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	and $fc
	ld e, a
	rla
;=@offset
	and $f8
	add e
	ld e, a
;> DrawEntitySprites(StreakSprites + offset, 3)
	ld d, b
	ld hl, StreakSprites
	add hl, de
	ld c, $03
	call DrawEntitySprites
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t == 1 or t == 0x30:
	cp $01
	jr z, .next

	cp $30
	jr nz, .done

;>     wEntitySpriteVariant[slot] += 1
.next
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]

.done
	ret


;@ path: ending/objects
;@ The ring of light (ending object part $0B): 14 sprites (y offset, x offset, tile, attributes),
;@ 56 bytes.
;@ asset: oam length=$38
GlowRingSprites::
	db $00, $00, $62, $10, $00, $08, $62, $30, $10, $f0, $64, $10, $10, $f8, $66, $10
	db $10, $00, $68, $10, $10, $08, $68, $30, $10, $10, $66, $30, $10, $18, $64, $30
	db $20, $00, $6a, $10, $20, $08, $6a, $30, $30, $f8, $6c, $10, $30, $00, $6e, $10
	db $30, $08, $6e, $30, $30, $10, $6c, $30

;@ def EndingGlowRing(slot: bc)
;@ path: ending/objects
;@ Ending object part $0B: the ring of light that rises into the sky during the tilt of ending part 6,
;@ drawn relative to the view from the start of the entity OAM area, moving up 2/16 pixel per frame.
;@ When its timer first runs out the wave sound $17 plays (state 1 -> 2, then $C0 more frames).
EndingGlowRing::
;> wOAMNextIndex = 0
	xor a
	ld [wOAMNextIndex], a
;> hActiveEntityDrawY = u8(hActiveEntityDrawY - hBaseScrollY)
	ld hl, hBaseScrollY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	ldh [hActiveEntityDrawY], a
;> DrawEntitySprites(GlowRingSprites, 14)
	ld hl, GlowRingSprites
	ld c, $0e
	call DrawEntitySprites
;> ReserveOAMEntriesFar(14)
	ld a, $0e
	call ReserveOAMEntriesFar
;> wEntitySpeedY[slot] = 0xFE
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fe
;> UpdateEntityPosY(slot)
	call UpdateEntityPosY
;> if hActiveEntityState < 2 and GetEntityTimer(slot) == 0:
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, .done

	call GetEntityTimer
	jr nz, .done

;>     wEntityTimer[slot] = 0xC0
	ld [hl], $c0
;>     IncrementEntityState(slot)                  # next state
	call IncrementEntityState
;>     hWaveSfx = 0x17
	ld a, $17
	ldh [hWaveSfx], a

.done
	ret


;@ path: ending/objects
;@ The Wind Fish high in the sky in ending part 6 (ending object part $0A): 3 frames of 17 sprites of
;@ 8x16 (y offset, x offset, tile, attributes), 68 bytes each; wEntityWorkRAM picks the frame.
;@ asset: oam length=$CC
WindFishSprites::
	db $00, $08, $b2, $00, $00, $10, $b4, $00, $00, $18, $b6, $00, $00, $20, $b8, $00
	db $10, $10, $ba, $00, $10, $18, $bc, $00, $10, $20, $86, $00, $20, $00, $88, $00
	db $20, $08, $8a, $00, $20, $10, $8c, $00, $20, $18, $8e, $00, $20, $20, $94, $00
	db $30, $00, $98, $00, $30, $08, $9a, $00, $30, $10, $a4, $00, $30, $18, $a8, $00
	db $30, $20, $aa, $00, $00, $08, $c2, $00, $00, $10, $c4, $00, $00, $18, $c6, $00
	db $00, $20, $c8, $00, $10, $10, $ca, $00, $10, $18, $cc, $00, $10, $20, $96, $00
	db $20, $00, $88, $00, $20, $08, $8a, $00, $20, $10, $8c, $00, $20, $18, $8e, $00
	db $20, $20, $94, $00, $30, $00, $98, $00, $30, $08, $9a, $00, $30, $10, $a4, $00
	db $30, $18, $a8, $00, $30, $20, $aa, $00, $00, $08, $d2, $00, $00, $10, $d4, $00
	db $00, $18, $d6, $00, $00, $20, $d8, $00, $10, $10, $da, $00, $10, $18, $dc, $00
	db $10, $20, $a6, $00, $20, $00, $88, $00, $20, $08, $8a, $00, $20, $10, $8c, $00
	db $20, $18, $8e, $00, $20, $20, $94, $00, $30, $00, $98, $00, $30, $08, $9a, $00
	db $30, $10, $a4, $00, $30, $18, $a8, $00, $30, $20, $aa, $00

;@ path: ending/objects
;@ The rocking of the sea: 49 bytes (0 rising to 8 and back), one step every 4 frames
;@ (wSceneVarF). Used by the objects on the sea and the bobbing sky of the portrait.
SeaBobOffsets::
	db $00, $00, $00, $00
	db $00, $00, $01, $01, $01, $01, $02, $02, $02, $03, $03, $04, $05, $05, $06, $06
	db $06, $07, $07, $07, $07, $08, $08, $08, $08, $08, $08, $07, $07, $07, $07, $06
	db $06, $06, $05, $05, $04, $03, $02, $02, $02, $01, $01, $01, $01

;@ def EndingWindFishHigh(slot: bc)
;@ path: ending/objects
;@ Ending object part $0A: the Wind Fish high above Link in ending part 6. It moves with the view at
;@ 1.5 times its speed (so it seems farther away) and bobs; it is removed once below the screen.
;@ wEntityWorkRAM (0-2) is its frame.
EndingWindFishHigh::
;> wOAMNextIndex = 0
	ld a, $00
	ld [wOAMNextIndex], a
;> hMultiPurpose0 = u8(hBaseScrollY + (((hBaseScrollY ^ 0x80) - 0x80) >> 1))     # 1.5 x the scroll
	ldh a, [hBaseScrollY]
	ld d, a
	sra a
	add d
	ldh [hMultiPurpose0], a
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .draw

;>     wSceneVarF = (wSceneVarF + 1) % 49
	ld a, [wSceneVarF]
	inc a
	cp $31
	jr c, .store

	xor a

.store
	ld [wSceneVarF], a

;>@y y = u8(hActiveEntityDrawY + SeaBobOffsets[wSceneVarF] - hMultiPurpose0)
.draw
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, SeaBobOffsets
	add hl, de
;=@y
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld hl, hMultiPurpose0
	sub [hl]
;> hActiveEntityDrawY = y
	ldh [hActiveEntityDrawY], a
;> if y >= 0xA8:
	cp $a8
;>     return RemoveEndingObject(slot)
	jp nc, RemoveEndingObject

;> offset = wEntityWorkRAM * 4
	ld a, [wEntityWorkRAM]
	rla
	rla
	and $fc
	ld e, a
;> offset += wEntityWorkRAM * 64        # 68 bytes per frame
	rla
	rla
	rla
	rla
	and $c0
	add e
;> DrawEntitySprites(WindFishSprites + offset, 17)
	ld e, a
	ld d, b
	ld hl, WindFishSprites
	add hl, de
	ld c, $11
	call DrawEntitySprites
;> ReserveOAMEntriesFar(17)
	ld a, $11
	call ReserveOAMEntriesFar
;> return
	ret


;@ path: ending/objects
;@ The gleam on the sea in ending part 3 (ending object part 7): 3 sprites (y offset, x offset, tile,
;@ attributes), 12 bytes.
;@ asset: oam length=$0C
SkyStreakSprites::
	db $00, $00, $70, $00, $08, $08, $5e, $00, $08, $10, $60, $00

;@ def EndingSkyStreak(slot: bc)
;@ path: ending/objects
;@ Ending object part 7: the gleam of light in the sky view of ending part 3; draws its 3 sprites.
EndingSkyStreak::
;> wEntityPhysicsFlags[slot] = 0xC3     # 3 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
;> DrawEntitySprites(SkyStreakSprites, 3)
	ld hl, SkyStreakSprites
	ld c, $03
	call DrawEntitySprites
;> return
	ret


;@ path: ending/objects
;@ The seagull of the sky view (ending object part 6): 6 frames of one 8x16 sprite, 2 bytes each (tile,
;@ attributes), by sprite variant; drawn by DrawEntity8x16.
SeagullFrames::
	db $50, $00, $52, $00, $54, $00, $56, $00, $57, $00, $5a, $00

;@ def EndingSeagull(slot: bc)
;@ path: ending/objects
;@ Ending object part 6: a seagull gliding across the sky view of ending part 3, flapping through its
;@ 6 frames (one every 8 frames), mirrored when it flies to the left; removed past x $B0.
EndingSeagull::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .draw

;>@var     wEntitySpriteVariant[slot] = (wEntitySpriteVariant[slot] + 1) % 6
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, .store

;=@var
	xor a

.store
	ld [hl], a

;> wEntityPhysicsFlags[slot] = 0xC1     # 1 sprite
.draw
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
;> if wEntitySpeedX[slot] & 0x80:       # flying left
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr z, .sprite

;>     hActiveEntityFlipAttribute |= 0x20                  # mirror it
	ld hl, hActiveEntityFlipAttribute
	set 5, [hl]

;> DrawEntity8x16(SeagullFrames)             # draw one sprite of the variant
.sprite
	ld de, SeagullFrames
	call DrawEntity8x16
;> UpdateEntityPosX(slot)
	call UpdateEntityPosX
;> if hActiveEntityX >= 0xB0:
	ldh a, [hActiveEntityX]
	cp $b0
;>     return RemoveEndingObject(slot)
	jp nc, RemoveEndingObject

;> return
	ret


;@ path: ending/objects
;@ Link on his log far out at sea (ending object part 4), first frame: 7 sprites (y offset, x offset,
;@ tile, attributes), 28 bytes. Alternates with FarLogSpritesB every 16 frames.
;@ asset: oam length=$1C
FarLogSpritesA::
	db $00, $08, $0e, $00, $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $50, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $58, $00

;@ path: ending/objects
;@ The second frame of Link on his log far out at sea: 7 sprites, 28 bytes (the log differs).
;@ asset: oam length=$1C
FarLogSpritesB::
	db $00, $08, $0e, $00
	db $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $60, $00, $10, $08, $62, $00
	db $10, $10, $64, $00, $10, $18, $68, $00

;@ path: ending/objects
;@ The bobbing of Link's log far out at sea: 8 bytes (0-2 pixels down), one step every 16 frames.
FarLogBobOffsets::
	db $00, $00, $00, $01, $02, $02, $02, $01
;@ path: ending/objects
;@ The bobbing of the driftwood far out at sea: 8 bytes (0 or 1 pixel down), one step every
;@ 16 frames, each piece with its own phase.
DebrisBobOffsets::
	db $00, $00, $00, $00, $01, $01, $01, $01

;@ def EndingFarLog(slot: bc)
;@ path: ending/objects
;@ Ending object part 4: Link on his log far out at sea (ending part 4), bobbing gently; the log's two
;@ frames alternate every 16 frames. Its 7 sprites start at the beginning of the entity OAM area.
EndingFarLog::
;> wEntityPhysicsFlags[slot] = 0xC7     # 7 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c7
;> wOAMNextIndex = 0
	ld a, $00
	ld [wOAMNextIndex], a
;> i = (hFrameCounter >> 4) & 7
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
;>@bob hActiveEntityDrawY = u8(hActiveEntityDrawY + FarLogBobOffsets[i])
	ld e, a
	ld d, b
	ld hl, FarLogBobOffsets
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
;=@bob
	ldh [hActiveEntityDrawY], a
;> sprites = FarLogSpritesA
	ld hl, FarLogSpritesA
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr z, .draw

;>     sprites = FarLogSpritesB
	ld hl, FarLogSpritesB

;> DrawEntitySprites(sprites, 7)
.draw
	ld c, $07
	call DrawEntitySprites
;> return
	ret


;@ path: ending/objects
;@ The driftwood far out at sea (ending object part 5): 2 sprite variants of one 8x16 sprite (tile,
;@ attributes): tile $5A or $6A.
DebrisFrames::
	db $5a, $00, $6a, $00

;@ def EndingDebris(slot: bc)
;@ path: ending/objects
;@ Ending object part 5: a piece of driftwood floating near Link's log in ending part 4, bobbing with
;@ a phase that depends on its slot.
EndingDebris::
;> wEntityPhysicsFlags[slot] = 0xC1     # 1 sprite
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
;>@phase i = ((slot * 2) & 6) + (hFrameCounter >> 4) & 7
	ld a, c
	rla
	and $06
	ld e, a
	ldh a, [hFrameCounter]
	rra
;=@phase
	rra
	rra
	rra
	add e
	and $07
;>@bob hActiveEntityDrawY = u8(hActiveEntityDrawY + DebrisBobOffsets[i])
	ld e, a
	ld d, b
	ld hl, DebrisBobOffsets
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
;=@bob
	ldh [hActiveEntityDrawY], a
;> DrawEntity8x16(DebrisFrames)
	ld de, DebrisFrames
	call DrawEntity8x16
;> return
	ret


;@ path: ending/objects
;@ The driftwood riding the waves in ending part 5 (ending object part 8): 3 sprite variants of two
;@ 8x8-wide sprite halves, 4 bytes each (tile and attributes of the left half, then of the right
;@ half; attribute $20 = mirrored), drawn by DrawEntity16x16.
WaveDebrisFrames::
	db $54, $00, $64, $00, $64, $20, $54, $20, $4e, $00, $7e, $00

;@ def EndingWaveDebris(slot: bc)
;@ path: ending/objects
;@ Ending object part 8: a piece of driftwood that rides the heaving sea of ending part 5: it follows
;@ WaveRasterScroll (the scroll of the lower screen) with a phase by variant (0: the current step,
;@ 1: 6 steps ahead, 2: $18 steps ahead and half as high), moving half (or a quarter) as far as the
;@ water.
EndingWaveDebris::
;> wEntityPhysicsFlags[slot] = 0xC2     # 2 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
;> if hActiveEntitySpriteVariant == 1:
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr z, .ahead6

;>@ahead6     step = (wSceneFadeStep + 6) % 43
;> elif hActiveEntitySpriteVariant == 2:
	cp $02
	jr z, .ahead24

;>@ahead24     step = (wSceneFadeStep + 0x18) % 43
;> else:
;>     step = wSceneFadeStep
	ld a, [wSceneFadeStep]

;>@h h = (((WaveRasterScroll[step] - 4) & 0xFF) ^ 0x80) - 0x80   # signed height of the water
.look
	ld e, a
	ld d, b
	ld hl, WaveRasterScroll
	add hl, de
	ld a, [hl]
	sub $04

;>@high if hActiveEntitySpriteVariant == 2: h >>= 1
;>@y hActiveEntityDrawY = u8(hActiveEntityDrawY + ((-h) >> 1))
.move
	cpl
	inc a
	sra a
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
;=@y
	ldh [hActiveEntityDrawY], a
;> DrawEntity16x16(WaveDebrisFrames)          # draw the two halves
	ld de, WaveDebrisFrames
	call DrawEntity16x16
;> return
	ret


.ahead6
;=@ahead6
	ld a, [wSceneFadeStep]
	add $06
	cp $2b
	jr c, .wrapped6

	sub $2b

.wrapped6
	jr .look

.ahead24
;=@ahead24
	ld a, [wSceneFadeStep]
	add $18
	cp $2b
	jr c, .wrapped24

	sub $2b

.wrapped24
;=@h
	ld e, a
	ld d, $00
	ld hl, WaveRasterScroll
	add hl, de
	ld a, [hl]
	sub $04
;=@high
	sra a
	jr .move

;@ path: ending/objects
;@ The seagull flying up out of ending part 5 (ending object part 9): 6 sprite variants of two
;@ halves, 4 bytes each (tile and attributes of the left half, then of the right half; $20 =
;@ mirrored, so each frame is symmetric), drawn by DrawEntity16x16.
FlyingBirdFrames::
	db $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20, $78, $00, $78, $20
	db $7a, $00, $7a, $20, $7c, $00, $7c, $20

;@ path: ending/objects
;@ How many frames each wing beat of FlyingBirdFrames lasts (6 bytes).
FlyingBirdDurations::
	db $08, $06, $06, $06, $06, $08

;@ def EndingFlyingSeagull(slot: bc)
;@ path: ending/objects
;@ Ending object part 9: a seagull that flies up and away to the right in ending part 5, beating its
;@ wings (FlyingBirdDurations) and levelling off a little every 32 frames; removed past x $B0.
EndingFlyingSeagull::
;> wEntityPhysicsFlags[slot] = 0xC2     # 2 sprites
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
;> DrawEntity16x16(FlyingBirdFrames)
	ld de, FlyingBirdFrames
	call DrawEntity16x16
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .rise

;>@var     wEntitySpriteVariant[slot] = (wEntitySpriteVariant[slot] + 1) % 6
	push hl
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
;=@var
	cp $06
	jr nz, .store

	xor a

.store
	ld [hl], a
;>@timer     wEntityTimer[slot] = FlyingBirdDurations[wEntitySpriteVariant[slot]]
	ld e, a
	ld d, b
	ld hl, FlyingBirdDurations
	add hl, de
	ld a, [hl]
	pop hl
;=@timer
	ld [hl], a

;> wEntityPrivateCounter[slot] += 1
.rise
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>@level if wEntityPrivateCounter[slot] & 0x1F == 0 and wEntitySpeedY[slot] != 0xFF:
	and $1f
	jr nz, .move

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
;=@level
	cp $ff
	jr z, .move

;>     wEntitySpeedY[slot] += 1
	inc [hl]

;> UpdateEntityPosition(slot)
.move
	call UpdateEntityPosition
;> if hActiveEntityX >= 0xB0:
	ldh a, [hActiveEntityX]
	cp $b0
;>     return RemoveEndingObject(slot)
	jp nc, RemoveEndingObject

;> return
	ret


;@ path: ending/instruments
;@ The eight instruments (ending object part 3, by sprite variant 0-7): 4 bytes each, tile and
;@ attributes of the left and the right 8x16 half. Tiles $D0-$EE, copied there by
;@ EndingCopyInstrumentTiles.
InstrumentFrames::
	db $d0, $00, $d2, $00, $d4, $00, $d6, $00, $d8, $00, $da, $00, $dc, $00, $de, $00
	db $e0, $00, $e2, $00, $e4, $00, $e6, $00, $e8, $00, $ea, $00, $ec, $00, $ee, $00

;@ def EndingInstrument(slot: bc)
;@ path: ending/instruments
;@ Ending object part 3: one of the eight instruments around Link. Draws itself at its own OAM
;@ entries (wEntityPrivate2 + $50) and moves outwards while its drop timer runs.
EndingInstrument::
;> hMultiPurpose0 = wEntityPrivate2[slot] + 0x50                       # its OAM offset
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	add $50
	ldh [hMultiPurpose0], a
;> DrawInstrumentSprites(InstrumentFrames)
	ld de, InstrumentFrames
	call DrawInstrumentSprites
;> if GetEntityDropTimer(slot) == 0:
	call GetEntityDropTimer
;>     return
	ret z

;> UpdateEntityPosition(slot)
	call UpdateEntityPosition
;> return
	ret


;@ def DrawInstrumentSprites(frames: de)
;@ path: ending/instruments
;@ Writes the two 8x16 sprites of the active ending object straight into the OAM buffer at offset
;@ hMultiPurpose0: frame = the sprite variant (4 bytes: tile, attributes of each half), at the
;@ object's position minus the screen shake; with x flip the halves change sides.
DrawInstrumentSprites::
;>@oam oam = addr(wOAMBuffer) + hMultiPurpose0
	push bc
	push de
	ldh a, [hMultiPurpose0]
	ld e, a
	ld d, b
	ld hl, wOAMBuffer
;=@oam
	add hl, de
	push hl
	pop de
;> mem[oam] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
;> flip = (hActiveEntityFlipAttribute & 0x20) >> 2                     # 8 when mirrored
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	rra
	rra
;> mem[oam + 1] = u8(hActiveEntityX + flip - wScreenShakeX)
	ld hl, hActiveEntityX
	add [hl]
	sub c
	ld [de], a
	inc de
;>@frame frame = frames + hActiveEntitySpriteVariant * 4
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@frame
	rl b
	pop hl
	add hl, bc
;> mem[oam + 2] = mem[frame]
	ld a, [hli]
	ld [de], a
	inc de
;> mem[oam + 3] = mem[frame + 1] ^ hActiveEntityFlipAttribute
	ld a, [hli]
	push hl
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	inc de
;> mem[oam + 4] = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
;>@flip2 flip2 = ((hActiveEntityFlipAttribute & 0x20) ^ 0x20) >> 2           # 8 when not mirrored
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	xor $20
	rra
;=@flip2
	rra
;> mem[oam + 5] = u8(hActiveEntityX + flip2 - wScreenShakeX)
	ld hl, hActiveEntityX
	sub c
	add [hl]
	ld [de], a
	inc de
;> mem[oam + 6] = mem[frame + 2]
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
;> mem[oam + 7] = mem[frame + 3] ^ hActiveEntityFlipAttribute
	ld a, [hl]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
;> return
	pop bc
	ret


;@ def EndingObjectHandler(slot: bc)
;@ path: ending/objects
;@ Entity handler of entity type $E8, the ending object: every figure of the ending scenes that moves
;@ is one of these, its part chosen by wEntityPrivate1 (EndingObjectParts).
EndingObjectHandler::
;> EndingObjectParts[wEntityPrivate1[slot]](slot)
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

;@ path: ending/objects
;@ The parts of the ending object (17 words), indexed by wEntityPrivate1: 0 the stairway with Link,
;@ 1 the stars, 2 the owl, 3 an instrument, 4 Link's log far away, 5 driftwood, 6 a seagull, 7 the
;@ gleam, 8 driftwood on the waves, 9 a flying seagull, $0A the Wind Fish in the sky, $0B the ring of
;@ light, $0C the streak of light, $0D Link's portrait, $0E Link on his log, $0F the Wind Fish flying
;@ away, $10 the last seagull.
EndingObjectParts::
	dw EndingStairway
	dw EndingStars
	dw EndingOwl
	dw EndingInstrument
	dw EndingFarLog
	dw EndingDebris
	dw EndingSeagull
	dw EndingSkyStreak
	dw EndingWaveDebris
	dw EndingFlyingSeagull
	dw EndingWindFishHigh
	dw EndingGlowRing
	dw EndingStreak
	dw EndingLinkPortrait
	dw EndingLinkOnLog
	dw EndingWindFishAway
	dw EndingLastSeagull

;@ def EndingStairway(slot: bc)
;@ path: ending/stairway
;@ Ending object part 0: the stairway on which Link rises from the egg into the night sky, and Link
;@ himself. Draws the stairway, then runs its state (StairwayStates).
EndingStairway::
;> DrawStairway()
	call DrawStairway
;> StairwayStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: ending/stairway
;@ The states of the stairway object (5 words).
StairwayStates::
	dw StairwayDescend
	dw StairwayLinkClimbs
	dw StairwayIdle
	dw StairwayFade
	dw StairwayGone

;@ def StairwayDescend(slot: bc)
;@ path: ending/stairway
;@ State 0: the top of the stairway comes down from above the screen (speed 8/16 pixel per frame). It
;@ runs 8 times from y $E0 to $F0 before going on, so the stairway reaches far up; once its top is
;@ drawn at y $60 the next state follows. Link floats up slowly meanwhile.
StairwayDescend::
;> if hActiveEntityDrawY == 0x60:
	ldh a, [hActiveEntityDrawY]
	cp $60
;>     return IncrementEntityState(slot)           # next state
	jp z, IncrementEntityState

;> wEntitySpeedY[slot] = 8
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $08
;> UpdateEntityPosY(slot)
	call UpdateEntityPosY
;>@loop if wEntityY[slot] == 0xF0 and wEntityPrivate2[slot] < 8:
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nz, .link

;=@loop
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $08
	jr nc, .link

;>     wEntityPrivate2[slot] += 1
	inc a
	ld [hl], a
;>     wEntityY[slot] = 0xE0            # once more from the top
	ld hl, wEntityY
	add hl, bc
	ld [hl], $e0

;> hLinkSpeedY = 0xFF
.link
	ld a, $ff
	ldh [hLinkSpeedY], a
;> AnimateLinkOnStairway()              # falls through

;@ def AnimateLinkOnStairway()
;@ path: ending/stairway
;@ Link's pose alternates between 0 and 1 every 8 frames; then he moves and is drawn
;@ (DrawLinkForEnding).
AnimateLinkOnStairway::
;>@pose hLinkAnimationState = (hFrameCounter >> 3) & 1
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $00
;=@pose
	ldh [hLinkAnimationState], a
;> DrawLinkForEnding()                  # falls through

;@ def DrawLinkForEnding()
;@ path: ending/stairway
;@ Moves Link by his vertical speed (no horizontal speed) and draws him (DrawLinkSprites).
;@ test: skip moves Link through bank 0
DrawLinkForEnding::
;> hLinkSpeedX = 0
	push bc
	xor a
	ldh [hLinkSpeedX], a
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> DrawLinkSprites()
	call DrawLinkSprites
;> return
	pop bc
	ret


;@ def StairwayLinkClimbs(slot: bc)
;@ path: ending/stairway
;@ State 1: Link climbs up (speed -8) until he stands at y $5C; then he takes pose 2 and the owl
;@ (ending object part 2) flies in from the top at x $50 (speed $14 downwards, timer $30).
StairwayLinkClimbs::
;> hLinkSpeedY = 0xF8
	ld a, $f8
	ldh [hLinkSpeedY], a
;> AnimateLinkOnStairway()
	call AnimateLinkOnStairway
;> if hLinkY != 0x5C:
	ldh a, [hLinkY]
	cp $5c
;>     return
	jr nz, .done

;> hLinkSpeedY = 0
	xor a
	ldh [hLinkSpeedY], a
;> hLinkAnimationState = 2
	ld a, $02
	ldh [hLinkAnimationState], a
;> owl = SpawnEntity(0xE8)
	ld a, $e8
	call SpawnEntity
;> wEntityPrivate1[owl] = 2             # the owl
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
;> wEntityX[owl] = 0x50
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
;> wEntityY[owl] = 0
	ld hl, wEntityY
	add hl, de
	ld [hl], $00
;> wEntitySpeedY[owl] = 0x14
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $14
;> wEntityTimer[owl] = 0x30
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30
;> IncrementEntityState(slot)                      # next state
	call IncrementEntityState

.done
	ret


;@ def StairwayIdle()
;@ path: ending/stairway
;@ State 2: Link stands on the stairway.
;@ test: skip moves Link through bank 0
StairwayIdle::
;> DrawLinkForEnding()
	call DrawLinkForEnding
;> return
	ret


;@ def StairwayFade(slot: bc)
;@ path: ending/stairway
;@ State 3 (started by EndingPillarScroll): the stairway disappears in 5 steps of 8 frames (its sprite
;@ variant 0-4, 5 = not drawn), then state 4. Link is moved and drawn twice per frame here.
StairwayFade::
;> DrawLinkForEnding()
	call DrawLinkForEnding
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .draw

;>     wEntityTimer[slot] = 8
	ld [hl], $08
;>     wEntitySpriteVariant[slot] += 1
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wEntitySpriteVariant[slot] == 5:
	cp $05
	jr nz, .draw

;>         IncrementEntityState(slot)              # next state
	call IncrementEntityState

;> DrawLinkForEnding()
.draw
	call DrawLinkForEnding
;> return
	ret


;@ def StairwayGone()
;@ path: ending/stairway
;@ State 4: only Link is left.
;@ test: skip moves Link through bank 0
StairwayGone::
;> DrawLinkForEnding()
	call DrawLinkForEnding
;> return
	ret


;@ path: ending/stairway
;@ The stairway of light that Link climbs into the night sky: 5 sprite lists of 32 sprites (128 bytes
;@ each, 4 bytes per sprite: y offset, x offset, tile, attributes), one per sprite variant 0-4; the
;@ variants are the steps of its fading away (StairwayFade). Each list: sprites 0-11 are the wide top
;@ (6 sprites side by side at y 0 and $10, x 0-$28, the right half mirrored with attribute $30), sprites
;@ 12-31 the shaft below, 2 sprites wide (x $10 and $18) from y $20 down to $B0. All use palette OBP1.
;@ Drawn by DrawStairway, which copies only as many bytes as StairwaySpriteBytes allows.
;@ asset: oam length=$80
StairwaySprites::
	db $00, $00, $10, $10, $00, $08, $04, $10, $00, $10, $06, $10, $00, $18, $06, $30
	db $00, $20, $04, $30, $00, $28, $10, $30, $10, $00, $08, $10, $10, $08, $0a, $10
	db $10, $10, $0c, $10, $10, $18, $0c, $30, $10, $20, $0a, $30, $10, $28, $08, $30
	db $20, $10, $20, $10, $20, $18, $30, $10, $30, $10, $20, $10, $30, $18, $30, $10
	db $40, $10, $20, $10, $40, $18, $30, $10, $50, $10, $20, $10, $50, $18, $30, $10
	db $60, $10, $20, $10, $60, $18, $30, $10, $70, $10, $20, $10, $70, $18, $30, $10
	db $80, $10, $20, $10, $80, $18, $30, $10, $90, $10, $20, $10, $90, $18, $30, $10
	db $a0, $10, $20, $10, $a0, $18, $30, $10, $b0, $10, $20, $10, $b0, $18, $30, $10
	db $00, $00, $12, $10, $00, $08, $14, $10, $00, $10, $16, $10, $00, $18, $16, $30
	db $00, $20, $14, $30, $00, $28, $12, $30, $10, $00, $18, $10, $10, $08, $1a, $10
	db $10, $10, $1c, $10, $10, $18, $1c, $30, $10, $20, $1a, $30, $10, $28, $18, $30
	db $20, $10, $40, $10, $20, $18, $50, $10, $30, $10, $40, $10, $30, $18, $50, $10
	db $40, $10, $40, $10, $40, $18, $50, $10, $50, $10, $40, $10, $50, $18, $50, $10
	db $60, $10, $40, $10, $60, $18, $50, $10, $70, $10, $40, $10, $70, $18, $50, $10
	db $80, $10, $40, $10, $80, $18, $50, $10, $90, $10, $40, $10, $90, $18, $50, $10
	db $a0, $10, $40, $10, $a0, $18, $50, $10, $b0, $10, $40, $10, $b0, $18, $50, $10
	db $00, $00, $22, $10, $00, $08, $24, $10, $00, $10, $26, $10, $00, $18, $26, $30
	db $00, $20, $24, $30, $00, $28, $22, $30, $10, $00, $28, $10, $10, $08, $2a, $10
	db $10, $10, $2c, $10, $10, $18, $2c, $30, $10, $20, $2a, $30, $10, $28, $28, $30
	db $20, $10, $60, $10, $20, $18, $70, $10, $30, $10, $60, $10, $30, $18, $70, $10
	db $40, $10, $60, $10, $40, $18, $70, $10, $50, $10, $60, $10, $50, $18, $70, $10
	db $60, $10, $60, $10, $60, $18, $70, $10, $70, $10, $60, $10, $70, $18, $70, $10
	db $80, $10, $60, $10, $80, $18, $70, $10, $90, $10, $60, $10, $90, $18, $70, $10
	db $a0, $10, $60, $10, $a0, $18, $70, $10, $b0, $10, $60, $10, $b0, $18, $70, $10
	db $00, $00, $32, $10, $00, $08, $34, $10, $00, $10, $36, $10, $00, $18, $36, $30
	db $00, $20, $34, $30, $00, $28, $32, $30, $10, $00, $38, $10, $10, $08, $3a, $10
	db $10, $10, $3c, $10, $10, $18, $3c, $30, $10, $20, $3a, $30, $10, $28, $38, $30
	db $20, $10, $52, $10, $20, $18, $62, $10, $30, $10, $52, $10, $30, $18, $62, $10
	db $40, $10, $52, $10, $40, $18, $62, $10, $50, $10, $52, $10, $50, $18, $62, $10
	db $60, $10, $52, $10, $60, $18, $62, $10, $70, $10, $52, $10, $70, $18, $62, $10
	db $80, $10, $52, $10, $80, $18, $62, $10, $90, $10, $52, $10, $90, $18, $62, $10
	db $a0, $10, $52, $10, $a0, $18, $62, $10, $b0, $10, $52, $10, $b0, $18, $62, $10
	db $00, $00, $42, $10, $00, $08, $44, $10, $00, $10, $46, $10, $00, $18, $46, $30
	db $00, $20, $44, $30, $00, $28, $42, $30, $10, $00, $48, $10, $10, $08, $4a, $10
	db $10, $10, $4c, $10, $10, $18, $4c, $30, $10, $20, $4a, $30, $10, $28, $08, $30
	db $20, $10, $56, $10, $20, $18, $66, $10, $30, $10, $56, $10, $30, $18, $66, $10
	db $40, $10, $56, $10, $40, $18, $66, $10, $50, $10, $56, $10, $50, $18, $66, $10
	db $60, $10, $56, $10, $60, $18, $66, $10, $70, $10, $56, $10, $70, $18, $66, $10
	db $80, $10, $56, $10, $80, $18, $66, $10, $90, $10, $56, $10, $90, $18, $66, $10
	db $a0, $10, $56, $10, $a0, $18, $66, $10, $b0, $10, $56, $10, $b0, $18, $66, $10
;@ path: ending/stairway
;@ How many bytes of the stairway's sprite list DrawStairway copies, by the top's screen y / 16
;@ (16 bytes): $70 (28 sprites) at y $00-$0F, 2 sprites less per 16 pixels down to $30 (the 12 sprites
;@ of the top) from y $80 on; y $E0-$EF (top above the screen) $80 = all 32 sprites, y $F0-$FF $78.
;@ This keeps the shaft from wrapping around to the top of the screen.
StairwaySpriteBytes::
	db $70, $68, $60, $58, $50, $48, $40, $38, $30, $30, $30, $30, $30, $30, $80, $78

;@ def DrawStairway()
;@ path: ending/stairway
;@ Draws the stairway object: copies its sprite list for the current variant (5 = nothing) into the
;@ sprite table from sprite 3 on, adding hActiveEntityDrawY to each y and the object's x (minus
;@ the screen shake) to each x.
DrawStairway::
;> i = hActiveEntityDrawY >> 4
	push bc
	ldh a, [hActiveEntityDrawY]
	swap a
	and $0f
	ld e, a
	ld d, b
;> count = StairwaySpriteBytes[i]        # bytes to copy
	ld hl, StairwaySpriteBytes
	add hl, de
	ld b, [hl]
;> if hActiveEntitySpriteVariant == 5:   # faded away
	ld hl, StairwaySprites
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
;>     return
	jr z, .done

;>@list sprites = StairwaySprites + hActiveEntitySpriteVariant * 0x80
	and a
	jr z, .copy

	ld hl, StairwaySprites + $80
	dec a
	jr z, .copy

;=@list
	ld hl, StairwaySprites + $100
	dec a
	jr z, .copy

;=@list
	ld hl, StairwaySprites + $180
	dec a
	jr z, .copy

	ld hl, StairwaySprites + $200

;>@loop for c in range(count):
.copy
	ld de, wOAMBuffer + $0C
	ld c, $00

;>     if c & 3 == 0:                   # y
.loop
	ld a, c
	and $03
	cp $00
	jr nz, .notY

;>         v = u8(hActiveEntityDrawY + sprites[c])
	ldh a, [hActiveEntityDrawY]
	jr .add

;>     elif c & 3 == 1:                 # x
.notY
	cp $01
	jr nz, .byte

;>@x         v = u8(hActiveEntityX - wScreenShakeX + sprites[c])
	push hl
	ld hl, wScreenShakeX
	ldh a, [hActiveEntityX]
	sub [hl]
	pop hl

.add
;=@x
	add [hl]
	jr .store

;>     else:                            # tile, attributes
;>         v = sprites[c]
.byte
	ld a, [hl]

;>     wOAMBuffer[0x0C + c] = v
.store
	ld [de], a
	inc hl
	inc de
	inc c
;=@loop
	ld a, c
	cp b
	jr nz, .loop

;> return
.done
	pop bc
	ret


;@ def EndingStars(slot: bc)
;@ path: ending/objects
;@ Ending object part 1: the twinkling stars of the night sky (DrawStars).
EndingStars::
;> DrawStars()
	call DrawStars
;> return
	ret


;@ path: ending/objects
;@ The x positions of the 16 stars of the night sky: 16 bytes, read by DrawStars.
StarsX::
	db $20, $40, $60, $78, $10, $48, $68, $90, $30, $50, $80, $90, $18, $38, $68, $78
;@ path: ending/objects
;@ The y positions of the 16 stars, relative to the star object's y: 16 bytes, read by DrawStars
;@ (a y of $98 or more wraps to the top by subtracting $88).
StarsY::
	db $28, $08, $28, $00, $48, $40, $4c, $38, $68, $70, $58, $68, $78, $88, $98, $80
;@ path: ending/objects
;@ The twinkle cycle of a star: 8 tiles ($1E, $2E or $3E, three sizes of star), one step every 16
;@ frames, each star with its own phase. Read by DrawStars.
StarsTiles::
	db $1e, $1e, $1e, $2e, $2e, $3e, $2e, $2e

;@ def DrawStars()
;@ path: ending/objects
;@ Draws the stars of the night sky as 8 sprites from sprite 36 on: on even frames the stars with
;@ even numbers, on odd frames the others, so all 16 flicker in turn. They move with the object's y.
DrawStars::
;> o = 0x90                             # sprite 36
	ld de, wOAMBuffer + $90
	push bc
;>@loop for c in range(hFrameCounter & 1, 16, 2):
	ldh a, [hFrameCounter]
	and $01
	ld c, a

;>     y = u8(hActiveEntityDrawY + StarsY[c])
.loop
	ld hl, StarsY
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	add [hl]
;>     if y >= 0x98:
	cp $98
	jr c, .storeY

;>         y -= 0x88                    # wrap to the top
	sub $88

;>     wOAMBuffer[o] = y
.storeY
	ld [de], a
	inc de
;>     wOAMBuffer[o + 1] = StarsX[c]
	ld hl, StarsX
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
;>@t     t = ((hFrameCounter >> 4) ^ c) & 7
	push bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
;=@t
	nop
	xor c
	and $07
	ld c, a
	ld b, $00
;>     wOAMBuffer[o + 2] = StarsTiles[t]
	ld hl, StarsTiles
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
;>     wOAMBuffer[o + 3] = 0x90         # behind the background, palette OBP1
	ld a, $90
	ld [de], a
	inc de
;>     o += 4
;=@loop
	inc c
	inc c
	ld a, c
	cp $10
	jr c, .loop

;> return
	pop bc
	ret


;@ path: ending/owl
;@ The owl of the ending, 4 frames of its wing beat: 4 sprites each (16 bytes per frame, 4 bytes per
;@ sprite: y offset, x offset, tile, attributes), x offsets -8, 0, 8, $10, the right half mirrored.
;@ Indexed by sprite variant, drawn by EndingOwl.
;@ asset: oam length=$10
OwlSprites::
	db $00, $f8, $58, $00, $00, $00, $68, $00, $00, $08, $68, $20, $00, $10, $58, $20
	db $00, $f8, $5a, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $5a, $20
	db $00, $f8, $5c, $00, $00, $00, $6c, $00, $00, $08, $6c, $20, $00, $10, $5c, $20
	db $00, $f8, $5e, $00, $00, $00, $6e, $00, $00, $08, $6e, $20, $00, $10, $5e, $20

;@ def EndingOwl(slot: bc)
;@ path: ending/owl
;@ Ending object part 2: the owl that flies down to Link on the stairway, says farewell (dialog $CF)
;@ and flies away. Draws it from sprite 20 on (wing beat: a new frame every 8 frames), then runs its
;@ state (OwlStates).
EndingOwl::
;> wOAMNextIndex = 0x50                 # sprite 20
	ld a, $50
	ld [wOAMNextIndex], a
;>@f sprites = OwlSprites + (hActiveEntitySpriteVariant & 0x0F) * 16
	ld hl, OwlSprites
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
;=@f
	and $f0
	ld e, a
	ld d, b
	add hl, de
;> DrawEntitySprites(sprites, 4)
	ld c, $04
	call DrawEntitySprites
;> ReserveOAMEntriesFar(4)
	ld a, $04
	call ReserveOAMEntriesFar
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 3)    # wing beat
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	call SetEntitySpriteVariant
;> OwlStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: ending/owl
;@ The states of the owl (4 words).
OwlStates::
	dw OwlDescend
	dw OwlTalk
	dw OwlWaitDialog
	dw OwlFlyAway

;@ def OwlDescend(slot: bc)
;@ path: ending/owl
;@ State 0: after its start timer the owl flies down, slowing down by 1 every 4 frames; when its speed
;@ reaches 0 it hovers in front of Link (timer $80, next state).
OwlDescend::
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return
	jr nz, .done

;> UpdateEntityPosY(slot)
	call UpdateEntityPosY
;> if hFrameCounter & 3:
	ldh a, [hFrameCounter]
	and $03
;>     return
	jr nz, .done

;> wEntitySpeedY[slot] = u8(wEntitySpeedY[slot] - 1)
	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
;> if wEntitySpeedY[slot] != 0:
;>     return
	jr nz, .done

;> wEntityTimer[slot] = 0x80
	call GetEntityTimer
	ld [hl], $80
;> IncrementEntityState(slot)           # next state
	call IncrementEntityState

;> return
.done
	ret


;@ path: ending/owl
;@ The owl's hovering: 16 heights above the ground (0-4 pixels, wEntityZ), one step every 4 frames.
;@ Read by OwlHover.
OwlHoverHeights::
	db $00, $00, $00, $01, $01, $02, $03, $03, $04, $04, $04, $03, $03, $02, $01, $01

;@ def OwlTalk(slot: bc)
;@ path: ending/owl
;@ State 1: the owl hovers; when its timer runs out it opens its farewell dialog ($CF) and the next
;@ state follows.
OwlTalk::
;> if GetEntityTimer(slot):
	call GetEntityTimer
;>     return OwlHover(slot)
	jr nz, OwlHover

;> OpenEndingDialog(0xCF)
	ld a, $cf
	call OpenEndingDialog
;> wDialogSfx = 0x19
	ld a, $19
	ld [wDialogSfx], a
;> IncrementEntityState(slot)           # next state
	call IncrementEntityState
;> return OwlHover(slot)                # falls through

;@ def OwlHover(slot: bc)
;@ path: ending/owl
;@ Makes the owl bob up and down: its height wEntityZ follows OwlHoverHeights, driven by its
;@ private counter.
OwlHover::
;> t = wEntityPrivateCounter[slot]
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld a, [hl]
;> wEntityPrivateCounter[slot] = u8(t + 1)
	inc [hl]
;>@z wEntityZ[slot] = OwlHoverHeights[(t >> 2) & 15]
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, OwlHoverHeights
;=@z
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def OwlWaitDialog(slot: bc)
;@ path: ending/owl
;@ State 2: the owl hovers while its dialog is open; once it is closed, timer $FF and the next state.
OwlWaitDialog::
;> OwlHover(slot)
	call OwlHover
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	jr nz, .done

;> wEntityTimer[slot] = 0xFF
	call GetEntityTimer
	ld [hl], $ff
;> IncrementEntityState(slot)           # next state
	call IncrementEntityState

;> return
.done
	ret


;@ def OwlFlyAway(slot: bc)
;@ path: ending/owl
;@ State 3: the owl hovers and then flickers away (OwlFlyAwayFade). When the timer runs out the
;@ ending moves on to its next step and the owl is removed.
OwlFlyAway::
;> OwlHover(slot)
	call OwlHover
;> t = GetEntityTimer(slot)
	call GetEntityTimer
;> if t:
;>     return OwlFlyAwayFade(slot, t)
	jr nz, OwlFlyAwayFade

;> EndingNextStep()
OwlFlyAwayEnd:
	call EndingNextStep
;> return RemoveEndingObject(slot)      # falls through

;@ def RemoveEndingObject(slot: bc)
;@ path: ending/objects
;@ Removes an ending object (its entity slot becomes free).
RemoveEndingObject::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;> return
	ret


;@ def OwlFlyAwayFade(slot: bc, t: a)
;@ path: ending/owl
;@ The owl's farewell (timer t from $FF down): it hovers for 32 frames, then a jingle ($26) plays and
;@ it starts to vanish: an accumulator grows by a speed that rises by 2 per frame, and on every frame
;@ the accumulator overflows the owl is not drawn, so it flickers more and more until it is gone
;@ (speed $FC or more); then the ending moves on and the owl is removed.
OwlFlyAwayFade::
;> if t >= 0xE0:
	cp $e0
;>     return
	jr nc, .done

;> if t == 0xDF:
	cp $df
	jr nz, .fade

;>     hJingle = 0x26
	ld a, $26
	ldh [hJingle], a

;> speed = wEntityPrivate3[slot]
.fade
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	ld a, [hl]
;> if speed >= 0xFC:
	cp $fc
;>     EndingNextStep()
;>     return RemoveEndingObject(slot)
	jr nc, OwlFlyAwayEnd

;> wEntityPrivate3[slot] = speed + 2
	add $02
	ld [hl], a
;> acc = wEntityPrivate4[slot] + speed
;> wEntityPrivate4[slot] = acc & 0xFF
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
;> if acc > 0xFF:
	jr nc, .done

;>     SetEntitySpriteVariant(slot, 0xFF)   # not drawn this frame
	ld a, $ff
	call SetEntitySpriteVariant

;> return
.done
	ret


;@ def OpenEndingDialog(dialog: a)
;@ path: ending/objects
;@ Opens a dialog during the ending with the box at the bottom of the screen: Link's y is set to $10
;@ (the top) for the call, so OpenDialog puts the box below him, and restored afterwards.
OpenEndingDialog::
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
;> return
	ret


;@ path: ending/stairway
;@ Link's poses in the ending, by hLinkAnimationState: 13 poses of two 8x16 sprites, 4 bytes each
;@ (tile and attributes of the left sprite, tile and attributes of the right sprite; attribute $20 =
;@ mirrored). Poses 0-1 standing (tiles $00/$02), 2-4 climbing and looking up ($44-$4C), 5-12 sitting
;@ and turning ($D4-$E2). Drawn by DrawLinkSprites.
LinkCreditsPoses::
	db $00, $00, $02, $00, $02, $20, $00, $20, $44, $00, $46, $00, $48, $00, $4a, $00
	db $4c, $00, $4c, $20, $d8, $20, $d6, $20, $d4, $00, $d4, $20, $d6, $00, $d8, $00
	db $da, $00, $dc, $00, $de, $00, $e0, $00, $e2, $00, $e2, $20, $e0, $20, $de, $20
	db $dc, $20, $da, $20

;@ def DrawLinkSprites()
;@ path: ending/stairway
;@ Draws Link as sprites 1 and 2 (8x16 each, side by side) at (hLinkX - screen shake, hLinkY) in the
;@ pose hLinkAnimationState (LinkCreditsPoses).
DrawLinkSprites::
;>@p pose = LinkCreditsPoses + hLinkAnimationState * 4
	ldh a, [hLinkAnimationState]
	rla
	rla
	and $fc
	ld e, a
	ld d, $00
;=@p
	ld hl, LinkCreditsPoses
	add hl, de
	push hl
	pop de
;> wOAMBuffer[4] = hLinkY
	ld hl, wOAMBuffer + 4
	ldh a, [hLinkY]
	ld [hli], a
;> x = u8(hLinkX - wScreenShakeX)
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hLinkX]
	sub c
;> wOAMBuffer[5] = x
	ld [hli], a
;> wOAMBuffer[6] = mem[pose]
	ld a, [de]
	inc de
	ld [hli], a
;> wOAMBuffer[7] = mem[pose + 1]
	ld a, [de]
	inc de
	ld [hli], a
;> wOAMBuffer[8] = hLinkY
	ldh a, [hLinkY]
	ld [hli], a
;> wOAMBuffer[9] = u8(x + 8)
	ldh a, [hLinkX]
	sub c
	add $08
	ld [hli], a
;> wOAMBuffer[10] = mem[pose + 2]
	ld a, [de]
	inc de
	ld [hli], a
;> wOAMBuffer[11] = mem[pose + 3]
	ld a, [de]
	ld [hl], a
;> return
	ret


;@ path: text/dialog
;@ The y of the dialog's "more text" arrow sprite: 2 bytes, for the box at the top ($37) and at the
;@ bottom ($7F) of the screen. Read by DrawDialogArrow.
DialogArrowY::
	db $37, $7f

;@ def DrawDialogArrow()
;@ path: text/dialog
;@ Draws the blinking arrow at the bottom right of a dialog box that waits for a button (shown 16
;@ frames, hidden 16). Called from the dialog code in bank 0. During the ending it uses sprite 0, tile
;@ $FE and corrects for the background scroll; otherwise sprite 6 with tile $A2. x is $97 either way.
DrawDialogArrow::
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
;>     return                           # blink
	ret nz
;> box = 0
	ld e, $00
;> if wDialogState & 0x80:              # box at the bottom
	ld a, [wDialogState]
	and $80
	jr z, .type

;>     box = 1
	inc e

;> if wGameplayType != 1:               # not the ending
.type
	ld d, $00
	ld a, [wGameplayType]
	cp $01
	jr z, .ending

;>     wOAMBuffer[0x18] = DialogArrowY[box]
	ld hl, DialogArrowY
	add hl, de
	ld a, [hl]
	ld [wOAMBuffer + $18], a
;>     wOAMBuffer[0x19] = 0x97
	ld a, $97
	ld [wOAMBuffer + $19], a
;>     wOAMBuffer[0x1A] = 0xA2          # tile
	ld a, $a2
	ld [wOAMBuffer + $1A], a
;>     wOAMBuffer[0x1B] = 0x40          # attributes: palette OBP0, bit 6
	ld a, $40
	ld [wOAMBuffer + $1B], a
;>     return
	ret

;> wOAMBuffer[0] = u8(DialogArrowY[box] - hBaseScrollY)
.ending
	ld hl, DialogArrowY
	add hl, de
	ld a, [hl]
	ld hl, hBaseScrollY
	sub [hl]
	ld [wOAMBuffer], a
;> wOAMBuffer[1] = 0x97
	ld a, $97
	ld [wOAMBuffer + 1], a
;> wOAMBuffer[2] = 0xFE                 # tile
	ld a, $fe
	ld [wOAMBuffer + 2], a
;> wOAMBuffer[3] = 0x40
	ld a, $40
	ld [wOAMBuffer + 3], a
;> return
	ret


;@ path: text/dialog
;@ The y of the answer cursor of a question dialog: 2 bytes, for the box at the top ($30) and at the
;@ bottom ($78). Read by DrawDialogChoiceCursor.
DialogChoiceY::
	db $30, $78

;@ path: text/dialog
;@ The x of the answer cursor: 2 bytes, for the first ($30) and the second ($58) answer. Read by
;@ DrawDialogChoiceCursor.
DialogChoiceX::
	db $30, $58

;@ def DrawDialogChoiceCursor()
;@ path: text/dialog
;@ Draws the cursor in front of the chosen answer (wDialogAnswer) of a question dialog. Called from
;@ the dialog code in bank 0. During the ending it uses sprite 0 and tile $9E and corrects for the
;@ background scroll; otherwise sprite 6 with tile $3E.
DrawDialogChoiceCursor::
;> box = 0
	ld e, $00
;> if wDialogState & 0x80:              # box at the bottom
	ld a, [wDialogState]
	and $80
	jr z, .type

;>     box = 1
	inc e

;> if wGameplayType != 1:               # not the ending
.type
	ld d, $00
	ld a, [wGameplayType]
	cp $01
	jr z, .ending

;>     wOAMBuffer[0x18] = DialogChoiceY[box]
	ld hl, DialogChoiceY
	add hl, de
	ld a, [hl]
	ld [wOAMBuffer + $18], a
;>     answer = 0
	ld e, $00
;>     if wDialogAnswer & 1:
	ld a, [wDialogAnswer]
	and $01
	jr z, .x

;>         answer = 1
	inc e

;>     wOAMBuffer[0x19] = DialogChoiceX[answer]
.x
	ld hl, DialogChoiceX
	add hl, de
	ld a, [hl]
	ld [wOAMBuffer + $19], a
;>     wOAMBuffer[0x1A] = 0x3E          # tile
	ld a, $3e
	ld [wOAMBuffer + $1A], a
;>     wOAMBuffer[0x1B] = 0
	ld a, $00
	ld [wOAMBuffer + $1B], a
;>     return
	ret

;> wOAMBuffer[0] = u8(DialogChoiceY[box] - hBaseScrollY)
.ending
	ld hl, DialogChoiceY
	add hl, de
	ld a, [hl]
	ld hl, hBaseScrollY
	sub [hl]
	ld [wOAMBuffer], a
;> answer = 0
	ld e, $00
;> if wDialogAnswer & 1:
	ld a, [wDialogAnswer]
	and $01
	jr z, .x2

;>     answer = 1
	inc e

;> wOAMBuffer[1] = DialogChoiceX[answer]
.x2
	ld hl, DialogChoiceX
	add hl, de
	ld a, [hl]
	ld [wOAMBuffer + 1], a
;> wOAMBuffer[2] = 0x9E                 # tile
	ld a, $9e
	ld [wOAMBuffer + 2], a
;> wOAMBuffer[3] = 0
	ld a, $00
	ld [wOAMBuffer + 3], a
;> return
	ret


;@ def UpdateEntityPosition(slot: bc)
;@ path: ending/objects
;@ Moves an ending object by its x and y speeds (UpdateEntityPosX, UpdateEntityPosY).
UpdateEntityPosition::
;> UpdateEntityPosX(slot)
	call UpdateEntityPosX
;> return UpdateEntityPosY(slot)        # falls through

;@ def UpdateEntityPosY(slot: bc)
;@ path: ending/objects
;@ Moves an ending object by its y speed: UpdateEntityPosX on slot + 16, since the y arrays (wEntityY,
;@ wEntitySpeedY, wEntitySpeedYAcc) lie 16 bytes after the x arrays.
UpdateEntityPosY::
;> UpdateEntityPosX(slot + 16)
	push bc
	ld a, c
	add $10
	ld c, a
	call UpdateEntityPosX
	pop bc
;> return
	ret


;@ def UpdateEntityPosX(slot: bc)
;@ path: ending/objects
;@ Moves an ending object by its x speed (signed, in 1/16 pixel per frame): the low 4 bits go into the
;@ fraction accumulator wEntitySpeedXAcc, the high 4 bits (sign-extended) plus the accumulator's
;@ carry are added to wEntityX.
UpdateEntityPosX::
;> speed = wEntitySpeedX[slot]
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
	jr z, UpdateEntityPosDone

;> acc = wEntitySpeedXAcc[slot] + ((speed & 0x0F) << 4)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
;> wEntitySpeedXAcc[slot] = acc & 0xFF
	ld [hl], a
	rl d
;>@pos wEntityX[slot] = u8(wEntityX[slot] + ((speed >> 4) | (0xF0 if speed & 0x80 else 0)) + (acc >> 8))
	ld hl, wEntityX
UpdateEntityPosAdd:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive

;=@pos
	ld e, $f0

.positive
;=@pos
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

;> return
UpdateEntityPosDone:
	ret


;@ def UnusedUpdateEntityPosZ(slot: bc)
;@ path: unused/ending
;@ Never called: the same movement for the height (wEntitySpeedZ, wEntitySpeedZAcc, wEntityZ); it
;@ shares the end of UpdateEntityPosX.
UnusedUpdateEntityPosZ::
;> speed = wEntitySpeedZ[slot]
	ld hl, wEntitySpeedZ
	add hl, bc
	ld a, [hl]
;> if speed == 0:
	and a
;>     return
	jr z, UpdateEntityPosDone

;> acc = wEntitySpeedZAcc[slot] + ((speed & 0x0F) << 4)
	push af
	swap a
	and $f0
	ld hl, wEntitySpeedZAcc
	add hl, bc
	add [hl]
;> wEntitySpeedZAcc[slot] = acc & 0xFF
	ld [hl], a
	rl d
;> wEntityZ[slot] = u8(wEntityZ[slot] + ((speed >> 4) | (0xF0 if speed & 0x80 else 0)) + (acc >> 8))
	ld hl, wEntityZ
	jr UpdateEntityPosAdd

;@ path: unused
;@ Unused space at the end of bank $17: $3F5 bytes of $FF up to $7FFF.
Bank17Padding::
	db $ff, $ff, $ff, $ff, $ff, $ff
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
