; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

Call_15_4000::
	call Call_3DAF
	ld hl, $c330
	add hl, bc
	ld [hl], b
	ld hl, $c260
	add hl, bc
	ld [hl], b
	ld hl, $c270
	add hl, bc
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ld hl, $c290
	add hl, bc
	ld [hl], b
	ld hl, $c2a0
	add hl, bc
	ld [hl], b
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	ld hl, $c2c0
	add hl, bc
	ld [hl], b
	ld hl, $c2d0
	add hl, bc
	ld [hl], b
	ld hl, $c440
	add hl, bc
	ld [hl], b
	ld hl, $c390
	add hl, bc
	ld [hl], b
	ld hl, $c2e0
	add hl, bc
	ld [hl], b
	ld hl, $c2f0
	add hl, bc
	ld [hl], b
	ld hl, $c300
	add hl, bc
	ld [hl], b
	ld hl, $c310
	add hl, bc
	ld [hl], b
	ld hl, $c380
	add hl, bc
	ld [hl], b
	xor a
	call Call_3B87
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	ld hl, $c360
	add hl, bc
	ld [hl], b
	ld hl, $c410
	add hl, bc
	ld [hl], b
	ld hl, $c220
	add hl, bc
	ld [hl], b
	ld hl, $c230
	add hl, bc
	ld [hl], b
	ld hl, $c470
	add hl, bc
	ld [hl], b
	ld hl, $c450
	add hl, bc
	ld [hl], b
	ld hl, $c480
	add hl, bc
	ld [hl], b
	ld hl, $c490
	add hl, bc
	ld [hl], b
	ld hl, $c420
	add hl, bc
	ld [hl], b
	ld hl, $c4e0
	add hl, bc
	ld [hl], b
	ld hl, $c4f0
	add hl, bc
	ld [hl], b
	ld hl, $c5d0
	add hl, bc
	ld [hl], $ff
	ret


Call_15_409A::
	ldh a, [$fff8]
	and $20
	jp nz, Call_15_7C35

	call Call_15_7B20
	ldh a, [$fff0]
	rst $00

JumpTable_15_40A7::
	dw Jump_15_40AD
	dw Jump_15_40BC
	dw Jump_15_40D2

Jump_15_40AD::
	ld a, [$c1cb]
	and a
	jr z, jr_015_40bb

	call Call_3B8D
	call Call_0891
	ld [hl], $20

jr_015_40bb:
	ret


Jump_15_40BC::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, jr_015_40d1

	ld [hl], $30
	ld a, $11
	ldh [$fff4], a
	call Call_3B8D

jr_015_40d1:
	ret


Jump_15_40D2::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_015_40ec

	ld [$c167], a
	ld [$c155], a
	ld a, $39
	call Call_2197
	call Call_15_7CE4
	jp Call_15_7C35


jr_015_40ec:
	ld e, $01
	and $04
	jr z, jr_015_40f4

	ld e, $ff

jr_015_40f4:
	ld a, e
	ld [$c155], a
	ret


	db $f8, $10, $fa, $10

Call_15_40FD::
	ld de, $40f9
	call Call_3C3B
	call Call_15_7B20
	xor a
	ldh [$ffe8], a
	ldh a, [$fff0]
	rst $00

JumpTable_15_410C::
	dw Jump_15_4110
	dw Jump_15_4124

Jump_15_4110::
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	add $10
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_15_4124::
	ldh a, [$ffba]
	cp $02
	jr z, Call_15_416C

	and a
	jr z, jr_015_414a

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_015_4149

	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr z, jr_015_4149

	dec [hl]

jr_015_4149:
	ret


jr_015_414a:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr z, jr_015_4168

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $0d
	jr c, Call_15_416C

	ld [hl], b
	ld hl, $c210
	add hl, bc
	inc [hl]
	jr Call_15_416C

jr_015_4168:
	ld hl, $ffe8
	inc [hl]

Call_15_416C::
	call Call_3DBA
	call Call_15_7BDF
	add $0c
	cp $18
	jr nc, jr_015_41c6

	call Call_15_7BEF
	add $10
	cp $1c
	jr nc, jr_015_41c6

	call Call_0942
	call Call_1495
	call Call_15_7C0E
	ld a, e
	cp $00
	jr nz, jr_015_4196

	ldh a, [$ffee]
	add $0c
	ldh [$ff98], a
	ret


jr_015_4196:
	cp $01
	jr nz, jr_015_41a1

	ldh a, [$ffee]
	add $f4
	ldh [$ff98], a
	ret


jr_015_41a1:
	cp $02
	jr nz, jr_015_41b6

	ldh a, [$ffeb]
	cp $47
	jr nz, jr_015_41af

	ldh a, [$ffe8]
	and a
	ret nz

jr_015_41af:
	ldh a, [$ffec]
	add $f0
	ldh [$ff99], a
	ret


jr_015_41b6:
	ldh a, [$ffeb]
	cp $46
	jr nz, jr_015_41c0

	ldh a, [$ffe8]
	and a
	ret nz

jr_015_41c0:
	ldh a, [$ffec]
	add $0c
	ldh [$ff99], a

jr_015_41c6:
	ret


Call_15_41C7::
	ld de, $40f9
	call Call_3C3B
	call Call_15_7B20
	xor a
	ldh [$ffe8], a
	ldh a, [$fff0]
	rst $00

JumpTable_15_41D6::
	dw Jump_15_41DA
	dw Jump_15_41EE

Jump_15_41DA::
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	sub $10
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_15_41EE::
	ldh a, [$ffba]
	cp $02
	jr z, jr_015_4236

	and a
	jr z, jr_015_4214

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_015_4213

	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr z, jr_015_4213

	inc [hl]

jr_015_4213:
	ret


jr_015_4214:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr z, jr_015_4232

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $0d
	jr c, jr_015_4236

	ld [hl], b
	ld hl, $c210
	add hl, bc
	dec [hl]
	jr jr_015_4236

jr_015_4232:
	ld hl, $ffe8
	inc [hl]

jr_015_4236:
	call Call_15_416C
	ret


Call_15_423A::
	ld de, $40f9
	call Call_3C3B
	call Call_15_7B20
	xor a
	ldh [$ffe8], a
	ldh a, [$fff0]
	rst $00

JumpTable_15_4249::
	dw Jump_15_424D
	dw Jump_15_4261

Jump_15_424D::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	add $10
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_15_4261::
	ldh a, [$ffba]
	cp $02
	jr z, jr_015_42a9

	and a
	jr z, jr_015_4287

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_015_4286

	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr z, jr_015_4286

	dec [hl]

jr_015_4286:
	ret


jr_015_4287:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr z, jr_015_42a5

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $0d
	jr c, jr_015_42a9

	ld [hl], b
	ld hl, $c200
	add hl, bc
	inc [hl]
	jr jr_015_42a9

jr_015_42a5:
	ld hl, $ffe8
	inc [hl]

jr_015_42a9:
	call Call_15_416C
	ret


Call_15_42AD::
	ld de, $40f9
	call Call_3C3B
	call Call_15_7B20
	xor a
	ldh [$ffe8], a
	ldh a, [$fff0]
	rst $00

JumpTable_15_42BC::
	dw Jump_15_42C0
	dw Jump_15_42D4

Jump_15_42C0::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	sub $10
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_15_42D4::
	ldh a, [$ffba]
	cp $02
	jr z, jr_015_431c

	and a
	jr z, jr_015_42fa

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $0a
	jr c, jr_015_42f9

	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr z, jr_015_42f9

	inc [hl]

jr_015_42f9:
	ret


jr_015_42fa:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr z, jr_015_4318

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $0d
	jr c, jr_015_431c

	ld [hl], b
	ld hl, $c200
	add hl, bc
	dec [hl]
	jr jr_015_431c

jr_015_4318:
	ld hl, $ffe8
	inc [hl]

jr_015_431c:
	call Call_15_416C
	ret


	db $58, $00, $58, $20

Call_15_4324::
	ld hl, $c360
	add hl, bc
	ld [hl], $ff
	call Call_0891
	rla
	and $10
	ldh [$ffed], a
	ld de, $4320
	call Call_3C3B
	call Call_15_7B20
	call Call_08E2
	call Call_3BEB
	call Call_15_7A85
	call Call_3B9E
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4364

	ld [hl], b
	ld a, [$d6f8]
	and a
	jr nz, jr_015_4364

	ld a, $01
	ld [$d6f8], a
	call Call_0891
	ld [hl], $18
	ld a, $0e
	ldh [$fff3], a

jr_015_4364:
	ret


Call_15_4365::
	ldh a, [$fff0]
	and a
	jp nz, Jump_015_43ca

	call Call_15_7B20
	call Call_0891
	jr nz, jr_015_43ad

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	ldh a, [$ff99]
	cp $18
	ret c

	ld a, $45
	call Call_3C01
	ret c

	call Call_27ED
	rla
	rla
	rla
	rla
	and $70
	add $18
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c210
	add hl, de
	ld [hl], $10
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c350
	add hl, de
	set 7, [hl]
	ld hl, $c290
	add hl, de
	inc [hl]

jr_015_43ad:
	ret


	db $5c, $00, $5e, $00, $5e, $20, $5c, $20, $5e, $60, $5c, $60, $5c, $40, $5e, $40
	db $0c, $f4, $05, $fb, $08, $0a, $06, $0c, $18, $20, $1c, $28

Jump_015_43ca:
	ld de, $43ae
	call Call_3C3B
	call Call_15_7B20
	call Call_08E2
	call Call_3BB4
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	call Call_3B87
	call Call_15_7B8C
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_4430

	ld [hl], b
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $43be
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $43c2
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $43c6
	add hl, de
	ld a, [hl]
	ld hl, $c320
	add hl, bc
	ld [hl], a
	ld a, $20
	ldh [$fff2], a

jr_015_4430:
	ldh a, [$ffee]
	cp $a8
	jp nc, Call_15_7C35

	ldh a, [$ffec]
	cp $84
	jp nc, Call_15_7C35

	ret


Call_15_443F::
	call Call_15_7B20
	ld e, $0f
	ld d, b

jr_015_4445:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_015_448d

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_448d

	ld hl, $c2e0
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_448d

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_448d

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_448d

	ldh a, [$fff6]
	cp $df
	ld a, $92
	jr z, jr_015_4489

	ld a, [$db79]
	and a
	ret nz

	ld a, $43

jr_015_4489:
	call Call_2197
	ret


jr_015_448d:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_015_4445

	ret


Call_15_4494::
	call Call_15_7B20
	call Call_15_7AD3
	ret nc

	ld a, $12
	call Call_2197
	ret


	db $ff, $00, $ff, $00, $54, $00, $56, $00, $58, $00, $5a, $00, $56, $20, $54, $20
	db $5a, $20, $58, $20, $5c, $00, $5c, $20, $5e, $00, $5e, $00

Call_15_44BD::
	ldh a, [$fff1]
	cp $ff
	jr z, jr_015_44d9

	cp $05
	jr c, jr_015_44d3

	sub $05
	ldh [$fff1], a
	ld de, $44b5
	call Call_3CD0
	jr jr_015_44d9

jr_015_44d3:
	ld de, $44a1
	call Call_3C3B

jr_015_44d9:
	call Call_15_7B20
	call Call_15_7B42
	call Call_15_7B8C
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_15_44E8::
	dw Jump_15_44EE
	dw Jump_15_4502
	dw Jump_15_4557

Jump_15_44EE::
	ld hl, $c240
	add hl, bc
	ld [hl], $08
	call Call_0891
	call Call_27ED
	and $7f
	add $40
	ld [hl], a
	jp Call_3B8D


Jump_15_4502::
	call Call_3BBF
	call Call_0891
	jr nz, jr_015_4533

	ld hl, $c340
	add hl, bc
	ld [hl], $12
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	call Call_3B8D
	ld hl, $c240
	add hl, bc
	sla [hl]

Call_15_451F::
	ld a, $0e
	ldh [$fff2], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $00
	ldh [$ffd8], a
	ld a, $01
	call Call_0953
	ret


jr_015_4533:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_015_4544

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_015_4544:
	ld hl, $c240
	add hl, bc
	ld e, $06
	ld a, [hl]
	and $80
	jr z, jr_015_4551

	ld e, $05

jr_015_4551:
	ld a, e
	call Call_3B87
	ret


	db $c9

Jump_15_4557::
	call Call_3BB4
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_458c

	ld [hl], b
	call Call_15_451F
	call Call_0891
	call Call_27ED
	and $7f
	add $50
	ld [hl], a
	ld hl, $c240
	add hl, bc
	sra [hl]
	ld hl, $c340
	add hl, bc
	ld [hl], $52
	call Call_3B8D
	ld [hl], $01
	ret


jr_015_458c:
	ld e, $01
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_015_4599

	ld e, $03

jr_015_4599:
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_45a3

	inc e

jr_015_45a3:
	ld a, e
	call Call_3B87
	ret


	db $00, $00, $46, $00, $00, $08, $7e, $00, $f0, $00, $46, $00, $f0, $08, $7e, $00
	db $e0, $00, $46, $00, $e0, $08, $7e, $00, $d0, $00, $46, $00, $d0, $08, $7e, $00
	db $c0, $00, $46, $00, $c0, $08, $7e, $00

Jump_015_45d0:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	add $01
	sla a
	ld c, a
	ld hl, $45a8
	call Call_3D26
	ld a, $0a
	call Call_3DD0
	call Call_15_7B20
	ld a, [$db95]
	cp $01
	ret z

	ldh a, [$fff0]
	rst $00

JumpTable_15_45F1::
	dw Jump_15_45FB
	dw Jump_15_4603
	dw Jump_15_462C
	dw Jump_15_4645
	dw Jump_15_4668

Jump_15_45FB::
	call Call_0891
	ld [hl], $c0
	jp Call_3B8D


Jump_15_4603::
	call Call_0891
	cp $40
	jr nz, jr_015_4610

	dec [hl]
	ld a, $d7
	jp Call_2197


jr_015_4610:
	and a
	ret nz

	ld a, $50
	dec a
	ldh [$ffd7], a
	ld a, $30
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $2f
	ldh [$fff2], a
	ld a, $00
	call Call_3B87
	jp Call_3B8D


