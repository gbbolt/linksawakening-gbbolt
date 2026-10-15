; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

	db $21, $00, $c2, $09, $7e, $c6, $08, $77, $c9

Call_04_4009::
	call Call_380E
	call Call_3F12
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_4015::
	dw Jump_04_401F
	dw Jump_04_42D2
	dw Jump_04_4833
	dw Jump_04_48D0
	dw Jump_04_4936

Jump_04_401F::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $03
	jr c, jr_004_4057

	ld a, $5c
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	sub $18
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c2e0
	add hl, de
	ld [hl], $27
	ld hl, $c360
	add hl, de
	ld [hl], $08
	call Call_3E64
	ld a, $29
	ldh [$fff4], a
	ret


jr_004_4057:
	ld hl, $c360
	add hl, bc
	ld [hl], $20
	ld a, c
	ld [$d002], a
	call Call_04_429C
	call Call_04_7F36
	ld hl, $c340
	add hl, bc
	ld [hl], $81
	ld hl, $c350
	add hl, bc
	ld [hl], $80
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	ldh [$ffe8], a
	and $80
	jr z, jr_004_408e

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld [hl], b

jr_004_408e:
	ldh a, [$fff0]
	rst $00

JumpTable_04_4091::
	dw Jump_04_4099
	dw Jump_04_40AC
	dw Jump_04_415F
	dw Jump_04_41FD

Jump_04_4099::
	ldh a, [$ff99]
	cp $70
	jr nc, jr_004_40a7

	call Call_3B8D
	call Call_0891
	ld [hl], $ff

jr_004_40a7:
	ret


	db $00, $01, $00, $02

Jump_04_40AC::
	call Call_08E2
	call Call_3BEB
	call Call_3BBF
	jr nc, jr_004_40d0

	call Call_0942
	ld a, $09
	ldh [$fff2], a
	ld a, $10
	ld [$c13e], a
	ld a, $14
	call Call_3C30
	ldh a, [$ffd7]
	ldh [$ff9b], a
	ldh a, [$ffd8]
	ldh [$ff9a], a

jr_004_40d0:
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_4121

	ldh a, [$ffe8]
	and $80
	jr z, jr_004_40e8

	ld hl, $c320
	add hl, bc
	ld [hl], $10
	ld a, $20
	ldh [$fff2], a

jr_004_40e8:
	ldh a, [$ff98]
	push af
	ld a, $50
	ldh [$ff98], a
	ldh a, [$ff99]
	push af
	ld a, $48
	ldh [$ff99], a
	ld a, $08
	call Call_3C25
	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_4118

	ldh a, [$ffef]
	ld hl, $ff99
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_4118

	ld hl, $c2d0
	add hl, bc
	inc [hl]

jr_004_4118:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_04_6D9D

jr_004_4121:
	call Call_0891
	cp $01
	jr nz, jr_004_414d

	ld a, $5c
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	sub $26
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	ld hl, $c2e0
	add hl, de
	ld [hl], $47
	ld a, $06
	ldh [$fff2], a

Jump_004_414d:
jr_004_414d:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $40a8
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_04_415F::
	call Call_0891
	jr z, jr_004_4194

	dec a
	jr nz, jr_004_416d

	call Call_3B8D
	ld [hl], $03
	ret


jr_004_416d:
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_418e

	call Call_3DAF
	call Call_0891
	cp $28
	jr nc, jr_004_4191

	ld e, $08
	ldh a, [$ffe7]
	and $04
	jr z, jr_004_4189

	ld e, $f8

jr_004_4189:
	ld hl, $c240
	add hl, bc
	ld [hl], e

jr_004_418e:
	call Call_04_6D9D

jr_004_4191:
	call Call_3B9E

jr_004_4194:
	call Call_08E2
	call Call_3BEB
	call Call_04_7B6B
	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_41f8

	ldh a, [$ffec]
	ld hl, $ff99
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_41f8

	call Call_0942
	ld a, [$db00]
	cp $03
	jr nz, jr_004_41c7

	ldh a, [$ffcb]
	and $20
	jr nz, jr_004_41d4

	jr jr_004_41f8

jr_004_41c7:
	ld a, [$db01]
	cp $03
	jr nz, jr_004_41f8

	ldh a, [$ffcb]
	and $10
	jr z, jr_004_41f8

jr_004_41d4:
	ld a, [$c3cf]
	and a
	jr nz, jr_004_41f8

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
	ld hl, $fff3
	ld [hl], $02
	call Call_0891
	ld [hl], $08

jr_004_41f8:
	xor a
	call Call_3B87
	ret


Jump_04_41FD::
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_422e

	ld [hl], b
	call Call_3B8D
	ld [hl], $02
	ld hl, $c320
	add hl, bc
	ld [hl], $20
	ld a, $08
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
	ld [hl], $c0
	ret


jr_004_422e:
	call Call_04_6D53
	ld hl, $c340
	add hl, bc
	ld [hl], $01
	ld hl, $c350
	add hl, bc
	ld [hl], $00
	ld hl, $c430
	add hl, bc
	ld [hl], $00
	call Call_3BB4
	ld hl, $c430
	add hl, bc
	ld [hl], $d0
	ldh a, [$ffe8]
	and $80
	jr z, jr_004_4261

	ld hl, $c320
	add hl, bc
	ld [hl], $10
	ld a, $20
	ldh [$fff2], a
	ld a, $0c
	call Call_3C25

jr_004_4261:
	call Call_04_6D9D
	call Call_3B9E
	jp Jump_004_414d


	db $f0, $00, $76, $00, $f0, $08, $76, $20, $00, $00, $78, $00, $00, $08, $78, $20
	db $f0, $00, $7a, $00, $f0, $08, $7c, $00, $00, $00, $7e, $00, $00, $08, $7e, $20
	db $f0, $00, $7c, $20, $f0, $08, $7a, $20, $00, $00, $7e, $00, $00, $08, $7e, $20
	db $26, $00

Call_04_429C::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	and $f0
	ld e, a
	ld d, b
	ld hl, $426a
	add hl, de
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_42d1

	ldh a, [$ffef]
	add $0a
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $429a
	call Call_3CD0
	call Call_3DBA

jr_004_42d1:
	ret


Jump_04_42D2::
	call Call_04_46EC
	ldh a, [$ffea]
	cp $05
	jr z, jr_004_4309

	ld hl, $c420
	add hl, bc
	ldh a, [$ffe7]
	ld [hl], a
	ldh a, [$fff0]
	rst $00

JumpTable_04_42E5::
	dw Jump_04_42EB
	dw Jump_04_42F4
	dw Jump_04_42FF

Jump_04_42EB::
	call Call_0891
	ld [hl], $40
	call Call_3B8D
	ret


Jump_04_42F4::
	call Call_0891
	jr nz, jr_004_42fe

	ld [hl], $a0
	call Call_3B8D

jr_004_42fe:
	ret


Jump_04_42FF::
	call Call_0891
	jp z, Jump_004_5746

	call Call_04_50F3
	ret


jr_004_4309:
	call Call_04_7F36
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld [$d000], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	ld [$d001], a
	ldh a, [$fff0]
	cp $05
	jr z, jr_004_4325

	call Call_3BBF

jr_004_4325:
	ldh a, [$fff0]
	rst $00

JumpTable_04_4328::
	dw Jump_04_4334
	dw Jump_04_4371
	dw Jump_04_4492
	dw Jump_04_44DC
	dw Jump_04_450A
	dw Jump_04_4568

Jump_04_4334::
	call Call_0891
	jr nz, jr_004_4360

	call Call_3B8D
	call Call_088C
	ld [hl], $ff
	ld a, [$d002]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	ld a, $52
	jr nz, jr_004_435d

	call Call_3B8D
	ld [hl], $04
	ld hl, $c360
	add hl, bc
	ld [hl], $08
	ld a, $53

jr_004_435d:
	call Call_2197

jr_004_4360:
	ret


	db $10, $14, $18, $20, $28, $30, $38, $40, $ff, $ff, $60, $40, $01, $ff, $08, $f8

Jump_04_4371::
	call Call_04_6D9D
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ldh a, [$ffe7]
	and $07
	jr nz, jr_004_4397

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld hl, $436f
	add hl, de
	cp [hl]
	jr z, jr_004_4397

	ld hl, $436d
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	add [hl]
	ld [hl], a

jr_004_4397:
	ld hl, $436b
	add hl, de
	ldh a, [$ffee]
	cp [hl]
	jr nz, jr_004_43a8

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_004_43a8:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_43ce

	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $436d
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	add [hl]
	ld [hl], a
	ld hl, $436f
	add hl, de
	cp [hl]
	jr nz, jr_004_43ce

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a

jr_004_43ce:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_0891
	jr nz, jr_004_4429

	push hl
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ld e, a
	cp $08
	jr c, jr_004_43f0

	call Call_3B8D
	pop hl
	ld [hl], $30
	ret


jr_004_43f0:
	ld d, b
	ld hl, $4361
	add hl, de
	ld a, [hl]
	pop hl
	ld [hl], a
	ld a, $5c
	call Call_3C01
	jr c, jr_004_4429

	ldh a, [$ffd7]
	sub $0c
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	sub $14
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $03
	ld hl, $c320
	add hl, de
	ld [hl], $20
	ld hl, $c240
	add hl, de
	ld [hl], $0c
	ld hl, $c340
	add hl, de
	ld [hl], $42

jr_004_4429:
	call Call_088C
	jr nz, jr_004_4478

	ld [hl], $20
	ld a, $5c
	call Call_3C01
	jr c, jr_004_4478

	push bc
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $01
	ld c, a
	ld hl, $4490
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
	ld hl, $c320
	add hl, de
	ld [hl], $24
	ld hl, $c2b0
	add hl, de
	ld [hl], $04
	ld hl, $c340
	add hl, de
	ld [hl], $12
	push de
	pop bc
	ld a, $1f
	call Call_3C25
	pop bc
	ld hl, $c300
	add hl, bc
	ld [hl], $10
	ld a, $28
	ldh [$fff4], a

jr_004_4478:
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_448f

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $01
	ld a, $02
	jr z, jr_004_448c

	inc a

jr_004_448c:
	call Call_3B87

jr_004_448f:
	ret


	db $f4, $0c

Jump_04_4492::
	ld a, [$d002]
	ld e, a
	ld d, b
	ldh a, [$ff98]
	push af
	ld hl, $c200
	add hl, de
	ld a, [hl]
	ldh [$ff98], a
	ldh a, [$ff99]
	push af
	ld hl, $c210
	add hl, de
	ld a, [hl]
	sub $20
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	call Call_04_6D9D
	ld hl, $ff98
	ldh a, [$ffee]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_004_44d5

	ld hl, $ff99
	ldh a, [$ffec]
	sub [hl]
	add $03
	cp $06
	jr nc, jr_004_44d5

	call Call_0891
	ld [hl], $10
	call Call_3B8D

jr_004_44d5:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	ret


Jump_04_44DC::
	call Call_0891
	jp z, Call_04_6D4D

	cp $04
	jr nz, jr_004_4509

	ld a, $5c
	call Call_3C01
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
	ld [hl], $02
	ld hl, $c2e0
	add hl, de
	ld [hl], $c7
	ld a, $1f
	ldh [$fff2], a

jr_004_4509:
	ret


Jump_04_450A::
	ld hl, $c350
	add hl, bc
	ld [hl], $0c
	ld hl, $c430
	add hl, bc
	ld [hl], $81
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	cp $02
	jr nz, jr_004_4528

	call Call_3B8D
	call Call_0891
	ld [hl], $80
	ret


jr_004_4528:
	call Call_04_6D53
	call Call_3BEB
	call Call_04_6D9D
	call Call_3B9E
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_455b

	ld a, $10
	call Call_3C30
	ld hl, $c240
	add hl, bc
	ldh a, [$ffd8]
	sub [hl]
	and $80
	jr z, jr_004_454c

	dec [hl]
	dec [hl]

jr_004_454c:
	inc [hl]
	ld hl, $c250
	add hl, bc
	ldh a, [$ffd7]
	sub [hl]
	and $80
	jr z, jr_004_455a

	dec [hl]
	dec [hl]

jr_004_455a:
	inc [hl]

Jump_004_455b:
jr_004_455b:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	add $02
	jp Call_3B87


Jump_04_4568::
	ld hl, $c340
	add hl, bc
	ld [hl], $41
	call Call_0891
	jr nz, jr_004_45e4

	call Call_3B8D
	ld [hl], $04
	ld hl, $c340
	add hl, bc
	ld [hl], $01
	call Call_27ED
	and $01
	jr nz, jr_004_4599

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	ld [hl], a

jr_004_4599:
	call Call_3DAF
	ld hl, $c410
	add hl, bc
	ld [hl], b
	ld a, $5c
	call Call_3C01
	jr c, jr_004_45e3

	push bc
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	and $01
	ld c, a
	ld hl, $4490
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
	ld hl, $c320
	add hl, de
	ld [hl], $24
	ld hl, $c2b0
	add hl, de
	ld [hl], $04
	ld hl, $c340
	add hl, de
	ld [hl], $12
	push de
	pop bc
	ld a, $1f
	call Call_3C25
	pop bc
	ld a, $28
	ldh [$fff4], a

jr_004_45e3:
	ret


