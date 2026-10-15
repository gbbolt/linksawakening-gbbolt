; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $018", ROMX[$4000], BANK[$18]

Call_18_4000::
	ld a, [$c116]
	and a
	jr nz, jr_018_400f

	inc a
	ld [$c116], a
	ld a, $14
	ld [$d6ff], a

jr_018_400f:
	ldh a, [$ffee]
	cp $48
	jp nz, Jump_018_4378

	call Call_18_435E
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_401F::
	dw Jump_18_402D

	db $98, $40, $d9, $40, $ce, $41, $55, $42, $6e, $42, $a9, $42

Jump_18_402D::
	xor a
	ld [$d201], a
	ld a, [$db49]
	and $01
	jr z, jr_018_404a

	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $28
	cp $50
	call Call_18_7D19
	jr nc, jr_018_407c

	jp Jump_018_42b6


jr_018_404a:
	ldh a, [$ff99]
	cp $4c
	jr nc, jr_018_407c

	ld a, $4c
	ldh [$ff99], a
	call Call_1495
	call Call_093B
	ld e, $0b
	ld hl, $db00

jr_018_405f:
	ld a, [hli]
	cp $09
	jr z, jr_018_4074

	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_405f

	ld a, $db
	call Call_18_4088
	call Call_3B8D
	ld [hl], b
	ret


jr_018_4074:
	ld a, $dc
	call Call_18_4088
	call Call_3B8D

Jump_018_407c:
jr_018_407c:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Call_18_4088::
	ld e, a
	ldh a, [$ff99]
	push af
	ld a, $10
	ldh [$ff99], a
	ld a, e
	call Call_2197
	pop af
	ldh [$ff99], a
	ret


	db $cd, $7c, $40, $fa, $9f, $c1, $a7, $20, $37, $cd, $8d, $3b, $fa, $77, $c1, $a7
	db $28, $07, $70, $3e, $de, $cd, $88, $40, $c9, $fa, $5d, $db, $fe, $03, $38, $f2
	db $fa, $92, $db, $c6, $2c, $ea, $92, $db, $fa, $91, $db, $ce, $01, $ea, $91, $db
	db $cd, $91, $08, $36, $ff, $cd, $d2, $27, $cd, $c1, $45, $3e, $01, $ea, $00, $c5
	db $c9, $3e, $02, $e0, $a1, $ea, $67, $c1, $cd, $91, $08, $20, $0d, $3e, $35, $ea
	db $68, $d3, $3e, $01, $ea, $15, $d2, $c3, $8d, $3b, $c9, $3e, $30, $e0, $cd, $3e
	db $18, $e0, $ce, $c3, $b5, $44, $3e, $30, $e0, $cd, $3e, $68, $e0, $ce, $c3, $b5
	db $44, $3e, $38, $e0, $ce, $3e, $08, $e0, $cd, $c3, $09, $44, $3e, $38, $e0, $ce
	db $3e, $08, $e0, $cd, $c3, $5e, $44, $c9, $03, $03, $03, $03, $03, $03, $03, $01
	db $02, $04, $03, $01, $02, $04, $03, $01, $02, $04, $03, $01, $02, $04, $03, $01
	db $02, $04, $03, $03, $03, $03, $03, $04, $03, $01, $02, $04, $03, $01, $02, $04
	db $03, $01, $02, $04, $03, $01, $02, $04, $03, $01, $02, $02, $02, $02, $02, $02
	db $02, $02, $01, $01, $05, $05, $05, $05, $05, $05, $01, $01, $04, $01, $05, $01
	db $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $05
	db $05, $05, $01, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01
	db $05, $01, $04, $01, $05, $01, $04, $04, $04, $04, $04, $04, $01, $01, $01, $01
	db $05, $05, $05, $05, $01, $01, $01, $01, $04, $01, $05, $01, $04, $01, $05, $01
	db $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $05, $01, $01, $01, $01
	db $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01, $05, $01, $04, $01
	db $05, $01, $04, $04, $04, $04, $3e, $02, $e0, $a1, $ea, $67, $c1, $fa, $11, $d2
	db $a7, $20, $20, $fa, $10, $d2, $fe, $00, $cc, $09, $41, $fa, $10, $d2, $fe, $01
	db $cc, $14, $41, $fa, $10, $d2, $fe, $38, $cc, $f3, $40, $fa, $10, $d2, $fe, $70
	db $cc, $fe, $40, $fa, $10, $d2, $c6, $01, $ea, $10, $d2, $5f, $fa, $11, $d2, $ce
	db $00, $ea, $11, $d2, $57, $fe, $06, $20, $12, $7b, $fe, $20, $20, $0d, $3e, $dd
	db $cd, $88, $40, $af, $ea, $00, $c5, $cd, $8d, $3b, $c9, $fa, $12, $d2, $3c, $fe
	db $1c, $20, $08, $fa, $13, $d2, $3c, $ea, $13, $d2, $af, $ea, $12, $d2, $fa, $13
	db $d2, $5f, $50, $21, $20, $41, $19, $7e, $cd, $87, $3b, $21, $5a, $41, $19, $7e
	db $ea, $b1, $c3, $21, $94, $41, $19, $7e, $ea, $b2, $c3, $c9, $c9, $fa, $9f, $c1
	db $a7, $20, $10, $ea, $15, $d2, $cd, $91, $08, $36, $70, $3e, $10, $ea, $68, $d3
	db $cd, $8d, $3b, $c3, $7c, $40, $cd, $91, $08, $20, $0e, $3e, $02, $ea, $4a, $db
	db $21, $49, $db, $cb, $c6, $cd, $8d, $3b, $c9, $fe, $08, $20, $06, $35, $3e, $df
	db $cd, $88, $40, $3e, $6c, $e0, $9d, $3e, $02, $e0, $a1, $f0, $98, $e0, $ee, $f0
	db $99, $d6, $0c, $e0, $ec, $11, $6c, $47, $af, $e0, $f1, $cd, $d0, $3c, $c3, $7c
	db $40, $fa, $9f, $c1, $a7, $20, $0c, $ea, $67, $c1, $cd, $8d, $3b, $70

Jump_018_42b6:
	ld a, $e0
	call Call_18_4088
	jp Jump_018_407c


	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $70, $00, $00, $08, $72, $00, $00, $10, $74, $00, $00, $18, $76, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $78, $00, $00, $08, $7a, $00, $00, $10, $7c, $00, $00, $18, $7e, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $7e, $20, $00, $08, $7c, $20, $00, $10, $7a, $20, $00, $18, $78, $20
	db $10, $00, $6e, $20, $10, $08, $6c, $20, $10, $10, $6a, $20, $10, $18, $68, $20
	db $00, $00, $76, $20, $00, $08, $74, $20, $00, $10, $72, $20, $00, $18, $70, $20
	db $10, $00, $6e, $20, $10, $08, $6c, $20, $10, $10, $6a, $20, $10, $18, $68, $20

Call_18_435E::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $42be
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


Jump_018_4378:
	ld hl, $c210
	add hl, bc
	ld [hl], $4a
	ld hl, $c350
	add hl, bc
	ld [hl], $98
	call Call_3B65
	call Call_18_43E9
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_4390::
	dw Jump_18_4394
	dw Jump_18_439F

Jump_18_4394::
	call Call_27ED
	ld hl, $c3d0
	add hl, bc
	ld [hl], a
	call Call_3B8D

Jump_18_439F::
	ld a, [$d215]
	and a
	jp nz, Jump_018_43b8

	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	ld e, $00
	and $30
	jr z, jr_018_43b3

	inc e

jr_018_43b3:
	ld a, e
	call Call_3B87
	ret


Jump_018_43b8:
	ret


	db $58, $00, $58, $20, $5a, $00, $5a, $20, $5c, $00, $5e, $00, $5e, $20, $5c, $20
	db $f0, $00, $50, $00, $f0, $08, $52, $00, $00, $00, $54, $00, $00, $08, $56, $00
	db $f0, $00, $52, $20, $f0, $08, $50, $20, $00, $00, $56, $20, $00, $08, $54, $20

Call_18_43E9::
	ldh a, [$fff1]
	cp $04
	jr nc, jr_018_43f5

	ld de, $43b9
	jp Call_3C3B


jr_018_43f5:
	sub $04
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $43c9
	add hl, de
	ld c, $04
	call Call_3D26
	ret


	db $cd, $39, $28, $3e, $1b, $ea, $00, $d6, $21, $01, $d6, $f0, $cf, $c6, $02, $5f
	db $22, $f0, $d0, $22, $3e, $85, $22, $3e, $00, $22, $3e, $04, $22, $3e, $7f, $22
	db $3e, $7f, $22, $3e, $06, $22, $3e, $0c, $22, $7b, $22, $f0, $d0, $c6, $01, $22
	db $3e, $85, $22, $3e, $01, $22, $3e, $7f, $22, $3e, $7f, $22, $3e, $7f, $22, $3e
	db $7f, $22, $3e, $0d, $22, $7b, $22, $f0, $d0, $c6, $02, $22, $3e, $c5, $22, $3e
	db $7f, $22, $36, $00, $c9, $cd, $39, $28, $3e, $1b, $ea, $00, $d6, $21, $01, $d6
	db $f0, $cf, $c6, $02, $5f, $22, $f0, $d0, $c6, $03, $22, $3e, $c5, $22, $3e, $7f
	db $22, $7b, $22, $f0, $d0, $c6, $04, $22, $3e, $85, $22, $3e, $02, $22, $3e, $7f
	db $22, $3e, $7f, $22, $3e, $7f, $22, $3e, $7f, $22, $3e, $0e, $22, $7b, $22, $f0
	db $d0, $c6, $05, $22, $3e, $85, $22, $3e, $03, $22, $3e, $05, $22, $3e, $7f, $22
	db $3e, $7f, $22, $3e, $07, $22, $3e, $0f, $22, $36, $00, $c9, $cd, $39, $28, $3e
	db $15, $ea, $00, $d6, $21, $01, $d6, $f0, $cf, $c6, $02, $5f, $22, $f0, $d0, $22
	db $3e, $83, $22, $3e, $00, $22, $3e, $04, $22, $3e, $06, $22, $3e, $0c, $22, $7b
	db $22, $f0, $d0, $c6, $01, $22, $3e, $83, $22, $3e, $01, $22, $3e, $7f, $22, $3e
	db $7f, $22, $3e, $0d, $22, $7b, $22, $f0, $d0, $c6, $02, $22, $3e, $83, $22, $3e
	db $02, $22, $3e, $7f, $22, $3e, $7f, $22, $3e, $0e, $22, $7b, $22, $f0, $d0, $c6
	db $03, $22, $3e, $83, $22, $3e, $03, $22, $3e, $05, $22, $3e, $07, $22, $3e, $0f
	db $22, $36, $00, $c9

Call_18_451D::
	ldh a, [$ffec]
	cp $50
	jp nc, Jump_018_48e5

	ld hl, $c210
	add hl, bc
	ld [hl], $3e
	ld a, [$d214]
	and a
	jr z, jr_018_4534

	dec a
	ld [$d214], a

jr_018_4534:
	ld a, [$d218]
	and a
	jr z, jr_018_453e

	dec a
	ld [$d218], a

jr_018_453e:
	call Call_18_484F
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_4547::
	dw Jump_18_4553
	dw Jump_18_4585
	dw Jump_18_45B3
	dw Jump_18_46C2
	dw Jump_18_4755
	dw Jump_18_476E

Jump_18_4553::
	ld a, [$db49]
	and $02
	jr z, jr_018_4565

	call Call_18_7CF5
	jr nc, Call_18_457A

	ld a, $89
	call Call_2185
	ret


jr_018_4565:
	ldh a, [$ff98]
	cp $30
	jr c, Call_18_457A

	ld a, $2f
	ldh [$ff98], a
	call Call_1495
	ld a, $85
	call Call_2185
	call Call_3B8D

Call_18_457A::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_18_4585::
	ld a, [$c19f]
	and a
	jr nz, jr_018_45aa

	ld a, [$c177]
	and a
	jr nz, jr_018_45a1

	ld e, $0b
	ld hl, $db00

jr_018_4596:
	ld a, [hli]
	cp $09
	jr z, jr_018_45ab

	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_4596

jr_018_45a1:
	call Call_3B8D
	ld [hl], b
	ld a, $8a
	call Call_2185

jr_018_45aa:
	ret


jr_018_45ab:
	call Call_3B8D
	ld a, $87
	jp Call_2185


Jump_18_45B3::
	ld a, [$c19f]
	and a
	jr nz, jr_018_45d7

	ld a, $30
	ld [$d368], a
	call Call_3B8D
	xor a
	ld [$d210], a
	ld [$d211], a
	ld [$d212], a
	ld [$d213], a
	ld [$d217], a
	ld [$d214], a
	ld [$d218], a

jr_018_45d7:
	ret


	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $02, $03, $04, $00, $00, $00, $00, $00, $00, $02, $01
	db $02, $01, $02, $01, $02, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00, $01
	db $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $02, $02, $02, $02, $02, $02, $02, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $02, $03, $02, $03, $02, $03, $02, $03
	db $02, $03, $02, $02, $03, $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06
	db $05, $06, $05, $06, $05, $06, $04, $02, $03, $02, $03, $02, $03, $02, $03, $02
	db $03, $02, $03, $02, $04, $05, $04, $05, $03, $02, $03, $02, $03, $02, $03, $02
	db $01, $01, $01, $01, $01, $01, $00, $00, $00, $00

Jump_18_46C2::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, [$d210]
	add $01
	ld [$d210], a
	ld a, [$d211]
	adc $00
	ld [$d211], a
	ld a, [$d211]
	cp $05
	jr nz, jr_018_46f0

	ld a, [$d210]
	cp $f0
	jr nz, jr_018_46f0

	call Call_3B8D
	call Call_0891
	ld [hl], $20
	ret


jr_018_46f0:
	ld a, [$d212]
	inc a
	cp $14
	jr nz, jr_018_4700

	ld a, [$d213]
	inc a
	ld [$d213], a
	xor a

jr_018_4700:
	ld [$d212], a
	ld a, [$d213]
	ld e, a
	ld d, b
	ld hl, $4626
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $45d8
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld hl, $4674
	add hl, de
	ld a, [hl]
	ld [$d215], a
	ld a, [$d211]
	ld d, a
	ld a, [$d210]
	ld e, a
	cp $cc
	jr nz, jr_018_4733

	ld a, d
	cp $00
	jr z, jr_018_4743

jr_018_4733:
	ld a, e
	cp $be
	jr nz, jr_018_473d

	ld a, d
	cp $05
	jr z, jr_018_473e

jr_018_473d:
	ret


jr_018_473e:
	ld a, $28
	ld [$d214], a

jr_018_4743:
	call Call_088C
	ld [hl], $28
	ret


	db $00, $00, $40, $00, $00, $08, $42, $00, $00, $10, $44, $00

Jump_18_4755::
	call Call_0891
	jr nz, jr_018_4764

	ld [hl], $70
	ld a, $10
	ld [$d368], a
	call Call_3B8D

jr_018_4764:
	ld a, $02
	ldh [$ffa1], a
	call Call_18_457A
	ret


	db $90, $10

Jump_18_476E::
	call Call_18_457A
	call Call_0891
	jr nz, jr_018_4785

	ld a, $01
	ld [$db4a], a
	ld hl, $db49
	set 1, [hl]
	call Call_3B8D
	ld [hl], b
	ret


jr_018_4785:
	cp $08
	jr nz, jr_018_478f

	dec [hl]
	ld a, $88
	call Call_2185

jr_018_478f:
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ldh a, [$ff98]
	ldh [$ffee], a
	ldh a, [$ff99]
	sub $0c
	ldh [$ffec], a
	ld de, $476c
	xor a
	ldh [$fff1], a
	call Call_3CD0
	ret


	db $00, $00, $50, $00, $00, $08, $52, $00, $10, $00, $54, $00, $10, $08, $56, $00
	db $f8, $10, $58, $00, $08, $10, $5a, $00, $18, $10, $5c, $00, $00, $18, $5e, $00
	db $10, $18, $5e, $40, $00, $00, $50, $00, $00, $08, $52, $00, $10, $00, $4a, $00
	db $10, $08, $4c, $00, $f8, $10, $58, $00, $08, $10, $4e, $00, $18, $10, $5c, $00
	db $00, $18, $5e, $00, $10, $18, $5e, $40, $00, $00, $50, $00, $00, $08, $52, $00
	db $10, $00, $54, $00, $10, $08, $56, $00, $f8, $10, $60, $00, $08, $10, $5a, $00
	db $18, $10, $62, $00, $00, $18, $5e, $00, $10, $18, $5e, $40, $00, $00, $46, $00
	db $00, $08, $48, $00, $10, $00, $4a, $00, $10, $08, $4c, $00, $f8, $10, $60, $00
	db $08, $10, $4e, $00, $18, $10, $62, $00, $00, $18, $5e, $00, $10, $18, $5e, $40
	db $ff, $ff, $ff, $ff, $64, $00, $66, $00, $64, $40, $66, $40, $66, $60, $64, $60
	db $66, $20, $64, $20

Call_18_484F::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ldh a, [$ffec]
	add $03
	ldh [$ffec], a
	ld de, $483b
	call Call_3C3B
	ld a, $02
	call Call_3DD0
	call Call_3DBA
	call Call_088C
	jr z, jr_018_4873

	ld a, $03
	jr jr_018_4878

jr_018_4873:
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]

