; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $017", ROMX[$4000], BANK[$17]

	db $18, $05, $37, $20, $36, $0e, $1e, $2b, $25, $14, $1f, $12, $15, $2c, $31, $3f
	db $0c, $30, $01, $33, $04, $27, $08, $1d, $38, $17, $3e, $28, $11, $00, $3a, $3d
	db $2a, $0b, $1b, $0a, $34, $07, $22, $0f, $1c, $23, $2f, $3b, $2d, $16, $3c, $32
	db $10, $29, $02, $2e, $0d, $19, $09, $26, $24, $06, $13, $21, $1a, $03, $39, $35
	db $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe, $50, $91, $60, $90, $70, $90, $80, $90
	db $90, $90, $a0, $90, $f0, $91, $60, $91, $70, $91, $80, $91, $90, $91, $a0, $91

	ld a, [$d00b]
	ld e, a
	ld d, $00
	ld hl, $4000
	add hl, de
	ld a, [hl]
	rra
	rra
	and $0e
	ld b, a
	ld a, [hl]
	and $07
	ld e, a
	ld hl, $4040
	add hl, de
	ld c, [hl]
	xor a
	ld d, a

jr_017_407b:
	ldh [$ffd9], a
	sla a
	ld e, a
	ld hl, $4048
	add hl, de
	ld a, [hli]
	ld h, [hl]
	add b
	ld l, a
	ld a, [hl]
	and c
	ld [hli], a
	ld a, [hl]
	and c
	ld [hl], a
	ldh a, [$ffd9]
	inc a
	cp $0c
	jr nz, jr_017_407b

	xor a
	ldh [$ffa5], a
	ret


	db $20, $20, $20, $20, $20, $44, $49, $52, $45, $43, $54, $4f, $52, $20, $20, $20
	db $20, $20, $20, $44, $55, $4e, $47, $45, $4f, $4e, $20, $44, $45, $53, $49, $47
	db $4e, $45, $52, $20, $20, $20, $53, $43, $52, $49, $50, $54, $20, $57, $52, $49
	db $54, $45, $52, $20, $20, $20, $20, $20, $20, $20, $50, $52, $4f, $47, $52, $41
	db $4d, $4d, $45, $52, $20, $20, $20, $20, $43, $48, $41, $52, $41, $43, $54, $45
	db $52, $20, $44, $45, $53, $49, $47, $4e, $45, $52, $20, $20, $53, $4f, $55, $4e
	db $44, $20, $43, $4f, $4d, $50, $4f, $53, $45, $52, $20, $20, $20, $20, $20, $49
	db $4c, $4c, $55, $53, $54, $52, $41, $54, $4f, $52, $20, $20, $20, $20, $20, $53
	db $50, $45, $43, $49, $41, $4c, $20, $54, $48, $41, $4e, $4b, $53, $20, $54, $4f
	db $20, $20, $20, $20, $20, $50, $52, $4f, $44, $55, $43, $45, $52, $20, $20, $20
	db $20, $20, $45, $58, $45, $43, $55, $54, $49, $56, $45, $20, $50, $52, $4f, $44
	db $55, $43, $45, $52, $20, $20, $45, $4e, $47, $4c, $49, $53, $48, $20, $53, $43
	db $52, $49, $50, $54, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $54, $41, $4b, $41, $53, $48
	db $49, $20, $54, $45, $5a, $55, $4b, $41, $20, $20, $20, $59, $41, $53, $55, $48
	db $49, $53, $41, $20, $59, $41, $4d, $41, $4d, $55, $52, $41, $20, $20, $4b, $45
	db $4e, $53, $55, $4b, $45, $20, $54, $41, $4e, $41, $42, $45, $20, $20, $20, $59
	db $4f, $53, $48, $49, $41, $4b, $49, $20, $4b, $4f, $49, $5a, $55, $4d, $49, $20
	db $20, $20, $4b, $41, $5a, $55, $41, $4b, $49, $20, $4d, $4f, $52, $49, $54, $41
	db $20, $20, $54, $41, $4b, $41, $4d, $49, $54, $53, $55, $20, $4b, $55, $5a, $55
	db $48, $41, $52, $41, $20, $20, $4d, $41, $53, $41, $4e, $41, $4f, $20, $41, $52
	db $49, $4d, $4f, $54, $4f, $20, $20, $20, $53, $48, $49, $47, $45, $46, $55, $4d
	db $49, $20, $48, $49, $4e, $4f, $20, $20, $20, $20, $20, $4b, $41, $5a, $55, $4d
	db $49, $20, $54, $4f, $54, $41, $4b, $41, $20, $20, $20, $20, $20, $4d, $49, $4e
	db $41, $4b, $4f, $20, $48, $41, $4d, $41, $4e, $4f, $20, $20, $20, $20, $4b, $4f
	db $5a, $55, $45, $20, $49, $53, $48, $49, $4b, $41, $57, $41, $20, $20, $20, $20
	db $59, $4f, $55, $49, $43, $48, $49, $20, $4b, $4f, $54, $41, $42, $45, $20, $20
	db $20, $54, $4f, $53, $48, $49, $48, $49, $4b, $4f, $20, $4e, $41, $4b, $41, $47
	db $4f, $20, $20, $20, $20, $20, $4b, $45, $49, $5a, $4f, $20, $4b, $41, $54, $4f
	db $20, $20, $20, $20, $20, $20, $20, $20, $4b, $4f, $4a, $49, $20, $4b, $4f, $4e
	db $44, $4f, $20, $20, $20, $20, $20, $20, $54, $4f, $4d, $4f, $41, $4b, $49, $20
	db $4b, $55, $52, $4f, $55, $4d, $45, $20, $20, $53, $48, $49, $47, $45, $52, $55
	db $20, $4d, $49, $59, $41, $4d, $4f, $54, $4f, $20, $20, $48, $49, $52, $4f, $53
	db $48, $49, $20, $59, $41, $4d, $41, $55, $43, $48, $49, $20, $20, $20, $20, $20
	db $20, $44, $41, $4e, $20, $4f, $57, $53, $45, $4e, $20, $20, $20, $20, $20, $4d
	db $41, $53, $41, $49, $43, $48, $49, $20, $4f, $4b, $55, $4d, $55, $52, $41, $20
	db $20, $20, $20, $20, $4b, $41, $4e, $41, $45, $20, $57, $41, $44, $41, $20, $20
	db $20, $20, $54, $48, $45, $20, $20, $45, $4e, $44, $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $20

Call_17_42FD::
	ld a, [$d009]
	and a
	ret nz

	call Call_17_44AE
	call Call_17_456D
	ld a, [$d012]
	rst $00

JumpTable_17_430C::
	dw Jump_17_4342
	dw Jump_17_43B1
	dw Jump_17_43F2
	dw Jump_17_4418
	dw Jump_17_446D
	dw Jump_17_4493

	db $00, $01, $02, $02, $03, $03, $04, $04, $05, $05, $05, $06, $0a, $07, $07, $07
	db $07, $07, $08, $09, $0b, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a
	db $0b, $12, $0c, $0e, $0f, $13, $14, $10, $11, $15

Jump_17_4342::
	ld a, [$d008]
	and a
	ret nz

	ld c, $00
	ld a, [$d00a]
	ld e, a
	ld d, $00
	ld hl, $4318
	add hl, de
	ld a, [$d010]
	cp [hl]
	jr nz, jr_017_435a

	inc c

jr_017_435a:
	ld a, c
	ld [$d005], a
	ld a, [hl]
	ld [$d010], a
	ld hl, $432d
	add hl, de
	ld a, [hl]
	ld [$d011], a
	xor a
	ld [$d000], a
	jp Call_17_4413


	db $00, $00, $00, $00, $04, $04, $04, $04, $19, $19, $19, $19, $1e, $1e, $1e, $1e
	db $ff, $ff, $ff, $ff, $af, $af, $af, $af, $5a, $5a, $5a, $5a, $1e, $1e, $1e, $1e
	db $1e, $1e, $1e, $1e, $19, $19, $19, $19, $04, $04, $04, $04, $00, $00, $00, $00
	db $1e, $1e, $1e, $1e, $6f, $6f, $6f, $6f, $bf, $bf, $bf, $bf, $ff, $ff, $ff, $ff

Jump_17_43B1::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_43d3

	ld a, [$d000]
	inc a
	ld [$d000], a
	cp $0c
	jr nz, jr_017_43d3

	ld a, $7c
	ld [$d008], a
	call Call_17_4413
	ld a, [$d00a]
	cp $14
	jr nz, jr_017_43d3

	ld [hl], $04

jr_017_43d3:
	ld a, [$d000]
	ld e, a
	ldh a, [$ffe7]
	and $03
	add e
	ld e, a
	ld d, $00
	ld hl, $4371
	ld a, [$d00a]
	cp $14
	jr nz, jr_017_43ec

	ld hl, $4381

jr_017_43ec:
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_43F2::
	ld a, [$d008]
	and a
	ret nz

	ld c, $00
	ld a, [$d00a]
	inc a
	ld e, a
	ld d, $00
	ld hl, $4318
	add hl, de
	ld a, [$d010]
	cp [hl]
	jr nz, jr_017_440b

	inc c

jr_017_440b:
	ld a, c
	ld [$d005], a
	xor a
	ld [$d000], a

Call_17_4413::
	ld hl, $d012
	inc [hl]
	ret


Jump_17_4418::
	ld a, [$d00a]
	ldh [$ffe4], a
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_4447

	ld a, [$d000]
	inc a
	ld [$d000], a
	cp $0c
	jr nz, jr_017_4447

	ldh a, [$ffe4]
	cp $13
	ld a, $10
	jr c, jr_017_4438

	ld a, $80

jr_017_4438:
	ld [$d008], a
	ld a, $00
	ld [$d012], a
	ld a, [$d00a]
	inc a
	ld [$d00a], a

jr_017_4447:
	ld a, [$d000]
	ld e, a
	ldh a, [$ffe7]
	and $03
	add e
	ld e, a
	ld d, $00
	ld hl, $4391
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ldh a, [$ffe4]
	cp $13
	jr c, jr_017_446c

	ld hl, $43a1
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db99], a

jr_017_446c:
	ret


Jump_17_446D::
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $e0
	ld hl, $c210
	add hl, de
	ld [hl], $10
	ld hl, $c240
	add hl, de
	ld [hl], $08
	ld hl, $c250
	add hl, de
	ld [hl], $08
	ld hl, $c2b0
	add hl, de
	ld [hl], $10
	jp Call_17_4413


Jump_17_4493::
	ret


	db $40, $00, $41, $42, $43, $00, $44, $45, $46, $00, $47, $48, $49, $4a, $4b, $50
	db $00, $51, $52, $53, $54, $55, $2f, $3f, $00, $00

Call_17_44AE::
	ld a, [$d010]
	cp $ff
	ret z

	rla
	and $fe
	ld e, a
	rla
	rla
	rla
	and $f0
	add e
	ld e, a
	ld d, $00
	ld hl, $4099
	add hl, de
	ld de, $c030
	ldh a, [$ffe7]
	and $01
	ld a, $10
	jr z, jr_017_44d3

	inc hl
	ld a, $18

jr_017_44d3:
	ldh [$ffd7], a
	ld c, $09

jr_017_44d7:
	ld a, $40
	ld [de], a
	inc de
	ldh a, [$ffd7]
	ld [de], a
	inc de
	add $10
	ldh [$ffd7], a
	ld a, [hli]
	inc hl
	push hl
	push de
	cp $20
	jr nz, jr_017_44ef

	ld a, $0f
	jr jr_017_44f9

jr_017_44ef:
	sub $41
	ld e, a
	ld d, $00
	ld hl, $4494
	add hl, de
	ld a, [hl]

jr_017_44f9:
	pop de
	pop hl
	ld [de], a
	inc de
	ld a, $10
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_44d7

	ret


	db $20, $30, $21, $31, $22, $22, $23, $33, $24, $34, $24, $35, $22, $32, $36, $30
	db $27, $27, $28, $38, $29, $39, $00, $00, $2a, $3a, $2b, $3b, $20, $20, $21, $35
	db $00, $00, $21, $26, $2c, $3c, $2d, $3d, $36, $20, $00, $00, $2e, $3e, $00, $00
	db $36, $25, $37, $37, $10, $10, $10, $10, $10, $50, $10, $10, $10, $10, $10, $10
	db $10, $10, $50, $10, $10, $50, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $50, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $50, $50, $10, $10
	db $10, $10, $10, $10, $50, $10, $10, $70

Call_17_456D::
	ld a, [$d011]
	rla
	and $fe
	ld e, a
	ld d, $00
	rla
	rl d
	rla
	rl d
	rla
	rl d
	and $f0
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	ld hl, $4171
	add hl, de
	push hl
	xor a
	ldh [$ffd8], a
	ld de, $c054
	ld a, $55
	call Call_17_45A1
	ld hl, $ffd8
	inc [hl]
	pop hl
	ld de, $c078
	ld a, $5d

Call_17_45A1::
	ldh [$ffe9], a
	ld c, $12
	ld b, $08
	ld a, [$d011]
	cp $15
	ld a, $38
	jr z, jr_017_45bf

	ld c, $09
	ld b, $10
	ldh a, [$ffe7]
	and $01
	ld a, $10
	jr z, jr_017_45bf

	inc hl
	ld a, $18

jr_017_45bf:
	ldh [$ffd7], a

jr_017_45c1:
	ldh a, [$ffe9]
	ld [de], a
	inc de
	ldh a, [$ffd7]
	ld [de], a
	inc de
	add b
	ldh [$ffd7], a
	ld a, [$d011]
	cp $15
	ld a, [hli]
	jr z, jr_017_45d5

	inc hl

jr_017_45d5:
	push hl
	push de
	cp $20
	jr nz, jr_017_45df

	ld a, $0f
	jr jr_017_45f6

jr_017_45df:
	sub $41
	sla a
	ld hl, $ffd8
	add [hl]
	ld e, a
	ld d, $00
	ld hl, $4539
	add hl, de
	ld a, [hl]
	ldh [$ffe8], a
	ld hl, $4505
	add hl, de
	ld a, [hl]

jr_017_45f6:
	pop de
	pop hl
	ld [de], a
	inc de
	ldh a, [$ffe8]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_45c1

	ret


Call_17_4602::
	ld a, [$c114]
	inc a
	cp $c0
	jr c, jr_017_460f

	ld a, $0f
	ldh [$fff4], a
	xor a