jr_004_45e4:
	ldh a, [$ff98]
	push af
	ld a, $50
	ldh [$ff98], a
	ldh a, [$ff99]
	push af
	ld a, $48
	ldh [$ff99], a
	ld a, $20
	call Call_3C30
	ldh a, [$ffd8]
	cpl
	inc a
	push af
	ldh a, [$ffd7]
	push af
	ld a, $04
	call Call_3C30
	ld hl, $ffd8
	pop af
	add [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $ffd7
	pop af
	add [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_04_6D9D
	call Call_04_4627
	jp Jump_004_455b


Call_04_4627::
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, a
	ld a, $48
	sub e
	ld hl, $c2d0
	add hl, bc
	ld [hl], a
	ld hl, $c200
	add hl, bc
	ld a, [hl]
	sub $50
	ld e, a
	ld a, $50
	sub e
	ld hl, $c440
	add hl, bc
	ld [hl], a
	ret


	db $f0, $f4, $60, $00, $f0, $fc, $62, $00, $f0, $04, $64, $00, $f0, $0c, $62, $20
	db $f0, $14, $60, $20, $00, $f4, $66, $00, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $68, $20, $00, $14, $66, $20, $f0, $f4, $60, $00, $f0, $fc, $62, $00
	db $f0, $04, $64, $20, $f0, $0c, $62, $20, $f0, $14, $60, $20, $00, $f4, $66, $00
	db $00, $fc, $68, $00, $00, $04, $6a, $20, $00, $0c, $68, $20, $00, $14, $66, $20
	db $f0, $f4, $60, $00, $f0, $fc, $62, $00, $f0, $04, $64, $00, $f0, $0c, $6c, $00
	db $f0, $14, $6e, $00, $00, $f4, $66, $00, $00, $fc, $68, $00, $00, $04, $6a, $00
	db $00, $0c, $70, $00, $00, $14, $72, $00, $f0, $f4, $6e, $20, $f0, $fc, $6c, $20
	db $f0, $04, $64, $20, $f0, $0c, $62, $20, $f0, $14, $60, $20, $00, $f4, $72, $20
	db $00, $fc, $70, $20, $00, $04, $6a, $20, $00, $0c, $68, $20, $00, $14, $66, $20
	db $74, $00, $74, $20

Call_04_46EC::
	ldh a, [$fff0]
	cp $05
	jr nz, jr_004_4706

	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_4706

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ldh [$ffec], a
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	ldh [$ffee], a

jr_004_4706:
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
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
	ld hl, $4648
	add hl, de
	ld c, $0a
	call Call_3D26
	ld a, $0a
	call Call_3DD0
	ldh a, [$ffec]
	add $10
	ldh [$ffec], a
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ldh [$fff1], a
	ld de, $46e8
	call Call_3CD0
	call Call_3DBA
	ret


	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $08, $00, $30, $00, $08, $08, $30, $60, $08, $00, $30, $00, $08, $08, $30, $60
	db $08, $00, $30, $00, $08, $08, $30, $60, $08, $00, $30, $00, $08, $08, $30, $60
	db $04, $00, $30, $00, $04, $08, $30, $60, $14, $00, $1e, $00, $14, $08, $1e, $60
	db $14, $00, $1e, $00, $14, $08, $1e, $60, $14, $00, $1e, $00, $14, $08, $1e, $60
	db $00, $00, $30, $00, $00, $08, $30, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $10, $00, $1e, $00, $10, $08, $1e, $60, $10, $00, $1e, $00, $10, $08, $1e, $60
	db $f2, $fa, $30, $00, $f2, $02, $30, $60, $f2, $06, $30, $00, $f2, $0e, $30, $60
	db $fe, $fa, $30, $00, $fe, $02, $30, $60, $fe, $06, $30, $00, $fe, $0e, $30, $60
	db $f0, $f8, $30, $40, $f0, $00, $30, $20, $f0, $08, $30, $40, $f0, $10, $30, $20
	db $00, $f8, $30, $40, $00, $00, $30, $20, $00, $08, $30, $40, $00, $10, $30, $20
	db $f0, $f8, $32, $00, $f0, $00, $32, $60, $f0, $08, $32, $00, $f0, $10, $32, $60
	db $00, $f8, $32, $00, $00, $00, $32, $60, $00, $08, $32, $00, $00, $10, $32, $60
	db $06, $05, $04, $05, $04, $03, $02, $01, $00, $00, $01, $02, $03, $04, $05, $04
	db $05, $06

Jump_04_4833::
	call Call_04_48AE
	call Call_04_7F36
	call Call_0891
	bit 7, a
	jr z, jr_004_4862

	and $7f
	jr nz, jr_004_4852

	ld a, [$d002]
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld [hl], $03
	jp Call_04_6D4D


jr_004_4852:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $482a
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


jr_004_4862:
	and a
	jp z, Call_04_6D4D

	cp $06
	jr nz, jr_004_489b

	ld a, $5c
	call Call_3C01
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	cp $14
	jr nc, jr_004_487e

	ld a, $14

jr_004_487e:
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $40
	ld hl, $c340
	add hl, de
	ld [hl], $01
	ld hl, $c350
	add hl, de
	ld [hl], $8c

jr_004_489b:
	call Call_0891
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $4821
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Call_04_48AE::
	ldh a, [$fff1]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld e, a
	ld d, b
	ld hl, $4741
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ret


	db $34, $00, $34, $20, $34, $10, $34, $30

Jump_04_48D0::
	ld de, $48c8
	call Call_3C3B
	call Call_04_7F36
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push af
	ld a, [$d000]
	add [hl]
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push af
	ld a, [$d001]
	add [hl]
	ld [hl], a
	call Call_04_6D9D
	pop af
	ld hl, $c250
	add hl, bc
	ld [hl], a
	pop af
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ldh a, [$fff0]
	and a
	jr nz, jr_004_492f

	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_492e

	ld [hl], b
	call Call_3B8D
	call Call_0891
	ld [hl], $08
	ld hl, $c240
	add hl, bc
	ld [hl], $e0

jr_004_492e:
	ret


jr_004_492f:
	call Call_0891
	call z, Call_04_6D4D
	ret


Jump_04_4936::
	ld de, $48c8
	call Call_3C3B
	call Call_04_7F36
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_3BBF
	call Call_04_6D9D
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jp nz, Call_04_6D4D

	ret


	db $ee, $12, $f8, $08

Jump_004_4967:
	xor a
	ldh [$ffe8], a

jr_004_496a:
	ld a, $5b
	call Call_3C01
	ld hl, $c390
	add hl, de
	ld [hl], $01
	push bc
	ldh a, [$ffe8]
	ld c, a
	ld hl, $4963
	add hl, bc
	ldh a, [$ffd7]
	add [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $4965
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ld hl, $c290
	add hl, de
	ld [hl], $01
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c360
	add hl, de
	ld [hl], $05
	pop bc
	ldh a, [$ffe8]
	inc a
	ldh [$ffe8], a
	cp $02
	jr nz, jr_004_496a

	jp Call_04_6D4D


	db $21, $10, $c3, $09, $36, $7e, $cd, $91, $08, $36, $a0, $c9

Call_04_49C1::
	call Call_380E
	call Call_3F12
	call Call_04_4E52
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_49D0::
	dw Jump_04_49D4
	dw Jump_04_4DF9

Jump_04_49D4::
	ld hl, $c360
	add hl, bc
	ld [hl], $50
	ldh a, [$fff0]
	rst $00

JumpTable_04_49DD::
	dw Jump_04_49E5
	dw Jump_04_4A25
	dw Jump_04_4A64
	dw Jump_04_4A78

Jump_04_49E5::
	ld a, [$c157]
	cp $05
	jr nz, jr_004_49f3

	call Call_3B8D
	ld a, $08
	ldh [$fff2], a

jr_004_49f3:
	call Call_0891
	jr nz, jr_004_4a24

	ld [hl], $50
	ld a, [$c1ae]
	cp $02
	jr nc, jr_004_4a24

	ld a, $1b
	call Call_3C01
	call Call_27ED
	and $3f
	add $40
	ld hl, $c200
	add hl, de
	ld [hl], a
	call Call_27ED
	and $3f
	add $30
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c310
	add hl, de
	ld [hl], $70

jr_004_4a24:
	ret


Jump_04_4A25::
	call Call_04_4DB1
	call Call_04_7F36
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	cp $a0
	jr z, jr_004_4a39

	dec [hl]
	dec [hl]

jr_004_4a39:
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_4a63

	ld [hl], b
	ld a, $50
	ld [$c157], a
	ld a, $04
	ld [$c158], a
	call Call_0891
	ld [hl], $40
	call Call_08D7
	ld a, [$c146]
	and a
	jr nz, jr_004_4a60

	call Call_0887
	ld [hl], $14

jr_004_4a60:
	call Call_3B8D

jr_004_4a63:
	ret


Jump_04_4A64::
	call Call_04_4DB1
	call Call_04_7F36
	call Call_0891
	jr nz, jr_004_4a72

	call Call_3B8D

jr_004_4a72:
	call Call_04_4B28
	jp Call_3BBF


Jump_04_4A78::
	call Call_04_4DB1
	call Call_04_7F36
	call Call_08E2
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_4a9f

	cp $01
	jp z, Jump_004_4967

	ldh [$ffa1], a
	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_4a9a

	ld hl, $ff99
	dec [hl]

jr_004_4a9a:
	ld a, $06
	jp Call_3B87


jr_004_4a9f:
	call Call_04_4B4C
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_4ac5

	inc a
	call Call_3B87
	call Call_088C
	jr nz, jr_004_4ac5

	ld [hl], $28
	ld hl, $c2b0
	add hl, bc
	dec [hl]

jr_004_4ac5:
	xor a
	ldh [$ffe8], a
	ld a, $14
	call Call_04_4B31
	call Call_3BEB
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	ld hl, $c300
	add hl, bc
	or [hl]
	jr nz, jr_004_4ae9

	call Call_04_4B28
	call Call_3BBF
	ld a, $01
	ldh [$ffe8], a
	call Call_3BEB

jr_004_4ae9:
	ld a, $14
	call Call_04_4B31
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_4b0b

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_004_4b0b

	call Call_088C
	ld [hl], $50
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_004_4b0b

	inc [hl]

jr_004_4b0b:
	ret


	db $08, $14, $00, $0c, $08, $15, $00, $0b, $08, $16, $00, $08, $08, $17, $00, $06
	db $08, $18, $00, $04, $08, $03, $08, $03, $08, $0c, $02, $0c

Call_04_4B28::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	sla a
	sla a

Call_04_4B31::
	ld e, a
	ld d, b
	ld hl, $4b0c
	add hl, de
	push hl
	pop de
	push bc
	sla c
	sla c
	ld hl, $d580
	add hl, bc
	ld c, $04

jr_004_4b44:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_004_4b44

	pop bc
	ret


Call_04_4B4C::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_4B52::
	dw Jump_04_4B76
	dw Jump_04_4BC1

	db $10, $0c, $06, $02, $f0, $f4, $fa, $fe, $10, $0c, $06, $02, $f0, $f4, $fa, $fe
	db $02, $06, $0c, $10, $02, $06, $0c, $10, $fe, $fa, $f4, $f0, $fe, $fa, $f4, $f0

Jump_04_4B76::
	call Call_0891
	and a
	jr nz, jr_004_4bc0

	call Call_27ED
	and $1f
	add $10
	ld [hl], a
	ld hl, $c2d0
	add hl, bc
	inc [hl]
	ld e, $00
	ldh a, [$ffee]
	cp $50
	jr c, jr_004_4b92

	inc e

jr_004_4b92:
	ld d, $00
	ldh a, [$ffec]
	cp $48
	jr c, jr_004_4b9c

	inc d
	inc d

jr_004_4b9c:
	ld a, d
	or e
	sla a
	sla a
	push af
	call Call_27ED
	and $03
	pop de
	or d
	ld e, a
	ld d, b
	ld hl, $4b56
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4b66
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_004_4bc0:
	ret


Jump_04_4BC1::
	call Call_0891
	jr z, jr_004_4bd1

	and $0e
	jr nz, jr_004_4bd0

	call Call_04_6D9D
	call Call_3B9E

jr_004_4bd0:
	ret


jr_004_4bd1:
	ld [hl], $30
	ld hl, $c2d0
	add hl, bc
	ld [hl], b
	ret


	db $f0, $f0, $60, $00, $f0, $f8, $62, $00, $f0, $00, $70, $00, $f0, $08, $70, $20
	db $f0, $10, $62, $20, $f0, $18, $60, $20, $00, $f0, $64, $00, $00, $f8, $6e, $00
	db $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $6e, $20, $00, $18, $64, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $f0, $68, $00, $f0, $f8, $6a, $00, $f0, $00, $7e, $00, $f0, $08, $7e, $20
	db $f0, $10, $6a, $20, $f0, $18, $68, $20, $00, $f0, $6c, $00, $00, $f8, $6e, $00
	db $00, $00, $72, $00, $00, $08, $72, $20, $00, $10, $6e, $20, $00, $18, $6c, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $f0, $60, $00, $f0, $f8, $62, $00, $f0, $00, $62, $20, $f0, $08, $62, $00
	db $f0, $10, $62, $20, $f0, $18, $60, $20, $00, $f0, $64, $00, $00, $f8, $66, $00
	db $00, $00, $66, $20, $00, $08, $66, $00, $00, $10, $66, $20, $00, $18, $64, $20
	db $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $ec, $60, $00, $f0, $f4, $62, $00, $f0, $fc, $62, $20, $f0, $04, $74, $00
	db $f0, $0c, $62, $00, $f0, $14, $62, $20, $f0, $1c, $60, $20, $00, $ec, $64, $00
	db $00, $f4, $66, $00, $00, $fc, $66, $20, $00, $04, $76, $00, $00, $0c, $66, $00
	db $00, $14, $66, $20, $00, $1c, $64, $20, $00, $00, $ff, $00, $00, $00, $ff, $00
	db $f0, $e8, $60, $00, $f0, $f0, $62, $00, $f0, $f8, $62, $20, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $62, $00, $f0, $18, $62, $20, $f0, $20, $60, $20
	db $00, $e8, $64, $00, $00, $f0, $66, $00, $00, $f8, $66, $20, $00, $00, $7a, $00
	db $00, $08, $7a, $20, $00, $10, $66, $00, $00, $18, $66, $20, $00, $20, $64, $20
	db $f0, $e8, $60, $00, $f0, $f0, $62, $00, $f0, $f8, $62, $20, $f0, $00, $78, $00
	db $f0, $08, $78, $20, $f0, $10, $62, $00, $f0, $18, $62, $20, $f0, $20, $60, $20
	db $00, $e8, $64, $00, $00, $f0, $66, $00, $00, $f8, $66, $20, $00, $00, $7c, $00
	db $00, $08, $7c, $20, $00, $10, $66, $00, $00, $18, $66, $20, $00, $20, $64, $20
	db $f0, $e6, $60, $00, $f0, $ee, $62, $00, $f0, $f6, $62, $20, $f0, $fe, $78, $00
	db $f0, $0a, $78, $20, $f0, $12, $62, $00, $f0, $1a, $62, $20, $f0, $22, $60, $20
	db $00, $e6, $64, $00, $00, $ee, $66, $00, $00, $f6, $66, $20, $00, $fe, $7c, $00
	db $00, $0a, $7c, $20, $00, $12, $66, $00, $00, $1a, $66, $20, $00, $22, $64, $20
	db $0c, $f5, $26, $00, $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00
	db $0c, $0d, $26, $00, $0c, $13, $26, $00

Call_04_4DB1::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
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
	rla
	rl d
	and $c0
	ld e, a
	ld hl, $4bd9
	add hl, de
	ld c, $10
	call Call_3D26
	ld a, $10
	call Call_3DD0
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_4df8

	ldh a, [$ffef]
	sub $08
	ldh [$ffec], a
	ld hl, $4d99
	ld c, $06
	call Call_3D26
	ld a, $06
	call Call_3DD0
	call Call_3DBA

jr_004_4df8:
	ret


Jump_04_4DF9::
	call Call_04_5000
	ldh a, [$ffea]
	cp $05
	jp z, Jump_004_4e60

	ld hl, $c420
	add hl, bc
	ldh a, [$ffe7]
	ld [hl], a
	ldh a, [$fff0]
	rst $00

JumpTable_04_4E0D::
	dw Jump_04_4E13
	dw Jump_04_4E1B
	dw Jump_04_4E26

Jump_04_4E13::
	call Call_0891
	ld [hl], $40
	jp Call_3B8D


Jump_04_4E1B::
	call Call_0891
	jr nz, jr_004_4e25

	ld [hl], $a0
	call Call_3B8D

jr_004_4e25:
	ret


Jump_04_4E26::
	call Call_0891
	jr nz, jr_004_4e4f

	ld e, $0f
	ld d, b

jr_004_4e2e:
	ld a, c
	cp e
	jr z, jr_004_4e43

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_4e43

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $5b
	jr z, jr_004_4e4c

jr_004_4e43:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_4e2e

	jp Jump_004_5746


jr_004_4e4c:
	jp Call_04_6D4D


jr_004_4e4f:
	jp Call_04_50F3


Call_04_4E52::
	call Call_0887
	jr z, jr_004_4e5f

	ld a, $02
	ldh [$ffa1], a
	ld a, $6a
	ldh [$ff9d], a

jr_004_4e5f:
	ret


Jump_004_4e60:
	call Call_04_7F36
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	cp $02
	jr nz, jr_004_4e83

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_4e82

	call Call_3B8D
	ld [hl], $02
	ld a, $24
	ldh [$fff2], a
	call Call_3DAF
	jr jr_004_4e83

jr_004_4e82:
	inc [hl]

jr_004_4e83:
	call Call_04_6D53
	xor a
	ldh [$ffe8], a
	ldh a, [$fff0]
	rst $00

JumpTable_04_4E8C::
	dw Jump_04_4EA4
	dw Jump_04_4EEB
	dw Jump_04_4F65
	dw Jump_04_4F80

	db $10, $0c, $00, $f4, $f0, $f4, $00, $0c, $00, $0c, $10, $0c, $00, $f4, $f0, $f4

Jump_04_4EA4::
	ld a, $18
	call Call_04_4B31
	call Call_3BB4
	call Call_0891
	jr nz, jr_004_4ee7

	call Call_27ED
	and $07
	ld e, a
	ld d, b
	ld hl, $4e94
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $4e9c
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_27ED
	and $03
	jr nz, jr_004_4ed8

	ld a, $18
	call Call_3C25

jr_004_4ed8:
	call Call_27ED
	and $0f
	ld hl, $c320
	add hl, bc
	add $08
	ld [hl], a
	call Call_3B8D

jr_004_4ee7:
	ld a, b
	jp Call_3B87


Jump_04_4EEB::
	call Call_0891
	and a
	jr nz, jr_004_4f60

	call Call_04_6D9D
	call Call_3B9E
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld a, $18
	call Call_04_4B31
	call Call_3BBF
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_4f14

	call Call_3BEB
	xor a

jr_004_4f14:
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_4f60

	ld [hl], b
	ld hl, $c440
	add hl, bc
	ld [hl], b
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sub $e0
	and $80
	jr z, jr_004_4f49

	ld a, $18
	ld [$c157], a
	ld a, $0b
	ldh [$fff2], a
	ld a, [$c146]
	and a
	jr nz, jr_004_4f49

	call Call_0887
	ld [hl], $0e
	ld hl, $c320
	add hl, bc
	ld [hl], b
	jr jr_004_4f57

jr_004_4f49:
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	ld [hl], b
	cp $f2
	jr nc, jr_004_4f57

	ld a, $20
	ldh [$fff2], a

jr_004_4f57:
	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $20

jr_004_4f60:
	ld a, $01
	jp Call_3B87


Jump_04_4F65::
	ld hl, $c320
	add hl, bc
	ld [hl], $60
	call Call_04_6DD6
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $70
	jr c, jr_004_4f7f

	call Call_0891
	ld [hl], $30
	call Call_3B8D

jr_004_4f7f:
	ret


Jump_04_4F80::
	ld a, $ff
	call Call_3B87
	call Call_0891
	jr nz, jr_004_4faf

	ld [hl], $18
	ld hl, $c440
	add hl, bc
	ld [hl], $01
	call Call_3B8D
	ld [hl], $01
	ld hl, $c320
	add hl, bc
	ld [hl], $c0
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	ld [hl], a
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	ld [hl], a
	ld a, $08
	ldh [$fff2], a

jr_004_4faf:
	ret


	db $f0, $f8, $60, $00, $f0, $00, $62, $00, $f0, $08, $62, $20, $f0, $10, $60, $20
	db $00, $f8, $64, $00, $00, $00, $66, $00, $00, $08, $66, $20, $00, $10, $64, $20
	db $f0, $f8, $68, $00, $f0, $00, $6a, $00, $f0, $08, $6a, $20, $f0, $10, $68, $20
	db $00, $f8, $6c, $00, $00, $00, $66, $00, $00, $08, $66, $20, $00, $10, $6c, $20
	db $0c, $fb, $26, $00, $0c, $01, $26, $00, $0c, $07, $26, $00, $0c, $0d, $26, $00

Call_04_5000::
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
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
	ld hl, $4fb0
	add hl, de
	ld c, $08
	call Call_3D26
	ld a, $08
	call Call_3DD0
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, jr_004_504a

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_504a

	ldh a, [$ffef]
	sub $02
	ldh [$ffec], a
	ld hl, $4ff0
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0

jr_004_504a:
	jp Call_3DBA


	db $cd, $91, $08, $36, $ff, $21, $10, $c4, $09, $36, $08, $21, $60, $c3, $09, $36
	db $12, $21, $00, $c2, $09, $cd, $69, $50, $21, $10, $c2, $09, $7e, $c6, $08, $77
	db $3e, $ff, $c3, $87, $3b

Call_04_5072::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_5078::
	dw Jump_04_5080
	dw Jump_04_5470
	dw Jump_04_550B
	dw Jump_04_559C

Jump_04_5080::
	xor a
	ld [$c155], a
	call Call_3F12
	call Call_380E
	call Call_04_5438
	ldh a, [$ffea]
	cp $05
	jp z, Jump_004_5115

	ld hl, $c420
	add hl, bc
	ldh a, [$ffe7]
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_50A1::
	dw Jump_04_50A7
	dw Jump_04_50E3
	dw Jump_04_50ED

Jump_04_50A7::
	call Call_0891
	ld [hl], $80
	ld e, $0f
	ld d, b

jr_004_50af:
	ld a, c
	cp e
	jr z, jr_004_50d7

	ld hl, $c340
	add hl, de
	ld a, [hl]
	and $80
	jr nz, jr_004_50d7

	ld hl, $c280
	add hl, de
	ld a, [hl]
	cp $05
	jr c, jr_004_50d7

	ld [hl], $01
	ld hl, $c480
	add hl, de
	ld [hl], $1f
	ld hl, $c340
	add hl, de
	ld a, [hl]
	and $f0
	or $02
	ld [hl], a

jr_004_50d7:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_50af

jr_004_50dd:
	ld hl, $c440
	add hl, bc
	inc [hl]
	ret


Jump_04_50E3::
	call Call_0891
	jr nz, jr_004_50ec

	ld [hl], $ff
	jr jr_004_50dd

jr_004_50ec:
	ret


Jump_04_50ED::
	call Call_0891
	jp z, Jump_004_5746

Call_04_50F3::
	and $07
	jr nz, jr_004_5114

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
	call Call_04_59FB

jr_004_5114:
	ret


Jump_004_5115:
	call Call_04_7F36
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5126

	ld hl, $c390
	add hl, bc
	ld [hl], $ff

jr_004_5126:
	ld hl, $c340
	add hl, bc
	ld [hl], $08
	ldh a, [$fff0]
	rst $00

JumpTable_04_512F::
	dw Jump_04_5135
	dw Jump_04_5160
	dw Jump_04_51F1

Jump_04_5135::
	call Call_0891
	jr nz, jr_004_513f

	ld [hl], $ff
	call Call_3B8D

jr_004_513f:
	ret


	db $03, $03, $03, $03, $03, $02, $01, $00, $01, $00, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00

Jump_04_5160::
	call Call_0891
	jr z, jr_004_5174

	rra
	rra
	rra
	and $1f
	ld e, a
	ld d, b
	ld hl, $5140
	add hl, de
	ld a, [hl]
	jp Call_3B87


jr_004_5174:
	call Call_3B8D
	call Call_088C
	ld [hl], $a0
	call Call_0887
	ld [hl], $ff
	ld a, $b6
	call Call_2197
	ret


	db $03, $02, $04, $02, $28, $38, $48, $58, $68, $78, $28, $78, $28, $78, $28, $38
	db $48, $58, $68, $78, $30, $30, $30, $30, $30, $30, $40, $40, $50, $50, $60, $60
	db $60, $60, $60, $60, $28, $38, $48, $58, $68, $78, $18, $88, $18, $88, $18, $88
	db $18, $88, $28, $38, $48, $58, $68, $78, $20, $20, $20, $20, $20, $20, $30, $30
	db $40, $40, $50, $50, $60, $60, $70, $70, $70, $70, $70, $70, $00, $13, $01, $12
	db $02, $11, $03, $10, $04, $0f, $05, $0e, $06, $0d, $07, $0c, $08, $0b, $09, $0a
	db $18, $88, $18, $88, $20, $70, $70, $20, $00, $ff

Jump_04_51F1::
	ldh a, [$ffe7]
	and $3f
	jr nz, jr_004_5203

	call Call_27ED
	and $01
	jr nz, jr_004_5203

	call Call_0891
	ld [hl], $1f

jr_004_5203:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld e, a
	ld d, b
	ld hl, $51ef
	add hl, de
	ld a, [hl]
	ld [$c155], a
	call Call_0887
	jr nz, jr_004_527c

	call Call_27ED
	and $0f
	add $18
	ld [hl], a
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $14
	jr c, jr_004_527c

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $04
	jr c, jr_004_527c

	ld a, $5a
	call Call_3C01
	jr c, jr_004_527c

	ld hl, $c2b0
	add hl, de
	ld [hl], $01

jr_004_5240:
	call Call_27ED
	and $0f
	ld hl, $c2c0
	add hl, bc
	cp [hl]
	jr z, jr_004_5240

	ld [hl], a
	push bc
	ld c, a
	ld hl, $518b
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $519b
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c2e0
	add hl, de
	ld [hl], $7f
	ld hl, $c340
	add hl, de
	ld [hl], $c2
	ld hl, $c350
	add hl, de
	ld [hl], $00
	ld hl, $c430
	add hl, de
	ld [hl], $00
	pop bc

jr_004_527c:
	call Call_088C
	jr nz, jr_004_52d2

	ld [hl], $40
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $14
	jr nc, jr_004_52d2

	ld a, $5a
	call Call_3C01
	jr c, jr_004_52d2

	ld hl, $c2b0
	add hl, de
	ld [hl], $02
	push bc
	ld hl, $c3d0
	add hl, bc
	ld c, [hl]
	inc [hl]
	ld hl, $51d3
	add hl, bc
	ld c, [hl]
	ld hl, $51ab
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $51bf
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c350
	add hl, de
	ld [hl], $00
	ld hl, $c430
	add hl, de
	ld [hl], $00
	ld hl, $c4d0
	add hl, de
	ld [hl], $02
	pop bc

jr_004_52d2:
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5349

	ld [hl], $40
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $04
	jr nc, jr_004_5349

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	cp $12
	jr c, jr_004_5349

	ld a, $5a
	call Call_3C01
	jr c, jr_004_5349

	ld hl, $c2b0
	add hl, de
	ld [hl], $03
	push bc
	ld hl, $c2d0
	add hl, bc
	ld c, [hl]
	inc [hl]
	ld hl, $51e7
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh [$ffee], a
	ld hl, $51eb
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh [$ffef], a
	ld hl, $c340
	add hl, de
	ld [hl], $12
	ld hl, $c350
	add hl, de
	ld [hl], $00
	ld hl, $c430
	add hl, de
	ld [hl], $00
	ld hl, $c4d0
	add hl, de
	ld [hl], $1b
	push de
	pop bc
	ld hl, $c240
	add hl, bc
	ld [hl], $01
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5348

	call Call_04_6D4D

jr_004_5348:
	pop bc

jr_004_5349:
	call Call_0891
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5187
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5368

	ld a, $02
	call Call_3B87

jr_004_5368:
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5387

	dec [hl]
	rra
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $5388
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $c340
	add hl, bc
	ld [hl], $48

jr_004_5387:
	ret


	db $02, $01, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $01, $02
	db $f8, $f0, $70, $00, $f8, $f8, $72, $00, $f8, $10, $72, $20, $f8, $18, $70, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20
	db $f8, $f0, $74, $00, $f8, $f8, $76, $00, $f8, $10, $76, $20, $f8, $18, $74, $20
	db $08, $f8, $7c, $00, $08, $00, $7e, $00, $08, $08, $7e, $20, $08, $10, $7c, $20
	db $f8, $f0, $74, $00, $f8, $f8, $76, $00, $f8, $10, $76, $20, $f8, $18, $74, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20
	db $f8, $f0, $78, $00, $f8, $f8, $7a, $00, $f8, $10, $7a, $20, $f8, $18, $78, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20
	db $f8, $f0, $70, $00, $f8, $f8, $72, $00, $f8, $10, $72, $20, $f8, $18, $70, $20
	db $08, $f8, $60, $00, $08, $00, $62, $00, $08, $08, $62, $20, $08, $10, $60, $20

Call_04_5438::
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
	ld hl, $5398
	add hl, de
	ld c, $08
	call Call_3D26
	ret


	db $68, $00, $68, $20, $6a, $00, $6a, $20, $6c, $00, $6c, $20, $6e, $00, $6e, $20
	db $00, $01, $02, $03, $03, $03, $03, $03, $03, $02, $01, $00, $00, $00, $00, $00

Jump_04_5470::
	ld de, $5450
	call Call_3C3B
	call Call_04_7F36
	call Call_0891
	jp z, Call_04_6D4D

	cp $50
	jr nz, jr_004_5488

	ld hl, $fff2
	ld [hl], $40

jr_004_5488:
	rra
	rra
	rra
	and $0f
	ld e, a
	ld d, b
	ld hl, $5460
	add hl, de
	ld a, [hl]
	call Call_3B87
	cp $03
	jr nz, jr_004_54fa

	ld a, [$c11c]
	cp $06
	jr z, jr_004_54fa

	ldh a, [$ffa2]
	and a
	jr nz, jr_004_54fa

	call Call_04_6E08
	add $08
	cp $10
	jr nc, jr_004_54fa

	call Call_04_6E18
	add $08
	cp $10
	jr nc, jr_004_54fa

	ld a, $0c
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
	call Call_04_6E08
	add $03
	cp $06
	jr nc, jr_004_54fa

	call Call_04_6E18
	add $03
	cp $06
	jr nc, jr_004_54fa

	ldh a, [$ffee]
	ldh [$ff98], a
	ld a, $06
	ld [$c11c], a
	call Call_093B
	ld [$c198], a
	call Call_0891
	ld [hl], $40
	ld a, $50
	ld [$dbcb], a

jr_004_54fa:
	ret


	db $40, $00, $40, $20, $42, $00, $42, $20, $70, $00, $70, $20, $72, $00, $72, $20

Jump_04_550B::
	ld de, $54fb
	ldh a, [$fff7]
	cp $01
	jr nz, jr_004_5517

	ld de, $5503

jr_004_5517:
	call Call_3C3B
	call Call_08E2
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5594

	call Call_04_7F36
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $07
	jr nz, jr_004_553c

	ld a, $3f
	ldh [$fff2], a

jr_004_553c:
	ldh a, [$fff0]
	rst $00

JumpTable_04_553F::
	dw Jump_04_5545
	dw Jump_04_5564
	dw Jump_04_5583

Jump_04_5545::
	call Call_0891
	ld [hl], $60
	call Call_3B8D
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp $01
	jp z, Jump_004_5608

	cp $10
	jp z, Jump_004_5616

	cp $20
	jp z, Jump_004_560f

	jp Jump_004_5624


Jump_04_5564::
	call Call_3BEB
	call Call_0891
	jr z, jr_004_557a

	cp $30
	jr c, jr_004_5582

	and $03
	jr nz, jr_004_5579

	ld hl, $c310
	add hl, bc
	inc [hl]

jr_004_5579:
	ret


jr_004_557a:
	call Call_3B8D
	ld a, $18
	call Call_3C25

jr_004_5582:
	ret


Jump_04_5583::
	call Call_04_6D9D
	call Call_3B9E
	call Call_3BB4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5597

Jump_004_5594:
jr_004_5594:
	call Call_3E64

jr_004_5597:
	ret


	db $f0, $10, $f0, $30

Jump_04_559C::
	ld de, $5598
	call Call_3C3B
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5594

	call Call_04_7F36
	ldh a, [$fff0]
	rst $00

JumpTable_04_55B0::
	dw Jump_04_55B6
	dw Jump_04_55C2
	dw Jump_04_55E1

Jump_04_55B6::
	call Call_04_561D
	call Call_3B8D
	call Call_0891
	ld [hl], $60
	ret


Jump_04_55C2::
	call Call_3BEB
	call Call_0891
	jr z, jr_004_55d8

	cp $30
	jr c, jr_004_55e0

	and $03
	jr nz, jr_004_55d7

	ld hl, $c310
	add hl, bc
	inc [hl]

jr_004_55d7:
	ret


jr_004_55d8:
	call Call_3B8D
	ld a, $18
	call Call_3C25

jr_004_55e0:
	ret


Jump_04_55E1::
	call Call_04_6D9D
	call Call_3B9E
	call Call_3BB4
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_004_5594

	ret


	db $10, $12, $11, $13, $10, $12, $11, $13, $14, $16, $15, $17, $76, $77, $76, $77
	db $76, $49, $76, $49

Jump_004_5608:
	ld de, $55fc
	ld a, $aa
	jr jr_004_5629

Jump_004_560f:
	ld de, $5600
	ld a, $ae
	jr jr_004_5629

Jump_004_5616:
	ld de, $5604
	ld a, $1d
	jr jr_004_5629

Call_04_561D::
	ld de, $55f8
	ld a, $0d
	jr jr_004_5629

Jump_004_5624:
	ld de, $55f4
	ld a, $0d

jr_004_5629:
	ldh [$ffd7], a
	push de
	ldh a, [$ffef]
	sub $0f
	ldh [$ffcd], a
	ldh a, [$ffee]
	sub $07
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
	ldh a, [$ffd7]
	ld [hl], a
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


Jump_004_5680:
	xor a
	ld [$d201], a
	ld e, $80
	ld hl, $d100

jr_004_5689:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_004_5689

	ret


	db $06, $07, $00, $01, $02, $03, $04, $05

Call_04_5697::
	call Call_04_7F36
	jp Call_3BB4


Call_04_569D::
	call Call_380E
	call Call_04_5697
	call Call_04_58F8
	call Call_08E2
	ld a, [$c124]
	and a
	jp nz, Jump_004_5680

	call Call_3F12
	ldh a, [$ffea]
	cp $05
	jp z, Jump_004_5786

	ldh a, [$fff0]
	rst $00

JumpTable_04_56BD::
	dw Jump_04_56C5
	dw Jump_04_56D4
	dw Jump_04_56E5
	dw Jump_04_5712

Jump_04_56C5::
	call Call_0891
	ld [hl], $60
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_3B8D
	ret


Jump_04_56D4::
	call Call_0891
	jr nz, jr_004_56e4

	ld [hl], $ff
	ld hl, $c420
	add hl, bc
	ld [hl], $ff
	call Call_3B8D

jr_004_56e4:
	ret


Jump_04_56E5::
	call Call_0891
	and $1f
	jr nz, jr_004_56f9

	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $04
	jr z, jr_004_56fa

	inc [hl]
	call Call_04_59FB

jr_004_56f9:
	ret


jr_004_56fa:
	call Call_0891
	ld [hl], $30
	jp Call_3B8D


	db $00, $06, $08, $06, $00, $fa, $f8, $fa, $f8, $fa, $00, $06, $08, $06, $00, $fa

Jump_04_5712::
	call Call_0891
	jp z, Jump_004_5746

	and $03
	jr nz, jr_004_5745

	ld a, [hl]
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $5702
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $570a
	add hl, de
	ldh a, [$ffec]
	add [hl]
	ldh [$ffec], a
	call Call_04_59FB
	call Call_0891
	cp $10
	jr nz, jr_004_5745

	ld hl, $c2d0
	add hl, bc
	ld [hl], $05

jr_004_5745:
	ret


Jump_004_5746:
	ld a, $36
	call Call_3C01
	ldh a, [$ffd7]
	cp $88
	jr c, jr_004_5753

	ld a, $88

jr_004_5753:
	cp $18
	jr nc, jr_004_5759

	ld a, $18

jr_004_5759:
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	cp $70
	jr c, jr_004_5766

	ld a, $70

jr_004_5766:
	cp $20
	jr nc, jr_004_576c

	ld a, $20

jr_004_576c:
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c320
	add hl, de
	ld [hl], $10
	ldh a, [$ffda]
	ld hl, $c310
	add hl, de
	ld [hl], a
	ld hl, $fff4
	ld [hl], $1a
	jp Call_04_6D4D


Jump_004_5786:
	call Call_3DBA
	call Call_04_7F36
	xor a
	ld [$d3d6], a
	ld e, $10
	ld hl, $c360
	add hl, bc
	ld a, [hl]
	cp $02
	jr c, jr_004_57a3

	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_57ad

jr_004_57a3:
	call Call_04_57BB
	ld a, $01
	ld [$d3d6], a
	ld e, $0b

jr_004_57ad:
	ld hl, $d201
	ld a, [hl]
	inc a
	ld [hl], a
	cp e
	jr c, Call_04_57BB

	ld [hl], b
	ld a, $1b
	ldh [$fff4], a

Call_04_57BB::
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
	call Call_04_5ADC
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	srl e
	ld d, b
	ld hl, $568f
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20

Jump_04_5818::
	db $08, $f8, $6c, $00, $08, $00, $6e, $00, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $68, $00, $f8, $00, $6a, $00, $f8, $08, $62, $20, $f8, $10, $60, $20

Jump_04_5838::
	db $08, $f8, $68, $40, $08, $00, $6a, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $6c, $40, $f8, $00, $6e, $40, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $64, $40, $f8, $00, $66, $40, $f8, $08, $66, $60, $f8, $10, $64, $60

Jump_04_5878::
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6e, $60, $f8, $10, $6c, $60
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $62, $60, $08, $10, $60, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $6a, $20, $f8, $10, $68, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6a, $60, $08, $10, $68, $60
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $60, $40, $08, $00, $62, $40, $08, $08, $6e, $20, $08, $10, $6c, $20
	db $70, $00, $70, $20, $72, $00, $72, $20, $74, $00, $74, $20, $76, $00, $76, $20

Call_04_58F8::
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $05
	jp nc, Jump_004_59fa

	ld hl, $c340
	add hl, bc
	ld [hl], $08
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
	ld hl, $57e8
	add hl, de
	ld c, $08
	call Call_3D26
	ld hl, $c340
	add hl, bc
	ld [hl], $02
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $04
	jp nc, Jump_004_59fa

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
	ld de, $58e8
	call Call_3C3B
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $03
	jp nc, Jump_004_59fa

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
	ld de, $58e8
	call Call_3C3B
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	cp $02
	jr nc, jr_004_59fa

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
	ld de, $58e8
	call Call_3C3B
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_59fa

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
	ld de, $58e8
	call Call_3C3B
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_59fa

	ld hl, $c430
	add hl, bc
	ld [hl], $90
	call Call_3BEB
	ld hl, $c430
	add hl, bc
	ld [hl], $d0

Jump_004_59fa:
jr_004_59fa:
	ret


Call_04_59FB::
	call Call_04_7F3C
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $02
	call Call_0953
	ld a, $13
	ldh [$fff4], a
	ret


Call_04_5A10::
	ld hl, $c460
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
	sla e
	sla e
	ld d, b
	ld hl, $d000
	add hl, de
	push de
	ld e, $20

jr_004_5a27:
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, jr_004_5a27

	pop de
	ld hl, $d100
	add hl, de
	ld e, $20

jr_004_5a36:
	xor a
	ld [hli], a
	dec e
	ld a, e
	cp $00
	jr nz, jr_004_5a36

	ret


	db $70, $00, $70, $20, $70, $40, $70, $60, $72, $00, $74, $00, $74, $20, $72, $20
	db $76, $00, $78, $00, $78, $20, $76, $20, $76, $40, $78, $40, $78, $60, $76, $60
	db $7a, $00, $7a, $20, $7c, $00, $7c, $20, $03, $03, $05, $05, $00, $00, $04, $04
	db $02, $02, $06, $06, $01, $01, $07, $07, $00, $06, $0c, $0e, $10, $0e, $0c, $06
	db $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa, $00, $06, $0c, $0e

Call_04_5A8B::
	call Call_04_5B75
	ld a, [$c124]
	and a
	jr nz, jr_004_5a9c

	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5a9f

jr_004_5a9c:
	call Call_04_5A10

jr_004_5a9f:
	call Call_04_7F36
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	and $1f
	ld [hl], a
	ldh [$ffd7], a
	ld hl, $c460
	add hl, bc
	ld e, [hl]
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
	call Call_04_6D53
	call Call_3BB4

Call_04_5ADC::
	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5ae7

	call Call_04_6D9D

jr_004_5ae7:
	call Call_3B9E
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5b1e

	ld e, $08
	bit 0, a
	jr nz, jr_004_5b06

	ld e, $00
	bit 1, a
	jr nz, jr_004_5b06

	ld e, $04
	bit 2, a
	jr nz, jr_004_5b06

	ld e, $0c

jr_004_5b06:
	ld hl, $c2b0
	add hl, bc
	ld [hl], e
	call Call_27ED
	rra
	jr c, jr_004_5b19

	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_004_5b19:
	call Call_0891
	ld [hl], $10

jr_004_5b1e:
	call Call_088C
	jr nz, jr_004_5b5c

	ld [hl], $04
	ldh a, [$ffeb]
	cp $59
	jr nz, jr_004_5b2d

	ld [hl], $06

jr_004_5b2d:
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
	ld hl, $5a67
	add hl, de
	ld a, [hl]
	call Call_3B87
	ld hl, $5a77
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ld hl, $5a7b
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a

jr_004_5b5c:
	call Call_0891
	jr nz, jr_004_5b74

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

jr_004_5b74:
	ret


Call_04_5B75::
	ld de, $5a3f
	call Call_3C3B
	call Call_04_7F36
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	ldh [$ffd7], a
	ld hl, $c460
	add hl, bc
	ld e, [hl]
	sla e
	sla e
	sla e
	sla e
	sla e
	ld d, b
	push de
	push de
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	sub $09
	and $1f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	pop de
	ld hl, $d100
	add hl, de
	ldh a, [$ffd7]
	sub $09
	and $1f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, $08
	ldh [$fff1], a
	ld de, $5a3f
	call Call_3C3B
	pop de
	push de
	ld hl, $d000
	add hl, de
	ldh a, [$ffd7]
	sub $10
	and $1f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	pop de
	ld hl, $d100
	add hl, de
	ldh a, [$ffd7]
	sub $10
	and $1f
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	ldh [$ffec], a
	ld a, $09
	ldh [$fff1], a
	ld de, $5a3f
	call Call_3C3B
	call Call_3DBA
	ret


	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $0c, $f4, $08, $f8

Call_04_5BFF::
	call Call_04_5D9D
	jr jr_004_5c0d

Call_04_5C04::
	call Call_04_7F23
	ld de, $5bf3
	call Call_3C3B

jr_004_5c0d:
	ldh a, [$fff0]
	and a
	jr z, jr_004_5c3a

	ld a, $ff
	call Call_3B87
	call Call_04_6E08
	add $10
	cp $20
	jr nc, jr_004_5c39

	call Call_04_6E18
	add $10
	cp $20
	jr nc, jr_004_5c39

	ld a, [$c133]
	and a
	jr z, jr_004_5c39

	call Call_3B8D
	ld [hl], b
	ld hl, $c300
	add hl, bc
	ld [hl], $30

jr_004_5c39:
	ret


jr_004_5c3a:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	xor c
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $00
	jr z, jr_004_5c51

	ld a, $ff
	call Call_3B87

jr_004_5c51:
	call Call_04_7F36
	call Call_04_6D53
	call Call_3BEB
	call Call_04_6D9D
	call Call_04_6DD6
	call Call_04_5CFF
	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_004_5cfe

	call Call_3BBF
	call Call_0891
	jr nz, jr_004_5c83

	call Call_27ED
	and $1f
	add $20
	ld [hl], a
	and $01
	ld hl, $c2b0
	add hl, bc
	ld [hl], a

jr_004_5c83:
	call Call_088C
	jr nz, jr_004_5c97

	call Call_27ED
	and $0f
	add $18
	ld [hl], a
	and $01
	ld hl, $c2c0
	add hl, bc
	ld [hl], a

jr_004_5c97:
	ldh a, [$ffe7]
	xor c
	and $03
	jr nz, jr_004_5cfe

	ld hl, $c2b0
	add hl, bc
	ldh a, [$ffee]
	cp $28
	jr nc, jr_004_5cac

	ld [hl], $00
	jr jr_004_5cb2

jr_004_5cac:
	cp $78
	jr c, jr_004_5cb7

	ld [hl], $01

jr_004_5cb2:
	call Call_0891
	ld [hl], $20

jr_004_5cb7:
	ld hl, $c2c0
	add hl, bc
	ldh a, [$ffec]
	cp $28
	jr nc, jr_004_5cc5

	ld [hl], $00
	jr jr_004_5ccb

jr_004_5cc5:
	cp $60
	jr c, jr_004_5cd0

	ld [hl], $01

jr_004_5ccb:
	call Call_088C
	ld [hl], $20

jr_004_5cd0:
	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5bfb
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_004_5ce6

	inc [hl]
	inc [hl]

jr_004_5ce6:
	dec [hl]
	ld hl, $c2c0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $5bfd
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	sub [hl]
	and $80
	jr nz, jr_004_5cfd

	inc [hl]
	inc [hl]

jr_004_5cfd:
	dec [hl]

Jump_004_5cfe:
jr_004_5cfe:
	ret


Call_04_5CFF::
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_5d1c

	ld hl, $c310
	add hl, bc
	ld a, [hl]
	cp $10
	jr z, jr_004_5d1c

	bit 7, a
	jr z, jr_004_5d15

	inc [hl]
	jr jr_004_5d1c

jr_004_5d15:
	cp $10
	jr nc, jr_004_5d1b

	inc [hl]
	ret


jr_004_5d1b:
	dec [hl]

jr_004_5d1c:
	ret


	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $66, $00, $08, $08, $68, $00, $08, $10, $6a, $00
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $64, $00, $08, $00, $6c, $00, $08, $08, $6e, $00, $08, $10, $6a, $00
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6a, $20, $08, $00, $68, $20, $08, $08, $66, $20, $08, $10, $64, $20
	db $f8, $f8, $60, $00, $f8, $00, $62, $00, $f8, $08, $62, $20, $f8, $10, $60, $20
	db $08, $f8, $6a, $20, $08, $00, $6e, $20, $08, $08, $6c, $20, $08, $10, $64, $20

Call_04_5D9D::
	call Call_04_7F23
	ldh a, [$ffed]
	push af
	rla
	and $40
	ldh [$ffd7], a
	pop af
	and $0f
	ldh [$ffed], a
	ld hl, $c3b0
	add hl, bc
	ld a, [hl]
	rla
	rla
	rla
	rla
	rla
	and $e0
	ld hl, $ffd7
	add [hl]
	ld e, a
	ld d, b
	ld hl, $5d1d
	add hl, de
	ld c, $08
	call Call_3D26
	ret


	db $70, $00, $72, $00, $72, $20, $70, $20, $74, $00, $74, $20, $00, $00, $00, $00
	db $7a, $00, $7a, $20, $ff, $00, $ff, $00, $76, $00, $78, $00, $78, $20, $76, $20

Call_04_5DE9::
	ldh a, [$fff1]
	cp $03
	jr nz, jr_004_5e14

	ldh a, [$ffee]
	sub $08
	ldh [$ffee], a
	ld a, $06
	ldh [$fff1], a
	ld de, $5dc9
	call Call_3C3B
	ldh a, [$ffee]
	add $10
	ldh [$ffee], a
	ld a, $07
	ldh [$fff1], a
	ld de, $5dc9
	call Call_3C3B
	call Call_3DBA
	jr jr_004_5e1a

jr_004_5e14:
	ld de, $5dc9
	call Call_3C3B

jr_004_5e1a:
	call Call_04_7F36
	call Call_04_6D53
	ldh a, [$fff0]
	rst $00

JumpTable_04_5E23::
	dw Jump_04_5E29
	dw Jump_04_5E6E
	dw Jump_04_5EAF

Jump_04_5E29::
	call Call_3BB4
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_0891
	cp $18
	jr nz, jr_004_5e42

	call Call_04_5EC0
	and a

jr_004_5e42:
	jr nc, jr_004_5e6a

	call Call_04_6E08
	add $20
	cp $40
	jr nc, jr_004_5e6a

	call Call_04_6E18
	add $20
	cp $40
	jr nc, jr_004_5e6a

	ld hl, $c420
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_5e6a

	call Call_0891
	ld [hl], $20
	call Call_3B8D
	ld a, $3c
	ldh [$fff2], a

jr_004_5e6a:
	ret


	db $04, $03, $02

Jump_04_5E6E::
	call Call_0891
	cp $18
	jp nc, Call_3BB4

	and a
	jr nz, jr_004_5e9c

	ld [hl], $40
	call Call_3B8D
	ld a, $ff
	call Call_3B87
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


jr_004_5e9c:
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5e6b
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $02, $03, $04

Jump_04_5EAF::
	call Call_0891
	cp $18
	jr nc, jr_004_5eee

	and a
	jr nz, jr_004_5edf

	ld [hl], $30
	call Call_3B8D
	ld [hl], b
	ret


Call_04_5EC0::
	ld a, $58
	call Call_3C01
	jr c, jr_004_5ede

	ld hl, $c200
	add hl, de
	ldh a, [$ffd7]
	ld [hl], a
	ld hl, $c210
	add hl, de
	ldh a, [$ffd8]
	ld [hl], a
	push bc
	push de
	pop bc
	ld a, $18
	call Call_3C25
	pop bc

jr_004_5ede:
	ret


jr_004_5edf:
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $5eac
	add hl, de
	ld a, [hl]
	call Call_3B87

jr_004_5eee:
	ret


	db $7c, $00, $7c, $20, $7e, $00, $7e, $20

Call_04_5EF7::
	ld de, $5eef
	call Call_3C3B
	call Call_04_7F36
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_04_6D9D
	call Call_3BA9
	call Call_3BCA
	call Call_3BEB
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5f24

	call Call_04_6D4D
	call Call_04_6BF2

jr_004_5f24:
	ret


	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $7c, $00, $00, $f8, $7e, $00, $00, $00, $70, $00, $00, $08, $72, $00
	db $00, $f0, $78, $00, $00, $f8, $7a, $00, $00, $00, $74, $00, $00, $08, $76, $00
	db $9a, $10, $9c, $10

Call_04_5F59::
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_5f93

	ldh a, [$ffec]
	add $04
	ldh [$ffec], a
	ld de, $5f55
	call Call_3C3B
	call Call_04_6D9D
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_5f8e

	call Call_04_6D4D
	xor a
	ld [$db7f], a
	ld [$c167], a
	jp Call_0898


jr_004_5f8e:
	ld a, $02
	ldh [$ffa1], a
	ret


jr_004_5f93:
	ldh a, [$fff9]
	and a
	jp nz, Jump_004_607b

	ld hl, $c340
	add hl, bc
	ld [hl], $84
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	ldh [$ffe8], a
	ld a, [$c19f]
	and a
	ld hl, $5f45
	jr nz, jr_004_5fbf

	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc [hl]
	ld hl, $5f25
	and $30
	jr z, jr_004_5fbf

	ld hl, $5f35

jr_004_5fbf:
	ld c, $04
	call Call_3D26
	ld a, $04
	call Call_3DD0
	call Call_04_7B6B
	ldh a, [$fff0]
	rst $00

JumpTable_04_5FCF::
	dw Jump_04_5FD5
	dw Jump_04_5FE3
	dw Jump_04_6016

Jump_04_5FD5::
	call Call_04_7BD3
	jr nc, jr_004_5fe2

	ld a, $45
	call Call_2197
	call Call_3B8D

jr_004_5fe2:
	ret


Jump_04_5FE3::
	ld a, [$c19f]
	and a
	jr nz, jr_004_600e

	call Call_3B8D
	ld a, [$c177]
	and a
	jr z, jr_004_5ff8

	ld [hl], b
	ld a, $46
	jp Call_2197


jr_004_5ff8:
	ld a, [$db5e]
	sub $10
	ld a, [$db5d]
	sbc $00
	jr c, jr_004_600f

	ld a, $0a
	ld [$db92], a
	ld a, $47
	call Call_2197

jr_004_600e:
	ret


jr_004_600f:
	ld [hl], b
	ld a, $4e
	call Call_2197
	ret


Jump_04_6016::
	ld a, [$c19f]
	and a
	jr nz, jr_004_6022

	call Call_3EAD
	call Call_04_67C6

jr_004_6022:
	ret


	db $58, $00, $5a, $00, $56, $20, $ff, $00, $5c, $00, $5e, $00, $58, $00, $5a, $00
	db $58, $00, $5a, $00, $5c, $00, $5e, $00, $5c, $00, $5e, $00, $56, $00, $ff, $00
	db $5e, $20, $5c, $20, $58, $00, $5a, $00, $06, $16, $10, $10, $38, $38, $39, $39
	db $16, $38, $f6, $00, $f1, $f0, $f0, $f0, $f0, $fe, $04, $f2, $00, $f0, $fa, $00
	db $00, $f8, $f8, $f8, $f2, $fe, $e8, $00, $e0, $e8, $00, $00, $00, $00, $14, $10
	db $e0, $f8, $10, $00, $00, $00, $00, $f0

Jump_004_607b:
	ld a, $01
	ld [$c167], a
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_6086::
	dw Jump_04_60A7
	dw Jump_04_6246
	dw Jump_04_6401
	dw Jump_04_66EC
	dw Jump_04_5818

	db $60, $18, $88, $40, $4c, $34, $68, $50, $01, $00, $00, $01, $00, $02, $02, $02
	db $03, $03, $00, $3e, $1e, $10, $30

Jump_04_60A7::
	ld a, $02
	ldh [$ffa1], a
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_60f7

	inc [hl]
	push bc
	ld c, $05

jr_004_60b7:
	ld a, $54
	call Call_3C01
	ld hl, $608d
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $6092
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $6097
	add hl, bc
	ld a, [hl]
	ld hl, $c380
	add hl, de
	ld [hl], a
	ld hl, $609c
	add hl, bc
	ld a, [hl]
	ld hl, $c2b0
	add hl, de
	ld [hl], a
	ld hl, $60a1
	add hl, bc
	ld a, [hl]
	ld hl, $c2e0
	add hl, de
	ld [hl], a
	dec c
	jr nz, jr_004_60b7

	xor a
	ld [$d004], a
	pop bc
	ret


jr_004_60f7:
	ldh a, [$fff1]
	ld e, a
	ld d, b
	ld hl, $604b
	add hl, de
	ld a, [hl]
	ldh [$ff9d], a
	ld hl, $6055
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ffee], a
	ld hl, $605f
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ldh [$ffec], a
	ld de, $6023
	call Call_3C3B
	ldh a, [$fff0]
	rst $00

JumpTable_04_611D::
	dw Jump_04_612B
	dw Jump_04_6153
	dw Jump_04_61BC
	dw Jump_04_61BD
	dw Jump_04_6207
	dw Jump_04_6214
	dw Jump_04_6231

Jump_04_612B::
	ld a, [$c19f]
	and a
	jr nz, jr_004_6143

	ldh a, [$ffcc]
	and $30
	jr z, jr_004_6143

	call Call_3B8D
	call Call_0891
	ld [hl], $23
	xor a
	ld [$d002], a

jr_004_6143:
	ld a, $09
	call Call_04_6192
	ret


	db $01, $08, $08, $08, $08, $08, $01, $02, $03, $00

Jump_04_6153::
	call Call_0891
	jr nz, jr_004_618e

	call Call_3B8D
	ld a, $02
	ld [$c3b0], a
	ld a, $54
	call Call_3C01
	ld hl, $c200
	add hl, de
	ld [hl], $78
	ld hl, $c210
	add hl, de
	ld [hl], $18
	ld hl, $c240
	add hl, de
	ld [hl], $e2
	ld hl, $c250
	add hl, de
	ld [hl], $fa
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $c2e0
	add hl, de
	ld [hl], $14
	ld a, $08
	ldh [$fff2], a
	ret


jr_004_618e:
	rra
	rra
	and $1f

Call_04_6192::
	ld e, a
	ld d, b
	ld hl, $6149
	add hl, de
	ld a, [hl]
	ld [$c3b0], a
	ld e, a
	ld d, b
	ld hl, $6069
	add hl, de
	ldh a, [$ff98]
	add [hl]
	ldh [$ffee], a
	ld hl, $6072
	add hl, de
	ldh a, [$ff99]
	add [hl]
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $6232
	call Call_3C3B
	jp Call_3DBA


Jump_04_61BC::
	ret


Jump_04_61BD::
	ld a, [$c19f]
	and a
	jr nz, jr_004_61fe

	ld a, [$c177]
	and a
	jr nz, jr_004_61f6

	ld a, [$d004]
	cp $05
	jr c, jr_004_61db

	ld a, $4b
	call Call_2197
	call Call_3B8D
	ld [hl], $05
	ret


jr_004_61db:
	ld a, [$db5e]
	sub $10
	ld a, [$db5d]
	sbc $00
	jr c, jr_004_61ff

	ld a, $0a
	ld [$db92], a
	ld a, $47
	call Call_2197
	call Call_3B8D
	ld [hl], b
	ret


jr_004_61f6:
	ld a, $46
	call Call_2197
	call Call_3B8D

jr_004_61fe:
	ret


jr_004_61ff:
	ld a, $4e
	call Call_2197
	jp Call_3B8D


Jump_04_6207::
	ld a, [$c19f]
	and a
	jr nz, jr_004_6213

	call Call_3EAD
	call Call_04_67C6

jr_004_6213:
	ret


Jump_04_6214::
	ld a, [$c19f]
	and a
	jr nz, jr_004_6230

	call Call_3B8D
	ld [hl], $04
	ld a, [$c177]
	and a
	jr nz, jr_004_622b

	ld a, $4c
	call Call_2197
	ret


jr_004_622b:
	ld a, $46
	call Call_2197

jr_004_6230:
	ret


Jump_04_6231::
	ret


	db $50, $00, $54, $00, $50, $00, $52, $00, $50, $40, $54, $00, $54, $40, $50, $40
	db $54, $60, $50, $60

Jump_04_6246::
	ld a, c
	ld [$d003], a
	ld de, $6232
	call Call_3C3B
	ldh a, [$ffee]
	ld [$d000], a
	ldh a, [$ffef]
	ld [$d001], a
	call Call_04_7F36
	ldh a, [$fff0]
	rst $00

JumpTable_04_6260::
	dw Jump_04_6264
	dw Jump_04_62CD

Jump_04_6264::
	call Call_04_6DAA
	call Call_04_6DA0
	ldh a, [$ffcb]
	and $01
	jr z, jr_004_6281

	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_6281

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6281

	inc [hl]
	jr jr_004_6286

jr_004_6281:
	call Call_0891
	jr nz, jr_004_62ac

jr_004_6286:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_6296

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cp $20
	jr z, jr_004_6296

	inc [hl]

jr_004_6296:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	cp $03
	ld [hl], a
	jr nz, jr_004_62ac

	xor a
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_62ac

	inc [hl]

jr_004_62ac:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $2a
	jr c, jr_004_62cc

	call Call_3DAF
	call Call_3B8D

Jump_004_62bb:
	ldh a, [$ffec]
	ldh [$ffd8], a
	ldh a, [$ffee]
	ldh [$ffd7], a
	ld a, $01
	call Call_0953
	ld a, $0e
	ldh [$fff2], a

jr_004_62cc:
	ret


Jump_04_62CD::
	ld hl, $c3b0
	ld [hl], $00
	call Call_0891
	jr z, jr_004_62dc

	ld hl, $c3b0
	ld [hl], $04

jr_004_62dc:
	call Call_088C
	jr z, jr_004_62e6

	ld hl, $c3b0
	ld [hl], $05

jr_004_62e6:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_04_6D9D
	ldh a, [$ffe7]
	and $07
	jr nz, jr_004_6319

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	sub $04
	jr z, jr_004_630a

	and $80
	jr z, jr_004_6309

	inc [hl]
	inc [hl]

jr_004_6309:
	dec [hl]

jr_004_630a:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6319

	and $80
	jr z, jr_004_6318

	inc [hl]
	inc [hl]

jr_004_6318:
	dec [hl]

jr_004_6319:
	ldh a, [$ffcc]
	and $30
	jr z, jr_004_637e

	call Call_0891
	ld [hl], $08
	ldh a, [$ff98]
	push af
	sub $17
	ldh [$ff98], a
	ld a, $04
	call Call_3C25
	pop af
	ldh [$ff98], a
	ldh a, [$ffec]
	cp $25
	jr nc, jr_004_6372

	ldh a, [$ffee]
	cp $70
	jr c, jr_004_6372

	ld hl, $c290
	ld [hl], $03
	ld a, $48
	call Call_2197
	call Call_04_6D4D
	ld e, $0f
	ld d, b

jr_004_634f:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_636c

	ld hl, $c2b0
	add hl, de
	ld a, [hl]
	cp $02
	jr c, jr_004_636c

	ld hl, $c290
	add hl, de
	ld a, [hl]
	cp $02
	jr c, jr_004_636c

	and $01
	ld [hl], a

jr_004_636c:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_634f

jr_004_6372:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	jr jr_004_63a3

jr_004_637e:
	ldh a, [$ffcc]
	and $05
	jr z, jr_004_63a3

	ldh a, [$ffec]
	cp $30
	jr c, jr_004_63a3

	ld hl, $c300
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_63a3

	ld hl, $c250
	add hl, bc
	ld [hl], $fa

Jump_04_6398::
	ld hl, $c300
	add hl, bc
	ld [hl], $50
	call Call_088C
	ld [hl], $10

jr_004_63a3:
	ldh a, [$ffee]
	ld hl, $c200
	add hl, bc
	cp [hl]
	jr nz, jr_004_63b5

	ldh a, [$ffef]
	ld hl, $c210
	add hl, bc
	cp [hl]
	jr z, jr_004_63c7

jr_004_63b5:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push af
	push hl
	and $80
	jr z, jr_004_63c1

	ld [hl], b

jr_004_63c1:
	call Call_3B9E
	pop hl
	pop af
	ld [hl], a

jr_004_63c7:
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_63d3

	xor a
	call Call_3B87

jr_004_63d3:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	rla
	jr c, jr_004_63e0

	ld a, $02
	call Call_3B87

jr_004_63e0:
	ret


	db $4c, $00, $4a, $00, $4c, $00, $4e, $00, $48, $00, $4a, $00, $48, $00, $4e, $00
	db $4a, $20, $4c, $20, $4e, $20, $4c, $20, $4a, $20, $48, $20, $4e, $20, $48, $20

Jump_04_6401::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_640f

	ldh a, [$fff1]
	add $04
	ldh [$fff1], a

jr_004_640f:
	ld de, $63e1
	call Call_3C3B

Jump_004_6415:
	call Call_04_7F36
	call Call_04_6D9D
	ldh a, [$fff0]
	rst $00

JumpTable_04_641E::
	dw Jump_04_642A
	dw Jump_04_6462
	dw Jump_04_64B9
	dw Jump_04_64F4
	dw Jump_04_6541
	dw Jump_04_6652

Jump_04_642A::
	call Call_04_6766
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_004_6703

	call Call_0891
	jr nz, jr_004_6449

	ld [hl], $30
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call Call_3B8D

jr_004_6449:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_645e

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_645e

	and $80
	jr z, jr_004_645d

	inc [hl]
	inc [hl]

jr_004_645d:
	dec [hl]

jr_004_645e:
	jr jr_004_64a7

	db $10, $f0

Jump_04_6462::
	call Call_04_6766
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $03
	jp z, Jump_004_672d

	call Call_0891
	jr nz, jr_004_647a

	ld [hl], $50
	call Call_3B8D
	ld [hl], b

jr_004_647a:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_64a7

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, $6460
	add hl, de
	sub [hl]
	pop hl
	and a
	jr z, jr_004_64a7

	and $80
	jr z, jr_004_64a6

	inc [hl]
	inc [hl]

jr_004_64a6:
	dec [hl]

jr_004_64a7:
	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $34
	jr nc, jr_004_64b6

	inc [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], b

jr_004_64b6:
	ret


	db $f2, $14

Jump_04_64B9::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	call Call_0891
	jr nz, jr_004_64cb

	call Call_3B8D

jr_004_64cb:
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $64b7
	add hl, de
	ld a, [$d000]
	add [hl]
	ldh [$ff98], a
	ld a, [$d001]
	ldh [$ff99], a
	ld a, $04
	call Call_3C25
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	jp Call_04_6D9D


Jump_04_64F4::
	ldh a, [$ffe7]
	rra
	rra
	and $01
	add $02
	call Call_3B87
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, [$d000]
	add $04
	ldh [$ff98], a
	ld a, [$d001]
	ldh [$ff99], a
	ld a, $10
	call Call_3C25
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_04_6D9D
	ld a, [$d000]
	ld hl, $ffee
	sub [hl]
	add $08
	cp $10
	jr nc, jr_004_653c

	call Call_3DAF
	call Call_3B8D
	ld a, [$d003]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld [hl], b

jr_004_653c:
	ret


	db $54, $00, $08, $f8

Jump_04_6541::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $653f
	add hl, de
	ldh a, [$ffee]
	add [hl]
	ldh [$ffee], a
	ld hl, $fff1
	ld [hl], b
	ld de, $653d
	call Call_3CD0
	call Call_3DBA
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $07
	jr nz, jr_004_65a2

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $00
	ldh [$ff98], a
	ld a, $59
	ldh [$ff99], a
	ld a, $08
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
	jr z, jr_004_658e

	dec [hl]
	dec [hl]

jr_004_658e:
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	sub [hl]
	inc [hl]
	and $80
	jr z, jr_004_659c

	dec [hl]
	dec [hl]

jr_004_659c:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a

jr_004_65a2:
	ldh a, [$ffcc]
	and $30
	jr z, jr_004_65f8

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $03
	jr nz, jr_004_65b8

	call Call_27ED
	and $03
	jr z, jr_004_65f8

jr_004_65b8:
	ldh a, [$ff98]
	push af
	sub $14
	ldh [$ff98], a
	ldh a, [$ff99]
	push af
	add $08
	ldh [$ff99], a
	ld a, $03
	call Call_3C30
	ldh a, [$ffd7]
	ld hl, $c250
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
	and $80
	jr z, jr_004_65dc

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

jr_004_65dc:
	ldh a, [$ffd8]
	ld hl, $c240
	add hl, bc
	sub [hl]
	inc [hl]
	inc [hl]
	and $80
	jr z, jr_004_65ed

	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]

jr_004_65ed:
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	call Call_0891
	ld [hl], $10

jr_004_65f8:
	call Call_04_6D9D
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_660b

	rlca
	and $01
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_004_660b:
	ld hl, $c3b0
	ld [hl], $05
	call Call_0891
	jr z, jr_004_6620

	ldh a, [$ffe7]
	and $30
	jr z, jr_004_6620

	ld hl, $c3b0
	ld [hl], $07

jr_004_6620:
	ldh a, [$ffec]
	cp $2c
	jr nc, jr_004_663e

	ldh a, [$ffee]
	cp $74
	jr c, jr_004_663e

	call Call_3B8D
	ld hl, $c240
	add hl, bc
	ld [hl], $05
	ld hl, $c250
	add hl, bc
	ld [hl], $f0
	jp Jump_004_62bb


jr_004_663e:
	ldh a, [$ffee]
	cp $03
	jr nc, jr_004_6651

	ld hl, $c290
	ld [hl], $03
	ld a, $49
	call Call_2197
	jp Call_04_6D4D


jr_004_6651:
	ret


Jump_04_6652::
	ld hl, $c3b0
	ld [hl], $01
	call Call_04_6D9D
	ld hl, $c250
	add hl, bc
	inc [hl]
	nop
	ld a, [hl]
	cp $0c
	jr nz, jr_004_66cb

	ld hl, $c290
	ld [hl], $03
	ld a, c
	cp $0f
	jr nz, jr_004_66b0

	ldh a, [$fff8]
	and $10
	jr nz, jr_004_66b0

	ld a, $01
	ldh [$fff2], a
	ldh a, [$fff6]
	ld e, a
	ld d, $01
	ld hl, $d900
	add hl, de
	ld a, [hl]
	or $10
	ld [hl], a
	ldh [$fff8], a
	ld a, [$db5c]
	inc a
	ld [$db5c], a
	cp $04
	jr nz, jr_004_66a4

	xor a
	ld [$db5c], a
	ld hl, $db93
	ld [hl], $40
	ld hl, $db5b
	inc [hl]
	ld a, $ff
	jr jr_004_66a6

jr_004_66a4:
	ld a, $fe

jr_004_66a6:
	call Call_2185
	ld hl, $db90
	ld [hl], $20
	jr jr_004_66c8

jr_004_66b0:
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cp $03
	ld e, $14
	ld a, $4a
	jr z, jr_004_66c1

	ld e, $05
	ld a, $4d

jr_004_66c1:
	ld hl, $db90
	ld [hl], e
	call Call_2197

jr_004_66c8:
	call Call_04_6D4D

jr_004_66cb:
	ret


	db $44, $00, $42, $00, $44, $00, $46, $00, $40, $00, $42, $00, $40, $00, $46, $00
	db $42, $20, $44, $20, $46, $20, $44, $20, $42, $20, $40, $20, $46, $20, $40, $20

Jump_04_66EC::
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_004_66fa

	ldh a, [$fff1]
	add $04
	ldh [$fff1], a

jr_004_66fa:
	ld de, $66cc
	call Call_3C3B
	jp Jump_004_6415


Jump_004_6703:
	call Call_0891
	jr nz, jr_004_6715

	ld [hl], $18
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	xor $01
	ld [hl], a
	call Call_3B8D

jr_004_6715:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_672a

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_672a

	and $80
	jr z, jr_004_6729

	inc [hl]
	inc [hl]

jr_004_6729:
	dec [hl]

jr_004_672a:
	ret


	db $08, $f8

Jump_004_672d:
	call Call_0891
	jr nz, jr_004_6738

	ld [hl], $50
	call Call_3B8D
	ld [hl], b

jr_004_6738:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_6765

	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push hl
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, $00
	ld hl, $672b
	add hl, de
	sub [hl]
	pop hl
	and a
	jr z, jr_004_6765

	and $80
	jr z, jr_004_6764

	inc [hl]
	inc [hl]

jr_004_6764:
	dec [hl]

jr_004_6765:
	ret


Call_04_6766::
	ld a, [$d002]
	and a
	jr nz, jr_004_67c5

	ld a, [$d003]
	ld e, a
	ld d, b
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_67c5

	ld hl, $c290
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_67c5

	ld a, [$d000]
	ld hl, $ffee
	sub [hl]
	rlca
	rlca
	and $01
	ld hl, $c380
	add hl, bc
	cp [hl]
	jr nz, jr_004_67c5

	ld a, [$d000]
	ld hl, $ffee
	sub [hl]
	add $18
	cp $30
	jr nc, jr_004_67c5

	ld a, [$d001]
	ld hl, $ffef
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_67c5

	call Call_3B8D
	ld [hl], $02
	ld hl, $d002
	inc [hl]
	ld hl, $d004
	inc [hl]
	call Call_0891
	call Call_27ED
	and $3f
	add $30
	ld [hl], a

jr_004_67c5:
	ret


Call_04_67C6::
	call Call_090F
	ldh a, [$ff98]
	swap a
	and $0f
	ld e, a
	ldh a, [$ff99]
	sub $08
	and $f0
	or e
	ld [$d416], a
	xor a
	ld [$c167], a
	ret


	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $7c, $00, $7c, $20, $7e, $00, $7e, $20

Call_04_67EF::
	ld hl, $d45e
	inc [hl]
	ld de, $67df
	ldh a, [$fff7]
	cp $01
	jr nz, jr_004_67ff

	ld de, $67e7

jr_004_67ff:
	call Call_3C3B
	call Call_04_7F36
	call Call_3BEB
	ldh a, [$fff0]
	rst $00

JumpTable_04_680B::
	dw Jump_04_6813
	dw Jump_04_68C9

	db $00, $03, $01, $02

Jump_04_6813::
	call Call_0887
	jr nz, jr_004_681e

	ld [hl], $10
	call Call_3B8D
	ret


jr_004_681e:
	ld a, [$c11c]
	cp $00
	jp nz, Jump_004_68b0

	ldh a, [$ff9a]
	push af
	ldh a, [$ff9b]
	push af
	ld e, $00
	ldh a, [$ffeb]
	cp $52
	ld a, $14
	jr nz, jr_004_6839

	inc e
	ld a, $08

jr_004_6839:
	push de
	call Call_3C30
	pop de
	ldh a, [$ffd7]
	bit 0, e
	jr z, jr_004_6846

	cpl
	inc a

jr_004_6846:
	ldh [$ff9b], a
	ldh a, [$ffd8]
	bit 0, e
	jr z, jr_004_6850

	cpl
	inc a

jr_004_6850:
	ldh [$ff9a], a
	push bc
	call Call_20D6
	call Call_3E49
	pop bc
	pop af
	ldh [$ff9b], a
	pop af
	ldh [$ff9a], a
	xor a
	ld [$c144], a
	ldh a, [$ffeb]
	cp $52
	jp nz, Jump_004_68b0

	ld a, [$c146]
	and a
	jr nz, jr_004_68a0

	call Call_04_6E08
	add $04
	cp $08
	jr nc, jr_004_68a0

	call Call_04_6E18
	add $04
	cp $08
	jr nc, jr_004_68a0

	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffec]
	ldh [$ff99], a
	ld a, $06
	ld [$c11c], a
	call Call_093B
	ld [$c198], a
	ld a, $ff
	ld [$dbcb], a
	ld a, $0c
	ldh [$fff3], a
	ret