jr_018_4878:
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $47ab
	add hl, de
	ld c, $09
	call Call_3D26
	ld a, $09
	call Call_3DD0
	call Call_088C
	ret z

	ldh a, [$ffee]
	sub $18
	ldh [$ffee], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	ld hl, $4749
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	ret


	db $00, $fc, $76, $00, $00, $04, $78, $00, $00, $0c, $7a, $00, $00, $fc, $7c, $00
	db $00, $04, $78, $00, $00, $0c, $7e, $00, $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $70, $00, $70, $20, $6a, $20, $68, $20, $6e, $20, $6c, $20, $72, $00, $74, $00
	db $74, $20, $72, $20

Jump_018_48e5:
	call Call_18_48FD
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld a, [$d215]
	and a
	jr z, jr_018_48fc

	call Call_3B87

jr_018_48fc:
	ret


Call_18_48FD::
	ld a, [$d214]
	and a
	jr z, jr_018_4923

	ldh a, [$ffee]
	sub $18
	ldh [$ffee], a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	ld hl, $4749
	ld c, $03
	call Call_3D26
	ld a, $03
	call Call_3DD0
	call Call_3DBA
	ld a, $07
	ldh [$fff1], a

jr_018_4923:
	ldh a, [$fff1]
	cp $02
	jr nc, jr_018_493c

	ld hl, $48b1
	dec a
	jr nz, jr_018_4932

	ld hl, $48bd

jr_018_4932:
	ld c, $03
	call Call_3D26
	ld a, $03
	jp Call_3DD0


jr_018_493c:
	ld de, $48c1
	call Call_3C3B
	ld a, $02
	jp Call_3DD0


	db $f0, $00, $70, $00, $f0, $08, $72, $00, $00, $00, $74, $00, $00, $08, $76, $00

Call_18_4957::
	ld hl, $4947
	ld c, $04
	call Call_3D26
	ldh a, [$fff0]
	rst $00

JumpTable_18_4962::
	dw Jump_18_4968
	dw Jump_18_497A
	dw Jump_18_49B2

Jump_18_4968::
	ldh a, [$fff8]
	and $20
	jr z, jr_018_4976

	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a

jr_018_4976:
	call Call_3B8D
	ret


Jump_18_497A::
	call Call_18_7CAF
	ld a, [$db7f]
	and a
	ret nz

	call Call_18_7D0E
	jr nc, jr_018_49b1

	ld a, [$db0e]
	cp $0d
	jr nz, jr_018_49ac

	ld a, $0e
	ld [$db0e], a
	ld a, $01
	ld [$db7f], a
	ld a, $04
	ldh [$fff4], a
	call Call_0891
	ld [hl], $60
	call Call_18_7F2B
	ld a, $16
	call Call_2185
	jp Call_3B8D


jr_018_49ac:
	ld a, $9c
	call Call_2185

jr_018_49b1:
	ret


Jump_18_49B2::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, jr_018_49cc

	call Call_3B8D
	ld [hl], $01
	ld a, $02
	ldh [$fff2], a
	xor a
	ld [$c167], a
	ret


jr_018_49cc:
	cp $40
	jr nz, jr_018_49d5

	ld hl, $fff4
	ld [hl], $11

jr_018_49d5:
	jr nc, jr_018_49e0

	ld hl, $c240
	add hl, bc
	ld [hl], $fc
	call Call_18_7DDA

jr_018_49e0:
	ret


	db $ff, $ff, $ff, $ff, $54, $00, $54, $60, $54, $40, $54, $20, $56, $00, $56, $20
	db $52, $00, $52, $20

Call_18_49F5::
	ld de, $49e1
	call Call_3C3B
	call Call_18_7D61
	call Call_18_7D83
	ldh a, [$fff0]
	rst $00

JumpTable_18_4A04::
	dw Jump_18_4A0C
	dw Jump_18_4A45
	dw Jump_18_4A50
	dw Jump_18_4A77

Jump_18_4A0C::
	ld hl, $c340
	add hl, bc
	set 6, [hl]
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $635a
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $6352
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_18_646E
	ldh a, [$ffda]
	cp $07
	jr z, jr_018_4a37

	ret


jr_018_4a37:
	call Call_0891
	call Call_27ED
	and $7f
	or $40
	ld [hl], a
	jp Call_3B8D


Jump_18_4A45::
	call Call_0891
	jr nz, jr_018_4a4f

	ld [hl], $60
	call Call_3B8D

jr_018_4a4f:
	ret


Jump_18_4A50::
	call Call_0891
	jr nz, jr_018_4a65

	ld [hl], $60
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	ld hl, $c340
	add hl, bc
	res 6, [hl]
	jp Call_3B8D


jr_018_4a65:
	and $04
	ld a, $01
	jr z, jr_018_4a6c

	inc a

jr_018_4a6c:
	jp Call_3B87


	db $00, $00, $01, $02, $02, $02, $01, $00

Jump_18_4A77::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $4a6f
	add hl, de
	ld a, [hl]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	call Call_3BB4
	call Call_0891
	jr nz, jr_018_4ab2

	call Call_3B8D
	ld [hl], b
	xor a
	call Call_3B87
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


jr_018_4ab2:
	cp $30
	jr nz, jr_018_4ad9

	ld a, $7d
	call Call_3C01
	jr c, jr_018_4ad9

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

jr_018_4ad9:
	call Call_0891
	ld e, $03
	cp $50
	jr nc, jr_018_4ae7

	cp $20
	jr c, jr_018_4ae7

	inc e

jr_018_4ae7:
	ld a, e
	jp Call_3B87


	db $00, $00, $70, $00, $00, $08, $72, $00, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $72, $20, $00, $08, $70, $20, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $78, $20, $00, $08, $76, $20, $10, $00, $74, $00, $10, $08, $74, $20
	db $00, $00, $76, $00, $00, $08, $78, $00, $10, $00, $74, $00, $10, $08, $74, $20
	db $7a, $00, $7c, $00, $7e, $00, $7e, $20

Call_18_4B33::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $4aeb
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_18_7E30
	add $0c
	cp $18
	jr nc, jr_018_4b6f

	call Call_18_7E20
	add $10
	cp $20
	jr nc, jr_018_4b6f

	ld a, e
	add $02
	call Call_3B87

jr_018_4b6f:
	call Call_18_7CAF
	ldh a, [$fff6]
	cp $a8
	jp z, Jump_018_4bf6

	ld de, $4b2b
	ld a, [$db0e]
	cp $09
	jr nc, jr_018_4b86

	ld de, $4b2f

jr_018_4b86:
	xor a
	ldh [$fff1], a
	ldh a, [$ffee]
	add $18
	ldh [$ffee], a
	ldh a, [$ffec]
	add $08
	ldh [$ffec], a
	call Call_3C3B
	call Call_3DBA
	call Call_18_7D61
	ldh a, [$fff0]
	rst $00

JumpTable_18_4BA1::
	dw Jump_18_4BA7
	dw Jump_18_4BC5
	dw Jump_18_4BDF

Jump_18_4BA7::
	call Call_18_7D02
	jr nc, jr_018_4bc4

	ld a, [$db0e]
	cp $08
	jr nz, jr_018_4bbb

	ld a, $67
	call Call_2185
	jp Call_3B8D


jr_018_4bbb:
	ld a, $66
	jr c, jr_018_4bc1

	ld a, $6b

jr_018_4bc1:
	call Call_2185

jr_018_4bc4:
	ret


Jump_18_4BC5::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4bd9

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_018_4bd9

	ld a, $68
	jp Call_2185


jr_018_4bd9:
	ld [hl], b
	ld a, $69
	jp Call_2185


Jump_18_4BDF::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4bf5

	call Call_3B8D
	ld [hl], b
	call Call_0898
	ld a, $09
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a

jr_018_4bf5:
	ret


Jump_018_4bf6:
	call Call_18_7D61
	ldh a, [$fff0]
	rst $00

JumpTable_18_4BFC::
	dw Jump_18_4C08
	dw Jump_18_4C26
	dw Jump_18_4C31
	dw Jump_18_4C44
	dw Jump_18_4C5A
	dw Jump_18_4C7D

Jump_18_4C08::
	call Call_18_7D02
	jr nc, jr_018_4c25

	ld a, [$db0e]
	cp $09
	jr nz, jr_018_4c1c

	ld a, $34
	call Call_2185
	jp Call_3B8D


jr_018_4c1c:
	ld a, $33
	jr c, jr_018_4c22

	ld a, $39

jr_018_4c22:
	call Call_2185

jr_018_4c25:
	ret


Jump_18_4C26::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4c30

	call Call_3B8D
	ret


jr_018_4c30:
	ret


Jump_18_4C31::
	call Call_3B8D
	ld a, $08

Call_18_4C36::
	ld [$db95], a
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$db96], a
	ret


Jump_18_4C44::
	ld a, [$c16b]
	cp $04
	jr nz, jr_018_4c59

	ld a, [$c19f]
	and a
	jr nz, jr_018_4c59

	call Call_3B8D
	ld a, $35
	call Call_2185

jr_018_4c59:
	ret


Jump_18_4C5A::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4c7c

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_018_4c76

	call Call_0898
	ld a, $0a
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	ret


jr_018_4c76:
	dec [hl]
	ld a, $37
	call Call_2185

jr_018_4c7c:
	ret


Jump_18_4C7D::
	call Call_18_7D02
	jr nc, jr_018_4c87

	ld a, $38
	call Call_2185

jr_018_4c87:
	ret


	db $62, $20, $60, $20, $66, $20, $64, $20, $6c, $00, $6e, $00, $68, $00, $6a, $00
	db $6a, $20, $68, $20, $6c, $00, $6e, $00, $9a, $10, $9c, $10

Call_18_4CA4::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_4cbe

	inc [hl]
	ld a, [$db69]
	ld d, $b1
	and $02
	jr z, jr_018_4cb8

	ld d, $cd

jr_018_4cb8:
	ldh a, [$fff6]
	cp d
	jp nz, Call_18_7E76

jr_018_4cbe:
	ld de, $4c88
	xor a
	ldh [$ffe8], a
	ld a, [$db0e]
	cp $0b
	jr nc, jr_018_4ce0

	ld a, [$db69]
	and $02
	jr nz, jr_018_4cd9

	ld a, [$db0e]
	cp $0a
	jr c, jr_018_4ce0

jr_018_4cd9:
	ld a, $01
	ldh [$ffe8], a
	ld de, $4c94

jr_018_4ce0:
	call Call_3C3B
	call Call_18_7D61
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_4CF7::
	dw Jump_18_4CFF
	dw Jump_18_4D35
	dw Jump_18_4D55
	dw Jump_18_4D8F

Jump_18_4CFF::
	call Call_18_7D0E
	jr nc, jr_018_4d34

	ld a, [$db56]
	cp $80
	ld a, $78
	jr z, jr_018_4d1d

	ldh a, [$ffe8]
	and a
	jr nz, jr_018_4d20

	ld a, [$db0e]
	cp $0b
	ld a, $5a
	jr c, jr_018_4d1d

	ld a, $5f

jr_018_4d1d:
	jp Call_2185


jr_018_4d20:
	ld a, [$db0e]
	cp $0a
	jr nz, jr_018_4d2f

	ld a, $5c
	call Call_2185
	jp Call_3B8D


jr_018_4d2f:
	ld a, $5b
	call Call_2185

jr_018_4d34:
	ret


Jump_18_4D35::
	ld a, [$c177]
	and a
	jr nz, jr_018_4d4b

	ld a, $01
	ldh [$fff2], a
	ld [$db7f], a
	call Call_0891
	ld [hl], $80
	call Call_3B8D
	ret


jr_018_4d4b:
	ld a, $59
	call Call_2185
	call Call_3B8D
	ld [hl], b
	ret


Jump_18_4D55::
	call Call_0891
	jr nz, jr_018_4d6b

	ld a, $0b
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	ld a, $5d
	call Call_2185
	jp Call_3B8D


jr_018_4d6b:
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	xor a
	ldh [$fff1], a
	ldh a, [$ffec]
	sub $0e
	ldh [$ffec], a
	ldh a, [$ffee]
	sub $04
	ldh [$ffee], a
	ld de, $4ca0
	call Call_3C3B
	call Call_3DBA
	ld a, $02
	jp Call_3B87


Jump_18_4D8F::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4da2

	ld [$db7f], a
	ld [$c167], a
	call Call_0898
	call Call_3B8D
	ld [hl], b

jr_018_4da2:
	ret


	db $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $00, $f8, $66, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00, $02, $00, $06, $04

Call_18_4DBF::
	ldh a, [$fff1]
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $4da3
	add hl, de
	ld c, $03
	call Call_3D26
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_18_7D61
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_4DE8::
	dw Jump_18_4DEE
	dw Jump_18_4E0B
	dw Jump_18_4E32

Jump_18_4DEE::
	call Call_18_7D0E
	jr nc, jr_018_4e0a

	ld a, [$db0e]
	and a
	ld e, $2a
	jr z, jr_018_4e06

	ld e, $2c
	cp $01
	jr nz, jr_018_4e06

	call Call_3B8D
	ld e, $2b

jr_018_4e06:
	ld a, e
	call Call_2185

jr_018_4e0a:
	ret


Jump_18_4E0B::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4e31

	ld a, [$c177]
	and a
	jr nz, jr_018_4e28

	ld a, $02
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	ld a, $28
	call Call_2185
	jp Call_3B8D


jr_018_4e28:
	ld a, $27
	call Call_2185
	call Call_3B8D
	ld [hl], b

jr_018_4e31:
	ret


Jump_18_4E32::
	ld a, [$c19f]
	and a
	jr nz, jr_018_4e3f

	call Call_0898
	call Call_3B8D
	ld [hl], b

jr_018_4e3f:
	ret


Call_18_4E40::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_5050

	ldh a, [$fff8]
	and $20
	jp nz, Call_18_7E76

	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_18_4E56::
	dw Jump_18_4E68
	dw Jump_18_4E81
	dw Jump_18_4E9B
	dw Jump_18_4EC1
	dw Jump_18_4EE8
	dw Jump_18_4EFF
	dw Jump_18_4F32
	dw Jump_18_4F6F
	dw Jump_18_4FBD

Jump_18_4E68::
	ld a, [$db76]
	ld hl, $4ef9
	cp [hl]
	jr nz, jr_018_4e80

	inc hl
	ld a, [$db77]
	cp [hl]
	jr nz, jr_018_4e80

	inc hl
	ld a, [$db78]
	cp [hl]
	jp z, Call_18_7E76

jr_018_4e80:
	ret


Jump_18_4E81::
	call Call_0891
	ld [hl], $90
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $06
	ldh [$fff2], a
	call Call_3B8D
	ret


Jump_18_4E9B::
	call Call_18_5031
	call Call_0891
	jr nz, jr_018_4ea8

	ld [hl], $60
	jp Call_3B8D


jr_018_4ea8:
	ld e, $fc
	sub $08
	and $10
	jr z, jr_018_4eb2

	ld e, $04

jr_018_4eb2:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	ld hl, $c250
	add hl, bc
	ld [hl], $fc
	call Call_18_7DCD
	ret


Jump_18_4EC1::
	call Call_18_5031
	call Call_0891
	jr nz, jr_018_4ee7

	ld [hl], $48
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
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	call Call_3B8D

jr_018_4ee7:
	ret


Jump_18_4EE8::
	call Call_18_5016
	call Call_0891
	jr nz, jr_018_4ef8

	ld a, $e1
	call Call_18_4FEE
	call Call_3B8D

jr_018_4ef8:
	ret


	db $40, $60, $60, $e2, $e3, $e4

Jump_18_4EFF::
	call Call_18_5016
	ld a, [$c19f]
	and a
	jr nz, jr_018_4f31

jr_018_4f08:
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld a, e
	ld [$d201], a
	inc a
	cp $03
	jr nz, jr_018_4f19

	xor a

jr_018_4f19:
	ld [hl], a
	ld hl, $4ef9
	add hl, de
	ld a, [hl]
	ld hl, $db76
	add hl, de
	cp [hl]
	jr z, jr_018_4f08

	ld hl, $4efc
	add hl, de
	ld a, [hl]
	call Call_18_4FEE
	call Call_3B8D

jr_018_4f31:
	ret


Jump_18_4F32::
	call Call_18_5016
	ld a, [$c19f]
	and a
	ret nz

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_018_4f6c

	ld a, $ca
	call Call_3C01
	ld a, $26
	ldh [$fff4], a
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2d0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $c0
	call Call_0891
	ld [hl], $c0
	ret


jr_018_4f6c:
	dec [hl]
	dec [hl]
	ret


Jump_18_4F6F::
	ld hl, $4ffe
	ld c, $03
	call Call_3D26
	call Call_18_5040
	call Call_0891
	ret nz

	call Call_3DAF
	ld a, $e5
	call Call_18_4FEE
	call Call_3B8D
	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $4ef9
	add hl, de
	ld a, [hl]
	ld hl, $db76
	add hl, de
	ld [hl], a
	ld d, a
	ld a, e
	and a
	jr nz, jr_018_4faf

	ld hl, $db4c
	ld [hl], d
	ld d, $0c
	call Call_3E95
	xor a
	ld [$db4b], a
	ld a, $0b
	ldh [$ffa5], a
	ret


jr_018_4faf:
	cp $01
	jr nz, jr_018_4fb8

	ld hl, $db4d
	ld [hl], d
	ret


jr_018_4fb8:
	ld hl, $db45
	ld [hl], d
	ret


