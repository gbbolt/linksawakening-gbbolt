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
;> slot = Call_3C01(0xE8)               # spawn an ending object
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)               # ending object, part 0
	ld a, $e8
	call Call_3C01
;> wEntityX[slot] = 0x40
	ld hl, wEntityX
	add hl, de
	ld [hl], $40
;> wEntityY[slot] = 0xE0
	ld hl, wEntityY
	add hl, de
	ld [hl], $e0
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;>     slot = Call_3C01(0xE8)           # ending object
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0x6D)
	ld a, $6d
	call Call_3C01
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = Call_3C01(0x6F)
	ld a, $6f
	call Call_3C01
;> wEntityX[slot] = 0x68
	ld hl, wEntityX
	add hl, de
	ld [hl], $68
;> wEntityY[slot] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> slot = Call_3C01(0x78)
	ld a, $78
	call Call_3C01
;> wEntityX[slot] = 0x2C
	ld hl, wEntityX
	add hl, de
	ld [hl], $2c
;> wEntityY[slot] = 0x58
	ld hl, wEntityY
	add hl, de
	ld [hl], $58
;> slot = Call_3C01(0x78)
	ld a, $78
	call Call_3C01
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
;> slot = Call_3C01(0x71)
	ld a, $71
	call Call_3C01
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
;> slot = Call_3C01(0x72)
	ld a, $72
	call Call_3C01
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
;> slot = Call_3C01(0xC5)
	ld a, $c5
	call Call_3C01
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x40
	ld hl, wEntityY
	add hl, de
	ld [hl], $40
;> slot = Call_3C01(0x09)
	ld a, $09
	call Call_3C01
;> wEntityX[slot] = 0x48
	ld hl, wEntityX
	add hl, de
	ld [hl], $48
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = Call_3C01(0x09)
	ld a, $09
	call Call_3C01
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
;> slot = Call_3C01(0x3F)
	ld a, $3f
	call Call_3C01
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
;> slot = Call_3C01(0x3E)
	ld a, $3e
	call Call_3C01
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x50
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
;> slot = Call_3C01(0x6E)
	ld a, $6e
	call Call_3C01
;> wEntityX[slot] = 0x18
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
;> wEntityY[slot] = 0x4C
	ld hl, wEntityY
	add hl, de
	ld [hl], $4c
;> slot = Call_3C01(0x6E)
	ld a, $6e
	call Call_3C01
;> wEntityX[slot] = 0x38
	ld hl, wEntityX
	add hl, de
	ld [hl], $38
;> wEntityY[slot] = 0x54
	ld hl, wEntityY
	add hl, de
	ld [hl], $54
;> slot = Call_3C01(0x6E)
	ld a, $6e
	call Call_3C01
;> wEntityX[slot] = 0x28
	ld hl, wEntityX
	add hl, de
	ld [hl], $28
;> wEntityY[slot] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> slot = Call_3C01(0x6F)
	ld a, $6f
	call Call_3C01
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
;> slot = Call_3C01(0xE8)               # ending object, part 0
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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
;> slot = Call_3C01(0xE8)
	ld a, $e8
	call Call_3C01
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


CreditsWindFishFlies::
	call UpdateEntitiesBank17
	ld a, [wSceneStep]
	rst $00

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

WindFishFliesInit::
	ld a, $19
	ld [wTileMapToLoad], a
	jp EndingNextStep


WindFishFliesSpawn::
	ld a, $1a
	ld [wBGMapToLoad], a
	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $40
	ld hl, wEntityY
	add hl, de
	ld [hl], $4e
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0a
	jp EndingNextStep


WindFishFliesFadeIn::
	ld de, $9960
	call AnimateWaterRows
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_5f80

	ld a, [wSceneFadeStep]
	cp $0c
	jr nz, jr_017_5f7c

	call ResetSceneVars
	ld a, $60
	ld [wSceneSlowTimer], a
	jp EndingNextStep


jr_017_5f7c:
	inc a
	ld [wSceneFadeStep], a

jr_017_5f80:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
	ld d, $00
	ld hl, $590b
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld [wOBJ0Palette], a
	ld hl, $590b
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
	ret


WindFishFliesWait::
	ld de, $9960
	call AnimateWaterRows
	ld a, [wSceneSlowTimer]
	and a
	jr nz, jr_017_5fba

	call ResetSceneVars
	jp EndingNextStep


jr_017_5fba:
	ret


SittingFadeInOBP0::
	db $1e, $1e, $1e, $1e, $2e, $2e, $2e, $2e, $6e, $6e, $6e, $6e

WindFishFliesFadeInOBP0::
	ld de, $9960
	call AnimateWaterRows
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_017_5fe9

	ld a, [wSceneFadeStep]
	cp $08
	jr nz, jr_017_5fe5

	call ResetSceneVars
	ld a, $20
	ld [wSceneTimer], a
	jp EndingNextStep


