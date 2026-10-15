; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $76, $00, $78, $00, $7a, $00
	db $76, $20, $74, $20, $7a, $20, $78, $20, $7c, $00, $7c, $20, $40, $00, $40, $20
	db $42, $00, $42, $20, $44, $00, $46, $00, $48, $00, $4a, $00, $46, $20, $44, $20
	db $4a, $20, $48, $20, $4c, $00, $4c, $20

Call_05_4038::
	ld a, c
	ld [$d154], a
	ld a, [$db56]
	cp $01
	jr nz, jr_005_4054

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

jr_005_4054:
	ld de, $401c
	ld a, [$db56]
	and a
	jr nz, jr_005_4060

	ld de, $4000

jr_005_4060:
	call Call_3C3B
	ld a, [$c124]
	and a
	jr z, jr_005_407e

	ld a, [$db56]
	cp $01
	jp z, Jump_005_40a4

	ld hl, $c3e0
	add hl, bc
	ldh a, [$fff6]
	cp [hl]
	jp z, Jump_005_40a7

	jp Jump_005_40a4


jr_005_407e:
	ld a, [$c1a8]
	ld hl, $c19f
	or [hl]
	ld hl, $c14f
	or [hl]
	jp nz, Jump_005_40a4

	ld a, [$c16b]
	cp $04
	ret nz

	call Call_05_44D4
	call Call_08E2
	ld a, [$db56]
	and a
	jr nz, jr_005_40a1

	call Call_3BEB

jr_005_40a1:
	call Call_05_40A8

Jump_005_40a4:
	call Call_05_425B

Jump_005_40a7:
	ret


Call_05_40A8::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_40AE::
	dw Jump_05_40B2
	dw Jump_05_40E9

Jump_05_40B2::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld e, $10
	ld hl, $d100

jr_005_40c4:
	ld [hli], a
	dec e
	jr nz, jr_005_40c4

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	ld hl, $c310
	add hl, bc
	sub [hl]
	ld e, $10
	ld hl, $d110

jr_005_40df:
	ld [hli], a
	dec e
	jr nz, jr_005_40df

	ld hl, $c440
	add hl, bc
	inc [hl]
	ret


Jump_05_40E9::
	ld a, [$db56]
	and a
	jr z, jr_005_413a

	cp $80
	jr z, jr_005_40fd

	ldh a, [$ff98]
	ldh [$ffd7], a
	ldh a, [$ffb3]
	ldh [$ffd8], a
	jr jr_005_412c

jr_005_40fd:
	ldh a, [$ff99]
	sub $40
	add $10
	cp $20
	jr nc, jr_005_412a

	ldh a, [$ff98]
	sub $88
	add $10
	cp $20
	jr nc, jr_005_412a

	ld a, [$c133]
	and a
	jr z, jr_005_412a

	ld a, $10
	ld [$d368], a
	ld a, $6c
	call Call_2185
	ld a, $18
	ldh [$fff3], a
	ld a, $01
	ld [$db56], a

jr_005_412a:
	jr jr_005_413a

jr_005_412c:
	ldh a, [$ffd7]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

jr_005_413a:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld [$d150], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld [$d151], a
	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	push hl
	pop de
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_005_4163

	xor a
	ld [hl], a
	ld [de], a

jr_005_4163:
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_05_4169::
	dw Jump_05_4183
	dw Jump_05_41D4
	dw Jump_05_41F1
	dw Jump_05_4216
	dw Jump_05_41F1

	db $04, $08, $0c, $08, $fc, $f8, $f4, $f8, $f4, $f8, $04, $08, $0c, $08, $fc, $f8

Jump_05_4183::
	call Call_0891
	jr z, jr_005_41b4

	call Call_088C
	jr nz, jr_005_41b3

	call Call_27ED
	and $3f
	add $20
	ld [hl], a
	call Call_3B8D
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $4173
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $417b
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_005_41b3:
	ret


jr_005_41b4:
	call Call_0891
	ld [hl], $28
	ld a, [$db56]
	and a
	jr z, jr_005_41c3

	call Call_05_42A0
	ret


jr_005_41c3:
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	call Call_3B8D
	ld [hl], $02
	ld a, $20
	call Call_3C25
	ret


Jump_05_41D4::
	call Call_088C
	jr nz, jr_005_41df

	ld [hl], $20
	call Call_3B8D
	ld [hl], b

jr_005_41df:
	ldh a, [$ffe8]
	and a
	jr z, jr_005_41ea

	ld hl, $c320
	add hl, bc
	ld [hl], $10

jr_005_41ea:
	call Call_05_79D1
	call Call_05_4230
	ret


Jump_05_41F1::
	call Call_0891
	jr z, jr_005_41ff

	call Call_05_79D1
	call Call_05_4230
	dec e
	jr z, jr_005_420c

jr_005_41ff:
	call Call_3DAF
	call Call_3B8D
	ld [hl], $03
	call Call_0891
	ld [hl], $10

jr_005_420c:
	ld a, [$db56]
	and a
	jr z, jr_005_4215

	call Call_05_433E

jr_005_4215:
	ret


Jump_05_4216::
	call Call_0891
	jr nz, jr_005_422f

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	ld a, [$db56]
	and a
	jr z, jr_005_422b

	ld [hl], $10

jr_005_422b:
	call Call_3B8D
	ld [hl], b

jr_005_422f:
	ret


Call_05_4230::
	ld e, $01
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	sub [hl]
	add $20
	cp $40
	jr c, jr_005_4246

	ldh a, [$ffee]
	ld [hl], a
	inc e

jr_005_4246:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	sub [hl]
	add $20
	cp $40
	jr c, jr_005_425a

	ldh a, [$ffef]
	ld [hl], a
	inc e

jr_005_425a:
	ret


Call_05_425B::
	call Call_05_43B1
	call Call_05_4407
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	push bc
	ld c, $05

jr_005_4270:
	ldh a, [$ffe7]
	xor c
	rra
	jr c, jr_005_4296

	ld hl, $d110
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $d100
	add hl, bc
	ld a, [hl]
	add $04
	ld [de], a
	inc de
	ld a, [$db56]
	and a
	ld a, $4e
	jr nz, jr_005_4290

	ld a, $7e

jr_005_4290:
	ld [de], a
	inc de
	ld a, $00
	ld [de], a
	inc de

jr_005_4296:
	dec c
	jr nz, jr_005_4270

	pop bc
	ld a, $03
	call Call_3DD0
	ret


Call_05_42A0::
	ld a, [$db56]
	cp $80
	jp z, Jump_005_4338

	call Call_27ED
	ld d, b
	and $01
	jr nz, jr_005_42b8

	ld e, $0f
	ld a, $ff
	ldh [$ffd7], a
	jr jr_005_42c0

jr_005_42b8:
	ld e, $00
	ld a, $01
	ldh [$ffd7], a
	ld a, $10

jr_005_42c0:
	ldh [$ffd8], a

jr_005_42c2:
	ld a, e
	cp c
	jr z, jr_005_432c

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_432c

	cp $01
	jr z, jr_005_432c

	ld hl, $c3b0
	add hl, de
	ld a, [hl]
	dec a
	jr z, jr_005_432c

	push de
	ld hl, $c3a0
	add hl, de
	ld e, [hl]
	call Call_37E6
	pop de
	and a
	jr z, jr_005_432c

	ld hl, $c200
	add hl, de
	ldh a, [$ff98]
	sub [hl]
	add $2f
	cp $5e
	jr nc, jr_005_432c

	ld hl, $c210
	add hl, de
	ldh a, [$ff99]
	sub [hl]
	add $2f
	cp $5e
	jr nc, jr_005_432c

	ld a, e
	ld [$d152], a
	ldh a, [$ff99]
	push af
	ldh a, [$ff98]
	push af
	ld a, [hl]
	ldh [$ff99], a
	ld hl, $c200
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld a, $30
	call Call_3C25
	pop af
	ldh [$ff98], a
	pop af
	ldh [$ff99], a
	ld hl, $c320
	add hl, bc
	ld [hl], $10
	call Call_3B8D
	ld [hl], $04
	ret


jr_005_432c:
	ld hl, $ffd7
	ld a, e
	add [hl]
	ld e, a
	ld hl, $ffd8
	cp [hl]
	jr nz, jr_005_42c2

Jump_005_4338:
	call Call_0891
	ld [hl], $10
	ret


Call_05_433E::
	ld a, [$d152]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	ret z

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $0e
	cp $1a
	ret nc

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $10
	cp $20
	ret nc

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $3d
	jr nz, jr_005_4389

	ld hl, $c440
	add hl, de
	ld a, [hl]
	and a
	ret z

	ld a, [$c19f]
	and a
	ret nz

	call Call_0891
	ld [hl], b
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ld [hl], $80
	ld a, $15
	jp Call_2185


jr_005_4389:
	ld hl, $c420
	add hl, de
	ld a, [hl]
	and a
	ret nz

	ld a, $03
	ldh [$fff2], a
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $ad
	jr nz, jr_005_43a9

	ld hl, $c420
	add hl, de
	ld [hl], $18
	ld hl, $c3d0
	add hl, de
	inc [hl]
	ret


jr_005_43a9:
	push bc
	push de
	pop bc
	call Call_3F7A
	pop bc
	ret


Call_05_43B1::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ld [$d100], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ld hl, $c310
	add hl, bc
	sub [hl]
	ld [$d110], a
	ld de, $d100
	ld hl, $d101
	push bc
	ld c, $05

jr_005_43cf:
	ld a, [de]
	sub [hl]
	add $07
	cp $0e
	jr c, jr_005_43e1

	bit 7, a
	jr nz, jr_005_43df

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_005_43df:
	dec [hl]
	dec [hl]

jr_005_43e1:
	inc hl
	inc de
	dec c
	jr nz, jr_005_43cf

	ld de, $d110
	ld hl, $d111
	ld c, $05

jr_005_43ee:
	ld a, [de]
	sub [hl]
	add $07
	cp $0e
	jr c, jr_005_4400

	bit 7, a
	jr nz, jr_005_43fe

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_005_43fe:
	dec [hl]
	dec [hl]

jr_005_4400:
	inc hl
	inc de
	dec c
	jr nz, jr_005_43ee

	pop bc
	ret


Call_05_4407::
	ld a, [$db56]
	and a
	ret z

	cp $80
	ret z

	ldh a, [$ff9b]
	ld hl, $ff9a
	or [hl]
	ld hl, $ffa3
	or [hl]
	jp z, Jump_005_44d3

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld [$d106], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld [$d116], a
	ld de, $d106
	ld hl, $d105
	push bc
	ld bc, $0006

jr_005_4436:
	ld a, [de]
	sub [hl]
	add $07
	cp $0e
	jr c, jr_005_4451

	bit 7, a
	jr nz, jr_005_4448

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_005_4448:
	dec [hl]
	dec [hl]
	dec [hl]
	ld a, c
	cp $01
	jr nz, jr_005_4451

	inc b

jr_005_4451:
	dec hl
	dec de
	dec c
	jr nz, jr_005_4436

	ld de, $d116
	ld hl, $d115
	ld c, $06

jr_005_445e:
	ld a, [de]
	sub [hl]
	add $07
	cp $0e
	jr c, jr_005_447c

	bit 7, a
	jr nz, jr_005_4470

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_005_4470:
	dec [hl]
	dec [hl]
	dec [hl]
	ld a, c
	cp $01
	jr nz, jr_005_447c

	ld a, b
	or $02
	ld b, a

jr_005_447c:
	dec hl
	dec de
	dec c
	jr nz, jr_005_445e

	ld a, b
	ldh [$ffd7], a
	pop bc
	and $01
	jr z, jr_005_44a2

	ld hl, $d110
	ld e, $06

jr_005_448e:
	ld a, [$d151]
	sub [hl]
	jr z, jr_005_449b

	bit 7, a
	jr nz, jr_005_449a

	inc [hl]
	inc [hl]

jr_005_449a:
	dec [hl]

jr_005_449b:
	inc hl
	dec e
	jr nz, jr_005_448e

	call Call_05_44BE

jr_005_44a2:
	ldh a, [$ffd7]
	and $02
	jr z, jr_005_44d3

	ld hl, $d100
	ld e, $06

jr_005_44ad:
	ld a, [$d150]
	sub [hl]
	jr z, jr_005_44ba

	bit 7, a
	jr nz, jr_005_44b9

	inc [hl]
	inc [hl]

jr_005_44b9:
	dec [hl]

jr_005_44ba:
	inc hl
	dec e
	jr nz, jr_005_44ad

Call_05_44BE::
	ld a, [$d110]
	ld hl, $c310
	add hl, bc
	add [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld a, [$d100]
	ld hl, $c200
	add hl, bc
	ld [hl], a

Jump_005_44d3:
jr_005_44d3:
	ret


Call_05_44D4::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	or [hl]
	ret z

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld d, a
	bit 7, a
	jr z, jr_005_44eb

	cpl
	inc a

jr_005_44eb:
	ld e, a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_005_44f7

	cpl
	inc a

jr_005_44f7:
	cp e
	jr nc, jr_005_4508

	bit 7, d
	jr nz, jr_005_4502

	ld e, $04
	jr Call_05_4513

jr_005_4502:
	ld e, $02
	call Call_05_4513
	ret


jr_005_4508:
	bit 7, [hl]
	jr z, jr_005_4511

	ld a, $06
	jp Call_3B87


jr_005_4511:
	ld e, $00

Call_05_4513::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add e
	jp Call_3B87


	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

Call_05_452E::
	ld hl, $c360
	add hl, bc
	ld [hl], $4c
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_4542

	ldh a, [$fff1]
	add $02
	ldh [$fff1], a

jr_005_4542:
	ld de, $451e
	call Call_3C3B
	ldh a, [$ffea]
	cp $07
	jr nz, jr_005_4561

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_4558

	ld a, $13
	ldh [$fff3], a

jr_005_4558:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	jp Call_3B87


jr_005_4561:
	call Call_05_7965
	call Call_3BEB
	call Call_08E2
	ldh a, [$fff0]
	cp $03
	jr z, jr_005_458a

	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_005_458a

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], a

