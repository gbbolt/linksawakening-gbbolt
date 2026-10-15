; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

Call_07_4000::
	ld a, $04
	ldh [$fff4], a
	ret


	db $7c, $00, $7e, $00, $7e, $20, $7c, $20, $f4, $10, $f6, $10, $f0, $10, $f2, $10

Call_07_4015::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_007_41dd

	and a
	jr nz, jr_007_4046

	inc [hl]
	ldh a, [$ffee]
	rla
	rla
	and $40
	push af
	ld hl, $c430
	add hl, bc
	or [hl]
	ld [hl], a
	pop af
	sla a
	ld hl, $c350
	add hl, bc
	or [hl]
	ld [hl], a
	ldh a, [$ffee]
	rra
	rra
	rra
	rra
	and $01
	ld hl, $c440
	add hl, bc
	ld [hl], a

jr_007_4046:
	ld hl, $c2c0
	add hl, bc
	ldh a, [$ffec]
	sub [hl]
	ldh [$ffec], a
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ld de, $400d
	call Call_3C3B
	call Call_3DBA
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_4074

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ld de, $4005
	call Call_3C3B

jr_007_4074:
	call Call_07_7C76
	ld hl, $c360
	add hl, bc
	ld [hl], $04
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_40ac

	ld [hl], b
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	xor $01
	call Call_3B87
	ld hl, $c3a0
	add hl, bc
	ld [hl], $05
	ld hl, $fff4
	ld [hl], $05
	call Call_088C
	ld [hl], $1f
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	add $02
	ld [hl], a
	call Call_07_4184
	ret


jr_007_40ac:
	call Call_08E2
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_07_40B5::
	dw Jump_07_40C1
	dw Jump_07_41A5

	db $10, $f0, $00, $00, $00, $00, $f0, $10

Jump_07_40C1::
	ld hl, $c2c0
	add hl, bc
	ld [hl], b
	call Call_0891
	jr nz, jr_007_4114

	call Call_07_7D45
	add $08
	cp $10
	jr c, jr_007_40e4

	push de
	call Call_07_7D35
	add $08
	pop de
	cp $10
	jr nc, jr_007_4114

	ld a, e
	cp $02
	jr z, jr_007_4114

jr_007_40e4:
	call Call_3B8D
	call Call_07_7D55
	ld d, b
	ld hl, $40b9
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $40bd
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ld hl, $c350
	add hl, bc
	res 2, [hl]
	call Call_3B65
	call Call_0891
	ld [hl], $30
	ret


jr_007_4114:
	ld hl, $c340
	add hl, bc
	set 7, [hl]
	ld hl, $c350
	add hl, bc
	set 2, [hl]
	call Call_3B65
	call Call_3BD5
	ret nc

	ld a, [$c19b]
	and a
	ret nz

	ld a, [$db00]
	cp $03
	jr nz, jr_007_413a

	ldh a, [$ffcc]
	and $20
	jr nz, jr_007_4146

	ret


jr_007_413a:
	ld a, [$db01]
	cp $03
	ret nz

	ldh a, [$ffcc]
	and $10
	jr z, jr_007_41a4

jr_007_4146:
	ld a, [$c3cf]
	and a
	ret nz

	inc a
	ld [$c3cf], a
	call Call_3B8D
	ld [hl], $02
	ld hl, $c280
	add hl, bc
	ld [hl], $07
	ld hl, $c390
	add hl, bc
	ld [hl], $01
	ld hl, $c490
	add hl, bc
	ld [hl], b
	ldh a, [$ff9e]
	ld [$c15d], a
	call Call_0891
	ld [hl], $02
	ld hl, $fff3
	ld [hl], $02
	ld hl, $c3a0
	add hl, bc
	ld [hl], $05
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	xor $01
	call Call_3B87

Call_07_4184::
	ld a, $bb
	call Call_3C01
	ret c

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c2e0
	add hl, de
	ld [hl], $40

jr_007_41a4:
	ret


Jump_07_41A5::
	call Call_0891
	jr nz, jr_007_41b4

jr_007_41aa:
	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	ret


jr_007_41b4:
	call Call_07_7CE2
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_41aa

	ld hl, $c2c0
	add hl, bc
	ld [hl], $04
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $f0, $f4, $00, $0c, $10, $0c, $00, $f4, $f0, $f4

Jump_007_41dd:
	ld de, $4005
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_07_7CE2
	call Call_3B9E
	call Call_3BB4
	call Call_0891
	jr nz, jr_007_4221

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $41d5
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $41d3
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_007_4221:
	ret


	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $7c, $00, $00, $f8, $7e, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $fc, $f0, $64, $00, $fc, $f8, $66, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $fc, $f0, $64, $00, $fc, $f8, $66, $00, $00, $00, $74, $00, $00, $08, $76, $00

Call_07_4272::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_007_4417

	and a
	jr nz, jr_007_42b2

	inc [hl]
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld a, $b8
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	add $06
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	add $10
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c350
	add hl, de
	ld [hl], $ac
	push bc
	push de
	pop bc
	call Call_3B65
	pop bc

jr_007_42b2:
	ld a, [$c19f]
	and a
	jr z, jr_007_42c4

	ldh a, [$fff1]
	cp $03
	ld a, $02
	jr nz, jr_007_42c2

	ld a, $04

jr_007_42c2:
	ldh [$fff1], a

jr_007_42c4:
	call Call_07_43B3
	call Call_07_7C76
	ldh a, [$fff0]
	rst $00

JumpTable_07_42CD::
	dw Jump_07_42D7
	dw Jump_07_4305
	dw Jump_07_4327
	dw Jump_07_4355
	dw Jump_07_43AA

Jump_07_42D7::
	call Call_07_7C23
	jr nc, jr_007_42f9

	ld a, [$db0e]
	cp $0b
	jr nz, jr_007_42eb

	ld a, $e8
	call Call_2185
	jp Call_3B8D


jr_007_42eb:
	cp $0c
	jr nc, jr_007_42f4

	ld a, $e7
	jp Call_2185


jr_007_42f4:
	ld a, $ed
	jp Call_2185


jr_007_42f9:
	ldh a, [$ffe7]
	and $30
	ld e, b
	jr z, jr_007_4301

	inc e

jr_007_4301:
	ld a, e
	jp Call_3B87


Jump_07_4305::
	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_007_4320

	ld a, $01
	ld [$db7f], a
	ld [$c167], a
	call Call_0891
	ld [hl], $d0
	ld a, $e9
	jp Call_2185


jr_007_4320:
	ld [hl], b
	ld a, $ea
	call Call_2185
	ret


Jump_07_4327::
	ld a, $02
	ldh [$ffa1], a
	ld a, $01
	ld [$c10b], a
	call Call_0891
	jr nz, jr_007_433f

	ld [hl], $20
	ld a, $eb
	call Call_2185
	call Call_3B8D

jr_007_433f:
	ld e, $03
	cp $30
	jr c, jr_007_4351

	cp $80
	jr nc, jr_007_42f9

	ldh a, [$ffe7]
	and $18
	ld e, b
	jr z, jr_007_4351

	inc e

jr_007_4351:
	ld a, e
	jp Call_3B87


Jump_07_4355::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_007_43a4

	ld [$c10b], a
	call Call_3B8D
	ld a, $54
	call Call_3C01
	ldh a, [$ffd7]
	sub $20
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh [$ffee], a
	ldh a, [$ffd8]
	add $08
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh [$ffec], a
	ld hl, $c320
	add hl, de
	ld [hl], $20
	ld hl, $c440
	add hl, de
	ld [hl], $01
	push bc
	push de
	pop bc
	ld a, $0a
	call Call_3C25
	pop bc
	call Call_07_4700
	ld a, $08
	ldh [$fff2], a
	ld a, $0c
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a

jr_007_43a4:
	ld a, $03
	call Call_3B87
	ret


Jump_07_43AA::
	ld a, $02
	ldh [$ffa1], a
	call Call_3B8D
	ld [hl], b
	ret


Call_07_43B3::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $4222
	add hl, de
	ld c, $04
	call Call_3D26
	ret


	db $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $01, $00, $00, $ff, $fe, $fe, $01, $01, $01, $00, $00, $ff, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $00, $01, $01, $01
	db $fe, $fe, $ff, $00, $00, $01, $02, $02, $00, $00, $01, $02, $02, $02, $01, $00

Jump_007_4417:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $440f
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	sub $10
	ld [$c210], a
	call Call_07_4492
	call Call_3BD5
	jr nc, jr_007_4457

	ldh a, [$ff9b]
	and $80
	jr nz, jr_007_4457

	call Call_07_7D45
	add $08
	bit 7, a
	jr z, jr_007_4457

	ldh a, [$ffec]
	sub $0f
	ldh [$ff99], a
	ld a, $02
	ldh [$ff9b], a
	ld a, $01
	ld [$c147], a

jr_007_4457:
	call Call_07_7C76
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $07
	jr nz, jr_007_447d

	ld e, $48
	ld a, [$c147]
	and a
	jr z, jr_007_446e

	ld e, $4b

jr_007_446e:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub e
	jr z, jr_007_447d

	and $80
	jr z, jr_007_447c

	inc [hl]
	inc [hl]

jr_007_447c:
	dec [hl]

jr_007_447d:
	ret


	db $00, $f8, $68, $00, $00, $00, $6a, $00, $00, $08, $6a, $00, $00, $10, $6a, $00
	db $00, $18, $6c, $00

Call_07_4492::
	ld hl, $447e
	ld c, $05
	call Call_3D26
	ret


	db $72, $20, $70, $20, $70, $00, $72, $00, $76, $00, $78, $00, $78, $20, $76, $20
	db $74, $00, $74, $20, $74, $10, $74, $30, $00, $fc, $7a, $00, $00, $04, $7c, $00
	db $00, $0c, $7e, $00, $00, $fc, $7e, $20, $00, $04, $7c, $20, $00, $0c, $7a, $20
	db $00, $00, $01, $02, $02, $02, $01, $00

Call_07_44D3::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_007_4712

	ldh a, [$fff0]
	cp $02
	jr nc, jr_007_44fc

	ldh a, [$fff8]
	and $20
	jr z, jr_007_44ea

	inc [hl]
	ret


jr_007_44ea:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $44cb
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a

jr_007_44fc:
	ldh a, [$fff1]
	cp $04
	jr c, jr_007_451a

	sub $04
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $44b3
	add hl, de
	ld c, $03
	call Call_3D26
	jr jr_007_4523

jr_007_451a:
	ld de, $449b
	call Call_3C3B
	call Call_3DBA

jr_007_4523:
	ldh a, [$fff0]
	cp $05
	jr z, jr_007_452d

	cp $03
	jr nc, jr_007_453f

jr_007_452d:
	ldh a, [$ffec]
	add $0b
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $44ab
	call Call_3C3B
	call Call_3DBA

jr_007_453f:
	call Call_07_7C76
	ldh a, [$fff0]
	rst $00

JumpTable_07_4545::
	dw Jump_07_455B
	dw Jump_07_4564
	dw Jump_07_45B0
	dw Jump_07_45B3
	dw Jump_07_45DE
	dw Jump_07_45FC
	dw Jump_07_4611
	dw Jump_07_466F
	dw Jump_07_4698
	dw Jump_07_46BA
	dw Jump_07_46D5

Jump_07_455B::
	ld hl, $c2b0
	add hl, bc
	ld [hl], $30
	jp Call_3B8D


Jump_07_4564::
	call Call_07_7D35
	ld a, e
	call Call_3B87
	call Call_07_7BD0
	call Call_07_7D35
	add $12
	cp $24
	jr nc, jr_007_4593

	call Call_07_7D45
	add $12
	cp $24
	jr nc, jr_007_4593

	ldh a, [$ff9c]
	and a
	jr z, jr_007_4593

	call Call_3B8D
	call Call_0891
	ld [hl], $14
	ld a, $f1
	call Call_2185
	ret


jr_007_4593:
	call Call_07_7C23
	jr nc, jr_007_45af

	ld a, [$db0e]
	cp $0c
	jr nz, jr_007_45aa

	ld a, $f2
	call Call_2185
	call Call_3B8D
	ld [hl], $05
	ret


jr_007_45aa:
	ld a, $f0
	call Call_2185

jr_007_45af:
	ret


Jump_07_45B0::
	jp Call_3B8D


Jump_07_45B3::
	ld a, [$c19f]
	and a
	jr nz, jr_007_45dd

	call Call_0891
	jr nz, jr_007_45cc

	ld [hl], $40
	call Call_07_4700
	call Call_3B8D
	ld a, $ff
	call Call_3B87
	ret


jr_007_45cc:
	ld e, $ff
	cp $10
	jr nc, jr_007_45d9

	ld e, $02
	cp $08
	jr c, jr_007_45d9

	inc e

jr_007_45d9:
	ld a, e
	call Call_3B87

jr_007_45dd:
	ret


Jump_07_45DE::
	call Call_0891
	jr nz, jr_007_45fb

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, $c200
	add hl, bc
	add [hl]
	ld [hl], a
	ldh [$ffee], a
	call Call_3B8D
	ld [hl], $01
	call Call_07_4700

jr_007_45fb:
	ret


Jump_07_45FC::
	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_007_460b

	call Call_0891
	ld [hl], $c0
	ret


jr_007_460b:
	ld [hl], b
	ld a, $f4
	jp Call_2185


Jump_07_4611::
	ld a, [$c19f]
	and a
	jr nz, jr_007_466e

	call Call_0891
	jr z, jr_007_465c

	cp $70
	jr nz, jr_007_4628

	dec [hl]
	push af
	ld a, $f3
	call Call_2185
	pop af

jr_007_4628:
	cp $90
	jr nz, jr_007_4642

	ldh a, [$ff99]
	sub $03
	ldh [$ffd8], a
	ldh a, [$ff98]
	ldh [$ffd7], a
	ld a, $0e
	ldh [$fff2], a
	ld a, $01
	call Call_0953
	call Call_0891

jr_007_4642:
	ld e, $00
	cp $20
	jr c, jr_007_464e

	cp $90
	jr nc, jr_007_464e

	ld e, $01

jr_007_464e:
	ld a, e
	ldh [$ff9c], a
	ld hl, $ffa1
	ld [hl], $02
	ld a, $04
	ld [$c13b], a
	ret


jr_007_465c:
	ld a, $0d
	ld [$db0e], a
	ldh [$ffa5], a
	call Call_0898
	call Call_3B8D
	call Call_0891
	ld [hl], $30

jr_007_466e:
	ret


Jump_07_466F::
	call Call_0891
	jr nz, jr_007_4697

	call Call_3B8D
	ldh a, [$fff1]
	add $04
	call Call_3B87
	ld e, $08
	cp $04
	jr nz, jr_007_4686

	ld e, $f8

jr_007_4686:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	call Call_07_4700
	call Call_07_7244

jr_007_4697:
	ret


Jump_07_4698::
	call Call_07_7CE2
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_46b9

	ld [hl], b
	call Call_3B8D
	call Call_07_4700
	call Call_0891
	ld [hl], $10

jr_007_46b9:
	ret


Jump_07_46BA::
	call Call_0891
	jr nz, jr_007_46c9

	ld [hl], $20
	ld a, $ff
	call Call_3B87
	jp Call_3B8D


jr_007_46c9:
	ld e, $02
	cp $08
	jr nc, jr_007_46d0

	inc e

jr_007_46d0:
	ld a, e
	call Call_3B87
	ret


