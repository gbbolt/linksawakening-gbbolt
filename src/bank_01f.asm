; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01f", ROMX[$4000], BANK[$1f]

	jp InitSoundEngine


SoundEntryStopAll::
	jp StopAllSound


	jp UpdateSoundEffects


InitSoundEngine::
	ld hl, wMusicTranspose

jr_01f_400c:
	ld [hl], $00
	inc l
	jr nz, jr_01f_400c

	ld a, $80
	ldh [rNR52], a
	ld a, $77
	ldh [rNR50], a
	ld a, $ff
	ldh [rNR51], a
	ret


UpdateSoundEffects::
	call UpdateJingle
	call UpdateWaveSfx
	call UpdateNoiseSfx
	xor a
	ld [wJingleToPlay], a
	ld [wWaveSfxToPlay], a
	ld [wNoiseSfxToPlay], a
	ret

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

UpdateJingle::
	ld hl, wJingleToPlay
	ld a, [hl]
	and a
	jr z, .x421c
	cp $01
	jr z, .x4216
	ld a, [wJingleLocked]
	and a
	jp nz, IgnoreJingle
.x4216
	ld a, [hl]
	ld hl, JingleStarts
	jr .x4223
.x421c
	inc hl
	ld a, [hl]
	and a
	ret z
	ld hl, JingleUpdates
.x4223
	call GetSfxTableEntry
	ld de, wJingleTimer
	ld bc, wJingleStep
	jp hl

Jingle01_Start::
	xor a
	ld [wWaveSfxToPlay], a
	ld [wActiveWaveSfx], a
	ldh [rNR30], a
	ld a, $01
	ld [wWaveSfxLocked], a
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	ld hl, wMusicChannel3 + $0F
	set 7, [hl]
	ld hl, Jingle01_Sq2
	call WriteSquare2Regs
	call LoadSfxWave2
	ld hl, Jingle01_Wave
	call WriteWaveRegs
	ld hl, Jingle01_Sq1
	jp StartLockedJingle

Jingle01_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $01
	jr z, .x4273
	cp $02
	jr z, .x4285
	cp $03
	jr z, .x4297
	cp $04
	jr z, .x42a9
	jr .x42bb
.x4273
	ld hl, Jingle01_Sq1_2
	call WriteSquare1Regs
	ld hl, Jingle01_Sq2_2
	call WriteSquare2Regs
	ld hl, Jingle01_Wave_2
	jp WriteWaveRegs
.x4285
	ld hl, Jingle01_Sq1_3
	call WriteSquare1Regs
	ld hl, Jingle01_Sq2_3
	call WriteSquare2Regs
	ld hl, Jingle01_Wave_3
	jp WriteWaveRegs
.x4297
	ld hl, Jingle01_Sq1_4
	call WriteSquare1Regs
	ld hl, Jingle01_Sq2_4
	call WriteSquare2Regs
	ld hl, Jingle01_Wave_4
	jp WriteWaveRegs
.x42a9
	ld hl, Square1Off
	call WriteSquare1Regs
	ld hl, Square2Off
	call WriteSquare2Regs
	ld hl, Square1Off
	jp WriteWaveRegs
.x42bb
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ld hl, wMusicChannel3 + $0F
	res 7, [hl]
	xor a
	ldh [rNR30], a
	ld [wWaveSfxLocked], a
	ld a, $01
	ld [wWaveRamDirty], a
	jp EndJingle

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

Jingle02_Start::
	ld hl, Jingle02_Sq1
	jp StartLockedJingle

Jingle02_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndJingle
	ld hl, Jingle02_Sq1FreqTable
	call GetSfxTableEntry
	ld a, $80
	ldh [rNR11], a
	ld a, $f1
	ldh [rNR12], a
	jp WriteSquare1Freq

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

Jingle03_Start::
	ld hl, Jingle03_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle03_Update::
	call NextSfxStep
	cp $0d
	jp z, SilenceJingle
	ld hl, Jingle03_Slide
	jp SlideSquare1

Jingle03_Data::
Jingle03_Slide:
	db $ff, $c0, $ff, $80, $ff, $00, $fe, $00, $01, $00, $ff, $00, $01, $00, $ff, $00
	db $00, $c0, $00, $c0, $00, $c0, $00, $c0
Jingle03_Sq1:
	db $00, $00, $c0, $80, $86, $01

Jingle04_Start::
	ld a, $0e
	ld [wJingleRepeat], a
	ld hl, Jingle04_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle04_Update::
	call CountDownSfxTimer
	ret nz
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, SilenceJingle
	ld a, $02
	ld [de], a
	call NextSfxStep
	cp $03
	jr z, .x43cd
.x43c7
	ld hl, Jingle04_Slide
	jp SlideSquare1
.x43cd
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $01
	ld [bc], a
	jr .x43c7

Jingle04_Data::
Jingle04_Slide:
	db $00, $20, $ff, $f0
Jingle04_Sq1:
	db $00, $80, $87, $c0, $86, $02

Jingle05_Start::
	ld a, $04
	ld [wJingleRepeat], a
	ld hl, Jingle05_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle05_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $04
	ld [de], a
	call NextSfxStep
	cp $05
	jr z, .x4404
.x43fe
	ld hl, Jingle05_Slide
	jp SlideSquare1
.x4404
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $01
	ld [bc], a
	jr .x43fe

Jingle05_Data::
Jingle05_Slide:
	db $00, $06, $00, $04, $00, $02, $ff, $f4
Jingle05_Sq1:
	db $00, $00, $c5, $d8, $87, $04

Jingle06_Start::
	ld a, $0a
	ld [wJingleRepeat], a
	ld hl, Jingle06_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle06_Update::
	call NextSfxStep
	cp $09
	jr z, .x4438
.x4432
	ld hl, Jingle06_Slide
	jp SlideSquare1
.x4438
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $01
	ld [bc], a
	jr .x4432

Jingle06_Data::
Jingle06_Slide:
	db $00, $40, $00, $80, $00, $80, $00, $40, $ff, $d0, $ff, $a0, $ff, $a0, $ff, $d0
Jingle06_Sq1:
	db $00, $80, $1b, $00, $82, $01

Jingle07_Start::
	ld hl, Jingle07_Sq1
	jp StartJingle

Jingle07_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndJingle
	ld hl, Jingle07_Sq1_2
	jp WriteSquare1Regs

Jingle07_Data::
Jingle07_Sq1:
	db $00, $3d, $f0, $d8, $c7, $03
Jingle07_Sq1_2:
	db $00, $00, $81, $e0, $87, $08

Jingle08_Start::
	ld hl, Jingle08_Sq1
	jp StartJingle

Jingle08_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndJingle
	ld hl, Jingle08_Sq1_2
	jp WriteSquare1Regs

Jingle08_Data::
Jingle08_Sq1:
	db $3f, $9e, $29, $80, $c7, $08
Jingle08_Sq1_2:
	db $1f, $9f, $81, $20, $87, $10

Jingle09_Start::
	ld hl, Jingle09_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle09_Update::
	call NextSfxStep
	cp $09
	jp z, SilenceJingle
	ld hl, Jingle09_Slide
	jp SlideSquare1

Jingle09_Data::
Jingle09_Slide:
	db $01, $00, $00, $c0, $00, $80, $00, $40, $ff, $c0, $ff, $80, $ff, $40, $ff, $00
Jingle09_Sq1:
	db $00, $9f, $a0, $00, $c2, $01

Jingle0A_Start::
	ld a, [wActiveJingle]
	cp $13
	jp z, IgnoreJingle
	ldh a, [rNR50]
	cp $77
	jr nz, .x44e2
	ld hl, Jingle0A_Sq1
.x44df
	jp StartJingle
.x44e2
	ld hl, Jingle0A_Sq1_2
	jr .x44df

Jingle0A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndJingle
	ldh a, [rNR50]
	cp $77
	jr nz, .x4505
	ld a, $10
.x44fb
	ldh [rNR12], a
	ld a, $c7
	ldh [rNR14], a
	ld a, $08
	ld [de], a
	ret
.x4505
	ld a, $20
	jr .x44fb

Jingle0A_Data::
Jingle0A_Sq1:
	db $00, $9f, $80, $a0, $c7, $02
Jingle0A_Sq1_2:
	db $00, $9f, $f0, $a0, $c7, $02

Jingle0B_Start::
	ld a, $05
	ld [wJingleRepeat], a
	ld hl, Jingle0B_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle0B_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $02
	ld [de], a
	call NextSfxStep
	cp $07
	jr z, .x4537
.x4531
	ld hl, Jingle0B_Slide
	jp SlideSquare1
.x4537
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $01
	ld [bc], a
	jr .x4531

Jingle0B_Data::
Jingle0B_Slide:
	db $ff, $c0, $ff, $80, $ff, $40, $00, $c0, $00, $80, $00, $40
Jingle0B_Sq1:
	db $00, $80, $f4, $80, $83, $01

Jingle0C_Start::
	ld a, $16
	ld [wJingleRepeat], a
	ld hl, Jingle0C_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle0C_Update::
	call NextSfxStep
	cp $04
	jr z, .x456f
.x4569
	ld hl, Jingle0C_Slide
	jp SlideSquare1
.x456f
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $08
	jr z, .x457e
	ld a, $01
	ld [bc], a
	jr .x4569
.x457e
	xor a
	ld [bc], a
	ld hl, Jingle0C_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle0C_Data::
Jingle0C_Slide:
	db $00, $28, $00, $00, $ff, $f0
Jingle0C_Sq1:
	db $00, $83, $47, $c0, $86, $02
Jingle0C_Sq1_2:
	db $00, $83, $47, $00, $87, $02

Jingle0D_Start::
	ld hl, Jingle0D_Sq1
	jp StartJingle

Jingle0D_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle0D_Sq1::
	db $27, $80, $c2, $48, $86, $18

Jingle0E_Start::
	ld a, [wActiveJingle]
	cp $08
	jr z, .x45b9
	and a
	jp nz, IgnoreJingle
.x45b9
	ld hl, Jingle0E_Sq1
	jp StartJingle

Jingle0E_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle0E_Sq1::
	db $16, $ab, $20, $80, $c6, $05

Jingle0F_Start::
	ld hl, Jingle0F_Sq1
	jp StartJingle

Jingle0F_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndJingle
	ld hl, Jingle0F_Sq1_2
	jp WriteSquare1Regs

Jingle0F_Data::
Jingle0F_Sq1:
	db $17, $80, $0b, $00, $85, $10
Jingle0F_Sq1_2:
	db $17, $80, $0e, $00, $c5, $10

Jingle10_Start::
	jp StopAllSound

Jingle11_Start::
	ld a, $17
	ld [wJingleRepeat], a
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	ld hl, Jingle11_Sq2
	call SaveSquare2Freq
	call WriteSquare2Regs
	ld hl, Jingle11_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle11_Update::
	call NextSfxStep
	cp $02
	jr z, .x4625
.x4616
	ld hl, Jingle11_Slide
	call SlideSquare2
	ld bc, wJingleStep
	ld hl, Jingle11_Slide
	jp SlideSquare1
.x4625
	call CountDownJingleRepeat
	jp z, Jingle11_End
	ld a, $01
	ld [bc], a
	jr .x4616

Jingle11_Data::
Jingle11_Slide:
	db $00, $21
Jingle11_Sq2:
	db $45, $0c, $00, $84, $12
Jingle11_Sq1:
	db $00, $85, $0b, $00, $81, $12

Jingle11_End::
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ld hl, Square2Off
	call WriteSquare2Regs
	jp SilenceJingle

Jingle12_Start::
	ld a, [wActiveJingle]
	cp $13
	jp z, IgnoreJingle
	ld a, $08
	ld [wJingleRepeat], a
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	ld hl, Jingle12_Sq2
	call SaveSquare2Freq
	call WriteSquare2Regs
	ld hl, Jingle12_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle12_Update::
	call NextSfxStep
	cp $02
	jr z, .x4685
.x4676
	ld hl, Jingle12_Slide
	call SlideSquare2
	ld bc, wJingleStep
	ld hl, Jingle12_Slide
	jp SlideSquare1
.x4685
	call CountDownJingleRepeat
	jp z, Jingle11_End
	ld a, $01
	ld [bc], a
	jr .x4676

Jingle12_Data::
Jingle12_Slide:
	db $ff, $d0
Jingle12_Sq2:
	db $40, $0a, $b0, $87, $12
Jingle12_Sq1:
	db $00, $80, $09, $c0, $86, $12

Jingle13_Start::
	ld a, $05
	ld [wJingleRepeat], a
	ldh a, [rNR50]
	cp $77
	jr nz, .x46b1
	ld hl, Jingle13_Sq1
.x46ab
	call SaveSquare1Freq
	jp StartJingle
.x46b1
	ld hl, Jingle13_Sq1_2
	jr .x46ab

Jingle13_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $03
	ld [de], a
	call NextSfxStep
	cp $04
	jr z, .x46ca
.x46c4
	ld hl, Jingle13_Slide
	jp SlideSquare1
.x46ca
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $01
	ld [bc], a
	jr .x46c4

Jingle13_Data::
Jingle13_Slide:
	db $00, $22, $00, $19, $ff, $c5
Jingle13_Sq1:
	db $00, $80, $a4, $7b, $87, $03
Jingle13_Sq1_2:
	db $00, $80, $f3, $7b, $87, $03

Jingle14_Start::
	ld a, [wActiveJingle]
	and a
	jp nz, IgnoreJingle
	ld hl, Jingle14_Sq1
	jp StartJingle

Jingle14_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle14_Sq1::
	db $35, $b0, $60, $20, $c7, $04

Jingle15_Start::
	ld hl, Jingle15_Sq1
	jp StartJingle

Jingle15_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jp z, EndJingle
	ld hl, Jingle15_Sq1Table
	call GetSfxTableEntry
	jp WriteSquare1Regs

Jingle15_Data::
Jingle15_Sq1Table:
	dw Jingle15_Sq1_2, Jingle15_Sq1_3
Jingle15_Sq1:
	db $00, $b0, $19, $4f, $c7, $06
Jingle15_Sq1_2:
	db $00, $b0, $19, $7b, $c7, $06
Jingle15_Sq1_3:
	db $00, $b0, $29, $9d, $c7, $03

Jingle16_Start::
	ld hl, Jingle16_Sq1
	jp StartJingle

Jingle16_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle16_Sq1::
	db $00, $00, $81, $bb, $c7, $20

Jingle17_Start::
	ld a, $2a
	ld [wJingleRepeat], a
	ld hl, Jingle17_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle17_Update::
	call NextSfxStep
	cp $03
	jr z, .x4760
.x475a
	ld hl, Jingle17_Slide
	jp SlideSquare1
.x4760
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $0e
	jr z, .x4773
	cp $1c
	jr z, .x4773
	ld a, $01
	ld [bc], a
	jr .x475a
.x4773
	ld hl, Jingle17_Slide
	call SlideSquare1
	xor a
	ld [wJingleStep], a
	ret

Jingle17_Data::
Jingle17_Slide:
	db $00, $20, $ff, $e8, $ff, $90
Jingle17_Sq1:
	db $00, $80, $d7, $68, $87, $01

Jingle18_Start::
	ld hl, Jingle18_Sq1
	jp StartJingle

Jingle18_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, SilenceJingle
	ld hl, Jingle18_Sq1_2
	jp WriteSquare1Regs

Jingle18_Data::
Jingle18_Sq1:
	db $2f, $80, $60, $e0, $86, $14
Jingle18_Sq1_2:
	db $2f, $80, $10, $e0, $86, $14