jr_005_458a:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_45c9

	cp $08
	jr nz, jr_005_45c1

	ld a, [$db73]
	and a
	jr z, jr_005_45b7

	dec [hl]
	ld a, [$c16b]
	cp $04
	jr nz, jr_005_45b7

	call Call_27ED
	and $3f
	jr nz, jr_005_45b2

	ld a, $76
	call Call_218E
	jr jr_005_45b7

jr_005_45b2:
	ld a, $8f
	call Call_2197

jr_005_45b7:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $23
	jr z, jr_005_45c1

	inc [hl]

jr_005_45c1:
	call Call_3B8D
	ld a, $02
	ld [hl], a
	ldh [$fff0], a

jr_005_45c9:
	call Call_3BD5
	jr nc, jr_005_461b

	ldh a, [$fff0]
	cp $03
	jr z, jr_005_461b

	ld a, [$c19b]
	and a
	jr nz, jr_005_461b

	ld a, [$db00]
	cp $03
	jr nz, jr_005_45e9

	ldh a, [$ffcc]
	and $20
	jr nz, jr_005_45f6

	jr jr_005_461b

jr_005_45e9:
	ld a, [$db01]
	cp $03
	jr nz, jr_005_461b

	ldh a, [$ffcc]
	and $10
	jr z, jr_005_461b

jr_005_45f6:
	ld a, [$c3cf]
	and a
	jr nz, jr_005_461b

	inc a
	ld [$c3cf], a
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
	ret


jr_005_461b:
	ldh a, [$fff0]
	rst $00

JumpTable_05_461E::
	dw Jump_05_462E
	dw Jump_05_466F
	dw Jump_05_46BC
	dw Jump_05_475B

	db $00, $04, $06, $04, $00, $fc, $fa, $fc

Jump_05_462E::
	xor a
	call Call_3B87
	call Call_0891
	jr nz, jr_005_466e

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $4626
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld a, e
	and $04
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	ld e, a
	ld hl, $4626
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_0891
	call Call_27ED
	and $1f
	add $30
	ld [hl], a
	call Call_3B8D

jr_005_466e:
	ret


Jump_05_466F::
	call Call_05_79D1
	call Call_3B9E
	ldh a, [$ffe8]
	and a
	jr z, jr_005_4691

	call Call_0891
	jr nz, jr_005_4686

	ld [hl], $30
	call Call_3B8D
	ld [hl], b
	ret


jr_005_4686:
	ld hl, $c320
	add hl, bc
	ld [hl], $05
	ld hl, $c310
	add hl, bc
	inc [hl]

jr_005_4691:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $28, $48, $68, $88, $18, $38, $58, $78, $00, $00, $00, $00, $a0, $a0, $a0, $a0
	db $00, $00, $00, $00, $90, $90, $90, $90, $20, $40, $60, $80, $20, $40, $60, $80

Jump_05_46BC::
	ld hl, $c310
	add hl, bc
	ldh a, [$ffe7]
	xor c
	and $1f
	or [hl]
	jr nz, jr_005_46df

	ld a, $0c
	call Call_3C30
	ldh a, [$ffd7]
	cpl
	inc a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ldh a, [$ffd8]
	cpl
	inc a
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_005_46df:
	call Call_05_79D1
	call Call_3B9E
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	call Call_05_7A24
	ld hl, $c380
	add hl, bc
	ld a, e
	xor $01
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $23
	jr nz, jr_005_475a

	ld hl, $dba5
	ldh a, [$ffe7]
	and $0f
	or [hl]
	jr nz, jr_005_475a

	ld a, $6c
	ld e, $07
	call Call_3C13
	jr c, jr_005_475a

	ld a, $13
	ldh [$fff3], a
	ld hl, $c290
	add hl, de
	ld [hl], $03
	ld hl, $c310
	add hl, de
	ld [hl], $10
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c350
	add hl, de
	ld [hl], $80
	ld hl, $c430
	add hl, de
	ld [hl], $40
	push bc
	call Call_27ED
	and $0f
	ld c, a
	ld hl, $469c
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $46ac
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_005_475a:
	ret


Jump_05_475B::
	call Call_3BBF
	call Call_05_79D1
	ldh a, [$ffee]
	cp $a9
	jp nc, Call_05_7A6B

	ldh a, [$ffec]
	cp $91
	jp nc, Call_05_7A6B

	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	ld e, $00
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_4784

	inc e

jr_005_4784:
	ld hl, $c380
	add hl, bc
	ld [hl], e
	jp Call_29C5


	db $c9, $f0, $00, $60, $00, $f0, $08, $62, $00, $00, $00, $64, $00, $00, $08, $66
	db $00, $f0, $00, $68, $00, $f0, $08, $6a, $00, $00, $00, $6c, $00, $00, $08, $6e
	db $00, $f0, $00, $62, $20, $f0, $08, $60, $20, $00, $00, $66, $20, $00, $08, $64
	db $20, $f0, $00, $68, $00, $f0, $08, $6a, $00, $00, $00, $6c, $00, $00, $08, $6e
	db $00

Call_05_47CD::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $478d
	add hl, de
	ld c, $04
	call Call_3D26
	ret


Call_05_47E1::
	call Call_05_47CD
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $03
	call Call_3B87
	call Call_05_5409
	ldh a, [$fff0]
	rst $00

JumpTable_05_47F9::
	dw Jump_05_4803
	dw Jump_05_4851
	dw Jump_05_4863
	dw Jump_05_4898
	dw Jump_05_48C0

Jump_05_4803::
	ld a, [$c19f]
	and a
	jr nz, jr_005_4844

	ld a, [$db4b]
	and a
	jr z, jr_005_483b

	call Call_05_544C
	ld a, e
	and a
	jr z, jr_005_4844

	ld hl, $db00
	ld a, [hl]
	cp $0c
	jr nz, jr_005_482d

	ldh a, [$ffcc]
	and $20
	jr z, jr_005_4844

	xor a
	ld [$c1a9], a
	ld [$c1a8], a
	jr jr_005_4838

jr_005_482d:
	inc hl
	ld a, [hl]
	cp $0c
	jr nz, jr_005_483b

	ldh a, [$ffcc]
	and $10
	ret z

jr_005_4838:
	ld [hl], b
	jr jr_005_4845

jr_005_483b:
	call Call_05_544C
	ret nc

	ld a, $0c
	call Call_2197

jr_005_4844:
	ret


jr_005_4845:
	xor a
	ld [$db4b], a
	call Call_0891
	ld [hl], $04
	jp Call_3B8D


Jump_05_4851::
	call Call_0891
	ret nz

	ld a, $09
	call Call_2197
	call Call_0891
	ld [hl], $c0
	call Call_3B8D
	ret


Jump_05_4863::
	ld a, [$c19f]
	and a
	jr nz, jr_005_4897

	ld a, [$c10b]
	and a
	jr nz, jr_005_4879

	ldh a, [$ffb0]
	ld [$d368], a
	ld a, $01
	ld [$c10b], a

jr_005_4879:
	ldh [$ffa1], a
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	call Call_0891
	ret nz

	ld [$c10b], a
	ldh a, [$ffb0]
	ld [$d368], a
	ld a, $fe
	call Call_2197
	call Call_3B8D

jr_005_4897:
	ret


Jump_05_4898::
	ld a, [$c19f]
	and a
	ret nz

	ld a, $2a
	ld [$c1aa], a
	ld a, $03
	ld [$c1a9], a
	ld d, $0c
	call Call_05_5261
	ld a, [$db4c]
	add $20
	daa
	ld [$db4c], a
	ld a, $0b
	ldh [$ffa5], a
	ld a, $01
	ldh [$fff2], a
	call Call_3B8D

Jump_05_48C0::
	ret


	db $78, $00, $7a, $00, $7a, $20, $78, $20, $7c, $00, $7e, $00, $78, $00, $7a, $00
	db $70, $00, $72, $00, $74, $00, $76, $00, $76, $20, $74, $20, $72, $20, $70, $20
	db $5a, $20, $58, $20, $58, $00, $5a, $00, $50, $00, $52, $00, $50, $00, $52, $00
	db $54, $00, $56, $00, $00, $00, $20, $00, $00, $08, $22, $00, $00, $00, $20, $00
	db $00, $08, $22, $00, $f1, $fa, $2a, $00, $f1, $02, $2a, $20, $00, $00, $24, $00
	db $00, $08, $28, $00

Call_05_4915::
	ld a, [$db95]
	cp $01
	jr nz, jr_005_4940

	ld hl, $c340
	add hl, bc
	ld [hl], $c4
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld hl, $48f5
	cp $70
	jr nz, jr_005_4931

	ld hl, $4905

jr_005_4931:
	ld c, $04
	call Call_3D26
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $70
	ret z

	inc [hl]
	ret


jr_005_4940:
	ld a, [$dba5]
	and a
	jp nz, Jump_005_4b68

	ldh a, [$fff8]
	and $10
	jp nz, Call_05_7A6B

	ldh a, [$fff0]
	and a
	jr nz, jr_005_497c

	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ff99]
	cp $30
	jr nc, jr_005_4977

	ld a, $01
	ld [$c10c], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	jr jr_005_497c

jr_005_4977:
	ld hl, $c440
	add hl, bc
	ld [hl], b

jr_005_497c:
	ld de, $48c1
	call Call_3C3B
	call Call_05_7965
	ldh a, [$fff0]
	rst $00

JumpTable_05_4988::
	dw Jump_05_4990
	dw Jump_05_49C2
	dw Jump_05_4AEC
	dw Jump_05_4B32

Jump_05_4990::
	call Call_05_5409
	ldh a, [$ff99]
	cp $20
	jr nc, jr_005_49a8

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_49a8

	ld [hl], $01
	ld a, $21
	jp Call_2197


jr_005_49a8:
	call Call_05_544C
	jr nc, jr_005_49b7

	ld a, [$c19b]
	and a
	ret nz

	ld a, $0d
	jp Call_2197


jr_005_49b7:
	ld hl, $c1ad
	ld [hl], b
	ret


	db $00, $04, $05, $06, $07, $01

Jump_05_49C2::
	ld a, $02
	ldh [$ffa1], a
	xor a
	ld [$c19b], a
	call Call_05_7A44
	ld a, e
	xor $01
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	ld hl, $c2d0
	add hl, bc
	ld e, [hl]
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_005_49f1

	ld hl, $c390
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, jr_005_49f0

	xor a

jr_005_49f0:
	ld [hl], a

jr_005_49f1:
	ld hl, $c390
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $49bc
	add hl, de
	ld a, [hl]
	call Call_3B87
	call Call_0887
	jr nz, jr_005_4a49

	ld a, $02
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $c440
	add hl, de
	ld [hl], $4c
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	ld a, $09
	call Call_3B87
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_3B8D
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ld hl, $d800
	add hl, de
	ld a, [hl]
	or $10
	ld [hl], a
	ld a, $01
	ld [$db48], a
	ret


jr_005_4a49:
	ld hl, $c2d0
	add hl, bc
	ldh a, [$ffe7]
	and $01
	jr nz, jr_005_4a59

	ld a, [hl]
	cp $f0
	jr nc, jr_005_4a59

	inc [hl]

jr_005_4a59:
	call Call_05_79D1
	call Call_3B9E
	call Call_0887
	cp $06
	jr nc, jr_005_4a97

	ldh a, [$ffef]
	cp $30
	jr nc, jr_005_4a70

	ld [hl], $08
	jr jr_005_4a97

jr_005_4a70:
	ld hl, $c320
	add hl, bc
	inc [hl]
	nop
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4a85

	and $80
	jr z, jr_005_4a84

	inc [hl]
	inc [hl]

jr_005_4a84:
	dec [hl]

jr_005_4a85:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4a94

	and $80
	jr z, jr_005_4a93

	inc [hl]
	inc [hl]

jr_005_4a93:
	dec [hl]

jr_005_4a94:
	jp Call_05_7A0A


jr_005_4a97:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_005_4aac

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld a, $09
	ldh [$fff2], a

jr_005_4aac:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_005_4ac1

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld a, $09
	ldh [$fff2], a

jr_005_4ac1:
	call Call_0887
	cp $60
	jr nc, jr_005_4aeb

	ldh a, [$ffe7]
	and $03
	jr nz, jr_005_4aeb

	ld hl, $c240
	call Call_05_4AD7
	ld hl, $c250

Call_05_4AD7::
	add hl, bc
	ld a, [hl]
	cp $30
	jr z, jr_005_4aeb

	cp $d0
	jr z, jr_005_4aeb

	ld e, $01
	bit 7, a
	jr z, jr_005_4ae9

	ld e, $ff

jr_005_4ae9:
	add e
	ld [hl], a

jr_005_4aeb:
	ret


Jump_05_4AEC::
	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_4b31

	ld [hl], b
	xor a
	ld [$c167], a
	ld a, $23
	ldh [$fff2], a
	call Call_27BD
	call Call_0891
	ld [hl], $40
	call Call_05_7A44
	add $08
	call Call_3B87
	call Call_05_7A24
	add $12
	cp $24
	jr nc, jr_005_4b2e

	call Call_05_7A34
	add $12
	cp $24
	jr nc, jr_005_4b2e

	ld hl, $c2b0
	add hl, bc
	ld [hl], $01

jr_005_4b2e:
	call Call_3B8D

jr_005_4b31:
	ret


Jump_05_4B32::
	call Call_0891
	cp $01
	jr nz, jr_005_4b3f

	ld a, $0a
	call Call_2197
	ret


jr_005_4b3f:
	and a
	jr nz, jr_005_4b65

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_4b50

	call Call_05_7A44
	add $08
	call Call_3B87

jr_005_4b50:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_4b5b

	call Call_05_5409

jr_005_4b5b:
	call Call_05_544C
	jr nc, jr_005_4b65

	ld a, $0b
	call Call_2197

jr_005_4b65:
	ret


	db $78, $00

Jump_005_4b68:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_4b98

	ld de, $4b66
	call Call_3CD0
	call Call_05_7965
	call Call_05_79D1
	call Call_0891
	jp z, Call_05_7A6B

	and $10
	ld e, $01
	jr z, jr_005_4b8a

	ld e, $ff

jr_005_4b8a:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_005_4b97

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a

jr_005_4b97:
	ret