Jump_07_46D5::
	call Call_0891
	ret nz

	ld hl, $c390
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Call_07_7D7C

	inc [hl]
	call Call_27ED
	and $01
	call Call_3B87
	ld e, $10
	and a
	jr z, jr_007_46f3

	ld e, $f0

jr_007_46f3:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	call Call_3B8D
	ld [hl], $07
	ret


Call_07_4700::
	ldh a, [$ffec]
	ldh [$ffd8], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ld a, $01
	call Call_0953
	ld a, $0e
	ldh [$fff2], a
	ret


Jump_007_4712:
	ldh a, [$fff0]
	rst $00

JumpTable_07_4715::
	dw Jump_07_471D
	dw Jump_07_4736
	dw Jump_07_474B
	dw Jump_07_4775

Jump_07_471D::
	call Call_07_7C76
	ld hl, $c200
	add hl, bc
	ld [hl], $58
	ld hl, $c210
	add hl, bc
	ld [hl], $80
	ld a, [$c130]
	and a
	jr z, jr_007_4735

	call Call_3B8D

jr_007_4735:
	ret


Jump_07_4736::
	call Call_07_7C76
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ld hl, $c250
	add hl, bc
	ld [hl], $fc
	call Call_07_4700
	jp Call_3B8D


Jump_07_474B::
	call Call_07_47CE
	call Call_07_7C76
	call Call_07_7CE2
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_4769

	ld [hl], b
	call Call_3B8D

jr_007_4769:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_07_4775::
	call Call_07_7D35
	ld a, e
	add $02
	ldh [$fff1], a
	call Call_07_47CE
	call Call_07_7C76
	call Call_07_7C23
	jr nc, jr_007_478d

	ld a, $f6
	call Call_2185

jr_007_478d:
	ret


	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $f0, $00, $72, $20, $f0, $08, $70, $20, $00, $00, $76, $20, $00, $08, $74, $20
	db $f0, $ff, $72, $20, $f0, $07, $70, $20, $00, $00, $7a, $20, $00, $08, $78, $20
	db $f0, $01, $70, $00, $f0, $09, $72, $00, $00, $00, $78, $00, $00, $08, $7a, $00

Call_07_47CE::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $478e
	add hl, de
	ld c, $04
	jp Call_3D26


	db $6e, $20, $6c, $20, $6c, $00, $6e, $00, $70, $00, $72, $00, $74, $00, $76, $00
	db $78, $00, $7a, $00, $7c, $00, $76, $00, $72, $20, $70, $20, $76, $20, $74, $20
	db $7a, $20, $78, $20, $76, $20, $7c, $20, $7e, $00, $7e, $20

Call_07_480D::
	ld a, [$dba5]
	and a
	jr z, jr_007_485d

	ld a, [$db0e]
	cp $08
	jr nc, jr_007_4822

	ld a, [$db66]
	and $02
	jp nz, Call_07_7D7C

jr_007_4822:
	ld de, $47f9
	ld a, [$db0e]
	cp $08
	jr nc, jr_007_4835

	call Call_07_7D35
	ld a, e
	ldh [$fff1], a
	ld de, $47e1

jr_007_4835:
	call Call_3C3B
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_07_7BD0
	call Call_07_7C23
	jr nc, jr_007_485c

	ld a, [$db0e]
	cp $08
	jr nc, jr_007_4857

	ld a, $27
	jp Call_2197


jr_007_4857:
	ld a, $76
	call Call_2185

jr_007_485c:
	ret


jr_007_485d:
	ldh a, [$fff8]
	and $20
	jp nz, Call_07_7D7C

	ld de, $47e9
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_4872

	ld de, $47f9

jr_007_4872:
	call Call_3C3B
	ld a, [$db0e]
	cp $08
	jr nc, jr_007_4894

	ldh a, [$ffee]
	add $10
	ldh [$ffee], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $4809
	call Call_3C3B
	call Call_3DBA

jr_007_4894:
	call Call_07_7C76
	call Call_07_7BD0
	ldh a, [$fff0]
	rst $00

JumpTable_07_489D::
	dw Jump_07_48A7
	dw Jump_07_48E4
	dw Jump_07_4909
	dw Jump_07_493E
	dw Jump_07_494B

Jump_07_48A7::
	call Call_07_7D35
	ld hl, $c380
	add hl, bc
	ld [hl], e
	add $24
	cp $48
	jr nc, jr_007_48d9

	call Call_07_7D45
	add $24
	cp $48
	jr nc, jr_007_48d9

	call Call_07_7C23
	jr nc, jr_007_48d4

	ld a, [$db0e]
	cp $07
	ld a, $70
	jr z, jr_007_48ce

	ld a, $77

jr_007_48ce:
	call Call_2185
	call Call_3B8D

jr_007_48d4:
	xor a
	call Call_3B87
	ret


jr_007_48d9:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_07_48E4::
	ld a, [$c177]
	and a
	jr nz, jr_007_48ff

	ld a, [$db0e]
	cp $07
	jr nz, jr_007_48ff

	ld a, $72
	call Call_2185
	call Call_3B8D
	call Call_0891
	ld [hl], $c0
	ret


jr_007_48ff:
	ld a, $71
	call Call_2185
	call Call_3B8D
	ld [hl], b
	ret


Jump_07_4909::
	ld a, [$c19f]
	and a
	jr nz, Call_07_4931

	call Call_0891
	jr nz, jr_007_4928

	ld [$c10b], a
	ld a, $73
	call Call_2185
	ld a, $08
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	jp Call_3B8D


jr_007_4928:
	ld a, $02
	ldh [$ffa1], a
	ld a, $01
	ld [$c10b], a

Call_07_4931::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	ret


Jump_07_493E::
	ld a, [$c19f]
	and a
	jr nz, jr_007_494a

	call Call_0898
	call Call_3B8D

jr_007_494a:
	ret


Jump_07_494B::
	call Call_07_4931
	call Call_07_7C23
	jr nc, jr_007_4958

	ld a, $75
	call Call_2185

jr_007_4958:
	ret


	db $fa, $00, $70, $00, $fa, $08, $72, $00, $fa, $10, $74, $00, $fa, $18, $70, $20
	db $0a, $00, $76, $00, $0a, $08, $78, $00, $0a, $10, $78, $20, $0a, $18, $76, $20
	db $fa, $00, $70, $00, $fa, $08, $74, $20, $fa, $10, $72, $20, $fa, $18, $70, $20
	db $0a, $00, $76, $00, $0a, $08, $78, $00, $0a, $10, $78, $20, $0a, $18, $76, $20
	db $7e, $00, $7a, $00, $7c, $00, $7c, $20, $7a, $20

Call_07_49A3::
	xor a
	ldh [$fff1], a
	ld a, $4a
	ldh [$ffec], a
	ld de, $499b
	call Call_3C3B
	ld a, $68
	ldh [$ffee], a
	ld de, $499f
	call Call_3C3B
	ld a, [$db0e]
	cp $06
	jr nz, jr_007_49cf

	ld a, $74
	ldh [$ffee], a
	ld a, $38
	ldh [$ffec], a
	ld de, $4999
	call Call_3CD0

jr_007_49cf:
	call Call_3DBA
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ld hl, $4959
	and a
	jr z, jr_007_49e0

	ld hl, $4979

jr_007_49e0:
	ld c, $08
	call Call_3D26
	ld a, $06
	call Call_3DD0
	xor a
	call Call_3B87
	call Call_07_7C76
	ldh a, [$ffe7]
	and $20
	call Call_3B87
	call Call_07_7BD0
	ldh a, [$fff0]
	rst $00

JumpTable_07_49FE::
	dw Jump_07_4A04
	dw Jump_07_4A39
	dw Jump_07_4A61

Jump_07_4A04::
	call Call_07_7C16
	jr nc, jr_007_4a38

	ld e, $d3
	ld a, [$d8fd]
	and $30
	jr nz, jr_007_4a34

	ld a, [$db0e]
	cp $06
	jr nz, jr_007_4a21

	ld a, $cf
	call Call_07_4A74
	jp Call_3B8D


jr_007_4a21:
	ld e, $d4
	ld a, [$db73]
	and a
	jr nz, jr_007_4a34

	ld e, $ce
	ld a, [$db0e]
	cp $07
	jr nz, jr_007_4a34

Call_07_4A32::
	ld e, $d2

jr_007_4a34:
	ld a, e
	call Call_07_4A74

jr_007_4a38:
	ret


Jump_07_4A39::
	ld a, [$c19f]
	and a
	jr nz, jr_007_4a60

	call Call_3B8D
	ld a, [$c177]
	and a
	jr z, jr_007_4a4f

	ld [hl], b
	ld a, $d1
	call Call_07_4A74
	ret


jr_007_4a4f:
	ld a, $07
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	call Call_0898
	call Call_0891
	ld [hl], $70

jr_007_4a60:
	ret


Jump_07_4A61::
	call Call_0891
	jr nz, jr_007_4a73

	ld a, [$c19f]
	and a
	jr nz, jr_007_4a73

	call Call_07_4A32
	call Call_3B8D
	ld [hl], b

jr_007_4a73:
	ret


Call_07_4A74::
	ld e, a
	ldh a, [$ff99]
	push af
	ld a, $10
	ldh [$ff99], a
	ld a, e
	call Call_2185
	pop af
	ldh [$ff99], a
	ret


	db $70, $00, $70, $20

Call_07_4A88::
	ldh a, [$fff8]
	and $20
	jp nz, Call_07_7D7C

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_007_4b79

	ld a, c
	ld [$d201], a
	call Call_0891
	and $20
	jr z, jr_007_4aa7

	ld hl, $ffee
	dec [hl]

jr_007_4aa7:
	ld de, $4a84
	call Call_3C3B
	call Call_07_7C76
	ldh a, [$fff0]
	rst $00

JumpTable_07_4AB3::
	dw Jump_07_4ABD
	dw Jump_07_4B10
	dw Jump_07_4B18
	dw Jump_07_4B3E
	dw Jump_07_4B3F

Jump_07_4ABD::
	ld a, [$db7f]
	cp $02
	jr nz, jr_007_4ad8

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], $10
	call Call_3B8D
	ld [hl], $04
	ret


jr_007_4ad8:
	xor a
	ld [$d202], a
	call Call_3B8D

Call_07_4ADF::
	ld a, $b3
	call Call_3C01
	jr c, jr_007_4b0e

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c440
	add hl, de
	ld [hl], $01
	ld hl, $c240
	add hl, de
	ld [hl], $0e
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	ld hl, $c350
	add hl, de
	ld [hl], $00
	and a
	ret


jr_007_4b0e:
	scf
	ret


Jump_07_4B10::
	ld a, [$d202]
	and a
	jp nz, Call_3B8D

	ret


Jump_07_4B18::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jp z, Call_3B8D

	ldh a, [$ffe7]
	and $07
	jr nz, jr_007_4b3d

	call Call_07_4ADF
	jr c, jr_007_4b3d

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld hl, $c3d0
	add hl, de
	ld [hl], a
	ld hl, $c240
	add hl, de
	ld [hl], b

jr_007_4b3d:
	ret


Jump_07_4B3E::
	ret


Jump_07_4B3F::
	call Call_0891
	jr nz, jr_007_4b74

	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_4b74

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_3BD5
	jr nc, jr_007_4b74

	xor a
	ld [$db7f], a
	ld a, $06
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	call Call_0898
	call Call_07_7D7C

jr_007_4b74:
	ret


	db $72, $00, $72, $40

Jump_007_4b79:
	ld de, $4b75
	call Call_3CD0
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	call Call_07_7C76
	ldh a, [$fff0]
	rst $00

JumpTable_07_4B8E::
	dw Jump_07_4B9A
	dw Jump_07_4C1B
	dw Jump_07_4C83

	db $01, $ff, $10, $f0, $0b, $f5

Jump_07_4B9A::
	ldh a, [$ffe7]
	and $01
	jr nz, jr_007_4be0

	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4b94
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $4b96
	add hl, de
	cp [hl]
	jr nz, jr_007_4bc0

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_007_4bc0:
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4b94
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $4b98
	add hl, de
	cp [hl]
	jr nz, jr_007_4be0

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_007_4be0:
	call Call_07_7CE2
	ld a, [$d202]
	and a
	jp nz, Call_3B8D

	ret


	db $f0, $e8, $e8, $e0, $e0, $d8, $10, $18, $18, $20, $20, $28, $00, $f8, $08, $f8
	db $08, $00, $00, $08, $f8, $08, $f8, $00, $00, $f8, $08, $f8, $08, $00, $00, $08
	db $f8, $08, $f8, $00, $10, $18, $18, $20, $20, $28, $f0, $e8, $e8, $e0, $e0, $d8

Jump_07_4C1B::
	ld a, $22
	ldh [$fff2], a
	ld a, [$d204]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jp z, Call_07_7D7C

	ldh a, [$ffe7]
	and $07
	ld hl, $c3d0
	add hl, bc
	cp [hl]
	jr nz, jr_007_4c7f

	ld a, [$d204]
	ld e, a
	ld d, b
	ld hl, $c380
	add hl, de
	ld a, [hl]
	ld e, a
	ld hl, $c3d0
	add hl, bc
	rla
	rla
	and $fc
	add e
	add e
	add [hl]
	ld e, a
	ld d, b
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	push bc
	ld a, [$d204]
	ld c, a
	ld hl, $4beb
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	add [hl]
	ldh [$ff98], a
	ld hl, $4c03
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	add [hl]
	ldh [$ff99], a
	pop bc
	ld a, $24
	call Call_3C25
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a

jr_007_4c7f:
	call Call_07_7CE2
	ret


Jump_07_4C83::
	ret


	db $5a, $20, $58, $20, $5e, $20, $5c, $20, $58, $00, $5a, $00, $5c, $00, $5e, $00
	db $54, $00, $56, $00, $56, $20, $54, $20, $50, $00, $52, $00, $52, $20, $50, $20
	db $74, $00, $76, $00

Call_07_4CA8::
	ld a, c
	ld [$d204], a
	ldh a, [$fff8]
	and $40
	jp nz, Call_07_7D7C

	ld a, [$db67]
	and $02
	jp z, Call_07_7D7C

	ld de, $4c84
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_4cdc

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_007_4cdc:
	ldh a, [$fff0]
	rst $00

JumpTable_07_4CDF::
	dw Jump_07_4CED
	dw Jump_07_4D0F
	dw Jump_07_4D46
	dw Jump_07_4DBA
	dw Jump_07_4E43
	dw Jump_07_4EAA
	dw Jump_07_4EDA

Jump_07_4CED::
	ld a, $02
	call Call_3B87
	ld hl, $c200
	add hl, bc
	ld [hl], $60
	ld hl, $c210
	add hl, bc
	ld [hl], $58
	call Call_07_7BD0
	call Call_07_7C23
	jr nc, jr_007_4d0e

	ld a, $c0
	call Call_2185
	call Call_3B8D

jr_007_4d0e:
	ret


Jump_07_4D0F::
	call Call_07_7BD0
	ld a, [$c19f]
	and a
	jr nz, jr_007_4d3d

	ld a, [$c177]
	and a
	jr nz, jr_007_4d34

	ld a, $02
	ld [$db7f], a
	ld hl, $d887
	set 6, [hl]
	call Call_0891
	ld [hl], $a0
	ld a, $01
	ldh [$fff2], a
	jp Call_3B8D


jr_007_4d34:
	ld a, $c2
	call Call_2185
	call Call_3B8D
	ld [hl], b

jr_007_4d3d:
	ret


	db $78, $00, $ff, $00, $7a, $00, $7c, $00

