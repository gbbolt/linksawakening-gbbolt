; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

RST_00::
	jp Jump_000_2872


	db $00, $00, $ff, $ff, $ff

RST_08::
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38

Call_0020::
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38

RST_28::
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38

Call_0038::
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38
	rst $38

VBlankInterrupt::
	jp Jump_000_0525


	db $ff, $ff, $ff, $ff, $ff

LCDCInterrupt::
	jp Jump_000_03e2


	db $ff, $ff, $ff, $ff, $ff

TimerOverflowInterrupt::
	reti


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff

SerialTransferCompleteInterrupt::
	reti


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $d9, $ff

Jump_000_0062:
	ld hl, $6900
	ld de, $89a0
	jr jr_000_0080

Jump_000_006a:
	ld hl, $6930
	ld de, $89d0
	jr jr_000_0080

Jump_000_0072:
	ld hl, $49d0
	ld de, $89d0
	jr jr_000_0080

Jump_000_007a:
	ld hl, $49a0
	ld de, $89a0

jr_000_0080:
	ld bc, $0030
	call Call_28C5
	xor a
	ldh [$ff90], a
	ldh [$ff92], a

Jump_000_008b:
	ld a, $0c
	ld [$2100], a
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

Boot::
	nop
	jp Jump_000_0150


HeaderLogo::
	db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
	db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
	db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
	db "ZELDA", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

HeaderNewLicenseeCode::
	db $00, $00

HeaderSGBFlag::
	db $00

HeaderCartridgeType::
	db $03

HeaderROMSize::
	db $04

HeaderRAMSize::
	db $02

HeaderDestinationCode::
	db $01

HeaderOldLicenseeCode::
	db $01

HeaderMaskROMVersion::
	db $02

HeaderComplementCheck::
	db $6a

HeaderGlobalChecksum::
	db $3a, $ee

Jump_000_0150:
	call Call_2881
	ld sp, $dfff
	xor a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	ld hl, $8000
	ld bc, $1800
	call Call_2999
	call Call_28A8
	call Call_298A
	ld a, $01
	ld [$2100], a
	call $7d19
	call $ffc0
	call $40ce
	call Call_2B6B
	ld a, $44
	ldh [rSTAT], a
	ld a, $4f
	ldh [rLYC], a
	ld a, $01
	ld [$dbaf], a
	ld a, $01
	ldh [rIE], a
	ld a, $01
	ld [$2100], a
	call $460f
	ld a, $1f
	ld [$2100], a
	call $4000
	ld a, $18
	ldh [$ffb5], a
	ei
	jp Jump_000_03bd


Jump_000_01a6:
	ld a, $01
	ldh [$fffd], a
	ld a, [$c500]
	and a
	jr z, jr_000_01be

	ld a, [$db95]
	cp $0b
	jr nz, jr_000_01be

	ldh a, [$ffe7]
	rrca
	and $80
	jr jr_000_01c4

jr_000_01be:
	ld hl, $c156
	ldh a, [$ff97]
	add [hl]

jr_000_01c4:
	ldh [rSCY], a
	ldh a, [$ff96]
	ld hl, $c155
	add [hl]
	ld hl, $c1bf
	add [hl]
	ldh [rSCX], a
	ld a, [$d6fe]
	and a
	jr nz, jr_000_01df

	ld a, [$d6ff]
	cp $00
	jr z, jr_000_0209

jr_000_01df:
	ld a, [$db95]
	cp $09
	jr z, jr_000_01f5

	cp $06
	jr c, jr_000_01f5

	cp $0b
	jr nz, jr_000_01fb

	ld a, [$db96]
	cp $07
	jr nc, jr_000_01fb

jr_000_01f5:
	call Call_0844
	call Call_0844

jr_000_01fb:
	di
	call Call_04A1
	ei
	call Call_0844
	call Call_0844
	jp Jump_000_03bd


jr_000_0209:
	ld a, [$d6fd]
	and $7f
	ld e, a
	ldh a, [rLCDC]
	and $80
	or e
	ldh [rLCDC], a
	ld hl, $ffe7
	inc [hl]
	ld a, [$db95]
	cp $00
	jr nz, jr_000_0230

	ld a, [$db96]
	cp $08
	jr c, jr_000_0230

	ld a, $01
	ld [$2100], a
	call $6db7

jr_000_0230:
	ld a, [$c17f]
	and a
	jp z, Jump_000_0352

	inc a
	jr nz, jr_000_0245

jr_000_023a:
	ld a, $17
	ld [$2100], a
	call $46a6
	jp Jump_000_0352


jr_000_0245:
	inc a
	jr z, jr_000_023a

	ld a, $14
	ld [$2100], a
	ld a, [$c180]
	inc a
	ld [$c180], a
	cp $c0
	jr nz, jr_000_026c

	ld a, [$c17f]
	cp $02
	jr nz, jr_000_0262

	call $541b

jr_000_0262:
	xor a
	ld [$c17f], a
	ld [$c3ca], a
	jp Jump_000_0352


jr_000_026c:
	cp $60
	jr c, jr_000_02bc

	push af
	and $07
	jr nz, jr_000_0280

	ld a, [$c3ca]
	cp $0c
	jr z, jr_000_02bb

	inc a
	ld [$c3ca], a

jr_000_0280:
	ld a, [$c3ca]
	ld e, a
	ldh a, [$ffe7]
	and $03
	add e
	ld e, a
	ld d, $00
	ld a, [$c17f]
	cp $03
	jr z, jr_000_02a8

	ld hl, $546a
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db99], a
	ld hl, $547a
	add hl, de
	ld a, [hl]
	ld [$db98], a
	jr jr_000_02bb

jr_000_02a8:
	ld hl, $548a
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db99], a
	ld hl, $549a
	add hl, de
	ld a, [hl]
	ld [$db98], a

jr_000_02bb:
	pop af

jr_000_02bc:
	srl a
	srl a
	ldh [$ffd7], a
	ld a, [$c180]
	nop
	and $e0
	ld e, a
	ld a, [$c17f]
	cp $03
	jr nz, jr_000_02d4

	ld a, e
	xor $e0
	ld e, a

jr_000_02d4:
	ld a, e
	ldh [$ffd8], a
	ld hl, $c17c
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a

Jump_000_02de:
jr_000_02de:
	ldh a, [rSTAT]
	and $03
	jr nz, jr_000_02de

	ld d, $00

jr_000_02e6:
	ld a, [$c17e]
	inc a
	ld [$c17e], a
	and $01
	jr nz, jr_000_02e6

	ld a, [$c17c]
	add $01
	ld [$c17c], a
	ld a, [$c17d]
	adc $00
	ld [$c17d], a
	ld a, [$c17c]
	cp $58
	jp z, Jump_000_033e

	ld c, $00
	ld a, [$c17f]
	cp $01
	jr z, jr_000_0313

	inc c

jr_000_0313:
	ld hl, $c17c
	ldh a, [$ffd7]
	add [hl]
	and $1f
	ld hl, $ffd8
	or [hl]
	ld e, a
	ld hl, $54aa
	add hl, de
	ld a, [$c180]
	and c
	ld a, [hl]
	jr z, jr_000_032d

	cpl
	inc a

jr_000_032d:
	push af
	ld hl, $ff96
	add [hl]
	ldh [rSCX], a
	pop af
	ld hl, $ff97
	add [hl]
	ldh [rSCY], a
	jp Jump_000_02de


Jump_000_033e:
	call Call_0844
	ld a, [$db97]
	ldh [rBGP], a
	ld a, [$db98]
	ldh [rOBP0], a
	ld a, [$db99]
	ldh [rOBP1], a
	jr jr_000_03bd

Jump_000_0352:
	ld a, [$db9a]
	ldh [rWY], a
	ld a, [$db97]
	ldh [rBGP], a
	ld a, [$db98]
	ldh [rOBP0], a
	ld a, [$db99]
	ldh [rOBP1], a
	call Call_0844
	call Call_27FE
	ldh a, [$ff90]
	ld hl, $ff91
	or [hl]
	ld hl, $c10e
	or [hl]
	jr nz, jr_000_03bd

	ld a, [$0003]
	and a
	jr z, jr_000_03aa

	ld a, [$d6fc]
	and a
	jr nz, jr_000_038a

	ldh a, [$ffcb]
	and $0f
	jr z, jr_000_03a4

jr_000_038a:
	ldh a, [$ffcc]
	and $40
	jr z, jr_000_03a4

	ld a, [$d6fc]
	xor $01
	ld [$d6fc], a
	jr nz, jr_000_03bd

	ld a, [$c17b]
	xor $10
	ld [$c17b], a
	jr jr_000_03bd

jr_000_03a4:
	ld a, [$d6fc]
	and a
	jr nz, jr_000_03bd

jr_000_03aa:
	ld a, $01
	call Call_07B9
	call $5cf0
	call Call_0A90
	ld a, $01
	ld [$2100], a
	call $5d03

Jump_000_03bd:
jr_000_03bd:
	ld a, $1f
	ld [$2100], a
	call $7f80
	ld a, $0c
	ld [$2100], a
	xor a
	ldh [$fffd], a
	halt

jr_000_03ce:
	ldh a, [$ffd1]
	and a
	jr z, jr_000_03ce

	xor a
	ldh [$ffd1], a
	jp Jump_000_01a6


	db $20, $30, $40, $60, $00, $30, $56, $68, $00

Jump_000_03e2:
	di
	push af
	push hl
	push de
	ld a, [$db95]
	cp $01
	jr nz, jr_000_0400

	ld a, [$db96]
	cp $05
	jr nz, jr_000_03f9

	ld a, [$d000]
	jr jr_000_03fb

jr_000_03f9:
	ldh a, [$ff97]

jr_000_03fb:
	ldh [rSCY], a
	jp Jump_000_0452


jr_000_0400:
	cp $00
	jr nz, jr_000_044f

	ld a, [$c105]
	ld e, a
	ld d, $00
	ld hl, $c100
	add hl, de
	ld a, [hl]
	ld hl, $ff96
	add [hl]
	ldh [rSCX], a
	ld a, [$db96]
	cp $06
	jr c, jr_000_042c

	ld hl, $03de
	add hl, de
	ld a, [hl]
	ldh [rLYC], a
	ld a, e
	inc a
	and $03
	ld [$c105], a
	jr jr_000_0452

jr_000_042c:
	ld hl, $03d9
	add hl, de
	ld a, [hl]
	ldh [rLYC], a
	ld a, e
	inc a
	cp $05
	jr nz, jr_000_043a

	xor a

jr_000_043a:
	ld [$c105], a
	nop
	cp $04
	jr nz, jr_000_044d

	ld a, [$c106]
	ldh [rSCY], a
	cpl
	inc a
	add $60
	ldh [rLYC], a

jr_000_044d:
	jr jr_000_0452

jr_000_044f:
	xor a
	ldh [rSCX], a

Jump_000_0452:
jr_000_0452:
	pop de
	pop hl
	pop af
	ei
	reti


	db $00, $00, $a5, $62, $13, $73, $0f, $6f, $01, $6f, $1e, $70, $54, $71, $51, $d6
	db $c2, $6e, $93, $73, $59, $75, $c0, $74, $2b, $72, $37, $76, $b7, $76, $00, $78
	db $0b, $7a, $8a, $7b, $af, $54, $70, $56, $81, $6e, $10, $53, $65, $63, $ce, $66
	db $a1, $67, $e5, $68, $34, $6a, $20, $6b, $dd, $6b, $dd, $6b, $73, $5a, $29, $5c
	db $c8, $5d, $67, $5f, $06, $61, $0e, $58, $ad, $59

Call_04A1::
	ld a, [$d6fe]
	and a
	jr z, jr_000_04f5

	push af
	call Call_2881
	pop af
	call Call_04B1
	jr jr_000_0516

Call_04B1::
	dec a
	rst $00

JumpTable_04B3::
	dw Jump_2E6C
	dw Call_28A8
	dw Call_2B6B
	dw Jump_2B9F
	dw Jump_2C7E
	dw Jump_2BC4
	dw Jump_2C7E
	dw Jump_28A1
	dw Jump_2D88
	dw Jump_0522
	dw Jump_2D01
	dw Jump_0522
	dw Jump_2D73
	dw Jump_37DB
	dw Jump_2898
	dw Jump_2CC2
	dw Jump_2CF0
	dw Jump_2D28
	dw Jump_2D56
	dw Jump_2D1E
	dw Call_2A26
	dw Jump_2AA2
	dw Jump_2A9D
	dw Jump_2A98
	dw Jump_2AF7
	dw Jump_2AF2
	dw Jump_2ABF
	dw Jump_2AF2
	dw Jump_2A65
	dw Jump_29FA
	dw Jump_2A17
	dw Jump_2D23
	dw Jump_2D39

jr_000_04f5:
	call Call_2881
	ld hl, $0457
	ld b, $00
	ld a, [$d6ff]
	sla a
	ld c, a
	add hl, bc
	ld a, [hl]
	ld e, a
	inc hl
	ld a, [hl]
	ld d, a
	ld a, $08
	ld [$2100], a
	call Call_28DE
	ld a, $0c
	ld [$2100], a

jr_000_0516:
	xor a
	ld [$d6ff], a
	ld [$d6fe], a
	ld a, [$d6fd]
	ldh [rLCDC], a

Jump_0522::
	ret


	db $07, $09

Jump_000_0525:
	push af
	push bc
	push de
	push hl
	di
	ldh a, [$fffd]
	and a
	jp nz, Jump_000_05b6

	ld a, [$c19f]
	and $7f
	jr z, jr_000_0566

	cp $01
	jr z, jr_000_0566

	cp $05
	jr nc, jr_000_0548

	call Call_21DF
	ld hl, $c19f
	inc [hl]
	jr jr_000_05b6

jr_000_0548:
	cp $0a
	jr nz, jr_000_0551

	call Call_25A5
	jr jr_000_05b6

jr_000_0551:
	cp $0b
	jr nz, jr_000_0566

	ld a, [$c172]
	and a
	jr z, jr_000_0561

	dec a
	ld [$c172], a
	jr jr_000_0566

jr_000_0561:
	call Call_25F9
	jr jr_000_05b6

jr_000_0566:
	ld a, [$d6fe]
	and a
	jr nz, jr_000_05b6

	ldh a, [$ff90]
	ldh [$ffe8], a
	ld hl, $ff91
	or [hl]
	ld hl, $c10e
	or [hl]
	jr z, jr_000_058b

	call Call_05C0
	ldh a, [$ffe8]
	cp $08
	jr nc, jr_000_0586

jr_000_0583:
	call Call_1CCC

jr_000_0586:
	call $ffc0
	jr jr_000_05b6

jr_000_058b:
	ldh a, [$ffbb]
	and a
	jr z, jr_000_05a3

	dec a
	ldh [$ffbb], a
	ld e, a
	ld d, $00
	ld hl, $0523
	add hl, de
	ld a, [hl]
	ld [$d6f8], a
	call Call_1DEE
	jr jr_000_0583

jr_000_05a3:
	call Call_1AA9
	ld de, $d601
	call Call_28D8
	xor a
	ld [$d600], a
	ld [$d601], a
	call $ffc0

Jump_000_05b6:
jr_000_05b6:
	ei
	pop hl
	pop de
	pop bc
	ld a, $01
	ldh [$ffd1], a
	pop af
	reti


Call_05C0::
	ldh a, [$ff90]
	and a
	jp z, Jump_000_0688

	cp $07
	jp z, Jump_000_0760

	cp $03
	jp z, Jump_000_0062

	cp $04
	jp z, Jump_000_006a

	cp $05
	jp z, Jump_000_0072

	cp $06
	jp z, Jump_000_007a

	cp $08
	jp nc, Jump_000_0783

	ld a, [$dba5]
	and a
	jr z, jr_000_0643

	ldh a, [$ff90]
	cp $02
	jp z, Jump_000_07c9

	ld a, $0d
	ld [$2100], a
	ldh a, [$ff92]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, $9000
	add hl, bc
	push hl
	pop de
	ld hl, $5000
	ldh a, [$ff94]
	add $50
	ld h, a
	add hl, bc
	ldh a, [$ffbb]
	and a
	jr z, jr_000_062e

	ldh a, [$ff92]
	dec a
	cp $02
	jr c, jr_000_0634

jr_000_062e:
	ld bc, $0040
	call Call_28C5

jr_000_0634:
	ldh a, [$ff92]
	inc a
	ldh [$ff92], a
	cp $04
	jr nz, jr_000_0642

	xor a
	ldh [$ff90], a
	ldh [$ff92], a

jr_000_0642:
	ret


jr_000_0643:
	ld hl, $2100
	ld [hl], $0f
	ldh a, [$ff92]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, $9000
	add hl, bc
	push hl
	pop de
	ldh a, [$ff94]
	add $40
	ld h, a
	ld l, $00
	add hl, bc
	ld bc, $0040
	call Call_28C5
	ldh a, [$ff92]
	inc a
	ldh [$ff92], a
	cp $08
	jr nz, jr_000_0687

	xor a
	ldh [$ff90], a
	ldh [$ff92], a

jr_000_0687:
	ret


Jump_000_0688:
	ldh a, [$ff91]
	and a
	jr z, jr_000_06f4

	ld a, [$c197]
	ld e, a
	ld d, $00
	ld hl, $c193
	add hl, de
	ld a, [hl]
	push af
	and $3f
	ld d, a
	ld e, $00
	pop af
	swap a
	rra
	rra
	and $03
	ld c, a
	ld b, $00
	ld hl, $2d84
	add hl, bc
	ld a, [hl]
	ld [$2100], a
	ldh a, [$ff93]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, $4000
	add hl, bc
	add hl, de
	push hl
	ld a, [$c197]
	ld d, a
	ld hl, $8400
	add hl, bc
	add hl, de
	push hl
	pop de
	pop hl
	ld bc, $0040
	call Call_28C5
	ldh a, [$ff93]
	inc a
	ldh [$ff93], a
	cp $04
	jr nz, jr_000_06f3

	xor a
	ldh [$ff91], a
	ldh [$ff93], a

jr_000_06f3:
	ret


jr_000_06f4:
	ld a, [$c10d]
	ld e, a
	ld d, $00
	ld hl, $c193
	add hl, de
	ld a, [hl]
	push af
	and $3f
	ld d, a
	ld e, $00
	pop af
	swap a
	rra
	rra
	and $03
	ld c, a
	ld b, $00
	ld hl, $2d84
	add hl, bc
	ld a, [hl]
	ld [$2100], a
	ld a, [$c10f]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, $4000
	add hl, bc
	add hl, de
	push hl
	ld a, [$c10d]
	ld d, a
	ld hl, $8400
	add hl, bc
	add hl, de
	push hl
	pop de
	pop hl
	ld bc, $0040
	call Call_28C5
	ld a, [$c10f]
	inc a
	ld [$c10f], a
	cp $04
	jr nz, jr_000_075f

	xor a
	ld [$c10e], a
	ld [$c10f], a

jr_000_075f:
	ret


Jump_000_0760:
	ld a, $01
	ld [$2100], a
	call $7bc5
	jp Jump_000_008b


	db $60, $69, $a0, $69, $c0, $69, $00, $42, $40, $42, $60, $42, $00, $82, $40, $82
	db $60, $82, $00, $82, $40, $82, $60, $82

Jump_000_0783:
	sub $08
	sla a
	ld e, a
	ld d, $00
	ld hl, $076b
	add hl, de
	push hl
	ld hl, $0777
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $0c
	ld [$2100], a
	ld bc, $0040
	call Call_28C5
	ldh a, [$ff90]
	cp $0a
	jr z, jr_000_07b5

	cp $0d
	jr z, jr_000_07b5

	ldh a, [$ff90]
	inc a
	ldh [$ff90], a
	ret


jr_000_07b5:
	xor a
	ldh [$ff90], a
	ret


Call_07B9::
	ld [$2100], a
	ld [$dbaf], a
	ret


Call_07C0::
	push af
	ld a, [$dbaf]
	ld [$2100], a
	pop af
	ret


Jump_000_07c9:
	ld a, $12
	ld [$2100], a
	ldh a, [$ff92]
	cp $08
	jr c, jr_000_0813

	jr nz, jr_000_07e3

	ld a, $02
	ld [$2100], a
	call $6bb8
	ld hl, $ff92
	inc [hl]
	ret


jr_000_07e3:
	cp $09
	jr nz, jr_000_07f4

	ld a, $02
	ld [$2100], a
	call $6b92
	ld hl, $ff92
	inc [hl]
	ret


jr_000_07f4:
	cp $0a
	jr nz, jr_000_0805

	ld a, $02
	ld [$2100], a
	call $6b6c
	ld hl, $ff92
	inc [hl]
	ret


jr_000_0805:
	ld a, $02
	ld [$2100], a
	call $6b46
	xor a
	ldh [$ff90], a
	ldh [$ff92], a
	ret


jr_000_0813:
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld hl, $8d00
	add hl, bc
	push hl
	pop de
	ld hl, $7e00
	add hl, bc
	ld bc, $0040
	call Call_28C5
	ldh a, [$ff92]
	inc a
	ldh [$ff92], a
	ret


Call_0844::
	ld a, $1f
	ld [$2100], a
	call $4006
	ldh a, [$fff3]
	and a
	jr nz, jr_000_0876

	ld a, [$c10b]
	and a
	jr z, Call_0866

	cp $02
	jr nz, jr_000_0863

	ldh a, [$ffe7]
	and $01
	jr nz, jr_000_0876

	jr Call_0866

jr_000_0863:
	call Call_0866

Call_0866::
	ld a, $1b
	ld [$2100], a
	call $4006
	ld a, $1e
	ld [$2100], a
	call $4006

jr_000_0876:
	ret


	db $ff, $ff, $ff, $ff, $ff

Call_087C::
	ld a, $02
	ld [$2100], a
	call Call_19EF
	jp Call_07C0


Call_0887::
	ld hl, $c450
	jr jr_000_0894

Call_088C::
	ld hl, $c2f0
	jr jr_000_0894

Call_0891::
	ld hl, $c2e0

jr_000_0894:
	add hl, bc
	ld a, [hl]
	and a
	ret


Call_0898::
	ld a, $af
	call Call_3C01
	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ret


