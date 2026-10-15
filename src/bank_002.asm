; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $09, $09, $09, $05, $05, $05, $05, $05, $05, $05, $05, $08, $08, $08, $08
	db $09, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0b, $0b, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0b, $0b, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
	db $14, $15, $16, $17, $4b, $58, $5b, $5a, $12, $26, $26, $26, $26, $26, $07, $02
	db $0a, $26, $0a, $53, $13, $3e, $1f, $00, $00, $00, $00, $00, $00, $0a, $48, $26
	db $00, $00, $01, $00, $01, $00, $00, $01, $00, $00, $01, $01, $01, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $01, $00, $01, $00

Call_02_4146::
	ldh a, [$ffbc]
	and a
	jr z, jr_002_414f

	xor a
	ldh [$ffbc], a
	ret


jr_002_414f:
	ld d, $1d
	ld a, [$db4e]
	and a
	jp z, Jump_002_418c

	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $4000
	add hl, de
	ld d, [hl]
	ld a, d
	xor a
	ldh [$ffb1], a
	ld a, [$dba5]
	and a
	jr z, jr_002_418c

	ld d, $18
	ld a, [$d46c]
	and a
	jr nz, jr_002_4190

	ldh a, [$fff7]
	ld e, a
	ld d, $00
	ld hl, $4100
	add hl, de
	ld d, [hl]
	ldh a, [$fff9]
	and a
	jr z, jr_002_4190

	ld a, e
	cp $0a
	jr nc, jr_002_4190

	ld a, $21
	jr jr_002_4191

Jump_002_418c:
jr_002_418c:
	xor a
	ld [$d46c], a

jr_002_4190:
	ld a, d

jr_002_4191:
	ld e, a
	ld d, $00
	ldh [$ffb0], a
	call Call_27A8
	ld a, e
	cp $25
	jr nc, jr_002_41a6

	ld hl, $4120
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_002_41b9

jr_002_41a6:
	ld a, [$d47c]
	and a
	jr z, jr_002_41b9

	ld a, $49
	ld [$d368], a
	ldh [$ffbd], a
	ldh [$ffbf], a
	xor a
	ld [$c1cf], a

jr_002_41b9:
	ret


Call_02_41BA::
	push bc
	ld a, $07
	call Call_3C01
	jr c, jr_002_41e4

	ld hl, $c280
	add hl, de
	dec [hl]
	ldh a, [$ffce]
	and $f0
	add $08
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffcd]
	and $f0
	add $10
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ldh a, [$ffdf]
	ld [hl], a

jr_002_41e4:
	pop bc
	ret


	db $21, $46, $c1, $fa, $66, $c1, $b6, $20, $42, $ea, $a4, $c5, $ea, $a5, $c5, $cd
	db $4a, $09, $fa, $49, $db, $e6, $07, $28, $29, $fa, $4a, $db, $fe, $01, $28, $0e
	db $fe, $02, $28, $14, $3e, $dc, $ea, $66, $c1, $3e, $09, $e0, $f3, $c9, $3e, $d0
	db $ea, $66, $c1, $3e, $0b, $e0, $f3, $c9, $3e, $bb, $ea, $66, $c1, $3e, $0a, $e0
	db $f3, $c9, $3e, $d0, $ea, $66, $c1, $3e, $15, $e0, $f3, $c9, $c9, $30, $d0, $00
	db $00, $00, $00, $d0, $30, $fa, $46, $c1, $a7, $20, $2c, $3e, $03, $cd, $eb, $10
	db $38, $25, $21, $e0, $c2, $19, $36, $2a, $21, $b0, $c3, $19, $af, $77, $f0, $9e
	db $4f, $06, $00, $21, $33, $42, $09, $7e, $21, $40, $c2, $19, $77, $21, $37, $42
	db $09, $7e, $21, $50, $c2, $19, $77, $c9

	ld a, [$c14c]
	and a
	jr z, jr_002_4278

	dec a
	ld [$c14c], a

jr_002_4278:
	ld a, [$c1c4]
	and a
	jr z, jr_002_4282

	dec a
	ld [$c1c4], a

jr_002_4282:
	ld a, [$c1c0]
	and a
	jr z, jr_002_428c

	dec a
	ld [$c1c0], a

jr_002_428c:
	call Call_02_4353
	ld a, [$c16e]
	and a
	jr z, jr_002_4299

	dec a
	ld [$c16e], a

jr_002_4299:
	ldh a, [$ffa1]
	cp $02
	jr nz, jr_002_42ae

	xor a
	ldh [$ffa1], a
	ldh [$ff9a], a
	ldh [$ff9b], a
	ldh [$ffa3], a
	call Call_02_49C5
	jp Jump_002_77fa


jr_002_42ae:
	call Call_19EF
	xor a
	ldh [$ffa1], a
	call Call_1E73
	call Call_0D68
	call Call_02_4497
	call Call_02_4331
	call Call_02_4738
	call Call_02_4AF8
	call Call_149B
	call Call_02_431F
	call Call_02_49C5
	ld a, [$c124]
	and a
	jr nz, jr_002_42fc

	ld a, [$c137]
	ld [$c16a], a
	cp $05
	jr nz, jr_002_42fd

	ld a, [$c14a]
	and a
	jr nz, jr_002_431a

	xor a
	ld [$c137], a
	ld a, [$c122]
	cp $28
	jr z, jr_002_42fc

	inc a
	ld [$c122], a
	cp $28
	jr nz, jr_002_42fc

	ld a, $04
	ldh [$fff2], a

jr_002_42fc:
	ret


jr_002_42fd:
	ld a, [$c1ad]
	cp $01
	jr z, jr_002_431a

	ld a, [$c122]
	cp $28
	jr nz, jr_002_431a

	ld a, [$c16e]
	and a
	jr nz, jr_002_431e

	ld a, $20
	ld [$c121], a
	ld a, $03
	ldh [$fff4], a

jr_002_431a:
	xor a
	ld [$c122], a

jr_002_431e:
	ret


Call_02_431F::
	ld a, [$c15c]
	cp $02
	jr c, jr_002_432c

	ldh [$ff9d], a
	ld a, $01
	ldh [$ffa1], a

jr_002_432c:
	ret


	db $11, $10, $0f, $0e

Call_02_4331::
	ld a, [$c19b]
	and $7f
	jr z, jr_002_434e

	ld a, [$c19b]
	dec a
	ld [$c19b], a
	and $7f
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $432d
	add hl, de
	ld a, [hl]
	ldh [$ff9d], a
	ret


jr_002_434e:
	xor a
	ld [$c19b], a
	ret


Call_02_4353::
	ldh a, [$fff9]
	and a
	jr z, jr_002_4362

	ld a, [$c17b]
	and a
	jr nz, jr_002_4362

	call Call_02_6BEF
	ret


jr_002_4362:
	ld a, [$dbae]
	ld [$d46b], a
	call Call_02_446A
	ldh a, [$ffa2]
	and a
	jr nz, jr_002_4376

	ldh a, [$ffa1]
	and a
	jp nz, Jump_002_445c

jr_002_4376:
	ld a, [$c14a]
	and a
	jr z, jr_002_43a9

	ldh a, [$ffcc]
	and $0f
	jr z, jr_002_438e

	ld e, a
	ld d, $00
	ld hl, $48b3
	add hl, de
	ldh a, [$ff9e]
	cp [hl]
	jr nz, jr_002_439b

jr_002_438e:
	ld a, [$c120]
	add $02
	ld [$c120], a
	call Call_145D
	jr jr_002_440a

jr_002_439b:
	ld [$c19a], a
	ld a, [$c199]
	add $0c
	ld [$c199], a
	call Call_093B

jr_002_43a9:
	ld a, [$c146]
	and a
	jr nz, jr_002_440a

	ld e, $00
	ld a, [$d47c]
	cp $01
	jr nz, jr_002_43ba

	ld e, $10

jr_002_43ba:
	ldh a, [$ffcb]
	and $0f
	or e
	ld e, a
	ld d, $00
	ld hl, $4873
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $4893
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	ld a, [$c17b]
	and a
	jr z, jr_002_43e0

	ld hl, $ff9a
	sla [hl]
	ld hl, $ff9b
	sla [hl]

jr_002_43e0:
	ld a, e
	and $0f
	ld e, a
	jr z, jr_002_43ff

	ld hl, $c120
	inc [hl]
	ld hl, $48b3
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, jr_002_440a

	ld e, a
	ld a, [$c16e]
	and a
	ld a, e
	jr nz, jr_002_43fd

	ldh [$ff9e], a

jr_002_43fd:
	jr jr_002_440a

jr_002_43ff:
	ld a, [$c14b]
	and a
	jr nz, jr_002_440a

	ld a, $07
	ld [$c120], a

jr_002_440a:
	ld e, $03
	ld a, [$c117]
	and a
	jr nz, jr_002_4448

	ld e, $01
	ld a, [$c15c]
	and a
	jr z, jr_002_4427

	ld a, [$c5a8]
	cp $d5
	jr nz, jr_002_4427

	ld a, [$c146]
	and a
	jr nz, jr_002_4448

jr_002_4427:
	ldh a, [$ffb2]
	and a
	jr nz, jr_002_4448

	ld hl, $c11f
	ld a, [hl]
	and a
	jr z, jr_002_4454

	cp $07
	jr nz, jr_002_444f

	ld a, [$c17b]
	and a
	jr nz, jr_002_4454

	ld e, $01
	ld a, [$c1bb]
	cp $18
	jr c, jr_002_4448

	ld e, $07

jr_002_4448:
	ldh a, [$ffe7]
	and e
	jr nz, jr_002_445c

	jr jr_002_4454

jr_002_444f:
	ldh a, [$ffe7]
	and [hl]
	jr z, jr_002_4469

jr_002_4454:
	ld a, [$c14f]
	and a
	ret nz

	call Call_20D6

Jump_002_445c:
jr_002_445c:
	ld a, [$c11f]
	ld [$c130], a
	xor a
	ld [$c11f], a
	call Call_02_6FB1

jr_002_4469:
	ret


Call_02_446A::
	ld a, [$c13e]
	and a
	jr z, jr_002_4490

	dec a
	ld [$c13e], a
	call Call_20D6
	call Call_02_6FB1
	ld a, [$c133]
	and a
	jr z, jr_002_448c

	and $03
	jr z, jr_002_4489

	xor a
	ldh [$ff9b], a
	jr jr_002_448c

jr_002_4489:
	xor a
	ldh [$ff9a], a

jr_002_448c:
	pop af
	call Call_149B

jr_002_4490:
	ret


	db $00, $f0, $10, $00, $ff, $01

Call_02_4497::
	ld a, [$c146]
	and a
	jp z, Jump_002_4556

	ldh a, [$fff9]
	and a
	jp nz, Jump_002_4556

	call Call_210F
	ldh a, [$ffa3]
	sub $02
	ldh [$ffa3], a
	ld a, $ff
	ld [$c120], a
	ld a, [$c10a]
	ld hl, $c14a
	or [hl]
	jr nz, jr_002_450d

	ld a, [$d475]
	and a
	jr nz, jr_002_44c8

	ld a, [$c1ad]
	cp $80
	jr nz, jr_002_44cd

jr_002_44c8:
	call Call_1495
	jr jr_002_450d

jr_002_44cd:
	ldh a, [$ffcb]
	and $03
	jr z, jr_002_44ec

	ld e, a
	ld d, $00
	ld hl, $6be9
	add hl, de
	ldh a, [$ff9a]
	sub [hl]
	jr z, jr_002_44ec

	ld e, $01
	bit 7, a
	jr nz, jr_002_44e7

	ld e, $ff

jr_002_44e7:
	ldh a, [$ff9a]
	add e
	ldh [$ff9a], a

jr_002_44ec:
	ldh a, [$ffcb]
	rra
	rra
	and $03
	jr z, jr_002_450d

	ld e, a
	ld d, $00
	ld hl, $4491
	add hl, de
	ldh a, [$ff9b]
	sub [hl]
	jr z, jr_002_450d

	ld e, $01
	bit 7, a
	jr nz, jr_002_4508

	ld e, $ff

jr_002_4508:
	ldh a, [$ff9b]
	add e
	ldh [$ff9b], a

jr_002_450d:
	ldh a, [$ffa2]
	and a
	jr z, jr_002_4516

	and $80
	jr z, jr_002_4556

jr_002_4516:
	call Call_0942
	ldh [$ffa2], a
	ld [$c149], a
	ldh [$ffa3], a
	ld [$c146], a
	ld [$c152], a
	ld [$c153], a
	ld [$c10a], a
	ldh a, [$ff99]
	cp $88
	jr nc, jr_002_4556

	call Call_02_787D
	ldh a, [$ffb8]
	cp $61
	jr z, jr_002_4556

	ld a, [$c181]
	cp $05
	jr z, jr_002_4557

	cp $07
	jr z, jr_002_4556

	cp $0b
	jr z, jr_002_4556

	cp $50
	jr z, jr_002_4556

	cp $51
	jr z, jr_002_4556

	ld a, $07
	ldh [$fff4], a

Jump_002_4556:
jr_002_4556:
	ret


jr_002_4557:
	ldh a, [$ff99]
	ldh [$ffd8], a
	ldh a, [$ff98]
	ldh [$ffd7], a
	ld a, $0e
	ldh [$fff2], a
	ld a, $0c
	call Call_0953
	ret


	db $00, $00, $08, $06, $00, $06, $00, $00, $08, $0a, $00, $0a, $00, $00, $08, $10
	db $00, $10, $00, $00, $08, $08, $00, $08, $00, $00, $05, $0a, $00, $0a, $00, $00
	db $05, $0a, $00, $0a, $00, $00, $05, $08, $00, $08, $00, $00, $05, $08, $00, $08
	db $00, $00, $08, $08, $00, $08, $00, $00, $08, $08, $00, $08, $00, $00, $08, $08
	db $00, $08, $00, $00, $08, $08, $00, $08, $00, $00, $05, $08, $00, $08, $00, $00
	db $05, $08, $00, $08, $00, $00, $05, $08, $00, $08, $00, $00, $05, $08, $00, $08
	db $00, $06, $07, $00, $01, $00, $00, $06, $05, $04, $03, $04, $00, $00, $07, $06
	db $05, $06, $00, $04, $03, $02, $01, $02, $00, $18, $19, $11, $11, $ff, $00, $16
	db $17, $10, $10, $ff, $00, $14, $15, $0f, $0f, $ff, $00, $12, $13, $0e, $0e, $ff
	db $00, $00, $0d, $13, $10, $0b, $00, $f8, $f3, $ed, $f0, $f5, $00, $10, $0d, $f8
	db $f5, $f8, $00, $f0, $f3, $00, $0c, $00, $00, $f0, $f3, $00, $0c, $00, $00, $f0
	db $f3, $00, $0c, $00, $00, $f8, $f3, $f0, $f3, $f5, $00, $00, $0d, $10, $0d, $0d
	db $00, $00, $00, $03, $03, $00, $00, $00, $00, $fd, $fd, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $fd, $fd, $00, $00, $00, $00, $03, $03, $00
	db $03, $03, $08, $01, $01, $01, $01, $61, $62, $63, $00, $5e, $5f, $60, $00, $67
	db $68, $69, $00, $64, $65, $66, $00, $00, $03, $01, $02, $03, $02, $03, $02, $03
	db $02, $03, $04, $03, $04, $03, $02, $03, $04, $03, $04, $03, $02, $03, $04, $03
	db $04, $03, $04, $03, $04, $03, $04, $03, $02, $03, $04, $00, $02, $02, $01, $01
	db $03, $03, $00, $01, $02, $02, $00, $00, $03, $03, $01, $02, $00, $00, $03, $03
	db $01, $01, $02, $03, $01, $01, $02, $02, $00, $00, $03

Jump_002_46b4:
	dec a
	ld [$c121], a
	ld hl, $ffa1
	ld [hl], $01
	srl a
	srl a
	ld e, a
	ld d, $00
	ldh a, [$ff9e]
	sla a
	sla a
	sla a
	add e
	ld e, a
	ld hl, $4674
	add hl, de
	ld a, [hl]
	ld [$c137], a
	ld hl, $4694
	add hl, de
	ldh a, [$ff9e]
	push af
	ld a, [hl]
	ldh [$ff9e], a
	call Call_02_47D4
	pop af
	ldh [$ff9e], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_002_46f0

	ld hl, $c121
	dec [hl]

jr_002_46f0:
	ld a, [$c121]
	and a
	jp z, Call_02_485E

	rla
	jp c, Call_02_485E

	ldh a, [$ff98]
	add $08
	ld [$c140], a
	ld a, $18
	ld [$c141], a
	ld [$c143], a
	ld a, [$c145]
	add $08
	ld [$c142], a
	ld [$c5b0], a
	ret


Jump_002_4716:
	dec a
	ld [$c16d], a
	jp z, Call_02_485E

	ld hl, $c16e
	ld [hl], $04
	ld a, [$c14a]
	and a
	jr nz, jr_002_472c

	ld a, $01
	ldh [$ffa1], a

jr_002_472c:
	ld a, $03
	ld [$c137], a
	jp Call_02_47D4


jr_002_4734:
	call Call_02_47D4

jr_002_4737:
	ret


Call_02_4738::
	ld a, [$d475]
	and a
	jr z, jr_002_474f

	ldh a, [$ffe7]
	rra
	rra
	and $03
	ld e, a
	ld d, $00
	ld hl, $4670
	add hl, de
	ld a, [hl]
	ldh [$ff9e], a
	ret


jr_002_474f:
	ld a, [$c146]
	cp $01
	jr nz, jr_002_478c

	ld a, [$c3cf]
	ld hl, $c137
	or [hl]
	jr nz, jr_002_478c

	ldh a, [$ff9e]
	rla
	rla
	and $0c
	ld c, a
	ld b, $00
	ld a, [$c152]
	cp $03
	jr nc, jr_002_478c

	ld e, a
	ld d, $00
	ld hl, $4660
	add hl, de
	add hl, bc
	ld a, [hl]
	ldh [$ff9d], a
	ld a, [$c153]
	inc a
	ld [$c153], a
	and $07
	jr nz, jr_002_478c

	ld a, [$c152]
	inc a
	ld [$c152], a

jr_002_478c:
	ld a, [$c121]
	and a
	jp nz, Jump_002_46b4

	ld a, [$c16d]
	and a
	jp nz, Jump_002_4716

	ld a, [$c137]
	and a
	jr z, jr_002_4737

	ld hl, $c16e
	ld [hl], $04
	ld a, [$c137]
	cp $05
	jr nc, jr_002_4734

	ld a, [$c14a]
	and a
	jr nz, jr_002_47b6

	ld a, $01
	ldh [$ffa1], a

jr_002_47b6:
	ld a, [$c138]
	and a
	jr nz, jr_002_47d0

	ld a, [$c137]
	inc a
	ld [$c137], a
	cp $04
	jp z, Call_02_485E

	ld c, a
	ld b, $00
	ld hl, $4658
	add hl, bc
	ld a, [hl]

jr_002_47d0:
	dec a
	ld [$c138], a

Call_02_47D4::
	ld hl, $c137
	ldh a, [$ff9e]
	ld e, a
	sla a
	sla a
	add e
	add e
	add [hl]
	ld c, a
	ld b, $00
	ld hl, $45c9
	add hl, bc
	ld a, [hl]
	ld [$c136], a
	ld hl, $45e1
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_002_47f7

	ldh [$ff9d], a

jr_002_47f7:
	ld hl, $45f9
	add hl, bc
	ld a, [hl]
	ld [$c13a], a
	ld hl, $4611
	add hl, bc
	ld a, [hl]
	ld [$c139], a
	ld hl, $4629
	add hl, bc
	ld a, [hl]
	ld [$c13c], a
	ld hl, $4641
	add hl, bc
	ld a, [hl]
	ld [$c13b], a
	ld hl, $4569
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_002_485a

	ld a, [$c15b]
	and a
	jr z, jr_002_482b

	ldh a, [$ffe7]
	and $01
	jr nz, jr_002_485a

jr_002_482b:
	ld a, [$c13a]
	add [hl]
	ld hl, $ff98
	add [hl]
	ld [$c140], a
	ld hl, $4581
	add hl, bc
	ld a, [hl]
	ld [$c141], a
	ld a, [$c139]
	ld hl, $4599
	add hl, bc
	add [hl]
	ld hl, $c145
	add [hl]
	ld [$c142], a
	ld hl, $45b1
	add hl, bc
	ld a, [hl]
	ld [$c143], a
	ld a, $01
	ld [$c5b0], a

jr_002_485a:
	call Call_12AE
	ret


Call_02_485E::
	xor a
	ld [$c1ac], a
	ld a, [$c14a]
	and a
	jr nz, jr_002_4872

	xor a
	ld [$c137], a
	ld [$c16a], a
	ld [$c121], a

