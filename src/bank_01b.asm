; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01b", ROMX[$4000], BANK[$1b]

	db $c3, $09, $40, $c3, $9e, $4d

	jp Jump_01b_401e


	db $21, $00, $d3, $36, $00, $2c, $20, $fb, $3e, $80, $e0, $26, $3e, $77, $e0, $24
	db $3e, $ff, $e0, $25, $c9

Jump_01b_401e:
	ld hl, $d368
	ld a, [hli]
	and a
	jr nz, jr_01b_4031

	call Call_1B_4037

jr_01b_4028:
	call Call_1B_4481
	ret


Jump_01b_402c:
	xor a
	ld [$d3ce], a
	ret


jr_01b_4031:
	ld [hl], a
	call Call_1B_411B
	jr jr_01b_4028

Call_1B_4037::
	ld de, $d393
	ld hl, $d378
	ld a, [hli]
	cp $01
	jr z, jr_01b_4048

	ld a, [hl]
	cp $01
	jr z, jr_01b_4053

	ret


jr_01b_4048:
	ld a, $01
	ld [$d379], a
	ld hl, $4060
	jp Jump_01b_406a


jr_01b_4053:
	ld a, [de]
	dec a
	ld [de], a
	ret nz

	xor a
	ld [$d379], a
	ld hl, $4065
	jr jr_01b_406a

	db $3b, $80, $07, $c0, $02, $00, $42, $02, $c0, $04

Jump_01b_406a:
jr_01b_406a:
	ld b, $04
	ld c, $20

jr_01b_406e:
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, jr_01b_406e

	ld a, [hl]
	ld [de], a
	ret


	db $34, $50, $e2, $51, $93, $52, $2c, $53, $05, $54, $58, $57, $f0, $59, $8d, $5a
	db $7d, $5b, $71, $5c, $09, $5d, $b8, $5d, $08, $5e, $27, $5e, $a7, $5e, $a8, $4a
	db $0a, $5f, $c1, $5f, $17, $60, $96, $60, $5f, $61, $41, $62, $1e, $4d, $00, $50
	db $15, $63, $3e, $64, $df, $64, $ec, $4b, $13, $65, $9c, $6b, $ea, $6b, $01, $4b

Call_1B_40B7::
	inc e
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld l, c
	ld h, b
	ld a, h
	ret


Call_1B_40C6::
	push bc
	ld c, $30

jr_01b_40c9:
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, jr_01b_40c9

	pop bc
	ret


Call_1B_40D3::
	xor a
	ld [$d379], a
	ld [$d34f], a
	ld [$d398], a
	ld [$d393], a
	ld [$d3c9], a
	ld [$d3a3], a
	ld a, $08
	ldh [rNR42], a
	ld a, $80
	ldh [rNR44], a
	ret


Call_1B_40EF::
	ld a, [$d379]
	cp $0c
	jp z, Jump_01b_4dbc

	cp $05
	jp z, Jump_01b_4dbc

	cp $1a
	jp z, Jump_01b_4dbc

	cp $24
	jp z, Jump_01b_4dbc

	cp $2a
	jp z, Jump_01b_4dbc

	cp $2e
	jp z, Jump_01b_4dbc

	cp $3f
	jp z, Jump_01b_4dbc

	call Call_1B_40D3
	jp Jump_01b_4dbc


Call_1B_411B::
	cp $ff
	jr z, Call_1B_40EF

	ld a, [$d3ca]
	ld [$d3cb], a
	ld a, [hl]
	ld [$d3ca], a
	cp $11
	jr nc, jr_01b_412f

	jr jr_01b_4144

jr_01b_412f:
	cp $21
	jr nc, jr_01b_4136

	jp Jump_01b_402c


jr_01b_4136:
	cp $31
	jr nc, jr_01b_413d

	jp Jump_01b_402c


jr_01b_413d:
	cp $41
	jp nc, Jump_01b_402c

	add $e0

jr_01b_4144:
	dec hl
	ld [hli], a
	ld b, a
	ld a, $01
	ld [$d3ce], a
	ld a, b
	ld [hl], a
	ld b, a
	ld hl, $4077
	and $7f
	call Call_1B_40B7
	call Call_1B_42AE
	jp Jump_01b_4247


	db $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff
	db $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00
	db $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00
	db $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff
	db $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00
	db $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00
	db $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff
	db $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00
	db $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00
	db $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff
	db $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00
	db $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00, $01, $00, $ff, $ff, $00, $00

Jump_01b_421d:
	ld a, [$d3e7]
	and a
	jp z, Jump_01b_463d

	xor a
	ldh [rNR30], a
	ld [$d3e7], a
	push hl
	ld a, [$d336]
	ld l, a
	ld a, [$d337]
	ld h, a
	push bc
	ld c, $30

jr_01b_4236:
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, jr_01b_4236

	ld a, $80
	ldh [rNR30], a
	pop bc
	pop hl
	jp Jump_01b_463d


Jump_01b_4247:
	ld a, [$d369]
	ld hl, $415d

jr_01b_424d:
	dec a
	jr z, jr_01b_4258

	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	jr jr_01b_424d

jr_01b_4258:
	ld bc, $d355
	ld a, [hli]
	ld [bc], a
	inc c
	xor a
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	xor a
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	ldh [rNR51], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	ret


Call_1B_4275::
	ld hl, $d355
	ld a, [hli]
	cp $01
	ret z

	inc [hl]
	ld a, [hli]
	cp [hl]
	ret nz

	dec l
	ld [hl], $00
	inc l
	inc l
	inc [hl]
	ld a, [hli]
	and $03
	ld c, l
	ld b, h
	and a
	jr z, jr_01b_4299

	inc c
	cp $01
	jr z, jr_01b_4299

	inc c
	cp $02
	jr z, jr_01b_4299

	inc c

jr_01b_4299:
	ld a, [bc]
	ldh [rNR51], a
	ret


Call_1B_429D::
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [bc]
	ld [de], a
	inc e
	inc bc
	ld a, [bc]
	ld [de], a
	ret


Call_1B_42A8::
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	ret


Call_1B_42AE::
	ld a, [$d379]
	cp $05
	jr z, jr_01b_42d0

	cp $0c
	jr z, jr_01b_42d0

	cp $1a
	jr z, jr_01b_42d0

	cp $24
	jr z, jr_01b_42d0

	cp $2a
	jr z, jr_01b_42d0

	cp $2e
	jr z, jr_01b_42d0

	cp $3f
	jr z, jr_01b_42d0

	call Call_1B_40D3

jr_01b_42d0:
	call Call_1B_4DC9
	ld de, $d300
	ld b, $00
	ld a, [hli]
	ld [de], a
	inc e
	call Call_1B_42A8
	ld de, $d310
	call Call_1B_42A8
	ld de, $d320
	call Call_1B_42A8
	ld de, $d330
	call Call_1B_42A8
	ld de, $d340
	call Call_1B_42A8
	ld hl, $d310
	ld de, $d314
	call Call_1B_429D
	ld hl, $d320
	ld de, $d324
	call Call_1B_429D
	ld hl, $d330
	ld de, $d334
	call Call_1B_429D
	ld hl, $d340
	ld de, $d344
	call Call_1B_429D
	ld bc, $0410
	ld hl, $d312

jr_01b_4320:
	ld [hl], $01
	ld a, c
	add l
	ld l, a
	dec b
	jr nz, jr_01b_4320

	xor a
	ld [$d31e], a
	ld [$d32e], a
	ld [$d33e], a
	ret


jr_01b_4333:
	push hl
	ld a, e
	ld [$d336], a
	ld a, d
	ld [$d337], a
	ld a, [$d371]
	and a
	jr nz, jr_01b_434a

	xor a
	ldh [rNR30], a
	ld l, e
	ld h, d
	call Call_1B_40C6

jr_01b_434a:
	pop hl
	jr jr_01b_4377

Jump_01b_434d:
	call Call_1B_437D
	call Call_1B_4392
	ld e, a
	call Call_1B_437D
	call Call_1B_4392
	ld d, a
	call Call_1B_437D
	call Call_1B_4392
	ld c, a
	inc l
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], c
	dec l
	dec l
	dec l
	dec l
	push hl
	ld hl, $d350
	ld a, [hl]
	pop hl
	cp $03
	jr z, jr_01b_4333

jr_01b_4377:
	call Call_1B_437D
	jp Jump_01b_44a3


Call_1B_437D::
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de

jr_01b_4383:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	pop de
	ret


Call_1B_4389::
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
	inc de
	jr jr_01b_4383

Call_1B_4392::
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [bc]
	ld b, a
	ret


jr_01b_4399:
	pop hl
	jr jr_01b_43cd

Jump_01b_439c:
	ld a, [$d350]
	cp $03
	jr nz, jr_01b_43b3

	ld a, [$d338]
	bit 7, a
	jr z, jr_01b_43b3

	ld a, [hl]
	cp $06
	jr nz, jr_01b_43b3

	ld a, $40
	ldh [rNR32], a

jr_01b_43b3:
	push hl
	ld a, l
	add $09
	ld l, a
	ld a, [hl]
	and a
	jr nz, jr_01b_4399

	ld a, l
	add $04
	ld l, a
	bit 7, [hl]
	jr nz, jr_01b_4399

	pop hl
	call Call_1B_4670
	push hl
	call Call_1B_46F9
	pop hl

Jump_01b_43cd:
jr_01b_43cd:
	dec l
	dec l
	jp Jump_01b_4650


Jump_01b_43d2:
	dec l
	dec l
	dec l
	dec l
	call Call_1B_4389

jr_01b_43d9:
	ld a, l
	add $04
	ld e, a
	ld d, h
	call Call_1B_429D
	cp $00
	jr z, jr_01b_4404

	cp $ff
	jr z, jr_01b_43ed

	inc l
	jp Jump_01b_44a1


jr_01b_43ed:
	dec l
	push hl
	call Call_1B_4389
	call Call_1B_4392
	ld e, a
	call Call_1B_437D
	call Call_1B_4392
	ld d, a
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	jr jr_01b_43d9

jr_01b_4404:
	ld a, [$d3ca]
	cp $0f
	jp z, Jump_01b_4757

	cp $10
	jp z, Jump_01b_4757

	cp $25
	jp z, Jump_01b_4757

	ld hl, $d369
	ld [hl], $00
	call Call_1B_40EF
	ret


Jump_01b_441f:
	call Call_1B_437D
	call Call_1B_4392
	ld [$d301], a
	call Call_1B_437D
	call Call_1B_4392
	ld [$d302], a
	jr jr_01b_443c

Jump_01b_4433:
	call Call_1B_437D
	call Call_1B_4392
	ld [$d300], a

jr_01b_443c:
	call Call_1B_437D
	jr jr_01b_44a3

Jump_01b_4441:
	call Call_1B_437D
	call Call_1B_4392
	push hl
	ld a, l
	add $0b
	ld l, a
	ld c, [hl]
	ld a, b
	or c
	ld [hl], a
	ld b, h
	ld c, l
	dec c
	dec c
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	ld a, d
	ld [bc], a
	dec c
	ld a, e
	ld [bc], a
	jr jr_01b_44a3

Jump_01b_4465:
	push hl
	ld a, l
	add $0b
	ld l, a
	ld a, [hl]
	dec [hl]
	ld a, [hl]
	and $7f
	jr z, jr_01b_447e

	ld b, h
	ld c, l
	dec c
	dec c
	dec c
	pop hl
	ld a, [bc]
	ld [hli], a
	inc c
	ld a, [bc]
	ld [hld], a
	jr jr_01b_44a3

jr_01b_447e:
	pop hl
	jr jr_01b_443c

Call_1B_4481::
	ld hl, $d369
	ld a, [hl]
	and a
	ret z

	ld a, [$d3ce]
	and a
	ret z

	call Call_1B_4275
	ld a, $01
	ld [$d350], a
	ld hl, $d310

Jump_01b_4497:
	inc l
	ld a, [hli]
	and a
	jp z, Jump_01b_43cd

	dec [hl]
	jp nz, Jump_01b_439c

Jump_01b_44a1:
	inc l
	inc l

Jump_01b_44a3:
jr_01b_44a3:
	call Call_1B_4392
	cp $00
	jp z, Jump_01b_43d2

	cp $9d
	jp z, Jump_01b_434d

	cp $9e
	jp z, Jump_01b_441f

	cp $9f
	jp z, Jump_01b_4433

	cp $9b
	jp z, Jump_01b_4441

	cp $9c
	jp z, Jump_01b_4465

	cp $99
	jp z, Jump_01b_4771

	cp $9a
	jp z, Jump_01b_477c

	cp $94
	jp z, Jump_01b_48ff

	cp $97
	jp z, Jump_01b_47b8

	cp $98
	jp z, Jump_01b_47c7

	cp $96
	jp z, Jump_01b_4763

	cp $95
	jp z, Jump_01b_476e

	and $f0
	cp $a0
	jr nz, jr_01b_453a

	ld a, b
	and $0f
	ld c, a
	ld b, $00
	push hl
	ld de, $d301
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, [hl]
	pop hl
	push hl
	ld d, a
	inc l
	inc l
	inc l
	ld a, [hl]
	and $f0
	jr nz, jr_01b_450c

	ld a, d
	jr jr_01b_4531

jr_01b_450c:
	ld e, a
	ld a, d
	push af
	srl a
	sla e
	jr c, jr_01b_451d

	ld d, a
	srl a
	sla e
	jr c, jr_01b_451d

	add d

jr_01b_451d:
	ld c, a
	and a
	jr nz, jr_01b_4523

	ld c, $02

jr_01b_4523:
	ld de, $d350
	ld a, [de]
	dec a
	ld e, a
	ld d, $00
	ld hl, $d307
	add hl, de
	ld [hl], c
	pop af