Jump_15_462C::
	ldh a, [$ff98]
	sub $50
	add $08
	cp $10
	jr nc, jr_015_4641

	ldh a, [$ff99]
	sub $30
	add $08
	cp $10
	jr nc, jr_015_4641

	ret


jr_015_4641:
	call Call_3B8D
	ret


Jump_15_4645::
	ldh a, [$ff98]
	sub $50
	add $08
	cp $10
	jr nc, jr_015_4667

	ldh a, [$ff99]
	sub $30
	add $08
	cp $10
	jr nc, jr_015_4667

	ld a, [$c146]
	and a
	ret nz

	call Call_3B8D
	ld hl, $c2b0
	add hl, bc
	ld [hl], $30

jr_015_4667:
	ret


Jump_15_4668::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$ff99], a
	ld a, $50
	ldh [$ff98], a
	ldh a, [$ffe7]
	and $07
	jr nz, jr_015_468a

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_015_468a

	inc [hl]

jr_015_468a:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_015_46a4

	ld hl, $c2b0
	add hl, bc
	dec [hl]
	ld a, [hl]
	cp $12
	jr nc, jr_015_46a4

	xor a
	ld [$db96], a
	ld a, $01
	ld [$db95], a
	ret


jr_015_46a4:
	ld a, $02
	ldh [$ff9e], a
	ldh a, [$ffe7]
	and $08
	ld [$c120], a
	push bc
	call Call_087C
	pop bc
	call Call_093B
	ld [$c137], a
	ld [$c16a], a
	ret


Call_15_46BE::
	ld a, [$db56]
	cp $80
	jp nz, Call_15_7C35

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_46d8

	ldh a, [$fff1]
	cp $0c
	jr nc, jr_015_46d8

	add $06
	ldh [$fff1], a

jr_015_46d8:
	call Call_15_4ADB
	ldh a, [$ffea]
	cp $01
	jr nz, jr_015_46e9

	ld a, $0c
	call Call_15_48C6
	jp Jump_015_7c3b


jr_015_46e9:
	call Call_380E
	call Call_15_7B20
	call Call_15_7B42
	call Call_3BB4
	ld hl, $c430
	add hl, bc
	set 6, [hl]
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	call Call_15_7B8C
	call Call_3B9E
	call Call_15_7BC5
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
	jr z, jr_015_4722

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_015_4722:
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_15_4728::
	dw Jump_15_473C
	dw Jump_15_4758
	dw Jump_15_478B
	dw Jump_15_484C
	dw Jump_15_4882
	dw Jump_15_48DF
	dw Jump_15_495C
	dw Jump_15_4988
	dw Jump_15_49AD
	dw Jump_15_49D3

Jump_15_473C::
	call Call_0891
	ld [hl], $20
	xor a
	ld [$d228], a
	call Call_3B87
	call Call_3B8D

Call_15_474B::
	call Call_15_7BDF
	ld a, e
	ld [$d227], a
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ret


Jump_15_4758::
	call Call_0891
	jr nz, jr_015_4780

	ld a, $91
	call Call_2185
	ld hl, $c19f
	res 7, [hl]
	call Call_3B8D
	call Call_0887
	ld [hl], $30
	ld hl, $c430
	add hl, bc
	ld [hl], $84
	ld a, $01
	ld [$d228], a
	ld a, $01
	call Call_3B87
	ret


jr_015_4780:
	ret


	db $08, $f8, $fc, $fc, $20, $e0, $00, $00, $d0, $30

Jump_15_478B::
	call Call_088C
	jr z, jr_015_47ef

	cp $0c
	jr nz, jr_015_47dc

	ld a, $0c
	call Call_3C01
	jr c, jr_015_47dc

	ld a, $0a
	ldh [$fff4], a
	push bc
	ldh a, [$ffd9]
	ld c, a
	ld hl, $4781
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4783
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $4785
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $4787
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ldh a, [$ffd9]
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $c380
	add hl, de
	ld [hl], a
	pop bc

jr_015_47dc:
	call Call_088C
	ld e, $00
	cp $0c
	jr c, jr_015_47e7

	ld e, $02

jr_015_47e7:
	ld a, e
	call Call_3B87
	call Call_3DAF
	ret


jr_015_47ef:
	call Call_0887
	jr nz, jr_015_4800

	call Call_0891
	ld [hl], $30
	call Call_3DAF
	call Call_3B8D
	ret


jr_015_4800:
	ldh a, [$ffe8]
	and a
	jr z, jr_015_4823

	ldh a, [$ff98]
	push af
	call Call_15_7BDF
	ld d, b
	ld hl, $4789
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ff98], a
	ld a, $0c
	call Call_3C25
	pop af
	ldh [$ff98], a
	ld hl, $c320
	add hl, bc
	ld [hl], $10

jr_015_4823:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld [$d228], a
	call Call_15_474B
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_4849

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	call Call_088C
	ld [hl], $18

jr_015_4849:
	ret


	db $28, $d8

Jump_15_484C::
	call Call_0891
	jr nz, jr_015_486a

	ld [hl], $22
	call Call_3DAF
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $484a
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ret


jr_015_486a:
	and $07
	jr nz, jr_015_4872

	ld a, $09
	ldh [$fff2], a

jr_015_4872:
	call Call_3DAF
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	ret


Jump_15_4882::
	call Call_0891
	jr nz, jr_015_488e

	call Call_3B8D
	call Call_3B8D
	ret


jr_015_488e:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_015_48be

	xor a
	ld [$c158], a
	ld a, $20
	ld [$c157], a
	ld a, $0b
	ldh [$fff2], a
	ld hl, $c240
	add hl, bc
	sra [hl]
	sra [hl]
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], $28
	call Call_3B8D
	call Call_0891
	ld [hl], $60

jr_015_48be:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	add $04

Call_15_48C6::
	call Call_3B87
	ld a, $ff
	ld [$d228], a
	ret


	db $00, $fe, $fd, $fe, $00, $02, $03, $02, $00, $04, $08, $0c, $10, $0c, $08, $04

Jump_15_48DF::
	ld hl, $c430
	add hl, bc
	res 6, [hl]
	ld hl, $c340
	add hl, bc
	set 7, [hl]
	call Call_0891
	jr nz, jr_015_4900

	ld [hl], $40
	call Call_3B8D
	call Call_3B8D
	ld a, $00
	ld [$d228], a
	jp Call_3B87


jr_015_4900:
	ldh a, [$ffe8]
	and a
	jr z, jr_015_4908

	call Call_3DAF

jr_015_4908:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $0c
	call Call_3B87
	ld a, [$c3c0]
	ld e, a
	ld d, b
	ld hl, $c030
	add hl, de
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	call Call_15_492C
	ld a, $02
	jp Call_3DD0


Call_15_492C::
	call Call_15_4938
	ldh a, [$ffe7]
	rra
	rra
	rra
	add $04
	and $07

Call_15_4938::
	push bc
	push hl
	ld e, a
	ld d, $00
	ld hl, $48cf
	add hl, de
	ld b, [hl]
	ld hl, $48d7
	add hl, de
	ld c, [hl]
	pop hl
	ldh a, [$ffec]
	add b
	add $f6
	ld [hli], a
	ldh a, [$ffee]
	add c
	add $fc
	ld [hli], a
	ld [hl], $24
	inc hl
	ld [hl], $00
	inc hl
	pop bc
	ret


Jump_15_495C::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $fe
	jr nz, jr_015_4970

	call Call_3DAF
	call Call_0891
	ld [hl], $40
	jp Call_3B8D


jr_015_4970:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_497d

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_015_497d:
	dec [hl]
	dec [hl]
	ld a, $00
	ld [$d228], a
	call Call_3B87
	ret


Jump_15_4988::
	call Call_3DAF
	call Call_0891
	jr nz, jr_015_49a1

Jump_015_4990:
	call Call_0887
	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	call Call_3B8D
	ld [hl], $02
	ret


jr_015_49a1:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	ld [$d227], a
	ret


Jump_15_49AD::
	call Call_3B8D
	call Call_0891
	ld [hl], $60
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ldh [$ff9a], a
	ld a, $28
	ld [$c13e], a
	ld a, $40
	ld [$dbc7], a
	ld a, [$db94]
	add $08
	ld [$db94], a
	ld a, $0b
	ldh [$fff2], a
	ret


Jump_15_49D3::
	call Call_3DAF
	call Call_0891
	jr nz, jr_015_49de

	jp Jump_015_4990


jr_015_49de:
	cp $40
	ld a, $00
	jr nc, jr_015_49ed

	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01

jr_015_49ed:
	call Call_3B87
	ld [$d228], a
	call Call_15_474B
	ret


	db $f8, $fc, $54, $20, $f8, $04, $52, $20, $f8, $0c, $50, $20, $f7, $fc, $54, $20
	db $f7, $04, $52, $20, $f7, $0c, $50, $20, $f8, $fc, $50, $00, $f8, $04, $52, $00
	db $f8, $0c, $54, $00, $f7, $fc, $50, $00, $f7, $04, $52, $00, $f7, $0c, $54, $00
	db $00, $fc, $56, $00, $00, $04, $58, $00, $00, $0c, $5a, $00, $00, $fc, $5c, $00
	db $00, $04, $58, $00, $00, $0c, $5e, $00, $00, $fc, $5c, $00, $00, $04, $58, $00
	db $00, $0c, $5a, $00, $00, $fc, $56, $00, $00, $04, $58, $00, $00, $0c, $5e, $00
	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $74, $00, $01, $fc, $70, $00
	db $00, $04, $76, $00, $00, $0c, $78, $00, $00, $fc, $5a, $20, $00, $04, $58, $20
	db $00, $0c, $56, $20, $00, $fc, $5e, $20, $00, $04, $58, $20, $00, $0c, $5c, $20
	db $00, $fc, $5a, $20, $00, $04, $58, $20, $00, $0c, $5c, $20, $00, $fc, $5e, $20
	db $00, $04, $58, $20, $00, $0c, $56, $20, $00, $fc, $74, $20, $00, $04, $72, $20
	db $00, $0c, $70, $20, $00, $fc, $78, $20, $00, $04, $76, $20, $01, $0c, $70, $20
	db $00, $fc, $7a, $00, $00, $04, $7c, $00, $00, $0c, $7e, $00, $00, $fc, $7e, $20
	db $00, $04, $7c, $20, $00, $0c, $7a, $20, $0c, $ff, $26, $00, $0c, $04, $26, $00
	db $0c, $09, $26, $00

Call_15_4ADB::
	ld a, [$d227]
	sla a
	ld e, a
	ld a, [$d228]
	cp $ff
	jr z, jr_015_4afd

	add e
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $49f7
	add hl, de
	ld c, $03
	call Call_3D26

jr_015_4afd:
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $4a27
	add hl, de
	ld c, $03
	call Call_3D26
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4b2a

	ldh a, [$ffef]
	ldh [$ffec], a
	ld hl, $4acf
	ld c, $03
	call Call_3D26
	call Call_3DBA

jr_015_4b2a:
	ret


	db $e8, $fe, $74, $00, $e8, $06, $74, $20, $f4, $01, $76, $00, $f4, $09, $76, $20
	db $00, $00, $76, $00, $00, $08, $76, $20, $e8, $00, $74, $00, $e8, $08, $74, $20
	db $f4, $00, $76, $00, $f4, $08, $76, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $e8, $02, $74, $00, $e8, $0a, $74, $20, $f4, $ff, $76, $00, $f4, $07, $76, $20
	db $00, $00, $76, $00, $00, $08, $76, $20, $e8, $00, $74, $00, $e8, $08, $74, $20
	db $f4, $00, $76, $00, $f4, $08, $76, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $ff, $74, $00, $f4, $07, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $00, $74, $00, $f4, $08, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $01, $74, $00, $f4, $09, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $f4, $00, $74, $00, $f4, $08, $74, $20, $00, $00, $76, $00, $00, $08, $76, $20
	db $00, $ff, $74, $00, $00, $07, $74, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $00, $01, $74, $00, $00, $09, $74, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $fa, $fc, $00, $04, $06, $04, $00, $fc, $fa, $fc

Call_15_4BF5::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_4cee

	call Call_15_4C9A
	call Call_15_7B20
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, jr_015_4c5d

	ld hl, $c360
	add hl, bc
	ld [hl], $02
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $14
	jr nz, jr_015_4c5d

	dec [hl]
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, $e3
	call Call_3C01
	jr c, jr_015_4c5d

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
	ld a, $20
	call Call_3C30
	ldh a, [$ffd8]
	cpl
	inc a
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$ffd7]
	cpl
	inc a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c2e0
	add hl, bc
	ld [hl], $18
	pop bc

jr_015_4c5d:
	call Call_08E2
	call Call_3BB4
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	and $03
	call Call_3B87
	call Call_0891
	jr nz, jr_015_4c93

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $4bed
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4beb
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_015_4c93:
	call Call_15_7B8C
	call Call_3B9E
	ret


Call_15_4C9A::
	ld d, b
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_4cbe

	ldh a, [$fff1]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	and $f0
	add e
	ld e, a
	ld hl, $4b2b
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $04
	jp Call_3DD0


jr_015_4cbe:
	cp $02
	jr z, jr_015_4cd9

	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld hl, $4b8b
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $02
	jp Call_3DD0


jr_015_4cd9:
	ldh a, [$fff1]
	rla
	rla
	rla
	and $f8
	ld e, a
	ld hl, $4bcb
	add hl, de
	ld c, $02
	jp Call_3D26


	db $76, $00, $76, $20

Jump_015_4cee:
	ld de, $4cea
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	call Call_0891
	jr nz, jr_015_4d02

	call Call_3BB4

jr_015_4d02:
	call Call_15_7B8C
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_015_4d18

	ld hl, $c240
	call Call_15_4D24
	ret c

jr_015_4d18:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_015_4d4e

	ld hl, $c250

Call_15_4D24::
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld a, $09
	ldh [$fff2], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $03
	jr c, jr_015_4d4e

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $2f
	ldh [$fff2], a
	call Call_15_7C35
	scf
	ret


jr_015_4d4e:
	and a
	ret


	db $70, $00, $70, $20, $72, $00, $72, $20

Call_15_4D58::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_4dca

	ld de, $4d50
	call Call_3C3B
	call Call_088C
	ld e, $00
	and a
	jr z, jr_015_4d70

	inc e