Jump_18_4FBD::
	call Call_18_5016
	ld a, [$c19f]
	and a
	jr nz, jr_018_4fed

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_4fd3

	inc [hl]
	ld a, $3b
	ldh [$fff2], a

jr_018_4fd3:
	call Call_18_7DD0
	ld hl, $c250
	add hl, bc
	dec [hl]
	dec [hl]
	dec [hl]
	ldh a, [$ffec]
	cp $f0
	jr c, jr_018_4fed

	call Call_18_7F2B
	xor a
	ld [$c167], a
	call Call_18_7E76

jr_018_4fed:
	ret


Call_18_4FEE::
	ld e, a
	ldh a, [$ff99]
	push af
	ld a, $20
	ldh [$ff99], a
	ld a, e
	call Call_2197
	pop af
	ldh [$ff99], a
	ret


	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $70, $20, $00, $fc, $74, $00
	db $00, $04, $76, $00, $00, $0c, $74, $20

Call_18_5016::
	ld hl, $4ffe
	ldh a, [$ffe7]
	and $08
	jr z, jr_018_5022

	ld hl, $500a

jr_018_5022:
	ld c, $03
	call Call_3D26
	jr Call_18_5040

	db $7e, $00, $7e, $20, $7e, $40, $7e, $60

Call_18_5031::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ldh [$fff1], a
	ld de, $5029
	call Call_3C3B

Call_18_5040::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, $04
	ldh [$ff9d], a
	xor a
	ld [$c19b], a
	ret


Jump_018_5050:
	call Call_18_50C9
	call Call_0891
	jp z, Call_18_7E76

	bit 1, a
	ld a, $e4
	jr z, jr_018_5061

	ld a, $44

jr_018_5061:
	ld [$db97], a
	ret


	db $10, $00, $7c, $00, $10, $08, $7c, $60, $20, $00, $7c, $00, $20, $08, $7c, $60
	db $30, $f8, $78, $00, $30, $00, $7a, $00, $30, $08, $7a, $20, $30, $10, $78, $20
	db $40, $f8, $78, $40, $40, $00, $7a, $40, $40, $08, $7a, $60, $40, $10, $78, $60
	db $10, $00, $7c, $50, $10, $08, $7c, $30, $20, $00, $7c, $50, $20, $08, $7c, $30
	db $30, $f8, $78, $10, $30, $00, $7a, $10, $30, $08, $7a, $30, $30, $10, $78, $30
	db $40, $f8, $78, $50, $40, $00, $7a, $50, $40, $08, $7a, $70, $40, $10, $78, $70
	db $0c, $0c, $04, $02

Call_18_50C9::
	ldh a, [$ffec]
	sub $05
	ldh [$ffec], a
	call Call_0891
	ld c, $0c
	cp $b0
	jr c, jr_018_50e5

	sub $b0
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $50c5
	add hl, de
	ld c, [hl]

jr_018_50e5:
	ld hl, $5065
	ldh a, [$ffe7]
	and $04
	jr z, jr_018_50f1

	ld hl, $5095

jr_018_50f1:
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


	db $0e, $00

Call_18_50FC::
	ld de, $50fa
	call Call_3CD0
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	dec a
	ld [hl], a
	jp z, Call_18_7E76

	bit 4, a
	ld e, $01
	jr z, jr_018_5114

	ld e, $ff

jr_018_5114:
	bit 0, a
	jr nz, jr_018_511f

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a

jr_018_511f:
	jp Call_18_7DCD


	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20

Call_18_5132::
	call Call_18_5168
	ld de, $5122
	call Call_3C3B
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c210
	add hl, de
	ldh a, [$ffef]
	ld e, $00
	cp [hl]
	jr c, jr_018_514d

	ld e, $02

jr_018_514d:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87

Jump_018_515a:
jr_018_515a:
	call Call_18_7CAF
	call Call_18_7D0E
	jr nc, jr_018_5167

	ld a, $96
	call Call_2185

jr_018_5167:
	ret


Call_18_5168::
	ld a, [$db74]
	and a
	jp z, Call_18_7E76

	ret nz

	db $74, $00, $76, $00, $70, $00, $72, $00, $76, $20, $74, $20, $72, $20, $70, $20

Call_18_5180::
	call Call_18_5168
	ld de, $5170
	call Call_3C3B
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	ld e, $00
	cp [hl]
	jr nc, jr_018_519b

	ld e, $02

jr_018_519b:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	jr jr_018_515a

	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $58, $00, $5a, $00, $5a, $20, $58, $20, $5a, $20, $58, $20

Call_18_51CA::
	ld a, [$db74]
	and a
	jp nz, Call_18_7E76

	ld de, $51aa
	call Call_3C3B
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_018_51e5

	call Call_18_7E4F
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_018_51e5:
	call Call_18_7CD9
	call Call_18_7D61
	call Call_18_7E06
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_5200

	and $80
	jr z, jr_018_520e

jr_018_5200:
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_018_520e

	ld [hl], $0c

jr_018_520e:
	ldh a, [$ffef]
	ldh [$ffec], a
	call Call_18_7CAF
	call Call_3DBA
	call Call_18_7D0E
	ret nc

	ld e, $00
	ld a, [$dba5]
	and a
	jr nz, jr_018_5231

	inc e
	ldh a, [$fff6]
	cp $cc
	jr z, jr_018_5231

	inc e
	cp $cd
	jr z, jr_018_5231

	inc e

jr_018_5231:
	ld a, [$db6a]
	and $02
	jr z, jr_018_523c

	ld a, e
	add $04
	ld e, a

jr_018_523c:
	ld a, [$db73]
	and a
	jr z, jr_018_5247

	ld a, $52
	jp Call_218E


jr_018_5247:
	ld a, e
	add $4a
	jp Call_218E


	db $78, $00, $7a, $00, $7c, $00, $7e, $00, $7a, $20, $78, $20, $7e, $20, $7c, $20

Call_18_525D::
	call Call_18_5168
	ld de, $524d
	call Call_3C3B
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	ld e, $00
	cp [hl]
	jr nc, jr_018_5278

	ld e, $02

jr_018_5278:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	jp Jump_018_515a


	db $5a, $20, $58, $20, $5e, $20, $5c, $20, $58, $00, $5a, $00, $5c, $00, $5e, $00

Call_18_5298::
	ld de, $5288
	call Call_3C3B
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_18_7E06
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_018_52c9

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_018_52c9:
	ldh a, [$fff0]
	rst $00

JumpTable_18_52CC::
	dw Jump_18_52D4
	dw Jump_18_5301
	dw Jump_18_532A
	dw Jump_18_534F

Jump_18_52D4::
	call Call_0891
	ret nz

	ld hl, $c240
	add hl, bc
	ld [hl], $0c
	call Call_18_7DDA
	ldh a, [$ffee]
	cp $20
	jr nz, jr_018_52f6

	ld a, $01
	call Call_18_59BA
	ld a, $01
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	ret


jr_018_52f6:
	cp $48
	ret nz

	call Call_0891
	ld [hl], $40
	jp Call_3B8D


Jump_18_5301::
	call Call_0891
	jr nz, Call_18_5313

	ld a, $e3
	call Call_2185
	call Call_0891
	ld [hl], $10
	call Call_3B8D

Call_18_5313::
	ldh a, [$ffe8]
	and a
	jr z, jr_018_5329

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	dec [hl]
	and a
	jr nz, jr_018_5329

	ld [hl], $08
	ld hl, $c320
	add hl, bc
	ld [hl], $12

jr_018_5329:
	ret


Jump_18_532A::
	call Call_18_5313
	ld a, [$c19f]
	and a
	jr nz, jr_018_534e

	call Call_0891
	jr nz, jr_018_5342

	ld [hl], $10
	ld a, $e5
	call Call_2185
	jp Call_3B8D


jr_018_5342:
	ld e, $02
	cp $08
	jr nc, jr_018_534a

	ld e, $00

jr_018_534a:
	ld a, e
	call Call_18_59BA

jr_018_534e:
	ret


Jump_18_534F::
	call Call_18_5313
	ld a, [$c19f]
	and a
	jr nz, jr_018_53c1

	call Call_0891
	jr z, jr_018_5369

	ld e, $01
	cp $08
	jr c, jr_018_5365

	ld e, $02

jr_018_5365:
	ld a, e
	jp Call_18_59BA


jr_018_5369:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $02
	call Call_3B87
	ld hl, $db74
	ld [hl], $01
	ldh a, [$ffee]
	and $fc
	cp $e0
	jr z, jr_018_538b

	ld hl, $c240
	add hl, bc
	ld [hl], $ec
	call Call_18_7DDA

jr_018_538b:
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c240
	add hl, de
	ld [hl], $f4
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $04
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	push de
	push bc
	push de
	pop bc
	call Call_18_7DDA
	pop bc
	pop de
	ld hl, $c200
	add hl, de
	ld a, [hl]
	cp $f0
	jr nz, jr_018_53c1

	call Call_18_7E76
	xor a
	ld [$db73], a
	xor a
	ld [$c167], a

jr_018_53c1:
	ret


Call_18_53C2::
	call Call_18_547E
	call Call_18_7D61
	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $04
	cp $08
	jr nc, jr_018_53e1

	ld hl, $ff99
	ldh a, [$ffec]
	add $04
	sub [hl]
	jr c, jr_018_53e1

	call Call_18_7CB4

jr_018_53e1:
	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_018_545a

	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $08
	cp $04
	jr nc, jr_018_545a

	ld e, $20
	ld a, [$db00]
	cp $03
	jr z, jr_018_540b

	ld e, $10
	ld a, [$db01]
	cp $03
	jr nz, jr_018_545a

jr_018_540b:
	ldh a, [$ffcb]
	and e
	jr z, jr_018_545a

	ld a, $02
	ldh [$ffba], a
	ld a, $3a
	ldh [$ff9d], a
	ld a, $02
	ldh [$ff9e], a
	ld a, $01
	ldh [$ffa1], a
	call Call_093B
	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffec]
	add $08
	ldh [$ff99], a
	cp $50
	jr nc, jr_018_5453

	ldh a, [$ffcb]
	and $08
	jr z, jr_018_5453

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $18
	jr z, jr_018_5452

	ld hl, $ff9d
	inc [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], $04
	call Call_18_7DD0
	ld a, $01
	ldh [$ffba], a

jr_018_5452:
	ret


jr_018_5453:
	ld hl, $c3d0
	add hl, bc
	ld [hl], $08
	ret


jr_018_545a:
	ldh a, [$ffec]
	cp $1b
	jr c, jr_018_546d

	ld hl, $c250
	add hl, bc
	ld [hl], $fd
	call Call_18_7DD0
	ld a, $00
	ldh [$ffba], a

jr_018_546d:
	ret


	db $44, $00, $44, $20, $74, $00, $74, $20, $46, $00, $46, $20, $76, $00, $76, $20

Call_18_547E::
	ldh a, [$fff7]
	cp $01
	jr nz, jr_018_5486

	ldh [$fff1], a

jr_018_5486:
	ld de, $546e
	call Call_3C3B
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	add $fc
	cp $f0
	ret nc

	ldh [$ffec], a

jr_018_5498:
	ld de, $5476
	call Call_3C3B
	ldh a, [$ffec]
	add $10
	ldh [$ffec], a
	ld hl, $ffef
	cp [hl]
	jr c, jr_018_5498

	call Call_3DBA
	ret


	db $24, $00, $3e, $00

Jump_018_54b2:
	ld de, $54ae
	call Call_3CD0
	call Call_18_7D61
	call Call_0891
	jp z, Call_18_7E76

	ld e, $01
	cp $40
	jr c, jr_018_54d4

	jr nz, jr_018_54d3

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
	jr jr_018_54d4

jr_018_54d3:
	dec e

jr_018_54d4:
	ld a, e
	call Call_3B87
	call Call_0891
	ld e, $fe
	and $20
	jr z, jr_018_54e3

	ld e, $fc

jr_018_54e3:
	ld hl, $c250
	add hl, bc
	ld [hl], e
	ld hl, $c240
	add hl, bc
	ld [hl], $ff
	ldh a, [$ffe7]
	and $03
	ret nz

	call Call_18_7DCD
	ret


Call_18_54F7::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_54b2

	ld a, [$d8fd]
	and $20
	jp nz, Jump_018_58a0

	call Call_18_5870
	call Call_18_7D61
	call Call_18_7E06
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_018_5525

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_018_5525:
	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_552B::
	dw Jump_18_553D
	dw Jump_18_55B5
	dw Jump_18_55DA
	dw Jump_18_5673
	dw Jump_18_56E9
	dw Jump_18_571D
	dw Jump_18_5756
	dw Jump_18_5781
	dw Jump_18_579F

Jump_18_553D::
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, $7f
	and [hl]
	jr nz, jr_018_5571

	ld a, $c4
	call Call_3C01
	jr c, jr_018_5571

	ldh a, [$ffd7]
	sub $08
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	add $02
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $60
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	ld hl, $c2b0
	add hl, de
	inc [hl]

jr_018_5571:
	ld a, [$db73]
	and a
	jr nz, jr_018_5582

	call Call_18_7CF5
	jr nc, jr_018_5581

	ld a, $e0
	call Call_2185

jr_018_5581:
	ret


jr_018_5582:
	call Call_18_7E20
	add $13
	cp $26
	ret nc

	call Call_18_7E30
	add $20
	cp $40
	ret nc

	call Call_093B
	call Call_1495
	ld a, [$c146]
	and a
	ret nz

	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c310
	add hl, de
	ld a, [hl]
	and a
	ret nz

	call Call_3B8D
	ld a, $e1
	call Call_2185
	call Call_18_59B8
	ret


Jump_18_55B5::
	ld a, [$c19f]
	and a
	jr nz, jr_018_55d9

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_018_55d2

	ld a, $2f
	ld [$d368], a
	ld [$c3c8], a
	call Call_0887
	ld [hl], $50
	ret


jr_018_55d2:
	ld [hl], $08
	ld a, $e4
	call Call_2185

jr_018_55d9:
	ret


Jump_18_55DA::
	ld a, $01
	ld [$c167], a
	ld a, $02
	ldh [$ffa1], a
	call Call_0887
	jr nz, jr_018_55ee

	ld [hl], $c0
	call Call_3B8D
	ret


jr_018_55ee:
	ld e, $00
	cp $40
	jr nc, jr_018_560e

	ld e, $02
	cp $10
	jr c, jr_018_560e

	ld e, $00
	cp $3c
	jr nc, jr_018_560c

	cp $20
	jr z, jr_018_560e

	cp $21
	jr z, jr_018_560e

	cp $22
	jr z, jr_018_560e

jr_018_560c:
	ld e, $01

jr_018_560e:
	ld a, e
	call Call_3B87
	ret


	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02
	db $01, $02, $01, $02, $01, $01, $02, $02, $01, $02, $01, $02, $01, $01, $02, $02

Jump_18_5673::
	ld a, $01
	ld [$c167], a
	ld a, $02
	ldh [$ffa1], a
	call Call_0887
	jr nz, jr_018_5695

	ld [$c3c8], a
	ld a, $11
	ldh [$fff4], a
	call Call_0891
	ld [hl], $08
	ld a, $02
	call Call_3B87
	jp Call_3B8D


jr_018_5695:
	ld hl, $c2d0
	add hl, bc
	ld e, [hl]
	ld d, b
	ldh a, [$ffe7]
	and $07
	jr nz, jr_018_56b5

	inc [hl]
	ld a, [hl]
	cp $60
	jr nc, jr_018_56b5

	and $0f
	jr nz, jr_018_56b5

	ld hl, $c320
	add hl, bc
	ld [hl], $10
	ld a, $24
	ldh [$fff2], a

jr_018_56b5:
	ld hl, $5613
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_018_56cb

	ldh a, [$ffe7]
	and $3f
	jr nz, jr_018_56c9

	ld hl, $fff2
	ld [hl], $27

jr_018_56c9:
	ld a, $02

jr_018_56cb:
	call Call_3B87
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_56e8

	ld e, $01
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sub $f8
	and $80
	jr nz, jr_018_56e4

	inc e

jr_018_56e4:
	ld a, e
	call Call_3B87

jr_018_56e8:
	ret


Jump_18_56E9::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_018_571c

	ld [hl], $10
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $04
	ld [hl], a
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr nz, jr_018_571c

	ld hl, $c310
	add hl, bc
	ld [hl], $18
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $18
	ld [hl], a
	ld a, $08
	ldh [$fff2], a
	call Call_3B8D

jr_018_571c:
	ret


Jump_18_571D::
	ld a, $02
	ldh [$ffa1], a
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_5755

	call Call_3B8D
	call Call_0891
	ld [hl], $08

Call_18_5731::
	ld a, $24
	ldh [$fff4], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $10
	ldh [$ffd8], a
	ld a, $01
	call Call_0953
	ldh a, [$ffee]
	add $10
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $10
	ldh [$ffd8], a
	ld a, $01
	call Call_0953

jr_018_5755:
	ret


Jump_18_5756::
	call Call_0891
	jr nz, jr_018_577c

	call Call_3B8D
	ldh a, [$ffb0]
	ld [$d368], a
	ld a, $ff
	call Call_3B87
	ld a, $e2
	call Call_2185
	ld a, $03
	call Call_18_59BA
	ld a, $03
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	ret


jr_018_577c:
	ld a, $05
	jp Call_3B87


Jump_18_5781::
	ld a, $c8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $f8
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	ld hl, $c210
	add hl, de
	ld [hl], $48
	call Call_18_7E76
	call Call_18_7F2B
	ret