jr_002_4872:
	ret


	db $00, $10, $f0, $00, $00, $0c, $f4, $00, $00, $0c, $f4, $00, $00, $00, $00, $00
	db $00, $14, $ec, $00, $00, $0f, $f1, $00, $00, $0f, $f1, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $f0, $f4, $f4, $00, $10, $0c, $0c, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $ec, $f1, $f1, $00, $14, $0f, $0f, $00, $00, $00, $00, $00
	db $0f, $00, $01, $0f, $02, $0f, $0f, $0f, $03, $0f, $0f, $0a, $0b, $06, $07, $04
	db $05, $00, $01, $2c, $2d, $06, $07, $34, $35, $22, $23, $2a, $2b, $28, $29, $30
	db $31, $24, $25, $2e, $2f, $06, $07, $34, $35, $22, $23, $2a, $2b, $28, $29, $32
	db $33, $26, $27, $20, $21, $1e, $1f, $1c, $1d, $1a, $1b, $3e, $3f, $40, $41, $42
	db $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $4e, $4f, $4e
	db $4f, $4e, $4f, $5b, $5c, $58, $59, $5b, $5c, $58, $59, $3e, $02, $ea, $c4, $c1
	db $f0, $9c, $a7, $20, $40, $f0, $99, $c6, $10, $e0, $99, $e0, $a0, $f0, $a2, $c6
	db $10, $e0, $a2, $3e, $ff, $e0, $9b, $af, $e0, $9a, $f0, $99, $c6, $08, $e0, $99
	db $e0, $a0, $f0, $a2, $c6, $08, $e0, $a2, $cd, $80, $71, $f0, $af, $fe, $e1, $28
	db $e2, $fe, $61, $28, $06, $fa, $33, $c1, $a7, $20, $d8, $3e, $01, $e0, $9c, $f0
	db $99, $d6, $03, $e0, $99, $cd, $a4, $44, $f0, $a2, $a7, $20, $04, $af, $ea, $1c
	db $c1, $3e, $01, $ea, $46, $c1, $cd, $68, $0d, $cd, $38, $47, $fa, $37, $c1, $ea
	db $6a, $c1, $cd, $9b, $14, $c9, $01, $00, $01, $00, $00, $01, $00, $01, $01, $01
	db $00, $00, $00, $00, $01, $01, $01, $00, $01, $00, $00, $01, $00, $01, $01, $01
	db $00, $00, $00, $00, $01, $01, $00, $01, $01, $01, $01, $00, $01, $01, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $01, $00, $01, $01, $00, $01, $00, $00, $01, $08, $f8
	db $06, $01

Call_02_49C5::
	ld a, [$c166]
	and a
	ret z

	ld hl, $ffa1
	ld [hl], $02
	cp $ff
	jr nz, jr_002_4a2b

	ld a, [$d210]
	add $01
	ld [$d210], a
	ld a, [$d211]
	adc $00
	ld [$d211], a
	cp $08
	jr nz, jr_002_4a02

	ld a, [$d210]
	cp $d0
	jr nz, jr_002_4a02

	xor a
	ld [$c166], a
	ld [$c167], a
	ld a, $03
	ld [$c5a3], a
	ld a, [$d465]
	cp $47
	ret z

	jr jr_002_4a1b

jr_002_4a02:
	ld a, [$d465]
	cp $47
	jr z, jr_002_4a29

	ldh a, [$ffcc]
	and $30
	jr z, jr_002_4a29

	xor a
	ld [$c166], a
	ld [$c167], a
	ld a, $03
	ld [$c5a3], a

jr_002_4a1b:
	ld a, [$d461]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld [hl], $00
	jp Call_27BD


jr_002_4a29:
	jr jr_002_4a80

jr_002_4a2b:
	call Call_1495
	call Call_093B
	ld hl, $c166
	dec [hl]
	jr nz, jr_002_4a80

	ld a, [$db73]
	and a
	jr z, jr_002_4a51

	ld a, [$db4a]
	cp $01
	jr z, jr_002_4a61

	ld a, [$dba5]
	and a
	jr nz, jr_002_4a61

	ld a, $77
	call Call_218E
	jr jr_002_4a61

jr_002_4a51:
	ld a, [$db49]
	and a
	jr nz, jr_002_4a61

	ld a, $8e
	call Call_2197
	xor a
	ld [$c167], a
	ret


jr_002_4a61:
	xor a
	ld [$c167], a
	ld a, [$db4a]
	cp $01
	jr nz, jr_002_4a7f

	ld a, $02
	ld [$c17f], a
	xor a
	ld [$c180], a
	ld [$c16b], a
	ld [$c16c], a
	ld a, $2c
	ldh [$fff2], a

jr_002_4a7f:
	ret


jr_002_4a80:
	ld a, [$c5a4]
	inc a
	ld [$c5a4], a
	cp $38
	jr c, jr_002_4a97

	xor a
	ld [$c5a4], a
	ld a, [$c5a5]
	xor $01
	ld [$c5a5], a

jr_002_4a97:
	ld a, [$c5a5]
	ld e, $75
	and a
	jr nz, jr_002_4aa0

	inc e

jr_002_4aa0:
	ld a, e
	ldh [$ff9d], a
	ld a, $02
	ld [$c167], a
	ld [$c111], a
	ld a, [$c166]
	cp $10
	ret c

	ld a, [$c5a4]
	cp $14
	jr nz, jr_002_4aef

	ld a, $c9
	call Call_3C01
	jr c, jr_002_4aef

	ldh a, [$ff99]
	ld hl, $c210
	add hl, de
	sub $08
	ld [hl], a
	ld a, [$c5a5]
	ld c, a
	ld b, d
	ld hl, $49c1
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $49c3
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

jr_002_4aef:
	ret


	db $71, $72, $6f, $70, $73, $74, $6d, $6e

Call_02_4AF8::
	ld a, [$c1c7]
	and a
	jr z, jr_002_4b6e

	ldh a, [$fff7]
	cp $08
	jr nz, jr_002_4b13

	ld a, [$d219]
	cp $02
	jr nz, jr_002_4b13

	call Call_0F3F
	ld a, $01
	ld [$c5b0], a

jr_002_4b13:
	ld hl, $ffa1
	ld [hl], $01
	call Call_1495
	ld [$c137], a
	ld [$c121], a
	ld [$c122], a
	ld a, [$c1c8]
	inc a
	ld [$c1c8], a
	cp $10
	jr nz, jr_002_4b34

	push af
	call Call_02_4B77
	pop af

jr_002_4b34:
	cp $18
	jr nz, jr_002_4b58

	ld a, [$c1c7]
	cp $02
	jr nz, jr_002_4b50

	ld a, [$db73]
	and a
	jr z, jr_002_4b50

	ld a, [$c19f]
	and a
	jr nz, jr_002_4b50

	ld a, $79
	call Call_218E

jr_002_4b50:
	xor a
	ld [$c1c7], a
	ld [$c1ac], a
	ret


jr_002_4b58:
	rra
	rra
	rra
	rra
	and $01
	ld e, a
	ldh a, [$ff9e]
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $4af0
	add hl, de
	ld a, [hl]
	ldh [$ff9d], a

jr_002_4b6e:
	ret


	db $14, $fc, $08, $08, $0a, $0a, $fc, $14

Call_02_4B77::
	call Call_02_4C35
	jr c, jr_002_4b84

	ld a, $02
	ld [$c1c7], a
	call Call_02_4B85

jr_002_4b84:
	ret


Call_02_4B85::
	ldh a, [$ffd8]
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ld [hl], $cc
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
	ld a, [$dba5]
	and a
	jr z, jr_002_4bc8

	ld a, $04
	ld [hli], a
	ld a, $06
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
	ld a, $07
	jr jr_002_4bdd

jr_002_4bc8:
	ld a, $6a
	ld [hli], a
	ld a, $7a
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $6b
	ld [hli], a
	ld a, $7b

jr_002_4bdd:
	ld [hli], a
	ld a, $00
	ld [hli], a
	call Call_27ED
	and $07
	jr nz, jr_002_4c34

	call Call_27ED
	rra
	ld a, $2e
	jr nc, jr_002_4bf2

	ld a, $2d

jr_002_4bf2:
	call Call_3C01
	jr c, jr_002_4c34

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
	ld [hl], $20
	push de
	pop bc
	ld a, $0c
	call Call_3C25
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

jr_002_4c34:
	ret


Call_02_4C35::
	ld a, [$c15c]
	ld hl, $ffa2
	or [hl]
	ld hl, $c11c
	or [hl]
	ld hl, $fff9
	or [hl]
	jp nz, Jump_002_4caa

	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $4b6f
	add hl, de
	ldh a, [$ff98]
	add [hl]
	sub $08
	and $f0
	ldh [$ffce], a
	swap a
	ld c, a
	ld hl, $4b73
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
	jp nz, Jump_002_4caa

	ld a, [hl]
	ldh [$ffd7], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	cp $00
	jr nz, jr_002_4caa

	ld a, d
	and a
	jr nz, jr_002_4ca2

	ldh a, [$ffd7]
	cp $0c
	jr z, jr_002_4caa

	cp $0d
	jr z, jr_002_4caa

	cp $0c
	jr z, jr_002_4caa

	cp $0d
	jr z, jr_002_4caa

	cp $b9
	jr z, jr_002_4caa

	jr jr_002_4ca8

jr_002_4ca2:
	ldh a, [$ffd7]
	cp $05
	jr nz, jr_002_4caa

jr_002_4ca8:
	and a
	ret


Jump_002_4caa:
jr_002_4caa:
	scf
	ret


Jump_002_4cac:
	ldh a, [$ffd7]
	ldh [$ffce], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffd8]
	ldh [$ffcd], a
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ld [hl], $ae
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
	ld a, $76
	ld [hli], a
	ld a, $77
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, $76
	ld [hli], a
	ld a, $77
	ld [hli], a
	ld [hl], $00
	ret


	db $50, $51, $52, $53, $53, $54, $52, $3e, $10, $e0, $99, $3e, $50, $e0, $98, $ea
	db $67, $c1, $fa, $98, $c1, $1f, $1f, $1f, $e6, $07, $5f, $16, $00, $21, $f9, $4c
	db $19, $7e, $e0, $9d, $fa, $98, $c1, $3c, $ea, $98, $c1, $fe, $38, $38, $0c, $3e
	db $fb, $e0, $99, $3e, $02, $e0, $9e, $3e, $04, $e0, $9d, $fa, $98, $c1, $fe, $48
	db $20, $16, $3e, $02, $ea, $25, $c1, $3e, $01, $ea, $24, $c1, $af, $ea, $98, $c1
	db $ea, $67, $c1, $3e, $00, $ea, $1c, $c1, $c9, $00, $08, $f8, $00, $00, $06, $fa
	db $00, $00, $06, $fa, $00, $00, $00, $00, $00, $00, $10, $f0, $00, $00, $0c, $f4
	db $00, $00, $0c, $f4, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f8, $fa, $fa
	db $00, $08, $06, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f4, $f4
	db $00, $10, $0c, $0c, $00, $00, $00, $00, $00, $fa, $7b, $c1, $a7, $28, $06, $3e
	db $00, $ea, $1c, $c1, $c9, $cd, $3b, $09, $e0, $a2, $ea, $46, $c1, $ea, $9b, $c1
	db $ea, $37, $c1, $ea, $6a, $c1, $ea, $6d, $c1, $21, $9f, $c1, $f0, $a1, $b6, $ca
	db $c9, $4d, $cd, $95, $14, $f0, $a1, $a7, $28, $03, $af, $e0, $a1, $c3, $ef, $19
	db $f0, $cc, $e6, $20, $28, $13, $f0, $9c, $ee, $01, $e0, $9c, $28, $0b, $3e, $a0
	db $e0, $b7, $f0, $99, $d6, $03, $cd, $1d, $57, $fa, $83, $c1, $a7, $28, $06, $3d
	db $ea, $83, $c1, $18, $0f, $f0, $cc, $e6, $10, $28, $09, $3e, $0f, $e0, $f2, $3e
	db $20, $ea, $83, $c1, $f0, $e7, $e6, $01, $20, $5e, $f0, $cb, $e6, $0f, $5f, $16
	db $00, $21, $52, $4d, $fa, $83, $c1, $fe, $10, $38, $03, $21, $62, $4d, $19, $7e
	db $21, $9a, $ff, $96, $28, $07, $34, $cb, $7f, $28, $02, $35, $35, $21, $72, $4d
	db $fa, $83, $c1, $fe, $10, $38, $03, $21, $82, $4d, $19, $7e, $21, $9b, $ff, $96
	db $28, $07, $34, $cb, $7f, $28, $02, $35, $35, $f0, $9a, $b6, $21, $9c, $ff, $b6
	db $28, $06, $21, $20, $c1, $34, $18, $05, $3e, $03, $ea, $20, $c1, $21, $b3, $48
	db $19, $7e, $fe, $0f, $28, $02, $e0, $9e, $cd, $ef, $19, $f0, $a1, $a7, $28, $05
	db $af, $e0, $a1, $18, $03, $cd, $54, $44, $cd, $fa, $77, $f0, $9c, $a7, $28, $5c
	db $f0, $b7, $a7, $20, $02, $e0, $9c, $f0, $f7, $a7, $28, $0c, $fe, $1f, $20, $4d
	db $f0, $f6, $fe, $f2, $20, $46, $18, $06, $f0, $f6, $fe, $78, $20, $3e, $f0, $99
	db $d6, $50, $c6, $08, $fe, $10, $30, $5d, $f0, $98, $d6, $58, $c6, $08, $fe, $10
	db $30, $53, $21, $f8, $ff, $cb, $6e, $20, $23, $cb, $ee, $3e, $35, $cd, $01, $3c
	db $38, $1a, $f0, $98, $21, $00, $c2, $19, $77, $f0, $99, $21, $10, $c2, $19, $77
	db $21, $10, $c3, $19, $36, $03, $21, $40, $c3, $19, $cb, $a6, $c9, $f0, $f6, $fe
	db $8d, $20, $22, $f0, $99, $d6, $50, $c6, $08, $fe, $10, $30, $18, $f0, $98, $d6
	db $58, $c6, $08, $fe, $10, $30, $0e, $f0, $98, $ea, $04, $d4, $fa, $1c, $c1, $ea
	db $63, $d4, $c3, $09, $09, $c9, $3e, $01, $e0, $a1, $cd, $d6, $20, $cd, $0f, $21
	db $f0, $98, $e6, $f0, $fe, $e0, $28, $05, $f0, $a2, $fe, $78, $d8, $cd, $0f, $09
	db $cd, $95, $14, $e0, $a2, $e0, $a3, $3e, $70, $ea, $c8, $db, $c9, $55, $56, $57
	db $57, $ff, $ff, $ff, $ff, $ff, $ff, $3e, $01, $ea, $67, $c1, $fa, $98, $c1, $3c
	db $ea, $98, $c1, $1f, $1f, $1f, $1f, $00, $e6, $0f, $fe, $06, $28, $0b, $5f, $16
	db $00, $21, $26, $4f, $19, $7e, $e0, $9d, $c9, $af, $ea, $3e, $c1, $ea, $21, $c1
	db $ea, $22, $c1, $cd, $11, $51, $fa, $a5, $db, $a7, $20, $22, $f0, $f6, $fe, $01
	db $28, $0c, $fe, $95, $28, $08, $fe, $2c, $28, $04, $fe, $ec, $20, $10, $3e, $09
	db $ea, $1c, $c1, $3e, $40, $e0, $b7, $af, $e0, $9c, $3d, $e0, $9d, $c9, $fa, $cb
	db $db, $fe, $50, $28, $38, $fe, $ff, $28, $1f, $fa, $01, $d4, $fe, $02, $20, $08
	db $f0, $99, $ea, $04, $d4, $af, $18, $17, $f0, $98, $e6, $f0, $c6, $08, $ea, $04
	db $d4, $f0, $99, $e6, $f0, $ea, $05, $d4, $3e, $01, $ea, $75, $d4, $3e, $70, $ea
	db $c8, $db, $cd, $95, $14, $e0, $a3, $ea, $46, $c1, $c3, $0f, $09, $fa, $a5, $db
	db $a7, $20, $06, $f0, $f6, $fe, $1e, $28, $df, $f0, $f7, $fe, $0a, $20, $30, $f0
	db $f6, $fe, $7a, $28, $0c, $fe, $7b, $28, $08, $fe, $7c, $28, $04, $fe, $7d, $20
	db $1e, $3e, $00, $21, $01, $d4, $22, $3e, $00, $22, $3e, $1a, $22, $3e, $68, $22
	db $3e, $56, $22, $3e, $24, $ea, $c8, $db, $3e, $03, $e0, $9e, $c3, $0f, $09, $cd
	db $f4, $50, $fa, $94, $db, $c6, $04, $ea, $94, $db, $af, $ea, $67, $c1, $c9, $fa
	db $aa, $c1, $fe, $2e, $20, $04, $3e, $17, $e0, $f2, $cd, $3b, $09, $ea, $6a, $c1
	db $ea, $37, $c1, $ea, $3e, $c1, $cd, $9b, $14, $cd, $0f, $21, $f0, $a3, $d6, $02
	db $e0, $a3, $f0, $a2, $e6, $80, $28, $08, $af, $e0, $a2, $ea, $49, $c1, $e0, $a3
	db $3e, $6b, $e0, $9d, $01, $10, $c0, $f0, $99, $21, $a2, $ff, $96, $21, $3b, $c1
	db $86, $d6, $10, $e0, $d7, $fa, $a9, $c1, $fe, $01, $28, $24, $f0, $d7, $c6, $02
	db $02, $03, $f0, $98, $c6, $00, $02, $fa, $a9, $c1, $1e, $ae, $fe, $05, $28, $08
	db $fe, $04, $1e, $8e, $20, $02, $1e, $8c, $03, $7b, $02, $3e, $10, $03, $02, $c9
	db $f0, $98, $d6, $08, $e0, $d8, $f0, $e7, $17, $17, $e6, $10, $e0, $da, $af, $67
	db $6f, $3e, $06, $e0, $d9, $cd, $40, $15, $c9, $cd, $3b, $09, $cd, $95, $14, $f0
	db $b7, $a7, $20, $2d, $ea, $67, $c1, $f0, $9c, $fe, $06, $20, $08, $fa, $94, $db
	db $c6, $04, $ea, $94, $db, $af, $e0, $9c, $fa, $a5, $db, $a7, $20, $10, $f0, $f6
	db $fe, $2b, $20, $0a, $3e, $48, $ea, $b1, $db, $3e, $30, $ea, $b2, $db, $c3, $f4
	db $50, $1e, $ff, $f0, $b7, $fe, $30, $38, $0e, $1e, $4e, $fe, $40, $38, $08, $20
	db $04, $3e, $03, $e0, $f3, $1e, $4c, $7b, $e0, $9d, $c9, $3e, $40, $ea, $c7, $db
	db $fa, $b1, $db, $e0, $98, $e0, $9f, $fa, $b2, $db, $e0, $99, $e0, $a0, $21, $a2
	db $ff, $96, $ea, $45, $c1, $cd, $45, $4d, $f0, $ac, $a7, $28, $04, $3e, $01, $e0
	db $ac, $c9, $0d, $f3, $00, $ff, $08, $f8, $0c, $f5, $00, $00, $f3, $0e, $f3, $f3
	db $fc, $00, $06, $08, $08, $06, $04, $ff, $ff, $04, $04, $ff, $ff, $04, $06, $08
	db $08, $06, $00, $00, $20, $20, $20, $00, $00, $40, $20, $00, $00, $20, $00, $00
	db $20, $20

Call_02_514B::
	ld a, [$c19b]
	and $7f
	cp $08
	ldh a, [$ff9e]
	jr c, jr_002_5158

	add $04

jr_002_5158:
	ld e, a
	ld d, $00
	ld hl, $5123
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $511b
	add hl, de
	ld a, [hl]
	ldh [$ffd8], a
	sla e
	ld hl, $512b
	add hl, de
	ld a, [hli]
	ldh [$ffd9], a
	ld a, [hl]
	ldh [$ffda], a
	ld hl, $513b
	add hl, de
	ld a, [hli]
	ldh [$ffdb], a
	ld a, [hl]
	ldh [$ffdc], a
	ld de, $c010
	ld bc, $c014
	ld a, [$c145]
	ld hl, $c13b
	add [hl]
	ld hl, $ffd7
	add [hl]
	ld [hl], a
	ldh a, [$ffd9]
	cp $ff
	jr z, jr_002_5199

	ld a, [hl]
	ld [de], a

jr_002_5199:
	ldh a, [$ffda]
	cp $ff
	jr z, jr_002_51a1

	ld a, [hl]
	ld [bc], a

jr_002_51a1:
	inc de
	inc bc
	ldh a, [$ffd8]
	ld hl, $ff98
	add [hl]
	ld [de], a
	add $08
	ld [bc], a
	inc de
	inc bc
	ldh a, [$ffd9]
	ld [de], a
	ldh a, [$ffda]
	ld [bc], a
	inc de
	inc bc
	ldh a, [$ffdb]
	ld [de], a
	ldh a, [$ffdc]
	ld [bc], a
	ret


	db $04, $fc, $fc, $04, $04, $04, $fc, $04

Call_02_51C6::
	ldh a, [$ff9e]
	ld c, a
	ld b, $00
	ld hl, $51be
	add hl, bc
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $51c2
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ld [hl], d
	jp Jump_000_10cb


Call_02_51EB::
	push bc
	push de
	ldh a, [$ffe8]
	cp $40
	jr z, jr_002_5236

	ld a, [$dbd0]
	and a
	jr z, jr_002_5258

	dec a
	ld [$dbd0], a
	call Call_27E2
	call Call_02_525B
	call Call_02_5987
	ld a, [hl]
	or $40
	ld [hl], a
	ldh [$fff8], a
	ldh a, [$ffdb]
	and $f0
	ldh [$ffce], a
	swap a
	ld e, a
	ldh a, [$ffdc]
	and $f0
	ldh [$ffcd], a
	or e
	ld e, a
	ld d, $00
	call Call_20A6
	ldh a, [$ffce]
	add $08
	ldh [$ffd7], a
	ldh a, [$ffcd]
	add $10
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	jp Jump_002_5258


jr_002_5236:
	ld a, $06
	call Call_3C01
	jr c, jr_002_5258

	ld hl, $c280
	add hl, de
	dec [hl]
	ldh a, [$ffdb]
	and $f0
	add $08
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffdc]
	and $f0
	add $10
	ld hl, $c210
	add hl, de
	ld [hl], a