jr_015_4d70:
	ld a, e
	call Call_3B87
	call Call_15_7B20
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $0f
	jr nz, jr_015_4db1

	call Call_088C
	ld [hl], $08
	ld a, $e2
	call Call_3C01
	ret c

	ld a, $12
	ldh [$fff4], a
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	add $04
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld hl, $c250
	add hl, de
	ld [hl], $10
	ld hl, $c2e0
	add hl, de
	ld [hl], $30

jr_015_4db1:
	ret


	db $78, $00, $78, $20, $76, $00, $76, $20, $74, $00, $74, $20, $7a, $00, $7c, $00
	db $7c, $20, $7a, $20, $fc, $04, $f4, $0c

Jump_015_4dca:
	cp $02
	jp z, Jump_015_4e77

	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ld de, $4db2
	call Call_3C3B
	call Call_15_7B20
	call Call_08E2
	call Call_3BEB
	ld a, [$dbc7]
	push af
	call Call_3BD5
	pop af
	ld e, a
	ld a, [$dbc7]
	cp e
	jr z, jr_015_4e07

	cp $20
	jr c, jr_015_4e07

	ld a, $1f
	ld [$dbc7], a
	ld a, $30
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a

jr_015_4e07:
	call Call_15_7B8F
	ldh a, [$fff0]
	and a
	jr z, jr_015_4e5e

	xor a

jr_015_4e10:
	ldh [$ffe8], a
	ld a, $e2
	call Call_3C01
	jr c, jr_015_4e5b

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $4dc6
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4dc8
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	add $00
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, de
	ld [hl], $0c
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	pop bc
	ldh a, [$ffe8]
	inc a
	cp $02
	jr c, jr_015_4e10

jr_015_4e5b:
	jp Call_15_7C35


jr_015_4e5e:
	call Call_0891
	jp z, Call_15_7C35

	ld hl, $c3b0
	add hl, bc
	cp $10
	jr z, jr_015_4e70

	cp $20
	jr nz, jr_015_4e76

jr_015_4e70:
	ld a, [hl]
	cp $02
	jr z, jr_015_4e76

	inc [hl]

jr_015_4e76:
	ret


Jump_015_4e77:
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ld de, $4dbe
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B8C
	call Call_0891
	jp z, Call_15_7C35

	ret


	db $4a, $00, $4c, $00, $4c, $20, $4a, $20, $4e, $00, $4e, $20, $00, $06, $fa, $fa
	db $06, $48, $00, $48, $60, $48, $40, $48, $20

Call_15_4EAB::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4f03

	ld de, $4ea3
	call Call_3C3B
	call Call_15_7B20
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_15_7B8C
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_4ee0

	call Call_3BB4
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_4ef4

Jump_015_4ee0:
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $07
	ldh [$fff2], a
	ld a, $05
	call Call_0953
	jp Call_15_7C35


jr_015_4ef4:
	ldh a, [$ffee]
	cp $a8
	jp nc, Call_15_7C35

	ldh a, [$ffec]
	cp $84
	jp nc, Call_15_7C35

	ret


jr_015_4f03:
	ld de, $4e92
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	call Call_0891
	jr nz, jr_015_4f17

	call Call_3BB4

jr_015_4f17:
	call Call_088C
	cp $01
	jr nz, jr_015_4f65

	ldh a, [$fff7]
	cp $03
	ret c

	ld a, $1e
	call Call_3C01
	ret c

	ld a, $0a
	ldh [$fff4], a
	ld hl, $c410
	add hl, de
	ld [hl], b
	ld hl, $c340
	add hl, de
	set 6, [hl]
	set 4, [hl]
	ld hl, $c430
	add hl, de
	set 1, [hl]
	set 4, [hl]
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
	ld hl, $c2b0
	add hl, de
	inc [hl]
	push bc
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_015_4f65:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_15_4F6B::
	dw Jump_15_4F6F
	dw Jump_15_5030

Jump_15_4F6F::
	call Call_15_7B8C
	call Call_3B9E
	ldh a, [$ffcc]
	and $30
	jr z, jr_015_4fc3

	call Call_15_7BDF
	add $24
	cp $48
	jr nc, jr_015_4fc3

	call Call_15_7BEF
	add $24
	cp $48
	jr nc, jr_015_4fc3

	call Call_0891
	ld [hl], $08
	call Call_088C
	ld [hl], b
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld hl, $c320
	add hl, bc
	ld [hl], $15
	ld a, $24
	ldh [$fff2], a
	ld a, $12
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
	ld hl, $c3b0
	add hl, bc
	ld [hl], $02
	ret


jr_015_4fc3:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_015_4fdb

	ld a, [hl]
	and $0c
	jr z, jr_015_4fe3

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a
	jr jr_015_4fe3

jr_015_4fdb:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	xor $f0
	ld [hl], a

jr_015_4fe3:
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_4ff2

	call Call_27ED
	and $2f
	jr nz, jr_015_501f

jr_015_4ff2:
	xor a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $4e9e
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_015_501f

	call Call_27ED
	and $01
	add $03
	ld e, a
	ld d, b
	ld hl, $4e9e
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_015_501f:
	ld hl, $c290
	add hl, bc
	xor a
	ld [hl], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_15_5030::
	call Call_15_7B8C
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	push hl
	ld [hl], $01
	call Call_3B9E
	pop hl
	ld [hl], b
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_506d

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ld hl, $c250
	add hl, bc
	ld [hl], $08
	ld hl, $c240
	add hl, bc
	ld [hl], $08
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	call Call_088C
	ld [hl], $10

jr_015_506d:
	ret


	db $ea, $eb, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f1, $f2, $f3

Call_15_507A::
	ld a, [$d219]
	rla
	and $fe
	ld e, a
	ld d, b
	ld hl, $506e
	add hl, de
	ld a, [hli]
	ld [$c195], a
	ld a, [hl]
	ld [$c196], a
	ld a, $01
	ldh [$ff91], a
	ld [$c10e], a
	ret


Call_15_5096::
	ld a, [$c124]
	and a
	jr nz, jr_015_50a9

	ld a, [$c116]
	and a
	jr nz, jr_015_50a9

	inc a
	ld [$c116], a
	call Call_15_507A

jr_015_50a9:
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_015_45d0

	and a
	jp nz, Jump_015_54d0

	ld a, [$d219]
	rst $00

JumpTable_15_50BB::
	dw Jump_15_50C7
	dw Jump_15_51FE
	dw Jump_15_5741
	dw Jump_15_5FE4
	dw Jump_15_63D8
	dw Jump_15_6E4A

Jump_15_50C7::
	ldh a, [$fff0]
	rst $00

JumpTable_15_50CA::
	dw Jump_15_50D8
	dw Jump_15_5135
	dw Jump_15_5150
	dw Jump_15_516C
	dw Jump_15_5189
	dw Jump_15_51AD
	dw Jump_15_51D3

Jump_15_50D8::
	ld a, [$c146]
	and a
	jr nz, jr_015_5134

	ld a, $5d
	ld [$d368], a
	ld hl, $da74
	set 6, [hl]
	ld a, $f5
	call Call_2197
	call Call_0891
	ld [hl], $50
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld e, $80
	ld hl, $d000

jr_015_50fe:
	ld [hli], a
	dec e
	jr nz, jr_015_50fe

	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld e, $80
	ld hl, $d100

jr_015_510e:
	ld [hli], a
	dec e
	jr nz, jr_015_510e

	xor a
	ld [$d21a], a
	ld [$d21b], a
	ld [$d21c], a
	ld [$d21d], a
	ld [$d21e], a
	ld [$d21f], a
	ld [$d220], a
	ld [$d221], a
	ld [$d222], a
	ld [$d223], a
	call Call_3B8D

jr_015_5134:
	ret


Jump_15_5135::
	call Call_15_562D
	call Call_0891
	jr nz, jr_015_5145

	call Call_3B8D

Call_15_5140::
	ld a, $35
	ldh [$fff2], a
	ret


jr_015_5145:
	cp $30
	jr nz, jr_015_514f

	dec [hl]
	ld a, $23
	ld [$d368], a

jr_015_514f:
	ret


Jump_15_5150::
	call Call_15_562D
	call Call_15_7B20
	ld hl, $c250
	add hl, bc
	dec [hl]
	ld a, [hl]
	cp $e8
	jr nz, jr_015_5168

	call Call_0891
	ld [hl], $08
	call Call_3B8D

jr_015_5168:
	call Call_15_7B8F
	ret


Jump_15_516C::
	call Call_15_562D
	call Call_15_7B20
	call Call_15_7B8F
	call Call_0891
	ret nz

	ld hl, $c250
	add hl, bc
	inc [hl]
	jr nz, jr_015_5188

	call Call_0891
	ld [hl], $80
	call Call_3B8D

jr_015_5188:
	ret


Jump_15_5189::
	call Call_15_562D
	call Call_0891
	jr z, jr_015_519f

	and $07
	jr nz, jr_015_519f

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	cp $05
	jr z, jr_015_51a0

	inc [hl]

jr_015_519f:
	ret


jr_015_51a0:
	call Call_0891
	ld [hl], $c0
	call Call_3B8D
	ret


	db $06, $05, $07, $05

Jump_15_51AD::
	call Call_15_569B
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $51a9
	add hl, de
	ld a, [hl]
	call Call_3B87
	call Call_0891
	jr nz, jr_015_51cc

	ld [hl], $2f
	call Call_3B8D

jr_015_51cc:
	ret


	db $08, $00, $01, $02, $03, $04

Jump_15_51D3::
	call Call_15_569B
	call Call_0891
	jr nz, jr_015_51ee

	ld hl, $d219
	inc [hl]
	xor a
	call Call_3B87
	call Call_3B8D
	ld [hl], b
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ret


jr_015_51ee:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $51cd
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_15_51FE::
	call Call_15_5728
	call Call_15_7B20
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_15_520A::
	dw Jump_15_521E
	dw Jump_15_522B
	dw Jump_15_524F
	dw Jump_15_52AE
	dw Jump_15_52CF
	dw Jump_15_52DD
	dw Jump_15_539A
	dw Jump_15_540B
	dw Jump_15_5340
	dw Jump_15_535A

Jump_15_521E::
	call Call_0891
	ld [hl], $80
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	jp Call_3B8D


Jump_15_522B::
	call Call_0891
	jr nz, jr_015_524e

	ldh a, [$ffe7]
	and $07
	jr nz, jr_015_524e

	ld hl, $c3b0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, jr_015_524e

	ld hl, $c320
	add hl, bc
	ld [hl], $28
	ld a, $08
	call Call_3C25
	call Call_3B8D

jr_015_524e:
	ret


Jump_15_524F::
	call Call_15_545F
	call Call_3BB4
	call Call_15_7B8C
	call Call_3B9E
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_529d

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $01
	jr nz, jr_015_5291

	call Call_27ED
	and $01
	jr nz, jr_015_5291

	call Call_0891
	ld [hl], $1f
	call Call_3B8D
	ld [hl], $08
	jr jr_015_529d

jr_015_5291:
	ld a, $20
	ldh [$fff2], a
	call Call_0891
	ld [hl], $30
	call Call_3B8D

jr_015_529d:
	ld e, $03
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $0c
	jr c, jr_015_52a9

	inc e

jr_015_52a9:
	ld a, e
	call Call_3B87
	ret


Jump_15_52AE::
	ld a, $05
	call Call_3B87
	call Call_0891
	jr nz, jr_015_52c8

	ld a, $0c
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	call Call_3B8D
	dec [hl]
	dec [hl]

jr_015_52c8:
	call Call_15_545F
	call Call_3BB4
	ret


Jump_15_52CF::
	call Call_0891
	jr nz, jr_015_52d7

	jp Jump_015_535f


jr_015_52d7:
	ret


Call_15_52D8::
	ld a, $23
	ldh [$fff3], a
	ret


Jump_15_52DD::
	call Call_0891
	jr nz, jr_015_5326

Call_15_52E2::
	ld a, [$d219]
	inc a
	ld [$d219], a
	call Call_15_507A
	xor a
	ld [$d221], a
	ld [$d222], a
	ld [$d223], a
	ld [$d220], a
	ld hl, $c310
	add hl, bc
	ld [hl], b
	ld hl, $c340
	add hl, bc
	ld [hl], $c0
	ld a, $02
	ld [$c197], a
	inc a
	ld [$c10d], a
	ld a, $ff
	call Call_3B87
	call Call_0891
	ld [hl], $40
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	call Call_3B8D
	ld [hl], b
	ld a, $01
	ld [$d21a], a
	ret


jr_015_5326:
	cp $18
	jr nc, jr_015_533b

	cp $17
	jr nz, jr_015_5333

	ld hl, $fff2
	ld [hl], $35

jr_015_5333:
	rra
	rra
	rra
	and $03
	call Call_3B87

jr_015_533b:
	ret


	db $ff, $00, $01, $02

Jump_15_5340::
	call Call_0891
	jr nz, jr_015_534a

	ld [hl], $80
	jp Call_3B8D


jr_015_534a:
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $533c
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_15_535A::
	call Call_0891
	jr nz, jr_015_537f

Jump_015_535f:
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5913
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_3B8D
	ld [hl], $01

jr_015_537f:
	ret


	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $18, $20, $18, $00, $e8, $e0, $e8, $00, $18

Jump_15_539A::
	ld a, $ff
	call Call_3B87
	call Call_0891
	ld [hl], $80
	call Call_3B8D
	ld [hl], $04
	ld a, $21
	ldh [$fff3], a

Call_15_53AD::
	xor a

jr_015_53ae:
	ldh [$ffe8], a
	ld a, $e6
	call Call_3C01
	ret c

	push bc
	ldh a, [$ffe8]
	ld c, a
	ldh a, [$ffd7]
	ld hl, $5380
	add hl, bc
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $5388
	add hl, bc
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $5392
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $5390
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $2f
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c390
	add hl, de
	inc [hl]
	pop bc
	ldh a, [$ffe8]
	inc a
	cp $08
	jr nz, jr_015_53ae

	ret


	db $05, $03, $04, $03

Jump_15_540B::
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_5423

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_015_5423:
	call Call_0891
	jr z, jr_015_5438

	rra
	nop
	nop
	nop
	and $03
	ld e, a
	ld d, b
	ld hl, $5407
	add hl, de
	ld a, [hl]
	jp Call_3B87


