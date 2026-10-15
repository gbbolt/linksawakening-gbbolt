; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $019", ROMX[$4000], BANK[$19]

	db $f0, $00, $48, $00, $f0, $08, $48, $20, $00, $00, $4a, $00, $00, $08, $4a, $20
	db $f0, $00, $78, $00, $f0, $08, $78, $20, $00, $00, $7a, $00, $00, $08, $7a, $20
	db $16, $00

Call_19_4022::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_404a

	ld de, $4020
	call Call_3CD0
	call Call_19_789F
	call Call_19_790B
	call Call_19_7944
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, Call_19_79B4

	ret


jr_019_404a:
	ld hl, $4000
	ldh a, [$fff7]
	cp $01
	jr nz, jr_019_4056

	ld hl, $4010

jr_019_4056:
	ld c, $04
	call Call_3D26
	call Call_3D19
	call Call_19_789F
	call Call_08E2
	call Call_3BEB
	ldh a, [$fff0]
	rst $00

JumpTable_19_406A::
	dw Jump_19_4070
	dw Jump_19_4123
	dw Jump_19_4123

Jump_19_4070::
	call Call_3B9E
	call Call_19_7804
	call Call_19_795E
	add $10
	cp $20
	jp nc, Jump_019_411c

	call Call_19_796E
	add $20
	cp $30
	jp nc, Jump_019_411c

	ld a, [$c19b]
	and a
	jp nz, Jump_019_411c

	ld a, [$db00]
	cp $03
	jr nz, jr_019_40a0

	ldh a, [$ffcb]
	and $20
	jr nz, jr_019_40ad

	jr jr_019_411c

jr_019_40a0:
	ld a, [$db01]
	cp $03
	jr nz, jr_019_411c

	ldh a, [$ffcb]
	and $10
	jr z, jr_019_411c

jr_019_40ad:
	ld a, [$c3cf]
	and a
	jr nz, jr_019_411c

	ld a, $01
	ldh [$ffa1], a
	ld [$c3cf], a
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
	jr z, jr_019_411c

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
	ld a, [$db43]
	cp $02
	jr nz, jr_019_411c

	ld e, $08
	ld a, [$d47c]
	and a
	jr z, jr_019_40f4

	ld e, $03

jr_019_40f4:
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp e
	jr c, jr_019_4122

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

Jump_019_411c:
jr_019_411c:
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	ret


jr_019_4122:
	ret


Jump_19_4123::
	call Call_19_790B
	call Call_19_7944
	call Call_3B9E
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0f
	jr nz, jr_019_4144

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_4169

jr_019_4144:
	call Call_19_4188
	ld a, [$c18e]
	and $1f
	cp $0b
	jr nz, jr_019_4169

	ld a, [$c50d]
	cp $35
	jr c, jr_019_415b

	cp $3d
	jr c, jr_019_4166

jr_019_415b:
	ld a, [$c503]
	cp $35
	jr c, jr_019_4169

	cp $3d
	jr nc, jr_019_4169

jr_019_4166:
	call Call_08EC

jr_019_4169:
	ret


	db $00, $08, $00, $08, $00, $08, $f8, $f8, $00, $00, $08, $08, $fc, $05, $fa, $06
	db $fb, $04, $fc, $f8, $fe, $ff, $03, $02, $18, $14, $13, $16, $12, $14

Call_19_4188::
	ld a, $00

jr_019_418a:
	ldh [$ffe8], a
	ld a, $9d
	call Call_3C01
	jr c, jr_019_41e7

	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $416a
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4170
	add hl, bc
	ldh a, [$ffd8]
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $4176
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $417c
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $4182
	add hl, bc
	ld a, [hl]
	ld hl, $c320
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [$ffe8]
	inc a
	cp $06
	jr nz, jr_019_418a

jr_019_41e7:
	ld a, $29
	ldh [$fff4], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ldh a, [$ffec]
	sub $10
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	jp Call_19_79B4


	db $17, $11, $36, $28, $45, $52, $7a, $64, $93, $a1, $c5, $d4, $28, $0e, $3f, $5d

Call_19_4216::
	ld a, [$dba5]
	and a
	jr nz, jr_019_4276

	ldh a, [$fff6]
	cp $ce
	jp nz, Jump_019_4405

	call Call_19_789F
	ld a, [$c146]
	and a
	ret nz

	ldh a, [$ff98]
	sub $50
	add $03
	cp $06
	ret nc

	ldh a, [$ff99]
	sub $46
	add $04
	cp $08
	ret nc

	ld a, $01
	ld [$d401], a
	ld a, $1f
	ld [$d402], a
	ld a, $f8
	ld [$d403], a
	ld a, $50
	ld [$d404], a
	ldh [$ff98], a
	ld a, $48
	ld [$d405], a
	ldh [$ff99], a
	ld a, $45
	ld [$d416], a
	ld a, $06
	ld [$c11c], a
	call Call_093B
	ld [$c198], a
	ld a, $51
	ld [$dbcb], a
	ld a, $0c
	ldh [$fff3], a
	jp Call_19_79B4


jr_019_4276:
	ld a, $01
	ld [$c19d], a
	ldh a, [$fff7]
	ld e, a
	ld d, b
	ld hl, $db65
	add hl, de
	ld a, [hl]
	and $01
	jp z, Jump_019_42de

	call Call_19_43A7
	ldh a, [$fff0]
	rst $00

JumpTable_19_428F::
	dw Jump_19_4297
	dw Jump_19_42A0
	dw Jump_19_42B6
	dw Jump_19_42F3

Jump_19_4297::
	call Call_3B8D
	ld a, $1b
	ld [$d368], a
	ret


Jump_19_42A0::
	call Call_19_795E
	add $04
	cp $08
	jr nc, jr_019_42b2

	call Call_19_796E
	add $04
	cp $08
	jr c, jr_019_42b5

jr_019_42b2:
	call Call_3B8D

jr_019_42b5:
	ret


Jump_19_42B6::
	ldh a, [$ffa2]
	and a
	jr nz, jr_019_42de

	call Call_19_795E
	add $03
	cp $06
	jr nc, jr_019_42de

	call Call_19_796E
	add $03
	cp $06
	jr nc, jr_019_42de

	call Call_3B8D
	ld a, $20
	ld [$c1c6], a
	call Call_0891
	ld [hl], $50
	ld a, $1c
	ldh [$fff2], a

Jump_019_42de:
jr_019_42de:
	ret


	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $54, $54, $54, $54, $00, $00, $00, $00
	db $00, $03, $01, $02

Jump_19_42F3::
	call Call_093B
	ld [$db94], a
	ld [$dbc7], a
	ld [$c13e], a
	ld [$c137], a
	ld [$c16a], a
	ld [$c166], a
	ld [$c1a9], a
	inc a
	ld [$c167], a
	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffec]
	ldh [$ff99], a
	call Call_0891
	jr nz, jr_019_4353

	ld hl, $d401
	ld a, $01
	ld [hli], a
	ldh a, [$fff7]
	ld [hli], a
	inc hl
	ld a, $50
	ld [hli], a
	push hl
	ldh a, [$fff7]
	ld e, a
	sla e
	ld d, $00
	ld hl, $4206
	add hl, de
	ldh a, [$fff6]
	cp [hl]
	jr nz, jr_019_433b

	inc hl

jr_019_433b:
	ld a, [hl]
	ld [$d403], a
	pop hl
	cp $64
	ld a, $48
	jr nz, jr_019_4348

	ld a, $28

jr_019_4348:
	ld [hl], a
	xor a
	ld [$c167], a
	call Call_19_79B4
	jp Call_092A


jr_019_4353:
	ld hl, $ffa1
	ld [hl], $01
	push af
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $42ef
	add hl, de
	ld a, [hl]
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc
	ld hl, $c440
	add hl, bc
	pop af
	cp $40
	jr nc, jr_019_4381

	and $03
	jr nz, jr_019_4381

	ld a, [hl]
	cp $0c
	jr z, jr_019_4381

	inc [hl]

jr_019_4381:
	ldh a, [$ffe7]
	and $03
	add [hl]
	ld e, a
	ld d, b
	ld hl, $42df
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ret


	db $1e, $00, $1e, $60, $1e, $40, $1e, $20, $f8, $fa, $00, $06, $08, $06, $00, $fa
	db $f8, $fa, $24, $00, $24, $00

Call_19_43A7::
	ld hl, $c340
	add hl, bc
	ld [hl], $c2
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ldh [$fff1], a
	ld de, $4391
	call Call_3C3B
	ld hl, $c340
	add hl, bc
	ld [hl], $c1
	xor a

jr_019_43c3:
	ldh [$ffe8], a
	ld e, a
	call Call_19_43D2
	ldh a, [$ffe8]
	add $02
	and $07
	jr nz, jr_019_43c3

	ret


Call_19_43D2::
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	add e
	and $07
	ld e, a
	ld d, b
	ld hl, $439b
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $4399
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld de, $43a3
	call Call_3CD0
	call Call_3DBA
	ret


	db $fa, $fc, $00, $04, $06, $04, $00, $fc, $fa, $fc, $3e, $00

Jump_019_4405:
	ld hl, $c340
	add hl, bc
	ld [hl], $c1
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ldh a, [$ffee]
	ldh [$ffe5], a
	ldh a, [$ffec]
	ldh [$ffe6], a
	xor a

jr_019_441c:
	ldh [$ffe8], a
	ld e, a
	call Call_19_442B
	ldh a, [$ffe8]
	add $02
	and $07
	jr nz, jr_019_441c

	ret


Call_19_442B::
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	add e
	and $07
	ld e, a
	ld d, b
	ld hl, $43fb
	add hl, de
	ldh a, [$ffe5]
	add [hl]
	ldh [$ffee], a
	ld hl, $43f9
	add hl, de
	ldh a, [$ffe6]
	add [hl]
	add $04
	ldh [$ffec], a
	ld de, $4403
	call Call_3CD0
	ret


	db $38, $10, $38, $30, $a4, $10, $ff, $ff, $38, $50, $38, $70, $ff, $ff, $a4, $30

Call_19_4461::
	ld a, $01
	ld [$c14d], a
	ld de, $4451
	call Call_3C3B
	call Call_19_789F
	call Call_29C5
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_4481

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

jr_019_4481:
	ld a, $08
	ld [$c19e], a
	call Call_3BF6
	call Call_19_790B
	call Call_3BA9
	call Call_19_44CF
	ldh a, [$fff0]
	rst $00

JumpTable_19_4495::
	dw Jump_19_4499
	dw Jump_19_44BB

Jump_19_4499::
	call Call_0891
	jr nz, jr_019_44a7

	ld a, $08
	call Call_3C25
	call Call_3B8D
	ret


jr_019_44a7:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_44ba

	call Call_0891
	ld [hl], b
	call Call_19_45A6
	ld a, $07
	ldh [$fff2], a

jr_019_44ba:
	ret


Jump_19_44BB::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_44c6

	ld a, $20
	call Call_3C25

jr_019_44c6:
	call Call_3BBF
	jr nc, jr_019_44ce

	call Call_19_79B4

jr_019_44ce:
	ret


Call_19_44CF::
	ld a, [$dba5]
	and a
	ret nz

	ldh a, [$ffaf]
	cp $d3
	jr z, jr_019_44dd

	cp $5c
	ret nz

jr_019_44dd:
	ld hl, $c2a0
	add hl, bc
	ld [hl], b
	ldh a, [$ffe9]
	ld e, a
	ld d, b
	call Call_20A6
	ldh a, [$ffce]
	add $08
	ldh [$ffd7], a
	ldh a, [$ffcd]
	add $10
	ldh [$ffd8], a
	ld a, $08
	call Call_0953
	ld a, $13
	ldh [$fff4], a
	ret


	db $00, $00, $08, $20, $00, $08, $06, $20, $00, $00, $06, $00, $00, $08, $08, $00
	db $00, $04, $04, $40, $ff, $ff, $ff, $ff, $00, $04, $04, $00, $ff, $ff, $ff, $ff
	db $00, $00, $fc, $04, $01, $01, $00, $00

Call_19_4527::
	ld hl, $c14d
	inc [hl]
	ldh a, [$fff0]
	and a
	jr nz, jr_019_4565

	ldh a, [$ff9e]
	ld e, a
	ld d, b
	ld hl, $451f
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ld hl, $4523
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $c240
	add hl, bc
	sla [hl]
	ld hl, $c250
	add hl, bc
	sla [hl]
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	ld a, $3b
	ldh [$fff2], a
	jp Call_3B8D


jr_019_4565:
	call Call_19_45B6
	call Call_19_789F
	ld a, $01
	ld [$c19e], a
	call Call_3BF6
	call Call_19_790B
	call Call_3BA9
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_45a3

	ldh a, [$ffe7]
	inc a
	and $03
	jr nz, jr_019_45a2

	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $0d
	call Call_0953
	ld hl, $c520
	add hl, de
	ld [hl], $08
	ldh a, [$fff1]
	ld hl, $c590
	add hl, de
	ld [hl], a

jr_019_45a2:
	ret


jr_019_45a3:
	call Call_19_79B4

Call_19_45A6::
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	add $03
	ldh [$ffd8], a
	ld a, $05
	call Call_0953
	ret


Call_19_45B6::
	ldh a, [$fff1]
	rla
	rla
	rla
	and $f8
	ld e, a
	ld d, b
	ld hl, $44ff
	add hl, de
	ld c, $02
	call Call_3D26
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Jump_019_45e9:
	ld hl, $c340
	add hl, bc
	set 6, [hl]
	set 7, [hl]
	ld a, [$db0e]
	cp $0e
	jp nz, Call_19_79B4

	ld hl, $c200
	add hl, bc
	ld [hl], $50
	ld de, $45c9
	call Call_3C3B
	call Call_19_7836
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_019_4616

	call Call_19_798D
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_019_4616:
	call Call_19_7804
	ldh a, [$fff0]
	rst $00

JumpTable_19_461C::
	dw Jump_19_4624
	dw Jump_19_4655
	dw Jump_19_4705
	dw Jump_19_46A9

Jump_19_4624::
	call Call_19_789F
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $26
	cp $4c
	call Call_19_785D
	ret nc

	ld a, [$db7d]
	cp $00
	jr z, jr_019_4641

	cp $0d
	jr nz, jr_019_464a

jr_019_4641:
	ld a, $21
	call Call_218E
	call Call_3B8D
	ret


jr_019_464a:
	ld a, $25
	call Call_218E
	call Call_3B8D
	ld [hl], $03
	ret


Jump_19_4655::
	call Call_19_789F
	call Call_3B8D
	ld a, [$c177]
	and a
	jr nz, jr_019_469b

	ld a, [$db00]
	and a
	jr z, jr_019_469b

	cp $01
	jr z, jr_019_46a2

	cp $04
	jr z, jr_019_46a2

	cp $03
	jr z, jr_019_46a2

	cp $02
	jr z, jr_019_46a2

	cp $09
	jr z, jr_019_46a2

	cp $0c
	jr z, jr_019_46a2

	cp $05
	jr z, jr_019_46a2

	ld [$db7d], a
	ld a, $0d
	ld [$db00], a
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_0891
	ld [hl], $80
	ld a, $10
	ld [$d368], a
	ret


jr_019_469b:
	ld [hl], b
	ld a, $23
	call Call_218E
	ret


jr_019_46a2:
	ld [hl], b
	ld a, $27
	call Call_218E
	ret


Jump_19_46A9::
	call Call_19_789F
	call Call_3B8D
	ld [hl], $02
	ld a, [$c177]
	and a
	jr nz, jr_019_46e2

	ld hl, $db00
	ld de, $0000

jr_019_46bd:
	ld a, [hl]
	cp $0d
	jr z, jr_019_46c9

	inc hl
	inc e
	ld a, e
	cp $0c
	jr nz, jr_019_46bd