Jingle19_Start::
	ld hl, Jingle19_Sq1
	jp StartLockedJingle

Jingle19_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndJingle
	ld hl, Jingle19_Sq1Table
	call GetSfxTableEntry
	jp WriteSquare1Regs

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

Jingle1A_Start::
	ld a, [wActiveJingle]
	cp $1a
	jp z, IgnoreJingle
	ld hl, Jingle1A_Sq1
	jp StartJingle

Jingle1A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, SilenceJingle
	ld hl, Jingle1A_Sq1Freq
	jp WriteSquare1Freq

Jingle1A_Data::
Jingle1A_Sq1:
	db $00, $80, $34, $90, $87, $01
Jingle1A_Sq1Freq:
	db $c8, $07, $04

Jingle1B_Start::
	ld a, $03
	ld [wJingleRepeat], a
	ld hl, Jingle1B_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle1B_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $04
	ld [de], a
	call NextSfxStep
	cp $08
	jr z, .x483a
	ld hl, Jingle1B_Slide
	jp SlideSquare1
.x483a
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $02
	jr z, .x4850
	ld hl, Jingle1B_Sq1_3
.x4847
	call SaveSquare1Freq
	ld a, $04
	ld [bc], a
	jp WriteSquare1Regs
.x4850
	ld hl, Jingle1B_Sq1_2
	jr .x4847

Jingle1B_Data::
Jingle1B_Slide:
	db $00, $2a, $00, $2e, $00, $25, $00, $07, $00, $15, $00, $17, $00, $13
Jingle1B_Sq1:
	db $00, $00, $4c, $f7, $86, $04
Jingle1B_Sq1_2:
	db $00, $40, $40, $7b, $87, $04
Jingle1B_Sq1_3:
	db $00, $80, $10, $7b, $87, $04

Jingle1C_Start::
	ld a, $2c
	ld [wJingleRepeat], a
	ld hl, Jingle1C_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle1C_Update::
	call NextSfxStep
	cp $03
	jr z, .x4894
	cp $05
	jr z, .x48b0
.x488e
	ld hl, Jingle1C_Slide
	jp SlideSquare1
.x4894
	call CountDownJingleRepeat
	cp $18
	jr z, .x48a4
	cp $17
	jr z, .x48b0
	ld a, $01
	ld [bc], a
	jr .x488e
.x48a4
	ld a, $02
	ld [bc], a
	ld hl, Jingle1C_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs
.x48b0
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $03
	ld [bc], a
	jr .x488e

Jingle1C_Data::
Jingle1C_Slide:
	db $00, $ae, $ff, $60, $00, $aa, $ff, $60
Jingle1C_Sq1:
	db $00, $40, $0c, $00, $85, $01
Jingle1C_Sq1_2:
	db $00, $40, $a4, $40, $86, $01

Jingle1D_Start::
	ld a, $08
	ld [wJingleRepeat], a
	ld hl, Jingle1D_Sq1
	jp StartJingle

Jingle1D_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $79
	ldh [rNR11], a
	call NextSfxStep
	cp $03
	jr z, .x48f2
.x48e9
	ld hl, Jingle1D_Sq1FreqTable
	call GetSfxTableEntry
	jp WriteSquare1Freq
.x48f2
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $02
	ld [bc], a
	jr .x48e9

Jingle1D_Data::
Jingle1D_Sq1FreqTable:
	dw Jingle1D_Sq1Freq_2, Jingle1D_Sq1Freq
Jingle1D_Sq1:
	db $00, $79, $e0
Jingle1D_Sq1Freq:
	db $c0, $c4, $02
Jingle1D_Sq1Freq_2:
	db $c0, $c4, $0c

Jingle1E_Start::
	ld hl, Jingle1E_Sq1
	jp StartLockedJingle

Jingle1E_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndJingle
	ld hl, Jingle1E_Sq1FreqTable
	call GetSfxTableEntry
	jp WriteSquare1Freq

Jingle1E_Data::
Jingle1E_Sq1FreqTable:
	dw Jingle1E_Sq1Freq, Jingle1E_Sq1Freq, Jingle1E_Sq1Freq_2, Jingle1E_Sq1Freq_2
Jingle1E_Sq1:
	db $1f, $a6, $e1, $00, $c7, $10
Jingle1E_Sq1Freq:
	db $a0, $c6, $09
Jingle1E_Sq1Freq_2:
	db $00, $c6, $18

Jingle1F_Start::
	ld a, $0a
	ld [wJingleRepeat], a
	ld hl, Jingle1F_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle1F_Update::
	call NextSfxStep
	cp $09
	jr z, .x4954
.x494e
	ld hl, Jingle1F_Slide
	jp SlideSquare1
.x4954
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $01
	ld [bc], a
	jr .x494e

Jingle1F_Data::
Jingle1F_Slide:
	db $00, $30, $00, $60, $00, $60, $00, $30, $ff, $c0, $ff, $80, $ff, $80, $ff, $c0
Jingle1F_Sq1:
	db $00, $80, $0b, $20, $86, $01

Jingle20_Start::
	ld a, [wActiveJingle]
	cp $20
	jr z, .x4980
	and a
	jp nz, IgnoreJingle
.x4980
	ld a, $08
	ld [wJingleRepeat], a
	ld hl, Jingle20_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle20_Update::
	call NextSfxStep
	cp $03
	jr z, .x499b
.x4995
	ld hl, Jingle20_Slide
	jp SlideSquare1
.x499b
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $01
	ld [bc], a
	jr .x4995

Jingle20_Data::
Jingle20_Slide:
	db $00, $c0, $ff, $a0
Jingle20_Sq1:
	db $00, $80, $f1, $80, $83, $01

Jingle21_Start::
	ld a, $1c
	ld [wJingleRepeat], a
	ld hl, Jingle21_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle21_Update::
	call NextSfxStep
	cp $02
	jr z, .x49cb
.x49c5
	ld hl, Jingle21_Slide
	jp SlideSquare1
.x49cb
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $14
	jr z, .x49de
	cp $0a
	jr z, .x49e9
	ld a, $01
	ld [bc], a
	jr .x49c5
.x49de
	xor a
	ld [bc], a
	ld hl, Jingle21_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs
.x49e9
	xor a
	ld [bc], a
	ld hl, Jingle21_Sq1_3
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle21_Data::
Jingle21_Slide:
	db $ff, $ff
Jingle21_Sq1:
	db $00, $00, $19, $b0, $87, $01
Jingle21_Sq1_2:
	db $00, $00, $62, $a7, $87, $01
Jingle21_Sq1_3:
	db $00, $00, $10, $a7, $87, $01

Jingle22_Start::
	ld a, [wActiveJingle]
	cp $22
	jp z, IgnoreJingle
	ld bc, wJingle22Count
	call NextSfxStep
	cp $04
	jr nc, .x4a20
.x4a1a
	ld hl, Jingle22_Sq1
	jp StartJingle
.x4a20
	cp $06
	jr nc, .x4a2a
.x4a24
	ld hl, Jingle22_Sq1_2
	jp StartJingle
.x4a2a
	cp $08
	jr nc, .x4a34
.x4a2e
	ld hl, Jingle22_Sq1_3
	jp StartJingle
.x4a34
	cp $09
	jr nc, .x4a3e
	ld hl, Jingle22_Sq1_4
	jp StartJingle
.x4a3e
	cp $0b
	jr nc, .x4a44
	jr .x4a2e
.x4a44
	cp $0d
	jr z, .x4a4a
	jr .x4a24
.x4a4a
	ld a, $01
	ld [bc], a
	jr .x4a1a

Jingle22_Update::
	jp EndJingle

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

Jingle23_Start::
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	ld hl, Jingle23_Sq1
	jp StartLockedJingle

Jingle23_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jr z, .x4a97
	ld hl, Jingle23_Sq2Table
	call GetSfxTableEntry
	ld a, [wJingleStep]
	and $01
	jp nz, WriteSquare2Regs
	jp WriteSquare1Regs
.x4a97
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	jp SilenceJingle

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

Jingle24_Start::
	ld hl, Jingle24_Sq1
	jp StartJingle

Jingle24_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle24_Sq1::
	db $27, $80, $83, $00, $86, $18

Jingle25_Start::
	ld a, $07
	ld [wJingleRepeat], a
	ld hl, Jingle25_Sq1
	jp StartLockedJingle

Jingle25_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $06
	jr z, .x4b0f
	cp $07
	jr z, .x4b1a
.x4b06
	ld hl, Jingle25_Sq1FreqTable
	call GetSfxTableEntry
	jp WriteSquare1Freq
.x4b0f
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $06
	ld [bc], a
	jr .x4b06
.x4b1a
	ld a, $03
	ld [bc], a
	jr .x4b06

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

Jingle26_Start::
	ld a, $0e
	ld [wJingleRepeat], a
	ld hl, Jingle26_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle26_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $03
	ld [de], a
	call NextSfxStep
	cp $04
	jr z, .x4b65
.x4b5f
	ld hl, Jingle26_Slide
	jp SlideSquare1
.x4b65
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $09
	jr z, .x4b74
	ld a, $01
	ld [bc], a
	jr .x4b5f
.x4b74
	xor a
	ld [bc], a
	ld hl, Jingle26_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle26_Data::
Jingle26_Slide:
	db $ff, $e0, $00, $20, $ff, $fc
Jingle26_Sq1:
	db $00, $00, $0c, $f0, $87, $03
Jingle26_Sq1_2:
	db $00, $00, $a7, $dc, $87, $03

Jingle27_Start::
	ld hl, Jingle27_Sq1
	jp StartJingle

Jingle27_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, SilenceJingle
	ld a, $1e
	ldh [rNR10], a
	ld a, $18
	ld [de], a
	ret

Jingle27_Sq1::
	db $14, $40, $c0, $00, $81, $0c

Jingle28_Start::
	ld hl, Jingle28_Sq1
	jp StartJingle

Jingle28_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndJingle
	ld hl, Jingle28_Sq1FreqTable
	call GetSfxTableEntry
	ld a, $bd
	ldh [rNR11], a
	jp WriteSquare1Freq

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

Jingle29_Start::
	ld hl, Jingle29_Sq1
	jp StartJingle

Jingle29_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndJingle
	ld a, $1e
	ldh [rNR10], a
	ld a, $06
	ld [de], a
	ret

Jingle29_Sq1::
	db $17, $96, $49, $60, $c6, $04

Jingle2A_Start::
	ld hl, Jingle2A_Sq1
	jp StartJingle

Jingle2A_Update::
	call CountDownSfxTimer
	ret nz
	jp SilenceJingle

Jingle2A_Sq1::
	db $16, $00, $f0, $00, $c2, $10

Jingle2B_Start::
	ld a, $2c
	ld [wJingleRepeat], a
	ld hl, Jingle2B_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle2B_Update::
	call NextSfxStep
	cp $0b
	jr z, .x4c47
.x4c41
	ld hl, Jingle2B_Slide
	jp SlideSquare1
.x4c47
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $0c
	jr z, .x4c56
	ld a, $01
	ld [bc], a
	jr .x4c41
.x4c56
	xor a
	ld [bc], a
	ld hl, Jingle2B_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle2B_Data::
Jingle2B_Slide:
	db $00, $08, $ff, $f0, $00, $08, $ff, $fc, $00, $06, $ff, $f8, $00, $06, $ff, $fa
	db $00, $08, $ff, $ff
Jingle2B_Sq1:
	db $00, $00, $0f, $d0, $87, $02
Jingle2B_Sq1_2:
	db $00, $00, $f7, $f0, $87, $04

Jingle2C_Start::
	ld a, $22
	ld [wJingleRepeat], a
	ld hl, Jingle2C_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle2C_Update::
	call NextSfxStep
	cp $07
	jr z, .x4c9c
.x4c96
	ld hl, Jingle2C_Slide
	jp SlideSquare1
.x4c9c
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $1e
	jr z, .x4cb2
	cp $06
	jr z, .x4cbe
	ld a, $01
	ld bc, wJingleStep
	ld [bc], a
	jr .x4c96
.x4cb2
	ld hl, Jingle2C_Sq1_2
.x4cb5
	ld a, $01
	ld [bc], a
	call SaveSquare1Freq
	jp WriteSquare1Regs
.x4cbe
	ld hl, Jingle2C_Sq1_3
	jr .x4cb5

Jingle2C_Data::
Jingle2C_Slide:
	db $00, $02, $00, $01, $ff, $f0, $ff, $e0, $ff, $c0, $00, $71
Jingle2C_Sq1:
	db $00, $00, $0f, $00, $87, $01
Jingle2C_Sq1_2:
	db $00, $00, $40, $10, $87, $01
Jingle2C_Sq1_3:
	db $00, $00, $47, $70, $87, $01

Jingle2D_Start::
	ld a, $03
	ld [wJingleRepeat], a
	ld hl, Jingle2D_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle2D_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $08
	ld [de], a
	call NextSfxStep
	cp $05
	jr z, .x4d03
.x4cfd
	ld hl, Jingle2D_Slide
	jp SlideSquare1
.x4d03
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $01
	jr z, .x4d12
.x4d0d
	ld a, $01
	ld [bc], a
	jr .x4cfd
.x4d12
	ld a, $65
	ldh [rNR12], a
	jr .x4d0d

Jingle2D_Data::
Jingle2D_Slide:
	db $00, $04, $ff, $dd, $00, $06, $00, $19
Jingle2D_Sq1:
	db $00, $80, $1f, $b6, $87, $08

Jingle2E_Start::
	ld a, $09
	ld [wJingleRepeat], a
	ld hl, Jingle2E_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle2E_Update::
	call NextSfxStep
	cp $29
	jr z, .x4d41
.x4d3b
	ld hl, Jingle2E_Slide
	jp SlideSquare1
.x4d41
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $03
	jr z, .x4d50
	ld a, $01
	ld [bc], a
	jr .x4d3b
.x4d50
	xor a
	ld [bc], a
	ld hl, Jingle2E_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

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

Jingle2F_Start::
	ld a, $07
	ld [wJingleRepeat], a
	ld hl, Jingle2F_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle2F_Update::
	call NextSfxStep
	cp $07
	jr z, .x4dd2
.x4dcc
	ld hl, Jingle2F_Slide
	jp SlideSquare1
.x4dd2
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $01
	ld [bc], a
	jr .x4dcc

Jingle2F_Data::
Jingle2F_Slide:
	db $00, $80, $00, $60, $00, $40, $ff, $c0, $ff, $a0, $ff, $88
Jingle2F_Sq1:
	db $00, $80, $f2, $00, $85, $01

Jingle30_Start::
	ld a, $0a
	ld [wJingleRepeat], a
	ld hl, Jingle30_Sq1
	jp StartJingle

Jingle30_Update::
	call CountDownSfxTimer
	ret nz
	call CountDownJingleRepeat
	jp z, EndJingle
	ld hl, Jingle30_Sq1
	jp WriteSquare1Regs

Jingle30_Sq1::
	db $17, $bc, $64, $44, $c7, $02

Jingle31_Start::
	ld a, $14
	ld [wJingleRepeat], a
	ld hl, Jingle31_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle31_Update::
	call NextSfxStep
	cp $03
	jr z, .x4e2b
.x4e25
	ld hl, Jingle31_Slide
	jp SlideSquare1
.x4e2b
	call CountDownJingleRepeat
	jp z, EndJingle
	cp $10
	jr z, .x4e3a
	ld a, $01
	ld [bc], a
	jr .x4e25
.x4e3a
	ld hl, Jingle31_Sq1_2
	ld a, $01
	ld [bc], a
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle31_Data::
Jingle31_Slide:
	db $ff, $fc, $00, $02