jr_017_460f:
	ld [$c114], a
	ld a, [$d466]
	and a
	jr nz, jr_017_4626

	ld a, $21
	ldh [$fff2], a
	call Call_27ED
	and $7f
	add $50
	ld [$d466], a

jr_017_4626:
	dec a
	ld [$d466], a
	ret


	db $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93, $92, $93
	db $92, $93, $92, $93, $92, $82, $83, $82, $83, $82, $83, $82, $83, $82, $83, $82
	db $83, $82, $83, $82, $83, $82, $83, $82, $83, $82

Call_17_4655::
	ldh a, [$ffe7]
	and $0f
	cp $02
	jr nz, jr_017_4695

	push de
	ld hl, $d601
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $13
	ld [hli], a
	ld de, $462b
	ldh a, [$ffe7]
	and $10
	jr z, jr_017_4672

	inc de

jr_017_4672:
	ld c, $14

jr_017_4674:
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, jr_017_4674

	pop de
	ld a, d
	ld [hli], a
	ld a, e
	sub $20
	ld [hli], a
	ld a, $13
	ld [hli], a
	ld de, $4640
	ldh a, [$ffe7]
	and $10
	jr z, jr_017_468d

	inc de

jr_017_468d:
	ld c, $14

jr_017_468f:
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, jr_017_468f

	ld [hl], c

jr_017_4695:
	ret


	db $f4, $f4, $f5, $f6, $f7, $f7, $f8, $f8, $f8, $f8, $f7, $f7, $f6, $f5, $f4, $f4

Call_17_46A6::
	ldh a, [$ffe7]
	rra
	rra
	rra
	nop
	and $0f
	ld e, a
	ld d, $00
	ld hl, $4696
	add hl, de
	ld a, [hl]
	sub $05
	ldh [rSCY], a
	ldh [$ffe8], a
	ld a, [$c17f]
	cp $fe
	ret z

	ld a, [$c180]
	inc a
	ld [$c180], a
	ld a, [$d005]
	ldh [$ffd8], a
	ld hl, $c17c
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a

Jump_017_46d5:
jr_017_46d5:
	ldh a, [rSTAT]
	and $03
	jr nz, jr_017_46d5

	ld d, $00

jr_017_46dd:
	ld a, [$c17e]
	inc a
	ld [$c17e], a
	and $01
	jr nz, jr_017_46dd

	ld a, [$c17c]
	add $01
	ld [$c17c], a
	ld a, [$c17d]
	adc $00
	ld [$c17d], a
	ld a, [$c17c]
	cp $50
	jp z, Jump_017_4726

	ld hl, $c180
	ld a, [$c17c]
	add [hl]
	and $1f
	ld hl, $ffd8
	or [hl]
	ld e, a
	ld hl, $472a
	add hl, de
	ld a, [hl]
	push af
	ld hl, $ff96
	add [hl]
	ldh [rSCX], a
	pop af
	sra a
	ld hl, $ffe8
	add [hl]
	ldh [rSCY], a
	jp Jump_017_46d5


Jump_017_4726:
	xor a
	ldh [rSCX], a
	ret


	db $00, $05, $09, $0c, $0d, $0e, $0e, $0f, $0f, $0f, $0e, $0e, $0d, $0c, $09, $05
	db $00, $fb, $f7, $f4, $f3, $f2, $f2, $f1, $f1, $f1, $f2, $f2, $f3, $f4, $f7, $fb
	db $00, $04, $07, $09, $0b, $0c, $0c, $0d, $0d, $0d, $0c, $0c, $0b, $09, $07, $04
	db $00, $fc, $f9, $f7, $f5, $f4, $f4, $f3, $f3, $f3, $f4, $f4, $f5, $f7, $f9, $fc
	db $00, $03, $05, $07, $08, $09, $0a, $0b, $0b, $0b, $0a, $09, $08, $07, $05, $03
	db $00, $fd, $fb, $f9, $f8, $f7, $f6, $f5, $f5, $f5, $f6, $f7, $f8, $f9, $fb, $fd
	db $00, $03, $05, $06, $07, $08, $08, $09, $09, $09, $08, $08, $07, $06, $05, $03
	db $00, $fd, $fb, $fa, $f9, $f8, $f8, $f7, $f7, $f7, $f8, $f8, $f9, $fa, $fb, $fd
	db $00, $02, $04, $05, $05, $06, $06, $07, $07, $07, $06, $06, $05, $05, $04, $02
	db $00, $fe, $fc, $fb, $fb, $fa, $fa, $f9, $f9, $f9, $fa, $fa, $fb, $fb, $fc, $fe
	db $00, $01, $02, $03, $03, $04, $04, $05, $05, $05, $04, $04, $03, $03, $02, $01
	db $00, $ff, $fe, $fd, $fd, $fc, $fc, $fb, $fb, $fb, $fc, $fc, $fd, $fd, $fe, $ff
	db $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $02, $02, $02, $01, $01, $01
	db $00, $ff, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff
	db $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00
	db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00

Call_17_482A::
	ldh a, [$ffcc]
	and $0c
	jr z, jr_017_483a

	ld a, [$0004]
	and a
	jr z, jr_017_483a

	xor a
	ld [$db96], a

jr_017_483a:
	ldh a, [$ffcc]
	and $03
	jr z, jr_017_4849

	ld a, [$0004]
	and a
	jr z, jr_017_4849

	call Call_17_5CC1

jr_017_4849:
	ld a, [$d006]
	and a
	jr z, jr_017_4853

	dec a
	ld [$d006], a

jr_017_4853:
	ld a, [$d007]
	and a
	jr z, jr_017_485d

	dec a
	ld [$d007], a

jr_017_485d:
	ld a, [$d008]
	and a
	jr z, jr_017_4867

	dec a
	ld [$d008], a

jr_017_4867:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_4877

	ld a, [$d009]
	and a
	jr z, jr_017_4877

	dec a
	ld [$d009], a

jr_017_4877:
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_017_4887

	ld a, [$d013]
	and a
	jr z, jr_017_4887

	dec a
	ld [$d013], a

jr_017_4887:
	ld a, [$db96]
	rst $00

JumpTable_17_488B::
	dw Jump_17_493D
	dw Jump_17_4943
	dw Jump_17_49B7
	dw Jump_17_5951
	dw Jump_17_5896
	dw Jump_17_5A70
	dw Jump_17_5F1E
	dw Jump_17_6ABF
	dw Jump_17_6BDE

	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $01, $01, $01, $01, $01, $01, $00, $01, $00, $00, $00, $00, $00
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00
	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00

Jump_17_493D::
	call Call_17_4AEB
	jp Call_17_49B2


Jump_17_4943::
	call Call_0B13
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_495a

	ld a, [$d001]
	inc a
	ld [$d001], a
	cp $0d
	jr nz, jr_017_495a

	jp Jump_017_4979


jr_017_495a:
	ld a, [$d001]
	ld e, a
	ldh a, [$ffe7]
	and $03
	add e
	ld e, a
	ld d, b
	ld hl, $491d
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db99], a
	ld hl, $492d
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ret


Jump_017_4979:
	call Call_297B
	ld hl, $d700
	ld de, $489d
	ld c, $80
	ld a, $01

jr_017_4986:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_017_4986

	call Call_27D2
	ld a, $01
	ldh [rIE], a
	ld a, $00
	ldh [rLYC], a
	ld hl, $d6fd
	res 3, [hl]
	call Call_17_4AEB
	call Call_17_49B2
	ld a, $59
	ld [$d368], a
	ld a, $40
	ld [$d006], a
	ld a, $04
	ld [$c16b], a
	ret


Call_17_49B2::
	ld hl, $db96
	inc [hl]
	ret


Jump_17_49B7::
	ld a, $80
	ld [$db56], a
	xor a
	ld [$dba5], a
	ldh [$fff8], a
	ld a, $01
	ld [$c3c8], a
	ld a, $92
	ldh [$fff6], a
	ld a, $ff
	ld [$dbc7], a
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_49D7::
	dw Jump_17_4A09
	dw Jump_17_4A30
	dw Jump_17_4A8B
	dw Jump_17_4AC7
	dw Jump_17_4B5F
	dw Jump_17_4B8C
	dw Jump_17_4B8D
	dw Jump_17_4B9E
	dw Jump_17_4CBF
	dw Jump_17_4D1B
	dw Jump_17_4D76
	dw Jump_17_4D89
	dw Jump_17_4D93
	dw Jump_17_4DC4
	dw Jump_17_4E47
	dw Jump_17_4E7D
	dw Jump_17_4E92
	dw Jump_17_4EDD
	dw Jump_17_4F5C
	dw Jump_17_4F6F
	dw Jump_17_53CF
	dw Jump_17_540E
	dw Jump_17_577C
	dw Jump_17_5825
	dw Jump_17_5874

Jump_17_4A09::
	ld a, $ff
	ld [$db9a], a
	ld a, $1f
	ld [$d6fe], a
	xor a
	ldh [$ff96], a
	ld [$c155], a
	ld [$c156], a
	ldh [$ff97], a
	ld hl, $c124
	ld e, $00

jr_017_4a23:
	xor a
	ld [hli], a
	inc e
	ld a, e
	cp $0c
	jr nz, jr_017_4a23

Call_17_4A2B::
	ld hl, $d00e
	inc [hl]
	ret


Jump_17_4A30::
	ld a, $16
	ld [$d6ff], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $40
	ld hl, $c210
	add hl, de
	ld [hl], $e0
	ld a, $e8
	call Call_3C01
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld a, $50
	ldh [$ff98], a
	ld a, $98
	ldh [$ff99], a
	jp Call_17_4A2B


	db $00, $00, $00, $00, $01, $01, $01, $01, $16, $16, $16, $16, $27, $27, $27, $27
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
	db $00, $00, $00, $00, $00, $00, $00, $00, $50, $50, $50, $50, $90, $90, $90, $90

Jump_17_4A8B::
	ld a, [$d006]
	ld e, a
	ldh a, [$ffe7]
	and $07
	or e
	jr nz, jr_017_4aa4

	ld a, [$d001]
	inc a
	ld [$d001], a
	cp $0c
	jr nz, jr_017_4aa4

	call Call_17_4A2B

jr_017_4aa4:
	ld a, [$d001]
	ld e, a
	ldh a, [$ffe7]
	and $03
	add e
	ld e, a
	ld d, b
	ld hl, $4a5b
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $4a6b
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $4a7b
	add hl, de
	ld a, [hl]
	ld [$db99], a

Jump_17_4AC7::
	ld a, [$d003]
	add $18
	ld [$d003], a
	jr nc, jr_017_4ad5

	ld hl, $c21e
	inc [hl]

jr_017_4ad5:
	ld a, [$d002]
	add $40
	ld [$d002], a
	jr nc, jr_017_4b16

	ldh a, [$ff97]
	dec a
	ldh [$ff97], a
	cp $90
	jr nz, jr_017_4b16

	call Call_17_4A2B

Call_17_4AEB::
	xor a
	ld [$d000], a
	ld [$d001], a
	ld [$d002], a
	ld [$d003], a
	ld [$d004], a
	ld [$d005], a
	ld [$d00a], a
	ld [$d00b], a
	ld [$d00c], a
	ld [$d00d], a
	ld [$d006], a
	ld [$d007], a
	ld [$d008], a
	ld [$d009], a

jr_017_4b16:
	ret


	db $98, $00, $53, $a0, $98, $20, $53, $a0, $98, $40, $53, $a0, $98, $60, $53, $a0
	db $98, $80, $53, $a0, $98, $a0, $53, $a0, $98, $c0, $53, $a0, $98, $e0, $53, $a0
	db $99, $00, $53, $a0, $99, $20, $53, $a0, $99, $40, $53, $a0, $99, $60, $53, $a0
	db $99, $80, $53, $a0, $99, $a0, $53, $a0, $99, $c0, $53, $a0, $99, $e0, $53, $a0
	db $9a, $00, $53, $a0, $9a, $20, $53, $a0

Jump_17_4B5F::
	ld a, [$d000]
	cp $09
	jr nz, jr_017_4b6d

	ld a, $f0
	ldh [$ff97], a
	jp Call_17_4A2B


jr_017_4b6d:
	ld e, a
	inc a
	ld [$d000], a
	sla e
	sla e
	sla e
	ld d, $00
	ld hl, $4b17
	add hl, de
	ld de, $d601
	ld c, $08

jr_017_4b83:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_4b83

	xor a
	ld [de], a
	ret


Jump_17_4B8C::
	ret


Jump_17_4B8D::
	call Call_17_4AEB
	ld a, $08
	ld [$d006], a
	jp Call_17_4A2B


	db $27, $27, $eb, $ff, $ff, $ff

Jump_17_4B9E::
	ldh a, [$ffe7]
	and $01
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $4b98
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld a, [$d006]
	and a
	jr nz, jr_017_4bce

	ld a, $08
	ld [$d006], a
	ld a, [$d00a]
	inc a
	ld [$d00a], a
	cp $05
	jr nz, jr_017_4bce

	call Call_17_4AEB
	jp Call_17_4A2B


jr_017_4bce:
	ret


	db $9b, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $72, $73, $74
	db $a0, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9b, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $a0, $a0, $a0, $a0, $7b, $7c, $7d, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $98, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $05, $06, $07, $08, $09, $0a
	db $0b, $0c, $0d, $0e, $a0, $a0, $a0, $00, $98, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $a0, $a0, $00
	db $98, $40, $13, $a0, $a0, $a0, $a0, $22, $23, $24, $25, $26, $27, $28, $29, $2a
	db $2b, $2c, $2d, $2e, $2f, $a0, $a0, $00, $98, $60, $13, $a0, $a0, $a0, $31, $32
	db $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $a0, $a0, $00
	db $98, $80, $13, $a0, $a0, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a
	db $4b, $4c, $4d, $4e, $4f, $a0, $a0, $00, $98, $a0, $13, $a0, $a0, $50, $51, $52
	db $53, $54, $55, $56, $57, $58, $59, $a0, $5b, $5c, $5d, $5e, $5f, $a0, $a0, $00
	db $98, $c0, $13, $a0, $a0, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a
	db $a0, $6c, $6d, $6e, $6f, $a0, $a0, $00, $98, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $a0, $75, $76, $77, $78, $79, $7a, $a0, $a0, $a0, $7e, $af, $a0, $a0, $00