Jump_18_579F::
	ret


	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $60, $00, $00, $08, $70, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $68, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $72, $00, $00, $08, $74, $00, $00, $10, $64, $00, $00, $18, $66, $00
	db $10, $00, $76, $00, $10, $08, $6a, $00, $10, $10, $6c, $00, $10, $18, $6e, $00
	db $00, $00, $78, $00, $00, $08, $7a, $00, $00, $10, $7c, $00, $00, $18, $7e, $00
	db $10, $00, $78, $40, $10, $08, $7a, $40, $10, $10, $7c, $40, $10, $18, $7e, $40
	db $00, $00, $68, $40, $00, $08, $6a, $40, $00, $10, $6c, $40, $00, $18, $6e, $40
	db $10, $00, $60, $40, $10, $08, $62, $40, $10, $10, $64, $40, $10, $18, $66, $40
	db $0e, $00, $68, $40, $0e, $08, $6a, $40, $0e, $10, $6c, $40, $0e, $18, $6e, $40
	db $10, $00, $ff, $40, $10, $08, $ff, $40, $10, $10, $ff, $40, $10, $18, $ff, $40
	db $17, $03, $26, $00, $17, $09, $26, $00, $17, $0f, $26, $00, $17, $15, $26, $00

Call_18_5870::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $57a0
	add hl, de
	ld c, $08
	call Call_3D26
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	ret z

	ldh a, [$ffef]
	ldh [$ffec], a
	ld hl, $5860
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	call Call_3DBA
	ret


Jump_018_58a0:
	call Call_18_5977
	ld a, [$c124]
	and a
	ret nz

	ldh a, [$fff0]
	rst $00

JumpTable_18_58AB::
	dw Jump_18_58B3
	dw Jump_18_58C7
	dw Jump_18_58E7
	dw Jump_18_58FC

Jump_18_58B3::
	ld hl, $c210
	add hl, bc
	ld [hl], $68
	ld hl, $c200
	add hl, bc
	ld [hl], $80
	call Call_0891
	ld [hl], $20
	jp Call_3B8D


Jump_18_58C7::
	call Call_0891
	jr nz, jr_018_58e6

	ld a, [$db4a]
	cp $00
	jr nz, jr_018_58e6

	ld a, [$c166]
	and a
	cp $40
	jr nz, jr_018_58e6

	call Call_3B8D
	call Call_0891
	ld [hl], $20
	call Call_18_5731

jr_018_58e6:
	ret


Jump_18_58E7::
	call Call_0891
	jr nz, jr_018_58f1

	ld [hl], $c8
	jp Call_3B8D


jr_018_58f1:
	cp $10
	ld a, $01
	jr c, jr_018_58f8

	inc a

jr_018_58f8:
	call Call_3B87
	ret


Jump_18_58FC::
	call Call_0891
	jr nz, jr_018_5907

	call Call_18_5731
	jp Call_18_7E76


jr_018_5907:
	cp $b0
	jr nz, jr_018_590b

jr_018_590b:
	call Call_0891
	cp $80
	jr nz, jr_018_5918

	dec [hl]
	ld a, $e6
	call Call_2185

jr_018_5918:
	call Call_0891
	ld d, $00
	cp $10
	ld e, $02
	jr c, jr_018_5929

	dec e
	cp $20
	jr c, jr_018_5929

	inc d

jr_018_5929:
	ld hl, $c390
	add hl, bc
	ld [hl], d
	ld a, e
	call Call_3B87
	ret


	db $ff, $04, $ff, $00, $ff, $0c, $ff, $00, $ff, $04, $ff, $00, $ff, $0c, $ff, $00
	db $ff, $14, $ff, $00, $fc, $04, $70, $00, $fc, $0c, $72, $00, $0c, $04, $74, $00
	db $0c, $0c, $76, $00, $0c, $14, $78, $00, $0c, $04, $7a, $00, $0c, $0c, $7c, $00
	db $0c, $14, $7e, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $01, $02
	db $03, $03, $02, $01

Call_18_5977::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	nop
	nop
	and $07
	ld e, a
	ld d, b
	ld hl, $596f
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_59a1

	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	rra
	and $01
	inc a
	ldh [$fff1], a

jr_018_59a1:
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, b
	ld hl, $5933
	add hl, de
	ld c, $05
	jp Call_3D26


Call_18_59B8::
	ld a, $00

Call_18_59BA::
	ld e, $10
	ld hl, $d1b5

jr_018_59bf:
	ld [hli], a
	dec e
	jr nz, jr_018_59bf

	ret


	db $42, $20, $40, $20, $40, $00, $42, $00, $44, $00, $46, $00, $46, $20, $44, $20
	db $48, $00, $4a, $00, $4c, $00, $4e, $00, $4a, $20, $48, $20, $4e, $20, $4c, $20
	db $50, $00, $52, $00, $54, $00, $54, $20, $52, $20, $50, $20, $06, $04, $02, $00

Jump_018_59f4:
	ld a, c
	ld [$c50f], a
	call Call_0891
	jr z, jr_018_5a4b

	cp $10
	jr nz, jr_018_5a13

	dec [hl]
	ldh a, [$ff99]
	push af
	ld a, $28
	ldh [$ff99], a
	ld a, $1f
	call Call_2197
	pop af
	ldh [$ff99], a
	ld a, $0f

jr_018_5a13:
	cp $01
	jr nz, jr_018_5a24

	xor a
	ld [$c167], a
	ld a, $31
	ld [$d368], a
	ld a, $05
	ldh [$ffb0], a

jr_018_5a24:
	xor a
	ld [$c3b0], a
	ld de, $59c4
	call Call_3C3B
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	ld a, $03
	ldh [$ff9e], a
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ldh a, [$ff99]
	sub $10
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ret


jr_018_5a4b:
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_5a98

	ld a, [$c16b]
	cp $04
	jr nz, jr_018_5a8b

	inc [hl]
	call Call_0891
	ld [hl], $70
	ld a, $10
	ld [$d368], a
	ld a, $ff
	ldh [$ffbf], a
	ldh a, [$ff98]
	ld hl, $d155
	call Call_18_5A85
	ldh a, [$ff99]
	ld hl, $d175
	call Call_18_5A85
	xor a
	ld hl, $d195
	call Call_18_5A85
	ldh a, [$ff9e]
	ld hl, $d1b5

Call_18_5A85::
	ld e, $10

jr_018_5a87:
	ld [hli], a
	dec e
	jr nz, jr_018_5a87

jr_018_5a8b:
	ret


	db $08, $08, $08, $09, $0a, $0a, $0a, $09, $08, $f8, $06, $01

jr_018_5a98:
	ld a, [$c3c8]
	and a
	jr z, jr_018_5af3

	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a8c
	add hl, de
	ld a, [hl]
	ldh [$fff1], a
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_018_5af3

	ld a, $c9
	call Call_3C01
	jr c, jr_018_5af3

	ldh a, [$ffd8]
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
	ld hl, $5a94
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $5a96
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

jr_018_5af3:
	ld de, $59c4
	call Call_3C3B
	ld a, [$c14f]
	and a
	ret nz

	ld hl, $c480
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_5b0f

	dec a
	jr nz, jr_018_5b0f

	dec [hl]
	ld a, $7a
	call Call_218E

jr_018_5b0f:
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_5b6a

	cp $30
	jr nz, jr_018_5b55

	xor a
	ld [$c167], a
	ldh a, [$ff98]
	sub $58
	add $03
	cp $06
	jr nc, jr_018_5b33

	ldh a, [$ff99]
	sub $50
	add $03
	cp $06
	jr c, jr_018_5b3b

jr_018_5b33:
	ld [hl], b
	ld hl, $c480
	add hl, bc
	ld [hl], $1c
	ret


jr_018_5b3b:
	ld hl, $fff2
	ld [hl], $0b
	ld hl, $fff3
	ld [hl], $03
	ld hl, $c157
	ld [hl], $18
	ld hl, $c158
	ld [hl], $04
	ld hl, $ff98
	inc [hl]
	jr jr_018_5b61

jr_018_5b55:
	jr nc, jr_018_5b6a

	cp $10
	jr nz, jr_018_5b61

	dec [hl]
	ld a, $7b
	call Call_218E

jr_018_5b61:
	ld a, $02
	ldh [$ffa1], a
	ld a, $6a
	ldh [$ff9d], a
	ret


jr_018_5b6a:
	ld a, [$db74]
	ld hl, $c1bc
	or [hl]
	ret nz

	ld a, [$db10]
	and a
	jp z, Jump_018_5c70

	call Call_3B9E
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_18_7D61
	ld a, [$d468]
	and a
	jr z, jr_018_5b90

	dec a
	ld [$d468], a

jr_018_5b90:
	ldh a, [$fff0]
	rst $00

JumpTable_18_5B93::
	dw Jump_18_5B9D
	dw Jump_18_5BB4
	dw Jump_18_5BD2
	dw Jump_18_5C0B
	dw Jump_18_5C3F

Jump_18_5B9D::
	ld a, [$c11c]
	cp $03
	ret z

	ld a, $40
	ld [$d468], a
	ld a, $0f
	ldh [$ffa5], a
	ld a, $01
	call Call_3B87
	jp Call_3B8D


Jump_18_5BB4::
	ld a, [$d468]
	and a
	jr nz, jr_018_5bd1

	ld a, $18
	ld [$d468], a
	ld hl, $c380
	add hl, bc
	ld [hl], $01
	ld a, $04
	call Call_3B87
	ld a, $10
	ldh [$ffa5], a
	call Call_3B8D

jr_018_5bd1:
	ret


Jump_18_5BD2::
	ld a, [$d468]
	and a
	jr nz, jr_018_5c0a

	ld hl, $c240
	add hl, bc
	ld [hl], $f4
	call Call_18_7DDA
	ldh a, [$ffe7]
	and $08
	ld e, $04
	jr z, jr_018_5bea

	inc e

jr_018_5bea:
	ld a, e
	call Call_3B87
	call Call_18_7E20
	add $02
	cp $04
	ret nc

	ld hl, $c3b0
	add hl, bc
	ld [hl], $02
	ld hl, $c380
	add hl, bc
	ld [hl], $02
	ld a, $10
	ld [$d468], a
	call Call_3B8D

jr_018_5c0a:
	ret


Jump_18_5C0B::
	ld a, [$d468]
	and a
	jr nz, jr_018_5c3e

	ld a, [$db10]
	dec a
	ld e, a
	ld a, [$c163]
	cp e
	jr z, jr_018_5c2c

	and a
	jr z, jr_018_5c2c

	ld e, $1c
	call Call_27ED
	and $3f
	jr nz, jr_018_5c37

	ld e, $1e
	jr jr_018_5c37

jr_018_5c2c:
	ld e, $1b
	ld a, [$db47]
	cp $80
	jr nc, jr_018_5c37

	ld e, $1d

jr_018_5c37:
	ld a, e
	call Call_218E
	call Call_3B8D

jr_018_5c3e:
	ret


Jump_18_5C3F::
	xor a
	ld [$db10], a
	ld [$c167], a
	call Call_3B8D
	ld [hl], b
	ld hl, $c3d0
	add hl, bc
	ld [hl], $ff
	ldh a, [$ffee]
	ld hl, $d155
	call Call_18_5C69
	ld hl, $d175
	ldh a, [$ffec]
	ld e, $10

jr_018_5c5f:
	ld [hli], a
	dec a
	dec e
	jr nz, jr_018_5c5f

	ld a, $02
	ld hl, $d1b5

Call_18_5C69::
	ld e, $10

jr_018_5c6b:
	ld [hli], a
	dec e
	jr nz, jr_018_5c6b

	ret


Jump_018_5c70:
	ld a, [$c16b]
	cp $04
	ret nz

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
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $59f0
	add hl, de
	push hl
	ld a, [$c120]
	rra
	rra
	rra
	pop hl
	and $01
	or [hl]
	call Call_3B87
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffe8], a
	and $0f
	ld e, a
	ld d, b
	ld hl, $d155
	add hl, de
	ldh a, [$ff9f]
	ld [hl], a
	ldh a, [$ffa0]
	ld hl, $c13b
	add [hl]
	ld hl, $d175
	add hl, de
	ld [hl], a
	ld hl, $d1b5
	add hl, de
	ldh a, [$ff9e]
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	and $0f
	ld e, a
	ld d, b
	ld hl, $d195
	add hl, de
	ldh a, [$ffa2]
	ld [hl], a
	ld a, [$c11c]
	cp $02
	jr z, jr_018_5cf0

	ld a, [$c124]
	and a
	jr nz, jr_018_5cf0

	ld a, [$c19f]
	and a
	jr nz, jr_018_5cf5

	ld hl, $ff9a
	ldh a, [$ff9b]
	or [hl]
	jr z, jr_018_5cf5

jr_018_5cf0:
	ld hl, $c3d0
	add hl, bc
	inc [hl]

jr_018_5cf5:
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ldh a, [$ffe8]
	inc a
	and $0f
	ld e, a
	ld d, b
	ld hl, $d155
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $d175
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $d1b5
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	ldh a, [$ffe9]
	inc a
	and $0f
	ld e, a
	ld d, b
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $d195
	add hl, de
	ld e, [hl]
	ld hl, $c310
	add hl, bc
	ld [hl], e
	call Call_088C
	ld hl, $c124
	or [hl]
	jr nz, jr_018_5d83

	pop af
	cp e
	jr z, jr_018_5d80

	and a
	jr z, jr_018_5d75

	ld a, e
	and a
	jr nz, jr_018_5d80

	call Call_3B9E
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	cp $02
	ret z

	ld hl, $c470
	add hl, bc
	ld a, [hl]
	dec a
	cp $02
	jr c, jr_018_5d64

	ld a, $07
	ldh [$fff4], a
	ret


jr_018_5d64:
	ldh a, [$ffec]
	ldh [$ffd8], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ld a, $0e
	ldh [$fff2], a
	ld a, $0c
	jp Call_0953


jr_018_5d75:
	ld a, e
	cp $08
	ld a, $08
	jr nc, jr_018_5d7e

	ld a, $24

jr_018_5d7e:
	ldh [$fff2], a

jr_018_5d80:
	jp Call_3B9E


jr_018_5d83:
	pop af
	ret


	db $00, $01, $ff, $00, $10, $f0

Call_18_5D8B::
	call Call_18_7D61
	ld a, $01
	ldh [$ffa4], a
	inc a
	ldh [$ffa1], a
	ld [$c167], a
	ldh a, [$ffcc]
	and $03
	ld e, a
	ld d, b
	ld hl, $5d85
	add hl, de
	ld a, [$c109]
	push af
	add [hl]
	and $0f
	ld e, a
	pop af
	and $f0
	or e
	ld [$c109], a
	ldh a, [$ffcc]
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5d88
	add hl, de
	ld a, [$c109]
	add [hl]
	ld [$c109], a
	ld a, [$c19f]
	and a
	jr nz, jr_018_5de2

	ldh a, [$ffcc]
	and $10
	jr z, jr_018_5dd6

	ld a, [$c109]
	jp Call_2197


jr_018_5dd6:
	ldh a, [$ffcc]
	and $20
	jr z, jr_018_5de2

	ld a, [$c109]
	jp Call_2185


jr_018_5de2:
	ldh a, [$ffcc]
	and $40
	jr z, jr_018_5dee

	ld a, [$c109]
	jp Call_218E


jr_018_5dee:
	ret


Call_18_5DEF::
	call Call_18_7D61
	ldh a, [$ffe7]
	and $03
	jr nz, jr_018_5dfc

	ld hl, $c1bf
	inc [hl]

jr_018_5dfc:
	ret


	db $5e, $00, $5e, $20, $00, $f8, $50, $00, $00, $00, $52, $00, $00, $08, $54, $00
	db $00, $10, $56, $00

Jump_018_5e11:
	ld hl, $5e01
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ldh a, [$fff0]
	rst $00

JumpTable_18_5E21::
	dw Jump_18_5E27
	dw Jump_18_5E30
	dw Jump_18_5E4B

Jump_18_5E27::
	ld hl, $c200
	add hl, bc
	ld [hl], $50
	jp Call_3B8D


Jump_18_5E30::
	call Call_18_7D61
	call Call_0891
	ret nz

	call Call_18_7D0E
	ret nc

	ld a, [$db97]
	cp $e4
	jr nz, jr_018_5e45

	jp Call_3B8D


jr_018_5e45:
	ld a, $e6
	call Call_2197
	ret


Jump_18_5E4B::
	call Call_18_7D61
	ld a, [$c19f]
	and a
	jr nz, jr_018_5e67

	ld a, $0a
	call Call_18_4C36
	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	ld hl, $d8ac
	set 4, [hl]

jr_018_5e67:
	ret


Call_18_5E68::
	ldh a, [$fff7]
	cp $16
	jp z, Jump_018_5e11

	ldh a, [$ffec]
	add $01
	ldh [$ffec], a
	ld de, $5dfd
	call Call_3C3B
	call Call_18_7CAF
	call Call_18_7D61
	call Call_18_7D0E
	jr nc, jr_018_5e95

	ld a, [$dbce]
	and a
	ld a, $10
	jr z, jr_018_5e92

	ldh a, [$fff7]
	add $08

jr_018_5e92:
	call Call_2185

jr_018_5e95:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_18_5EB6::
	ld a, [$db6b]
	and $02
	jp z, Call_18_7E76

	ld a, [$db7b]
	and a
	jp nz, Call_18_7E76

	ldh a, [$fff8]
	and $10
	jp nz, Call_18_7E76

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_60dd

	ld a, c
	ld [$c50f], a
	ld de, $5e96
	call Call_3C3B
	call Call_18_7CD9
	call Call_18_7E06
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	ldh [$ffe8], a
	jr z, jr_018_5ef9

	and $80
	jr z, jr_018_5eff

