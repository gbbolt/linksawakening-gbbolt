; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01e", ROMX[$4000], BANK[$1e]

	db $c3, $09, $40, $c3, $fa, $4c

	jp Jump_01e_401e


	db $21, $00, $d3, $36, $00, $2c, $20, $fb, $3e, $80, $e0, $26, $3e, $77, $e0, $24
	db $3e, $ff, $e0, $25, $c9

Jump_01e_401e:
	ld hl, $d368
	ld a, [hli]
	and a
	jr nz, jr_01e_4039

	call Call_1E_403F

jr_01e_4028:
	call Call_1E_457C

Jump_01e_402b:
	xor a
	ld [$d360], a
	ld [$d368], a
	ld [$d370], a
	ld [$d378], a
	ret


jr_01e_4039:
	ld [hl], a
	call Call_1E_4163
	jr jr_01e_4028

Call_1E_403F::
	ld de, $d393
	ld hl, $d378
	ld a, [hli]
	cp $01
	jr z, jr_01e_4050

	ld a, [hl]
	cp $01
	jr z, jr_01e_405b

	ret


jr_01e_4050:
	ld a, $01
	ld [$d379], a
	ld hl, $4068
	jp Jump_01e_4072


jr_01e_405b:
	ld a, [de]
	dec a
	ld [de], a
	ret nz

	xor a
	ld [$d379], a
	ld hl, $406d
	jr jr_01e_4072

	db $3b, $80, $07, $c0, $02, $00, $42, $02, $c0, $04

Jump_01e_4072:
jr_01e_4072:
	ld b, $04
	ld c, $20

jr_01e_4076:
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, jr_01e_4076

	ld a, [hl]
	ld [de], a
	ret


	db $09, $52, $56, $56, $6a, $5e, $74, $59, $ae, $5a, $a7, $5c, $b3, $5d, $ee, $5e
	db $3c, $5f, $00, $50, $64, $60, $c2, $60, $23, $61, $a9, $62, $75, $64, $a5, $72
	db $10, $66, $36, $66, $bf, $52, $62, $66, $a6, $7b, $77, $67, $2e, $4b, $f1, $72
	db $3f, $73, $9e, $73, $16, $74, $a8, $74, $46, $75, $92, $75, $00, $76, $3d, $77
	db $00, $70, $2c, $70, $f0, $70, $58, $71, $a6, $71, $d4, $71, $3c, $72, $d3, $78
	db $23, $4b, $93, $76, $0e, $63, $79, $69, $df, $69, $21, $6a, $09, $6c, $33, $4c
	db $6a, $5e, $74, $59, $b7, $66, $80, $6c, $05, $7a, $5a, $7a, $28, $7b, $7b, $65
	db $28, $7c, $c9, $58, $9c, $67, $49, $6c, $ac, $52, $ff, $7c, $4b, $7d, $04, $7e

Call_1E_40FF::
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


Call_1E_410E::
	push bc
	ld c, $30

jr_01e_4111:
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, jr_01e_4111

	pop bc
	ret


Call_1E_411B::
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


Call_1E_4137::
	ld a, [$d379]
	cp $05
	jp z, Jump_01e_4d18

	cp $0c
	jp z, Jump_01e_4d18

	cp $1a
	jp z, Jump_01e_4d18

	cp $24
	jp z, Jump_01e_4d18

	cp $2a
	jp z, Jump_01e_4d18

	cp $2e
	jp z, Jump_01e_4d18

	cp $3f
	jp z, Jump_01e_4d18

	call Call_1E_411B
	jp Jump_01e_4d18


Call_1E_4163::
	ld b, a
	ld a, [$d3ce]
	and a
	jp nz, Jump_01e_402b

	ld a, b
	cp $ff
	jr z, Call_1E_4137

	cp $11
	jr nc, jr_01e_4177

	jp Jump_01e_402b


jr_01e_4177:
	cp $21
	jr nc, jr_01e_417f

	add $f0
	jr jr_01e_418e

jr_01e_417f:
	cp $31
	jr nc, jr_01e_4187

	add $f0
	jr jr_01e_418e

jr_01e_4187:
	cp $41
	jp c, Jump_01e_402b

	add $e0

jr_01e_418e:
	dec hl
	ld [hli], a
	ld [hld], a
	ld a, [$d3ca]
	ld [$d3cb], a
	ld a, [hli]
	ld [$d3ca], a
	ld b, a
	ld hl, $407f
	and $7f
	call Call_1E_40FF
	call Call_1E_43BB
	jp Jump_01e_4354


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

Jump_01e_432a:
	ld a, [$d3e7]
	and a
	jp z, Jump_01e_473a

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

jr_01e_4343:
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, jr_01e_4343

	ld a, $80
	ldh [rNR30], a
	pop bc
	pop hl
	jp Jump_01e_473a


Jump_01e_4354:
	ld a, [$d369]
	ld hl, $41aa

jr_01e_435a:
	dec a
	jr z, jr_01e_4365

	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	jr jr_01e_435a

jr_01e_4365:
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


Call_1E_4382::
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
	jr z, jr_01e_43a6

	inc c
	cp $01
	jr z, jr_01e_43a6

	inc c
	cp $02
	jr z, jr_01e_43a6

	inc c

jr_01e_43a6:
	ld a, [bc]
	ldh [rNR51], a
	ret


Call_1E_43AA::
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


Call_1E_43B5::
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	ret


Call_1E_43BB::
	ld a, [$d379]
	cp $05
	jr z, jr_01e_43dd

	cp $0c
	jr z, jr_01e_43dd

	cp $1a
	jr z, jr_01e_43dd

	cp $24
	jr z, jr_01e_43dd

	cp $2a
	jr z, jr_01e_43dd

	cp $2e
	jr z, jr_01e_43dd

	cp $3f
	jr z, jr_01e_43dd

	call Call_1E_411B

jr_01e_43dd:
	call Call_1E_4D25
	ld de, $d300
	ld b, $00
	ld a, [hli]
	ld [de], a
	inc e
	call Call_1E_43B5
	ld de, $d310
	call Call_1E_43B5
	ld de, $d320
	call Call_1E_43B5
	ld de, $d330
	call Call_1E_43B5
	ld de, $d340
	call Call_1E_43B5
	ld hl, $d310
	ld de, $d314
	call Call_1E_43AA
	ld hl, $d320
	ld de, $d324
	call Call_1E_43AA
	ld hl, $d330
	ld de, $d334
	call Call_1E_43AA
	ld hl, $d340
	ld de, $d344
	call Call_1E_43AA
	ld bc, $0410
	ld hl, $d312

jr_01e_442d:
	ld [hl], $01
	ld a, c
	add l
	ld l, a
	dec b
	jr nz, jr_01e_442d

	xor a
	ld [$d31e], a
	ld [$d32e], a
	ld [$d33e], a
	ret


jr_01e_4440:
	push hl
	ld a, [$d371]
	and a
	jr nz, jr_01e_444f

	xor a
	ldh [rNR30], a
	ld l, e
	ld h, d
	call Call_1E_410E

jr_01e_444f:
	pop hl
	jr jr_01e_447c

Jump_01e_4452:
	call Call_1E_4482
	call Call_1E_4497
	ld e, a
	call Call_1E_4482
	call Call_1E_4497
	ld d, a
	call Call_1E_4482
	call Call_1E_4497
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
	jr z, jr_01e_4440

jr_01e_447c:
	call Call_1E_4482
	jp Jump_01e_45a0


Call_1E_4482::
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de

jr_01e_4488:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	pop de
	ret


Call_1E_448E::
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
	inc de
	jr jr_01e_4488

Call_1E_4497::
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [bc]
	ld b, a
	ret


jr_01e_449e:
	pop hl
	jr jr_01e_44d2

Jump_01e_44a1:
	ld a, [$d350]
	cp $03
	jr nz, jr_01e_44b8

	ld a, [$d338]
	bit 7, a
	jr z, jr_01e_44b8

	ld a, [hl]
	cp $06
	jr nz, jr_01e_44b8

	ld a, $40
	ldh [rNR32], a

jr_01e_44b8:
	push hl
	ld a, l
	add $09
	ld l, a
	ld a, [hl]
	and a
	jr nz, jr_01e_449e

	ld a, l
	add $04
	ld l, a
	bit 7, [hl]
	jr nz, jr_01e_449e

	pop hl
	call Call_1E_476D
	push hl
	call Call_1E_47F1
	pop hl

Jump_01e_44d2:
jr_01e_44d2:
	dec l
	dec l
	jp Jump_01e_474d


Jump_01e_44d7:
	dec l
	dec l
	dec l
	dec l
	call Call_1E_448E

jr_01e_44de:
	ld a, l
	add $04
	ld e, a
	ld d, h
	call Call_1E_43AA
	cp $00
	jr z, jr_01e_4509

	cp $ff
	jr z, jr_01e_44f2

	inc l
	jp Jump_01e_459e


jr_01e_44f2:
	dec l
	push hl
	call Call_1E_448E
	call Call_1E_4497
	ld e, a
	call Call_1E_4482
	call Call_1E_4497
	ld d, a
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	jr jr_01e_44de

jr_01e_4509:
	ld a, [$d3ca]
	cp $15
	jp z, Jump_01e_484f

	ld hl, $d369
	ld [hl], $00
	call Call_1E_4137
	ret


Jump_01e_451a:
	call Call_1E_4482
	call Call_1E_4497
	ld [$d301], a
	call Call_1E_4482
	call Call_1E_4497
	ld [$d302], a
	jr jr_01e_4537

Jump_01e_452e:
	call Call_1E_4482
	call Call_1E_4497
	ld [$d300], a

jr_01e_4537:
	call Call_1E_4482
	jr jr_01e_45a0

Jump_01e_453c:
	call Call_1E_4482
	call Call_1E_4497
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
	jr jr_01e_45a0

Jump_01e_4560:
	push hl
	ld a, l
	add $0b
	ld l, a
	ld a, [hl]
	dec [hl]
	ld a, [hl]
	and $7f
	jr z, jr_01e_4579

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
	jr jr_01e_45a0

jr_01e_4579:
	pop hl
	jr jr_01e_4537

Call_1E_457C::
	ld hl, $d369
	ld a, [hl]
	and a
	ret z

	ld a, [$d3ce]
	and a
	jp nz, Jump_01e_402b

	call Call_1E_4382
	ld a, $01
	ld [$d350], a
	ld hl, $d310

Jump_01e_4594:
	inc l
	ld a, [hli]
	and a
	jp z, Jump_01e_44d2

	dec [hl]
	jp nz, Jump_01e_44a1

Jump_01e_459e:
	inc l
	inc l

Jump_01e_45a0:
jr_01e_45a0:
	call Call_1E_4497
	cp $00
	jp z, Jump_01e_44d7

	cp $9d
	jp z, Jump_01e_4452

	cp $9e
	jp z, Jump_01e_451a

	cp $9f
	jp z, Jump_01e_452e

	cp $9b
	jp z, Jump_01e_453c

	cp $9c
	jp z, Jump_01e_4560

	cp $99
	jp z, Jump_01e_4869

	cp $9a
	jp z, Jump_01e_4874

	cp $94
	jp z, Jump_01e_48b3

	cp $97
	jp z, Jump_01e_48e8

	cp $98
	jp z, Jump_01e_48f7

	cp $96
	jp z, Jump_01e_485b

	cp $95
	jp z, Jump_01e_4866

	and $f0
	cp $a0
	jr nz, jr_01e_4637

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
	jr nz, jr_01e_4609

	ld a, d
	jr jr_01e_462e

jr_01e_4609:
	ld e, a
	ld a, d
	push af
	srl a
	sla e
	jr c, jr_01e_461a

	ld d, a
	srl a
	sla e
	jr c, jr_01e_461a

	add d

jr_01e_461a:
	ld c, a
	and a
	jr nz, jr_01e_4620

	ld c, $02

jr_01e_4620:
	ld de, $d350
	ld a, [de]
	dec a
	ld e, a
	ld d, $00
	ld hl, $d307
	add hl, de
	ld [hl], c
	pop af

jr_01e_462e:
	pop hl
	dec l
	ld [hli], a
	call Call_1E_4482
	call Call_1E_4497

jr_01e_4637:
	ld a, [$d350]
	cp $04
	jr z, jr_01e_4676

	push de
	ld de, $d3b0
	call Call_1E_4937
	xor a
	ld [de], a
	inc e
	ld [de], a
	ld de, $d3b6
	call Call_1E_4937
	inc e
	xor a
	ld [de], a
	ld a, [$d350]
	cp $03
	jr nz, jr_01e_4675

	ld de, $d39e
	ld a, [de]
	and a
	jr z, jr_01e_4667

	ld a, $01
	ld [de], a
	xor a
	ld [$d39f], a

jr_01e_4667:
	ld de, $d3d9
	ld a, [de]
	and a
	jr z, jr_01e_4675

	ld a, $01
	ld [de], a
	xor a
	ld [$d3da], a

jr_01e_4675:
	pop de

jr_01e_4676:
	ld c, b
	ld b, $00
	call Call_1E_4482
	ld a, [$d350]
	cp $04
	jp z, Jump_01e_46b8

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
	jr z, jr_01e_46b3

	ld [hl], $00
	ld a, [$d300]
	and a
	jr z, jr_01e_46a6

	ld l, a
	ld h, $00
	bit 7, l
	jr z, jr_01e_46a3

	ld h, $ff

jr_01e_46a3:
	add hl, bc
	ld b, h
	ld c, l

jr_01e_46a6:
	ld hl, $49ba
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	jp Jump_01e_46e9


jr_01e_46b3:
	ld [hl], $01
	pop hl
	jr jr_01e_46e9

Jump_01e_46b8:
	push hl
	ld a, c
	cp $ff
	jr z, jr_01e_46d6

	ld de, $d346
	ld hl, $4a4c
	add hl, bc

jr_01e_46c5:
	ld a, [hli]
	ld [de], a
	inc e
	ld a, e
	cp $4b
	jr nz, jr_01e_46c5

	ld c, $20
	ld hl, $d344
	ld b, $00
	jr jr_01e_4717

jr_01e_46d6:
	ld a, [$d34f]
	bit 7, a
	jp nz, Jump_01e_4748

	ld a, $01
	ld [$d378], a
	call Call_1E_403F
	jp Jump_01e_4748


Jump_01e_46e9:
jr_01e_46e9:
	push hl
	ld b, $00
	ld a, [$d350]
	cp $01
	jr z, jr_01e_4714

	cp $02
	jr z, jr_01e_4710

	ld c, $1a
	ld a, [$d33f]
	bit 7, a
	jr nz, jr_01e_4705

	xor a
	ldh [c], a
	ld a, $80
	ldh [c], a

jr_01e_4705:
	inc c
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	ld e, a
	ld d, $00
	jr jr_01e_471e

jr_01e_4710:
	ld c, $16
	jr jr_01e_4717

jr_01e_4714:
	ld c, $10
	inc c

jr_01e_4717:
	inc l
	inc l
	ld a, [hli]
	ld e, a
	inc l
	ld a, [hli]
	ld d, a

jr_01e_471e:
	push hl
	inc l
	inc l
	ld a, [hli]
	and a
	jr z, jr_01e_4727

	ld e, $08

jr_01e_4727:
	inc l
	inc l
	ld [hl], $00
	inc l
	ld a, [hl]
	pop hl
	bit 7, a
	jr nz, jr_01e_4748

	ld a, [$d350]
	cp $03
	jp z, Jump_01e_432a

Jump_01e_473a:
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

Jump_01e_4748:
jr_01e_4748:
	pop hl
	dec l
	ld a, [hld]
	ld [hld], a
	dec l

Jump_01e_474d:
	ld de, $d350
	ld a, [de]
	cp $04
	jr z, jr_01e_475e

	inc a
	ld [de], a
	ld a, $10
	add l
	ld l, a
	jp Jump_01e_4594


jr_01e_475e:
	ld hl, $d31e
	inc [hl]
	ld hl, $d32e
	inc [hl]
	ld hl, $d33e
	inc [hl]
	ret


Jump_01e_476b:
	pop hl
	ret


Call_1E_476D::
	push hl
	ld a, l
	add $06
	ld l, a
	ld a, [hl]
	and $0f
	jr z, jr_01e_478f

	ld [$d351], a
	ld a, [$d350]
	ld c, $13
	cp $01
	jr z, jr_01e_47d1

	ld c, $18
	cp $02
	jr z, jr_01e_47d1

	ld c, $1d
	cp $03
	jr z, jr_01e_47d1

Jump_01e_478f:
jr_01e_478f:
	ld a, [$d350]
	cp $04
	jp z, Jump_01e_476b

	ld de, $d3b6
	call Call_1E_4937
	ld a, [de]
	and a
	jp z, Jump_01e_47b8

	ld a, [$d350]
	ld c, $13
	cp $01
	jp z, Jump_01e_4900

	ld c, $18
	cp $02
	jp z, Jump_01e_4900

	ld c, $1d
	jp Jump_01e_4900