Call_08AC::
	ld a, $1d
	ldh [$fff2], a
	ret


Call_08B1::
	ld hl, $45e1
	jr jr_000_08b9

	db $21, $e1, $46

jr_000_08b9:
	ld a, $1c
	ld [$2100], a
	add hl, bc
	ld a, [hl]
	ld hl, $2100
	ld [hl], $01
	ret


Call_08C6::
	ld a, $0c
	ld [$2100], a
	ld bc, $0040
	call Call_28C5
	ld a, $01
	ld [$2100], a
	ret


Call_08D7::
	ld hl, $fff4
	ld [hl], $0c

Call_08DC::
	ld hl, $c502
	ld [hl], $04
	ret


Call_08E2::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_08eb

	dec [hl]

jr_000_08eb:
	ret


Call_08EC::
	push af
	ld a, [$c18f]
	and a
	jr nz, jr_000_0907

	ld [$c1cf], a
	inc a
	ld [$c18f], a
	ld [$c5a6], a
	ld a, [$c19d]
	and a
	jr nz, jr_000_0907

	ld a, $02
	ldh [$fff2], a

jr_000_0907:
	pop af
	ret


Call_0909::
	ld a, $30
	ldh [$ffa8], a
	jr jr_000_0926

Call_090F::
	ld a, $30
	ldh [$ffa8], a
	jr Call_092A

Call_0915::
	ld a, [$d401]
	cp $01
	jr nz, Call_0909

	ld a, [$dba5]
	and a
	jr z, Call_0909

	ld a, $01
	ldh [$ffbc], a

jr_000_0926:
	ld a, $06
	ldh [$fff4], a

Call_092A::
	ld a, $03
	ld [$c11c], a
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$d478], a
	and a
	ret


Call_093B::
	xor a
	ld [$c121], a
	ld [$c122], a

Call_0942::
	xor a
	ld [$c14b], a
	ld [$c14a], a
	ret


Call_094A::
	ldh a, [$ff9f]
	ldh [$ff98], a
	ldh a, [$ffa0]
	ldh [$ff99], a
	ret


Call_0953::
	push af
	ld e, $0f
	ld d, $00

jr_000_0958:
	ld hl, $c510
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_000_0978

	dec e
	ld a, e
	cp $ff
	jr nz, jr_000_0958

	ld hl, $c5c0
	dec [hl]
	ld a, [hl]
	cp $ff
	jr nz, jr_000_0974

	ld a, $0f
	ld [$c5c0], a

jr_000_0974:
	ld a, [$c5c0]
	ld e, a

jr_000_0978:
	pop af
	ld hl, $c510
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c540
	add hl, de
	ld [hl], a
	ldh a, [$ffd7]
	ld hl, $c530
	add hl, de
	ld [hl], a
	ld hl, $c520
	add hl, de
	ld [hl], $0f
	ret


Call_0993::
	ld a, [$c140]
	sub $08
	ldh [$ffd7], a
	ld a, [$c142]
	sub $08
	ldh [$ffd8], a

Call_09A1::
	ld a, $07
	ldh [$fff2], a
	ld a, $05
	jp Call_0953


Call_09AA::
	ld a, $08
	ld [$2100], a
	ld a, [$dba5]
	and a
	jr z, jr_000_09dc

	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $4040
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_09c8

	cp $06
	jr c, jr_000_09c8

	inc h

jr_000_09c8:
	add hl, de
	ldh a, [$ff94]
	ld e, a
	ld a, [hl]
	cp e
	jr z, jr_000_09da

	ldh [$ff94], a
	cp $ff
	jr z, jr_000_09da

	ld a, $01
	ldh [$ff90], a

jr_000_09da:
	jr jr_000_0a09

jr_000_09dc:
	ldh a, [$fff6]
	cp $07
	jr nz, jr_000_09e3

	inc a

jr_000_09e3:
	ld d, a
	srl a
	srl a
	and $f8
	ld e, a
	ld a, d
	srl a
	and $07
	or e
	ld e, a
	ld d, $00
	ld hl, $4000
	add hl, de
	ldh a, [$ff94]
	ld e, a
	ld a, [hl]
	cp e
	jr z, jr_000_0a09

	cp $0f
	jr z, jr_000_0a09

	ldh [$ff94], a
	ld a, $01
	ldh [$ff90], a

jr_000_0a09:
	xor a
	ldh [$ffd7], a
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $4240
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_0a23

	cp $06
	jr c, jr_000_0a23

	inc d

jr_000_0a23:
	add hl, de
	ld e, [hl]
	ld a, d
	and a
	jr nz, jr_000_0a43

	ld a, e
	cp $23
	jr nz, jr_000_0a36

	ld a, [$d8c9]
	and $20
	jr z, jr_000_0a36

	inc e

jr_000_0a36:
	ld a, e
	cp $21
	jr nz, jr_000_0a43

	ld a, [$d8fd]
	and $20
	jr z, jr_000_0a43

	inc e

jr_000_0a43:
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $4540
	ld a, [$dba5]
	and a
	jr z, jr_000_0a59

	ld hl, $4788

jr_000_0a59:
	add hl, de
	ld d, $00
	ld bc, $c193

jr_000_0a5f:
	ld e, [hl]
	ld a, [bc]
	cp e
	jr z, jr_000_0a85

	ld a, e
	cp $ff
	jr z, jr_000_0a85

	ld [bc], a
	ldh a, [$ffd7]
	and a
	jr z, jr_000_0a7a

	ld a, d
	ld [$c10d], a
	ld a, $01
	ld [$c10e], a
	jr jr_000_0a85

jr_000_0a7a:
	inc a
	ldh [$ffd7], a
	ld a, d
	ld [$c197], a
	ld a, $01
	ldh [$ff91], a

jr_000_0a85:
	inc hl
	inc bc
	inc d
	ld a, d
	cp $04
	jr nz, jr_000_0a5f

	jp Call_07C0


Call_0A90::
	ld a, [$db95]
	cp $07
	jr c, jr_000_0ace

	cp $0b
	jr nz, jr_000_0aa2

	ld a, [$db96]
	cp $07
	jr nz, jr_000_0ace

jr_000_0aa2:
	ld a, [$c16b]
	cp $04
	jr nz, jr_000_0ace

	ld a, [$c19f]
	ld hl, $c167
	or [hl]
	ld hl, $c124
	or [hl]
	jr nz, jr_000_0ace

	ldh a, [$ffcb]
	cp $f0
	jr nz, jr_000_0ace

	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$c19f], a
	ld [$db96], a
	ld a, $06
	ld [$db95], a

jr_000_0ace:
	ld a, [$db95]
	rst $00

JumpTable_0AD2::
	dw Jump_0B05
	dw Jump_0B08
	dw Jump_0B34
	dw Jump_0B37
	dw Jump_0B3A
	dw Jump_0B3D
	dw Jump_0B02
	dw Jump_0AFC
	dw Jump_0AF0
	dw Jump_0AF6
	dw Jump_0AEA
	dw Jump_0B40

Jump_0AEA::
	call $67bc
	jp Jump_000_0c32


Jump_0AF0::
	call $654c
	jp Jump_000_0c32


Jump_0AF6::
	call $5fbb
	jp Jump_000_0c32


Jump_0AFC::
	call $546e
	jp Jump_000_0c32


Jump_0B02::
	jp $4000


Jump_0B05::
	jp $6e3e


Jump_0B08::
	ld a, $17
	call Call_07B9
	call $482a
	jp Jump_000_0c32


Call_0B13::
	ld a, $03
	ld [$2100], a
	ld a, $17

jr_000_0b1a:
	push af
	call Call_3843
	pop af
	jp Call_07B9


Call_0B22::
	ld a, $03
	ld [$2100], a
	ld a, $01
	jr jr_000_0b1a

Call_0B2B::
	ld a, $03
	ld [$2100], a
	ld a, $02
	jr jr_000_0b1a

Jump_0B34::
	jp $4711


Jump_0B37::
	jp $494b


Jump_0B3A::
	jp $4be6


Jump_0B3D::
	jp $4e34


Jump_0B40::
	ld a, $14
	ld [$2100], a
	call $5326
	call $523c
	ld a, $01
	call Call_07B9
	jp $431e


	ld a, $02
	call Call_07B9
	ld a, [$c19f]
	and a
	jr nz, jr_000_0b9a

	ld hl, $ffb4
	ld a, [hl]
	and a
	jr z, jr_000_0b80

	ld a, [$db9a]
	cp $80
	jr nz, jr_000_0b80

	ld a, [$c14f]
	and a
	jr nz, jr_000_0b80

	dec [hl]
	jr nz, jr_000_0b80

	ld a, $01
	ld [$2100], a
	call $5fa6
	call Call_07C0

jr_000_0b80:
	ld a, [$c19f]
	and a
	jr nz, jr_000_0b9a

	ld a, [$c1bc]
	and a
	jr z, jr_000_0b9a

	ld hl, $ffa1
	ld [hl], $02
	dec a
	ld [$c1bc], a
	jr nz, jr_000_0b9a

	jp Call_0909


jr_000_0b9a:
	ld hl, $dbc7
	ld a, [hl]
	and a
	jr z, jr_000_0ba2

	dec [hl]

jr_000_0ba2:
	ldh a, [$ff98]
	ldh [$ff9f], a
	ldh a, [$ff99]
	ldh [$ffa0], a
	ld hl, $ffa2
	sub [hl]
	ldh [$ffb3], a
	call $5dd5
	xor a
	ld [$c140], a
	ld [$c13c], a
	ld [$c13b], a
	ld hl, $c11d
	res 7, [hl]
	ld hl, $c11e
	res 7, [hl]
	call $5731
	ld a, $02
	call Call_07B9
	call Call_2655
	call Call_0C40
	ld a, [$c15c]
	ld [$c3cf], a
	xor a
	ld [$c14e], a
	ld [$c14d], a
	ld [$c1a4], a
	ld [$c15c], a
	ld [$c1ae], a
	ld a, [$c144]
	and a
	jr z, jr_000_0bf5

	dec a
	ld [$c144], a

jr_000_0bf5:
	ld a, $19
	call Call_07B9
	call $769b
	call Call_3843
	ld a, $02
	call Call_07B9
	call $529a
	ld hl, $d601
	ldh a, [$ffe7]
	and $03
	or [hl]
	jr nz, jr_000_0c2a

	ld a, [$c11c]
	cp $02
	jr nc, jr_000_0c2a

	ld c, $01
	ld b, $00
	ld e, $00
	ldh a, [$ffe7]
	and $04
	jr z, jr_000_0c27

	dec c
	dec e

jr_000_0c27:
	call $61ed

jr_000_0c2a:
	ld a, $14
	call Call_07B9
	call $59b0

Jump_000_0c32:
	ld a, $0f
	call Call_07B9
	call Call_2133
	ret


	db $08, $0e, $99, $28, $ec

Call_0C40::
	ldh a, [$ff99]
	ld hl, $ffa2
	sub [hl]
	ld [$c145], a
	ld a, [$c1a9]
	and a
	jr z, jr_000_0c8c

	ld a, [$c19f]
	and a
	jr nz, jr_000_0c7a

	ld hl, $c1aa
	dec [hl]
	ld a, [hl]
	cp $02
	jr nz, jr_000_0c6e

	ld a, [$c1a9]
	ld e, a
	ld d, $00
	ld hl, $0c3a
	add hl, de
	ld a, [hl]
	call Call_2197
	ld a, $01

jr_000_0c6e:
	and a
	jr nz, jr_000_0c7a

	xor a
	ld [$c1a9], a
	ld [$c1a8], a
	jr jr_000_0c8c

jr_000_0c7a:
	ld a, [$c1a9]
	ld [$c1a8], a
	dec a
	rst $00

JumpTable_0C82::
	db $18, $50, $23, $50, $23, $50, $23, $50, $18, $50

jr_000_0c8c:
	ldh a, [$ffcb]
	and $b0
	jr nz, jr_000_0cde

	ldh a, [$ffcb]
	and $40
	jr z, jr_000_0cde

	ld a, [$d45f]
	inc a
	ld [$d45f], a
	cp $04
	jr c, jr_000_0ce2

	ldh a, [$ffa1]
	cp $02
	jr z, jr_000_0cde

	ldh a, [$ff9d]
	cp $ff
	jr z, jr_000_0cde

	ld a, [$c11c]
	cp $02
	jr nc, jr_000_0cde

	ld hl, $c167
	ld a, [$c19f]
	or [hl]
	jr nz, jr_000_0cde

	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$db96], a
	ld a, $07
	ld [$db95], a
	ld a, $02
	ld [$2100], a
	call $781b
	call Call_1CCC
	call Call_3843
	pop af
	ret


jr_000_0cde:
	xor a
	ld [$d45f], a

jr_000_0ce2:
	ldh a, [$ffb7]
	and a
	jr z, jr_000_0cea

	dec a
	ldh [$ffb7], a

jr_000_0cea:
	ldh a, [$ffb6]
	and a
	jr z, jr_000_0cf2

	dec a
	ldh [$ffb6], a

jr_000_0cf2:
	ld a, [$c19f]
	and a
	jp nz, Call_149B

	ld a, [$c124]
	and a
	jp nz, Jump_000_0d49

	ld a, [$c11c]
	cp $07
	jr z, jr_000_0d32

	ld a, [$db5a]
	ld hl, $c50a
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_000_0d2f

	ld a, $07
	ld [$c11c], a
	ld a, $bf
	ldh [$ffb7], a
	ld a, $10
	ld [$c3cc], a
	xor a
	ld [$dbc7], a
	ldh [$ff9c], a
	call Call_27D2
	ld a, $08
	ldh [$fff3], a

jr_000_0d2f:
	ld a, [$c11c]

jr_000_0d32:
	rst $00

JumpTable_0D33::
	dw Jump_0D5F

	db $92, $4d, $0e, $49, $b3, $15, $32, $17, $00, $4d, $30, $4f, $57, $0d, $a2, $50
	db $4f, $0d, $ff, $4e

Jump_000_0d49:
	call Call_149B
	jp Call_1CCC


	db $3e, $19, $cd, $b9, $07, $c3, $a9, $5c, $3e, $01, $cd, $b9, $07, $c3, $84, $41

Jump_0D5F::
	ld a, $02
	call Call_07B9
	call $426e
	ret


Call_0D68::
	ld a, [$c50a]
	ld hl, $c167
	or [hl]
	ld hl, $c1a4
	or [hl]
	ret nz

	ld a, [$c14a]
	and a
	jr z, jr_000_0dad

	ld a, [$db01]
	cp $01
	jr z, jr_000_0d9b

	ld a, [$db00]
	cp $01
	jr z, jr_000_0d9b

	ld a, [$db01]
	cp $04
	jr z, jr_000_0d96

	ld a, [$db00]
	cp $04
	jr nz, jr_000_0dab

jr_000_0d96:
	call Call_0F34
	jr jr_000_0dab

jr_000_0d9b:
	ld a, [$c137]
	dec a
	cp $04
	jr c, jr_000_0dab

	ld a, $05
	ld [$c137], a
	ld [$c16a], a

jr_000_0dab:
	jr jr_000_0db4

jr_000_0dad:
	xor a
	ld [$c15b], a
	ld [$c15a], a

jr_000_0db4:
	ld a, [$c117]
	and a
	jp nz, Jump_000_0ed0

	ld a, [$c15c]
	and a
	jp nz, Jump_000_0ed0

	ld a, [$c137]
	and a
	jr z, jr_000_0dd3

	cp $03
	jr nz, jr_000_0dd3

	ld a, [$c138]
	cp $03
	jr nc, jr_000_0dd9

jr_000_0dd3:
	ldh a, [$ffa1]
	and a
	jp nz, Jump_000_0ed0

jr_000_0dd9:
	ld a, [$db00]
	cp $08
	jr nz, jr_000_0def

	ldh a, [$ffcb]
	and $20
	jr z, jr_000_0deb

	call Call_140C
	jr jr_000_0def

jr_000_0deb:
	xor a
	ld [$c14b], a

jr_000_0def:
	ld a, [$db01]
	cp $08
	jr nz, jr_000_0e05

	ldh a, [$ffcb]
	and $10
	jr z, jr_000_0e01

	call Call_140C
	jr jr_000_0e05

jr_000_0e01:
	xor a
	ld [$c14b], a

jr_000_0e05:
	ld a, [$db01]
	cp $04
	jr nz, jr_000_0e26

	ld a, [$db44]
	ld [$c15a], a
	ldh a, [$ffcb]
	and $10
	jr z, jr_000_0e26

	ld a, [$c1ad]
	cp $01
	jr z, jr_000_0e26

	cp $02
	jr z, jr_000_0e26

	call Call_0F34

jr_000_0e26:
	ld a, [$db00]
	cp $04
	jr nz, jr_000_0e3c

	ld a, [$db44]
	ld [$c15a], a
	ldh a, [$ffcb]
	and $20
	jr z, jr_000_0e3c

	call Call_0F34

jr_000_0e3c:
	ldh a, [$ffcc]
	and $20
	jr z, jr_000_0e4f

	ld a, [$c1ad]
	cp $02
	jr z, jr_000_0e4f

	ld a, [$db00]
	call Call_0E7F

jr_000_0e4f:
	ldh a, [$ffcc]
	and $10
	jr z, jr_000_0e66

	ld a, [$c1ad]
	cp $01
	jr z, jr_000_0e66

	cp $02
	jr z, jr_000_0e66

	ld a, [$db01]
	call Call_0E7F

jr_000_0e66:
	ldh a, [$ffcb]
	and $20
	jr z, jr_000_0e72

	ld a, [$db00]
	call Call_0F05

jr_000_0e72:
	ldh a, [$ffcb]
	and $10
	jr z, jr_000_0e7e

	ld a, [$db01]
	call Call_0F05

jr_000_0e7e:
	ret


Call_0E7F::
	ld c, a
	cp $01
	jp z, Jump_000_122f

	cp $04
	jp z, Jump_000_0ed1

	cp $02
	jp z, Jump_000_0f76

	cp $03
	jp z, Jump_000_1007

	cp $05
	jp z, Jump_000_1079

	cp $0d
	jp z, Jump_000_100e

	cp $06
	jp z, Jump_000_0efc

	cp $0a
	jp z, Jump_000_11d1

	cp $09
	jp z, $41e6

	cp $0c
	jp z, Jump_000_1151

	cp $0b
	jp z, Jump_000_0edb

	cp $07
	jr nz, jr_000_0ed0

	ld hl, $c137
	ld a, [$c19b]
	or [hl]
	jr nz, jr_000_0ed0

	ld a, [$c14d]
	cp $02
	jr nc, jr_000_0ed0

	ld a, $8e
	ld [$c19b], a

Jump_000_0ed0:
jr_000_0ed0:
	ret


Jump_000_0ed1:
	ld a, [$c144]
	and a
	ret nz

	ld a, $16
	ldh [$fff4], a
	ret


Jump_000_0edb:
	ld a, [$c1c7]
	ld hl, $c146
	or [hl]
	ret nz

	call $4c35
	jr nc, jr_000_0eee

	ld a, $07
	ldh [$fff2], a
	jr jr_000_0ef2

jr_000_0eee:
	ld a, $0e
	ldh [$fff4], a

jr_000_0ef2:
	ld a, $01
	ld [$c1c7], a
	xor a
	ld [$c1c8], a
	ret


Jump_000_0efc:
	ld a, [$c1a4]
	and a
	ret nz

	call $423b
	ret


Call_0F05::
	cp $01
	ret nz

	ld hl, $c137
	ld a, [$c1ad]
	and $03
	or [hl]
	ret nz

	ld a, [$c160]
	and a
	ret nz

	xor a
	ld [$c1ac], a
	ld a, $05
	ld [$c137], a
	ld [$c5b0], a
	ret


	db $10, $00, $08, $08, $03, $03, $08, $08, $08, $08, $00, $0d, $08, $08, $03, $04

Call_0F34::
	ld a, $01
	ld [$c15b], a
	ld a, [$db44]
	ld [$c15a], a

Call_0F3F::
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $0f24
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ld [$c140], a
	ld hl, $0f28
	add hl, de
	ld a, [hl]
	ld [$c141], a
	ld hl, $0f2c
	add hl, de
	ld a, [$c145]
	add [hl]
	ld [$c142], a
	ld hl, $0f30
	add hl, de
	ld a, [hl]
	ld [$c143], a
	xor a
	ld [$c5b0], a
	ret


	db $08, $f8, $00, $00, $00, $00, $fd, $04

Jump_000_0f76:
	ld a, [$c14e]
	cp $01
	ret nc

	ld a, [$db4d]
	and a
	jp z, Call_08AC

	sub $01
	daa
	ld [$db4d], a
	ld a, $02
	call Call_10EB
	ret c

	ld hl, $c2f0
	add hl, de
	ld [hl], $10
	ld a, [$c1c0]
	and a
	jp z, Jump_000_0fac

	xor a
	ld [$c1c0], a
	ld a, [$c1c2]
	ld c, a
	ld b, d
	ld hl, $c290
	add hl, bc
	ld [hl], $01
	ret


Jump_000_0fac:
	ld a, $06
	ld [$c1c0], a
	ld a, e
	ld [$c1c1], a
	ld a, $0c
	ld [$c19b], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $a0
	ld hl, $c3b0
	add hl, de
	ld [hl], d
	ld hl, $c480
	add hl, de
	ld [hl], $03
	ldh a, [$fff9]
	and a
	jr nz, jr_000_0fd6

	ld a, $09
	ldh [$fff2], a
	jr jr_000_0fdb

jr_000_0fd6:
	ld hl, $c310
	add hl, de
	ld [hl], d

jr_000_0fdb:
	ld hl, $c240
	add hl, de
	ld [hl], d
	ld hl, $c250
	add hl, de
	ld [hl], d
	ld hl, $c320
	add hl, de
	ld [hl], d
	ldh a, [$ff9e]
	ld c, a
	ld b, d
	ld hl, $0f6e
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $0f72
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ret


Jump_000_1007:
	ret


	db $18, $e8, $00, $e8, $18, $00