jr_017_5fe5:
	inc a
	ld [wSceneFadeStep], a

jr_017_5fe9:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
	ld d, $00
	ld hl, $5fbb
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ret


WindFishFliesCount::
	ld de, $9960
	call AnimateWaterRows
	ld a, [wSceneTimer]
	and a
	jr nz, jr_017_6022

	ld a, $0a
	ld [wSceneTimer], a
	ld a, [wEntityWorkRAM]
	inc a
	ld [wEntityWorkRAM], a
	cp $02
	jr nz, jr_017_6022

	ld a, $20
	ld [wSceneTimer], a
	jp EndingNextStep


jr_017_6022:
	ret


WindFishFliesWait2::
	ld de, $9960
	call AnimateWaterRows
	ld a, [wSceneTimer]
	and a
	jr nz, jr_017_6032

	jp EndingNextStep


jr_017_6032:
	ret


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
SkyScrollSpeeds::
	db $02, $04, $06, $08, $0a, $0c, $0e, $10, $12, $14, $16, $18, $1a, $1c, $1e, $20
	db $22, $24, $26, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $27, $26, $25, $24, $23, $22, $21, $20, $1f, $1e, $1d, $1c, $1b
	db $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10, $0f, $0e, $0d, $0c, $0b
	db $0a, $09, $08, $07, $06, $05, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00
SkyFadeSteps::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
SkyFadeBGP::
	db $1e, $1e, $1e, $1e, $1f, $1f, $1f, $1f, $1a, $1a, $1a, $1a, $15, $15, $15, $15
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $15, $15, $15, $15
	db $19, $19, $1a, $1a, $1e, $1e, $1e, $1e

WindFishFliesTiltUp::
	ld a, [wSceneVarD]
	cp $0e
	jr nc, jr_017_6998

	ld de, $9960
	call AnimateWaterRows

jr_017_6998:
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
	ld hl, $6903
	add hl, de
	ld a, [hl]
	ld [wSceneVarC], a
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVarC]
	add e
	ld e, a
	ld d, $00
	ld hl, $6963
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
	cp $59
	jr nz, jr_017_69d7

	ldh a, [hBaseScrollY]
	cp $30
	jr nz, jr_017_69d7

	ld a, $ff
	ld [wSceneTimer3], a
	ld a, $a8
	ld [wSceneSlowTimer], a
	jp EndingNextStep


jr_017_69d7:
	ld hl, $68a3
	add hl, de
	ld a, [hl]
	cpl
	inc a
	sla a
	ld [wEntitySpeedX], a
	ld bc, $0000
	ld a, [wEntityX]
	push af
	call UpdateEntityPosX
	ld a, [wEntityX]
	ldh [hBaseScrollY], a
	and $f8
	ld e, a
	pop af
	and $f8
	cp e
	jr z, jr_017_6a5a

	ld a, [wSceneVarD]
	cp $59
	jr z, jr_017_6a5a

	inc a
	ld [wSceneVarD], a
	cp $44
	jr nz, jr_017_6a2c

	ld a, $e3
	ld [wOBJ1Palette], a
	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $80
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0b
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $a8

jr_017_6a2c:
	ld a, [wSceneVarD]
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld a, e
	ld l, d
	sla e
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	add l
	ld d, a
	ld hl, $6033
	add hl, de
	ld de, wDrawCommand
	ld c, $18

jr_017_6a54:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_6a54

jr_017_6a5a:
	ret


WindFishFliesFadeOut::
	ld a, [wSceneSlowTimer]
	and a
	jr nz, jr_017_6a68

	xor a
	ld [wBGPalette], a
	jp CreditsNextScene


jr_017_6a68:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVarC]
	add e
	ld e, a
	ld d, $00
	ld hl, $6963
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld a, [wSceneTimer3]
	and a
	jr nz, jr_017_6abe

	ld a, [wSceneVarB]
	inc a
	ld [wSceneVarB], a
	and $07
	jr nz, jr_017_6abe

	ld a, [wSceneVarC]
	cp $24
	jr z, jr_017_6abe

	inc a
	ld [wSceneVarC], a
	cp $05
	jr nz, jr_017_6abe

	ld a, $1e
	ld [wOBJ0Palette], a
	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $62
	ld hl, wEntityY
	add hl, de
	ld [hl], $5a
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0c
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $60

jr_017_6abe:
	ret


CreditsLinkPortrait::
	call UpdateEntitiesBank17
	ld a, [wSceneStep]
	rst $00

PortraitSteps::
	dw PortraitInit
	dw PortraitSpawn
	dw PortraitWait
	dw PortraitFadeIn
	dw PortraitSmile
	dw PortraitFadeOut
	dw PortraitDone

PortraitInit::
	ld a, $1a
	ld [wTileMapToLoad], a
	jp EndingNextStep