Jump_002_5258:
jr_002_5258:
	pop de
	pop bc
	ret


Call_02_525B::
	ld a, $04
	ldh [$fff4], a
	ret


Call_02_5260::
	push bc
	ldh a, [$fff7]
	cp $0a
	ld a, $30
	jr c, jr_002_526b

	ld a, $3c

jr_002_526b:
	call Call_3C01
	jr c, jr_002_5282

	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $3c
	ld hl, $c310
	add hl, de
	ld [hl], $70

jr_002_5282:
	pop bc
	ret


	db $30, $33, $81, $01, $28, $56, $68, $87, $b3, $e6, $0a, $01, $01, $04, $00, $01
	db $02, $03, $04, $05, $06, $07

Call_02_529A::
	xor a
	ld [$d900], a
	ld [$da00], a
	ld a, [$c134]
	and a
	jr z, jr_002_52ab

	dec a
	ld [$c134], a

jr_002_52ab:
	ldh a, [$ffcb]
	and $20
	jr z, jr_002_52ed

	ldh a, [$ffcc]
	and $40
	jr jr_002_52ed

	db $3e, $01, $ea, $01, $d4, $fa, $79, $d4, $5f, $3c, $fe, $0b, $38, $01, $af, $ea
	db $79, $d4, $16, $00, $21, $84, $52, $19, $7e, $ea, $03, $d4, $21, $8f, $52, $19
	db $7e, $ea, $02, $d4, $3e, $50, $ea, $04, $d4, $3e, $70, $ea, $05, $d4, $21, $f2
	db $ff, $36, $02, $c3, $09, $09

jr_002_52ed:
	ld b, $00
	ld c, $0f

jr_002_52f1:
	ld a, c
	ld [$c123], a
	ld hl, $c510
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_002_5300

	call Call_02_535D

jr_002_5300:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_002_52f1

	ld a, [$c124]
	and a
	jr nz, jr_002_5332

	ldh a, [$ffac]
	and a
	jr z, jr_002_5332

	cp $01
	jr nz, jr_002_5333

	ld hl, $ffad
	ldh a, [$ff98]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_002_532d

	ld hl, $ffae
	ldh a, [$ff99]
	sub [hl]
	add $06
	cp $0c
	jr c, jr_002_5332

jr_002_532d:
	ldh a, [$ffac]
	inc a
	ldh [$ffac], a

jr_002_5332:
	ret


jr_002_5333:
	ldh a, [$ffa2]
	and a
	jr nz, jr_002_535c

	ld hl, $ffad
	ldh a, [$ff98]
	sub [hl]
	add $05
	cp $0a
	jr nc, jr_002_535c

	ld hl, $ffae
	ldh a, [$ff99]
	sub [hl]
	add $05
	cp $0a
	jr nc, jr_002_535c

	ld a, [$c15c]
	and a
	jr nz, jr_002_535c

	call Call_0915
	xor a
	ldh [$ffac], a

jr_002_535c:
	ret


Call_02_535D::
	push af
	ld a, [$c124]
	and a
	jr nz, jr_002_5372

	ld hl, $c520
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_002_5375

	dec a
	ld [hl], a
	ldh [$ffd7], a
	jr nz, jr_002_5375

jr_002_5372:
	call Call_02_56DB

jr_002_5375:
	pop af
	dec a
	rst $00

JumpTable_02_5378::
	dw Jump_02_5619
	dw Jump_02_5699
	dw Jump_02_5699
	dw Jump_02_5699
	dw Jump_02_55E1
	dw Jump_02_55A7
	dw Jump_02_5550
	dw Jump_02_5538
	dw Jump_02_543D
	dw Jump_02_5402
	dw Jump_02_550A
	dw Jump_02_5611
	dw Jump_02_53D2

	db $00, $00, $08, $20, $00, $08, $06, $20, $00, $00, $06, $00, $00, $08, $08, $00
	db $00, $04, $04, $40, $00, $04, $04, $40, $00, $04, $04, $00, $00, $04, $04, $00
	db $00, $00, $08, $30, $00, $08, $06, $30, $00, $00, $06, $10, $00, $08, $08, $10
	db $00, $04, $04, $50, $00, $04, $04, $50, $00, $04, $04, $10, $00, $04, $04, $10

Jump_02_53D2::
	ldh a, [$ffe7]
	xor c
	and $01
	ret z

	call Call_02_56C5
	ld hl, $c590
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $5392
	ldh a, [$ffe7]
	and $02
	jr z, jr_002_53f3

	ld hl, $53b2

jr_002_53f3:
	jp Jump_002_562e


	db $f8, $00, $08, $10, $6c, $6e, $6e, $6c, $00, $00, $20, $20

Jump_02_5402::
	call Call_02_56C5
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	push bc
	ld c, $04

jr_002_5414:
	ldh a, [$ffd8]
	ld [de], a
	inc de
	ldh a, [$ffd9]
	ld hl, $53f5
	add hl, bc
	add [hl]
	ld [de], a
	inc de
	ld hl, $53f9
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, $53fd
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	dec c
	jr nz, jr_002_5414

	pop bc
	ld a, $04
	call Call_02_56EA
	ret


	db $7e, $1f, $0c, $1f

Jump_02_543D::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	xor a
	ld [$c155], a
	ldh a, [$ffd7]
	cp $02
	jr nc, jr_002_5452

	ld hl, $c167
	ld [hl], b

jr_002_5452:
	cp $de
	jr nz, jr_002_545b

	call Call_02_525B
	ld a, $de

jr_002_545b:
	cp $a0
	jr nz, jr_002_5464

	ld hl, $fff4
	ld [hl], $2a

jr_002_5464:
	cp $0a
	jr nz, jr_002_546f

	ld a, $50
	ld [$c5af], a
	ld a, $0a

jr_002_546f:
	cp $20
	jr c, jr_002_5483

	cp $9c
	ret nc

	ld e, $01
	and $04
	jr z, jr_002_547e

	ld e, $fe

jr_002_547e:
	ld a, e
	ld [$c155], a
	ret


jr_002_5483:
	and $0f
	cp $08
	jp nz, Jump_002_54f9

	ldh a, [$ffd7]
	rra
	rra
	rra
	and $02
	ld e, a
	ld d, b
	ld hl, $5439
	add hl, de
	ld a, [hli]
	ldh [$ffd7], a
	ld a, [hl]
	ldh [$ffd8], a
	ld a, $60
	ldh [$ffce], a
	ldh a, [$fff6]
	cp $b5
	ld a, $10
	jr nz, jr_002_54af

	ld a, $60
	ldh [$ffce], a
	ld a, $10

jr_002_54af:
	ldh [$ffcd], a
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, b
	ld hl, $d601
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $41
	ld [hli], a
	ldh a, [$ffd7]
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	add $20
	ld [hli], a
	ld a, $41
	ld [hli], a
	ldh a, [$ffd8]
	ld [hli], a
	ld [hl], b
	ld a, e
	add $08
	ld [$d600], a
	ld hl, $c520
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_002_54f9

	ld hl, $d727
	ldh a, [$fff6]
	cp $b5
	jr nz, jr_002_54f3

	ld hl, $d727

jr_002_54f3:
	ld [hl], $e3
	ld a, $23
	ldh [$fff2], a

Jump_002_54f9:
jr_002_54f9:
	ret


	db $00, $04, $24, $00, $00, $04, $24, $00, $00, $00, $1e, $00, $00, $08, $1e, $60

Jump_02_550A::
	call Call_02_56C5
	ldh a, [$ffd7]
	and $08
	ld d, $00
	ld e, a
	ld hl, $54fa
	ld a, [$c14a]
	and a
	jp nz, Jump_002_562e

	add hl, de
	ld de, $c000
	call Call_02_5649
	jp Call_02_5649


	db $00, $00, $1e, $00, $00, $08, $1e, $60, $00, $00, $30, $00, $00, $08, $30, $60

Jump_02_5538::
	call Call_02_56C5
	ldh a, [$ffd7]
	and $08
	ld d, $00
	ld e, a
	ld hl, $5528
	jp Jump_002_562e


	db $01, $ff, $01, $ff, $01, $01, $ff, $ff

Jump_02_5550::
	ldh a, [$ffd7]
	cp $0a
	jr c, jr_002_5572

	ld hl, $c590
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5548
	add hl, de
	ld a, [hl]
	ld hl, $c530
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $554c
	add hl, de
	ld a, [hl]
	ld hl, $c540
	add hl, bc
	add [hl]
	ld [hl], a

jr_002_5572:
	call Call_02_56C5
	push bc
	ld c, $3a
	ldh a, [$ffd7]
	cp $07
	jr nc, jr_002_5580

	ld c, $3c

jr_002_5580:
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ldh a, [$ffd8]
	ld [hli], a
	ldh a, [$ffd9]
	ld [hli], a
	ld a, c
	ld [hli], a
	xor a
	ld [hli], a
	ldh a, [$ffd8]
	ld [hli], a
	ldh a, [$ffd9]
	add $08
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], $20
	pop bc
	ld a, $02
	call Call_02_56EA
	ret


Jump_02_55A7::
	call Call_02_56C5
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ldh a, [$ffd8]
	ld [hli], a
	ldh a, [$ffd9]
	ld [hli], a
	ld a, $24
	ld [hli], a
	ldh a, [$ffe7]
	xor c
	rl a
	rl a
	rl a
	rl a
	and $10
	ld [hl], a
	ld a, $01
	call Call_02_56EA
	ret


	db $00, $ff, $3c, $00, $00, $07, $3c, $20, $00, $ff, $3a, $00, $00, $07, $3a, $20

Jump_02_55E1::
	call Call_02_56C5
	ldh a, [$ffd7]
	and $08
	ld d, $00
	ld e, a
	ld hl, $55d1
	jp Jump_002_562e


	db $f6, $fe, $18, $00, $f8, $0a, $18, $20, $fc, $00, $18, $00, $fe, $08, $18, $20
	db $00, $fa, $18, $00, $00, $0e, $18, $20, $02, $fc, $18, $00, $02, $0c, $18, $20

Jump_02_5611::
	call Call_02_56C5
	ld hl, $5601
	jr jr_002_5627

Jump_02_5619::
	call Call_02_56C5
	ld a, [$c1a7]
	cp $02
	jp z, Jump_002_566c

	ld hl, $55f1

jr_002_5627:
	ldh a, [$ffd7]
	and $08
	ld e, a
	ld d, $00

Jump_002_562e:
	add hl, de
	push hl
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	push hl
	pop de
	pop hl
	call Call_02_5649
	call Call_02_5649
	ld a, $02
	call Call_02_56EA
	ret


Call_02_5649::
	ldh a, [$ffd8]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ldh a, [$ffd9]
	add [hl]
	ld [de], a
	inc hl
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ret


	db $00, $00, $7a, $00, $00, $08, $7a, $20, $00, $00, $78, $00, $00, $08, $78, $20

Jump_002_566c:
	ldh a, [$ffd7]
	and $08
	ld d, $00
	ld e, a
	ld hl, $565c
	jp Jump_002_562e


	db $00, $00, $32, $00, $00, $08, $32, $20, $00, $00, $32, $00, $00, $08, $32, $20
	db $00, $00, $30, $00, $00, $08, $30, $20, $00, $00, $30, $00, $00, $08, $30, $20

Jump_02_5699::
	call Call_02_56C5
	ldh a, [$ffd7]
	cp $04
	jr nz, jr_002_56b0

	ld hl, $c510
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_002_56b0

	call Call_02_5C92
	jr jr_002_56b7

jr_002_56b0:
	cp $04
	jr nz, jr_002_56b7

	call Call_02_5D00

jr_002_56b7:
	ldh a, [$ffd7]
	rla
	and $18
	ld d, $00
	ld e, a
	ld hl, $5679
	jp Jump_002_562e


Call_02_56C5::
	ld hl, $c540
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	cp $88
	jr nc, Call_02_56DB

	ld hl, $c530
	add hl, bc
	ld a, [hl]
	ldh [$ffd9], a
	cp $a8
	jr c, jr_002_56e1

Call_02_56DB::
	ld hl, $c510
	add hl, bc
	xor a
	ld [hl], a

jr_002_56e1:
	ret


	db $00, $08, $10, $18, $20, $28, $30, $38

Call_02_56EA::
	sla a
	sla a
	ld e, a
	ld a, [$c3c0]
	add e
	cp $60
	jr c, jr_002_56f9

	sub $60

jr_002_56f9:
	ld [$c3c0], a
	ld a, [$c3c1]
	add e
	ld [$c3c1], a
	cp $60
	jr c, jr_002_571a

	ldh a, [$ffe7]
	ld hl, $c123
	add [hl]
	and $07
	ld e, a
	ld d, $00
	ld hl, $56e2
	add hl, de
	ld a, [hl]
	ld [$c3c0], a

jr_002_571a:
	ret


Call_02_571B::
	ldh a, [$ff99]

Call_02_571D::
	ldh [$ffd8], a
	ldh a, [$ff98]
	ldh [$ffd7], a
	ld a, $0e
	ldh [$fff2], a
	ld a, $01
	call Call_0953
	ret


	db $fe, $fd, $fb, $f7

	ld hl, $c19f
	ld a, [$c124]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_002_575d

	ld a, [$dba5]
	and a
	jr z, jr_002_575d

	call Call_02_5B15
	ld a, [$c188]
	and a
	jr z, jr_002_575e

	cp $02
	ld a, $01
	ldh [$ffa1], a
	jr z, jr_002_575a

	call Call_02_5871
	jr jr_002_575d

jr_002_575a:
	call Call_02_59E1

jr_002_575d:
	ret


jr_002_575e:
	ld a, [$c18c]
	and a
	jr z, jr_002_5793

	ld e, $03
	ld a, [$c18a]
	ld c, a

jr_002_576a:
	inc e
	ld a, e
	cp $08
	jr z, jr_002_578e

	srl c
	jr nc, jr_002_576a

	ld d, $00
	ld hl, $5729
	add hl, de
	ld a, [$c18a]
	and [hl]
	ld [$c18a], a
	ld a, e
	ld [$c189], a
	xor a
	ld [$dbac], a
	inc a
	ld [$c188], a
	ret


jr_002_578e:
	xor a
	ld [$c18c], a
	ret


jr_002_5793:
	ld a, [$c18d]
	and a
	jr nz, jr_002_579a

	ret


jr_002_579a:
	ld e, $03
	ld a, [$c18b]
	ld c, a

jr_002_57a0:
	inc e
	ld a, e
	cp $08
	jr z, jr_002_57c5

	srl c
	jr nc, jr_002_57a0

	ld d, $00
	ld hl, $5729
	add hl, de
	ld a, [$c18b]
	and [hl]
	ld [$c18b], a
	ld a, e
	ld [$c189], a
	ld a, $02
	ld [$c188], a
	xor a
	ld [$dbac], a
	ret


jr_002_57c5:
	xor a
	ld [$c18d], a
	ret


	db $50, $51, $13, $12, $11, $10, $42, $43, $45, $13, $55, $11, $12, $46, $10, $56
	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $02, $03, $13, $12, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12, $11, $10, $13, $12, $12, $13, $10, $11
	db $12, $13, $10, $11, $11, $10, $13, $12, $08, $08, $00, $00, $08, $08, $00, $00
	db $08, $08, $08, $00, $00, $08, $08, $00, $00, $08, $00, $00, $08, $08, $00, $00
	db $08, $08, $00, $08, $08, $10, $10, $08, $08, $10, $10, $08, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $01, $10, $10, $01, $01, $10, $10, $43, $8c, $09, $0b
	db $43, $8c, $09, $0b, $44, $08, $0a, $0c, $44, $08, $0a, $0c, $04, $08, $02, $01
	db $04, $08, $02, $01, $04, $f8, $08, $ff, $01, $f8, $08, $ff, $01, $f8, $08, $04
	db $01, $02, $08, $04, $01, $02, $08

Call_02_5871::
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [$ffe3], a
	ldh [$ffe5], a
	ld a, [$c189]
	ld c, a
	and a
	jr z, jr_002_588b

	xor a

jr_002_5883:
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, jr_002_5883

jr_002_588b:
	ld hl, $5812
	ld a, [$c189]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld hl, $c1d0
	add hl, bc
	add [hl]
	ldh [$ffce], a

Jump_002_589d:
	ld hl, $5824
	ldh a, [$ffe3]
	ld c, a
	add hl, bc
	ld a, [$c189]
	ld c, a
	add hl, bc
	ld a, [hl]
	ld hl, $c1e0
	add hl, bc
	add [hl]
	ldh [$ffcd], a
	push de
	call Call_2839
	pop de
	ldh a, [$ffe3]
	and a
	jr z, jr_002_58bd

	inc de
	inc de

jr_002_58bd:
	ld a, [$d600]
	ld c, a
	ld b, $00
	add $05
	ld [$d600], a
	ld hl, $d601
	add hl, bc
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $01
	ld [hli], a
	push hl
	ld hl, $57ca
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld hl, $57cb
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ldh a, [$ffe3]
	and a
	jr nz, jr_002_58f1

	ld a, $09
	ldh [$ffe3], a
	jp Jump_002_589d


jr_002_58f1:
	xor a
	inc hl
	ld [hl], a
	ld a, [$dbac]
	add $01
	ld [$dbac], a
	ld a, [$dbac]
	cp $08
	jr nc, jr_002_5904

	ret


jr_002_5904:
	ldh a, [$ffe5]
	and a
	jr nz, jr_002_5919

	xor a
	ldh [$ffe3], a
	ld a, e
	add $24
	ld e, a
	ld d, $00
	ldh [$ffe5], a
	dec de
	dec de
	jp Jump_002_589d


jr_002_5919:
	xor a
	ld [$c188], a
	ld [$c1a8], a
	xor a
	ldh [$ffe5], a
	ld a, [$c189]
	ld c, a
	ld b, $00
	ld hl, $c1f0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld a, c
	and $07
	ld c, a

jr_002_5934:
	ld hl, $5836
	add hl, bc
	ld a, [hl]
	ld hl, $ffd7
	add [hl]
	ld e, a
	ld d, $00
	ld hl, $5846
	add hl, bc
	ld a, [hl]
	ld hl, $d711
	add hl, de
	ld [hl], a
	ldh a, [$ffe5]
	and a
	jr nz, jr_002_5957

	ld a, c
	add $08
	ldh [$ffe5], a
	ld c, a
	jr jr_002_5934

jr_002_5957:
	call Call_02_5987
	push hl
	pop bc
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5856
	add hl, de
	ld a, [bc]
	or [hl]
	ld [bc], a
	ldh [$fff8], a
	ld hl, $585f
	add hl, de
	ld a, [$dbae]
	add [hl]
	ld e, a
	call Call_2B25
	push hl
	pop bc
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5868
	add hl, de
	ld a, [bc]
	or [hl]
	ld [bc], a
	ret


Call_02_5987::
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	and a
	jr z, jr_002_599f

	ldh a, [$fff7]
	cp $1a
	jr nc, jr_002_599f

	cp $06
	jr c, jr_002_599f

	inc d

jr_002_599f:
	add hl, de
	ret


	db $58, $59, $13, $12, $11, $10, $4a, $4b, $4d, $13, $5d, $11, $12, $4e, $10, $5e
	db $40, $41, $58, $59, $4a, $4b, $52, $53, $44, $4d, $54, $5d, $4e, $47, $5e, $57
	db $08, $08, $00, $00, $08, $08, $00, $00, $00, $00, $08, $08, $08, $08, $10, $10
	db $00, $00, $00, $00, $01, $01, $10, $10, $35, $37, $39, $3b, $36, $38, $3a, $3c

Call_02_59E1::
	ld e, $00
	ld d, e
	ld c, e
	ld b, e
	xor a
	ldh [$ffe3], a
	ldh [$ffe4], a
	ldh [$ffe5], a
	ld a, [$c189]
	sub $04
	jr z, jr_002_59fe

	ld c, a
	xor a

jr_002_59f6:
	add $04
	ld e, a
	ld d, $00
	dec c
	jr nz, jr_002_59f6

jr_002_59fe:
	ld hl, $59bd
	ld a, [$c189]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld hl, $c1d0
	add hl, bc
	add [hl]
	ldh [$ffce], a

Jump_002_5a10:
	ld hl, $59c5
	ldh a, [$ffe3]
	ld c, a
	add hl, bc
	ld a, [$c189]
	ld c, a
	add hl, bc
	ld a, [hl]
	ld hl, $c1e0
	add hl, bc
	add [hl]
	ldh [$ffcd], a
	ld a, [$dbb2]
	sub $10
	ld hl, $ffcd
	sub [hl]
	add $10
	cp $20
	jr nc, jr_002_5a4c

	ld a, [$dbb1]
	sub $08
	ld hl, $ffce
	sub [hl]
	add $10
	cp $20
	jr nc, jr_002_5a4c

	ldh a, [$ff98]
	ld [$dbb1], a
	ldh a, [$ff99]
	ld [$dbb2], a

jr_002_5a4c:
	push de
	call Call_2839
	pop de
	ldh a, [$ffe3]
	and a
	jr z, jr_002_5a58

	inc de
	inc de

jr_002_5a58:
	ld a, [$d600]
	ld c, a
	ld b, $00
	add $05
	ld [$d600], a
	ld hl, $d601
	add hl, bc
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $01
	ld [hli], a
	push hl
	ld hl, $59a1
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld hl, $59a2
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ldh a, [$ffe3]
	and a
	jr nz, jr_002_5a8c

	ld a, $04
	ldh [$ffe3], a
	jp Jump_002_5a10


jr_002_5a8c:
	xor a
	inc hl
	ld [hl], a
	ld a, [$dbac]
	add $01
	ld [$dbac], a
	ld a, [$dbac]
	cp $08
	jr nc, jr_002_5a9f

	ret