Jump_17_4CBF::
	ld a, [$d000]
	cp $0a
	jr nz, jr_017_4ce9

	ld a, $f0
	ldh [$ff97], a
	call Call_17_4AEB
	ld a, $01
	ldh [rIE], a
	ld a, $56
	ldh [rLYC], a
	ld a, $0c
	ld [$d006], a
	ld a, $ff
	ld [$c17f], a
	ld a, $09
	ld [$d00e], a
	ld a, $1f
	ldh [$fff3], a
	ret


jr_017_4ce9:
	ld e, a
	inc a
	ld [$d000], a
	sla e
	sla e
	sla e
	ld a, e
	sla e
	add e
	ld e, a
	ld d, $00
	ld hl, $4bcf
	add hl, de
	ld de, $d601
	ld c, $18

jr_017_4d04:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_4d04

	ret


	db $ff, $ff, $ff, $ff, $bf, $bf, $bf, $bf, $6b, $6b, $6b, $6b, $27, $27, $27, $27

Jump_17_4D1B::
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $4d0b
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld a, [$d006]
	and a
	jr nz, jr_017_4d45

	ld a, [$d00a]
	cp $0c
	jr z, jr_017_4d45

	inc a
	ld [$d00a], a
	ld a, $0c
	ld [$d006], a

jr_017_4d45:
	ld a, [$d00a]
	cp $07
	jr c, jr_017_4d75

	ld a, [$d00b]
	inc a
	ld [$d00b], a
	and $0f
	jr nz, jr_017_4d75

	ld a, [$d005]
	add $20
	ld [$d005], a
	jr nz, jr_017_4d75

	ld a, $fe
	ld [$c17f], a
	call Call_17_4AEB
	ld a, $40
	ld [$d006], a
	ld a, $03
	ldh [rIE], a
	jp Call_17_4A2B


jr_017_4d75:
	ret


Jump_17_4D76::
	ld a, [$d006]
	and a
	jr nz, jr_017_4d88

	call Call_17_4A2B
	ld a, $d0

Call_17_4D81::
	call Call_17_7A8F
	ld a, $17
	ldh [$fff3], a

jr_017_4d88:
	ret


Jump_17_4D89::
	ld a, [$c19f]
	and a
	jr nz, jr_017_4d92

	call Call_17_4A2B

jr_017_4d92:
	ret


Jump_17_4D93::
	ld a, [$c19f]
	and a
	jr nz, jr_017_4db3

	ld a, $01
	ldh [rIE], a
	ld a, $ff
	ld [$c17f], a
	ld a, $e0
	ld [$d005], a
	ld a, $50
	ld [$d006], a
	ld a, $1f
	ldh [$fff3], a
	call Call_17_4A2B

jr_017_4db3:
	ret


	db $27, $27, $27, $27, $6b, $6b, $6b, $6b, $bf, $bf, $bf, $bf, $ff, $ff, $ff, $ff

Jump_17_4DC4::
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $4db4
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld a, [$d005]
	cp $a0
	jr nc, jr_017_4e08

	ld a, [$d006]
	and a
	jr nz, jr_017_4e08

	ld a, $0c
	ld [$d006], a
	ld a, [$d00a]
	inc a
	ld [$d00a], a
	cp $0d
	jr nz, jr_017_4e08

	xor a
	ld [$c17f], a
	call Call_17_4AEB
	ld a, $30
	ld [$d006], a
	ld a, $01
	ldh [rIE], a
	jp Call_17_4A2B


jr_017_4e08:
	ld a, [$d00b]
	inc a
	ld [$d00b], a
	and $0f
	jr nz, jr_017_4e1e

	ld a, [$d005]
	and a
	jr z, jr_017_4e1e

	sub $20
	ld [$d005], a

jr_017_4e1e:
	ret


	db $9b, $c0, $53, $a0, $9b, $e0, $53, $a0, $98, $00, $53, $a0, $98, $20, $53, $a0
	db $98, $40, $53, $a0, $98, $60, $53, $a0, $98, $80, $53, $a0, $98, $a0, $53, $a0
	db $98, $c0, $53, $a0, $98, $e0, $53, $a0

Jump_17_4E47::
	ld a, [$d006]
	and a
	ret nz

	ld a, [$d000]
	cp $0a
	jr nz, jr_017_4e60

	ld a, $d2
	call Call_17_4D81
	ld a, $27
	ld [$db97], a
	jp Call_17_4A2B


jr_017_4e60:
	ld e, a
	inc a
	ld [$d000], a
	sla e
	sla e
	ld d, $00
	ld hl, $4e1f
	add hl, de
	ld de, $d601
	ld c, $04

jr_017_4e74:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_4e74

	xor a
	ld [de], a
	ret


Jump_17_4E7D::
	ld a, [$c19f]
	and a
	jr nz, jr_017_4e91

	call Call_17_4AEB
	ld a, $03
	ldh [$ff9d], a
	ld a, $0c
	ldh [$ffa5], a
	call Call_17_4A2B

jr_017_4e91:
	ret


Jump_17_4E92::
	ld a, [$d000]
	cp $07
	jr nz, jr_017_4ea4

	call Call_17_4AEB
	ld a, $80
	ld [$d006], a
	jp Call_17_4A2B


jr_017_4ea4:
	inc a
	ld [$d000], a
	ld a, $0c
	ldh [$ffa5], a
	ret


	db $48, $58, $60, $60, $58, $48, $40, $40, $40, $40, $48, $58, $60, $60, $58, $48
	db $ff, $01, $02, $02, $01, $ff, $fe, $fe, $fe, $fe, $ff, $01, $02, $02, $01, $ff
	db $00, $01, $02, $03, $04, $05, $06, $07, $00, $08, $10, $18, $20, $28, $30, $38

Jump_17_4EDD::
	ld a, [$d006]
	and a
	jr nz, jr_017_4f5b

	ld a, $04
	ldh [$ff9d], a
	ld a, $3f
	ld [$d368], a

jr_017_4eec:
	ld a, $e8
	call Call_3C01
	ld a, [$d000]
	ld c, a
	ld b, $00
	ld hl, $4ead
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4eb5
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	sub $20
	ld [hl], a
	ld hl, $4ebd
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $4ec5
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	ld hl, $4ecd
	add hl, bc
	ld a, [hl]
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $4ed5
	add hl, bc
	ld a, [hl]
	ld hl, $c2c0
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $03
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c450
	add hl, de
	ld [hl], $20
	ld a, c
	inc a
	ld [$d000], a
	cp $08
	jr nz, jr_017_4eec

	call Call_17_4AEB
	ld a, $a0
	ld [$d006], a
	call Call_17_4A2B

jr_017_4f5b:
	ret


Jump_17_4F5C::
	ld a, [$d006]
	cp $9e
	jr nz, jr_017_4f68

	ld hl, $fff2
	ld [hl], $34

jr_017_4f68:
	and a
	jr nz, jr_017_4f6e

	call Call_17_4A2B

jr_017_4f6e:
	ret


Jump_17_4F6F::
	ld a, [$d000]
	rst $00

JumpTable_17_4F73::
	dw Jump_17_4FD7
	dw Jump_17_502A
	dw Jump_17_507F
	dw Jump_17_5094
	dw Jump_17_50E1
	dw Jump_17_50EF
	dw Jump_17_513C
	dw Jump_17_514A
	dw Jump_17_5175
	dw Jump_17_5183
	dw Jump_17_51F2
	dw Jump_17_5200
	dw Jump_17_521A
	dw Jump_17_5222
	dw Jump_17_5235
	dw Jump_17_5262
	dw Jump_17_535C
	dw Jump_17_53BF

Jump_017_4f97:
	ld hl, $d000
	inc [hl]
	ret


Call_17_4F9C::
	ld e, $10
	ld hl, $c280
	xor a

jr_017_4fa2:
	ld [hli], a
	dec e
	jr nz, jr_017_4fa2

	ret


	db $ff, $ff, $ff, $ff, $aa, $aa, $aa, $aa, $55, $55, $55, $55, $00, $00, $00, $00
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00
	db $90, $90, $90, $90, $50, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00

Jump_17_4FD7::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_4ff6

	ld a, [$d00a]
	inc a
	ld [$d00a], a
	cp $0c
	jr nz, jr_017_4ff6

	ld a, $1d
	ld [$d6fe], a
	xor a
	ldh [$ff97], a
	call Call_17_4F9C
	jp Jump_017_4f97


jr_017_4ff6:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $4fa7
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $4fb7
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $4fc7
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_017_501b:
	ldh a, [$ffe7]
	ld e, $01
	and $04
	jr z, jr_017_5025

	ld e, $fe

jr_017_5025:
	ld hl, $c155
	ld [hl], e
	ret


Jump_17_502A::
	xor a
	ld [$d00a], a
	ld a, $20
	ld [$d6ff], a
	ld a, $6d
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $48
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld a, $6f
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $68
	ld hl, $c210
	add hl, de
	ld [hl], $30
	ld a, $78
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $2c
	ld hl, $c210
	add hl, de
	ld [hl], $58
	ld a, $78
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $60
	ld hl, $c210
	add hl, de
	ld [hl], $52
	ld hl, $c2b0
	add hl, de
	inc [hl]
	jp Jump_017_4f97


Jump_17_507F::
	call Call_17_529A
	jr nz, jr_017_508c

	ld a, $50
	ld [$d006], a
	jp Jump_017_4f97


jr_017_508c:
	ret


Call_17_508D::
	ldh a, [$ffcb]
	and $30
	ret nz

	nop
	ret


Jump_17_5094::
	ld a, [$d006]
	and a
	jr nz, jr_017_50e0

	call Call_17_508D
	call Call_17_5304
	jr nz, jr_017_50e0

	ld a, $1e
	ld [$d6ff], a
	call Call_17_4F9C
	ld a, $71
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $48
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld hl, $c290
	add hl, de
	inc [hl]
	ld hl, $c2e0
	add hl, de
	ld [hl], $20
	ld hl, $c380
	add hl, de
	ld [hl], $02
	ld a, $72
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $50
	jp Jump_017_4f97


jr_017_50e0:
	ret


Jump_17_50E1::
	call Call_17_529A
	jr nz, jr_017_50ee

	ld a, $50
	ld [$d006], a
	jp Jump_017_4f97


jr_017_50ee:
	ret


Jump_17_50EF::
	ld a, [$d006]
	and a
	jr nz, jr_017_513b

	call Call_17_508D
	call Call_17_5304
	jr nz, jr_017_513b

	ld a, $22
	ld [$d6ff], a
	call Call_17_4F9C
	ld a, $c5
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $40
	ld a, $09
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $48
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld a, $09
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $68
	ld hl, $c210
	add hl, de
	ld [hl], $60
	jp Jump_017_4f97


jr_017_513b:
	ret


Jump_17_513C::
	call Call_17_529A
	jr nz, jr_017_5149

	ld a, $50
	ld [$d006], a
	jp Jump_017_4f97


jr_017_5149:
	ret


Jump_17_514A::
	ld a, [$d006]
	and a
	jr nz, jr_017_5174

	call Call_17_508D
	call Call_17_5304
	jr nz, jr_017_5174

	ld a, $21
	ld [$d6ff], a
	call Call_17_4F9C
	ld a, $3f
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $50
	jp Jump_017_4f97


jr_017_5174:
	ret


Jump_17_5175::
	call Call_17_529A
	jr nz, jr_017_5182

	ld a, $50
	ld [$d006], a
	jp Jump_017_4f97


jr_017_5182:
	ret


Jump_17_5183::
	ld a, [$d006]
	and a
	jr nz, jr_017_51f1

	call Call_17_508D
	call Call_17_5304
	jr nz, jr_017_51f1

	ld a, $1f
	ld [$d6ff], a
	call Call_17_4F9C
	ld a, $3e
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld a, $6e
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $18
	ld hl, $c210
	add hl, de
	ld [hl], $4c
	ld a, $6e
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $38
	ld hl, $c210
	add hl, de
	ld [hl], $54
	ld a, $6e
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $30
	ld a, $6f
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $60
	jp Jump_017_4f97


jr_017_51f1:
	ret


Jump_17_51F2::
	call Call_17_529A
	jr nz, jr_017_51ff

	ld a, $c0
	ld [$d006], a
	jp Jump_017_4f97


jr_017_51ff:
	ret


Jump_17_5200::
	ld a, [$d006]
	and a
	jr nz, jr_017_5219

	call Call_17_508D
	call Call_17_5304
	jr nz, jr_017_5219

	ld a, $1e
	ld [$d6fe], a
	call Call_17_4F9C
	jp Jump_017_4f97


jr_017_5219:
	ret


Jump_17_521A::
	ld a, $01
	ld [$d6ff], a
	jp Jump_017_4f97


Jump_17_5222::
	call Call_17_52C1
	jr nz, jr_017_5234

	ld a, $a0
	ld [$d006], a
	ld a, $ff
	ld [$d00b], a
	jp Jump_017_4f97


jr_017_5234:
	ret


Jump_17_5235::
	ld a, [$d006]
	cp $01
	jr nz, jr_017_5241

	ld hl, $fff4
	ld [hl], $35

jr_017_5241:
	and a
	jr nz, jr_017_5279

	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_5279

	ld a, [$d00b]
	cp $3f
	jr z, jr_017_525a

	inc a
	ld [$d00b], a
	ld a, $0e
	ldh [$ffa5], a
	ret


jr_017_525a:
	ld a, $40
	ld [$d006], a
	jp Jump_017_4f97


Jump_17_5262::
	ld a, [$d006]
	and a
	ret nz

	xor a
	ld [$db97], a
	ld [$db98], a
	ld [$db99], a
	ld a, $15
	ld [$d6fe], a
	jp Jump_017_4f97


jr_017_5279:
	ret


	db $00, $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c

Call_17_529A::
	ldh a, [$ffe7]
	and $01
	jr nz, jr_017_52a7

	ld a, [$d00a]
	inc a
	ld [$d00a], a

jr_017_52a7:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $527a
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $528a
	jp Jump_017_5328


Call_17_52C1::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_52ce

	ld a, [$d00a]
	inc a
	ld [$d00a], a

jr_017_52ce:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $6c3c
	add hl, de
	ld a, [hl]
	ld [$db97], a
	jr jr_017_532d

	db $e4, $e4, $e4, $e4, $94, $94, $94, $94, $40, $40, $40, $40, $00, $00, $00, $00
	db $1c, $1c, $1c, $1c, $18, $18, $18, $18, $04, $04, $04, $04, $00, $00, $00, $00