PortraitSpawn::
	ld a, $1b
	ld [wBGMapToLoad], a
	call ResetSceneVars
	ld a, $1e
	ld [wBGPalette], a
	ld a, $6e
	ld [wOBJ0Palette], a
	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $38
	ld hl, wEntityY
	add hl, de
	ld [hl], $50
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0d
	ld a, $20
	ld [wSceneTimer], a
	jp EndingNextStep


PortraitWait::
	ld a, [wSceneTimer]
	and a
	jr nz, BobPortraitScroll

	call EndingNextStep

BobPortraitScroll::
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_6b28

	ld a, [wSceneVarF]
	inc a
	cp $31
	jr nz, jr_017_6b25

	xor a

jr_017_6b25:
	ld [wSceneVarF], a

jr_017_6b28:
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ld a, [hl]
	sra a
	ldh [hBaseScrollY], a
	ret


PortraitFadeInOBP0::
	db $6e, $6e, $6e, $6e, $1e, $1e, $1e, $1e

PortraitFadeIn::
	call BobPortraitScroll
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_017_6b5b

	ld a, [wSceneFadeStep]
	inc a
	ld [wSceneFadeStep], a
	cp $04
	jr nz, jr_017_6b5b

	ld a, $ff
	ld [wSceneTimer], a
	jp EndingNextStep


jr_017_6b5b:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneFadeStep]
	add e
	ld e, a
	ld d, $00
	ld hl, $6b37
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ret


PortraitSmile::
	call BobPortraitScroll
	ld a, [wSceneTimer]
	and a
	jr nz, jr_017_6b82

	ld a, $e0
	ld [wSceneTimer], a
	jp EndingNextStep


	db $c9

jr_017_6b82:
	cp $44
	jr z, jr_017_6b8a

	cp $50
	jr nz, jr_017_6b8e

jr_017_6b8a:
	ld hl, wSceneVar3
	inc [hl]

jr_017_6b8e:
	ret


PortraitFadeOut::
	call BobPortraitScroll
	ld hl, wSceneTimer
	ldh a, [hFrameCounter]
	and $07
	or [hl]
	jr nz, jr_017_6baf

	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
	cp $0c
	jr nz, jr_017_6baf

	ld a, $40
	ld [wSceneTimer], a
	call EndingNextStep

jr_017_6baf:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVar2]
	add e
	ld e, a
	ld d, $00
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ld hl, $5c63
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
	ret


PortraitDone::
	ld a, [wSceneTimer]
	and a
	jr nz, jr_017_6bdd

	jp CreditsNextScene


jr_017_6bdd:
	ret


CreditsFinalScene::
	ld de, $99a0
	call AnimateWaterRows
	call CreditsRoll
	call UpdateEntitiesBank17
	ld a, [wSceneStep]
	rst $00

FinalSteps::
	dw FinalInit
	dw FinalSpawn
	dw FinalSceneFadeIn
	dw FinalScrollUp
	dw FinalEnd
	dw FinalUnusedStep

FinalInit::
	ld a, $1b
	ld [wTileMapToLoad], a
	ld hl, wLCDControl
	res 2, [hl]
	jp EndingNextStep


FinalSpawn::
	ld a, $1c
	ld [wBGMapToLoad], a
	call ResetSceneVars
	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $78
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0e
	xor a
	ld [wCreditsRollStep], a
	dec a
	ld [wCreditsRole], a
	ld a, $b0
	ld [wSceneSlowTimer], a
	xor a
	ldh [hFrameCounter], a
	ld [wOBJ1Palette], a
	jp EndingNextStep


FinalFadeIn::
	db $00, $00, $00, $00, $04, $04, $04, $04, $19, $19, $19, $19, $1e, $1e, $1e, $1e

FinalSceneFadeIn::
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_017_6c68

	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
	cp $0c
	jr nz, jr_017_6c68

	ld a, $ff
	ld [wSceneVerySlowTimer], a
	xor a
	ldh [hFrameCounter], a
	call EndingNextStep

jr_017_6c68:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wSceneVar2]
	add e
	ld e, a
	ld d, $00
	ld hl, $6c3c
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld [wOBJ0Palette], a
	ret


FinalScrollUp::
	ld a, [wSceneVerySlowTimer]
	and a
	jr nz, jr_017_6cbf

	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_017_6cbf

	ld hl, hBaseScrollY
	dec [hl]
	ld a, [hl]
	cp $70
	jr nz, jr_017_6c98

	jp EndingNextStep


jr_017_6c98:
	cp $a0
	jr nz, jr_017_6ca4

	ld hl, $c28f
	ld [hl], $00
	jp DrawFinalPatch


jr_017_6ca4:
	cp $c0
	jr nz, jr_017_6cbf

	ld a, $e8
	call Call_3C01
	ld hl, wEntityX
	add hl, de
	ld [hl], $18
	ld hl, wEntityY
	add hl, de
	ld [hl], $b0
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $0f

jr_017_6cbf:
	ret


