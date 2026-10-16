; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01f", ROMX[$4000], BANK[$1f]

;@ def SoundEntryInit()
;@ path: sound/sfx/engine
;@ Entry point $4000 of the sound effect bank, called by Init at power-on: sets the sound engines up
;@ (InitSoundEngine).
;@ test: skip resets the whole sound state
SoundEntryInit::
;> return InitSoundEngine()
	jp InitSoundEngine


;@ def SoundEntryStopAll()
;@ path: sound/sfx/engine
;@ Entry point $4003 of the sound effect bank: stops all music and sound effects (StopAllSound).
;@ test: skip resets the whole sound state
SoundEntryStopAll::
;> return StopAllSound()
	jp StopAllSound


;@ def SoundEntryUpdate()
;@ path: sound/sfx/engine
;@ Entry point $4006 of the sound effect bank, called once a frame by UpdateSound: plays the sound effects
;@ on (UpdateSoundEffects).
;@ test: skip runs the effect routines through their tables
SoundEntryUpdate::
;> return UpdateSoundEffects()
	jp UpdateSoundEffects


;@ def InitSoundEngine()
;@ path: sound/sfx/engine
;@ Entry $4000: clears all of the sound engines' RAM ($D300-$D3FF) and switches the sound on, at full volume
;@ on both sides, every channel on both speakers.
InitSoundEngine::
;> fill(0xD300, 0, 0x100)                     # wMusicTranspose up to $D3FF
	ld hl, wMusicTranspose
.clear
	ld [hl], $00
	inc l
	jr nz, .clear
;> rNR52 = 0x80                               # sound on
	ld a, $80
	ldh [rNR52], a
;> rNR50 = 0x77                               # full volume left and right
	ld a, $77
	ldh [rNR50], a
;> rNR51 = 0xFF                               # every channel on both speakers
	ld a, $ff
	ldh [rNR51], a
	ret


;@ def UpdateSoundEffects()
;@ path: sound/sfx/engine
;@ The sound effect engine for one frame (entry $4006): the square, wave and noise channel effects each
;@ start the new request or play on, then the three requests are cleared. Each channel plays one effect at a
;@ time; an effect takes its channel away from the music while it plays.
;@ test: skip runs the effect routines through their tables
UpdateSoundEffects::
;> UpdateJingle()
	call UpdateJingle
;> UpdateWaveSfx()
	call UpdateWaveSfx
;> UpdateNoiseSfx()
	call UpdateNoiseSfx
;> wJingleToPlay = 0
	xor a
	ld [wJingleToPlay], a
;> wWaveSfxToPlay = 0
	ld [wWaveSfxToPlay], a
;> wNoiseSfxToPlay = 0
	ld [wNoiseSfxToPlay], a
	ret

;@ path: unused
;@ Unused space ($FF bytes).
Padding_1F_4032::
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
;@ path: sound/sfx/engine
;@ The start routines of the square-channel effects, one per effect number ($01-$41): UpdateJingle jumps to
;@ entry n-1 when effect n is requested. JingleUpdates right after it: the routines that play each effect
;@ on, once a frame (effect $10 ends at once).
JingleStarts::
	dw Jingle01_Start, Jingle02_Start, Jingle03_Start, Jingle04_Start, Jingle05_Start, Jingle06_Start, Jingle07_Start, Jingle08_Start
	dw Jingle09_Start, Jingle0A_Start, Jingle0B_Start, Jingle0C_Start, Jingle0D_Start, Jingle0E_Start, Jingle0F_Start, Jingle10_Start
	dw Jingle11_Start, Jingle12_Start, Jingle13_Start, Jingle14_Start, Jingle15_Start, Jingle16_Start, Jingle17_Start, Jingle18_Start
	dw Jingle19_Start, Jingle1A_Start, Jingle1B_Start, Jingle1C_Start, Jingle1D_Start, Jingle1E_Start, Jingle1F_Start, Jingle20_Start
	dw Jingle21_Start, Jingle22_Start, Jingle23_Start, Jingle24_Start, Jingle25_Start, Jingle26_Start, Jingle27_Start, Jingle28_Start
	dw Jingle29_Start, Jingle2A_Start, Jingle2B_Start, Jingle2C_Start, Jingle2D_Start, Jingle2E_Start, Jingle2F_Start, Jingle30_Start
	dw Jingle31_Start, Jingle32_Start, Jingle33_Start, Jingle34_Start, Jingle35_Start, Jingle36_Start, Jingle37_Start, Jingle38_Start
	dw Jingle39_Start, Jingle3A_Start, Jingle3B_Start, Jingle3C_Start, Jingle3D_Start, Jingle3E_Start, Jingle3F_Start, Jingle40_Start
	dw Jingle41_Start
JingleUpdates:
	dw Jingle01_Update, Jingle02_Update, Jingle03_Update, Jingle04_Update, Jingle05_Update, Jingle06_Update, Jingle07_Update, Jingle08_Update
	dw Jingle09_Update, Jingle0A_Update, Jingle0B_Update, Jingle0C_Update, Jingle0D_Update, Jingle0E_Update, Jingle0F_Update, EndJingle
	dw Jingle11_Update, Jingle12_Update, Jingle13_Update, Jingle14_Update, Jingle15_Update, Jingle16_Update, Jingle17_Update, Jingle18_Update
	dw Jingle19_Update, Jingle1A_Update, Jingle1B_Update, Jingle1C_Update, Jingle1D_Update, Jingle1E_Update, Jingle1F_Update, Jingle20_Update
	dw Jingle21_Update, Jingle22_Update, Jingle23_Update, Jingle24_Update, Jingle25_Update, Jingle26_Update, Jingle27_Update, Jingle28_Update
	dw Jingle29_Update, Jingle2A_Update, Jingle2B_Update, Jingle2C_Update, Jingle2D_Update, Jingle2E_Update, Jingle2F_Update, Jingle30_Update
	dw Jingle31_Update, Jingle32_Update, Jingle33_Update, Jingle34_Update, Jingle35_Update, Jingle36_Update, Jingle37_Update, Jingle38_Update
	dw Jingle39_Update, Jingle3A_Update, Jingle3B_Update, Jingle3C_Update, Jingle3D_Update, Jingle3E_Update, Jingle3F_Update, Jingle40_Update
	dw Jingle41_Update

;@ def UpdateJingle()
;@ path: sound/sfx/engine
;@ The square-channel effects for one frame. A request in wJingleToPlay starts that effect (its routine in
;@ JingleStarts) unless a locked effect plays - effect 1 starts anyway; without a request the effect in
;@ wActiveJingle plays on (its routine in JingleUpdates). Every routine gets de = wJingleTimer and bc =
;@ wJingleStep.
;@ test: skip jumps through a table of routines
UpdateJingle::
;> request = wJingleToPlay
	ld hl, wJingleToPlay
	ld a, [hl]
;> if request:
	and a
	jr z, .playOn
;>     if request != 1 and wJingleLocked: return IgnoreJingle()
	cp $01
	jr z, .start
	ld a, [wJingleLocked]
	and a
	jp nz, IgnoreJingle
;>     table, index = JingleStarts, request
.start
	ld a, [hl]
	ld hl, JingleStarts
	jr .call
;> else:
;>     if wActiveJingle == 0: return
.playOn
	inc hl
	ld a, [hl]
	and a
	ret z
;>     table, index = JingleUpdates, wActiveJingle
	ld hl, JingleUpdates
;> routine = GetSfxTableEntry(index, table)
.call
	call GetSfxTableEntry
;> raise NotModeled('jp hl: the routine from the table, called with de = addr(wJingleTimer), bc = addr(wJingleStep)')
	ld de, wJingleTimer
	ld bc, wJingleStep
	jp hl

;@ def Jingle01_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $01, Gift chord: someone hands over or takes a trade item (the witch, Tarin,
;@ Kiki, Grandma Ulrira). It locks its channel, so that other effects of the channel are ignored until it
;@ ends; loads wave pattern SfxWave2.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle01_Start::
;> wWaveSfxToPlay = 0
	xor a
	ld [wWaveSfxToPlay], a
;> wActiveWaveSfx = 0
	ld [wActiveWaveSfx], a
;> rNR30 = 0
	ldh [rNR30], a
;> wWaveSfxLocked = 0x01
	ld a, $01
	ld [wWaveSfxLocked], a
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> wMusicChannel3[0x0F] |= 0x80
	ld hl, wMusicChannel3 + $0F
	set 7, [hl]
;> WriteSquare2Regs(Jingle01_Sq2, timer)
	ld hl, Jingle01_Sq2
	call WriteSquare2Regs
;> LoadSfxWave2()
	call LoadSfxWave2
;> WriteWaveRegs(Jingle01_Wave, timer)
	ld hl, Jingle01_Wave
	call WriteWaveRegs
;> return StartLockedJingle(Jingle01_Sq1, timer)
	ld hl, Jingle01_Sq1
	jp StartLockedJingle

;@ def Jingle01_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $01 (Gift chord) on: each time its timer runs out, the next step. At the end
;@ the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle01_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 1:
	cp $01
	jr z, .case1
.part1
;=@t1
	cp $02
	jr z, .case2
.part2
;=@t2
	cp $03
	jr z, .case3
.part3
;=@t3
	cp $04
	jr z, .case4
.part4
;=@t4
	jr .part5
;>     WriteSquare1Regs(Jingle01_Sq1_2, timer)
.case1
	ld hl, Jingle01_Sq1_2
	call WriteSquare1Regs
;>     WriteSquare2Regs(Jingle01_Sq2_2, timer)
	ld hl, Jingle01_Sq2_2
	call WriteSquare2Regs
;>     return WriteWaveRegs(Jingle01_Wave_2, timer)
	ld hl, Jingle01_Wave_2
	jp WriteWaveRegs
;>@t1 if wJingleStep == 2:
;>     WriteSquare1Regs(Jingle01_Sq1_3, timer)
.case2
	ld hl, Jingle01_Sq1_3
	call WriteSquare1Regs
;>     WriteSquare2Regs(Jingle01_Sq2_3, timer)
	ld hl, Jingle01_Sq2_3
	call WriteSquare2Regs
;>     return WriteWaveRegs(Jingle01_Wave_3, timer)
	ld hl, Jingle01_Wave_3
	jp WriteWaveRegs
;>@t2 if wJingleStep == 3:
;>     WriteSquare1Regs(Jingle01_Sq1_4, timer)
.case3
	ld hl, Jingle01_Sq1_4
	call WriteSquare1Regs
;>     WriteSquare2Regs(Jingle01_Sq2_4, timer)
	ld hl, Jingle01_Sq2_4
	call WriteSquare2Regs
;>     return WriteWaveRegs(Jingle01_Wave_4, timer)
	ld hl, Jingle01_Wave_4
	jp WriteWaveRegs
;>@t3 if wJingleStep == 4:
;>     WriteSquare1Regs(Square1Off, timer)
.case4
	ld hl, Square1Off
	call WriteSquare1Regs
;>     WriteSquare2Regs(Square2Off, timer)
	ld hl, Square2Off
	call WriteSquare2Regs
;>     return WriteWaveRegs(Square1Off, timer)
	ld hl, Square1Off
	jp WriteWaveRegs
.part5
;=@t4
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;>@t4 wMusicChannel2[0x0F] &= 0x7F
;> wMusicChannel3[0x0F] &= 0x7F
	ld hl, wMusicChannel3 + $0F
	res 7, [hl]
;> rNR30 = 0
	xor a
	ldh [rNR30], a
;> wWaveSfxLocked = 0
	ld [wWaveSfxLocked], a
;> wWaveRamDirty = 0x01
	ld a, $01
	ld [wWaveRamDirty], a
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $01 (Gift chord), read by Jingle01_Start / Jingle01_Update.
;@ Jingle01_Sq1, Jingle01_Sq1_2, Jingle01_Sq1_3, Jingle01_Sq1_4, Square1Off: square 1 register records, 6
;@ bytes each: NR10 sweep, NR11 duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7
;@ restarts the sound), then the frames until the next step.
;@ Jingle01_Sq2, Jingle01_Sq2_2, Jingle01_Sq2_3, Jingle01_Sq2_4, Square2Off: square 2 register records, 5
;@ bytes each: NR21 duty and length, NR22 volume envelope, NR23 / NR24 frequency (NR24 bit 7 restarts the
;@ sound), then the frames until the next step.
;@ Jingle01_Wave, Jingle01_Wave_2, Jingle01_Wave_3, Jingle01_Wave_4: wave channel register records, 6 bytes
;@ each: NR30 on ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the
;@ sound), then the frames until the next step.
Jingle01_Data::
Jingle01_Sq1:
	db $00, $80, $80, $89, $86, $0a
Jingle01_Sq1_2:
	db $00, $80, $80, $9e, $86, $0a
Jingle01_Sq1_3:
	db $00, $80, $80, $b2, $86, $0a
Jingle01_Sq1_4:
	db $00, $80, $80, $c4, $86, $30
Jingle01_Sq2:
	db $00, $c0, $06, $87, $0a
Jingle01_Sq2_2:
	db $00, $c0, $14, $87, $0a
Jingle01_Sq2_3:
	db $00, $c0, $21, $87, $0a
Jingle01_Sq2_4:
	db $00, $c0, $2d, $87, $30
Jingle01_Wave:
	db $80, $00, $20, $6b, $87, $0a
Jingle01_Wave_2:
	db $80, $00, $20, $73, $87, $0a
Jingle01_Wave_3:
	db $80, $00, $20, $7b, $87, $0a
Jingle01_Wave_4:
	db $80, $00, $20, $83, $87, $30
Square1Off:
	db $00, $00, $00, $00, $c0, $20
Square2Off:
	db $3f, $00, $00, $c1, $20

;@ def Jingle02_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $02, Secret chime: a puzzle is solved or a secret appears (room events,
;@ Kiki's bridge, the mermaid statue, the signpost maze). It locks its channel, so that other effects of the
;@ channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle02_Start::
;> return StartLockedJingle(Jingle02_Sq1, timer)
	ld hl, Jingle02_Sq1
	jp StartLockedJingle

;@ def Jingle02_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $02 (Secret chime) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle02_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 8: return EndJingle()
	cp $08
	jp z, EndJingle
;> record = mem16[Jingle02_Sq1FreqTable + 2 * (wJingleStep - 1)]
	ld hl, Jingle02_Sq1FreqTable
	call GetSfxTableEntry
;> rNR11 = 0x80
	ld a, $80
	ldh [rNR11], a
;> rNR12 = 0xF1
	ld a, $f1
	ldh [rNR12], a
;> return WriteSquare1Freq(record, timer)
	jp WriteSquare1Freq

;@ path: sound/sfx/square
;@ The data of square-channel effect $02 (Secret chime), read by Jingle02_Start / Jingle02_Update.
;@ Jingle02_Sq1FreqTable: one pointer per step (the first for step 1) to its record (square 1 notes).
;@ Jingle02_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle02_Sq1Freq, Jingle02_Sq1Freq_2, Jingle02_Sq1Freq_3, Jingle02_Sq1Freq_4, Jingle02_Sq1Freq_5,
;@ Jingle02_Sq1Freq_6, Jingle02_Sq1Freq_7: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the
;@ frames until the next step.
Jingle02_Data::
Jingle02_Sq1FreqTable:
	dw Jingle02_Sq1Freq, Jingle02_Sq1Freq_2, Jingle02_Sq1Freq_3, Jingle02_Sq1Freq_4, Jingle02_Sq1Freq_5, Jingle02_Sq1Freq_6, Jingle02_Sq1Freq_7
Jingle02_Sq1:
	db $00, $80, $f1, $a7, $c7, $08
Jingle02_Sq1Freq:
	db $a2, $c7, $08
Jingle02_Sq1Freq_2:
	db $90, $c7, $08
Jingle02_Sq1Freq_3:
	db $7b, $c7, $08
Jingle02_Sq1Freq_4:
	db $59, $c7, $08
Jingle02_Sq1Freq_5:
	db $97, $c7, $08
Jingle02_Sq1Freq_6:
	db $ac, $c7, $08
Jingle02_Sq1Freq_7:
	db $be, $c7, $20

;@ def Jingle03_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $03, BowWow bite: BowWow bites.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle03_Start::
;> SaveSquare1Freq(Jingle03_Sq1)
	ld hl, Jingle03_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle03_Sq1, timer)
	jp StartJingle

;@ def Jingle03_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $03 (BowWow bite) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle03_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 13: return SilenceJingle(timer)
	cp $0d
	jp z, SilenceJingle
;> return SlideSquare1(Jingle03_Slide, step)
	ld hl, Jingle03_Slide
	jp SlideSquare1

;@ path: sound/sfx/square
;@ The data of square-channel effect $03 (BowWow bite), read by Jingle03_Start / Jingle03_Update.
;@ Jingle03_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle03_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle03_Data::
Jingle03_Slide:
	db $ff, $c0, $ff, $80, $ff, $00, $fe, $00, $01, $00, $ff, $00, $01, $00, $ff, $00
	db $00, $c0, $00, $c0, $00, $c0, $00, $c0
Jingle03_Sq1:
	db $00, $00, $c0, $80, $86, $01

;@ def Jingle04_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $04, Sword charged: the sword is fully charged for a spin attack. Its steps
;@ run 14 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle04_Start::
;> wJingleRepeat = 14
	ld a, $0e
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle04_Sq1)
	ld hl, Jingle04_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle04_Sq1, timer)
	jp StartJingle

;@ def Jingle04_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $04 (Sword charged) on: each time its timer runs out, the next step. The
;@ frequency slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle04_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> if wActiveNoiseSfx == 0x02: return SilenceJingle(timer)
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, SilenceJingle
;> wJingleTimer = 2
	ld a, $02
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle04_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle04_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $04 (Sword charged), read by Jingle04_Start / Jingle04_Update.
;@ Jingle04_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle04_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle04_Data::
Jingle04_Slide:
	db $00, $20, $ff, $f0
Jingle04_Sq1:
	db $00, $80, $87, $c0, $86, $02

;@ def Jingle05_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $05, Magic powder: Link sprinkles magic powder. Its steps run 4 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle05_Start::
;> wJingleRepeat = 4
	ld a, $04
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle05_Sq1)
	ld hl, Jingle05_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle05_Sq1, timer)
	jp StartJingle

;@ def Jingle05_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $05 (Magic powder) on: each time its timer runs out, the next step. The
;@ frequency slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle05_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 4
	ld a, $04
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 5:
	cp $05
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle05_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle05_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $05 (Magic powder), read by Jingle05_Start / Jingle05_Update.
;@ Jingle05_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle05_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle05_Data::
Jingle05_Slide:
	db $00, $06, $00, $04, $00, $02, $ff, $f4
Jingle05_Sq1:
	db $00, $00, $c5, $d8, $87, $04

;@ def Jingle06_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $06, Magic appearance: the genie leaves its bottle, the Mad Batter appears.
;@ It locks its channel, so that other effects of the channel are ignored until it ends; its steps run 10
;@ times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle06_Start::
;> wJingleRepeat = 10
	ld a, $0a
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle06_Sq1)
	ld hl, Jingle06_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle06_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle06_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $06 (Magic appearance) on, a step every frame. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle06_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle06_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle06_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $06 (Magic appearance), read by Jingle06_Start / Jingle06_Update.
;@ Jingle06_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle06_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle06_Data::
Jingle06_Slide:
	db $00, $40, $00, $80, $00, $80, $00, $40, $ff, $d0, $ff, $a0, $ff, $a0, $ff, $d0
Jingle06_Sq1:
	db $00, $80, $1b, $00, $82, $01

;@ def Jingle07_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $07, Clink: the sword, the shovel or the boomerang hits something hard.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle07_Start::
;> return StartJingle(Jingle07_Sq1, timer)
	ld hl, Jingle07_Sq1
	jp StartJingle

;@ def Jingle07_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $07 (Clink) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle07_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return EndJingle()
	cp $02
	jp z, EndJingle
;> return WriteSquare1Regs(Jingle07_Sq1_2, timer)
	ld hl, Jingle07_Sq1_2
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $07 (Clink), read by Jingle07_Start / Jingle07_Update.
;@ Jingle07_Sq1, Jingle07_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle07_Data::
Jingle07_Sq1:
	db $00, $3d, $f0, $d8, $c7, $03
Jingle07_Sq1_2:
	db $00, $00, $81, $e0, $87, $08

;@ def Jingle08_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $08, Throw: something is grabbed or thrown (Mad Bomber, Monkey, Smasher,
;@ Hinox, the walrus rolling).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle08_Start::
;> return StartJingle(Jingle08_Sq1, timer)
	ld hl, Jingle08_Sq1
	jp StartJingle

;@ def Jingle08_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $08 (Throw) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle08_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return EndJingle()
	cp $02
	jp z, EndJingle
;> return WriteSquare1Regs(Jingle08_Sq1_2, timer)
	ld hl, Jingle08_Sq1_2
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $08 (Throw), read by Jingle08_Start / Jingle08_Update.
;@ Jingle08_Sq1, Jingle08_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle08_Data::
Jingle08_Sq1:
	db $3f, $9e, $29, $80, $c7, $08
Jingle08_Sq1_2:
	db $1f, $9f, $81, $20, $87, $10

;@ def Jingle09_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $09, Bonk: a bomb is put down, a coconut or Pokey segment bounces, the map
;@ cursor cannot move.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle09_Start::
;> SaveSquare1Freq(Jingle09_Sq1)
	ld hl, Jingle09_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle09_Sq1, timer)
	jp StartJingle

;@ def Jingle09_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $09 (Bonk) on, a step every frame. The frequency slides by a table of steps.
;@ At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle09_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9: return SilenceJingle(timer)
	cp $09
	jp z, SilenceJingle
;> return SlideSquare1(Jingle09_Slide, step)
	ld hl, Jingle09_Slide
	jp SlideSquare1

;@ path: sound/sfx/square
;@ The data of square-channel effect $09 (Bonk), read by Jingle09_Start / Jingle09_Update.
;@ Jingle09_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle09_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle09_Data::
Jingle09_Slide:
	db $01, $00, $00, $c0, $00, $80, $00, $40, $ff, $c0, $ff, $80, $ff, $40, $ff, $00
Jingle09_Sq1:
	db $00, $9f, $a0, $00, $c2, $01

;@ def Jingle0A_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0A, Cursor: a menu cursor or a dialog choice moves. Some running effects
;@ keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle0A_Start::
;> if wActiveJingle == 0x13: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $13
	jp z, IgnoreJingle
;> if rNR50 != 0x77:
	ldh a, [rNR50]
	cp $77
	jr nz, .case1
;>@t1     record = Jingle0A_Sq1_2
;> else:
;>     record = Jingle0A_Sq1
.part1
	ld hl, Jingle0A_Sq1
;> return StartJingle(record, timer)
.part2
	jp StartJingle
.case1
;=@t1
	ld hl, Jingle0A_Sq1_2
	jr .part2

;@ def Jingle0A_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0A (Cursor) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0A_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return EndJingle()
	cp $02
	jp z, EndJingle
;> if rNR50 != 0x77:
	ldh a, [rNR50]
	cp $77
	jr nz, .case1
;>@t1     value = 0x20
;> else:
;>     value = 0x10
.part1
	ld a, $10
;> rNR12 = value
.part2
	ldh [rNR12], a
;> rNR14 = 0xC7
	ld a, $c7
	ldh [rNR14], a
;> wJingleTimer = 8
	ld a, $08
	ld [de], a
;> return
	ret
.case1
;=@t1
	ld a, $20
	jr .part2

;@ path: sound/sfx/square
;@ The data of square-channel effect $0A (Cursor), read by Jingle0A_Start / Jingle0A_Update.
;@ Jingle0A_Sq1, Jingle0A_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle0A_Data::
Jingle0A_Sq1:
	db $00, $9f, $80, $a0, $c7, $02
Jingle0A_Sq1_2:
	db $00, $9f, $f0, $a0, $c7, $02

;@ def Jingle0B_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0B, Stomp: a heavy boss lands or charges (Slime Eye, Armos Knight, Moblin
;@ King). It locks its channel, so that other effects of the channel are ignored until it ends; its steps
;@ run 5 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0B_Start::
;> wJingleRepeat = 5
	ld a, $05
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle0B_Sq1)
	ld hl, Jingle0B_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle0B_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle0B_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0B (Stomp) on: each time its timer runs out, the next step. The frequency
;@ slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0B_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 2
	ld a, $02
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 7:
	cp $07
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle0B_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle0B_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $0B (Stomp), read by Jingle0B_Start / Jingle0B_Update.
;@ Jingle0B_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle0B_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle0B_Data::
Jingle0B_Slide:
	db $ff, $c0, $ff, $80, $ff, $40, $00, $c0, $00, $80, $00, $40
Jingle0B_Sq1:
	db $00, $80, $f4, $80, $83, $01

;@ def Jingle0C_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0C (bank $02). Its steps run 22 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0C_Start::
;> wJingleRepeat = 22
	ld a, $16
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle0C_Sq1)
	ld hl, Jingle0C_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle0C_Sq1, timer)
	jp StartJingle

;@ def Jingle0C_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0C on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0C_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 4:
	cp $04
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle0C_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 8:
	cp $08
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle0C_Sq1_2)
	ld hl, Jingle0C_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle0C_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle0C_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $0C, read by Jingle0C_Start / Jingle0C_Update.
;@ Jingle0C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle0C_Sq1, Jingle0C_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle0C_Data::
Jingle0C_Slide:
	db $00, $28, $00, $00, $ff, $f0
Jingle0C_Sq1:
	db $00, $83, $47, $c0, $86, $02
Jingle0C_Sq1_2:
	db $00, $83, $47, $00, $87, $02

;@ def Jingle0D_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0D, Jump: Link jumps with Roc's Feather.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0D_Start::
;> return StartJingle(Jingle0D_Sq1, timer)
	ld hl, Jingle0D_Sq1
	jp StartJingle

;@ def Jingle0D_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0D (Jump) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0D_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $0D (Jump), read by Jingle0D_Start / Jingle0D_Update.
;@ Jingle0D_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle0D_Sq1::
	db $27, $80, $c2, $48, $86, $18

;@ def Jingle0E_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0E, Splash: something splashes into water (Link, fish, a Zora, the
;@ mermaid). Some running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle0E_Start::
;> if wActiveJingle != 0x08:
	ld a, [wActiveJingle]
	cp $08
	jr z, .case1
;>     if wActiveJingle: return IgnoreJingle()
.part1
	and a
	jp nz, IgnoreJingle
;> return StartJingle(Jingle0E_Sq1, timer)
.case1
	ld hl, Jingle0E_Sq1
	jp StartJingle

;@ def Jingle0E_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0E (Splash) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0E_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $0E (Splash), read by Jingle0E_Start / Jingle0E_Update.
;@ Jingle0E_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle0E_Sq1::
	db $16, $ab, $20, $80, $c6, $05

;@ def Jingle0F_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $0F, Swim stroke: Link swims.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0F_Start::
;> return StartJingle(Jingle0F_Sq1, timer)
	ld hl, Jingle0F_Sq1
	jp StartJingle

;@ def Jingle0F_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $0F (Swim stroke) on: each time its timer runs out, the next step. At the end
;@ the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle0F_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return EndJingle()
	cp $02
	jp z, EndJingle
;> return WriteSquare1Regs(Jingle0F_Sq1_2, timer)
	ld hl, Jingle0F_Sq1_2
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $0F (Swim stroke), read by Jingle0F_Start / Jingle0F_Update.
;@ Jingle0F_Sq1, Jingle0F_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle0F_Data::
Jingle0F_Sq1:
	db $17, $80, $0b, $00, $85, $10
Jingle0F_Sq1_2:
	db $17, $80, $0e, $00, $c5, $10

;@ def Jingle10_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $10, Stop all sound: its start routine is StopAllSound.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle10_Start::
;> return StopAllSound()
	jp StopAllSound

;@ def Jingle11_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $11, Inventory opens: the inventory slides in. Its steps run 23 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle11_Start::
;> wJingleRepeat = 23
	ld a, $17
	ld [wJingleRepeat], a
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> SaveSquare2Freq(Jingle11_Sq2)
	ld hl, Jingle11_Sq2
	call SaveSquare2Freq
;> WriteSquare2Regs(Jingle11_Sq2, timer)
	call WriteSquare2Regs
;> SaveSquare1Freq(Jingle11_Sq1)
	ld hl, Jingle11_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle11_Sq1, timer)
	jp StartJingle

;@ def Jingle11_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $11 (Inventory opens) on, a step every frame. The frequency slides by a table
;@ of steps.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle11_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2:
	cp $02
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle11_Slide
	call SlideSquare2
;=@t2
	ld bc, wJingleStep
	ld hl, Jingle11_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return Jingle11_End(timer)
	jp z, Jingle11_End
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 SlideSquare2(Jingle11_Slide, step)
;>@t2 return SlideSquare1(Jingle11_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $11 (Inventory opens), read by Jingle11_Start / Jingle11_Update.
;@ Jingle11_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle11_Sq2: square 2 register records, 5 bytes each: NR21 duty and length, NR22 volume envelope, NR23 /
;@ NR24 frequency (NR24 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle11_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle11_Data::
Jingle11_Slide:
	db $00, $21
Jingle11_Sq2:
	db $45, $0c, $00, $84, $12
Jingle11_Sq1:
	db $00, $85, $0b, $00, $81, $12

;@ def Jingle11_End(timer: de)
;@ path: sound/sfx/square
;@ The end of square-channel effects $11 and $12 (the inventory sliding in and out): square 2 is silenced
;@ and given back to the music, then square 1 is silenced and the effect ends.
;@ test: timer = 0xD390
Jingle11_End::
;> wMusicChannel2[0x0F] &= 0x7F
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;> WriteSquare2Regs(Square2Off, timer)
	ld hl, Square2Off
	call WriteSquare2Regs
;> return SilenceJingle(timer)
	jp SilenceJingle

;@ def Jingle12_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $12, Inventory closes: the inventory slides out. Its steps run 8 times; some
;@ running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle12_Start::
;> if wActiveJingle == 0x13: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $13
	jp z, IgnoreJingle
;> wJingleRepeat = 8
	ld a, $08
	ld [wJingleRepeat], a
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> SaveSquare2Freq(Jingle12_Sq2)
	ld hl, Jingle12_Sq2
	call SaveSquare2Freq
;> WriteSquare2Regs(Jingle12_Sq2, timer)
	call WriteSquare2Regs
;> SaveSquare1Freq(Jingle12_Sq1)
	ld hl, Jingle12_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle12_Sq1, timer)
	jp StartJingle

;@ def Jingle12_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $12 (Inventory closes) on, a step every frame. The frequency slides by a
;@ table of steps.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle12_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2:
	cp $02
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle12_Slide
	call SlideSquare2
;=@t2
	ld bc, wJingleStep
	ld hl, Jingle12_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return Jingle11_End(timer)
	jp z, Jingle11_End
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 SlideSquare2(Jingle12_Slide, step)
;>@t2 return SlideSquare1(Jingle12_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $12 (Inventory closes), read by Jingle12_Start / Jingle12_Update.
;@ Jingle12_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle12_Sq2: square 2 register records, 5 bytes each: NR21 duty and length, NR22 volume envelope, NR23 /
;@ NR24 frequency (NR24 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle12_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle12_Data::
Jingle12_Slide:
	db $ff, $d0
Jingle12_Sq2:
	db $40, $0a, $b0, $87, $12
Jingle12_Sq1:
	db $00, $80, $09, $c0, $86, $12

;@ def Jingle13_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $13, Confirm: a menu choice is confirmed (file select, save menu), a
;@ glinting tile. Its steps run 5 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle13_Start::
;> wJingleRepeat = 5
	ld a, $05
	ld [wJingleRepeat], a
;> if rNR50 != 0x77:
	ldh a, [rNR50]
	cp $77
	jr nz, .case1
;>@t1     record = Jingle13_Sq1_2
;> else:
;>     record = Jingle13_Sq1
.part1
	ld hl, Jingle13_Sq1
;> SaveSquare1Freq(record)
.part2
	call SaveSquare1Freq
;> return StartJingle(record, timer)
	jp StartJingle
.case1
;=@t1
	ld hl, Jingle13_Sq1_2
	jr .part2

;@ def Jingle13_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $13 (Confirm) on: each time its timer runs out, the next step. The frequency
;@ slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle13_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 3
	ld a, $03
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 4:
	cp $04
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle13_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle13_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $13 (Confirm), read by Jingle13_Start / Jingle13_Update.
;@ Jingle13_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle13_Sq1, Jingle13_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle13_Data::
Jingle13_Slide:
	db $00, $22, $00, $19, $ff, $c5
Jingle13_Sq1:
	db $00, $80, $a4, $7b, $87, $03
Jingle13_Sq1_2:
	db $00, $80, $f3, $7b, $87, $03

;@ def Jingle14_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $14 (not requested directly). Some running effects keep their channel (the
;@ request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle14_Start::
;> if wActiveJingle: return IgnoreJingle()
	ld a, [wActiveJingle]
	and a
	jp nz, IgnoreJingle
;> return StartJingle(Jingle14_Sq1, timer)
	ld hl, Jingle14_Sq1
	jp StartJingle

;@ def Jingle14_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $14 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle14_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $14, read by Jingle14_Start / Jingle14_Update.
;@ Jingle14_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle14_Sq1::
	db $35, $b0, $60, $20, $c7, $04

;@ def Jingle15_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $15, Dialog jingle: a dialog plays its jingle.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle15_Start::
;> return StartJingle(Jingle15_Sq1, timer)
	ld hl, Jingle15_Sq1
	jp StartJingle

;@ def Jingle15_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $15 (Dialog jingle) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle15_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3: return EndJingle()
	cp $03
	jp z, EndJingle
;> record = mem16[Jingle15_Sq1Table + 2 * (wJingleStep - 1)]
	ld hl, Jingle15_Sq1Table
	call GetSfxTableEntry
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $15 (Dialog jingle), read by Jingle15_Start / Jingle15_Update.
;@ Jingle15_Sq1Table: one pointer per step (the first for step 1) to its record (square 1 register records).
;@ Jingle15_Sq1, Jingle15_Sq1_2, Jingle15_Sq1_3: square 1 register records, 6 bytes each: NR10 sweep, NR11
;@ duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the
;@ frames until the next step.
Jingle15_Data::
Jingle15_Sq1Table:
	dw Jingle15_Sq1_2, Jingle15_Sq1_3
Jingle15_Sq1:
	db $00, $b0, $19, $4f, $c7, $06
Jingle15_Sq1_2:
	db $00, $b0, $19, $7b, $c7, $06
Jingle15_Sq1_3:
	db $00, $b0, $29, $9d, $c7, $03

;@ def Jingle16_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $16 (bank $03).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle16_Start::
;> return StartJingle(Jingle16_Sq1, timer)
	ld hl, Jingle16_Sq1
	jp StartJingle

;@ def Jingle16_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $16 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle16_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $16, read by Jingle16_Start / Jingle16_Update.
;@ Jingle16_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle16_Sq1::
	db $00, $00, $81, $bb, $c7, $20

;@ def Jingle17_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $17, Item held up: Link holds up a new item. It locks its channel, so that
;@ other effects of the channel are ignored until it ends; its steps run 42 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle17_Start::
;> wJingleRepeat = 42
	ld a, $2a
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle17_Sq1)
	ld hl, Jingle17_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle17_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle17_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $17 (Item held up) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle17_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle17_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat in (14, 28):
	cp $0e
	jr z, .case2
.part2
	cp $1c
	jr z, .case2
.part3
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         SlideSquare1(Jingle17_Slide, step)
.case2
	ld hl, Jingle17_Slide
	call SlideSquare1
;>         wJingleStep = 0
	xor a
	ld [wJingleStep], a
;>         return
	ret
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle17_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $17 (Item held up), read by Jingle17_Start / Jingle17_Update.
;@ Jingle17_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle17_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle17_Data::
Jingle17_Slide:
	db $00, $20, $ff, $e8, $ff, $90
Jingle17_Sq1:
	db $00, $80, $d7, $68, $87, $01

;@ def Jingle18_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $18, Key falls: a key falls into a pit.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle18_Start::
;> return StartJingle(Jingle18_Sq1, timer)
	ld hl, Jingle18_Sq1
	jp StartJingle

;@ def Jingle18_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $18 (Key falls) on: each time its timer runs out, the next step. At the end
;@ the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle18_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return SilenceJingle(timer)
	cp $02
	jp z, SilenceJingle
;> return WriteSquare1Regs(Jingle18_Sq1_2, timer)
	ld hl, Jingle18_Sq1_2
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $18 (Key falls), read by Jingle18_Start / Jingle18_Update.
;@ Jingle18_Sq1, Jingle18_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle18_Data::
Jingle18_Sq1:
	db $2f, $80, $60, $e0, $86, $14
Jingle18_Sq1_2:
	db $2f, $80, $10, $e0, $86, $14

;@ def Jingle19_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $19, Heart piece: a piece of heart is collected. It locks its channel, so
;@ that other effects of the channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle19_Start::
;> return StartLockedJingle(Jingle19_Sq1, timer)
	ld hl, Jingle19_Sq1
	jp StartLockedJingle

;@ def Jingle19_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $19 (Heart piece) on: each time its timer runs out, the next step. At the end
;@ the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle19_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 5: return EndJingle()
	cp $05
	jp z, EndJingle
;> record = mem16[Jingle19_Sq1Table + 2 * (wJingleStep - 1)]
	ld hl, Jingle19_Sq1Table
	call GetSfxTableEntry
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $19 (Heart piece), read by Jingle19_Start / Jingle19_Update.
;@ Jingle19_Sq1Table: one pointer per step (the first for step 1) to its record (square 1 register records).
;@ Jingle19_Sq1, Jingle19_Sq1_2, Jingle19_Sq1_3, Jingle19_Sq1_4, Jingle19_Sq1_5: square 1 register records,
;@ 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7
;@ restarts the sound), then the frames until the next step.
Jingle19_Data::
Jingle19_Sq1Table:
	dw Jingle19_Sq1_2, Jingle19_Sq1_3, Jingle19_Sq1_4, Jingle19_Sq1_5
Jingle19_Sq1:
	db $00, $80, $c1, $a7, $87, $06
Jingle19_Sq1_2:
	db $00, $80, $c1, $b1, $87, $06
Jingle19_Sq1_3:
	db $00, $80, $c1, $ba, $87, $06
Jingle19_Sq1_4:
	db $00, $80, $c1, $be, $87, $06
Jingle19_Sq1_5:
	db $00, $80, $a3, $c5, $87, $20

;@ def Jingle1A_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1A (bank $06). Some running effects keep their channel (the request is then
;@ ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle1A_Start::
;> if wActiveJingle == 0x1A: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $1a
	jp z, IgnoreJingle
;> return StartJingle(Jingle1A_Sq1, timer)
	ld hl, Jingle1A_Sq1
	jp StartJingle

;@ def Jingle1A_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1A on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1A_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return SilenceJingle(timer)
	cp $02
	jp z, SilenceJingle
;> return WriteSquare1Freq(Jingle1A_Sq1Freq, timer)
	ld hl, Jingle1A_Sq1Freq
	jp WriteSquare1Freq

;@ path: sound/sfx/square
;@ The data of square-channel effect $1A, read by Jingle1A_Start / Jingle1A_Update.
;@ Jingle1A_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle1A_Sq1Freq: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the frames until the next step.
Jingle1A_Data::
Jingle1A_Sq1:
	db $00, $80, $34, $90, $87, $01
Jingle1A_Sq1Freq:
	db $c8, $07, $04

;@ def Jingle1B_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1B, Shutters: shutter doors open. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; its steps run 3 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1B_Start::
;> wJingleRepeat = 3
	ld a, $03
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle1B_Sq1)
	ld hl, Jingle1B_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle1B_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle1B_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1B (Shutters) on: each time its timer runs out, the next step. The frequency
;@ slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1B_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 4
	ld a, $04
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 8:
	cp $08
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle1B_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 2:
	cp $02
	jr z, .case2
;>@t1         record = Jingle1B_Sq1_2
;>     else:
;>         record = Jingle1B_Sq1_3
.part2
	ld hl, Jingle1B_Sq1_3
;>     SaveSquare1Freq(record)
.part3
	call SaveSquare1Freq
;>     wJingleStep = 4
	ld a, $04
	ld [bc], a
;>     return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs
.case2
;=@t1
	ld hl, Jingle1B_Sq1_2
	jr .part3
;>@t2 return SlideSquare1(Jingle1B_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $1B (Shutters), read by Jingle1B_Start / Jingle1B_Update.
;@ Jingle1B_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle1B_Sq1, Jingle1B_Sq1_2, Jingle1B_Sq1_3: square 1 register records, 6 bytes each: NR10 sweep, NR11
;@ duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the
;@ frames until the next step.
Jingle1B_Data::
Jingle1B_Slide:
	db $00, $2a, $00, $2e, $00, $25, $00, $07, $00, $15, $00, $17, $00, $13
Jingle1B_Sq1:
	db $00, $00, $4c, $f7, $86, $04
Jingle1B_Sq1_2:
	db $00, $40, $40, $7b, $87, $04
Jingle1B_Sq1_3:
	db $00, $80, $10, $7b, $87, $04

;@ def Jingle1C_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1C, Warp: a warp hole takes Link. Its steps run 44 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1C_Start::
;> wJingleRepeat = 44
	ld a, $2c
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle1C_Sq1)
	ld hl, Jingle1C_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle1C_Sq1, timer)
	jp StartJingle

;@ def Jingle1C_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1C (Warp) on, one slide step per frame. Each round of steps counts
;@ wJingleRepeat down; at 24 the sound starts over from its second record, at 23 and after that each round
;@ ends in a second part, until the counter runs out.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1C_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .third
;=@t5
	cp $05
	jr z, .nextRound
.slide
;=@t6
	ld hl, Jingle1C_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.third
	call CountDownJingleRepeat
;>     if wJingleRepeat == 24:
	cp $18
	jr z, .restart
;=@t1
	cp $17
	jr z, .nextRound
;=@t2
	ld a, $01
	ld [bc], a
	jr .slide
;>         wJingleStep = 2
.restart
	ld a, $02
	ld [bc], a
;>         SaveSquare1Freq(Jingle1C_Sq1_2)
	ld hl, Jingle1C_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle1C_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     if wJingleRepeat != 23:
;>@t2         wJingleStep = 1
;>         return SlideSquare1(Jingle1C_Slide, step)
;>@t5 if wJingleStep in (3, 5):                 # step 3 gets here once the counter is at 23
;>     wJingleRepeat -= 1
.nextRound
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 3
	ld a, $03
	ld [bc], a
	jr .slide
;>@t6 return SlideSquare1(Jingle1C_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $1C (Warp), read by Jingle1C_Start / Jingle1C_Update.
;@ Jingle1C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle1C_Sq1, Jingle1C_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle1C_Data::
Jingle1C_Slide:
	db $00, $ae, $ff, $60, $00, $aa, $ff, $60
Jingle1C_Sq1:
	db $00, $40, $0c, $00, $85, $01
Jingle1C_Sq1_2:
	db $00, $40, $a4, $40, $86, $01

;@ def Jingle1D_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1D, Error: an item has no ammo left, a wrong signpost. Its steps run 8
;@ times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1D_Start::
;> wJingleRepeat = 8
	ld a, $08
	ld [wJingleRepeat], a
;> return StartJingle(Jingle1D_Sq1, timer)
	ld hl, Jingle1D_Sq1
	jp StartJingle

;@ def Jingle1D_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1D (Error) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1D_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> rNR11 = 0x79
	ld a, $79
	ldh [rNR11], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle1D_Sq1FreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteSquare1Freq
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 2
	ld a, $02
	ld [bc], a
	jr .part1
;>@t1 record = mem16[Jingle1D_Sq1FreqTable + 2 * (wJingleStep - 1)]
;>@t2 return WriteSquare1Freq(record, timer)

;@ path: sound/sfx/square
;@ The data of square-channel effect $1D (Error), read by Jingle1D_Start / Jingle1D_Update.
;@ Jingle1D_Sq1FreqTable: one pointer per step (the first for step 1) to its record (square 1 notes).
;@ Jingle1D_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle1D_Sq1Freq, Jingle1D_Sq1Freq_2: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the
;@ frames until the next step.
Jingle1D_Data::
Jingle1D_Sq1FreqTable:
	dw Jingle1D_Sq1Freq_2, Jingle1D_Sq1Freq
Jingle1D_Sq1:
	db $00, $79, $e0
Jingle1D_Sq1Freq:
	db $c0, $c4, $02
Jingle1D_Sq1Freq_2:
	db $c0, $c4, $0c

;@ def Jingle1E_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1E (not requested directly). It locks its channel, so that other effects of
;@ the channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1E_Start::
;> return StartLockedJingle(Jingle1E_Sq1, timer)
	ld hl, Jingle1E_Sq1
	jp StartLockedJingle

;@ def Jingle1E_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1E on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1E_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 5: return EndJingle()
	cp $05
	jp z, EndJingle
;> record = mem16[Jingle1E_Sq1FreqTable + 2 * (wJingleStep - 1)]
	ld hl, Jingle1E_Sq1FreqTable
	call GetSfxTableEntry
;> return WriteSquare1Freq(record, timer)
	jp WriteSquare1Freq

;@ path: sound/sfx/square
;@ The data of square-channel effect $1E, read by Jingle1E_Start / Jingle1E_Update.
;@ Jingle1E_Sq1FreqTable: one pointer per step (the first for step 1) to its record (square 1 notes).
;@ Jingle1E_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle1E_Sq1Freq, Jingle1E_Sq1Freq_2: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the
;@ frames until the next step.
Jingle1E_Data::
Jingle1E_Sq1FreqTable:
	dw Jingle1E_Sq1Freq, Jingle1E_Sq1Freq, Jingle1E_Sq1Freq_2, Jingle1E_Sq1Freq_2
Jingle1E_Sq1:
	db $1f, $a6, $e1, $00, $c7, $10
Jingle1E_Sq1Freq:
	db $a0, $c6, $09
Jingle1E_Sq1Freq_2:
	db $00, $c6, $18

;@ def Jingle1F_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $1F, Genie into the bottle: the genie goes back into its bottle. It locks
;@ its channel, so that other effects of the channel are ignored until it ends; its steps run 10 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1F_Start::
;> wJingleRepeat = 10
	ld a, $0a
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle1F_Sq1)
	ld hl, Jingle1F_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle1F_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle1F_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $1F (Genie into the bottle) on, a step every frame. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle1F_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle1F_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle1F_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $1F (Genie into the bottle), read by Jingle1F_Start / Jingle1F_Update.
;@ Jingle1F_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle1F_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle1F_Data::
Jingle1F_Slide:
	db $00, $30, $00, $60, $00, $60, $00, $30, $ff, $c0, $ff, $80, $ff, $80, $ff, $c0
Jingle1F_Sq1:
	db $00, $80, $0b, $20, $86, $01

;@ def Jingle20_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $20, Thud: a boulder bounces, a boss hops (Genie's bottle, Slime Eye, Hinox,
;@ Armos Knight, the final Nightmare). Its steps run 8 times; some running effects keep their channel (the
;@ request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle20_Start::
;> if wActiveJingle != 0x20:
	ld a, [wActiveJingle]
	cp $20
	jr z, .case1
;>     if wActiveJingle: return IgnoreJingle()
.part1
	and a
	jp nz, IgnoreJingle
;> wJingleRepeat = 8
.case1
	ld a, $08
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle20_Sq1)
	ld hl, Jingle20_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle20_Sq1, timer)
	jp StartJingle

;@ def Jingle20_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $20 (Thud) on, a step every frame. The frequency slides by a table of steps.
;@ At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle20_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle20_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle20_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $20 (Thud), read by Jingle20_Start / Jingle20_Update.
;@ Jingle20_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle20_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle20_Data::
Jingle20_Slide:
	db $00, $c0, $ff, $a0
Jingle20_Sq1:
	db $00, $80, $f1, $80, $83, $01

;@ def Jingle21_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $21, Seagull: a seagull cries in the ending. Its steps run 28 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle21_Start::
;> wJingleRepeat = 28
	ld a, $1c
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle21_Sq1)
	ld hl, Jingle21_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle21_Sq1, timer)
	jp StartJingle

;@ def Jingle21_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $21 (Seagull) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle21_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2:
	cp $02
	jr z, .case1
.part1
;=@t3
	ld hl, Jingle21_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 20:
	cp $14
	jr z, .case2
.part2
;=@t1
	cp $0a
	jr z, .case3
.part3
;=@t2
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle21_Sq1_2)
	ld hl, Jingle21_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle21_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     if wJingleRepeat == 10:
;>         wJingleStep = 0
.case3
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle21_Sq1_3)
	ld hl, Jingle21_Sq1_3
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle21_Sq1_3, timer)
	jp WriteSquare1Regs
;>@t2     wJingleStep = 1
;>@t3 return SlideSquare1(Jingle21_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $21 (Seagull), read by Jingle21_Start / Jingle21_Update.
;@ Jingle21_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle21_Sq1, Jingle21_Sq1_2, Jingle21_Sq1_3: square 1 register records, 6 bytes each: NR10 sweep, NR11
;@ duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the
;@ frames until the next step.
Jingle21_Data::
Jingle21_Slide:
	db $ff, $ff
Jingle21_Sq1:
	db $00, $00, $19, $b0, $87, $01
Jingle21_Sq1_2:
	db $00, $00, $62, $a7, $87, $01
Jingle21_Sq1_3:
	db $00, $00, $10, $a7, $87, $01

;@ def Jingle22_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $22, Bees: the bees chase Link (each start a step higher) (unless it plays
;@ already). Each start counts wJingle22Count up and picks the pitch from it: four records that go up and
;@ down again over twelve starts.
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle22_Start::
;> if wActiveJingle == 0x22: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $22
	jp z, IgnoreJingle
;> wJingle22Count += 1
	ld bc, wJingle22Count
	call NextSfxStep
;> if wJingle22Count < 4:
	cp $04
	jr nc, .not1
;>     return StartJingle(Jingle22_Sq1, timer)
.first
	ld hl, Jingle22_Sq1
	jp StartJingle
;> if wJingle22Count < 6:
.not1
	cp $06
	jr nc, .not2
;>     return StartJingle(Jingle22_Sq1_2, timer)
.second
	ld hl, Jingle22_Sq1_2
	jp StartJingle
;> if wJingle22Count < 8:
.not2
	cp $08
	jr nc, .not3
;>     return StartJingle(Jingle22_Sq1_3, timer)
.third
	ld hl, Jingle22_Sq1_3
	jp StartJingle
;> if wJingle22Count < 9:
.not3
	cp $09
	jr nc, .not4
;>     return StartJingle(Jingle22_Sq1_4, timer)
	ld hl, Jingle22_Sq1_4
	jp StartJingle
;> if wJingle22Count < 11:
.not4
	cp $0b
	jr nc, .not5
;>     return StartJingle(Jingle22_Sq1_3, timer)  # down again
	jr .third
;> if wJingle22Count != 13:
.not5
	cp $0d
	jr z, .again
;>     return StartJingle(Jingle22_Sq1_2, timer)
	jr .second
;> wJingle22Count = 1                          # over again from the bottom
.again
	ld a, $01
	ld [bc], a
;> return StartJingle(Jingle22_Sq1, timer)
	jr .first

;@ def Jingle22_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $22 (Bees) on, a step every frame. At the end the channel goes back to the
;@ music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle22_Update::
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $22 (Bees), read by Jingle22_Start / Jingle22_Update.
;@ Jingle22_Sq1, Jingle22_Sq1_2, Jingle22_Sq1_3, Jingle22_Sq1_4: square 1 register records, 6 bytes each:
;@ NR10 sweep, NR11 duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the
;@ sound), then the frames until the next step.
Jingle22_Data::
Jingle22_Sq1:
	db $15, $38, $30, $40, $c6, $02
Jingle22_Sq1_2:
	db $15, $38, $40, $3c, $c6, $02
Jingle22_Sq1_3:
	db $15, $38, $60, $38, $c6, $02
Jingle22_Sq1_4:
	db $15, $38, $90, $34, $c6, $02
	db $15, $38, $d0, $30, $c6, $02

;@ def Jingle23_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $23, Rumble: a gate opens, the weathervane slides, an instrument appears. It
;@ locks its channel, so that other effects of the channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle23_Start::
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> return StartLockedJingle(Jingle23_Sq1, timer)
	ld hl, Jingle23_Sq1
	jp StartLockedJingle

;@ def Jingle23_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $23 (Rumble) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle23_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 8:
	cp $08
	jr z, .case1
;>@t1     wMusicChannel2[0x0F] &= 0x7F
;>@t2     return SilenceJingle(timer)
;> record = mem16[Jingle23_Sq2Table + 2 * (wJingleStep - 1)]
.part1
	ld hl, Jingle23_Sq2Table
	call GetSfxTableEntry
;> if (wJingleStep & 0x01): return WriteSquare2Regs(record, timer)
	ld a, [wJingleStep]
	and $01
	jp nz, WriteSquare2Regs
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs
.case1
;=@t1
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;=@t2
	jp SilenceJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $23 (Rumble), read by Jingle23_Start / Jingle23_Update.
;@ Jingle23_Sq2Table: one pointer per step (the first for step 1) to its record (square 2 register records).
;@ Jingle23_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle23_Sq2, Jingle23_Sq2_2, Jingle23_Sq2_3, Jingle23_Sq2_4, Jingle23_Sq2_5, Jingle23_Sq2_6,
;@ Jingle23_Sq2_7: square 2 register records, 5 bytes each: NR21 duty and length, NR22 volume envelope, NR23
;@ / NR24 frequency (NR24 bit 7 restarts the sound), then the frames until the next step.
Jingle23_Data::
Jingle23_Sq2Table:
	dw Jingle23_Sq2, Jingle23_Sq2_2, Jingle23_Sq2_3, Jingle23_Sq2_4, Jingle23_Sq2_5, Jingle23_Sq2_6, Jingle23_Sq2_7
Jingle23_Sq1:
	db $00, $80, $e2, $a7, $87, $09
Jingle23_Sq2:
	db $80, $e2, $a2, $87, $08
Jingle23_Sq2_2:
	db $00, $80, $e2, $90, $87
	db $08
Jingle23_Sq2_3:
	db $80, $e2, $7b, $87, $08
Jingle23_Sq2_4:
	db $00, $80, $b2, $59, $87
	db $09
Jingle23_Sq2_5:
	db $80, $e2, $97, $87, $0a
Jingle23_Sq2_6:
	db $00, $80, $e2, $ac, $87
	db $0b
Jingle23_Sq2_7:
	db $80, $e2, $be, $87, $10

;@ def Jingle24_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $24, Hop: something hops or wakes (Slime Eye, Evil Eagle's gust, Armos
;@ Knight, Stalfos, the walrus).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle24_Start::
;> return StartJingle(Jingle24_Sq1, timer)
	ld hl, Jingle24_Sq1
	jp StartJingle

;@ def Jingle24_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $24 (Hop) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle24_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $24 (Hop), read by Jingle24_Start / Jingle24_Update.
;@ Jingle24_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle24_Sq1::
	db $27, $80, $83, $00, $86, $18

;@ def Jingle25_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $25 (not requested directly). It locks its channel, so that other effects of
;@ the channel are ignored until it ends; its steps run 7 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle25_Start::
;> wJingleRepeat = 7
	ld a, $07
	ld [wJingleRepeat], a
;> return StartLockedJingle(Jingle25_Sq1, timer)
	ld hl, Jingle25_Sq1
	jp StartLockedJingle

;@ def Jingle25_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $25 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle25_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 6:
	cp $06
	jr z, .case1
.part1
;=@t1
	cp $07
	jr z, .case2
.part2
;=@t2
	ld hl, Jingle25_Sq1FreqTable
	call GetSfxTableEntry
;=@t3
	jp WriteSquare1Freq
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 6
	ld a, $06
	ld [bc], a
	jr .part2
;> else:
;>@t1     if wJingleStep == 7:
;>         wJingleStep = 3
.case2
	ld a, $03
	ld [bc], a
	jr .part2
;>@t2 record = mem16[Jingle25_Sq1FreqTable + 2 * (wJingleStep - 1)]
;>@t3 return WriteSquare1Freq(record, timer)

;@ path: sound/sfx/square
;@ The data of square-channel effect $25, read by Jingle25_Start / Jingle25_Update.
;@ Jingle25_Sq1FreqTable: one pointer per step (the first for step 1) to its record (square 1 notes).
;@ Jingle25_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle25_Sq1Freq, Jingle25_Sq1Freq_2, Jingle25_Sq1Freq_3, Jingle25_Sq1Freq_4, Jingle25_Sq1Freq_5,
;@ Jingle25_Sq1Freq_6: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the frames until the next
;@ step.
Jingle25_Data::
Jingle25_Sq1FreqTable:
	dw Jingle25_Sq1Freq, Jingle25_Sq1Freq_2, Jingle25_Sq1Freq_3, Jingle25_Sq1Freq_4, Jingle25_Sq1Freq_5, Jingle25_Sq1Freq_6
Jingle25_Sq1:
	db $00, $80, $a5, $06, $87, $02
Jingle25_Sq1Freq:
	db $21, $07, $02
Jingle25_Sq1Freq_2:
	db $39, $07, $02
Jingle25_Sq1Freq_3:
	db $4f, $07, $02
Jingle25_Sq1Freq_4:
	db $62, $07, $02
Jingle25_Sq1Freq_5:
	db $74, $07, $02
Jingle25_Sq1Freq_6:
	db $06, $07, $02

;@ def Jingle26_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $26, Owl flies off: the owl flies away. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; its steps run 14 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle26_Start::
;> wJingleRepeat = 14
	ld a, $0e
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle26_Sq1)
	ld hl, Jingle26_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle26_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle26_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $26 (Owl flies off) on: each time its timer runs out, the next step. The
;@ frequency slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle26_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 3
	ld a, $03
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 4:
	cp $04
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle26_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 9:
	cp $09
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle26_Sq1_2)
	ld hl, Jingle26_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle26_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle26_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $26 (Owl flies off), read by Jingle26_Start / Jingle26_Update.
;@ Jingle26_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle26_Sq1, Jingle26_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle26_Data::
Jingle26_Slide:
	db $ff, $e0, $00, $20, $ff, $fc
Jingle26_Sq1:
	db $00, $00, $0c, $f0, $87, $03
Jingle26_Sq1_2:
	db $00, $00, $a7, $dc, $87, $03

;@ def Jingle27_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $27 (not requested directly).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle27_Start::
;> return StartJingle(Jingle27_Sq1, timer)
	ld hl, Jingle27_Sq1
	jp StartJingle

;@ def Jingle27_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $27 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle27_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return SilenceJingle(timer)
	cp $02
	jp z, SilenceJingle
;> rNR10 = 0x1E
	ld a, $1e
	ldh [rNR10], a
;> wJingleTimer = 24
	ld a, $18
	ld [de], a
;> return
	ret

;@ path: sound/sfx/square
;@ The data of square-channel effect $27, read by Jingle27_Start / Jingle27_Update.
;@ Jingle27_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle27_Sq1::
	db $14, $40, $c0, $00, $81, $0c

;@ def Jingle28_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $28 (bank $07).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle28_Start::
;> return StartJingle(Jingle28_Sq1, timer)
	ld hl, Jingle28_Sq1
	jp StartJingle

;@ def Jingle28_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $28 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle28_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 8: return EndJingle()
	cp $08
	jp z, EndJingle
;> record = mem16[Jingle28_Sq1FreqTable + 2 * (wJingleStep - 1)]
	ld hl, Jingle28_Sq1FreqTable
	call GetSfxTableEntry
;> rNR11 = 0xBD
	ld a, $bd
	ldh [rNR11], a
;> return WriteSquare1Freq(record, timer)
	jp WriteSquare1Freq

;@ path: sound/sfx/square
;@ The data of square-channel effect $28, read by Jingle28_Start / Jingle28_Update.
;@ Jingle28_Sq1FreqTable: one pointer per step (the first for step 1) to its record (square 1 notes).
;@ Jingle28_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
;@ Jingle28_Sq1Freq, Jingle28_Sq1Freq_2, Jingle28_Sq1Freq_3, Jingle28_Sq1Freq_4, Jingle28_Sq1Freq_5,
;@ Jingle28_Sq1Freq_6, Jingle28_Sq1Freq_7: square 1 notes, 3 bytes each: NR13 / NR14 frequency, then the
;@ frames until the next step.
Jingle28_Data::
Jingle28_Sq1FreqTable:
	dw Jingle28_Sq1Freq, Jingle28_Sq1Freq_2, Jingle28_Sq1Freq_3, Jingle28_Sq1Freq_4, Jingle28_Sq1Freq_5, Jingle28_Sq1Freq_6, Jingle28_Sq1Freq_7
Jingle28_Sq1:
	db $00, $bd, $f0, $e0, $c7, $0c
Jingle28_Sq1Freq:
	db $e0, $c7, $03
Jingle28_Sq1Freq_2:
	db $c0, $c7, $03
Jingle28_Sq1Freq_3:
	db $a0, $c7, $04
Jingle28_Sq1Freq_4:
	db $80, $c7, $04
Jingle28_Sq1Freq_5:
	db $60, $c7, $05
Jingle28_Sq1Freq_6:
	db $40, $c7, $06
Jingle28_Sq1Freq_7:
	db $20, $c7, $03

;@ def Jingle29_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $29 (bank $05).
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle29_Start::
;> return StartJingle(Jingle29_Sq1, timer)
	ld hl, Jingle29_Sq1
	jp StartJingle

;@ def Jingle29_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $29 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle29_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 2: return EndJingle()
	cp $02
	jp z, EndJingle
;> rNR10 = 0x1E
	ld a, $1e
	ldh [rNR10], a
;> wJingleTimer = 6
	ld a, $06
	ld [de], a
;> return
	ret

;@ path: sound/sfx/square
;@ The data of square-channel effect $29, read by Jingle29_Start / Jingle29_Update.
;@ Jingle29_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle29_Sq1::
	db $17, $96, $49, $60, $c6, $04

;@ def Jingle2A_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2A, Dodongo crawl: a Dodongo snake crawls.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2A_Start::
;> return StartJingle(Jingle2A_Sq1, timer)
	ld hl, Jingle2A_Sq1
	jp StartJingle

;@ def Jingle2A_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2A (Dodongo crawl) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2A_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return SilenceJingle(timer)
	jp SilenceJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $2A (Dodongo crawl), read by Jingle2A_Start / Jingle2A_Update.
;@ Jingle2A_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle2A_Sq1::
	db $16, $00, $f0, $00, $c2, $10

;@ def Jingle2B_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2B, Instrument notes: an instrument plays its notes. Its steps run 44
;@ times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2B_Start::
;> wJingleRepeat = 44
	ld a, $2c
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle2B_Sq1)
	ld hl, Jingle2B_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle2B_Sq1, timer)
	jp StartJingle

;@ def Jingle2B_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2B (Instrument notes) on, a step every frame. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2B_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 11:
	cp $0b
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle2B_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 12:
	cp $0c
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle2B_Sq1_2)
	ld hl, Jingle2B_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle2B_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle2B_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $2B (Instrument notes), read by Jingle2B_Start / Jingle2B_Update.
;@ Jingle2B_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle2B_Sq1, Jingle2B_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle2B_Data::
Jingle2B_Slide:
	db $00, $08, $ff, $f0, $00, $08, $ff, $fc, $00, $06, $ff, $f8, $00, $06, $ff, $fa
	db $00, $08, $ff, $ff
Jingle2B_Sq1:
	db $00, $00, $0f, $d0, $87, $02
Jingle2B_Sq1_2:
	db $00, $00, $f7, $f0, $87, $04

;@ def Jingle2C_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2C, Ocarina: Link plays the ocarina. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; its steps run 34 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2C_Start::
;> wJingleRepeat = 34
	ld a, $22
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle2C_Sq1)
	ld hl, Jingle2C_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle2C_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle2C_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2C (Ocarina) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2C_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 7:
	cp $07
	jr z, .case1
.part1
;=@t3
	ld hl, Jingle2C_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 30:
	cp $1e
	jr z, .case2
.part2
;=@t1
	cp $06
	jr z, .case3
.part3
;=@t2
	ld a, $01
	ld bc, wJingleStep
	ld [bc], a
	jr .part1
;>         wJingleStep = 1
.case2
	ld hl, Jingle2C_Sq1_2
.part4
	ld a, $01
	ld [bc], a
;>         SaveSquare1Freq(Jingle2C_Sq1_2)
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle2C_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     if wJingleRepeat == 6:
;>         wJingleStep = 1
.case3
	ld hl, Jingle2C_Sq1_3
	jr .part4
;>         SaveSquare1Freq(Jingle2C_Sq1_3)
;>         return WriteSquare1Regs(Jingle2C_Sq1_3, timer)
;>@t2     wJingleStep = 1
;>@t3 return SlideSquare1(Jingle2C_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $2C (Ocarina), read by Jingle2C_Start / Jingle2C_Update.
;@ Jingle2C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle2C_Sq1, Jingle2C_Sq1_2, Jingle2C_Sq1_3: square 1 register records, 6 bytes each: NR10 sweep, NR11
;@ duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the
;@ frames until the next step.
Jingle2C_Data::
Jingle2C_Slide:
	db $00, $02, $00, $01, $ff, $f0, $ff, $e0, $ff, $c0, $00, $71
Jingle2C_Sq1:
	db $00, $00, $0f, $00, $87, $01
Jingle2C_Sq1_2:
	db $00, $00, $40, $10, $87, $01
Jingle2C_Sq1_3:
	db $00, $00, $47, $70, $87, $01

;@ def Jingle2D_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2D (the followers, bank $19). It locks its channel, so that other effects
;@ of the channel are ignored until it ends; its steps run 3 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2D_Start::
;> wJingleRepeat = 3
	ld a, $03
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle2D_Sq1)
	ld hl, Jingle2D_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle2D_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle2D_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2D on: every 8 frames a slide step, rounds of 4 steps until wJingleRepeat
;@ runs out; the last round plays with a fading envelope.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2D_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 8
	ld a, $08
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 5:
	cp $05
	jr z, .round
.slide
;=@t3
	ld hl, Jingle2D_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.round
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 1:
	cp $01
	jr z, .last
.again
;=@t2
	ld a, $01
	ld [bc], a
	jr .slide
;>         rNR12 = 0x65                          # the last round fades out
.last
	ld a, $65
	ldh [rNR12], a
	jr .again
;>@t2     wJingleStep = 1
;>@t3 return SlideSquare1(Jingle2D_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $2D, read by Jingle2D_Start / Jingle2D_Update.
;@ Jingle2D_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle2D_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle2D_Data::
Jingle2D_Slide:
	db $00, $04, $ff, $dd, $00, $06, $00, $19
Jingle2D_Sq1:
	db $00, $80, $1f, $b6, $87, $08

;@ def Jingle2E_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2E (bank $19). Its steps run 9 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2E_Start::
;> wJingleRepeat = 9
	ld a, $09
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle2E_Sq1)
	ld hl, Jingle2E_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle2E_Sq1, timer)
	jp StartJingle

;@ def Jingle2E_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2E on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2E_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 41:
	cp $29
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle2E_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 3:
	cp $03
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle2E_Sq1_2)
	ld hl, Jingle2E_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle2E_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle2E_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $2E, read by Jingle2E_Start / Jingle2E_Update.
;@ Jingle2E_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle2E_Sq1, Jingle2E_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle2E_Data::
Jingle2E_Slide:
	db $00, $30, $00, $30, $00, $30, $00, $30, $00, $28, $00, $28, $00, $28, $00, $28
	db $00, $20, $00, $20, $00, $20, $00, $20, $00, $18, $00, $18, $00, $18, $00, $18
	db $00, $10, $00, $10, $00, $10, $00, $10, $ff, $f0, $ff, $f0, $ff, $f0, $ff, $f0
	db $ff, $e8, $ff, $e8, $ff, $e8, $ff, $e8, $ff, $e0, $ff, $e0, $ff, $e0, $ff, $e0
	db $ff, $d8, $ff, $d8, $ff, $d8, $ff, $d8, $ff, $d0, $ff, $d0, $ff, $d0, $ff, $d0
Jingle2E_Sq1:
	db $00, $80, $1d, $00, $81, $10
Jingle2E_Sq1_2:
	db $00, $80, $f7, $00, $81, $10

;@ def Jingle2F_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $2F, Roll: the hole filler rolls, a Pokey segment bounces, the final
;@ Nightmare leaves. Its steps run 7 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2F_Start::
;> wJingleRepeat = 7
	ld a, $07
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle2F_Sq1)
	ld hl, Jingle2F_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle2F_Sq1, timer)
	jp StartJingle

;@ def Jingle2F_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $2F (Roll) on, a step every frame. The frequency slides by a table of steps.
;@ At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle2F_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 7:
	cp $07
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle2F_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideSquare1(Jingle2F_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $2F (Roll), read by Jingle2F_Start / Jingle2F_Update.
;@ Jingle2F_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle2F_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle2F_Data::
Jingle2F_Slide:
	db $00, $80, $00, $60, $00, $40, $ff, $c0, $ff, $a0, $ff, $88
Jingle2F_Sq1:
	db $00, $80, $f2, $00, $85, $01

;@ def Jingle30_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $30 (not requested directly). Its steps run 10 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle30_Start::
;> wJingleRepeat = 10
	ld a, $0a
	ld [wJingleRepeat], a
;> return StartJingle(Jingle30_Sq1, timer)
	ld hl, Jingle30_Sq1
	jp StartJingle

;@ def Jingle30_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $30 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle30_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleRepeat -= 1
	call CountDownJingleRepeat
;> if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;> return WriteSquare1Regs(Jingle30_Sq1, timer)
	ld hl, Jingle30_Sq1
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $30, read by Jingle30_Start / Jingle30_Update.
;@ Jingle30_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle30_Sq1::
	db $17, $bc, $64, $44, $c7, $02

;@ def Jingle31_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $31, Grim Creeper: the Grim Creeper calls its bats. Its steps run 20 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle31_Start::
;> wJingleRepeat = 20
	ld a, $14
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle31_Sq1)
	ld hl, Jingle31_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle31_Sq1, timer)
	jp StartJingle

;@ def Jingle31_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $31 (Grim Creeper) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle31_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, Jingle31_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     if wJingleRepeat == 16:
	cp $10
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wJingleStep = 1
.case2
	ld hl, Jingle31_Sq1_2
	ld a, $01
	ld [bc], a
;>         SaveSquare1Freq(Jingle31_Sq1_2)
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle31_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 1
;>@t2 return SlideSquare1(Jingle31_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $31 (Grim Creeper), read by Jingle31_Start / Jingle31_Update.
;@ Jingle31_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle31_Sq1, Jingle31_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle31_Data::
Jingle31_Slide:
	db $ff, $fc, $00, $02
Jingle31_Sq1:
	db $00, $00, $19, $ea, $87, $01
Jingle31_Sq1_2:
	db $00, $00, $47, $e0, $87, $01

;@ def Jingle32_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $32, Hot Head jump: Hot Head jumps. It locks its channel, so that other
;@ effects of the channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle32_Start::
;> return StartLockedJingle(Jingle32_Sq1, timer)
	ld hl, Jingle32_Sq1
	jp StartLockedJingle

;@ def Jingle32_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $32 (Hot Head jump) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle32_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3: return SilenceJingle(timer)
	cp $03
	jp z, SilenceJingle
;> record = mem16[Jingle32_Sq1Table + 2 * (wJingleStep - 1)]
	ld hl, Jingle32_Sq1Table
	call GetSfxTableEntry
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $32 (Hot Head jump), read by Jingle32_Start / Jingle32_Update.
;@ Jingle32_Sq1Table: one pointer per step (the first for step 1) to its record (square 1 register records).
;@ Jingle32_Sq1, Jingle32_Sq1_2, Jingle32_Sq1_3: square 1 register records, 6 bytes each: NR10 sweep, NR11
;@ duty and length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the
;@ frames until the next step.
Jingle32_Data::
Jingle32_Sq1Table:
	dw Jingle32_Sq1_2, Jingle32_Sq1_3
Jingle32_Sq1:
	db $1f, $80, $85, $a0, $87, $0c
Jingle32_Sq1_2:
	db $1f, $80, $47, $a0, $87, $0c
Jingle32_Sq1_3:
	db $1f, $8d, $20, $a0, $c7, $0c

;@ def Jingle33_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $33 (not requested directly). Its steps run 2 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle33_Start::
;> wJingleRepeat = 2
	ld a, $02
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle33_Sq1)
	ld hl, Jingle33_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle33_Sq1, timer)
	jp StartJingle

;@ def Jingle33_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $33 on: each time its timer runs out, the next step. The frequency slides by
;@ a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle33_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 8
	ld a, $08
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 4:
	cp $04
	jr z, .case1
.part1
;=@t1
	cp $05
	jr z, .case2
.part2
;=@t2
	ld hl, Jingle33_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 4
	ld a, $04
.part3
	ld [bc], a
	jr .part2
;> else:
;>@t1     if wJingleStep == 5:
;>         wJingleStep = 1
.case2
	ld a, $01
	jr .part3
;>@t2 return SlideSquare1(Jingle33_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $33, read by Jingle33_Start / Jingle33_Update.
;@ Jingle33_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle33_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle33_Data::
Jingle33_Slide:
	db $00, $08, $ff, $fd, $00, $03, $ff, $f8
Jingle33_Sq1:
	db $00, $00, $60, $d1, $87, $08

;@ def Jingle34_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $34 (not requested directly). Its steps run 12 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle34_Start::
;> wJingleRepeat = 12
	ld a, $0c
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle34_Sq1)
	ld hl, Jingle34_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle34_Sq1, timer)
	jp StartJingle

;@ def Jingle34_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $34 on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle34_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t2
	cp $0a
	jr z, .case3
.part2
;=@t1
	ld hl, Jingle34_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 9:
	cp $09
	jr z, .case2
.part3
;=@t1
	jr .part2
;>         wJingleStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle34_Sq1_2)
	ld hl, Jingle34_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle34_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     return SlideSquare1(Jingle34_Slide, step)
;>@t2 if wJingleStep == 10:
;>     wJingleStep = 1
.case3
	ld a, $01
	ld [bc], a
	jr .part2
;> return SlideSquare1(Jingle34_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $34, read by Jingle34_Start / Jingle34_Update.
;@ Jingle34_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle34_Sq1, Jingle34_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle34_Data::
Jingle34_Slide:
	db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01
	db $ff, $fa
Jingle34_Sq1:
	db $00, $00, $1f, $d0, $87, $01
Jingle34_Sq1_2:
	db $00, $00, $a7, $d8, $87, $01

;@ def Jingle35_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $35, Nightmare jingle: the final Nightmare. Its steps run 5 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle35_Start::
;> wJingleRepeat = 5
	ld a, $05
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle35_Sq1)
	ld hl, Jingle35_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle35_Sq1, timer)
	jp StartJingle

;@ def Jingle35_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $35 (Nightmare jingle) on: each time its timer runs out, the next step. The
;@ frequency slides by a table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle35_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleTimer = 2
	ld a, $02
	ld [de], a
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t2
	cp $0a
	jr z, .case2
.part2
;=@t1
	ld hl, Jingle35_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 3:
	cp $03
	jr z, .case3
.part3
;=@t1
	ld a, [bc]
	jr .part2
.case2
;=@t3
	ld a, $01
	ld [bc], a
	jr .part2
;>         wJingleStep = 0
.case3
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle35_Sq1_2)
	ld hl, Jingle35_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle35_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     return SlideSquare1(Jingle35_Slide, step)
;>@t2 if wJingleStep == 10:
;>@t3     wJingleStep = 1
;> return SlideSquare1(Jingle35_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $35 (Nightmare jingle), read by Jingle35_Start / Jingle35_Update.
;@ Jingle35_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle35_Sq1, Jingle35_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle35_Data::
Jingle35_Slide:
	db $00, $10, $00, $10, $00, $10, $00, $10, $00, $0c, $00, $08, $00, $04, $00, $02
	db $ff, $a2
Jingle35_Sq1:
	db $00, $80, $1f, $a0, $86, $02
Jingle35_Sq1_2:
	db $00, $80, $87, $a0, $86, $02

;@ def Jingle36_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $36 (bank $15). Its steps run 11 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle36_Start::
;> wJingleRepeat = 11
	ld a, $0b
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle36_Sq1)
	ld hl, Jingle36_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle36_Sq1, timer)
	jp StartJingle

;@ def Jingle36_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $36 on, a slide step every frame. Each round (wJingleRepeat frames) counts
;@ wJingleSubStep up; the rounds get shorter, step 5 sets a new envelope, and from sub-step 13 on the slide
;@ uses other steps. After sub-step $22 the effect ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle36_Update::
;> wJingleRepeat -= 1
	call CountDownJingleRepeat
;> if wJingleRepeat == 0:                     # a round is over
	jr z, .nextRound
;>@t2     wJingleSubStep += 1
;>@t3     if wJingleSubStep == 5:
;>@t4         rNR12 = 0xA0
;>@t5         n = 5
;>@t6     elif wJingleSubStep == 0x22: return SilenceJingle(timer)
;>@t7     elif wJingleSubStep >= 0x11:
;>@t8         n = 0x11
;>     else:
;>         n = wJingleSubStep
;>@t9     wJingleRepeat = u8(11 - (n >> 1))     # the rounds get shorter
;> if wJingleSubStep < 13:
.pick
	ld a, [wJingleSubStep]
	cp $0d
	jr nc, .late
;>@t10     value = 1 if (wJingleSubStep & 1) == 0 else 2
	and $01
	jr nz, .odd
	ld a, $01
;> else:
;>@t11     value = 3 if (wJingleSubStep & 1) == 0 else 4
;> wJingleStep = value
.setStep
	ld [bc], a
;> return SlideSquare1(Jingle36_Slide, step)
	ld hl, Jingle36_Slide
	jp SlideSquare1
.odd
;=@t10
	ld a, $02
	jr .setStep
.late
;=@t11
	and $01
	jr nz, .late4
	ld a, $03
	jr .setStep
.late4
;=@t11
	ld a, $04
	jr .setStep
.nextRound
;=@t2
	push bc
	ld bc, wJingleSubStep
	call NextSfxStep
	pop bc
;=@t3
	cp $05
	jr z, .five
;=@t6
	cp $22
	jp z, SilenceJingle
;=@t7
	cp $11
	jr nc, .cap
.repeat
;=@t9
	sra a
	ld e, a
	ld a, $0b
	sub e
	ld [wJingleRepeat], a
	jr .pick
.five
;=@t4
	ld a, $a0
	ldh [rNR12], a
;=@t5
	ld a, $05
	jr .repeat
.cap
;=@t8
	ld a, $11
	jr .repeat

;@ path: sound/sfx/square
;@ The data of square-channel effect $36, read by Jingle36_Start / Jingle36_Update.
;@ Jingle36_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle36_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle36_Data::
Jingle36_Slide:
	db $00, $20, $ff, $e8, $00, $1c, $ff, $f0
Jingle36_Sq1:
	db $00, $40, $1f, $80, $83, $01

;@ def Jingle37_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $37, Nightmare powdered: magic powder hits the final Nightmare's gel form.
;@ It locks its channel, so that other effects of the channel are ignored until it ends; its steps run 16
;@ times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle37_Start::
;> wJingleRepeat = 16
	ld a, $10
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle37_Sq1)
	ld hl, Jingle37_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle37_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle37_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $37 (Nightmare powdered) on, a step every frame. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle37_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	cp $0a
	jr z, .case2
.part2
;=@t2
	ld hl, Jingle37_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 9
	ld a, $09
	ld [bc], a
	jr .part2
;> else:
;>@t1     if wJingleStep == 10:
;>         wJingleStep = 1
.case2
	ld a, $01
	ld [bc], a
	jr .part2
;>@t2 return SlideSquare1(Jingle37_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $37 (Nightmare powdered), read by Jingle37_Start / Jingle37_Update.
;@ Jingle37_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle37_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle37_Data::
Jingle37_Slide:
	db $00, $40, $00, $30, $00, $20, $ff, $e0, $ff, $d0, $ff, $c0, $ff, $a0, $ff, $80
	db $00, $d0
Jingle37_Sq1:
	db $00, $80, $80, $00, $86, $01

;@ def Jingle38_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $38 (bank $15 (with a fast variant, wSfxFastVariant)). Some running effects
;@ keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle38_Start::
;> if wActiveJingle: return IgnoreJingle()
	ld a, [wActiveJingle]
	and a
	jp nz, IgnoreJingle
;> if wSfxFastVariant:
	ld a, [wSfxFastVariant]
	and a
	jr nz, .case1
;>@t1     record = Jingle38_Sq1_2
;> else:
;>     record = Jingle38_Sq1
.part1
	ld hl, Jingle38_Sq1
;> SaveSquare1Freq(record)
.part2
	call SaveSquare1Freq
;> return StartJingle(record, timer)
	jp StartJingle
.case1
;=@t1
	ld hl, Jingle38_Sq1_2
	jr .part2

;@ def Jingle38_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $38 on, a step every frame. The frequency slides by a table of steps.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle38_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 11:
	cp $0b
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle38_Slide
	jp SlideSquare1
;>     wJingleToPlay = 0x38
.case1
	ld hl, wJingleToPlay
	ld a, $38
	ld [hli], a
;>     wActiveJingle = 0
	xor a
	ld [hl], a
;>     return Jingle38_Start(timer, step)
	jr Jingle38_Start
;>@t1 return SlideSquare1(Jingle38_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $38, read by Jingle38_Start / Jingle38_Update.
;@ Jingle38_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle38_Sq1, Jingle38_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle38_Data::
Jingle38_Slide:
	db $00, $c0, $00, $90, $00, $60, $00, $30, $00, $18, $ff, $e8, $ff, $d0, $ff, $a0
	db $ff, $70, $ff, $40
Jingle38_Sq1:
	db $00, $80, $a0, $00, $82, $01
Jingle38_Sq1_2:
	db $00, $80, $c0, $00, $83, $01

;@ def Jingle39_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $39 (not requested directly). It locks its channel, so that other effects of
;@ the channel are ignored until it ends; its steps run 4 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle39_Start::
;> wJingleRepeat = 4
	ld a, $04
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle39_Sq1)
	ld hl, Jingle39_Sq1
	call SaveSquare1Freq
;> return StartLockedJingle(Jingle39_Sq1, timer)
	jp StartLockedJingle

;@ def Jingle39_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $39 on, a slide step every frame: rounds of 13 steps, the last ones with a
;@ second slide; at the round where wJingleRepeat is 1 the sound starts over from its second record.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle39_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 14:
	cp $0e
	jr z, .round
;>@t1     wJingleRepeat -= 1
;>@t2     if wJingleRepeat == 0: return SilenceJingle(timer)
;>@t3     wJingleStep = 14
;> elif wJingleStep == 15:
	cp $0f
	jr z, .s15
;>@t4     if wJingleRepeat == 1:
;>@t5         wJingleStep = 0
;>@t6         SaveSquare1Freq(Jingle39_Sq1_2)
;>@t7         return WriteSquare1Regs(Jingle39_Sq1_2, timer)
;>@t8     wJingleStep = 1
;> if wJingleRepeat < 3:
.slide
	ld a, [wJingleRepeat]
	cp $03
	jr c, .slow
;>@t9     return SlideSquare1(Jingle39_Slide_2, step)
;> return SlideSquare1(Jingle39_Slide, step)
	ld hl, Jingle39_Slide
	jp SlideSquare1
.slow
;=@t9
	ld hl, Jingle39_Slide_2
	jp SlideSquare1
.round
;=@t1
	call CountDownJingleRepeat
;=@t2
	jp z, SilenceJingle
;=@t3
	ld a, $0e
	ld [bc], a
	jr .slide
.s15
;=@t4
	ld a, [wJingleRepeat]
	cp $01
	jr z, .restart
;=@t8
	ld a, $01
	ld [bc], a
	jr .slide
.restart
;=@t5
	xor a
	ld [bc], a
;=@t6
	ld hl, Jingle39_Sq1_2
	call SaveSquare1Freq
;=@t7
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $39, read by Jingle39_Start / Jingle39_Update.
;@ Jingle39_Slide, Jingle39_Slide_2: frequency slide steps: big-endian 16-bit values, entry n is added to
;@ the effect's frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle39_Sq1, Jingle39_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle39_Data::
Jingle39_Slide:
	db $00, $c0, $00, $a0, $00, $80, $00, $60, $00, $40, $00, $20, $ff, $e0, $ff, $e0
	db $ff, $d0, $ff, $d0, $ff, $c0, $ff, $c0, $ff, $b0, $ff, $b0
Jingle39_Slide_2:
	db $00, $60, $00, $50, $00, $40, $00, $30, $00, $20, $00, $10, $ff, $f0, $ff, $f0
	db $ff, $f0, $ff, $f0, $ff, $e0, $ff, $e0, $ff, $d0, $ff, $d0
Jingle39_Sq1:
	db $00, $40, $4d, $80, $83, $01
Jingle39_Sq1_2:
	db $00, $80, $20, $c0, $84, $01

;@ def Jingle3A_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3A (not requested directly). Its steps run 4 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3A_Start::
;> wJingleRepeat = 4
	ld a, $04
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle3A_Sq1)
	ld hl, Jingle3A_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle3A_Sq1, timer)
	jp StartJingle

;@ def Jingle3A_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3A on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3A_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	cp $0a
	jr z, .case2
.part2
;=@t2
	ld hl, Jingle3A_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return EndJingle()
	jp z, EndJingle
;>     wJingleStep = 9
	ld a, $09
	ld [bc], a
	jr .part2
;> else:
;>@t1     if wJingleStep == 10:
;>         wJingleStep = 1
.case2
	ld a, $01
	ld [bc], a
	jr .part2
;>@t2 return SlideSquare1(Jingle3A_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $3A, read by Jingle3A_Start / Jingle3A_Update.
;@ Jingle3A_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle3A_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle3A_Data::
Jingle3A_Slide:
	db $00, $12, $00, $0e, $00, $0a, $00, $08, $00, $06, $00, $04, $00, $02, $00, $01
	db $ff, $c1
Jingle3A_Sq1:
	db $00, $00, $a4, $00, $87, $01

;@ def Jingle3B_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3B, Sword beam: the sword shoots a beam, the Mad Batter leaves. Its steps
;@ run 5 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3B_Start::
;> wJingleRepeat = 5
	ld a, $05
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle3B_Sq1)
	ld hl, Jingle3B_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle3B_Sq1, timer)
	jp StartJingle

;@ def Jingle3B_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3B (Sword beam) on, a slide step every frame: steps 1-11 once, then step 12
;@ again and again until wJingleRepeat runs out.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3B_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 12:
	cp $0c
	jr z, .round
;>@t1     wJingleRepeat -= 1
;>@t2     if wJingleRepeat == 0: return SilenceJingle(timer)
;>@t3     wJingleStep = 12
;> elif wJingleStep == 13:
	cp $0d
	jr z, .wrap
;>@t4     wJingleStep = 1
;> return SlideSquare1(Jingle3B_Slide, step)
.slide
	ld hl, Jingle3B_Slide
	jp SlideSquare1
.wrap
;=@t4
	ld a, $01
	ld [bc], a
	jr .slide
.round
;=@t1
	call CountDownJingleRepeat
;=@t2
	jp z, SilenceJingle
;=@t3
	ld a, $0c
	ld [bc], a
	jr .slide

;@ path: sound/sfx/square
;@ The data of square-channel effect $3B (Sword beam), read by Jingle3B_Start / Jingle3B_Update.
;@ Jingle3B_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle3B_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle3B_Data::
Jingle3B_Slide:
	db $ff, $c0, $ff, $a0, $00, $80, $ff, $c0, $ff, $a0, $00, $80, $ff, $c0, $ff, $a0
	db $00, $80, $ff, $c0, $ff, $a0, $01, $00
Jingle3B_Sq1:
	db $00, $00, $87, $80, $87, $01

;@ def Jingle3C_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3C, Pairodd: a Pairodd vanishes. Its steps run 2 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3C_Start::
;> wJingleRepeat = 2
	ld a, $02
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle3C_Sq1)
	ld hl, Jingle3C_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle3C_Sq1, timer)
	jp StartJingle

;@ def Jingle3C_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3C (Pairodd) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3C_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	ld hl, Jingle3C_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     wJingleStep = 0
	xor a
	ld [bc], a
;>     SaveSquare1Freq(Jingle3C_Sq1_2)
	ld hl, Jingle3C_Sq1_2
	call SaveSquare1Freq
;>     return WriteSquare1Regs(Jingle3C_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1 return SlideSquare1(Jingle3C_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $3C (Pairodd), read by Jingle3C_Start / Jingle3C_Update.
;@ Jingle3C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle3C_Sq1, Jingle3C_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle3C_Data::
Jingle3C_Slide:
	db $00, $02, $00, $02, $00, $02, $00, $02, $00, $01, $00, $01, $00, $01, $00, $01
Jingle3C_Sq1:
	db $00, $00, $60, $d0, $87, $02
Jingle3C_Sq1_2:
	db $00, $40, $10, $d0, $87, $01

;@ def Jingle3D_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3D (bank $15 (it requests itself again)). Its steps run 10 times; some
;@ running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle3D_Start::
;> if wActiveJingle == 0x04: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $04
	jp z, IgnoreJingle
;> if wActiveJingle == 0x05: return IgnoreJingle()
	cp $05
	jp z, IgnoreJingle
;> if wActiveJingle == 0x07: return IgnoreJingle()
	cp $07
	jp z, IgnoreJingle
;> if wActiveJingle == 0x03: return IgnoreJingle()
	cp $03
	jp z, IgnoreJingle
;> if wActiveJingle == 0x0D: return IgnoreJingle()
	cp $0d
	jp z, IgnoreJingle
;> wJingleRepeat = 10
	ld a, $0a
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle3D_Sq1)
	ld hl, Jingle3D_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle3D_Sq1, timer)
	jp StartJingle

;@ def Jingle3D_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3D on, a step every frame. The frequency slides by a table of steps.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3D_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 4:
	cp $04
	jr z, .case2
.part1
;=@t4
	cp $05
	jr z, .case1
.part2
;=@t3
	ld hl, Jingle3D_Slide
	jp SlideSquare1
.case1
;=@t5
	ld a, $01
	ld [bc], a
	jr .part2
;>     wJingleRepeat -= 1
.case2
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0:
	jp z, .case4
;>@t1         wJingleToPlay = 0x3D
;>@t2         return Jingle3D_Start(timer, step)
;>     if wJingleRepeat == 7:
.part3
	cp $07
	jr z, .case3
.part4
;=@t3
	jr .part2
;>         wJingleStep = 0
.case3
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle3D_Sq1_2)
	ld hl, Jingle3D_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle3D_Sq1_2, timer)
	jp WriteSquare1Regs
.case4
;=@t1
	ld a, $3d
	ld [wJingleToPlay], a
;=@t2
	jr Jingle3D_Start
;>@t3     return SlideSquare1(Jingle3D_Slide, step)
;>@t4 if wJingleStep == 5:
;>@t5     wJingleStep = 1
;> return SlideSquare1(Jingle3D_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $3D, read by Jingle3D_Start / Jingle3D_Update.
;@ Jingle3D_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle3D_Sq1, Jingle3D_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle3D_Data::
Jingle3D_Slide:
	db $00, $c0, $00, $80, $00, $40, $fe, $80
Jingle3D_Sq1:
	db $00, $40, $19, $80, $83, $01
Jingle3D_Sq1_2:
	db $00, $40, $86, $80, $83, $01

;@ def Jingle3E_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3E, Scrape: the hole filler moves, an urchin is pushed. Some running
;@ effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
Jingle3E_Start::
;> if wActiveJingle == 0x3E: return IgnoreJingle()
	ld a, [wActiveJingle]
	cp $3e
	jp z, IgnoreJingle
;> return StartJingle(Jingle3E_Sq1, timer)
	ld hl, Jingle3E_Sq1
	jp StartJingle

;@ def Jingle3E_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3E (Scrape) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3E_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> return EndJingle()
	jp EndJingle

;@ path: sound/sfx/square
;@ The data of square-channel effect $3E (Scrape), read by Jingle3E_Start / Jingle3E_Update.
;@ Jingle3E_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
Jingle3E_Sq1::
	db $27, $be, $60, $c0, $c7, $03

;@ def Jingle3F_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $3F, Buzz: Facade's flying tiles buzz. Its steps run 9 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3F_Start::
;> wJingleRepeat = 9
	ld a, $09
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle3F_Sq1)
	ld hl, Jingle3F_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle3F_Sq1, timer)
	jp StartJingle

;@ def Jingle3F_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $3F (Buzz) on, a step every frame. The frequency slides by a table of steps.
;@ At the end the channel goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle3F_Update::
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t3
	cp $04
	jr z, .case2
.part2
;=@t2
	ld hl, Jingle3F_Slide
	jp SlideSquare1
;>     wJingleRepeat -= 1
.case1
	call CountDownJingleRepeat
;>     if wJingleRepeat == 0: return SilenceJingle(timer)
	jp z, SilenceJingle
;>     if wJingleRepeat == 6:
	cp $06
	jr z, .case3
.part3
;=@t1
	ld a, $03
	ld [bc], a
;=@t2
	jr .part2
.case2
;=@t4
	ld a, $01
	ld [bc], a
	jr .part2
;>         wJingleStep = 0
.case3
	xor a
	ld [bc], a
;>         SaveSquare1Freq(Jingle3F_Sq1_2)
	ld hl, Jingle3F_Sq1_2
	call SaveSquare1Freq
;>         return WriteSquare1Regs(Jingle3F_Sq1_2, timer)
	jp WriteSquare1Regs
;>@t1     wJingleStep = 3
;>@t2     return SlideSquare1(Jingle3F_Slide, step)
;>@t3 if wJingleStep == 4:
;>@t4     wJingleStep = 1
;> return SlideSquare1(Jingle3F_Slide, step)

;@ path: sound/sfx/square
;@ The data of square-channel effect $3F (Buzz), read by Jingle3F_Start / Jingle3F_Update.
;@ Jingle3F_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle3F_Sq1, Jingle3F_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle3F_Data::
Jingle3F_Slide:
	db $00, $60, $00, $40, $ff, $70
Jingle3F_Sq1:
	db $00, $80, $19, $00, $86, $01
Jingle3F_Sq1_2:
	db $00, $80, $d1, $10, $86, $01

;@ def Jingle40_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $40 (not requested directly). Its steps run 4 times.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle40_Start::
;> wJingleRepeat = 4
	ld a, $04
	ld [wJingleRepeat], a
;> SaveSquare1Freq(Jingle40_Sq1)
	ld hl, Jingle40_Sq1
	call SaveSquare1Freq
;> return StartJingle(Jingle40_Sq1, timer)
	jp StartJingle

;@ def Jingle40_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $40 on, a slide step every frame. Every 4 frames a round ends and counts
;@ wJingleSubStep up: at 6 the sound starts over from its second record, from 6 on the slide uses its second
;@ step, at 20 the effect ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle40_Update::
;> wJingleRepeat -= 1
	call CountDownJingleRepeat
;> if wJingleRepeat == 0:
	jr z, .round
;>@t2     wJingleSubStep += 1
;>@t3     if wJingleSubStep == 20: return EndJingle()
;>@t4     if wJingleSubStep == 6:
;>@t5         wJingleRepeat = 4
;>@t6         SaveSquare1Freq(Jingle40_Sq1_2)
;>@t7         return WriteSquare1Regs(Jingle40_Sq1_2, timer)
;>@t8     wJingleRepeat = 4
;> if wJingleSubStep < 6:
.pick
	ld a, [wJingleSubStep]
	cp $06
	jr nc, .late
;>     wJingleStep = 1
	ld a, $01
.setStep
	ld [bc], a
;> else:
;>@t9     wJingleStep = 2
;> return SlideSquare1(Jingle40_Slide, step)
	ld hl, Jingle40_Slide
	jp SlideSquare1
.late
;=@t9
	ld a, $02
	jr .setStep
.round
;=@t2
	push bc
	ld bc, wJingleSubStep
	call NextSfxStep
	pop bc
;=@t3
	cp $14
	jp z, EndJingle
;=@t4
	cp $06
	jp z, .restart
;=@t8
	ld a, $04
	ld [wJingleRepeat], a
	jr .pick
.restart
;=@t5
	ld a, $04
	ld [wJingleRepeat], a
;=@t6
	ld hl, Jingle40_Sq1_2
	call SaveSquare1Freq
;=@t7
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $40, read by Jingle40_Start / Jingle40_Update.
;@ Jingle40_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ Jingle40_Sq1, Jingle40_Sq1_2: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length,
;@ NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the
;@ next step.
Jingle40_Data::
Jingle40_Slide:
	db $00, $10, $ff, $f8
Jingle40_Sq1:
	db $00, $80, $1a, $80, $82, $01
Jingle40_Sq1_2:
	db $00, $80, $e5, $10, $84, $01

;@ def Jingle41_Start(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Starts square-channel effect $41 (not requested directly). It locks its channel, so that other effects of
;@ the channel are ignored until it ends.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle41_Start::
;> return StartLockedJingle(Jingle41_Sq1, timer)
	ld hl, Jingle41_Sq1
	jp StartLockedJingle

;@ def Jingle41_Update(timer: de, step: bc)
;@ path: sound/sfx/square
;@ Plays square-channel effect $41 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD390; step = 0xD394; wJingleStep = rand(0, 0x7F)
Jingle41_Update::
;> wJingleTimer -= 1
	call CountDownSfxTimer
;> if wJingleTimer: return
	ret nz
;> wJingleStep += 1
	call NextSfxStep
;> if wJingleStep == 8: return EndJingle()
	cp $08
	jp z, EndJingle
;> record = mem16[Jingle41_Sq1Table + 2 * (wJingleStep - 1)]
	ld hl, Jingle41_Sq1Table
	call GetSfxTableEntry
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs

;@ path: sound/sfx/square
;@ The data of square-channel effect $41, read by Jingle41_Start / Jingle41_Update.
;@ Jingle41_Sq1Table: one pointer per step (the first for step 1) to its record (square 1 register records).
;@ Jingle41_Sq1, Jingle41_Sq1_2, Jingle41_Sq1_3, Jingle41_Sq1_4, Jingle41_Sq1_5, Jingle41_Sq1_6,
;@ Jingle41_Sq1_7, Jingle41_Sq1_8: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and
;@ length, NR12 volume envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames
;@ until the next step.
Jingle41_Data::
Jingle41_Sq1Table:
	dw Jingle41_Sq1_5, Jingle41_Sq1_2, Jingle41_Sq1_6, Jingle41_Sq1_3, Jingle41_Sq1_7, Jingle41_Sq1_4, Jingle41_Sq1_8
Jingle41_Sq1:
	db $00, $00, $c1, $7b, $87, $06
Jingle41_Sq1_2:
	db $00, $00, $c1, $8a, $87, $06
Jingle41_Sq1_3:
	db $00, $00, $c1, $90, $87, $07
Jingle41_Sq1_4:
	db $00, $00, $c1, $b6, $87, $07
Jingle41_Sq1_5:
	db $00, $00, $62, $7b, $87, $04
Jingle41_Sq1_6:
	db $00, $00, $62, $8a, $87, $04
Jingle41_Sq1_7:
	db $00, $00, $62, $90, $87, $04
Jingle41_Sq1_8:
	db $00, $00, $62, $b6, $87, $04
	db $3e, $01, $ea, $a0, $d3

;@ def StartLockedJingle(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Starts the requested square-channel effect like StartJingle and locks the channel: other requests (except
;@ effect 1) are ignored until this effect ends.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD390
StartLockedJingle::
;> wJingleLocked = 1
	ld a, $01
	ld [wJingleLocked], a
;> return StartJingle(record, timer)          # falls through

;@ def StartJingle(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ The common start of a square-channel effect: wActiveJingle = the request, timer, step and sub-step
;@ cleared, square 1 taken from the music (bit 7 of its channel record's last byte), then the first record
;@ is written to NR10-NR14 and its frame count goes into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD390
StartJingle::
;> wActiveJingle = wJingleToPlay
	ld a, [wJingleToPlay]
	ld [wActiveJingle], a
;> wJingleTimer = 0
	xor a
	ld [wJingleTimer], a
;> wJingleStep = 0
	ld [wJingleStep], a
;> wJingleSubStep = 0
	ld [wJingleSubStep], a
;> wMusicChannel1[0x0F] |= 0x80               # the music leaves square 1 alone
	ld a, [wMusicChannel1 + $0F]
	set 7, a
	ld [wMusicChannel1 + $0F], a
;> return WriteSquare1Regs(record, timer)
	jp WriteSquare1Regs

;@ def SilenceJingle(timer: de)
;@ path: sound/sfx/engine
;@ Ends the square-channel effect after silencing square 1 (JingleSilence).
;@ test: timer = 0xD390
SilenceJingle::
;> WriteSquare1Regs(JingleSilence, timer)
	ld hl, JingleSilence
	call WriteSquare1Regs
;> return EndJingle()                         # falls through

;@ def EndJingle()
;@ path: sound/sfx/engine
;@ Ends the square-channel effect: its state is cleared, the lock released and square 1 given back to the
;@ music, which plays on it again from its next note.
EndJingle::
;> wActiveJingle = 0
	xor a
	ld [wActiveJingle], a
;> wJingleTimer = 0
	ld [wJingleTimer], a
;> rNR10 = 0                                  # no sweep
	ldh [rNR10], a
;> wJingleStep = 0
	ld [wJingleStep], a
;> wJingleRepeat = 0
	ld [wJingleRepeat], a
;> wSoundUnusedA0 = 0
	ld [wSoundUnusedA0], a
;> wJingleLocked = 0
	ld [wJingleLocked], a
;> wMusicChannel1[0x0F] &= 0x7F               # square 1 back to the music
	ld a, [wMusicChannel1 + $0F]
	res 7, a
	ld [wMusicChannel1 + $0F], a
	ret

;@ path: sound/sfx/engine
;@ The square 1 record that silences the channel when an effect ends (SilenceJingle).
;@ JingleSilence: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
JingleSilence::
	db $00, $3f, $00, $00, $c1, $01

;@ def WriteSquare1Freq(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ A note of a square 1 effect: the record's two bytes go to NR13 / NR14, the third into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD390
WriteSquare1Freq::
;> return WriteSoundRegs(record, 2, 0x13, timer)   # rNR13, rNR14
	ld b, $02
	ld c, $13
	jp WriteSoundRegs

;@ def IgnoreJingle()
;@ path: sound/sfx/engine
;@ A square-channel request that may not start (the channel is locked, or the playing effect keeps it): the
;@ request is dropped and the playing effect goes on.
;@ test: skip runs the effect routines through their tables
IgnoreJingle::
;> wJingleToPlay = 0
	xor a
	ld [wJingleToPlay], a
;> return UpdateJingle()
	jp UpdateJingle


;@ def UpdateWaveSfx()
;@ path: sound/sfx/engine
;@ The wave-channel effects for one frame, like UpdateJingle: a request starts its routine in WaveSfxStarts
;@ unless a locked effect plays (effect $14 starts anyway), otherwise wActiveWaveSfx plays on
;@ (WaveSfxUpdates), with de = wWaveSfxTimer, bc = wWaveSfxStep. Nothing happens while the song needs the
;@ wave channel (wMusicBlocksWaveSfx).
;@ test: wCurrentBank = $1F
UpdateWaveSfx::
;> request = wWaveSfxToPlay
	ld hl, wWaveSfxToPlay
	ld a, [hl]
;> if request:
	and a
	jr z, .playOn
;>     if request != 0x14 and wWaveSfxLocked: return IgnoreWaveSfx()
	cp $14
	jr z, .start
	ld a, [wWaveSfxLocked]
	and a
	jp nz, IgnoreWaveSfx
;>     table, index = WaveSfxStarts, request
.start
	ld a, [hl]
	ld hl, WaveSfxStarts
	jr .call
;> else:
;>     if wActiveWaveSfx == 0: return
.playOn
	inc hl
	ld a, [hl]
	and a
	ret z
;>     table, index = WaveSfxUpdates, wActiveWaveSfx
	ld hl, WaveSfxUpdates
;> routine = GetSfxTableEntry(index, table)
.call
	call GetSfxTableEntry
	ld de, wWaveSfxTimer
	ld bc, wWaveSfxStep
;> if wMusicBlocksWaveSfx: return
	ld a, [wMusicBlocksWaveSfx]
	and a
	ret nz
;> return table[(index - 1) & 0x7F](addr(wWaveSfxTimer), addr(wWaveSfxStep))   # jp hl (de = the timer, bc = the step)
	jp hl

;@ path: sound/sfx/engine
;@ The start routines of the wave-channel effects ($01-$23), then WaveSfxUpdates, the routines that play
;@ them on (UpdateWaveSfx).
WaveSfxStarts::
	dw WaveSfx01_Start, WaveSfx02_Start, WaveSfx03_Start, WaveSfx04_Start, WaveSfx05_Start, WaveSfx06_Start, WaveSfx07_Start, WaveSfx08_Start
	dw WaveSfx09_Start, WaveSfx0A_Start, WaveSfx0B_Start, WaveSfx0C_Start, WaveSfx0D_Start, WaveSfx0E_Start, WaveSfx0F_Start, WaveSfx10_Start
	dw WaveSfx11_Start, WaveSfx12_Start, WaveSfx13_Start, WaveSfx14_Start, WaveSfx15_Start, WaveSfx16_Start, WaveSfx17_Start, WaveSfx18_Start
	dw WaveSfx19_Start, WaveSfx1A_Start, WaveSfx1B_Start, WaveSfx1C_Start, WaveSfx1D_Start, WaveSfx1E_Start, WaveSfx1F_Start, WaveSfx20_Start
	dw WaveSfx21_Start, WaveSfx22_Start, WaveSfx23_Start
WaveSfxUpdates:
	dw WaveSfx01_Update, WaveSfx02_Update, WaveSfx03_Update, WaveSfx04_Update, WaveSfx05_Update, WaveSfx06_Update, WaveSfx07_Update, WaveSfx08_Update
	dw WaveSfx09_Update, WaveSfx0A_Update, WaveSfx0B_Update, WaveSfx0C_Update, WaveSfx0D_Update, WaveSfx0E_Update, WaveSfx0F_Update, WaveSfx10_Update
	dw WaveSfx11_Update, WaveSfx12_Update, WaveSfx13_Update, WaveSfx14_Update, WaveSfx15_Update, WaveSfx16_Update, WaveSfx17_Update, WaveSfx18_Update
	dw WaveSfx19_Update, WaveSfx1A_Update, WaveSfx1B_Update, WaveSfx1C_Update, WaveSfx1D_Update, WaveSfx1E_Update, WaveSfx1F_Update, WaveSfx20_Update
	dw WaveSfx21_Update, WaveSfx22_Update, WaveSfx23_Update

;@ def WaveSfx01_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $01 (banks $06 and $19). It locks its channel, so that other effects of the
;@ channel are ignored until it ends; loads wave pattern SfxWave2.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx01_Start::
;> LoadSfxWave2()
	call LoadSfxWave2
;> return StartLockedWaveSfx(WaveSfx01_Wave, timer)
	ld hl, WaveSfx01_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx01_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $01 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx01_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 6: return EndWaveSfx()
	cp $06
	jp z, EndWaveSfx
;> record = mem16[WaveSfx01_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx01_WaveTable
	call GetSfxTableEntry
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $01, read by WaveSfx01_Start / WaveSfx01_Update.
;@ WaveSfx01_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx01_Wave, WaveSfx01_Wave_2, WaveSfx01_Wave_3, WaveSfx01_Wave_4, WaveSfx01_Wave_5, WaveSfx01_Wave_6:
;@ wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32 level, NR33 / NR34
;@ frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx01_Data::
WaveSfx01_WaveTable:
	dw WaveSfx01_Wave_2, WaveSfx01_Wave_3, WaveSfx01_Wave_4, WaveSfx01_Wave_5, WaveSfx01_Wave_6
WaveSfx01_Wave:
	db $80, $ee, $20, $cb, $c7, $05
WaveSfx01_Wave_2:
	db $80, $ee, $20, $d1, $c7, $05
WaveSfx01_Wave_3:
	db $80, $ee, $20, $d6, $c7, $05
WaveSfx01_Wave_4:
	db $80, $ee, $20, $dd, $c7, $07
WaveSfx01_Wave_5:
	db $80, $ee, $40, $dd, $c7, $07
WaveSfx01_Wave_6:
	db $80, $ee, $60, $dd, $c7, $07

;@ def WaveSfx02_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $02, Lift: Link lifts something. Loads wave pattern SfxWave5; its steps run 12
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx02_Start::
;> wWaveSfxRepeat = 12
	ld a, $0c
	ld [wWaveSfxRepeat], a
;> LoadSfxWave5()
	call LoadSfxWave5
;> SaveWaveFreq(WaveSfx02_Wave)
	ld hl, WaveSfx02_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx02_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx02_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $02 (Lift) on, a step every frame. The frequency slides by a table of steps. At
;@ the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx02_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 2:
	cp $02
	jr z, .case2
.part1
;=@t1
	cp $0a
	jp z, SilenceWaveSfx
.case1
;=@t2
	ld hl, WaveSfx02_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case2
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat:
	jr z, .case1
;>         wWaveSfxStep = 1
.part2
	ld a, $01
	ld [bc], a
	jr .case1
;> else:
;>@t1     if wWaveSfxStep == 10: return SilenceWaveSfx(timer)
;>@t2 return SlideWave(WaveSfx02_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $02 (Lift), read by WaveSfx02_Start / WaveSfx02_Update.
;@ WaveSfx02_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx02_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx02_Data::
WaveSfx02_Slide:
	db $00, $10, $00, $40, $00, $40, $00, $30, $00, $30, $00, $20, $00, $10, $ff, $f0
	db $ff, $e0
WaveSfx02_Wave:
	db $80, $00, $20, $80, $85, $02

;@ def WaveSfx03_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $03 (Link climbs out of the water, and more).
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx03_Start::
;> rNR30 = 0
	ld hl, SfxWave5
	xor a
	ldh [rNR30], a
;> LoadWaveRam(SfxWave5)
	call LoadWaveRam
;> SaveWaveFreq(WaveSfx03_Wave)
	ld hl, WaveSfx03_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx03_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx03_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $03 on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx03_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 5: return EndWaveSfx()
	cp $05
	jp z, EndWaveSfx
;> return SlideWave(WaveSfx03_Slide, step)
	ld hl, WaveSfx03_Slide
	jp SlideWave

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $03, read by WaveSfx03_Start / WaveSfx03_Update.
;@ WaveSfx03_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx03_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx03_Data::
WaveSfx03_Slide:
	db $01, $80, $ff, $f0, $ff, $e0
WaveSfx03_Wave:
	db $80, $ef, $20, $00, $c6, $01

;@ def WaveSfx04_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $04 (not requested directly). Loads wave pattern SfxWave5; its steps run 2
;@ times; some running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx04_Start::
;> if wActiveWaveSfx: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	and a
	jp nz, IgnoreWaveSfx
;> if wActiveJingle == 0x01: return
	ld a, [wActiveJingle]
	cp $01
	ret z
;> if wActiveJingle == 0x01: return
	ld a, [wActiveJingle]
	cp $01
	ret z
;> wWaveSfxRepeat = 2
	ld a, $02
	ld [wWaveSfxRepeat], a
;> LoadSfxWave5()
	call LoadSfxWave5
;> return StartWaveSfx(WaveSfx04_Wave, timer)
	ld hl, WaveSfx04_Wave
	jp StartWaveSfx

;@ def WaveSfx04_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $04 on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx04_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 2:
	cp $02
	jr z, .case1
.part1
;=@t1
	ld hl, WaveSfx04_WaveFreq
	jp WriteWaveFreq
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return EndWaveSfx()
	jp z, EndWaveSfx
;>     wWaveSfxStep = 0
	xor a
	ld [bc], a
;>     return WriteWaveRegs(WaveSfx04_Wave_2, timer)
	ld hl, WaveSfx04_Wave_2
	jp WriteWaveRegs
;>@t1 return WriteWaveFreq(WaveSfx04_WaveFreq, timer)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $04, read by WaveSfx04_Start / WaveSfx04_Update.
;@ WaveSfx04_Wave, WaveSfx04_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
;@ WaveSfx04_WaveFreq: wave channel notes, 3 bytes each: NR33 / NR34 frequency, then the frames until the
;@ next step.
WaveSfx04_Data::
WaveSfx04_Wave:
	db $80, $fa, $40, $c0, $c7, $04
WaveSfx04_WaveFreq:
	db $e0, $c7, $04
WaveSfx04_Wave_2:
	db $80, $fa, $60, $c0, $c7, $04

;@ def WaveSfx05_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $05, Rupees: the rupee counter counts. Loads wave pattern SfxWave2.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx05_Start::
;> LoadSfxWave2()
	call LoadSfxWave2
;> return StartWaveSfx(WaveSfx05_Wave, timer)
	ld hl, WaveSfx05_Wave
	jp StartWaveSfx

;@ def WaveSfx05_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $05 (Rupees) on: each time its timer runs out the next note of
;@ WaveSfx05_WaveFreqTable, at half volume from step 2 and a quarter from step 4; it ends at step 6.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx05_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 6: return EndWaveSfx()
	cp $06
	jp z, EndWaveSfx
;> if wWaveSfxStep == 2:
	cp $02
	jp z, .half
;>@t1     rNR32 = 0x40                          # half volume
;> elif wWaveSfxStep == 4:
	cp $04
	jp z, .quarter
;>@t2     rNR32 = 0x60                          # a quarter
;> return WriteWaveFreq(mem16[WaveSfx05_WaveFreqTable + 2 * (wWaveSfxStep - 1)], timer)
.note
	ld hl, WaveSfx05_WaveFreqTable
	call GetSfxTableEntry
	jp WriteWaveFreq
.half
;=@t1
	ld a, $40
.setLevel
	ldh [rNR32], a
	ld a, [bc]
	jr .note
.quarter
;=@t2
	ld a, $60
	jr .setLevel

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $05 (Rupees), read by WaveSfx05_Start / WaveSfx05_Update.
;@ WaveSfx05_WaveFreqTable: one pointer per step (the first for step 1) to its record (wave channel notes).
;@ WaveSfx05_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
;@ WaveSfx05_WaveFreq, WaveSfx05_WaveFreq_2: wave channel notes, 3 bytes each: NR33 / NR34 frequency, then
;@ the frames until the next step.
WaveSfx05_Data::
WaveSfx05_WaveFreqTable:
	dw WaveSfx05_WaveFreq_2, WaveSfx05_WaveFreq, WaveSfx05_WaveFreq_2, WaveSfx05_WaveFreq, WaveSfx05_WaveFreq_2
WaveSfx05_Wave:
	db $80, $fa, $20
WaveSfx05_WaveFreq:
	db $da, $c7, $02
WaveSfx05_WaveFreq_2:
	db $ea, $c7, $02

;@ def WaveSfx06_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $06, Hearts: the hearts fill up. Loads wave pattern SfxWave4; its steps run 12
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx06_Start::
;> if wActiveJingle == 0x01: return
	ld a, [wActiveJingle]
	cp $01
	ret z
;> wWaveSfxRepeat = 12
	ld a, $0c
	ld [wWaveSfxRepeat], a
;> LoadSfxWave4()
	call LoadSfxWave4
;> SaveWaveFreq(WaveSfx06_Wave)
	ld hl, WaveSfx06_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx06_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx06_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $06 (Hearts) on, a step every frame. The frequency slides by a table of steps.
;@ At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx06_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 2:
	cp $02
	jr z, .case2
.part1
;=@t4
	ld hl, WaveSfx06_Slide
	jp SlideWave
;>@t1     wWaveSfxRepeat -= 1
;>@t2     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
;>@t3     if wWaveSfxRepeat == 7:
;>         wWaveSfxStep = 0
.case1
	xor a
	ld [bc], a
;>         SaveWaveFreq(WaveSfx06_Wave_2)
	ld hl, WaveSfx06_Wave_2
	call SaveWaveFreq
;>         return WriteWaveRegs(WaveSfx06_Wave_2, timer)
	jp WriteWaveRegs
.case2
;=@t1
	call CountDownWaveSfxRepeat
;=@t2
	jp z, SilenceWaveSfx
;=@t3
	cp $07
	jr z, .case1
;>     wWaveSfxStep = 1
.part2
	ld a, $01
	ld [bc], a
	jr .part1
;>@t4 return SlideWave(WaveSfx06_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $06 (Hearts), read by WaveSfx06_Start / WaveSfx06_Update.
;@ WaveSfx06_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx06_Wave, WaveSfx06_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx06_Data::
WaveSfx06_Slide:
	db $00, $03
WaveSfx06_Wave:
	db $80, $d2, $40, $e0, $87, $01
WaveSfx06_Wave_2:
	db $80, $d2, $60, $e0, $87, $01

;@ def WaveSfx07_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $07 (Smasher's ball thrown back, the final Nightmare). Loads wave pattern
;@ SfxWave4; its steps run 2 times; some running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx07_Start::
;> if wActiveWaveSfx == 0x03: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
;> wWaveSfxRepeat = 2
	ld a, $02
	ld [wWaveSfxRepeat], a
;> LoadSfxWave4()
	call LoadSfxWave4
;> SaveWaveFreq(WaveSfx07_Wave)
	ld hl, WaveSfx07_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx07_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx07_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $07 on: each time its timer runs out, the next step. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx07_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxTimer = 1
	ld a, $01
	ld [de], a
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 29:
	cp $1d
	jr z, .case1
.part1
;=@t1
	cp $15
	jr nc, .case2
.part2
;=@t2
	ld hl, WaveSfx07_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     wWaveSfxStep = 20
	ld a, $14
	ld [bc], a
;>     SaveWaveFreq(WaveSfx07_Wave_2)
	ld hl, WaveSfx07_Wave_2
	call SaveWaveFreq
;>     return WriteWaveRegs(WaveSfx07_Wave_2, timer)
	jp WriteWaveRegs
;>@t1 if wWaveSfxStep >= 21:
;>     wWaveSfxTimer = 2
.case2
	ld a, $02
	ld [de], a
	jr .part2
;>@t2 return SlideWave(WaveSfx07_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $07, read by WaveSfx07_Start / WaveSfx07_Update.
;@ WaveSfx07_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx07_Wave, WaveSfx07_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx07_Data::
WaveSfx07_Slide:
	db $00, $40, $00, $40, $00, $40, $01, $00, $00, $20, $ff, $e0, $00, $40, $ff, $c0
	db $00, $60, $ff, $a0, $00, $80, $ff, $80, $00, $a0, $ff, $60, $00, $c0, $ff, $40
	db $01, $00, $ff, $00, $01, $00, $ff, $00, $ff, $e0, $ff, $c0, $ff, $a0, $ff, $80
	db $ff, $60, $ff, $40, $ff, $20, $ff, $00
WaveSfx07_Wave:
	db $80, $00, $20, $40, $84, $02
WaveSfx07_Wave_2:
	db $80, $00, $60, $00, $86, $02

;@ def WaveSfx08_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $08, Link dies: Link runs out of hearts. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; loads wave pattern SfxWave1; its steps run 8 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx08_Start::
;> wWaveSfxRepeat = 8
	ld a, $08
	ld [wWaveSfxRepeat], a
;> LoadSfxWave1()
	call LoadSfxWave1
;> SaveWaveFreq(WaveSfx08_Wave)
	ld hl, WaveSfx08_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx08_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx08_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $08 (Link dies) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx08_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 15:
	cp $0f
	jr z, .case1
.part1
;=@t1
	ld hl, WaveSfx08_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     wWaveSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 return SlideWave(WaveSfx08_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $08 (Link dies), read by WaveSfx08_Start / WaveSfx08_Update.
;@ WaveSfx08_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx08_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
;@ SfxWave7: wave pattern: 16 bytes = 32 4-bit samples (high nibble first) for wave RAM.
WaveSfx08_Data::
WaveSfx08_Slide:
	db $00, $0a, $00, $06, $ff, $f0, $00, $20, $00, $0a, $00, $06, $ff, $fa, $ff, $f6
	db $00, $20, $00, $0a, $00, $06, $ff, $fa, $ff, $f6, $ff, $a8
WaveSfx08_Wave:
	db $80, $00, $20, $60, $87, $00
SfxWave7:
	db $8a, $df, $fd, $a8, $87, $42, $24, $78, $8a, $df, $fd, $a8, $87, $42, $24, $78

;@ def LoadSfxWave7()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave7.
LoadSfxWave7::
;> return LoadSfxWave(SfxWave7)
	ld hl, SfxWave7
	jp LoadSfxWave

;@ def WaveSfx09_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $09, Ocarina song 1: the ocarina plays a song. It locks its channel, so that
;@ other effects of the channel are ignored until it ends; loads wave pattern SfxWave7.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx09_Start::
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> LoadSfxWave7()
	call LoadSfxWave7
;> return StartLockedWaveSfx(WaveSfx09_Wave, timer)
	ld hl, WaveSfx09_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx09_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $09 (Ocarina song 1) on: each time its timer runs out, the next step.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx09_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 20: return WaveSfx09_End(timer)
	cp $14
	jr z, WaveSfx09_End
;> record = mem16[WaveSfx09_Sq2Table + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx09_Sq2Table
	call GetSfxTableEntry
;> return WaveSfx09_PlayStep(record, timer)   # falls through

;@ def WaveSfx09_PlayStep(record: hl, timer: de)
;@ path: sound/sfx/wave
;@ Plays the record of a step of the ocarina songs (wave-channel effects $09 and $0A): on odd steps a square
;@ 2 record, on even steps a wave channel record.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD392
WaveSfx09_PlayStep::
;> if (wWaveSfxStep & 0x01): return WriteSquare2Regs(record, timer)
	ld a, [wWaveSfxStep]
	and $01
	jp nz, WriteSquare2Regs
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ def WaveSfx09_End(timer: de)
;@ path: sound/sfx/wave
;@ The end of the ocarina songs (wave-channel effects $09 and $0A): square 2 is silenced and given back to
;@ the music, then the wave channel is silenced and the effect ends.
;@ test: timer = 0xD392
WaveSfx09_End::
;> WriteSquare2Regs(Square2Off, timer)
	ld hl, Square2Off
	call WriteSquare2Regs
;> wMusicChannel2[0x0F] &= 0x7F
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;> return SilenceWaveSfx(timer)
	jp SilenceWaveSfx

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $09 (Ocarina song 1), read by WaveSfx09_Start / WaveSfx09_Update.
;@ WaveSfx09_Sq2Table: one pointer per step (the first for step 1) to its record; the steps use different
;@ kinds of record, listed below.
;@ WaveSfx09_Wave, WaveSfx09_Wave_2, WaveSfx09_Wave_3, WaveSfx09_Wave_4, WaveSfx09_Wave_5, WaveSfx09_Wave_6,
;@ WaveSfx09_Wave_7, WaveSfx09_Wave_8, WaveSfx09_Wave_9, WaveSfx09_Wave_10: wave channel register records, 6
;@ bytes each: NR30 on ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the
;@ sound), then the frames until the next step.
;@ WaveSfx09_Sq2, WaveSfx09_Sq2_2, WaveSfx09_Sq2_3, WaveSfx09_Sq2_4, WaveSfx09_Sq2_5, WaveSfx09_Sq2_6,
;@ WaveSfx09_Sq2_7, WaveSfx09_Sq2_8, WaveSfx09_Sq2_9, WaveSfx09_Sq2_10: square 2 register records, 5 bytes
;@ each: NR21 duty and length, NR22 volume envelope, NR23 / NR24 frequency (NR24 bit 7 restarts the sound),
;@ then the frames until the next step.
WaveSfx09_Data::
WaveSfx09_Sq2Table:
	dw WaveSfx09_Sq2, WaveSfx09_Wave_2, WaveSfx09_Sq2_2, WaveSfx09_Wave_3, WaveSfx09_Sq2_3, WaveSfx09_Wave_4, WaveSfx09_Sq2_4, WaveSfx09_Wave_5
	dw WaveSfx09_Sq2_5, WaveSfx09_Wave_6, WaveSfx09_Sq2_6, WaveSfx09_Wave_7, WaveSfx09_Sq2_7, WaveSfx09_Wave_8, WaveSfx09_Sq2_8, WaveSfx09_Wave_9
	dw WaveSfx09_Sq2_9, WaveSfx09_Wave_10, WaveSfx09_Sq2_10
WaveSfx09_Wave:
	db $80, $e6, $20, $8a, $c7, $08
WaveSfx09_Wave_2:
	db $80, $e6, $20, $97, $c7, $08
WaveSfx09_Wave_3:
	db $80, $60, $20, $9c, $c7, $08
WaveSfx09_Wave_4:
	db $80, $e6, $20, $8a, $c7, $08
WaveSfx09_Wave_5:
	db $80, $e6, $20, $97, $c7, $08
WaveSfx09_Wave_6:
	db $80, $e6, $20, $9c, $c7, $08
WaveSfx09_Wave_7:
	db $80, $e6, $20, $97, $c7, $08
WaveSfx09_Wave_8:
	db $80, $e6, $20, $8a, $c7, $08
WaveSfx09_Wave_9:
	db $80, $e6, $20, $62, $c7, $08
WaveSfx09_Wave_10:
	db $80, $00, $20, $79, $c7, $08
WaveSfx09_Sq2:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_2:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_3:
	db $80, $20, $9c, $87, $34
WaveSfx09_Sq2_4:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_5:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_6:
	db $80, $20, $9c, $87, $02
WaveSfx09_Sq2_7:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_8:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_9:
	db $80, $20, $62, $87, $02
WaveSfx09_Sq2_10:
	db $80, $20, $79, $87, $48

;@ def WaveSfx0A_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0A, Ocarina song 2: the ocarina plays a song. It locks its channel, so that
;@ other effects of the channel are ignored until it ends; loads wave pattern SfxWave7.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0A_Start::
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> LoadSfxWave7()
	call LoadSfxWave7
;> return StartLockedWaveSfx(WaveSfx0A_Wave, timer)
	ld hl, WaveSfx0A_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx0A_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0A (Ocarina song 2) on: each time its timer runs out, the next step.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0A_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 22: return WaveSfx09_End(timer)
	cp $16
	jp z, WaveSfx09_End
;> record = mem16[WaveSfx0A_Sq2Table + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx0A_Sq2Table
	call GetSfxTableEntry
;> return WaveSfx09_PlayStep(record, timer)
	jp WaveSfx09_PlayStep

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0A (Ocarina song 2), read by WaveSfx0A_Start / WaveSfx0A_Update.
;@ WaveSfx0A_Sq2Table: one pointer per step (the first for step 1) to its record; the steps use different
;@ kinds of record, listed below.
;@ WaveSfx0A_Wave, WaveSfx0A_Wave_2, WaveSfx0A_Wave_3, WaveSfx0A_Wave_4, WaveSfx0A_Wave_5, WaveSfx0A_Wave_6,
;@ WaveSfx0A_Wave_7, WaveSfx0A_Wave_8: wave channel register records, 6 bytes each: NR30 on ($80) / off,
;@ NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the
;@ next step.
;@ WaveSfx0A_Sq2, WaveSfx0A_Sq2_2, WaveSfx0A_Sq2_3, WaveSfx0A_Sq2_4, WaveSfx0A_Sq2_5, WaveSfx0A_Sq2_6,
;@ WaveSfx0A_Sq2_7, WaveSfx0A_Sq2_8: square 2 register records, 5 bytes each: NR21 duty and length, NR22
;@ volume envelope, NR23 / NR24 frequency (NR24 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx0A_Data::
WaveSfx0A_Sq2Table:
	dw WaveSfx0A_Sq2, WaveSfx0A_Wave_2, WaveSfx0A_Sq2_2, WaveSfx0A_Wave_3, WaveSfx0A_Sq2_3, WaveSfx0A_Wave_4, WaveSfx0A_Sq2_4, WaveSfx0A_Wave_5
	dw WaveSfx0A_Sq2_5, WaveSfx0A_Wave_6, WaveSfx0A_Sq2_6, WaveSfx0A_Wave_7, WaveSfx0A_Sq2_7, WaveSfx0A_Wave_4, WaveSfx0A_Sq2_4, WaveSfx0A_Wave_3
	dw WaveSfx0A_Sq2_3, WaveSfx0A_Wave_2, WaveSfx0A_Sq2_2, WaveSfx0A_Wave_8, WaveSfx0A_Sq2_8
WaveSfx0A_Wave:
	db $80, $e0, $20, $9d, $c7, $04
WaveSfx0A_Wave_2:
	db $80, $e0, $20, $a7, $c7, $04
WaveSfx0A_Wave_3:
	db $80, $e0, $20, $b0, $c7, $04
WaveSfx0A_Wave_4:
	db $80, $e0, $20, $b6, $c7, $04
WaveSfx0A_Wave_5:
	db $80, $90, $20, $bd, $c7, $04
WaveSfx0A_Wave_6:
	db $80, $e0, $20, $c4, $c7, $04
WaveSfx0A_Wave_7:
	db $80, $e0, $20, $bd, $c7, $04
WaveSfx0A_Wave_8:
	db $80, $80, $20, $9d, $c7, $04
WaveSfx0A_Sq2:
	db $80, $20, $9d, $87, $07
WaveSfx0A_Sq2_2:
	db $80, $20, $a7, $87, $07
WaveSfx0A_Sq2_3:
	db $80, $20, $b0, $87, $07
WaveSfx0A_Sq2_4:
	db $80, $20, $b6, $87, $07
WaveSfx0A_Sq2_5:
	db $80, $20, $bd, $87, $23
WaveSfx0A_Sq2_6:
	db $80, $20, $c4, $87, $07
WaveSfx0A_Sq2_7:
	db $80, $20, $bd, $87, $07
WaveSfx0A_Sq2_8:
	db $80, $20, $9d, $87, $35

;@ def WaveSfx0B_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0B, Ocarina song 3: the ocarina plays a song. It locks its channel, so that
;@ other effects of the channel are ignored until it ends; loads wave pattern SfxWave7.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0B_Start::
;> StopAllSound()
	call StopAllSound
;> LoadSfxWave7()
	call LoadSfxWave7
;> return StartLockedWaveSfx(WaveSfx0A_Wave, timer)
	ld hl, WaveSfx0A_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx0B_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0B (Ocarina song 3) on: each time its timer runs out, the next step.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0B_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 18: return WaveSfx09_End(timer)
	cp $12
	jp z, WaveSfx09_End
;> record = mem16[WaveSfx0B_Sq2Table + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx0B_Sq2Table
	call GetSfxTableEntry
;> return WaveSfx09_PlayStep(record, timer)
	jp WaveSfx09_PlayStep

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0B (Ocarina song 3), read by WaveSfx0B_Start / WaveSfx0B_Update.
;@ WaveSfx0B_Sq2Table: one pointer per step (the first for step 1) to its record (square 2 register records).
;@ WaveSfx0B_Sq2, WaveSfx0B_Sq2_2, WaveSfx0B_Sq2_3, WaveSfx0B_Sq2_4, WaveSfx0B_Sq2_5, WaveSfx0B_Sq2_6,
;@ WaveSfx0B_Sq2_7, WaveSfx0B_Sq2_8, WaveSfx0B_Sq2_9, WaveSfx0B_Sq2_10, WaveSfx0B_Sq2_11, WaveSfx0B_Sq2_12,
;@ WaveSfx0B_Sq2_13, WaveSfx0B_Sq2_14, WaveSfx0B_Sq2_15, WaveSfx0B_Sq2_16, WaveSfx0B_Sq2_17: square 2
;@ register records, 5 bytes each: NR21 duty and length, NR22 volume envelope, NR23 / NR24 frequency (NR24
;@ bit 7 restarts the sound), then the frames until the next step.
WaveSfx0B_Data::
WaveSfx0B_Sq2Table:
	dw WaveSfx0B_Sq2_9, WaveSfx0B_Sq2, WaveSfx0B_Sq2_10, WaveSfx0B_Sq2_2, WaveSfx0B_Sq2_11, WaveSfx0B_Sq2_3, WaveSfx0B_Sq2_12, WaveSfx0B_Sq2_4
	dw WaveSfx0B_Sq2_13, WaveSfx0B_Sq2_5, WaveSfx0B_Sq2_14, WaveSfx0B_Sq2_6, WaveSfx0B_Sq2_15, WaveSfx0B_Sq2_7, WaveSfx0B_Sq2_16, WaveSfx0B_Sq2_8
	dw WaveSfx0B_Sq2_17, $c080, $9d20, $04c7
WaveSfx0B_Sq2:
	db $80, $f0, $20, $9d, $c7
	db $04
WaveSfx0B_Sq2_2:
	db $80, $f0, $20, $7b, $c7
	db $04
WaveSfx0B_Sq2_3:
	db $80, $f0, $20, $8e, $c7
	db $04
WaveSfx0B_Sq2_4:
	db $80, $c0, $20, $a6, $c7
	db $04
WaveSfx0B_Sq2_5:
	db $80, $c0, $20, $9d, $c7
	db $04
WaveSfx0B_Sq2_6:
	db $80, $c0, $20, $bd, $c7
	db $04
WaveSfx0B_Sq2_7:
	db $80, $f0, $20, $bd, $c7
	db $04
WaveSfx0B_Sq2_8:
	db $80, $80, $20, $bd, $c7
	db $04
WaveSfx0B_Sq2_9:
	db $80, $20, $9d, $87, $14
WaveSfx0B_Sq2_10:
	db $80, $20, $9d, $87, $08
WaveSfx0B_Sq2_11:
	db $80, $20, $7b, $87, $08
WaveSfx0B_Sq2_12:
	db $80, $20, $8e, $87, $08
WaveSfx0B_Sq2_13:
	db $80, $20, $a6, $87, $14
WaveSfx0B_Sq2_14:
	db $80, $20, $9d, $87, $14
WaveSfx0B_Sq2_15:
	db $80, $20, $bd, $87, $14
WaveSfx0B_Sq2_16:
	db $80, $20, $bd, $87, $08
WaveSfx0B_Sq2_17:
	db $80, $20, $bd, $87, $2c

;@ def WaveSfx0C_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0C, Fall: Link falls (into a warp hole, down a hole). It locks its channel,
;@ so that other effects of the channel are ignored until it ends; loads wave pattern SfxWave5; its steps
;@ run 8 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0C_Start::
;> wWaveSfxRepeat = 8
	ld a, $08
	ld [wWaveSfxRepeat], a
;> LoadSfxWave5()
	call LoadSfxWave5
;> SaveWaveFreq(WaveSfx0C_Wave)
	ld hl, WaveSfx0C_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx0C_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx0C_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0C (Fall) on, a step every frame. The frequency slides by a table of steps. At
;@ the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0C_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t2
	ld hl, WaveSfx0C_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 2:
	cp $02
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wWaveSfxStep = 0
.case2
	xor a
	ld [bc], a
;>         rNR32 = 0x60
	ld a, $60
	ldh [rNR32], a
;>         return
	ret
;>@t1     wWaveSfxStep = 1
;>@t2 return SlideWave(WaveSfx0C_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0C (Fall), read by WaveSfx0C_Start / WaveSfx0C_Update.
;@ WaveSfx0C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx0C_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx0C_Data::
WaveSfx0C_Slide:
	db $ff, $fe, $ff, $fc, $ff, $f8, $ff, $e8, $00, $14, $00, $02, $00, $04, $00, $06
WaveSfx0C_Wave:
	db $80, $00, $40, $c0, $87, $01
	db $80, $00, $60, $c0, $87, $01

;@ def WaveSfx0D_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0D (not requested directly). Loads wave pattern SfxWave3; its steps run 16
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0D_Start::
;> wWaveSfxRepeat = 16
	ld a, $10
	ld [wWaveSfxRepeat], a
;> LoadSfxWave3()
	call LoadSfxWave3
;> SaveWaveFreq(WaveSfx0D_Wave)
	ld hl, WaveSfx0D_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx0D_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx0D_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0D on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0D_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, WaveSfx0D_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 8:
	cp $08
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wWaveSfxStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveWaveFreq(WaveSfx0D_Wave_2)
	ld hl, WaveSfx0D_Wave_2
	call SaveWaveFreq
;>         return WriteWaveRegs(WaveSfx0D_Wave_2, timer)
	jp WriteWaveRegs
;>@t1     wWaveSfxStep = 1
;>@t2 return SlideWave(WaveSfx0D_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0D, read by WaveSfx0D_Start / WaveSfx0D_Update.
;@ WaveSfx0D_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx0D_Wave, WaveSfx0D_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx0D_Data::
WaveSfx0D_Slide:
	db $ff, $a0, $00, $c0
WaveSfx0D_Wave:
	db $80, $00, $20, $70, $80, $02
WaveSfx0D_Wave_2:
	db $80, $00, $60, $70, $80, $02

;@ def WaveSfx0E_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0E, Crystal switch: a crystal switch is hit. Loads wave pattern SfxWave3.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0E_Start::
;> LoadSfxWave3()
	call LoadSfxWave3
;> return StartWaveSfx(WaveSfx0E_Wave, timer)
	ld hl, WaveSfx0E_Wave
	jp StartWaveSfx

;@ def WaveSfx0E_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0E (Crystal switch) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0E_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 5: return EndWaveSfx()
	cp $05
	jp z, EndWaveSfx
;> record = mem16[WaveSfx0E_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx0E_WaveTable
	call GetSfxTableEntry
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0E (Crystal switch), read by WaveSfx0E_Start / WaveSfx0E_Update.
;@ WaveSfx0E_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx0E_Wave, WaveSfx0E_Wave_2, WaveSfx0E_Wave_3: wave channel register records, 6 bytes each: NR30 on
;@ ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx0E_Data::
WaveSfx0E_WaveTable:
	dw WaveSfx0E_Wave_2, WaveSfx0E_Wave_3, WaveSfx0E_Wave_2, WaveSfx0E_Wave
WaveSfx0E_Wave:
	db $80, $fb, $20, $00, $c2, $03
WaveSfx0E_Wave_2:
	db $80, $fd, $40, $80, $c3, $04
WaveSfx0E_Wave_3:
	db $80, $fd, $60, $00, $c4, $05

;@ def WaveSfx0F_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $0F (not requested directly). Loads wave pattern SfxWave5; some running
;@ effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx0F_Start::
;> if wActiveWaveSfx == 0x0F: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	cp $0f
	jp z, IgnoreWaveSfx
;> LoadSfxWave5()
	call LoadSfxWave5
;> return StartWaveSfx(WaveSfx0F_Wave, timer)
	ld hl, WaveSfx0F_Wave
	jp StartWaveSfx

;@ def WaveSfx0F_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $0F on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx0F_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 2: return EndWaveSfx()
	cp $02
	jp z, EndWaveSfx
;> return WriteWaveRegs(WaveSfx0F_Wave_2, timer)
	ld hl, WaveSfx0F_Wave_2
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $0F, read by WaveSfx0F_Start / WaveSfx0F_Update.
;@ WaveSfx0F_Wave, WaveSfx0F_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx0F_Data::
WaveSfx0F_Wave:
	db $80, $fb, $60, $d2, $c7, $01
WaveSfx0F_Wave_2:
	db $80, $fb, $40, $d2, $c7, $02

;@ def WaveSfx10_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $10 (entities (delayed), Smasher's ball, bank $15 bosses). It locks its
;@ channel, so that other effects of the channel are ignored until it ends; loads wave pattern SfxWave4; its
;@ steps run 2 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx10_Start::
;> wWaveSfxRepeat = 2
	ld a, $02
	ld [wWaveSfxRepeat], a
;> LoadSfxWave4()
	call LoadSfxWave4
;> SaveWaveFreq(WaveSfx10_Wave)
	ld hl, WaveSfx10_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx10_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx10_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $10 on: each time its timer runs out, the next step. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx10_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxTimer = 1
	ld a, $01
	ld [de], a
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 113:
	cp $71
	jr z, .case1
.part1
;=@t1
	ld hl, WaveSfx10_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     wWaveSfxStep = 96
	ld a, $60
	ld [bc], a
;>     SaveWaveFreq(WaveSfx10_Wave_2)
	ld hl, WaveSfx10_Wave_2
	call SaveWaveFreq
;>     return WriteWaveRegs(WaveSfx10_Wave_2, timer)
	jp WriteWaveRegs
;>@t1 return SlideWave(WaveSfx10_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $10, read by WaveSfx10_Start / WaveSfx10_Update.
;@ WaveSfx10_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx10_Wave, WaveSfx10_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx10_Data::
WaveSfx10_Slide:
	db $00, $b0, $00, $b0, $00, $b0, $00, $b0, $00, $60, $00, $60, $00, $60, $00, $60
	db $00, $20, $ff, $e0, $00, $40, $ff, $c0, $00, $60, $ff, $a0, $00, $80, $ff, $80
	db $00, $a0, $ff, $60, $00, $c0, $ff, $40, $00, $80, $ff, $88, $00, $80, $ff, $88
	db $00, $90, $ff, $78, $00, $a0, $ff, $68, $00, $b0, $ff, $56, $00, $c0, $ff, $46
	db $00, $c0, $ff, $44, $00, $c0, $ff, $44, $00, $c0, $ff, $43, $00, $c0, $ff, $43
	db $00, $c0, $ff, $42, $00, $a0, $ff, $62, $00, $80, $ff, $82, $00, $80, $ff, $82
	db $00, $80, $ff, $84, $00, $80, $ff, $84, $00, $80, $ff, $84, $00, $80, $ff, $84
	db $00, $80, $ff, $b0, $00, $80, $ff, $b0, $00, $80, $ff, $80, $00, $80, $ff, $80
	db $00, $80, $ff, $80, $00, $80, $ff, $80, $00, $80, $ff, $68, $00, $80, $ff, $68
	db $00, $80, $ff, $68, $00, $80, $ff, $68, $00, $80, $ff, $78, $00, $80, $ff, $78
	db $00, $a0, $ff, $40, $00, $a0, $ff, $40, $00, $a0, $ff, $40, $00, $a0, $ff, $40
	db $00, $a0, $ff, $40, $00, $a0, $ff, $40, $00, $a0, $ff, $40, $00, $a0, $ff, $40
	db $00, $a0, $ff, $40, $00, $a0, $ff, $40, $00, $a0, $ff, $00, $00, $a0, $ff, $00
	db $00, $80, $fe, $80, $00, $80, $fe, $80, $00, $80, $fe, $80, $00, $80, $fe, $80
WaveSfx10_Wave:
	db $80, $00, $20, $a0, $81, $02
WaveSfx10_Wave_2:
	db $80, $00, $60, $22, $86, $02

;@ def WaveSfx11_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $11 (bank $03). Loads wave pattern SfxWave2; its steps run 12 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx11_Start::
;> wWaveSfxRepeat = 12
	ld a, $0c
	ld [wWaveSfxRepeat], a
;> LoadSfxWave2()
	call LoadSfxWave2
;> SaveWaveFreq(WaveSfx11_Wave)
	ld hl, WaveSfx11_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx11_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx11_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $11 on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx11_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t4
	ld hl, WaveSfx11_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 6:
	cp $06
	jp z, .case2
.part2
;=@t1
	cp $03
	jp z, .case3
.part3
;=@t2
	ld a, $01
	ld [bc], a
;=@t3
	ld hl, WaveSfx11_Slide
	jp SlideWave
;>         SaveWaveFreq(WaveSfx11_Wave_2)
.case2
	ld hl, WaveSfx11_Wave_2
.part4
	call SaveWaveFreq
;>         wWaveSfxStep = 0
	xor a
	ld [bc], a
;>         return WriteWaveRegs(WaveSfx11_Wave_2, timer)
	jp WriteWaveRegs
;>@t1     if wWaveSfxRepeat == 3:
;>         SaveWaveFreq(WaveSfx11_Wave_3)
.case3
	ld hl, WaveSfx11_Wave_3
	jr .part4
;>         wWaveSfxStep = 0
;>         return WriteWaveRegs(WaveSfx11_Wave_3, timer)
;>@t2     wWaveSfxStep = 1
;>@t3     return SlideWave(WaveSfx11_Slide, step)
;>@t4 return SlideWave(WaveSfx11_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $11, read by WaveSfx11_Start / WaveSfx11_Update.
;@ WaveSfx11_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx11_Wave, WaveSfx11_Wave_2, WaveSfx11_Wave_3: wave channel register records, 6 bytes each: NR30 on
;@ ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx11_Data::
WaveSfx11_Slide:
	db $00, $e0, $ff, $a0
WaveSfx11_Wave:
	db $80, $00, $20, $00, $84, $01
WaveSfx11_Wave_2:
	db $80, $00, $40, $80, $85, $01
WaveSfx11_Wave_3:
	db $80, $00, $60, $80, $85, $01

;@ def WaveSfx12_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $12 (an entity's status change). Loads wave pattern SfxWave2; its steps run 18
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx12_Start::
;> wWaveSfxRepeat = 18
	ld a, $12
	ld [wWaveSfxRepeat], a
;> LoadSfxWave2()
	call LoadSfxWave2
;> SaveWaveFreq(WaveSfx12_Wave)
	ld hl, WaveSfx12_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx12_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx12_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $12 on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx12_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, WaveSfx12_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 6:
	cp $06
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wWaveSfxStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveWaveFreq(WaveSfx12_Wave_2)
	ld hl, WaveSfx12_Wave_2
	call SaveWaveFreq
;>         return WriteWaveRegs(WaveSfx12_Wave_2, timer)
	jp WriteWaveRegs
;>@t1     wWaveSfxStep = 1
;>@t2 return SlideWave(WaveSfx12_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $12, read by WaveSfx12_Start / WaveSfx12_Update.
;@ WaveSfx12_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx12_Wave, WaveSfx12_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx12_Data::
WaveSfx12_Slide:
	db $01, $00, $fe, $c0
WaveSfx12_Wave:
	db $80, $00, $20, $40, $86, $02
WaveSfx12_Wave_2:
	db $80, $00, $60, $c0, $84, $02

;@ def WaveSfx13_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $13, Cucco: a cucco clucks. Loads wave pattern SfxWave6; its steps run 4
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx13_Start::
;> wWaveSfxRepeat = 4
	ld a, $04
	ld [wWaveSfxRepeat], a
;> LoadSfxWave6()
	call LoadSfxWave6
;> SaveWaveFreq(WaveSfx13_Wave)
	ld hl, WaveSfx13_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx13_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx13_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $13 (Cucco) on, one slide step every frame (the timer is set to 1): rounds of 5
;@ steps, each followed by a 6-frame pause; wWaveSfxRepeat counts the rounds, the last two start from a
;@ different record, and the effect ends when it runs out.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx13_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxTimer = 1
	ld a, $01
	ld [de], a
;> wWaveSfxStep += 1
	call NextSfxStep
;>@t1 if wWaveSfxStep == 6 and wWaveSfxRepeat != 1:
	cp $06
	jr z, .six
;>@t2     if wWaveSfxRepeat == 4: return
;>@t3     wWaveSfxTimer = 6
;>@t4     rNR32 = 0                             # a pause
;>@t5     return
;> if wWaveSfxStep in (6, 7):                  # (step 6 gets here in the last round)
	cp $07
	jr z, .round
;>@t6     wWaveSfxRepeat -= 1
;>@t7     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
;>@t8     record = WaveSfx13_Wave_3 if wWaveSfxRepeat in (1, 2) else WaveSfx13_Wave_2
;>@t9     wWaveSfxStep = 0
;>@t10     SaveWaveFreq(record)
;>@t11     return WriteWaveRegs(record, timer)
;> return SlideWave(WaveSfx13_Slide, step)
	ld hl, WaveSfx13_Slide
	jp SlideWave
.round
;=@t6
	call CountDownWaveSfxRepeat
;=@t7
	jp z, SilenceWaveSfx
;=@t8
	cp $02
	jr z, .high
	cp $01
	jr z, .high
	ld hl, WaveSfx13_Wave_2
.restart
;=@t9
	xor a
	ld [bc], a
;=@t10
	call SaveWaveFreq
;=@t11
	jp WriteWaveRegs
.six
;=@t1
	ld a, [wWaveSfxRepeat]
	cp $01
	jr z, .round
;=@t2
	cp $04
	ret z
;=@t3
	ld a, $06
	ld [de], a
;=@t4
	xor a
	ldh [rNR32], a
;=@t5
	ret
.high
;=@t8
	ld hl, WaveSfx13_Wave_3
	jr .restart

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $13 (Cucco), read by WaveSfx13_Start / WaveSfx13_Update.
;@ WaveSfx13_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx13_Wave, WaveSfx13_Wave_2, WaveSfx13_Wave_3: wave channel register records, 6 bytes each: NR30 on
;@ ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx13_Data::
WaveSfx13_Slide:
	db $02, $40, $01, $40, $ff, $f2, $00, $0e, $ff, $f2
WaveSfx13_Wave:
	db $80, $00, $20, $16, $84, $01
WaveSfx13_Wave_2:
	db $80, $00, $20, $26, $84, $01
WaveSfx13_Wave_3:
	db $80, $00, $20, $08, $84, $01

;@ def WaveSfx14_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $14, Monkey hop: a monkey hops (it may start over a locked effect). Loads wave
;@ pattern SfxWave2; its steps run 4 times; some running effects keep their channel (the request is then
;@ ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx14_Start::
;> if wActiveWaveSfx == 0x14: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	cp $14
	jp z, IgnoreWaveSfx
;> wWaveSfxRepeat = 4
	ld a, $04
	ld [wWaveSfxRepeat], a
;> LoadSfxWave2()
	call LoadSfxWave2
;> SaveWaveFreq(WaveSfx14_Wave)
	ld hl, WaveSfx14_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx14_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx14_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $14 (Monkey hop) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx14_Update::
;> wWaveSfxRepeat -= 1
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;> wWaveSfxStep = 1
	ld a, $01
	ld [bc], a
;> return SlideWave(WaveSfx14_Slide, step)
	ld hl, WaveSfx14_Slide
	jp SlideWave

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $14 (Monkey hop), read by WaveSfx14_Start / WaveSfx14_Update.
;@ WaveSfx14_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx14_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx14_Data::
WaveSfx14_Slide:
	db $00, $0e
WaveSfx14_Wave:
	db $80, $00, $40, $80, $87, $01

;@ def WaveSfx15_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $15, Ocarina song 4: the ocarina. It locks its channel, so that other effects
;@ of the channel are ignored until it ends; loads wave pattern SfxWave1.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx15_Start::
;> LoadSfxWave1()
	call LoadSfxWave1
;> return StartLockedWaveSfx(WaveSfx15_Wave, timer)
	ld hl, WaveSfx15_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx15_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $15 (Ocarina song 4) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx15_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 6: return EndWaveSfx()
	cp $06
	jp z, EndWaveSfx
;> record = mem16[WaveSfx15_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx15_WaveTable
	call GetSfxTableEntry
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $15 (Ocarina song 4), read by WaveSfx15_Start / WaveSfx15_Update.
;@ WaveSfx15_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx15_Wave, WaveSfx15_Wave_2, WaveSfx15_Wave_3, WaveSfx15_Wave_4, WaveSfx15_Wave_5, WaveSfx15_Wave_6:
;@ wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32 level, NR33 / NR34
;@ frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx15_Data::
WaveSfx15_WaveTable:
	dw WaveSfx15_Wave_2, WaveSfx15_Wave_3, WaveSfx15_Wave_4, WaveSfx15_Wave_5, WaveSfx15_Wave_6
WaveSfx15_Wave:
	db $80, $d0, $20, $40, $c7, $14
WaveSfx15_Wave_2:
	db $80, $c0, $20, $64, $c7, $0c
WaveSfx15_Wave_3:
	db $80, $90, $40, $78, $c7, $40
WaveSfx15_Wave_4:
	db $80, $c0, $20, $54, $c7, $06
WaveSfx15_Wave_5:
	db $80, $c0, $40, $46, $c7, $0c
WaveSfx15_Wave_6:
	db $80, $a0, $20, $5e, $c7, $20

;@ def WaveSfx16_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $16 (Hot Head's lava, Hinox charging). Loads wave pattern SfxWave4; its steps
;@ run 2 times; some running effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx16_Start::
;> if wActiveWaveSfx == 0x03: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
;> if wActiveWaveSfx == 0x07: return IgnoreWaveSfx()
	cp $07
	jp z, IgnoreWaveSfx
;> wWaveSfxRepeat = 2
	ld a, $02
	ld [wWaveSfxRepeat], a
;> LoadSfxWave4()
	call LoadSfxWave4
;> SaveWaveFreq(WaveSfx16_Wave)
	ld hl, WaveSfx16_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx16_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx16_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $16 on: each time its timer runs out, the next step. The frequency slides by a
;@ table of steps. At the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx16_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxTimer = 1
	ld a, $01
	ld [de], a
;> if wWaveSfxStep >= 7:
	ld a, [bc]
	cp $07
	jr nc, .case1
;>@t1     wWaveSfxTimer = 3
;> wWaveSfxStep += 1
.part1
	call NextSfxStep
;> if wWaveSfxStep == 16:
	cp $10
	jr z, .case2
.part2
;=@t2
	ld hl, WaveSfx16_Slide
	jp SlideWave
.case1
;=@t1
	ld a, $03
	ld [de], a
	jr .part1
;>     wWaveSfxRepeat -= 1
.case2
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     wWaveSfxStep = 3
	ld a, $03
	ld [bc], a
;>     SaveWaveFreq(WaveSfx16_Wave_2)
	ld hl, WaveSfx16_Wave_2
	call SaveWaveFreq
;>     return WriteWaveRegs(WaveSfx16_Wave_2, timer)
	jp WriteWaveRegs
;>@t2 return SlideWave(WaveSfx16_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $16, read by WaveSfx16_Start / WaveSfx16_Update.
;@ WaveSfx16_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx16_Wave, WaveSfx16_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
;@ WaveSfx17_WavePattern: wave pattern: 16 bytes = 32 4-bit samples (high nibble first) for wave RAM.
WaveSfx16_Data::
WaveSfx16_Slide:
	db $02, $00, $02, $00, $01, $00, $00, $c0, $ff, $40, $00, $c0, $ff, $40, $ff, $00
	db $ff, $00, $fe, $00, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0
WaveSfx16_Wave:
	db $80, $00, $20, $60, $80, $02
WaveSfx16_Wave_2:
	db $80, $00, $60, $60, $85, $02
WaveSfx17_WavePattern:
	db $02, $46, $8a, $ce, $fc, $96, $04, $04, $02, $46, $8a, $ce, $fc, $96, $04, $04

;@ def WaveSfx17_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $17, Wind Fish: the Wind Fish speaks, the glowing ring in the ending. It locks
;@ its channel, so that other effects of the channel are ignored until it ends; loads wave pattern SfxWave2;
;@ its steps run 3 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx17_Start::
;> wMusicChannel4[0x0F] |= 0x80
	ld hl, wMusicChannel4 + $0F
	set 7, [hl]
;> wWaveSfxRepeat = 3
	ld a, $03
	ld [wWaveSfxRepeat], a
;> WriteNoiseRegs(WaveSfx17_Noise, timer)
	ld hl, WaveSfx17_Noise
	call WriteNoiseRegs
;> LoadSfxWave2()
	call LoadSfxWave2
;> LoadSfxWave(WaveSfx17_WavePattern)
	ld hl, WaveSfx17_WavePattern
	call LoadSfxWave
;> SaveWaveFreq(WaveSfx17_Wave)
	ld hl, WaveSfx17_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx17_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx17_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $17 (Wind Fish) on, a slide step every frame; the noise channel plays along
;@ (steps 3 and 7 change the volume, step 7 adds a noise). Rounds of 84 steps until wWaveSfxRepeat runs out;
;@ the last round uses other records, and at the end both channels are silenced.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx17_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep != 85:
	cp $55
	jr z, .round
;>     if wWaveSfxStep == 3:
	cp $03
	jr z, .s3
;>@t1         rNR32 = 0x40                      # half volume
;>     elif wWaveSfxStep == 7:
	cp $07
	jr z, .s7
;>@t2         WriteNoiseRegs(WaveSfx17_Noise_2, timer)
;>@t3         rNR32 = 0x20                      # full volume
;>     return SlideWave(WaveSfx17_Slide, step)
.slide
	ld hl, WaveSfx17_Slide
	jp SlideWave
.s3
;=@t1
	ld a, $40
.setLevel
	ldh [rNR32], a
	ld bc, wWaveSfxStep
	jr .slide
.s7
;=@t2
	ld hl, WaveSfx17_Noise_2
	call WriteNoiseRegs
;=@t3
	ld a, $20
	jr .setLevel
;> wWaveSfxRepeat -= 1
.round
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 0:
	jr z, .done
;>@t4     wMusicChannel4[0x0F] &= 0x7F            # the noise channel back to the music
;>@t5     WriteNoiseRegs(NoiseSfxSilence, timer)
;>@t6     return SilenceWaveSfx(timer)
;> if wWaveSfxRepeat != 1:
	cp $01
	jr z, .last
;>     wWaveSfxStep = 64
	ld a, $40
	ld [bc], a
;>     WriteNoiseRegs(WaveSfx17_Noise_3, timer)
	ld hl, WaveSfx17_Noise_3
	call WriteNoiseRegs
;>     SaveWaveFreq(WaveSfx17_Wave_2)
	ld hl, WaveSfx17_Wave_2
	call SaveWaveFreq
;>     return WriteWaveRegs(WaveSfx17_Wave_2, timer)
	jp WriteWaveRegs
;> wWaveSfxStep = 64
.last
	ld a, $40
	ld [bc], a
;> WriteNoiseRegs(WaveSfx17_Noise_4, timer)
	ld hl, WaveSfx17_Noise_4
	call WriteNoiseRegs
;> SaveWaveFreq(WaveSfx17_Wave_3)
	ld hl, WaveSfx17_Wave_3
	call SaveWaveFreq
;> return WriteWaveRegs(WaveSfx17_Wave_3, timer)
	jp WriteWaveRegs
.done
;=@t4
	ld hl, wMusicChannel4 + $0F
	res 7, [hl]
;=@t5
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs
;=@t6
	jp SilenceWaveSfx

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $17 (Wind Fish), read by WaveSfx17_Start / WaveSfx17_Update.
;@ WaveSfx17_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx17_Noise, WaveSfx17_Noise_2, WaveSfx17_Noise_3, WaveSfx17_Noise_4: noise channel register records,
;@ 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7),
;@ then the frames until the next step.
;@ WaveSfx17_Wave, WaveSfx17_Wave_2, WaveSfx17_Wave_3: wave channel register records, 6 bytes each: NR30 on
;@ ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx17_Data::
WaveSfx17_Slide:
	db $00, $40, $ff, $e0, $00, $40, $ff, $e0, $00, $30, $ff, $e8, $00, $30, $ff, $e8
	db $00, $20, $ff, $f0, $00, $20, $ff, $f0, $00, $10, $ff, $f8, $00, $10, $ff, $f8
	db $00, $08, $ff, $f9, $00, $08, $ff, $f9, $00, $08, $ff, $f9, $00, $08, $ff, $f9
	db $00, $08, $ff, $f9, $00, $08, $ff, $f9, $00, $08, $ff, $f8, $00, $08, $ff, $f8
	db $00, $08, $ff, $f8, $00, $08, $ff, $f8, $00, $08, $ff, $f7, $00, $08, $ff, $f7
	db $00, $08, $ff, $f7, $00, $08, $ff, $f7, $00, $08, $ff, $f7, $00, $08, $ff, $f7
	db $00, $10, $ff, $ee, $00, $10, $ff, $ee, $00, $10, $ff, $ee, $00, $10, $ff, $ee
	db $00, $10, $ff, $ee, $00, $10, $ff, $ee, $00, $10, $ff, $ee, $00, $10, $ff, $ee
	db $00, $10, $ff, $ee, $00, $10, $ff, $ee, $00, $10, $ff, $ec, $00, $10, $ff, $ec
	db $00, $10, $ff, $ec, $00, $10, $ff, $ec, $00, $10, $ff, $ec, $00, $10, $ff, $ec
	db $00, $10, $ff, $ec, $00, $10, $ff, $ec
WaveSfx17_Noise:
	db $00, $19, $00, $80, $01
WaveSfx17_Noise_2:
	db $00, $a0, $00, $80, $01
WaveSfx17_Noise_3:
	db $00, $50, $00, $80, $01
WaveSfx17_Noise_4:
	db $00, $20, $00, $80, $01
WaveSfx17_Wave:
	db $80, $00, $60, $a0, $86, $02
WaveSfx17_Wave_2:
	db $80, $00, $40, $20, $87, $02
WaveSfx17_Wave_3:
	db $80, $00, $60, $20, $87, $02

;@ def WaveSfx18_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $18, Bark: BowWow or a poodle barks. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; loads wave pattern SfxWave4; its steps run 14 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx18_Start::
;> wWaveSfxRepeat = 14
	ld a, $0e
	ld [wWaveSfxRepeat], a
;> LoadSfxWave4()
	call LoadSfxWave4
;> SaveWaveFreq(WaveSfx18_Wave)
	ld hl, WaveSfx18_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx18_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx18_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $18 (Bark) on, a step every frame. The frequency slides by a table of steps. At
;@ the end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx18_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, WaveSfx18_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 7:
	cp $07
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wWaveSfxStep = 0
.case2
	xor a
	ld [bc], a
;>         SaveWaveFreq(WaveSfx18_Wave)
	ld hl, WaveSfx18_Wave
	call SaveWaveFreq
;>         return WriteWaveRegs(WaveSfx18_Wave, timer)
	jp WriteWaveRegs
;>@t1     wWaveSfxStep = 1
;>@t2 return SlideWave(WaveSfx18_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $18 (Bark), read by WaveSfx18_Start / WaveSfx18_Update.
;@ WaveSfx18_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx18_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx18_Data::
WaveSfx18_Slide:
	db $00, $60, $ff, $00
WaveSfx18_Wave:
	db $80, $00, $20, $40, $86, $00

;@ def WaveSfx19_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $19 (not requested directly). Loads wave pattern SfxWave1.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx19_Start::
;> LoadSfxWave1()
	call LoadSfxWave1
;> SaveWaveFreq(WaveSfx19_Wave)
	ld hl, WaveSfx19_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx19_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx19_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $19 on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx19_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 19: return SilenceWaveSfx(timer)
	cp $13
	jp z, SilenceWaveSfx
;> if wWaveSfxStep == 2:
	cp $02
	jr z, .case1
.part1
;=@t1
	cp $0e
	jr z, .case2
.part2
;=@t2
	cp $10
	jr z, .case3
.part3
;=@t3
	ld hl, WaveSfx19_Slide
	jp SlideWave
;>     rNR32 = 0x20
.case1
	ld a, $20
.part4
	ldh [rNR32], a
;>     value = wWaveSfxStep
	ld a, [bc]
	jr .part3
;> else:
;>@t1     if wWaveSfxStep == 14:
;>         rNR32 = 0x40
.case2
	ld a, $40
	jr .part4
;>     else:
;>@t2         if wWaveSfxStep == 16:
;>             rNR32 = 0x60
.case3
	ld a, $60
	jr .part4
;>@t3 return SlideWave(WaveSfx19_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $19, read by WaveSfx19_Start / WaveSfx19_Update.
;@ WaveSfx19_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx19_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx19_Data::
WaveSfx19_Slide:
	db $ff, $f0, $00, $12, $ff, $f0, $00, $12, $ff, $f0, $00, $12, $ff, $e0, $00, $1e
	db $ff, $e0, $00, $1c, $ff, $e0, $00, $1a, $ff, $e0, $00, $18, $ff, $e0, $00, $12
	db $ff, $e0, $00, $14
WaveSfx19_Wave:
	db $80, $00, $40, $30, $87, $01

;@ def WaveSfx1A_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1A (bank $06). Loads wave pattern SfxWave3; some running effects keep their
;@ channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
WaveSfx1A_Start::
;> if wActiveWaveSfx == 0x03: return IgnoreWaveSfx()
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
;> if wActiveWaveSfx == 0x06: return IgnoreWaveSfx()
	cp $06
	jp z, IgnoreWaveSfx
;> if wActiveWaveSfx == 0x07: return IgnoreWaveSfx()
	cp $07
	jp z, IgnoreWaveSfx
;> LoadSfxWave3()
	call LoadSfxWave3
;> return StartWaveSfx(WaveSfx1A_Wave, timer)
	ld hl, WaveSfx1A_Wave
	jp StartWaveSfx

;@ def WaveSfx1A_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1A on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1A_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 4: return EndWaveSfx()
	cp $04
	jp z, EndWaveSfx
;> record = mem16[WaveSfx1A_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx1A_WaveTable
	call GetSfxTableEntry
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $1A, read by WaveSfx1A_Start / WaveSfx1A_Update.
;@ WaveSfx1A_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx1A_Wave, WaveSfx1A_Wave_2, WaveSfx1A_Wave_3: wave channel register records, 6 bytes each: NR30 on
;@ ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx1A_Data::
WaveSfx1A_WaveTable:
	dw WaveSfx1A_Wave_2, WaveSfx1A_Wave_3, WaveSfx1A_Wave_2
WaveSfx1A_Wave:
	db $80, $fd, $40, $20, $c0, $02
WaveSfx1A_Wave_2:
	db $80, $fd, $40, $80, $c1, $02
WaveSfx1A_Wave_3:
	db $80, $fd, $40, $00, $c2, $02

;@ def WaveSfx1B_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1B (bank $14). It locks its channel, so that other effects of the channel are
;@ ignored until it ends; loads wave pattern SfxWave1.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1B_Start::
;> LoadSfxWave1()
	call LoadSfxWave1
;> return StartLockedWaveSfx(WaveSfx1B_Wave, timer)
	ld hl, WaveSfx1B_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx1B_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1B on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1B_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 8: return EndWaveSfx()
	cp $08
	jp z, EndWaveSfx
;> record = mem16[WaveSfx1B_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx1B_WaveTable
	call GetSfxTableEntry
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $1B, read by WaveSfx1B_Start / WaveSfx1B_Update.
;@ WaveSfx1B_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx1B_Wave, WaveSfx1B_Wave_2, WaveSfx1B_Wave_3, WaveSfx1B_Wave_4, WaveSfx1B_Wave_5, WaveSfx1B_Wave_6,
;@ WaveSfx1B_Wave_7, WaveSfx1B_Wave_8: wave channel register records, 6 bytes each: NR30 on ($80) / off,
;@ NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the
;@ next step.
WaveSfx1B_Data::
WaveSfx1B_WaveTable:
	dw WaveSfx1B_Wave_5, WaveSfx1B_Wave_2, WaveSfx1B_Wave_6, WaveSfx1B_Wave_3, WaveSfx1B_Wave_7, WaveSfx1B_Wave_4, WaveSfx1B_Wave_8
WaveSfx1B_Wave:
	db $80, $ea, $20, $62, $c7, $06
WaveSfx1B_Wave_2:
	db $80, $ea, $20, $74, $c7, $06
WaveSfx1B_Wave_3:
	db $80, $ea, $20, $7b, $c7, $06
WaveSfx1B_Wave_4:
	db $80, $ea, $20, $a7, $c7, $06
WaveSfx1B_Wave_5:
	db $80, $ea, $60, $62, $c7, $06
WaveSfx1B_Wave_6:
	db $80, $ea, $60, $74, $c7, $06
WaveSfx1B_Wave_7:
	db $80, $ea, $60, $7b, $c7, $06
WaveSfx1B_Wave_8:
	db $80, $ea, $60, $a7, $c7, $06

;@ def WaveSfx1C_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1C (Smasher fetches its ball). Loads wave pattern SfxWave1; its steps run 4
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1C_Start::
;> wWaveSfxRepeat = 4
	ld a, $04
	ld [wWaveSfxRepeat], a
;> LoadSfxWave1()
	call LoadSfxWave1
;> SaveWaveFreq(WaveSfx1C_Wave)
	ld hl, WaveSfx1C_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx1C_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx1C_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1C on, a step every frame. The frequency slides by a table of steps. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1C_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 7:
	cp $07
	jr z, .case1
.part1
;=@t2
	ld hl, WaveSfx1C_Slide
	jp SlideWave
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0: return SilenceWaveSfx(timer)
	jp z, SilenceWaveSfx
;>     if wWaveSfxRepeat == 2:
	cp $02
	jr z, .case2
;>@t1         record = WaveSfx1C_Wave
;>     else:
;>         record = WaveSfx1C_Wave_2
.part2
	ld hl, WaveSfx1C_Wave_2
;>     wWaveSfxStep = 0
.part3
	xor a
	ld [bc], a
;>     SaveWaveFreq(record)
	call SaveWaveFreq
;>     return WriteWaveRegs(record, timer)
	jp WriteWaveRegs
.case2
;=@t1
	ld hl, WaveSfx1C_Wave
	jr .part3
;>@t2 return SlideWave(WaveSfx1C_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $1C, read by WaveSfx1C_Start / WaveSfx1C_Update.
;@ WaveSfx1C_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx1C_Wave, WaveSfx1C_Wave_2: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31
;@ length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next
;@ step.
WaveSfx1C_Data::
WaveSfx1C_Slide:
	db $00, $06, $00, $04, $00, $02, $ff, $f8, $ff, $f0, $ff, $e8
WaveSfx1C_Wave:
	db $80, $00, $20, $60, $87, $01
WaveSfx1C_Wave_2:
	db $80, $00, $60, $60, $87, $01

;@ def WaveSfx1D_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1D (not requested directly).
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1D_Start::
;> return
	ret

;@ def WaveSfx1D_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1D on, a step every frame.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1D_Update::
;> return
	ret

;@ def WaveSfx1E_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1E (bank $19). Loads wave pattern SfxWave3; its steps run 64 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1E_Start::
;> wWaveSfx1ECount = 0x07
	ld a, $07
	ld [wWaveSfx1ECount], a
;> wWaveSfxRepeat = 64
	ld a, $40
	ld [wWaveSfxRepeat], a
;> LoadSfxWave3()
	call LoadSfxWave3
;> SaveWaveFreq(WaveSfx1E_Wave)
	ld hl, WaveSfx1E_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx1E_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx1E_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1E on, a slide step every frame: 7 rounds of 64 frames (wWaveSfx1ECount), the
;@ first two with their own slide steps.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1E_Update::
;> wWaveSfxRepeat -= 1
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 0:                     # a round is over
	jp z, .round
;>@t2     wWaveSfx1ECount -= 1
;>@t3     if wWaveSfx1ECount == 0: return SilenceWaveSfx(timer)
;>@t4     wWaveSfxRepeat = 64
;> if wWaveSfx1ECount == 7:
.pick
	ld a, [wWaveSfx1ECount]
	cp $07
	jr z, .first
;>@t5     value = 1
;> elif wWaveSfx1ECount == 6:
	cp $06
	jr z, .second
;>@t6     value = 2
;> else:
;>     value = 3
	ld a, $03
;> wWaveSfxStep = value
.setStep
	ld [bc], a
;> return SlideWave(WaveSfx1E_Slide, step)
	ld hl, WaveSfx1E_Slide
	jp SlideWave
.first
;=@t5
	ld a, $01
	jr .setStep
.second
;=@t6
	ld a, $02
	jr .setStep
.round
;=@t2
	push de
	ld de, wWaveSfx1ECount
	call CountDownSfxTimer
	pop de
;=@t3
	jp z, SilenceWaveSfx
;=@t4
	ld a, $40
	ld [wWaveSfxRepeat], a
	jr .pick

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $1E, read by WaveSfx1E_Start / WaveSfx1E_Update.
;@ WaveSfx1E_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx1E_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
;@ WaveSfx1F_WavePattern: wave pattern: 16 bytes = 32 4-bit samples (high nibble first) for wave RAM.
WaveSfx1E_Data::
WaveSfx1E_Slide:
	db $ff, $ff, $ff, $fe, $ff, $fb
WaveSfx1E_Wave:
	db $80, $00, $20, $ff, $87, $01
WaveSfx1F_WavePattern:
	db $06, $c6, $06, $c6, $06, $c6, $06, $c6, $89, $bd, $ed, $b9, $87, $53, $23, $57

;@ def WaveSfx1F_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $1F, Wind Fish waves: the ending: the Wind Fish and the waves (then music
;@ track $59). It locks its channel, so that other effects of the channel are ignored until it ends; loads
;@ wave pattern SfxWave; its steps run 5 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1F_Start::
;> StopAllSound()
	call StopAllSound
;> LoadSfxWave(WaveSfx1F_WavePattern)
	ld hl, WaveSfx1F_WavePattern
	call LoadSfxWave
;> wWaveSfxRepeat = 5
	ld a, $05
	ld [wWaveSfxRepeat], a
;> wWaveSfx1FCount = 0
	xor a
	ld [wWaveSfx1FCount], a
;> SaveWaveFreq(WaveSfx1F_Wave)
	ld hl, WaveSfx1F_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx1F_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx1F_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $1F (Wind Fish waves) on, a slide step every frame, in 17 rounds that get
;@ longer each time (wWaveSfx1FCount); the slide steps change with the round. After the last round music
;@ track $59 is requested and the effect ends.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx1F_Update::
;> wWaveSfxRepeat -= 1
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 1:                     # a round is over
	cp $01
	jr z, .round
;>@t3     wWaveSfx1FCount += 1
;>@t4     if wWaveSfx1FCount == 18:
;>@t5         wMusicTrackToPlay = 0x59
;>@t6         return SilenceWaveSfx(timer)
;>@t7     wWaveSfxRepeat = u8(wWaveSfx1FCount + 5)   # each round a little longer
;>@t8     value = 2 if wWaveSfx1FCount < 11 else 4
;> elif wWaveSfx1FCount == 17:
	ld a, [wWaveSfx1FCount]
	cp $11
	jr z, .s17
;>@t10     value = 5
;> elif wWaveSfx1FCount >= 10:
	cp $0a
	jr nc, .late
;>@t12     value = 3
;> else:
;>     value = 1
	ld a, $01
;> wWaveSfxStep = value
.setStep
	ld bc, wWaveSfxStep
	ld [bc], a
;> return SlideWave(WaveSfx1F_Slide, step)
	ld hl, WaveSfx1F_Slide
	jp SlideWave
.s17
;=@t10
	ld a, $05
	jr .setStep
.late
;=@t12
	ld a, $03
	jr .setStep
.round
;=@t3
	push bc
	ld bc, wWaveSfx1FCount
	call NextSfxStep
	pop bc
;=@t4
	cp $12
	jr z, .over
;=@t7
	add $05
	ld [wWaveSfxRepeat], a
;=@t8
	ld a, [wWaveSfx1FCount]
	cp $0b
	jr nc, .late2
	ld a, $02
	jr .setStep
.late2
;=@t8
	ld a, $04
	jr .setStep
.over
;=@t5
	ld a, $59
	ld [wMusicTrackToPlay], a
;=@t6
	jp SilenceWaveSfx

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $1F (Wind Fish waves), read by WaveSfx1F_Start / WaveSfx1F_Update.
;@ WaveSfx1F_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx1F_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx1F_Data::
WaveSfx1F_Slide:
	db $ff, $f4, $00, $32, $ff, $f0, $00, $70, $ff, $e8
WaveSfx1F_Wave:
	db $80, $00, $40, $a0, $87, $01

;@ def WaveSfx20_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $20 (joins noise effect $34). Loads wave pattern SfxWave3; its steps run 144
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx20_Start::
;> LoadSfxWave3()
	call LoadSfxWave3
;> wWaveSfx20Count = 0x03
	ld a, $03
	ld [wWaveSfx20Count], a
;> wWaveSfxRepeat = 144
	ld a, $90
	ld [wWaveSfxRepeat], a
;> SaveWaveFreq(WaveSfx20_Wave)
	ld hl, WaveSfx20_Wave
	call SaveWaveFreq
;> return StartWaveSfx(WaveSfx20_Wave, timer)
	jp StartWaveSfx

;@ def WaveSfx20_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $20 on, a slide step every frame: 3 rounds of 144 frames (wWaveSfx20Count),
;@ each with its own slide step.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx20_Update::
;> wWaveSfxRepeat -= 1
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 0:                     # a round is over
	jr z, .round
;>@t2     wWaveSfx20Count -= 1
;>@t3     if wWaveSfx20Count == 0: return SilenceWaveSfx(timer)
;>@t4     wWaveSfxRepeat = 144
;> if wWaveSfx20Count == 3:
.pick
	ld a, [wWaveSfx20Count]
	cp $03
	jr z, .first
;>@t5     value = 3
;> elif wWaveSfx20Count == 2:
	cp $02
	jr z, .second
;>@t6     value = 2
;> else:
;>     value = 1
	ld a, $01
;> wWaveSfxStep = value
.setStep
	ld [bc], a
;> return SlideWave(WaveSfx20_Slide, step)
	ld hl, WaveSfx20_Slide
	jp SlideWave
.first
;=@t5
	ld a, $03
	jr .setStep
.second
;=@t6
	ld a, $02
	jr .setStep
.round
;=@t2
	push de
	ld de, wWaveSfx20Count
	call CountDownSfxTimer
	pop de
;=@t3
	jp z, SilenceWaveSfx
;=@t4
	ld a, $90
	ld [wWaveSfxRepeat], a
	jr .pick

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $20, read by WaveSfx20_Start / WaveSfx20_Update.
;@ WaveSfx20_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx20_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx20_Data::
WaveSfx20_Slide:
	db $00, $01, $00, $02, $00, $03
WaveSfx20_Wave:
	db $80, $00, $60, $80, $84, $02

;@ def WaveSfx21_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $21, Nightmare splits: the final Nightmare's gel splits. Its steps run 7
;@ times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx21_Start::
;> wWaveSfxRepeat = 7
	ld a, $07
	ld [wWaveSfxRepeat], a
;> wActiveWaveSfx = wWaveSfxToPlay
	ld a, [wWaveSfxToPlay]
	ld [wActiveWaveSfx], a
;> wWaveSfxLocked = 0x01
	ld a, $01
	ld [wWaveSfxLocked], a
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> wWaveSfxTimer = 0
	xor a
	ld [wWaveSfxTimer], a
;> wWaveSfxStep = wWaveSfxTimer
	ld [wWaveSfxStep], a
;> rNR30 = wWaveSfxStep
	ldh [rNR30], a
;> WriteWaveRegs(WaveSfxSilence, timer)
	ld hl, WaveSfxSilence
	call WriteWaveRegs
;> SaveSquare2Freq(WaveSfx21_Sq2)
	ld hl, WaveSfx21_Sq2
	call SaveSquare2Freq
;> return WriteSquare2Regs(WaveSfx21_Sq2, timer)
	jp WriteSquare2Regs

;@ def WaveSfx21_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $21 (Nightmare splits) on, a step every frame. The frequency slides by a table
;@ of steps.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx21_Update::
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t2
	cp $0a
	jr z, .case2
.part2
;=@t1
	ld hl, WaveSfx21_Slide
	jp SlideSquare2
;>     wWaveSfxRepeat -= 1
.case1
	call CountDownWaveSfxRepeat
;>     if wWaveSfxRepeat == 0:
	jr z, .case3
.part3
;=@t1
	ld a, [bc]
	jr .part2
.case2
;=@t3
	ld a, $01
	ld [bc], a
	jr .part2
;>         wWaveSfxTimer = 0
.case3
	xor a
	ld [wWaveSfxTimer], a
;>         wWaveSfxStep = wWaveSfxTimer
	ld [wWaveSfxStep], a
;>         wActiveWaveSfx = wWaveSfxStep
	ld [wActiveWaveSfx], a
;>         wWaveSfxLocked = wWaveSfxStep
	ld [wWaveSfxLocked], a
;>         wMusicChannel2[0x0F] &= 0x7F
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;>         wMusicChannel2[0x0F] &= 0x7F
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
;>         return
	ret
;>@t1     return SlideSquare2(WaveSfx21_Slide, step)
;>@t2 if wWaveSfxStep == 10:
;>@t3     wWaveSfxStep = 1
;> return SlideSquare2(WaveSfx21_Slide, step)

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $21 (Nightmare splits), read by WaveSfx21_Start / WaveSfx21_Update.
;@ WaveSfx21_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx21_Sq2: square 2 register records, 5 bytes each: NR21 duty and length, NR22 volume envelope, NR23
;@ / NR24 frequency (NR24 bit 7 restarts the sound), then the frames until the next step.
WaveSfx21_Data::
WaveSfx21_Slide:
	db $ff, $ff, $ff, $fe, $ff, $fd, $ff, $fc, $ff, $fa, $ff, $f6, $ff, $f2, $ff, $ee
	db $00, $3a
WaveSfx21_Sq2:
	db $00, $97, $80, $87, $01

;@ def WaveSfx22_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $22 (bank $15). It locks its channel, so that other effects of the channel are
;@ ignored until it ends; loads wave pattern SfxWave3; its steps run 46 times.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx22_Start::
;> wWaveSfxRepeat = 46
	ld a, $2e
	ld [wWaveSfxRepeat], a
;> wWaveSfx22Count = 0
	xor a
	ld [wWaveSfx22Count], a
;> LoadSfxWave3()
	call LoadSfxWave3
;> SaveWaveFreq(WaveSfx22_Wave)
	ld hl, WaveSfx22_Wave
	call SaveWaveFreq
;> return StartLockedWaveSfx(WaveSfx22_Wave, timer)
	jp StartLockedWaveSfx

;@ def WaveSfx22_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $22 on, a slide step every frame: 4 rounds of 46 frames (wWaveSfx22Count), each
;@ with its own slide step.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx22_Update::
;> wWaveSfxRepeat -= 1
	call CountDownWaveSfxRepeat
;> if wWaveSfxRepeat == 0:                     # a round is over
	jr z, .round
;>@t2     wWaveSfx22Count += 1
;>@t3     if wWaveSfx22Count == 4: return SilenceWaveSfx(timer)
;>@t4     wWaveSfxRepeat = 46
;> if wWaveSfx22Count == 1:
.pick
	ld a, [wWaveSfx22Count]
	cp $01
	jr z, .s1
;>@t5     value = 2
;> elif wWaveSfx22Count == 2:
	cp $02
	jr z, .s2
;>@t6     value = 3
;> elif wWaveSfx22Count == 3:
	cp $03
	jr z, .s3
;>@t7     value = 4
;> else:
;>     value = 1
	ld a, $01
;> wWaveSfxStep = value
.setStep
	ld [bc], a
;> return SlideWave(WaveSfx22_Slide, step)
	ld hl, WaveSfx22_Slide
	jp SlideWave
.round
;=@t2
	push bc
	ld bc, wWaveSfx22Count
	call NextSfxStep
	pop bc
;=@t3
	cp $04
	jp z, SilenceWaveSfx
;=@t4
	ld a, $2e
	ld [wWaveSfxRepeat], a
	jr .pick
.s1
;=@t5
	ld a, $02
	jr .setStep
.s2
;=@t6
	ld a, $03
	jr .setStep
.s3
;=@t7
	ld a, $04
	jr .setStep

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $22, read by WaveSfx22_Start / WaveSfx22_Update.
;@ WaveSfx22_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ WaveSfx22_Wave: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfx22_Data::
WaveSfx22_Slide:
	db $00, $08, $00, $06, $00, $04, $00, $02
WaveSfx22_Wave:
	db $80, $00, $40, $30, $84, $01

;@ def WaveSfx23_Start(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Starts wave-channel effect $23, Nightmare form: the final Nightmare changes its form. It locks its
;@ channel, so that other effects of the channel are ignored until it ends; loads wave pattern SfxWave4.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx23_Start::
;> LoadSfxWave4()
	call LoadSfxWave4
;> return StartLockedWaveSfx(WaveSfx23_Wave, timer)
	ld hl, WaveSfx23_Wave
	jp StartLockedWaveSfx

;@ def WaveSfx23_Update(timer: de, step: bc)
;@ path: sound/sfx/wave
;@ Plays wave-channel effect $23 (Nightmare form) on: each time its timer runs out, the next step. At the
;@ end the channel goes back to the music.
;@ test: timer = 0xD392; step = 0xD396; wWaveSfxStep = rand(0, 0x7F)
WaveSfx23_Update::
;> wWaveSfxTimer -= 1
	call CountDownSfxTimer
;> if wWaveSfxTimer: return
	ret nz
;> wWaveSfxStep += 1
	call NextSfxStep
;> if wWaveSfxStep == 13: return SilenceWaveSfx(timer)
	cp $0d
	jp z, SilenceWaveSfx
;> record = mem16[WaveSfx23_WaveTable + 2 * (wWaveSfxStep - 1)]
	ld hl, WaveSfx23_WaveTable
	call GetSfxTableEntry
;> if wWaveSfxStep == 1: return WriteWaveRegs(record, timer)
	ld a, [wWaveSfxStep]
	cp $01
	jp z, WriteWaveRegs
;> if wWaveSfxStep == 2: return WriteWaveRegs(record, timer)
	cp $02
	jp z, WriteWaveRegs
;> if wWaveSfxStep == 7: return WriteWaveRegs(record, timer)
	cp $07
	jp z, WriteWaveRegs
;> if wWaveSfxStep == 10: return WriteWaveRegs(record, timer)
	cp $0a
	jp z, WriteWaveRegs
;> return WriteWaveFreq(record, timer)
	jp WriteWaveFreq

;@ path: sound/sfx/wave
;@ The data of wave-channel effect $23 (Nightmare form), read by WaveSfx23_Start / WaveSfx23_Update.
;@ WaveSfx23_WaveTable: one pointer per step (the first for step 1) to its record (wave channel register
;@ records).
;@ WaveSfx23_Wave, WaveSfx23_Wave_2, WaveSfx23_Wave_3, WaveSfx23_Wave_4, WaveSfx23_Wave_5, WaveSfx23_Wave_6,
;@ WaveSfx23_Wave_7, WaveSfx23_Wave_8, WaveSfx23_Wave_9: wave channel register records, 6 bytes each: NR30
;@ on ($80) / off, NR31 length, NR32 level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the
;@ frames until the next step.
WaveSfx23_Data::
WaveSfx23_WaveTable:
	dw WaveSfx23_Wave_2, WaveSfx23_Wave_3, WaveSfx23_Wave_6, WaveSfx23_Wave_7, WaveSfx23_Wave_8, WaveSfx23_Wave_9, WaveSfx23_Wave_4, WaveSfx23_Wave_8
	dw WaveSfx23_Wave_9, WaveSfx23_Wave_5, WaveSfx23_Wave_8, WaveSfx23_Wave_9
WaveSfx23_Wave:
	db $80, $f2, $60, $df, $87, $02
WaveSfx23_Wave_2:
	db $80, $f2, $40, $df, $87, $02
WaveSfx23_Wave_3:
	db $80, $f2, $20, $df, $87, $03
WaveSfx23_Wave_4:
	db $80, $f2, $40, $a2, $87, $03
WaveSfx23_Wave_5:
	db $80, $f2, $60, $a2, $87, $03
WaveSfx23_Wave_6:
	db $be, $87, $03
WaveSfx23_Wave_7:
	db $a2, $87, $03
WaveSfx23_Wave_8:
	db $83, $87, $03
WaveSfx23_Wave_9:
	db $a7, $c7, $03

;@ def StartLockedWaveSfx(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Starts the requested wave-channel effect like StartWaveSfx and locks the channel: other requests (except
;@ effect $14) are ignored until it ends.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD392
StartLockedWaveSfx::
;> wWaveSfxLocked = 1
	ld a, $01
	ld [wWaveSfxLocked], a
;> return StartWaveSfx(record, timer)         # falls through

;@ def StartWaveSfx(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ The common start of a wave-channel effect: wActiveWaveSfx = the request, timer and step cleared, the wave
;@ channel taken from the music and switched off, then the first record goes to NR30-NR34 and its frame
;@ count into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD392
StartWaveSfx::
;> wActiveWaveSfx = wWaveSfxToPlay
	ld a, [wWaveSfxToPlay]
	ld [wActiveWaveSfx], a
;> wMusicChannel3[0x0F] |= 0x80               # the music leaves the wave channel alone
	push hl
	ld hl, wMusicChannel3 + $0F
	set 7, [hl]
	pop hl
;> wWaveSfxTimer = 0
	xor a
	ld [wWaveSfxTimer], a
;> wWaveSfxStep = 0
	ld [wWaveSfxStep], a
;> rNR30 = 0
	ldh [rNR30], a
;> return WriteWaveRegs(record, timer)
	jp WriteWaveRegs

;@ path: unused
;@ 22 bytes nothing uses, between StartWaveSfx and SilenceWaveSfx: they look like a wave register record (6
;@ bytes) and a 16-byte wave pattern.
Unused_1F_6311::
	db $80, $00, $00, $00, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00
	db $00, $00, $ff, $ff, $ff, $ff

;@ def SilenceWaveSfx(timer: de)
;@ path: sound/sfx/engine
;@ Ends the wave-channel effect after silencing the channel (WaveSfxSilence).
;@ test: timer = 0xD392
SilenceWaveSfx::
;> WriteWaveRegs(WaveSfxSilence, timer)
	ld hl, WaveSfxSilence
	call WriteWaveRegs
;> return EndWaveSfx()                        # falls through

;@ def EndWaveSfx()
;@ path: sound/sfx/engine
;@ Ends the wave-channel effect: state cleared, channel off, lock released, the channel given back to the
;@ music, which reloads its own wave pattern at its next note (wWaveRamDirty).
EndWaveSfx::
;> wWaveSfxTimer = 0
	xor a
	ld [wWaveSfxTimer], a
;> wWaveSfxStep = 0
	ld [wWaveSfxStep], a
;> wActiveWaveSfx = 0
	ld [wActiveWaveSfx], a
;> rNR30 = 0
	ldh [rNR30], a
;> wWaveSfxLocked = 0
	ld [wWaveSfxLocked], a
;> wMusicChannel3[0x0F] &= 0x7F
	ld hl, wMusicChannel3 + $0F
	res 7, [hl]
;> wWaveRamDirty = 1
	ld a, $01
	ld [wWaveRamDirty], a
	ret

;@ def LoadWaveRam(pattern: hl)
;@ path: sound/sfx/engine
;@ Copies a 16-byte wave pattern (32 4-bit samples) into wave RAM, $FF30-$FF3F.
LoadWaveRam::
;>@loop for i in range(16):
	push bc
	ld c, $30
;>     mem[0xFF30 + i] = mem[pattern + i]
.copy
	ld a, [hli]
	ldh [c], a
	inc c
;=@loop
	ld a, c
	cp $40
	jr nz, .copy
	pop bc
	ret

;@ path: sound/sfx/engine
;@ The wave channel record that silences the channel when an effect ends (SilenceWaveSfx).
;@ WaveSfxSilence: wave channel register records, 6 bytes each: NR30 on ($80) / off, NR31 length, NR32
;@ level, NR33 / NR34 frequency (NR34 bit 7 restarts the sound), then the frames until the next step.
WaveSfxSilence::
	db $80, $00, $00, $00, $81, $01

;@ def LoadSfxWave(pattern: hl)
;@ path: sound/sfx/engine
;@ Switches the wave channel off and loads a wave pattern into wave RAM.
LoadSfxWave::
;> rNR30 = 0
	xor a
	ldh [rNR30], a
;> return LoadWaveRam(pattern)
	jp LoadWaveRam

;@ def LoadSfxWave3()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave3.
LoadSfxWave3::
;> return LoadSfxWave(SfxWave3)
	ld hl, SfxWave3
	jr LoadSfxWave

;@ def LoadSfxWave4()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave4.
LoadSfxWave4::
;> return LoadSfxWave(SfxWave4)
	ld hl, SfxWave4
	jr LoadSfxWave

;@ def LoadSfxWave2()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave2.
LoadSfxWave2::
;> return LoadSfxWave(SfxWave2)
	ld hl, SfxWave2
	jr LoadSfxWave

;@ def LoadSfxWave5()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave5.
LoadSfxWave5::
;> return LoadSfxWave(SfxWave5)
	ld hl, SfxWave5
	jr LoadSfxWave

;@ def LoadSfxWave6()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave6.
LoadSfxWave6::
;> return LoadSfxWave(SfxWave6)
	ld hl, SfxWave6
	jr LoadSfxWave

;@ def LoadSfxWave1()
;@ path: sound/sfx/engine
;@ Turns the wave channel off and loads wave pattern SfxWave1.
LoadSfxWave1::
;> return LoadSfxWave(SfxWave1)
	ld hl, SfxWave1
	jr LoadSfxWave

;@ def WriteWaveFreq(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ A note of a wave effect: the record's two bytes go to NR33 / NR34, the third into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD392
WriteWaveFreq::
;> return WriteSoundRegs(record, 2, 0x1D, timer)   # rNR33, rNR34
	ld c, $1d
	ld b, $02
	jp WriteSoundRegs

;@ def IgnoreWaveSfx()
;@ path: sound/sfx/engine
;@ A wave-channel request that may not start: dropped, the playing effect goes on.
;@ test: skip runs the effect routines through their tables
IgnoreWaveSfx::
;> wWaveSfxToPlay = 0
	xor a
	ld [wWaveSfxToPlay], a
;> return UpdateWaveSfx()
	jp UpdateWaveSfx

;@ path: sound/sfx/engine
;@ The wave patterns of the wave-channel effects, loaded by LoadSfxWave1-LoadSfxWave6: 16 bytes each, 32
;@ 4-bit samples (high nibble first) for wave RAM.
SfxWaves::
SfxWave1:
	db $8c, $ef, $fe, $c8, $84, $21, $12, $48, $8c, $ef, $fe, $c8, $84, $21, $12, $48
SfxWave2:
	db $00, $22, $44, $66, $88, $aa, $cc, $cc, $00, $22, $44, $66, $88, $aa, $cc, $cc
SfxWave3:
	db $0f, $0f, $1f, $1f, $2f, $2f, $3f, $3f, $40, $40, $50, $50, $60, $60, $70, $70
SfxWave4:
	db $0c, $0c, $00, $22, $44, $88, $aa, $cc, $ee, $00, $6c, $60, $00, $6c, $60, $00
SfxWave5:
	db $ff, $ff, $ee, $dd, $ee, $dd, $ee, $ff, $ff, $c9, $63, $21, $00, $00, $04, $8c
SfxWave6:
	db $01, $23, $45, $67, $89, $ac, $ee, $ee, $fe, $dc, $ba, $98, $76, $54, $32, $10
;@ path: sound/sfx/engine
;@ The start routines of the noise effects ($01-$3F), then NoiseSfxUpdates, the routines that play them on
;@ (UpdateNoiseSfx).
NoiseSfxStarts::
	dw NoiseSfx01_Start, NoiseSfx02_Start, NoiseSfx03_Start, NoiseSfx04_Start, NoiseSfx05_Start, NoiseSfx06_Start, NoiseSfx07_Start, NoiseSfx08_Start
	dw NoiseSfx09_Start, NoiseSfx0A_Start, NoiseSfx0B_Start, NoiseSfx0C_Start, NoiseSfx0D_Start, NoiseSfx0E_Start, NoiseSfx0F_Start, NoiseSfx10_Start
	dw NoiseSfx11_Start, NoiseSfx12_Start, NoiseSfx13_Start, NoiseSfx14_Start, NoiseSfx15_Start, NoiseSfx16_Start, NoiseSfx17_Start, NoiseSfx18_Start
	dw NoiseSfx19_Start, NoiseSfx1A_Start, NoiseSfx1B_Start, NoiseSfx1C_Start, NoiseSfx1D_Start, NoiseSfx1E_Start, NoiseSfx1F_Start, NoiseSfx20_Start
	dw SilenceNoiseSfx, NoiseSfx22_Start, NoiseSfx23_Start, NoiseSfx24_Start, NoiseSfx25_Start, NoiseSfx26_Start, NoiseSfx27_Start, NoiseSfx28_Start
	dw NoiseSfx29_Start, NoiseSfx2A_Start, NoiseSfx2B_Start, NoiseSfx2C_Start, NoiseSfx2D_Start, NoiseSfx2E_Start, NoiseSfx2F_Start, NoiseSfx30_Start
	dw NoiseSfx31_Start, NoiseSfx32_Start, NoiseSfx33_Start, NoiseSfx34_Start, NoiseSfx35_Start, NoiseSfx36_Start, NoiseSfx37_Start, NoiseSfx38_Start
	dw NoiseSfx39_Start, NoiseSfx3A_Start, NoiseSfx3B_Start, NoiseSfx3C_Start, NoiseSfx3D_Start, NoiseSfx3E_Start, NoiseSfx3F_Start
NoiseSfxUpdates:
	dw NoiseSfx01_Update, NoiseSfx02_Update, NoiseSfx03_Update, NoiseSfx04_Update, NoiseSfx05_Update, NoiseSfx06_Update, NoiseSfx07_Update, NoiseSfx08_Update
	dw NoiseSfx09_Update, NoiseSfx0A_Update, NoiseSfx0B_Update, NoiseSfx0C_Update, NoiseSfx0D_Update, NoiseSfx0E_Update, NoiseSfx0F_Update, NoiseSfx10_Update
	dw NoiseSfx11_Update, NoiseSfx12_Update, NoiseSfx13_Update, NoiseSfx14_Update, NoiseSfx15_Update, NoiseSfx16_Update, NoiseSfx17_Update, NoiseSfx18_Update
	dw NoiseSfx19_Update, NoiseSfx1A_Update, NoiseSfx1B_Update, NoiseSfx1C_Update, NoiseSfx1D_Update, NoiseSfx1E_Update, NoiseSfx1F_Update, NoiseSfx20_Update
	dw SilenceNoiseSfx, NoiseSfx22_Update, NoiseSfx23_Update, NoiseSfx24_Update, NoiseSfx25_Update, NoiseSfx26_Update, NoiseSfx27_Update, NoiseSfx28_Update
	dw NoiseSfx29_Update, NoiseSfx2A_Update, NoiseSfx2B_Update, NoiseSfx2C_Update, NoiseSfx2D_Update, NoiseSfx2E_Update, NoiseSfx2F_Update, NoiseSfx30_Update
	dw NoiseSfx31_Update, NoiseSfx32_Update, NoiseSfx33_Update, NoiseSfx34_Update, NoiseSfx35_Update, NoiseSfx36_Update, NoiseSfx37_Update, NoiseSfx38_Update
	dw NoiseSfx39_Update, NoiseSfx3A_Update, NoiseSfx3B_Update, EndNoiseSfx, NoiseSfx3D_Update, NoiseSfx3E_Update, NoiseSfx3F_Update

;@ def UpdateNoiseSfx()
;@ path: sound/sfx/engine
;@ The noise-channel effects for one frame, like UpdateJingle (no request gets past a locked effect):
;@ routines in NoiseSfxStarts / NoiseSfxUpdates with de = wNoiseSfxTimer, bc = wNoiseSfxStep. When no noise
;@ effect plays and the room has its looping noise (wRoomNoiseLoop), noise effect $1E starts again.
;@ test: skip jumps through a table of routines
UpdateNoiseSfx::
;> request = wNoiseSfxToPlay
	ld hl, wNoiseSfxToPlay
	ld a, [hl]
;> if request:
	and a
	jr z, .playOn
;>     if wNoiseSfxLocked: return IgnoreNoiseSfx()
	ld a, [wNoiseSfxLocked]
	and a
	jp nz, IgnoreNoiseSfx
;>     table, index = NoiseSfxStarts, request
	ld a, [hl]
	ld hl, NoiseSfxStarts
	jr .call
;> elif wActiveNoiseSfx:
.playOn
	inc hl
	ld a, [hl]
	and a
	jr z, .idle
;>     table, index = NoiseSfxUpdates, wActiveNoiseSfx
	ld hl, NoiseSfxUpdates
;> else:
;>@t1     if wRoomNoiseLoop == 0: return
;>@t2     wNoiseSfxToPlay = 0x1E                  # the room's noise starts again
;>@t3     return UpdateNoiseSfx()
;> routine = GetSfxTableEntry(index, table)
.call
	call GetSfxTableEntry
;> raise NotModeled('jp hl: the routine from the table, called with de = addr(wNoiseSfxTimer), bc = addr(wNoiseSfxStep)')
	ld de, wNoiseSfxTimer
	ld bc, wNoiseSfxStep
	jp hl
.idle
;=@t1
	ld a, [wRoomNoiseLoop]
	and a
	ret z
;=@t2
	ld a, $1e
	ld [wNoiseSfxToPlay], a
;=@t3
	jr UpdateNoiseSfx

;@ def NoiseSfx01_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $01, Drum: the music's two-step drum (note $FF).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx01_Start::
;> wActiveNoiseSfx = 0x01
	ld a, $01
	ld [wActiveNoiseSfx], a
;> return WriteNoiseRegs(NoiseSfx01_Noise, timer)
	ld hl, NoiseSfx01_Noise
	jp WriteNoiseRegs

;@ def NoiseSfx01_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $01 (Drum) on, a step every frame.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx01_Update::
;> wActiveNoiseSfx = 0
	xor a
	ld [wActiveNoiseSfx], a
;> return WriteNoiseRegs(NoiseSfx01_Noise_2, timer)
	ld hl, NoiseSfx01_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $01 (Drum), read by NoiseSfx01_Start / NoiseSfx01_Update.
;@ NoiseSfx01_Noise, NoiseSfx01_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx01_Data::
NoiseSfx01_Noise:
	db $3b, $80, $07, $c0, $01
NoiseSfx01_Noise_2:
	db $00, $42, $02, $c0, $04

;@ def NoiseSfx02_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $02 (not requested directly).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx02_Start::
;> return StartNoiseSfx(NoiseSfx02_Noise, timer)
	ld hl, NoiseSfx02_Noise
	jp StartNoiseSfx

;@ def NoiseSfx02_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $02 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx02_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 7: return EndNoiseSfx()
	cp $07
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx02_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx02_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $02, read by NoiseSfx02_Start / NoiseSfx02_Update.
;@ NoiseSfx02_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx02_Noise, NoiseSfx02_Noise_2, NoiseSfx02_Noise_3, NoiseSfx02_Noise_4, NoiseSfx02_Noise_5,
;@ NoiseSfx02_Noise_6, NoiseSfx02_Noise_7: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx02_Data::
NoiseSfx02_NoiseTable:
	dw NoiseSfx02_Noise_2, NoiseSfx02_Noise_3, NoiseSfx02_Noise_4, NoiseSfx02_Noise_5, NoiseSfx02_Noise_6, NoiseSfx02_Noise_7
NoiseSfx02_Noise:
	db $00, $40, $21, $80, $01
NoiseSfx02_Noise_2:
	db $00, $50, $22, $80, $01
NoiseSfx02_Noise_3:
	db $00, $60, $23, $80, $01
NoiseSfx02_Noise_4:
	db $00, $70, $24, $80, $01
NoiseSfx02_Noise_5:
	db $00, $80, $25, $80, $01
NoiseSfx02_Noise_6:
	db $00, $90, $26, $80, $01
NoiseSfx02_Noise_7:
	db $3c, $a0, $27, $c0, $01

;@ def NoiseSfx03_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $03, Sword swing: Link swings the sword.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx03_Start::
;> return StartNoiseSfx(NoiseSfx03_Noise, timer)
	ld hl, NoiseSfx03_Noise
	jp StartNoiseSfx

;@ def NoiseSfx03_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $03 (Sword swing) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx03_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 17: return EndNoiseSfx()
	cp $11
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx03_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx03_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $03 (Sword swing), read by NoiseSfx03_Start / NoiseSfx03_Update.
;@ NoiseSfx03_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx03_Noise, NoiseSfx03_Noise_2, NoiseSfx03_Noise_3, NoiseSfx03_Noise_4, NoiseSfx03_Noise_5,
;@ NoiseSfx03_Noise_6, NoiseSfx03_Noise_7, NoiseSfx03_Noise_8, NoiseSfx03_Noise_9: noise channel register
;@ records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart
;@ (bit 7), then the frames until the next step.
NoiseSfx03_Data::
NoiseSfx03_NoiseTable:
	dw NoiseSfx03_Noise_2, NoiseSfx03_Noise_3, NoiseSfx03_Noise_4, NoiseSfx03_Noise_5, NoiseSfx03_Noise_6, NoiseSfx03_Noise_7, NoiseSfx03_Noise_8, NoiseSfx03_Noise_9
	dw NoiseSfx03_Noise_8, NoiseSfx03_Noise_7, NoiseSfx03_Noise_6, NoiseSfx03_Noise_5, NoiseSfx03_Noise_4, NoiseSfx03_Noise_3, NoiseSfx03_Noise_2, NoiseSfx03_Noise
NoiseSfx03_Noise:
	db $37, $10, $04, $c0, $02
NoiseSfx03_Noise_2:
	db $00, $20, $06, $80, $02
NoiseSfx03_Noise_3:
	db $00, $30, $14, $80, $02
NoiseSfx03_Noise_4:
	db $00, $40, $16, $80, $02
NoiseSfx03_Noise_5:
	db $00, $50, $24, $80, $02
NoiseSfx03_Noise_6:
	db $00, $60, $26, $80, $02
NoiseSfx03_Noise_7:
	db $00, $70, $34, $80, $02
NoiseSfx03_Noise_8:
	db $00, $80, $36, $80, $02
NoiseSfx03_Noise_9:
	db $00, $90, $44, $80, $02

;@ def NoiseSfx04_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $04, Unlock: a door unlocks, a chest opens, the mermaid statue.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx04_Start::
;> return StartNoiseSfx(NoiseSfx04_Noise, timer)
	ld hl, NoiseSfx04_Noise
	jp StartNoiseSfx

;@ def NoiseSfx04_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $04 (Unlock) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx04_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 4: return EndNoiseSfx()
	cp $04
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx04_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx04_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $04 (Unlock), read by NoiseSfx04_Start / NoiseSfx04_Update.
;@ NoiseSfx04_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx04_Noise, NoiseSfx04_Noise_2, NoiseSfx04_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx04_Data::
NoiseSfx04_NoiseTable:
	dw NoiseSfx04_Noise_2, NoiseSfx04_Noise, NoiseSfx04_Noise_3
NoiseSfx04_Noise:
	db $3b, $c0, $3e, $c0, $01
NoiseSfx04_Noise_2:
	db $33, $f0, $6e, $c0, $06
NoiseSfx04_Noise_3:
	db $36, $70, $4e, $c0, $03

;@ def NoiseSfx05_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $05 (bank $06). Some running effects keep their channel (the request is then
;@ ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx05_Start::
;> if wActiveNoiseSfx == 0x02: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x03: return IgnoreNoiseSfx()
	cp $03
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x0C: return IgnoreNoiseSfx()
	cp $0c
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x13: return IgnoreNoiseSfx()
	cp $13
	jp z, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx05_Noise, timer)
	ld hl, NoiseSfx05_Noise
	jp StartNoiseSfx

;@ def NoiseSfx05_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $05 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx05_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 5: return EndNoiseSfx()
	cp $05
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx05_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx05_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $05, read by NoiseSfx05_Start / NoiseSfx05_Update.
;@ NoiseSfx05_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx05_Noise, NoiseSfx05_Noise_2, NoiseSfx05_Noise_3, NoiseSfx05_Noise_4: noise channel register
;@ records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart
;@ (bit 7), then the frames until the next step.
NoiseSfx05_Data::
NoiseSfx05_NoiseTable:
	dw NoiseSfx05_Noise_2, NoiseSfx05_Noise_3, NoiseSfx05_Noise_4, NoiseSfx05_Noise_4
NoiseSfx05_Noise:
	db $30, $49, $60, $c0, $06
NoiseSfx05_Noise_2:
	db $30, $49, $40, $c0, $06
NoiseSfx05_Noise_3:
	db $30, $49, $20, $c0, $06
NoiseSfx05_Noise_4:
	db $30, $49, $00, $c0, $06

;@ def NoiseSfx06_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $06, Warp out: a warp starts.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx06_Start::
;> return StartNoiseSfx(NoiseSfx06_Noise, timer)
	ld hl, NoiseSfx06_Noise
	jp StartNoiseSfx

;@ def NoiseSfx06_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $06 (Warp out) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx06_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 4: return EndNoiseSfx()
	cp $04
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx06_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx06_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $06 (Warp out), read by NoiseSfx06_Start / NoiseSfx06_Update.
;@ NoiseSfx06_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx06_Noise, NoiseSfx06_Noise_2, NoiseSfx06_Noise_3, NoiseSfx06_Noise_4: noise channel register
;@ records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart
;@ (bit 7), then the frames until the next step.
NoiseSfx06_Data::
NoiseSfx06_NoiseTable:
	dw NoiseSfx06_Noise_2, NoiseSfx06_Noise_3, NoiseSfx06_Noise_4
NoiseSfx06_Noise:
	db $00, $61, $24, $80, $0c
NoiseSfx06_Noise_2:
	db $00, $51, $25, $80, $0c
NoiseSfx06_Noise_3:
	db $00, $32, $27, $80, $0c
NoiseSfx06_Noise_4:
	db $00, $22, $34, $80, $0c

;@ def NoiseSfx07_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $07, Landing: Link lands from a jump, the boots raise dust. Some running effects keep
;@ their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx07_Start::
;> if wActiveNoiseSfx == 0x05: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	cp $05
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x08: return IgnoreNoiseSfx()
	cp $08
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x0C: return IgnoreNoiseSfx()
	cp $0c
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x10: return IgnoreNoiseSfx()
	cp $10
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x13: return IgnoreNoiseSfx()
	cp $13
	jp z, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx07_Noise, timer)
	ld hl, NoiseSfx07_Noise
	jp StartNoiseSfx

;@ def NoiseSfx07_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $07 (Landing) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx07_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return EndNoiseSfx()
	cp $02
	jp z, EndNoiseSfx
;> return WriteNoiseRegs(NoiseSfx07_Noise_2, timer)
	ld hl, NoiseSfx07_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $07 (Landing), read by NoiseSfx07_Start / NoiseSfx07_Update.
;@ NoiseSfx07_Noise, NoiseSfx07_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx07_Data::
NoiseSfx07_Noise:
	db $3b, $f0, $20, $c0, $02
NoiseSfx07_Noise_2:
	db $39, $40, $20, $c0, $08

;@ def NoiseSfx08_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $08 (banks $04 and $15). Its steps run 3 times; some running effects keep their
;@ channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx08_Start::
;> if wActiveNoiseSfx == 0x0C: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	cp $0c
	jp z, IgnoreNoiseSfx
;> wNoiseSfxRepeat = 3
	ld a, $03
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx08_Noise, timer)
	ld hl, NoiseSfx08_Noise
	jp StartNoiseSfx

;@ def NoiseSfx08_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $08 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx08_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 4:
	cp $04
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx08_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfx()
	jp z, EndNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx08_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $08, read by NoiseSfx08_Start / NoiseSfx08_Update.
;@ NoiseSfx08_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx08_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx08_NoiseFreq, NoiseSfx08_NoiseFreq_2, NoiseSfx08_NoiseFreq_3: noise notes, 3 bytes each: NR43
;@ noise frequency, NR44 restart, then the frames until the next step.
NoiseSfx08_Data::
NoiseSfx08_NoiseFreqTable:
	dw NoiseSfx08_NoiseFreq, NoiseSfx08_NoiseFreq_2, NoiseSfx08_NoiseFreq_3
NoiseSfx08_Noise:
	db $00, $a3, $3c, $80, $03
NoiseSfx08_NoiseFreq:
	db $3d, $00, $03
NoiseSfx08_NoiseFreq_2:
	db $3e, $00, $03
NoiseSfx08_NoiseFreq_3:
	db $3f, $00, $03

;@ def NoiseSfx09_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $09, Shatter: a pot or rock breaks.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx09_Start::
;> return StartNoiseSfx(NoiseSfx09_Noise, timer)
	ld hl, NoiseSfx09_Noise
	jp StartNoiseSfx

;@ def NoiseSfx09_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $09 (Shatter) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx09_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> rNR41 = 0x33
	ld a, $33
	ldh [rNR41], a
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 6: return EndNoiseSfx()
	cp $06
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx09_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx09_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $09 (Shatter), read by NoiseSfx09_Start / NoiseSfx09_Update.
;@ NoiseSfx09_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx09_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx09_NoiseFreq, NoiseSfx09_NoiseFreq_2, NoiseSfx09_NoiseFreq_3, NoiseSfx09_NoiseFreq_4: noise
;@ notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames until the next step.
NoiseSfx09_Data::
NoiseSfx09_NoiseFreqTable:
	dw NoiseSfx09_NoiseFreq, NoiseSfx09_NoiseFreq_2, NoiseSfx09_NoiseFreq_3, NoiseSfx09_NoiseFreq_4, NoiseSfx09_NoiseFreq_4
NoiseSfx09_Noise:
	db $33, $a0, $72, $c0, $04
NoiseSfx09_NoiseFreq:
	db $52, $c0, $04
NoiseSfx09_NoiseFreq_2:
	db $50, $c0, $04
NoiseSfx09_NoiseFreq_3:
	db $30, $c0, $04
NoiseSfx09_NoiseFreq_4:
	db $10, $c0, $04

;@ def NoiseSfx0A_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0A, Arrow: an arrow flies, a boss hops.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0A_Start::
;> return StartNoiseSfx(NoiseSfx0A_Noise, timer)
	ld hl, NoiseSfx0A_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0A_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0A (Arrow) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0A_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 5: return EndNoiseSfx()
	cp $05
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx0A_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx0A_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $0A (Arrow), read by NoiseSfx0A_Start / NoiseSfx0A_Update.
;@ NoiseSfx0A_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx0A_Noise, NoiseSfx0A_Noise_2, NoiseSfx0A_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx0A_Data::
NoiseSfx0A_NoiseTable:
	dw NoiseSfx0A_Noise_2, NoiseSfx0A_Noise_3, NoiseSfx0A_Noise_2, NoiseSfx0A_Noise
NoiseSfx0A_Noise:
	db $37, $40, $47, $c0, $01
NoiseSfx0A_Noise_2:
	db $00, $60, $27, $80, $02
NoiseSfx0A_Noise_3:
	db $00, $a0, $15, $80, $02

;@ def NoiseSfx0B_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0B (bank $18).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0B_Start::
;> return StartNoiseSfx(NoiseSfx0B_Noise, timer)
	ld hl, NoiseSfx0B_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0B_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0B on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0B_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return EndNoiseSfx()
	cp $02
	jp z, EndNoiseSfx
;> return WriteNoiseRegs(NoiseSfx0B_Noise_2, timer)
	ld hl, NoiseSfx0B_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $0B, read by NoiseSfx0B_Start / NoiseSfx0B_Update.
;@ NoiseSfx0B_Noise, NoiseSfx0B_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx0B_Data::
NoiseSfx0B_Noise:
	db $3c, $c0, $18, $c0, $01
NoiseSfx0B_Noise_2:
	db $3c, $60, $18, $c0, $02

;@ def NoiseSfx0C_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0C (not requested directly). Some running effects keep their channel (the request is
;@ then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx0C_Start::
;> if wActiveNoiseSfx == 0x02: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, IgnoreNoiseSfx
;> if wActiveNoiseSfx == 0x03: return IgnoreNoiseSfx()
	cp $03
	jp z, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx0C_Noise, timer)
	ld hl, NoiseSfx0C_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0C_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0C on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0C_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 5: return EndNoiseSfx()
	cp $05
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx0C_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx0C_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $0C, read by NoiseSfx0C_Start / NoiseSfx0C_Update.
;@ NoiseSfx0C_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx0C_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx0C_NoiseFreq, NoiseSfx0C_NoiseFreq_2, NoiseSfx0C_NoiseFreq_3, NoiseSfx0C_NoiseFreq_4: noise
;@ notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames until the next step.
NoiseSfx0C_Data::
NoiseSfx0C_NoiseFreqTable:
	dw NoiseSfx0C_NoiseFreq, NoiseSfx0C_NoiseFreq_2, NoiseSfx0C_NoiseFreq_3, NoiseSfx0C_NoiseFreq_4
NoiseSfx0C_Noise:
	db $00, $c6, $6a, $80, $04
NoiseSfx0C_NoiseFreq:
	db $6b, $00, $05
NoiseSfx0C_NoiseFreq_2:
	db $6c, $00, $06
NoiseSfx0C_NoiseFreq_3:
	db $6d, $00, $07
NoiseSfx0C_NoiseFreq_4:
	db $6e, $00, $38

;@ def NoiseSfx0D_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0D, Fireball: the magic rod fires, Vire shoots fireballs. Its steps run 14 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0D_Start::
;> wNoiseSfxRepeat = 14
	ld a, $0e
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx0D_Noise, timer)
	ld hl, NoiseSfx0D_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0D_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0D (Fireball) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0D_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx0D_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
	jp z, SilenceNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx0D_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $0D (Fireball), read by NoiseSfx0D_Start / NoiseSfx0D_Update.
;@ NoiseSfx0D_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx0D_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx0D_NoiseFreq, NoiseSfx0D_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx0D_Data::
NoiseSfx0D_NoiseFreqTable:
	dw NoiseSfx0D_NoiseFreq, NoiseSfx0D_NoiseFreq_2
NoiseSfx0D_Noise:
	db $00, $67, $0f, $80, $02
NoiseSfx0D_NoiseFreq:
	db $60, $00, $02
NoiseSfx0D_NoiseFreq_2:
	db $0f, $00, $02

;@ def NoiseSfx0E_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0E, Dig: Link digs with the shovel.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0E_Start::
;> return StartNoiseSfx(NoiseSfx0E_Noise, timer)
	ld hl, NoiseSfx0E_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0E_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0E (Dig) on: each time its timer runs out, the next step. At the end the channel goes
;@ back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0E_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3: return EndNoiseSfx()
	cp $03
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx0E_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx0E_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $0E (Dig), read by NoiseSfx0E_Start / NoiseSfx0E_Update.
;@ NoiseSfx0E_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx0E_Noise, NoiseSfx0E_Noise_2, NoiseSfx0E_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx0E_Data::
NoiseSfx0E_NoiseTable:
	dw NoiseSfx0E_Noise_2, NoiseSfx0E_Noise_3
NoiseSfx0E_Noise:
	db $1e, $29, $46, $c0, $10
NoiseSfx0E_Noise_2:
	db $00, $29, $64, $80, $08
NoiseSfx0E_Noise_3:
	db $00, $81, $64, $80, $06

;@ def NoiseSfx0F_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $0F, Waves: the sea. Some running effects keep their channel (the request is then
;@ ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx0F_Start::
;> if wActiveNoiseSfx: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx0F_Noise, timer)
	ld hl, NoiseSfx0F_Noise
	jp StartNoiseSfx

;@ def NoiseSfx0F_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $0F (Waves) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx0F_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3: return EndNoiseSfx()
	cp $03
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx0F_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx0F_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $0F (Waves), read by NoiseSfx0F_Start / NoiseSfx0F_Update.
;@ NoiseSfx0F_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx0F_Noise, NoiseSfx0F_Noise_2, NoiseSfx0F_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx0F_Data::
NoiseSfx0F_NoiseTable:
	dw NoiseSfx0F_Noise_2, NoiseSfx0F_Noise_3
NoiseSfx0F_Noise:
	db $00, $0f, $30, $80, $20
NoiseSfx0F_Noise_2:
	db $00, $60, $03, $80, $30
NoiseSfx0F_Noise_3:
	db $00, $67, $03, $80, $20

;@ def NoiseSfx10_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $10, Shutters close: shutter doors close behind Link. Its steps run 3 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx10_Start::
;> wNoiseSfxRepeat = 3
	ld a, $03
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx10_Noise, timer)
	ld hl, NoiseSfx10_Noise
	jp StartNoiseSfx

;@ def NoiseSfx10_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $10 (Shutters close) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx10_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 6:
	cp $06
	jr z, .case1
.part1
;=@t2
	ld hl, NoiseSfx10_NoiseFreqTable
	call GetSfxTableEntry
;=@t3
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
	jp z, SilenceNoiseSfx
;>     if wNoiseSfxRepeat == 1:
	cp $01
	jr z, .case2
;>@t1         record = NoiseSfx10_Noise_3
;>     else:
;>         record = NoiseSfx10_Noise_2
.part2
	ld hl, NoiseSfx10_Noise_2
;>     wNoiseSfxStep = 1
.part3
	ld a, $01
	ld [bc], a
;>     return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs
.case2
;=@t1
	ld hl, NoiseSfx10_Noise_3
	jr .part3
;>@t2 record = mem16[NoiseSfx10_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t3 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $10 (Shutters close), read by NoiseSfx10_Start / NoiseSfx10_Update.
;@ NoiseSfx10_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx10_Noise, NoiseSfx10_Noise_2, NoiseSfx10_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
;@ NoiseSfx10_NoiseFreq, NoiseSfx10_NoiseFreq_2, NoiseSfx10_NoiseFreq_3, NoiseSfx10_NoiseFreq_4,
;@ NoiseSfx10_NoiseFreq_5: noise notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames
;@ until the next step.
NoiseSfx10_Data::
NoiseSfx10_NoiseFreqTable:
	dw NoiseSfx10_NoiseFreq, NoiseSfx10_NoiseFreq_2, NoiseSfx10_NoiseFreq_3, NoiseSfx10_NoiseFreq_4, NoiseSfx10_NoiseFreq_5
NoiseSfx10_Noise:
	db $00, $e0, $48, $80, $01
NoiseSfx10_NoiseFreq:
	db $4b, $00, $01
NoiseSfx10_NoiseFreq_2:
	db $5e, $00, $01
NoiseSfx10_NoiseFreq_3:
	db $5d, $00, $02
NoiseSfx10_NoiseFreq_4:
	db $6c, $00, $02
NoiseSfx10_NoiseFreq_5:
	db $6f, $00, $02
NoiseSfx10_Noise_2:
	db $00, $70, $4b, $80, $01
NoiseSfx10_Noise_3:
	db $00, $20, $4b, $80, $01

;@ def NoiseSfx11_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $11, Rumble: a block, lever gate or statue slides.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx11_Start::
;> return StartNoiseSfx(NoiseSfx11_Noise, timer)
	ld hl, NoiseSfx11_Noise
	jp StartNoiseSfx

;@ def NoiseSfx11_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $11 (Rumble) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx11_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> return SilenceNoiseSfx(timer)
	jp SilenceNoiseSfx

;@ path: sound/sfx/noise
;@ The data of noise effect $11 (Rumble), read by NoiseSfx11_Start / NoiseSfx11_Update.
;@ NoiseSfx11_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx11_Noise::
	db $00, $f0, $a0, $80, $20

;@ def NoiseSfx12_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $12, Flame: a flame shooter.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx12_Start::
;> return StartNoiseSfx(NoiseSfx12_Noise, timer)
	ld hl, NoiseSfx12_Noise
	jp StartNoiseSfx

;@ def NoiseSfx12_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $12 (Flame) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx12_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 8: return SilenceNoiseSfx(timer)
	cp $08
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx12_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx12_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $12 (Flame), read by NoiseSfx12_Start / NoiseSfx12_Update.
;@ NoiseSfx12_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx12_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx12_NoiseFreq, NoiseSfx12_NoiseFreq_2, NoiseSfx12_NoiseFreq_3, NoiseSfx12_NoiseFreq_4,
;@ NoiseSfx12_NoiseFreq_5: noise notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames
;@ until the next step.
NoiseSfx12_Data::
NoiseSfx12_NoiseFreqTable:
	dw NoiseSfx12_NoiseFreq, NoiseSfx12_NoiseFreq_2, NoiseSfx12_NoiseFreq_3, NoiseSfx12_NoiseFreq_2, NoiseSfx12_NoiseFreq, NoiseSfx12_NoiseFreq_4, NoiseSfx12_NoiseFreq_5
NoiseSfx12_Noise:
	db $00, $69, $b8, $80, $02
NoiseSfx12_NoiseFreq:
	db $a8, $00, $02
NoiseSfx12_NoiseFreq_2:
	db $98, $00, $02
NoiseSfx12_NoiseFreq_3:
	db $88, $00, $02
NoiseSfx12_NoiseFreq_4:
	db $b8, $00, $02
NoiseSfx12_NoiseFreq_5:
	db $c8, $00, $02

;@ def NoiseSfx13_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $13, Explosion: a bomb or an enemy explodes.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx13_Start::
;> return StartNoiseSfx(NoiseSfx13_Noise, timer)
	ld hl, NoiseSfx13_Noise
	jp StartNoiseSfx

;@ def NoiseSfx13_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $13 (Explosion) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx13_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 26: return EndNoiseSfx()
	cp $1a
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx13_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx13_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep >= 17:
	ld a, [wNoiseSfxStep]
	cp $11
	jr nc, .case1
.part1
;=@t1
	jp WriteNoiseRegs
;>     rNR42 = 0x20
.case1
	inc hl
	inc hl
	ld a, $20
	ldh [rNR42], a
;>     return WriteNoiseFreq(record + 2, timer)
	jp WriteNoiseFreq
;>@t1 return WriteNoiseRegs(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $13 (Explosion), read by NoiseSfx13_Start / NoiseSfx13_Update.
;@ NoiseSfx13_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx13_Noise, NoiseSfx13_Noise_2, NoiseSfx13_Noise_3, NoiseSfx13_Noise_4, NoiseSfx13_Noise_5,
;@ NoiseSfx13_Noise_6, NoiseSfx13_Noise_7, NoiseSfx13_Noise_8, NoiseSfx13_Noise_9: noise channel register
;@ records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart
;@ (bit 7), then the frames until the next step.
NoiseSfx13_Data::
NoiseSfx13_NoiseTable:
	dw NoiseSfx13_Noise_2, NoiseSfx13_Noise_3, NoiseSfx13_Noise_4, NoiseSfx13_Noise_5, NoiseSfx13_Noise_6, NoiseSfx13_Noise_7, NoiseSfx13_Noise_8, NoiseSfx13_Noise_9
	dw NoiseSfx13_Noise_8, NoiseSfx13_Noise_7, NoiseSfx13_Noise_6, NoiseSfx13_Noise_5, NoiseSfx13_Noise_4, NoiseSfx13_Noise_3, NoiseSfx13_Noise_2, NoiseSfx13_Noise
	dw NoiseSfx13_Noise_9, NoiseSfx13_Noise_8, NoiseSfx13_Noise_7, NoiseSfx13_Noise_6, NoiseSfx13_Noise_5, NoiseSfx13_Noise_4, NoiseSfx13_Noise_3, NoiseSfx13_Noise_2
	dw NoiseSfx13_Noise
NoiseSfx13_Noise:
	db $37, $20, $25, $c0, $01
NoiseSfx13_Noise_2:
	db $00, $40, $27, $80, $01
NoiseSfx13_Noise_3:
	db $00, $60, $35, $80, $01
NoiseSfx13_Noise_4:
	db $00, $80, $37, $80, $01
NoiseSfx13_Noise_5:
	db $00, $a0, $4d, $80, $02
NoiseSfx13_Noise_6:
	db $00, $b0, $4f, $80, $02
NoiseSfx13_Noise_7:
	db $00, $c0, $5d, $80, $02
NoiseSfx13_Noise_8:
	db $00, $d0, $5f, $80, $02
NoiseSfx13_Noise_9:
	db $00, $e0, $6d, $80, $02

;@ def NoiseSfx14_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $14 (not requested directly).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx14_Start::
;> return StartNoiseSfx(NoiseSfx14_Noise, timer)
	ld hl, NoiseSfx14_Noise
	jp StartNoiseSfx

;@ def NoiseSfx14_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $14 on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx14_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 7: return EndNoiseSfx()
	cp $07
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx14_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx14_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $14, read by NoiseSfx14_Start / NoiseSfx14_Update.
;@ NoiseSfx14_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx14_Noise, NoiseSfx14_Noise_2, NoiseSfx14_Noise_3, NoiseSfx14_Noise_4, NoiseSfx14_Noise_5,
;@ NoiseSfx14_Noise_6, NoiseSfx14_Noise_7: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx14_Data::
NoiseSfx14_NoiseTable:
	dw NoiseSfx14_Noise_2, NoiseSfx14_Noise_3, NoiseSfx14_Noise_4, NoiseSfx14_Noise_5, NoiseSfx14_Noise_6, NoiseSfx14_Noise_7
NoiseSfx14_Noise:
	db $00, $40, $5f, $80, $01
NoiseSfx14_Noise_2:
	db $00, $50, $5d, $80, $01
NoiseSfx14_Noise_3:
	db $00, $60, $4f, $80, $01
NoiseSfx14_Noise_4:
	db $00, $70, $4d, $80, $01
NoiseSfx14_Noise_5:
	db $00, $80, $3f, $80, $01
NoiseSfx14_Noise_6:
	db $00, $90, $3c, $80, $01
NoiseSfx14_Noise_7:
	db $3c, $a0, $2e, $c0, $01

;@ def NoiseSfx15_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $15 (not requested directly).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx15_Start::
;> return StartNoiseSfx(NoiseSfx15_Noise, timer)
	ld hl, NoiseSfx15_Noise
	jp StartNoiseSfx

;@ def NoiseSfx15_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $15 on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx15_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 6: return EndNoiseSfx()
	cp $06
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx15_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx15_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $15, read by NoiseSfx15_Start / NoiseSfx15_Update.
;@ NoiseSfx15_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx15_Noise, NoiseSfx15_Noise_2, NoiseSfx15_Noise_3, NoiseSfx15_Noise_4, NoiseSfx15_Noise_5,
;@ NoiseSfx15_Noise_6: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx15_Data::
NoiseSfx15_NoiseTable:
	dw NoiseSfx15_Noise_2, NoiseSfx15_Noise_3, NoiseSfx15_Noise_4, NoiseSfx15_Noise_5, NoiseSfx15_Noise_6
NoiseSfx15_Noise:
	db $00, $20, $47, $80, $02
NoiseSfx15_Noise_2:
	db $00, $40, $37, $80, $01
NoiseSfx15_Noise_3:
	db $00, $60, $27, $80, $01
NoiseSfx15_Noise_4:
	db $00, $80, $17, $80, $01
NoiseSfx15_Noise_5:
	db $00, $a0, $07, $80, $01
NoiseSfx15_Noise_6:
	db $3c, $c0, $03, $c0, $01

;@ def NoiseSfx16_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $16, Shield: something hits Link's shield. Some running effects keep their channel
;@ (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx16_Start::
;> if wActiveNoiseSfx == 0x03: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	cp $03
	jp z, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx16_Noise, timer)
	ld hl, NoiseSfx16_Noise
	jp StartNoiseSfx

;@ def NoiseSfx16_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $16 (Shield) on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx16_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3: return EndNoiseSfx()
	cp $03
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx16_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx16_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $16 (Shield), read by NoiseSfx16_Start / NoiseSfx16_Update.
;@ NoiseSfx16_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx16_Noise, NoiseSfx16_Noise_2, NoiseSfx16_Noise_3: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx16_Data::
NoiseSfx16_NoiseTable:
	dw NoiseSfx16_Noise_2, NoiseSfx16_Noise_3
NoiseSfx16_Noise:
	db $00, $29, $68, $80, $10
NoiseSfx16_Noise_2:
	db $3c, $c0, $50, $c0, $01
NoiseSfx16_Noise_3:
	db $3c, $c1, $18, $c0, $01

;@ def NoiseSfx17_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $17, Hit: the sword hits something hard, a pickup lands.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx17_Start::
;> return StartNoiseSfx(NoiseSfx17_Noise, timer)
	ld hl, NoiseSfx17_Noise
	jp StartNoiseSfx

;@ def NoiseSfx17_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $17 (Hit) on: each time its timer runs out, the next step. At the end the channel goes
;@ back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx17_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return EndNoiseSfx()
	cp $02
	jp z, EndNoiseSfx
;> return WriteNoiseRegs(NoiseSfx17_Noise_2, timer)
	ld hl, NoiseSfx17_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $17 (Hit), read by NoiseSfx17_Start / NoiseSfx17_Update.
;@ NoiseSfx17_Noise, NoiseSfx17_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx17_Data::
NoiseSfx17_Noise:
	db $00, $f1, $09, $80, $0e
NoiseSfx17_Noise_2:
	db $00, $62, $09, $80, $10

;@ def NoiseSfx18_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $18 (not requested directly).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx18_Start::
;> return StartNoiseSfx(NoiseSfx18_Noise, timer)
	ld hl, NoiseSfx18_Noise
	jp StartNoiseSfx

;@ def NoiseSfx18_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $18 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx18_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 7: return EndNoiseSfx()
	cp $07
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx18_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx18_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $18, read by NoiseSfx18_Start / NoiseSfx18_Update.
;@ NoiseSfx18_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx18_Noise, NoiseSfx18_Noise_2, NoiseSfx18_Noise_3, NoiseSfx18_Noise_4, NoiseSfx18_Noise_5,
;@ NoiseSfx18_Noise_6, NoiseSfx18_Noise_7: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx18_Data::
NoiseSfx18_NoiseTable:
	dw NoiseSfx18_Noise_2, NoiseSfx18_Noise_3, NoiseSfx18_Noise_4, NoiseSfx18_Noise_5, NoiseSfx18_Noise_6, NoiseSfx18_Noise_7
NoiseSfx18_Noise:
	db $00, $20, $11, $80, $01
NoiseSfx18_Noise_2:
	db $00, $40, $21, $80, $01
NoiseSfx18_Noise_3:
	db $00, $60, $39, $80, $01
NoiseSfx18_Noise_4:
	db $00, $80, $49, $80, $01
NoiseSfx18_Noise_5:
	db $00, $a0, $4b, $80, $01
NoiseSfx18_Noise_6:
	db $00, $c0, $4d, $80, $01
NoiseSfx18_Noise_7:
	db $3c, $e0, $4f, $c0, $01

;@ def NoiseSfx19_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $19 (bank $01).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx19_Start::
;> return StartNoiseSfx(NoiseSfx19_Noise, timer)
	ld hl, NoiseSfx19_Noise
	jp StartNoiseSfx

;@ def NoiseSfx19_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $19 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx19_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 11: return EndNoiseSfx()
	cp $0b
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx19_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx19_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $19, read by NoiseSfx19_Start / NoiseSfx19_Update.
;@ NoiseSfx19_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx19_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx19_NoiseFreq, NoiseSfx19_NoiseFreq_2, NoiseSfx19_NoiseFreq_3, NoiseSfx19_NoiseFreq_4,
;@ NoiseSfx19_NoiseFreq_5, NoiseSfx19_NoiseFreq_6: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx19_Data::
NoiseSfx19_NoiseFreqTable:
	dw NoiseSfx19_NoiseFreq, NoiseSfx19_NoiseFreq_2, NoiseSfx19_NoiseFreq_3, NoiseSfx19_NoiseFreq_4, NoiseSfx19_NoiseFreq_5, NoiseSfx19_NoiseFreq_4, NoiseSfx19_NoiseFreq_3, NoiseSfx19_NoiseFreq_2
	dw NoiseSfx19_NoiseFreq, NoiseSfx19_NoiseFreq_6
NoiseSfx19_Noise:
	db $00, $67, $2c, $80, $01
NoiseSfx19_NoiseFreq:
	db $3c, $00, $01
NoiseSfx19_NoiseFreq_2:
	db $4c, $00, $01
NoiseSfx19_NoiseFreq_3:
	db $5c, $00, $01
NoiseSfx19_NoiseFreq_4:
	db $6c, $00, $01
NoiseSfx19_NoiseFreq_5:
	db $7c, $00, $01
NoiseSfx19_NoiseFreq_6:
	db $09, $80, $30

;@ def NoiseSfx1A_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1A, Big explosion: a miniboss or boss is defeated. It locks its channel, so that
;@ other effects of the channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1A_Start::
;> return StartLockedNoiseSfx(NoiseSfx1A_Noise, timer)
	ld hl, NoiseSfx1A_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx1A_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1A (Big explosion) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1A_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 22: return EndNoiseSfx()
	cp $16
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx1A_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx1A_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $1A (Big explosion), read by NoiseSfx1A_Start / NoiseSfx1A_Update.
;@ NoiseSfx1A_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx1A_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx1A_NoiseFreq, NoiseSfx1A_NoiseFreq_2, NoiseSfx1A_NoiseFreq_3, NoiseSfx1A_NoiseFreq_4,
;@ NoiseSfx1A_NoiseFreq_5, NoiseSfx1A_NoiseFreq_6, NoiseSfx1A_NoiseFreq_7, NoiseSfx1A_NoiseFreq_8,
;@ NoiseSfx1A_NoiseFreq_9: noise notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames
;@ until the next step.
NoiseSfx1A_Data::
NoiseSfx1A_NoiseFreqTable:
	dw NoiseSfx1A_NoiseFreq, NoiseSfx1A_NoiseFreq_2, NoiseSfx1A_NoiseFreq_3, NoiseSfx1A_NoiseFreq_4, NoiseSfx1A_NoiseFreq_5, NoiseSfx1A_NoiseFreq_4, NoiseSfx1A_NoiseFreq_3, NoiseSfx1A_NoiseFreq_2
	dw NoiseSfx1A_NoiseFreq_3, NoiseSfx1A_NoiseFreq_4, NoiseSfx1A_NoiseFreq_5, NoiseSfx1A_NoiseFreq_6, NoiseSfx1A_NoiseFreq_7, NoiseSfx1A_NoiseFreq_6, NoiseSfx1A_NoiseFreq_5, NoiseSfx1A_NoiseFreq_4
	dw NoiseSfx1A_NoiseFreq_5, NoiseSfx1A_NoiseFreq_6, NoiseSfx1A_NoiseFreq_7, NoiseSfx1A_NoiseFreq_8, NoiseSfx1A_NoiseFreq_9
NoiseSfx1A_Noise:
	db $00, $f7, $3d, $80, $04
NoiseSfx1A_NoiseFreq:
	db $60, $00, $04
NoiseSfx1A_NoiseFreq_2:
	db $61, $00, $04
NoiseSfx1A_NoiseFreq_3:
	db $62, $00, $04
NoiseSfx1A_NoiseFreq_4:
	db $63, $00, $04
NoiseSfx1A_NoiseFreq_5:
	db $64, $00, $04
NoiseSfx1A_NoiseFreq_6:
	db $65, $00, $04
NoiseSfx1A_NoiseFreq_7:
	db $66, $00, $04
NoiseSfx1A_NoiseFreq_8:
	db $67, $00, $04
NoiseSfx1A_NoiseFreq_9:
	db $74, $00, $28

;@ def NoiseSfx1B_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1B, Moldorm crawl: Moldorm crawls (faster with wSfxFastVariant). Some running
;@ effects keep their channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx1B_Start::
;> if wActiveNoiseSfx: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
;> if wSfxFastVariant:
	ld a, [wSfxFastVariant]
	and a
	jr nz, .case1
;>@t1     record = NoiseSfx1B_Noise_5
;> else:
;>     record = NoiseSfx1B_Noise
.part1
	ld hl, NoiseSfx1B_Noise
;> return StartNoiseSfx(record, timer)
.part2
	jp StartNoiseSfx
.case1
;=@t1
	ld hl, NoiseSfx1B_Noise_5
	jr .part2

;@ def NoiseSfx1B_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1B (Moldorm crawl) on: each time its timer runs out the record of the next step (from
;@ NoiseSfx1B_NoiseTable, or NoiseSfx1B_NoiseTable_2 while wSfxFastVariant is set); after 5 steps (2 when
;@ fast) the effect starts over by requesting itself again.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1B_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;>@t4 if wNoiseSfxStep == 6 or (wNoiseSfxStep == 3 and wSfxFastVariant):   # one round over: again
	cp $03
	jr z, .third
	cp $06
	jp z, .again
;>@t5     wNoiseSfxToPlay = 0x1B
;>@t6     wActiveNoiseSfx = 0
;>@t7     return NoiseSfx1B_Start(timer, step)
;> if wSfxFastVariant:
	ld a, [wSfxFastVariant]
	and a
	jr nz, .fast
;>@t9     table = NoiseSfx1B_NoiseTable_2
;> else:
;>     table = NoiseSfx1B_NoiseTable
.normal
	ld hl, NoiseSfx1B_NoiseTable
;> return WriteNoiseRegs(mem16[table + 2 * (wNoiseSfxStep - 1)], timer)
.write
	ld a, [bc]
	call GetSfxTableEntry
	jp WriteNoiseRegs
.fast
;=@t9
	ld hl, NoiseSfx1B_NoiseTable_2
	jr .write
.third
;=@t4
	ld a, [wSfxFastVariant]
	and a
	jp nz, .again
	jr .normal
.again
;=@t5
	ld hl, wNoiseSfxToPlay
	ld a, $1b
	ld [hli], a
;=@t6
	xor a
	ld [hl], a
;=@t7
	jr NoiseSfx1B_Start

;@ path: sound/sfx/noise
;@ The data of noise effect $1B (Moldorm crawl), read by NoiseSfx1B_Start / NoiseSfx1B_Update.
;@ NoiseSfx1B_NoiseTable, NoiseSfx1B_NoiseTable_2: one pointer per step (the first for step 1) to its record
;@ (noise channel register records).
;@ NoiseSfx1B_Noise, NoiseSfx1B_Noise_2, NoiseSfx1B_Noise_3, NoiseSfx1B_Noise_4, NoiseSfx1B_Noise_5,
;@ NoiseSfx1B_Noise_6: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx1B_Data::
NoiseSfx1B_NoiseTable:
	dw NoiseSfx1B_Noise_3, NoiseSfx1B_Noise_2, NoiseSfx1B_Noise_4, NoiseSfx1B_Noise_2, NoiseSfx1B_Noise_4
NoiseSfx1B_NoiseTable_2:
	dw NoiseSfx1B_Noise_6, NoiseSfx1B_Noise_6
NoiseSfx1B_Noise:
	db $37, $61, $30, $80, $03
NoiseSfx1B_Noise_2:
	db $37, $41, $14, $80, $03
NoiseSfx1B_Noise_3:
	db $37, $20, $30, $c0, $02
NoiseSfx1B_Noise_4:
	db $37, $20, $14, $c0, $02
NoiseSfx1B_Noise_5:
	db $37, $a1, $30, $80, $04
NoiseSfx1B_Noise_6:
	db $37, $51, $14, $80, $04

;@ def NoiseSfx1C_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1C (bank $03). Its steps run 6 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1C_Start::
;> wNoiseSfxRepeat = 6
	ld a, $06
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx1C_Noise, timer)
	ld hl, NoiseSfx1C_Noise
	jp StartNoiseSfx

;@ def NoiseSfx1C_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1C on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1C_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx1C_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
	jp z, SilenceNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx1C_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $1C, read by NoiseSfx1C_Start / NoiseSfx1C_Update.
;@ NoiseSfx1C_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx1C_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx1C_NoiseFreq, NoiseSfx1C_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx1C_Data::
NoiseSfx1C_NoiseFreqTable:
	dw NoiseSfx1C_NoiseFreq, NoiseSfx1C_NoiseFreq_2
NoiseSfx1C_Noise:
	db $00, $c0, $58, $80, $02
NoiseSfx1C_NoiseFreq:
	db $68, $80, $02
NoiseSfx1C_NoiseFreq_2:
	db $58, $80, $02

;@ def NoiseSfx1D_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1D (banks $07 and $19). It locks its channel, so that other effects of the channel
;@ are ignored until it ends; its steps run 120 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1D_Start::
;> wNoiseSfxRepeat = 120
	ld a, $78
	ld [wNoiseSfxRepeat], a
;> return StartLockedNoiseSfx(NoiseSfx1D_Noise, timer)
	ld hl, NoiseSfx1D_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx1D_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1D on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1D_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, NoiseSfx1D_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
	jp z, SilenceNoiseSfx
;>     if wNoiseSfxRepeat == 24:
	cp $18
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wNoiseSfxStep = 1
.case2
	ld a, $01
	ld [bc], a
;>         return WriteNoiseRegs(NoiseSfx1D_Noise_2, timer)
	ld hl, NoiseSfx1D_Noise_2
	jp WriteNoiseRegs
;>@t1     wNoiseSfxStep = 1
;>@t2 return WriteNoiseFreq(mem16[NoiseSfx1D_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)], timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $1D, read by NoiseSfx1D_Start / NoiseSfx1D_Update.
;@ NoiseSfx1D_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx1D_Noise, NoiseSfx1D_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
;@ NoiseSfx1D_NoiseFreq, NoiseSfx1D_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx1D_Data::
NoiseSfx1D_NoiseFreqTable:
	dw NoiseSfx1D_NoiseFreq, NoiseSfx1D_NoiseFreq_2
NoiseSfx1D_Noise:
	db $00, $2c, $7c, $80, $02
NoiseSfx1D_Noise_2:
	db $00, $f7, $7c, $80, $02
NoiseSfx1D_NoiseFreq:
	db $7d, $00, $02
NoiseSfx1D_NoiseFreq_2:
	db $7c, $00, $02

;@ def NoiseSfx1E_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1E, Room noise: loops while wRoomNoiseLoop is set. Some running effects keep their
;@ channel (the request is then ignored).
;@ test: skip an ignored request runs the channel's update again, which jumps through a table of routines
NoiseSfx1E_Start::
;> if wActiveNoiseSfx: return IgnoreNoiseSfx()
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
;> return StartNoiseSfx(NoiseSfx1E_Noise, timer)
	ld hl, NoiseSfx1E_Noise
	jp StartNoiseSfx

;@ def NoiseSfx1E_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1E (Room noise) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1E_Update::
;> if wRoomNoiseLoop == 0:
	ld a, [wRoomNoiseLoop]
	and a
	jr z, .case1
;>@t1     WriteNoiseRegs(NoiseSfx1E_Noise_2, timer)
;>@t2     return EndNoiseSfx()
;> wNoiseSfxTimer -= 1
.part1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> return EndNoiseSfx()
	jp EndNoiseSfx
.case1
;=@t1
	ld hl, NoiseSfx1E_Noise_2
	call WriteNoiseRegs
;=@t2
	jp EndNoiseSfx

;@ path: sound/sfx/noise
;@ The data of noise effect $1E (Room noise), read by NoiseSfx1E_Start / NoiseSfx1E_Update.
;@ NoiseSfx1E_Noise, NoiseSfx1E_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx1E_Data::
NoiseSfx1E_Noise:
	db $08, $60, $00, $c0, $0c
NoiseSfx1E_Noise_2:
	db $00, $67, $00, $00, $20

;@ def NoiseSfx1F_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $1F (bank $04). Its steps run 20 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1F_Start::
;> wNoiseSfxRepeat = 20
	ld a, $14
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx1F_Noise, timer)
	ld hl, NoiseSfx1F_Noise
	jp StartNoiseSfx

;@ def NoiseSfx1F_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $1F on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx1F_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t2
	ld hl, NoiseSfx1F_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfx()
	jp z, EndNoiseSfx
;>     if wNoiseSfxRepeat == 14:
	cp $0e
	jr z, .case2
.part2
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1
;>         wNoiseSfxStep = 1
.case2
	ld a, $01
	ld [bc], a
;>         return WriteNoiseRegs(NoiseSfx1F_Noise_2, timer)
	ld hl, NoiseSfx1F_Noise_2
	jp WriteNoiseRegs
;>@t1     wNoiseSfxStep = 1
;>@t2 return WriteNoiseFreq(mem16[NoiseSfx1F_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)], timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $1F, read by NoiseSfx1F_Start / NoiseSfx1F_Update.
;@ NoiseSfx1F_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx1F_Noise, NoiseSfx1F_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
;@ NoiseSfx1F_NoiseFreq, NoiseSfx1F_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx1F_Data::
NoiseSfx1F_NoiseFreqTable:
	dw NoiseSfx1F_NoiseFreq, NoiseSfx1F_NoiseFreq_2
NoiseSfx1F_Noise:
	db $00, $1a, $06, $80, $01
NoiseSfx1F_Noise_2:
	db $00, $64, $06, $80, $01
NoiseSfx1F_NoiseFreq:
	db $06, $00, $01
NoiseSfx1F_NoiseFreq_2:
	db $48, $00, $01

;@ def NoiseSfx20_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $20 (bank $04).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx20_Start::
;> return StartNoiseSfx(NoiseSfx20_Noise, timer)
	ld hl, NoiseSfx20_Noise
	jp StartNoiseSfx

;@ def NoiseSfx20_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $20 on, a step every frame.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx20_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
;>@t1     wNoiseSfxStep = 1
;> record = mem16[NoiseSfx20_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
.part1
	ld hl, NoiseSfx20_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq
.case1
;=@t1
	ld a, $01
	ld [bc], a
	jr .part1

;@ path: sound/sfx/noise
;@ The data of noise effect $20, read by NoiseSfx20_Start / NoiseSfx20_Update.
;@ NoiseSfx20_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx20_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx20_NoiseFreq, NoiseSfx20_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx20_Data::
NoiseSfx20_NoiseFreqTable:
	dw NoiseSfx20_NoiseFreq, NoiseSfx20_NoiseFreq_2
NoiseSfx20_Noise:
	db $00, $50, $0b, $80, $01
NoiseSfx20_NoiseFreq:
	db $0c, $00, $01
NoiseSfx20_NoiseFreq_2:
	db $0b, $00, $01

;@ def NoiseSfx22_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $22, Eagle screech: the Evil Eagle screeches. It locks its channel, so that other
;@ effects of the channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx22_Start::
;> return StartLockedNoiseSfx(NoiseSfx22_Noise, timer)
	ld hl, NoiseSfx22_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx22_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $22 (Eagle screech) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx22_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 5: return EndNoiseSfx()
	cp $05
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx22_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx22_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 1: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $22 (Eagle screech), read by NoiseSfx22_Start / NoiseSfx22_Update.
;@ NoiseSfx22_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx22_Noise, NoiseSfx22_Noise_2, NoiseSfx22_Noise_3, NoiseSfx22_Noise_4, NoiseSfx22_Noise_5: noise
;@ channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind,
;@ NR44 restart (bit 7), then the frames until the next step.
NoiseSfx22_Data::
NoiseSfx22_NoiseTable:
	dw NoiseSfx22_Noise_2, NoiseSfx22_Noise_3, NoiseSfx22_Noise_4, NoiseSfx22_Noise_5
NoiseSfx22_Noise:
	db $00, $0f, $60, $80, $38
NoiseSfx22_Noise_2:
	db $00, $f6, $60, $80, $0c
NoiseSfx22_Noise_3:
	db $61, $00, $0c
NoiseSfx22_Noise_4:
	db $62, $00, $0c
NoiseSfx22_Noise_5:
	db $63, $00, $38

;@ def NoiseSfx23_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $23, Lanmola dive: the Lanmola dives into the sand. It locks its channel, so that
;@ other effects of the channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx23_Start::
;> return StartLockedNoiseSfx(NoiseSfx23_Noise, timer)
	ld hl, NoiseSfx23_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx23_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $23 (Lanmola dive) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx23_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return SilenceNoiseSfx(timer)
	cp $02
	jp z, SilenceNoiseSfx
;> return WriteNoiseRegs(NoiseSfx23_Noise_2, timer)
	ld hl, NoiseSfx23_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $23 (Lanmola dive), read by NoiseSfx23_Start / NoiseSfx23_Update.
;@ NoiseSfx23_Noise, NoiseSfx23_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx23_Data::
NoiseSfx23_Noise:
	db $00, $0f, $a8, $80, $a0
NoiseSfx23_Noise_2:
	db $00, $f7, $a8, $80, $60

;@ def NoiseSfx24_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $24, Walrus splash: the walrus splashes.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx24_Start::
;> return StartNoiseSfx(NoiseSfx24_Noise, timer)
	ld hl, NoiseSfx24_Noise
	jp StartNoiseSfx

;@ def NoiseSfx24_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $24 (Walrus splash) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx24_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return EndNoiseSfx()
	cp $02
	jp z, EndNoiseSfx
;> return WriteNoiseRegs(NoiseSfx24_Noise_2, timer)
	ld hl, NoiseSfx24_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $24 (Walrus splash), read by NoiseSfx24_Start / NoiseSfx24_Update.
;@ NoiseSfx24_Noise, NoiseSfx24_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx24_Data::
NoiseSfx24_Noise:
	db $00, $29, $07, $80, $08
NoiseSfx24_Noise_2:
	db $00, $a7, $05, $80, $50

;@ def NoiseSfx25_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $25 (bank $07). It locks its channel, so that other effects of the channel are
;@ ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx25_Start::
;> return StartLockedNoiseSfx(NoiseSfx25_Noise, timer)
	ld hl, NoiseSfx25_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx25_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $25 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx25_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 36: return SilenceNoiseSfx(timer)
	cp $24
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx25_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx25_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 30: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $1e
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $25, read by NoiseSfx25_Start / NoiseSfx25_Update.
;@ NoiseSfx25_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx25_Noise, NoiseSfx25_Noise_2, NoiseSfx25_Noise_3, NoiseSfx25_Noise_4, NoiseSfx25_Noise_5,
;@ NoiseSfx25_Noise_6, NoiseSfx25_Noise_7, NoiseSfx25_Noise_8, NoiseSfx25_Noise_9, NoiseSfx25_Noise_10,
;@ NoiseSfx25_Noise_11, NoiseSfx25_Noise_12, NoiseSfx25_Noise_13, NoiseSfx25_Noise_14: noise channel
;@ register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44
;@ restart (bit 7), then the frames until the next step.
NoiseSfx25_Data::
NoiseSfx25_NoiseTable:
	dw NoiseSfx25_Noise_4, NoiseSfx25_Noise_5, NoiseSfx25_Noise_6, NoiseSfx25_Noise_5, NoiseSfx25_Noise_4, NoiseSfx25_Noise_3, NoiseSfx25_Noise_4, NoiseSfx25_Noise_5
	dw NoiseSfx25_Noise_6, NoiseSfx25_Noise_5, NoiseSfx25_Noise_4, NoiseSfx25_Noise_3, NoiseSfx25_Noise_4, NoiseSfx25_Noise_6, NoiseSfx25_Noise_7, NoiseSfx25_Noise_6
	dw NoiseSfx25_Noise_4, NoiseSfx25_Noise_3, NoiseSfx25_Noise_4, NoiseSfx25_Noise_6, NoiseSfx25_Noise_7, NoiseSfx25_Noise_6, NoiseSfx25_Noise_4, NoiseSfx25_Noise_2
	dw NoiseSfx25_Noise_4, NoiseSfx25_Noise_5, NoiseSfx25_Noise_6, NoiseSfx25_Noise_7, NoiseSfx25_Noise_8, NoiseSfx25_Noise_9, NoiseSfx25_Noise_10, NoiseSfx25_Noise_11
	dw NoiseSfx25_Noise_12, NoiseSfx25_Noise_13, NoiseSfx25_Noise_14
NoiseSfx25_Noise:
	db $00, $f0, $8c, $80, $5c
NoiseSfx25_Noise_2:
	db $8c, $00, $08
NoiseSfx25_Noise_3:
	db $8c, $00, $0c
NoiseSfx25_Noise_4:
	db $7e, $00, $04
NoiseSfx25_Noise_5:
	db $7c, $00, $04
NoiseSfx25_Noise_6:
	db $6e, $00, $04
NoiseSfx25_Noise_7:
	db $6d, $00, $04
NoiseSfx25_Noise_8:
	db $6c, $00, $04
NoiseSfx25_Noise_9:
	db $00, $f7, $6b, $80, $0c
NoiseSfx25_Noise_10:
	db $6c, $00, $0c
NoiseSfx25_Noise_11:
	db $6d, $00, $0c
NoiseSfx25_Noise_12:
	db $6e, $00, $0c
NoiseSfx25_Noise_13:
	db $7c, $00, $0c
NoiseSfx25_Noise_14:
	db $7e, $00, $34

;@ def NoiseSfx26_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $26 (the Mad Batter, bank $04). Its steps run 64 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx26_Start::
;> wNoiseSfxRepeat = 64
	ld a, $40
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx26_Noise, timer)
	ld hl, NoiseSfx26_Noise
	jp StartNoiseSfx

;@ def NoiseSfx26_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $26 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx26_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx26_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
	jp z, SilenceNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx26_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $26, read by NoiseSfx26_Start / NoiseSfx26_Update.
;@ NoiseSfx26_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx26_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx26_NoiseFreq, NoiseSfx26_NoiseFreq_2: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx26_Data::
NoiseSfx26_NoiseFreqTable:
	dw NoiseSfx26_NoiseFreq, NoiseSfx26_NoiseFreq_2
NoiseSfx26_Noise:
	db $00, $80, $3a, $80, $01
NoiseSfx26_NoiseFreq:
	db $39, $80, $02
NoiseSfx26_NoiseFreq_2:
	db $3a, $80, $01

;@ def NoiseSfx27_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $27 (banks $07 and $15).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx27_Start::
;> return StartNoiseSfx(NoiseSfx27_Noise, timer)
	ld hl, NoiseSfx27_Noise
	jp StartNoiseSfx

;@ def NoiseSfx27_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $27 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx27_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 13: return EndNoiseSfx()
	cp $0d
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx27_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx27_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $27, read by NoiseSfx27_Start / NoiseSfx27_Update.
;@ NoiseSfx27_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx27_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx27_NoiseFreq, NoiseSfx27_NoiseFreq_2, NoiseSfx27_NoiseFreq_3, NoiseSfx27_NoiseFreq_4,
;@ NoiseSfx27_NoiseFreq_5, NoiseSfx27_NoiseFreq_6, NoiseSfx27_NoiseFreq_7, NoiseSfx27_NoiseFreq_8,
;@ NoiseSfx27_NoiseFreq_9, NoiseSfx27_NoiseFreq_10: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx27_Data::
NoiseSfx27_NoiseFreqTable:
	dw NoiseSfx27_NoiseFreq, NoiseSfx27_NoiseFreq_2, NoiseSfx27_NoiseFreq_3, NoiseSfx27_NoiseFreq_2, NoiseSfx27_NoiseFreq, NoiseSfx27_NoiseFreq_4, NoiseSfx27_NoiseFreq_5, NoiseSfx27_NoiseFreq_6
	dw NoiseSfx27_NoiseFreq_7, NoiseSfx27_NoiseFreq_8, NoiseSfx27_NoiseFreq_9, NoiseSfx27_NoiseFreq_10
NoiseSfx27_Noise:
	db $00, $c2, $5d, $80, $01
NoiseSfx27_NoiseFreq:
	db $5c, $00, $01
NoiseSfx27_NoiseFreq_2:
	db $4f, $00, $01
NoiseSfx27_NoiseFreq_3:
	db $4e, $00, $01
NoiseSfx27_NoiseFreq_4:
	db $5d, $00, $01
NoiseSfx27_NoiseFreq_5:
	db $5e, $00, $01
NoiseSfx27_NoiseFreq_6:
	db $5f, $00, $01
NoiseSfx27_NoiseFreq_7:
	db $6c, $00, $01
NoiseSfx27_NoiseFreq_8:
	db $6d, $00, $01
NoiseSfx27_NoiseFreq_9:
	db $6e, $00, $01
NoiseSfx27_NoiseFreq_10:
	db $6f, $00, $10

;@ def NoiseSfx28_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $28, Genie flames: the genie throws flames. Its steps run 5 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx28_Start::
;> wNoiseSfxRepeat = 5
	ld a, $05
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx28_Noise, timer)
	ld hl, NoiseSfx28_Noise
	jp StartNoiseSfx

;@ def NoiseSfx28_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $28 (Genie flames) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx28_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 12:
	cp $0c
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx28_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfx()
	jp z, EndNoiseSfx
;>     wNoiseSfxStep = 4
	ld a, $04
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx28_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $28 (Genie flames), read by NoiseSfx28_Start / NoiseSfx28_Update.
;@ NoiseSfx28_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx28_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx28_NoiseFreq, NoiseSfx28_NoiseFreq_2, NoiseSfx28_NoiseFreq_3, NoiseSfx28_NoiseFreq_4,
;@ NoiseSfx28_NoiseFreq_5: noise notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames
;@ until the next step.
NoiseSfx28_Data::
NoiseSfx28_NoiseFreqTable:
	dw NoiseSfx28_NoiseFreq_2, NoiseSfx28_NoiseFreq_3, NoiseSfx28_NoiseFreq_4, NoiseSfx28_NoiseFreq_5, NoiseSfx28_NoiseFreq_4, NoiseSfx28_NoiseFreq_3, NoiseSfx28_NoiseFreq_2, NoiseSfx28_NoiseFreq
	dw NoiseSfx28_NoiseFreq_2, NoiseSfx28_NoiseFreq_3, NoiseSfx28_NoiseFreq_4
NoiseSfx28_Noise:
	db $00, $67, $6c, $80, $01
NoiseSfx28_NoiseFreq:
	db $6c, $00, $01
NoiseSfx28_NoiseFreq_2:
	db $6b, $00, $01
NoiseSfx28_NoiseFreq_3:
	db $6a, $00, $01
NoiseSfx28_NoiseFreq_4:
	db $69, $00, $01
NoiseSfx28_NoiseFreq_5:
	db $68, $00, $02

;@ def NoiseSfx29_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $29, Crash: a statue shatters, Hot Head's shell breaks, the genie bottle. It locks
;@ its channel, so that other effects of the channel are ignored until it ends; its steps run 5 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx29_Start::
;> wNoiseSfxRepeat = 5
	ld a, $05
	ld [wNoiseSfxRepeat], a
;> return StartLockedNoiseSfx(NoiseSfx29_Noise, timer)
	ld hl, NoiseSfx29_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx29_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $29 (Crash) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx29_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 7:
	cp $07
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx29_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfx()
	jp z, EndNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx29_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $29 (Crash), read by NoiseSfx29_Start / NoiseSfx29_Update.
;@ NoiseSfx29_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx29_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx29_NoiseFreq, NoiseSfx29_NoiseFreq_2, NoiseSfx29_NoiseFreq_3, NoiseSfx29_NoiseFreq_4: noise
;@ notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames until the next step.
NoiseSfx29_Data::
NoiseSfx29_NoiseFreqTable:
	dw NoiseSfx29_NoiseFreq, NoiseSfx29_NoiseFreq_2, NoiseSfx29_NoiseFreq, NoiseSfx29_NoiseFreq_3, NoiseSfx29_NoiseFreq, NoiseSfx29_NoiseFreq_4
NoiseSfx29_Noise:
	db $00, $f4, $68, $80, $02
NoiseSfx29_NoiseFreq:
	db $6f, $00, $02
NoiseSfx29_NoiseFreq_2:
	db $69, $00, $02
NoiseSfx29_NoiseFreq_3:
	db $6a, $00, $02
NoiseSfx29_NoiseFreq_4:
	db $68, $00, $02

;@ def NoiseSfx2A_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2A (not requested directly). It locks its channel, so that other effects of the
;@ channel are ignored until it ends; its steps run 8 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2A_Start::
;> wNoiseSfxRepeat = 8
	ld a, $08
	ld [wNoiseSfxRepeat], a
;> return StartLockedNoiseSfx(NoiseSfx2A_Noise, timer)
	ld hl, NoiseSfx2A_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx2A_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2A on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2A_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 10:
	cp $0a
	jr z, .case1
;>@t1     wNoiseSfxRepeat -= 1
;>@t2     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
;>@t3     wNoiseSfxStep = 2
;> record = mem16[NoiseSfx2A_NoiseTable + 2 * (wNoiseSfxStep - 1)]
.part1
	ld hl, NoiseSfx2A_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 1: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq
.case1
;=@t1
	call CountDownNoiseSfxRepeat
;=@t2
	jp z, SilenceNoiseSfx
;=@t3
	ld a, $02
	ld [bc], a
	jr .part1

;@ path: sound/sfx/noise
;@ The data of noise effect $2A, read by NoiseSfx2A_Start / NoiseSfx2A_Update.
;@ NoiseSfx2A_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx2A_Noise, NoiseSfx2A_Noise_2, NoiseSfx2A_Noise_3, NoiseSfx2A_Noise_4, NoiseSfx2A_Noise_5,
;@ NoiseSfx2A_Noise_6, NoiseSfx2A_Noise_7, NoiseSfx2A_Noise_8, NoiseSfx2A_Noise_9: noise channel register
;@ records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart
;@ (bit 7), then the frames until the next step.
NoiseSfx2A_Data::
NoiseSfx2A_NoiseTable:
	dw NoiseSfx2A_Noise_2, NoiseSfx2A_Noise_3, NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_7, NoiseSfx2A_Noise_9, NoiseSfx2A_Noise_8, NoiseSfx2A_Noise_7, NoiseSfx2A_Noise_6
	dw NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_4
NoiseSfx2A_Noise:
	db $00, $c0, $7f, $80, $88
NoiseSfx2A_Noise_2:
	db $00, $f4, $6d, $80, $01
NoiseSfx2A_Noise_3:
	db $74, $00, $01
NoiseSfx2A_Noise_4:
	db $5f, $00, $01
NoiseSfx2A_Noise_5:
	db $66, $00, $01
NoiseSfx2A_Noise_6:
	db $5d, $00, $01
NoiseSfx2A_Noise_7:
	db $64, $00, $01
NoiseSfx2A_Noise_8:
	db $4f, $00, $01
NoiseSfx2A_Noise_9:
	db $62, $00, $01

;@ def NoiseSfx2B_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2B, Instrument appears: an instrument appears.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2B_Start::
;> return StartNoiseSfx(NoiseSfx2B_Noise, timer)
	ld hl, NoiseSfx2B_Noise
	jp StartNoiseSfx

;@ def NoiseSfx2B_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2B (Instrument appears) on: each time its timer runs out, the next step. At the end
;@ the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2B_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> return EndNoiseSfx()
	jp EndNoiseSfx

;@ path: sound/sfx/noise
;@ The data of noise effect $2B (Instrument appears), read by NoiseSfx2B_Start / NoiseSfx2B_Update.
;@ NoiseSfx2B_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx2B_Noise::
	db $00, $f4, $7d, $80, $40

;@ def NoiseSfx2C_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2C, Instrument flash: an instrument flashes.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2C_Start::
;> return StartNoiseSfx(NoiseSfx2C_Noise, timer)
	ld hl, NoiseSfx2C_Noise
	jp StartNoiseSfx

;@ def NoiseSfx2C_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2C (Instrument flash) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2C_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 20: return SilenceNoiseSfx(timer)
	cp $14
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx2C_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx2C_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 19: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $13
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $2C (Instrument flash), read by NoiseSfx2C_Start / NoiseSfx2C_Update.
;@ NoiseSfx2C_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx2C_Noise, NoiseSfx2C_Noise_2, NoiseSfx2C_Noise_3, NoiseSfx2C_Noise_4, NoiseSfx2C_Noise_5,
;@ NoiseSfx2C_Noise_6, NoiseSfx2C_Noise_7, NoiseSfx2C_Noise_8, NoiseSfx2C_Noise_9, NoiseSfx2C_Noise_10,
;@ NoiseSfx2C_Noise_11, NoiseSfx2C_Noise_12, NoiseSfx2C_Noise_13, NoiseSfx2C_Noise_14, NoiseSfx2C_Noise_15,
;@ NoiseSfx2C_Noise_16, NoiseSfx2C_Noise_17, NoiseSfx2C_Noise_18, NoiseSfx2C_Noise_19, NoiseSfx2C_Noise_20:
;@ noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and
;@ kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx2C_Data::
NoiseSfx2C_NoiseTable:
	dw NoiseSfx2C_Noise_2, NoiseSfx2C_Noise_3, NoiseSfx2C_Noise_4, NoiseSfx2C_Noise_5, NoiseSfx2C_Noise_6, NoiseSfx2C_Noise_7, NoiseSfx2C_Noise_8, NoiseSfx2C_Noise_9
	dw NoiseSfx2C_Noise_10, NoiseSfx2C_Noise_11, NoiseSfx2C_Noise_12, NoiseSfx2C_Noise_13, NoiseSfx2C_Noise_14, NoiseSfx2C_Noise_15, NoiseSfx2C_Noise_16, NoiseSfx2C_Noise_17
	dw NoiseSfx2C_Noise_18, NoiseSfx2C_Noise_19, NoiseSfx2C_Noise_20
NoiseSfx2C_Noise:
	db $26, $40, $37, $80, $06
NoiseSfx2C_Noise_2:
	db $36, $80, $06
NoiseSfx2C_Noise_3:
	db $35, $80, $06
NoiseSfx2C_Noise_4:
	db $34, $80, $06
NoiseSfx2C_Noise_5:
	db $27, $80, $06
NoiseSfx2C_Noise_6:
	db $26, $80, $06
NoiseSfx2C_Noise_7:
	db $25, $80, $06
NoiseSfx2C_Noise_8:
	db $24, $80, $06
NoiseSfx2C_Noise_9:
	db $17, $80, $06
NoiseSfx2C_Noise_10:
	db $16, $80, $06
NoiseSfx2C_Noise_11:
	db $15, $80, $06
NoiseSfx2C_Noise_12:
	db $14, $80, $06
NoiseSfx2C_Noise_13:
	db $07, $80, $06
NoiseSfx2C_Noise_14:
	db $06, $00, $06
NoiseSfx2C_Noise_15:
	db $05, $00, $06
NoiseSfx2C_Noise_16:
	db $04, $00, $06
NoiseSfx2C_Noise_17:
	db $03, $00, $06
NoiseSfx2C_Noise_18:
	db $02, $00, $06
NoiseSfx2C_Noise_19:
	db $01, $00, $06
NoiseSfx2C_Noise_20:
	db $00, $47, $00, $80, $20

;@ def NoiseSfx2D_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2D, Periodic noise: PlayPeriodicNoiseSfx.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2D_Start::
;> return StartNoiseSfx(NoiseSfx2D_Noise, timer)
	ld hl, NoiseSfx2D_Noise
	jp StartNoiseSfx

;@ def NoiseSfx2D_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2D (Periodic noise) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2D_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 8: return EndNoiseSfx()
	cp $08
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx2D_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx2D_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $2D (Periodic noise), read by NoiseSfx2D_Start / NoiseSfx2D_Update.
;@ NoiseSfx2D_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx2D_Noise, NoiseSfx2D_Noise_2, NoiseSfx2D_Noise_3, NoiseSfx2D_Noise_4, NoiseSfx2D_Noise_5,
;@ NoiseSfx2D_Noise_6, NoiseSfx2D_Noise_7: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx2D_Data::
NoiseSfx2D_NoiseTable:
	dw NoiseSfx2D_Noise_2, NoiseSfx2D_Noise_3, NoiseSfx2D_Noise_4, NoiseSfx2D_Noise_5, NoiseSfx2D_Noise_6, NoiseSfx2D_Noise_3, NoiseSfx2D_Noise_7
NoiseSfx2D_Noise:
	db $26, $29, $40, $c0, $04
NoiseSfx2D_Noise_2:
	db $26, $10, $40, $c0, $02
NoiseSfx2D_Noise_3:
	db $26, $29, $10, $c0, $04
NoiseSfx2D_Noise_4:
	db $26, $10, $10, $c0, $02
NoiseSfx2D_Noise_5:
	db $26, $19, $60, $c0, $04
NoiseSfx2D_Noise_6:
	db $26, $10, $60, $c0, $02
NoiseSfx2D_Noise_7:
	db $26, $10, $10, $c0, $03

;@ def NoiseSfx2E_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2E (not requested directly). It locks its channel, so that other effects of the
;@ channel are ignored until it ends; its steps run 8 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2E_Start::
;> wNoiseSfxRepeat = 8
	ld a, $08
	ld [wNoiseSfxRepeat], a
;> return StartLockedNoiseSfx(NoiseSfx2E_Noise, timer)
	ld hl, NoiseSfx2E_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx2E_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2E on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2E_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 12:
	cp $0c
	jr z, .case1
;>@t1     wNoiseSfxRepeat -= 1
;>@t2     if wNoiseSfxRepeat == 0: return SilenceNoiseSfx(timer)
;>@t3     wNoiseSfxStep = 3
;> record = mem16[NoiseSfx2E_NoiseTable + 2 * (wNoiseSfxStep - 1)]
.part1
	ld hl, NoiseSfx2E_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 2: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $02
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq
.case1
;=@t1
	call CountDownNoiseSfxRepeat
;=@t2
	jp z, SilenceNoiseSfx
;=@t3
	ld a, $03
	ld [bc], a
	jr .part1

;@ path: sound/sfx/noise
;@ The data of noise effect $2E, read by NoiseSfx2E_Start / NoiseSfx2E_Update.
;@ NoiseSfx2E_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx2E_Noise, NoiseSfx2E_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx2E_Data::
NoiseSfx2E_NoiseTable:
	dw NoiseSfx2E_Noise_2, NoiseSfx2A_Noise_2, NoiseSfx2A_Noise_3, NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_7, NoiseSfx2A_Noise_9, NoiseSfx2A_Noise_8, NoiseSfx2A_Noise_7
	dw NoiseSfx2A_Noise_6, NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_4
NoiseSfx2E_Noise:
	db $00, $c0, $7f, $80, $ff
NoiseSfx2E_Noise_2:
	db $7f, $80, $34

;@ def NoiseSfx2F_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $2F, Cue Ball: Cue Ball rolls.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2F_Start::
;> return StartNoiseSfx(NoiseSfx2F_Noise, timer)
	ld hl, NoiseSfx2F_Noise
	jp StartNoiseSfx

;@ def NoiseSfx2F_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $2F (Cue Ball) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx2F_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 2: return SilenceNoiseSfx(timer)
	cp $02
	jp z, SilenceNoiseSfx
;> return WriteNoiseRegs(NoiseSfx2F_Noise_2, timer)
	ld hl, NoiseSfx2F_Noise_2
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $2F (Cue Ball), read by NoiseSfx2F_Start / NoiseSfx2F_Update.
;@ NoiseSfx2F_Noise, NoiseSfx2F_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
NoiseSfx2F_Data::
NoiseSfx2F_Noise:
	db $00, $19, $50, $80, $06
NoiseSfx2F_Noise_2:
	db $00, $65, $50, $80, $20

;@ def NoiseSfx30_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $30, Eagle screech 2: the Evil Eagle screeches.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx30_Start::
;> return StartNoiseSfx(NoiseSfx30_Noise, timer)
	ld hl, NoiseSfx30_Noise
	jp StartNoiseSfx

;@ def NoiseSfx30_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $30 (Eagle screech 2) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx30_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 35: return EndNoiseSfx()
	cp $23
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx30_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx30_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $30 (Eagle screech 2), read by NoiseSfx30_Start / NoiseSfx30_Update.
;@ NoiseSfx30_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx30_Noise, NoiseSfx30_Noise_2, NoiseSfx30_Noise_3, NoiseSfx30_Noise_4, NoiseSfx30_Noise_5,
;@ NoiseSfx30_Noise_6, NoiseSfx30_Noise_7, NoiseSfx30_Noise_8, NoiseSfx30_Noise_9, NoiseSfx30_Noise_10:
;@ noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and
;@ kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx30_Data::
NoiseSfx30_NoiseTable:
	dw NoiseSfx30_Noise_2, NoiseSfx30_Noise_9, NoiseSfx30_Noise_3, NoiseSfx30_Noise_9, NoiseSfx30_Noise_4, NoiseSfx30_Noise_9, NoiseSfx30_Noise_5, NoiseSfx30_Noise_9
	dw NoiseSfx30_Noise_5, NoiseSfx30_Noise_9, NoiseSfx30_Noise_6, NoiseSfx30_Noise_10, NoiseSfx30_Noise_7, NoiseSfx30_Noise_10, NoiseSfx30_Noise_8, NoiseSfx30_Noise_10
	dw NoiseSfx30_Noise_7, NoiseSfx30_Noise_10, NoiseSfx30_Noise_6, NoiseSfx30_Noise_10, NoiseSfx30_Noise_7, NoiseSfx30_Noise_10, NoiseSfx30_Noise_8, NoiseSfx30_Noise_10
	dw NoiseSfx30_Noise_7, NoiseSfx30_Noise_10, NoiseSfx30_Noise_6, NoiseSfx30_Noise_10, NoiseSfx30_Noise_7, NoiseSfx30_Noise_10, NoiseSfx30_Noise_8, NoiseSfx30_Noise_10
	dw NoiseSfx30_Noise_7, NoiseSfx30_Noise_10
NoiseSfx30_Noise:
	db $00, $1c, $60, $80, $18
NoiseSfx30_Noise_2:
	db $00, $19, $50, $80, $0a
NoiseSfx30_Noise_3:
	db $00, $19, $30, $80, $09
NoiseSfx30_Noise_4:
	db $00, $19, $40, $80, $07
NoiseSfx30_Noise_5:
	db $00, $19, $50, $80, $06
NoiseSfx30_Noise_6:
	db $00, $19, $60, $80, $06
NoiseSfx30_Noise_7:
	db $00, $19, $60, $80, $04
NoiseSfx30_Noise_8:
	db $00, $19, $50, $80, $02
NoiseSfx30_Noise_9:
	db $37, $40, $20, $c0, $02
NoiseSfx30_Noise_10:
	db $37, $20, $20, $c0, $02

;@ def NoiseSfx31_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $31, Evil Eagle: the Evil Eagle flies, is hurt. It locks its channel, so that other
;@ effects of the channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx31_Start::
;> return StartLockedNoiseSfx(NoiseSfx31_Noise, timer)
	ld hl, NoiseSfx31_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx31_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $31 (Evil Eagle) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx31_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 27: return SilenceNoiseSfx(timer)
	cp $1b
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx31_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx31_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $31 (Evil Eagle), read by NoiseSfx31_Start / NoiseSfx31_Update.
;@ NoiseSfx31_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx31_Noise, NoiseSfx31_Noise_2, NoiseSfx31_Noise_3, NoiseSfx31_Noise_4, NoiseSfx31_Noise_5,
;@ NoiseSfx31_Noise_6, NoiseSfx31_Noise_7, NoiseSfx31_Noise_8: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx31_Data::
NoiseSfx31_NoiseTable:
	dw NoiseSfx31_Noise_2, NoiseSfx30_Noise_9, NoiseSfx31_Noise_3, NoiseSfx30_Noise_9, NoiseSfx31_Noise_4, NoiseSfx30_Noise_9, NoiseSfx31_Noise_5, NoiseSfx30_Noise_9
	dw NoiseSfx31_Noise_5, NoiseSfx30_Noise_9, NoiseSfx31_Noise_6, NoiseSfx30_Noise_10, NoiseSfx31_Noise_7, NoiseSfx30_Noise_10, NoiseSfx31_Noise_8, NoiseSfx30_Noise_10
	dw NoiseSfx31_Noise_7, NoiseSfx30_Noise_10, NoiseSfx31_Noise_6, NoiseSfx30_Noise_10, NoiseSfx31_Noise_7, NoiseSfx30_Noise_10, NoiseSfx31_Noise_8, NoiseSfx30_Noise_10
	dw NoiseSfx31_Noise_7, NoiseSfx30_Noise_10
NoiseSfx31_Noise:
	db $00, $00, $00, $80, $20
NoiseSfx31_Noise_2:
	db $00, $19, $27, $80, $0a
NoiseSfx31_Noise_3:
	db $00, $19, $26, $80, $09
NoiseSfx31_Noise_4:
	db $00, $19, $24, $80, $08
NoiseSfx31_Noise_5:
	db $00, $19, $23, $80, $07
NoiseSfx31_Noise_6:
	db $00, $19, $17, $80, $06
NoiseSfx31_Noise_7:
	db $00, $19, $17, $80, $04
NoiseSfx31_Noise_8:
	db $00, $19, $16, $80, $02

;@ def NoiseSfx32_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $32, Wind: the Evil Eagle blows wind.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx32_Start::
;> return StartNoiseSfx(NoiseSfx32_Noise, timer)
	ld hl, NoiseSfx32_Noise
	jp StartNoiseSfx

;@ def NoiseSfx32_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $32 (Wind) on: each time its timer runs out, the next step. At the end the channel
;@ goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx32_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 11: return EndNoiseSfx()
	cp $0b
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx32_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx32_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $32 (Wind), read by NoiseSfx32_Start / NoiseSfx32_Update.
;@ NoiseSfx32_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx32_Noise, NoiseSfx32_Noise_2, NoiseSfx32_Noise_3, NoiseSfx32_Noise_4, NoiseSfx32_Noise_5,
;@ NoiseSfx32_Noise_6, NoiseSfx32_Noise_7, NoiseSfx32_Noise_8: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx32_Data::
NoiseSfx32_NoiseTable:
	dw NoiseSfx32_Noise_2, NoiseSfx32_Noise_3, NoiseSfx32_Noise_4, NoiseSfx32_Noise_3, NoiseSfx32_Noise_2, NoiseSfx32_Noise, NoiseSfx32_Noise_8, NoiseSfx32_Noise_7
	dw NoiseSfx32_Noise_6, NoiseSfx32_Noise_5
NoiseSfx32_Noise:
	db $00, $20, $30, $80, $02
NoiseSfx32_Noise_2:
	db $00, $40, $40, $80, $03
NoiseSfx32_Noise_3:
	db $00, $80, $50, $80, $04
NoiseSfx32_Noise_4:
	db $00, $c0, $60, $80, $05
NoiseSfx32_Noise_5:
	db $37, $10, $30, $c0, $02
NoiseSfx32_Noise_6:
	db $00, $10, $40, $80, $03
NoiseSfx32_Noise_7:
	db $00, $10, $50, $80, $04
NoiseSfx32_Noise_8:
	db $00, $10, $60, $80, $05

;@ def NoiseSfx33_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $33 (bank $19).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx33_Start::
;> return StartNoiseSfx(NoiseSfx33_Noise, timer)
	ld hl, NoiseSfx33_Noise
	jp StartNoiseSfx

;@ def NoiseSfx33_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $33 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx33_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 12: return SilenceNoiseSfx(timer)
	cp $0c
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx33_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx33_NoiseTable
	call GetSfxTableEntry
;> if wNoiseSfxStep == 6: return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $06
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $33, read by NoiseSfx33_Start / NoiseSfx33_Update.
;@ NoiseSfx33_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx33_Noise, NoiseSfx33_Noise_2, NoiseSfx33_Noise_3, NoiseSfx33_Noise_4, NoiseSfx33_Noise_5,
;@ NoiseSfx33_Noise_6: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx33_Data::
NoiseSfx33_NoiseTable:
	dw NoiseSfx33_Noise_3, NoiseSfx33_Noise_2, NoiseSfx33_Noise_4, NoiseSfx33_Noise_3, NoiseSfx33_Noise_5, NoiseSfx33_Noise_6, NoiseSfx33_Noise_3, NoiseSfx33_Noise_2
	dw NoiseSfx33_Noise_4, NoiseSfx33_Noise_3, NoiseSfx33_Noise_5
NoiseSfx33_Noise:
	db $00, $80, $48, $80, $02
NoiseSfx33_Noise_2:
	db $49, $80, $02
NoiseSfx33_Noise_3:
	db $4a, $80, $02
NoiseSfx33_Noise_4:
	db $4b, $80, $02
NoiseSfx33_Noise_5:
	db $4c, $80, $02
NoiseSfx33_Noise_6:
	db $00, $20, $48, $80, $02

;@ def NoiseSfx34_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $34, Memory pillar: the ending's memories (with wave effect $20).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx34_Start::
;> wNoiseSfx34CountA = 0x2B
	ld a, $2b
	ld [wNoiseSfx34CountA], a
;> wNoiseSfx34CountB = 0x15
	ld a, $15
	ld [wNoiseSfx34CountB], a
;> return StartNoiseSfx(NoiseSfx34_Noise, timer)
	ld hl, NoiseSfx34_Noise
	jp StartNoiseSfx

;@ def NoiseSfx34_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $34 (Memory pillar) on: each time its timer runs out the record of the next step from
;@ NoiseSfx34_NoiseTable (a full register record every 8th step from 26 on, otherwise only the noise
;@ frequency). Steps 1-4 repeat wNoiseSfx34CountA times, steps 18-25 wNoiseSfx34CountB times; at step 13
;@ wave effect $20 joins in; the effect ends at step 82.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx34_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 5:
	cp $05
	jr z, .loopA
;>@t5     wNoiseSfx34CountA -= 1
;>@t6     wNoiseSfxStep = 5 if wNoiseSfx34CountA == 0 else 1
;> elif wNoiseSfxStep == 13:
	cp $0d
	jr z, .wave
;>@t8     wWaveSfxToPlay = 0x20                   # wave effect $20 joins in
;>@t9     UpdateWaveSfx()                         # and starts right away
;> elif wNoiseSfxStep == 26:
	cp $1a
	jr z, .loopB
;>@t12     wNoiseSfx34CountB -= 1
;>@t13     wNoiseSfxStep = 26 if wNoiseSfx34CountB == 0 else 18
;> elif wNoiseSfxStep == 82: return SilenceNoiseSfx(timer)
	cp $52
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx34_NoiseTable + 2 * (wNoiseSfxStep - 1)]
.play
	ld hl, NoiseSfx34_NoiseTable
	call GetSfxTableEntry
;>@t16 if wNoiseSfxStep in (26, 34, 42, 50, 58, 66, 74): return WriteNoiseRegs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $1a
	jp z, WriteNoiseRegs
	cp $22
	jp z, WriteNoiseRegs
;=@t16
	cp $2a
	jp z, WriteNoiseRegs
	cp $32
	jp z, WriteNoiseRegs
	cp $3a
	jp z, WriteNoiseRegs
;=@t16
	cp $42
	jp z, WriteNoiseRegs
	cp $4a
	jp z, WriteNoiseRegs
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq
.loopA
;=@t5
	push de
	ld de, wNoiseSfx34CountA
	call CountDownSfxTimer
	pop de
;=@t6
	jr z, .endA
	ld a, $01
	ld [bc], a
	jr .play
.loopB
;=@t12
	push de
	ld de, wNoiseSfx34CountB
	call CountDownSfxTimer
	pop de
;=@t13
	jr z, .endB
	ld a, $12
	ld [bc], a
	jr .play
.endA
;=@t6
	ld a, $05
	ld [bc], a
	jr .play
.endB
;=@t13
	ld a, $1a
	ld [bc], a
	jr .play
.wave
;=@t8
	ld a, $20
	ld [wWaveSfxToPlay], a
;=@t9
	call UpdateWaveSfx
	ld bc, wNoiseSfxStep
	ld de, wNoiseSfxTimer
	jr .play

;@ path: sound/sfx/noise
;@ The data of noise effect $34 (Memory pillar), read by NoiseSfx34_Start / NoiseSfx34_Update.
;@ NoiseSfx34_NoiseTable: one pointer per step (the first for step 1) to its record; the steps use different
;@ kinds of record, listed below.
;@ NoiseSfx34_Noise, NoiseSfx34_Noise_2, NoiseSfx34_Noise_3, NoiseSfx34_Noise_4, NoiseSfx34_Noise_5,
;@ NoiseSfx34_Noise_6, NoiseSfx34_Noise_7, NoiseSfx34_Noise_8: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
;@ NoiseSfx34_NoiseFreq, NoiseSfx34_NoiseFreq_2, NoiseSfx34_NoiseFreq_3, NoiseSfx34_NoiseFreq_4,
;@ NoiseSfx34_NoiseFreq_5, NoiseSfx34_NoiseFreq_6, NoiseSfx34_NoiseFreq_7, NoiseSfx34_NoiseFreq_8,
;@ NoiseSfx34_NoiseFreq_9, NoiseSfx34_NoiseFreq_10, NoiseSfx34_NoiseFreq_11, NoiseSfx34_NoiseFreq_12,
;@ NoiseSfx34_NoiseFreq_13, NoiseSfx34_NoiseFreq_14, NoiseSfx34_NoiseFreq_15, NoiseSfx34_NoiseFreq_16,
;@ NoiseSfx34_NoiseFreq_17, NoiseSfx34_NoiseFreq_18, NoiseSfx34_NoiseFreq_19, NoiseSfx34_NoiseFreq_20,
;@ NoiseSfx34_NoiseFreq_21, NoiseSfx34_NoiseFreq_22, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24,
;@ NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26: noise notes, 3 bytes each: NR43 noise frequency, NR44
;@ restart, then the frames until the next step.
NoiseSfx34_Data::
NoiseSfx34_NoiseTable:
	dw NoiseSfx34_NoiseFreq, NoiseSfx34_NoiseFreq_2, NoiseSfx34_NoiseFreq_3, NoiseSfx34_NoiseFreq_4, NoiseSfx34_NoiseFreq_5, NoiseSfx34_NoiseFreq_6, NoiseSfx34_NoiseFreq_7, NoiseSfx34_NoiseFreq_8
	dw NoiseSfx34_NoiseFreq_9, NoiseSfx34_NoiseFreq_10, NoiseSfx34_NoiseFreq_11, NoiseSfx34_NoiseFreq_12, NoiseSfx34_NoiseFreq_13, NoiseSfx34_NoiseFreq_14, NoiseSfx34_NoiseFreq_15, NoiseSfx34_NoiseFreq_16
	dw NoiseSfx34_NoiseFreq_17, NoiseSfx34_NoiseFreq_18, NoiseSfx34_NoiseFreq_19, NoiseSfx34_NoiseFreq_20, NoiseSfx34_NoiseFreq_21, NoiseSfx34_NoiseFreq_22, NoiseSfx34_NoiseFreq_21, NoiseSfx34_NoiseFreq_20
	dw NoiseSfx34_NoiseFreq_19, NoiseSfx34_Noise_2, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_3, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_4, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_5, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_6, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_7, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23, NoiseSfx34_Noise_8, NoiseSfx34_NoiseFreq_23, NoiseSfx34_NoiseFreq_24, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_26, NoiseSfx34_NoiseFreq_25, NoiseSfx34_NoiseFreq_24
	dw NoiseSfx34_NoiseFreq_23
NoiseSfx34_Noise:
	db $00, $80, $9c, $80, $01
NoiseSfx34_NoiseFreq:
	db $8e, $00, $01
NoiseSfx34_NoiseFreq_2:
	db $7e, $00, $01
NoiseSfx34_NoiseFreq_3:
	db $8c, $00, $01
NoiseSfx34_NoiseFreq_4:
	db $7c, $00, $01
NoiseSfx34_NoiseFreq_5:
	db $6f, $00, $01
NoiseSfx34_NoiseFreq_6:
	db $6d, $00, $01
NoiseSfx34_NoiseFreq_7:
	db $5f, $00, $01
NoiseSfx34_NoiseFreq_8:
	db $5d, $00, $01
NoiseSfx34_NoiseFreq_9:
	db $4f, $00, $01
NoiseSfx34_NoiseFreq_10:
	db $4d, $00, $01
NoiseSfx34_NoiseFreq_11:
	db $3f, $00, $01
NoiseSfx34_NoiseFreq_12:
	db $3d, $00, $01
NoiseSfx34_NoiseFreq_13:
	db $37, $80, $02
NoiseSfx34_NoiseFreq_14:
	db $35, $80, $02
NoiseSfx34_NoiseFreq_15:
	db $27, $80, $02
NoiseSfx34_NoiseFreq_16:
	db $25, $80, $02
NoiseSfx34_NoiseFreq_17:
	db $17, $80, $02
NoiseSfx34_NoiseFreq_18:
	db $15, $80, $02
NoiseSfx34_NoiseFreq_19:
	db $14, $80, $02
NoiseSfx34_NoiseFreq_20:
	db $07, $80, $02
NoiseSfx34_NoiseFreq_21:
	db $06, $80, $02
NoiseSfx34_NoiseFreq_22:
	db $05, $80, $02
NoiseSfx34_Noise_2:
	db $00, $70, $15, $80, $02
NoiseSfx34_NoiseFreq_23:
	db $14, $80, $02
NoiseSfx34_NoiseFreq_24:
	db $07, $80, $02
NoiseSfx34_NoiseFreq_25:
	db $06, $80, $02
NoiseSfx34_NoiseFreq_26:
	db $05, $80, $02
NoiseSfx34_Noise_3:
	db $00, $60, $15, $80, $02
NoiseSfx34_Noise_4:
	db $00, $50, $15, $80, $02
NoiseSfx34_Noise_5:
	db $00, $40, $15, $80, $02
NoiseSfx34_Noise_6:
	db $00, $30, $15, $80, $02
NoiseSfx34_Noise_7:
	db $00, $20, $15, $80, $02
NoiseSfx34_Noise_8:
	db $00, $10, $15, $80, $02

;@ def NoiseSfx35_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $35 (not requested directly). Its steps run 64 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx35_Start::
;> wNoiseSfxRepeat = 64
	ld a, $40
	ld [wNoiseSfxRepeat], a
;> return StartNoiseSfx(NoiseSfx35_Noise, timer)
	ld hl, NoiseSfx35_Noise
	jp StartNoiseSfx

;@ def NoiseSfx35_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $35 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx35_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 33: return SilenceNoiseSfx(timer)
	cp $21
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx35_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx35_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $35, read by NoiseSfx35_Start / NoiseSfx35_Update.
;@ NoiseSfx35_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx35_Noise, NoiseSfx35_Noise_2, NoiseSfx35_Noise_3, NoiseSfx35_Noise_4, NoiseSfx35_Noise_5,
;@ NoiseSfx35_Noise_6, NoiseSfx35_Noise_7, NoiseSfx35_Noise_8, NoiseSfx35_Noise_9, NoiseSfx35_Noise_10,
;@ NoiseSfx35_Noise_11, NoiseSfx35_Noise_12, NoiseSfx35_Noise_13, NoiseSfx35_Noise_14, NoiseSfx35_Noise_15,
;@ NoiseSfx35_Noise_16, NoiseSfx35_Noise_17, NoiseSfx35_Noise_18, NoiseSfx35_Noise_19, NoiseSfx35_Noise_20,
;@ NoiseSfx35_Noise_21, NoiseSfx35_Noise_22, NoiseSfx35_Noise_23, NoiseSfx35_Noise_24, NoiseSfx35_Noise_25,
;@ NoiseSfx35_Noise_26, NoiseSfx35_Noise_27, NoiseSfx35_Noise_28, NoiseSfx35_Noise_29, NoiseSfx35_Noise_30,
;@ NoiseSfx35_Noise_31, NoiseSfx35_Noise_32, NoiseSfx35_Noise_33: noise channel register records, 5 bytes
;@ each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the
;@ frames until the next step.
NoiseSfx35_Data::
NoiseSfx35_NoiseTable:
	dw NoiseSfx35_Noise_2, NoiseSfx35_Noise_3, NoiseSfx35_Noise_4, NoiseSfx35_Noise_5, NoiseSfx35_Noise_6, NoiseSfx35_Noise_7, NoiseSfx35_Noise_8, NoiseSfx35_Noise_9
	dw NoiseSfx35_Noise_10, NoiseSfx35_Noise_11, NoiseSfx35_Noise_12, NoiseSfx35_Noise_13, NoiseSfx35_Noise_14, NoiseSfx35_Noise_15, NoiseSfx35_Noise_16, NoiseSfx35_Noise_17
	dw NoiseSfx35_Noise_18, NoiseSfx35_Noise_19, NoiseSfx35_Noise_20, NoiseSfx35_Noise_21, NoiseSfx35_Noise_22, NoiseSfx35_Noise_23, NoiseSfx35_Noise_24, NoiseSfx35_Noise_25
	dw NoiseSfx35_Noise_26, NoiseSfx35_Noise_27, NoiseSfx35_Noise_28, NoiseSfx35_Noise_29, NoiseSfx35_Noise_30, NoiseSfx35_Noise_31, NoiseSfx35_Noise_32, NoiseSfx35_Noise_33
NoiseSfx35_Noise:
	db $00, $20, $67, $80, $02
NoiseSfx35_Noise_2:
	db $00, $20, $66, $80, $02
NoiseSfx35_Noise_3:
	db $00, $20, $65, $80, $02
NoiseSfx35_Noise_4:
	db $00, $20, $64, $80, $03
NoiseSfx35_Noise_5:
	db $00, $20, $57, $80, $03
NoiseSfx35_Noise_6:
	db $00, $20, $56, $80, $03
NoiseSfx35_Noise_7:
	db $00, $20, $55, $80, $04
NoiseSfx35_Noise_8:
	db $00, $20, $54, $80, $04
NoiseSfx35_Noise_9:
	db $00, $20, $47, $80, $04
NoiseSfx35_Noise_10:
	db $00, $20, $46, $80, $05
NoiseSfx35_Noise_11:
	db $00, $20, $45, $80, $05
NoiseSfx35_Noise_12:
	db $00, $20, $44, $80, $05
NoiseSfx35_Noise_13:
	db $00, $20, $37, $80, $06
NoiseSfx35_Noise_14:
	db $00, $20, $36, $80, $06
NoiseSfx35_Noise_15:
	db $00, $20, $35, $80, $06
NoiseSfx35_Noise_16:
	db $00, $20, $34, $80, $08
NoiseSfx35_Noise_17:
	db $00, $20, $27, $80, $08
NoiseSfx35_Noise_18:
	db $00, $20, $26, $80, $0a
NoiseSfx35_Noise_19:
	db $00, $20, $25, $80, $0a
NoiseSfx35_Noise_20:
	db $00, $20, $24, $80, $0c
NoiseSfx35_Noise_21:
	db $00, $20, $17, $80, $0c
NoiseSfx35_Noise_22:
	db $00, $20, $16, $80, $0e
NoiseSfx35_Noise_23:
	db $00, $20, $15, $80, $0e
NoiseSfx35_Noise_24:
	db $00, $20, $14, $80, $10
NoiseSfx35_Noise_25:
	db $00, $20, $07, $80, $10
NoiseSfx35_Noise_26:
	db $00, $20, $06, $80, $12
NoiseSfx35_Noise_27:
	db $00, $20, $05, $80, $12
NoiseSfx35_Noise_28:
	db $00, $20, $04, $80, $14
NoiseSfx35_Noise_29:
	db $00, $20, $03, $80, $14
NoiseSfx35_Noise_30:
	db $00, $20, $02, $80, $16
NoiseSfx35_Noise_31:
	db $00, $20, $01, $80, $16
NoiseSfx35_Noise_32:
	db $00, $20, $00, $80, $18
NoiseSfx35_Noise_33:
	db $00, $10, $00, $80, $20

;@ def NoiseSfx36_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $36 (bank $15). It locks its channel, so that other effects of the channel are
;@ ignored until it ends; its steps run 7 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx36_Start::
;> wNoiseSfxRepeat = 7
	ld a, $07
	ld [wNoiseSfxRepeat], a
;> return StartLockedNoiseSfx(NoiseSfx36_Noise, timer)
	ld hl, NoiseSfx36_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx36_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $36 on, a step every frame. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx36_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	ld hl, NoiseSfx36_NoiseFreqTable
	call GetSfxTableEntry
;=@t2
	jp WriteNoiseFreq
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfx()
	jp z, EndNoiseSfx
;>     wNoiseSfxStep = 1
	ld a, $01
	ld [bc], a
	jr .part1
;>@t1 record = mem16[NoiseSfx36_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
;>@t2 return WriteNoiseFreq(record, timer)

;@ path: sound/sfx/noise
;@ The data of noise effect $36, read by NoiseSfx36_Start / NoiseSfx36_Update.
;@ NoiseSfx36_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx36_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx36_NoiseFreq, NoiseSfx36_NoiseFreq_2, NoiseSfx36_NoiseFreq_3, NoiseSfx36_NoiseFreq_4,
;@ NoiseSfx36_NoiseFreq_5: noise notes, 3 bytes each: NR43 noise frequency, NR44 restart, then the frames
;@ until the next step.
NoiseSfx36_Data::
NoiseSfx36_NoiseFreqTable:
	dw NoiseSfx36_NoiseFreq, NoiseSfx36_NoiseFreq_2, NoiseSfx36_NoiseFreq_3, NoiseSfx36_NoiseFreq_4, NoiseSfx36_NoiseFreq_5, NoiseSfx36_NoiseFreq_4, NoiseSfx36_NoiseFreq_3, NoiseSfx36_NoiseFreq_2
NoiseSfx36_Noise:
	db $00, $f4, $0f, $80, $01
NoiseSfx36_NoiseFreq:
	db $0e, $00, $01
NoiseSfx36_NoiseFreq_2:
	db $0d, $00, $01
NoiseSfx36_NoiseFreq_3:
	db $0c, $00, $01
NoiseSfx36_NoiseFreq_4:
	db $0b, $00, $01
NoiseSfx36_NoiseFreq_5:
	db $0a, $00, $01

;@ def NoiseSfx37_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $37, Nightmare bursts: the final Nightmare bursts into pieces (plays on square 2).
;@ Its steps run 7 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx37_Start::
;> wNoiseSfxRepeat = 7
	ld a, $07
	ld [wNoiseSfxRepeat], a
;> StartNoiseSfxOnSquare2(timer)
	call StartNoiseSfxOnSquare2
;> SaveSquare2Freq(WaveSfx21_Sq2)
	ld hl, WaveSfx21_Sq2
	call SaveSquare2Freq
;> return WriteSquare2Regs(WaveSfx21_Sq2, timer)
	jp WriteSquare2Regs

;@ def NoiseSfx37_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $37 (Nightmare bursts) on, a step every frame. The frequency slides by a table of
;@ steps. At the end the channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx37_Update::
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 9:
	cp $09
	jr z, .case1
.part1
;=@t1
	cp $0a
	jr z, .case2
.part2
;=@t2
	ld hl, WaveSfx21_Slide
	jp SlideSquare2
;>     wNoiseSfxRepeat -= 1
.case1
	call CountDownNoiseSfxRepeat
;>     if wNoiseSfxRepeat == 0: return EndNoiseSfxOnSquare2()
	jp z, EndNoiseSfxOnSquare2
;>     value = wNoiseSfxStep
	ld a, [bc]
	jr .part2
;> else:
;>@t1     if wNoiseSfxStep == 10:
;>         wNoiseSfxStep = 1
.case2
	ld a, $01
	ld [bc], a
	jr .part2
;>@t2 return SlideSquare2(WaveSfx21_Slide, step)

;@ def NoiseSfx39_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $39 (bank $15).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx39_Start::
;> return StartNoiseSfx(NoiseSfx39_Noise, timer)
	ld hl, NoiseSfx39_Noise
	jp StartNoiseSfx

;@ def NoiseSfx39_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $39 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx39_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 18: return EndNoiseSfx()
	cp $12
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx39_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx39_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $39, read by NoiseSfx39_Start / NoiseSfx39_Update.
;@ NoiseSfx39_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx39_Noise, NoiseSfx39_Noise_2, NoiseSfx39_Noise_3, NoiseSfx39_Noise_4, NoiseSfx39_Noise_5,
;@ NoiseSfx39_Noise_6, NoiseSfx39_Noise_7, NoiseSfx39_Noise_8, NoiseSfx39_Noise_9, NoiseSfx39_Noise_10,
;@ NoiseSfx39_Noise_11, NoiseSfx39_Noise_12, NoiseSfx39_Noise_13, NoiseSfx39_Noise_14, NoiseSfx39_Noise_15,
;@ NoiseSfx39_Noise_16, NoiseSfx39_Noise_17, NoiseSfx39_Noise_18: noise channel register records, 5 bytes
;@ each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the
;@ frames until the next step.
NoiseSfx39_Data::
NoiseSfx39_NoiseTable:
	dw NoiseSfx39_Noise_2, NoiseSfx39_Noise_3, NoiseSfx39_Noise_4, NoiseSfx39_Noise_5, NoiseSfx39_Noise_6, NoiseSfx39_Noise_7, NoiseSfx39_Noise_8, NoiseSfx39_Noise_9
	dw NoiseSfx39_Noise_10, NoiseSfx39_Noise_11, NoiseSfx39_Noise_12, NoiseSfx39_Noise_13, NoiseSfx39_Noise_14, NoiseSfx39_Noise_15, NoiseSfx39_Noise_16, NoiseSfx39_Noise_17
	dw NoiseSfx39_Noise_18
NoiseSfx39_Noise:
	db $00, $20, $0c, $80, $01
NoiseSfx39_Noise_2:
	db $00, $40, $0d, $80, $01
NoiseSfx39_Noise_3:
	db $00, $60, $0e, $80, $01
NoiseSfx39_Noise_4:
	db $00, $80, $0f, $80, $01
NoiseSfx39_Noise_5:
	db $00, $a0, $1c, $80, $01
NoiseSfx39_Noise_6:
	db $00, $e0, $1d, $80, $01
NoiseSfx39_Noise_7:
	db $00, $c0, $1e, $80, $02
NoiseSfx39_Noise_8:
	db $00, $b0, $1f, $80, $02
NoiseSfx39_Noise_9:
	db $00, $a0, $2c, $80, $02
NoiseSfx39_Noise_10:
	db $00, $90, $2d, $80, $02
NoiseSfx39_Noise_11:
	db $00, $80, $2e, $80, $02
NoiseSfx39_Noise_12:
	db $00, $70, $2f, $80, $02
NoiseSfx39_Noise_13:
	db $00, $60, $3c, $80, $02
NoiseSfx39_Noise_14:
	db $00, $50, $3d, $80, $02
NoiseSfx39_Noise_15:
	db $00, $40, $3e, $80, $02
NoiseSfx39_Noise_16:
	db $00, $30, $3f, $80, $02
NoiseSfx39_Noise_17:
	db $00, $20, $4c, $80, $02
NoiseSfx39_Noise_18:
	db $37, $10, $4d, $c0, $02

;@ def NoiseSfx38_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $38 (bank $15).
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx38_Start::
;> return StartNoiseSfx(NoiseSfx38_Noise, timer)
	ld hl, NoiseSfx38_Noise
	jp StartNoiseSfx

;@ def NoiseSfx38_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $38 on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx38_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 14: return EndNoiseSfx()
	cp $0e
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx38_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx38_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $38, read by NoiseSfx38_Start / NoiseSfx38_Update.
;@ NoiseSfx38_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx38_Noise, NoiseSfx38_Noise_2, NoiseSfx38_Noise_3, NoiseSfx38_Noise_4, NoiseSfx38_Noise_5,
;@ NoiseSfx38_Noise_6, NoiseSfx38_Noise_7, NoiseSfx38_Noise_8, NoiseSfx38_Noise_9, NoiseSfx38_Noise_10,
;@ NoiseSfx38_Noise_11, NoiseSfx38_Noise_12, NoiseSfx38_Noise_13, NoiseSfx38_Noise_14: noise channel
;@ register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44
;@ restart (bit 7), then the frames until the next step.
NoiseSfx38_Data::
NoiseSfx38_NoiseTable:
	dw NoiseSfx38_Noise_2, NoiseSfx38_Noise_3, NoiseSfx38_Noise_4, NoiseSfx38_Noise_5, NoiseSfx38_Noise_6, NoiseSfx38_Noise_7, NoiseSfx38_Noise_8, NoiseSfx38_Noise_9
	dw NoiseSfx38_Noise_10, NoiseSfx38_Noise_11, NoiseSfx38_Noise_12, NoiseSfx38_Noise_13, NoiseSfx38_Noise_14
NoiseSfx38_Noise:
	db $00, $30, $3d, $80, $02
NoiseSfx38_Noise_2:
	db $00, $60, $3f, $80, $02
NoiseSfx38_Noise_3:
	db $00, $90, $3d, $80, $02
NoiseSfx38_Noise_4:
	db $00, $c0, $3f, $80, $02
NoiseSfx38_Noise_5:
	db $00, $f0, $3d, $80, $02
NoiseSfx38_Noise_6:
	db $00, $d0, $3f, $80, $02
NoiseSfx38_Noise_7:
	db $00, $b0, $3d, $80, $02
NoiseSfx38_Noise_8:
	db $00, $90, $3f, $80, $02
NoiseSfx38_Noise_9:
	db $00, $70, $3d, $80, $03
NoiseSfx38_Noise_10:
	db $00, $50, $3f, $80, $03
NoiseSfx38_Noise_11:
	db $00, $40, $3d, $80, $04
NoiseSfx38_Noise_12:
	db $00, $30, $3f, $80, $04
NoiseSfx38_Noise_13:
	db $00, $20, $3d, $80, $04
NoiseSfx38_Noise_14:
	db $2f, $10, $3f, $c0, $04

;@ def NoiseSfx3A_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3A (bank $15). It locks its channel, so that other effects of the channel are
;@ ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3A_Start::
;> wActiveJingle = 0
	xor a
	ld [wActiveJingle], a
;> wMusicChannel1[0x0F] |= 0x80
	ld hl, wMusicChannel1 + $0F
	set 7, [hl]
;> wJingleLocked = 0x01
	ld a, $01
	ld [wJingleLocked], a
;> return StartLockedNoiseSfx(NoiseSfx3A_Noise, timer)
	ld hl, NoiseSfx3A_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx3A_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $3A on: step 1 is a square 1 record, step 2 a noise record (NoiseSfx3A_Sq1Table); at
;@ step 3 square 1 is given back to the music and the effect ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3A_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 3:
	cp $03
	jr z, .done
;>@t1     rNR10 = 0
;>@t2     wJingleLocked = 0
;>@t3     wMusicChannel1[0x0F] &= 0x7F            # square 1 back to the music
;>@t4     return EndNoiseSfx()
;> record = mem16[NoiseSfx3A_Sq1Table + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx3A_Sq1Table
	call GetSfxTableEntry
;> if wNoiseSfxStep == 1: return WriteSquare1Regs(record, timer)
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteSquare1Regs
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs
.done
;=@t1
	xor a
	ldh [rNR10], a
;=@t2
	ld [wJingleLocked], a
;=@t3
	ld hl, wMusicChannel1 + $0F
	res 7, [hl]
;=@t4
	jp EndNoiseSfx

;@ path: sound/sfx/noise
;@ The data of noise effect $3A, read by NoiseSfx3A_Start / NoiseSfx3A_Update.
;@ NoiseSfx3A_Sq1Table: one pointer per step (the first for step 1) to its record; the steps use different
;@ kinds of record, listed below.
;@ NoiseSfx3A_Noise, NoiseSfx3A_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
;@ NoiseSfx3A_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
NoiseSfx3A_Data::
NoiseSfx3A_Sq1Table:
	dw NoiseSfx3A_Sq1, NoiseSfx3A_Noise_2
NoiseSfx3A_Noise:
	db $00, $20, $70, $80, $01
NoiseSfx3A_Sq1:
	db $1d, $51, $82, $59, $c7, $03
NoiseSfx3A_Noise_2:
	db $00, $42, $50, $80, $08

;@ def NoiseSfx3B_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3B, Anti-Kirby inhales: an Anti-Kirby inhales. It locks its channel, so that other
;@ effects of the channel are ignored until it ends; its steps run 240 times.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3B_Start::
;> wActiveJingle = 0
	xor a
	ld [wActiveJingle], a
;> wMusicChannel1[0x0F] |= 0x80
	ld hl, wMusicChannel1 + $0F
	set 7, [hl]
;> wJingleLocked = 0x01
	ld a, $01
	ld [wJingleLocked], a
;> StartLockedNoiseSfx(NoiseSfx3B_Noise, timer)
	ld hl, NoiseSfx3B_Noise
	call StartLockedNoiseSfx
;> wNoiseSfxRepeat = 240
	ld a, $f0
	ld [wNoiseSfxRepeat], a
;> SaveSquare1Freq(NoiseSfx3B_Sq1)
	ld hl, NoiseSfx3B_Sq1
	call SaveSquare1Freq
;> return WriteSquare1Regs(NoiseSfx3B_Sq1, timer)
	jp WriteSquare1Regs

;@ def NoiseSfx3B_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $3B (Anti-Kirby inhales) on while an Anti-Kirby inhales (wAntiKirbyInhaling is set
;@ again every frame): a square 1 slide that changes its steps as wNoiseSfxRepeat counts down, plus a noise
;@ at count $E0. When the inhaling stops or the count runs out, NoiseSfx3C_Start ends it.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3B_Update::
;> if wAntiKirbyInhaling == 0: return NoiseSfx3C_Start(timer, step)
	ld hl, wAntiKirbyInhaling
	ld a, [hl]
	and a
	jr z, NoiseSfx3C_Start
;> wAntiKirbyInhaling = 0
	xor a
	ld [hl], a
;> wNoiseSfxRepeat -= 1
	call CountDownNoiseSfxRepeat
;> if wNoiseSfxRepeat == 0: return NoiseSfx3C_Start(timer, step)
	jr z, NoiseSfx3C_Start
;> if wNoiseSfxRepeat == 0xE0:
	cp $e0
	jr z, .noise
;>@t1     WriteNoiseRegs(NoiseSfx3B_Noise_2, timer)
;>@t2     value = 1
;> elif wNoiseSfxRepeat >= 0xD8:
	cp $d8
	jr nc, .early
;>@t3     value = 1
;> else:
;>     value = 2
	ld a, $02
;> wNoiseSfxStep = value
.setStep
	ld [bc], a
;> return SlideSquare1(NoiseSfx3B_Slide, step)
	ld hl, NoiseSfx3B_Slide
	jp SlideSquare1
.early
;=@t3
	ld a, $01
	jr .setStep
.noise
;=@t1
	ld hl, NoiseSfx3B_Noise_2
	call WriteNoiseRegs
;=@t2
	ld a, $01
	ld bc, wNoiseSfxStep
	jr .setStep

;@ def NoiseSfx3C_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3C, Inhale ends: ends noise effect $3B and gives square 1 back.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3C_Start::
;> wJingleLocked = 0
	xor a
	ld [wJingleLocked], a
;> wMusicChannel1[0x0F] &= 0x7F
	ld hl, wMusicChannel1 + $0F
	res 7, [hl]
;> WriteSquare1Regs(JingleSilence, timer)
	ld hl, JingleSilence
	call WriteSquare1Regs
;> return SilenceNoiseSfx(timer)
	jp SilenceNoiseSfx

;@ path: sound/sfx/noise
;@ The data of noise effect $3B (Anti-Kirby inhales), read by NoiseSfx3B_Start / NoiseSfx3B_Update.
;@ NoiseSfx3B_Slide: frequency slide steps: big-endian 16-bit values, entry n is added to the effect's
;@ frequency at step n and the sum goes to the channel's frequency registers.
;@ NoiseSfx3B_Noise, NoiseSfx3B_Noise_2: noise channel register records, 5 bytes each: NR41 length, NR42
;@ volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next
;@ step.
;@ NoiseSfx3B_Sq1: square 1 register records, 6 bytes each: NR10 sweep, NR11 duty and length, NR12 volume
;@ envelope, NR13 / NR14 frequency (NR14 bit 7 restarts the sound), then the frames until the next step.
NoiseSfx3B_Data::
NoiseSfx3B_Slide:
	db $00, $02, $00, $00
NoiseSfx3B_Noise:
	db $00, $1d, $20, $80, $01
NoiseSfx3B_Noise_2:
	db $00, $60, $20, $80, $01
NoiseSfx3B_Sq1:
	db $00, $40, $10, $a0, $87, $01

;@ def NoiseSfx3D_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3D (bank $15). It locks its channel, so that other effects of the channel are
;@ ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3D_Start::
;> return StartLockedNoiseSfx(NoiseSfx3D_Noise, timer)
	ld hl, NoiseSfx3D_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx3D_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $3D on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3D_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 81: return SilenceNoiseSfx(timer)
	cp $51
	jp z, SilenceNoiseSfx
;> record = mem16[NoiseSfx3D_NoiseFreqTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx3D_NoiseFreqTable
	call GetSfxTableEntry
;> return WriteNoiseFreq(record, timer)
	jp WriteNoiseFreq

;@ path: sound/sfx/noise
;@ The data of noise effect $3D, read by NoiseSfx3D_Start / NoiseSfx3D_Update.
;@ NoiseSfx3D_NoiseFreqTable: one pointer per step (the first for step 1) to its record (noise notes).
;@ NoiseSfx3D_Noise: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
;@ NoiseSfx3D_NoiseFreq, NoiseSfx3D_NoiseFreq_2, NoiseSfx3D_NoiseFreq_3, NoiseSfx3D_NoiseFreq_4,
;@ NoiseSfx3D_NoiseFreq_5, NoiseSfx3D_NoiseFreq_6, NoiseSfx3D_NoiseFreq_7, NoiseSfx3D_NoiseFreq_8,
;@ NoiseSfx3D_NoiseFreq_9, NoiseSfx3D_NoiseFreq_10, NoiseSfx3D_NoiseFreq_11, NoiseSfx3D_NoiseFreq_12,
;@ NoiseSfx3D_NoiseFreq_13, NoiseSfx3D_NoiseFreq_14, NoiseSfx3D_NoiseFreq_15, NoiseSfx3D_NoiseFreq_16,
;@ NoiseSfx3D_NoiseFreq_17, NoiseSfx3D_NoiseFreq_18, NoiseSfx3D_NoiseFreq_19, NoiseSfx3D_NoiseFreq_20,
;@ NoiseSfx3D_NoiseFreq_21, NoiseSfx3D_NoiseFreq_22, NoiseSfx3D_NoiseFreq_23, NoiseSfx3D_NoiseFreq_24,
;@ NoiseSfx3D_NoiseFreq_25, NoiseSfx3D_NoiseFreq_26, NoiseSfx3D_NoiseFreq_27, NoiseSfx3D_NoiseFreq_28,
;@ NoiseSfx3D_NoiseFreq_29, NoiseSfx3D_NoiseFreq_30, NoiseSfx3D_NoiseFreq_31: noise notes, 3 bytes each:
;@ NR43 noise frequency, NR44 restart, then the frames until the next step.
NoiseSfx3D_Data::
NoiseSfx3D_NoiseFreqTable:
	dw NoiseSfx3D_NoiseFreq, NoiseSfx3D_NoiseFreq_2, NoiseSfx3D_NoiseFreq_3, NoiseSfx3D_NoiseFreq_4, NoiseSfx3D_NoiseFreq_5, NoiseSfx3D_NoiseFreq_6, NoiseSfx3D_NoiseFreq_5, NoiseSfx3D_NoiseFreq_4
	dw NoiseSfx3D_NoiseFreq_3, NoiseSfx3D_NoiseFreq_4, NoiseSfx3D_NoiseFreq_5, NoiseSfx3D_NoiseFreq_6, NoiseSfx3D_NoiseFreq_7, NoiseSfx3D_NoiseFreq_8, NoiseSfx3D_NoiseFreq_9, NoiseSfx3D_NoiseFreq_8
	dw NoiseSfx3D_NoiseFreq_7, NoiseSfx3D_NoiseFreq_6, NoiseSfx3D_NoiseFreq_7, NoiseSfx3D_NoiseFreq_8, NoiseSfx3D_NoiseFreq_9, NoiseSfx3D_NoiseFreq_10, NoiseSfx3D_NoiseFreq_11, NoiseSfx3D_NoiseFreq_12
	dw NoiseSfx3D_NoiseFreq_11, NoiseSfx3D_NoiseFreq_10, NoiseSfx3D_NoiseFreq_9, NoiseSfx3D_NoiseFreq_10, NoiseSfx3D_NoiseFreq_11, NoiseSfx3D_NoiseFreq_12, NoiseSfx3D_NoiseFreq_13, NoiseSfx3D_NoiseFreq_14
	dw NoiseSfx3D_NoiseFreq_15, NoiseSfx3D_NoiseFreq_14, NoiseSfx3D_NoiseFreq_13, NoiseSfx3D_NoiseFreq_12, NoiseSfx3D_NoiseFreq_13, NoiseSfx3D_NoiseFreq_14, NoiseSfx3D_NoiseFreq_15, NoiseSfx3D_NoiseFreq_16
	dw NoiseSfx3D_NoiseFreq_17, NoiseSfx3D_NoiseFreq_18, NoiseSfx3D_NoiseFreq_17, NoiseSfx3D_NoiseFreq_16, NoiseSfx3D_NoiseFreq_15, NoiseSfx3D_NoiseFreq_16, NoiseSfx3D_NoiseFreq_17, NoiseSfx3D_NoiseFreq_18
	dw NoiseSfx3D_NoiseFreq_19, NoiseSfx3D_NoiseFreq_20, NoiseSfx3D_NoiseFreq_21, NoiseSfx3D_NoiseFreq_20, NoiseSfx3D_NoiseFreq_19, NoiseSfx3D_NoiseFreq_18, NoiseSfx3D_NoiseFreq_19, NoiseSfx3D_NoiseFreq_20
	dw NoiseSfx3D_NoiseFreq_21, NoiseSfx3D_NoiseFreq_22, NoiseSfx3D_NoiseFreq_23, NoiseSfx3D_NoiseFreq_24, NoiseSfx3D_NoiseFreq_23, NoiseSfx3D_NoiseFreq_22, NoiseSfx3D_NoiseFreq_21, NoiseSfx3D_NoiseFreq_22
	dw NoiseSfx3D_NoiseFreq_23, NoiseSfx3D_NoiseFreq_24, NoiseSfx3D_NoiseFreq_25, NoiseSfx3D_NoiseFreq_26, NoiseSfx3D_NoiseFreq_27, NoiseSfx3D_NoiseFreq_26, NoiseSfx3D_NoiseFreq_25, NoiseSfx3D_NoiseFreq_24
	dw NoiseSfx3D_NoiseFreq_25, NoiseSfx3D_NoiseFreq_26, NoiseSfx3D_NoiseFreq_27, NoiseSfx3D_NoiseFreq_28, NoiseSfx3D_NoiseFreq_29, NoiseSfx3D_NoiseFreq_30, NoiseSfx3D_NoiseFreq_31, NoiseSfx3D_NoiseFreq_30
	dw NoiseSfx3D_NoiseFreq_31
NoiseSfx3D_Noise:
	db $38, $80, $24, $80, $02
NoiseSfx3D_NoiseFreq:
	db $25, $80, $02
NoiseSfx3D_NoiseFreq_2:
	db $26, $80, $02
NoiseSfx3D_NoiseFreq_3:
	db $27, $80, $02
NoiseSfx3D_NoiseFreq_4:
	db $34, $80, $02
NoiseSfx3D_NoiseFreq_5:
	db $35, $80, $02
NoiseSfx3D_NoiseFreq_6:
	db $36, $80, $02
NoiseSfx3D_NoiseFreq_7:
	db $37, $80, $02
NoiseSfx3D_NoiseFreq_8:
	db $44, $80, $02
NoiseSfx3D_NoiseFreq_9:
	db $45, $80, $02
NoiseSfx3D_NoiseFreq_10:
	db $46, $80, $02
NoiseSfx3D_NoiseFreq_11:
	db $47, $80, $02
NoiseSfx3D_NoiseFreq_12:
	db $3c, $80, $03
NoiseSfx3D_NoiseFreq_13:
	db $3d, $80, $03
NoiseSfx3D_NoiseFreq_14:
	db $3e, $80, $03
NoiseSfx3D_NoiseFreq_15:
	db $3f, $80, $03
NoiseSfx3D_NoiseFreq_16:
	db $4c, $80, $03
NoiseSfx3D_NoiseFreq_17:
	db $4d, $80, $03
NoiseSfx3D_NoiseFreq_18:
	db $4e, $80, $03
NoiseSfx3D_NoiseFreq_19:
	db $4f, $80, $03
NoiseSfx3D_NoiseFreq_20:
	db $5c, $80, $03
NoiseSfx3D_NoiseFreq_21:
	db $5d, $80, $03
NoiseSfx3D_NoiseFreq_22:
	db $5e, $80, $03
NoiseSfx3D_NoiseFreq_23:
	db $5f, $80, $03
NoiseSfx3D_NoiseFreq_24:
	db $6c, $80, $03
NoiseSfx3D_NoiseFreq_25:
	db $6d, $c0, $03
NoiseSfx3D_NoiseFreq_26:
	db $6e, $c0, $03
NoiseSfx3D_NoiseFreq_27:
	db $6f, $c0, $03
NoiseSfx3D_NoiseFreq_28:
	db $7c, $c0, $03
NoiseSfx3D_NoiseFreq_29:
	db $7d, $c0, $03
NoiseSfx3D_NoiseFreq_30:
	db $7e, $c0, $03
NoiseSfx3D_NoiseFreq_31:
	db $7f, $c0, $03

;@ def NoiseSfx3E_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3E, Slime Eel rumble: the Slime Eel cracks the floor (held while wHoldNoiseSfx3E is
;@ set). It locks its channel, so that other effects of the channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3E_Start::
;> return StartLockedNoiseSfx(NoiseSfx3E_Noise, timer)
	ld hl, NoiseSfx3E_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx3E_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $3E (Slime Eel rumble) on: each time its timer runs out, the next step. At the end the
;@ channel goes back to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3E_Update::
;> if wHoldNoiseSfx3E: return
	ld a, [wHoldNoiseSfx3E]
	and a
	ret nz
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 8: return EndNoiseSfx()
	cp $08
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx3E_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx3E_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $3E (Slime Eel rumble), read by NoiseSfx3E_Start / NoiseSfx3E_Update.
;@ NoiseSfx3E_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx3E_Noise, NoiseSfx3E_Noise_2, NoiseSfx3E_Noise_3, NoiseSfx3E_Noise_4, NoiseSfx3E_Noise_5,
;@ NoiseSfx3E_Noise_6, NoiseSfx3E_Noise_7, NoiseSfx3E_Noise_8: noise channel register records, 5 bytes each:
;@ NR41 length, NR42 volume envelope, NR43 noise frequency and kind, NR44 restart (bit 7), then the frames
;@ until the next step.
NoiseSfx3E_Data::
NoiseSfx3E_NoiseTable:
	dw NoiseSfx3E_Noise_2, NoiseSfx3E_Noise_3, NoiseSfx3E_Noise_4, NoiseSfx3E_Noise_5, NoiseSfx3E_Noise_6, NoiseSfx3E_Noise_7, NoiseSfx3E_Noise_8
NoiseSfx3E_Noise:
	db $00, $1f, $7f, $80, $01
NoiseSfx3E_Noise_2:
	db $00, $e0, $44, $80, $06
NoiseSfx3E_Noise_3:
	db $00, $c0, $45, $80, $06
NoiseSfx3E_Noise_4:
	db $00, $a0, $46, $80, $06
NoiseSfx3E_Noise_5:
	db $00, $80, $47, $80, $06
NoiseSfx3E_Noise_6:
	db $00, $60, $54, $80, $06
NoiseSfx3E_Noise_7:
	db $00, $40, $55, $80, $06
NoiseSfx3E_Noise_8:
	db $38, $20, $56, $c0, $06

;@ def NoiseSfx3F_Start(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Starts noise effect $3F (the Grim Creeper, bank $07). It locks its channel, so that other effects of the
;@ channel are ignored until it ends.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3F_Start::
;> return StartLockedNoiseSfx(NoiseSfx3F_Noise, timer)
	ld hl, NoiseSfx3F_Noise
	jp StartLockedNoiseSfx

;@ def NoiseSfx3F_Update(timer: de, step: bc)
;@ path: sound/sfx/noise
;@ Plays noise effect $3F on: each time its timer runs out, the next step. At the end the channel goes back
;@ to the music.
;@ test: timer = 0xD393; step = 0xD398; wNoiseSfxStep = rand(0, 0x7F)
NoiseSfx3F_Update::
;> wNoiseSfxTimer -= 1
	call CountDownSfxTimer
;> if wNoiseSfxTimer: return
	ret nz
;> wNoiseSfxStep += 1
	call NextSfxStep
;> if wNoiseSfxStep == 16: return EndNoiseSfx()
	cp $10
	jp z, EndNoiseSfx
;> record = mem16[NoiseSfx3F_NoiseTable + 2 * (wNoiseSfxStep - 1)]
	ld hl, NoiseSfx3F_NoiseTable
	call GetSfxTableEntry
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ path: sound/sfx/noise
;@ The data of noise effect $3F, read by NoiseSfx3F_Start / NoiseSfx3F_Update.
;@ NoiseSfx3F_NoiseTable: one pointer per step (the first for step 1) to its record (noise channel register
;@ records).
;@ NoiseSfx3F_Noise, NoiseSfx3F_Noise_2, NoiseSfx3F_Noise_3, NoiseSfx3F_Noise_4, NoiseSfx3F_Noise_5,
;@ NoiseSfx3F_Noise_6, NoiseSfx3F_Noise_7, NoiseSfx3F_Noise_8, NoiseSfx3F_Noise_9, NoiseSfx3F_Noise_10,
;@ NoiseSfx3F_Noise_11, NoiseSfx3F_Noise_12, NoiseSfx3F_Noise_13, NoiseSfx3F_Noise_14, NoiseSfx3F_Noise_15,
;@ NoiseSfx3F_Noise_16: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope,
;@ NR43 noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfx3F_Data::
NoiseSfx3F_NoiseTable:
	dw NoiseSfx3F_Noise_2, NoiseSfx3F_Noise_3, NoiseSfx3F_Noise_4, NoiseSfx3F_Noise_5, NoiseSfx3F_Noise_6, NoiseSfx3F_Noise_7, NoiseSfx3F_Noise_8, NoiseSfx3F_Noise_9
	dw NoiseSfx3F_Noise_10, NoiseSfx3F_Noise_11, NoiseSfx3F_Noise_12, NoiseSfx3F_Noise_13, NoiseSfx3F_Noise_14, NoiseSfx3F_Noise_15, NoiseSfx3F_Noise_16
NoiseSfx3F_Noise:
	db $00, $20, $27, $80, $02
NoiseSfx3F_Noise_2:
	db $00, $40, $25, $80, $02
NoiseSfx3F_Noise_3:
	db $00, $60, $17, $80, $02
NoiseSfx3F_Noise_4:
	db $00, $80, $15, $80, $02
NoiseSfx3F_Noise_5:
	db $00, $a0, $17, $80, $02
NoiseSfx3F_Noise_6:
	db $00, $c0, $25, $80, $04
NoiseSfx3F_Noise_7:
	db $00, $b0, $27, $80, $04
NoiseSfx3F_Noise_8:
	db $00, $a0, $25, $80, $04
NoiseSfx3F_Noise_9:
	db $00, $90, $17, $80, $04
NoiseSfx3F_Noise_10:
	db $00, $80, $15, $c0, $04
NoiseSfx3F_Noise_11:
	db $00, $70, $17, $80, $04
NoiseSfx3F_Noise_12:
	db $00, $60, $25, $80, $04
NoiseSfx3F_Noise_13:
	db $00, $50, $27, $80, $04
NoiseSfx3F_Noise_14:
	db $00, $40, $25, $80, $04
NoiseSfx3F_Noise_15:
	db $00, $30, $17, $80, $04
NoiseSfx3F_Noise_16:
	db $2f, $20, $15, $c0, $04

;@ def StartLockedNoiseSfx(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Starts the requested noise effect like StartNoiseSfx and locks the channel: other noise requests are
;@ ignored until it ends.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD393
StartLockedNoiseSfx::
;> wNoiseSfxLocked = 1
	ld a, $01
	ld [wNoiseSfxLocked], a
;> return StartNoiseSfx(record, timer)        # falls through

;@ def StartNoiseSfx(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ The common start of a noise effect: wActiveNoiseSfx = the request, timer and step cleared, the noise
;@ channel taken from the music, then the first record goes to NR41-NR44 and its frame count into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD393
StartNoiseSfx::
;> wActiveNoiseSfx = wNoiseSfxToPlay
	ld a, [wNoiseSfxToPlay]
	ld [wActiveNoiseSfx], a
;> wNoiseSfxTimer = 0
	xor a
	ld [wNoiseSfxTimer], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wMusicChannel4[0x0F] |= 0x80               # the music leaves the noise channel alone
	ld a, [wMusicChannel4 + $0F]
	set 7, a
	ld [wMusicChannel4 + $0F], a
;> return WriteNoiseRegs(record, timer)
	jp WriteNoiseRegs

;@ def SilenceNoiseSfx(timer: de)
;@ path: sound/sfx/engine
;@ Ends the noise effect after silencing the noise channel (NoiseSfxSilence).
;@ test: timer = 0xD393
SilenceNoiseSfx::
;> WriteNoiseRegs(NoiseSfxSilence, timer)
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs
;> return EndNoiseSfx()                       # falls through

;@ def EndNoiseSfx()
;@ path: sound/sfx/engine
;@ Ends the noise effect: state cleared, lock released, the noise channel given back to the music.
EndNoiseSfx::
;> wActiveNoiseSfx = 0
	xor a
	ld [wActiveNoiseSfx], a
;> wNoiseSfxTimer = 0
	ld [wNoiseSfxTimer], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wNoiseSfxRepeat = 0
	ld [wNoiseSfxRepeat], a
;> wNoiseSfxLocked = 0
	ld [wNoiseSfxLocked], a
;> wMusicChannel4[0x0F] &= 0x7F
	ld a, [wMusicChannel4 + $0F]
	res 7, a
	ld [wMusicChannel4 + $0F], a
	ret

;@ path: sound/sfx/engine
;@ The noise channel record that silences the channel when an effect ends (SilenceNoiseSfx).
;@ NoiseSfxSilence: noise channel register records, 5 bytes each: NR41 length, NR42 volume envelope, NR43
;@ noise frequency and kind, NR44 restart (bit 7), then the frames until the next step.
NoiseSfxSilence::
	db $00, $00, $00, $00, $01

;@ def WriteNoiseFreq(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ A note of a noise effect: the record's two bytes go to NR43 / NR44, the third into the timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD393
WriteNoiseFreq::
;> return WriteSoundRegs(record, 2, 0x22, timer)   # rNR43, rNR44
	ld b, $02
	ld c, $22
	jp WriteSoundRegs

;@ def IgnoreNoiseSfx()
;@ path: sound/sfx/engine
;@ A noise request that may not start (a locked noise effect plays): dropped, the playing effect goes on.
;@ test: skip runs the effect routines through their tables
IgnoreNoiseSfx::
;> wNoiseSfxToPlay = 0
	xor a
	ld [wNoiseSfxToPlay], a
;> return UpdateNoiseSfx()
	jp UpdateNoiseSfx

;@ def StartNoiseSfxOnSquare2(timer: de)
;@ path: sound/sfx/engine
;@ The start of noise effect $37, which plays on square 2: the noise request becomes the active noise
;@ effect, square 2 is taken from the music, the noise channel is locked and silenced.
;@ test: timer = 0xD393
StartNoiseSfxOnSquare2::
;> wActiveNoiseSfx = wNoiseSfxToPlay
	ld a, [wNoiseSfxToPlay]
	ld [wActiveNoiseSfx], a
;> wMusicChannel2[0x0F] |= 0x80
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
;> wNoiseSfxLocked = 1
	ld a, $01
	ld [wNoiseSfxLocked], a
;> wNoiseSfxTimer = 0
	xor a
	ld [wNoiseSfxTimer], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> WriteNoiseRegs(NoiseSfxSilence, timer)
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs
	ret

;@ def EndNoiseSfxOnSquare2()
;@ path: sound/sfx/engine
;@ Ends a noise effect that played on square 2 (noise effect $37): state cleared, lock released, square 2
;@ given back to the music.
EndNoiseSfxOnSquare2::
;> wNoiseSfxTimer = 0
	xor a
	ld [wNoiseSfxTimer], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wActiveNoiseSfx = 0
	ld [wActiveNoiseSfx], a
;> wNoiseSfxLocked = 0
	ld [wNoiseSfxLocked], a
;> wMusicChannel2[0x0F] &= 0x7F
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ret

;@ def GetSfxTableEntry(index: a, table: hl) -> hl
;@ path: sound/sfx/engine
;@ Entry index-1 of a table of words: an effect routine, or the record of an effect's step (index = the step
;@ after NextSfxStep). bc gets the same value.
;@ test: table = rand(0x4000, 0x7F00)
GetSfxTableEntry::
;> p = table + u8(2 * (index - 1))
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
;> return mem16[p]
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld h, b
	ld l, c
	ret


;@ def CountDownSfxTimer(timer: de) -> a
;@ path: sound/sfx/engine
;@ Counts an effect's frame timer down by one; the zero flag is set when it ran out.
;@ test: timer = 0xD390
CountDownSfxTimer::
;> mem[timer] = u8(mem[timer] - 1)
	ld a, [de]
	dec a
	ld [de], a
;> return mem[timer]
	ret


;@ def NextSfxStep(step: bc) -> a
;@ path: sound/sfx/engine
;@ Counts an effect's step up by one and returns the new step.
;@ test: step = 0xD394
NextSfxStep::
;> mem[step] = u8(mem[step] + 1)
	ld a, [bc]
	inc a
	ld [bc], a
;> return mem[step]
	ret


;@ def WriteSquare1Regs(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Writes a square 1 register record: 5 bytes into NR10-NR14, the 6th into the effect's timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD390
WriteSquare1Regs::
;> return WriteSoundRegs(record, 5, 0x10, timer)   # rNR10-rNR14
	ld b, $05
	ld c, $10
	jr WriteSoundRegs

;@ def WriteSquare2Regs(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Writes a square 2 register record: 4 bytes into NR21-NR24, the 5th into the effect's timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD390
WriteSquare2Regs::
;> return WriteSoundRegs(record, 4, 0x16, timer)   # rNR21-rNR24
	ld b, $04
	ld c, $16
	jr WriteSoundRegs

;@ def WriteWaveRegs(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Writes a wave channel register record: 5 bytes into NR30-NR34, the 6th into the effect's timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD392
WriteWaveRegs::
;> return WriteSoundRegs(record, 5, 0x1A, timer)   # rNR30-rNR34
	ld b, $05
	ld c, $1a
	jr WriteSoundRegs

;@ def WriteNoiseRegs(record: hl, timer: de)
;@ path: sound/sfx/engine
;@ Writes a noise channel register record: 4 bytes into NR41-NR44, the 5th into the effect's timer.
;@ test: record = rand(0x4000, 0x7FF0); timer = 0xD393
WriteNoiseRegs::
;> return WriteSoundRegs(record, 4, 0x20, timer)   # rNR41-rNR44
	ld b, $04
	ld c, $20
	jr WriteSoundRegs

;@ def WriteSoundRegs(record: hl, count: b, reg: c, timer: de)
;@ path: sound/sfx/engine
;@ Writes count bytes of a record into the sound registers from $FF00 + reg on, then the next byte into the
;@ effect's timer: the frames until its next step.
;@ test: record = rand(0x4000, 0x7FF0); count = rand(1, 5); reg = rand(0x10, 0x1B); timer = 0xD390
WriteSoundRegs::
;> for i in range(count):
;>     mem[0xFF00 + reg + i] = mem[record + i]
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, WriteSoundRegs
;> mem[timer] = mem[record + count]
	ld a, [hl]
	ld [de], a
	ret


;@ def CountDownJingleRepeat() -> a
;@ path: sound/sfx/engine
;@ Counts wJingleRepeat down by one and returns it (zero flag set when it ran out).
;@ test: skip goes on in CountDownCounter, which takes back de from the stack
CountDownJingleRepeat::
;> wJingleRepeat -= 1                         # (CountDownCounter)
	push de
	ld de, wJingleRepeat
	jr CountDownCounter
;> return wJingleRepeat

;@ def CountDownSfxRepeat2() -> a
;@ path: unused
;@ Counts wUnusedSfxRepeat down by one, like CountDownJingleRepeat. Nothing calls it.
;@ test: skip goes on in CountDownCounter, which takes back de from the stack
CountDownSfxRepeat2::
;> wUnusedSfxRepeat -= 1                      # (CountDownCounter)
	push de
	ld de, wUnusedSfxRepeat
	jr CountDownCounter
;> return wUnusedSfxRepeat

;@ def CountDownWaveSfxRepeat() -> a
;@ path: sound/sfx/engine
;@ Counts wWaveSfxRepeat down by one and returns it (zero flag set when it ran out).
;@ test: skip goes on in CountDownCounter, which takes back de from the stack
CountDownWaveSfxRepeat::
;> wWaveSfxRepeat -= 1                        # (CountDownCounter)
	push de
	ld de, wWaveSfxRepeat
	jr CountDownCounter
;> return wWaveSfxRepeat

;@ def CountDownNoiseSfxRepeat() -> a
;@ path: sound/sfx/engine
;@ Counts wNoiseSfxRepeat down by one and returns it (zero flag set when it ran out).
;@ test: skip goes on in CountDownCounter, which takes back de from the stack
CountDownNoiseSfxRepeat::
;> wNoiseSfxRepeat -= 1                       # (CountDownCounter)
	push de
	ld de, wNoiseSfxRepeat
	jr CountDownCounter
;> return wNoiseSfxRepeat

;@ def CountDownCounter(counter: de) -> a
;@ path: sound/sfx/engine
;@ The shared end of the CountDown...Repeat helpers: counts the byte at counter down, then takes back the de
;@ they saved on the stack.
;@ test: skip pops the de its callers pushed
CountDownCounter::
;> mem[counter] = u8(mem[counter] - 1)
	call CountDownSfxTimer
;> return mem[counter]                        # (pop de: the caller's de comes back)
	pop de
	ret


;@ def SaveSquare1Freq(record: hl)
;@ path: sound/sfx/engine
;@ Keeps the frequency of a square 1 register record (its NR13 byte, and NR14 & $0F) in wJingleFreq, where
;@ SlideSquare1 starts from.
;@ test: skip goes on in SaveFreqFromRecord, which takes back de from the stack
SaveSquare1Freq::
;> wJingleFreq = mem[record + 3] | (mem[record + 4] & 0x0F) << 8    # (SaveFreqFromRecord)
	push de
	ld de, wJingleFreq
	jr SaveFreqFromRecord

;@ def SaveWaveFreq(record: hl)
;@ path: sound/sfx/engine
;@ Keeps the frequency of a wave register record (NR33, NR34 & $0F) in wWaveSfxFreq, where SlideWave starts
;@ from.
;@ test: skip goes on in SaveFreqFromRecord, which takes back de from the stack
SaveWaveFreq::
;> wWaveSfxFreq = mem[record + 3] | (mem[record + 4] & 0x0F) << 8   # falls into SaveFreqFromRecord
	push de
	ld de, wWaveSfxFreq

;@ def SaveFreqFromRecord(record: hl, dest: de)
;@ path: sound/sfx/engine
;@ The shared part of SaveSquare1Freq / SaveWaveFreq: bytes 3 and 4 of a register record (the frequency,
;@ without the restart bits) into the 16-bit variable at dest; hl stays at the record and the caller's de is
;@ taken back from the stack.
;@ test: skip pops the de its callers pushed
SaveFreqFromRecord::
;> mem[dest] = mem[record + 3]                # frequency, low byte
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
;> mem[dest + 1] = mem[record + 4] & 0x0F     # high bits
	inc e
	ld a, [hld]
	and $0f
	ld [de], a
;> return
	dec hl
	dec hl
	dec hl
	pop de
	ret


;@ def SaveSquare2Freq(record: hl)
;@ path: sound/sfx/engine
;@ Keeps the frequency of a square 2 register record (NR23, NR24 & $0F) in wSquare2SfxFreq, where
;@ SlideSquare2 starts from.
SaveSquare2Freq::
;>@f wSquare2SfxFreq = mem[record + 2] | (mem[record + 3] & 0x0F) << 8
	push de
	ld de, wSquare2SfxFreq
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
;=@f
	inc e
	ld a, [hld]
	and $0f
	ld [de], a
;> return                                     # hl back at the record
	dec hl
	dec hl
	pop de
	ret

;@ def SlideSquare1(deltas: hl, step: bc)
;@ path: sound/sfx/engine
;@ One step of a square 1 slide: entry step-1 of the deltas is added to wJingleFreq and the sum goes to NR13
;@ / NR14 (the sound is not restarted unless the sum has bit 15 set).
;@ test: skip goes on in SlideFreq, which takes its register number and de from the stack
SlideSquare1::
;> return SlideFreq(deltas, mem[step], 0xD3C1, 0x13)   # wJingleFreq (high byte), rNR13
	push de
	ld de, wJingleFreq + $01
	ld a, [bc]
	ld c, $13
	push bc
	jr SlideFreq

;@ def SlideWave(deltas: hl, step: bc)
;@ path: sound/sfx/engine
;@ One step of a wave channel slide: entry step-1 of the deltas is added to wWaveSfxFreq and the sum goes to
;@ NR33 / NR34.
;@ test: skip goes on in SlideFreq, which takes its register number and de from the stack
SlideWave::
;> return SlideFreq(deltas, mem[step], 0xD3C5, 0x1D)   # wWaveSfxFreq (high byte), rNR33
	push de
	ld de, wWaveSfxFreq + $01
	ld a, [bc]
	ld c, $1d
	push bc
	jr SlideFreq

;@ def SlideFreq(deltas: hl, index: a, freq: de, reg)
;@ path: sound/sfx/engine
;@ The shared part of SlideSquare1 / SlideSquare2 / SlideWave. freq points at the high byte of the effect's
;@ 16-bit frequency; the register number (NR13 / NR23 / NR33) waits on the stack above the caller's saved
;@ de. Entry index-1 of the deltas (big-endian) is added to the frequency, and the sum goes into the
;@ register pair and back into the frequency.
;@ test: skip takes its register number and the caller's de from the stack
SlideFreq::
;> i = u8(2 * (index - 1))
	dec a
	sla a
	ld c, a
	ld b, $00
;> delta = mem[deltas + i] << 8 | mem[deltas + i + 1]
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
;> value = u16((mem[freq] << 8 | mem[freq - 1]) + delta)
	ld a, [de]
	dec e
	ld h, a
	ld a, [de]
	ld l, a
	add hl, bc
;> mem[0xFF00 + reg] = lo(value)              # the register number comes off the stack
	pop bc
	ld a, l
	ldh [c], a
;> mem[freq - 1] = lo(value)
	ld [de], a
;> mem[0xFF00 + reg + 1] = hi(value)
	inc c
	inc e
	ld a, h
	ldh [c], a
;> mem[freq] = hi(value)
	ld [de], a
	pop de
	ret


;@ def SlideSquare2(deltas: hl, step: bc)
;@ path: sound/sfx/engine
;@ One step of a square 2 slide: entry step-1 of the deltas is added to wSquare2SfxFreq and the sum goes to
;@ NR23 / NR24.
;@ test: skip goes on in SlideFreq, which takes its register number and de from the stack
SlideSquare2::
;> return SlideFreq(deltas, mem[step], 0xD3C3, 0x18)   # wSquare2SfxFreq (high byte), rNR23
	push de
	ld de, wSquare2SfxFreq + $01
	ld a, [bc]
	ld c, $18
	push bc
	jr SlideFreq

;@ def StopAllSound()
;@ path: sound/sfx/engine
;@ Entry $4003: stops the music and every sound effect. Every channel goes to both speakers again, all
;@ effect and music state is cleared and the channels are silenced (envelope 0, restarted).
StopAllSound::
;> rNR51 = 0xFF
	ld a, $ff
	ldh [rNR51], a
;> wMusicPanMode = 3
	ld a, $03
	ld [wMusicPanMode], a
;> wActiveMusicTrack = 0
	xor a
	ld [wActiveMusicTrack], a
;> wActiveJingle = 0
	xor a
	ld [wActiveJingle], a
;> wActiveWaveSfx = 0
	ld [wActiveWaveSfx], a
;> wActiveNoiseSfx = 0
	ld [wActiveNoiseSfx], a
;> wMusicChannel1[0x0F] = 0                   # no effect owns a channel
	ld [wMusicChannel1 + $0F], a
;> wMusicChannel2[0x0F] = 0
	ld [wMusicChannel2 + $0F], a
;> wMusicChannel3[0x0F] = 0
	ld [wMusicChannel3 + $0F], a
;> wMusicChannel4[0x0F] = 0
	ld [wMusicChannel4 + $0F], a
;> wMusicWaveDecay = 0
	ld [wMusicWaveDecay], a
;> wMusicWaveDecayFrame = 0
	ld [wMusicWaveDecayFrame], a
;> wMusicWaveSwell = 0
	ld [wMusicWaveSwell], a
;> wMusicWaveSwellFrame = 0
	ld [wMusicWaveSwellFrame], a
;> fill(wMusicPitchDrop, 0, 6)
	ld [wMusicPitchDrop], a
	ld [wMusicPitchDrop + $01], a
	ld [wMusicPitchDrop + $02], a
	ld [wMusicPitchDrop + $03], a
	ld [wMusicPitchDrop + $04], a
	ld [wMusicPitchDrop + $05], a
;> wJingleStep = 0
	ld [wJingleStep], a
;> wUnusedSfxStep = 0
	ld [wUnusedSfxStep], a
;> wWaveSfxStep = 0
	ld [wWaveSfxStep], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wJingleTimer = 0
	ld [wJingleTimer], a
;> wUnusedSfxTimer = 0
	ld [wUnusedSfxTimer], a
;> wWaveSfxTimer = 0
	ld [wWaveSfxTimer], a
;> wNoiseSfxTimer = 0
	ld [wNoiseSfxTimer], a
;> wJingleLocked = 0
	ld [wJingleLocked], a
;> wUnusedSfxLocked = 0
	ld [wUnusedSfxLocked], a
;> wWaveSfxLocked = 0
	ld [wWaveSfxLocked], a
;> wNoiseSfxLocked = 0
	ld [wNoiseSfxLocked], a
;> wSoundUnusedA0 = 0
	ld [wSoundUnusedA0], a
;> wSoundUnusedA1 = 0
	ld [wSoundUnusedA1], a
;> wSoundUnusedA2 = 0
	ld [wSoundUnusedA2], a
;> wSoundUnusedA3 = 0
	ld [wSoundUnusedA3], a
;> wMusicBlocksWaveSfx = 0
	ld [wMusicBlocksWaveSfx], a
;> wSfxFastVariant = 0
	ld [wSfxFastVariant], a
;> wJingle22Count = 0
	ld [wJingle22Count], a
;> wSoundUnusedD8 = 0
	ld [wSoundUnusedD8], a
;> wWaveSfx1ECount = 0
	ld [wWaveSfx1ECount], a
;> wWaveRamDirty = 0
	ld [wWaveRamDirty], a
;> wJingleSubStep = 0
	ld [wJingleSubStep], a
;> wSoundUnusedE3 = 0
	ld [wSoundUnusedE3], a
;> wSoundUnusedE4 = 0
	ld [wSoundUnusedE4], a
;> wSoundUnusedE5 = 0
	ld [wSoundUnusedE5], a
;> rNR12 = 0x08                               # volume 0
	ld a, $08
	ldh [rNR12], a
;> rNR22 = 0x08
	ldh [rNR22], a
;> rNR42 = 0x08
	ldh [rNR42], a
;> rNR14 = 0x80                               # restart: the channels take the new volume
	ld a, $80
	ldh [rNR14], a
;> rNR24 = 0x80
	ldh [rNR24], a
;> rNR44 = 0x80
	ldh [rNR44], a
;> rNR10 = 0
	xor a
	ldh [rNR10], a
;> rNR30 = 0                                  # wave channel off
	ldh [rNR30], a
	ret

;@ path: unused
;@ Unused space ($FF bytes).
Padding_1F_7BBC::
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
	db $ff, $ff, $ff, $ff

;@ def UpdateVolumeAndSfxRequests()
;@ path: sound/sfx/engine
;@ Called once a frame from bank 0 before the sound engines run: the master volume fades (while
;@ hVolumeFadeOutTimer runs, every 4th frame one step down; while hVolumeFadeInTimer runs, every 2nd frame
;@ one step up, to 7), NR50 gets hVolumeRight / hVolumeLeft, and the effects the game asked for in hJingle /
;@ hWaveSfx / hNoiseSfx move into the engine's request bytes.
UpdateVolumeAndSfxRequests::
;> if hVolumeFadeOutTimer:
	ldh a, [hVolumeFadeOutTimer]
	and a
	jr z, .fadeIn
;>     hVolumeFadeOutTimer -= 1
	sub $01
	ldh [hVolumeFadeOutTimer], a
;>     if (hVolumeFadeOutTimer & 3) == 0:
	and $03
	jr nz, .fadeIn
;>         if hVolumeRight: hVolumeRight -= 1
	ldh a, [hVolumeRight]
	and a
	jr z, .left
	dec a
	ldh [hVolumeRight], a
;>         if hVolumeLeft: hVolumeLeft -= 0x10
.left
	ldh a, [hVolumeLeft]
	and a
	jr z, .fadeIn
	sub $10
	ldh [hVolumeLeft], a
;> if hVolumeFadeInTimer:
.fadeIn
	ldh a, [hVolumeFadeInTimer]
	and a
	jr z, .setVolume
;>     hVolumeFadeInTimer -= 1
	sub $01
	ldh [hVolumeFadeInTimer], a
;>     if (hVolumeFadeInTimer & 1) == 0:
	and $01
	jr nz, .setVolume
;>         if hVolumeRight < 7: hVolumeRight += 1
	ldh a, [hVolumeRight]
	cp $07
	jr nc, .left2
	inc a
	ldh [hVolumeRight], a
;>         if hVolumeLeft < 0x70: hVolumeLeft += 0x10
.left2
	ldh a, [hVolumeLeft]
	cp $70
	jr nc, .setVolume
	add $10
	ldh [hVolumeLeft], a
;>@nr50 rNR50 = ((rNR50 & 0xF8 | hVolumeRight) & 0x8F) | hVolumeLeft
.setVolume
	ld hl, hVolumeRight
	ldh a, [rNR50]
	and $f8
	or [hl]
	inc hl
	and $8f
;=@nr50
	or [hl]
	ldh [rNR50], a
;> if hJingle:
	ldh a, [hJingle]
	and a
	jr z, .wave
;>     wJingleToPlay = hJingle
	ld [wJingleToPlay], a
;>     hJingle = 0
	xor a
	ldh [hJingle], a
;> if hWaveSfx:
.wave
	ldh a, [hWaveSfx]
	and a
	jr z, .noise
;>     wWaveSfxToPlay = hWaveSfx
	ld [wWaveSfxToPlay], a
;>     hWaveSfx = 0
	xor a
	ldh [hWaveSfx], a
;> if hNoiseSfx:
.noise
	ldh a, [hNoiseSfx]
	and a
	jr z, .done
;>     wNoiseSfxToPlay = hNoiseSfx
	ld [wNoiseSfxToPlay], a
;>     hNoiseSfx = 0
	xor a
	ldh [hNoiseSfx], a
;> return
.done
	ret

;@ path: unused
;@ Unused space ($FF bytes).
Padding_1F_7FEE::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
