; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

	db $50, $00, $52, $00, $54, $00, $56, $00, $50, $00, $52, $00, $54, $00, $56, $00
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5a, $20, $58, $20, $5e, $20, $5c, $20

Call_06_4020::
	ld a, $21
	ldh [$ffec], a
	ld de, $4000
	call Call_3C3B
	call Call_06_64DF
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_006_403b

	call Call_06_65BE
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_006_403b:
	call Call_06_6470
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_4049

	call Call_06_6449

jr_006_4049:
	ldh a, [$fff0]
	rst $00

JumpTable_06_404C::
	dw Jump_06_4056
	dw Jump_06_4068
	dw Jump_06_40C7
	dw Jump_06_40DA
	dw Jump_06_40EC

Jump_06_4056::
	call Call_3B8D
	ld a, [$db15]
	cp $06
	ret c

	ld [hl], $04
	ld hl, $c200
	add hl, bc
	ld [hl], $58
	ret


Jump_06_4068::
	call Call_06_648C
	jr nc, jr_006_40c6

	ld a, [$db56]
	and a
	jr z, jr_006_4078

	ld e, $2d
	jp Jump_006_40c2


jr_006_4078:
	ldh a, [$fff8]
	and $10
	jr z, jr_006_4084

	ld a, [$db15]
	and a
	jr nz, jr_006_40a1

jr_006_4084:
	ldh a, [$fff8]
	or $10
	ldh [$fff8], a
	ld [$dac7], a
	ld a, $3a
	call Call_2185
	ld a, [$db55]
	cp $02
	jr nc, jr_006_409e

	ld a, $02
	ld [$db55], a

jr_006_409e:
	jp Call_3B8D


jr_006_40a1:
	ld e, $3f
	cp $05
	jr c, jr_006_40c2

	call Call_3B8D
	ld [hl], $03
	call Call_0891
	ld [hl], $20
	ld hl, $c2b0
	add hl, bc
	ld [hl], $01
	ld a, $ff
	ld [$db15], a
	ld a, $09
	ldh [$ffa5], a
	ld e, $3d

Jump_006_40c2:
jr_006_40c2:
	ld a, e
	call Call_2185

jr_006_40c6:
	ret


Jump_06_40C7::
	ld a, [$c177]
	and a
	ld a, $3b
	jr z, jr_006_40d1

	ld a, $3c

jr_006_40d1:
	call Call_2185
	call Call_3B8D
	ld [hl], $01
	ret


Jump_06_40DA::
	call Call_0891
	jr nz, jr_006_40e2

	call Call_3B8D

jr_006_40e2:
	ld hl, $c240
	add hl, bc
	ld [hl], $f8
	call Call_06_6558
	ret


Jump_06_40EC::
	call Call_06_648C
	jr nc, jr_006_40ff

	ld a, [$db15]
	cp $06
	ld a, $3e
	jr z, jr_006_40fc

	ld a, $3d

jr_006_40fc:
	call Call_2185

jr_006_40ff:
	ldh a, [$ff98]
	sub $78
	add $02
	cp $04
	jr nc, jr_006_412b

	ldh a, [$ff99]
	sub $20
	add $05
	cp $0a
	jr nc, jr_006_412b

	ld hl, $d401
	ld a, $01
	ld [hli], a
	ld a, $11
	ld [hli], a
	ld a, $d8
	ld [hli], a
	ld a, $88
	ld [hli], a
	ld a, $70
	ld [hli], a
	call Call_06_65E5
	jp Call_0909


jr_006_412b:
	ret


	db $ff, $00, $ff, $20, $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $76, $00
	db $76, $20, $74, $20, $28, $38, $58, $58, $78, $88, $28, $88, $40, $70, $20, $50
	db $70, $40, $40, $40

Call_06_4150::
	ldh a, [$fff8]
	and $10
	jp nz, Call_06_65E5

	ld hl, $c4e0
	add hl, bc
	ld [hl], $3c
	ld hl, $c460
	add hl, bc
	ld [hl], $ff
	ld de, $412c
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_06_4172::
	dw Jump_06_417C
	dw Jump_06_4184
	dw Jump_06_41BF
	dw Jump_06_41D4
	dw Jump_06_422D

Jump_06_417C::
	call Call_0891
	ld [hl], $40
	jp Call_3B8D


Jump_06_4184::
	call Call_0891
	jr nz, jr_006_41be

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $4140
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $4148
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_06_659E
	add $20
	cp $40
	jr nc, jr_006_41b6

	call Call_06_65AE
	add $20
	cp $40
	jr c, jr_006_41be

jr_006_41b6:
	call Call_0891
	ld [hl], $18
	call Call_3B8D

jr_006_41be:
	ret


Jump_06_41BF::
	call Call_0891
	jr nz, jr_006_41c9

	ld [hl], $30
	jp Call_3B8D


jr_006_41c9:
	cp $0c
	ld a, $01
	jr nc, jr_006_41d0

	inc a

jr_006_41d0:
	call Call_3B87
	ret


Jump_06_41D4::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_4222

	ld [hl], $10
	call Call_3B8D
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_4221

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
	ld hl, $c310
	add hl, de
	ld [hl], $04

Jump_006_4202:
	ld hl, $c320
	add hl, de
	ld [hl], $18
	ld hl, $c2e0
	add hl, de
	ld [hl], $40
	ld hl, $c440
	add hl, de
	ld [hl], $01
	push bc
	push de
	pop bc
	ld a, $10
	call Call_3C25
	pop bc
	ld a, $08
	ldh [$fff2], a

jr_006_4221:
	ret


jr_006_4222:
	and $20
	ld a, $03
	jr nz, jr_006_4229

	inc a

jr_006_4229:
	call Call_3B87
	ret


Jump_06_422D::
	call Call_0891
	jr nz, jr_006_423c

	call Call_3B8D
	ld [hl], b
	ld a, $ff
	call Call_3B87
	ret


jr_006_423c:
	cp $08
	ld a, $01
	jr c, jr_006_4243

	inc a

jr_006_4243:
	call Call_3B87
	ret


Call_06_4247::
	call Call_06_44C6
	call Call_06_64DF
	call Call_06_6501
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_426b

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_006_426b:
	ldh a, [$fff0]
	rst $00

JumpTable_06_426E::
	dw Jump_06_4278
	dw Jump_06_42D7
	dw Jump_06_4321
	dw Jump_06_43D4
	dw Jump_06_4438

Jump_06_4278::
	call Call_0891
	jr nz, jr_006_42af

	call Call_3DAF
	call Call_0887
	jr nz, jr_006_42a1

	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	cp e
	jr nz, jr_006_42a1

	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $ff
	ld a, $3b
	ldh [$fff4], a
	ret


jr_006_42a1:
	call Call_0891
	call Call_27ED
	and $1f
	add $10
	ld [hl], a
	call Call_3B8D

Jump_006_42af:
jr_006_42af:
	ldh a, [$ffe8]
	and a
	jr z, jr_006_42ba

	ld hl, $c320
	add hl, bc
	ld [hl], $10

jr_006_42ba:
	call Call_06_654B
	call Call_3B9E
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	rla
	and $06
	call Call_3B87
	call Call_3BB4
	ret


	db $08, $f8, $08, $f8, $f8, $f8, $08, $08

Jump_06_42D7::
	call Call_0891
	jr nz, jr_006_431e

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	call Call_27ED
	bit 2, a
	jr z, jr_006_42f3

	and $03
	jr jr_006_4303

jr_006_42f3:
	call Call_06_659E
	push de
	call Call_06_65AE
	ld a, e
	and $03
	dec a
	dec a
	sla a
	pop de
	or e

jr_006_4303:
	ld e, a
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld d, b
	ld hl, $42cf
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $42d3
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_431e:
	jp Jump_006_42af


Jump_06_4321::
	call Call_3BEB
	call Call_0891
	jr nz, jr_006_4339

Jump_006_4329:
	call Call_3B8D
	ld [hl], b
	call Call_0887
	call Call_27ED
	and $1f
	add $08
	ld [hl], a
	ret


jr_006_4339:
	ld a, $01
	ld [$d3e6], a
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ldh a, [$ffe7]
	and $03
	jr nz, jr_006_4359

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	sub $0c
	jr z, jr_006_4359

	and $80
	jr z, jr_006_4358

	inc [hl]
	inc [hl]

jr_006_4358:
	dec [hl]

jr_006_4359:
	ldh a, [$ff9d]
	cp $ff
	jr z, jr_006_43c6

	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	cp e
	jr nz, jr_006_43c6

	call Call_06_659E
	add $40
	cp $80
	jr nc, jr_006_43c6

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	push hl
	push af
	ldh a, [$ffec]
	ld [hl], a
	call Call_06_65AE
	ld e, a
	pop af
	pop hl
	ld [hl], a
	ld a, e
	add $30
	cp $60
	jr nc, jr_006_43c6

	ld a, $08
	call Call_3C30
	ldh a, [$ffd7]
	cpl
	inc a
	ldh [$ff9b], a
	ldh a, [$ffd8]
	cpl
	inc a
	ldh [$ff9a], a
	push bc
	call Call_20D6
	call Call_3E49
	pop bc
	ld hl, $ffee
	ldh a, [$ff98]
	sub [hl]
	add $04
	cp $08
	jr nc, jr_006_43c6

	ld hl, $ffec
	ldh a, [$ff99]
	sub [hl]
	add $04
	cp $08
	jr nc, jr_006_43c6

	call Call_0891
	ld [hl], $80
	call Call_3B8D

Jump_006_43c6:
jr_006_43c6:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	rla
	and $06
	or $01
	call Call_3B87
	ret


Jump_06_43D4::
	call Call_0891
	jr z, jr_006_4404

	ldh a, [$ffe8]
	and a
	jr z, jr_006_43f1

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_43f1

	inc [hl]
	ld hl, $c320
	add hl, bc
	ld [hl], $0c
	ld a, $09
	ldh [$fff2], a

jr_006_43f1:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	add $08
	call Call_3B87
	ld a, $ff
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ret


jr_006_4404:
	ld [hl], $0c
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	xor a
	ldh [$ff9b], a
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	ld a, $18
	jr z, jr_006_441b

	ld a, $e8

jr_006_441b:
	ldh [$ff9a], a
	ld a, $10
	ldh [$ffa3], a
	ld a, $20
	ld [$dbc7], a
	ld a, $02
	ld [$c146], a
	ld a, $02
	ld [$db94], a
	ld a, $08
	ldh [$fff2], a
	call Call_3B8D
	ret


Jump_06_4438::
	call Call_0891
	jp z, Jump_006_4329

	ld hl, $c320
	add hl, bc
	ld [hl], b
	jp Jump_006_43c6


	db $62, $20, $60, $20, $68, $20, $66, $20, $60, $00, $62, $00, $66, $00, $68, $00
	db $62, $20, $60, $20, $68, $20, $66, $20, $60, $00, $62, $00, $66, $00, $68, $00
	db $00, $fc, $62, $20, $00, $04, $6a, $20, $00, $0c, $64, $20, $00, $fc, $64, $00
	db $00, $04, $6a, $00, $00, $0c, $62, $00, $00, $fc, $62, $20, $00, $04, $6a, $20
	db $00, $0c, $64, $20, $00, $fc, $64, $00, $00, $04, $6a, $00, $00, $0c, $62, $00
	db $00, $0e, $24, $00, $f8, $18, $24, $00, $08, $18, $24, $00, $fe, $13, $24, $00
	db $03, $13, $24, $00, $03, $13, $ff, $00, $00, $fa, $24, $00, $f8, $f0, $24, $00
	db $08, $f0, $24, $00, $fe, $f5, $24, $00, $03, $f5, $24, $00, $03, $f5, $ff, $00

Call_06_44C6::
	ldh a, [$fff1]
	cp $08
	jr nc, jr_006_4503

	ld de, $4446
	call Call_3C3B
	ldh a, [$fff0]
	cp $02
	jr nz, jr_006_4502

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	rla
	and $02
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	or e
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $4496
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0

jr_006_4502:
	ret


jr_006_4503:
	sub $08
	rla
	rla
	and $fc
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $4466
	add hl, de
	ld c, $03
	call Call_3D26
	jp Call_3D19


Call_06_451B::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_006_4799

	ld a, c
	ld [$d202], a
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_4551

	inc [hl]
	ld a, $92
	call Call_3C01
	ld a, e
	ld [$d201], a
	ldh a, [$ffd8]
	add $10
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffd7]
	add $30
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c440
	add hl, de
	inc [hl]

jr_006_4551:
	call Call_06_477F
	call Call_3F12
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_006_53cb

	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_4582

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_006_4582:
	ldh a, [$fff0]
	rst $00

JumpTable_06_4585::
	dw Jump_06_458F
	dw Jump_06_4615
	dw Jump_06_4683
	dw Jump_06_46DE
	dw Jump_06_472B

Jump_06_458F::
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $00
	jr nz, jr_006_45f4

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld hl, $c200
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $c210
	add hl, de
	ld a, [hl]
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	call Call_06_654B
	call Call_3B9E
	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld [hl], e
	add $0c
	cp $18
	jr nc, jr_006_45ec

	call Call_06_65AE
	add $0c
	cp $18
	jr nc, jr_006_45ec

	call Call_3B8D
	ld [hl], $02
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld [hl], $01
	call Call_0891
	ld [hl], $1f
	ld a, $1c
	ldh [$fff3], a

jr_006_45ec:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	jr Call_06_45F7

jr_006_45f4:
	call Call_3B8D

Call_06_45F7::
	ldh a, [$ffe8]
	and a
	jr z, jr_006_4602

	ld hl, $c320
	add hl, bc
	ld [hl], $10

jr_006_4602:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	call Call_3B87
	ret


	db $0c, $f4, $0c, $f4, $fc, $fc, $04, $04

Jump_06_4615::
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $00
	jr nz, jr_006_4627

	call Call_3B8D
	ld [hl], b

jr_006_4627:
	call Call_0891
	jr nz, jr_006_4651

	call Call_27ED
	and $1f
	add $10
	ld [hl], a
	and $03
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $460d
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4611
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_4651:
	call Call_06_654B
	call Call_3B9E
	call Call_06_45F7
	ldh a, [$ffe7]
	and $08
	jr z, jr_006_4662

	inc [hl]
	inc [hl]

jr_006_4662:
	ret


	db $00, $02, $04, $06, $08, $0a, $0c, $0e, $00, $fe, $fc, $fa, $f8, $f6, $f4, $f2
	db $f0, $f1, $f2, $f4, $f6, $f8, $fa, $fe, $f0, $f1, $f2, $f4, $f6, $f8, $fa, $fe

Jump_06_4683::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	rla
	rla
	rla
	and $08
	ld e, a
	call Call_0891
	jr nz, jr_006_469b

	ld [hl], $20
	call Call_3B8D
	ret


jr_006_469b:
	rra
	rra
	and $07
	or e

Call_06_46A0::
	push bc
	ld c, a
	ld a, [$d201]
	ld e, a
	ld d, b
	ldh a, [$ffee]
	ld hl, $4663
	add hl, bc
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4673
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	pop bc
	ld hl, $c310
	add hl, bc
	add [hl]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $02
	ld hl, $c210
	add hl, de
	ld [hl], a

Call_06_46D1::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	or $02
	call Call_3B87
	ret


Jump_06_46DE::
	xor a
	call Call_06_46A0
	call Call_0891
	jr nz, jr_006_4711

	ld [hl], $20
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld [hl], $04
	push bc
	push de
	pop bc
	ld a, $20
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	pop bc
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ld a, $08
	ldh [$fff2], a
	call Call_3B8D
	ret


jr_006_4711:
	call Call_06_45F7
	ld a, $04
	call Call_3C25
	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_06_46D1
	call Call_06_654B
	call Call_3B9E
	ret


Jump_06_472B::
	call Call_0891
	jr nz, jr_006_4734

	call Call_3B8D
	ld [hl], b

jr_006_4734:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	call Call_3B87
	ret


	db $00, $fc, $64, $20, $00, $04, $62, $20, $00, $0c, $60, $20, $f0, $fc, $6c, $20
	db $00, $fc, $60, $00, $00, $04, $62, $00, $00, $0c, $64, $00, $f0, $0c, $6c, $00
	db $00, $fc, $6a, $20, $00, $04, $68, $20, $00, $0c, $66, $20, $f0, $fc, $6c, $00
	db $00, $fc, $66, $00, $00, $04, $68, $00, $00, $0c, $6a, $00, $f0, $0c, $6c, $20

Call_06_477F::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $473f
	add hl, de
	ld c, $04
	call Call_3D26
	jp Call_3D19


	db $6e, $00, $6e, $20

Jump_006_4799:
	ld hl, $c340
	add hl, bc
	ld [hl], $92
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
	ld de, $4795
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_3BEB
	call Call_06_654B
	call Call_06_6584
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
	jr z, jr_006_47f2

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	cp $07
	jr nc, jr_006_47dd

	xor a
	jr jr_006_47e1

jr_006_47dd:
	ld a, $09
	ldh [$fff2], a

jr_006_47e1:
	ld [hl], a
	ld hl, $c240
	add hl, bc
	sra [hl]
	sra [hl]
	ld hl, $c250
	add hl, bc
	sra [hl]
	sra [hl]

jr_006_47f2:
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_06_47F8::
	dw Jump_06_4802
	dw Jump_06_486B
	dw Jump_06_486C
	dw Jump_06_486D
	dw Jump_06_48F5

Jump_06_4802::
	ldh a, [$ffe9]
	dec a
	and $80
	jr z, jr_006_481e

	ld hl, $c250
	call Call_06_4812
	ld hl, $c240

Call_06_4812::
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_481e

	and $80
	jr z, jr_006_481d

	inc [hl]
	inc [hl]