Jingle31_Sq1:
	db $00, $00, $19, $ea, $87, $01
Jingle31_Sq1_2:
	db $00, $00, $47, $e0, $87, $01

Jingle32_Start::
	ld hl, Jingle32_Sq1
	jp StartLockedJingle

Jingle32_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jp z, SilenceJingle
	ld hl, Jingle32_Sq1Table
	call GetSfxTableEntry
	jp WriteSquare1Regs

Jingle32_Data::
Jingle32_Sq1Table:
	dw Jingle32_Sq1_2, Jingle32_Sq1_3
Jingle32_Sq1:
	db $1f, $80, $85, $a0, $87, $0c
Jingle32_Sq1_2:
	db $1f, $80, $47, $a0, $87, $0c
Jingle32_Sq1_3:
	db $1f, $8d, $20, $a0, $c7, $0c

Jingle33_Start::
	ld a, $02
	ld [wJingleRepeat], a
	ld hl, Jingle33_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle33_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $08
	ld [de], a
	call NextSfxStep
	cp $04
	jr z, .x4ead
	cp $05
	jr z, .x4eb8
.x4ea7
	ld hl, Jingle33_Slide
	jp SlideSquare1
.x4ead
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $04
.x4eb5
	ld [bc], a
	jr .x4ea7
.x4eb8
	ld a, $01
	jr .x4eb5

Jingle33_Data::
Jingle33_Slide:
	db $00, $08, $ff, $fd, $00, $03, $ff, $f8
Jingle33_Sq1:
	db $00, $00, $60, $d1, $87, $08

Jingle34_Start::
	ld a, $0c
	ld [wJingleRepeat], a
	ld hl, Jingle34_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle34_Update::
	call NextSfxStep
	cp $09
	jr z, .x4ee9
	cp $0a
	jr z, .x4f00
.x4ee3
	ld hl, Jingle34_Slide
	jp SlideSquare1
.x4ee9
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $09
	jr z, .x4ef5
	jr .x4ee3
.x4ef5
	xor a
	ld [bc], a
	ld hl, Jingle34_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs
.x4f00
	ld a, $01
	ld [bc], a
	jr .x4ee3

Jingle34_Data::
Jingle34_Slide:
	db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01
	db $ff, $fa
Jingle34_Sq1:
	db $00, $00, $1f, $d0, $87, $01
Jingle34_Sq1_2:
	db $00, $00, $a7, $d8, $87, $01

Jingle35_Start::
	ld a, $05
	ld [wJingleRepeat], a
	ld hl, Jingle35_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle35_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $02
	ld [de], a
	call NextSfxStep
	cp $09
	jr z, .x4f49
	cp $0a
	jr z, .x4f56
.x4f43
	ld hl, Jingle35_Slide
	jp SlideSquare1
.x4f49
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $03
	jr z, .x4f5b
	ld a, [bc]
	jr .x4f43
.x4f56
	ld a, $01
	ld [bc], a
	jr .x4f43
.x4f5b
	xor a
	ld [bc], a
	ld hl, Jingle35_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle35_Data::
Jingle35_Slide:
	db $00, $10, $00, $10, $00, $10, $00, $10, $00, $0c, $00, $08, $00, $04, $00, $02
	db $ff, $a2
Jingle35_Sq1:
	db $00, $80, $1f, $a0, $86, $02
Jingle35_Sq1_2:
	db $00, $80, $87, $a0, $86, $02

Jingle36_Start::
	ld a, $0b
	ld [wJingleRepeat], a
	ld hl, Jingle36_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle36_Update::
	call CountDownJingleRepeat
	jr z, .x4fbb
.x4f97
	ld a, [wJingleSubStep]
	cp $0d
	jr nc, .x4faf
	and $01
	jr nz, .x4fab
	ld a, $01
.x4fa4
	ld [bc], a
	ld hl, Jingle36_Slide
	jp SlideSquare1
.x4fab
	ld a, $02
	jr .x4fa4
.x4faf
	and $01
	jr nz, .x4fb7
	ld a, $03
	jr .x4fa4
.x4fb7
	ld a, $04
	jr .x4fa4
.x4fbb
	push bc
	ld bc, wJingleSubStep
	call NextSfxStep
	pop bc
	cp $05
	jr z, .x4fdb
	cp $22
	jp z, SilenceJingle
	cp $11
	jr nc, .x4fe3
.x4fd0
	sra a
	ld e, a
	ld a, $0b
	sub e
	ld [wJingleRepeat], a
	jr .x4f97
.x4fdb
	ld a, $a0
	ldh [rNR12], a
	ld a, $05
	jr .x4fd0
.x4fe3
	ld a, $11
	jr .x4fd0

Jingle36_Data::
Jingle36_Slide:
	db $00, $20, $ff, $e8, $00, $1c, $ff, $f0
Jingle36_Sq1:
	db $00, $40, $1f, $80, $83, $01

Jingle37_Start::
	ld a, $10
	ld [wJingleRepeat], a
	ld hl, Jingle37_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle37_Update::
	call NextSfxStep
	cp $09
	jr z, .x5014
	cp $0a
	jr z, .x501f
.x500e
	ld hl, Jingle37_Slide
	jp SlideSquare1
.x5014
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $09
	ld [bc], a
	jr .x500e
.x501f
	ld a, $01
	ld [bc], a
	jr .x500e

Jingle37_Data::
Jingle37_Slide:
	db $00, $40, $00, $30, $00, $20, $ff, $e0, $ff, $d0, $ff, $c0, $ff, $a0, $ff, $80
	db $00, $d0
Jingle37_Sq1:
	db $00, $80, $80, $00, $86, $01

Jingle38_Start::
	ld a, [wActiveJingle]
	and a
	jp nz, IgnoreJingle
	ld a, [wSfxFastVariant]
	and a
	jr nz, .x5052
	ld hl, Jingle38_Sq1
.x504c
	call SaveSquare1Freq
	jp StartJingle
.x5052
	ld hl, Jingle38_Sq1_2
	jr .x504c

Jingle38_Update::
	call NextSfxStep
	cp $0b
	jr z, .x5064
	ld hl, Jingle38_Slide
	jp SlideSquare1
.x5064
	ld hl, wJingleToPlay
	ld a, $38
	ld [hli], a
	xor a
	ld [hl], a
	jr Jingle38_Start

Jingle38_Data::
Jingle38_Slide:
	db $00, $c0, $00, $90, $00, $60, $00, $30, $00, $18, $ff, $e8, $ff, $d0, $ff, $a0
	db $ff, $70, $ff, $40
Jingle38_Sq1:
	db $00, $80, $a0, $00, $82, $01
Jingle38_Sq1_2:
	db $00, $80, $c0, $00, $83, $01

Jingle39_Start::
	ld a, $04
	ld [wJingleRepeat], a
	ld hl, Jingle39_Sq1
	call SaveSquare1Freq
	jp StartLockedJingle

Jingle39_Update::
	call NextSfxStep
	cp $0e
	jr z, .x50ba
	cp $0f
	jr z, .x50c5
.x50a7
	ld a, [wJingleRepeat]
	cp $03
	jr c, .x50b4
	ld hl, Jingle39_Slide
	jp SlideSquare1
.x50b4
	ld hl, Jingle39_Slide_2
	jp SlideSquare1
.x50ba
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $0e
	ld [bc], a
	jr .x50a7
.x50c5
	ld a, [wJingleRepeat]
	cp $01
	jr z, .x50d1
	ld a, $01
	ld [bc], a
	jr .x50a7
.x50d1
	xor a
	ld [bc], a
	ld hl, Jingle39_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

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

Jingle3A_Start::
	ld a, $04
	ld [wJingleRepeat], a
	ld hl, Jingle3A_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle3A_Update::
	call NextSfxStep
	cp $09
	jr z, .x513f
	cp $0a
	jr z, .x514a
.x5139
	ld hl, Jingle3A_Slide
	jp SlideSquare1
.x513f
	call CountDownJingleRepeat
	jp z, EndJingle
	ld a, $09
	ld [bc], a
	jr .x5139
.x514a
	ld a, $01
	ld [bc], a
	jr .x5139

Jingle3A_Data::
Jingle3A_Slide:
	db $00, $12, $00, $0e, $00, $0a, $00, $08, $00, $06, $00, $04, $00, $02, $00, $01
	db $ff, $c1
Jingle3A_Sq1:
	db $00, $00, $a4, $00, $87, $01

Jingle3B_Start::
	ld a, $05
	ld [wJingleRepeat], a
	ld hl, Jingle3B_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle3B_Update::
	call NextSfxStep
	cp $0c
	jr z, .x518b
	cp $0d
	jr z, .x5186
.x5180
	ld hl, Jingle3B_Slide
	jp SlideSquare1
.x5186
	ld a, $01
	ld [bc], a
	jr .x5180
.x518b
	call CountDownJingleRepeat
	jp z, SilenceJingle
	ld a, $0c
	ld [bc], a
	jr .x5180

Jingle3B_Data::
Jingle3B_Slide:
	db $ff, $c0, $ff, $a0, $00, $80, $ff, $c0, $ff, $a0, $00, $80, $ff, $c0, $ff, $a0
	db $00, $80, $ff, $c0, $ff, $a0, $01, $00
Jingle3B_Sq1:
	db $00, $00, $87, $80, $87, $01

Jingle3C_Start::
	ld a, $02
	ld [wJingleRepeat], a
	ld hl, Jingle3C_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle3C_Update::
	call NextSfxStep
	cp $09
	jr z, .x51cf
	ld hl, Jingle3C_Slide
	jp SlideSquare1
.x51cf
	call CountDownJingleRepeat
	jp z, SilenceJingle
	xor a
	ld [bc], a
	ld hl, Jingle3C_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle3C_Data::
Jingle3C_Slide:
	db $00, $02, $00, $02, $00, $02, $00, $02, $00, $01, $00, $01, $00, $01, $00, $01
Jingle3C_Sq1:
	db $00, $00, $60, $d0, $87, $02
Jingle3C_Sq1_2:
	db $00, $40, $10, $d0, $87, $01

Jingle3D_Start::
	ld a, [wActiveJingle]
	cp $04
	jp z, IgnoreJingle
	cp $05
	jp z, IgnoreJingle
	cp $07
	jp z, IgnoreJingle
	cp $03
	jp z, IgnoreJingle
	cp $0d
	jp z, IgnoreJingle
	ld a, $0a
	ld [wJingleRepeat], a
	ld hl, Jingle3D_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle3D_Update::
	call NextSfxStep
	cp $04
	jr z, .x523c
	cp $05
	jr z, .x5237
.x5231
	ld hl, Jingle3D_Slide
	jp SlideSquare1
.x5237
	ld a, $01
	ld [bc], a
	jr .x5231
.x523c
	call CountDownJingleRepeat
	jp z, .x5253
	cp $07
	jr z, .x5248
	jr .x5231
.x5248
	xor a
	ld [bc], a
	ld hl, Jingle3D_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs
.x5253
	ld a, $3d
	ld [wJingleToPlay], a
	jr Jingle3D_Start

Jingle3D_Data::
Jingle3D_Slide:
	db $00, $c0, $00, $80, $00, $40, $fe, $80
Jingle3D_Sq1:
	db $00, $40, $19, $80, $83, $01
Jingle3D_Sq1_2:
	db $00, $40, $86, $80, $83, $01

Jingle3E_Start::
	ld a, [wActiveJingle]
	cp $3e
	jp z, IgnoreJingle
	ld hl, Jingle3E_Sq1
	jp StartJingle

Jingle3E_Update::
	call CountDownSfxTimer
	ret nz
	jp EndJingle

Jingle3E_Sq1::
	db $27, $be, $60, $c0, $c7, $03

Jingle3F_Start::
	ld a, $09
	ld [wJingleRepeat], a
	ld hl, Jingle3F_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle3F_Update::
	call NextSfxStep
	cp $03
	jr z, .x52a8
	cp $04
	jr z, .x52b7
.x52a2
	ld hl, Jingle3F_Slide
	jp SlideSquare1
.x52a8
	call CountDownJingleRepeat
	jp z, SilenceJingle
	cp $06
	jr z, .x52bc
	ld a, $03
	ld [bc], a
	jr .x52a2
.x52b7
	ld a, $01
	ld [bc], a
	jr .x52a2
.x52bc
	xor a
	ld [bc], a
	ld hl, Jingle3F_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle3F_Data::
Jingle3F_Slide:
	db $00, $60, $00, $40, $ff, $70
Jingle3F_Sq1:
	db $00, $80, $19, $00, $86, $01
Jingle3F_Sq1_2:
	db $00, $80, $d1, $10, $86, $01

Jingle40_Start::
	ld a, $04
	ld [wJingleRepeat], a
	ld hl, Jingle40_Sq1
	call SaveSquare1Freq
	jp StartJingle

Jingle40_Update::
	call CountDownJingleRepeat
	jr z, .x5300
.x52ec
	ld a, [wJingleSubStep]
	cp $06
	jr nc, .x52fc
	ld a, $01
.x52f5
	ld [bc], a
	ld hl, Jingle40_Slide
	jp SlideSquare1
.x52fc
	ld a, $02
	jr .x52f5
.x5300
	push bc
	ld bc, wJingleSubStep
	call NextSfxStep
	pop bc
	cp $14
	jp z, EndJingle
	cp $06
	jp z, .x5319
	ld a, $04
	ld [wJingleRepeat], a
	jr .x52ec
.x5319
	ld a, $04
	ld [wJingleRepeat], a
	ld hl, Jingle40_Sq1_2
	call SaveSquare1Freq
	jp WriteSquare1Regs

Jingle40_Data::
Jingle40_Slide:
	db $00, $10, $ff, $f8
Jingle40_Sq1:
	db $00, $80, $1a, $80, $82, $01
Jingle40_Sq1_2:
	db $00, $80, $e5, $10, $84, $01

Jingle41_Start::
	ld hl, Jingle41_Sq1
	jp StartLockedJingle

Jingle41_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndJingle
	ld hl, Jingle41_Sq1Table
	call GetSfxTableEntry
	jp WriteSquare1Regs

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

StartLockedJingle::
	ld a, $01
	ld [wJingleLocked], a

StartJingle::
	ld a, [wJingleToPlay]
	ld [wActiveJingle], a
	xor a
	ld [wJingleTimer], a
	ld [wJingleStep], a
	ld [wJingleSubStep], a
	ld a, [wMusicChannel1 + $0F]
	set 7, a
	ld [wMusicChannel1 + $0F], a
	jp WriteSquare1Regs

SilenceJingle::
	ld hl, JingleSilence
	call WriteSquare1Regs

EndJingle::
	xor a
	ld [wActiveJingle], a
	ld [wJingleTimer], a
	ldh [rNR10], a
	ld [wJingleStep], a
	ld [wJingleRepeat], a
	ld [wSoundUnusedA0], a
	ld [wJingleLocked], a
	ld a, [wMusicChannel1 + $0F]
	res 7, a
	ld [wMusicChannel1 + $0F], a
	ret

JingleSilence::
	db $00, $3f, $00, $00, $c1, $01

WriteSquare1Freq::
	ld b, $02
	ld c, $13
	jp WriteSoundRegs

IgnoreJingle::
	xor a
	ld [wJingleToPlay], a
	jp UpdateJingle


UpdateWaveSfx::
	ld hl, wWaveSfxToPlay
	ld a, [hl]
	and a
	jr z, .x5405
	cp $14
	jr z, .x53ff
	ld a, [wWaveSfxLocked]
	and a
	jp nz, IgnoreWaveSfx
.x53ff
	ld a, [hl]
	ld hl, WaveSfxStarts
	jr .x540c