Jump_000_100e:
	ld a, [$c14d]
	and a
	ret nz

	ld a, $01
	call Call_10EB
	ret c

	ld hl, $c2e0
	add hl, de
	ld [hl], $28
	ld c, $04
	ld b, $00
	ldh a, [$ffcb]

jr_000_1025:
	srl a
	jr nc, jr_000_102a

	inc b

jr_000_102a:
	dec c
	jr nz, jr_000_1025

	ld a, b
	cp $02
	jr c, jr_000_1058

	ldh a, [$ffcb]
	and $03
	ld c, a
	ld b, $00
	ld hl, $1007
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ldh a, [$ffcb]
	srl a
	srl a
	and $03
	ld c, a
	ld b, $00
	ld hl, $100a
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a

jr_000_1058:
	ret


	db $00, $00, $00, $00, $00, $00, $00, $00, $20, $e0, $00, $00, $00, $00, $e0, $20
	db $30, $d0, $00, $00, $40, $c0, $00, $00, $00, $00, $d0, $30, $00, $00, $c0, $40

Jump_000_1079:
	ld a, [$c14c]
	and a
	ret nz

	ld a, [$c14d]
	cp $02
	jr nc, jr_000_10ea

	ld a, $10
	ld [$c14c], a
	ld a, [$db45]
	and a
	jp z, Call_08AC

	sub $01
	daa
	ld [$db45], a
	call Call_1283
	ld a, $00
	call Call_10EB
	ret c

	ld a, e
	ld [$c1c2], a
	ld a, [$c1c0]
	and a
	jr z, jr_000_10bd

	ld a, [$c1c1]
	ld c, a
	ld b, d
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ld hl, $c290
	add hl, de
	ld [hl], $01
	xor a
	jr jr_000_10c3

jr_000_10bd:
	ld a, $0a
	ldh [$fff4], a
	ld a, $06

jr_000_10c3:
	ld [$c1c0], a
	ldh a, [$ff9e]
	ld c, a
	ld b, $00

Jump_000_10cb:
	ld a, [$d47c]
	cp $01
	jr nz, jr_000_10d6

	ld a, c
	add $04
	ld c, a

jr_000_10d6:
	ld hl, $1069
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $1071
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a

jr_000_10ea:
	ret


Call_10EB::
	call Call_3C01
	ret c

	ld a, $0c
	ld [$c19b], a
	push bc
	ldh a, [$ff9e]
	ld c, a
	ld b, $00
	ld hl, $1059
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $105d
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffa2]
	inc a
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $1061
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $1065
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ldh a, [$ff9e]
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $c380
	add hl, de
	ld [hl], a
	ld hl, $c5d0
	add hl, de
	ld [hl], a
	ld hl, $c4f0
	add hl, de
	ld [hl], $01
	pop bc
	scf
	ccf
	ret


	db $0e, $f2, $00, $00, $00, $00, $f4, $0c

Jump_000_1151:
	ld a, [$c19b]
	and a
	ret nz

	ld a, [$db4b]
	and a
	jr z, jr_000_116b

	ldh a, [$ffa2]
	and a
	ret nz

	ld a, $02
	ld [$c1a9], a
	ld a, $2a
	ld [$c1aa], a
	ret


jr_000_116b:
	ld a, [$db4c]
	and a
	jp z, Call_08AC

	ld a, $08
	call Call_3C01
	ret c

	ld a, $05
	ldh [$fff2], a
	ld a, $0e
	ld [$c19b], a
	ld a, [$db4c]
	sub $01
	daa
	ld [$db4c], a
	jr nz, jr_000_119e

	ld hl, $db00
	ld a, [hl]
	cp $0c
	jr nz, jr_000_1196

	ld [hl], $00

jr_000_1196:
	inc hl
	ld a, [hl]
	cp $0c
	jr nz, jr_000_119e

	ld [hl], $00

jr_000_119e:
	push bc
	ldh a, [$ff9e]
	ld c, a
	ld hl, $1149
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $114d
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $17
	pop bc
	ret


	db $1c, $e4, $00, $00, $00, $00, $e4, $1c

Jump_000_11d1:
	ld a, [$c130]
	cp $07
	ret z

	ld a, [$c146]
	and a
	ret nz

	ld a, $01
	ld [$c146], a
	xor a
	ld [$c152], a
	ld [$c153], a
	ld a, $0d
	ldh [$fff2], a
	ldh a, [$fff9]
	and a
	jr z, Call_120F

	call Call_120F
	ldh a, [$ffcb]
	and $03
	ld a, $ea
	jr z, jr_000_11fe

	ld a, $e8

jr_000_11fe:
	ldh [$ff9b], a
	xor a
	ldh [$ffa3], a
	call Call_20D6
	ld a, $02
	call Call_07B9
	call $6fb1
	ret


Call_120F::
	ld a, $20
	ldh [$ffa3], a
	ld a, [$c14a]
	and a
	ret z

	ldh a, [$ff9e]
	ld e, a
	ld d, b
	ld hl, $11c9
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $11cd
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	ret


	db $02, $14, $15, $18

Jump_000_122f:
	ld a, [$c16d]
	ld hl, $c121
	or [hl]
	ret nz

	ld a, $03
	ld [$c138], a
	ld a, $01
	ld [$c137], a
	ld [$c5b0], a
	xor a
	ld [$c160], a
	ld [$c1ac], a
	call Call_27ED
	and $03
	ld e, a
	ld d, $00
	ld hl, $122b
	add hl, de
	ld a, [hl]
	ldh [$fff4], a
	call Call_1283
	ld a, [$c146]
	and a
	jr nz, jr_000_1269

	call Call_093B
	call Call_1495

jr_000_1269:
	ld a, [$c14d]
	and a
	ret nz

	ld a, [$c5a9]
	and a
	ret z

	ld a, [$db4e]
	cp $02
	ret nz

	ld a, $df
	call Call_10EB
	xor a
	ld [$c19b], a
	ret


Call_1283::
	ldh a, [$ffcb]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $48b3
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, jr_000_1295

	ldh [$ff9e], a

jr_000_1295:
	ret


	db $16, $fa, $08, $08, $16, $16, $08, $fa, $fa, $fa, $08, $16, $08, $08, $fa, $16
	db $08, $16, $16, $16, $08, $fa, $fa, $fa

Call_12AE::
	call Call_12B6
	ld a, $02
	jp Call_07B9


Call_12B6::
	ld a, [$c1c4]
	and a
	ret nz

	ld a, [$c14a]
	and a
	jr nz, jr_000_12c7

	ld a, [$c16a]
	cp $05
	ret z

jr_000_12c7:
	ld a, [$c121]
	and a
	jr z, jr_000_12d4

	ld a, [$c136]
	add $04
	jr jr_000_12d6

jr_000_12d4:
	ldh a, [$ff9e]

jr_000_12d6:
	ld e, a
	ld d, $00
	ld hl, $1296
	add hl, de
	ldh a, [$ff98]
	add [hl]
	sub $08
	and $f0
	ldh [$ffce], a
	swap a
	ld c, a
	ld hl, $12a2
	add hl, de
	ldh a, [$ff99]
	add [hl]
	sub $10
	and $f0
	ldh [$ffcd], a
	or c
	ld e, a
	ld hl, $d711
	add hl, de
	ld a, h
	cp $d7
	ret nz

	push de
	ld a, [hl]
	ldh [$ffaf], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	pop de
	cp $d0
	jp c, Jump_000_1317

	cp $d4
	jp c, Jump_000_13c9

Jump_000_1317:
	cp $90
	jp nc, Jump_000_13c9

	cp $01
	jp z, Jump_000_13c9

	ld c, $00
	ld a, [$dba5]
	and a
	ldh a, [$ffaf]
	jr z, jr_000_1330

	cp $dd
	jr z, jr_000_133e

	ret


jr_000_1330:
	inc c
	cp $d3
	jr z, jr_000_133e

	cp $5c
	jr z, jr_000_133e

	cp $0a
	ret nz

	ld c, $ff

jr_000_133e:
	ld a, c
	ldh [$fff1], a
	call Call_20A6
	ld a, [$c14a]
	and a
	jr nz, jr_000_135a

	ld a, [$c16a]
	cp $05
	jr nz, jr_000_135a

	xor a
	ld [$c122], a
	ld a, $0c
	ld [$c16d], a

jr_000_135a:
	ld a, $05
	call Call_10EB
	jr c, jr_000_1383

	xor a
	ld [$c19b], a
	ld hl, $c200
	add hl, de
	ldh a, [$ffce]
	add $08
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffcd]
	add $10
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ldh a, [$fff1]
	ld [hl], a
	push de
	pop bc
	call Call_3803

jr_000_1383:
	call Call_27ED
	and $07
	ret nz

	ldh a, [$ffaf]
	cp $d3
	ret z

	call Call_27ED
	rra
	ld a, $2e
	jr nc, jr_000_1398

	ld a, $2d

jr_000_1398:
	call Call_3C01
	ret c

	ld hl, $c200
	add hl, de
	ldh a, [$ffce]
	add $08
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffcd]
	add $10
	ld [hl], a
	ld hl, $c450
	add hl, de
	ld [hl], $80
	ld hl, $c2f0
	add hl, de
	ld [hl], $18
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ret


	db $12, $ee, $fc, $04, $04, $04, $ee, $12

Jump_000_13c9:
	ld c, a
	ld a, [$c16d]
	and a
	ret z

	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $13c1
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ffd7], a
	ld hl, $13c5
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ldh [$ffd8], a
	ld a, $04
	ld [$c502], a
	call Call_09A1
	ld a, $10
	ld [$c1c4], a
	ld a, c
	and $f0
	cp $90
	jr z, jr_000_13ff

	ld a, $07
	ldh [$fff2], a
	ret


jr_000_13ff:
	ld a, $17
	ldh [$fff4], a
	ret


	db $20, $e0, $00, $00, $00, $00, $e0, $20

Call_140C::
	ldh a, [$fff9]
	and a
	jr z, jr_000_141a

	ldh a, [$ff9c]
	and a
	ret nz

	ldh a, [$ff9e]
	and $02
	ret nz

jr_000_141a:
	ld a, [$c14a]
	and a
	ret nz

	ldh a, [$ffa2]
	ld hl, $c146
	or [hl]
	ret nz

	ld a, [$c120]
	add $02
	ld [$c120], a
	call Call_145D
	ld a, [$c14b]
	inc a
	ld [$c14b], a
	cp $20
	ret nz

	ld [$c14a], a
	xor a
	ld [$c121], a
	ld [$c122], a
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $1404
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $1408
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	xor a
	ld [$c1ac], a
	ret


Call_145D::
	ldh a, [$ffe7]
	and $07
	ld hl, $ffa2
	or [hl]
	ld hl, $ffa1
	or [hl]
	ld hl, $c146
	or [hl]
	ret nz

	ldh a, [$ff98]
	ldh [$ffd7], a
	ld a, [$c181]
	cp $05
	jr z, jr_000_1488

	ld a, $07
	ldh [$fff4], a
	ldh a, [$ff99]
	add $06
	ldh [$ffd8], a
	ld a, $0b
	jp Call_0953


jr_000_1488:
	ldh a, [$ff99]
	ldh [$ffd8], a
	ld a, $0e
	ldh [$fff2], a
	ld a, $0c
	jp Call_0953


Call_1495::
	xor a
	ldh [$ff9a], a
	ldh [$ff9b], a
	ret


Call_149B::
	call $77fa

Call_149E::
	ld a, [$c11c]
	cp $01
	ret z

	ld a, [$c16a]
	and a
	jr z, jr_000_14e2

	ld bc, $c010
	ld a, [$c145]
	ld hl, $c13b
	add [hl]
	ldh [$ffd7], a
	ldh a, [$ff98]
	ldh [$ffd8], a
	ld hl, $ffda
	ld [hl], $00
	ld a, [$c122]
	cp $28
	jr c, jr_000_14cd

	ldh a, [$ffe7]
	rla
	rla
	and $10
	ld [hl], a

jr_000_14cd:
	ld a, [$c139]
	ld h, a
	ld a, [$c13a]
	ld l, a
	ld a, [$c136]
	ldh [$ffd9], a
	ldh a, [$ff99]
	cp $88
	ret nc

	jp Call_1540


jr_000_14e2:
	ld a, [$c19b]
	push af
	bit 7, a
	jp z, Jump_000_151b

	ld a, $02
	call Call_07B9
	call $514b
	ld a, [$c19b]
	and $7f
	cp $0c
	jr nz, jr_000_151b

	ld hl, $c19f
	ld a, [$c124]
	or [hl]
	jr nz, jr_000_151b

	call Call_1283
	ld a, $04
	call Call_10EB
	jr c, jr_000_151b

	ld a, $0d
	ldh [$fff4], a
	ld a, $02
	call Call_07B9
	call $51c6

Jump_000_151b:
jr_000_151b:
	pop af
	ld [$c19b], a
	ret


	db $08, $06, $0c, $0a, $ff, $04, $0a, $0c, $06, $08, $0a, $0c, $ff, $04, $0c, $0a
	db $20, $20, $60, $60, $00, $00, $40, $40, $00, $00, $00, $00, $40, $40, $20, $20

Call_1540::
	push hl
	ldh a, [$ffd7]
	add h
	ld [bc], a
	inc bc
	ldh a, [$ffd8]
	add l
	ld [bc], a
	inc bc
	ld hl, $1520
	ldh a, [$ffd9]
	sla a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld [bc], a
	cp $ff
	jr nz, jr_000_1561

	dec bc
	ld a, $f0
	ld [bc], a
	inc bc

jr_000_1561:
	inc bc
	ld hl, $1530
	add hl, de
	ld a, [hl]
	ld hl, $ffda
	or [hl]
	ld [bc], a
	inc bc
	pop hl
	ldh a, [$ffd7]
	add h
	ld [bc], a
	inc bc
	ldh a, [$ffd8]
	add l
	add $08
	ld [bc], a
	inc bc
	ld hl, $1521
	add hl, de
	ld a, [hl]
	ld [bc], a
	inc bc
	ld hl, $1531
	add hl, de
	ld a, [hl]
	ld hl, $ffda
	or [hl]
	ld [bc], a
	ret


	db $10, $f0, $08, $08, $0c, $0c, $f0, $10

Call_1594::
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $158c
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ld [$c179], a
	ld hl, $1590
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ld [$c17a], a
	ld a, $02
	ld [$c178], a
	ret


	call $780f
	ld a, [$c3c9]
	and a
	jr z, jr_000_15c3

	xor a
	ld [$c3c9], a
	jp Call_0909


jr_000_15c3:
	call Call_1776
	xor a
	ld [$c157], a
	inc a
	ld [$c1a8], a
	ld a, [$c16b]
	cp $04
	jp nz, Jump_000_172d

	xor a
	ldh [$ff96], a
	ldh [$ff97], a
	ldh [$ffb4], a
	ld e, $10
	ld hl, $c280

jr_000_15e2:
	ld [hli], a
	dec e
	jr nz, jr_000_15e2

	ld a, [$c509]
	and a
	jr z, jr_000_1606

	push af
	ld a, $04
	call Call_07B9
	pop af
	call $79fa
	ld hl, $db6e
	inc [hl]
	ld hl, $db46
	inc [hl]
	ld a, $01
	ld [$d47e], a
	xor a
	ldh [$ff9d], a

jr_000_1606:
	ldh a, [$fff9]
	ldh [$ffe4], a
	ld a, $0b
	ld [$db95], a
	xor a
	ld [$db96], a
	ld [$c3cb], a
	ldh [$fff9], a
	ld hl, $d401
	ld a, [$dba5]
	ldh [$ffe6], a
	and a
	jr nz, jr_000_164d

	ld hl, $d416
	ld c, $00

jr_000_1628:
	ldh a, [$ff98]
	swap a
	and $0f
	ld e, a
	ldh a, [$ff99]
	sub $08
	and $f0
	or e
	cp [hl]
	jr z, jr_000_1640

	inc hl
	inc c
	ld a, c
	cp $04
	jr nz, jr_000_1628

jr_000_1640:
	ld a, c
	sla a
	sla a
	add c
	ld e, a
	ld d, $00
	ld hl, $d401
	add hl, de

jr_000_164d:
	push hl
	ld a, [hli]
	ld [$dba5], a
	cp $02
	jr nz, jr_000_1660

	ldh [$fff9], a
	dec a
	ld [$dba5], a
	ld a, $01
	ldh [$ff9c], a

jr_000_1660:
	ld a, [hli]
	ldh [$fff7], a
	ld a, [$dba5]
	and a
	ld a, [hli]
	ldh [$fff6], a
	jr nz, jr_000_1677

	ldh a, [$ffe6]
	and a
	jr z, jr_000_1675

	xor a
	ld [$d47c], a

jr_000_1675:
	jr jr_000_16d4

jr_000_1677:
	ld c, a
	ld a, $14
	call Call_07B9
	push hl
	ldh a, [$fff7]
	swap a
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $4200
	add hl, de
	ldh a, [$fff7]
	cp $06
	jr nz, jr_000_16a1

	ld a, [$db6b]
	and $04
	jr z, jr_000_16a1

	ld hl, $44c0

jr_000_16a1:
	ld e, $00

jr_000_16a3:
	ld a, [hli]
	cp c
	jr z, jr_000_16ad

	inc e
	ld a, e
	cp $40
	jr nz, jr_000_16a3

jr_000_16ad:
	ld a, e
	ld [$dbae], a
	ldh a, [$ffe6]
	and a
	jr nz, jr_000_16d3

	xor a
	ld [$d47c], a
	ldh a, [$fff7]
	cp $0a
	jr nc, jr_000_16d3

	ld a, $02
	call Call_07B9
	call $6a9b
	ld a, $30
	ldh [$ffb4], a
	xor a
	ld [$d6fb], a
	ld [$d6f8], a

jr_000_16d3:
	pop hl

jr_000_16d4:
	ld a, [hli]
	ld [$db9d], a
	ld a, [hl]
	ld [$db9e], a
	pop hl
	ldh a, [$fff9]
	and a
	jr nz, jr_000_172e

	ldh a, [$ffe4]
	and a
	jr nz, jr_000_172d

	ld a, [$dba5]
	and a
	jr z, Call_1716

	ldh a, [$fff7]
	cp $0a
	jr nc, Call_1716

	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $53e5
	add hl, de
	ld a, $14
	ld [$2100], a
	call Call_1716
	push de
	ldh a, [$fff7]
	ld e, a
	ld d, $00
	ld hl, $5412
	add hl, de
	ld a, [hl]
	pop de
	ld [de], a
	ret


Call_1716::
	ld a, $00
	ldh [$ffd7], a
	ld de, $db5f

jr_000_171d:
	ld a, [hli]
	ld [de], a
	inc de
	ldh a, [$ffd7]
	inc a
	ldh [$ffd7], a
	cp $05
	jr nz, jr_000_171d

	ld a, [$dbae]
	ld [de], a

Jump_000_172d:
jr_000_172d:
	ret


jr_000_172e:
	xor a
	ldh [$ff9e], a
	ret


	call $780f
	ld a, [$d474]
	and a
	jr z, jr_000_1750

	xor a
	ld [$d474], a
	ld a, $30
	ld [$c180], a
	ld a, $03
	ld [$c17f], a
	ld a, $04
	ld [$c16b], a
	jr jr_000_175a

jr_000_1750:
	call Call_17C3
	ld a, [$c16b]
	cp $04
	jr nz, jr_000_1775

jr_000_175a:
	ld a, [$d463]
	cp $01
	jr z, jr_000_1763

	ld a, $00

jr_000_1763:
	ld [$c11c], a
	ld a, [$d47e]
	and a
	jr z, jr_000_1775

	xor a
	ld [$d47e], a
	ld a, $36
	call Call_2197

jr_000_1775:
	ret


Call_1776::
	ld hl, $c16c
	inc [hl]
	ld a, [$c16c]
	and $03
	jr nz, jr_000_17b6

	ld hl, $c16b
	ld a, [hl]
	cp $04
	jr z, jr_000_17b6

	inc [hl]
	xor a
	ldh [$ffd7], a

jr_000_178d:
	ldh a, [$ffd7]
	cp $03
	jr z, jr_000_17b6

	ld hl, $db97
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld c, a
	ld b, $00

jr_000_179e:
	ld a, c
	and $03
	jr z, jr_000_17a4

	dec c

jr_000_17a4:
	rrc c
	rrc c
	inc b
	ld a, b
	cp $04
	jr nz, jr_000_179e

	ld a, c
	ld [hl], a
	ld hl, $ffd7
	inc [hl]
	jr jr_000_178d

jr_000_17b6:
	ret


	db $00, $01, $02, $03, $00, $03, $01, $00, $00, $01, $02, $03

Call_17C3::
	ld hl, $c16c
	inc [hl]
	ld a, [$c16c]
	and $03
	jr nz, jr_000_1812

	ld hl, $c16b
	ld a, [hl]
	inc [hl]
	cp $04
	jr z, jr_000_17b6

	xor a
	ldh [$ffd7], a

jr_000_17da:
	ldh a, [$ffd7]
	cp $03
	jr z, jr_000_1812

	ld hl, $db97
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	push hl
	ld c, a
	ld b, $00

jr_000_17ec:
	ldh a, [$ffd7]
	sla a
	sla a
	or b
	ld e, a
	ld hl, $17b7
	add hl, de
	ld a, c
	and $03
	cp [hl]
	jr z, jr_000_17ff

	inc c

jr_000_17ff:
	rrc c
	rrc c
	inc b
	ld a, b
	cp $04
	jr nz, jr_000_17ec

	ld a, c
	pop hl
	ld [hl], a
	ld hl, $ffd7
	inc [hl]
	jr jr_000_17da