jr_006_481d:
	dec [hl]

jr_006_481e:
	call Call_3BD5
	jr nc, jr_006_486a

	ld a, [$c19b]
	and a
	jr nz, jr_006_486a

	ld a, [$db00]
	cp $03
	jr nz, jr_006_4838

	ldh a, [$ffcc]
	and $20
	jr nz, jr_006_4845

	jr jr_006_486a

jr_006_4838:
	ld a, [$db01]
	cp $03
	jr nz, jr_006_486a

	ldh a, [$ffcc]
	and $10
	jr z, jr_006_486a

jr_006_4845:
	ld a, [$c3cf]
	and a
	jr nz, jr_006_486a

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

jr_006_486a:
	ret


Jump_06_486B::
	ret


Jump_06_486C::
	ret


Jump_06_486D::
	ld a, [$d202]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $0c
	cp $18
	jp nc, Jump_006_48f3

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_006_48f3

	ld hl, $c410
	add hl, de
	ld [hl], $10
	ld hl, $c420
	add hl, de
	ld [hl], $20
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, $c3f0
	add hl, de
	ld [hl], a
	pop hl
	cpl
	inc a
	sra a
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, $c400
	add hl, de
	ld [hl], a
	pop hl
	cpl
	inc a
	sra a
	ld [hl], a
	ld a, $07
	ldh [$fff3], a
	ld hl, $c360
	add hl, de
	ld a, [hl]
	sub $02
	ld [hl], a
	dec a
	and $80
	jr z, jr_006_48ef

	ld hl, $c280
	add hl, de
	ld [hl], $01
	ld hl, $c280
	add hl, bc
	ld [hl], $01
	ld hl, $c480
	add hl, bc
	ld [hl], $1f
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	ld [hl], $04
	ld hl, $c430
	add hl, bc
	res 7, [hl]
	ld a, $10
	ldh [$fff3], a

jr_006_48ef:
	call Call_3B8D
	ld [hl], b

Jump_006_48f3:
jr_006_48f3:
	jr jr_006_4904

Jump_06_48F5::
	ld hl, $c340
	add hl, bc
	ld [hl], $12
	call Call_3BBF
	ld hl, $c340
	add hl, bc
	ld [hl], $92

jr_006_4904:
	ldh a, [$ffe8]
	and a
	jr nz, jr_006_4924

	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_4928

	and $03
	jr z, jr_006_491a

	ld hl, $c240
	jr jr_006_491d

jr_006_491a:
	ld hl, $c250

jr_006_491d:
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a

jr_006_4924:
	call Call_3B8D
	ld [hl], b

jr_006_4928:
	ret


	db $74, $00, $76, $00, $76, $20, $74, $20, $70, $00, $72, $00, $72, $20, $70, $20
	db $78, $00, $7a, $00, $7a, $20, $78, $20, $7c, $00, $7e, $00, $7e, $20, $7c, $20

Call_06_4949::
	ld hl, $c360
	add hl, bc
	ld [hl], $20
	ld de, $4929
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_06_654B
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_06_4964::
	dw Jump_06_496A
	dw Jump_06_49BD
	dw Jump_06_49EE

Jump_06_496A::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_497a

	ld [hl], $20
	call Call_3DAF
	call Call_3B8D

jr_006_497a:
	ld hl, $c3d0
	add hl, bc
	inc [hl]

jr_006_497f:
	ld hl, $c380
	add hl, bc
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_006_498e

	ld a, [hl]
	inc a
	and $03
	ld [hl], a

jr_006_498e:
	ld e, [hl]
	sla e
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $01
	or e
	call Call_3B87
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_49b4

	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $40
	call Call_3DAF

jr_006_49b4:
	ret


	db $0c, $f4, $00, $00, $00, $00, $f4, $0c

Jump_06_49BD::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_49ec

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $49b5
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $49b9
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_49ec:
	jr jr_006_497f

Jump_06_49EE::
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_006_4ac1

	ldh [$ffd7], a
	ld e, $0f
	ld d, b

jr_006_49fc:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_006_4a23

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, jr_006_4a23

	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_006_4a23

	ld hl, $c2e0
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_006_4a23

	ldh a, [$ffd7]
	inc a
	ldh [$ffd7], a

jr_006_4a23:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_006_49fc

	ldh a, [$ffd7]
	cp $03
	jp nz, Jump_006_4ac1

	push bc
	ld c, b
	ld e, $0f
	ld d, b

jr_006_4a35:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_006_4a51

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, jr_006_4a51

	ld hl, $c380
	add hl, de
	ld a, [hl]
	ld hl, $ffd9
	add hl, bc
	ld [hl], a
	inc bc

jr_006_4a51:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_006_4a35

	pop bc
	call Call_08AC
	ld e, $00
	ldh a, [$ffd9]
	ld hl, $ffda
	cp [hl]
	jr nz, jr_006_4a7c

	inc hl
	cp [hl]
	jr nz, jr_006_4a7c

	ld e, $ff
	cp $02
	jr nc, jr_006_4a7c

	ld hl, $fff2
	ld [hl], $02
	ld e, $2d
	cp $01
	jr nz, jr_006_4a7c

	ld e, $2e

jr_006_4a7c:
	ld a, e
	ldh [$ffe8], a
	ld e, $0f
	ld d, b

jr_006_4a82:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_006_4abb

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $90
	jr nz, jr_006_4abb

	ldh a, [$ffe8]
	and a
	jr nz, jr_006_4a9f

	ld hl, $c290
	add hl, de
	ld [hl], d
	jr jr_006_4abb

jr_006_4a9f:
	ld hl, $c4e0
	add hl, de
	ld [hl], a
	ld hl, $c480
	add hl, de
	ld [hl], $1f
	ld hl, $c280
	add hl, de
	ld [hl], $01
	ld hl, $c340
	add hl, de
	ld [hl], $04
	ld hl, $fff4
	ld [hl], $13

jr_006_4abb:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_006_4a82

Jump_006_4ac1:
	ret


	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20

Call_06_4ACE::
	ld de, $4ac2
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_06_4AE0::
	dw Jump_06_4AE8
	dw Jump_06_4AF1
	dw Jump_06_4B2D
	dw Jump_06_4B54

Jump_06_4AE8::
	call Call_0891
	jr nz, jr_006_4af0

	call Call_3B8D

jr_006_4af0:
	ret


Jump_06_4AF1::
	ldh a, [$ffe7]
	xor c
	and $03
	jr nz, jr_006_4afd

	ld a, $08
	call Call_3C25

jr_006_4afd:
	call Call_06_659E
	add $1c
	cp $38
	jr nc, jr_006_4b1d

	call Call_06_65AE
	add $1c
	cp $38
	jr nc, jr_006_4b1d

	ld hl, $c320
	add hl, bc
	ld [hl], $28
	ld a, $10
	call Call_3C25
	call Call_3B8D

jr_006_4b1d:
	call Call_06_654B
	call Call_3B9E
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_06_4B2D::
	call Call_06_654B
	call Call_3B9E
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp $02
	jr nc, jr_006_4b4e

	ld [hl], $c0
	call Call_0891
	ld [hl], $10
	call Call_3DAF
	call Call_3B8D

jr_006_4b4e:
	ld a, $02
	call Call_3B87
	ret


Jump_06_4B54::
	call Call_0891
	jr nz, jr_006_4b8d

	call Call_06_6584
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_4b68

	and $80
	jr z, jr_006_4b8d

jr_006_4b68:
	ld [hl], b
	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	ld [hl], b
	bit 7, a
	jr z, jr_006_4b8d

	cp $d0
	jr nc, jr_006_4b8d

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $0c
	ldh [$ffd8], a
	call Call_09A1

jr_006_4b8d:
	ret


	db $00, $03, $01, $02

Call_06_4B92::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_006_4ea4

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_4bb0

	inc [hl]
	ld hl, $c360
	add hl, bc
	ld [hl], $08
	ld hl, $c440
	add hl, bc
	ld [hl], $01

jr_006_4bb0:
	call Call_380E
	call Call_06_4E7F
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_006_53cb

	call Call_06_64DF
	call Call_3F12
	call Call_08E2
	call Call_3BBF
	call Call_06_654B
	ld a, [$c146]
	and a
	jr nz, jr_006_4bf9

	ld hl, $c430
	add hl, bc
	ld [hl], $c4
	ldh a, [$fff0]
	and a
	jr nz, jr_006_4bf6

	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4b8e
	add hl, de
	ld a, [hl]
	push af
	call Call_06_65BE
	pop af
	cp e
	jr z, jr_006_4bf6

	ld hl, $c430
	add hl, bc
	ld [hl], $84

jr_006_4bf6:
	call Call_3BEB

jr_006_4bf9:
	ldh a, [$fff0]
	rst $00

JumpTable_06_4BFC::
	dw Jump_06_4C38
	dw Jump_06_4D55

	db $14, $00, $ec, $00, $00, $14, $00, $ec, $06, $07, $00, $01, $04, $05, $02, $03
	db $10, $10, $f4, $0c, $f0, $f0, $f4, $0c, $f4, $0c, $10, $10, $f4, $0c, $f0, $f0
	db $80, $80, $80, $7f, $7f, $7f, $80, $7f, $80, $7f, $80, $80, $80, $7f, $7f, $7f
	db $00, $02, $00, $01, $01, $03, $02, $03

Jump_06_4C38::
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_4c68

	call Call_06_4C72
	call Call_3B8D
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	ld hl, $c390
	add hl, bc
	ld [hl], a
	call Call_0891
	ld [hl], $58
	call Call_27ED
	and $01
	jr nz, jr_006_4c64

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_006_4c64:
	call Call_3DAF
	ret


jr_006_4c68:
	call Call_0891
	jr z, Call_06_4C72

	cp $01
	jr z, jr_006_4c9d

	ret


Call_06_4C72::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	cp $20
	jr c, jr_006_4c91

	cp $80
	jr nc, jr_006_4c91

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $28
	jr c, jr_006_4c8c

	cp $68
	jr c, Call_06_4CAB

jr_006_4c8c:
	ldh a, [$ffef]
	ld [hl], a
	jr jr_006_4c94

jr_006_4c91:
	ldh a, [$ffee]
	ld [hl], a

jr_006_4c94:
	call Call_0891
	ld [hl], $15
	call Call_3DAF
	ret


jr_006_4c9d:
	ld hl, $c440
	add hl, bc
	ld e, [hl]
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	add e
	and $03
	ld [hl], a

Call_06_4CAB::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $4c00
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4c04
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	sla e
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	or e
	and $07
	ld e, a
	ld d, b
	ld hl, $4c08
	add hl, de
	ld a, [hl]
	call Call_3B87
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_006_4d54

	ld a, $2f
	ldh [$fff4], a
	ld a, $01

jr_006_4ce8:
	ldh [$ffe8], a
	ld a, $8e
	call Call_3C01
	jr c, jr_006_4d54

	push bc
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, $ffe8
	or [hl]
	ld c, a
	ld hl, $4c10
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4c18
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $4c20
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $4c28
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $4c30
	add hl, bc
	ld a, [hl]
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c430
	add hl, de
	ld [hl], $00
	ld hl, $c2e0
	add hl, de
	ld [hl], $0c
	pop bc
	ldh a, [$ffe8]
	dec a
	cp $ff
	jr nz, jr_006_4ce8

jr_006_4d54:
	ret


Jump_06_4D55::
	call Call_0891
	jr nz, jr_006_4d6b

	ld hl, $c390
	add hl, bc
	ld a, [hl]
	xor $02
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	ret


jr_006_4d6b:
	and $03
	jr nz, jr_006_4d78

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

jr_006_4d78:
	call Call_06_4CAB
	call Call_3DAF
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $fa, $f8, $60, $00, $fa, $00, $62, $00, $fa, $08, $62, $20, $fa, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $06, $f8, $60, $40, $06, $00, $62, $40, $06, $08, $62, $60, $06, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $06, $62, $20, $f8, $0e, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $06, $62, $60, $08, $0e, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $fa, $60, $00, $f8, $02, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $fa, $60, $40, $08, $02, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60

Call_06_4E7F::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $4d7f
	add hl, de
	ld c, $08
	call Call_3D26
	ret


	db $6c, $00, $6e, $00, $6e, $20, $6c, $20, $6c, $40, $6e, $40, $6e, $60, $6c, $60

Jump_006_4ea4:
	ld de, $4e94
	call Call_3C3B
	call Call_06_64DF
	call Call_0891
	jp z, Call_06_65E5

	cp $06
	jr nz, jr_006_4eba

	call Call_06_654B

jr_006_4eba:
	ret


	db $f8, $10, $fa, $10

Call_06_4EBF::
	ldh a, [$fff0]
	and a
	jr nz, jr_006_4ed5

	ld hl, $c200
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], $10
	jp Call_3B8D


Jump_006_4ed5:
jr_006_4ed5:
	ld de, $4ebb
	call Call_3C3B
	call Call_06_64DF
	ldh a, [$ffba]
	cp $02
	jr z, jr_006_4f10

	and a
	jr z, jr_006_4f01

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr nz, jr_006_4f00

	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $20
	jr nc, jr_006_4f00

	inc [hl]

jr_006_4f00:
	ret


jr_006_4f01:
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_4f2d

	ldh a, [$ffe7]
	and $0f
	jr nz, jr_006_4f10

	dec [hl]

jr_006_4f10:
	ld a, [hl]
	cp $04
	jr nc, jr_006_4f2c

	call Call_3BD5
	jr nc, jr_006_4f35

	ld a, $08
	ld [$c13e], a
	ld a, $10
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a

jr_006_4f2c:
	ret


jr_006_4f2d:
	call Call_3BD5
	jr nc, jr_006_4f35

	call Call_06_644E

jr_006_4f35:
	ret


Call_06_4F36::
	ldh a, [$fff0]
	and a
	jp nz, Jump_006_4ed5

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], $10
	jp Call_3B8D


	db $44, $00, $44, $20, $46, $00, $46, $20, $64, $00, $64, $20, $66, $00, $66, $20

Call_06_4F5D::
	ld de, $4f4d
	ldh a, [$fff7]
	cp $0a
	jr nz, jr_006_4f69

	ld de, $4f55

jr_006_4f69:
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	call Call_06_654B
	call Call_3B9E
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	xor c
	and $03
	jr nz, jr_006_4fd0

	call Call_27ED
	xor c
	and $07
	add $04
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	call Call_06_4FC4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_006_4fad

	ld hl, $c250
	add hl, bc
	ld [hl], b

jr_006_4fad:
	ldh a, [$ffd8]
	ld hl, $c240
	call Call_06_4FC4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_4fc3

	ld hl, $c240
	add hl, bc
	ld [hl], b

jr_006_4fc3:
	ret


Call_06_4FC4::
	add hl, bc
	sub [hl]
	jr z, jr_006_4fd0

	bit 7, a
	jr z, jr_006_4fcf

	dec [hl]
	jr jr_006_4fd0

jr_006_4fcf:
	inc [hl]

jr_006_4fd0:
	ret


	db $ff, $00, $ff, $20, $3a, $00, $3a, $20, $3c, $00, $3c, $20, $3c, $00, $3c, $20
	db $58, $78, $78, $28, $28, $28, $78, $58, $28, $78, $28, $78, $28, $78, $58, $58
	db $28, $78, $28, $78, $40, $30, $50, $50, $30, $30, $50, $40, $50, $30, $50, $50
	db $30, $30, $40, $40, $50, $30, $30, $50, $f2, $00, $3a, $00, $f2, $08, $3a, $20
	db $0e, $00, $3a, $00, $0e, $08, $3a, $20, $f6, $0a, $3a, $00, $f6, $12, $3a, $20
	db $0a, $f6, $3a, $00, $0a, $fe, $3a, $20, $00, $0e, $3a, $00, $00, $16, $3a, $20
	db $00, $f2, $3a, $00, $00, $fa, $3a, $20, $0a, $0a, $3a, $00, $0a, $12, $3a, $20
	db $f6, $f6, $3a, $00, $f6, $fe, $3a, $20

Call_06_5049::
	ldh a, [$fff0]
	and a
	jr z, jr_006_5069

	call Call_0891
	jp z, Call_06_65E5

	rla
	rla
	and $30
	ld e, a
	ld d, b
	ld hl, $5009
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ret


jr_006_5069:
	call Call_06_64DF
	ldh a, [$ffeb]
	cp $8a
	jr nz, jr_006_5081

	ldh a, [$ffe7]
	rra
	rra
	and $03
	call Call_3B87
	ld de, $4fd1
	call Call_3C3B

jr_006_5081:
	ld hl, $c3d0
	add hl, bc
	ldh a, [$ffb9]
	ld e, a
	sla a
	sla a
	add e
	add [hl]
	ld e, a
	ld d, b
	ld hl, $4fe1
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $4ff5
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_3DBA
	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffb8]
	cp [hl]
	jr z, jr_006_50f7

	cp $8d
	jr nz, jr_006_50f7

	call Call_3BD5
	jr nc, jr_006_50f2

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $04
	jr nz, jr_006_50ca

	call Call_06_65E5
	call Call_08EC
	jr jr_006_50f7

jr_006_50ca:
	inc [hl]
	ld a, $13
	ldh [$fff2], a
	ld a, $8a
	call Call_3C01
	jr c, jr_006_50f0

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
	call Call_3B8D
	call Call_0891
	ld [hl], $18
	pop bc

jr_006_50f0:
	jr jr_006_50f7

jr_006_50f2:
	ld hl, $c3d0
	add hl, bc
	ld [hl], b

jr_006_50f7:
	ldh a, [$ffb8]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ret


	db $08, $f8, $00, $00, $00, $00, $f8, $08