jr_018_5ef9:
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_018_5eff:
	ldh a, [$fff0]
	rst $00

JumpTable_18_5F02::
	dw Jump_18_5F22
	dw Jump_18_5F54
	dw Jump_18_5F62
	dw Jump_18_5F7C
	dw Jump_18_5FAD
	dw Jump_18_5FD1
	dw Jump_18_5FE3
	dw Jump_18_5FFA
	dw Jump_18_6012
	dw Jump_18_6035
	dw Jump_18_603D
	dw Jump_18_6059
	dw Jump_18_607B

Call_18_5F1C::
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	ret


Jump_18_5F22::
	call Call_18_5F3F
	call Call_18_7D61
	call Call_18_7E20
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ldh a, [$ff98]
	cp $90
	jr nc, jr_018_5f3e

	ld a, $35
	call Call_218E
	call Call_3B8D

jr_018_5f3e:
	ret


Call_18_5F3F::
	ldh a, [$ffe8]
	and a
	jr z, jr_018_5f47

	and $80
	ret z

jr_018_5f47:
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_018_5f53

	ld hl, $c320
	add hl, bc
	ld [hl], $10

jr_018_5f53:
	ret


Jump_18_5F54::
	call Call_18_5F3F
	call Call_18_7D61
	ld a, $36
	call Call_218E
	jp Call_3B8D


Jump_18_5F62::
	call Call_18_5F3F
	call Call_18_7D61
	call Call_18_7E20
	add $08
	cp $10
	ret nc

	call Call_18_7E30
	add $10
	cp $20
	ret nc

	call Call_3B8D
	ret


Jump_18_5F7C::
	call Call_18_5F1C
	call Call_18_7D61
	call Call_18_7E20
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld a, [$c1a4]
	and a
	jr z, jr_018_5fa1

	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	add $10
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ret


jr_018_5fa1:
	xor a
	ld [$c19b], a
	call Call_0891
	ld [hl], $10
	jp Call_3B8D


Jump_18_5FAD::
	call Call_18_5F1C
	call Call_18_7D61
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, $00
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	call Call_0891
	jr nz, jr_018_5fd0

	ld a, $37
	call Call_218E
	call Call_3B8D

jr_018_5fd0:
	ret


Jump_18_5FD1::
	call Call_18_5F1C
	call Call_18_7D61
	ld a, $02
	ldh [$ffa1], a
	ld a, $38
	call Call_218E
	jp Call_3B8D


Jump_18_5FE3::
	call Call_18_5F1C
	ld a, $02
	ldh [$ffa1], a
	call Call_18_7D61
	ld a, $39
	call Call_218E
	ld hl, $c2b0
	add hl, bc
	ld [hl], b
	jp Call_3B8D


Jump_18_5FFA::
	call Call_18_5F1C
	ld a, $02
	ldh [$ffa1], a
	call Call_18_7D61
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $a0
	jr nz, jr_018_6011

	jp Call_3B8D


jr_018_6011:
	ret


Jump_18_6012::
	call Call_18_5F1C
	ld a, $02
	ldh [$ffa1], a
	call Call_18_7D61
	ld a, $c2
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $12
	ld hl, $c210
	add hl, de
	ld [hl], $88
	ld hl, $c2c0
	add hl, de
	inc [hl]
	jp Call_3B8D


Jump_18_6035::
	call Call_18_5F1C
	ld a, $02
	ldh [$ffa1], a
	ret


Jump_18_603D::
	ld a, $02
	ldh [$ffa1], a
	ldh a, [$ffec]
	cp $3e
	jr c, jr_018_604a

	jp Call_3B8D


jr_018_604a:
	ld hl, $c250
	add hl, bc
	ld [hl], $06
	ld hl, $c380
	add hl, bc
	ld [hl], $03
	jp Call_18_7DD0


Jump_18_6059::
	ld a, $02
	ldh [$ffa1], a
	ld hl, $c240
	add hl, bc
	ld [hl], $fa
	ld hl, $c380
	add hl, bc
	ld [hl], $01
	call Call_18_7DDA
	ldh a, [$ffee]
	cp $18
	jr nc, jr_018_607a

	call Call_0891
	ld [hl], $60
	call Call_3B8D

jr_018_607a:
	ret


Jump_18_607B::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr z, jr_018_608b

	ld hl, $c380
	add hl, bc
	ld [hl], $02
	ret


jr_018_608b:
	ld hl, $c240
	add hl, bc
	ld [hl], $f4
	ld hl, $c380
	add hl, bc
	ld [hl], $01
	call Call_18_7DDA
	ldh a, [$ffee]
	cp $f0
	jr nz, jr_018_60af

	xor a
	ld [$c167], a
	ld hl, $d808
	set 4, [hl]
	ld a, [hl]
	ldh [$fff8], a
	jp Call_18_7E76


jr_018_60af:
	call Call_18_7E20
	ld a, e
	xor $01
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	ret


	db $50, $00, $52, $00, $52, $20, $50, $20, $54, $00, $56, $00, $56, $20, $54, $20
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5a, $20, $58, $20, $5e, $20, $5c, $20

Jump_018_60dd:
	ld de, $60bd
	call Call_3C3B
	call Call_18_7CD9
	ldh a, [$fff0]
	rst $00

JumpTable_18_60E9::
	dw Jump_18_60F1
	dw Jump_18_6123
	dw Jump_18_6139
	dw Jump_18_615D

Jump_18_60F1::
	ld hl, $c380
	add hl, bc
	ld [hl], $02
	ld hl, $c250
	add hl, bc
	ld [hl], $f4
	call Call_18_7DD0
	ldh a, [$ffec]
	cp $70
	jr nc, jr_018_6122

	ld a, $3b
	call Call_218E
	ld a, $03
	ldh [$ff9e], a
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c380
	add hl, de
	ld [hl], $03
	push bc
	call Call_087C
	pop bc
	call Call_3B8D

jr_018_6122:
	ret


Jump_18_6123::
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c380
	add hl, de
	ld [hl], $03
	call Call_18_7D61
	ld a, $3a
	call Call_218E
	jp Call_3B8D


Jump_18_6139::
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c380
	add hl, de
	ld [hl], $03
	ld a, [$c170]
	cp $22
	jr c, jr_018_614d

	ld [hl], $01

jr_018_614d:
	call Call_18_7D61
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	inc [hl]
	jp Call_3B8D


Jump_18_615D::
	ld hl, $c380
	add hl, bc
	ld [hl], $01
	ld hl, $c240
	add hl, bc
	ld [hl], $f8
	call Call_18_7DDA
	ldh a, [$ffee]
	cp $e0
	jr nz, jr_018_6175

	call Call_18_7E76

jr_018_6175:
	ret


Call_18_6176::
	ld a, [$db73]
	and a
	jp nz, Jump_018_59f4

	ld a, [$db74]
	and a
	ret nz

	ld a, [$d8fd]
	and $20
	jp nz, Call_18_7E76

	ld a, [$db0e]
	cp $07
	jp c, Call_18_7E76

	ld de, $5e96
	call Call_3C3B
	ld a, [$c124]
	and a
	ret nz

	call Call_18_7CAF
	ldh a, [$fff0]
	rst $00

JumpTable_18_61A3::
	dw Jump_18_61B1
	dw Jump_18_61BE
	dw Jump_18_61DB
	dw Jump_18_61FB
	dw Jump_18_622E
	dw Jump_18_623D
	dw Jump_18_6252

Jump_18_61B1::
	ld a, $4d
	ld [$d368], a
	ldh [$ffb0], a
	ldh [$ffbd], a
	call Call_3B8D
	ret


Jump_18_61BE::
	ld a, [$c19f]
	and a
	jr nz, jr_018_61da

	call Call_18_7E30
	add $14
	cp $28
	jr nc, jr_018_61da

	ld a, $01
	ld [$c167], a
	call Call_0891
	ld [hl], $18
	call Call_3B8D

jr_018_61da:
	ret


Jump_18_61DB::
	ld a, [$c19f]
	and a
	jr nz, jr_018_61fa

	call Call_0891
	jr nz, jr_018_61ee

	ld a, $d5
	call Call_2185
	call Call_3B8D

jr_018_61ee:
	ld e, $02
	cp $0c
	jr c, jr_018_61f6

	ld e, $04

jr_018_61f6:
	ld a, e
	call Call_3B87

jr_018_61fa:
	ret


Jump_18_61FB::
	ld a, [$c19f]
	and a
	jr nz, jr_018_622d

	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_018_6224

	ld [hl], $06
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$d47c], a
	ld [$db96], a
	ld a, $09
	ld [$db95], a
	ld a, $4e
	ld [$d368], a
	ret


jr_018_6224:
	xor a
	ld [$c167], a
	ld a, $d6
	call Call_2185

jr_018_622d:
	ret


Jump_18_622E::
	ld a, [$c19f]
	and a
	jr nz, jr_018_623c

	call Call_0891
	ld [hl], $60
	call Call_3B8D

jr_018_623c:
	ret


Jump_18_623D::
	call Call_0891
	jr nz, jr_018_6245

	call Call_3B8D

jr_018_6245:
	ld e, $00
	cp $54
	jr c, jr_018_624d

	ld e, $04

jr_018_624d:
	ld a, e
	call Call_3B87
	ret


Jump_18_6252::
	ret


	db $65, $64, $54, $52, $22, $22, $32, $37, $37, $37, $57, $56, $26, $21, $c4, $c5
	db $d5, $d4, $c4, $c5, $d5, $d5, $c5, $c4, $c4, $c5, $d5, $d4, $ab, $a9, $ac, $aa
	db $ab, $a9, $ab, $aa, $ac, $a9, $ab, $a9, $ac, $ae

Call_18_627D::
	call Call_18_7D61
	ldh a, [$fff6]
	cp $b4
	jr nz, jr_018_628d

	xor a
	ld [$d472], a
	ld [$d473], a

jr_018_628d:
	ld a, [$d473]
	and a
	jr z, jr_018_62df

	ld a, [$d472]
	ld e, a
	ld d, b
	ld hl, $6253
	add hl, de
	ld a, [$d473]
	cp [hl]
	jr nz, jr_018_62cf

	ld hl, $6261
	add hl, de
	ldh a, [$fff6]
	cp [hl]
	jr nz, jr_018_62cf

	xor a
	ld [$d473], a
	ld a, [$d472]
	inc a
	ld [$d472], a
	cp $0e
	jr nz, jr_018_62c7

	xor a
	ld [$d472], a
	ld a, $02
	ldh [$fff2], a
	push de
	call Call_18_62E0
	pop de

jr_018_62c7:
	ld hl, $626f
	add hl, de
	ld a, [hl]
	jp Call_2185


jr_018_62cf:
	xor a
	ld [$d472], a
	ld [$d473], a
	ld a, $1d
	ldh [$fff2], a
	ld a, $ad
	call Call_2185

jr_018_62df:
	ret


Call_18_62E0::
	ld hl, $d739
	ld [hl], $c6
	ld a, $28
	ld [$d416], a
	ld a, $20
	ldh [$ffcd], a
	add $10
	ldh [$ffd8], a
	ld a, $80
	ldh [$ffce], a
	add $08
	ldh [$ffd7], a
	ld a, $02
	call Call_0953
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
	ld a, $68
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
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
	ld [hl], $00
	ld a, $01
	ldh [$ffac], a
	ldh a, [$ffcd]
	and $f0
	add $10
	ldh [$ffae], a
	ldh a, [$ffce]
	and $f0
	add $08
	ldh [$ffad], a
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $d800
	add hl, de
	set 4, [hl]
	ret


	db $10, $20, $30, $40, $50, $60, $70, $80, $18, $28, $38, $48, $58, $68, $78, $88

Call_18_6362::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_63e3

	call Call_18_7D61
	call Call_0891
	jr nz, jr_018_63ce

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $635a
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $6352
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	call Call_18_646E
	ldh a, [$ffda]
	cp $00
	jr z, jr_018_63a0

	cp $06
	jr z, jr_018_63a0

	cp $09
	jr z, jr_018_63a0

	ret


jr_018_63a0:
	call Call_0891
	call Call_27ED
	and $3f
	add $40
	ld [hl], a
	ld a, $bf
	ld e, $05
	call Call_3C13
	jr c, jr_018_63ce

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
	ld hl, $c340
	add hl, de
	res 6, [hl]

jr_018_63ce:
	ret


	db $ff, $ff, $ff, $ff, $6c, $00, $6c, $20, $68, $00, $6a, $00, $60, $00, $62, $00
	db $64, $00, $66, $00

Jump_018_63e3:
	ld de, $63cf
	call Call_3C3B
	call Call_18_7D61
	call Call_18_7D83
	ldh a, [$fff0]
	rst $00

JumpTable_18_63F2::
	dw Jump_18_63FA
	dw Jump_18_6403
	dw Jump_18_6429
	dw Jump_18_645C

Jump_18_63FA::
	call Call_0891
	ld [hl], $30
	call Call_3B8D
	ret


Jump_18_6403::
	call Call_0891
	jr nz, jr_018_641d

	call Call_27ED
	and $3f
	add $70
	ld [hl], a
	call Call_27ED
	and $07
	add $05
	call Call_3C25
	call Call_3B8D

jr_018_641d:
	ld e, $01
	cp $18
	jr nc, jr_018_6424

	inc e

jr_018_6424:
	ld a, e
	call Call_3B87
	ret


Jump_18_6429::
	call Call_18_7DCD
	call Call_3B9E
	call Call_3BB4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_018_6440

	call Call_0891
	jr nz, jr_018_644e

jr_018_6440:
	call Call_0891
	ld [hl], $30
	call Call_3B8D
	ld hl, $c340
	add hl, bc
	set 6, [hl]

jr_018_644e:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add $03
	call Call_3B87
	ret


Jump_18_645C::
	call Call_0891
	jp z, Call_18_7E76

	ld e, $01
	cp $18
	jr c, jr_018_6469

	inc e

jr_018_6469:
	ld a, e
	call Call_3B87
	ret


Call_18_646E::
	push bc
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $01
	ldh [$ffdb], a
	and $f0
	ldh [$ffce], a
	swap a
	ld hl, $c210
	add hl, bc
	ld c, a
	ld a, [hl]
	sub $07
	ldh [$ffdc], a
	and $f0
	ldh [$ffcd], a
	or c
	ld c, a
	ld b, $00
	ld hl, $d711
	ld a, h
	add hl, bc
	ld h, a
	pop bc
	ld a, [hl]
	ldh [$ffaf], a
	ld e, a
	ld a, [$dba5]
	ld d, a
	call Call_29DB
	ldh [$ffda], a
	ret


	db $ec, $14

Call_18_64A7::
	call Call_18_68C6
	ldh a, [$ffea]
	cp $01
	jp z, Call_18_7E7C

	call Call_18_7D61
	call Call_3F12
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_64c5

	inc [hl]
	call Call_0887
	ld [hl], $20

jr_018_64c5:
	call Call_088C
	jr z, jr_018_64e5

	ld a, [$c13e]
	and a
	cp $01
	jr nz, jr_018_64d7

	ld hl, $fff2
	ld [hl], $33

jr_018_64d7:
	and a
	jr nz, jr_018_64e5

	ld a, $02
	ldh [$ffa1], a
	ld a, $6a
	ldh [$ff9d], a
	call Call_18_6990

jr_018_64e5:
	call Call_18_7D83
	call Call_3BE0
	ld a, [$c13e]
	and a
	jr nz, jr_018_64f4

	call Call_3BB4

jr_018_64f4:
	call Call_18_7DCD
	call Call_3B9E
	call Call_18_7E06
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
	and a
	jr z, jr_018_6519

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b
	call Call_3DAF

jr_018_6519:
	call Call_18_65AB
	call Call_18_7E20
	ld hl, $c380
	add hl, bc
	ld [hl], e
	call Call_18_7E30
	cp $00
	jr z, jr_018_6536

	ld d, b
	ld hl, $64a3
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_018_6536:
	ldh a, [$ffe8]
	and a
	jr z, jr_018_6563

	ld hl, $c320
	add hl, bc
	ld [hl], $10
	call Call_27ED
	and $0f
	sub $08
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_18_7E20
	add $28
	cp $50
	jr c, jr_018_6563

	ld a, $08
	call Call_3C30
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a

jr_018_6563:
	call Call_18_6572
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Call_18_6572::
	call Call_088C
	jr z, jr_018_657b

	ld a, $03
	jr jr_018_6594

jr_018_657b:
	call Call_0887
	jr nz, jr_018_65aa

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $05
	jr nc, jr_018_658e

	inc [hl]
	ld a, $01
	jr jr_018_6594

jr_018_658e:
	call Call_27ED
	and $03
	inc a

Jump_018_6594:
jr_018_6594:
	ld [$d205], a
	cp $01
	jr nz, jr_018_659f

	ld a, $0a
	ldh [$fff4], a

jr_018_659f:
	call Call_0891
	ld [hl], $00
	ld hl, $c3d0
	add hl, bc
	ld [hl], $00

jr_018_65aa:
	ret


Call_18_65AB::
	ld a, [$d205]
	and a
	ret z

	pop de
	dec a
	rst $00

JumpTable_18_65B3::
	dw Jump_18_65C8
	dw Jump_18_661F
	dw Jump_18_66A9
	dw Jump_18_65C8

	db $01, $01, $01, $02, $02, $03, $03, $03, $03, $03, $02, $02, $01