Jump_07_4D46::
	ld a, $01
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	cp $30
	jr c, jr_007_4d6c

	xor a
	ldh [$fff1], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	ld de, $4d3e
	call Call_3C3B
	call Call_3DBA
	ld a, $08
	call Call_3B87
	ret


jr_007_4d6c:
	cp $18
	jr nc, jr_007_4d98

	ld a, $02
	ldh [$ff9e], a
	ld hl, $c240
	add hl, bc
	ld [hl], $fe
	ld hl, $c250
	add hl, bc
	ld [hl], $f4
	call Call_07_7CE2
	call Call_0891
	jr nz, jr_007_4d98

	ld a, $34
	ld [$d368], a
	ldh [$ffb0], a
	call Call_0891
	ld [hl], $c0
	call Call_3B8D
	ret


jr_007_4d98:
	ld a, $01
	ldh [$fff1], a
	ldh a, [$ffee]
	sub $0c
	ldh [$ffee], a
	ld de, $4d3e
	call Call_3C3B
	call Call_3DBA
	call Call_0891
	rra
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	ret


Jump_07_4DBA::
	ld a, $01
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_007_4dc8

	ld [hl], $0c
	call Call_3B8D

jr_007_4dc8:
	call Call_0891
	cp $20
	jr nz, jr_007_4dd9

	ld hl, $c320
	add hl, bc
	ld [hl], $18
	call Call_07_7244
	xor a

jr_007_4dd9:
	cp $60
	jr nz, jr_007_4de1

	ld hl, $d202
	inc [hl]

jr_007_4de1:
	cp $a0
	jr nz, jr_007_4df0

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c2e0
	add hl, de
	ld [hl], $a0

jr_007_4df0:
	and $20
	jr z, jr_007_4e06

	ld a, $01
	ldh [$fff1], a
	ldh a, [$ffee]
	sub $0e
	ldh [$ffee], a
	ldh a, [$ffec]
	sub $08
	ldh [$ffec], a
	jr jr_007_4e0f

jr_007_4e06:
	xor a
	ldh [$fff1], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a

jr_007_4e0f:
	ld de, $4d3e
	call Call_3C3B
	call Call_3DBA
	call Call_0891
	ld e, $02
	and $20
	jr z, jr_007_4e22

	inc e

jr_007_4e22:
	ld a, e
	call Call_3B87
	ret


	db $20, $00, $e0, $00, $00, $e0, $00, $20, $00, $02, $01, $03, $16, $28, $28, $28
	db $28, $28, $28, $28, $28, $28, $28, $28, $00, $02, $04, $06

Jump_07_4E43::
	ld a, $01
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_007_4e63

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $0b
	jp z, Call_3B8D

	ld e, a
	ld d, b
	ld hl, $4e32
	add hl, de
	ld e, [hl]
	call Call_0891
	ld [hl], e

jr_007_4e63:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $03
	ld e, a
	ld d, b
	ld hl, $4e27
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4e2b
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $4e2f
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_07_7D55
	ld a, e
	xor $01

jr_007_4e90:
	ldh [$ff9e], a
	call Call_07_7CE2
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4e3f
	add hl, de
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	or [hl]
	jp Call_3B87


Jump_07_4EAA::
	ld a, $01
	ldh [$ffa1], a
	ld hl, $c380
	add hl, bc
	ld a, $01
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld [hl], $e4
	ld hl, $c250
	add hl, bc
	ld [hl], $08
	call Call_07_7CE2
	ldh a, [$ffee]
	cp $c0
	jr c, jr_007_4ed6

	cp $c4
	jp nc, Jump_007_4ed6

	xor a
	ld [$c167], a
	call Call_3B8D

Jump_007_4ed6:
jr_007_4ed6:
	ld a, $01
	jr jr_007_4e90

Jump_07_4EDA::
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	inc [hl]
	ld hl, $c2e0
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld a, [hl]
	add $10
	ld [hl], a
	ld hl, $c310
	add hl, de
	ld [hl], $10
	jp Call_07_7D7C


	db $40, $00, $40, $20, $42, $00, $42, $20

Call_07_4F03::
	ld de, $4efb
	call Call_3C3B
	call Call_07_7C76
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_07_4F1A::
	dw Jump_07_4F26
	dw Jump_07_4F74

	db $08, $f8, $00, $00, $00, $00, $f8, $08

Jump_07_4F26::
	call Call_07_7BD0
	jr nc, jr_007_4f66

	ldh a, [$ffcb]
	and $0f
	jr z, jr_007_4f66

	ld a, $01
	ld [$c144], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $10
	jr nz, jr_007_4f6b

	call Call_3B8D
	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld a, e
	xor $01
	ld e, a
	ld [hl], e

Call_07_4F50::
	ld d, b
	ld hl, $4f1e
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4f22
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ret


jr_007_4f66:
	ld hl, $c3d0
	add hl, bc
	ld [hl], b

jr_007_4f6b:
	ret


	db $10, $f0, $00, $00, $00, $00, $f0, $10

Jump_07_4F74::
	ld a, $01
	ldh [$ffa1], a
	ld a, $3e
	ldh [$fff2], a
	ldh a, [$ffcc]
	and $0f
	ld d, a
	jr z, jr_007_4fa2

	and $03
	jr z, jr_007_4f90

	ld e, $00
	and $01
	jr nz, jr_007_4f8e

	inc e

jr_007_4f8e:
	jr jr_007_4f97

jr_007_4f90:
	ld e, $02
	bit 2, d
	jr nz, jr_007_4f97

	inc e

jr_007_4f97:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor e
	cp $01
	jr z, jr_007_4fa2

	ld [hl], e

jr_007_4fa2:
	call Call_07_7CE2
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $08
	ld hl, $c210
	add hl, bc
	or [hl]
	and $0f
	jp nz, Jump_007_5086

	ld a, [hl]
	sub $10
	ldh [$ffcd], a
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $08
	ldh [$ffce], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffcd]
	and $f0
	or e
	ld e, a
	ld d, b
	ld hl, $d711
	add hl, de
	ld [hl], $0d
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0a
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $12
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $11
	ld [hli], a
	ld a, $13
	ld [hli], a
	ld [hl], b
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	call Call_07_4F50
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4f6c
	add hl, de
	ldh a, [$ffce]
	add [hl]
	swap a
	and $0f
	push af
	ld hl, $4f70
	add hl, de
	pop af
	ld e, a
	ldh a, [$ffcd]
	add [hl]
	and $f0
	or e
	ld e, a
	ld d, b
	ld hl, $d711
	add hl, de
	ld e, [hl]
	ld d, $01
	call Call_29DB
	cp $0b
	jr z, jr_007_5086

	cp $50
	jr z, jr_007_5086

	cp $51
	jr z, jr_007_5086

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $2f
	ldh [$fff2], a
	ld a, $02
	call Call_0953
	ld hl, $c520
	add hl, de
	ld [hl], $0f
	call Call_07_7D7C
	ld a, [$c18e]
	and $0f
	cp $0e
	jr nz, jr_007_5086

	push bc
	ld c, b
	ld hl, $d700

jr_007_506e:
	ld a, [hli]
	push hl
	ld e, a
	ld d, $01
	call Call_29DB
	pop hl
	cp $50
	jr z, jr_007_5085

	cp $51
	jr z, jr_007_5085

	dec c
	jr nz, jr_007_506e

	call Call_08EC

jr_007_5085:
	pop bc

Jump_007_5086:
jr_007_5086:
	ret


	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

Call_07_50C7::
	ldh a, [$ffd7]
	rlca
	and $01
	ld e, a
	ldh a, [$ffd8]
	rlca
	rla
	and $02
	or e
	rla
	rla
	rla
	and $18
	ld h, a
	ldh a, [$ffd8]
	bit 7, a
	jr z, jr_007_50e2

	cpl
	inc a

jr_007_50e2:
	ld d, a
	ldh a, [$ffd7]
	bit 7, a
	jr z, jr_007_50eb

	cpl
	inc a

jr_007_50eb:
	cp d
	jr nc, jr_007_50fb

	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $5087
	add hl, de
	ld a, [hl]
	ret


jr_007_50fb:
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $50a7
	add hl, de
	ld a, [hl]
	ret


Call_07_5109::
	ld hl, $c470
	add hl, bc
	ld [hl], b
	ld hl, $c3f0
	add hl, bc
	ld [hl], b
	ld hl, $c400
	add hl, bc
	ld [hl], b
	call Call_07_5240
	call Call_07_7C76
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_07_5124::
	dw Jump_07_5130
	dw Jump_07_5142
	dw Jump_07_516C
	dw Jump_07_51A7
	dw Jump_07_51B8
	dw Jump_07_51C4

Jump_07_5130::
	ldh a, [$ffee]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ldh a, [$ffef]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ret


Jump_07_5142::
	call Call_0891
	jr nz, jr_007_5167

	ld hl, $c340
	add hl, bc
	set 6, [hl]
	call Call_07_7D35
	add $20
	cp $40
	jr nc, jr_007_5167

	call Call_07_7D45
	add $20
	cp $40
	jr nc, jr_007_5167

	call Call_0891
	ld [hl], $30
	call Call_3B8D

jr_007_5167:
	xor a
	call Call_3B87
	ret


Jump_07_516C::
	call Call_0891
	jr nz, jr_007_5187

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	call Call_3B87
	call Call_0891
	ld [hl], $18
	ld hl, $c340
	add hl, bc
	res 6, [hl]
	jp Call_3B8D


jr_007_5187:
	cp $10
	jr nz, jr_007_51a1

	ld a, $1f
	call Call_3C25
	call Call_07_50C7
	sra a
	add $02
	ld hl, $c2d0
	add hl, bc
	ld [hl], a
	ld a, $18
	call Call_3C25

jr_007_51a1:
	ld a, $01
	call Call_3B87
	ret


Jump_07_51A7::
	call Call_07_7CE2
	call Call_0891
	jr nz, jr_007_51b4

	ld [hl], $20
	call Call_3B8D

jr_007_51b4:
	call Call_3BB4
	ret


Jump_07_51B8::
	call Call_0891
	jr nz, jr_007_51c0

	call Call_3B8D

jr_007_51c0:
	call Call_3BB4
	ret


Jump_07_51C4::
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	call Call_07_7D35
	add $02
	cp $04
	jr nc, jr_007_520b

	call Call_07_7D45
	add $02
	cp $04
	jr nc, jr_007_520b

	ld hl, $c200
	add hl, bc
	ldh a, [$ff98]
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ldh a, [$ff99]
	ld [hl], a
	xor a
	call Call_3B87
	call Call_3B8D
	ld [hl], $01
	call Call_0891
	ld [hl], $20

jr_007_520b:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_07_7CE2
	call Call_3BB4
	ret


	db $ff, $00, $ff, $20, $6c, $00, $6c, $20, $64, $20, $62, $20, $68, $20, $66, $20
	db $60, $00, $60, $20, $66, $00, $68, $00, $62, $00, $64, $00, $66, $40, $68, $40
	db $60, $40, $60, $60, $68, $60, $66, $60

Call_07_5240::
	ld de, $5218
	call Call_3C3B
	ldh a, [$fff0]
	cp $03
	ret c

	ldh a, [$ffee]
	ld hl, $c2b0
	add hl, bc
	sub [hl]
	sra a
	sra a
	ldh [$ffd7], a
	ldh [$ffd9], a
	ldh a, [$ffec]
	ld hl, $c2c0
	add hl, bc
	sub [hl]
	sra a
	sra a
	ldh [$ffd8], a
	ldh [$ffda], a
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	ld a, $03

jr_007_5277:
	ldh [$ffdb], a
	ld hl, $c2c0
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld [de], a
	inc de
	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	add $04
	ld [de], a
	inc de
	ld a, $6a
	ld [de], a
	inc de
	ld a, $00
	ld [de], a
	inc de
	ldh a, [$ffd7]
	ld hl, $ffd9
	add [hl]
	ldh [$ffd7], a
	ldh a, [$ffd8]
	ld hl, $ffda
	add [hl]
	ldh [$ffd8], a
	ldh a, [$ffdb]
	dec a
	jr nz, jr_007_5277

	ld a, $03
	call Call_3DD0
	ret


	db $44, $29, $82, $cb, $64, $c1, $d0, $74, $6a, $36, $5e, $ec, $f5, $9d, $9a, $10
	db $9c, $10, $74, $00, $76, $00

Call_07_52C6::
	ld a, [$dba5]
	and a
	jr nz, jr_007_52e4

	ldh a, [$fff6]
	cp $6b
	jr z, jr_007_52de

	cp $7a
	jr z, jr_007_52de

	cp $8b
	jr z, jr_007_52de

	cp $7b
	jr nz, jr_007_52e4

jr_007_52de:
	ld a, [$d87b]
	and $10
	ret z

jr_007_52e4:
	ldh a, [$fff8]
	and $20
	jp nz, Call_07_7D7C

	ld de, $52c2
	ld a, [$db0e]
	cp $04
	jr z, jr_007_5303

	ldh a, [$fff9]
	and a
	jr z, jr_007_5300

	ldh a, [$ffec]
	add $02
	ldh [$ffec], a

jr_007_5300:
	ld de, $52be

jr_007_5303:
	call Call_3C3B
	call Call_0891
	jr nz, jr_007_5329

	call Call_3BD5
	jr nc, jr_007_5328

	ld a, $10
	ld [$d368], a
	ld [$c167], a
	ldh a, [$ffbf]
	ldh [$ffb0], a
	call Call_0891
	ld a, $68
	ld [hl], a
	ld [$c111], a
	jp Call_093B


jr_007_5328:
	ret


jr_007_5329:
	cp $10
	jr nz, jr_007_5349

	dec [hl]
	ld a, [$db0e]
	ld e, a
	ld d, b
	ld hl, $52af
	add hl, de
	ld a, [hl]
	cp $9d
	jr z, jr_007_5340

	cp $44
	jr nz, jr_007_5345

jr_007_5340:
	call Call_2197
	jr jr_007_5348

jr_007_5345:
	call Call_2185

jr_007_5348:
	xor a

jr_007_5349:
	dec a
	jr nz, jr_007_535c

	xor a
	ld [$db7f], a
	ld [$c167], a
	call Call_07_539C
	or $20
	ld [hl], a
	jp Call_07_7D7C


jr_007_535c:
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ldh a, [$fff6]
	cp $c9
	jr nz, jr_007_536e

	ld a, $04
	ld [$c13b], a

jr_007_536e:
	ld hl, $c13b
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, bc
	sub $10
	ld [hl], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $03
	ldh [$ff9e], a
	xor a
	ld [$c137], a
	ld [$c16a], a
	ld [$c122], a
	ld [$c121], a
	ret


Call_07_539C::
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_007_53b1

	cp $06
	jr c, jr_007_53b1

	inc d

jr_007_53b1:
	add hl, de
	ld a, [hl]
	ret


	db $08, $f8, $00, $00, $00, $00, $f8, $08, $50, $00, $50, $20, $52, $00, $52, $20
	db $50, $40, $50, $60, $52, $40, $52, $60, $54, $00, $56, $00, $58, $00, $5a, $00
	db $56, $20, $54, $20, $5a, $20, $58, $20

Call_07_53DC::
	ld de, $53bc
	call Call_3C3B
	call Call_07_5597
	call Call_07_7C76
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_53fe

	ld hl, $c290
	add hl, bc
	ld a, $01
	ld [hl], a
	ldh [$fff0], a
	call Call_0891
	ld [hl], $40