Call_06_5107::
	call Call_06_538C
	xor a
	ld [$c167], a
	ldh a, [$ffea]
	cp $05
	jp nz, Jump_006_53cb

	call Call_06_64DF
	call Call_3F12
	call Call_06_6501
	call Call_088C
	jr z, jr_006_5126

	call Call_06_5301

jr_006_5126:
	ldh a, [$fff0]
	cp $04
	jr nc, jr_006_5140

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_006_5140

	call Call_3B8D
	ld [hl], $05
	call Call_0891
	ld [hl], $20
	ret


jr_006_5140:
	ldh a, [$fff0]
	rst $00

JumpTable_06_5143::
	dw Jump_06_51C4
	dw Jump_06_514F
	dw Jump_06_51F9
	dw Jump_06_521C
	dw Jump_06_528C
	dw Jump_06_530D

Jump_06_514F::
	call Call_3BB4
	call Call_0891
	jr z, jr_006_516a

	cp $0a
	jr nz, jr_006_5166

	call Call_06_65BE
	ld hl, $c380
	add hl, bc
	ld a, e
	cp [hl]
	jr nz, jr_006_5166

jr_006_5166:
	call Call_3B9E
	ret


jr_006_516a:
	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $02
	jr nz, jr_006_5187

	ld [hl], b
	call Call_27ED
	and $01
	jr nz, jr_006_5187

	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $30
	ret


jr_006_5187:
	call Call_0891
	call Call_27ED
	and $1f
	or $20
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
	cp $00
	jr nz, jr_006_51a8

	call Call_06_65BE
	jr jr_006_51ab

jr_006_51a8:
	call Call_27ED

jr_006_51ab:
	and $03
	ld e, a
	ld d, b
	ld hl, $50ff
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5103
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ret


Jump_06_51C4::
	call Call_3BB4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_51d5

	call Call_0891
	jr nz, jr_006_51e3

jr_006_51d5:
	call Call_27ED
	and $0f
	or $10
	ld [hl], a
	call Call_3B8D
	call Call_3DAF

jr_006_51e3:
	call Call_06_654B
	call Call_3B9E

Call_06_51E9::
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_06_51F9::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_520b

	ld [hl], $20
	call Call_3B8D
	ld a, $18
	call Call_3C25

jr_006_520b:
	call Call_06_51E9
	call Call_06_51E9
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_006_521b

	ld a, $20
	ldh [$fff2], a

jr_006_521b:
	ret


Jump_06_521C::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_5228

	call Call_3B8D
	ld [hl], b

jr_006_5228:
	call Call_06_654B
	call Call_3B9E
	call Call_06_659E
	add $18
	cp $30
	jr nc, jr_006_5253

	call Call_06_65AE
	add $18
	cp $30
	jr nc, jr_006_5253

	ld a, [$c11c]
	cp $00
	jr nz, jr_006_5253

	call Call_3B8D
	call Call_0891
	ld [hl], $4f
	ld a, $16
	ldh [$fff3], a

jr_006_5253:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_006_5268

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $0a
	ldh [$ffd8], a
	ld a, $0b
	call Call_0953

jr_006_5268:
	jr jr_006_520b

	db $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $ef, $ef, $ef, $ef, $ef, $ef
	db $ef, $ef, $f3, $f7, $fb, $00, $15, $15, $15, $15, $15, $14, $14, $14, $10, $08
	db $04, $00

Jump_06_528C::
	call Call_0891
	jr nz, jr_006_5296

	call Call_3B8D
	ld [hl], b
	ret


jr_006_5296:
	cp $20
	jr nz, jr_006_52ca

	ld a, $20
	ldh [$ff9b], a
	ldh a, [$ff98]
	cp $50
	ld a, $e0
	jr nc, jr_006_52a8

	ld a, $20

jr_006_52a8:
	ldh [$ff9a], a
	ld a, $10
	ldh [$ffa3], a
	ld a, $02
	ld [$c146], a
	ld a, $08
	ldh [$fff2], a
	ld a, $08
	ld [$db94], a
	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffef]
	ldh [$ff99], a
	call Call_088C
	ld [hl], $50
	ret


jr_006_52ca:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $526a
	add hl, de
	ld a, [hl]
	call Call_3B87
	call Call_0891
	cp $20
	jr c, jr_006_530c

	sub $20
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $5274
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ff98], a
	ld hl, $5280
	add hl, de
	ld a, [hl]
	ldh [$ffa2], a
	ld a, $02
	ld [$c146], a
	ldh a, [$ffef]
	ldh [$ff99], a

Call_06_5301::
	ld a, $01
	ldh [$ffa1], a
	ld a, $6a
	ldh [$ff9d], a
	ld [$c167], a

jr_006_530c:
	ret


Jump_06_530D::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_531a

	call Call_3B8D
	ld [hl], b
	ret


jr_006_531a:
	ld e, $00
	cp $10
	jr c, jr_006_5321

	inc e

jr_006_5321:
	cp $10
	jr nz, jr_006_5347

	ld a, $02
	call Call_3C01
	jr c, jr_006_5347

	ldh a, [$ffd7]
	sub $0c
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	sub $00
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c310
	add hl, de
	ld [hl], $10
	jp Jump_006_4202


jr_006_5347:
	ld a, e
	call Call_3B87
	ret


	db $f4, $f8, $60, $00, $f4, $00, $62, $00, $f4, $08, $64, $00, $f4, $10, $66, $00
	db $04, $f8, $68, $00, $04, $00, $6a, $00, $04, $08, $6c, $00, $04, $10, $6e, $00
	db $f4, $f8, $66, $20, $f4, $00, $64, $20, $f4, $08, $62, $20, $f4, $10, $60, $20
	db $04, $f8, $6e, $20, $04, $00, $6c, $20, $04, $08, $6a, $20, $04, $10, $68, $20

Call_06_538C::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $534c
	add hl, de
	ld c, $08
	call Call_3D26
	ret


Call_06_53A1::
	ld hl, $c460
	add hl, bc
	ld [hl], $ff
	ld hl, $c4e0
	add hl, bc
	ld [hl], $30
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $08
	jr nc, jr_006_53c2

	ld e, $02
	cp $04
	jr nc, jr_006_53be

	ld e, $03

jr_006_53be:
	ld a, e
	call Call_3B87

jr_006_53c2:
	call Call_06_5680
	ldh a, [$ffea]
	cp $05
	jr z, jr_006_5428

Jump_006_53cb:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_53D1::
	dw Jump_06_53D9
	dw Jump_06_53E8
	dw Jump_06_53F9
	dw Jump_06_5427

Jump_06_53D9::
	call Call_0891
	ld [hl], $a0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_06_5701
	ret


Jump_06_53E8::
	call Call_0891
	jr nz, jr_006_53f8

	ld [hl], $c0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_06_5701

jr_006_53f8:
	ret


Jump_06_53F9::
	call Call_0891
	jr nz, jr_006_5423

	ld a, $1a
	ldh [$fff4], a
	call Call_27BD
	call Call_3F7A
	ldh a, [$ffeb]
	cp $88
	ret z

	ldh a, [$ffeb]
	cp $89
	jr z, jr_006_541b

	cp $8e
	jr z, jr_006_541b

	cp $92
	jr nz, jr_006_5420

jr_006_541b:
	ldh a, [$fff7]
	cp $06
	ret nc

jr_006_5420:
	jp Jump_006_6cb4


jr_006_5423:
	call Call_06_6FFC
	ret


Jump_06_5427::
	ret


jr_006_5428:
	call Call_06_64DF
	call Call_3F12
	call Call_3BEB
	call Call_06_6449
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_544e

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_006_544e:
	call Call_088C
	jr z, jr_006_545b

	ld a, $02
	ldh [$ffa1], a
	ld a, $6a
	ldh [$ff9d], a

jr_006_545b:
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	cp [hl]
	ld [hl], a
	jp z, Jump_006_54d8

	cp $08
	jr nc, jr_006_54d8

	cp $04
	jr nc, jr_006_549a

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, jr_006_54d8

	inc [hl]
	ld a, $05
	call Call_3C01
	jr c, jr_006_54d8

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	dec a
	ld [hl], a
	ldh [$ffd7], a
	ldh a, [$ffd8]
	ld hl, $ffda
	sub [hl]
	ld hl, $c210
	add hl, de
	sub $10
	jr jr_006_54c0

jr_006_549a:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $01
	jr nc, jr_006_54d8

	inc [hl]
	ld a, $05
	call Call_3C01
	jr c, jr_006_54d8

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	add $07
	ld [hl], a
	ldh [$ffd7], a
	ldh a, [$ffd8]
	ld hl, $ffda
	sub [hl]
	ld hl, $c210
	add hl, de

jr_006_54c0:
	ld [hl], a
	ldh [$ffd8], a
	ld hl, $c2f0
	add hl, de
	ld [hl], $0f
	ld hl, $c340
	add hl, de
	ld [hl], $c4
	ld a, $02
	call Call_0953
	ld a, $29
	ldh [$fff4], a

Jump_006_54d8:
jr_006_54d8:
	ldh a, [$fff0]
	rst $00

JumpTable_06_54DB::
	dw Jump_06_54EB
	dw Jump_06_5509
	dw Jump_06_551E
	dw Jump_06_554F
	dw Jump_06_5588
	dw Jump_06_55A3
	dw Jump_06_55B8
	dw Jump_06_55E2

Jump_06_54EB::
	call Call_08E2
	call Call_06_659E
	add $20
	cp $40
	jr nc, jr_006_5508

	call Call_06_65AE
	add $20
	cp $40
	jr nc, jr_006_5508

	call Call_3B8D
	call Call_0891
	ld [hl], $30

jr_006_5508:
	ret


Jump_06_5509::
	call Call_08E2
	call Call_0891
	jr nz, jr_006_5516

	ld [hl], $80
	call Call_3B8D

jr_006_5516:
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_06_551E::
	call Call_08E2
	call Call_0891
	jr nz, jr_006_553e

	ld [hl], $50
	call Call_3B8D
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ld hl, $c350
	add hl, bc
	res 7, [hl]
	ld hl, $c430
	add hl, bc
	res 6, [hl]
	ret


jr_006_553e:
	ld e, $08
	and $04
	jr z, jr_006_5546

	ld e, $f8

jr_006_5546:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	call Call_06_6558
	ret


Jump_06_554F::
	call Call_06_6501
	call Call_0891
	jr nz, jr_006_5565

	ld hl, $c320
	add hl, bc
	ld [hl], $30
	call Call_3B8D
	ld a, $24
	ldh [$fff2], a
	ret


jr_006_5565:
	ldh a, [$ffe8]
	and a
	jr z, jr_006_5584

	ld hl, $c320
	add hl, bc
	ld [hl], $0c
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $05
	ld a, $08
	jr nc, jr_006_557d

	ld a, $0c

jr_006_557d:
	call Call_3C25
	ld a, $20
	ldh [$fff2], a

jr_006_5584:
	call Call_06_654B
	ret


Jump_06_5588::
	call Call_06_6501
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and $fe
	jr nz, jr_006_559f

	call Call_0891
	ld [hl], $10
	call Call_3DAF
	call Call_3B8D

jr_006_559f:
	call Call_06_654B
	ret


Jump_06_55A3::
	call Call_06_6501
	call Call_0891
	ld a, $00
	jr nz, jr_006_55b2

	call Call_3B8D
	ld a, $b0

jr_006_55b2:
	ld hl, $c320
	add hl, bc
	ld [hl], a
	ret


Jump_06_55B8::
	call Call_06_6501
	ldh a, [$ffe8]
	and a
	jr z, jr_006_55e1

	ld a, $30
	ld [$c157], a
	ld a, $04
	ld [$c158], a
	ld a, $0b
	ldh [$fff2], a
	call Call_0891
	ld [hl], $30
	ld a, [$c146]
	and a
	jr nz, jr_006_55de

	call Call_088C
	ld [hl], $40

jr_006_55de:
	call Call_3B8D

jr_006_55e1:
	ret


Jump_06_55E2::
	call Call_06_6501
	call Call_0891
	jr nz, jr_006_55ef

	call Call_3B8D
	ld [hl], $02

jr_006_55ef:
	ret


	db $f4, $f8, $70, $00, $f4, $00, $72, $00, $f4, $08, $72, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $7a, $00, $04, $10, $7a, $20
	db $f4, $f8, $70, $00, $f4, $00, $78, $00, $f4, $08, $78, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $7a, $00, $04, $10, $7a, $20
	db $f4, $f8, $70, $00, $f4, $00, $72, $00, $f4, $08, $72, $20, $f4, $10, $70, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $76, $20, $04, $10, $74, $20
	db $f4, $f8, $7c, $00, $f4, $00, $7e, $00, $f4, $08, $7e, $20, $f4, $10, $7c, $20
	db $04, $f8, $74, $00, $04, $00, $76, $00, $04, $08, $76, $20, $04, $10, $74, $20
	db $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

Call_06_5680::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $55f0
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_56ad

	ldh a, [$ffef]
	ldh [$ffec], a
	ld hl, $5670
	ld c, $04
	call Call_3D26

jr_006_56ad:
	jp Call_3DBA


	db $00, $04, $fc, $08, $f8

Call_06_56B5::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_006_5a5c

	cp $00
	jr nz, jr_006_56de

	inc [hl]
	ld a, $50
	ldh [$ffb0], a
	ld hl, $c310
	add hl, bc
	ld [hl], $ff
	call Call_0891
	ld [hl], $50
	ld e, $00
	ld a, $ff
	ld hl, $d200

jr_006_56da:
	ld [hli], a
	dec e
	jr nz, jr_006_56da

jr_006_56de:
	call Call_06_599C
	ldh a, [$ffea]
	cp $01
	jp nz, Jump_006_5795

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_56EE::
	dw Jump_06_56F6
	dw Jump_06_5707
	dw Jump_06_5718
	dw Jump_06_5794

Jump_06_56F6::
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_0891
	ld [hl], $60

Call_06_5701::
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_06_5707::
	call Call_0891
	jr nz, jr_006_5717

	ld [hl], $cf
	call Call_06_5701
	ld hl, $c440
	add hl, bc
	ld [hl], $05

jr_006_5717:
	ret


Jump_06_5718::
	call Call_0891
	jr nz, jr_006_5757

	call Call_27BD
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
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ld [hl], $02
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ld hl, $c2f0
	add hl, de
	ld [hl], $10
	call Call_06_65E5
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	jr jr_006_5788

jr_006_5757:
	and $1f
	jr nz, jr_006_5793

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld hl, $c440
	add hl, bc
	ld e, [hl]
	dec [hl]
	ld d, b
	ld hl, $5996
	add hl, de
	sub [hl]
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $d200
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_006_5793

	push hl
	ld hl, $d100
	add hl, de
	ld a, [hl]
	pop hl
	sub [hl]
	ld [hl], $ff

jr_006_5788:
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $13
	ldh [$fff4], a

jr_006_5793:
	ret


Jump_06_5794::
	ret


Jump_006_5795:
	call Call_06_64DF
	call Call_3F12
	call Call_088C
	jr z, jr_006_57f3

	and $0f
	jr nz, jr_006_57f3

	ld a, $02

jr_006_57a6:
	ldh [$ffe8], a
	ld a, $87
	call Call_3C01
	jr c, jr_006_57f3

	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $c3b0
	add hl, de
	and $02
	ld [hl], a
	ld a, [$c1cd]
	ld hl, $56b0
	add hl, bc
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $56b2
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld a, [$c1ce]
	add $00
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, de
	ld [hl], $f0
	ld hl, $c2d0
	add hl, de
	ld [hl], $02
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	pop bc
	ldh a, [$ffe8]
	dec a
	jr nz, jr_006_57a6

jr_006_57f3:
	call Call_06_5A1F
	call Call_08E2
	ldh a, [$fff0]
	cp $02
	jr c, jr_006_5821

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $ff
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ldh a, [$ffee]
	ld [hl], a
	ld hl, $d100
	add hl, de
	ldh a, [$ffef]
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	ld hl, $d200
	add hl, de
	ld [hl], a

jr_006_5821:
	ldh a, [$fff0]
	rst $00

JumpTable_06_5824::
	dw Jump_06_5840
	dw Jump_06_5877
	dw Jump_06_58BD
	dw Jump_06_58DD
	dw Jump_06_5907
	dw Jump_06_5972

	db $28, $38, $48, $58, $68, $78, $88, $28, $30, $40, $50, $60, $70, $30, $40, $50

Jump_06_5840::
	call Call_0891
	jr nz, jr_006_5876

	call Call_0891
	ld [hl], $18
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5830
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	ld e, a
	ld hl, $5838
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], b
	call Call_3DBA
	call Call_3B8D

jr_006_5876:
	ret


Jump_06_5877::
	call Call_0891
	jr nz, jr_006_58af

	ld [hl], $20
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $58
	ldh [$ff98], a
	ld a, $50
	ldh [$ff99], a
	ld a, $08
	call Call_3C25
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ldh a, [$ffee]
	ld [$c1cd], a
	ldh a, [$ffef]
	ld [$c1ce], a
	call Call_088C
	ld [hl], $61
	call Call_3B8D

jr_006_58af:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add $05
	call Call_3B87
	ret


Jump_06_58BD::
	call Call_0891
	jr nz, jr_006_58d3

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld [hl], $20
	call Call_3B8D

jr_006_58d3:
	call Call_06_654B
	call Call_06_6584
	call Call_3BB4
	ret


Jump_06_58DD::
	call Call_0891
	jr nz, jr_006_58e7

	ld [hl], $80
	call Call_3B8D

jr_006_58e7:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld a, [hl]
	bit 0, a
	jr nz, jr_006_58fd

	ld hl, $c320
	add hl, bc
	and $20
	jr nz, jr_006_58fc

	inc [hl]
	inc [hl]