jr_015_5438:
	ld a, [$d220]
	inc a
	ld [$d220], a
	cp $03
	jr nc, jr_015_5449

	call Call_3B8D
	ld [hl], $02
	ret


jr_015_5449:
	ld a, $06
	call Call_3B87
	call Call_0891
	ld [hl], $80
	call Call_3B8D
	ld [hl], $05

Call_15_5458::
	ld a, $37
	ldh [$fff4], a
	jp Call_15_53AD


Call_15_545F::
	ld e, $0f
	ld d, b

jr_015_5462:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_015_54b1

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_54b1

	ld hl, $c2e0
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_54b1

	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_54b1

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_54b1

	ld hl, $c420
	add hl, bc
	ld [hl], $14
	ld a, $07
	ldh [$fff3], a
	ld a, $37
	ldh [$fff2], a
	call Call_3B8D
	ld [hl], $07
	call Call_0891
	ld [hl], $80
	pop af
	ret


jr_015_54b1:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_015_5462

	ret


	db $4e, $00, $4e, $20, $4c, $00, $4c, $20, $4a, $00, $4a, $20, $02, $02, $02, $01
	db $01, $00, $0f, $07, $03, $01, $00, $00

Jump_015_54d0:
	ld de, $54b8
	call Call_3C3B
	call Call_15_7B20
	call Call_0891
	jp z, Call_15_7C35

	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $54c4
	add hl, de
	push de
	ld a, [hl]
	call Call_3B87
	pop de
	ld hl, $54ca
	add hl, de
	ldh a, [$ffe7]
	and [hl]
	jr nz, jr_015_54fc

	call Call_15_7B8C

jr_015_54fc:
	ret


	db $00, $00, $4c, $00, $00, $08, $4c, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
	db $f8, $f8, $7a, $00, $f8, $00, $7c, $00, $f8, $08, $7c, $20, $f8, $10, $7a, $20
	db $08, $f8, $7a, $40, $08, $00, $7c, $40, $08, $08, $7c, $60, $08, $10, $7a, $60
	db $f8, $f8, $76, $00, $f8, $00, $78, $00, $f8, $08, $78, $20, $f8, $10, $76, $20
	db $08, $f8, $76, $40, $08, $00, $78, $40, $08, $08, $78, $60, $08, $10, $76, $60
	db $f8, $f8, $72, $00, $f8, $00, $74, $00, $f8, $08, $74, $20, $f8, $10, $72, $20
	db $08, $f8, $72, $40, $08, $00, $74, $40, $08, $08, $74, $60, $08, $10, $72, $60
	db $f8, $f8, $66, $00, $f8, $00, $68, $00, $f8, $08, $68, $20, $f8, $10, $66, $20
	db $08, $f8, $66, $40, $08, $00, $6a, $00, $08, $08, $6a, $20, $08, $10, $66, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $64, $00, $08, $08, $64, $20, $08, $10, $60, $60
	db $f8, $f8, $6c, $00, $f8, $00, $6e, $00, $f8, $08, $6e, $20, $f8, $10, $6c, $20
	db $08, $f8, $6c, $40, $08, $00, $70, $00, $08, $08, $70, $20, $08, $10, $6c, $60
	db $00, $00, $4a, $00, $00, $08, $4a, $20, $00, $08, $ff, $20, $00, $10, $ff, $20
	db $00, $f8, $ff, $40, $00, $00, $ff, $40, $00, $08, $ff, $60, $00, $10, $ff, $60
	db $4c, $00, $4c, $20, $48, $00, $48, $20, $28, $23, $1e, $19, $14, $0f, $0a, $05

Call_15_562D::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	xor a

jr_015_5635:
	ldh [$ffe8], a
	ld e, a
	ld d, b
	ld hl, $5625
	add hl, de
	ldh a, [$ffe9]
	sub [hl]
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
	ld de, $5621
	ldh a, [$ffe8]
	cp $00
	jr z, jr_015_5667

	ld hl, $c210
	add hl, bc
	ldh a, [$ffec]
	cp [hl]
	jr z, jr_015_5672

	ld de, $561d

jr_015_5667:
	xor a
	ldh [$fff1], a
	call Call_3C3B
	ld a, $02
	call Call_3DD0

jr_015_5672:
	ldh a, [$ffe8]
	inc a
	cp $08
	jr nz, jr_015_5635

	call Call_3DBA
	call Call_15_569B
	call Call_15_7B20
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $7f
	ld e, a
	ld d, b
	ldh a, [$ffec]
	ld hl, $d100
	add hl, de
	ld [hl], a
	ldh a, [$ffee]
	ld hl, $d000
	add hl, de
	ld [hl], a
	ret


Call_15_569B::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $54fd
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $00, $00, $4a, $00, $00, $08, $4a, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4c, $00, $00, $08, $4c, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $00, $00, $ff, $00, $00, $00, $ff, $20
	db $f0, $00, $5c, $00, $f0, $08, $5c, $20, $00, $00, $5e, $00, $00, $08, $5e, $20
	db $f0, $00, $44, $00, $f0, $08, $44, $20, $00, $00, $44, $40, $00, $08, $44, $60
	db $00, $fc, $40, $00, $00, $04, $42, $00, $00, $0c, $40, $20, $00, $00, $ff, $00
	db $00, $00, $48, $00, $00, $08, $48, $20, $00, $00, $ff, $00, $00, $00, $ff, $20

Call_15_5728::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $56b8
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


Jump_15_5741::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_015_5de0

	and a
	jp nz, Jump_015_5df8

	ld a, c
	ld [$d201], a
	ld a, [$d21a]
	and a
	jr nz, jr_015_575c

	call Call_15_5A6E

jr_015_575c:
	call Call_15_7B20
	call Call_15_7B42
	ldh a, [$fff0]
	rst $00

JumpTable_15_5765::
	dw Jump_15_5779
	dw Jump_15_57CE
	dw Jump_15_580B
	dw Jump_15_5855
	dw Jump_15_58EE
	dw Jump_15_5928
	dw Jump_15_5965
	dw Jump_15_59BC
	dw Jump_15_5A0A
	dw Jump_15_5A25

Jump_15_5779::
	xor a
	call Call_3B87
	call Call_15_5728
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $50
	ldh [$ff98], a
	ld a, $30
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_57b5

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_57b5

	call Call_0891
	ld [hl], $50
	call Call_3B8D
	ld [hl], $01

jr_015_57b5:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_15_7B8C
	ret


	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_57CE::
	call Call_0891
	jr z, jr_015_57e4

	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $57bf
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	jp Call_15_5728


jr_015_57e4:
	xor a
	ld [$d21a], a
	call Call_15_5819
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	call Call_0891
	ld [hl], $40
	call Call_3B8D
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	inc [hl]
	call Call_15_52D8
	ret


	db $0f, $0a, $05, $00

Jump_15_580B::
	call Call_0891
	jr nz, Call_15_5819

	ld a, $22
	ldh [$fff3], a
	ld [hl], $c0
	jp Call_3B8D


Call_15_5819::
	call Call_15_7C0E
	ld a, e
	ld [$d21e], a
	ld d, b
	ld hl, $5807
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a

Call_15_582B::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	add [hl]
	call Call_3B87
	ret


	db $00, $01, $02, $03, $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01
	db $00, $00, $00, $00, $18, $e8, $00, $00, $00, $00, $f0, $00

Jump_15_5855::
	call Call_0891
	jr nz, jr_015_58c1

	ld [$d21d], a
	ld [hl], $50
	ld a, $e6
	call Call_3C01
	ld hl, $c440
	add hl, de
	inc [hl]
	push bc
	ld a, [$d21e]
	ld c, a
	ld hl, $584d
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $5851
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $42
	ld hl, $c350
	add hl, de
	ld [hl], d
	ld a, $38
	ldh [$fff4], a
	ld a, [$d220]
	cp $02
	jr c, jr_015_58b6

	ldh a, [$ff98]
	ld hl, $ffe7
	add [hl]
	and $01
	jr nz, jr_015_58b6

	ld hl, $c290
	add hl, de
	ld [hl], $03
	ld hl, $c2e0
	add hl, de
	ld [hl], $1c
	ld a, $39
	ldh [$fff4], a

jr_015_58b6:
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc
	jp Call_3B8D


jr_015_58c1:
	rra
	rra
	rra
	and $03
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_0891
	rra
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $583d
	add hl, de
	ld a, [hl]
	ld [$d21d], a
	call Call_0891
	cp $40
	jp c, Call_15_582B

	and $1f
	jp z, Call_15_5819

	jp Call_15_582B


Jump_15_58EE::
	call Call_0891
	jr nz, jr_015_5909

	ld [hl], $27
	ld a, $35
	ldh [$fff2], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	ld a, $01
	ld [$d21a], a
	jp Call_3B8D


jr_015_5909:
	ld hl, $c2b0
	add hl, bc
	ld [hl], $04
	call Call_15_582B
	ret


	db $50, $28, $78, $18, $88, $38, $68, $50, $30, $30, $30, $50, $50, $70, $70, $74
	db $00, $01, $02, $03, $04

Jump_15_5928::
	call Call_0891
	jr nz, jr_015_594c

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5913
	add hl, de
	ld a, [hl]
	ld [$d21b], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld [$d21c], a
	call Call_0891
	ld [hl], $1f
	jp Call_3B8D


jr_015_594c:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $5923
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	jp Call_15_5728


	db $18, $14, $10, $0c, $08, $05, $02, $01

Jump_15_5965::
	xor a
	ldh [$fff1], a
	call Call_15_5728
	ldh a, [$ff99]
	push af
	ldh a, [$ff98]
	push af
	ld a, [$d21b]
	ldh [$ff98], a
	ld a, [$d21c]
	ldh [$ff99], a
	call Call_0891
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $595d
	add hl, de
	ld a, [hl]
	call Call_3C25
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_59ae

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_59ae

	call Call_0891
	ld [hl], $50
	call Call_3B8D
	ld [hl], $01

jr_015_59ae:
	pop af
	ldh [$ff98], a
	pop af
	ldh [$ff99], a
	call Call_15_7B8C
	ret


	db $00, $0a, $0f, $05

Jump_15_59BC::
	call Call_0891
	jr nz, jr_015_59d7

	call Call_15_5458
	ld a, $01
	ld [$d21a], a
	ld a, $06
	call Call_3B87
	call Call_0891
	ld [hl], $50
	call Call_3B8D
	ret


jr_015_59d7:
	ld a, [$d221]
	cp $80
	jr nc, jr_015_59e2

	inc a
	ld [$d221], a

jr_015_59e2:
	ld a, [$d221]
	ld hl, $d222
	add [hl]
	ld [hl], a
	jr nc, jr_015_59f0

	ld hl, $d223
	inc [hl]

jr_015_59f0:
	ld a, [$d223]
	and $03
	ld e, a
	ld d, b
	ld hl, $59b8
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	call Call_15_582B
	ret


Jump_15_5A0A::
	call Call_0891
	jr nz, jr_015_5a15

	call Call_15_5140
	jp Call_3B8D


jr_015_5a15:
	cp $18
	jr nc, jr_015_5a21

	rra
	rra
	rra
	and $03
	call Call_3B87

jr_015_5a21:
	call Call_15_5728
	ret


Jump_15_5A25::
	call Call_15_5728
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $50
	ldh [$ff98], a
	ld a, $30
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_5a64

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_5a64

	call Call_15_52E2
	call Call_0891
	ld [hl], $31
	ld hl, $c360
	add hl, bc
	ld [hl], $ff
	call Call_15_5FA7

jr_015_5a64:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_15_7B8C
	ret


Call_15_5A6E::
	call Call_15_5D97
	call Call_15_5B34
	call Call_15_5B13
	call Call_15_5D51
	ret


	db $6a, $00, $6c, $00, $6c, $20, $6a, $20, $6a, $00, $ff, $ff, $6a, $20, $ff, $ff
	db $00, $00, $6a, $00, $08, $08, $7a, $00, $08, $00, $7a, $20, $00, $08, $6a, $20
	db $00, $00, $00, $00, $02, $00, $00, $00, $00, $02, $04, $04, $04, $04, $04, $05
	db $05, $05, $05, $05, $f0, $f3, $f3, $f0, $f5, $f0, $f3, $f3, $f0, $f5, $f1, $f0
	db $f1, $f2, $f0, $0f, $10, $0f, $0e, $10, $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1
	db $f1, $fd, $f4, $f6, $f7, $f6, $f8, $f4, $f6, $f7, $f6, $f8, $01, $01, $01, $01
	db $03, $01, $01, $01, $01, $03, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03
	db $10, $0d, $0d, $10, $13, $10, $0d, $0d, $10, $13, $f5, $f6, $f5, $f4, $f3, $13
	db $12, $13, $14, $15, $ed, $ed, $f1, $f1, $fd, $ed, $ed, $f1, $f1, $fd, $eb, $ec
	db $ed, $ec, $f2, $eb, $ec, $ed, $ec, $f2

Call_15_5B13::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5aeb
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $5aff
	add hl, de
	ldh a, [$ffec]
	add $08
	add [hl]
	ldh [$ffec], a
	ld hl, $5ad7
	add hl, de
	jr jr_015_5b53

Call_15_5B34::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5aaf
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $5ac3
	add hl, de
	ldh a, [$ffec]
	add $08
	add [hl]
	ldh [$ffec], a
	ld hl, $5a9b
	add hl, de

jr_015_5b53:
	ld a, [hl]
	cp $04
	jr nc, jr_015_5b62

	ldh [$fff1], a
	ld de, $5a7b
	call Call_3C3B
	jr jr_015_5b74

jr_015_5b62:
	sub $04
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $5a8b
	add hl, de
	ld c, $02
	call Call_3D26