.x5405
	inc hl
	ld a, [hl]
	and a
	ret z
	ld hl, WaveSfxUpdates
.x540c
	call GetSfxTableEntry
	ld de, wWaveSfxTimer
	ld bc, wWaveSfxStep
	ld a, [wMusicBlocksWaveSfx]
	and a
	ret nz
	jp hl

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

WaveSfx01_Start::
	call LoadSfxWave2
	ld hl, WaveSfx01_Wave
	jp StartLockedWaveSfx

WaveSfx01_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $06
	jp z, EndWaveSfx
	ld hl, WaveSfx01_WaveTable
	call GetSfxTableEntry
	jp WriteWaveRegs

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

WaveSfx02_Start::
	ld a, $0c
	ld [wWaveSfxRepeat], a
	call LoadSfxWave5
	ld hl, WaveSfx02_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx02_Update::
	call NextSfxStep
	cp $02
	jr z, .x5516
	cp $0a
	jp z, SilenceWaveSfx
.x5510
	ld hl, WaveSfx02_Slide
	jp SlideWave
.x5516
	call CountDownWaveSfxRepeat
	jr z, .x5510
	ld a, $01
	ld [bc], a
	jr .x5510

WaveSfx02_Data::
WaveSfx02_Slide:
	db $00, $10, $00, $40, $00, $40, $00, $30, $00, $30, $00, $20, $00, $10, $ff, $f0
	db $ff, $e0
WaveSfx02_Wave:
	db $80, $00, $20, $80, $85, $02

WaveSfx03_Start::
	ld hl, SfxWave5
	xor a
	ldh [rNR30], a
	call LoadWaveRam
	ld hl, WaveSfx03_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx03_Update::
	call NextSfxStep
	cp $05
	jp z, EndWaveSfx
	ld hl, WaveSfx03_Slide
	jp SlideWave

WaveSfx03_Data::
WaveSfx03_Slide:
	db $01, $80, $ff, $f0, $ff, $e0
WaveSfx03_Wave:
	db $80, $ef, $20, $00, $c6, $01

WaveSfx04_Start::
	ld a, [wActiveWaveSfx]
	and a
	jp nz, IgnoreWaveSfx
	ld a, [wActiveJingle]
	cp $01
	ret z
	ld a, [wActiveJingle]
	cp $01
	ret z
	ld a, $02
	ld [wWaveSfxRepeat], a
	call LoadSfxWave5
	ld hl, WaveSfx04_Wave
	jp StartWaveSfx

WaveSfx04_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jr z, .x5596
	ld hl, WaveSfx04_WaveFreq
	jp WriteWaveFreq
.x5596
	call CountDownWaveSfxRepeat
	jp z, EndWaveSfx
	xor a
	ld [bc], a
	ld hl, WaveSfx04_Wave_2
	jp WriteWaveRegs

WaveSfx04_Data::
WaveSfx04_Wave:
	db $80, $fa, $40, $c0, $c7, $04
WaveSfx04_WaveFreq:
	db $e0, $c7, $04
WaveSfx04_Wave_2:
	db $80, $fa, $60, $c0, $c7, $04

WaveSfx05_Start::
	call LoadSfxWave2
	ld hl, WaveSfx05_Wave
	jp StartWaveSfx

WaveSfx05_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $06
	jp z, EndWaveSfx
	cp $02
	jp z, .x55db
	cp $04
	jp z, .x55e2
.x55d2
	ld hl, WaveSfx05_WaveFreqTable
	call GetSfxTableEntry
	jp WriteWaveFreq
.x55db
	ld a, $40
.x55dd
	ldh [rNR32], a
	ld a, [bc]
	jr .x55d2
.x55e2
	ld a, $60
	jr .x55dd

WaveSfx05_Data::
WaveSfx05_WaveFreqTable:
	dw WaveSfx05_WaveFreq_2, WaveSfx05_WaveFreq, WaveSfx05_WaveFreq_2, WaveSfx05_WaveFreq, WaveSfx05_WaveFreq_2
WaveSfx05_Wave:
	db $80, $fa, $20
WaveSfx05_WaveFreq:
	db $da, $c7, $02
WaveSfx05_WaveFreq_2:
	db $ea, $c7, $02

WaveSfx06_Start::
	ld a, [wActiveJingle]
	cp $01
	ret z
	ld a, $0c
	ld [wWaveSfxRepeat], a
	call LoadSfxWave4
	ld hl, WaveSfx06_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx06_Update::
	call NextSfxStep
	cp $02
	jr z, .x5628
.x5617
	ld hl, WaveSfx06_Slide
	jp SlideWave
.x561d
	xor a
	ld [bc], a
	ld hl, WaveSfx06_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs
.x5628
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $07
	jr z, .x561d
	ld a, $01
	ld [bc], a
	jr .x5617

WaveSfx06_Data::
WaveSfx06_Slide:
	db $00, $03
WaveSfx06_Wave:
	db $80, $d2, $40, $e0, $87, $01
WaveSfx06_Wave_2:
	db $80, $d2, $60, $e0, $87, $01

WaveSfx07_Start::
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
	ld a, $02
	ld [wWaveSfxRepeat], a
	call LoadSfxWave4
	ld hl, WaveSfx07_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx07_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $01
	ld [de], a
	call NextSfxStep
	cp $1d
	jr z, .x5676
	cp $15
	jr nc, .x5688
.x5670
	ld hl, WaveSfx07_Slide
	jp SlideWave
.x5676
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	ld a, $14
	ld [bc], a
	ld hl, WaveSfx07_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs
.x5688
	ld a, $02
	ld [de], a
	jr .x5670

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

WaveSfx08_Start::
	ld a, $08
	ld [wWaveSfxRepeat], a
	call LoadSfxWave1
	ld hl, WaveSfx08_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx08_Update::
	call NextSfxStep
	cp $0f
	jr z, .x56ef
.x56e9
	ld hl, WaveSfx08_Slide
	jp SlideWave
.x56ef
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	ld a, $01
	ld [bc], a
	jr .x56e9

WaveSfx08_Data::
WaveSfx08_Slide:
	db $00, $0a, $00, $06, $ff, $f0, $00, $20, $00, $0a, $00, $06, $ff, $fa, $ff, $f6
	db $00, $20, $00, $0a, $00, $06, $ff, $fa, $ff, $f6, $ff, $a8
WaveSfx08_Wave:
	db $80, $00, $20, $60, $87, $00
SfxWave7:
	db $8a, $df, $fd, $a8, $87, $42, $24, $78, $8a, $df, $fd, $a8, $87, $42, $24, $78

LoadSfxWave7::
	ld hl, SfxWave7
	jp LoadSfxWave

WaveSfx09_Start::
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	call LoadSfxWave7
	ld hl, WaveSfx09_Wave
	jp StartLockedWaveSfx

WaveSfx09_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $14
	jr z, WaveSfx09_End
	ld hl, WaveSfx09_Sq2Table
	call GetSfxTableEntry

WaveSfx09_PlayStep::
	ld a, [wWaveSfxStep]
	and $01
	jp nz, WriteSquare2Regs
	jp WriteWaveRegs

WaveSfx09_End::
	ld hl, Square2Off
	call WriteSquare2Regs
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	jp SilenceWaveSfx

WaveSfx09_Data::
WaveSfx09_Sq2Table:
	dw WaveSfx09_Sq2_10, WaveSfx09_Sq2, WaveSfx09_Sq2_11, WaveSfx09_Sq2_2, WaveSfx09_Sq2_12, WaveSfx09_Sq2_3, WaveSfx09_Sq2_13, WaveSfx09_Sq2_4
	dw WaveSfx09_Sq2_14, WaveSfx09_Sq2_5, WaveSfx09_Sq2_15, WaveSfx09_Sq2_6, WaveSfx09_Sq2_16, WaveSfx09_Sq2_7, WaveSfx09_Sq2_17, WaveSfx09_Sq2_8
	dw WaveSfx09_Sq2_18, WaveSfx09_Sq2_9, WaveSfx09_Sq2_19
WaveSfx09_Wave:
	db $80, $e6, $20, $8a, $c7, $08
WaveSfx09_Sq2:
	db $80, $e6, $20, $97, $c7
	db $08
WaveSfx09_Sq2_2:
	db $80, $60, $20, $9c, $c7
	db $08
WaveSfx09_Sq2_3:
	db $80, $e6, $20, $8a, $c7
	db $08
WaveSfx09_Sq2_4:
	db $80, $e6, $20, $97, $c7
	db $08
WaveSfx09_Sq2_5:
	db $80, $e6, $20, $9c, $c7
	db $08
WaveSfx09_Sq2_6:
	db $80, $e6, $20, $97, $c7
	db $08
WaveSfx09_Sq2_7:
	db $80, $e6, $20, $8a, $c7
	db $08
WaveSfx09_Sq2_8:
	db $80, $e6, $20, $62, $c7
	db $08
WaveSfx09_Sq2_9:
	db $80, $00, $20, $79, $c7
	db $08
WaveSfx09_Sq2_10:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_11:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_12:
	db $80, $20, $9c, $87, $34
WaveSfx09_Sq2_13:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_14:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_15:
	db $80, $20, $9c, $87, $02
WaveSfx09_Sq2_16:
	db $80, $20, $97, $87, $02
WaveSfx09_Sq2_17:
	db $80, $20, $8a, $87, $02
WaveSfx09_Sq2_18:
	db $80, $20, $62, $87, $02
WaveSfx09_Sq2_19:
	db $80, $20, $79, $87, $48

WaveSfx0A_Start::
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	call LoadSfxWave7
	ld hl, WaveSfx0A_Wave
	jp StartLockedWaveSfx

WaveSfx0A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $16
	jp z, WaveSfx09_End
	ld hl, WaveSfx0A_Sq2Table
	call GetSfxTableEntry
	jp WaveSfx09_PlayStep

WaveSfx0A_Data::
WaveSfx0A_Sq2Table:
	dw WaveSfx0A_Sq2_8, WaveSfx0A_Sq2, WaveSfx0A_Sq2_9, WaveSfx0A_Sq2_2, WaveSfx0A_Sq2_10, WaveSfx0A_Sq2_3, WaveSfx0A_Sq2_11, WaveSfx0A_Sq2_4
	dw WaveSfx0A_Sq2_12, WaveSfx0A_Sq2_5, WaveSfx0A_Sq2_13, WaveSfx0A_Sq2_6, WaveSfx0A_Sq2_14, WaveSfx0A_Sq2_3, WaveSfx0A_Sq2_11, WaveSfx0A_Sq2_2
	dw WaveSfx0A_Sq2_10, WaveSfx0A_Sq2, WaveSfx0A_Sq2_9, WaveSfx0A_Sq2_7, WaveSfx0A_Sq2_15
WaveSfx0A_Wave:
	db $80, $e0, $20, $9d, $c7, $04
WaveSfx0A_Sq2:
	db $80, $e0, $20, $a7, $c7
	db $04
WaveSfx0A_Sq2_2:
	db $80, $e0, $20, $b0, $c7
	db $04
WaveSfx0A_Sq2_3:
	db $80, $e0, $20, $b6, $c7
	db $04
WaveSfx0A_Sq2_4:
	db $80, $90, $20, $bd, $c7
	db $04
WaveSfx0A_Sq2_5:
	db $80, $e0, $20, $c4, $c7
	db $04
WaveSfx0A_Sq2_6:
	db $80, $e0, $20, $bd, $c7
	db $04
WaveSfx0A_Sq2_7:
	db $80, $80, $20, $9d, $c7
	db $04
WaveSfx0A_Sq2_8:
	db $80, $20, $9d, $87, $07
WaveSfx0A_Sq2_9:
	db $80, $20, $a7, $87, $07
WaveSfx0A_Sq2_10:
	db $80, $20, $b0, $87, $07
WaveSfx0A_Sq2_11:
	db $80, $20, $b6, $87, $07
WaveSfx0A_Sq2_12:
	db $80, $20, $bd, $87, $23
WaveSfx0A_Sq2_13:
	db $80, $20, $c4, $87, $07
WaveSfx0A_Sq2_14:
	db $80, $20, $bd, $87, $07
WaveSfx0A_Sq2_15:
	db $80, $20, $9d, $87, $35

WaveSfx0B_Start::
	call StopAllSound
	call LoadSfxWave7
	ld hl, WaveSfx0A_Wave
	jp StartLockedWaveSfx

WaveSfx0B_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $12
	jp z, WaveSfx09_End
	ld hl, WaveSfx0B_Sq2Table
	call GetSfxTableEntry
	jp WaveSfx09_PlayStep

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

WaveSfx0C_Start::
	ld a, $08
	ld [wWaveSfxRepeat], a
	call LoadSfxWave5
	ld hl, WaveSfx0C_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx0C_Update::
	call NextSfxStep
	cp $09
	jr z, .x5967
.x5961
	ld hl, WaveSfx0C_Slide
	jp SlideWave
.x5967
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $02
	jr z, .x5976
	ld a, $01
	ld [bc], a
	jr .x5961
.x5976
	xor a
	ld [bc], a
	ld a, $60
	ldh [rNR32], a
	ret

WaveSfx0C_Data::
WaveSfx0C_Slide:
	db $ff, $fe, $ff, $fc, $ff, $f8, $ff, $e8, $00, $14, $00, $02, $00, $04, $00, $06
WaveSfx0C_Wave:
	db $80, $00, $40, $c0, $87, $01
	db $80, $00, $60, $c0, $87, $01

WaveSfx0D_Start::
	ld a, $10
	ld [wWaveSfxRepeat], a
	call LoadSfxWave3
	ld hl, WaveSfx0D_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx0D_Update::
	call NextSfxStep
	cp $03
	jr z, .x59b7
.x59b1
	ld hl, WaveSfx0D_Slide
	jp SlideWave
.x59b7
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $08
	jr z, .x59c6
	ld a, $01
	ld [bc], a
	jr .x59b1
.x59c6
	xor a
	ld [bc], a
	ld hl, WaveSfx0D_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs

WaveSfx0D_Data::
WaveSfx0D_Slide:
	db $ff, $a0, $00, $c0
WaveSfx0D_Wave:
	db $80, $00, $20, $70, $80, $02
WaveSfx0D_Wave_2:
	db $80, $00, $60, $70, $80, $02

WaveSfx0E_Start::
	call LoadSfxWave3
	ld hl, WaveSfx0E_Wave
	jp StartWaveSfx

WaveSfx0E_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndWaveSfx
	ld hl, WaveSfx0E_WaveTable
	call GetSfxTableEntry
	jp WriteWaveRegs

WaveSfx0E_Data::
WaveSfx0E_WaveTable:
	dw WaveSfx0E_Wave_2, WaveSfx0E_Wave_3, WaveSfx0E_Wave_2, WaveSfx0E_Wave
WaveSfx0E_Wave:
	db $80, $fb, $20, $00, $c2, $03
WaveSfx0E_Wave_2:
	db $80, $fd, $40, $80, $c3, $04
WaveSfx0E_Wave_3:
	db $80, $fd, $60, $00, $c4, $05

WaveSfx0F_Start::
	ld a, [wActiveWaveSfx]
	cp $0f
	jp z, IgnoreWaveSfx
	call LoadSfxWave5
	ld hl, WaveSfx0F_Wave
	jp StartWaveSfx

WaveSfx0F_Update::
	call NextSfxStep
	cp $02
	jp z, EndWaveSfx
	ld hl, WaveSfx0F_Wave_2
	jp WriteWaveRegs

WaveSfx0F_Data::
WaveSfx0F_Wave:
	db $80, $fb, $60, $d2, $c7, $01