jr_006_58fc:
	dec [hl]

jr_006_58fd:
	call Call_06_654B
	call Call_06_6584
	call Call_3BB4
	ret


Jump_06_5907::
	call Call_0891
	jr nz, jr_006_5913

	ld [hl], $60
	call Call_3B8D
	ld [hl], b
	ret


jr_006_5913:
	cp $78
	jr nz, jr_006_592a

	ldh a, [$ffee]
	ld [$c1cd], a
	ldh a, [$ffef]
	ld [$c1ce], a
	call Call_088C
	ld [hl], $60
	ld a, $23
	ldh [$fff4], a

jr_006_592a:
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sub $f4
	and $80
	jr nz, jr_006_5936

	dec [hl]

jr_006_5936:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_006_595a

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_594b

	and $80
	jr z, jr_006_594a

	inc [hl]
	inc [hl]

jr_006_594a:
	dec [hl]

jr_006_594b:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_595a

	and $80
	jr z, jr_006_5959

	inc [hl]
	inc [hl]

jr_006_5959:
	dec [hl]

jr_006_595a:
	call Call_06_654B
	call Call_06_6584
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_006_596c

	call Call_3BB4

jr_006_596c:
	ld a, $02
	call Call_3B87
	ret


Jump_06_5972::
	db $72, $00, $74, $00, $74, $20, $72, $20, $70, $00, $70, $20, $70, $40, $70, $60
	db $76, $00, $76, $20, $7a, $00, $7a, $60, $7a, $40, $7a, $20, $78, $00, $78, $60
	db $78, $40, $78, $20, $0c, $18, $24, $30, $3c, $48

Call_06_599C::
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_006_59ab

	ld de, Jump_06_5972
	call Call_3C3B

jr_006_59ab:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ldh a, [$ffe7]
	and $01
	jr z, jr_006_59c0

	ld a, $06
	ldh [$ffe9], a
	ld a, $00
	jr jr_006_59c6

jr_006_59c0:
	ld a, $ff
	ldh [$ffe9], a
	ld a, $05

jr_006_59c6:
	ldh [$ffe8], a
	ld e, a
	ld d, b
	ld hl, $5996
	add hl, de
	ldh a, [$ffd7]
	sub [hl]
	and $ff
	ld e, a
	ld d, $00
	ld hl, $d000
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $d100
	add hl, de
	ld a, [hl]
	ldh [$ffef], a
	ld hl, $d200
	add hl, de
	sub [hl]
	ldh [$ffec], a
	ld a, [hl]
	and $80
	jr nz, jr_006_5a09

	ldh a, [$ffe8]
	cp $05
	ld a, $04
	jr nz, jr_006_5a01

	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $07

jr_006_5a01:
	ldh [$fff1], a
	ld de, Jump_06_5972
	call Call_3C3B

jr_006_5a09:
	ld e, $ff
	ldh a, [$ffe7]
	and $01
	jr z, jr_006_5a13

	ld e, $01

jr_006_5a13:
	ld hl, $ffe9
	ldh a, [$ffe8]
	add e
	cp [hl]
	jr nz, jr_006_59c6

	jp Call_3DBA


Call_06_5A1F::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld d, a
	bit 7, a
	jr z, jr_006_5a2b

	cpl
	inc a

jr_006_5a2b:
	ld e, a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_006_5a37

	cpl
	inc a

jr_006_5a37:
	cp e
	jr nc, jr_006_5a46

	bit 7, d
	jr nz, jr_006_5a42

	ld a, $01
	jr jr_006_5a50

jr_006_5a42:
	ld a, $00
	jr jr_006_5a50

jr_006_5a46:
	bit 7, [hl]
	jr nz, jr_006_5a4e

	ld a, $02
	jr jr_006_5a50

jr_006_5a4e:
	ld a, $03

jr_006_5a50:
	call Call_3B87
	ret


	db $7c, $20, $7e, $20, $7c, $00, $7e, $00

Jump_006_5a5c:
	ld de, $5a54
	call Call_3CD0
	call Call_06_64DF
	call Call_06_654B
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld a, [hl]
	and a
	jr nz, jr_006_5a76

	ld hl, $c3b0
	add hl, bc
	inc [hl]

jr_006_5a76:
	cp $10
	jr nz, jr_006_5a7d

	call Call_06_65E5

jr_006_5a7d:
	ret


	db $70, $00, $72, $00, $74, $00, $76, $00, $72, $20, $70, $20, $76, $20, $74, $20
	db $00, $00, $02, $00, $04, $00, $06, $00, $02, $20, $00, $20, $06, $20, $04, $20
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20
	db $10, $00, $12, $00, $14, $00, $16, $00, $12, $20, $10, $20, $16, $20, $14, $20

Call_06_5ABE::
	ld a, [$c19f]
	and a
	jr z, jr_006_5ae3

	ld a, [$c173]
	cp $82
	jr z, jr_006_5ae3

	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_3DAF
	ld a, [$c170]
	ld e, $00
	and $06
	jr z, jr_006_5ae0

	inc e

jr_006_5ae0:
	ld a, e
	ldh [$fff1], a

jr_006_5ae3:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_5af1

	ldh a, [$fff1]
	add $02
	ldh [$fff1], a

jr_006_5af1:
	ld de, $5a7e
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_5b09

	ldh a, [$fff6]
	cp $b2
	jr nz, jr_006_5b0c

	ld a, [$db0e]
	cp $03
	jr c, jr_006_5b0c

jr_006_5b09:
	ld de, $5a9e

jr_006_5b0c:
	ld a, [$db95]
	cp $01
	jr nz, jr_006_5b19

	ldh a, [$fff1]
	add $04
	ldh [$fff1], a

jr_006_5b19:
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_5b3d

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], a

jr_006_5b3d:
	ldh a, [$fff0]
	cp $02
	jr nc, jr_006_5b6e

	call Call_06_648C
	jr nc, jr_006_5b6e

	ld e, $23
	ldh a, [$fff6]
	cp $b2
	jr nz, jr_006_5b67

	ld e, $80
	ld a, [$db0e]
	cp $02
	jr nz, jr_006_5b60

	call Call_3B8D
	ld [hl], $02
	ld e, $81

jr_006_5b60:
	ld a, e
	call Call_2185
	jp Call_06_5BA3


jr_006_5b67:
	ld a, e
	call Call_2197
	call Call_06_5BA3

jr_006_5b6e:
	ldh a, [$fff0]
	rst $00

JumpTable_06_5B71::
	dw Jump_06_5BBE
	dw Jump_06_5C01
	dw Jump_06_5B79
	dw Jump_06_5BA8

Jump_06_5B79::
	ld a, [$c19f]
	and a
	jr nz, jr_006_5ba7

	ld a, [$c177]
	and a
	jr nz, jr_006_5b9a

	ld a, $03
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	ld a, $83
	call Call_2185
	call Call_06_5BA3
	call Call_3B8D
	ret


jr_006_5b9a:
	call Call_3B8D
	ld [hl], b
	ld a, $84
	call Call_2185

Call_06_5BA3::
	ld a, $18
	ldh [$fff3], a

jr_006_5ba7:
	ret


Jump_06_5BA8::
	ld a, [$c19f]
	and a
	jr nz, jr_006_5bb5

	call Call_0898
	call Call_3B8D
	ld [hl], b

jr_006_5bb5:
	ret


	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

Jump_06_5BBE::
	xor a
	call Call_3B87
	call Call_0891
	jr nz, jr_006_5bfe

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5bb6
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
	ld hl, $5bb6
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

jr_006_5bfe:
	jp Jump_006_5c23


Jump_06_5C01::
	call Call_06_654B
	call Call_3B9E
	ldh a, [$ffe8]
	and a
	jr z, jr_006_5c23

	call Call_0891
	jr nz, jr_006_5c18

	ld [hl], $30
	call Call_3B8D
	ld [hl], b
	ret


jr_006_5c18:
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ld hl, $c310
	add hl, bc
	inc [hl]

Jump_006_5c23:
jr_006_5c23:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_06_5C4E::
	call Call_0891
	cp $01
	jr nz, jr_006_5c5b

	ld [hl], b
	ld a, $ff
	ld [$db93], a

jr_006_5c5b:
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_006_5c69

	call Call_06_65BE
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_006_5c69:
	call Call_06_6470
	ld de, $5c2e
	call Call_3C3B
	ld a, [$db56]
	cp $80
	jr nz, jr_006_5c9c

	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_5c8e

	and $80
	jr z, jr_006_5c9c

jr_006_5c8e:
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_006_5c9c

	ld [hl], $10

jr_006_5c9c:
	call Call_06_64DF
	ldh a, [$ffef]
	ldh [$ffec], a
	call Call_06_6449
	call Call_3DBA
	call Call_06_648C
	jr nc, jr_006_5cdd

	ld e, $30
	ld a, [$db66]
	and $02
	jr z, jr_006_5ccb

	ld a, [$db56]
	cp $01
	jr nz, jr_006_5ccb

	xor a
	ld [$db56], a
	call Call_0891
	ld [hl], $10
	ld e, $2f
	jr jr_006_5cd9

jr_006_5ccb:
	ld a, [$db56]
	and a
	jr z, jr_006_5cd9

	ld e, $31
	cp $01
	jr nz, jr_006_5cd9

	ld e, $32

jr_006_5cd9:
	ld a, e
	call Call_06_5CDE

jr_006_5cdd:
	ret


Call_06_5CDE::
	ld a, e
	call Call_2185
	ld hl, $c19f
	set 7, [hl]
	ret


Call_06_5CE8::
	call Call_06_5D33
	call Call_06_64DF
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_06_6449
	call Call_06_648C
	jr nc, jr_006_5d12

	ld a, [$db55]
	and a
	jr nz, jr_006_5d0d

	ld a, $01
	ld [$db55], a

jr_006_5d0d:
	ld a, $40
	call Call_2185

jr_006_5d12:
	ret


	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $f0, $00, $78, $00, $f0, $08, $7a, $00, $00, $00, $7c, $00, $00, $08, $7e, $00

Call_06_5D33::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $5d13
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

Call_06_5D5C::
	ldh a, [$fff6]
	cp $58
	jr nz, jr_006_5d75

	ldh a, [$fff8]
	and $10
	jp nz, Call_06_65E5

	ld hl, $c460
	add hl, bc
	ld [hl], $ff
	ld hl, $c4e0
	add hl, bc
	ld [hl], $3c

jr_006_5d75:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_5d83

	ldh a, [$fff1]
	add $02
	ldh [$fff1], a

jr_006_5d83:
	ld de, $5d4c
	call Call_3C3B
	ldh a, [$fff0]
	and a
	jr nz, jr_006_5d9c

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	call Call_3B8D
	ld a, [hl]
	ldh [$fff0], a

jr_006_5d9c:
	call Call_06_64DF
	call Call_06_6501
	ldh a, [$fff0]
	dec a
	rst $00

JumpTable_06_5DA6::
	dw Jump_06_5DAE
	dw Jump_06_5E14
	dw Jump_06_5E2F
	dw Jump_06_5E7F

Jump_06_5DAE::
	ldh a, [$fff6]
	cp $58
	jr nz, jr_006_5dee

	ld a, [$c50c]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_006_5e13

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_006_5e13

	ld hl, $c2f0
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_006_5e13

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $10
	cp $20
	jr nc, jr_006_5e13

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $28
	cp $50
	jr nc, jr_006_5e13

	jr jr_006_5e05

jr_006_5dee:
	call Call_06_659E
	ld hl, $c380
	add hl, bc
	ld [hl], e
	add $18
	cp $30
	jr nc, jr_006_5e13

	call Call_06_65AE
	add $30
	cp $60
	jr nc, jr_006_5e13

jr_006_5e05:
	ld hl, $c340
	add hl, bc
	ld [hl], $12
	call Call_0891
	ld [hl], $22
	call Call_3B8D

jr_006_5e13:
	ret


Jump_06_5E14::
	call Call_3BB4
	call Call_0891
	jr nz, jr_006_5e21

	ld [hl], $30
	jp Call_3B8D


jr_006_5e21:
	call Call_3DAF
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	call Call_06_6584
	jr jr_006_5e6f

Jump_06_5E2F::
	call Call_3BB4
	call Call_0891
	jp z, Call_3B8D

	and $01
	jr nz, Call_06_5E69

	ld a, $20
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_006_5e4e

	inc [hl]
	inc [hl]

jr_006_5e4e:
	dec [hl]
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_006_5e5c

	inc [hl]
	inc [hl]

jr_006_5e5c:
	dec [hl]
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	ld hl, $c380
	add hl, bc
	ld [hl], a

Call_06_5E69::
	call Call_06_654B
	call Call_06_5E7B

jr_006_5e6f:
	call Call_06_5E7B
	ld a, [hl]
	rra
	rra
	rra
	and $01
	jp Call_3B87


Call_06_5E7B::
	call Call_29C5
	ret


Jump_06_5E7F::
	call Call_3BB4
	ldh a, [$ffe7]
	and $03
	jr nz, jr_006_5eb9

	ld a, $20
	call Call_3C30
	ldh a, [$ffd7]
	cpl
	inc a
	ld hl, $c250
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_006_5e9c

	inc [hl]
	inc [hl]

jr_006_5e9c:
	dec [hl]
	ldh a, [$ffd8]
	cpl
	inc a
	ld hl, $c240
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_006_5eac

	inc [hl]
	inc [hl]

jr_006_5eac:
	dec [hl]
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_006_5eb9:
	call Call_06_5E69

Call_06_5EBC::
	ldh a, [$ffec]
	cp $88
	jp nc, Call_06_65E5

	ldh a, [$ffee]
	cp $a8
	jp nc, Call_06_65E5

	ret


	db $f8, $00, $64, $00, $f8, $08, $66, $00, $08, $00, $68, $00, $08, $08, $6a, $00
	db $f8, $00, $60, $00, $f8, $08, $62, $00, $08, $00, $68, $00, $08, $08, $6a, $00
	db $f8, $00, $66, $20, $f8, $08, $64, $20, $08, $00, $6a, $20, $08, $08, $68, $20
	db $a0, $10

Call_06_5EFD::
	call Call_0891
	jr z, jr_006_5f2f

	ldh a, [$ff98]
	ldh [$ffee], a
	ld a, [$c145]
	sub $10
	ldh [$ffec], a
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
	ld de, $5efb
	call Call_3CD0
	call Call_3DBA

jr_006_5f2f:
	ld e, $00
	ldh a, [$ff98]
	cp $30
	jr c, jr_006_5f3f

	ld e, $01
	cp $60
	jr c, jr_006_5f3f

	ld e, $02

jr_006_5f3f:
	ld a, e
	ldh [$fff1], a
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $5ecb
	add hl, de
	ldh a, [$ffec]
	sub $04
	ldh [$ffec], a
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	call Call_3DBA
	call Call_06_64DF
	call Call_06_6449
	ldh a, [$fff0]
	rst $00

JumpTable_06_5F6A::
	dw Jump_06_5F82
	dw Jump_06_5FA8
	dw Jump_06_5FE5
	dw Jump_06_6070
	dw Jump_06_6079

Call_06_5F74::
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $28
	cp $50
	call Call_06_6497
	ret


Jump_06_5F82::
	call Call_06_5F74
	jr nc, jr_006_5fa7

	ld a, $17
	call Call_2197
	ld hl, $c19f
	set 7, [hl]
	ld a, [$d415]
	and $01
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld a, [$db75]
	cp $07
	jr nz, jr_006_5fa4

	inc [hl]
	inc [hl]

jr_006_5fa4:
	call Call_3B8D

jr_006_5fa7:
	ret


Jump_06_5FA8::
	call Call_06_5F74
	ret nc

	ld a, [$db0d]
	and a
	jr nz, jr_006_5fca

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and $01
	ld a, $18
	jr z, jr_006_5fbf

	ld a, $19

jr_006_5fbf:
	call Call_2197
	ld hl, $c19f
	set 7, [hl]
	jp Call_3B8D


jr_006_5fca:
	ld a, $1c
	call Call_2197
	ld hl, $c19f
	set 7, [hl]
	ret


	db $28, $42, $07, $07, $00, $00, $00, $00, $1c, $2a, $07, $07, $00, $00, $00, $00

Jump_06_5FE5::
	ld a, [$c19f]
	and a
	jp nz, Jump_006_606f

	ld a, [$c177]
	and a
	jr nz, jr_006_6061

	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5fd9
	add hl, de
	ld a, [hl]
	ld hl, $5fd5
	add hl, de
	ld e, [hl]
	ld d, a
	ld a, [$db5e]
	sub e
	ld a, [$db5d]
	sbc d
	jr nc, jr_006_6011

	ld a, $1b
	jr Call_06_6063

jr_006_6011:
	ld a, [$db75]
	inc a
	and $07
	ld [$db75], a
	jr nz, jr_006_6029

	ld a, $1e
	call Call_2197
	ld hl, $c19f
	set 7, [hl]
	jp Call_3B8D


jr_006_6029:
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5fdd
	add hl, de
	ld a, [$db92]
	add [hl]
	ld [$db92], a
	rl a
	ld hl, $5fe1
	add hl, de
	rr a
	ld a, [$db91]
	adc [hl]
	ld [$db91], a
	ld hl, $db0d
	inc [hl]
	ld a, $1a
	call Call_06_6063
	call Call_3B8D
	ld [hl], $04
	call Call_0891
	ld [hl], $20
	ld a, $01
	ldh [$fff2], a
	ret


jr_006_6061:
	ld a, $1d

Call_06_6063::
	call Call_2197
	ld hl, $c19f
	set 7, [hl]
	call Call_3B8D
	ld [hl], b