jr_002_5a9f:
	ldh a, [$ffe5]
	and a
	jr nz, jr_002_5ab4

	xor a
	ldh [$ffe3], a
	ld a, e
	add $10
	ld e, a
	ld d, $00
	ldh [$ffe5], a
	dec de
	dec de
	jp Jump_002_5a10


jr_002_5ab4:
	xor a
	ld [$c188], a
	ld [$c1a8], a
	xor a
	ldh [$ffe5], a
	ld a, [$c189]
	sub $04
	ld c, a
	ld b, $00
	ld hl, $c1f4
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a

jr_002_5acd:
	ld hl, $59d1
	add hl, bc
	ld a, [hl]
	ld hl, $ffd7
	add [hl]
	ld e, a
	ld d, $00
	ld hl, $59d9
	add hl, bc
	ld a, [hl]
	ld hl, $d711
	add hl, de
	ld [hl], a
	ldh a, [$ffe5]
	and a
	jr nz, jr_002_5af0

	ld a, c
	add $04
	ldh [$ffe5], a
	ld c, a
	jr jr_002_5acd

jr_002_5af0:
	ld hl, $d800
	ld a, [$dba5]
	and a
	jr z, jr_002_5afc

	ld hl, $d900

jr_002_5afc:
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	add hl, de
	push hl
	ld a, [$c189]
	ld e, a
	ld d, $00
	ld hl, $5856
	add hl, de
	ld a, [hl]
	cpl
	pop hl
	and [hl]
	ld [hl], a
	ldh [$fff8], a
	ret


Call_02_5B15::
	ld a, [$c18e]
	and a
	jp z, Jump_002_5bc8

	call Call_02_5D3F
	ld a, [$c18e]
	and $e0
	srl a
	srl a
	srl a
	srl a
	srl a
	rst $00

JumpTable_02_5B2F::
	dw Jump_02_5D63
	dw Jump_02_5BED
	dw Jump_02_5B3F
	dw Jump_02_5C69
	dw Jump_02_5BC9
	dw Jump_02_5BAF
	dw Jump_02_5BDF
	dw Jump_02_5B88

Jump_02_5B3F::
	call Call_02_5B75
	ld c, $0f
	ld b, $00

jr_002_5b46:
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_002_5b6e

	ld hl, $c280
	add hl, bc
	ld a, [hl]
	cp $05
	jr c, jr_002_5b6e

	ld [hl], $01
	ld hl, $c480
	add hl, bc
	ld [hl], $1f
	ld hl, $c340
	add hl, bc
	ld a, [hl]
	and $f0
	or $02
	ld [hl], a
	ld a, $13
	ldh [$fff4], a

jr_002_5b6e:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_002_5b46

	ret


Call_02_5B75::
	ldh a, [$fff8]
	and $10
	jr nz, jr_002_5b86

	ld a, [$c18f]
	and a
	jr z, jr_002_5b86

	xor a
	ld [$c18e], a
	ret


jr_002_5b86:
	pop af
	ret


Jump_02_5B88::
	call Call_02_5B75
	ld a, $2f
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $88
	ld hl, $c210
	add hl, de
	ld [hl], $30
	ld hl, $c450
	add hl, de
	ld [hl], $80
	ld a, $88
	ldh [$ffd7], a
	ld a, $30
	ldh [$ffd8], a
	ld a, $02
	jp Jump_002_5bbc


Jump_02_5BAF::
	call Call_02_5B75
	ld a, $88
	ldh [$ffd7], a
	ld a, $20
	ldh [$ffd8], a
	ld a, $04

Jump_002_5bbc:
	call Call_0953
	call Call_02_5987
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [$fff8], a

Jump_002_5bc8:
	ret


Jump_02_5BC9::
	call Call_02_5B75
	ldh a, [$fff6]
	cp $69
	jr nz, jr_002_5bdb

	call Call_02_5987
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [$fff8], a

jr_002_5bdb:
	call Call_02_5260
	ret


Jump_02_5BDF::
	ldh a, [$fff7]
	ld e, a
	ld d, $00
	ld hl, $db65
	add hl, de
	ld a, [hl]
	and $01
	jr nz, jr_002_5c3c

Jump_02_5BED::
	ld a, [$c190]
	and a
	jr nz, jr_002_5bf6

	call Call_02_5C3D

jr_002_5bf6:
	ld a, [$c18f]
	and a
	jr z, jr_002_5c3c

	ld a, [$c18e]
	cp $c1
	jr nz, jr_002_5c2a

	ldh a, [$fff7]
	ld e, a
	ld d, $00
	ld hl, $db65
	add hl, de
	ld a, [hl]
	or $01
	ld [hl], a
	ld d, $00
	ldh a, [$fff6]
	ld e, a
	ld hl, $d900
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_002_5c23

	cp $06
	jr c, jr_002_5c23

	inc d

jr_002_5c23:
	add hl, de
	set 5, [hl]
	ld a, $1b
	ldh [$fff2], a

jr_002_5c2a:
	ld a, [$c190]
	and a
	jr z, jr_002_5c3c

	xor a
	ld [$c18e], a
	ld a, $01
	ld [$c18c], a
	call Call_02_525B

jr_002_5c3c:
	ret


Call_02_5C3D::
	ldh a, [$ff98]
	sub $11
	cp $7e
	jr nc, jr_002_5c64

	ldh a, [$ff99]
	sub $16
	cp $5e
	jr nc, jr_002_5c64

	ld a, [$c18f]
	and a
	jr nz, jr_002_5c64

	ld a, $01
	ld [$c18d], a
	ld [$c190], a
	ld a, $04
	ld [$c111], a
	ld a, $10
	ldh [$fff4], a

jr_002_5c64:
	ret


	db $60, $70, $61, $71

Jump_02_5C69::
	call Call_02_5B75
	ld a, $88
	ldh [$ffd7], a
	ldh a, [$ff99]
	sub $30
	add $08
	cp $10
	jr nc, jr_002_5c88

	ldh a, [$ff98]
	sub $88
	add $10
	cp $20
	jr nc, jr_002_5c88

	ld a, $40
	jr jr_002_5c8a

jr_002_5c88:
	ld a, $30

jr_002_5c8a:
	ldh [$ffd8], a
	ld a, $03
	call Call_0953
	ret


Call_02_5C92::
	ldh a, [$ff99]
	sub $30
	add $08
	cp $10
	jr nc, jr_002_5caa

	ldh a, [$ff98]
	sub $88
	add $10
	cp $20
	jr nc, jr_002_5caa

	ld a, $30
	jr jr_002_5cac

jr_002_5caa:
	ld a, $20

jr_002_5cac:
	ldh [$ffcd], a
	ld a, $80
	ldh [$ffce], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffcd]
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ld a, $a0
	ld [hl], a
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0a
	ld [$d600], a
	ld de, $5c65

jr_002_5cdb:
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $81
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
	inc a
	ld [hli], a
	ld a, $81
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hli], a
	xor a
	ld [hl], a
	ret


	db $6a, $7a, $6b, $7b

Call_02_5D00::
	ld a, $01
	ldh [$ffac], a
	ld a, $10
	ldh [$ffcd], a
	add $10
	ldh [$ffae], a
	ld a, $80
	ldh [$ffce], a
	add $08
	ldh [$ffad], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffcd]
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, $d711
	add hl, de
	ld a, $be
	ld [hl], a
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0a
	ld [$d600], a
	ld de, $5cfc
	jr jr_002_5cdb

Call_02_5D3F::
	and $1f
	ldh [$ffd7], a
	dec a
	rst $00

JumpTable_02_5D45::
	dw Jump_02_5D9C
	dw Jump_02_5D63
	dw Jump_02_5D81
	dw Jump_02_5D63
	dw Jump_02_5D78
	dw Jump_02_5D89
	dw Jump_02_5D63
	dw Jump_02_5D9C
	dw Jump_02_5D63
	dw Jump_02_5D64
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63
	dw Jump_02_5D63

Jump_02_5D63::
	ret


Jump_02_5D64::
	ldh a, [$fff7]
	cp $06
	jr nz, jr_002_5d6f

	ld a, [$dae8]
	jr jr_002_5d72

jr_002_5d6f:
	ld a, [$d9ff]

jr_002_5d72:
	and $20
	jp nz, Call_08EC

	ret


Jump_02_5D78::
	ld a, [$c1a2]
	cp $02
	jp z, Call_08EC

	ret


Jump_02_5D81::
	ld a, [$c1cb]
	and a
	jp nz, Call_08EC

	ret


Jump_02_5D89::
	ld c, $00
	ld hl, $dbb6

jr_002_5d8e:
	ld a, [hli]
	cp c
	jr nz, jr_002_5d9b

	inc c
	ld a, c
	cp $03
	jr nz, jr_002_5d8e

	call Call_08EC

jr_002_5d9b:
	ret


Jump_02_5D9C::
	ld c, $0f
	ld b, $00

jr_002_5da0:
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_002_5db1

	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $02
	jr z, jr_002_5dcc

jr_002_5db1:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_002_5da0

	ldh a, [$ffd7]
	cp $08
	jr nz, jr_002_5dc9

	ld a, [$d460]
	and a
	jr z, jr_002_5dcc

	ld a, [$c113]
	and a
	jr nz, jr_002_5dcc

jr_002_5dc9:
	jp Call_08EC


jr_002_5dcc:
	ret


Call_02_5DCD::
	ld a, [de]
	cp [hl]
	jr c, jr_002_5dd3

	ld a, [hl]
	ld [de], a

jr_002_5dd3:
	inc hl
	ret


	ld hl, $db76
	ld de, $db4c
	call Call_02_5DCD
	ld de, $db4d
	call Call_02_5DCD
	ld de, $db45
	call Call_02_5DCD
	ld a, [$c11c]
	cp $02
	ret nc

	ld a, [$c19f]
	and a
	jp nz, Jump_002_5edc

	ld a, [$c124]
	and a
	jp nz, Jump_002_5ef1

	ld a, [$c14f]
	and a
	jp nz, Jump_002_5e83

	ldh a, [$ffcb]
	and $40
	jp nz, Jump_002_5ec8

	ldh a, [$ffcc]
	and $80
	jp z, Jump_002_5ec8

	ld a, [$db9a]
	cp $00
	jr z, jr_002_5e2e

	ld a, [$c167]
	and a
	jp nz, Jump_002_5ec8

	ldh a, [$ffa1]
	cp $02
	jp z, Jump_002_5ec8

	ldh a, [$ff9d]
	inc a
	jp z, Jump_002_5ec8

jr_002_5e2e:
	ld a, [$c1b5]
	ld hl, $c1b8
	or [hl]
	ld hl, $c1b9
	or [hl]
	jp nz, Jump_002_5ec8

Jump_002_5e3c:
	ld a, $01
	ld [$c14f], a
	ld [$c151], a
	ld a, $12
	ldh [$fff2], a
	ld a, [$c150]
	cpl
	inc a
	ld [$c150], a
	and $80
	jr z, jr_002_5e79

	ld a, $11
	ldh [$fff2], a
	xor a
	ld [$c151], a
	ld a, $0b
	ld [$c154], a
	ld a, [$dba5]
	and a
	ld a, $07
	jr z, jr_002_5e76

	ldh a, [$fff7]
	cp $08
	ld a, $07
	jr nc, jr_002_5e76

	call Call_02_6A9B
	ld a, $02

jr_002_5e76:
	ldh [$ff90], a
	ret


jr_002_5e79:
	ld a, $07
	ldh [$ffa9], a
	ld a, $70
	ldh [$ffaa], a
	pop af
	ret


Jump_002_5e83:
	ld a, [$c151]
	and a
	jr nz, jr_002_5ea4

	ld a, [$d601]
	and a
	jr nz, jr_002_5e96

	call Call_02_631F
	ld hl, $c151
	inc [hl]

jr_002_5e96:
	pop af

Call_02_5E97::
	call Call_02_781B
	call Call_149E
	call Call_1CCC
	call Call_0B2B
	ret


jr_002_5ea4:
	call Call_02_5EF2
	ld a, [$c150]
	ld hl, $db9a
	add [hl]
	ld [hl], a
	cp $80
	jr z, jr_002_5ebf

	cp $00
	jr nz, jr_002_5ec5

	ld a, $03
	ldh [$ffa9], a
	ld a, $30
	ldh [$ffaa], a

jr_002_5ebf:
	xor a
	ld [$c14f], a
	jr jr_002_5ec8

jr_002_5ec5:
	call Call_02_5E97

Jump_002_5ec8:
jr_002_5ec8:
	ld a, [$db9a]
	cp $80
	jr z, jr_002_5edc

	ld a, [$c14f]
	and a
	jr nz, jr_002_5edb

	call Call_02_645E
	call Call_02_63F0

jr_002_5edb:
	pop af

Jump_002_5edc:
jr_002_5edc:
	ld a, [$c19f]
	and $7f
	jr z, jr_002_5eeb

	cp $0c
	jr z, jr_002_5eeb

	cp $0d
	jr nz, jr_002_5ef1

jr_002_5eeb:
	call Call_02_5F09
	call Call_02_601A

Jump_002_5ef1:
jr_002_5ef1:
	ret


Call_02_5EF2::
	ld a, [$c154]
	cp $01
	jr z, jr_002_5f08

	ld c, a
	ld b, $00
	dec a
	ld e, a
	call Call_02_61ED
	ld a, [$c154]
	dec a
	ld [$c154], a

jr_002_5f08:
	ret


Call_02_5F09::
	ld hl, $d600
	ldh a, [$ffe7]
	and $01
	or [hl]
	ret nz

	ld hl, $c3ce
	ld a, [hl]
	and a
	jr z, jr_002_5f1b

	dec [hl]
	ret


jr_002_5f1b:
	ld hl, $db8f
	ld a, [$db90]
	or [hl]
	jr z, jr_002_5f74

	ld a, $05
	ldh [$fff3], a
	ld a, [$db90]
	ld e, a
	ld a, [$db8f]
	sla e
	rla
	sla e
	rla
	sla e
	rla
	inc a
	cp $0a
	jr c, jr_002_5f3f

	ld a, $09

jr_002_5f3f:
	ld e, a
	ld a, [$db90]
	sub e
	ld [$db90], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	ld a, [$db5e]
	add e
	daa
	ld [$db5e], a
	ld a, [$db5d]
	adc $00
	daa
	ld [$db5d], a
	cp $10
	jr c, jr_002_5f71

	ld a, $09
	ld [$db5d], a
	ld a, $99
	ld [$db5e], a
	xor a
	ld [$db8f], a
	ld [$db90], a

jr_002_5f71:
	call Call_02_5FD1

jr_002_5f74:
	ld hl, $db91
	ld a, [$db92]
	or [hl]
	jr z, jr_002_5fd0

	ld a, $05
	ldh [$fff3], a
	ld a, [$db92]
	ld e, a
	ld a, [$db91]
	sla e
	rla
	sla e
	rla
	sla e
	rla
	inc a
	cp $0a
	jr c, jr_002_5f98

	ld a, $09

jr_002_5f98:
	ld e, a
	ld a, [$db92]
	sub e
	ld [$db92], a
	ld a, [hl]
	sbc $00
	ld [hl], a
	ld a, [$db5e]
	ld hl, $db5d
	or [hl]
	jr z, jr_002_5fd0

	ld a, [$db5e]
	sub e
	daa
	ld [$db5e], a
	ld a, [$db5d]
	sbc $00
	daa
	ld [$db5d], a
	jr nc, jr_002_5fcd

	xor a
	ld [$db5d], a
	ld [$db5e], a
	ld [$db91], a
	ld [$db92], a

jr_002_5fcd:
	call Call_02_5FD1

jr_002_5fd0:
	ret


Call_02_5FD1::
	ld a, [$d600]
	ld e, a
	ld d, $00
	add $06
	ld [$d600], a
	ld hl, $d601
	add hl, de
	ld a, $9c
	ld [hli], a
	ld a, $2a
	ld [hli], a
	ld a, $02
	ld [hli], a
	push hl
	ld a, [$db5d]
	and $0f
	ld e, a
	add $b0
	pop hl
	ld [hli], a
	push hl
	ld a, [$db5e]
	swap a
	and $0f
	add $b0
	pop hl
	ld [hli], a
	push hl
	ld a, [$db5e]
	and $0f
	add $b0
	pop hl
	ld [hli], a
	ld a, $00
	ld [hli], a
	ret


	db $05, $05, $05, $09, $09, $09, $11, $11, $11, $19, $19, $19

Call_02_601A::
	xor a
	ld [$c163], a
	ld a, [$db5b]
	ld e, a
	ld d, $00
	ld hl, $600b
	add hl, de
	ld a, [$db5a]
	cp [hl]
	jr nc, jr_002_6045

	ld a, $01
	ld [$c163], a
	ld a, [$c110]
	dec a
	cp $ff
	jr nz, jr_002_6042

	ld a, $30
	ld hl, $fff3
	ld [hl], $04

jr_002_6042:
	ld [$c110], a

jr_002_6045:
	ldh a, [$ffe7]
	and $01
	jr z, jr_002_60a5

	ld a, [$d600]
	and a
	jr nz, jr_002_60a5

	ld a, [$db93]
	and a
	jr z, jr_002_6088

	dec a
	ld [$db93], a
	ld a, [$db5b]
	cp $0f
	jr c, jr_002_6064

	ld a, $0e

jr_002_6064:
	sla a
	sla a
	sla a
	ld e, a
	ld a, [$db5a]
	cp e
	jr nz, jr_002_6077

	xor a
	ld [$db93], a
	jr jr_002_6088

jr_002_6077:
	inc a
	ld [$db5a], a
	and $07
	cp $06
	jr nz, jr_002_6085

	ld a, $06
	ldh [$fff3], a

jr_002_6085:
	jp Call_02_6117


jr_002_6088:
	ld a, [$db94]
	and a
	jr z, jr_002_60a5

	dec a
	ld [$db94], a
	ld a, [$db5a]
	and a
	jr z, jr_002_609c

	dec a
	ld [$db5a], a

jr_002_609c:
	call Call_02_6117
	ld a, [$db5a]
	and a
	jr z, jr_002_60a6

jr_002_60a5:
	ret


jr_002_60a6:
	ld a, [$db0d]
	and a
	jr z, jr_002_6101

	dec a
	ld [$db0d], a
	ld a, $08
	ld [$db5a], a
	ld a, [$db93]
	add $80
	ld [$db93], a
	ld a, $a0
	ld [$dbc7], a
	ld a, [$d600]
	ld e, a
	ld d, $00
	add $04
	ld [$d600], a
	ld hl, $d601
	add hl, de
	ld a, $9c
	ld [hli], a
	ld a, $93
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, [$db0d]
	add $b0
	cp $b0
	jr z, jr_002_60e7

	ld [hli], a
	xor a
	ld [hl], a
	ret


jr_002_60e7:
	ld a, $7f
	ld [hli], a
	ld a, $9c
	ld [hli], a
	ld a, $72
	ld [hli], a
	ld a, $c1
	ld [hli], a
	ld a, $7f
	ld [hli], a
	xor a
	ld [hl], a
	ld a, [$d600]
	add $04
	ld [$d600], a
	ret


jr_002_6101:
	ret


	db $9c, $0d, $06, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $9c, $2d, $06, $7f, $7f, $7f
	db $7f, $7f, $7f, $7f, $00

Call_02_6117::
	ld a, [$d600]
	ld e, a
	ld d, $00
	add $14
	ld [$d600], a
	ld hl, $d601
	add hl, de
	push de
	ld bc, $6102
	ld e, $15

jr_002_612c:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_002_612c

	nop
	nop
	nop
	nop
	pop de
	ld hl, $d604
	add hl, de
	ld c, $00
	ld a, [$db5a]
	and a
	jr z, jr_002_6165

	ldh [$ffd7], a

jr_002_6145:
	ldh a, [$ffd7]
	sub $08
	ldh [$ffd7], a
	jr c, jr_002_615c

	ld a, $a9
	ld [hli], a
	inc c
	ld a, c
	cp $07
	jr nz, jr_002_615a

	ld a, l
	add $03
	ld l, a

jr_002_615a:
	jr jr_002_6145

jr_002_615c:
	add $08
	jr z, jr_002_6165

	ld a, $ce
	ld [hli], a
	jr jr_002_616e

jr_002_6165:
	ld a, [$db5b]
	cp c
	jr z, jr_002_617a

	ld a, $cd
	ld [hli], a

jr_002_616e:
	inc c
	ld a, c
	cp $07
	jr nz, jr_002_6178

	ld a, l
	add $03
	ld l, a

jr_002_6178:
	jr jr_002_6165

jr_002_617a:
	ret


	db $7f, $7f, $7f, $7f, $7f, $7f, $84, $7f, $7f, $85, $ba, $7f, $80, $7f, $7f, $81
	db $7f, $7f, $82, $7f, $7f, $83, $ba, $7f, $86, $7f, $7f, $87, $ba, $7f, $88, $7f
	db $7f, $89, $7f, $7f, $8a, $7f, $7f, $8b, $7f, $7f, $8c, $7f, $7f, $8d, $7f, $7f
	db $98, $7f, $7f, $99, $7f, $7f, $90, $7f, $7f, $91, $7f, $7f, $92, $7f, $7f, $93
	db $7f, $7f, $96, $7f, $7f, $97, $7f, $7f, $8e, $7f, $7f, $8f, $7f, $7f, $a4, $7f
	db $7f, $a5, $7f, $7f, $9c, $01, $9c, $06, $9c, $61, $9c, $65, $9c, $c1, $9c, $c5
	db $9d, $21, $9d, $25, $9d, $81, $9d, $85, $9d, $e1, $9d, $e5