jr_004_68a0:
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $03
	ld e, a
	ld d, b
	ld hl, $680f
	add hl, de
	ld a, [hl]
	ldh [$ff9e], a

Jump_004_68b0:
	call Call_04_68D9
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_004_68c8

	ld a, $1f
	ldh [$fff4], a

jr_004_68c8:
	ret


Jump_04_68C9::
	call Call_0887
	jr nz, jr_004_68d4

	ld [hl], $40
	call Call_3B8D
	ld [hl], b

jr_004_68d4:
	ld a, $00
	jp Call_3B87


Call_04_68D9::
	ld e, $0f
	ld d, b

Jump_004_68dc:
	push de
	ld a, e
	cp c
	jp z, Jump_004_6971

	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jp z, Jump_004_6971

	call Call_3DBA
	push bc
	push de
	pop bc
	ldh a, [$ffe7]
	xor c
	and $01
	jr nz, jr_004_6970

	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ldh a, [$ffee]
	ldh [$ff98], a
	ldh a, [$ffef]
	ldh [$ff99], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	push af
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	push af
	ld a, $10
	call Call_3C30
	ld e, $00
	ldh a, [$ffeb]
	cp $52
	jr nz, jr_004_6920

	inc e

jr_004_6920:
	ldh a, [$ffd7]
	bit 0, e
	jr nz, jr_004_6928

	cpl
	inc a