jr_005_4b98:
	ld a, [$db73]
	and a
	jr nz, jr_005_4bae

	ld a, [$db67]
	and $02
	jp nz, Call_05_7A6B

	ld a, [$db0e]
	cp $04
	jp nc, Call_05_7A6B

jr_005_4bae:
	ld a, [$db48]
	and a
	jr nz, jr_005_4bbb

	ld a, [$db4e]
	and a
	jp nz, Call_05_7A6B

jr_005_4bbb:
	ld a, [$db73]
	and a
	jr nz, jr_005_4bcb

	ld a, [$db48]
	and a
	jr z, jr_005_4bdf

	cp $01
	jr nz, jr_005_4bdf

jr_005_4bcb:
	ld hl, $c200
	add hl, bc
	ld [hl], $18
	ld hl, $c210
	add hl, bc
	ld [hl], $34
	call Call_3DBA
	ld de, $48f1
	jr jr_005_4bf3

jr_005_4bdf:
	call Call_05_4D52
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_4bf0

	call Call_05_7A44
	ld hl, $c3b0
	add hl, bc
	ld [hl], e

jr_005_4bf0:
	ld de, $48e1

jr_005_4bf3:
	call Call_3C3B
	call Call_05_7965
	call Call_05_5409
	ldh a, [$fff0]
	rst $00

JumpTable_05_4BFF::
	dw Jump_05_4C09
	dw Jump_05_4C32
	dw Jump_05_4C48
	dw Jump_05_4C89
	dw Jump_05_4D26

Jump_05_4C09::
	ld a, [$db44]
	and a
	jr z, jr_005_4c15

	call Call_3B8D
	ld [hl], $03
	ret


jr_005_4c15:
	ldh a, [$ff99]
	cp $7b
	jr c, jr_005_4c24

	sub $02
	ldh [$ff99], a
	ld a, $00
	jp Call_2197


jr_005_4c24:
	call Call_05_544C
	jr nc, jr_005_4c31

	ld a, $54
	call Call_2197
	call Call_3B8D

jr_005_4c31:
	ret


Jump_05_4C32::
	ld a, [$c19f]
	and a
	jr nz, jr_005_4c45

	call Call_0891
	ld [hl], $80
	ld a, $10
	ld [$d368], a
	call Call_3B8D

jr_005_4c45:
	ret


	db $86, $10

Jump_05_4C48::
	call Call_0891
	jr nz, jr_005_4c66

	ld [$c167], a
	ld d, $04
	call Call_05_5261
	ld a, $01
	ld [$db44], a
	ld a, $22
	ldh [$ff9d], a
	ld a, $91
	call Call_2197
	jp Call_3B8D


jr_005_4c66:
	ldh a, [$ff98]
	ldh [$ffee], a
	ldh a, [$ff99]
	sub $0c
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $4c46
	call Call_3CD0
	call Call_3DBA
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $03
	ldh [$ff9e], a
	ret


Jump_05_4C89::
	ld a, [$db48]
	and a
	jr z, jr_005_4cce

	cp $01
	jr z, jr_005_4cb9

	call Call_05_544C
	jr nc, jr_005_4cac

	ld a, [$db73]
	and a
	ld a, $dd
	jr nz, jr_005_4cb5

	ld a, [$db0e]
	cp $03
	jr nz, jr_005_4cb3

	ld a, $c5
	call Call_2185

jr_005_4cac:
	ld a, [$db73]
	and a
	jr nz, jr_005_4ce0

	ret


jr_005_4cb3:
	ld a, $c5

jr_005_4cb5:
	call Call_2185
	ret


jr_005_4cb9:
	call Call_05_544C
	jr nc, jr_005_4ccc

	ld a, [$db65]
	bit 1, a
	ld a, $11
	jr z, jr_005_4cc9

	ld a, $10

jr_005_4cc9:
	call Call_2197

jr_005_4ccc:
	jr jr_005_4cd9

jr_005_4cce:
	call Call_05_544C
	jr nc, jr_005_4cd8

	ld a, $55
	call Call_2197

jr_005_4cd8:
	ret


jr_005_4cd9:
	ld a, [$db48]
	cp $01
	jr nz, jr_005_4d25

jr_005_4ce0:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	add $07
	ld [hl], a
	jr nc, jr_005_4d25

	ld a, $3f
	call Call_3C01
	ldh a, [$ffd7]
	add $06
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	sub $03
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2c0
	add hl, de
	ld [hl], $01
	ld hl, $c240
	add hl, de
	ld [hl], $ff
	ld hl, $c250
	add hl, de
	ld [hl], $fd
	ld hl, $c2e0
	add hl, de
	ld [hl], $30
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	ld hl, $c350
	add hl, de
	ld [hl], $00

jr_005_4d25:
	ret


Jump_05_4D26::
	ld a, [$c19f]
	and a
	jr nz, jr_005_4d49

	ld a, [$c177]
	and a
	jr nz, jr_005_4d40

	ld a, $04
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	call Call_0898
	jr jr_005_4d45

jr_005_4d40:
	ld a, $c9
	call Call_2185

jr_005_4d45:
	call Call_3B8D
	ld [hl], b

jr_005_4d49:
	ret


	db $74, $00, $76, $00, $70, $00, $72, $00

Call_05_4D52::
	ld a, [$db48]
	cp $02
	ret nz

	ld a, [$db0e]
	cp $04
	jr nc, jr_005_4d66

	ld a, $78
	ld de, $4d4a
	jr jr_005_4d76

jr_005_4d66:
	ldh a, [$fff8]
	and $20
	ret z

	ld hl, $c210
	add hl, bc
	ld [hl], $4b
	ld de, $4d4e
	ld a, $7c

jr_005_4d76:
	ldh [$ffee], a
	ld a, $5c
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	call Call_3C3B
	call Call_3DBA
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
	db $68, $00, $6a, $00, $6a, $20, $68, $20, $66, $00, $66, $20, $66, $00, $66, $20
	db $6c, $00, $6e, $00, $6c, $00, $6e, $00, $6e, $20, $6c, $20, $6e, $20, $6c, $20
	db $60, $00, $62, $00, $64, $00, $64, $20, $62, $20, $60, $20, $08, $08, $08, $09
	db $0a, $0a, $0a, $09, $08, $f8, $06, $01

Call_05_4DE5::
	ld a, [$db95]
	cp $01
	jp z, Jump_005_4e4e

	ld a, [$db73]
	and a
	jp nz, Call_05_7A6B

	ld a, [$dba5]
	and a
	jp nz, Jump_005_511d

	ld a, [$db4e]
	and a
	jp z, Call_05_7A6B

	ldh a, [$fff6]
	cp $c0
	jr c, jr_005_4e0a

	jr jr_005_4e19

jr_005_4e0a:
	ld a, [$d808]
	and $10
	jr nz, jr_005_4e19

	ld a, [$db0e]
	cp $07
	jp nc, Call_05_7A6B

jr_005_4e19:
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_4e3f

	ld hl, $c380
	add hl, bc
	ld [hl], $03
	call Call_05_7A24
	add $14
	cp $28
	jr nc, jr_005_4e3f

	call Call_05_7A34
	add $14
	cp $28
	jr nc, jr_005_4e3f

	call Call_05_7A44
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_005_4e3f:
	call Call_05_5430
	ld a, [$c3c8]
	cp $01
	jr nz, jr_005_4ea7

	call Call_088C
	jr nz, jr_005_4ea7

Jump_005_4e4e:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $4dd9
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	ldh a, [$ffe7]
	add $10
	and $1f
	jr nz, jr_005_4ea7

	ld a, $c9
	call Call_3C01
	jr c, jr_005_4ea7

	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	sub $08
	ld [hl], a
	push bc
	ldh a, [$ffe7]
	add $10
	rra
	rra
	rra
	rra
	rra
	and $01
	ld c, a
	ld hl, $4de1
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4de3
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, de
	ld [hl], $fc
	ld hl, $c3d0
	add hl, de
	ld [hl], $40
	pop bc

jr_005_4ea7:
	ld a, c
	ld [$c50f], a
	ld de, $4dad
	call Call_3C3B
	call Call_05_5409
	ldh a, [$fff0]
	rst $00

JumpTable_05_4EB7::
	dw Jump_05_4EC3
	dw Jump_05_4F84
	dw Jump_05_4FBD
	dw Jump_05_508C
	dw Jump_05_50B8
	dw Jump_05_510B

Jump_05_4EC3::
	ldh a, [$fff6]
	cp $c0
	jr nc, jr_005_4ed0

	ld a, [$c3c8]
	and a
	jp nz, Jump_005_4f83

jr_005_4ed0:
	call Call_05_544C
	jp nc, Jump_005_4f83

	ld a, [$d808]
	and $10
	jr z, jr_005_4f0a

	ld hl, $d892
	ld a, [hl]
	and $40
	jr nz, jr_005_4eec

	set 6, [hl]
	ld a, $94
	jp Call_2185


jr_005_4eec:
	ld a, [$db49]
	and $04
	jr z, jr_005_4ef8

jr_005_4ef3:
	ld a, $95
	jp Call_2185


jr_005_4ef8:
	ld e, $0b
	ld hl, $db00

jr_005_4efd:
	ld a, [hli]
	cp $09
	jr z, jr_005_4f0a

	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_4efd

	jr jr_005_4ef3

jr_005_4f0a:
	call Call_088C
	ld [hl], $10
	ld d, $2f
	ld e, $03
	ld a, [$db48]
	and a
	jr z, jr_005_4f5e

	ld e, $06
	cp $02
	jr nz, jr_005_4f33

	ld e, $05
	ldh a, [$fff6]
	cp $c0
	jr c, jr_005_4f33

	push de
	call Call_27BD
	pop de
	ld hl, $c2d0
	add hl, bc
	ld [hl], b
	ld e, $92

jr_005_4f33:
	push bc
	ld c, $0b
	ld hl, $db00

jr_005_4f39:
	ld a, [hli]
	cp $09
	jr nz, jr_005_4f57

	ld e, $04
	ld d, $4a
	ld a, [$db49]
	and $04
	jr z, jr_005_4f5d

	ld e, $05
	ld d, $2f
	ldh a, [$fff6]
	cp $c0
	jr c, jr_005_4f5d

	ld e, $92
	jr jr_005_4f5d

jr_005_4f57:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_005_4f39

jr_005_4f5d:
	pop bc

jr_005_4f5e:
	ld a, e
	cp $80
	jr c, jr_005_4f68

	call Call_2185
	jr jr_005_4f6b

jr_005_4f68:
	call Call_2197

jr_005_4f6b:
	ldh a, [$fff6]
	cp $c0
	jr c, jr_005_4f7b

	ld hl, $c2d0
	add hl, bc
	ld [hl], b
	push de
	call Call_27BD
	pop de

jr_005_4f7b:
	ld hl, $c440
	add hl, bc
	ld [hl], d
	call Call_3B8D

Jump_005_4f83:
	ret


Jump_05_4F84::
	call Call_05_7965
	ld hl, $c440
	add hl, bc
	ld d, [hl]
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	ld a, d
	jr nz, jr_005_4fa2

	inc [hl]
	ld [$d368], a
	ldh [$ffb0], a
	ldh [$ffbd], a
	ld hl, $c3c8
	ld [hl], $01

jr_005_4fa2:
	cp $4a
	jr nz, jr_005_4fb8

	ld a, [$db49]
	and $04
	jr nz, jr_005_4fb8

	call Call_3B8D
	xor a
	ld [$d210], a
	ld [$d211], a
	ret


jr_005_4fb8:
	call Call_3B8D
	ld [hl], b
	ret


Jump_05_4FBD::
	ld a, $02
	ldh [$ffa1], a
	push bc
	call Call_087C
	pop bc
	ld a, [$d211]
	cp $07
	jr nz, jr_005_4feb

	ld a, [$d210]
	cp $e8
	jr nz, jr_005_4feb

	ld a, $16
	call Call_2197
	push bc
	call Call_087C
	pop bc
	xor a
	ld [$d210], a
	ld [$d211], a
	call Call_27D2
	jp Call_3B8D


jr_005_4feb:
	call Call_05_7A44
	ld a, e
	xor $01
	ldh [$ff9e], a
	ld a, [$d210]
	add $01
	ld [$d210], a
	ld e, a
	ld a, [$d211]
	adc $00
	ld [$d211], a
	ld d, a
	ld a, [$d211]
	cp $07
	jr nz, jr_005_5018

	ld a, [$d210]
	cp $e0
	jr c, jr_005_5018

	xor a
	ld [$c3c8], a
	ret


jr_005_5018:
	ld hl, $c3c8
	ld [hl], $01
	ld a, e
	srl d
	rra
	srl d
	rra
	srl d
	rra
	srl d
	rra
	cp $1d
	jr c, jr_005_5033

	cp $3b
	jr nc, jr_005_5033

	inc [hl]

jr_005_5033:
	cp $1d
	ret c

	ld a, $00
	ldh [$ff9d], a
	ldh a, [$ffe7]
	ld e, $75
	and $40
	jr z, jr_005_5043

	inc e

jr_005_5043:
	ld a, e
	ldh [$ff9d], a
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_508b

	ld a, $c9
	call Call_3C01
	jr c, jr_005_508b

	ldh a, [$ff99]
	ld hl, $c210
	add hl, de
	sub $08
	ld [hl], a
	push bc
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	ld c, a
	ld b, d
	ld hl, $4de1
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4de3
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	pop bc
	ld hl, $c250
	add hl, de
	ld [hl], $fc
	ld hl, $c3d0
	add hl, de
	ld [hl], $40

jr_005_508b:
	ret


Jump_05_508C::
	ld a, [$c19f]
	and a
	jr nz, jr_005_50b5

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_005_50a6

	ld a, $10
	ld [$d368], a
	call Call_0891
	ld [hl], $80
	ret


jr_005_50a6:
	ld a, $15
	call Call_2197
	call Call_3B8D
	ld [hl], $01
	ld hl, $c2d0
	add hl, bc
	ld [hl], b

jr_005_50b5:
	ret


	db $90, $10