WaveSfx0F_Wave_2:
	db $80, $fb, $40, $d2, $c7, $02

WaveSfx10_Start::
	ld a, $02
	ld [wWaveSfxRepeat], a
	call LoadSfxWave4
	ld hl, WaveSfx10_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx10_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $01
	ld [de], a
	call NextSfxStep
	cp $71
	jr z, .x5a69
	ld hl, WaveSfx10_Slide
	jp SlideWave
.x5a69
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	ld a, $60
	ld [bc], a
	ld hl, WaveSfx10_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs

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

WaveSfx11_Start::
	ld a, $0c
	ld [wWaveSfxRepeat], a
	call LoadSfxWave2
	ld hl, WaveSfx11_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx11_Update::
	call NextSfxStep
	cp $03
	jr z, .x5b85
	ld hl, WaveSfx11_Slide
	jp SlideWave
.x5b85
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $06
	jp z, .x5b9e
	cp $03
	jp z, .x5ba9
	ld a, $01
	ld [bc], a
	ld hl, WaveSfx11_Slide
	jp SlideWave
.x5b9e
	ld hl, WaveSfx11_Wave_2
.x5ba1
	call SaveWaveFreq
	xor a
	ld [bc], a
	jp WriteWaveRegs
.x5ba9
	ld hl, WaveSfx11_Wave_3
	jr .x5ba1

WaveSfx11_Data::
WaveSfx11_Slide:
	db $00, $e0, $ff, $a0
WaveSfx11_Wave:
	db $80, $00, $20, $00, $84, $01
WaveSfx11_Wave_2:
	db $80, $00, $40, $80, $85, $01
WaveSfx11_Wave_3:
	db $80, $00, $60, $80, $85, $01

WaveSfx12_Start::
	ld a, $12
	ld [wWaveSfxRepeat], a
	call LoadSfxWave2
	ld hl, WaveSfx12_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx12_Update::
	call NextSfxStep
	cp $03
	jr z, .x5be2
.x5bdc
	ld hl, WaveSfx12_Slide
	jp SlideWave
.x5be2
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $06
	jr z, .x5bf1
	ld a, $01
	ld [bc], a
	jr .x5bdc
.x5bf1
	xor a
	ld [bc], a
	ld hl, WaveSfx12_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs

WaveSfx12_Data::
WaveSfx12_Slide:
	db $01, $00, $fe, $c0
WaveSfx12_Wave:
	db $80, $00, $20, $40, $86, $02
WaveSfx12_Wave_2:
	db $80, $00, $60, $c0, $84, $02

WaveSfx13_Start::
	ld a, $04
	ld [wWaveSfxRepeat], a
	call LoadSfxWave6
	ld hl, WaveSfx13_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx13_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $01
	ld [de], a
	call NextSfxStep
	cp $06
	jr z, .x5c4e
	cp $07
	jr z, .x5c35
	ld hl, WaveSfx13_Slide
	jp SlideWave
.x5c35
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $02
	jr z, .x5c5f
	cp $01
	jr z, .x5c5f
	ld hl, WaveSfx13_Wave_2
.x5c46
	xor a
	ld [bc], a
	call SaveWaveFreq
	jp WriteWaveRegs
.x5c4e
	ld a, [wWaveSfxRepeat]
	cp $01
	jr z, .x5c35
	cp $04
	ret z
	ld a, $06
	ld [de], a
	xor a
	ldh [rNR32], a
	ret
.x5c5f
	ld hl, WaveSfx13_Wave_3
	jr .x5c46

WaveSfx13_Data::
WaveSfx13_Slide:
	db $02, $40, $01, $40, $ff, $f2, $00, $0e, $ff, $f2
WaveSfx13_Wave:
	db $80, $00, $20, $16, $84, $01
WaveSfx13_Wave_2:
	db $80, $00, $20, $26, $84, $01
WaveSfx13_Wave_3:
	db $80, $00, $20, $08, $84, $01

WaveSfx14_Start::
	ld a, [wActiveWaveSfx]
	cp $14
	jp z, IgnoreWaveSfx
	ld a, $04
	ld [wWaveSfxRepeat], a
	call LoadSfxWave2
	ld hl, WaveSfx14_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx14_Update::
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	ld a, $01
	ld [bc], a
	ld hl, WaveSfx14_Slide
	jp SlideWave

WaveSfx14_Data::
WaveSfx14_Slide:
	db $00, $0e
WaveSfx14_Wave:
	db $80, $00, $40, $80, $87, $01

WaveSfx15_Start::
	call LoadSfxWave1
	ld hl, WaveSfx15_Wave
	jp StartLockedWaveSfx

WaveSfx15_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $06
	jp z, EndWaveSfx
	ld hl, WaveSfx15_WaveTable
	call GetSfxTableEntry
	jp WriteWaveRegs

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

WaveSfx16_Start::
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
	cp $07
	jp z, IgnoreWaveSfx
	ld a, $02
	ld [wWaveSfxRepeat], a
	call LoadSfxWave4
	ld hl, WaveSfx16_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx16_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $01
	ld [de], a
	ld a, [bc]
	cp $07
	jr nc, .x5d33
.x5d26
	call NextSfxStep
	cp $10
	jr z, .x5d38
	ld hl, WaveSfx16_Slide
	jp SlideWave
.x5d33
	ld a, $03
	ld [de], a
	jr .x5d26
.x5d38
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	ld a, $03
	ld [bc], a
	ld hl, WaveSfx16_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs

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

WaveSfx17_Start::
	ld hl, wMusicChannel4 + $0F
	set 7, [hl]
	ld a, $03
	ld [wWaveSfxRepeat], a
	ld hl, WaveSfx17_Noise
	call WriteNoiseRegs
	call LoadSfxWave2
	ld hl, WaveSfx17_WavePattern
	call LoadSfxWave
	ld hl, WaveSfx17_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx17_Update::
	call NextSfxStep
	cp $55
	jr z, .x5dce
	cp $03
	jr z, .x5dbb
	cp $07
	jr z, .x5dc4
.x5db5
	ld hl, WaveSfx17_Slide
	jp SlideWave
.x5dbb
	ld a, $40
.x5dbd
	ldh [rNR32], a
	ld bc, wWaveSfxStep
	jr .x5db5
.x5dc4
	ld hl, WaveSfx17_Noise_2
	call WriteNoiseRegs
	ld a, $20
	jr .x5dbd
.x5dce
	call CountDownWaveSfxRepeat
	jr z, .x5dfb
	cp $01
	jr z, .x5de9
	ld a, $40
	ld [bc], a
	ld hl, WaveSfx17_Noise_3
	call WriteNoiseRegs
	ld hl, WaveSfx17_Wave_2
	call SaveWaveFreq
	jp WriteWaveRegs
.x5de9
	ld a, $40
	ld [bc], a
	ld hl, WaveSfx17_Noise_4
	call WriteNoiseRegs
	ld hl, WaveSfx17_Wave_3
	call SaveWaveFreq
	jp WriteWaveRegs
.x5dfb
	ld hl, wMusicChannel4 + $0F
	res 7, [hl]
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs
	jp SilenceWaveSfx

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

WaveSfx18_Start::
	ld a, $0e
	ld [wWaveSfxRepeat], a
	call LoadSfxWave4
	ld hl, WaveSfx18_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx18_Update::
	call NextSfxStep
	cp $03
	jr z, .x5ef5
.x5eef
	ld hl, WaveSfx18_Slide
	jp SlideWave
.x5ef5
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $07
	jr z, .x5f04
	ld a, $01
	ld [bc], a
	jr .x5eef
.x5f04
	xor a
	ld [bc], a
	ld hl, WaveSfx18_Wave
	call SaveWaveFreq
	jp WriteWaveRegs

WaveSfx18_Data::
WaveSfx18_Slide:
	db $00, $60, $ff, $00
WaveSfx18_Wave:
	db $80, $00, $20, $40, $86, $00

WaveSfx19_Start::
	call LoadSfxWave1
	ld hl, WaveSfx19_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx19_Update::
	call NextSfxStep
	cp $13
	jp z, SilenceWaveSfx
	cp $02
	jr z, .x5f3f
	cp $0e
	jr z, .x5f46
	cp $10
	jr z, .x5f4a
.x5f39
	ld hl, WaveSfx19_Slide
	jp SlideWave
.x5f3f
	ld a, $20
.x5f41
	ldh [rNR32], a
	ld a, [bc]
	jr .x5f39
.x5f46
	ld a, $40
	jr .x5f41
.x5f4a
	ld a, $60
	jr .x5f41

WaveSfx19_Data::
WaveSfx19_Slide:
	db $ff, $f0, $00, $12, $ff, $f0, $00, $12, $ff, $f0, $00, $12, $ff, $e0, $00, $1e
	db $ff, $e0, $00, $1c, $ff, $e0, $00, $1a, $ff, $e0, $00, $18, $ff, $e0, $00, $12
	db $ff, $e0, $00, $14
WaveSfx19_Wave:
	db $80, $00, $40, $30, $87, $01

WaveSfx1A_Start::
	ld a, [wActiveWaveSfx]
	cp $03
	jp z, IgnoreWaveSfx
	cp $06
	jp z, IgnoreWaveSfx
	cp $07
	jp z, IgnoreWaveSfx
	call LoadSfxWave3
	ld hl, WaveSfx1A_Wave
	jp StartWaveSfx

WaveSfx1A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $04
	jp z, EndWaveSfx
	ld hl, WaveSfx1A_WaveTable
	call GetSfxTableEntry
	jp WriteWaveRegs

WaveSfx1A_Data::
WaveSfx1A_WaveTable:
	dw WaveSfx1A_Wave_2, WaveSfx1A_Wave_3, WaveSfx1A_Wave_2
WaveSfx1A_Wave:
	db $80, $fd, $40, $20, $c0, $02
WaveSfx1A_Wave_2:
	db $80, $fd, $40, $80, $c1, $02
WaveSfx1A_Wave_3:
	db $80, $fd, $40, $00, $c2, $02

WaveSfx1B_Start::
	call LoadSfxWave1
	ld hl, WaveSfx1B_Wave
	jp StartLockedWaveSfx

WaveSfx1B_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndWaveSfx
	ld hl, WaveSfx1B_WaveTable
	call GetSfxTableEntry
	jp WriteWaveRegs

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

WaveSfx1C_Start::
	ld a, $04
	ld [wWaveSfxRepeat], a
	call LoadSfxWave1
	ld hl, WaveSfx1C_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx1C_Update::
	call NextSfxStep
	cp $07
	jr z, .x603a
	ld hl, WaveSfx1C_Slide
	jp SlideWave
.x603a
	call CountDownWaveSfxRepeat
	jp z, SilenceWaveSfx
	cp $02
	jr z, .x604f
	ld hl, WaveSfx1C_Wave_2
.x6047
	xor a
	ld [bc], a
	call SaveWaveFreq
	jp WriteWaveRegs
.x604f
	ld hl, WaveSfx1C_Wave
	jr .x6047

WaveSfx1C_Data::
WaveSfx1C_Slide:
	db $00, $06, $00, $04, $00, $02, $ff, $f8, $ff, $f0, $ff, $e8
WaveSfx1C_Wave:
	db $80, $00, $20, $60, $87, $01
WaveSfx1C_Wave_2:
	db $80, $00, $60, $60, $87, $01

WaveSfx1D_Start::
	ret

WaveSfx1D_Update::
	ret

WaveSfx1E_Start::
	ld a, $07
	ld [wWaveSfx1ECount], a
	ld a, $40
	ld [wWaveSfxRepeat], a
	call LoadSfxWave3
	ld hl, WaveSfx1E_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx1E_Update::
	call CountDownWaveSfxRepeat
	jp z, .x60a6
.x608a
	ld a, [wWaveSfx1ECount]
	cp $07
	jr z, .x609e
	cp $06
	jr z, .x60a2
	ld a, $03
.x6097
	ld [bc], a
	ld hl, WaveSfx1E_Slide
	jp SlideWave
.x609e
	ld a, $01
	jr .x6097
.x60a2
	ld a, $02
	jr .x6097
.x60a6
	push de
	ld de, wWaveSfx1ECount
	call CountDownSfxTimer
	pop de
	jp z, SilenceWaveSfx
	ld a, $40
	ld [wWaveSfxRepeat], a
	jr .x608a

WaveSfx1E_Data::
WaveSfx1E_Slide:
	db $ff, $ff, $ff, $fe, $ff, $fb
WaveSfx1E_Wave:
	db $80, $00, $20, $ff, $87, $01
WaveSfx1F_WavePattern:
	db $06, $c6, $06, $c6, $06, $c6, $06, $c6, $89, $bd, $ed, $b9, $87, $53, $23, $57

WaveSfx1F_Start::
	call StopAllSound
	ld hl, WaveSfx1F_WavePattern
	call LoadSfxWave
	ld a, $05
	ld [wWaveSfxRepeat], a
	xor a
	ld [wWaveSfx1FCount], a
	ld hl, WaveSfx1F_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx1F_Update::
	call CountDownWaveSfxRepeat
	cp $01
	jr z, .x6115
	ld a, [wWaveSfx1FCount]
	cp $11
	jr z, .x610d
	cp $0a
	jr nc, .x6111
	ld a, $01
.x6103
	ld bc, wWaveSfxStep
	ld [bc], a
	ld hl, WaveSfx1F_Slide
	jp SlideWave
.x610d
	ld a, $05
	jr .x6103
.x6111
	ld a, $03
	jr .x6103
.x6115
	push bc
	ld bc, wWaveSfx1FCount
	call NextSfxStep
	pop bc
	cp $12
	jr z, .x6135
	add $05
	ld [wWaveSfxRepeat], a
	ld a, [wWaveSfx1FCount]
	cp $0b
	jr nc, .x6131
	ld a, $02
	jr .x6103
.x6131
	ld a, $04
	jr .x6103
.x6135
	ld a, $59
	ld [wMusicTrackToPlay], a
	jp SilenceWaveSfx

WaveSfx1F_Data::
WaveSfx1F_Slide:
	db $ff, $f4, $00, $32, $ff, $f0, $00, $70, $ff, $e8
WaveSfx1F_Wave:
	db $80, $00, $40, $a0, $87, $01

WaveSfx20_Start::
	call LoadSfxWave3
	ld a, $03
	ld [wWaveSfx20Count], a
	ld a, $90
	ld [wWaveSfxRepeat], a
	ld hl, WaveSfx20_Wave
	call SaveWaveFreq
	jp StartWaveSfx

WaveSfx20_Update::
	call CountDownWaveSfxRepeat
	jr z, .x6184
.x6168
	ld a, [wWaveSfx20Count]
	cp $03
	jr z, .x617c
	cp $02
	jr z, .x6180
	ld a, $01
.x6175
	ld [bc], a
	ld hl, WaveSfx20_Slide
	jp SlideWave
.x617c
	ld a, $03
	jr .x6175
.x6180
	ld a, $02
	jr .x6175
.x6184
	push de
	ld de, wWaveSfx20Count
	call CountDownSfxTimer
	pop de
	jp z, SilenceWaveSfx
	ld a, $90
	ld [wWaveSfxRepeat], a
	jr .x6168

WaveSfx20_Data::
WaveSfx20_Slide:
	db $00, $01, $00, $02, $00, $03
WaveSfx20_Wave:
	db $80, $00, $60, $80, $84, $02