Call_02_61E7::
	ld c, $01
	ld b, $00
	ld e, $ff

Call_02_61ED::
	ld a, [$0004]
	and a
	ret nz

	push de
	push bc
	ld hl, $db00
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	sla a
	ld e, a
	sla a
	add e
	ldh [$ffd7], a
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0c
	ld [$d600], a
	push hl
	sla c
	ld hl, $61cf
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, $02
	ld [hli], a
	ldh a, [$ffd7]
	ld c, a
	push hl
	ld hl, $617b
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	pop bc
	push bc
	push hl
	sla c
	ld hl, $61cf
	add hl, bc
	push hl
	pop de
	pop hl
	inc de
	inc hl
	ld a, [de]
	add $20
	ld [hl], a
	dec de
	dec hl
	ld a, [de]
	inc de
	inc de
	adc $00
	ld [hli], a
	inc hl
	ld a, $02
	ld [hli], a
	ldh a, [$ffd7]
	ld c, a
	push hl
	ld hl, $617e
	add hl, bc
	push hl
	pop de
	pop hl
	ld a, [de]
	inc de
	ld [hli], a
	call Call_02_6273
	xor a
	ld [hl], a
	pop bc
	pop de
	dec c
	ld a, c
	cp e
	jp nz, Call_02_61ED

	ret


Call_02_6273::
	ldh a, [$ffd8]
	cp $09
	jr z, jr_002_62b5

	cp $0c
	jr z, jr_002_62aa

	dec a
	jr z, jr_002_629d

	dec a
	jr z, jr_002_62cf

	dec a
	jr z, jr_002_6293

	dec a
	jr z, jr_002_6298

	dec a
	jr z, jr_002_62ca

Jump_002_628c:
jr_002_628c:
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ret


jr_002_6293:
	ld a, [$db43]
	jr jr_002_62a0

jr_002_6298:
	ld a, [$db44]
	jr jr_002_62a0

jr_002_629d:
	ld a, [$db4e]

jr_002_62a0:
	add $b0
	ld c, a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, c
	inc de
	ld [hli], a
	ret


jr_002_62aa:
	ld a, [$db4b]
	and a
	jr nz, jr_002_628c

	ld a, [$db4c]
	jr Call_02_62D2

jr_002_62b5:
	ld a, [$db49]
	and a
	jp z, Jump_002_628c

	ld a, [$db4a]
	inc a
	swap a
	call Call_02_62D2
	dec hl
	ld [hl], $7f
	inc hl
	ret


jr_002_62ca:
	ld a, [$db45]
	jr Call_02_62D2

jr_002_62cf:
	ld a, [$db4d]

Call_02_62D2::
	push af
	and $0f
	add $b0
	ld c, a
	pop af
	swap a
	and $0f
	add $b0
	ld [hli], a
	ld a, c
	ld [hli], a
	ret


	db $9c, $6a, $83, $94, $95, $c0, $c1, $9c, $6c, $83, $a0, $a1, $c2, $c3, $9c, $6e
	db $83, $9a, $9b, $c4, $c5, $9c, $6f, $81, $9c, $9d, $9c, $b0, $81, $c6, $c7, $9c
	db $71, $81, $9e, $9f, $9c, $b2, $81, $ca, $cb, $9c, $92, $01, $7f, $7f, $9c, $d3
	db $00, $7f, $00, $03, $0a, $11, $22, $05, $0c, $13, $1d, $27

Call_02_631F::
	ld hl, $d601
	ld bc, $62e3
	ld e, $33

jr_002_6327:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_002_6327

	ld de, $db0c
	ld bc, $0000

jr_002_6333:
	ld a, c
	cp $02
	jr nz, jr_002_633f

	ld a, [$db7f]
	and a
	ld a, c
	jr nz, jr_002_635f

jr_002_633f:
	cp $04
	jr nz, jr_002_6357

	ld a, [$dba5]
	and a
	jr z, jr_002_6354

	ldh a, [$fff7]
	cp $0a
	jr nc, jr_002_6354

	ld de, $dbcc
	jr jr_002_6357

jr_002_6354:
	ld de, $db11

jr_002_6357:
	ld a, [de]
	cp $ff
	jr z, jr_002_635f

	and a
	jr nz, jr_002_637e

jr_002_635f:
	push de
	ld hl, $6316
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, $d601
	add hl, de
	ld a, $7f
	ld [hli], a
	ld [hli], a
	ld a, c
	cp $02
	jr nz, jr_002_637d

	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, $7f
	ld [hli], a
	ld [hl], a

jr_002_637d:
	pop de

jr_002_637e:
	inc de
	inc c
	ld a, c
	cp $09
	jr nz, jr_002_6333

	ld hl, $d601
	ld de, $002c
	add hl, de
	ld a, [$db0f]
	and a
	jr z, jr_002_63a0

	ld e, a
	swap a
	and $0f
	add $b0
	ld [hli], a
	ld a, e
	and $0f
	add $b0
	ld [hli], a

jr_002_63a0:
	ld hl, $d601
	ld de, $0031
	add hl, de
	ld a, [$dba5]
	and a
	jr z, jr_002_63bb

	ldh a, [$fff7]
	cp $0a
	jr nc, jr_002_63bb

	ld a, [$dbd0]
	and a
	jr z, jr_002_63c8

	jr jr_002_63c5

jr_002_63bb:
	ld a, [$db15]
	and a
	jr z, jr_002_63c8

	cp $06
	jr nc, jr_002_63c8

jr_002_63c5:
	add $b0
	ld [hl], a

jr_002_63c8:
	ld a, $32
	ld [$d600], a
	ret


	db $0f, $37, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f, $0f, $2f, $0e, $0e, $26, $26
	db $3e, $3e, $56, $56, $6e, $6e, $86, $86

Call_02_63E6::
	ld a, [$db97]
	cp $e4
	ret c

	ld d, $02
	jr jr_002_63f2

Call_02_63F0::
	ld d, $0c

jr_002_63f2:
	ld hl, $db00
	ld e, $00

jr_002_63f7:
	ld a, [hli]
	cp $01
	jr z, jr_002_6402

	inc e
	ld a, e
	cp d
	jr nz, jr_002_63f7

	ret


jr_002_6402:
	ld d, $00
	ld hl, $63ce
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $63da
	add hl, de
	ld a, [hl]
	ldh [$ffd8], a
	ld a, [$d47c]
	dec a
	jr nz, jr_002_6444

	ldh a, [$ffe7]
	and $08
	jr nz, jr_002_6444

	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
	ld a, [$c1b5]
	and a
	jr z, jr_002_6431

	ld hl, $c09c

jr_002_6431:
	ld a, [$db9a]
	push hl
	ld hl, $ffd8
	add [hl]
	pop hl
	ld [hli], a
	ldh a, [$ffd7]
	ld [hli], a
	ld a, $04
	ld [hli], a
	ld a, $50
	ld [hli], a

jr_002_6444:
	ld a, $01
	call Call_3DD0
	ret


	db $07, $27, $07, $27, $07, $27, $07, $27, $07, $27, $28, $28, $40, $40, $58, $58
	db $70, $70, $88, $88

Call_02_645E::
	ld a, [$dba5]
	and a
	jr z, jr_002_64b8

	ldh a, [$fff7]
	cp $08
	jp nc, Jump_002_64bb

	ld a, [$d46b]
	and $f8
	add $58
	ld h, a
	ld a, [$d46b]
	rla
	rla
	rla
	and $38
	add $57
	ld l, a
	ld a, [$dbb0]
	and $20
	jr z, jr_002_6492

	ld a, [$d46b]
	and $38
	cp $20
	jr nc, jr_002_6492

	ld a, h
	sub $08
	ld h, a

jr_002_6492:
	ld a, [$dbb0]
	and $10
	jr z, jr_002_64a6

	ld a, [$d46b]
	and $07
	cp $04
	jr c, jr_002_64a6

	ld a, l
	add $08
	ld l, a

jr_002_64a6:
	ld a, h
	ld [$c000], a
	ld a, l
	ld [$c001], a
	ld a, $3f
	ld [$c002], a
	ldh a, [$ffe7]
	rla
	and $10

jr_002_64b8:
	ld [$c003], a

Jump_002_64bb:
	call Call_02_6505
	call Call_02_6742
	ld a, [$c159]
	inc a
	ld [$c159], a
	and $10
	jr nz, jr_002_64fc

	ld a, [$dba3]
	ld e, a
	ld d, $00
	ld hl, $6454
	add hl, de
	ld a, [hl]
	ld [$c004], a
	ld [$c008], a
	ld hl, $644a
	add hl, de
	ld a, [hl]
	ld [$c005], a
	add $20
	ld [$c009], a
	ld a, $be
	ld [$c006], a
	ld [$c00a], a
	ld a, $30
	ld [$c007], a
	ld a, $10
	ld [$c00b], a

jr_002_64fc:
	ret


	db $00, $01, $ff, $00, $00, $fe, $02, $00

Call_02_6505::
	ld a, [$dba3]
	ld [$c1b6], a
	ld a, [$c1b8]
	ld hl, $c1b9
	or [hl]
	jr nz, jr_002_655e

	ld a, [$c1b5]
	and a
	jr nz, jr_002_653a

	ldh a, [$ffcc]
	and $03
	ld e, a
	ld d, $00
	ld hl, $64fd
	add hl, de
	ld a, [$dba3]
	add [hl]
	ld [$dba3], a
	cp $0a
	jr c, jr_002_653a

	rla
	ld a, $00
	jr nc, jr_002_6537

	ld a, $09

jr_002_6537:
	ld [$dba3], a

jr_002_653a:
	ldh a, [$ffcc]
	srl a
	srl a
	and $03
	ld e, a
	ld d, $00
	ld hl, $6501
	add hl, de
	ld a, [$dba3]
	add [hl]
	ld [$dba3], a
	cp $0a
	jr c, jr_002_655e

	rla
	ld a, $00
	jr nc, jr_002_655b

	ld a, $09

jr_002_655b:
	ld [$dba3], a

jr_002_655e:
	ldh a, [$ffcb]
	and $0f
	jr z, jr_002_656e

	ld a, [$c1b5]
	and a
	jr nz, jr_002_656e

	xor a
	ld [$c159], a

jr_002_656e:
	ld a, [$c1b5]
	and a
	jr z, jr_002_658a

	ld a, [$c1b8]
	ld hl, $c1b9
	or [hl]
	jr nz, jr_002_658a

	ldh a, [$ffcc]
	and $80
	jr z, jr_002_658a

	ld a, $01
	ld [$c1ba], a
	jr jr_002_65b7

jr_002_658a:
	ld a, [$dba3]
	ld hl, $c1b6
	cp [hl]
	jr z, jr_002_65c6

	ld hl, $fff2
	ld [hl], $0a
	ld e, a
	ld d, $00
	ld hl, $db02
	add hl, de
	ld a, [hl]
	cp $09
	jr nz, jr_002_65b7

	ld a, [$db49]
	and a
	jr z, jr_002_65b7

	ld a, $08
	ldh [$ff90], a
	ld a, $10
	ld [$c1b8], a
	ld a, $01
	jr jr_002_65c3

jr_002_65b7:
	ld a, [$c1b5]
	and a
	jr z, jr_002_65c6

	ld a, $10
	ld [$c1b9], a
	xor a

jr_002_65c3:
	ld [$c1b5], a

jr_002_65c6:
	ld hl, $c1b9
	ld a, [$c1b8]
	or [hl]
	jp nz, Jump_002_667b

	ldh a, [$ffcc]
	and $10
	jr z, jr_002_661e

	ld a, [$db01]
	push af
	ld hl, $db02
	ld a, [$dba3]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [$db01], a
	pop af
	ld [hl], a
	cp $09
	jr nz, jr_002_6604

	ld a, [$db49]
	and a
	jr z, jr_002_6604

	ld a, $08
	ldh [$ff90], a
	ld a, $10
	ld [$c1b8], a
	ld a, $01
	ld [$c1b5], a
	jr jr_002_6613

jr_002_6604:
	ld a, [$c1b5]
	and a
	jr z, jr_002_6613

	xor a
	ld [$c1b5], a
	ld a, $10
	ld [$c1b9], a

jr_002_6613:
	ld c, $01
	ld b, $00
	ld e, $00
	call Call_02_61ED
	jr Call_02_666A

jr_002_661e:
	ldh a, [$ffcc]
	and $20
	jr z, jr_002_667b

	ld a, [$db00]
	push af
	ld hl, $db02
	ld a, [$dba3]
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [$db00], a
	pop af
	ld [hl], a
	cp $09
	jr nz, jr_002_6652

	ld a, [$db49]
	and a
	jr z, jr_002_6652

	ld a, $10
	ld [$c1b8], a
	ld a, $08
	ldh [$ff90], a
	ld a, $01
	ld [$c1b5], a
	jr jr_002_6661

jr_002_6652:
	ld a, [$c1b5]
	and a
	jr z, jr_002_6661

	xor a
	ld [$c1b5], a
	ld a, $10
	ld [$c1b9], a

jr_002_6661:
	ld c, $00
	ld b, $00
	ld e, $ff
	call Call_02_61ED

Call_02_666A::
	ld a, $13
	ldh [$fff2], a
	ld a, [$dba3]
	add $02
	ld c, a
	ld b, $00
	dec a
	ld e, a
	call Call_02_61ED

Jump_002_667b:
jr_002_667b:
	ret


	db $f8, $f0, $22, $00, $f8, $f8, $22, $20, $f8, $00, $24, $00, $f8, $08, $24, $20
	db $f8, $10, $26, $00, $f8, $18, $26, $20, $08, $f0, $20, $00, $08, $f8, $20, $00
	db $08, $00, $20, $00, $08, $08, $20, $00, $08, $10, $20, $00, $08, $18, $20, $00
	db $fb, $f4, $20, $00, $fb, $fc, $20, $20, $fb, $00, $20, $00, $fb, $08, $20, $20
	db $fb, $0c, $20, $00, $fb, $14, $20, $20, $05, $f4, $20, $00, $05, $fc, $20, $00
	db $05, $00, $20, $00, $05, $08, $20, $00, $05, $0c, $20, $00, $05, $14, $20, $00
	db $fd, $f8, $20, $00, $fd, $10, $20, $20, $fd, $00, $20, $00, $fd, $08, $20, $20
	db $fd, $08, $20, $00, $fd, $10, $20, $20, $03, $f8, $20, $00, $03, $10, $20, $00
	db $03, $00, $20, $00, $03, $08, $20, $00, $03, $08, $20, $00, $03, $10, $20, $00
	db $00, $00, $20, $00, $00, $08, $20, $20, $00, $00, $20, $00, $00, $08, $20, $20
	db $00, $00, $20, $00, $00, $08, $20, $20, $00, $00, $20, $00, $00, $08, $20, $00
	db $00, $00, $20, $00, $00, $08, $20, $00, $00, $00, $20, $00, $00, $08, $20, $00
	db $50, $60, $70, $04, $02, $01

Call_02_6742::
	ld a, [$c1b9]
	and a
	jr z, jr_002_6764

	dec a
	ld [$c1b9], a
	jr nz, jr_002_6761

	ld hl, $ff90
	ld [hl], $0b
	ld a, [$c1ba]
	and a
	jr z, jr_002_6760

	xor a
	ld [$c1ba], a
	jp Jump_002_5e3c


jr_002_6760:
	ret


jr_002_6761:
	cpl
	jr jr_002_676e

jr_002_6764:
	ld a, [$c1b8]
	and a
	jr z, jr_002_6774

	dec a
	ld [$c1b8], a

jr_002_676e:
	rra
	rra
	and $03
	jr jr_002_677d

jr_002_6774:
	ld a, [$c1b5]
	and a
	jp z, Jump_002_684a

	ld a, $00

jr_002_677d:
	ld [$c1b7], a
	ld a, [$c1b7]
	ld d, $00
	sla a
	sla a
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld hl, $667c
	add hl, de
	ld de, $c018
	ld c, $0c
	ld b, $04

jr_002_679d:
	ld a, [hli]
	add $30
	ld [de], a
	inc de
	ld a, [hli]
	add $60
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	cp $22
	jr z, jr_002_67b8

	cp $24
	jr z, jr_002_67bc

	cp $26
	jr z, jr_002_67c0

	jr jr_002_67cd

jr_002_67b8:
	ld b, $04
	jr jr_002_67c2

jr_002_67bc:
	ld b, $02
	jr jr_002_67c2

jr_002_67c0:
	ld b, $01

jr_002_67c2:
	ld a, [$db49]
	and b
	jr nz, jr_002_67cd

	dec de
	ld a, $20
	ld [de], a
	inc de

jr_002_67cd:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_002_679d

	ld a, [$c1b7]
	cp $00
	jr nz, jr_002_684a

	ldh a, [$ffcc]
	and $41
	jr z, jr_002_67f8

jr_002_67e0:
	ld hl, $db4a
	ld a, [hl]
	inc a
	cp $03
	jr nz, jr_002_67ea

	xor a

jr_002_67ea:
	ld [hl], a
	ld e, a
	ld d, $00
	ld hl, $673f
	add hl, de
	ld a, [$db49]
	and [hl]
	jr z, jr_002_67e0

jr_002_67f8:
	ldh a, [$ffcc]
	and $02
	jr z, jr_002_6817

jr_002_67fe:
	ld hl, $db4a
	ld a, [hl]
	dec a
	cp $80
	jr c, jr_002_6809

	ld a, $02

jr_002_6809:
	ld [hl], a
	ld e, a
	ld d, $00
	ld hl, $673f
	add hl, de
	ld a, [$db49]
	and [hl]
	jr z, jr_002_67fe

jr_002_6817:
	ld a, [$db4a]
	ldh a, [$ffcc]
	and $43
	jr z, jr_002_6823

	call Call_02_666A

jr_002_6823:
	ld hl, $c010
	ld a, $38
	ld [hli], a
	push hl
	ld a, [$db4a]
	ld e, a
	ld d, $00
	ld hl, $673c
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push af
	ld a, $28
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $38
	ld [hli], a
	pop af
	add $08
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld [hl], $20

Jump_002_684a:
jr_002_684a:
	ret


	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $7d, $7d, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ef, $ef, $ef, $7d, $7d, $ee, $7d
	db $ed, $7d, $ef, $ed, $ef, $ed, $ef, $7d, $ef, $ef, $ed, $ed, $ef, $ef, $ef, $7d
	db $ef, $7d, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ed, $ed, $ef, $ef, $ef, $7d
	db $7d, $7d, $ed, $7d, $7d, $ed, $7d, $7d, $7d, $ef, $ef, $7d, $7d, $ef, $ee, $7d
	db $7d, $ef, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ed, $7d, $7d, $7d, $7d, $ef, $7d
	db $7d, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $ed, $ed, $ed, $ed, $7d, $7d
	db $ef, $ef, $ed, $ef, $7d, $7d, $7d, $7d, $ed, $ef, $ed, $ed, $7d, $7d, $7d, $7d
	db $ef, $ef, $ef, $ef, $7d, $7d, $ef, $7d, $7d, $ed, $ef, $7d, $7d, $ef, $ef, $ef
	db $7d, $ed, $7d, $7d, $7d, $7d, $ef, $7d, $7d, $ed, $ed, $7d, $7d, $7d, $ef, $7d
	db $7d, $ed, $7d, $7d, $7d, $7d, $ee, $7d, $7d, $ef, $ed, $7d, $7d, $7d, $ef, $ef
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ef, $7d, $7d, $7d
	db $7d, $ef, $7d, $ef, $ef, $7d, $ed, $7d, $7d, $ee, $ef, $ed, $ef, $ed, $ef, $7d
	db $7d, $ef, $ed, $ed, $ef, $ef, $ed, $7d, $7d, $7d, $ef, $ef, $ef, $ed, $7d, $7d
	db $7d, $7d, $ed, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ed, $7d, $7d, $7d
	db $7d, $ef, $ef, $ef, $ed, $ef, $7d, $7d, $7d, $7d, $7d, $ee, $7d, $ef, $ed, $7d
	db $7d, $ef, $ef, $ef, $ef, $ef, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef
	db $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $ed, $ef, $ef, $ef, $7d, $7d
	db $7d, $7d, $7d, $ed, $ef, $ef, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $ef, $ed, $ef
	db $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $ed, $7d, $7d, $7d, $7d, $7d, $7d, $ed
	db $ef, $ed, $7d, $ef, $ef, $7d, $ed, $ef, $ef, $ed, $ef, $ef, $ee, $ef, $ed, $ef
	db $ed, $ef, $7d, $ef, $ef, $7d, $ef, $ef, $7d, $ef, $ed, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ed, $7d, $7d, $ef, $ed, $7d, $7d, $ef, $ef, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $ee, $ef, $7d
	db $ef, $ef, $ef, $ed, $7d, $ef, $ef, $7d, $ef, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $ed, $ef, $ef, $ed, $7d, $ef, $ed, $7d, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ed
	db $ed, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ef, $7d
	db $7d, $7d, $7d, $ef, $ef, $7d, $7d, $7d, $ed, $7d, $7d, $ee, $ed, $7d, $7d, $ed
	db $ef, $ef, $ed, $ef, $ef, $ed, $ef, $ef, $7d, $ed, $ef, $ef, $ef, $ef, $ef, $7d
	db $7d, $ed, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ed, $ef, $ed, $ef, $ef, $ef, $ef
	db $ef, $ed, $ef, $ef, $ef, $ed, $ef, $ef, $ed, $7d, $7d, $ef, $ef, $7d, $7d, $ed
	db $7d, $ed, $ed, $7d, $7d, $7d, $7d, $7d, $ef, $ef, $ef, $ef, $7d, $7d, $7d, $7d
	db $ef, $ef, $ef, $ed, $7d, $7d, $7d, $7d, $ef, $ed, $ef, $ef, $7d, $7d, $7d, $7d
	db $ed, $ef, $ef, $ed, $7d, $ef, $ed, $7d, $ef, $ef, $ef, $ef, $ef, $ee, $ef, $ef
	db $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $7d, $ef, $ef, $7d
	db $00, $02, $03, $07, $05, $0a, $0b, $0f, $04, $08, $09, $0e, $06, $0c, $0d, $01