Jump_18_65C8::
	call Call_0891
	jr nz, jr_018_65e7

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $0d
	jp z, Jump_018_65e8

	inc [hl]
	ld e, a
	ld d, b
	ld hl, $65bb
	add hl, de
	ld a, [hl]
	call Call_3B87
	call Call_0891
	ld [hl], $01

jr_018_65e7:
	ret


Jump_018_65e8:
	call Call_27ED
	and $03
	jp z, Jump_018_6706

	ld a, $01
	jp Jump_018_6594


	db $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $07, $08, $08, $08
	db $08, $08, $07, $06, $01, $08, $10, $08, $08, $02, $00, $00, $00, $fc, $f8, $f0
	db $f8, $e0, $90, $a0, $00, $00, $00, $00, $00, $00

Jump_18_661F::
	call Call_0891
	jr nz, jr_018_6654

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $15
	jp z, Jump_018_6706

	inc [hl]
	ld e, a
	ld d, b
	ld hl, $65f5
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $660a
	add hl, de
	ld e, [hl]
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_664a

	ld a, e
	cpl
	inc a
	ld e, a

jr_018_664a:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	call Call_0891
	ld [hl], $03

jr_018_6654:
	ret


	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $0a, $0a, $0b, $0b, $0c, $0c
	db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $0d, $0e, $0f, $10, $11, $11, $11, $01, $0c, $0c, $0c, $0c, $0c, $0c
	db $0c, $0c, $08, $08, $08, $08, $08, $08, $08, $08, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $e0, $d0, $c0, $c0, $e0
	db $f0, $00, $00, $00

Jump_18_66A9::
	call Call_0891
	jr nz, jr_018_6705

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $2a
	jp z, Jump_018_6706

	ld e, a
	cp $28
	jr nz, jr_018_66c4

	ld a, [$c11c]
	cp $0a
	jr z, jr_018_66c5

jr_018_66c4:
	inc [hl]

jr_018_66c5:
	ld d, b
	ld hl, $6655
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $667f
	add hl, de
	ld e, [hl]
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_66df

	ld a, e
	cpl
	inc a
	ld e, a

jr_018_66df:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	call Call_088C
	jr z, jr_018_6700

	call Call_18_7E20
	add $30
	cp $60
	jr c, jr_018_6700

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $18
	jr nc, jr_018_6700

	ld a, $10
	call Call_3C25

jr_018_6700:
	call Call_0891
	ld [hl], $03

jr_018_6705:
	ret


Jump_018_6706:
	xor a
	ld [$d205], a
	call Call_0887
	call Call_27ED
	and $0f
	add $0c
	ld [hl], a
	ret


	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $ff, $f8, $6c, $00, $ff, $00, $6e, $00
	db $00, $00, $64, $00, $00, $08, $66, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $00, $60, $00, $00, $08, $62, $00
	db $fd, $f8, $6c, $00, $fd, $00, $6e, $00, $fd, $f0, $6c, $00, $fd, $f8, $6e, $00
	db $00, $f8, $6e, $20, $00, $00, $6c, $20, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $6e, $20, $00, $08, $6c, $20, $00, $00, $64, $00, $00, $08, $66, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $fd, $08, $6e, $20, $fd, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $f8, $6c, $00, $00, $00, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $f0, $6c, $00, $00, $f8, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $00, $e8, $6c, $00, $00, $f0, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $f8, $10, $6c, $00, $f8, $18, $6e, $00
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $f0, $08, $6c, $00, $f0, $10, $6e, $00, $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $fc, $08, $6e, $20, $fc, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $00, $10, $6e, $20, $00, $18, $6c, $20, $00, $00, $68, $00, $00, $08, $6a, $00
	db $fd, $f8, $6e, $20, $fd, $00, $6c, $20, $04, $08, $6e, $20, $04, $10, $6c, $20
	db $00, $00, $68, $00, $00, $08, $6a, $00, $fd, $f8, $6e, $20, $fd, $00, $6c, $20
	db $08, $00, $6c, $00, $08, $08, $6e, $00, $00, $00, $64, $00, $00, $08, $66, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $08, $f8, $6c, $00, $08, $00, $6e, $00
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $05, $f0, $6c, $00, $05, $f8, $6e, $00, $00, $00, $60, $00, $00, $08, $62, $00
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $f4, $f0, $6e, $20, $f4, $f8, $6c, $20
	db $00, $00, $60, $00, $00, $08, $62, $00, $00, $00, $ff, $00, $00, $00, $ff, $00

Call_18_68C6::
	ld a, $80
	ld [$d5c0], a
	ld [$d5c2], a
	ldh a, [$fff1]
	sla a
	sla a
	ld d, b
	sla a
	ld e, a
	rl d
	sla a
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	xor a
	ldh [$ffe8], a
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_68f7

	inc a
	ldh [$ffe8], a
	ld hl, $ffed
	set 5, [hl]

jr_018_68f7:
	ld hl, $6716
	add hl, de
	ld c, $06
	push hl
	ld a, [$c3c0]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de
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

jr_018_6918:
	ld a, [$d5c2]
	cp $80
	jr nz, jr_018_6925

	ld a, [hl]
	add $08
	ld [$d5c2], a

jr_018_6925:
	ldh a, [$ffec]
	add [hl]
	ld [de], a
	inc hl
	inc de
	push bc
	ld a, [$c155]
	ld c, a
	ld b, [hl]
	ldh a, [$ffe8]
	and a
	jr z, jr_018_693c

	ld a, b
	cpl
	inc a
	add $08
	ld b, a

jr_018_693c:
	ld a, [$d5c0]
	cp $80
	jr nz, jr_018_694e

	ldh a, [$ffe8]
	and a
	ld a, b
	jr nz, jr_018_694b

	add $08

jr_018_694b:
	ld [$d5c0], a

jr_018_694e:
	ldh a, [$ffee]
	add b
	sub c
	ld [de], a
	inc hl
	inc de
	pop bc
	ld a, [hli]
	ld [de], a
	cp $ff
	jr nz, jr_018_6960

	dec de
	xor a
	ld [de], a
	inc de

jr_018_6960:
	inc de
	ldh a, [$ffed]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_018_6918

	ld a, $08
	ld [$d5c1], a
	ld a, $04
	ld [$d5c3], a
	ld a, [$c123]
	ld c, a
	ld a, $06
	call Call_3DD0
	jp Call_3D19


	db $00, $fe, $fd, $fe, $00, $02, $03, $02, $00, $04, $08, $0c, $10, $0c, $08, $04

Call_18_6990::
	ld hl, $c010
	ldh a, [$ffe7]
	rra
	rra
	rra
	push af
	and $07
	call Call_18_69A3
	pop af
	add $04
	and $07

Call_18_69A3::
	push bc
	push hl
	ld e, a
	ld d, $00
	ld hl, $6980
	add hl, de
	ld b, [hl]
	ld hl, $6988
	add hl, de
	ld c, [hl]
	pop hl
	ldh a, [$ff99]
	add b
	add $f6
	ld [hli], a
	ldh a, [$ff98]
	add c
	add $fc
	ld [hli], a
	ld [hl], $24
	inc hl
	ld [hl], $00
	inc hl
	pop bc
	ret


Call_18_69C7::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_018_6eed

	and a
	jp nz, Jump_018_6f3e

	ldh a, [$ffea]
	cp $01
	jr nz, jr_018_6a3c

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $0c
	ldh [$ffe8], a
	call Call_18_69FC
	ld a, $f4
	ldh [$ffe8], a
	call Call_18_69FC
	call Call_3F88
	jp Call_18_7E76


Call_18_69FC::
	ld a, $bd
	call Call_3C01
	jr c, jr_018_6a3b

	ld hl, $c460
	add hl, bc
	ld a, [hl]
	ld hl, $c460
	add hl, de
	ld [hl], a
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
	ld [hl], $01
	ldh a, [$ffe8]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	ld hl, $c360
	add hl, de
	ld [hl], $01

jr_018_6a3b:
	ret


jr_018_6a3c:
	call Call_18_6EC9
	ldh a, [$fff6]
	ld hl, $c3e0
	add hl, bc
	cp [hl]
	jr z, jr_018_6a56

	ldh a, [$ffee]
	cp $98
	jp nc, Call_18_7E76

	ldh a, [$ffec]
	cp $70
	jp nc, Call_18_7E76

jr_018_6a56:
	call Call_18_7D61
	call Call_18_7D83
	call Call_18_7DCD
	call Call_18_7E06
	ldh a, [$fff0]
	rst $00

JumpTable_18_6A65::
	dw Jump_18_6A75
	dw Jump_18_6A96
	dw Jump_18_6B68
	dw Jump_18_6BA9
	dw Jump_18_6CB9
	dw Jump_18_6CE5
	dw Jump_18_6D36
	dw Jump_18_6D4F

Jump_18_6A75::
	ld hl, $c360
	add hl, bc
	ld [hl], $03
	call Call_0891
	ld [hl], $c0
	ld hl, $c450
	add hl, bc
	ld [hl], $80
	call Call_3DAF
	ld hl, $c240
	add hl, bc
	ld [hl], $08
	jp Call_3B8D


	db $08, $f8, $08, $f8

Jump_18_6A96::
	call Call_18_6E08
	call Call_18_7E20
	add $1c
	cp $38
	jr nc, jr_018_6acd

	call Call_18_7E40
	add $20
	cp $40
	jr nc, jr_018_6acd

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
	call Call_3B8D
	ld [hl], $03
	ld hl, $c2c0
	add hl, bc
	ld [hl], $ff

jr_018_6acd:
	ld hl, $c450
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6ae0

	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $20
	ret


jr_018_6ae0:
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	sub $28
	jr z, jr_018_6afb

	ld e, $08
	and $80
	jr nz, jr_018_6af6

	ld e, $f8

jr_018_6af6:
	ld hl, $c320
	add hl, bc
	ld [hl], e

jr_018_6afb:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_018_6b16

	ld e, a
	ld d, b
	ld hl, $6a93
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld [hl], $00

jr_018_6b16:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	rra
	rra
	and $03
	jr z, jr_018_6b33

	ld e, a
	ld d, b
	ld hl, $6a91
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], $00

jr_018_6b33:
	call Call_0891
	jr nz, jr_018_6b46

	call Call_27ED
	and $7f
	add $40
	ld [hl], a
	ld hl, $c2f0
	add hl, bc
	ld [hl], $10

jr_018_6b46:
	ld hl, $c2f0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6b5a

	cp $08
	jr nz, jr_018_6b55

	call Call_18_6D65

jr_018_6b55:
	ld a, $02
	jp Call_3B87


jr_018_6b5a:
	call Call_18_6E25

Jump_018_6b5d:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_18_6B68::
	call Call_0891
	jr nz, jr_018_6ba0

	call Call_3B8D
	ld [hl], $03
	ldh a, [$ff99]
	push af
	sub $14
	ldh [$ff99], a
	ld a, $20
	call Call_3C25
	pop af
	ldh [$ff99], a
	ld hl, $c320
	add hl, bc
	ld [hl], $ec
	ld hl, $c450
	add hl, bc
	ld [hl], $30
	call Call_27ED
	and $03
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	and a
	jr nz, jr_018_6b9f

	call Call_0891
	ld [hl], $10

jr_018_6b9f:
	ret


jr_018_6ba0:
	call Call_18_6CA0
	ld a, $02
	call Call_3B87
	ret


Jump_18_6BA9::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_018_6bf4

	call Call_18_7E20
	add $18
	cp $30
	jr nc, jr_018_6bf4

	call Call_18_7E40
	add $18
	cp $30
	jr nc, jr_018_6bf4

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6bf4

	ld a, [$c137]
	and a
	jr z, jr_018_6bf4

	ld a, $20
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
	call Call_0891
	ld [hl], $0b
	call Call_3B8D
	ld [hl], $06
	ret


jr_018_6bf4:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_018_6c05

	and a
	jr nz, jr_018_6c30

	call Call_0891
	jr nz, jr_018_6c30

jr_018_6c05:
	ld a, $20
	call Call_3C30
	ldh a, [$ffd7]
	cpl
	inc a
	ld hl, $c250
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_018_6c1b

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_018_6c1b:
	dec [hl]
	dec [hl]
	ldh a, [$ffd8]
	cpl
	inc a
	ld hl, $c240
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_018_6c2e

	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]

jr_018_6c2e:
	dec [hl]
	dec [hl]

jr_018_6c30:
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $40
	jr c, jr_018_6c45

	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_018_6c45

	ld [hl], b
	jr jr_018_6c55

jr_018_6c45:
	ld hl, $c320
	add hl, bc
	ldh a, [$ffe7]
	and $01
	jr nz, jr_018_6c50

	inc [hl]

jr_018_6c50:
	ld a, [hl]
	and $80
	jr nz, Call_18_6C85

jr_018_6c55:
	ld hl, $c450
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6c6d

	ldh a, [$ffee]
	cp $a8
	jr nc, jr_018_6c6d

	ldh a, [$ffec]
	cp $90
	jr c, Call_18_6C85

	cp $c0
	jr nc, Call_18_6C85

jr_018_6c6d:
	call Call_3B8D
	ld [hl], $04
	call Call_18_6CA0
	call Call_0891
	call Call_27ED
	and $3f
	add $20
	ld [hl], a
	ld a, $ff
	jp Call_3B87


Call_18_6C85::
	call Call_3BB4
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6c9a

	call Call_3DAF
	ld hl, $c2c0
	add hl, bc
	ld [hl], $ff
	ret


jr_018_6c9a:
	call Call_18_6E25
	jp Jump_018_6b5d


Call_18_6CA0::
	call Call_3DAF
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ret


	db $00, $00, $d0, $d0, $40, $40, $80, $80, $08, $98, $38, $78, $f8, $a8, $f8, $a8

Jump_18_6CB9::
	call Call_0891
	jr nz, jr_018_6ce4

	ld hl, $c310
	add hl, bc
	ld [hl], $28
	call Call_3B8D
	ld [hl], $05
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $6ca9
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $6cb1
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a

jr_018_6ce4:
	ret


Jump_18_6CE5::
	ld a, $08
	call Call_3C25
	ldh a, [$ffee]
	cp $09
	jr c, jr_018_6d1f

	cp $97
	jr nc, jr_018_6d1f

	ldh a, [$ffec]
	cp $20
	jr c, jr_018_6d1f

	cp $70
	jr nc, jr_018_6d1f

	call Call_3B8D
	ld [hl], $01
	ld hl, $c450
	add hl, bc
	call Call_27ED
	and $3f
	add $20
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_018_6d1f:
	jp Jump_018_6b5d


	db $00, $09, $12, $15, $18, $15, $12, $09, $00, $f7, $ee, $eb, $e8, $eb, $ee, $f7
	db $00, $09, $12, $15

Jump_18_6D36::
	call Call_0891
	jr nz, jr_018_6d45

	ld [hl], $20
	call Call_3B8D
	ld [hl], $07
	jp Call_18_6CA0


jr_018_6d45:
	cp $08
	jr c, jr_018_6d4c

	call Call_18_6C85

jr_018_6d4c:
	jp Jump_018_6b5d


Jump_18_6D4F::
	call Call_0891
	jr nz, jr_018_6d60

	ld hl, $c2c0
	add hl, bc
	ld [hl], $ff
	call Call_3B8D
	ld [hl], $03
	ret


jr_018_6d60:
	cp $08
	jp nz, Jump_018_6e03

Call_18_6D65::
	ld a, $0d
	ldh [$fff4], a
	ldh a, [$ff99]
	push af
	sub $08
	ldh [$ff99], a
	ld a, $1f
	call Call_3C30
	pop af
	ldh [$ff99], a
	call Call_18_7B1B
	and $0f
	ldh [$ffe8], a
	ld e, $00
	call Call_18_6D86
	ld e, $01

Call_18_6D86::
	ldh a, [$ffe8]
	add e
	and $0f
	ldh [$ffe8], a
	ld e, $0f
	ld d, b

jr_018_6d90:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_018_6dab

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $bd
	jr nz, jr_018_6dab

	ld hl, $c2b0
	add hl, de
	ld a, [hl]
	cp $02
	jr nz, jr_018_6dab

	inc b

jr_018_6dab:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_6d90

	ld a, b
	ld b, $00
	cp $03
	jr nc, jr_018_6e02

	ld a, $bd
	call Call_3C01
	jr c, jr_018_6e02

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $ffda
	sub [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c340
	add hl, de
	ld [hl], $02
	ld hl, $c360
	add hl, de
	ld [hl], $4c
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $6d26
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $6d22
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	pop bc

jr_018_6e02:
	ret


Jump_018_6e03:
	ld a, $02
	jp Call_3B87


Call_18_6E08::
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $28
	ld [hl], a
	ldh a, [$ffef]
	sub $28
	ldh [$ffef], a
	call Call_3B9E
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $28
	ld [hl], a
	call Call_3DBA
	ret


Call_18_6E25::
	ld e, $0f

jr_018_6e27:
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $05
	jr nz, jr_018_6e9e

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $03
	jr z, jr_018_6e42

	cp $00
	jr z, jr_018_6e42

	cp $02
	jr nz, jr_018_6e9e

jr_018_6e42:
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	sub [hl]
	add $18
	cp $30
	jr nc, jr_018_6e9e

	ld hl, $c210
	add hl, de
	ldh a, [$ffec]
	sub [hl]
	add $20
	cp $40
	jr nc, jr_018_6e9e

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
	push de
	ld a, $20
	call Call_3C30
	pop de
	ldh a, [$ffd8]
	cpl
	inc a
	jr nz, jr_018_6e7b

	ld a, $20

jr_018_6e7b:
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$ffd7]
	cpl
	inc a
	jr nz, jr_018_6e88

	ld a, $20