Jump_006_606f:
	ret


Jump_06_6070::
	ld a, [$c19f]
	and a
	jr nz, jr_006_6078

	jr jr_006_6029

jr_006_6078:
	ret


Jump_06_6079::
	call Call_0891
	ret nz

	ld a, [$c19f]
	and a
	jr nz, jr_006_609c

	ld a, [$c5a9]
	and a
	jr nz, jr_006_6098

	ld a, $ff
	ld [$db93], a
	ld a, $9a
	call Call_2185
	ld hl, $c19f
	set 7, [hl]

jr_006_6098:
	call Call_3B8D
	ld [hl], b

jr_006_609c:
	ld a, $02
	ldh [$ffa1], a
	ret


	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $76, $00, $76, $20, $74, $20
	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20
	db $3e, $00

Call_06_60C3::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_60e6

	ld de, $60c1
	call Call_3CD0
	call Call_06_64DF
	call Call_06_654B
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	call Call_0891
	jp z, Call_06_65E5

	ret


jr_006_60e6:
	ld a, [$db56]
	cp $80
	jp nz, Jump_006_61a8

	ld a, [$db95]
	cp $01
	jp z, Jump_006_61a8

	ld de, $60a1
	call Call_3C3B
	call Call_06_65AE
	ld a, e
	dec a
	and $02
	xor $02
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_6117::
	dw Jump_06_611D
	dw Jump_06_6135
	dw Jump_06_616C

Jump_06_611D::
	call Call_06_64DF
	ld hl, $c2c0
	add hl, bc
	ld [hl], $30
	ld a, $0e
	ld [$d368], a
	ldh [$ffb0], a
	ldh [$ffbd], a

Jump_006_612f:
	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ret


Jump_06_6135::
	call Call_06_64DF
	call Call_06_65AE
	add $20
	cp $40
	jr c, jr_006_6148

	ld hl, $c2c0
	add hl, bc
	dec [hl]
	jr nz, jr_006_615c

jr_006_6148:
	ld a, [$c16b]
	cp $04
	ret nz

	ldh a, [$ffeb]
	cp $71
	jr nz, jr_006_6159

	ld a, $20
	call Call_218E

jr_006_6159:
	jp Jump_006_612f


jr_006_615c:
	ld a, $08
	call Call_3C25
	call Call_06_654B
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ret


Jump_06_616C::
	xor a
	ld [$c167], a
	ldh a, [$ffef]
	ldh [$ffec], a
	call Call_06_6449
	call Call_3DBA
	call Call_06_648C
	jr nc, jr_006_6184

	ld a, $20
	call Call_218E

jr_006_6184:
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6199

	and $80
	jr z, jr_006_61a7

jr_006_6199:
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_006_61a7

	ld [hl], $10

jr_006_61a7:
	ret


Jump_006_61a8:
	ld hl, $c380
	add hl, bc
	ldh a, [$fff1]
	or [hl]
	ldh [$fff1], a
	ld de, $60b1
	call Call_3C3B
	call Call_06_64DF
	call Call_06_626A
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_61d7

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], a

jr_006_61d7:
	ldh a, [$fff0]
	rst $00

JumpTable_06_61DA::
	dw Jump_06_61DE
	dw Jump_06_6224

Jump_06_61DE::
	call Call_0891
	jr nz, jr_006_6223

	ld [hl], $80
	call Call_3B8D
	ld a, $01
	call Call_3B87
	ld a, $71
	call Call_3C01
	jr c, jr_006_6223

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
	ld [hl], $01
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ldh a, [$ffeb]
	cp $71
	ld a, $14
	jr z, jr_006_6218

	ld a, $ec

jr_006_6218:
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $24

jr_006_6223:
	ret


Jump_06_6224::
	call Call_0891
	jr nz, jr_006_6230

	ld [hl], $60
	call Call_3B8D
	ld [hl], b
	ret


jr_006_6230:
	cp $60
	jr nc, jr_006_6247

	cp $40
	jr nc, jr_006_6243

	ldh a, [$ffe8]
	and a
	jr z, jr_006_6243

	ld hl, $c320
	add hl, bc
	ld [hl], $08

jr_006_6243:
	xor a
	call Call_3B87

jr_006_6247:
	ret


Call_06_6248::
	ldh a, [$fff6]
	cp $92
	jr nz, jr_006_6256

	ld a, [$db0e]
	cp $07
	jp c, Call_06_65E5

jr_006_6256:
	ld de, $60a1
	call Call_3C3B
	call Call_06_64DF
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87

Call_06_626A::
	ldh a, [$ffef]
	ldh [$ffec], a
	call Call_06_6449
	call Call_3DBA
	call Call_06_648C
	jr nc, jr_006_62dd

	ld a, [$db74]
	and a
	jr z, jr_006_6284

	ld a, $23
	jp Call_2185


jr_006_6284:
	ld a, [$db73]
	and a
	jr z, jr_006_628f

	ld a, $21
	jp Call_2185


jr_006_628f:
	ldh a, [$fff6]
	cp $92
	jr nz, jr_006_62a1

	ld a, [$d8fd]
	and $30
	jr nz, jr_006_62a1

	ld a, $20
	jp Call_2185


jr_006_62a1:
	ld a, [$db66]
	and $02
	jr z, jr_006_62ba

	ld a, [$dabe]
	and $10
	jr nz, jr_006_62ba

	ldh a, [$fff6]
	cp $83
	jr nz, jr_006_62ba

	ld a, $22
	jp Call_2185


jr_006_62ba:
	ld hl, $db7e
	ld a, [hl]
	push af
	inc a
	cp $04
	jr nz, jr_006_62c5

	xor a

jr_006_62c5:
	ld [hl], a
	ld a, [$db65]
	and $02
	jr nz, jr_006_62d3

	pop af
	add $18
	jp Call_2185


jr_006_62d3:
	pop af
	ldh a, [$ffeb]
	sub $70
	add $1c
	call Call_2185

jr_006_62dd:
	ret


Call_06_62DE::
	call Call_06_63A3
	call Call_06_64DF
	call Call_08E2
	call Call_3BEB
	call Call_06_6449
	ldh a, [$fff0]
	rst $00

JumpTable_06_62F0::
	dw Jump_06_62F6
	dw Jump_06_62FE
	dw Jump_06_6312

Jump_06_62F6::
	call Call_0891
	ld [hl], $c0
	jp Call_3B8D


Jump_06_62FE::
	call Call_0891
	jr nz, jr_006_6308

	ld [hl], $50
	call Call_3B8D

jr_006_6308:
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_06_6312::
	call Call_0891
	jr nz, jr_006_631b

	call Call_3B8D
	ld [hl], b

jr_006_631b:
	cp $4a
	jr nz, jr_006_633d

	ld a, $7d
	call Call_3C01
	jr c, jr_006_633d

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
	ld a, $0c
	call Call_3C25
	pop bc

jr_006_633d:
	ld a, $02
	call Call_3B87
	ret


	db $f8, $f8, $70, $00, $f8, $00, $72, $00, $f8, $08, $72, $20, $f8, $10, $70, $20
	db $08, $f8, $74, $00, $08, $00, $76, $00, $08, $08, $76, $20, $08, $10, $74, $20
	db $f9, $f9, $70, $00, $f9, $01, $72, $00, $f9, $07, $72, $20, $f9, $0f, $70, $20
	db $07, $f9, $74, $00, $07, $01, $76, $00, $07, $07, $76, $20, $07, $0f, $74, $20
	db $f8, $f8, $78, $00, $f8, $00, $7a, $00, $f8, $08, $7a, $20, $f8, $10, $78, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20

Call_06_63A3::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6343
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $32, $00, $32, $20, $30, $00, $30, $20

Call_06_63CD::
	ld hl, $c360
	add hl, bc
	ld [hl], $30
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_63e3

	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a

jr_006_63e3:
	ld de, $63bd
	call Call_3C3B
	call Call_0891
	jr z, jr_006_63fc

	dec a
	jp z, Call_06_65E5

	rra
	rra
	rra
	and $01
	add $02
	jp Call_3B87


jr_006_63fc:
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	cp $02
	jr c, jr_006_640b

	call Call_0891
	ld [hl], $10
	ret


jr_006_640b:
	ld [hl], b
	call Call_06_64DF
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BB4
	call Call_06_654B
	jp Call_06_5EBC


	db $50, $00, $50, $20, $52, $00, $52, $20

Call_06_642A::
	ld de, $6422
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_3BEB
	call Call_06_6449
	ldh a, [$ffe7]
	ld e, b
	and $30
	jr z, jr_006_6444

	inc e

jr_006_6444:
	ld a, e
	call Call_3B87
	ret


Call_06_6449::
	call Call_3BD5
	jr nc, jr_006_646b

Call_06_644E::
	call Call_094A
	call Call_0942
	ld a, [$c1a6]
	and a
	jr z, jr_006_646b

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_006_646b

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_006_646b:
	ret


	db $06, $04, $02, $00

Call_06_6470::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $646c
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


Call_06_648C::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28

Call_06_6497::
	jr nc, jr_006_64dd

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_006_64dd

	inc e
	ldh a, [$ffeb]
	cp $78
	jr z, jr_006_64b8

	push de
	call Call_06_65BE
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_006_64dd

jr_006_64b8:
	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_006_64dd

	ld a, [$db9a]
	cp $80
	jr nz, jr_006_64dd

	ldh a, [$ffcc]
	and $10
	jr z, jr_006_64dd

	scf
	ret


jr_006_64dd:
	and a
	ret


Call_06_64DF::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_006_64ff

Call_06_64E5::
	ld a, [$db95]
	cp $07
	jr z, jr_006_64ff

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_006_64ff

	ld a, [$c124]
	and a
	jr z, jr_006_6500

jr_006_64ff:
	pop af

jr_006_6500:
	ret


Call_06_6501::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_654a

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
	call Call_06_654B
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_006_653d

	call Call_3B9E

jr_006_653d:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_006_654a:
	ret


Call_06_654B::
	call Call_06_6558
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_06_6558
	pop bc
	ret


Call_06_6558::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6583

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

jr_006_6570:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_006_657a

	ld e, $f0

jr_006_657a:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_006_6583:
	ret


Call_06_6584::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6583

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_006_6570

Call_06_659E::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_006_65ac

	inc e

jr_006_65ac:
	ld d, a
	ret


Call_06_65AE::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_006_65bc

	inc e

jr_006_65bc:
	ld d, a
	ret


Call_06_65BE::
	call Call_06_659E
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_006_65cb

	cpl
	inc a

jr_006_65cb:
	push af
	call Call_06_65AE
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_006_65d9

	cpl
	inc a

jr_006_65d9:
	pop de
	cp d
	jr nc, jr_006_65e1

	ldh a, [$ffd7]
	jr jr_006_65e3

jr_006_65e1:
	ldh a, [$ffd8]

jr_006_65e3:
	ld e, a
	ret


Call_06_65E5::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


	db $6a, $20, $68, $20, $68, $00, $6a, $00, $6c, $40, $6c, $60, $6c, $00, $6c, $20

Call_06_65FB::
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ld de, $65eb
	call Call_3C3B
	call Call_06_64DF
	call Call_3BCA
	call Call_06_654B
	call Call_3BA9
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6620

	call Call_06_65E5

jr_006_6620:
	ret


	db $5c, $00, $5c, $20, $5c, $10, $5c, $30, $00, $10, $00, $f0, $00, $f0, $00, $10
	db $10, $00, $f0, $00, $10, $00, $f0, $00, $01, $08, $02, $04, $01, $04, $02, $08

Call_06_6641::
	ld a, $01
	ldh [$ffbe], a
	ldh a, [$ffe7]
	rra
	and $01
	ldh [$fff1], a
	ld de, $6621
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BBF
	call Call_06_654B
	call Call_06_66D8
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $c2c0
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6639
	add hl, de
	push hl
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	pop hl
	and [hl]
	jr nz, jr_006_6691

	call Call_0891
	jr nz, jr_006_669c

	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_66a9

	call Call_0891
	ld [hl], $09
	jr jr_006_66a9

jr_006_6691:
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $03
	ld [hl], a
	jr jr_006_66a9

jr_006_669c:
	cp $06
	jr nz, jr_006_66a9

	ld hl, $c2b0
	add hl, bc
	dec [hl]
	ld a, [hl]
	and $03
	ld [hl], a

jr_006_66a9:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $c2c0
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6629
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $c2c0
	add hl, bc
	add [hl]
	ld e, a
	ld hl, $6631
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ret


Call_06_66D8::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push af
	ld [hl], $01
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $c240
	add hl, bc
	ld [hl], $ff
	ld hl, $c250
	add hl, bc
	ld [hl], $ff
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	pop af
	or [hl]
	ld [hl], a
	pop af
	ld hl, $c250
	add hl, bc
	ld [hl], a
	pop af
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ret


	db $42, $00, $42, $20, $40, $00, $40, $20, $62, $00, $62, $20, $60, $00, $60, $20
	db $00, $05, $0a, $0d, $0e, $0d, $0a, $05, $00, $fb, $f6, $f3, $f2, $f3, $f6, $fb
	db $00, $05, $0a, $0d, $0c, $04, $08, $00

Call_06_673C::
	ld de, $6714
	ldh a, [$fff7]
	cp $0a
	jr nz, jr_006_6748

	ld de, $671c

jr_006_6748:
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_06_6757::
	dw Jump_06_675B
	dw Jump_06_679B

Jump_06_675B::
	call Call_0891
	jp nz, Jump_006_67f2

	call Call_06_659E
	add $20
	cp $40
	jp nc, Jump_006_67f2

	call Call_06_65AE
	add $20
	cp $40
	jp nc, Jump_006_67f2

	call Call_06_65BE
	ld d, $00
	ld hl, $6738
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_0891
	call Call_27ED
	and $3f
	add $50
	ld [hl], a
	ld hl, $c2c0
	add hl, bc
	ld [hl], $01
	call Call_3B8D
	jp Jump_006_67f2


Jump_06_679B::
	call Call_06_654B
	call Call_3B9E
	call Call_0891
	jr nz, jr_006_67ae

	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	jr jr_006_67f2

jr_006_67ae:
	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_006_67f2

	ld [hl], b
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	add [hl]
	and $0f
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6724
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $6728
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $1f
	jr nz, jr_006_67f2

	call Call_27ED
	and $02
	dec a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

Jump_006_67f2:
jr_006_67f2:
	ldh a, [$fff0]
	and a
	jr z, jr_006_67fe

	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01

jr_006_67fe:
	jp Call_3B87


Call_06_6801::
	ld a, c
	ld [$c501], a
	ldh a, [$fff6]
	cp $64
	jr nz, jr_006_6819

	ld a, [$d9e3]
	and $40
	ret z

	ld a, [$db69]
	and $02
	jp nz, Call_06_65E5

jr_006_6819:
	ldh a, [$fff6]
	cp $ac
	jr nz, jr_006_6826

	ldh a, [$fff8]
	and $10
	jp z, Call_06_65E5

jr_006_6826:
	ldh a, [$fff6]
	cp $41
	jr nz, jr_006_6835

	ld a, [$db11]
	and a
	ret z

	call Call_088C
	ret nz

jr_006_6835:
	ldh a, [$fff6]
	cp $ee
	jr nz, jr_006_6841

	ld a, [$db12]
	and a
	jr jr_006_68a9

jr_006_6841:
	ldh a, [$fff6]
	cp $d2
	jr z, jr_006_685a

	cp $36
	jr nz, jr_006_685f

	ld a, [$db66]
	and a
	jp nz, Call_06_65E5

	ld a, [$db56]
	cp $01
	jp nz, Call_06_65E5

jr_006_685a:
	ld a, [$db65]
	jr jr_006_68a7

jr_006_685f:
	ldh a, [$fff6]
	cp $08
	jr nz, jr_006_6875

	ld a, [$db6c]
	and $02
	jp nz, Call_06_65E5

	ld a, [$d808]
	and $10
	ret z

	jr jr_006_68ac

jr_006_6875:
	cp $9d
	jr nz, jr_006_687e

	ld a, [$db69]
	jr jr_006_68a7

jr_006_687e:
	cp $06
	jr nz, jr_006_688a

	ld a, [$d806]
	and $10
	ret z

	jr jr_006_68ac

jr_006_688a:
	cp $b6
	jr nz, jr_006_6893

	ld a, [$db67]
	jr jr_006_68a7

jr_006_6893:
	cp $17
	jr z, jr_006_689b

	cp $9c
	jr nz, jr_006_68a0

jr_006_689b:
	ld a, [$db6a]
	jr jr_006_68a7

jr_006_68a0:
	cp $16
	jr nz, jr_006_68ac

	ld a, [$db66]

jr_006_68a7:
	and $02

jr_006_68a9:
	jp z, Call_06_65E5

jr_006_68ac:
	ldh a, [$fff6]
	cp $d2
	jr z, jr_006_68c0

	cp $16
	jr z, jr_006_68c0

	cp $36
	jr z, jr_006_68c0

	ldh a, [$fff0]
	cp $00
	jr z, jr_006_68c3

jr_006_68c0:
	call Call_06_6A5A

jr_006_68c3:
	ldh a, [$ffe7]
	and $b0
	ld a, $00
	jr nz, jr_006_68cc

	inc a

jr_006_68cc:
	call Call_3B87
	ld a, [$c124]
	and a
	ret nz

	ldh a, [$fff0]
	rst $00

JumpTable_06_68D7::
	dw Jump_06_68E1
	dw Jump_06_693C
	dw Jump_06_6982
	dw Jump_06_69B1
	dw Jump_06_69DB