WaveSfx21_Start::
	ld a, $07
	ld [wWaveSfxRepeat], a
	ld a, [wWaveSfxToPlay]
	ld [wActiveWaveSfx], a
	ld a, $01
	ld [wWaveSfxLocked], a
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	xor a
	ld [wWaveSfxTimer], a
	ld [wWaveSfxStep], a
	ldh [rNR30], a
	ld hl, WaveSfxSilence
	call WriteWaveRegs
	ld hl, WaveSfx21_Sq2
	call SaveSquare2Freq
	jp WriteSquare2Regs

WaveSfx21_Update::
	call NextSfxStep
	cp $09
	jr z, .x61e0
	cp $0a
	jr z, .x61e8
.x61da
	ld hl, WaveSfx21_Slide
	jp SlideSquare2
.x61e0
	call CountDownWaveSfxRepeat
	jr z, .x61ed
	ld a, [bc]
	jr .x61da
.x61e8
	ld a, $01
	ld [bc], a
	jr .x61da
.x61ed
	xor a
	ld [wWaveSfxTimer], a
	ld [wWaveSfxStep], a
	ld [wActiveWaveSfx], a
	ld [wWaveSfxLocked], a
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ret

WaveSfx21_Data::
WaveSfx21_Slide:
	db $ff, $ff, $ff, $fe, $ff, $fd, $ff, $fc, $ff, $fa, $ff, $f6, $ff, $f2, $ff, $ee
	db $00, $3a
WaveSfx21_Sq2:
	db $00, $97, $80, $87, $01

WaveSfx22_Start::
	ld a, $2e
	ld [wWaveSfxRepeat], a
	xor a
	ld [wWaveSfx22Count], a
	call LoadSfxWave3
	ld hl, WaveSfx22_Wave
	call SaveWaveFreq
	jp StartLockedWaveSfx

WaveSfx22_Update::
	call CountDownWaveSfxRepeat
	jr z, .x624e
.x6236
	ld a, [wWaveSfx22Count]
	cp $01
	jr z, .x6262
	cp $02
	jr z, .x6266
	cp $03
	jr z, .x626a
	ld a, $01
.x6247
	ld [bc], a
	ld hl, WaveSfx22_Slide
	jp SlideWave
.x624e
	push bc
	ld bc, wWaveSfx22Count
	call NextSfxStep
	pop bc
	cp $04
	jp z, SilenceWaveSfx
	ld a, $2e
	ld [wWaveSfxRepeat], a
	jr .x6236
.x6262
	ld a, $02
	jr .x6247
.x6266
	ld a, $03
	jr .x6247
.x626a
	ld a, $04
	jr .x6247

WaveSfx22_Data::
WaveSfx22_Slide:
	db $00, $08, $00, $06, $00, $04, $00, $02
WaveSfx22_Wave:
	db $80, $00, $40, $30, $84, $01

WaveSfx23_Start::
	call LoadSfxWave4
	ld hl, WaveSfx23_Wave
	jp StartLockedWaveSfx

WaveSfx23_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0d
	jp z, SilenceWaveSfx
	ld hl, WaveSfx23_WaveTable
	call GetSfxTableEntry
	ld a, [wWaveSfxStep]
	cp $01
	jp z, WriteWaveRegs
	cp $02
	jp z, WriteWaveRegs
	cp $07
	jp z, WriteWaveRegs
	cp $0a
	jp z, WriteWaveRegs
	jp WriteWaveFreq

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

StartLockedWaveSfx::
	ld a, $01
	ld [wWaveSfxLocked], a

StartWaveSfx::
	ld a, [wWaveSfxToPlay]
	ld [wActiveWaveSfx], a
	push hl
	ld hl, wMusicChannel3 + $0F
	set 7, [hl]
	pop hl
	xor a
	ld [wWaveSfxTimer], a
	ld [wWaveSfxStep], a
	ldh [rNR30], a
	jp WriteWaveRegs

Unused_1F_6311::
	db $80, $00, $00, $00, $01, $01, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00
	db $00, $00, $ff, $ff, $ff, $ff

SilenceWaveSfx::
	ld hl, WaveSfxSilence
	call WriteWaveRegs

EndWaveSfx::
	xor a
	ld [wWaveSfxTimer], a
	ld [wWaveSfxStep], a
	ld [wActiveWaveSfx], a
	ldh [rNR30], a
	ld [wWaveSfxLocked], a
	ld hl, wMusicChannel3 + $0F
	res 7, [hl]
	ld a, $01
	ld [wWaveRamDirty], a
	ret

LoadWaveRam::
	push bc
	ld c, $30
.x634a
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, .x634a
	pop bc
	ret

WaveSfxSilence::
	db $80, $00, $00, $00, $81, $01

LoadSfxWave::
	xor a
	ldh [rNR30], a
	jp LoadWaveRam

LoadSfxWave3::
	ld hl, SfxWave3
	jr LoadSfxWave

LoadSfxWave4::
	ld hl, SfxWave4
	jr LoadSfxWave

LoadSfxWave2::
	ld hl, SfxWave2
	jr LoadSfxWave

LoadSfxWave5::
	ld hl, SfxWave5
	jr LoadSfxWave

LoadSfxWave6::
	ld hl, SfxWave6
	jr LoadSfxWave

LoadSfxWave1::
	ld hl, SfxWave1
	jr LoadSfxWave

WriteWaveFreq::
	ld c, $1d
	ld b, $02
	jp WriteSoundRegs

IgnoreWaveSfx::
	xor a
	ld [wWaveSfxToPlay], a
	jp UpdateWaveSfx

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

UpdateNoiseSfx::
	ld hl, wNoiseSfxToPlay
	ld a, [hl]
	and a
	jr z, .x64fc
	ld a, [wNoiseSfxLocked]
	and a
	jp nz, IgnoreNoiseSfx
	ld a, [hl]
	ld hl, NoiseSfxStarts
	jr .x6504
.x64fc
	inc hl
	ld a, [hl]
	and a
	jr z, .x650e
	ld hl, NoiseSfxUpdates
.x6504
	call GetSfxTableEntry
	ld de, wNoiseSfxTimer
	ld bc, wNoiseSfxStep
	jp hl
.x650e
	ld a, [wRoomNoiseLoop]
	and a
	ret z
	ld a, $1e
	ld [wNoiseSfxToPlay], a
	jr UpdateNoiseSfx

NoiseSfx01_Start::
	ld a, $01
	ld [wActiveNoiseSfx], a
	ld hl, NoiseSfx01_Noise
	jp WriteNoiseRegs

NoiseSfx01_Update::
	xor a
	ld [wActiveNoiseSfx], a
	ld hl, NoiseSfx01_Noise_2
	jp WriteNoiseRegs

NoiseSfx01_Data::
NoiseSfx01_Noise:
	db $3b, $80, $07, $c0, $01
NoiseSfx01_Noise_2:
	db $00, $42, $02, $c0, $04

NoiseSfx02_Start::
	ld hl, NoiseSfx02_Noise
	jp StartNoiseSfx

NoiseSfx02_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $07
	jp z, EndNoiseSfx
	ld hl, NoiseSfx02_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx03_Start::
	ld hl, NoiseSfx03_Noise
	jp StartNoiseSfx

NoiseSfx03_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $11
	jp z, EndNoiseSfx
	ld hl, NoiseSfx03_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx04_Start::
	ld hl, NoiseSfx04_Noise
	jp StartNoiseSfx

NoiseSfx04_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $04
	jp z, EndNoiseSfx
	ld hl, NoiseSfx04_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

NoiseSfx04_Data::
NoiseSfx04_NoiseTable:
	dw NoiseSfx04_Noise_2, NoiseSfx04_Noise, NoiseSfx04_Noise_3
NoiseSfx04_Noise:
	db $3b, $c0, $3e, $c0, $01
NoiseSfx04_Noise_2:
	db $33, $f0, $6e, $c0, $06
NoiseSfx04_Noise_3:
	db $36, $70, $4e, $c0, $03

NoiseSfx05_Start::
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, IgnoreNoiseSfx
	cp $03
	jp z, IgnoreNoiseSfx
	cp $0c
	jp z, IgnoreNoiseSfx
	cp $13
	jp z, IgnoreNoiseSfx
	ld hl, NoiseSfx05_Noise
	jp StartNoiseSfx

NoiseSfx05_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndNoiseSfx
	ld hl, NoiseSfx05_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx06_Start::
	ld hl, NoiseSfx06_Noise
	jp StartNoiseSfx

NoiseSfx06_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $04
	jp z, EndNoiseSfx
	ld hl, NoiseSfx06_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx07_Start::
	ld a, [wActiveNoiseSfx]
	cp $05
	jp z, IgnoreNoiseSfx
	cp $08
	jp z, IgnoreNoiseSfx
	cp $0c
	jp z, IgnoreNoiseSfx
	cp $10
	jp z, IgnoreNoiseSfx
	cp $13
	jp z, IgnoreNoiseSfx
	ld hl, NoiseSfx07_Noise
	jp StartNoiseSfx

NoiseSfx07_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndNoiseSfx
	ld hl, NoiseSfx07_Noise_2
	jp WriteNoiseRegs

NoiseSfx07_Data::
NoiseSfx07_Noise:
	db $3b, $f0, $20, $c0, $02
NoiseSfx07_Noise_2:
	db $39, $40, $20, $c0, $08

NoiseSfx08_Start::
	ld a, [wActiveNoiseSfx]
	cp $0c
	jp z, IgnoreNoiseSfx
	ld a, $03
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx08_Noise
	jp StartNoiseSfx

NoiseSfx08_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $04
	jr z, .x6703
.x66fa
	ld hl, NoiseSfx08_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6703
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x66fa

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

NoiseSfx09_Start::
	ld hl, NoiseSfx09_Noise
	jp StartNoiseSfx

NoiseSfx09_Update::
	call CountDownSfxTimer
	ret nz
	ld a, $33
	ldh [rNR41], a
	call NextSfxStep
	cp $06
	jp z, EndNoiseSfx
	ld hl, NoiseSfx09_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx0A_Start::
	ld hl, NoiseSfx0A_Noise
	jp StartNoiseSfx

NoiseSfx0A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndNoiseSfx
	ld hl, NoiseSfx0A_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

NoiseSfx0A_Data::
NoiseSfx0A_NoiseTable:
	dw NoiseSfx0A_Noise_2, NoiseSfx0A_Noise_3, NoiseSfx0A_Noise_2, NoiseSfx0A_Noise
NoiseSfx0A_Noise:
	db $37, $40, $47, $c0, $01
NoiseSfx0A_Noise_2:
	db $00, $60, $27, $80, $02
NoiseSfx0A_Noise_3:
	db $00, $a0, $15, $80, $02

NoiseSfx0B_Start::
	ld hl, NoiseSfx0B_Noise
	jp StartNoiseSfx

NoiseSfx0B_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndNoiseSfx
	ld hl, NoiseSfx0B_Noise_2
	jp WriteNoiseRegs

NoiseSfx0B_Data::
NoiseSfx0B_Noise:
	db $3c, $c0, $18, $c0, $01
NoiseSfx0B_Noise_2:
	db $3c, $60, $18, $c0, $02

NoiseSfx0C_Start::
	ld a, [wActiveNoiseSfx]
	cp $02
	jp z, IgnoreNoiseSfx
	cp $03
	jp z, IgnoreNoiseSfx
	ld hl, NoiseSfx0C_Noise
	jp StartNoiseSfx

NoiseSfx0C_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndNoiseSfx
	ld hl, NoiseSfx0C_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx0D_Start::
	ld a, $0e
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx0D_Noise
	jp StartNoiseSfx

NoiseSfx0D_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x6810
.x6807
	ld hl, NoiseSfx0D_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6810
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x6807

NoiseSfx0D_Data::
NoiseSfx0D_NoiseFreqTable:
	dw NoiseSfx0D_NoiseFreq, NoiseSfx0D_NoiseFreq_2
NoiseSfx0D_Noise:
	db $00, $67, $0f, $80, $02
NoiseSfx0D_NoiseFreq:
	db $60, $00, $02
NoiseSfx0D_NoiseFreq_2:
	db $0f, $00, $02

NoiseSfx0E_Start::
	ld hl, NoiseSfx0E_Noise
	jp StartNoiseSfx

NoiseSfx0E_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jp z, EndNoiseSfx
	ld hl, NoiseSfx0E_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

NoiseSfx0E_Data::
NoiseSfx0E_NoiseTable:
	dw NoiseSfx0E_Noise_2, NoiseSfx0E_Noise_3
NoiseSfx0E_Noise:
	db $1e, $29, $46, $c0, $10
NoiseSfx0E_Noise_2:
	db $00, $29, $64, $80, $08
NoiseSfx0E_Noise_3:
	db $00, $81, $64, $80, $06

NoiseSfx0F_Start::
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
	ld hl, NoiseSfx0F_Noise
	jp StartNoiseSfx

NoiseSfx0F_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jp z, EndNoiseSfx
	ld hl, NoiseSfx0F_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

NoiseSfx0F_Data::
NoiseSfx0F_NoiseTable:
	dw NoiseSfx0F_Noise_2, NoiseSfx0F_Noise_3
NoiseSfx0F_Noise:
	db $00, $0f, $30, $80, $20
NoiseSfx0F_Noise_2:
	db $00, $60, $03, $80, $30
NoiseSfx0F_Noise_3:
	db $00, $67, $03, $80, $20

NoiseSfx10_Start::
	ld a, $03
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx10_Noise
	jp StartNoiseSfx

NoiseSfx10_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $06
	jr z, .x68ac
	ld hl, NoiseSfx10_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x68ac
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	cp $01
	jr z, .x68bf
	ld hl, NoiseSfx10_Noise_2
.x68b9
	ld a, $01
	ld [bc], a
	jp WriteNoiseRegs
.x68bf
	ld hl, NoiseSfx10_Noise_3
	jr .x68b9

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

NoiseSfx11_Start::
	ld hl, NoiseSfx11_Noise
	jp StartNoiseSfx

NoiseSfx11_Update::
	call CountDownSfxTimer
	ret nz
	jp SilenceNoiseSfx

NoiseSfx11_Noise::
	db $00, $f0, $a0, $80, $20

NoiseSfx12_Start::
	ld hl, NoiseSfx12_Noise
	jp StartNoiseSfx

NoiseSfx12_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx12_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx13_Start::
	ld hl, NoiseSfx13_Noise
	jp StartNoiseSfx

NoiseSfx13_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $1a
	jp z, EndNoiseSfx
	ld hl, NoiseSfx13_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $11
	jr nc, .x695d
	jp WriteNoiseRegs
.x695d
	inc hl
	inc hl
	ld a, $20
	ldh [rNR42], a
	jp WriteNoiseFreq

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

NoiseSfx14_Start::
	ld hl, NoiseSfx14_Noise
	jp StartNoiseSfx

NoiseSfx14_Update::
	call NextSfxStep
	cp $07
	jp z, EndNoiseSfx
	ld hl, NoiseSfx14_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx15_Start::
	ld hl, NoiseSfx15_Noise
	jp StartNoiseSfx

NoiseSfx15_Update::
	call NextSfxStep
	cp $06
	jp z, EndNoiseSfx
	ld hl, NoiseSfx15_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx16_Start::
	ld a, [wActiveNoiseSfx]
	cp $03
	jp z, IgnoreNoiseSfx
	ld hl, NoiseSfx16_Noise
	jp StartNoiseSfx

NoiseSfx16_Update::
	call NextSfxStep
	cp $03
	jp z, EndNoiseSfx
	ld hl, NoiseSfx16_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

NoiseSfx16_Data::
NoiseSfx16_NoiseTable:
	dw NoiseSfx16_Noise_2, NoiseSfx16_Noise_3
NoiseSfx16_Noise:
	db $00, $29, $68, $80, $10