Jump_01e_47b8:
	ld a, [$d350]
	cp $03
	jp nz, Jump_01e_476b

	ld a, [$d39e]
	and a
	jp nz, Jump_01e_487d

	ld a, [$d3d9]
	and a
	jp nz, Jump_01e_48be

	jp Jump_01e_476b


jr_01e_47d1:
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
	jp z, Jump_01e_494d

	ld hl, $ffff
	pop de
	add hl, de
	call Call_1E_4926
	jp Jump_01e_478f


Call_1E_47F1::
	ld a, [$d31b]
	and a
	jr nz, jr_01e_4818

	ld a, [$d317]
	and a
	jr z, jr_01e_4818

	and $0f
	ld b, a
	ld hl, $d307
	ld a, [$d31e]
	cp [hl]
	jr nz, jr_01e_4818

	ld c, $12
	ld de, $d31a
	ld a, [$d31f]
	bit 7, a
	jr nz, jr_01e_4818

	call Call_1E_483C

jr_01e_4818:
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
	call Call_1E_483C
	ret


Call_1E_483C::
	push bc
	dec b
	ld c, b
	ld b, $00
	ld hl, $4b10
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


Jump_01e_484f:
	xor a
	ld [$d3ce], a
	ldh a, [$ffbf]
	ld [$d368], a
	jp Jump_01e_401e


Jump_01e_485b:
	ld a, $01

jr_01e_485d:
	ld [$d3cd], a
	call Call_1E_4482
	jp Jump_01e_45a0


Jump_01e_4866:
	xor a
	jr jr_01e_485d

Jump_01e_4869:
	ld a, $01

jr_01e_486b:
	ld [$d39e], a
	call Call_1E_4482
	jp Jump_01e_45a0


Jump_01e_4874:
	xor a
	ld [$d3d9], a
	ld [$d3da], a
	jr jr_01e_486b

Jump_01e_487d:
	cp $02
	jp z, Jump_01e_476b

	ld bc, $d39f
	call Call_1E_48AF
	ld c, $1c
	ld b, $40
	cp $03
	jr z, jr_01e_48aa

	ld b, $60
	cp $05
	jr z, jr_01e_48aa

	cp $0a
	jr z, jr_01e_48aa

	ld b, $00
	cp $07
	jr z, jr_01e_48aa

	cp $0d
	jp nz, Jump_01e_476b

	ld a, $02
	ld [$d39e], a

Jump_01e_48aa:
jr_01e_48aa:
	ld a, b
	ldh [c], a
	jp Jump_01e_476b


Call_1E_48AF::
	ld a, [bc]
	inc a
	ld [bc], a
	ret


Jump_01e_48b3:
	ld a, $01
	ld [$d3d9], a
	call Call_1E_4482
	jp Jump_01e_45a0


Jump_01e_48be:
	cp $02
	jp z, Jump_01e_476b

	ld bc, $d3da
	call Call_1E_48AF
	ld c, $1c
	ld b, $60
	cp $03
	jp z, Jump_01e_48aa

	ld b, $40
	cp $05
	jp z, Jump_01e_48aa

	ld b, $20
	cp $06
	jp nz, Jump_01e_476b

	ld a, $02
	ld [$d3d9], a
	jp Jump_01e_48aa


Jump_01e_48e8:
	ld de, $d3b6
	call Call_1E_4937
	ld a, $01

jr_01e_48f0:
	ld [de], a
	call Call_1E_4482
	jp Jump_01e_45a0


Jump_01e_48f7:
	ld de, $d3b6
	call Call_1E_4937
	xor a
	jr jr_01e_48f0

Jump_01e_4900:
	inc e
	ld a, [de]
	and a
	jr nz, jr_01e_4916

	inc a
	ld [de], a
	pop hl
	push hl
	call Call_1E_491B

jr_01e_490c:
	ld hl, $ff9c
	add hl, de
	call Call_1E_4926
	jp Jump_01e_476b


jr_01e_4916:
	call Call_1E_4940
	jr jr_01e_490c

Call_1E_491B::
	ld a, $07
	add l
	ld l, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0f
	ld d, a
	ret


Call_1E_4926::
	ld de, $d3a4
	call Call_1E_4937
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


Call_1E_4937::
	ld a, [$d350]
	dec a
	sla a
	add e
	ld e, a
	ret


Call_1E_4940::
	ld de, $d3a4
	call Call_1E_4937
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld d, a
	ld e, l
	ret


Jump_01e_494d:
	pop de
	ld de, $d3b0
	call Call_1E_4937
	ld a, [de]
	inc a
	ld [de], a
	inc e
	cp $19
	jr z, jr_01e_498d

	cp $2d
	jr z, jr_01e_4986

	ld a, [de]
	and a
	jp z, Jump_01e_478f

jr_01e_4965:
	dec e
	ld a, [de]
	sub $19
	sla a
	ld l, a
	ld h, $00
	ld de, $4992
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	push de
	call Call_1E_491B
	ld h, d
	ld l, e
	pop de
	add hl, de
	call Call_1E_4926
	jp Jump_01e_478f


jr_01e_4986:
	dec e
	ld a, $19
	ld [de], a
	inc e
	jr jr_01e_4965

jr_01e_498d:
	ld a, $01
	ld [de], a
	jr jr_01e_4965

	db $00, $00, $00, $00, $00, $01, $00, $01, $00, $02, $00, $02, $00, $00, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $00, $00, $00, $01, $00, $02, $00, $01
	db $00, $00, $ff, $ff, $ff, $fe, $ff, $ff, $00, $0f, $2c, $00, $9c, $00, $06, $01
	db $6b, $01, $c9, $01, $23, $02, $77, $02, $c6, $02, $12, $03, $56, $03, $9b, $03
	db $da, $03, $16, $04, $4e, $04, $83, $04, $b5, $04, $e5, $04, $11, $05, $3b, $05
	db $63, $05, $89, $05, $ac, $05, $ce, $05, $ed, $05, $0a, $06, $27, $06, $42, $06
	db $5b, $06, $72, $06, $89, $06, $9e, $06, $b2, $06, $c4, $06, $d6, $06, $e7, $06
	db $f7, $06, $06, $07, $14, $07, $21, $07, $2d, $07, $39, $07, $44, $07, $4f, $07
	db $59, $07, $62, $07, $6b, $07, $74, $07, $7b, $07, $83, $07, $8a, $07, $90, $07
	db $97, $07, $9d, $07, $a2, $07, $a7, $07, $ac, $07, $b1, $07, $b6, $07, $ba, $07
	db $be, $07, $c1, $07, $c5, $07, $c8, $07, $cb, $07, $ce, $07, $d1, $07, $d4, $07
	db $d6, $07, $d9, $07, $db, $07, $dd, $07, $df, $07, $00, $00, $00, $00, $00, $c0
	db $09, $00, $38, $34, $c0, $19, $00, $38, $33, $c0, $46, $00, $13, $10, $c0, $23
	db $00, $20, $40, $80, $51, $00, $20, $07, $80, $a1, $00, $00, $18, $80, $f2, $00
	db $00, $18, $80, $81, $00, $3a, $10, $c0, $80, $00, $00, $10, $c0, $57, $00, $00
	db $60, $80, $10, $00, $00, $10, $80, $01, $02, $04, $08, $10, $20, $06, $0c, $18
	db $01, $01, $01, $01, $01, $30, $01, $03, $06, $0c, $18, $30, $09, $12, $24, $02
	db $04, $08, $01, $01, $48, $02, $04, $08, $10, $20, $40, $0c, $18, $30, $02, $05
	db $03, $01, $01, $60, $03, $05, $0a, $14, $28, $50, $0f, $1e, $3c, $02, $08, $10
	db $02, $01, $78, $03, $06, $0c, $18, $30, $60, $12, $24, $48, $03, $08, $10, $02
	db $04, $90, $03, $07, $0e, $1c, $38, $70, $15, $2a, $54, $04, $09, $12, $02, $01
	db $a8, $04, $08, $10, $20, $40, $80, $18, $30, $60, $04, $02, $01, $01, $00, $c0
	db $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $05, $0c, $18, $18, $06, $d8, $05
	db $0a, $14, $28, $50, $a0, $1e, $3c, $78, $05, $01, $01, $01, $01, $f0, $10, $32
	db $22, $47, $60, $20, $00, $1d, $4b, $ff, $ff, $17, $4b, $9b, $20, $ae, $01, $9c
	db $00, $00, $c5, $4a, $3b, $4b, $43, $4b, $4b, $4b, $53, $4b, $00, $c5, $4a, $39
	db $4b, $41, $4b, $49, $4b, $51, $4b, $59, $4b, $60, $4b, $ff, $ff, $3b, $4b, $82
	db $4b, $92, $4b, $ff, $ff, $43, $4b, $14, $4c, $19, $4c, $ff, $ff, $4b, $4b, $25
	db $4c, $2a, $4c, $ff, $ff, $53, $4b, $a5, $01, $a8, $01, $aa, $01, $00, $9d, $10
	db $00, $80, $9b, $04, $a1, $7c, $76, $6e, $64, $9c, $9b, $04, $7e, $78, $70, $66
	db $9c, $9b, $04, $7c, $76, $6e, $64, $9c, $9b, $04, $78, $72, $6a, $60, $9c, $00
	db $9d, $60, $81, $41, $aa, $01, $56, $60, $6a, $60, $66, $a5, $64, $a3, $01, $00
	db $9d, $34, $00, $00, $9b, $03, $a1, $7c, $76, $6e, $64, $9c, $9d, $43, $00, $00
	db $7c, $76, $6e, $64, $9d, $62, $00, $00, $7e, $78, $70, $66, $9d, $43, $00, $00
	db $7e, $78, $70, $66, $9d, $34, $00, $00, $9b, $02, $7e, $78, $70, $66, $9c, $9b
	db $02, $7c, $76, $6e, $64, $9c, $9d, $43, $00, $00, $7c, $76, $6e, $64, $9d, $62
	db $00, $00, $7c, $76, $6e, $64, $9d, $82, $00, $00, $78, $72, $6a, $60, $9d, $62
	db $00, $00, $78, $72, $6a, $60, $9d, $43, $00, $00, $9b, $02, $78, $72, $6a, $60
	db $9c, $00, $66, $66, $66, $66, $00, $00, $00, $00, $66, $66, $66, $66, $00, $00
	db $00, $00, $00, $22, $44, $55, $66, $66, $88, $88, $aa, $aa, $cc, $cc, $04, $84
	db $04, $84, $a5, $01, $a8, $01, $00, $9d, $f4, $4b, $20, $99, $9b, $20, $a2, $04
	db $1c, $9c, $00, $a5, $01, $a8, $01, $00, $9b, $20, $a2, $1a, $a1, $1a, $1a, $9c
	db $00, $02, $b6, $4a, $3e, $4c, $4c, $4c, $60, $4c, $66, $4c, $6c, $4c, $82, $4c
	db $94, $4c, $a6, $4c, $94, $4c, $ff, $ff, $40, $4c, $73, $4c, $82, $4c, $78, $4c
	db $94, $4c, $7d, $4c, $a6, $4c, $78, $4c, $94, $4c, $ff, $ff, $4c, $4c, $b8, $4c
	db $ff, $ff, $60, $4c, $eb, $4c, $ff, $ff, $66, $4c, $9d, $43, $00, $03, $a0, $01
	db $00, $9d, $43, $00, $00, $00, $9d, $71, $00, $00, $00, $9d, $91, $00, $00, $00
	db $9b, $02, $a1, $48, $4c, $4e, $a6, $5c, $a1, $48, $4c, $4e, $a6, $5a, $a3, $01
	db $9c, $00, $9b, $02, $a1, $4c, $50, $52, $a6, $60, $a1, $4c, $50, $52, $a6, $5e
	db $a3, $01, $9c, $00, $9b, $02, $a1, $50, $54, $56, $a6, $64, $a1, $50, $54, $56
	db $a6, $62, $a3, $01, $9c, $00, $9d, $04, $4c, $20, $99, $9b, $02, $a2, $30, $18
	db $18, $30, $18, $18, $30, $18, $9c, $9b, $02, $34, $1c, $1c, $34, $1c, $1c, $34
	db $1c, $9c, $9b, $02, $38, $20, $20, $38, $20, $20, $38, $20, $9c, $9b, $02, $34
	db $1c, $1c, $34, $1c, $1c, $34, $1c, $9c, $00, $9b, $02, $a1, $1a, $1a, $1a, $a6
	db $1a, $9c, $a1, $1a, $15, $15, $15, $00, $af, $ea, $79, $d3, $ea, $4f, $d3, $ea
	db $98, $d3, $ea, $93, $d3, $ea, $c9, $d3, $ea, $a3, $d3, $ea, $e5, $d3, $3e, $08
	db $e0, $21, $3e, $80, $e0, $23

Jump_01e_4d18:
	ld a, $ff
	ldh [rNR51], a
	ld a, $03
	ld [$d355], a
	xor a
	ld [$d369], a