jr_004_6928:
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ldh a, [$ffd8]
	bit 0, e
	jr nz, jr_004_6935

	cpl
	inc a

jr_004_6935:
	ld hl, $c240
	add hl, bc
	ld [hl], a
	call Call_3DBA
	call Call_04_6D9D
	call Call_3B9E
	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_695e

	ldh a, [$ffec]
	ld hl, $ff99
	sub [hl]
	add $02
	cp $04
	jr nc, jr_004_695e

	call Call_04_6D4D

jr_004_695e:
	pop af
	ld hl, $c250
	add hl, bc
	ld [hl], a
	pop af
	ld hl, $c240
	add hl, bc
	ld [hl], a
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a

jr_004_6970:
	pop bc

Jump_004_6971:
	pop de
	dec e
	ld a, e
	cp $ff
	jp nz, Jump_004_68dc

	ret


Call_04_697A::
	ldh a, [$fff7]
	cp $14
	jr c, jr_004_6995

	ldh a, [$fff8]
	and $10
	jp nz, Call_04_6D4D

	ld hl, $c460
	add hl, bc
	ld [hl], $ff
	ld hl, $c4e0
	add hl, bc
	ld [hl], $3c
	jr jr_004_69a1

jr_004_6995:
	ld e, a
	ld d, b
	ld hl, $db65
	add hl, de
	ld a, [hl]
	and $01
	jp nz, Call_04_6D4D