jr_018_6e88:
	ld hl, $c250
	add hl, bc
	ld [hl], a
	pop af
	ldh [$ff98], a
	pop af
	ldh [$ff99], a
	call Call_3B8D
	ld [hl], $03
	ld hl, $c2c0
	add hl, bc
	ld [hl], $01

jr_018_6e9e:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_6e27

	ret


	db $00, $fc, $60, $00, $00, $04, $62, $00, $00, $0c, $60, $20, $00, $fc, $64, $00
	db $00, $04, $66, $00, $00, $0c, $64, $20, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $68, $20

Call_18_6EC9::
	ldh a, [$fff1]
	cp $ff
	ret z

	rla
	rla
	and $fc
	ld e, a
	rla
	and $f8
	add e
	ld e, a
	ld d, b
	ld hl, $6ea5
	add hl, de
	ld c, $03
	call Call_3D26
	jp Call_3D19


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20

Jump_018_6eed:
	ld de, $6ee5
	call Call_3C3B
	call Call_18_7D61
	call Call_08E2
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BEB
	call Call_3BBF
	jr c, jr_018_6f1f

	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_6f22

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953

jr_018_6f1f:
	jp Call_18_7E76


jr_018_6f22:
	call Call_18_7DCD
	call Call_0891
	ret nz

	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Call_18_7E76

	ret


	db $6c, $00, $6c, $20, $6e, $00, $6e, $20

Jump_018_6f3e:
	ld de, $6f36
	call Call_3C3B
	call Call_18_7D61
	call Call_18_7D83
	call Call_18_7DCD
	ldh a, [$ffe7]
	and $03
	jr nz, jr_018_6f63

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	sub $10
	jr z, jr_018_6f63

	and $80
	jr z, jr_018_6f62

	inc [hl]
	inc [hl]

jr_018_6f62:
	dec [hl]

jr_018_6f63:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_18_6F70::
	dw Jump_18_6F76
	dw Jump_18_6F84
	dw Jump_18_6F94

Jump_18_6F76::
	call Call_0891
	jr nz, jr_018_6f83

	ld [hl], $20
	call Call_3DAF
	call Call_3B8D

jr_018_6f83:
	ret


Jump_18_6F84::
	call Call_0891
	jr nz, jr_018_6f93

	ld [hl], $20
	ld a, $20
	call Call_3C25
	call Call_3B8D

jr_018_6f93:
	ret


Jump_18_6F94::
	call Call_3BB4
	call Call_0891
	ret nz

	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Call_18_7E76

	ret


Call_18_6FA8::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_018_7166

	ld hl, $c340
	add hl, bc
	set 6, [hl]
	call Call_18_7144
	call Call_380E
	call Call_3F12
	call Call_18_7D61
	ld a, [$c18f]
	and a
	jr z, jr_018_6ffa

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_6fda

	inc [hl]
	ld a, $25
	call Call_2197
	jp Call_18_7F2B


jr_018_6fda:
	cp $01
	jr nz, jr_018_6fe3

	ld a, $3f
	ldh [$fff4], a
	inc [hl]

jr_018_6fe3:
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	call Call_18_7E06
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $78
	ret c

	call Call_27BD
	jp Call_18_7E76


jr_018_6ffa:
	ldh a, [$fff0]
	rst $00

JumpTable_18_6FFD::
	dw Jump_18_700B
	dw Jump_18_7013
	dw Jump_18_702B
	dw Jump_18_7067
	dw Jump_18_70DC
	dw Jump_18_70F8
	dw Jump_18_710C

Jump_18_700B::
	ld a, $07
	ld [$d205], a
	jp Call_3B8D


Jump_18_7013::
	call Call_0891
	ld [hl], $80
	xor a
	ld [$d201], a
	ld [$d202], a
	ld a, [$d205]
	inc a
	and $07
	ld [$d205], a
	jp Call_3B8D


Jump_18_702B::
	call Call_0891
	jr nz, jr_018_705a

	ld [hl], $ff
	ld hl, $c430
	add hl, bc
	res 1, [hl]
	ld e, $0f
	ld d, b

jr_018_703b:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $bc
	jr nz, jr_018_7051

	ld hl, $c2b0
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_018_7051

	ld hl, $c280
	add hl, de
	ld [hl], b

jr_018_7051:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_018_703b

	jp Call_3B8D


jr_018_705a:
	ret


	db $78, $68, $58, $48, $38, $28, $00, $00, $00, $00, $00, $00

Jump_18_7067::
	call Call_0891
	jr nz, jr_018_7076

	ld hl, $c430
	add hl, bc
	set 1, [hl]
	call Call_3B8D
	xor a

jr_018_7076:
	and $1f
	jr nz, Call_18_70CF

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $06
	jr nc, Call_18_70CF

	ld a, $bc
	call Call_3C01
	jr c, Call_18_70CF

	ld a, $31
	ldh [$fff2], a
	ld hl, $c3d0
	add hl, bc
	push bc
	ld c, [hl]
	inc [hl]
	ld hl, $705b
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $7061
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c310
	add hl, de
	ld [hl], $1c
	ld hl, $c3d0
	add hl, de
	ld [hl], c
	ld hl, $c430
	add hl, de
	ld a, [hl]
	and $7b
	ld [hl], a
	ld hl, $c360
	add hl, de
	ld [hl], $01
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c340
	add hl, de
	set 6, [hl]
	pop bc

Call_18_70CF::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_18_70DC::
	ld a, [$d201]
	cp $06
	jr nz, jr_018_70f4

	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	xor a
	ld [$d201], a
	call Call_0891
	ld [hl], $40
	call Call_3B8D

jr_018_70f4:
	call Call_18_70CF
	ret


Jump_18_70F8::
	call Call_0891
	jr nz, jr_018_710b

	ld a, $ff
	ld [$d201], a
	ld hl, $c450
	add hl, bc
	ld [hl], $40
	call Call_3B8D

jr_018_710b:
	ret


Jump_18_710C::
	ld hl, $c450
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7119

	call Call_3B8D
	ld [hl], $01

jr_018_7119:
	ld a, $02
	call Call_3B87
	ret


	db $c9, $00, $f8, $60, $00, $00, $00, $62, $00, $00, $08, $64, $00, $00, $f8, $66
	db $00, $00, $00, $62, $00, $00, $08, $64, $00, $10, $00, $68, $00, $00, $00, $62
	db $00, $00, $08, $64, $00

Call_18_7144::
	ldh a, [$fff1]
	rla
	rla
	and $fc
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $7120
	add hl, de
	ld c, $03
	call Call_3D26
	ld a, $01
	jp Call_3DD0


	db $6e, $00, $6e, $20, $6e, $40, $6e, $60

Jump_018_7166:
	ld de, $715e
	call Call_3C3B
	call Call_18_7D61
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_18_7175::
	dw Jump_18_71DF
	dw Jump_18_724C
	dw Jump_18_7269
	dw Jump_18_728C
	dw Jump_18_72B9

	db $28, $38, $48, $58, $68, $78, $38, $68, $48, $58, $48, $58, $18, $88, $28, $78
	db $60, $40, $28, $78, $78, $28, $60, $40, $28, $78, $28, $78, $50, $50, $38, $68
	db $50, $50, $38, $68, $38, $68, $38, $68, $38, $68, $28, $78, $38, $48, $68, $58
	db $20, $30, $40, $40, $30, $20, $60, $60, $50, $70, $70, $50, $38, $38, $58, $58
	db $70, $70, $30, $30, $70, $70, $50, $50, $30, $70, $70, $30, $30, $70, $40, $60
	db $70, $30, $60, $40, $30, $30, $50, $50, $70, $70, $40, $40, $50, $40, $50, $40

Jump_18_71DF::
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$d205]
	rla
	and $fe
	ld e, a
	rla
	and $fc
	add e
	ld hl, $c3d0
	add hl, bc
	add [hl]
	ld e, a
	ld d, b
	ld hl, $717f
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ld hl, $71af
	add hl, de
	ld a, [hl]
	ldh [$ff99], a
	ldh a, [$ffe7]
	xor c
	and $03
	jr nz, jr_018_7211

	ld a, $10
	call Call_3C25

jr_018_7211:
	ld hl, $ffee
	ldh a, [$ff98]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_018_7230

	ld hl, $ffec
	ldh a, [$ff99]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_018_7230

	ld hl, $d201
	inc [hl]
	call Call_3B8D

jr_018_7230:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a

Call_18_7236::
	call Call_18_7DCD

Jump_018_7239:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $04, $0c, $14, $1c, $24, $2c, $34, $3c

Jump_18_724C::
	ld a, [$d201]
	cp $ff
	jr nz, jr_018_7266

	ld hl, $c3d0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7244
	add hl, de
	ld a, [hl]
	ld hl, $c450
	add hl, bc
	ld [hl], a
	call Call_3B8D

jr_018_7266:
	jp Jump_018_7239


Jump_18_7269::
	ld hl, $c450
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7289

	ld hl, $c340
	add hl, bc
	res 6, [hl]
	ld a, $20
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $f4
	ld a, $31
	ldh [$fff2], a
	call Call_3B8D

jr_018_7289:
	jp Jump_018_7239


Jump_18_728C::
	call Call_3BB4
	call Call_18_7236
	call Call_18_7E06
	ldh a, [$ffe7]
	and $03
	jr nz, jr_018_72a5

	ld hl, $c320
	add hl, bc
	ld a, [hl]
	cp $0c
	jr z, jr_018_72a5

	inc [hl]

jr_018_72a5:
	ldh a, [$ffec]
	cp $88
	jr nc, jr_018_72b0

	ldh a, [$ffee]
	cp $a8
	ret c

jr_018_72b0:
	call Call_3B8D
	ld a, $ff
	call Call_3B87
	ret


Jump_18_72B9::
	ret


	db $7a, $10, $7e, $30, $7a, $30, $7e, $10, $7c, $10, $7c, $30

Call_18_72C6::
	ldh a, [$fff8]
	and $20
	jp nz, Call_18_7E76

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_72f5

	ld de, $72ba
	call Call_3CD0
	call Call_18_7D61
	call Call_18_7DCD
	call Call_18_7E06
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, Call_18_7E76

	ret


jr_018_72f5:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7301

	ld a, $07
	ldh [$fff1], a

jr_018_7301:
	call Call_18_763B
	ldh a, [$fff0]
	and a
	jr nz, jr_018_7328

	ld a, [$db4a]
	cp $02
	jr nz, jr_018_7328

	ld a, [$c166]
	and a
	jr z, jr_018_7328

	call Call_3B8D
	ld hl, $c430
	add hl, bc
	set 7, [hl]
	set 2, [hl]
	ld hl, $c360
	add hl, bc
	ld [hl], $10
	ret


jr_018_7328:
	ldh a, [$ffea]
	cp $05
	jr z, jr_018_7343

	call Call_18_7E7C
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7342

	ld hl, $d810
	set 5, [hl]
	ld a, $02
	ldh [$fff2], a

jr_018_7342:
	ret


jr_018_7343:
	call Call_18_7D61
	call Call_08E2
	call Call_3BEB
	ldh a, [$fff0]
	cp $05
	jr nc, jr_018_7357

	call Call_18_7CAF
	jr jr_018_735a

jr_018_7357:
	call Call_3BBF

jr_018_735a:
	ldh a, [$fff0]
	rst $00

JumpTable_18_735D::
	dw Jump_18_7375
	dw Jump_18_7376
	dw Jump_18_7389
	dw Jump_18_73D3
	dw Jump_18_7442
	dw Jump_18_7464
	dw Jump_18_748F
	dw Jump_18_74A0
	dw Jump_18_74B7
	dw Jump_18_74EC
	dw Jump_18_7508
	dw Jump_18_751C

Jump_18_7375::
	ret


Jump_18_7376::
	call Call_0891
	ld [hl], $80
	ld a, $39
	ld [$d368], a
	ldh [$ffb0], a
	ldh [$ffbd], a
	ldh [$ffbf], a
	jp Call_3B8D


Jump_18_7389::
	ldh a, [$ffee]
	ld hl, $c440
	add hl, bc
	ld [hl], a
	ldh a, [$ffec]
	ld hl, $c2d0
	add hl, bc
	sub $14
	ld [hl], a
	call Call_0891
	jr nz, jr_018_73a4

	ld [hl], $ff
	call Call_3B8D
	ret


jr_018_73a4:
	ld e, $08
	and $04
	jr z, jr_018_73ac

	ld e, $f8

jr_018_73ac:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	call Call_18_7DDA
	ret


	db $f8, $08, $10, $00, $00, $08, $f0, $00, $f0, $00, $f0, $f0, $f8, $08, $08, $f8
	db $f8, $08, $fc, $02, $fc, $02, $fc, $fc, $10, $10, $10, $10, $10, $10

Jump_18_73D3::
	call Call_0891
	jr nz, jr_018_73de

	ld [hl], $80
	call Call_3B8D
	ret


jr_018_73de:
	and $1f
	jr nz, jr_018_7441

	ldh a, [$fff1]
	cp $06
	jr z, jr_018_7436

	ld a, $13
	ldh [$fff4], a
	ld a, $7f
	call Call_3C01
	push bc
	ldh a, [$fff1]
	ld c, a
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $73b5
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $73bb
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $73c1
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $73c7
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $73cd
	add hl, bc
	ld a, [hl]
	ld hl, $c320
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], a
	pop bc

jr_018_7436:
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	cp $07
	jr z, jr_018_7441

	inc a
	ld [hl], a

jr_018_7441:
	ret


Jump_18_7442::
	call Call_0891
	jr nz, jr_018_744c

	ld [hl], $80
	jp Call_3B8D


jr_018_744c:
	ld e, $07
	cp $60
	jr nc, jr_018_745e

	cp $40
	jr nc, jr_018_745f

	cp $30
	jr c, jr_018_745e

	cp $20
	jr c, jr_018_745f

jr_018_745e:
	inc e

jr_018_745f:
	ld a, e
	call Call_3B87
	ret


Jump_18_7464::
	call Call_0891
	jr nz, jr_018_7485

	ld [hl], $40
	ld hl, $c340
	add hl, bc
	res 7, [hl]
	ld hl, $c430
	add hl, bc
	res 6, [hl]
	call Call_3B8D
	ldh a, [$ffee]
	ld [$d201], a
	ldh a, [$ffec]
	ld [$d202], a
	ret


jr_018_7485:
	ld hl, $c250
	add hl, bc
	ld [hl], $04
	call Call_18_7DD0
	ret


Jump_18_748F::
	call Call_0891
	jr nz, jr_018_749f

	ld [hl], $20
	ld hl, $c240
	add hl, bc
	ld [hl], $08
	call Call_3B8D

jr_018_749f:
	ret


Jump_18_74A0::
	call Call_0891
	jr nz, jr_018_74b3

	call Call_0891
	call Call_27ED
	and $1f
	add $08
	ld [hl], a
	call Call_3B8D

jr_018_74b3:
	call Call_18_7DDA
	ret


Jump_18_74B7::
	call Call_0891
	jr nz, jr_018_74eb

	ld hl, $c390
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $03
	jr c, jr_018_74d9

	call Call_27ED
	and $01
	jr nz, jr_018_74d9

	call Call_3B8D
	ld a, $09
	ld [hl], a
	call Call_0891
	ld [hl], $20
	ret


jr_018_74d9:
	call Call_0891
	ld [hl], $40
	call Call_3B8D
	dec [hl]
	dec [hl]
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_018_74eb:
	ret


Jump_18_74EC::
	call Call_0891
	jr nz, jr_018_7507

	ld [hl], $20
	ld a, $18
	call Call_3C25
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	bit 7, [hl]
	jr z, jr_018_7504

	cpl
	inc a
	ld [hl], a

jr_018_7504:
	call Call_3B8D

jr_018_7507:
	ret


Jump_18_7508::
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7515

	call Call_0891
	jr nz, jr_018_7518

jr_018_7515:
	call Call_3B8D

jr_018_7518:
	call Call_18_7DCD
	ret


Jump_18_751C::
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$d201]
	ldh [$ff98], a
	ld a, [$d202]
	ldh [$ff99], a
	ld a, $08
	call Call_3C25
	ld a, [$d201]
	ld hl, $ffee
	sub [hl]
	add $01
	cp $02
	jr nc, jr_018_7555

	ld a, [$d202]
	ld hl, $ffec
	sub [hl]
	add $01
	cp $02
	jr nc, jr_018_7555

	call Call_3B8D
	ld [hl], $06
	call Call_0891
	ld [hl], $20

jr_018_7555:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_18_7DCD
	ret


	db $f0, $f8, $7a, $10, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $7e, $30, $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $7a, $30, $00, $00, $7e, $10, $00, $08, $7e, $30
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $7a, $30
	db $00, $00, $7e, $10, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $7c, $10
	db $f0, $08, $7c, $30, $f0, $10, $70, $20, $00, $00, $7e, $10, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $7c, $10, $f0, $08, $7c, $30, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $7c, $30, $f0, $10, $70, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $78, $00, $f0, $08, $78, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $f0, $f8, $70, $00, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $70, $20, $00, $00, $74, $00, $00, $08, $74, $20
	db $f0, $f8, $70, $00, $f0, $00, $72, $00, $f0, $08, $72, $20, $f0, $10, $70, $20
	db $00, $00, $74, $00, $00, $08, $74, $20, $76, $00, $76, $20