jr_007_53fe:
	call Call_07_7C98
	call Call_07_7CE2
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_007_5422

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ld hl, $c2c0
	add hl, bc
	ld [hl], b

jr_007_5422:
	call Call_3B9E
	ldh a, [$fff0]
	cp $02
	jp z, Jump_007_550c

	and a
	jr z, jr_007_548f

	call Call_0891
	jr z, jr_007_544c

	cp $0a
	jr nz, jr_007_5446

	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, jr_007_5446

	call Call_07_5542

jr_007_5446:
	call Call_3DAF
	jp Jump_007_54b1


jr_007_544c:
	call Call_27ED
	and $1f
	or $20
	ld [hl], a
	ld hl, $c290
	add hl, bc
	ld [hl], $00
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
	cp $00
	jr nz, jr_007_546c

	call Call_07_7D55
	jr jr_007_546f

jr_007_546c:
	call Call_27ED

jr_007_546f:
	and $03
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $53b4
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $53b8
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	jp Jump_007_54b1


jr_007_548f:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_007_549d

	call Call_0891
	jr nz, jr_007_54ae

jr_007_549d:
	call Call_27ED
	and $0f
	or $10
	ld [hl], a
	ld hl, $c290
	add hl, bc
	ld [hl], $01
	call Call_3DAF

jr_007_54ae:
	call Call_07_7BFA

Jump_007_54b1:
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_5508

	call Call_07_7D35
	add $20
	cp $40
	jr nc, jr_007_5508

	call Call_07_7D45
	add $20
	cp $40
	jr nc, jr_007_5508

	ld a, [$db00]
	cp $01
	jr nz, jr_007_54da

	ldh a, [$ffcc]
	and $20
	jr nz, jr_007_54e7

	jr jr_007_5508

jr_007_54da:
	ld a, [$db01]
	cp $01
	jr nz, jr_007_5508

	ldh a, [$ffcc]
	and $10
	jr z, jr_007_5508

jr_007_54e7:
	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	cp e
	jr z, jr_007_5508

	ld hl, $c320
	add hl, bc
	ld [hl], $18
	ld a, $10
	call Call_3C25
	call Call_3B8D
	ld [hl], $02
	call Call_07_7244
	ret


jr_007_5508:
	call Call_3BB4
	ret


Jump_007_550c:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_07_7BFA
	ldh a, [$ffe8]
	and a
	jr z, jr_007_5531

	call Call_3B8D
	ld [hl], $01
	call Call_0891
	ld [hl], $20

jr_007_5531:
	ret


	db $08, $f8, $00, $00, $00, $00, $f8, $08, $20, $e0, $00, $00, $00, $00, $e0, $20

Call_07_5542::
	ld a, $0a
	call Call_3C01
	jr c, jr_007_5586

	push bc
	ld hl, $c3b0
	add hl, de
	ld [hl], $01
	ldh a, [$ffd9]
	ld hl, $c380
	add hl, de
	ld [hl], a
	ld c, a
	ld hl, $5532
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $5536
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $553a
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $553e
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc
	and a

jr_007_5586:
	ret


	db $00, $fc, $22, $40, $00, $0c, $22, $60, $00, $fc, $22, $00, $00, $0c, $22, $20

Call_07_5597::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $5587
	add hl, de
	ld c, $02
	call Call_3D26
	ret


	db $78, $00, $72, $00, $7a, $00, $72, $00, $70, $00, $72, $00, $7c, $00, $7e, $00
	db $74, $00, $76, $00, $72, $20, $78, $20, $72, $20, $7a, $20, $72, $20, $70, $20
	db $7e, $20, $7c, $20, $76, $20, $74, $20

Call_07_55D5::
	ldh a, [$fff8]
	and $10
	jp nz, Call_07_7D7C

	ld de, $55ad
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_55ea

	ld de, $55c1

jr_007_55ea:
	call Call_3C3B
	ld hl, $c480
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5607

	xor a
	ldh [$fff1], a
	ldh a, [$ffec]
	sub $0e
	ldh [$ffec], a
	ld de, $56e3
	call Call_3C3B
	call Call_3DBA

jr_007_5607:
	call Call_07_7C76
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_007_5624

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_007_5624:
	ldh a, [$fff0]
	rst $00

JumpTable_07_5627::
	dw Jump_07_563B
	dw Jump_07_56AE
	dw Jump_07_56CA
	dw Jump_07_56E7
	dw Jump_07_572D
	dw Jump_07_5826
	dw Jump_07_58A3
	dw Jump_07_58E8
	dw Jump_07_595B
	dw Jump_07_5973

Jump_07_563B::
	ld a, [$db56]
	cp $01
	jr nz, jr_007_5671

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_565c

	call Call_07_7D35
	add $18
	cp $30
	jr nc, jr_007_5670

	call Call_07_7D45
	add $18
	cp $30
	jr nc, jr_007_5670

jr_007_565c:
	call Call_0891
	ld [hl], $10
	call Call_3B8D
	ld [hl], $05
	ld a, $60

Call_07_5668::
	call Call_2185
	ld a, $14
	ld [$c5ab], a

jr_007_5670:
	ret


jr_007_5671:
	call Call_07_7BD0
	call Call_07_7C23
	jr nc, Call_07_568E

	ld a, [$db0e]
	cp $04
	jr nz, jr_007_5689

	ld a, $65
	call Call_07_5668
	call Call_3B8D
	ret


jr_007_5689:
	ld a, $61
	call Call_07_5668

Call_07_568E::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_007_56ad

	call Call_27ED
	and $01
	jr nz, jr_007_56ad

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_007_56ad:
	ret


Jump_07_56AE::
	ld a, [$c19f]
	and a
	jr nz, jr_007_56c9

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_007_56c3

	call Call_0891
	ld [hl], $10
	ret


jr_007_56c3:
	ld [hl], b
	ld a, $61
	call Call_07_5668

jr_007_56c9:
	ret


Jump_07_56CA::
	call Call_0891
	jr nz, jr_007_56de

	ld [hl], $80
	ld hl, $c480
	add hl, bc
	ld [hl], $80
	ld a, $01
	ldh [$fff2], a
	call Call_3B8D

jr_007_56de:
	ld a, $02
	ldh [$ffa1], a
	ret


	db $9a, $10, $9c, $10

Jump_07_56E7::
	ld a, $03
	call Call_3B87
	call Call_0891
	jr nz, jr_007_5700

	ld a, $36
	ld [$d368], a
	ldh [$ffb0], a
	call Call_0887
	ld [hl], $80
	jp Call_3B8D


jr_007_5700:
	cp $10
	jr nz, jr_007_5709

	ld a, $62
	call Call_07_5668

jr_007_5709:
	ld a, $02
	ldh [$ffa1], a
	ret


	db $48, $48, $48, $48, $48, $48, $48, $18, $20, $28, $30, $38, $40, $48, $00, $78
	db $28, $58, $40, $30, $60, $00, $00, $80, $80, $00, $80, $00, $10, $30, $20

Jump_07_572D::
	ld a, $02
	ldh [$ffa1], a
	call Call_07_568E
	call Call_0887
	jr nz, jr_007_575e

	ld a, $02
	ldh [$fff2], a
	ld a, [$d87b]
	or $10
	ld [$d87b], a
	ld a, $01
	ld [$db7f], a
	ld a, $63
	ld [$c168], a
	call Call_07_5668
	call Call_3B8D
	ld [hl], $05
	ld hl, $c3d0
	add hl, bc
	ld [hl], $06
	ret


jr_007_575e:
	cp $01
	jr nz, jr_007_576b

	ld a, $05
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a

jr_007_576b:
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_007_57c0

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $07
	jr z, jr_007_57c0

	ld a, $ad
	call Call_3C01
	jr c, jr_007_57c0

	push bc
	call Call_07_7244
	ld hl, $c2d0
	add hl, bc
	ld c, [hl]
	inc [hl]
	ld hl, $570e
	add hl, bc
	ld a, [hl]
	ld hl, $c2b0
	add hl, de
	ld [hl], a
	ld hl, $5715
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, de
	ld [hl], a
	ld hl, $571c
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $5723
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c290
	add hl, de
	ld [hl], $07
	ld hl, $c300
	add hl, de
	ld [hl], $80
	pop bc

jr_007_57c0:
	call Call_0887
	cp $40
	jr nc, jr_007_5825

	ldh a, [$ffe7]
	and $3f
	jr nz, jr_007_5825

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $03
	jr nc, jr_007_5825

	ld e, a
	ld d, b
	inc [hl]
	ld hl, $572a
	add hl, de
	ld a, [hl]
	ldh [$ffcd], a
	ld a, $40
	ldh [$ffce], a
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0a
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $0c
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $0d
	ld [hli], a
	ld a, $1d
	ld [hli], a
	ld [hl], b
	ld hl, $d725
	ld [hl], $db
	ld hl, $d735
	ld [hl], $db
	ld hl, $d745
	ld [hl], $db

jr_007_5825:
	ret


Jump_07_5826::
	call Call_0891
	jr nz, jr_007_5895

	call Call_3B8D
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, jr_007_585a

	call Call_27ED
	and $0f
	add $10
	ld hl, $c320
	add hl, bc
	ld [hl], a
	ld e, $10
	and $01
	jr z, jr_007_584b

	ld e, $f0

jr_007_584b:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	ld hl, $c250
	add hl, bc
	ld [hl], $f0
	call Call_07_5884
	ret


jr_007_585a:
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$d154]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $c210
	add hl, de
	ld a, [hl]
	ldh [$ff99], a
	ld a, $14
	call Call_3C25
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a

Call_07_5884::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld e, $00
	and $80
	jr z, jr_007_5890

	inc e

jr_007_5890:
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_007_5895:
	call Call_07_568E
	call Call_088C
	jr z, jr_007_58a2

	ld a, $04
	call Call_3B87

jr_007_58a2:
	ret


Jump_07_58A3::
	call Call_07_7CE2
	ldh a, [$ffef]
	cp $08
	jp c, Call_07_7D7C

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_007_58b9

	call Call_3B9E

jr_007_58b9:
	ldh a, [$ffe8]
	and a
	jr z, jr_007_58e2

	call Call_3B8D
	ld [hl], $05
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, jr_007_58d7

	call Call_0891
	ld [hl], $10
	call Call_088C
	ld [hl], $10
	ret


jr_007_58d7:
	call Call_0891
	call Call_27ED
	and $3f
	add $30
	ld [hl], a

jr_007_58e2:
	ld a, $03
	call Call_3B87
	ret


Jump_07_58E8::
	call Call_0891
	jr nz, jr_007_594a

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ldh [$ff99], a
	ld hl, $c300
	add hl, bc
	ld a, [$c168]
	or [hl]
	ld a, $10
	ld e, $10
	jr nz, jr_007_5913

	ld a, $08
	ld e, $08

jr_007_5913:
	push de
	call Call_3C25
	pop de
	ld hl, $c320
	add hl, bc
	ld [hl], e
	ld a, [$c168]
	and a
	jr z, jr_007_593e

	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	cpl
	inc a
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	cpl
	inc a
	ld [hl], a
	ldh a, [$ffef]
	cp $90
	jr c, jr_007_593e

	call Call_07_7D7C

jr_007_593e:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_3B8D
	call Call_07_5884

jr_007_594a:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and $80
	ld a, $02
	jr z, jr_007_5957

	ld a, $04

jr_007_5957:
	call Call_3B87
	ret


Jump_07_595B::
	ldh a, [$ffe8]
	and a
	jr z, jr_007_596a

	call Call_0891
	ld [hl], $08
	call Call_3B8D
	dec [hl]
	dec [hl]

jr_007_596a:
	ld a, $03
	call Call_3B87
	call Call_07_7CE2
	ret


Jump_07_5973::
	ret


	db $6a, $00, $6a, $20, $68, $00, $68, $20

Call_07_597C::
	ld de, $5974
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	call Call_3BB4
	call Call_07_7CE2
	call Call_3B9E
	ld hl, $c470
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_59ad

	ld hl, $c480
	add hl, bc
	ld [hl], $10
	ldh a, [$ffee]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ldh a, [$ffef]
	ld hl, $c210
	add hl, bc
	ld [hl], a

jr_007_59ad:
	xor a
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_07_59B4::
	dw Jump_07_59B8
	dw Jump_07_59FD

Jump_07_59B8::
	call Call_0891
	jr nz, jr_007_59db

	call Call_07_7D45
	ld a, e
	cp $03
	jr z, jr_007_59db

	call Call_3DAF
	call Call_0891
	ld [hl], $25
	call Call_07_7D35
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_3B8D
	ld [hl], $01
	ret


jr_007_59db:
	ld hl, $c250
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
	ld hl, $c240
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


	db $01, $ff

Jump_07_59FD::
	call Call_0891
	jr nz, jr_007_5a09

	ld [hl], $40
	call Call_3B8D
	ld [hl], b
	ret


jr_007_5a09:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_007_5a25

	ld hl, $c250
	add hl, bc
	dec [hl]
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $59fb
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a

jr_007_5a25:
	ld a, $01
	call Call_3B87
	ret


Call_07_5A2B::
	ldh a, [$fff1]
	inc a
	jr z, jr_007_5a7a

	push hl
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	pop hl

jr_007_5a3e:
	ldh a, [$ffec]
	add [hl]
	cp $7e
	jr c, jr_007_5a46

	xor a

jr_007_5a46:
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
	jr nz, jr_007_5a65

	dec de
	xor a
	ld [de], a
	inc de

jr_007_5a65:
	pop bc
	inc de
	ldh a, [$ffed]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_007_5a3e

	ld a, [$c123]
	ld c, a
	ld a, $0a
	call Call_3DD0
	ret


jr_007_5a7a:
	ld a, [$c123]
	ld c, a
	ret


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

Call_07_5B47::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_007_5d28

	and a
	jp nz, Jump_007_5cc8

	ldh a, [$fff8]
	and $20
	jp nz, Call_07_7D7C

	ld a, [$c124]
	and a
	jr nz, jr_007_5b6c

	ld hl, $c3e0
	add hl, bc
	ldh a, [$fff6]
	cp [hl]
	jp nz, Call_07_7D7C

jr_007_5b6c:
	ldh a, [$fff1]
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
	call Call_07_5A2B

jr_007_5b89:
	call Call_08E2
	call Call_3BEB
	call Call_07_7BD0
	ldh a, [$fff0]
	rst $00

JumpTable_07_5B95::
	dw Jump_07_5BA1
	dw Jump_07_5BA2
	dw Jump_07_5BBA
	dw Jump_07_5C3D
	dw Jump_07_5C6B
	dw Jump_07_5C8C

Jump_07_5BA1::
	ret


Jump_07_5BA2::
	call Call_07_5C63
	call Call_0891
	jr nz, Call_07_5BAD

	jp Call_3B8D


Call_07_5BAD::
	ld e, $00
	and $04
	jr z, jr_007_5bb5

	ld e, $02

jr_007_5bb5:
	ld a, e
	ld [$c155], a
	ret


Jump_07_5BBA::
	call Call_07_5C63
	ldh a, [$ffe7]
	call Call_07_5BAD
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_007_5bde

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $05
	jp z, Jump_007_5c1e

	call Call_27ED
	and $03
	jr z, jr_007_5bde

	call Call_07_5CDE