jr_004_69a1:
	call Call_04_6A94
	call Call_3DBA
	call Call_04_7F36
	call Call_04_6D53
	ld hl, $c430
	add hl, bc
	ld [hl], $00
	call Call_3BB4
	ldh a, [$fff0]
	rst $00

JumpTable_04_69B9::
	dw Jump_04_69BF
	dw Jump_04_6A0A
	dw Jump_04_6A37

Jump_04_69BF::
	call Call_0891
	jr nz, jr_004_69f1

	ldh a, [$ffe7]
	xor c
	and $07
	jr nz, jr_004_69d0

	ld a, $04
	call Call_3C25

jr_004_69d0:
	call Call_04_6D9D
	call Call_3B9E
	call Call_04_6E08
	add $30
	cp $60
	jr nc, jr_004_69f1

	call Call_04_6E18
	add $30
	cp $60
	jr nc, jr_004_69f1

	call Call_0891
	ld [hl], $28
	call Call_3B8D

jr_004_69f0:
	ret


jr_004_69f1:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_69f0

Jump_004_69f7:
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $04, $0c, $00, $08

Jump_04_6A0A::
	call Call_0891
	jr nz, jr_004_6a34

	call Call_04_6E28
	ld hl, $c380
	add hl, bc
	ld [hl], e
	ld d, b
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $0f
	ld hl, $6a06
	add hl, de
	cp [hl]
	jr nz, jr_004_6a34

	ld hl, $c2b0
	add hl, bc
	ld [hl], $38
	ld hl, $c440
	add hl, bc
	ld [hl], b
	call Call_3B8D

jr_004_6a34:
	jp Jump_004_69f7


Jump_04_6A37::
	call Call_04_6DF0
	ld hl, $c2b0
	add hl, bc
	dec [hl]
	dec [hl]
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_6a4b

	ld hl, $c440
	add hl, bc
	inc [hl]

jr_004_6a4b:
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6a57

	and $80
	jr z, jr_004_6a73

jr_004_6a57:
	ld [hl], b
	call Call_3B8D
	ld [hl], b
	call Call_0891
	ld [hl], $10
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $6a06
	add hl, de
	ld a, [hl]
	add $08
	ld hl, $c3d0
	add hl, bc
	ld [hl], a

jr_004_6a73:
	ret


	db $70, $00, $72, $00, $74, $00, $76, $00, $78, $00, $78, $20, $0a, $06, $03, $01
	db $00, $01, $03, $06, $0a, $0e, $11, $13, $14, $13, $11, $0e, $0a, $06, $03, $01

Call_04_6A94::
	ld de, $6a74
	call Call_3C3B
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6afe

	xor a
	ldh [$ffd7], a
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	ld hl, $c2d0
	add hl, bc
	bit 1, a
	jr nz, jr_004_6ad8

	cp $01
	ld a, [hl]
	jr nz, jr_004_6abd

	ld hl, $ffd7
	inc [hl]
	cpl
	inc a

jr_004_6abd:
	ld hl, $ffee
	add [hl]
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ldh a, [$ffd7]
	and a
	ld a, [hl]
	jr z, jr_004_6acf

	cpl
	and $0f

jr_004_6acf:
	ld hl, $ffec
	add [hl]
	add $f3
	ld [hl], a
	jr jr_004_6b1e

jr_004_6ad8:
	cp $02
	ld a, [hl]
	jr nz, jr_004_6ae3

	ld hl, $ffd7
	inc [hl]
	cpl
	inc a

jr_004_6ae3:
	ld hl, $ffec
	add [hl]
	ld [hl], a
	ld hl, $c440
	add hl, bc
	ldh a, [$ffd7]
	and a
	ld a, [hl]
	jr nz, jr_004_6af5

	cpl
	and $0f

jr_004_6af5:
	ld hl, $ffee
	add [hl]
	add $f8
	ld [hl], a
	jr jr_004_6b1e