jr_000_1812:
	ret


	db $00, $02, $02, $00, $10, $02, $12, $00, $04, $06, $06, $04, $08, $0a, $0c, $0e
	db $18, $0a, $1c, $0e, $0a, $08, $0e, $0c, $0a, $18, $0e, $1c, $20, $22, $24, $26
	db $28, $2a, $2a, $28, $30, $32, $20, $22, $34, $36, $24, $26, $38, $3a, $28, $2a
	db $3a, $38, $2a, $28, $40, $40, $42, $42, $44, $46, $48, $4a, $4c, $4e, $50, $52
	db $4e, $4c, $52, $50, $80, $02, $82, $00, $84, $86, $88, $8a, $8c, $8e, $90, $92
	db $94, $96, $98, $9a, $9c, $9e, $9a, $a2, $a4, $08, $a6, $0c, $a8, $aa, $ac, $ae
	db $b0, $b2, $b4, $b6, $b0, $b2, $b4, $b6, $04, $c0, $06, $c2, $5a, $58, $5e, $5c
	db $58, $5a, $5c, $5e, $44, $46, $6e, $6e, $40, $40, $56, $56, $7a, $78, $7e, $7c
	db $78, $7a, $7c, $7e, $74, $76, $76, $74, $70, $72, $72, $70, $ca, $c8, $d6, $d4
	db $c8, $ca, $d4, $d6, $cc, $ce, $d8, $da, $c4, $c4, $c6, $c6, $dc, $dc, $de, $de
	db $ea, $ec, $ee, $f0, $f2, $f4, $f6, $f6, $f8, $fa, $e0, $e2, $e4, $e6, $e8, $e8
	db $10, $12, $14, $16, $18, $1c, $12, $10, $16, $14, $1c, $18, $66, $68, $6a, $6c
	db $68, $66, $68, $66, $6c, $6a, $66, $68, $60, $60, $62, $62, $64, $64, $62, $62
	db $64, $64, $60, $60, $54, $54, $3c, $3e, $fe, $fe, $18, $1a, $1c, $1e, $2c, $2e
	db $b8, $ba, $2e, $2c, $ba, $b8, $bc, $be, $d0, $d2, $a0, $fc, $fc, $a0, $00, $00
	db $20, $20, $00, $00, $00, $20, $00, $00, $20, $20, $00, $00, $00, $00, $00, $00
	db $00, $00, $20, $20, $20, $20, $20, $20, $20, $20, $00, $00, $00, $00, $00, $00
	db $20, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20
	db $20, $20, $00, $20, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20
	db $20, $20, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $20, $00, $00, $20, $00, $20, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $00, $20, $00, $20, $00, $20, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $20, $20, $00, $00, $20, $20, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $20, $00, $20, $00, $20, $00, $20, $00, $00
	db $00, $00, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00
	db $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $00, $00, $00, $00, $60, $60
	db $20, $20, $20, $20, $40, $40, $00, $20, $00, $20, $00, $20, $40, $60, $40, $60
	db $40, $60, $00, $20, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00
	db $20, $20, $20, $20, $00, $00, $00, $00, $00, $00, $20, $20

Call_19EF::
	ld a, [$c120]
	sra a
	sra a
	sra a
	and $01
	ld d, a
	ldh a, [$ff9e]
	sla a
	or d
	ld c, a
	ld b, $00
	ld hl, $48f6
	ld a, [$c11c]
	cp $01
	jr nz, jr_000_1a17

	ldh a, [$ff9c]
	and a
	jr z, jr_000_1a15

	ld hl, $48fe

jr_000_1a15:
	jr jr_000_1a66

jr_000_1a17:
	ldh a, [$fff9]
	and a
	jr z, jr_000_1a27

	ldh a, [$ff9c]
	cp $02
	jr nz, jr_000_1a27

	ld hl, $4906
	jr jr_000_1a66

jr_000_1a27:
	ld a, [$c15c]
	cp $01
	jr z, jr_000_1a63

	ldh a, [$ffb2]
	and a
	jr nz, jr_000_1a39

	ld a, [$c144]
	and a
	jr nz, jr_000_1a5e

jr_000_1a39:
	ld a, [$c15a]
	and a
	jr nz, jr_000_1a44

	ld hl, $48be
	jr jr_000_1a66

jr_000_1a44:
	ld hl, $48c6
	cp $02
	jr nz, jr_000_1a4e

	ld hl, $48d6

jr_000_1a4e:
	ld a, [$c15b]
	and a
	jr z, jr_000_1a5c

	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a

jr_000_1a5c:
	jr jr_000_1a66

jr_000_1a5e:
	ld hl, $48e6
	jr jr_000_1a66

jr_000_1a63:
	ld hl, $48ee

jr_000_1a66:
	add hl, bc
	ld a, [hl]
	ldh [$ff9d], a
	ret


jr_000_1a6b:
	ld a, [$d601]
	and a
	ret nz

	ld a, $10
	ld [$2100], a
	ld hl, $6500
	ld de, $9500
	ldh a, [$ffe7]
	and $0f
	jr z, jr_000_1a87

	cp $08
	ret nz

	ld l, $40
	ld e, l

jr_000_1a87:
	ldh a, [$ffe7]
	and $30
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld bc, $0040
	jp Call_28C5


	db $20, $60, $a0, $e0, $e0, $e0, $a0, $60

Call_1AA9::
	ld a, [$db95]
	cp $09
	jr z, jr_000_1a6b

	cp $00
	jr nz, jr_000_1adf

	ld a, [$d601]
	and a
	jp nz, Jump_000_1ade

	ldh a, [$ffe7]
	and $0f
	cp $04
	jr c, jr_000_1ade

	ld a, $10
	ld [$2100], a
	ld a, [$d006]
	ld l, a
	ld a, [$d007]
	ld h, a
	ld a, [$d008]
	ld e, a
	ld a, [$d009]
	ld d, a
	ld bc, $0020
	call Call_28C5

Jump_000_1ade:
jr_000_1ade:
	ret


jr_000_1adf:
	ld a, [$db95]
	cp $01
	jr nz, jr_000_1aec

	ldh a, [$ffa5]
	and a
	jr nz, jr_000_1b1b

	ret


jr_000_1aec:
	cp $0b
	jp c, Jump_000_1d14

	ld a, [$db9a]
	cp $80
	jp nz, Jump_000_1d14

	ld a, [$c14f]
	and a
	jp nz, Call_1CCC

	ld hl, $c124
	ld a, [$d601]
	or [hl]
	jp nz, Call_1CCC

	ld a, [$d6f8]
	and a
	jr z, jr_000_1b16

	call Call_1DEE
	jp Call_1CCC


jr_000_1b16:
	ldh a, [$ffa5]
	and a
	jr z, jr_000_1b66

jr_000_1b1b:
	cp $01
	jp z, Jump_000_3fbd

	cp $02
	jp z, Jump_000_3fd3

	cp $03
	jp z, Jump_000_1dcf

	cp $04
	jp z, Jump_000_1dd6

	cp $08
	jp z, Jump_000_1d8c

	cp $09
	jp z, Call_1DBE

	cp $0a
	jp z, Call_1D54

	cp $0b
	jp z, Jump_000_1dad

	cp $0c
	jp z, Jump_000_1d5c

	cp $0d
	jp z, Jump_000_1d2d

	cp $0e
	jr z, jr_000_1b5e

	cp $0f
	jp z, Jump_000_1d1c

	cp $10
	jp z, Jump_000_1d15

	jp Call_1CCC


jr_000_1b5e:
	ld a, $17
	ld [$2100], a
	jp $4060


jr_000_1b66:
	ldh a, [$ffa6]
	inc a
	ldh [$ffa6], a

Call_1B6B::
	ldh a, [$ffa4]
	rst $00

JumpTable_1B6E::
	dw Jump_1C5A
	dw Jump_1B90
	dw Jump_1BAA
	dw Jump_1BAE
	dw Jump_1BCD
	dw Jump_1BF1
	dw Jump_1BF5
	dw Jump_1C10
	dw Jump_1C21
	dw Jump_1C30
	dw Jump_1C3F
	dw Jump_1BB6
	dw Jump_1BB2
	dw Jump_1C4A
	dw Jump_1C56
	dw Jump_1C4E
	dw Jump_1C52

Jump_1B90::
	ldh a, [$ffa6]
	and $07
	jp nz, Jump_1C5A

	ld a, $01
	ld [$2100], a
	call $5f62
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


Jump_000_1ba7:
	ld l, a
	jr jr_000_1be5

Jump_1BAA::
	ld h, $6b
	jr jr_000_1bb8

Jump_1BAE::
	ld h, $6c
	jr jr_000_1bb8

Jump_1BB2::
	ld h, $73
	jr jr_000_1bb8

Jump_1BB6::
	ld h, $6a

jr_000_1bb8:
	ldh a, [$ffa6]
	and $0f
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


	db $00, $40, $80, $c0, $c0, $c0, $80, $40

Jump_1BCD::
	ldh a, [$ffa6]
	and $07
	jp nz, Jump_1C5A

	ldh a, [$ffa6]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $1bc5
	add hl, de
	ld l, [hl]
	ld h, $6d

Jump_000_1be5:
jr_000_1be5:
	ld de, $96c0

Jump_000_1be8:
	ld bc, $0040
	call Call_28C5
	jp Call_1CCC


Jump_1BF1::
	ld h, $6e
	jr jr_000_1bb8

Jump_1BF5::
	ldh a, [$ffa6]
	and $07
	jp nz, Jump_1C5A

	ldh a, [$ffa6]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $1bc5
	add hl, de
	ld l, [hl]
	ld h, $6f
	jp Jump_000_1be5


Jump_1C10::
	ldh a, [$ffa6]
	inc a
	and $03
	jp nz, Jump_1BCD

	ld hl, $dcc0
	ld de, $90c0
	jp Jump_000_1be8


Jump_1C21::
	ld h, $70

jr_000_1c23:
	ldh a, [$ffa6]
	and $07
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


Jump_1C30::
	ld h, $71

jr_000_1c32:
	ldh a, [$ffa6]
	and $03
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


Jump_1C3F::
	ld h, $72
	jr jr_000_1c32

Call_1C43::
	ldh a, [$ffa7]
	add $40
	ldh [$ffa7], a
	ret


Jump_1C4A::
	ld h, $75
	jr jr_000_1c32

Jump_1C4E::
	ld h, $74
	jr jr_000_1c23

Jump_1C52::
	ld h, $77
	jr jr_000_1c23

Jump_1C56::
	ld h, $76
	jr jr_000_1c23

Jump_1C5A::
	ldh a, [$ff9d]
	cp $ff
	jp z, Call_1CCC

	ld hl, $1813
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
	push hl
	ld hl, $1901
	add hl, bc
	ld a, [$c11d]
	and $9f
	or [hl]
	ld [$c11d], a
	inc hl
	ld a, [$c11e]
	and $9f
	or [hl]
	ld [$c11e], a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
	pop bc
	ld hl, $8000
	ld d, $20

jr_000_1ca0:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, jr_000_1ca0

	pop hl
	inc hl
	ld e, [hl]
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
	pop bc
	ld hl, $8020
	ld d, $20

jr_000_1cc6:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, jr_000_1cc6

Call_1CCC::
	ldh a, [$ff9d]
	inc a
	jr z, jr_000_1d14

	ld a, [$dbc7]
	rla
	rla
	and $10
	ld [$c135], a
	ld hl, $c008
	ld a, [$c13b]
	ld c, a
	ld a, [$c145]
	add c
	cp $88
	jr nc, jr_000_1d14

	push af
	ld [hli], a
	ld a, [$c13c]
	ld c, a
	ldh a, [$ff98]
	add c
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, [$c135]
	ld d, a
	ld a, [$c11d]
	or d
	ld [hli], a
	pop af
	ld [hli], a
	ldh a, [$ff98]
	add c
	add $08
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, [$c135]
	ld d, a
	ld a, [$c11e]
	or d
	ld [hli], a

Jump_000_1d14:
jr_000_1d14:
	ret


Jump_000_1d15:
	ld hl, $4f00
	ld a, $0e
	jr jr_000_1d21

Jump_000_1d1c:
	ld a, $12
	ld hl, $6080

jr_000_1d21:
	ld [$2100], a
	ld de, $8400
	ld bc, $0040
	jp Jump_000_1e4d


Jump_000_1d2d:
	ld a, [$db0e]
	cp $02
	jp c, Jump_000_1e50

	sub $02
	ld d, a
	ld e, $00
	sra d
	rr e
	sra d
	rr e
	ld hl, $4400
	add hl, de
	ld de, $89a0
	ld bc, $0040
	ld a, $0c
	ld [$2100], a
	jp Jump_000_1e4d


Call_1D54::
	ld hl, $68c0
	ld de, $88e0
	jr jr_000_1dc4

Jump_000_1d5c:
	ld a, $11
	ld [$2100], a
	ld a, [$d000]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $8d00
	add hl, de
	push hl
	ld hl, $5000

jr_000_1d7b:
	add hl, de
	pop de
	ld bc, $0040
	call Call_28C5
	xor a
	ldh [$ffa5], a
	ld a, $0c
	ld [$2100], a
	ret


Jump_000_1d8c:
	ld a, $13
	ld [$2100], a
	ld a, [$d000]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $8d00
	add hl, de
	push hl
	ld hl, $4d00
	jr jr_000_1d7b

Jump_000_1dad:
	ld hl, $48e0
	ld de, $88e0
	ld a, $0c
	ld [$2100], a
	ld bc, $0020
	jp Jump_000_1e4d


Call_1DBE::
	ld hl, $68e0
	ld de, $8ca0

jr_000_1dc4:
	ld a, $0c
	ld [$2100], a
	ld bc, $0020
	jp Jump_000_1e4d


Jump_000_1dcf:
	ld hl, $7f00
	ld a, $12
	jr jr_000_1ddb

Jump_000_1dd6:
	ld hl, $4c40
	ld a, $0d

jr_000_1ddb:
	ld [$2100], a
	ld de, $9140
	jp Jump_000_1e4a


	db $40, $68, $40, $68, $00, $68, $80, $68, $00, $68

Call_1DEE::
	ld hl, $2100
	ld [hl], $0c
	ld hl, $ffa1
	ld [hl], $01
	ld hl, $d6fb
	ld e, [hl]
	ld d, $00
	inc a
	cp $03
	jr nz, jr_000_1e0d

	push af
	ld a, [$d6fb]
	xor $02
	ld [$d6fb], a
	pop af

jr_000_1e0d:
	ld [$d6f8], a
	cp $04
	jr nz, jr_000_1e19

	ld hl, $1de4
	jr jr_000_1e20

jr_000_1e19:
	cp $08
	jr nz, jr_000_1e26

	ld hl, $1de8

jr_000_1e20:
	add hl, de
	ld de, $9040
	jr jr_000_1e3e

jr_000_1e26:
	cp $06
	jr nz, jr_000_1e2f

	ld hl, $1de4
	jr jr_000_1e3a

jr_000_1e2f:
	cp $0a
	jr nz, jr_000_1e47

	xor a
	ld [$d6f8], a
	ld hl, $1dea

jr_000_1e3a:
	add hl, de
	ld de, $9080

jr_000_1e3e:
	ld bc, $0040
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp Call_28C5


jr_000_1e47:
	jp Call_1CCC


Jump_000_1e4a:
	ld bc, $0040

Jump_000_1e4d:
	call Call_28C5

Jump_000_1e50:
	xor a
	ldh [$ffa5], a
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


	db $0c, $03, $08, $08, $0a, $0a, $05, $10, $36, $38, $3a, $3c, $02, $01, $08, $04
	db $fc, $04, $00, $00, $00, $00, $04, $00

Call_1E73::
	call Call_1E7B
	ld a, $02
	jp Call_07B9


Call_1E7B::
	ld hl, $c14a
	ld a, [$c15c]
	or [hl]
	ld hl, $ffa2
	or [hl]
	ld hl, $c11c
	or [hl]
	jp nz, Jump_000_20a5

	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $1e5b
	add hl, de
	ldh a, [$ff98]
	add [hl]
	sub $08
	and $f0
	ldh [$ffce], a
	swap a
	ld c, a
	ld hl, $1e5f
	add hl, de
	ldh a, [$ff99]
	add [hl]
	sub $10
	and $f0
	ldh [$ffcd], a
	or c
	ld e, a
	ldh [$ffd8], a
	ld hl, $d711
	add hl, de
	ld a, h
	cp $d7
	jp nz, Jump_000_207c

	ld a, [hl]
	ldh [$ffd7], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	ldh [$ffdc], a
	ldh a, [$ffd7]
	cp $9a
	jr z, jr_000_1f10

	ldh a, [$ffdc]
	cp $00
	jp z, Jump_000_207c

	cp $01
	jr z, jr_000_1ef8

	cp $50
	jp z, Jump_000_207c

	cp $51
	jp z, Jump_000_207c

	cp $11
	jp c, Jump_000_207c

	cp $d4
	jp nc, Jump_000_207c

	cp $d0
	jr nc, jr_000_1ef8

	cp $7c
	jp nc, Jump_000_207c

jr_000_1ef8:
	ldh a, [$ffd7]
	ld e, a
	cp $6f
	jr z, jr_000_1f08

	cp $5e
	jr z, jr_000_1f08

	cp $d4
	jp nz, Jump_000_1fa1

jr_000_1f08:
	ld a, [$dba5]
	and a
	ld a, e
	jp nz, Jump_000_1fa1

jr_000_1f10:
	ld e, a
	ldh a, [$ff9e]
	cp $02
	jp nz, Jump_000_1ffd

	ld a, $02
	ld [$c1ad], a
	ldh a, [$ffcc]
	and $30
	jp z, Jump_000_1ffd

	ld a, e
	cp $5e
	ld a, $8e
	jr z, jr_000_1f96

	ld a, e
	cp $6f
	jr z, jr_000_1f5b

	cp $d4
	jr z, jr_000_1f5b

	ld a, [$db73]
	and a
	jr z, jr_000_1f42

	ld a, $78
	call Call_218E
	jp Jump_000_1ffd


jr_000_1f42:
	ld a, [$db4e]
	and a
	ldh a, [$fff6]
	jr nz, jr_000_1f50

	ld e, $ff
	cp $a3
	jr z, jr_000_1f58

jr_000_1f50:
	ld e, $fc
	cp $fa
	jr z, jr_000_1f58

	ld e, $fd

jr_000_1f58:
	ld a, e
	jr jr_000_1f9c

jr_000_1f5b:
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld a, $14
	ld [$2100], a
	ld hl, $55ff
	add hl, de
	ld a, [$db49]
	ld e, a
	ld a, [hl]
	cp $a9
	jr nz, jr_000_1f78

	bit 0, e
	jr z, jr_000_1f78

	ld a, $af

jr_000_1f78:
	cp $af
	jr nz, jr_000_1f92

	bit 0, e
	jr nz, jr_000_1f92

	ldh a, [$ffce]
	swap a
	and $0f
	ld e, a
	ldh a, [$ffcd]
	and $f0
	or e
	ld [$d473], a
	jp Jump_000_1ffd


jr_000_1f92:
	cp $83
	jr z, jr_000_1f9c

jr_000_1f96:
	call Call_2185
	jp Jump_000_1ffd


jr_000_1f9c:
	call Call_2197
	jr jr_000_1ffd

Jump_000_1fa1:
	cp $a0
	jr nz, jr_000_1ffd

	ld a, [$c18e]
	and $1f
	cp $0d
	jr z, jr_000_1ffd

	ldh a, [$ff9e]
	cp $02
	jr nz, jr_000_1ffd

	ld [$c1ad], a
	ldh a, [$ffcc]
	and $30
	jr z, jr_000_1ffd

	ldh a, [$fff9]
	and a
	jr nz, jr_000_1fc8

	ldh a, [$ff9e]
	cp $02
	jr nz, jr_000_1ffd

jr_000_1fc8:
	ld a, $14
	ld [$2100], a
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_1fdf

	cp $06
	jr c, jr_000_1fdf

	inc d

jr_000_1fdf:
	ld hl, $4500
	add hl, de
	ld a, [hl]
	cp $20
	jr nz, jr_000_1ff3

	ld a, [$db4e]
	cp $02
	ld a, $20
	jr c, jr_000_1ff3

	ld a, $1c

jr_000_1ff3:
	ldh [$ffdf], a
	ld a, $02
	ld [$2100], a
	call $41ba

Jump_000_1ffd:
jr_000_1ffd:
	ld a, [$db00]
	cp $03
	jr nz, jr_000_200b

	ldh a, [$ffcb]
	and $20
	jr nz, jr_000_201a

	ret


jr_000_200b:
	ld a, [$db01]
	cp $03
	jp nz, Jump_000_20a5

	ldh a, [$ffcb]
	and $10
	jp z, Jump_000_20a5

jr_000_201a:
	ld a, $02
	ld [$2100], a
	call $485e
	ld a, $01
	ldh [$ffa1], a
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $1e63
	add hl, de
	ld a, [hl]
	ldh [$ff9d], a
	ld hl, $1e67
	add hl, de
	ldh a, [$ffcb]
	and [hl]
	jr z, jr_000_207c

	ld hl, $1e6b
	add hl, de
	ld a, [hl]
	ld [$c13c], a
	ld hl, $1e6f
	add hl, de
	ld a, [hl]
	ld [$c13b], a
	ld hl, $ff9d
	inc [hl]
	ld e, $08
	ld a, [$d47c]
	cp $01
	jr nz, jr_000_205a

	ld e, $03

jr_000_205a:
	ld hl, $c15f
	inc [hl]
	ld a, [hl]
	cp e
	jr c, jr_000_207b

	xor a
	ldh [$ffe5], a
	ldh a, [$ffd7]
	cp $8e
	jr z, jr_000_2081

	cp $20
	jr z, jr_000_2081

	ld a, [$dba5]
	and a
	jr nz, jr_000_207b

	ldh a, [$ffd7]
	cp $5c
	jr z, jr_000_208f

jr_000_207b:
	ret


Jump_000_207c:
jr_000_207c:
	xor a
	ld [$c15f], a
	ret


jr_000_2081:
	call Call_2093
	ld a, $14
	ld [$2100], a
	call $55aa
	jp Call_07C0


jr_000_208f:
	ld a, $01
	ldh [$ffe5], a

Call_2093::
	ldh a, [$ffd8]
	ld e, a
	ldh a, [$ffd7]
	ldh [$ffaf], a
	call Call_20A6
	ldh a, [$ff9e]
	ld [$c15d], a
	call Call_20B1

Jump_000_20a5:
	ret


Call_20A6::
	ld a, $14
	ld [$2100], a
	call $59de
	jp Call_07C0