jr_015_5b74:
	ld a, $02
	call Call_3DD0
	call Call_3DBA
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $05, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $05, $10, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $05, $f9, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $05, $0f, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $06, $f9, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $06, $0f, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $06, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $06, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $62, $00, $fa, $08, $62, $20, $fa, $10, $60, $20
	db $08, $f8, $6e, $00, $08, $00, $64, $00, $08, $08, $64, $20, $08, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $05, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $05, $10, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $05, $f9, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $05, $0f, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $06, $f9, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $06, $0f, $6e, $20
	db $fa, $f8, $60, $00, $fa, $00, $66, $00, $fa, $08, $66, $20, $fa, $10, $60, $20
	db $06, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $06, $10, $6e, $20
	db $f8, $f8, $60, $00, $f8, $00, $66, $00, $f8, $08, $66, $20, $f8, $10, $60, $20
	db $04, $f8, $6e, $00, $08, $00, $68, $00, $08, $08, $68, $20, $04, $10, $6e, $20
	db $f8, $fc, $72, $00, $f8, $04, $74, $00, $08, $00, $76, $00, $08, $08, $78, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fa, $fb, $72, $00, $fa, $03, $74, $00, $08, $00, $76, $00, $08, $08, $78, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $04, $74, $20, $f8, $0c, $72, $20, $08, $00, $78, $20, $08, $08, $76, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fa, $05, $74, $20, $fa, $0d, $72, $20, $08, $00, $78, $20, $08, $08, $76, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0a, $0a, $0a, $0b, $0c
	db $0c, $0c, $0c, $0d

Call_15_5D51::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld d, b
	ld hl, $5d3d
	add hl, de
	ld a, [hl]
	ld d, $00
	ld e, a
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
	ld hl, $5b7d
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $1e, $00, $1e, $60, $7c, $00, $7c, $20, $7e, $00, $7e, $20, $14, $ec, $00, $00
	db $00, $00, $f0, $04

Call_15_5D97::
	ldh a, [$ffed]
	push af
	call Call_15_5DA1
	pop af
	ldh [$ffed], a
	ret


Call_15_5DA1::
	ld a, [$d21d]
	and a
	ret z

	dec a
	ldh [$fff1], a
	ldh a, [$ffe7]
	rla
	rla
	rla
	and $50
	ldh [$ffed], a
	ld a, [$d21e]
	ld e, a
	ld d, b
	ld hl, $5d8f
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $5d93
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld de, $5d83
	call Call_3C3B
	ld a, $02
	call Call_3DD0
	call Call_3DBA
	ret


	db $46, $00, $46, $60, $70, $00, $ff, $ff

Jump_015_5de0:
	ld de, $5dd8
	ret


	db $7e, $00, $7e, $20, $7c, $00, $7c, $20, $1e, $00, $1e, $60, $58, $00, $58, $20
	db $5a, $00, $5a, $20

Jump_015_5df8:
	ldh a, [$ffe7]
	rla
	rla
	rla
	and $50
	ldh [$ffed], a
	ld de, $5de4
	call Call_3C3B
	call Call_15_7B20
	call Call_08E2
	ldh a, [$fff0]
	cp $04
	jr nz, jr_015_5e30

	call Call_088C
	jp z, Call_15_7C35

	xor c
	bit 0, a
	ld e, $ff
	jr z, jr_015_5e2b

	call Call_088C
	ld e, $01
	cp $08
	jr nc, jr_015_5e2b

	ld e, $02

jr_015_5e2b:
	ld a, e
	call Call_3B87
	ret


jr_015_5e30:
	call Call_15_7B8C
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_15_5E39::
	dw Jump_15_5E41
	dw Jump_15_5E91
	dw Jump_15_5EB9
	dw Jump_15_5F2F

Jump_15_5E41::
	call Call_3BB4

Call_15_5E44::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $03
	jr nz, jr_015_5e85

	ld a, $e6
	call Call_3C01
	ret c

	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c350
	add hl, de
	ld [hl], d
	ld hl, $c440
	add hl, de
	inc [hl]
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2f0
	add hl, de
	ld [hl], $0f
	ld hl, $c3b0
	add hl, de
	ld [hl], $01
	ld hl, $c290
	add hl, de
	ld [hl], $04

jr_015_5e85:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_5e90

	jp Call_15_7C35


jr_015_5e90:
	ret


Jump_15_5E91::
	ld a, $08
	ldh [$fff4], a
	ld a, $18
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	cpl
	inc a
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ldh a, [$ffd8]
	ldh [$ff9a], a
	cpl
	inc a
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld a, $10
	ld [$c13e], a
	call Call_3B8D
	ret


Jump_15_5EB9::
	call Call_15_5E44
	ld a, [$d21a]
	and a
	ret nz

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_5f26

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_015_5f26

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, $c3f0
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	sla a
	ld hl, $c400
	add hl, de
	ld [hl], a
	ld hl, $c410
	add hl, de
	ld [hl], $12
	call Call_15_7C35
	ld a, [$d220]
	inc a
	ld [$d220], a
	cp $04
	jr c, jr_015_5f1c

	ld hl, $c290
	add hl, de
	ld [hl], $07
	ld hl, $c2e0
	add hl, de
	ld [hl], $c0
	ld a, $36
	ldh [$fff2], a

jr_015_5f1c:
	ld hl, $c420
	add hl, de
	ld [hl], $14
	ld a, $07
	ldh [$fff3], a

jr_015_5f26:
	ret


	db $20, $20, $e0, $e0, $20, $e0, $20, $e0

Jump_15_5F2F::
	call Call_3BBF
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $03
	call Call_3B87
	call Call_0891
	jr z, jr_015_5f4c

	and $01
	jr nz, jr_015_5f4c

	ld a, $18
	call Call_3C25

jr_015_5f4c:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_5fa6

	ld a, $36
	ldh [$fff4], a
	xor a

jr_015_5f59:
	ldh [$ffe8], a
	ld a, $7d
	call Call_3C01
	jr c, jr_015_5fa3

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
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffe8]
	ld c, a
	ld hl, $5f27
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $5f2b
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [$ffe8]
	inc a
	cp $04
	jr nz, jr_015_5f59

jr_015_5fa3:
	jp Call_15_7C35


jr_015_5fa6:
	ret


Call_15_5FA7::
	ld e, $80
	ld hl, $d100

jr_015_5fac:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_015_5fac

	ret


	db $03, $03, $05, $05, $00, $00, $04, $04, $02, $02, $06, $06, $01, $01, $07, $07
	db $00, $06, $0c, $0e, $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa
	db $00, $06, $0c, $0e, $06, $07, $00, $01, $02, $03, $04, $05

Call_15_5FDE::
	call Call_15_7B20
	jp Call_3BB4


Jump_15_5FE4::
	ldh a, [$fff0]
	rst $00

JumpTable_15_5FE7::
	dw Jump_15_6057
	dw Jump_15_60E3
	dw Jump_15_60D0
	dw Jump_15_609A

	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $f8, $78, $00, $f8, $00, $7a, $00
	db $f8, $08, $7a, $20, $00, $10, $78, $20, $08, $00, $7c, $00, $08, $08, $7c, $20
	db $03, $03, $02, $01, $00, $00, $00, $00

Jump_15_6057::
	xor a
	ldh [$fff1], a
	call Call_0891
	jr nz, jr_015_6062

	jp Call_3B8D


jr_015_6062:
	cp $20
	jr nz, jr_015_606c

	dec [hl]
	call Call_15_52D8
	ld a, $20

jr_015_606c:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $604f

jr_015_6076:
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	and $f0
	add e
	ld e, a
	ld hl, $5fef
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ret


	db $00, $00, $01, $01, $02, $02, $03, $03

Jump_15_609A::
	xor a
	ldh [$fff1], a
	call Call_0891
	jr nz, jr_015_60c4

	call Call_15_52E2
	call Call_15_5140
	ld hl, $c360
	add hl, bc
	ld [hl], $ff
	ld hl, $c340
	add hl, bc
	ld [hl], $40
	ld hl, $c350
	add hl, bc
	ld [hl], $0a
	ld hl, $c430
	add hl, bc
	ld [hl], $90
	call Call_3B65
	ret


jr_015_60c4:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6092
	jr jr_015_6076

Jump_15_60D0::
	ld hl, $c480
	add hl, bc
	ld a, [hl]
	and a
	jr nz, Jump_15_60E3

	call Call_0891
	ld [hl], $1f
	call Call_15_5458
	jp Call_3B8D


Jump_15_60E3::
	call Call_15_5FDE
	call Call_15_6255
	call Call_08E2
	call Call_3DBA
	call Call_15_7B20
	xor a
	ld [$d3d6], a
	ld e, $0c
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_610a

	call Call_15_6118
	ld a, $01
	ld [$d3d6], a
	ld e, $0c

jr_015_610a:
	ld hl, $d202
	ld a, [hl]
	inc a
	ld [hl], a
	cp e
	jr c, Call_15_6118

	ld [hl], b
	ld a, $38
	ldh [$fff2], a

Call_15_6118::
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
	call Call_15_6341
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, $5fd6
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6c, $00, $08, $00, $6e, $00, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $6c, $40, $f8, $00, $6e, $40, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6e, $60, $f8, $10, $6c, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6e, $20, $08, $10, $6c, $20
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20

Call_15_6255::
	ld hl, $c340
	add hl, bc
	ld [hl], $48
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6145
	add hl, de
	ld c, $08
	call Call_3D26
	ld hl, $c340
	add hl, bc
	ld [hl], $42
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
	ld de, $6245
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
	ld de, $6245
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
	ld a, $01
	ldh [$fff1], a
	ld de, $6245
	call Call_3C3B
	ldh a, [$ffd7]
	sub $2e
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
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	ldh [$fff1], a
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ld hl, $ffed
	xor [hl]
	ld [hl], a
	ld de, $6245
	call Call_3C3B
	ldh a, [$fff0]
	cp $02
	jr nc, jr_015_6340

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_6340

	ld hl, $c430
	add hl, bc
	ld [hl], $90
	call Call_3BEB
	ld hl, $c430
	add hl, bc
	ld [hl], $d0
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nc, jr_015_6340

	call Call_3B8D
	ld hl, $c480
	add hl, bc
	ld [hl], $50

jr_015_6340:
	ret


Call_15_6341::
	ldh a, [$fff0]
	cp $02
	jr nc, jr_015_6352

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_6352

	call Call_15_7B8C

jr_015_6352:
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6389

	ld e, $08
	bit 0, a
	jr nz, jr_015_6371

	ld e, $00
	bit 1, a
	jr nz, jr_015_6371

	ld e, $04
	bit 2, a
	jr nz, jr_015_6371

	ld e, $0c

jr_015_6371:
	ld hl, $c2b0
	add hl, bc
	ld [hl], e
	call Call_27ED
	rra
	jr c, jr_015_6384

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_015_6384:
	call Call_0891
	ld [hl], $10

jr_015_6389:
	call Call_088C
	jr nz, jr_015_63bf

	ld [hl], $06
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
	ld hl, $5fb2
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $5fc2
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $5fc6
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_015_63bf:
	call Call_0891
	jr nz, jr_015_63d7

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

jr_015_63d7:
	ret


Jump_15_63D8::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_015_6d5d

	cp $02
	jp z, Jump_015_6d8c

	and a
	jp nz, Jump_015_6c7e

	ldh a, [$fff0]
	cp $02
	jr c, jr_015_6435

	cp $0b
	jr z, jr_015_63f9

	cp $0c
	jr nz, jr_015_6402

jr_015_63f9:
	ld a, $06
	ldh [$fff1], a
	call Call_15_5728
	jr jr_015_6405

jr_015_6402:
	call Call_15_6943

jr_015_6405:
	call Call_15_7B20
	call Call_08E2
	ldh a, [$fff0]
	cp $09
	jr nc, jr_015_6435

	call Call_3BB4
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $e8
	jr nc, jr_015_6435

	call Call_3B8D
	ld [hl], $09
	ld a, $09
	ldh [$fff0], a
	ld a, $10
	ldh [$fff3], a
	call Call_0891
	ld [hl], $80
	ld hl, $c420
	add hl, bc
	ld [hl], $80

jr_015_6435:
	ldh a, [$fff0]
	rst $00

JumpTable_15_6438::
	dw Jump_15_64CC
	dw Jump_15_651F
	dw Jump_15_6565
	dw Jump_15_65B8
	dw Jump_15_662A
	dw Jump_15_66DE
	dw Jump_15_6766
	dw Jump_15_67A3
	dw Jump_15_67F7
	dw Jump_15_67F8
	dw Jump_15_680F
	dw Jump_15_6828
	dw Jump_15_68AD
	dw Jump_15_68FF

	db $00, $00, $4a, $00, $00, $08, $4a, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $4c, $00, $00, $08, $4c, $20
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $4e, $00, $00, $08, $4e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $00, $5c, $00, $f0, $08, $5c, $20
	db $00, $00, $5e, $00, $00, $08, $5e, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $fc, $6a, $00, $00, $04, $6c, $20, $00, $0c, $6a, $20, $f3, $fc, $50, $00
	db $f3, $04, $52, $00, $f3, $0c, $6e, $00

Jump_15_64CC::
	xor a
	ldh [$fff1], a
	call Call_3B87
	call Call_15_5728
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $50
	ldh [$ff98], a
	ld a, $30
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6508

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6508

	call Call_0891
	ld [hl], $60
	call Call_3B8D

jr_015_6508:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_15_7B8C
	ret


	db $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_651F::
	call Call_0891
	jr nz, jr_015_653f

	ld [$d224], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $08
	ld [hl], a
	call Call_0891
	ld [hl], $08
	ld a, $04
	call Call_3B87
	call Call_15_52D8
	jp Call_3B8D


jr_015_653f:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $6512
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	and $f0
	add e
	ld e, a
	ld hl, $6454
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ret


Jump_15_6565::
	call Call_0891
	jr nz, jr_015_6577

	ld [hl], $7f
	jp Call_3B8D


Call_15_656F::
	call Call_15_7BDF
	ld a, e
	ld [$d21e], a
	ret


jr_015_6577:
	ret


	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $02, $07, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_15_65B8::
	ld a, $00
	ld [$d21e], a
	call Call_0891
	jr nz, jr_015_65cd

	call Call_0887
	ld [hl], $4c
	call Call_15_656F
	jp Call_3B8D


jr_015_65cd:
	cp $40
	jr nz, jr_015_65d6

	ld hl, $fff4
	ld [hl], $19

jr_015_65d6:
	cp $58
	jr nz, jr_015_65df

	ld hl, $fff2
	ld [hl], $39