jr_004_6afe:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $6a80
	add hl, de
	ldh a, [$ffec]
	add [hl]
	add $f0
	ldh [$ffec], a
	ld hl, $6a84
	add hl, de
	ldh a, [$ffee]
	add [hl]
	add $f3
	ldh [$ffee], a

jr_004_6b1e:
	ld a, $02
	ldh [$fff1], a
	ld de, $6a74
	call Call_3C3B
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	and a
	jp z, Jump_004_6bb0

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and $80
	jr nz, jr_004_6b4b

	call Call_088C
	jr nz, jr_004_6b4b

	ld hl, $c430
	add hl, bc
	ld [hl], $40
	call Call_3BB4
	call Call_04_6BB1

jr_004_6b4b:
	ldh a, [$ffee]
	add $04
	ld hl, $c200
	add hl, bc
	sub [hl]
	sra a
	sra a
	ldh [$ffd7], a
	ldh [$ffd9], a
	ldh a, [$ffec]
	ld hl, $c210
	add hl, bc
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
	call Call_3DBA
	ld a, $03

jr_004_6b7c:
	ldh [$ffdb], a
	ldh a, [$ffec]
	ld hl, $ffd8
	add [hl]
	ld [de], a
	inc de
	ldh a, [$ffee]
	ld hl, $ffd7
	add [hl]
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
	jr nz, jr_004_6b7c

	ld a, $03
	call Call_3DD0

Jump_004_6bb0:
	ret


Call_04_6BB1::
	ldh a, [$ffee]
	ldh [$ffdb], a
	swap a
	and $0f
	ld e, a
	ldh a, [$ffec]
	sub $10
	add $04
	ldh [$ffdc], a
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
	cp $00
	jr z, jr_004_6bff

	cp $01
	jr nz, jr_004_6bff

	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	call Call_088C
	ld [hl], $08
	ld a, $07
	ldh [$fff2], a

Call_04_6BF2::
	ldh a, [$ffee]
	ldh [$ffd7], a
	ldh a, [$ffec]
	ldh [$ffd8], a
	ld a, $05
	call Call_0953

jr_004_6bff:
	ret


	db $70, $00, $70, $20, $78, $00, $7a, $00, $74, $00, $76, $00, $7c, $00, $7e, $00
	db $72, $00, $72, $20, $7e, $20, $7c, $20, $76, $20, $74, $20, $7a, $20, $78, $20
	db $10, $0e, $0c, $06, $00, $fa, $f4, $f2, $f0, $f2, $f4, $fa, $00, $06, $0c, $0e
	db $10, $0e, $0c, $06

Call_04_6C34::
	ldh a, [$fff0]
	and a
	jp nz, Jump_004_6ce2

	ld de, $6c00
	call Call_3C3B
	call Call_04_7F36
	call Call_3BBF
	call Call_3B9E
	call Call_0891
	jr z, jr_004_6c87

	cp $10
	jr nz, jr_004_6c86

	ld a, $2b
	call Call_3C01
	jr c, jr_004_6c86

	ld a, $08
	ldh [$fff4], a
	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ldh a, [$ffd9]
	ld hl, $c380
	add hl, de
	ld [hl], a
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a

jr_004_6c86:
	ret


jr_004_6c87:
	ld hl, $c3d0
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
	and $07
	jr nz, jr_004_6ce1

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	inc a
	and $0f
	ld [hl], a
	srl a
	ld hl, $c3b0
	add hl, bc
	ld [hl], a
	ld a, $2a
	call Call_3C01
	jr c, jr_004_6ce1

	ldh a, [$ffd7]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ldh a, [$ffd8]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c290
	add hl, de
	ld [hl], $01
	ld hl, $c2b0
	add hl, de
	ld [hl], c
	ld hl, $c340
	add hl, de
	ld [hl], $c0
	push bc
	ldh a, [$ffd9]
	ld c, a
	ld hl, $6c24
	add hl, bc
	ld a, [hl]
	ld hl, $c240
	add hl, de
	ld [hl], a
	ld hl, $6c20
	add hl, bc
	ld a, [hl]
	ld hl, $c250
	add hl, de
	ld [hl], a
	pop bc

jr_004_6ce1:
	ret


Jump_004_6ce2:
	call Call_3BA9
	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Call_04_6D4D

	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_6d2f

	ldh a, [$ffef]
	ld hl, $ff99
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_6d2f

	call Call_04_6D4D
	ld a, [$dbc7]
	and a
	jr nz, jr_004_6d2f

	ld hl, $c2b0
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $c2e0
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_004_6d2f

	ld [hl], $20
	ld hl, $c420
	add hl, de
	ld [hl], $10
	push bc
	push de
	pop bc
	ld a, $40
	call Call_3C25
	pop bc
	ret


jr_004_6d2f:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	ld hl, $c200
	add hl, bc
	add [hl]
	ld [hl], a
	cp $9c
	jp nc, Call_04_6D4D

	ld hl, $c250
	add hl, bc
	ld a, [hl]
	ld hl, $c210
	add hl, bc
	add [hl]
	ld [hl], a
	cp $78
	ret c

Call_04_6D4D::
	ld hl, $c280
	add hl, bc
	ld [hl], b
	ret


Call_04_6D53::
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6d9c

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
	call Call_04_6D9D
	ld hl, $c430
	add hl, bc
	ld a, [hl]
	and $20
	jr nz, jr_004_6d8f

	call Call_3B9E

jr_004_6d8f:
	ld hl, $c250
	add hl, bc
	pop af
	ld [hl], a
	ld hl, $c240
	add hl, bc
	pop af
	ld [hl], a
	pop af

jr_004_6d9c:
	ret


Call_04_6D9D::
	call Call_04_6DAA

Call_04_6DA0::
	push bc
	ld a, c
	add $10
	ld c, a
	call Call_04_6DAA
	pop bc
	ret


Call_04_6DAA::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6dd5

	push af
	swap a
	and $f0
	ld hl, $c260
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c200

Jump_004_6dc2:
jr_004_6dc2:
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, jr_004_6dcc

	ld e, $f0

jr_004_6dcc:
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a

jr_004_6dd5:
	ret


Call_04_6DD6::
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6dd5

	push af
	swap a
	and $f0
	ld hl, $c330
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c310
	jr jr_004_6dc2

Call_04_6DF0::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	push af
	swap a
	and $f0
	ld hl, $c2c0
	add hl, bc
	add [hl]
	ld [hl], a
	rl d
	ld hl, $c2d0
	jp Jump_004_6dc2


Call_04_6E08::
	ld e, $00
	ldh a, [$ff98]
	ld hl, $c200
	add hl, bc
	sub [hl]
	bit 7, a
	jr z, jr_004_6e16

	inc e

jr_004_6e16:
	ld d, a
	ret


Call_04_6E18::
	ld e, $02
	ldh a, [$ff99]
	ld hl, $c210
	add hl, bc
	sub [hl]
	bit 7, a
	jr nz, jr_004_6e26

	inc e

jr_004_6e26:
	ld d, a
	ret


Call_04_6E28::
	call Call_04_6E08
	ld a, e
	ldh [$ffd7], a
	ld a, d
	bit 7, a
	jr z, jr_004_6e35

	cpl
	inc a

jr_004_6e35:
	push af
	call Call_04_6E18
	ld a, e
	ldh [$ffd8], a
	ld a, d
	bit 7, a
	jr z, jr_004_6e43

	cpl
	inc a

jr_004_6e43:
	pop de
	cp d
	jr nc, jr_004_6e4b

	ldh a, [$ffd7]
	jr jr_004_6e4d

jr_004_6e4b:
	ldh a, [$ffd8]

jr_004_6e4d:
	ld e, a
	ret


Call_04_6E4F::
	ld a, [$db73]
	push af
	ldh a, [$fff8]
	and $10
	jr z, jr_004_6e5d

	xor a
	ld [$db73], a

jr_004_6e5d:
	call Call_04_6E65
	pop af
	ld [$db73], a
	ret


Call_04_6E65::
	ld hl, $c2b0
	add hl, bc
	ld a, [hl]
	and a
	jp nz, Jump_004_7440

	ld a, c
	ld [$d210], a
	ld a, $02
	ld [$c50a], a
	call Call_088C
	dec a
	jr nz, jr_004_6e81

	ld a, $19
	ldh [$fff2], a

jr_004_6e81:
	ldh a, [$fff1]
	inc a
	jr z, jr_004_6e9d

	ldh a, [$ffe7]
	and $1f
	jr nz, jr_004_6e94

	call Call_04_6E28
	ld hl, $c380
	add hl, bc
	ld [hl], e

jr_004_6e94:
	call Call_04_7C20
	ld de, $7662
	call Call_3C3B

jr_004_6e9d:
	call Call_04_7377
	call Call_3DBA
	call Call_04_7B6B
	call Call_04_7330
	ldh a, [$fff0]
	cp $03
	jr c, jr_004_6ebc

	ld a, [$db73]
	and a
	jr z, jr_004_6ebc

	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a

jr_004_6ebc:
	ldh a, [$fff0]
	rst $00

JumpTable_04_6EBF::
	dw Jump_04_6EF7
	dw Jump_04_6F72
	dw Jump_04_6FCF
	dw Jump_04_702F
	dw Jump_04_70AD
	dw Jump_04_7107
	dw Jump_04_712D
	dw Jump_04_716C
	dw Jump_04_71B6
	dw Jump_04_71EC
	dw Jump_04_7209
	dw Jump_04_7265
	dw Jump_04_72A7
	dw Jump_04_5838
	dw Jump_04_5878
	dw $7040 ; Jump_04_7040 (not an instruction start in this disassembly)

	db $2e, $2e, $2e, $3e, $4e, $4e, $00, $00, $00, $04, $01, $02, $05, $02, $02, $00
	db $03, $04, $81, $81, $81, $82, $81, $81

Jump_04_6EF7::
	ld e, $06
	ld d, $00

jr_004_6efb:
	push de
	ld a, $4f
	ld e, $0e
	call Call_3C13
	ld hl, $c2b0
	add hl, de
	ld [hl], $01
	ld hl, $6ed0
	add hl, de
	ld a, [hl]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld hl, $6ed6
	add hl, de
	ld a, [hl]
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $6ee2
	add hl, de
	ld a, [hl]
	ld hl, $c3b0
	add hl, de
	ld [hl], a
	ld hl, $6ee8
	add hl, de
	ld a, [hl]
	ld hl, $c340
	add hl, de
	ld [hl], a
	ld hl, $6edc
	add hl, de
	ld a, [hl]
	ld hl, $c380
	add hl, de
	ld [hl], a
	push bc
	push de
	pop bc
	call Call_04_761D
	pop bc
	pop de
	dec e
	jr nz, jr_004_6efb

	xor a
	ld [$d206], a
	ld a, $10
	ld [$d202], a
	ld [$d203], a
	ld a, $16
	ld [$d205], a
	ld a, $18
	ld [$d204], a
	ld a, $00
	ld [$d200], a
	ld a, $04
	ld [$d201], a
	call Call_3B8D
	ld a, [$db0e]
	ld hl, $c390
	add hl, bc
	ld [hl], a
	ret


Jump_04_6F72::
	ld a, [$c167]
	and a
	ret nz

	ld a, [$db73]
	and a
	jr z, jr_004_6f8e

	ldh a, [$ff98]
	cp $6c
	jr c, jr_004_6f8e

	ld hl, $daa0
	set 4, [hl]
	ld a, $6b
	ldh [$ff98], a
	jr jr_004_6f93

jr_004_6f8e:
	call Call_04_7B8E
	jr nc, jr_004_6fce

jr_004_6f93:
	xor a
	ld [$c120], a
	ldh [$ff9a], a
	ld e, $06
	ld hl, $c390
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_6fa4

	dec e

jr_004_6fa4:
	ld hl, $c440
	add hl, bc
	ld a, [hl]
	cp e
	jr c, jr_004_6fb2

	ld a, $40
	call Call_2197
	ret


jr_004_6fb2:
	ld a, [$db73]
	and a
	jr z, jr_004_6fbc

	ld a, $f7
	jr jr_004_6fc8

jr_004_6fbc:
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	and a
	ld a, $3b
	jr z, jr_004_6fc8

	ld a, $3e

jr_004_6fc8:
	call Call_2197
	call Call_3B8D

jr_004_6fce:
	ret


Jump_04_6FCF::
	ld a, $02
	ldh [$ffa1], a
	ld a, [$c19f]
	and a
	jr nz, jr_004_700b

	ld a, [$c173]
	cp $f8
	jr z, jr_004_6fe7

	ld a, [$c177]
	cp $01
	jr nc, jr_004_6ffa

jr_004_6fe7:
	ld a, [$db5e]
	sub $10
	ld a, [$db5d]
	sbc $00
	jr nc, jr_004_700c

	ld a, $34
	call Call_2197
	jr Call_04_7005

jr_004_6ffa:
	ld a, [$db73]
	and a
	jr z, Call_04_7005

	ld a, $f8
	jp Call_2197


Call_04_7005::
	ld hl, $c290
	add hl, bc
	ld [hl], $01

jr_004_700b:
	ret


jr_004_700c:
	ld a, [$db73]
	and a
	jr z, jr_004_7015

	ld [$db74], a

jr_004_7015:
	ld hl, $c2d0
	add hl, bc
	ld a, [hl]
	ld [hl], $01
	and a
	ld a, $3c
	jr z, jr_004_7023

	ld a, $3f

jr_004_7023:
	call Call_2197
	ld a, $0a
	ld [$db92], a
	call Call_3B8D
	ret


Jump_04_702F::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	ld [$d200], a
	ld a, $10
	ld [$d203], a
	ldh a, [$ffe7]
	and $10
	ld [$d202], a
	ld a, [$db73]
	and a
	jr z, jr_004_7095

	call Call_0887
	jr z, jr_004_7058

	dec a
	jr nz, jr_004_7057

	call Call_04_70A5

jr_004_7057:
	ret


jr_004_7058:
	call Call_04_7F36
	push bc
	ld a, [$c50f]
	ld c, a
	ldh a, [$ffe7]
	and $10
	ld a, $04
	jr z, jr_004_7069

	inc a

jr_004_7069:
	call Call_3B87
	ld hl, $c240
	add hl, bc
	ld [hl], $f8
	call Call_04_6DAA
	ld hl, $c200
	add hl, bc
	pop bc
	ld a, [hl]
	cp $28
	jr nz, jr_004_7094

	call Call_0887
	ld [hl], $18
	ld a, [$c50f]
	ld e, a
	ld d, b
	ld hl, $c3b0
	add hl, de
	ld [hl], $02
	ld e, $01
	call Call_04_71A8

jr_004_7094:
	ret


jr_004_7095:
	ldh a, [$ffcb]
	and $20
	jr z, jr_004_70ac

	ldh a, [$ff98]
	cp $20
	jr c, jr_004_70ac

	cp $30
	jr nc, jr_004_70ac

Call_04_70A5::
	call Call_3B8D

Call_04_70A8::
	ld a, $20
	ldh [$fff4], a

jr_004_70ac:
	ret


Jump_04_70AD::
	call Call_04_70F3
	ld a, $10
	ld [$d203], a
	ldh a, [$ffe7]
	and $10
	ld [$d202], a
	ld a, [$db73]
	and a
	jr z, jr_004_70c9

	ld e, $02
	call Call_04_71A8
	jr jr_004_70cf

jr_004_70c9:
	ldh a, [$ffcb]
	and $20
	jr z, jr_004_70e0

jr_004_70cf:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_70f2

	ld a, [$d204]
	inc a
	ld [$d204], a
	cp $88
	jr c, jr_004_70f2

jr_004_70e0:
	call Call_3B8D
	ld a, [$db73]
	and a
	jr z, Call_04_70EE

	call Call_0887
	ld [hl], $10

Call_04_70EE::
	ld a, $21
	ldh [$fff4], a

jr_004_70f2:
	ret


Call_04_70F3::
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	ld [$d200], a
	ld a, $01
	ldh [$ffa1], a
	ld a, $02
	ldh [$ff9e], a
	ret


Jump_04_7107::
	call Call_04_70F3
	ld a, $10
	ld [$d202], a
	ldh a, [$ffe7]
	and $10
	ld [$d203], a
	call Call_0887
	ret nz

	ld a, [$db73]
	and a
	jr nz, jr_004_7126

	ldh a, [$ffcb]
	and $10
	jr z, jr_004_712c

jr_004_7126:
	call Call_04_70A8
	call Call_3B8D

jr_004_712c:
	ret


Jump_04_712D::
	call Call_04_70F3
	ld a, $10
	ld [$d202], a
	ldh a, [$ffe7]
	and $10
	ld [$d203], a
	ld a, [$db73]
	and a
	jr z, jr_004_7144

	jr jr_004_714a

jr_004_7144:
	ldh a, [$ffcb]
	and $10
	jr z, jr_004_715b

jr_004_714a:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_716b

	ld a, [$d205]
	inc a
	ld [$d205], a
	cp $55
	jr c, jr_004_716b

jr_004_715b:
	call Call_3B8D
	call Call_04_70EE
	call Call_0891
	ld [hl], $60
	ld e, $00
	call Call_04_71A8

jr_004_716b:
	ret


Jump_04_716C::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld [$d200], a
	ld a, $10
	ld [$d202], a
	ld [$d203], a
	call Call_0891
	cp $30
	jr nc, jr_004_718a

	ld hl, $d201
	ld [hl], $02

jr_004_718a:
	and a
	jr nz, jr_004_71b5

	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_71b5

	ld a, [$d206]
	inc a
	ld [$d206], a
	cp $0f
	jr nz, jr_004_71b5

	call Call_0891
	ld [hl], $ff
	call Call_3B8D
	ld e, $00

Call_04_71A8::
	ld a, [$db73]
	and a
	ret z

	ld a, e
	ldh [$ff9e], a
	push bc
	call Call_087C
	pop bc

jr_004_71b5:
	ret


Jump_04_71B6::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld [$d200], a
	call Call_0891
	cp $c8
	jr nz, jr_004_71cc

	ld hl, $d206
	ld [hl], $10

jr_004_71cc:
	cp $a0
	jr nz, jr_004_71d5

	ld hl, $d201
	ld [hl], $03

jr_004_71d5:
	cp $50
	jr nz, jr_004_71e2

	ld hl, $d201
	ld [hl], $04
	call Call_04_72AB
	ret


jr_004_71e2:
	and a
	jr nz, jr_004_71eb

	call Call_3B8D
	call Call_04_70A8

jr_004_71eb:
	ret


Jump_04_71EC::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld [$d200], a
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_7208

	ld a, [$d206]
	dec a
	ld [$d206], a
	jr nz, jr_004_7208

	call Call_3B8D

jr_004_7208:
	ret