Call_20B1::
	ld a, $05
	call Call_10EB
	jr c, jr_000_20d5

	ld a, $02
	ldh [$fff3], a
	ld hl, $c280
	add hl, de
	ld [hl], $07
	ld hl, $c3b0
	add hl, de
	ldh a, [$ffe5]
	ld [hl], a
	push de
	pop bc
	ld e, $01
	ld a, $03
	call Call_07B9
	call $57ef

jr_000_20d5:
	ret


Call_20D6::
	ld a, [$c14f]
	and a
	ret nz

	ld c, $01
	call Call_20E4

Call_20E0::
	ld c, $00
	ldh [$ffd7], a

Call_20E4::
	ld b, $00
	ld hl, $ff9a
	add hl, bc
	ld a, [hl]
	push af
	swap a
	and $f0
	ld hl, $c11a
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $ff98
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_000_2105

	ld e, $f0

jr_000_2105:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a
	ret


Call_210F::
	ldh a, [$ffa3]
	push af
	swap a
	and $f0
	ld hl, $c149
	add [hl]
	ld [hl], a
	rl d
	ld hl, $ffa2
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_000_2129

	ld e, $f0

jr_000_2129:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a
	ret


Call_2133::
	ld a, [$c19f]
	and a
	ret z

	ld e, a
	ld a, [$db95]
	cp $01
	ld a, $7e
	jr nz, jr_000_2144

	ld a, $7f

jr_000_2144:
	ldh [$ffe8], a
	ld a, [$c164]
	and a
	ld a, [$c170]
	jr nz, jr_000_2153

	cp $20
	jr c, jr_000_2157

jr_000_2153:
	and $0f
	or $10

jr_000_2157:
	ld [$c171], a
	ld a, e
	and $7f
	dec a
	rst $00

JumpTable_215F::
	dw Jump_217D
	dw Jump_21C2
	dw Jump_21C2
	dw Jump_21C2
	dw Jump_2253
	dw Jump_2320
	dw Jump_2359
	dw Jump_23B5
	dw Jump_2521
	dw Jump_25A0
	dw Jump_25F4
	dw Jump_2295
	dw Jump_261F
	dw Jump_22CE
	dw Jump_21C3

Jump_217D::
	ld a, $14
	ld [$2100], a
	jp $5924


Call_2185::
	call Call_2197
	ld a, $01
	ld [$c112], a
	ret


Call_218E::
	call Call_2197
	ld a, $02
	ld [$c112], a
	ret


Call_2197::
	push af
	xor a
	ld [$c177], a
	pop af
	ld [$c173], a
	xor a
	ld [$c16f], a
	ld [$c170], a
	ld [$c164], a
	ld [$c108], a
	ld [$c112], a
	ld a, $0f
	ld [$c5ab], a
	ldh a, [$ff99]
	cp $48
	rra
	and $80
	or $01
	ld [$c19f], a
	ret


Jump_21C2::
	ret


Jump_21C3::
	xor a
	ld [$c19f], a
	ld a, $18
	ld [$c134], a
	ret


	db $00, $24, $48, $00, $24, $48, $98, $98, $98, $99, $99, $99, $21, $61, $a1, $41
	db $81, $c1

Call_21DF::
	ld a, [$c19f]
	bit 7, a
	jr z, jr_000_21ea

	and $7f
	add $03

jr_000_21ea:
	ld e, a
	ld d, $00
	ld hl, $21cb
	add hl, de
	ld a, [hl]
	ld c, a
	ld b, $00
	ld hl, $d500
	add hl, bc
	push hl
	pop bc
	ld hl, $21d7
	add hl, de
	ld a, [$c12f]
	add [hl]
	ld l, a
	ldh [$ffd7], a
	ld hl, $21d1
	add hl, de
	ld a, [$c12e]
	add [hl]
	ld h, a
	ldh a, [$ffd7]
	ld l, a
	xor a
	ld e, a
	ld d, a

jr_000_2215:
	ld a, [hl]
	ld [bc], a
	inc bc
	ld a, l
	add $01
	and $1f
	jr nz, jr_000_2225

	ld a, l
	and $e0
	ld l, a
	jr jr_000_2226

jr_000_2225:
	inc l

jr_000_2226:
	inc e
	ld a, e
	cp $12
	jr nz, jr_000_2215

	ld e, $00
	ldh a, [$ffd7]
	add $20
	ldh [$ffd7], a
	jr nc, jr_000_2237

	inc h

jr_000_2237:
	ld l, a
	inc d
	ld a, d
	cp $02
	jr nz, jr_000_2215

	ret


	db $61, $41, $81, $21, $a1, $81, $61, $a1, $41, $c1, $98, $98, $98, $98, $98, $99
	db $99, $99, $99, $99

Jump_2253::
	ld a, [$c19f]
	ld c, a
	ld a, [$c16f]
	cp $05
	jr z, Call_2290

	bit 7, c
	jr z, jr_000_2264

	add $05

jr_000_2264:
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
	ld a, [$c12e]
	ld hl, $2249
	add hl, bc
	add [hl]
	ld hl, $d600
	add hl, de
	ld [hli], a
	push hl
	ld a, [$c12f]
	ld hl, $223f
	add hl, bc
	add [hl]
	pop hl
	ld [hli], a
	ld a, $51
	ld [hli], a
	ldh a, [$ffe8]
	ld [hli], a
	ld [hl], $00
	ld hl, $c16f
	inc [hl]
	ret


Call_2290::
	ld hl, $c19f
	inc [hl]
	ret


Jump_2295::
	ld a, [$c1ab]
	and a
	jr nz, jr_000_22af

	ldh a, [$ffcc]
	and $30
	jr z, jr_000_22af

Call_22A1::
	xor a
	ld [$c16f], a
	ld a, [$c19f]
	and $f0
	or $0e
	ld [$c19f], a

jr_000_22af:
	ret


	db $a1, $21, $81, $41, $61, $c1, $41, $a1, $61, $81, $98, $98, $98, $98, $98, $99
	db $99, $99, $99, $99, $48, $00, $36, $12, $24, $48, $00, $36, $12, $24

Jump_22CE::
	ld a, [$c19f]
	ld c, a
	ld a, [$c16f]
	cp $05
	jr z, Call_2290

	bit 7, c
	jr z, jr_000_22df

	add $05

jr_000_22df:
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
	ld a, [$c12e]
	ld hl, $22ba
	add hl, bc
	add [hl]
	ld hl, $d600
	add hl, de
	ld [hli], a
	push hl
	ld a, [$c12f]
	ld hl, $22b0
	add hl, bc
	add [hl]
	pop hl
	ld [hli], a
	ld a, $11
	ld [hli], a
	push hl
	ld hl, $22c4
	add hl, bc
	ld a, [hl]
	ld c, a
	ld b, $00
	ld hl, $d500
	add hl, bc
	push hl
	pop bc
	pop hl
	ld e, $12

jr_000_2313:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_000_2313

	ld [hl], $00
	ld hl, $c16f
	inc [hl]
	ret


Jump_2320::
	ld a, $1c
	ld [$2100], a
	ld a, [$c172]
	and a
	jr z, jr_000_2330

	dec a
	ld [$c172], a
	ret


jr_000_2330:
	ld a, [$c170]
	and $1f
	ld e, a
	ld d, $00
	ld c, $01
	ld b, $00
	ld hl, $4521
	add hl, de
	ld a, [hl]
	ld hl, $d600
	add hl, bc
	ld [hli], a
	push hl
	ld hl, $4501
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	ld a, $4f
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld [hl], $00
	jp Call_2290


Jump_2359::
	ld a, $1c
	ld [$2100], a
	ld a, [$c19f]
	ld c, a
	ld a, [$c171]
	bit 7, c
	jr z, jr_000_236b

	add $20

jr_000_236b:
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
	ld a, [$c12e]
	ld hl, $4561
	add hl, bc
	add [hl]
	ld hl, $d600
	add hl, de
	ld [hli], a
	ld [$c175], a
	push hl
	ld hl, $45a1
	add hl, bc
	ld a, [hl]
	and $e0
	add $20
	ld e, a
	ld a, [$c12f]
	add [hl]
	ld d, a
	cp e
	jr c, jr_000_2399

	ld a, d
	sub $20
	ld d, a

jr_000_2399:
	ld a, d
	ld [$c176], a
	pop hl
	ld [hli], a
	xor a
	ld [hli], a
	push hl
	ld a, [$c170]
	and $1f
	ld c, a
	ld hl, $4541
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hli], a
	call Call_2290
	jp Jump_23B5


Jump_23B5::
	ld a, $1c
	ld [$2100], a
	ld a, [$c170]
	and $1f
	ld c, a
	ld b, $00
	ld e, $05
	ld d, $00
	ld hl, $4521
	add hl, bc
	ld a, [hl]
	ld hl, $d600
	add hl, de
	ld [hli], a
	push hl
	ld hl, $4501
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hli], a
	ld a, $0f
	ld [hli], a
	push hl
	ld a, [$c112]
	ld d, a
	ld a, [$c173]
	ld e, a
	sla e
	rl d
	ld hl, $4001
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	push de
	ld a, [$c173]
	ld e, a
	ld a, [$c112]
	ld d, a
	ld hl, $46e1
	add hl, de
	ld a, [hl]
	and $1f
	ld [$2100], a
	pop hl
	ld a, [$c170]
	ld e, a
	ld a, [$c164]
	ld d, a
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld [$c3c3], a
	call Call_07C0
	ld a, e
	ldh [$ffd7], a
	cp $fe
	jr nz, jr_000_2430

	pop hl
	xor a
	ld [$d601], a

Jump_000_2421:
	ld a, [$c19f]
	and $f0
	or $0d
	ld [$c19f], a

Call_242B::
	ld a, $15
	ldh [$fff2], a
	ret


jr_000_2430:
	cp $ff
	jr nz, jr_000_2449

	pop hl
	xor a
	ld [$d601], a

Jump_000_2439:
	ld a, [$c19f]
	and $f0
	or $0c
	ld [$c19f], a
	ret


	db $55, $49, $4a, $46, $47

jr_000_2449:
	cp $20
	jr z, jr_000_246c

	push af
	ld a, [$c5ab]
	ld d, a
	ld e, $01
	cp $0f
	jr z, jr_000_2460

	ld e, $07
	cp $19
	jr z, jr_000_2460

	ld e, $03

jr_000_2460:
	ld a, [$c170]
	add $04
	and e
	jr nz, jr_000_246b

	ld a, d
	ldh [$fff3], a

jr_000_246b:
	pop af

jr_000_246c:
	ld d, $00
	cp $23
	jr nz, jr_000_2494

	ld a, [$c108]
	ld e, a
	inc a
	cp $05
	jr nz, jr_000_247c

	xor a

jr_000_247c:
	ld [$c108], a
	ld hl, $db4f
	ld a, [$db6e]
	and a
	jr z, jr_000_248b

	ld hl, $2444

jr_000_248b:
	add hl, de
	ld a, [hl]
	dec a
	cp $ff
	jr nz, jr_000_2494

	ld a, $20

jr_000_2494:
	ldh [$ffd8], a
	ld e, a
	ld a, $1c
	ld [$2100], a
	ld hl, $45e1
	add hl, de
	ld e, [hl]
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	call Call_07C0
	ld hl, $5000
	add hl, de
	push hl
	pop bc
	pop hl
	ld e, $10

jr_000_24bf:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec e
	jr nz, jr_000_24bf

	ld [hl], $00
	push hl
	ld a, $1c
	ld [$2100], a
	ldh a, [$ffd8]
	ld e, a
	ld d, $00
	xor a
	pop hl
	and a
	jr z, jr_000_24ef

	ld e, a
	ld a, [$c175]
	ld [hli], a
	ld a, [$c176]
	sub $20
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $c9
	rr e
	jr c, jr_000_24ec

	dec a

jr_000_24ec:
	ld [hli], a
	ld [hl], $00

jr_000_24ef:
	ld a, [$c170]
	add $01
	ld [$c170], a
	ld a, [$c164]
	adc $00
	ld [$c164], a
	xor a
	ld [$c1cc], a
	ld a, [$c171]
	cp $1f
	jr z, jr_000_251a

Jump_000_250a:
	ld a, [$c19f]
	and $f0
	or $06
	ld [$c19f], a
	ld a, $00
	ld [$c172], a
	ret


jr_000_251a:
	jp Call_2290


	db $22, $42, $98, $99

Jump_2521::
	ld a, [$c170]
	and $1f
	jr nz, jr_000_256d

	ld a, [$c3c3]
	cp $ff
	jp z, Jump_000_2439

	cp $fe
	jp z, Jump_000_2421

	ld a, [$c1cc]
	and a
	jr nz, jr_000_2542

	inc a
	ld [$c1cc], a
	call Call_242B

jr_000_2542:
	call Call_264D
	ldh a, [$ffcc]
	bit 4, a
	jr nz, jr_000_256d

	bit 5, a
	jr z, Jump_25A0

	ld a, $1c
	ld [$2100], a
	ld a, [$db95]
	cp $07
	jp z, Jump_000_2617

	ld a, [$c173]
	ld e, a
	ld a, [$c112]
	ld d, a
	ld hl, $46e1
	add hl, de
	bit 7, [hl]
	jp z, Jump_000_2617

jr_000_256d:
	ld e, $00
	ld a, [$c19f]
	and $80
	jr z, jr_000_2577

	inc e

jr_000_2577:
	ld d, $00
	ld hl, $251f
	add hl, de
	ld a, [$c12e]
	add [hl]
	ld [$d601], a
	ld hl, $251d
	add hl, de
	ld a, [$c12f]
	add [hl]
	ld [$d602], a
	ld a, $4f
	ld [$d603], a
	ldh a, [$ffe8]
	ld [$d604], a
	xor a
	ld [$d605], a
	call Call_2290

Jump_25A0::
	ret


	db $62, $82, $98, $99

Call_25A5::
	ld e, $00
	ld a, [$c19f]
	and $80
	jr z, jr_000_25af

	inc e

jr_000_25af:
	ld d, $00
	ld hl, $25a3
	add hl, de
	ld a, [$c12e]
	add [hl]
	ld b, a
	ld hl, $25a1

Call_25BD::
	add hl, de
	ld a, [$c12f]
	add [hl]
	ld c, a
	ld e, $10

jr_000_25c5:
	ld a, c
	sub $20
	ld l, a
	ld h, b
	ld a, [bc]
	ld [hl], a
	push bc
	ld a, c
	add $20
	ld c, a
	ld a, l
	add $20
	ld l, a
	ld a, [bc]
	ld [hl], a
	ld a, l
	add $20
	ld l, a
	ldh a, [$ffe8]
	ld [hl], a
	pop bc
	inc bc
	ld a, c
	and $1f
	jr nz, jr_000_25e9

	ld a, c
	sub $20
	ld c, a

jr_000_25e9:
	dec e
	jr nz, jr_000_25c5

	ld a, $08
	ld [$c172], a
	jp Call_2290


Jump_25F4::
	ret


	db $42, $62, $98, $99

Call_25F9::
	ld e, $00
	ld a, [$c19f]
	and $80
	jr z, jr_000_2603

	inc e

jr_000_2603:
	ld d, $00
	ld hl, $25f7
	add hl, de
	ld a, [$c12e]
	add [hl]
	ld b, a
	ld hl, $25f5
	call Call_25BD
	jp Jump_000_250a


Jump_000_2617:
jr_000_2617:
	ld a, $02
	ld [$c177], a
	jp Call_22A1


Jump_261F::
	ldh a, [$ffcc]
	bit 5, a
	jr nz, jr_000_2617

	and $10
	jp nz, Jump_000_2649

	ldh a, [$ffcc]
	and $43
	jr z, jr_000_263c

	ld hl, $c177
	ld a, [hl]
	inc a
	and $01
	ld [hl], a
	ld a, $0a
	ldh [$fff2], a

jr_000_263c:
	ldh a, [$ffe7]
	and $10
	ret z

	ld a, $17
	ld [$2100], a
	jp $7b57


Jump_000_2649:
	call Call_22A1
	ret


Call_264D::
	ld a, $17
	ld [$2100], a
	jp $7b07


Call_2655::
	ld a, $02
	call Call_07B9
	call $7b74
	ret


	db $01, $01, $20, $20, $93, $93, $13, $13, $10, $10, $01, $01, $08, $08, $0a, $0a
	db $01, $ff, $f0, $10, $00, $00, $03, $00, $02, $1e, $c0, $40

Call_267A::
	ld a, $08
	ld [$2100], a
	call Call_2686
	call Call_07C0
	ret


Call_2686::
	ld a, [$c12b]
	cp $00
	jr z, jr_000_2692

	dec a
	ld [$c12b], a
	ret


jr_000_2692:
	ld a, [$c125]
	ld c, a
	ld b, $00
	ld a, $01
	ld [$c12b], a
	ld a, [$c12a]
	ldh [$ffd9], a
	ld hl, $265e
	add hl, bc
	ld a, [$c127]
	ld [$d602], a
	add [hl]
	rl d
	ld [$d619], a
	ld a, [$c126]
	or $98
	ld [$d601], a
	rr d
	adc $00
	ld [$d618], a
	ld hl, $2662
	add hl, bc
	ld a, [hl]
	ld [$d603], a
	ld [$d61a], a
	ld a, $00
	ld [$d62f], a
	ld a, $ee
	ld [$d614], a
	ld [$d615], a
	ld [$d616], a
	ld [$d617], a
	ld [$d62b], a
	ld [$d62c], a
	ld [$d62d], a
	ld [$d62e], a
	ld b, $d6
	ld c, $04
	ld d, $d6
	ld e, $1b

jr_000_26f3:
	push bc
	push de
	ldh a, [$ffd9]
	ld c, a
	ld b, $00
	ld hl, $d711
	add hl, bc
	ld b, $00
	ld c, [hl]
	sla c
	rl b
	sla c
	rl b
	ld hl, $498c
	ld a, [$dba5]
	and a
	jr z, jr_000_2715

	ld hl, $4d60

jr_000_2715:
	add hl, bc
	pop de
	pop bc
	ld a, [$c125]
	and $02
	jr z, jr_000_272d

	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	jr jr_000_2739

jr_000_272d:
	ld a, [hli]
	ld [bc], a
	ld a, [hli]
	ld [de], a
	inc bc
	inc de
	ld a, [hli]
	ld [bc], a
	ld a, [hl]
	ld [de], a
	inc bc
	inc de

jr_000_2739:
	push bc
	ld a, [$c125]
	ld c, a
	ld b, $00
	ld hl, $2666
	add hl, bc
	ldh a, [$ffd9]
	add [hl]
	ldh [$ffd9], a
	pop bc
	ld a, [$c128]
	dec a
	ld [$c128], a
	jr nz, jr_000_26f3

	ld a, [$c125]
	ld c, a
	ld b, $00
	ld hl, $266a
	add hl, bc
	ld a, [hl]
	ld [$c128], a
	ld hl, $266e
	add hl, bc
	ld a, [$c12a]
	add [hl]
	ld [$c12a], a
	ld hl, $2676
	add hl, bc
	ld a, [$c127]
	add [hl]
	rr d
	and $df
	ld [$c127], a
	ld hl, $2672
	add hl, bc
	ld a, [$c126]
	rl d
	adc [hl]
	and $03
	ld [$c126], a
	ld a, [$c129]
	dec a
	ld [$c129], a
	jr nz, jr_000_2796

	jp Jump_000_2797


jr_000_2796:
	ret


Jump_000_2797:
	ld a, [$c124]
	inc a
	ld [$c124], a
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

Call_27A8::
	ld [$d368], a
	ldh [$ffbf], a
	ld a, $38
	ldh [$ffab], a
	xor a
	ldh [$ffa8], a
	ret


Call_27B5::
	push hl
	ld hl, $0000
	ld [hl], $0a
	pop hl
	ret


Call_27BD::
	ld a, $02
	ld [$2100], a
	push bc
	call $4146
	pop bc
	jp Call_07C0


Call_27CA::
	ld a, $38
	ldh [$ffa8], a
	xor a
	ldh [$ffab], a
	ret


Call_27D2::
	ldh a, [$ffbc]
	and a
	jr nz, jr_000_27df

	ld a, $1f
	ld [$2100], a
	call $4003

jr_000_27df:
	jp Call_07C0


Call_27E2::
	ld a, $01
	ld [$2100], a
	call $5bcf
	jp Call_07C0


Call_27ED::
	push hl
	ldh a, [$ffe7]
	ld hl, $c13d
	add [hl]
	ld hl, $ff44
	add [hl]
	rrca
	ld [$c13d], a
	pop hl
	ret


Call_27FE::
	ld a, [$c124]
	and a
	jr nz, jr_000_2838

	ld a, $20
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0f
	ld b, a
	ld a, $10
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	swap a
	cpl
	and $f0
	or b
	ld c, a
	ldh a, [$ffcb]
	xor c
	and c
	ldh [$ffcc], a
	ld a, c
	ldh [$ffcb], a
	ld a, $30
	ldh [rP1], a

jr_000_2838:
	ret


Call_2839::
	push bc
	ldh a, [$ffcd]
	ld hl, $ff97
	add [hl]
	and $f8
	srl a
	srl a
	srl a
	ld de, $0000
	ld e, a
	ld hl, $9800
	ld b, $20

jr_000_2851:
	add hl, de
	dec b
	jr nz, jr_000_2851

	push hl
	ldh a, [$ffce]
	ld hl, $ff96
	add [hl]
	pop hl
	and $f8
	srl a
	srl a
	srl a
	ld de, $0000
	ld e, a
	add hl, de
	ld a, h
	ldh [$ffcf], a
	ld a, l
	ldh [$ffd0], a
	pop bc
	ret


Jump_000_2872:
	ld e, a
	ld d, $00
	sla e
	rl d
	pop hl
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl
	jp hl


Call_2881::
	ldh a, [rIE]
	ldh [$ffd2], a
	res 0, a

jr_000_2887:
	ldh a, [rLY]
	cp $91
	jr nz, jr_000_2887

	ldh a, [rLCDC]
	and $7f
	ldh [rLCDC], a
	ldh a, [$ffd2]
	ldh [rIE], a
	ret


Jump_2898::
	ld a, $01
	call Call_07B9
	call $7cf3
	ret