jr_01b_4531:
	pop hl
	dec l
	ld [hli], a
	call Call_1B_437D
	call Call_1B_4392

jr_01b_453a:
	ld a, [$d350]
	cp $04
	jr z, jr_01b_4579

	push de
	ld de, $d3b0
	call Call_1B_4807
	xor a
	ld [de], a
	inc e
	ld [de], a
	ld de, $d3b6
	call Call_1B_4807
	inc e
	xor a
	ld [de], a
	ld a, [$d350]
	cp $03
	jr nz, jr_01b_4578

	ld de, $d39e
	ld a, [de]
	and a
	jr z, jr_01b_456a

	ld a, $01
	ld [de], a
	xor a
	ld [$d39f], a

jr_01b_456a:
	ld de, $d3d9
	ld a, [de]
	and a
	jr z, jr_01b_4578

	ld a, $01
	ld [de], a
	xor a
	ld [$d3da], a

jr_01b_4578:
	pop de

jr_01b_4579:
	ld c, b
	ld b, $00
	call Call_1B_437D
	ld a, [$d350]
	cp $04
	jp z, Jump_01b_45bb

	push hl
	ld a, l
	add $05
	ld l, a
	ld e, l
	ld d, h
	inc l
	inc l
	ld a, c
	cp $01
	jr z, jr_01b_45b6

	ld [hl], $00
	ld a, [$d300]
	and a
	jr z, jr_01b_45a9

	ld l, a
	ld h, $00
	bit 7, l
	jr z, jr_01b_45a6

	ld h, $ff

jr_01b_45a6:
	add hl, bc
	ld b, h
	ld c, l

jr_01b_45a9:
	ld hl, $4934
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	jp Jump_01b_45ec


jr_01b_45b6:
	ld [hl], $01
	pop hl
	jr jr_01b_45ec

Jump_01b_45bb:
	push hl
	ld a, c
	cp $ff
	jr z, jr_01b_45d9

	ld de, $d346
	ld hl, $49c6
	add hl, bc

jr_01b_45c8:
	ld a, [hli]
	ld [de], a
	inc e
	ld a, e
	cp $4b
	jr nz, jr_01b_45c8

	ld c, $20
	ld hl, $d344
	ld b, $00
	jr jr_01b_461a

jr_01b_45d9:
	ld a, [$d34f]
	bit 7, a
	jp nz, Jump_01b_464b

	ld a, $01
	ld [$d378], a
	call Call_1B_4037
	jp Jump_01b_464b


Jump_01b_45ec:
jr_01b_45ec:
	push hl
	ld b, $00
	ld a, [$d350]
	cp $01
	jr z, jr_01b_4617

	cp $02
	jr z, jr_01b_4613

	ld c, $1a
	ld a, [$d33f]
	bit 7, a
	jr nz, jr_01b_4608

	xor a
	ldh [c], a
	ld a, $80
	ldh [c], a

jr_01b_4608:
	inc c
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	ld e, a
	ld d, $00
	jr jr_01b_4621

jr_01b_4613:
	ld c, $16
	jr jr_01b_461a

jr_01b_4617:
	ld c, $10
	inc c

jr_01b_461a:
	inc l
	inc l
	ld a, [hli]
	ld e, a
	inc l
	ld a, [hli]
	ld d, a

jr_01b_4621:
	push hl
	inc l
	inc l
	ld a, [hli]
	and a
	jr z, jr_01b_462a

	ld e, $08

jr_01b_462a:
	inc l
	inc l
	ld [hl], $00
	inc l
	ld a, [hl]
	pop hl
	bit 7, a
	jr nz, jr_01b_464b

	ld a, [$d350]
	cp $03
	jp z, Jump_01b_421d

Jump_01b_463d:
	ld a, d
	or b
	ldh [c], a
	inc c
	ld a, e
	ldh [c], a
	inc c
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, [hl]
	or $80
	ldh [c], a

Jump_01b_464b:
jr_01b_464b:
	pop hl
	dec l
	ld a, [hld]
	ld [hld], a
	dec l

Jump_01b_4650:
	ld de, $d350
	ld a, [de]
	cp $04
	jr z, jr_01b_4661

	inc a
	ld [de], a
	ld a, $10
	add l
	ld l, a
	jp Jump_01b_4497


jr_01b_4661:
	ld hl, $d31e
	inc [hl]
	ld hl, $d32e
	inc [hl]
	ld hl, $d33e
	inc [hl]
	ret


Jump_01b_466e:
	pop hl
	ret


Call_1B_4670::
	push hl
	ld a, l
	add $06
	ld l, a
	ld a, [hl]
	and $0f
	jr z, jr_01b_4692

	ld [$d351], a
	ld a, [$d350]
	ld c, $13
	cp $01
	jr z, jr_01b_46d4

	ld c, $18
	cp $02
	jr z, jr_01b_46d4

	ld c, $1d
	cp $03
	jr z, jr_01b_46d4

Jump_01b_4692:
jr_01b_4692:
	ld a, [$d350]
	cp $04
	jp z, Jump_01b_466e

	ld de, $d3b6
	call Call_1B_4807
	ld a, [de]
	and a
	jp z, Jump_01b_46bb

	ld a, [$d350]
	ld c, $13
	cp $01
	jp z, Jump_01b_47d0

	ld c, $18
	cp $02
	jp z, Jump_01b_47d0

	ld c, $1d
	jp Jump_01b_47d0


Jump_01b_46bb:
	ld a, [$d350]
	cp $03
	jp nz, Jump_01b_466e

	ld a, [$d39e]
	and a
	jp nz, Jump_01b_4782

	ld a, [$d3d9]
	and a
	jp nz, Jump_01b_490a

	jp Jump_01b_466e


jr_01b_46d4:
	inc l
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0f
	ld d, a
	push de
	ld a, l
	add $04
	ld l, a
	ld b, [hl]
	ld a, [$d351]
	cp $01
	jp z, Jump_01b_481d

	cp $05
	jp z, Jump_01b_488a

	ld hl, $ffff
	pop de
	add hl, de
	call Call_1B_47F6
	jp Jump_01b_4692


Call_1B_46F9::
	ld a, [$d31b]
	and a
	jr nz, jr_01b_4720

	ld a, [$d317]
	and a
	jr z, jr_01b_4720

	and $0f
	ld b, a
	ld hl, $d307
	ld a, [$d31e]
	cp [hl]
	jr nz, jr_01b_4720

	ld c, $12
	ld de, $d31a
	ld a, [$d31f]
	bit 7, a
	jr nz, jr_01b_4720

	call Call_1B_4744

jr_01b_4720:
	ld a, [$d32b]
	and a
	ret nz

	ld a, [$d327]
	and a
	ret z

	and $0f
	ld b, a
	ld hl, $d308
	ld a, [$d32e]
	cp [hl]
	ret nz

	ld a, [$d32f]
	bit 7, a
	ret nz

	ld c, $17
	ld de, $d32a
	call Call_1B_4744
	ret


Call_1B_4744::
	push bc
	dec b
	ld c, b
	ld b, $00
	ld hl, $4a85
	add hl, bc
	ld a, [hl]
	pop bc
	ldh [c], a
	inc c
	inc c
	ld a, [de]
	or $80
	ldh [c], a
	ret


Jump_01b_4757:
	xor a
	ld [$d3ce], a
	ldh a, [$ffbf]
	ld [$d368], a
	jp Jump_01b_401e


Jump_01b_4763:
	ld a, $01

jr_01b_4765:
	ld [$d3cd], a
	call Call_1B_437D
	jp Jump_01b_44a3


Jump_01b_476e:
	xor a
	jr jr_01b_4765

Jump_01b_4771:
	ld a, $01

jr_01b_4773:
	ld [$d39e], a
	call Call_1B_437D
	jp Jump_01b_44a3


Jump_01b_477c:
	xor a
	ld [$d39e], a
	jr jr_01b_4773

Jump_01b_4782:
	cp $02
	jp z, Jump_01b_466e

	ld bc, $d39f
	call Call_1B_47B4
	ld c, $1c
	ld b, $40
	cp $03
	jr z, jr_01b_47af

	ld b, $60
	cp $05
	jr z, jr_01b_47af

	cp $0a
	jr z, jr_01b_47af

	ld b, $00
	cp $07
	jr z, jr_01b_47af

	cp $0d
	jp nz, Jump_01b_466e

	ld a, $02
	ld [$d39e], a

Jump_01b_47af:
jr_01b_47af:
	ld a, b
	ldh [c], a
	jp Jump_01b_466e


Call_1B_47B4::
	ld a, [bc]
	inc a
	ld [bc], a
	ret


Jump_01b_47b8:
	ld de, $d3b6
	call Call_1B_4807
	ld a, $01

jr_01b_47c0:
	ld [de], a
	call Call_1B_437D
	jp Jump_01b_44a3


Jump_01b_47c7:
	ld de, $d3b6
	call Call_1B_4807
	xor a
	jr jr_01b_47c0

Jump_01b_47d0:
	inc e
	ld a, [de]
	and a
	jr nz, jr_01b_47e6

	inc a
	ld [de], a
	pop hl
	push hl
	call Call_1B_47EB

jr_01b_47dc:
	ld hl, $ff9c
	add hl, de
	call Call_1B_47F6
	jp Jump_01b_466e


jr_01b_47e6:
	call Call_1B_4810
	jr jr_01b_47dc

Call_1B_47EB::
	ld a, $07
	add l
	ld l, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0f
	ld d, a
	ret


Call_1B_47F6::
	ld de, $d3a4
	call Call_1B_4807
	ld a, l
	ldh [c], a
	ld [de], a
	inc c
	inc e
	ld a, h
	and $0f
	ldh [c], a
	ld [de], a
	ret


Call_1B_4807::
	ld a, [$d350]
	dec a
	sla a
	add e
	ld e, a
	ret


Call_1B_4810::
	ld de, $d3a4
	call Call_1B_4807
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld d, a
	ld e, l
	ret


Jump_01b_481d:
	pop de
	ld de, $d3b0
	call Call_1B_4807
	ld a, [de]
	inc a
	ld [de], a
	inc e
	cp $19
	jr z, jr_01b_485d

	cp $2d
	jr z, jr_01b_4856

	ld a, [de]
	and a
	jp z, Jump_01b_4692

jr_01b_4835:
	dec e
	ld a, [de]
	sub $19
	sla a
	ld l, a
	ld h, $00
	ld de, $4862
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	push de
	call Call_1B_47EB
	ld h, d
	ld l, e
	pop de
	add hl, de
	call Call_1B_47F6
	jp Jump_01b_4692


jr_01b_4856:
	dec e
	ld a, $19
	ld [de], a
	inc e
	jr jr_01b_4835

jr_01b_485d:
	ld a, $01
	ld [de], a
	jr jr_01b_4835

	db $00, $00, $00, $00, $00, $01, $00, $01, $00, $02, $00, $02, $00, $00, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $00, $00, $00, $01, $00, $02, $00, $01
	db $00, $00, $ff, $ff, $ff, $fe, $ff, $ff

Jump_01b_488a:
	pop de
	ld de, $d3d0
	call Call_1B_4807
	ld a, [de]
	inc a
	ld [de], a
	inc e
	cp $21
	jr z, jr_01b_48b8

jr_01b_4899:
	dec e
	ld a, [de]
	sla a
	ld l, a
	ld h, $00
	ld de, $48bf
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	push de
	call Call_1B_47EB
	ld h, d
	ld l, e
	pop de
	add hl, de
	call Call_1B_47F6
	jp Jump_01b_4692


jr_01b_48b8:
	dec e
	ld a, $01
	ld [de], a
	inc e
	jr jr_01b_4899

	db $00, $08, $00, $00, $ff, $f8, $00, $00, $00, $0a, $00, $02, $ff, $fa, $00, $02
	db $00, $0c, $00, $04, $ff, $fc, $00, $04, $00, $0a, $00, $02, $ff, $fa, $00, $02
	db $00, $08, $00, $00, $ff, $f8, $00, $00, $00, $06, $ff, $fe, $ff, $f6, $ff, $fe
	db $00, $04, $ff, $fc, $ff, $f4, $ff, $fc, $00, $06, $ff, $fe, $ff, $f6, $ff, $fe

Jump_01b_48ff:
	ld a, $01
	ld [$d3d9], a
	call Call_1B_437D
	jp Jump_01b_44a3