Jump_04_7209::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld [$d200], a
	ldh a, [$ff98]
	push af
	ldh a, [$ff99]
	push af
	ld a, $16
	ldh [$ff99], a
	ld a, $18
	ldh [$ff98], a
	ld a, [$d204]
	ld [$c201], a
	ld a, [$d205]
	ld [$c211], a
	push bc
	ld c, $01
	ld a, $04
	call Call_3C25
	call Call_04_6D9D
	ld a, [$c201]
	ld [$d204], a
	ld a, [$c211]
	ld [$d205], a
	pop bc
	pop af
	ldh [$ff99], a
	pop af
	ldh [$ff98], a
	ld a, [$d204]
	cp $18
	jr nz, jr_004_7264

	ld a, [$d205]
	cp $16
	jr nz, jr_004_7264

	call Call_0891
	ld [hl], $c0
	call Call_3B8D
	call Call_04_70EE

jr_004_7264:
	ret


Jump_04_7265::
	ldh a, [$ffe7]
	rra
	rra
	rra
	and $01
	ld [$d200], a
	call Call_0891
	cp $60
	jr nz, jr_004_729b

	ld hl, $d201
	ld [hl], $02
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_729a

	ld [hl], $00
	dec a
	ld e, a
	ld d, b
	ld hl, $c290
	add hl, de
	ld [hl], $02
	ld a, [$db73]
	and a
	jr z, jr_004_729a

	ld hl, $c3b0
	add hl, de
	ld [hl], $07

jr_004_729a:
	ret


jr_004_729b:
	and a
	jr nz, jr_004_72a6

	ld hl, $d201
	ld [hl], $04
	call Call_3B8D

jr_004_72a6:
	ret


Jump_04_72A7::
	call Call_04_7005
	ret


Call_04_72AB::
	ld a, [$db73]
	and a
	jr z, jr_004_72d8

	ld a, $ff
	call Call_3B87
	ld a, $4f
	call Call_3C01
	ld a, [$d204]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld a, [$d205]
	add $18
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld hl, $c3b0
	add hl, de
	ld [hl], $06
	ld hl, $c2b0
	add hl, de
	inc [hl]

jr_004_72d8:
	ld e, $0f
	ld d, b

jr_004_72db:
	ld hl, $c280
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_7329

	ld hl, $c290
	add hl, de
	ld a, [hl]
	and a
	jr nz, jr_004_7329

	ld hl, $c3a0
	add hl, de
	ld a, [hl]
	cp $4f
	jr nz, jr_004_7329

	ld hl, $c200
	add hl, de
	ld a, [$d204]
	sub [hl]
	add $04
	cp $08
	jr nc, jr_004_7329

	ld hl, $c210
	add hl, de
	ld a, [$d205]
	add $18
	sub [hl]
	add $06
	cp $0c
	jr nc, jr_004_7329

	ld hl, $c290
	add hl, de
	ld [hl], $01
	ld a, e
	inc a
	ld hl, $c2c0
	add hl, bc
	ld [hl], a
	call Call_088C
	ld [hl], $10
	ld hl, $c440
	inc [hl]
	ret


jr_004_7329:
	dec e
	ld a, e
	cp $ff
	jr nz, jr_004_72db

	ret


Call_04_7330::
	ld hl, $c2c0
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_004_735a

	dec a
	ld e, a
	ld d, b
	ld a, [$d204]
	ld hl, $c200
	add hl, de
	ld [hl], a
	ld a, [$d205]
	add $18
	ld hl, $c210
	add hl, de
	ld [hl], a
	ld a, $10
	ld hl, $d206
	sub [hl]
	add $fe
	ld hl, $c310
	add hl, de
	ld [hl], a

jr_004_735a:
	ret


	db $76, $00, $78, $00, $78, $20, $76, $20, $70, $00, $70, $20, $72, $00, $70, $20
	db $72, $00, $72, $20, $7e, $00, $7e, $20, $26, $00, $26, $00

Call_04_7377::
	ld a, [$d204]
	ldh [$ffee], a
	ld a, [$d205]
	ld hl, $d206
	add [hl]
	add $08
	ldh [$ffec], a
	ld a, [$d201]
	ldh [$fff1], a
	ld de, $735b
	call Call_3C3B
	ld a, [$d204]
	ldh [$ffee], a
	ld a, [$d205]
	ldh [$ffec], a
	ld a, [$d200]
	ldh [$fff1], a
	ld de, $735b
	call Call_3C3B
	ld a, [$d206]
	cp $08
	jr c, jr_004_73c4

	ld a, [$d204]
	ldh [$ffee], a
	ld a, [$d205]
	add $10
	ldh [$ffec], a
	ld a, $05
	ldh [$fff1], a
	ld de, $735b
	call Call_3C3B

jr_004_73c4:
	ldh a, [$ffe7]
	and $01
	jr nz, jr_004_73f0

	ld a, [$d204]
	ldh [$ffee], a
	ld a, [$d205]
	add $20
	ldh [$ffec], a
	xor a
	ldh [$fff1], a
	ld de, $7373
	ld a, [$c3c0]
	push af
	call Call_3C3B
	pop af
	ld e, a
	ld d, b
	ld hl, $c031
	add hl, de
	inc [hl]
	inc hl
	inc hl
	inc hl
	inc hl
	dec [hl]

jr_004_73f0:
	ld hl, $c020
	ld a, $50
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld a, $7a
	ld [hli], a
	ld a, [$d202]
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $28
	ld [hli], a
	ld a, $3e
	ld [hli], a
	ld a, [$d202]
	ld [hli], a
	ld a, $50
	ld [hli], a
	ld a, $30
	ld [hli], a
	ld a, $7c
	ld [hli], a
	ld a, [$d203]
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $30
	ld [hli], a
	ld a, $3e
	ld [hli], a
	ld a, [$d203]
	ld [hli], a
	ret


	db $ff, $ff, $9e, $10, $a6, $10, $8e, $10, $86, $10, $a8, $10, $9a, $10, $9c, $10
	db $6c, $00, $6e, $00, $6e, $20, $6c, $20

Jump_004_7440:
	ldh a, [$fff1]
	cp $06
	jr c, jr_004_7458

	ld de, $7420
	cp $07
	jr z, jr_004_7456

	ldh a, [$ffe7]
	and $10
	jr nz, jr_004_7456

	ld de, $7424

jr_004_7456:
	jr jr_004_7473

jr_004_7458:
	cp $03
	jr nz, jr_004_7465

	ld a, [$db4b]
	and a
	jp nz, Call_04_6D4D

	jr jr_004_7478

jr_004_7465:
	cp $00
	jr nz, jr_004_7478

	ld a, [$db0e]
	and a
	jp nz, Call_04_6D4D

	ld de, $7434

jr_004_7473:
	call Call_3C3B
	jr jr_004_747e

jr_004_7478:
	ld de, $7428
	call Call_3CD0

jr_004_747e:
	call Call_04_7F36
	ldh a, [$fff0]
	rst $00

JumpTable_04_7484::
	dw Jump_04_7490
	dw Jump_04_74C3
	dw Jump_04_74CE
	dw Jump_04_7525
	dw Jump_04_75EB
	dw Jump_04_7602

Jump_04_7490::
	call Call_04_6D9D
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	rst $00

JumpTable_04_7499::
	dw Jump_04_74A3
	dw Jump_04_74AB
	dw Jump_04_74B3
	dw Jump_04_74BB
	dw Jump_04_74AA

Jump_04_74A3::
	ldh a, [$ffee]
	cp $3a
	jp c, Jump_004_7614

Jump_04_74AA::
	ret


Jump_04_74AB::
	ldh a, [$ffec]
	cp $4e
	jp nc, Jump_004_7614

	ret


Jump_04_74B3::
	ldh a, [$ffee]
	cp $78
	jp nc, Jump_004_7614

	ret


Jump_04_74BB::
	ldh a, [$ffec]
	cp $2e
	jp c, Jump_004_7614

	ret


Jump_04_74C3::
	call Call_04_6E28
	ld a, e
	xor $01
	ld e, a
	call Call_04_71A8
	ret


Jump_04_74CE::
	ld a, [$db73]
	and a
	jr z, jr_004_74d8

	ld a, $02
	ldh [$ffa1], a

jr_004_74d8:
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jr z, jr_004_7500

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_004_74fc

	ld [hl], b
	jr jr_004_7500

jr_004_74fc:
	ld a, $09
	ldh [$fff2], a

jr_004_7500:
	ldh a, [$ffe7]
	and $03
	jr nz, jr_004_7511

	ld hl, $c210
	add hl, bc
	ld a, [hl]
	cp $56
	jr z, jr_004_7512

	inc a
	ld [hl], a

jr_004_7511:
	ret


jr_004_7512:
	add $0a
	ld [hl], a
	ld hl, $c310
	add hl, bc
	ld [hl], $0a
	call Call_3B8D
	ret


	db $44, $43, $42, $41, $3d, $2a

Jump_04_7525::
	ld a, [$db73]
	and a
	jr z, jr_004_752f

	ld a, $02
	ldh [$ffa1], a

jr_004_752f:
	call Call_04_6DD6
	ld hl, $c320
	add hl, bc
	dec [hl]
	dec [hl]
	ld hl, $c310
	add hl, bc
	ld a, [hl]
	and $80
	jp z, Jump_004_75ea

	xor a
	ld [hl], a
	ld hl, $c320
	add hl, bc
	ld a, [hl]
	sra a
	cpl
	ld [hl], a
	cp $07
	jr nc, jr_004_7553

	xor a
	ld [hl], a

jr_004_7553:
	ldh a, [$fff1]
	cp $06
	jr c, jr_004_7561

	ld a, $f9
	call Call_2197
	jp Call_3B8D


jr_004_7561:
	ldh a, [$ffee]
	ld hl, $ff98
	sub [hl]
	add $07
	cp $0e
	ret nc

	ldh a, [$ffec]
	ld hl, $ff99
	sub [hl]
	add $05
	cp $0a
	ret nc

	ld a, [$d210]
	ld e, a
	ld d, b
	ld hl, $c480
	add hl, de
	ld a, [hl]
	and a
	ret nz

	ld [hl], $18
	ldh a, [$fff1]
	cp $00
	jr nz, jr_004_7596

	ld a, $01
	ld [$db0e], a
	call Call_0898
	jp Call_04_6D4D


jr_004_7596:
	call Call_04_6D4D
	ld hl, $fff3
	ld [hl], $01
	ldh a, [$fff1]
	ld e, a
	ld d, b
	ld hl, $751f
	add hl, de
	ld a, [hl]
	call Call_2197
	ldh a, [$fff1]
	dec a
	jr nz, jr_004_75b0

	ret


jr_004_75b0:
	dec a
	jr nz, jr_004_75bc

	ld a, [$db90]
	add $1e
	ld [$db90], a
	ret


jr_004_75bc:
	dec a
	jr nz, jr_004_75dc

	ld hl, $db76
	ld a, [$db4c]
	cp [hl]
	jr nc, jr_004_75cf

	add $10
	daa
	cp [hl]
	jr c, jr_004_75cf

	ld a, [hl]

jr_004_75cf:
	ld [$db4c], a
	ld d, $0c
	call Call_3E95
	ld a, $0b
	ldh [$ffa5], a
	ret


jr_004_75dc:
	dec a
	jr nz, jr_004_75e5

	ld d, $04
	call Call_3E95
	ret


jr_004_75e5:
	ld a, $ff
	ld [$db93], a

Jump_004_75ea:
	ret


Jump_04_75EB::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, [$c1ad]
	and a
	ret nz

	ld [$db74], a
	ld a, $18
	ld [$c1bc], a
	jp Call_3B8D


Jump_04_7602::
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ret


	db $fc, $00, $04, $00, $00, $00, $04, $00, $fc, $00

Jump_004_7614:
	ld hl, $c380
	add hl, bc
	ld a, [hl]
	inc a
	and $03
	ld [hl], a

Call_04_761D::
	ld e, a
	ld d, b
	ld hl, $760a
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $760f
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	ret


Call_04_7634::
	ldh a, [$ffe7]
	and $1f
	jr nz, jr_004_7643

	call Call_04_6E28
	ld a, e
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_004_7643:
	call Call_04_7C20
	ld de, $7662
	call Call_3C3B
	call Call_04_7B6B
	call Call_04_7BD3
	jr nc, jr_004_7661

	ld a, [$d47f]
	cp $03
	ld a, $39
	jr c, jr_004_765e

	inc a

jr_004_765e:
	call Call_2197

jr_004_7661:
	ret


	db $60, $00, $62, $00, $62, $20, $60, $20, $64, $00, $66, $00, $66, $20, $64, $20
	db $68, $00, $6a, $00, $6c, $00, $6e, $00, $6a, $20, $68, $20, $6e, $20, $6c, $20

Call_04_7682::
	ld a, [$c50a]
	and a
	jr nz, jr_004_7690

	ld a, $01
	ld [$c50a], a
	call Call_04_7826

jr_004_7690:
	ld a, [$db4e]
	and a
	jr z, jr_004_769c

	ldh a, [$ffe7]
	and $5f
	jr nz, jr_004_76a5

jr_004_769c:
	call Call_04_6E28
	ld a, e
	ld hl, $c380
	add hl, bc
	ld [hl], a

jr_004_76a5:
	call Call_04_7C20
	ld de, $7662
	call Call_3C3B
	call Call_04_7AF5
	ldh a, [$fff0]
	cp $04
	jr nc, jr_004_76ba

	call Call_04_7B6B

jr_004_76ba:
	ldh a, [$fff0]
	rst $00

JumpTable_04_76BD::
	dw Jump_04_778F
	dw Jump_04_7847
	dw Jump_04_78F8
	dw Jump_04_7A7D
	dw Jump_04_7A87
	dw Jump_04_7AC2
	dw Jump_04_6398

	db $02, $b2, $b0, $b0, $98, $a4, $01, $7f, $7f, $98, $67, $02, $b1, $b0, $7f, $98
	db $a8, $01, $0a, $b3, $98, $6a, $02, $7f, $b2, $b0, $98, $ac, $01, $ba, $b1, $98
	db $6e, $02, $b1, $b0, $7f, $98, $b0, $01, $0a, $09, $98, $63, $02, $b9, $b8, $b0
	db $98, $a4, $01, $7f, $7f, $98, $63, $02, $b1, $b0, $7f, $98, $a4, $01, $0a, $09
	db $00, $98, $62, $43, $7f, $98, $83, $42, $7f, $98, $a3, $42, $7f, $00, $00, $00
	db $00, $98, $66, $43, $7f, $98, $87, $42, $7f, $98, $a7, $42, $7f, $00, $00, $00
	db $00, $98, $6a, $43, $7f, $98, $8b, $42, $7f, $98, $ab, $42, $7f, $00, $00, $00
	db $00, $98, $6e, $43, $7f, $98, $8f, $42, $7f, $98, $af, $42, $7f, $00, $00, $00
	db $00, $01, $02, $03, $00, $01, $02, $03, $04, $05, $02, $03, $04, $06, $02, $03
	db $04, $07, $08, $09, $0a, $30, $31, $32, $33, $2c, $2d, $39, $00, $00, $00, $00
	db $02, $00, $00, $00, $09, $00, $00, $00, $00, $00, $10, $20, $10, $80, $10, $00
	db $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $c8, $0a, $14, $0a, $d4
	db $0a, $00, $00, $00

Jump_04_778F::
	ld a, [$db46]
	and a
	jr z, jr_004_77d0

	ld hl, $c210
	add hl, bc
	ld [hl], $40
	ld hl, $c200
	add hl, bc
	ld [hl], $50
	ld hl, $c380
	add hl, bc
	ld [hl], $03
	ld a, $02
	ldh [$ffa1], a
	ld [$c167], a
	ld a, [$c16b]
	cp $04
	jr nz, jr_004_77cf

	ldh a, [$ff99]
	sub $01
	ldh [$ff99], a
	cp $74
	jr nz, jr_004_77cf

	ld a, $38
	call Call_2197
	ld hl, $c290
	add hl, bc
	ld [hl], $04
	ld a, $19
	ld [$d368], a

jr_004_77cf:
	ret


jr_004_77d0:
	ld e, $00
	ld d, b
	ld a, [$db66]
	and $02
	jr z, jr_004_77dc

	ld e, $04

jr_004_77dc:
	push bc
	ld hl, $db00
	ld c, $0b

jr_004_77e2:
	ld a, [$db7d]
	cp $0b
	jr z, jr_004_77ee

	ld a, [hli]
	cp $0b
	jr nz, jr_004_77f0

jr_004_77ee:
	ld e, $08

jr_004_77f0:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_004_77e2

	ld hl, $db00
	ld c, $0b

jr_004_77fb:
	ld a, [$db7d]
	cp $05
	jr z, jr_004_7807

	ld a, [hli]
	cp $05
	jr nz, jr_004_7809

jr_004_7807:
	ld e, $0c

jr_004_7809:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_004_77fb

	ld hl, $774c
	add hl, de
	ld de, $c505
	ld c, $04

jr_004_7818:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_7818

	pop bc
	call Call_3B8D
	call Call_04_7826
	ret


Call_04_7826::
	ld de, $d601
	push bc
	ld hl, $c505
	ld c, $04

jr_004_782f:
	ld a, [hli]
	and a
	jr z, jr_004_7838

	push hl
	call Call_04_7926
	pop hl

jr_004_7838:
	dec c
	jr nz, jr_004_782f

	pop bc
	ret


	db $00, $00, $00, $01, $01, $02, $02, $03, $03, $03

Jump_04_7847::
	ld a, [$c509]
	and a
	jr z, jr_004_786c

	ld hl, $c380
	add hl, bc
	ld a, [hl]
	and $01
	jr z, jr_004_786c

	ld a, [$c11c]
	cp $00
	jr nz, jr_004_786c

	ldh a, [$ff99]
	cp $7b
	jr c, jr_004_786c

	sub $02
	ldh [$ff99], a
	ld a, $2f
	jp Call_2197


jr_004_786c:
	ldh a, [$ff99]
	cp $48
	jr nc, jr_004_78d8

	ldh a, [$ff9e]
	cp $02
	jr nz, jr_004_78d8

	ldh a, [$ffcc]
	and $30
	jr z, jr_004_78d8

	ld a, [$c509]
	and a
	jr z, jr_004_789f

	ldh a, [$ff98]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $783d
	add hl, de
	ld a, [$c50b]
	cp [hl]
	jr nz, jr_004_78d8

	ld a, $13
	ldh [$fff2], a
	jp Call_04_7908


jr_004_789f:
	ldh a, [$ff98]
	add $00
	swap a
	and $0f
	ld e, a
	ld d, b
	ld hl, $783d
	add hl, de
	ld a, [hl]
	ld [$c50b], a
	ld e, a
	ld d, b
	ld hl, $c505
	add hl, de
	ld a, [hl]
	ld [$c509], a
	ld [hl], b
	and a
	jr z, jr_004_78c3

	ld a, $13
	ldh [$fff2], a

jr_004_78c3:
	push bc
	ld a, e
	swap a
	ld e, a
	ld hl, $770c
	add hl, de
	ld de, $d601
	ld c, $0d

jr_004_78d1:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_78d1

	pop bc