Jump_05_50B8::
	call Call_0891
	jr nz, jr_005_50e5

	ld a, [$c19f]
	and a
	ret nz

	ld hl, $db49
	set 2, [hl]
	xor a
	ld [$db4a], a
	call Call_3B8D
	ldh a, [$fff6]
	cp $c0
	jr c, jr_005_50d5

	ld [hl], b

jr_005_50d5:
	ldh a, [$fff6]
	cp $c0
	jr nc, jr_005_50e0

	ld a, $14
	jp Call_2197


jr_005_50e0:
	ld a, $93
	jp Call_2185


jr_005_50e5:
	cp $08
	jr nz, jr_005_50ef

	dec [hl]
	ld a, $13
	call Call_2197

jr_005_50ef:
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ldh a, [$ff98]
	ldh [$ffee], a
	ldh a, [$ff99]
	sub $0c
	ldh [$ffec], a
	ld de, $50b6
	xor a
	ldh [$fff1], a
	call Call_3CD0
	ret


Jump_05_510B::
	ld a, [$c19f]
	and a
	ret nz

	call Call_05_544C
	ret nc

	ld a, $97
	jp Call_2185


	db $5c, $00, $5c, $20

Jump_005_511d:
	ld a, [$db0e]
	cp $07
	jr c, jr_005_514c

	ld a, [$d8fd]
	and $30
	jp nz, Call_05_7A6B

	ld hl, $c210
	add hl, bc
	ld [hl], $60
	ld hl, $c200
	add hl, bc
	ld [hl], $7a
	ld de, $5119
	call Call_3C3B
	call Call_05_7965
	call Call_05_544C
	jr nc, jr_005_514b

	ld a, $d7
	call Call_2185

jr_005_514b:
	ret


jr_005_514c:
	ld a, [$db4e]
	and a
	jp nz, Call_05_7A6B

	ld a, [$db44]
	and a
	jr z, jr_005_5162

	ld hl, $c290
	add hl, bc
	ld a, $03
	ld [hl], a
	ldh [$fff0], a

jr_005_5162:
	ldh a, [$fff0]
	and a
	jr nz, jr_005_5189

	call Call_0887
	ld [hl], $7f
	ld hl, $c380
	add hl, bc
	ld [hl], $01
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	ld [$c167], a
	call Call_3B8D
	ret


jr_005_5189:
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_5197

	call Call_05_7A44
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_005_5197:
	call Call_05_5430
	ld de, $4d8d
	call Call_3C3B
	ldh a, [$fff0]
	dec a
	rst $00

JumpTable_05_51A4::
	dw Jump_05_51DE
	dw Jump_05_5219
	dw Jump_05_5250

	db $40, $00, $42, $00, $42, $20, $40, $20, $44, $00, $46, $00, $48, $00, $4a, $00
	db $48, $00, $4c, $00, $03, $03, $03, $03, $03, $04, $03, $04, $03, $03, $03, $02
	db $02, $02, $02, $02, $00, $00, $01, $01, $00, $00, $01, $01, $00, $00, $01, $01
	db $00, $00, $01, $01

Jump_05_51DE::
	call Call_0887
	jr nz, jr_005_51ee

	ld a, $01
	call Call_2197
	ld [hl], $40
	call Call_3B8D
	xor a

jr_005_51ee:
	rra
	rra
	and $1f
	ld e, a
	ld d, b
	ld hl, $51be
	add hl, de
	ld a, [hl]

Call_05_51F9::
	ldh [$fff1], a
	ld a, $38
	ldh [$ffee], a
	ldh [$ff98], a
	ld a, $34
	ldh [$ffec], a
	ldh [$ff99], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $ff
	ldh [$ff9d], a
	ld de, $51aa
	call Call_3C3B
	call Call_3DBA
	ret


Jump_05_5219::
	ld a, $03
	call Call_05_51F9
	call Call_0891
	ld hl, $c19f
	or [hl]
	jr nz, jr_005_524f

	ldh a, [$ffcb]
	and $0f
	jr z, jr_005_524f

	call Call_3B8D
	ld a, $01
	ldh [$ffa2], a
	ld a, $02
	ld [$c146], a
	ld a, $12
	ldh [$ffa3], a
	ld a, $0c
	ldh [$ff9a], a
	xor a
	ldh [$ff9b], a
	ld a, $00
	ldh [$ff9e], a
	ldh [$ffa1], a
	ld a, $01
	ld [$c10a], a

jr_005_524f:
	ret


Jump_05_5250::
	call Call_05_7965
	call Call_05_5409
	call Call_05_544C
	jr nc, jr_005_5260

	ld a, $02
	call Call_2197

jr_005_5260:
	ret


Call_05_5261::
	ld hl, $db00
	ld e, $0c

jr_005_5266:
	ld a, [hli]
	cp d
	jr z, jr_005_527d

	dec e
	jr nz, jr_005_5266

	ld hl, $db00

jr_005_5270:
	ld a, [hl]
	and a
	jr nz, jr_005_5276

	ld [hl], d
	ret


jr_005_5276:
	inc hl
	inc e
	ld a, e
	cp $0c
	jr nz, jr_005_5270

jr_005_527d:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_05_529E::
	ld a, [$dba5]
	and a
	jr z, jr_005_5322

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_005_52b2

	call Call_05_7A44
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_005_52b2:
	call Call_05_5430
	ld de, $527e
	call Call_3C3B
	call Call_05_7965
	call Call_05_5409
	ldh a, [$fff0]
	rst $00

JumpTable_05_52C4::
	dw Jump_05_52CA
	dw Jump_05_52DE
	dw Jump_05_530F

Jump_05_52CA::
	ld a, [$d477]
	and a
	jr nz, Jump_05_530F

	call Call_05_544C
	jr nc, jr_005_52dd

	ld a, $f0
	call Call_2197
	call Call_3B8D

jr_005_52dd:
	ret


Jump_05_52DE::
	ld a, [$c19f]
	and a
	jr nz, jr_005_5308

	call Call_3B8D
	ld a, [$c177]
	and a
	jr z, jr_005_52ef

	ld [hl], b
	ret


jr_005_52ef:
	ld a, [$db5e]
	sub $00
	ld a, [$db5d]
	sbc $01
	jr c, jr_005_5309

	ld a, $64
	ld [$db92], a
	ld a, $f1
	ld [$d477], a
	call Call_2197

jr_005_5308:
	ret


jr_005_5309:
	ld [hl], b
	ld a, $4e
	jp Call_2197


Jump_05_530F::
	call Call_05_544C
	jr nc, jr_005_5319

	ld a, $f1
	call Call_2197

jr_005_5319:
	ret


	db $5c, $00, $5c, $20, $5e, $00, $5e, $20

jr_005_5322:
	ld hl, $c440
	add hl, bc
	ld a, [$d477]
	or [hl]
	jr nz, jr_005_5357

	ld e, $0f
	ld d, b

jr_005_532f:
	ld a, e
	cp c
	jr z, jr_005_5345

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_5345

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $6a
	jp z, Call_05_7A6B

jr_005_5345:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_005_532f

	ld de, $531a
	call Call_3C3B
	call Call_05_7965
	jp Call_05_5409


jr_005_5357:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_005_5386

	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $1c
	jr nc, jr_005_5386

	ld a, $80
	ld [$c1ad], a
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a

jr_005_5386:
	ld a, [$c11f]
	and a
	jr z, jr_005_5392

	call Call_3B8D
	ld [hl], b
	jr jr_005_53cd

jr_005_5392:
	ldh a, [$fff0]
	rst $00

JumpTable_05_5395::
	dw Jump_05_539B
	dw Jump_05_53B2
	dw Jump_05_53D6

Jump_05_539B::
	call Call_05_7A24
	add $08
	cp $10
	jr nc, jr_005_53b0

	call Call_05_7A34
	add $09
	cp $12
	jr nc, jr_005_53b0

	call Call_3B8D

jr_005_53b0:
	jr jr_005_53cd

Jump_05_53B2::
	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffec]
	sub $05
	ldh [$ff99], a
	call Call_3B8D
	ld hl, $c440
	add hl, bc
	ld [hl], $01
	xor a
	ld [$d477], a

jr_005_53c9:
	ld a, $01
	ldh [$ffb2], a

jr_005_53cd:
	call Call_3DBA
	ld de, $531a
	jp Call_3C3B


Jump_05_53D6::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	ld [$c13b], a
	ldh a, [$fff6]
	ld hl, $c3e0
	add hl, bc
	ld [hl], a
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	add $05
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], b
	ld a, [$c11c]
	cp $02
	jr nz, jr_005_5407

	ldh a, [$ffa2]
	ld [hl], a

jr_005_5407:
	jr jr_005_53c9

Call_05_5409::
	call Call_3BD5
	jr nc, jr_005_542b

	call Call_094A
	call Call_0942
	ld a, [$c1a6]
	and a
	jr z, jr_005_542b

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_005_542b

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_005_542b:
	ret


	db $06, $04, $02, $00

Call_05_5430::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $542c
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


Call_05_544C::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28
	jr nc, jr_005_549d

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_005_549d

	inc e
	ldh a, [$ffeb]
	cp $6d
	jr z, jr_005_5478

	push de
	call Call_05_7A44
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_005_549d

jr_005_5478:
	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_005_549d

	ld a, [$db9a]
	cp $80
	jr nz, jr_005_549d

	ldh a, [$ffcc]
	and $10
	jr z, jr_005_549d

	scf
	ret


jr_005_549d:
	and a
	ret


Call_05_549F::
	call Call_0887
	ld [hl], $c0
	ld a, $18
	ld [$d202], a
	ret


Call_05_54AA::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_54B0::
	dw Jump_05_54B8
	dw Jump_05_5875
	dw Jump_05_583C
	dw Jump_05_58BF

Jump_05_54B8::
	call Call_3F12
	call Call_05_580E
	ldh a, [$ffea]
	cp $05
	jr z, jr_005_5500

	ld [$c1c6], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_54CD::
	dw Jump_05_54D1
	dw Jump_05_54DF

Jump_05_54D1::
	call Call_0891
	ld [hl], $ff
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	jp Jump_005_6294


Jump_05_54DF::
	call Call_0891
	jp z, Jump_005_54f2

	ld hl, $c420
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_005_54f1

	call Call_05_7476

jr_005_54f1:
	ret


Jump_005_54f2:
	call Call_05_74AD
	ld hl, $c480
	add hl, de
	ld [hl], $08
	ret


	db $f8, $a8, $08, $f8

jr_005_5500:
	call Call_05_7965
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5554

	and $3f
	jr nz, jr_005_5554

	ld a, $65
	ld e, $04
	call Call_3C13
	jr c, jr_005_5586

	ld hl, $c340
	add hl, de
	ld [hl], $02
	ld hl, $c350
	add hl, de
	ld [hl], $80
	ld hl, $c430
	add hl, de
	ld [hl], $40
	ld hl, $c2d0
	add hl, de
	ld [hl], $01
	ld hl, $c200
	add hl, de
	ld a, [$d202]
	ld [hl], a
	add $20
	ld [$d202], a
	cp $a8
	jr c, jr_005_5546

	ld a, $08
	ld [$d202], a

jr_005_5546:
	call Call_27ED
	ld hl, $c3d0
	add hl, de
	ld [hl], a
	ld hl, $c210
	add hl, de
	ld [hl], $00

jr_005_5554:
	ld a, [$d201]
	inc a
	ld [$d201], a
	and $7f
	jr nz, jr_005_5586

	ld a, $65
	ld e, $04
	call Call_3C13
	jr c, jr_005_5586

	ld hl, $c340
	add hl, de
	ld [hl], $41
	ld hl, $c2d0
	add hl, de
	ld [hl], $02
	ldh a, [$ffd7]
	sub $14
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	sub $04
	ld hl, $c210
	add hl, de
	ld [hl], a

jr_005_5586:
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $0a
	jr nc, jr_005_55e7

	ld a, [$d201]
	add $40
	and $ff
	jr nz, jr_005_55e7

	ld a, $65
	ld e, $04
	call Call_3C13
	jr c, jr_005_55e7

	ld hl, $c4d0
	add hl, de
	ld [hl], d
	ld hl, $c340
	add hl, de
	ld [hl], $02
	ld hl, $c430
	add hl, de
	ld [hl], d
	ld hl, $c360
	add hl, de
	ld [hl], d
	ld hl, $c2d0
	add hl, de
	ld [hl], $03
	call Call_27ED
	and $3f
	add $20
	ld hl, $c210
	add hl, de
	ld [hl], a
	push bc
	and $01
	ld c, a
	ld hl, $54fc
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $54fe
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $40
	pop bc

jr_005_55e7:
	call Call_08E2
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	rra
	rra
	rra
	rra
	and $01
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	ldh a, [$ffee]
	sub $10
	ldh [$ffee], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	ld hl, $c350
	add hl, bc
	ld [hl], $00
	call Call_3B65
	call Call_3BEB
	call Call_3DBA
	ld hl, $c350
	add hl, bc
	ld [hl], $14
	call Call_3B65
	call Call_3BBF
	ldh a, [$fff0]
	rst $00

JumpTable_05_5625::
	dw Jump_05_562F
	dw Jump_05_566E
	dw Jump_05_56A8

	db $08, $f8, $60, $18

Jump_05_562F::
	call Call_0887
	jr nz, jr_005_5649

	call Call_0891
	ld [hl], $80
	call Call_3B8D
	call Call_27ED
	and $1f
	add $60
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ret


jr_005_5649:
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $562d
	add hl, de
	ldh a, [$ffec]
	cp [hl]
	jr nz, jr_005_5660

	ld a, e
	xor $01
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_005_5660:
	ld hl, $562b
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_05_79D4
	ret


Jump_05_566E::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	inc [hl]
	call Call_0891
	cp $60
	jr nz, jr_005_5681

	ld hl, $fff3
	ld [hl], $0d

jr_005_5681:
	jr nc, jr_005_56a7

	ld hl, $c240
	add hl, bc
	ld [hl], $d0
	call Call_05_79DE
	ldh a, [$ffee]
	cp $18
	jr nc, jr_005_56a7

	ld a, $30
	ld [$c157], a
	xor a
	ld [$c158], a
	call Call_08D7
	ld hl, $c300
	add hl, bc
	ld [hl], $ff
	call Call_3B8D

jr_005_56a7:
	ret