Jump_01b_490a:
	cp $02
	jp z, Jump_01b_466e

	ld bc, $d3da
	call Call_1B_47B4
	ld c, $1c
	ld b, $60
	cp $03
	jp z, Jump_01b_47af

	ld b, $40
	cp $05
	jp z, Jump_01b_47af

	ld b, $20
	cp $06
	jp nz, Jump_01b_466e

	ld a, $02
	ld [$d3d9], a
	jp Jump_01b_47af


	db $00, $0f, $2c, $00, $9c, $00, $06, $01, $6b, $01, $c9, $01, $23, $02, $77, $02
	db $c6, $02, $12, $03, $56, $03, $9b, $03, $da, $03, $16, $04, $4e, $04, $83, $04
	db $b5, $04, $e5, $04, $11, $05, $3b, $05, $63, $05, $89, $05, $ac, $05, $ce, $05
	db $ed, $05, $0a, $06, $27, $06, $42, $06, $5b, $06, $72, $06, $89, $06, $9e, $06
	db $b2, $06, $c4, $06, $d6, $06, $e7, $06, $f7, $06, $06, $07, $14, $07, $21, $07
	db $2d, $07, $39, $07, $44, $07, $4f, $07, $59, $07, $62, $07, $6b, $07, $74, $07
	db $7b, $07, $83, $07, $8a, $07, $90, $07, $97, $07, $9d, $07, $a2, $07, $a7, $07
	db $ac, $07, $b1, $07, $b6, $07, $ba, $07, $be, $07, $c1, $07, $c5, $07, $c8, $07
	db $cb, $07, $ce, $07, $d1, $07, $d4, $07, $d6, $07, $d9, $07, $db, $07, $dd, $07
	db $df, $07, $00, $00, $00, $00, $00, $c0, $09, $00, $38, $34, $c0, $19, $00, $38
	db $33, $c0, $46, $00, $13, $10, $c0, $23, $00, $20, $40, $80, $51, $00, $20, $07
	db $80, $a1, $00, $00, $18, $80, $f2, $00, $00, $18, $80, $81, $00, $3a, $10, $c0
	db $80, $00, $00, $10, $c0, $57, $00, $00, $60, $80, $01, $02, $04, $08, $10, $20
	db $06, $0c, $18, $01, $01, $01, $01, $01, $30, $01, $03, $06, $0c, $18, $30, $09
	db $12, $24, $02, $04, $08, $01, $01, $48, $02, $04, $08, $10, $20, $40, $0c, $18
	db $30, $02, $05, $03, $01, $01, $60, $03, $05, $0a, $14, $28, $50, $0f, $1e, $3c
	db $02, $08, $10, $02, $01, $78, $03, $06, $0c, $18, $30, $60, $12, $24, $48, $03
	db $08, $10, $02, $04, $90, $03, $07, $0e, $1c, $38, $70, $15, $2a, $54, $04, $09
	db $12, $02, $01, $a8, $04, $08, $10, $20, $40, $80, $18, $30, $60, $04, $02, $01
	db $01, $00, $c0, $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $05, $0c, $18, $18
	db $06, $d8, $05, $0a, $14, $28, $50, $a0, $1e, $3c, $78, $05, $01, $01, $01, $01
	db $f0, $10, $32, $22, $47, $81, $20, $00, $92, $4a, $ff, $ff, $8c, $4a, $9b, $20
	db $ae, $01, $9c, $00, $00, $22, $44, $55, $66, $66, $88, $88, $aa, $aa, $cc, $cc
	db $04, $84, $04, $84, $00, $2b, $4a, $b3, $4a, $b7, $4a, $bb, $4a, $bf, $4a, $c3
	db $4a, $00, $00, $d3, $4a, $00, $00, $e1, $4a, $00, $00, $f3, $4a, $00, $00, $9d
	db $60, $21, $00, $96, $a2, $5c, $5e, $aa, $60, $62, $64, $ae, $66, $95, $00, $9d
	db $80, $21, $41, $a2, $4a, $4c, $aa, $4e, $50, $52, $ae, $54, $00, $9d, $42, $6e
	db $20, $99, $a2, $3c, $3e, $aa, $40, $42, $44, $9a, $a5, $46, $a4, $01, $00, $a3
	db $01, $aa, $15, $1a, $1a, $9b, $1e, $a0, $15, $9c, $a7, $01, $00, $04, $67, $4a
	db $0c, $4b, $24, $4b, $2c, $4b, $00, $00, $42, $4b, $7c, $4b, $7c, $4b, $7c, $4b
	db $7c, $4b, $7c, $4b, $7c, $4b, $7c, $4b, $7c, $4b, $e6, $4b, $ff, $ff, $0c, $4b
	db $47, $4b, $b1, $4b, $ff, $ff, $24, $4b, $77, $4b, $77, $4b, $77, $4b, $77, $4b
	db $77, $4b, $77, $4b, $77, $4b, $77, $4b, $e6, $4b, $ff, $ff, $2c, $4b, $9d, $31
	db $00, $40, $00, $9d, $30, $81, $80, $9b, $08, $a3, $01, $a2, $44, $46, $a3, $4a
	db $a2, $54, $5c, $a7, $5c, $a1, $58, $56, $a4, $58, $a2, $01, $58, $5c, $5e, $a3
	db $5c, $58, $a5, $4a, $a4, $7a, $a7, $6c, $a1, $6a, $6c, $a4, $70, $62, $66, $ae
	db $74, $9c, $00, $9d, $52, $6e, $40, $99, $9b, $02, $a2, $24, $2c, $32, $2c, $9c
	db $9b, $02, $24, $30, $36, $30, $9c, $24, $2e, $36, $2e, $22, $2e, $34, $2e, $2c
	db $32, $40, $3a, $3c, $36, $32, $2c, $9b, $02, $28, $2e, $36, $2e, $9c, $9b, $02
	db $28, $2e, $34, $2e, $9c, $9b, $04, $24, $2c, $32, $2c, $9c, $00, $9d, $61, $00
	db $80, $a4, $01, $97, $ac, $01, $ad, $2c, $2c, $ac, $2c, $aa, $2c, $98, $ac, $32
	db $ad, $32, $36, $ac, $3a, $aa, $36, $a3, $32, $40, $3a, $4a, $a4, $40, $ac, $40
	db $ad, $40, $42, $ac, $40, $aa, $3e, $a4, $38, $a3, $36, $a7, $40, $a4, $40, $a7
	db $01, $00, $9b, $0b, $a4, $01, $9c, $00, $00, $58, $4a, $f7, $4b, $ff, $4b, $07
	db $4c, $0f, $4c, $17, $4c, $50, $4c, $ff, $ff, $f9, $4b, $24, $4c, $61, $4c, $ff
	db $ff, $01, $4c, $31, $4c, $b1, $4c, $ff, $ff, $09, $4c, $3e, $4c, $fa, $4c, $ff
	db $ff, $11, $4c, $9d, $60, $00, $41, $a7, $01, $a1, $4e, $aa, $01, $ae, $50, $00
	db $9d, $40, $00, $01, $a7, $01, $a1, $64, $aa, $01, $ae, $66, $00, $9d, $a1, $4c
	db $20, $a7, $01, $a1, $5a, $aa, $01, $ae, $5c, $00, $a7, $01, $a1, $01, $aa, $01
	db $a5, $01, $a1, $ff, $a2, $ff, $ff, $a1, $ff, $a2, $ff, $00, $9d, $22, $00, $80
	db $97, $9b, $20, $a1, $54, $6a, $62, $5c, $78, $70, $6a, $9c, $00, $9d, $81, $00
	db $40, $a6, $46, $a0, $46, $4a, $a6, $4e, $a1, $4a, $a3, $46, $54, $4e, $5e, $a4
	db $54, $a6, $54, $a0, $54, $56, $a6, $54, $a1, $52, $a4, $4c, $a3, $4a, $54, $a4
	db $46, $a5, $01, $01, $01, $9d, $61, $00, $80, $97, $a1, $36, $a6, $36, $a1, $36
	db $a6, $36, $a1, $36, $a2, $36, $36, $a1, $36, $a2, $36, $98, $00, $8a, $df, $da
	db $86, $31, $01, $36, $86, $8a, $df, $da, $86, $31, $01, $36, $86, $9d, $a1, $4c
	db $20, $97, $9b, $02, $aa, $30, $01, $a0, $01, $a1, $01, $9c, $a6, $01, $aa, $30
	db $01, $a0, $01, $a1, $01, $9b, $02, $aa, $30, $01, $a0, $01, $9c, $a1, $01, $a3
	db $01, $9b, $02, $aa, $30, $01, $a0, $01, $a1, $01, $9c, $a6, $01, $aa, $30, $01
	db $a0, $01, $a1, $01, $9b, $02, $aa, $30, $01, $a0, $01, $9c, $a1, $01, $a6, $01
	db $aa, $30, $01, $a0, $01, $00, $9b, $07, $a1, $15, $15, $15, $15, $ff, $15, $15
	db $15, $15, $15, $15, $15, $ff, $15, $15, $1a, $9c, $9b, $02, $ff, $ff, $15, $15
	db $9c, $ff, $ff, $15, $ff, $15, $ff, $ff, $15, $00, $00, $2b, $4a, $29, $4d, $2f
	db $4d, $35, $4d, $00, $00, $3b, $4d, $ff, $ff, $29, $4d, $51, $4d, $ff, $ff, $2f
	db $4d, $87, $4d, $ff, $ff, $35, $4d, $9d, $43, $00, $80, $a7, $4c, $4c, $4c, $4c
	db $4a, $4a, $4a, $4a, $46, $46, $46, $46, $42, $46, $4a, $50, $00, $9d, $40, $21
	db $80, $a8, $5a, $a3, $01, $a2, $58, $a3, $5e, $a8, $50, $a2, $01, $a3, $5a, $a2
	db $42, $a3, $46, $a2, $4a, $a3, $4c, $a2, $4a, $a3, $4c, $a7, $40, $54, $ae, $50
	db $a2, $01, $00, $44, $44, $44, $42, $00, $00, $00, $00, $44, $44, $44, $42, $00
	db $00, $00, $00, $9d, $77, $4d, $20, $99, $a7, $4a, $4a, $46, $46, $46, $46, $42
	db $42, $42, $42, $40, $40, $3e, $3e, $44, $4a, $00, $af, $ea, $79, $d3, $ea, $4f
	db $d3, $ea, $98, $d3, $ea, $93, $d3, $ea, $c9, $d3, $ea, $a3, $d3, $ea, $e5, $d3
	db $3e, $08, $e0, $21, $3e, $80, $e0, $23

Jump_01b_4dbc:
	ld a, $ff
	ldh [rNR51], a
	ld a, $03
	ld [$d355], a
	xor a
	ld [$d369], a