jr_007_5bde:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_007_5c1d

	ld a, $a7
	call Call_3C01
	jr c, jr_007_5c1d

	call Call_27ED
	and $07
	sub $04
	ld hl, $ffd8
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	call Call_27ED
	and $1f
	sub $10
	ld hl, $ffd7
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c2e0
	add hl, de
	ld [hl], $10
	ld hl, $c2b0
	add hl, de
	ld [hl], $01

jr_007_5c1d:
	ret


Jump_007_5c1e:
	ld a, $00
	ld [$c155], a
	ld a, [$db72]
	inc a
	ld [$db72], a
	cp $04
	jr c, jr_007_5c37

	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ret


jr_007_5c37:
	call Call_07_6D97
	jp Call_07_7D7C


Jump_07_5C3D::
	call Call_0891
	jr nz, jr_007_5c57

	ld [hl], $20
	ld a, $08
	ld [$db95], a
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$db96], a
	call Call_3B8D
	ret


jr_007_5c57:
	ld e, $00
	and $04
	jr z, jr_007_5c5f

	ld e, $02

jr_007_5c5f:
	ld a, e
	ld [$c155], a

Call_07_5C63::
	ld a, $02
	ldh [$ffa1], a
	ld [$c111], a
	ret


Jump_07_5C6B::
	xor a
	ld [$c155], a
	call Call_0891
	jr nz, jr_007_5c80

	call Call_07_6D97
	ld hl, $db6b
	set 2, [hl]
	call Call_07_7D7C
	ret


jr_007_5c80:
	call Call_07_5C63
	ret


	db $00, $02, $04, $06, $06, $04, $02, $00

Jump_07_5C8C::
	xor a
	ld [$c156], a
	call Call_0891
	jr nz, jr_007_5c98

	jp Call_07_7D7C


jr_007_5c98:
	push af
	and $07
	ld e, a
	ld d, b
	ld hl, $5c84
	add hl, de
	ld a, [hl]
	ld [$c156], a
	pop af
	cp $20
	jr nc, jr_007_5cb2

	and $03
	jr nz, jr_007_5cb2

	call Call_07_5CDE
	xor a

jr_007_5cb2:
	cp $40
	jr c, jr_007_5cbf

	and $07
	jr nz, jr_007_5cbf

	ld hl, $fff4
	ld [hl], $0c

jr_007_5cbf:
	ret


	db $30, $00, $30, $20, $32, $00, $32, $20

Jump_007_5cc8:
	ld de, $5cc0
	call Call_3C3B
	call Call_0891
	jp z, Call_07_7D7C

	cp $04
	jr nz, jr_007_5cdd

	ld a, $01
	call Call_3B87

jr_007_5cdd:
	ret


Call_07_5CDE::
	ld a, $a7
	call Call_3C01
	jr c, jr_007_5d17

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c340
	add hl, de
	ld [hl], $d1
	ld hl, $c310
	add hl, de
	ld [hl], $70
	call Call_27ED
	and $3f
	sub $20
	ld hl, $ffd7
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	call Call_27ED
	and $3f
	sub $20
	ld hl, $ffd8
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a

jr_007_5d17:
	ret


	db $16, $00, $16, $20, $18, $10, $0c, $08, $0c, $f4, $0c, $f4, $f4, $f4, $0c, $0c

Jump_007_5d28:
	ldh a, [$ffec]
	add $08
	ldh [$ffec], a
	ld de, $5d18
	call Call_3CD0
	call Call_07_7CE2
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_007_5d82

	ld [hl], b
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $04
	jp z, Call_07_7D7C

	ld e, a
	ld d, b
	ld hl, $5d1c
	add hl, de
	ld a, [hl]
	ld hl, $c320
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $5d20
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5d24
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld a, e
	and $01
	call Call_3B87

jr_007_5d82:
	ret


	db $4e, $00, $4e, $20

Call_07_5D87::
	ldh a, [$ffea]
	cp $07
	jr nz, jr_007_5daa

	ld a, [$c11c]
	cp $05
	jr nz, jr_007_5d99

	ld a, $10
	ld [$c5ae], a

jr_007_5d99:
	ldh a, [$fff6]
	ld hl, $c3e0
	add hl, bc
	ld [hl], a
	ld hl, $c220
	add hl, bc
	ld [hl], b
	ld hl, $c230
	add hl, bc
	ld [hl], b

jr_007_5daa:
	ld de, $5d83
	call Call_3C3B
	ld a, [$c124]
	and a
	ret nz

	ldh a, [$fff6]
	ld [$db6f], a
	ldh a, [$ffee]
	ld [$db70], a
	ldh a, [$ffef]
	ld [$db71], a
	ld a, [$c19f]
	and a
	ret nz

	ldh a, [$ffea]
	cp $02
	ret z

	call Call_08E2
	call Call_3BEB
	call Call_07_7CE2
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	and $80
	ldh [$ffe8], a
	jr z, jr_007_5e10

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	cp $07
	jr c, jr_007_5e02

	push af
	ld a, $17
	ldh [$fff4], a
	pop af
	jr jr_007_5e03

jr_007_5e02:
	xor a

jr_007_5e03:
	ld [hl], a
	ld hl, $c240
	add hl, bc
	sra [hl]
	ld hl, $c250
	add hl, bc
	sra [hl]

jr_007_5e10:
	ld hl, $c410
	add hl, bc
	ld [hl], $03
	ld e, $03
	ld a, e
	ldh [$ffed], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	ldh a, [$ffef]
	add e
	ldh [$ffef], a
	call Call_3B9E
	ldh a, [$ffed]
	ld e, a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub e
	ld [hl], a
	ldh a, [$ffef]
	sub e
	ldh [$ffef], a
	ldh a, [$fff0]
	rst $00

JumpTable_07_5E3C::
	dw Jump_07_5E42
	dw Jump_07_5EB5
	dw Jump_07_5EB6

Jump_07_5E42::
	ldh a, [$ffe9]
	dec a
	and $80
	jr z, jr_007_5e5e

	ld hl, $c250
	call Call_07_5E52
	ld hl, $c240

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
	call Call_3BD5
	jr nc, jr_007_5eb4

	ld a, [$c19b]
	and a
	jr nz, jr_007_5eb4

	ld a, [$db00]
	cp $03
	jr nz, jr_007_5e78

	ldh a, [$ffcc]
	and $20
	jr nz, jr_007_5e85

	jr jr_007_5eb4

jr_007_5e78:
	ld a, [$db01]
	cp $03
	jr nz, jr_007_5eb4

	ldh a, [$ffcc]
	and $10
	jr z, jr_007_5eb4

jr_007_5e85:
	ld a, [$c3cf]
	and a
	jr nz, jr_007_5eb4

	inc a
	ld [$c3cf], a
	ldh a, [$ffea]
	cp $07
	jr z, jr_007_5eb4

	call Call_3B8D
	ld [hl], $02
	ld hl, $c280
	add hl, bc
	ld [hl], $07
	ld hl, $c490
	add hl, bc
	ld [hl], b
	ldh a, [$ff9e]
	ld [$c15d], a
	call Call_0891
	ld [hl], $02
	ld hl, $fff3
	ld [hl], $02

jr_007_5eb4:
	ret


Jump_07_5EB5::
	ret


Jump_07_5EB6::
	ldh a, [$ffe8]
	and a
	jr nz, jr_007_5edb

	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5ee6

Call_07_5EC3::
	ld a, $07
	ldh [$fff2], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a
	ld hl, $c250
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
	call Call_3B8D
	ld [hl], b
	ret


jr_007_5ee6:
	call Call_07_7C76
	ld a, $0b
	ld [$c19e], a
	call Call_3BF6
	ld e, $0f
	ld d, b

jr_007_5ef4:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_007_5f0a

	ld hl, $c3a0
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
	call Call_0891
	jr nz, jr_007_5f4f

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $10
	cp $20
	jr nc, jr_007_5f4f

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $18
	cp $28
	jr nc, jr_007_5f4f

	call Call_07_5EC3
	ld a, $25
	ldh [$fff4], a
	ld a, $0b
	ldh [$fff2], a
	call Call_0891
	ld [hl], $10
	ld hl, $c290
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_007_5f4f

	inc [hl]
	ld hl, $c2e0
	add hl, de
	ld [hl], $50

jr_007_5f4f:
	ret


	db $50, $00, $50, $20

Call_07_5F54::
	ld de, $5f50
	call Call_3C3B
	call Call_07_7C76
	call Call_07_6103
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ld e, a
	and a
	jr nz, jr_007_5f7c

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5fcd

	call Call_07_6081
	ld hl, $c2d0
	add hl, de
	ld [hl], $f0
	ld e, $10

jr_007_5f7c:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_007_5f91

	ld hl, $c250
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
	ld hl, $c350
	add hl, bc
	ld [hl], $02
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push hl
	push af
	ld [hl], e
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	push hl
	push af
	call Call_3B9E
	pop af
	pop hl
	ld [hl], a
	pop af
	pop hl
	ld [hl], a
	ld hl, $c350
	add hl, bc
	ld [hl], $30
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_5fcb

	ld hl, $c250
	add hl, bc
	ld [hl], b
	call Call_07_6081
	ld hl, $c250
	add hl, de
	ld [hl], $00

jr_007_5fcb:
	jr jr_007_5fe5

jr_007_5fcd:
	ld hl, $c250
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
	ld hl, $c2d0
	add hl, de
	ld [hl], $00

jr_007_5fe5:
	ldh a, [$ffef]
	and $0f
	cp $00
	jr nz, jr_007_6047

	ldh a, [$ffef]
	sub $10
	ldh [$ffcd], a
	and $f0
	ld e, a
	ldh a, [$ffee]
	sub $08
	ldh [$ffce], a
	swap a
	and $0f
	or e
	ld e, a
	ld d, b
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6047

	and $80
	jr nz, jr_007_6048

	ld hl, $d711
	add hl, de
	ld [hl], $4d
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0a
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $44
	ld [hli], a
	ld a, $54
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
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
	ld hl, $d711
	add hl, de
	ld [hl], $04
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0a
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
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
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	xor $01
	ldh [$ffd7], a
	ld e, b
	ld d, b

jr_007_608c:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_007_60a6

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $a6
	jr nz, jr_007_60a6

	ld hl, $c460
	add hl, de
	ldh a, [$ffd7]
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
	call Call_3D26
	call Call_07_7C76
	call Call_0891
	ld e, a
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $03
	or e
	jr nz, Call_07_6103

	ldh a, [$ffeb]
	cp $a4
	jp z, Jump_007_6160

	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $615c
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $615e
	add hl, de
	cp [hl]
	jr nz, Call_07_6103

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call Call_0891
	ld [hl], $6a

Call_07_6103::
	ld hl, $c2c0
	add hl, bc
	ld [hl], b
	ldh a, [$ffee]
	push af
	call Call_07_7CE2
	pop af
	ld e, a
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub e
	ldh [$ffe8], a
	call Call_3B9E
	call Call_3BD5
	jr nc, jr_007_615b

	ldh a, [$ff9b]
	and $80
	jr nz, jr_007_615b

	call Call_07_7D45
	add $08
	bit 7, a
	jr z, jr_007_615b

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [$ff99], a
	ldh a, [$ff9a]
	push af
	ldh a, [$ffe8]
	ldh [$ff9a], a
	ld hl, $ff98
	add [hl]
	ld [hl], a
	push bc
	call Call_3E49
	pop bc
	pop af
	ldh [$ff9a], a
	ld a, $02
	ldh [$ff9b], a
	ld a, $01
	ld [$c147], a
	ld hl, $c2c0
	add hl, bc
	ld [hl], $10

jr_007_615b:
	ret


	db $01, $ff, $06, $fa

Jump_007_6160:
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $615c
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $615e
	add hl, de
	cp [hl]
	jr nz, jr_007_6185

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call Call_0891
	ld [hl], $6a

jr_007_6185:
	jp Call_07_6103


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20

Call_07_6198::
	call Call_088C
	jr z, jr_007_61a1

	ld a, $04
	ldh [$fff5], a

jr_007_61a1:
	ld hl, $6188
	ld c, $04
	call Call_3D26
	call Call_07_7C76
	call Call_07_6103
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_61f0

	ld e, $04
	ldh a, [$fff6]
	cp $3b
	jr z, jr_007_61cc

	call Call_088C
	ld [hl], $08
	ld a, [$c3cf]
	and a
	jr z, jr_007_61f0

	ld e, $04

jr_007_61cc:
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_007_61de

	inc [hl]
	cp $03
	jr nz, jr_007_61de

	ld a, $11
	ldh [$fff4], a

jr_007_61de:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_007_61ef

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	sub e
	and $80
	jr z, jr_007_61ef

	inc [hl]

jr_007_61ef:
	ret


jr_007_61f0:
	ld hl, $c250
	add hl, bc
	ld [hl], b
	ld hl, $c440
	add hl, bc
	ld [hl], b
	ret


Call_07_61FB::
	ld hl, $c3f0
	add hl, bc
	ld [hl], b
	ld hl, $c400
	add hl, bc
	ld [hl], b
	call Call_07_6331
	call Call_07_7C76
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_621b

	inc [hl]
	ldh a, [$ffef]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a

jr_007_621b:
	call Call_07_7C98
	ldh a, [$fff0]
	rst $00

JumpTable_07_6221::
	dw Jump_07_6229
	dw Jump_07_624D
	dw Jump_07_627A
	dw Jump_07_62A3

Jump_07_6229::
	call Call_0891
	jr nz, jr_007_623c

	ld [hl], $40
	call Call_07_7D35
	add $10
	cp $20
	jr c, jr_007_623c

	call Call_3B8D

jr_007_623c:
	ret


	db $04, $04, $03, $02, $01, $00, $00, $00, $e0, $e0, $e8, $f0, $00, $00, $00, $00