jr_015_65df:
	rra
	rra
	and $3f
	ld e, a
	ld d, b
	ld hl, $6598
	add hl, de
	ld a, [hl]
	ld [$d224], a
	ld hl, $6578
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld a, [$d224]
	cp $05
	jr z, jr_015_6607

	ld a, $f3
	ld [$d225], a
	ld a, $f0
	ld [$d226], a
	ret


jr_015_6607:
	ld a, $f8
	ld [$d225], a
	ld a, $fe
	ld [$d226], a
	ret


	db $03, $02, $01, $00, $00, $01, $02, $03, $e8, $00, $18, $18, $00, $e8, $e8, $00
	db $10, $18, $10, $f0, $e8, $f0, $10, $18

Jump_15_662A::
	call Call_0887
	jr nz, jr_015_663a

	ld [$d221], a
	call Call_0891
	ld [hl], $30
	jp Call_3B8D


jr_015_663a:
	ld a, [$d21e]
	and a
	ld a, $f5
	jr z, jr_015_6644

	ld a, $0b

jr_015_6644:
	ld [$d225], a
	ld a, $ee
	ld [$d226], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	and $01
	call Call_3B87
	ld a, [$d21e]
	and a
	ld hl, $6612
	jr z, jr_015_6663

	ld hl, $6616

jr_015_6663:
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	nop
	and $03
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	inc a
	ld [$d224], a
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_015_66d9

	ld a, [$d221]
	cp $06
	jr nc, jr_015_66d9

	ld a, $e6
	call Call_3C01
	ret c

	ld hl, $c2e0
	add hl, de
	ld [hl], $30
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ld hl, $c340
	add hl, de
	ld [hl], $42
	ld hl, $c350
	add hl, de
	ld [hl], $00
	push de
	push de
	pop bc
	call Call_3B65
	pop de
	ld a, [$d21e]
	and a
	ld a, [$d221]
	jr nz, jr_015_66b2

	xor $07

jr_015_66b2:
	ld c, a
	ld hl, $6622
	add hl, bc
	ld a, [$d225]
	add [hl]
	ld hl, $ffd7
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $661a
	add hl, bc
	ld a, [hl]
	sub $0c
	ld hl, $ffd8
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $d221
	inc [hl]
	pop bc

jr_015_66d9:
	ret


	db $0b, $0a, $02, $0a

Jump_15_66DE::
	ld a, [$d21e]
	and a
	ld a, $fd
	jr z, jr_015_66e8

	ld a, $03

jr_015_66e8:
	ld [$d225], a
	ld a, $ec
	ld [$d226], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	nop
	and $03
	ld e, a
	ld d, b
	ld hl, $66da
	add hl, de
	ld a, [hl]
	inc a
	ld [$d224], a
	call Call_0891
	jr nz, jr_015_6760

	ld [hl], $40
	xor a
	ld [$d224], a
	call Call_3B8D
	ld a, $e6
	call Call_3C01
	jr c, jr_015_6760

	ld hl, $c2b0
	add hl, de
	inc [hl]
	ldh a, [$ffd8]
	sub $10
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld a, [$d21e]
	ld hl, $c380
	add hl, de
	ld [hl], a
	and a
	ld a, $08
	jr nz, jr_015_6736

	ld a, $f8

jr_015_6736:
	ld hl, $ffd7
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $40
	ld hl, $c350
	add hl, de
	ld [hl], $08
	push bc
	push de
	pop bc
	call Call_3B65
	ld a, $18
	call Call_3C25
	call Call_0891
	ld [hl], $30
	ld a, $27
	ldh [$fff4], a
	pop bc

jr_015_6760:
	ld a, $02
	call Call_3B87
	ret


Jump_15_6766::
	call Call_0891
	jr nz, jr_015_677d

	ld [hl], $1f
	call Call_27ED
	and $07
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	call Call_15_5140
	call Call_3B8D

jr_015_677d:
	ld a, $03
	call Call_3B87
	ret


	db $28, $50, $78, $28, $78, $28, $50, $78, $20, $28, $20, $30, $30, $50, $50, $50
	db $20, $1e, $1c, $1a, $18, $16, $14, $12, $10, $0e, $0c, $0a, $08, $06, $04, $02

Jump_15_67A3::
	ld a, $04
	call Call_3B87
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6783
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $678b
	add hl, de
	ld a, [hl]
	ldh [$ff99], a
	call Call_0891
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $6793
	add hl, de
	ld a, [hl]
	call Call_3C25
	ld hl, $ffee
	ldh a, [$ff98]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_67ed

	ld hl, $ffec
	ldh a, [$ff99]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_67ed

	call Call_3B8D

jr_015_67ed:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_15_7B8C
	ret


Jump_15_67F7::
	ret


Jump_15_67F8::
	call Call_0891
	jr nz, jr_015_680e

	ld [hl], $40
	call Call_15_5458
	call Call_3B8D
	ld a, $00
	call Call_3B87
	xor a
	ld [$d224], a

jr_015_680e:
	ret


Jump_15_680F::
	ld a, $06
	ldh [$fff1], a
	call Call_15_5728
	call Call_0891
	jr nz, jr_015_6827

	ld hl, $c340
	add hl, bc
	res 6, [hl]
	call Call_3B8D
	call Call_3DAF

jr_015_6827:
	ret


Jump_15_6828::
	call Call_3BB4
	call Call_15_7B8C
	call Call_3B9E
	ldh a, [$ffe7]
	and $01
	jr nz, jr_015_6856

	ld a, $18
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	sub [hl]
	bit 7, a
	jr z, jr_015_6848

	dec [hl]
	dec [hl]

jr_015_6848:
	inc [hl]
	ldh a, [$ffd8]
	ld hl, $c240
	sub [hl]
	bit 7, a
	jr z, jr_015_6855

	dec [hl]
	dec [hl]

jr_015_6855:
	inc [hl]

jr_015_6856:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6876

	ld hl, $c340
	add hl, bc
	set 6, [hl]
	call Call_0891
	ld [hl], $80
	call Call_27D2
	ld a, $10
	ldh [$fff3], a
	call Call_15_53AD
	jp Call_3B8D


jr_015_6876:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	ret nz

	ld a, $e6
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
	ld [hl], $03
	ld hl, $c2e0
	add hl, de
	ld [hl], $1f
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c3b0
	add hl, de
	ld [hl], $01
	ret


Jump_15_68AD::
	call Call_0891
	cp $01
	jr nz, jr_015_68b8

	dec [hl]
	jp Call_15_5140


jr_015_68b8:
	and a
	ret nz

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $50
	ldh [$ff98], a
	ld a, $30
	ldh [$ff99], a
	ld a, $0c
	call Call_3C25
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_68ed

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_68ed

	call Call_0891
	ld [hl], $5f
	call Call_3B8D

jr_015_68ed:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_15_7B8C
	ret


	db $00, $00, $00, $01, $01, $01, $02, $02

Jump_15_68FF::
	call Call_0891
	jr nz, jr_015_692c

	call Call_3DAF
	call Call_15_52E2
	ld hl, $c360
	add hl, bc
	ld [hl], $ff
	ld hl, $c340
	add hl, bc
	ld [hl], $00
	ld hl, $c430
	add hl, bc
	ld [hl], $c0
	call Call_0887
	ld [hl], $90
	xor a
	ld [$d223], a
	ld hl, $c300
	add hl, bc
	ld [hl], $3f
	ret


jr_015_692c:
	cp $20
	jr c, jr_015_6932

	ld a, $1f

jr_015_6932:
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $68f7
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	call Call_15_5728
	ret


Call_15_6943::
	ldh a, [$fff0]
	cp $0a
	ret nc

	ldh a, [$fff1]
	inc a
	ret z

	ld a, [$d21e]
	and a
	ldh a, [$fff1]
	jr z, jr_015_6956

	add $05

jr_015_6956:
	ldh [$fff1], a
	call Call_15_69EC
	call Call_15_6A84
	call Call_15_6C2C
	ret


	db $f8, $fc, $50, $00, $f8, $04, $52, $00, $f8, $0c, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fe, $50, $00, $fb, $06, $52, $00, $fb, $0e, $6e, $00, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $f8, $fc, $6e, $20, $f8, $04, $52, $20, $f8, $0c, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $fb, $fa, $6e, $20, $fb, $02, $52, $20, $fb, $0a, $50, $20, $08, $f8, $6a, $00
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $10, $6a, $20, $ff, $ff, $ff, $ff
	db $00, $00, $02, $01, $00, $02, $02, $00, $03, $02

Call_15_69EC::
	ldh a, [$fff1]
	ld e, a
	ld d, b
	ld hl, $69e2
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $70
	ld e, a
	ld hl, $6962
	add hl, de
	ld c, $07
	call Call_3D26
	ld a, $07
	call Call_3DD0
	ret


	db $f4, $f8, $64, $00, $fe, $11, $60, $00, $fe, $19, $62, $00, $f4, $f9, $64, $00
	db $fe, $11, $60, $00, $fe, $19, $62, $00, $f0, $00, $64, $20, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $10, $60, $00, $fb, $18, $62, $00
	db $00, $f8, $66, $00, $fe, $10, $66, $20, $ff, $ff, $ff, $ff, $f4, $10, $64, $20
	db $fe, $ef, $62, $20, $fe, $f7, $60, $20, $f4, $0f, $64, $20, $fe, $ef, $62, $20
	db $fe, $f7, $60, $20, $f0, $08, $64, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $fb, $f0, $62, $20, $fb, $f8, $60, $20, $fe, $f8, $66, $00
	db $00, $10, $66, $20, $ff, $ff, $ff, $ff

Call_15_6A84::
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $6a0c
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ret


	db $ec, $00, $70, $00, $ec, $08, $70, $20, $f4, $00, $7c, $00, $f4, $08, $7c, $20
	db $08, $00, $7c, $40, $08, $08, $7c, $60, $14, $00, $70, $40, $14, $08, $70, $60
	db $00, $00, $7e, $40, $00, $08, $7e, $20, $f3, $0d, $78, $20, $f3, $15, $76, $20
	db $0d, $f3, $76, $40, $0d, $fb, $78, $40, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $ec, $72, $00, $00, $f4, $74, $00, $00, $fc, $7a, $00, $00, $0c, $7a, $00
	db $00, $14, $74, $20, $00, $1c, $72, $20, $00, $00, $ff, $ff, $00, $00, $ff, $ff
	db $00, $00, $7e, $00, $00, $08, $7e, $60, $f3, $f3, $76, $00, $f3, $fb, $78, $00
	db $0d, $0d, $78, $60, $0d, $15, $76, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f1, $0f, $78, $20, $f1, $17, $76, $20, $0d, $f3, $76, $40, $0d, $fb, $78, $40
	db $00, $00, $ff, $ff, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f1, $f1, $76, $00, $f1, $f9, $78, $00, $0d, $0d, $78, $60, $0d, $15, $76, $60
	db $00, $00, $ff, $ff, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $08, $78, $20, $f8, $10, $76, $20, $08, $f8, $76, $40, $08, $00, $78, $40
	db $00, $00, $ff, $40, $00, $08, $ff, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fc, $04, $78, $20, $fc, $0c, $76, $20, $04, $fc, $76, $40, $04, $04, $78, $40
	db $00, $00, $ff, $40, $00, $08, $ff, $20, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $f8, $f8, $76, $00, $f8, $00, $78, $00, $08, $08, $78, $60, $08, $10, $76, $60
	db $00, $00, $ff, $00, $00, $08, $ff, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $fc, $fc, $76, $00, $fc, $04, $78, $00, $04, $04, $78, $60, $04, $0c, $76, $60
	db $00, $00, $ff, $00, $00, $08, $ff, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $f8, $72, $00, $00, $00, $74, $00, $00, $08, $74, $20, $00, $10, $72, $20
	db $00, $08, $ff, $ff, $00, $10, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff
	db $00, $fb, $72, $00, $00, $03, $74, $00, $00, $05, $74, $20, $00, $0d, $72, $20
	db $00, $fc, $ff, $ff, $00, $0c, $ff, $ff, $00, $00, $ff, $ff, $00, $00, $ff, $ff
	db $08, $06, $06, $06, $04, $04, $04, $04, $04, $04, $04, $04

Call_15_6C2C::
	ld a, [$d224]
	and a
	ret z

	ld a, [$d225]
	ld hl, $ffee
	add [hl]
	ld [hl], a
	ld a, [$d226]
	ld hl, $ffec
	add [hl]
	ld [hl], a
	ld a, [$d224]
	dec a
	ld e, a
	ld d, b
	ld hl, $6c20
	add hl, de
	ld c, [hl]
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
	ld a, e
	and $e0
	ld e, a
	ld hl, $6aa0
	add hl, de
	push bc
	call Call_3D26
	pop de
	ld a, e
	call Call_3DD0
	call Call_3DBA
	ret


	db $03, $02, $01, $00, $00, $01, $02, $03

Jump_015_6c7e:
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $09
	jp nc, Call_15_7C35

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	ld hl, $6c76
	jr z, jr_015_6ca7

	ld hl, $6c7a

jr_015_6ca7:
	add hl, de
	ld a, [hl]
	inc a
	ld [$d224], a
	xor a
	ld [$d225], a
	ld [$d226], a
	call Call_15_6C2C
	xor a
	ld [$d224], a
	call Call_15_7B20
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_015_6cc8

	ld a, $3a
	ldh [$fff4], a

jr_015_6cc8:
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	call Call_15_7B8C
	call Call_3BBF
	call Call_0891
	jr z, jr_015_6cd9

	ret


jr_015_6cd9:
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $c210
	add hl, de
	ld a, [hl]
	sub $0c
	ldh [$ff99], a
	ld a, $10
	call Call_3C30
	ld hl, $c250
	add hl, bc
	ldh a, [$ffd7]
	sub [hl]
	and $80
	jr nz, jr_015_6d06

	inc [hl]
	inc [hl]

jr_015_6d06:
	dec [hl]
	ld hl, $c240
	add hl, bc
	ldh a, [$ffd8]
	sub [hl]
	and $80
	jr nz, jr_015_6d14

	inc [hl]
	inc [hl]

jr_015_6d14:
	dec [hl]
	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6d46

	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_015_6d46

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $08
	jr nz, jr_015_6d46

	ld [hl], $03
	ld hl, $c2e0
	add hl, de
	ld [hl], $4c
	call Call_15_7C35

jr_015_6d46:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	ret


	db $4a, $00, $4a, $20, $4c, $00, $4c, $20, $4e, $00, $4e, $20, $00, $00, $01, $01