Jump_05_56A8::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld a, [$c157]
	and a
	jr nz, jr_005_56d5

	ld hl, $c240
	add hl, bc
	ld [hl], $20
	call Call_05_79DE
	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffee]
	cp [hl]
	jr c, jr_005_56d5

	call Call_0887
	call Call_27ED
	and $1f
	add $40
	ld [hl], a
	call Call_3B8D
	ld [hl], b

jr_005_56d5:
	ret


	db $f0, $f0, $40, $00, $f0, $f8, $42, $00, $f0, $00, $44, $00, $f0, $08, $46, $10
	db $f0, $10, $48, $10, $f0, $18, $4a, $10, $00, $f0, $4c, $00, $00, $f8, $4e, $00
	db $00, $00, $50, $10, $00, $08, $52, $10, $00, $10, $54, $10, $00, $18, $56, $10
	db $00, $20, $58, $10, $10, $f8, $5a, $10, $10, $00, $5c, $10, $10, $08, $5e, $10
	db $10, $10, $60, $10, $10, $18, $62, $10, $10, $20, $64, $10, $00, $00, $ff, $00
	db $f0, $f0, $66, $00, $f0, $f8, $42, $00, $f0, $00, $44, $00, $f0, $08, $46, $10
	db $f0, $10, $48, $10, $f0, $18, $4a, $10, $00, $f0, $68, $00, $00, $f8, $4e, $00
	db $00, $00, $50, $10, $00, $08, $52, $10, $00, $10, $54, $10, $00, $18, $56, $10
	db $00, $20, $6a, $10, $10, $f8, $5a, $10, $10, $00, $5c, $10, $10, $08, $5e, $10
	db $10, $10, $60, $10, $10, $18, $62, $10, $10, $20, $6c, $10, $f0, $18, $4a, $10
	db $f0, $08, $46, $10, $f0, $10, $48, $10, $f0, $f8, $42, $00, $f0, $00, $44, $00
	db $f0, $f0, $40, $00, $00, $20, $58, $10, $00, $08, $52, $10, $00, $10, $54, $10
	db $00, $18, $56, $10, $00, $f8, $4e, $00, $00, $00, $50, $10, $00, $f0, $4c, $00
	db $10, $20, $64, $10, $10, $10, $60, $10, $10, $18, $62, $10, $10, $00, $5c, $10
	db $10, $08, $5e, $10, $10, $f8, $5a, $10, $00, $00, $ff, $00, $f0, $18, $4a, $10
	db $f0, $08, $46, $10, $f0, $10, $48, $10, $f0, $f8, $42, $00, $f0, $00, $44, $00
	db $f0, $f0, $66, $00, $00, $20, $6a, $10, $00, $08, $52, $10, $00, $10, $54, $10
	db $00, $18, $56, $10, $00, $f8, $4e, $00, $00, $00, $50, $10, $00, $f0, $68, $00
	db $10, $20, $6c, $10, $10, $10, $60, $10, $10, $18, $62, $10, $10, $00, $5c, $10
	db $10, $08, $5e, $10, $10, $f8, $5a, $10

Call_05_580E::
	ldh a, [$fff1]
	sla a
	sla a
	sla a
	sla a
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $56d6
	ldh a, [$ffe7]
	and $01
	jr z, jr_005_582c

	ld hl, $5772

jr_005_582c:
	add hl, de
	ld c, $13
	call Call_3D26
	ld a, $13
	call Call_3DD0
	ret


	db $72, $00, $72, $20

Jump_05_583C::
	ld de, $5838
	call Call_3CD0
	call Call_05_7965
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $30
	jr z, jr_005_5865

	ld hl, $c250
	add hl, bc
	ld [hl], $f8
	call Call_05_79D4

jr_005_5865:
	ldh a, [$ffec]
	cp $10
	jp c, Call_05_7A6B

	ret


	db $74, $00, $76, $00, $76, $20, $74, $20

Jump_05_5875::
	ld de, $586d
	call Call_3C3B
	call Call_05_7965
	call Call_08E2
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	push af
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BB4
	pop af
	ld e, $fc
	and $10
	jr z, jr_005_589d

	ld e, $04

jr_005_589d:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	ld hl, $c250
	add hl, bc
	ld [hl], $0c
	call Call_05_79D1
	ldh a, [$ffec]
	cp $8b
	jp nc, Call_05_7A6B

	ret


	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $01, $ff, $08, $f8

Jump_05_58BF::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	rra
	rra
	and $20
	ldh [$ffed], a
	ld de, $58b3
	call Call_3C3B
	call Call_05_7965
	call Call_08E2
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BB4
	ldh a, [$ffe7]
	and $03
	jr nz, jr_005_5909

	ld hl, $c290
	add hl, bc
	ld a, [hl]
	and $01
	ld e, a
	ld d, b
	ld hl, $58bb
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $58bd
	add hl, de
	cp [hl]
	jr nz, jr_005_5909

	call Call_3B8D

jr_005_5909:
	call Call_05_79D1
	call Call_0891
	jr nz, jr_005_5918

	ldh a, [$ffee]
	cp $a8
	jp nc, Call_05_7A6B

jr_005_5918:
	ret


	db $07, $00, $0f, $07, $1e, $0f, $3f, $18, $3f, $10, $3f, $14, $3f, $10, $27, $1b
	db $e0, $00, $f0, $e0, $18, $f0, $8c, $78, $8c, $70, $3f, $c0, $ff, $3e, $ef, $f1
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $07, $03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f, $00, $ff, $3e, $ef, $f1
	db $21, $30, $c4, $09, $7e, $e6, $7f, $77, $1e, $0f, $50, $21, $80, $c2, $19, $70
	db $1d, $7b, $fe, $01, $20, $f5, $fa, $78, $d4, $a7, $28, $23, $3e, $05, $cd, $b9
	db $07, $cd, $3f, $5a, $21, $90, $c2, $19, $36, $07, $21, $e0, $c2, $19, $36, $60
	db $3e, $01, $e0, $a5, $cd, $8d, $3b, $36, $04, $3e, $c0, $ea, $10, $c2, $c9, $3e
	db $02, $e0, $a5, $ea, $78, $d4, $cd, $91, $08, $36, $80, $1e, $0c, $af, $21, $90
	db $d7, $22, $1d, $20, $fc, $3e, $02, $ea, $05, $d2, $3e, $5c, $ea, $68, $d3, $c9
	db $10, $f0

Call_05_59BB::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_59C1::
	dw Jump_05_59C9
	dw Jump_05_5AAB
	dw Jump_05_61A3
	dw Jump_05_6215

Jump_05_59C9::
	ldh a, [$fff0]
	rst $00

JumpTable_05_59CC::
	dw Jump_05_59D7
	dw Jump_05_5A16
	dw Jump_05_5A76
	dw Jump_05_5A7A
	dw Jump_05_5A8A

jr_005_59d6:
	ret


Jump_05_59D7::
	call Call_05_5A99
	ldh a, [$ffea]
	cp $05
	jr nz, jr_005_59d6

	ld a, $02

jr_005_59e2:
	ldh [$ffe8], a
	ld a, $63
	call Call_3C01
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $59b8
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	sub $10
	ld hl, $c210
	add hl, de
	ld [hl], a
	pop bc
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ldh a, [$ffe8]
	dec a
	jr nz, jr_005_59e2

	call Call_0891
	ld [hl], $43
	jp Call_3B8D


Jump_05_5A16::
	call Call_05_5A99
	call Call_05_7965
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	and a
	jr z, jr_005_5a3a

	cp $20
	jr nz, jr_005_5a75

	ldh a, [$ff99]
	push af
	ld a, $10
	ldh [$ff99], a
	ld a, $ba
	call Call_2197
	pop af
	ldh [$ff99], a
	ret


jr_005_5a3a:
	ld a, $54
	ld [$d368], a
	ld a, $63
	call Call_3C01
	ld hl, $c360
	add hl, de
	ld [hl], $0c
	ld hl, $c200
	add hl, de
	ld [hl], $d0
	ld hl, $c210
	add hl, de
	ld [hl], $18
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c240
	add hl, de
	ld [hl], $e0
	ld hl, $c380
	add hl, de
	ld [hl], $00
	ld hl, $c2e0
	add hl, de
	ld [hl], $80
	call Call_05_5B62
	call Call_3B8D
	ret


jr_005_5a75:
	ret


Jump_05_5A76::
	call Call_05_5A99
	ret


Jump_05_5A7A::
	call Call_05_5A99
	call Call_05_7965
	call Call_05_79D1
	ld hl, $c250
	add hl, bc
	inc [hl]
	inc [hl]
	ret


Jump_05_5A8A::
	ld hl, $c340
	add hl, bc
	ld [hl], $c2
	ret


	db $7e, $00, $7e, $20, $7e, $40, $7e, $60

Call_05_5A99::
	ld de, $5a91
	call Call_3C3B
	ret


	db $02, $02, $02, $00, $01, $00, $01, $04, $04, $04, $04

Jump_05_5AAB::
	call Call_05_613F
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_005_7d8d

	call Call_05_7965
	call Call_08E2
	ldh a, [$fff0]
	cp $0e
	jr z, jr_005_5af7

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5af7

	ld hl, $c420
	add hl, bc
	ld [hl], $50
	call Call_3DAF
	call Call_3B8D
	ld [hl], $0e
	ld a, $31
	ldh [$fff4], a
	ld hl, $c340
	add hl, bc
	ld [hl], $42
	ld hl, $c2d0
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
	ld [$d205], a
	ret


jr_005_5af7:
	ldh a, [$fff0]
	rst $00

JumpTable_05_5AFA::
	dw Jump_05_5B18
	dw Jump_05_5B2E
	dw Jump_05_5B74
	dw Jump_05_5B9F
	dw Jump_05_5BD0
	dw Jump_05_5BF2
	dw Jump_05_5C15
	dw Jump_05_5C5B
	dw Jump_05_5D33
	dw Jump_05_5D84
	dw Jump_05_5E82
	dw Jump_05_5EDB
	dw Jump_05_5EF1
	dw Jump_05_5F62
	dw Jump_05_5F73

Jump_05_5B18::
	call Call_05_79D1
	call Call_0891
	jr nz, jr_005_5b2d

	call Call_3B8D
	call Call_0891
	ld [hl], $20
	ld a, $ff
	call Call_3B87

jr_005_5b2d:
	ret


Jump_05_5B2E::
	call Call_0891
	jr nz, jr_005_5b66

	xor a
	call Call_3B87
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $14
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $02
	jr z, jr_005_5b67

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $80

Call_05_5B62::
	ld a, $22
	ldh [$fff4], a

jr_005_5b66:
	ret


jr_005_5b67:
	call Call_3B8D
	call Call_0891
	ld [hl], $30
	ld a, $30
	ldh [$fff4], a
	ret


Jump_05_5B74::
	call Call_05_79D1
	call Call_0891
	cp $01
	jr nz, jr_005_5b83

	ld hl, $fff2
	ld [hl], $30

jr_005_5b83:
	and a
	jr nz, jr_005_5b9e

	ld hl, $c240
	add hl, bc
	inc [hl]
	jr nz, jr_005_5b9b

	call Call_3B8D
	call Call_0891
	ld [hl], $40
	ld hl, $c29e
	inc [hl]
	inc hl
	inc [hl]

jr_005_5b9b:
	call Call_05_5BBF

jr_005_5b9e:
	ret


Jump_05_5B9F::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, Call_05_5BBF

	ld [hl], $28
	ld a, $d0
	ld [$c250], a
	ld a, $24
	ldh [$fff2], a
	ld a, $12
	ld [$c240], a
	ld hl, $c290
	inc [hl]
	call Call_3B8D

Call_05_5BBF::
	ld hl, $c3d0
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


Jump_05_5BD0::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_005_5beb

	ld a, $01
	ldh [$ffa5], a
	ld [hl], $20
	call Call_3B8D
	ld hl, $c290
	inc [hl]
	ld a, $c0
	ld [$c210], a

jr_005_5beb:
	jp Call_05_5BBF


	db $01, $02, $03, $02

Jump_05_5BF2::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, Call_05_5BFE

	call Call_3B8D

Call_05_5BFE::
	ld hl, $c3d0
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


Jump_05_5C15::
	call Call_05_79D1
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cp $d4
	jr nz, jr_005_5c42

	ldh a, [$ffee]
	and $f8
	cp $c0
	jr nz, jr_005_5c32

	call Call_3B8D
	call Call_0891
	ld [hl], $80
	ret


jr_005_5c32:
	ldh a, [$ffe7]
	and $00
	jr nz, jr_005_5c3d

	ld hl, $c250
	add hl, bc
	dec [hl]

jr_005_5c3d:
	xor a
	call Call_3B87
	ret


jr_005_5c42:
	dec [hl]
	dec [hl]
	call Call_05_5BFE
	call Call_05_5BFE
	jp Call_05_5BFE


	db $f8, $a8, $30, $d0, $30, $70, $dc, $24, $f8, $a8, $20, $e0, $04, $00

Jump_05_5C5B::
	call Call_0891
	jr nz, jr_005_5caf

	ld a, [$d205]
	rst $00

JumpTable_05_5C64::
	dw Jump_05_5C6E
	dw Jump_05_5CB0
	dw Jump_05_5CEA
	dw Jump_05_5CEA
	dw Jump_05_5CB0

Jump_05_5C6E::
	call Call_27ED
	and $03
	ld [$d205], a
	ld e, $00
	ldh a, [$ff98]
	cp $50
	jr nc, jr_005_5c7f

	inc e

jr_005_5c7f:
	ld d, b
	ld hl, $5c4d
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $5c4f
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ld [hl], $00
	ld hl, $c250
	add hl, bc
	ld [hl], $20
	call Call_3B8D
	ld [hl], $08

jr_005_5caf:
	ret


Jump_05_5CB0::
	ld e, $00
	ldh a, [$ff98]
	cp $50
	jr nc, jr_005_5cb9

	inc e

jr_005_5cb9:
	ld d, b
	ld hl, $5c51
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld [hl], b
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ld [hl], $f0
	ld hl, $c250
	add hl, bc
	ld [hl], $10
	call Call_3B8D
	ld [hl], $0b
	call Call_0891
	ld [hl], $30
	ret