Call_17_5304::
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_017_5311

	ld a, [$d00a]
	inc a
	ld [$d00a], a

jr_017_5311:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $52e4
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $52f4

Jump_017_5328:
	add hl, de
	ld a, [hl]
	ld [$db98], a

jr_017_532d:
	ld a, [$d00a]
	cp $0c
	jr nz, jr_017_5338

	xor a
	ld [$d00a], a

jr_017_5338:
	ret


	db $f0, $e7, $e6, $07, $20, $07, $fa, $0a, $d0, $3c, $ea, $0a, $d0, $f0, $e7, $e6
	db $03, $5f, $fa, $0a, $d0, $83, $5f, $16, $00, $21, $53, $5c, $19, $7e, $ea, $97
	db $db, $18, $d1

Jump_17_535C::
	ld a, $c9
	ld [$db97], a
	ld a, $1c
	ld [$db98], a
	ld a, $90
	ld [$db99], a
	ld a, [$d006]
	and a
	jp nz, Jump_017_501b

	ld a, $00
	ld [$c155], a
	ld a, $00
	ldh [$ff9d], a
	ld a, $15
	ld [$d6fe], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $40
	ld hl, $c210
	add hl, de
	ld [hl], $60
	ld hl, $c290
	add hl, de
	ld [hl], $02
	ld a, $e8
	call Call_3C01
	ld hl, $c2b0
	add hl, de
	inc [hl]
	ld a, $50
	ldh [$ff98], a
	ld hl, $d6fd
	set 3, [hl]
	ld a, $a0
	ld [$d006], a
	ld a, $ff
	ld [$db97], a
	ld a, $5c
	ldh [$ff99], a
	ld a, $34
	ldh [$fff4], a
	jp Jump_017_4f97


Jump_17_53BF::
	ld a, [$d006]
	and a
	jp nz, Jump_017_501b

	ld [$c155], a
	call Call_17_4AEB
	jp Call_17_4A2B


Jump_17_53CF::
	ldh a, [$ff99]
	sub $02
	ldh [$ff99], a
	ldh a, [$ff97]
	add $08
	ldh [$ff97], a
	cp $60
	jr nz, jr_017_53ee

	ld a, [$c29f]
	inc a
	ld [$c29f], a
	ld a, $40
	ld [$d009], a
	call Call_17_4A2B

jr_017_53ee:
	call Call_17_543D
	ret


	db $43, $13, $07, $83, $23, $0b, $53, $17, $47, $27, $4b, $93, $60, $60, $61, $62
	db $63, $64, $65, $65, $65, $65, $64, $63, $62, $61, $60, $60

Jump_17_540E::
	call Call_17_543D
	ld a, [$d009]
	and a
	jr nz, jr_017_541a

	jp Call_17_4A2B


jr_017_541a:
	ld a, [$c21e]
	add $08
	ld [$c21e], a
	ld a, [$d00a]
	inc a
	ld [$d00a], a
	rra
	rra
	rra
	nop
	and $0f
	ld e, a
	ld d, $00
	ld hl, $53fe
	add hl, de
	ld a, [hl]
	ldh [$ff97], a
	call Call_17_5471
	ret


Call_17_543D::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $07
	add $05
	ldh [$ff9d], a
	ld a, [$d006]
	and a
	jr nz, jr_017_5462

	ld a, $03
	ld [$d006], a
	ld a, [$d000]
	inc a
	ld [$d000], a
	cp $03
	jr nz, jr_017_5462

	xor a
	ld [$d000], a

jr_017_5462:
	ld a, [$d000]
	ld e, a
	ld d, $00
	ld hl, $53fb
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ret


Call_17_5471::
	ldh a, [$ff97]
	cpl
	inc a
	sub $a0
	add $3c
	ldh [$ff99], a
	ret


	db $9c, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9c, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9c, $60, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9c, $a0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9c, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9c, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9d, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9d, $60, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9d, $a0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9d, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9d, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9e, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9e, $60, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9e, $a0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9e, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9e, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $00, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9f, $20, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $40, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9f, $60, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $80, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9f, $a0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00
	db $9f, $c0, $13, $a0, $a0, $a0, $a0, $a0, $a0, $80, $81, $80, $81, $80, $81, $80
	db $81, $a0, $a0, $a0, $a0, $a0, $a0, $00, $9f, $e0, $13, $a0, $a0, $a0, $a0, $a0
	db $a0, $90, $91, $90, $91, $90, $91, $90, $91, $a0, $a0, $a0, $a0, $a0, $a0, $00

Jump_17_577C::
	call Call_17_543D
	ld a, [$c21e]
	add $04
	ld [$c21e], a
	ld a, [$d00b]
	inc a
	ld [$d00b], a
	and $07
	jr nz, jr_017_579d

	ld a, [$d00c]
	cp $08
	jr z, jr_017_579d

	inc a
	ld [$d00c], a

jr_017_579d:
	ld a, [$d00c]
	ld e, a
	ldh a, [$ff97]
	add e
	ldh [$ff97], a
	call Call_17_5471
	ldh a, [$ff99]
	cp $f0
	jr c, jr_017_57b3

	xor a
	ld [$c28f], a

jr_017_57b3:
	ld a, [$d00b]
	and $01
	ret nz

	ld a, [$d001]
	cp $20
	jr nz, jr_017_57c7

	call Call_17_4AEB
	call Call_17_4A2B
	ret


jr_017_57c7:
	ld e, a
	inc a
	ld [$d001], a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld a, e
	sla e
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	ld hl, $547c
	add hl, de
	ld de, $d601
	ld c, $18

jr_017_57ee:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_57ee

	ret


	db $27, $27, $27, $27, $16, $16, $16, $16, $01, $01, $01, $01, $00, $00, $00, $00
	db $1c, $1c, $1c, $1c, $1c, $1c, $18, $18, $08, $08, $08, $08, $00, $00, $00, $00
	db $90, $90, $90, $90, $50, $50, $50, $50, $00, $00, $00, $00, $00, $00, $00, $00

Jump_17_5825::
	ld a, [$c21e]
	add $02
	ld [$c21e], a
	ldh a, [$ff97]
	add $04
	ldh [$ff97], a
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_584f

	ld a, [$d00a]
	cp $0c
	jr nz, jr_017_584b

	call Call_17_4AEB
	ld a, $c0
	ld [$d006], a
	jp Call_17_4A2B


jr_017_584b:
	inc a
	ld [$d00a], a

jr_017_584f:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $57f5
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $5805
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $5815
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_5874::
	ld a, [$d006]
	and a
	jr nz, jr_017_5895

	xor a
	ld [$d00e], a
	ld [$c28e], a
	ld [$c28f], a
	ld [$c114], a
	ld a, $80
	ld [$d466], a
	ld hl, $d6fd
	res 3, [hl]
	ld hl, $db96
	inc [hl]

jr_017_5895:
	ret


Jump_17_5896::
	call Call_17_4602
	ld de, $98e0
	call Call_17_4655
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_58A6::
	dw Jump_17_58AE
	dw Jump_17_58B9
	dw Jump_17_592B
	dw Jump_17_5936

Jump_17_58AE::
	ld a, $16
	ld [$d6fe], a
	call Call_17_4AEB
	jp Call_17_4A2B


Jump_17_58B9::
	ld a, $17
	ld [$d6ff], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $48
	ld hl, $c210
	add hl, de
	ld [hl], $60
	ld hl, $c2b0
	add hl, de
	ld [hl], $04
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $28
	ld hl, $c210
	add hl, de
	ld [hl], $68
	ld hl, $c2b0
	add hl, de
	ld [hl], $05
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $60
	ld hl, $c2b0
	add hl, de
	ld [hl], $05
	ld hl, $c3b0
	add hl, de
	inc [hl]
	jp Call_17_4A2B


	db $00, $00, $00, $00, $05, $05, $05, $05, $19, $19, $1a, $1a, $1e, $1e, $1e, $1e
	db $00, $00, $00, $00, $00, $01, $01, $01, $51, $51, $52, $52, $92, $92, $92, $92

Jump_17_592B::
	call Call_17_4AEB
	ld a, $60
	ld [$d009], a
	jp Call_17_4A2B


Jump_17_5936::
	ld a, [$d009]
	and a
	jr nz, jr_017_5950

	xor a
	ld [$d00e], a
	ld [$c28c], a
	ld [$c28d], a
	ld [$c28e], a
	ld [$c28f], a
	ld hl, $db96
	inc [hl]

jr_017_5950:
	ret


Jump_17_5951::
	call Call_17_4602
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_595B::
	dw Jump_17_5965
	dw Jump_17_5980
	dw Jump_17_5A0D
	dw Jump_17_5A4E
	dw Jump_17_5A5B

Jump_17_5965::
	ld a, $17
	ld [$d6fe], a
	xor a
	ldh [$ff96], a
	ldh [$ff97], a
	ld [$c155], a
	ld [$c156], a
	ld a, $3d
	ld [$d368], a
	call Call_17_4AEB
	jp Call_17_4A2B


Jump_17_5980::
	ld a, $18
	ld [$d6ff], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $18
	ld hl, $c210
	add hl, de
	ld [hl], $20
	ld hl, $c2b0
	add hl, de
	ld [hl], $06
	ld hl, $c240
	add hl, de
	ld [hl], $03
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $78
	ld hl, $c2b0
	add hl, de
	ld [hl], $06
	ld hl, $c240
	add hl, de
	ld [hl], $fd
	ld hl, $c3b0
	add hl, de
	ld [hl], $03
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $68
	ld hl, $c210
	add hl, de
	ld [hl], $60
	ld hl, $c2b0
	add hl, de
	ld [hl], $07
	ld a, $60
	ld [$d009], a
	jp Call_17_4A2B


	db $00, $00, $00, $00, $05, $05, $05, $05, $05, $05, $05, $05, $19, $19, $1a, $1a
	db $1e, $1e, $1e, $1e, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01
	db $51, $51, $51, $52, $52, $92, $92, $92, $92

Jump_17_5A0D::
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_017_5a29

	ld a, [$d00a]
	cp $10
	jr nz, jr_017_5a25

	call Call_17_4AEB
	ld a, $60
	ld [$d009], a
	jp Call_17_4A2B


jr_017_5a25:
	inc a
	ld [$d00a], a

jr_017_5a29:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $59e4
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $59e4
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $59f8
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_5A4E::
	ld a, [$d009]
	and a
	jr nz, jr_017_5a5a

	call Call_17_4AEB
	jp Call_17_4A2B


jr_017_5a5a:
	ret


Jump_17_5A5B::
	call Call_17_4AEB
	xor a
	ld [$d00e], a
	ld [$c28d], a
	ld [$c28e], a
	ld [$c28f], a
	ld hl, $db96
	inc [hl]
	ret


Jump_17_5A70::
	call Call_17_4602
	ld de, $98e0
	call Call_17_4655
	call Call_0B13
	ld a, [$d00f]
	inc a
	ld [$d00f], a
	cp $05
	jr c, jr_017_5a97

	xor a
	ld [$d00f], a
	ld a, [$d00a]
	inc a
	cp $2b
	jr nz, jr_017_5a94

	xor a

jr_017_5a94:
	ld [$d00a], a

jr_017_5a97:
	ld a, [$d00a]
	ld e, a
	ld d, $00
	ld hl, $5b49
	add hl, de
	ld a, [hl]
	add $00
	ld [$d000], a
	ld a, [$d00e]
	rst $00

JumpTable_17_5AAB::
	dw Jump_17_5AB5
	dw Jump_17_5ABD
	dw Jump_17_5BB9
	dw Jump_17_5C73
	dw Jump_17_5CBB

Jump_17_5AB5::
	ld a, $18
	ld [$d6fe], a
	jp Call_17_4A2B


Jump_17_5ABD::
	ld a, $19
	ld [$d6ff], a
	ld hl, $ffff
	set 1, [hl]
	ld a, $42
	ldh [rLYC], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $18
	ld hl, $c210
	add hl, de
	ld [hl], $55
	ld hl, $c2b0
	add hl, de
	ld [hl], $08
	ld hl, $c3b0
	add hl, de
	ld [hl], $02
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $68
	ld hl, $c210
	add hl, de
	ld [hl], $58
	ld hl, $c2b0
	add hl, de
	ld [hl], $08
	ld hl, $c3b0
	add hl, de
	inc [hl]
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $88
	ld hl, $c210
	add hl, de
	ld [hl], $60
	ld hl, $c2b0
	add hl, de
	ld [hl], $08
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $08
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld hl, $c2b0
	add hl, de
	ld [hl], $09
	ld hl, $c240
	add hl, de
	ld [hl], $08
	ld hl, $c250
	add hl, de
	ld [hl], $f8
	call Call_17_4AEB
	ld a, $50
	ld [$d009], a
	jp Call_17_4A2B


	db $00, $00, $00, $00, $01, $01, $01, $02, $02, $03, $03, $04, $05, $06, $07, $08
	db $09, $0a, $0a, $0b, $0b, $0c, $0c, $0c, $0b, $0b, $0a, $0a, $09, $08, $07, $06
	db $05, $04, $03, $03, $02, $02, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00
	db $0d, $4c, $4d, $4e, $4f, $4c, $4d, $4e, $4f, $4c, $4d, $4e, $4f, $4c, $4d, $00
	db $0d, $5c, $5d, $5e, $5f, $5c, $5d, $5e, $5f, $5c, $5d, $5e, $5f, $5c, $5d, $00
	db $0d, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $6e, $6f, $6c, $6d, $00
	db $0d, $7c, $7d, $7e, $7f, $7c, $7d, $7e, $7f, $7c, $7d, $7e, $7f, $7c, $7d, $00

Jump_17_5BB9::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_5beb

	ld hl, $d601
	ld a, $9a
	ld [hli], a
	ld a, $23
	ld [hli], a
	ld a, [$d00b]
	inc a
	and $03
	ld [$d00b], a
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, $00
	ld hl, $5b79
	add hl, de
	ld de, $d603
	ld c, $10

jr_017_5be3:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_5be3

	jr jr_017_5bee

jr_017_5beb:
	call Call_17_5EF9

jr_017_5bee:
	ld a, [$d001]
	rst $00

JumpTable_17_5BF2::
	dw Jump_17_5BF8
	dw Jump_17_5C1B
	dw Jump_17_5C44

Jump_17_5BF8::
	ld a, [$d009]
	and a
	jr nz, jr_017_5c02

Jump_017_5bfe:
	ld hl, $d001
	inc [hl]