Call_18_763B::
	ldh a, [$fff1]
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	add e
	ld e, a
	ld d, b
	ld hl, $755f
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ldh a, [$ffea]
	cp $01
	jr z, jr_018_7662

	ldh a, [$fff0]
	cp $05
	jp c, Jump_018_76f7

jr_018_7662:
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	ldh [$ffe8], a
	ldh a, [$ffee]
	sub [hl]
	sra a
	ldh [$ffe1], a
	sra a
	ldh [$ffe2], a
	sra a
	ldh [$ffe3], a
	sra a
	ldh [$ffe4], a
	sra a
	ldh [$ffe5], a
	sra a
	ldh [$ffe6], a
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ldh [$ffe9], a
	ldh a, [$ffec]
	sub $20
	cp [hl]
	jr c, jr_018_76f7

	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld hl, $ffe1

jr_018_769a:
	ldh a, [$ffe8]
	add [hl]
	ldh [$ffee], a
	inc hl
	push hl
	ld de, $7637
	call Call_3C3B
	ld a, [$dbc7]
	and a
	jr nz, jr_018_76e8

	ld hl, $ffec
	ldh a, [$ff99]
	sub [hl]
	add $0c
	cp $18
	jr nc, jr_018_76e8

	ld hl, $ffee
	ldh a, [$ff98]
	sub [hl]
	ld e, a
	add $0c
	cp $18
	jr nc, jr_018_76e8

	ld a, e
	ld e, $20
	and $80
	jr z, jr_018_76cf

	ld e, $e0

jr_018_76cf:
	ld a, e
	ldh [$ff9a], a
	xor a
	ldh [$ff9b], a
	ld a, $18
	ld [$c13e], a
	ld a, $10
	ld [$dbc7], a
	ld a, $08
	ld [$db94], a
	ld a, $03
	ldh [$fff3], a

jr_018_76e8:
	pop hl
	ldh a, [$ffe9]
	ld e, a
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	sub e
	and $80
	jr z, jr_018_769a

Jump_018_76f7:
jr_018_76f7:
	call Call_3DBA
	ret


	db $62, $00, $64, $00, $60, $00, $60, $20, $64, $20, $62, $20, $66, $00, $68, $00
	db $60, $00, $60, $20, $68, $20, $66, $20, $6c, $00, $6e, $00, $6a, $00, $6a, $20
	db $6e, $20, $6c, $20, $00, $01, $02, $01, $03, $04, $05, $04, $06, $07, $08, $07

Call_18_772B::
	ld de, $76fb
	call Call_3C3B
	call Call_18_7D61
	call Call_18_7D83
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_18_773D::
	dw Jump_18_774B
	dw Jump_18_77A5

	db $fa, $fc, $00, $04, $06, $04, $00, $fc, $fa, $fc

Jump_18_774B::
	call Call_0891
	jr nz, jr_018_7770

	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $7743
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7741
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_018_7770:
	call Call_18_7DCD
	call Call_3B9E
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $771f
	and a
	jr z, Call_18_7796

	call Call_18_7D0E
	jr nc, jr_018_7793

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and $03
	add $7c
	inc [hl]
	call Call_218E

jr_018_7793:
	ld hl, $7727

Call_18_7796::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_18_77A5::
	call Call_0891
	jr nz, jr_018_77af

	call Call_3B8D
	ld [hl], b
	ret


jr_018_77af:
	ld hl, $7723
	call Call_18_7796
	ret


	db $00, $fc, $70, $00, $00, $04, $72, $00, $00, $0c, $70, $20, $00, $fc, $74, $00
	db $00, $04, $72, $00, $00, $0c, $74, $20, $00, $fc, $76, $00, $00, $04, $72, $00
	db $00, $0c, $76, $20, $00, $fc, $74, $00, $00, $04, $72, $00, $00, $0c, $74, $20
	db $10, $11, $12, $11

Call_18_77EA::
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
	ld hl, $77b6
	add hl, de
	ld c, $03
	call Call_3D26
	call Call_18_7D61
	call Call_3D19
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $77e6
	add hl, de
	ld a, [hl]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	call Call_18_7D83
	call Call_18_7DCD
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_18_7828::
	dw Jump_18_7838
	dw Jump_18_790B
	dw Jump_18_791C

	db $f8, $fa, $00, $06, $08, $06, $00, $fa, $f8, $fa

Jump_18_7838::
	call Call_0891
	jr nz, jr_018_786f

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	and $07
	ld e, a
	ld d, b
	ld hl, $7830
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $782e
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $07
	jr nz, jr_018_786c

	ld a, $0a
	call Call_3C25

jr_018_786c:
	call Call_3B8D

Jump_018_786f:
jr_018_786f:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $7f
	jr nz, jr_018_78ba

	ld a, $02
	call Call_3C01
	jr c, jr_018_78ba

	ld hl, $c430
	add hl, de
	res 0, [hl]
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
	ld hl, $c320
	add hl, de
	ld [hl], $08
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

jr_018_78ba:
	call Call_18_7E4F
	ldh a, [$ff9e]
	xor $01
	cp e
	jr nz, jr_018_78fe

	call Call_18_7E20
	add $20
	cp $40
	jr nc, jr_018_78fe

	call Call_18_7E40
	add $20
	cp $40
	jr nc, jr_018_78fe

	ld a, [$c137]
	and a
	jr z, jr_018_78fe

	call Call_3B8D
	ld [hl], $02
	call Call_0891
	ld [hl], $12
	ld a, $20
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
	ret


jr_018_78fe:
	call Call_3BB4

Jump_018_7901:
	ldh a, [$ffe7]
	rra
	rra
	and $03
	call Call_3B87
	ret


Jump_18_790B::
	call Call_0891
	jr nz, jr_018_7919

	ld [hl], $20
	call Call_3B8D
	ld [hl], b
	call Call_3DAF

jr_018_7919:
	jp Jump_018_786f


Jump_18_791C::
	call Call_0891
	jr nz, jr_018_7925

	call Call_3B8D
	ld [hl], b

jr_018_7925:
	jp Jump_018_7901


	db $6c, $74, $6d, $75, $64, $74, $65, $75

Call_18_7930::
	call Call_18_7A8A
	call Call_18_7D61
	ldh a, [$fff0]
	and a
	jp nz, Jump_018_7a02

	call Call_0891
	jp z, Jump_018_79eb

	cp $07
	jp nz, Jump_018_79ee

	push bc
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	add $07
	sub $08
	and $f0
	ldh [$ffce], a
	swap a
	ld hl, $c210
	add hl, bc
	ld c, a
	ld a, [hl]
	add $07
	sub $10
	and $f0
	ldh [$ffcd], a
	or c
	ld c, a
	ld b, $00
	ld hl, $d711
	ld a, h
	add hl, bc
	push bc
	pop de
	ld h, a
	pop bc
	ld a, [hl]
	ldh [$ffaf], a
	cp $d3
	jr z, jr_018_797d

	cp $5c
	jr nz, jr_018_7999

jr_018_797d:
	ld a, [$dba5]
	and a
	jr nz, jr_018_7999

	call Call_20A6
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $2f
	ldh [$fff2], a
	jr jr_018_79eb

jr_018_7999:
	ld a, [$dba5]
	and a
	jp z, Jump_018_79ee

	ldh a, [$ffaf]
	cp $ab
	jr nz, jr_018_7a01

	ld [hl], $ac
	ld d, h
	ld e, l
	ld hl, $c2b0
	add hl, bc
	ld [hl], d
	ld hl, $c2c0
	add hl, bc
	ld [hl], e
	ld hl, $c290
	add hl, bc
	ld [hl], $01
	call Call_0887
	ld [hl], $80
	ld hl, $c200
	add hl, bc
	ldh a, [$ffce]
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ldh a, [$ffcd]
	ld [hl], a
	ld hl, $c1a2
	inc [hl]
	ld a, [$c3cd]
	and a
	jr z, jr_018_79dc

	sub $04
	ld [$c3cd], a

jr_018_79dc:
	call Call_0891
	ld [hl], b
	ld a, $12
	ldh [$fff4], a
	ld de, $7928
	push de
	jp Jump_018_7aa7


Jump_018_79eb:
jr_018_79eb:
	jp Call_18_7E76


Jump_018_79ee:
	cp $10
	jr nc, jr_018_7a01

	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ld a, $09
	ld [$c19e], a
	call Call_3BF6

jr_018_7a01:
	ret


Jump_018_7a02:
	call Call_0887
	jr nz, jr_018_7a41

	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ldh [$ffce], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ldh [$ffcd], a
	ld hl, $c2b0
	add hl, bc
	ld d, [hl]
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld a, $ab
	ld [de], a
	call Call_18_7E76
	ldh a, [$fff6]
	cp $74
	ret z

	ld hl, $c1a2
	dec [hl]
	ld a, [$c3cd]
	cp $0c
	jr nc, jr_018_7a3a

	add $04
	ld [$c3cd], a

jr_018_7a3a:
	ld de, $792c
	push de
	jp Jump_018_7aa7


jr_018_7a41:
	ret


	db $06, $fe, $24, $00, $03, $04, $24, $10, $05, $0a, $24, $00, $05, $fe, $24, $10
	db $02, $04, $24, $00, $04, $0a, $24, $10, $03, $ff, $24, $00, $01, $04, $24, $10
	db $02, $09, $24, $00, $01, $00, $24, $10, $ff, $04, $24, $00, $00, $06, $24, $10
	db $00, $01, $24, $00, $fe, $03, $24, $10, $ff, $05, $24, $00, $ff, $01, $24, $10
	db $fd, $03, $24, $00, $fe, $05, $24, $10

Call_18_7A8A::
	call Call_0891
	jr z, jr_018_7aa6

	rra
	rra
	and $07
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $7a42
	add hl, de
	ld c, $03
	call Call_3D26

jr_018_7aa6:
	ret


Jump_018_7aa7:
	call Call_2839
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $0a
	ld [$d600], a
	pop de
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


	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

Call_18_7B1B::
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
	jr z, jr_018_7b36

	cpl
	inc a

jr_018_7b36:
	ld d, a
	ldh a, [$ffd7]
	bit 7, a
	jr z, jr_018_7b3f

	cpl
	inc a

jr_018_7b3f:
	cp d
	jr nc, jr_018_7b4f

	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $7adb
	add hl, de
	ld a, [hl]
	ret


jr_018_7b4f:
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $7afb
	add hl, de
	ld a, [hl]
	ret


	db $11, $10, $0f, $0e

Call_18_7B61::
	ld a, $02
	ldh [$ffa1], a
	ld [$c1a4], a
	ld [$c1c6], a
	ld a, c
	inc a
	ld [$c1a6], a
	xor a
	call Call_093B
	ld [$c13e], a
	ldh a, [$ff9e]
	ld e, a
	ld d, $00
	ld hl, $7b5d
	add hl, de
	ld a, [hl]
	ldh [$ff9d], a
	call Call_18_7C40
	call Call_18_7D61
	ldh a, [$ffe7]
	and $03
	jr nz, jr_018_7b93

	ld a, $0b
	ldh [$fff4], a

jr_018_7b93:
	ldh a, [$fff0]
	and a
	jr z, jr_018_7bb0

	ld a, $30
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
	pop bc
	jr jr_018_7bbd

jr_018_7bb0:
	call Call_18_7DCD
	call Call_0891
	jr nz, jr_018_7bcb

	ld a, $30
	call Call_3C25

jr_018_7bbd:
	call Call_3BD5
	jr nc, jr_018_7c25

	xor a
	ld [$c1c6], a
	call Call_18_7E76
	jr jr_018_7c25

jr_018_7bcb:
	ld a, $06
	ld [$c19e], a
	call Call_3BF6
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_018_7c26

	call Call_3B9E
	ld a, [$dba5]
	and a
	jr z, jr_018_7c25

	call Call_18_646E
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7c25

	ld e, $9e
	bit 7, a
	jr nz, jr_018_7bf7

	ld e, $9f

jr_018_7bf7:
	ldh a, [$ffaf]
	cp e
	jr nz, jr_018_7c25

	ld a, $68
	call Call_3C01
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
	ldh a, [$ffaf]
	cp $9e
	ld a, $00
	jr z, jr_018_7c1c

	inc a

jr_018_7c1c:
	ld hl, $c380
	add hl, de
	ld [hl], a
	call Call_0891
	ld [hl], b

jr_018_7c25:
	ret


jr_018_7c26:
	call Call_0891
	ld [hl], b
	ld a, $07
	ldh [$fff2], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $05
	call Call_0953
	ret


	db $36, $00, $36, $20

Call_18_7C40::
	ld de, $7c3c
	call Call_3C3B
	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	sra a
	sra a
	ldh [$ffd7], a
	ldh [$ffd9], a
	ldh a, [$ffef]
	ld hl, $ff99
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

jr_018_7c70:
	ldh [$ffdb], a
	ld hl, $ffe7
	xor [hl]
	and $01
	jr nz, jr_018_7c81

	ldh a, [$ff99]
	ld hl, $ffd8
	add [hl]
	ld [de], a

jr_018_7c81:
	inc de
	ldh a, [$ff98]
	ld hl, $ffd7
	add [hl]
	add $04
	ld [de], a
	inc de
	ld a, $24
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
	jr nz, jr_018_7c70

	ld a, $03
	call Call_3DD0
	ret


Call_18_7CAF::
	call Call_3BD5
	jr nc, jr_018_7cd3

Call_18_7CB4::
	call Call_094A
	call Call_0942
	ld a, [$c1a6]
	and a
	jr z, jr_018_7cd1

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_018_7cd1

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_018_7cd1:
	scf
	ret


jr_018_7cd3:
	and a
	ret


	db $06, $04, $02, $00

Call_18_7CD9::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7cd5
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


Call_18_7CF5::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $18
	cp $38
	jr Call_18_7D19

Call_18_7D02::
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $38
	jr Call_18_7D19

Call_18_7D0E::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28

Call_18_7D19::
	jr nc, jr_018_7d5f

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_018_7d5f

	inc e
	ldh a, [$ffeb]
	cp $c4
	jr z, jr_018_7d3a

	push de
	call Call_18_7E4F
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_018_7d5f

jr_018_7d3a:
	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_018_7d5f

	ld a, [$db9a]
	cp $80
	jr nz, jr_018_7d5f

	ldh a, [$ffcc]
	and $10
	jr z, jr_018_7d5f

	scf
	ret


jr_018_7d5f:
	and a
	ret


Call_18_7D61::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_018_7d81

Call_18_7D67::
	ld a, [$db95]
	cp $07
	jr z, jr_018_7d81

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_018_7d81

	ld a, [$c124]
	and a
	jr z, jr_018_7d82

jr_018_7d81:
	pop af

jr_018_7d82:
	ret


Call_18_7D83::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7dcc

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
	call Call_18_7DCD
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_018_7dbf

	call Call_3B9E

jr_018_7dbf:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_018_7dcc:
	ret


Call_18_7DCD::
	call Call_18_7DDA

Call_18_7DD0::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_18_7DDA
	pop bc
	ret


Call_18_7DDA::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7e05

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

jr_018_7df2:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_018_7dfc

	ld e, $f0

jr_018_7dfc:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_018_7e05:
	ret


Call_18_7E06::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_018_7e05

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_018_7df2

Call_18_7E20::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_018_7e2e

	inc e

jr_018_7e2e:
	ld d, a
	ret


Call_18_7E30::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_018_7e3e

	inc e

jr_018_7e3e:
	ld d, a
	ret


Call_18_7E40::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $ffec
	sub [hl]
	bit 7, a
	jr nz, jr_018_7e4d

	inc e

jr_018_7e4d:
	ld d, a
	ret


Call_18_7E4F::
	call Call_18_7E20
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_018_7e5c

	cpl
	inc a

jr_018_7e5c:
	push af
	call Call_18_7E30
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_018_7e6a

	cpl
	inc a

jr_018_7e6a:
	pop de
	cp d
	jr nc, jr_018_7e72

	ldh a, [$ffd7]
	jr jr_018_7e74

jr_018_7e72:
	ldh a, [$ffd8]

jr_018_7e74:
	ld e, a
	ret


Call_18_7E76::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


Call_18_7E7C::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_18_7E82::
	dw Jump_18_7E88
	dw Jump_18_7E99
	dw Jump_18_7EAA

Jump_18_7E88::
	call Call_0891
	ld [hl], $a0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff

Call_18_7E93::
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


Jump_18_7E99::
	call Call_0891
	jr nz, jr_018_7ea9

	ld [hl], $c0
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_18_7E93

jr_018_7ea9:
	ret


Jump_18_7EAA::
	call Call_0891
	jr nz, jr_018_7ebb

	call Call_08D7
	call Call_27BD
	call Call_18_7F2B
	jp Call_3F7A


jr_018_7ebb:
	call Call_18_7EBF
	ret


Call_18_7EBF::
	and $07
	jr nz, jr_018_7ee0

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
	call Call_18_7EE1

jr_018_7ee0:
	ret


Call_18_7EE1::
	call Call_18_7D67
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
	db $21, $20, $c3, $19, $36, $10, $21, $10, $c3, $19, $36, $08, $cd, $76, $7e, $21
	db $f4, $ff, $36, $1a, $c9

Call_18_7F2B::
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_018_7f40

	cp $06
	jr c, jr_018_7f40

	inc d

jr_018_7f40:
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