Call_1B_4DC9::
	xor a
	ld [$d361], a
	ld [$d371], a
	ld [$d31f], a
	ld [$d32f], a
	ld [$d33f], a
	ld [$d39e], a
	ld [$d39f], a
	ld [$d3d9], a
	ld [$d3da], a
	ld [$d3b6], a
	ld [$d3b7], a
	ld [$d3b8], a
	ld [$d3b9], a
	ld [$d3ba], a
	ld [$d3bb], a
	ld [$d394], a
	ld [$d395], a
	ld [$d396], a
	ld [$d390], a
	ld [$d391], a
	ld [$d392], a
	ld [$d3c6], a
	ld [$d3c7], a
	ld [$d3c8], a
	ld [$d3a0], a
	ld [$d3a1], a
	ld [$d3a2], a
	ld [$d3cd], a
	ld [$d3d6], a
	ld [$d3d7], a
	ld [$d3d8], a
	ld [$d3dc], a
	ld [$d3e7], a
	ld [$d3e2], a
	ld [$d3e3], a
	ld [$d3e4], a
	ld a, $08
	ldh [rNR12], a
	ldh [rNR22], a
	ld a, $80
	ldh [rNR14], a
	ldh [rNR24], a
	xor a
	ldh [rNR10], a
	ldh [rNR30], a
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $58, $4a, $8c, $4a, $8c, $4a, $0b
	db $50, $00, $00, $0f, $50, $00, $00, $9d, $82, $6e, $01, $94, $a3, $4a, $a2, $4e
	db $a3, $52, $a2, $4e, $a7, $4a, $58, $52, $62, $a8, $58, $a3, $58, $a2, $5a, $a3
	db $58, $a2, $56, $a8, $50, $a7, $4e, $58, $a8, $4a, $9a, $00, $00, $3a, $4a, $3f
	db $50, $47, $50, $4f, $50, $00, $00, $ec, $6f, $5b, $50, $ff, $ff, $41, $50, $ab
	db $50, $d9, $50, $ff, $ff, $49, $50, $e1, $6e, $3c, $51, $c2, $6e, $7e, $51, $ff
	db $ff, $53, $50, $9d, $66, $81, $80, $a5, $01, $a2, $01, $5e, $a1, $5e, $62, $66
	db $68, $a3, $6c, $01, $01, $a1, $64, $6e, $72, $76, $a3, $7c, $01, $a7, $01, $a1
	db $64, $68, $a2, $6c, $64, $a3, $5a, $a7, $01, $9b, $02, $a1, $68, $6c, $a2, $6e
	db $9c, $01, $a7, $01, $9b, $02, $a1, $64, $68, $a2, $6c, $9c, $01, $a7, $01, $a1
	db $62, $66, $a2, $6a, $a1, $6a, $6c, $70, $74, $76, $7a, $a2, $74, $01, $a8, $01
	db $a5, $01, $00, $9d, $a0, $84, $80, $a4, $46, $a2, $01, $46, $46, $a1, $46, $46
	db $9b, $02, $a6, $46, $a1, $42, $a3, $46, $a2, $01, $46, $46, $a1, $46, $46, $9c
	db $a2, $46, $a1, $3c, $3c, $9b, $02, $a2, $3c, $a1, $3c, $3c, $9c, $a2, $3c, $3c
	db $00, $9d, $80, $21, $40, $a2, $46, $01, $a7, $3c, $a1, $01, $46, $46, $4a, $4e
	db $50, $a4, $54, $a2, $01, $54, $54, $a1, $56, $5a, $a4, $5e, $a2, $01, $5e, $5e
	db $a1, $5a, $56, $a6, $5a, $a1, $56, $a4, $54, $a3, $54, $a6, $50, $a1, $54, $a4
	db $56, $a2, $54, $50, $a6, $4c, $a1, $50, $a4, $54, $a2, $50, $4c, $a6, $4a, $a1
	db $4e, $a4, $52, $a3, $58, $9d, $60, $81, $80, $a2, $54, $a1, $46, $46, $a2, $46
	db $a1, $46, $46, $a3, $46, $01, $a2, $01, $a1, $44, $44, $a2, $44, $a1, $44, $44
	db $a3, $44, $01, $00, $99, $a3, $4e, $a2, $01, $a1, $2e, $2e, $a2, $2e, $4e, $4e
	db $a1, $4e, $4e, $a6, $4a, $a1, $4a, $a2, $4a, $a1, $2a, $2a, $a2, $2a, $4a, $4a
	db $a1, $4a, $4a, $a6, $4c, $a1, $4c, $a2, $4c, $a1, $26, $26, $a2, $26, $4c, $4c
	db $a1, $4c, $4c, $a2, $4c, $a1, $44, $44, $9b, $02, $a2, $44, $a1, $44, $44, $9c
	db $a2, $24, $a1, $28, $2c, $00, $99, $9b, $02, $a2, $2e, $a3, $46, $a2, $46, $9c
	db $9b, $02, $a2, $2a, $a3, $42, $a2, $42, $9c, $9b, $02, $a2, $26, $a3, $3e, $a2
	db $3e, $9c, $9b, $02, $a2, $34, $a3, $4c, $a2, $4c, $9c, $9b, $02, $a2, $30, $a3
	db $48, $a2, $48, $9c, $9b, $02, $a2, $2e, $a3, $46, $a2, $46, $9c, $a2, $32, $a3
	db $4a, $a2, $4a, $32, $4a, $5e, $32, $3c, $9b, $02, $a1, $50, $50, $a2, $50, $9c
	db $a1, $32, $32, $a2, $32, $a1, $32, $32, $a2, $3c, $9b, $02, $a1, $50, $50, $a2
	db $50, $9c, $a1, $24, $24, $24, $26, $28, $2c, $00, $00, $1c, $4a, $ed, $51, $0d
	db $52, $21, $52, $00, $00, $fb, $6e, $a5, $6f, $41, $52, $41, $52, $41, $52, $41
	db $52, $41, $52, $41, $52, $00, $6f, $ab, $6f, $41, $52, $41, $52, $41, $52, $4b
	db $52, $ff, $ff, $ed, $51, $05, $6f, $a5, $6f, $55, $52, $5d, $52, $0a, $6f, $ab
	db $6f, $5d, $52, $7a, $52, $ff, $ff, $0d, $52, $dc, $6e, $a5, $6f, $7d, $52, $7d
	db $52, $7d, $52, $7d, $52, $7d, $52, $7d, $52, $c2, $6e, $ab, $6f, $7d, $52, $7d
	db $52, $7d, $52, $88, $52, $ff, $ff, $21, $52, $a7, $22, $a2, $22, $a3, $24, $22
	db $1e, $18, $00, $a7, $22, $a2, $22, $a3, $24, $22, $1e, $01, $00, $9b, $03, $a8
	db $01, $9c, $a4, $01, $00, $9b, $02, $a1, $01, $40, $42, $44, $a7, $46, $a2, $3a
	db $a4, $46, $a1, $01, $44, $46, $44, $a2, $40, $3c, $a7, $40, $a2, $32, $a8, $40
	db $9c, $00, $a3, $01, $00, $99, $a7, $32, $a2, $32, $a3, $34, $32, $2e, $28, $00
	db $99, $a7, $32, $a2, $32, $a3, $34, $32, $2e, $01, $00, $00, $58, $4a, $9e, $52
	db $a4, $52, $ac, $52, $00, $00, $eb, $52, $ff, $ff, $9e, $52, $b6, $52, $bb, $52
	db $ff, $ff, $a4, $52, $fb, $6f, $27, $53, $bb, $52, $ff, $ff, $ae, $52, $9d, $57
	db $00, $80, $00, $a2, $78, $7c, $a3, $7e, $01, $01, $a2, $78, $7c, $a3, $7e, $01
	db $01, $a2, $7c, $78, $6e, $a7, $74, $a3, $78, $01, $a8, $01, $a2, $78, $7c, $a3
	db $7e, $01, $01, $a2, $78, $7e, $a3, $88, $01, $01, $a2, $86, $82, $a4, $86, $01
	db $a8, $01, $00, $9d, $37, $00, $80, $a7, $01, $9b, $02, $a2, $40, $4e, $58, $5c
	db $a3, $60, $01, $9c, $a2, $48, $56, $5c, $6a, $a3, $6e, $01, $a2, $48, $56, $5c
	db $56, $44, $56, $5c, $56, $9b, $02, $a2, $40, $4e, $58, $5c, $a3, $60, $01, $9c
	db $a2, $36, $44, $4c, $52, $56, $5c, $64, $6a, $6e, $6a, $6e, $74, $8c, $00, $9d
	db $a2, $6e, $20, $00, $00, $67, $4a, $37, $53, $3d, $53, $8c, $4a, $00, $00, $43
	db $53, $ff, $ff, $37, $53, $a5, $53, $ff, $ff, $3d, $53, $9d, $52, $00, $80, $99
	db $9b, $02, $a2, $40, $4e, $9c, $9b, $02, $40, $52, $9c, $9b, $02, $40, $56, $9c
	db $9b, $02, $40, $52, $9c, $9b, $02, $40, $4e, $9c, $9b, $02, $40, $50, $9c, $9b
	db $02, $44, $52, $9c, $4e, $36, $3a, $36, $9b, $02, $32, $40, $9c, $9b, $02, $32
	db $44, $9c, $9b, $02, $30, $44, $9c, $9b, $02, $3a, $48, $9c, $9b, $02, $2c, $3a
	db $9c, $2c, $38, $36, $32, $9d, $40, $00, $80, $a4, $36, $32, $9e, $76, $4a, $a4
	db $30, $a7, $2c, $9d, $52, $00, $80, $a2, $36, $9e, $67, $4a, $00, $9d, $56, $00
	db $80, $a3, $66, $58, $a7, $5c, $a1, $60, $62, $a2, $66, $66, $58, $58, $a7, $5c
	db $a1, $60, $62, $a2, $60, $66, $a7, $74, $a2, $70, $74, $70, $66, $a1, $62, $60
	db $a3, $5c, $9d, $42, $00, $80, $56, $9d, $56, $00, $80, $a1, $01, $60, $62, $66
	db $a3, $6a, $58, $a7, $56, $a1, $5c, $6a, $a2, $66, $66, $56, $56, $a7, $58, $a1
	db $58, $56, $a2, $52, $58, $a7, $60, $a2, $5c, $58, $50, $9b, $04, $4e, $66, $9c
	db $9e, $76, $4a, $9b, $04, $a2, $66, $7e, $9c, $9e, $67, $4a, $00, $00, $3a, $4a
	db $10, $54, $1e, $54, $2c, $54, $00, $00, $46, $54, $71, $54, $bc, $54, $71, $54
	db $e9, $54, $ff, $ff, $12, $54, $62, $55, $8f, $55, $c4, $55, $8f, $55, $e8, $55
	db $ff, $ff, $20, $54, $c2, $6e, $64, $56, $c2, $6e, $8d, $56, $af, $56, $8d, $56
	db $dd, $56, $c7, $6e, $ea, $56, $c2, $6e, $f7, $56, $ff, $ff, $30, $54, $9d, $45
	db $00, $80, $a3, $30, $aa, $30, $30, $30, $a3, $2c, $aa, $2c, $30, $32, $a3, $38
	db $aa, $38, $38, $38, $a3, $3c, $aa, $3c, $3c, $3c, $9d, $40, $21, $81, $a8, $40
	db $aa, $3c, $3c, $3c, $a8, $40, $a3, $01, $00, $9d, $45, $00, $80, $a3, $30, $aa
	db $32, $30, $2c, $a6, $30, $a1, $30, $30, $32, $36, $3a, $a6, $3c, $a1, $40, $40
	db $44, $48, $4a, $a3, $4e, $aa, $3c, $40, $44, $a6, $46, $a1, $38, $38, $3c, $40
	db $44, $aa, $46, $01, $46, $46, $44, $40, $46, $01, $3c, $3c, $3c, $38, $3c, $01
	db $3c, $3c, $38, $3c, $a2, $38, $a1, $38, $36, $a2, $38, $a1, $38, $3c, $a3, $40
	db $a2, $3c, $38, $00, $a2, $36, $a1, $36, $32, $a2, $36, $a1, $36, $38, $a3, $3c
	db $a2, $38, $36, $a3, $34, $a2, $34, $a1, $34, $36, $a2, $3a, $a1, $3a, $3c, $40
	db $44, $46, $4a, $a3, $44, $9d, $40, $21, $41, $aa, $32, $32, $32, $a3, $36, $01
	db $00, $9d, $45, $00, $80, $aa, $36, $34, $36, $3e, $40, $44, $46, $01, $46, $46
	db $44, $40, $9d, $70, $21, $80, $a6, $4e, $46, $a2, $40, $a3, $3e, $aa, $3e, $3a
	db $3e, $aa, $40, $44, $46, $4a, $46, $44, $a3, $46, $01, $9d, $50, $21, $81, $a3
	db $46, $a7, $40, $a1, $01, $46, $46, $4a, $4e, $50, $aa, $4a, $01, $46, $a4, $44
	db $a3, $3c, $aa, $40, $01, $36, $a3, $36, $32, $3a, $a2, $40, $a1, $40, $3e, $40
	db $44, $46, $4a, $a4, $4e, $aa, $4e, $01, $4a, $a4, $46, $a3, $01, $aa, $4a, $01
	db $50, $a4, $5a, $a3, $01, $01, $aa, $40, $40, $40, $a3, $40, $01, $9d, $40, $21
	db $40, $01, $aa, $4a, $4a, $4a, $a3, $4e, $01, $00, $9d, $55, $00, $80, $a3, $40
	db $aa, $40, $36, $40, $a3, $3c, $aa, $3c, $40, $44, $a3, $46, $aa, $46, $40, $46
	db $a3, $44, $aa, $44, $46, $4a, $9d, $50, $21, $81, $a8, $4e, $aa, $4a, $4a, $4a
	db $a8, $4e, $aa, $4a, $48, $44, $00, $9d, $65, $00, $80, $a3, $40, $a7, $36, $a1
	db $01, $40, $40, $44, $48, $4a, $a4, $4e, $aa, $01, $01, $4e, $4e, $50, $54, $a4
	db $58, $aa, $01, $01, $58, $58, $54, $50, $54, $01, $50, $a4, $4e, $aa, $4e, $50
	db $4e, $a2, $4a, $a1, $4a, $4e, $a4, $50, $a2, $4e, $4a, $00, $a2, $46, $a1, $46
	db $4a, $a4, $4e, $a2, $4a, $46, $44, $a1, $44, $48, $a4, $4c, $a3, $52, $a2, $4e
	db $9d, $60, $21, $01, $ad, $36, $36, $36, $aa, $3a, $3a, $3a, $a3, $3e, $01, $00
	db $9d, $45, $00, $80, $aa, $46, $44, $46, $4a, $46, $4a, $4e, $01, $4e, $4e, $4a
	db $46, $9d, $40, $00, $81, $a4, $4e, $66, $a8, $58, $9d, $70, $21, $41, $aa, $4e
	db $50, $54, $a3, $58, $a7, $4e, $a1, $01, $58, $58, $5c, $5e, $62, $aa, $5c, $01
	db $54, $a7, $4a, $a1, $4a, $4e, $54, $50, $4e, $4a, $aa, $4e, $01, $40, $a7, $40
	db $a1, $40, $3e, $40, $44, $46, $4a, $a4, $4e, $a3, $01, $aa, $4e, $4a, $4e, $aa
	db $5e, $01, $5c, $a3, $58, $aa, $01, $4e, $4e, $4e, $46, $58, $5a, $01, $5e, $a3
	db $62, $aa, $01, $62, $66, $68, $6c, $68, $a5, $66, $9d, $40, $21, $40, $a2, $01
	db $ad, $4e, $4e, $4e, $aa, $52, $52, $52, $a3, $56, $01, $00, $99, $a3, $40, $aa
	db $40, $40, $40, $a3, $3c, $aa, $3c, $3c, $3c, $a3, $38, $aa, $38, $38, $38, $3c
	db $3c, $3c, $3c, $38, $3c, $9b, $02, $a3, $40, $aa, $40, $40, $40, $a3, $40, $aa
	db $36, $36, $36, $9c, $00, $a3, $28, $aa, $28, $28, $24, $a3, $28, $28, $24, $aa
	db $24, $24, $20, $a3, $24, $24, $20, $aa, $20, $20, $1e, $a3, $20, $20, $2e, $aa
	db $2e, $2e, $2a, $a3, $2e, $2e, $00, $2a, $aa, $2a, $2a, $28, $a3, $2a, $aa, $2a
	db $2a, $2a, $a3, $28, $aa, $28, $28, $24, $a3, $28, $aa, $28, $28, $28, $9b, $02
	db $a3, $2c, $aa, $2c, $2c, $2c, $9c, $a3, $36, $aa, $40, $40, $40, $9a, $a3, $44
	db $99, $a2, $22, $26, $00, $a3, $2a, $aa, $42, $42, $40, $a3, $42, $aa, $42, $42
	db $42, $00, $9a, $a3, $40, $3e, $a4, $3c, $a3, $3a, $32, $99, $a3, $36, $00, $aa
	db $36, $4e, $4a, $46, $44, $40, $a3, $44, $40, $01, $20, $aa, $38, $40, $46, $a3
	db $50, $aa, $20, $20, $20, $a3, $1e, $aa, $36, $3c, $44, $a3, $4e, $aa, $36, $36
	db $36, $9b, $03, $a3, $28, $aa, $28, $28, $28, $9c, $a6, $28, $28, $a2, $24, $a3
	db $20, $aa, $20, $28, $2e, $a3, $38, $aa, $20, $20, $20, $a3, $2a, $aa, $2a, $32
	db $38, $a3, $42, $aa, $2a, $2a, $2a, $a3, $1e, $aa, $4a, $4a, $4a, $a3, $4a, $aa
	db $1e, $1e, $1e, $a3, $1e, $aa, $58, $58, $58, $5c, $38, $36, $32, $2e, $2c, $00
	db $00, $3a, $4a, $63, $57, $8d, $57, $a7, $57, $c3, $57, $19, $6f, $d3, $57, $d3
	db $57, $19, $6f, $f8, $57, $16, $58, $19, $6f, $f8, $57, $a8, $6f, $fb, $6e, $f8
	db $57, $1e, $6f, $f8, $57, $16, $58, $a5, $6f, $e2, $6f, $19, $6f, $f8, $57, $f8
	db $57, $ff, $ff, $69, $57, $ec, $6f, $6f, $58, $23, $6f, $8e, $58, $ec, $6f, $ec
	db $6f, $28, $6f, $8e, $58, $e2, $6f, $ec, $6f, $1b, $59, $ff, $ff, $91, $57, $d6
	db $6e, $26, $59, $ec, $6e, $33, $59, $7f, $59, $ec, $6f, $f2, $6f, $e2, $6f, $7f
	db $59, $e2, $6f, $ec, $6f, $ec, $6f, $ff, $ff, $ab, $57, $94, $59, $a1, $59, $b8
	db $59, $c2, $59, $b8, $59, $d9, $59, $ff, $ff, $c5, $57, $9d, $33, $00, $80, $9b
	db $04, $a2, $4e, $a1, $4e, $4e, $9c, $9b, $04, $a2, $52, $a1, $52, $52, $9c, $9b
	db $04, $a2, $54, $a1, $54, $54, $9c, $9b, $04, $a2, $52, $a1, $52, $52, $9c, $00
	db $9b, $04, $a1, $28, $36, $2e, $36, $9c, $9b, $04, $28, $3a, $32, $3a, $9c, $9b
	db $04, $28, $3c, $36, $3c, $9c, $9b, $04, $28, $3a, $32, $3a, $9c, $00, $9b, $04
	db $20, $36, $2e, $36, $9c, $9b, $04, $24, $32, $2c, $32, $9c, $9b, $02, $24, $36
	db $2e, $36, $9c, $9b, $02, $28, $3a, $32, $3a, $9c, $9b, $04, $2c, $3e, $36, $3e
	db $9c, $9b, $04, $28, $36, $2e, $36, $9c, $9b, $04, $2a, $38, $32, $38, $9c, $9b
	db $04, $28, $36, $2e, $36, $9c, $9b, $04, $22, $36, $2e, $36, $9c, $9b, $04, $2a
	db $38, $32, $38, $9c, $a1, $36, $40, $44, $4a, $a3, $4e, $a4, $01, $9d, $50, $26
	db $01, $a4, $4e, $4a, $46, $4a, $00, $9d, $40, $26, $41, $a3, $40, $a7, $36, $a2
	db $40, $a1, $40, $44, $46, $4a, $a5, $4e, $a3, $58, $a7, $4e, $a2, $58, $a1, $58
	db $5c, $5e, $62, $a5, $66, $00, $a6, $40, $a1, $36, $a7, $36, $a2, $40, $a1, $40
	db $44, $46, $4a, $a7, $4e, $a1, $52, $54, $a6, $52, $4e, $a2, $4a, $a6, $4e, $a1
	db $40, $a5, $58, $a2, $01, $4e, $5e, $5c, $5e, $62, $66, $a1, $58, $66, $a3, $70
	db $a2, $01, $66, $62, $5e, $62, $a1, $54, $62, $a3, $6c, $a2, $01, $62, $5e, $5c
	db $a6, $5e, $a1, $4e, $a3, $4e, $a2, $01, $ad, $4a, $4e, $4a, $a2, $46, $4a, $a5
	db $4e, $a6, $40, $a1, $36, $a7, $36, $a2, $40, $a1, $40, $44, $46, $4a, $a7, $4e
	db $a1, $50, $54, $a6, $50, $4e, $a2, $4a, $a6, $46, $a1, $40, $a7, $4e, $a2, $46
	db $58, $4e, $a7, $5e, $a2, $5c, $58, $5c, $5e, $62, $a2, $66, $a1, $62, $66, $a3
	db $68, $a2, $01, $a6, $6c, $68, $66, $5c, $a2, $5e, $a6, $62, $5e, $a2, $5c, $a5
	db $58, $70, $00, $9d, $56, $00, $80, $9b, $04, $a4, $01, $8c, $9c, $00, $9b, $1f
	db $a2, $40, $a1, $40, $40, $9c, $01, $1a, $16, $14, $00, $99, $9b, $02, $a3, $28
	db $a4, $28, $a3, $28, $9c, $28, $a4, $28, $a3, $36, $32, $a4, $32, $a2, $32, $36
	db $a3, $38, $a4, $38, $a3, $38, $3c, $a4, $3c, $a3, $3c, $2e, $2e, $32, $32, $36
	db $a4, $36, $a1, $36, $32, $2e, $2c, $a3, $28, $a4, $28, $a3, $28, $2a, $a4, $2a
	db $a3, $2a, $28, $a4, $28, $a3, $24, $22, $a4, $22, $a3, $22, $2a, $a4, $2a, $a3
	db $2a, $36, $01, $01, $9a, $1e, $00, $a6, $28, $36, $a2, $28, $a6, $24, $32, $a2
	db $24, $a6, $20, $2e, $a2, $20, $a6, $24, $32, $a2, $24, $00, $9b, $1f, $a2, $0b
	db $a1, $0b, $0b, $9c, $15, $15, $15, $15, $00, $9b, $0d, $a2, $15, $a1, $15, $15
	db $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $15, $15, $15, $15, $9c, $00
	db $a1, $15, $15, $15, $15, $a3, $15, $a4, $01, $00, $9b, $17, $a2, $15, $a1, $15
	db $15, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $15, $15, $15, $15, $9c
	db $00, $9b, $0c, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $a2, $15, $a1
	db $15, $15, $15, $15, $15, $15, $9c, $00, $00, $76, $4a, $fb, $59, $01, $5a, $07
	db $5a, $00, $00, $0f, $5a, $ff, $ff, $fb, $59, $3f, $5a, $ff, $ff, $01, $5a, $c7
	db $6e, $7a, $5a, $ff, $ff, $07, $5a, $9d, $44, $00, $80, $98, $9b, $02, $a3, $01
	db $a2, $46, $a1, $88, $88, $a3, $01, $a2, $44, $a1, $88, $88, $9c, $9d, $24, $00
	db $80, $a3, $01, $a2, $64, $62, $60, $64, $5e, $60, $5c, $60, $5a, $5c, $58, $56
	db $a4, $01, $97, $a1, $88, $88, $00, $9d, $50, $84, $00, $a6, $70, $a1, $66, $a2
	db $60, $58, $a3, $5a, $a1, $68, $62, $5a, $50, $a2, $4e, $a1, $66, $60, $a2, $58
	db $4e, $54, $a1, $50, $54, $a3, $4e, $9d, $24, $00, $00, $a2, $4c, $4e, $68, $66
	db $64, $66, $62, $64, $60, $62, $5e, $60, $a1, $5c, $5e, $5a, $5c, $a3, $01, $a7
	db $01, $00, $9b, $02, $99, $a2, $40, $4c, $56, $4c, $36, $4a, $54, $4a, $9c, $a5
	db $01, $01, $a7, $01, $00, $00, $49, $4a, $98, $5a, $b2, $5a, $c4, $5a, $d6, $5a
	db $ab, $6f, $df, $6f, $32, $6f, $f9, $5a, $2d, $6f, $f9, $5a, $a5, $6f, $e0, $5a
	db $ab, $6f, $e0, $5a, $e2, $6f, $ff, $ff, $98, $5a, $32, $6f, $21, $5b, $2d, $6f
	db $28, $5b, $00, $5b, $00, $5b, $e2, $6f, $ff, $ff, $b2, $5a, $c2, $6e, $e2, $6f
	db $2f, $5b, $45, $5b, $2f, $5b, $45, $5b, $e2, $6f, $ff, $ff, $c4, $5a, $68, $5b
	db $5a, $5b, $68, $5b, $ff, $ff, $d6, $5a, $9d, $33, $00, $80, $9b, $04, $a1, $58
	db $56, $54, $52, $50, $4e, $4c, $4a, $48, $4a, $4c, $4e, $50, $52, $54, $56, $9c
	db $00, $9b, $04, $a1, $46, $44, $9c, $00, $9d, $40, $81, $80, $a7, $58, $a2, $4e
	db $58, $5c, $60, $66, $a7, $64, $a2, $66, $a4, $68, $a7, $58, $a2, $4e, $58, $5c
	db $60, $66, $a7, $64, $a2, $66, $a4, $80, $00, $9b, $0c, $a1, $58, $56, $9c, $00
	db $9b, $04, $a1, $58, $56, $9c, $00, $99, $a3, $28, $a2, $36, $a3, $28, $a2, $28
	db $2a, $38, $a3, $28, $a2, $36, $a3, $28, $a2, $28, $24, $26, $00, $a3, $28, $a2
	db $36, $a3, $28, $a2, $28, $2a, $38, $a3, $28, $a2, $36, $a3, $28, $a2, $28, $36
	db $40, $00, $9b, $08, $a2, $29, $29, $29, $29, $a3, $ff, $a2, $29, $29, $9c, $00
	db $a3, $29, $a2, $29, $29, $a3, $ff, $a2, $29, $29, $a2, $29, $29, $29, $29, $a3
	db $ff, $a2, $29, $29, $00, $00, $76, $4a, $88, $5b, $94, $5b, $9c, $5b, $a8, $5b
	db $e2, $6f, $ae, $5b, $ae, $5b, $be, $5b, $ff, $ff, $8a, $5b, $d3, $5b, $f4, $5b
	db $ff, $ff, $96, $5b, $e2, $6f, $ec, $6e, $26, $5c, $44, $5c, $ff, $ff, $9e, $5b
	db $61, $5c, $ff, $ff, $a8, $5b, $9d, $23, $00, $80, $9b, $20, $a0, $5e, $62, $9c
	db $9b, $20, $62, $64, $9c, $00, $9b, $20, $5e, $54, $9c, $9b, $20, $5c, $52, $9c
	db $9b, $20, $5e, $50, $9c, $9b, $20, $5c, $52, $9c, $00, $9d, $81, $82, $00, $a2
	db $10, $1e, $a1, $24, $a2, $26, $a1, $28, $a7, $01, $a1, $0c, $0e, $a2, $10, $a1
	db $1e, $a2, $24, $26, $a1, $28, $a7, $01, $a1, $0c, $0e, $00, $9d, $40, $00, $81
	db $9b, $02, $a4, $58, $4e, $a8, $4e, $a0, $58, $56, $58, $5c, $5e, $5c, $5e, $62
	db $a6, $66, $68, $a2, $6c, $a8, $70, $a2, $70, $6c, $a6, $68, $62, $a2, $5a, $9c
	db $9d, $30, $00, $01, $a5, $58, $4e, $50, $52, $54, $54, $56, $56, $00, $99, $a2
	db $28, $36, $a1, $3c, $a2, $3e, $a1, $40, $a7, $01, $a1, $24, $26, $a2, $28, $a1
	db $36, $a2, $3c, $3e, $a1, $40, $a7, $01, $a1, $26, $28, $00, $a2, $2a, $38, $a1
	db $3e, $a2, $40, $a1, $42, $a7, $01, $a1, $26, $28, $a2, $2a, $a1, $38, $a2, $3e
	db $40, $a1, $42, $a7, $01, $a1, $24, $26, $00, $9b, $04, $a1, $29, $9c, $ff, $9b
	db $05, $29, $9c, $ff, $9b, $05, $29, $9c, $00, $04, $58, $4a, $7c, $5c, $86, $5c
	db $8c, $4a, $00, $00, $ae, $6f, $fb, $6f, $8e, $5c, $ff, $ff, $80, $5c, $b3, $6f
	db $8e, $5c, $ff, $ff, $86, $5c, $a2, $5c, $3c, $4a, $52, $58, $5c, $5e, $40, $4e
	db $54, $5c, $5e, $62, $44, $52, $58, $70, $6c, $62, $36, $44, $4a, $5e, $5c, $5c
	db $40, $4e, $54, $58, $5c, $5e, $40, $4c, $54, $5c, $5e, $58, $32, $40, $46, $4c
	db $54, $52, $4a, $4e, $52, $54, $58, $5c, $3c, $4a, $52, $58, $5c, $5e, $40, $4e
	db $54, $5c, $5e, $62, $44, $52, $58, $74, $70, $70, $36, $44, $6e, $68, $66, $62
	db $40, $4e, $54, $5e, $5c, $5c, $32, $40, $46, $58, $5c, $54, $46, $54, $5c, $5e
	db $74, $70, $44, $52, $58, $5c, $6a, $66, $40, $4e, $54, $58, $66, $64, $32, $40
	db $46, $4c, $54, $62, $32, $3a, $40, $4a, $52, $a3, $62, $a2, $62, $a7, $7a, $32
	db $00, $00, $76, $4a, $14, $5d, $22, $5d, $2c, $5d, $38, $5d, $df, $6f, $a5, $6f
	db $3e, $5d, $ab, $6f, $3e, $5d, $ff, $ff, $16, $5d, $df, $6f, $60, $5d, $60, $5d
	db $ff, $ff, $24, $5d, $df, $6f, $c2, $6e, $7b, $5d, $7b, $5d, $ff, $ff, $2e, $5d
	db $a5, $5d, $ff, $ff, $38, $5d, $9d, $44, $00, $80, $a2, $01, $a1, $36, $36, $a2
	db $34, $a3, $01, $a1, $36, $36, $a2, $38, $a3, $01, $a1, $36, $36, $a2, $34, $a3
	db $01, $a1, $36, $34, $a2, $36, $01, $00, $9d, $64, $00, $00, $9b, $02, $a2, $40
	db $36, $a1, $40, $44, $48, $4a, $a2, $4e, $a0, $56, $a1, $58, $a0, $01, $a2, $4e
	db $01, $9c, $00, $99, $a2, $28, $a1, $40, $40, $a2, $3e, $a1, $36, $36, $a2, $28
	db $a1, $40, $40, $a2, $42, $a1, $2a, $2a, $a2, $28, $a1, $40, $40, $a2, $3e, $a1
	db $36, $36, $a2, $28, $a1, $40, $3e, $a2, $40, $a1, $28, $28, $00, $a2, $29, $a1
	db $29, $29, $a2, $ff, $a1, $29, $29, $a1, $29, $29, $29, $29, $a2, $ff, $1a, $00
	db $00, $3a, $4a, $c3, $5d, $d3, $5d, $e1, $5d, $00, $00, $f1, $5d, $01, $70, $a5
	db $6f, $f6, $5d, $a2, $6f, $f6, $5d, $ff, $ff, $c7, $5d, $b8, $6f, $a5, $6f, $f6
	db $5d, $a2, $6f, $f6, $5d, $ff, $ff, $d3, $5d, $fb, $6f, $e6, $6e, $a5, $6f, $f6
	db $5d, $a2, $6f, $f6, $5d, $ff, $ff, $e3, $5d, $9d, $44, $00, $80, $00, $a2, $30
	db $34, $3a, $40, $48, $4c, $52, $58, $60, $64, $6a, $70, $78, $7c, $82, $88, $00
	db $00, $3a, $4a, $13, $5e, $19, $5e, $1f, $5e, $00, $00, $5b, $50, $ff, $ff, $13
	db $5e, $d9, $50, $ff, $ff, $19, $5e, $c2, $6e, $7e, $51, $ff, $ff, $1f, $5e, $00
	db $2b, $4a, $32, $5e, $52, $5e, $5e, $5e, $00, $00, $a5, $6f, $0f, $6f, $6e, $5e
	db $6e, $5e, $14, $6f, $6e, $5e, $6e, $5e, $a2, $6f, $0f, $6f, $6e, $5e, $6e, $5e
	db $14, $6f, $6e, $5e, $6e, $5e, $ff, $ff, $32, $5e, $78, $5e, $91, $5e, $78, $5e
	db $91, $5e, $ff, $ff, $52, $5e, $ec, $6e, $a0, $5e, $a0, $5e, $f6, $6e, $a0, $5e
	db $a0, $5e, $ff, $ff, $5e, $5e, $9b, $02, $a2, $1c, $20, $20, $9c, $1c, $20, $00
	db $9d, $70, $21, $40, $a7, $48, $a1, $44, $48, $a7, $4a, $a1, $48, $4a, $a7, $4c
	db $a1, $5c, $58, $a2, $4c, $64, $a3, $64, $00, $9d, $20, $21, $81, $a2, $4c, $64
	db $a8, $64, $a2, $64, $7c, $a8, $7c, $00, $99, $a7, $28, $28, $a3, $28, $00, $00
	db $2b, $4a, $b2, $5e, $ba, $5e, $c2, $5e, $00, $00, $cc, $5e, $d1, $5e, $db, $5e
	db $00, $00, $d6, $5e, $db, $5e, $d1, $5e, $00, $00, $d6, $6e, $04, $70, $db, $5e
	db $fb, $6f, $00, $00, $9d, $26, $00, $80, $00, $a3, $01, $a1, $01, $00, $9d, $67
	db $00, $81, $00, $96, $a1, $70, $6e, $66, $60, $58, $56, $4e, $48, $74, $70, $6a
	db $62, $5c, $58, $52, $4a, $78, $74, $6e, $66, $60, $5c, $56, $4e, $7a, $78, $70
	db $6a, $62, $60, $58, $52, $a2, $36, $44, $4a, $4e, $56, $5c, $62, $66, $a8, $7e
	db $95, $00, $00, $3a, $4a, $15, $5f, $1b, $5f, $21, $5f, $00, $00, $29, $5f, $ff
	db $ff, $12, $54, $5c, $5f, $ff, $ff, $20, $54, $c2, $6e, $85, $5f, $ff, $ff, $30
	db $54, $9d, $70, $21, $81, $aa, $01, $36, $40, $a3, $48, $aa, $48, $48, $44, $a3
	db $48, $aa, $01, $3c, $46, $a3, $4e, $aa, $4e, $4e, $4a, $a3, $4e, $a3, $01, $9b
	db $02, $a3, $4c, $a2, $01, $a1, $4c, $4c, $9c, $a8, $4a, $9d, $40, $21, $80, $aa
	db $32, $30, $2c, $00, $9d, $90, $21, $81, $aa, $36, $40, $48, $a8, $4e, $aa, $3c
	db $46, $4e, $a8, $54, $aa, $4e, $54, $5e, $9b, $02, $a3, $5a, $a2, $01, $a1, $5a
	db $5a, $9c, $a8, $5c, $9d, $60, $21, $80, $aa, $44, $40, $3e, $00, $99, $aa, $01
	db $01, $4e, $9a, $a3, $58, $99, $aa, $40, $40, $3c, $9a, $a3, $40, $99, $aa, $01
	db $01, $54, $9a, $a3, $5e, $99, $aa, $46, $46, $42, $9a, $a3, $46, $01, $99, $aa
	db $2a, $28, $2a, $34, $32, $34, $3c, $3a, $3c, $42, $4c, $54, $56, $52, $56, $58
	db $56, $52, $a3, $4e, $aa, $1e, $1e, $1e, $00, $00, $58, $4a, $cc, $5f, $d4, $5f
	db $8c, $4a, $00, $00, $37, $6f, $dc, $5f, $ff, $ff, $cc, $5f, $3c, $6f, $fe, $5f
	db $ff, $ff, $d4, $5f, $a2, $32, $3a, $40, $3a, $32, $36, $3e, $44, $30, $36, $3e
	db $44, $22, $28, $30, $28, $2c, $32, $3a, $32, $1e, $26, $2c, $26, $28, $2c, $32
	db $36, $28, $30, $36, $3c, $00, $a4, $70, $a2, $01, $6e, $74, $a4, $66, $a2, $01
	db $70, $58, $5c, $60, $62, $60, $62, $a3, $56, $6a, $a5, $66, $a2, $01, $00, $00
	db $2b, $4a, $22, $60, $38, $60, $8c, $4a, $00, $00, $59, $60, $65, $60, $4e, $60
	db $4e, $60, $59, $60, $6a, $60, $4e, $60, $4e, $60, $4e, $60, $ff, $ff, $22, $60
	db $7e, $60, $8a, $60, $6f, $60, $6f, $60, $7e, $60, $90, $60, $6f, $60, $6f, $60
	db $6f, $60, $ff, $ff, $38, $60, $9b, $0c, $ad, $01, $01, $01, $01, $9c, $a5, $01
	db $00, $9d, $40, $41, $80, $9b, $02, $a3, $28, $32, $32, $9c, $00, $a3, $30, $26
	db $01, $00, $a3, $34, $2a, $01, $00, $9d, $42, $00, $80, $9b, $0c, $ad, $46, $44
	db $46, $01, $9c, $a5, $01, $00, $9d, $40, $41, $80, $9b, $02, $a3, $30, $3a, $3a
	db $9c, $00, $a3, $38, $2e, $a3, $01, $00, $a3, $3c, $32, $a3, $01, $00, $00, $49
	db $4a, $8c, $4a, $a1, $60, $b1, $60, $00, $00, $c1, $60, $d9, $60, $d9, $60, $fa
	db $60, $b3, $6f, $0f, $61, $01, $70, $00, $00, $cc, $6e, $1d, $61, $29, $61, $d6
	db $6e, $4c, $61, $59, $61, $0f, $61, $00, $00, $9d, $43, $00, $80, $a4, $01, $a2
	db $01, $a1, $78, $74, $a2, $78, $a3, $01, $a1, $7a, $78, $a2, $7a, $a3, $01, $01
	db $00, $9d, $55, $00, $00, $9e, $2b, $4a, $9b, $02, $a1, $66, $68, $66, $64, $62
	db $64, $62, $64, $9c, $a2, $66, $7e, $66, $a1, $66, $68, $6a, $6c, $6a, $68, $a3
	db $66, $00, $9d, $35, $00, $40, $9b, $02, $a1, $66, $68, $66, $64, $62, $64, $62
	db $64, $9c, $a5, $01, $a3, $01, $00, $9e, $3a, $4a, $a0, $7e, $7a, $76, $72, $6e
	db $6a, $a3, $66, $01, $00, $a4, $01, $a2, $01, $99, $a3, $6c, $01, $6e, $01, $01
	db $00, $9e, $2b, $4a, $99, $9b, $02, $a2, $40, $4e, $36, $4e, $9c, $9b, $02, $42
	db $50, $38, $50, $9c, $9b, $02, $46, $54, $3c, $54, $9c, $4a, $58, $40, $58, $4a
	db $58, $48, $44, $00, $9b, $02, $a2, $40, $4e, $36, $4e, $9c, $a5, $01, $a3, $01
	db $00, $9e, $3a, $4a, $a1, $01, $00, $00, $49, $4a, $6a, $61, $76, $61, $82, $61
	db $00, $00, $41, $6f, $8c, $61, $46, $6f, $9a, $61, $9a, $61, $00, $00, $41, $6f
	db $c8, $61, $46, $6f, $d6, $61, $d6, $61, $00, $00, $f1, $6e, $04, $62, $11, $62
	db $11, $62, $00, $00, $a4, $01, $a1, $26, $2a, $2e, $30, $34, $01, $34, $01, $a5
	db $36, $00, $a4, $01, $a2, $34, $38, $3c, $3e, $a7, $42, $a2, $46, $42, $3e, $3c
	db $38, $a4, $34, $a2, $3c, $3e, $42, $4c, $a7, $54, $a2, $56, $54, $50, $4c, $4a
	db $a7, $4c, $a1, $42, $42, $9b, $02, $a2, $4c, $a1, $42, $42, $9c, $a5, $4c, $00
	db $a5, $01, $a1, $40, $44, $48, $4a, $4e, $01, $4e, $01, $a4, $50, $00, $a5, $01
	db $a2, $4e, $52, $56, $58, $a7, $5c, $a2, $60, $5c, $58, $56, $52, $a4, $4e, $a2
	db $56, $58, $5c, $66, $a7, $6e, $a2, $70, $6e, $6a, $66, $64, $a7, $66, $a1, $5c
	db $5c, $9b, $02, $a2, $66, $a1, $5c, $5c, $9c, $a4, $66, $00, $9a, $a1, $24, $28
	db $2c, $2e, $32, $01, $32, $01, $ae, $34, $00, $a2, $32, $36, $3a, $3c, $a7, $40
	db $a2, $44, $40, $3c, $3a, $36, $a4, $32, $a2, $3a, $3c, $40, $4a, $a7, $52, $a2
	db $54, $52, $4e, $4a, $48, $a3, $4a, $a2, $01, $99, $a1, $40, $40, $9b, $02, $a2
	db $4a, $a1, $40, $40, $9c, $9a, $ae, $4a, $00, $00, $49, $4a, $8c, $4a, $4c, $62
	db $5c, $62, $00, $00, $6c, $62, $71, $62, $23, $6f, $71, $62, $82, $62, $37, $6f
	db $ba, $62, $00, $00, $d6, $6e, $c7, $62, $cc, $6e, $c7, $62, $d9, $62, $d6, $6e
	db $00, $63, $00, $00, $9d, $40, $26, $01, $00, $a1, $90, $a6, $90, $a1, $88, $a6
	db $88, $a1, $7e, $a6, $7e, $a1, $88, $a6, $88, $00, $a6, $4e, $a1, $4e, $a3, $48
	db $a6, $4a, $a1, $4a, $a3, $42, $a1, $4e, $a2, $4e, $a1, $52, $4e, $48, $40, $48
	db $a2, $4a, $90, $a3, $90, $a6, $4e, $a1, $4e, $a3, $48, $a6, $58, $a1, $58, $a3
	db $50, $a1, $4e, $a2, $4e, $a1, $52, $a2, $4e, $a1, $58, $60, $a2, $62, $90, $a3
	db $90, $00, $a6, $4e, $a1, $4e, $a3, $48, $a6, $4a, $a1, $4a, $a3, $42, $00, $99
	db $a1, $8e, $a6, $8e, $a1, $86, $a6, $86, $a1, $7c, $a6, $7c, $a1, $86, $a6, $86
	db $00, $9b, $02, $a2, $28, $a1, $30, $36, $a2, $1e, $a1, $30, $36, $a2, $2a, $a1
	db $32, $38, $a2, $20, $a1, $32, $38, $a2, $28, $a1, $30, $36, $a2, $1e, $a1, $30
	db $36, $a2, $2a, $8e, $8e, $1e, $9c, $00, $a2, $28, $a1, $30, $36, $a2, $1e, $a1
	db $30, $36, $a2, $2a, $a1, $32, $38, $a2, $20, $a1, $32, $38, $00, $00, $2b, $4a
	db $20, $63, $3a, $63, $50, $63, $64, $63, $ec, $6f, $2d, $6f, $6e, $63, $4b, $6f
	db $7f, $63, $0f, $6f, $a5, $6f, $94, $63, $5a, $6f, $a8, $6f, $94, $63, $ff, $ff
	db $2a, $63, $2d, $6f, $a3, $63, $b2, $63, $4b, $6f, $c1, $63, $50, $6f, $d6, $63
	db $55, $6f, $d6, $63, $ff, $ff, $44, $63, $c7, $6e, $e5, $63, $e2, $6f, $c2, $6e
	db $f4, $63, $c2, $6e, $04, $64, $04, $64, $ff, $ff, $5a, $63, $20, $64, $28, $64
	db $2e, $64, $ff, $ff, $68, $63, $a8, $01, $a1, $46, $48, $5e, $60, $a8, $01, $a1
	db $48, $4a, $60, $62, $a8, $01, $00, $9b, $05, $a1, $70, $72, $70, $6e, $9c, $70
	db $6e, $6c, $6a, $68, $66, $64, $62, $60, $5e, $5c, $5a, $00, $9b, $04, $a2, $50
	db $4a, $4a, $50, $4a, $4a, $50, $4a, $50, $4a, $9c, $00, $a5, $01, $9b, $08, $a1
	db $1e, $20, $9c, $a3, $1e, $ae, $01, $a5, $01, $00, $a1, $52, $54, $6a, $6c, $a8
	db $01, $a1, $54, $56, $6c, $6e, $a8, $01, $00, $9b, $05, $a1, $58, $5a, $58, $56
	db $9c, $58, $56, $54, $52, $50, $4e, $4c, $4a, $48, $46, $44, $42, $00, $9b, $04
	db $a2, $58, $01, $01, $56, $01, $01, $58, $01, $5a, $01, $9c, $00, $9a, $9b, $10
	db $a1, $28, $2a, $9c, $99, $a3, $2c, $ae, $01, $a5, $01, $00, $a5, $01, $99, $9b
	db $04, $a2, $40, $9c, $28, $28, $a1, $28, $28, $2a, $28, $00, $99, $9b, $04, $a1
	db $4a, $4a, $32, $32, $a2, $32, $a1, $4a, $4a, $32, $32, $a2, $32, $a1, $4a, $4a
	db $32, $32, $4a, $4a, $32, $32, $9c, $00, $9b, $04, $a5, $01, $9c, $a8, $01, $00
	db $9b, $04, $a5, $01, $9c, $00, $9b, $02, $a1, $15, $15, $15, $15, $a2, $01, $9c
	db $9b, $08, $a1, $15, $9c, $00, $00, $67, $4a, $8c, $4a, $49, $64, $53, $64, $5b
	db $64, $37, $6f, $61, $64, $80, $64, $ff, $ff, $49, $64, $ec, $6e, $b5, $64, $ff
	db $ff, $53, $64, $d0, $64, $ff, $ff, $5b, $64, $a4, $01, $a7, $01, $ad, $5a, $5e
	db $5a, $a3, $58, $01, $a7, $01, $a1, $4a, $54, $a3, $4e, $01, $a7, $01, $ad, $42
	db $46, $42, $a3, $40, $01, $a7, $01, $00, $9d, $40, $21, $01, $ad, $4e, $50, $52
	db $a6, $54, $a1, $48, $a7, $54, $ad, $52, $54, $52, $a2, $4e, $4a, $a6, $4e, $a1
	db $40, $a4, $4e, $a2, $01, $ad, $4e, $50, $52, $a6, $54, $a1, $48, $a7, $54, $ad
	db $52, $54, $52, $a2, $4e, $4a, $a6, $4e, $a1, $40, $a8, $4e, $00, $99, $9b, $04
	db $a6, $28, $a1, $30, $a2, $36, $28, $2a, $32, $a3, $38, $a6, $28, $a1, $30, $a2
	db $36, $28, $1e, $2a, $a3, $32, $9c, $00, $9b, $03, $a2, $15, $ad, $15, $15, $15
	db $9c, $9b, $04, $a1, $15, $9c, $00, $00, $2b, $4a, $ea, $64, $f0, $64, $f6, $64
	db $00, $00, $50, $6f, $fc, $64, $00, $00, $50, $6f, $03, $65, $00, $00, $ec, $6e
	db $0a, $65, $00, $00, $a2, $52, $54, $56, $a8, $58, $00, $a2, $5c, $5e, $60, $a8
	db $62, $00, $99, $a2, $30, $32, $34, $9a, $a8, $36, $00, $00, $58, $4a, $1e, $65
	db $5a, $65, $a2, $65, $ec, $65, $cb, $6f, $bd, $6f, $44, $66, $49, $66, $5b, $66
	db $78, $66, $a8, $66, $20, $70, $c6, $66, $04, $67, $09, $67, $07, $70, $1c, $70
	db $e2, $6f, $1d, $67, $58, $67, $58, $67, $bf, $67, $58, $67, $58, $67, $bf, $67
	db $58, $67, $58, $67, $ff, $67, $1f, $68, $20, $70, $30, $68, $24, $70, $4d, $68
	db $00, $00, $cb, $6f, $69, $6f, $5c, $68, $64, $6f, $72, $68, $73, $6f, $5c, $68
	db $5f, $6f, $86, $68, $99, $68, $6e, $6f, $9e, $68, $20, $70, $b5, $68, $cc, $5e
	db $01, $70, $09, $67, $fb, $6f, $1c, $70, $e2, $6f, $d1, $68, $0a, $69, $0a, $69
	db $5c, $69, $0a, $69, $0a, $69, $5c, $69, $0a, $69, $0a, $69, $9c, $69, $b5, $69
	db $20, $70, $c6, $69, $24, $70, $db, $69, $00, $00, $cb, $6f, $fb, $6f, $ea, $69
	db $5c, $68, $ef, $69, $72, $68, $f4, $69, $d6, $6e, $49, $66, $5b, $66, $df, $6f
	db $fe, $69, $03, $6a, $20, $70, $2a, $6a, $d6, $6e, $04, $70, $09, $67, $fe, $6f
	db $1c, $70, $e2, $6f, $51, $6a, $65, $6a, $65, $6a, $c3, $6a, $65, $6a, $65, $6a
	db $c3, $6a, $65, $6a, $65, $6a, $0d, $6b, $2a, $6b, $20, $70, $36, $6b, $24, $70
	db $4c, $6b, $00, $00, $d3, $6f, $57, $6b, $20, $70, $5f, $6b, $1c, $70, $67, $6b
	db $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b
	db $67, $6b, $67, $6b, $78, $6b, $78, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b
	db $67, $6b, $67, $6b, $67, $6b, $67, $6b, $78, $6b, $78, $6b, $67, $6b, $67, $6b
	db $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $67, $6b, $83, $6b
	db $20, $70, $83, $6b, $83, $6b, $24, $70, $91, $6b, $00, $00, $9d, $56, $00, $80
	db $00, $a1, $30, $3e, $44, $4c, $4e, $56, $5c, $64, $66, $64, $5c, $56, $4e, $4c
	db $44, $3e, $00, $a1, $40, $44, $48, $4e, $58, $5c, $60, $66, $70, $66, $60, $5c
	db $58, $4e, $48, $44, $40, $44, $48, $4e, $58, $5c, $60, $66, $a3, $70, $01, $00
	db $9d, $42, $00, $80, $a1, $36, $34, $36, $2c, $30, $34, $36, $3a, $3e, $3a, $3e
	db $36, $3a, $3e, $40, $44, $9d, $52, $00, $80, $4e, $4c, $4e, $44, $56, $52, $56
	db $4e, $9d, $62, $00, $80, $5c, $56, $4e, $66, $64, $5e, $56, $52, $a3, $4e, $00
	db $9d, $60, $21, $80, $a3, $52, $4e, $5c, $a7, $5c, $a3, $60, $a2, $5c, $58, $52
	db $a3, $56, $a2, $01, $58, $56, $52, $4e, $5c, $a3, $58, $a4, $01, $00, $9d, $52
	db $00, $80, $a3, $01, $9b, $02, $a1, $44, $4a, $52, $58, $60, $58, $52, $4a, $9c
	db $9b, $02, $36, $3e, $44, $4a, $52, $4a, $44, $3e, $9c, $40, $44, $48, $4e, $58
	db $4e, $48, $44, $40, $44, $48, $4e, $58, $4e, $48, $40, $3e, $42, $46, $4c, $56
	db $5a, $5e, $64, $6e, $64, $5e, $5a, $56, $4c, $46, $3e, $00, $9d, $47, $00, $80
	db $00, $a1, $1e, $22, $26, $2c, $32, $3a, $3e, $44, $4a, $52, $56, $5c, $62, $6a
	db $6e, $74, $a4, $7e, $00, $9d, $52, $00, $80, $a4, $01, $a3, $1e, $aa, $1e, $1e
	db $1e, $9d, $72, $00, $80, $a3, $22, $9b, $06, $aa, $22, $9c, $28, $28, $28, $9d
	db $92, $00, $80, $a3, $2c, $aa, $2c, $2c, $2c, $a3, $32, $aa, $32, $32, $3a, $a3
	db $3e, $aa, $36, $36, $36, $a3, $36, $9d, $92, $00, $40, $aa, $36, $3a, $3e, $00
	db $9d, $90, $21, $41, $a3, $30, $aa, $32, $30, $2c, $30, $01, $30, $32, $36, $3a
	db $a3, $3c, $aa, $44, $48, $44, $a3, $42, $aa, $3a, $3e, $42, $a3, $44, $aa, $5c
	db $62, $6a, $70, $38, $3c, $40, $3c, $38, $a3, $36, $aa, $36, $3a, $36, $a3, $32
	db $01, $9d, $77, $00, $80, $9b, $02, $aa, $52, $56, $58, $9c, $56, $4e, $48, $a3
	db $4e, $aa, $52, $56, $58, $58, $5c, $58, $56, $4e, $48, $a3, $4e, $9d, $70, $21
	db $41, $aa, $4a, $4e, $52, $52, $52, $52, $a3, $50, $aa, $50, $54, $50, $a3, $4e
	db $aa, $4e, $52, $4e, $a4, $4a, $00, $9d, $70, $00, $81, $a5, $01, $01, $a8, $4a
	db $aa, $4a, $4e, $4a, $a4, $48, $a3, $4a, $4e, $9d, $90, $26, $80, $aa, $50, $01
	db $54, $a4, $58, $aa, $50, $54, $58, $a8, $58, $aa, $58, $58, $58, $9b, $02, $01
	db $50, $50, $50, $4e, $50, $9c, $a3, $4e, $9d, $70, $21, $40, $aa, $3a, $01, $3a
	db $36, $01, $36, $32, $01, $32, $00, $9d, $80, $21, $41, $aa, $46, $44, $46, $4a
	db $46, $44, $9b, $04, $46, $9c, $44, $46, $4a, $46, $4a, $50, $5a, $62, $68, $5a
	db $5a, $62, $62, $62, $a3, $60, $00, $9d, $70, $21, $41, $a2, $48, $a1, $48, $48
	db $a3, $44, $a2, $44, $a1, $46, $4a, $00, $9d, $70, $21, $41, $a3, $50, $a2, $50
	db $a1, $50, $50, $a2, $5c, $58, $a3, $54, $a3, $60, $a2, $60, $a1, $5c, $60, $a2
	db $62, $66, $68, $62, $00, $a3, $66, $9d, $a0, $21, $40, $a2, $28, $a1, $28, $28
	db $a3, $28, $01, $00, $a2, $01, $60, $64, $a8, $66, $a2, $60, $64, $a8, $66, $a2
	db $64, $60, $56, $a7, $5c, $a5, $60, $a3, $01, $00, $a2, $60, $64, $a8, $66, $a2
	db $5c, $66, $a8, $70, $a2, $6e, $6a, $a5, $6e, $a4, $01, $a2, $01, $00, $a2, $60
	db $64, $a8, $66, $a2, $5c, $66, $a8, $70, $a2, $6e, $6a, $9d, $50, $00, $80, $6e
	db $00, $a5, $6e, $a4, $01, $00, $a8, $01, $a3, $7c, $78, $6e, $a7, $6e, $a5, $70
	db $a2, $82, $7e, $7c, $78, $6e, $6a, $6e, $78, $70, $a3, $01, $00, $a2, $70, $a4
	db $74, $a2, $01, $62, $6a, $74, $a8, $6e, $a2, $01, $66, $a5, $78, $a2, $01, $a7
	db $76, $88, $9d, $60, $00, $80, $a4, $86, $00, $9d, $62, $21, $80, $a3, $01, $01
	db $26, $aa, $26, $26, $26, $9d, $82, $21, $80, $a3, $28, $aa, $28, $28, $28, $32
	db $32, $32, $3a, $3a, $3a, $9d, $a2, $21, $80, $a3, $3e, $aa, $3e, $3e, $3e, $a3
	db $40, $aa, $40, $40, $40, $a3, $44, $aa, $4e, $4e, $4e, $a3, $4e, $aa, $4e, $4e
	db $4e, $00, $9d, $a0, $21, $41, $a3, $40, $36, $aa, $36, $01, $40, $44, $48, $4a
	db $a4, $4e, $aa, $01, $4e, $52, $54, $52, $4e, $a4, $4a, $aa, $01, $4a, $4e, $50
	db $4e, $4a, $a3, $48, $aa, $48, $4a, $48, $a3, $44, $9d, $57, $00, $80, $aa, $01
	db $70, $74, $9b, $02, $a3, $78, $70, $a4, $7e, $9c, $9d, $a0, $21, $41, $aa, $52
	db $56, $58, $58, $5c, $60, $a3, $62, $aa, $62, $66, $62, $a3, $60, $aa, $60, $62
	db $60, $a4, $5c, $00, $9d, $a0, $26, $81, $aa, $58, $01, $5c, $a4, $5e, $aa, $58
	db $01, $5c, $a3, $5e, $aa, $01, $01, $5e, $a6, $5c, $58, $a2, $4e, $a4, $54, $ae
	db $58, $aa, $58, $01, $5c, $a4, $5e, $aa, $58, $5c, $5e, $a8, $68, $aa, $68, $66
	db $5e, $a5, $62, $a3, $62, $9d, $a0, $21, $40, $aa, $4a, $4e, $4a, $48, $4a, $48
	db $44, $48, $44, $00, $9d, $a0, $21, $41, $a4, $58, $aa, $01, $58, $58, $58, $54
	db $58, $a4, $5a, $aa, $01, $5e, $62, $66, $68, $6c, $a3, $70, $00, $9d, $a0, $21
	db $00, $a2, $58, $a1, $4e, $58, $a3, $54, $a2, $54, $a1, $58, $5c, $00, $a3, $5e
	db $a2, $5e, $a1, $58, $5e, $a3, $62, $a1, $62, $66, $68, $6c, $9d, $a0, $00, $01
	db $a5, $70, $00, $9d, $a0, $21, $00, $a3, $78, $a2, $40, $a1, $40, $40, $a3, $40
	db $01, $00, $9d, $a2, $6e, $20, $00, $9d, $92, $6e, $40, $00, $9b, $03, $a5, $01
	db $9c, $a3, $01, $a6, $01, $00, $a8, $01, $a2, $01, $00, $9d, $42, $6e, $20, $99
	db $a2, $48, $56, $5c, $66, $a4, $01, $a2, $3a, $48, $4e, $58, $01, $56, $a1, $52
	db $4e, $4c, $3e, $a2, $48, $56, $5c, $66, $a4, $01, $a2, $3a, $48, $4e, $58, $a3
	db $01, $00, $a3, $01, $9b, $02, $a2, $2c, $a3, $2c, $a2, $2c, $9c, $9b, $02, $a2
	db $1e, $a3, $1e, $a2, $1e, $9c, $9b, $02, $a2, $28, $a3, $28, $a2, $28, $9c, $9b
	db $02, $a2, $26, $a3, $26, $a2, $26, $9c, $00, $9d, $42, $6e, $20, $99, $9b, $06
	db $a3, $1e, $aa, $1e, $1e, $1e, $9c, $a3, $1e, $1e, $22, $26, $00, $99, $a3, $28
	db $aa, $28, $28, $24, $a3, $28, $aa, $28, $28, $28, $a3, $24, $aa, $3c, $3c, $3c
	db $9a, $a3, $3a, $22, $99, $9b, $02, $a3, $2c, $aa, $2c, $2c, $2c, $9c, $a3, $1e
	db $aa, $1e, $1e, $1e, $9a, $a3, $1e, $20, $99, $aa, $22, $40, $48, $52, $48, $40
	db $30, $3e, $44, $4e, $44, $3e, $3a, $40, $48, $52, $48, $40, $30, $3e, $44, $4e
	db $44, $30, $a3, $32, $aa, $32, $32, $32, $a3, $2a, $aa, $2a, $2a, $2a, $1e, $28
	db $2c, $36, $40, $44, $4e, $36, $3a, $3e, $3a, $36, $00, $38, $58, $5e, $68, $5e
	db $58, $50, $58, $5e, $68, $5e, $58, $9b, $02, $50, $54, $5c, $62, $5c, $54, $9c
	db $9b, $02, $4e, $54, $5c, $62, $5c, $54, $9c, $40, $48, $4e, $54, $4e, $48, $40
	db $48, $4e, $54, $4e, $40, $9b, $02, $99, $aa, $32, $40, $46, $50, $58, $5e, $9a
	db $a3, $68, $01, $9c, $99, $9b, $02, $aa, $2a, $42, $42, $42, $46, $4a, $9c, $a3
	db $4e, $1e, $22, $26, $00, $38, $40, $46, $50, $58, $5e, $9a, $a3, $68, $99, $aa
	db $38, $38, $38, $2a, $32, $38, $42, $4a, $50, $9a, $a3, $72, $99, $aa, $2a, $2a
	db $2a, $00, $9b, $02, $a2, $28, $1e, $9c, $9b, $02, $24, $1a, $9c, $00, $9b, $02
	db $a2, $20, $2e, $9c, $9b, $02, $24, $32, $9c, $9b, $02, $28, $1e, $9c, $9b, $02
	db $2a, $20, $9c, $00, $a3, $28, $a2, $28, $a1, $28, $28, $a3, $28, $01, $00, $9b
	db $14, $a5, $01, $9c, $a3, $01, $00, $9b, $06, $a5, $01, $9c, $a3, $01, $00, $9b
	db $03, $a3, $15, $aa, $1a, $1a, $1a, $9c, $aa, $15, $15, $15, $1a, $15, $15, $00
	db $9b, $08, $aa, $29, $29, $29, $1a, $29, $29, $9c, $00, $9b, $02, $a1, $1a, $1a
	db $a3, $1a, $9c, $9b, $04, $a1, $1a, $9c, $00, $a3, $1a, $a2, $1a, $a1, $1a, $1a
	db $a3, $1a, $01, $00, $00, $2b, $4a, $a7, $6b, $b9, $6b, $cb, $6b, $00, $00, $d1
	db $6b, $d6, $6b, $d6, $6b, $41, $6f, $d6, $6b, $78, $6f, $d6, $6b, $ff, $ff, $32
	db $5e, $d1, $6b, $e0, $6b, $e0, $6b, $41, $6f, $e0, $6b, $78, $6f, $e0, $6b, $ff
	db $ff, $52, $5e, $e2, $6f, $ff, $ff, $5e, $5e, $9d, $40, $00, $40, $00, $a1, $34
	db $36, $34, $32, $30, $2e, $30, $32, $00, $a1, $48, $4a, $48, $46, $44, $42, $44
	db $46, $00, $00, $49, $4a, $f5, $6b, $15, $6c, $39, $6c, $59, $6c, $e2, $6f, $77
	db $6c, $81, $6d, $0a, $70, $87, $6f, $7e, $6c, $8c, $6f, $84, $6c, $82, $6f, $8a
	db $6c, $fb, $6c, $61, $6d, $74, $6d, $79, $6d, $ff, $ff, $10, $70, $e2, $6f, $02
	db $6d, $81, $6d, $0a, $70, $7d, $6f, $09, $6d, $91, $6f, $28, $6d, $04, $70, $7c
	db $6d, $48, $6d, $55, $6d, $61, $6d, $04, $70, $74, $6d, $79, $6d, $ff, $ff, $10
	db $70, $e2, $6f, $96, $6f, $81, $6d, $04, $70, $0a, $70, $9c, $6f, $93, $6d, $b5
	db $6d, $d6, $6e, $48, $6d, $55, $6d, $61, $6d, $0a, $70, $79, $6d, $ff, $ff, $10
	db $70, $cb, $6d, $d7, $6d, $d7, $6d, $d7, $6d, $d7, $6d, $ec, $6d, $ec, $6d, $ec
	db $6d, $ec, $6d, $ec, $6d, $ec, $6d, $16, $6e, $1a, $6e, $ff, $ff, $16, $70, $9d
	db $10, $00, $81, $a2, $01, $00, $a4, $90, $82, $86, $78, $00, $a4, $90, $82, $86
	db $01, $00, $9d, $b1, $82, $00, $a2, $10, $10, $9d, $71, $82, $80, $a1, $6e, $60
	db $6e, $78, $a3, $01, $9d, $b1, $82, $00, $a2, $01, $06, $10, $10, $9d, $71, $82
	db $80, $a1, $6e, $60, $6e, $78, $a3, $01, $9d, $b1, $82, $00, $a2, $01, $10, $18
	db $18, $9d, $71, $82, $80, $a1, $6a, $5c, $6a, $6e, $a3, $01, $9d, $b1, $82, $00
	db $a2, $01, $0e, $18, $18, $9d, $71, $82, $80, $a1, $6a, $5c, $6a, $6e, $9d, $80
	db $00, $00, $a3, $18, $14, $9d, $a1, $82, $00, $a2, $10, $10, $a4, $01, $a2, $01
	db $06, $10, $10, $a4, $01, $a3, $10, $9b, $03, $a2, $06, $06, $a4, $01, $a2, $01
	db $14, $9c, $00, $9d, $26, $00, $00, $a3, $01, $00, $9d, $40, $00, $41, $a2, $01
	db $00, $9b, $03, $a5, $01, $9c, $a4, $01, $a2, $01, $48, $4c, $a8, $4e, $a2, $48
	db $4c, $a8, $4e, $a2, $4c, $48, $3e, $a7, $44, $a8, $48, $a2, $01, $a8, $01, $00
	db $9b, $03, $a1, $60, $5c, $58, $4e, $48, $4e, $58, $5c, $9c, $60, $5c, $58, $4e
	db $48, $4e, $58, $60, $9b, $02, $5c, $56, $52, $4e, $44, $4e, $52, $56, $9c, $00
	db $9b, $02, $a1, $64, $5c, $56, $4e, $4c, $4e, $56, $5c, $9c, $00, $9b, $02, $6a
	db $64, $5c, $56, $52, $56, $5c, $64, $9c, $00, $a1, $06, $14, $1c, $1e, $26, $2c
	db $34, $36, $3e, $44, $4c, $4e, $56, $5c, $a2, $64, $66, $00, $9d, $77, $00, $80
	db $00, $a5, $8c, $00, $9d, $40, $00, $80, $00, $a2, $48, $4c, $a8, $4e, $a2, $48
	db $4c, $a8, $4e, $a2, $4c, $48, $a6, $3e, $a5, $56, $00, $9b, $03, $a5, $01, $9c
	db $a4, $01, $a2, $01, $a2, $36, $3a, $a4, $3e, $a3, $01, $a2, $36, $3a, $a4, $3e
	db $a3, $01, $a2, $3a, $a3, $36, $a7, $34, $a4, $36, $a8, $01, $00, $a2, $48, $4c
	db $a4, $4e, $a3, $01, $a2, $48, $4e, $a4, $58, $a3, $01, $a2, $56, $52, $a5, $56
	db $a2, $01, $00, $9b, $05, $a5, $01, $9c, $a4, $01, $a2, $01, $a6, $01, $00, $9b
	db $03, $a2, $15, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c, $9b, $04
	db $a1, $15, $9c, $00, $a2, $24, $a9, $1a, $ad, $01, $a9, $1a, $ad, $01, $a9, $1a
	db $a2, $1a, $a9, $1a, $ad, $01, $a9, $1a, $ad, $01, $a9, $1a, $a2, $24, $a9, $15
	db $ad, $01, $a9, $1a, $ad, $01, $a9, $1a, $9b, $04, $a1, $1a, $9c, $00, $a4, $24
	db $01, $00, $9b, $04, $a5, $01, $9c, $a7, $01, $00, $66, $66, $66, $66, $66, $66
	db $66, $66, $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $88, $88, $88, $88
	db $88, $88, $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $88, $88, $00, $00
	db $00, $00, $88, $88, $88, $88, $00, $00, $00, $00, $aa, $aa, $aa, $aa, $aa, $aa
	db $aa, $aa, $00, $00, $00, $00, $00, $00, $00, $00, $06, $9b, $cd, $de, $ee, $ff
	db $ff, $fe, $06, $9b, $cd, $de, $ee, $ff, $ff, $fe, $7f, $ff, $57, $73, $55, $34
	db $42, $21, $7f, $ff, $57, $73, $55, $34, $42, $21, $33, $33, $33, $33, $00, $00
	db $00, $00, $33, $33, $33, $33, $00, $00, $00, $00, $11, $11, $11, $11, $00, $00
	db $00, $00, $11, $11, $11, $11, $00, $00, $00, $00, $44, $44, $44, $44, $00, $00
	db $00, $00, $44, $44, $44, $44, $00, $00, $00, $00, $9d, $42, $6e, $20, $00, $9d
	db $42, $6e, $40, $00, $9d, $52, $6e, $21, $00, $9d, $52, $6e, $40, $00, $9d, $52
	db $6e, $40, $99, $00, $9d, $22, $6e, $20, $00, $9d, $62, $6e, $20, $00, $9d, $b2
	db $6e, $40, $99, $00, $9d, $32, $6e, $21, $00, $9d, $32, $6e, $25, $00, $9d, $32
	db $6e, $40, $00, $9d, $42, $00, $80, $00, $9d, $53, $00, $80, $00, $9d, $50, $83
	db $40, $00, $9d, $60, $81, $80, $00, $9d, $71, $00, $40, $00, $9d, $42, $00, $40
	db $00, $9d, $33, $00, $40, $00, $9d, $62, $00, $80, $00, $9d, $60, $26, $01, $00
	db $9d, $60, $26, $81, $00, $9d, $40, $00, $80, $00, $9d, $20, $00, $80, $00, $9d
	db $43, $00, $80, $00, $9d, $40, $21, $80, $00, $9d, $50, $00, $41, $00, $9d, $60
	db $21, $41, $00, $9d, $60, $00, $81, $00, $9d, $90, $21, $41, $00, $9d, $b0, $21
	db $41, $00, $9d, $91, $00, $40, $00, $9d, $50, $26, $80, $00, $9d, $30, $21, $80
	db $00, $9d, $20, $21, $80, $00, $9d, $60, $26, $80, $00, $9d, $40, $26, $80, $00
	db $9d, $60, $00, $40, $00, $9d, $a0, $21, $41, $00, $9d, $82, $82, $80, $00, $9d
	db $77, $00, $80, $00, $9d, $97, $00, $80, $00, $9d, $51, $82, $80, $00, $9d, $82
	db $6e, $01, $94, $00, $9d, $72, $6e, $01, $94, $00, $9f, $fe, $00, $9f, $00, $00
	db $9f, $02, $00, $9f, $0a, $00, $9d, $10, $00, $80, $00, $9d, $37, $00, $80, $00
	db $9d, $43, $83, $80, $00, $9b, $0b, $a5, $01, $9c, $a4, $01, $00, $9b, $11, $a5
	db $01, $9c, $00, $9b, $09, $a5, $01, $9c, $a4, $01, $00, $9b, $09, $a5, $01, $9c
	db $a4, $01, $00, $a5, $01, $01, $00, $a5, $01, $00, $a5, $01, $01, $00, $9b, $03
	db $a5, $01, $9c, $00, $9b, $04, $a5, $01, $9c, $00, $9b, $10, $a5, $01, $9c, $00
	db $a8, $01, $00, $a6, $01, $00, $a7, $01, $00, $a1, $01, $00, $a2, $01, $00, $a4
	db $01, $00, $a3, $01, $00, $a5, $01, $00, $df, $6f, $ff, $ff, $10, $70, $0d, $70
	db $ff, $ff, $16, $70, $9e, $3a, $4a, $00, $9e, $49, $4a, $00, $9e, $67, $4a, $00
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