Call_02_6A9B::
	ldh a, [$fff6]
	cp $e8
	ret z

	ld hl, $684b
	ldh a, [$fff7]
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
	jr nz, jr_002_6ac3

	ld a, [$db6b]
	and $04
	jr z, jr_002_6ac3

	ld hl, $6a4b

jr_002_6ac3:
	ld de, $d480
	ld bc, $0040
	call Call_28C5
	ld d, $00
	ld e, $00

Jump_002_6ad0:
	ld hl, $d480
	add hl, de
	ld a, [hl]
	cp $7d
	jr z, jr_002_6b3e

	cp $ed
	jr z, jr_002_6ae1

	cp $ee
	jr nz, jr_002_6ae9

jr_002_6ae1:
	ld a, [$dbcd]
	and a
	jr nz, jr_002_6af4

	ld [hl], $ef

jr_002_6ae9:
	ld a, [$dbcc]
	and a
	jr nz, jr_002_6af4

	ld [hl], $7d
	jp Jump_002_6b3e


jr_002_6af4:
	push de
	call Call_2B25
	push de
	pop bc
	pop de
	ld a, [hl]
	bit 7, a
	jr z, jr_002_6b3e

	ld a, [hl]
	and $0f
	ld c, a
	ld b, $00
	ld hl, $6a8b
	add hl, bc
	ld a, [hl]
	inc a
	add $cf
	ld c, a
	ld hl, $d480
	add hl, de
	ld a, [hl]
	cp $ee
	jr z, jr_002_6b1c

	cp $ed
	jr nz, jr_002_6b31

jr_002_6b1c:
	push de
	push af
	call Call_2B25
	pop af
	ld e, $20
	cp $ed
	jr nz, jr_002_6b2a

	ld e, $10

jr_002_6b2a:
	ld a, [hl]
	and e
	pop de
	cp $00
	jr z, jr_002_6b3e

jr_002_6b31:
	ld hl, $d480
	add hl, de
	ld [hl], c
	ld a, [$dbcc]
	and a
	jr nz, jr_002_6b3e

	ld [hl], $7d

Jump_002_6b3e:
jr_002_6b3e:
	inc e
	ld a, e
	cp $40
	jp nz, Jump_002_6ad0

	ret


Call_02_6B46::
	ld a, [$dbb0]
	and $30
	swap a
	rst $00

JumpTable_02_6B4E::
	dw Jump_02_6B56
	dw Jump_02_6B5B
	dw Jump_02_6B60
	dw Jump_02_6B65

Jump_02_6B56::
	ld hl, $9d2e
	jr jr_002_6b68

Jump_02_6B5B::
	ld hl, $9d2f
	jr jr_002_6b68

Jump_02_6B60::
	ld hl, $9d0e
	jr jr_002_6b68

Jump_02_6B65::
	ld hl, $9d0f

jr_002_6b68:
	ld e, $04
	jr jr_002_6bbd

Call_02_6B6C::
	ld a, [$dbb0]
	and $30
	swap a
	rst $00

JumpTable_02_6B74::
	dw Jump_02_6B7C
	dw Jump_02_6B81
	dw Jump_02_6B86
	dw Jump_02_6B8B

Jump_02_6B7C::
	ld hl, $9dae
	jr jr_002_6b8e

Jump_02_6B81::
	ld hl, $9daf
	jr jr_002_6b8e

Jump_02_6B86::
	ld hl, $9dae
	jr jr_002_6b8e

Jump_02_6B8B::
	ld hl, $9daf

jr_002_6b8e:
	ld e, $24
	jr jr_002_6bbd

Call_02_6B92::
	ld a, [$dbb0]
	and $30
	swap a
	rst $00

JumpTable_02_6B9A::
	dw Jump_02_6BA2
	dw Jump_02_6BA7
	dw Jump_02_6BAC
	dw Jump_02_6BB1

Jump_02_6BA2::
	ld hl, $9d2a
	jr jr_002_6bb4

Jump_02_6BA7::
	ld hl, $9d2a
	jr jr_002_6bb4

Jump_02_6BAC::
	ld hl, $9d0a
	jr jr_002_6bb4

Jump_02_6BB1::
	ld hl, $9d0a

jr_002_6bb4:
	ld e, $00
	jr jr_002_6bbd

Call_02_6BB8::
	ld hl, $9daa
	ld e, $20

jr_002_6bbd:
	ld c, $00
	ld d, c

jr_002_6bc0:
	push hl
	ld hl, $d480
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	inc e
	inc c
	ld a, c
	cp $10
	jr z, jr_002_6be2

	inc hl
	and $03
	jr nz, jr_002_6bc0

	ld a, e
	add $04
	ld e, a
	ld a, l
	add $1c
	ld l, a
	ld a, $00
	adc h
	ld h, a
	jr jr_002_6bc0

jr_002_6be2:
	ret


	db $00, $08, $f8, $00, $f0, $10, $00, $10, $f0, $ff, $00, $01

Call_02_6BEF::
	ld a, [$c146]
	and a
	jr nz, jr_002_6bff

	ldh a, [$ffa1]
	cp $01
	jr z, jr_002_6c1b

	cp $02
	jr z, jr_002_6c1b

jr_002_6bff:
	ld a, [$c13e]
	and a
	jr z, jr_002_6c1c

	dec a
	ld [$c13e], a
	call Call_20D6
	call Call_02_6FB1
	ldh a, [$ff9c]
	cp $02
	jr z, jr_002_6c1b

	ldh a, [$ff9b]
	add $03
	ldh [$ff9b], a

jr_002_6c1b:
	ret


jr_002_6c1c:
	ldh a, [$ff9c]
	rst $00

JumpTable_02_6C1F::
	dw Jump_02_6D3A
	dw Jump_02_6CDA
	dw Jump_02_6C48

	db $00, $08, $f8, $00, $00, $06, $fa, $00, $00, $06, $fa, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $f8, $fa, $fa, $00, $08, $06, $06, $00, $00, $00, $00, $00
	db $00, $00, $01

Jump_02_6C48::
	ldh a, [$fff7]
	cp $07
	jr nz, jr_002_6c63

	call Call_02_79D9
	ld a, [$db94]
	add $04
	ld [$db94], a
	ld a, $03
	ldh [$fff3], a
	ld a, $80
	ld [$dbc7], a
	ret


jr_002_6c63:
	ld a, [$db0c]
	and a
	jp z, Call_02_79D9

	ld hl, $ff9e
	res 1, [hl]
	call Call_0942
	ld [$c146], a
	ldh a, [$ffe7]
	and $01
	jr nz, jr_002_6ca6

	ldh a, [$ffcb]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $6c25
	add hl, de
	ld a, [hl]
	ld hl, $ff9a
	sub [hl]
	jr z, jr_002_6c94

	inc [hl]
	bit 7, a
	jr z, jr_002_6c94

	dec [hl]
	dec [hl]

jr_002_6c94:
	ld hl, $6c35
	add hl, de
	ld a, [hl]
	ld hl, $ff9b
	sub [hl]
	jr z, jr_002_6ca6

	inc [hl]
	bit 7, a
	jr z, jr_002_6ca6

	dec [hl]
	dec [hl]

jr_002_6ca6:
	ld hl, $c120
	inc [hl]
	ldh a, [$ffcb]
	and $03
	jr z, jr_002_6cba

	ld e, a
	ld d, $00
	ld hl, $6c45
	add hl, de
	ld a, [hl]
	ldh [$ff9e], a

jr_002_6cba:
	call Call_20D6
	call Call_02_6FB1
	ld a, [$c14f]
	and a
	ret nz

	ldh a, [$ffd7]
	cp $b0
	jr z, jr_002_6cd6

	cp $b1
	jr nz, jr_002_6cd3

	ld a, $01
	jr jr_002_6cd4

jr_002_6cd3:
	xor a

jr_002_6cd4:
	ldh [$ff9c], a

jr_002_6cd6:
	call Call_02_6E8F
	ret


Jump_02_6CDA::
	call Call_0942
	ld [$c146], a
	ld [$c153], a
	ld [$c152], a
	ldh a, [$ffcb]
	and $03
	ld e, a
	ld d, $00
	ld hl, $6be3
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ldh a, [$ffcb]
	rra
	rra
	and $03
	ld e, a
	ld hl, $6be6
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	ld a, $02
	ldh [$ff9e], a
	ldh a, [$ffcb]
	and $0f
	jr z, jr_002_6d10

	ld hl, $c120
	inc [hl]

jr_002_6d10:
	call Call_20D6
	call Call_02_6FB1
	ld a, [$c14f]
	and a
	ret nz

	ldh a, [$ffd7]
	cp $b1
	jr z, jr_002_6d2c

	cp $b0
	jr nz, jr_002_6d29

	ld a, $02
	jr jr_002_6d2a

jr_002_6d29:
	xor a

jr_002_6d2a:
	ldh [$ff9c], a

jr_002_6d2c:
	call Call_02_6E8F
	ld a, [$c133]
	and $08
	jr z, jr_002_6d39

	xor a
	ldh [$ff9c], a

jr_002_6d39:
	ret


Jump_02_6D3A::
	ldh a, [$fff7]
	cp $06
	jr nz, jr_002_6d5d

	ldh a, [$fff6]
	cp $f8
	jr nz, jr_002_6d5d

	ld a, [$c146]
	and a
	jr nz, jr_002_6d5d

	ldh a, [$ff98]
	sub $46
	add $04
	cp $08
	jr nc, jr_002_6d5d

	ldh a, [$ffcc]
	and $04
	jp nz, Call_0909

jr_002_6d5d:
	ld a, [$c14a]
	and a
	jr z, jr_002_6d85

	ldh a, [$ffcc]
	and $0f
	jr nz, jr_002_6d77

	ld a, [$c120]
	add $02
	ld [$c120], a
	call Call_145D
	jp Jump_002_6e14


jr_002_6d77:
	ld [$c19a], a
	ld a, [$c199]
	add $0c
	ld [$c199], a
	call Call_093B

jr_002_6d85:
	ld a, [$c147]
	and a
	jr nz, jr_002_6dcd

	ld a, [$c133]
	and $08
	jr nz, jr_002_6dcd

	ld a, [$c146]
	and a
	jr nz, jr_002_6d9d

	ld a, $01
	ld [$c146], a

jr_002_6d9d:
	ld a, $0a
	ld [$c120], a
	ldh a, [$ff9a]
	and a
	jr z, jr_002_6dac

	rlca
	and $01
	ldh [$ff9e], a

jr_002_6dac:
	ldh a, [$ffcb]
	and $03
	jr z, jr_002_6dcb

	ld e, a
	ld d, $00
	ld hl, $6be9
	add hl, de
	ldh a, [$ff9a]
	sub [hl]
	jr z, jr_002_6dcb

	ld e, $01
	bit 7, a
	jr nz, jr_002_6dc6

	ld e, $ff

jr_002_6dc6:
	ldh a, [$ff9a]
	add e
	ldh [$ff9a], a

jr_002_6dcb:
	jr jr_002_6e14

jr_002_6dcd:
	ld a, [$c146]
	and a
	jr z, jr_002_6de3

	ld a, $07
	ldh [$fff4], a
	call Call_0942
	ld [$c146], a
	ld [$c152], a
	ld [$c153], a

jr_002_6de3:
	ldh a, [$ffcb]
	and $03
	ld e, a
	ld d, $00
	ld hl, $6be9
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $6bec
	add hl, de
	ld a, [hl]
	cp $ff
	jr z, jr_002_6e0a

	ld e, a
	ld a, [$c16e]
	and a
	jr nz, jr_002_6e04

	ld a, e
	ldh [$ff9e], a

jr_002_6e04:
	ld hl, $c120
	inc [hl]
	jr jr_002_6e14

jr_002_6e0a:
	ld a, [$c14b]
	and a
	jr nz, jr_002_6e14

	xor a
	ld [$c120], a

Jump_002_6e14:
jr_002_6e14:
	ld a, [$c137]
	and a
	jr nz, jr_002_6e1f

	ldh a, [$ffa1]
	and a
	jr nz, jr_002_6e35

jr_002_6e1f:
	call Call_20D6
	ld hl, $ff9e
	ldh a, [$ffcb]
	and $0f
	cp $04
	jr nz, jr_002_6e2f

	ld [hl], $02

jr_002_6e2f:
	cp $08
	jr nz, jr_002_6e35

	ld [hl], $03

jr_002_6e35:
	call Call_02_6FB1
	ld a, [$c14f]
	and a
	ret nz

	ldh a, [$ffd7]
	cp $b1
	jr z, jr_002_6e63

	cp $b0
	jr nz, jr_002_6e6d

	ld a, [$c133]
	and a
	jr nz, jr_002_6e5f

	ld a, [$dbc7]
	and a
	jr nz, jr_002_6e58

	ld a, $02
	call Call_02_571B

jr_002_6e58:
	ld a, $04
	ldh [$ff9b], a
	xor a
	ldh [$ff9a], a

jr_002_6e5f:
	ld a, $02
	jr jr_002_6e6b

jr_002_6e63:
	ldh a, [$ffcb]
	and $0c
	jr z, jr_002_6e6d

	ld a, $01

jr_002_6e6b:
	ldh [$ff9c], a

jr_002_6e6d:
	ld hl, $ff9b
	ld a, [hl]
	sub $40
	and $80
	jr z, Call_02_6E8F

	inc [hl]
	ldh a, [$ff9b]
	and $80
	jr z, jr_002_6e8e

	ld e, $20
	ld a, [$db00]
	cp $0a
	jr z, jr_002_6e89

	ld e, $10

jr_002_6e89:
	ldh a, [$ffcb]
	and e
	jr nz, Call_02_6E8F

jr_002_6e8e:
	inc [hl]

Call_02_6E8F::
	ret


	db $01, $02, $04, $08, $10, $0b, $05, $08, $08, $08, $08, $08, $04, $10, $0b

Call_02_6E9F::
	ld c, $04
	ld b, $00
	call Call_02_6F6B
	ldh a, [$ffd8]
	ldh [$ffd7], a
	xor a
	ld [$c133], a
	ld c, $00
	ldh a, [$ff9a]
	and a
	jr z, jr_002_6edb

	and $80
	jr z, jr_002_6eba

	inc c

jr_002_6eba:
	call Call_02_6F6B
	ldh a, [$ffaf]
	cp $8a
	jr nz, jr_002_6ed2

	ld a, [$c5a6]
	and a
	jr nz, jr_002_6ed2

	inc a
	ld [$c5a6], a
	ld a, $51
	call Call_2197

jr_002_6ed2:
	ldh a, [$ffaf]
	cp $ff
	jr nz, jr_002_6edb

	call Call_02_6FA5

jr_002_6edb:
	ld c, $02
	ldh a, [$ff9b]
	and a
	and $80
	jr nz, jr_002_6ee5

	inc c

jr_002_6ee5:
	call Call_02_6F6B
	ldh a, [$ff9b]
	and $80
	jr nz, jr_002_6f0a

	ldh a, [$ffcb]
	and $08
	jr nz, jr_002_6f0a

	ldh a, [$ffe9]
	and $0f
	cp $03
	jr nc, jr_002_6f0a

	ldh a, [$ffaf]
	cp $62
	jr z, jr_002_6f11

	cp $64
	jr z, jr_002_6f11

	cp $66
	jr z, jr_002_6f11

jr_002_6f0a:
	ld a, [$c133]
	and $08
	jr z, jr_002_6f24

jr_002_6f11:
	ld a, [$c133]
	or $08
	ld [$c133], a
	xor a
	ldh [$ff9b], a
	ldh a, [$ff99]
	and $f0
	add $00
	ldh [$ff99], a

jr_002_6f24:
	ld a, [$c133]
	and $04
	jr z, jr_002_6f2f

	ldh a, [$ffa0]
	ldh [$ff99], a

jr_002_6f2f:
	ld a, [$c133]
	and $03
	jr z, jr_002_6f6a

	ldh a, [$ff9f]
	ldh [$ff98], a
	ld a, [$c14a]
	and a
	jr z, jr_002_6f6a

	call Call_093B
	ldh a, [$ff9a]
	cpl
	inc a
	sra a
	sra a
	ldh [$ff9a], a
	ld a, $e8
	ldh [$ff9b], a
	call Call_20D6
	call Call_02_6FB1
	ld a, $20
	ld [$c157], a
	ldh a, [$ff9e]
	and $02
	sla a
	ld [$c158], a
	ld a, $0b
	ldh [$fff2], a
	ret


jr_002_6f6a:
	ret


Call_02_6F6B::
	ld hl, $6e95
	add hl, bc
	ldh a, [$ff98]
	sub $08
	add [hl]
	swap a
	and $0f
	ld e, a
	ld hl, $6e9a
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	sub $10
	ldh [$ffe9], a
	and $f0
	or e
	ld e, a
	ld d, $00
	ld hl, $d711
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
	ldh [$ffaf], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	ldh [$ffd8], a
	cp $60
	jr z, Call_02_6FA5

	cp $01
	jr nz, jr_002_6fb0

Call_02_6FA5::
	ld hl, $6e90
	add hl, bc
	ld a, [$c133]
	or [hl]
	ld [$c133], a

jr_002_6fb0:
	ret


Call_02_6FB1::
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ret nz

	ldh a, [$fff7]
	cp $1f
	jr nz, jr_002_6fd5

	ldh a, [$fff9]
	and a
	jr z, jr_002_6fd5

	ldh a, [$fff6]
	cp $eb
	jr z, jr_002_6fce

	cp $ec
	jr nz, jr_002_6fd5

jr_002_6fce:
	ldh a, [$ff99]
	cp $2c
	jp c, Call_0909

jr_002_6fd5:
	ld e, $02
	ldh a, [$ff99]
	cp $0c
	jr c, jr_002_6ff2

	inc e
	cp $84
	jr nc, jr_002_6ff2

	ld e, $01
	ldh a, [$ff98]
	cp $04
	jr c, jr_002_704f

	dec e
	cp $9c
	jr nc, jr_002_704f

	jp Jump_002_7142


jr_002_6ff2:
	ldh a, [$fff9]
	and a
	jr nz, jr_002_700d

	ldh a, [$fff7]
	cp $1f
	jp nz, Jump_002_7098

	ldh a, [$fff6]
	cp $f5
	jp z, Call_0909

	cp $f2
	jp nz, Jump_002_7098

	jp Call_0909


jr_002_700d:
	ldh a, [$fff6]
	cp $e8
	jp z, Jump_002_7098

	cp $f8
	jp z, Jump_002_7098

	cp $fd
	jr z, jr_002_703c

	cp $a3
	jp z, Call_0909

	cp $c0
	jp z, Call_0909

	cp $c1
	jp z, Call_0909

	cp $ff
	jr nz, jr_002_7046

	ldh a, [$ff99]
	cp $50
	jr nc, jr_002_703c

	ld a, [$c280]
	and a
	jr z, jr_002_7098

jr_002_703c:
	ldh a, [$ffa0]
	ldh [$ff99], a
	xor a
	ldh [$ff9b], a
	jp Jump_002_7142


jr_002_7046:
	ldh a, [$ff9c]
	cp $02
	jr z, jr_002_7098

	jp Call_0909


jr_002_704f:
	ldh a, [$ff9f]
	ldh [$ff98], a
	xor a
	ldh [$ff9a], a
	ldh a, [$fff9]
	and a
	jr z, jr_002_7098

	ldh a, [$fff6]
	cp $f5
	jp z, Call_090F

	cp $fd
	jp z, Call_090F

	cp $e9
	jp z, Call_0909

	cp $e8
	jp z, Jump_002_7142

	cp $f8
	jp z, Jump_002_7142

	cp $ef
	jp z, Jump_002_7142

	cp $ff
	jp z, Jump_002_7142

	cp $c0
	jr nz, jr_002_708d

	ldh a, [$ff98]
	cp $30
	jp c, Jump_002_7142

	jr jr_002_7098

jr_002_708d:
	cp $c1
	jr nz, jr_002_7098

	ldh a, [$ff98]
	cp $50
	jp nc, Jump_002_7142

Jump_002_7098:
jr_002_7098:
	call Call_094A
	ld a, [$c181]
	cp $50
	jp z, Jump_002_7146

	cp $51
	jp z, Jump_002_7146

	ld a, [$c11f]
	cp $07
	jp z, Jump_002_7146

	ld a, [$c11c]
	cp $06
	jp z, Jump_002_7146

	ldh a, [$fff9]
	and a
	jr nz, jr_002_70c4

	ld a, [$c146]
	and a
	jp nz, Jump_002_7146

jr_002_70c4:
	ld a, [$c14a]
	and a
	jr nz, jr_002_70d0

	ld a, [$c16d]
	and a
	jr nz, jr_002_7146

jr_002_70d0:
	ld a, [$c13e]
	ld hl, $c157
	or [hl]
	jr nz, jr_002_7146

	ldh a, [$ff99]
	cp $88
	jr nc, jr_002_7108

	ld a, [$c14a]
	ld hl, $fff9
	or [hl]
	ld hl, $ffb2
	or [hl]
	jr nz, jr_002_7108

	ldh a, [$ffcb]
	and $0f
	jr z, jr_002_7146

	and $03
	jr z, jr_002_70fa

	dec a
	cp e
	jr z, jr_002_7108