FinalEnd::
	ret


FinalUnusedStep::
	ret


FinalPatchCommands::
	db $99, $c1, $05, $58, $59, $5a, $5b, $5c, $5d, $99, $e1, $05, $68, $69, $6a, $6b
	db $6c, $6d, $99, $f1, $02, $58, $59, $5a, $9a, $11, $02, $68, $69, $6a, $9a, $20
	db $01, $5c, $5d, $00

DrawFinalPatch::
	ld hl, $6cc2
	ld de, wDrawCommand
	ld c, $24

jr_017_6cee:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_6cee

	ret


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

EndingWindFishAway::
	ld a, $3c
	ld [wOAMNextIndex], a
	ldh a, [hBaseScrollY]
	ld e, a
	ldh a, [hActiveEntityDrawY]
	sub e
	ldh [hActiveEntityDrawY], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	rra
	and $03
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $6cf5
	add hl, de
	ld c, $0a
	call Call_3D20
	ld a, $0a
	call Call_3DD0
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_017_6de6

	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], $04
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $ff
	call UpdateEntityPosition
	ldh a, [hActiveEntityX]
	cp $a8
	ret c

	call EndingNextStep
	jp RemoveEndingObject


jr_017_6de6:
	ret


LastSeagullSprites::
	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60

EndingLastSeagull::
	ld hl, wDeathCount
	ld a, [hli]
	or [hl]
	jr nz, jr_017_6e96

	ld a, $1c
	ld [wOBJ0Palette], a
	ld a, $3c
	ld [wOAMNextIndex], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6de7
	add hl, de
	ld c, $08
	call Call_3D20
	ld a, $08
	call Call_3DD0

jr_017_6e96:
	call UpdateEntityPosition
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_017_6ea9

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $fc
	jr z, jr_017_6ea9

	dec [hl]

jr_017_6ea9:
	ldh a, [hActiveEntityX]
	cp $a8
	jp z, RemoveEndingObject

	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $7f
	jr nz, jr_017_6ebf

	ld a, $21
	ldh [hJingle], a

jr_017_6ebf:
	ret


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

EndingLinkOnLog::
	ld a, $3c
	ld [wOAMNextIndex], a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_6f97

	ld a, [wSceneVarF]
	inc a
	cp $31
	jr c, jr_017_6f94

	xor a

jr_017_6f94:
	ld [wSceneVarF], a

jr_017_6f97:
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ldh a, [hBaseScrollY]
	ld d, a
	ld a, [hl]
	sra a
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
	sub d
	ldh [hActiveEntityDrawY], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $6ec0
	add hl, de
	ld c, $0c
	call Call_3D20
	ld a, $0c
	call Call_3DD0
	ret


LinkPortraitSprites::
	db $00, $00, $00, $00, $00, $08, $02, $00, $00, $10, $04, $00, $00, $18, $06, $00
	db $00, $20, $08, $00, $00, $28, $0a, $00, $10, $20, $14, $00, $10, $28, $16, $00
	db $20, $20, $1e, $00, $20, $28, $20, $00, $30, $00, $50, $00, $30, $08, $22, $00
	db $30, $10, $24, $00, $30, $18, $26, $00, $30, $20, $28, $00, $30, $28, $2a, $00
	db $30, $30, $2c, $00, $30, $38, $2e, $00, $40, $00, $30, $00, $40, $08, $32, $00
	db $40, $10, $34, $00, $40, $18, $36, $00, $40, $20, $38, $00, $40, $28, $3a, $00
	db $40, $30, $3c, $00, $40, $38, $3e, $00, $40, $40, $40, $00

LinkFaceSprites::
	db $10, $00, $0c, $00
	db $10, $08, $0e, $00, $10, $10, $10, $00, $10, $18, $12, $00, $20, $08, $18, $00
	db $20, $10, $1a, $00, $20, $18, $1c, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $42, $00, $10, $10, $44, $00, $10, $18, $46, $00, $20, $08, $18, $00
	db $20, $10, $48, $00, $20, $18, $4a, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $56, $00, $20, $08, $18, $00
	db $20, $10, $58, $00, $20, $18, $5a, $00, $ff, $ff, $ff, $ff

EndingLinkPortrait::
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ld a, [hl]
	sra a
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
	ldh [hActiveEntityDrawY], a
	ld hl, $6fd0
	ld c, $1b
	call Call_3D20
	ld a, $1b
	call Call_3DD0
	ld a, [wSceneVar3]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $703c
	add hl, de
	ld c, $07
	ld a, $40
	ld [wOAMNextIndex], a
	call Call_3D26
	ld a, $07
	call Call_3DD0
	ret


StreakSprites::
	db $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00
	db $08, $08, $5c, $00, $08, $08, $5c, $00, $00, $00, $70, $00, $08, $08, $5e, $00
	db $08, $10, $60, $00