jr_017_5c02:
	ret


	db $01, $00, $01, $02, $01, $02, $03, $04, $05, $06, $07, $08, $20, $18, $20, $18
	db $18, $18, $20, $40, $0c, $0c, $0c, $40

Jump_17_5C1B::
	ld a, [$d006]
	and a
	jr nz, jr_017_5c43

	ld a, [$d00d]
	ld e, a
	ld d, $00
	ld hl, $5c03
	add hl, de
	ld a, [hl]
	ld [$d002], a
	ld hl, $5c0f
	add hl, de
	ld a, [hl]
	ld [$d006], a
	ld a, e
	inc a
	ld [$d00d], a
	cp $0c
	jr nz, jr_017_5c43

	jp Jump_017_5bfe


jr_017_5c43:
	ret


Jump_17_5C44::
	ld a, [$d006]
	and a
	jr nz, jr_017_5c52

	xor a
	ld [$d005], a
	call Call_17_4A2B
	ret


jr_017_5c52:
	ret


	db $1e, $1e, $1e, $1e, $1a, $1a, $19, $19, $05, $05, $05, $05, $00, $00, $00, $00
	db $92, $92, $92, $92, $92, $92, $51, $51, $41, $41, $00, $00, $00, $00, $00, $00

Jump_17_5C73::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_5c96

	ld a, [$d005]
	cp $0c
	jr nz, jr_017_5c92

	ld a, $c0
	ld [$d006], a
	xor a
	ld [$db97], a
	ld [$db98], a
	ld [$db99], a
	jp Call_17_4A2B


jr_017_5c92:
	inc a
	ld [$d005], a

jr_017_5c96:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d005]
	add e
	ld e, a
	ld d, $00
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $5c63
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_5CBB::
	ld a, [$d006]
	and a
	jr nz, jr_017_5d00

Call_17_5CC1::
	xor a
	ld [$d00e], a
	ld [$c287], a
	ld [$c288], a
	ld [$c289], a
	ld [$c28a], a
	ld [$c28b], a
	ld [$c28c], a
	ld [$c28d], a
	ld [$c28e], a
	ld [$c28f], a
	ldh [$ff97], a
	ld [$d00f], a
	ld [$d00f], a
	call Call_17_4AEB
	ld hl, $ffff
	res 1, [hl]
	ld hl, $d6fd
	set 2, [hl]
	ld hl, $db96
	inc [hl]
	ld a, [hl]
	cp $09
	jr nz, jr_017_5d00

	ld [hl], $00

jr_017_5d00:
	ret


	db $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac, $99, $66, $05, $ac, $ac, $86, $87
	db $88, $89, $99, $86, $05, $94, $95, $96, $97, $98, $99, $99, $a6, $05, $a4, $a5
	db $a6, $a7, $a8, $a9, $99, $c6, $05, $b4, $b5, $b6, $b7, $b8, $b9, $99, $e6, $05
	db $c4, $c5, $c6, $c7, $c8, $c9, $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac, $99
	db $66, $05, $ac, $ac, $86, $87, $88, $89, $99, $86, $05, $94, $95, $96, $97, $98
	db $99, $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9, $99, $c6, $05, $b4, $b5, $8a
	db $8b, $b8, $b9, $99, $e6, $05, $c4, $c5, $9a, $9b, $c8, $c9, $99, $46, $05, $ac
	db $ac, $ac, $ac, $ac, $ac, $99, $66, $05, $ac, $ac, $86, $87, $88, $89, $99, $86
	db $05, $94, $95, $96, $97, $98, $99, $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9
	db $99, $c6, $05, $b4, $b5, $8c, $8d, $b8, $b9, $99, $e6, $05, $c4, $c5, $9c, $c7
	db $c8, $c9, $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac, $99, $66, $05, $ac, $ac
	db $86, $87, $88, $89, $99, $86, $05, $94, $95, $96, $97, $98, $99, $99, $a6, $05
	db $a4, $a5, $a6, $a7, $a8, $a9, $99, $c6, $05, $b4, $b5, $8e, $8f, $b8, $b9, $99
	db $e6, $05, $c4, $c5, $9e, $c7, $c8, $c9, $99, $46, $05, $ac, $ac, $ac, $ac, $ac
	db $ac, $99, $66, $05, $ac, $ac, $86, $87, $88, $89, $99, $86, $05, $94, $95, $96
	db $97, $98, $99, $99, $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9, $99, $c6, $05, $b4
	db $b5, $e9, $ea, $b8, $b9, $99, $e6, $05, $c4, $c5, $f9, $c7, $c8, $c9, $99, $46
	db $05, $ac, $ac, $ac, $ac, $ac, $ac, $99, $66, $05, $ac, $ac, $86, $87, $88, $89
	db $99, $86, $05, $94, $95, $96, $97, $98, $99, $99, $a6, $05, $a4, $a5, $a6, $a7
	db $a8, $a9, $99, $c6, $05, $b4, $b5, $eb, $ec, $b8, $b9, $99, $e6, $05, $c4, $c5
	db $fb, $c7, $c8, $c9, $99, $46, $05, $ac, $ac, $ac, $ac, $ac, $ac, $99, $66, $05
	db $ac, $ac, $86, $87, $88, $89, $99, $86, $05, $94, $95, $96, $97, $98, $99, $99
	db $a6, $05, $a4, $a5, $a6, $a7, $a8, $a9, $99, $c6, $05, $b4, $b5, $ed, $ee, $b8
	db $b9, $99, $e6, $05, $c4, $c5, $fb, $c7, $c8, $c9, $99, $46, $05, $ac, $ac, $ac
	db $ac, $ac, $ac, $99, $66, $05, $00, $01, $02, $03, $04, $ac, $99, $86, $05, $10
	db $11, $12, $13, $14, $15, $99, $a6, $05, $20, $21, $22, $23, $24, $25, $99, $c6
	db $05, $30, $31, $32, $33, $34, $35, $99, $e6, $05, $40, $41, $42, $43, $44, $c9
	db $99, $46, $05, $0c, $0d, $1c, $1d, $ac, $ac, $99, $66, $05, $06, $07, $08, $09
	db $0a, $ac, $99, $86, $05, $16, $17, $18, $19, $1a, $1b, $99, $a6, $05, $26, $27
	db $28, $29, $2a, $2b, $99, $c6, $05, $36, $37, $38, $39, $3a, $3b, $99, $e6, $05
	db $46, $47, $48, $49, $4a, $c9, $01, $5d, $37, $5d, $6d, $5d, $a3, $5d, $d9, $5d
	db $0f, $5e, $45, $5e, $7b, $5e, $b1, $5e

Call_17_5EF9::
	ldh a, [$ffe7]
	and $01
	cp $01
	jr nz, jr_017_5f1d

	ld a, [$d002]
	sla a
	ld e, a
	ld d, $00
	ld hl, $5ee7
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $d601
	ld c, $36

jr_017_5f15:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_5f15

	xor a
	ld [de], a

jr_017_5f1d:
	ret


Jump_17_5F1E::
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_5F25::
	dw Jump_17_5F37
	dw Jump_17_5F3F
	dw Jump_17_5F5E
	dw Jump_17_5FA8
	dw Jump_17_5FC7
	dw Jump_17_5FFE
	dw Jump_17_6023
	dw Jump_17_698B
	dw Jump_17_6A5B

Jump_17_5F37::
	ld a, $19
	ld [$d6fe], a
	jp Call_17_4A2B


Jump_17_5F3F::
	ld a, $1a
	ld [$d6ff], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $40
	ld hl, $c210
	add hl, de
	ld [hl], $4e
	ld hl, $c2b0
	add hl, de
	ld [hl], $0a
	jp Call_17_4A2B


Jump_17_5F5E::
	ld de, $9960
	call Call_17_4655
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_5f80

	ld a, [$d00a]
	cp $0c
	jr nz, jr_017_5f7c

	call Call_17_4AEB
	ld a, $60
	ld [$d009], a
	jp Call_17_4A2B


jr_017_5f7c:
	inc a
	ld [$d00a], a

jr_017_5f80:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $590b
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db98], a
	ld hl, $590b
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $591b
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_5FA8::
	ld de, $9960
	call Call_17_4655
	ld a, [$d009]
	and a
	jr nz, jr_017_5fba

	call Call_17_4AEB
	jp Call_17_4A2B


jr_017_5fba:
	ret


	db $1e, $1e, $1e, $1e, $2e, $2e, $2e, $2e, $6e, $6e, $6e, $6e

Jump_17_5FC7::
	ld de, $9960
	call Call_17_4655
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_5fe9

	ld a, [$d00a]
	cp $08
	jr nz, jr_017_5fe5

	call Call_17_4AEB
	ld a, $20
	ld [$d006], a
	jp Call_17_4A2B


jr_017_5fe5:
	inc a
	ld [$d00a], a

jr_017_5fe9:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $5fbb
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ret


Jump_17_5FFE::
	ld de, $9960
	call Call_17_4655
	ld a, [$d006]
	and a
	jr nz, jr_017_6022

	ld a, $0a
	ld [$d006], a
	ld a, [$d000]
	inc a
	ld [$d000], a
	cp $02
	jr nz, jr_017_6022

	ld a, $20
	ld [$d006], a
	jp Call_17_4A2B


jr_017_6022:
	ret


Jump_17_6023::
	ld de, $9960
	call Call_17_4655
	ld a, [$d006]
	and a
	jr nz, jr_017_6032

	jp Call_17_4A2B


jr_017_6032:
	ret


	db $9b, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $60, $61, $62, $63, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $50, $51, $52, $53, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $60, $61, $62, $63, $ac, $ac, $ac, $00, $9a, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $50, $51, $52, $53, $ac, $ac, $ac, $00
	db $9a, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $60, $61, $00, $9a, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $50, $51, $00
	db $9a, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $00, $13, $6b, $6c, $6d, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $e0, $13, $5b, $5c, $5d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $68
	db $69, $6a, $6b, $6c, $6d, $ac, $ac, $00, $99, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $58, $59, $5a, $5b, $5c, $5d, $ac, $ac, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $68, $69, $00, $99, $40, $13, $ac, $ac, $ac, $ac, $68
	db $69, $6a, $6b, $6c, $6d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $58, $59, $00
	db $99, $20, $13, $ac, $ac, $ac, $ac, $58, $59, $5a, $5b, $5c, $5d, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $40, $41, $42, $43, $00, $98, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $1b, $2e, $2e, $2e, $00
	db $9b, $e0, $13, $41, $42, $43, $54, $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $9c, $9e, $be, $e9, $00, $9b, $c0, $13, $2e, $2e, $2e, $2e, $2f
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $9e, $be, $e9, $f9, $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $43, $54, $55, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $2e, $2e, $2f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $00, $13, $e9, $f9, $fb, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $40, $41, $42, $43, $54, $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $1b, $2e, $2e, $2e, $2e, $2f
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $9c, $9e, $be, $e9, $f9, $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9a, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9a, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $40, $41, $42, $43, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $1b, $2e, $2e, $2e, $00, $99, $40, $13, $40, $41, $42, $43, $54
	db $55, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $9c, $9e, $be, $e9, $00
	db $99, $20, $13, $1b, $2e, $2e, $2e, $2e, $2f, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $00, $13, $9c, $9e, $be, $e9, $f9
	db $fb, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $98, $20, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $98, $00, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $e0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $c0, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $60, $13, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $9b, $40, $13, $2c, $2d, $ac, $ac, $ac
	db $ac, $ac, $ac, $78, $79, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $9b, $20, $13, $ae, $ae, $3d, $3f, $ac, $ac, $ac, $ac, $45, $ae, $2c, $2d, $ac
	db $ac, $ac, $7b, $3d, $3f, $78, $79, $00, $9b, $00, $13, $ae, $ae, $ae, $3e, $ac
	db $ac, $ac, $ac, $72, $ae, $ae, $75, $ac, $ac, $7a, $4b, $ae, $3e, $45, $ae, $00
	db $9a, $e0, $13, $ae, $ae, $ae, $ae, $3d, $3f, $ac, $ac, $56, $73, $74, $67, $ac
	db $ac, $72, $ae, $ae, $ae, $ae, $ae, $00, $9a, $c0, $13, $ae, $ae, $ae, $ae, $ae
	db $3e, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $56, $73, $ae, $ae, $ae, $ae, $00
	db $9a, $a0, $13, $ae, $ae, $ae, $ae, $ae, $75, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $70, $71, $ae, $ae, $00, $9a, $80, $13, $ae, $ae, $ae, $ae, $74
	db $67, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $57, $ae, $ae, $00
	db $9a, $60, $13, $72, $ae, $76, $77, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $7b, $ae, $ae, $00, $9a, $40, $13, $56, $73, $66, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $7a, $4b, $ae, $ae, $00
	db $9a, $20, $13, $ac, $ac, $ac, $7b, $3d, $3f, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $72, $ae, $ae, $ae, $00, $9a, $00, $13, $ac, $ac, $7a, $4b, $ae
	db $3e, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $56, $73, $ae, $ae, $00
	db $99, $e0, $13, $ac, $ac, $72, $ae, $ae, $75, $ac, $ac, $fe, $ff, $05, $0b, $ac
	db $ac, $ac, $ac, $ac, $ac, $70, $71, $00, $99, $c0, $13, $ac, $ac, $56, $73, $74
	db $67, $ac, $ac, $f8, $fa, $fc, $fd, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $57, $00
	db $99, $a0, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $a2, $a3, $bf, $f0, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $80, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $84, $85, $9d, $9f, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $60, $13, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00, $99, $40, $13, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $00
	db $99, $20, $13, $3c, $ac, $78, $79, $3c, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac
	db $ac, $ac, $7b, $3d, $3f, $ac, $ac, $00, $99, $00, $13, $2c, $2d, $45, $ae, $2c
	db $2d, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $ac, $7a, $4b, $ae, $3e, $ac, $ac, $00
	db $98, $e0, $13, $ae, $ae, $ae, $ae, $ae, $75, $ac, $ac, $ac, $ac, $ac, $ac, $78
	db $79, $ae, $ae, $ae, $ae, $3c, $ac, $00, $98, $c0, $13, $ae, $ae, $ae, $ae, $74
	db $67, $ac, $ac, $ac, $ac, $ac, $ac, $45, $ae, $ae, $ae, $ae, $ae, $2c, $2d, $00
	db $02, $04, $06, $08, $0a, $0c, $0e, $10, $12, $14, $16, $18, $1a, $1c, $1e, $20
	db $22, $24, $26, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
	db $28, $28, $28, $27, $26, $25, $24, $23, $22, $21, $20, $1f, $1e, $1d, $1c, $1b
	db $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10, $0f, $0e, $0d, $0c, $0b
	db $0a, $09, $08, $07, $06, $05, $04, $04, $04, $04, $04, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $1e, $1e, $1e, $1e, $1f, $1f, $1f, $1f, $1a, $1a, $1a, $1a, $15, $15, $15, $15
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $15, $15, $15, $15
	db $19, $19, $1a, $1a, $1e, $1e, $1e, $1e