Jump_06_68E1::
	ldh a, [$fff6]
	cp $f2
	jr nz, jr_006_68fb

	ld a, $1d
	ldh [$ffb0], a
	ldh a, [$ff99]
	cp $44
	ret c

	ldh a, [$ff98]
	sub $58
	add $18
	cp $30
	ret nc

	jr jr_006_6902

jr_006_68fb:
	ld a, [$db4e]
	and a
	jp z, Call_06_65E5

jr_006_6902:
	ldh a, [$ffb0]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld a, $22
	ld [$d368], a
	ldh [$ffb0], a
	ldh [$ffbd], a
	ldh a, [$fff6]
	cp $16
	jr z, jr_006_6920

	cp $36
	jr z, jr_006_6920

	cp $d2
	jr nz, jr_006_6926

jr_006_6920:
	call Call_3B8D
	ld [hl], $02
	ret


jr_006_6926:
	ld hl, $c310
	add hl, bc
	ld [hl], $20
	ld hl, $c240
	add hl, bc
	ld [hl], $18
	ld hl, $c250
	add hl, bc
	ld [hl], $10
	call Call_3B8D
	ret


Jump_06_693C::
	call Call_06_65BE
	ld a, e
	xor $01
	ldh [$ff9e], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $05
	ld [$c111], a
	call Call_06_69CD
	call Call_06_654B
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_695f

	call Call_3B8D
	ret


jr_006_695f:
	ld hl, $c320
	add hl, bc
	ld [hl], $fc
	call Call_06_6584
	call Call_29C5
	ldh a, [$ffe7]
	and $03
	jr nz, jr_006_6981

	ld a, $00
	ld hl, $c250
	call Call_06_6A36
	ld a, $00
	ld hl, $c240
	call Call_06_6A36

jr_006_6981:
	ret


Jump_06_6982::
	call Call_06_64DF
	call Call_06_6449
	ld a, [$c16b]
	cp $04
	ret nz

	ld a, [$c17b]
	and a
	ret nz

	ldh a, [$fff6]
	cp $06
	jr nz, jr_006_69a0

	ld a, $cd
	call Call_2197
	jr jr_006_69a3

jr_006_69a0:
	call Call_29D0

jr_006_69a3:
	ld a, $19
	ld [$c5ab], a
	call Call_3B8D
	call Call_0891
	ld [hl], $10
	ret


Jump_06_69B1::
	call Call_06_64DF
	ldh a, [$fff6]
	cp $06
	jr z, jr_006_69c2

	call Call_0891
	jr nz, Call_06_69CD

	call Call_3B8D

jr_006_69c2:
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ld hl, $d800
	add hl, de
	set 5, [hl]
	ret


Call_06_69CD::
	ld a, $02
	ldh [$ffa1], a
	ldh a, [$ffe7]
	rra
	rra
	and $02
	call Call_3B87
	ret


Jump_06_69DB::
	call Call_06_64DF
	call Call_06_69CD
	call Call_06_654B
	call Call_06_5EBC
	ld hl, $c320
	add hl, bc
	ld [hl], $04
	call Call_06_6584
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_6a10

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld [$d368], a
	ldh [$ffb0], a
	ld a, [$d47c]
	and a
	jr z, jr_006_6a0f

	ld a, $49
	ld [$d368], a
	ldh [$ffbd], a

jr_006_6a0f:
	ret


jr_006_6a10:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_006_6a1a

	ld a, $05
	ldh [$fff4], a

jr_006_6a1a:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_006_6a41

	ld a, $20
	call Call_3C30
	ldh a, [$ffd7]
	cpl
	inc a
	ld hl, $c250
	call Call_06_6A36
	ldh a, [$ffd8]
	cpl
	inc a
	ld hl, $c240

Call_06_6A36::
	add hl, bc
	sub [hl]
	jr z, jr_006_6a41

	bit 7, a
	jr z, jr_006_6a40

	dec [hl]
	dec [hl]

jr_006_6a40:
	inc [hl]

jr_006_6a41:
	ret


	db $78, $00, $78, $20, $7a, $00, $7a, $20, $00, $f8, $7c, $00, $00, $00, $7e, $00
	db $00, $08, $7e, $20, $00, $10, $7c, $20

Call_06_6A5A::
	ldh a, [$fff1]
	cp $02
	jr nc, jr_006_6a66

	ld de, $6a42
	jp Call_3C3B


jr_006_6a66:
	ld hl, $6a4a
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ldh a, [$fff6]
	cp $08
	jr z, jr_006_6a7d

	call Call_3D19
	ret


jr_006_6a7d:
	ld hl, $c340
	add hl, bc
	res 4, [hl]
	ret


	db $50, $00, $52, $00

Call_06_6A88::
	ldh a, [$ffec]
	sub $05
	ldh [$ffec], a
	ld de, $6a84
	call Call_3C3B
	call Call_06_64DF
	call Call_06_648C
	ret nc

	ld e, $fd
	ldh a, [$fff6]
	cp $a9
	jp z, Jump_006_6b98

	ld e, $41
	ld a, [$daa9]
	and $20
	jp z, Jump_006_6b98

	ld e, $46
	ld a, [$db65]
	and $02
	jp z, Jump_006_6b98

	ld e, $42
	ld a, [$db56]
	cp $80
	jp z, Jump_006_6b98

	ld e, $43
	ld a, [$db66]
	and $02
	jp z, Jump_006_6b98

	ld e, $44
	ld a, [$db56]
	cp $01
	jp z, Jump_006_6b9e

	ld e, $44
	ld a, [$db55]
	cp $02
	jp nz, Jump_006_6b98

	ld e, $45
	ld a, [$db0e]
	cp $05
	jp c, Jump_006_6b98

	ld e, $47
	ld a, [$db15]
	cp $05
	jp c, Jump_006_6b98

	ld e, $48
	jp z, Jump_006_6b98

	cp $06
	jp nz, Jump_006_6b98

	ld e, $49
	ld a, [$db67]
	and $02
	jp z, Jump_006_6b98

	ld e, $4a
	ld a, [$db12]
	and a
	jp z, Jump_006_6b98

	ld e, $40
	ld a, [$db68]
	and $02
	jp z, Jump_006_6b9e

	ld a, [$db79]
	and a
	jr z, jr_006_6b2a

	ld e, $4b
	ld a, [$d9e3]
	and $40
	jr z, jr_006_6b98

jr_006_6b2a:
	ld e, $4c
	ld a, [$db69]
	and $02
	jr z, jr_006_6b98

	ld e, $45
	ld a, [$db49]
	and $01
	jp z, Jump_006_6b9e

	ld e, $4d
	ld a, [$db6a]
	and $02
	jr z, jr_006_6b98

	ld e, $4e
	ld a, [$db7b]
	and a
	jr z, jr_006_6b59

	ld e, $46
	ld a, [$db14]
	and a
	jp z, Jump_006_6b9e

	ld e, $41

jr_006_6b59:
	ld a, [$db6b]
	and $02
	jr nz, jr_006_6b67

	ld a, e
	cp $4e
	jr z, jr_006_6b98

	jr jr_006_6b9e

jr_006_6b67:
	ld e, $4f
	ld a, [$d810]
	and $30
	jr z, jr_006_6b98

	ld e, $48
	ld a, [$db6c]
	and $02
	jr z, jr_006_6b9e

	ld e, $42
	ld a, [$d806]
	and $30
	jr z, jr_006_6b9e

	ld e, $43
	ld a, [$da74]
	and $40
	jr z, jr_006_6b9e

	ld e, $47
	ld a, [$db4e]
	cp $02
	jr c, jr_006_6b9e

	ld e, $48
	jr jr_006_6b9e

Jump_006_6b98:
jr_006_6b98:
	ld a, e
	call Call_2185
	jr jr_006_6ba2

Jump_006_6b9e:
jr_006_6b9e:
	ld a, e
	call Call_218E

jr_006_6ba2:
	ld hl, $daa9
	set 5, [hl]
	ret


	db $5e, $00, $5e, $40, $04, $fc, $03, $fd, $02, $fe, $05, $fa

Call_06_6BB4::
	ldh a, [$fff1]
	cp $01
	jr nz, jr_006_6bc0

	ldh a, [$ffec]
	sub $00
	ldh [$ffec], a

jr_006_6bc0:
	ld de, $6ba8
	call Call_3CD0
	call Call_06_64DF
	ld a, c
	sla a
	sla a
	sla a
	ld hl, $ffe7
	add [hl]
	ldh [$fff0], a
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_06_654B
	ldh a, [$fff0]
	and $1f
	jr nz, jr_006_6bfd

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $6bac
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	add [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_006_6bfd:
	ldh a, [$fff0]
	add $10
	and $1f
	jr nz, jr_006_6c1b

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $6bac
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	add [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_6c1b:
	ldh a, [$fff0]
	and $3f
	jr nz, jr_006_6c57

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$c50f]
	cp $ff
	jr z, jr_006_6c3e

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

jr_006_6c3e:
	ld a, $02
	call Call_3C30
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	ldh a, [$ffd7]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a

jr_006_6c57:
	ret


Call_06_6C58::
	ld a, c
	ld [$d202], a
	ldh a, [$fff7]
	cp $07
	jr nz, jr_006_6c66

	ld a, $10
	ldh [$fff5], a

jr_006_6c66:
	call Call_06_6E6C
	call Call_3F12
	call Call_380E
	ldh a, [$ffea]
	cp $05
	jr z, jr_006_6cca

	ld hl, $c430
	add hl, bc
	ld [hl], $80
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_6C81::
	dw Jump_06_6C85
	dw Jump_06_6C96

Jump_06_6C85::
	call Call_0891
	ld [hl], $ff
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ret


Jump_06_6C96::
	call Call_0891
	jp z, Jump_006_6ca9

	ld hl, $c420
	add hl, bc
	ld [hl], a
	cp $80
	jr nc, jr_006_6ca8

	call Call_06_6FFC

jr_006_6ca8:
	ret


Jump_006_6ca9:
	call Call_27BD
	call Call_3F7A
	ldh a, [$fff7]
	cp $07
	ret z

Jump_006_6cb4:
	ldh a, [$fff6]
	ld e, a
	ld d, b
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_006_6cc3

	cp $06
	jr c, jr_006_6cc3

	inc d

jr_006_6cc3:
	ld hl, $d900
	add hl, de
	set 5, [hl]
	ret


jr_006_6cca:
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6cef

	ld e, $00
	and $80
	jr nz, jr_006_6cea

	ld e, $03

jr_006_6cea:
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_006_6cef:
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	nop
	nop
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_6d14

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	ld [hl], b
	cp $f2
	jr nc, jr_006_6d14

	ld a, $20
	ldh [$fff2], a

jr_006_6d14:
	ldh a, [$fff0]
	rst $00

JumpTable_06_6D17::
	dw Jump_06_6D1F
	dw Jump_06_6D60
	dw Jump_06_6D91
	dw Jump_06_6D9A

Jump_06_6D1F::
	call Call_0891
	jr nz, jr_006_6d5f

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	ld e, $08
	bit 7, a
	jr nz, jr_006_6d38

	ld e, $f8

jr_006_6d38:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	add $10
	cp $20
	jr nc, jr_006_6d4c

	call Call_0891
	ld [hl], $18
	call Call_3B8D
	ret


jr_006_6d4c:
	call Call_06_6558
	ldh a, [$ffe8]
	and a
	jr z, jr_006_6d5a

	ld hl, $c320
	add hl, bc
	ld [hl], $0c

jr_006_6d5a:
	ld a, $01
	call Call_3B87

jr_006_6d5f:
	ret


Jump_06_6D60::
	call Call_0891
	jr nz, jr_006_6d90

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	ld a, $10
	jr nz, jr_006_6d71

	ld a, $f0

jr_006_6d71:
	push af
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c240
	add hl, de
	pop af
	ld [hl], a
	ld hl, $c290
	add hl, de
	ld [hl], $01
	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld a, $00
	call Call_3B87

jr_006_6d90:
	ret


Jump_06_6D91::
	call Call_0891
	jr nz, jr_006_6d99

	call Call_3B8D

jr_006_6d99:
	ret


Jump_06_6D9A::
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $08
	ld a, $01
	jr c, jr_006_6da6

	inc a

jr_006_6da6:
	call Call_3B87
	call Call_0891
	cp $01
	jr z, jr_006_6dc0

	cp $00
	jp nz, Jump_006_6e0b

	ldh a, [$ffe8]
	and a
	jr z, jr_006_6df0

	call Call_0891
	ld [hl], $10
	ret


jr_006_6dc0:
	ld e, $10
	ld hl, $c320
	add hl, bc
	ld [hl], $19
	ldh a, [$ffe9]
	cp $05
	jr nc, jr_006_6dd2

	ld e, $14
	ld [hl], $16

jr_006_6dd2:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	ld a, e
	jr nz, jr_006_6ddd

	cpl
	inc a

jr_006_6ddd:
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$ffec]
	cp $50
	ld a, e
	jr c, jr_006_6deb

	cpl
	inc a

jr_006_6deb:
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_6df0:
	call Call_06_654B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_6e0b

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $08
	call Call_3DAF

Jump_006_6e0b:
jr_006_6e0b:
	ret


	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $f0, $00, $6e, $20
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $00, $6e, $00
	db $00, $f8, $66, $00, $00, $00, $68, $00, $00, $08, $6a, $00, $f0, $06, $6e, $20
	db $00, $00, $64, $20, $00, $08, $62, $20, $00, $10, $60, $20, $f0, $08, $6e, $00
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $08, $6e, $20
	db $00, $00, $6a, $20, $00, $08, $68, $20, $00, $10, $66, $20, $f0, $02, $6e, $00

Call_06_6E6C::
	ld hl, $c380
	add hl, bc
	ldh a, [$fff1]
	add [hl]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $6e0c
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6ec5

	ldh a, [$ffe7]
	and $01
	jr nz, jr_006_6ec5

	ld a, [$c3c0]
	ld e, a
	ld d, b
	ld hl, $c030
	add hl, de
	ldh a, [$ffef]
	add $0c
	ld [hli], a
	ldh a, [$ffee]
	add $02
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld a, $00
	ld [hli], a
	ldh a, [$ffef]
	add $0c
	ld [hli], a
	ldh a, [$ffee]
	add $04
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $02
	call Call_3DD0

jr_006_6ec5:
	ret


	db $6c, $00, $6c, $20, $6c, $40, $6c, $60, $70, $60, $50, $40, $30, $20

Call_06_6ED4::
	ldh a, [$fff7]
	cp $07
	jr nz, jr_006_6ede

	ld a, $10
	ldh [$fff5], a

jr_006_6ede:
	ldh a, [$fff8]
	and $20
	jp nz, Call_06_65E5

	ld a, c
	ld [$d201], a
	call Call_06_6FDB
	call Call_06_64DF
	ld a, [$d202]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $01
	ret z

	and a
	jr nz, jr_006_6f39

	call Call_0891
	jr nz, jr_006_6f38

	ld [hl], $03
	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffee]
	ldh [$ffd7], a
	ld e, [hl]
	inc [hl]
	ld a, [hl]
	cp $06
	jr nz, jr_006_6f2d

	call Call_06_65E5
	ld hl, $c460
	add hl, bc
	ld e, [hl]
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

jr_006_6f2d:
	ld d, b
	ld hl, $6ece
	add hl, de
	ld a, [hl]
	ldh [$ffd8], a
	jp Jump_006_7029


jr_006_6f38:
	ret


jr_006_6f39:
	call Call_08E2
	ldh a, [$ffa2]
	and a
	jr nz, jr_006_6f44

	call Call_3BB4

jr_006_6f44:
	call Call_06_6558
	call Call_3B9E
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6f77

	bit 7, a
	jr z, jr_006_6f58

	cpl
	inc a

jr_006_6f58:
	ld e, $04
	cp $08
	jr nc, jr_006_6f60

	ld e, $08

jr_006_6f60:
	cp $04
	jr nc, jr_006_6f66

	ld e, $10

jr_006_6f66:
	cp $02
	jr nc, jr_006_6f6c

	ld e, $20

jr_006_6f6c:
	ld d, b
	ldh a, [$ffe7]
	and e
	jr z, jr_006_6f73

	inc d

jr_006_6f73:
	ld a, d
	call Call_3B87

jr_006_6f77:
	ldh a, [$fff0]
	rst $00

JumpTable_06_6F7A::
	dw Jump_06_6F80
	dw Jump_06_6F81
	dw Jump_06_6FB5

Jump_06_6F80::
	ret


Jump_06_6F81::
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_6fa4

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	inc a
	ld [hl], a
	ld a, $20
	ld [$c157], a
	xor a
	ld [$c158], a
	ld a, $0b
	ldh [$fff2], a
	call Call_3B8D

jr_006_6fa4:
	ld a, [$d210]
	inc a
	cp $09
	jr c, jr_006_6fb1

	ld a, $1a
	ldh [$fff3], a
	xor a

jr_006_6fb1:
	ld [$d210], a
	ret


Jump_06_6FB5::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_006_6fca

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_6fcb

	and $80
	jr z, jr_006_6fc9

	inc [hl]
	inc [hl]

jr_006_6fc9:
	dec [hl]

jr_006_6fca:
	ret


jr_006_6fcb:
	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $50
	ret


	db $80, $70, $60, $50, $40, $30

Call_06_6FDB::
	ld a, $20
	ldh [$ffec], a

jr_006_6fdf:
	ld de, $6ec6
	call Call_3C3B
	ldh a, [$ffec]
	add $10
	ldh [$ffec], a
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6fd5
	add hl, de
	cp [hl]
	jr nz, jr_006_6fdf

	call Call_3DBA
	ret


Call_06_6FFC::
	and $07
	jr nz, jr_006_701d

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
	call Call_06_701E

jr_006_701d:
	ret


Call_06_701E::
	call Call_06_64E5
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a