Jump_07_624D::
	call Call_3BB4
	call Call_0891
	jr nz, jr_007_625b

	ld [hl], $80
	call Call_3B8D
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
	call Call_3B87
	ld hl, $6245
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	add [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ret


Jump_07_627A::
	call Call_3BB4
	call Call_0891
	jr nz, jr_007_6287

	ld [hl], $40
	call Call_3B8D

jr_007_6287:
	ld e, $04
	and $10
	jr nz, jr_007_628e

	inc e

jr_007_628e:
	ld a, e
	call Call_3B87
	ret


	db $00, $00, $00, $00, $01, $02, $03, $05, $00, $00, $00, $00, $00, $f0, $e8, $e0

Jump_07_62A3::
	call Call_3BB4
	call Call_0891
	jr nz, jr_007_62b2

	ld [hl], $40
	call Call_3B8D
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
	call Call_3B87
	ld hl, $629b
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	add [hl]
	ld hl, $c210
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
	ldh a, [$fff1]
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
	call Call_3D26
	ret


	db $98, $00, $53, $7f, $98, $20, $53, $7f, $98, $40, $53, $7f, $98, $60, $53, $7f
	db $98, $80, $53, $7f, $98, $a0, $53, $7f, $98, $c0, $53, $7f, $98, $e0, $53, $7f
	db $99, $00, $53, $7f, $99, $20, $53, $7f, $99, $40, $53, $7f, $99, $60, $53, $7f
	db $99, $80, $53, $7f, $99, $a0, $53, $7f, $99, $c0, $53, $7f, $99, $e0, $53, $7f
	db $9a, $00, $53, $7f, $9a, $20, $53, $7f

Jump_007_638d:
	xor a
	ldh [$ff96], a
	ldh [$ff97], a
	ld [$c12f], a
	ld [$c12e], a
	ld hl, $d6fd
	res 5, [hl]
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $09
	jr z, jr_007_63d2

	ld a, [$d600]
	ld e, a
	add $08
	ld [$d600], a
	ld d, b
	push bc
	ld hl, $c3d0
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
	ld hl, $d601
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
	call Call_0891
	ret nz

	ldh a, [$fff7]
	add $50
	call Call_2185
	ld a, $e4
	ld [$db97], a
	jp Call_07_7D7C


	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

Call_07_63F1::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_007_638d

	ld de, $63e5
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	ldh a, [$fff9]
	and a
	jp nz, Jump_007_64ad

	ldh a, [$fff0]
	rst $00

JumpTable_07_640F::
	dw Jump_07_641D
	dw Jump_07_6461
	dw Jump_07_6484

	db $08, $f8, $00, $00, $00, $00, $f8, $08

Jump_07_641D::
	call Call_3BEB
	call Call_07_650E
	call Call_0891
	jr nz, jr_007_645f

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr nz, jr_007_6441

	ld [hl], b
	call Call_07_7D55
	jr jr_007_6447

jr_007_6441:
	call Call_27ED
	and $03
	ld e, a

jr_007_6447:
	ld d, b
	ld hl, $6415
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $6419
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_3B8D

jr_007_645f:
	jr jr_007_6478

Jump_07_6461::
	call Call_3BEB
	call Call_07_650E
	call Call_0891
	jr nz, jr_007_6472

	ld [hl], $20
	call Call_3B8D
	ld [hl], b

jr_007_6472:
	call Call_07_7CE2
	call Call_3B9E

Jump_007_6478:
jr_007_6478:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_07_6484::
	ld hl, $c340
	add hl, bc
	ld [hl], $c2
	call Call_0891
	jr nz, jr_007_64a7

	ld hl, $c4e0
	add hl, bc
	ld [hl], $2d
	ld hl, $c480
	add hl, bc
	ld [hl], $0c
	ld hl, $c280
	add hl, bc
	ld [hl], $01
	ld hl, $c340
	add hl, bc
	ld [hl], $04

jr_007_64a7:
	ld a, $02
	call Call_3B87
	ret


Jump_007_64ad:
	ldh a, [$fff0]
	cp $02
	jr z, Jump_07_6484

	call Call_3BEB
	call Call_07_651A
	ldh a, [$fff0]
	rst $00

JumpTable_07_64BC::
	dw Jump_07_64C0
	dw Jump_07_64D2

Jump_07_64C0::
	call Call_07_7D35
	ld a, $08
	dec e
	jr nz, jr_007_64ca

	ld a, $f8

jr_007_64ca:
	ld hl, $c240
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_07_64D2::
	call Call_07_7CE2
	ld hl, $c250
	add hl, bc
	inc [hl]
	inc [hl]
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_007_64ef

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_007_64ef:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $08
	jr z, jr_007_650a

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	and $f0
	add $03
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], b
	jp Jump_007_6478


jr_007_650a:
	xor a
	jp Call_3B87


Call_07_650E::
	ldh a, [$ffa2]
	and a
	jp z, Call_3BD5

	cp $08
	jp c, Call_3BD5

	ret


Call_07_651A::
	jp Call_3BD5


	db $40, $00, $40, $20, $42, $00, $42, $20

Call_07_6525::
	ld de, $651d
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	call Call_3BB4
	call Call_07_7CE2
	call Call_07_7D1B
	call Call_3B9E
	ld hl, $c350
	add hl, bc
	set 7, [hl]
	ld hl, $c430
	add hl, bc
	set 6, [hl]
	ldh a, [$fff0]
	rst $00

JumpTable_07_654C::
	dw Jump_07_6552
	dw Jump_07_65AD
	dw Jump_07_65F5

Jump_07_6552::
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6563

	ldh a, [$ffe7]
	and $07
	jr nz, jr_007_656f

	dec [hl]
	jr jr_007_656f

jr_007_6563:
	ld hl, $c350
	add hl, bc
	res 7, [hl]
	ld hl, $c430
	add hl, bc
	res 6, [hl]

jr_007_656f:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_007_6593

	ld hl, $c240
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
	ld hl, $c250
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
	call Call_0887
	jr nz, jr_007_659b

	call Call_3B8D

jr_007_659b:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_65aa

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_007_65aa

	dec [hl]

jr_007_65aa:
	jp Call_07_65CB


Jump_07_65AD::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $08
	jr c, jr_007_65c4

	call Call_0887
	call Call_27ED
	and $1f
	add $80
	ld [hl], a
	jp Call_3B8D


jr_007_65c4:
	ldh a, [$ffe7]
	and $0f
	jr nz, Call_07_65CB

	inc [hl]

Call_07_65CB::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c3d0
	add hl, bc
	add [hl]
	ld [hl], a
	rra
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d

Jump_07_65F5::
	call Call_07_65CB
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $10
	jr z, jr_007_6609

	ldh a, [$ffe7]
	and $07
	jr nz, jr_007_6608

	inc [hl]

jr_007_6608:
	ret


jr_007_6609:
	call Call_0887
	jr nz, jr_007_6614

	ld [hl], $60
	call Call_3B8D
	ld [hl], b

jr_007_6614:
	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $18
	jr c, jr_007_665c

	ld [hl], b
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c440
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $65e1
	add hl, de
	ld a, [hl]
	sra a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $65e5
	add hl, de
	ld a, [hl]
	sra a
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	jr nz, jr_007_665c

	call Call_27ED
	and $02
	dec a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

jr_007_665c:
	ret


	db $44, $00, $46, $00, $44, $00, $48, $00, $46, $20, $44, $20, $48, $20, $44, $20

Call_07_666D::
	ld hl, $c380
	add hl, bc
	ldh a, [$fff1]
	add [hl]
	ldh [$fff1], a
	ld de, $665d
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	call Call_3BB4
	call Call_07_7CE2
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_66a1

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $08
	call Call_088C
	ld [hl], $20

jr_007_66a1:
	ldh a, [$fff0]
	rst $00

JumpTable_07_66A4::
	dw Jump_07_66B6
	dw Jump_07_66F8
	dw Jump_07_674B

	db $08, $f8, $00, $00, $00, $00, $f8, $08, $02, $00, $ff, $ff

Jump_07_66B6::
	call Call_0891
	jr nz, jr_007_66f0

	call Call_3B8D
	call Call_0891
	call Call_27ED
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
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $66ae
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $66b2
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, jr_007_66ef

	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_007_66ef:
	ret


jr_007_66f0:
	call Call_3DAF
	call Call_07_6711
	jr jr_007_6706

Jump_07_66F8::
	call Call_0891
	jr nz, jr_007_6703

	ld [hl], $18
	call Call_3B8D
	ld [hl], b

jr_007_6703:
	call Call_07_6711

jr_007_6706:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Call_07_6711::
	call Call_088C
	jr nz, jr_007_673b

	call Call_07_7D35
	add $08
	cp $10
	jr nc, jr_007_673c

	call Call_07_7D45

jr_007_6722:
	call Call_07_66CC
	ld hl, $c240
	add hl, bc
	sla [hl]
	ld hl, $c250
	add hl, bc
	sla [hl]
	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $30

jr_007_673b:
	ret


jr_007_673c:
	call Call_07_7D45
	add $08
	cp $10
	jr nc, jr_007_674a

	call Call_07_7D35
	jr jr_007_6722

jr_007_674a:
	ret


Jump_07_674B::
	call Call_0891
	jr nz, jr_007_675b

	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	call Call_088C
	ld [hl], $40

jr_007_675b:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
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
	call Call_07_7C76
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ldh a, [$fff0]
	rst $00

JumpTable_07_6862::
	dw Jump_07_686A
	dw Jump_07_6875
	dw Jump_07_6881
	dw Jump_07_688D

Jump_07_686A::
	call Call_07_4000
	call Call_0891
	ld [hl], $28
	jp Call_3B8D


Jump_07_6875::
	call Call_0891
	ret nz

	ld a, $4c
	ld [$d368], a
	jp Call_3B8D


Jump_07_6881::
	ld a, $1d
	ldh [$fff4], a
	call Call_0891
	ld [hl], $80
	jp Call_3B8D


Jump_07_688D::
	ldh a, [$ffe7]
	ld e, $00
	and $08
	jr z, jr_007_6897

	ld e, $02

jr_007_6897:
	ld a, e
	ld [$c155], a
	call Call_0891
	ret nz

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld e, a
	inc a
	ld [hl], a
	ldh [$ffe8], a
	ld a, e
	and $1f
	jp nz, Jump_007_68bb

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $0a
	jp z, Jump_007_6940

	inc a
	ld [hl], a

Jump_007_68bb:
	ld hl, $c3d0
	add hl, bc
	push hl
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $684a
	add hl, de
	ld a, [hl]
	ldh [$ffcd], a
	ld a, $20
	ldh [$ffce], a
	call Call_2839
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
	ldh a, [$ffe8]
	and $01
	jr z, jr_007_68eb

	ld hl, $67c9

jr_007_68eb:
	add hl, de
	push hl
	ld a, [$d600]
	ld e, a
	ld d, b
	add $0d
	ld [$d600], a
	ld hl, $d601
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
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
	ld hl, $c3d0
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
	ld hl, $d711
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
	ld [$c155], a
	ld [$c167], a
	call Call_27BD
	jp Call_07_7D7C


Call_07_694D::
	ld hl, $c440
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
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_007_7d82

	call Call_07_7C76
	call Call_380E
	call Call_3F12
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, jr_007_6995

	ldh a, [$fff0]
	cp $09
	jr nc, jr_007_6990

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_3B8D
	ld a, $09
	ld [hl], a
	ldh [$fff0], a
	jr jr_007_6995

jr_007_6990:
	ld hl, $c3d0
	add hl, bc
	inc [hl]

jr_007_6995:
	call Call_07_7C98
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_007_69b2

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_007_69b2:
	ldh a, [$fff0]
	cp $09
	jr nc, jr_007_69cc

	call Call_3BE0
	ld hl, $c410
	add hl, bc
	ld a, [$c13e]
	or [hl]
	and a
	jr nz, jr_007_69cc

	call Call_3BD5
	call Call_3BEB

jr_007_69cc:
	ldh a, [$fff0]
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
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_0891
	jr nz, jr_007_6a00

	ld [hl], $30
	call Call_3B8D
	ld hl, $c310
	add hl, bc
	ld [hl], $6f

jr_007_6a00:
	ret


Jump_07_6A01::
	call Call_0891
	jr z, jr_007_6a14

	cp $01
	jr nz, jr_007_6a0e

	ld a, $08
	ldh [$fff2], a

jr_007_6a0e:
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ret


jr_007_6a14:
	ldh a, [$ffe8]
	and a
	jr z, Call_07_6A21

	call Call_0891
	ld [hl], $40
	call Call_3B8D

Call_07_6A21::
	ret


Jump_07_6A22::
	call Call_0891
	cp $01
	jr nz, jr_007_6a3f

	ld e, $12
	ldh a, [$fff6]
	cp $92
	jr z, jr_007_6a3b

	cp $84
	jr z, jr_007_6a3b

	cp $80
	jr nz, jr_007_6a3f

	ld e, $14

jr_007_6a3b:
	ld a, e
	call Call_2185

jr_007_6a3f:
	call Call_0891
	jr nz, jr_007_6a51

	ld [hl], $a0
	ldh a, [$fff6]
	cp $95
	jr z, jr_007_6a4e

	ld [hl], $20

jr_007_6a4e:
	jp Call_3B8D


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
	call Call_0891
	jr nz, jr_007_6a7e

	ld [hl], $20
	jp Call_3B8D


jr_007_6a7e:
	and $3f
	jr nz, jr_007_6a82

jr_007_6a82:
	call Call_0891
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
	call Call_0891
	jr nz, jr_007_6b02

	call Call_27ED
	and $1f
	add $30
	ld [hl], a
	ld a, $08
	call Call_3C25
	call Call_3B8D

Call_07_6AEC::
	call Call_07_7D35
	ld hl, $c380
	add hl, bc
	ld [hl], e

Call_07_6AF4::
	call Call_07_6A89
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_6b02

	call Call_07_6AAF

jr_007_6b02:
	ret


Jump_07_6B03::
	call Call_07_6DB1
	call Call_07_7D35
	add $20
	cp $40
	jr nc, jr_007_6b23

	call Call_07_7D45
	add $1c
	cp $38
	jr nc, jr_007_6b23

	call Call_3B8D
	ld [hl], $06
	call Call_0891
	ld [hl], $30
	ret


jr_007_6b23:
	call Call_0891
	jr nz, jr_007_6b36

	call Call_27ED
	and $0f
	add $10
	ld [hl], a
	call Call_3B8D
	ld [hl], $04
	ret


jr_007_6b36:
	and $0f
	jr nz, Call_07_6B42

	ld a, [$d209]
	xor $01
	ld [$d209], a

Call_07_6B42::
	call Call_07_7CE2
	call Call_3B9E
	ret


Jump_07_6B49::
	call Call_0891
	jr nz, jr_007_6b65

Call_07_6B4E::
	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld [hl], $04
	ld hl, $c350
	add hl, bc
	set 7, [hl]
	ld hl, $c430
	add hl, bc
	res 6, [hl]
	ret


jr_007_6b65:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_6bc8

	call Call_0891
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
	ldh [$fff4], a
	ld hl, $c300
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
	call Call_0891
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
	ldh [$fff4], a
	ld hl, $c300
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
	call Call_0891
	jr nz, Call_07_6C57

	call Call_3B8D
	call Call_07_7244
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c320
	add hl, bc
	ld [hl], $30
	and a
	jr nz, jr_007_6c4b

	ld [hl], $28
	ld a, $18
	jp Call_3C25


jr_007_6c4b:
	ld a, $08
	call Call_3C25
	ld hl, $c250
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
	call Call_0891
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
	ldh a, [$ffe8]
	and a
	jr z, jr_007_6c92

	call Call_0891
	ld [hl], $10
	call Call_07_6A21

jr_007_6c92:
	ret


Jump_07_6C93::
	ldh a, [$ffe8]
	and a
	jr z, jr_007_6cb0

	call Call_3B8D
	call Call_0891
	ld [hl], $20
	ld hl, $c350
	add hl, bc
	res 7, [hl]
	ld hl, $c430
	add hl, bc
	set 6, [hl]
	ld a, $28
	ldh [$fff2], a

jr_007_6cb0:
	call Call_07_6B42
	ret


Jump_07_6CB4::
	call Call_0891
	jr nz, jr_007_6cbf

	ld [hl], $c0
	call Call_3B8D
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
	call Call_0891
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
	call Call_0891
	jr nz, jr_007_6cfa

	ld [hl], $30
	call Call_3B8D
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
	call Call_0891
	jr nz, jr_007_6d4c

	ld e, $ff
	ldh a, [$fff6]
	cp $80
	jr z, jr_007_6d2d

	ld e, $03
	cp $95
	jr z, jr_007_6d2d

	ld e, $02

jr_007_6d2d:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp e
	jr c, jr_007_6d49

	ld hl, $c350
	add hl, bc
	set 7, [hl]
	call Call_3B8D
	ld a, $13
	call Call_2185
	call Call_0891
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
	call Call_0891
	jr z, jr_007_6d82

	dec a
	jr nz, jr_007_6d7e

	ld a, $3f
	ldh [$fff4], a

jr_007_6d7e:
	call Call_07_6C57
	ret


jr_007_6d82:
	ld hl, $c320
	add hl, bc
	ld [hl], $30
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $78
	jr c, jr_007_6db0

	call Call_27BD
	call Call_07_7D7C