Jump_015_6d5d:
	ld de, $6d4d
	call Call_3C3B
	call Call_15_7B20
	call Call_0891
	jp z, Call_15_7C35

	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $6d59
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $1e, $00, $1e, $60, $34, $00, $34, $20, $54, $00, $54, $20, $56, $00, $56, $20

Jump_015_6d8c:
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ld de, $6d7c
	call Call_3C3B
	call Call_15_7B20
	ldh a, [$fff0]
	rst $00

JumpTable_15_6DA0::
	dw Jump_15_6DA4
	dw Jump_15_6DBB

Jump_15_6DA4::
	call Call_0891
	jr nz, jr_015_6dae

	ld [hl], $20
	jp Call_3B8D


jr_015_6dae:
	ld e, $00
	cp $18
	jr nc, jr_015_6db6

	ld e, $01

jr_015_6db6:
	ld a, e
	call Call_3B87
	ret


Jump_15_6DBB::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	call Call_0891
	cp $01
	jr nz, jr_015_6dd7

	ld a, $28
	ldh [$fff4], a
	ld a, $30
	call Call_3C25

jr_015_6dd7:
	ldh a, [$ffe7]
	xor c
	rra
	jr nc, jr_015_6de3

	call Call_15_7B8C
	call Call_3BBF

jr_015_6de3:
	ldh a, [$ffee]
	cp $a8
	jp nc, Call_15_7C35

	ldh a, [$ffec]
	cp $88
	jp nc, Call_15_7C35

	ret


	db $01, $02, $03, $03, $03, $03, $02, $01, $20, $23, $26, $29, $2c, $2f, $32, $35
	db $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
	db $20, $23, $26, $29, $2c, $2f, $32, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $34, $28, $27, $26, $25, $24, $23, $22, $21
	db $20, $1f, $1e, $1d, $1c, $1b, $1a, $19, $18, $18, $18, $18, $18, $18, $18, $18
	db $03, $02, $01, $00, $00, $00, $00, $00

Jump_15_6E4A::
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_6e6e

	cp $10
	jr nz, jr_015_6e5c

	dec [hl]
	call Call_15_52D8
	ld a, $10

jr_015_6e5c:
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6e42
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	call Call_15_5728
	ret


jr_015_6e6e:
	call Call_15_7070
	call Call_15_7B20
	ldh a, [$fff0]
	rst $00

JumpTable_15_6E77::
	dw Jump_15_6E7D
	dw Jump_15_6FB9
	dw Jump_15_6FD6

Jump_15_6E7D::
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nc, jr_015_6eb3

	ld a, $03
	ld [$c5a7], a
	ld a, $f6
	call Call_2197
	ld a, $5e
	ld [$d368], a
	call Call_0891
	ld [hl], $80
	ld hl, $c420
	add hl, bc
	ld [hl], $80
	ld hl, $c350
	add hl, bc
	res 7, [hl]
	ld hl, $c340
	add hl, bc
	set 6, [hl]
	call Call_27D2
	call Call_3B8D
	ret


jr_015_6eb3:
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_015_6ecd

	ld a, [$d223]
	cp $04
	jr nc, jr_015_6ecd

	inc a
	ld [$d223], a
	cp $01
	jr nz, jr_015_6ecd

	ld hl, $d368
	ld [hl], $50

jr_015_6ecd:
	call Call_08E2
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cpl
	cp $17
	jr c, jr_015_6edc

	ld a, $17

jr_015_6edc:
	ld e, a
	ld d, b
	ld hl, $6dfa
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld hl, $6e12
	add hl, de
	ld a, [hl]
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	ld hl, $6e2a
	add hl, de
	ld a, [$d210]
	inc a
	cp [hl]
	jr c, jr_015_6f02

	ld a, $3d
	ldh [$fff2], a
	xor a

jr_015_6f02:
	ld [$d210], a
	ld a, $00
	call Call_3B87
	call Call_0887
	jr nz, jr_015_6f23

	call Call_27ED
	and $0f
	add $20
	ld [hl], a
	call Call_27ED
	and $01
	jr nz, jr_015_6f23

	call Call_088C
	ld [hl], $7f

jr_015_6f23:
	ld hl, $c350
	add hl, bc
	set 7, [hl]
	call Call_088C
	jr z, jr_015_6f48

	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $6df2
	add hl, de
	ld a, [hl]
	call Call_3B87
	cp $03
	jr nz, jr_015_6f48

	ld hl, $c350
	add hl, bc
	res 7, [hl]

jr_015_6f48:
	call Call_3BB4
	ld e, $0f
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $f8
	jr nc, jr_015_6f58

	ld e, $07

jr_015_6f58:
	ldh a, [$ffe7]
	and e
	jr nz, jr_015_6f88

	ldh a, [$ff99]
	push af
	sub $20
	ldh [$ff99], a
	ld a, $08
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_015_6f76

	inc [hl]
	inc [hl]

jr_015_6f76:
	dec [hl]
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_015_6f84

	inc [hl]
	inc [hl]

jr_015_6f84:
	dec [hl]
	pop af
	ldh [$ff99], a

jr_015_6f88:
	call Call_15_7B8C
	call Call_3B9E
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_015_6fa3

	ld a, [$d221]
	inc a
	ld [$d221], a

jr_015_6fa3:
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_015_6fb8

	ld a, [$d222]
	dec a
	ld [$d222], a

jr_015_6fb8:
	ret


Jump_15_6FB9::
	call Call_0891
	cp $02
	jr nz, jr_015_6fc5

	ld hl, $d368
	ld [hl], $5f

jr_015_6fc5:
	and a
	jr nz, jr_015_6fd5

	ld [hl], $80
	ld a, $3d
	ldh [$fff4], a
	ld a, $10
	ldh [$fff3], a
	call Call_3B8D

jr_015_6fd5:
	ret


Jump_15_6FD6::
	call Call_0891
	and $0f
	jr nz, jr_015_700f

	ld a, [$d223]
	cp $00
	jr nz, jr_015_700b

	call Call_08D7
	call Call_15_53AD
	call Call_15_7C35
	ld a, $e6
	call Call_3C01
	ld hl, $c390
	add hl, de
	ld [hl], $02
	ld hl, $c210
	add hl, de
	ld [hl], $30
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c3b0
	add hl, de
	ld [hl], $ff
	ret


jr_015_700b:
	dec a
	ld [$d223], a

jr_015_700f:
	ret


	db $f0, $fc, $60, $00, $f0, $04, $62, $00, $f0, $0c, $60, $20, $f0, $fc, $64, $00
	db $f0, $04, $66, $00, $f0, $0c, $64, $20, $f0, $fc, $68, $00, $f0, $04, $6a, $00
	db $f0, $0c, $68, $20, $f0, $fc, $64, $00, $f0, $04, $66, $00, $f0, $0c, $64, $20
	db $00, $fc, $6c, $00, $00, $04, $6e, $00, $00, $0c, $6c, $20, $00, $fc, $70, $00
	db $00, $04, $72, $00, $00, $0c, $70, $20, $00, $fc, $74, $00, $00, $04, $76, $00
	db $00, $0c, $74, $20, $00, $fc, $78, $00, $00, $04, $7a, $00, $00, $0c, $78, $20

Call_15_7070::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $7010
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $7040
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	push af
	push hl
	sub $08
	ld [hl], a
	call Call_3DBA
	call Call_15_7196
	pop hl
	pop af
	ld [hl], a
	call Call_3DBA
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
	db $f8, $f9, $fa, $fb, $fb, $fc, $fd, $ff, $4e, $00, $4e, $20, $4c, $00, $4c, $20
	db $7c, $00, $7c, $20

Call_15_7196::
	ld a, [$d223]
	cp $04
	jr c, jr_015_71bb

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70ca
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $70c2
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $02
	call Call_15_72ED

jr_015_71bb:
	ld a, [$d223]
	cp $03
	jr c, jr_015_71e0

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70f2
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $70ea
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $01
	call Call_15_72ED

jr_015_71e0:
	ld a, [$d223]
	cp $02
	jr c, jr_015_7205

	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $711a
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $7112
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $01
	call Call_15_72ED

jr_015_7205:
	ld a, [$d223]
	cp $01
	jr c, jr_015_7241

	ld a, [$d221]
	and $0f
	cp $07
	jr z, jr_015_721d

	cp $08
	jr z, jr_015_721d

	cp $09
	jr nz, jr_015_7223

jr_015_721d:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_015_7241

jr_015_7223:
	ld a, [$d221]
	and $1f
	ld e, a
	ld d, b
	ld hl, $7142
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $713a
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $00
	call Call_15_72ED

jr_015_7241:
	ld a, [$d223]
	cp $04
	jr c, jr_015_7266

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70ca
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $70c2
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $02
	call Call_15_72ED

jr_015_7266:
	ld a, [$d223]
	cp $03
	jr c, jr_015_728b

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $70f2
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $70ea
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $01
	call Call_15_72ED

jr_015_728b:
	ld a, [$d223]
	cp $02
	jr c, jr_015_72b0

	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $711a
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $7112
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $01
	call Call_15_72ED

jr_015_72b0:
	ld a, [$d223]
	cp $01
	jr c, jr_015_72ec

	ld a, [$d222]
	and $0f
	cp $07
	jr z, jr_015_72c8

	cp $08
	jr z, jr_015_72c8

	cp $09
	jr nz, jr_015_72ce

jr_015_72c8:
	ldh a, [$ffe7]
	and $01
	jr z, jr_015_72ec

jr_015_72ce:
	ld a, [$d222]
	and $1f
	ld e, a
	ld d, b
	ld hl, $7142
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $713a
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld a, $00
	call Call_15_72ED

jr_015_72ec:
	ret


Call_15_72ED::
	ldh [$fff1], a
	ld de, $718a
	call Call_3C3B
	ld a, $02
	call Call_3DD0
	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_733b

	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $08
	cp $10
	jr nc, jr_015_733b

	ld hl, $c146
	ld a, [$dbc7]
	or [hl]
	jr nz, jr_015_733b

	ld a, $08
	ld [$db94], a
	ld a, $20
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a
	ld a, $10
	ld [$c13e], a
	ld a, $30
	ld [$dbc7], a
	ld a, $03
	ldh [$fff3], a

jr_015_733b:
	jp Call_3DBA


	db $58, $00, $58, $20, $5a, $00, $5a, $20, $10, $f0, $00, $00, $00, $00, $fb, $05

Call_15_734E::
	ld de, $733e
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	call Call_15_7B8C
	call Call_3B9E
	call Call_3BB4
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_737a

	call Call_0891
	jr nz, jr_015_73a0

jr_015_737a:
	call Call_0891
	call Call_27ED
	and $7f
	add $30
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $7346
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $734a
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_015_73a0:
	ret


	db $5c, $00, $5e, $00, $5e, $20, $5c, $20, $5e, $60, $5c, $60, $5c, $40, $5e, $40
	db $2c, $00, $2e, $00, $2e, $20, $2c, $20, $2e, $60, $2c, $60, $2c, $40, $2e, $40
	db $fd, $03, $00, $00, $00, $00, $03, $fd

Call_15_73C9::
	ld de, $73a1
	ld a, [$db95]
	cp $01
	jr nz, jr_015_73d6

	ld de, $73b1

jr_015_73d6:
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $03
	call Call_3B87
	call Call_15_7C0E
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ld a, [$c15b]
	and a
	jr z, jr_015_7407

	ldh a, [$ff9e]
	xor $01
	cp e
	jr nz, jr_015_7407

	set 7, [hl]

jr_015_7407:
	call Call_3BD5
	jr nc, jr_015_7446

	call Call_094A
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $80
	ret z

	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $73c1
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $73c5
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld a, $3e
	ldh [$fff2], a
	call Call_15_7B8C
	ld hl, $c410
	add hl, bc
	ld [hl], $03
	call Call_3B9E
	ld hl, $c410
	add hl, bc
	ld [hl], b

jr_015_7446:
	ld a, [$c16a]
	and a
	jr nz, jr_015_7452

	ld a, [$c15b]
	and a
	jr nz, jr_015_7455

jr_015_7452:
	call Call_3BEB

jr_015_7455:
	ret


	db $30, $d0

Call_15_7458::
	call Call_15_7B20
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7456
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_15_7B8F
	call Call_3B9E
	ldh a, [$ffaf]
	cp $9d
	jr z, jr_015_748a

	ld e, a
	ld d, $01
	call Call_29DB
	and a
	jr nz, jr_015_748a

	call Call_15_7C35
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	ldh [$ffea], a

jr_015_748a:
	ldh a, [$ffee]
	sub $08
	ldh [$ffce], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffec]
	add $04
	sub $10
	ldh [$ffcd], a
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ld [hl], $9d
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
	push hl
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr nz, jr_015_74f5

	ld a, $04
	ld [hli], a
	ldh a, [$ffea]
	and a
	ld a, $08
	jr nz, jr_015_74da

	ld a, $04

jr_015_74da:
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $05
	ld [hli], a
	ldh a, [$ffea]
	and a
	ld a, $09
	jr nz, jr_015_74f1

	ld a, $05

jr_015_74f1:
	ld [hli], a
	ld [hl], $00
	ret


jr_015_74f5:
	ldh a, [$ffea]
	and a
	ld a, $0a
	jr nz, jr_015_74fe

	ld a, $04

jr_015_74fe:
	ld [hli], a
	ld a, $04
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ldh a, [$ffea]
	and a
	ld a, $0b
	jr nz, jr_015_7515

	ld a, $05

jr_015_7515:
	ld [hli], a
	ld a, $05
	ld [hli], a
	ld [hl], $00
	ret


Call_15_751C::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_758e

	call Call_15_7B20
	call Call_15_7BDF
	add $20
	cp $40
	jr nc, jr_015_757d

	call Call_15_7BEF
	add $20
	cp $40
	jr nc, jr_015_757d

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $3f
	jr nz, jr_015_757d

	ld a, $b2
	ld e, $04
	call Call_3C13
	jr c, jr_015_757d

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c2d0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $18
	ld hl, $c2f0
	add hl, de
	ld [hl], $20
	push bc
	push de
	pop bc
	ld a, $08
	call Call_3C25
	pop bc