EndingStreak::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
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
	ld hl, $70db
	add hl, de
	ld c, $03
	call Call_3D26
	call GetEntityTimer
	cp $01
	jr z, jr_017_7126

	cp $30
	jr nz, jr_017_712b

jr_017_7126:
	ld hl, wEntitySpriteVariant
	add hl, bc
	inc [hl]

jr_017_712b:
	ret


GlowRingSprites::
	db $00, $00, $62, $10, $00, $08, $62, $30, $10, $f0, $64, $10, $10, $f8, $66, $10
	db $10, $00, $68, $10, $10, $08, $68, $30, $10, $10, $66, $30, $10, $18, $64, $30
	db $20, $00, $6a, $10, $20, $08, $6a, $30, $30, $f8, $6c, $10, $30, $00, $6e, $10
	db $30, $08, $6e, $30, $30, $10, $6c, $30

EndingGlowRing::
	xor a
	ld [wOAMNextIndex], a
	ld hl, hBaseScrollY
	ldh a, [hActiveEntityDrawY]
	sub [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $712c
	ld c, $0e
	call Call_3D26
	ld a, $0e
	call Call_3DD0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $fe
	call UpdateEntityPosY
	ldh a, [hActiveEntityState]
	cp $02
	jr nc, jr_017_719a

	call GetEntityTimer
	jr nz, jr_017_719a

	ld [hl], $c0
	call Call_3B8D
	ld a, $17
	ldh [hWaveSfx], a

jr_017_719a:
	ret


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

SeaBobOffsets::
	db $00, $00, $00, $00
	db $00, $00, $01, $01, $01, $01, $02, $02, $02, $03, $03, $04, $05, $05, $06, $06
	db $06, $07, $07, $07, $07, $08, $08, $08, $08, $08, $08, $07, $07, $07, $07, $06
	db $06, $06, $05, $05, $04, $03, $02, $02, $02, $01, $01, $01, $01

EndingWindFishHigh::
	ld a, $00
	ld [wOAMNextIndex], a
	ldh a, [hBaseScrollY]
	ld d, a
	sra a
	add d
	ldh [hMultiPurpose0], a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_72b7

	ld a, [wSceneVarF]
	inc a
	cp $31
	jr c, jr_017_72b4

	xor a

jr_017_72b4:
	ld [wSceneVarF], a

jr_017_72b7:
	ld a, [wSceneVarF]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld hl, hMultiPurpose0
	sub [hl]
	ldh [hActiveEntityDrawY], a
	cp $a8
	jp nc, RemoveEndingObject

	ld a, [wEntityWorkRAM]
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	rla
	rla
	and $c0
	add e
	ld e, a
	ld d, b
	ld hl, $719b
	add hl, de
	ld c, $11
	call Call_3D26
	ld a, $11
	call Call_3DD0
	ret


SkyStreakSprites::
	db $00, $00, $70, $00, $08, $08, $5e, $00, $08, $10, $60, $00

EndingSkyStreak::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c3
	ld hl, $72ee
	ld c, $03
	call Call_3D26
	ret


SeagullFrames::
	db $50, $00, $52, $00, $54, $00, $56, $00, $57, $00, $5a, $00

EndingSeagull::
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_017_7327

	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, jr_017_7326

	xor a

jr_017_7326:
	ld [hl], a

jr_017_7327:
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_017_733b

	ld hl, hActiveEntityFlipAttribute
	set 5, [hl]

jr_017_733b:
	ld de, $7309
	call Call_3CD0
	call UpdateEntityPosX
	ldh a, [hActiveEntityX]
	cp $b0
	jp nc, RemoveEndingObject

	ret


FarLogSpritesA::
	db $00, $08, $0e, $00, $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $50, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $58, $00

FarLogSpritesB::
	db $00, $08, $0e, $00
	db $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $60, $00, $10, $08, $62, $00
	db $10, $10, $64, $00, $10, $18, $68, $00

FarLogBobOffsets::
	db $00, $00, $00, $01, $02, $02, $02, $01
DebrisBobOffsets::
	db $00, $00, $00, $00, $01, $01, $01, $01

EndingFarLog::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c7
	ld a, $00
	ld [wOAMNextIndex], a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $7384
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, $734c
	ldh a, [hFrameCounter]
	and $10
	jr z, jr_017_73be

	ld hl, $7368

jr_017_73be:
	ld c, $07
	call Call_3D26
	ret


DebrisFrames::
	db $5a, $00, $6a, $00

EndingDebris::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c1
	ld a, c
	rla
	and $06
	ld e, a
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	add e
	and $07
	ld e, a
	ld d, b
	ld hl, $738c
	add hl, de
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ldh [hActiveEntityDrawY], a
	ld de, $73c4
	call Call_3CD0
	ret


WaveDebrisFrames::
	db $54, $00, $64, $00, $64, $20, $54, $20, $4e, $00, $7e, $00

EndingWaveDebris::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
	ldh a, [hActiveEntitySpriteVariant]
	cp $01
	jr z, jr_017_7427

	cp $02
	jr z, jr_017_7434

	ld a, [wSceneFadeStep]

jr_017_740d:
	ld e, a
	ld d, b
	ld hl, $5b49
	add hl, de
	ld a, [hl]
	sub $04

jr_017_7416:
	cpl
	inc a
	sra a
	ld e, a
	ldh a, [hActiveEntityDrawY]
	add e
	ldh [hActiveEntityDrawY], a
	ld de, $73ee
	call Call_3C3B
	ret


jr_017_7427:
	ld a, [wSceneFadeStep]
	add $06
	cp $2b
	jr c, jr_017_7432

	sub $2b

jr_017_7432:
	jr jr_017_740d

jr_017_7434:
	ld a, [wSceneFadeStep]
	add $18
	cp $2b
	jr c, jr_017_743f

	sub $2b

jr_017_743f:
	ld e, a
	ld d, $00
	ld hl, $5b49
	add hl, de
	ld a, [hl]
	sub $04
	sra a
	jr jr_017_7416

FlyingBirdFrames::
	db $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20, $78, $00, $78, $20
	db $7a, $00, $7a, $20, $7c, $00, $7c, $20

FlyingBirdDurations::
	db $08, $06, $06, $06, $06, $08

EndingFlyingSeagull::
	ld hl, wEntityPhysicsFlags
	add hl, bc
	ld [hl], $c2
	ld de, $744d
	call Call_3C3B
	call GetEntityTimer
	jr nz, jr_017_7492

	push hl
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, jr_017_7488

	xor a

jr_017_7488:
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7465
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a

jr_017_7492:
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $1f
	jr nz, jr_017_74a7

	ld hl, wEntitySpeedY
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_017_74a7

	inc [hl]

jr_017_74a7:
	call UpdateEntityPosition
	ldh a, [hActiveEntityX]
	cp $b0
	jp nc, RemoveEndingObject

	ret


InstrumentFrames::
	db $d0, $00, $d2, $00, $d4, $00, $d6, $00, $d8, $00, $da, $00, $dc, $00, $de, $00
	db $e0, $00, $e2, $00, $e4, $00, $e6, $00, $e8, $00, $ea, $00, $ec, $00, $ee, $00

EndingInstrument::
	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	add $50
	ldh [hMultiPurpose0], a
	ld de, $74b2
	call DrawInstrumentSprites
	call GetEntityDropTimer
	ret z

	call UpdateEntityPosition
	ret


DrawInstrumentSprites::
	push bc
	push de
	ldh a, [hMultiPurpose0]
	ld e, a
	ld d, b
	ld hl, wOAMBuffer
	add hl, de
	push hl
	pop de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	rra
	rra
	ld hl, hActiveEntityX
	add [hl]
	sub c
	ld [de], a
	inc de
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	push hl
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	inc de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	xor $20
	rra
	rra
	ld hl, hActiveEntityX
	sub c
	add [hl]
	ld [de], a
	inc de
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	pop bc
	ret


EndingObjectHandler::
	ld hl, wEntityPrivate1
	add hl, bc
	ld a, [hl]
	rst $00

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

EndingStairway::
	call DrawStairway
	ldh a, [hActiveEntityState]
	rst $00

StairwayStates::
	dw StairwayDescend
	dw StairwayLinkClimbs
	dw StairwayIdle
	dw StairwayFade
	dw StairwayGone

StairwayDescend::
	ldh a, [hActiveEntityDrawY]
	cp $60
	jp z, Call_3B8D

	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], $08
	call UpdateEntityPosY
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nz, jr_017_75a9

	ld hl, wEntityPrivate2
	add hl, bc
	ld a, [hl]
	cp $08
	jr nc, jr_017_75a9

	inc a
	ld [hl], a
	ld hl, wEntityY
	add hl, bc
	ld [hl], $e0