Jump_17_698B::
	ld a, [$d00d]
	cp $0e
	jr nc, jr_017_6998

	ld de, $9960
	call Call_17_4655

jr_017_6998:
	ld a, [$d00d]
	ld e, a
	ld d, $00
	ld hl, $6903
	add hl, de
	ld a, [hl]
	ld [$d00c], a
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00c]
	add e
	ld e, a
	ld d, $00
	ld hl, $6963
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld a, [$d00d]
	ld e, a
	ld d, $00
	cp $59
	jr nz, jr_017_69d7

	ldh a, [$ff97]
	cp $30
	jr nz, jr_017_69d7

	ld a, $ff
	ld [$d008], a
	ld a, $a8
	ld [$d009], a
	jp Call_17_4A2B


jr_017_69d7:
	ld hl, $68a3
	add hl, de
	ld a, [hl]
	cpl
	inc a
	sla a
	ld [$c240], a
	ld bc, $0000
	ld a, [$c200]
	push af
	call Call_17_7BC5
	ld a, [$c200]
	ldh [$ff97], a
	and $f8
	ld e, a
	pop af
	and $f8
	cp e
	jr z, jr_017_6a5a

	ld a, [$d00d]
	cp $59
	jr z, jr_017_6a5a

	inc a
	ld [$d00d], a
	cp $44
	jr nz, jr_017_6a2c

	ld a, $e3
	ld [$db99], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $80
	ld hl, $c2b0
	add hl, de
	ld [hl], $0b
	ld hl, $c2e0
	add hl, de
	ld [hl], $a8

jr_017_6a2c:
	ld a, [$d00d]
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld a, e
	ld l, d
	sla e
	rl d
	add e
	ld e, a
	ld a, d
	adc $00
	add l
	ld d, a
	ld hl, $6033
	add hl, de
	ld de, $d601
	ld c, $18

jr_017_6a54:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_6a54

jr_017_6a5a:
	ret


Jump_17_6A5B::
	ld a, [$d009]
	and a
	jr nz, jr_017_6a68

	xor a
	ld [$db97], a
	jp Call_17_5CC1


jr_017_6a68:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00c]
	add e
	ld e, a
	ld d, $00
	ld hl, $6963
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld a, [$d008]
	and a
	jr nz, jr_017_6abe

	ld a, [$d00b]
	inc a
	ld [$d00b], a
	and $07
	jr nz, jr_017_6abe

	ld a, [$d00c]
	cp $24
	jr z, jr_017_6abe

	inc a
	ld [$d00c], a
	cp $05
	jr nz, jr_017_6abe

	ld a, $1e
	ld [$db98], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $62
	ld hl, $c210
	add hl, de
	ld [hl], $5a
	ld hl, $c2b0
	add hl, de
	ld [hl], $0c
	ld hl, $c2e0
	add hl, de
	ld [hl], $60

jr_017_6abe:
	ret


Jump_17_6ABF::
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_6AC6::
	dw Jump_17_6AD4
	dw Jump_17_6ADC
	dw Jump_17_6B0D
	dw Jump_17_6B3F
	dw Jump_17_6B70
	dw Jump_17_6B8F
	dw Jump_17_6BD4

Jump_17_6AD4::
	ld a, $1a
	ld [$d6fe], a
	jp Call_17_4A2B


Jump_17_6ADC::
	ld a, $1b
	ld [$d6ff], a
	call Call_17_4AEB
	ld a, $1e
	ld [$db97], a
	ld a, $6e
	ld [$db98], a
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $38
	ld hl, $c210
	add hl, de
	ld [hl], $50
	ld hl, $c2b0
	add hl, de
	ld [hl], $0d
	ld a, $20
	ld [$d006], a
	jp Call_17_4A2B


Jump_17_6B0D::
	ld a, [$d006]
	and a
	jr nz, Call_17_6B16

	call Call_17_4A2B

Call_17_6B16::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_6b28

	ld a, [$d00f]
	inc a
	cp $31
	jr nz, jr_017_6b25

	xor a

jr_017_6b25:
	ld [$d00f], a

jr_017_6b28:
	ld a, [$d00f]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ld a, [hl]
	sra a
	ldh [$ff97], a
	ret


	db $6e, $6e, $6e, $6e, $1e, $1e, $1e, $1e

Jump_17_6B3F::
	call Call_17_6B16
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_6b5b

	ld a, [$d00a]
	inc a
	ld [$d00a], a
	cp $04
	jr nz, jr_017_6b5b

	ld a, $ff
	ld [$d006], a
	jp Call_17_4A2B


jr_017_6b5b:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d00a]
	add e
	ld e, a
	ld d, $00
	ld hl, $6b37
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ret


Jump_17_6B70::
	call Call_17_6B16
	ld a, [$d006]
	and a
	jr nz, jr_017_6b82

	ld a, $e0
	ld [$d006], a
	jp Call_17_4A2B


	db $c9

jr_017_6b82:
	cp $44
	jr z, jr_017_6b8a

	cp $50
	jr nz, jr_017_6b8e

jr_017_6b8a:
	ld hl, $d003
	inc [hl]

jr_017_6b8e:
	ret


Jump_17_6B8F::
	call Call_17_6B16
	ld hl, $d006
	ldh a, [$ffe7]
	and $07
	or [hl]
	jr nz, jr_017_6baf

	ld a, [$d002]
	inc a
	ld [$d002], a
	cp $0c
	jr nz, jr_017_6baf

	ld a, $40
	ld [$d006], a
	call Call_17_4A2B

jr_017_6baf:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d002]
	add e
	ld e, a
	ld d, $00
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld hl, $5c53
	add hl, de
	ld a, [hl]
	ld [$db98], a
	ld hl, $5c63
	add hl, de
	ld a, [hl]
	ld [$db99], a
	ret


Jump_17_6BD4::
	ld a, [$d006]
	and a
	jr nz, jr_017_6bdd

	jp Call_17_5CC1


jr_017_6bdd:
	ret


Jump_17_6BDE::
	ld de, $99a0
	call Call_17_4655
	call Call_17_42FD
	call Call_0B13
	ld a, [$d00e]
	rst $00

JumpTable_17_6BEE::
	dw Jump_17_6BFA
	dw Jump_17_6C07
	dw Jump_17_6C4C
	dw Jump_17_6C80
	dw Jump_17_6CC0
	dw Jump_17_6CC1

Jump_17_6BFA::
	ld a, $1b
	ld [$d6fe], a
	ld hl, $d6fd
	res 2, [hl]
	jp Call_17_4A2B


Jump_17_6C07::
	ld a, $1c
	ld [$d6ff], a
	call Call_17_4AEB
	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $78
	ld hl, $c2b0
	add hl, de
	ld [hl], $0e
	xor a
	ld [$d012], a
	dec a
	ld [$d010], a
	ld a, $b0
	ld [$d009], a
	xor a
	ldh [$ffe7], a
	ld [$db99], a
	jp Call_17_4A2B


	db $00, $00, $00, $00, $04, $04, $04, $04, $19, $19, $19, $19, $1e, $1e, $1e, $1e

Jump_17_6C4C::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_6c68

	ld a, [$d002]
	inc a
	ld [$d002], a
	cp $0c
	jr nz, jr_017_6c68

	ld a, $ff
	ld [$d013], a
	xor a
	ldh [$ffe7], a
	call Call_17_4A2B

jr_017_6c68:
	ldh a, [$ffe7]
	and $03
	ld e, a
	ld a, [$d002]
	add e
	ld e, a
	ld d, $00
	ld hl, $6c3c
	add hl, de
	ld a, [hl]
	ld [$db97], a
	ld [$db98], a
	ret


Jump_17_6C80::
	ld a, [$d013]
	and a
	jr nz, jr_017_6cbf

	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_6cbf

	ld hl, $ff97
	dec [hl]
	ld a, [hl]
	cp $70
	jr nz, jr_017_6c98

	jp Call_17_4A2B


jr_017_6c98:
	cp $a0
	jr nz, jr_017_6ca4

	ld hl, $c28f
	ld [hl], $00
	jp Jump_017_6ce6


jr_017_6ca4:
	cp $c0
	jr nz, jr_017_6cbf

	ld a, $e8
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $18
	ld hl, $c210
	add hl, de
	ld [hl], $b0
	ld hl, $c2b0
	add hl, de
	ld [hl], $0f

jr_017_6cbf:
	ret


Jump_17_6CC0::
	ret


Jump_17_6CC1::
	ret


	db $99, $c1, $05, $58, $59, $5a, $5b, $5c, $5d, $99, $e1, $05, $68, $69, $6a, $6b
	db $6c, $6d, $99, $f1, $02, $58, $59, $5a, $9a, $11, $02, $68, $69, $6a, $9a, $20
	db $01, $5c, $5d, $00

Jump_017_6ce6:
	ld hl, $6cc2
	ld de, $d601
	ld c, $24

jr_017_6cee:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_017_6cee

	ret


	db $08, $00, $5c, $00, $10, $00, $5d, $00, $00, $08, $c0, $00, $08, $08, $c1, $00
	db $00, $10, $ce, $00, $08, $10, $cf, $00, $00, $18, $de, $00, $08, $18, $df, $00
	db $00, $20, $ea, $00, $08, $20, $eb, $00, $08, $00, $5e, $00, $10, $00, $5f, $00
	db $00, $08, $c0, $00, $08, $08, $c1, $00, $00, $10, $ce, $00, $08, $10, $cf, $00
	db $00, $18, $de, $00, $08, $18, $df, $00, $00, $20, $ea, $00, $08, $20, $eb, $00
	db $08, $00, $ec, $00, $10, $00, $ed, $00, $00, $08, $d0, $00, $08, $08, $d1, $00
	db $00, $10, $ce, $00, $08, $10, $cf, $00, $00, $18, $de, $00, $08, $18, $df, $00
	db $00, $20, $ea, $00, $08, $20, $eb, $00, $08, $00, $ee, $00, $10, $00, $ef, $00
	db $00, $08, $d0, $00, $08, $08, $d1, $00, $00, $10, $ce, $00, $08, $10, $cf, $00
	db $00, $18, $de, $00, $08, $18, $df, $00, $00, $20, $ea, $00, $08, $20, $eb, $00

Jump_17_6D95::
	ld a, $3c
	ld [$c3c0], a
	ldh a, [$ff97]
	ld e, a
	ldh a, [$ffec]
	sub e
	ldh [$ffec], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	rra
	and $03
	rla
	rla
	rla
	and $f8
	ld e, a
	rla
	rla
	and $e0
	add e
	ld e, a
	ld d, b
	ld hl, $6cf5
	add hl, de
	ld c, $0a
	call Call_3D20
	ld a, $0a
	call Call_3DD0
	ldh a, [$ffe7]
	and $01
	jr nz, jr_017_6de6

	ld hl, $c240
	add hl, bc
	ld [hl], $04
	ld hl, $c250
	add hl, bc
	ld [hl], $ff
	call Call_17_7BB8
	ldh a, [$ffee]
	cp $a8
	ret c

	call Call_17_4A2B
	jp Jump_017_7a61


jr_017_6de6:
	ret


	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $00, $00, $00, $08, $00, $01, $00, $00, $08, $02, $00, $08, $08, $03, $00
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $00, $fa, $10, $00, $08, $fa, $11, $00, $00, $0e, $10, $20, $08, $0e, $11, $20
	db $00, $08, $00, $20, $08, $08, $01, $20, $00, $00, $02, $20, $08, $00, $03, $20
	db $08, $fa, $10, $40, $00, $fa, $11, $40, $08, $0e, $10, $60, $00, $0e, $11, $60

Jump_17_6E67::
	ld hl, $db57
	ld a, [hli]
	or [hl]
	jr nz, jr_017_6e96

	ld a, $1c
	ld [$db98], a
	ld a, $3c
	ld [$c3c0], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $6de7
	add hl, de
	ld c, $08
	call Call_3D20
	ld a, $08
	call Call_3DD0

jr_017_6e96:
	call Call_17_7BB8
	ldh a, [$ffe7]
	and $0f
	jr nz, jr_017_6ea9

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $fc
	jr z, jr_017_6ea9

	dec [hl]

jr_017_6ea9:
	ldh a, [$ffee]
	cp $a8
	jp z, Jump_017_7a61

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $7f
	jr nz, jr_017_6ebf

	ld a, $21
	ldh [$fff2], a

jr_017_6ebf:
	ret


	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $60, $00, $18, $f8, $61, $00, $10, $00, $62, $00, $18, $00, $63, $00
	db $10, $08, $64, $00, $18, $08, $65, $00, $10, $10, $66, $00, $18, $10, $67, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $68, $00, $18, $f8, $69, $00, $10, $00, $6a, $00, $18, $00, $6b, $00
	db $10, $08, $6c, $00, $18, $08, $6d, $00, $10, $10, $6e, $00, $18, $10, $6f, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $70, $00, $18, $f8, $71, $00, $10, $00, $72, $00, $18, $00, $73, $00
	db $10, $08, $74, $00, $18, $08, $75, $00, $10, $10, $76, $00, $18, $10, $77, $00
	db $00, $00, $4c, $00, $08, $00, $4d, $00, $00, $08, $4e, $00, $08, $08, $4f, $00
	db $10, $f8, $78, $00, $18, $f8, $79, $00, $10, $00, $7a, $00, $18, $00, $7b, $00
	db $10, $08, $7c, $00, $18, $08, $7d, $00, $10, $10, $7e, $00, $18, $10, $7f, $00

Jump_17_6F80::
	ld a, $3c
	ld [$c3c0], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_6f97

	ld a, [$d00f]
	inc a
	cp $31
	jr c, jr_017_6f94

	xor a

jr_017_6f94:
	ld [$d00f], a

