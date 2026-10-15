; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

;@ path: text/dialog
;@ A single byte ($01) in front of DialogPointers; nothing reads it as part of a table.
DialogTablesStart::
	db $01

;@ path: text/dialog
;@ The address of each of the 640 dialogs ($000-$27F; OpenDialog opens $000-$0FF, OpenDialogTable1 $100-$1FF, OpenDialogTable2 $200-$27F), one word per dialog; the bank comes from DialogBanks. Read by DialogStateDrawChar. Addresses without a label lie in bank $14; $0000 marks an unused number. Text format: one byte per character, mostly ASCII (^ is the apostrophe, # types the next letter of the player's name, other codes are symbols and item pictures of the font, see DialogCharGlyphs); the box shows 16 characters per line, 2 lines at a time, so the texts are padded with spaces; $FF ends a text, $FE ends it with a choice of two answers.
DialogPointers::
	dw $5c00, $5c59, $5d1a, $5db9  ; dialog $000-$003
	dw $5e45, $5e93, $5eda, $5f86  ; dialog $004-$007
	dw $5fc5, $6012, $6072, $6117  ; dialog $008-$00B
	dw $6164, $61ac, $61fa, $6284  ; dialog $00C-$00F
	dw $62ee, $633e, $636f, $6415  ; dialog $010-$013
	dw $6471, $64d7, $6511, $657d  ; dialog $014-$017
	dw $65da, $6619, $6658, $6701  ; dialog $018-$01B
	dw $6737, $6762, $67bc, $67f6  ; dialog $01C-$01F
	dw $681e, $6827, $6868, $6881  ; dialog $020-$023
	dw $689a, $68f3, $694f, $69ab  ; dialog $024-$027
	dw $6a29, $6a80, $6ae1, $6b2c  ; dialog $028-$02B
	dw $6b2c, $6b5c, $6b8b, $6bca  ; dialog $02C-$02F
	dw $6bf7, $6c38, $6c67, $6c96  ; dialog $030-$033
	dw $6cc5, $6d14, $6d34, $6d6e  ; dialog $034-$037
	dw $6d6e, $6db6, $6e06, $6e06  ; dialog $038-$03B
	dw $6e32, $6e9d, $6ecc, $6ee8  ; dialog $03C-$03F
	dw $6ef3, $6f23, $6f6b, $6fac  ; dialog $040-$043
	dw $700b, $7057, $70b8, $70e7  ; dialog $044-$047
	dw $7167, $71a8, $71e9, $724a  ; dialog $048-$04B
	dw $7296, $72c7, $7333, $73a1  ; dialog $04C-$04F
	dw $73c2, $7413, $7449, $7484  ; dialog $050-$053
	dw $74cb, $7588, $7638, $7657  ; dialog $054-$057
	dw $7678, $7699, $76ba, $76db  ; dialog $058-$05B
	dw $76fc, $771d, $773e, $774f  ; dialog $05C-$05F
	dw $774f, $7760, $777c, $778a  ; dialog $060-$063
	dw $77a7, $77b6, $77c7, $77e8  ; dialog $064-$067
	dw $77f7, $7806, $7816, $7827  ; dialog $068-$06B
	dw $7838, $7859, $786a, $787b  ; dialog $06C-$06F
	dw $788c, $789d, $78ae, $78bf  ; dialog $070-$073
	dw $78cf, $78de, $78ee, $78fe  ; dialog $074-$077
	dw $790e, $791e, $792e, $793f  ; dialog $078-$07B
	dw $795b, $796c, $799c, $79bd  ; dialog $07C-$07F
	dw Dialog080, Dialog081, Dialog082, Dialog083  ; dialog $080-$083
	dw Dialog084, Dialog085, Dialog086, Dialog087  ; dialog $084-$087
	dw Dialog088, Dialog089, Dialog08A, Dialog08B  ; dialog $088-$08B
	dw Dialog08C, Dialog08D, Dialog08E, Dialog08F  ; dialog $08C-$08F
	dw Dialog090, Dialog091, Dialog092, Dialog093  ; dialog $090-$093
	dw Dialog094, Dialog095, Dialog096, Dialog097  ; dialog $094-$097
	dw Dialog098, Dialog099, Dialog09A, Dialog09A  ; dialog $098-$09B
	dw Dialog09C, Dialog09D, Dialog09E, Dialog09E  ; dialog $09C-$09F
	dw Dialog0A0, Dialog0A0, Dialog0A2, Dialog0A3  ; dialog $0A0-$0A3
	dw Dialog0A4, Dialog0A5, Dialog0A6, Dialog0A7  ; dialog $0A4-$0A7
	dw Dialog0A8, Dialog0A9, Dialog0AA, Dialog0AB  ; dialog $0A8-$0AB
	dw Dialog0AC, Dialog0AD, Dialog0AE, Dialog0AF  ; dialog $0AC-$0AF
	dw Dialog0B0, Dialog0B1, Dialog0B2, Dialog0B3  ; dialog $0B0-$0B3
	dw Dialog0B4, Dialog0B5, Dialog0B6, Dialog0B7  ; dialog $0B4-$0B7
	dw Dialog0B8, Dialog0B8, Dialog0BA, Dialog0BB  ; dialog $0B8-$0BB
	dw Dialog0BB, Dialog0BD, Dialog0BE, Dialog0BE  ; dialog $0BC-$0BF
	dw Dialog0BE, Dialog0C1, Dialog0C2, Dialog0C3  ; dialog $0C0-$0C3
	dw Dialog0C4, Dialog0C5, Dialog0C6, Dialog0C7  ; dialog $0C4-$0C7
	dw Dialog0C8, Dialog0C9, Dialog0CA, Dialog0CB  ; dialog $0C8-$0CB
	dw Dialog0CC, Dialog0CD, Dialog0CE, Dialog0CE  ; dialog $0CC-$0CF
	dw Dialog0D0, Dialog0D1, Dialog0D1, Dialog0D3  ; dialog $0D0-$0D3
	dw Dialog0D3, Dialog0D3, Dialog0D6, Dialog0D6  ; dialog $0D4-$0D7
	dw Dialog0D8, Dialog0D9, Dialog0DA, Dialog0DB  ; dialog $0D8-$0DB
	dw Dialog0DC, Dialog0DD, Dialog0DE, Dialog0DF  ; dialog $0DC-$0DF
	dw Dialog0E0, Dialog0E1, Dialog0E2, Dialog0E3  ; dialog $0E0-$0E3
	dw Dialog0E4, Dialog0E5, Dialog0E6, Dialog0E7  ; dialog $0E4-$0E7
	dw Dialog0E8, Dialog0E9, Dialog0EA, Dialog0EA  ; dialog $0E8-$0EB
	dw Dialog0EA, Dialog0ED, Dialog0EE, Dialog0EF  ; dialog $0EC-$0EF
	dw Dialog0F0, Dialog0F1, Dialog0F2, Dialog0F3  ; dialog $0F0-$0F3
	dw Dialog0F4, Dialog0F5, Dialog0F6, Dialog0F7  ; dialog $0F4-$0F7
	dw Dialog0F8, Dialog0F9, Dialog0FA, Dialog0FB  ; dialog $0F8-$0FB
	dw Dialog0FC, Dialog0FD, Dialog0FE, Dialog0FF  ; dialog $0FC-$0FF
	dw Dialog100, Dialog101, Dialog102, Dialog103  ; dialog $100-$103
	dw Dialog104, Dialog105, Dialog106, Dialog107  ; dialog $104-$107
	dw Dialog108, Dialog109, Dialog10A, Dialog10B  ; dialog $108-$10B
	dw Dialog10C, Dialog10D, Dialog10E, Dialog10F  ; dialog $10C-$10F
	dw Dialog110, Dialog111, Dialog112, Dialog113  ; dialog $110-$113
	dw Dialog114, Dialog115, Dialog116, Dialog117  ; dialog $114-$117
	dw Dialog117, Dialog119, Dialog11A, Dialog11B  ; dialog $118-$11B
	dw Dialog11C, Dialog11D, Dialog11E, Dialog11F  ; dialog $11C-$11F
	dw Dialog120, Dialog121, Dialog122, Dialog123  ; dialog $120-$123
	dw Dialog124, Dialog124, Dialog124, Dialog124  ; dialog $124-$127
	dw Dialog128, Dialog129, Dialog12A, Dialog12B  ; dialog $128-$12B
	dw Dialog12C, Dialog12D, Dialog12E, Dialog12E  ; dialog $12C-$12F
	dw Dialog130, Dialog131, Dialog132, Dialog133  ; dialog $130-$133
	dw Dialog134, Dialog135, Dialog136, Dialog137  ; dialog $134-$137
	dw Dialog138, Dialog139, Dialog13A, Dialog13B  ; dialog $138-$13B
	dw Dialog13C, Dialog13D, Dialog13E, Dialog13F  ; dialog $13C-$13F
	dw Dialog140, Dialog141, Dialog142, Dialog143  ; dialog $140-$143
	dw Dialog144, Dialog145, Dialog146, Dialog147  ; dialog $144-$147
	dw Dialog148, Dialog149, Dialog14A, Dialog14B  ; dialog $148-$14B
	dw Dialog14C, Dialog14D, Dialog14E, Dialog14F  ; dialog $14C-$14F
	dw Dialog150, Dialog151, Dialog152, Dialog153  ; dialog $150-$153
	dw Dialog154, Dialog155, Dialog156, Dialog157  ; dialog $154-$157
	dw Dialog158, Dialog158, Dialog15A, Dialog15B  ; dialog $158-$15B
	dw Dialog15C, Dialog15D, Dialog15E, Dialog15F  ; dialog $15C-$15F
	dw Dialog160, Dialog161, Dialog162, Dialog163  ; dialog $160-$163
	dw Dialog164, Dialog165, Dialog166, Dialog167  ; dialog $164-$167
	dw Dialog168, Dialog169, Dialog16A, Dialog16B  ; dialog $168-$16B
	dw Dialog16C, Dialog16D, $0000, $0000  ; dialog $16C-$16F
	dw Dialog170, Dialog171, Dialog172, Dialog173  ; dialog $170-$173
	dw Dialog174, Dialog175, Dialog176, Dialog177  ; dialog $174-$177
	dw Dialog178, Dialog179, Dialog179, Dialog179  ; dialog $178-$17B
	dw Dialog179, Dialog179, Dialog179, Dialog179  ; dialog $17C-$17F
	dw Dialog180, Dialog181, Dialog182, Dialog183  ; dialog $180-$183
	dw Dialog184, Dialog185, Dialog186, Dialog187  ; dialog $184-$187
	dw Dialog188, Dialog189, Dialog18A, Dialog18B  ; dialog $188-$18B
	dw Dialog18C, Dialog18D, Dialog18E, Dialog18F  ; dialog $18C-$18F
	dw Dialog18F, Dialog191, Dialog192, Dialog193  ; dialog $190-$193
	dw Dialog194, Dialog195, Dialog196, Dialog197  ; dialog $194-$197
	dw Dialog198, Dialog199, Dialog19A, Dialog19B  ; dialog $198-$19B
	dw Dialog19C, Dialog19D, Dialog19E, Dialog19F  ; dialog $19C-$19F
	dw Dialog19F, Dialog1A1, Dialog1A2, Dialog1A3  ; dialog $1A0-$1A3
	dw Dialog1A4, Dialog1A5, Dialog1A6, Dialog1A7  ; dialog $1A4-$1A7
	dw Dialog1A8, Dialog1A9, Dialog1AA, Dialog1AB  ; dialog $1A8-$1AB
	dw Dialog1AC, Dialog1AD, Dialog1AE, Dialog1AF  ; dialog $1AC-$1AF
	dw Dialog1B0, Dialog1B1, Dialog1B2, Dialog1B3  ; dialog $1B0-$1B3
	dw Dialog1B4, Dialog1B5, Dialog1B6, Dialog1B7  ; dialog $1B4-$1B7
	dw Dialog1B8, Dialog1B9, Dialog1BA, Dialog1BB  ; dialog $1B8-$1BB
	dw Dialog1BC, Dialog1BD, Dialog1BE, Dialog1BF  ; dialog $1BC-$1BF
	dw Dialog1BF, Dialog1C1, Dialog1C2, Dialog1C3  ; dialog $1C0-$1C3
	dw Dialog1C4, Dialog1C4, Dialog1C6, Dialog1C7  ; dialog $1C4-$1C7
	dw Dialog1C8, Dialog1C9, Dialog1CA, Dialog1CB  ; dialog $1C8-$1CB
	dw Dialog1CC, Dialog1CD, Dialog1CE, Dialog1CF  ; dialog $1CC-$1CF
	dw Dialog1D0, Dialog1D1, Dialog1D2, Dialog1D3  ; dialog $1D0-$1D3
	dw Dialog1D4, Dialog1D5, Dialog1D6, Dialog1D7  ; dialog $1D4-$1D7
	dw Dialog1D8, Dialog1D9, Dialog1DA, Dialog1DB  ; dialog $1D8-$1DB
	dw Dialog1DC, Dialog1DD, Dialog1DE, Dialog1DF  ; dialog $1DC-$1DF
	dw Dialog1DF, Dialog1E1, Dialog1E2, Dialog1E3  ; dialog $1E0-$1E3
	dw Dialog1E4, Dialog1E5, Dialog1E6, Dialog1E7  ; dialog $1E4-$1E7
	dw Dialog1E8, Dialog1E9, Dialog1EA, Dialog1EB  ; dialog $1E8-$1EB
	dw Dialog1EC, Dialog1ED, Dialog1EE, Dialog1EE  ; dialog $1EC-$1EF
	dw Dialog1EE, Dialog1F1, Dialog1F2, Dialog1F3  ; dialog $1F0-$1F3
	dw Dialog1F4, Dialog1F5, Dialog1F6, Dialog1F6  ; dialog $1F4-$1F7
	dw Dialog1F8, Dialog1F8, Dialog1FA, Dialog1FB  ; dialog $1F8-$1FB
	dw Dialog1FC, Dialog1FD, Dialog1FE, Dialog1FF  ; dialog $1FC-$1FF
	dw Dialog200, Dialog201, Dialog202, Dialog203  ; dialog $200-$203
	dw Dialog204, Dialog205, Dialog206, Dialog207  ; dialog $204-$207
	dw Dialog208, Dialog209, Dialog20A, Dialog20B  ; dialog $208-$20B
	dw Dialog20C, Dialog20D, Dialog20E, Dialog20F  ; dialog $20C-$20F
	dw Dialog20F, Dialog211, Dialog212, Dialog213  ; dialog $210-$213
	dw Dialog214, Dialog215, Dialog216, Dialog217  ; dialog $214-$217
	dw Dialog218, Dialog219, Dialog21A, Dialog21B  ; dialog $218-$21B
	dw Dialog21C, Dialog21D, Dialog21E, Dialog21F  ; dialog $21C-$21F
	dw Dialog21F, Dialog221, Dialog222, Dialog223  ; dialog $220-$223
	dw Dialog224, Dialog225, Dialog226, Dialog227  ; dialog $224-$227
	dw Dialog228, Dialog228, Dialog228, Dialog228  ; dialog $228-$22B
	dw Dialog228, Dialog228, Dialog228, Dialog228  ; dialog $22C-$22F
	dw Dialog228, Dialog231, Dialog232, Dialog233  ; dialog $230-$233
	dw Dialog234, Dialog235, Dialog236, Dialog237  ; dialog $234-$237
	dw Dialog238, Dialog239, Dialog23A, Dialog23B  ; dialog $238-$23B
	dw Dialog23C, Dialog23C, Dialog23C, Dialog23C  ; dialog $23C-$23F
	dw Dialog23C, Dialog241, Dialog242, Dialog243  ; dialog $240-$243
	dw Dialog244, Dialog245, Dialog246, Dialog247  ; dialog $244-$247
	dw Dialog248, Dialog249, Dialog249, Dialog24B  ; dialog $248-$24B
	dw Dialog24C, Dialog24D, Dialog24E, Dialog24F  ; dialog $24C-$24F
	dw Dialog250, Dialog251, Dialog252, Dialog253  ; dialog $250-$253
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $254-$257
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $258-$25B
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $25C-$25F
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $260-$263
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $264-$267
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $268-$26B
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $26C-$26F
	dw Dialog253, Dialog253, Dialog253, Dialog253  ; dialog $270-$273
	dw Dialog253, Dialog253, Dialog276, Dialog277  ; dialog $274-$277
	dw Dialog278, Dialog279, Dialog27A, Dialog27B  ; dialog $278-$27B
	dw Dialog27C, Dialog27D, Dialog27E, Dialog27F  ; dialog $27C-$27F

;@ path: text/dialog
;@ Low byte of the VRAM address of the text tile of each of the 32 character places of the dialog box (where DialogStateDrawChar copies the glyph).
DialogCharTileLow::
	db $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0, $f0
	db $00, $10, $20, $30, $40, $50, $60, $70, $80, $90, $a0, $b0, $c0, $d0, $e0, $f0

;@ path: text/dialog
;@ High byte of the VRAM address of the text tile of each of the 32 character places (with DialogCharTileLow).
DialogCharTileHigh::
	db $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d, $8d
	db $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e, $8e

;@ path: text/dialog
;@ The tile number of each of the 32 character places (the tile DialogStatePlaceChar puts into the BG map).
DialogCharTileNumbers::
	db $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df
	db $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef

;@ path: text/dialog
;@ High byte of the BG map offset of each character place: 32 for the box at the top of the screen, then 32 for the box at the bottom (added to wBGOriginHigh).
DialogCharBGHigh::
	db $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98
	db $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98, $98
	db $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99
	db $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99, $99

;@ path: text/dialog
;@ Low byte of the BG map offset of each character place, top box then bottom box (added to wBGOriginLow, wrapping within the BG map row).
DialogCharBGLow::
	db $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51
	db $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $90, $91
	db $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $70, $71
	db $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $b0, $b1

;@ path: text/dialog
;@ The glyph of each character code: the number of its 16-byte tile in the font at $5000 (DialogTypeChar); 0 = the blank glyph. Codes $41-$5A are A-Z, $61-$7A a-z, $30-$39 the digits; codes from $80 on are symbols and the pictures of the trading items.
DialogCharGlyphs::
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; codes $00-$0F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; codes $10-$1F
	db $7e, $3d, $41, $00, $8a, $8b, $44, $40, $45, $46, $8c, $8d, $3a, $3f, $3b, $00  ; codes $20-$2F
	db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $42, $43, $8e, $00, $8f, $3c  ; codes $30-$3F
	db $00, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e  ; codes $40-$4F
	db $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $00, $00, $00, $40, $00  ; codes $50-$5F
	db $00, $1a, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $24, $25, $26, $27, $28  ; codes $60-$6F
	db $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $3e, $00, $00, $00, $00, $00  ; codes $70-$7F
	db $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $52, $53, $59, $5a, $5b  ; codes $80-$8F
	db $5c, $5d, $59, $5a, $5b, $5c, $5d, $32, $6f, $6d, $6e, $00, $00, $00, $00, $00  ; codes $90-$9F
	db $3d, $3c, $3f, $7e, $39, $3a, $3b, $7a, $7b, $00, $00, $00, $00, $00, $00, $00  ; codes $A0-$AF
	db $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $9b, $9c, $9d, $9e, $9f, $38  ; codes $B0-$BF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00  ; codes $C0-$CF
	db $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f  ; codes $D0-$DF
	db $88, $90, $91, $92, $93, $94, $95, $89, $96, $97, $98, $99, $9a, $87, $86, $00  ; codes $E0-$EF
	db $34, $35, $36, $37, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7e, $00, $00  ; codes $F0-$FF

;@ path: text/dialog
;@ The ROM bank of each dialog's text (bits 0-4: $09, $14, $16, $1C or $1D), one byte per dialog; bit 7 set means the B button does not hurry the text along.
DialogBanks::
	db $14, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $94  ; dialog $000-$00F
	db $14, $14, $14, $94, $14, $14, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14  ; dialog $010-$01F
	db $14, $14, $14, $14, $14, $14, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14  ; dialog $020-$02F
	db $14, $14, $14, $14, $14, $14, $94, $14, $94, $14, $14, $14, $14, $14, $14, $14  ; dialog $030-$03F
	db $14, $14, $14, $14, $14, $94, $94, $94, $94, $94, $94, $94, $94, $94, $94, $94  ; dialog $040-$04F
	db $94, $94, $94, $94, $94, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14  ; dialog $050-$05F
	db $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14  ; dialog $060-$06F
	db $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14, $14  ; dialog $070-$07F
	db $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16  ; dialog $080-$08F
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96  ; dialog $090-$09F
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96  ; dialog $0A0-$0AF
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96  ; dialog $0B0-$0BF
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $96  ; dialog $0C0-$0CF
	db $96, $96, $96, $96, $96, $96, $96, $96, $96, $96, $16, $16, $16, $16, $16, $16  ; dialog $0D0-$0DF
	db $16, $96, $96, $96, $96, $96, $16, $16, $09, $89, $09, $09, $09, $09, $09, $09  ; dialog $0E0-$0EF
	db $09, $09, $09, $09, $09, $89, $89, $89, $09, $09, $09, $09, $09, $09, $89, $09  ; dialog $0F0-$0FF
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $9c, $9c, $9c, $9c, $9c, $9c, $9c, $9c  ; dialog $100-$10F
	db $9c, $9c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $110-$11F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $120-$12F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $130-$13F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $140-$14F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $150-$15F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $9c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $160-$16F
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c  ; dialog $170-$17F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $180-$18F
	db $1d, $9d, $1d, $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $190-$19F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $1A0-$1AF
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $1B0-$1BF
	db $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $1C0-$1CF
	db $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $9d, $9d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $1D0-$1DF
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $1d, $1d  ; dialog $1E0-$1EF
	db $1d, $1d, $1d, $1d, $1d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $9d, $9d  ; dialog $1F0-$1FF
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $200-$20F
	db $9d, $9d, $1d, $9d, $9d, $9d, $9d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $210-$21F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $220-$22F
	db $1d, $1d, $1d, $1d, $1d, $9d, $9d, $9d, $9d, $9d, $9d, $9d, $1d, $1d, $1d, $1d  ; dialog $230-$23F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $240-$24F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $250-$25F
	db $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d, $1d  ; dialog $260-$26F
	db $1d, $1d, $1d, $1d, $1d, $1d, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09  ; dialog $270-$27F

;@ path: unused
;@ Free space at the end of the bank's data, filled with $FF.
Bank1CFreeSpace1::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;@ path: text/dialogs
;@ Dialog $100: "You've got the Full Moon Cello!"
Dialog100::
	db "You^ve got the  "
	db "Full Moon Cello!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $101: "You've got the Conch Horn!"
Dialog101::
	db "You^ve got the  "
	db "Conch Horn!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $102: "You've got the Sea Lily's Bell!"
Dialog102::
	db "You^ve got the  "
	db "Sea Lily^s Bell!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $103: "You've got the Surf Harp!"
Dialog103::
	db "You^ve got the  "
	db "Surf Harp!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $104: "You've got the Wind Marimba!"
Dialog104::
	db "You^ve got the  "
	db "Wind Marimba!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $105: "You've got the Coral Triangle!"
Dialog105::
	db "You^ve got the  "
	db "Coral Triangle!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $106: "You've got the Organ of Evening Calm!"
Dialog106::
	db "You^ve got the  "
	db "Organ of        "
	db "  Evening Calm!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $107: "You've got the Thunder Drum!"
Dialog107::
	db "You^ve got the  "
	db "Thunder Drum!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $108: "Turn aside the spined ones with a shield..." (B does not hurry it)
Dialog108::
	db "Turn aside the  "
	db "spined ones with"
	db "a shield..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $109: "First, defeat the imprisoned Pols Voice, Last, Stalfos..." (B does not hurry it)
Dialog109::
	db "First, defeat   "
	db "the imprisoned  "
	db "Pols Voice,     "
	db "Last, Stalfos..."
	db $ff  ; end
	db $ff

;@ path: text/dialogs
;@ Dialog $10A: "Far away... Do not fear, dash and fly!" (B does not hurry it)
Dialog10A::
	db "Far away...     "
	db "Do not fear,    "
	db "dash and fly!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10B: "The glint of the tile will be your guide..." (B does not hurry it)
Dialog10B::
	db "The glint of the"
	db "tile will be    "
	db "your guide..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10C: "Dive under where torchlight beams do cross..." (B does not hurry it)
Dialog10C::
	db "Dive under where"
	db "torchlight beams"
	db "do cross..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10D: "Enter the space where the eyes have walls..." (B does not hurry it)
Dialog10D::
	db "Enter the space "
	db "where the eyes  "
	db "have walls..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10E: "The riddle is solved when the pillars fall!" (B does not hurry it)
Dialog10E::
	db "The riddle is   "
	db "solved when the "
	db "pillars fall!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $10F: "Fill all the holes with the rock that rolls, this (?) is the key!" (B does not hurry it)
Dialog10F::
	db "Fill all the    "
	db "holes with the  "
	db "rock that rolls,"
	db "this (", $ee, ") is the "
	db "key!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $110: "Something is inscribed on the stone slab, but you can't read it bec..." (B does not hurry it)
Dialog110::
	db "Something is    "
	db "inscribed on the"
	db "stone slab, but "
	db "you can^t read  "
	db "it because a    "
	db "piece is gone."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $111: "'I've got what was inside this box. Come and get it, if you can!' M..." (B does not hurry it)
Dialog111::
	db "^I^ve got what  "
	db "was inside this "
	db "box.  Come and  "
	db "get it, if you  "
	db "can!^  Master ", $dc
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $112: "Gulp! You found me! You're a real pesky kid, you know that?!"
Dialog112::
	db "Gulp!  You found"
	db "me!  You^re a   "
	db "real pesky kid, "
	db "you know that?!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $113: "Arrgh! I can't beat you! I'm outta here!"
Dialog113::
	db "Arrgh!  I can^t "
	db "beat you!  I^m  "
	db "outta here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $114: "You again?! You keep going and going... I can't outlast you! All ri..."
Dialog114::
	db "You again?!  You"
	db "keep going and  "
	db "going... I can^t"
	db "outlast you!    "
	db "All right, let^s"
	db "do it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $115: "WOOF! Dig! RUFF!"
Dialog115::
	db "WOOF! Dig! RUFF!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $116: "You put the missing scale in the mermaid statue!"
Dialog116::
	db "You put the     "
	db "missing scale in"
	db "the mermaid     "
	db "statue!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $117, $118: "Hey, man! When you want to save just push all the Buttons at once! ..."
Dialog117::
	db "Hey, man!  When "
	db "you want to save"
	db "just push all   "
	db "the Buttons at  "
	db "once!  Uhh...   "
	db "Don^t ask me    "
	db "what that means,"
	db "I^m just a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $119: "Well, it seems that after you save, you will start at the last door..."
Dialog119::
	db "Well, it seems  "
	db "that after you  "
	db "save, you will  "
	db "start at the    "
	db "last door you   "
	db "went through... "
	db "I^m not really  "
	db "sure why that is"
	db "^cause I^m just "
	db "a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11A: "I heard that you can press SELECT to look at the island map... But,..."
Dialog11A::
	db "I heard that you"
	db "can press SELECT"
	db "to look at the  "
	db "island map...   "
	db "But, I don^t    "
	db "understand what "
	db "they mean by    "
	db "that..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11B: "When you're running out of Hearts, you'd better enter a house or ca..."
Dialog11B::
	db "When you^re     "
	db "running out of  "
	db "Hearts, you^d   "
	db "better enter a  "
	db "house or cave..."
	db "Why?  I have no "
	db "idea, I^m just a"
	db "kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11C: "Hey, dude! What do you think of Marin? Uhh... I don't know, I'm jus..."
Dialog11C::
	db "Hey, dude! What "
	db "do you think of "
	db "Marin?  Uhh...  "
	db "I don^t know,   "
	db "I^m just a kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11D: "Where are you from, brother? ...Outside the island? What is 'outsid..."
Dialog11D::
	db "Where are you   "
	db "from, brother?  "
	db "...Outside the  "
	db "island?  What is"
	db "^outside?^  I^ve"
	db "never thought   "
	db "about it..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11E: "The giant egg on top Tamaranch Mountain? They say the Wind Fish is ..."
Dialog11E::
	db "The giant egg on"
	db "top Tamaranch   "
	db "Mountain?  They "
	db "say the Wind    "
	db "Fish is sleeping"
	db "inside of it... "
	db "Why?  I don^t   "
	db "know either..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $11F: "Dude! You're asking me when we started to live on this island? What..."
Dialog11F::
	db "Dude!  You^re   "
	db "asking me when  "
	db "we started to   "
	db "live on this    "
	db "island?  What do"
	db "you mean by     "
	db "^when?^  Whoa!  "
	db "The concept just"
	db "makes my head   "
	db "hurt!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $120: "Marin? She likes to go stare at the ocean all by herself... Why? He..."
Dialog120::
	db "Marin? She likes"
	db "to go stare at  "
	db "the ocean all by"
	db "herself...  Why?"
	db "Hey, I^m just a "
	db "kid, don^t ask  "
	db "me!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $121: "Hey... Where're you two going together? Hunh? Uh, I didn't mean any..."
Dialog121::
	db "Hey... Where^re "
	db "you two going   "
	db "together?  Hunh?"
	db "Uh, I didn^t    "
	db "mean anything..."
	db "I^m just a kid!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $122: "Hey hey, bro! About the Dream Shrine there... They say there's some..."
Dialog122::
	db "Hey hey, bro!   "
	db "About the Dream "
	db "Shrine there... "
	db "They say there^s"
	db "something good  "
	db "inside... ...   "
	db "I better not say"
	db "anything else   "
	db "as I^m just a   "
	db "kid!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $123: "Hunh?! Marin's not with you? What happened to her?"
Dialog123::
	db "Hunh?!  Marin^s "
	db "not with you?   "
	db "What happened to"
	db "her?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $124, $125, $126, $127: "Tsk tsk... What a shame..."
Dialog124::
	db "Tsk tsk...  What"
	db "a shame..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $128: "Oh thank you! You are indeed a generous person! Ah! I will give you..."
Dialog128::
	db "Oh thank you!   "
	db "You are indeed a"
	db "generous person!"
	db "Ah!  I will give"
	db "you this in     "
	db "return!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $129: "You traded your ? for ?! Maybe you can trade the ribbon for somethi..."
Dialog129::
	db "You traded your "
	db $e0, " for ", $e1, "!  Maybe "
	db "you can trade   "
	db "the ribbon for  "
	db "something else!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12A: "Because they all look alike, even I am sometimes confused... By the..."
Dialog12A::
	db "Because they all"
	db "look alike, even"
	db "I am sometimes  "
	db "confused...     "
	db "By the way, do  "
	db "you know Yoshi? "
	db "My baby keeps on"
	db "asking for a    "
	db "Yoshi Doll and I"
	db "don^t know what "
	db "to do about it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12B: "Oh! Will you give that doll to my baby?! Yes No"
Dialog12B::
	db "Oh!  Will you   "
	db "give that doll  "
	db "to my baby?!    "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $12C: "Because they all look alike, even I am sometimes confused..."
Dialog12C::
	db "Because they all"
	db "look alike, even"
	db "I am sometimes  "
	db "confused...     "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $12D: "Ahem! Really, I must insist that you not bring that awful beast in ..."
Dialog12D::
	db "Ahem!  Really, I"
	db "must insist that"
	db "you not bring   "
	db "that awful beast"
	db "in here!  Leave "
	db "that creature   "
	db "outside and then"
	db "we can talk!    "
	db "Good Bye!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $12E, $12F: "Ho ho ho! I really appre- ciate what you did for my poor, precious ..."
Dialog12E::
	db "Ho ho ho!       "
	db "I really appre- "
	db "ciate what you  "
	db "did for my poor,"
	db "precious BowWow!"
	db "You are such a  "
	db "nice boy!  How  "
	db "can I ever repay"
	db "you?  I know... "
	db "  SMOOOOOOOCH!  "
	db "You got a reward"
	db "from Madam Meow-"
	db "Meow... ... ... "
	db "L-l-lucky!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $130: "Ho ho ho! My BowWow is so proud of his fine fur coat!"
Dialog130::
	db "Ho ho ho!  My   "
	db "BowWow is so    "
	db "proud of his    "
	db "fine fur coat!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $131: "AIEEEEEEEE! It's terrrrbile! My BowWow was dognapped by... Mo-mo-MO..."
Dialog131::
	db "AIEEEEEEEE!     "
	db "It^s terrrrbile!"
	db "My BowWow was   "
	db "dognapped by... "
	db "Mo-mo-MOBLINS!! "
	db "OHHH!  AHHHH!   "
	db "Please! Somebody"
	db "help my poor    "
	db "BowWow!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $132: "Oh thank you! I'm so happy you brought my baby back! Now, would you..."
Dialog132::
	db "Oh thank you!   "
	db "I^m so happy you"
	db "brought my baby "
	db "back! Now, would"
	db "you be a dear   "
	db "and take him for"
	db "a walk? It would"
	db "really help me  "
	db "out a lot!  You "
	db "will?!  Thanks!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $133: "Well... I pretty much stick to myself, me and my letters... My name..."
Dialog133::
	db "Well... I pretty"
	db "much stick to   "
	db "myself, me and  "
	db "my letters...   "
	db "My name^s Write!"
	db "The only thing I"
	db "don^t like about"
	db "my hobby is that"
	db "I never receive "
	db "a response..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $134: "What's this?! A letter for me?! I'm so happy! ...And look! The lett..."
Dialog134::
	db "What^s this?!  A"
	db "letter for me?! "
	db "I^m so happy!   "
	db "...And look! The"
	db "letter came with"
	db "a photograph!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $135: "Mmm... She's so beautiful... I must give you something for your tro..."
Dialog135::
	db "Mmm... She^s so "
	db "beautiful...    "
	db "I must give you "
	db "something for   "
	db "your trouble... "
	db "Hmm...  Well, it"
	db "looks like all I"
	db "have is this    "
	db "broom... how^ll "
	db "that be?        "
	db "    Fine No..."
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $136: "You got a Broom as your reward from Mr. Write! But that photo was n..."
Dialog136::
	db "You got a Broom "
	db "as your reward  "
	db "from Mr. Write! "
	db "But that photo  "
	db "was not of..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $137: "Please! I really must insist you have this ?! Okay No Way"
Dialog137::
	db "Please! I really"
	db "must insist you "
	db "have this ", $e8, "!    "
	db "    Okay No Way"
	db $fe  ; end, then a choice of two answers
;@ path: text/dialogs
;@ Dialog $138: "Oh boy! Letter writing is such a great hobby!"
Dialog138::
	db "Oh boy!  Letter "
	db "writing is such "
	db "a great hobby!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $139: "Hello! I'm writing back to Christine now!"
Dialog139::
	db "Hello!  I^m     "
	db "writing back to "
	db "Christine now!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13A: "Salutations! You wouldn't know by the look of me, but I used to liv..."
Dialog13A::
	db "Salutations!    "
	db "You wouldn^t    "
	db "know by the look"
	db "of me, but I    "
	db "used to live in "
	db "the castle! My  "
	db "servants went   "
	db "berserk and I   "
	db "was forced to   "
	db "flee to my      "
	db "villa... So, you"
	db "want the key to "
	db "Ukuku Prairie,  "
	db "do you?  I may  "
	db "be able to help "
	db "you...  Let^s   "
	db "make... a deal, "
	db "shall we? I want"
	db "you to retrieve "
	db "the Golden Leaf "
	db "I left behind in"
	db "the castle when "
	db "I fled...       "
	db "    Okay No Way"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $13B: "Smashing! To tell you the truth, there are five leaves, and I want ..."
Dialog13B::
	db "Smashing!  To   "
	db "tell you the    "
	db "truth, there are"
	db "five leaves, and"
	db "I want them all!"
	db "Oh, you^ll need "
	db "to do some dig- "
	db "ging, so buy a  "
	db "shovel! Are you "
	db "off, then?  Good"
	db "luck!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13C: "Well, I never! I thought you looked cowardly, but... Please, leave ..."
Dialog13C::
	db "Well, I never!  "
	db "I thought you   "
	db "looked cowardly,"
	db "but...  Please, "
	db "leave me... just"
	db "get out here!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13D: "Ahh! Tres Bien! I see you have recovered all of the leaves! Now, mo..."
Dialog13D::
	db "Ahh!  Tres Bien!"
	db "I see you have  "
	db "recovered all of"
	db "the leaves! Now,"
	db "move this box   "
	db "and you will    "
	db "find your       "
	db "reward!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13E: "I am forever in your debt for getting my leaves back!"
Dialog13E::
	db "I am forever in "
	db "your debt for   "
	db "getting my      "
	db "leaves back!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $13F: "Ah! Bonjour! [NAME], for the love of justice, and my own sake, you ..."
Dialog13F::
	db "Ah!  Bonjour!   "
	db "#####, for the  "
	db "love of justice,"
	db "and my own sake,"
	db "you must find   "
	db "all the leaves!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $140: "Er...Uh...Hmm... How to say... Please call... Outside... ... It see..."
Dialog140::
	db "Er...Uh...Hmm..."
	db "How to say...   "
	db "Please call...  "
	db "Outside...  ... "
	db "It seems that   "
	db "old man Ulrira  "
	db "is a shy guy,   "
	db "in person..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $141: "'BRRING! BRRING! Hello! It's me, Ulrira! Ask me anything about the ..."
Dialog141::
	db "^BRRING! BRRING!"
	db "Hello!  It^s me,"
	db "Ulrira!  Ask me "
	db "anything about  "
	db "the island!  If "
	db "you get lost,   "
	db "give me a call! "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $142: "'BRRING! BRRING! Hello, this is Ulrira! ...Well, most Moblins live ..."
Dialog142::
	db "^BRRING! BRRING!"
	db "Hello, this is  "
	db "Ulrira! ...Well,"
	db "most Moblins    "
	db "live in the Mys-"
	db "terious Forest, "
	db "but some live in"
	db "the caves of Tal"
	db "Tal Heights...  "
	db "I hope that is  "
	db "what you wanted "
	db "to know! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $143: "'BRRING! BRRING! Yes, this is Ulrira. The Indigestible Flowers of G..."
Dialog143::
	db "^BRRING! BRRING!"
	db "Yes, this is    "
	db "Ulrira.  The    "
	db "Indigestible    "
	db "Flowers of      "
	db "Goponga Swamp..."
	db "Those flowers   "
	db "are BowWow^s    "
	db "favorite.  Why  "
	db "don^t you take  "
	db "him for a walk  "
	db "there?  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $144: "'BRRING! BRRING! Hi, it's Ulrira! ...Have you met everyone on the i..."
Dialog144::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "...Have you met "
	db "everyone on the "
	db "island?  There^s"
	db "a man named     "
	db "Richard who     "
	db "lives in Pothole"
	db "Field, southeast"
	db "of the village. "
	db "Why not pay him "
	db "a visit?  That^s"
	db "all I can tell  "
	db "you for now!    "
	db "Bye!  CLICK!^"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $145: "'BRRING! BRRING! Old man Ulrira here! ...Do you like bananas? Try t..."
Dialog145::
	db "^BRRING! BRRING!"
	db "Old man Ulrira  "
	db "here! ...Do you "
	db "like bananas?   "
	db "Try talking to  "
	db "people in the   "
	db "village again!  "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $146: "'BRRING! BRRING! Ulrira speaking! You know, there is a library in t..."
Dialog146::
	db "^BRRING! BRRING!"
	db "Ulrira speaking!"
	db "You know, there "
	db "is a library in "
	db "the village that"
	db "might have some "
	db "good information"
	db "for you!  Talk  "
	db "to you later!   "
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $147: "'BRRING! BRRING! Yeah, it's me, Ulrira! Hmmm... You can't find all ..."
Dialog147::
	db "^BRRING! BRRING!"
	db "Yeah, it^s me,  "
	db "Ulrira!  Hmmm..."
	db "You can^t find  "
	db "all the leaves  "
	db "you say?  That^s"
	db "a stumper!  Ahh,"
	db "check out the   "
	db "raven by the    "
	db "castle!  In any "
	db "case, try many  "
	db "things!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $148: "'BRRING! BRRING! Ulrira here! ... Shovel... Did you purchase a shov..."
Dialog148::
	db "^BRRING! BRRING!"
	db "Ulrira here! ..."
	db "Shovel...  Did  "
	db "you purchase a  "
	db "shovel?  You may"
	db "find something  "
	db "if you dig here "
	db "and there!  Bye!"
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $149: "'BRRING! BRRING! Ya, it's Ulrira! The cave in the Ukuku Prairie is ..."
Dialog149::
	db "^BRRING! BRRING!"
	db "Ya, it^s Ulrira!"
	db "The cave in the "
	db "Ukuku Prairie is"
	db "the key!  Yes, I"
	db "mean the key    "
	db "cave, no pun    "
	db "intended!  Bye! "
	db "CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14A: "'BRRING! BRRING! Hi, this is Ulrira! In the Yarna Desert, which is ..."
Dialog14A::
	db "^BRRING! BRRING!"
	db "Hi, this is     "
	db "Ulrira!  In the "
	db "Yarna Desert,   "
	db "which is located"
	db "in the southeast"
	db "of the island,  "
	db "you will find   "
	db "something called"
	db "the Angler Key. "
	db "Hmmm... How much"
	db "more obvious do "
	db "I have to be?   "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14B: "'BRRING! BRRING! This is Ulrira! Now you're being haunted by a ghos..."
Dialog14B::
	db "^BRRING! BRRING!"
	db "This is Ulrira! "
	db "Now you^re being"
	db "haunted by a    "
	db "ghost?! Well,   "
	db "how about taking"
	db "him where he    "
	db "wants to go?    "
	db "Bye! CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14C: "'BRRING! BRRING! Hi, it's Ulrira! The Catfish's mouth is wide open?..."
Dialog14C::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "The Catfish^s   "
	db "mouth is wide   "
	db "open?  It sounds"
	db "like a great    "
	db "place to dive!  "
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14D: "'BRRING! BRRING! Ulrira here! ... Have you been to the Face Shrine?..."
Dialog14D::
	db "^BRRING! BRRING!"
	db "Ulrira here! ..."
	db "Have you been to"
	db "the Face Shrine?"
	db "It is north of  "
	db "Animal Village. "
	db "That is a very  "
	db "interesting     "
	db "ruin... CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $14E: "'BRRING! BRRING! Hi, it's Ulrira! Have you heard of the Flying Roos..."
Dialog14E::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "Have you heard  "
	db "of the Flying   "
	db "Rooster of Mabe "
	db "Village?  In the"
	db "good old days,  "
	db "it used to give "
	db "us rides if we  "
	db "held it above   "
	db "our heads... Now"
	db "it is lying     "
	db "under the       "
	db "Weathercock...  "
	db "Is that useful  "
	db "for you?  I hope"
	db "so! Bye! CLICK!^"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $14F: "'BRRING! BRRING! Hi, it's Ulrira! The head of the turtle is in your..."
Dialog14F::
	db "^BRRING! BRRING!"
	db "Hi, it^s Ulrira!"
	db "The head of the "
	db "turtle is in    "
	db "your way?  Put  "
	db "life into it and"
	db "it will move!   "
	db "It^s true! True!"
	db "Bye!  CLICK!^"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $150: "...SWAMP... A path opens... in the blooms..."
Dialog150::
	db "   ...SWAMP...  "
	db " A path opens..."
	db "in the blooms..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $151: "...PRAIRIE... ...PRAIRIE... The Prairie is waiting..."
Dialog151::
	db "  ...PRAIRIE... "
	db "  ...PRAIRIE... "
	db " The Prairie is "
	db "     waiting..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $152: "...WATERFALL... It is hidden in the waterfall..."
Dialog152::
	db "...WATERFALL... "
	db "It is hidden in "
	db "the waterfall..."
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $153: "...BAY... Your road goes into the bay..."
Dialog153::
	db "    ...BAY...   "
	db "Your road goes  "
	db "into the bay... "
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $154: "...SHRINE... An island secret in the shrine..."
Dialog154::
	db "   ...SHRINE... "
	db "An island secret"
	db "in the shrine..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $155: "...MOUNTAIN... Something calls ...from the mountains..."
Dialog155::
	db " ...MOUNTAIN... "
	db "Something calls "
	db "  ...from the   "
	db "  mountains..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $156: "...OCARINA... The music of the Ocarina leads..."
Dialog156::
	db "  ...OCARINA... "
	db "The music of the"
	db "Ocarina leads..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $157: "...EGG.... The Egg on the mountain calls!"
Dialog157::
	db "    ...EGG....  "
	db "The Egg on the  "
	db "mountain calls!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialogs $158, $159: "Then YOU sweep the island!"
Dialog158::
	db "Then YOU sweep  "
	db "the island!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15A: "YAHOO! I'm fine, and you?!"
Dialog15A::
	db "YAHOO!   I^m    "
	db "fine, and you?!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15B: "YAHOO! I worked too hard and now my broom is worn to the handle!"
Dialog15B::
	db "YAHOO!  I worked"
	db "too hard and now"
	db "my broom is worn"
	db "to the handle!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15C: "YAHOO! YAHOO! A new broom?! For me? It is, isn't it?! Yes No"
Dialog15C::
	db "YAHOO!  YAHOO!  "
	db "A new broom?!   "
	db "For me?  It is, "
	db "isn^t it?!      "
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $15D: "Okay! In return you can have this fishing hook I found when I swept..."
Dialog15D::
	db "Okay!  In return"
	db "you can have    "
	db "this fishing    "
	db "hook I found    "
	db "when I swept by "
	db "the river bank!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15E: "You exchanged ? for the fishing hook ?! What will the fishing hook ..."
Dialog15E::
	db "You exchanged ", $e8, " "
	db "for the fishing "
	db "hook ", $e9, "!  What   "
	db "will the fishing"
	db "hook become?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $15F: "YAHOO! A new broom! Superb!"
Dialog15F::
	db "YAHOO!  A new   "
	db "broom!  Superb!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $160: "Kiiiki! What?! All right, mutt! Let's battle!!"
Dialog160::
	db "Kiiiki!  What?! "
	db "All right, mutt!"
	db "Let^s battle!!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $161: "Chi-kiita! Chi- kiita! Kiki the monkey! Hungry! Kiki the monkey!"
Dialog161::
	db "Chi-kiita! Chi- "
	db "kiita!  Kiki the"
	db "monkey!  Hungry!"
	db "Kiki the monkey!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $162: "?! ?! Oooh! Ooh! Kiki! Monkees! Come! Repay him! Kiki!"
Dialog162::
	db "    ", $e3, "!    ", $e3, "!    "
	db "Oooh! Ooh! Kiki!"
	db "Monkees!  Come! "
	db "Repay him! Kiki!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $163: "Monkey business! Done! Bye bye! Oooh! Kiki!"
Dialog163::
	db "Monkey business!"
	db "Done!  Bye bye! "
	db "Oooh!  Kiki!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $164: "You found a stick a monkey left behind... You take it!"
Dialog164::
	db "You found a     "
	db "stick a monkey  "
	db "left behind...  "
	db "You take it!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $165: "?! ?! Oooh! Oooh! Give to Kiki!? Yes No!"
Dialog165::
	db "    ", $e3, "!    ", $e3, "!    "
	db "  Oooh!  Oooh!  "
	db " Give to Kiki!? "
	db "    Yes  No!"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $166: "You don't know the proper etiquette when dealing with a lady, do yo..."
Dialog166::
	db "You don^t know  "
	db "the proper      "
	db "etiquette when  "
	db "dealing with a  "
	db "lady, do you?   "
	db "You should have "
	db "brought flowers "
	db "or something,   "
	db "then I might be "
	db "more inclined to"
	db "talk with you..."
	db "Oh yes, in my   "
	db "case, hibiscus  "
	db "are best..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $167: "Oh, you brought me a hibiscus! How sweet! Well, since you are such ..." (B does not hurry it)
Dialog167::
	db "Oh, you brought "
	db "me a hibiscus!  "
	db "How sweet! Well,"
	db "since you are   "
	db "such a gentleman"
	db "I have a request"
	db "to make of you. "
	db "Will you listen?"
	db "    Yes  No"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $168: "I would like you to take this letter to a Mr. Write who lives on th..."
Dialog168::
	db "I would like you"
	db "to take this    "
	db "letter to a Mr. "
	db "Write who lives "
	db "on the border of"
	db "the Mysterious  "
	db "Forest, please!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $169: "...Is that so? And I thought you were a gentleman..."
Dialog169::
	db "...Is that so?  "
	db "And I thought   "
	db "you were a      "
	db "gentleman..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $16A: "You traded ? for a goat's letter ?! ...Great!?"
Dialog16A::
	db "You traded ", $e7, " for"
	db "a goat^s letter "
	db $ed, "!  ...Great!?"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $16B: "You know, some- times I can't help eating a delicious piece of pape..."
Dialog16B::
	db "You know, some- "
	db "times I can^t   "
	db "help eating a   "
	db "delicious piece "
	db "of paper, even  "
	db "if it^s a letter"
	db "to my darling   "
	db "Mr. Write... How"
	db "embarrassing!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $16C: "You've saved BowWow! What a fearsome beast!"
Dialog16C::
	db "You^ve saved    "
	db "BowWow!  What a "
	db "fearsome beast!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $16D: "Wow! The Rooster has recovered! He seems very friendly!"
Dialog16D::
	db "Wow! The Rooster"
	db "has recovered!  "
	db "He seems very   "
	db "friendly!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $170: "Yep, Papahl got lost, just like he said! Now, I am so famished I ca..."
Dialog170::
	db "Yep, Papahl got "
	db "lost, just like "
	db "he said!  Now, I"
	db "am so famished I"
	db "can^t move!  Can"
	db "you give me some"
	db "vittles?        "
	db "    Yes  Nope"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $171: "You're one cold hombre..."
Dialog171::
	db "You^re one cold "
	db "hombre..."
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $172: "This ? is so delicious! I'm going to eat the ? right now! Bon Appet..."
Dialog172::
	db "This ", $e6, " is so    "
	db "delicious!  I^m "
	db "going to eat the"
	db $e6, " right now!    "
	db " Bon Appetit!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialog $173: "AH! This isn't meant to be a reward... Here, take this ?! It's a hi..."
Dialog173::
	db "AH!  This isn^t "
	db "meant to be a   "
	db "reward...  Here,"
	db "take this ", $e7, "!    "
	db "It^s a hibiscus!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $174: "You traded the ? for the ?!"
Dialog174::
	db "You traded the ", $e6
	db "for the ", $e7, "!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $175: "Delicious! Yum! I'm filled with energy, now!"
Dialog175::
	db "Delicious!  Yum!"
	db "I^m filled with "
	db "energy, now!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $176: "I've got to say, thanks again!"
Dialog176::
	db "I^ve got to say,"
	db "thanks again!"
	db $ff  ; end

;@ path: text/dialogs
;@ Dialog $177: "Yep, Papahl got lost, just like he said! Now, I am so famished I ca..."
Dialog177::
	db "Yep, Papahl got "
	db "lost, just like "
	db "he said!  Now, I"
	db "am so famished I"
	db "can^t move!  Can"
	db "you give me some"
	db "vittles?        "
	db "    Nope Can^t"
	db $fe  ; end, then a choice of two answers

;@ path: text/dialogs
;@ Dialog $178: "She's had an awful tradgedy in the house across the way! It's just ..."
Dialog178::
	db "She^s had an    "
	db "awful tradgedy  "
	db "in the house    "
	db "across the way! "
	db "It^s just awful,"
	db "and all I can do"
	db "is sweep!"
	db $ff  ; end
;@ path: text/dialogs
;@ Dialogs $179, $17A, $17B, $17C, $17D, $17E, $17F: ""
Dialog179::
	db $ff  ; end
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