jr_017_75a9:
	ld a, $ff
	ldh [hLinkSpeedY], a

AnimateLinkOnStairway::
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	add $00
	ldh [hLinkAnimationState], a

DrawLinkForEnding::
	push bc
	xor a
	ldh [hLinkSpeedX], a
	call ApplyLinkSpeed
	call DrawLinkSprites
	pop bc
	ret


StairwayLinkClimbs::
	ld a, $f8
	ldh [hLinkSpeedY], a
	call AnimateLinkOnStairway
	ldh a, [hLinkY]
	cp $5c
	jr nz, jr_017_75fe

	xor a
	ldh [hLinkSpeedY], a
	ld a, $02
	ldh [hLinkAnimationState], a
	ld a, $e8
	call Call_3C01
	ld hl, wEntityPrivate1
	add hl, de
	ld [hl], $02
	ld hl, wEntityX
	add hl, de
	ld [hl], $50
	ld hl, wEntityY
	add hl, de
	ld [hl], $00
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], $14
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $30
	call Call_3B8D

jr_017_75fe:
	ret


StairwayIdle::
	call DrawLinkForEnding
	ret


StairwayFade::
	call DrawLinkForEnding
	call GetEntityTimer
	jr nz, jr_017_761b

	ld [hl], $08
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $05
	jr nz, jr_017_761b

	call Call_3B8D