jr_019_46c9:
	ld a, [$db7d]
	ld [hl], a
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	ld a, $0d
	ld [$db7d], a
	call Call_0891
	ld [hl], $80
	ld a, $10
	ld [$d368], a
	ret


jr_019_46e2:
	ld [hl], b
	ld a, $23
	call Call_218E
	ret


	db $00, $10, $84, $10, $80, $10, $82, $10, $86, $10, $88, $10, $8a, $10, $8c, $10
	db $98, $10, $90, $10, $92, $10, $96, $10, $8e, $10, $a4, $10

Jump_19_4705::
	call Call_0891
	jr nz, jr_019_470f

	call Call_3B8D
	ld [hl], b
	ret


jr_019_470f:
	cp $08
	jr nz, jr_019_4724

	dec [hl]
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $0d
	ld a, $24
	jr z, jr_019_4721

	ld a, $26

jr_019_4721:
	call Call_218E

jr_019_4724:
	ldh a, [$ff98]
	ldh [$ffee], a
	ldh a, [$ff99]
	sub $0c
	ldh [$ffec], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ld a, $6c
	ldh [$ff9d], a
	ld a, $02
	ldh [$ffa1], a
	call Call_093B
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ld de, $46e9
	call Call_3CD0
	call Call_3DBA
	ret


	db $6a, $20, $68, $20, $6e, $20, $6c, $20, $68, $00, $6a, $00, $6c, $00, $6e, $00
	db $64, $00, $66, $00, $66, $20, $64, $20, $60, $00, $62, $00, $62, $20, $60, $20
	db $00, $f4, $0c, $00, $0c, $f4

Call_19_4777::
	ldh a, [$fff7]
	cp $1f
	jp z, Jump_019_45e9

	ld de, $4751
	call Call_3C3B
	call Call_19_789F
	call Call_19_78C1
	ld hl, $c430
	add hl, bc
	ld [hl], $48
	call Call_19_798D
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	cp e
	jr nz, jr_019_47a3

	ld hl, $c430
	add hl, bc
	ld [hl], $08

jr_019_47a3:
	call Call_3BB4
	ld a, [$c133]
	and a
	jr nz, jr_019_47f5

	ldh a, [$ffcb]
	and $0f
	jr z, jr_019_47f5

	and $03
	ld e, a
	ld d, b
	ld hl, $4771
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$ffcb]
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $4774
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_19_790B
	call Call_3B9E
	ldh a, [$ff9e]
	xor $01
	ld hl, $c380
	add hl, bc
	ld [hl], a
	rla
	and $06
	ld e, a
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	rra
	and $01
	or e
	call Call_3B87

jr_019_47f5:
	ret


	db $02, $11, $c0, $30, $14, $02, $11, $c1, $50, $14, $02, $0f, $f5, $94, $52

Call_19_4805::
	call Call_19_789F
	call Call_0891
	jr z, jr_019_4827

	cp $01
	jr nz, jr_019_481a

	ld a, [$c11c]
	ld [$d463], a
	call Call_19_484B

jr_019_481a:
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, $04
	ld [$c13b], a
	ret


jr_019_4827:
	ld a, [$c11c]
	cp $01
	jr nz, jr_019_484a

	ldh a, [$ff9c]
	and a
	jr z, jr_019_484a

	call Call_19_795E
	add $0c
	cp $18
	jr nc, jr_019_484a

	call Call_19_796E
	add $0c
	cp $18
	jr nc, jr_019_484a

	call Call_0891
	ld [hl], $10

jr_019_484a:
	ret


Call_19_484B::
	ld de, $4800
	ldh a, [$fff6]
	cp $ea
	jr z, jr_019_4860

	ld de, $47f6
	ldh a, [$ff98]
	cp $30
	jr c, jr_019_4860

	ld de, $47fb

jr_019_4860:
	ld hl, $d401
	push bc
	ld c, $05

jr_019_4866:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_4866

	pop bc
	call Call_19_79B4
	ldh a, [$ff98]
	swap a
	and $0f
	ld e, a
	ldh a, [$ff99]
	sub $08
	and $f0
	or e
	ld [$d416], a
	jp Call_090F


	db $58, $00, $5a, $00, $58, $00, $5c, $00, $5a, $20, $58, $20, $5c, $20, $58, $20

Call_19_4894::
	ld hl, $c360
	add hl, bc
	ld [hl], $4c
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_48a8

	ldh a, [$fff1]
	add $02
	ldh [$fff1], a

jr_019_48a8:
	ld de, $4884
	call Call_3C3B
	call Call_19_789F
	call Call_08E2
	call Call_19_7944
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_019_48ce

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_019_48ce:
	ld a, [$c3c8]
	and a
	jr z, jr_019_4901

	ld hl, $c340
	add hl, bc
	set 6, [hl]
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c200
	add hl, de
	ldh a, [$ffee]
	ld e, $00
	cp [hl]
	jr c, jr_019_48eb

	inc e

jr_019_48eb:
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_019_48fc

	ld hl, $c320
	add hl, bc
	ld [hl], $0c

jr_019_48fc:
	call Call_19_49B7
	jr jr_019_4904

jr_019_4901:
	call Call_3BEB

jr_019_4904:
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_491d

	cp $08
	jr nz, jr_019_491d

	call Call_3B8D
	ld a, $02
	ld [hl], a
	ldh [$fff0], a
	call Call_0891
	ld [hl], $10

jr_019_491d:
	ldh a, [$fff0]
	cp $02
	jr nc, jr_019_493a

	call Call_19_7852
	jr nc, jr_019_493a

	ld a, [$c3c8]
	and a
	ld a, $20
	jr z, jr_019_4937

	ld a, $96
	call Call_2185
	jr jr_019_493a

jr_019_4937:
	call Call_2197

jr_019_493a:
	ld a, [$c3c8]
	and a
	ret nz

	ldh a, [$fff0]
	rst $00

JumpTable_19_4942::
	dw Jump_19_4952
	dw Jump_19_4995
	dw Jump_19_49C2
	dw Jump_19_49E8

	db $02, $08, $0c, $08, $fe, $f8, $f4, $f8

Jump_19_4952::
	xor a
	call Call_3B87
	call Call_0891
	jr nz, jr_019_4992

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $494a
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
	ld hl, $494a
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

jr_019_4992:
	jp Call_19_49B7


Jump_19_4995::
	call Call_19_790B
	call Call_3B9E
	ldh a, [$ffe8]
	and a
	jr z, Call_19_49B7

	call Call_0891
	jr nz, jr_019_49ac

	ld [hl], $30
	call Call_3B8D
	ld [hl], b
	ret


jr_019_49ac:
	ld hl, $c320
	add hl, bc
	ld [hl], $08
	ld hl, $c310
	add hl, bc
	inc [hl]

Call_19_49B7::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_19_49C2::
	call Call_0891
	jr nz, jr_019_49de

	call Call_3B8D
	ld a, $24
	call Call_3C25
	ld hl, $c320
	add hl, bc
	ld [hl], $18
	call Call_19_795E
	ld hl, $c380
	add hl, bc
	ld a, e
	ld [hl], a

jr_019_49de:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_19_49E8::
	call Call_19_790B
	call Call_3B9E
	ld hl, $c340
	add hl, bc
	ld [hl], $52
	call Call_3BBF
	ld hl, $c340
	add hl, bc
	ld [hl], $92
	ldh a, [$ffe8]
	and a
	jr z, jr_019_4a0b

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $20

jr_019_4a0b:
	ret


	db $60, $78, $78, $60, $40, $28, $28, $40, $20, $38, $58, $78, $78, $58, $38, $20

Call_19_4A1C::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_4b22

	ld a, c
	ld [$d461], a
	ldh a, [$fff8]
	and $10
	jp nz, Call_19_79B4

	ldh a, [$fff0]
	rst $00

JumpTable_19_4A33::
	dw Jump_19_4A3D
	dw Jump_19_4A5F
	dw Jump_19_4A6F
	dw Jump_19_4A93
	dw Jump_19_4AC3

Jump_19_4A3D::
	ld a, [$db49]
	and $04
	ret z

	ld a, [$db4a]
	cp $00
	ret nz

	ld a, [$c166]
	cp $01
	ret nz

	call Call_27D2
	call Call_0891
	ld [hl], $30
	xor a
	ld [$c5a3], a
	call Call_3B8D
	ret


Jump_19_4A5F::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, jr_019_4a6e

	call Call_3B8D

jr_019_4a6e:
	ret


Jump_19_4A6F::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	ret nz

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	cp $08
	jr nz, jr_019_4a8a

	ld [hl], b
	call Call_0891
	ld [hl], $40
	jp Call_3B8D


jr_019_4a8a:
	call Call_19_4AC4
	call Call_0891
	ld [hl], $20
	ret


Jump_19_4A93::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_019_4ac2

	ld e, $41
	ld hl, $db67

jr_019_4aa1:
	ld a, [hli]
	and $02
	jr z, jr_019_4aac

	inc e
	ld a, e
	cp $47
	jr nz, jr_019_4aa1

jr_019_4aac:
	ld a, e
	ld [$d368], a
	ld [$d465], a
	ld a, $ff
	ld [$c166], a
	xor a
	ld [$d210], a
	ld [$d211], a
	call Call_3B8D

jr_019_4ac2:
	ret


Jump_19_4AC3::
	ret


Call_19_4AC4::
	ldh [$ffe8], a
	ld e, a
	ld d, b
	ld hl, $db65
	add hl, de
	ld a, [hl]
	and $02
	jr z, jr_019_4b01

	ld a, $de
	call Call_3C01
	ret c

	ld a, $2b
	ldh [$fff4], a
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $4a0c
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	add $08
	ld [hl], a
	ld hl, $4a14
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld a, c
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	inc [hl]
	pop bc

jr_019_4b01:
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $58, $00, $5a, $00, $5c, $00, $5e, $00
	db $60, $00, $62, $00, $64, $00, $66, $00, $68, $00, $6a, $00, $6c, $00, $6e, $00

Jump_019_4b22:
	cp $02
	jp z, Jump_019_4bf8

	ldh a, [$fff0]
	and a
	jr nz, jr_019_4b71

	ld a, [$c5a3]
	cp $03
	jr z, jr_019_4b46

	ld hl, $fff1
	ldh a, [$ffe7]
	rra
	rra
	rra
	xor [hl]
	and $03
	ret z

	ld de, $4b02
	call Call_3C3B
	ret


jr_019_4b46:
	ldh a, [$fff1]
	cp $07
	jp nz, Call_19_79B4

	ld e, $08
	ld hl, $db65

jr_019_4b52:
	ld a, [hli]
	and $02
	jr z, jr_019_4b6a

	dec e
	jr nz, jr_019_4b52

	ldh a, [$fff8]
	and $10
	jp nz, Call_19_79B4

	call Call_0891
	ld [hl], $a0
	call Call_3B8D
	ret


jr_019_4b6a:
	xor a
	ld [$c5a3], a
	jp Call_19_79B4


jr_019_4b71:
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, jr_019_4be3

	ld [$c155], a
	ld [$c5a3], a
	ld a, $c1
	ld [$d736], a
	ld a, $cb
	ld [$d746], a
	ld a, $50
	ldh [$ffce], a
	ld a, $20
	ldh [$ffcd], a
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $07
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $1f
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $7f
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ld a, $7e
	ld [hli], a
	ld a, $1f
	ld [hli], a
	ld [hl], b
	call Call_27D2
	ld a, $23
	ldh [$fff2], a
	call Call_19_4C3E
	call Call_08D7
	jp Call_19_79B4


jr_019_4be3:
	ld e, $01
	and $04
	jr z, jr_019_4beb

	ld e, $ff

jr_019_4beb:
	ld a, e
	ld [$c155], a
	ret


	db $16, $00, $16, $20, $16, $60, $16, $40

Jump_019_4bf8:
	ld de, $4bf0
	call Call_3CD0
	call Call_19_790B
	ld hl, $c250
	add hl, bc
	inc [hl]
	call Call_0891
	ld [$c167], a
	jr z, jr_019_4c13

	ld a, $02
	ldh [$ffa1], a
	ret


jr_019_4c13:
	ld hl, $d806
	set 4, [hl]
	ld a, [hl]
	ldh [$fff8], a
	jp Call_19_79B4


	db $00, $04, $08, $00, $08, $00, $04, $08, $00, $00, $00, $04, $04, $08, $08, $08
	db $f0, $fc, $10, $f0, $10, $f0, $04, $10, $f0, $e8, $f0, $f8, $f8, $08, $0c, $08

Call_19_4C3E::
	xor a

jr_019_4c3f:
	ldh [$ffe8], a
	ld a, $de
	call Call_3C01
	ret c

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	call Call_27ED
	and $1f
	add $30
	ld hl, $c2e0
	add hl, de
	ld [hl], a
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $4c1e
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	add $54
	ld [hl], a
	ld hl, $4c26
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	add $3c
	ld [hl], a
	ld hl, $4c2e
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $4c36
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	sub $08
	ld [hl], a
	pop bc
	ldh a, [$ffe8]
	inc a
	cp $08
	jr nz, jr_019_4c3f

	ret


	db $58, $00, $5a, $00, $5a, $20

Call_19_4C9A::
	ldh a, [$fff1]
	and a
	jr z, jr_019_4ca7

	ld de, $4c92
	call Call_3C3B
	jr jr_019_4cad

jr_019_4ca7:
	ld de, $4c94
	call Call_3CD0

jr_019_4cad:
	call Call_19_789F
	ldh a, [$fff0]
	rst $00

JumpTable_19_4CB3::
	dw Jump_19_4CBF
	dw Jump_19_4D01

	db $02, $04, $06, $00, $0a, $08, $0c, $0d

Jump_19_4CBF::
	ld a, [$db95]
	cp $07
	jr z, jr_019_4cca

	xor a
	ld [$c5a2], a

jr_019_4cca:
	xor a
	call Call_3B87
	call Call_19_7852
	ret nc

	ld e, $00
	ldh a, [$ffee]
	cp $20
	jr c, jr_019_4ce5

	inc e
	cp $40
	jr c, jr_019_4ce5

	inc e
	cp $70
	jr c, jr_019_4ce5

	inc e

jr_019_4ce5:
	ldh a, [$ffef]
	cp $40
	jr c, jr_019_4cef

	ld a, e
	add $04
	ld e, a

jr_019_4cef:
	ld d, b
	ld hl, $4cb7
	add hl, de
	ld a, [hl]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_218E
	call Call_3B8D
	ret


Jump_19_4D01::
	ld a, $01
	call Call_3B87
	ld a, [$c19f]
	and a
	ret nz

	call Call_3B8D
	ld [hl], b
	ld a, [$c177]
	and a
	jr nz, jr_019_4d64

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	inc a
	ld e, a
	cp $0e
	jr nz, jr_019_4d46

	ld a, [$db0e]
	cp $0e
	jr nz, jr_019_4d46

	ldh a, [$fff8]
	and $20
	jr nz, jr_019_4d3b

	call Call_19_7A66
	call Call_27ED
	rla
	rla
	rla
	and $18
	ld [$db7c], a

jr_019_4d3b:
	ld a, [$db7c]
	rra
	rra
	rra
	and $03
	add $17
	ld e, a

jr_019_4d46:
	ld a, e
	cp $0d
	jr nz, jr_019_4d60

	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$db96], a
	ld a, $07
	ld [$db95], a
	ld a, $01
	ld [$c5a2], a
	ret


jr_019_4d60:
	call Call_218E
	ret


jr_019_4d64:
	xor a
	jp Call_3B87


Jump_019_4d68:
	ldh a, [$fff8]
	and $20
	jp nz, Call_19_79B4

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_4f00

	ldh a, [$fff0]
	rst $00

JumpTable_19_4D7B::
	dw Jump_19_4D89
	dw Call_19_4DCD
	dw Jump_19_4DD7
	dw Jump_19_4E11
	dw Jump_19_4E42

	db $60, $00, $62, $00

Jump_19_4D89::
	ld a, c
	ld [$d201], a
	ld hl, $c200
	add hl, bc
	ld [hl], $50
	call Call_19_4DCD
	ld a, [$db49]
	and $01
	ret z

	ld a, [$c166]
	cp $01
	ret nz

	ld a, [$db4a]
	cp $02
	ret nz

	ld a, $dc
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $94
	ld hl, $c210
	add hl, de
	ld [hl], $d8
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld hl, $c340
	add hl, de
	ld [hl], $c1
	ld a, $55
	ld [$d368], a
	jp Call_3B8D


	db $c9

Call_19_4DCD::
	ld de, $4d85
	call Call_3C3B
	call Call_19_7804
	ret


Jump_19_4DD7::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_19_4DCD
	call Call_0891
	jr nz, jr_019_4e04

	ld [hl], $a0
	call Call_3B8D
	ld a, $02
	call Call_3C01
	ld hl, $c200
	add hl, de
	ldh a, [$ffd7]
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffd8]
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $20

jr_019_4e04:
	ret


	db $f0, $00, $64, $00, $00, $00, $66, $00, $00, $08, $68, $00

Jump_19_4E11::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld hl, $4e05
	ld c, $03
	call Call_3D26
	call Call_0891
	jp z, Jump_019_4e30

	cp $70
	jr nz, jr_019_4e2f

	ld a, $10
	ld [$d368], a

jr_019_4e2f:
	ret


Jump_019_4e30:
	ldh a, [$ff99]
	push af
	ld a, $10
	ldh [$ff99], a
	ld a, $6d
	call Call_2185
	pop af
	ldh [$ff99], a
	jp Call_3B8D


Jump_19_4E42::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld hl, $4e05
	ld c, $03
	call Call_3D26
	ld a, [$c19f]
	and a
	jr nz, jr_019_4e79

	ld a, $d5
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld a, $01
	ld [$db7b], a
	xor a
	ld [$c167], a
	call Call_19_7A66
	jp Call_19_79B4


jr_019_4e79:
	ret


	db $6a, $00, $6c, $00, $6e, $00, $02, $02, $01, $01, $04, $04, $04, $04, $04, $04
	db $04, $04, $05, $06, $07, $08, $07, $06, $05, $04, $04, $04, $03, $02, $01, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $08, $08, $09, $0a, $0b, $0c, $0c, $0c
	db $0b, $0a, $09, $08, $07, $06, $05, $04, $05, $06, $07, $08, $09, $0a, $0b, $0b
	db $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01, $00, $01, $02, $03, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $00, $03, $06, $07, $08, $07, $06, $03, $00, $fd, $fa, $f9, $f8, $f9
	db $fa, $fd, $00, $03, $06, $07

Jump_019_4f00:
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ld de, $4e7a
	call Call_3CD0
	call Call_19_789F
	call Call_0891
	jr z, jr_019_4f2a

	cp $01
	jp z, Call_19_79B4

	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $4e80
	add hl, de
	ld a, [hl]
	jp Call_3B87


jr_019_4f2a:
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	jr nz, jr_019_4f5f

	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $49
	jr nz, jr_019_4f5f

	ld a, [$d201]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	inc [hl]
	ld hl, $c420
	add hl, de
	ld [hl], $40
	ld hl, $c2e0
	add hl, de
	ld [hl], $80
	jp Call_19_79B4


jr_019_4f5f:
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $4e84
	add hl, de
	ld e, [hl]
	ld hl, $4ef0
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4eec
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_19_790B
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $07
	jr nz, jr_019_4faa

	ld a, $dc
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
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $1f

jr_019_4faa:
	ret


	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $20, $60, $20, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
	db $70, $00, $72, $00, $74, $00, $76, $00, $72, $20, $70, $20, $76, $20, $74, $20
	db $f2, $0e

Jump_019_4fdd:
	ld hl, $c340
	add hl, bc
	ld [hl], $d2
	ld de, $4fab
	call Call_3C3B
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_4ff7

	inc [hl]
	ld a, $57
	ld [$d368], a

jr_019_4ff7:
	ld a, [$db6b]
	and a
	jp nz, Jump_019_5090

	call Call_19_789F
	call Call_19_7804
	ldh a, [$ffe7]
	and $7f
	jr nz, jr_019_5014

	call Call_27ED
	and $02
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_019_5014:
	ldh a, [$ffe7]
	ld e, $00
	and $30
	jr z, jr_019_501d

	inc e

jr_019_501d:
	ld hl, $c380
	add hl, bc
	ld a, e
	add [hl]
	call Call_3B87
	ldh a, [$ffe7]
	and $3f
	cp $0f
	jr nz, jr_019_505d

	ld a, $08
	call Call_3C01
	jr c, jr_019_505c

	push bc
	ld hl, $c380
	add hl, bc
	ld c, [hl]
	srl c
	ld hl, $4fdb
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
	ld hl, $c2e0
	add hl, de
	ld [hl], $17
	ld hl, $c440
	add hl, de
	inc [hl]
	pop bc

jr_019_505c:
	ret


jr_019_505d:
	call Call_19_7852
	jr nc, jr_019_506f

	ld a, [$db7b]
	and a
	ld a, $8b
	jr z, jr_019_506c

	ld a, $8c

jr_019_506c:
	call Call_2185

jr_019_506f:
	ret


	db $10, $11, $12, $13, $13, $12, $11, $10, $00, $09, $02, $09, $00, $f7, $fe, $f7
	db $0c, $09, $0a, $f7, $f4, $f7, $f6, $09, $03, $01, $00, $00, $00, $00, $01, $03

Jump_019_5090:
	ldh a, [$fff0]
	and a
	jr nz, jr_019_509e

	ld hl, $c210
	add hl, bc
	ld [hl], $50
	call Call_3B8D

jr_019_509e:
	ld e, $00
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_019_50ab

	ld e, $02

jr_019_50ab:
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5070
	add hl, de
	ld a, [hl]
	sub $03
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ld hl, $c380
	add hl, bc
	ldh a, [$ffe7]
	and $20
	ld a, $04
	jr nz, jr_019_50d3

	ld a, $05

jr_019_50d3:
	add [hl]
	call Call_3B87
	ldh a, [$ffec]
	sub $10
	ldh [$ffec], a
	ld hl, $c380
	add hl, bc
	ldh a, [$ffe7]
	rra
	rra
	and $01
	add [hl]
	ldh [$fff1], a
	ld hl, $c340
	add hl, bc
	res 4, [hl]
	ld de, $4fcb
	call Call_3C3B
	call Call_3DBA
	call Call_19_789F
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_019_5124

	call Call_27ED
	and $01
	jr nz, jr_019_5124

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5080
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5078
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_019_5124:
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	nop
	and $07
	ld e, a
	ld d, b
	ld hl, $5088
	add hl, de
	ldh a, [$ffe7]
	and [hl]
	call z, Call_19_790B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_019_514d

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_514d:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_019_515e

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_515e:
	call Call_19_795E
	add $12
	cp $24
	ret nc

	call Call_19_796E
	add $10
	cp $20
	ret nc

	call Call_0891
	ret nz

	ld [hl], $80
	ld a, $8d
	call Call_2185
	ret


	db $f0, $00, $78, $00, $f0, $08, $7a, $00, $00, $00, $7c, $00, $00, $08, $7e, $00

Call_19_518A::
	ld a, [$dba5]
	and a
	jr z, jr_019_519f

	ldh a, [$fff6]
	cp $e4
	jp z, Jump_019_4d68

	cp $f4
	jp z, Jump_019_4d68

	jp Jump_019_4fdd


jr_019_519f:
	ldh a, [$fff8]
	and $20
	jp nz, Call_19_79B4

	ldh a, [$fff0]
	rst $00

JumpTable_19_51A9::
	dw Jump_19_51AD
	dw Jump_19_5242

Jump_19_51AD::
	call Call_19_789F
	ld a, [$db43]
	cp $02
	ret c

	call Call_19_795E
	add $08
	cp $10
	jr nc, jr_019_523c

	call Call_19_796E
	add $10
	cp $20
	jr nc, jr_019_523c

	ld a, [$c133]
	and a
	jr z, jr_019_523c

	ldh a, [$ff9e]
	cp $02
	jr nz, jr_019_523c

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $18
	ret nz

	call Call_0891
	ld [hl], $40
	ld hl, $d746
	ld [hl], $0c
	ld hl, $d756
	ld [hl], $c6
	ld a, $50
	ldh [$ffce], a
	ld a, $30
	ldh [$ffcd], a
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0e
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ld a, $0f
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
	ld a, $83
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ld a, $69
	ld [hli], a
	ld a, $4b
	ld [hli], a
	ld [hl], b
	ld a, $11
	ldh [$fff4], a
	call Call_3B8D
	jr Jump_19_5242

jr_019_523c:
	ld hl, $c3d0
	add hl, bc
	ld [hl], b
	ret


Jump_19_5242::
	call Call_19_789F
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld hl, $517a
	ld c, $04
	call Call_3D26
	call Call_0891
	jr nz, jr_019_52b6

	ld [$c167], a
	ld hl, $d736
	ld [hl], $91
	ld hl, $d746
	ld [hl], $5e
	ld a, $50
	ldh [$ffce], a
	ld a, $20
	ldh [$ffcd], a
	call Call_2839
	ld hl, $d601
	ld a, [$d600]
	ld e, a
	add $0e
	ld [$d600], a
	ld d, $00
	add hl, de
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, $12
	ld [hli], a
	ldh a, [$ffcf]
	ld [hli], a
	ldh a, [$ffd0]
	inc a
	ld [hli], a
	ld a, $83
	ld [hli], a
	ld a, $6c
	ld [hli], a
	ld a, $6d
	ld [hli], a
	ld a, $03
	ld [hli], a
	ld a, $13
	ld [hli], a
	ld [hl], b
	ld a, $23
	ldh [$fff2], a
	call Call_19_7A66
	jp Call_19_79B4


jr_019_52b6:
	ld hl, $c250
	add hl, bc
	ld [hl], $fc
	call Call_19_790E
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $00, $04, $08, $04

Call_19_52E4::
	ldh a, [$ffe7]
	rla
	rla
	and $10
	ldh [$ffed], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $52e0
	add hl, de
	ld a, [hl]
	ldh [$fff5], a
	ld hl, $52c0
	ld c, $08
	call Call_3D26
	call Call_19_789F
	call Call_3BBF
	call Call_19_790B
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr z, jr_019_5322

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_5322:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $0c
	jr z, jr_019_5333

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_5333:
	ret


	db $7a, $40, $7a, $60, $7a, $50, $7a, $70, $7a, $00, $7a, $20, $7a, $10, $7a, $30

Call_19_5344::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_5451

	ldh a, [$fff0]
	rst $00

JumpTable_19_5350::
	dw Jump_19_5356
	dw Jump_19_536A
	dw Jump_19_53C3

Jump_19_5356::
	call Call_0891
	call Call_27ED
	and $3f
	add $30
	ld [hl], a
	jp Call_3B8D


	db $ff, $01, $fd, $03, $f4, $f4

Jump_19_536A::
	call Call_0891
	jr nz, jr_019_53c2

	ld a, [$c5a1]
	cp $02
	ret nc

	ld hl, $c250
	add hl, bc
	ld [hl], $d0
	call Call_3B8D

Call_19_537E::
	ld a, $01

jr_019_5380:
	ldh [$ffe9], a
	ld a, $da
	call Call_3C01
	ret c

	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ldh a, [$ffe9]
	ld c, a
	ld hl, $5364
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $5366
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $5368
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc
	ldh a, [$ffe9]
	dec a
	cp $ff
	jr nz, jr_019_5380

	ret


jr_019_53c2:
	ret


Jump_19_53C3::
	ld hl, $c5a0
	inc [hl]
	ld de, $5334
	call Call_3C3B
	call Call_19_789F
	call Call_3BBF
	call Call_19_790E
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld e, $00
	ld a, [hl]
	and $80
	jr nz, jr_019_53e4

	ld e, $02

jr_019_53e4:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	add e
	call Call_3B87
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_019_5400

	ld [hl], $70
	call Call_3B8D
	ld [hl], b
	call Call_19_537E

jr_019_5400:
	ldh a, [$ffe7]
	xor c
	and $0f
	ret nz

	ld a, $da
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
	ld hl, $c2e0
	add hl, de
	ld [hl], $18
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ldh a, [$fff1]
	rla
	and $04
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ret


	db $7c, $40, $7c, $60, $7c, $50, $7c, $70, $7e, $40, $7e, $60, $7e, $50, $7e, $70
	db $7c, $00, $7c, $20, $7c, $10, $7c, $30, $7e, $00, $7e, $20, $7e, $10, $7e, $30

Jump_019_5451:
	cp $02
	jr z, jr_019_5481

	ldh a, [$ffe7]
	xor c
	rra
	jr c, jr_019_546d

	ldh a, [$ffe7]
	rra
	rra
	and $01
	ld e, a
	ldh a, [$fff1]
	add e
	ldh [$fff1], a
	ld de, $5431
	call Call_3C3B

jr_019_546d:
	call Call_19_789F
	call Call_0891
	jp z, Call_19_79B4

	cp $08
	jr nz, jr_019_5480

	ld hl, $c3b0
	add hl, bc
	inc [hl]
	inc [hl]

jr_019_5480:
	ret


jr_019_5481:
	ld de, $5449
	call Call_3C3B
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	call Call_19_790B
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $10
	jr nz, jr_019_54a0

	call Call_19_79B4

jr_019_54a0:
	ret


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $52, $20, $00, $18, $50, $20
	db $10, $00, $54, $00, $10, $08, $56, $00, $10, $10, $56, $20, $10, $18, $54, $20

Call_19_54C1::
	ldh a, [$fff1]
	and a
	ld a, $00
	jr z, jr_019_54ca

	ld a, $08

jr_019_54ca:
	ldh [$fff5], a
	ld hl, $54a1
	ld c, $08
	call Call_3D26
	call Call_19_789F
	call Call_08E2
	ldh a, [$fff0]
	rst $00

JumpTable_19_54DD::
	dw Jump_19_54E3
	dw Jump_19_550B
	dw Jump_19_5565

Jump_19_54E3::
	call Call_19_7804
	ret nc

	and a
	ret z

	call Call_093B
	ldh a, [$ff9a]
	cpl
	inc a
	sra a
	sra a
	ldh [$ff9a], a
	ld a, $e8
	ldh [$ff9b], a
	call Call_0891
	ld [hl], $20
	ld a, $01
	call Call_3B87
	ld a, $0b
	ldh [$fff2], a
	jp Call_3B8D


Jump_19_550B::
	call Call_0891
	cp $01
	jr nz, jr_019_5517

	ld hl, $fff2
	ld [hl], $08

jr_019_5517:
	and a
	ret nz

	call Call_19_790E
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_5528

	add $03
	ld [hl], a

jr_019_5528:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	ldh a, [$ffef]
	add $10
	ldh [$ffef], a
	call Call_3B9E
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
	ldh a, [$ffef]
	sub $10
	ldh [$ffef], a
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_5564

	call Call_08D7
	call Call_0891
	ld [hl], $30
	ld a, $30
	ld [$c157], a
	ld a, $04
	ld [$c158], a
	call Call_3B8D

jr_019_5564:
	ret


Jump_19_5565::
	call Call_19_57DC
	ret


	db $00, $00, $01, $01, $01, $02, $02, $02, $00, $00, $0f, $0f, $0f, $0e, $0e, $0e
	db $08, $08, $07, $07, $07, $06, $06, $06, $08, $08, $09, $09, $09, $0a, $0a, $0a
	db $04, $04, $03, $03, $03, $02, $02, $02, $0c, $0c, $0d, $0d, $0d, $0e, $0e, $0e
	db $04, $04, $05, $05, $05, $06, $06, $06, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a

Call_19_55A9::
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
	jr z, jr_019_55c4

	cpl
	inc a

jr_019_55c4:
	ld d, a
	ldh a, [$ffd7]
	bit 7, a
	jr z, jr_019_55cd

	cpl
	inc a

jr_019_55cd:
	cp d
	jr nc, jr_019_55dd

	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $5569
	add hl, de
	ld a, [hl]
	ret


jr_019_55dd:
	ld a, d
	sra a
	sra a
	add h
	ld e, a
	ld d, b
	ld hl, $5589
	add hl, de
	ld a, [hl]
	ret


	db $5a, $00, $5a, $20, $58, $00, $58, $20

Call_19_55F3::
	ld de, $55eb
	call Call_3C3B
	call Call_19_789F
	call Call_08E2
	call Call_3BB4
	xor a
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_19_5609::
	dw Jump_19_5611
	dw Jump_19_561B
	dw Jump_19_5641
	dw Jump_19_567B

Jump_19_5611::
	ldh a, [$ffec]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_3B8D

Jump_19_561B::
	call Call_0891
	ret nz

	call Call_19_795E
	ld e, a
	add $28
	cp $50
	jr nc, jr_019_5640

	ld a, $01
	call Call_3B87
	ld a, e
	add $18
	cp $30
	jr nc, jr_019_5640

	call Call_3DAF
	call Call_0891
	ld [hl], $08
	call Call_3B8D

jr_019_5640:
	ret


Jump_19_5641::
	ld a, $01
	call Call_3B87
	call Call_0891
	cp $01
	jr nz, jr_019_5652

	ld hl, $fff2
	ld [hl], $08

jr_019_5652:
	and a
	ret nz

	call Call_19_790E
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_5663

	add $03
	ld [hl], a

jr_019_5663:
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_567a

	ld a, $09
	ldh [$fff2], a
	call Call_0891
	ld [hl], $30
	call Call_3B8D

jr_019_567a:
	ret


Jump_19_567B::
	call Call_0891
	ret nz

	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffec]
	cp [hl]
	jr nz, jr_019_5692

	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $20
	ret


jr_019_5692:
	ld hl, $c250
	add hl, bc
	ld [hl], $f8
	call Call_19_790E
	ret


	db $00, $00, $70, $00, $00, $08, $72, $00, $00, $10, $72, $20, $00, $18, $70, $20
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $76, $20, $10, $18, $74, $20
	db $ff, $00, $ff, $00, $6e, $00, $7e, $00, $7a, $00, $7a, $20, $7e, $20, $6e, $20
	db $7e, $20, $7c, $20, $7e, $20, $6c, $20, $78, $00, $78, $20, $6c, $00, $7e, $00
	db $7c, $00, $7e, $00, $04, $05, $06, $07, $08, $01, $02, $03

Call_19_56E8::
	ldh a, [$ffec]
	add $08
	ldh [$ffec], a
	ldh a, [$ffee]
	add $08
	ldh [$ffee], a
	ld de, $56bc
	call Call_3C3B
	call Call_3DBA
	ld hl, $569c
	ld c, $08
	call Call_3D26
	ld a, $06
	call Call_3DD0
	call Call_19_789F
	call Call_08E2
	call Call_3BEB
	call Call_19_57DC
	ldh a, [$fff0]
	rst $00

JumpTable_19_5719::
	dw Jump_19_5721
	dw Jump_19_572B
	dw Jump_19_576E
	dw Jump_19_57BA

Jump_19_5721::
	ldh a, [$ffec]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	call Call_3B8D

Jump_19_572B::
	call Call_0891
	ret nz

	call Call_19_795E
	add $f8
	ld e, a
	add $28
	cp $50
	jr nc, jr_019_5752

	ld a, e
	add $18
	cp $30
	jr nc, jr_019_5752

	call Call_3DAF
	ld a, $08
	ldh [$fff2], a
	ld a, $00
	call Call_3B87
	call Call_3B8D
	ret


jr_019_5752:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_019_576d

	ld a, $1f
	call Call_3C30
	call Call_19_55A9
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $56e0
	add hl, de
	ld a, [hl]
	call Call_3B87

jr_019_576d:
	ret


Jump_19_576E::
	call Call_19_790E
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $70
	jr nc, jr_019_577d

	add $03
	ld [hl], a

jr_019_577d:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	add $10
	ld [hl], a
	ldh a, [$ffef]
	add $10
	ldh [$ffef], a
	call Call_3B9E
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	ld [hl], a
	ldh a, [$ffef]
	sub $10
	ldh [$ffef], a
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_57b9

	call Call_08D7
	call Call_0891
	ld [hl], $30
	ld a, $30
	ld [$c157], a
	ld a, $04
	ld [$c158], a
	call Call_3B8D

jr_019_57b9:
	ret


Jump_19_57BA::
	call Call_0891
	ret nz

	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffec]
	cp [hl]
	jr nz, jr_019_57d2

	call Call_3B8D
	ld [hl], $01
	call Call_0891
	ld [hl], $20
	ret


jr_019_57d2:
	ld hl, $c250
	add hl, bc
	ld [hl], $f8
	call Call_19_790E
	ret


Call_19_57DC::
	call Call_3BD5
	ret nc

	call Call_19_796E
	add $08
	bit 7, a
	jr nz, jr_019_57fa

	call Call_3B93
	ld a, $10
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a
	ret


jr_019_57fa:
	ldh a, [$ff9b]
	and $80
	jr nz, jr_019_5812

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [$ff99], a
	ld a, $02
	ldh [$ff9b], a
	ld a, $01
	ld [$c147], a

jr_019_5812:
	ret


	db $5e, $00, $5e, $20

Call_19_5817::
	ld de, $5813
	call Call_3C3B
	call Call_19_789F
	ldh a, [$fff0]
	rst $00

JumpTable_19_5823::
	dw Jump_19_5829
	dw Jump_19_58B3
	dw Jump_19_58B3

Jump_19_5829::
	call Call_3BD5
	jr nc, jr_019_585c

	call Call_19_796E
	ld e, a
	add $03
	cp $06
	jr nc, jr_019_583b

	call Call_19_58D7

jr_019_583b:
	ldh a, [$ff9b]
	and $80
	jr nz, jr_019_585c

	call Call_19_796E
	add $08
	bit 7, a
	jr z, jr_019_585c

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	ldh [$ff99], a
	ld a, $02
	ldh [$ff9b], a
	ld a, $01
	ld [$c147], a

jr_019_585c:
	call Call_19_795E
	add $12
	cp $24
	ret nc

	call Call_19_796E
	add $12
	cp $24
	ret nc

	ld a, [$c19b]
	and a
	ret nz

	ld a, [$db00]
	cp $03
	jr nz, jr_019_587f

	ldh a, [$ffcc]
	and $20
	jr nz, jr_019_588a

	ret


jr_019_587f:
	ld a, [$db01]
	cp $03
	ret nz

	ldh a, [$ffcc]
	and $10
	ret z

jr_019_588a:
	ld a, [$c3cf]
	and a
	ret nz

	inc a
	ld [$c3cf], a
	ld hl, $c280
	add hl, bc
	ld [hl], $07
	ld hl, $c490
	add hl, bc
	ld [hl], b
	call Call_0891
	ld [hl], $02
	ld hl, $fff3
	ld [hl], $02
	call Call_3B8D
	ld [hl], $02
	ldh a, [$ff9e]
	ld [$c15d], a
	ret


Jump_19_58B3::
	call Call_19_790B
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr nz, jr_019_58c3

	cp $40
	jr nc, jr_019_58c5

jr_019_58c3:
	inc [hl]
	inc [hl]

jr_019_58c5:
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_58d6

	call Call_3E64
	call Call_19_79B4

jr_019_58d6:
	ret


Call_19_58D7::
	call Call_0942
	ld a, [$c146]
	and a
	jr nz, jr_019_58f3

	ld a, $02
	ld [$c13e], a
	call Call_19_795E
	ld a, e
	and a
	ld a, $10
	jr z, jr_019_58f0

	ld a, $f0

jr_019_58f0:
	ldh [$ff9a], a
	ret


jr_019_58f3:
	ldh a, [$ff9f]
	ldh [$ff98], a
	ret


	db $42, $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00
	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $48, $00, $48, $20, $4a, $00, $4a, $20

Call_19_5918::
	ld a, [$db7b]
	and a
	jp z, Call_19_79B4

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
	ld de, $58f8
	call Call_3C3B
	ldh a, [$ffea]
	cp $07
	jp z, Jump_019_5a78

	ld a, [$c11c]
	cp $01
	jr nz, jr_019_5949

	call Call_19_5A3C
	jr jr_019_596d

jr_019_5949:
	call Call_19_7944
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_5971

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], $10
	ld a, [$c146]
	ld e, a
	ld a, [$c14a]
	or e
	jr z, jr_019_596d

	ld [hl], $20

jr_019_596d:
	call Call_3B8D
	ld [hl], b

jr_019_5971:
	call Call_19_789F
	ldh a, [$fff0]
	and a
	jr nz, jr_019_59c1

	call Call_19_798D
	sla e
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	call Call_19_795E
	add $12
	cp $24
	jr nc, jr_019_599b

	call Call_19_796E
	add $12
	cp $24
	jr c, jr_019_59db

jr_019_599b:
	ldh a, [$ffe7]
	and $07
	jr nz, jr_019_59bb

	ld a, [$c14a]
	and a
	ld a, $0c
	jr z, jr_019_59ab

	ld a, $20

jr_019_59ab:
	ld e, a
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	push af
	push hl
	ld [hl], b
	ld a, e
	call Call_3C25
	pop hl
	pop af
	ld [hl], a

jr_019_59bb:
	call Call_19_790B
	jp Call_3B9E


jr_019_59c1:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_59cc

	inc [hl]
	inc [hl]

jr_019_59cc:
	dec [hl]
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_019_59d8

	inc [hl]
	inc [hl]

jr_019_59d8:
	dec [hl]
	jr jr_019_59bb

jr_019_59db:
	call Call_3DAF
	call Call_3BD5
	ret nc

	ld a, [$c19b]
	and a
	ret nz

	ld a, [$db00]
	cp $03
	jr nz, jr_019_59f5

	ldh a, [$ffcc]
	and $20
	jr nz, jr_019_5a00

	ret


jr_019_59f5:
	ld a, [$db01]
	cp $03
	ret nz

	ldh a, [$ffcc]
	and $10
	ret z

jr_019_5a00:
	ld a, [$c11c]
	cp $02
	ret nc

	ld a, [$c3cf]
	and a
	ret nz

	ld [$c11c], a
	inc a
	ld [$c3cf], a
	ld hl, $c280
	add hl, bc
	ld [hl], $07
	ld hl, $c490
	add hl, bc
	ld [hl], b
	call Call_0891
	ld [hl], $02
	ld hl, $fff3
	ld [hl], $02
	call Call_3B8D
	ld [hl], $01
	ld a, $02
	ldh [$ffa2], a
	ld [$c146], a
	ret


	db $06, $07, $08, $09, $09, $08, $07, $06

Call_19_5A3C::
	ld hl, $c320
	add hl, bc
	ld [hl], b
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a34
	add hl, de
	ld e, [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	sub e
	ret z

	ld e, a
	ldh a, [$ffe7]
	and $01
	ret nz

	ld a, e
	and $80
	jr z, jr_019_5a63

	inc [hl]
	inc [hl]

jr_019_5a63:
	dec [hl]
	ret


	db $0f, $00, $01, $0f, $02, $0f, $0f, $0f, $03, $0f, $0f, $14, $14, $15, $16, $17
	db $17, $16, $15

Jump_019_5a78:
	ldh a, [$ff9e]
	rla
	and $06
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	and $01
	add e
	call Call_3B87
	ld a, $02
	ld [$c146], a
	xor a
	ldh [$ffa3], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_5ab1

	ldh a, [$ffe7]
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5a70
	add hl, de
	ld e, [hl]
	ld hl, $ffa2
	ld a, [hl]
	sub e
	jr z, jr_019_5ab1

	and $80
	jr z, jr_019_5ab0

	inc [hl]
	inc [hl]

jr_019_5ab0:
	dec [hl]

jr_019_5ab1:
	ldh a, [$ffcb]
	and $0f
	ld e, a
	ld d, b
	ld hl, $5a65
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, jr_019_5ac5

	ldh [$ff9e], a
	ld [$c15d], a

jr_019_5ac5:
	ld a, [$c133]
	and $03
	jr z, jr_019_5acf

	xor a
	ldh [$ff9b], a

jr_019_5acf:
	ld a, [$c133]
	and $0c
	jr z, jr_019_5ad9

	xor a
	ldh [$ff9a], a

jr_019_5ad9:
	call Call_29C5
	ret


	db $64, $00, $64, $20, $66, $00, $66, $20, $60, $00, $60, $20, $62, $00, $62, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_19_5AFD::
	ld de, $5add
	call Call_3C3B
	call Call_19_789F
	call Call_19_790B
	call Call_19_7944
	call Call_3B9E
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	ldh [$ffe8], a
	jr z, jr_019_5b26

	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_019_5b26:
	ldh a, [$fff0]
	rst $00

JumpTable_19_5B29::
	dw Jump_19_5B45
	dw Jump_19_5B87

	db $00, $10, $00, $f0, $0c, $0c, $f4, $f4, $f0, $00, $10, $00, $f4, $0c, $0c, $f4
	db $00, $06, $02, $04, $00, $06, $02, $04

Jump_19_5B45::
	call Call_0891
	jr nz, jr_019_5b7e

	call Call_3B8D
	call Call_27ED
	and $1f
	or $10
	ld hl, $c320
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $5b2d
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5b35
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $5b3d
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_019_5b7e:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	call Call_3B87
	ret


Jump_19_5B87::
	ldh a, [$ffe8]
	and a
	jr z, jr_019_5b9f

	call Call_0891
	call Call_27ED
	and $1f
	add $10
	ld [hl], a
	call Call_3DAF
	call Call_3B8D
	ld [hl], b
	ret


jr_019_5b9f:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	inc a
	call Call_3B87
	ret


	db $00, $2c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ec, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $95, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $3e, $01, $e0, $a1, $ea, $67, $c1, $cd, $95, $14, $f0, $9c, $c7, $bc, $5c, $ce
	db $5c, $ec, $5c, $f0, $b7, $a7, $20, $08, $3e, $01, $e0, $9c, $3e, $25, $e0, $f2
	db $c9, $00, $03, $01, $02, $f0, $b7, $a7, $20, $05, $3e, $02, $e0, $9c, $c9, $f0
	db $e7, $1f, $1f, $e6, $03, $5f, $16, $00, $21, $ca, $5c, $19, $7e, $e0, $9e, $cd
	db $7c, $08, $c9, $cd, $d8, $5c, $f0, $a2, $c6, $04, $e0, $a2, $fe, $78, $38, $3e
	db $ea, $c8, $db, $f0, $f6, $5f, $16, $00, $21, $a9, $5b, $19, $5e, $21, $00, $d8
	db $19, $7e, $e6, $80, $28, $f2, $7b, $ea, $03, $d4, $af, $ea, $01, $d4, $ea, $02
	db $d4, $3e, $70, $ea, $05, $d4, $e0, $99, $3e, $68, $ea, $04, $d4, $e0, $98, $ea
	db $75, $d4, $3e, $66, $ea, $16, $d4, $cd, $0f, $09, $af, $ea, $67, $c1, $c9, $42
	db $20, $40, $20, $46, $20, $44, $20, $40, $00, $42, $00, $44, $00, $46, $00, $48
	db $00, $4a, $00, $4c, $00, $4e, $00, $10, $11, $12, $13, $13, $12, $11, $10

Call_19_5D58::
	ld a, [$db79]
	cp $01
	jp nz, Call_19_79B4

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
	ldh a, [$ffe7]
	xor c
	and $01
	jr nz, jr_019_5d7e

	ld de, $5d38
	call Call_3C3B

jr_019_5d7e:
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_5d9b

	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5d50
	add hl, de
	ld a, [hl]
	sub $04
	ld hl, $c310
	add hl, bc
	ld [hl], a

jr_019_5d9b:
	ldh a, [$fff0]
	and a
	jr nz, jr_019_5def

	call Call_19_798D
	ld a, e
	cp $02
	ld e, $04
	jr z, jr_019_5daf

	call Call_19_795E
	sla e

jr_019_5daf:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	call Call_19_795E
	add $18
	cp $30
	jr nc, jr_019_5dd9

	ldh a, [$ff99]
	push af
	add $0c
	ldh [$ff99], a
	call Call_19_796E
	ld e, a
	pop af
	ldh [$ff99], a
	ld a, e
	add $18
	cp $30
	jr c, jr_019_5def

jr_019_5dd9:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_5dec

	ld a, [$c14a]
	and a
	ld a, $08
	jr z, jr_019_5de9

	ld a, $18

jr_019_5de9:
	call Call_3C25

jr_019_5dec:
	call Call_19_790B

jr_019_5def:
	ld a, [$dba5]
	and a
	jp nz, Jump_019_5f02

	ld a, [$db7a]
	and a
	jp z, Jump_019_5ea1

	ldh a, [$fff6]
	cp $64
	jp nz, Jump_019_5ec7

	ldh a, [$fff0]
	rst $00

JumpTable_19_5E07::
	dw Jump_19_5E0D
	dw Jump_19_5E20
	dw Jump_19_5E7D

Jump_19_5E0D::
	call Call_19_789F
	ldh a, [$ff98]
	cp $3c
	ret nc

	ldh a, [$ff99]
	cp $7a
	ret nc

	ld [$c167], a
	jp Call_3B8D


Jump_19_5E20::
	ld a, $02
	ldh [$ffa1], a
	ldh a, [$ff99]
	push af
	ldh a, [$ff98]
	push af
	ld hl, $c310
	add hl, bc
	ld a, $60
	sub [hl]
	ldh [$ff99], a
	ld a, $28
	ldh [$ff98], a
	ld a, $08
	call Call_3C25
	call Call_19_795E
	push af
	ld a, e
	sla a
	ld hl, $c380
	add hl, bc
	ld [hl], a
	pop af
	add $03
	cp $06
	jr nc, jr_019_5e70

	call Call_19_796E
	add $0c
	cp $18
	jr nc, jr_019_5e70

	pop af
	ldh [$ff98], a
	pop af
	ldh [$ff99], a
	ld a, $16
	call Call_218E
	ld a, $2d
	ldh [$fff2], a
	call Call_3B8D
	ld hl, $c2c0
	add hl, bc
	inc [hl]
	ret


jr_019_5e70:
	pop af
	ldh [$ff98], a
	pop af
	ldh [$ff99], a
	call Call_19_790B
	call Call_19_5F96
	ret


Jump_19_5E7D::
	ld a, $02
	ldh [$ffa1], a
	call Call_19_789F
	ld hl, $c310
	add hl, bc
	dec [hl]
	jr nz, jr_019_5e9d

	xor a
	ld [$db79], a
	ld [$db7a], a
	ld [$c167], a
	ld hl, $d9e3
	set 6, [hl]
	jp Call_19_79B4


jr_019_5e9d:
	call Call_19_5F96
	ret


Jump_019_5ea1:
	call Call_19_789F
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ldh a, [$fff6]
	cp $f6
	jp nz, Jump_019_5ec7

	ldh a, [$ff99]
	cp $40
	ret c

	ldh a, [$ff98]
	cp $78
	ret nc

	inc [hl]
	ld a, $2d
	ldh [$fff2], a
	ld a, $13
	call Call_218E
	ret


Jump_019_5ec7:
	call Call_19_789F
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	ret nz

	ld a, [$c16b]
	cp $04
	ret nz

	ldh a, [$ffe7]
	and $01
	ret nz

	ld hl, $c440
	add hl, bc
	dec [hl]
	ret nz

	call Call_27ED
	and $03
	ld hl, $c3c8
	or [hl]
	ret nz

	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld a, $2d
	ldh [$fff2], a
	ld a, [$db7a]
	and a
	ld a, $11
	jr z, jr_019_5eff

	ld a, $10

jr_019_5eff:
	jp Call_218E


Jump_019_5f02:
	call Call_19_789F
	ldh a, [$fff7]
	cp $1e
	ret nz

	ldh a, [$fff6]
	cp $e3
	ret nz

	ldh a, [$fff8]
	and $20
	ret nz

	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ldh a, [$fff0]
	rst $00

JumpTable_19_5F1E::
	dw Jump_19_5F2A
	dw Jump_19_5F42
	dw Jump_19_5F7A
	dw Jump_19_5FA8
	dw Jump_19_5FC4
	dw Jump_19_5FEA

Jump_19_5F2A::
	call Call_0891
	ld [hl], $40
	jp Call_3B8D


	db $60, $28, $28, $68, $00, $f8, $fc, $08, $f8, $fc, $f8, $02, $04, $02, $04, $00

Jump_19_5F42::
	call Call_0891
	jr nz, jr_019_5f78

	ld hl, $c3d0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5f32
	add hl, de
	ld a, [hl]
	ld hl, $c2e0
	add hl, bc
	ld [hl], a
	ld hl, $5f36
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $5f3a
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $5f3e
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, bc
	ld [hl], a
	call Call_3B8D

jr_019_5f78:
	jr Call_19_5F96

Jump_19_5F7A::
	call Call_0891
	jr nz, jr_019_5f93

	ld [hl], $50
	call Call_3B8D
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr z, jr_019_5f93

	call Call_3B8D
	ld [hl], b

jr_019_5f93:
	call Call_19_790B

Call_19_5F96::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add e
	call Call_3B87
	ret


Jump_19_5FA8::
	call Call_0891
	jr nz, jr_019_5fc1

	ld [hl], $50
	ldh a, [$ff99]
	push af
	ld a, $10
	ldh [$ff99], a
	ld a, $14
	call Call_218E
	pop af
	ldh [$ff99], a
	call Call_3B8D

jr_019_5fc1:
	jp Call_19_5F96


Jump_19_5FC4::
	call Call_0891
	jr nz, jr_019_5fd1

	ld a, $15
	call Call_218E
	call Call_3B8D

jr_019_5fd1:
	ld hl, $c250
	add hl, bc
	ld [hl], $0a
	ld hl, $c240
	add hl, bc
	ld [hl], $fc
	ld hl, $c380
	add hl, bc
	ld [hl], $02
	call Call_19_790B
	jp Call_19_5F96


	db $c9

Jump_19_5FEA::
	ld a, $01
	ld [$db7a], a
	call Call_19_7A66
	call Call_19_79B4
	jp Call_0909


	db $00, $98, $06, $89, $00, $04, $00, $04, $00, $04, $00, $04, $00, $10, $98, $07
	db $89, $01, $11, $01, $11, $01, $11, $01, $11, $01, $11, $98, $08, $89, $07, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $98, $08, $89, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $06, $98, $09, $89, $06, $07, $06, $07, $06, $07, $06, $07
	db $06, $07, $98, $0a, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98
	db $0b, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0b, $89, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0c, $89, $07, $06, $07, $06
	db $07, $06, $07, $06, $07, $06, $98, $0d, $89, $06, $07, $06, $07, $06, $07, $06
	db $07, $06, $07, $98, $0e, $89, $02, $12, $02, $12, $02, $12, $02, $12, $02, $12
	db $98, $0f, $89, $03, $05, $03, $05, $03, $05, $03, $05, $03, $13, $98, $06, $89
	db $04, $00, $04, $00, $04, $00, $04, $00, $04, $14, $98, $07, $89, $11, $01, $11
	db $01, $11, $01, $11, $01, $11, $01, $98, $08, $89, $06, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $98, $08, $89, $06, $07, $06, $07, $06, $07, $06, $07, $06
	db $07, $98, $09, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98, $0a
	db $89, $06, $07, $06, $07, $06, $07, $06, $07, $06, $07, $98, $0b, $89, $07, $06
	db $07, $06, $07, $06, $07, $06, $07, $06, $98, $0b, $89, $07, $06, $07, $06, $07
	db $06, $07, $06, $07, $06, $98, $0c, $89, $06, $07, $06, $07, $06, $07, $06, $07
	db $06, $07, $98, $0d, $89, $07, $06, $07, $06, $07, $06, $07, $06, $07, $06, $98
	db $0e, $89, $12, $02, $12, $02, $12, $02, $12, $02, $12, $02, $98, $0f, $89, $05
	db $03, $05, $03, $05, $03, $05, $03, $05, $15, $95, $60, $f9, $5f, $c9, $60, $2d
	db $60, $fd, $60, $61, $60

Jump_019_613d:
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_19_63BE
	ldh a, [$fff0]
	rst $00

JumpTable_19_614A::
	dw Jump_19_6158
	dw Jump_19_6163
	dw Jump_19_6199
	dw Jump_19_61A3
	dw Jump_19_61A8
	dw Jump_19_61DD
	dw Jump_19_6204

Jump_19_6158::
	call Call_27D2
	call Call_0891
	ld [hl], $ff
	call Call_3B8D

Jump_19_6163::
	call Call_0891
	jr nz, jr_019_6176

	ld [$c155], a
	call Call_3B87
	ld a, $2e
	ldh [$fff2], a
	call Call_3B8D
	ret


jr_019_6176:
	cp $a0
	jr nz, jr_019_617e

	ld a, $1d
	ldh [$fff4], a

jr_019_617e:
	jr c, jr_019_618c

	and $10
	ld a, $00
	jr z, jr_019_6188

	ld a, $ff

jr_019_6188:
	call Call_3B87
	ret


jr_019_618c:
	ld e, $01
	and $04
	jr z, jr_019_6194

	ld e, $fe

jr_019_6194:
	ld a, e
	ld [$c155], a
	ret


Jump_19_6199::
	call Call_0891
	and a
	jr nz, jr_019_61a2

	call Call_3B8D

jr_019_61a2:
	ret


Jump_19_61A3::
	ld hl, $6131
	jr Call_19_61AB

Jump_19_61A8::
	ld hl, $6135

Call_19_61AB::
	push bc
	push hl
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rla
	and $02
	ld e, a
	ld d, b
	pop hl
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld c, $34
	ld hl, $d601

jr_019_61c1:
	dec de
	ld a, [de]
	inc de
	cp $98
	ld a, [de]
	jr nz, jr_019_61d1

	ldh a, [$ff96]
	and a
	ld a, [de]
	jr z, jr_019_61d1

	add $0c

jr_019_61d1:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_61c1

	ld [hl], $00
	pop bc
	call Call_3B8D
	ret


Jump_19_61DD::
	ld hl, $6139
	call Call_19_61AB
	call Call_0891
	ld [hl], $18
	ld hl, $c2b0
	add hl, bc
	inc [hl]
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $0c
	jr nz, jr_019_61fe

	ldh a, [$ffbf]
	ld [$d368], a
	ret


jr_019_61fe:
	call Call_3B8D
	ld [hl], $02
	ret


Jump_19_6204::
	call Call_19_7A66
	set 4, [hl]
	xor a
	ld [$c155], a
	ld [$c167], a
	ld a, $02
	ldh [$fff2], a
	ld a, $e1
	ld [$d736], a
	ld a, $77
	ld [$d746], a
	ld a, $77
	ld [$d756], a
	call Call_19_6269
	jp Call_19_79B4


	db $98, $4a, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f, $98, $4b, $87, $0d, $1d
	db $65, $67, $1f, $1f, $1f, $1f, $98, $49, $81, $0b, $1b, $98, $4c, $81, $0e, $1e
	db $98, $56, $87, $0c, $1c, $64, $66, $0f, $0f, $0f, $0f, $98, $57, $87, $0d, $1d
	db $65, $67, $1f, $1f, $1f, $1f, $98, $55, $81, $0b, $1b, $98, $58, $81, $0e, $1e

Call_19_6269::
	ld a, $20
	ld [$d600], a
	ld hl, $d601
	ld de, $6229
	ldh a, [$ff96]
	and a
	jr z, jr_019_627c

	ld de, $6249

jr_019_627c:
	push bc
	ld c, $20

jr_019_627f:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_627f

	pop bc
	ld [hl], b
	ret


	db $50, $5c, $68, $70, $7a, $7e, $58, $32, $38, $38, $40, $44, $50, $20, $20, $20
	db $20, $20, $1f, $1e, $1f, $20, $20, $20, $20, $20, $03, $03, $04, $04, $05, $05
	db $06, $01, $01, $02, $02, $03, $03, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $38, $3a
	db $3b, $44, $4c, $58, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $2f, $30, $30, $30, $30
	db $30, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04, $04, $00, $00
	db $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $72, $00, $00, $08, $74, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $76, $00, $00, $08, $78, $00, $00, $10, $7a, $00, $00, $00, $ff, $00, $00, $00
	db $7c, $00, $00, $08, $7e, $00, $00, $10, $7e, $20, $00, $18, $7c, $20, $00, $00
	db $7a, $20, $00, $08, $78, $20, $00, $10, $76, $20, $00, $00, $ff, $00, $00, $00
	db $74, $20, $00, $08, $72, $20, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $30
	db $70, $20, $00, $d8, $70, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00
	db $60, $10, $10, $00, $62, $00, $20, $00, $62, $00, $00, $00, $ff, $00, $00, $00
	db $ff, $00, $00, $00, $ff, $00, $00, $00, $64, $10, $10, $00, $66, $00, $20, $00
	db $66, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $02
	db $68, $10, $10, $02, $6a, $00, $20, $02, $6a, $00, $00, $05, $68, $30, $10, $05
	db $6a, $20, $20, $05, $6a, $20, $00, $01, $68, $10, $10, $01, $6a, $00, $20, $01
	db $6a, $00, $00, $07, $68, $30, $10, $07, $6a, $20, $20, $07, $6a, $20, $00, $00
	db $68, $10, $10, $00, $6a, $00, $20, $00, $6a, $00, $00, $08, $68, $30, $10, $08
	db $6a, $20, $20, $08, $6a, $20

Call_19_63BE::
	ld hl, $c3d0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6288
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $6295
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld hl, $62a2
	add hl, de
	ld a, [hl]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $62d6
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ld hl, $c3d0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $62af
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $62bc
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld hl, $62c9
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
	ld d, b
	ld hl, $6346
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ret


	db $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $22, $09
	db $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $42, $09, $0c, $0d, $0c
	db $0d, $0c, $0d, $0c, $0d, $0c, $0d, $98, $62, $09, $0e, $0f, $0e, $0f, $0e, $0f
	db $0e, $0f, $0e, $0f, $98, $02, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55
	db $56, $98, $22, $09, $55, $56, $55, $56, $55, $56, $55, $56, $55, $56, $98, $42
	db $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $62, $09, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $02, $09, $55, $56, $55, $56, $55
	db $56, $55, $56, $55, $56, $98, $22, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f
	db $0e, $0f, $98, $42, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98
	db $62, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $02, $09, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $22, $09, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $0e, $98, $42, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $98, $62, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $98, $82, $09, $0f, $0e, $0f, $0f, $0f, $0e, $0f, $0e, $0f, $0e, $98, $a2, $09
	db $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $98, $c2, $09, $0f, $0e, $0f
	db $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $e2, $09, $1e, $1e, $1e, $1e, $1e, $1e
	db $1e, $1e, $1e, $1e, $98, $82, $09, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e
	db $0f, $98, $a2, $09, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $0f, $0e, $98, $c2
	db $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $98, $e2, $09, $09, $08
	db $18, $09, $7e, $7e, $09, $08, $18, $09, $98, $82, $09, $0e, $0f, $0e, $0f, $0e
	db $0f, $0e, $0f, $0e, $0f, $98, $a2, $09, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e
	db $1e, $1e, $98, $c2, $09, $09, $08, $18, $09, $7e, $7e, $09, $08, $18, $09, $98
	db $e2, $09, $09, $04, $05, $09, $7e, $7e, $09, $04, $05, $09, $98, $82, $09, $1e
	db $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $98, $a2, $09, $09, $08, $18, $09
	db $7e, $7e, $09, $08, $18, $09, $98, $c2, $09, $09, $04, $05, $09, $7e, $7e, $09
	db $04, $05, $09, $98, $e2, $09, $19, $14, $15, $19, $1f, $1f, $19, $14, $15, $19
	db $21, $64, $55, $64, $89, $64, $bd, $64, $f1, $64, $25, $65, $59, $65, $8d, $65

Jump_019_65d1:
	ldh a, [$fff6]
	cp $0e
	jp z, Jump_019_613d

	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ldh a, [$fff0]
	rst $00

JumpTable_19_65E2::
	dw Jump_19_65EA
	dw Jump_19_65FB
	dw Jump_19_6624
	dw Jump_19_665F

Jump_19_65EA::
	ld a, $04
	ldh [$fff4], a
	call Call_0891
	ld [hl], $ac
	call Call_088C
	ld [hl], $ac
	call Call_3B8D

Jump_19_65FB::
	call Call_0891
	cp $a0
	jr nz, jr_019_6607

	ld hl, $fff4
	ld [hl], $2e

jr_019_6607:
	and a
	jr nz, jr_019_6611

	ld a, $2f
	ldh [$fff2], a
	call Call_3B8D

jr_019_6611:
	ld e, $01
	and $04
	jr z, jr_019_6619

	ld e, $fe

jr_019_6619:
	ld a, e
	ld [$c155], a
	call Call_088C
	ret nz

	jp Jump_019_6705


Jump_19_6624::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	push af
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $65c1
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	push bc
	ld c, $34
	ld hl, $d601

jr_019_663c:
	ld a, [de]
	cp $98
	jr nz, jr_019_664a

	ldh a, [$ff97]
	and a
	ld a, $98
	jr z, jr_019_664a

	ld a, $9a

jr_019_664a:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_663c

	ld [hl], $00
	pop bc
	pop af
	cp $03
	jr nz, jr_019_665c

	ldh a, [$ffbf]
	ld [$d368], a

jr_019_665c:
	jp Call_3B8D


Jump_19_665F::
	push bc
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $65c9
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld c, $34
	ld hl, $d601

jr_019_6676:
	ld a, [de]
	cp $98
	jr nz, jr_019_6684

	ldh a, [$ff97]
	and a
	ld a, $98
	jr z, jr_019_6684

	ld a, $9a

jr_019_6684:
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_6676

	ld [hl], $00
	pop bc
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $04
	jr nz, jr_019_66f2

	ld hl, $d712
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld hl, $d722
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld a, $b3
	ld [hli], a
	ld hl, $d732
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
	ld a, $e7
	ld [hli], a
	ld a, $ad
	ld [hli], a
	ld a, $b1
	ld [hli], a
	ld hl, $d742
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
	ld a, $e3
	ld [hli], a
	ld a, $ae
	ld [hli], a
	ld a, $b2
	ld [hli], a
	call Call_19_7A66
	set 4, [hl]
	xor a
	ld [$c155], a
	ld [$c167], a
	ld a, $02
	ldh [$fff2], a
	jp Call_19_79B4


jr_019_66f2:
	call Call_3B8D
	ld [hl], $01
	call Call_0891
	ld [hl], $30
	ret


	db $18, $58, $28, $48, $38, $20, $50, $40

Jump_019_6705:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_6742

	ld a, $a7
	call Call_3C01
	jr c, jr_019_6742

	push bc
	call Call_27ED
	and $07
	ld c, a
	ld hl, $66fd
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	call Call_27ED
	and $07
	add $47
	ld hl, $c210
	add hl, de
	ld [hl], a
	pop bc
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c2e0
	add hl, de
	ld [hl], $10
	ld hl, $c2b0
	add hl, de
	ld [hl], $01

jr_019_6742:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20
	db $f0, $10

Call_19_6765::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_65d1

	ldh a, [$fff7]
	cp $0a
	jr nz, jr_019_6784

	ldh a, [$fff6]
	cp $97
	jr z, jr_019_677e

	cp $98
	jr nz, jr_019_6784

jr_019_677e:
	ld a, [$db7f]
	and a
	jr nz, jr_019_678a

jr_019_6784:
	ld de, $6743
	call Call_3C3B

jr_019_678a:
	call Call_19_789F
	call Call_19_78C1
	call Call_3BB4
	call Call_19_790B
	call Call_3B9E
	ld a, [$c133]
	and a
	jr nz, jr_019_67f7

	ldh a, [$ffcb]
	and $03
	jr z, jr_019_67c7

	ld e, a
	ld d, b
	ld hl, $6762
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld [hl], b
	ld a, e
	and $02
	add $04
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add e
	jp Call_3B87


jr_019_67c7:
	ldh a, [$ffcb]
	and $0f
	jr z, jr_019_67f7

	rra
	rra
	cpl
	and $03
	ld e, a
	ld d, b
	ld hl, $6762
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld [hl], b
	ld a, e
	dec a
	xor $01
	sra a
	rla
	rla
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add e
	jp Call_3B87


jr_019_67f7:
	jp Call_3DAF


	db $60, $00, $62, $00, $64, $00, $66, $00, $62, $20, $60, $20, $66, $20, $64, $20

Call_19_680A::
	ld de, $67fa
	call Call_3C3B
	call Call_19_789F
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and $02
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	or e
	call Call_3B87
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_19_682E::
	dw Jump_19_6834
	dw Jump_19_6857
	dw Jump_19_6865

Jump_19_6834::
	ld hl, $c240
	ldh a, [$ffeb]
	cp $aa
	jr z, jr_019_6840

	ld hl, $c250

jr_019_6840:
	add hl, bc
	ld [hl], $08

Jump_019_6843:
	ld e, $80
	ldh a, [$ffeb]
	cp $aa
	jr z, jr_019_684d

	ld e, $60

jr_019_684d:
	call Call_0891
	ld [hl], e
	call Call_3B8D
	ld [hl], $01
	ret


Jump_19_6857::
	call Call_0891
	jr nz, jr_019_6861

	ld [hl], $28
	call Call_3B8D

jr_019_6861:
	call Call_19_790B
	ret


Jump_19_6865::
	call Call_0891
	jr nz, jr_019_687d

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
	jp Jump_019_6843


jr_019_687d:
	ret


Call_19_687E::
	ldh a, [$fff0]
	cp $05
	jr nz, jr_019_688a

	ldh a, [$ffed]
	or $40
	ldh [$ffed], a

jr_019_688a:
	ld de, $67fa
	call Call_3C3B
	call Call_19_789F
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	and $02
	ld e, a
	call Call_19_78C1
	ldh a, [$fff0]
	cp $05
	jr z, Call_19_68B8

	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	or e
	call Call_3B87
	call Call_19_68B8
	call Call_3BB4
	ret


Call_19_68B8::
	ldh a, [$fff0]
	rst $00

JumpTable_19_68BB::
	dw Jump_19_68C7
	dw Jump_19_68D7
	dw Jump_19_68F5
	dw Jump_19_6929
	dw Jump_19_6942
	dw Jump_19_6967

Jump_19_68C7::
	ld hl, $c480
	add hl, bc
	ld [hl], $03
	ldh a, [$ffef]
	ld hl, $c2b0
	add hl, bc
	ld [hl], a
	jp Call_3B8D


Jump_19_68D7::
	call Call_0891
	call Call_27ED
	and $7f
	add $30
	ld [hl], a
	call Call_27ED
	ld e, $f4
	and $01
	jr z, jr_019_68ed

	ld e, $0c

jr_019_68ed:
	ld hl, $c240
	add hl, bc
	ld [hl], e
	jp Call_3B8D


Jump_19_68F5::
	call Call_0891
	jr nz, jr_019_690e

	ld hl, $c250
	add hl, bc
	ld [hl], $d4
	ldh a, [$ffec]
	sub $08
	call Call_19_6991
	ld a, $24
	ldh [$fff2], a
	jp Call_3B8D


jr_019_690e:
	call Call_088C
	jr nz, jr_019_6923

	call Call_27ED
	and $3f
	or $10
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_019_6923:
	call Call_19_7918
	jp Call_3B9E


Jump_19_6929::
	call Call_0891
	jr nz, jr_019_6941

	call Call_19_790E
	call Call_19_6957
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld a, [hl]
	cp $18
	jr nz, jr_019_6941

	call Call_3B8D

jr_019_6941:
	ret


Jump_19_6942::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr nc, jr_019_6954

	call Call_3B8D
	ld [hl], $01
	ret


jr_019_6954:
	call Call_19_790E

Call_19_6957::
	ld hl, $c430
	add hl, bc
	set 0, [hl]
	call Call_3B9E
	ld hl, $c430
	add hl, bc
	res 0, [hl]
	ret


Jump_19_6967::
	ld hl, $c340
	add hl, bc
	set 7, [hl]
	set 6, [hl]
	ld hl, $c250
	add hl, bc
	inc [hl]
	push hl
	ld hl, $c470
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, jr_019_6980

	ld [hl], $06

jr_019_6980:
	call Call_19_790E
	ldh a, [$ffec]
	cp $70
	jr c, Call_19_6957

	cp $88
	jp nc, Call_19_79B4

	ret


	db $f0, $ec

Call_19_6991::
	ldh [$ffd8], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ld a, $01
	call Call_0953
	ld a, $0e
	ldh [$fff2], a
	ret


	db $9a, $10, $9c, $10

Jump_019_69a5:
	ld de, $69a1
	call Call_3C3B
	call Call_19_7944
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, Call_19_79B4

	ret


Jump_019_69be:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_019_69a5

	call Call_19_6B4E
	call Call_19_7804
	ldh a, [$fff0]
	rst $00

JumpTable_19_69D0::
	dw Jump_19_69D8
	dw Jump_19_6A0F
	dw Jump_19_6A2A
	dw Jump_19_6A68

Jump_19_69D8::
	call Call_19_7852
	jr nc, jr_019_6a03

	ld e, $cd
	ldh a, [$fff8]
	and $20
	jr nz, jr_019_69ff

	ld e, $cc
	ld a, [$dafe]
	and $20
	jr nz, jr_019_69ff

	ld e, $c6
	ld a, [$db0e]
	cp $03
	jr nz, jr_019_69ff

	ld a, $c7
	call Call_2185
	jp Call_3B8D


jr_019_69ff:
	ld a, e
	call Call_2185

jr_019_6a03:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_19_6A0F::
	ld a, [$c19f]
	and a
	jr nz, jr_019_6a29

	call Call_3B8D
	ld a, [$c177]
	and a
	jr z, jr_019_6a24

	ld [hl], b
	ld a, $c9
	jp Call_2185


jr_019_6a24:
	ld a, $c8
	call Call_2185

jr_019_6a29:
	ret


Jump_19_6A2A::
	ld a, [$c19f]
	and a
	jr nz, jr_019_6a63

	ld a, $cd
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	sub $02
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
	ld [hl], $20
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld a, $24
	ldh [$fff2], a
	call Call_0891
	ld [hl], $c0
	call Call_3B8D

jr_019_6a63:
	ret


	db $00, $01, $02, $01

Jump_19_6A68::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, jr_019_6a89

	xor a
	ld [$c167], a
	ld a, $04
	ld [$db0e], a
	ld a, $0d
	ldh [$ffa5], a
	call Call_0898
	call Call_3B8D
	ld [hl], b
	ret


jr_019_6a89:
	cp $80
	jr c, jr_019_6a92

	ld a, $03
	jp Call_3B87


jr_019_6a92:
	cp $08
	jr nz, jr_019_6a9c

	dec [hl]
	ld a, $ca
	call Call_2185

jr_019_6a9c:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $6a64
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $54, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5a, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $00, $00, $50, $00, $00, $08, $52, $00, $00, $10, $5c, $00, $10, $00, $56, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $18, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $62, $00, $00, $08, $64, $00, $00, $10, $66, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
	db $00, $00, $6a, $00, $00, $08, $6c, $00, $00, $10, $6e, $00, $10, $00, $68, $00
	db $10, $08, $58, $00, $10, $10, $5e, $00, $10, $10, $60, $00, $ff, $ff, $ff, $ff
	db $10, $00, $74, $00, $10, $08, $76, $00, $10, $10, $74, $00, $10, $18, $76, $00
	db $00, $10, $74, $00, $00, $18, $76, $00, $00, $00, $74, $00, $00, $08, $76, $00

Call_19_6B4E::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6aae
	add hl, de
	ldh a, [$ffee]
	add $03
	ldh [$ffee], a
	ld c, $07
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ld a, $78
	ldh [$ffee], a
	ld a, $5c
	ldh [$ffec], a
	ld hl, $6b2e
	ld c, $08
	ld a, [$db0e]
	cp $04
	jr nz, jr_019_6b83

	dec c
	dec c

jr_019_6b83:
	call Call_3D26
	ld a, $03
	call Call_3DD0
	call Call_3DBA
	ret


	db $08, $04, $70, $00, $08, $0c, $72, $00, $08, $14, $70, $20

Call_19_6B9B::
	ld a, [$dba5]
	and a
	jr nz, jr_019_6baf

	ld hl, $c340
	add hl, bc
	ld [hl], $c3
	ld hl, $6b8f
	ld c, $03
	jp Call_3D26


jr_019_6baf:
	ldh a, [$fff6]
	cp $fe
	jp z, Jump_019_69be

	ldh a, [$ffee]
	cp $30
	jp c, Jump_019_6d11

	ldh a, [$fff0]
	and a
	jr nz, jr_019_6bf0

	call Call_3B8D
	ld hl, $c210
	add hl, bc
	ld [hl], $48
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $04
	ld [hl], a
	ld a, $cd
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $28
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $40

jr_019_6bf0:
	call Call_19_6CA7
	call Call_19_7804
	ldh a, [$fff0]
	rst $00

JumpTable_19_6BF9::
	dw Jump_19_6BFF
	dw Jump_19_6C00
	dw Jump_19_6C32

Jump_19_6BFF::
	ret


Jump_19_6C00::
	call Call_0887
	ret nz

	call Call_19_7852
	jr nc, jr_019_6c24

	ld a, [$db0e]
	cp $0e
	jr nz, jr_019_6c17

	ld a, $d8
	call Call_2197
	jr jr_019_6c1c

jr_019_6c17:
	ld a, $9b
	call Call_2185

jr_019_6c1c:
	ld hl, $c19f
	set 7, [hl]
	call Call_3B8D

jr_019_6c24:
	ldh a, [$ffe7]
	ld e, $00
	and $20
	jr z, jr_019_6c2d

	inc e

jr_019_6c2d:
	ld a, e
	call Call_3B87
	ret


Jump_19_6C32::
	ld a, [$c19f]
	and a
	jr nz, jr_019_6c3d

	call Call_3B8D
	ld [hl], $01

jr_019_6c3d:
	call Call_19_795E
	ld a, e
	add $02
	call Call_3B87
	ret


	db $f8, $f8, $5a, $00, $f8, $00, $5c, $00, $f8, $08, $5e, $00, $08, $00, $60, $00
	db $08, $08, $62, $00, $f8, $10, $5a, $20, $f8, $00, $5e, $20, $f8, $08, $5c, $20
	db $08, $00, $62, $20, $08, $08, $60, $20, $00, $10, $50, $20, $f8, $00, $54, $20
	db $f8, $08, $52, $20, $08, $00, $58, $20, $08, $08, $56, $20, $00, $f8, $50, $00
	db $f8, $00, $52, $00, $f8, $08, $54, $00, $08, $00, $56, $00, $08, $08, $58, $00
	db $f0, $00, $76, $00, $f0, $08, $76, $20, $00, $00, $78, $00, $00, $08, $78, $20

Call_19_6CA7::
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
	ld hl, $6c47
	add hl, de
	ldh a, [$ffee]
	add $04
	ldh [$ffee], a
	ld c, $05
	call Call_3D26
	ldh a, [$ffee]
	add $10
	ldh [$ffee], a
	ld hl, $6c97
	ld c, $04
	call Call_3D26
	call Call_19_7804
	ldh a, [$ff98]
	sub $68
	add $04
	cp $08
	jr nc, jr_019_6d0d

	ldh a, [$ff99]
	sub $50
	add $04
	cp $08
	jr nc, jr_019_6d0d

	ldh a, [$ff9e]
	cp $02
	jr nz, jr_019_6d0d

	call Call_19_7878
	jr nc, jr_019_6d0d

	call Call_0887
	jr nz, jr_019_6d0d

	ld a, $08
	ld [$db95], a
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld [$db96], a
	call Call_0887
	ld [hl], $08

jr_019_6d0d:
	call Call_3DBA
	ret


Jump_019_6d11:
	call Call_0891
	jr z, jr_019_6d1a

	ld a, $00
	ldh [$fff1], a

jr_019_6d1a:
	call Call_19_6DD6
	call Call_19_7804
	ld hl, $c380
	add hl, bc
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	inc a
	add [hl]
	call Call_3B87
	call Call_19_796E
	add $13
	cp $26
	jr nc, jr_019_6d4a

	call Call_19_795E
	add $13
	cp $26
	jr nc, jr_019_6d4a

	ld a, e
	sla a
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_019_6d4a:
	call Call_19_7852
	jr nc, jr_019_6d71

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $01
	jr z, jr_019_6d6b

	ld e, $af
	call Call_27ED
	and $3f
	jr z, jr_019_6d6d

	ld e, $fb
	call Call_27ED
	and $07
	jr z, jr_019_6d6d

jr_019_6d6b:
	ld e, $fa

jr_019_6d6d:
	ld a, e
	call Call_2197

jr_019_6d71:
	ret


	db $f4, $00, $64, $00, $f4, $08, $66, $00, $04, $00, $68, $00, $04, $08, $6a, $00
	db $ff, $ff, $ff, $ff, $04, $f8, $70, $00, $f4, $00, $6c, $00, $f4, $08, $6e, $00
	db $04, $00, $72, $00, $04, $08, $74, $00, $04, $f8, $7a, $00, $f4, $00, $6c, $00
	db $f4, $08, $6e, $00, $04, $00, $7c, $00, $04, $08, $74, $00, $04, $10, $70, $20
	db $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20, $04, $08, $72, $20
	db $04, $10, $7a, $20, $f4, $00, $6e, $20, $f4, $08, $6c, $20, $04, $00, $74, $20
	db $04, $08, $7c, $20

Call_19_6DD6::
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
	ld hl, $6d72
	add hl, de
	ld c, $05
	call Call_3D26
	ret


	db $00, $06, $0c, $13, $19, $20, $26, $2c, $33, $39, $00, $00, $00, $00, $00, $00
	db $40, $43, $46, $49, $4c, $4f, $52, $55, $58, $5c, $00, $00, $00, $00, $00, $00
	db $60, $60, $60, $60, $60, $60, $60, $60, $60

Call_19_6E17::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_019_747b

	and a
	jp nz, Jump_019_70ce

	ldh a, [$ff98]
	cp $38
	jr nc, jr_019_6e3d

	cp $20
	jr c, jr_019_6e3d

	ld hl, $c11e
	set 7, [hl]
	cp $24
	jr c, jr_019_6e3d

	ld hl, $c11d
	set 7, [hl]

jr_019_6e3d:
	ld a, [$db0f]
	and a
	ret z

	ld e, a
	ld d, b
	ld hl, $6dee
	add hl, de
	ld a, [hl]
	ldh [$ffe8], a
	ldh a, [$fff8]
	and $10
	call Call_19_6FB1
	ldh a, [$fff0]
	rst $00

JumpTable_19_6E55::
	dw Jump_19_6E65
	dw Jump_19_6E7A
	dw Jump_19_6E87
	dw Jump_19_6EC0
	dw Jump_19_6F27
	dw Jump_19_6F5E
	dw Jump_19_6F5F
	dw Jump_19_6F9C

Jump_19_6E65::
	ldh a, [$ff98]
	cp $3c
	jr c, jr_019_6e79

	call Call_1495
	call Call_093B
	call Call_3B8D
	call Call_0891
	ld [hl], $58

jr_019_6e79:
	ret


Jump_19_6E7A::
	ld a, $01
	ld [$c167], a
	ld a, [$c146]
	and a
	jp z, Call_3B8D

	ret


Jump_19_6E87::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	ret nz

	ld hl, $c3d0
	add hl, bc
	ldh a, [$ffe8]
	sub [hl]
	jr nc, jr_019_6e9f

	ldh a, [$ffe8]
	ld [hl], a
	call Call_3B8D
	ret


jr_019_6e9f:
	ld e, a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_019_6ebf

	call Call_27ED
	and $01
	jr nz, jr_019_6ebf

	ld a, e
	rra
	rra
	rra
	rra
	and $0f
	and a
	jr nz, jr_019_6eb9

	ld a, $01

jr_019_6eb9:
	add [hl]
	ld [hl], a
	ld a, $06
	ldh [$fff3], a

jr_019_6ebf:
	ret


Jump_19_6EC0::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, [$db0f]
	cp $20
	jr c, jr_019_6eee

	call Call_0891
	ld [hl], $40
	call Call_3B8D
	call Call_19_7520
	ld hl, $c2c0
	add hl, bc
	ld [hl], $01
	ld a, $56
	ld [$d368], a

Jump_019_6ee4:
	xor a
	ld [$c167], a
	call Call_088C
	ld [hl], $3f
	ret


jr_019_6eee:
	ld hl, $dae9
	cp $05
	jr nz, jr_019_6f05

	bit 5, [hl]
	jr nz, jr_019_6f19

	call Call_3B8D
	ld [hl], $06
	ld a, $23
	ldh [$fff2], a
	jp Jump_019_6ee4


jr_019_6f05:
	cp $10
	jr nz, jr_019_6f19

	bit 6, [hl]
	jr nz, jr_019_6f19

	call Call_3B8D
	ld [hl], $06
	ld a, $23
	ldh [$fff2], a
	jp Jump_019_6ee4


jr_019_6f19:
	ld a, $1d
	ldh [$fff2], a
	call Call_3B8D
	ld [hl], $05
	xor a
	ld [$c167], a
	ret


Jump_19_6F27::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	cp $3e
	jr nz, jr_019_6f3a

	ld hl, $fff2
	ld [hl], $23

jr_019_6f3a:
	and a
	jr nz, jr_019_6f5d

	ld a, $cf
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $48
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $4f
	call Call_3B8D

jr_019_6f5d:
	ret


Jump_19_6F5E::
	ret


Jump_19_6F5F::
	call Call_088C
	jr nz, jr_019_6f9b

	call Call_3B8D
	ld a, $cf
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $48
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c2e0
	add hl, de
	ld [hl], $14
	ld a, $02
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $48
	ld hl, $c2e0
	add hl, de
	ld [hl], $20

jr_019_6f9b:
	ret


Jump_19_6F9C::
	ret


	db $50, $00, $50, $20, $3c, $00, $3c, $20, $3a, $00, $3a, $20, $1e, $00, $1e, $60
	db $1e, $10, $1e, $70

Call_19_6FB1::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_019_6fe2

	ld a, $88
	ldh [$ffee], a
	ld a, $80
	ldh [$ffec], a
	ld de, $6f9d
	call Call_3C3B
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld a, $80
	sub e
	ldh [$ffec], a

jr_019_6fd2:
	ld de, $6f9d
	call Call_3C3B
	ldh a, [$ffec]
	add $10
	ldh [$ffec], a
	cp $80
	jr c, jr_019_6fd2

jr_019_6fe2:
	call Call_088C
	jr z, jr_019_700d

	rra
	rra
	rra
	and $03
	ldh [$fff1], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld a, $80
	sub e
	ldh [$ffec], a
	ld a, $78
	ldh [$ffee], a
	ld de, $6fa1
	call Call_3C3B
	ld a, $98
	ldh [$ffee], a
	ld de, $6fa1
	call Call_3C3B

jr_019_700d:
	ret


	db $d8, $e8, $7c, $40, $d8, $f0, $7c, $20, $e8, $e8, $7c, $00, $e8, $f0, $7c, $60
	db $f8, $f8, $7c, $00, $f8, $00, $7c, $60, $08, $08, $7c, $00, $08, $10, $7c, $60
	db $18, $18, $7c, $00, $18, $20, $7c, $60, $28, $18, $7c, $40, $28, $20, $7c, $20
	db $d8, $f8, $7c, $00, $d8, $00, $7c, $60, $e8, $08, $7c, $00, $e8, $10, $7c, $60
	db $f8, $08, $7c, $40, $f8, $10, $7c, $20, $08, $f8, $7c, $40, $08, $00, $7c, $20
	db $18, $f8, $7c, $00, $18, $00, $7c, $60, $28, $08, $7c, $00, $28, $10, $7c, $60
	db $d8, $08, $7c, $40, $d8, $10, $7c, $20, $e8, $f8, $7c, $40, $e8, $00, $7c, $20
	db $f8, $f8, $7c, $00, $f8, $00, $7c, $60, $08, $08, $7c, $00, $08, $10, $7c, $60
	db $18, $08, $7c, $40, $18, $10, $7c, $20, $28, $f8, $7c, $40, $28, $00, $7c, $20
	db $d8, $18, $7c, $00, $d8, $20, $7c, $60, $e8, $18, $7c, $40, $e8, $20, $7c, $20
	db $f8, $08, $7c, $40, $f8, $10, $7c, $20, $08, $f8, $7c, $40, $08, $00, $7c, $20
	db $18, $e8, $7c, $40, $18, $f0, $7c, $20, $28, $e8, $7c, $00, $28, $f0, $7c, $60

Jump_019_70ce:
	ldh a, [$fff0]
	rst $00

JumpTable_19_70D1::
	dw Jump_19_70E1
	dw Jump_19_7108
	dw Jump_19_7167
	dw Jump_19_7239
	dw Jump_19_7275
	dw Jump_19_72AB
	dw Jump_19_72C5
	dw Jump_19_733F

Jump_19_70E1::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr z, jr_019_7100

	cp $30
	ret c

	sub $30
	rra
	rra
	rra
	and $03
	ldh [$fff1], a
	ld de, $6fa1
	call Call_3C3B
	ret


jr_019_7100:
	call Call_0891
	ld [hl], $a0
	jp Call_3B8D


Jump_19_7108::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_0891
	jr nz, Call_19_711D

	ld [hl], $ff
	ld a, $1e
	ldh [$fff3], a
	call Call_3B8D

Call_19_711D::
	call Call_0891
	and $04
	ld e, $e4
	jr z, jr_019_7128

	ld e, $84

jr_019_7128:
	ld a, e
	ld [$db97], a
	ldh a, [$ffe7]
	and $07
	jr nz, jr_019_713e

	ld a, $33
	ldh [$fff4], a
	call Call_27ED
	and $03
	call Call_3B87

jr_019_713e:
	ldh a, [$ffe7]
	ld hl, $c420
	add hl, bc
	ld [hl], a
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $700e
	add hl, de
	ld c, $0c
	call Call_3D26
	ld a, $0a
	call Call_3DD0
	ret


	db $7a, $00, $7a, $20

Jump_19_7167::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_19_711D
	call Call_0891
	jr nz, jr_019_717e

	call Call_0887
	ld [hl], $28
	jp Call_3B8D


jr_019_717e:
	cp $50
	jr nc, jr_019_718f

	ld hl, $7219
	ld c, $08
	call Call_3D26
	ld a, $06
	jp Call_3DD0


jr_019_718f:
	xor a
	ldh [$fff1], a
	ld de, $7163
	call Call_3C3B
	ret


	db $f8, $00, $6e, $00, $f8, $08, $6e, $20, $f8, $00, $6e, $00, $f8, $08, $6e, $20
	db $08, $00, $70, $00, $08, $08, $70, $20, $08, $00, $70, $00, $08, $08, $70, $20
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $00, $6c, $00, $08, $08, $6c, $20, $08, $00, $6c, $00, $08, $08, $6c, $20
	db $f8, $f8, $62, $00, $f8, $00, $64, $00, $f8, $08, $64, $20, $f8, $10, $62, $20
	db $08, $00, $66, $00, $08, $08, $66, $20, $08, $00, $66, $00, $08, $08, $66, $20
	db $f8, $f8, $5a, $00, $f8, $00, $5c, $00, $f8, $08, $5c, $20, $f8, $10, $5a, $20
	db $08, $f8, $5e, $00, $08, $00, $60, $00, $08, $08, $60, $20, $08, $10, $5e, $20
	db $f8, $f8, $56, $00, $f8, $00, $58, $00, $f8, $08, $58, $20, $f8, $10, $56, $20
	db $08, $f8, $56, $40, $08, $00, $58, $40, $08, $08, $58, $60, $08, $10, $56, $60

Jump_19_7239::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ldh a, [$ffe7]
	and $0f
	or $20
	ld hl, $c420
	add hl, bc
	ld [hl], a
	call Call_0887
	jr nz, jr_019_7253

	jp Call_3B8D


jr_019_7253:
	rra
	rra
	and $0f
	cp $04
	jr c, jr_019_725d

	ld a, $04

jr_019_725d:
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $7199
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $06
	call Call_3DD0
	ret


Jump_19_7275::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	call Call_19_74EF
	call Call_19_790E
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $80
	jr nz, jr_019_72aa

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_019_72aa

	ld [hl], $70
	ld a, $17
	ldh [$fff4], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $04
	jp c, Call_3B8D

	cpl
	inc a
	sra a
	ld [hl], a

jr_019_72aa:
	ret


Jump_19_72AB::
	xor a
	ld [$c167], a
	call Call_19_74EF
	call Call_3BD5
	jr nc, jr_019_72c4

	call Call_3B8D
	ld a, $0f
	ld [$d368], a
	call Call_0891
	ld [hl], $ff

jr_019_72c4:
	ret


Jump_19_72C5::
	call Call_0891
	and $08
	ld e, $e4
	jr z, jr_019_72d0

	ld e, $84

jr_019_72d0:
	ld a, e
	ld [$db97], a
	call Call_0891
	jr nz, jr_019_7303

	ld [hl], $20
	ld a, $10
	ld [$d368], a
	ld a, $9f
	call Call_2197
	ld a, [$dae9]
	or $10
	ld [$dae9], a
	ldh [$fff8], a
	ld a, $02
	ld [$db4e], a
	ld a, $ff
	ld [$db93], a
	xor a
	ld [$db0f], a
	ld [$c167], a
	call Call_3B8D

jr_019_7303:
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub $04
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub $13
	ld [hl], a
	call Call_3DBA
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ld a, $6b
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
	call Call_19_744C
	call Call_19_74EA
	ret


Jump_19_733F::
	call Call_19_74EA
	ld a, [$c19f]
	and a
	jr nz, jr_019_734b

	call Call_19_79B4

jr_019_734b:
	ret


	db $00, $04, $72, $00, $e0, $04, $72, $00, $00, $f0, $78, $20, $00, $f8, $78, $40
	db $00, $10, $78, $60, $00, $18, $78, $00, $f0, $e8, $76, $20, $f0, $f0, $76, $40
	db $f0, $18, $76, $60, $f0, $20, $76, $00, $e8, $f4, $74, $20, $e8, $14, $74, $00
	db $f8, $04, $72, $00, $d8, $04, $72, $00, $fc, $e8, $78, $20, $fc, $f0, $78, $40
	db $fc, $18, $78, $60, $fc, $20, $78, $00, $e8, $e0, $76, $20, $e8, $e8, $76, $40
	db $e8, $20, $76, $60, $e8, $28, $76, $00, $e0, $f0, $74, $20, $e0, $18, $74, $00
	db $00, $00, $74, $20, $00, $08, $74, $00, $f0, $04, $72, $00, $d0, $04, $72, $00
	db $f8, $e0, $78, $20, $f8, $e8, $78, $40, $f8, $20, $78, $60, $f8, $28, $78, $00
	db $e0, $d8, $76, $20, $e0, $e0, $76, $40, $e0, $28, $76, $60, $e0, $30, $76, $00
	db $d8, $ec, $74, $20, $d8, $1c, $74, $00, $f8, $fc, $74, $20, $f8, $0c, $74, $00
	db $00, $f8, $76, $20, $00, $00, $76, $40, $00, $08, $76, $60, $00, $10, $76, $00
	db $e4, $04, $72, $00, $00, $f8, $78, $20, $00, $00, $78, $40, $00, $08, $78, $60
	db $00, $10, $78, $00, $f4, $f0, $76, $20, $f4, $f8, $76, $40, $f4, $10, $76, $60
	db $f4, $18, $76, $00, $ec, $f8, $74, $20, $ec, $10, $74, $00, $f0, $d8, $78, $20
	db $f0, $e0, $78, $40, $f0, $28, $78, $60, $f0, $30, $78, $00, $cc, $e8, $74, $20
	db $cc, $20, $74, $00, $4c, $73, $7c, $73, $b4, $73, $fc, $73, $0c, $0e, $12, $11

Call_19_744C::
	ldh a, [$ffec]
	sub $00
	ldh [$ffec], a
	ldh a, [$ffe7]
	rra
	rra
	nop
	push af
	and $03
	ld e, a
	ld d, b
	ld hl, $7448
	add hl, de
	ld c, [hl]
	pop af
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, $7440
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Call_3D26
	ld a, $10
	call Call_3DD0
	ret


	db $7e, $00, $7e, $20

Jump_019_747b:
	call Call_0891
	ret nz

	ld de, $7477
	call Call_3C3B
	call Call_19_790E
	ld hl, $c250
	add hl, bc
	inc [hl]
	ld a, [hl]
	and $80
	jr nz, jr_019_74c9

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_019_74c9

	ld [hl], $70
	ld hl, $c250
	add hl, bc
	ld [hl], b
	call Call_3BD5
	jr nc, jr_019_74c9

	ld a, $01
	ldh [$fff3], a
	call Call_19_79B4
	ld hl, $dae9
	ld a, [$db0f]
	cp $05
	jr nz, jr_019_74bc

	set 5, [hl]
	jr jr_019_74be

jr_019_74bc:
	set 6, [hl]

jr_019_74be:
	add $01
	daa
	ld [$db0f], a
	ld a, $ef
	call Call_2197

jr_019_74c9:
	ret


	db $f8, $00, $52, $00, $f8, $08, $52, $20, $08, $00, $54, $00, $08, $08, $54, $20
	db $f8, $00, $54, $40, $f8, $08, $54, $60, $08, $00, $52, $40, $08, $08, $52, $60

Call_19_74EA::
	ld hl, $74da
	jr jr_019_74f2

Call_19_74EF::
	ld hl, $74ca

jr_019_74f2:
	ld c, $04
	call Call_3D26
	ld a, $02
	call Call_3DD0
	ret


	db $98, $50, $8d, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c, $6e, $6c
	db $6e, $98, $51, $8d, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f, $6d, $6f
	db $6d, $6f, $00

Call_19_7520::
	push bc
	ld c, $23
	ld a, $22
	ld [$d600], a
	ld hl, $d601
	ld de, $74fd

jr_019_752e:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_019_752e

	pop bc
	ld a, $89
	ld [$d729], a
	ld [$d739], a
	ld [$d749], a
	ld [$d759], a
	ld [$d769], a
	ld [$d779], a
	ld [$d789], a
	ret


	db $fc, $04, $00, $00, $ff, $00, $00, $00, $00, $00, $04, $fc, $00, $00, $00, $ff
	db $0c, $18, $24, $30, $3c, $48

Call_19_7563::
	ld a, [$c124]
	cp $03
	jr nc, jr_019_756b

	ret


jr_019_756b:
	ld a, [$c125]
	ld e, a
	ld d, $00
	ld hl, $754d
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $7551
	add hl, de
	ld a, [hl]
	ldh [$ffd8], a
	ld hl, $7555
	add hl, de
	ld a, [hl]
	ldh [$ffd9], a
	ld hl, $7559
	add hl, de
	ld a, [hl]
	ldh [$ffda], a
	ld hl, $c200
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	rl d
	ld [hl], a
	ld hl, $c220
	add hl, bc
	ldh a, [$ffd8]
	rr d
	adc [hl]
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ldh a, [$ffd9]
	add [hl]
	rl d
	ld [hl], a
	ld hl, $c230
	add hl, bc
	ldh a, [$ffda]
	rr d
	adc [hl]
	ld [hl], a
	ldh a, [$ffeb]
	cp $7f
	jr nz, jr_019_75ce

	ld hl, $c440
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld [hl], a
	ld hl, $c2d0
	add hl, bc
	ldh a, [$ffd9]
	add [hl]
	ld [hl], a
	jp Jump_019_7673


jr_019_75ce:
	cp $87
	jr nz, jr_019_760e

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $02
	jp z, Jump_019_7673

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffe6], a
	ld a, $06

jr_019_75e5:
	ldh [$ffe8], a
	ld e, a
	ld d, b
	ld hl, $755c
	add hl, de
	push hl
	ldh a, [$ffe6]
	sub [hl]
	ld e, a
	ld d, b
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	add [hl]
	ld [hl], a
	ldh a, [$ffe6]
	pop hl
	sub [hl]
	ld e, a
	ld d, b
	ld hl, $d100
	add hl, de
	ldh a, [$ffd9]
	add [hl]
	ld [hl], a
	ldh a, [$ffe8]
	dec a
	jr nz, jr_019_75e5

jr_019_760e:
	cp $c1
	jr nz, jr_019_7632

	ld a, [$db73]
	and a
	jr z, jr_019_7673

	ld e, $10
	ld hl, $d155

jr_019_761d:
	ldh a, [$ffd7]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_761d

	ld e, $10
	ld hl, $d175

jr_019_7629:
	ldh a, [$ffd9]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_7629

	jr jr_019_7673

jr_019_7632:
	cp $69
	jr z, jr_019_7663

	cp $b0
	jr z, jr_019_7663

	cp $6d
	jr nz, jr_019_7673

	ld a, [$db56]
	cp $01
	jr nz, jr_019_764b

	ldh a, [$ffe7]
	and $07
	jr z, jr_019_7673

jr_019_764b:
	ld e, $06
	ld hl, $d100

jr_019_7650:
	ldh a, [$ffd7]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_7650

	ld e, $06
	ld hl, $d110

jr_019_765c:
	ldh a, [$ffd9]
	add [hl]
	ld [hli], a
	dec e
	jr nz, jr_019_765c

jr_019_7663:
	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld [hl], a
	ld hl, $c2c0
	add hl, bc
	ldh a, [$ffd9]
	add [hl]
	ld [hl], a

Jump_019_7673:
jr_019_7673:
	ldh a, [$fff6]
	ld hl, $c3e0
	add hl, bc
	cp [hl]
	jr z, jr_019_769a

	ld hl, $c200
	add hl, bc
	ld a, [hl]
	cp $a0
	jr nc, jr_019_7690

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $10
	cp $78
	jr c, jr_019_769a

jr_019_7690:
	ldh a, [$ffeb]
	cp $a7
	ret z

	ld hl, $c280
	add hl, bc
	ld [hl], b

jr_019_769a:
	ret


Call_19_769B::
	ld a, [$c1a5]
	and a
	jr z, jr_019_76d0

	ld a, [$c19f]
	and a
	jr nz, jr_019_76d0

	ldh a, [$ffe7]
	and $03
	rst $00

JumpTable_19_76AC::
	dw Jump_19_76B4
	dw Jump_19_76D1
	dw Jump_19_76EE
	dw Jump_19_76FA

Jump_19_76B4::
	ld hl, $dccf
	ld de, $dccf
	ld a, [hld]
	push af
	ld a, [hld]
	push af
	ld c, $07

jr_019_76c0:
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, jr_019_76c0

	pop hl
	pop bc
	ld a, b
	ld [de], a
	dec de
	ld a, h
	ld [de], a

jr_019_76d0:
	ret


Jump_19_76D1::
	ld hl, $dcd0
	ld de, $dcd0
	ld a, [hli]
	push af
	ld a, [hli]
	push af
	ld c, $07

jr_019_76dd:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_019_76dd

	pop hl
	pop bc
	ld a, b
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ret


Jump_19_76EE::
	ld hl, $dce0
	ld e, $10

jr_019_76f3:
	rlc [hl]
	inc hl
	dec e
	jr nz, jr_019_76f3

	ret


Jump_19_76FA::
	ld hl, $dcf0
	ld e, $10

jr_019_76ff:
	rrc [hl]
	inc hl
	dec e
	jr nz, jr_019_76ff

	ret


	db $fd, $fc, $16, $00, $fc, $0c, $16, $00, $0e, $fb, $16, $00, $0c, $0d, $16, $00
	db $fb, $fd, $16, $00, $fa, $0b, $16, $00, $0b, $fc, $16, $00, $09, $0c, $16, $00
	db $fd, $fe, $16, $00, $fc, $0a, $16, $00, $0b, $fd, $16, $00, $08, $0a, $16, $00
	db $ff, $00, $16, $00, $00, $08, $16, $00, $0a, $ff, $16, $00, $08, $09, $16, $00
	db $02, $fc, $28, $00, $fb, $04, $28, $60, $05, $06, $28, $00, $01, $0a, $28, $20
	db $01, $ff, $28, $00, $f9, $04, $28, $60, $08, $06, $28, $00, $02, $07, $28, $20
	db $00, $00, $28, $20, $f8, $02, $28, $60, $04, $04, $28, $20, $0a, $07, $28, $20
	db $fe, $01, $28, $20, $04, $01, $28, $60, $04, $05, $28, $20, $0c, $07, $28, $20
	db $fd, $00, $28, $20, $04, $fe, $28, $60, $08, $08, $28, $20, $0e, $09, $28, $20
	db $fc, $ff, $28, $00, $04, $fa, $28, $40, $08, $09, $28, $20, $0f, $0a, $28, $00
	db $fb, $fe, $28, $00, $03, $f9, $28, $40, $08, $0c, $28, $00, $11, $0b, $28, $00
	db $fa, $fd, $28, $00, $01, $f7, $28, $40, $09, $0d, $28, $00, $0f, $0c, $28, $00

Call_19_77C6::
	ldh a, [$fff1]
	cp $ff
	jr z, jr_019_77e4

	cp $01
	jr z, jr_019_77e4

	ldh a, [$ffd7]
	and $0c
	sla a
	sla a
	ld e, a
	ld d, b
	ld hl, $7706
	add hl, de
	ld c, $04
	call Call_3D26
	ret


jr_019_77e4:
	inc a
	jr nz, jr_019_77ee

	ldh [$fff1], a
	ldh a, [$ffe7]
	xor c
	rra
	ret c

jr_019_77ee:
	ldh a, [$ffd7]
	and $1c
	xor $1c
	sla a
	sla a
	ld e, a
	ld d, b
	ld hl, $7746
	add hl, de
	ld c, $04
	call Call_3D26
	ret


Call_19_7804::
	call Call_3BD5
	jr nc, jr_019_7830

	call Call_094A
	ld a, [$c1a6]
	and a
	jr z, jr_019_7823

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_019_7823

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_019_7823:
	ld a, [$c14a]
	ld e, a
	call Call_0942
	call Call_1495
	ld a, e
	scf
	ret


jr_019_7830:
	and a
	ret


	db $06, $04, $02, $00

Call_19_7836::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7832
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


Call_19_7852::
	ld e, b
	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28

Call_19_785D::
	jr nc, jr_019_789d

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_019_789d

	inc e
	push de
	call Call_19_798D
	ldh a, [$ff9e]
	xor $01
	cp e
	pop de
	jr nz, jr_019_789d

Call_19_7878::
	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_019_789d

	ld a, [$db9a]
	cp $80
	jr nz, jr_019_789d

	ldh a, [$ffcc]
	and $10
	jr z, jr_019_789d

	scf
	ret


jr_019_789d:
	and a
	ret


Call_19_789F::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_019_78bf

	ld a, [$db95]
	cp $07
	jr z, jr_019_78bf

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_019_78bf

	ld a, [$c124]
	and a
	jr z, jr_019_78c0

jr_019_78bf:
	pop af

jr_019_78c0:
	ret


Call_19_78C1::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_790a

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
	call Call_19_790B
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_019_78fd

	call Call_3B9E

jr_019_78fd:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_019_790a:
	ret


Call_19_790B::
	call Call_19_7918

Call_19_790E::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_19_7918
	pop bc
	ret


Call_19_7918::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_7943

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

jr_019_7930:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_019_793a

	ld e, $f0

jr_019_793a:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_019_7943:
	ret


Call_19_7944::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_019_7943

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_019_7930

Call_19_795E::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_019_796c

	inc e

jr_019_796c:
	ld d, a
	ret


Call_19_796E::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_019_797c

	inc e

jr_019_797c:
	ld d, a
	ret


	db $1e, $02, $f0, $99, $21, $ec, $ff, $96, $cb, $7f, $20, $01, $1c, $57, $c9

Call_19_798D::
	call Call_19_795E
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_019_799a

	cpl
	inc a

jr_019_799a:
	push af
	call Call_19_796E
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_019_79a8

	cpl
	inc a

jr_019_79a8:
	pop de
	cp d
	jr nc, jr_019_79b0

	ldh a, [$ffd7]
	jr jr_019_79b2

jr_019_79b0:
	ldh a, [$ffd8]

jr_019_79b2:
	ld e, a
	ret


Call_19_79B4::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


	db $21, $c0, $c2, $09, $7e, $c7, $c6, $79, $d7, $79, $e8, $79, $cd, $91, $08, $36
	db $a0, $21, $20, $c4, $09, $36, $ff, $21, $c0, $c2, $09, $34, $c9, $cd, $91, $08
	db $20, $0b, $36, $c0, $21, $20, $c4, $09, $36, $ff, $cd, $d1, $79, $c9, $cd, $91
	db $08, $20, $09, $cd, $d7, $08, $cd, $bd, $27, $c3, $7a, $3f, $cd, $fa, $79, $c9
	db $e6, $07, $20, $1d, $cd, $ed, $27, $e6, $1f, $d6, $10, $5f, $21, $ee, $ff, $86
	db $77, $cd, $ed, $27, $e6, $1f, $d6, $14, $5f, $21, $ec, $ff, $86, $77, $cd, $1c
	db $7a, $c9, $cd, $a5, $78, $f0, $ee, $e0, $d7, $f0, $ec, $e0, $d8, $3e, $02, $cd
	db $53, $09, $3e, $13, $e0, $f4, $c9, $3e, $36, $cd, $01, $3c, $f0, $d7, $21, $00
	db $c2, $19, $77, $f0, $d8, $21, $10, $c2, $19, $77, $f0, $f9, $a7, $28, $08, $21
	db $50, $c2, $09, $36, $f0, $18, $0c, $21, $20, $c3, $19, $36, $10, $21, $10, $c3
	db $19, $36, $08, $cd, $b4, $79, $21, $f4, $ff, $36, $1a, $c9

Call_19_7A66::
	ld hl, $d800
	ldh a, [$fff6]
	ld e, a
	ld a, [$dba5]
	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_019_7a7b

	cp $06
	jr c, jr_019_7a7b

	inc d

jr_019_7a7b:
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