Jump_28A1::
	ld a, $7e
	ld bc, $0400
	jr jr_000_28ad

Call_28A8::
	ld a, $7f
	ld bc, $0800

jr_000_28ad:
	ld d, a
	ld hl, $9800

jr_000_28b1:
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, jr_000_28b1

	ret


Call_28B9::
	ld [$2100], a
	call Call_28C5
	ld a, $01
	ld [$2100], a
	ret


Call_28C5::
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Call_28C5

	ret


jr_000_28ce:
	inc de
	ld h, a
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	inc de
	call Call_28F2

Call_28D8::
	ld a, [$c124]
	and a
	jr nz, jr_000_28ed

Call_28DE::
	ld a, [de]
	and a
	jr nz, jr_000_28ce

	ret


jr_000_28e3:
	inc de
	ld h, a
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	inc de
	call Call_2948

jr_000_28ed:
	ld a, [de]
	and a
	jr nz, jr_000_28e3

	ret


Call_28F2::
	push af
	and $3f
	ld b, a
	inc b
	pop af
	rlca
	rlca
	and $03
	jr z, jr_000_2906

	dec a
	jr z, jr_000_291a

	dec a
	jr z, jr_000_292e

	jr jr_000_293b

jr_000_2906:
	ld a, [de]
	ld [hli], a
	ld a, l
	and $1f
	jr nz, jr_000_2915

	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

jr_000_2915:
	inc de
	dec b
	jr nz, jr_000_2906

	ret


jr_000_291a:
	ld a, [de]
	ld [hli], a
	ld a, l
	and $1f
	jr nz, jr_000_2929

	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

jr_000_2929:
	dec b
	jr nz, jr_000_291a

	inc de
	ret


jr_000_292e:
	ld a, [de]
	ld [hl], a
	inc de
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
	dec b
	jr nz, jr_000_292e

	ret


jr_000_293b:
	ld a, [de]
	ld [hl], a
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
	dec b
	jr nz, jr_000_293b

	inc de
	ret


Call_2948::
	push af
	and $3f
	ld b, a
	inc b
	pop af
	and $80
	jr nz, jr_000_296a

jr_000_2952:
	ld a, [de]
	cp $ee
	jr z, jr_000_2965

	ld [hli], a
	ld a, l
	and $1f
	jr nz, jr_000_2965

	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

jr_000_2965:
	inc de
	dec b
	jr nz, jr_000_2952

	ret


jr_000_296a:
	ld a, [de]
	cp $ee
	jr z, jr_000_2970

	ld [hl], a

jr_000_2970:
	inc de
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
	dec b
	jr nz, jr_000_296a

	ret


Call_297B::
	ld bc, $1600
	jr jr_000_2996

Call_2980::
	ld bc, $1300
	jr jr_000_2996

	db $01, $2f, $00, $18, $03

Call_298A::
	ld bc, $006d
	ld hl, $ff90
	call Call_2999
	ld bc, $1f00

jr_000_2996:
	ld hl, $c000

Call_2999::
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, Call_2999

	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff

Call_29B8::
	ld a, $14
	ld [$2100], a
	ld hl, $4500
	add hl, de
	ld a, [hl]
	jp Call_07C0


Call_29C5::
	ld a, [$c5ac]
	and a
	jr nz, jr_000_29cf

	ld a, $2d
	ldh [$fff4], a

jr_000_29cf:
	ret


Call_29D0::
	ld a, $01
	ld [$2100], a
	call $5807
	jp Call_07C0


Call_29DB::
	ld a, $08
	ld [$2100], a
	ld hl, $5110
	add hl, de
	ld a, [hl]
	jp Call_07C0


Call_29E8::
	ld a, $08
	ld [$2100], a
	ld hl, $5110
	add hl, de
	ld a, [hl]
	push af
	ld a, $03
	ld [$2100], a
	pop af
	ret


Jump_29FA::
	ld a, $13
	ld [$2100], a
	ld hl, $6800
	ld de, $9000
	ld bc, $0800
	call Call_28C5
	ld hl, $7000
	ld de, $8800
	ld bc, $0800
	jp Call_28C5


Jump_2A17::
	call Call_2A26
	ld de, $8400
	ld hl, $7600
	ld bc, $0100
	jp Call_28C5


Call_2A26::
	ld a, $13
	ld [$2100], a
	ld hl, $4000
	ld de, $8000
	ld bc, $1800
	call Call_28C5
	ld a, $0c
	ld [$2100], a
	ld hl, $57e0
	ld de, $97f0
	ld bc, $0010
	call Call_28C5
	ld a, $12
	ld [$2100], a
	ld hl, $7500
	ld de, $8000
	ld bc, $0040
	call Call_28C5
	ld de, $8d00
	ld hl, $7500
	ld bc, $0200
	jp Call_28C5


Jump_2A65::
	ld a, $0c
	ld [$2100], a
	ld hl, $5000
	ld de, $9000
	ld bc, $0800
	call Call_28C5
	ld a, $12
	ld [$2100], a
	ld hl, $6000
	ld de, $8000
	ld bc, $0800
	call Call_28C5
	ld a, $0f
	ld [$2100], a
	ld hl, $6000
	ld de, $8800
	ld bc, $0800
	jp Call_28C5


Jump_2A98::
	ld hl, $4000
	jr jr_000_2aa5

Jump_2A9D::
	ld hl, $4800
	jr jr_000_2aa5

Jump_2AA2::
	ld hl, $6000

jr_000_2aa5:
	ld a, $13
	ld [$2100], a
	ld de, $8000
	ld bc, $0800
	call Call_28C5
	ld hl, $5800
	ld de, $8800
	ld bc, $1000
	jp Call_28C5


Jump_2ABF::
	call Call_0844
	ld hl, $6800
	ld a, $10
	call Call_2AFC
	call Call_0844
	ld a, $12
	ld [$2100], a
	ld hl, $6600
	ld de, $8000
	ld bc, $0080
	call Call_28C5
	call Call_0844
	ld a, $0c
	ld [$2100], a
	ld hl, $4220
	ld de, $8100
	ld bc, $0020
	jp Call_28C5


Jump_2AF2::
	ld hl, $7800
	jr jr_000_2afa

Jump_2AF7::
	ld hl, $4800

jr_000_2afa:
	ld a, $13

Call_2AFC::
	ld [$2100], a
	ld de, $8000
	ld bc, $0800
	call Call_28C5
	ld a, $13
	ld [$2100], a
	ld hl, $7000
	ld de, $8800
	ld bc, $0800
	call Call_28C5
	ld hl, $6800
	ld de, $9000
	ld bc, $0800
	jp Call_28C5


Call_2B25::
	push bc
	ld a, $14
	ld [$2100], a
	ld hl, $4200
	ldh a, [$fff7]
	cp $0b
	jr nc, jr_000_2b66

	swap a
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ldh a, [$fff7]
	cp $06
	jr nz, jr_000_2b52

	ld a, [$db6b]
	and $04
	jr z, jr_000_2b52

	ld hl, $44c0

jr_000_2b52:
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, $00
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_2b62

	cp $06
	jr c, jr_000_2b62

	inc d

jr_000_2b62:
	ld hl, $d900
	add hl, de

jr_000_2b66:
	call Call_07C0
	pop bc
	ret


Call_2B6B::
	ld a, $0c
	call Call_07B9
	ld hl, $4000
	ld de, $8000
	ld bc, $0400
	call Call_28C5
	ld a, $0c
	call Call_07B9
	ld hl, $4800
	ld de, $8800
	ld bc, $1000
	call Call_28C5
	ld hl, $47a0
	ld de, $8e00
	ld bc, $0020
	call Call_28C5
	ld a, $01
	call Call_07B9
	ret


Jump_2B9F::
	call Call_2B6B
	ld a, $0f
	call Call_07B9
	ld hl, $4000
	ld de, $8800
	ld bc, $0400
	call Call_28C5
	ld a, $0f
	call Call_07B9
	ld hl, $5000
	ld de, $9000
	ld bc, $0800
	jp Call_28C5


Jump_2BC4::
	ld a, $01
	call Call_07B9
	ldh a, [$fff7]
	ld e, a
	ld d, $00
	push de
	ld hl, $7f64
	add hl, de
	ld h, [hl]
	ld l, $00
	ld a, $0d
	call Call_07B9
	ld de, $9100
	ld bc, $0100
	call Call_28C5
	ld hl, $4000
	ld de, $9200
	ld bc, $0600
	call Call_28C5
	ld a, $01
	ld [$2100], a
	pop de
	push de
	ld hl, $7f84
	add hl, de
	ld h, [hl]
	ld l, $00
	call Call_07C0
	ld de, $9200
	ld bc, $0200
	call Call_28C5
	ld a, $0c
	ld [$2100], a
	ld hl, $47c0
	ld de, $dcc0
	ld bc, $0040
	call Call_28C5
	call Call_2CA1
	ld a, $01
	ld [$2100], a
	pop de
	ld hl, $7fa4
	add hl, de
	ld h, [hl]
	ld l, $00
	ld a, $12
	call Call_07B9
	ld de, $8f00
	ld bc, $0100
	call Call_28C5
	ld hl, $7d00
	ldh a, [$fff7]
	cp $0a
	jr c, jr_000_2c4a

	ld a, $0c
	call Call_07B9
	ld hl, $4c00

jr_000_2c4a:
	ld de, $8c00
	ld bc, $0300
	call Call_28C5

Jump_000_2c53:
	ld a, [$db4b]
	and a
	jr z, jr_000_2c5c

	call Call_1D54

jr_000_2c5c:
	ld a, [$dba5]
	and a
	jr z, jr_000_2c68

	ldh a, [$fff7]
	cp $0a
	jr c, jr_000_2c72

jr_000_2c68:
	ld a, [$db15]
	cp $06
	jr c, jr_000_2c72

	call Call_1DBE

jr_000_2c72:
	ld a, [$db0e]
	cp $02
	jr c, jr_000_2c7d

	ld a, $0d
	ldh [$ffa5], a

jr_000_2c7d:
	ret


Jump_2C7E::
	ld a, $0c
	call Call_07B9
	ld hl, $5200
	ld de, $9200
	ld bc, $0600
	call Call_28C5
	ld hl, $4c00
	ld de, $8c00
	ld bc, $0400
	call Call_28C5
	call Call_2CA1
	jp Jump_000_2c53


Call_2CA1::
	xor a
	ldh [$ffa6], a
	ldh [$ffa7], a
	call Call_1B6B
	ld hl, $4800
	ld de, $8800
	ld bc, $0800
	call Call_28C5
	ld hl, $4200
	ld de, $8200
	ld bc, $0100
	call Call_28C5
	ret


Jump_2CC2::
	ld a, $01
	call Call_07B9
	ld hl, $7d31
	ld de, $8700
	ld bc, $0080
	call Call_28C5
	ld a, $10
	call Call_07B9
	ld hl, $5400
	ld de, $8000
	ld bc, $0600
	call Call_28C5
	ld hl, $4000
	ld de, $8800
	ld bc, $1000
	jp Call_28C5


Jump_2CF0::
	ld a, $0f
	call Call_07B9
	ld hl, $4900
	ld de, $8800
	ld bc, $0700
	jp Call_28C5


Jump_2D01::
	ld a, $0c
	call Call_07B9
	ld hl, $7800
	ld de, $8f00
	ld bc, $0800
	call Call_28C5
	ld hl, $5000
	ld de, $8200
	ld bc, $0100
	jp Call_28C5


Jump_2D1E::
	ld hl, $7000
	jr jr_000_2d2b

Jump_2D23::
	ld hl, $7800
	jr jr_000_2d2b

Jump_2D28::
	ld hl, $5800

jr_000_2d2b:
	ld a, $10
	call Call_07B9
	ld de, $9000
	ld bc, $0800
	jp Call_28C5


Jump_2D39::
	ld a, $13
	ld [$2100], a
	ld hl, $7c00
	ld de, $8c00
	ld bc, $0400
	call Call_28C5
	ld hl, $6800
	ld de, $9000
	ld bc, $0400
	jp Call_28C5


Jump_2D56::
	ld a, $10
	call Call_07B9
	ld hl, $6700
	ld de, $8400
	ld bc, $0400
	call Call_28C5
	ld hl, $6000
	ld de, $9000
	ld bc, $0600
	jp Call_28C5


Jump_2D73::
	ld a, $0f
	call Call_07B9
	ld hl, $4400
	ld de, $8800
	ld bc, $0500
	jp Call_28C5


	db $00, $11, $0e, $12

Jump_2D88::
	xor a

Jump_000_2d89:
	ldh [$ffd7], a
	ld hl, $c193
	ld e, a
	ld d, $00
	add hl, de
	and a
	jr nz, jr_000_2dd7

	ld a, [$dba5]
	and a
	jr z, jr_000_2db4

	ldh a, [$fff9]
	and a
	jr nz, jr_000_2dd7

	ldh a, [$fff7]
	cp $14
	jr z, jr_000_2dd7

	cp $0a
	jr c, jr_000_2dd7

	ldh a, [$fff6]
	cp $fd
	jr z, jr_000_2dd7

	cp $b1
	jr z, jr_000_2dd7

jr_000_2db4:
	ld a, [$db56]
	cp $01
	ld a, $a4
	jr z, jr_000_2dd5

	ld a, [$db79]
	and a
	ld a, $d8
	jr nz, jr_000_2dd5

	ld a, [$db7b]
	and a
	ld a, $dd
	jr nz, jr_000_2dd5

	ld a, [$db73]
	and a
	jr z, jr_000_2dd7

	ld a, $8f

jr_000_2dd5:
	jr jr_000_2dd8

jr_000_2dd7:
	ld a, [hl]

jr_000_2dd8:
	push af
	and $3f
	ld b, a
	ld c, $00
	pop af
	swap a
	rra
	rra
	and $03
	ld e, a
	ld d, $00
	ld hl, $2d84
	add hl, de
	ld a, [hl]
	ld [$2100], a
	ldh a, [$ffd7]
	ld d, a
	ld e, $00
	ld hl, $8400
	add hl, de
	push hl
	pop de
	ld hl, $4000
	add hl, bc
	ld bc, $0100
	call Call_28C5
	ldh a, [$ffd7]
	inc a
	cp $04
	jp nz, Jump_000_2d89

	ld de, $9000
	ld a, [$dba5]
	and a
	jr z, jr_000_2e55

	ld a, $0d
	ld [$2100], a
	ldh a, [$fff9]
	and a
	jr z, jr_000_2e42

	ld hl, $7000
	ldh a, [$fff7]
	cp $06
	jr z, jr_000_2e38

	cp $0a
	jr nc, jr_000_2e32

jr_000_2e2d:
	ld hl, $7800
	jr jr_000_2e38

jr_000_2e32:
	ldh a, [$fff6]
	cp $e9
	jr z, jr_000_2e2d

jr_000_2e38:
	ld de, $9000
	ld bc, $0800
	call Call_28C5
	ret


jr_000_2e42:
	ld hl, $5000
	ldh a, [$ff94]
	cp $ff
	jr z, jr_000_2e54

	add $50
	ld h, a
	ld bc, $0100
	call Call_28C5

jr_000_2e54:
	ret


jr_000_2e55:
	ld a, $0f
	ld [$2100], a
	ldh a, [$ff94]
	cp $0f
	jr z, jr_000_2e6b

	add $40
	ld h, a
	ld l, $00
	ld bc, $0200
	call Call_28C5

jr_000_2e6b:
	ret


Jump_2E6C::
	ld a, $08
	call Call_07B9
	ld de, $9800
	ld hl, $d711
	ld c, $80

jr_000_2e79:
	push de
	push hl
	push bc
	ld a, [hl]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	ld hl, $498c
	ld a, [$dba5]
	and a
	jr z, jr_000_2e94

	ld hl, $4d60

jr_000_2e94:
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	add $1f
	ld e, a
	ld a, d
	adc $00
	ld d, a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop bc
	pop hl
	pop de
	inc hl
	ld a, l
	and $0f
	cp $0b
	jr nz, jr_000_2eb8

	ld a, l
	and $f0
	add $11
	ld l, a

jr_000_2eb8:
	ld a, e
	add $02
	ld e, a
	and $1f
	cp $14
	jr nz, jr_000_2ecc

	ld a, e
	and $e0
	add $40
	ld e, a
	ld a, d
	adc $00
	ld d, a

jr_000_2ecc:
	dec c
	jr nz, jr_000_2e79

	ld a, $01
	ld [$2100], a
	jp $7dc1


Call_2ED7::
	ld a, $01
	ldh [rIE], a
	ld hl, $d47f
	inc [hl]
	ld a, $09
	ld [$2100], a
	xor a
	ldh [$ffe6], a
	ld [$c19c], a
	ld [$c504], a
	ld [$dbc8], a
	ld [$dbc9], a
	ld [$c1a2], a
	ld [$c1c6], a
	ld [$d6fa], a
	ld [$c50a], a
	ldh [$ffac], a
	ld [$c113], a
	ld [$d460], a
	ld [$c1be], a
	ld [$c50e], a
	ld [$c3c8], a
	ld [$c5a6], a
	ld [$d462], a
	ld [$c3cd], a
	ld a, $ff
	ld [$d401], a
	ld [$c50f], a
	ld a, [$dba5]
	and a
	jr z, jr_000_2f90

	ld a, $14
	ld [$2100], a
	ldh [$ffe8], a
	ldh a, [$fff7]
	cp $0b
	jr nc, jr_000_2f5f

	ld hl, $4200
	swap a
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	add hl, de
	ldh a, [$fff7]
	cp $06
	jr nz, jr_000_2f55

	ld a, [$db6b]
	and $04
	jr z, jr_000_2f55

	ld hl, $44c0

jr_000_2f55:
	ld a, [$dbae]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ldh [$fff6], a

jr_000_2f5f:
	ldh a, [$fff6]
	ld c, a
	ld b, $00
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_2f6f

	cp $06
	jr c, jr_000_2f6f

	inc b

jr_000_2f6f:
	ld hl, $4000
	add hl, bc
	ld a, [hl]
	ld [$c18e], a
	xor a
	ld [$c18a], a
	ld [$c18b], a
	ld [$c190], a
	ld [$c18f], a
	ld e, a
	ld hl, $dbb5

jr_000_2f88:
	xor a
	ld [hli], a
	inc e
	ld a, e
	cp $11
	jr nz, jr_000_2f88

jr_000_2f90:
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $d800
	ld a, [$dba5]
	and a
	jr z, jr_000_2fae

	ld hl, $d900
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_2fae

	cp $06
	jr c, jr_000_2fae

	ld hl, $da00

jr_000_2fae:
	add hl, de
	ldh a, [$fff9]
	and a
	ld a, [hl]
	jr nz, jr_000_2fb8

	or $80
	ld [hl], a

jr_000_2fb8:
	ldh [$fff8], a
	ldh a, [$fff6]
	ld c, a
	ld b, $00
	sla c
	rl b
	ld a, [$dba5]
	and a
	jr z, jr_000_3002

	ld a, $0a
	ld [$2100], a
	ldh [$ffe8], a
	ldh a, [$fff7]
	cp $1f
	jr nz, jr_000_2fe9

	ldh a, [$fff6]
	cp $f5
	jr nz, jr_000_2fe9

	ld a, [$db0e]
	cp $0e
	jr nz, jr_000_2fe9

	ld bc, $7853
	jp Jump_000_307d


jr_000_2fe9:
	ld hl, $4000
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_3067

	cp $06
	jr c, jr_000_3067

	ld a, $0b
	ld [$2100], a
	ldh [$ffe8], a
	ld hl, $4000
	jr jr_000_3067

jr_000_3002:
	ldh a, [$fff6]
	cp $0e
	jr nz, jr_000_3014

	ld a, [$d80e]
	and $10
	jr z, jr_000_3064

	ld bc, $47f0
	jr jr_000_3072

jr_000_3014:
	cp $8c
	jr nz, jr_000_3024

	ld a, [$d88c]
	and $10
	jr z, jr_000_3064

	ld bc, $4356
	jr jr_000_3072

jr_000_3024:
	cp $79
	jr nz, jr_000_3034

	ld a, [$d879]
	and $10
	jr z, jr_000_3064

	ld bc, $64fd
	jr jr_000_3072

jr_000_3034:
	cp $06
	jr nz, jr_000_3044

	ld a, [$d806]
	and $10
	jr z, jr_000_3064

	ld bc, $4496
	jr jr_000_3072

jr_000_3044:
	cp $1b
	jr nz, jr_000_3054

	ld a, [$d82b]
	and $10
	jr z, jr_000_3064

	ld bc, $4c13
	jr jr_000_3072

jr_000_3054:
	cp $2b
	jr nz, jr_000_3064

	ld a, [$d82b]
	and $10
	jr z, jr_000_3064

	ld bc, $50ac
	jr jr_000_3072

jr_000_3064:
	ld hl, $4000

jr_000_3067:
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [$dba5]
	and a
	jr nz, jr_000_307d

jr_000_3072:
	ldh a, [$fff6]
	cp $80
	jr c, jr_000_307d

	ld a, $1a
	ld [$2100], a

Jump_000_307d:
jr_000_307d:
	ld a, [bc]
	cp $fe
	jr z, jr_000_30d1

	ldh [$ffa4], a
	inc bc
	ld a, [$dba5]
	and a
	jr z, jr_000_309b

	ld a, [bc]
	and $0f
	call Call_36CF
	ld a, [bc]
	swap a
	and $0f
	call Call_37C9
	jr jr_000_309f

jr_000_309b:
	ld a, [bc]
	call Call_36CF

jr_000_309f:
	inc bc
	ld a, [bc]
	and $fc
	cp $e0
	jr nz, jr_000_30c7

	ldh a, [$ffe6]
	ld e, a
	ld d, $00
	ld hl, $d401
	add hl, de
	ld a, [bc]
	and $03
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	ld a, e
	add $05
	ldh [$ffe6], a
	jr jr_000_309f

jr_000_30c7:
	ld a, [bc]
	cp $fe
	jr z, jr_000_30d1

	call Call_30DC
	jr jr_000_309f

jr_000_30d1:
	ld a, $01
	ld [$2100], a
	call $7cde
	jp Call_07C0