jr_017_6f97:
	ld a, [$d00f]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ldh a, [$ff97]
	ld d, a
	ld a, [hl]
	sra a
	ld e, a
	ldh a, [$ffec]
	add e
	sub d
	ldh [$ffec], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
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
	ld hl, $6ec0
	add hl, de
	ld c, $0c
	call Call_3D20
	ld a, $0c
	call Call_3DD0
	ret


	db $00, $00, $00, $00, $00, $08, $02, $00, $00, $10, $04, $00, $00, $18, $06, $00
	db $00, $20, $08, $00, $00, $28, $0a, $00, $10, $20, $14, $00, $10, $28, $16, $00
	db $20, $20, $1e, $00, $20, $28, $20, $00, $30, $00, $50, $00, $30, $08, $22, $00
	db $30, $10, $24, $00, $30, $18, $26, $00, $30, $20, $28, $00, $30, $28, $2a, $00
	db $30, $30, $2c, $00, $30, $38, $2e, $00, $40, $00, $30, $00, $40, $08, $32, $00
	db $40, $10, $34, $00, $40, $18, $36, $00, $40, $20, $38, $00, $40, $28, $3a, $00
	db $40, $30, $3c, $00, $40, $38, $3e, $00, $40, $40, $40, $00, $10, $00, $0c, $00
	db $10, $08, $0e, $00, $10, $10, $10, $00, $10, $18, $12, $00, $20, $08, $18, $00
	db $20, $10, $1a, $00, $20, $18, $1c, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $42, $00, $10, $10, $44, $00, $10, $18, $46, $00, $20, $08, $18, $00
	db $20, $10, $48, $00, $20, $18, $4a, $00, $ff, $ff, $ff, $ff, $10, $00, $0c, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $56, $00, $20, $08, $18, $00
	db $20, $10, $58, $00, $20, $18, $5a, $00, $ff, $ff, $ff, $ff

Jump_17_709C::
	ld a, [$d00f]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ld a, [hl]
	sra a
	ld e, a
	ldh a, [$ffec]
	add e
	ldh [$ffec], a
	ld hl, $6fd0
	ld c, $1b
	call Call_3D20
	ld a, $1b
	call Call_3DD0
	ld a, [$d003]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $703c
	add hl, de
	ld c, $07
	ld a, $40
	ld [$c3c0], a
	call Call_3D26
	ld a, $07
	call Call_3DD0
	ret


	db $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00, $00, $00, $70, $00
	db $08, $08, $5c, $00, $08, $08, $5c, $00, $00, $00, $70, $00, $08, $08, $5e, $00
	db $08, $10, $60, $00

Jump_17_70FF::
	ld hl, $c340
	add hl, bc
	ld [hl], $c3
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
	ld hl, $70db
	add hl, de
	ld c, $03
	call Call_3D26
	call Call_0891
	cp $01
	jr z, jr_017_7126

	cp $30
	jr nz, jr_017_712b

jr_017_7126:
	ld hl, $c3b0
	add hl, bc
	inc [hl]

jr_017_712b:
	ret


	db $00, $00, $62, $10, $00, $08, $62, $30, $10, $f0, $64, $10, $10, $f8, $66, $10
	db $10, $00, $68, $10, $10, $08, $68, $30, $10, $10, $66, $30, $10, $18, $64, $30
	db $20, $00, $6a, $10, $20, $08, $6a, $30, $30, $f8, $6c, $10, $30, $00, $6e, $10
	db $30, $08, $6e, $30, $30, $10, $6c, $30

Jump_17_7164::
	xor a
	ld [$c3c0], a
	ld hl, $ff97
	ldh a, [$ffec]
	sub [hl]
	ldh [$ffec], a
	ld hl, $712c
	ld c, $0e
	call Call_3D26
	ld a, $0e
	call Call_3DD0
	ld hl, $c250
	add hl, bc
	ld [hl], $fe
	call Call_17_7BBB
	ldh a, [$fff0]
	cp $02
	jr nc, jr_017_719a

	call Call_0891
	jr nz, jr_017_719a

	ld [hl], $c0
	call Call_3B8D
	ld a, $17
	ldh [$fff3], a

jr_017_719a:
	ret


	db $00, $08, $b2, $00, $00, $10, $b4, $00, $00, $18, $b6, $00, $00, $20, $b8, $00
	db $10, $10, $ba, $00, $10, $18, $bc, $00, $10, $20, $86, $00, $20, $00, $88, $00
	db $20, $08, $8a, $00, $20, $10, $8c, $00, $20, $18, $8e, $00, $20, $20, $94, $00
	db $30, $00, $98, $00, $30, $08, $9a, $00, $30, $10, $a4, $00, $30, $18, $a8, $00
	db $30, $20, $aa, $00, $00, $08, $c2, $00, $00, $10, $c4, $00, $00, $18, $c6, $00
	db $00, $20, $c8, $00, $10, $10, $ca, $00, $10, $18, $cc, $00, $10, $20, $96, $00
	db $20, $00, $88, $00, $20, $08, $8a, $00, $20, $10, $8c, $00, $20, $18, $8e, $00
	db $20, $20, $94, $00, $30, $00, $98, $00, $30, $08, $9a, $00, $30, $10, $a4, $00
	db $30, $18, $a8, $00, $30, $20, $aa, $00, $00, $08, $d2, $00, $00, $10, $d4, $00
	db $00, $18, $d6, $00, $00, $20, $d8, $00, $10, $10, $da, $00, $10, $18, $dc, $00
	db $10, $20, $a6, $00, $20, $00, $88, $00, $20, $08, $8a, $00, $20, $10, $8c, $00
	db $20, $18, $8e, $00, $20, $20, $94, $00, $30, $00, $98, $00, $30, $08, $9a, $00
	db $30, $10, $a4, $00, $30, $18, $a8, $00, $30, $20, $aa, $00, $00, $00, $00, $00
	db $00, $00, $01, $01, $01, $01, $02, $02, $02, $03, $03, $04, $05, $05, $06, $06
	db $06, $07, $07, $07, $07, $08, $08, $08, $08, $08, $08, $07, $07, $07, $07, $06
	db $06, $06, $05, $05, $04, $03, $02, $02, $02, $01, $01, $01, $01

Jump_17_7298::
	ld a, $00
	ld [$c3c0], a
	ldh a, [$ff97]
	ld d, a
	sra a
	add d
	ldh [$ffd7], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_72b7

	ld a, [$d00f]
	inc a
	cp $31
	jr c, jr_017_72b4

	xor a

jr_017_72b4:
	ld [$d00f], a

jr_017_72b7:
	ld a, [$d00f]
	ld e, a
	ld d, b
	ld hl, $7267
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ld hl, $ffd7
	sub [hl]
	ldh [$ffec], a
	cp $a8
	jp nc, Jump_017_7a61

	ld a, [$d000]
	rla
	rla
	and $fc
	ld e, a
	rla
	rla
	rla
	rla
	and $c0
	add e
	ld e, a
	ld d, b
	ld hl, $719b
	add hl, de
	ld c, $11
	call Call_3D26
	ld a, $11
	call Call_3DD0
	ret


	db $00, $00, $70, $00, $08, $08, $5e, $00, $08, $10, $60, $00

Jump_17_72FA::
	ld hl, $c340
	add hl, bc
	ld [hl], $c3
	ld hl, $72ee
	ld c, $03
	call Call_3D26
	ret


	db $50, $00, $52, $00, $54, $00, $56, $00, $57, $00, $5a, $00

Jump_17_7315::
	ldh a, [$ffe7]
	and $07
	jr nz, jr_017_7327

	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, jr_017_7326

	xor a

jr_017_7326:
	ld [hl], a

jr_017_7327:
	ld hl, $c340
	add hl, bc
	ld [hl], $c1
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_017_733b

	ld hl, $ffed
	set 5, [hl]

jr_017_733b:
	ld de, $7309
	call Call_3CD0
	call Call_17_7BC5
	ldh a, [$ffee]
	cp $b0
	jp nc, Jump_017_7a61

	ret


	db $00, $08, $0e, $00, $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $50, $00
	db $10, $08, $52, $00, $10, $10, $54, $00, $10, $18, $58, $00, $00, $08, $0e, $00
	db $00, $10, $1e, $00, $00, $18, $2e, $00, $10, $00, $60, $00, $10, $08, $62, $00
	db $10, $10, $64, $00, $10, $18, $68, $00, $00, $00, $00, $01, $02, $02, $02, $01
	db $00, $00, $00, $00, $01, $01, $01, $01

Jump_17_7394::
	ld hl, $c340
	add hl, bc
	ld [hl], $c7
	ld a, $00
	ld [$c3c0], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $7384
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld hl, $734c
	ldh a, [$ffe7]
	and $10
	jr z, jr_017_73be

	ld hl, $7368

jr_017_73be:
	ld c, $07
	call Call_3D26
	ret


	db $5a, $00, $6a, $00

Jump_17_73C8::
	ld hl, $c340
	add hl, bc
	ld [hl], $c1
	ld a, c
	rla
	and $06
	ld e, a
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	add e
	and $07
	ld e, a
	ld d, b
	ld hl, $738c
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	ld de, $73c4
	call Call_3CD0
	ret


	db $54, $00, $64, $00, $64, $20, $54, $20, $4e, $00, $7e, $00

Jump_17_73FA::
	ld hl, $c340
	add hl, bc
	ld [hl], $c2
	ldh a, [$fff1]
	cp $01
	jr z, jr_017_7427

	cp $02
	jr z, jr_017_7434

	ld a, [$d00a]

jr_017_740d:
	ld e, a
	ld d, b
	ld hl, $5b49
	add hl, de
	ld a, [hl]
	sub $04

jr_017_7416:
	cpl
	inc a
	sra a
	ld e, a
	ldh a, [$ffec]
	add e
	ldh [$ffec], a
	ld de, $73ee
	call Call_3C3B
	ret


jr_017_7427:
	ld a, [$d00a]
	add $06
	cp $2b
	jr c, jr_017_7432

	sub $2b

jr_017_7432:
	jr jr_017_740d

jr_017_7434:
	ld a, [$d00a]
	add $18
	cp $2b
	jr c, jr_017_743f

	sub $2b

jr_017_743f:
	ld e, a
	ld d, $00
	ld hl, $5b49
	add hl, de
	ld a, [hl]
	sub $04
	sra a
	jr jr_017_7416

	db $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20, $78, $00, $78, $20
	db $7a, $00, $7a, $20, $7c, $00, $7c, $20, $08, $06, $06, $06, $06, $08

Jump_17_746B::
	ld hl, $c340
	add hl, bc
	ld [hl], $c2
	ld de, $744d
	call Call_3C3B
	call Call_0891
	jr nz, jr_017_7492

	push hl
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	cp $06
	jr nz, jr_017_7488

	xor a

jr_017_7488:
	ld [hl], a
	ld e, a
	ld d, b
	ld hl, $7465
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a

jr_017_7492:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $1f
	jr nz, jr_017_74a7

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_017_74a7

	inc [hl]

jr_017_74a7:
	call Call_17_7BB8
	ldh a, [$ffee]
	cp $b0
	jp nc, Jump_017_7a61

	ret


	db $d0, $00, $d2, $00, $d4, $00, $d6, $00, $d8, $00, $da, $00, $dc, $00, $de, $00
	db $e0, $00, $e2, $00, $e4, $00, $e6, $00, $e8, $00, $ea, $00, $ec, $00, $ee, $00

Jump_17_74D2::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	add $50
	ldh [$ffd7], a
	ld de, $74b2
	call Call_17_74E9
	call Call_0887
	ret z

	call Call_17_7BB8
	ret


Call_17_74E9::
	push bc
	push de
	ldh a, [$ffd7]
	ld e, a
	ld d, b
	ld hl, $c000
	add hl, de
	push hl
	pop de
	ldh a, [$ffec]
	ld [de], a
	inc de
	ld a, [$c155]
	ld c, a
	ldh a, [$ffed]
	and $20
	rra
	rra
	ld hl, $ffee
	add [hl]
	sub c
	ld [de], a
	inc de
	ldh a, [$fff1]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	push hl
	ld hl, $ffed
	xor [hl]
	ld [de], a
	inc de
	ldh a, [$ffec]
	ld [de], a
	inc de
	ld a, [$c155]
	ld c, a
	ldh a, [$ffed]
	and $20
	xor $20
	rra
	rra
	ld hl, $ffee
	sub c
	add [hl]
	ld [de], a
	inc de
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld hl, $ffed
	xor [hl]
	ld [de], a
	pop bc
	ret


Call_17_7547::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_17_754D::
	dw Jump_17_756F
	dw Jump_17_790C
	dw Jump_17_79BA
	dw Jump_17_74D2
	dw Jump_17_7394
	dw Jump_17_73C8
	dw Jump_17_7315
	dw Jump_17_72FA
	dw Jump_17_73FA
	dw Jump_17_746B
	dw Jump_17_7298
	dw Jump_17_7164
	dw Jump_17_70FF
	dw Jump_17_709C
	dw Jump_17_6F80
	dw Jump_17_6D95
	dw Jump_17_6E67

Jump_17_756F::
	call Call_17_78B3
	ldh a, [$fff0]
	rst $00

JumpTable_17_7575::
	dw Jump_17_757F
	dw Jump_17_75C4
	dw Jump_17_75FF
	dw Jump_17_7603
	dw Jump_17_761F

Jump_17_757F::
	ldh a, [$ffec]
	cp $60
	jp z, Call_3B8D

	ld hl, $c250
	add hl, bc
	ld [hl], $08
	call Call_17_7BBB
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $f0
	jr nz, jr_017_75a9

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cp $08
	jr nc, jr_017_75a9

	inc a
	ld [hl], a
	ld hl, $c210
	add hl, bc
	ld [hl], $e0

jr_017_75a9:
	ld a, $ff
	ldh [$ff9b], a

Call_17_75AD::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	add $00
	ldh [$ff9d], a

Call_17_75B8::
	push bc
	xor a
	ldh [$ff9a], a
	call Call_20D6
	call Call_17_7AD3
	pop bc
	ret


Jump_17_75C4::
	ld a, $f8
	ldh [$ff9b], a
	call Call_17_75AD
	ldh a, [$ff99]
	cp $5c
	jr nz, jr_017_75fe

	xor a
	ldh [$ff9b], a
	ld a, $02
	ldh [$ff9d], a
	ld a, $e8
	call Call_3C01
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c200
	add hl, de
	ld [hl], $50
	ld hl, $c210
	add hl, de
	ld [hl], $00
	ld hl, $c250
	add hl, de
	ld [hl], $14
	ld hl, $c2e0
	add hl, de
	ld [hl], $30
	call Call_3B8D