Call_07_6D97::
	ld hl, $d900
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ldh a, [$fff7]
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
	ldh [$fff8], a

jr_007_6db0:
	ret


Call_07_6DB1::
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	call Call_07_7D35
	add $30
	cp $60
	jr nc, jr_007_6dd3

	call Call_07_7D45
	add $30
	cp $60
	jr nc, jr_007_6dd3

	ld a, e
	cp $02
	jr nz, jr_007_6de0

	ld hl, $c2b0
	add hl, bc
	ld [hl], $01

jr_007_6dd3:
	call Call_3B8D
	ld [hl], $07
	call Call_0891
	ld [hl], $20
	call Call_07_6AEC

jr_007_6de0:
	ret


Call_07_6DE1::
	ld hl, $c310
	add hl, bc
	ld [hl], $7f
	call Call_0891
	ld [hl], $80
	ldh a, [$ffb0]
	ld hl, $c390
	add hl, bc
	ld [hl], a
	ld hl, $c360
	add hl, bc
	ld [hl], $ff
	ldh a, [$fff6]
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
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_007_6f27

	call Call_07_6EF8
	call Call_07_6F28
	call Call_07_6F4F
	call Call_07_6F84
	call Call_07_6FA5
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6ef5

	ldh a, [$ffef]
	sub $02
	ldh [$ffec], a
	ld hl, $6eb2
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0

jr_007_6ef5:
	jp Call_3DBA


Call_07_6EF8::
	ld a, [$d20c]
	ld hl, $ffee
	add [hl]
	ld [hl], a
	ld a, [$d20d]
	ld hl, $ffec
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
	call Call_3D26
	ld a, $02
	jp Jump_007_6f48


jr_007_6f24:
	call Call_3DBA

jr_007_6f27:
	ret


Call_07_6F28::
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_6f4e

	call Call_07_6FCC
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	ld hl, $6e8a
	and a
	jr z, jr_007_6f41

	ld hl, $6e9e

jr_007_6f41:
	ld c, $05
	call Call_3D26
	ld a, $05

Jump_007_6f48:
	call Call_3DD0
	call Call_3DBA

jr_007_6f4e:
	ret


Call_07_6F4F::
	ld a, [$d20a]
	ld hl, $ffee
	add [hl]
	ld [hl], a
	ld a, [$d20a]
	add $0c
	ld [$d5c0], a
	ld a, [$d20b]
	ld hl, $ffec
	add [hl]
	ld [hl], a
	ld a, [$d20b]
	add $08
	ld [$d5c2], a
	ld a, $08
	ld [$d5c1], a
	ld a, $06
	ld [$d5c3], a
	ld de, $6e26
	call Call_3C3B
	ld a, $02
	jp Jump_007_6f48


Call_07_6F84::
	ld a, [$d20e]
	ld hl, $ffec
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
	call Call_3D26
	ld a, $04
	jp Jump_007_6f48


Call_07_6FA5::
	ld a, [$d20e]
	cp $00
	ret z

	ld a, [$d20f]
	ld hl, $ffec
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
	call Call_3D26
	ld a, $04
	jp Jump_007_6f48


Call_07_6FCC::
	ld hl, $c146
	ld a, [$dbc7]
	or [hl]
	jr nz, jr_007_7026

	ldh a, [$ffec]
	add $18
	ld e, a
	ldh a, [$ff99]
	ld hl, $ffa2
	sub [hl]
	add $08
	sub e
	add $0c
	cp $18
	jr nc, jr_007_7026

	ld hl, $c380
	add hl, bc
	ld e, $08
	ld a, [hl]
	and a
	jr z, jr_007_6ff5

	ld e, $f8

jr_007_6ff5:
	ldh a, [$ffee]
	add e
	ld hl, $ff98
	sub [hl]
	add $1a
	cp $34
	jr nc, jr_007_7026

	ld a, $28
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a
	ld a, $02
	ld [$c146], a
	ld a, $13
	ldh [$ffa3], a
	ld a, $08
	ld [$db94], a
	ld a, $20
	ld [$dbc7], a
	ld a, $03
	ldh [$fff3], a

jr_007_7026:
	ret


	db $12, $14, $16, $18, $19, $1a, $1a, $1a, $1a, $1a

Call_07_7031::
	call Call_07_7C76
	call Call_07_7D35
	add $20
	cp $40
	jr nc, jr_007_7046

	call Call_07_7D45
	add $20
	cp $40
	jr c, jr_007_70ac

jr_007_7046:
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $7f
	ret nz

	ld e, $0f
	ld d, b

jr_007_7053:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $82
	jr z, jr_007_7076

	cp $9e
	jr z, jr_007_7076

	cp $7d
	jr z, jr_007_7076

	ld hl, $c340
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_007_7076

	ld hl, $c280
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
	ld a, [$c18f]
	and a
	ret nz

	ld a, $7d
	call Call_3C01
	jr c, jr_007_70ac

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	push bc
	push de
	pop bc
	ldh a, [$fff7]
	ld e, a
	ld a, $14
	cp $0a
	jr nc, jr_007_70a8

	ld hl, $7027
	add hl, de
	ld a, [hl]

jr_007_70a8:
	call Call_3C25
	pop bc

jr_007_70ac:
	ret


Call_07_70AD::
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	cp $00
	jr nz, jr_007_70c9

	ldh a, [$fff8]
	and $10
	jp nz, Call_07_7D7C

	ld hl, $c460
	add hl, bc
	ld [hl], $ff
	ld hl, $c4e0
	add hl, bc
	ld [hl], $3c

jr_007_70c9:
	call Call_07_7C76
	ld hl, $c3b0
	add hl, bc
	ld [hl], b
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7149

	ld a, $14
	call Call_3C01
	jr c, jr_007_7149

	ld hl, $c4e0
	add hl, bc
	ld a, [hl]
	ld hl, $c4e0
	add hl, de
	ld [hl], a
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	add $08
	ld [hl], a
	call Call_3E64
	ldh a, [$ffee]
	sub $08
	ldh [$ffce], a
	ldh a, [$ffef]
	sub $10
	ldh [$ffcd], a
	ldh a, [$ffce]
	swap a
	and $0f
	ld e, a
	ldh a, [$ffcd]
	and $f0
	or e
	ld e, a
	ld d, b
	ld hl, $d711
	add hl, de
	ld [hl], $91
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0a
	ld [$d600], a
	ld e, $08
	call Call_07_7136
	ld e, $09

Call_07_7136::
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	inc a
	ldh [$ffd0], a
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
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	call Call_3BB4
	call Call_07_7CE2
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_007_7183

	ld a, [hl]
	and $0c
	jr nz, jr_007_718d

	jr jr_007_7195

jr_007_7183:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_007_7195

jr_007_718d:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_007_7195:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	call Call_3B87
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $54, $00, $54, $20, $52, $00, $52, $20
	db $56, $00, $56, $00

Call_07_71B4::
	ldh a, [$fff1]
	cp $01
	jr nz, jr_007_71c2

	ld de, $71b0
	call Call_3CD0
	jr jr_007_71c8

jr_007_71c2:
	ld de, $71a0
	call Call_3C3B

jr_007_71c8:
	call Call_07_7C76
	call Call_07_7C98
	call Call_07_7D1B
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_007_71e8

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_007_71e8:
	ldh a, [$fff0]
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
	call Call_0891
	jr nz, jr_007_7224

	call Call_07_7D35
	add $20
	cp $40
	jr nc, jr_007_7224

	call Call_07_7D45
	add $20
	cp $40
	jr nc, jr_007_7224

	call Call_3B8D
	call Call_0891
	ld [hl], $20
	call Call_27ED
	and $03
	add $03
	ld hl, $c2b0
	add hl, bc
	ld [hl], a

jr_007_7224:
	ret


Jump_07_7225::
	call Call_0891
	jr nz, jr_007_7249

	ld hl, $c310
	add hl, bc
	ld [hl], $08
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ld hl, $c340
	add hl, bc
	ld [hl], $12
	ld a, $03
	call Call_3B87
	call Call_3B8D

Call_07_7244::
	ld a, $24
	ldh [$fff2], a
	ret


jr_007_7249:
	ld e, $01
	cp $10
	jr nc, jr_007_7251

	ld e, $02

jr_007_7251:
	ld a, e
	call Call_3B87
	ret


Jump_07_7256::
	ldh a, [$ffe8]
	and a
	jr z, jr_007_7263

	call Call_0891
	ld [hl], $20
	call Call_3B8D

jr_007_7263:
	ret


Jump_07_7264::
	call Call_3BEB
	call Call_0891
	jr nz, jr_007_7275

	ld [hl], $10
	call Call_3DAF
	call Call_3B8D
	ret


jr_007_7275:
	ld e, $08
	and $04
	jr z, jr_007_727d

	ld e, $f8

jr_007_727d:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	call Call_07_7CEF
	ret


Jump_07_7286::
	call Call_3BB4
	call Call_07_7CE2
	call Call_07_7305
	call Call_0891
	jr nz, jr_007_72a5

	ld a, $0c
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	call Call_07_7244
	call Call_3B8D

jr_007_72a5:
	ld a, $03
	call Call_3B87
	ret


Jump_07_72AB::
	call Call_3BB4
	call Call_07_7CE2
	call Call_07_7305
	ldh a, [$ffe8]
	and a
	jr z, jr_007_72dd

	call Call_3DAF
	call Call_3B8D
	ld [hl], $04
	call Call_0891
	ld [hl], $20
	ld hl, $c2b0
	add hl, bc
	dec [hl]
	jr nz, jr_007_72dd

	call Call_3B8D
	ld [hl], $06
	call Call_0891
	ld [hl], $30
	ld hl, $c340
	add hl, bc
	ld [hl], $d2

jr_007_72dd:
	ld a, $02
	call Call_3B87
	ret


Jump_07_72E3::
	call Call_0891
	jr nz, jr_007_72f3

	ld [hl], $50
	call Call_3B8D
	ld [hl], b
	xor a
	call Call_3B87
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
	call Call_3B87
	ret


Call_07_7305::
	ld hl, $c410
	add hl, bc
	ld [hl], $03
	call Call_3B9E
	ld hl, $c410
	add hl, bc
	ld [hl], b
	ret


Call_07_7314::
	call Call_07_7C76
	ldh a, [$fff0]
	rst $00

JumpTable_07_731A::
	dw Jump_07_731E
	dw Jump_07_73B7

Jump_07_731E::
	ldh a, [$ffee]
	and $70
	ld [$d201], a
	call Call_0891
	ld [hl], $80
	call Call_3B8D
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
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $10
	jp z, Call_07_7D7C

	call Call_0891
	jr nz, jr_007_743b

	push hl
	ldh a, [$fff7]
	ld e, a
	ld d, b
	ld hl, $73ae
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ld a, $5a
	call Call_3C01
	jr c, jr_007_743b

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ld a, [$d201]
	ld hl, $c3d0
	add hl, bc
	add [hl]
	inc [hl]
	ld c, a
	ld hl, $c440
	add hl, de
	ldh a, [$ffef]
	sub $10
	and $f0
	jr z, jr_007_73f7

	ld [hl], a

jr_007_73f7:
	ld a, c
	cp $0f
	jr nz, jr_007_7407

	ld a, [$c18e]
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
	ld hl, $c200
	add hl, de
	ld [hl], a
	pop af
	and $f0
	add $10
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c350
	add hl, de
	ld [hl], $00
	ld hl, $c430
	add hl, de
	ld [hl], $00
	ld hl, $c4d0
	add hl, de
	ld [hl], $00
	pop bc

jr_007_743b:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20

Call_07_7444::
	ld de, $743c
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7C98
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_07_7CE2
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, jr_007_7479

	call Call_0891
	ld [hl], $10
	call Call_3DAF
	call Call_3B8D
	xor a
	ld [hl], a
	ldh [$fff0], a

jr_007_7479:
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_07_747F::
	dw Jump_07_7485
	dw Jump_07_74A6
	dw Jump_07_74C7

Jump_07_7485::
	call Call_0891
	jr nz, jr_007_74a5

	ld [hl], $20
	call Call_3B8D
	call Call_27ED
	and $02
	dec a
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $02
	dec a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

jr_007_74a5:
	ret


Jump_07_74A6::
	call Call_0891
	jp z, Call_3B8D

	and $01
	jr nz, jr_007_74c6

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a

jr_007_74c6:
	ret


Jump_07_74C7::
	ldh a, [$ffe7]
	and $01
	jr nz, jr_007_74ee

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_74df

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $10
	ret


jr_007_74df:
	call Call_07_74E7
	ld hl, $c250
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
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_750f

	ld a, c
	ld [$d201], a

jr_007_750f:
	ld de, $74ef
	call Call_3C3B
	call Call_07_7C76
	call Call_07_7CE2
	call Call_07_7D1B
	call Call_3B9E
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	ldh [$ffe8], a
	dec a
	and $80
	jr z, jr_007_7544

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	sra a
	cpl
	cp $07
	jr nc, jr_007_7543

	xor a

jr_007_7543:
	ld [hl], a

jr_007_7544:
	ldh a, [$fff0]
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
	call Call_0891
	jr nz, jr_007_7584

	call Call_3DAF
	call Call_3B8D
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $7565
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


jr_007_7584:
	and $07
	jr nz, jr_007_7591

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

jr_007_7591:
	ldh a, [$ffe8]
	dec a
	and $80
	jr z, jr_007_75d6

	call Call_07_75FB
	ldh a, [$ffe9]
	sub $fc
	and $80
	jr nz, jr_007_75a9

	ldh a, [$ffe7]
	and $07
	jr nz, jr_007_75d6

jr_007_75a9:
	call Call_27ED
	and $01
	ld e, $01
	jr z, jr_007_75b4

	ld e, $ff

jr_007_75b4:
	ld hl, $c380
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
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $755d
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_07_75FB

jr_007_75d6:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7601

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
	call Call_0891
	srl [hl]
	ld hl, $c240
	call Call_07_75F4
	ld hl, $c250

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
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_763a

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_007_763a

	inc [hl]
	call Call_3B8D
	ldh a, [$fff1]
	cp $00
	jr nz, jr_007_762c

	ld hl, $c3b0
	add hl, de
	ld a, [hl]
	cp $00
	jp z, Call_08EC

jr_007_762c:
	ld hl, $c2e0
	add hl, de
	ld [hl], $40
	call Call_0891
	ld [hl], $40
	jp Call_08AC


jr_007_763a:
	ret


Jump_07_763B::
	call Call_0891
	cp $01
	jr nz, jr_007_7647

	ld a, $01
	call Call_3B87

jr_007_7647:
	call Call_07_764B
	ret


Call_07_764B::
	call Call_3BD5
	jr nc, jr_007_769b

	ld a, [$c19b]
	and a
	jr nz, jr_007_769b

	ld a, [$db00]
	cp $03
	jr nz, jr_007_7665

	ldh a, [$ffcc]
	and $20
	jr nz, jr_007_7672

	jr jr_007_769b

jr_007_7665:
	ld a, [$db01]
	cp $03
	jr nz, jr_007_769b

	ldh a, [$ffcc]
	and $10
	jr z, jr_007_769b

jr_007_7672:
	ld a, [$c3cf]
	and a
	jr nz, jr_007_769b

	inc a
	ld [$c3cf], a
	call Call_3B8D
	ld [hl], $02
	ld hl, $c280
	add hl, bc
	ld [hl], $07
	ld hl, $c490
	add hl, bc
	ld [hl], b
	ldh a, [$ff9e]
	ld [$c15d], a
	call Call_0891
	ld [hl], $02
	ld hl, $fff3
	ld [hl], $02