Jump_05_5CEA::
	call Call_27ED
	and $01
	ld e, a
	ld d, b
	ld hl, $5c55
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $5c57
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], b
	ld hl, $5c59
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $3f
	add $18
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ldh a, [$ff9c]
	and a
	jr z, jr_005_5d28

	ldh a, [$ff99]
	ld [hl], a

jr_005_5d28:
	call Call_3B8D
	ld [hl], $0d
	call Call_0891
	ld [hl], $70
	ret


Jump_05_5D33::
	ld a, $01
	call Call_3B87
	call Call_05_79D1
	ld hl, $c250
	call Call_05_5D48
	ld a, [hl]
	and a
	jr z, jr_005_5d55

	ld hl, $c240

Call_05_5D48::
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
	call Call_0891
	ld [hl], $ff
	ret


	db $ee, $12, $d0, $30, $10, $f0, $d8, $d4, $d0, $cc, $c8, $c4, $c0, $bc, $28, $2c
	db $30, $34, $38, $3c, $40, $44, $30, $2e, $2c, $2a, $28, $26, $24, $22, $30, $2e
	db $2c, $2a, $28, $26, $24, $22

Jump_05_5D84::
	call Call_0891
	jp z, Jump_005_5e77

	ld hl, $c210
	add hl, bc
	ldh a, [$ffe7]
	and $03
	jr nz, jr_005_5d9d

	ldh a, [$ffe7]
	and $20
	jr z, jr_005_5d9c

	inc [hl]
	inc [hl]

jr_005_5d9c:
	dec [hl]

jr_005_5d9d:
	call Call_05_5BFE
	call Call_05_5BFE
	ldh a, [$ff9c]
	and a
	jr nz, jr_005_5dd1

	ld a, [$c146]
	and a
	jr z, jr_005_5dd1

	ld hl, $c380
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
	ld hl, $ff9a
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
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5d5e
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	push bc
	call Call_20E0
	call Call_3E49
	pop bc

jr_005_5dea:
	ld a, [$d210]
	inc a
	cp $22
	jr c, jr_005_5df7

	ld a, $32
	ldh [$fff4], a
	xor a

jr_005_5df7:
	ld [$d210], a
	call Call_0891
	cp $c0
	jr nc, jr_005_5e76

	ldh a, [$ffe7]
	and $0f
	jr nz, jr_005_5e76

	ld a, $63
	ld e, $03
	call Call_3C13
	jr c, jr_005_5e76

	ld hl, $c2b0
	add hl, de
	ld [hl], $03
	push bc
	ld hl, $c380
	add hl, bc
	ld c, [hl]
	srl c
	srl c
	ld hl, $5d62
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	add $0c
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ld a, c
	xor $01
	ld [hl], a
	ld hl, $c380
	add hl, de
	ld [hl], a
	sla c
	sla c
	sla c
	call Call_27ED
	and $07
	add c
	ld c, a
	ld hl, $5d74
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $5d64
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	pop bc
	ld hl, $c340
	add hl, de
	ld [hl], $02
	ld hl, $c430
	add hl, de
	ld [hl], $00
	ld hl, $c4d0
	add hl, de
	ld [hl], $02

jr_005_5e76:
	ret


Jump_005_5e77:
	call Call_3B8D
	call Call_0891
	ld [hl], $50
	ret


	db $e0, $20

Jump_05_5E82::
	call Call_05_79D1
	call Call_0891
	jr z, jr_005_5ec0

	ld hl, $c380
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
	ld hl, $c240
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
	call Call_05_5BFE
	call Call_05_5BFE
	ret


jr_005_5eb0:
	xor a
	call Call_3B87
	ldh a, [$ffe7]
	and $01
	jr nz, jr_005_5ebf

	ld hl, $c250
	add hl, bc
	dec [hl]

jr_005_5ebf:
	ret


Jump_005_5ec0:
jr_005_5ec0:
	ld hl, $c340
	add hl, bc
	ld [hl], $02
	call Call_3B8D
	ld [hl], $07
	call Call_0891
	ld a, [$d205]
	cp $04
	jr nz, jr_005_5ed8

	ld [hl], $10
	ret


jr_005_5ed8:
	ld [hl], $80
	ret


Jump_05_5EDB::
	call Call_05_79D1
	call Call_0891
	jr nz, jr_005_5eeb

	ld [hl], $30
	call Call_3B8D
	call Call_3DAF

jr_005_5eeb:
	call Call_05_5BFE
	ret


	db $e0, $20

Jump_05_5EF1::
	call Call_05_79D1
	call Call_0891
	jr nz, jr_005_5f33

	ldh a, [$ffec]
	cp $b0
	jp nc, Jump_005_5ec0

	ld a, $01
	call Call_3B87
	ld a, [$c13e]
	and a
	jr nz, jr_005_5f32

	call Call_3BB4
	ld a, [$c13e]
	and a
	jr z, jr_005_5f32

	ld a, $10
	ld [$c13e], a
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5eef
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld a, $f0
	ldh [$ff9b], a
	ld hl, $ff99
	dec [hl]

jr_005_5f32:
	ret


jr_005_5f33:
	cp $01
	jr nz, jr_005_5f51

	ld hl, $c380
	add hl, bc
	ld e, [hl]
	srl e
	srl e
	ld d, b
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], $34

jr_005_5f51:
	call Call_05_5BFE
	call Call_0891
	cp $40
	jr nc, jr_005_5f61

	call Call_05_5BFE
	call Call_05_5BFE

jr_005_5f61:
	ret


Jump_05_5F62::
	xor a
	call Call_3B87
	call Call_05_79D1
	call Call_3BB4
	call Call_0891
	jp z, Jump_005_5ec0

	ret


Jump_05_5F73::
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_5f8d

	cp $30
	jr nc, jr_005_5f8c

	dec a
	jr nz, jr_005_5f86

	ld a, $31
	ldh [$fff4], a

jr_005_5f86:
	call Call_05_5BFE
	call Call_05_5BFE

jr_005_5f8c:
	ret


jr_005_5f8d:
	call Call_05_5BFE
	call Call_05_5BFE
	call Call_05_5BFE
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $d0
	jr z, jr_005_5fa0

	dec [hl]

jr_005_5fa0:
	call Call_05_79D1
	ldh a, [$ffec]
	and $f0
	cp $c0
	jr nz, jr_005_5fae

	jp Jump_005_5ec0


jr_005_5fae:
	ret


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
	db $1c, $1c, $08, $0c, $14, $10, $10, $10, $f4, $1c, $08, $0c, $fc, $10, $10, $10

Call_05_613F::
	ld hl, $c380
	add hl, bc
	ldh a, [$fff1]
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
	ldh a, [$fff1]
	and a
	jr z, jr_005_6175

	ld e, $04

jr_005_6175:
	ld hl, $c380
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
	ld hl, $d580
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


	db $7c, $00, $7c, $20, $7c, $40, $7c, $60

Jump_05_61A3::
	ld a, $02
	ldh [$ffa1], a
	ld de, $619b
	call Call_3C3B
	call Call_05_7965
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_05_61BD::
	dw Jump_05_61C1
	dw Jump_05_61E6

Jump_05_61C1::
	ld hl, $c210
	add hl, bc
	ld e, $07
	call Call_05_61D0
	ld hl, $c200
	add hl, bc
	ld e, $00

Call_05_61D0::
	ldh a, [$ffe7]
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


Jump_05_61E6::
	call Call_05_79D1
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cp $c0
	jr z, jr_005_61f3

	dec [hl]

jr_005_61f3:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $f0
	jr z, jr_005_61fd

	dec [hl]

jr_005_61fd:
	ldh a, [$ffee]
	cp $e0
	jp nc, Call_05_7A6B

	ret


	db $7a, $20, $78, $20, $78, $00, $7a, $00, $7a, $60, $78, $60, $78, $40, $7a, $40

Jump_05_6215::
	ld de, $6205
	call Call_3C3B
	call Call_05_7965
	call Call_05_79D1
	ldh a, [$fff0]
	rst $00

JumpTable_05_6224::
	dw Jump_05_6228
	dw Jump_05_6247

Jump_05_6228::
	call Call_3BCA
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6242

	call Call_3B8D
	ld hl, $c250
	add hl, bc
	ld [hl], $e0
	ld hl, $c3b0
	add hl, bc
	inc [hl]
	inc [hl]

jr_005_6242:
	ld hl, $c250
	add hl, bc
	dec [hl]

Jump_05_6247::
	ldh a, [$ffee]
	cp $a8
	jp nc, Call_05_7A6B

	ret


	db $cd, $91, $08, $36, $40, $21, $b0, $c3, $09, $36, $ff, $21, $60, $c3, $09, $36
	db $ff, $c9

Call_05_6261::
	call Call_380E
	call Call_3F12
	ld hl, $c2b0
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
	ldh a, [$ffea]
	cp $01
	jr nz, jr_005_62c4

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_628B::
	dw Jump_05_628F
	dw Jump_05_629A

Jump_05_628F::
	call Call_0891
	ld [hl], $ff

Jump_005_6294:
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_05_629A::
	call Call_0891
	jp z, Jump_005_62ad

	ld hl, $c420
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_005_62ac

	call Call_05_7476

jr_005_62ac:
	ret


Jump_005_62ad:
	call Call_05_74AD
	ld hl, $c200
	add hl, de
	ldh a, [$ff98]
	ld [hl], a
	ld hl, $c210
	add hl, de
	ld [hl], $70
	ld hl, $c310
	add hl, de
	ld [hl], $70
	ret


jr_005_62c4:
	call Call_05_7965
	call Call_08E2
	ldh a, [$fff0]
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
	call Call_0891
	jr nz, jr_005_633b

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $62d7
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $62df
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $62e7
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $62ef
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	ld a, $16
	ldh [$fff3], a
	call Call_05_652E
	call Call_3B8D

jr_005_633b:
	ret


Jump_05_633C::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_6395

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $0b
	jr c, jr_005_6395

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_005_6394

	call Call_3B8D
	call Call_0891
	ld [hl], $40
	ld hl, $c240
	add hl, bc
	ld [hl], $18
	ld hl, $c250
	add hl, bc
	ld [hl], $18
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_0887
	ld [hl], $40
	ldh a, [$ffee]
	add $f8
	ldh [$ffd7], a
	call Call_05_6383
	ldh a, [$ffee]
	add $08
	ldh [$ffd7], a

Call_05_6383::
	ldh a, [$ffec]
	sub $10
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld hl, $c520
	add hl, de
	ld [hl], $0f

jr_005_6394:
	ret


jr_005_6395:
	call Call_05_79D1
	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_63c2

	ld [hl], b
	call Call_0891
	ld [hl], $40
	call Call_3B8D
	ld [hl], b
	call Call_05_6566
	call Call_05_652E
	ld a, $32
	ldh [$fff2], a
	ld a, $ff
	jp Call_3B87


jr_005_63c2:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $05
	jp nc, Jump_005_64c1

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_63de

	ldh a, [$ffe7]
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
	call Call_0891
	jr z, jr_005_6400

	and $02
	ld e, $08
	jr z, jr_005_63f1

	ld e, $f8

jr_005_63f1:
	ld hl, $c240
	add hl, bc
	push hl
	ld a, [hl]
	push af
	ld [hl], e
	call Call_05_79DE
	pop af
	pop hl
	ld [hl], a
	ret


jr_005_6400:
	call Call_3BB4
	call Call_0887
	jr nz, jr_005_641d

	ldh a, [$ffee]
	cp $70
	jr nc, jr_005_641d

	ldh a, [$ffec]
	cp $50
	jr nc, jr_005_641d

	call Call_3DAF
	call Call_3B8D
	ld [hl], $01
	ret


jr_005_641d:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_005_6448

	ldh a, [$ffee]
	cp $70
	jr nc, jr_005_6448

	ldh a, [$ffec]
	cp $50
	jr nc, jr_005_6448

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $05
	jr c, jr_005_6448

	call Call_3B8D
	call Call_3DAF
	call Call_0891
	ld [hl], $80
	ret


jr_005_6448:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $0b
	jr nc, jr_005_6487

	call Call_05_79D1
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	push af
	and $03
	jr z, jr_005_6467

	ld hl, $c240
	call Call_05_646F

jr_005_6467:
	pop af
	and $0c
	jr z, jr_005_6474

	ld hl, $c250

Call_05_646F::
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_005_6474:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_005_6487

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $0a
	call Call_0953

jr_005_6487:
	ret


Jump_05_6488::
	call Call_0891
	cp $40
	jr c, jr_005_64af

	jr nz, jr_005_6498

	ld a, $29
	ldh [$fff4], a
	call Call_05_64D4

jr_005_6498:
	and $02
	ld e, $10
	jr z, jr_005_64a0

	ld e, $f0

jr_005_64a0:
	ld hl, $c240
	add hl, bc
	push hl
	ld a, [hl]
	push af
	ld [hl], e
	call Call_05_79DE
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
	ld hl, $c360
	add hl, bc
	ld [hl], $08
	ret


Jump_005_64c1:
jr_005_64c1:
	ldh a, [$ffe7]
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
	ldh [$ffe8], a
	ld a, $62
	call Call_3C01
	jr c, jr_005_6528

	ld hl, $c2b0
	add hl, de
	ld [hl], $03
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $64cf
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ldh a, [$ffe8]
	dec a
	ld [hl], a
	ld hl, $64d1
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, de
	ld [hl], $04
	pop bc
	ld hl, $c320
	add hl, de
	ld [hl], $08
	ld hl, $c340
	add hl, de
	ld [hl], $42

jr_005_6528:
	ldh a, [$ffe8]
	dec a
	jr nz, jr_005_64d6

	ret


Call_05_652E::
	ld a, $62
	call Call_3C01
	jr c, jr_005_6555

	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $14
	ld hl, $c340
	add hl, de
	ld [hl], $c4

jr_005_6555:
	ret


	db $f8, $08, $f8, $08, $fc, $fc, $04, $04, $f4, $0c, $f4, $0c, $f4, $f4, $0c, $0c

Call_05_6566::
	ld a, $04