jr_002_70fa:
	ldh a, [$ffcb]
	rra
	rra
	and $03
	jr z, jr_002_7146

	dec a
	add $02
	cp e
	jr nz, jr_002_7146

jr_002_7108:
	ldh a, [$fff6]
	cp $e8
	jr nz, jr_002_7120

	ldh a, [$fff7]
	cp $1f
	jr z, jr_002_7120

	ld a, [$dba5]
	and a
	jr z, jr_002_7120

	xor a
	ld [$c1bf], a
	ldh [rSCX], a

jr_002_7120:
	ld a, e
	ld [$c125], a
	ld a, $01
	ld [$c124], a
	xor a
	ld [$c14b], a
	ld [$c121], a
	ld [$c14a], a
	ldh a, [$ff99]
	cp $88
	jr c, jr_002_7142

	ld a, $02
	ld [$c146], a
	ld a, $08
	ldh [$ffa2], a

Jump_002_7142:
jr_002_7142:
	call Call_02_7180
	ret


Jump_002_7146:
jr_002_7146:
	call Call_1495
	ld [$c13e], a
	call Call_02_7180

jr_002_714f:
	ret


	db $06, $09, $0b, $0b, $06, $09, $04, $04, $06, $06, $09, $0c, $0f, $0f, $09, $0c
	db $04, $00, $02, $06, $01, $02, $04, $08, $01, $02, $04, $08, $02, $02, $00, $00
	db $03, $03, $01, $01, $00, $01, $ff, $00, $10, $f0, $00, $00, $00, $00, $f0, $10

Call_02_7180::
	ld hl, $c10a
	ld a, [$c17b]
	or [hl]
	jr nz, jr_002_714f

	ldh a, [$fff9]
	and a
	jr z, jr_002_7192

	call Call_02_6E9F
	ret


jr_002_7192:
	xor a
	ld [$c133], a
	ldh a, [$ff9b]
	cp $00
	jr z, jr_002_721a

	ld e, $03
	rla
	ld bc, $7160
	jr nc, jr_002_71a6

	dec e
	inc bc

jr_002_71a6:
	ld a, e
	ldh [$ffe3], a
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

jr_002_71af:
	push de
	push bc
	call Call_02_726A
	pop bc
	pop de
	inc bc
	dec e
	jr nz, jr_002_71af

	ldh a, [$ff9b]
	and $80
	jr nz, jr_002_7203

	ld a, [$dba5]
	and a
	jr nz, jr_002_7203

	ldh a, [$ffaf]
	cp $e9
	jr nz, jr_002_7203

	ld a, [$db0c]
	and a
	jr z, jr_002_7203

	ld a, [$c5a8]
	cp $d5
	jr z, jr_002_7203

	ld a, [$c11c]
	cp $02
	jr z, jr_002_721a

	ld a, $08
	ldh [$fff2], a
	jr jr_002_71f2

Call_02_71E6::
	ld a, $08
	ldh [$fff2], a

Call_02_71EA::
	ldh a, [$ff98]
	and $f0
	add $08
	ldh [$ff98], a

jr_002_71f2:
	ld a, $02
	ld [$c11c], a
	xor a
	ldh [$ff9c], a
	ldh a, [$ff99]
	sub $08
	ldh [$ff99], a
	jp Call_0942


jr_002_7203:
	ld a, [$c133]
	and $03
	jr z, jr_002_721a

	ld e, a
	ld d, $00
	ld hl, $7174
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ff98], a
	ldh a, [$ffa0]
	ldh [$ff99], a

jr_002_721a:
	ldh a, [$ff9a]
	cp $00
	jr z, jr_002_7259

	ld e, $00
	rla
	ld bc, $7162
	jr nc, jr_002_722a

	inc e
	inc bc

jr_002_722a:
	ld a, e
	ldh [$ffe3], a
	ld e, $02
	ld a, [bc]
	ld c, a
	ld b, $00

jr_002_7233:
	push de
	push bc
	call Call_02_726A
	pop bc
	pop de
	inc bc
	dec e
	jr nz, jr_002_7233

	ld a, [$c133]
	and $0c
	jr z, jr_002_7259

	srl a
	srl a
	ld e, a
	ld d, $00
	ld hl, $7174
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ldh [$ff99], a
	ldh a, [$ff9f]
	ldh [$ff98], a

jr_002_7259:
	ld a, [$c133]
	and a
	jr nz, jr_002_7262

	ld [$c1c3], a

jr_002_7262:
	call Call_02_7769
	ret


	db $01, $02, $04, $08

Call_02_726A::
	ld hl, $7150
	add hl, bc
	ldh a, [$ff98]
	sub $08
	add [hl]
	ldh [$ffdb], a
	swap a
	and $0f
	ld e, a
	ld hl, $7158
	add hl, bc
	ldh a, [$ff99]
	add [hl]
	sub $10
	ldh [$ffdc], a
	and $f0
	or e
	ld e, a
	ldh [$ffe9], a
	ld d, $00
	ld hl, $d711
	ld a, h
	add hl, de
	ld h, a
	ld a, [hl]
	ldh [$ffaf], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	ldh [$ffe4], a
	and a
	jp z, Jump_002_771c

	cp $01
	jp z, Jump_002_75b1

	cp $02
	jp z, Jump_002_759a

	cp $03
	jp z, Jump_002_74f9

	cp $10
	jp z, Jump_002_74da

	cp $04
	jp z, Jump_002_7577

	cp $30
	jp z, Jump_002_75b1

	cp $60
	jp z, Jump_002_75b1

	cp $0a
	jp z, Jump_002_759a

	cp $ff
	jp z, Jump_002_771c

	cp $e0
	jp z, Jump_002_771c

	cp $f0
	jp nc, Jump_002_771c

	cp $c0
	jp nz, Jump_002_7383

	ldh a, [$ff9e]
	cp $02
	jp nz, Jump_002_7379

	ldh a, [$fff8]
	bit 4, a
	jp nz, Jump_002_7379

	ldh a, [$fff6]
	cp $0e
	jr nz, jr_002_72fb

	ld a, [$db14]
	ld e, $33
	jr jr_002_7304

jr_002_72fb:
	cp $8c
	jr nz, jr_002_7321

	ld a, [$db13]
	ld e, $34

jr_002_7304:
	and a
	jr z, jr_002_737c

	ldh a, [$fff6]
	cp $8c
	jr nz, jr_002_7312

	call Call_27D2
	jr jr_002_7315

jr_002_7312:
	call Call_02_525B

jr_002_7315:
	ld a, $28
	call Call_3C01
	ld hl, $c2c0
	add hl, de
	inc [hl]
	jr jr_002_736a

jr_002_7321:
	cp $2b
	jr nz, jr_002_733c

	ld a, [$db12]
	and a
	ld e, $32
	jr z, jr_002_737c

	call Call_27D2
	ld a, $5f
	call Call_3C01
	ld hl, $c440
	add hl, de
	dec [hl]
	jr jr_002_736a

jr_002_733c:
	cp $b5
	jr nz, jr_002_734b

	ld a, [$db15]
	cp $06
	ld e, $31
	jr nz, jr_002_737c

	jr jr_002_7353

jr_002_734b:
	ld a, [$db11]
	and a
	ld e, $30
	jr z, jr_002_737c

jr_002_7353:
	ldh a, [$ff99]
	ldh [$ffd8], a
	ldh a, [$ff98]
	ldh [$ffd7], a
	ld a, $09
	call Call_0953
	ld [hl], $df
	ld a, $df
	ld [$c111], a
	call Call_27D2

jr_002_736a:
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [$fff8], a

Jump_002_7379:
	jp Jump_002_75b1


jr_002_737c:
	ld a, e
	call Call_02_77C4
	jp Jump_002_75b1


Jump_002_7383:
	ldh a, [$ffaf]
	cp $db
	jr nz, jr_002_7391

	ld a, [$c11c]
	cp $01
	jp z, Jump_002_75b1

jr_002_7391:
	ldh a, [$ffe4]
	cp $d0
	jp c, Jump_002_741d

	cp $d4
	jp nc, Jump_002_741d

	sub $d0
	ld e, a
	ld a, [$dba5]
	and a
	jr nz, jr_002_73c3

	ld a, e
	cp $00
	jr nz, jr_002_73b6

	ldh a, [$ffdb]
	and $0f
	cp $08
	jp c, Jump_002_771c

	jr jr_002_73c3

jr_002_73b6:
	cp $01
	jr nz, jr_002_73c3

	ldh a, [$ffdb]
	and $0f
	cp $08
	jp nc, Jump_002_771c

jr_002_73c3:
	ld d, $00
	ldh a, [$ff9e]
	cp e
	jp nz, Jump_002_7416

	ld a, [$c13e]
	ld hl, $c121
	or [hl]
	ld hl, $d45e
	or [hl]
	jr nz, jr_002_7416

	ld a, [$c14a]
	and a
	jr nz, jr_002_73f3

	ld hl, $7266
	add hl, de
	ldh a, [$ffcb]
	and [hl]
	jr z, jr_002_7416

	ld a, [$c191]
	inc a
	ld [$c191], a
	cp $0c
	jp c, Jump_002_75b1

jr_002_73f3:
	call Call_0942
	ld hl, $7178
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $717c
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	ld a, $1c
	ldh [$ffa3], a
	ld a, $01
	ld [$c146], a
	ld a, $01
	ld [$c10a], a
	ld a, $08
	ldh [$fff2], a

Jump_002_7416:
jr_002_7416:
	xor a
	ld [$c191], a
	jp Jump_002_75b1


Jump_002_741d:
	cp $90
	jp c, Jump_002_749d

	cp $99
	jp nc, Jump_002_75b1

	sub $90
	ld e, a
	ld d, $00
	bit 1, a
	jr nz, jr_002_7441

	ld hl, $c1d0
	add hl, de
	ld e, [hl]
	ldh a, [$ff98]
	sub e
	sub $0c
	cp $08
	jp nc, Jump_002_75b1

	jr jr_002_7450

jr_002_7441:
	ld hl, $c1e0
	add hl, de
	ld e, [hl]
	ldh a, [$ff99]
	sub e
	sub $14
	cp $08
	jp nc, Jump_002_75b1

jr_002_7450:
	ld a, [$c188]
	and a
	jp nz, Jump_002_75b1

	ldh a, [$ffe4]
	cp $94
	jr nc, jr_002_746a

	ld a, [$dbd0]
	and a
	jp z, Jump_002_75b1

	dec a
	ld [$dbd0], a
	jr jr_002_7485

jr_002_746a:
	cp $98
	jr z, jr_002_7477

	ld a, [$c18e]
	and a
	jr z, jr_002_7485

	jp Jump_002_75b1


jr_002_7477:
	ld a, [$dbcf]
	and a
	jr nz, jr_002_7485

	ld a, $07
	call Call_02_77BE
	jp Jump_002_75b1


jr_002_7485:
	ldh a, [$ffe4]
	sub $90
	ld [$c189], a
	xor a
	ld [$dbac], a
	inc a
	ld [$c188], a
	call Call_27E2
	call Call_02_525B
	jp Jump_002_75b1


Jump_002_749d:
	cp $7c
	jp c, Jump_002_771c

	push af
	jr z, jr_002_74a9

	cp $7d
	jr nz, jr_002_74ac

jr_002_74a9:
	call Call_02_7723

jr_002_74ac:
	pop af
	cp $90
	jp nc, Jump_002_771c

	sub $7c
	sla a
	sla a
	ld e, a
	ld d, $00
	ld hl, $4979
	add hl, de
	ldh a, [$ffdb]
	rra
	rra
	rra
	and $01
	ld e, a
	ldh a, [$ffdc]
	rra
	rra
	and $02
	or e
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	and a
	jp nz, Jump_002_75b1

	jp Jump_002_771c


Jump_002_74da:
	ld a, [$c11c]
	cp $02
	jp z, Jump_002_770f

	ld a, [$c5a8]
	cp $d5
	jp z, Jump_002_770f

	ldh a, [$ffdc]
	and $0f
	cp $08
	jp c, Jump_002_771c

	call Call_02_71E6
	jp Jump_002_770f


Jump_002_74f9:
	ld a, [$c15c]
	and a
	jp nz, Jump_002_770f

	ldh a, [$ffdc]
	and $0f
	cp $06
	jp nc, Jump_002_75a4

	ld a, [$dba5]
	and a
	jr nz, jr_002_7566

	ld a, [$db79]
	cp $01
	jr z, jr_002_751c

	ld a, [$db73]
	and a
	jr z, jr_002_7566

jr_002_751c:
	ldh a, [$fff6]
	cp $d3
	jr z, jr_002_753e

	cp $24
	jr z, jr_002_753e

	cp $b5
	jr z, jr_002_753e

	cp $2b
	jr z, jr_002_753e

	cp $d9
	jr z, jr_002_753e

	cp $ac
	jr z, jr_002_753e

	cp $8c
	jr z, jr_002_753e

	cp $0e
	jr nz, jr_002_7566

jr_002_753e:
	ld a, [$db79]
	cp $01
	jr nz, jr_002_754d

	ld a, $12
	call Call_02_77C4
	jp Jump_002_770f


jr_002_754d:
	xor a
	ld [$db47], a
	ld a, $98
	ld [$c3c9], a
	call Call_2185
	ld a, [$c163]
	inc a
	ld [$db10], a
	call Call_092A
	jp Jump_002_770f


jr_002_7566:
	ld a, [$c13e]
	and a
	jp nz, Jump_002_770f

	ld a, [$dba5]
	and a
	jp nz, Call_0915

	jp Call_0909


Jump_002_7577:
	ld a, [$d6f9]
	and a
	jp nz, Jump_002_771c

	ldh a, [$ffaf]
	cp $db
	jr c, jr_002_75b1

	cp $dd
	jr nc, jr_002_75b1

	sub $db
	ld e, a
	ld d, $00
	ld hl, $7b35
	add hl, de
	ld a, [$d6fb]
	xor [hl]
	jr nz, jr_002_75b1

	jp Jump_002_771c


Jump_002_759a:
	ld hl, $c11f
	ld [hl], $01
	cp $0a
	jp z, Jump_002_771c

Jump_002_75a4:
	ldh a, [$ffdb]
	and $0f
	cp $06
	jr c, jr_002_75b1

	cp $0b
	jp c, Jump_002_771c

Jump_002_75b1:
jr_002_75b1:
	ldh a, [$ffaf]
	cp $69
	jr nz, jr_002_75c8

	ld hl, $ffe3
	ldh a, [$ff9e]
	cp [hl]
	jr nz, jr_002_75c5

	ld a, [$c15b]
	and a
	jr nz, jr_002_75c8

jr_002_75c5:
	call Call_02_78B5

jr_002_75c8:
	ld hl, $ffe3
	ldh a, [$ff9e]
	cp [hl]
	jr nz, jr_002_7634

	ld a, [$c13e]
	ld hl, $c146
	or [hl]
	jr nz, jr_002_7634

	ld a, [$dba5]
	and a
	ldh a, [$ffaf]
	jr z, jr_002_760b

	ld e, $8a
	cp $a9
	jr z, jr_002_7626

	ld e, $8b
	cp $4f
	jr z, jr_002_75f5

	cp $4e
	jr z, jr_002_75f5

	cp $88
	jr nz, jr_002_75fd

jr_002_75f5:
	ld a, [$c14a]
	and a
	jr nz, jr_002_7634

	jr jr_002_7626

jr_002_75fd:
	cp $de
	jr nz, jr_002_760b

	ld a, [$dbd0]
	and a
	jr nz, jr_002_7634

	ld e, $8c
	jr jr_002_7626

jr_002_760b:
	cp $20
	jr nz, jr_002_7634

	ld a, [$db01]
	cp $03
	jr z, jr_002_7634

	ld a, [$db00]
	cp $03
	jr z, jr_002_7634

	ld a, [$db66]
	and $02
	jr nz, jr_002_7634

	ld e, $8d

jr_002_7626:
	ld a, [$c5a6]
	and a
	jr nz, jr_002_7634

	inc a
	ld [$c5a6], a
	ld a, e
	call Call_02_77BE

jr_002_7634:
	ld a, [$c14a]
	and a
	jr nz, jr_002_766a

	ld a, [$c16a]
	cp $05
	jr nz, jr_002_766a

	ld hl, $716c
	add hl, bc
	ldh a, [$ff9e]
	cp [hl]
	jp nz, Jump_002_770f

	ld a, [$c1c3]
	inc a
	ld [$c1c3], a
	cp $0c
	jp c, Jump_002_770f

	xor a
	ld [$c1c3], a
	xor a
	ld [$c121], a
	ld [$c122], a
	ld a, $0c
	ld [$c16d], a
	jp Jump_002_770f


jr_002_766a:
	ld a, [$c15b]
	and a
	jr nz, jr_002_7675

	ld a, $03
	ld [$c144], a

jr_002_7675:
	ldh a, [$fff7]
	and a
	ldh a, [$ffaf]
	jr z, jr_002_76db

	cp $88
	jr z, jr_002_7689

	cp $4e
	jr z, jr_002_7689

	cp $4f
	jp nz, Jump_002_76db

jr_002_7689:
	ld a, [$c14a]
	and a
	jp z, Jump_002_770f

	ldh a, [$ffdb]
	and $f0
	ldh [$ffce], a
	ldh a, [$ffdc]
	and $f0
	ldh [$ffcd], a
	ldh a, [$ffe9]
	ld e, a
	ld d, $00
	call Call_20A6
	ld a, $05
	call Call_3C01
	jr c, jr_002_770f

	ld hl, $c200
	add hl, de
	ldh a, [$ffe9]
	swap a
	and $f0
	add $08
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffe9]
	and $f0
	add $10
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ld [hl], d
	ld hl, $fff4
	ld [hl], $09
	ld hl, $c2f0
	add hl, de
	ld [hl], $0f
	ld hl, $c340
	add hl, de
	ld [hl], $c4
	jr jr_002_771c

Jump_002_76db:
jr_002_76db:
	ld e, $20
	cp $c5
	jr nz, jr_002_76e9

	ld a, [$dba5]
	and a
	jr z, jr_002_76f9

	jr jr_002_770f

jr_002_76e9:
	ld a, [$dba5]
	and a
	jr z, jr_002_770f

	ldh a, [$ffaf]
	cp $de
	jr z, jr_002_76fb

	cp $a7
	jr nz, jr_002_770f

jr_002_76f9:
	ld e, $40

jr_002_76fb:
	ld a, [$c191]
	inc a
	ld [$c191], a
	cp e
	jr c, jr_002_770f

	ld a, e
	ldh [$ffe8], a
	xor a
	ld [$c191], a
	call Call_02_51EB

Jump_002_770f:
jr_002_770f:
	ld hl, $7164
	add hl, bc
	ld a, [$c133]
	or [hl]
	ld [$c133], a
	scf
	ret


Jump_002_771c:
jr_002_771c:
	xor a
	ld [$c191], a
	scf
	ccf
	ret


Call_02_7723::
	ldh a, [$ffaf]
	cp $b1
	jr z, jr_002_772d

	cp $b2
	jr nz, jr_002_774f

jr_002_772d:
	ldh a, [$ffdc]
	and $0f
	cp $06
	jr nc, jr_002_7768

	ld a, $0c
	ldh [$fff2], a
	ld a, $05
	ld [$c11c], a
	call Call_1495
	ld [$dbc7], a
	ld [$c198], a
	ldh [$ffa2], a
	ldh [$ffa3], a
	call Call_093B
	ret


jr_002_774f:
	cp $c1
	jr z, jr_002_775f

	cp $c2
	jr z, jr_002_775f

	cp $bb
	jr z, jr_002_775f

	cp $bc
	jr nz, jr_002_7768

jr_002_775f:
	ldh a, [$ffdc]
	and $0f
	cp $0c
	jp nc, Call_0909

jr_002_7768:
	ret


Call_02_7769::
	ld a, [$c14a]
	and a
	jr z, jr_002_77bd

	ld a, [$dbaf]
	cp $02
	jr nz, jr_002_77bd

	ld a, [$c133]
	and $03
	cp $03
	jr z, jr_002_7788

	ld a, [$c133]
	and $0c
	cp $0c
	jr nz, jr_002_77bd

jr_002_7788:
	call Call_093B
	ldh a, [$ff9a]
	cpl
	inc a
	sra a
	sra a
	ldh [$ff9a], a
	ldh a, [$ff9b]
	cpl
	inc a
	sra a
	sra a
	ldh [$ff9b], a
	ld a, $18
	ldh [$ffa3], a
	ld a, $02
	ld [$c146], a
	ld a, $20
	ld [$c157], a
	ldh a, [$ff9e]
	and $02
	sla a
	ld [$c158], a
	ld a, $0b
	ldh [$fff2], a
	call Call_1594

jr_002_77bd:
	ret


Call_02_77BE::
	call Call_2197
	jp Call_1495


Call_02_77C4::
	call Call_218E
	jp Call_1495


	db $08, $f8, $00, $00, $00, $00, $f8, $08

Call_02_77D2::
	ldh a, [$ff98]
	and $f0
	ldh [$ffd7], a
	swap a
	ld e, a
	ldh a, [$ff99]
	sub $04
	and $f0
	ldh [$ffd8], a
	or e
	ld e, a
	ldh [$fffa], a
	ld d, $00
	ld hl, $d711
	ld a, h
	add hl, de
	ld h, a
	ld a, [$dba5]
	ld d, a
	ld a, [hl]
	ldh [$ffb8], a
	ldh [$ffaf], a
	ld e, a
	ret


Jump_002_77fa:
	ld a, [$c11c]
	cp $01
	jr nz, jr_002_7809

	ld a, [$c13b]
	add $04
	ld [$c13b], a