NoiseSfx16_Noise_2:
	db $3c, $c0, $50, $c0, $01
NoiseSfx16_Noise_3:
	db $3c, $c1, $18, $c0, $01

NoiseSfx17_Start::
	ld hl, NoiseSfx17_Noise
	jp StartNoiseSfx

NoiseSfx17_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndNoiseSfx
	ld hl, NoiseSfx17_Noise_2
	jp WriteNoiseRegs

NoiseSfx17_Data::
NoiseSfx17_Noise:
	db $00, $f1, $09, $80, $0e
NoiseSfx17_Noise_2:
	db $00, $62, $09, $80, $10

NoiseSfx18_Start::
	ld hl, NoiseSfx18_Noise
	jp StartNoiseSfx

NoiseSfx18_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $07
	jp z, EndNoiseSfx
	ld hl, NoiseSfx18_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx19_Start::
	ld hl, NoiseSfx19_Noise
	jp StartNoiseSfx

NoiseSfx19_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0b
	jp z, EndNoiseSfx
	ld hl, NoiseSfx19_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx1A_Start::
	ld hl, NoiseSfx1A_Noise
	jp StartLockedNoiseSfx

NoiseSfx1A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $16
	jp z, EndNoiseSfx
	ld hl, NoiseSfx1A_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx1B_Start::
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
	ld a, [wSfxFastVariant]
	and a
	jr nz, .x6ba6
	ld hl, NoiseSfx1B_Noise
.x6ba3
	jp StartNoiseSfx
.x6ba6
	ld hl, NoiseSfx1B_Noise_5
	jr .x6ba3

NoiseSfx1B_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x6bd0
	cp $06
	jp z, .x6bd9
	ld a, [wSfxFastVariant]
	and a
	jr nz, .x6bcb
.x6bc1
	ld hl, NoiseSfx1B_NoiseTable
.x6bc4
	ld a, [bc]
	call GetSfxTableEntry
	jp WriteNoiseRegs
.x6bcb
	ld hl, NoiseSfx1B_NoiseTable_2
	jr .x6bc4
.x6bd0
	ld a, [wSfxFastVariant]
	and a
	jp nz, .x6bd9
	jr .x6bc1
.x6bd9
	ld hl, wNoiseSfxToPlay
	ld a, $1b
	ld [hli], a
	xor a
	ld [hl], a
	jr NoiseSfx1B_Start

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

NoiseSfx1C_Start::
	ld a, $06
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx1C_Noise
	jp StartNoiseSfx

NoiseSfx1C_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x6c2e
.x6c25
	ld hl, NoiseSfx1C_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6c2e
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x6c25

NoiseSfx1C_Data::
NoiseSfx1C_NoiseFreqTable:
	dw NoiseSfx1C_NoiseFreq, NoiseSfx1C_NoiseFreq_2
NoiseSfx1C_Noise:
	db $00, $c0, $58, $80, $02
NoiseSfx1C_NoiseFreq:
	db $68, $80, $02
NoiseSfx1C_NoiseFreq_2:
	db $58, $80, $02

NoiseSfx1D_Start::
	ld a, $78
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx1D_Noise
	jp StartLockedNoiseSfx

NoiseSfx1D_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x6c67
.x6c5e
	ld hl, NoiseSfx1D_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6c67
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	cp $18
	jr z, .x6c76
	ld a, $01
	ld [bc], a
	jr .x6c5e
.x6c76
	ld a, $01
	ld [bc], a
	ld hl, NoiseSfx1D_Noise_2
	jp WriteNoiseRegs

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

NoiseSfx1E_Start::
	ld a, [wActiveNoiseSfx]
	and a
	jp nz, IgnoreNoiseSfx
	ld hl, NoiseSfx1E_Noise
	jp StartNoiseSfx

NoiseSfx1E_Update::
	ld a, [wRoomNoiseLoop]
	and a
	jr z, .x6cad
	call CountDownSfxTimer
	ret nz
	jp EndNoiseSfx
.x6cad
	ld hl, NoiseSfx1E_Noise_2
	call WriteNoiseRegs
	jp EndNoiseSfx

NoiseSfx1E_Data::
NoiseSfx1E_Noise:
	db $08, $60, $00, $c0, $0c
NoiseSfx1E_Noise_2:
	db $00, $67, $00, $00, $20

NoiseSfx1F_Start::
	ld a, $14
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx1F_Noise
	jp StartNoiseSfx

NoiseSfx1F_Update::
	call NextSfxStep
	cp $03
	jr z, .x6cdb
.x6cd2
	ld hl, NoiseSfx1F_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6cdb
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfx
	cp $0e
	jr z, .x6cea
	ld a, $01
	ld [bc], a
	jr .x6cd2
.x6cea
	ld a, $01
	ld [bc], a
	ld hl, NoiseSfx1F_Noise_2
	jp WriteNoiseRegs

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

NoiseSfx20_Start::
	ld hl, NoiseSfx20_Noise
	jp StartNoiseSfx

NoiseSfx20_Update::
	call NextSfxStep
	cp $03
	jr z, .x6d1d
.x6d14
	ld hl, NoiseSfx20_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6d1d
	ld a, $01
	ld [bc], a
	jr .x6d14

NoiseSfx20_Data::
NoiseSfx20_NoiseFreqTable:
	dw NoiseSfx20_NoiseFreq, NoiseSfx20_NoiseFreq_2
NoiseSfx20_Noise:
	db $00, $50, $0b, $80, $01
NoiseSfx20_NoiseFreq:
	db $0c, $00, $01
NoiseSfx20_NoiseFreq_2:
	db $0b, $00, $01

NoiseSfx22_Start::
	ld hl, NoiseSfx22_Noise
	jp StartLockedNoiseSfx

NoiseSfx22_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jp z, EndNoiseSfx
	ld hl, NoiseSfx22_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq

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

NoiseSfx23_Start::
	ld hl, NoiseSfx23_Noise
	jp StartLockedNoiseSfx

NoiseSfx23_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx23_Noise_2
	jp WriteNoiseRegs

NoiseSfx23_Data::
NoiseSfx23_Noise:
	db $00, $0f, $a8, $80, $a0
NoiseSfx23_Noise_2:
	db $00, $f7, $a8, $80, $60

NoiseSfx24_Start::
	ld hl, NoiseSfx24_Noise
	jp StartNoiseSfx

NoiseSfx24_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, EndNoiseSfx
	ld hl, NoiseSfx24_Noise_2
	jp WriteNoiseRegs

NoiseSfx24_Data::
NoiseSfx24_Noise:
	db $00, $29, $07, $80, $08
NoiseSfx24_Noise_2:
	db $00, $a7, $05, $80, $50

NoiseSfx25_Start::
	ld hl, NoiseSfx25_Noise
	jp StartLockedNoiseSfx

NoiseSfx25_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $24
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx25_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $1e
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq

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

NoiseSfx26_Start::
	ld a, $40
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx26_Noise
	jp StartNoiseSfx

NoiseSfx26_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x6e69
.x6e60
	ld hl, NoiseSfx26_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6e69
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x6e60

NoiseSfx26_Data::
NoiseSfx26_NoiseFreqTable:
	dw NoiseSfx26_NoiseFreq, NoiseSfx26_NoiseFreq_2
NoiseSfx26_Noise:
	db $00, $80, $3a, $80, $01
NoiseSfx26_NoiseFreq:
	db $39, $80, $02
NoiseSfx26_NoiseFreq_2:
	db $3a, $80, $01

NoiseSfx27_Start::
	ld hl, NoiseSfx27_Noise
	jp StartNoiseSfx

NoiseSfx27_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0d
	jp z, EndNoiseSfx
	ld hl, NoiseSfx27_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx28_Start::
	ld a, $05
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx28_Noise
	jp StartNoiseSfx

NoiseSfx28_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0c
	jr z, .x6ef8
.x6eef
	ld hl, NoiseSfx28_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6ef8
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfx
	ld a, $04
	ld [bc], a
	jr .x6eef

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

NoiseSfx29_Start::
	ld a, $05
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx29_Noise
	jp StartLockedNoiseSfx

NoiseSfx29_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $07
	jr z, .x6f4c
.x6f43
	ld hl, NoiseSfx29_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x6f4c
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x6f43

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

NoiseSfx2A_Start::
	ld a, $08
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx2A_Noise
	jp StartLockedNoiseSfx

NoiseSfx2A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0a
	jr z, .x6f9b
.x6f8a
	ld hl, NoiseSfx2A_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq
.x6f9b
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	ld a, $02
	ld [bc], a
	jr .x6f8a

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

NoiseSfx2B_Start::
	ld hl, NoiseSfx2B_Noise
	jp StartNoiseSfx

NoiseSfx2B_Update::
	call CountDownSfxTimer
	ret nz
	jp EndNoiseSfx

NoiseSfx2B_Noise::
	db $00, $f4, $7d, $80, $40

NoiseSfx2C_Start::
	ld hl, NoiseSfx2C_Noise
	jp StartNoiseSfx

NoiseSfx2C_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $14
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx2C_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $13
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq

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

NoiseSfx2D_Start::
	ld hl, NoiseSfx2D_Noise
	jp StartNoiseSfx

NoiseSfx2D_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndNoiseSfx
	ld hl, NoiseSfx2D_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx2E_Start::
	ld a, $08
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx2E_Noise
	jp StartLockedNoiseSfx

NoiseSfx2E_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0c
	jr z, .x70e7
.x70d6
	ld hl, NoiseSfx2E_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $02
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq
.x70e7
	call CountDownNoiseSfxRepeat
	jp z, SilenceNoiseSfx
	ld a, $03
	ld [bc], a
	jr .x70d6

NoiseSfx2E_Data::
NoiseSfx2E_NoiseTable:
	dw NoiseSfx2E_Noise_2, NoiseSfx2A_Noise_2, NoiseSfx2A_Noise_3, NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_7, NoiseSfx2A_Noise_9, NoiseSfx2A_Noise_8, NoiseSfx2A_Noise_7
	dw NoiseSfx2A_Noise_6, NoiseSfx2A_Noise_5, NoiseSfx2A_Noise_4
NoiseSfx2E_Noise:
	db $00, $c0, $7f, $80, $ff
NoiseSfx2E_Noise_2:
	db $7f, $80, $34

NoiseSfx2F_Start::
	ld hl, NoiseSfx2F_Noise
	jp StartNoiseSfx

NoiseSfx2F_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $02
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx2F_Noise_2
	jp WriteNoiseRegs

NoiseSfx2F_Data::
NoiseSfx2F_Noise:
	db $00, $19, $50, $80, $06
NoiseSfx2F_Noise_2:
	db $00, $65, $50, $80, $20

NoiseSfx30_Start::
	ld hl, NoiseSfx30_Noise
	jp StartNoiseSfx

NoiseSfx30_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $23
	jp z, EndNoiseSfx
	ld hl, NoiseSfx30_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx31_Start::
	ld hl, NoiseSfx31_Noise
	jp StartLockedNoiseSfx

NoiseSfx31_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $1b
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx31_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx32_Start::
	ld hl, NoiseSfx32_Noise
	jp StartNoiseSfx

NoiseSfx32_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0b
	jp z, EndNoiseSfx
	ld hl, NoiseSfx32_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx33_Start::
	ld hl, NoiseSfx33_Noise
	jp StartNoiseSfx

NoiseSfx33_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0c
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx33_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $06
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq

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

NoiseSfx34_Start::
	ld a, $2b
	ld [wNoiseSfx34CountA], a
	ld a, $15
	ld [wNoiseSfx34CountB], a
	ld hl, NoiseSfx34_Noise
	jp StartNoiseSfx

NoiseSfx34_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $05
	jr z, .x7337
	cp $0d
	jr z, .x735f
	cp $1a
	jr z, .x7346
	cp $52
	jp z, SilenceNoiseSfx
.x7308
	ld hl, NoiseSfx34_NoiseTable
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $1a
	jp z, WriteNoiseRegs
	cp $22
	jp z, WriteNoiseRegs
	cp $2a
	jp z, WriteNoiseRegs
	cp $32
	jp z, WriteNoiseRegs
	cp $3a
	jp z, WriteNoiseRegs
	cp $42
	jp z, WriteNoiseRegs
	cp $4a
	jp z, WriteNoiseRegs
	jp WriteNoiseFreq
.x7337
	push de
	ld de, wNoiseSfx34CountA
	call CountDownSfxTimer
	pop de
	jr z, .x7355
	ld a, $01
	ld [bc], a
	jr .x7308
.x7346
	push de
	ld de, wNoiseSfx34CountB
	call CountDownSfxTimer
	pop de
	jr z, .x735a
	ld a, $12
	ld [bc], a
	jr .x7308
.x7355
	ld a, $05
	ld [bc], a
	jr .x7308
.x735a
	ld a, $1a
	ld [bc], a
	jr .x7308
.x735f
	ld a, $20
	ld [wWaveSfxToPlay], a
	call UpdateWaveSfx
	ld bc, wNoiseSfxStep
	ld de, wNoiseSfxTimer
	jr .x7308

NoiseSfx34_Data::
NoiseSfx34_NoiseTable:
	dw NoiseSfx34_Noise_2, NoiseSfx34_Noise_3, NoiseSfx34_Noise_4, NoiseSfx34_Noise_5, NoiseSfx34_Noise_6, NoiseSfx34_Noise_7, NoiseSfx34_Noise_8, NoiseSfx34_Noise_9
	dw NoiseSfx34_Noise_10, NoiseSfx34_Noise_11, NoiseSfx34_Noise_12, NoiseSfx34_Noise_13, NoiseSfx34_Noise_14, NoiseSfx34_Noise_15, NoiseSfx34_Noise_16, NoiseSfx34_Noise_17
	dw NoiseSfx34_Noise_18, NoiseSfx34_Noise_19, NoiseSfx34_Noise_20, NoiseSfx34_Noise_21, NoiseSfx34_Noise_22, NoiseSfx34_Noise_23, NoiseSfx34_Noise_22, NoiseSfx34_Noise_21
	dw NoiseSfx34_Noise_20, NoiseSfx34_Noise_24, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_29, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_30, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_31, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_32, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_33, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25, NoiseSfx34_Noise_34, NoiseSfx34_Noise_25, NoiseSfx34_Noise_26, NoiseSfx34_Noise_27, NoiseSfx34_Noise_28, NoiseSfx34_Noise_27, NoiseSfx34_Noise_26
	dw NoiseSfx34_Noise_25
NoiseSfx34_Noise:
	db $00, $80, $9c, $80, $01
NoiseSfx34_Noise_2:
	db $8e, $00, $01
NoiseSfx34_Noise_3:
	db $7e, $00, $01
NoiseSfx34_Noise_4:
	db $8c, $00, $01
NoiseSfx34_Noise_5:
	db $7c, $00, $01
NoiseSfx34_Noise_6:
	db $6f, $00, $01
NoiseSfx34_Noise_7:
	db $6d, $00, $01
NoiseSfx34_Noise_8:
	db $5f, $00, $01
NoiseSfx34_Noise_9:
	db $5d, $00, $01
NoiseSfx34_Noise_10:
	db $4f, $00, $01
NoiseSfx34_Noise_11:
	db $4d, $00, $01
NoiseSfx34_Noise_12:
	db $3f, $00, $01
NoiseSfx34_Noise_13:
	db $3d, $00, $01
NoiseSfx34_Noise_14:
	db $37, $80, $02
NoiseSfx34_Noise_15:
	db $35, $80, $02
NoiseSfx34_Noise_16:
	db $27, $80, $02
NoiseSfx34_Noise_17:
	db $25, $80, $02