Call_1E_4D25::
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $e3, $4a, $0b
	db $50, $2f, $50, $53, $50, $00, $00, $13, $6e, $6f, $50, $ac, $6e, $a1, $50, $a8
	db $6e, $22, $6e, $a8, $50, $09, $6e, $2a, $6d, $47, $51, $47, $51, $15, $6d, $b0
	db $6e, $10, $6d, $09, $6e, $51, $51, $e3, $51, $00, $00, $b7, $50, $ac, $6e, $ff
	db $6d, $ed, $50, $a8, $6e, $f2, $50, $cd, $6d, $47, $51, $09, $6e, $47, $51, $15
	db $6d, $b0, $6e, $be, $6d, $51, $51, $2d, $6d, $18, $6e, $e3, $51, $00, $00, $63
	db $6e, $00, $51, $ac, $6e, $31, $51, $a8, $6e, $54, $6e, $38, $51, $72, $6e, $27
	db $6d, $47, $51, $77, $6e, $47, $51, $ff, $ff, $30, $6d, $9b, $02, $a2, $12, $2a
	db $12, $18, $30, $9c, $16, $2e, $16, $1c, $34, $16, $2e, $14, $2c, $9b, $02, $a2
	db $12, $2a, $12, $18, $30, $9c, $1a, $32, $1a, $20, $38, $1a, $32, $18, $30, $9b
	db $02, $16, $2e, $16, $1c, $34, $9c, $22, $3a, $22, $28, $40, $00, $a2, $16, $2e
	db $16, $1c, $34, $00, $a2, $22, $3a, $22, $28, $40, $a2, $2e, $46, $2e, $34, $4c
	db $a5, $01, $00, $9d, $97, $86, $80, $a7, $42, $a4, $34, $a6, $01, $a1, $38, $3a
	db $3e, $a3, $40, $a4, $58, $a7, $01, $42, $a4, $34, $a6, $01, $a1, $38, $3a, $4c
	db $a3, $4a, $a4, $48, $a7, $01, $9d, $b7, $86, $80, $a7, $46, $a4, $38, $a6, $01
	db $a1, $3e, $40, $42, $a3, $44, $a7, $5c, $00, $a3, $32, $a7, $4a, $00, $9d, $89
	db $86, $81, $a3, $48, $a7, $60, $a8, $80, $01, $a2, $01, $00, $9b, $02, $a2, $04
	db $1c, $04, $0a, $22, $9c, $08, $20, $08, $0e, $26, $08, $20, $06, $1e, $9b, $02
	db $04, $1c, $04, $0a, $22, $9c, $0c, $24, $0c, $12, $2a, $0c, $24, $0a, $22, $9b
	db $02, $08, $20, $08, $0e, $26, $9c, $14, $2c, $14, $1a, $32, $00, $a2, $08, $20
	db $08, $0e, $26, $00, $a2, $14, $2c, $14, $1a, $32, $a2, $20, $38, $20, $26, $3e
	db $a5, $01, $00, $a1, $48, $50, $54, $5c, $60, $68, $6c, $74, $00, $a3, $3c, $2e
	db $01, $a1, $2e, $32, $36, $38, $a3, $01, $38, $2a, $a1, $2a, $2e, $32, $36, $a2
	db $01, $6c, $5e, $24, $16, $5e, $a1, $5e, $62, $66, $a6, $68, $a2, $68, $5a, $20
	db $12, $5a, $a1, $5a, $5e, $62, $66, $a2, $01, $84, $76, $3c, $2e, $76, $a1, $76
	db $7a, $7e, $a6, $80, $a2, $80, $72, $38, $2a, $72, $a1, $72, $76, $7a, $7e, $a2
	db $38, $66, $58, $38, $20, $58, $a1, $58, $5c, $5e, $62, $a2, $36, $62, $54, $6c
	db $a1, $36, $3c, $44, $4a, $4e, $54, $5c, $62, $a2, $32, $5e, $50, $32, $4a, $50
	db $a1, $50, $54, $58, $5c, $a2, $2e, $5c, $4e, $66, $a1, $2e, $36, $3c, $44, $46
	db $4e, $54, $5c, $a2, $2a, $58, $a1, $4a, $50, $58, $62, $a2, $26, $54, $a1, $46
	db $a0, $01, $a1, $4c, $a0, $01, $a1, $54, $a0, $01, $a1, $5e, $a4, $01, $00, $9e
	db $d4, $4a, $a1, $32, $3c, $46, $9b, $02, $0c, $01, $01, $9c, $3c, $40, $44, $46
	db $4a, $01, $0c, $3c, $46, $50, $0c, $01, $01, $0c, $01, $46, $50, $5a, $01, $0c
	db $0c, $01, $0c, $01, $00, $00, $d4, $4a, $14, $52, $1e, $52, $26, $52, $2e, $52
	db $15, $6d, $e1, $6d, $53, $52, $ff, $ff, $16, $52, $31, $6e, $34, $52, $ff, $ff
	db $1e, $52, $63, $6e, $74, $52, $ff, $ff, $26, $52, $93, $52, $ff, $ff, $2e, $52
	db $a2, $46, $01, $a7, $3c, $a1, $46, $01, $46, $4a, $4e, $50, $a4, $54, $01, $a2
	db $5e, $01, $a7, $54, $a1, $5e, $01, $5e, $62, $66, $68, $a4, $6c, $01, $00, $a2
	db $2a, $01, $a7, $20, $a1, $2a, $01, $2a, $2e, $32, $38, $3e, $a6, $01, $a5, $01
	db $a2, $42, $01, $a3, $38, $a1, $42, $38, $32, $2a, $2e, $a6, $01, $a8, $01, $00
	db $9b, $02, $99, $a2, $16, $16, $01, $16, $9c, $9b, $02, $12, $12, $01, $12, $9c
	db $9b, $02, $0e, $0e, $01, $0e, $9c, $9b, $02, $12, $12, $01, $12, $9c, $00, $9b
	db $07, $a2, $1a, $a1, $1a, $1a, $9c, $9b, $04, $1a, $9c, $9b, $06, $a2, $1a, $a1
	db $1a, $1a, $9c, $9b, $08, $1a, $9c, $00, $00, $e3, $4a, $17, $4b, $b7, $52, $17
	db $4b, $00, $00, $2c, $6e, $da, $53, $ff, $ff, $b7, $52, $00, $a7, $4a, $f0, $52
	db $ca, $52, $9a, $53, $be, $53, $e1, $6d, $ce, $53, $a0, $6e, $15, $6d, $ac, $6e
	db $27, $6d, $eb, $6d, $98, $54, $d7, $54, $d7, $54, $d7, $54, $de, $54, $98, $54
	db $d7, $54, $d7, $54, $d7, $54, $de, $54, $ff, $ff, $3b, $55, $7c, $6e, $d2, $6d
	db $11, $54, $a0, $6e, $15, $6d, $ac, $6e, $27, $6d, $40, $6e, $2a, $54, $3b, $54
	db $2a, $6d, $3b, $54, $40, $6e, $50, $54, $3b, $54, $40, $6e, $61, $54, $3b, $54
	db $40, $6e, $2a, $54, $3b, $54, $2a, $6d, $3b, $54, $40, $6e, $50, $54, $3b, $54
	db $40, $6e, $61, $54, $3b, $54, $91, $6e, $40, $6e, $72, $54, $3b, $54, $2a, $6d
	db $3b, $54, $f0, $6d, $7c, $6e, $ab, $54, $94, $6e, $ab, $54, $8e, $6e, $ba, $54
	db $7c, $6e, $f0, $6d, $c2, $54, $40, $6e, $2a, $54, $3b, $54, $2a, $6d, $3b, $54
	db $40, $6e, $50, $54, $3b, $54, $40, $6e, $61, $54, $3b, $54, $40, $6e, $2a, $54
	db $3b, $54, $2a, $6d, $3b, $54, $40, $6e, $50, $54, $3b, $54, $40, $6e, $61, $54
	db $3b, $54, $91, $6e, $40, $6e, $72, $54, $3b, $54, $2a, $6d, $3b, $54, $f0, $6d
	db $7c, $6e, $ab, $54, $94, $6e, $ab, $54, $8e, $6e, $ba, $54, $7c, $6e, $e1, $6d
	db $c2, $54, $ff, $ff, $31, $55, $54, $6e, $1d, $54, $a0, $6e, $15, $6d, $ac, $6e
	db $27, $6d, $59, $6e, $82, $54, $f3, $54, $54, $6e, $08, $55, $59, $6e, $82, $54
	db $f3, $54, $54, $6e, $08, $55, $ff, $ff, $45, $55, $18, $55, $a0, $6e, $2d, $60
	db $ac, $6e, $1d, $55, $20, $55, $ff, $ff, $c8, $53, $a2, $4e, $4c, $4a, $48, $4e
	db $50, $52, $54, $a3, $01, $00, $9b, $06, $a0, $48, $46, $9c, $9b, $0a, $46, $44
	db $9c, $9d, $68, $00, $81, $9b, $06, $44, $42, $9c, $9b, $0a, $42, $40, $9c, $9d
	db $a8, $00, $81, $9b, $06, $a0, $4c, $4a, $9c, $9b, $0a, $4a, $48, $9c, $9d, $78
	db $00, $81, $9b, $06, $48, $46, $9c, $9b, $0a, $46, $44, $9c, $00, $a2, $54, $52
	db $50, $4e, $54, $56, $58, $5a, $a3, $01, $00, $99, $a2, $5a, $58, $56, $54, $5a
	db $5c, $5e, $60, $a3, $01, $00, $a1, $40, $44, $01, $a5, $46, $a7, $01, $a1, $40
	db $44, $01, $46, $a2, $01, $4c, $00, $9d, $92, $00, $c0, $a1, $10, $01, $10, $28
	db $01, $1a, $1c, $01, $10, $01, $12, $01, $12, $04, $01, $00, $a1, $01, $a2, $5e
	db $a1, $01, $5e, $01, $a9, $5e, $a0, $01, $a4, $5e, $a2, $01, $00, $a1, $01, $a2
	db $64, $a1, $01, $64, $01, $a9, $64, $a0, $01, $a4, $64, $a2, $01, $00, $a1, $40
	db $44, $01, $a5, $46, $a4, $01, $a1, $01, $40, $44, $46, $50, $4e, $00, $9b, $14
	db $99, $a1, $32, $32, $01, $32, $4a, $01, $3c, $3e, $01, $32, $01, $34, $01, $34
	db $26, $01, $9c, $00, $a1, $04, $9b, $7f, $02, $9c, $a1, $04, $9b, $7f, $02, $9c
	db $a1, $04, $9b, $3f, $02, $9c, $00, $a1, $52, $52, $52, $50, $a3, $01, $a1, $4e
	db $01, $01, $4c, $a3, $01, $00, $a1, $52, $52, $52, $50, $a8, $01, $00, $a1, $46
	db $46, $01, $46, $01, $46, $01, $50, $01, $50, $a2, $50, $97, $a1, $01, $36, $2c
	db $24, $98, $00, $a1, $10, $9b, $0f, $0e, $9c, $00, $a1, $3c, $3c, $01, $3c, $01
	db $3c, $01, $3c, $01, $46, $a2, $46, $97, $a1, $01, $2c, $24, $1e, $98, $00, $9b
	db $03, $a1, $3e, $3e, $01, $3e, $56, $01, $48, $4a, $01, $3e, $01, $40, $01, $40
	db $32, $01, $9c, $00, $a1, $32, $32, $01, $32, $01, $32, $01, $3c, $01, $3c, $3c
	db $01, $a3, $01, $00, $a5, $01, $a3, $01, $00, $a6, $01, $00, $9b, $02, $a1, $1a
	db $1a, $1a, $15, $9c, $1a, $1a, $15, $1a, $1a, $1a, $1a, $1a, $00, $51, $55, $51
	db $55, $61, $55, $ff, $ff, $fe, $52, $7c, $55, $7c, $55, $a8, $55, $ff, $ff, $d6
	db $52, $59, $6e, $ec, $55, $ec, $55, $15, $56, $ff, $ff, $a6, $53, $9d, $c4, $83
	db $80, $a1, $04, $9b, $1f, $02, $9c, $0a, $9b, $1f, $08, $9c, $00, $a1, $10, $9b
	db $0d, $0e, $9c, $10, $12, $9b, $0f, $14, $9c, $10, $9b, $0e, $0e, $9c, $10, $12
	db $9b, $07, $14, $9c, $16, $a4, $01, $00, $9d, $84, $86, $80, $9b, $02, $a1, $10
	db $10, $01, $10, $28, $01, $1a, $1c, $01, $10, $01, $12, $01, $12, $04, $01, $9c
	db $9b, $02, $16, $16, $01, $16, $2e, $01, $20, $22, $01, $16, $01, $18, $01, $18
	db $0c, $01, $9c, $00, $a1, $1c, $1c, $01, $1c, $34, $01, $26, $2a, $01, $1c, $9b
	db $02, $01, $1e, $9c, $12, $01, $22, $22, $01, $22, $3a, $01, $2c, $2e, $01, $22
	db $9b, $02, $01, $24, $9c, $18, $01, $1c, $1c, $01, $1c, $34, $01, $26, $2a, $01
	db $1c, $9b, $02, $01, $1e, $9c, $12, $01, $a2, $22, $22, $3a, $a1, $24, $26, $01
	db $26, $a6, $3e, $a1, $26, $0e, $26, $00, $9b, $02, $99, $a1, $32, $32, $01, $32
	db $4a, $01, $3c, $3e, $01, $32, $01, $34, $01, $34, $26, $01, $9c, $9b, $02, $38
	db $38, $01, $38, $50, $01, $42, $44, $01, $38, $01, $3a, $01, $3a, $2e, $01, $9c
	db $00, $a1, $3e, $3e, $01, $3e, $56, $01, $48, $4c, $01, $3e, $01, $40, $01, $40
	db $34, $01, $44, $44, $01, $44, $5c, $01, $4e, $50, $01, $44, $01, $46, $01, $46
	db $3a, $01, $3e, $3e, $01, $3e, $56, $01, $48, $4c, $01, $3e, $01, $40, $01, $40
	db $34, $01, $a2, $44, $44, $5c, $a1, $46, $48, $01, $48, $a6, $60, $a1, $48, $30
	db $48, $00, $00, $f2, $4a, $61, $56, $6d, $56, $93, $56, $00, $00, $e1, $6d, $a7
	db $56, $20, $6d, $20, $6d, $ff, $ff, $45, $57, $9b, $6d, $bc, $56, $45, $6e, $c7
	db $56, $9b, $6d, $d2, $56, $bc, $56, $45, $6e, $c7, $56, $9b, $6d, $d2, $56, $27
	db $6e, $e3, $56, $9b, $6d, $d2, $56, $82, $6d, $ed, $56, $ff, $ff, $5f, $57, $59
	db $6e, $f9, $56, $f9, $56, $54, $6e, $35, $57, $59, $6e, $24, $57, $24, $57, $ff
	db $ff, $91, $57, $9b, $10, $a5, $01, $9c, $a3, $01, $a1, $0c, $18, $24, $30, $3c
	db $48, $54, $60, $a5, $01, $a3, $01, $00, $9b, $02, $a2, $6a, $70, $6e, $74, $ae
	db $01, $9c, $00, $a1, $3a, $40, $3e, $44, $a4, $50, $01, $a8, $01, $00, $a8, $01
	db $a2, $01, $a1, $78, $76, $9b, $0d, $a0, $78, $76, $9c, $78, $a3, $01, $00, $a1
	db $6a, $70, $78, $76, $a5, $7e, $a8, $01, $00, $a3, $01, $9b, $0d, $a0, $78, $76
	db $9c, $78, $a5, $01, $00, $99, $a2, $0a, $01, $a4, $01, $a6, $01, $a1, $0a, $0a
	db $a6, $01, $a8, $01, $a2, $0a, $0a, $a4, $01, $a6, $01, $a1, $0a, $a2, $0a, $01
	db $a8, $01, $a2, $0a, $01, $a4, $01, $a6, $01, $a1, $0a, $a2, $0a, $01, $a8, $01
	db $99, $a2, $0a, $0a, $a4, $01, $a6, $01, $a1, $0a, $0a, $0a, $a8, $01, $a2, $0a
	db $00, $9a, $a1, $0a, $10, $18, $16, $a5, $1e, $a4, $01, $a1, $20, $18, $10, $0a
	db $00, $36, $6e, $b1, $57, $40, $6e, $db, $57, $9b, $6d, $b4, $6e, $08, $58, $e1
	db $6d, $a7, $56, $20, $6d, $20, $6d, $ff, $ff, $61, $56, $36, $6e, $14, $58, $40
	db $6e, $3e, $58, $b4, $6e, $15, $6d, $9b, $6d, $bc, $56, $45, $6e, $c7, $56, $9b
	db $6d, $d2, $56, $bc, $56, $45, $6e, $c7, $56, $9b, $6d, $d2, $56, $27, $6e, $e3
	db $56, $9b, $6d, $d2, $56, $82, $6d, $ed, $56, $ff, $ff, $6d, $56, $63, $6e, $6b
	db $58, $54, $6e, $9b, $58, $b4, $6e, $15, $6d, $59, $6e, $f9, $56, $f9, $56, $54
	db $6e, $35, $57, $59, $6e, $24, $57, $24, $57, $ff, $ff, $93, $56, $a2, $18, $1c
	db $a4, $1e, $a3, $01, $a2, $18, $1c, $a7, $1e, $a2, $28, $26, $18, $a4, $1c, $ae
	db $01, $a2, $18, $1c, $a4, $1e, $a3, $01, $a2, $18, $1c, $a7, $1e, $a2, $26, $30
	db $2e, $a4, $2e, $01, $a5, $01, $00, $a1, $30, $32, $a4, $34, $a2, $01, $a1, $30
	db $32, $34, $a6, $01, $a3, $40, $a1, $3e, $3c, $48, $4a, $a4, $4c, $a1, $4e, $01
	db $48, $4a, $4c, $4e, $a2, $01, $a3, $58, $a1, $56, $54, $52, $54, $56, $48, $4a
	db $01, $a7, $01, $00, $a7, $01, $a1, $78, $76, $9b, $09, $a0, $78, $76, $9c, $00
	db $a2, $22, $26, $a4, $28, $a3, $01, $a2, $22, $26, $a7, $28, $a2, $32, $30, $22
	db $a4, $24, $ae, $01, $a2, $22, $26, $a4, $28, $a3, $01, $a2, $22, $26, $a7, $28
	db $a2, $30, $3a, $38, $a4, $36, $01, $a5, $01, $00, $a1, $3a, $3c, $a4, $3e, $a2
	db $01, $a1, $3a, $3c, $3e, $a6, $01, $a3, $4a, $a1, $48, $46, $52, $54, $a4, $56
	db $a1, $58, $01, $52, $54, $56, $58, $a2, $01, $a3, $4a, $a1, $60, $5e, $6a, $6c
	db $6e, $60, $62, $01, $a7, $01, $00, $9b, $02, $99, $a2, $0a, $0a, $a8, $01, $9c
	db $9b, $02, $a2, $06, $06, $a8, $01, $9c, $9b, $02, $a2, $0a, $0a, $01, $0a, $01
	db $0a, $a1, $0a, $0a, $0a, $0a, $9c, $9b, $02, $a2, $1a, $1a, $01, $1a, $01, $1a
	db $a1, $1a, $1a, $1a, $1a, $9c, $00, $9b, $04, $a1, $0a, $9c, $22, $9b, $07, $0a
	db $9c, $9b, $04, $0a, $9c, $22, $9b, $07, $0a, $9c, $9b, $04, $0a, $9c, $22, $9b
	db $07, $0a, $9c, $9b, $04, $0a, $9c, $22, $9b, $07, $0a, $9c, $22, $24, $26, $18
	db $1a, $01, $a7, $01, $00, $00, $c5, $4a, $d4, $58, $ee, $58, $0c, $59, $00, $00
	db $27, $6d, $78, $6d, $18, $59, $21, $59, $18, $59, $09, $6e, $29, $59, $31, $59
	db $31, $59, $31, $59, $31, $59, $ff, $ff, $d6, $58, $09, $6e, $18, $59, $21, $59
	db $c3, $6d, $18, $59, $29, $59, $a5, $6d, $31, $59, $31, $59, $c3, $6d, $31, $59
	db $09, $6e, $31, $59, $ff, $ff, $ee, $58, $54, $6e, $6e, $59, $39, $59, $61, $59
	db $ff, $ff, $0c, $59, $9b, $04, $a2, $48, $4c, $54, $58, $9c, $00, $9b, $04, $44
	db $48, $50, $54, $9c, $00, $9b, $04, $4a, $4e, $56, $5a, $9c, $00, $9b, $02, $4c
	db $50, $56, $5c, $9c, $00, $99, $a7, $18, $a2, $18, $a5, $01, $a7, $01, $a2, $16
	db $a7, $14, $a2, $14, $a5, $01, $a7, $01, $a2, $14, $a7, $0a, $a2, $0a, $a5, $01
	db $a7, $01, $a2, $0a, $02, $02, $01, $02, $a5, $01, $a7, $01, $00, $9b, $04, $a2
	db $04, $9c, $ae, $01, $01, $a4, $01, $a2, $18, $00, $9b, $0c, $a5, $01, $9c, $00
	db $00, $b6, $4a, $17, $4b, $7f, $59, $2f, $5a, $00, $00, $13, $6e, $7c, $6e, $47
	db $5a, $51, $5a, $1d, $6e, $94, $6e, $47, $5a, $51, $5a, $fa, $6d, $8b, $6e, $47
	db $5a, $88, $6e, $47, $5a, $e6, $6d, $85, $6e, $47, $5a, $20, $6d, $7c, $6e, $13
	db $6e, $7c, $6e, $47, $5a, $51, $5a, $1d, $6e, $94, $6e, $47, $5a, $51, $5a, $fa
	db $6d, $8b, $6e, $47, $5a, $88, $6e, $47, $5a, $e6, $6d, $85, $6e, $47, $5a, $20
	db $6d, $7c, $6e, $9b, $6d, $77, $5a, $8c, $6d, $7e, $5a, $91, $6d, $84, $5a, $9b
	db $6d, $84, $5a, $84, $5a, $82, $6d, $84, $5a, $9b, $6d, $8a, $5a, $8c, $6d, $90
	db $5a, $91, $6d, $84, $5a, $9b, $6d, $84, $5a, $84, $5a, $82, $6d, $84, $5a, $94
	db $6e, $9b, $6d, $77, $5a, $8c, $6d, $7e, $5a, $91, $6d, $84, $5a, $9b, $6d, $84
	db $5a, $84, $5a, $82, $6d, $84, $5a, $9b, $6d, $8a, $5a, $8c, $6d, $90, $5a, $91
	db $6d, $84, $5a, $9b, $6d, $84, $5a, $84, $5a, $82, $6d, $84, $5a, $7c, $6e, $b9
	db $6d, $3f, $5a, $27, $6e, $96, $5a, $ff, $ff, $7f, $59, $5e, $6e, $6a, $5a, $9f
	db $5a, $59, $6e, $3f, $5a, $96, $5a, $ff, $ff, $2f, $5a, $a2, $18, $1c, $1e, $14
	db $18, $1a, $00, $a3, $30, $34, $36, $a4, $44, $18, $a3, $01, $00, $30, $34, $36
	db $a4, $42, $18, $a3, $01, $30, $34, $36, $a4, $40, $18, $a3, $01, $30, $34, $36
	db $a4, $42, $18, $a3, $01, $00, $9b, $18, $99, $a3, $18, $18, $a5, $01, $a3, $01
	db $18, $9c, $00, $9b, $0c, $a1, $24, $2c, $9c, $00, $9b, $04, $24, $2c, $9c, $00
	db $9b, $04, $22, $2a, $9c, $00, $9b, $0c, $20, $28, $9c, $00, $9b, $04, $20, $28
	db $9c, $00, $a2, $01, $ae, $0c, $a5, $01, $a7, $01, $00, $9b, $08, $99, $a3, $18
	db $18, $01, $18, $01, $a4, $30, $a3, $18, $9c, $00, $00, $b6, $4a, $b9, $5a, $d5
	db $5a, $b1, $5b, $00, $00, $82, $6d, $df, $5b, $9b, $6d, $df, $5b, $df, $5b, $00
	db $5c, $8c, $6d, $0b, $5c, $0b, $5c, $0b, $5c, $7c, $6e, $0b, $5c, $ff, $ff, $b9
	db $5a, $82, $6d, $2f, $5c, $2f, $5c, $9b, $6d, $2f, $5c, $82, $6d, $2f, $5c, $82
	db $6d, $35, $5c, $35, $5c, $9b, $6d, $35, $5c, $82, $6d, $35, $5c, $82, $6d, $3a
	db $5c, $3a, $5c, $9b, $6d, $3a, $5c, $82, $6d, $3a, $5c, $82, $6d, $3f, $5c, $3f
	db $5c, $9b, $6d, $3f, $5c, $82, $6d, $3f, $5c, $82, $6d, $2f, $5c, $9b, $6d, $2f
	db $5c, $8c, $6d, $2f, $5c, $82, $6d, $2f, $5c, $82, $6d, $35, $5c, $9b, $6d, $35
	db $5c, $8c, $6d, $35, $5c, $82, $6d, $35, $5c, $82, $6d, $3a, $5c, $9b, $6d, $3a
	db $5c, $8c, $6d, $3a, $5c, $82, $6d, $3a, $5c, $82, $6d, $3f, $5c, $9b, $6d, $3f
	db $5c, $8c, $6d, $3f, $5c, $82, $6d, $3f, $5c, $82, $6d, $2f, $5c, $9b, $6d, $2f
	db $5c, $8c, $6d, $2f, $5c, $82, $6d, $2f, $5c, $82, $6d, $35, $5c, $9b, $6d, $35
	db $5c, $8c, $6d, $35, $5c, $82, $6d, $35, $5c, $82, $6d, $3a, $5c, $9b, $6d, $3a
	db $5c, $8c, $6d, $3a, $5c, $82, $6d, $3a, $5c, $82, $6d, $3f, $5c, $9b, $6d, $3f
	db $5c, $8c, $6d, $3f, $5c, $82, $6d, $3f, $5c, $82, $6d, $44, $5c, $8c, $6d, $44
	db $5c, $9b, $6d, $49, $5c, $8c, $6d, $49, $5c, $20, $6d, $20, $6d, $9b, $6d, $4e
	db $5c, $94, $6e, $4e, $5c, $20, $6d, $20, $6d, $ff, $ff, $d5, $5a, $67, $5d, $15
	db $6d, $20, $6d, $20, $6d, $20, $6d, $63, $6e, $5e, $5c, $72, $6e, $8d, $5c, $6d
	db $6e, $a1, $5c, $72, $6e, $8d, $5c, $6d, $6e, $a1, $5c, $18, $6d, $6d, $6e, $96
	db $5c, $77, $6e, $a1, $5c, $18, $6d, $ff, $ff, $b1, $5b, $a5, $01, $a3, $01, $9b
	db $04, $a2, $54, $9c, $ae, $01, $9b, $04, $a2, $52, $9c, $ae, $01, $9b, $04, $a2
	db $58, $9c, $ae, $01, $9b, $04, $a2, $56, $9c, $a3, $01, $00, $a8, $01, $a2, $01
	db $5e, $a8, $01, $a2, $01, $60, $00, $9b, $03, $a2, $02, $08, $04, $0c, $9c, $9d
	db $a2, $83, $c0, $02, $08, $04, $0c, $9d, $c2, $83, $c0, $02, $08, $04, $0c, $9d
	db $81, $83, $c0, $9b, $03, $02, $08, $04, $0c, $9c, $00, $9b, $04, $a2, $60, $9c
	db $00, $9b, $04, $5e, $9c, $00, $9b, $04, $64, $9c, $00, $9b, $04, $62, $9c, $00
	db $9b, $04, $6a, $9c, $00, $9b, $04, $6c, $9c, $00, $a2, $30, $34, $36, $44, $a5
	db $01, $a2, $01, $42, $34, $42, $a5, $01, $01, $00, $99, $a2, $18, $1c, $1e, $2c
	db $ae, $01, $a2, $18, $1c, $1e, $2a, $ae, $01, $a2, $1c, $20, $22, $30, $ae, $01
	db $a2, $1c, $20, $22, $2e, $ae, $01, $a2, $26, $2a, $2c, $3a, $a4, $01, $a2, $28
	db $2c, $2e, $3c, $9b, $09, $a4, $01, $9c, $00, $a3, $01, $a2, $60, $64, $66, $74
	db $a3, $01, $a5, $01, $9b, $03, $a2, $5a, $60, $5e, $62, $9c, $00, $a2, $5a, $60
	db $5e, $62, $00, $00, $d4, $4a, $b2, $5c, $00, $5d, $2c, $5d, $00, $00, $09, $6e
	db $6d, $5d, $13, $6e, $6d, $5d, $cd, $6d, $6d, $5d, $13, $6e, $6d, $5d, $87, $6d
	db $75, $5d, $09, $6e, $6d, $5d, $6d, $5d, $18, $6d, $24, $6d, $24, $6d, $2d, $6d
	db $09, $6e, $6d, $5d, $13, $6e, $6d, $5d, $cd, $6d, $6d, $5d, $13, $6e, $6d, $5d
	db $87, $6d, $86, $5d, $0e, $6e, $6d, $5d, $13, $6e, $6d, $5d, $cd, $6d, $6d, $5d
	db $24, $6d, $24, $6d, $0e, $6e, $98, $5d, $ff, $ff, $b2, $5c, $45, $6e, $36, $5d
	db $13, $6e, $4d, $5d, $09, $6e, $6d, $5d, $13, $6e, $6d, $5d, $09, $6e, $6d, $5d
	db $2d, $6d, $2d, $6d, $09, $6e, $6d, $5d, $0e, $6e, $6d, $5d, $13, $6e, $6d, $5d
	db $2d, $6d, $2d, $6d, $ff, $ff, $00, $5d, $5e, $6e, $36, $5d, $67, $5d, $ff, $ff
	db $2c, $5d, $a4, $18, $a3, $1c, $1e, $a5, $16, $9b, $04, $01, $9c, $a4, $18, $a3
	db $1c, $1e, $a5, $24, $9b, $04, $01, $9c, $00, $a4, $60, $a3, $64, $66, $a4, $74
	db $5e, $a3, $62, $64, $a4, $72, $6e, $a3, $72, $74, $a4, $82, $70, $a3, $74, $76
	db $a4, $84, $00, $9b, $09, $a5, $01, $9c, $00, $aa, $48, $54, $56, $60, $56, $54
	db $00, $a1, $01, $ad, $01, $a3, $01, $74, $72, $01, $74, $72, $a4, $01, $a2, $74
	db $72, $00, $a1, $01, $ad, $01, $01, $a3, $01, $7a, $78, $01, $7a, $78, $a4, $01
	db $a2, $7a, $78, $00, $a0, $01, $01, $9b, $03, $a3, $48, $3c, $9c, $9b, $03, $46
	db $3a, $9c, $9b, $03, $3e, $32, $9c, $9b, $06, $40, $34, $9c, $ae, $01, $00, $00
	db $b6, $4a, $be, $5d, $c6, $5d, $17, $4b, $00, $00, $09, $6e, $d6, $5d, $ff, $ff
	db $be, $5d, $0e, $6e, $20, $5e, $13, $6e, $4d, $5e, $cd, $6d, $5f, $5e, $ff, $ff
	db $c6, $5d, $a3, $01, $a2, $48, $4c, $4e, $5c, $01, $6c, $6c, $a4, $01, $a2, $01
	db $48, $4c, $4e, $5a, $01, $6a, $6a, $a4, $01, $a2, $01, $4c, $50, $52, $60, $01
	db $70, $70, $a4, $01, $a2, $01, $4c, $50, $52, $5e, $01, $6e, $6e, $a4, $01, $a2
	db $01, $56, $5a, $5c, $6a, $01, $76, $a3, $01, $a2, $58, $5c, $5e, $6c, $01, $78
	db $a3, $01, $a2, $60, $64, $84, $82, $80, $7e, $ae, $01, $00, $a2, $48, $4c, $4e
	db $5c, $a7, $01, $a2, $78, $a4, $78, $a2, $48, $4c, $4e, $5a, $a7, $01, $a2, $76
	db $a4, $76, $a2, $4c, $50, $52, $60, $a7, $01, $a2, $7c, $a4, $7c, $a2, $4c, $50
	db $52, $5e, $a7, $01, $a2, $7a, $a4, $7a, $00, $a2, $56, $5a, $5c, $6a, $a7, $01
	db $a2, $82, $58, $5c, $5e, $6c, $a7, $01, $a2, $84, $00, $60, $64, $66, $8c, $8a
	db $88, $86, $84, $ae, $01, $00, $00, $e3, $4a, $89, $5e, $75, $5e, $93, $5e, $00
	db $00, $aa, $6d, $9b, $5e, $af, $6d, $ad, $5e, $b4, $6d, $be, $5e, $af, $6d, $cf
	db $5e, $ff, $ff, $75, $5e, $10, $6d, $7d, $6d, $9b, $5e, $ff, $ff, $8b, $5e, $54
	db $6e, $e0, $5e, $ff, $ff, $93, $5e, $a2, $2c, $26, $20, $1a, $14, $0e, $08, $04
	db $02, $08, $0e, $14, $1a, $20, $26, $2c, $00, $2e, $26, $20, $1a, $16, $0e, $08
	db $04, $02, $08, $0e, $16, $1a, $20, $26, $2e, $00, $30, $26, $20, $1a, $18, $0e
	db $08, $04, $02, $08, $0e, $18, $1a, $20, $26, $30, $00, $2e, $26, $20, $1a, $16
	db $0e, $08, $04, $02, $08, $0e, $16, $1a, $20, $26, $2e, $00, $99, $a8, $01, $a2
	db $01, $02, $02, $01, $a8, $01, $a5, $01, $01, $00, $00, $d4, $4a, $f9, $5e, $05
	db $5f, $00, $00, $00, $00, $10, $6d, $7d, $6d, $19, $5f, $19, $5f, $ff, $ff, $fb
	db $5e, $09, $6e, $19, $5f, $0e, $6e, $2b, $5f, $13, $6e, $19, $5f, $22, $6e, $2b
	db $5f, $ff, $ff, $0d, $5f, $a1, $48, $44, $3e, $38, $30, $2c, $26, $20, $18, $20
	db $26, $2c, $30, $38, $3e, $44, $00, $4c, $48, $44, $3e, $38, $30, $2c, $26, $20
	db $26, $2c, $34, $3e, $44, $4c, $50, $00, $00, $98, $4a, $47, $5f, $5d, $5f, $77
	db $5f, $8b, $5f, $4f, $6e, $03, $60, $c8, $6d, $9d, $5f, $27, $6e, $bc, $5f, $c8
	db $6d, $9d, $5f, $20, $6d, $ff, $ff, $47, $5f, $4f, $6e, $f1, $5f, $c8, $6d, $c7
	db $5f, $27, $6e, $e6, $5f, $8e, $6e, $c8, $6d, $c7, $5f, $20, $6d, $7c, $6e, $ff
	db $ff, $5d, $5f, $15, $6d, $5e, $6e, $15, $60, $59, $6e, $22, $60, $5e, $6e, $15
	db $60, $20, $6d, $ff, $ff, $77, $5f, $2d, $60, $30, $60, $30, $60, $48, $60, $30
	db $60, $30, $60, $53, $60, $ff, $ff, $8b, $5f, $9b, $02, $a2, $22, $22, $22, $20
	db $a4, $01, $a7, $1e, $1c, $a3, $01, $9c, $9b, $02, $a2, $26, $26, $26, $24, $a4
	db $01, $a7, $22, $20, $a3, $01, $9c, $00, $a7, $48, $46, $a2, $48, $4a, $4c, $a1
	db $4e, $01, $00, $9b, $02, $a2, $30, $30, $30, $2e, $a4, $01, $a7, $2c, $2a, $a3
	db $01, $9c, $9b, $02, $a2, $34, $34, $34, $32, $a4, $01, $a7, $30, $2e, $a3, $01
	db $9c, $00, $a7, $52, $50, $a2, $52, $54, $56, $a1, $58, $01, $00, $a1, $6c, $6a
	db $68, $66, $64, $62, $60, $5e, $5c, $5a, $58, $56, $54, $52, $50, $4e, $00, $a1
	db $66, $64, $62, $60, $5e, $5c, $5a, $58, $56, $54, $52, $50, $4e, $4c, $4a, $48
	db $00, $9b, $10, $99, $a2, $18, $0e, $9c, $9b, $10, $04, $1c, $9c, $00, $9a, $a7
	db $32, $30, $a2, $32, $34, $36, $99, $38, $00, $a5, $01, $00, $9b, $04, $a2, $15
	db $15, $ff, $01, $9c, $9b, $02, $15, $15, $ff, $15, $9c, $1a, $ff, $15, $ff, $9b
	db $04, $ff, $9c, $00, $9b, $02, $ff, $1a, $1a, $9c, $9b, $04, $ff, $9c, $00, $1a
	db $1a, $01, $15, $15, $01, $ff, $ff, $9b, $04, $15, $9c, $9b, $04, $1a, $9c, $00
	db $00, $a7, $4a, $6f, $60, $79, $60, $7f, $60, $00, $00, $09, $6e, $24, $6d, $27
	db $6d, $87, $60, $00, $00, $cd, $6d, $87, $60, $00, $00, $77, $6e, $27, $6d, $87
	db $60, $00, $00, $9b, $02, $a1, $90, $8a, $82, $7c, $78, $72, $6a, $64, $60, $5a
	db $52, $4c, $48, $42, $3a, $34, $8e, $88, $82, $7a, $76, $70, $6a, $62, $5e, $58
	db $52, $4a, $46, $40, $3a, $32, $9c, $2e, $28, $22, $1a, $16, $10, $0a, $02, $a6
	db $48, $56, $5c, $64, $01, $a2, $60, $a1, $68, $6e, $a5, $78, $01, $00, $00, $c5
	db $4a, $cd, $60, $d9, $60, $17, $4b, $00, $00, $09, $6e, $03, $60, $10, $6d, $e3
	db $60, $ff, $ff, $d3, $60, $09, $6e, $9d, $6e, $f1, $5f, $ff, $ff, $d3, $60, $a2
	db $28, $30, $36, $3e, $a3, $6e, $01, $a2, $60, $28, $30, $36, $60, $64, $66, $6a
	db $26, $34, $a3, $6a, $5c, $74, $a2, $52, $4c, $44, $3e, $3a, $34, $2c, $26, $22
	db $28, $30, $36, $a3, $66, $01, $a2, $58, $22, $28, $30, $58, $5c, $60, $64, $1e
	db $2c, $a3, $64, $56, $6e, $a2, $4c, $44, $3e, $36, $34, $2c, $26, $1e, $00, $00
	db $a7, $4a, $2e, $61, $34, $61, $48, $61, $00, $00, $54, $61, $ff, $ff, $2e, $61
	db $8f, $61, $e3, $60, $7c, $6e, $9d, $61, $96, $61, $e2, $61, $7c, $6e, $26, $62
	db $ff, $ff, $34, $61, $68, $6e, $67, $62, $6d, $6e, $67, $62, $ff, $ff, $48, $61
	db $9d, $32, $83, $80, $9b, $04, $a2, $48, $01, $48, $48, $9c, $9b, $04, $44, $01
	db $44, $44, $9c, $9b, $04, $40, $01, $40, $40, $9c, $9b, $04, $3e, $01, $3e, $3e
	db $9c, $9b, $04, $30, $01, $30, $30, $9c, $9b, $04, $2c, $01, $2c, $2c, $9c, $9b
	db $07, $2e, $01, $2e, $2e, $9c, $2c, $01, $2c, $2c, $00, $9d, $67, $86, $80, $9f
	db $e8, $00, $9d, $47, $86, $80, $9f, $e8, $00, $a2, $10, $18, $1e, $26, $a3, $56
	db $a2, $58, $5c, $a3, $60, $a2, $10, $1e, $28, $30, $5c, $58, $5c, $06, $1e, $58
	db $a3, $56, $a2, $52, $4e, $06, $0e, $14, $1e, $a4, $4e, $a2, $0c, $16, $1a, $1e
	db $54, $5e, $62, $a3, $66, $a2, $16, $0c, $24, $2e, $3c, $62, $5e, $a7, $62, $a2
	db $70, $0a, $16, $1a, $28, $a7, $6e, $a2, $7a, $08, $14, $1a, $26, $00, $a2, $28
	db $30, $36, $3e, $a3, $6e, $01, $a2, $60, $28, $30, $36, $01, $86, $78, $90, $a2
	db $8c, $4c, $4e, $52, $a3, $56, $a2, $58, $a4, $5c, $a2, $3e, $3a, $34, $3e, $44
	db $3a, $40, $48, $4e, $a3, $4e, $01, $a2, $40, $22, $28, $30, $40, $44, $48, $4c
	db $30, $34, $36, $3e, $a3, $4e, $a2, $52, $a7, $56, $a2, $01, $48, $4e, $56, $58
	db $5c, $00, $a4, $48, $a2, $10, $18, $1e, $26, $28, $30, $36, $3e, $48, $4c, $4e
	db $52, $a7, $44, $a2, $5c, $26, $2c, $30, $34, $36, $6e, $66, $74, $8c, $26, $2c
	db $36, $a7, $76, $a2, $8e, $3c, $46, $4a, $a3, $4e, $a2, $16, $0c, $24, $2e, $3c
	db $4a, $46, $a7, $4a, $a2, $58, $22, $24, $28, $2e, $a7, $56, $a2, $62, $38, $3e
	db $44, $4a, $00, $9b, $04, $99, $a2, $40, $01, $40, $40, $9c, $9b, $04, $3e, $01
	db $3e, $3e, $9c, $9b, $04, $3a, $01, $3a, $3a, $9c, $9b, $04, $30, $01, $30, $30
	db $9c, $9b, $04, $28, $01, $28, $28, $9c, $9b, $04, $26, $01, $26, $26, $9c, $9b
	db $04, $24, $01, $24, $24, $9c, $9b, $02, $22, $01, $22, $22, $9c, $9b, $02, $20
	db $01, $20, $20, $9c, $00, $00, $b6, $4a, $b4, $62, $d0, $62, $17, $4b, $00, $00
	db $7d, $6d, $10, $6d, $f2, $62, $09, $6e, $f2, $62, $04, $63, $2d, $6d, $a8, $6e
	db $7d, $6d, $47, $51, $47, $51, $47, $51, $20, $6d, $00, $00, $f0, $6d, $f2, $62
	db $e1, $6d, $94, $6e, $f2, $62, $13, $6e, $7c, $6e, $04, $63, $22, $6e, $a8, $6e
	db $47, $51, $cd, $6d, $47, $51, $0e, $6e, $47, $51, $20, $6d, $00, $00, $a1, $2e
	db $34, $3c, $44, $46, $4c, $54, $5c, $2c, $32, $3a, $42, $44, $42, $3a, $32, $00
	db $a1, $38, $3e, $46, $4e, $50, $56, $5e, $66, $00, $00, $d4, $4a, $19, $63, $29
	db $63, $55, $63, $00, $00, $a0, $6d, $c7, $63, $3b, $6e, $e7, $63, $a0, $6d, $18
	db $64, $ff, $ff, $19, $63, $aa, $6d, $65, $63, $aa, $6d, $65, $63, $aa, $6d, $8b
	db $63, $aa, $6d, $65, $63, $aa, $6d, $65, $63, $aa, $6d, $65, $63, $aa, $6d, $8b
	db $63, $af, $6d, $a9, $63, $aa, $6d, $8b, $63, $af, $6d, $a9, $63, $ff, $ff, $29
	db $63, $6d, $6e, $33, $64, $6d, $6e, $54, $64, $6d, $6e, $5a, $64, $ff, $ff, $55
	db $63, $a2, $02, $0e, $04, $0c, $01, $04, $9d, $92, $00, $c0, $02, $0e, $04, $0c
	db $01, $04, $9d, $b2, $00, $c0, $02, $0e, $04, $0c, $01, $04, $9d, $92, $00, $c0
	db $02, $0e, $04, $0c, $01, $04, $00, $9b, $02, $02, $0e, $04, $0c, $01, $04, $9c
	db $9d, $92, $00, $c0, $02, $0e, $04, $0c, $01, $04, $9d, $b2, $00, $c0, $02, $0e
	db $04, $0c, $01, $04, $00, $02, $0e, $04, $0c, $01, $04, $9d, $92, $00, $c0, $02
	db $0e, $04, $0c, $01, $04, $9d, $62, $00, $c0, $9b, $02, $02, $0e, $04, $0c, $01
	db $04, $9c, $00, $ae, $01, $01, $9b, $02, $a1, $32, $32, $32, $32, $34, $32, $a2
	db $32, $ae, $01, $a8, $01, $a2, $01, $4a, $a1, $32, $32, $a7, $01, $a5, $01, $ae
	db $01, $9c, $00, $a1, $01, $50, $54, $56, $64, $a3, $5e, $a1, $5e, $62, $01, $ae
	db $01, $a4, $01, $a1, $68, $62, $5e, $5c, $ae, $01, $a9, $2c, $a0, $01, $a1, $2c
	db $a7, $01, $a5, $01, $a1, $62, $5e, $52, $50, $a5, $01, $01, $a4, $01, $a2, $30
	db $a1, $32, $01, $00, $a1, $2c, $2c, $2c, $2c, $2e, $2c, $a2, $2c, $ae, $01, $a5
	db $01, $a1, $22, $22, $22, $22, $24, $22, $a2, $22, $a5, $01, $ae, $01, $00, $99
	db $ae, $01, $01, $9b, $02, $a1, $2e, $2e, $2e, $2e, $30, $2e, $a2, $2e, $ae, $01
	db $a8, $01, $a2, $01, $46, $a1, $2e, $2e, $a7, $01, $ae, $01, $a5, $01, $9c, $00
	db $9b, $0c, $a8, $01, $9c, $00, $a1, $24, $24, $24, $24, $26, $24, $24, $01, $a5
	db $01, $ae, $01, $a1, $1a, $1a, $1a, $1a, $34, $1a, $1a, $01, $a5, $01, $ae, $01
	db $00, $00, $b6, $4a, $80, $64, $b4, $64, $17, $4b, $17, $4b, $7f, $6e, $0e, $6e
	db $c0, $64, $c0, $64, $13, $6e, $c0, $64, $d7, $64, $e0, $64, $e9, $64, $0e, $6e
	db $f2, $64, $13, $6e, $fb, $64, $1d, $6e, $04, $65, $13, $6e, $0d, $65, $0e, $6e
	db $16, $65, $13, $6e, $1f, $65, $1d, $6e, $28, $65, $42, $65, $ff, $ff, $88, $64
	db $20, $6d, $20, $6d, $2c, $6e, $4b, $65, $ff, $ff, $b8, $64, $a3, $28, $32, $30
	db $32, $38, $32, $30, $32, $00, $9b, $02, $a2, $28, $32, $30, $32, $38, $32, $30
	db $32, $9c, $00, $2a, $32, $30, $32, $38, $32, $30, $32, $00, $2a, $36, $32, $36
	db $3c, $36, $32, $36, $00, $28, $38, $36, $38, $40, $38, $36, $38, $00, $32, $38
	db $36, $38, $42, $38, $36, $38, $00, $2a, $36, $32, $36, $3c, $36, $32, $36, $00
	db $2e, $36, $32, $36, $3c, $36, $32, $36, $00, $2e, $38, $36, $38, $40, $38, $36
	db $38, $00, $2a, $38, $36, $38, $42, $38, $36, $38, $00, $2c, $36, $32, $36, $3e
	db $36, $32, $36, $00, $28, $36, $32, $36, $40, $36, $32, $36, $00, $30, $36, $3c
	db $42, $48, $4e, $54, $5a, $58, $54, $4e, $48, $40, $3c, $36, $30, $00, $30, $36
	db $3c, $42, $48, $4e, $54, $5a, $00, $9b, $02, $a3, $4a, $4e, $ae, $50, $9c, $a5
	db $4e, $48, $ae, $4a, $a4, $01, $a3, $4a, $4e, $ae, $50, $a3, $4e, $50, $a5, $54
	db $a4, $01, $a3, $46, $4e, $a5, $54, $a4, $5a, $ae, $58, $a4, $01, $a5, $54, $54
	db $56, $56, $58, $58, $01, $01, $00, $00, $e3, $4a, $86, $65, $ba, $65, $17, $4b
	db $00, $00, $24, $6d, $7d, $6d, $ca, $64, $d7, $64, $d7, $64, $e0, $64, $e0, $64
	db $e9, $64, $e9, $64, $f2, $64, $f2, $64, $fb, $64, $fb, $64, $04, $65, $04, $65
	db $0d, $65, $0d, $65, $16, $65, $16, $65, $1f, $65, $1f, $65, $28, $65, $28, $65
	db $31, $65, $ff, $ff, $88, $65, $0e, $6e, $ca, $64, $d7, $64, $13, $6e, $d7, $64
	db $cd, $6d, $e0, $64, $fa, $6d, $e0, $64, $13, $6e, $e9, $64, $0e, $6e, $e9, $64
	db $f2, $64, $13, $6e, $f2, $64, $cd, $6d, $fb, $64, $0e, $6e, $fb, $64, $09, $6e
	db $04, $65, $0e, $6e, $04, $65, $13, $6e, $0d, $65, $09, $6e, $0d, $65, $0e, $6e
	db $16, $65, $13, $6e, $16, $65, $cd, $6d, $1f, $65, $fa, $6d, $1f, $65, $28, $65
	db $e6, $6d, $28, $65, $cd, $6d, $31, $65, $ff, $ff, $ba, $65, $00, $e3, $4a, $17
	db $4b, $1b, $66, $17, $4b, $00, $00, $f5, $6d, $25, $66, $20, $6d, $ff, $ff, $1b
	db $66, $a2, $02, $0e, $0c, $a7, $01, $a6, $01, $a1, $02, $a2, $02, $0e, $a1, $0c
	db $18, $00, $00, $b6, $4a, $41, $66, $4d, $66, $17, $4b, $00, $00, $09, $6e, $24
	db $6d, $10, $6d, $53, $66, $ff, $ff, $47, $66, $cd, $6d, $ff, $ff, $47, $66, $a3
	db $32, $46, $58, $66, $70, $01, $a3, $2e, $42, $54, $62, $6c, $01, $00, $00, $c5
	db $4a, $6d, $66, $7b, $66, $17, $4b, $00, $00, $09, $6e, $10, $6d, $85, $66, $9b
	db $66, $ab, $66, $ff, $ff, $75, $66, $0e, $6e, $85, $66, $8f, $66, $ff, $ff, $7f
	db $66, $a1, $8e, $8c, $84, $7c, $76, $74, $6c, $64, $00, $9b, $03, $a7, $74, $01
	db $9c, $a2, $74, $74, $a4, $01, $00, $a4, $01, $a6, $01, $9b, $02, $a7, $54, $01
	db $9c, $a2, $54, $54, $a4, $01, $00, $9b, $03, $a7, $54, $01, $9c, $a2, $54, $54
	db $a4, $01, $00, $00, $c5, $4a, $c2, $66, $d4, $66, $e6, $66, $00, $00, $7d, $6d
	db $10, $6d, $f6, $66, $a4, $6e, $09, $6e, $45, $67, $a8, $6e, $ff, $ff, $c2, $66
	db $a0, $6d, $f6, $66, $10, $6d, $a4, $6e, $be, $6d, $19, $67, $a8, $6e, $ff, $ff
	db $d4, $66, $10, $6d, $18, $6d, $a4, $6e, $68, $6e, $00, $67, $a8, $6e, $ff, $ff
	db $e6, $66, $a1, $8e, $8c, $84, $7c, $76, $74, $6c, $64, $00, $9b, $02, $a3, $01
	db $a6, $88, $a1, $01, $ae, $01, $01, $01, $a5, $01, $9c, $a3, $01, $a6, $88, $a1
	db $01, $ae, $01, $01, $00, $9d, $61, $86, $80, $9b, $02, $a3, $64, $68, $6a, $82
	db $a5, $01, $a3, $01, $80, $7c, $6a, $a5, $01, $9c, $a3, $64, $68, $6a, $01, $01
	db $68, $64, $58, $5e, $64, $a8, $01, $a3, $68, $6a, $6e, $70, $88, $ae, $01, $01
	db $00, $9b, $04, $a2, $54, $5c, $4c, $52, $54, $52, $4c, $44, $9c, $9b, $04, $52
	db $58, $48, $50, $52, $58, $60, $68, $9c, $9b, $04, $50, $58, $46, $4c, $50, $4c
	db $46, $40, $9c, $9b, $03, $52, $58, $48, $50, $52, $58, $60, $68, $9c, $52, $58
	db $48, $50, $00, $00, $c5, $4a, $82, $67, $8a, $67, $17, $4b, $00, $00, $09, $6e
	db $d6, $5d, $ff, $ff, $82, $67, $13, $6e, $9a, $6e, $ff, $ff, $92, $67, $20, $5e
	db $4d, $5e, $5f, $5e, $ff, $ff, $92, $67, $00, $d4, $4a, $a7, $67, $fd, $67, $d3
	db $67, $00, $00, $10, $6d, $78, $6d, $db, $68, $db, $68, $db, $68, $db, $68, $db
	db $68, $db, $68, $78, $6d, $db, $68, $db, $68, $7d, $6d, $97, $68, $78, $6d, $db
	db $68, $c4, $68, $20, $6d, $20, $6d, $20, $6d, $20, $6d, $ff, $ff, $a9, $67, $73
	db $69, $68, $6e, $56, $68, $6d, $6e, $56, $68, $68, $6e, $25, $68, $77, $6e, $25
	db $68, $68, $6e, $39, $68, $6d, $6e, $66, $68, $68, $6e, $73, $68, $6d, $6e, $7f
	db $68, $77, $6e, $8b, $68, $ff, $ff, $d3, $67, $09, $6e, $fc, $68, $fc, $68, $fc
	db $68, $fc, $68, $fc, $68, $fc, $68, $09, $6e, $fc, $68, $fc, $68, $97, $68, $fc
	db $68, $0e, $6e, $c4, $68, $09, $6e, $35, $69, $78, $6d, $65, $69, $ff, $ff, $fd
	db $67, $a3, $50, $64, $62, $6e, $a4, $01, $a2, $01, $64, $62, $50, $a3, $4e, $60
	db $5e, $6c, $a5, $01, $00, $a3, $4c, $5c, $5a, $6a, $a5, $01, $a3, $4a, $5a, $58
	db $68, $a5, $01, $a3, $48, $58, $56, $66, $a5, $01, $a3, $4a, $5a, $58, $68, $a5
	db $01, $00, $99, $a3, $4c, $5c, $5a, $6a, $a5, $01, $a3, $4a, $5a, $58, $68, $a5
	db $01, $00, $9a, $a2, $30, $34, $36, $44, $48, $4c, $4e, $5c, $a5, $01, $00, $a2
	db $30, $34, $36, $42, $48, $4c, $4e, $5a, $a5, $01, $00, $a2, $34, $38, $3a, $48
	db $4c, $50, $52, $60, $a5, $01, $00, $a2, $34, $38, $3a, $46, $4c, $50, $52, $5e
	db $a5, $01, $00, $9b, $02, $a2, $01, $38, $3c, $38, $3c, $a7, $01, $9c, $9b, $02
	db $a2, $01, $36, $3c, $36, $3c, $a7, $01, $9c, $9b, $02, $a2, $01, $38, $3c, $3e
	db $46, $a7, $01, $9c, $9b, $02, $a2, $01, $36, $3c, $3e, $4e, $a7, $01, $9c, $00
	db $9b, $02, $3e, $36, $3e, $40, $46, $48, $46, $44, $9c, $9b, $02, $32, $38, $40
	db $42, $48, $4a, $48, $42, $9c, $00, $a2, $44, $4c, $4a, $4c, $9d, $20, $00, $80
	db $9b, $03, $a2, $44, $4c, $4a, $4c, $9c, $9b, $03, $42, $48, $4a, $48, $9c, $9d
	db $10, $00, $80, $42, $48, $4a, $48, $00, $a2, $44, $4c, $4a, $4c, $9d, $37, $00
	db $80, $44, $4c, $4a, $4c, $9d, $53, $00, $80, $44, $4c, $4a, $4c, $9d, $64, $00
	db $80, $44, $4c, $4a, $4c, $9d, $53, $00, $80, $42, $48, $4a, $48, $9d, $37, $00
	db $80, $42, $48, $4a, $48, $9d, $27, $00, $80, $9b, $02, $42, $48, $4a, $48, $9c
	db $00, $a2, $01, $30, $34, $36, $44, $48, $4c, $4e, $60, $64, $66, $74, $a4, $01
	db $a2, $01, $30, $34, $36, $42, $48, $4c, $4e, $60, $64, $66, $72, $a4, $01, $a2
	db $01, $34, $38, $3a, $48, $4c, $50, $52, $64, $68, $6a, $78, $a4, $01, $a2, $01
	db $00, $34, $38, $3a, $46, $4c, $50, $52, $64, $68, $6a, $76, $a4, $01, $00, $9b
	db $18, $a5, $01, $9c, $00, $00, $d4, $4a, $84, $69, $8e, $69, $98, $69, $00, $00
	db $ff, $6d, $a2, $69, $4a, $6e, $b4, $69, $00, $00, $ff, $6d, $b7, $69, $4a, $6e
	db $c9, $69, $00, $00, $54, $6e, $cc, $69, $59, $6e, $da, $69, $00, $00, $a1, $01
	db $a4, $01, $a3, $1c, $20, $a8, $22, $a3, $01, $22, $26, $a7, $2a, $a2, $2e, $00
	db $ae, $1a, $00, $a1, $01, $a4, $01, $a3, $2e, $30, $a8, $34, $a3, $01, $34, $38
	db $a7, $3a, $a2, $3e, $00, $ae, $42, $00, $9b, $02, $99, $a1, $0e, $9a, $a5, $0e
	db $a3, $0e, $a6, $01, $9c, $00, $a1, $01, $ae, $14, $00, $00, $e3, $4a, $ea, $69
	db $f4, $69, $fe, $69, $00, $00, $7d, $6d, $10, $6d, $08, $6a, $ff, $ff, $f8, $69
	db $87, $6d, $08, $6a, $12, $6a, $ff, $ff, $30, $6d, $18, $6d, $77, $6e, $1c, $6a
	db $ff, $ff, $30, $6d, $a1, $80, $78, $72, $6a, $68, $60, $5a, $50, $00, $a1, $54
	db $5c, $62, $6a, $6c, $74, $7a, $82, $00, $99, $a2, $54, $54, $00, $00, $d4, $4a
	db $54, $6a, $2c, $6a, $7c, $6a, $00, $00, $a0, $6d, $9b, $6a, $a5, $6a, $b0, $6e
	db $96, $6d, $a8, $6a, $10, $6d, $7d, $6d, $08, $6a, $24, $6d, $2d, $6d, $96, $6a
	db $78, $6b, $a0, $6d, $28, $6b, $09, $6e, $40, $6b, $27, $6d, $ff, $ff, $32, $6a
	db $7d, $6d, $10, $6d, $9b, $6a, $2d, $6d, $b0, $6e, $22, $6b, $87, $6d, $08, $6a
	db $20, $6d, $20, $6d, $20, $6d, $20, $6d, $10, $6d, $7d, $6d, $28, $6b, $27, $6d
	db $2d, $6d, $10, $6d, $ff, $ff, $5c, $6a, $18, $6d, $24, $6d, $6d, $6e, $b0, $6e
	db $10, $6d, $67, $5d, $46, $6b, $15, $6d, $2d, $6d, $18, $6d, $24, $6d, $ff, $ff
	db $80, $6a, $9d, $c2, $83, $c0, $00, $a1, $44, $48, $4c, $50, $56, $5c, $60, $64
	db $00, $68, $6e, $00, $9d, $b1, $83, $80, $a6, $01, $64, $68, $6a, $9d, $81, $83
	db $80, $a2, $3e, $42, $44, $4c, $52, $a1, $01, $9d, $b1, $83, $80, $a6, $64, $68
	db $6a, $9d, $81, $83, $80, $a2, $30, $3e, $44, $4c, $50, $9d, $b1, $83, $80, $68
	db $64, $5a, $60, $9d, $81, $83, $80, $3a, $42, $64, $50, $a7, $01, $a2, $34, $3c
	db $42, $48, $4c, $9d, $b1, $83, $80, $64, $68, $6a, $9d, $81, $83, $80, $a2, $3e
	db $42, $44, $4c, $52, $9d, $b1, $83, $80, $60, $6a, $74, $9d, $81, $83, $80, $a2
	db $30, $3e, $44, $4c, $56, $9d, $b1, $83, $80, $72, $6e, $72, $9d, $81, $83, $80
	db $a2, $3a, $42, $48, $50, $52, $5a, $60, $68, $78, $01, $90, $01, $00, $9b, $11
	db $a4, $01, $9c, $00, $a1, $1c, $22, $2a, $30, $38, $3a, $42, $48, $50, $48, $42
	db $3a, $38, $30, $2a, $22, $18, $26, $2c, $34, $3e, $44, $00, $4c, $56, $60, $a9
	db $01, $00, $a9, $01, $a3, $01, $a3, $80, $7c, $72, $a7, $72, $a4, $74, $a7, $01
	db $a3, $86, $82, $72, $a7, $72, $a3, $74, $a2, $01, $a3, $74, $a3, $78, $01, $a2
	db $66, $6c, $78, $a4, $72, $a7, $01, $a2, $6a, $a4, $7c, $01, $a2, $01, $a7, $7a
	db $8c, $a3, $8a, $00, $9d, $c2, $83, $c0, $a3, $80, $7c, $72, $a2, $72, $9d, $72
	db $00, $80, $26, $34, $9d, $c2, $83, $c0, $74, $9d, $72, $00, $80, $a1, $3e, $42
	db $44, $4c, $56, $5a, $5c, $6a, $34, $42, $50, $60, $9d, $c2, $83, $c0, $a3, $86
	db $82, $72, $a2, $72, $9d, $72, $00, $80, $3e, $4c, $9d, $c2, $83, $c0, $74, $9d
	db $72, $00, $80, $a1, $56, $5a, $5c, $64, $9d, $c2, $83, $c0, $a3, $74, $78, $9d
	db $72, $00, $80, $a1, $4e, $54, $5a, $60, $9d, $c2, $83, $c0, $a2, $66, $6c, $78
	db $72, $9d, $72, $00, $80, $a1, $01, $52, $5a, $60, $6a, $72, $78, $7e, $a3, $82
	db $9d, $c2, $83, $c0, $a2, $6a, $7c, $9d, $72, $00, $80, $a1, $2c, $34, $3a, $42
	db $44, $4c, $52, $5a, $4c, $52, $5a, $5c, $52, $5a, $5c, $64, $9d, $c2, $83, $c0
	db $a7, $7a, $8c, $a3, $8a, $00, $c5, $4a, $14, $6c, $1e, $6c, $26, $6c, $00, $00
	db $9b, $6d, $40, $6c, $2a, $6d, $ff, $ff, $22, $6c, $b9, $6d, $2e, $6c, $38, $6c
	db $00, $00, $6d, $6e, $10, $6d, $ff, $ff, $20, $6c, $a1, $52, $5a, $60, $68, $6a
	db $72, $78, $80, $00, $a3, $01, $a1, $8a, $90, $01, $01, $00, $9b, $02, $a1, $3a
	db $42, $48, $42, $9c, $00, $00, $b6, $4a, $54, $6c, $66, $6c, $17, $4b, $00, $00
	db $e1, $6d, $03, $6d, $f0, $6d, $03, $6d, $03, $6d, $e1, $6d, $03, $6d, $ff, $ff
	db $54, $6c, $9b, $6d, $e9, $6c, $8c, $6d, $9d, $6e, $e9, $6c, $94, $6e, $e9, $6c
	db $9b, $6d, $97, $6e, $e9, $6c, $7c, $6e, $ff, $ff, $66, $6c, $00, $b6, $4a, $8b
	db $6c, $a5, $6c, $d3, $6c, $e1, $6c, $e1, $6d, $03, $6d, $f0, $6d, $03, $6d, $ff
	db $6d, $03, $6d, $03, $6d, $03, $6d, $03, $6d, $03, $6d, $a0, $6e, $ff, $ff, $47
	db $5f, $9b, $6d, $e9, $6c, $8c, $6d, $9d, $6e, $e9, $6c, $eb, $6d, $94, $6e, $e9
	db $6c, $97, $6e, $e9, $6c, $8c, $6d, $7c, $6e, $f6, $6c, $b9, $6d, $9d, $6e, $f6
	db $6c, $eb, $6d, $94, $6e, $f6, $6c, $7c, $6e, $a0, $6e, $ff, $ff, $5d, $5f, $20
	db $6d, $20, $6d, $20, $6d, $15, $6d, $a0, $6e, $ff, $ff, $77, $5f, $0a, $6d, $a0
	db $6e, $ff, $ff, $8b, $5f, $9b, $02, $a1, $06, $0c, $12, $1a, $1e, $24, $2a, $32
	db $9c, $00, $9b, $02, $a1, $1e, $24, $2a, $32, $36, $3c, $42, $4a, $9c, $00, $99
	db $a2, $06, $06, $a8, $01, $00, $9b, $07, $a5, $01, $9c, $00, $a1, $01, $a9, $01
	db $00, $a5, $01, $00, $a4, $01, $00, $a5, $01, $a8, $01, $00, $a5, $01, $01, $00
	db $a2, $01, $00, $a6, $01, $00, $a1, $01, $00, $a0, $01, $00, $15, $6d, $ff, $ff
	db $30, $6d, $99, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff
	db $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $99, $99, $99, $99, $00, $00, $00, $00, $99, $99, $99, $99
	db $00, $00, $00, $00, $44, $44, $44, $44, $00, $00, $00, $00, $44, $44, $44, $44
	db $00, $00, $00, $00, $9d, $10, $00, $80, $00, $9d, $20, $00, $80, $00, $9d, $24
	db $83, $c0, $00, $9d, $46, $86, $80, $00, $9d, $81, $83, $c0, $00, $9d, $a2, $83
	db $c0, $00, $9d, $91, $83, $80, $00, $9d, $52, $83, $c0, $00, $9d, $62, $00, $80
	db $00, $9d, $82, $00, $80, $00, $9d, $62, $00, $c0, $00, $9d, $92, $00, $c0, $00
	db $9d, $b2, $00, $c0, $00, $9d, $c1, $83, $00, $00, $9d, $45, $00, $80, $00, $9d
	db $53, $00, $80, $00, $9d, $93, $00, $00, $00, $9d, $64, $00, $80, $00, $9d, $84
	db $86, $80, $00, $9d, $b4, $86, $80, $00, $9d, $e4, $86, $80, $00, $9d, $75, $86
	db $80, $00, $9d, $a5, $00, $80, $00, $9d, $f5, $86, $80, $00, $9d, $a5, $86, $80
	db $00, $9d, $a5, $46, $80, $00, $9d, $85, $00, $80, $00, $9d, $e7, $86, $80, $00
	db $9d, $17, $00, $80, $00, $9d, $27, $00, $80, $00, $9d, $37, $00, $80, $00, $9d
	db $47, $00, $80, $00, $9d, $86, $00, $c0, $00, $9d, $66, $00, $80, $00, $9d, $87
	db $00, $80, $00, $9d, $48, $00, $80, $00, $9d, $38, $00, $81, $00, $9d, $48, $86
	db $80, $00, $9d, $48, $00, $00, $00, $9d, $58, $00, $00, $00, $9d, $a8, $86, $c0
	db $00, $9d, $88, $00, $00, $00, $9d, $1f, $00, $00, $00, $9d, $5f, $00, $80, $00
	db $9d, $38, $6d, $20, $00, $9d, $48, $6d, $20, $00, $9d, $48, $6d, $40, $00, $9d
	db $58, $6d, $20, $00, $9d, $58, $6d, $40, $00, $9d, $58, $6d, $60, $00, $9d, $68
	db $6d, $40, $00, $9d, $68, $6d, $60, $00, $9f, $00, $00, $9f, $18, $00, $9f, $16
	db $00, $9f, $0e, $00, $9f, $0c, $00, $9f, $0a, $00, $9f, $08, $00, $9f, $06, $00
	db $9f, $04, $00, $9f, $02, $00, $9f, $d0, $00, $9f, $fe, $00, $9e, $98, $4a, $00
	db $9e, $a7, $4a, $00, $9e, $c5, $4a, $00, $9e, $d4, $4a, $00, $9e, $e3, $4a, $00
	db $9e, $f2, $4a, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $d4, $4a, $0b
	db $70, $17, $4b, $13, $70, $00, $00, $1d, $70, $97, $70, $c0, $70, $00, $00, $26
	db $70, $97, $70, $91, $70, $c0, $70, $00, $00, $9d, $20, $00, $81, $a2, $01, $a9
	db $01, $00, $9d, $0f, $73, $01, $94, $00, $00, $d4, $4a, $37, $70, $3f, $70, $43
	db $70, $00, $00, $4d, $70, $97, $70, $c0, $70, $00, $00, $58, $70, $00, $00, $89
	db $70, $97, $70, $91, $70, $c0, $70, $00, $00, $9d, $20, $00, $81, $a2, $01, $a9
	db $01, $ae, $01, $00, $9d, $47, $00, $80, $96, $9b, $0a, $a3, $74, $66, $6a, $78
	db $9c, $9b, $02, $6e, $60, $66, $6e, $70, $60, $6a, $70, $9c, $74, $62, $6a, $74
	db $7a, $68, $6e, $74, $70, $60, $66, $70, $6a, $5e, $64, $76, $9b, $02, $74, $66
	db $6a, $78, $9c, $95, $00, $9d, $0f, $73, $01, $ae, $01, $94, $00, $9d, $e1, $72
	db $01, $94, $00, $96, $a2, $01, $30, $34, $a8, $36, $a2, $30, $34, $a8, $36, $a2
	db $34, $30, $26, $a7, $2c, $a5, $30, $a3, $01, $a2, $30, $34, $a8, $36, $a2, $2c
	db $36, $a8, $40, $a2, $3e, $3a, $a5, $3e, $01, $a2, $01, $00, $a3, $01, $64, $60
	db $56, $a7, $56, $a5, $58, $a2, $6a, $66, $64, $60, $56, $52, $56, $60, $a7, $58
	db $a2, $58, $a4, $5c, $a2, $01, $4a, $52, $5c, $a8, $56, $a2, $01, $4e, $a8, $60
	db $a7, $01, $5e, $70, $6e, $01, $a4, $01, $a5, $01, $95, $00, $00, $d4, $4a, $3f
	db $70, $fb, $70, $43, $70, $00, $00, $07, $71, $14, $71, $23, $71, $23, $71, $33
	db $71, $00, $00, $9d, $71, $82, $80, $96, $9b, $04, $a2, $4e, $56, $64, $5c, $9c
	db $9b, $04, $52, $58, $66, $60, $9c, $9b, $04, $4e, $56, $64, $60, $9c, $00, $9b
	db $02, $a2, $48, $4e, $60, $56, $9c, $9b, $02, $48, $52, $60, $58, $9c, $00, $9b
	db $02, $44, $4a, $58, $52, $9c, $9b, $02, $44, $4a, $56, $50, $9c, $9b, $02, $40
	db $48, $56, $4e, $9c, $9b, $02, $40, $46, $52, $4c, $9c, $9b, $04, $4e, $56, $64
	db $5c, $9c, $95, $00, $00, $d4, $4a, $63, $71, $fb, $70, $43, $70, $00, $00, $6d
	db $71, $76, $71, $76, $71, $8a, $71, $00, $00, $9d, $87, $00, $80, $96, $a5, $8c
	db $8c, $00, $9d, $87, $00, $80, $a5, $8c, $8c, $9d, $37, $00, $80, $9b, $02, $a3
	db $74, $66, $6a, $78, $9c, $00, $9d, $76, $00, $80, $9b, $02, $a4, $90, $86, $90
	db $88, $9c, $8c, $88, $86, $8c, $90, $88, $8e, $88, $9d, $87, $00, $80, $a5, $8c
	db $8c, $00, $00, $d4, $4a, $63, $71, $fb, $70, $43, $70, $b1, $71, $b5, $71, $00
	db $00, $9b, $0a, $a1, $1f, $1f, $1f, $1f, $a2, $1f, $a3, $24, $a2, $1f, $a3, $24
	db $a1, $1f, $1f, $1f, $1f, $a3, $24, $a1, $1f, $1f, $1f, $1f, $a3, $24, $9c, $00
	db $00, $d4, $4a, $df, $71, $ef, $71, $43, $70, $b1, $71, $6d, $71, $76, $71, $76
	db $71, $37, $72, $23, $71, $23, $71, $33, $71, $00, $00, $f7, $71, $04, $72, $13
	db $72, $00, $00, $9d, $19, $45, $40, $96, $9b, $02, $a3, $1e, $2c, $26, $2c, $9c
	db $9b, $02, $22, $30, $28, $30, $9c, $9b, $02, $1e, $2c, $26, $2c, $9c, $00, $9b
	db $02, $a3, $18, $26, $1e, $26, $18, $28, $22, $28, $9c, $2c, $22, $1a, $22, $2c
	db $20, $1a, $20, $28, $1e, $18, $1e, $28, $1c, $16, $1c, $9b, $02, $1e, $2c, $26
	db $2c, $9c, $00, $9d, $61, $82, $80, $00, $00, $d4, $4a, $fb, $70, $47, $72, $43
	db $70, $53, $72, $6d, $71, $76, $71, $76, $71, $7d, $72, $13, $72, $00, $00, $82
	db $72, $82, $72, $82, $72, $82, $72, $82, $72, $82, $72, $82, $72, $82, $72, $82
	db $72, $82, $72, $95, $72, $82, $72, $95, $72, $82, $72, $82, $72, $82, $72, $82
	db $72, $82, $72, $82, $72, $82, $72, $00, $00, $9d, $19, $45, $40, $00, $9b, $03
	db $a2, $1a, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c, $a2, $1a, $1a
	db $00, $9b, $02, $a1, $1f, $1f, $1f, $1f, $a2, $1f, $a3, $24, $a2, $1f, $a3, $24
	db $00, $00, $e3, $4a, $17, $4b, $b0, $72, $b6, $72, $00, $00, $ba, $72, $c8, $72
	db $00, $00, $c3, $72, $00, $00, $9d, $20, $00, $41, $a1, $01, $a0, $01, $00, $9d
	db $e1, $72, $01, $94, $a2, $60, $64, $a8, $66, $a2, $60, $64, $a4, $66, $a2, $64
	db $a6, $60, $a3, $56, $ae, $6e, $9a, $9b, $20, $a5, $01, $9c, $00, $01, $35, $66
	db $53, $10, $02, $46, $8a, $01, $35, $66, $53, $10, $02, $46, $8a, $00, $f2, $4a
	db $17, $4b, $fc, $72, $02, $73, $00, $00, $06, $73, $24, $73, $00, $00, $1f, $73
	db $00, $00, $9d, $20, $00, $41, $a1, $01, $a0, $01, $00, $06, $9b, $cd, $de, $ee
	db $ff, $ff, $fe, $06, $9b, $cd, $de, $ee, $ff, $ff, $fe, $9d, $0f, $73, $01, $94
	db $a1, $30, $34, $a4, $36, $a3, $01, $a1, $30, $34, $a2, $36, $34, $a6, $30, $a3
	db $26, $a2, $01, $a5, $3e, $9b, $20, $ae, $01, $9c, $00, $00, $d4, $4a, $17, $4b
	db $4a, $73, $54, $73, $00, $00, $5a, $73, $5a, $73, $6a, $73, $ff, $ff, $bb, $78
	db $80, $73, $ff, $ff, $bb, $78, $9d, $81, $00, $80, $a1, $74, $66, $6a, $78, $9d
	db $a6, $00, $80, $a4, $74, $00, $9d, $82, $00, $80, $a2, $74, $66, $a6, $6a, $9d
	db $85, $00, $80, $a3, $78, $9d, $a6, $00, $80, $ae, $74, $00, $9d, $0c, $75, $23
	db $99, $9b, $02, $a1, $6a, $5c, $60, $6e, $a4, $6a, $9c, $a2, $6a, $5c, $a6, $60
	db $a3, $6e, $ae, $6a, $9b, $20, $ae, $01, $9c, $00, $18, $98, $4a, $17, $4b, $a9
	db $73, $af, $73, $00, $00, $b3, $73, $d1, $73, $00, $00, $cc, $73, $00, $00, $9d
	db $10, $00, $80, $a3, $01, $a1, $01, $00, $46, $79, $98, $64, $43, $10, $01, $34
	db $46, $79, $98, $64, $43, $10, $01, $34, $9d, $bc, $73, $20, $99, $a3, $62, $60
	db $58, $52, $a6, $4a, $48, $4a, $52, $58, $ab, $60, $58, $52, $4a, $a2, $48, $4a
	db $52, $58, $60, $58, $52, $4a, $48, $4a, $52, $58, $9b, $02, $5e, $56, $50, $48
	db $46, $48, $50, $56, $9c, $58, $50, $4a, $42, $40, $42, $4a, $50, $ab, $54, $4c
	db $46, $3e, $a6, $3c, $3e, $a3, $46, $4c, $aa, $01, $a2, $50, $9b, $20, $ae, $01
	db $9c, $00, $00, $b6, $4a, $21, $74, $27, $74, $2d, $74, $00, $00, $33, $74, $ff
	db $ff, $bb, $78, $58, $74, $ff, $ff, $bb, $78, $8c, $74, $ff, $ff, $bb, $78, $9d
	db $81, $00, $80, $a1, $01, $a2, $6e, $9d, $c1, $00, $80, $a2, $6e, $a6, $01, $a4
	db $01, $9d, $a2, $00, $80, $a2, $01, $a3, $64, $6a, $74, $6a, $78, $9d, $a7, $00
	db $80, $ae, $8c, $00, $9d, $61, $00, $80, $a2, $6e, $9d, $a1, $00, $80, $a2, $6e
	db $9d, $e5, $00, $80, $a8, $6e, $9d, $a2, $00, $80, $a3, $60, $66, $6e, $72, $6e
	db $82, $9d, $a7, $00, $80, $ae, $86, $00, $66, $00, $66, $00, $66, $00, $66, $00
	db $66, $00, $66, $00, $66, $00, $66, $00, $9d, $7c, $74, $23, $99, $a1, $64, $64
	db $64, $64, $a8, $64, $a2, $56, $5a, $5c, $78, $64, $6a, $68, $60, $64, $6e, $78
	db $82, $ae, $7c, $00, $00, $c5, $4a, $17, $4b, $b3, $74, $cf, $74, $00, $00, $d3
	db $74, $ec, $74, $d3, $74, $fe, $74, $d3, $74, $fe, $74, $d3, $74, $ec, $74, $d3
	db $74, $fe, $74, $d3, $74, $05, $75, $40, $75, $00, $00, $1c, $75, $00, $00, $9d
	db $21, $00, $80, $a1, $78, $9d, $41, $00, $80, $a1, $78, $9d, $71, $00, $80, $a1
	db $78, $9d, $a1, $00, $80, $a1, $78, $00, $9d, $a1, $00, $80, $a2, $78, $9d, $c3
	db $00, $80, $a3, $78, $9d, $82, $00, $80, $a2, $78, $9d, $d2, $00, $80, $a3, $78
	db $00, $9d, $e3, $00, $80, $ae, $78, $00, $00, $0c, $00, $0c, $00, $0c, $00, $0c
	db $06, $06, $06, $06, $06, $06, $06, $06, $9d, $0c, $75, $20, $99, $9b, $02, $a1
	db $86, $86, $86, $86, $a2, $86, $a3, $86, $a2, $86, $a3, $86, $a1, $86, $86, $86
	db $86, $a3, $86, $a1, $86, $86, $86, $86, $a3, $86, $9c, $9a, $9b, $20, $ae, $01
	db $9c, $00, $00, $e3, $4a, $17, $4b, $51, $75, $59, $75, $00, $00, $5f, $75, $7d
	db $75, $ff, $ff, $bb, $78, $78, $75, $ff, $ff, $bb, $78, $9d, $20, $00, $80, $a2
	db $01, $a9, $01, $00, $88, $88, $88, $84, $00, $00, $00, $00, $88, $88, $88, $84
	db $00, $00, $00, $00, $9d, $68, $75, $00, $94, $a2, $48, $4c, $a8, $4e, $a2, $48
	db $4c, $a3, $4e, $4c, $48, $a0, $01, $a3, $3e, $a1, $01, $a5, $56, $00, $00, $d4
	db $4a, $17, $4b, $9d, $75, $17, $4b, $ad, $75, $b5, $75, $b5, $75, $cb, $75, $b5
	db $75, $b5, $75, $cb, $75, $ff, $ff, $bb, $78, $e2, $75, $e2, $75, $fa, $75, $00
	db $00, $9d, $a1, $00, $80, $97, $a2, $36, $9d, $61, $00, $80, $a9, $2c, $ad, $01
	db $a9, $2c, $ad, $01, $a9, $2c, $00, $a1, $2c, $9d, $a1, $00, $80, $a1, $36, $9d
	db $61, $00, $80, $a1, $2c, $2c, $9d, $a1, $00, $80, $a2, $36, $36, $00, $9b, $02
	db $a2, $ff, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c, $a1, $15, $ff
	db $15, $15, $a2, $ff, $ff, $00, $9b, $20, $ae, $01, $9c, $00, $00, $d4, $4a, $0b
	db $76, $17, $76, $21, $76, $00, $00, $27, $76, $34, $76, $4a, $76, $5d, $76, $ff
	db $ff, $0d, $76, $30, $76, $4a, $76, $5d, $76, $ff, $ff, $17, $76, $8a, $76, $ff
	db $ff, $0d, $76, $9d, $20, $00, $80, $a1, $01, $a9, $01, $00, $9d, $60, $21, $80
	db $a2, $01, $60, $64, $a8, $66, $a2, $60, $64, $a8, $66, $a2, $64, $60, $56, $a7
	db $5c, $a5, $60, $a3, $01, $00, $a2, $60, $64, $a8, $66, $a2, $5c, $66, $a8, $70
	db $a2, $6e, $6a, $a5, $6e, $01, $a7, $01, $00, $a3, $7c, $78, $6e, $a7, $6e, $a5
	db $70, $a2, $82, $7e, $7c, $78, $6e, $6a, $6e, $78, $a7, $70, $a2, $70, $a4, $74
	db $a2, $01, $62, $6a, $74, $a8, $6e, $a2, $01, $66, $a5, $78, $a2, $01, $a7, $76
	db $88, $86, $01, $a5, $01, $00, $9d, $68, $6d, $60, $a3, $01, $a1, $01, $00, $00
	db $d4, $4a, $9e, $76, $ae, $76, $b8, $76, $00, $00, $be, $76, $14, $71, $14, $71
	db $23, $71, $23, $71, $33, $71, $ff, $ff, $a0, $76, $30, $76, $c7, $76, $5d, $76
	db $ff, $ff, $ae, $76, $eb, $76, $ff, $ff, $b8, $76, $9d, $19, $42, $40, $a7, $01
	db $a2, $01, $00, $a2, $30, $34, $a8, $36, $a2, $2c, $36, $a8, $40, $a2, $3e, $3a
	db $ae, $3e, $a4, $01, $a7, $01, $00, $01, $37, $9a, $bb, $bb, $bb, $a6, $21, $01
	db $37, $9a, $bb, $bb, $bb, $a6, $21, $9d, $db, $76, $40, $9b, $08, $a5, $01, $9c
	db $a8, $01, $a3, $6a, $66, $a6, $5c, $a1, $01, $a7, $5c, $a8, $60, $a3, $01, $a1
	db $70, $01, $6e, $01, $6a, $01, $66, $01, $5c, $01, $58, $01, $5c, $01, $66, $01
	db $a6, $60, $01, $a2, $60, $a7, $62, $a3, $01, $a1, $52, $01, $58, $01, $62, $01
	db $a4, $5c, $a7, $01, $a2, $56, $a8, $66, $a7, $01, $a3, $64, $a2, $01, $a3, $5e
	db $a2, $01, $a3, $5c, $a4, $01, $a5, $01, $00, $00, $01, $4b, $48, $77, $4c, $77
	db $50, $77, $54, $77, $58, $77, $00, $00, $a3, $77, $00, $00, $27, $78, $00, $00
	db $8c, $78, $00, $00, $9d, $62, $00, $00, $a1, $1e, $22, $24, $a6, $26, $a1, $26
	db $28, $2a, $a6, $2c, $a1, $2c, $30, $32, $34, $a3, $36, $97, $3c, $98, $9d, $41
	db $00, $80, $9b, $06, $a2, $78, $a1, $7e, $a2, $74, $7e, $78, $7e, $a1, $78, $a2
	db $74, $7e, $9c, $9d, $61, $00, $40, $a6, $70, $a1, $70, $6c, $a2, $74, $70, $70
	db $a1, $70, $a2, $6c, $74, $88, $88, $84, $a7, $88, $97, $a3, $2c, $98, $00, $9d
	db $81, $00, $40, $a1, $3e, $40, $42, $a6, $44, $a1, $44, $46, $48, $a6, $4a, $a1
	db $4a, $4e, $52, $54, $a4, $56, $ae, $01, $97, $a1, $01, $a2, $4a, $a1, $4a, $a2
	db $40, $a1, $30, $30, $98, $a6, $30, $a1, $30, $2c, $a2, $32, $30, $30, $a1, $30
	db $a2, $2c, $32, $a6, $30, $a1, $30, $2c, $a2, $32, $a2, $30, $97, $4a, $a1, $4a
	db $a2, $40, $a1, $30, $30, $98, $a6, $36, $a1, $36, $32, $a2, $3a, $36, $36, $a1
	db $36, $a2, $32, $3a, $a6, $36, $a1, $36, $32, $a2, $3a, $a2, $36, $97, $4a, $a1
	db $4a, $a2, $40, $a1, $30, $30, $98, $a6, $10, $a1, $10, $0c, $a2, $14, $10, $10
	db $a1, $10, $a2, $0c, $14, $10, $10, $0c, $a7, $10, $9d, $a1, $00, $80, $97, $a3
	db $3c, $98, $00, $9d, $0f, $73, $20, $99, $a1, $4e, $52, $54, $a6, $56, $a1, $56
	db $58, $5a, $a6, $5c, $a1, $5c, $60, $62, $64, $a4, $66, $9b, $02, $a6, $28, $a1
	db $28, $24, $a2, $2c, $28, $28, $a1, $28, $a2, $24, $2c, $a6, $28, $a1, $28, $24
	db $a2, $2c, $28, $a6, $01, $a3, $01, $9c, $a6, $30, $a1, $30, $2c, $a2, $32, $30
	db $30, $a1, $30, $a2, $2c, $32, $a6, $30, $a1, $30, $2c, $a2, $32, $30, $a6, $01
	db $a3, $01, $a6, $40, $a1, $40, $3c, $a2, $44, $40, $40, $a1, $40, $a2, $3c, $44
	db $40, $40, $3c, $a7, $40, $a3, $01, $00, $a5, $01, $a3, $01, $ff, $9b, $06, $a1
	db $1a, $15, $15, $1a, $15, $15, $ff, $1a, $1a, $15, $15, $1a, $15, $15, $ff, $ff
	db $9c, $a6, $ff, $a1, $ff, $ff, $a2, $ff, $ff, $ff, $a1, $ff, $a2, $ff, $ff, $ff
	db $ff, $ff, $a7, $ff, $a3, $ff, $00, $c1, $78, $ff, $ff, $bb, $78, $9b, $20, $ae
	db $01, $9c, $00, $cd, $78, $ff, $ff, $c7, $78, $9b, $20, $ae, $01, $9c, $00, $00
	db $d4, $4a, $de, $78, $e4, $78, $ea, $78, $00, $00, $f2, $78, $ff, $ff, $de, $78
	db $60, $79, $ff, $ff, $e4, $78, $b7, $79, $be, $79, $ff, $ff, $ec, $78, $9d, $42
	db $82, $80, $9b, $02, $a2, $40, $4e, $5c, $60, $a4, $01, $a2, $40, $52, $60, $62
	db $a4, $01, $9c, $a2, $40, $4e, $5c, $60, $a4, $01, $a2, $40, $4c, $5c, $5e, $a4
	db $01, $a2, $44, $52, $60, $62, $a4, $01, $a2, $42, $48, $4e, $54, $52, $a7, $01
	db $a2, $44, $4c, $52, $58, $a4, $01, $a2, $4a, $50, $56, $5c, $a4, $01, $a2, $48
	db $4e, $56, $5c, $a4, $01, $a2, $48, $4e, $56, $58, $a4, $01, $a2, $44, $4a, $52
	db $58, $a4, $01, $a2, $44, $4c, $52, $58, $a4, $01, $a2, $48, $4e, $56, $4e, $46
	db $4c, $52, $4c, $44, $4a, $52, $4a, $44, $4a, $50, $4a, $00, $9d, $50, $44, $80
	db $9b, $02, $a4, $66, $58, $5c, $a3, $01, $a2, $60, $62, $9c, $a3, $60, $66, $a4
	db $74, $a3, $01, $70, $74, $70, $66, $a2, $62, $60, $a4, $5c, $01, $a2, $01, $60
	db $62, $66, $a4, $6a, $58, $56, $a3, $01, $a2, $5c, $6a, $a4, $66, $56, $58, $a3
	db $01, $a2, $58, $56, $a3, $52, $58, $a4, $60, $a3, $01, $5c, $58, $50, $a4, $4e
	db $ae, $01, $00, $11, $11, $11, $10, $00, $00, $00, $00, $11, $11, $11, $10, $00
	db $00, $00, $00, $9d, $a7, $79, $20, $a2, $01, $00, $9b, $02, $a4, $66, $58, $5c
	db $a3, $01, $a2, $60, $62, $9c, $a3, $60, $66, $a7, $74, $01, $a3, $70, $74, $70
	db $66, $a2, $62, $60, $a7, $5c, $a4, $01, $a2, $01, $01, $60, $62, $66, $a4, $6a
	db $58, $a7, $56, $01, $a2, $5c, $6a, $a4, $66, $56, $a7, $58, $01, $a2, $58, $56
	db $a3, $52, $58, $a7, $60, $01, $a3, $5c, $58, $50, $a7, $4e, $a2, $01, $ae, $01
	db $00, $00, $c5, $4a, $10, $7a, $24, $7a, $2a, $7a, $00, $00, $3e, $7a, $32, $7a
	db $43, $7a, $32, $7a, $48, $7a, $32, $7a, $43, $7a, $32, $7a, $ff, $ff, $10, $7a
	db $4d, $7a, $ff, $ff, $24, $7a, $b7, $79, $51, $7a, $ff, $ff, $2c, $7a, $9b, $02
	db $ac, $7c, $7e, $9c, $9b, $02, $82, $84, $9c, $00, $9d, $10, $00, $00, $00, $9d
	db $20, $00, $00, $00, $9d, $30, $00, $00, $00, $9d, $1a, $81, $40, $9b, $20, $a2
	db $62, $6c, $76, $78, $9c, $00, $00, $f2, $4a, $65, $7a, $71, $7a, $17, $4b, $00
	db $00, $7b, $7a, $87, $7a, $16, $7b, $1f, $7b, $ff, $ff, $69, $7a, $82, $7a, $87
	db $7a, $1b, $7b, $ff, $ff, $75, $7a, $9d, $42, $00, $80, $a1, $01, $00, $9d, $81
	db $00, $80, $00, $a5, $01, $a2, $01, $97, $a0, $2e, $30, $3e, $40, $46, $40, $38
	db $30, $32, $34, $3c, $44, $4a, $44, $3c, $34, $36, $38, $40, $48, $4e, $48, $40
	db $38, $3a, $3c, $44, $4c, $52, $4c, $44, $3c, $3e, $40, $48, $50, $56, $50, $48
	db $40, $42, $44, $4c, $54, $5a, $54, $4c, $44, $46, $48, $50, $58, $5e, $58, $50
	db $48, $4a, $4c, $54, $5c, $62, $5c, $54, $4c, $4e, $50, $58, $60, $66, $60, $58
	db $50, $52, $54, $5c, $64, $6a, $64, $5c, $54, $9b, $02, $56, $58, $60, $68, $6e
	db $68, $60, $58, $56, $50, $48, $40, $48, $50, $9c, $56, $58, $60, $68, $6e, $68
	db $60, $58, $68, $60, $58, $56, $60, $58, $56, $50, $58, $56, $50, $48, $56, $50
	db $48, $40, $50, $48, $40, $38, $48, $40, $3e, $38, $40, $3e, $38, $30, $a5, $28
	db $98, $00, $9d, $10, $00, $80, $00, $9d, $1a, $81, $40, $9b, $20, $aa, $62, $6c
	db $76, $78, $9c, $00, $0e, $b6, $4a, $33, $7b, $39, $7b, $3f, $7b, $00, $00, $45
	db $7b, $ff, $ff, $33, $7b, $61, $7b, $ff, $ff, $39, $7b, $90, $7b, $ff, $ff, $3f
	db $7b, $9d, $62, $00, $40, $9b, $20, $a3, $32, $a2, $3a, $a3, $40, $a2, $48, $a8
	db $44, $a3, $2c, $a2, $36, $a3, $3c, $a2, $44, $a8, $40, $9c, $00, $9d, $50, $21
	db $80, $ae, $01, $01, $a8, $58, $a3, $01, $a2, $4e, $a3, $52, $a2, $40, $a5, $44
	db $a2, $01, $a3, $52, $a2, $5c, $a8, $58, $a3, $01, $a2, $4e, $a3, $52, $a2, $40
	db $a5, $44, $a2, $01, $a3, $40, $a2, $52, $ae, $4a, $01, $00, $9d, $f4, $4b, $40
	db $9b, $20, $a5, $01, $a1, $5c, $01, $a7, $74, $a5, $01, $a1, $58, $01, $a7, $70
	db $9c, $00, $00, $e3, $4a, $b1, $7b, $b7, $7b, $bd, $7b, $c3, $7b, $c9, $7b, $ff
	db $ff, $f9, $5e, $e0, $7b, $ff, $ff, $05, $5f, $06, $7c, $ff, $ff, $bb, $78, $1a
	db $7c, $ff, $ff, $c7, $78, $9d, $80, $81, $00, $96, $a1, $52, $5c, $66, $60, $6a
	db $74, $9d, $80, $00, $00, $a4, $6e, $01, $9e, $d4, $4a, $00, $9d, $40, $81, $40
	db $a1, $42, $4c, $56, $50, $5a, $64, $9d, $40, $00, $40, $a4, $5e, $01, $9e, $d4
	db $4a, $00, $aa, $aa, $aa, $a8, $00, $00, $00, $00, $aa, $aa, $aa, $a8, $00, $00
	db $00, $00, $9d, $f6, $7b, $20, $99, $a1, $30, $3a, $44, $3e, $48, $52, $9a, $a4
	db $4c, $01, $9e, $d4, $4a, $00, $9b, $06, $a1, $1a, $9c, $9b, $10, $a0, $15, $9c
	db $9e, $d4, $4a, $00, $00, $c5, $4a, $33, $7c, $3b, $7c, $17, $4b, $41, $7c, $47
	db $7c, $4e, $7c, $ff, $ff, $35, $7c, $93, $7c, $ff, $ff, $3b, $7c, $f9, $7c, $ff
	db $ff, $41, $7c, $9d, $10, $00, $80, $a1, $01, $00, $ac, $90, $86, $8e, $84, $8c
	db $82, $8a, $80, $88, $7e, $86, $78, $84, $76, $82, $74, $80, $72, $ac, $86, $78
	db $84, $76, $82, $74, $80, $72, $ad, $7c, $7a, $72, $6c, $68, $64, $62, $5a, $54
	db $50, $ad, $64, $62, $5a, $54, $50, $ae, $01, $ad, $7a, $72, $ad, $7a, $72, $a5
	db $01, $01, $ad, $62, $64, $72, $6c, $62, $64, $72, $6c, $a5, $01, $01, $00, $9d
	db $39, $00, $00, $ac, $90, $86, $8e, $84, $8c, $82, $8a, $80, $88, $7e, $86, $78
	db $84, $76, $82, $74, $80, $72, $9d, $20, $00, $40, $ac, $86, $78, $84, $76, $82
	db $74, $80, $72, $9d, $29, $00, $00, $ad, $7c, $7a, $72, $6c, $68, $64, $62, $5a
	db $54, $50, $9d, $20, $00, $40, $ad, $64, $62, $5a, $54, $50, $ae, $01, $9d, $29
	db $00, $00, $ad, $7a, $72, $9d, $20, $00, $40, $ad, $7a, $72, $a5, $01, $01, $9d
	db $29, $00, $00, $ad, $62, $64, $72, $6c, $9d, $20, $00, $40, $ad, $62, $64, $72
	db $6c, $a5, $01, $01, $00, $9b, $20, $a3, $38, $9c, $00, $00, $c5, $4a, $0a, $7d
	db $12, $7d, $17, $4b, $00, $00, $28, $7d, $36, $7d, $ff, $ff, $0c, $7d, $33, $7d
	db $3c, $7d, $36, $7d, $41, $7d, $36, $7d, $46, $7d, $36, $7d, $41, $7d, $36, $7d
	db $ff, $ff, $14, $7d, $9d, $20, $00, $43, $a7, $01, $a1, $01, $a0, $01, $00, $a7
	db $01, $00, $a1, $20, $22, $20, $22, $00, $9d, $20, $00, $40, $00, $9d, $30, $00
	db $40, $00, $9d, $40, $00, $40, $00, $00, $a7, $4a, $56, $7d, $5e, $7d, $66, $7d
	db $00, $00, $6e, $7d, $84, $7d, $ff, $ff, $58, $7d, $7a, $7d, $84, $7d, $ff, $ff
	db $60, $7d, $f8, $7d, $84, $7d, $ff, $ff, $68, $7d, $9d, $10, $00, $40, $a5, $01
	db $01, $a8, $01, $aa, $01, $00, $9d, $20, $00, $00, $a5, $01, $01, $a8, $01, $00
	db $a1, $8e, $8a, $88, $80, $7a, $76, $72, $70, $68, $62, $5e, $5a, $58, $50, $4a
	db $46, $42, $40, $38, $32, $2e, $2a, $2e, $32, $38, $40, $42, $46, $4a, $50, $58
	db $5a, $5e, $62, $68, $70, $72, $76, $7a, $80, $88, $8a, $8e, $8a, $86, $80, $78
	db $76, $72, $6e, $68, $60, $5e, $5a, $56, $50, $48, $46, $42, $3e, $38, $30, $34
	db $38, $3e, $42, $46, $48, $34, $50, $56, $5a, $5e, $60, $34, $68, $6e, $72, $76
	db $76, $72, $6c, $64, $62, $5e, $5a, $54, $4c, $4a, $46, $42, $3c, $34, $32, $2e
	db $32, $34, $3c, $42, $46, $4a, $4c, $54, $5a, $5e, $62, $64, $6c, $72, $76, $7a
	db $7c, $84, $8a, $00, $9d, $a7, $79, $20, $a5, $01, $01, $a8, $01, $a3, $01, $00
	db $00, $d4, $4a, $0f, $7e, $17, $7e, $1f, $7e, $27, $7e, $2f, $7e, $70, $7e, $ff
	db $ff, $11, $7e, $3a, $7e, $96, $7e, $ff, $ff, $19, $7e, $55, $7e, $fe, $7e, $ff
	db $ff, $21, $7e, $60, $7e, $76, $7f, $ff, $ff, $29, $7e, $9d, $60, $00, $41, $a7
	db $01, $aa, $4e, $ae, $50, $00, $9d, $40, $00, $01, $a7, $01, $aa, $64, $ae, $66
	db $00, $8a, $df, $da, $86, $31, $01, $36, $86, $8a, $df, $da, $86, $31, $01, $36
	db $86, $9d, $45, $7e, $20, $a7, $01, $aa, $5a, $ae, $5c, $00, $a7, $01, $aa, $01
	db $a5, $01, $a1, $ff, $a2, $ff, $ff, $a1, $ff, $a2, $ff, $00, $9d, $41, $00, $80
	db $9b, $07, $a6, $82, $82, $a3, $82, $a2, $82, $a3, $82, $9c, $9d, $61, $00, $80
	db $97, $a2, $44, $a6, $44, $a1, $44, $44, $a3, $44, $a2, $44, $a1, $44, $a2, $44
	db $98, $00, $9d, $60, $21, $41, $a3, $46, $a7, $3c, $a1, $01, $46, $46, $4a, $4c
	db $50, $a8, $54, $aa, $54, $56, $5a, $ad, $01, $a8, $5e, $aa, $5e, $5a, $56, $ad
	db $01, $a6, $5a, $a1, $56, $a4, $54, $a3, $54, $a2, $50, $a1, $50, $54, $a4, $56
	db $a2, $54, $50, $a2, $4c, $a1, $4c, $50, $a4, $54, $a2, $50, $4c, $a2, $4a, $a1
	db $4a, $4e, $a4, $52, $a3, $58, $9d, $62, $00, $40, $a2, $54, $a6, $54, $a1, $54
	db $54, $a3, $54, $a2, $54, $a1, $54, $a2, $54, $00, $00, $11, $22, $33, $44, $55
	db $67, $89, $00, $00, $00, $05, $00, $00, $00, $05, $9d, $ee, $7e, $20, $99, $a2
	db $5e, $a1, $4c, $a2, $54, $5e, $5c, $4c, $54, $5c, $a1, $4c, $a2, $5a, $a1, $4c
	db $a2, $54, $5a, $58, $4c, $54, $58, $a1, $4c, $a2, $56, $a1, $46, $a2, $4c, $56
	db $5a, $4a, $50, $5a, $a1, $4a, $a2, $5a, $a1, $4c, $a2, $54, $5a, $5a, $a1, $4c
	db $54, $a2, $5a, $a1, $4c, $54, $5a, $a2, $56, $a1, $48, $a2, $50, $56, $50, $3e
	db $48, $50, $a1, $52, $a2, $54, $a1, $46, $a2, $4c, $54, $5e, $a1, $4c, $54, $a2
	db $5e, $a1, $5c, $5e, $60, $a2, $62, $a1, $52, $a2, $58, $62, $5e, $52, $58, $5e
	db $a1, $58, $a2, $5c, $a6, $5c, $a1, $5c, $5c, $a3, $5c, $a2, $5c, $a1, $5c, $a2
	db $5c, $00, $9b, $07, $a1, $15, $15, $1a, $15, $15, $15, $ff, $15, $15, $15, $1a
	db $15, $15, $15, $1a, $ff, $9c, $a2, $ff, $a6, $ff, $a1, $ff, $ff, $a3, $ff, $a2
	db $ff, $a1, $ff, $a2, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