jr_017_761b:
	call DrawLinkForEnding
	ret


StairwayGone::
	call DrawLinkForEnding
	ret


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
StairwaySpriteBytes::
	db $70, $68, $60, $58, $50, $48, $40, $38, $30, $30, $30, $30, $30, $30, $80, $78

DrawStairway::
	push bc
	ldh a, [hActiveEntityDrawY]
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $78a3
	add hl, de
	ld b, [hl]
	ld hl, $7623
	ldh a, [hActiveEntitySpriteVariant]
	cp $05
	jr z, jr_017_790a

	and a
	jr z, jr_017_78e2

	ld hl, $76a3
	dec a
	jr z, jr_017_78e2

	ld hl, $7723
	dec a
	jr z, jr_017_78e2

	ld hl, $77a3
	dec a
	jr z, jr_017_78e2

	ld hl, $7823

jr_017_78e2:
	ld de, $c00c
	ld c, $00

jr_017_78e7:
	ld a, c
	and $03
	cp $00
	jr nz, jr_017_78f2

	ldh a, [hActiveEntityDrawY]
	jr jr_017_78fe

jr_017_78f2:
	cp $01
	jr nz, jr_017_7901

	push hl
	ld hl, wScreenShakeX
	ldh a, [hActiveEntityX]
	sub [hl]
	pop hl

jr_017_78fe:
	add [hl]
	jr jr_017_7902

jr_017_7901:
	ld a, [hl]

jr_017_7902:
	ld [de], a
	inc hl
	inc de
	inc c
	ld a, c
	cp b
	jr nz, jr_017_78e7

jr_017_790a:
	pop bc
	ret


EndingStars::
	call DrawStars
	ret


StarsX::
	db $20, $40, $60, $78, $10, $48, $68, $90, $30, $50, $80, $90, $18, $38, $68, $78
StarsY::
	db $28, $08, $28, $00, $48, $40, $4c, $38, $68, $70, $58, $68, $78, $88, $98, $80
StarsTiles::
	db $1e, $1e, $1e, $2e, $2e, $3e, $2e, $2e

DrawStars::
	ld de, $c090
	push bc
	ldh a, [hFrameCounter]
	and $01
	ld c, a

jr_017_7941:
	ld hl, $7920
	add hl, bc
	ldh a, [hActiveEntityDrawY]
	add [hl]
	cp $98
	jr c, jr_017_794e

	sub $88

jr_017_794e:
	ld [de], a
	inc de
	ld hl, $7910
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	push bc
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	nop
	xor c
	and $07
	ld c, a
	ld b, $00
	ld hl, $7930
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	ld a, $90
	ld [de], a
	inc de
	inc c
	inc c
	ld a, c
	cp $10
	jr c, jr_017_7941

	pop bc
	ret


OwlSprites::
	db $00, $f8, $58, $00, $00, $00, $68, $00, $00, $08, $68, $20, $00, $10, $58, $20
	db $00, $f8, $5a, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $5a, $20
	db $00, $f8, $5c, $00, $00, $00, $6c, $00, $00, $08, $6c, $20, $00, $10, $5c, $20
	db $00, $f8, $5e, $00, $00, $00, $6e, $00, $00, $08, $6e, $20, $00, $10, $5e, $20

EndingOwl::
	ld a, $50
	ld [wOAMNextIndex], a
	ld hl, $797a
	ldh a, [hActiveEntitySpriteVariant]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $03
	call Call_3B87
	ldh a, [hActiveEntityState]
	rst $00

OwlStates::
	dw OwlDescend
	dw OwlTalk
	dw OwlWaitDialog
	dw OwlFlyAway

OwlDescend::
	call GetEntityTimer
	jr nz, jr_017_7a09

	call UpdateEntityPosY
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_017_7a09

	ld hl, wEntitySpeedY
	add hl, bc
	dec [hl]
	jr nz, jr_017_7a09

	call GetEntityTimer
	ld [hl], $80
	call Call_3B8D

jr_017_7a09:
	ret


OwlHoverHeights::
	db $00, $00, $00, $01, $01, $02, $03, $03, $04, $04, $04, $03, $03, $02, $01, $01

OwlTalk::
	call GetEntityTimer
	jr nz, OwlHover

	ld a, $cf
	call OpenEndingDialog
	ld a, $19
	ld [wDialogSfx], a
	call Call_3B8D

OwlHover::
	ld hl, wEntityPrivateCounter
	add hl, bc
	ld a, [hl]
	ld a, [hl]
	inc [hl]
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $7a0a
	add hl, de
	ld a, [hl]
	ld hl, wEntityZ
	add hl, bc
	ld [hl], a
	ret