NoiseSfx34_Noise_18:
	db $17, $80, $02
NoiseSfx34_Noise_19:
	db $15, $80, $02
NoiseSfx34_Noise_20:
	db $14, $80, $02
NoiseSfx34_Noise_21:
	db $07, $80, $02
NoiseSfx34_Noise_22:
	db $06, $80, $02
NoiseSfx34_Noise_23:
	db $05, $80, $02
NoiseSfx34_Noise_24:
	db $00, $70, $15, $80, $02
NoiseSfx34_Noise_25:
	db $14, $80, $02
NoiseSfx34_Noise_26:
	db $07, $80, $02
NoiseSfx34_Noise_27:
	db $06, $80, $02
NoiseSfx34_Noise_28:
	db $05, $80, $02
NoiseSfx34_Noise_29:
	db $00, $60, $15, $80, $02
NoiseSfx34_Noise_30:
	db $00, $50, $15, $80, $02
NoiseSfx34_Noise_31:
	db $00, $40, $15, $80, $02
NoiseSfx34_Noise_32:
	db $00, $30, $15, $80, $02
NoiseSfx34_Noise_33:
	db $00, $20, $15, $80, $02
NoiseSfx34_Noise_34:
	db $00, $10, $15, $80, $02

NoiseSfx35_Start::
	ld a, $40
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx35_Noise
	jp StartNoiseSfx

NoiseSfx35_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $21
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx35_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx36_Start::
	ld a, $07
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx36_Noise
	jp StartLockedNoiseSfx

NoiseSfx36_Update::
	call NextSfxStep
	cp $09
	jr z, .x75a7
.x759e
	ld hl, NoiseSfx36_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq
.x75a7
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfx
	ld a, $01
	ld [bc], a
	jr .x759e

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

NoiseSfx37_Start::
	ld a, $07
	ld [wNoiseSfxRepeat], a
	call StartNoiseSfxOnSquare2
	ld hl, WaveSfx21_Sq2
	call SaveSquare2Freq
	jp WriteSquare2Regs

NoiseSfx37_Update::
	call NextSfxStep
	cp $09
	jr z, .x75f8
	cp $0a
	jr z, .x7601
.x75f2
	ld hl, WaveSfx21_Slide
	jp SlideSquare2
.x75f8
	call CountDownNoiseSfxRepeat
	jp z, EndNoiseSfxOnSquare2
	ld a, [bc]
	jr .x75f2
.x7601
	ld a, $01
	ld [bc], a
	jr .x75f2

NoiseSfx39_Start::
	ld hl, NoiseSfx39_Noise
	jp StartNoiseSfx

NoiseSfx39_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $12
	jp z, EndNoiseSfx
	ld hl, NoiseSfx39_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx38_Start::
	ld hl, NoiseSfx38_Noise
	jp StartNoiseSfx

NoiseSfx38_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $0e
	jp z, EndNoiseSfx
	ld hl, NoiseSfx38_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx3A_Start::
	xor a
	ld [wActiveJingle], a
	ld hl, wMusicChannel1 + $0F
	set 7, [hl]
	ld a, $01
	ld [wJingleLocked], a
	ld hl, NoiseSfx3A_Noise
	jp StartLockedNoiseSfx

NoiseSfx3A_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $03
	jr z, .x7748
	ld hl, NoiseSfx3A_Sq1Table
	call GetSfxTableEntry
	ld a, [wNoiseSfxStep]
	cp $01
	jp z, WriteSquare1Regs
	jp WriteNoiseRegs
.x7748
	xor a
	ldh [rNR10], a
	ld [wJingleLocked], a
	ld hl, wMusicChannel1 + $0F
	res 7, [hl]
	jp EndNoiseSfx

NoiseSfx3A_Data::
NoiseSfx3A_Sq1Table:
	dw NoiseSfx3A_Sq1, NoiseSfx3A_Sq1_2
NoiseSfx3A_Noise:
	db $00, $20, $70, $80, $01
NoiseSfx3A_Sq1:
	db $1d, $51, $82, $59, $c7, $03
NoiseSfx3A_Sq1_2:
	db $00, $42, $50, $80, $08

NoiseSfx3B_Start::
	xor a
	ld [wActiveJingle], a
	ld hl, wMusicChannel1 + $0F
	set 7, [hl]
	ld a, $01
	ld [wJingleLocked], a
	ld hl, NoiseSfx3B_Noise
	call StartLockedNoiseSfx
	ld a, $f0
	ld [wNoiseSfxRepeat], a
	ld hl, NoiseSfx3B_Sq1
	call SaveSquare1Freq
	jp WriteSquare1Regs

NoiseSfx3B_Update::
	ld hl, wAntiKirbyInhaling
	ld a, [hl]
	and a
	jr z, NoiseSfx3C_Start
	xor a
	ld [hl], a
	call CountDownNoiseSfxRepeat
	jr z, NoiseSfx3C_Start
	cp $e0
	jr z, .x77af
	cp $d8
	jr nc, .x77ab
	ld a, $02
.x77a4
	ld [bc], a
	ld hl, NoiseSfx3B_Slide
	jp SlideSquare1
.x77ab
	ld a, $01
	jr .x77a4
.x77af
	ld hl, NoiseSfx3B_Noise_2
	call WriteNoiseRegs
	ld a, $01
	ld bc, wNoiseSfxStep
	jr .x77a4

NoiseSfx3C_Start::
	xor a
	ld [wJingleLocked], a
	ld hl, wMusicChannel1 + $0F
	res 7, [hl]
	ld hl, JingleSilence
	call WriteSquare1Regs
	jp SilenceNoiseSfx

NoiseSfx3B_Data::
NoiseSfx3B_Slide:
	db $00, $02, $00, $00
NoiseSfx3B_Noise:
	db $00, $1d, $20, $80, $01
NoiseSfx3B_Noise_2:
	db $00, $60, $20, $80, $01
NoiseSfx3B_Sq1:
	db $00, $40, $10, $a0, $87, $01

NoiseSfx3D_Start::
	ld hl, NoiseSfx3D_Noise
	jp StartLockedNoiseSfx

NoiseSfx3D_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $51
	jp z, SilenceNoiseSfx
	ld hl, NoiseSfx3D_NoiseFreqTable
	call GetSfxTableEntry
	jp WriteNoiseFreq

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

NoiseSfx3E_Start::
	ld hl, NoiseSfx3E_Noise
	jp StartLockedNoiseSfx

NoiseSfx3E_Update::
	ld a, [wHoldNoiseSfx3E]
	and a
	ret nz
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $08
	jp z, EndNoiseSfx
	ld hl, NoiseSfx3E_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

NoiseSfx3F_Start::
	ld hl, NoiseSfx3F_Noise
	jp StartLockedNoiseSfx

NoiseSfx3F_Update::
	call CountDownSfxTimer
	ret nz
	call NextSfxStep
	cp $10
	jp z, EndNoiseSfx
	ld hl, NoiseSfx3F_NoiseTable
	call GetSfxTableEntry
	jp WriteNoiseRegs

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

StartLockedNoiseSfx::
	ld a, $01
	ld [wNoiseSfxLocked], a

StartNoiseSfx::
	ld a, [wNoiseSfxToPlay]
	ld [wActiveNoiseSfx], a
	xor a
	ld [wNoiseSfxTimer], a
	ld [wNoiseSfxStep], a
	ld a, [wMusicChannel4 + $0F]
	set 7, a
	ld [wMusicChannel4 + $0F], a
	jp WriteNoiseRegs

SilenceNoiseSfx::
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs

EndNoiseSfx::
	xor a
	ld [wActiveNoiseSfx], a
	ld [wNoiseSfxTimer], a
	ld [wNoiseSfxStep], a
	ld [wNoiseSfxRepeat], a
	ld [wNoiseSfxLocked], a
	ld a, [wMusicChannel4 + $0F]
	res 7, a
	ld [wMusicChannel4 + $0F], a
	ret

NoiseSfxSilence::
	db $00, $00, $00, $00, $01

WriteNoiseFreq::
	ld b, $02
	ld c, $22
	jp WriteSoundRegs

IgnoreNoiseSfx::
	xor a
	ld [wNoiseSfxToPlay], a
	jp UpdateNoiseSfx

StartNoiseSfxOnSquare2::
	ld a, [wNoiseSfxToPlay]
	ld [wActiveNoiseSfx], a
	ld hl, wMusicChannel2 + $0F
	set 7, [hl]
	ld a, $01
	ld [wNoiseSfxLocked], a
	xor a
	ld [wNoiseSfxTimer], a
	ld [wNoiseSfxStep], a
	ld hl, NoiseSfxSilence
	call WriteNoiseRegs
	ret

EndNoiseSfxOnSquare2::
	xor a
	ld [wNoiseSfxTimer], a
	ld [wNoiseSfxStep], a
	ld [wActiveNoiseSfx], a
	ld [wNoiseSfxLocked], a
	ld hl, wMusicChannel2 + $0F
	res 7, [hl]
	ret

GetSfxTableEntry::
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld h, b
	ld l, c
	ret


CountDownSfxTimer::
	ld a, [de]
	dec a
	ld [de], a
	ret


NextSfxStep::
	ld a, [bc]
	inc a
	ld [bc], a
	ret


WriteSquare1Regs::
	ld b, $05
	ld c, $10
	jr WriteSoundRegs

WriteSquare2Regs::
	ld b, $04
	ld c, $16
	jr WriteSoundRegs

WriteWaveRegs::
	ld b, $05
	ld c, $1a
	jr WriteSoundRegs

WriteNoiseRegs::
	ld b, $04
	ld c, $20
	jr WriteSoundRegs

WriteSoundRegs::
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, WriteSoundRegs
	ld a, [hl]
	ld [de], a
	ret


CountDownJingleRepeat::
	push de
	ld de, wJingleRepeat
	jr CountDownCounter

CountDownSfxRepeat2::
	push de
	ld de, wUnusedSfxRepeat
	jr CountDownCounter

CountDownWaveSfxRepeat::
	push de
	ld de, wWaveSfxRepeat
	jr CountDownCounter

CountDownNoiseSfxRepeat::
	push de
	ld de, wNoiseSfxRepeat
	jr CountDownCounter

CountDownCounter::
	call CountDownSfxTimer
	pop de
	ret


SaveSquare1Freq::
	push de
	ld de, wJingleFreq
	jr SaveFreqFromRecord

SaveWaveFreq::
	push de
	ld de, wWaveSfxFreq

SaveFreqFromRecord::
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hld]
	and $0f
	ld [de], a
	dec hl
	dec hl
	dec hl
	pop de
	ret


SaveSquare2Freq::
	push de
	ld de, wSquare2SfxFreq
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hld]
	and $0f
	ld [de], a
	dec hl
	dec hl
	pop de
	ret

SlideSquare1::
	push de
	ld de, $d3c1
	ld a, [bc]
	ld c, $13
	push bc
	jr SlideFreq

SlideWave::
	push de
	ld de, $d3c5
	ld a, [bc]
	ld c, $1d
	push bc
	jr SlideFreq

SlideFreq::
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld a, [de]
	dec e
	ld h, a
	ld a, [de]
	ld l, a
	add hl, bc
	pop bc
	ld a, l
	ldh [c], a
	ld [de], a
	inc c
	inc e
	ld a, h
	ldh [c], a
	ld [de], a
	pop de
	ret


SlideSquare2::
	push de
	ld de, $d3c3
	ld a, [bc]
	ld c, $18
	push bc
	jr SlideFreq

StopAllSound::
	ld a, $ff
	ldh [rNR51], a
	ld a, $03
	ld [wMusicPanMode], a
	xor a
	ld [wActiveMusicTrack], a
	xor a
	ld [wActiveJingle], a
	ld [wActiveWaveSfx], a
	ld [wActiveNoiseSfx], a
	ld [wMusicChannel1 + $0F], a
	ld [wMusicChannel2 + $0F], a
	ld [wMusicChannel3 + $0F], a
	ld [wMusicChannel4 + $0F], a
	ld [wMusicWaveDecay], a
	ld [wMusicWaveDecayFrame], a
	ld [wMusicWaveSwell], a
	ld [wMusicWaveSwellFrame], a
	ld [wMusicPitchDrop], a
	ld [wMusicPitchDrop + $01], a
	ld [wMusicPitchDrop + $02], a
	ld [wMusicPitchDrop + $03], a
	ld [wMusicPitchDrop + $04], a
	ld [wMusicPitchDrop + $05], a
	ld [wJingleStep], a
	ld [wUnusedSfxStep], a
	ld [wWaveSfxStep], a
	ld [wNoiseSfxStep], a
	ld [wJingleTimer], a
	ld [wUnusedSfxTimer], a
	ld [wWaveSfxTimer], a
	ld [wNoiseSfxTimer], a
	ld [wJingleLocked], a
	ld [wUnusedSfxLocked], a
	ld [wWaveSfxLocked], a
	ld [wNoiseSfxLocked], a
	ld [wSoundUnusedA0], a
	ld [wSoundUnusedA1], a
	ld [wSoundUnusedA2], a
	ld [wSoundUnusedA3], a
	ld [wMusicBlocksWaveSfx], a
	ld [wSfxFastVariant], a
	ld [wJingle22Count], a
	ld [wSoundUnusedD8], a
	ld [wWaveSfx1ECount], a
	ld [wWaveRamDirty], a
	ld [wJingleSubStep], a
	ld [wSoundUnusedE3], a
	ld [wSoundUnusedE4], a
	ld [wSoundUnusedE5], a
	ld a, $08
	ldh [rNR12], a
	ldh [rNR22], a
	ldh [rNR42], a
	ld a, $80
	ldh [rNR14], a
	ldh [rNR24], a
	ldh [rNR44], a
	xor a
	ldh [rNR10], a
	ldh [rNR30], a
	ret

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

UpdateVolumeAndSfxRequests::
	ldh a, [hVolumeFadeOutTimer]
	and a
	jr z, .x7f9e
	sub $01
	ldh [hVolumeFadeOutTimer], a
	and $03
	jr nz, .x7f9e
	ldh a, [hVolumeRight]
	and a
	jr z, .x7f95
	dec a
	ldh [hVolumeRight], a
.x7f95
	ldh a, [hVolumeLeft]
	and a
	jr z, .x7f9e
	sub $10
	ldh [hVolumeLeft], a
.x7f9e
	ldh a, [hVolumeFadeInTimer]
	and a
	jr z, .x7fbe
	sub $01
	ldh [hVolumeFadeInTimer], a
	and $01
	jr nz, .x7fbe
	ldh a, [hVolumeRight]
	cp $07
	jr nc, .x7fb4
	inc a
	ldh [hVolumeRight], a
.x7fb4
	ldh a, [hVolumeLeft]
	cp $70
	jr nc, .x7fbe
	add $10
	ldh [hVolumeLeft], a
.x7fbe
	ld hl, hVolumeRight
	ldh a, [rNR50]
	and $f8
	or [hl]
	inc hl
	and $8f
	or [hl]
	ldh [rNR50], a
	ldh a, [hJingle]
	and a
	jr z, .x7fd7
	ld [wJingleToPlay], a
	xor a
	ldh [hJingle], a
.x7fd7
	ldh a, [hWaveSfx]
	and a
	jr z, .x7fe2
	ld [wWaveSfxToPlay], a
	xor a
	ldh [hWaveSfx], a
.x7fe2
	ldh a, [hNoiseSfx]
	and a
	jr z, .x7fed
	ld [wNoiseSfxToPlay], a
	xor a
	ldh [hNoiseSfx], a
.x7fed
	ret

Padding_1F_7FEE::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