jr_005_6568:
	ldh [$ffe8], a
	ld a, $62
	call Call_3C01
	jr c, jr_005_65b4

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $6555
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $6559
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $655d
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $6561
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc
	ld hl, $c320
	add hl, de
	ld [hl], $13
	ld hl, $c340
	add hl, de
	ld [hl], $42

jr_005_65b4:
	ldh a, [$ffe8]
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
	ldh a, [$fff1]
	cp $02
	jr nc, Call_05_66AC

	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
	ldh a, [$fff1]
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
	ldh a, [$fff1]
	cp $05
	jr nc, jr_005_66ab

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	dec a
	cp $08
	jr c, jr_005_66ab

	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ldh a, [$ffef]
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld hl, $664a
	ld c, $04
	call Call_3D26
	call Call_3DBA

jr_005_66ab:
	ret


Call_05_66AC::
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ldh a, [$fff1]
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
	call Call_0891
	jp z, Call_05_7A6B

	cp $0a
	ld a, $05
	jr c, jr_005_66dc

	inc a

jr_005_66dc:
	ldh [$fff1], a
	call Call_05_66AC
	ret


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $7a, $00, $7a, $20, $78, $00, $78, $20

Jump_005_66f2:
	ld de, $66e2
	call Call_3C3B
	call Call_05_7965
	call Call_3BBF
	ldh a, [$fff0]
	rst $00

JumpTable_05_6701::
	dw Jump_05_6705
	dw Jump_05_672D

Jump_05_6705::
	call Call_05_79D1
	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6722

	ld [hl], b
	call Call_3B8D
	call Call_0891
	ld [hl], $0f

jr_005_6722:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_05_672D::
	call Call_0891
	jp z, Call_05_7A6B

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
	call Call_05_7965
	call Call_05_79D1
	call Call_05_7A0A
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_005_6775

	xor a
	ld [hl], a
	call Call_0891
	ld [hl], $0f
	ld hl, $c2b0
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
	ldh a, [$fff7]
	cp $07
	jr nz, jr_005_67d7

	ld a, $10
	ldh [$fff5], a

jr_005_67d7:
	call Call_05_699A
	call Call_05_7965
	call Call_3F12
	call Call_08E2
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_05_67E9::
	dw Jump_05_67EF
	dw Jump_05_68B5
	dw Jump_05_690F

Jump_05_67EF::
	call Call_0891
	jr nz, jr_005_67f9

	ld [hl], $00
	call Call_3B8D

jr_005_67f9:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	and $3f
	ld [hl], a
	ldh [$ffd7], a
	rra
	rra
	nop
	and $03
	ld e, a
	ld d, $00
	ld hl, $67c5
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld hl, $67c9
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	ld hl, $c460
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
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	ld e, a
	add hl, de
	ldh a, [$ffee]
	ld [hl], a
	pop de
	ld hl, $d100
	add hl, de
	ldh a, [$ffd7]
	ld e, a
	add hl, de
	ldh a, [$ffec]
	ld [hl], a
	call Call_05_79D1
	call Call_3B9E
	ld e, $0f
	ld d, b

jr_005_6854:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_005_68b1

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_005_68b1

	ld hl, $c2e0
	add hl, de
	ld a, [hl]
	cp $38
	jr c, jr_005_68b1

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_005_68b1

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_005_68b1

	ld hl, $c310
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_005_68b1

	ld hl, $c280
	add hl, de
	ld [hl], b
	call Call_3B8D
	ld [hl], $02
	ld hl, $c300
	add hl, bc
	ld [hl], $60
	ld hl, $c420
	add hl, bc
	ld [hl], $0c
	ld hl, $c440
	add hl, bc
	inc [hl]
	ld a, $2a
	ldh [$fff2], a
	ret


jr_005_68b1:
	dec e
	jr nz, jr_005_6854

	ret


Jump_05_68B5::
	call Call_0891
	jr nz, jr_005_68fe

	call Call_27ED
	and $1f
	add $40
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
	jr nz, jr_005_68d6

	call Call_05_7A44
	jr jr_005_68dc

jr_005_68d6:
	call Call_27ED
	and $03
	ld e, a

jr_005_68dc:
	ld hl, $fff1
	xor [hl]
	and $02
	jr z, jr_005_68d6

	ld d, b
	ld hl, $c3b0
	add hl, bc
	ld [hl], e
	ld hl, $67bd
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $67c1
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_005_68fe:
	ret


	db $f3, $0d, $00, $00, $00, $00, $0d, $f3, $0c, $f4, $00, $00, $00, $00, $f4, $0c

Jump_05_690F::
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_6922

	call Call_0891
	ld [hl], $30
	call Call_3B8D
	ld [hl], $01
	ret


jr_005_6922:
	cp $24
	jr nz, jr_005_6929

	call Call_08D7

jr_005_6929:
	cp $04
	jr nz, jr_005_6949

	ldh a, [$fff1]
	ld e, a
	ld d, b
	ld hl, $6907
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffd7], a
	ld hl, $690b
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	xor a

jr_005_6949:
	cp $20
	jr nz, jr_005_6985

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_005_6985

	ld a, $02
	call Call_3C01
	jr c, jr_005_6985

	ld hl, $c2e0
	add hl, de
	ld [hl], $17
	push bc
	ld hl, $c3b0
	add hl, bc
	ld c, [hl]
	ld hl, $68ff
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $6903
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	pop bc
	call Call_05_7DC0

jr_005_6985:
	ret


	db $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20, $60, $00, $60, $20
	db $68, $00, $68, $20

Call_05_699A::
	call Call_088C
	ld hl, $c124
	or [hl]
	ld hl, $c300
	add hl, bc
	or [hl]
	jp nz, Jump_005_6bda

	ldh a, [$fff1]
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
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	push bc
	ld hl, $c460
	add hl, bc
	ld e, [hl]
	ld hl, $c2b0
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
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	pop de
	ld hl, $d100
	add hl, de
	ldh a, [$ffd7]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	pop bc
	ld de, $6986
	call Call_3C3B
	ret


Call_05_6A08::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	push bc
	ld hl, $c460
	add hl, bc
	ld e, [hl]
	ld hl, $c2c0
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
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	pop de
	ld hl, $d100
	add hl, de
	ldh a, [$ffd7]
	sub c
	and $3f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	pop bc
	ld a, $04
	ldh [$fff1], a
	ld de, $6986
	call Call_3C3B
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
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
	ld hl, $c300
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
	ldh a, [$fff1]
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
	ldh a, [$fff1]
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
	call Call_08E2
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_6C50::
	dw Jump_05_6C56
	dw Jump_05_7207
	dw Jump_05_74F9

Jump_05_6C56::
	ld a, c
	ld [$d201], a
	ldh a, [$fff0]
	rst $00

JumpTable_05_6C5D::
	dw Jump_05_6C65
	dw Jump_05_6CA9
	dw Jump_05_6D95
	dw Call_05_700B

Jump_05_6C65::
	call Call_0891
	jr nz, jr_005_6c80

	ld [hl], $80
	ld a, $ff
	ld [$c157], a
	ld a, $3e
	ldh [$fff4], a
	ld [$d3e8], a
	ld a, $04
	ld [$c158], a
	call Call_3B8D

jr_005_6c80:
	ret


	db $20, $60, $20, $60, $00, $00, $70, $70, $08, $08, $08, $08, $09, $0b, $0b, $0a
	db $08, $08, $08, $08, $09, $0b, $0b, $0a, $05, $07, $07, $06, $04, $04, $04, $04
	db $05, $07, $07, $06, $04, $04, $04, $04

Jump_05_6CA9::
	ld a, $38
	ldh [$ffce], a
	add $10
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld a, $30
	ldh [$ffcd], a
	add $18
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_0891
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
	call Call_088C
	ld [hl], $1f
	call Call_0887
	ld [hl], $b0
	call Call_3E64
	ld hl, $c280
	add hl, bc
	ld [hl], $05
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	call Call_3E64
	ld hl, $c280
	add hl, bc
	ld [hl], $05
	call Call_3E64
	call Call_08D7
	ld hl, $c280
	add hl, bc
	ld [hl], $05
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $1c
	ld [$d600], a
	call Call_05_6D2D
	call Call_05_6D2D
	call Call_05_6D2D

Call_05_6D2D::
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ldh [$ffd0], a
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

	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $1c
	ld [$d600], a
	call Call_05_6D62

Call_05_6D62::
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ldh [$ffd0], a
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
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ldh [$ffd0], a
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
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	push af
	call Call_05_700B
	pop af
	ld hl, $c210
	add hl, bc
	ld [hl], a
	pop af
	ld hl, $c200
	add hl, bc
	ld [hl], a
	call Call_3DBA
	call Call_0891
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
	ld hl, $c3d0
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
	ldh [$ffce], a
	ld hl, $6c85
	add hl, de
	ld a, [hl]
	ldh [$ffcd], a
	sla e
	sla e
	sla e
	ld hl, $6c89
	add hl, de
	push hl
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0e
	ld [$d600], a
	pop de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
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
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
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
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c200
	add hl, de
	ldh a, [$ffce]
	add $10
	ld [hl], a
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffcd]
	add $10
	ld [hl], a
	ld hl, $c210
	add hl, bc
	add $08
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $2f
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $03
	ld a, $00
	jr c, jr_005_6e97

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	ld a, $01

jr_005_6e97:
	ld hl, $c380
	add hl, de
	ld [hl], a
	call Call_3E64
	ld hl, $c280
	add hl, bc
	ld [hl], $05
	call Call_08D7

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
	call Call_0887
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

	ld hl, $c360
	add hl, de
	ld [hl], $ff
	ld hl, $c3b0
	add hl, de
	ld [hl], $ff
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c290
	add hl, de
	ld [hl], $01
	push bc
	call Call_27ED
	and $03
	ld c, a
	ld hl, $6fff
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c2c0
	add hl, de
	ld [hl], a
	ld hl, $7003
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2d0
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $5f
	ld hl, $7007
	add hl, bc
	ld a, [hl]
	ld hl, $c380
	add hl, de
	ld [hl], a
	pop bc

jr_005_7071:
	call Call_088C
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
	ld hl, $c2d0
	add hl, bc
	ld [hl], a

jr_005_7087:
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and $07
	ld hl, $d200
	or [hl]
	jr nz, jr_005_70a8

	ldh a, [$fff0]
	cp $03
	jr nz, jr_005_70a8

	ld hl, $c390
	add hl, bc
	ld e, [hl]
	ld hl, $c2c0
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

	ld hl, $c440
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	and $1f

jr_005_70ba:
	ldh [$ffe8], a
	ld hl, $c200
	add hl, bc
	ld [hl], $50
	ld hl, $c210
	add hl, bc
	ld [hl], $48
	ldh a, [$ffe8]
	ld e, a
	ld d, b
	ld hl, $6f71
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, $c2d0
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
	ldh a, [$ffe8]
	ld e, a
	ld d, b
	ld hl, $6f91
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, $c2d0
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
	ldh a, [$ffe8]
	ld e, a
	ld d, b
	ld hl, $6fb1
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, $c2d0
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
	ldh a, [$ffe8]
	ld e, a
	ld d, b
	ld hl, $6fd1
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	add [hl]
	and $1f
	ld e, a
	ld d, b
	push de
	ld hl, $c2d0
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
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	push de
	ld hl, $c2d0
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
	ldh [$fff1], a
	add hl, de
	ld a, $48
	add [hl]
	ldh [$ffec], a
	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a
	ld a, $50
	add [hl]
	ldh [$ffee], a
	call Call_05_7200
	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

	ldh a, [$ff99]
	ld hl, $ffec
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_71e9

	ld a, [$c11c]
	and a
	jr nz, jr_005_71e9

	call Call_3B93
	ld a, $18
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a

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
	call Call_05_7965
	ldh a, [$fff0]
	rst $00

JumpTable_05_7210::
	dw Jump_05_7226
	dw Jump_05_7285
	dw Jump_05_7348
	dw Jump_05_73D5
	dw Jump_05_7460

	db $09, $0a, $0b, $0b, $0b, $0b, $0c, $0d, $0e, $0e, $0e, $0e

Jump_05_7226::
	call Call_0891
	jp z, Call_05_7459

	ld e, a
	cp $18
	jr nz, jr_005_7235

	ld a, $16
	ldh [$fff3], a

jr_005_7235:
	ld a, e
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $c380
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
	call Call_0891
	jp z, Call_05_7459

	ld e, a
	cp $20
	jr nz, jr_005_7294

	ld a, $16
	ldh [$fff3], a

jr_005_7294:
	ld a, e
	rra
	rra
	and $1f
	ld e, a
	ld d, b
	ld hl, $c380
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
	ldh a, [$ff9e]
	and $02
	jp z, Jump_005_7347

	ld a, [$c1a6]
	and a
	jp z, Jump_005_7347

	dec a
	ld [$d202], a
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7347

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_005_7347

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_005_7347

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_005_7347

	ld a, [$d203]
	inc a
	ld [$d203], a
	cp $04
	jr c, jr_005_7337

	call Call_27ED
	and $01
	jr nz, jr_005_7337

	ld hl, $c2b0
	add hl, bc
	ld [hl], $02
	call Call_0887
	ld [hl], $30
	ld hl, $c300
	add hl, bc
	ld [hl], $20
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7281
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $7283
	add hl, de
	ld a, [hl]
	ld hl, $c290
	add hl, bc
	ld [hl], a
	call Call_05_76A1
	ret


jr_005_7337:
	call Call_3B8D
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c390
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
	ld a, [$d202]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_739c

	ld a, [$dbc7]
	and a
	jr nz, jr_005_739c

	ld hl, $c210
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c2d0
	add hl, de
	ld a, [hl]
	cp $00
	jr z, jr_005_7382

	ldh a, [$ffe7]
	and $03
	jr nz, jr_005_7382

	dec [hl]

jr_005_7382:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_005_738c

	ld a, $29
	ldh [$fff2], a

jr_005_738c:
	ld hl, $c380
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
	call Call_0891
	ld [hl], $5f
	ret


	db $10, $10, $0c, $08, $04, $03, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $03, $1f, $1f, $3f, $3f, $3f, $3f, $3f
	db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f