Jump_006_7029:
	ld a, $02
	call Call_0953
	ld a, $13
	ldh [$fff4], a
	ret


	db $3e, $36, $cd, $01, $3c, $f0, $d7, $21, $00, $c2, $19, $77, $f0, $d8, $21, $10
	db $c2, $19, $77, $f0, $f9, $a7, $28, $08, $21, $50, $c2, $09, $36, $f0, $18, $0c
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08, $cd, $e5, $65, $cd
	db $d7, $08, $c9

Call_06_7066::
	ldh a, [$fff0]
	rst $00

JumpTable_06_7069::
	dw Jump_06_706F
	dw Jump_06_70CE
	dw Jump_06_716D

Jump_06_706F::
	call Call_06_659E
	add $0e
	cp $1c
	jr nc, jr_006_70bd

	call Call_06_65AE
	add $0c
	cp $18
	jr nc, jr_006_70bd

	ldh a, [$ff9e]
	and a
	jr nz, jr_006_70bd

	ld a, [$c133]
	and a
	jr z, jr_006_70bd

	call Call_3B8D
	call Call_0891
	ld [hl], $a0
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
	ld a, $01
	ld [$c10a], a
	ld a, $1e
	ld [$d368], a
	xor a
	ld [$c16b], a
	ld [$c16c], a

jr_006_70bd:
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $98, $42, $98, $50, $99, $90, $99, $82

Jump_06_70CE::
	ld a, [$c146]
	and a
	jp nz, Jump_006_716c

	call Call_0891
	jr nz, jr_006_70ec

	ld a, $01
	ld [$c17f], a
	xor a
	ld [$c180], a
	ld a, $08
	ld [$c3ca], a
	call Call_3B8D
	xor a

jr_006_70ec:
	push af
	cp $80
	jr nc, jr_006_7144

	push af
	and $1f
	jr nz, jr_006_7107

	ld a, [$c16b]
	cp $02
	jr z, jr_006_7107

	ld a, $03
	ld [$c16c], a
	push bc
	call Call_1776
	pop bc

jr_006_7107:
	pop af
	and $0f
	jr nz, jr_006_7144

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_006_7144

	ld a, [$d600]
	ld e, a
	ld d, b
	add $05
	ld [$d600], a
	ld hl, $d601
	add hl, de
	push hl
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	inc [hl]
	sla a
	ld e, a
	ld d, b
	ld hl, $70c6
	add hl, de
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, $64
	ld [hli], a
	ld a, $65
	ld [hli], a
	ld [hl], b

jr_006_7144:
	pop af
	ld e, $00
	cp $80
	jr c, jr_006_714c

	inc e

jr_006_714c:
	ld a, e

Call_06_714D::
	ldh [$fff1], a
	ld a, $58
	ldh [$ffee], a
	ldh [$ff98], a
	ld a, $44
	ldh [$ffec], a
	ldh [$ff99], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $ff
	ldh [$ff9d], a
	ld de, $70be
	call Call_3C3B
	call Call_3DBA

Jump_006_716c:
	ret


Jump_06_716D::
	xor a
	call Call_06_714D
	ld a, [$c17f]
	and a
	jr nz, jr_006_7192

	xor a
	ldh [$ff9d], a
	ld hl, $d401
	ld a, $01
	ld [hli], a
	ldh a, [$fff7]
	ld [hli], a
	ld a, $ce
	ld [hli], a
	ld a, $50
	ld [hli], a
	ld a, $7c
	ld [hl], a
	call Call_06_65E5
	jp Call_092A


jr_006_7192:
	ret


	db $f0, $fc, $50, $00, $f0, $04, $52, $00, $f0, $0c, $54, $00, $00, $fc, $56, $00
	db $00, $04, $58, $00, $00, $0c, $5a, $00, $f0, $fc, $50, $00, $f0, $04, $52, $00
	db $f0, $0c, $54, $00, $00, $fc, $5c, $00, $00, $04, $58, $00, $00, $0c, $5e, $00
	db $a8, $10, $01, $ff, $18, $e8

Call_06_71C9::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_006_7235

	ld hl, $c280
	ld a, [$d201]
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	and a
	jp z, Call_06_65E5

	ld a, [$d202]
	ldh [$fff1], a
	ld de, $71c3
	call Call_3CD0
	ldh a, [$ffe7]
	and $01
	jr nz, jr_006_7231

	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $71c5
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $71c7
	add hl, de
	cp [hl]
	jr nz, jr_006_7211

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_006_7211:
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $71c5
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $71c7
	add hl, de
	cp [hl]
	jr nz, jr_006_7231

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_006_7231:
	call Call_06_654B
	ret


Jump_006_7235:
	ld hl, $7193
	ldh a, [$ffe7]
	and $08
	jr z, jr_006_7241

	ld hl, $71ab

jr_006_7241:
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	call Call_3D19
	ld e, $fe
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $40
	jr z, jr_006_725c

	ld e, $02

jr_006_725c:
	ld hl, $c320
	add hl, bc
	ld [hl], e
	call Call_06_6584
	call Call_06_64DF
	ldh a, [$fff0]
	rst $00

JumpTable_06_726A::
	dw Jump_06_7270
	dw Jump_06_729A
	dw Jump_06_7306

Jump_06_7270::
	xor a
	ld [$d202], a
	ld a, c
	ld [$d201], a
	ldh a, [$ff98]
	sub $50
	add $08
	cp $10
	jr nc, jr_006_7299

	ldh a, [$ff99]
	sub $58
	add $08
	cp $10
	jr nc, jr_006_7299

	call Call_3B8D
	call Call_0887
	ld [hl], $48
	ld a, $24
	call Call_2197

jr_006_7299:
	ret


Jump_06_729A::
	call Call_0887
	jr nz, jr_006_72ac

	call Call_0891
	ld [hl], $48
	call Call_3B8D
	ld a, $26
	ldh [$fff2], a
	ret


jr_006_72ac:
	ld a, $02
	ldh [$ffa1], a
	ld a, $1a
	ldh [$fff2], a
	call Call_06_64DF
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_72cf

	ld [hl], $01
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $04
	jr c, jr_006_72cf

	ld a, $04
	ld [$db93], a

jr_006_72cf:
	call Call_088C
	jr nz, jr_006_7305

	ld [hl], $13
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $0a
	jr z, jr_006_7305

	inc [hl]
	ld a, $84
	call Call_3C01
	jr c, jr_006_7305

	ld hl, $c2d0
	add hl, de
	ld [hl], $01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	add $00
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	sub $0e
	ld [hl], a
	ld hl, $c240
	add hl, de
	ld [hl], $e8

jr_006_7305:
	ret


Jump_06_7306::
	call Call_0891
	jp z, Call_06_65E5

	ldh a, [$ffe7]
	and $02
	ld a, $00
	jr z, jr_006_7316

	ld a, $ff

jr_006_7316:
	ld [$d202], a
	call Call_3B87
	ld a, $02
	ldh [$ffa1], a
	ret


	db $68, $00, $6a, $00, $64, $00, $66, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20
	db $66, $20, $64, $20, $6e, $20, $6c, $20

Call_06_7339::
	ld hl, $c380
	add hl, bc
	ldh a, [$fff1]
	add [hl]
	ldh [$fff1], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_7357

	and $80
	ld a, $00
	jr nz, jr_006_7352

	ld a, $03

jr_006_7352:
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_006_7357:
	ld de, $7321
	call Call_3C3B
	call Call_06_64DF
	ld a, [$dba5]
	and a
	jp z, Jump_006_7467

	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_7380

	ld [hl], b
	ld hl, $c310
	add hl, bc
	ld [hl], b

jr_006_7380:
	ldh a, [$fff0]
	rst $00

JumpTable_06_7383::
	dw Jump_06_7391
	dw Jump_06_73D7
	dw Jump_06_7407

	db $02, $06, $08, $06, $fe, $fa, $f8, $fa

Jump_06_7391::
	call Call_06_742A
	xor a
	call Call_3B87
	call Call_0891
	jr nz, jr_006_73d4

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $7389
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
	ld hl, $7389
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_0891
	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	call Call_3B8D

jr_006_73d4:
	jp Jump_006_73fc


Jump_06_73D7::
	call Call_06_742A
	call Call_06_654B
	call Call_3B9E
	ldh a, [$ffe8]
	and a
	jr z, jr_006_73fc

	call Call_0891
	jr nz, jr_006_73f1

	ld [hl], $30
	call Call_3B8D
	ld [hl], b
	ret


jr_006_73f1:
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ld hl, $c310
	add hl, bc
	inc [hl]

Jump_006_73fc:
jr_006_73fc:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_06_7407::
	call Call_06_654B
	call Call_3B9E
	ldh a, [$ffe7]
	and $01
	jr nz, jr_006_7418

	ld hl, $c320
	add hl, bc
	inc [hl]

jr_006_7418:
	ldh a, [$ffe8]
	and a
	jr z, jr_006_7421

	call Call_3B8D
	ld [hl], b

jr_006_7421:
	ldh a, [$ffe7]
	rra
	and $02
	call Call_3B87
	ret


Call_06_742A::
	ld a, [$c137]
	cp $02
	jr nz, jr_006_7466

	call Call_06_659E
	add $18
	cp $30
	jr nc, jr_006_7466

	call Call_06_65AE
	add $18
	cp $30
	jr nc, jr_006_7466

	call Call_3B8D
	ld [hl], $02
	ld a, $10
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
	ld hl, $c320
	add hl, bc
	ld [hl], $0c
	pop af

jr_006_7466:
	ret


Jump_006_7467:
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20

Call_06_7470::
	ld a, [$c166]
	cp $01
	jr nz, jr_006_74a2

	ld a, [$db49]
	and $04
	jr z, jr_006_74a2

	ld a, [$db4a]
	and a
	jr nz, jr_006_74a2

	ldh a, [$ffea]
	cp $01
	jr z, jr_006_74a2

	ld hl, $c480
	add hl, bc
	ld [hl], $1f
	ld hl, $c280
	add hl, bc
	ld [hl], $01
	ld hl, $c340
	add hl, bc
	ld [hl], $04
	ld hl, $fff4
	ld [hl], $13
	ret


jr_006_74a2:
	ld de, $7468
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_06_654B
	ld hl, $c410
	add hl, bc
	ld [hl], $01
	push hl
	call Call_3B9E
	pop hl
	ld [hl], b
	call Call_3BB4
	ldh a, [$fff0]
	and $01
	rst $00

JumpTable_06_74C5::
	dw Jump_06_74D5
	dw Jump_06_751A

	db $08, $08, $f8, $f8, $04, $fc, $fc, $04, $fc, $04, $08, $f8

Jump_06_74D5::
	ld hl, $c3b0
	add hl, bc
	ld [hl], $01
	call Call_0891
	jr nz, jr_006_7519

	call Call_3B8D
	call Call_27ED
	and $07
	add $10
	ld hl, $c320
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	cp $06
	jr c, jr_006_74ff

	ld a, $0a
	call Call_3C25
	jr jr_006_7515

jr_006_74ff:
	ld e, a
	ld d, b
	ld hl, $74c9
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $74cf
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_7515:
	xor a
	call Call_3B87

jr_006_7519:
	ret


Jump_06_751A::
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_006_753e

	xor a
	ld [hl], a
	call Call_3B8D
	call Call_0891
	call Call_27ED
	and $0f
	add $18
	ld [hl], a
	call Call_3DAF

jr_006_753e:
	ret


	db $60, $00, $62, $00, $64, $00, $66, $00

Call_06_7547::
	ld de, $753f
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	xor a
	ldh [$ffe8], a
	call Call_3BEB
	call Call_3BD5
	jr nc, jr_006_756b

	ld a, $01
	ldh [$ffe8], a
	ldh a, [$fff0]
	cp $02
	jr nc, jr_006_756b

	call Call_094A

jr_006_756b:
	call Call_06_654B
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_06_7574::
	dw Jump_06_757A
	dw Jump_06_758E
	dw Jump_06_75C4

Jump_06_757A::
	ldh a, [$ffe8]
	and a
	jr z, jr_006_758d

	call Call_3B8D
	call Call_0891
	ld [hl], $30
	ld hl, $c420
	add hl, bc
	ld [hl], $18

jr_006_758d:
	ret


Jump_06_758E::
	call Call_0891
	jr nz, jr_006_75ac

	call Call_3B8D
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ld hl, $c350
	add hl, bc
	res 7, [hl]
	ld hl, $c430
	add hl, bc
	res 6, [hl]
	call Call_3DAF
	ret


jr_006_75ac:
	ld e, $08
	and $04
	jr z, jr_006_75b4

	ld e, $f8

jr_006_75b4:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	ret


	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

Jump_06_75C4::
	call Call_0891
	jr nz, jr_006_75e9

	call Call_27ED
	and $3f
	add $20
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $75bc
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $75ba
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_75e9:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $50, $00, $50, $20, $20, $e0, $00, $00, $f8, $08, $00, $00, $00, $00, $e0, $20
	db $00, $00, $08, $f8, $30, $20

Call_06_760B::
	ld a, $01
	ldh [$ffbe], a
	ld de, $75f5
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_06_7621::
	dw Jump_06_7629
	dw Jump_06_763A
	dw Jump_06_769D
	dw Jump_06_76BE

Jump_06_7629::
	ldh a, [$ffee]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ldh a, [$ffec]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_06_763A::
	call Call_0891
	jr nz, jr_006_7694

	call Call_3DAF
	call Call_06_65AE
	add $12
	cp $24
	jr nc, jr_006_7662

	call Call_06_659E
	ld d, b
	ld hl, $75f9
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld e, $18
	jr jr_006_7680

jr_006_7662:
	call Call_06_659E
	add $12
	cp $24
	jr nc, jr_006_7694

	call Call_06_65AE
	ld d, b
	ld hl, $7601
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld e, $10

jr_006_7680:
	call Call_0891
	ld [hl], e
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr z, jr_006_7695

	call Call_0891
	ld [hl], b

jr_006_7694:
	ret


jr_006_7695:
	ld a, $0a
	ldh [$fff4], a
	call Call_3B8D
	ret


Jump_06_769D::
	call Call_06_654B
	call Call_0891
	jr nz, jr_006_76b1

jr_006_76a5:
	ld a, $07
	ldh [$fff2], a
	call Call_0891
	ld [hl], $20
	jp Call_3B8D


jr_006_76b1:
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_006_76a5

	ret


Jump_06_76BE::
	call Call_0891
	jr nz, jr_006_7702

	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $75fd
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7605
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_06_654B
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr nz, jr_006_7702

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr nz, jr_006_7702

	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld [hl], $01

jr_006_7702:
	ret


	db $6e, $00, $6e, $20, $66, $20, $64, $20, $64, $00, $66, $00, $62, $00, $62, $20
	db $60, $00, $60, $20, $08, $f8, $00, $00, $00, $00, $f8, $08, $20, $e0, $00, $00
	db $00, $00, $e0, $20

Call_06_7727::
	ld de, $7703
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_06_654B
	call Call_3B9E
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_773F::
	dw Jump_06_7747
	dw Jump_06_775F
	dw Jump_06_778F
	dw Jump_06_77BD

Jump_06_7747::
	ld hl, $c2e0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_775d

	call Call_3B8D
	ld hl, $c2b0
	add hl, bc
	ld [hl], $01
	call Call_088C
	ld [hl], $20

jr_006_775d:
	jr jr_006_777e

Jump_06_775F::
	call Call_088C
	jr nz, jr_006_7779

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c290
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $c2e0
	add hl, bc
	ld [hl], $30
	call Call_06_7839
	ret


jr_006_7779:
	ld a, [hl]
	and $02
	jr nz, jr_006_7787

jr_006_777e:
	ld a, $ff
	call Call_3B87
	call Call_06_7839
	ret


jr_006_7787:
	xor a
	call Call_3B87
	call Call_06_7839
	ret


Jump_06_778F::
	xor a
	call Call_3B87
	call Call_088C
	cp $02
	jr nc, jr_006_77b9

	ld a, [hl]
	cp $01
	jr z, jr_006_77a5

	ld [hl], $18
	call Call_06_7839
	ret


jr_006_77a5:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c290
	add hl, bc
	add [hl]
	ld [hl], a
	cp $01
	jr nz, jr_006_77b9

	call Call_088C
	ld [hl], $20

jr_006_77b9:
	call Call_06_7839
	ret


Jump_06_77BD::
	call Call_3BB4
	call Call_088C
	cp $28
	jr z, jr_006_77ed

	cp $02
	jr nc, jr_006_7831

	ld a, [hl]
	cp $01
	jr z, jr_006_77e1

	ld [hl], $40
	call Call_06_65BE
	ld hl, $c380
	add hl, bc
	ld [hl], a
	inc a
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	ret


jr_006_77e1:
	ld hl, $c2b0
	add hl, bc
	ld [hl], $ff
	ld hl, $c290
	add hl, bc
	dec [hl]
	ret


jr_006_77ed:
	ld a, $22
	call Call_3C01
	jr c, jr_006_7831

	push bc
	ldh a, [$ffd9]
	ld hl, $c380
	add hl, de
	ld [hl], a
	ld c, a
	ld hl, $7717
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $771b
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $771f
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $7723
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [$ffd9]
	ld hl, $c3b0
	add hl, de
	ld [hl], a

jr_006_7831:
	ld hl, $c340
	add hl, bc
	ld a, $02
	ld [hl], a
	ret