jr_004_78d8:
	call Call_04_7B8E
	jr nc, jr_004_78f7

	ld a, [$c509]
	and a
	jr z, jr_004_78f2

	dec a
	ld e, a
	ld d, b
	ld hl, $7760
	add hl, de
	ld a, [hl]
	call Call_2197
	call Call_3B8D
	ret


jr_004_78f2:
	ld a, $2e
	call Call_2197

jr_004_78f7:
	ret


Jump_04_78F8::
	ld a, [$c19f]
	and a
	ret nz

	ld a, [$c177]
	cp $00
	jr z, jr_004_7946

	cp $02
	jr z, jr_004_791f

Call_04_7908::
	ld a, [$c50b]
	ld e, a
	ld d, b
	ld hl, $c505
	add hl, de
	ld a, [$c509]
	ld [hl], a
	ld de, $d601
	call Call_04_7926
	xor a
	ld [$c509], a

jr_004_791f:
	ld hl, $c290
	add hl, bc
	ld [hl], $01
	ret


Call_04_7926::
	push de
	dec a
	ld d, a
	sla a
	ld e, a
	sla a
	sla a
	add e
	add d
	ld e, a
	ld d, b
	ld hl, $76c9
	add hl, de
	pop de
	push bc
	ld c, $0b

jr_004_793c:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, jr_004_793c

	xor a
	ld [de], a
	pop bc
	ret


jr_004_7946:
	ld a, [$c509]
	ld e, a
	cp $02
	jr nz, jr_004_7956

	ld a, [$c5a9]
	and a
	jr nz, jr_004_79a0

	jr jr_004_79a7

jr_004_7956:
	cp $04
	jr nz, jr_004_7974

	ld hl, $db00
	ld d, $0c

jr_004_795f:
	ld a, [hli]
	cp $02
	jr z, jr_004_7969

	dec d
	jr nz, jr_004_795f

	jr jr_004_79a7

jr_004_7969:
	ld a, [$db4d]
	ld hl, $db77
	cp [hl]
	jr nc, jr_004_79a0

	jr jr_004_79a7

jr_004_7974:
	cp $06
	jr nz, jr_004_7992

	ld hl, $db00
	ld d, $0c

jr_004_797d:
	ld a, [hli]
	cp $05
	jr z, jr_004_7987

	dec d
	jr nz, jr_004_797d

	jr jr_004_79a7

jr_004_7987:
	ld a, [$db45]
	ld hl, $db78
	cp [hl]
	jr nc, jr_004_79a0

	jr jr_004_79a7

jr_004_7992:
	cp $03
	jr nz, jr_004_79a7

	ld hl, $db00
	ld d, $0c

jr_004_799b:
	ld a, [hli]
	cp $04
	jr nz, jr_004_79a4

jr_004_79a0:
	ld a, $29
	jr jr_004_79bf

jr_004_79a4:
	dec d
	jr nz, jr_004_799b

jr_004_79a7:
	ld d, b
	ld hl, $776a
	add hl, de
	ld a, [hl]
	ld hl, $7773
	add hl, de
	ld e, [hl]
	ld d, a
	ld a, [$db5e]
	sub e
	ld a, [$db5d]
	sbc d
	jr nc, jr_004_79c9

	ld a, $34

jr_004_79bf:
	call Call_2197
	ld hl, $c290
	add hl, bc
	ld [hl], $03
	ret


jr_004_79c9:
	ld hl, $c509
	ld a, [hl]
	push af
	ld [hl], $00
	ld e, a
	ld d, b
	ld hl, $7785
	add hl, de
	ld a, [$db92]
	add [hl]
	ld [$db92], a
	rl a
	ld hl, $777c
	add hl, de
	rr a
	ld a, [$db91]
	adc [hl]
	ld [$db91], a
	ld hl, $c290
	add hl, bc
	ld [hl], $01
	pop af
	push af
	ld a, $35
	call Call_2197
	pop af

Call_04_79FA::
	dec a
	rst $00

JumpTable_04_79FC::
	dw Jump_04_7A45
	dw Jump_04_7A71
	dw Jump_04_7A77
	dw Jump_04_7A4B
	dw Jump_04_7A0E
	dw Jump_04_7A19
	dw Jump_04_7A27
	dw Jump_04_7A2D
	dw Jump_04_7A3B

Jump_04_7A0E::
	ld d, $05
	call Call_3E95
	ld a, $20
	ld [$db45], a
	ret


Jump_04_7A19::
	ld a, [$db45]
	add $0a
	daa
	jr nc, jr_004_7a23

	ld a, $99

jr_004_7a23:
	ld [$db45], a
	ret


Jump_04_7A27::
	ld d, $09
	call Call_3E95
	ret


Jump_04_7A2D::
	ld a, [$db47]
	add $0a
	daa
	jr nc, jr_004_7a37

	ld a, $99

jr_004_7a37:
	ld [$db47], a
	ret


Jump_04_7A3B::
	ld a, [$db0d]
	add $01
	daa
	ld [$db0d], a
	ret


Jump_04_7A45::
	ld d, $0b
	call Call_3E95
	ret


Jump_04_7A4B::
	ld a, [$db4d]
	add $0a
	daa
	jr nc, jr_004_7a55

	ld a, $99

jr_004_7a55:
	ld [$db4d], a
	ld d, $02
	call Call_3E95
	ret


	db $fa, $45, $db, $c6, $0a, $27, $30, $02, $3e, $99, $ea, $45, $db, $16, $0c, $cd
	db $95, $3e, $c9

Jump_04_7A71::
	ld a, $18
	ld [$db93], a
	ret


Jump_04_7A77::
	ld d, $04
	call Call_3E95
	ret


Jump_04_7A7D::
	ld a, [$c19f]
	and a
	jr nz, jr_004_7a86

	call Call_04_7908

jr_004_7a86:
	ret


Jump_04_7A87::
	ld a, [$c19f]
	and a
	jr nz, jr_004_7ac1

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
	call Call_3B8D
	xor a
	ld [$db0d], a
	ld a, $ff
	ld [$db94], a

jr_004_7ac1:
	ret


Jump_04_7AC2::
	ld a, $02
	ldh [$ffa1], a
	call Call_0891
	jr nz, jr_004_7ada

	ld a, [$db5a]
	and a
	jr nz, jr_004_7ada

	ld [$db46], a
	ld [$c50a], a
	jp Call_04_6D4D


jr_004_7ada:
	ret


	db $1d, $3d, $5d, $7d, $96, $10, $a8, $10, $86, $10, $80, $10, $88, $10, $ff, $ff
	db $90, $10, $ae, $10, $a0, $10, $2a, $40, $2a, $60

Call_04_7AF5::
	ld a, $04

jr_004_7af7:
	ldh [$ffe6], a
	ld e, a
	ld d, b
	ld hl, $c504
	add hl, de
	ld a, [hl]
	and a
	jr z, jr_004_7b31

	dec a
	ldh [$fff1], a
	ld hl, $7ada
	ldh a, [$ffe6]
	ld e, a
	add hl, de
	ld a, [hl]
	ldh [$ffee], a
	ld a, $32
	ldh [$ffec], a
	ldh a, [$fff1]
	cp $01
	jr nz, jr_004_7b1f

	ld hl, $ffec
	ld [hl], $2f

jr_004_7b1f:
	cp $05
	jr nz, jr_004_7b2b

	ld de, $7add
	call Call_3C3B
	jr jr_004_7b31

jr_004_7b2b:
	ld de, $7adf
	call Call_3CD0

jr_004_7b31:
	ldh a, [$ffe6]
	dec a
	jr nz, jr_004_7af7

	call Call_04_7B3D
	call Call_3DBA
	ret


Call_04_7B3D::
	ld a, [$c509]
	and a
	jr z, jr_004_7b6a

	dec a
	ldh [$fff1], a
	ld a, $01
	ld [$c15c], a
	call Call_093B
	ldh a, [$ff98]
	ldh [$ffee], a
	ldh a, [$ff99]
	sub $0e
	ldh [$ffec], a
	ldh a, [$fff1]
	cp $05
	jr nz, jr_004_7b64

	ld de, $7add
	jp Call_3C3B


jr_004_7b64:
	ld de, $7adf
	call Call_3CD0

jr_004_7b6a:
	ret


Call_04_7B6B::
	call Call_3BD5
	jr nc, jr_004_7b8d

	call Call_094A
	call Call_0942
	ld a, [$c1a6]
	and a
	jr z, jr_004_7b8d

	ld e, a
	ld d, b
	ld hl, $c39f
	add hl, de
	ld a, [hl]
	cp $03
	jr nz, jr_004_7b8d

	ld hl, $c28f
	add hl, de
	ld [hl], $00

jr_004_7b8d:
	ret


Call_04_7B8E::
	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $20
	cp $30
	jr nc, jr_004_7bd1

	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_7bd1

	call Call_04_6E28
	ldh a, [$ff9e]
	xor $01
	cp e
	jr nz, jr_004_7bd1

	ld hl, $c1ad
	ld [hl], $01
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_004_7bd1

	ld a, [$db9a]
	cp $80
	jr nz, jr_004_7bd1

	ldh a, [$ffcc]
	and $10
	jr z, jr_004_7bd1

	scf
	ret


jr_004_7bd1:
	and a
	ret


Call_04_7BD3::
	ld a, [$c19f]
	ld hl, $c14f
	or [hl]
	ld hl, $c146
	or [hl]
	ld hl, $c134
	or [hl]
	jr nz, jr_004_7c1a

	ld a, [$db9a]
	cp $80
	jr nz, jr_004_7c1a

	ldh a, [$ff98]
	ld hl, $ffee
	sub [hl]
	add $10
	cp $20
	jr nc, jr_004_7c1a

	ldh a, [$ff99]
	ld hl, $ffef
	sub [hl]
	add $14
	cp $28
	jr nc, jr_004_7c1a

	call Call_04_6E28
	ldh a, [$ff9e]
	xor $01
	cp e
	jr nz, jr_004_7c1a

	ld hl, $c1ad
	ld [hl], $01
	ldh a, [$ffcc]
	and $10
	jr z, jr_004_7c1a

	scf
	ret


jr_004_7c1a:
	and a
	ret


	db $06, $04, $02, $00

Call_04_7C20::
	ld hl, $c380
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, $7c1c
	add hl, de
	push hl
	ld hl, $c3d0
	add hl, bc
	inc [hl]
	ld a, [hl]
	rra
	rra
	rra
	pop hl
	and $01
	or [hl]
	jp Call_3B87


	db $21, $40, $c2, $09, $7e, $f5, $36, $01, $21, $50, $c2, $09, $7e, $f5, $36, $01
	db $cd, $9e, $3b, $21, $a0, $c2, $09, $7e, $f5, $21, $40, $c2, $09, $36, $ff, $21
	db $50, $c2, $09, $36, $ff, $cd, $9e, $3b, $21, $a0, $c2, $09, $f1, $b6, $77, $f1
	db $21, $50, $c2, $09, $77, $f1, $21, $40, $c2, $09, $77, $c9, $7a, $20, $78, $20
	db $78, $00, $7a, $00, $7e, $00, $7e, $20, $70, $00, $72, $00, $74, $00, $76, $00
	db $7c, $00, $7c, $20, $6a, $20, $68, $20, $68, $00, $6a, $00, $6e, $00, $6e, $20
	db $60, $00, $62, $00, $64, $00, $66, $00, $6c, $00, $6c, $20

Call_04_7CA7::
	ld de, $7c77
	ldh a, [$fff7]
	cp $07
	jr nz, jr_004_7cb3

	ld de, $7c8f

jr_004_7cb3:
	call Call_088C
	rla
	rla
	rla
	and $10
	ldh [$ffed], a
	call Call_3C3B
	call Call_04_7F36
	ld hl, $c410
	add hl, bc
	ld a, [hl]
	cp $08
	jr nz, jr_004_7cd9

	ldh a, [$fff0]
	and a
	jr nz, jr_004_7cd9

	call Call_3B8D
	call Call_0887
	ld [hl], $6f

jr_004_7cd9:
	call Call_04_6D53
	call Call_04_6D9D
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_04_7CE5::
	dw Jump_04_7CF1
	dw Jump_04_7D2C

	db $08, $f8, $00, $00, $00, $00, $f8, $00

Jump_04_7CF1::
	call Call_3BB4
	call Call_0891
	jr nz, jr_004_7d19

	call Call_27ED
	and $1f
	add $30
	ld [hl], a
	and $03
	ld e, a
	ld d, b
	ld hl, $7ce9
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7ced
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a

jr_004_7d19:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


	db $05, $05, $04, $03, $02, $02, $02

Jump_04_7D2C::
	ld a, [$c14a]
	and a
	jr z, jr_004_7d37

	call Call_3B8D
	ld [hl], b
	ret


jr_004_7d37:
	call Call_3BEB
	call Call_04_6E08
	add $12
	cp $24
	jr nc, jr_004_7d4c

	call Call_04_6E18
	add $12
	cp $24
	jr c, jr_004_7d5a

jr_004_7d4c:
	ldh a, [$ffe7]
	xor c
	and $03
	jr nz, jr_004_7d58

	ld a, $0e
	call Call_3C25

jr_004_7d58:
	jr jr_004_7d5d

jr_004_7d5a:
	call Call_3DAF

jr_004_7d5d:
	call Call_0887
	jp z, Jump_004_7e46

	cp $18
	jr nz, jr_004_7d6e

	ld [hl], $0a
	call Call_088C
	ld [hl], $30

jr_004_7d6e:
	rra
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, b
	ld hl, $7d25
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


	db $7a, $20, $78, $20, $78, $00, $7a, $00, $6a, $20, $68, $20, $68, $00, $6a, $00
	db $08, $f8, $00, $00, $00, $00, $f8, $08

Call_04_7D97::
	ld de, $7d7f
	ldh a, [$fff7]
	cp $07
	jr nz, jr_004_7da3

	ld de, $7d87

jr_004_7da3:
	call Call_3C3B
	call Call_04_7F36
	call Call_04_6D53
	call Call_088C
	jr nz, jr_004_7db4

	call Call_3BB4

jr_004_7db4:
	call Call_04_6D9D
	call Call_3B9E
	ldh a, [$fff0]
	rst $00

JumpTable_04_7DBD::
	dw Jump_04_7DC3
	dw Jump_04_7DD7
	dw Jump_04_7E0E

Jump_04_7DC3::
	call Call_0891
	jr nz, jr_004_7dcb

	call Call_3B8D

jr_004_7dcb:
	ldh a, [$ffe7]
	rra
	rra
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_04_7DD7::
	call Call_27ED
	and $03
	jr z, jr_004_7de5

	call Call_27ED
	and $03
	jr jr_004_7de8

jr_004_7de5:
	call Call_04_6E28

jr_004_7de8:
	ld e, a
	ld d, b
	ld hl, $7d8f
	add hl, de
	ld a, [hl]
	ld hl, $c240
	add hl, bc
	ld [hl], a
	ld hl, $7d93
	add hl, de
	ld a, [hl]
	ld hl, $c250
	add hl, bc
	ld [hl], a
	call Call_0891
	call Call_27ED
	and $0f
	add $20
	ld [hl], a
	call Call_3B8D
	ld [hl], b
	ret


Jump_04_7E0E::
	call Call_3BF6
	call Call_0891
	jr z, jr_004_7e46

	ld hl, $c2a0
	add hl, bc
	ld a, [hl]
	and $03
	jr nz, jr_004_7e26

	ld a, [hl]
	and $0c
	jr nz, jr_004_7e30

	jr jr_004_7e3c

jr_004_7e26:
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a
	jr jr_004_7e38

jr_004_7e30:
	ld hl, $c250
	add hl, bc
	ld a, [hl]
	cpl
	inc a
	ld [hl], a

jr_004_7e38:
	ld a, $09
	ldh [$fff2], a

jr_004_7e3c:
	ldh a, [$ffe7]
	rra
	rra
	and $01
	call Call_3B87
	ret


Jump_004_7e46:
jr_004_7e46:
	call Call_04_7E4D
	call Call_04_6D4D
	ret


Call_04_7E4D::
	ld a, $02
	call Call_3C01
	jr c, jr_004_7e71

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

jr_004_7e71:
	ret


	db $56, $00, $56, $20, $54, $00, $54, $20, $52, $00, $52, $20, $50, $00, $50, $20

Call_04_7E82::
	ld de, $7e72
	call Call_3C3B
	call Call_04_7F36
	call Call_04_6D53
	call Call_04_6D9D
	call Call_3B9E
	ldh a, [$fff0]
	and $03
	rst $00

JumpTable_04_7E99::
	dw Jump_04_7EA1
	dw Jump_04_7EB6
	dw Jump_04_7EDA
	dw Jump_04_7F07

Jump_04_7EA1::
	ld a, $ff
	call Call_3B87
	call Call_0891
	jr nz, jr_004_7eb3

	ld [hl], $1f
	call Call_3B8D
	call Call_3DAF

jr_004_7eb3:
	ret


	db $01, $00

Jump_04_7EB6::
	call Call_0891
	jr nz, jr_004_7ec7

	call Call_27ED
	and $3f
	add $70
	ld [hl], a
	call Call_3B8D
	ret


jr_004_7ec7:
	ld hl, $7eb4

Jump_004_7eca:
	srl a
	srl a
	srl a
	srl a
	ld e, a
	ld d, b
	add hl, de
	ld a, [hl]
	call Call_3B87
	ret


Jump_04_7EDA::
	call Call_3BB4
	call Call_0891
	jr nz, jr_004_7eeb

	ld [hl], $1f
	call Call_3B8D
	call Call_3DAF
	ret


jr_004_7eeb:
	ldh a, [$ffe7]
	xor c
	push af
	and $0f
	jr nz, jr_004_7ef8

	ld a, $08
	call Call_3C25

jr_004_7ef8:
	pop af
	srl a
	srl a
	and $01
	call Call_3B87
	inc [hl]
	inc [hl]
	ret


	db $00, $01

Jump_04_7F07::
	call Call_0891
	jr nz, jr_004_7f1d

	call Call_27ED
	and $1f
	add $30
	ld [hl], a
	call Call_3B8D
	ld a, $08
	call Call_3C25
	ret


jr_004_7f1d:
	ld hl, $7f05
	jp Jump_004_7eca


Call_04_7F23::
	ld hl, $c240
	add hl, bc
	ld a, [hl]
	rl a
	ld a, $00
	jr c, jr_004_7f30

	ld a, $20

jr_004_7f30:
	ld hl, $ffed
	xor [hl]
	ld [hl], a
	ret


Call_04_7F36::
	ldh a, [$ffea]
	cp $05
	jr nz, jr_004_7f56

Call_04_7F3C::
	ld a, [$db95]
	cp $07
	jr z, jr_004_7f56

	ld hl, $c1a8
	ld a, [$c19f]
	or [hl]
	ld hl, $c14f
	or [hl]
	jr nz, jr_004_7f56

	ld a, [$c124]
	and a
	jr z, jr_004_7f57

jr_004_7f56:
	pop af

jr_004_7f57:
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
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