Call_30DC::
	xor a
	ldh [$ffd7], a
	ld a, [bc]
	bit 7, a
	jr z, jr_000_30eb

	bit 4, a
	jr nz, jr_000_30eb

	ldh [$ffd7], a
	inc bc

jr_000_30eb:
	inc bc
	ldh a, [$fff8]
	ld e, a
	ld a, [$dba5]
	and a
	jr nz, jr_000_310d

	ld a, [bc]
	sub $f5
	jr c, jr_000_3138

	rst $00

JumpTable_30FB::
	dw Jump_3338
	dw Jump_3425
	dw Jump_3445
	dw Jump_33EF
	dw Jump_345F
	dw Jump_3479
	dw Jump_3498
	dw Jump_34C2
	dw Jump_34DC

jr_000_310d:
	ld a, [bc]
	sub $ec
	jp c, Jump_000_31fd

	rst $00

JumpTable_3114::
	dw Jump_34EB
	dw Jump_3506
	dw Jump_3521
	dw Jump_353C
	dw Jump_3555
	dw Jump_3568
	dw Jump_357B
	dw Jump_358E
	dw Jump_35A3
	dw Jump_35D2
	dw Jump_35E6
	dw Jump_35FA
	dw Jump_360E
	dw Jump_3646
	dw Jump_3655
	dw Jump_3664
	dw Jump_368A
	dw Jump_369E

jr_000_3138:
	add $f5
	push af
	ld d, a
	cp $e9
	jr nz, jr_000_3143

	ld [$c50e], a

jr_000_3143:
	cp $5e
	jr nz, jr_000_314b

	bit 5, e
	jr nz, jr_000_31b0

jr_000_314b:
	cp $91
	jr nz, jr_000_3158

	bit 5, e
	jr z, jr_000_3158

	pop af
	ld a, $5e
	ld d, a
	push af

jr_000_3158:
	cp $dc
	jr nz, jr_000_3165

	bit 5, e
	jr z, jr_000_3165

	pop af
	ld a, $91
	ld d, a
	push af

jr_000_3165:
	cp $d8
	jr z, jr_000_3171

	cp $d9
	jr z, jr_000_3171

	cp $da
	jr nz, jr_000_317a

jr_000_3171:
	bit 4, e
	jr z, jr_000_317a

	pop af
	ld a, $db
	ld d, a
	push af

jr_000_317a:
	cp $c2
	jr nz, jr_000_3187

	bit 4, e
	jr z, jr_000_3187

	pop af
	ld a, $e3
	ld d, a
	push af

jr_000_3187:
	ld a, d
	cp $ba
	jr nz, jr_000_3195

	bit 2, e
	jr z, jr_000_3195

	pop af
	ld a, $e1
	ld d, a
	push af

jr_000_3195:
	ld a, d
	cp $d3
	jr nz, jr_000_31b5

	bit 4, e
	jr z, jr_000_31b5

	ldh a, [$fff6]
	cp $75
	jr z, jr_000_31b0

	cp $07
	jr z, jr_000_31b0

	cp $aa
	jr z, jr_000_31b0

	cp $4a
	jr nz, jr_000_31b5

jr_000_31b0:
	pop af
	ld a, $c6
	ld d, a
	push af

jr_000_31b5:
	ld a, d
	ldh [$ffe0], a
	cp $c2
	jr z, jr_000_31dc

	cp $e1
	jr z, jr_000_31dc

	cp $cb
	jr z, jr_000_31dc

	cp $ba
	jr z, jr_000_31dc

	cp $61
	jr z, jr_000_31dc

	cp $c6
	jr z, jr_000_31dc

	cp $c5
	jr z, jr_000_31dc

	cp $e2
	jr z, jr_000_31dc

	cp $e3
	jr nz, jr_000_31ee

jr_000_31dc:
	ld a, [$c19c]
	ld e, a
	inc a
	ld [$c19c], a
	ld d, $00
	ld hl, $d416
	add hl, de
	dec bc
	ld a, [bc]
	ld [hl], a
	inc bc

jr_000_31ee:
	ldh a, [$ffe0]
	cp $c5
	jp z, Jump_000_32aa

	cp $c6
	jp z, Jump_000_32aa

	jp Jump_000_32fb


Jump_000_31fd:
	add $ec
	ldh [$ffe0], a
	push af
	cp $cf
	jr c, jr_000_320e

	cp $d3
	jr nc, jr_000_320e

	ld hl, $c1a5
	inc [hl]

jr_000_320e:
	cp $ab
	jr nz, jr_000_3234

	xor a
	ld [$c3cb], a
	ldh a, [$fff6]
	cp $c4
	ldh a, [$ffe0]
	jr z, jr_000_3234

	ld hl, $dbc9
	inc [hl]
	ld [$c3cb], a
	push af
	ld a, [$c3cd]
	add $04
	ld [$c3cd], a
	ld a, $04
	ld [$c16b], a
	pop af

jr_000_3234:
	cp $8e
	jr z, jr_000_324b

	cp $aa
	jr z, jr_000_324b

	cp $dc
	jr z, jr_000_3244

	cp $db
	jr nz, jr_000_3250

jr_000_3244:
	ld hl, $d6fa
	ld [hl], $02
	jr jr_000_3250

jr_000_324b:
	ld hl, $d6fa
	ld [hl], $01

jr_000_3250:
	cp $3f
	jr z, jr_000_3258

	cp $47
	jr nz, jr_000_325c

jr_000_3258:
	bit 2, e
	jr nz, jr_000_3268

jr_000_325c:
	cp $40
	jr z, jr_000_3264

	cp $48
	jr nz, jr_000_326c

jr_000_3264:
	bit 3, e
	jr z, jr_000_326c

jr_000_3268:
	pop af
	ld a, $3d
	push af

jr_000_326c:
	cp $41
	jr z, jr_000_3274

	cp $49
	jr nz, jr_000_3278

jr_000_3274:
	bit 1, e
	jr nz, jr_000_3284

jr_000_3278:
	cp $42
	jr z, jr_000_3280

	cp $4a
	jr nz, jr_000_3288

jr_000_3280:
	bit 0, e
	jr z, jr_000_3288

jr_000_3284:
	pop af
	ld a, $3e
	push af

jr_000_3288:
	cp $a1
	jr nz, jr_000_3294

	bit 4, e
	jr nz, jr_000_3294

	pop af
	ldh a, [$ffe9]
	push af

jr_000_3294:
	cp $bf
	jr nz, jr_000_329e

	bit 4, e
	jr nz, jr_000_329e

	pop af
	ret


jr_000_329e:
	cp $be
	jr z, jr_000_32aa

	cp $bf
	jr z, jr_000_32aa

	cp $cb
	jr nz, jr_000_32c3

Jump_000_32aa:
jr_000_32aa:
	dec bc
	ld a, $01
	ldh [$ffac], a
	ld a, [bc]
	and $f0
	add $10
	ldh [$ffae], a
	ld a, [bc]
	swap a
	and $f0
	add $08
	ldh [$ffad], a
	inc bc
	jp Jump_000_32fb


jr_000_32c3:
	cp $d6
	jr z, jr_000_32cb

	cp $d5
	jr nz, jr_000_32d3

jr_000_32cb:
	bit 4, e
	jr nz, jr_000_32d3

	pop af
	ld a, $21
	push af

jr_000_32d3:
	cp $d7
	jr z, jr_000_32db

	cp $d8
	jr nz, jr_000_32e3

jr_000_32db:
	bit 4, e
	jr nz, jr_000_32e3

	pop af
	ld a, $22
	push af

jr_000_32e3:
	ldh a, [$fff7]
	cp $0a
	ldh a, [$ffe0]
	jr c, jr_000_32ef

	cp $a9
	jr z, jr_000_32f3

jr_000_32ef:
	cp $de
	jr nz, jr_000_32fb

jr_000_32f3:
	bit 6, e
	jr z, jr_000_32fb

	pop af
	ld a, $0d
	push af

Jump_000_32fb:
jr_000_32fb:
	cp $a0
	jr nz, jr_000_3307

	bit 4, e
	jr z, jr_000_3307

	pop af
	ld a, $a1
	push af

jr_000_3307:
	ld d, $00
	ldh a, [$ffd7]
	and a
	jr z, jr_000_332d

	dec bc
	ld a, [bc]
	ld e, a
	ld hl, $d711
	add hl, de
	ldh a, [$ffd7]
	and $0f
	ld e, a
	pop af
	ld d, a

jr_000_331c:
	ld a, d
	ld [hli], a
	ldh a, [$ffd7]
	and $40
	jr z, jr_000_3328

	ld a, l
	add $0f
	ld l, a

jr_000_3328:
	dec e
	jr nz, jr_000_331c

	inc bc
	ret


jr_000_332d:
	dec bc
	ld a, [bc]
	ld e, a
	ld hl, $d711
	add hl, de
	pop af
	ld [hl], a
	inc bc
	ret


Jump_3338::
	dec bc
	ld a, [bc]
	add $11
	ld e, a
	and $0f
	jr nz, jr_000_3345

	ld a, e
	sub $10
	ld e, a

jr_000_3345:
	ld d, $00
	ld hl, $d700
	add hl, de
	ldh a, [$ffd7]
	and a
	jr z, Call_3369

	and $0f
	ld e, a

jr_000_3353:
	call Call_3369
	dec bc
	ldh a, [$ffd7]
	and $40
	ld d, $f1
	jr z, jr_000_3361

	ld d, $0f

jr_000_3361:
	ld a, l
	add d
	ld l, a
	dec e
	jr nz, jr_000_3353

	inc bc
	ret


Call_3369::
	ld a, [hl]
	cp $10
	ld a, $25
	jr c, jr_000_3372

	add $04

jr_000_3372:
	ld [hli], a
	ld a, [hl]
	cp $10
	ld a, $26
	jr c, jr_000_337c

	add $04

jr_000_337c:
	ld [hld], a
	ld a, l
	add $10
	ld l, a
	ld a, [hl]
	cp $8a
	jr nc, jr_000_3390

	cp $10
	ld a, $27
	jr c, jr_000_3392

	ld a, $2a
	jr jr_000_3392

jr_000_3390:
	ld a, $82

jr_000_3392:
	ld [hli], a
	ld a, [hl]
	cp $8a
	jr nc, jr_000_33a2

	cp $10
	ld a, $28
	jr c, jr_000_33a4

	ld a, $29
	jr jr_000_33a4

jr_000_33a2:
	ld a, $83

jr_000_33a4:
	ld [hl], a
	inc bc
	ret


Jump_000_33a7:
jr_000_33a7:
	push hl
	push de
	ld a, [bc]
	ld e, a
	ld d, $00
	add hl, de
	pop de
	ld a, [de]
	cp $e1
	jr z, jr_000_33bc

	cp $e2
	jr z, jr_000_33bc

	cp $e3
	jr nz, jr_000_33d6

jr_000_33bc:
	push af
	push hl
	push de
	ld a, l
	sub $11
	push af
	ld a, [$c19c]
	ld e, a
	inc a
	ld [$c19c], a
	ld d, $00
	ld hl, $d416
	add hl, de
	pop af
	ld [hl], a
	pop de
	pop hl
	pop af

jr_000_33d6:
	ld [hl], a
	inc de
	inc bc
	pop hl
	ld a, [bc]
	and a
	cp $ff
	jr nz, jr_000_33a7

	pop bc
	ret


	db $00, $01, $02, $10, $11, $12, $ff, $b6, $b7, $66, $67, $e3, $68

Jump_33EF::
	push bc
	call Call_33FC
	ld bc, $33e2
	ld de, $33e9
	jp Jump_000_33a7


Call_33FC::
	dec bc
	ld a, [bc]
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ret


	db $00, $01, $02, $03, $04, $10, $11, $12, $13, $14, $20, $21, $22, $23, $24, $ff
	db $55, $5a, $5a, $5a, $56, $57, $59, $59, $59, $58, $5b, $e2, $5b, $e2, $5b

Jump_3425::
	push bc
	call Call_33FC
	ld bc, $3406
	ld de, $3416
	jp Jump_000_33a7


	db $00, $01, $02, $10, $11, $12, $20, $21, $22, $ff, $55, $5a, $56, $57, $59, $58
	db $5b, $e2, $5b

Jump_3445::
	push bc
	call Call_33FC
	ld bc, $3432
	ld de, $343c
	jp Jump_000_33a7


	db $00, $01, $02, $10, $11, $12, $ff, $a4, $a5, $a6, $a7, $e3, $a8

Jump_345F::
	push bc
	call Call_33FC
	ld bc, $3452
	ld de, $3459
	jp Jump_000_33a7


	db $00, $01, $10, $11, $ff, $bb, $bc, $bd, $be, $09, $09, $09, $09

Jump_3479::
	push bc
	call Call_33FC
	ld bc, $346c
	ld de, $3471
	ldh a, [$fff8]
	and $04
	jr z, jr_000_348c

	ld de, $3475

jr_000_348c:
	jp Jump_000_33a7


	db $00, $01, $10, $11, $ff, $b6, $b7, $cd, $ce

Jump_3498::
	push bc
	call Call_33FC
	ld bc, $348f
	ld de, $3494
	jp Jump_000_33a7


	db $00, $01, $02, $10, $11, $12, $1f, $20, $21, $22, $23, $30, $31, $32, $ff, $2b
	db $2c, $2d, $37, $e8, $38, $0a, $33, $2f, $34, $0a, $0a, $0a, $0a

Jump_34C2::
	push bc
	call Call_33FC
	ld bc, $34a5
	ld de, $34b4
	jp Jump_000_33a7


	db $00, $01, $02, $10, $11, $12, $ff, $52, $52, $52, $5b, $e2, $5b

Jump_34DC::
	push bc
	call Call_33FC
	ld bc, $34cf
	ld de, $34d6
	jp Jump_000_33a7


	db $2d, $2e

Jump_34EB::
	ld e, $00
	call Call_3627
	ldh a, [$fff8]
	and $04
	jp nz, Jump_35A3

	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $34e9
	jp Jump_000_33a7


	db $2f, $30

Jump_3506::
	ld e, $01
	call Call_3627
	ldh a, [$fff8]
	and $08
	jp nz, Jump_35D2

	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $3504
	jp Jump_000_33a7


	db $31, $32

Jump_3521::
	ld e, $02
	call Call_3627
	ldh a, [$fff8]
	and $02
	jp nz, Jump_35E6

	push bc
	call Call_33FC
	ld bc, $36cc
	ld de, $351f
	jp Jump_000_33a7


	db $33, $34

Jump_353C::
	ld e, $03
	call Call_3627
	ldh a, [$fff8]
	and $01
	jp nz, Jump_35FA

	push bc
	call Call_33FC
	ld bc, $36cc
	ld de, $353a
	jp Jump_000_33a7


Jump_3555::
	ld e, $04
	call Call_3627
	ld a, [$c18a]
	or $01
	ld [$c18a], a
	ld [$c18b], a
	jp Jump_35A3


Jump_3568::
	ld e, $05
	call Call_3627
	ld a, [$c18a]
	or $02
	ld [$c18a], a
	ld [$c18b], a
	jp Jump_35D2


Jump_357B::
	ld e, $06
	call Call_3627
	ld a, [$c18a]
	or $04
	ld [$c18a], a
	ld [$c18b], a
	jp Jump_35E6


Jump_358E::
	ld e, $07
	call Call_3627
	ld a, [$c18a]
	or $08
	ld [$c18a], a
	ld [$c18b], a
	jp Jump_35FA


	db $43, $44

Jump_35A3::
	ld a, $04
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $35a1
	jp Jump_000_33a7


Call_35B5::
	push af
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_35c6

	cp $06
	jr c, jr_000_35c6

	inc d

jr_000_35c6:
	ld hl, $d900
	add hl, de
	pop af
	or [hl]
	ld [hl], a
	ldh [$fff8], a
	ret


	db $8c, $08

Jump_35D2::
	ld a, $08
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $35d0
	jp Jump_000_33a7


	db $09, $0a

Jump_35E6::
	ld a, $02
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $36cc
	ld de, $35e4
	jp Jump_000_33a7


	db $0b, $0c

Jump_35FA::
	ld a, $01
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $36cc
	ld de, $35f8
	jp Jump_000_33a7


	db $a4, $a5

Jump_360E::
	ld e, $08
	call Call_3627
	ldh a, [$fff8]
	and $04
	jp nz, Jump_35A3

	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $360c
	jp Jump_000_33a7


Call_3627::
	ld d, $00
	ld hl, $c1f0
	add hl, de
	dec bc
	ld a, [bc]
	ld [hl], a
	push af
	and $f0
	ld hl, $c1e0
	add hl, de
	ld [hl], a
	pop af
	swap a
	and $f0
	ld hl, $c1d0
	add hl, de
	ld [hl], a
	inc bc
	ret


	db $af, $b0

Jump_3646::
	push bc
	call Call_33FC
	ld bc, $36cc
	ld de, $3644
	jp Jump_000_33a7


	db $b1, $b2

Jump_3655::
	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $3653
	jp Jump_000_33a7


	db $45, $46

Jump_3664::
	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $3662
	jp Jump_000_33a7


	db $00, $01, $02, $03, $10, $11, $12, $13, $20, $21, $22, $23, $ff, $b3, $b4, $b4
	db $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd

Jump_368A::
	ld a, $08
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $3671
	ld de, $367e
	jp Jump_000_33a7


	db $c1, $c2

Jump_369E::
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_36b7

	cp $06
	jr c, jr_000_36b7

	ldh a, [$fff6]
	cp $d3
	jr nz, jr_000_36b7

	ld a, [$db46]
	and a
	jr z, jr_000_36b7

	jp Jump_3568


jr_000_36b7:
	ld a, $01
	call Call_35B5
	push bc
	call Call_33FC
	ld bc, $36c9
	ld de, $369c
	jp Jump_000_33a7


	db $00, $01, $ff, $00, $10, $ff

Call_36CF::
	ldh [$ffe9], a
	ld d, $80
	ld hl, $d711
	ld e, a

jr_000_36d7:
	ld a, l
	and $0f
	jr z, jr_000_36e1

	cp $0b
	jr nc, jr_000_36e1

	ld [hl], e

jr_000_36e1:
	inc hl
	dec d
	jr nz, jr_000_36d7

	ret


Call_36E6::
	ld a, $01
	ld [$2100], a
	call $5c61
	ld a, $16
	ld [$2100], a
	xor a
	ldh [$ffe4], a
	ldh a, [$fff6]
	ld c, a
	ld b, $00
	sla c
	rl b
	ld hl, $4000
	ld a, [$dba5]
	and a
	jr z, jr_000_3747

	ldh a, [$fff7]
	cp $06
	jr nz, jr_000_3738

	ld a, [$db6f]
	ld hl, $fff6
	cp [hl]
	jr nz, jr_000_3738

	ld a, $a8
	call Call_3C01
	ld a, [$db70]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld a, [$db71]
	ld hl, $c210
	add hl, de
	ld [hl], a
	call Call_37B3
	ld hl, $c460
	add hl, de
	ld [hl], $ff
	xor a
	ldh [$ffe4], a

jr_000_3738:
	ld hl, $4200
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_000_3747

	cp $06
	jr c, jr_000_3747

	inc h
	inc h

jr_000_3747:
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a

jr_000_374c:
	ld a, [bc]
	cp $ff
	jr z, jr_000_3756

	call Call_3762
	jr jr_000_374c

jr_000_3756:
	call Call_07C0
	ret


	db $01, $02, $04, $08, $10, $20, $40, $80

Call_3762::
	ldh a, [$ffe4]
	cp $08
	jr nc, jr_000_377a

	ld e, a
	ld d, $00
	ld hl, $375a
	add hl, de
	ldh a, [$fff6]
	ld e, a
	ld a, [hl]
	ld hl, $cf00
	add hl, de
	and [hl]
	jr nz, jr_000_378c

jr_000_377a:
	ld e, $00
	ld d, e

jr_000_377d:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $00
	jr z, jr_000_3793

	inc e
	ld a, e
	cp $10
	jr nz, jr_000_377d

jr_000_378c:
	ld hl, $ffe4
	inc [hl]
	inc bc
	inc bc
	ret


jr_000_3793:
	ld [hl], $04
	ld a, [bc]
	and $f0
	ld hl, $c210
	add hl, de
	add $10
	ld [hl], a
	ld a, [bc]
	inc bc
	swap a
	and $f0
	ld hl, $c200
	add hl, de
	add $08
	ld [hl], a
	ld hl, $c3a0
	add hl, de
	ld a, [bc]
	inc bc
	ld [hl], a

Call_37B3::
	ld a, $03
	ld [$2100], a
	call $6552
	ld a, $01
	ld [$2100], a
	call $5c0a
	ld a, $16
	ld [$2100], a
	ret


Call_37C9::
	ld e, a
	ld a, $14
	ld [$2100], a
	ld a, e
	push bc
	call $5000
	pop bc
	ldh a, [$ffe8]
	ld [$2100], a
	ret


Jump_37DB::
	ld a, $01
	ld [$2100], a
	call $7ee8
	ret


	db $ff, $ff

Call_37E6::
	ld a, $14
	ld [$2100], a
	ld hl, $56ff
	add hl, de
	ld a, [hl]
	ld hl, $2100
	ld [hl], $05
	ret


Call_37F6::
	ld a, $19
	call Call_07B9
	call $77c6
	ld a, $03
	jp Call_07B9


Call_3803::
	ld a, $03
	ld [$2100], a
	call $5441
	jp Call_07C0


Call_380E::
	ld a, $14
	ld [$2100], a
	call $5964
	jp Call_07C0


Call_3819::
	ld a, $01
	call Call_07B9
	call $5d6b
	ld a, $02
	jp Call_07B9


Call_3826::
	ld a, $03
	ld [$2100], a
	call $48b0
	jp Call_07C0


Call_3831::
	ld a, $14
	ld [$2100], a
	call $5822
	ld a, $03
	ld [$2100], a
	ret


	db $00, $08, $10, $18

Call_3843::
	ld hl, $c5a7
	ld a, [hl]
	and a
	jr z, jr_000_3851

	dec [hl]
	jr nz, jr_000_3851

	ld a, $10
	ldh [$fff3], a