Call_06_7839::
	ld hl, $c340
	add hl, bc
	ld [hl], $42
	ret


	db $00, $d8, $60, $00, $00, $e0, $60, $20, $00, $28, $60, $00, $00, $30, $60, $20
	db $d8, $00, $62, $00, $d8, $08, $62, $20, $28, $00, $62, $00, $28, $08, $62, $20
	db $f0, $f0, $6a, $00, $f0, $f8, $6a, $60, $f0, $10, $6a, $40, $f0, $18, $6a, $20
	db $10, $f0, $6a, $40, $10, $f8, $6a, $20, $10, $10, $6a, $00, $10, $18, $6a, $60
	db $00, $e8, $60, $00, $00, $f0, $60, $20, $00, $18, $60, $00, $00, $20, $60, $20
	db $e8, $00, $62, $00, $e8, $08, $62, $20, $18, $00, $62, $00, $18, $08, $62, $20
	db $f0, $f0, $ff, $00, $f0, $f8, $ff, $00, $f0, $10, $ff, $00, $f0, $18, $ff, $00
	db $10, $f0, $ff, $00, $10, $f8, $ff, $00, $10, $10, $ff, $00, $10, $18, $ff, $00
	db $e0, $e0, $68, $00, $e0, $e8, $68, $60, $20, $e0, $68, $40, $20, $e8, $68, $20
	db $e0, $20, $68, $40, $e0, $28, $68, $20, $20, $20, $68, $00, $20, $28, $68, $60
	db $00, $f0, $64, $00, $00, $f8, $64, $20, $f0, $00, $66, $00, $f0, $08, $66, $20
	db $00, $10, $64, $00, $00, $18, $64, $20, $10, $00, $66, $00, $10, $08, $66, $20
	db $e8, $e8, $68, $00, $e8, $f0, $68, $60, $18, $e8, $68, $40, $18, $f0, $68, $20
	db $e8, $18, $68, $40, $e8, $20, $68, $20, $18, $18, $68, $00, $18, $20, $68, $60
	db $00, $f0, $ff, $00, $00, $f8, $ff, $20, $f0, $00, $ff, $00, $f0, $08, $ff, $20
	db $00, $10, $ff, $00, $00, $18, $ff, $20, $10, $00, $ff, $00, $10, $08, $ff, $20

Call_06_7940::
	call Call_06_64DF
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $7840
	add hl, de
	ld c, $10
	call Call_3D26
	ld a, $10
	call Call_3DD0
	ret


	db $5a, $00, $5a, $20, $5a, $10, $5a, $30

Call_06_797B::
	ld de, $7973
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	call Call_06_654B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_006_79a0

	ld a, [hl]
	and $0c
	jr nz, jr_006_79aa

	jr jr_006_79b2

jr_006_79a0:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_006_79b2

jr_006_79aa:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_006_79b2:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $58, $00, $58, $20, $5a, $00, $5a, $20, $10, $f0, $10, $f0, $10, $10, $f0, $f0

Call_06_79CD::
	ld de, $79bd
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_3BB4
	call Call_06_654B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_006_79ee

	call Call_06_7A83

jr_006_79ee:
	ld a, [hl]
	and $0c
	jr z, jr_006_79f6

	call Call_06_7A88

jr_006_79f6:
	ldh a, [$fff0]
	and a
	jr nz, jr_006_7a28

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_006_7a1f

	xor a
	ld [hl], a
	call Call_3DAF
	ld hl, $c290
	add hl, bc
	inc [hl]
	call Call_0891
	call Call_27ED
	and $3f
	add $10
	ld [hl], a
	ld a, $01
	call Call_3B87
	ret


jr_006_7a1f:
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	ret


jr_006_7a28:
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $10
	srl a
	srl a
	srl a
	srl a
	call Call_3B87
	and a
	jr nz, jr_006_7a82

	call Call_0891
	jr nz, jr_006_7a82

	call Call_27ED
	and $07
	add $10
	ld hl, $c320
	add hl, bc
	ld [hl], a
	call Call_06_6584
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $79c5
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $79c9
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $01
	jr z, jr_006_7a79

	ld a, $14
	call Call_3C25

jr_006_7a79:
	ld hl, $c290
	add hl, bc
	xor a
	ld [hl], a
	call Call_3B87

jr_006_7a82:
	ret


Call_06_7A83::
	ld hl, $c240
	jr jr_006_7a8c

Call_06_7A88::
	ld hl, $c240
	add hl, bc

jr_006_7a8c:
	ld a, [hl]
	cpl
	inc a
	sra a
	ld [hl], a
	ret


	db $62, $20, $60, $20, $66, $20, $64, $20, $60, $00, $62, $00, $64, $00, $66, $00
	db $68, $00, $68, $20, $6a, $00, $6a, $20, $6e, $20, $6c, $20, $6c, $00, $6e, $00

Call_06_7AB3::
	ld de, $7a93
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	call Call_06_654B
	call Call_06_5EBC
	ldh a, [$fff0]
	rst $00

JumpTable_06_7AC8::
	dw Jump_06_7ACC
	dw Jump_06_7B4B

Jump_06_7ACC::
	ld a, [$c1a2]
	and a
	jp nz, Jump_006_7b45

	call Call_0891
	jr nz, jr_006_7b1b

	call Call_088C
	jr nz, jr_006_7b2c

	ld a, [$c137]
	cp $03
	jr z, jr_006_7b04

	call Call_27ED
	xor c
	and $07
	add $06
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	call Call_06_7B86
	ldh a, [$ffd8]
	ld hl, $c240
	call Call_06_7B86
	call Call_3BBF
	jr jr_006_7b33

jr_006_7b04:
	call Call_06_659E
	add $24
	cp $48
	jr nc, jr_006_7b33

	call Call_06_65AE
	add $24
	cp $48
	jr nc, jr_006_7b33

	call Call_0891
	ld [hl], $20

jr_006_7b1b:
	call Call_3DAF
	call Call_06_7BBD
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_006_7b44

	call Call_06_7B99

jr_006_7b2c:
	call Call_3DAF
	call Call_06_7BBD
	ret


jr_006_7b33:
	call Call_06_659E
	sla e
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87

jr_006_7b44:
	ret


Jump_006_7b45:
	call Call_3B8D
	ld [hl], $01
	ret


Jump_06_7B4B::
	ld a, [$c1a2]
	and a
	jr z, jr_006_7b81

	ld hl, $c360
	add hl, bc
	ld [hl], $01
	call Call_3BB4
	ld a, $04
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
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add $04
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	ret


jr_006_7b81:
	call Call_3B8D
	ld [hl], b
	ret


Call_06_7B86::
	add hl, bc
	sub [hl]
	jr z, jr_006_7b98

	bit 7, a
	jr z, jr_006_7b94

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	jr jr_006_7b98

jr_006_7b94:
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_006_7b98:
	ret


Call_06_7B99::
	call Call_088C
	ld [hl], $20
	ld hl, $c2b0
	add hl, bc
	ld [hl], $00
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
	sub e
	ld [hl], a
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
	sub e
	ld [hl], a
	ret


Call_06_7BBD::
	ldh a, [$ffe7]
	rra
	rra
	and $01
	jr z, jr_006_7bd4

	call Call_06_659E
	srl e
	jr c, jr_006_7bd0

	ld a, $06
	jr jr_006_7bd6

jr_006_7bd0:
	ld a, $07
	jr jr_006_7bd6

jr_006_7bd4:
	ld a, $ff

jr_006_7bd6:
	call Call_3B87
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	call Call_0891
	cp $01
	jr nz, jr_006_7bea

	ld hl, $c2b0
	add hl, bc
	inc [hl]

jr_006_7bea:
	ret


	db $a6, $10, $8e, $10, $80, $10, $a6, $10, $a9, $10, $2a, $40, $2a, $60, $00, $fc
	db $22, $00, $00, $0c, $22, $20, $00, $fc, $22, $40, $00, $0c, $22, $60, $0f, $0f
	db $10, $11, $11, $11, $10, $0f, $00, $00, $01, $02, $02, $02, $01, $00

Call_06_7C19::
	ld hl, $7c09
	ldh a, [$fff9]
	and a
	jr z, jr_006_7c24

	ld hl, $7c11

jr_006_7c24:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ldh a, [$fff1]
	cp $05
	jr nz, jr_006_7c42

	ld de, $7be1
	call Call_3C3B
	jr jr_006_7c48

jr_006_7c42:
	ld de, $7beb
	call Call_3CD0

jr_006_7c48:
	ldh a, [$ffe7]
	and $08
	ld e, a
	ld d, b
	ld hl, $7bf9
	add hl, de
	ld c, $02
	call Call_3D26
	ld a, $01
	call Call_3DD0
	call Call_3DBA
	call Call_06_64DF
	ldh a, [$fff9]
	and a
	jr nz, jr_006_7c6d

	ldh a, [$ffa2]
	cp $0c
	jr c, jr_006_7ca7

jr_006_7c6d:
	call Call_3BD5
	jr nc, jr_006_7ca7

	call Call_3F88
	call Call_06_65E5
	ld a, $01
	ldh [$fff3], a
	ldh a, [$fff1]
	rst $00

JumpTable_06_7C7F::
	dw Jump_06_7CA2
	dw Jump_06_7CA8
	dw Jump_06_7CB9
	dw Jump_06_7CA2
	dw Jump_06_7C8B
	dw Jump_06_7C98

Jump_06_7C8B::
	ld a, [$db93]
	add $18
	jr nc, jr_006_7c94

	ld a, $ff

jr_006_7c94:
	ld [$db93], a
	ret


Jump_06_7C98::
	ld a, [$db45]
	add $10
	daa
	ld [$db45], a
	ret


Jump_06_7CA2::
	ld a, $0a
	ld [$db90], a

jr_006_7ca7:
	ret


Jump_06_7CA8::
	ld d, $0c
	call Call_3E95
	ld a, $0b
	ldh [$ffa5], a
	ld hl, $db76
	ld de, $db4c
	jr jr_006_7cbf

Jump_06_7CB9::
	ld hl, $db77
	ld de, $db4d

jr_006_7cbf:
	ld a, [de]
	cp [hl]
	jr nc, jr_006_7ccb

	add $10
	daa
	cp [hl]
	jr c, jr_006_7cca

	ld a, [hl]

jr_006_7cca:
	ld [de], a

jr_006_7ccb:
	ret


	db $56, $00, $56, $20

Call_06_7CD0::
	call Call_06_7CDC
	ld de, $7ccc
	call Call_3CD0
	jp Jump_006_7d05


Call_06_7CDC::
	ldh a, [$fff7]
	cp $0a
	ret nz

	ldh a, [$fff6]
	cp $97
	jr z, jr_006_7cea

	cp $98
	ret nz

jr_006_7cea:
	ld a, [$db7f]
	and a
	ret z

	ld a, $ff
	ldh [$fff1], a
	ret


	db $52, $00, $52, $20, $54, $00, $54, $20

Call_06_7CFC::
	call Call_06_7CDC
	ld de, $7cf4
	call Call_3C3B

Jump_006_7d05:
	ld hl, $c1ae
	inc [hl]
	call Call_06_64DF
	call Call_06_6584
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_006_7d27

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_006_7d27:
	ldh a, [$ffeb]
	cp $1b
	jr nz, jr_006_7d8e

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_006_7d8e

	ld [hl], b
	ld hl, $c460
	add hl, bc
	ld a, [hl]
	push hl
	push af
	ld hl, $c3a0
	add hl, bc
	ld [hl], $1c
	call Call_3826
	pop af
	pop hl
	ld [hl], a
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	call Call_3DAF
	ld hl, $c410
	add hl, bc
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ld a, $1c
	call Call_3C01
	jr c, jr_006_7d8e

	ld hl, $c460
	add hl, bc
	ld a, [hl]
	ld hl, $c460
	add hl, de
	ld [hl], a
	ldh a, [$ffd7]
	add $08
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
	ld hl, $c320
	add hl, de
	ld [hl], $20

jr_006_7d8e:
	call Call_06_6501
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7dab

	ldh a, [$fff0]
	and $01
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	dec a
	jr nz, jr_006_7dab

	ld hl, $c300
	add hl, bc
	ld [hl], $08

jr_006_7dab:
	ldh a, [$fff0]
	cp $04
	jr z, jr_006_7dbc

	ld hl, $c480
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7dbc

	call Call_3BB4

jr_006_7dbc:
	ldh a, [$fff0]
	rst $00

JumpTable_06_7DBF::
	dw Jump_06_7DFC
	dw Jump_06_7DC9
	dw Jump_06_7E0F
	dw Jump_06_7E3C
	dw Jump_06_7E49

Jump_06_7DC9::
	call Call_0891
	jr nz, Call_06_7DE6

	ld [hl], $10
	call Call_3DAF
	call Call_27ED
	and $0f
	jr nz, jr_006_7de2

	call Call_0891
	ld [hl], $50
	jp Call_3B8D


jr_006_7de2:
	call Call_3B8D
	ld [hl], b

Call_06_7DE6::
	call Call_06_654B
	call Call_088C
	ret nz

	ld hl, $c410
	add hl, bc
	ld [hl], $02
	call Call_3B9E
	ld hl, $c410
	add hl, bc
	ld [hl], b
	ret


Jump_06_7DFC::
	call Call_06_7DE6
	call Call_0891
	jr nz, jr_006_7e0e

	ld [hl], $07
	call Call_3B8D
	ld a, $04
	call Call_3C25

jr_006_7e0e:
	ret


Jump_06_7E0F::
	call Call_0891
	jr nz, jr_006_7e23

	call Call_3B8D
	ld a, $10
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ret


jr_006_7e23:
	call Call_0891
	ld hl, $c240
	add hl, bc
	and $04
	jr nz, jr_006_7e32

	ld [hl], $08
	jr jr_006_7e34

jr_006_7e32:
	ld [hl], $f8

jr_006_7e34:
	ld hl, $c250
	add hl, bc
	ld [hl], b
	jp Call_06_7DE6


Jump_06_7E3C::
	call Call_06_7DE6
	ldh a, [$ffe8]
	and a
	jr z, jr_006_7e48

	call Call_3B8D
	ld [hl], b

jr_006_7e48:
	ret


Jump_06_7E49::
	call Call_0891
	jr nz, jr_006_7e6a

	ld hl, $c480
	add hl, bc
	ld [hl], $30
	ld a, $10
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ld hl, $c310
	add hl, bc
	inc [hl]
	call Call_3B8D
	ld [hl], $03
	ret


jr_006_7e6a:
	push af
	rra
	and $07
	sub $04
	ld e, a
	ldh a, [$ff98]
	sub e
	ld hl, $c200
	add hl, bc
	ld [hl], a
	pop af
	rra
	rra
	and $07
	sub $04
	ld e, a
	ldh a, [$ff99]
	sub e
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ld a, $01
	ld [$c117], a
	call Call_3B9E
	ldh a, [$ffcc]
	and a
	jr z, jr_006_7eac

	call Call_06_7EA6
	call Call_06_7EA6
	call Call_06_7EA6

Call_06_7EA6::
	call Call_0891
	jr z, jr_006_7eac

	dec [hl]

jr_006_7eac:
	ret


	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

Call_06_7EB5::
	ld de, $7ead
	call Call_3C3B
	call Call_06_64DF
	call Call_06_6501
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_06_7EC7::
	dw Jump_06_7ECB
	dw Jump_06_7EE5

Jump_06_7ECB::
	call Call_0887
	jr nz, jr_006_7edf

	call Call_3BBF
	jr nc, jr_006_7edf

	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld hl, $c3d0
	add hl, bc
	ld [hl], b

jr_006_7edf:
	call Call_3BEB
	jp Jump_006_7f77


Jump_06_7EE5::
	ldh a, [$ffcc]
	and $30
	jr z, jr_006_7f00

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $08
	jr c, jr_006_7f00

	call Call_0887
	ld [hl], $15
	ld hl, $c2d0
	add hl, bc
	ld [hl], b
	ret


jr_006_7f00:
	ld a, $ff
	ldh [$ff9d], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7f2e

	ld hl, $db00
	ld e, b

jr_006_7f10:
	ld a, [hl]
	cp $04
	jr nz, jr_006_7f27

	ld a, [$db44]
	cp $02
	jr nc, jr_006_7f2e

	ld [hl], b
	ld hl, $c2b0
	add hl, bc
	ld a, [$db44]
	ld [hl], a
	jr jr_006_7f2e

jr_006_7f27:
	inc hl
	inc e
	ld a, e
	cp $02
	jr nz, jr_006_7f10

jr_006_7f2e:
	ld a, [$c11c]
	cp $00
	ret nz

	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffef]
	ldh [$ff99], a
	xor a
	ld [$c146], a
	ldh [$ffa2], a
	call Call_06_7FDF
	call Call_06_7FDF
	ret


	db $74, $00, $76, $00, $76, $20, $74, $20, $44, $00, $46, $00, $46, $20, $44, $20
	db $00, $08, $f8, $00, $f8, $08

Call_06_7F5F::
	ld de, $7f49
	ldh a, [$fff7]
	cp $07
	jr nz, jr_006_7f6b

	ld de, $7f51

jr_006_7f6b:
	call Call_3C3B
	call Call_06_64DF
	call Call_08E2
	call Call_3BB4

Jump_006_7f77:
	call Call_06_654B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_006_7f95

	ld a, [hl]
	and $0c
	jr z, jr_006_7f9d

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr jr_006_7f9d

jr_006_7f95:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

jr_006_7f9d:
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_006_7fac

	call Call_27ED
	and $3f
	jr nz, jr_006_7fd9

jr_006_7fac:
	xor a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $7f59
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_006_7fd9

	call Call_27ED
	and $01
	add $04
	ld e, a
	ld d, b
	ld hl, $7f59
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_006_7fd9:
	ld hl, $c290
	add hl, bc
	xor a
	ld [hl], a

Call_06_7FDF::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	inc [hl]
	rra
	rra
	rra
	rra
	and $01
	jp Call_3B87


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff
