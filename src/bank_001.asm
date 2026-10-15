; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

	db $fa, $96, $db, $c7, $10, $40, $41, $40, $4d, $40, $65, $40, $73, $40, $fd, $55
	db $cd, $cc, $1c, $cd, $22, $0b, $cd, $76, $17, $fa, $6b, $c1, $fe, $04, $20, $20
	db $3e, $03, $e0, $a9, $3e, $30, $e0, $aa, $cd, $45, $44, $af, $ea, $bf, $c1, $ea
	db $4f, $c1, $ea, $b8, $c1, $ea, $b9, $c1, $ea, $b5, $c1, $3e, $0f, $ea, $fe, $d6
	db $c9, $3e, $0d, $ea, $fe, $d6, $af, $ea, $3f, $c1, $c3, $45, $44, $3e, $0d, $ea
	db $ff, $d6, $3e, $ff, $ea, $9a, $db, $af, $e0, $96, $e0, $97, $ea, $6b, $c1, $ea
	db $6c, $c1, $c3, $45, $44, $cd, $c3, $17, $fa, $6b, $c1, $fe, $04, $20, $03, $cd
	db $45, $44, $c9, $cd, $eb, $40, $f0, $cc, $e6, $b0, $28, $6c, $3e, $13, $e0, $f2
	db $fa, $3f, $c1, $fe, $01, $28, $3b, $cd, $45, $44, $af, $ea, $6b, $c1, $ea, $6c
	db $c1, $fa, $a5, $db, $a7, $28, $07, $af, $ea, $0a, $c5, $ea, $16, $c1, $c9, $af
	db $ea, $98, $db, $ea, $99, $db, $e0, $48, $e0, $49, $ea, $97, $db, $e0, $47, $f0
	db $98, $ea, $9d, $db, $f0, $99, $ea, $9e, $db, $cd, $2a, $51, $3e, $80, $ea, $c7
	db $db, $c9, $cd, $d2, $27, $cd, $94, $5b, $cd, $85, $29, $cd, $1a, $5f

	ld a, $c7
	ldh [rLCDC], a
	ld [$d6fd], a
	ld a, $07
	ldh [rWX], a
	ld a, $80
	ld [$db9a], a
	ldh [rWY], a
	ld a, $07
	ldh [$ffa9], a
	ld a, $70
	ldh [$ffaa], a
	ret


	db $48, $58, $21, $3f, $c1, $cd, $2d, $6e, $f0, $cc, $e6, $4c, $28, $05, $7e, $3c
	db $e6, $01, $77, $5e, $16, $00, $21, $e9, $40, $19, $7e, $21, $18, $c0, $22, $3e
	db $24, $22, $3e, $be, $22, $36, $00, $c9, $f0, $b7, $a7, $c2, $7d, $41, $1e, $70
	db $3e, $00, $e0, $47, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $1d, $20, $db, $1e, $30, $3e, $40, $e0, $47, $1d, $20, $f9, $1e, $30
	db $3e, $80, $e0, $47, $1d, $20, $f9, $1e, $ff, $3e, $c0, $e0, $47, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1d
	db $20, $e7, $1e, $30, $3e, $80, $e0, $47, $1d, $20, $f9, $1e, $30, $3e, $40, $e0
	db $47, $1d, $20, $f9, $af, $ea, $97, $db, $e0, $47, $c9, $f0, $9c, $c7, $c5, $41
	db $49, $42, $53, $42, $7f, $42, $8e, $42, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a
	db $6a, $6a, $00, $00, $00, $0a, $04, $06, $00, $0a, $04, $06, $00, $0a, $04, $06
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1b, $1a, $19, $18, $17, $16
	db $15, $14, $13, $12, $11, $10, $10, $10, $10, $10, $10, $10, $af, $ea, $55, $c1
	db $ea, $56, $c1, $f0, $b7, $a7, $20, $48, $3e, $10, $e0, $b7, $3e, $01, $e0, $9c
	db $3e, $0f, $ea, $fe, $d6, $3e, $ff, $e0, $9d, $fa, $57, $db, $c6, $01, $27, $ea
	db $57, $db, $fa, $58, $db, $ce, $00, $27, $ea, $58, $db, $fe, $10, $38, $0a, $3e
	db $99, $ea, $57, $db, $3e, $09, $ea, $58, $db, $af, $ea, $bf, $c1, $ea, $15, $d4
	db $ea, $7c, $d4, $ea, $7a, $d4, $ea, $cb, $c3, $ea, $cc, $c3, $ea, $cd, $c3, $c9
	db $1f, $1f, $1f, $e6, $3f, $5f, $16, $00, $21, $91, $41, $19, $7e, $e0, $9d, $f0
	db $b7, $1f, $1f, $1f, $e6, $1f, $5f, $21, $a9, $41, $19, $7e, $ea, $cd, $c3, $3e
	db $01, $ea, $cb, $c3, $3e, $1c, $ea, $98, $db, $fa, $97, $db, $ea, $99, $db, $c9
	db $3e, $0d, $ea, $fe, $d6, $21, $9c, $ff, $34, $c9, $3e, $e4, $ea, $97, $db, $3e
	db $0a, $ea, $ff, $d6, $3e, $ff, $ea, $9a, $db, $af, $e0, $96, $e0, $97, $21, $9c
	db $ff, $34, $cd, $e2, $27, $c9, $00, $fe, $fd, $fe, $00, $02, $03, $02, $00, $04
	db $08, $0c, $10, $0c, $08, $04, $f0, $b7, $a7, $20, $09, $21, $9c, $ff, $34, $3e
	db $03, $ea, $68, $d3, $c9, $cd, $e6, $42, $f0, $cc, $e6, $b0, $28, $4b, $fa, $3f
	db $c1, $fe, $01, $28, $3e, $fe, $00, $28, $05, $ea, $d1, $db, $18, $03, $cd, $94
	db $5b, $af, $21, $80, $c2, $1e, $10, $22, $1d, $20, $fc, $ea, $98, $db, $ea, $99
	db $db, $e0, $48, $e0, $49, $ea, $97, $db, $e0, $47, $ea, $fb, $d6, $ea, $75, $d4
	db $f0, $98, $ea, $9d, $db, $f0, $99, $ea, $9e, $db, $cd, $2a, $51, $3e, $80, $ea
	db $c7, $db, $c9, $cd, $94, $5b, $cd, $1a, $5f, $c9, $50, $60, $70, $21, $3f, $c1
	db $cd, $2d, $6e, $f0, $cc, $e6, $48, $28, $08, $7e, $3c, $fe, $03, $20, $01, $af
	db $77, $f0, $cc, $e6, $04, $28, $09, $7e, $3d, $fe, $ff, $20, $02, $3e, $02, $77
	db $5e, $16, $00, $21, $e3, $42, $19, $7e, $21, $18, $c0, $22, $3e, $24, $22, $3e
	db $be, $22, $36, $00, $c9

	ld a, [$db96]
	rst $00

JumpTable_01_4322::
	dw Jump_01_433F
	dw Jump_01_43B3
	dw Jump_01_4434
	dw Jump_01_444A
	dw Jump_01_4468
	dw Jump_01_446F
	dw Jump_01_4476

	db $53, $0b, $00, $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00

Jump_01_433F::
	call Call_27D2
	call Call_01_4445
	ld a, [$dba5]
	and a
	jr z, jr_001_439c

	ldh a, [$fff7]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $db16
	add hl, de
	ld de, $dbcc
	ld c, $05

jr_001_435f:
	ldh a, [$fff7]
	cp $0a
	ldh a, [$fff7]
	cp $08
	jr z, jr_001_436b

	jr c, jr_001_436e

jr_001_436b:
	xor a
	jr z, jr_001_436f

jr_001_436e:
	ld a, [hli]

jr_001_436f:
	ld [de], a
	inc de
	dec c
	jr nz, jr_001_435f

	ldh a, [$fff7]
	ld e, a
	ld d, $00
	ld hl, $4332
	add hl, de
	ld a, [hl]
	ld [$dbb0], a
	ld a, e
	cp $08
	jr z, jr_001_43ad

	cp $0a
	jr nc, jr_001_43ad

	cp $06
	jr nz, jr_001_4393

	ldh a, [$fff9]
	and a
	jr nz, jr_001_43ad

jr_001_4393:
	call Call_01_5357
	ld a, $07
	ld [$d6ff], a
	ret


jr_001_439c:
	ld a, $02
	ld [$d6ff], a
	call Call_27ED
	ld hl, $ffe7
	or [hl]
	and $03
	ldh [$ffb9], a
	ret


jr_001_43ad:
	ld a, $09
	ld [$d6ff], a
	ret


Jump_01_43B3::
	call Call_2980
	xor a
	ld [$c11c], a
	call Call_01_4445
	ld a, [$db9d]
	ldh [$ff98], a
	ld [$dbb1], a
	ld a, [$db9e]
	ldh [$ff99], a
	ld [$dbb2], a
	ld a, [$dbc8]
	ldh [$ffa2], a
	and a
	jr z, jr_001_43da

	ld a, $02
	ld [$c146], a

jr_001_43da:
	ld a, $04
	ld [$c125], a
	call Call_2ED7
	call Call_36E6
	call Call_01_5D6B
	ld a, $ff
	ldh [$ffa6], a
	ld a, [$dba5]
	and a
	jr z, jr_001_4426

	ld d, a
	ldh a, [$fff7]
	cp $1a
	jr nc, jr_001_43fe

	cp $06
	jr c, jr_001_43fe

	inc d

jr_001_43fe:
	ldh a, [$fff6]
	ld e, a
	call Call_29B8
	cp $1a
	jr z, jr_001_4415

	cp $19
	jr z, jr_001_4415

	ld a, [$c18e]
	and $e0
	cp $80
	jr nz, jr_001_4426

jr_001_4415:
	ld a, [$dbcd]
	and a
	jr z, jr_001_4426

	ldh a, [$fff8]
	and $10
	jr nz, jr_001_4426

	ld a, $0c
	ld [$d462], a

jr_001_4426:
	ld a, [$dba5]
	and a
	ld a, $06
	jr nz, jr_001_4430

	ld a, $07

jr_001_4430:
	ld [$d6fe], a
	ret


Jump_01_4434::
	ld a, $0f
	ldh [$ff94], a
	call Call_09AA
	xor a
	ldh [$ff90], a
	ldh [$ff91], a
	ld a, $09
	ld [$d6fe], a

Call_01_4445::
	ld hl, $db96
	inc [hl]
	ret


Jump_01_444A::
	ld a, $01
	ld [$d6fe], a
	ld a, [$d6fa]
	and a
	jr z, jr_001_4464

	ld a, $05
	ld [$d6f8], a
	ld a, [$c1cb]
	and a
	jr z, jr_001_4464

	ld a, $03
	ldh [$ffa5], a

jr_001_4464:
	call Call_01_4445
	ret


Jump_01_4468::
	call Call_3E6F
	call Call_01_4445
	ret


Jump_01_446F::
	call Call_3E8A
	call Call_01_4445
	ret


Jump_01_4476::
	call Call_01_5643
	ldh a, [rLCDC]
	or $20
	ld [$d6fd], a
	ldh [rLCDC], a
	call Call_01_4445
	ld a, [$c11c]
	ld [$d463], a
	ld a, $04
	ld [$c11c], a
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ld a, [$c3cb]
	and a
	jr z, jr_001_44b2

	ld a, [$c5ad]
	ld [$db97], a
	ld a, $1c
	ld [$db98], a
	ld a, $e4
	ld [$db99], a
	ld a, $04
	ld [$c16b], a

jr_001_44b2:
	jp Call_27BD


	db $f0, $cc, $e6, $90, $ca, $cb, $45

Jump_001_44bc:
	ld [$d47b], a

Jump_001_44bf:
	call Call_27B5
	ld a, [$a454]
	ld [$db80], a
	call Call_27B5
	ld a, [$a455]
	ld [$db81], a
	call Call_27B5
	ld a, [$a456]
	ld [$db82], a
	call Call_27B5
	ld a, [$a457]
	ld [$db83], a
	call Call_27B5
	ld a, [$a458]
	ld [$db84], a
	call Call_27B5
	ld a, [$a45f]
	ld [$dc06], a
	call Call_27B5
	ld a, [$a460]
	ld [$dc09], a
	call Call_27B5
	ld a, [$a45c]
	ld [$dc00], a
	call Call_27B5
	ld a, [$a45d]
	ld [$dc01], a
	call Call_27B5
	ld a, [$a7d9]
	ld [$db85], a
	call Call_27B5
	ld a, [$a7da]
	ld [$db86], a
	call Call_27B5
	ld a, [$a7db]
	ld [$db87], a
	call Call_27B5
	ld a, [$a7dc]
	ld [$db88], a
	call Call_27B5
	ld a, [$a7dd]
	ld [$db89], a
	call Call_27B5
	ld a, [$a7e4]
	ld [$dc07], a
	call Call_27B5
	ld a, [$a7e5]
	ld [$dc0a], a
	call Call_27B5
	ld a, [$a7e1]
	ld [$dc02], a
	call Call_27B5
	ld a, [$a7e2]
	ld [$dc03], a
	call Call_27B5
	ld a, [$ab5e]
	ld [$db8a], a
	call Call_27B5
	ld a, [$ab5f]
	ld [$db8b], a
	call Call_27B5
	ld a, [$ab60]
	ld [$db8c], a
	call Call_27B5
	ld a, [$ab61]
	ld [$db8d], a
	call Call_27B5
	ld a, [$ab62]
	ld [$db8e], a
	call Call_27B5
	ld a, [$ab69]
	ld [$dc08], a
	call Call_27B5
	ld a, [$ab6a]
	ld [$dc0b], a
	call Call_27B5
	ld a, [$ab66]
	ld [$dc04], a
	call Call_27B5
	ld a, [$ab67]
	ld [$dc05], a
	ld a, $02
	ld [$db95], a
	xor a
	ld [$db96], a
	xor a
	ldh [$ff97], a
	ldh [$ff96], a
	ld a, $00
	ld [$db97], a
	ld [$db98], a
	ld [$db99], a
	ret


	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $01, $01, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02
	db $01, $01, $01, $01, $03, $01, $01, $01, $01, $04, $01, $01, $01, $01, $05, $01
	db $01, $01, $01, $06, $01, $01, $01, $01, $07, $01, $01, $01, $01, $08, $01, $01
	db $01, $01, $09

	ld de, $0000
	call Call_01_46DD
	ld de, $0385
	call Call_01_46DD
	ld de, $070a
	call Call_01_46DD
	ld a, [$0003]
	and a
	jp z, Jump_001_46dc

	ld e, $00
	ld d, $00
	ld bc, $a405

jr_001_462f:
	ld hl, $45cc
	add hl, de
	ld a, [hli]
	ld [bc], a
	inc bc
	inc e
	ld a, e
	cp $43
	jr nz, jr_001_462f

	ld a, $01
	ld [$a453], a
	ld a, $01
	ld [$a449], a
	ld a, $02
	ld [$a448], a
	ld hl, $a46a
	ld e, $09
	ld a, $02

jr_001_4652:
	ld [hli], a
	dec e
	jr nz, jr_001_4652

	ld a, $60
	ld [$a452], a
	ld [$a47d], a
	ld [$a47c], a
	ld [$a44a], a
	ld a, $40
	ld [$a47b], a
	ld [$a451], a
	ld a, $89
	ld [$a44c], a
	ld a, $00
	ld [$a414], a
	ld a, $07
	ld [$a44e], a
	ld a, $05
	ld [$a462], a
	ld a, $09
	ld [$a463], a
	ld a, $01
	ld [$a44d], a
	ld a, $50
	ld [$a45f], a
	ld a, $0a
	ld [$a460], a
	ld a, $5b
	ld [$a454], a
	ld a, $46
	ld [$a455], a
	ld a, $4d
	ld [$a456], a
	ld a, $45
	ld [$a457], a
	ld a, $42
	ld [$a458], a
	ld a, $00
	ld [$a45c], a
	ld [$a45d], a
	ld a, $00
	ld [$a45b], a
	ld [$a464], a
	ld a, $00
	ld [$a465], a
	ld a, $92
	ld [$a466], a
	ld a, $48
	ld [$a467], a
	ld a, $62
	ld [$a468], a
	ld hl, $a105
	ld a, $80
	ld e, $00

jr_001_46d8:
	ld [hli], a
	dec e
	jr nz, jr_001_46d8

Jump_001_46dc:
	ret


Call_01_46DD::
	ld c, $01
	ld b, $05
	ld hl, $a100
	add hl, de

jr_001_46e5:
	call Call_27B5
	ld a, [hli]
	cp c
	jr nz, jr_001_46f3

	inc c
	inc c
	dec b
	jr nz, jr_001_46e5

	jr jr_001_4710

jr_001_46f3:
	ld hl, $a100
	add hl, de
	ld a, $01

jr_001_46f9:
	call Call_27B5
	ld [hli], a
	inc a
	inc a
	cp $0b
	jr c, jr_001_46f9

	ld de, $0380

jr_001_4706:
	call Call_27B5
	xor a
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, jr_001_4706

jr_001_4710:
	ret


	call Call_01_5B6E
	ld a, [$db96]
	rst $00

JumpTable_01_4718::
	dw Jump_01_472C
	dw Jump_01_4738
	dw Jump_01_4740
	dw Jump_01_4749
	dw Jump_01_474F
	dw Jump_01_4792
	dw Jump_01_47F6
	dw Jump_01_4828
	dw Jump_01_48DE
	dw Jump_01_4948

Jump_01_472C::
	ld a, $04
	ld [$d6fe], a
	xor a
	ld [$d000], a
	jp Call_01_4445


Jump_01_4738::
	ld a, $08
	ld [$d6fe], a
	jp Call_01_4445


Jump_01_4740::
	call Call_01_4C4D
	call Call_01_4C66
	jp Call_01_4445


Jump_01_4749::
	call Call_01_4C7E
	jp Call_01_4445


Jump_01_474F::
	ld a, [$dba7]
	and $01
	jr z, jr_001_4764

	ld a, [$dc00]
	ld h, a
	ld a, [$dc01]
	ld l, a
	ld de, $98e7
	call Call_01_4DED

jr_001_4764:
	ld a, [$dba7]
	and $02
	jr z, jr_001_4779

	ld a, [$dc02]
	ld h, a
	ld a, [$dc03]
	ld l, a
	ld de, $9947
	call Call_01_4DED

jr_001_4779:
	ld a, [$dba7]
	and $04
	jr z, jr_001_478e

	ld a, [$dc04]
	ld h, a
	ld a, [$dc05]
	ld l, a
	ld de, $99a7
	call Call_01_4DED

jr_001_478e:
	jp Call_01_4445


	db $c9

Jump_01_4792::
	jp Jump_001_4c14


Call_01_4795::
	push de
	ld a, [$d600]
	ld e, a
	ld d, $00
	ld hl, $d601
	add hl, de
	add $10
	ld [$d600], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $04
	ld [hli], a
	pop de
	push de
	ld a, $05

jr_001_47b0:
	ldh [$ffd7], a
	ld a, [de]
	and a
	ld a, $7e
	jr z, jr_001_47c4

	ld a, [de]
	dec a
	push bc
	push hl
	ld c, a
	ld b, $00
	call Call_08B1
	pop hl
	pop bc

jr_001_47c4:
	ld [hli], a
	inc de
	ldh a, [$ffd7]
	dec a
	jr nz, jr_001_47b0

	ld a, b
	ld [hli], a
	ld a, c
	sub $20
	ld [hli], a
	ld a, $04
	ld [hli], a
	pop de
	ld a, $05

jr_001_47d7:
	ldh [$ffd7], a
	ld a, [de]
	and a
	jr jr_001_47e0

	db $3d, $e6, $c0

jr_001_47e0:
	ld a, $7e
	jr jr_001_47ec

	db $1a, $e6, $80, $3e, $c8, $28, $01, $3c

jr_001_47ec:
	ld [hli], a
	inc de
	ldh a, [$ffd7]
	dec a
	jr nz, jr_001_47d7

	xor a
	ld [hl], a
	ret


Jump_01_47F6::
	ld a, [$d47b]
	and a
	jr z, jr_001_4805

	xor a
	ld [$d47b], a
	ld a, $11
	ld [$d368], a

jr_001_4805:
	ld a, [$dba7]
	and a
	ld a, $03
	jr z, jr_001_480f

	ld a, $04

jr_001_480f:
	ld [$d6ff], a
	ld a, $e4
	ld [$db97], a
	ld a, $1c
	ld [$db98], a
	ld a, $e4
	ld [$db99], a
	jp Call_01_4445


	db $3b, $53, $6b, $83

Jump_01_4828::
	call Call_01_6E2D
	ldh a, [$ffcc]
	and $90
	jr z, jr_001_4834

	jp Call_01_4445


jr_001_4834:
	ldh a, [$ffcc]
	and $4c
	jr z, jr_001_4864

	ld c, $02
	ld a, [$dba7]
	and a
	jr z, jr_001_4843

	inc c

jr_001_4843:
	ldh a, [$ffcc]
	bit 6, a
	jr nz, jr_001_484d

	bit 2, a
	jr nz, jr_001_4859

jr_001_484d:
	ld a, [$dba6]
	add $01
	inc c
	cp c
	jr c, jr_001_4861

	xor a
	jr jr_001_4861

jr_001_4859:
	ld a, [$dba6]
	sub $01
	jr nc, jr_001_4861

	ld a, c

jr_001_4861:
	ld [$dba6], a

jr_001_4864:
	ld a, [$dba6]
	cp $03
	jr nz, jr_001_4898

	ldh a, [$ffcc]
	and $03
	jr z, jr_001_487c

	call Call_01_6E33
	ld a, [$d000]
	xor $01
	ld [$d000], a

jr_001_487c:
	ldh a, [$ffe7]
	and $10
	jr nz, jr_001_4898

	ld a, [$d000]
	and a
	ld a, $2c
	jr z, jr_001_488c

	ld a, $64

jr_001_488c:
	ld hl, $c008
	ld [hl], $88
	inc hl
	ld [hli], a
	ld a, $be
	ld [hli], a
	xor a
	ld [hl], a

jr_001_4898:
	ld a, [$dba6]
	ld e, a
	ld d, $00
	ld hl, $4824
	add hl, de
	ldh a, [$ffe7]
	and $08
	jr z, jr_001_48c3

	ld a, [hl]
	ld hl, $c000
	push af
	ld [hli], a
	ld a, $18
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $00
	ld [hli], a
	pop af
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret


jr_001_48c3:
	ld a, [hl]
	ld hl, $c000
	push af
	ld [hli], a
	ld a, $18
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, $20
	ld [hli], a
	pop af
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $20
	ld [hl], a
	ret


Jump_01_48DE::
	ld a, [$dba6]
	cp $03
	jr z, jr_001_4922

	ld a, [$dba6]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld c, $05
	ld hl, $db80
	add hl, de

jr_001_48f7:
	ld a, [hli]
	and a
	jr nz, jr_001_490c

	dec c
	jr nz, jr_001_48f7

	xor a
	ld [$db96], a
	ld a, $03
	ld [$db95], a

Call_01_4907::
	ld a, $13
	ldh [$fff2], a
	ret


jr_001_490c:
	call Call_01_4907
	ld a, $00
	ld [$db97], a
	ld [$db98], a
	ld [$db99], a
	ld a, $05
	ld [$d6fe], a
	jp Call_01_4445


jr_001_4922:
	xor a
	ld [$db96], a
	ld a, [$d000]
	and a
	ld a, $04
	jr z, jr_001_4930

	ld a, $05

jr_001_4930:
	ld [$db95], a
	jp Call_01_4907


	db $05, $a4, $8a, $a7, $0f, $ab, $05, $a1, $8a, $a4, $0f, $a8, $00, $a1, $85, $a4
	db $0a, $a8

Jump_01_4948::
	jp Jump_001_512a


	ld a, [$db96]
	rst $00

JumpTable_01_494F::
	dw Jump_01_4955
	dw Jump_01_4968
	dw Jump_01_4986

Jump_01_4955::
	call Call_01_4445
	ld a, $08
	ld [$d6fe], a
	xor a
	ld [$dba8], a
	ld [$dba9], a
	ld [$dbaa], a
	ret


Jump_01_4968::
	ld a, $05
	ld [$d6ff], a
	ld hl, $d601
	ld a, $98
	ld [hli], a
	ld a, $48
	ld [hli], a
	xor a
	ld [hli], a
	ld a, [$dba6]
	add $ab
	ld [hli], a
	xor a
	ld [hl], a
	jp Call_01_4445


	db $00, $05, $0a

Jump_01_4986::
	ld a, [$dba6]
	ld e, a
	ld d, $00
	ld hl, $4983
	add hl, de
	ld e, [hl]
	ld hl, $db80
	add hl, de
	push hl
	pop de
	ld bc, $9849
	call Call_01_4795
	ldh a, [$ffcc]
	and $80
	jr z, jr_001_4a14

	call Call_01_4907
	ld a, [$dba6]
	sla a
	ld e, a
	ld d, $00
	ld hl, $4936
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, $004f
	add hl, de
	push hl
	ld a, [$dba6]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $db80
	add hl, de
	ld a, [hli]
	cp $5b
	jr nz, jr_001_49e9

	ld a, [hli]
	cp $46
	jr nz, jr_001_49e9

	ld a, [hli]
	cp $4d
	jr nz, jr_001_49e9

	ld a, [hli]
	cp $45
	jr nz, jr_001_49e9

	ld a, [hli]
	cp $42
	jr nz, jr_001_49e9

	ld a, $60
	ld [$d368], a

jr_001_49e9:
	ld hl, $db80
	add hl, de
	pop bc
	ld e, $05

jr_001_49f0:
	call Call_27B5
	ld a, [hli]
	ld [bc], a
	inc bc
	dec e
	jr nz, jr_001_49f0

	pop hl
	push hl
	ld de, $005a
	add hl, de
	ld [hl], $18
	pop hl
	push hl
	ld de, $005b
	add hl, de
	ld [hl], $03
	pop hl
	ld de, $0057
	add hl, de
	xor a
	ld [hli], a
	ld [hl], a
	jp Jump_001_44bf


jr_001_4a14:
	call Call_01_4AE0
	call Call_01_4B75
	ret


	db $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
	db $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48
	db $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
	db $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $4c, $54, $5c, $64, $6c, $42, $43, $44, $45, $46, $47, $48, $00, $00, $62, $63
	db $64, $65, $66, $67, $68, $49, $4a, $4b, $4c, $4d, $4e, $4f, $00, $00, $69, $6a
	db $6b, $6c, $6d, $6e, $6f, $50, $51, $52, $53, $54, $55, $56, $00, $00, $70, $71
	db $72, $73, $74, $75, $76, $57, $58, $59, $5a, $5b, $00, $00, $00, $00, $77, $78
	db $79, $7a, $7b, $00, $00

Call_01_4AE0::
	ldh a, [$ffcc]

jr_001_4ae2:
	ldh [$ffd7], a
	ldh a, [$ffd7]
	and $0c
	jr nz, jr_001_4b2c

	ldh a, [$ffd7]
	and $03
	jr nz, jr_001_4b0c

	ldh a, [$ffcb]
	ld hl, $c182
	and $0f
	jr nz, jr_001_4afd

	xor a
	ld [hl], a
	jr jr_001_4b0a

jr_001_4afd:
	ld a, [hl]
	inc a
	ld [hl], a
	cp $18
	jr nz, jr_001_4b0a

	ld [hl], $15
	ldh a, [$ffcb]
	jr jr_001_4ae2

jr_001_4b0a:
	jr jr_001_4b4e

jr_001_4b0c:
	call Call_01_6E33
	bit 1, a
	jr nz, jr_001_4b1f

	ld a, [$dba9]
	add $01
	cp $40
	jr c, jr_001_4b49

	xor a
	jr jr_001_4b49

jr_001_4b1f:
	ld a, [$dba9]
	sub $01
	cp $ff
	jr nz, jr_001_4b49

	ld a, $3f
	jr jr_001_4b49

jr_001_4b2c:
	call Call_01_6E33
	bit 2, a
	jr z, jr_001_4b3e

	ld a, [$dba9]
	sub $10
	jr nc, jr_001_4b49

	add $40
	jr jr_001_4b49

jr_001_4b3e:
	ld a, [$dba9]
	add $10
	cp $40
	jr c, jr_001_4b49

	sub $40

jr_001_4b49:
	ld [$dba9], a
	jr jr_001_4b4e

jr_001_4b4e:
	ld a, [$dba9]
	ld hl, $4a5b
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
	ld a, [$dba9]
	ld hl, $4a1b
	ld c, a
	ld b, $00
	add hl, bc
	ld d, [hl]
	ld hl, $c000
	ld a, d
	add $0b
	ld [hli], a
	ld a, e
	add $04
	ld [hli], a
	ld a, $e0
	ld [hli], a
	xor a
	ld [hl], a
	ret


Call_01_4B75::
	ldh a, [$ffcc]
	and $30
	jr z, jr_001_4ba2

	bit 5, a
	jr nz, jr_001_4b92

	call Call_01_4907
	call Call_01_4BC5
	ld a, [$dbaa]
	add $01
	cp $05
	jr c, jr_001_4b9f

	ld a, $04
	jr jr_001_4b9f

jr_001_4b92:
	call Call_01_4907
	ld a, [$dbaa]
	sub $01
	cp $ff
	jr nz, jr_001_4b9f

	xor a

jr_001_4b9f:
	ld [$dbaa], a

jr_001_4ba2:
	ld a, [$dbaa]
	ld hl, $4a9b
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
	ldh a, [$ffe7]
	and $10
	jr z, jr_001_4bc4

	ld hl, $c004
	ld a, $18
	add $0b
	ld [hli], a
	ld a, e
	add $04
	ld [hli], a
	ld a, $e0
	ld [hli], a
	xor a
	ld [hl], a

jr_001_4bc4:
	ret


Call_01_4BC5::
	ld a, [$dba9]
	ld c, a
	ld b, $00
	ld hl, $4aa0
	add hl, bc
	ld a, [hl]
	ld e, a
	ld a, [$dba6]
	ld c, a
	sla a
	sla a
	add c
	ld c, a
	ld hl, $db80
	add hl, bc
	ld a, [$dbaa]
	ld c, a
	add hl, bc
	ld [hl], e
	ret


	db $cd, $6e, $5b, $fa, $96, $db, $c7, $fd, $4b, $0c, $4c, $14, $4c, $20, $4c, $29
	db $4c, $2f, $4c, $ae, $4c, $13, $4d, $3e, $08, $ea, $fe, $d6, $af, $ea, $a6, $db
	db $ea, $00, $d0, $c3, $45, $44, $3e, $06, $ea, $ff, $d6, $c3, $45, $44

Jump_001_4c14:
	call Call_01_4C32
	call Call_01_4C3B
	call Call_01_4C44
	jp Call_01_4445


	db $cd, $4d, $4c, $cd, $66, $4c, $c3, $45, $44, $cd, $7e, $4c, $c3, $45, $44, $c3
	db $4f, $47

Call_01_4C32::
	ld bc, $98c5
	ld de, $db80
	jp Call_01_4795


Call_01_4C3B::
	ld bc, $9925
	ld de, $db85
	jp Call_01_4795


Call_01_4C44::
	ld bc, $9985
	ld de, $db8a
	jp Call_01_4795


Call_01_4C4D::
	ld a, [$dba7]
	and $01
	jr z, jr_001_4c65

	ld a, $00
	ldh [$ffdb], a
	ld a, [$dc06]
	ldh [$ffd9], a
	ld a, [$dc09]
	ldh [$ffda], a
	jp Jump_001_5b01


jr_001_4c65:
	ret


Call_01_4C66::
	ld a, [$dba7]
	and $02
	jr z, jr_001_4c65

	ld a, $01
	ldh [$ffdb], a
	ld a, [$dc07]
	ldh [$ffd9], a
	ld a, [$dc0a]
	ldh [$ffda], a
	jp Jump_001_5b01


Call_01_4C7E::
	ld a, [$dba7]
	and $04
	jr z, jr_001_4c65

	ld a, $02
	ldh [$ffdb], a
	ld a, [$dc08]
	ldh [$ffd9], a
	ld a, [$dc0b]
	ldh [$ffda], a
	jp Jump_001_5b01


	db $98, $a5, $44, $7e, $98, $c5, $44, $7e, $99, $05, $44, $7e, $99, $25, $44, $7e
	db $99, $65, $44, $7e, $99, $85, $44, $7e, $cd, $2d, $6e, $f0, $cc, $e6, $48, $28
	db $09, $fa, $a6, $db, $3c, $e6, $03, $ea, $a6, $db, $f0, $cc, $e6, $04, $28, $0d
	db $fa, $a6, $db, $3d, $fe, $ff, $20, $02, $3e, $03, $ea, $a6, $db, $f0, $cc, $e6
	db $90, $28, $36, $fa, $a6, $db, $fe, $03, $20, $03, $c3, $bf, $44, $cd, $07, $49
	db $cd, $45, $44, $18, $12, $99, $e4, $0d, $7e, $7e, $10, $14, $08, $13, $7e, $7e
	db $7e, $7e, $0e, $0a, $7e, $7e, $00, $21, $01, $d6, $11, $eb, $4c, $0e, $11, $1a
	db $13, $22, $0d, $79, $fe, $ff, $20, $f7, $c9, $cd, $98, $48, $c9, $f0, $cc, $cb
	db $6f, $20, $2d, $e6, $90, $28, $64, $fa, $00, $d0, $a7, $ca, $bf, $44, $cd, $07
	db $49, $fa, $a6, $db, $cb, $27, $5f, $16, $00, $21, $3c, $49, $19, $2a, $66, $6f
	db $11, $80, $03, $cd, $b5, $27, $af, $22, $1b, $7b, $b2, $20, $f6, $c3, $bf, $44
	db $cd, $8d, $4d, $cd, $63, $4d, $21, $96, $db, $35, $c9, $99, $e4, $0d, $11, $04
	db $13, $14, $11, $0d, $7e, $13, $0e, $7e, $0c, $04, $0d, $14, $00, $fa, $00, $d6
	db $5f, $c6, $11, $ea, $00, $d6, $16, $00, $21, $01, $d6, $19, $11, $51, $4d, $0e
	db $11, $1a, $13, $22, $0d, $79, $fe, $ff, $20, $f7, $c9, $cd, $b4, $4d, $cd, $98
	db $48, $f0, $e7, $e6, $10, $28, $0a, $fa, $a6, $db, $c7, $32, $4c, $3b, $4c, $44
	db $4c, $fa, $a6, $db, $17, $17, $17, $e6, $f8, $5f, $16, $00, $21, $96, $4c, $19
	db $11, $01, $d6, $0e, $08, $2a, $12, $13, $0d, $20, $fa, $af, $12, $c9, $f0, $cc
	db $e6, $43, $28, $0b, $cd, $33, $6e, $fa, $00, $d0, $ee, $01, $ea, $00, $d0, $f0
	db $e7, $e6, $10, $20, $17, $fa, $00, $d0, $5f, $3e, $28, $1d, $20, $02, $3e, $6c
	db $21, $0c, $c0, $36, $88, $23, $22, $3e, $be, $22, $af, $77, $c9, $b0, $b1, $b2
	db $b3, $b4, $b5, $b6, $b7, $b8, $b9

Call_01_4DED::
	push hl
	ld a, [$d600]
	ld c, a
	add $06
	ld [$d600], a
	ld b, $00
	ld hl, $d601
	add hl, bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $02
	ld [hli], a
	pop bc
	push hl
	ld a, c
	and $0f
	ld e, a
	ld d, $00
	ld hl, $4de3
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld a, b
	and $f0
	swap a
	ld e, a
	ld d, $00
	ld hl, $4de3
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	push hl
	ld a, b
	and $0f
	ld e, a
	ld d, $00
	ld hl, $4de3
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	xor a
	ld [hl], a
	ret


	db $fa, $96, $db, $c7, $46, $4e, $5b, $4e, $63, $4e, $81, $4e, $9f, $4e, $65, $4f
	db $6f, $50, $3e, $08, $ea, $fe, $d6, $af, $ea, $a6, $db, $ea, $00, $d0, $ea, $01
	db $d0, $ea, $02, $d0, $c3, $45, $44, $3e, $0c, $ea, $ff, $d6, $c3, $45, $44, $01
	db $c4, $98, $11, $80, $db, $cd, $95, $47, $01, $24, $99, $11, $85, $db, $cd, $95
	db $47, $01, $84, $99, $11, $8a, $db, $cd, $95, $47, $c3, $45, $44, $01, $cd, $98
	db $11, $80, $db, $cd, $95, $47, $01, $2d, $99, $11, $85, $db, $cd, $95, $47, $01
	db $8d, $99, $11, $8a, $db, $cd, $95, $47, $c3, $45, $44, $cd, $2d, $6e, $f0, $cc
	db $e6, $48, $28, $09, $fa, $01, $d0, $3c, $e6, $03, $ea, $01, $d0, $f0, $cc, $e6
	db $04, $28, $0d, $fa, $01, $d0, $3d, $fe, $ff, $20, $02, $3e, $03, $ea, $01, $d0
	db $f0, $cc, $e6, $90, $28, $0e, $fa, $01, $d0, $fe, $03, $ca, $bf, $44, $cd, $45
	db $44, $cd, $07, $49, $fa, $01, $d0, $5f, $16, $00, $21, $24, $48, $19, $f0, $e7
	db $e6, $08, $7e, $21, $00, $c0, $28, $17, $f5, $22, $3e, $10, $22, $3e, $00, $22
	db $3e, $00, $22, $f1, $22, $3e, $18, $22, $3e, $02, $22, $3e, $00, $77, $c9, $f5
	db $22, $3e, $10, $22, $3e, $02, $22, $3e, $20, $22, $f1, $22, $3e, $18, $22, $3e
	db $00, $22, $3e, $20, $77, $c9, $fa, $01, $d0, $5f, $16, $00, $21, $24, $48, $19
	db $7e, $21, $00, $c0, $c6, $05, $22, $3e, $14, $22, $3e, $be, $22, $3e, $00, $77
	db $c9, $98, $a4, $44, $7e, $98, $c4, $44, $7e, $99, $04, $44, $7e, $99, $24, $44
	db $7e, $99, $64, $44, $7e, $99, $84, $44, $7e, $98, $ad, $44, $7e, $98, $cd, $44
	db $7e, $99, $0d, $44, $7e, $99, $2d, $44, $7e, $99, $6d, $44, $7e, $99, $8d, $44
	db $7e, $cd, $2d, $6e, $f0, $cc, $e6, $48, $28, $09, $fa, $02, $d0, $3c, $e6, $03
	db $ea, $02, $d0, $f0, $cc, $e6, $04, $28, $0d, $fa, $02, $d0, $3d, $fe, $ff, $20
	db $02, $3e, $03, $ea, $02, $d0, $cd, $1a, $4f, $f0, $cc, $cb, $6f, $28, $07, $21
	db $96, $db, $35, $c3, $d5, $4f, $e6, $90, $28, $11, $fa, $02, $d0, $fe, $03, $ca
	db $bf, $44, $cd, $07, $49, $cd, $45, $44, $c3, $fd, $4c, $cd, $fb, $4f, $f0, $e7
	db $e6, $10, $28, $1d, $fa, $01, $d0, $17, $17, $17, $e6, $f8, $5f, $16, $00, $21
	db $35, $4f, $19, $11, $01, $d6, $0e, $08, $2a, $12, $13, $0d, $20, $fa, $af, $12
	db $c9, $fa, $01, $d0, $fe, $01, $28, $0d, $fe, $02, $28, $12, $01, $c4, $98, $11
	db $80, $db, $c3, $95, $47, $01, $24, $99, $11, $85, $db, $c3, $95, $47, $01, $84
	db $99, $11, $8a, $db, $c3, $95, $47, $fa, $02, $d0, $5f, $16, $00, $21, $24, $48
	db $19, $fa, $02, $d0, $fe, $03, $ca, $49, $50, $f0, $e7, $e6, $08, $28, $1b, $7e
	db $21, $08, $c0, $f5, $22, $3e, $58, $22, $3e, $00, $22, $3e, $00, $22, $f1, $22
	db $3e, $60, $22, $3e, $02, $22, $3e, $00, $77, $c9, $7e, $21, $08, $c0, $f5, $22
	db $3e, $58, $22, $3e, $02, $22, $3e, $20, $22, $f1, $22, $3e, $60, $22, $3e, $00
	db $22, $3e, $20, $77, $c9, $f0, $e7, $e6, $08, $7e, $21, $08, $c0, $c3, $ea, $4e
	db $fa, $02, $d0, $5f, $16, $00, $21, $24, $48, $19, $7e, $21, $08, $c0, $c6, $05
	db $22, $3e, $5c, $22, $3e, $be, $22, $3e, $00, $77, $c9, $cd, $1a, $4f, $cd, $54
	db $50, $cd, $b4, $4d, $f0, $cc, $e6, $90, $28, $3d, $fa, $00, $d0, $a7, $ca, $bf
	db $44, $cd, $07, $49, $fa, $01, $d0, $cb, $27, $5f, $16, $00, $21, $42, $49, $19
	db $4e, $23, $46, $fa, $02, $d0, $cb, $27, $5f, $16, $00, $21, $42, $49, $19, $7e
	db $23, $66, $6f, $11, $85, $03, $cd, $b5, $27, $0a, $03, $cd, $b5, $27, $22, $1b
	db $7b, $b2, $20, $f2, $c3, $bf, $44, $f0, $cc, $cb, $6f, $28, $0e, $21, $96, $db
	db $35, $af, $ea, $00, $d0, $cd, $63, $4d, $c3, $f5, $50, $cd, $b2, $4f, $f0, $e7
	db $e6, $10, $28, $1d, $fa, $02, $d0, $17, $17, $17, $e6, $f8, $5f, $16, $00, $21
	db $4d, $4f, $19, $11, $09, $d6, $0e, $08, $2a, $12, $13, $0d, $20, $fa, $af, $12
	db $c9, $fa, $02, $d0, $fe, $01, $28, $0d, $fe, $02, $28, $12, $01, $cd, $98, $11
	db $80, $db, $c3, $95, $47, $01, $2d, $99, $11, $85, $db, $c3, $95, $47, $01, $8d
	db $99, $11, $8a, $db, $c3, $95, $47, $18, $18, $18, $18, $18, $18, $28, $28, $28
	db $28, $38, $38, $38, $38, $50

Jump_001_512a:
	xor a
	ldh [$fff9], a
	ld a, [$db5a]
	and a
	jr nz, jr_001_5141

	ld a, [$db5b]
	ld e, a
	ld d, $00
	ld hl, $511b
	add hl, de
	ld a, [hl]
	ld [$db5a], a

jr_001_5141:
	ld hl, $dbd1
	ld a, [hl]
	ld [hl], $00
	and a
	jr nz, jr_001_516a

	ld a, [$dba6]
	sla a
	ld e, a
	ld d, $00
	ld hl, $493c
	add hl, de
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld hl, $d800
	ld de, $0380

jr_001_515f:
	call Call_27B5
	ld a, [bc]
	inc bc
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, jr_001_515f

jr_001_516a:
	ld a, $0b
	ld [$db95], a
	xor a
	ld [$db96], a
	xor a
	ld [$c11c], a
	ldh [$ff9c], a
	ld [$db93], a
	ld [$db94], a
	ld [$db90], a
	ld [$db8f], a
	ld [$db92], a
	ld [$db91], a
	ld a, [$db6f]
	and a
	jr nz, jr_001_51a0

	ld a, $16
	ld [$db6f], a
	ld a, $50
	ld [$db70], a
	ld a, $27
	ld [$db71], a

jr_001_51a0:
	ld a, [$db62]
	and a
	jr z, jr_001_51dd

	ld [$db9d], a
	ld a, [$db63]
	ld [$db9e], a
	ld a, [$db61]
	ldh [$fff6], a
	ld [$db9c], a
	ld a, [$db60]
	ldh [$fff7], a
	ld a, [$db64]
	ld [$dbae], a
	xor a
	ldh [$fff9], a
	ld a, [$db5f]
	and $01
	ld [$dba5], a
	jr z, jr_001_51d7

	ld a, $04
	ldh [$ff9d], a
	ld a, $02
	ldh [$ff9e], a

jr_001_51d7:
	ld a, $02
	ld [$d6ff], a
	ret


jr_001_51dd:
	ld a, $30
	ld [$db78], a
	ld a, $30
	ld [$db77], a
	ld a, $20
	ld [$db76], a
	ld a, $a3
	ld [$db9c], a
	ldh [$fff6], a
	ld a, $01
	ld [$dba5], a
	ld a, $10
	ldh [$fff7], a
	ld a, $50
	ld [$db9d], a
	ld a, $60
	ld [$db9e], a
	xor a
	ldh [$ff9d], a
	ld a, $03
	ldh [$ff9e], a
	ld a, $16
	ld [$db6f], a
	ld a, $50
	ld [$db70], a
	ld a, $27
	ld [$db71], a
	jr jr_001_51d7

	db $9d, $9d, $9d, $ff, $9d, $9d, $9d, $ff, $9d, $9d, $9c, $ff, $9d, $9d, $9c, $ff
	db $32, $32, $09, $ff, $2e, $2e, $09, $ff, $8a, $32, $e9, $ff, $8a, $2e, $e9, $ff
	db $c8, $c8, $00, $ff, $c8, $c8, $00, $ff, $48, $c8, $00, $ff, $48, $c8, $00, $ff
	db $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff
	db $00, $00, $00, $ff, $00, $00, $00, $ff, $9d, $9d, $ff, $00, $9d, $9d, $9d, $ff
	db $9d, $9c, $ff, $00, $9d, $9c, $9c, $ff, $9d, $9d, $9c, $9c, $ff, $00, $00, $00
	db $00, $00, $00, $9d, $9d, $9c, $9c, $9c, $9c, $ff, $00, $00, $00, $00, $9d, $9d
	db $9c, $9c, $9d, $9d, $9c, $9c, $ff, $00, $00, $9d, $9d, $9c, $9c, $9d, $9d, $9c
	db $9c, $9c, $9c, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $0d, $12, $ff, $00
	db $0d, $11, $12, $ff, $92, $f2, $ff, $00, $92, $f1, $f2, $ff, $8d, $92, $ed, $f2
	db $ff, $00, $00, $00, $00, $00, $00, $8d, $92, $ed, $f2, $f1, $f2, $ff, $00, $00
	db $00, $00, $8d, $92, $ed, $f2, $91, $92, $f1, $f2, $ff, $00, $00, $8d, $92, $ed
	db $f2, $91, $92, $ec, $ed, $f1, $f2, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff
	db $e8, $e9, $ff, $00, $e8, $ec, $e8, $ff, $e8, $e9, $ff, $00, $e8, $ec, $e8, $ff
	db $e8, $ea, $e9, $eb, $ff, $00, $00, $00, $00, $00, $00, $e8, $ea, $e9, $eb, $ec
	db $e8, $ff, $00, $00, $00, $00, $e8, $ea, $e9, $eb, $ec, $e8, $ec, $e9, $ff, $00
	db $00, $e8, $ea, $e9, $eb, $ec, $e8, $ec, $ea, $ec, $e9, $ff, $9d, $9c, $0a, $ea
	db $9c, $e9, $49, $7f, $9d, $09, $49, $7f, $9d, $29, $49, $7f, $9d, $49, $49, $7f
	db $9d, $69, $49, $7f, $9d, $89, $49, $7f, $9d, $a9, $49, $7f, $9d, $c9, $49, $7f
	db $9d, $e9, $49, $7f, $9e, $09, $49, $7f, $00

Call_01_5357::
	ld hl, $532e
	ld de, $d650
	ld c, $29

jr_001_535f:
	ld a, [hli]
	inc de
	ld [de], a
	dec c
	jr nz, jr_001_535f

	push de
	xor a
	ldh [$ffd7], a
	ldh [$ffd8], a
	ldh [$ffd9], a
	ldh [$ffda], a
	ld c, a
	ld b, a
	ld e, a
	ld d, a
	ld a, [$dbb0]
	swap a
	and $03
	ld e, a
	and a
	jr z, jr_001_5389

jr_001_537e:
	ld a, c
	add $04
	ld c, a
	dec e
	ld a, e
	and a
	jr nz, jr_001_537e

	ld b, $00

jr_001_5389:
	pop hl

jr_001_538a:
	push hl
	ld hl, $521e
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $522e
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	ld hl, $523e
	add hl, bc
	ld a, [hl]
	ldh [$ffd9], a
	ld hl, $524e
	add hl, bc
	ld a, [hl]
	ldh [$ffda], a
	pop hl
	call Call_01_5461
	push hl
	ld hl, $521e
	inc bc
	add hl, bc
	ld a, [hl]
	pop hl
	inc hl
	cp $ff
	jr nz, jr_001_538a

	xor a
	ld [hl], a
	xor a
	ldh [$ffd7], a
	ldh [$ffd8], a
	ldh [$ffd9], a
	ldh [$ffda], a
	ld c, a
	ld b, a
	ld e, a
	ld d, a
	ld a, [$dbb0]
	swap a
	and $03
	ld e, a
	and a
	jr z, jr_001_5430

jr_001_53d2:
	ld b, $00
	ld a, c
	add $08
	ld c, a
	dec e
	ld a, e
	and a
	jr nz, jr_001_53d2

	ld a, [$dbb0]
	and $03
	jr z, jr_001_5406

	ld a, [$dbb0]
	and $30
	cp $30
	jr z, jr_001_53f5

	ld a, c
	add $04
	ld c, a
	ld b, $00
	jr jr_001_5406

jr_001_53f5:
	ld a, [$dbb0]
	and $03
	ld e, a

jr_001_53fb:
	ld b, $00
	ld a, c
	add $0b
	ld c, a
	dec e
	ld a, e
	and a
	jr nz, jr_001_53fb

jr_001_5406:
	push hl
	ld hl, $525e
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $52a2
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	xor a
	ldh [$ffd9], a
	ld hl, $52e6
	add hl, bc
	ld a, [hl]
	ldh [$ffda], a
	pop hl
	call Call_01_5461
	push hl
	ld hl, $525e
	inc bc
	add hl, bc
	ld a, [hl]
	pop hl
	inc hl
	cp $ff
	jr nz, jr_001_5406

jr_001_5430:
	xor a
	ld b, a
	ld c, a
	ld a, [$dbb0]
	bit 5, a
	jr z, jr_001_543b

	inc bc

jr_001_543b:
	push hl
	ld hl, $532a
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $532c
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	ld a, $01
	ldh [$ffd9], a
	ldh a, [$fff7]
	add $b1
	ldh [$ffda], a
	pop hl
	call Call_01_5461
	push hl
	pop hl
	inc hl
	ld a, $7f
	ld [hli], a
	xor a
	ld [hl], a
	ret


Call_01_5461::
	ldh a, [$ffd7]
	ld [hli], a
	ldh a, [$ffd8]
	ld [hli], a
	ldh a, [$ffd9]
	ld [hli], a
	ldh a, [$ffda]
	ld [hl], a
	ret


	xor a
	ld [$c3c0], a
	ld a, [$db96]
	rst $00

JumpTable_01_5476::
	dw Jump_01_5482
	dw Jump_01_54FE
	dw Jump_01_5507
	dw Jump_01_5510
	dw Jump_01_5521
	dw Jump_01_55FD

Jump_01_5482::
	call Call_1CCC
	call Call_0B22
	call Call_1776
	ld a, [$c16b]
	cp $04
	jr nz, jr_001_54fd

	ld a, $03
	ldh [$ffa9], a
	ld a, $30
	ldh [$ffaa], a
	call Call_01_4445
	xor a
	ld [$c16b], a
	ld [$c16c], a
	ldh [$ff96], a
	ld [$c1bf], a
	ldh [$ff97], a
	ld [$c14f], a
	ld [$c1b2], a
	ld [$c1b3], a
	ld a, [$db54]
	ld [$dbb4], a
	ld e, a
	ld d, $00
	ld hl, $5707
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_54e3

	swap a
	and $07
	inc a
	cp $01
	jr nz, jr_001_54e3

	ld a, [$c5a2]
	and a
	ld a, $00
	jr nz, jr_001_54e3

	ld hl, $d800
	add hl, de
	ld a, [hl]
	and $20
	ld a, $00
	jr z, jr_001_54e3

	ld a, $01

jr_001_54e3:
	ld [$c1b1], a
	ld a, [$dbb4]
	ld [$c1b4], a
	ldh a, [rLCDC]
	and $df
	ld [$d6fd], a
	ldh [rLCDC], a
	call Call_01_5636
	ld a, $08
	ld [$d6ff], a

jr_001_54fd:
	ret


Jump_01_54FE::
	ld a, $0b
	ld [$d6fe], a
	call Call_01_4445
	ret


Jump_01_5507::
	ld a, $0e
	ld [$d6fe], a
	call Call_01_4445
	ret


Jump_01_5510::
	call Call_17C3
	ld a, [$c16b]
	cp $04
	jr nz, jr_001_5520

	call Call_01_4445
	call Call_01_4907

jr_001_5520:
	ret


Jump_01_5521::
	ld a, [$c19f]
	and a
	jp nz, Jump_001_55f0

	ldh a, [$ffcc]
	and $10
	jr z, jr_001_5594

	ld a, [$dbb4]
	ld e, a
	ld d, $00
	ld hl, $5707
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_555f

	ld e, a
	and $f0
	jr nz, jr_001_5556

	ld a, [$c5a2]
	and a
	jr nz, jr_001_555f

	push de
	ld a, [$dbb4]
	ld e, a
	ld hl, $d800
	add hl, de
	pop de
	ld a, [hl]
	and $20
	jr z, jr_001_555f

jr_001_5556:
	ld d, $00
	ld hl, $56b7
	add hl, de
	ld a, [hl]
	jr jr_001_5582

jr_001_555f:
	ld a, [$dbb4]
	cp $24
	jr z, jr_001_556a

	cp $34
	jr nz, jr_001_556e

jr_001_556a:
	ld a, $76
	jr jr_001_5582

jr_001_556e:
	rra
	and $07
	ld e, a
	ld a, [$dbb4]
	rra
	rra
	and $38
	or e
	ld e, a
	ld d, $00
	ld hl, $5677
	add hl, de
	ld a, [hl]

jr_001_5582:
	call Call_2197
	ld a, [$dbb4]
	cp $70
	ld a, $01
	jr nc, jr_001_5590

	ld a, $81

jr_001_5590:
	ld [$c19f], a
	ret


jr_001_5594:
	ld a, [$0003]
	and a
	jr z, jr_001_55d7

	ldh a, [$ffcb]
	cp $60
	jr nz, jr_001_55d7

	ld a, $0b
	ld [$db95], a
	call Call_0909
	ld a, $00
	ld [$d401], a
	ld [$d402], a
	ld a, [$dbb4]
	ld [$d403], a
	ld a, $48
	ld [$d404], a
	ld a, $52
	ld [$d405], a
	ldh a, [$ff98]
	swap a
	and $0f
	ld e, a
	ldh a, [$ff99]
	sub $08
	and $f0
	or e
	ld [$d416], a
	ld a, $07
	ld [$db96], a
	ret


jr_001_55d7:
	ld e, $40
	ld a, [$0003]
	and a
	jr nz, jr_001_55e1

	ld e, $60

jr_001_55e1:
	ldh a, [$ffcc]
	and e
	jr z, jr_001_55f0

	xor a
	ld [$c16b], a
	ld [$c16c], a
	call Call_01_4445

Jump_001_55f0:
jr_001_55f0:
	call Call_01_5656
	call Call_01_581F
	call Call_01_59F7
	ret


	db $cd, $50, $67

Jump_01_55FD::
	call Call_1776
	ld a, [$c16b]
	cp $04
	jr nz, jr_001_5655

	xor a
	ld [$c50a], a
	ld [$c116], a
	ldh [$ff96], a
	ldh [$ff97], a
	ld [$c167], a
	ld a, $07
	ldh [$ffa9], a
	ld a, $70
	ldh [$ffaa], a
	ld a, $0b
	ld [$db95], a
	ldh [$ffbc], a
	ld a, $02
	ld [$db96], a
	ld a, [$dba5]
	and a
	ld a, $06
	jr nz, jr_001_5633

	ld a, $07

jr_001_5633:
	ld [$d6fe], a

Call_01_5636::
	ld hl, $c124
	ld e, $00

jr_001_563b:
	xor a
	ld [hli], a
	inc e
	ld a, e
	cp $0c
	jr nz, jr_001_563b

Call_01_5643::
	ld a, $80
	ld [$db9a], a
	ld a, $06
	ldh [rWX], a
	ld a, $08
	ld [$c150], a
	xor a
	ld [$c14f], a

jr_001_5655:
	ret


Call_01_5656::
	ld hl, $c09c
	ld a, [$db54]
	rra
	and $78
	add $18
	ld [hli], a
	ld a, [$db54]
	swap a
	rra
	and $78
	add $18
	ld [hli], a
	ld [hl], $3e
	inc hl
	ldh a, [$ffe7]
	rla
	and $10
	ld [hl], a
	ret


	db $6c, $6c, $6c, $6b, $6c, $6c, $6c, $6c, $76, $76, $79, $79, $79, $79, $79, $79
	db $6a, $6a, $72, $7a, $78, $78, $71, $71, $6a, $6a, $72, $70, $78, $78, $71, $71
	db $6a, $6e, $69, $69, $69, $69, $77, $71, $6e, $6e, $69, $69, $69, $69, $77, $77
	db $7b, $7b, $6d, $62, $74, $74, $6f, $68, $73, $73, $73, $74, $74, $74, $75, $68
	db $00, $d9, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd
	db $00, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $00, $00, $00, $00, $00, $00, $00
	db $00, $7c, $67, $00, $00, $80, $65, $00, $64, $88, $00, $00, $00, $00, $00, $00
	db $00, $5e, $5f, $7f, $7e, $7d, $82, $84, $85, $86, $87, $81, $66, $83, $5e, $63
	db $00, $61, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $3e, $00, $0e, $00, $39, $00, $00, $00, $17, $00
	db $18, $3d, $00, $00, $00, $00, $06, $0c, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $12, $00, $00, $00, $07, $00

Call_01_5731::
	db $00, $14, $00, $00, $00, $00, $33, $3d, $00, $00, $00, $00, $05, $00, $00, $00
	db $00, $00, $00, $00, $00, $29, $00, $03, $00, $00, $00, $25, $00, $00, $00, $00
	db $00, $3d, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0d, $22, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $02, $21, $3b, $36, $00, $00, $00, $00, $3d, $00
	db $37, $00, $16, $00, $00, $00, $00, $00, $00, $26, $00, $00, $00, $00, $00, $00
	db $00, $09, $0b, $09, $00, $00, $00, $35, $3c, $00, $3d, $00, $00, $00, $00, $00
	db $00, $00, $0a, $00, $00, $00, $3a, $34, $3d, $28, $00, $13, $07, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $04, $11, $00, $00, $38, $00, $00, $15
	db $00, $3d, $00, $00, $00, $00, $00, $00, $00, $41, $00, $00, $00, $00, $3d, $00
	db $00, $00, $00, $00, $08, $00, $00, $00, $01, $00, $00, $00, $3f, $00, $00, $00
	db $00, $00, $00, $00, $00, $00

Call_01_5807::
	ldh a, [$fff6]
	ld e, a
	ld d, $00
	ld hl, $5707
	add hl, de
	ld e, [hl]
	ld hl, $56b7
	add hl, de
	ld a, [hl]
	jp Call_2197


	db $00, $01, $ff, $00, $f0, $10

Call_01_581F::
	ld a, [$dbb4]
	ldh [$ffd7], a
	ld a, [$c1b3]
	ld hl, $c1b2
	or [hl]
	ld hl, $c19f
	or [hl]
	jp nz, Jump_001_58ed

	ldh a, [$ffcb]
	ld c, a
	ld hl, $c182
	and $0f
	jr nz, jr_001_5840

	xor a
	ld [hl], a
	jr jr_001_584b

jr_001_5840:
	ld a, [hl]
	inc a
	ld [hl], a
	cp $18
	jr nz, jr_001_584b

	ld [hl], $15
	jr jr_001_584e

jr_001_584b:
	ldh a, [$ffcc]
	ld c, a

jr_001_584e:
	ld a, c
	and $03
	ld e, a
	ld d, $00
	ld hl, $5819
	add hl, de
	ld a, [$dbb4]
	ld d, a
	and $f0
	ld e, a
	ld a, d
	add [hl]
	and $0f
	or e
	ld [$dbb4], a
	ld a, c
	rra
	rra
	and $03
	ld e, a
	ld d, $00
	ld hl, $581c
	add hl, de
	ld a, [$dbb4]
	add [hl]
	ld hl, $ffd7
	ld [$dbb4], a
	cp [hl]
	jr z, jr_001_58ed

	ld e, a
	ld d, $00
	ld hl, $d800
	add hl, de
	ld a, [$c5a2]
	and a
	jr nz, jr_001_58a3

	ld a, [hl]
	and $ff
	jr nz, jr_001_58a3

	ld a, [$c17b]
	and a
	jr nz, jr_001_58a3

	ld a, $09
	ldh [$fff2], a
	ldh a, [$ffd7]
	ld [$dbb4], a
	jr jr_001_58ed

jr_001_58a3:
	call Call_01_6E33
	ld hl, $5707
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_58de

	swap a
	and $07
	inc a
	ld c, a
	cp $01
	jr nz, jr_001_58c7

	ld a, [$c5a2]
	and a
	jr nz, jr_001_58de

	ld hl, $d800
	add hl, de
	ld a, [hl]
	and $20
	jr z, jr_001_58de

jr_001_58c7:
	ld a, [$c1b1]
	and a
	jr nz, jr_001_58d2

	ld a, $10
	ld [$c1b2], a

jr_001_58d2:
	ld a, c
	ld [$c1b1], a
	ld a, [$dbb4]
	ld [$c1b4], a
	jr jr_001_58ed

jr_001_58de:
	ld a, [$c1b1]
	and a
	jr z, jr_001_58ed

	xor a
	ld [$c1b1], a
	ld a, $10
	ld [$c1b3], a

Jump_001_58ed:
jr_001_58ed:
	ld hl, $c080
	ld a, [$dbb4]
	rra
	and $78
	add $14
	ld e, a
	ld a, [$dbb4]
	swap a
	rra
	and $78
	add $14
	ld d, a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], $f0
	inc hl
	ld [hl], $00
	inc hl
	ld a, e
	ld [hli], a
	ld a, d
	add $08
	ld [hli], a
	ld [hl], $f0
	inc hl
	ld [hl], $20
	ldh a, [$ffe7]
	and $10
	jr nz, jr_001_595a

	ld hl, $c088
	ld a, e
	add $04
	ld [hli], a
	ld a, d
	add $f6
	ld [hli], a
	ld a, $f6
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, e
	add $04
	ld [hli], a
	ld a, d
	add $13
	ld [hli], a
	ld a, $f6
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, e
	add $f6
	ld [hli], a
	ld a, d
	add $04
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, e
	add $0b
	ld [hli], a
	ld a, d
	add $04
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $40
	ld [hli], a

jr_001_595a:
	ret


	db $f8, $f8, $f2, $00, $f8, $00, $f4, $00, $f8, $08, $f4, $20, $f8, $10, $f2, $20
	db $08, $f8, $f2, $40, $08, $00, $f4, $40, $08, $08, $f4, $60, $08, $10, $f2, $60
	db $fa, $fa, $f2, $00, $fa, $02, $f4, $00, $fa, $06, $f4, $20, $fa, $0e, $f2, $20
	db $06, $fa, $f2, $40, $06, $02, $f4, $40, $06, $06, $f4, $60, $06, $0e, $f2, $60
	db $fc, $fc, $f2, $00, $fc, $04, $f4, $00, $fc, $04, $f4, $20, $fc, $0c, $f2, $20
	db $04, $fc, $f2, $40, $04, $04, $f4, $40, $04, $04, $f4, $60, $04, $0c, $f2, $60
	db $fe, $fe, $f2, $00, $fe, $04, $f4, $00, $fe, $04, $f4, $20, $fe, $0a, $f2, $20
	db $02, $fe, $f2, $40, $02, $04, $f4, $40, $02, $04, $f4, $60, $02, $0a, $f2, $60
	db $20, $00, $22, $00, $24, $00, $26, $00, $28, $00, $2a, $00, $2c, $00, $2e, $00
	db $2c, $00, $2e, $00, $28, $78, $28, $78, $28, $28, $78, $78

Call_01_59F7::
	ld a, [$c340]
	push af
	call Call_01_5A03
	pop af
	ld [$c340], a
	ret


Call_01_5A03::
	ld a, [$c1b3]
	and a
	jr z, jr_001_5a10

	dec a
	ld [$c1b3], a
	cpl
	jr jr_001_5a1a

jr_001_5a10:
	ld a, [$c1b2]
	and a
	jr z, jr_001_5a20

	dec a
	ld [$c1b2], a

jr_001_5a1a:
	rra
	rra
	and $03
	jr jr_001_5a29

jr_001_5a20:
	ld a, [$c1b1]
	and a
	jp z, Jump_001_5ac1

	ld a, $00

jr_001_5a29:
	ld [$c1b0], a
	ldh [$fff1], a
	ld a, $00
	ld [$c3c0], a
	ld a, $08
	ld [$c340], a
	ld a, $00
	ld [$c123], a
	ldh [$ffed], a
	ld e, $00
	ld a, [$c1b4]
	cp $70
	jr c, jr_001_5a4a

	ld e, $02

jr_001_5a4a:
	and $0f
	cp $08
	jr nc, jr_001_5a51

	inc e

jr_001_5a51:
	ld d, $00
	ld hl, $59ef
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $59f3
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, [$c1b0]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, $00
	ld hl, $595b
	add hl, de
	ld a, $08
	ld [$c3c0], a
	xor a
	ldh [$fff5], a
	ld c, $08
	call Call_3D26
	ld a, [$c1b0]
	cp $00
	jr nz, jr_001_5ac1

	ld a, [$c1b1]
	dec a
	cp $80
	jr nc, jr_001_5ac1

	ldh [$fff1], a
	ld de, $c030
	ldh a, [$ffec]
	ld [de], a
	inc de
	ldh a, [$ffee]
	ld [de], a
	inc de
	ldh a, [$fff1]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	ld hl, $59db
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ldh a, [$ffec]
	ld [de], a
	inc de
	ldh a, [$ffee]
	add $08
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

Jump_001_5ac1:
jr_001_5ac1:
	ret


	db $98, $cb, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $98, $eb, $06, $7e, $7e, $7e
	db $7e, $7e, $7e, $7e, $00, $99, $2b, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $99
	db $4b, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $00, $99, $8b, $06, $7e, $7e, $7e
	db $7e, $7e, $7e, $7e, $99, $ab, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $00

Jump_001_5b01:
	ld a, [$d600]
	ld e, a
	ld d, $00
	add $14
	ld [$d600], a
	ld hl, $d601
	add hl, de
	push de
	ld bc, $5ac2
	ldh a, [$ffdb]
	and a
	jr z, jr_001_5b23

	ld bc, $5ad7
	cp $01
	jr z, jr_001_5b23

	ld bc, $5aec

jr_001_5b23:
	ld e, $15

jr_001_5b25:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, jr_001_5b25

	pop de
	ld hl, $d604
	add hl, de
	ld c, $00
	ldh a, [$ffd9]
	and a
	jr z, jr_001_5b59

	ldh [$ffd7], a

jr_001_5b39:
	ldh a, [$ffd7]
	sub $08
	ldh [$ffd7], a
	jr c, jr_001_5b50

	ld a, $ae
	ld [hli], a
	inc c
	ld a, c
	cp $07
	jr nz, jr_001_5b4e

	ld a, l
	add $03
	ld l, a

jr_001_5b4e:
	jr jr_001_5b39

jr_001_5b50:
	add $08
	jr z, jr_001_5b59

	ld a, $ae
	ld [hli], a
	jr jr_001_5b61

jr_001_5b59:
	ldh a, [$ffda]
	cp c
	jr z, jr_001_5b6d

	ld a, $ae
	ld [hli], a

jr_001_5b61:
	inc c
	ld a, c
	cp $07
	jr nz, jr_001_5b6b

	ld a, l
	add $03
	ld l, a

jr_001_5b6b:
	jr jr_001_5b59

jr_001_5b6d:
	ret


Call_01_5B6E::
	xor a
	ld de, $dba7
	ld [de], a
	ld b, $01
	ld c, $00
	ld hl, $db80

jr_001_5b7a:
	ld a, [hli]
	and a
	jr z, jr_001_5b81

	ld a, [de]
	or b
	ld [de], a

jr_001_5b81:
	inc c
	ld a, c
	cp $05
	jr nz, jr_001_5b89

	ld b, $02

jr_001_5b89:
	cp $0a
	jr nz, jr_001_5b8f

	ld b, $04

jr_001_5b8f:
	cp $0f
	jr nz, jr_001_5b7a

	ret


	db $fa, $5a, $db, $a7, $20, $0e, $fa, $5b, $db, $5f, $16, $00, $21, $1b, $51, $19
	db $7e, $ea, $5a, $db, $cd, $e2, $27, $fa, $a6, $db, $cb, $27, $5f, $16, $00, $21
	db $3c, $49, $19, $2a, $66, $6f, $01, $00, $d8, $11, $80, $03, $cd, $b5, $27, $0a
	db $03, $cd, $b5, $27, $22, $1b, $7b, $b2, $20, $f2, $c9

Call_01_5BCF::
	push bc
	ld a, [$dba5]
	and a
	jr z, jr_001_5bf4

	ldh a, [$fff7]
	cp $0a
	jr nc, jr_001_5bf4

	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $db16
	add hl, de
	ld de, $dbcc
	ld c, $05

jr_001_5bee:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_001_5bee

jr_001_5bf4:
	pop bc
	ret


	db $a0, $60, $00, $00, $00, $00, $ff, $00, $00, $00, $00, $00, $80, $80, $00, $00
	db $00, $ff, $00, $00

Call_01_5C0A::
	ld hl, $c460
	add hl, de
	ldh a, [$ffe4]
	ld [hl], a
	inc a
	ldh [$ffe4], a
	push bc
	ld a, [$c125]
	ld c, a
	ld b, $00
	ld hl, $5bf6
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $5bfb
	add hl, bc
	ld a, [hl]
	ldh [$ffd8], a
	ld hl, $5c00
	add hl, bc
	ld a, [hl]
	ldh [$ffd9], a
	ld hl, $5c05
	add hl, bc
	ld a, [hl]
	ldh [$ffda], a
	ld hl, $c200
	add hl, de
	ldh a, [$ffd7]
	add [hl]
	ld [hl], a
	rr c
	ld hl, $c220
	add hl, de
	ldh a, [$ffd8]
	rl c
	adc [hl]
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffd9]
	add [hl]
	ld [hl], a
	rr c
	ld hl, $c230
	add hl, de
	ldh a, [$ffda]
	rl c
	adc [hl]
	ld [hl], a
	pop bc
	ret


Call_01_5C61::
	ld c, $06
	ldh a, [$fff6]
	ld hl, $ce81

jr_001_5c68:
	cp [hl]
	jr z, jr_001_5c8c

	inc hl
	dec c
	jr nz, jr_001_5c68

	ld a, [$ce80]
	inc a
	cp $06
	jr nz, jr_001_5c78

	xor a

jr_001_5c78:
	ld [$ce80], a
	ld e, a
	ld d, $00
	ld hl, $ce81
	add hl, de
	ld e, [hl]
	ldh a, [$fff6]
	ld [hl], a
	ld hl, $cf00
	add hl, de
	ld [hl], $00

jr_001_5c8c:
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff

Call_01_5CF0::
	ld hl, $0000
	ld [hl], $ff
	ld b, $28
	xor a
	ld hl, $c000

jr_001_5cfb:
	ld [hli], a
	inc hl
	inc hl
	inc hl
	dec b
	jr nz, jr_001_5cfb

	ret


Call_01_5D03::
	ld a, [$c14f]
	and a
	jr z, jr_001_5d22

	ld hl, $c000
	ld a, [$db9a]
	add $08
	ld d, a
	ld e, $28

jr_001_5d14:
	ld a, [hl]
	cp d
	jr c, jr_001_5d1a

	ld [hl], $00

jr_001_5d1a:
	inc hl
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, jr_001_5d14

	ret


jr_001_5d22:
	ld a, [$db9a]
	and a
	ret z

	ld a, [$c19f]
	and a
	ret z

	ld d, $3e
	ld a, [$c19f]
	and $80
	jr z, jr_001_5d37

	ld d, $58

jr_001_5d37:
	ld e, $1f
	ld hl, $c024

jr_001_5d3c:
	ld a, [hl]
	cp d
	ld a, [$c19f]
	bit 7, a
	jr nz, jr_001_5d46

	ccf

jr_001_5d46:
	jr c, jr_001_5d63

	ld a, [$c173]
	cp $4f
	jr nz, jr_001_5d61

	ld a, [$c112]
	and a
	jr nz, jr_001_5d61

	inc hl
	inc hl
	ld a, [hld]
	dec hl
	cp $9a
	jr c, jr_001_5d61

	cp $a0
	jr c, jr_001_5d63

jr_001_5d61:
	ld [hl], $00

jr_001_5d63:
	inc hl
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, jr_001_5d3c

	ret


Call_01_5D6B::
	ld a, [$dba5]
	and a
	jr z, jr_001_5d8b

	ldh a, [$fff9]
	and a
	ret nz

	ldh a, [$fff7]
	cp $16
	ret z

	cp $14
	ret z

	cp $13
	ret z

	cp $0a
	ret c

	ldh a, [$fff6]
	cp $fd
	ret z

	cp $b1
	ret z

jr_001_5d8b:
	ld a, [$db7b]
	cp $01
	jr nz, jr_001_5dcc

	ld e, $0f
	ld d, $00

jr_001_5d96:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $d5
	jr nz, jr_001_5da8

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_5da8

	ld [hl], d

jr_001_5da8:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_5d96

	ld a, $d5
	call Call_3C01
	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c13b
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a

jr_001_5dcc:
	ld a, [$db79]
	cp $01
	jr z, jr_001_5dfb

	cp $02

Call_01_5DD5::
	jr nz, jr_001_5e37

	ld a, [$dba5]
	and a
	jr nz, jr_001_5e37

	ldh a, [$fff6]
	cp $40
	jr c, jr_001_5e37

	ld a, [$db68]
	and $02
	jr z, jr_001_5e37

	ld a, [$db43]
	cp $02
	jr c, jr_001_5df4

	xor a
	jr jr_001_5df6

jr_001_5df4:
	ld a, $01

jr_001_5df6:
	ld [$db79], a
	jr jr_001_5e37

jr_001_5dfb:
	ld e, $0f
	ld d, $00

jr_001_5dff:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $d4
	jr nz, jr_001_5e11

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_5e11

	ld [hl], d

jr_001_5e11:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_5dff

	ld a, $d4
	call Call_3C01
	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c13b
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld a, $2d
	ldh [$fff2], a

jr_001_5e37:
	ld a, [$db73]
	and a
	jp z, Jump_001_5ed7

	ld e, $0f
	ld d, $00

jr_001_5e42:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $c1
	jr nz, jr_001_5e54

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_5e54

	ld [hl], d

jr_001_5e54:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_5e42

	ld a, $c1
	call Call_3C01
	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $d155
	call Call_01_5ED0
	ldh a, [$ff99]
	ld hl, $c13b
	add [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $d175
	call Call_01_5ED0
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $d195
	call Call_01_5ED0
	ld hl, $c440
	add hl, de
	ld [hl], $01
	ld hl, $c2f0
	add hl, de
	ld [hl], $0c
	ldh a, [$fff6]
	cp $a4
	jr nz, jr_001_5eaf

	ldh a, [$fff7]
	cp $11
	jr nz, jr_001_5eaf

	ld a, $08
	ldh [$fff2], a
	ld [$c167], a
	ld hl, $c300
	add hl, de
	ld [hl], $79

jr_001_5eaf:
	ldh a, [$ff9e]
	ld hl, $d1b5
	call Call_01_5ED0
	ld a, [$db10]
	and a
	jr z, jr_001_5ecf

	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	add $20
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, de
	add $10
	ld [hl], a

jr_001_5ecf:
	ret


Call_01_5ED0::
	ld c, $10

jr_001_5ed2:
	ld [hli], a
	dec c
	jr nz, jr_001_5ed2

	ret


Jump_001_5ed7:
	ldh a, [$fff6]
	cp $a7
	ret z

	ld a, [$db56]
	cp $01
	jr nz, jr_001_5f19

	ld e, $0f
	ld d, $00

jr_001_5ee7:
	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $6d
	jr nz, jr_001_5ef9

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_5ef9

	ld [hl], d

jr_001_5ef9:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_5ee7

	ld a, $6d
	call Call_3C01
	ldh a, [$ff98]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffa2]
	ld hl, $c310
	add hl, de
	ld [hl], a

jr_001_5f19:
	ret


Jump_001_5f1a:
	call Call_27D2
	xor a
	ld [$db95], a
	ld [$db96], a
	ld [$db98], a
	ld [$db99], a
	ld [$db97], a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a
	ldh [$ff97], a
	ldh [$ff96], a
	ld [$d6fb], a
	ld [$d6f8], a
	ld a, $18
	ldh [$ffb5], a
	ret


	db $00, $57, $10, $57, $20, $57, $30, $57, $40, $57, $50, $57, $60, $57, $70, $57
	db $80, $57, $90, $57, $00, $58, $10, $58, $20, $58, $30, $58, $40, $58, $50, $58

Call_01_5F62::
	ld a, [$c109]
	and $0f
	sla a
	ld e, a
	ld d, $00
	ld hl, $5f42
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $96d0
	ld bc, $0010
	ld a, $0f
	call Call_28B9
	ld a, [$c109]
	swap a
	and $0f
	sla a
	ld e, a
	ld d, $00
	ld hl, $5f42
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $96c0
	ld bc, $0010
	ld a, $0f
	call Call_28B9
	ld a, $6c
	ld [$9909], a
	inc a
	ld [$990a], a
	ret


Call_01_5FA6::
	ld a, [$c11c]
	cp $00
	jr nz, jr_001_5fba

	ld a, [$c17b]
	and a
	jr nz, jr_001_5fba

	ldh a, [$fff7]
	add $56
	call Call_2197

jr_001_5fba:
	ret


	db $fa, $9f, $c1, $a7, $20, $0a, $fa, $c7, $c3, $a7, $28, $04, $3d, $ea, $c7, $c3
	db $fa, $c4, $c3, $a7, $28, $04, $3d, $ea, $c4, $c3, $fa, $96, $db, $c7, $f5, $5f
	db $17, $60, $23, $60, $5a, $61, $8d, $61, $a8, $61, $c6, $61, $dd, $61, $ef, $61
	db $06, $62, $18, $62, $46, $62, $5d, $62, $fd, $55, $3e, $01, $ea, $67, $c1, $cd
	db $76, $17, $fa, $6b, $c1, $fe, $04, $20, $12, $cd, $45, $44, $af, $ea, $bf, $c1
	db $cd, $36, $56, $cd, $75, $62, $3e, $0f, $ea, $fe, $d6, $c9, $3e, $13, $ea, $fe
	db $d6, $af, $ea, $3f, $c1, $c3, $45, $44, $3e, $13, $ea, $ff, $d6, $3e, $ff, $ea
	db $9a, $db, $af, $e0, $96, $ea, $6b, $c1, $ea, $6c, $c1, $3e, $90, $e0, $97, $3e
	db $40, $ea, $14, $c1, $3e, $a0, $ea, $66, $d4, $3e, $e0, $ea, $40, $c5, $3e, $00
	db $ea, $30, $c5, $3e, $01, $ea, $10, $c5, $3e, $0c, $ea, $60, $c5, $3e, $08, $ea
	db $50, $c5, $3e, $00, $ea, $20, $c5, $ea, $00, $d2, $3e, $20, $ea, $41, $c5, $3e
	db $a0, $ea, $31, $c5, $3e, $01, $ea, $11, $c5, $3e, $08, $ea, $61, $c5, $3e, $f8
	db $ea, $51, $c5, $3e, $40, $ea, $21, $c5, $3e, $24, $ea, $01, $d2, $3e, $48, $ea
	db $42, $c5, $3e, $30, $ea, $32, $c5, $3e, $02, $ea, $12, $c5, $3e, $00, $ea, $62
	db $c5, $3e, $00, $ea, $52, $c5, $3e, $00, $ea, $22, $c5, $3e, $02, $ea, $02, $d2
	db $3e, $3c, $ea, $43, $c5, $3e, $40, $ea, $33, $c5, $3e, $02, $ea, $13, $c5, $3e
	db $00, $ea, $63, $c5, $3e, $00, $ea, $53, $c5, $3e, $00, $ea, $23, $c5, $3e, $00
	db $ea, $03, $d2, $3e, $40, $ea, $44, $c5, $3e, $50, $ea, $34, $c5, $3e, $02, $ea
	db $14, $c5, $3e, $00, $ea, $64, $c5, $3e, $00, $ea, $54, $c5, $3e, $00, $ea, $24
	db $c5, $3e, $00, $ea, $04, $d2, $3e, $3c, $ea, $45, $c5, $3e, $60, $ea, $35, $c5
	db $3e, $02, $ea, $15, $c5, $3e, $00, $ea, $65, $c5, $3e, $00, $ea, $55, $c5, $3e
	db $00, $ea, $25, $c5, $3e, $00, $ea, $05, $d2, $3e, $44, $ea, $46, $c5, $3e, $68
	db $ea, $36, $c5, $3e, $02, $ea, $16, $c5, $3e, $00, $ea, $66, $c5, $3e, $00, $ea
	db $56, $c5, $3e, $00, $ea, $26, $c5, $3e, $00, $ea, $06, $d2, $c3, $45, $44, $00
	db $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4, $00
	db $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c, $f0
	db $e7, $e6, $07, $20, $0e, $fa, $c5, $c3, $3c, $ea, $c5, $c3, $fe, $0c, $20, $03
	db $cd, $45, $44, $f0, $e7, $e6, $03, $5f, $fa, $c5, $c3, $83, $5f, $16, $00, $21
	db $3a, $61, $19, $7e, $ea, $97, $db, $ea, $99, $db, $21, $4a, $61, $19, $7e, $ea
	db $98, $db, $f0, $e7, $e6, $03, $20, $11, $f0, $97, $3c, $e0, $97, $fe, $00, $20
	db $08, $3e, $80, $ea, $c7, $c3, $cd, $45, $44, $cd, $8c, $62, $c9, $cd, $8c, $62
	db $fa, $9f, $c1, $a7, $20, $0f, $fa, $c7, $c3, $a7, $20, $08, $3e, $d8, $cd, $3c
	db $65, $cd, $45, $44, $c9, $3e, $02, $ea, $c4, $c3, $c9, $cd, $8c, $62, $fa, $9f
	db $c1, $a7, $20, $0d, $3e, $80, $ea, $c4, $c3, $3e, $c0, $ea, $c7, $c3, $cd, $45
	db $44, $c9, $cd, $8c, $62, $fa, $c7, $c3, $a7, $20, $08, $3e, $d9, $cd, $3c, $65
	db $c3, $45, $44, $c9, $cd, $8c, $62, $fa, $9f, $c1, $a7, $20, $0d, $3e, $80, $ea
	db $c4, $c3, $3e, $c0, $ea, $c7, $c3, $cd, $45, $44, $c9, $cd, $8c, $62, $fa, $c7
	db $c3, $a7, $20, $08, $3e, $da, $cd, $3c, $65, $c3, $45, $44, $c9, $cd, $8c, $62
	db $fa, $9f, $c1, $a7, $20, $1f, $fa, $77, $c1, $a7, $20, $09, $3e, $db, $cd, $3c
	db $65, $cd, $45, $44, $c9, $3e, $de, $cd, $3c, $65, $3e, $05, $ea, $96, $db, $3e
	db $05, $ea, $c7, $c3, $c9, $3e, $02, $ea, $c4, $c3, $c9, $cd, $8c, $62, $fa, $9f
	db $c1, $a7, $20, $0d, $3e, $dc, $cd, $3c, $65, $3e, $30, $ea, $c7, $c3, $cd, $45
	db $44, $c9, $cd, $8c, $62, $3e, $02, $ea, $c4, $c3, $fa, $c7, $c3, $a7, $c0, $cd
	db $d2, $27, $cd, $0f, $66, $3e, $01, $ea, $73, $db, $1e, $10, $21, $10, $c5, $af
	db $22, $1d, $20, $fc, $c9, $40, $00, $40, $20, $46, $00, $48, $00, $42, $00, $44
	db $00, $cd, $0c, $63, $fa, $14, $c1, $3c, $fe, $a0, $20, $05, $3e, $0f, $e0, $f4
	db $af, $ea, $14, $c1, $fa, $66, $d4, $a7, $20, $0e, $3e, $21, $e0, $f2, $cd, $ed
	db $27, $e6, $7f, $c6, $60, $ea, $66, $d4, $3d, $ea, $66, $d4, $f0, $97, $3d, $fe
	db $c0, $d8, $11, $80, $62, $fa, $c4, $c3, $a7, $28, $07, $fe, $60, $30, $03, $11
	db $84, $62, $3e, $7c, $e0, $ec, $3e, $58, $e0, $ee, $21, $30, $c0, $cd, $e9, $62
	db $3e, $48, $e0, $ee, $11, $88, $62, $21, $38, $c0, $cd, $e9, $62, $c9, $c5, $f0
	db $97, $4f, $f0, $ec, $91, $e0, $e8, $22, $f0, $ee, $22, $1a, $13, $22, $1a, $13
	db $22, $f0, $ec, $91, $22, $f0, $ee, $c6, $08, $22, $1a, $13, $22, $1a, $77, $c1
	db $c9, $0e, $08, $06, $00, $21, $10, $c5, $09, $7e, $a7, $28, $1c, $f5, $21, $30
	db $c5, $09, $7e, $e0, $ee, $21, $40, $c5, $09, $7e, $e0, $ec, $21, $20, $c5, $09
	db $7e, $a7, $28, $01, $35, $f1, $cd, $3b, $63, $0d, $79, $fe, $ff, $20, $d6, $c9
	db $3d, $c7, $d1, $63, $5b, $64, $4d, $63, $51, $63, $55, $63, $59, $63, $5d, $63
	db $61, $63, $50, $00, $50, $20, $52, $00, $52, $20, $54, $00, $54, $20, $56, $00
	db $56, $20, $58, $00, $58, $20, $5a, $00, $5a, $20, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $03, $03, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $04, $05, $00, $01, $02, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05
	db $00, $01, $02, $03, $04, $05, $21, $20, $c5, $09, $7e, $a7, $c0, $21, $10, $d2
	db $09, $7e, $3c, $77, $fe, $06, $38, $06, $70, $21, $00, $d2, $09, $34, $21, $00
	db $d2, $09, $5e, $50, $21, $65, $63, $19, $5e, $cb, $23, $50, $21, $41, $63, $19
	db $2a, $56, $5f, $d5, $21, $40, $c0, $79, $17, $17, $17, $e6, $78, $5f, $50, $19
	db $d1, $cd, $e9, $62, $cd, $06, $65, $f0, $e7, $e6, $07, $20, $0a, $21, $60, $c5
	db $09, $7e, $fe, $fb, $28, $01, $35, $f0, $e8, $fe, $f0, $38, $0d, $21, $60, $c5
	db $09, $7e, $e6, $80, $c8, $21, $10, $c5, $09, $70, $c9, $3e, $64, $42, $64, $46
	db $64, $4a, $64, $4c, $00, $4c, $20, $4e, $00, $4e, $20, $5c, $00, $5c, $20, $5e
	db $00, $5e, $20, $01, $ff, $01, $ff, $fe, $02, $01, $ff, $4c, $52, $58, $5c, $60
	db $21, $60, $c5, $09, $7e, $1e, $03, $e6, $80, $28, $10, $21, $00, $d2, $09, $f0
	db $e7, $e6, $07, $20, $05, $7e, $3c, $e6, $03, $77, $5e, $cb, $23, $50, $21, $36
	db $64, $19, $2a, $56, $5f, $d5, $21, $40, $c0, $79, $17, $17, $17, $e6, $78, $5f
	db $50, $19, $d1, $cd, $e9, $62, $cd, $06, $65, $79, $cb, $27, $cb, $27, $cb, $27
	db $cb, $27, $5f, $f0, $e7, $83, $e0, $e9, $e6, $3f, $20, $11, $cd, $ed, $27, $e6
	db $07, $5f, $50, $21, $4e, $64, $19, $7e, $21, $50, $c5, $09, $77, $f0, $e9, $c6
	db $40, $e6, $3f, $20, $11, $cd, $ed, $27, $e6, $07, $5f, $50, $21, $4e, $64, $19
	db $7e, $21, $60, $c5, $09, $77, $21, $90, $c5, $09, $7e, $3c, $77, $fe, $13, $38
	db $29, $70, $21, $54, $64, $09, $56, $21, $30, $c5, $09, $7e, $92, $1e, $01, $e6
	db $80, $20, $02, $1e, $ff, $7e, $83, $77, $21, $40, $c5, $09, $7e, $d6, $48, $1e
	db $01, $e6, $80, $20, $02, $1e, $ff, $7e, $83, $77, $c9, $cd, $13, $65, $c5, $79
	db $c6, $10, $4f, $cd, $13, $65, $c1, $c9, $21, $50, $c5, $09, $7e, $f5, $cb, $37
	db $e6, $f0, $21, $70, $c5, $09, $86, $77, $cb, $12, $21, $30, $c5, $09, $f1, $1e
	db $00, $cb, $7f, $28, $02, $1e, $f0, $cb, $37, $e6, $0f, $b3, $cb, $1a, $8e, $77
	db $c9, $5f, $f0, $99, $f5, $3e, $60, $e0, $99, $7b, $cd, $85, $21, $f1, $e0, $99
	db $c9, $fa, $96, $db, $c7, $64, $65, $91, $65, $ae, $65, $e0, $65, $f6, $65, $fd
	db $55, $1a, $66, $3e, $66, $7b, $66, $fa, $55, $3e, $01, $ea, $67, $c1, $cd, $76
	db $17, $fa, $6b, $c1, $fe, $04, $20, $1d, $cd, $36, $56, $f0, $f7, $fe, $06, $28
	db $08, $3e, $03, $e0, $a9, $3e, $30, $e0, $aa, $cd, $45, $44, $af, $ea, $bf, $c1
	db $3e, $0f, $ea, $fe, $d6, $c9, $1e, $21, $f0, $f7, $fe, $06, $28, $0a, $f0, $f6
	db $fe, $dd, $1e, $12, $20, $02, $1e, $20, $7b, $ea, $fe, $d6, $af, $ea, $3f, $c1
	db $c3, $45, $44, $1e, $24, $f0, $f7, $fe, $06, $28, $0a, $f0, $f6, $fe, $dd, $1e
	db $12, $20, $02, $1e, $23, $7b, $ea, $ff, $d6, $3e, $ff, $ea, $9a, $db, $af, $e0
	db $96, $e0, $97, $ea, $6b, $c1, $ea, $6c, $c1, $1e, $08, $21, $10, $d2, $22, $1d
	db $20, $fc, $c3, $45, $44, $cd, $50, $67, $cd, $c3, $17, $fa, $6b, $c1, $fe, $04
	db $20, $08, $cd, $45, $44, $3e, $80, $ea, $10, $d2, $c9, $f0, $f7, $fe, $06, $20
	db $09, $cd, $50, $67, $3e, $06, $ea, $96, $db, $c9, $f0, $cc, $e6, $b0, $28, $0e
	db $3e, $13, $e0, $f2, $cd, $45, $44, $af, $ea, $6b, $c1, $ea, $6c, $c1, $c9, $cd
	db $50, $67, $fa, $10, $d2, $3d, $ea, $10, $d2, $20, $0b, $ea, $56, $c1, $3e, $20
	db $ea, $10, $d2, $c3, $45, $44, $1e, $00, $e6, $04, $28, $02, $1e, $fe, $7b, $ea
	db $56, $c1, $c9, $cd, $50, $67, $cd, $91, $66, $fa, $10, $d2, $3d, $ea, $10, $d2
	db $20, $2d, $cd, $d7, $08, $3e, $30, $ea, $10, $d2, $3e, $30, $ea, $14, $d2, $3e
	db $18, $ea, $15, $d2, $fa, $11, $d2, $c6, $08, $ea, $11, $d2, $fa, $13, $d2, $3c
	db $ea, $13, $d2, $fe, $04, $20, $08, $3e, $80, $ea, $10, $d2, $cd, $45, $44, $c9
	db $cd, $50, $67, $cd, $91, $66, $21, $10, $d2, $35, $c0, $cd, $45, $44, $af, $ea
	db $6b, $c1, $ea, $6c, $c1, $c9, $af, $ea, $56, $c1, $fa, $15, $d2, $a7, $28, $10
	db $3d, $ea, $15, $d2, $1e, $fe, $e6, $04, $28, $02, $1e, $00, $7b, $ea, $56, $c1
	db $c9, $14, $14, $10, $10, $0c, $0c, $00, $00, $cc, $10, $00, $08, $ce, $10, $00
	db $10, $dc, $10, $00, $18, $cc, $30, $10, $00, $de, $10, $10, $08, $e0, $10, $10
	db $10, $e2, $10, $10, $18, $de, $30, $20, $00, $e4, $10, $20, $08, $e6, $10, $20
	db $10, $e8, $10, $20, $18, $e4, $30, $30, $00, $de, $10, $30, $08, $e0, $10, $30
	db $10, $e0, $30, $30, $18, $de, $30, $40, $00, $de, $10, $40, $08, $e0, $10, $40
	db $10, $e0, $30, $40, $18, $de, $30, $48, $08, $f0, $00, $48, $10, $f2, $00, $48
	db $18, $f4, $00, $48, $20, $f4, $20, $48, $28, $f2, $20, $48, $30, $f0, $20, $48
	db $08, $f6, $00, $48, $10, $f8, $00, $48, $18, $fa, $00, $48, $20, $fa, $20, $48
	db $28, $f8, $20, $48, $30, $f6, $20, $48, $08, $fc, $00, $48, $10, $fe, $00, $48
	db $18, $ee, $00, $48, $20, $ee, $20, $48, $28, $fe, $20, $48, $30, $fc, $20, $02
	db $67, $1a, $67, $32, $67, $f0, $f7, $fe, $06, $c0, $af, $e0, $f1, $e0, $ed, $e0
	db $f5, $3e, $38, $e0, $ee, $fa, $56, $c1, $5f, $3e, $20, $93, $e0, $ec, $fa, $14
	db $d2, $a7, $28, $27, $3d, $ea, $14, $d2, $f0, $e7, $e6, $07, $fa, $12, $d2, $20
	db $06, $3c, $fe, $03, $20, $01, $af, $ea, $12, $d2, $17, $e6, $06, $5f, $50, $21
	db $4a, $67, $19, $2a, $66, $6f, $0e, $06, $cd, $20, $3d, $3e, $48, $e0, $ee, $fa
	db $56, $c1, $5f, $fa, $11, $d2, $c6, $20, $93, $e0, $ec, $fa, $13, $d2, $5f, $16
	db $00, $21, $ac, $66, $19, $4e, $af, $ea, $c0, $c3, $21, $b2, $66, $cd, $26, $3d
	db $c9, $fa, $96, $db, $c7, $cc, $67, $f3, $67, $0b, $68, $1d, $68, $36, $68, $fd
	db $55, $3e, $01, $ea, $67, $c1, $cd, $76, $17, $fa, $6b, $c1, $fe, $04, $20, $17
	db $cd, $36, $56, $3e, $03, $e0, $a9, $3e, $30, $e0, $aa, $cd, $45, $44, $af, $ea
	db $bf, $c1, $3e, $14, $ea, $fe, $d6, $c9, $3e, $15, $ea, $ff, $d6, $3e, $ff, $ea
	db $9a, $db, $af, $e0, $96, $e0, $97, $ea, $6b, $c1, $ea, $6c, $c1, $c3, $45, $44
	db $cd, $c3, $17, $fa, $6b, $c1, $fe, $04, $20, $07, $cd, $45, $44, $af, $ea, $c4
	db $c3, $c9, $fa, $9f, $c1, $a7, $c0, $fa, $c4, $c3, $3c, $ea, $c4, $c3, $ca, $45
	db $44, $fe, $80, $20, $05, $3e, $e7, $cd, $97, $21, $c9, $f0, $cc, $e6, $b0, $28
	db $07, $3e, $13, $e0, $f2, $cd, $0f, $66, $c9, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0, $e0, $e0, $e0, $e0, $e2, $e5
	db $e8, $eb, $ee, $f1, $f4, $f7, $fa, $fd, $00, $03, $06, $09, $0c, $0f, $12, $15
	db $18, $1b, $1e, $21, $24, $27, $2a, $2d, $30, $33, $36, $39, $3c, $3f, $42, $45
	db $48, $33, $36, $39, $3c, $3f, $42, $45, $48, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0, $e2, $e4, $e6, $e8, $ea, $ec, $ee
	db $f0, $f2, $f4, $f6, $f8, $fa, $fc, $fe, $00, $02, $04, $06, $08, $0a, $0c, $0e
	db $10, $12, $14, $16, $18, $1a, $1c, $1d, $1e, $20, $22, $24, $26, $28, $2a, $2c
	db $2e, $20, $22, $24, $26, $28, $2a, $2c, $2e, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $f0, $f0, $df, $e0, $e2, $e3, $e5, $e6, $e8, $e9, $eb, $ec, $ee, $ef, $f1, $f2
	db $f4, $f5, $f7, $f8, $fa, $fb, $fd, $fe, $00, $01, $03, $04, $06, $07, $09, $0a
	db $0c, $0d, $0f, $10, $12, $13, $15, $16, $18, $19, $1b, $1c, $1e, $1f, $21, $22
	db $24, $19, $1b, $1c, $1e, $1f, $21, $22, $24, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $f0, $f0, $f0, $e2, $e3, $e5, $e6, $e8, $e9, $eb, $ec, $ee, $f0, $f2, $f3, $f6
	db $f7, $f8, $f9, $fa, $fc, $fd, $fe, $ff, $00, $01, $03, $04, $06, $07, $09, $0a
	db $0c, $0d, $0f, $10, $12, $13, $15, $16, $18, $19, $1b, $1c, $1e, $1f, $21, $22
	db $22, $24, $25, $27, $29, $2b, $2c, $2e, $2f, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $f0, $e1, $e2, $e4, $e5, $e6, $e8, $e9, $ea, $ec, $ed, $ee, $f0, $f1, $f2, $f4
	db $f5, $f6, $f8, $f9, $fa, $fc, $fe, $ff, $00, $01, $02, $04, $05, $06, $08, $09
	db $0a, $0c, $0d, $0e, $10, $11, $12, $14, $15, $16, $18, $19, $1a, $1c, $1d, $1e
	db $20, $22, $23, $24, $25, $27, $28, $2a, $2b, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $e2, $e3, $e4, $e5, $e6, $e8, $e9, $ea, $ec, $ed, $ee, $ef, $f1, $f2, $f3, $f5
	db $f6, $f8, $f9, $fa, $fb, $fd, $fe, $ff, $00, $01, $02, $03, $05, $06, $07, $08
	db $0a, $0b, $0c, $0d, $0f, $10, $11, $12, $14, $15, $16, $17, $19, $1a, $1b, $1d
	db $1e, $20, $21, $22, $23, $25, $26, $27, $28, $f0, $f0, $f0, $f0, $f0, $f0, $e3
	db $e4, $e5, $e6, $e7, $e8, $e9, $eb, $ec, $ed, $ee, $f0, $f1, $f2, $f3, $f4, $f6
	db $f7, $f8, $f9, $fb, $fc, $fd, $fe, $ff, $00, $01, $02, $03, $04, $06, $07, $08
	db $09, $0a, $0b, $0c, $0e, $10, $11, $12, $13, $14, $15, $16, $18, $19, $1a, $1b
	db $1c, $1d, $1f, $20, $21, $22, $23, $24, $25, $f0, $f0, $f0, $f0, $f0, $e4, $e5
	db $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ee, $ef, $f0, $f1, $f2, $f3, $f4, $f5, $f6
	db $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $00, $01, $02, $03, $04, $05, $06, $07
	db $08, $09, $0a, $0c, $0d, $0e, $0f, $10, $11, $12, $13, $15, $16, $17, $18, $19
	db $1a, $1b, $1c, $1d, $1e, $1f, $21, $22, $23, $f0, $f0, $f0, $f0, $e5, $e6, $e7
	db $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7
	db $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $00, $01, $02, $03, $04, $05, $06, $07
	db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10, $11, $12, $13, $14, $15, $16, $17
	db $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $20, $f0, $f0, $f0, $e6, $e7, $e8, $e8
	db $e9, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7
	db $f8, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $00, $01, $02, $03, $04, $05, $06
	db $07, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10, $11, $12, $13, $14, $15
	db $16, $17, $18, $19, $1a, $1a, $1b, $1c, $1d, $f0, $f0, $e7, $e8, $e9, $ea, $eb
	db $ec, $ec, $ec, $ed, $ee, $ef, $f0, $f1, $f2, $f2, $f3, $f4, $f5, $f6, $f7, $f7
	db $f8, $f9, $fa, $fb, $fc, $fc, $fd, $fe, $ff, $00, $01, $02, $03, $04, $04, $05
	db $06, $07, $08, $09, $09, $0a, $0b, $0c, $0d, $0e, $0e, $0f, $10, $11, $12, $13
	db $14, $15, $16, $16, $17, $18, $19, $1a, $1b, $f0, $e9, $e9, $ea, $eb, $eb, $ec
	db $ed, $ee, $ee, $ef, $f0, $f0, $f1, $f2, $f3, $f4, $f4, $f5, $f6, $f7, $f8, $f8
	db $f9, $fa, $fb, $fc, $fc, $fd, $fe, $ff, $00, $00, $01, $02, $03, $03, $04, $05
	db $06, $06, $07, $08, $09, $0a, $0a, $0b, $0c, $0c, $0d, $0e, $0e, $10, $11, $12
	db $12, $13, $14, $15, $15, $16, $17, $18, $18, $eb, $ec, $ec, $ed, $ee, $ee, $ef
	db $f0, $f0, $f1, $f2, $f2, $f3, $f4, $f4, $f5, $f6, $f6, $f7, $f8, $f8, $f9, $fa
	db $fa, $fb, $fc, $fc, $fd, $fe, $fe, $ff, $00, $00, $01, $02, $02, $03, $04, $04
	db $05, $06, $06, $07, $08, $08, $09, $0a, $0a, $0b, $0c, $0c, $0d, $0e, $0e, $0f
	db $10, $10, $11, $12, $12, $13, $14, $14, $15, $ed, $ee, $ee, $ef, $f0, $f0, $f1
	db $f1, $f2, $f2, $f3, $f3, $f3, $f4, $f5, $f5, $f6, $f6, $f7, $f8, $f8, $f9, $f9
	db $fa, $fb, $fb, $fc, $fc, $fe, $ff, $ff, $00, $00, $01, $01, $02, $03, $03, $04
	db $04, $05, $06, $06, $07, $07, $08, $09, $09, $0a, $0a, $0b, $0c, $0c, $0d, $0d
	db $0e, $0f, $0f, $10, $10, $11, $12, $12, $13, $f0, $f1, $f1, $f2, $f2, $f3, $f3
	db $f4, $f4, $f5, $f5, $f6, $f6, $f7, $f7, $f8, $f8, $f9, $f9, $fa, $fa, $fb, $fb
	db $fc, $fc, $fd, $fd, $fe, $fe, $ff, $ff, $00, $00, $01, $01, $02, $02, $03, $03
	db $04, $04, $05, $05, $06, $06, $07, $07, $08, $08, $09, $09, $0a, $0a, $0b, $0b
	db $0c, $0c, $0d, $0d, $0e, $0e, $0f, $0f, $10, $f3, $f4, $f4, $f4, $f5, $f5, $f6
	db $f6, $f6, $f7, $f7, $f8, $f8, $f8, $f9, $f9, $fa, $fa, $fa, $fb, $fb, $fc, $fc
	db $fc, $fd, $fd, $fe, $fe, $ff, $ff, $00, $00, $00, $01, $01, $02, $02, $03, $03
	db $03, $04, $04, $05, $05, $05, $06, $06, $07, $07, $07, $08, $08, $09, $09, $09
	db $0a, $0a, $0b, $0b, $0b, $0c, $0c, $0d, $0d, $f5, $f6, $f6, $f6, $f7, $f7, $f7
	db $f8, $f8, $f8, $f9, $f9, $f9, $fa, $fa, $fa, $fb, $fb, $fb, $fc, $fc, $fc, $fd
	db $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff, $00, $00, $01, $01, $01, $02, $02, $02
	db $03, $03, $03, $04, $04, $04, $05, $05, $05, $06, $06, $06, $07, $07, $07, $08
	db $08, $08, $09, $09, $09, $0a, $0a, $0a, $0b, $fc, $fc, $fb, $fb, $fb, $fb, $fa
	db $fa, $fa, $fa, $fb, $fb, $fb, $fb, $fc, $fc, $fc, $fc, $fd, $fd, $fd, $fd, $fe
	db $fe, $fe, $fe, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $01, $01, $01, $01, $02
	db $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04, $05, $05, $05, $05, $06
	db $06, $06, $06, $07, $07, $07, $07, $08, $08, $fb, $fb, $fb, $fb, $fb, $fc, $fc
	db $fc, $fc, $fc, $fc, $fd, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $fe, $fe, $fe, $ff
	db $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01
	db $01, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $04, $04, $04
	db $04, $04, $04, $05, $05, $05, $05, $05, $05, $fd, $fd, $fd, $fd, $fd, $fd, $fd
	db $fd, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $fe, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $03, $03, $03, $03, $03, $03, $03, $84, $68, $c4, $68, $04, $69, $84
	db $69, $04, $6a, $44, $6a, $c4, $6a, $04, $6b, $44, $6b, $c4, $6b, $04, $6c, $44
	db $6c, $84, $6c, $c4, $6c, $04, $6d, $44, $6d, $44, $68, $28, $2a, $2c, $2c, $2e
	db $2e, $30, $30, $31, $33, $33, $34, $35, $36, $38, $3a, $3a

Call_01_6DB7::
	ld hl, $c17c
	xor a
	ld [hli], a
	ld [hli], a
	ld d, $00
	ldh a, [$ffe7]
	and $01
	jr nz, jr_001_6dd2

	ld a, [$c17e]
	inc a
	cp $10
	jr c, jr_001_6dcf

	ld a, $10

jr_001_6dcf:
	ld [$c17e], a

jr_001_6dd2:
	ld a, [$c17e]
	ld e, a
	ld hl, $6da6
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	sla e
	ld hl, $6d84
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a

jr_001_6de6:
	ldh a, [rLY]
	cp $10
	jr nz, jr_001_6de6

jr_001_6dec:
	ldh a, [rSTAT]
	and $03
	jr nz, jr_001_6dec

jr_001_6df2:
	ld a, [$c17d]
	inc a
	ld [$c17d], a
	and $01
	jr nz, jr_001_6df2

	ldh a, [$ffd7]
	ld l, a
	ld a, [$c17c]
	ld e, a
	inc a
	ld [$c17c], a
	cp $3a
	jr z, jr_001_6e23

	cp l
	jr c, jr_001_6e15

	ld a, $55
	ldh [rBGP], a
	jr jr_001_6dec

jr_001_6e15:
	ld hl, $0000
	add hl, de
	add hl, bc
	ld a, [hl]
	ld hl, $ff97
	add [hl]
	ldh [rSCY], a
	jr jr_001_6dec

jr_001_6e23:
	ldh a, [$ff97]
	ldh [rSCY], a
	ld a, [$db97]
	ldh [rBGP], a
	ret


Call_01_6E2D::
	ldh a, [$ffcc]
	and $4c
	jr z, jr_001_6e39

Call_01_6E33::
	push af
	ld a, $0a
	ldh [$fff2], a
	pop af

jr_001_6e39:
	ret


	db $c6, $c2, $c0, $c2

	ldh a, [$ffb5]
	and a
	jr z, jr_001_6e48

	dec a
	ldh [$ffb5], a
	jr jr_001_6ead

jr_001_6e48:
	ldh a, [$ffcc]
	and $80
	jr z, jr_001_6ead

	call Call_27D2
	ld a, [$db96]
	cp $0b
	jr z, jr_001_6e90

	ld a, $28
	ldh [$ffb5], a
	ld a, $11
	ld [$d6ff], a
	ld a, $0d
	ld [$db96], a
	xor a
	ld [$c280], a
	ld [$c281], a
	ld [$c282], a
	ld [$c283], a
	ld [$c284], a
	ldh [rBGP], a
	ld [$db97], a
	ld a, $10
	ld [$c17e], a
	call Call_01_727D
	ld a, $0d
	ld [$d368], a
	ld [$d00f], a
	call Call_01_7B11
	jr jr_001_6ea4

jr_001_6e90:
	jp Jump_001_44bc


	db $af, $ea, $96, $db, $e0, $96, $e0, $97, $e0, $47, $ea, $97, $db, $21, $95, $db
	db $34

jr_001_6ea4:
	ld a, $01
	ldh [rIE], a
	ld a, $4f
	ldh [rLYC], a
	ret


jr_001_6ead:
	ld a, [$db96]
	cp $05
	jr nc, jr_001_6ecd

	ld a, [$d000]
	and a
	jr z, jr_001_6ebe

	dec a
	ld [$d000], a

jr_001_6ebe:
	rra
	nop
	and $03
	ld e, a
	ld d, $00
	ld hl, $6e3a
	add hl, de
	ld a, [hl]
	ld [$db97], a

jr_001_6ecd:
	ld a, [$db96]
	rst $00

JumpTable_01_6ED1::
	dw Jump_01_6EED
	dw Jump_01_6F11
	dw Jump_01_6F19
	dw Jump_01_6F84
	dw Jump_01_708A
	dw Jump_01_70D4
	dw Jump_01_710D
	dw Jump_01_7175
	dw Jump_01_7224
	dw Jump_01_724F
	dw Jump_01_726C
	dw Jump_01_729C
	dw Jump_01_7303
	dw Jump_01_7311

Jump_01_6EED::
	call Call_297B
	call Call_27D2
	ld a, $1a
	call Call_27A8
	ld a, $02
	ld [$d6fe], a
	xor a
	ldh [$ffe7], a
	ld a, $a2
	ld [$c13d], a
	ldh a, [rLCDC]
	and $df
	ld [$d6fd], a
	ldh [rLCDC], a
	jp Call_01_4445


Jump_01_6F11::
	ld a, $10
	ld [$d6fe], a
	jp Call_01_4445


Jump_01_6F19::
	call Call_01_7AC4
	ld a, $0e
	ld [$d6ff], a
	ld a, $c6
	ld [$db97], a
	ld a, $1c
	ld [$db98], a
	ld a, $e0
	ld [$db99], a
	ld a, $03
	ldh [rIE], a
	ld a, $00
	ldh [rLYC], a
	ld e, $11
	ld hl, $d000
	xor a

jr_001_6f3e:
	ld [hli], a
	dec e
	jr nz, jr_001_6f3e

	ld [$c280], a
	ld [$c281], a
	ld [$c3b0], a
	ld [$c3b1], a
	ld [$c3b2], a
	ldh [$ffed], a
	ld a, $05
	ld [$c282], a
	ld a, $c0
	ld [$c202], a
	ld a, $4e
	ld [$c212], a
	xor a
	ld [$c340], a
	ld [$c341], a
	ld [$c342], a
	ld [$c343], a
	jp Call_01_4445


	db $81, $40, $00, $00, $00, $00, $00, $00, $00, $08, $08, $08, $04, $00, $00, $00
	db $00, $00

Jump_01_6F84::
	call Call_01_732B
	call Call_01_739B
	ld a, [$d002]
	and a
	jr z, jr_001_6ff0

	inc a
	ld [$d002], a
	cp $18
	jr c, jr_001_6fef

	sub $18
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, $00
	ld hl, $6f72
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $6f7b
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld a, e
	cp $08
	jp nz, Jump_001_6fef

	xor a
	ld [$c280], a
	ld [$c281], a
	ld [$c282], a
	ld [$c290], a
	ld a, $05
	ld [$db96], a
	ld [$d00f], a
	call Call_01_7B11
	ld a, $11
	ld [$d6fe], a
	ld a, $ff
	ld [$d001], a
	xor a
	ldh [$ff96], a
	ld [$c100], a
	ld [$c102], a
	ld [$c103], a
	ld a, $92
	ld [$c101], a
	ld a, $03
	ldh [rIE], a

Jump_001_6fef:
jr_001_6fef:
	ret


jr_001_6ff0:
	ld a, [$c202]
	cp $50
	jr nz, jr_001_7009

	ld a, $04
	ld [$db96], a
	ld a, $0f
	ld [$d6ff], a
	ld a, $01
	ldh [rIE], a
	xor a
	ldh [$ff96], a
	ret


jr_001_7009:
	call Call_01_7AC4
	ldh a, [$ffe7]
	and $07
	jp nz, Jump_001_7089

	ld hl, $ff96
	inc [hl]
	ld hl, $c200
	dec [hl]
	inc hl
	dec [hl]
	inc hl
	dec [hl]
	ld c, $00
	ldh a, [$ff96]
	cp $10
	jr z, jr_001_7040

	inc c
	cp $30
	jr z, jr_001_7040

	inc c
	cp $38
	jr z, jr_001_7040

	inc c
	cp $58
	jr z, jr_001_7040

	inc c
	cp $5a
	jr z, jr_001_7040

	inc c
	cp $69
	jr nz, jr_001_7089

jr_001_7040:
	ld e, $01
	ld d, $00

jr_001_7044:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_705f

	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_7044

	ret


	db $28, $78, $60, $38, $68, $58, $04, $02, $01, $04, $03, $01

jr_001_705f:
	ld b, $00
	ld hl, $7059
	add hl, bc
	ld a, [hl]
	ld hl, $c280
	add hl, de
	ld [hl], a
	ld hl, $7053
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $c210
	add hl, de
	ld [hl], $30
	ld hl, $c2e0
	add hl, de
	ld [hl], $20

Call_01_7081::
	ld a, $1c
	ld [$d000], a
	call Call_08D7

Jump_001_7089:
jr_001_7089:
	ret


Jump_01_708A::
	call Call_01_732B
	ld a, [$d001]
	inc a
	ld [$d001], a
	cp $80
	jr nz, jr_001_709d

	push af
	call Call_01_738C
	pop af

jr_001_709d:
	cp $90
	jr nz, jr_001_70a4

	call Call_01_7081

jr_001_70a4:
	cp $a0
	jr nz, jr_001_70c3

	ld a, $03
	ld [$db96], a
	ld a, $0e
	ld [$d6ff], a
	ld a, $03
	ldh [rIE], a
	xor a
	ld [$c280], a
	ld [$c281], a
	ld a, $01
	ld [$d002], a
	ret


jr_001_70c3:
	ldh a, [$ffe7]
	and $7f
	jr nz, jr_001_70d3

	call Call_27ED
	and $00
	jr nz, jr_001_70d3

	call Call_01_7081

jr_001_70d3:
	ret


Jump_01_70D4::
	ld a, $10
	ld [$d6ff], a
	call Call_01_4445
	ret


	db $00, $00, $00, $00, $40, $40, $40, $80, $85, $85, $85, $c5, $c9, $c9, $c9, $c9
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
	db $00, $00, $00, $00, $40, $40, $40, $40, $90, $90, $90, $90, $e0, $e0, $e0, $e0

Jump_01_710D::
	call Call_01_7179
	ld a, [$d001]
	cp $a0
	jr nz, jr_001_711d

	push af
	ld a, $02
	ldh [rLYC], a
	pop af

jr_001_711d:
	dec a
	ld [$d001], a
	jr nz, jr_001_713d

	ld a, $07
	ld [$db96], a
	ld a, $06
	ld [$c280], a
	ld a, $b0
	ld [$c200], a
	ld a, $68
	ld [$c210], a
	ld a, $01
	ld [$c3d0], a
	ret


jr_001_713d:
	cp $34
	jr nc, jr_001_7174

	and $03
	jr nz, jr_001_7150

	ld a, [$d010]
	cp $0c
	jr z, jr_001_7150

	inc a
	ld [$d010], a

jr_001_7150:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d010]
	add e
	ld e, a
	ld d, $00
	ld hl, $70dd
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $70ed
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $70fd
	add hl, de
	ld a, [hl]
	ld [$db99], a

jr_001_7174:
	ret


Jump_01_7175::
	call Call_01_739B
	ret


Call_01_7179::
	ld a, [$c291]
	cp $02
	jr nc, jr_001_7190

	ld a, [$c114]
	inc a
	cp $a0
	jr nz, jr_001_718d

	ld a, $0f
	ldh [$fff4], a
	xor a

jr_001_718d:
	ld [$c114], a

jr_001_7190:
	ret


	db $9a, $16, $0f, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c
	db $8d, $8e, $8f, $9a, $36, $0f, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99
	db $9a, $9b, $9c, $9d, $9e, $9f, $9a, $56, $0f, $a0, $a1, $a2, $a3, $a4, $a5, $a6
	db $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $9a, $76, $0f, $b0, $b1, $b2, $b3
	db $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $9a, $96, $0f, $c0
	db $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf, $9a
	db $b6, $0f, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd
	db $de, $df, $9a, $d6, $0f, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea
	db $eb, $ec, $ed, $ee, $ef, $ca, $71, $b7, $71, $dd, $71, $a4, $71, $f0, $71, $91
	db $71, $03, $72

Jump_01_7224::
	ld a, [$d002]
	sla a
	ld e, a
	ld d, $00
	ld hl, $7216
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $d601
	ld c, $13

jr_001_7238:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_001_7238

	ld [hl], $00
	ld a, [$d002]
	inc a
	ld [$d002], a
	cp $07
	jr nz, jr_001_724e

	call Call_01_4445

jr_001_724e:
	ret


Jump_01_724F::
	ld a, [$c17e]
	cp $10
	jr c, jr_001_725d

	ld a, $19
	ldh [$fff4], a
	call Call_01_4445

jr_001_725d:
	ret


	db $9b, $b9, $09, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $00

Jump_01_726C::
	ld de, $725e
	ld hl, $d601
	ld c, $0e

jr_001_7274:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_001_7274

	call Call_01_4445

Call_01_727D::
	ld a, $a0
	ld [$d001], a
	xor a
	ld [$d002], a
	ld a, $ff
	ld [$d003], a
	ret


	db $18, $18, $38, $40, $58, $60, $80, $88, $20, $48, $44, $28, $44, $28, $28, $40

Jump_01_729C::
	call Call_01_739B
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_001_72e1

	ld e, $01
	ld d, $00

jr_001_72a9:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_001_72b9

	dec e
	ld a, e
	cp $ff
	jr nz, jr_001_72a9

	jr jr_001_72e1

jr_001_72b9:
	ld [hl], $08
	ld hl, $c2e0
	add hl, de
	ld [hl], $3f
	ld a, [$d003]
	inc a
	ld [$d003], a
	and $07
	ld c, a
	ld b, $00
	ld hl, $728c
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $7294
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a

jr_001_72e1:
	ld a, [$d002]
	inc a
	ld [$d002], a
	and $0f
	jr nz, jr_001_7302

	ld a, [$d001]
	dec a
	ld [$d001], a
	jr nz, jr_001_7302

	call Call_01_4445
	xor a
	ld [$c16b], a
	ld [$c16c], a
	call Call_27CA

jr_001_7302:
	ret


Jump_01_7303::
	call Call_1776
	ld a, [$c16b]
	cp $04
	jr nz, jr_001_7310

	jp Jump_001_5f1a


jr_001_7310:
	ret


Jump_01_7311::
	ld a, $11
	ld [$d6fe], a
	ld a, $0b
	ld [$db96], a
	ld a, $c9
	ld [$db97], a
	ld a, $1c
	ld [$db98], a
	xor a
	ldh [$ff96], a
	ldh [$ff97], a
	ret


Call_01_732B::
	call Call_27ED
	and $18
	add $10
	ldh [$ffd8], a
	call Call_27ED
	and $18
	add $10
	ldh [$ffd7], a
	ld hl, $c04c
	ld c, $10
	ld a, [$db96]
	cp $04
	jr nz, jr_001_734b

	ld c, $15

jr_001_734b:
	ldh a, [$ffd8]
	ld [hli], a
	ldh a, [$ffd7]
	ld [hli], a
	call Call_27ED
	and $01
	ld a, $28
	jr z, jr_001_7361

	call Call_27ED
	and $06
	add $70

jr_001_7361:
	ld [hli], a
	ld a, $00
	ld [hli], a
	ldh a, [$ffd7]
	add $1c
	ldh [$ffd7], a
	cp $a0
	jr c, jr_001_7379

	sub $98
	ldh [$ffd7], a
	ldh a, [$ffd8]
	add $25
	ldh [$ffd8], a

jr_001_7379:
	dec c
	jr nz, jr_001_734b

	ret


	db $99, $2b, $83, $1e, $20, $22, $24, $99, $2c, $83, $1f, $21, $23, $25, $00

Call_01_738C::
	ld de, $d601
	ld hl, $737d
	ld c, $0f

jr_001_7394:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_001_7394

	ret


Call_01_739B::
	xor a
	ld [$c3c0], a
	ld c, $02
	ld b, $00

jr_001_73a3:
	ld a, c
	ld [$c123], a
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_001_73ce

	ld hl, $c200
	add hl, bc
	ld a, [hl]
	ldh [$ffee], a
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	ldh [$ffec], a
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	ldh [$fff1], a
	ld hl, $c290
	add hl, bc
	ld a, [hl]
	ldh [$fff0], a
	call Call_01_73D5

jr_001_73ce:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_001_73a3

	ret


Call_01_73D5::
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	cp $05
	jr z, jr_001_742d

	cp $06
	jp z, Jump_001_7524

	cp $07
	jp z, Jump_001_770c

	cp $08
	jp z, Jump_001_76a2

	call Call_0891
	jr nz, jr_001_73f8

	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


jr_001_73f8:
	dec [hl]
	call Call_01_74F0
	ret


	db $00, $00, $1c, $00, $00, $08, $1e, $00, $10, $f8, $20, $00, $10, $00, $22, $00
	db $10, $08, $24, $00, $10, $10, $26, $00, $f8, $04, $32, $00, $e8, $04, $32, $00
	db $d8, $04, $32, $00, $c8, $04, $32, $00, $02, $01, $00, $00, $00, $01, $02, $02

jr_001_742d:
	ld a, [$d002]
	and a
	ld a, $00
	jr nz, jr_001_743f

	ldh a, [$ffe7]
	add $d0
	rra
	rra
	rra
	rra
	and $07

jr_001_743f:
	ld e, a
	ld d, $00
	ld hl, $7425
	add hl, de
	ld a, [hl]
	ld hl, $ffec
	add [hl]
	ld [hl], a
	ld hl, $73fd
	ld de, $c000
	push bc
	ld c, $06

jr_001_7455:
	ldh a, [$ffec]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ldh a, [$ffee]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_001_7455

	ld a, [$d002]
	cp $10
	jr c, jr_001_748e

	ld hl, $7415
	ld de, $c018
	ld c, $04

jr_001_7479:
	ldh a, [$ffec]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ldh a, [$ffee]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_001_7479

jr_001_748e:
	pop bc
	ret


	db $00, $00, $34, $00, $00, $08, $36, $00, $10, $00, $2c, $00, $20, $f8, $2c, $00
	db $28, $00, $2e, $20, $30, $f0, $2e, $00, $08, $00, $36, $20, $08, $08, $34, $20
	db $18, $00, $30, $00, $18, $08, $2c, $20, $28, $10, $2e, $20, $28, $10, $2e, $20
	db $00, $08, $34, $20, $00, $00, $36, $20, $10, $08, $2c, $20, $20, $10, $2c, $20
	db $28, $08, $2e, $00, $30, $18, $2e, $20, $08, $08, $36, $00, $08, $00, $34, $00
	db $18, $08, $30, $20, $18, $00, $2c, $00, $28, $f8, $2e, $00, $28, $f8, $2e, $00

Call_01_74F0::
	ld hl, $c280
	add hl, bc
	ld a, [hl]
	dec a
	sla a
	sla a
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
	ld hl, $7490
	add hl, de
	ld c, $06
	call Call_3D26
	ld a, [$c3c0]
	add $18
	ld [$c3c0], a
	ret


	db $00, $00, $02, $00, $04, $00, $06, $00, $08, $00, $0a, $00, $0c, $00, $0e, $00

Jump_001_7524:
	call Call_01_7179
	xor a
	ld [$c340], a
	ld de, $7514
	call Call_3C3B
	ld a, [$c3c0]
	add $08
	ld [$c3c0], a
	ldh a, [$fff0]
	rst $00

JumpTable_01_753C::
	dw Jump_01_7546
	dw Jump_01_7570
	dw Jump_01_759B
	dw Jump_01_75D6
	dw Jump_01_7646

Jump_01_7546::
	call Call_01_7B5F
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffee]
	cp $48
	jr nc, jr_001_7561

	call Call_0891
	ld [hl], $40
	call Call_3B8D

jr_001_7561:
	ld hl, $c3d0
	add hl, bc
	dec [hl]
	jr nz, jr_001_756f

	ld [hl], $04
	ld hl, $c200
	add hl, bc
	dec [hl]

jr_001_756f:
	ret


Jump_01_7570::
	call Call_01_7B09
	ld a, $01
	call Call_3B87
	call Call_0891
	jr nz, jr_001_7599

	call Call_3B8D
	ld a, $07
	ld [$c281], a
	ld a, $fe
	ld [$c201], a
	ld a, $6e
	ld [$c211], a
	xor a
	ld [$c291], a
	ld [$c2e1], a
	ldh [$ffe7], a
	ret


jr_001_7599:
	dec [hl]
	ret


Jump_01_759B::
	call Call_01_7B5F
	ld a, [$c201]
	dec a
	ld [$c201], a
	ldh a, [$ffe7]
	and $01
	jr nz, jr_001_75cc

	ld hl, $ff96
	inc [hl]
	ld a, [hl]
	cp $30
	jr nz, jr_001_75bc

	call Call_0891
	ld [hl], $40
	jp Call_3B8D


jr_001_75bc:
	cp $20
	jr nz, jr_001_75c4

	call Call_01_76F3
	xor a

jr_001_75c4:
	cp $22
	jr nz, jr_001_75cc

	call Call_01_76EE
	xor a

jr_001_75cc:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_01_75D6::
	call Call_0891
	jr nz, jr_001_763d

	call Call_01_7B92
	ldh a, [$ffe7]
	and $01
	jr nz, jr_001_7631

	ld a, [$c201]
	dec a
	ld [$c201], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_001_7631

	ld hl, $ff96
	inc [hl]
	ld a, [hl]
	cp $40
	jr z, jr_001_7605

	cp $3a
	jr nz, jr_001_760a

	call Call_0891
	ld [hl], $30
	jr jr_001_760a

jr_001_7605:
	call Call_0891
	ld [hl], $50

jr_001_760a:
	ldh a, [$ff96]
	cp $56
	jr nz, jr_001_7621

	ld a, $a0
	ld [hl], a
	ldh [rSCX], a
	ld a, $01
	ldh [rIE], a
	call Call_0891
	ld [hl], $e0
	jp Call_3B8D


jr_001_7621:
	cp $20
	jr nz, jr_001_7629

	call Call_01_76F3
	xor a

jr_001_7629:
	cp $22
	jr nz, jr_001_7631

	call Call_01_76EE
	xor a

jr_001_7631:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


jr_001_763d:
	dec [hl]
	call Call_01_7B09
	ld a, $01
	jp Call_3B87


Jump_01_7646::
	call Call_01_7B09
	ldh a, [$ffe7]
	and $01
	jr nz, jr_001_7681

	ld a, $02
	call Call_3B87
	ld a, $00
	ld [$c3b1], a
	call Call_0891
	jr z, jr_001_765f

	dec [hl]

jr_001_765f:
	cp $a0
	jr nc, jr_001_7681

	cp $90
	jr nc, jr_001_7677

	cp $50
	jr nc, jr_001_7681

	cp $4a
	jr nc, jr_001_7677

	cp $3c
	jr nc, jr_001_7681

	cp $36
	jr c, jr_001_7681

jr_001_7677:
	ld a, $03
	call Call_3B87
	ld a, $01
	ld [$c3b1], a

jr_001_7681:
	ret


	db $38, $00, $38, $20, $3a, $00, $3a, $20, $3a, $00, $3a, $20, $3c, $00, $3e, $00
	db $3c, $00, $3e, $00, $3a, $00, $3a, $20, $3a, $00, $3a, $20, $38, $00, $38, $20

Jump_001_76a2:
	call Call_0891
	dec [hl]
	jr nz, jr_001_76ae

	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


jr_001_76ae:
	ld a, [hl]
	rra
	rra
	rra
	and $07
	ldh [$fff1], a
	xor a
	ld [$c340], a
	ld de, $7682
	call Call_3C3B
	ld a, [$c3c0]
	add $08
	ld [$c3c0], a
	ret


	db $98, $00, $43, $7d, $98, $20, $43, $7d, $98, $40, $43, $7d, $98, $60, $43, $7d
	db $00, $98, $04, $03, $7d, $7d, $4c, $4d, $98, $24, $43, $7d, $98, $44, $43, $7d
	db $98, $64, $43, $7d, $00

Call_01_76EE::
	ld hl, $76da
	jr jr_001_76f6

Call_01_76F3::
	ld hl, $76c9

jr_001_76f6:
	ld de, $d601
	push bc
	ld c, $18

jr_001_76fc:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_001_76fc

	pop bc
	ret


	db $10, $00, $12, $00, $14, $00, $16, $00

Jump_001_770c:
	ldh a, [$ffee]
	cp $f0
	jr nc, jr_001_7724

	xor a
	ld [$c340], a
	ld de, $7704
	call Call_3C3B
	ld a, [$c3c0]
	add $08
	ld [$c3c0], a

jr_001_7724:
	ldh a, [$fff0]
	rst $00

JumpTable_01_7727::
	dw Jump_01_772F
	dw Jump_01_773B
	dw Jump_01_774B
	dw Jump_01_77A1

Jump_01_772F::
	call Call_0891
	dec [hl]
	jr nz, jr_001_773a

	ld [hl], $90
	call Call_3B8D

jr_001_773a:
	ret


Jump_01_773B::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_001_7747

	call Call_0891
	dec [hl]
	jr z, jr_001_7748

jr_001_7747:
	ret


jr_001_7748:
	jp Call_3B8D


Jump_01_774B::
	ld a, [$d00a]
	cp $13
	jr z, jr_001_7790

	ld a, [$d00e]
	inc a
	ld [$d00e], a
	and $03
	jr nz, jr_001_778f

	ld a, [$c210]
	cp $a0
	jr nc, jr_001_7768

	inc a
	ld [$c210], a

jr_001_7768:
	ld a, [$c211]
	cp $a0
	jr nc, jr_001_7773

	inc a
	ld [$c211], a

jr_001_7773:
	ldh a, [$ff97]
	push af
	dec a
	ldh [$ff97], a
	pop af
	and $07
	jr nz, jr_001_778f

	push bc
	call Call_01_7A41
	pop bc
	ld a, [$d00a]
	cp $0b
	jr nz, jr_001_778f

	ld a, $01
	ld [$d368], a

jr_001_778f:
	ret


jr_001_7790:
	call Call_3B8D
	call Call_0891
	ld [hl], $17
	ld a, $07
	ldh [$ffa9], a
	ld a, $70
	ldh [$ffaa], a
	ret


Jump_01_77A1::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_001_77c0

	call Call_0891
	dec [hl]
	jr nz, jr_001_77c0

	call Call_01_4445
	xor a
	ld [$d002], a
	ld [$d003], a
	ld [$d004], a
	ld [$c280], a
	ld [$c281], a

jr_001_77c0:
	ret


	db $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d
	db $4c, $4d, $7c, $7c, $7c, $7c, $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d
	db $7d, $7d, $4c, $4d, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $70, $71, $72
	db $73, $74, $75, $76, $77, $78, $79, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $46, $7d, $7d, $7d, $7d, $4b, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $5c, $5d, $5e, $5f, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $58, $59, $5a, $5b
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $54, $55, $56, $57, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $50, $51, $52, $53, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $2b, $2c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c

Call_01_7A41::
	ld a, [$d00a]
	and a
	jr nz, jr_001_7a51

	ld a, $f4
	ld [$d00b], a
	ld a, $9b
	ld [$d00c], a

jr_001_7a51:
	ld a, [$d00a]
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld a, e
	sla e
	rl d
	sla e
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	ld c, $00
	ld hl, $d601
	ld a, [$d00c]
	ld [hli], a
	ld a, [$d00b]
	ld [hli], a
	ld a, $13
	ld [hli], a

jr_001_7a7e:
	push hl
	ld hl, $77c1
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
	inc de
	inc c
	ld a, c
	cp $14
	jr nz, jr_001_7a7e

	ld [hl], $00
	ld hl, $d00a
	inc [hl]
	ld a, [$d00b]
	sub $20
	ld [$d00b], a
	ld a, [$d00c]
	sbc $00
	ld [$d00c], a
	ret


	db $00, $50, $80, $50, $00, $51, $80, $51, $00, $52, $80, $52, $00, $53, $80, $53
	db $00, $02, $04, $06, $06, $04, $02, $00, $03, $02, $01, $00, $00, $01, $02, $03

Call_01_7AC4::
	ld hl, $c100
	ldh a, [$ffe7]
	and $07
	jr nz, jr_001_7ace

	inc [hl]

jr_001_7ace:
	inc hl
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_001_7ad6

	inc [hl]

jr_001_7ad6:
	inc hl
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_001_7ade

	inc [hl]

jr_001_7ade:
	inc hl
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_001_7ae6

	inc [hl]

jr_001_7ae6:
	inc hl
	ld a, [$d004]
	add $28
	ld [$d004], a
	jr nc, jr_001_7af2

	inc [hl]

jr_001_7af2:
	ldh a, [$ffe7]
	add $fc
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $7abc
	add hl, de
	ld a, $00
	sub [hl]
	ld [$c106], a

Call_01_7B09::
	ldh a, [$ffe7]
	and $0f
	cp $04
	jr c, jr_001_7b5e

Call_01_7B11::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $7ab4
	add hl, de
	ld e, [hl]
	ld hl, $7aa4
	ld a, [$d00f]
	and a
	jr z, jr_001_7b2d

	ld hl, $7aac

jr_001_7b2d:
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $8900
	ld a, [$d00f]
	and a
	jr z, jr_001_7b3d

	ld de, $9300

jr_001_7b3d:
	ldh a, [$ffe7]
	and $03
	sla a
	sla a
	sla a
	sla a
	sla a
	ld e, a
	add l
	ld l, a
	ld a, l
	ld [$d006], a
	ld a, h
	ld [$d007], a
	ld a, e
	ld [$d008], a
	ld a, d
	ld [$d009], a

jr_001_7b5e:
	ret


Call_01_7B5F::
	ld hl, $c100
	ldh a, [$ffe7]
	and $07
	jr nz, jr_001_7b69

	inc [hl]

jr_001_7b69:
	ld hl, $c101
	ld a, [$d004]
	add $50
	ld [$d004], a
	jr nc, jr_001_7b77

	inc [hl]

jr_001_7b77:
	inc hl
	ld a, [$d005]
	add $58
	ld [$d005], a
	jr nc, jr_001_7b83

	inc [hl]

jr_001_7b83:
	inc hl
	ld a, [$d00d]
	add $b0
	ld [$d00d], a
	jr nc, jr_001_7b8f

	inc [hl]

jr_001_7b8f:
	jp Call_01_7B09


Call_01_7B92::
	ld hl, $c100
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_001_7b9c

	inc [hl]

jr_001_7b9c:
	ld hl, $c101
	ld a, [$d004]
	add $28
	ld [$d004], a
	jr nc, jr_001_7baa

	inc [hl]

jr_001_7baa:
	inc hl
	ld a, [$d005]
	add $2c
	ld [$d005], a
	jr nc, jr_001_7bb6

	inc [hl]

jr_001_7bb6:
	inc hl
	ld a, [$d00d]
	add $58
	ld [$d00d], a
	jr nc, jr_001_7bc2

	inc [hl]

jr_001_7bc2:
	jp Call_01_7B09


Call_01_7BC5::
	ldh a, [$ff92]
	cp $08
	jp c, Jump_001_7c87

	jr nz, jr_001_7bd6

	call Call_01_7C00
	ld hl, $ff92
	inc [hl]
	ret


jr_001_7bd6:
	call Call_01_7BFA
	xor a
	ldh [$ff90], a
	ldh [$ff92], a
	ret


	db $0f, $51, $b1, $ef, $ec, $aa, $4a, $0c, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8
	db $d0, $d2, $d4, $d6, $d8, $da, $dc, $de, $01, $1f, $01

Call_01_7BFA::
	ld c, $08
	ld e, $04
	jr jr_001_7c04

Call_01_7C00::
	ld c, $04
	ld e, $00

jr_001_7c04:
	ld a, c
	ldh [$ffe0], a
	ld d, $00

Jump_001_7c09:
	xor a
	ldh [$ffd7], a
	ldh [$ffd8], a
	ldh [$ffd9], a
	ldh [$ffda], a
	ld hl, $db65
	add hl, de
	ld a, [hl]
	bit 1, a
	jp nz, Jump_001_7c3a

	ld c, $00
	ld b, c
	ld hl, $7bdf
	add hl, de
	ld a, [hl]
	ld l, a
	ld h, $9d
	push hl
	ld a, $7c
	ldh [$ffd7], a
	ldh [$ffd8], a
	ldh [$ffd9], a
	ld hl, $7be7
	add hl, de
	ld a, [hl]
	ldh [$ffda], a
	pop hl
	jr jr_001_7c58

Jump_001_7c3a:
	ld c, $00
	ld b, c
	ld hl, $7bdf
	add hl, de
	ld a, [hl]
	ld l, a
	ld h, $9d
	push hl
	ld hl, $7bef
	add hl, de
	ld a, [hl]
	ldh [$ffd7], a
	inc a
	ldh [$ffd8], a
	add $0f
	ldh [$ffd9], a
	inc a
	ldh [$ffda], a
	pop hl

jr_001_7c58:
	ldh a, [$ffd7]
	ld [hl], a
	call Call_01_7C79
	ldh a, [$ffd8]
	ld [hl], a
	inc c
	call Call_01_7C79
	ldh a, [$ffd9]
	ld [hl], a
	inc c
	call Call_01_7C79
	ldh a, [$ffda]
	ld [hl], a
	inc e
	ld a, e
	ld hl, $ffe0
	cp [hl]
	jp nz, Jump_001_7c09

	ret


Call_01_7C79::
	push hl
	ld hl, $7bf7
	add hl, bc
	ld a, [hl]
	pop hl
	add l
	ld l, a
	ld a, h
	adc $00
	ld h, a
	ret


Jump_001_7c87:
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
	ld hl, $4d00
	add hl, bc
	call Call_08C6
	ldh a, [$ff92]
	inc a
	ldh [$ff92], a
	ret


	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $10, $1b, $20, $2b
	db $30, $3b, $40, $4b, $50, $5b, $60, $6b, $70, $7b, $80, $8b, $90, $91, $92, $93
	db $94, $95, $96, $97, $98, $99, $9a, $9b, $ff

Call_01_7CDE::
	ld bc, $7cb5

jr_001_7ce1:
	ld a, [bc]
	cp $ff
	jr z, jr_001_7cf2

	ld e, a
	ld d, $00
	ld hl, $d700
	add hl, de
	ld [hl], $ff
	inc bc
	jr jr_001_7ce1

jr_001_7cf2:
	ret


Call_01_7CF3::
	ld bc, $0400
	ld hl, $9800

jr_001_7cf9:
	ld e, $00
	ld a, l
	and $20
	jr z, jr_001_7d01

	inc e

jr_001_7d01:
	ld d, $ae
	ld a, l
	and $01
	xor e
	jr z, jr_001_7d0a

	inc d

jr_001_7d0a:
	ld a, l
	and $1f
	cp $14
	jr nc, jr_001_7d12

	ld [hl], d

jr_001_7d12:
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, jr_001_7cf9

	ret


	ld c, $c0
	ld b, $0a
	ld hl, $7d27

jr_001_7d20:
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, jr_001_7d20

	ret


	db $3e, $c0, $e0, $46, $3e, $28, $3d, $20, $fd, $c9, $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2d, $9e, $2c, $9e, $2b, $9e
	db $2d, $9e, $31, $9e, $2d, $9e, $2b, $9e, $2d, $9e

	ld a, [$0004]
	and a
	ret nz

	ld a, [$dba5]
	and a
	jr z, jr_001_7de7

	ldh a, [$fff7]
	cp $08
	jr nc, jr_001_7de7

	sla a
	ld e, a
	ld d, $00
	ld hl, $7db1
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld [hl], $a3
	ldh a, [$fff9]
	and a
	jr z, jr_001_7de7

	ld [hl], $7f

jr_001_7de7:
	ret


	db $27, $6a, $6c, $21, $22, $23, $24, $25, $26, $6a, $ff, $6c, $6a, $6c, $6a, $6c
	db $65, $65, $66, $31, $32, $33, $34, $35, $36, $67, $68, $64, $67, $69, $65, $66
	db $40, $40, $41, $42, $43, $44, $fa, $fa, $63, $40, $40, $40, $40, $40, $40, $60
	db $ff, $fa, $48, $49, $4a, $fa, $fa, $fa, $62, $6d, $6d, $6d, $6d, $6d, $6d, $ff
	db $00, $01, $00, $01, $fa, $ff, $5e, $5f, $04, $05, $06, $07, $28, $29, $29, $2a
	db $10, $11, $10, $11, $fa, $fa, $6e, $6f, $14, $15, $16, $17, $38, $20, $20, $3a
	db $00, $01, $00, $01, $fb, $ff, $fe, $fe, $08, $09, $0a, $0b, $38, $20, $20, $3a
	db $10, $11, $10, $11, $fb, $fb, $fe, $fe, $18, $19, $1a, $1b, $48, $49, $49, $4a
	db $fb, $ff, $0c, $0d, $40, $40, $40, $40, $fa, $fa, $ff, $58, $0e, $0f, $fa, $fa
	db $fb, $fb, $1c, $1d, $fa, $fa, $fa, $fa, $fa, $fa, $fa, $5d, $1e, $1f, $fa, $fa
	db $0c, $0d, $0c, $0d, $fb, $fb, $28, $2a, $fa, $fa, $fa, $58, $2d, $2e, $2e, $2f
	db $1c, $1d, $1c, $1d, $fb, $56, $61, $4a, $fa, $fa, $59, $5a, $3d, $3e, $3e, $3f
	db $fd, $fd, $fd, $fd, $fb, $fb, $fb, $fb, $28, $29, $5b, $fa, $ff, $ff, $54, $54
	db $fd, $fd, $fd, $fd, $fb, $fb, $ff, $fb, $38, $30, $3a, $fa, $ff, $ff, $54, $54
	db $fd, $fd, $fd, $ff, $fd, $fd, $fb, $fb, $48, $fe, $4a, $fa, $56, $57, $54, $54
	db $03, $12, $13, $12, $13, $02, $ff, $fb, $5c, $2b, $fa, $fa, $fa, $fa, $54, $54

Call_01_7EE8::
	ld de, $9822
	ld bc, $0000

jr_001_7eee:
	ld a, [$c5a2]
	and a
	jr nz, jr_001_7f06

	ld a, [$db95]
	cp $01
	jr z, jr_001_7f06

	ld hl, $d800
	add hl, bc
	ld a, [hl]
	and $80
	ld a, $2c
	jr z, jr_001_7f0b

jr_001_7f06:
	ld hl, $7de8
	add hl, bc
	ld a, [hl]

jr_001_7f0b:
	ld [de], a
	inc c
	jr z, jr_001_7f23

	inc e
	ld a, e
	and $1f
	cp $12
	jr nz, jr_001_7f21

	ld a, e
	and $e0
	add $22
	ld e, a
	ld a, d
	adc $00
	ld d, a

jr_001_7f21:
	jr jr_001_7eee

jr_001_7f23:
	ret


	db $0f, $00, $1f, $00, $3f, $00, $3f, $11, $3f, $1f, $3f, $1f, $3f, $19, $3f, $11
	db $3f, $03, $ff, $1f, $ff, $40, $ff, $4a, $ff, $51, $ff, $5f, $fe, $5f, $7e, $1f
	db $3e, $1f, $3c, $1f, $3f, $1f, $3f, $1f, $3f, $1f, $3f, $1f, $3a, $1d, $39, $17
	db $33, $1f, $3b, $16, $39, $1f, $1c, $0b, $0f, $05, $07, $03, $03, $00, $00, $00
	db $4c, $62, $63, $66, $6b, $63, $65, $64, $60, $4c, $4d, $4c, $4c, $4c, $4e, $4e
	db $4e, $4d, $4d, $4f, $61, $63, $63, $00, $00, $00, $00, $00, $00, $4e, $4e, $4d
	db $40, $40, $6c, $40, $40, $6c, $40, $6e, $4a, $40, $46, $40, $40, $40, $48, $48
	db $48, $46, $48, $4a, $40, $46, $6c, $00, $00, $00, $00, $00, $00, $48, $48, $46
	db $79, $79, $77, $79, $79, $77, $78, $79, $79, $63, $7a, $00, $00, $00, $7b, $7b
	db $7b, $7a, $7b, $79, $7c, $7a, $77, $00, $00, $00, $00, $00, $00, $7c, $7b, $7a
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