jr_007_769b:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20
	db $60, $00, $60, $20, $62, $00, $62, $20, $64, $00, $64, $20, $66, $00, $66, $20

Call_07_76BC::
	ld de, $769c
	ldh a, [$fff7]
	cp $03
	jr nz, jr_007_76c8

	ld de, $76ac

jr_007_76c8:
	call Call_3C3B
	call Call_07_7C76
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_76d9

	call Call_3DAF

jr_007_76d9:
	call Call_07_7C98
	call Call_3BB4
	call Call_07_7CE2
	call Call_07_7D1B
	call Call_3B9E
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_007_76fa

	and a
	jr nz, jr_007_7727

jr_007_76fa:
	ld [hl], b
	ldh a, [$fff0]
	cp $03
	jr nz, jr_007_7722

	ld hl, $c240
	add hl, bc
	sra [hl]
	ld hl, $c250
	add hl, bc
	sra [hl]
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_007_7720

	ld [hl], b
	call Call_3DAF
	jr jr_007_7727

jr_007_7720:
	jr jr_007_7727

jr_007_7722:
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_007_7727:
	ldh a, [$fff0]
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
	call Call_3DAF
	call Call_0891
	jr nz, jr_007_7779

	call Call_27ED
	and $1f
	add $30
	ld [hl], a
	call Call_3B8D
	call Call_27ED
	and $06
	jr nz, jr_007_775e

	call Call_07_7D55
	jr jr_007_7764

jr_007_775e:
	call Call_27ED
	and $03
	ld e, a

jr_007_7764:
	ld d, b
	ld hl, $7737
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $773b
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_007_7779:
	jr jr_007_7789

Jump_07_777B::
	call Call_0891
	jr nz, jr_007_7786

	ld [hl], $18
	call Call_3B8D
	ld [hl], b

jr_007_7786:
	call Call_07_77FD

jr_007_7789:
	ld hl, $c350
	add hl, bc
	ld [hl], $80
	ld hl, $c430
	add hl, bc
	ld [hl], $48
	call Call_07_7D35
	add $06
	cp $0a
	jr c, jr_007_77a7

	call Call_07_7D45
	add $06
	cp $0a
	jr nc, jr_007_77b7

jr_007_77a7:
	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_3B8D
	call Call_0891
	ld [hl], $ff

jr_007_77b7:
	ret


	db $18, $e8, $00, $00, $00, $00, $e8, $18

Jump_07_77C0::
	call Call_0891
	jr z, jr_007_77f9

	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $77b8
	add hl, de
	ld a, [hl]
	ld hl, $c240
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
	ld hl, $c250
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
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, Call_07_77FD

jr_007_77f9:
	call Call_3B8D
	ld [hl], b

Call_07_77FD::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_07_7809::
	ld hl, $c430
	add hl, bc
	ld [hl], $08
	ld hl, $c350
	add hl, bc
	ld [hl], $00
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	inc a
	inc a
	call Call_3B87
	call Call_0891
	jr nz, jr_007_7837

	call Call_3B8D
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	ld hl, $c240
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
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_007_7848:
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	call Call_3B9E
	pop af
	ld hl, $c410
	add hl, bc
	ld [hl], a
	ret


	db $06, $04, $02, $00

Call_07_785E::
	ldh a, [$fff7]
	cp $15
	jr nz, jr_007_786c

	ld a, [$db56]
	cp $80
	jp nz, Call_07_7D7C

jr_007_786c:
	call Call_07_79D5
	call Call_07_7C76
	ldh a, [$fff7]
	cp $15
	jr z, jr_007_7880

	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7883

jr_007_7880:
	call Call_07_7975

jr_007_7883:
	call Call_07_7C98
	call Call_3BE0
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_07_788F::
	dw Jump_07_789D
	dw Jump_07_78D2
	dw Jump_07_78F5

	db $06, $fa, $00, $00, $00, $00, $fa, $06

Jump_07_789D::
	call Call_3B9E
	ld hl, $c3d0
	add hl, bc
	ld [hl], $00
	call Call_07_794D
	call Call_0891
	jr nz, jr_007_78d1

	ld [hl], $80
	call Call_3B8D

Call_07_78B3::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7895
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7899
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_007_78d1:
	ret


Jump_07_78D2::
	call Call_07_794D
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_78e0

	call Call_07_78B3

jr_007_78e0:
	call Call_07_7CE2
	call Call_3B9E
	call Call_07_7BFA
	call Call_0891
	jr nz, jr_007_78f4

	ld [hl], $30

Call_07_78F0::
	call Call_3B8D
	ld [hl], b

jr_007_78f4:
	ret


Jump_07_78F5::
	call Call_088C
	jr z, jr_007_7917

	ld a, [$c16b]
	cp $04
	jr nz, jr_007_7917

	ldh a, [$fff7]
	cp $15
	jr nz, jr_007_7917

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_007_793d

	inc [hl]
	ld a, $90
	call Call_2185
	jr jr_007_793d

jr_007_7917:
	ld a, [hl]
	and a
	jr nz, jr_007_793d

	call Call_0891
	jr nz, jr_007_7925

	ld [hl], $18
	call Call_07_78F0

jr_007_7925:
	call Call_07_7BFA
	call Call_07_7BFA
	call Call_07_7CE2
	call Call_3B9E
	ldh a, [$ffe7]
	xor c
	and $0f
	jr nz, jr_007_7948

	ld a, $0a
	call Call_3C25

jr_007_793d:
	call Call_07_7D55
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_07_7BFA

jr_007_7948:
	ret


	db $01, $00, $03, $02

Call_07_794D::
	ld a, [$c502]
	and a
	jr nz, Call_07_7975

	call Call_07_7D35
	add $30
	cp $60
	jr nc, jr_007_798c

	call Call_07_7D45
	add $30
	cp $60
	jr nc, jr_007_798c

	call Call_07_7D55
	ld d, b
	ld hl, $7949
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	cp [hl]
	jr z, jr_007_798c

Call_07_7975::
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	cp $02
	jr z, jr_007_7985

	push hl
	call Call_088C
	ld [hl], $10
	pop hl

jr_007_7985:
	ld [hl], $02
	call Call_0891
	ld [hl], $80

jr_007_798c:
	ret


	db $00, $00, $f9, $f9, $f8, $f2, $08, $0e, $08, $0e, $f8, $f2, $00, $00, $00, $00
	db $02, $02, $06, $06, $04, $04, $00, $00, $0c, $0c, $04, $04, $fc, $fc, $14, $14
	db $14, $14, $fc, $fc, $0c, $0c, $0c, $0c, $60, $00, $62, $00, $62, $20, $60, $20
	db $64, $00, $66, $00, $66, $20, $64, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_07_79D5::
	call Call_3D87
	ldh a, [$fff1]
	cp $02
	jr nc, jr_007_79e1

	call Call_07_7A39

jr_007_79e1:
	push bc
	ldh a, [$ffec]
	ldh [$ffd7], a
	ldh a, [$ffee]
	ldh [$ffd8], a
	ldh a, [$fff1]
	ld e, a
	ld d, b
	ld hl, $79a5
	add hl, de
	ld a, [hl]
	ld [$d5c0], a
	ld hl, $79ad
	add hl, de
	ld a, [hl]
	ld [$d5c2], a
	ld a, $02
	ld [$d5c1], a
	ld [$d5c3], a
	ld hl, $799d
	add hl, de
	ld a, [hl]
	ldh [$ffd9], a
	ld hl, $7995
	add hl, de
	ld a, [hl]
	ld hl, $798d
	add hl, de
	ld l, [hl]
	ld h, a
	push hl
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop bc
	xor a
	ldh [$ffda], a
	pop hl
	call Call_1540
	pop bc
	ld a, $02
	call Call_3DD0
	ld de, $79b5
	call Call_3C3B
	ret


Call_07_7A39::
	xor $01
	push af
	ld a, [$c3c0]
	ld l, a
	ld h, $00
	ld de, $c030
	add hl, de
	pop de
	ldh a, [$ffec]
	add d
	add $04
	ld [hli], a
	ldh a, [$ffee]
	add $fe
	ld [hli], a
	ld a, $86
	ld [hli], a
	ld [hl], $10
	ld a, $01
	call Call_3DD0
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
	ldh [$ffa1], a
	xor a
	ld [$c137], a
	ld [$c16a], a
	ldh a, [$fff1]
	cp $22
	jr nz, jr_007_7b2f

	ld a, $1b
	call Call_3C01
	jp c, Call_07_7D7C

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c320
	add hl, de
	ld [hl], $18
	ld hl, $c310
	add hl, de
	ld [hl], $06
	ld hl, $c2f0
	add hl, de
	ld [hl], $50
	ld hl, $c240
	add hl, de
	ld [hl], $08
	ld hl, $c290
	add hl, de
	ld [hl], $03
	ld a, $1d
	ldh [$fff2], a
	jp Call_07_7D7C


jr_007_7b2f:
	cp $21
	jr z, jr_007_7b39

	ld de, $7a5d
	call Call_3CD0

jr_007_7b39:
	ld a, [$c19f]
	and a
	jp nz, Jump_007_7bcf

	call Call_07_7CE2
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $10
	jr nz, jr_007_7b54

	ld hl, $c250
	add hl, bc
	ld [hl], $00

jr_007_7b54:
	cp $08
	jr nz, jr_007_7b71

	ldh a, [$fff1]
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
	ldh [$fff2], a
	jr jr_007_7b71

jr_007_7b6e:
	ld [$d368], a

jr_007_7b71:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $26
	jr nz, jr_007_7bc8

	ldh a, [$fff1]
	ld e, a
	ld d, b
	cp $21
	jr nz, jr_007_7b8f

	ldh a, [$fff6]
	cp $96
	jr nz, jr_007_7b8f

	ld a, $11
	call Call_2185
	jr jr_007_7bc7

jr_007_7b8f:
	ld a, e
	cp $01
	jr nz, jr_007_7b9f

	ld a, [$db44]
	cp $02
	jr nz, jr_007_7b9f

	ld a, $ed
	jr jr_007_7bc4

jr_007_7b9f:
	ld a, e
	cp $0b
	jr nz, jr_007_7baf

	ld a, [$db4e]
	cp $02
	jr nz, jr_007_7baf

	ld a, $9f
	jr jr_007_7bc4

jr_007_7baf:
	ld a, e
	cp $00
	jr nz, jr_007_7bbf

	ld a, [$db43]
	cp $02
	jr nz, jr_007_7bbf

	ld a, $ee
	jr jr_007_7bc4

jr_007_7bbf:
	ld hl, $7a9f
	add hl, de
	ld a, [hl]

jr_007_7bc4:
	call Call_2197

jr_007_7bc7:
	xor a

jr_007_7bc8:
	cp $28
	jr nz, jr_007_7bcf

	call Call_07_7D7C

Jump_007_7bcf:
jr_007_7bcf:
	ret


Call_07_7BD0::
	call Call_3BD5
	jr nc, jr_007_7bf4

	call Call_094A
	call Call_0942
	ld a, [$c1a6]
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

Call_07_7BFA::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7bf6
	add hl, de
	push hl
	ld hl, $c3d0
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
	jp Call_3B87


Call_07_7C16::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $38
	jr jr_007_7c2e

Call_07_7C23::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28

jr_007_7c2e:
	jr nc, jr_007_7c74

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_007_7c74

	inc e
	ldh a, [$ffeb]
	cp $b5
	jr z, jr_007_7c4f

	push de
	call Call_07_7D55
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_007_7c74

jr_007_7c4f:
	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_007_7c74

	ld a, [$db9a]
	cp $80
	jr nz, jr_007_7c74

	ldh a, [$ffcc]
	and $10
	jr z, jr_007_7c74

	scf
	ret


jr_007_7c74:
	and a
	ret


Call_07_7C76::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_007_7c96

Call_07_7C7C::
	ld a, [$db95]
	cp $07
	jr z, jr_007_7c96

	ld a, [$c19f]
	ld hl, $c1a8
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_007_7c96

	ld a, [$c124]
	and a
	jr z, jr_007_7c97

jr_007_7c96:
	pop af

jr_007_7c97:
	ret


Call_07_7C98::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7ce1

	dec a
	ld [hl], a
	call Call_3EB8
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $c3f0
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c400
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_07_7CE2
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_007_7cd4

	call Call_3B9E

jr_007_7cd4:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_007_7ce1:
	ret


Call_07_7CE2::
	call Call_07_7CEF
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_07_7CEF
	pop bc
	ret


Call_07_7CEF::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7d1a

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

jr_007_7d07:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_007_7d11

	ld e, $f0

jr_007_7d11:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_007_7d1a:
	ret


Call_07_7D1B::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_007_7d1a

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_007_7d07

Call_07_7D35::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_007_7d43

	inc e

jr_007_7d43:
	ld d, a
	ret


Call_07_7D45::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_007_7d53

	inc e

jr_007_7d53:
	ld d, a
	ret


Call_07_7D55::
	call Call_07_7D35
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_007_7d62

	cpl
	inc a

jr_007_7d62:
	push af
	call Call_07_7D45
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_007_7d70

	cpl
	inc a

jr_007_7d70:
	pop de
	cp d
	jr nc, jr_007_7d78

	ldh a, [$ffd7]
	jr jr_007_7d7a

jr_007_7d78:
	ldh a, [$ffd8]

jr_007_7d7a:
	ld e, a
	ret


Call_07_7D7C::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


Jump_007_7d82:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_07_7D88::
	dw Jump_07_7D8E
	dw Jump_07_7D9F
	dw Jump_07_7DB0

Jump_07_7D8E::
	call Call_0891
	ld [hl], $a0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff

Call_07_7D99::
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_07_7D9F::
	call Call_0891
	jr nz, jr_007_7daf

	ld [hl], $c0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_07_7D99

jr_007_7daf:
	ret


Jump_07_7DB0::
	call Call_0891
	jr nz, jr_007_7ded

	ldh a, [$ffeb]
	cp $5f
	jr nz, jr_007_7de4

	ld a, $30
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c320
	add hl, de
	ld [hl], $18
	ld hl, $c2f0
	add hl, de
	ld [hl], $20
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	ldh [$ffb0], a
	jp Jump_007_7e54


jr_007_7de4:
	call Call_08D7
	call Call_27BD
	jp Call_3F7A


jr_007_7ded:
	call Call_07_7DF1
	ret


Call_07_7DF1::
	and $07
	jr nz, jr_007_7e12

	call Call_27ED
	and $1f
	sub $10
	ld e, a
	ld hl, $ffee
	add [hl]
	ld [hl], a
	call Call_27ED
	and $1f
	sub $14
	ld e, a
	ld hl, $ffec
	add [hl]
	ld [hl], a
	call Call_07_7E13

jr_007_7e12:
	ret


Call_07_7E13::
	call Call_07_7C7C
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $13
	ldh [$fff4], a
	ret


	db $3e, $36, $cd, $01, $3c, $f0, $d7, $21, $00, $c2, $19, $77, $f0, $d8, $21, $10
	db $c2, $19, $77, $f0, $f9, $a7, $28, $08, $21, $50, $c2, $09, $36, $f0, $18, $0c
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08

Jump_007_7e54:
	call Call_07_7D7C
	ld hl, $fff4
	ld [hl], $1a
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
	db $ff, $ff, $ff