jr_015_757d:
	ret


	db $08, $f8, $00, $00, $00, $00, $f8, $08, $70, $00, $72, $00, $72, $20, $70, $20

Jump_015_758e:
	ld de, $7586
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_15_7B8C
	call Call_088C
	jr nz, jr_015_75af

	call Call_3B9E

jr_015_75af:
	call Call_3BB4
	call Call_0891
	jr nz, jr_015_75da

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	call Call_27ED
	and $03
	ld e, a
	ld d, b
	ld hl, $757e
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7582
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_015_75da:
	ret


	db $3e, $00, $f8, $08, $00, $00, $00, $00, $08, $f8

Call_15_75E5::
	call Call_15_7B20
	ldh a, [$fff0]
	and a
	jr nz, jr_015_75f0

	call Call_3BCA

jr_015_75f0:
	call Call_15_7B8C
	call Call_3BA9
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_7648

	push hl
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffef]
	ldh [$ffd8], a
	ld a, $05
	call Call_0953
	pop hl
	ld a, [hl]
	cp $02
	jp nz, Call_15_7C35

	ld [hl], $00
	ld hl, $c290
	add hl, bc
	ld [hl], a
	ldh a, [$ff9e]
	and $02
	jr nz, jr_015_7625

	ld hl, $c240
	jr jr_015_7628

jr_015_7625:
	ld hl, $c250

jr_015_7628:
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call Call_093B
	ld a, $10
	ld [$c13e], a
	ldh a, [$ff9e]
	ld e, a
	ld d, b
	ld hl, $75dd
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $75e1
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	ret


jr_015_7648:
	ldh a, [$ffee]
	add $04
	ldh [$ffd7], a
	ldh a, [$ffef]
	ldh [$ffd8], a
	ld a, $06
	call Call_0953
	ld [hl], $10
	ret


	db $00, $00, $74, $00, $00, $08, $74, $20, $00, $00, $ff, $00, $f0, $08, $7a, $00
	db $00, $00, $76, $00, $00, $08, $78, $00, $f0, $00, $7a, $20, $00, $00, $78, $20
	db $00, $08, $76, $20, $00, $00, $74, $40, $00, $08, $74, $60, $00, $00, $ff, $00

Call_15_768A::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_015_7834

	ld hl, $765a
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	rla
	add e
	ld e, a
	ld d, b
	add hl, de
	ld c, $03
	call Call_3D26
	call Call_3D19
	ldh a, [$fff0]
	cp $02
	jr nc, jr_015_76fe

	ld a, [$c157]
	and a
	jr z, jr_015_76fe

	ld a, [$c178]
	and a
	jr z, jr_015_76fe

	ldh a, [$ffee]
	add $08
	ld hl, $c179
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_76fe

	ldh a, [$ffef]
	add $08
	ld hl, $c17a
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_76fe

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $18
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], $18
	call Call_3B8D
	ld [hl], $02
	ld hl, $c320
	add hl, bc
	ld [hl], $15
	ld hl, $c250
	add hl, bc
	ld [hl], $0c
	ld hl, $c240
	add hl, bc
	ld [hl], $fa
	ret


jr_015_76fe:
	ldh a, [$fff0]
	rst $00

JumpTable_15_7701::
	dw Jump_15_7709
	dw Jump_15_7719
	dw Jump_15_77A2
	dw Jump_15_77CE

Jump_15_7709::
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	add $08
	ld [hl], a
	call Call_0891
	ld [hl], $80
	jp Call_3B8D


Jump_15_7719::
	call Call_15_7B20
	call Call_0891
	ret nz

	ld [hl], $50
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	cp $03
	jr nz, jr_015_772d

	xor a

jr_015_772d:
	ld [hl], a
	ldh [$fff1], a
	cp $00
	jr z, jr_015_77a1

	call Call_0891
	ld [hl], $28
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $0f
	jr nz, jr_015_7747

	ld a, $02
	jr jr_015_7749

jr_015_7747:
	ld a, $e0

jr_015_7749:
	call Call_3C01
	ret c

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	sub $0c
	add $18
	ld [hl], a
	ld hl, $c310
	add hl, de
	ld [hl], $18
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld hl, $c320
	add hl, de
	ld [hl], $20
	ldh a, [$fff1]
	cp $01
	ld a, $f8
	jr z, jr_015_777a

	ld a, $08

jr_015_777a:
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, de
	ld [hl], $0c
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c430
	add hl, de
	set 0, [hl]
	ld a, $08
	ldh [$fff2], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $60
	ld hl, $c440
	add hl, de
	ld [hl], $01

jr_015_77a1:
	ret


Jump_15_77A2::
	ld a, $03
	call Call_3B87
	call Call_15_7B8C
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_77cd

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	call Call_3DAF
	call Call_3B8D

jr_015_77c9:
	ld a, $14
	ldh [$fff3], a

jr_015_77cd:
	ret


Jump_15_77CE::
	ld a, $00
	call Call_3B87
	call Call_15_7B8C
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_780d

	ld [hl], $01
	call Call_27ED
	and $0f
	add $08
	ld hl, $c320
	add hl, bc
	ld [hl], a
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

jr_015_780d:
	ldh a, [$ffee]
	cp $a8
	jp nc, Call_15_7C35

	ldh a, [$ffec]
	cp $80
	jp nc, Call_15_7C35

	ldh a, [$ffe7]
	and $0f
	jr z, jr_015_77c9

	ret


	db $7c, $00, $7e, $00, $7e, $20, $7c, $20, $00, $0c, $10, $0c, $00, $f4, $f0, $f4
	db $00, $0c

Jump_015_7834:
	ld de, $7822
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7B42
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BB4
	call Call_15_7B8C
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_015_789b

	ld [hl], b
	call Call_27ED
	and $0f
	add $10
	ld hl, $c320
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $782c
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $782a
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld a, [hl]
	cp $04
	jp z, Call_15_7C35

	ld a, $09
	ldh [$fff2], a

jr_015_789b:
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $52, $20, $50, $20, $56, $20, $54, $20

Call_15_78AC::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_015_78ba

	ldh a, [$fff1]
	add $02
	ldh [$fff1], a

jr_015_78ba:
	ld de, $789c
	call Call_3C3B
	call Call_15_7B20
	call Call_15_7BC5
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_015_78de

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], a

jr_015_78de:
	ldh a, [$fff0]
	rst $00

JumpTable_15_78E1::
	dw Jump_15_78ED
	dw Jump_15_793D

	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

Jump_15_78ED::
	call Call_0891
	jr nz, jr_015_7929

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $78e5
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
	ld hl, $78e5
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
	jp Call_3B8D


jr_015_7929:
	ld a, $01
	call Call_3B87
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_015_793c

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $04
	ld [hl], a

jr_015_793c:
	ret


Jump_15_793D::
	call Call_15_7B8C
	call Call_3B9E
	ldh a, [$ffe8]
	and a
	jr z, jr_015_795f

	call Call_0891
	jr nz, jr_015_7954

	ld [hl], $48
	call Call_3B8D
	ld [hl], b
	ret


jr_015_7954:
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ld hl, $c310
	add hl, bc
	inc [hl]

jr_015_795f:
	ld a, $00
	call Call_3B87
	ret


	db $00, $08, $10, $18, $20, $28, $30, $38

Call_15_796D::
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $0f

Call_15_7974::
	sla a
	sla a
	ld e, a
	ld a, [$c3c0]
	add e
	cp $60
	jr c, jr_015_7983

	sub $60

jr_015_7983:
	ld [$c3c0], a
	ld a, [$c3c1]
	add e
	ld [$c3c1], a
	cp $60
	jr c, jr_015_79a4

	ldh a, [$ffe7]
	ld hl, $c123
	add [hl]
	and $07
	ld e, a
	ld d, $00
	ld hl, $7965
	add hl, de
	ld a, [hl]
	ld [$c3c0], a

jr_015_79a4:
	ret


Call_15_79A5::
	ldh a, [$ffea]
	cp $07
	jr z, jr_015_79f4

	ld hl, $c470
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_015_79f5

	cp $03
	jp z, Jump_015_7a3e

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_79f4

	ldh a, [$fff9]
	and a
	jr nz, jr_015_79f4

	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $10
	jr z, jr_015_79f4

	ldh a, [$ffe7]
	xor c
	and $01
	jr nz, jr_015_79f4

	ld a, [$c3c0]
	ld l, a
	ld h, $00
	ld de, $c030
	add hl, de
	ldh a, [$ffef]
	add $0a
	ld [hli], a
	ldh a, [$ffee]
	add $04
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld [hl], b
	ld a, $01
	call Call_15_7974

jr_015_79f4:
	ret


Jump_015_79f5:
	ldh a, [$ffeb]
	cp $02
	jr nz, Call_15_7A06

	ld hl, $ffec
	dec [hl]
	dec [hl]
	call Call_15_7A06
	jp Call_3DBA


Call_15_7A06::
	ld a, [$c3c0]
	ld l, a
	ld h, $00
	ld de, $c030
	add hl, de
	ld e, $00
	ldh a, [$ffe7]
	and $04
	jr z, jr_015_7a1a

	ld e, $10

jr_015_7a1a:
	ldh a, [$ffec]
	add $0b
	ld [hli], a
	ldh a, [$ffee]
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ld a, e
	ld [hli], a
	ldh a, [$ffec]
	add $0b
	ld [hli], a
	ldh a, [$ffee]
	add $08
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ld a, e
	or $20
	ld [hli], a
	ld a, $02
	call Call_15_7974
	ret


Jump_015_7a3e:
	push bc
	ld hl, $c3d0
	add hl, bc
	ld e, [hl]
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld c, b
	or [hl]
	jr z, jr_015_7a57

	ld a, e
	rla
	rla
	and $20
	ld c, a

jr_015_7a57:
	ld a, [$c3c0]
	ld l, a
	ld h, $00
	ld de, $c030
	add hl, de
	ldh a, [$ffec]
	add $08
	ld [hli], a
	ldh a, [$ffee]
	dec a
	ld [hli], a
	ld a, $1a
	ld [hli], a
	ld a, c
	ld [hli], a
	ldh a, [$ffec]
	add $08
	ld [hli], a
	ldh a, [$ffee]
	add $07
	ld [hli], a
	ld a, $1a
	ld [hli], a
	ld a, c
	ld [hl], a
	pop bc
	ld a, $02
	call Call_15_7974
	ret


Call_15_7A85::
	call Call_3BD5
	jr nc, jr_015_7ab1

	call Call_094A
	ld a, [$c1a6]
	and a
	jr z, jr_015_7aa4

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_015_7aa4

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_015_7aa4:
	ld a, [$c14a]
	ld e, a
	call Call_0942
	call Call_1495
	ld a, e
	scf
	ret


jr_015_7ab1:
	and a
	ret


	db $06, $04, $02, $00, $21, $80, $c3, $09, $5e, $50, $21, $b3, $7a, $19, $e5, $21
	db $d0, $c3, $09, $34, $7e, $1f, $1f, $1f, $1f, $e1, $e6, $01, $b6, $c3, $87, $3b

Call_15_7AD3::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28
	jr nc, jr_015_7b1e

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_015_7b1e

	inc e
	push de
	call Call_15_7C0E
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_015_7b1e

	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_015_7b1e

	ld a, [$db9a]
	cp $80
	jr nz, jr_015_7b1e

	ldh a, [$ffcc]
	and $10
	jr z, jr_015_7b1e

	scf
	ret


jr_015_7b1e:
	and a
	ret


Call_15_7B20::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_015_7b40

Call_15_7B26::
	ld a, [$db95]
	cp $07
	jr z, jr_015_7b40

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_015_7b40

	ld a, [$c124]
	and a
	jr z, jr_015_7b41

jr_015_7b40:
	pop af

jr_015_7b41:
	ret


Call_15_7B42::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_7b8b

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
	call Call_15_7B8C
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_015_7b7e

	call Call_3B9E

jr_015_7b7e:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_015_7b8b:
	ret


Call_15_7B8C::
	call Call_15_7B99

Call_15_7B8F::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_15_7B99
	pop bc
	ret


Call_15_7B99::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_7bc4

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

jr_015_7bb1:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_015_7bbb

	ld e, $f0

jr_015_7bbb:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_015_7bc4:
	ret


Call_15_7BC5::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_015_7bc4

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_015_7bb1

Call_15_7BDF::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_015_7bed

	inc e

jr_015_7bed:
	ld d, a
	ret


Call_15_7BEF::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_015_7bfd

	inc e

jr_015_7bfd:
	ld d, a
	ret


	db $1e, $02, $f0, $99, $21, $ec, $ff, $96, $cb, $7f, $20, $01, $1c, $57, $c9

Call_15_7C0E::
	call Call_15_7BDF
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_015_7c1b

	cpl
	inc a

jr_015_7c1b:
	push af
	call Call_15_7BEF
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_015_7c29

	cpl
	inc a

jr_015_7c29:
	pop de
	cp d
	jr nc, jr_015_7c31

	ldh a, [$ffd7]
	jr jr_015_7c33

jr_015_7c31:
	ldh a, [$ffd8]

jr_015_7c33:
	ld e, a
	ret


Call_15_7C35::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


Jump_015_7c3b:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_15_7C41::
	dw Jump_15_7C47
	dw Jump_15_7C58
	dw Jump_15_7C69

Jump_15_7C47::
	call Call_0891
	ld [hl], $a0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff

Call_15_7C52::
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_15_7C58::
	call Call_0891
	jr nz, jr_015_7c68

	ld [hl], $c0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_15_7C52

jr_015_7c68:
	ret


Jump_15_7C69::
	call Call_0891
	jr nz, jr_015_7c74

	call Call_08D7
	jp Call_3F7A


jr_015_7c74:
	call Call_15_7C78
	ret


Call_15_7C78::
	and $07
	jr nz, jr_015_7c99

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
	call Call_15_7C9A

jr_015_7c99:
	ret


Call_15_7C9A::
	call Call_15_7B26
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
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08, $cd, $35, $7c, $21
	db $f4, $ff, $36, $1a, $c9

Call_15_7CE4::
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_015_7cf9

	cp $06
	jr c, jr_015_7cf9

	inc d

jr_015_7cf9:
	add hl, de
	ld a, [hl]
	or $20
	ld [hl], a
	ldh [$fff8], a
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