jr_002_7809:
	ld a, [$c1a4]
	and a
	jr z, jr_002_7847

	ld hl, $c146
	ld a, [$c14a]
	or [hl]
	jr nz, Call_02_781B

	call Call_1495

Call_02_781B::
	call Call_02_77D2
	ld c, $04
	ld a, [$d463]
	cp $01
	jr z, jr_002_7842

	ld c, $fc
	ld a, [$d6f9]
	and a
	jr nz, jr_002_7842

	call Call_29DB
	ld c, $02
	cp $05
	jr z, jr_002_7842

	cp $09
	jr z, jr_002_7842

	cp $08
	jr nz, jr_002_7846

	ld c, $fd

jr_002_7842:
	ld a, c
	ld [$c13b], a

jr_002_7846:
	ret


jr_002_7847:
	ldh a, [$fffa]
	ldh [$fffb], a
	ld a, [$c17b]
	and a
	ret nz

	ldh a, [$ffa2]
	and a
	jr z, jr_002_7872

	ldh a, [$ffe7]
	and $01
	jr nz, jr_002_7871

	ld hl, $c000
	ldh a, [$ff99]
	add $0b
	cp $88
	jr nc, jr_002_7871

	ld [hli], a
	ldh a, [$ff98]
	add $04
	ld [hli], a
	ld a, $26
	ld [hli], a
	ld [hl], $00

jr_002_7871:
	ret


jr_002_7872:
	xor a
	ld [$d475], a
	ld a, [$c11c]
	cp $02
	jr z, jr_002_7871

Call_02_787D::
	ld a, [$c124]
	ld hl, $c19f
	or [hl]
	jp nz, Jump_002_7980

	call Call_02_77D2
	ld c, a
	ld a, [$dba5]
	and a
	jr nz, jr_002_7899

	ld a, c
	cp $61
	jp z, Jump_002_796a

	jr jr_002_78a7

jr_002_7899:
	ld a, c
	cp $4c
	jr nz, jr_002_78a7

	ldh a, [$ff99]
	dec a
	and $0f
	cp $0c
	jr nc, Call_02_78B5

jr_002_78a7:
	call Call_29DB
	ld [$c181], a
	and a
	jp z, Jump_002_7a5c

	cp $e0
	jr nz, jr_002_78f5

Call_02_78B5::
	ld a, [$dbc7]
	and a
	jr nz, jr_002_78f4

	call Call_093B
	ldh a, [$ff9a]
	cpl
	inc a
	ldh [$ff9a], a
	ldh a, [$ff9b]
	cpl
	inc a
	ldh [$ff9b], a
	ld a, $02
	ld [$c146], a
	ldh a, [$fff9]
	and a
	jr nz, jr_002_78de

	ld a, $10
	ldh [$ffa3], a
	ldh a, [$ffa2]
	add $02
	ldh [$ffa2], a

jr_002_78de:
	ld a, $10
	ld [$c13e], a
	ld a, $30
	ld [$dbc7], a
	ld a, [$db94]
	add $04
	ld [$db94], a
	ld a, $03
	ldh [$fff3], a

jr_002_78f4:
	ret


jr_002_78f5:
	ld a, [$c181]
	cp $ff
	jp z, Jump_002_7a5c

	cp $f0
	jr c, jr_002_7904

	jp Jump_002_7e6e


jr_002_7904:
	cp $51
	jr z, jr_002_790c

	cp $50
	jr nz, jr_002_7980

jr_002_790c:
	call Call_093B
	ld a, $07
	ld [$c11f], a
	ld hl, $c1bb
	inc [hl]
	ld hl, $c17b
	ldh a, [$ffe7]
	and $03
	or [hl]
	jr nz, jr_002_797f

	ldh a, [$ff98]
	sub $08
	ld hl, $ffd7
	sub [hl]
	bit 7, a
	ld a, $ff
	jr z, jr_002_7932

	ld a, $01

jr_002_7932:
	ld hl, $ff98
	add [hl]
	ld [hl], a
	ldh a, [$ffd8]
	add $10
	ld hl, $ff99
	sub [hl]
	bit 7, a
	ld a, $ff
	jr nz, jr_002_7947

	ld a, $01

jr_002_7947:
	ld hl, $ff99
	add [hl]
	ld [hl], a
	ldh a, [$ff98]
	sub $08
	add $02
	and $0f
	cp $04
	jr nc, jr_002_797f

	ldh a, [$ff99]
	sub $10
	add $02
	and $0f
	cp $04
	jr nc, jr_002_797f

	ldh a, [$ff99]
	add $03
	ldh [$ff99], a

Jump_002_796a:
	ld a, $06
	ld [$c11c], a
	call Call_093B
	ld [$c198], a
	ld a, [$c181]
	ld [$dbcb], a
	ld a, $0c
	ldh [$fff3], a

jr_002_797f:
	ret


Jump_002_7980:
jr_002_7980:
	ld hl, $c000
	ld a, [$c181]
	cp $08
	jr nz, jr_002_7995

	ld a, [$c13b]
	add $fd
	ld [$c13b], a
	jp Jump_002_7a5c


jr_002_7995:
	cp $09
	jr nz, jr_002_79a4

	ld a, [$c13b]
	add $02
	ld [$c13b], a
	jp Jump_002_7a5c


jr_002_79a4:
	cp $0b
	jr z, jr_002_79ac

	cp $07
	jr nz, jr_002_7a10

jr_002_79ac:
	ldh a, [$ffb2]
	and a
	jr z, jr_002_79b4

	jp Jump_002_7eaa


jr_002_79b4:
	ld a, [$c1ad]
	cp $80
	jr z, jr_002_7a10

	ld a, [$c11c]
	cp $08
	jr z, jr_002_7a0f

	cp $01
	jr z, jr_002_7a0f

	ldh a, [$ff99]
	add $fe
	call Call_02_571D
	ldh a, [$ffaf]
	cp $06
	jr z, Call_02_79D9

	ld a, [$db0c]
	and a
	jr nz, jr_002_79f2

Call_02_79D9::
	ld a, $50
	ldh [$ffb7], a
	ld a, $08
	ld [$c11c], a
	ldh a, [$ffaf]
	ldh [$ff9c], a
	ldh a, [$ff99]
	add $02
	ldh [$ff99], a
	ld a, $01
	ld [$c167], a
	ret


jr_002_79f2:
	ld a, $01
	ld [$c11c], a
	xor a
	ldh [$ff9c], a
	call Call_1495
	ldh a, [$ff9e]
	ld e, a
	ld d, b
	ld hl, $77ca
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $77ce
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a

jr_002_7a0f:
	ret


jr_002_7a10:
	cp $06
	jp z, Jump_002_7b37

	cp $05
	jr nz, jr_002_7a5c

	ldh a, [$ff99]
	add $0c
	ld [hli], a
	ldh a, [$ff98]
	add $00
	ld [hli], a
	ld a, $1c
	ld [hli], a
	ldh a, [$ffe7]
	rla
	rla
	and $10
	push af
	ld [hli], a
	ldh a, [$ff99]
	add $0c
	ld [hli], a
	ldh a, [$ff98]
	add $08
	ld [hli], a
	ld a, $1c
	ld [hli], a
	pop af
	or $20
	ld [hl], a
	ld a, $03
	ld [$c11f], a
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_002_7a54

	ldh a, [$ffcb]
	and $0f
	jr z, jr_002_7a54

	ld a, $0e
	ldh [$fff2], a

jr_002_7a54:
	ld a, [$c13b]
	add $02
	ld [$c13b], a

Jump_002_7a5c:
jr_002_7a5c:
	xor a
	ld [$c1bb], a
	ld a, [$c11c]
	cp $01
	jr nz, jr_002_7a6c

	ld a, $00
	ld [$c11c], a

jr_002_7a6c:
	ld a, [$c181]
	cp $04
	jr nz, jr_002_7aa3

	ldh a, [$ffaf]
	cp $db
	jr c, jr_002_7aa3

	cp $dd
	jr nc, jr_002_7aa3

	sub $db
	ld e, a
	ld d, $00
	ld hl, $7b35
	add hl, de
	ld a, [$d6fb]
	xor [hl]
	jr z, jr_002_7aa3

	ld a, [$d6f8]
	ld e, a
	ld d, $00
	ld hl, $7b29
	add hl, de
	ld a, [$c13b]
	add [hl]
	ld [$c13b], a
	ld a, $01
	ld [$d6f9], a
	ret


jr_002_7aa3:
	ld a, [$d6f9]
	and a
	jr z, jr_002_7ab1

	ld a, $07
	ldh [$fff4], a
	xor a
	ld [$d6f9], a

jr_002_7ab1:
	ld a, [$dba5]
	and a
	jp z, Jump_002_7b28

	ld a, [$c124]
	and a
	jr nz, jr_002_7b28

	ldh a, [$ffaf]
	cp $aa
	jr nz, jr_002_7af6

	ld a, [$c1cb]
	and a
	jr nz, jr_002_7af6

	ld a, [$c1ca]
	inc a
	ld [$c1ca], a
	cp $18
	jr nz, jr_002_7aed

	ld a, $60
	ld [$c1cb], a
	ld a, $0e
	ldh [$fff3], a
	ld a, $03
	ldh [$ffa5], a
	ldh a, [$fff6]
	cp $c3
	jr nz, jr_002_7aed

	ld hl, $d879
	set 4, [hl]

jr_002_7aed:
	ld a, [$c13b]
	add $fd
	ld [$c13b], a
	ret


jr_002_7af6:
	xor a
	ld [$c1ca], a
	ldh a, [$fffa]
	ld hl, $fffb
	cp [hl]
	ld hl, $c1c9
	jr nz, jr_002_7b26

	ldh a, [$ffaf]
	cp $df
	jr nz, jr_002_7b26

	ldh a, [$ffa1]
	ld e, a
	ld a, [$c1a9]
	ld d, a
	ld a, [$c19f]
	or e
	or d
	jr nz, jr_002_7b26

	inc [hl]
	ld a, [hl]
	cp $28
	jr c, jr_002_7b28

	ld a, $2b
	ldh [$fff4], a
	jp Jump_002_4cac


jr_002_7b26:
	ld [hl], $00

Jump_002_7b28:
jr_002_7b28:
	ret


	db $fc, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fc, $fc, $fc, $00, $02

Jump_002_7b37:
	ldh a, [$ff99]
	add $08
	ld [hli], a
	ldh a, [$ff98]
	add $ff
	ld [hli], a
	ld a, $1a
	ld [hli], a
	ld a, [$c120]
	rla
	rla
	and $20
	push af
	ld [hli], a
	ldh a, [$ff99]
	add $08
	ld [hli], a
	ldh a, [$ff98]
	add $07
	ld [hli], a
	ld a, $1a
	ld [hli], a
	pop af
	xor $20
	ld [hl], a
	ld a, $03
	ld [$c11f], a
	ret


	db $c6, $3a, $00, $00, $00, $00, $3a, $c6, $04, $fc, $00, $00, $00, $00, $fc, $04

Call_02_7B74::
	ld a, [$c124]
	cp $00
	jp z, Jump_002_7c5d

	push af
	cp $03
	jp c, Jump_002_7c50

	ld a, [$c125]
	ld c, a
	ld b, $00
	ld hl, $7b64
	add hl, bc
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $7b68
	add hl, bc
	ld a, [hl]
	ldh [$ff9b], a
	push bc
	call Call_20D6
	pop bc
	ld hl, $7b6c
	add hl, bc
	ldh a, [$ff96]
	add [hl]
	ldh [$ff96], a
	ld hl, $7b70
	add hl, bc
	ldh a, [$ff97]
	add [hl]
	ldh [$ff97], a
	ld hl, $c12d
	cp [hl]
	jp nz, Jump_002_7c50

	ldh a, [$ff96]
	ld hl, $c12c
	cp [hl]
	jp nz, Jump_002_7c50

	pop af
	ldh a, [$ffb1]
	and a
	jr z, jr_002_7bc9

	call Call_27A8
	xor a
	ldh [$ffb1], a

jr_002_7bc9:
	call Call_1495
	ldh [$ffa3], a
	ld [$c124], a
	ldh a, [$ff98]
	ld [$dbb1], a
	ldh a, [$ff99]
	ld [$dbb2], a
	ld a, [$c125]
	cp $03
	jr nz, jr_002_7c06

	ld a, $01
	ldh [$ff9b], a
	call Call_02_7180
	ldh a, [$ffaf]
	cp $db
	jr z, jr_002_7c06

	cp $dc
	jr z, jr_002_7c06

	cp $e1
	jr z, jr_002_7bfd

	ld a, [$c133]
	and a
	jr z, jr_002_7c06

jr_002_7bfd:
	ld a, [$c17b]
	and a
	jr nz, jr_002_7c06

	call Call_02_71EA

jr_002_7c06:
	ld a, [$c169]
	and a
	jr z, jr_002_7c12

	ldh [$fff2], a
	xor a
	ld [$c169], a

jr_002_7c12:
	call Call_3819
	ld a, $ff
	ldh [$ffa6], a
	ld a, [$dba5]
	and a
	ret z

	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_002_7c2a

	cp $06
	jr c, jr_002_7c2a

	inc d

jr_002_7c2a:
	ldh a, [$fff6]
	ld e, a
	call Call_29B8
	cp $1a
	jr z, jr_002_7c40

	cp $19
	jr z, jr_002_7c40

	ld a, [$c18e]
	and $e0
	cp $80
	ret nz

jr_002_7c40:
	ld a, [$dbcd]
	and a
	ret z

	ldh a, [$fff8]
	and $10
	ret nz

	ld a, $0c
	ld [$d462], a
	ret


Jump_002_7c50:
	pop af
	dec a
	rst $00

JumpTable_02_7C53::
	dw Jump_02_7C7E
	dw Jump_02_7DA1
	dw Jump_02_7DE2
	dw Jump_02_7E59
	dw Jump_02_7E5D

Jump_002_7c5d:
	ret


	db $01, $01, $02, $00, $00, $02, $01, $02, $00, $02, $02, $00, $02, $02, $00, $02
	db $01, $02, $00, $02, $01, $02, $00, $02, $00, $00, $00, $00, $02, $02, $02, $02

Jump_02_7C7E::
	ld a, [$c125]
	ld c, a
	ld b, $00
	ld a, [$dba5]
	and a
	jr z, jr_002_7ced

	ldh a, [$fff7]
	cp $0b
	jr nc, jr_002_7ced

	cp $08
	jr nz, jr_002_7cc8

	ldh a, [$fff6]
	cp $71
	jr nz, jr_002_7cc8

	ld a, c
	cp $03
	jr z, jr_002_7cc8

	ld a, [$db7c]
	ld e, a
	ld d, $00
	ld hl, $7c5e
	add hl, de
	ld a, [$c5aa]
	ld e, a
	inc a
	ld [$c5aa], a
	add hl, de
	ld a, c
	cp [hl]
	jr z, jr_002_7cbd

	xor a
	ld [$c5aa], a
	jp Jump_002_7d25


jr_002_7cbd:
	ld a, e
	cp $07
	jp nz, Jump_002_7d25

	ld a, $02
	ld [$c169], a

jr_002_7cc8:
	xor a
	ld [$c5aa], a
	ld hl, $7dde
	add hl, bc
	ld a, c
	cp $02
	jr nz, jr_002_7ce7

	ldh a, [$fff7]
	cp $05
	jr nz, jr_002_7ce7

	ld a, [$dbae]
	cp $1d
	jr nz, jr_002_7ce7

	ld a, $35
	ld [$dbae], a

jr_002_7ce7:
	ld a, [hl]
	ld hl, $dbae
	jr jr_002_7d0c

jr_002_7ced:
	ld a, [$c10c]
	and a
	jr z, jr_002_7d04

	ld a, c
	cp $02
	jr nz, jr_002_7d04

	ld a, $1e
	ld [$c169], a
	ld a, $63
	ld hl, $fff6
	jr jr_002_7d0d

jr_002_7d04:
	ld hl, $7dda
	add hl, bc
	ld a, [hl]
	ld hl, $fff6

jr_002_7d0c:
	add [hl]

jr_002_7d0d:
	ld [hl], a
	cp $41
	jr nz, jr_002_7d25

	ld a, c
	cp $02
	jr nz, jr_002_7d25

	ld hl, $d841
	bit 6, [hl]
	jr nz, jr_002_7d25

	set 6, [hl]
	ld a, $02
	ld [$c169], a

Jump_002_7d25:
jr_002_7d25:
	call Call_2ED7
	call Call_36E6
	call Call_1CCC
	call Call_149B
	ld a, [$c1cf]
	and a
	jr z, jr_002_7d4c

	xor a
	ld [$c1cf], a
	ld a, [$d47c]
	and a
	ldh a, [$ffb0]
	jr z, jr_002_7d45

	ld a, $49

jr_002_7d45:
	ldh [$ffb1], a
	call Call_27CA
	jr jr_002_7d99

jr_002_7d4c:
	ld a, [$dba5]
	and a
	jr nz, jr_002_7d99

	ld a, [$db4e]
	and a
	jr z, jr_002_7d99

	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $4000
	add hl, de
	ld a, [hl]
	ld hl, $ffb0
	cp [hl]
	jr z, jr_002_7d99

	ld c, a
	cp $25
	jr nc, jr_002_7d77

	ld b, $00
	ld hl, $4120
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_002_7d8d

jr_002_7d77:
	ld a, [$d47c]
	and a
	jr z, Call_02_7D90

	ldh a, [$ffbd]
	cp $49
	jr z, jr_002_7d96

	call Call_02_7D90
	ld a, $49
	ldh [$ffb1], a
	ldh [$ffbd], a
	ret


jr_002_7d8d:
	ld a, c
	ldh [$ffbd], a

Call_02_7D90::
	ld a, c
	ldh [$ffb1], a
	call Call_27CA

jr_002_7d96:
	ld a, c
	ldh [$ffb0], a

Jump_002_7d99:
jr_002_7d99:
	ld a, [$c124]
	inc a
	ld [$c124], a
	ret


Jump_02_7DA1::
	call Call_09AA
	ld a, [$d6fa]
	cp $02
	jr nz, jr_002_7daf

	ld a, $02
	ldh [$ffbb], a

jr_002_7daf:
	jp Jump_002_7d99


	db $00, $00, $02, $02, $14, $0c, $00, $00, $00, $00, $03, $02, $14, $1e, $c0, $00
	db $08, $08, $0a, $0a, $0a, $0a, $08, $08, $00, $09, $70, $00, $40, $40, $02, $02
	db $a0, $60, $00, $00, $00, $00, $80, $80, $01, $ff, $f0, $10, $01, $ff, $f8, $08

Jump_02_7DE2::
	ld a, [$c125]
	ld c, a
	ld b, $00
	ld hl, $7dd2
	add hl, bc
	ld a, [$c12c]
	add [hl]
	ld [$c12c], a
	ld hl, $7dd6
	add hl, bc
	ld a, [$c12d]
	add [hl]
	ld [$c12d], a
	ld hl, $7dbe
	add hl, bc
	ld a, [$c12f]
	add [hl]
	rl d
	and $df
	ld [$c127], a
	ld hl, $7dba
	add hl, bc
	ld a, [$c12e]
	rr d
	adc [hl]
	and $03
	ld [$c126], a
	ld hl, $7db6
	add hl, bc
	ld a, [$c12f]
	add [hl]
	rl d
	and $df
	ld [$c12f], a
	ld hl, $7db2
	add hl, bc
	ld a, [$c12e]
	rr d
	adc [hl]
	and $03
	ld [$c12e], a
	ld hl, $7dc2
	add hl, bc
	ld a, [hl]
	ld [$c128], a
	ld hl, $7dc6
	add hl, bc
	ld a, [hl]
	ld [$c129], a
	ld hl, $7dca
	add hl, bc
	ld a, [hl]
	ld [$c12a], a
	xor a
	ld [$c12b], a
	jp Jump_002_7d99


Jump_02_7E59::
	call Call_267A
	ret


Jump_02_7E5D::
	ret


	db $00, $00, $ff, $01, $01, $ff, $01, $ff, $01, $ff, $00, $00, $01, $01, $ff, $ff

Jump_002_7e6e:
	ldh a, [$ffe7]
	and $03
	ld hl, $c167
	or [hl]
	ld hl, $ffa1
	or [hl]
	ld hl, $c1a9
	or [hl]
	ret nz

	ld a, [$c181]
	sub $f0
	ld e, a
	ld d, $00
	ld hl, $7e5e
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ff98], a
	ld hl, $7e66
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ldh [$ff99], a
	ret


	db $fc, $fa, $f8, $f6, $0c, $00, $00, $f4, $00, $00, $00, $00, $00, $f4, $0c, $00

Jump_002_7eaa:
	ldh a, [$ffe7]
	and $00
	ld hl, $c124
	or [hl]
	ld hl, $c1a9
	or [hl]
	ld hl, $ffa1
	or [hl]
	ld hl, $c19f
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_002_7efd

	ld e, $01
	ldh a, [$ffaf]
	cp $0e
	jr nz, jr_002_7ee4

	ldh a, [$fff6]
	cp $3e
	jr z, jr_002_7ee7

	inc e
	cp $3d
	jr z, jr_002_7ee7

	inc e
	cp $3c
	jr z, jr_002_7ee7

	cp $3f
	jr nz, jr_002_7efd

	ld e, $00
	jr jr_002_7ee7

jr_002_7ee4:
	sub $e7
	ld e, a

jr_002_7ee7:
	ld d, $00
	ld hl, $7e9a
	add hl, de
	ld a, [hl]
	ldh [$ff9a], a
	ld hl, $7ea2
	add hl, de
	ld a, [hl]
	ldh [$ff9b], a
	call Call_20D6
	call Call_02_7180

jr_002_7efd:
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
	db $ff, $ff