OwlWaitDialog::
	call OwlHover
	ld a, [wDialogState]
	and a
	jr nz, jr_017_7a55

	call GetEntityTimer
	ld [hl], $ff
	call Call_3B8D

jr_017_7a55:
	ret


OwlFlyAway::
	call OwlHover
	call GetEntityTimer
	jr nz, jr_017_7a67

jr_017_7a5e:
	call EndingNextStep

RemoveEndingObject::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


jr_017_7a67:
	cp $e0
	jr nc, jr_017_7a8e

	cp $df
	jr nz, jr_017_7a73

	ld a, $26
	ldh [hJingle], a

jr_017_7a73:
	ld hl, wEntityPrivate3
	add hl, bc
	ld e, [hl]
	ld a, [hl]
	cp $fc
	jr nc, jr_017_7a5e

	add $02
	ld [hl], a
	ld hl, wEntityPrivate4
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_017_7a8e

	ld a, $ff
	call Call_3B87

jr_017_7a8e:
	ret


OpenEndingDialog::
	ld e, a
	ldh a, [hLinkY]
	push af
	ld a, $10
	ldh [hLinkY], a
	ld a, e
	call OpenDialog
	pop af
	ldh [hLinkY], a
	ret


LinkCreditsPoses::
	db $00, $00, $02, $00, $02, $20, $00, $20, $44, $00, $46, $00, $48, $00, $4a, $00
	db $4c, $00, $4c, $20, $d8, $20, $d6, $20, $d4, $00, $d4, $20, $d6, $00, $d8, $00
	db $da, $00, $dc, $00, $de, $00, $e0, $00, $e2, $00, $e2, $20, $e0, $20, $de, $20
	db $dc, $20, $da, $20

DrawLinkSprites::
	ldh a, [hLinkAnimationState]
	rla
	rla
	and $fc
	ld e, a
	ld d, $00
	ld hl, $7a9f
	add hl, de
	push hl
	pop de
	ld hl, $c004
	ldh a, [hLinkY]
	ld [hli], a
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hLinkX]
	sub c
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ldh a, [hLinkY]
	ld [hli], a
	ldh a, [hLinkX]
	sub c
	add $08
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret


DialogArrowY::
	db $37, $7f

DrawDialogArrow::
	db $f0, $e7, $e6, $10, $c0, $1e, $00, $fa, $9f, $c1, $e6, $80, $28, $01, $1c, $16
	db $00, $fa, $95, $db, $fe, $01, $28, $18, $21, $05, $7b, $19, $7e, $ea, $18, $c0
	db $3e, $97, $ea, $19, $c0, $3e, $a2, $ea, $1a, $c0, $3e, $40, $ea, $1b, $c0, $c9
	db $21, $05, $7b, $19, $7e, $21, $97, $ff, $96, $ea, $00, $c0, $3e, $97, $ea, $01
	db $c0, $3e, $fe, $ea, $02, $c0, $3e, $40, $ea, $03, $c0, $c9


DialogChoiceY::
	db $30, $78

DialogChoiceX::
	db $30, $58

DrawDialogChoiceCursor::
	db $1e, $00, $fa, $9f, $c1, $e6, $80, $28, $01, $1c, $16, $00, $fa, $95, $db, $fe
	db $01, $28, $25, $21, $53, $7b, $19, $7e, $ea, $18, $c0, $1e, $00, $fa, $77, $c1
	db $e6, $01, $28, $01, $1c, $21, $55, $7b, $19, $7e, $ea, $19, $c0, $3e, $3e, $ea
	db $1a, $c0, $3e, $00, $ea, $1b, $c0, $c9, $21, $53, $7b, $19, $7e, $21, $97, $ff
	db $96, $ea, $00, $c0, $1e, $00, $fa, $77, $c1, $e6, $01, $28, $01, $1c, $21, $55
	db $7b, $19, $7e, $ea, $01, $c0, $3e, $9e, $ea, $02, $c0, $3e, $00, $ea, $03, $c0
	db $c9


UpdateEntityPosition::
	call UpdateEntityPosX

UpdateEntityPosY::
	push bc
	ld a, c
	add $10
	ld c, a
	call UpdateEntityPosX
	pop bc
	ret


UpdateEntityPosX::
	ld hl, wEntitySpeedX
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_017_7bf0

	push af
	swap a
	and $f0
	ld hl, wEntitySpeedXAcc
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, wEntityX
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_017_7be7

	ld e, $f0

jr_017_7be7:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_017_7bf0:
	ret


UnusedUpdateEntityPosZ::
	db $21, $20, $c3, $09, $7e, $a7, $28, $f7, $f5, $cb, $37, $e6, $f0, $21, $30, $c3
	db $09, $86, $77, $cb, $12, $21, $10, $c3, $18, $d2

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