jr_000_3851:
	ld a, [$c19f]
	and a
	jr nz, jr_000_3864

	ld a, [$c111]
	ld [$c1a8], a
	and a
	jr z, jr_000_3864

	dec a
	ld [$c111], a

jr_000_3864:
	ld a, [$c11c]
	cp $07
	ret z

	xor a
	ld [$c3c1], a
	ldh a, [$fff7]
	cp $0a
	ldh a, [$ffe7]
	jr c, jr_000_3877

	xor a

jr_000_3877:
	and $03
	ld e, a
	ld d, $00
	ld hl, $383f
	add hl, de
	ld a, [hl]
	ld [$c3c0], a
	ld a, [$c5a0]
	ld [$c5a1], a
	xor a
	ld [$c5a0], a
	ld [$c10c], a
	ldh [$ffb2], a
	ld [$c117], a
	ld [$c19d], a
	ld [$c147], a
	ld [$c5a8], a
	ld [$d45e], a
	ld a, [$c19f]
	and a
	jr nz, jr_000_38ab

	ld [$c1ad], a

jr_000_38ab:
	ld a, $02
	call Call_07B9
	call $63e6
	ld b, $00
	ld c, $0f

jr_000_38b7:
	ld a, c
	ld [$c123], a
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_38c8

	ldh [$ffea], a
	call Call_38DD

jr_000_38c8:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_000_38b7

Jump_38CE::
	ret


Call_38CF::
	ld a, $15
	ld [$2100], a
	call $4000
	ld a, $03
	ld [$2100], a
	ret


Call_38DD::
	ld hl, $c3a0
	add hl, bc
	ld a, [hl]
	ldh [$ffeb], a
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	ldh [$fff0], a
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ld a, $19
	call Call_07B9
	ldh a, [$ffeb]
	cp $6a
	jr nz, jr_000_3902

	ldh a, [$ffb2]
	and a
	jr nz, jr_000_3908

jr_000_3902:
	ldh a, [$ffea]
	cp $07
	jr nz, jr_000_3910

jr_000_3908:
	call $7563
	call Call_3DBA
	jr jr_000_3916

jr_000_3910:
	call Call_3DBA
	call $7563

jr_000_3916:
	ld a, $14
	call Call_07B9
	call $5388
	ld a, $03
	call Call_07B9
	ldh a, [$ffea]
	cp $05
	jp z, Call_3945

	rst $00

JumpTable_392B::
	dw Jump_38CE

	db $7e, $55, $90, $4d, $26, $4d, $0a, $49, $45, $39, $bc, $4e, $92, $57, $49, $4e

Call_393D::
	call Call_3945
	ld a, $03
	jp Call_07B9


Call_3945::
	ldh a, [$ffeb]
	ld e, a
	ld d, b
	ld hl, $4000
	add hl, de
	ld a, [hl]
	call Call_07B9
	ld a, e
	rst $00

JumpTable_3953::
	dw Call_03_6A4B
	dw Call_19_4461
	dw Call_03_66BF
	dw Call_18_7B61
	dw Call_03_69C9
	dw Call_03_5397
	dw Call_03_52BE
	dw Call_07_7AE3
	dw Call_18_7930
	dw Call_03_5844
	dw Call_03_6A3D
	dw Call_03_5882
	dw Call_03_6AE7
	dw Call_06_79CD
	dw Call_04_7E82
	dw Call_06_7547
	dw Call_04_5C04
	dw Call_04_5BFF
	dw Call_04_5C04
	dw Call_03_5A35
	dw Call_07_785E
	dw Call_06_797B
	dw Call_06_6641
	dw Call_06_6641
	dw Call_06_7470
	dw Call_06_673C
	dw Call_06_4ACE
	dw Call_06_7CFC
	dw Call_06_7CD0
	dw $0000
	dw Call_15_4EAB
	dw Call_06_7F5F
	dw Call_06_4F5D
	dw Call_06_7727
	dw Call_06_65FB
	dw Call_06_7EB5
	dw Call_03_50B4
	dw Call_03_4D1E
	dw Call_03_4D1E
	dw Call_06_760B
	dw Call_19_6765
	dw Call_04_5A8B
	dw Call_04_6C34
	dw Call_15_75E5
	dw Call_07_76BC
	dw Call_03_5D7F
	dw Call_03_60C0
	dw Call_03_617D
	dw Call_03_5CD0
	dw Call_03_5BDC
	dw Call_03_5BCB
	dw Call_03_5BB0
	dw Call_03_5BA0
	dw Call_03_5A9C
	dw Call_03_5A39
	dw Call_03_609D
	dw Call_03_5FEE
	dw Call_03_5DDA
	dw Call_03_5D92
	dw Call_03_6083
	dw Call_03_6029
	dw Call_03_5FFF
	dw Call_05_4DE5
	dw Call_05_4915
	dw Call_05_47E1
	dw Call_06_6801
	dw Call_18_5E68
	dw Call_15_4494
	dw Call_15_443F
	dw Call_15_4365
	dw Call_15_40FD
	dw Call_15_41C7
	dw Call_15_423A
	dw Call_15_42AD
	dw $0000
	dw Call_03_5395
	dw $0000
	dw Call_04_7682
	dw Call_04_7634
	dw Call_04_6E4F
	dw Call_06_7AB3
	dw Call_04_697A
	dw Call_04_67EF
	dw Call_04_67EF
	dw Call_04_5F59
	dw Call_04_7D97
	dw Call_04_7CA7
	dw Call_04_5DE9
	dw Call_04_5EF7
	dw Call_04_569D
	dw Call_04_5072
	dw Call_04_49C1
	dw Call_04_4009
	dw Call_05_6C41
	dw Call_05_7B05
	dw Call_07_694D
	dw Call_05_67CD
	dw Call_19_4216
	dw Call_05_6261
	dw Call_05_59BB
	dw Call_18_5DEF
	dw Call_05_54AA
	dw Call_15_4324
	dw Call_05_549F
	dw Call_15_7458
	dw Call_18_53C2
	dw Call_05_529E
	dw Call_18_5D8B
	dw Call_05_452E
	dw Call_05_4038
	dw Call_06_6BB4
	dw Call_19_4894
	dw Call_06_6248
	dw Call_06_60C3
	dw Call_06_60C3
	dw Call_06_6248
	dw Call_18_4DBF
	dw Call_18_4CA4
	dw Call_18_4B33
	dw Call_06_5CE8
	dw Call_06_5ABE
	dw Call_06_5C4E
	dw Call_06_5D5C
	dw Call_06_5EFD
	dw Call_06_62DE
	dw Call_06_63CD
	dw Call_06_642A
	dw Call_18_72C6
	dw Call_06_6A88
	dw Call_06_6C58
	dw Call_06_6ED4
	dw Call_06_7066
	dw Call_06_71C9
	dw Call_06_7339
	dw Call_06_7C19
	dw Call_06_56B5
	dw Call_06_53A1
	dw Call_06_5107
	dw Call_06_5049
	dw Call_06_5049
	dw Call_06_4EBF
	dw Call_06_4F36
	dw Call_06_4B92
	dw Call_19_4777
	dw Call_06_4949
	dw Call_06_4247
	dw Call_06_451B
	dw Call_06_4150
	dw Call_07_70AD
	dw Call_06_4020
	dw Call_19_5AFD
	dw Call_19_4805
	dw Call_07_7503
	dw Call_07_7444
	dw Call_07_7314
	dw Call_07_71B4
	dw Call_07_715E
	dw Call_19_4022
	dw Call_07_7031
	dw Call_07_63F1
	dw Call_07_6525
	dw Call_07_666D
	dw Call_07_61FB
	dw Call_07_60BD
	dw Call_07_60BD
	dw Call_07_6198
	dw Call_07_5F54
	dw Call_07_5B47
	dw Call_07_5D87
	dw Call_07_597C
	dw Call_19_680A
	dw Call_19_680A
	dw Call_19_687E
	dw Call_07_55D5
	dw Call_07_53DC
	dw Call_07_52C6
	dw Call_07_5109
	dw Call_07_4F03
	dw Call_15_751C
	dw Call_07_4A88
	dw Call_07_4CA8
	dw Call_07_49A3
	dw Call_07_480D
	dw Call_07_44D3
	dw Call_07_4272
	dw Call_18_772B
	dw Call_18_77EA
	dw Call_07_4015
	dw Call_18_6FA8
	dw Call_18_69C7
	dw Call_18_64A7
	dw Call_18_6362
	dw Call_18_627D
	dw Call_18_6176
	dw Call_18_5EB6
	dw Call_18_4000
	dw Call_18_54F7
	dw Call_15_73C9
	dw Call_15_734E
	dw Call_18_451D
	dw Call_18_5298
	dw Call_18_50FC
	dw Call_18_4E40
	dw Call_18_49F5
	dw Call_15_44BD
	dw Call_19_6B9B
	dw Call_18_4957
	dw Call_19_6E17
	dw Call_18_5132
	dw Call_18_5180
	dw Call_18_525D
	dw Call_18_51CA
	dw Call_19_5D58
	dw Call_19_5918
	dw Call_19_5817
	dw Call_19_55F3
	dw Call_19_56E8
	dw Call_19_54C1
	dw Call_19_5344
	dw Call_19_52E4
	dw Call_19_518A
	dw Call_19_4C9A
	dw Call_19_4A1C
	dw Call_19_4527
	dw Call_15_768A
	dw Call_15_78AC
	dw Call_15_4D58
	dw Call_15_4BF5
	dw Call_15_46BE
	dw Call_06_7C19
	dw Call_15_5096
	dw Call_15_409A
	dw Call_17_7547

	db $08, $05, $08, $05, $08, $0a, $08, $0a, $08, $0a, $08, $0a, $08, $10, $04, $0a
	db $08, $02, $08, $02, $08, $13, $08, $13, $08, $06, $06, $08, $08, $07, $06, $0a
	db $08, $06, $10, $30, $08, $07, $04, $0a, $0c, $07, $fc, $04, $10, $10, $0c, $12
	db $08, $08, $02, $08, $10, $0c, $08, $10, $08, $07, $0c, $08, $08, $08, $02, $08

Call_3B65::
	ld hl, $c350
	add hl, bc
	ld a, [hl]
	and $7c
	ld e, a
	ld d, b
	ld hl, $3b25
	add hl, de
	push hl
	pop de
	push bc
	sla c
	sla c
	ld hl, $d580
	add hl, bc
	ld c, $04

jr_000_3b7f:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_000_3b7f

	pop bc
	ret


Call_3B87::
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	ret


Call_3B8D::
	ld hl, $c290
	add hl, bc
	inc [hl]
	ret


Call_3B93::
	ld a, $02
	ld [$2100], a
	call $78b5
	jp Call_07C0


Call_3B9E::
	ld a, $03
	ld [$2100], a
	call $7892
	jp Call_07C0


Call_3BA9::
	ld a, $03
	ld [$2100], a
	call $7caa
	jp Call_07C0


Call_3BB4::
	ld a, $03
	ld [$2100], a
	call $6e3d
	jp Call_07C0


Call_3BBF::
	ld a, $03
	ld [$2100], a
	call $6c87
	jp Call_07C0


Call_3BCA::
	ld a, $03
	ld [$2100], a
	call $6bf9
	jp Call_07C0


Call_3BD5::
	ld a, $03
	ld [$2100], a
	call $6c93
	jp Call_07C0


Call_3BE0::
	ld a, $03
	ld [$2100], a
	call $73ef
	jp Call_07C0


Call_3BEB::
	ld a, $03
	ld [$2100], a
	call $6e40
	jp Call_07C0


Call_3BF6::
	ld a, $03
	ld [$2100], a
	call $75a6
	jp Call_07C0


Call_3C01::
	push af
	ld a, $03
	ld [$2100], a
	pop af
	call $64f8
	rr l
	call Call_07C0
	rl l
	ret


Call_3C13::
	push af
	ld a, $03
	ld [$2100], a
	pop af
	call $64fa
	rr l
	call Call_07C0
	rl l
	ret


Call_3C25::
	ld hl, $2100
	ld [hl], $03
	call $7e99
	jp Call_07C0


Call_3C30::
	ld hl, $2100
	ld [hl], $03
	call $7e17
	jp Call_07C0


Call_3C3B::
	ldh a, [$fff1]
	inc a
	ret z

	call Call_3D87
	push de
	ld a, [$c3c0]
	ld e, a
	ld d, b
	ld hl, $c030
	add hl, de
	push hl
	pop de
	ldh a, [$ffec]
	ld [de], a
	inc de
	ld a, [$c155]
	ld c, a
	ldh a, [$ffed]
	and $20
	rra
	rra
	ld hl, $ffee
	add [hl]
	sub c
	ld [de], a
	inc de
	ldh a, [$fff1]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	pop hl
	add hl, bc
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	add c
	ld [de], a
	and $0f
	cp $0f
	jr nz, jr_000_3c83

	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3c83:
	inc de
	ld a, [hli]
	push hl
	ld hl, $ffed
	xor [hl]
	ld [de], a
	inc de
	ldh a, [$ffec]
	ld [de], a
	inc de
	ld a, [$c155]
	ld c, a
	ldh a, [$ffed]
	and $20
	xor $20
	rra
	rra
	ld hl, $ffee
	sub c
	add [hl]
	ld [de], a
	inc de
	pop hl
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	add c
	ld [de], a
	and $0f
	cp $0f
	jr nz, jr_000_3cb5

	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3cb5:
	inc de
	ld a, [hl]
	ld hl, $ffed
	xor [hl]
	ld [de], a

jr_000_3cbc:
	ld a, [$c123]
	ld c, a
	ld b, $00
	ld a, $15
	ld [$2100], a
	call $796d

jr_000_3cca:
	call $79a5
	jp Call_07C0


Call_3CD0::
	ldh a, [$fff1]
	inc a
	ret z

	call Call_3D87
	push de
	ld a, [$c3c0]
	ld l, a
	ld h, $00
	ld bc, $c030
	add hl, bc
	push hl
	pop de
	ld a, [$c123]
	ld c, a
	ld b, $00
	ldh a, [$fff9]
	and a
	ldh a, [$ffec]
	jr z, jr_000_3cf5

	sub $04
	ldh [$ffec], a

jr_000_3cf5:
	ld [de], a
	inc de
	ld a, [$c155]
	ld h, a
	ldh a, [$ffee]
	add $04
	sub h
	ld [de], a
	inc de
	ldh a, [$fff1]
	ld c, a
	ld b, $00
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld hl, $ffed
	xor [hl]
	ld [de], a
	inc de
	jr jr_000_3cbc

Call_3D19::
	ld a, $15
	ld [$2100], a
	jr jr_000_3cca

Call_3D20::
	push hl
	ld hl, $c000
	jr jr_000_3d36

Call_3D26::
	ldh a, [$fff1]
	inc a
	jr z, jr_000_3d82

	push hl
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de

jr_000_3d36:
	push hl
	pop de
	pop hl
	ld a, c
	ldh [$ffd7], a
	ld a, [$c123]
	ld c, a
	call Call_3D87
	ldh a, [$ffd7]
	ld c, a

jr_000_3d46:
	ldh a, [$ffec]
	add [hl]
	ld [de], a
	inc hl
	inc de
	push bc
	ld a, [$c155]
	ld c, a
	ldh a, [$ffee]
	add [hl]
	sub c
	ld [de], a
	inc hl
	inc de
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	push af
	add c
	ld [de], a
	pop af
	cp $ff
	jr nz, jr_000_3d68

	dec de
	xor a
	ld [de], a
	inc de

jr_000_3d68:
	pop bc
	inc de
	ldh a, [$ffed]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_000_3d46

	ld a, [$c123]
	ld c, a
	ld a, $15
	ld [$2100], a
	call $796d
	jp Call_07C0


jr_000_3d82:
	ld a, [$c123]
	ld c, a
	ret


Call_3D87::
	push hl
	ld a, [$c124]
	and a
	jr z, jr_000_3dad

	ldh a, [$ffee]
	dec a
	cp $c0
	jr nc, jr_000_3dac

	ldh a, [$ffec]
	dec a
	cp $88
	jr nc, jr_000_3dac

	ld hl, $c220
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_000_3dac

	ld hl, $c230
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_3dad

jr_000_3dac:
	pop af

jr_000_3dad:
	pop hl
	ret


Call_3DAF::
	ld hl, $c240
	add hl, bc
	ld [hl], b
	ld hl, $c250
	add hl, bc
	ld [hl], b
	ret


Call_3DBA::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ldh [$ffef], a
	ld hl, $c310
	add hl, bc
	sub [hl]
	ldh [$ffec], a
	ret


Call_3DD0::
	ld hl, $2100
	ld [hl], $15
	call $7974
	jp Call_07C0


	db $21, $00, $21, $36, $04, $cd, $10, $5a, $c3, $c0, $07, $21, $00, $21, $36, $04
	db $cd, $80, $56, $c3, $c0, $07, $21, $00, $21, $36, $04, $cd, $4d, $50, $c3, $c0
	db $07, $21, $00, $21, $36, $04, $cd, $b5, $49, $c3, $c0, $07, $21, $00, $21, $36
	db $04, $cd, $00, $40, $c3, $c0, $07, $21, $00, $21, $36, $05, $cd, $2b, $6c, $c3
	db $c0, $07, $21, $00, $21, $36, $05, $cd, $76, $67, $c3, $c0, $07, $21, $00, $21
	db $36, $05, $cd, $4f, $62, $c3, $c0, $07, $21, $00, $21, $36, $05, $cd, $59, $59
	db $c3, $c0, $07, $21, $00, $21, $36, $05, $cd, $9f, $54, $c3, $c0, $07

Call_3E49::
	ld a, [$dbaf]
	push af
	ld a, $02
	call Call_07B9
	call $6fb1
	pop af
	jp Call_07B9


	db $21, $00, $21, $36, $04, $cd, $5a, $5c, $c3, $c0, $07

Call_3E64::
	ld hl, $2100
	ld [hl], $03
	call $5464
	jp Call_07C0


Call_3E6F::
	ld hl, $2100
	ld [hl], $02
	call $5fd1
	call $6117
	jp Call_07C0


Call_3E7D::
	ld a, $02
	call Call_07B9
	call $41ba
	ld a, $03
	jp Call_07B9


Call_3E8A::
	ld hl, $2100
	ld [hl], $02
	call $61e7
	jp Call_07C0


Call_3E95::
	ld hl, $2100
	ld [hl], $03
	call $6497
	jp Call_07C0


Call_3EA0::
	ld a, $06
	call Call_07B9
	call $7940
	ld a, $03
	jp Call_07B9


Call_3EAD::
	ld e, $10
	ld hl, $c280

jr_000_3eb2:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_000_3eb2

	ret


Call_3EB8::
	ld hl, $c4a0
	add hl, bc
	ld a, [hl]
	and a
	ret z

	ldh a, [$ffe7]
	xor c
	and $03
	ret nz

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $08
	call Call_0953
	ld hl, $c520
	add hl, de
	ld [hl], $0f
	ret


Call_3ED9::
	ld hl, $c3f0
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_000_3ee4

	cpl
	inc a

jr_000_3ee4:
	ldh [$ffd7], a
	ld hl, $c400
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_000_3ef1

	cpl
	inc a

jr_000_3ef1:
	ld e, $03
	ld hl, $ffd7
	cp [hl]
	jr c, jr_000_3efb

	ld e, $0c

jr_000_3efb:
	ld a, e
	ld hl, $c2a0
	add hl, bc
	and [hl]
	jr z, jr_000_3f08

	ld hl, $c410
	add hl, bc
	ld [hl], b

jr_000_3f08:
	ret


	db $b0, $b4, $b1, $b2, $b3, $b6, $ba, $bc, $b8

Call_3F12::
	ld hl, $c14f
	ld a, [$c124]
	or [hl]
	ret nz

	ld a, [$c165]
	and a
	jr z, jr_000_3f25

	dec a
	ld [$c165], a
	ret


jr_000_3f25:
	ld a, [$c1bd]
	and a
	ret nz

	inc a
	ld [$c1bd], a
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $04
	ld a, $19
	jr z, jr_000_3f3b

	ld a, $50

jr_000_3f3b:
	ld [$d368], a
	ldh [$ffbd], a
	ld a, [$c16b]
	cp $04
	ret nz

	ldh a, [$ffeb]
	cp $87
	jr nz, jr_000_3f50

	ld a, $da
	jr jr_000_3f6e

jr_000_3f50:
	cp $bc
	jr nz, jr_000_3f58

	ld a, $26
	jr jr_000_3f6e

jr_000_3f58:
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $04
	jr nz, jr_000_3f71

	ldh a, [$fff7]
	cp $05
	jr z, jr_000_3f71

	ld e, a
	ld d, b
	ld hl, $3f09
	add hl, de
	ld a, [hl]

jr_000_3f6e:
	call Call_2197

jr_000_3f71:
	ret


	db $01, $02, $04, $08, $10, $20, $40, $80

Call_3F7A::
	ld a, $03
	ld [$c113], a
	ld [$2100], a
	call $562f
	call Call_07C0

Call_3F88::
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, Call_3FB7

	push af
	ld a, [$dbb5]
	ld e, a
	ld d, b
	inc a
	ld [$dbb5], a
	ld a, [hl]
	ld hl, $dbb6
	add hl, de
	ld [hl], a
	pop af

Call_3FA2::
	cp $08
	jr nc, Call_3FB7

	ld e, a
	ld d, b
	ld hl, $3f72
	add hl, de
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ld a, [hl]
	ld hl, $cf00
	add hl, de
	or [hl]
	ld [hl], a

Call_3FB7::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


Jump_000_3fbd:
	ld a, $05
	ld [$2100], a
	ld hl, $5919
	ld de, $8460
	ld bc, $0010
	call Call_28C5
	ld hl, $5929
	jr jr_000_3fe7

Jump_000_3fd3:
	ld a, $05
	ld [$2100], a
	ld hl, $5939
	ld de, $8460
	ld bc, $0010
	call Call_28C5
	ld hl, $5949

jr_000_3fe7:
	ld de, $8480
	ld bc, $0010
	call Call_28C5
	xor a
	ldh [$ffa5], a
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


	db $ff, $ff, $ff, $ff, $ff