Jump_05_73D5::
	call Call_05_78D2
	ld a, $01
	ld [$d200], a
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	ld a, $08
	jr z, jr_005_73e9

	ld a, $0f

jr_005_73e9:
	call Call_3B87
	ldh a, [$ff98]
	push af
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ldh [$ff98], a
	ldh a, [$ff99]
	push af
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ldh [$ff99], a
	call Call_0891
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $73a5
	add hl, de
	ld a, [hl]
	call Call_3C30
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_05_79D1
	ldh a, [$ff99]
	ld hl, $ffec
	sub [hl]
	add $03
	cp $06
	jr nc, jr_005_7431

	call Call_05_7459

jr_005_7431:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_0891
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $73bd
	add hl, de
	ldh a, [$ffe7]
	and [hl]
	jr nz, jr_005_7458

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c2d0
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
	jp Call_05_7A6B


Jump_05_7460::
	call Call_05_78D2
	call Call_0891
	jp z, Call_05_74AD

	ld hl, $c420
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

	call Call_27ED
	and $1f
	sub $10
	ld e, a
	ld hl, $ffee
	add [hl]
	ld [hl], a
	call Call_27ED
	and $1f
	sub $10
	ld e, a
	ld hl, $ffec
	add [hl]
	ld [hl], a
	call Call_05_7498

jr_005_7497:
	ret


Call_05_7498::
	call Call_05_796B
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $13
	ldh [$fff4], a
	ret


Call_05_74AD::
	ld a, $36
	call Call_3C01
	jr jr_005_74c1

Jump_005_74b4:
	ld a, $36
	call Call_3C01
	ld a, $48
	ldh [$ffd7], a
	ld a, $10
	ldh [$ffd8], a

jr_005_74c1:
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$fff9]
	and a
	jr z, jr_005_74dc

	ld hl, $c250
	add hl, bc
	ld [hl], $f0
	jr jr_005_74e8

jr_005_74dc:
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ld hl, $c310
	add hl, de
	ld [hl], $08

jr_005_74e8:
	call Call_05_7A6B
	ld hl, $fff4
	ld [hl], $1a
	ret


	db $03, $05, $00, $04, $02, $06, $01, $07

Jump_05_74F9::
	call Call_05_7597
	call Call_3DBA
	call Call_05_7965
	ld a, $01
	ld [$d200], a
	call Call_0887
	cp $10
	jr nc, jr_005_7549

	and a
	jr nz, jr_005_7541

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c2f0
	add hl, de
	ld [hl], $1f
	ld a, $02
	call Call_3C01
	call Call_08D7
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $17
	ld hl, $c440
	add hl, de
	ld [hl], $01
	jp Call_05_7459


jr_005_7541:
	ldh a, [$ffe7]
	ld hl, $c420
	add hl, bc
	ld [hl], a
	ret


jr_005_7549:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_005_755d

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c2d0
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_755d

	dec [hl]

jr_005_755d:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	and $7f
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ldh a, [$ffee]
	ld [hl], a
	ld hl, $d100
	add hl, de
	ldh a, [$ffec]
	ld [hl], a
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7583

	call Call_05_79D1
	jr jr_005_7586

jr_005_7583:
	call Call_05_762C

jr_005_7586:
	ld hl, $c290
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
	ldh a, [$fff1]
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
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ldh a, [$ffd7]
	sub $0c
	and $7f
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $d100
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, $00
	ldh [$fff1], a
	ld de, $71ec
	call Call_3C3B
	ldh a, [$ffd7]
	sub $18
	and $7f
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $d100
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, $00
	ldh [$fff1], a
	ld de, $71ec
	call Call_3C3B
	ldh a, [$ffd7]
	sub $24
	and $7f
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $d100
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, $02
	ldh [$fff1], a
	ld de, $71ec
	call Call_3C3B
	ret


	db $00, $06, $0c, $0e, $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e

Call_05_762C::
	call Call_05_79D1
	call Call_3BBF
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_765a

	call Call_27ED
	rra
	jr c, jr_005_764b

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_005_764b:
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	add $08
	and $0f
	ld [hl], a
	call Call_0891
	ld [hl], $10

jr_005_765a:
	call Call_088C
	jr nz, jr_005_7688

	ld [hl], $04
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c290
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, $c290
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7618
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $761c
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_005_7688:
	call Call_0891
	jr nz, jr_005_76a0

	call Call_27ED
	and $1f
	add $10
	ld [hl], a
	call Call_27ED
	and $02
	dec a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

jr_005_76a0:
	ret


Call_05_76A1::
	ld e, $80
	ld hl, $d100

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
	ldh a, [$fff1]
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
	ldh a, [$ffe7]
	and $10
	ld a, $03
	jr z, jr_005_78db

	inc a

jr_005_78db:
	ldh [$fff1], a
	nop

jr_005_78de:
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $78d0
	add hl, de
	ld a, [hl]
	ld hl, $ffec
	add [hl]
	ld [hl], a
	cp $14
	jr c, jr_005_794a

	cp $7c
	jr nc, jr_005_794a

	ld de, $71ec
	call Call_3C3B
	ldh a, [$fff0]
	cp $04
	jr nc, jr_005_7948

	ldh a, [$fff1]
	and a
	jr z, jr_005_7945

	xor a
	ldh [$fff1], a
	call Call_3BEB
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $16
	jr nz, jr_005_7945

	ld hl, $d204
	inc [hl]
	ld a, [hl]
	cp $08
	jr nz, jr_005_7945

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld [hl], b
	call Call_3B8D
	ld [hl], $04
	call Call_0891
	ld [hl], $ff
	call Call_27D2
	ld a, $03
	ld [$c5a7], a
	ld a, $5e
	ld [$d368], a
	ld a, $b5
	call Call_2197

jr_005_7945:
	call Call_3BBF

jr_005_7948:
	jr jr_005_78de

jr_005_794a:
	call Call_3DBA
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_7964

	ld hl, $c430
	add hl, bc
	ld [hl], $c0
	call Call_3BEB
	ld hl, $c430
	add hl, bc
	ld [hl], $80

jr_005_7964:
	ret


Call_05_7965::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_005_7985

Call_05_796B::
	ld a, [$db95]
	cp $07
	jr z, jr_005_7985

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_005_7985

	ld a, [$c124]
	and a
	jr z, jr_005_7986

jr_005_7985:
	pop af

jr_005_7986:
	ret


	db $21, $10, $c4, $09, $7e, $a7, $28, $41, $3d, $77, $cd, $b8, $3e, $21, $40, $c2
	db $09, $7e, $f5, $21, $50, $c2, $09, $7e, $f5, $21, $f0, $c3, $09, $7e, $21, $40
	db $c2, $09, $77, $21, $00, $c4, $09, $7e, $21, $50, $c2, $09, $77, $cd, $d1, $79
	db $21, $30, $c4, $09, $7e, $e6, $20, $20, $03, $cd, $9e, $3b, $21, $50, $c2, $09
	db $f1, $77, $21, $40, $c2, $09, $f1, $77, $f1, $c9

Call_05_79D1::
	call Call_05_79DE

Call_05_79D4::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_05_79DE
	pop bc
	ret


Call_05_79DE::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7a09

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

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


Call_05_7A0A::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7a09

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_005_79f6

Call_05_7A24::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_005_7a32

	inc e

jr_005_7a32:
	ld d, a
	ret


Call_05_7A34::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_005_7a42

	inc e

jr_005_7a42:
	ld d, a
	ret


Call_05_7A44::
	call Call_05_7A24
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_005_7a51

	cpl
	inc a

jr_005_7a51:
	push af
	call Call_05_7A34
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_005_7a5f

	cpl
	inc a

jr_005_7a5f:
	pop de
	cp d
	jr nc, jr_005_7a67

	ldh a, [$ffd7]
	jr jr_005_7a69

jr_005_7a67:
	ldh a, [$ffd8]

jr_005_7a69:
	ld e, a
	ret


Call_05_7A6B::
	ld hl, $c280
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
	ld a, [$c166]
	cp $01
	jr nz, jr_005_7b16

	call Call_05_7BF5
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	ldh [$fff0], a

jr_005_7b16:
	ldh a, [$fff1]
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
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_005_7d8d

	call Call_05_7965
	call Call_3F12
	call Call_3BB4
	call Call_05_79D1
	call Call_3B9E
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_05_7B4E::
	dw Jump_05_7B56
	dw Jump_05_7B72
	dw Jump_05_7C83
	dw Jump_05_7D2B

Jump_05_7B56::
	call Call_27ED
	and $01
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7a71
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ld [hl], $01
	ret


Jump_05_7B72::
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	call Call_088C
	jp nz, Jump_005_7c09

	call Call_0891
	jr z, jr_005_7ba9

	cp $01
	jr nz, jr_005_7bbc

	call Call_05_7A24
	ld d, b
	ld hl, $7a73
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], b
	call Call_088C
	call Call_27ED
	and $3f
	add $60
	ld [hl], a
	jp Jump_005_7c09


jr_005_7ba9:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, $ff99
	cp [hl]
	jp c, Jump_005_7bd3

	call Call_0891
	ld [hl], $60

jr_005_7bbc:
	ld hl, $c250
	add hl, bc
	ld [hl], b
	ld hl, $c240
	add hl, bc
	and $04
	jr nz, jr_005_7bce

	ld [hl], $08
	jp Jump_005_7c61


jr_005_7bce:
	ld [hl], $f8
	jp Jump_005_7c61


Jump_005_7bd3:
	ld hl, $c210
	add hl, bc
	ldh a, [$ff99]
	sub [hl]
	cp $28
	jr nc, jr_005_7c09

	ld hl, $c480
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_005_7c09

	call Call_27ED
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
	ld hl, $c300
	add hl, bc
	ld [hl], $40
	ld a, $01
	call Call_05_7C80
	ret


Jump_005_7c09:
jr_005_7c09:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_005_7c2a

	call Call_088C
	jr z, jr_005_7c22

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jp Jump_005_7c61


jr_005_7c22:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_005_7c2a:
	call Call_088C
	jr nz, jr_005_7c61

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $7a71
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	jr jr_005_7c69

jr_005_7c42:
	call Call_0891
	ld [hl], $60
	call Call_088C
	ld [hl], b
	call Call_3B8D
	ld [hl], $02
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ld hl, $c2d0
	add hl, bc
	ld [hl], a
	jr jr_005_7c69

Jump_005_7c61:
jr_005_7c61:
	ldh a, [$ffe7]
	and $07
	jr z, jr_005_7c6f

	jr jr_005_7c7b

jr_005_7c69:
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_005_7c7b

jr_005_7c6f:
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_005_7c7b

	ld [hl], $00

jr_005_7c7b:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]

Call_05_7C80::
	jp Call_3B87


Jump_05_7C83::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_005_7cfd

	call Call_0891
	cp $02
	jr nc, jr_005_7ced

	cp $00
	jr z, jr_005_7cc9

	ld hl, $ff99
	ld a, [hl]
	ld hl, $c390
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $02
	jr z, jr_005_7cb3

	call Call_3DAF
	ld hl, $c250
	add hl, bc
	ld [hl], $10
	jp Jump_005_7cb8


jr_005_7cb3:
	ld a, $10
	call Call_3C25

Jump_005_7cb8:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld hl, $ff99
	cp [hl]
	jp nc, Jump_005_7d09

	jp Jump_005_7d11


jr_005_7cc9:
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	sub $08
	ld hl, $c210
	add hl, bc
	cp [hl]
	jp nc, Jump_005_7d11

	ld hl, $c2b0
	add hl, bc
	inc [hl]
	call Call_3DAF
	ld hl, $c250
	add hl, bc
	ld [hl], $f0
	ld a, $16
	ldh [$fff3], a
	jp Jump_005_7d11


jr_005_7ced:
	ld hl, $c240
	add hl, bc
	and $04
	jr nz, jr_005_7cf9

	ld [hl], $08
	jr jr_005_7d11

jr_005_7cf9:
	ld [hl], $f8
	jr jr_005_7d11

Jump_005_7cfd:
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr c, jr_005_7d11

Jump_005_7d09:
	call Call_3DAF
	call Call_3B8D
	ld [hl], $01

Jump_005_7d11:
jr_005_7d11:
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_005_7d23

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_005_7d23

	ld [hl], $00

jr_005_7d23:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	jp Call_3B87


Jump_05_7D2B::
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_005_7d34

	ret


jr_005_7d34:
	call Call_088C
	cp $02
	jr nc, jr_005_7d5b

	cp $00
	jr z, jr_005_7d56

	ld hl, $c350
	add hl, bc
	ld [hl], $80
	ld a, $01
	call Call_3B87
	call Call_3B8D
	ld [hl], $01
	ld hl, $c300
	add hl, bc
	ld [hl], $40
	ret


jr_005_7d56:
	call Call_088C
	ld [hl], $30

jr_005_7d5b:
	cp $18
	jr nz, jr_005_7d82

	ld a, $7d
	call Call_3C01
	jr c, jr_005_7d82

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
	inc [hl]
	push bc
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_005_7d82:
	ld hl, $c350
	add hl, bc
	ld [hl], $00
	ld a, $04
	jp Call_3B87


Jump_005_7d8d:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_05_7D93::
	dw Jump_05_7D99
	dw Jump_05_7DAA
	dw Jump_05_7DBB

Jump_05_7D99::
	call Call_0891
	ld [hl], $a0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff

Call_05_7DA4::
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_05_7DAA::
	call Call_0891
	jr nz, jr_005_7dba

	ld [hl], $c0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_05_7DA4

jr_005_7dba:
	ret


Jump_05_7DBB::
	call Call_0891
	jr nz, jr_005_7df8

Call_05_7DC0::
	ld a, $1a
	ldh [$fff4], a
	ldh a, [$ffeb]
	cp $63
	jp z, Jump_005_74b4

	call Call_3F7A
	ld e, $0f
	ld d, b

jr_005_7dd1:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_005_7de2

	ld hl, $c430
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
	ld [$c1cf], a
	call Call_27BD
	ret


jr_005_7df0:
	ldh a, [$fff7]
	cp $05
	ret nc

	jp Jump_005_7dfc


jr_005_7df8:
	call Call_05_7476
	ret


Jump_005_7dfc:
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ldh a, [$fff7]
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