jr_017_75fe:
	ret


Jump_17_75FF::
	call Call_17_75B8
	ret


Jump_17_7603::
	call Call_17_75B8
	call Call_0891
	jr nz, jr_017_761b

	ld [hl], $08
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	cp $05
	jr nz, jr_017_761b

	call Call_3B8D

jr_017_761b:
	call Call_17_75B8
	ret


Jump_17_761F::
	call Call_17_75B8
	ret


	db $00, $00, $10, $10, $00, $08, $04, $10, $00, $10, $06, $10, $00, $18, $06, $30
	db $00, $20, $04, $30, $00, $28, $10, $30, $10, $00, $08, $10, $10, $08, $0a, $10
	db $10, $10, $0c, $10, $10, $18, $0c, $30, $10, $20, $0a, $30, $10, $28, $08, $30
	db $20, $10, $20, $10, $20, $18, $30, $10, $30, $10, $20, $10, $30, $18, $30, $10
	db $40, $10, $20, $10, $40, $18, $30, $10, $50, $10, $20, $10, $50, $18, $30, $10
	db $60, $10, $20, $10, $60, $18, $30, $10, $70, $10, $20, $10, $70, $18, $30, $10
	db $80, $10, $20, $10, $80, $18, $30, $10, $90, $10, $20, $10, $90, $18, $30, $10
	db $a0, $10, $20, $10, $a0, $18, $30, $10, $b0, $10, $20, $10, $b0, $18, $30, $10
	db $00, $00, $12, $10, $00, $08, $14, $10, $00, $10, $16, $10, $00, $18, $16, $30
	db $00, $20, $14, $30, $00, $28, $12, $30, $10, $00, $18, $10, $10, $08, $1a, $10
	db $10, $10, $1c, $10, $10, $18, $1c, $30, $10, $20, $1a, $30, $10, $28, $18, $30
	db $20, $10, $40, $10, $20, $18, $50, $10, $30, $10, $40, $10, $30, $18, $50, $10
	db $40, $10, $40, $10, $40, $18, $50, $10, $50, $10, $40, $10, $50, $18, $50, $10
	db $60, $10, $40, $10, $60, $18, $50, $10, $70, $10, $40, $10, $70, $18, $50, $10
	db $80, $10, $40, $10, $80, $18, $50, $10, $90, $10, $40, $10, $90, $18, $50, $10
	db $a0, $10, $40, $10, $a0, $18, $50, $10, $b0, $10, $40, $10, $b0, $18, $50, $10
	db $00, $00, $22, $10, $00, $08, $24, $10, $00, $10, $26, $10, $00, $18, $26, $30
	db $00, $20, $24, $30, $00, $28, $22, $30, $10, $00, $28, $10, $10, $08, $2a, $10
	db $10, $10, $2c, $10, $10, $18, $2c, $30, $10, $20, $2a, $30, $10, $28, $28, $30
	db $20, $10, $60, $10, $20, $18, $70, $10, $30, $10, $60, $10, $30, $18, $70, $10
	db $40, $10, $60, $10, $40, $18, $70, $10, $50, $10, $60, $10, $50, $18, $70, $10
	db $60, $10, $60, $10, $60, $18, $70, $10, $70, $10, $60, $10, $70, $18, $70, $10
	db $80, $10, $60, $10, $80, $18, $70, $10, $90, $10, $60, $10, $90, $18, $70, $10
	db $a0, $10, $60, $10, $a0, $18, $70, $10, $b0, $10, $60, $10, $b0, $18, $70, $10
	db $00, $00, $32, $10, $00, $08, $34, $10, $00, $10, $36, $10, $00, $18, $36, $30
	db $00, $20, $34, $30, $00, $28, $32, $30, $10, $00, $38, $10, $10, $08, $3a, $10
	db $10, $10, $3c, $10, $10, $18, $3c, $30, $10, $20, $3a, $30, $10, $28, $38, $30
	db $20, $10, $52, $10, $20, $18, $62, $10, $30, $10, $52, $10, $30, $18, $62, $10
	db $40, $10, $52, $10, $40, $18, $62, $10, $50, $10, $52, $10, $50, $18, $62, $10
	db $60, $10, $52, $10, $60, $18, $62, $10, $70, $10, $52, $10, $70, $18, $62, $10
	db $80, $10, $52, $10, $80, $18, $62, $10, $90, $10, $52, $10, $90, $18, $62, $10
	db $a0, $10, $52, $10, $a0, $18, $62, $10, $b0, $10, $52, $10, $b0, $18, $62, $10
	db $00, $00, $42, $10, $00, $08, $44, $10, $00, $10, $46, $10, $00, $18, $46, $30
	db $00, $20, $44, $30, $00, $28, $42, $30, $10, $00, $48, $10, $10, $08, $4a, $10
	db $10, $10, $4c, $10, $10, $18, $4c, $30, $10, $20, $4a, $30, $10, $28, $08, $30
	db $20, $10, $56, $10, $20, $18, $66, $10, $30, $10, $56, $10, $30, $18, $66, $10
	db $40, $10, $56, $10, $40, $18, $66, $10, $50, $10, $56, $10, $50, $18, $66, $10
	db $60, $10, $56, $10, $60, $18, $66, $10, $70, $10, $56, $10, $70, $18, $66, $10
	db $80, $10, $56, $10, $80, $18, $66, $10, $90, $10, $56, $10, $90, $18, $66, $10
	db $a0, $10, $56, $10, $a0, $18, $66, $10, $b0, $10, $56, $10, $b0, $18, $66, $10
	db $70, $68, $60, $58, $50, $48, $40, $38, $30, $30, $30, $30, $30, $30, $80, $78

Call_17_78B3::
	push bc
	ldh a, [$ffec]
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $78a3
	add hl, de
	ld b, [hl]
	ld hl, $7623
	ldh a, [$fff1]
	cp $05
	jr z, jr_017_790a

	and a
	jr z, jr_017_78e2

	ld hl, $76a3
	dec a
	jr z, jr_017_78e2

	ld hl, $7723
	dec a
	jr z, jr_017_78e2

	ld hl, $77a3
	dec a
	jr z, jr_017_78e2

	ld hl, $7823

jr_017_78e2:
	ld de, $c00c
	ld c, $00

jr_017_78e7:
	ld a, c
	and $03
	cp $00
	jr nz, jr_017_78f2

	ldh a, [$ffec]
	jr jr_017_78fe

jr_017_78f2:
	cp $01
	jr nz, jr_017_7901

	push hl
	ld hl, $c155
	ldh a, [$ffee]
	sub [hl]
	pop hl

jr_017_78fe:
	add [hl]
	jr jr_017_7902

jr_017_7901:
	ld a, [hl]

jr_017_7902:
	ld [de], a
	inc hl
	inc de
	inc c
	ld a, c
	cp b
	jr nz, jr_017_78e7

jr_017_790a:
	pop bc
	ret


Jump_17_790C::
	call Call_17_7938
	ret


	db $20, $40, $60, $78, $10, $48, $68, $90, $30, $50, $80, $90, $18, $38, $68, $78
	db $28, $08, $28, $00, $48, $40, $4c, $38, $68, $70, $58, $68, $78, $88, $98, $80
	db $1e, $1e, $1e, $2e, $2e, $3e, $2e, $2e

Call_17_7938::
	ld de, $c090
	push bc
	ldh a, [$ffe7]
	and $01
	ld c, a

jr_017_7941:
	ld hl, $7920
	add hl, bc
	ldh a, [$ffec]
	add [hl]
	cp $98
	jr c, jr_017_794e

	sub $88

jr_017_794e:
	ld [de], a
	inc de
	ld hl, $7910
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	push bc
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	nop
	xor c
	and $07
	ld c, a
	ld b, $00
	ld hl, $7930
	add hl, bc
	ld a, [hl]
	ld [de], a
	inc de
	pop bc
	ld a, $90
	ld [de], a
	inc de
	inc c
	inc c
	ld a, c
	cp $10
	jr c, jr_017_7941

	pop bc
	ret


	db $00, $f8, $58, $00, $00, $00, $68, $00, $00, $08, $68, $20, $00, $10, $58, $20
	db $00, $f8, $5a, $00, $00, $00, $6a, $00, $00, $08, $6a, $20, $00, $10, $5a, $20
	db $00, $f8, $5c, $00, $00, $00, $6c, $00, $00, $08, $6c, $20, $00, $10, $5c, $20
	db $00, $f8, $5e, $00, $00, $00, $6e, $00, $00, $08, $6e, $20, $00, $10, $5e, $20

Jump_17_79BA::
	ld a, $50
	ld [$c3c0], a
	ld hl, $797a
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	call Call_3B87
	ldh a, [$fff0]
	rst $00

JumpTable_17_79E4::
	dw Jump_17_79EC
	dw Jump_17_7A1A
	dw Jump_17_7A44
	dw Jump_17_7A56

Jump_17_79EC::
	call Call_0891
	jr nz, jr_017_7a09

	call Call_17_7BBB
	ldh a, [$ffe7]
	and $03
	jr nz, jr_017_7a09

	ld hl, $c250
	add hl, bc
	dec [hl]
	jr nz, jr_017_7a09

	call Call_0891
	ld [hl], $80
	call Call_3B8D

jr_017_7a09:
	ret


	db $00, $00, $00, $01, $01, $02, $03, $03, $04, $04, $04, $03, $03, $02, $01, $01

Jump_17_7A1A::
	call Call_0891
	jr nz, Call_17_7A2C

	ld a, $cf
	call Call_17_7A8F
	ld a, $19
	ld [$c5ab], a
	call Call_3B8D

Call_17_7A2C::
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld a, [hl]
	inc [hl]
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $7a0a
	add hl, de
	ld a, [hl]
	ld hl, $c310
	add hl, bc
	ld [hl], a
	ret


Jump_17_7A44::
	call Call_17_7A2C
	ld a, [$c19f]
	and a
	jr nz, jr_017_7a55

	call Call_0891
	ld [hl], $ff
	call Call_3B8D

jr_017_7a55:
	ret


Jump_17_7A56::
	call Call_17_7A2C
	call Call_0891
	jr nz, jr_017_7a67

jr_017_7a5e:
	call Call_17_4A2B

Jump_017_7a61:
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


jr_017_7a67:
	cp $e0
	jr nc, jr_017_7a8e

	cp $df
	jr nz, jr_017_7a73

	ld a, $26
	ldh [$fff2], a

jr_017_7a73:
	ld hl, $c2d0
	add hl, bc
	ld e, [hl]
	ld a, [hl]
	cp $fc
	jr nc, jr_017_7a5e

	add $02
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	add e
	ld [hl], a
	jr nc, jr_017_7a8e

	ld a, $ff
	call Call_3B87

jr_017_7a8e:
	ret


Call_17_7A8F::
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


	db $00, $00, $02, $00, $02, $20, $00, $20, $44, $00, $46, $00, $48, $00, $4a, $00
	db $4c, $00, $4c, $20, $d8, $20, $d6, $20, $d4, $00, $d4, $20, $d6, $00, $d8, $00
	db $da, $00, $dc, $00, $de, $00, $e0, $00, $e2, $00, $e2, $20, $e0, $20, $de, $20
	db $dc, $20, $da, $20

Call_17_7AD3::
	ldh a, [$ff9d]
	rla
	rla
	and $fc
	ld e, a
	ld d, $00
	ld hl, $7a9f
	add hl, de
	push hl
	pop de
	ld hl, $c004
	ldh a, [$ff99]
	ld [hli], a
	ld a, [$c155]
	ld c, a
	ldh a, [$ff98]
	sub c
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ldh a, [$ff99]
	ld [hli], a
	ldh a, [$ff98]
	sub c
	add $08
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	ld [hl], a
	ret


	db $37, $7f

	ldh a, [$ffe7]
	and $10
	ret nz

	ld e, $00
	ld a, [$c19f]
	and $80
	jr z, jr_017_7b16

	inc e

jr_017_7b16:
	ld d, $00
	ld a, [$db95]
	cp $01
	jr z, jr_017_7b37

	ld hl, $7b05
	add hl, de
	ld a, [hl]
	ld [$c018], a
	ld a, $97
	ld [$c019], a
	ld a, $a2
	ld [$c01a], a
	ld a, $40
	ld [$c01b], a
	ret


jr_017_7b37:
	ld hl, $7b05
	add hl, de
	ld a, [hl]
	ld hl, $ff97
	sub [hl]
	ld [$c000], a
	ld a, $97
	ld [$c001], a
	ld a, $fe
	ld [$c002], a
	ld a, $40
	ld [$c003], a
	ret


	db $30, $78, $30, $58

	ld e, $00
	ld a, [$c19f]
	and $80
	jr z, jr_017_7b61

	inc e

jr_017_7b61:
	ld d, $00
	ld a, [$db95]
	cp $01
	jr z, jr_017_7b8f

	ld hl, $7b53
	add hl, de
	ld a, [hl]
	ld [$c018], a
	ld e, $00
	ld a, [$c177]
	and $01
	jr z, jr_017_7b7c

	inc e

jr_017_7b7c:
	ld hl, $7b55
	add hl, de
	ld a, [hl]
	ld [$c019], a
	ld a, $3e
	ld [$c01a], a
	ld a, $00
	ld [$c01b], a
	ret


jr_017_7b8f:
	ld hl, $7b53
	add hl, de
	ld a, [hl]
	ld hl, $ff97
	sub [hl]
	ld [$c000], a
	ld e, $00
	ld a, [$c177]
	and $01
	jr z, jr_017_7ba5

	inc e

jr_017_7ba5:
	ld hl, $7b55
	add hl, de
	ld a, [hl]
	ld [$c001], a
	ld a, $9e
	ld [$c002], a
	ld a, $00
	ld [$c003], a
	ret


Call_17_7BB8::
	call Call_17_7BC5

Call_17_7BBB::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_17_7BC5
	pop bc
	ret


Call_17_7BC5::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_017_7bf0

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_017_7be7

	ld e, $f0

jr_017_7be7:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_017_7bf0:
	ret


	db $21, $20, $c3, $09, $7e, $a7, $28, $f7, $f5, $cb, $37, $e6, $f0, $21, $30, $c3
	db $09, $86, $77, $cb, $12, $21, $10, $c3, $18, $d2, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
