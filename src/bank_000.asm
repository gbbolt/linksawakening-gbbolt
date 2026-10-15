; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

;@ def RST_00(index: a)
;@ path: system/vectors
;@ `rst $00`: jump-table dispatch. The `rst $00` is followed by a table of 16-bit addresses;
;@ execution continues at entry `index` of that table (the work is done by JumpTable).
;@ The byte at $0003 is a debug switch read by the main loop (0 = debug pause off).
;@ test: skip rewrites the return address on the stack
RST_00::
;> return JumpTable(index)
	jp JumpTable


	db $00, $00, $ff, $ff, $ff

;@ path: unused/vectors
;@ Restart vectors $08-$1F are not used: the area is filled with $FF.
RST_08::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: unused/vectors
;@ Restart vector $20 is not used (filled with $FF).
RST_20::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: unused/vectors
;@ Restart vectors $28-$37 are not used (filled with $FF).
RST_28::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: unused/vectors
;@ Restart vector $38 is not used (filled with $FF; an `rst $38` here would loop until the
;@ stack overflows).
RST_38::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def VBlankInterrupt()
;@ path: system/vectors
;@ Interrupt vector $40 (vertical blank).
;@ test: skip interrupt vector
VBlankInterrupt::
;> return VBlankHandler()
	jp VBlankHandler


	db $ff, $ff, $ff, $ff, $ff

;@ def LCDCInterrupt()
;@ path: system/vectors
;@ Interrupt vector $48 (LCD STAT, used for split-screen scroll effects).
;@ test: skip interrupt vector
LCDCInterrupt::
;> return LCDStatHandler()
	jp LCDStatHandler


	db $ff, $ff, $ff, $ff, $ff

;@ def TimerOverflowInterrupt()
;@ path: system/vectors
;@ Interrupt vector $50: the timer is not used, it just returns.
;@ test: skip interrupt vector
TimerOverflowInterrupt::
;> return
	reti


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def SerialTransferCompleteInterrupt()
;@ path: system/vectors
;@ Interrupt vector $58: the link cable is not used, it just returns.
;@ test: skip interrupt vector
SerialTransferCompleteInterrupt::
;> return
	reti


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def JoypadInterrupt()
;@ path: system/vectors
;@ Interrupt vector $60: the joypad interrupt is not used, it just returns.
;@ test: skip interrupt vector
JoypadInterrupt::
;> return
	reti
	db $ff

;@ def SwapInTiles9A()
;@ path: gfx/tiles
;@ VBlank tile job 3 (hNeedsUpdatingBGTiles = 3): copies 3 tiles from bank $0C $6900 over the
;@ shared tiles $9A-$9C ($89A0). Used by the heart piece pickup (bank 3), which shows its own
;@ graphics there; RestoreTiles9A puts the normal tiles back. Bank $0C is the bank switched in
;@ while the main loop waits for VBlank.
;@ test: skip runs in VBlank with the graphics bank switched in
SwapInTiles9A::
;> src = 0x6900
	ld hl, $6900
;> dest = 0x89A0
	ld de, $89a0
;> copy(dest, src, 0x30)               # in the shared end of RestoreTiles9A, which also
;> return RestoreGfxBank()              # clears the request before switching bank $0C back in
	jr jr_000_0080

;@ def SwapInTiles9D()
;@ path: gfx/tiles
;@ VBlank tile job 4: copies 3 tiles from bank $0C $6930 over the shared tiles $9D-$9F ($89D0).
;@ test: skip runs in VBlank with the graphics bank switched in
SwapInTiles9D::
;> src = 0x6930
	ld hl, $6930
;> dest = 0x89D0
	ld de, $89d0
;> copy(dest, src, 0x30)               # in the shared end of RestoreTiles9A, which also
;> return RestoreGfxBank()              # clears the request before switching bank $0C back in
	jr jr_000_0080

;@ def RestoreTiles9D()
;@ path: gfx/tiles
;@ VBlank tile job 5: puts the normal tiles $9D-$9F back (bank $0C $49D0 -> $89D0).
;@ test: skip runs in VBlank with the graphics bank switched in
RestoreTiles9D::
;> src = 0x49D0
	ld hl, $49d0
;> dest = 0x89D0
	ld de, $89d0
;> copy(dest, src, 0x30)               # in the shared end of RestoreTiles9A, which also
;> return RestoreGfxBank()              # clears the request before switching bank $0C back in
	jr jr_000_0080

;@ def RestoreTiles9A()
;@ path: gfx/tiles
;@ VBlank tile job 6: puts the normal tiles $9A-$9C back (bank $0C $49A0 -> $89A0). The jobs 3-5
;@ jump into the end of this routine, which copies the 3 tiles, clears the request and switches
;@ bank $0C back in.
;@ test: skip runs in VBlank with the graphics bank switched in
RestoreTiles9A::
;> src = 0x49A0
	ld hl, $49a0
;> dest = 0x89A0
	ld de, $89a0

jr_000_0080:
;>@copy copy(dest, src, 0x30)          # 3 tiles
	ld bc, $0030
	call CopyData
;> hNeedsUpdatingBGTiles = 0             # job done
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;> hBGTilesLoadingStage = 0
	ldh [hBGTilesLoadingStage], a
;> return RestoreGfxBank()

;@ def RestoreGfxBank()
;@ path: system/banks
;@ Switches bank $0C (background and sprite tiles) back in: the bank the VBlank tile copies
;@ expect, and the one the main loop leaves switched in while it waits for VBlank.
RestoreGfxBank::
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
	ret


	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def Boot()
;@ path: system/boot
;@ Cartridge entry point at $0100: the boot ROM jumps here.
;@ test: skip entry point
Boot::
;> return Init()
	nop
	jp Init


;@ asset: logo
;@ path: system/header
;@ The Nintendo logo. The boot ROM scrolls it down the screen and only starts the cartridge
;@ if these 48 bytes match its own copy.
HeaderLogo::
	db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
	db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
	db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

;@ asset: header range=$0100-$014F
;@ path: system/header
;@ Cartridge header: game title "ZELDA", padded with zeros to 16 bytes.
HeaderTitle::
	db "ZELDA", $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: system/header
;@ Cartridge header: new licensee code (not used: the old licensee code is $01).
HeaderNewLicenseeCode::
	db $00, $00

;@ path: system/header
;@ Cartridge header: $00 = no Super Game Boy functions.
HeaderSGBFlag::
	db $00

;@ path: system/header
;@ Cartridge header: $03 = MBC1 with RAM and battery (the save files).
HeaderCartridgeType::
	db $03

;@ path: system/header
;@ Cartridge header: $04 = 512 KiB ROM (32 banks of 16 KiB).
HeaderROMSize::
	db $04

;@ path: system/header
;@ Cartridge header: $02 = 8 KiB cartridge RAM.
HeaderRAMSize::
	db $02

;@ path: system/header
;@ Cartridge header: $01 = sold outside Japan.
HeaderDestinationCode::
	db $01

;@ path: system/header
;@ Cartridge header: $01 = Nintendo.
HeaderOldLicenseeCode::
	db $01

;@ path: system/header
;@ Cartridge header: ROM version 2 (the third revision).
HeaderMaskROMVersion::
	db $02

;@ path: system/header
;@ Cartridge header: checksum of the header bytes $0134-$014C (checked by the boot ROM).
HeaderComplementCheck::
	db $6a

;@ path: system/header
;@ Cartridge header: checksum of the whole ROM (big endian; not checked by the hardware).
HeaderGlobalChecksum::
	db $3a, $ee

;@ def Init()
;@ path: system/boot
;@ Start-up: switches the LCD off, clears video memory and RAM, puts the OAM DMA routine in
;@ HRAM, loads the basic tiles, sets up the LCD interrupt, checks the save files and starts the
;@ sound engine. Then it enters the main loop (through FinishFrame, which waits for the first
;@ VBlank).
;@ test: skip start-up code (resets the stack, never returns)
Init::
;> DisableLCD()
	call DisableLCD
;> reset_stack(0xDFFF)
	ld sp, $dfff
;> rBGP = 0                                 # all palettes black while loading
	xor a
	ldh [rBGP], a
;> rOBP0 = 0
	ldh [rOBP0], a
;> rOBP1 = 0
	ldh [rOBP1], a
;> ClearMemory(0x8000, 0x1800)              # all tiles
	ld hl, $8000
	ld bc, $1800
	call ClearMemory
;> FillBGMapsWith7F()                              # fills both background maps with tile $7F
	call FillBGMapsWith7F
;> ClearHRAMAndWRAM()                              # clears HRAM variables and WRAM
	call ClearHRAMAndWRAM
;> set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;> CopyDMARoutineToHRAM()                   # bank 1 $7D19
	call $7d19
;> hDMARoutine()                            # send the (empty) sprite table
	call hDMARoutine
;> InitLCDRegisters()                       # bank 1 $40CE: LCD on, window hidden, full volume
	call $40ce
;> LoadTileset03()                              # loads the basic tiles from bank $0C
	call LoadTileset03
;> rSTAT = 0x44                             # LCD interrupt when rLY == rLYC
	ld a, $44
	ldh [rSTAT], a
;> rLYC = 0x4F
	ld a, $4f
	ldh [rLYC], a
;> wCurrentBank = 1
	ld a, $01
	ld [wCurrentBank], a
;> rIE = 0x01                               # only the VBlank interrupt for now
	ld a, $01
	ldh [rIE], a
;> set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;> CheckSaveFiles()                         # bank 1 $460F: checks the 3 save files in cartridge RAM
	call $460f
;> set_rom_bank(0x1F)
	ld a, $1f
	ld [$2100], a
;> InitSoundEngine()                        # bank $1F $4000
	call $4000
;> hStartButtonDelay = 0x18
	ld a, $18
	ldh [hStartButtonDelay], a
;> enable_interrupts()
	ei
;> return FinishFrame()
	jp FinishFrame


;@ def MainLoop()
;@ path: system/mainloop
;@ One frame of the game. Sets the scroll registers; when a whole screen or tile set has to be
;@ loaded (wTileMapToLoad / wBGMapToLoad) it does that with the LCD off and runs the sound twice
;@ so the music keeps its tempo. Otherwise it applies the window and palettes, runs the raster
;@ effects of the intro and of the full-screen wave effect, waits while VBlank still has tiles to
;@ copy, and runs the current game mode (RunGameMode). Ends in FinishFrame, which waits for the
;@ next VBlank and comes back here.
;@ test: skip the main loop never returns
MainLoop::
;> hFrameInProgress = 1
	ld a, $01
	ldh [hFrameInProgress], a
;>@c if wAlternateBackgroundEnabled and wGameplayType == 0x0B:
	ld a, [wAlternateBackgroundEnabled]
	and a
	jr z, .normalScrollY

;=@c
	ld a, [wGameplayType]
	cp $0b
	jr nz, .normalScrollY

;>     scrollY = (hFrameCounter & 1) << 7   # 0 and $80 on alternate frames
	ldh a, [hFrameCounter]
	rrca
	and $80
;=@c
	jr .setScrollY

;> else:
.normalScrollY
;>     scrollY = u8(hBaseScrollY + wScreenShakeY)
	ld hl, wScreenShakeY
	ldh a, [hBaseScrollY]
	add [hl]

.setScrollY
;> rSCY = scrollY
	ldh [rSCY], a
;> rSCX = u8(hBaseScrollX + wScreenShakeX + wScrollXOffset)
	ldh a, [hBaseScrollX]
	ld hl, wScreenShakeX
	add [hl]
	ld hl, wScrollXOffset
	add [hl]
	ldh [rSCX], a
;>@redraw if wTileMapToLoad or wBGMapToLoad:
	ld a, [wTileMapToLoad]
	and a
	jr nz, .redraw

;=@redraw
	ld a, [wBGMapToLoad]
	cp $00
	jr z, .normalFrame

.redraw
;>     # the redraw takes long: run the sound engine more often so the music keeps its tempo
;>@xs     if wGameplayType == 0x09 or wGameplayType < 0x06 or (wGameplayType == 0x0B and wGameplaySubtype < 0x07):
	ld a, [wGameplayType]
	cp $09
	jr z, .extraSound

	cp $06
	jr c, .extraSound

;=@xs
	cp $0b
	jr nz, .loadScreen

	ld a, [wGameplaySubtype]
	cp $07
	jr nc, .loadScreen

.extraSound
;>         UpdateSound()
	call UpdateSound
;>         UpdateSound()
	call UpdateSound

.loadScreen
;>     disable_interrupts()
	di
;>     LoadRequestedGraphics()
	call LoadRequestedGraphics
;>     enable_interrupts()
	ei
;>     UpdateSound()
	call UpdateSound
;>     UpdateSound()
	call UpdateSound
;>     return FinishFrame()
	jp FinishFrame


.normalFrame
;> lcdc = wLCDControl & 0x7F
	ld a, [wLCDControl]
	and $7f
	ld e, a
;> rLCDC = (rLCDC & 0x80) | lcdc            # the settings of wLCDControl, LCD on/off unchanged
	ldh a, [rLCDC]
	and $80
	or e
	ldh [rLCDC], a
;> hFrameCounter = u8(hFrameCounter + 1)
	ld hl, hFrameCounter
	inc [hl]
;>@intro if wGameplayType == 0x00 and wGameplaySubtype >= 0x08:
	ld a, [wGameplayType]
	cp $00
	jr nz, .transition

;=@intro
	ld a, [wGameplaySubtype]
	cp $08
	jr c, .transition

;>     set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;>     IntroRasterEffect()                  # bank 1 $6DB7
	call $6db7

.transition
;> if wTransitionGfx != 0:
	ld a, [wTransitionGfx]
	and a
	jp z, .regular

;>@fx     if wTransitionGfx >= 0xFE:          # $FF and $FE: an effect of bank $17
	inc a
	jr nz, .notFF

.bank17Effect
;>         set_rom_bank(0x17)
	ld a, $17
	ld [$2100], a
;>         TransitionEffect17()             # bank $17 $46A6
	call $46a6
;=@fx
	jp .regular


.notFF
;=@fx
	inc a
	jr z, .bank17Effect

;>     else:                                # 1-3: the wave effect of bank $14
;>         set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;>         wTransitionGfxFrameCount = u8(wTransitionGfxFrameCount + 1)
	ld a, [wTransitionGfxFrameCount]
	inc a
	ld [wTransitionGfxFrameCount], a
;>@end         if wTransitionGfxFrameCount == 0xC0:   # the effect is over
	cp $c0
	jr nz, .waveRunning

;>             if wTransitionGfx == 2:
	ld a, [wTransitionGfx]
	cp $02
	jr nz, .endWave

;>                 EndWaveWarp()            # bank $14 $541B: starts the warp that follows the effect
	call $541b

.endWave
;>             wTransitionGfx = 0
	xor a
	ld [wTransitionGfx], a
;>             wWavePaletteStep = 0
	ld [wWavePaletteStep], a
;=@end
	jp .regular


.waveRunning
;>         else:
;>             count = wTransitionGfxFrameCount
;>             if count >= 0x60:            # second half: the palettes fade
	cp $60
	jr c, .waveSetup

	push af
;>                 if count & 7 == 0 and wWavePaletteStep != 0x0C:
	and $07
	jr nz, .wavePalette

	ld a, [wWavePaletteStep]
	cp $0c
	jr z, .palettesDone

;>                     wWavePaletteStep += 1
	inc a
	ld [wWavePaletteStep], a

.wavePalette
;>                 i = wWavePaletteStep + (hFrameCounter & 3)    # flickers between neighbouring steps
	ld a, [wWavePaletteStep]
	ld e, a
	ldh a, [hFrameCounter]
	and $03
	add e
	ld e, a
;>@pal                 if wTransitionGfx != 3:
	ld d, $00
	ld a, [wTransitionGfx]
	cp $03
	jr z, .palettesType3

;>                     wBGPalette = mem[0x546A + i]   # palette tables in bank $14
	ld hl, $546a
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;>                     wOBJ1Palette = mem[0x546A + i]
	ld [wOBJ1Palette], a
;>                     wOBJ0Palette = mem[0x547A + i]
	ld hl, $547a
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;=@pal
	jr .palettesDone

;>                 else:
.palettesType3
;>                     wBGPalette = mem[0x548A + i]
	ld hl, $548a
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;>                     wOBJ1Palette = mem[0x548A + i]
	ld [wOBJ1Palette], a
;>                     wOBJ0Palette = mem[0x549A + i]
	ld hl, $549a
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a

.palettesDone
	pop af

.waveSetup
;>             hMultiPurpose0 = count >> 2                     # phase of the wave
	srl a
	srl a
	ldh [hMultiPurpose0], a
;>             row = wTransitionGfxFrameCount & 0xE0           # strength: the table row grows with time
	ld a, [wTransitionGfxFrameCount]
	nop
	and $e0
	ld e, a
;>             if wTransitionGfx == 3:
	ld a, [wTransitionGfx]
	cp $03
	jr nz, .rowChosen

;>                 row ^= 0xE0                                # type 3 runs the strengths backwards
	ld a, e
	xor $e0
	ld e, a

.rowChosen
;>             hMultiPurpose1 = row
	ld a, e
	ldh [hMultiPurpose1], a
;>             wRasterLine = 0
	ld hl, wRasterLine
	xor a
	ld [hli], a
	ld [hli], a
;>             wRasterDelay = 0
	ld [hli], a

.nextLine
;>@line             for _ in forever():                        # every line of the frame:
;>                 wait_hblank()
	ldh a, [rSTAT]
	and $03
	jr nz, .nextLine

	ld d, $00

.delay
;>                 while True:                            # a short delay: count on to the next even value
;>                     wRasterDelay = u8(wRasterDelay + 1)
	ld a, [wRasterDelay]
	inc a
	ld [wRasterDelay], a
;>                     if wRasterDelay & 1 == 0: break
	and $01
	jr nz, .delay

;>                 wRasterLine = u16(wRasterLine + 1)
	ld a, [wRasterLine]
	add $01
	ld [wRasterLine], a
	ld a, [wRasterLine + 1]
	adc $00
	ld [wRasterLine + 1], a
;>                 if lo(wRasterLine) == 0x58: break
	ld a, [wRasterLine]
	cp $58
	jp z, .waveDone

;>                 flip = 0 if wTransitionGfx == 1 else 1   # types 2 and 3 swing both ways
	ld c, $00
	ld a, [wTransitionGfx]
	cp $01
	jr z, .flipChosen

	inc c

.flipChosen
;>@off                 offset = mem[0x54AA + (((hMultiPurpose0 + lo(wRasterLine)) & 0x1F) | hMultiPurpose1)]
	ld hl, wRasterLine
	ldh a, [hMultiPurpose0]
	add [hl]
	and $1f
	ld hl, hMultiPurpose1
	or [hl]
;=@off
	ld e, a
	ld hl, $54aa
	add hl, de
;>@neg                 if wTransitionGfxFrameCount & flip:  # every other frame the other way
	ld a, [wTransitionGfxFrameCount]
	and c
;=@off
	ld a, [hl]
;=@neg
	jr z, .notNegated

;>                     offset = u8(-offset)
	cpl
	inc a

.notNegated
;>                 rSCX = u8(offset + hBaseScrollX)
	push af
	ld hl, hBaseScrollX
	add [hl]
	ldh [rSCX], a
	pop af
;>                 rSCY = u8(offset + hBaseScrollY)
	ld hl, hBaseScrollY
	add [hl]
	ldh [rSCY], a
;=@line
	jp .nextLine


.waveDone
;>             UpdateSound()
	call UpdateSound
;>             rBGP = wBGPalette
	ld a, [wBGPalette]
	ldh [rBGP], a
;>             rOBP0 = wOBJ0Palette
	ld a, [wOBJ0Palette]
	ldh [rOBP0], a
;>             rOBP1 = wOBJ1Palette
	ld a, [wOBJ1Palette]
	ldh [rOBP1], a
;>             return FinishFrame()         # the frame went into the effect: no game logic
	jr FinishFrame

.regular
;> rWY = wWindowY
	ld a, [wWindowY]
	ldh [rWY], a
;> rBGP = wBGPalette
	ld a, [wBGPalette]
	ldh [rBGP], a
;> rOBP0 = wOBJ0Palette
	ld a, [wOBJ0Palette]
	ldh [rOBP0], a
;> rOBP1 = wOBJ1Palette
	ld a, [wOBJ1Palette]
	ldh [rOBP1], a
;> UpdateSound()
	call UpdateSound
;> ReadJoypad()
	call ReadJoypad
;> if hNeedsUpdatingBGTiles or hNeedsUpdatingEnemiesTiles or wNeedsUpdatingNPCTiles:
	ldh a, [hNeedsUpdatingBGTiles]
	ld hl, hNeedsUpdatingEnemiesTiles
	or [hl]
	ld hl, wNeedsUpdatingNPCTiles
	or [hl]
;>     return FinishFrame()                 # wait until VBlank has copied the tiles
	jr nz, FinishFrame

;> if mem[0x0003]:                          # debug switch (0 in this ROM)
	ld a, [$0003]
	and a
	jr z, .run

;>@sel     if (wDebugPaused or hJoypadHeld & 0x0F) and hJoypadPressed & 0x40:   # select (with the d-pad to pause)
	ld a, [wDebugPaused]
	and a
	jr nz, .select

	ldh a, [hJoypadHeld]
	and $0f
	jr z, .stillPaused

.select
;=@sel
	ldh a, [hJoypadPressed]
	and $40
	jr z, .stillPaused

;>         wDebugPaused ^= 1
	ld a, [wDebugPaused]
	xor $01
	ld [wDebugPaused], a
;>         if wDebugPaused: return FinishFrame()
	jr nz, FinishFrame

;>         wDebugToggle ^= 0x10
	ld a, [wDebugToggle]
	xor $10
	ld [wDebugToggle], a
;>         return FinishFrame()
	jr FinishFrame

.stillPaused
;>     if wDebugPaused: return FinishFrame()
	ld a, [wDebugPaused]
	and a
	jr nz, FinishFrame

.run
;> SwitchBank(1)
	ld a, $01
	call SwitchBank
;> ClearOAMBuffer()                         # bank 1 $5CF0: hides all sprites
	call $5cf0
;> RunGameMode()
	call RunGameMode
;> set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;> HideSpritesUnderWindow()                 # bank 1 $5D03
	call $5d03
;> return FinishFrame()

;@ def FinishFrame()
;@ path: system/mainloop
;@ End of a frame: runs the sound volume fades (bank $1F), switches the graphics bank $0C in for
;@ the VBlank tile copies, waits for the VBlank interrupt and starts the next frame.
;@ test: skip waits for an interrupt and never returns
FinishFrame::
;> set_rom_bank(0x1F)
	ld a, $1f
	ld [$2100], a
;> UpdateVolumeFades()                      # bank $1F $7F80: hVolumeFadeOutTimer / hVolumeFadeInTimer
	call $7f80
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> hFrameInProgress = 0                     # VBlank may do its work now
	xor a
	ldh [hFrameInProgress], a
	halt

.wait
;> while not hVBlankDone:
;>     wait_vblank_flag()
	ldh a, [hVBlankDone]
	and a
	jr z, .wait

;> hVBlankDone = 0
	xor a
	ldh [hVBlankDone], a
;> return MainLoop()
	jp MainLoop


;@ path: system/lcd
;@ Intro screen, steps before 6: rLYC line where each of the 5 horizontal bands ends (the LCD
;@ interrupt then sets the x scroll of the next band). One byte per band, indexed by
;@ wIntroLCDSection.
IntroBandLinesA::
	db $20, $30, $40, $60, $00

;@ path: system/lcd
;@ Intro screen, steps 6 and later: rLYC line of each of the 4 bands (one byte per band).
IntroBandLinesB::
	db $30, $56, $68, $00

;@ def LCDStatHandler()
;@ path: system/lcd
;@ LCD interrupt (rLY reached rLYC): split-screen scrolling. In the ending (mode 1) it changes the
;@ y scroll from that line down; on the intro screen (mode 0) it gives each horizontal band its
;@ own x scroll (parallax) and sets the line of the next interrupt. In other modes it resets the
;@ x scroll to 0 (so the window/status area does not scroll).
;@ test: skip interrupt handler (ends in reti)
LCDStatHandler::
;> disable_interrupts()                    # af, hl, de are saved and restored
	di
	push af
	push hl
	push de
;>@e if wGameplayType == 0x01:               # the ending
	ld a, [wGameplayType]
	cp $01
	jr nz, .notEnding

;>@sy     if wGameplaySubtype == 0x05:
	ld a, [wGameplaySubtype]
	cp $05
	jr nz, .baseScroll

;>         rSCY = wEntityWorkRAM            # $D000: the ending keeps the lower scroll there
	ld a, [wEntityWorkRAM]
;=@sy
	jr .setScrollY

;>     else:
.baseScroll
;>         rSCY = hBaseScrollY
	ldh a, [hBaseScrollY]

.setScrollY
	ldh [rSCY], a
;=@e
	jp .done


.notEnding
;>@e2 elif wGameplayType == 0x00:             # the intro screen
	cp $00
	jr nz, .otherMode

;>     band = wIntroLCDSection
	ld a, [wIntroLCDSection]
	ld e, a
	ld d, $00
;>     rSCX = u8(wIntroBandScrollX[band] + hBaseScrollX)
	ld hl, wIntroBandScrollX
	add hl, de
	ld a, [hl]
	ld hl, hBaseScrollX
	add [hl]
	ldh [rSCX], a
;>@b     if wGameplaySubtype >= 0x06:
	ld a, [wGameplaySubtype]
	cp $06
	jr c, .fiveBands

;>         rLYC = IntroBandLinesB[band]
	ld hl, IntroBandLinesB
	add hl, de
	ld a, [hl]
	ldh [rLYC], a
;>         wIntroLCDSection = (band + 1) & 3
	ld a, e
	inc a
	and $03
	ld [wIntroLCDSection], a
;=@b
	jr .done

;>     else:
.fiveBands
;>         rLYC = IntroBandLinesA[band]
	ld hl, IntroBandLinesA
	add hl, de
	ld a, [hl]
	ldh [rLYC], a
;>         band += 1
	ld a, e
	inc a
;>         if band == 5: band = 0
	cp $05
	jr nz, .storeBand

	xor a

.storeBand
;>         wIntroLCDSection = band
	ld [wIntroLCDSection], a
	nop
;>         if band == 4:                    # the last band: also its own y scroll
	cp $04
	jr nz, .bandDone

;>             rSCY = wIntroBandScrollY
	ld a, [wIntroBandScrollY]
	ldh [rSCY], a
;>             rLYC = u8(0x60 - wIntroBandScrollY)
	cpl
	inc a
	add $60
	ldh [rLYC], a

.bandDone
;=@e2
	jr .done

;> else:
.otherMode
;>     rSCX = 0
	xor a
	ldh [rSCX], a

.done
;> enable_interrupts()
	pop de
	pop hl
	pop af
	ei
;> return
	reti


;@ path: world/drawing
;@ Screen layouts drawn when wBGMapToLoad is set (DrawRequestedBGMap): 37 pointers into bank 8
;@ (entry 0 is unused; entry 7 points into WRAM, $D651, a list built at run time). Each points to
;@ a list of background draw commands: VRAM address (high byte first), a byte with the count - 1
;@ in bits 0-5 and the drawing mode in bits 6-7, then the tiles; a 0 byte ends the list.
BGMapPointers::
	dw $0000, $62a5, $7313, $6f0f, $6f01, $701e, $7154, $d651
	dw $6ec2, $7393, $7559, $74c0, $722b, $7637, $76b7, $7800
	dw $7a0b, $7b8a, $54af, $5670, $6e81, $5310, $6365, $66ce
	dw $67a1, $68e5, $6a34, $6b20, $6bdd, $6bdd, $5a73, $5c29
	dw $5dc8, $5f67, $6106, $580e, $59ad

;@ def LoadRequestedGraphics()
;@ path: world/drawing
;@ Does the big graphics job the main loop found requested, with the LCD off: wTileMapToLoad
;@ (a loader from TileMapLoaders) or else wBGMapToLoad (DrawRequestedBGMap). Both end in
;@ ClearGraphicsRequests, which switches the LCD back on.
;@ test: skip switches the LCD off and calls loaders in other banks
LoadRequestedGraphics::
;> if not wTileMapToLoad:
	ld a, [wTileMapToLoad]
	and a
;>     return DrawRequestedBGMap()
	jr z, DrawRequestedBGMap

;> DisableLCD()
	push af
	call DisableLCD
	pop af
;> RunTileMapLoader(wTileMapToLoad)
	call RunTileMapLoader
;> return ClearGraphicsRequests()
	jr ClearGraphicsRequests

;@ def RunTileMapLoader(index: a)
;@ path: world/drawing
;@ Runs loader `index` (1-based) of TileMapLoaders.
;@ test: skip calls loaders in other banks
RunTileMapLoader::
;> TileMapLoaders[index - 1]()
	dec a
	rst $00

;@ path: world/drawing
;@ The loaders behind wTileMapToLoad (index - 1): routines that load a whole tile set and/or
;@ screen while the LCD is off (the areas of the game, menus, the map, the ending, ...). Entries
;@ $0A and $0C do nothing.
TileMapLoaders::
	dw LoadTileset01
	dw FillBGMapsWith7F
	dw LoadTileset03
	dw LoadTileset04
	dw LoadTileset05
	dw LoadTileset06
	dw LoadTileset05
	dw FillBGMap0With7E
	dw LoadTileset09
	dw DoNothing
	dw LoadTileset0B
	dw DoNothing
	dw LoadTileset0D
	dw LoadTileset0E
	dw FillBGMapCheckerboard
	dw LoadTileset10
	dw LoadTileset11
	dw LoadTileset12
	dw LoadTileset13
	dw LoadTileset14
	dw LoadTileset15
	dw LoadTileset16
	dw LoadTileset17
	dw LoadTileset18
	dw LoadTileset19
	dw LoadTileset1A
	dw LoadTileset1B
	dw LoadTileset1A
	dw LoadTileset1D
	dw LoadTileset1E
	dw LoadTileset1F
	dw LoadTileset20
	dw LoadTileset21

;@ def DrawRequestedBGMap()
;@ path: world/drawing
;@ Draws screen layout wBGMapToLoad (BGMapPointers, bank 8) with the LCD off, then clears the
;@ requests (falls into ClearGraphicsRequests).
;@ test: skip switches the LCD off
DrawRequestedBGMap::
;> DisableLCD()
	call DisableLCD
;>@cm commands = mem16[BGMapPointers + 2 * wBGMapToLoad]
	ld hl, BGMapPointers
	ld b, $00
	ld a, [wBGMapToLoad]
	sla a
	ld c, a
	add hl, bc
;=@cm
	ld a, [hl]
	ld e, a
	inc hl
	ld a, [hl]
	ld d, a
;> set_rom_bank(0x08)
	ld a, $08
	ld [$2100], a
;> DrawCommandsLoop(commands)                      # draws the list
	call DrawCommandsLoop
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> return ClearGraphicsRequests()

;@ def ClearGraphicsRequests()
;@ path: world/drawing
;@ Clears wBGMapToLoad and wTileMapToLoad and switches the LCD back on with wLCDControl.
ClearGraphicsRequests::
;> wBGMapToLoad = 0
	xor a
	ld [wBGMapToLoad], a
;> wTileMapToLoad = 0
	ld [wTileMapToLoad], a
;> rLCDC = wLCDControl
	ld a, [wLCDControl]
	ldh [rLCDC], a
;> return

;@ def DoNothing()
;@ path: system/misc
;@ Just returns (the end of ClearGraphicsRequests, also used as an empty table entry).
DoNothing::
;> return
	ret


;@ path: object/raised_blocks
;@ The two raised-block steps the VBlank handler sets while hTileSwapFinishCount counts down
;@ after a room transition (index hTileSwapFinishCount - 1: $09 first, then $07); each is then
;@ advanced by one in UpdateRaisedBlocks.
VBlankAnimFrames::
	db $07, $09

;@ def VBlankHandler()
;@ path: system/vblank
;@ VBlank interrupt. Does nothing while the main loop is still busy with the frame (lag). The
;@ dialogue box gets the VBlank time first while it opens or scrolls. Otherwise one graphics job
;@ per frame: requested tile copies (CopyRequestedTiles), the last raised-block tile steps after a
;@ room transition, or the regular work - animated tiles and the queued background draw
;@ commands. Ends with the sprite DMA and sets hVBlankDone for the main loop.
;@ test: skip interrupt handler (ends in reti)
VBlankHandler::
;> disable_interrupts()                    # all registers are saved and restored
	push af
	push bc
	push de
	push hl
	di
;> if not hFrameInProgress:
	ldh a, [hFrameInProgress]
	and a
	jp nz, .done

;>     state = wDialogState & 0x7F
	ld a, [wDialogState]
	and $7f
;>@d1     if 2 <= state < 5:                   # the box opens: save what it covers
	jr z, .graphics

	cp $01
	jr z, .graphics

	cp $05
	jr nc, .not1to4

;>         SaveDialogBackground()
	call SaveDialogBackground
;>         wDialogState += 1
	ld hl, wDialogState
	inc [hl]
;=@d1
	jr .done

.not1to4
;>@d2     elif state == 0x0A:
	cp $0a
	jr nz, .notA

;>         ScrollDialogText1()
	call ScrollDialogText1
;=@d2
	jr .done

.notA
;>@s2     elif state == 0x0B and wDialogScrollDelay == 0:
	cp $0b
	jr nz, .graphics

	ld a, [wDialogScrollDelay]
	and a
	jr z, .scroll2

;>@s2b         ScrollDialogText2()
;>     else:
;>         if state == 0x0B:                # (the scroll delay is still running)
;>             wDialogScrollDelay -= 1
	dec a
	ld [wDialogScrollDelay], a
	jr .graphics

.scroll2
;=@s2b
	call ScrollDialogText2
;=@s2
	jr .done

.graphics
;>         if not wTileMapToLoad:           # (the main loop does that job with the LCD off)
	ld a, [wTileMapToLoad]
	and a
	jr nz, .done

;>             hBGTilesRequestCopy = hNeedsUpdatingBGTiles
	ldh a, [hNeedsUpdatingBGTiles]
	ldh [hBGTilesRequestCopy], a
;>@g             if hNeedsUpdatingBGTiles or hNeedsUpdatingEnemiesTiles or wNeedsUpdatingNPCTiles:
	ld hl, hNeedsUpdatingEnemiesTiles
	or [hl]
	ld hl, wNeedsUpdatingNPCTiles
	or [hl]
	jr z, .noTileCopy

;>                 CopyRequestedTiles()
	call CopyRequestedTiles
;>                 if hBGTilesRequestCopy < 0x08:
	ldh a, [hBGTilesRequestCopy]
	cp $08
	jr nc, .dma

.linkTiles
;>@lt                     DrawLinkOAM()
	call DrawLinkOAM

.dma
;>                 hDMARoutine()
	call hDMARoutine
;=@g
	jr .done

.noTileCopy
;>@f             elif hTileSwapFinishCount:
	ldh a, [hTileSwapFinishCount]
	and a
	jr z, .regularWork

;>                 hTileSwapFinishCount -= 1
	dec a
	ldh [hTileSwapFinishCount], a
;>                 wRaisedBlockStep = VBlankAnimFrames[hTileSwapFinishCount]
	ld e, a
	ld d, $00
	ld hl, VBlankAnimFrames
	add hl, de
	ld a, [hl]
	ld [wRaisedBlockStep], a
;>                 UpdateRaisedBlocks(wRaisedBlockStep)
	call UpdateRaisedBlocks
;>                 DrawLinkOAM()
;>                 hDMARoutine()
;=@lt
	jr .linkTiles

;>             else:
.regularWork
;>                 UpdateAnimatedTiles()
	call UpdateAnimatedTiles
;>                 DrawCommands(wDrawCommand)      # draws the queued background commands
	ld de, wDrawCommand
	call DrawCommands
;>                 wDrawCommandsSize = 0
	xor a
	ld [wDrawCommandsSize], a
;>                 wDrawCommand[0] = 0
	ld [wDrawCommand], a
;>                 hDMARoutine()
	call hDMARoutine

.done
;> enable_interrupts()
	ei
	pop hl
	pop de
	pop bc
;> hVBlankDone = 1
	ld a, $01
	ldh [hVBlankDone], a
;> return
	pop af
	reti


;@ def CopyRequestedTiles()
;@ path: gfx/tiles
;@ VBlank tile copier: does one 64-byte piece (4 tiles) of the requested tile job per VBlank, so
;@ a whole tile set arrives over several frames without the screen being switched off.
;@ hNeedsUpdatingBGTiles picks the background job: 1 = the background tiles of the area (indoor:
;@ 16 tiles from bank $0D in 4 pieces; overworld: 32 tiles from bank $0F in 8 pieces), 2 = an
;@ indoor job with extra steps (CopyIndoorTilesJob2), 3-6 = single tile swaps, 7 = a job of
;@ bank 1, 8 and more = the sprite tile series of RunSpriteTileSwap. Without a background job it
;@ copies the entity tile set requested by hNeedsUpdatingEnemiesTiles (or else
;@ wNeedsUpdatingNPCTiles) into one of the four entity tile slots at $8400-$87FF.
;@ test: skip switches ROM banks and runs in VBlank
CopyRequestedTiles::
;> job = hNeedsUpdatingBGTiles
	ldh a, [hNeedsUpdatingBGTiles]
;> if job != 0:
	and a
	jp z, .entityTiles

;>@j7     if job == 7:
	cp $07
	jp z, .job7

;>@k         TileJob7()                       # bank 1 $7BC5 (a staged job of its own)
;>@k2         return RestoreGfxBank()
;>     elif job == 3:
	cp $03
;>         return SwapInTiles9A()
	jp z, SwapInTiles9A

;>     elif job == 4:
	cp $04
;>         return SwapInTiles9D()
	jp z, SwapInTiles9D

;>     elif job == 5:
	cp $05
;>         return RestoreTiles9D()
	jp z, RestoreTiles9D

;>     elif job == 6:
	cp $06
;>         return RestoreTiles9A()
	jp z, RestoreTiles9A

;>     elif job >= 8:
	cp $08
;>         return RunSpriteTileSwap()
	jp nc, RunSpriteTileSwap

;>     elif wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

;>         if job == 2:
	ldh a, [hNeedsUpdatingBGTiles]
	cp $02
;>             return CopyIndoorTilesJob2()
	jp z, CopyIndoorTilesJob2

;>         set_rom_bank(0x0D)
	ld a, $0d
	ld [$2100], a
;>@o1         offset = hBGTilesLoadingStage * 0x40
	ldh a, [hBGTilesLoadingStage]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@o1
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
;=@o1
	rl b
	sla c
	rl b
;>         dest = 0x9000 + offset           # background tiles $00-$0F of the $9000 area
	ld hl, $9000
	add hl, bc
	push hl
	pop de
;>         src = 0x5000 + (hWorldTileset << 8) + offset   # bank $0D: 256 bytes per tile set
	ld hl, $5000
	ldh a, [hWorldTileset]
	add $50
	ld h, a
	add hl, bc
;>         # right after a room transition the raised-block tiles (pieces 1 and 2) are left alone
;>@ra         if not hTileSwapFinishCount or not (1 <= hBGTilesLoadingStage <= 2):
	ldh a, [hTileSwapFinishCount]
	and a
	jr z, .copyIndoor

;=@ra
	ldh a, [hBGTilesLoadingStage]
	dec a
	cp $02
	jr c, .indoorCopied

.copyIndoor
;>             copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData

.indoorCopied
;>         hBGTilesLoadingStage += 1
	ldh a, [hBGTilesLoadingStage]
	inc a
	ldh [hBGTilesLoadingStage], a
;>         if hBGTilesLoadingStage == 4:    # all 16 tiles done
	cp $04
	jr nz, .indoorRet

;>             hNeedsUpdatingBGTiles = 0
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;>             hBGTilesLoadingStage = 0
	ldh [hBGTilesLoadingStage], a

.indoorRet
;>         return
	ret


.overworld
;>     else:
;>         set_rom_bank(0x0F)
	ld hl, $2100
	ld [hl], $0f
;>@o2         offset = hBGTilesLoadingStage * 0x40
	ldh a, [hBGTilesLoadingStage]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@o2
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
;=@o2
	rl b
	sla c
	rl b
;>         dest = 0x9000 + offset           # background tiles $00-$1F of the $9000 area
	ld hl, $9000
	add hl, bc
	push hl
	pop de
;>         src = 0x4000 + (hWorldTileset << 8) + offset   # bank $0F
	ldh a, [hWorldTileset]
	add $40
	ld h, a
	ld l, $00
	add hl, bc
;>         copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;>         hBGTilesLoadingStage += 1
	ldh a, [hBGTilesLoadingStage]
	inc a
	ldh [hBGTilesLoadingStage], a
;>         if hBGTilesLoadingStage == 8:    # all 32 tiles done
	cp $08
	jr nz, .overworldRet

;>             hNeedsUpdatingBGTiles = 0
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;>             hBGTilesLoadingStage = 0
	ldh [hBGTilesLoadingStage], a

.overworldRet
;>         return
	ret


.entityTiles
;> else:
;>     if hNeedsUpdatingEnemiesTiles:
	ldh a, [hNeedsUpdatingEnemiesTiles]
	and a
	jr z, .npcTiles

;>         slot = wEntityTilesSlotA
;>         tileset = wLoadedEntityTilesets[slot]
	ld a, [wEntityTilesSlotA]
	ld e, a
	ld d, $00
	ld hl, wLoadedEntityTilesets
	add hl, de
	ld a, [hl]
;>         page = tileset & 0x3F            # 256-byte page in the bank
	push af
	and $3f
	ld d, a
	ld e, $00
	pop af
;>@b1         set_rom_bank(mem[0x2D84 + (tileset >> 6)])   # bits 6-7 pick one of 4 banks
	swap a
	rra
	rra
	and $03
	ld c, a
	ld b, $00
;=@b1
	ld hl, $2d84
	add hl, bc
	ld a, [hl]
	ld [$2100], a
;>@o3         offset = hEnemiesTilesLoadingStage * 0x40
	ldh a, [hEnemiesTilesLoadingStage]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@o3
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
;=@o3
	rl b
	sla c
	rl b
;>         src = 0x4000 + offset + (page << 8)
	ld hl, $4000
	add hl, bc
	add hl, de
	push hl
;>@d1         dest = 0x8400 + offset + (slot << 8)   # entity tile slot `slot`
	ld a, [wEntityTilesSlotA]
	ld d, a
	ld hl, $8400
	add hl, bc
	add hl, de
;=@d1
	push hl
	pop de
	pop hl
;>         copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;>         hEnemiesTilesLoadingStage += 1
	ldh a, [hEnemiesTilesLoadingStage]
	inc a
	ldh [hEnemiesTilesLoadingStage], a
;>         if hEnemiesTilesLoadingStage == 4:   # 256 bytes = 16 tiles done
	cp $04
	jr nz, .enemiesRet

;>             hNeedsUpdatingEnemiesTiles = 0
	xor a
	ldh [hNeedsUpdatingEnemiesTiles], a
;>             hEnemiesTilesLoadingStage = 0
	ldh [hEnemiesTilesLoadingStage], a

.enemiesRet
;>         return
	ret


.npcTiles
;>     else:                                # the same for the second request
;>         slot = wEntityTilesSlotB
;>         tileset = wLoadedEntityTilesets[slot]
	ld a, [wEntityTilesSlotB]
	ld e, a
	ld d, $00
	ld hl, wLoadedEntityTilesets
	add hl, de
	ld a, [hl]
;>         page = tileset & 0x3F
	push af
	and $3f
	ld d, a
	ld e, $00
	pop af
;>@b2         set_rom_bank(mem[0x2D84 + (tileset >> 6)])
	swap a
	rra
	rra
	and $03
	ld c, a
	ld b, $00
;=@b2
	ld hl, $2d84
	add hl, bc
	ld a, [hl]
	ld [$2100], a
;>@o4         offset = wNPCTilesLoadingStage * 0x40
	ld a, [wNPCTilesLoadingStage]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@o4
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
;=@o4
	rl b
	sla c
	rl b
;>         src = 0x4000 + offset + (page << 8)
	ld hl, $4000
	add hl, bc
	add hl, de
	push hl
;>@d2         dest = 0x8400 + offset + (slot << 8)
	ld a, [wEntityTilesSlotB]
	ld d, a
	ld hl, $8400
	add hl, bc
	add hl, de
;=@d2
	push hl
	pop de
	pop hl
;>         copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;>         wNPCTilesLoadingStage += 1
	ld a, [wNPCTilesLoadingStage]
	inc a
	ld [wNPCTilesLoadingStage], a
;>         if wNPCTilesLoadingStage == 4:
	cp $04
	jr nz, .npcRet

;>             wNeedsUpdatingNPCTiles = 0
	xor a
	ld [wNeedsUpdatingNPCTiles], a
;>             wNPCTilesLoadingStage = 0
	ld [wNPCTilesLoadingStage], a

.npcRet
;>         return
	ret


.job7
;=@k
	ld a, $01
	ld [$2100], a
	call $7bc5
;=@k2
	jp RestoreGfxBank


;@ path: gfx/tiles
;@ Source addresses (bank $0C) of the sprite tile series, one 16-bit word per job $08-$0D
;@ (index job - 8). Jobs 8-10 put three 64-byte pieces of special sprite tiles from $6960/$69A0/
;@ $69C0 in place; jobs 11-13 copy the normal tiles back from $4200/$4240/$4260.
SpriteTileSwapSources::
	dw $6960, $69a0, $69c0, $4200, $4240, $4260

;@ path: gfx/tiles
;@ Destination addresses in VRAM of the sprite tile series, one 16-bit word per job $08-$0D:
;@ $8200, $8240, $8260 (sprite tiles $20-$29; the last two pieces overlap by 2 tiles).
SpriteTileSwapDests::
	dw $8200, $8240, $8260, $8200, $8240, $8260

;@ def RunSpriteTileSwap()
;@ path: gfx/tiles
;@ VBlank tile jobs $08-$0D: copies one 64-byte piece of sprite tiles from bank $0C
;@ (SpriteTileSwapSources -> SpriteTileSwapDests) and goes on to the next job; the series
;@ $08-$0A ends after $0A, the series $0B-$0D after $0D.
;@ test: skip switches ROM banks and runs in VBlank
RunSpriteTileSwap::
;> i = 2 * (hNeedsUpdatingBGTiles - 8)
	sub $08
	sla a
	ld e, a
	ld d, $00
;>@src src = mem16[SpriteTileSwapSources + i]
	ld hl, SpriteTileSwapSources
	add hl, de
	push hl
;> dest = mem16[SpriteTileSwapDests + i]
	ld hl, SpriteTileSwapDests
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
;=@src
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;> if hNeedsUpdatingBGTiles in (0x0A, 0x0D):   # last piece of the series
	ldh a, [hNeedsUpdatingBGTiles]
	cp $0a
	jr z, .done

	cp $0d
	jr z, .done

;>@z     hNeedsUpdatingBGTiles = 0
;> else:
;>     hNeedsUpdatingBGTiles += 1
	ldh a, [hNeedsUpdatingBGTiles]
	inc a
	ldh [hNeedsUpdatingBGTiles], a
	ret


.done
;=@z
	xor a
	ldh [hNeedsUpdatingBGTiles], a
	ret


;@ def SwitchBank(bank: a)
;@ path: system/banks
;@ Switches ROM bank `bank` in at $4000-$7FFF and remembers it in wCurrentBank, so code that is
;@ interrupted (or that calls into bank 0 and back) can switch it in again.
SwitchBank::
;> set_rom_bank(bank)
	ld [$2100], a
;> wCurrentBank = bank
	ld [wCurrentBank], a
	ret


;@ def RestoreBank()
;@ path: system/banks
;@ Switches the bank remembered in wCurrentBank back in (after a routine used another bank).
;@ All registers are kept.
RestoreBank::
;> set_rom_bank(wCurrentBank)
	push af
	ld a, [wCurrentBank]
	ld [$2100], a
	pop af
	ret


;@ def CopyIndoorTilesJob2()
;@ path: gfx/tiles
;@ Background tile job 2 indoors, one step per VBlank: steps 0-7 copy 512 bytes of tiles from
;@ bank $12 $7E00 to tiles $D0-$EF ($8D00); steps 8-11 run four routines of bank 2 (step 8 at
;@ $6BB8 copies a row from the buffer at $D480 into the window map at $9DAA, the others draw
;@ further parts), then the job ends.
;@ test: skip switches ROM banks and runs in VBlank
CopyIndoorTilesJob2::
;> set_rom_bank(0x12)
	ld a, $12
	ld [$2100], a
;> stage = hBGTilesLoadingStage
	ldh a, [hBGTilesLoadingStage]
;> if stage == 8:
	cp $08
	jr c, .copyTiles

	jr nz, .not8

;>     set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>     DrawMinimapBottomLeft()
	call $6bb8
;>     hBGTilesLoadingStage += 1
	ld hl, hBGTilesLoadingStage
	inc [hl]
	ret


.not8
;> elif stage == 9:
	cp $09
	jr nz, .not9

;>     set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>     DrawMinimapTopLeft()
	call $6b92
;>     hBGTilesLoadingStage += 1
	ld hl, hBGTilesLoadingStage
	inc [hl]
	ret


.not9
;> elif stage == 0x0A:
	cp $0a
	jr nz, .last

;>     set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>     DrawMinimapBottomRight()
	call $6b6c
;>     hBGTilesLoadingStage += 1
	ld hl, hBGTilesLoadingStage
	inc [hl]
	ret


.last
;> elif stage > 0x0A:
;>     set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>     DrawMinimapTopRight()
	call $6b46
;>     hNeedsUpdatingBGTiles = 0            # job done
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;>     hBGTilesLoadingStage = 0
	ldh [hBGTilesLoadingStage], a
	ret


.copyTiles
;> else:                                    # steps 0-7
;>@o     offset = stage * 0x40
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
;=@o
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
;=@o
	sla c
	rl b
;>@c     copy(0x8D00 + offset, 0x7E00 + offset, 0x40)
	ld hl, $8d00
	add hl, bc
	push hl
	pop de
	ld hl, $7e00
	add hl, bc
;=@c
	ld bc, $0040
	call CopyData
;>     hBGTilesLoadingStage += 1
	ldh a, [hBGTilesLoadingStage]
	inc a
	ldh [hBGTilesLoadingStage], a
	ret


;@ def UpdateSound()
;@ path: sound/engine
;@ Runs the sound engine for one frame: the sound effects (bank $1F), then the music (UpdateMusic)
;@ at the speed set by wMusicSpeed - once, twice (1) or only on even frames (2). While a wave
;@ channel effect is requested in hWaveSfx the music is not updated this frame.
;@ test: skip calls the sound engines in other banks
UpdateSound::
;> set_rom_bank(0x1F)
	ld a, $1f
	ld [$2100], a
;> UpdateSoundEffects()                     # bank $1F $4006
	call $4006
;> if hWaveSfx:
	ldh a, [hWaveSfx]
	and a
;>     return
	jr nz, jr_000_0876

;> if wMusicSpeed == 0:
	ld a, [wMusicSpeed]
	and a
;>     return UpdateMusic()
	jr z, UpdateMusic

;> elif wMusicSpeed == 2:                   # half speed
	cp $02
	jr nz, .twice

;>     if hFrameCounter & 1: return
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_000_0876

;>     return UpdateMusic()
	jr UpdateMusic

.twice
;> else:                                    # double speed
;>     UpdateMusic()
	call UpdateMusic
;>     return UpdateMusic()

;@ def UpdateMusic()
;@ path: sound/engine
;@ Runs the two music engines for one frame (banks $1B and $1E; the one holding the current song
;@ plays it).
;@ test: skip calls the sound engines in other banks
UpdateMusic::
;> set_rom_bank(0x1B)
	ld a, $1b
	ld [$2100], a
;> UpdateMusicBank1B()                      # bank $1B $4006
	call $4006
;> set_rom_bank(0x1E)
	ld a, $1e
	ld [$2100], a
;> UpdateMusicBank1E()                      # bank $1E $4006
	call $4006

jr_000_0876:
;> return
	ret


	db $ff, $ff, $ff, $ff, $ff

;@ def UpdateLinkAnimationStateFar()
;@ path: link/animation
;@ Calls UpdateLinkAnimationState with bank 2 (its pose tables) switched in, then switches the
;@ caller's bank (wCurrentBank) back in.
;@ test: skip switches ROM banks
UpdateLinkAnimationStateFar::
;> set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;> UpdateLinkAnimationState()
	call UpdateLinkAnimationState
;> return RestoreBank()
	jp RestoreBank


;@ def GetEntityDropTimer(slot: bc) -> a
;@ path: entity/helpers
;@ Returns wEntityDropTimer[slot] (zero flag set when it is 0).
GetEntityDropTimer::
;> table = wEntityDropTimer
	ld hl, wEntityDropTimer
;> return mem[table + slot]                 # (the shared end in GetEntityTimer)
	jr jr_000_0894

;@ def GetEntityTimer1(slot: bc) -> a
;@ path: entity/helpers
;@ Returns wEntityTimer1[slot] (zero flag set when it is 0).
GetEntityTimer1::
;> table = wEntityTimer1
	ld hl, wEntityTimer1
;> return mem[table + slot]                 # (the shared end in GetEntityTimer)
	jr jr_000_0894

;@ def GetEntityTimer(slot: bc) -> a
;@ path: entity/helpers
;@ Returns wEntityTimer[slot] (zero flag set when it is 0). The two routines above share its end.
GetEntityTimer::
;> table = wEntityTimer
	ld hl, wEntityTimer

jr_000_0894:
;>@t return mem[table + slot]
	add hl, bc
	ld a, [hl]
	and a
	ret


;@ def SpawnHeldItemEntity()
;@ path: entity/spawn
;@ Spawns entity $AF - the item Link holds up when he gets something - at Link's position.
;@ test: skip spawns an entity
SpawnHeldItemEntity::
;> slot = SpawnEntity(0xAF)                 # SpawnEntity: new slot in de (no check whether it worked)
	ld a, $af
	call SpawnEntity
;> wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> return
	ret


;@ def PlayNoAmmoSound()
;@ path: item/use
;@ The "can't" buzz (square sound $1D), played when an item has no ammunition left.
PlayNoAmmoSound::
;> hJingle = 0x1D
	ld a, $1d
	ldh [hJingle], a
	ret


;@ def GetNameCharTile(char: bc) -> a
;@ path: menu/file_select
;@ The tile that shows character `char` (0-based) of the player name: a byte of the table at
;@ $45E1 in bank $1C. Switches bank 1 back in (the file menus run there). The three bytes after
;@ the first instruction (`ld hl, $46E1`) are an unused second entry for another table.
;@ test: skip reads a table in another bank
GetNameCharTile::
;> table = 0x45E1
	ld hl, $45e1
	jr jr_000_08b9

	db $21, $e1, $46

jr_000_08b9:
;> set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;> tile = mem[table + char]
	add hl, bc
	ld a, [hl]
;> set_rom_bank(1)
	ld hl, $2100
	ld [hl], $01
;> return tile
	ret


;@ def CopyTilesFromBank0C(src: hl, dest: de)
;@ path: gfx/tiles
;@ Copies 4 tiles (64 bytes) from bank $0C to VRAM for code in bank 1, then switches bank 1 back in.
;@ test: skip switches ROM banks
CopyTilesFromBank0C::
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;> set_rom_bank(1)
	ld a, $01
	ld [$2100], a
	ret


;@ def PlayClinkNoise()
;@ path: link/sword
;@ Plays the clink noise ($0C) and starts wClinkTimer (runs on into StartClinkTimer).
PlayClinkNoise::
;> hNoiseSfx = 0x0C
;> return StartClinkTimer()
	ld hl, hNoiseSfx
	ld [hl], $0c

;@ def StartClinkTimer()
;@ path: link/sword
;@ Starts wClinkTimer (4 frames).
StartClinkTimer::
;> wClinkTimer = 4
	ld hl, wClinkTimer
	ld [hl], $04
	ret


;@ def DecrementEntityIgnoreHitsTimer(slot: bc)
;@ path: entity/helpers
;@ Counts wEntityIgnoreHitsTimer[slot] down by one, stopping at 0.
DecrementEntityIgnoreHitsTimer::
;> if wEntityIgnoreHitsTimer[slot]:
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .done

;>     wEntityIgnoreHitsTimer[slot] -= 1
	dec [hl]

.done
;> return
	ret


;@ def TriggerRoomEvent()
;@ path: world/room_events
;@ The room's event happens (all enemies beaten, a puzzle solved, ...): marks it done, so the
;@ shutters open, and plays the chime (square sound 2) unless wNoEventJingle is set. Only the
;@ first call counts. Keeps a.
;@ test: wRoomEventDone = rng.choice([0, 0, 1])
TriggerRoomEvent::
;> if not wRoomEventDone:
	push af
	ld a, [wRoomEventDone]
	and a
	jr nz, .done

;>     wRestoreMusicAfterTransition = 0
	ld [wRestoreMusicAfterTransition], a
;>     wRoomEventDone = 1
	inc a
	ld [wRoomEventDone], a
;>     wRoomEventJustDone = 1
	ld [wRoomEventJustDone], a
;>     if not wNoEventJingle:
	ld a, [wNoEventJingle]
	and a
	jr nz, .done

;>         hJingle = 0x02
	ld a, $02
	ldh [hJingle], a

.done
;> return
	pop af
	ret


;@ def StartWarpFadeOutWithNoise()
;@ path: world/warps
;@ Starts the fade-out of a warp with the warp noise ($06) and the music fading out.
StartWarpFadeOutWithNoise::
;> hVolumeFadeOutTimer = 0x30
	ld a, $30
	ldh [hVolumeFadeOutTimer], a
;> hNoiseSfx = 0x06
;> return StartScreenFadeOut()
	jr jr_000_0926

;@ def StartWarpFadeOutMusic()
;@ path: world/warps
;@ Starts the fade-out of a warp with the music fading out, without a noise.
StartWarpFadeOutMusic::
;> hVolumeFadeOutTimer = 0x30
	ld a, $30
	ldh [hVolumeFadeOutTimer], a
;> return StartScreenFadeOut()
	jr StartScreenFadeOut

;@ def StartWarpFadeOut()
;@ path: world/warps
;@ Starts the fade-out of the warp in warp record 0. From an indoor room to another indoor
;@ place the music keeps playing (hSkipMusicSelection); otherwise it fades out. The warp noise
;@ plays in both cases.
StartWarpFadeOut::
;> if wWarpType != 1 or not wIsIndoor:
	ld a, [wWarpType]
	cp $01
	jr nz, StartWarpFadeOutWithNoise

	ld a, [wIsIndoor]
	and a
;>     return StartWarpFadeOutWithNoise()
	jr z, StartWarpFadeOutWithNoise

;> hSkipMusicSelection = 1
	ld a, $01
	ldh [hSkipMusicSelection], a

jr_000_0926:
;> hNoiseSfx = 0x06
	ld a, $06
	ldh [hNoiseSfx], a
;> return StartScreenFadeOut()

;@ def StartScreenFadeOut() -> carry
;@ path: world/warps
;@ Puts Link into motion state 3 (the screen fades out, then the warp is taken) and restarts the
;@ fade counters. Returns with carry clear.
StartScreenFadeOut::
;> wLinkMotionState = 3
	ld a, $03
	ld [wLinkMotionState], a
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> mem[0xD478] = 0
	ld [wEvilEagleFightStarted], a
;> return False
	and a
	ret


;@ def ResetSpinAttackAndDash()
;@ path: link/sword
;@ Cancels the spin attack and the sword charge, then the Pegasus dash (ResetPegasusBoots).
ResetSpinAttackAndDash::
;> wSpinAttackTimer = 0
	xor a
	ld [wSpinAttackTimer], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> return ResetPegasusBoots()

;@ def ResetPegasusBoots()
;@ path: link/pegasus_boots
;@ Stops the Pegasus dash and empties its charge.
ResetPegasusBoots::
;> wPegasusBootsChargeMeter = 0
	xor a
	ld [wPegasusBootsChargeMeter], a
;> wIsUsingPegasusBoots = 0
	ld [wIsUsingPegasusBoots], a
	ret


;@ def RestoreLinkPosition()
;@ path: link/movement
;@ Puts Link back where he was before this frame's move.
RestoreLinkPosition::
;> hLinkX = hLinkPrevX
	ldh a, [hLinkPrevX]
	ldh [hLinkX], a
;> hLinkY = hLinkPrevY
	ldh a, [hLinkPrevY]
	ldh [hLinkY], a
	ret


;@ def AddTransientVfx(kind: a)
;@ path: gfx/vfx
;@ Starts a short visual effect `kind` (dust, splash, clink star, ...) at (hMultiPurpose0,
;@ hMultiPurpose1) for $0F frames. Takes the highest free effect slot; when all 16 are busy it
;@ overwrites one, going round with wVfxReplaceSlot.
;@ test: hMultiPurpose0 = rand(0, 255)
AddTransientVfx::
;> slot = 0x0F
	push af
	ld e, $0f
	ld d, $00

.find
;>@f while wVfxType[slot] != 0:             # look for a free slot, from 15 down
	ld hl, wVfxType
	add hl, de
	ld a, [hl]
	and a
	jr z, .found

;>     slot -= 1
	dec e
;>     if slot < 0:                         # none free: reuse one
	ld a, e
	cp $ff
;=@f
	jr nz, .find

;>         wVfxReplaceSlot = u8(wVfxReplaceSlot - 1)
	ld hl, wVfxReplaceSlot
	dec [hl]
;>         if wVfxReplaceSlot == 0xFF:
	ld a, [hl]
	cp $ff
	jr nz, .replace

;>             wVfxReplaceSlot = 0x0F
	ld a, $0f
	ld [wVfxReplaceSlot], a

.replace
;>         slot = wVfxReplaceSlot
	ld a, [wVfxReplaceSlot]
	ld e, a
;>         break

.found
;> wVfxType[slot] = kind
	pop af
	ld hl, wVfxType
	add hl, de
	ld [hl], a
;> wVfxY[slot] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld hl, wVfxY
	add hl, de
	ld [hl], a
;> wVfxX[slot] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld hl, wVfxX
	add hl, de
	ld [hl], a
;> wVfxTimer[slot] = 0x0F
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f
	ret


;@ def AddClinkAtSword()
;@ path: link/sword
;@ The clink of the sword on something hard, shown at the sword's hitbox (AddClinkVfx).
AddClinkAtSword::
;> hMultiPurpose0 = u8(wSwordHitboxX - 8)
	ld a, [wSwordHitboxX]
	sub $08
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = u8(wSwordHitboxY - 8)
	ld a, [wSwordHitboxY]
	sub $08
	ldh [hMultiPurpose1], a
;> return AddClinkVfx()

;@ def AddClinkVfx()
;@ path: link/sword
;@ Plays the clink sound (square sound 7) and shows the clink star (effect 5) at (hMultiPurpose0,
;@ hMultiPurpose1).
AddClinkVfx::
;> hJingle = 0x07
	ld a, $07
	ldh [hJingle], a
;> return AddTransientVfx(0x05)
	ld a, $05
	jp AddTransientVfx


;@ def LoadRoomTilesets()
;@ path: world/rooms
;@ After a room change: picks the background tile set of the room and the four entity tile sets
;@ its characters need (tables in bank 8), and requests the VBlank copies of those that are not
;@ loaded yet. Background: indoors one byte per room ($4040, a second page for maps $06-$19),
;@ on the overworld one byte per 2x2 block of rooms ($4000; $0F = keep). Entity tiles: a group
;@ number per room ($4240 + page), then 4 tile set ids per group ($4540 overworld, $4788
;@ indoors; $FF = keep). Two overworld groups change once a room event has happened there
;@ (rooms $C9 and $FD). The first changed slot goes to the first request, the others to the
;@ second. Switches the caller's bank back in at the end.
;@ test: skip reads tables in bank 8
LoadRoomTilesets::
;> set_rom_bank(0x08)
	ld a, $08
	ld [$2100], a
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

;>     table = 0x4040
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, $4040
;>     if 0x06 <= hMapId < 0x1A: table += 0x100   # the second group of indoor maps
	ldh a, [hMapId]
	cp $1a
	jr nc, .indoorTable

	cp $06
	jr c, .indoorTable

	inc h

.indoorTable
;>     tileset = mem[table + hMapRoom]
	add hl, de
	ldh a, [hWorldTileset]
	ld e, a
	ld a, [hl]
;>     if tileset != hWorldTileset:
	cp e
	jr z, .indoorDone

;>         hWorldTileset = tileset
	ldh [hWorldTileset], a
;>         if tileset != 0xFF:
	cp $ff
	jr z, .indoorDone

;>             hNeedsUpdatingBGTiles = 1
	ld a, $01
	ldh [hNeedsUpdatingBGTiles], a

.indoorDone
;=@bg
	jr .entityTiles

.overworld
;>@bg else:
;>     room = hMapRoom
;>     if room == 0x07: room = 0x08         # room 7 uses the tile set of room 8
	ldh a, [hMapRoom]
	cp $07
	jr nz, .room

	inc a

.room
;>     block = ((room >> 2) & 0xF8) | ((room >> 1) & 0x07)   # the 2x2 block of rooms
	ld d, a
	srl a
	srl a
	and $f8
	ld e, a
;=@blk
	ld a, d
	srl a
	and $07
	or e
	ld e, a
;>@blk     tileset = mem[0x4000 + block]
	ld d, $00
	ld hl, $4000
	add hl, de
	ldh a, [hWorldTileset]
	ld e, a
	ld a, [hl]
;>     if tileset != hWorldTileset and tileset != 0x0F:
	cp e
	jr z, .entityTiles

	cp $0f
	jr z, .entityTiles

;>         hWorldTileset = tileset
	ldh [hWorldTileset], a
;>         hNeedsUpdatingBGTiles = 1
	ld a, $01
	ldh [hNeedsUpdatingBGTiles], a

.entityTiles
;> hMultiPurpose0 = 0                       # no entity tile request made yet
	xor a
	ldh [hMultiPurpose0], a
;> page = wIsIndoor
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, $4240
	ld a, [wIsIndoor]
	ld d, a
;> if 0x06 <= hMapId < 0x1A: page += 1
	ldh a, [hMapId]
	cp $1a
	jr nc, .groupPage

	cp $06
	jr c, .groupPage

	inc d

.groupPage
;> group = mem[0x4240 + (page << 8) + hMapRoom]
	add hl, de
	ld e, [hl]
;> if page == 0:                            # overworld
	ld a, d
	and a
	jr nz, .groupDone

;>@g23     if group == 0x23 and wRoomStatus[0xC9] & 0x20: group += 1
	ld a, e
	cp $23
	jr nz, .check21

;=@g23
	ld a, [$d8c9]
	and $20
	jr z, .check21

	inc e

.check21
;>@g21     if group == 0x21 and wRoomStatus[0xFD] & 0x20: group += 1
	ld a, e
	cp $21
	jr nz, .groupDone

;=@g21
	ld a, [$d8fd]
	and $20
	jr z, .groupDone

	inc e

.groupDone
;> sets = (0x4788 if wIsIndoor else 0x4540) + 4 * group
	ld d, $00
	sla e
	rl d
	sla e
	rl d
;=@sets
	ld hl, $4540
	ld a, [wIsIndoor]
	and a
	jr z, .setsTable

	ld hl, $4788

.setsTable
;=@sets
	add hl, de
;>@sets for slot in range(4):
	ld d, $00
	ld bc, wLoadedEntityTilesets

.slot
;>     want = mem[sets + slot]
	ld e, [hl]
;>     if want != wLoadedEntityTilesets[slot] and want != 0xFF:
	ld a, [bc]
	cp e
	jr z, .nextSlot

	ld a, e
	cp $ff
	jr z, .nextSlot

;>         wLoadedEntityTilesets[slot] = want
	ld [bc], a
;>         if hMultiPurpose0:                # second change and later: the second request
	ldh a, [hMultiPurpose0]
	and a
	jr z, .firstRequest

;>             wEntityTilesSlotB = slot
	ld a, d
	ld [wEntityTilesSlotB], a
;>             wNeedsUpdatingNPCTiles = 1
	ld a, $01
	ld [wNeedsUpdatingNPCTiles], a
;=@req
	jr .nextSlot

;>@req         else:
.firstRequest
;>             hMultiPurpose0 = 1
	inc a
	ldh [hMultiPurpose0], a
;>             wEntityTilesSlotA = slot
	ld a, d
	ld [wEntityTilesSlotA], a
;>             hNeedsUpdatingEnemiesTiles = 1
	ld a, $01
	ldh [hNeedsUpdatingEnemiesTiles], a

.nextSlot
;=@sets
	inc hl
	inc bc
	inc d
	ld a, d
	cp $04
	jr nz, .slot

;> return RestoreBank()
	jp RestoreBank


;@ def RunGameMode()
;@ path: system/modes
;@ Runs the current game mode (wGameplayType) for one frame. First, in the modes from the world
;@ map on (and in the world mode only during normal play, step 7), holding A+B+Select+Start
;@ opens the save menu (mode 6) when nothing else is going on.
;@ test: skip calls the mode handlers in other banks
RunGameMode::
;>@c if wGameplayType >= 0x07 and (wGameplayType != 0x0B or wGameplaySubtype == 0x07):
	ld a, [wGameplayType]
	cp $07
	jr c, .dispatch

	cp $0b
	jr nz, .check

;=@c
	ld a, [wGameplaySubtype]
	cp $07
	jr nz, .dispatch

.check
;>     if wTransitionSequenceCounter == 4 and not (wDialogState or wLinkFrozen or wRoomTransitionState):
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .dispatch

;=@q
	ld a, [wDialogState]
	ld hl, wLinkFrozen
	or [hl]
	ld hl, wRoomTransitionState
	or [hl]
	jr nz, .dispatch

;>@q         if hJoypadHeld == 0xF0:          # A + B + Select + Start, nothing else
	ldh a, [hJoypadHeld]
	cp $f0
	jr nz, .dispatch

;>             wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>             wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>             wDialogState = 0
	ld [wDialogState], a
;>             wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>             wGameplayType = 0x06             # the save menu
	ld a, $06
	ld [wGameplayType], a

.dispatch
;> GameModeHandlers[wGameplayType]()
	ld a, [wGameplayType]
	rst $00

;@ path: system/modes
;@ The handler of each game mode, indexed by wGameplayType: 0 intro and title, 1 ending,
;@ 2 file select, 3 new file (name entry), 4 delete a file, 5 copy a file, 6 save menu, 7 world
;@ map, 8 a picture screen, 9 the scene with Marin on the beach, $0A a wall mural screen,
;@ $0B the game world. They run with bank 1 switched in (MainLoop).
GameModeHandlers::
	dw GameModeIntro
	dw GameModeEnding
	dw GameModeFileSelect
	dw GameModeFileNew
	dw GameModeFileDelete
	dw GameModeFileCopy
	dw GameModeSaveMenu
	dw GameModeWorldMap
	dw GameModePicture
	dw GameModeMarinBeach
	dw GameModeMural
	dw GameModeWorld

;@ def GameModeMural()
;@ path: system/modes
;@ Game mode $0A (bank 1 $67BC), then the common end of the frame.
;@ test: skip calls bank 1
GameModeMural::
;> Bank01_67BC()
	call $67bc
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def GameModePicture()
;@ path: system/modes
;@ Game mode 8, a picture shown full screen (bank 1 $654C), then the common end of the frame.
;@ test: skip calls bank 1
GameModePicture::
;> Bank01_654C()
	call $654c
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def GameModeMarinBeach()
;@ path: system/modes
;@ Game mode 9, Marin on the beach (bank 1 $5FBB), then the common end of the frame.
;@ test: skip calls bank 1
GameModeMarinBeach::
;> Bank01_5FBB()
	call $5fbb
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def GameModeWorldMap()
;@ path: system/modes
;@ Game mode 7, the world map screen (bank 1 $546E), then the common end of the frame.
;@ test: skip calls bank 1
GameModeWorldMap::
;> Bank01_546E()
	call $546e
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def GameModeSaveMenu()
;@ path: system/modes
;@ Game mode 6, the save menu: bank 1 $4000.
;@ test: skip jumps into bank 1
GameModeSaveMenu::
;> return Bank01_4000()
	jp $4000


;@ def GameModeIntro()
;@ path: system/modes
;@ Game mode 0, the intro and title screen: bank 1 $6E3E.
;@ test: skip jumps into bank 1
GameModeIntro::
;> return Bank01_6E3E()
	jp $6e3e


;@ def GameModeEnding()
;@ path: system/modes
;@ Game mode 1, the ending (bank $17 $482A), then the common end of the frame.
;@ test: skip calls bank $17
GameModeEnding::
;> SwitchBank(0x17)
	ld a, $17
	call SwitchBank
;> Call_17_482A()
	call $482a
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def UpdateEntitiesBank17()
;@ path: entity/engine
;@ Runs UpdateEntities (the entity update) with bank 3 switched in, for code in bank $17, and switches
;@ bank $17 back in. UpdateEntitiesBank1 and UpdateEntitiesBank2 do the same for banks 1 and 2.
;@ test: skip switches ROM banks
UpdateEntitiesBank17::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> back = 0x17
	ld a, $17

jr_000_0b1a:
;> UpdateEntities()
	push af
	call UpdateEntities
	pop af
;> return SwitchBank(back)
	jp SwitchBank


;@ def UpdateEntitiesBank1()
;@ path: entity/engine
;@ Runs UpdateEntities with bank 3 switched in, then switches bank 1 back in.
;@ test: skip switches ROM banks
UpdateEntitiesBank1::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> UpdateEntities()                              # (the end of UpdateEntitiesBank17)
;> return SwitchBank(0x01)
	ld a, $01
	jr jr_000_0b1a

;@ def UpdateEntitiesBank2()
;@ path: entity/engine
;@ Runs UpdateEntities with bank 3 switched in, then switches bank 2 back in.
;@ test: skip switches ROM banks
UpdateEntitiesBank2::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> UpdateEntities()                              # (the end of UpdateEntitiesBank17)
;> return SwitchBank(0x02)
	ld a, $02
	jr jr_000_0b1a

;@ def GameModeFileSelect()
;@ path: system/modes
;@ Game mode 2, the file select screen: bank 1 $4711.
;@ test: skip jumps into bank 1
GameModeFileSelect::
;> return Bank01_4711()
	jp $4711


;@ def GameModeFileNew()
;@ path: system/modes
;@ Game mode 3, a new file (name entry): bank 1 $494B.
;@ test: skip jumps into bank 1
GameModeFileNew::
;> return Bank01_494B()
	jp $494b


;@ def GameModeFileDelete()
;@ path: system/modes
;@ Game mode 4, deleting a file: bank 1 $4BE6.
;@ test: skip jumps into bank 1
GameModeFileDelete::
;> return Bank01_4BE6()
	jp $4be6


;@ def GameModeFileCopy()
;@ path: system/modes
;@ Game mode 5, copying a file: bank 1 $4E34.
;@ test: skip jumps into bank 1
GameModeFileCopy::
;> return Bank01_4E34()
	jp $4e34


;@ def GameModeWorld()
;@ path: system/modes
;@ Game mode $0B, the game world: runs two per-frame routines of bank $14 (timers and sound
;@ cues), then the world step dispatcher of bank 1 ($431E, by wGameplaySubtype); during normal
;@ play (step 7) that goes on to WorldGameplayFrame.
;@ test: skip calls other banks
GameModeWorld::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> Bank14_5326()
	call $5326
;> Bank14_523C()                            # counts down several timers (compass chime, clink, ...)
	call $523c
;> SwitchBank(1)
	ld a, $01
	call SwitchBank
;> return WorldStepDispatch()               # bank 1 $431E: table by wGameplaySubtype
	jp $431e


;@ def WorldGameplayFrame()
;@ path: world/frame
;@ One frame of normal play in the world (world step 7): the delayed area name popup, a scripted
;@ warp countdown, Link's update (banks 2 and 1), the room scroll, Link's items and controls
;@ (UpdateLink), the per-frame counters, the entities, and the background effects; ends in
;@ EndGameModeFrame (dialogues).
;@ test: skip calls routines in other banks
WorldGameplayFrame::
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .afterTimers

;>     if mem[0xFFB4] and wWindowY == 0x80 and not wInventoryAppearing:
	ld hl, $ffb4
	ld a, [hl]
	and a
	jr z, .warpTimer

;=@nm
	ld a, [wWindowY]
	cp $80
	jr nz, .warpTimer

	ld a, [wInventoryAppearing]
	and a
	jr nz, .warpTimer

;>@nm         mem[0xFFB4] -= 1
	dec [hl]
;>         if mem[0xFFB4] == 0:
	jr nz, .warpTimer

;>             set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;>             ShowDungeonNameText()
	call ShowDungeonNameText
;>             RestoreBank()
	call RestoreBank

.warpTimer
;>     if not wDialogState and mem[0xC1BC]: # a scripted warp counts down
	ld a, [wDialogState]
	and a
	jr nz, .afterTimers

	ld a, [wScriptedWarpTimer]
	and a
	jr z, .afterTimers

;>         hLinkInteractiveMotionBlocked = 2
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $02
;>         mem[0xC1BC] -= 1
	dec a
	ld [wScriptedWarpTimer], a
;>         if mem[0xC1BC] == 0:
	jr nz, .afterTimers

;>             return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise


.afterTimers
;> if wInvincibilityCounter: wInvincibilityCounter -= 1
	ld hl, wInvincibilityCounter
	ld a, [hl]
	and a
	jr z, .notInvincible

	dec [hl]

.notInvincible
;> hLinkPrevX = hLinkX
	ldh a, [hLinkX]
	ldh [hLinkPrevX], a
;> hLinkPrevY = hLinkY
	ldh a, [hLinkY]
	ldh [hLinkPrevY], a
;> hLinkDrawYAtFrameStart = u8(hLinkY - hLinkPositionZ)
	ld hl, hLinkPositionZ
	sub [hl]
	ldh [hLinkDrawYAtFrameStart], a
;> UpdateInventoryAndHud()                            # caps the ammunition at the capacities, ...
	call UpdateInventoryAndHud
;> wSwordHitboxX = 0
	xor a
	ld [wSwordHitboxX], a
;> wLinkSpriteDX = 0
	ld [wLinkSpriteDX], a
;> wLinkSpriteDY = 0
	ld [wLinkSpriteDY], a
;> mem[0xC11D] &= 0x7F                      # attributes of Link's two sprites: bit 7 (behind the background) off
	ld hl, wLinkOAMAttrLeft
	res 7, [hl]
;> mem[0xC11E] &= 0x7F
	ld hl, wLinkOAMAttrRight
	res 7, [hl]
;> UpdateRoomDoors()
	call UpdateRoomDoors
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> RunRoomTransition()
	call RunRoomTransition
;> UpdateLink()
	call UpdateLink
;> wLinkIsCarrying = wIsCarryingLiftedObject
	ld a, [wIsCarryingLiftedObject]
	ld [wLinkIsCarrying], a
;> wBombsOnScreen = 0                       # recounted by the entities below
	xor a
	ld [wBombsOnScreen], a
;> wActiveProjectileCount = 0
	ld [wActiveProjectileCount], a
;> wHookshotInUse = 0
	ld [wHookshotInUse], a
;> wIsCarryingLiftedObject = 0
	ld [wIsCarryingLiftedObject], a
;> wGelCount = 0
	ld [wGelCount], a
;> if wLinkPushingTimer: wLinkPushingTimer -= 1
	ld a, [wLinkPushingTimer]
	and a
	jr z, .entities

	dec a
	ld [wLinkPushingTimer], a

.entities
;> SwitchBank(0x19)
	ld a, $19
	call SwitchBank
;> AnimateScrollingFloorTiles()
	call AnimateScrollingFloorTiles
;> UpdateEntities()                              # all entities
	call UpdateEntities
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> UpdateVfxAndStairs()
	call UpdateVfxAndStairs
;> if not (hFrameCounter & 3 or wDrawCommand[0]) and wLinkMotionState < 2:
	ld hl, wDrawCommand
	ldh a, [hFrameCounter]
	and $03
	or [hl]
	jr nz, .bank14

;=@dbg
	ld a, [wLinkMotionState]
	cp $02
	jr nc, .bank14

;>@dbg     c = 1
	ld c, $01
	ld b, $00
;>     e = 0
	ld e, $00
;>     if hFrameCounter & 4:
	ldh a, [hFrameCounter]
	and $04
	jr z, .call61ED

;>         c = 0
	dec c
;>         e = 0xFF
	dec e

.call61ED
;>     DrawItemSlots(c, e)                    # does nothing unless the debug byte at $0004 is set
	call $61ed

.bank14
;> SwitchBank(0x14)
	ld a, $14
	call SwitchBank
;> UpdateBumpShake()
	call $59b0
;> return EndGameModeFrame()

;@ def EndGameModeFrame()
;@ path: system/modes
;@ Common end of a game mode's frame: runs the dialogue box (UpdateDialog, bank $0F).
;@ test: skip calls bank $0F
EndGameModeFrame::
;> SwitchBank(0x0F)
	ld a, $0f
	call SwitchBank
;> UpdateDialog()
	call UpdateDialog
	ret


;@ path: link/items
;@ Dialogue opened by each of Link's item-showing poses when wLinkShowItemTimer reaches 2, one
;@ byte per pose (wLinkShowItemPose 1-5, index pose - 1): dialogues $08, $0E, $99, $28, $EC.
ItemSceneDialogs::
	db $08, $0e, $99, $28, $ec

;@ def UpdateLink()
;@ path: link/frame
;@ Link's part of a world frame. Works out where his sprite is drawn, then runs the pose in which
;@ he holds something up (wLinkShowItemPose): its timer counts down while no dialogue is open,
;@ at 2 the pose's dialogue opens (ItemSceneDialogs), at 0 the pose ends; while it runs the
;@ pose's handler in bank 2 does the frame. Otherwise UpdateLinkMain.
;@ test: skip calls routines in bank 2
UpdateLink::
;> wLinkDrawY = u8(hLinkY - hLinkPositionZ)
	ldh a, [hLinkY]
	ld hl, hLinkPositionZ
	sub [hl]
	ld [wLinkDrawY], a
;> if not wLinkShowItemPose:
	ld a, [wLinkShowItemPose]
	and a
;>     return UpdateLinkMain()
	jr z, UpdateLinkMain

;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .runPose

;>     wLinkShowItemTimer -= 1
	ld hl, wLinkShowItemTimer
	dec [hl]
;>     left = wLinkShowItemTimer
	ld a, [hl]
;>     if left == 2:                        # the pose's text opens
	cp $02
	jr nz, .checkEnd

;>         OpenDialog(ItemSceneDialogs[wLinkShowItemPose - 1])
	ld a, [wLinkShowItemPose]
	ld e, a
	ld d, $00
	ld hl, ItemSceneDialogs - 1
	add hl, de
;=@od
	ld a, [hl]
	call OpenDialog
;>@od         left = 1
	ld a, $01

.checkEnd
;>     if left == 0:                        # the pose is over
	and a
	jr nz, .runPose

;>         wLinkShowItemPose = 0
	xor a
	ld [wLinkShowItemPose], a
;>         wLinkShowItemPoseActive = 0
	ld [wLinkShowItemPoseActive], a
;>         return UpdateLinkMain()
	jr UpdateLinkMain

.runPose
;> wLinkShowItemPoseActive = wLinkShowItemPose
	ld a, [wLinkShowItemPose]
	ld [wLinkShowItemPoseActive], a
;> return ShowItemPoseHandlers[wLinkShowItemPose - 1]()
	dec a
	rst $00

;@ path: link/items
;@ Handlers (bank 2) of Link's item-showing poses 1-5, indexed by wLinkShowItemPose - 1. $5018
;@ (poses 1 and 5) plays square sound $17 at timer $2E and goes on into $5023, the common pose
;@ routine of poses 2-4.
ShowItemPoseHandlers::
	dw $5018, $5023, $5023, $5023, $5018

;@ def UpdateLinkMain()
;@ path: link/frame
;@ The main part of Link's frame: Select held alone for 4 frames opens the world map (game mode
;@ 7, returning straight to the caller's caller); counts down Link's timers; while a dialogue is
;@ open or the room scrolls only his sprite is updated; Link dies when his health is 0; then the
;@ handler of his motion state (LinkMotionHandlers) runs.
;@ test: skip calls routines in other banks
UpdateLinkMain::
;>@sel if not hJoypadHeld & 0xB0 and hJoypadHeld & 0x40:   # Select without A, B, Start
	ldh a, [hJoypadHeld]
	and $b0
	jr nz, .noMap

;=@sel
	ldh a, [hJoypadHeld]
	and $40
	jr z, .noMap

;>     wSelectHeldFrames += 1
	ld a, [wSelectHeldFrames]
	inc a
	ld [wSelectHeldFrames], a
;>     if wSelectHeldFrames >= 4:
	cp $04
	jr c, .timers

;>@ok         if (hLinkInteractiveMotionBlocked != 2 and hLinkAnimationState != 0xFF
;>                 and wLinkMotionState < 2 and not (wDialogState or wLinkFrozen)):
	ldh a, [hLinkInteractiveMotionBlocked]
	cp $02
	jr z, .noMap

	ldh a, [hLinkAnimationState]
	cp $ff
;=@ok
	jr z, .noMap

	ld a, [wLinkMotionState]
	cp $02
	jr nc, .noMap

;=@ok
	ld hl, wLinkFrozen
	ld a, [wDialogState]
	or [hl]
	jr nz, .noMap

;>             wTransitionSequenceCounter = 0  # open the world map
	xor a
	ld [wTransitionSequenceCounter], a
;>             wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>             wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;>             wGameplayType = 0x07
	ld a, $07
	ld [wGameplayType], a
;>             set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>             SetLinkSpriteDY()
	call $781b
;>             DrawLinkOAM()
	call DrawLinkOAM
;>             UpdateEntities()
	call UpdateEntities
;>             return_from_caller()          # skips the rest of the world frame
	pop af
	ret


;>         else:
;>             wSelectHeldFrames = 0        # (the same instructions as below)
;> else:
;>     wSelectHeldFrames = 0
.noMap
	xor a
	ld [wSelectHeldFrames], a

.timers
;> if hLinkCountdown: hLinkCountdown -= 1
	ldh a, [hLinkCountdown]
	and a
	jr z, .countdown2

	dec a
	ldh [hLinkCountdown], a

.countdown2
;> if mem[0xFFB6]: mem[0xFFB6] -= 1
	ldh a, [hSwordClashCooldown]
	and a
	jr z, .checkDialog

	dec a
	ldh [hSwordClashCooldown], a

.checkDialog
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return UpdateLinkItemSprites()                   # only Link's sprite while a dialogue is open
	jp nz, UpdateLinkItemSprites

;> if wRoomTransitionState:
	ld a, [wRoomTransitionState]
	and a
;>     return UpdateLinkInTransition()
	jp nz, UpdateLinkInTransition

;> if wLinkMotionState != 7:
	ld a, [wLinkMotionState]
	cp $07
	jr z, .dispatch

;>     if not (wHealth or mem[0xC50A] or wInventoryAppearing):   # out of health: Link dies
	ld a, [wHealth]
	ld hl, wItemButtonsDisabled
	or [hl]
	ld hl, wInventoryAppearing
	or [hl]
	jr nz, .state

;>         wLinkMotionState = 7
	ld a, $07
	ld [wLinkMotionState], a
;>         hLinkCountdown = 0xBF
	ld a, $bf
	ldh [hLinkCountdown], a
;>         mem[0xC3CC] = 0x10
	ld a, $10
	ld [wRoomDarknessShown], a
;>         wInvincibilityCounter = 0
	xor a
	ld [wInvincibilityCounter], a
;>         hLinkMotionStep = 0
	ldh [hLinkMotionStep], a
;>         ResetSoundEngine()
	call ResetSoundEngine
;>         hWaveSfx = 0x08                  # the dying sound
	ld a, $08
	ldh [hWaveSfx], a

.state
	ld a, [wLinkMotionState]

.dispatch
;> return LinkMotionHandlers[wLinkMotionState]()
	rst $00

;@ path: link/motion
;@ Handler of each of Link's motion states (wLinkMotionState), run every world frame with bank
;@ 2 switched in (raw addresses are in bank 2): 0 normal (LinkMotionNormal), 1 $4D92, 2 $490E,
;@ 3 fading out for a warp (LinkMotionMapFadeOut), 4 fading in after it (LinkMotionMapFadeIn),
;@ 5 $4D00, 6 $4F30, 7 dying (LinkMotionDying), 8 $50A2, 9 LinkMotionBank19, $0A $4EFF.
LinkMotionHandlers::
	dw LinkMotionNormal
	dw $4d92
	dw $490e
	dw LinkMotionMapFadeOut
	dw LinkMotionMapFadeIn
	dw $4d00
	dw $4f30
	dw LinkMotionDying
	dw $50a2
	dw LinkMotionBank19
	dw $4eff

;@ def UpdateLinkInTransition()
;@ path: link/frame
;@ While the room scrolls: only Link's sprites are updated (UpdateLinkItemSprites, then DrawLinkOAM).
;@ test: skip
UpdateLinkInTransition::
;> UpdateLinkItemSprites()
	call UpdateLinkItemSprites
;> return DrawLinkOAM()
	jp DrawLinkOAM


;@ def LinkMotionBank19()
;@ path: link/motion
;@ Motion state 9: runs bank $19 $5CA9 (it blocks Link's controls and steps by hLinkMotionStep).
;@ test: skip jumps into bank $19
LinkMotionBank19::
;> SwitchBank(0x19)
	ld a, $19
	call SwitchBank
;> return LinkMotionWarpHoleRise()
	jp LinkMotionWarpHoleRise

;@ def LinkMotionDying()
;@ path: link/motion
;@ Motion state 7, Link dies: the death and game over sequence of bank 1 ($4184, steps by
;@ hLinkMotionStep). Also used by other banks.
;@ test: skip jumps into bank 1
LinkMotionDying::
;> SwitchBank(1)
	ld a, $01
	call SwitchBank
;> return Bank01_4184()
	jp $4184

;@ def LinkMotionNormal()
;@ path: link/motion
;@ Motion state 0, Link under the player's control: bank 2 $426E.
;@ test: skip calls bank 2
LinkMotionNormal::
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> Bank02_426E()
	call $426e
	ret


;@ def HandleItemButtons()
;@ path: link/items
;@ Reads the A and B buttons for the items on them: while dashing a sword is held out in front
;@ (or the shield raised); the Pegasus Boots charge while their button is held; the shield is
;@ raised while its button is held; a newly pressed button uses its item (UseItem), a held one
;@ keeps using it (HoldItem). Nothing happens while Link is held by a scene, the hookshot is
;@ out, he carries something, or (outside the end of a sword swing) his controls are blocked.
;@ While Link can talk to someone, A (and B when wCanTalkToEntity is 2) talks instead.
;@ test: skip calls item routines in other banks
HandleItemButtons::
;> if mem[0xC50A] or wLinkFrozen or wHookshotInUse:
	ld a, [wItemButtonsDisabled]
	ld hl, wLinkFrozen
	or [hl]
	ld hl, wHookshotInUse
	or [hl]
;>     return
	ret nz

;>@dash if wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, .notDashing

;>@sw     if wItemA != 1 and wItemB != 1:      # no sword on a button
	ld a, [wItemA]
	cp $01
	jr z, .swordOut

	ld a, [wItemB]
	cp $01
	jr z, .swordOut

;>         if wItemA == 4 or wItemB == 4:   # the shield
	ld a, [wItemA]
	cp $04
	jr z, .shield

	ld a, [wItemB]
	cp $04
	jr nz, .dashDone

.shield
;>             RaiseShield()
	call RaiseShield
;=@sw
	jr .dashDone

;>     else:                                # the sword is held out in front while dashing
.swordOut
;>         if not 1 <= wSwordAnimationState <= 4:
	ld a, [wSwordAnimationState]
	dec a
	cp $04
	jr c, .dashDone

;>             wSwordAnimationState = 5
	ld a, $05
	ld [wSwordAnimationState], a
;>             wSwordAnimationStatePrev = 5
	ld [wSwordAnimationStatePrev], a

.dashDone
;=@dash
	jr .buttons

;> else:
.notDashing
;>     wIsUsingShield = 0
	xor a
	ld [wIsUsingShield], a
;>     wShieldLevelEquipped = 0
	ld [wShieldLevelEquipped], a

.buttons
;> if wLinkSlowAnimation or wIsCarryingLiftedObject:
	ld a, [wLinkSlowAnimation]
	and a
	jp nz, Jump_000_0ed0

	ld a, [wIsCarryingLiftedObject]
	and a
;>     return
	jp nz, Jump_000_0ed0

;>@bl if not (wSwordAnimationState == 3 and wSwordStateTimer >= 3) and hLinkInteractiveMotionBlocked:
	ld a, [wSwordAnimationState]
	and a
	jr z, .blocked

	cp $03
	jr nz, .blocked

;=@bl
	ld a, [wSwordStateTimer]
	cp $03
	jr nc, .boots

.blocked
;=@bl
	ldh a, [hLinkInteractiveMotionBlocked]
	and a
;>     return
	jp nz, Jump_000_0ed0

.boots
;> if wItemB == 8:                          # Pegasus Boots on B
	ld a, [wItemB]
	cp $08
	jr nz, .bootsA

;>     if hJoypadHeld & 0x20:
	ldh a, [hJoypadHeld]
	and $20
	jr z, .releaseB

;>         ChargePegasusBoots()
	call ChargePegasusBoots
;=@b1
	jr .bootsA

;>@b1     else:
.releaseB
;>         wPegasusBootsChargeMeter = 0
	xor a
	ld [wPegasusBootsChargeMeter], a

.bootsA
;> if wItemA == 8:                          # Pegasus Boots on A
	ld a, [wItemA]
	cp $08
	jr nz, .shieldA

;>     if hJoypadHeld & 0x10:
	ldh a, [hJoypadHeld]
	and $10
	jr z, .releaseA

;>         ChargePegasusBoots()
	call ChargePegasusBoots
;=@b2
	jr .shieldA

;>@b2     else:
.releaseA
;>         wPegasusBootsChargeMeter = 0
	xor a
	ld [wPegasusBootsChargeMeter], a

.shieldA
;> if wItemA == 4:                          # the shield on A
	ld a, [wItemA]
	cp $04
	jr nz, .shieldB

;>     wShieldLevelEquipped = wShieldLevel
	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a
;>     if hJoypadHeld & 0x10 and wCanTalkToEntity not in (1, 2):
	ldh a, [hJoypadHeld]
	and $10
	jr z, .shieldB

;=@s1
	ld a, [wCanTalkToEntity]
	cp $01
	jr z, .shieldB

	cp $02
	jr z, .shieldB

;>@s1         RaiseShield()
	call RaiseShield

.shieldB
;> if wItemB == 4:                          # the shield on B
	ld a, [wItemB]
	cp $04
	jr nz, .pressB

;>     wShieldLevelEquipped = wShieldLevel
	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a
;>     if hJoypadHeld & 0x20:
	ldh a, [hJoypadHeld]
	and $20
	jr z, .pressB

;>         RaiseShield()
	call RaiseShield

.pressB
;> if hJoypadPressed & 0x20 and wCanTalkToEntity != 2:
	ldh a, [hJoypadPressed]
	and $20
	jr z, .pressA

	ld a, [wCanTalkToEntity]
	cp $02
	jr z, .pressA

;>     UseItem(wItemB)
	ld a, [wItemB]
	call UseItem

.pressA
;>@pa if hJoypadPressed & 0x10 and wCanTalkToEntity not in (1, 2):
	ldh a, [hJoypadPressed]
	and $10
	jr z, .holdB

;=@pa
	ld a, [wCanTalkToEntity]
	cp $01
	jr z, .holdB

	cp $02
	jr z, .holdB

;>     UseItem(wItemA)
	ld a, [wItemA]
	call UseItem

.holdB
;> if hJoypadHeld & 0x20:
	ldh a, [hJoypadHeld]
	and $20
	jr z, .holdA

;>     HoldItem(wItemB)
	ld a, [wItemB]
	call HoldItem

.holdA
;> if hJoypadHeld & 0x10:
	ldh a, [hJoypadHeld]
	and $10
	jr z, .done

;>     HoldItem(wItemA)
	ld a, [wItemA]
	call HoldItem

.done
;> return
	ret


;@ def UseItem(item: a)
;@ path: link/items
;@ Uses inventory item `item` (its button was just pressed): 1 sword, 2 bombs, 3 Power Bracelet,
;@ 4 shield, 5 bow, 6 hookshot, 7 magic rod, 9 ocarina (bank 2 $41E6), $0A Roc's Feather,
;@ $0B shovel, $0C magic powder, $0D boomerang. The magic rod only puts Link into its pose
;@ (wItemUsePoseTimer $8E, bit 7 = draw the rod); its fireball comes from Link's code.
;@ test: skip calls item routines in other banks
UseItem::
;> if item == 0x01:
	ld c, a
	cp $01
;>     return UseSword()
	jp z, UseSword

;> elif item == 0x04:
	cp $04
;>     return UseShield()
	jp z, UseShield

;> elif item == 0x02:
	cp $02
;>     return UseBombs()
	jp z, UseBombs

;> elif item == 0x03:
	cp $03
;>     return UsePowerBracelet()
	jp z, UsePowerBracelet

;> elif item == 0x05:
	cp $05
;>     return UseBow()
	jp z, UseBow

;> elif item == 0x0D:
	cp $0d
;>     return UseBoomerang()
	jp z, UseBoomerang

;> elif item == 0x06:
	cp $06
;>     return UseHookshotItem()
	jp z, UseHookshotItem

;> elif item == 0x0A:
	cp $0a
;>     return UseRocsFeather()
	jp z, UseRocsFeather

;> elif item == 0x09:
	cp $09
;>     return UseOcarina()                  # bank 2 $41E6
	jp z, $41e6

;> elif item == 0x0C:
	cp $0c
;>     return UseMagicPowder()
	jp z, UseMagicPowder

;> elif item == 0x0B:
	cp $0b
;>     return UseShovel()
	jp z, UseShovel

;> elif item == 0x07:                       # the magic rod
	cp $07
	jr nz, Jump_000_0ed0

;>     if not (wItemUsePoseTimer or wSwordAnimationState) and wActiveProjectileCount < 2:
	ld hl, wSwordAnimationState
	ld a, [wItemUsePoseTimer]
	or [hl]
	jr nz, Jump_000_0ed0

;=@rod
	ld a, [wActiveProjectileCount]
	cp $02
	jr nc, Jump_000_0ed0

;>@rod         wItemUsePoseTimer = 0x8E
	ld a, $8e
	ld [wItemUsePoseTimer], a

Jump_000_0ed0:
;> return
	ret


;@ def UseShield()
;@ path: link/items
;@ Pressing the shield's button: plays the shield noise ($16) unless Link is pushing against
;@ something. Holding it is handled by HandleItemButtons.
UseShield::
;> if wLinkPushingTimer:
	ld a, [wLinkPushingTimer]
	and a
;>     return
	ret nz

;> hNoiseSfx = 0x16
	ld a, $16
	ldh [hNoiseSfx], a
	ret


;@ def UseShovel()
;@ path: link/items
;@ Digs with the shovel (unless already digging or in the air). Bank 2 $4C35 checks the square
;@ in front of Link: carry = it cannot be dug (clink, square sound 7), otherwise the dig noise
;@ ($0E). Then the dig animation starts (wDigState 1).
;@ test: skip calls bank 2
UseShovel::
;> if wDigState or wIsLinkInTheAir:
	ld a, [wDigState]
	ld hl, wIsLinkInTheAir
	or [hl]
;>     return
	ret nz

;> if CheckDiggableSquare():                # bank 2 $4C35, carry = hard ground
	call $4c35
	jr nc, .soft

;>     hJingle = 0x07
	ld a, $07
	ldh [hJingle], a
;=@h
	jr .dig

;>@h else:
.soft
;>     hNoiseSfx = 0x0E
	ld a, $0e
	ldh [hNoiseSfx], a

.dig
;> wDigState = 1
	ld a, $01
	ld [wDigState], a
;> wDigCounter = 0
	xor a
	ld [wDigCounter], a
	ret


;@ def UseHookshotItem()
;@ path: link/items
;@ Fires the hookshot (bank 2 $423B) unless it is already out.
;@ test: skip calls bank 2
UseHookshotItem::
;> if wHookshotInUse:
	ld a, [wHookshotInUse]
	and a
;>     return
	ret nz

;> FireHookshot()                           # bank 2 $423B
	call $423b
	ret


;@ def HoldItem(item: a)
;@ path: link/items
;@ An item button is held: for the sword (1) this holds it out in front, ready for a spin
;@ attack (wSwordAnimationState 5), when no swing is running and Link is not in talking position.
HoldItem::
;> if item != 0x01:
	cp $01
;>     return
	ret nz

;> if wSwordAnimationState or wCanTalkToEntity & 3:
	ld hl, wSwordAnimationState
	ld a, [wCanTalkToEntity]
	and $03
	or [hl]
;>     return
	ret nz

;> if mem[0xC160]:
	ld a, [$c160]
	and a
;>     return
	ret nz

;> wSwordDirectionLocked = 0
	xor a
	ld [wSwordDirectionLocked], a
;> wSwordAnimationState = 5
	ld a, $05
	ld [wSwordAnimationState], a
;> wSwordCollisionEnabled = 5
	ld [wSwordCollisionEnabled], a
	ret


;@ path: link/items
;@ Shield hitbox by Link's direction (right, left, up, down): x offset from hLinkX (signed).
ShieldHitboxDX::
	db $10, $00, $08, $08

;@ path: link/items
;@ Shield hitbox by direction: half width.
ShieldHitboxWidth::
	db $03, $03, $08, $08

;@ path: link/items
;@ Shield hitbox by direction: y offset from wLinkDrawY.
ShieldHitboxDY::
	db $08, $08, $00, $0d

;@ path: link/items
;@ Shield hitbox by direction: half height.
ShieldHitboxHeight::
	db $08, $08, $03, $04

;@ def RaiseShield()
;@ path: link/items
;@ Link holds up his shield: sets wIsUsingShield and the shield hitbox (SetShieldHitbox).
RaiseShield::
;> wIsUsingShield = 1
	ld a, $01
	ld [wIsUsingShield], a
;> wShieldLevelEquipped = wShieldLevel
	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a
;> return SetShieldHitbox()

;@ def SetShieldHitbox()
;@ path: link/items
;@ Puts the item hitbox (wSwordHitboxX ...) on the shield, in front of Link (ShieldHitboxDX ...).
;@ test: hLinkDirection = rand(0, 3)
SetShieldHitbox::
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> wSwordHitboxX = u8(hLinkX + mem[ShieldHitboxDX + d])
	ld hl, ShieldHitboxDX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ld [wSwordHitboxX], a
;> wSwordHitboxWidth = mem[ShieldHitboxWidth + d]
	ld hl, ShieldHitboxWidth
	add hl, de
	ld a, [hl]
	ld [wSwordHitboxWidth], a
;> wSwordHitboxY = u8(wLinkDrawY + mem[ShieldHitboxDY + d])
	ld hl, ShieldHitboxDY
	add hl, de
	ld a, [wLinkDrawY]
	add [hl]
	ld [wSwordHitboxY], a
;> wSwordHitboxHeight = mem[ShieldHitboxHeight + d]
	ld hl, ShieldHitboxHeight
	add hl, de
	ld a, [hl]
	ld [wSwordHitboxHeight], a
;> wSwordCollisionEnabled = 0
	xor a
	ld [wSwordCollisionEnabled], a
	ret


;@ path: link/items
;@ Where a new bomb is placed, by Link's direction (right, left, up, down): x offset from hLinkX.
BombPlaceDX::
	db $08, $f8, $00, $00

;@ path: link/items
;@ Where a new bomb is placed, by direction: y offset from hLinkY.
BombPlaceDY::
	db $00, $00, $fd, $04

;@ def UseBombs()
;@ path: link/items
;@ Lays a bomb (entity type 2) in front of Link, if no other bomb is out and he has one; with
;@ none left the "can't" buzz plays. An arrow shot within 6 frames before (wBombArrowWindow)
;@ turns into a bomb arrow instead (its state becomes 1); otherwise the window opens for an arrow
;@ shot just after. The bomb's fuse is wEntityTimer = $A0.
;@ test: skip spawns an entity
UseBombs::
;> if wBombsOnScreen >= 1:
	ld a, [wBombsOnScreen]
	cp $01
;>     return
	ret nc

;> if wBombCount == 0:
	ld a, [wBombCount]
	and a
;>     return PlayNoAmmoSound()
	jp z, PlayNoAmmoSound

;> wBombCount = to_bcd(bcd_to_int(wBombCount) - 1)
	sub $01
	daa
	ld [wBombCount], a
;> slot = SpawnLinkProjectile(0x02)         # carry: no free slot
	ld a, $02
	call SpawnLinkProjectile
;> if slot is None: return                  # carry: no free entity slot
	ret c

;> wEntityTimer1[slot] = 0x10
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $10
;> if wBombArrowWindow:                     # an arrow was just shot: it becomes a bomb arrow
	ld a, [wBombArrowWindow]
	and a
	jp z, .fuse

;>     wBombArrowWindow = 0
	xor a
	ld [wBombArrowWindow], a
;>     wEntityState[wBombArrowArrowSlot] = 1
	ld a, [$c1c2]
	ld c, a
	ld b, d
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
;>     return
	ret


.fuse
;> wBombArrowWindow = 6                     # an arrow shot within 6 frames joins this bomb
	ld a, $06
	ld [wBombArrowWindow], a
;> wBombArrowBombSlot = slot
	ld a, e
	ld [$c1c1], a
;> wItemUsePoseTimer = 0x0C
	ld a, $0c
	ld [wItemUsePoseTimer], a
;> wEntityTimer[slot] = 0xA0                # the fuse
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $a0
;> wEntitySpriteVariant[slot] = 0
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], d
;> wEntityDyingTimer[slot] = 3
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $03
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .sideView

;>     hJingle = 0x09
	ld a, $09
	ldh [hJingle], a
;=@sv
	jr .place

;>@sv else:
.sideView
;>     wEntityZ[slot] = 0
	ld hl, wEntityZ
	add hl, de
	ld [hl], d

.place
;> wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], d
;> wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], d
;> wEntitySpeedZ[slot] = 0
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], d
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld c, a
	ld b, d
;>@bx wEntityX[slot] = u8(hLinkX + BombPlaceDX[d])
	ld hl, BombPlaceDX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
;=@bx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@by wEntityY[slot] = u8(hLinkY + BombPlaceDY[d])
	ld hl, BombPlaceDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
;=@by
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ret


;@ def UsePowerBracelet()
;@ path: link/items
;@ The Power Bracelet does nothing when pressed (lifting is handled by Link's movement code).
;@ The six bytes after the `ret` are the boomerang's diagonal speeds (BoomerangDiagonalSpeedX/Y).
UsePowerBracelet::
;> return
	ret


;@ path: link/items
;@ Boomerang thrown diagonally: x speed by the held left/right button (index 0 right, 1 left;
;@ read as BoomerangDiagonalSpeedX - 1 + (hJoypadHeld & 3)).
BoomerangDiagonalSpeedX::
	db $18, $e8, $00

;@ path: link/items
;@ Boomerang thrown diagonally: y speed by the held up/down button (index 0 up, 1 down).
BoomerangDiagonalSpeedY::
	db $e8, $18, $00

;@ def UseBoomerang()
;@ path: link/items
;@ Throws the boomerang (entity type 1) unless one of Link's projectiles is out. It flies for
;@ $28 frames; with two direction buttons held it flies diagonally.
;@ test: skip spawns an entity
UseBoomerang::
;> if wActiveProjectileCount:
	ld a, [wActiveProjectileCount]
	and a
;>     return
	ret nz

;> slot = SpawnLinkProjectile(0x01)
	ld a, $01
	call SpawnLinkProjectile
;> if slot is None: return                  # carry: no free entity slot
	ret c

;> wEntityTimer[slot] = 0x28
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $28
;>@n pressed = (hJoypadHeld & 1) + (hJoypadHeld >> 1 & 1) + (hJoypadHeld >> 2 & 1) + (hJoypadHeld >> 3 & 1)   # direction buttons held
	ld c, $04
	ld b, $00
	ldh a, [hJoypadHeld]

.count
;=@n
	srl a
	jr nc, .notHeld

	inc b

.notHeld
;=@n
	dec c
	jr nz, .count

;> if pressed >= 2:                          # diagonal
	ld a, b
	cp $02
	jr c, .done

;>@x     wEntitySpeedX[slot] = mem[BoomerangDiagonalSpeedX - 1 + (hJoypadHeld & 3)]
	ldh a, [hJoypadHeld]
	and $03
	ld c, a
	ld b, $00
	ld hl, BoomerangDiagonalSpeedX - 1
	add hl, bc
;=@x
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;>@y     wEntitySpeedY[slot] = mem[BoomerangDiagonalSpeedY - 1 + ((hJoypadHeld >> 2) & 3)]
	ldh a, [hJoypadHeld]
	srl a
	srl a
	and $03
	ld c, a
	ld b, $00
;=@y
	ld hl, BoomerangDiagonalSpeedY - 1
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

.done
;> return
	ret


;@ path: link/items
;@ Start position of a projectile of Link's, by his direction (right, left, up, down): x offset.
ProjectileStartDX::
	db $00, $00, $00, $00

;@ path: link/items
;@ Start position of a projectile, by direction: y offset.
ProjectileStartDY::
	db $00, $00, $00, $00

;@ path: link/items
;@ Start speed of a projectile, by direction: x speed (signed).
ProjectileSpeedX::
	db $20, $e0, $00, $00

;@ path: link/items
;@ Start speed of a projectile, by direction: y speed (signed).
ProjectileSpeedY::
	db $00, $00, $e0, $20
;@ path: link/items
;@ Arrow x speed, by direction; entries 4-7 with a Piece of Power (faster).
ArrowSpeedX::
	db $30, $d0, $00, $00, $40, $c0, $00, $00

;@ path: link/items
;@ Arrow y speed, by direction; entries 4-7 with a Piece of Power.
ArrowSpeedY::
	db $00, $00, $d0, $30, $00, $00, $c0, $40

;@ def UseBow()
;@ path: link/items
;@ Shoots an arrow (entity type 0) if the bow is ready, fewer than 2 projectiles are out and
;@ Link has arrows (otherwise the "can't" buzz). Link turns to the held direction first. A bomb
;@ laid within the last 6 frames is taken along: the bomb vanishes and the arrow becomes a bomb
;@ arrow (state 1). Ends in SetArrowSpeed.
;@ test: skip spawns an entity
UseBow::
;> if wArrowCooldown:
	ld a, [wArrowCooldown]
	and a
;>     return
	ret nz

;> if wActiveProjectileCount >= 2:
	ld a, [wActiveProjectileCount]
	cp $02
;>     return
	jr nc, jr_000_10ea

;> wArrowCooldown = 0x10
	ld a, $10
	ld [wArrowCooldown], a
;> if wArrowCount == 0:
	ld a, [wArrowCount]
	and a
;>     return PlayNoAmmoSound()
	jp z, PlayNoAmmoSound

;> wArrowCount = to_bcd(bcd_to_int(wArrowCount) - 1)
	sub $01
	daa
	ld [wArrowCount], a
;> SetLinkDirectionFromDpad()
	call SetLinkDirectionFromDpad
;> slot = SpawnLinkProjectile(0x00)
	ld a, $00
	call SpawnLinkProjectile
;> if slot is None: return                  # carry: no free entity slot
	ret c

;> wBombArrowArrowSlot = slot
	ld a, e
	ld [$c1c2], a
;>@w if wBombArrowWindow:                     # a bomb was just laid: make a bomb arrow
	ld a, [wBombArrowWindow]
	and a
	jr z, .plainArrow

;>     wEntityStatus[wBombArrowBombSlot] = 0       # the bomb goes
	ld a, [$c1c1]
	ld c, a
	ld b, d
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;>     wEntityState[slot] = 1
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
;>     wBombArrowWindow = 0
	xor a
;=@w
	jr .window

;> else:
.plainArrow
;>     hNoiseSfx = 0x0A
	ld a, $0a
	ldh [hNoiseSfx], a
;>     wBombArrowWindow = 6                 # a bomb laid within 6 frames joins this arrow
	ld a, $06

.window
;=@w
	ld [wBombArrowWindow], a
;> return SetArrowSpeed(hLinkDirection, slot)
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00

;@ def SetArrowSpeed(direction: c, slot: de)
;@ path: link/items
;@ Gives the arrow in `slot` its speed for `direction` (ArrowSpeedX/Y), faster with a Piece of
;@ Power. Also used by bank 2.
;@ test: skip
SetArrowSpeed::
;> if wActivePowerUp == 1:
	ld a, [wActivePowerUp]
	cp $01
	jr nz, .speed

;>     direction += 4
	ld a, c
	add $04
	ld c, a

.speed
;> wEntitySpeedX[slot] = ArrowSpeedX[direction]
	ld hl, ArrowSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[slot] = ArrowSpeedY[direction]
	ld hl, ArrowSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

jr_000_10ea:
;> return
	ret


;@ def SpawnLinkProjectile(kind: a) -> de
;@ path: link/items
;@ Spawns entity `kind` as a projectile of Link's (arrow 0, boomerang 1, bomb 2, sword beam $DF,
;@ ...) in front of him: start position, height, speed and direction from his direction
;@ (ProjectileStartDX ...), and Link takes the item-use pose for $0C frames. Returns the slot in
;@ de, carry set when no entity slot was free. Keeps bc.
;@ test: skip spawns an entity
SpawnLinkProjectile::
;> slot = SpawnEntity(kind)                   # spawn the entity; carry = no free slot
	call SpawnEntity
;> if slot is None: return                  # carry: no free entity slot
	ret c

;> wItemUsePoseTimer = 0x0C
	ld a, $0c
	ld [wItemUsePoseTimer], a
;> d = hLinkDirection
	push bc
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00
;>@px wEntityX[slot] = u8(hLinkX + ProjectileStartDX[d])
	ld hl, ProjectileStartDX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
;=@px
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@py wEntityY[slot] = u8(hLinkY + ProjectileStartDY[d])
	ld hl, ProjectileStartDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
;=@py
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityZ[slot] = u8(hLinkPositionZ + 1)
	ldh a, [hLinkPositionZ]
	inc a
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;> wEntitySpeedX[slot] = ProjectileSpeedX[d]
	ld hl, ProjectileSpeedX
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
;> wEntitySpeedY[slot] = ProjectileSpeedY[d]
	ld hl, ProjectileSpeedY
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
;> wEntitySpriteVariant[slot] = d
	ldh a, [hLinkDirection]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
;> wEntityDirection[slot] = d
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
;> mem[0xC5D0 + slot] = d
	ld hl, wEntityLedgeDirection
	add hl, de
	ld [hl], a
;> mem[0xC4F0 + slot] = 1
	ld hl, wEntityLedgeCredit
	add hl, de
	ld [hl], $01
;> return slot                              # carry clear
	pop bc
	scf
	ccf
	ret


;@ path: link/items
;@ Magic powder cloud position by Link's direction (right, left, up, down): x offset.
MagicPowderDX::
	db $0e, $f2, $00, $00

;@ path: link/items
;@ Magic powder cloud position by direction: y offset.
MagicPowderDY::
	db $00, $00, $f4, $0c

;@ def UseMagicPowder()
;@ path: link/items
;@ Item $0C. While Link carries the Sleepy Toadstool instead, he holds it up (pose 2, its text
;@ follows). Otherwise sprinkles a dose of magic powder (entity type 8, square sound 5) in front
;@ of him; when the last dose is used the item leaves its button.
;@ test: skip spawns an entity
UseMagicPowder::
;> if wItemUsePoseTimer:
	ld a, [wItemUsePoseTimer]
	and a
;>     return
	ret nz

;> if wHasToadstool:
	ld a, [wHasToadstool]
	and a
	jr z, .powder

;>     if hLinkPositionZ: return            # not in the air
	ldh a, [hLinkPositionZ]
	and a
	ret nz

;>     wLinkShowItemPose = 2
	ld a, $02
	ld [wLinkShowItemPose], a
;>     wLinkShowItemTimer = 0x2A
	ld a, $2a
	ld [wLinkShowItemTimer], a
;>     return
	ret


.powder
;> if wMagicPowderCount == 0:
	ld a, [wMagicPowderCount]
	and a
;>     return PlayNoAmmoSound()
	jp z, PlayNoAmmoSound

;> slot = SpawnEntity(0x08)                   # the powder cloud
	ld a, $08
	call SpawnEntity
;> if slot is None: return                  # carry: no free entity slot
	ret c

;> hJingle = 0x05
	ld a, $05
	ldh [hJingle], a
;> wItemUsePoseTimer = 0x0E
	ld a, $0e
	ld [wItemUsePoseTimer], a
;> wMagicPowderCount = to_bcd(bcd_to_int(wMagicPowderCount) - 1)
	ld a, [wMagicPowderCount]
	sub $01
	daa
	ld [wMagicPowderCount], a
;> if wMagicPowderCount == 0:               # the last dose: take the item off its buttons
	jr nz, .place

;>     if wItemB == 0x0C: wItemB = 0
	ld hl, wItemB
	ld a, [hl]
	cp $0c
	jr nz, .checkA

	ld [hl], $00

.checkA
;>     if wItemA == 0x0C: wItemA = 0
	inc hl
	ld a, [hl]
	cp $0c
	jr nz, .place

	ld [hl], $00

.place
;> d = hLinkDirection
	push bc
	ldh a, [hLinkDirection]
	ld c, a
;>@mx wEntityX[slot] = u8(hLinkX + MagicPowderDX[d])
	ld hl, MagicPowderDX
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
;=@mx
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>@my wEntityY[slot] = u8(hLinkY + MagicPowderDY[d])
	ld hl, MagicPowderDY
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
;=@my
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;> wEntityTimer[slot] = 0x17
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
	pop bc
	ret


;@ path: link/items
;@ Horizontal speed of a jump started while dashing, by Link's direction (right, left, up, down).
FeatherDashSpeedX::
	db $1c, $e4, $00, $00

;@ path: link/items
;@ Vertical speed of a jump started while dashing, by direction.
FeatherDashSpeedY::
	db $00, $00, $e4, $1c

;@ def UseRocsFeather()
;@ path: link/items
;@ Jumps with Roc's Feather (not in sinking sand, not when already in the air): square sound
;@ $0D, jump animation from the start, StartJump. In side view the jump is a vertical leap
;@ ($EA, or $E8 while moving sideways) handled by bank 2 $6FB1.
;@ test: skip calls other banks
UseRocsFeather::
;> if wLinkGroundVfxPrev == 7:              # sinking sand
	ld a, [wLinkGroundVfxPrev]
	cp $07
;>     return
	ret z

;> if wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
;>     return
	ret nz

;> wIsLinkInTheAir = 1
	ld a, $01
	ld [wIsLinkInTheAir], a
;> wJumpAnimationFrame = 0
	xor a
	ld [wJumpAnimationFrame], a
;> wJumpAnimationCounter = 0
	ld [wJumpAnimationCounter], a
;> hJingle = 0x0D
	ld a, $0d
	ldh [hJingle], a
;> if not hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
;>     return StartJump()
	jr z, StartJump

;> StartJump()
	call StartJump
;> hLinkSpeedY = 0xEA if hJoypadHeld & 3 == 0 else 0xE8
	ldh a, [hJoypadHeld]
	and $03
	ld a, $ea
	jr z, .speed

	ld a, $e8

.speed
	ldh [hLinkSpeedY], a
;> hLinkSpeedZ = 0
	xor a
	ldh [hLinkSpeedZ], a
;> ApplyLinkSpeed()
	call ApplyLinkSpeed
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> SideViewJump()                           # bank 2 $6FB1
	call $6fb1
	ret


;@ def StartJump(b: b)
;@ path: link/items
;@ Starts Link's jump: height speed $20; while dashing also a forward speed (FeatherDashSpeedX/Y).
;@ test: hLinkDirection = rand(0, 3)
StartJump::
;> hLinkSpeedZ = 0x20
	ld a, $20
	ldh [hLinkSpeedZ], a
;> if not wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
;>     return
	ret z

;> d = (b << 8) | hLinkDirection             # b is 0 at the calls
	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
;> hLinkSpeedX = mem[FeatherDashSpeedX + d]
	ld hl, FeatherDashSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = mem[FeatherDashSpeedY + d]
	ld hl, FeatherDashSpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	ret


;@ path: link/sword
;@ Noise sound of a sword swing, one of four picked at random.
SwordSwingNoises::
	db $02, $14, $15, $18

;@ def UseSword()
;@ path: link/sword
;@ Swings the sword (not while a poke or a spin attack runs): swing state 1 for 3 frames, a
;@ random swing noise, Link turns to the held direction and stops (unless jumping). With the
;@ Level-2 sword and wC5A9 set (and none of Link's projectiles out) it also shoots a sword beam
;@ (entity $DF).
;@ test: skip spawns an entity
UseSword::
;> if wSwordPokeTimer or wSpinAttackTimer:
	ld a, [wSwordPokeTimer]
	ld hl, wSpinAttackTimer
	or [hl]
;>     return
	ret nz

;> wSwordStateTimer = 3
	ld a, $03
	ld [wSwordStateTimer], a
;> wSwordAnimationState = 1
	ld a, $01
	ld [wSwordAnimationState], a
;> wSwordCollisionEnabled = 1
	ld [wSwordCollisionEnabled], a
;> mem[0xC160] = 0
	xor a
	ld [$c160], a
;> wSwordDirectionLocked = 0
	ld [wSwordDirectionLocked], a
;>@nz hNoiseSfx = SwordSwingNoises[GetRandomByte() & 3]   # a random swing noise
	call GetRandomByte
	and $03
	ld e, a
	ld d, $00
	ld hl, SwordSwingNoises
	add hl, de
;=@nz
	ld a, [hl]
	ldh [hNoiseSfx], a
;> SetLinkDirectionFromDpad()
	call SetLinkDirectionFromDpad
;> if not wIsLinkInTheAir:
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, .beam

;>     ResetSpinAttackAndDash()
	call ResetSpinAttackAndDash
;>     StopLinkSpeed()
	call StopLinkSpeed

.beam
;>@bm if wActiveProjectileCount or not mem[0xC5A9] or wSwordLevel != 2:
	ld a, [wActiveProjectileCount]
	and a
	ret nz

	ld a, [wHealthIsFull]
	and a
	ret z

;=@bm
	ld a, [wSwordLevel]
	cp $02
;>     return
	ret nz

;> SpawnLinkProjectile(0xDF)                # the sword beam
	ld a, $df
	call SpawnLinkProjectile
;> wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
	ret


;@ def SetLinkDirectionFromDpad()
;@ path: link/movement
;@ Turns Link to the direction of the held d-pad buttons (table in bank 2 at $48B3, one byte per
;@ combination of the four buttons; $0F = no change).
;@ test: skip reads a table in bank 2
SetLinkDirectionFromDpad::
;>@dd d = mem[0x48B3 + (hJoypadHeld & 0x0F)]
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $48b3
	add hl, de
;=@dd
	ld a, [hl]
;> if d != 0x0F:
	cp $0f
	jr z, .done

;>     hLinkDirection = d
	ldh [hLinkDirection], a

.done
;> return
	ret


;@ path: link/sword
;@ Where the sword checks the room for bushes, grass and walls: x offset from hLinkX, one byte
;@ per direction (right, left, up, down), then 8 entries for the frames of the spin attack
;@ (index wSwordSpriteFrame + 4).
SwordProbeDX::
	db $16, $fa, $08, $08, $16, $16, $08, $fa, $fa, $fa, $08, $16

;@ path: link/sword
;@ The same for the y offset from hLinkY.
SwordProbeDY::
	db $08, $08, $fa, $16, $08, $16, $16, $16, $08, $fa, $fa, $fa

;@ def CheckSwordHitsObjectBank2()
;@ path: link/sword
;@ CheckSwordHitsObject for code in bank 2 (switches bank 2 back in afterwards).
;@ test: skip switches ROM banks
CheckSwordHitsObjectBank2::
;> CheckSwordHitsObject()
	call CheckSwordHitsObject
;> return SwitchBank(2)
	ld a, $02
	jp SwitchBank


;@ def CheckSwordHitsObject()
;@ path: link/sword
;@ The sword against the room's objects: looks at the 16x16 square at the sword's tip
;@ (SwordProbeDX/DY). A hard object (collision type 1 or $90 and above) makes a clink
;@ (SwordHitsHardObject). Bushes and grass are cut: indoors only object $DD, on the overworld
;@ $D3 and $5C (and $0A, with a different leaf variant). The object is replaced (RemoveRoomObject),
;@ the cut leaves fly (entity type 5), and one time in 8 a heart or a rupee drops (entity $2D /
;@ $2E; never from object $D3). Not while Link holds the sword out without dashing.
;@ test: skip spawns entities and changes the room
CheckSwordHitsObject::
;> if wLinkJumpSquashTimer:
	ld a, [wLinkJumpSquashTimer]
	and a
;>     return
	ret nz

;> if not wIsUsingPegasusBoots and wSwordAnimationStatePrev == 5:   # sword held out
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .probe

	ld a, [wSwordAnimationStatePrev]
	cp $05
;>     return
	ret z

.probe
;>@i i = wSwordSpriteFrame + 4 if wSpinAttackTimer else hLinkDirection
	ld a, [wSpinAttackTimer]
	and a
	jr z, .notSpinning

;=@i
	ld a, [wSwordSpriteFrame]
	add $04
	jr .index

.notSpinning
	ldh a, [hLinkDirection]

.index
;>@px hBGPosX = (hLinkX + SwordProbeDX[i] - 8) & 0xF0
	ld e, a
	ld d, $00
	ld hl, SwordProbeDX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
;=@px
	sub $08
	and $f0
	ldh [hBGPosX], a
;> column = hBGPosX >> 4
	swap a
	ld c, a
;>@py hBGPosY = (hLinkY + SwordProbeDY[i] - 0x10) & 0xF0
	ld hl, SwordProbeDY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	sub $10
	and $f0
;=@py
	ldh [hBGPosY], a
;> square = hBGPosY | column
	or c
	ld e, a
;> if hi(wRoomObjects + square) != 0xD7:   # outside the room
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
;>     return
	ret nz

;> hRoomObjectType = mem[wRoomObjects + square]
	push de
	ld a, [hl]
	ldh [hRoomObjectType], a
;> collision = GetObjectPhysics(hRoomObjectType, wIsIndoor)   # the object's collision type
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	pop de
;>@hc if collision >= 0x90 or collision == 0x01:
	cp $d0
	jp c, .notD0

	cp $d4
	jp c, SwordHitsHardObject

.notD0
;=@hc
	cp $90
	jp nc, SwordHitsHardObject

	cp $01
;>     return SwordHitsHardObject(collision)
	jp z, SwordHitsHardObject

;> variant = 0
	ld c, $00
;>@cut if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, .overworld

;>     if hRoomObjectType != 0xDD: return
	cp $dd
	jr z, .cut

	ret


.overworld
;>@ow else:
;>     variant = 1
	inc c
;>     if hRoomObjectType in (0xD3, 0x5C):
	cp $d3
	jr z, .cut

	cp $5c
	jr z, .cut

;>         pass
;>     elif hRoomObjectType == 0x0A:
	cp $0a
;>         variant = 0xFF
;>     else:
;>         return
	ret nz

	ld c, $ff

.cut
;> hActiveEntitySpriteVariant = variant
	ld a, c
	ldh [hActiveEntitySpriteVariant], a
;> RemoveRoomObject()                              # replaces the cut object
	call RemoveRoomObject
;>@held if not wIsUsingPegasusBoots and wSwordAnimationStatePrev == 5:
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, .leaves

;=@held
	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, .leaves

;>     wSwordCharge = 0
	xor a
	ld [wSwordCharge], a
;>     wSwordPokeTimer = 0x0C
	ld a, $0c
	ld [wSwordPokeTimer], a

.leaves
;> slot = SpawnLinkProjectile(0x05)          # the flying leaves
	ld a, $05
	call SpawnLinkProjectile
;> if slot is not None:
	jr c, .drop

;>     wItemUsePoseTimer = 0
	xor a
	ld [wItemUsePoseTimer], a
;>     wEntityX[slot] = hBGPosX + 8
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
;>     wEntityY[slot] = hBGPosY + 0x10
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
;>     wEntitySpriteVariant[slot] = hActiveEntitySpriteVariant
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hActiveEntitySpriteVariant]
	ld [hl], a
;>     BreakThrownObjectFar(slot)
	push de
	pop bc
	call BreakThrownObjectFar

.drop
;> if GetRandomByte() & 7:                      # one time in 8 something drops
	call GetRandomByte
	and $07
;>     return
	ret nz

;> if hRoomObjectType == 0xD3:
	ldh a, [hRoomObjectType]
	cp $d3
;>     return
	ret z

;> kind = 0x2D if GetRandomByte() & 1 else 0x2E   # heart or rupee
	call GetRandomByte
	rra
	ld a, $2e
	jr nc, .spawnDrop

	ld a, $2d

.spawnDrop
;> slot = SpawnEntity(kind)
	call SpawnEntity
;> if slot is None: return
	ret c

;> wEntityX[slot] = hBGPosX + 8
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
;> wEntityY[slot] = hBGPosY + 0x10
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
;> wEntityDropTimer[slot] = 0x80
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
;> wEntityTimer1[slot] = 0x18
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $18
;> wEntitySpeedZ[slot] = 0x10              # it hops up
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
	ret


;@ path: link/sword
;@ Where the clink star appears when the sword hits something hard: x offset from hLinkX, by
;@ Link's direction (right, left, up, down).
SwordClinkDX::
	db $12, $ee, $fc, $04

;@ path: link/sword
;@ The same for the y offset from hLinkY.
SwordClinkDY::
	db $04, $04, $ee, $12

;@ def SwordHitsHardObject(collision: a)
;@ path: link/sword
;@ The held-out sword poked something hard (only while wSwordPokeTimer runs): clink star in front
;@ of Link, wClinkTimer, a short lock (wLinkJumpSquashTimer $10) and the clink sound - the
;@ noise $17 for objects of collision type $9x, the square sound 7 otherwise.
;@ test: hLinkDirection = rand(0, 3)
SwordHitsHardObject::
;> if not wSwordPokeTimer:
	ld c, a
	ld a, [wSwordPokeTimer]
	and a
;>     return
	ret z

;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> hMultiPurpose0 = u8(hLinkX + mem[SwordClinkDX + d])
	ld hl, SwordClinkDX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = u8(hLinkY + mem[SwordClinkDY + d])
	ld hl, SwordClinkDY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hMultiPurpose1], a
;> wClinkTimer = 4
	ld a, $04
	ld [wClinkTimer], a
;> AddClinkVfx()
	call AddClinkVfx
;> wLinkJumpSquashTimer = 0x10
	ld a, $10
	ld [wLinkJumpSquashTimer], a
;> if collision & 0xF0 == 0x90:
	ld a, c
	and $f0
	cp $90
	jr z, .noise

;>@n     hNoiseSfx = 0x17
;> else:
;>     hJingle = 0x07
	ld a, $07
	ldh [hJingle], a
	ret


.noise
;=@n
	ld a, $17
	ldh [hNoiseSfx], a
	ret


;@ path: link/pegasus_boots
;@ Dash speed of the Pegasus Boots, by Link's direction (right, left, up, down): x speed.
PegasusDashSpeedX::
	db $20, $e0, $00, $00

;@ path: link/pegasus_boots
;@ Dash speed by direction: y speed.
PegasusDashSpeedY::
	db $00, $00, $e0, $20

;@ def ChargePegasusBoots()
;@ path: link/pegasus_boots
;@ The Pegasus Boots' button is held: Link runs on the spot (faster walk animation, dust) while
;@ the charge fills; after $20 frames the dash starts with the speed for his direction. In side
;@ view only when facing left or right and not on a ladder.
;@ test: hLinkDirection = rand(0, 3)
ChargePegasusBoots::
;>@sv if hIsSideScrolling and (hLinkMotionStep or hLinkDirection & 2):
	ldh a, [hIsSideScrolling]
	and a
	jr z, .charge

;=@sv
	ldh a, [hLinkMotionStep]
	and a
	ret nz

	ldh a, [hLinkDirection]
	and $02
;>     return
	ret nz

.charge
;> if wIsUsingPegasusBoots:
	ld a, [wIsUsingPegasusBoots]
	and a
;>     return
	ret nz

;> if hLinkPositionZ or wIsLinkInTheAir:
	ldh a, [hLinkPositionZ]
	ld hl, wIsLinkInTheAir
	or [hl]
;>     return
	ret nz

;> wLinkWalkingFrameCount = u8(wLinkWalkingFrameCount + 2)
	ld a, [wLinkWalkingFrameCount]
	add $02
	ld [wLinkWalkingFrameCount], a
;> AddDashDustVfx()
	call AddDashDustVfx
;> wPegasusBootsChargeMeter += 1
	ld a, [wPegasusBootsChargeMeter]
	inc a
	ld [wPegasusBootsChargeMeter], a
;> if wPegasusBootsChargeMeter != 0x20:
	cp $20
;>     return
	ret nz

;> wIsUsingPegasusBoots = 0x20              # the dash starts
	ld [wIsUsingPegasusBoots], a
;> wSpinAttackTimer = 0
	xor a
	ld [wSpinAttackTimer], a
;> wSwordCharge = 0
	ld [wSwordCharge], a
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> hLinkSpeedX = PegasusDashSpeedX[d]
	ld hl, PegasusDashSpeedX
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = PegasusDashSpeedY[d]
	ld hl, PegasusDashSpeedY
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
;> wSwordDirectionLocked = 0
	xor a
	ld [wSwordDirectionLocked], a
	ret


;@ def AddDashDustVfx()
;@ path: link/pegasus_boots
;@ Every 8th frame while Link runs on the ground: a dust cloud at his feet (effect $0B, noise 7),
;@ or a splash (effect $0C, square sound $0E) in shallow water.
AddDashDustVfx::
;>@c if hFrameCounter & 7 or hLinkPositionZ or hLinkInteractiveMotionBlocked or wIsLinkInTheAir:
	ldh a, [hFrameCounter]
	and $07
	ld hl, hLinkPositionZ
	or [hl]
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
;=@c
	ld hl, wIsLinkInTheAir
	or [hl]
;>     return
	ret nz

;> hMultiPurpose0 = hLinkX
	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
;> if wLinkGroundType != 5:                 # not shallow water
	ld a, [wLinkGroundType]
	cp $05
	jr z, .splash

;>     hNoiseSfx = 0x07
	ld a, $07
	ldh [hNoiseSfx], a
;>     hMultiPurpose1 = u8(hLinkY + 6)
	ldh a, [hLinkY]
	add $06
	ldh [hMultiPurpose1], a
;>     return AddTransientVfx(0x0B)
	ld a, $0b
	jp AddTransientVfx


.splash
;> else:
;>     hMultiPurpose1 = hLinkY
	ldh a, [hLinkY]
	ldh [hMultiPurpose1], a
;>     hJingle = 0x0E
	ld a, $0e
	ldh [hJingle], a
;>     return AddTransientVfx(0x0C)
	ld a, $0c
	jp AddTransientVfx


;@ def StopLinkSpeed()
;@ path: link/movement
;@ Sets Link's speed to 0.
StopLinkSpeed::
;> hLinkSpeedX = 0
	xor a
	ldh [hLinkSpeedX], a
;> hLinkSpeedY = 0
	ldh [hLinkSpeedY], a
	ret


;@ def UpdateLinkItemSprites()
;@ path: link/sprites
;@ Runs bank 2 $77FA, then draws Link's sword or held item (DrawLinkItemSprites).
;@ test: skip calls bank 2
UpdateLinkItemSprites::
;> Bank02_77FA()
	call $77fa

;@ def DrawLinkItemSprites()
;@ path: link/sprites
;@ Draws what Link holds next to him: while a sword pose is shown (wSwordAnimationStatePrev) the
;@ sword's two sprites go into OAM entries 4-5 (flashing once the spin attack is charged); in the
;@ magic rod pose (wItemUsePoseTimer bit 7) bank 2 draws the rod, and at the right moment of the
;@ pose the rod's fireball (entity 4) is shot. Nothing while Link falls (motion state 1).
;@ test: skip calls bank 2
DrawLinkItemSprites::
;> if wLinkMotionState == 1:
	ld a, [wLinkMotionState]
	cp $01
;>     return
	ret z

;> if wSwordAnimationStatePrev:
	ld a, [wSwordAnimationStatePrev]
	and a
	jr z, .item

;>     oam = wOAMBuffer + 0x10              # OAM entries 4 and 5
	ld bc, wOAMBuffer + $10
;>     hMultiPurpose0 = u8(wLinkDrawY + wLinkSpriteDY)
	ld a, [wLinkDrawY]
	ld hl, wLinkSpriteDY
	add [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = hLinkX
	ldh a, [hLinkX]
	ldh [hMultiPurpose1], a
;>     hMultiPurpose3 = 0                   # attribute bits: palette 0
	ld hl, hMultiPurpose3
	ld [hl], $00
;>     if wSwordCharge >= 0x28:             # charged: the sword flashes
	ld a, [wSwordCharge]
	cp $28
	jr c, .notCharged

;>         hMultiPurpose3 = (hFrameCounter << 2) & 0x10
	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ld [hl], a

.notCharged
;>     offset = (wSwordSpriteDY << 8) | wSwordSpriteDX
	ld a, [wSwordSpriteDY]
	ld h, a
	ld a, [wSwordSpriteDX]
	ld l, a
;>     hMultiPurpose2 = wSwordSpriteFrame
	ld a, [wSwordSpriteFrame]
	ldh [hMultiPurpose2], a
;>     if hLinkY >= 0x88:                   # off the bottom of the play area
	ldh a, [hLinkY]
	cp $88
;>         return
	ret nc

;>     return DrawSpritePair(oam, offset)
	jp DrawSpritePair


.item
;> else:
;>     saved = wItemUsePoseTimer
	ld a, [wItemUsePoseTimer]
	push af
;>     if saved & 0x80:                     # the magic rod is shown
	bit 7, a
	jp z, .restore

;>         SwitchBank(2)
	ld a, $02
	call SwitchBank
;>         DrawMagicRod()                   # bank 2 $514B
	call $514b
;>         if wItemUsePoseTimer & 0x7F == 0x0C and not (wDialogState or wRoomTransitionState):
	ld a, [wItemUsePoseTimer]
	and $7f
	cp $0c
	jr nz, .restore

;=@f
	ld hl, wDialogState
	ld a, [wRoomTransitionState]
	or [hl]
	jr nz, .restore

;>@f             SetLinkDirectionFromDpad()
	call SetLinkDirectionFromDpad
;>             slot = SpawnLinkProjectile(0x04)     # the rod's fireball
	ld a, $04
	call SpawnLinkProjectile
;>             if slot is not None:
	jr c, .restore

;>                 hNoiseSfx = 0x0D
	ld a, $0d
	ldh [hNoiseSfx], a
;>                 SwitchBank(2)
	ld a, $02
	call SwitchBank
;>                 Call_02_51C6()
	call $51c6

.restore
;>     wItemUsePoseTimer = saved
	pop af
	ld [wItemUsePoseTimer], a
	ret


;@ path: link/sword
;@ Tiles of the sword's two sprites for each sword frame (wSwordSpriteFrame), two bytes per
;@ frame (left sprite, right sprite; $FF = that sprite is hidden).
SwordSpriteTiles::
	db $08, $06, $0c, $0a, $ff, $04, $0a, $0c, $06, $08, $0a, $0c, $ff, $04, $0c, $0a
;@ path: link/sword
;@ OAM attributes of the sword's two sprites for each sword frame (bit 5 x flip, bit 6 y flip).
SwordSpriteAttributes::
	db $20, $20, $60, $60, $00, $00, $40, $40, $00, $00, $00, $00, $40, $40, $20, $20

;@ def DrawSpritePair(oam: bc, offset: hl)
;@ path: link/sprites
;@ Writes a pair of side-by-side sprites (16x16, e.g. the sword) into OAM at `oam`: position
;@ (hMultiPurpose1, hMultiPurpose0) plus `offset` (h = y, l = x), frame hMultiPurpose2 from
;@ SwordSpriteTiles / SwordSpriteAttributes, extra attribute bits hMultiPurpose3. A tile $FF
;@ hides the left sprite (x = $F0).
;@ test: hMultiPurpose2 = rand(0, 7)
DrawSpritePair::
;> mem[oam] = u8(hMultiPurpose0 + hi(offset))
	push hl
	ldh a, [hMultiPurpose0]
	add h
	ld [bc], a
	inc bc
;> mem[oam + 1] = u8(hMultiPurpose1 + lo(offset))
	ldh a, [hMultiPurpose1]
	add l
	ld [bc], a
	inc bc
;> f = 2 * hMultiPurpose2
	ld hl, SwordSpriteTiles
	ldh a, [hMultiPurpose2]
	sla a
	ld e, a
	ld d, $00
;> mem[oam + 2] = mem[SwordSpriteTiles + f]
	add hl, de
	ld a, [hl]
	ld [bc], a
;> if mem[SwordSpriteTiles + f] == 0xFF:
	cp $ff
	jr nz, .attr

;>     mem[oam + 1] = 0xF0                  # hidden (off screen to the right)
	dec bc
	ld a, $f0
	ld [bc], a
	inc bc

.attr
;> mem[oam + 3] = mem[SwordSpriteAttributes + f] | hMultiPurpose3
	inc bc
	ld hl, SwordSpriteAttributes
	add hl, de
	ld a, [hl]
	ld hl, hMultiPurpose3
	or [hl]
;=@a
	ld [bc], a
	inc bc
;>@a mem[oam + 4] = u8(hMultiPurpose0 + hi(offset))
	pop hl
	ldh a, [hMultiPurpose0]
	add h
	ld [bc], a
	inc bc
;> mem[oam + 5] = u8(hMultiPurpose1 + lo(offset) + 8)
	ldh a, [hMultiPurpose1]
	add l
	add $08
	ld [bc], a
	inc bc
;> mem[oam + 6] = mem[SwordSpriteTiles + f + 1]
	ld hl, SwordSpriteTiles + 1
	add hl, de
	ld a, [hl]
	ld [bc], a
	inc bc
;>@o7 mem[oam + 7] = mem[SwordSpriteAttributes + f + 1] | hMultiPurpose3
	ld hl, SwordSpriteAttributes + 1
	add hl, de
	ld a, [hl]
	ld hl, hMultiPurpose3
	or [hl]
;=@o7
	ld [bc], a
	ret


;@ path: link/pegasus_boots
;@ Point in front of Link that a dash into a wall shakes (wDashBumpX), by his direction (right,
;@ left, up, down): x offset from hLinkX.
DashBumpDX::
	db $10, $f0, $08, $08

;@ path: link/pegasus_boots
;@ The same for the y offset from hLinkY.
DashBumpDY::
	db $0c, $0c, $f0, $10

;@ def SetDashBumpPoint()
;@ path: link/pegasus_boots
;@ Link dashed into a wall: marks the point in front of him (DashBumpDX/DY) for 2 frames, so the
;@ entities there react (things fall from a tree, ...).
;@ test: hLinkDirection = rand(0, 3)
SetDashBumpPoint::
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> wDashBumpX = u8(hLinkX + mem[DashBumpDX + d])
	ld hl, DashBumpDX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ld [wDashBumpX], a
;> wDashBumpY = u8(hLinkY + mem[DashBumpDY + d])
	ld hl, DashBumpDY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ld [wDashBumpY], a
;> wDashBumpFrames = 2
	ld a, $02
	ld [wDashBumpFrames], a
	ret


;@ def LinkMotionMapFadeOut()
;@ path: world/warps
;@ Motion state 3: the screen fades to white; once the fade is done the warp is taken. All
;@ entities are removed; a shop item carried out without paying makes Link a thief. On the
;@ overworld the warp record whose arrival square matches Link's square is used (4 records of 5
;@ bytes at wWarpType: kind, map, room, x, y). The new place is set up (side view, dungeon map
;@ position, music and power-up reset, the dungeon's name popup) and the world mode restarts at
;@ step 0 to load it. Entering a dungeon saves its entrance as the restart point.
;@ test: skip calls routines in other banks
LinkMotionMapFadeOut::
;> Bank02_780F()                            # Link stands still during the fade
	call $780f
;> if mem[0xC3C9]:                          # the fade was asked to start again
	ld a, [$c3c9]
	and a
	jr z, .fade

;>     mem[0xC3C9] = 0
	xor a
	ld [$c3c9], a
;>     return StartWarpFadeOutWithNoise()
	jp StartWarpFadeOutWithNoise


.fade
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> wBumpShakeTimer = 0
	xor a
	ld [wBumpShakeTimer], a
;> wLinkShowItemPoseActive = 1              # the characters wait
	inc a
	ld [wLinkShowItemPoseActive], a
;> if wTransitionSequenceCounter != 4:      # still fading
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	jp nz, Jump_000_172d

;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> mem[0xFFB4] = 0
	ldh [$ffb4], a
;> fill(wEntityStatus, 0, 16)               # no entities
	ld e, $10
	ld hl, wEntityStatus

.clear
	ld [hli], a
	dec e
	jr nz, .clear

;> if mem[0xC509]:                          # a shop item carried out without paying
	ld a, [$c509]
	and a
	jr z, .notThief

;>     SwitchBank(4)
	push af
	ld a, $04
	call SwitchBank
	pop af
;>     ShopGiveItem(mem[0xC509])
	call $79fa
;>     wIsThief += 1
	ld hl, wIsThief
	inc [hl]
;>     mem[0xDB46] += 1
	ld hl, wShopPunishThief
	inc [hl]
;>     mem[0xD47E] = 1                      # the "thief" text follows the fade-in
	ld a, $01
	ld [$d47e], a
;>     hLinkAnimationState = 0
	xor a
	ldh [hLinkAnimationState], a

.notThief
;> hMultiPurposeD = hIsSideScrolling        # where Link comes from
	ldh a, [hIsSideScrolling]
	ldh [hMultiPurposeD], a
;> wGameplayType = 0x0B
	ld a, $0b
	ld [wGameplayType], a
;> wGameplaySubtype = 0                     # the world mode loads the new place
	xor a
	ld [wGameplaySubtype], a
;> mem[0xC3CB] = 0
	ld [wRoomHasTorches], a
;> hIsSideScrolling = 0
	ldh [hIsSideScrolling], a
;> record = wWarpType
	ld hl, wWarpType
;> hMultiPurposeF = wIsIndoor
	ld a, [wIsIndoor]
	ldh [hMultiPurposeF], a
;> if not wIsIndoor:                        # overworld: the warp of the square Link stands on
	and a
	jr nz, .record

;>     c = 0
	ld hl, wWarpDestPosition
	ld c, $00

.findWarp
;>@fw     while c != 4 and mem[addr(wWarpDestPosition) + c] != (((hLinkY - 8) & 0xF0) | (hLinkX >> 4)):
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
	ldh a, [hLinkY]
	sub $08
;=@fw
	and $f0
	or e
	cp [hl]
	jr z, .found

;>         c += 1
	inc hl
	inc c
;=@fw
	ld a, c
	cp $04
	jr nz, .findWarp

.found
;>@rc     record = wWarpType + 5 * c
	ld a, c
	sla a
	sla a
	add c
	ld e, a
	ld d, $00
;=@rc
	ld hl, wWarpType
	add hl, de

.record
;> wIsIndoor = mem[record]
	push hl
	ld a, [hli]
	ld [wIsIndoor], a
;> if wIsIndoor == 2:                       # a side-view place
	cp $02
	jr nz, .map

;>     hIsSideScrolling = 2
	ldh [hIsSideScrolling], a
;>     wIsIndoor = 1
	dec a
	ld [wIsIndoor], a
;>     hLinkMotionStep = 1
	ld a, $01
	ldh [hLinkMotionStep], a

.map
;> hMapId = mem[record + 1]
	ld a, [hli]
	ldh [hMapId], a
;> hMapRoom = mem[record + 2]
	ld a, [wIsIndoor]
	and a
	ld a, [hli]
	ldh [hMapRoom], a
;>@io if not wIsIndoor:                       # to the overworld
	jr nz, .indoor

;>     if hMultiPurposeF: wActivePowerUp = 0   # left an indoor place
	ldh a, [hMultiPurposeF]
	and a
	jr z, .owDone

	xor a
	ld [wActivePowerUp], a

.owDone
;=@io
	jr .entrance

;> else:
.indoor
;>     SwitchBank(0x14)
	ld c, a
	ld a, $14
	call SwitchBank
;>@grid     grid = 0x4200 + 64 * hMapId         # bank $14: the map's 8x8 grid of rooms
	push hl
	ldh a, [hMapId]
	swap a
	ld e, a
	ld d, $00
	sla e
;=@grid
	rl d
	sla e
	rl d
	ld hl, $4200
	add hl, de
;>     if hMapId == 6 and wDungeon7Flags & 4:   # the other layout of map 6
	ldh a, [hMapId]
	cp $06
	jr nz, .search

	ld a, [wDungeon7Flags]
	and $04
	jr z, .search

;>         grid = 0x44C0
	ld hl, $44c0

.search
;>     cell = 0
	ld e, $00

.cell
;>@cl     while cell != 0x40 and mem[grid + cell] != hMapRoom:
	ld a, [hli]
	cp c
	jr z, .cellFound

;>         cell += 1
	inc e
;=@cl
	ld a, e
	cp $40
	jr nz, .cell

.cellFound
;>     wIndoorRoom = cell
	ld a, e
	ld [wIndoorRoom], a
;>     if not hMultiPurposeF:               # came in from the overworld
	ldh a, [hMultiPurposeF]
	and a
	jr nz, .indoorDone

;>         wActivePowerUp = 0
	xor a
	ld [wActivePowerUp], a
;>         if hMapId < 0x0A:                # a dungeon
	ldh a, [hMapId]
	cp $0a
	jr nc, .indoorDone

;>             SwitchBank(2)
	ld a, $02
	call SwitchBank
;>             LoadDungeonMinimap()
	call $6a9b
;>             mem[0xFFB4] = 0x30           # the dungeon's name shows after a moment
	ld a, $30
	ldh [$ffb4], a
;>             wRaisedBlocksState = 0
	xor a
	ld [wRaisedBlocksState], a
;>             wRaisedBlockStep = 0
	ld [wRaisedBlockStep], a

.indoorDone
	pop hl

.entrance
;> wMapEntrancePositionX = mem[record + 3]
	ld a, [hli]
	ld [wMapEntrancePositionX], a
;> wMapEntrancePositionY = mem[record + 4]
	ld a, [hl]
	ld [wMapEntrancePositionY], a
	pop hl
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
;>     hLinkDirection = 0
;>     return
	jr nz, jr_000_172e

;> if hMultiPurposeD:                       # came from a side-view place
	ldh a, [hMultiPurposeD]
	and a
;>     return
	jr nz, Jump_000_172d

;> if not wIsIndoor or hMapId >= 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, SetSpawnPoint

	ldh a, [hMapId]
	cp $0a
;>     return SetSpawnPoint(record)
	jr nc, SetSpawnPoint

;>@en entry = 0x53E5 + 5 * hMapId              # a dungeon: its entrance (bank $14 table)
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
;=@en
	ld hl, $53e5
	add hl, de
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> SetSpawnPoint(entry)
	call SetSpawnPoint
;>@sr wSpawnIndoorRoom = mem[0x5412 + hMapId]  # the entrance's cell in the dungeon grid
	push de
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, $5412
	add hl, de
;=@sr
	ld a, [hl]
	pop de
	ld [de], a
;> return
	ret


;@ def SetSpawnPoint(record: hl)
;@ path: save/spawn
;@ Saves a restart point: the 5 bytes of `record` (kind, map, room, x, y) to wSpawnIsIndoor...
;@ wSpawnY, and wIndoorRoom to wSpawnIndoorRoom. Returns with de pointing at wSpawnIndoorRoom.
;@ test: skip
SetSpawnPoint::
;> hMultiPurpose0 = 0
	ld a, $00
	ldh [hMultiPurpose0], a
	ld de, wSpawnIsIndoor

.copy
;>@c while hMultiPurpose0 != 5:
;>     mem[addr(wSpawnIsIndoor) + hMultiPurpose0] = mem[record + hMultiPurpose0]
	ld a, [hli]
	ld [de], a
	inc de
;>     hMultiPurpose0 += 1
	ldh a, [hMultiPurpose0]
	inc a
	ldh [hMultiPurpose0], a
;=@c
	cp $05
	jr nz, .copy

;> wSpawnIndoorRoom = wIndoorRoom
	ld a, [wIndoorRoom]
	ld [de], a

Jump_000_172d:
;> return
	ret


jr_000_172e:
	xor a
	ldh [hLinkDirection], a
	ret


;@ def LinkMotionMapFadeIn()
;@ path: world/warps
;@ Motion state 4: the new place fades in from white (or, after a warp that asked for it, the
;@ wave effect type 3 plays instead). When done Link gets his motion state back (1 if it was
;@ saved as 1, otherwise 0), and a thief gets told off (dialogue $36).
;@ test: skip calls routines in other banks
LinkMotionMapFadeIn::
;> Bank02_780F()
	call $780f
;>@w if mem[0xD474]:                          # arrive with the wave effect
	ld a, [$d474]
	and a
	jr z, .fadeIn

;>     mem[0xD474] = 0
	xor a
	ld [$d474], a
;>     wTransitionGfxFrameCount = 0x30
	ld a, $30
	ld [wTransitionGfxFrameCount], a
;>     wTransitionGfx = 3
	ld a, $03
	ld [wTransitionGfx], a
;>     wTransitionSequenceCounter = 4
	ld a, $04
	ld [wTransitionSequenceCounter], a
;=@w
	jr .done

;> else:
.fadeIn
;>     FadePalettesIn()
	call FadePalettesIn
;>     if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>         return
	jr nz, .ret

.done
;> wLinkMotionState = 1 if wSavedLinkMotionState == 1 else 0
	ld a, [wSavedLinkMotionState]
	cp $01
	jr z, .setState

	ld a, $00

.setState
	ld [wLinkMotionState], a
;> if mem[0xD47E]:
	ld a, [$d47e]
	and a
	jr z, .ret

;>     mem[0xD47E] = 0
	xor a
	ld [$d47e], a
;>     OpenDialog(0x36)
	ld a, $36
	call OpenDialog

.ret
;> return
	ret


;@ def FadePalettesToWhite()
;@ path: gfx/palettes
;@ One step of the fade to white, every 4th frame until wTransitionSequenceCounter reaches 4:
;@ every colour of the three palettes (wBGPalette, wOBJ0Palette, wOBJ1Palette) gets one shade
;@ lighter.
FadePalettesToWhite::
;> wTransitionFrameCounter = u8(wTransitionFrameCounter + 1)
	ld hl, wTransitionFrameCounter
	inc [hl]
;> if wTransitionFrameCounter & 3 or wTransitionSequenceCounter == 4:
	ld a, [wTransitionFrameCounter]
	and $03
	jr nz, .done

	ld hl, wTransitionSequenceCounter
	ld a, [hl]
	cp $04
;>     return
	jr z, .done

;> wTransitionSequenceCounter += 1
	inc [hl]
;> hMultiPurpose0 = 0
	xor a
	ldh [hMultiPurpose0], a

.palette
;>@p while hMultiPurpose0 != 3:              # the three palettes
	ldh a, [hMultiPurpose0]
	cp $03
	jr z, .done

;>     pal = mem[addr(wBGPalette) + hMultiPurpose0]
	ld hl, wBGPalette
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
;>@i     for i in range(4):                   # the four colours
	ld c, a
	ld b, $00

.colour
;>         if pal & 3: pal -= 1             # one shade lighter
	ld a, c
	and $03
	jr z, .rotate

	dec c

.rotate
;>         pal = (pal >> 2) | ((pal & 3) << 6)
	rrc c
	rrc c
;=@i
	inc b
	ld a, b
	cp $04
	jr nz, .colour

;>     mem[addr(wBGPalette) + hMultiPurpose0] = pal
	ld a, c
	ld [hl], a
;>     hMultiPurpose0 += 1
	ld hl, hMultiPurpose0
	inc [hl]
;=@p
	jr .palette

.done
;> return
	ret


;@ path: gfx/palettes
;@ Colours the fade-in of FadePalettesIn ends at, 4 per palette (colour 0-3, each a shade 0-3):
;@ BG 0,1,2,3 ($E4), OBJ0 0,3,1,0 ($1C), OBJ1 0,1,2,3 ($E4).
PaletteFadeTargets::
	db $00, $01, $02, $03, $00, $03, $01, $00, $00, $01, $02, $03

;@ def FadePalettesIn()
;@ path: gfx/palettes
;@ One step of the fade in from white, every 4th frame until wTransitionSequenceCounter reaches
;@ 4: each colour of the three palettes gets one shade darker until it reaches its value in
;@ PaletteFadeTargets.
FadePalettesIn::
;> wTransitionFrameCounter = u8(wTransitionFrameCounter + 1)
	ld hl, wTransitionFrameCounter
	inc [hl]
;> if wTransitionFrameCounter & 3:
	ld a, [wTransitionFrameCounter]
	and $03
;>     return
	jr nz, .done

;> step = wTransitionSequenceCounter
	ld hl, wTransitionSequenceCounter
	ld a, [hl]
;> wTransitionSequenceCounter = u8(step + 1)
	inc [hl]
;> if step == 4:
	cp $04
;>     return
	jr z, FadePalettesToWhite.done

;> hMultiPurpose0 = 0
	xor a
	ldh [hMultiPurpose0], a

.palette
;>@p while hMultiPurpose0 != 3:
	ldh a, [hMultiPurpose0]
	cp $03
	jr z, .done

;>     pal = mem[addr(wBGPalette) + hMultiPurpose0]
	ld hl, wBGPalette
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
;>@i     for i in range(4):
	push hl
	ld c, a
	ld b, $00

.colour
;>@t         if pal & 3 != mem[PaletteFadeTargets + 4 * hMultiPurpose0 + i]: pal += 1
	ldh a, [hMultiPurpose0]
	sla a
	sla a
	or b
	ld e, a
	ld hl, PaletteFadeTargets
;=@t
	add hl, de
	ld a, c
	and $03
	cp [hl]
	jr z, .rotate

	inc c

.rotate
;>         pal = (pal >> 2) | ((pal & 3) << 6)
	rrc c
	rrc c
;=@i
	inc b
	ld a, b
	cp $04
	jr nz, .colour

;>     mem[addr(wBGPalette) + hMultiPurpose0] = pal
	ld a, c
	pop hl
	ld [hl], a
;>     hMultiPurpose0 += 1
	ld hl, hMultiPurpose0
	inc [hl]
;=@p
	jr .palette

.done
;> return
	ret


;@ path: link/animation
;@ Link's poses (hLinkAnimationState, 119 of them): two tile numbers per pose, for the left and
;@ the right 8x16 half of his 16x16 sprite. UpdateLinkTiles copies the two tiles from bank $0C
;@ $5800 + 16 * tile into sprite tiles 0-3. The pose tables in bank 2 (UpdateLinkAnimationState)
;@ pick the pose; LinkPoseAttributes gives the flip bits.
LinkPoseTiles::
	db $00, $02, $02, $00, $10, $02, $12, $00, $04, $06, $06, $04, $08, $0a, $0c, $0e
	db $18, $0a, $1c, $0e, $0a, $08, $0e, $0c, $0a, $18, $0e, $1c, $20, $22, $24, $26
	db $28, $2a, $2a, $28, $30, $32, $20, $22, $34, $36, $24, $26, $38, $3a, $28, $2a
	db $3a, $38, $2a, $28, $40, $40, $42, $42, $44, $46, $48, $4a, $4c, $4e, $50, $52
	db $4e, $4c, $52, $50, $80, $02, $82, $00, $84, $86, $88, $8a, $8c, $8e, $90, $92
	db $94, $96, $98, $9a, $9c, $9e, $9a, $a2, $a4, $08, $a6, $0c, $a8, $aa, $ac, $ae
	db $b0, $b2, $b4, $b6, $b0, $b2, $b4, $b6, $04, $c0, $06, $c2, $5a, $58, $5e, $5c
	db $58, $5a, $5c, $5e, $44, $46, $6e, $6e, $40, $40, $56, $56, $7a, $78, $7e, $7c
	db $78, $7a, $7c, $7e, $74, $76, $76, $74, $70, $72, $72, $70, $ca, $c8, $d6, $d4
	db $c8, $ca, $d4, $d6, $cc, $ce, $d8, $da, $c4, $c4, $c6, $c6, $dc, $dc, $de, $de
	db $ea, $ec, $ee, $f0, $f2, $f4, $f6, $f6, $f8, $fa, $e0, $e2, $e4, $e6, $e8, $e8
	db $10, $12, $14, $16, $18, $1c, $12, $10, $16, $14, $1c, $18, $66, $68, $6a, $6c
	db $68, $66, $68, $66, $6c, $6a, $66, $68, $60, $60, $62, $62, $64, $64, $62, $62
	db $64, $64, $60, $60, $54, $54, $3c, $3e, $fe, $fe, $18, $1a, $1c, $1e, $2c, $2e
	db $b8, $ba, $2e, $2c, $ba, $b8, $bc, $be, $d0, $d2, $a0, $fc, $fc, $a0

;@ path: link/animation
;@ OAM attribute bits of the two halves of each of Link's poses, two bytes per pose (same index
;@ as LinkPoseTiles): $20 = x flip, $40 = y flip, $60 = both. Bits 5-6 of wLinkOAMAttrLeft/Right.
LinkPoseAttributes::
	db $00, $00
	db $20, $20, $00, $00, $00, $20, $00, $00, $20, $20, $00, $00, $00, $00, $00, $00
	db $00, $00, $20, $20, $20, $20, $20, $20, $20, $20, $00, $00, $00, $00, $00, $00
	db $20, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20
	db $20, $20, $00, $20, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20
	db $20, $20, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $20, $00, $00, $20, $00, $20, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $00, $20, $00, $20, $00, $20, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $20, $20, $00, $00, $20, $20, $20, $20, $20, $20, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $20, $00, $20, $00, $20, $00, $20, $00, $00
	db $00, $00, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00
	db $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $00, $00, $00, $00, $60, $60
	db $20, $20, $20, $20, $40, $40, $00, $20, $00, $20, $00, $20, $40, $60, $40, $60
	db $40, $60, $00, $20, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00
	db $20, $20, $20, $20, $00, $00, $00, $00, $00, $00, $20, $20

;@ def UpdateLinkAnimationState()
;@ path: link/animation
;@ Picks Link's pose (hLinkAnimationState) from a table in bank 2 chosen by what he does -
;@ normal walking ($48BE), with the shield ($48C6, $48D6 with the mirror shield; +8 while it is
;@ raised), pushing ($48E6), carrying ($48EE), motion state 1 ($48F6 / $48FE) and climbing a
;@ ladder in side view ($4906) - indexed by 2 * direction + the walk frame (bit 3 of
;@ wLinkWalkingFrameCount). Runs with bank 2 switched in (UpdateLinkAnimationStateFar).
;@ test: skip reads tables in bank 2
UpdateLinkAnimationState::
;> frame = (wLinkWalkingFrameCount >> 3) & 1
	ld a, [wLinkWalkingFrameCount]
	sra a
	sra a
	sra a
	and $01
	ld d, a
;> i = 2 * hLinkDirection + frame
	ldh a, [hLinkDirection]
	sla a
	or d
	ld c, a
	ld b, $00
;> table = 0x48F6
	ld hl, $48f6
;> if wLinkMotionState == 1:
	ld a, [wLinkMotionState]
	cp $01
	jr nz, .notState1

;>     if hLinkMotionStep: table = 0x48FE
	ldh a, [hLinkMotionStep]
	and a
	jr z, .state1Done

	ld hl, $48fe

.state1Done
;=@t
	jr .pose

.notState1
;>@t elif hIsSideScrolling and hLinkMotionStep == 2:   # on a ladder
	ldh a, [hIsSideScrolling]
	and a
	jr z, .notLadder

	ldh a, [hLinkMotionStep]
	cp $02
	jr nz, .notLadder

;>     table = 0x4906
	ld hl, $4906
;=@t
	jr .pose

.notLadder
;>@t elif wIsCarryingLiftedObject == 1:
	ld a, [wIsCarryingLiftedObject]
	cp $01
	jr z, .carrying

;>@cp     table = 0x48EE
;> elif not hLinkInWater and wLinkPushingTimer:
	ldh a, [hLinkInWater]
	and a
	jr nz, .shield

	ld a, [wLinkPushingTimer]
	and a
	jr nz, .pushing

;>@pu     table = 0x48E6
;> elif not wShieldLevelEquipped:
.shield
	ld a, [wShieldLevelEquipped]
	and a
	jr nz, .withShield

;>     table = 0x48BE
	ld hl, $48be
;=@t
	jr .pose

;> else:
.withShield
;>     table = 0x48D6 if wShieldLevelEquipped == 2 else 0x48C6
	ld hl, $48c6
	cp $02
	jr nz, .raised

	ld hl, $48d6

.raised
;>@r     if wIsUsingShield: table += 8        # the shield is raised
	ld a, [wIsUsingShield]
	and a
	jr z, .shieldDone

;=@r
	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a

.shieldDone
;=@t
	jr .pose

.pushing
;=@pu
	ld hl, $48e6
	jr .pose

.carrying
;=@cp
	ld hl, $48ee

.pose
;> hLinkAnimationState = mem[table + i]
	add hl, bc
	ld a, [hl]
	ldh [hLinkAnimationState], a
	ret


;@ def AnimateMarinBeachTiles()
;@ path: gfx/animation
;@ Animated tiles of game mode 9 (the beach scene): on frames 0 and 8 of every 16 copies 64
;@ bytes of the waves from bank $10 ($6500 / $6540, one of 4 frames picked by bits 4-5 of the
;@ frame counter) to $9500 / $9540. Not while background draw commands are queued.
;@ test: skip switches ROM banks and writes VRAM
AnimateMarinBeachTiles::
;> if wDrawCommand[0]:
	ld a, [wDrawCommand]
	and a
;>     return
	ret nz

;> set_rom_bank(0x10)
	ld a, $10
	ld [$2100], a
;> src = 0x6500
	ld hl, $6500
;> dest = 0x9500
	ld de, $9500
;> f = hFrameCounter & 0x0F
	ldh a, [hFrameCounter]
	and $0f
;> if f == 0:                               # the first half of the tiles
;>     pass
	jr z, .copy

;> elif f != 8:
	cp $08
;>     return
	ret nz

;> else:                                    # the second half
;>     src = 0x6540
	ld l, $40
;>     dest = 0x9540
	ld e, l

.copy
;>@h src += (hFrameCounter & 0x30) << 3     # the animation frame
	ldh a, [hFrameCounter]
	and $30
	ld c, a
	ld b, $00
	sla c
	rl b
;=@h
	sla c
	rl b
	sla c
	rl b
	add hl, bc
;> copy(dest, src, 0x40)
	ld bc, $0040
	jp CopyData


;@ path: unused/data
;@ Eight bytes nothing reads ($20, $60, $A0, $E0, $E0, $E0, $A0, $60: a ping-pong sequence like
;@ AnimatedTilesPhases).
Unused1AA1::
	db $20, $60, $a0, $e0, $e0, $e0, $a0, $60

;@ def UpdateAnimatedTiles()
;@ path: gfx/animation
;@ The VBlank's regular graphics job. The beach scene and the intro have their own tile
;@ animations. In the world (mode $0B, window hidden): a requested background change
;@ (hBGChangeRequest) is done, else the raised blocks step on, else the room's animated tiles
;@ (hAnimatedTilesGroup) advance. Ends with Link's sprite tiles and OAM entries.
;@ test: skip switches ROM banks and writes VRAM
UpdateAnimatedTiles::
;> if wGameplayType == 0x09:
	ld a, [wGameplayType]
	cp $09
;>     return AnimateMarinBeachTiles()
	jr z, AnimateMarinBeachTiles

;> if wGameplayType == 0x00:                # the intro
	cp $00
	jr nz, .notIntro

;>     if wDrawCommand[0] or hFrameCounter & 0x0F < 4:
	ld a, [wDrawCommand]
	and a
	jp nz, .ret

	ldh a, [hFrameCounter]
	and $0f
	cp $04
;>         return
	jr c, .ret

;>     set_rom_bank(0x10)
	ld a, $10
	ld [$2100], a
;>@ic     copy(mem16[addr(wSceneTimer3)], mem16[addr(wSceneTimer)], 0x20)   # the intro keeps source and target at $D006 / $D008
	ld a, [wSceneTimer]
	ld l, a
	ld a, [wSceneTimer + 1]
	ld h, a
	ld a, [wSceneTimer3]
	ld e, a
;=@ic
	ld a, [wSceneTimer3 + 1]
	ld d, a
	ld bc, $0020
	call CopyData

.ret
;>     return
	ret


.notIntro
;> if wGameplayType == 0x01:                # the ending: only background changes
	ld a, [wGameplayType]
	cp $01
	jr nz, .world

;>     if not hBGChangeRequest: return
	ldh a, [hBGChangeRequest]
	and a
	jr nz, .bgChange

	ret


.world
;> elif wGameplayType < 0x0B or wWindowY != 0x80:
	cp $0b
	jp c, Jump_000_1d14

	ld a, [wWindowY]
	cp $80
;>     return
	jp nz, Jump_000_1d14

;> elif wInventoryAppearing or wDrawCommand[0] or wRoomTransitionState:
	ld a, [wInventoryAppearing]
	and a
	jp nz, DrawLinkOAM

	ld hl, wRoomTransitionState
	ld a, [wDrawCommand]
	or [hl]
;>     return DrawLinkOAM()
	jp nz, DrawLinkOAM

;> elif wRaisedBlockStep:
	ld a, [wRaisedBlockStep]
	and a
	jr z, .noBlocks

;>     UpdateRaisedBlocks(wRaisedBlockStep)
	call UpdateRaisedBlocks
;>     return DrawLinkOAM()
	jp DrawLinkOAM


.noBlocks
;> elif not hBGChangeRequest:
	ldh a, [hBGChangeRequest]
	and a
	jr z, .animate

;>@an     hAnimatedTilesFrameCount += 1
;>@an2     return RunAnimatedTiles()
;> # a background change (hBGChangeRequest 1-$10)
.bgChange
;> if hBGChangeRequest == 0x01: return LoadBGChangeTilesA()
	cp $01
	jp z, LoadBGChangeTilesA

;> if hBGChangeRequest == 0x02: return LoadBGChangeTilesB()
	cp $02
	jp z, LoadBGChangeTilesB

;> if hBGChangeRequest == 0x03: return BGChangeTiles9140A()
	cp $03
	jp z, BGChangeTiles9140A

;> if hBGChangeRequest == 0x04: return BGChangeTiles9140B()
	cp $04
	jp z, BGChangeTiles9140B

;> if hBGChangeRequest == 0x08: return BGChangeTilesBank13()
	cp $08
	jp z, BGChangeTilesBank13

;> if hBGChangeRequest == 0x09: return BGChangeTiles8CA0()
	cp $09
	jp z, BGChangeTiles8CA0

;> if hBGChangeRequest == 0x0A: return BGChangeTiles88E0Alt()
	cp $0a
	jp z, BGChangeTiles88E0Alt

;> if hBGChangeRequest == 0x0B: return BGChangeTiles88E0()
	cp $0b
	jp z, BGChangeTiles88E0

;> if hBGChangeRequest == 0x0C: return BGChangeTilesBank11()
	cp $0c
	jp z, BGChangeTilesBank11

;> if hBGChangeRequest == 0x0D: return BGChangeTradeItemTiles()
	cp $0d
	jp z, BGChangeTradeItemTiles

;> if hBGChangeRequest == 0x0E:
	cp $0e
	jr z, .bank17

;>@e17     set_rom_bank(0x17)
;>@e17b     return Bank17_4060()
;> if hBGChangeRequest == 0x0F: return BGChangeEntityTilesB()
	cp $0f
	jp z, BGChangeEntityTilesB

;> if hBGChangeRequest == 0x10: return BGChangeEntityTilesA()
	cp $10
	jp z, BGChangeEntityTilesA

;> return DrawLinkOAM()
	jp DrawLinkOAM


.bank17
;=@e17
	ld a, $17
	ld [$2100], a
;=@e17b
	jp $4060


.animate
;=@an
	ldh a, [hAnimatedTilesFrameCount]
	inc a
	ldh [hAnimatedTilesFrameCount], a
;=@an2

;@ def RunAnimatedTiles()
;@ path: gfx/animation
;@ Runs the animated-tiles routine of the room's group (hAnimatedTilesGroup).
;@ test: skip writes VRAM
RunAnimatedTiles::
;> return AnimatedTilesHandlers[hAnimatedTilesGroup]()
	ldh a, [hAnimatedTilesGroup]
	rst $00

;@ path: gfx/animation
;@ Animated-tiles routine of each room group (hAnimatedTilesGroup 0-$10). Most copy one 64-byte
;@ frame (4 tiles) from bank $0C to tiles $6C-$6F ($96C0): from page $6A-$77 (the group's own
;@ page, 4 frames at offset hAnimatedTilesStep) every 4, 8 or 16 frames, or a ping-pong of
;@ frames (AnimatedTilesPhases). Group 0 has no animated tiles; group 1 runs bank 1 $5F62;
;@ group 7 also copies tiles from the RAM buffer at $DCC0 to $90C0. All end in UpdateLinkTiles.
AnimatedTilesHandlers::
	dw UpdateLinkTiles
	dw AnimateTilesGroup1
	dw AnimateTilesGroup2
	dw AnimateTilesGroup3
	dw AnimateTilesGroup4
	dw AnimateTilesGroup5
	dw AnimateTilesGroup6
	dw AnimateTilesGroup7
	dw AnimateTilesGroup8
	dw AnimateTilesGroup9
	dw AnimateTilesGroupA
	dw AnimateTilesGroupB
	dw AnimateTilesGroupC
	dw AnimateTilesGroupD
	dw AnimateTilesGroupE
	dw AnimateTilesGroupF
	dw AnimateTilesGroup10

;@ def AnimateTilesGroup1()
;@ path: gfx/animation
;@ Animated tiles group 1: every 8 frames bank 1 $5F62 does the animation.
;@ test: skip calls bank 1
AnimateTilesGroup1::
;> if hAnimatedTilesFrameCount & 7:
	ldh a, [hAnimatedTilesFrameCount]
	and $07
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;> set_rom_bank(1)
	ld a, $01
	ld [$2100], a
;> Call_01_5F62()
	call $5f62
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> return DrawLinkOAM()
	jp DrawLinkOAM


Jump_000_1ba7:
	ld l, a
	jr jr_000_1be5

;@ def AnimateTilesGroup2()
;@ path: gfx/animation
;@ Animated tiles group 2: page $6B, a new frame every 16 frames.
;@ test: skip writes VRAM
AnimateTilesGroup2::
;> page = 0x6B
	ld h, $6b
;> return AnimateTilesEvery16(page)
	jr AnimateTilesEvery16

;@ def AnimateTilesGroup3()
;@ path: gfx/animation
;@ Animated tiles group 3: page $6C every 16 frames.
;@ test: skip writes VRAM
AnimateTilesGroup3::
;> page = 0x6C
	ld h, $6c
;> return AnimateTilesEvery16(page)
	jr AnimateTilesEvery16

;@ def AnimateTilesGroupC()
;@ path: gfx/animation
;@ Animated tiles group $0C: page $73 every 16 frames.
;@ test: skip writes VRAM
AnimateTilesGroupC::
;> page = 0x73
	ld h, $73
;> return AnimateTilesEvery16(page)
	jr AnimateTilesEvery16

;@ def AnimateTilesGroupB()
;@ path: gfx/animation
;@ Animated tiles group $0B: page $6A every 16 frames. Its end (AnimateTilesEvery16) is shared by the
;@ groups that change every 16 frames: on a new frame it steps hAnimatedTilesStep by $40 and
;@ copies 64 bytes from page:hAnimatedTilesStep (Jump_000_1ba7) to $96C0.
;@ test: skip writes VRAM
AnimateTilesGroupB::
;> page = 0x6A
	ld h, $6a

AnimateTilesEvery16:
;> if hAnimatedTilesFrameCount & 0x0F:
	ldh a, [hAnimatedTilesFrameCount]
	and $0f
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;> step = NextAnimatedTilesStep()
	call NextAnimatedTilesStep
;> copy(0x96C0, (page << 8) | step, 0x40)
;> return DrawLinkOAM()
	jp Jump_000_1ba7


;@ path: gfx/animation
;@ Ping-pong frame order of the animated tiles (offsets of the 4 frames in a page: 0, 1, 2, 3,
;@ 3, 3, 2, 1), indexed by bits 3-5 of hAnimatedTilesFrameCount.
AnimatedTilesPhases::
	db $00, $40, $80, $c0, $c0, $c0, $80, $40

;@ def AnimateTilesGroup4()
;@ path: gfx/animation
;@ Animated tiles group 4: page $6D, every 8 frames the next frame of the ping-pong order
;@ (AnimatedTilesPhases). The copy to $96C0 at its end is shared by the other groups.
;@ test: skip writes VRAM
AnimateTilesGroup4::
;> if hAnimatedTilesFrameCount & 7:
	ldh a, [hAnimatedTilesFrameCount]
	and $07
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;>@s src = 0x6D00 | AnimatedTilesPhases[(hAnimatedTilesFrameCount >> 3) & 7]
	ldh a, [hAnimatedTilesFrameCount]
	rra
	rra
	rra
	and $07
	ld e, a
;=@s
	ld d, $00
	ld hl, AnimatedTilesPhases
	add hl, de
	ld l, [hl]
	ld h, $6d

jr_000_1be5:
;> dest = 0x96C0
	ld de, $96c0

jr_000_1be8:
;> copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;> return DrawLinkOAM()
	jp DrawLinkOAM


;@ def AnimateTilesGroup5()
;@ path: gfx/animation
;@ Animated tiles group 5: page $6E every 16 frames.
;@ test: skip writes VRAM
AnimateTilesGroup5::
;> page = 0x6E
	ld h, $6e
;> return AnimateTilesEvery16(page)
	jr AnimateTilesEvery16

;@ def AnimateTilesGroup6()
;@ path: gfx/animation
;@ Animated tiles group 6: page $6F, ping-pong order every 8 frames.
;@ test: skip writes VRAM
AnimateTilesGroup6::
;> if hAnimatedTilesFrameCount & 7:
	ldh a, [hAnimatedTilesFrameCount]
	and $07
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;>@s src = 0x6F00 | AnimatedTilesPhases[(hAnimatedTilesFrameCount >> 3) & 7]
	ldh a, [hAnimatedTilesFrameCount]
	rra
	rra
	rra
	and $07
	ld e, a
;=@s
	ld d, $00
	ld hl, AnimatedTilesPhases
	add hl, de
	ld l, [hl]
	ld h, $6f
;> copy(0x96C0, src, 0x40)                 # the end of AnimateTilesGroup4
;> return DrawLinkOAM()
	jp jr_000_1be5


;@ def AnimateTilesGroup7()
;@ path: gfx/animation
;@ Animated tiles group 7: like group 4, but on every 4th frame (when the next frame count is a
;@ multiple of 4) it copies 4 tiles from the RAM buffer at $DCC0 to $90C0 instead.
;@ test: skip writes VRAM
AnimateTilesGroup7::
;> if (hAnimatedTilesFrameCount + 1) & 3:
	ldh a, [hAnimatedTilesFrameCount]
	inc a
	and $03
;>     return AnimateTilesGroup4()
	jp nz, AnimateTilesGroup4

;> copy(0x90C0, 0xDCC0, 0x40)
	ld hl, $dcc0
	ld de, $90c0
;> return DrawLinkOAM()
	jp jr_000_1be8


;@ def AnimateTilesGroup8()
;@ path: gfx/animation
;@ Animated tiles group 8: page $70, a new frame every 8 frames. Its end (AnimateTilesEvery8) is shared
;@ by the groups that change every 8 frames.
;@ test: skip writes VRAM
AnimateTilesGroup8::
;> page = 0x70
	ld h, $70

AnimateTilesEvery8:
;> if hAnimatedTilesFrameCount & 7:
	ldh a, [hAnimatedTilesFrameCount]
	and $07
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;> step = NextAnimatedTilesStep()
	call NextAnimatedTilesStep
;> copy(0x96C0, (page << 8) | step, 0x40)
;> return DrawLinkOAM()
	jp Jump_000_1ba7


;@ def AnimateTilesGroup9()
;@ path: gfx/animation
;@ Animated tiles group 9: page $71, a new frame every 4 frames. Its end (AnimateTilesEvery4) is shared
;@ by the groups that change every 4 frames.
;@ test: skip writes VRAM
AnimateTilesGroup9::
;> page = 0x71
	ld h, $71

AnimateTilesEvery4:
;> if hAnimatedTilesFrameCount & 3:
	ldh a, [hAnimatedTilesFrameCount]
	and $03
;>     return UpdateLinkTiles()
	jp nz, UpdateLinkTiles

;> step = NextAnimatedTilesStep()
	call NextAnimatedTilesStep
;> copy(0x96C0, (page << 8) | step, 0x40)
;> return DrawLinkOAM()
	jp Jump_000_1ba7


;@ def AnimateTilesGroupA()
;@ path: gfx/animation
;@ Animated tiles group $0A: page $72 every 4 frames.
;@ test: skip writes VRAM
AnimateTilesGroupA::
;> page = 0x72
	ld h, $72
;> return AnimateTilesEvery4(page)
	jr AnimateTilesEvery4

;@ def NextAnimatedTilesStep() -> a
;@ path: gfx/animation
;@ Steps hAnimatedTilesStep to the next of the 4 frames of a page ($40 bytes each) and returns it.
NextAnimatedTilesStep::
;> hAnimatedTilesStep = u8(hAnimatedTilesStep + 0x40)
	ldh a, [hAnimatedTilesStep]
	add $40
	ldh [hAnimatedTilesStep], a
;> return hAnimatedTilesStep
	ret


;@ def AnimateTilesGroupD()
;@ path: gfx/animation
;@ Animated tiles group $0D: page $75 every 4 frames.
;@ test: skip writes VRAM
AnimateTilesGroupD::
;> page = 0x75
	ld h, $75
;> return AnimateTilesEvery4(page)
	jr AnimateTilesEvery4

;@ def AnimateTilesGroupF()
;@ path: gfx/animation
;@ Animated tiles group $0F: page $74 every 8 frames.
;@ test: skip writes VRAM
AnimateTilesGroupF::
;> page = 0x74
	ld h, $74
;> return AnimateTilesEvery8(page)
	jr AnimateTilesEvery8

;@ def AnimateTilesGroup10()
;@ path: gfx/animation
;@ Animated tiles group $10: page $77 every 8 frames.
;@ test: skip writes VRAM
AnimateTilesGroup10::
;> page = 0x77
	ld h, $77
;> return AnimateTilesEvery8(page)
	jr AnimateTilesEvery8

;@ def AnimateTilesGroupE()
;@ path: gfx/animation
;@ Animated tiles group $0E: page $76 every 8 frames.
;@ test: skip writes VRAM
AnimateTilesGroupE::
;> page = 0x76
	ld h, $76
;> return AnimateTilesEvery8(page)
	jr AnimateTilesEvery8

;@ def UpdateLinkTiles()
;@ path: link/sprites
;@ Copies the two tiles of Link's current pose to sprite tiles 0-3 ($8000-$803F): tile numbers
;@ from LinkPoseTiles (two per pose, the tiles are at bank $0C $5800 + 16 * tile), and his
;@ sprites' flip bits (bits 5-6) from LinkPoseAttributes into wLinkOAMAttrLeft/Right. Then
;@ DrawLinkOAM puts Link's sprites in OAM. Nothing when Link is not drawn (pose $FF).
;@ test: skip writes VRAM
UpdateLinkTiles::
;> if hLinkAnimationState == 0xFF:
	ldh a, [hLinkAnimationState]
	cp $ff
;>     return DrawLinkOAM()
	jp z, DrawLinkOAM

;> i = 2 * hLinkAnimationState
	ld hl, LinkPoseTiles
	sla a
	ld c, a
	ld b, $00
;> left = LinkPoseTiles[i]
	add hl, bc
	ld e, [hl]
	push hl
;>@al wLinkOAMAttrLeft = (wLinkOAMAttrLeft & 0x9F) | LinkPoseAttributes[i]
	ld hl, LinkPoseAttributes
	add hl, bc
	ld a, [wLinkOAMAttrLeft]
	and $9f
	or [hl]
;=@al
	ld [wLinkOAMAttrLeft], a
;> wLinkOAMAttrRight =(wLinkOAMAttrRight & 0x9F) | LinkPoseAttributes[i + 1]
	inc hl
	ld a, [wLinkOAMAttrRight]
	and $9f
	or [hl]
	ld [wLinkOAMAttrRight], a
;>@cl copy(0x8000, 0x5800 + 16 * left, 0x20)  # the pose's left half (two 8x8 tiles)
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
;=@cl
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
;=@cl
	pop bc
	ld hl, $8000
	ld d, $20

.copyLeft
;=@cl
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, .copyLeft

;> right = LinkPoseTiles[i + 1]
	pop hl
	inc hl
	ld e, [hl]
;>@cr copy(0x8020, 0x5800 + 16 * right, 0x20)  # the right half
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
;=@cr
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
;=@cr
	pop bc
	ld hl, $8020
	ld d, $20

.copyRight
;=@cr
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, .copyRight

;> return DrawLinkOAM()

;@ def DrawLinkOAM()
;@ path: link/sprites
;@ Puts Link's two 8x16 sprites in OAM entries 2-3 at his drawing position (with the sprite
;@ offsets), tiles 0 and 2, attributes wLinkOAMAttrLeft/Right; while invincible the palette bit
;@ blinks. Not when Link is hidden (pose $FF) or below the play area.
DrawLinkOAM::
;> if hLinkAnimationState == 0xFF:
	ldh a, [hLinkAnimationState]
	inc a
;>     return
	jr z, Jump_000_1d14

;> wLinkFlashAttr = (wInvincibilityCounter << 2) & 0x10   # palette 1 on alternate 4-frame phases
	ld a, [wInvincibilityCounter]
	rla
	rla
	and $10
	ld [wLinkFlashAttr], a
;> y = u8(wLinkSpriteDY + wLinkDrawY)
	ld hl, wOAMBuffer + $08
	ld a, [wLinkSpriteDY]
	ld c, a
	ld a, [wLinkDrawY]
	add c
;> if y >= 0x88:
	cp $88
;>     return
	jr nc, Jump_000_1d14

;> wOAMBuffer[8] = y
	push af
	ld [hli], a
;> x = u8(hLinkX + wLinkSpriteDX)
	ld a, [wLinkSpriteDX]
	ld c, a
	ldh a, [hLinkX]
	add c
;> wOAMBuffer[9] = x
	ld [hli], a
;> wOAMBuffer[10] = 0x00
	ld a, $00
	ld [hli], a
;> wOAMBuffer[11] = wLinkOAMAttrLeft | wLinkFlashAttr
	ld a, [wLinkFlashAttr]
	ld d, a
	ld a, [wLinkOAMAttrLeft]
	or d
	ld [hli], a
;> wOAMBuffer[12] = y
	pop af
	ld [hli], a
;> wOAMBuffer[13] = u8(x + 8)
	ldh a, [hLinkX]
	add c
	add $08
	ld [hli], a
;> wOAMBuffer[14] = 0x02
	ld a, $02
	ld [hli], a
;> wOAMBuffer[15] = wLinkOAMAttrRight | wLinkFlashAttr
	ld a, [wLinkFlashAttr]
	ld d, a
	ld a, [wLinkOAMAttrRight]
	or d
	ld [hli], a

Jump_000_1d14:
;> return
	ret


;@ def BGChangeEntityTilesA()
;@ path: gfx/tiles
;@ Background change $10: 4 tiles from bank $0E $4F00 into the first entity tile slot ($8400).
;@ test: skip switches ROM banks and writes VRAM
BGChangeEntityTilesA::
;> src = 0x4F00
	ld hl, $4f00
;> bank = 0x0E
	ld a, $0e
;> set_rom_bank(bank)                       # (the end of BGChangeEntityTilesB)
;> return CopyBGChangeTiles(src, 0x8400, 0x40)
	jr jr_000_1d21

;@ def BGChangeEntityTilesB()
;@ path: gfx/tiles
;@ Background change $0F: 4 tiles from bank $12 $6080 into the first entity tile slot ($8400).
;@ BGChangeEntityTilesA shares its end.
;@ test: skip switches ROM banks and writes VRAM
BGChangeEntityTilesB::
;> bank = 0x12
	ld a, $12
;> src = 0x6080
	ld hl, $6080

jr_000_1d21:
;> set_rom_bank(bank)
	ld [$2100], a
;> return CopyBGChangeTiles(src, 0x8400, 0x40)
	ld de, $8400
	ld bc, $0040
	jp CopyBGChangeTiles


;@ def BGChangeTradeItemTiles()
;@ path: gfx/tiles
;@ Background change $0D: the tiles of the current trading item (wTradeSequenceItem 2 and up,
;@ 64 bytes each from bank $0C $4400 + (item - 2) * $40) into tiles $9A-$9D ($89A0).
;@ test: skip switches ROM banks and writes VRAM
BGChangeTradeItemTiles::
;> if wTradeSequenceItem < 2:
	ld a, [wTradeSequenceItem]
	cp $02
;>     return FinishBGChange()
	jp c, FinishBGChange

;>@s src = 0x4400 + (wTradeSequenceItem - 2) * 0x40
	sub $02
	ld d, a
	ld e, $00
	sra d
	rr e
	sra d
;=@s
	rr e
	ld hl, $4400
	add hl, de
;> set_rom_bank(0x0C)
	ld de, $89a0
	ld bc, $0040
	ld a, $0c
	ld [$2100], a
;> return CopyBGChangeTiles(src, 0x89A0, 0x40)
	jp CopyBGChangeTiles


;@ def BGChangeTiles88E0Alt()
;@ path: gfx/tiles
;@ Background change $0A: 2 tiles from bank $0C $68C0 to tiles $8E-$8F ($88E0).
;@ test: skip switches ROM banks and writes VRAM
BGChangeTiles88E0Alt::
;> src = 0x68C0
	ld hl, $68c0
;> dest = 0x88E0
	ld de, $88e0
;> return BGChangeTiles8CA0.copy2(src, dest)   # (shared end of BGChangeTiles8CA0)
	jr jr_000_1dc4

;@ def BGChangeTilesBank11()
;@ path: gfx/tiles
;@ Background change $0C: 4 tiles from bank $11 ($5000 + $40 * the low nibble of $D000) to the
;@ same place in tiles $D0-$FF ($8D00 + ...). Ends without updating Link's sprite.
;@ test: skip switches ROM banks and writes VRAM
BGChangeTilesBank11::
;> set_rom_bank(0x11)
	ld a, $11
	ld [$2100], a
;>@o offset = (wEntityWorkRAM & 0x0F) * 0x40
	ld a, [wEntityWorkRAM]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
;=@o
	rl d
	sla e
	rl d
;> dest = 0x8D00 + offset
	ld hl, $8d00
	add hl, de
	push hl
;> src = 0x5000 + offset
	ld hl, $5000

jr_000_1d7b:
	add hl, de
	pop de
;> copy(dest, src, 0x40)
	ld bc, $0040
	call CopyData
;> hBGChangeRequest = 0
	xor a
	ldh [hBGChangeRequest], a
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
	ret


;@ def BGChangeTilesBank13()
;@ path: gfx/tiles
;@ Background change 8: like BGChangeTilesBank11 with bank $13 $4D00.
;@ test: skip switches ROM banks and writes VRAM
BGChangeTilesBank13::
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;>@o offset = (wEntityWorkRAM & 0x0F) * 0x40
	ld a, [wEntityWorkRAM]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
;=@o
	rl d
	sla e
	rl d
;> dest = 0x8D00 + offset
	ld hl, $8d00
	add hl, de
	push hl
;> copy(dest, 0x4D00 + offset, 0x40)       # the end of BGChangeTilesBank11
	ld hl, $4d00
	jr jr_000_1d7b

;@ def BGChangeTiles88E0()
;@ path: gfx/tiles
;@ Background change $0B: 2 tiles from bank $0C $48E0 to tiles $8E-$8F ($88E0).
;@ test: skip switches ROM banks and writes VRAM
BGChangeTiles88E0::
;> set_rom_bank(0x0C)
	ld hl, $48e0
	ld de, $88e0
	ld a, $0c
	ld [$2100], a
;> return CopyBGChangeTiles(0x48E0, 0x88E0, 0x20)
	ld bc, $0020
	jp CopyBGChangeTiles


;@ def BGChangeTiles8CA0()
;@ path: gfx/tiles
;@ Background change 9: 2 tiles from bank $0C $68E0 to tiles $CA-$CB ($8CA0). Its end (bank $0C,
;@ 32 bytes) is shared with BGChangeTiles88E0Alt.
;@ test: skip switches ROM banks and writes VRAM
BGChangeTiles8CA0::
;> src = 0x68E0
	ld hl, $68e0
;> dest = 0x8CA0
	ld de, $8ca0

jr_000_1dc4:
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> return CopyBGChangeTiles(src, dest, 0x20)
	ld bc, $0020
	jp CopyBGChangeTiles


;@ def BGChangeTiles9140A()
;@ path: gfx/tiles
;@ Background change 3: 4 tiles from bank $12 $7F00 to background tiles $14-$17 ($9140).
;@ test: skip switches ROM banks and writes VRAM
BGChangeTiles9140A::
;> src = 0x7F00
	ld hl, $7f00
;> bank = 0x12
	ld a, $12
;> set_rom_bank(bank)                       # (the end of BGChangeTiles9140B)
;> return CopyBGChangeTiles64(src, 0x9140)
	jr jr_000_1ddb

;@ def BGChangeTiles9140B()
;@ path: gfx/tiles
;@ Background change 4: 4 tiles from bank $0D $4C40 to $9140 (BGChangeTiles9140A shares its end).
;@ test: skip switches ROM banks and writes VRAM
BGChangeTiles9140B::
;> src = 0x4C40
	ld hl, $4c40
;> bank = 0x0D
	ld a, $0d

jr_000_1ddb:
;> set_rom_bank(bank)
	ld [$2100], a
;> return CopyBGChangeTiles64(src, 0x9140)
	ld de, $9140
	jp CopyBGChangeTiles64


;@ path: object/raised_blocks
;@ Bank $0C sources of the raised-block tiles (64 bytes each), read with wRaisedBlocksState (0 or
;@ 2) as byte offset: entries 0-1 at step 4 and 6, entries 2-3 at step 8 and $0A.
RaisedBlockTilePointers::
	dw $6840, $6840, $6800, $6880, $6800

;@ def UpdateRaisedBlocks(step: a)
;@ path: object/raised_blocks
;@ One frame of the raised / lowered blocks changing over (after a crystal switch): the step
;@ counts up; at step 3 the raised set flips (wRaisedBlocksState ^= 2); at steps 4 and 8 the
;@ tiles at $9040, at steps 6 and $0A those at $9080 are swapped (RaisedBlockTilePointers); after
;@ $0A it is over. Link cannot walk meanwhile. Other steps only update Link's sprite.
;@ test: skip writes VRAM
UpdateRaisedBlocks::
;> set_rom_bank(0x0C)
	ld hl, $2100
	ld [hl], $0c
;> hLinkInteractiveMotionBlocked = 1
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
;> variant = wRaisedBlocksState
	ld hl, wRaisedBlocksState
	ld e, [hl]
	ld d, $00
;> step += 1
	inc a
;> if step == 3:
	cp $03
	jr nz, .store

;>     wRaisedBlocksState ^= 2
	push af
	ld a, [wRaisedBlocksState]
	xor $02
	ld [wRaisedBlocksState], a
	pop af

.store
;> wRaisedBlockStep = step
	ld [wRaisedBlockStep], a
;> if step == 4:
	cp $04
	jr nz, .not4

;>     src = mem16[RaisedBlockTilePointers + variant]
	ld hl, RaisedBlockTilePointers
;>     dest = 0x9040                        # (shared with step 8)
	jr .at9040

.not4
;> elif step == 8:
	cp $08
	jr nz, .not8

;>     src = mem16[RaisedBlockTilePointers + 4 + variant]
	ld hl, RaisedBlockTilePointers + 4

.at9040
;>     dest = 0x9040
	add hl, de
	ld de, $9040
	jr .copy

.not8
;> elif step == 6:
	cp $06
	jr nz, .notA6

;>     src = mem16[RaisedBlockTilePointers + variant]
	ld hl, RaisedBlockTilePointers
;>     dest = 0x9080                        # (shared with step $0A)
	jr .at9080

.notA6
;> elif step == 0x0A:                       # the last step
	cp $0a
	jr nz, .noCopy

;>     wRaisedBlockStep = 0
	xor a
	ld [wRaisedBlockStep], a
;>     src = mem16[RaisedBlockTilePointers + 6 + variant]
	ld hl, RaisedBlockTilePointers + 6

.at9080
;>     dest = 0x9080
	add hl, de
	ld de, $9080
;> else:
;>@nc     return DrawLinkOAM()

.copy
;> copy(dest, src, 0x40)
	ld bc, $0040
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp CopyData

.noCopy
;=@nc
	jp DrawLinkOAM


;@ def CopyBGChangeTiles64(src: hl, dest: de)
;@ path: gfx/tiles
;@ CopyBGChangeTiles with 64 bytes.
;@ test: skip writes VRAM
CopyBGChangeTiles64::
;> count = 0x40
	ld bc, $0040

;@ def CopyBGChangeTiles(src: hl, dest: de, count: bc)
;@ path: gfx/tiles
;@ Copies the tiles of a background change, then finishes it (FinishBGChange).
;@ test: skip writes VRAM
CopyBGChangeTiles::
;> copy(dest, src, count)
	call CopyData

;@ def FinishBGChange()
;@ path: gfx/tiles
;@ Clears hBGChangeRequest, switches bank $0C back in and updates Link's sprite (DrawLinkOAM).
;@ test: skip switches ROM banks
FinishBGChange::
;> hBGChangeRequest = 0
	xor a
	ldh [hBGChangeRequest], a
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> return DrawLinkOAM()
	jp DrawLinkOAM


;@ path: link/lift
;@ Where Link looks for something to lift, read or open, by his direction (right, left, up,
;@ down): x offset from hLinkX.
LiftProbeDX::
	db $0c, $03, $08, $08

;@ path: link/lift
;@ The same for the y offset from hLinkY.
LiftProbeDY::
	db $0a, $0a, $05, $10

;@ path: link/lift
;@ Link's pose while pulling with the Power Bracelet, by direction (the next pose number is the
;@ second frame).
LiftPullPoses::
	db $36, $38, $3a, $3c

;@ path: link/lift
;@ The d-pad button that pulls (the opposite of Link's direction: left, right, down, up), by
;@ direction.
LiftPullButtons::
	db $02, $01, $08, $04
;@ path: link/lift
;@ Link's sprite x offset while he pulls, by direction.
LiftPullSpriteDX::
	db $fc, $04, $00, $00

;@ path: link/lift
;@ Link's sprite y offset while he pulls, by direction.
LiftPullSpriteDY::
	db $00, $00, $04, $00

;@ def CheckLiftAndReadBank2()
;@ path: link/lift
;@ CheckLiftAndRead for code in bank 2 (switches bank 2 back in).
;@ test: skip switches ROM banks
CheckLiftAndReadBank2::
;> CheckLiftAndRead()
	call CheckLiftAndRead
;> return SwitchBank(2)
	ld a, $02
	jp SwitchBank


;@ def CheckLiftAndRead()
;@ path: link/lift
;@ Link's actions on the square in front of him (LiftProbeDX/DY), when he stands on the ground
;@ and carries nothing. Facing up, A or B reads a sign or other readable object (texts per room
;@ from bank $14 $55FF), or opens a chest (object $A0; its content from bank $14 $4500, opened
;@ by bank 2 $41BA). With the Power Bracelet's button held he pulls at the object: after 8 frames
;@ (3 with a Piece of Power) of pulling against the opposite direction he lifts it (pots $8E,
;@ $20 and, on the overworld, rocks $5C) - LiftRoomObject.
;@ test: skip calls routines in other banks
CheckLiftAndRead::
;>@b if wIsCarryingLiftedObject or wIsUsingPegasusBoots or hLinkPositionZ or wLinkMotionState:
	ld hl, wIsUsingPegasusBoots
	ld a, [wIsCarryingLiftedObject]
	or [hl]
	ld hl, hLinkPositionZ
	or [hl]
	ld hl, wLinkMotionState
;=@b
	or [hl]
;>     return
	jp nz, Jump_000_20a5

;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;>@px hBGPosX = (hLinkX + LiftProbeDX[d] - 8) & 0xF0
	ld hl, LiftProbeDX
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	sub $08
	and $f0
;=@px
	ldh [hBGPosX], a
;> c = hBGPosX >> 4
	swap a
	ld c, a
;>@py hBGPosY = (hLinkY + LiftProbeDY[d] - 0x10) & 0xF0
	ld hl, LiftProbeDY
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	sub $10
	and $f0
;=@py
	ldh [hBGPosY], a
;> square = hBGPosY | c
	or c
	ld e, a
;> hMultiPurpose1 = square
	ldh [hMultiPurpose1], a
;> if hi(wRoomObjects + square) != 0xD7:   # outside the room
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
;>     return ResetLiftPull()
	jp nz, ResetLiftPull

;> hMultiPurpose0 = mem[wRoomObjects + square]   # the object there
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose5 = GetObjectPhysics(hMultiPurpose0, wIsIndoor)
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	ldh [hMultiPurpose5], a
;> obj = hMultiPurpose0
;> if obj != 0x9A:
	ldh a, [hMultiPurpose0]
	cp $9a
	jr z, jr_000_1f10

;>@ph     if hMultiPurpose5 in (0x00, 0x50, 0x51) or not (hMultiPurpose5 == 1 or 0x11 <= hMultiPurpose5 < 0x7C or 0xD0 <= hMultiPurpose5 < 0xD4):
	ldh a, [hMultiPurpose5]
	cp $00
	jp z, ResetLiftPull

	cp $01
	jr z, jr_000_1ef8

;=@ph
	cp $50
	jp z, ResetLiftPull

	cp $51
	jp z, ResetLiftPull

	cp $11
	jp c, ResetLiftPull

;=@ph
	cp $d4
	jp nc, ResetLiftPull

	cp $d0
	jr nc, jr_000_1ef8

	cp $7c
;>         return ResetLiftPull()           # nothing to do with it
	jp nc, ResetLiftPull

jr_000_1ef8:
;>@rd if obj == 0x9A or (obj in (0x6F, 0x5E, 0xD4) and not wIsIndoor):   # readable: signs and tablets outdoors
	ldh a, [hMultiPurpose0]
	ld e, a
	cp $6f
	jr z, jr_000_1f08

	cp $5e
	jr z, jr_000_1f08

;=@rd
	cp $d4
	jp nz, Jump_000_1fa1

jr_000_1f08:
;=@rd
	ld a, [wIsIndoor]
	and a
	ld a, e
	jp nz, Jump_000_1fa1

jr_000_1f10:
;>     if hLinkDirection == 2:              # facing up
	ld e, a
	ldh a, [hLinkDirection]
	cp $02
	jp nz, Jump_000_1ffd

;>         wCanTalkToEntity = 2
	ld a, $02
	ld [wCanTalkToEntity], a
;>         if hJoypadPressed & 0x30:        # A or B
	ldh a, [hJoypadPressed]
	and $30
	jp z, Jump_000_1ffd

;>             if obj == 0x5E:
	ld a, e
	cp $5e
;>                 OpenDialogTable1(0x8E)   # (the call at jr_000_1f96)
	ld a, $8e
	jr z, jr_000_1f96

;>             elif obj not in (0x6F, 0xD4):
	ld a, e
	cp $6f
	jr z, jr_000_1f5b

	cp $d4
	jr z, jr_000_1f5b

;>                 if wIsMarinFollowingLink:   # object $9A
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_000_1f42

;>                     OpenDialogTable2(0x78)
	ld a, $78
	call OpenDialogTable2
	jp Jump_000_1ffd


jr_000_1f42:
;>                 else:
;>@tx                     text = 0xFF if (wSwordLevel == 0 and hMapRoom == 0xA3) else 0xFC if hMapRoom == 0xFA else 0xFD
	ld a, [wSwordLevel]
	and a
	ldh a, [hMapRoom]
	jr nz, jr_000_1f50

	ld e, $ff
	cp $a3
;=@tx
	jr z, jr_000_1f58

jr_000_1f50:
;=@tx
	ld e, $fc
	cp $fa
	jr z, jr_000_1f58

	ld e, $fd

jr_000_1f58:
;>@od                     OpenDialog(text)
	ld a, e
	jr jr_000_1f9c

jr_000_1f5b:
;>             else:                        # a sign: its text from the room's entry
;>                 set_rom_bank(0x14)
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld a, $14
	ld [$2100], a
;>                 text = mem[0x55FF + hMapRoom]
	ld hl, $55ff
	add hl, de
	ld a, [wOcarinaSongFlags]
	ld e, a
	ld a, [hl]
;>                 if text == 0xA9 and wOcarinaSongFlags & 1: text = 0xAF
	cp $a9
	jr nz, jr_000_1f78

	bit 0, e
	jr z, jr_000_1f78

	ld a, $af

jr_000_1f78:
;>                 if text == 0xAF and not wOcarinaSongFlags & 1:
	cp $af
	jr nz, jr_000_1f92

	bit 0, e
	jr nz, jr_000_1f92

;>@sp                     wSignpostReadPos = (hBGPosY & 0xF0) | (hBGPosX >> 4)   # where it was read
	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
;=@sp
	or e
	ld [wSignpostReadPos], a
	jp Jump_000_1ffd


jr_000_1f92:
;>                 elif text == 0x83:
	cp $83
;>                     OpenDialog(text)     # (the call at jr_000_1f9c)
	jr z, jr_000_1f9c

;>                 else:
;>                     OpenDialogTable1(text)

jr_000_1f96:
	call OpenDialogTable1
	jp Jump_000_1ffd


jr_000_1f9c:
;=@od
	call OpenDialog
	jr jr_000_1ffd

Jump_000_1fa1:
;> else:                                    # object $A0 is a chest
;>@ch     if obj == 0xA0 and wRoomEvent & 0x1F != 0x0D and hLinkDirection == 2:
	cp $a0
	jr nz, jr_000_1ffd

	ld a, [wRoomEvent]
	and $1f
	cp $0d
	jr z, jr_000_1ffd

;=@ch
	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_000_1ffd

;>         wCanTalkToEntity = 2
	ld [wCanTalkToEntity], a
;>@op         if hJoypadPressed & 0x30 and (hIsSideScrolling or hLinkDirection == 2):
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_000_1ffd

	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_000_1fc8

;=@op
	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_000_1ffd

jr_000_1fc8:
;>             set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;>@pg             page = wIsIndoor + (1 if 0x06 <= hMapId < 0x1A else 0)
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	ldh a, [hMapId]
	cp $1a
;=@pg
	jr nc, jr_000_1fdf

	cp $06
	jr c, jr_000_1fdf

	inc d

jr_000_1fdf:
;>             content = mem[0x4500 + (page << 8) + hMapRoom]   # what the chest holds
	ld hl, $4500
	add hl, de
	ld a, [hl]
;>             if content == 0x20:
	cp $20
	jr nz, jr_000_1ff3

;>                 content = 0x20 if wSwordLevel < 2 else 0x1C
	ld a, [wSwordLevel]
	cp $02
	ld a, $20
	jr c, jr_000_1ff3

	ld a, $1c

jr_000_1ff3:
;>             hMultiPurpose8 = content
	ldh [hMultiPurpose8], a
;>             set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;>             OpenChest()                  # bank 2 $41BA
	call $41ba

Jump_000_1ffd:
jr_000_1ffd:
;> # pulling with the Power Bracelet
;> if wItemB == 3:
	ld a, [wItemB]
	cp $03
	jr nz, jr_000_200b

;>     if not hJoypadHeld & 0x20: return
	ldh a, [hJoypadHeld]
	and $20
	jr nz, jr_000_201a

	ret


jr_000_200b:
;> elif wItemA != 3 or not hJoypadHeld & 0x10:
	ld a, [wItemA]
	cp $03
	jp nz, Jump_000_20a5

	ldh a, [hJoypadHeld]
	and $10
;>     return
	jp z, Jump_000_20a5

jr_000_201a:
;> set_rom_bank(2)
	ld a, $02
	ld [$2100], a
;> Bank02_485E()
	call $485e
;> hLinkInteractiveMotionBlocked = 1
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
;> d = hLinkDirection
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
;> hLinkAnimationState = LiftPullPoses[d]
	ld hl, LiftPullPoses
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;> if not hJoypadHeld & LiftPullButtons[d]:   # not pulling back
	ld hl, LiftPullButtons
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
;>     return ResetLiftPull()
	jr z, jr_000_207c

;> wLinkSpriteDX = LiftPullSpriteDX[d]
	ld hl, LiftPullSpriteDX
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDX], a
;> wLinkSpriteDY = LiftPullSpriteDY[d]
	ld hl, LiftPullSpriteDY
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDY], a
;> hLinkAnimationState += 1                 # the pulling frame
	ld hl, hLinkAnimationState
	inc [hl]
;> needed = 3 if wActivePowerUp == 1 else 8
	ld e, $08
	ld a, [wActivePowerUp]
	cp $01
	jr nz, jr_000_205a

	ld e, $03

jr_000_205a:
;> wLiftPullCounter += 1
	ld hl, wLiftPullCounter
	inc [hl]
;> if wLiftPullCounter < needed:
	ld a, [hl]
	cp e
;>     return
	jr c, jr_000_207b

;> hMultiPurposeE = 0
	xor a
	ldh [hMultiPurposeE], a
;> if obj in (0x8E, 0x20):                  # pots
	ldh a, [hMultiPurpose0]
	cp $8e
	jr z, jr_000_2081

	cp $20
	jr z, jr_000_2081

;>@rk     LiftRoomObject()
;>@rk2     set_rom_bank(0x14)
;>@rk3     Bank14_55AA()
;>@rk4     return RestoreBank()
;> elif not wIsIndoor and obj == 0x5C:      # an overworld rock
	ld a, [wIsIndoor]
	and a
	jr nz, jr_000_207b

	ldh a, [hMultiPurpose0]
	cp $5c
	jr z, jr_000_208f

;>@rk5     hMultiPurposeE = 1; return LiftRoomObject()   # by running on into it

jr_000_207b:
;> return
	ret


ResetLiftPull:
jr_000_207c:
;> # ResetLiftPull:
;> wLiftPullCounter = 0
	xor a
	ld [wLiftPullCounter], a
	ret


jr_000_2081:
;=@rk
	call LiftRoomObject
;=@rk2
	ld a, $14
	ld [$2100], a
;=@rk3
	call $55aa
;=@rk4
	jp RestoreBank


jr_000_208f:
;=@rk5
	ld a, $01
	ldh [hMultiPurposeE], a

;@ def LiftRoomObject()
;@ path: link/lift
;@ Link picks up the room object in front of him (hMultiPurpose0 = its id, hMultiPurpose1 = its place in
;@ wRoomObjects): the object disappears from the room map and comes back as a lifted entity over his head.
LiftRoomObject::
;> pos = hMultiPurpose1                     # where the object is in wRoomObjects
	ldh a, [hMultiPurpose1]
	ld e, a
;> hRoomObjectType = hMultiPurpose0         # which object it is (pot, rock, bush, ...)
	ldh a, [hMultiPurpose0]
	ldh [hRoomObjectType], a
;> RemoveRoomObject(pos)
	call RemoveRoomObject
;> wLiftDirection = hLinkDirection
	ldh a, [hLinkDirection]
	ld [wLiftDirection], a
;> SpawnLiftedObject()
	call SpawnLiftedObject

Jump_000_20a5:
;> return
	ret


;@ def RemoveRoomObject(pos: e)
;@ path: object/lift
;@ Takes the object at `pos` out of the room (the code in bank $14 puts the floor in its place and queues the
;@ redraw of that square), then switches the caller's bank back in.
RemoveRoomObject::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> ReplaceRoomObjectWithFloor(pos)
	call ReplaceRoomObjectWithFloor
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SpawnLiftedObject()
;@ path: link/lift
;@ Creates the entity for an object Link has just lifted (type 5), in the lifted state, with the sprite
;@ variant from hMultiPurposeE (1 = a bush), and lets bank 3 place it over Link's head. Nothing happens when
;@ all entity slots are taken.
SpawnLiftedObject::
;> slot = SpawnLinkProjectile(0x05)                   # a new entity of type 5; carry = no free slot
	ld a, $05
	call SpawnLinkProjectile
;> if slot is None: return
	jr c, .done

;> hWaveSfx = 0x02                          # the lifting sound
	ld a, $02
	ldh [hWaveSfx], a
;> wEntityStatus[slot] = 7                  # lifted: carried by Link
	ld hl, wEntityStatus
	add hl, de
	ld [hl], $07
;> wEntitySpriteVariant[slot] = hMultiPurposeE
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hMultiPurposeE]
	ld [hl], a
;> SwitchBank(3)                            # (bc = the slot, e = 1 for the call below)
	push de
	pop bc
	ld e, $01
	ld a, $03
	call SwitchBank
;> PlaceLiftedEntity(slot, 1)                    # puts it above Link's head, by the way he faces
	call PlaceLiftedEntity

.done
;> return
	ret


;@ def ApplyLinkSpeed()
;@ path: link/movement
;@ Moves Link by his speed on both axes: first y, then x (see ApplyLinkSpeedOnAxis). Nothing moves while the
;@ inventory is coming in or out.
ApplyLinkSpeed::
;> if wInventoryAppearing: return
	ld a, [wInventoryAppearing]
	and a
	ret nz

;> y = ApplyLinkSpeedOnAxis(1)              # vertical
	ld c, $01
	call ApplyLinkSpeedOnAxis
;> ApplyLinkSpeedX(y)                       # runs on into the horizontal move

;@ def ApplyLinkSpeedX(value: a)
;@ path: link/movement
;@ Moves Link horizontally by hLinkSpeedX. Keeps `value` in hMultiPurpose0 for the caller (coming from
;@ ApplyLinkSpeed it is Link's new y position).
ApplyLinkSpeedX::
;> hMultiPurpose0 = value
	ld c, $00
	ldh [hMultiPurpose0], a
;> return ApplyLinkSpeedOnAxis(0)

;@ def ApplyLinkSpeedOnAxis(axis: c) -> a
;@ path: link/movement
;@ Adds Link's speed on one axis (0 = x, 1 = y) to his position. The speed is signed in 1/16 pixels: its low
;@ nibble adds to the fraction byte (wLinkSubpixelX/Y), its high nibble plus the fraction's carry to the
;@ position (hLinkX/Y). Returns the new position.
;@ test: axis = rand(0, 1)
ApplyLinkSpeedOnAxis::
;> speed = mem[addr(hLinkSpeedX) + axis]
	ld b, $00
	ld hl, hLinkSpeedX
	add hl, bc
	ld a, [hl]
	push af
;> frac = mem[addr(wLinkSubpixelX) + axis] + ((speed & 0x0F) << 4)
	swap a
	and $f0
	ld hl, wLinkSubpixelX
	add hl, bc
	add [hl]
;> mem[addr(wLinkSubpixelX) + axis] = u8(frac)  # (the carry out of it is kept)
	ld [hl], a
	rl d
;> pos = addr(hLinkX) + axis
	ld hl, hLinkX
	add hl, bc
	pop af
;>@sg sign = 0xF0 if speed & 0x80 else 0x00   # a negative speed moves back
	ld e, $00
	bit 7, a
	jr z, .positive

;=@sg
	ld e, $f0

.positive
;> mem[pos] = u8(mem[pos] + ((speed >> 4) | sign) + (frac >> 8))
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a
;> return mem[pos]
	ret


;@ def ApplyLinkSpeedZ()
;@ path: link/movement
;@ Adds Link's height speed hLinkSpeedZ (signed, 1/16 pixels) to his height hLinkPositionZ, the same way
;@ ApplyLinkSpeedOnAxis does for x and y, with the fraction in wLinkSubpixelZ.
ApplyLinkSpeedZ::
;> speed = hLinkSpeedZ
	ldh a, [hLinkSpeedZ]
	push af
;> frac = wLinkSubpixelZ + ((speed & 0x0F) << 4)
	swap a
	and $f0
	ld hl, wLinkSubpixelZ
	add [hl]
;> wLinkSubpixelZ = u8(frac)
	ld [hl], a
	rl d
;>@sg sign = 0xF0 if speed & 0x80 else 0x00
	ld hl, hLinkPositionZ
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive

;=@sg
	ld e, $f0

.positive
;> hLinkPositionZ = u8(hLinkPositionZ + ((speed >> 4) | sign) + (frac >> 8))
	swap a
	and $0f
	or e
	rr d
	adc [hl]
	ld [hl], a
;> return
	ret


;@ def UpdateDialog()
;@ path: text/dialog
;@ Runs the dialog box once per frame. wDialogState holds the step in its low 7 bits (0 = no dialog) and in
;@ bit 7 whether the box sits in the lower half of the screen. Before the step runs, the blank tile for this
;@ game mode and the box place of the next character (wDialogCharSlot: 0-$0F first line, $10-$1F second
;@ line; after the first 32 characters every character goes to the second line, as the text scrolls up)
;@ are worked out.
UpdateDialog::
;> state = wDialogState
	ld a, [wDialogState]
	and a
;> if state == 0: return
	ret z

;>@blank hBGTilesRequestCopy = 0x7F if wGameplayType == 1 else 0x7E   # the blank tile of the box
	ld e, a
	ld a, [wGameplayType]
	cp $01
	ld a, $7e
	jr nz, .haveBlank

;=@blank
	ld a, $7f

.haveBlank
;=@blank
	ldh [hBGTilesRequestCopy], a
;> slot = wDialogCharIndex
	ld a, [wDialogCharIndexHigh]
	and a
	ld a, [wDialogCharIndex]
;>@second if wDialogCharIndexHigh or slot >= 0x20:   # past the first two lines: always the second line
	jr nz, .secondLine

	cp $20
	jr c, .haveSlot

.secondLine
;>     slot = (slot & 0x0F) | 0x10
	and $0f
	or $10

.haveSlot
;> wDialogCharSlot = slot
	ld [wDialogCharSlot], a
;> DialogStateHandlers[(state & 0x7F) - 1]()
	ld a, e
	and $7f
	dec a
	rst $00

;@ path: text/dialog
;@ The handlers of the dialog steps 1-$0F (UpdateDialog calls entry step - 1). Steps 2-4, $0A and $0B do their
;@ work in the VBlank handler (saving the background, scrolling) and do nothing here.
DialogStateHandlers::
	dw DialogStateOpenBox
	dw DialogStateWaitVBlank
	dw DialogStateWaitVBlank
	dw DialogStateWaitVBlank
	dw DialogStateClearBox
	dw DialogStateClearCharTile
	dw DialogStatePlaceChar
	dw DialogStateDrawChar
	dw DialogStateBoxFull
	dw DialogStateScroll1
	dw DialogStateScroll2
	dw DialogStateEnd
	dw DialogStateChoice
	dw DialogStateRestoreBox
	dw DialogStateFinish

;@ def DialogStateOpenBox()
;@ path: text/dialog
;@ Dialog step 1: the code in bank $14 starts the box (it does not return here: it ends the step itself).
;@ test: skip jumps into bank $14 code that has no label yet
DialogStateOpenBox::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> pass                                        # the box-opening code at 14:5924
	jp $5924


;@ def OpenDialogTable1(index: a)
;@ path: text/dialog
;@ Opens dialog $100 + index (the second part of the dialog table).
OpenDialogTable1::
;> OpenDialog(index)
	call OpenDialog
;> wDialogIndexHigh = 1
	ld a, $01
	ld [wDialogIndexHigh], a
;> return
	ret


;@ def OpenDialogTable2(index: a)
;@ path: text/dialog
;@ Opens dialog $200 + index (the third part of the dialog table).
OpenDialogTable2::
;> OpenDialog(index)
	call OpenDialog
;> wDialogIndexHigh = 2
	ld a, $02
	ld [wDialogIndexHigh], a
;> return
	ret


;@ def OpenDialog(index: a)
;@ path: text/dialog
;@ Starts dialog number `index` (0-$FF; OpenDialogTable1/2 for the higher ones): resets the text position,
;@ the question answer and the typing sound, and puts the box in the half of the screen Link is not in
;@ (lower half when Link is above y $48).
OpenDialog::
;> wDialogAnswer = 0
	push af
	xor a
	ld [wDialogAnswer], a
	pop af
;> wDialogIndex = index
	ld [wDialogIndex], a
;> wDialogBoxStep = 0
	xor a
	ld [wDialogBoxStep], a
;> wDialogCharIndex = 0
	ld [wDialogCharIndex], a
;> wDialogCharIndexHigh = 0
	ld [wDialogCharIndexHigh], a
;> wDialogNameCharIndex = 0
	ld [wDialogNameCharIndex], a
;> wDialogIndexHigh = 0
	ld [wDialogIndexHigh], a
;> wDialogSfx = 0x0F                        # the normal typing sound
	ld a, $0f
	ld [wDialogSfx], a
;> wDialogState = (0x80 if hLinkY < 0x48 else 0) | 1   # step 1; bit 7 = box at the bottom
	ldh a, [hLinkY]
	cp $48
	rra
	and $80
	or $01
	ld [wDialogState], a
;> return
	ret


;@ def DialogStateWaitVBlank()
;@ path: text/dialog
;@ Dialog steps 2-4, $0A and $0B: nothing to do here, the VBlank handler does these steps.
DialogStateWaitVBlank::
;> return
	ret


;@ def DialogStateFinish()
;@ path: text/dialog
;@ Dialog step $0F, after the box has been taken down: the dialog is over. For $18 frames Link cannot start
;@ another one.
DialogStateFinish::
;> wDialogState = 0
	xor a
	ld [wDialogState], a
;> wDialogCooldown = 0x18
	ld a, $18
	ld [wDialogCooldown], a
;> return
	ret


;@ path: text/dialog
;@ Where SaveDialogBackground copies from and to, for dialog steps 2-4 (box at the top) and 5-7 (bottom):
;@ three tables of 6 bytes, indexed by the step - 2 (+3 for the bottom box). Each step saves two rows of 18
;@ tiles.
;@   +0  6 bytes: offset into wDialogBackground ($00, $24, $48)
;@   +6  6 bytes: high byte of the BG map address, added to wBGOriginHigh ($98 top box, $99 bottom box)
;@   +12 6 bytes: low byte of the BG map address, added to wBGOriginLow (rows 1/3/5 or 10/12/14, column 1)
DialogBackgroundSaveTable::
	db $00, $24, $48, $00, $24, $48, $98, $98, $98, $99, $99, $99, $21, $61, $a1, $41
	db $81, $c1

;@ def SaveDialogBackground()
;@ path: text/dialog
;@ Called by the VBlank handler in dialog steps 2-4: copies two rows of 18 BG map tiles (the place the box
;@ will cover, rows wrap around within the 32-tile BG map) into wDialogBackground, so the box can be taken
;@ down again later.
SaveDialogBackground::
;> i = wDialogState & 0x7F
	ld a, [wDialogState]
	bit 7, a
;> if wDialogState & 0x80: i += 3            # the bottom box uses the second half of the tables
	jr z, .top

	and $7f
	add $03

.top
;> offset = mem[DialogBackgroundSaveTable - 2 + i]
	ld e, a
	ld d, $00
	ld hl, DialogBackgroundSaveTable - 2
	add hl, de
	ld a, [hl]
;> dest = wDialogBackground + offset
	ld c, a
	ld b, $00
	ld hl, wDialogBackground
	add hl, bc
	push hl
	pop bc
;> row = u8(wBGOriginLow + mem[DialogBackgroundSaveTable + 10 + i])   # low byte of the row start
	ld hl, DialogBackgroundSaveTable + 10
	add hl, de
	ld a, [wBGOriginLow]
	add [hl]
	ld l, a
	ldh [hMultiPurpose0], a
;> high = u8(wBGOriginHigh + mem[DialogBackgroundSaveTable + 4 + i])
	ld hl, DialogBackgroundSaveTable + 4
	add hl, de
	ld a, [wBGOriginHigh]
	add [hl]
	ld h, a
;> src = (high << 8) | row
	ldh a, [hMultiPurpose0]
	ld l, a
;>@rows for r in range(2):
	xor a
	ld e, a
	ld d, a

.copyTile
;>@cols     for col in range(18):
;>         mem[dest] = mem[src]; dest += 1
	ld a, [hl]
	ld [bc], a
	inc bc
;>@wrap         if (src + 1) & 0x1F == 0: src &= 0xFFE0   # wrap around to the row's first column
	ld a, l
	add $01
	and $1f
	jr nz, .nextColumn

;=@wrap
	ld a, l
	and $e0
	ld l, a
	jr .columnDone

.nextColumn
;>         else: src += 1
	inc l

.columnDone
;=@cols
	inc e
	ld a, e
	cp $12
	jr nz, .copyTile

;>     row += 0x20                           # next row; a carry goes into the high byte
	ld e, $00
	ldh a, [hMultiPurpose0]
	add $20
	ldh [hMultiPurpose0], a
;>     if row > 0xFF: src += 0x100; row = u8(row)
	jr nc, .noCarry

	inc h

.noCarry
;>     src = (src & 0xFF00) | row
	ld l, a
;=@rows
	inc d
	ld a, d
	cp $02
	jr nz, .copyTile

;> return
	ret


;@ path: text/dialog
;@ The rows DialogStateClearBox blanks, one per frame, while the box opens: of the box's 5 rows, in the
;@ order 3, 2, 4, 1, 5.
;@   +0  10 bytes: low byte of the row's BG map address (column 1), added to wBGOriginLow; 5 for the top box,
;@                 then 5 for the bottom box
;@   +10 10 bytes: high byte, added to wBGOriginHigh ($98 top box, $99 bottom box)
DialogBoxClearRows::
	db $61, $41, $81, $21, $a1, $81, $61, $a1, $41, $c1, $98, $98, $98, $98, $98, $99
	db $99, $99, $99, $99

;@ def DialogStateClearBox()
;@ path: text/dialog
;@ Dialog step 5: the box appears row by row. Each frame one row of 18 tiles is filled with the blank tile
;@ through a draw command (done in VBlank); after 5 rows the next step starts.
DialogStateClearBox::
;> step = wDialogBoxStep
	ld a, [wDialogState]
	ld c, a
	ld a, [wDialogBoxStep]
;> if step == 5: return NextDialogState()
	cp $05
	jr z, NextDialogState

;> if wDialogState & 0x80: step += 5        # the bottom box's rows
	bit 7, c
	jr z, .top

	add $05

.top
;> i = step
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
;> high = u8(wBGOriginHigh + mem[DialogBoxClearRows + 10 + i])
	ld a, [wBGOriginHigh]
	ld hl, DialogBoxClearRows + 10
	add hl, bc
	add [hl]
;> wDrawCommand[0] = high                   # the command goes first in the queue
	ld hl, wDrawCommandsSize
	add hl, de
	ld [hli], a
;> low = u8(wBGOriginLow + mem[DialogBoxClearRows + i])
	push hl
	ld a, [wBGOriginLow]
	ld hl, DialogBoxClearRows
	add hl, bc
	add [hl]
;> wDrawCommand[1] = low
	pop hl
	ld [hli], a
;> wDrawCommand[2] = 0x51                   # one tile repeated 18 times along the row
	ld a, $51
	ld [hli], a
;> wDrawCommand[3] = hBGTilesRequestCopy    # the blank tile
	ldh a, [hBGTilesRequestCopy]
	ld [hli], a
;> wDrawCommand[4] = 0                      # end of the commands
	ld [hl], $00
;> wDialogBoxStep += 1
	ld hl, wDialogBoxStep
	inc [hl]
;> return
	ret


;@ def NextDialogState()
;@ path: text/dialog
;@ Moves the dialog on to its next step.
NextDialogState::
;> wDialogState += 1
	ld hl, wDialogState
	inc [hl]
;> return
	ret


;@ def DialogStateEnd()
;@ path: text/dialog
;@ Dialog step $0C: the text has reached its end mark. A or B closes the box, unless wDialogKeepOpen is set
;@ (the code that opened the dialog closes it itself).
DialogStateEnd::
;> if wDialogKeepOpen: return
	ld a, [wDialogKeepOpen]
	and a
	jr nz, jr_000_22af

;> if not hJoypadPressed & 0x30: return     # A or B
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_000_22af

;> CloseDialog()

;@ def CloseDialog()
;@ path: text/dialog
;@ Starts taking the dialog box down (step $0E, row by row).
CloseDialog::
;> wDialogBoxStep = 0
	xor a
	ld [wDialogBoxStep], a
;> wDialogState = (wDialogState & 0xF0) | 0x0E
	ld a, [wDialogState]
	and $f0
	or $0e
	ld [wDialogState], a

jr_000_22af:
;> return
	ret


;@ path: text/dialog
;@ The rows DialogStateRestoreBox puts back, one per frame, as the box closes (box rows 5, 1, 4, 2, 3).
;@   +0  10 bytes: low byte of the row's BG map address (column 1), added to wBGOriginLow; 5 for the top box,
;@                 then 5 for the bottom box
;@   +10 10 bytes: high byte, added to wBGOriginHigh ($98 top box, $99 bottom box)
;@   +20 10 bytes: offset of the saved row in wDialogBackground (18 tiles per row)
DialogBoxRestoreRows::
	db $a1, $21, $81, $41, $61, $c1, $41, $a1, $61, $81, $98, $98, $98, $98, $98, $99
	db $99, $99, $99, $99, $48, $00, $36, $12, $24, $48, $00, $36, $12, $24

;@ def DialogStateRestoreBox()
;@ path: text/dialog
;@ Dialog step $0E: the box disappears row by row. Each frame one row of 18 tiles saved in wDialogBackground
;@ is copied back to the BG map through a draw command; after 5 rows the next step (the end) follows.
DialogStateRestoreBox::
;> step = wDialogBoxStep
	ld a, [wDialogState]
	ld c, a
	ld a, [wDialogBoxStep]
;> if step == 5: return NextDialogState()
	cp $05
	jr z, NextDialogState

;> if wDialogState & 0x80: step += 5        # the bottom box's rows
	bit 7, c
	jr z, .top

	add $05

.top
;> i = step
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
;> high = u8(wBGOriginHigh + mem[DialogBoxRestoreRows + 10 + i])
	ld a, [wBGOriginHigh]
	ld hl, DialogBoxRestoreRows + 10
	add hl, bc
	add [hl]
;> wDrawCommand[0] = high
	ld hl, wDrawCommandsSize
	add hl, de
	ld [hli], a
;> low = u8(wBGOriginLow + mem[DialogBoxRestoreRows + i])
	push hl
	ld a, [wBGOriginLow]
	ld hl, DialogBoxRestoreRows
	add hl, bc
	add [hl]
;> wDrawCommand[1] = low
	pop hl
	ld [hli], a
;> wDrawCommand[2] = 0x11                   # copy 18 tiles along the row
	ld a, $11
	ld [hli], a
;> offset = mem[DialogBoxRestoreRows + 20 + i]
	push hl
	ld hl, DialogBoxRestoreRows + 20
	add hl, bc
	ld a, [hl]
;> src = wDialogBackground + offset
	ld c, a
	ld b, $00
	ld hl, wDialogBackground
	add hl, bc
	push hl
	pop bc
;>@cp for k in range(18):
	pop hl
	ld e, $12

.copy
;>     wDrawCommand[3 + k] = mem[src + k]
	ld a, [bc]
	inc bc
	ld [hli], a
;=@cp
	dec e
	jr nz, .copy

;> wDrawCommand[21] = 0                     # end of the commands
	ld [hl], $00
;> wDialogBoxStep += 1
	ld hl, wDialogBoxStep
	inc [hl]
;> return
	ret


;@ def DialogStateClearCharTile()
;@ path: text/dialog
;@ Dialog step 6, the start of typing one character: after the delay in wDialogScrollDelay, queues a draw
;@ command that fills the character's tile (one of 32 VRAM tiles the text cycles through, by the character
;@ number) with $FF, the colour of the box, then moves on to step 7. Its tables are in bank $1C.
DialogStateClearCharTile::
;> set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;> if wDialogScrollDelay:
	ld a, [wDialogScrollDelay]
	and a
	jr z, .clear

;>     wDialogScrollDelay -= 1
	dec a
	ld [wDialogScrollDelay], a
;>     return
	ret

.clear
;> t = wDialogCharIndex & 0x1F              # which of the 32 text tiles
	ld a, [wDialogCharIndex]
	and $1f
	ld e, a
	ld d, $00
;> high = mem[0x4521 + t]                   # the tile's VRAM address (tables in bank $1C)
	ld c, $01
	ld b, $00
	ld hl, $4521
	add hl, de
	ld a, [hl]
;> wDrawCommand[0] = high
	ld hl, wDrawCommandsSize
	add hl, bc
	ld [hli], a
;> wDrawCommand[1] = mem[0x4501 + t]        # low byte
	push hl
	ld hl, $4501
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;> wDrawCommand[2] = 0x4F                   # one byte repeated 16 times: the whole tile
	ld a, $4f
	ld [hli], a
;> wDrawCommand[3] = 0xFF
	ld a, $ff
	ld [hli], a
;> wDrawCommand[4] = 0
	ld [hl], $00
;> NextDialogState()
	jp NextDialogState


;@ def DialogStatePlaceChar()
;@ path: text/dialog
;@ Dialog step 7: queues the draw command that puts the character's text tile into the BG map at its place
;@ in the box (wDialogCharSlot; the bottom box uses the second half of the tables in bank $1C), remembers
;@ that place in wDialogCharBGHigh/Low, and goes straight on with step 8 in the same frame.
DialogStatePlaceChar::
;> set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;> p = wDialogCharSlot
	ld a, [wDialogState]
	ld c, a
	ld a, [wDialogCharSlot]
;> if wDialogState & 0x80: p += 0x20       # bottom box
	bit 7, c
	jr z, .top

	add $20

.top
;> i = p
	ld c, a
	ld b, $00
	ld e, $01
	ld d, $00
;> high = u8(wBGOriginHigh + mem[0x4561 + i])
	ld a, [wBGOriginHigh]
	ld hl, $4561
	add hl, bc
	add [hl]
;> wDrawCommand[0] = high
	ld hl, wDrawCommandsSize
	add hl, de
	ld [hli], a
;> wDialogCharBGHigh = high
	ld [wDialogCharBGHigh], a
;> t = mem[0x45A1 + i]                      # low byte of the place, relative to the screen
	push hl
	ld hl, $45a1
	add hl, bc
	ld a, [hl]
;> row_end = u8((t & 0xE0) + 0x20)
	and $e0
	add $20
	ld e, a
;> low = u8(wBGOriginLow + t)
	ld a, [wBGOriginLow]
	add [hl]
	ld d, a
;> if low >= row_end: low -= 0x20           # stay on the same BG map row
	cp e
	jr c, .haveLow

	ld a, d
	sub $20
	ld d, a

.haveLow
;> wDialogCharBGLow = low
	ld a, d
	ld [wDialogCharBGLow], a
;> wDrawCommand[1] = low
	pop hl
	ld [hli], a
;> wDrawCommand[2] = 0                      # a single byte
	xor a
	ld [hli], a
;> t = wDialogCharIndex & 0x1F
	push hl
	ld a, [wDialogCharIndex]
	and $1f
	ld c, a
;> wDrawCommand[3] = mem[0x4541 + t]        # the number of the text tile
	ld hl, $4541
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hli], a
;> NextDialogState()
	call NextDialogState
;> return DialogStateDrawChar()
	jp DialogStateDrawChar


;@ def DialogStateDrawChar()
;@ path: text/dialog
;@ Dialog step 8: reads the next character of the text and draws it. The text's address comes from the
;@ pointer table at $1C:$4001 (two bytes per dialog number) and its bank from the table at $1C:$46E1 (one
;@ byte per dialog: bank in bits 0-4, bit 7 = B does not skip the text). A second draw command is started
;@ for the character's tile (16 bytes copied); DialogTypeChar fills in its graphics. Character $FE ends the
;@ text with a two-answer question, $FF ends it; for both, nothing is drawn.
DialogStateDrawChar::
;> set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;> t = wDialogCharIndex & 0x1F
	ld a, [wDialogCharIndex]
	and $1f
	ld c, a
	ld b, $00
;> high = mem[0x4521 + t]                   # the text tile's VRAM address
	ld e, $05
	ld d, $00
	ld hl, $4521
	add hl, bc
	ld a, [hl]
;> wDrawCommand[4] = high
	ld hl, wDrawCommandsSize
	add hl, de
	ld [hli], a
;> wDrawCommand[5] = mem[0x4501 + t]        # low byte
	push hl
	ld hl, $4501
	add hl, bc
	ld a, [hl]
	pop hl
	ld [hli], a
;> wDrawCommand[6] = 0x0F                   # copy 16 bytes (the glyph follows)
	ld a, $0f
	ld [hli], a
;> n = (wDialogIndexHigh << 8) | wDialogIndex
	push hl
	ld a, [wDialogIndexHigh]
	ld d, a
	ld a, [wDialogIndex]
	ld e, a
;> ptr = 0x4001 + 2 * n
	sla e
	rl d
	ld hl, $4001
	add hl, de
;> text = mem16[ptr]
	ld a, [hli]
	ld e, a
	ld d, [hl]
	push de
;> entry = 0x46E1 + n
	ld a, [wDialogIndex]
	ld e, a
	ld a, [wDialogIndexHigh]
	ld d, a
	ld hl, $46e1
	add hl, de
;> set_rom_bank(mem[entry] & 0x1F)          # the bank of the text
	ld a, [hl]
	and $1f
	ld [$2100], a
;> pos = text + ((wDialogCharIndexHigh << 8) | wDialogCharIndex)
	pop hl
	ld a, [wDialogCharIndex]
	ld e, a
	ld a, [wDialogCharIndexHigh]
	ld d, a
	add hl, de
;> char = mem[pos]
	ld a, [hli]
	ld e, a
;> wDialogNextChar = mem[pos + 1]
	ld a, [hl]
	ld [wDialogNextChar], a
;> set_rom_bank(wCurrentBank)
	call RestoreBank
;> hMultiPurpose0 = char
	ld a, e
	ldh [hMultiPurpose0], a
;> if char != 0xFE: return DialogCheckEnd(char)
	cp $fe
	jr nz, DialogCheckEnd

;> wDrawCommand[0] = 0                      # $FE: a question - draw nothing
	pop hl
	xor a
	ld [wDrawCommand], a

DialogAskQuestion:
;> wDialogState = (wDialogState & 0xF0) | 0x0D
	ld a, [wDialogState]
	and $f0
	or $0d
	ld [wDialogState], a
;> PlayDialogJingle()

;@ def PlayDialogJingle()
;@ path: text/dialog
;@ The jingle of a dialog box that waits for the player (a full box, a question).
PlayDialogJingle::
;> hJingle = 0x15
	ld a, $15
	ldh [hJingle], a
;> return
	ret


;@ def DialogCheckEnd(char: a)
;@ path: text/dialog
;@ Part of DialogStateDrawChar: $FF ends the text (nothing is drawn, step $0C waits for a button), other
;@ characters are typed by DialogTypeChar.
DialogCheckEnd::
;> if char != 0xFF: return DialogTypeChar(char)
	cp $ff
	jr nz, DialogTypeChar

;> wDrawCommand[0] = 0                      # draw nothing
	pop hl
	xor a
	ld [wDrawCommand], a

DialogReachedEnd:
;> wDialogState = (wDialogState & 0xF0) | 0x0C
	ld a, [wDialogState]
	and $f0
	or $0c
	ld [wDialogState], a
;> return
	ret


;@ path: text/dialog
;@ The name the dialogs use for the player after he stole from the shop: "THIEF", stored like wPlayerName
;@ (each character code + 1).
ThiefName::
	db $55, $49, $4a, $46, $47

;@ def DialogTypeChar(char: a)
;@ path: text/dialog
;@ The rest of DialogStateDrawChar for a printable character: plays the typing sound (not for spaces; every
;@ 2nd, 4th or 8th character depending on wDialogSfx), replaces '#' by the next letter of the player's name,
;@ copies the character's 16-byte glyph from the font ($5000 in the caller's bank, glyph number from the
;@ table at $1C:$45E1) into the draw command, and moves on to the next character (step 6), or to step 9 when
;@ the box is full.
DialogTypeChar::
;> if char != 0x20:                         # spaces make no sound
	cp $20
	jr z, .noSound

;>@ev     mask = 1 if wDialogSfx == 0x0F else 7 if wDialogSfx == 0x19 else 3
	push af
	ld a, [wDialogSfx]
	ld d, a
	ld e, $01
	cp $0f
	jr z, .haveMask

;=@ev
	ld e, $07
	cp $19
	jr z, .haveMask

	ld e, $03

.haveMask
;>@snd     if (wDialogCharIndex + 4) & mask == 0: hWaveSfx = wDialogSfx
	ld a, [wDialogCharIndex]
	add $04
	and e
	jr nz, .soundDone

;=@snd
	ld a, d
	ldh [hWaveSfx], a

.soundDone
;=@snd
	pop af

.noSound
;> if char == 0x23:                         # '#': a letter of the player's name
	ld d, $00
	cp $23
	jr nz, .haveChar

;>     i = wDialogNameCharIndex
	ld a, [wDialogNameCharIndex]
	ld e, a
;>@ni     wDialogNameCharIndex = (i + 1) % 5
	inc a
	cp $05
	jr nz, .storeIndex

;=@ni
	xor a

.storeIndex
;=@ni
	ld [wDialogNameCharIndex], a
;>@nm     name = ThiefName if wIsThief else wPlayerName
	ld hl, wPlayerName
	ld a, [wIsThief]
	and a
	jr z, .haveName

;=@nm
	ld hl, ThiefName

.haveName
;>     char = u8(mem[name + i] - 1)         # names are stored one above the character codes
	add hl, de
	ld a, [hl]
	dec a
;>     if char == 0xFF: char = 0x20         # an unused letter (0) prints as a space
	cp $ff
	jr nz, .haveChar

	ld a, $20

.haveChar
;> hMultiPurpose1 = char
	ldh [hMultiPurpose1], a
	ld e, a
;> set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;> glyph = mem[0x45E1 + char]               # the character's glyph in the font
	ld hl, $45e1
	add hl, de
	ld e, [hl]
	ld d, $00
;>@x16 offset = glyph * 16
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
;=@x16
	sla e
	rl d
;> set_rom_bank(wCurrentBank)
	call RestoreBank
;> src = 0x5000 + offset                    # the font
	ld hl, $5000
	add hl, de
	push hl
	pop bc
;> data = wDrawCommand + 7                  # the tile command's data (DialogStateDrawChar kept it on the stack)
	pop hl
;>@cp for k in range(16):
	ld e, $10

.copyGlyph
;>     mem[data + k] = mem[src + k]
	ld a, [bc]
	ld [hli], a
	inc bc
;=@cp
	dec e
	jr nz, .copyGlyph

;> mem[data + 16] = 0                       # end of the commands
	ld [hl], $00
;> set_rom_bank(0x1C)
	push hl
	ld a, $1c
	ld [$2100], a
;> mark = 0                                 # always 0: the code for a mark above the character never runs
	ldh a, [hMultiPurpose1]
	ld e, a
	ld d, $00
	xor a
	pop hl
;> if mark:
	and a
	jr z, .advance

;>     mem[data + 17] = wDialogCharBGHigh   # a command for the BG map tile above the character
	ld e, a
	ld a, [wDialogCharBGHigh]
	ld [hli], a
;>     mem[data + 18] = u8(wDialogCharBGLow - 0x20)
	ld a, [wDialogCharBGLow]
	sub $20
	ld [hli], a
;>     mem[data + 19] = 0
	ld a, $00
	ld [hli], a
;>@mk     mem[data + 20] = 0xC9 if mark & 1 else 0xC8
	ld a, $c9
	rr e
	jr c, .haveMark

	dec a

.haveMark
;=@mk
	ld [hli], a
;>     mem[data + 21] = 0
	ld [hl], $00

.advance
;> wDialogCharIndex = u8(wDialogCharIndex + 1)
	ld a, [wDialogCharIndex]
	add $01
	ld [wDialogCharIndex], a
;> if wDialogCharIndex == 0: wDialogCharIndexHigh += 1
	ld a, [wDialogCharIndexHigh]
	adc $00
	ld [wDialogCharIndexHigh], a
;> wDialogFullJinglePlayed = 0
	xor a
	ld [wDialogFullJinglePlayed], a
;>@full if wDialogCharSlot == 0x1F: return NextDialogState()   # the box is full
	ld a, [wDialogCharSlot]
	cp $1f
	jr z, jr_000_251a

DialogNextChar:
;> wDialogState = (wDialogState & 0xF0) | 6   # type the next character
	ld a, [wDialogState]
	and $f0
	or $06
	ld [wDialogState], a
;> wDialogScrollDelay = 0
	ld a, $00
	ld [wDialogScrollDelay], a
;> return
	ret

jr_000_251a:
;=@full
	jp NextDialogState


;@ path: text/dialog
;@ BG map address of the dialog's first text line (column 2), cleared by DialogStateBoxFull before the text
;@ scrolls up: low bytes ($22 top box, $42 bottom box; added to wBGOriginLow), then high bytes ($98, $99;
;@ added to wBGOriginHigh).
DialogLine1Address::
	db $22, $42, $98, $99

;@ def DialogStateBoxFull()
;@ path: text/dialog
;@ Dialog step 9: the box's last place has been typed. After a full new page (the character position is a
;@ multiple of 32) it waits: at the end of the text or before a question it goes to step $0C / $0D, else it
;@ plays the jingle once, shows the blinking arrow and waits for A (go on) or B (skip the rest of the text,
;@ unless the dialog's bank byte has bit 7 set; in game mode 7 B always closes). After the first half of a
;@ page it goes on at once. Going on means: clear the first line and start the two scroll steps ($0A, $0B).
DialogStateBoxFull::
;> if wDialogCharIndex & 0x1F == 0:        # a whole new page is in the box: wait for the player
	ld a, [wDialogCharIndex]
	and $1f
	jr nz, .scroll

;>     if wDialogNextChar == 0xFF: return DialogReachedEnd()
	ld a, [wDialogNextChar]
	cp $ff
	jp z, DialogReachedEnd

;>     if wDialogNextChar == 0xFE: return DialogAskQuestion()
	cp $fe
	jp z, DialogAskQuestion

;>     if not wDialogFullJinglePlayed:
	ld a, [wDialogFullJinglePlayed]
	and a
	jr nz, .jingleDone

;>         wDialogFullJinglePlayed = 1
	inc a
	ld [wDialogFullJinglePlayed], a
;>         PlayDialogJingle()
	call PlayDialogJingle

.jingleDone
;>     DrawDialogMoreArrow()
	call DrawDialogMoreArrow
;>     if not hJoypadPressed & 0x10:        # not A
	ldh a, [hJoypadPressed]
	bit 4, a
	jr nz, .scroll

;>         if not hJoypadPressed & 0x20: return   # nor B: keep waiting
	bit 5, a
	jr z, DialogStateScroll1

;>         set_rom_bank(0x1C)
	ld a, $1c
	ld [$2100], a
;>         if wGameplayType == 7: return DialogCancel()
	ld a, [wGameplayType]
	cp $07
	jp z, DialogCancel

;>         n = (wDialogIndexHigh << 8) | wDialogIndex
	ld a, [wDialogIndex]
	ld e, a
	ld a, [wDialogIndexHigh]
	ld d, a
;>         if not mem[0x46E1 + n] & 0x80: return DialogCancel()   # B skips the rest of the text
	ld hl, $46e1
	add hl, de
	bit 7, [hl]
	jp z, DialogCancel

.scroll
;> b = 1 if wDialogState & 0x80 else 0      # bottom box
	ld e, $00
	ld a, [wDialogState]
	and $80
	jr z, .top

	inc e

.top
;> wDrawCommand[0] = u8(wBGOriginHigh + mem[DialogLine1Address + 2 + b])
	ld d, $00
	ld hl, DialogLine1Address + 2
	add hl, de
	ld a, [wBGOriginHigh]
	add [hl]
	ld [wDrawCommand], a
;> wDrawCommand[1] = u8(wBGOriginLow + mem[DialogLine1Address + b])
	ld hl, DialogLine1Address
	add hl, de
	ld a, [wBGOriginLow]
	add [hl]
	ld [wDrawCommand + 1], a
;> wDrawCommand[2] = 0x4F                   # the blank tile 16 times along the row
	ld a, $4f
	ld [wDrawCommand + 2], a
;> wDrawCommand[3] = hBGTilesRequestCopy
	ldh a, [hBGTilesRequestCopy]
	ld [wDrawCommand + 3], a
;> wDrawCommand[4] = 0
	xor a
	ld [wDrawCommand + 4], a
;> NextDialogState()
	call NextDialogState
;> DialogStateScroll1()

;@ def DialogStateScroll1()
;@ path: text/dialog
;@ Dialog step $0A: nothing to do here; the VBlank handler runs ScrollDialogText1.
DialogStateScroll1::
;> return
	ret


;@ path: text/dialog
;@ BG map address of the first row ScrollDialogText1 moves up (row 3 / 12, column 2): low bytes $62 (top
;@ box), $82 (bottom box), then high bytes $98, $99.
DialogScroll1Address::
	db $62, $82, $98, $99

;@ def ScrollDialogText1()
;@ path: text/dialog
;@ Called by the VBlank handler in dialog step $0A: the first half of the text scroll - the lower text rows
;@ move up one tile row. Then 8 frames of pause (step $0B).
ScrollDialogText1::
;> b = 1 if wDialogState & 0x80 else 0      # bottom box
	ld e, $00
	ld a, [wDialogState]
	and $80
	jr z, .top

	inc e

.top
;> high = u8(wBGOriginHigh + mem[DialogScroll1Address + 2 + b])
	ld d, $00
	ld hl, DialogScroll1Address + 2
	add hl, de
	ld a, [wBGOriginHigh]
	add [hl]
	ld b, a
;> ScrollDialogRows(high, DialogScroll1Address, b)
	ld hl, DialogScroll1Address

;@ def ScrollDialogRows(high: b, table: hl, b: e)
;@ path: text/dialog
;@ Moves 16 columns of the dialog box up by one tile row: the row at (high, wBGOriginLow + table[b]) goes to
;@ the row above it, the row below it takes its place, and that lower row is blanked. Columns wrap within
;@ the 32-tile BG map row. Sets the 8-frame pause and moves on to the next dialog step.
ScrollDialogRows::
;> col = u8(wBGOriginLow + mem[table + b])
	add hl, de
	ld a, [wBGOriginLow]
	add [hl]
	ld c, a
;>@cl for _ in range(16):
	ld e, $10

.column
;>     mem[(high << 8) | u8(col - 0x20)] = mem[(high << 8) | col]   # this row moves up ...
	ld a, c
	sub $20
	ld l, a
	ld h, b
	ld a, [bc]
	ld [hl], a
;>@dn     mem[(high << 8) | col] = mem[(high << 8) | u8(col + 0x20)]   # ... the row below takes its place ...
	push bc
	ld a, c
	add $20
	ld c, a
	ld a, l
	add $20
;=@dn
	ld l, a
	ld a, [bc]
	ld [hl], a
;>     mem[(high << 8) | u8(col + 0x20)] = hBGTilesRequestCopy        # ... and is blanked
	ld a, l
	add $20
	ld l, a
	ldh a, [hBGTilesRequestCopy]
	ld [hl], a
	pop bc
;>     col = u8(col + 1)
	inc bc
;>     if col & 0x1F == 0: col -= 0x20      # wrap around within the BG map row
	ld a, c
	and $1f
	jr nz, .next

	ld a, c
	sub $20
	ld c, a

.next
;=@cl
	dec e
	jr nz, .column

;> wDialogScrollDelay = 8
	ld a, $08
	ld [wDialogScrollDelay], a
;> NextDialogState()
	jp NextDialogState


;@ def DialogStateScroll2()
;@ path: text/dialog
;@ Dialog step $0B: nothing to do here; the VBlank handler waits out wDialogScrollDelay and runs
;@ ScrollDialogText2.
DialogStateScroll2::
;> return
	ret


;@ path: text/dialog
;@ BG map address of the first row ScrollDialogText2 moves up (row 2 / 11, column 2): low bytes $42 (top
;@ box), $62 (bottom box), then high bytes $98, $99.
DialogScroll2Address::
	db $42, $62, $98, $99

;@ def ScrollDialogText2()
;@ path: text/dialog
;@ Called by the VBlank handler in dialog step $0B after the pause: the second half of the text scroll (the
;@ old second line is now the first one), then typing goes on (step 6).
ScrollDialogText2::
;> b = 1 if wDialogState & 0x80 else 0      # bottom box
	ld e, $00
	ld a, [wDialogState]
	and $80
	jr z, .top

	inc e

.top
;> high = u8(wBGOriginHigh + mem[DialogScroll2Address + 2 + b])
	ld d, $00
	ld hl, DialogScroll2Address + 2
	add hl, de
	ld a, [wBGOriginHigh]
	add [hl]
	ld b, a
;> ScrollDialogRows(high, DialogScroll2Address, b)
	ld hl, DialogScroll2Address
	call ScrollDialogRows
;> return DialogNextChar()
	jp DialogNextChar


;@ def DialogCancel()
;@ path: text/dialog
;@ B in a question or in a long text: the answer is 2 (cancelled) and the box closes.
DialogCancel::
;> wDialogAnswer = 2
	ld a, $02
	ld [wDialogAnswer], a
;> CloseDialog()
	jp CloseDialog


;@ def DialogStateChoice()
;@ path: text/dialog
;@ Dialog step $0D, a question with two answers: left, right or Select switch the answer (wDialogAnswer 0/1,
;@ with a sound), A confirms it, B cancels (answer 2). The answer cursor is drawn blinking (16 frames on, 16
;@ off) by the code in bank $17.
DialogStateChoice::
;> if hJoypadPressed & 0x20: return DialogCancel()   # B
	ldh a, [hJoypadPressed]
	bit 5, a
	jr nz, DialogCancel

;>@ok if hJoypadPressed & 0x10: return CloseDialog()    # A: keep the answer
	and $10
	jp nz, .confirm

;> if hJoypadPressed & 0x43:                # right, left or Select
	ldh a, [hJoypadPressed]
	and $43
	jr z, .cursor

;>     wDialogAnswer = (wDialogAnswer + 1) & 1
	ld hl, wDialogAnswer
	ld a, [hl]
	inc a
	and $01
	ld [hl], a
;>     hJingle = 0x0A
	ld a, $0a
	ldh [hJingle], a

.cursor
;> if not hFrameCounter & 0x10: return
	ldh a, [hFrameCounter]
	and $10
	ret z

;> set_rom_bank(0x17)
	ld a, $17
	ld [$2100], a
;> return DrawDialogChoiceCursor()          # draws the answer cursor (bank $17)
	jp DrawDialogChoiceCursor

.confirm
;=@ok
	call CloseDialog
	ret


;@ def DrawDialogMoreArrow()
;@ path: text/dialog
;@ Draws the arrow of a full dialog box that waits for a button (code in bank $17 at $7B07; it does not
;@ come back here).
DrawDialogMoreArrow::
;> set_rom_bank(0x17)
	ld a, $17
	ld [$2100], a
;> return DrawDialogArrow()
	jp DrawDialogArrow


;@ def RunRoomTransition()
;@ path: world/transition
;@ Runs one frame of the scroll from one room to the next (UpdateRoomTransition, by wRoomTransitionState).
RunRoomTransition::
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> UpdateRoomTransition()
	call UpdateRoomTransition
;> return
	ret


;@ path: world/transition
;@ Tables of QueueTransitionStrip, each 4 bytes indexed by wRoomTransitionDirection (right, left, up, down):
;@   +0  offset of the second draw command from the first: $01 (next column), $20 (next row)
;@   +4  draw command mode: $93 = 20 tiles down a column, $13 = 20 tiles along a row
;@   +8  step in wRoomObjects from one object of the strip to the next: $10 (down), $01 (right)
;@   +12 objects per strip: 8 (a column of the room), 10 (a row)
;@   +16 step in wRoomObjects to the next strip: +1, -1, -$10, +$10
;@   +20 high byte of the BG map step to the next strip (with the carry): $00, $00, $03, $00
;@   +24 low byte of the BG map step: $02, $1E, $C0, $40 (two tiles right / left, up / down, wrapping)
TransitionStripTables::
	db $01, $01, $20, $20, $93, $93, $13, $13, $10, $10, $01, $01, $08, $08, $0a, $0a
	db $01, $ff, $f0, $10, $00, $00, $03, $00, $02, $1e, $c0, $40

;@ def DrawTransitionStrip()
;@ path: world/transition
;@ QueueTransitionStrip with bank 8 (the object tile tables) switched in.
DrawTransitionStrip::
;> set_rom_bank(0x08)
	ld a, $08
	ld [$2100], a
;> QueueTransitionStrip()
	call QueueTransitionStrip
;> set_rom_bank(wCurrentBank)
	call RestoreBank
;> return
	ret


;@ def QueueTransitionStrip()
;@ path: world/transition
;@ While the screen scrolls to a new room, draws the new room into the BG map one strip (a column or a row of
;@ objects, 16x16 pixels each, four tiles) every second frame: two draw commands, one per tile column / row
;@ of the strip, each 20 tiles long with the last 4 set to $EE (left as they are). The tiles of an object
;@ come from bank 8 (4 per object: top left, top right, bottom left, bottom right; $498C overworld, $4D60
;@ indoors). When all strips are drawn the transition moves on to its next state.
QueueTransitionStrip::
;> if wTransitionDrawDelay != 0:
	ld a, [wTransitionDrawDelay]
	cp $00
	jr z, .draw

;>     wTransitionDrawDelay -= 1
	dec a
	ld [wTransitionDrawDelay], a
;>     return
	ret

.draw
;> d = wRoomTransitionDirection
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;> wTransitionDrawDelay = 1
	ld a, $01
	ld [wTransitionDrawDelay], a
;> obj = wTransitionObjectIndex
	ld a, [wTransitionObjectIndex]
	ldh [hMultiPurpose2], a
;> wDrawCommand[1] = wTransitionDrawLow
	ld hl, TransitionStripTables
	add hl, bc
	ld a, [wTransitionDrawLow]
	ld [wDrawCommand + 1], a
;> low2 = wTransitionDrawLow + mem[TransitionStripTables + d]   # the second command: next column / row
	add [hl]
	rl d
;> wDrawCommand[24] = u8(low2)
	ld [wDrawCommand + 24], a
;> high = wTransitionDrawHigh | 0x98
	ld a, [wTransitionDrawHigh]
	or $98
;> wDrawCommand[0] = high
	ld [wDrawCommand], a
;> wDrawCommand[23] = high + (low2 >> 8)
	rr d
	adc $00
	ld [wDrawCommand + 23], a
;> mode = mem[TransitionStripTables + 4 + d]
	ld hl, TransitionStripTables + 4
	add hl, bc
	ld a, [hl]
;> wDrawCommand[2] = mode
	ld [wDrawCommand + 2], a
;> wDrawCommand[25] = mode
	ld [wDrawCommand + 25], a
;> wDrawCommand[46] = 0                     # end of the commands
	ld a, $00
	ld [wDrawCommand + 46], a
;>@ee for i in (19, 20, 21, 22, 42, 43, 44, 45):   # the last 4 tiles of each command are skipped ($EE)
	ld a, $ee
;>     wDrawCommand[i] = 0xEE
	ld [wDrawCommand + 19], a
	ld [wDrawCommand + 20], a
	ld [wDrawCommand + 21], a
	ld [wDrawCommand + 22], a
;=@ee
	ld [wDrawCommand + 42], a
	ld [wDrawCommand + 43], a
	ld [wDrawCommand + 44], a
	ld [wDrawCommand + 45], a
;> first = wDrawCommand + 3                 # where the tiles of the two commands go
	ld b, HIGH(wDrawCommand + 3)
	ld c, LOW(wDrawCommand + 3)
;> second = wDrawCommand + 26
	ld d, HIGH(wDrawCommand + 26)
	ld e, LOW(wDrawCommand + 26)

.object
;> while True:
	push bc
	push de
;>     o = wRoomObjects[obj]
	ldh a, [hMultiPurpose2]
	ld c, a
	ld b, $00
	ld hl, wRoomObjects
	add hl, bc
;>     offset = o * 4
	ld b, $00
	ld c, [hl]
	sla c
	rl b
	sla c
	rl b
;>@tb     tiles = (0x4D60 if wIsIndoor else 0x498C) + offset   # 4 tiles per object, in bank 8
	ld hl, $498c
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

;=@tb
	ld hl, $4d60

.overworld
;=@tb
	add hl, bc
	pop de
	pop bc
;>     if wRoomTransitionDirection & 2:     # up / down: the strip is a row of objects
	ld a, [wRoomTransitionDirection]
	and $02
	jr z, .column

;>         mem[first] = mem[tiles]; mem[first + 1] = mem[tiles + 1]; first += 2           # top tiles
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
;>         mem[second] = mem[tiles + 2]; mem[second + 1] = mem[tiles + 3]; second += 2    # bottom tiles
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
;>     else:                                # left / right: the strip is a column of objects
	jr .stored

.column
;>         mem[first] = mem[tiles]; mem[second] = mem[tiles + 1]                          # top left, top right
	ld a, [hli]
	ld [bc], a
	ld a, [hli]
	ld [de], a
	inc bc
	inc de
;>         mem[first + 1] = mem[tiles + 2]; mem[second + 1] = mem[tiles + 3]; first += 2; second += 2
	ld a, [hli]
	ld [bc], a
	ld a, [hl]
	ld [de], a
	inc bc
	inc de

.stored
;>     d = wRoomTransitionDirection
	push bc
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;>     obj = u8(obj + mem[TransitionStripTables + 8 + d])
	ld hl, TransitionStripTables + 8
	add hl, bc
	ldh a, [hMultiPurpose2]
	add [hl]
	ldh [hMultiPurpose2], a
	pop bc
;>     wTransitionStripLength -= 1
	ld a, [wTransitionStripLength]
	dec a
	ld [wTransitionStripLength], a
;>     if wTransitionStripLength == 0: break
	jr nz, .object

;> d = wRoomTransitionDirection
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;> wTransitionStripLength = mem[TransitionStripTables + 12 + d]
	ld hl, TransitionStripTables + 12
	add hl, bc
	ld a, [hl]
	ld [wTransitionStripLength], a
;> wTransitionObjectIndex = u8(wTransitionObjectIndex + mem[TransitionStripTables + 16 + d])
	ld hl, TransitionStripTables + 16
	add hl, bc
	ld a, [wTransitionObjectIndex]
	add [hl]
	ld [wTransitionObjectIndex], a
;> low = wTransitionDrawLow + mem[TransitionStripTables + 24 + d]
	ld hl, TransitionStripTables + 24
	add hl, bc
	ld a, [wTransitionDrawLow]
	add [hl]
	rr d
;> wTransitionDrawLow = u8(low) & 0xDF      # wrap around at the BG map's right edge
	and $df
	ld [wTransitionDrawLow], a
;> high = wTransitionDrawHigh + mem[TransitionStripTables + 20 + d] + (low >> 8)
	ld hl, TransitionStripTables + 20
	add hl, bc
	ld a, [wTransitionDrawHigh]
	rl d
	adc [hl]
;> wTransitionDrawHigh = high & 3
	and $03
	ld [wTransitionDrawHigh], a
;> wTransitionStripsLeft -= 1
	ld a, [wTransitionStripsLeft]
	dec a
	ld [wTransitionStripsLeft], a
;>@more if wTransitionStripsLeft: return
	jr nz, .more

;>@done wRoomTransitionState += 1         # every strip drawn
	jp .allDone

.more
;=@more
	ret

.allDone
;=@done
	ld a, [wRoomTransitionState]
	inc a
	ld [wRoomTransitionState], a
;> return
	ret


;@ path: unused
;@ 9 unused bytes ($FF) between two routines.
Padding279F::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def PlayMusic(track: a)
;@ path: sound/music
;@ Starts music track `track`: asks the sound engine for it, remembers it as the last track and lets the
;@ volume fade in (stopping a fade-out).
PlayMusic::
;> wMusicTrackToPlay = track
	ld [wMusicTrackToPlay], a
;> hLastMusicTrack = track
	ldh [hLastMusicTrack], a
;> hVolumeFadeInTimer = 0x38
	ld a, $38
	ldh [hVolumeFadeInTimer], a
;> hVolumeFadeOutTimer = 0
	xor a
	ldh [hVolumeFadeOutTimer], a
;> return
	ret


;@ def EnableSRAM()
;@ path: save/sram
;@ Enables the cartridge's battery RAM (MBC1: $0A written to $0000-$1FFF), so the save files can be read
;@ and written.
EnableSRAM::
;> mem[0x0000] = 0x0A
	push hl
	ld hl, $0000
	ld [hl], $0a
	pop hl
;> return
	ret


;@ def SelectAreaMusicFar()
;@ path: sound/music
;@ SelectAreaMusic (bank 2) called from anywhere: picks the music of the current area. bc is kept.
SelectAreaMusicFar::
;> set_rom_bank(0x02)
	ld a, $02
	ld [$2100], a
;> SelectAreaMusic()
	push bc
	call SelectAreaMusic
	pop bc
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def FadeOutVolume()
;@ path: sound/music
;@ Lets the sound volume fade out (and stops a fade-in).
FadeOutVolume::
;> hVolumeFadeOutTimer = 0x38
	ld a, $38
	ldh [hVolumeFadeOutTimer], a
;> hVolumeFadeInTimer = 0
	xor a
	ldh [hVolumeFadeInTimer], a
;> return
	ret


;@ def ResetSoundEngine()
;@ path: sound/engine
;@ Stops all music and sound effects (SoundEntryStopAll in the sound bank), unless hSkipMusicSelection asks to
;@ keep the music running across this room change.
ResetSoundEngine::
;> if not hSkipMusicSelection:
	ldh a, [hSkipMusicSelection]
	and a
	jr nz, .done

;>     set_rom_bank(0x1F)
	ld a, $1f
	ld [$2100], a
;>     SoundEntryStopAll()
	call SoundEntryStopAll

.done
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SaveDungeonItemFlags()
;@ path: world/dungeon
;@ In a dungeon, copies the dungeon's item flags (map, compass, ...) from the working copy back into its
;@ entry in the save data (StoreDungeonItemFlags).
SaveDungeonItemFlags::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> StoreDungeonItemFlags()
	call StoreDungeonItemFlags
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def GetRandomByte() -> a
;@ path: system/random
;@ A cheap random number: mixes the last one with the frame counter and the LCD's current line, rotated right
;@ by one bit.
;@ test: skip reads rLY
GetRandomByte::
;> r = u8(hFrameCounter + wRandomSeed + rLY)
	push hl
	ldh a, [hFrameCounter]
	ld hl, wRandomSeed
	add [hl]
	ld hl, $ff44
	add [hl]
;> r = ((r >> 1) | (r << 7)) & 0xFF         # rotate right
	rrca
;> wRandomSeed = r
	ld [wRandomSeed], a
	pop hl
;> return r
	ret


;@ def ReadJoypad()
;@ path: system/joypad
;@ Reads the buttons into hJoypadHeld (bits 0-3 right, left, up, down; 4-7 A, B, Select, Start) and the ones
;@ pressed since the last frame into hJoypadPressed. The buttons are not read while the screen scrolls to
;@ another room (the old values stay).
;@ test: skip reads the joypad
ReadJoypad::
;> if wRoomTransitionState: return
	ld a, [wRoomTransitionState]
	and a
	jr nz, .done

;> dirs = read_buttons(0x20) & 0x0F         # the direction keys (read twice to let the lines settle)
	ld a, $20
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0f
;>@btn buttons = read_buttons(0x10) & 0x0F  # A, B, Select, Start (read 8 times)
	ld b, a
	ld a, $10
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
;=@btn
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
;> held = (buttons << 4) | dirs
	swap a
	cpl
	and $f0
	or b
	ld c, a
;> hJoypadPressed = (hJoypadHeld ^ held) & held
	ldh a, [hJoypadHeld]
	xor c
	and c
	ldh [hJoypadPressed], a
;> hJoypadHeld = held
	ld a, c
	ldh [hJoypadHeld], a
;> rP1 = 0x30                               # deselect both groups
	ld a, $30
	ldh [rP1], a

.done
;> return
	ret


;@ def GetBGAddress() -> hl
;@ path: gfx/bgmap
;@ The BG map address of the tile under the screen position (hBGPosX, hBGPosY), taking the scroll
;@ (hBaseScrollX/Y) into account. Also stored in hBGAddrHigh / hBGAddrLow.
GetBGAddress::
;>@ry row = u8(hBGPosY + hBaseScrollY) >> 3
	push bc
	ldh a, [hBGPosY]
	ld hl, hBaseScrollY
	add [hl]
	and $f8
	srl a
;=@ry
	srl a
	srl a
;> addr = 0x9800
	ld de, $0000
	ld e, a
	ld hl, $9800
;>@rw for _ in range(32):                   # + 32 * row
	ld b, $20

.addRow
;>     addr += row
	add hl, de
;=@rw
	dec b
	jr nz, .addRow

;>@cx col = u8(hBGPosX + hBaseScrollX) >> 3
	push hl
	ldh a, [hBGPosX]
	ld hl, hBaseScrollX
	add [hl]
	pop hl
	and $f8
;=@cx
	srl a
	srl a
	srl a
;> addr += col
	ld de, $0000
	ld e, a
	add hl, de
;> hBGAddrHigh = hi(addr)
	ld a, h
	ldh [hBGAddrHigh], a
;> hBGAddrLow = lo(addr)
	ld a, l
	ldh [hBGAddrLow], a
	pop bc
;> return addr
	ret


;@ def JumpTable(index: a)
;@ path: system/jumptable
;@ The target of `rst $00`: the `rst` is followed by a table of 16-bit addresses, and execution goes on at
;@ entry `index` of that table instead of returning.
;@ test: skip rewrites the return address on the stack
JumpTable::
;> offset = 2 * index
	ld e, a
	ld d, $00
	sla e
	rl d
;> table = pop_return_address()             # the table starts right after the `rst $00`
	pop hl
;> target = mem16[table + offset]
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
;> goto(target)
	push de
	pop hl
	jp hl


;@ def DisableLCD()
;@ path: system/lcd
;@ Waits for line $91 (inside VBlank) and switches the LCD off. (It means to disable the VBlank interrupt
;@ meanwhile, but the `res 0` result is never written back, so rIE stays as it was.)
;@ test: skip waits for the LCD
DisableLCD::
;> hSavedIE = rIE
	ldh a, [rIE]
	ldh [hSavedIE], a
	res 0, a

;> wait_ly(0x91)
.wait
	ldh a, [rLY]
	cp $91
	jr nz, .wait

;> rLCDC &= 0x7F
	ldh a, [rLCDC]
	and $7f
	ldh [rLCDC], a
;> rIE = hSavedIE
	ldh a, [hSavedIE]
	ldh [rIE], a
;> return
	ret


;@ def FillBGMapCheckerboard()
;@ path: gfx/bgmap
;@ Fills BG map 0 with a checkerboard of tiles $AE / $AF (FillBGCheckerboard).
FillBGMapCheckerboard::
;> SwitchBank(1)
	ld a, $01
	call SwitchBank
;> FillBGCheckerboard()
	call FillBGCheckerboard
;> return
	ret


;@ def FillBGMap0With7E()
;@ path: gfx/bgmap
;@ Fills BG map 0 ($9800-$9BFF) with tile $7E (the loop of FillBGMapsWith7F). The LCD must be off.
FillBGMap0With7E::
;> fill(0x9800, 0x7E, 0x400)
	ld a, $7e
	ld bc, $0400
	jr jr_000_28ad

;@ def FillBGMapsWith7F()
;@ path: gfx/bgmap
;@ Fills both BG maps ($9800-$9FFF) with tile $7F. The LCD must be off.
FillBGMapsWith7F::
;> tile = 0x7F
	ld a, $7f
;> count = 0x800
	ld bc, $0800

jr_000_28ad:
;>@f fill(0x9800, tile, count)
	ld d, a
	ld hl, $9800

.loop
;=@f
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop

;> return
	ret


;@ def CopyDataFromBank(bank: a, src: hl, dest: de, count: bc)
;@ path: system/memory
;@ Copies `count` bytes from `src` in ROM bank `bank` to `dest`, then switches bank 1 in.
CopyDataFromBank::
;> set_rom_bank(bank)
	ld [$2100], a
;> CopyData(src, dest, count)
	call CopyData
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> return
	ret


;@ def CopyData(src: hl, dest: de, count: bc)
;@ path: system/memory
;@ Copies `count` bytes (1-65536) from `src` to `dest`, front to back.
CopyData::
;>@cp copy(dest, src, count)
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
;=@cp
	jr nz, CopyData

;> return
	ret


;@ def DrawNextCommand(high: a, cmds: de)
;@ path: gfx/bgmap
;@ Part of DrawCommands: runs the draw command at `cmds` (its first byte `high` is not 0) and goes on with the
;@ next one.
DrawNextCommand::
;> dest = (high << 8) | mem[cmds + 1]
	inc de
	ld h, a
	ld a, [de]
	ld l, a
;> mode = mem[cmds + 2]
	inc de
	ld a, [de]
	inc de
;> cmds = ExecuteDrawCommand(dest, mode, cmds + 3)
	call ExecuteDrawCommand
;> return DrawCommands(cmds)

;@ def DrawCommands(cmds: de)
;@ path: gfx/bgmap
;@ Runs a list of draw commands (as in wDrawCommand), each: VRAM address high, low, mode byte, data; a 0
;@ ends the list. The mode byte holds the count - 1 in bits 0-5 and in bits 6-7 the kind: 0 copy along a BG
;@ map row, 1 one byte repeated along the row, 2 copy down a column, 3 one byte repeated down the column.
;@ While the screen scrolls to another room the commands are run by ExecuteDrawCommandSkipEE instead
;@ (copies only, $EE bytes are left out).
DrawCommands::
;> if wRoomTransitionState: return DrawCommandsSkipEE(cmds)
	ld a, [wRoomTransitionState]
	and a
	jr nz, DrawCommandsSkipEE

;> return DrawCommandsLoop(cmds)

;@ def DrawCommandsLoop(cmds: de)
;@ path: gfx/bgmap
;@ The loop of DrawCommands: stops at the 0 that ends the list.
DrawCommandsLoop::
;> if mem[cmds] != 0: return DrawNextCommand(mem[cmds], cmds)
	ld a, [de]
	and a
	jr nz, DrawNextCommand

;> return
	ret


;@ def DrawNextCommandSkipEE(high: a, cmds: de)
;@ path: gfx/bgmap
;@ Like DrawNextCommand, for the commands drawn during a room scroll.
DrawNextCommandSkipEE::
;> dest = (high << 8) | mem[cmds + 1]
	inc de
	ld h, a
	ld a, [de]
	ld l, a
;> mode = mem[cmds + 2]
	inc de
	ld a, [de]
	inc de
;> cmds = ExecuteDrawCommandSkipEE(dest, mode, cmds + 3)
	call ExecuteDrawCommandSkipEE
;> return DrawCommandsSkipEE(cmds)

;@ def DrawCommandsSkipEE(cmds: de)
;@ path: gfx/bgmap
;@ Runs a list of draw commands with ExecuteDrawCommandSkipEE, until the 0 that ends the list.
DrawCommandsSkipEE::
;> if mem[cmds] != 0: return DrawNextCommandSkipEE(mem[cmds], cmds)
	ld a, [de]
	and a
	jr nz, DrawNextCommandSkipEE

;> return
	ret


;@ def ExecuteDrawCommand(dest: hl, mode: a, data: de) -> de
;@ path: gfx/bgmap
;@ Runs one draw command (see DrawCommands) at VRAM address `dest` with the bytes at `data`; returns the
;@ address after its data. Along a row the address wraps around within the 32-tile BG map row.
ExecuteDrawCommand::
;> count = (mode & 0x3F) + 1
	push af
	and $3f
	ld b, a
	inc b
	pop af
;> kind = mode >> 6
	rlca
	rlca
	and $03
;> if kind == 1:                            # one byte repeated along the row
	jr z, .copyRow

	dec a
	jr z, .fillRow

;>@b0     for _ in range(count):
;>@b1         mem[dest] = mem[data]; dest += 1
;>@b2         if dest & 0x1F == 0: dest -= 0x20   # stay on the same BG map row
;>@b3     return data + 1
;> elif kind == 2:                          # copy down the column
	dec a
	jr z, .copyColumn

;>@c0     for _ in range(count):
;>@c1         mem[dest] = mem[data]; data += 1
;>@c2         dest += 0x20
;>@c3     return data
;> elif kind == 3:                          # one byte repeated down the column
	jr .fillColumn

;>@d0     for _ in range(count):
;>@d1         mem[dest] = mem[data]
;>@d2         dest += 0x20
;>@d3     return data + 1
;> else:                                    # copy along the row
;>@a0     for _ in range(count):
.copyRow
;>         mem[dest] = mem[data]; dest += 1
	ld a, [de]
	ld [hli], a
;>@a2         if dest & 0x1F == 0: dest -= 0x20   # stay on the same BG map row
	ld a, l
	and $1f
	jr nz, .copyRowNext

;=@a2
	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

.copyRowNext
;>         data += 1
	inc de
;=@a0
	dec b
	jr nz, .copyRow

;>     return data
	ret

.fillRow
;=@b1
	ld a, [de]
	ld [hli], a
;=@b2
	ld a, l
	and $1f
	jr nz, .fillRowNext

;=@b2
	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

.fillRowNext
;=@b0
	dec b
	jr nz, .fillRow

;=@b3
	inc de
	ret

.copyColumn
;=@c1
	ld a, [de]
	ld [hl], a
	inc de
;=@c2
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
;=@c0
	dec b
	jr nz, .copyColumn

;=@c3
	ret

.fillColumn
;=@d1
	ld a, [de]
	ld [hl], a
;=@d2
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
;=@d0
	dec b
	jr nz, .fillColumn

;=@d3
	inc de
	ret


;@ def ExecuteDrawCommandSkipEE(dest: hl, mode: a, data: de) -> de
;@ path: gfx/bgmap
;@ The draw command of a room scroll: copies count = (mode & $3F) + 1 bytes from `data` along a BG map row
;@ (mode bit 7 clear; the address wraps within the row) or down a column (bit 7 set). Bytes $EE are not
;@ written (along a row the address then does not move on either - $EE is only used at the end). Returns
;@ the address after the data.
ExecuteDrawCommandSkipEE::
;> count = (mode & 0x3F) + 1
	push af
	and $3f
	ld b, a
	inc b
	pop af
;> if mode & 0x80:                          # down a column
	and $80
	jr nz, .column

;>@e0     for _ in range(count):
;>@e1         if mem[data] != 0xEE: mem[dest] = mem[data]
;>@e2         data += 1; dest += 0x20
;>@e3     return data
;> else:                                    # along a row
;>@r0     for _ in range(count):
.row
;>         if mem[data] != 0xEE:
	ld a, [de]
	cp $ee
	jr z, .rowNext

;>             mem[dest] = mem[data]; dest += 1
	ld [hli], a
;>@w             if dest & 0x1F == 0: dest -= 0x20
	ld a, l
	and $1f
	jr nz, .rowNext

;=@w
	ld a, l
	sub $20
	ld l, a
	ld a, h
	sbc $00
	ld h, a

.rowNext
;>         data += 1
	inc de
;=@r0
	dec b
	jr nz, .row

;>     return data
	ret

.column
;=@e1
	ld a, [de]
	cp $ee
	jr z, .columnNext

	ld [hl], a

.columnNext
;=@e2
	inc de
	ld a, b
	ld bc, $0020
	add hl, bc
	ld b, a
;=@e0
	dec b
	jr nz, .column

;=@e3
	ret


;@ def ClearWRAM1600()
;@ path: system/memory
;@ Clears $C000-$D5FF (the end of ClearHRAMAndWRAM does it).
ClearWRAM1600::
;> return ClearMemory(wOAMBuffer, 0x1600)
	ld bc, $1600
	jr jr_000_2996

;@ def ClearWRAM1300()
;@ path: system/memory
;@ Clears $C000-$D2FF (the end of ClearHRAMAndWRAM does it).
ClearWRAM1300::
;> return ClearMemory(wOAMBuffer, 0x1300)
	ld bc, $1300
	jr jr_000_2996

;@ def ClearHRAMPartAndWRAM()
;@ path: system/memory
;@ Clears HRAM $FF90-$FFBE and WRAM $C000-$DEFF (going on in ClearHRAMAndWRAM). Called from bank 1.
ClearHRAMPartAndWRAM::
;> ClearMemory(hNeedsUpdatingBGTiles, 0x2F)  # (done by the rest of ClearHRAMAndWRAM)
	ld bc, $002f
;> return ClearMemory(wOAMBuffer, 0x1F00)
	jr ClearHRAMFromFF90

;@ def ClearHRAMAndWRAM()
;@ path: system/memory
;@ Clears HRAM $FF90-$FFFC and WRAM $C000-$DEFF (the stack at the top of WRAM is left alone).
ClearHRAMAndWRAM::
;> count = 0x6D
	ld bc, $006d

ClearHRAMFromFF90:
;> ClearMemory(hNeedsUpdatingBGTiles, count)   # HRAM from $FF90
	ld hl, hNeedsUpdatingBGTiles
	call ClearMemory
;> count = 0x1F00
	ld bc, $1f00

jr_000_2996:
;> return ClearMemory(wOAMBuffer, count)      # WRAM from $C000
	ld hl, wOAMBuffer

;@ def ClearMemory(addr: hl, count: bc)
;@ path: system/memory
;@ Sets `count` bytes (1-65536) from `addr` to 0.
ClearMemory::
;>@z fill(addr, 0, count)
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, ClearMemory

;> return
	ret


;@ path: unused
;@ 23 unused bytes ($FF) between two routines.
Padding29A1::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ def GetRoomInfo(room: de) -> a
;@ path: world/rooms
;@ The info byte of a room from the table at $14:$4500 (d = page: 0 overworld rooms, 1 and 2 the two
;@ indoor room sets, e = room number). Values seen in use: $19 and $1A mark rooms of special kinds.
GetRoomInfo::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> info = mem[0x4500 + room]
	ld hl, $4500
	add hl, de
	ld a, [hl]
;> set_rom_bank(wCurrentBank)
	jp RestoreBank
;> return info


;@ def PlayPeriodicNoiseSfx()
;@ path: sound/sfx
;@ Plays noise effect $2D, but only when wNoiseSfxCycle is 0 (once per cycle of $1A frames).
PlayPeriodicNoiseSfx::
;> if wNoiseSfxCycle == 0: hNoiseSfx = 0x2D
	ld a, [wNoiseSfxCycle]
	and a
	jr nz, .done

	ld a, $2d
	ldh [hNoiseSfx], a

.done
;> return
	ret


;@ def OpenRoomDialog()
;@ path: text/dialog
;@ Opens the dialog that a table in bank 1 gives for the current room (hMapRoom -> $01:$5707 -> dialog
;@ number at $01:$56B7; ShowCurrentPlaceName).
OpenRoomDialog::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> ShowCurrentPlaceName()
	call ShowCurrentPlaceName
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def GetObjectPhysics(obj: de) -> a
;@ path: object/physics
;@ The physics kind of room object e (wall, floor, water, pit, ...) from the table at $08:$5110; d = 0 for
;@ the overworld objects, 1 for the indoor ones (the callers pass wIsIndoor).
GetObjectPhysics::
;> set_rom_bank(0x08)
	ld a, $08
	ld [$2100], a
;> kind = mem[0x5110 + obj]
	ld hl, $5110
	add hl, de
	ld a, [hl]
;> set_rom_bank(wCurrentBank)
	jp RestoreBank
;> return kind


;@ def GetObjectPhysicsBank3(obj: de) -> a
;@ path: object/physics
;@ GetObjectPhysics for code in bank 3: switches bank 3 back in afterwards.
GetObjectPhysicsBank3::
;> set_rom_bank(0x08)
	ld a, $08
	ld [$2100], a
;> kind = mem[0x5110 + obj]
	ld hl, $5110
	add hl, de
	ld a, [hl]
;> set_rom_bank(0x03)
	push af
	ld a, $03
	ld [$2100], a
	pop af
;> return kind
	ret


;@ def LoadTileset1E()
;@ path: gfx/tilesets
;@ Tile set request $1E (TileMapLoaders): $13:$6800 -> $9000 ($800 bytes) and $13:$7000 -> $8800 ($800).
LoadTileset1E::
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;> CopyData(0x6800, 0x9000, 0x800)
	ld hl, $6800
	ld de, $9000
	ld bc, $0800
	call CopyData
;> CopyData(0x7000, 0x8800, 0x800)
	ld hl, $7000
	ld de, $8800
	ld bc, $0800
	jp CopyData


;@ def LoadTileset1F()
;@ path: gfx/tilesets
;@ Tile set request $1F (the ending starts with it): LoadTileset15, then $13:$7600 -> $8400 ($100 bytes).
LoadTileset1F::
;> LoadTileset15()
	call LoadTileset15
;> CopyData(0x7600, 0x8400, 0x100)
	ld de, $8400
	ld hl, $7600
	ld bc, $0100
	jp CopyData


;@ def LoadTileset15()
;@ path: gfx/tilesets
;@ Tile set request $15: $13:$4000 -> $8000 ($1800 bytes: all tiles), $0C:$57E0 -> $97F0 (one tile),
;@ $12:$7500 -> $8000 ($40) and $12:$7500 -> $8D00 ($200).
LoadTileset15::
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;> CopyData(0x4000, 0x8000, 0x1800)
	ld hl, $4000
	ld de, $8000
	ld bc, $1800
	call CopyData
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> CopyData(0x57E0, 0x97F0, 0x10)
	ld hl, $57e0
	ld de, $97f0
	ld bc, $0010
	call CopyData
;> set_rom_bank(0x12)
	ld a, $12
	ld [$2100], a
;> CopyData(0x7500, 0x8000, 0x40)
	ld hl, $7500
	ld de, $8000
	ld bc, $0040
	call CopyData
;> CopyData(0x7500, 0x8D00, 0x200)
	ld de, $8d00
	ld hl, $7500
	ld bc, $0200
	jp CopyData


;@ def LoadTileset1D()
;@ path: gfx/tilesets
;@ Tile set request $1D: $0C:$5000 -> $9000, $12:$6000 -> $8000 and $0F:$6000 -> $8800 ($800 bytes each).
LoadTileset1D::
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> CopyData(0x5000, 0x9000, 0x800)
	ld hl, $5000
	ld de, $9000
	ld bc, $0800
	call CopyData
;> set_rom_bank(0x12)
	ld a, $12
	ld [$2100], a
;> CopyData(0x6000, 0x8000, 0x800)
	ld hl, $6000
	ld de, $8000
	ld bc, $0800
	call CopyData
;> set_rom_bank(0x0F)
	ld a, $0f
	ld [$2100], a
;> CopyData(0x6000, 0x8800, 0x800)
	ld hl, $6000
	ld de, $8800
	ld bc, $0800
	jp CopyData


;@ def LoadTileset18()
;@ path: gfx/tilesets
;@ Tile set request $18: $13:$4000 -> $8000 ($800), then $13:$5800 -> $8800 ($1000) (the code of
;@ LoadTileset16 from jr_000_2aa5 does it).
LoadTileset18::
;> set_rom_bank(0x13); CopyData(0x4000, 0x8000, 0x800)
	ld hl, $4000
;> return CopyData(0x5800, 0x8800, 0x1000)
	jr jr_000_2aa5

;@ def LoadTileset17()
;@ path: gfx/tilesets
;@ Tile set request $17: $13:$4800 -> $8000 ($800), then $13:$5800 -> $8800 ($1000) (the code of
;@ LoadTileset16 from jr_000_2aa5 does it).
LoadTileset17::
;> set_rom_bank(0x13); CopyData(0x4800, 0x8000, 0x800)
	ld hl, $4800
;> return CopyData(0x5800, 0x8800, 0x1000)
	jr jr_000_2aa5

;@ def LoadTileset16()
;@ path: gfx/tilesets
;@ Tile set request $16: $13:$6000 -> $8000 ($800), then $13:$5800 -> $8800 ($1000). Requests $17 and $18
;@ use the same code with another source for the first part (jr_000_2aa5).
LoadTileset16::
;> src = 0x6000
	ld hl, $6000

jr_000_2aa5:
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;> CopyData(src, 0x8000, 0x800)
	ld de, $8000
	ld bc, $0800
	call CopyData
;> CopyData(0x5800, 0x8800, 0x1000)
	ld hl, $5800
	ld de, $8800
	ld bc, $1000
	jp CopyData


;@ def LoadTileset1B()
;@ path: gfx/tilesets
;@ Tile set request $1B: LoadTilesetFromBank($10, $6800), $12:$6600 -> $8000 ($80) and $0C:$4220 -> $8100
;@ ($20). Keeps the music going between the copies (UpdateSound).
LoadTileset1B::
;> UpdateSound()
	call UpdateSound
;> LoadTilesetFromBank(0x10, 0x6800)
	ld hl, $6800
	ld a, $10
	call LoadTilesetFromBank
;> UpdateSound()
	call UpdateSound
;> set_rom_bank(0x12)
	ld a, $12
	ld [$2100], a
;> CopyData(0x6600, 0x8000, 0x80)
	ld hl, $6600
	ld de, $8000
	ld bc, $0080
	call CopyData
;> UpdateSound()
	call UpdateSound
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> CopyData(0x4220, 0x8100, 0x20)
	ld hl, $4220
	ld de, $8100
	ld bc, $0020
	jp CopyData


;@ def LoadTileset1A()
;@ path: gfx/tilesets
;@ Tile set requests $1A and $1C: LoadTilesetFromBank($13, $7800).
LoadTileset1A::
;> return LoadTilesetFromBank(0x13, 0x7800)
	ld hl, $7800
	jr jr_000_2afa

;@ def LoadTileset19()
;@ path: gfx/tilesets
;@ Tile set request $19: LoadTilesetFromBank($13, $4800).
LoadTileset19::
;> src = 0x4800
	ld hl, $4800

jr_000_2afa:
;> return LoadTilesetFromBank(0x13, src)
	ld a, $13

;@ def LoadTilesetFromBank(bank: a, src: hl)
;@ path: gfx/tilesets
;@ Copies $800 bytes from `src` in bank `bank` to $8000 (the first sprite tiles), then $13:$7000 -> $8800
;@ and $13:$6800 -> $9000 ($800 each).
LoadTilesetFromBank::
;> set_rom_bank(bank)
	ld [$2100], a
;> CopyData(src, 0x8000, 0x800)
	ld de, $8000
	ld bc, $0800
	call CopyData
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;> CopyData(0x7000, 0x8800, 0x800)
	ld hl, $7000
	ld de, $8800
	ld bc, $0800
	call CopyData
;> CopyData(0x6800, 0x9000, 0x800)
	ld hl, $6800
	ld de, $9000
	ld bc, $0800
	jp CopyData


;@ def GetDungeonRoomStatusAddress(pos: de) -> hl
;@ path: world/dungeon
;@ For a square `pos` (0-63) of the current dungeon's 8x8 map grid: the address of that room's status byte
;@ in wRoomStatus. The room number comes from the dungeon's grid in the table at $14:$4200 (64 bytes per
;@ dungeon; dungeon 7 has a second grid at $14:$44C0 used once wDungeon7Flags bit 2 is set). Only for maps
;@ below $0B (for others hl is not a room address). The maps 6-$19 use the second group of indoor rooms.
GetDungeonRoomStatusAddress::
;> set_rom_bank(0x14)
	push bc
	ld a, $14
	ld [$2100], a
;> grid = 0x4200
	ld hl, $4200
;> if hMapId < 0x0B:
	ldh a, [hMapId]
	cp $0b
	jr nc, .done

;>     offset = hMapId << 4
	swap a
	ld c, a
	ld b, $00
;>     offset *= 4                          # 64 bytes per dungeon
	sla c
	rl b
	sla c
	rl b
;>     grid += offset
	add hl, bc
;>@d7     if hMapId == 6 and wDungeon7Flags & 4: grid = 0x44C0   # dungeon 7's second layout
	ldh a, [hMapId]
	cp $06
	jr nz, .haveGrid

	ld a, [wDungeon7Flags]
	and $04
	jr z, .haveGrid

;=@d7
	ld hl, $44c0

.haveGrid
;>     room = mem[grid + pos]
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, $00
;>     if 0x06 <= hMapId < 0x1A: room += 0x100   # the second indoor group
	ldh a, [hMapId]
	cp $1a
	jr nc, .firstGroup

	cp $06
	jr c, .firstGroup

	inc d

.firstGroup
;>     grid = wRoomStatus + 0x100 + room       # (the indoor groups start at $D900)
	ld hl, $d900
	add hl, de

.done
;> set_rom_bank(wCurrentBank)
	call RestoreBank
	pop bc
;> return grid
	ret


;@ def LoadTileset03()
;@ path: gfx/tilesets
;@ Tile set request 3, the menu tiles from bank $0C: $4000 -> $8000 ($400), $4800 -> $8800 ($1000) and
;@ $47A0 -> $8E00 ($20). Ends with bank 1 switched in.
LoadTileset03::
;> SwitchBank(0x0C)
	ld a, $0c
	call SwitchBank
;> CopyData(0x4000, 0x8000, 0x400)
	ld hl, $4000
	ld de, $8000
	ld bc, $0400
	call CopyData
;> SwitchBank(0x0C)
	ld a, $0c
	call SwitchBank
;> CopyData(0x4800, 0x8800, 0x1000)
	ld hl, $4800
	ld de, $8800
	ld bc, $1000
	call CopyData
;> CopyData(0x47A0, 0x8E00, 0x20)
	ld hl, $47a0
	ld de, $8e00
	ld bc, $0020
	call CopyData
;> SwitchBank(0x01)
	ld a, $01
	call SwitchBank
;> return
	ret


;@ def LoadTileset04()
;@ path: gfx/tilesets
;@ Tile set request 4: LoadTileset03, then $0F:$4000 -> $8800 ($400) and $0F:$5000 -> $9000 ($800).
LoadTileset04::
;> LoadTileset03()
	call LoadTileset03
;> SwitchBank(0x0F)
	ld a, $0f
	call SwitchBank
;> CopyData(0x4000, 0x8800, 0x400)
	ld hl, $4000
	ld de, $8800
	ld bc, $0400
	call CopyData
;> SwitchBank(0x0F)
	ld a, $0f
	call SwitchBank
;> CopyData(0x5000, 0x9000, 0x800)
	ld hl, $5000
	ld de, $9000
	ld bc, $0800
	jp CopyData


;@ def LoadTileset06()
;@ path: gfx/tilesets
;@ Tile set request 6, the tiles of an indoor map (hMapId): three tables in bank 1 give, per map, the high
;@ byte of a $100-aligned source: $01:$7F64 -> $0D:xx00 to $9100 ($100 bytes), $01:$7F84 -> xx00 to $9200
;@ ($200, after $0D:$4000 -> $9200 $600), $01:$7FA4 -> $12:xx00 to $8F00 ($100). Also $0C:$47C0 -> $DCC0
;@ ($40), the common world tiles, and $12:$7D00 (dungeons) or $0C:$4C00 (other maps) -> $8C00 ($300). Ends
;@ with LoadWorldItemTiles.
LoadTileset06::
;> SwitchBank(0x01)
	ld a, $01
	call SwitchBank
;> map = hMapId
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	push de
;> src = mem[0x7F64 + map] << 8
	ld hl, $7f64
	add hl, de
	ld h, [hl]
	ld l, $00
;> SwitchBank(0x0D)
	ld a, $0d
	call SwitchBank
;> CopyData(src, 0x9100, 0x100)
	ld de, $9100
	ld bc, $0100
	call CopyData
;> CopyData(0x4000, 0x9200, 0x600)
	ld hl, $4000
	ld de, $9200
	ld bc, $0600
	call CopyData
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> src = mem[0x7F84 + map] << 8
	pop de
	push de
	ld hl, $7f84
	add hl, de
	ld h, [hl]
	ld l, $00
;> set_rom_bank(wCurrentBank)               # bank $0D again
	call RestoreBank
;> CopyData(src, 0x9200, 0x200)
	ld de, $9200
	ld bc, $0200
	call CopyData
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> CopyData(0x47C0, 0xDCC0, 0x40)
	ld hl, $47c0
	ld de, $dcc0
	ld bc, $0040
	call CopyData
;> LoadCommonWorldTiles()
	call LoadCommonWorldTiles
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> src = mem[0x7FA4 + map] << 8
	pop de
	ld hl, $7fa4
	add hl, de
	ld h, [hl]
	ld l, $00
;> SwitchBank(0x12)
	ld a, $12
	call SwitchBank
;> CopyData(src, 0x8F00, 0x100)
	ld de, $8f00
	ld bc, $0100
	call CopyData
;> src = 0x7D00
	ld hl, $7d00
;> if hMapId >= 0x0A:                       # not a dungeon
	ldh a, [hMapId]
	cp $0a
	jr c, .haveSrc

;>     SwitchBank(0x0C)
	ld a, $0c
	call SwitchBank
;>     src = 0x4C00
	ld hl, $4c00

.haveSrc
;> CopyData(src, 0x8C00, 0x300)
	ld de, $8c00
	ld bc, $0300
	call CopyData
;> LoadWorldItemTiles()

;@ def LoadWorldItemTiles()
;@ path: gfx/tilesets
;@ The last part of loading the world tiles: the tiles that depend on the story - the Sleepy Toadstool
;@ while Link carries it, the golden leaves part once all 6 are found (not inside the dungeons), and a
;@ background change (request $0D) once the trading sequence is past its first item.
LoadWorldItemTiles::
;> if wHasToadstool: BGChangeTiles88E0Alt()
	ld a, [wHasToadstool]
	and a
	jr z, .noToadstool

	call BGChangeTiles88E0Alt

.noToadstool
;> if not wIsIndoor or hMapId >= 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, .notDungeon

	ldh a, [hMapId]
	cp $0a
	jr c, .tradeItem

.notDungeon
;>     if wGoldenLeaves >= 6: BGChangeTiles8CA0()
	ld a, [wGoldenLeaves]
	cp $06
	jr c, .tradeItem

	call BGChangeTiles8CA0

.tradeItem
;> if wTradeSequenceItem >= 2: hBGChangeRequest = 0x0D
	ld a, [wTradeSequenceItem]
	cp $02
	jr c, .done

	ld a, $0d
	ldh [hBGChangeRequest], a

.done
;> return
	ret


;@ def LoadTileset05()
;@ path: gfx/tilesets
;@ Tile set requests 5 and 7, the overworld tiles: $0C:$5200 -> $9200 ($600), $0C:$4C00 -> $8C00 ($400),
;@ the common world tiles, then LoadWorldItemTiles.
LoadTileset05::
;> SwitchBank(0x0C)
	ld a, $0c
	call SwitchBank
;> CopyData(0x5200, 0x9200, 0x600)
	ld hl, $5200
	ld de, $9200
	ld bc, $0600
	call CopyData
;> CopyData(0x4C00, 0x8C00, 0x400)
	ld hl, $4c00
	ld de, $8c00
	ld bc, $0400
	call CopyData
;> LoadCommonWorldTiles()
	call LoadCommonWorldTiles
;> return LoadWorldItemTiles()
	jp LoadWorldItemTiles


;@ def LoadCommonWorldTiles()
;@ path: gfx/tilesets
;@ The tiles every world map uses, from the bank the caller switched in ($0C): $4800 -> $8800 ($800) and
;@ $4200 -> $8200 ($100); restarts the animated background tiles first.
LoadCommonWorldTiles::
;> hAnimatedTilesFrameCount = 0
	xor a
	ldh [hAnimatedTilesFrameCount], a
;> hAnimatedTilesStep = 0
	ldh [hAnimatedTilesStep], a
;> RunAnimatedTiles()
	call RunAnimatedTiles
;> CopyData(0x4800, 0x8800, 0x800)
	ld hl, $4800
	ld de, $8800
	ld bc, $0800
	call CopyData
;> CopyData(0x4200, 0x8200, 0x100)
	ld hl, $4200
	ld de, $8200
	ld bc, $0100
	call CopyData
;> return
	ret


;@ def LoadTileset10()
;@ path: gfx/tilesets
;@ Tile set request $10: $01:$7D31 -> $8700 ($80), $10:$5400 -> $8000 ($600), $10:$4000 -> $8800 ($1000).
LoadTileset10::
;> SwitchBank(0x01)
	ld a, $01
	call SwitchBank
;> CopyData(0x7D31, 0x8700, 0x80)
	ld hl, $7d31
	ld de, $8700
	ld bc, $0080
	call CopyData
;> SwitchBank(0x10)
	ld a, $10
	call SwitchBank
;> CopyData(0x5400, 0x8000, 0x600)
	ld hl, $5400
	ld de, $8000
	ld bc, $0600
	call CopyData
;> CopyData(0x4000, 0x8800, 0x1000)
	ld hl, $4000
	ld de, $8800
	ld bc, $1000
	jp CopyData


;@ def LoadTileset11()
;@ path: gfx/tilesets
;@ Tile set request $11: $0F:$4900 -> $8800 ($700).
LoadTileset11::
;> SwitchBank(0x0F)
	ld a, $0f
	call SwitchBank
;> CopyData(0x4900, 0x8800, 0x700)
	ld hl, $4900
	ld de, $8800
	ld bc, $0700
	jp CopyData


;@ def LoadTileset0B()
;@ path: gfx/tilesets
;@ Tile set request $0B: $0C:$7800 -> $8F00 ($800) and $0C:$5000 -> $8200 ($100).
LoadTileset0B::
;> SwitchBank(0x0C)
	ld a, $0c
	call SwitchBank
;> CopyData(0x7800, 0x8F00, 0x800)
	ld hl, $7800
	ld de, $8f00
	ld bc, $0800
	call CopyData
;> CopyData(0x5000, 0x8200, 0x100)
	ld hl, $5000
	ld de, $8200
	ld bc, $0100
	jp CopyData


;@ def LoadTileset14()
;@ path: gfx/tilesets
;@ Tile set request $14: $10:$7000 -> $9000 ($800) (the code of LoadTileset12 from jr_000_2d2b).
LoadTileset14::
;> SwitchBank(0x10)
	ld hl, $7000
;> return CopyData(0x7000, 0x9000, 0x800)
	jr jr_000_2d2b

;@ def LoadTileset20()
;@ path: gfx/tilesets
;@ Tile set request $20: $10:$7800 -> $9000 ($800) (the code of LoadTileset12 from jr_000_2d2b).
LoadTileset20::
;> SwitchBank(0x10)
	ld hl, $7800
;> return CopyData(0x7800, 0x9000, 0x800)
	jr jr_000_2d2b

;@ def LoadTileset12()
;@ path: gfx/tilesets
;@ Tile set request $12: $10:$5800 -> $9000 ($800). Requests $14 and $20 use the same code with another
;@ source (jr_000_2d2b).
LoadTileset12::
;> src = 0x5800
	ld hl, $5800

jr_000_2d2b:
;> SwitchBank(0x10)
	ld a, $10
	call SwitchBank
;> CopyData(src, 0x9000, 0x800)
	ld de, $9000
	ld bc, $0800
	jp CopyData


;@ def LoadTileset21()
;@ path: gfx/tilesets
;@ Tile set request $21: $13:$7C00 -> $8C00 ($400) and $13:$6800 -> $9000 ($400).
LoadTileset21::
;> set_rom_bank(0x13)
	ld a, $13
	ld [$2100], a
;> CopyData(0x7C00, 0x8C00, 0x400)
	ld hl, $7c00
	ld de, $8c00
	ld bc, $0400
	call CopyData
;> CopyData(0x6800, 0x9000, 0x400)
	ld hl, $6800
	ld de, $9000
	ld bc, $0400
	jp CopyData


;@ def LoadTileset13()
;@ path: gfx/tilesets
;@ Tile set request $13: $10:$6700 -> $8400 ($400) and $10:$6000 -> $9000 ($600).
LoadTileset13::
;> SwitchBank(0x10)
	ld a, $10
	call SwitchBank
;> CopyData(0x6700, 0x8400, 0x400)
	ld hl, $6700
	ld de, $8400
	ld bc, $0400
	call CopyData
;> CopyData(0x6000, 0x9000, 0x600)
	ld hl, $6000
	ld de, $9000
	ld bc, $0600
	jp CopyData


;@ def LoadTileset0D()
;@ path: gfx/tilesets
;@ Tile set request $0D (the save and game over menus): $0F:$4400 -> $8800 ($500).
LoadTileset0D::
;> SwitchBank(0x0F)
	ld a, $0f
	call SwitchBank
;> CopyData(0x4400, 0x8800, 0x500)
	ld hl, $4400
	ld de, $8800
	ld bc, $0500
	jp CopyData


;@ path: gfx/tilesets
;@ ROM bank of each group of entity tile sets (index = bits 6-7 of a wLoadedEntityTilesets entry): $00
;@ (reads as bank 1 on this cartridge), $11, $0E, $12. The set's page (bits 0-5) is the high byte of its
;@ address minus $40.
EntityTilesBanks::
	db $00, $11, $0e, $12

;@ def LoadTileset09()
;@ path: gfx/tilesets
;@ Tile set request 9, used when entering a room: copies the four entity tile sets of wLoadedEntityTilesets
;@ ($100 bytes each) to $8400-$87FF. On the overworld and in some indoor places slot 0 is taken by whoever
;@ follows Link (BowWow $A4, the ghost $D8, the rooster $DD, Marin $8F). Then the room's background tile
;@ set: overworld $0F:(hWorldTileset + $40)00 -> $9000 ($200 bytes; not for set $0F); indoors
;@ $0D:(hWorldTileset + $50)00 -> $9000 ($100; not for $FF); in side-view areas $0D:$7000 or $0D:$7800
;@ -> $9000 ($800).
LoadTileset09::
;> slot = 0
	xor a

Jump_000_2d89:
;> while True:
;>     hMultiPurpose0 = slot
	ldh [hMultiPurpose0], a
;>     entry = addr(wLoadedEntityTilesets) + slot
	ld hl, wLoadedEntityTilesets
	ld e, a
	ld d, $00
	add hl, de
;>@fl     tiles = mem[entry]
;>@fw     if slot == 0 and (not wIsIndoor or not (hIsSideScrolling or hMapId == 0x14 or hMapId < 0x0A or hMapRoom in (0xFD, 0xB1))):
	and a
	jr nz, .fromList

	ld a, [wIsIndoor]
	and a
	jr z, .follower

;=@fw
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .fromList

	ldh a, [hMapId]
	cp $14
	jr z, .fromList

;=@fw
	cp $0a
	jr c, .fromList

	ldh a, [hMapRoom]
	cp $fd
	jr z, .fromList

;=@fw
	cp $b1
	jr z, .fromList

.follower
;>         if wIsBowWowFollowingLink == 1: tiles = 0xA4   # whoever follows Link takes slot 0
	ld a, [wIsBowWowFollowingLink]
	cp $01
	ld a, $a4
	jr z, .haveSet

;>         elif wIsGhostFollowingLink: tiles = 0xD8
	ld a, [wIsGhostFollowingLink]
	and a
	ld a, $d8
	jr nz, .haveSet

;>         elif wIsRoosterFollowingLink: tiles = 0xDD
	ld a, [wIsRoosterFollowingLink]
	and a
	ld a, $dd
	jr nz, .haveSet

;>@mr         elif wIsMarinFollowingLink: tiles = 0x8F
	ld a, [wIsMarinFollowingLink]
	and a
	jr z, .fromList

	ld a, $8f

.haveSet
;=@mr
	jr .gotSet

.fromList
;=@fl
	ld a, [hl]

.gotSet
;>     page = tiles & 0x3F
	push af
	and $3f
	ld b, a
	ld c, $00
	pop af
;>     group = tiles >> 6
	swap a
	rra
	rra
	and $03
	ld e, a
	ld d, $00
;>     set_rom_bank(mem[EntityTilesBanks + group])
	ld hl, EntityTilesBanks
	add hl, de
	ld a, [hl]
	ld [$2100], a
;>     dest = 0x8400 + slot * 0x100
	ldh a, [hMultiPurpose0]
	ld d, a
	ld e, $00
	ld hl, $8400
	add hl, de
	push hl
;>     CopyData(0x4000 + page * 0x100, dest, 0x100)
	pop de
	ld hl, $4000
	add hl, bc
	ld bc, $0100
	call CopyData
;>     slot += 1
	ldh a, [hMultiPurpose0]
	inc a
;>     if slot == 4: break
	cp $04
	jp nz, Jump_000_2d89

;> if not wIsIndoor:
	ld de, $9000
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

;>@in     set_rom_bank(0x0F)
;>@ov     if hWorldTileset != 0x0F: CopyData((hWorldTileset + 0x40) << 8, 0x9000, 0x200)
;>@ret     return
;> set_rom_bank(0x0D)
	ld a, $0d
	ld [$2100], a
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .indoorRoom

;>     src = 0x7000
	ld hl, $7000
;>@sv     if hMapId != 6 and (hMapId < 0x0A or hMapRoom == 0xE9): src = 0x7800
	ldh a, [hMapId]
	cp $06
	jr z, .sideViewSrc

	cp $0a
	jr nc, .checkRoom

.src7800
;=@sv
	ld hl, $7800
	jr .sideViewSrc

.checkRoom
;=@sv
	ldh a, [hMapRoom]
	cp $e9
	jr z, .src7800

.sideViewSrc
;>     CopyData(src, 0x9000, 0x800)
	ld de, $9000
	ld bc, $0800
	call CopyData
;>     return
	ret

.indoorRoom
;>@is if hWorldTileset != 0xFF: CopyData((hWorldTileset + 0x50) << 8, 0x9000, 0x100)
	ld hl, $5000
	ldh a, [hWorldTileset]
	cp $ff
	jr z, .noIndoorSet

;=@is
	add $50
	ld h, a
	ld bc, $0100
	call CopyData

.noIndoorSet
;> return
	ret

.overworld
;=@in
	ld a, $0f
	ld [$2100], a
;=@ov
	ldh a, [hWorldTileset]
	cp $0f
	jr z, .noOverworldSet

;=@ov
	add $40
	ld h, a
	ld l, $00
	ld bc, $0200
	call CopyData

.noOverworldSet
;=@ret
	ret


;@ def LoadTileset01()
;@ path: world/drawing
;@ Tile set request 1: draws the whole room into BG map 0 with the LCD off - each object of wRoomObjects
;@ becomes its four tiles (from bank 8: $498C overworld, $4D60 indoors; top left, top right, bottom left,
;@ bottom right), 10 objects per row. It walks 128 objects, so rows beyond the 8 of a room are drawn too
;@ (below the screen). Ends in bank 1 ($01:$7DC1).
LoadTileset01::
;> SwitchBank(0x08)
	ld a, $08
	call SwitchBank
;> dest = 0x9800
	ld de, $9800
;> obj = addr(wRoomObjects)
	ld hl, wRoomObjects
;>@ob for _ in range(128):
	ld c, $80

.object
;>@tl     tiles = (0x4D60 if wIsIndoor else 0x498C) + mem[obj] * 4
	push de
	push hl
	push bc
	ld a, [hl]
	ld c, a
	ld b, $00
;=@tl
	sla c
	rl b
	sla c
	rl b
	ld hl, $498c
	ld a, [wIsIndoor]
;=@tl
	and a
	jr z, .overworld

	ld hl, $4d60

.overworld
;=@tl
	add hl, bc
;>     mem[dest] = mem[tiles]; mem[dest + 1] = mem[tiles + 1]   # the top row
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
;>     row2 = dest + 0x20                   # the tile row below
	ld a, e
	add $1f
	ld e, a
	ld a, d
	adc $00
	ld d, a
;>     mem[row2] = mem[tiles + 2]; mem[row2 + 1] = mem[tiles + 3]
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop bc
;>     obj += 1
	pop hl
	pop de
	inc hl
;>@or     if obj & 0x0F == 0x0B: obj = (obj & 0xF0) + 0x11   # past column 10: next row of objects
	ld a, l
	and $0f
	cp $0b
	jr nz, .sameObjectRow

	ld a, l
	and $f0
;=@or
	add $11
	ld l, a

.sameObjectRow
;>     dest += 2
	ld a, e
	add $02
	ld e, a
;>@dr     if dest & 0x1F == 0x14: dest = (dest & 0xFFE0) + 0x40   # past tile column 20: two tile rows down
	and $1f
	cp $14
	jr nz, .sameTileRow

	ld a, e
	and $e0
	add $40
;=@dr
	ld e, a
	ld a, d
	adc $00
	ld d, a

.sameTileRow
;=@ob
	dec c
	jr nz, .object

;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> return DisabledDungeonMarker()
	jp DisabledDungeonMarker


;@ def LoadRoom()
;@ path: world/rooms
;@ Loads the room hMapRoom of the current map: resets the per-room state, marks the room as visited in
;@ wRoomStatus (hRoomStatus gets its flags), reads the dungeon room number from the map grid and the room's
;@ event (bank $14), then reads the room's object data and builds wRoomObjects.
;@ Object data: overworld rooms $00-$7F in bank 9, $80-$FF in bank $1A (pointer table at $4000 of bank 9,
;@ two bytes per room); indoor rooms in bank $0A (first group) or $0B (maps 6-$19), pointer table at $4000.
;@ Six overworld rooms have a second layout once their event is done (status bit 4), and one room of map
;@ $1F looks different while Link has the magnifying lens. The data:
;@   byte 0   animated tiles group (hAnimatedTilesGroup); $FE = no objects at all
;@   byte 1   overworld: the object that fills the room; indoors: floor object (low nibble) and wall
;@            template (high nibble, ApplyIndoorRoomTemplate)
;@   then     records until $FE: a warp ($E0-$E3 + 4 bytes, copied to wWarpType + 5 * n; the low two bits are
;@            the kind of destination) or an object (LoadRoomObject: [count] position type)
;@ Ends with FillRoomObjectsBorder in bank 1.
LoadRoom::
;> rIE = 1                                  # only the VBlank interrupt while the room loads
	ld a, $01
	ldh [rIE], a
;> wRoomLoadCounter += 1
	ld hl, wRoomLoadCounter
	inc [hl]
;> set_rom_bank(0x09)
	ld a, $09
	ld [$2100], a
;> hMultiPurposeF = 0                       # bytes of warp records read so far
	xor a
	ldh [hMultiPurposeF], a
;> wRoomDoorCount = 0
	ld [wRoomDoorCount], a
;> mem[0xC504] = 0
	ld [$c504], a
;> wWarpTimer = 0
	ld [wWarpTimer], a
;> mem[0xDBC9] = 0
	ld [$dbc9], a
;> mem[0xC1A2] = 0
	ld [wRoomEventCounter], a
;> mem[0xC1C6] = 0
	ld [wHookshotOut], a
;> mem[0xD6FA] = 0
	ld [$d6fa], a
;> mem[0xC50A] = 0
	ld [wItemButtonsDisabled], a
;> hStairsState = 0
	ldh [hStairsState], a
;> mem[0xC113] = 0
	ld [$c113], a
;> mem[0xD460] = 0
	ld [$d460], a
;> wBossInRoom = 0
	ld [wBossInRoom], a
;> mem[0xC50E] = 0
	ld [wRoomNoiseLoop], a
;> wMarinSinging = 0
	ld [wMarinSinging], a
;> wRoomEventJustDone = 0
	ld [wRoomEventJustDone], a
;> wCompassChimeDelay = 0
	ld [wCompassChimeDelay], a
;> mem[0xC3CD] = 0
	ld [wRoomDarkness], a
;> wWarpType = 0xFF                         # no warp record yet
	ld a, $ff
	ld [wWarpType], a
;> wSingingMarinSlot = 0xFF
	ld [wSingingMarinSlot], a
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .status

;>     set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;>     hBGTilesRequestCopy = 0x14           # (scratch here: the bank in use)
	ldh [hBGTilesRequestCopy], a
;>     if hMapId < 0x0B:                    # a dungeon: the room number comes from its map grid
	ldh a, [hMapId]
	cp $0b
	jr nc, .haveRoom

;>@gr         grid = 0x4200 + hMapId * 64
	ld hl, $4200
	swap a
	ld e, a
	ld d, $00
	sla e
	rl d
;=@gr
	sla e
	rl d
	add hl, de
;>@d7         if hMapId == 6 and wDungeon7Flags & 4: grid = 0x44C0   # dungeon 7's second layout
	ldh a, [hMapId]
	cp $06
	jr nz, .haveGrid

	ld a, [wDungeon7Flags]
	and $04
	jr z, .haveGrid

;=@d7
	ld hl, $44c0

.haveGrid
;>         hMapRoom = mem[grid + wIndoorRoom]
	ld a, [wIndoorRoom]
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ldh [hMapRoom], a

.haveRoom
;>@rg     room = hMapRoom + (0x100 if 0x06 <= hMapId < 0x1A else 0)
	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
	ldh a, [hMapId]
	cp $1a
	jr nc, .firstGroup

;=@rg
	cp $06
	jr c, .firstGroup

	inc b

.firstGroup
;>     wRoomEvent = mem[0x4000 + room]      # the room's event (table in bank $14)
	ld hl, $4000
	add hl, bc
	ld a, [hl]
	ld [wRoomEvent], a
;>     wRoomShutterDoors = 0
	xor a
	ld [wRoomShutterDoors], a
;>     wRoomShutterDoorsCopy = 0
	ld [wRoomShutterDoorsCopy], a
;>     mem[0xC190] = 0
	ld [wRoomEventShuttersClosed], a
;>     wRoomEventDone = 0
	ld [wRoomEventDone], a
;>@cl     fill(addr(wDefeatedEntityCount), 0, 17)    # and the list wDefeatedEntities
	ld e, a
	ld hl, wDefeatedEntityCount

.clearDefeated
;=@cl
	xor a
	ld [hli], a
	inc e
	ld a, e
	cp $11
	jr nz, .clearDefeated

.status
;> base = wRoomStatus
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, wRoomStatus
;>@st if wIsIndoor: base = 0xDA00 if 0x06 <= hMapId < 0x1A else 0xD900   # the indoor groups
	ld a, [wIsIndoor]
	and a
	jr z, .haveBase

;=@st
	ld hl, $d900
	ldh a, [hMapId]
	cp $1a
	jr nc, .haveBase

	cp $06
	jr c, .haveBase

;=@st
	ld hl, $da00

.haveBase
;> status = base + hMapRoom
	add hl, de
;> if not hIsSideScrolling: mem[status] |= 0x80   # the room has been visited
	ldh a, [hIsSideScrolling]
	and a
	ld a, [hl]
	jr nz, .haveStatus

	or $80
	ld [hl], a

.haveStatus
;> hRoomStatus = mem[status]
	ldh [hRoomStatus], a
;> offset = hMapRoom * 2
	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
	sla c
	rl b
;> data = None
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .overworld

;>     set_rom_bank(0x0A)
	ld a, $0a
	ld [$2100], a
;>     hBGTilesRequestCopy = 0x0A
	ldh [hBGTilesRequestCopy], a
;>@lens     if hMapId == 0x1F and hMapRoom == 0xF5 and wTradeSequenceItem == 0x0E:
	ldh a, [hMapId]
	cp $1f
	jr nz, .indoorTable

	ldh a, [hMapRoom]
	cp $f5
	jr nz, .indoorTable

;=@lens
	ld a, [wTradeSequenceItem]
	cp $0e
	jr nz, .indoorTable

;>         data = 0x7853                    # with the magnifying lens this room looks different
	ld bc, $7853
	jp .readData

.indoorTable
;>     table = 0x4000
	ld hl, $4000
;>     if 0x06 <= hMapId < 0x1A:            # the second indoor group is in bank $0B
	ldh a, [hMapId]
	cp $1a
	jr nc, .readPointer

	cp $06
	jr c, .readPointer

;>         set_rom_bank(0x0B)
	ld a, $0b
	ld [$2100], a
;>         hBGTilesRequestCopy = 0x0B
	ldh [hBGTilesRequestCopy], a
;>         table = 0x4000
	ld hl, $4000
	jr .readPointer

.overworld
;> else:                                    # six overworld rooms change for good after their event
;>@o1     if hMapRoom == 0x0E and wRoomStatus[0x0E] & 0x10: data = 0x47F0
	ldh a, [hMapRoom]
	cp $0e
	jr nz, .room8C

	ld a, [$d80e]
	and $10
	jr z, .normalOverworld

;=@o1
	ld bc, $47f0
	jr .checkHighRoom

.room8C
;>@o2     elif hMapRoom == 0x8C and wRoomStatus[0x8C] & 0x10: data = 0x4356
	cp $8c
	jr nz, .room79

	ld a, [$d88c]
	and $10
	jr z, .normalOverworld

;=@o2
	ld bc, $4356
	jr .checkHighRoom

.room79
;>@o3     elif hMapRoom == 0x79 and wRoomStatus[0x79] & 0x10: data = 0x64FD
	cp $79
	jr nz, .room06

	ld a, [$d879]
	and $10
	jr z, .normalOverworld

;=@o3
	ld bc, $64fd
	jr .checkHighRoom

.room06
;>@o4     elif hMapRoom == 0x06 and wRoomStatus[0x06] & 0x10: data = 0x4496
	cp $06
	jr nz, .room1B

	ld a, [$d806]
	and $10
	jr z, .normalOverworld

;=@o4
	ld bc, $4496
	jr .checkHighRoom

.room1B
;>@o5     elif hMapRoom == 0x1B and wRoomStatus[0x2B] & 0x10: data = 0x4C13   # (room $2B's flag)
	cp $1b
	jr nz, .room2B

	ld a, [$d82b]
	and $10
	jr z, .normalOverworld

;=@o5
	ld bc, $4c13
	jr .checkHighRoom

.room2B
;>@o6     elif hMapRoom == 0x2B and wRoomStatus[0x2B] & 0x10: data = 0x50AC
	cp $2b
	jr nz, .normalOverworld

	ld a, [$d82b]
	and $10
	jr z, .normalOverworld

;=@o6
	ld bc, $50ac
	jr .checkHighRoom

.normalOverworld
;>     table = 0x4000
	ld hl, $4000

.readPointer
;> if data is None: data = mem16[table + offset]
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
;>@hi if not wIsIndoor and hMapRoom >= 0x80: set_rom_bank(0x1A)   # overworld rooms $80-$FF
	ld a, [wIsIndoor]
	and a
	jr nz, .readData

.checkHighRoom
;=@hi
	ldh a, [hMapRoom]
	cp $80
	jr c, .readData

	ld a, $1a
	ld [$2100], a

.readData
;> if mem[data] != 0xFE:                    # $FE: a room without objects
	ld a, [bc]
	cp $fe
	jr z, .done

;>     hAnimatedTilesGroup = mem[data]
	ldh [hAnimatedTilesGroup], a
;>     data += 1
	inc bc
;>     if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .overworldFill

;>         FillRoomObjects(mem[data] & 0x0F)        # the floor
	ld a, [bc]
	and $0f
	call FillRoomObjects
;>         ApplyIndoorRoomTemplate(mem[data] >> 4)  # the walls
	ld a, [bc]
	swap a
	and $0f
	call ApplyIndoorRoomTemplate
	jr .nextRecord

.overworldFill
;>     else:
;>         FillRoomObjects(mem[data])
	ld a, [bc]
	call FillRoomObjects

.nextRecord
;>     while True:
;>         data += 1
	inc bc
;>         if mem[data] & 0xFC == 0xE0:     # a warp record, 5 bytes
	ld a, [bc]
	and $fc
	cp $e0
	jr nz, .notWarp

;>             rec = addr(wWarpType) + hMultiPurposeF
	ldh a, [hMultiPurposeF]
	ld e, a
	ld d, $00
	ld hl, wWarpType
	add hl, de
;>             mem[rec] = mem[data] & 3     # the kind of destination
	ld a, [bc]
	and $03
	ld [hli], a
;>@wr             copy(rec + 1, data + 1, 4); data += 4
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
;=@wr
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
;>             hMultiPurposeF += 5
	ld a, e
	add $05
	ldh [hMultiPurposeF], a
	jr .nextRecord

.notWarp
;>         elif mem[data] == 0xFE: break    # the end
	ld a, [bc]
	cp $fe
	jr z, .done

;>         else: data = LoadRoomObject(data)
	call LoadRoomObject
	jr .nextRecord

.done
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> FillRoomObjectsBorder()
	call FillRoomObjectsBorder
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def LoadRoomObject(data: bc) -> bc
;@ path: world/rooms
;@ Reads one object record of the room data at `data` and places it: either "position type" (position =
;@ row << 4 | column in wRoomObjects) or "count position type" for a strip of the same object (count byte
;@ $8x / $Cx: bits 0-3 = length, bit 6 = downwards instead of to the right). Types from $F5 (overworld) or
;@ $EC (indoors) up are macros: shapes of several objects, doors (OverworldMacroHandlers,
;@ IndoorMacroHandlers). Returns `data` pointing at the record's last byte.
LoadRoomObject::
;> hMultiPurpose0 = 0                       # 0 = a single object
	xor a
	ldh [hMultiPurpose0], a
;> if mem[data] & 0x80 and not mem[data] & 0x10:   # a strip
	ld a, [bc]
	bit 7, a
	jr z, .single

	bit 4, a
	jr nz, .single

;>     hMultiPurpose0 = mem[data]; data += 1
	ldh [hMultiPurpose0], a
	inc bc

.single
;> data += 1                                # now at the type; the position is the byte before
	inc bc
;> status = hRoomStatus
	ldh a, [hRoomStatus]
	ld e, a
;> if wIsIndoor: return LoadRoomObjectIndoor(data, status)
	ld a, [wIsIndoor]
	and a
	jr nz, LoadRoomObjectIndoor

;> if mem[data] < 0xF5: return LoadOverworldObject(mem[data] - 0xF5, data, status)
	ld a, [bc]
	sub $f5
	jr c, LoadOverworldObject

;> return OverworldMacroHandlers[mem[data] - 0xF5](data)
	rst $00

;@ path: world/rooms
;@ Handlers of the overworld macro objects $F5-$FD (index = type - $F5): $F5 a tree (2x2, merging with the
;@ trees next to it), $F6-$FD buildings and other shapes of several objects (see their MacroShape tables).
OverworldMacroHandlers::
	dw OverworldMacroTree
	dw OverworldMacroF6
	dw OverworldMacroF7
	dw OverworldMacroF8
	dw OverworldMacroF9
	dw OverworldMacroFA
	dw OverworldMacroFB
	dw OverworldMacroFC
	dw OverworldMacroFD

;@ def LoadRoomObjectIndoor(data: bc, status: e) -> bc
;@ path: world/rooms
;@ The indoor part of LoadRoomObject: types $EC-$FD are the doors and other macros (IndoorMacroHandlers),
;@ the others single objects or strips (LoadIndoorObject).
LoadRoomObjectIndoor::
;> if mem[data] < 0xEC: return LoadIndoorObject(mem[data] - 0xEC, data, status)
	ld a, [bc]
	sub $ec
	jp c, LoadIndoorObject

;> return IndoorMacroHandlers[mem[data] - 0xEC](data)
	rst $00

;@ path: world/rooms
;@ Handlers of the indoor macro objects $EC-$FD (index = type - $EC): $EC-$EF doors that need a key (top,
;@ bottom, left, right; open once the room status says so), $F0-$F3 shutter doors, $F4-$F7 open doorways,
;@ $F8 the top door of the boss room, $F9-$FD other two- and more-object shapes.
IndoorMacroHandlers::
	dw DoorKeyTop
	dw DoorKeyBottom
	dw DoorKeyLeft
	dw DoorKeyRight
	dw DoorShutterTop
	dw DoorShutterBottom
	dw DoorShutterLeft
	dw DoorShutterRight
	dw DoorOpenTop
	dw DoorOpenBottom
	dw DoorOpenLeft
	dw DoorOpenRight
	dw DoorBossTop
	dw IndoorMacroF9
	dw IndoorMacroFA
	dw IndoorMacroFB
	dw IndoorMacroFC
	dw IndoorMacroFD

;@ def LoadOverworldObject(kind: a, data: bc, status: e) -> bc
;@ path: world/rooms
;@ An ordinary overworld object (type = kind + $F5). Some objects change with the room's status flags
;@ (things opened, burnt, dug up, ...): $5E -> $C6 and $91 -> $5E and $DC -> $91 (bit 5), $D8-$DA -> $DB,
;@ $C2 -> $E3 and $D3 -> $C6 in four rooms (bit 4), $BA -> $E1 (bit 2). The positions of the entrances
;@ ($C2 $E1 $CB $BA $61 $C6 $C5 $E2 $E3) are noted in the list at wWarpDestPosition, in the order of the
;@ room's warp records; $C5 and $C6 are stairs (RecordStairsObject).
;@ test: skip passes the object on the stack
LoadOverworldObject::
;> obj = kind + 0xF5
	add $f5
	push af
	ld d, a
;> if obj == 0xE9: mem[0xC50E] = obj
	cp $e9
	jr nz, .not_E9

	ld [wRoomNoiseLoop], a

.not_E9
;> if obj == 0x5E and status & 0x20: obj = 0xC6     # (done at .toC6 below)
	cp $5e
	jr nz, .not_5E

	bit 5, e
	jr nz, .toC6

.not_5E
;>@91 if obj == 0x91 and status & 0x20: obj = 0x5E
	cp $91
	jr nz, .not_91

	bit 5, e
	jr z, .not_91

;=@91
	pop af
	ld a, $5e
	ld d, a
	push af

.not_91
;>@dc if obj == 0xDC and status & 0x20: obj = 0x91
	cp $dc
	jr nz, .not_DC

	bit 5, e
	jr z, .not_DC

;=@dc
	pop af
	ld a, $91
	ld d, a
	push af

.not_DC
;>@d8 if obj in (0xD8, 0xD9, 0xDA) and status & 0x10: obj = 0xDB
	cp $d8
	jr z, .is_D8

	cp $d9
	jr z, .is_D8

	cp $da
	jr nz, .not_D8

.is_D8
;=@d8
	bit 4, e
	jr z, .not_D8

	pop af
	ld a, $db
	ld d, a
	push af

.not_D8
;>@c2 if obj == 0xC2 and status & 0x10: obj = 0xE3
	cp $c2
	jr nz, .not_C2

	bit 4, e
	jr z, .not_C2

;=@c2
	pop af
	ld a, $e3
	ld d, a
	push af

.not_C2
;>@ba if obj == 0xBA and status & 0x04: obj = 0xE1
	ld a, d
	cp $ba
	jr nz, .not_BA

	bit 2, e
	jr z, .not_BA

;=@ba
	pop af
	ld a, $e1
	ld d, a
	push af

.not_BA
;>@d3 if obj == 0xD3 and status & 0x10 and hMapRoom in (0x75, 0x07, 0xAA, 0x4A): obj = 0xC6
	ld a, d
	cp $d3
	jr nz, .haveObject

	bit 4, e
	jr z, .haveObject

;=@d3
	ldh a, [hMapRoom]
	cp $75
	jr z, .toC6

	cp $07
	jr z, .toC6

;=@d3
	cp $aa
	jr z, .toC6

	cp $4a
	jr nz, .haveObject

.toC6
;=@d3
	pop af
	ld a, $c6
	ld d, a
	push af

.haveObject
;> hMultiPurpose9 = obj
	ld a, d
	ldh [hMultiPurpose9], a
;>@ent if obj in (0xC2, 0xE1, 0xCB, 0xBA, 0x61, 0xC6, 0xC5, 0xE2, 0xE3):   # an entrance
	cp $c2
	jr z, .entrance

	cp $e1
	jr z, .entrance

	cp $cb
	jr z, .entrance

;=@ent
	cp $ba
	jr z, .entrance

	cp $61
	jr z, .entrance

	cp $c6
	jr z, .entrance

;=@ent
	cp $c5
	jr z, .entrance

	cp $e2
	jr z, .entrance

	cp $e3
	jr nz, .placeIt

.entrance
;>     n = wRoomDoorCount
	ld a, [wRoomDoorCount]
	ld e, a
;>     wRoomDoorCount = n + 1
	inc a
	ld [wRoomDoorCount], a
;>@wp     wWarpDestPosition[n] = mem[data - 1]  # its position
	ld d, $00
	ld hl, wWarpDestPosition
	add hl, de
	dec bc
	ld a, [bc]
	ld [hl], a
;=@wp
	inc bc

.placeIt
;> if obj in (0xC5, 0xC6): return RecordStairsObject(obj, data, status)
	ldh a, [hMultiPurpose9]
	cp $c5
	jp z, RecordStairsObject

	cp $c6
	jp z, RecordStairsObject

;> return PlaceRoomObject(obj, data, status)
	jp PlaceRoomObject


;@ def LoadIndoorObject(kind: a, data: bc, status: e) -> bc
;@ path: world/rooms
;@ An ordinary indoor object (type = kind + $EC). Notes some objects while the room loads (objects $CF-$D2
;@ are counted in $C1A5; $AB; raised-block objects $8E/$AA and $DB/$DC set $D6FA to 1 / 2) and changes some
;@ by the room's status flags: the key / shutter doors $3F/$47 (bit 2) and $40/$48 (bit 3) become $3D,
;@ $41/$49 (bit 1) and $42/$4A (bit 0) become $3E; $A1 stays the floor until bit 4; $BF is left out until bit
;@ 4. $BE, $BF and $CB are stairs (RecordStairsObject); the rest goes on in LoadIndoorObjectEnd.
;@ test: skip passes the object on the stack
LoadIndoorObject::
;> obj = kind + 0xEC
	add $ec
	ldh [hMultiPurpose9], a
	push af
;> if 0xCF <= obj < 0xD3: mem[0xC1A5] += 1
	cp $cf
	jr c, .not_CF

	cp $d3
	jr nc, .not_CF

	ld hl, wScrollingFloorCount
	inc [hl]

.not_CF
;> if obj == 0xAB:
	cp $ab
	jr nz, .not_AB

;>     mem[0xC3CB] = 0
	xor a
	ld [wRoomHasTorches], a
;>     if hMapRoom != 0xC4:
	ldh a, [hMapRoom]
	cp $c4
	ldh a, [hMultiPurpose9]
	jr z, .not_AB

;>         mem[0xDBC9] += 1
	ld hl, $dbc9
	inc [hl]
;>         mem[0xC3CB] = obj
	ld [wRoomHasTorches], a
;>         mem[0xC3CD] += 4
	push af
	ld a, [wRoomDarkness]
	add $04
	ld [wRoomDarkness], a
;>         wTransitionSequenceCounter = 4
	ld a, $04
	ld [wTransitionSequenceCounter], a
	pop af

.not_AB
;>@rb if obj in (0x8E, 0xAA): mem[0xD6FA] = 1
	cp $8e
	jr z, .blocks1

	cp $aa
	jr z, .blocks1

;>@rb2 elif obj in (0xDC, 0xDB): mem[0xD6FA] = 2
	cp $dc
	jr z, .blocks2

	cp $db
	jr nz, .doors

.blocks2
;=@rb2
	ld hl, $d6fa
	ld [hl], $02
	jr .doors

.blocks1
;=@rb
	ld hl, $d6fa
	ld [hl], $01

.doors
;>@d3d if (obj in (0x3F, 0x47) and status & 0x04) or (obj in (0x40, 0x48) and status & 0x08): obj = 0x3D
	cp $3f
	jr z, .door3F

	cp $47
	jr nz, .not_3F

.door3F
;=@d3d
	bit 2, e
	jr nz, .to3D

.not_3F
;=@d3d
	cp $40
	jr z, .door40

	cp $48
	jr nz, .not_40

.door40
;=@d3d
	bit 3, e
	jr z, .not_40

.to3D
;=@d3d
	pop af
	ld a, $3d
	push af

.not_40
;>@d3e if (obj in (0x41, 0x49) and status & 0x02) or (obj in (0x42, 0x4A) and status & 0x01): obj = 0x3E
	cp $41
	jr z, .door41

	cp $49
	jr nz, .not_41

.door41
;=@d3e
	bit 1, e
	jr nz, .to3E

.not_41
;=@d3e
	cp $42
	jr z, .door42

	cp $4a
	jr nz, .not_42

.door42
;=@d3e
	bit 0, e
	jr z, .not_42

.to3E
;=@d3e
	pop af
	ld a, $3e
	push af

.not_42
;>@a1 if obj == 0xA1 and not status & 0x10: obj = hMultiPurposeH   # (the room's floor)
	cp $a1
	jr nz, .not_A1

	bit 4, e
	jr nz, .not_A1

;=@a1
	pop af
	ldh a, [hMultiPurposeH]
	push af

.not_A1
;>@bf if obj == 0xBF and not status & 0x10: return data   # not there yet
	cp $bf
	jr nz, .not_BF

	bit 4, e
	jr nz, .not_BF

;=@bf
	pop af
	ret

.not_BF
;> if obj in (0xBE, 0xBF): return RecordStairsObject(obj, data, status)
	cp $be
	jr z, RecordStairsObject

	cp $bf
	jr z, RecordStairsObject

;> if obj != 0xCB: return LoadIndoorObjectEnd(obj, data, status)
	cp $cb
	jr nz, LoadIndoorObjectEnd

;> return RecordStairsObject(obj, data, status)

;@ def RecordStairsObject(obj: a, data: bc, status: e) -> bc
;@ path: world/rooms
;@ A staircase object: its place becomes hStairsX / hStairsY (pixels: the square's middle, y + $10 for the
;@ status bar) and hStairsState 1 (Link stands on it and must step off first). Then it is placed.
;@ test: skip passes the object on the stack
RecordStairsObject::
;> hStairsState = 1
	dec bc
	ld a, $01
	ldh [hStairsState], a
;> hStairsY = (mem[data - 1] & 0xF0) + 0x10
	ld a, [bc]
	and $f0
	add $10
	ldh [hStairsY], a
;> hStairsX = ((mem[data - 1] << 4) & 0xF0) + 8
	ld a, [bc]
	swap a
	and $f0
	add $08
	ldh [hStairsX], a
;> return PlaceRoomObject(obj, data, status)   # (the $A0 check there sees hStairsX, never $A0)
	inc bc
	jp PlaceRoomObject


;@ def LoadIndoorObjectEnd(obj: a, data: bc, status: e) -> bc
;@ path: world/rooms
;@ The last changes of LoadIndoorObject: $D5/$D6 become $21 and $D7/$D8 become $22 until room status bit 4;
;@ $DE (and $A9 outside the dungeons) become $0D once bit 6 is set. Then the object is placed.
;@ test: skip passes the object on the stack
LoadIndoorObjectEnd::
;>@d5 if obj in (0xD6, 0xD5) and not status & 0x10: obj = 0x21
	cp $d6
	jr z, .is_D5

	cp $d5
	jr nz, .not_D5

.is_D5
;=@d5
	bit 4, e
	jr nz, .not_D5

	pop af
	ld a, $21
	push af

.not_D5
;>@d7 if obj in (0xD7, 0xD8) and not status & 0x10: obj = 0x22
	cp $d7
	jr z, .is_D7

	cp $d8
	jr nz, .not_D7

.is_D7
;=@d7
	bit 4, e
	jr nz, .not_D7

	pop af
	ld a, $22
	push af

.not_D7
;> orig = hMultiPurpose9                    # the type before these changes
	ldh a, [hMapId]
	cp $0a
	ldh a, [hMultiPurpose9]
;>@de if ((hMapId >= 0x0A and orig == 0xA9) or orig == 0xDE) and status & 0x40: obj = 0x0D
	jr c, .checkDE

	cp $a9
	jr z, .isDE

.checkDE
;=@de
	cp $de
	jr nz, PlaceRoomObject

.isDE
;=@de
	bit 6, e
	jr z, PlaceRoomObject

	pop af
	ld a, $0d
	push af

;> return PlaceRoomObject(obj, data, status)

;@ def PlaceRoomObject(obj: a, data: bc, status: e) -> bc
;@ path: world/rooms
;@ Writes the object (taken from the stack, where the callers left it) into wRoomObjects at the record's
;@ position, or a whole strip of it (hMultiPurpose0: length in bits 0-3, bit 6 = downwards). $A0 becomes $A1
;@ once room status bit 4 is set.
;@ test: skip takes the object from the stack
PlaceRoomObject::
;>@a0 if obj == 0xA0 and status & 0x10: obj = 0xA1
	cp $a0
	jr nz, .place

	bit 4, e
	jr z, .place

;=@a0
	pop af
	ld a, $a1
	push af

.place
;> if hMultiPurpose0:                       # a strip
	ld d, $00
	ldh a, [hMultiPurpose0]
	and a
	jr z, .single

;>     dest = addr(wRoomObjects) + mem[data - 1]
	dec bc
	ld a, [bc]
	ld e, a
	ld hl, wRoomObjects
	add hl, de
;>     n = hMultiPurpose0 & 0x0F
	ldh a, [hMultiPurpose0]
	and $0f
	ld e, a
	pop af
	ld d, a
;>@sp     for _ in range(n):
.strip
;>         mem[dest] = obj; dest += 1
	ld a, d
	ld [hli], a
;>         if hMultiPurpose0 & 0x40: dest += 0x0F   # downwards: one row ($10) per object
	ldh a, [hMultiPurpose0]
	and $40
	jr z, .next

	ld a, l
	add $0f
	ld l, a

.next
;=@sp
	dec e
	jr nz, .strip

;>     return data
	inc bc
	ret

.single
;>@sg mem[addr(wRoomObjects) + mem[data - 1]] = obj
	dec bc
	ld a, [bc]
	ld e, a
	ld hl, wRoomObjects
	add hl, de
	pop af
;=@sg
	ld [hl], a
;> return data
	inc bc
	ret


;@ def OverworldMacroTree(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $F5: a tree of 2x2 objects at the record's position, or a strip of trees (two squares
;@ apart, to the right or downwards). A column of $F means one square left of the room's first column, so
;@ the tree sticks out at the left edge.
OverworldMacroTree::
;> e = mem[data - 1] + 0x11
	dec bc
	ld a, [bc]
	add $11
	ld e, a
;> if e & 0x0F == 0: e -= 0x10              # column $F: one square to the left
	and $0f
	jr nz, .haveSquare

	ld a, e
	sub $10
	ld e, a

.haveSquare
;> dest = wRoomObjectsArea + e              # = wRoomObjects + the position
	ld d, $00
	ld hl, wRoomObjectsArea
	add hl, de
;> if not hMultiPurpose0: return PlaceTree(dest, data)   # a single tree
	ldh a, [hMultiPurpose0]
	and a
	jr z, PlaceTree

;>@tr for _ in range(hMultiPurpose0 & 0x0F):
	and $0f
	ld e, a

.tree
;>     data = PlaceTree(dest, data) - 1     # (data stays at the position byte)
	call PlaceTree
	dec bc
;>@st     step = 0x0F if hMultiPurpose0 & 0x40 else 0xF1   # from the tree's bottom right: down 2 / right 2
	ldh a, [hMultiPurpose0]
	and $40
	ld d, $f1
	jr z, .haveStep

;=@st
	ld d, $0f

.haveStep
;>     dest = (dest & 0xFF00) | u8(dest + 0x11 + step)
	ld a, l
	add d
	ld l, a
;=@tr
	dec e
	jr nz, .tree

;> return data + 1
	inc bc
	ret


;@ def PlaceTree(dest: hl, data: bc) -> bc
;@ path: world/rooms
;@ Writes a 2x2 tree into wRoomObjects at `dest`: objects $25 $26 / $27 $28 on open ground (objects below
;@ $10). Where a square already holds something else (another tree's half), the joined tree pieces
;@ $29 $2A / $2A $29 are used, and on the bottom row objects $8A and up get $82 / $83. Returns data + 1.
PlaceTree::
;>@t1 mem[dest] = 0x25 if mem[dest] < 0x10 else 0x29
	ld a, [hl]
	cp $10
	ld a, $25
	jr c, .topLeft

	add $04

.topLeft
;=@t1
	ld [hli], a
;>@t2 mem[dest + 1] = 0x26 if mem[dest + 1] < 0x10 else 0x2A
	ld a, [hl]
	cp $10
	ld a, $26
	jr c, .topRight

	add $04

.topRight
;=@t2
	ld [hld], a
;>@bl mem[dest + 0x10] = 0x82 if mem[dest + 0x10] >= 0x8A else 0x27 if mem[dest + 0x10] < 0x10 else 0x2A
	ld a, l
	add $10
	ld l, a
	ld a, [hl]
	cp $8a
	jr nc, .bottomLeft82

;=@bl
	cp $10
	ld a, $27
	jr c, .bottomLeft

	ld a, $2a
	jr .bottomLeft

.bottomLeft82
;=@bl
	ld a, $82

.bottomLeft
;=@bl
	ld [hli], a
;>@br mem[dest + 0x11] = 0x83 if mem[dest + 0x11] >= 0x8A else 0x28 if mem[dest + 0x11] < 0x10 else 0x29
	ld a, [hl]
	cp $8a
	jr nc, .bottomRight83

	cp $10
	ld a, $28
	jr c, .bottomRight

;=@br
	ld a, $29
	jr .bottomRight

.bottomRight83
;=@br
	ld a, $83

.bottomRight
;=@br
	ld [hl], a
;> return data + 1
	inc bc
	ret


;@ def PlaceObjectShape(base: hl, offsets: bc, objects: de)
;@ path: world/rooms
;@ Writes a shape of objects into wRoomObjects: for each offset of the list at `offsets` (row << 4 | column
;@ from `base`; the list ends with $FF) the next object of `objects`. Entrances ($E1-$E3) are noted in the
;@ wWarpDestPosition list. Returns to the room data pointer the caller pushed.
;@ test: skip takes the data pointer from the stack
PlaceObjectShape::
;> while True:
;>     dest = base + mem[offsets]
	push hl
	push de
	ld a, [bc]
	ld e, a
	ld d, $00
	add hl, de
;>     obj = mem[objects]
	pop de
	ld a, [de]
;>@en     if obj in (0xE1, 0xE2, 0xE3):         # an entrance: note its position
	cp $e1
	jr z, .entrance

	cp $e2
	jr z, .entrance

	cp $e3
	jr nz, .store

.entrance
;=@en
	push af
	push hl
	push de
	ld a, l
	sub $11
	push af
;>         n = wRoomDoorCount
	ld a, [wRoomDoorCount]
	ld e, a
;>         wRoomDoorCount = n + 1
	inc a
	ld [wRoomDoorCount], a
;>         mem[addr(wWarpDestPosition) + n] = u8(dest - 0x11)   # the low byte is the position in wRoomObjects
	ld d, $00
	ld hl, wWarpDestPosition
	add hl, de
	pop af
	ld [hl], a
	pop de
;=@en
	pop hl
	pop af

.store
;>     mem[dest] = obj
	ld [hl], a
;>     objects += 1
	inc de
;>     offsets += 1
	inc bc
	pop hl
;>     if mem[offsets] == 0xFF: break
	ld a, [bc]
	and a
	cp $ff
	jr nz, PlaceObjectShape

;> return pop_return_address()               # the room data pointer saved by the macro
	pop bc
	ret


;@ path: world/rooms
;@ Overworld macro $F8: 3x2 objects. +0 offsets from the record's position (row << 4 | column, $FF ends),
;@ +7 the objects: $B6 $B7 $66 / $67 $E3 $68 ($E3 an entrance).
MacroShapeF8::
	db $00, $01, $02, $10, $11, $12, $ff, $b6, $b7, $66, $67, $e3, $68

;@ def OverworldMacroF8(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $F8: the shape MacroShapeF8 at the record's position.
OverworldMacroF8::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeF8, MacroShapeF8 + 7)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeF8
	ld de, MacroShapeF8 + 7
	jp PlaceObjectShape
;> return data


;@ def GetObjectRoomAddress(data: bc) -> hl
;@ path: world/rooms
;@ The address in wRoomObjects of the position byte before `data` (bc is left pointing at it).
GetObjectRoomAddress::
;>@ga return addr(wRoomObjects) + mem[data - 1]
	dec bc
	ld a, [bc]
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
;=@ga
	ret


;@ path: world/rooms
;@ Overworld macro $F6: 5x3 objects (offsets, $FF, then objects): $55 $5A $5A $5A $56 / $57 $59 $59 $59 $58 /
;@ $5B $E2 $5B $E2 $5B - a wide building with two entrances ($E2).
MacroShapeF6::
	db $00, $01, $02, $03, $04, $10, $11, $12, $13, $14, $20, $21, $22, $23, $24, $ff
	db $55, $5a, $5a, $5a, $56, $57, $59, $59, $59, $58, $5b, $e2, $5b, $e2, $5b

;@ def OverworldMacroF6(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $F6: the shape MacroShapeF6 at the record's position.
OverworldMacroF6::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeF6, MacroShapeF6 + 16)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeF6
	ld de, MacroShapeF6 + 16
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $F7: 3x3 objects (offsets, $FF, then objects): $55 $5A $56 / $57 $59 $58 / $5B $E2 $5B -
;@ a small building with an entrance ($E2).
MacroShapeF7::
	db $00, $01, $02, $10, $11, $12, $20, $21, $22, $ff, $55, $5a, $56, $57, $59, $58
	db $5b, $e2, $5b

;@ def OverworldMacroF7(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $F7: the shape MacroShapeF7 at the record's position.
OverworldMacroF7::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeF7, MacroShapeF7 + 10)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeF7
	ld de, MacroShapeF7 + 10
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $F9: 3x2 objects (offsets, $FF, then objects): $A4 $A5 $A6 / $A7 $E3 $A8 ($E3 an
;@ entrance).
MacroShapeF9::
	db $00, $01, $02, $10, $11, $12, $ff, $a4, $a5, $a6, $a7, $e3, $a8

;@ def OverworldMacroF9(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $F9: the shape MacroShapeF9 at the record's position.
OverworldMacroF9::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeF9, MacroShapeF9 + 7)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeF9
	ld de, MacroShapeF9 + 7
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $FA: 2x2 objects (offsets, $FF, then two object sets): $BB $BC / $BD $BE, or four $09 once
;@ room status bit 2 is set.
MacroShapeFA::
	db $00, $01, $10, $11, $ff, $bb, $bc, $bd, $be, $09, $09, $09, $09

;@ def OverworldMacroFA(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $FA: the shape MacroShapeFA; its second object set once room status bit 2 is set.
OverworldMacroFA::
;> base = GetObjectRoomAddress(data)
	push bc
	call GetObjectRoomAddress
;> objects = MacroShapeFA + 5
	ld bc, MacroShapeFA
	ld de, MacroShapeFA + 5
;> if hRoomStatus & 0x04: objects = MacroShapeFA + 9
	ldh a, [hRoomStatus]
	and $04
	jr z, .place

	ld de, MacroShapeFA + 9

.place
;> PlaceObjectShape(base, MacroShapeFA, objects)
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $FB: 2x2 objects (offsets, $FF, then objects): $B6 $B7 / $CD $CE.
MacroShapeFB::
	db $00, $01, $10, $11, $ff, $b6, $b7, $cd, $ce

;@ def OverworldMacroFB(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $FB: the shape MacroShapeFB at the record's position.
OverworldMacroFB::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeFB, MacroShapeFB + 5)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeFB
	ld de, MacroShapeFB + 5
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $FC: 14 objects (offsets, $FF, then objects) in rows of 3, 5 (from one column left) and
;@ 3: $2B $2C $2D / $37 $E8 $38 ... with entrance $E8 in the middle; $0A fills the rest.
MacroShapeFC::
	db $00, $01, $02, $10, $11, $12, $1f, $20, $21, $22, $23, $30, $31, $32, $ff, $2b
	db $2c, $2d, $37, $e8, $38, $0a, $33, $2f, $34, $0a, $0a, $0a, $0a

;@ def OverworldMacroFC(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $FC: the shape MacroShapeFC at the record's position.
OverworldMacroFC::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeFC, MacroShapeFC + 15)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeFC
	ld de, MacroShapeFC + 15
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Overworld macro $FD: 3x2 objects (offsets, $FF, then objects): $52 $52 $52 / $5B $E2 $5B ($E2 an
;@ entrance).
MacroShapeFD::
	db $00, $01, $02, $10, $11, $12, $ff, $52, $52, $52, $5b, $e2, $5b

;@ def OverworldMacroFD(data: bc) -> bc
;@ path: world/rooms
;@ Overworld macro $FD: the shape MacroShapeFD at the record's position.
OverworldMacroFD::
;> PlaceObjectShape(GetObjectRoomAddress(data), MacroShapeFD, MacroShapeFD + 7)
	push bc
	call GetObjectRoomAddress
	ld bc, MacroShapeFD
	ld de, MacroShapeFD + 7
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (left, right) of a locked door in the top wall: $2D $2E.
DoorKeyTopObjects::
	db $2d, $2e

;@ def DoorKeyTop(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a locked door in the top wall (door slot 0). Once room status bit 2 is set (unlocked) it is
;@ drawn as an open doorway instead.
DoorKeyTop::
;> RecordDoor(0, data)
	ld e, $00
	call RecordDoor
;> if hRoomStatus & 0x04: return DoorOpenTop(data)
	ldh a, [hRoomStatus]
	and $04
	jp nz, DoorOpenTop

;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, DoorKeyTopObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, DoorKeyTopObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (left, right) of a locked door in the bottom wall: $2F $30.
DoorKeyBottomObjects::
	db $2f, $30

;@ def DoorKeyBottom(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a locked door in the bottom wall (door slot 1). Once room status bit 3 is set (unlocked) it is
;@ drawn as an open doorway instead.
DoorKeyBottom::
;> RecordDoor(1, data)
	ld e, $01
	call RecordDoor
;> if hRoomStatus & 0x08: return DoorOpenBottom(data)
	ldh a, [hRoomStatus]
	and $08
	jp nz, DoorOpenBottom

;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, DoorKeyBottomObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, DoorKeyBottomObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (top, bottom) of a locked door in the left wall: $31 $32.
DoorKeyLeftObjects::
	db $31, $32

;@ def DoorKeyLeft(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a locked door in the left wall (door slot 2). Once room status bit 1 is set (unlocked) it is
;@ drawn as an open doorway instead.
DoorKeyLeft::
;> RecordDoor(2, data)
	ld e, $02
	call RecordDoor
;> if hRoomStatus & 0x02: return DoorOpenLeft(data)
	ldh a, [hRoomStatus]
	and $02
	jp nz, DoorOpenLeft

;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeVerticalPair, DoorKeyLeftObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeVerticalPair
	ld de, DoorKeyLeftObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (top, bottom) of a locked door in the right wall: $33 $34.
DoorKeyRightObjects::
	db $33, $34

;@ def DoorKeyRight(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a locked door in the right wall (door slot 3). Once room status bit 0 is set (unlocked) it is
;@ drawn as an open doorway instead.
DoorKeyRight::
;> RecordDoor(3, data)
	ld e, $03
	call RecordDoor
;> if hRoomStatus & 0x01: return DoorOpenRight(data)
	ldh a, [hRoomStatus]
	and $01
	jp nz, DoorOpenRight

;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeVerticalPair, DoorKeyRightObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeVerticalPair
	ld de, DoorKeyRightObjects
	jp PlaceObjectShape
;> return data


;@ def DoorShutterTop(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a shutter door in the top wall (door slot 4): noted in wRoomShutterDoors (bit 0) and drawn
;@ as an open doorway; the shutter closes and opens with the room's event.
DoorShutterTop::
;> RecordDoor(4, data)
	ld e, $04
	call RecordDoor
;> wRoomShutterDoors |= 0x01
	ld a, [wRoomShutterDoors]
	or $01
	ld [wRoomShutterDoors], a
;> wRoomShutterDoorsCopy = wRoomShutterDoors
	ld [wRoomShutterDoorsCopy], a
;> return DoorOpenTop(data)
	jp DoorOpenTop


;@ def DoorShutterBottom(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a shutter door in the bottom wall (door slot 5): noted in wRoomShutterDoors (bit 1) and drawn
;@ as an open doorway; the shutter closes and opens with the room's event.
DoorShutterBottom::
;> RecordDoor(5, data)
	ld e, $05
	call RecordDoor
;> wRoomShutterDoors |= 0x02
	ld a, [wRoomShutterDoors]
	or $02
	ld [wRoomShutterDoors], a
;> wRoomShutterDoorsCopy = wRoomShutterDoors
	ld [wRoomShutterDoorsCopy], a
;> return DoorOpenBottom(data)
	jp DoorOpenBottom


;@ def DoorShutterLeft(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a shutter door in the left wall (door slot 6): noted in wRoomShutterDoors (bit 2) and drawn
;@ as an open doorway; the shutter closes and opens with the room's event.
DoorShutterLeft::
;> RecordDoor(6, data)
	ld e, $06
	call RecordDoor
;> wRoomShutterDoors |= 0x04
	ld a, [wRoomShutterDoors]
	or $04
	ld [wRoomShutterDoors], a
;> wRoomShutterDoorsCopy = wRoomShutterDoors
	ld [wRoomShutterDoorsCopy], a
;> return DoorOpenLeft(data)
	jp DoorOpenLeft


;@ def DoorShutterRight(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: a shutter door in the right wall (door slot 7): noted in wRoomShutterDoors (bit 3) and drawn
;@ as an open doorway; the shutter closes and opens with the room's event.
DoorShutterRight::
;> RecordDoor(7, data)
	ld e, $07
	call RecordDoor
;> wRoomShutterDoors |= 0x08
	ld a, [wRoomShutterDoors]
	or $08
	ld [wRoomShutterDoors], a
;> wRoomShutterDoorsCopy = wRoomShutterDoors
	ld [wRoomShutterDoorsCopy], a
;> return DoorOpenRight(data)
	jp DoorOpenRight


;@ path: world/doors
;@ The two objects (left, right) of an open doorway in the top wall: $43 $44.
DoorOpenTopObjects::
	db $43, $44

;@ def DoorOpenTop(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: an open doorway in the top wall; sets room status bit 2 (this door is open).
DoorOpenTop::
;> SetRoomStatusBits(0x04)
	ld a, $04
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, DoorOpenTopObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, DoorOpenTopObjects
	jp PlaceObjectShape
;> return data


;@ def SetRoomStatusBits(bits: a)
;@ path: world/rooms
;@ Sets `bits` in the status byte of the current indoor room (in wRoomStatus; maps 6-$19 use the second
;@ indoor group) and copies the result into hRoomStatus.
SetRoomStatusBits::
;>@rm room = hMapRoom + (0x100 if 0x06 <= hMapId < 0x1A else 0)
	push af
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ldh a, [hMapId]
	cp $1a
;=@rm
	jr nc, .firstGroup

	cp $06
	jr c, .firstGroup

	inc d

.firstGroup
;> wRoomStatus[0x100 + room] |= bits
	ld hl, $d900
	add hl, de
	pop af
	or [hl]
	ld [hl], a
;> hRoomStatus = wRoomStatus[0x100 + room]
	ldh [hRoomStatus], a
;> return
	ret


;@ path: world/doors
;@ The two objects (left, right) of an open doorway in the bottom wall: $8C $08.
DoorOpenBottomObjects::
	db $8c, $08

;@ def DoorOpenBottom(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: an open doorway in the bottom wall; sets room status bit 3 (this door is open).
DoorOpenBottom::
;> SetRoomStatusBits(0x08)
	ld a, $08
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, DoorOpenBottomObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, DoorOpenBottomObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (top, bottom) of an open doorway in the left wall: $09 $0A.
DoorOpenLeftObjects::
	db $09, $0a

;@ def DoorOpenLeft(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: an open doorway in the left wall; sets room status bit 1 (this door is open).
DoorOpenLeft::
;> SetRoomStatusBits(0x02)
	ld a, $02
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeVerticalPair, DoorOpenLeftObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeVerticalPair
	ld de, DoorOpenLeftObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (top, bottom) of an open doorway in the right wall: $0B $0C.
DoorOpenRightObjects::
	db $0b, $0c

;@ def DoorOpenRight(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: an open doorway in the right wall; sets room status bit 0 (this door is open).
DoorOpenRight::
;> SetRoomStatusBits(0x01)
	ld a, $01
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeVerticalPair, DoorOpenRightObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeVerticalPair
	ld de, DoorOpenRightObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ The two objects (left, right) of the boss door in the top wall, while it is closed: $A4 $A5.
DoorBossTopObjects::
	db $a4, $a5

;@ def DoorBossTop(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro: the boss door in the top wall (door slot 8); an open doorway once room status bit 2 is
;@ set.
DoorBossTop::
;> RecordDoor(8, data)
	ld e, $08
	call RecordDoor
;> if hRoomStatus & 0x04: return DoorOpenTop(data)
	ldh a, [hRoomStatus]
	and $04
	jp nz, DoorOpenTop

;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, DoorBossTopObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, DoorBossTopObjects
	jp PlaceObjectShape
;> return data


;@ def RecordDoor(slot: e, data: bc)
;@ path: world/doors
;@ Notes the door at the record position (the byte before `data`) in door slot `slot`: wDoorPosition,
;@ and its pixel position in wDoorY (row * 16) and wDoorX (column * 16).
RecordDoor::
;> pos = mem[data - 1]
	ld d, $00
	ld hl, wDoorPosition
	add hl, de
	dec bc
	ld a, [bc]
;> wDoorPosition[slot] = pos
	ld [hl], a
;> wDoorY[slot] = pos & 0xF0
	push af
	and $f0
	ld hl, wDoorY
	add hl, de
	ld [hl], a
;> wDoorX[slot] = (pos << 4) & 0xF0
	pop af
	swap a
	and $f0
	ld hl, wDoorX
	add hl, de
	ld [hl], a
;> return
	inc bc
	ret


;@ path: world/doors
;@ Indoor macro $F9: two objects one above the other: $AF $B0.
IndoorMacroF9Objects::
	db $af, $b0

;@ def IndoorMacroF9(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro $F9: places IndoorMacroF9Objects (one above the other).
IndoorMacroF9::
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeVerticalPair, IndoorMacroF9Objects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeVerticalPair
	ld de, IndoorMacroF9Objects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ Indoor macro $FA: two objects side by side: $B1 $B2.
IndoorMacroFAObjects::
	db $b1, $b2

;@ def IndoorMacroFA(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro $FA: places IndoorMacroFAObjects (side by side).
IndoorMacroFA::
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, IndoorMacroFAObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, IndoorMacroFAObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ Indoor macro $FB: two objects side by side: $45 $46.
IndoorMacroFBObjects::
	db $45, $46

;@ def IndoorMacroFB(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro $FB: places IndoorMacroFBObjects (side by side).
IndoorMacroFB::
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, IndoorMacroFBObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, IndoorMacroFBObjects
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ Indoor macro $FC: 4x3 objects (offsets from the record position, $FF, then the objects):
;@ $B3 $B4 $B4 $B5 / $B6 $B7 $B8 $B9 / $BA $BB $BC $BD.
IndoorMacroFCShape::
	db $00, $01, $02, $03, $10, $11, $12, $13, $20, $21, $22, $23, $ff, $b3, $b4, $b4
	db $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd

;@ def IndoorMacroFC(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro $FC: sets room status bit 3 and places the 4x3 shape IndoorMacroFCShape.
IndoorMacroFC::
;> SetRoomStatusBits(0x08)
	ld a, $08
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), IndoorMacroFCShape, IndoorMacroFCShape + 13)
	push bc
	call GetObjectRoomAddress
	ld bc, IndoorMacroFCShape
	ld de, IndoorMacroFCShape + 13
	jp PlaceObjectShape
;> return data


;@ path: world/doors
;@ Indoor macro $FD: two objects side by side: $C1 $C2.
IndoorMacroFDObjects::
	db $c1, $c2

;@ def IndoorMacroFD(data: bc) -> bc
;@ path: world/doors
;@ Indoor macro $FD: in room $D3 of the second indoor group, once $DB46 is set, a shutter door in the
;@ bottom wall; otherwise sets room status bit 0 and places IndoorMacroFDObjects.
IndoorMacroFD::
;>@d3 if 0x06 <= hMapId < 0x1A and hMapRoom == 0xD3 and mem[0xDB46]: return DoorShutterBottom(data)
	ldh a, [hMapId]
	cp $1a
	jr nc, .other

	cp $06
	jr c, .other

;=@d3
	ldh a, [hMapRoom]
	cp $d3
	jr nz, .other

	ld a, [wShopPunishThief]
	and a
	jr z, .other

;=@d3
	jp DoorShutterBottom

.other
;> SetRoomStatusBits(0x01)
	ld a, $01
	call SetRoomStatusBits
;> PlaceObjectShape(GetObjectRoomAddress(data), ShapeHorizontalPair, IndoorMacroFDObjects)
	push bc
	call GetObjectRoomAddress
	ld bc, ShapeHorizontalPair
	ld de, IndoorMacroFDObjects
	jp PlaceObjectShape
;> return data


;@ path: world/rooms
;@ Offsets for PlaceObjectShape: two squares side by side ($00 $01, then $FF).
ShapeHorizontalPair::
	db $00, $01, $ff

;@ path: world/rooms
;@ Offsets for PlaceObjectShape: two squares one above the other ($00 $10, then $FF).
ShapeVerticalPair::
	db $00, $10, $ff

;@ def FillRoomObjects(obj: a)
;@ path: world/rooms
;@ Fills the room (columns 1-10 of the rows of wRoomObjects) with object `obj`, the room's floor, which is
;@ also kept in hMultiPurposeH.
FillRoomObjects::
;> hMultiPurposeH = obj
	ldh [hMultiPurposeH], a
;>@f for p in range(0x80):
	ld d, $80
	ld hl, wRoomObjects
	ld e, a

.loop
;>     if 1 <= (wRoomObjects + p) & 0x0F < 0x0B: wRoomObjects[p] = obj   # not the border columns
	ld a, l
	and $0f
	jr z, .next

	cp $0b
	jr nc, .next

	ld [hl], e

.next
;=@f
	inc hl
	dec d
	jr nz, .loop

;> return
	ret


;@ def LoadRoomEntities()
;@ path: entity/spawn
;@ Spawns the entities of the room being entered. First the list of the last 6 rooms visited is updated
;@ (RememberRecentRoom: a room that drops out of it gets its defeated entities back). In dungeon 7 (map 6) the
;@ heavy ball is placed where it was left (wIronBallRoom / X / Y). Then the room's entity list is read from
;@ bank $16: pointer table at $4000 (overworld), $4200 (indoor group 1) or $4400 (maps 6-$19), two bytes
;@ per room; each entry is 2 bytes (position row << 4 | column, entity type), $FF ends the list.
LoadRoomEntities::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> RememberRecentRoom()
	call RememberRecentRoom
;> set_rom_bank(0x16)
	ld a, $16
	ld [$2100], a
;> hMultiPurposeD = 0                       # index in the room's entity list
	xor a
	ldh [hMultiPurposeD], a
;> offset = hMapRoom * 2
	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
	sla c
	rl b
;> table = 0x4000
	ld hl, $4000
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .readPointer

;>@ib     if hMapId == 6 and wIronBallRoom == hMapRoom:   # the heavy ball of dungeon 7 lies here
	ldh a, [hMapId]
	cp $06
	jr nz, .indoorTable

;=@ib
	ld a, [wIronBallRoom]
	ld hl, hMapRoom
	cp [hl]
	jr nz, .indoorTable

;>         slot = SpawnEntity(0xA8)
	ld a, $a8
	call SpawnEntity
;>         wEntityX[slot] = wIronBallX
	ld a, [wIronBallX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>         wEntityY[slot] = wIronBallY
	ld a, [wIronBallY]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>         InitLoadedEntity(slot)
	call InitLoadedEntity
;>         wEntityLoadOrder[slot] = 0xFF        # not from the list
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], $ff
;>         hMultiPurposeD = 0
	xor a
	ldh [hMultiPurposeD], a

.indoorTable
;>     table = 0x4200
	ld hl, $4200
;>@g2     if 0x06 <= hMapId < 0x1A: table = 0x4400
	ldh a, [hMapId]
	cp $1a
	jr nc, .readPointer

	cp $06
	jr c, .readPointer

;=@g2
	inc h
	inc h

.readPointer
;> data = mem16[table + offset]
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a

.next
;> while mem[data] != 0xFF:
	ld a, [bc]
	cp $ff
	jr z, .done

;>     data = LoadRoomEntity(data)
	call LoadRoomEntity
	jr .next

.done
;> set_rom_bank(wCurrentBank)
	call RestoreBank
;> return
	ret


;@ path: entity/spawn
;@ One bit for each of the first 8 entries of a room's entity list (in wRoomDefeatedEntityBits).
RoomEntityBitMask::
	db $01, $02, $04, $08, $10, $20, $40, $80

;@ def LoadRoomEntity(data: bc) -> bc
;@ path: entity/spawn
;@ Spawns one entry of the room's entity list (hMultiPurposeD = its index) in a free entity slot: status 4
;@ (being set up), position from the entry (the middle of the square: x + 8, y + $10 for the status bar),
;@ type. Entries 0-7 are left out when wRoomDefeatedEntityBits says they were defeated; also when all 16
;@ slots are taken. Returns `data` past the entry.
LoadRoomEntity::
;>@df skip = hMultiPurposeD < 8 and bool(wRoomDefeatedEntityBits[hMapRoom] & mem[RoomEntityBitMask + hMultiPurposeD])
	ldh a, [hMultiPurposeD]
	cp $08
	jr nc, .findSlot

	ld e, a
	ld d, $00
;=@df
	ld hl, RoomEntityBitMask
	add hl, de
	ldh a, [hMapRoom]
	ld e, a
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
;=@df
	add hl, de
	and [hl]
	jr nz, .skip

.findSlot
;>@fs slot = None if skip else next((s for s in range(16) if wEntityStatus[s] == 0), None)
	ld e, $00
	ld d, e

.trySlot
;=@fs
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $00
	jr z, .spawn

;=@fs
	inc e
	ld a, e
	cp $10
	jr nz, .trySlot

.skip
;> if slot is None:                         # defeated before, or no free slot
;>     hMultiPurposeD += 1
	ld hl, hMultiPurposeD
	inc [hl]
;>     return data + 2
	inc bc
	inc bc
	ret

.spawn
;> wEntityStatus[slot] = 4                  # being set up
	ld [hl], $04
;> wEntityY[slot] = (mem[data] & 0xF0) + 0x10
	ld a, [bc]
	and $f0
	ld hl, wEntityY
	add hl, de
	add $10
	ld [hl], a
;>@ex wEntityX[slot] = ((mem[data] << 4) & 0xF0) + 8
	ld a, [bc]
	inc bc
	swap a
	and $f0
	ld hl, wEntityX
	add hl, de
;=@ex
	add $08
	ld [hl], a
;> wEntityType[slot] = mem[data + 1]
	ld hl, wEntityType
	add hl, de
	ld a, [bc]
	inc bc
	ld [hl], a
;> InitLoadedEntity(slot)
;> return data + 2

;@ def InitLoadedEntity(slot: de)
;@ path: entity/spawn
;@ Sets up a just-spawned entity from its type's defaults (InitSpawnedEntityProperties) and notes its place in the room's
;@ list (PlaceEntityForRoomScroll: wEntityLoadOrder = hMultiPurposeD, which counts on). Ends with bank $16 switched in.
InitLoadedEntity::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> InitSpawnedEntityProperties(slot)
	call InitSpawnedEntityProperties
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> PlaceEntityForRoomScroll(slot)
	call PlaceEntityForRoomScroll
;> set_rom_bank(0x16)
	ld a, $16
	ld [$2100], a
;> return
	ret


;@ def ApplyIndoorRoomTemplate(template: a)
;@ path: world/rooms
;@ Builds the walls of an indoor room from one of its templates (PlaceIndoorWalls, high nibble of the room
;@ data's second byte), then switches back to the bank of the room data (kept in hBGTilesRequestCopy by
;@ LoadRoom). bc is kept.
ApplyIndoorRoomTemplate::
;> set_rom_bank(0x14)
	ld e, a
	ld a, $14
	ld [$2100], a
;> PlaceIndoorWalls(template)
	ld a, e
	push bc
	call PlaceIndoorWalls
	pop bc
;> set_rom_bank(hBGTilesRequestCopy)
	ldh a, [hBGTilesRequestCopy]
	ld [$2100], a
;> return
	ret


;@ def LoadTileset0E()
;@ path: menu/map
;@ Tile set request $0E: draws the world map screen (DrawWorldMapRooms: rooms not visited yet are hidden).
LoadTileset0E::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> DrawWorldMapRooms()
	call DrawWorldMapRooms
;> return
	ret


;@ path: unused
;@ 2 unused bytes ($FF).
Padding37E4::
	db $ff, $ff

;@ def GetEntityTypeByte14(type: de) -> a
;@ path: entity/data
;@ A byte of the per-entity-type table at $14:$56FF; for code in bank 5, which is switched back in.
GetEntityTypeByte14::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> value = mem[0x56FF + type]
	ld hl, $56ff
	add hl, de
	ld a, [hl]
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> return value
	ret


;@ def ShatterThrownObject(slot: bc)
;@ path: object/liftable
;@ A thrown pot or rock breaks into pieces (DrawShatterPieces), for code in bank 3.
ShatterThrownObject::
;> SwitchBank(0x19)
	ld a, $19
	call SwitchBank
;> DrawShatterPieces(slot, hMultiPurpose0)
	call DrawShatterPieces
;> SwitchBank(0x03)
	ld a, $03
	jp SwitchBank


;@ def BreakThrownObjectFar(slot: bc)
;@ path: object/liftable
;@ BreakThrownObject (bank 3) called from bank 0.
BreakThrownObjectFar::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> BreakThrownObject(slot)
	call BreakThrownObject
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def ConfineLinkToArena()
;@ path: boss/common
;@ Keeps Link inside the boss arena (KeepLinkInBossArena); called by boss handlers.
ConfineLinkToArena::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> KeepLinkInBossArena()
	call KeepLinkInBossArena
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def OnRoomEnteredBank1()
;@ path: world/rooms
;@ SpawnFollowers, run by bank 2 when Link has entered a room; bank 2 is switched back in.
OnRoomEnteredBank1::
;> SwitchBank(0x01)
	ld a, $01
	call SwitchBank
;> SpawnFollowers()
	call SpawnFollowers
;> SwitchBank(0x02)
	ld a, $02
	jp SwitchBank


;@ def InitEntityPropertiesFar(slot: bc)
;@ path: entity/spawn
;@ InitEntityProperties (bank 3) called from another bank.
InitEntityPropertiesFar::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> InitEntityProperties(slot)
	call InitEntityProperties
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def UpdateCarriedEntity()
;@ path: entity/carry
;@ CarriedEntityStep, for the entity that Link carries; for code in bank 3, which is switched back in.
UpdateCarriedEntity::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> CarriedEntityStep()
	call CarriedEntityStep
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> return
	ret


;@ path: entity/engine
;@ First OAM offset handed to the entities each frame (wOAMNextIndex), by frame number & 3: $00 $08 $10 $18.
;@ Rotating the start makes sprites flicker instead of vanishing when there are too many on a line.
OAMStartOffsets::
	db $00, $08, $10, $18

;@ def UpdateEntities()
;@ path: entity/engine
;@ Runs all entities once per frame, slot 15 down to 0 (UpdateEntity for each used slot). Before that:
;@ counts down wDelayedWaveSfxTimer (sound $10 when it runs out), wLinkPoseLock (not during a dialog),
;@ picks the OAM start (rotating by frame inside the dungeons - maps below $0A - else 0), clears the per-frame
;@ flags the entities set (Link in water, on a platform, carried entity, ...), and runs DrawSwordPowerSparkleAB. Nothing
;@ runs while wLinkMotionState is 7.
UpdateEntities::
;> if wDelayedWaveSfxTimer:
	ld hl, wDelayedWaveSfxTimer
	ld a, [hl]
	and a
	jr z, .poseLock

;>     wDelayedWaveSfxTimer -= 1
	dec [hl]
;>     if wDelayedWaveSfxTimer == 0: hWaveSfx = 0x10
	jr nz, .poseLock

	ld a, $10
	ldh [hWaveSfx], a

.poseLock
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .motion

;>     wLinkShowItemPoseActive = wLinkPoseLock
	ld a, [wLinkPoseLock]
	ld [wLinkShowItemPoseActive], a
;>     if wLinkPoseLock: wLinkPoseLock -= 1
	and a
	jr z, .motion

	dec a
	ld [wLinkPoseLock], a

.motion
;> if wLinkMotionState == 7: return
	ld a, [wLinkMotionState]
	cp $07
	ret z

;> wOAMEntriesUsed = 0
	xor a
	ld [wOAMEntriesUsed], a
;>@st start = hFrameCounter & 3 if hMapId < 0x0A else 0
	ldh a, [hMapId]
	cp $0a
	ldh a, [hFrameCounter]
	jr c, .haveStart

	xor a

.haveStart
;=@st
	and $03
;> wOAMNextIndex = mem[OAMStartOffsets + start]
	ld e, a
	ld d, $00
	ld hl, OAMStartOffsets
	add hl, de
	ld a, [hl]
	ld [wOAMNextIndex], a
;> mem[0xC5A1] = mem[0xC5A0]
	ld a, [wPodobooCount]
	ld [wPodobooCountPrev], a
;> mem[0xC5A0] = 0
	xor a
	ld [wPodobooCount], a
;> wRaccoonLoopsExit = 0
	ld [wRaccoonLoopsExit], a
;> hLinkInWater = 0
	ldh [hLinkInWater], a
;> wLinkSlowAnimation = 0
	ld [wLinkSlowAnimation], a
;> wNoEventJingle = 0
	ld [wNoEventJingle], a
;> wLinkOnPlatform = 0
	ld [wLinkOnPlatform], a
;> wCarriedEntityType = 0
	ld [wCarriedEntityType], a
;> mem[0xD45E] = 0
	ld [wLinkPulledByDevice], a
;> if not wDialogState: wCanTalkToEntity = 0
	ld a, [wDialogState]
	and a
	jr nz, .entities

	ld [wCanTalkToEntity], a

.entities
;> SwitchBank(0x02)
	ld a, $02
	call SwitchBank
;> DrawSwordPowerSparkleAB()
	call DrawSwordPowerSparkleAB
;>@sl for slot in range(15, -1, -1):
	ld b, $00
	ld c, $0f

.slot
;>     wActiveEntitySlot = slot
	ld a, c
	ld [wActiveEntitySlot], a
;>     if wEntityStatus[slot]:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, .nextSlot

;>         hActiveEntityStatus = wEntityStatus[slot]
	ldh [hActiveEntityStatus], a
;>         UpdateEntity(slot)
	call UpdateEntity

.nextSlot
;=@sl
	dec c
	ld a, c
	cp $ff
	jr nz, .slot

;> EntityStatusFreeHandler()

;@ def EntityStatusFreeHandler()
;@ path: entity/engine
;@ Entry 0 of EntityStatusHandlers (a free slot; never reached, UpdateEntities skips free slots): nothing.
EntityStatusFreeHandler::
;> return
	ret


;@ def ResetEntityVariablesFrom3(slot: bc)
;@ path: entity/engine
;@ ResetEntityVariables (bank $15) for code in bank 3, which is switched back in.
ResetEntityVariablesFrom3::
;> set_rom_bank(0x15)
	ld a, $15
	ld [$2100], a
;> ResetEntityVariables(slot)
	call ResetEntityVariables
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> return
	ret


;@ def UpdateEntity(slot: bc)
;@ path: entity/engine
;@ Runs one entity: copies its type, state and sprite variant to the hActiveEntity bytes, moves it along with
;@ a room scroll (MoveEntityWithRoomScroll) and reads its position (LoadEntityPosition) - for lifted entities, and for type $6A
;@ while Link swims, in the other order, so they follow Link - runs the common checks of bank $14
;@ (UpdateEntityTimers), then the code for its status: the type's own handler (RunEntityHandler) when active
;@ (status 5), else EntityStatusHandlers in bank 3.
UpdateEntity::
;> hActiveEntityType = wEntityType[slot]
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityType], a
;> hActiveEntityState = wEntityState[slot]
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a
;> hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;> SwitchBank(0x19)
	ld a, $19
	call SwitchBank
;>@ft if (hActiveEntityType == 0x6A and hLinkInWater) or hActiveEntityStatus == 7:   # carried along with Link
	ldh a, [hActiveEntityType]
	cp $6a
	jr nz, .checkLifted

	ldh a, [hLinkInWater]
	and a
	jr nz, .follows

.checkLifted
;=@ft
	ldh a, [hActiveEntityStatus]
	cp $07
	jr nz, .usual

.follows
;>     MoveEntityWithRoomScroll(slot)                   # moves it with a room scroll first
	call MoveEntityWithRoomScroll
;>     LoadEntityPosition(slot)                      # then reads its position
	call LoadEntityPosition
	jr .common

.usual
;> else:
;>     LoadEntityPosition(slot)
	call LoadEntityPosition
;>     MoveEntityWithRoomScroll(slot)
	call MoveEntityWithRoomScroll

.common
;> SwitchBank(0x14)
	ld a, $14
	call SwitchBank
;> UpdateEntityTimers(slot)
	call UpdateEntityTimers
;> SwitchBank(0x03)
	ld a, $03
	call SwitchBank
;> if hActiveEntityStatus == 5: return RunEntityHandler(slot)   # active
	ldh a, [hActiveEntityStatus]
	cp $05
	jp z, RunEntityHandler

;> return EntityStatusHandlers[hActiveEntityStatus](slot)
	rst $00

;@ path: entity/engine
;@ Code for each entity status (index = wEntityStatus; bank 3 is switched in): 0 free, 1 dying, 2 falling into
;@ a pit, 3 destroyed, 4 being set up (init), 5 active (the type's own handler, RunEntityHandler), 6 stunned,
;@ 7 lifted by Link, 8 thrown.
EntityStatusHandlers::
	dw EntityStatusFreeHandler
	dw EntityStatus1Handler
	dw EntityStatus2Handler
	dw EntityStatus3Handler
	dw EntityStatusInitHandler
	dw RunEntityHandler
	dw EntityStatus6Handler
	dw EntityStatus7Handler
	dw EntityStatus8Handler

;@ def RunEntityHandlerFrom3(slot: bc)
;@ path: entity/engine
;@ RunEntityHandler for code in bank 3, which is switched back in afterwards.
RunEntityHandlerFrom3::
;> RunEntityHandler(slot)
	call RunEntityHandler
;> SwitchBank(0x03)
	ld a, $03
	jp SwitchBank


;@ def RunEntityHandler(slot: bc)
;@ path: entity/engine
;@ Runs the handler of the active entity's type (hActiveEntityType): its bank comes from the table at
;@ $03:$4000 (one byte per type; bank 3 must be switched in), its address from EntityHandlers.
;@ test: skip dispatches into the entity handlers of eight banks
RunEntityHandler::
;>@bk SwitchBank(mem[0x4000 + hActiveEntityType])
	ldh a, [hActiveEntityType]
	ld e, a
	ld d, b
	ld hl, $4000
	add hl, de
	ld a, [hl]
;=@bk
	call SwitchBank
;> return EntityHandlers[hActiveEntityType](slot)
	ld a, e
	rst $00

;@ path: entity/engine
;@ The handler of every entity type (index = type, $00-$E8; 233 entries; $0000 = no such type). Each runs in
;@ the bank the table at $03:$4000 gives for its type, with bc = the entity's slot.
EntityHandlers::
	dw ArrowHandler                ; $00
	dw BoomerangHandler            ; $01
	dw BombHandler                ; $02
	dw HookshotEntityHandler                ; $03
	dw MagicRodFireballHandler                ; $04
	dw LiftableObjectHandler       ; $05
	dw PushedBlockHandler          ; $06
	dw ChestItemHandler                ; $07
	dw MagicPowderEntityHandler                ; $08
	dw OctorokHandler              ; $09
	dw OctorokRockHandler                ; $0A
	dw MoblinHandler               ; $0B
	dw MoblinArrowHandler                ; $0C
	dw TektiteHandler                ; $0D
	dw Leever                ; $0E
	dw ArmosHandler                ; $0F
	dw GhiniHandler                ; $10
	dw GiantGhiniHandler                ; $11
	dw GhiniHandler                ; $12
	dw HeartContainerSprite        ; $13
	dw SwordMoblinHandler                ; $14
	dw AntiFairyHandler                ; $15
	dw SparkHandler                ; $16
	dw SparkHandler                ; $17
	dw PolsVoiceHandler                ; $18
	dw KeeseHandler                ; $19
	dw StalfosHandler              ; $1A
	dw ZolHandler                ; $1B
	dw GelHandler                ; $1C
	dw $0000                       ; $1D
	dw EvasiveStalfosHandler       ; $1E
	dw GibdoHandler                ; $1F
	dw HardhatBeetleHandler        ; $20
	dw WizrobeHandler                ; $21
	dw WizrobeShotHandler                ; $22
	dw LikeLikeHandler                ; $23
	dw IronMaskHandler             ; $24
	dw BurningFlameSprites         ; $25
	dw BurningFlameSprites         ; $26
	dw SpikeTrapHandler                ; $27
	dw MimicHandler                ; $28
	dw MiniMoldormHandler          ; $29
	dw Beamos                ; $2A
	dw LaserBeamHandler            ; $2B
	dw SpikedBeetleHandler                ; $2C
	dw DroppedHeartHandler         ; $2D
	dw RupeeHandler                ; $2E
	dw FairyHandler                ; $2F
	dw KeyDropPointHandler         ; $30
	dw SwordHandler                ; $31
	dw Type32Handler               ; $32
	dw PieceOfPowerHandler         ; $33
	dw GuardianAcornHandler        ; $34
	dw HeartPieceHandler           ; $35
	dw HeartContainerHandler       ; $36
	dw DroppedArrowsHandler                ; $37
	dw DroppedBombsHandler                ; $38
	dw InstrumentHandler           ; $39
	dw ToadstoolHandler            ; $3A
	dw MagicPowderHandler                ; $3B
	dw GoldenLeafHandler                ; $3C
	dw SecretSeashellHandler                ; $3D
	dw MarinEntityHandler          ; $3E
	dw TarinEntityHandler          ; $3F
	dw WitchEntityHandler          ; $40
	dw OwlEventHandler                ; $41
	dw OwlStatueEntityHandler      ; $42
	dw SeashellMansionTreesHandler ; $43
	dw TalkingBonesHandler         ; $44
	dw BouldersHandler             ; $45
	dw LeverBlockDownHandler       ; $46
	dw LeverBlockUpHandler         ; $47
	dw LeverBlockRightHandler      ; $48
	dw LeverBlockLeftHandler       ; $49
	dw $0000                       ; $4A
	dw EntityHandler_Type4B        ; $4B
	dw $0000                       ; $4C
	dw ShopOwner                ; $4D
	dw Entity4E                ; $4E
	dw TrendyGameOwner                ; $4F
	dw BooBuddyHandler                ; $50
	dw BallTrooper                ; $51
	dw TractorDevice                ; $52
	dw TractorDevice                ; $53
	dw PondFisherman                ; $54
	dw BouncingBombite                ; $55
	dw TimerBombite                ; $56
	dw PairoddHandler                ; $57
	dw PairoddProjectileHandler                ; $58
	dw MoldormHandler              ; $59
	dw FacadeHandler               ; $5A
	dw SlimeEyeHandler             ; $5B
	dw GenieHandler                ; $5C
	dw SlimeEelEntityHandler                ; $5D
	dw GohmaEntityHandler                ; $5E
	dw MasterStalfosHandler                ; $5F
	dw DodongoSnakeEntityHandler                ; $60
	dw WarpHandler                 ; $61
	dw HotHeadEntityHandler        ; $62
	dw EvilEagleEntityHandler      ; $63
	dw SkyScrollEntityHandler      ; $64
	dw AnglerFishEntityHandler     ; $65
	dw CrystalSwitchHandler        ; $66
	dw AnglerRoomHelperEntityHandler; $67
	dw RollingBridgeHandler        ; $68
	dw LeverEntityHandler          ; $69
	dw RaftOwnerEntityHandler      ; $6A
	dw TextDebuggerEntityHandler   ; $6B
	dw CuccoEntityHandler          ; $6C
	dw BowWowEntityHandler         ; $6D
	dw ButterflyHandler                ; $6E
	dw DogHandler                  ; $6F
	dw KidHandler                ; $70
	dw KidCatchHandler                ; $71
	dw KidCatchHandler                ; $72
	dw KidHandler                ; $73
	dw MamashaEntityHandler        ; $74
	dw GrandmaUlriraEntityHandler  ; $75
	dw ChristineEntityHandler      ; $76
	dw UlriraHandler                ; $77
	dw PoodleHandler                ; $78
	dw MadamMeowMeowHandler                ; $79
	dw CrowHandler                ; $7A
	dw CrazyTracyHandler                ; $7B
	dw GiantGopongaHandler                ; $7C
	dw GopongaShotHandler                ; $7D
	dw GopongaFlowerHandler                ; $7E
	dw TurtleRockEntityHandler                ; $7F
	dw TelephoneHandler                ; $80
	dw RollingBonesHandler                ; $81
	dw SpikedBarHandler                ; $82
	dw DreamShrineBedHandler                ; $83
	dw GreatFairyHandler                ; $84
	dw BirdHandler                ; $85
	dw FloatingItemHandler                ; $86
	dw LanmolaHandler                ; $87
	dw ArmosKnightHandler          ; $88
	dw HinoxHandler                ; $89
	dw TileGlintHandler            ; $8A
	dw TileGlintHandler            ; $8B
	dw LeverGateShiftXHandler      ; $8C
	dw LeverGateShiftYHandler      ; $8D
	dw CueBallHandler              ; $8E
	dw MaskedMimicHandler          ; $8F
	dw ThreeOfAKindHandler         ; $90
	dw AntiKirbyHandler            ; $91
	dw SmasherHandler              ; $92
	dw MadBomberHandler            ; $93
	dw HiddenSwordMoblinHandler                ; $94
	dw RichardHandler              ; $95
	dw FrogHandler                ; $96
	dw SideViewWarpTriggerHandler  ; $97
	dw HorseHeadHandler                ; $98
	dw WaterTektiteHandler                ; $99
	dw FlyingTilesHandler                ; $9A
	dw HidingZolHandler                ; $9B
	dw StarHandler                ; $9C
	dw LiftableStatueHandler       ; $9D
	dw FireballShooterHandler                ; $9E
	dw GoombaHandler                ; $9F
	dw PeahatHandler                ; $A0
	dw SnakeHandler                ; $A1
	dw PiranhaPlantHandler                ; $A2
	dw MovingPlatformHandler                ; $A3
	dw MovingPlatformHandler                ; $A4
	dw SinkingPlatformHandler                ; $A5
	dw SideViewWeightsHandler                ; $A6
	dw PillarHandler                ; $A7
	dw IronBallHandler                ; $A8
	dw BlooperHandler                ; $A9
	dw CheepCheepHandler                ; $AA
	dw CheepCheepHandler                ; $AB
	dw JumpingCheepCheepHandler                ; $AC
	dw KikiHandler                ; $AD
	dw WingedOctorokHandler        ; $AE
	dw TradeItemHandler            ; $AF
	dw PincerHandler               ; $B0
	dw HoleFillerHandler           ; $B1
	dw BeetleSpawnerHandler        ; $B2
	dw HoneycombHandler            ; $B3
	dw TarinHoneycombHandler       ; $B4
	dw BearHandler                 ; $B5
	dw PapahlHandler               ; $B6
	dw MermaidHandler              ; $B7
	dw FishermanUnderBridgeHandler ; $B8
	dw BuzzBlobEntityHandler                ; $B9
	dw BomberEntityHandler                ; $BA
	dw BushCrawlerHandler          ; $BB
	dw GrimCreeperEntityHandler                ; $BC
	dw VireEntityHandler                ; $BD
	dw BlainoEntityHandler         ; $BE
	dw ZombieEntityHandler         ; $BF
	dw SignpostMazeEntityHandler   ; $C0
	dw MarinCompanionEntityHandler                ; $C1
	dw MarinSceneEntityHandler     ; $C2
	dw MamuEntityHandler           ; $C3
	dw WalrusEntityHandler         ; $C4
	dw UrchinHandler               ; $C5
	dw SandCrabHandler             ; $C6
	dw ManboEntityHandler          ; $C7
	dw BunnyCallingMarinEntityHandler; $C8
	dw MusicalNoteEntityHandler    ; $C9
	dw MadBatterEntityHandler      ; $CA
	dw ZoraEntityHandler           ; $CB
	dw FishHandler                 ; $CC
	dw BananasSchuleSaleHandler                ; $CD
	dw MermaidStatueEntityHandler  ; $CE
	dw SeashellMansionHandler                ; $CF
	dw AnimalD0EntityHandler       ; $D0
	dw AnimalD1EntityHandler       ; $D1
	dw AnimalD2EntityHandler       ; $D2
	dw AnimalD3EntityHandler       ; $D3
	dw GhostHandler                ; $D4
	dw RoosterCompanionHandler                ; $D5
	dw SideViewPotHandler                ; $D6
	dw ThwimpHandler                ; $D7
	dw ThwompHandler                ; $D8
	dw RammableBlockHandler                ; $D9
	dw PodobooHandler                ; $DA
	dw GiantBubbleHandler                ; $DB
	dw FlyingRoosterEventsHandler  ; $DC
	dw BookHandler                 ; $DD
	dw EggSongEventHandler         ; $DE
	dw SwordBeamHandler            ; $DF
	dw MonkeyHandler                ; $E0
	dw RatHandler                ; $E1
	dw FlameShooterHandler         ; $E2
	dw PokeyHandler                ; $E3
	dw MoblinKingHandler           ; $E4
	dw FloatingItemHandler                ; $E5
	dw FinalNightmareHandler                ; $E6
	dw CastleGateSwitchHandler     ; $E7
	dw EndingObjectHandler         ; $E8

;@ path: entity/engine
;@ Hitbox shapes, 4 bytes each: x offset, half width, y offset, half height (pixels, from the entity's
;@ position). LoadEntityHitbox picks one by wEntityHitboxFlags & $7C (bits 2-6 = shape * 4). 16 shapes.
EntityHitboxTable::
	db $08, $05, $08, $05, $08, $0a, $08, $0a, $08, $0a, $08, $0a, $08, $10, $04, $0a
	db $08, $02, $08, $02, $08, $13, $08, $13, $08, $06, $06, $08, $08, $07, $06, $0a
	db $08, $06, $10, $30, $08, $07, $04, $0a, $0c, $07, $fc, $04, $10, $10, $0c, $12
	db $08, $08, $02, $08, $10, $0c, $08, $10, $08, $07, $0c, $08, $08, $08, $02, $08

;@ def LoadEntityHitbox(slot: bc)
;@ path: entity/engine
;@ Copies the entity's hitbox shape (EntityHitboxTable, by wEntityHitboxFlags) into its 4 bytes of
;@ wEntityHitbox.
;@ test: slot = rand(0, 15)
LoadEntityHitbox::
;>@sh shape = EntityHitboxTable + (wEntityHitboxFlags[slot] & 0x7C)
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld a, [hl]
	and $7c
	ld e, a
	ld d, b
;=@sh
	ld hl, EntityHitboxTable
	add hl, de
	push hl
	pop de
;>@cp copy(wEntityHitbox + slot * 4, shape, 4)
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	ld c, $04
;=@cp
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, .copy

	pop bc
;> return
	ret


;@ def SetEntitySpriteVariant(slot: bc, variant: a)
;@ path: entity/engine
;@ Sets the entity's sprite variant.
SetEntitySpriteVariant::
;> wEntitySpriteVariant[slot] = variant
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
;> return
	ret


;@ def IncrementEntityState(slot: bc)
;@ path: entity/engine
;@ Moves the entity's state machine on to its next state.
IncrementEntityState::
;> wEntityState[slot] += 1
	ld hl, wEntityState
	add hl, bc
	inc [hl]
;> return
	ret


;@ def BounceLinkBack()
;@ path: link/damage
;@ HurtLinkOnGround (bank 2) from anywhere: Link is hurt and bounced back, unless he is still invincible.
BounceLinkBack::
;> set_rom_bank(0x02)
	ld a, $02
	ld [$2100], a
;> HurtLinkOnGround()
	call HurtLinkOnGround
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckWalls(slot: bc)
;@ path: entity/collision
;@ EntityCheckWalls_03 from any bank: the entity stops at walls and solid room objects (its ground status is
;@ looked at and cleared).
EntityCheckWalls::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckWalls_03(slot)
	call EntityCheckWalls_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckObjectCollision(slot: bc)
;@ path: entity/collision
;@ EntityCheckObjectCollision_03 from any bank: what the entity has run into in the room (wall, hole, water, ...).
EntityCheckObjectCollision::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckObjectCollision_03(slot)
	call EntityCheckObjectCollision_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckHits(slot: bc)
;@ path: entity/collision
;@ EntityCheckHits_03 from any bank: contact damage to Link and hits from Link's weapons.
EntityCheckHits::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckHits_03(slot)
	call EntityCheckHits_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckContactDamage(slot: bc)
;@ path: entity/collision
;@ EntityCheckContactDamage_03 from any bank: the entity hurts Link when it touches him.
EntityCheckContactDamage::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckContactDamage_03(slot)
	call EntityCheckContactDamage_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckTouchLink(slot: bc)
;@ path: entity/collision
;@ ProjectileHitsLink from any bank: the entity hits Link when they touch (while Link walks on the ground).
EntityCheckTouchLink::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> ProjectileHitsLink(slot)
	call ProjectileHitsLink
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityTouchesLink(slot: bc) -> carry
;@ path: entity/collision
;@ EntityTouchesLink_03 from any bank: carry set when the entity touches Link.
EntityTouchesLink::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> r = EntityTouchesLink_03(slot)
	call EntityTouchesLink_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank
;> return r


;@ def EntityCheckSwordClash(slot: bc)
;@ path: entity/collision
;@ EntityCheckSwordClash_03 from any bank: Link's sword against the entity's clash box (parrying).
EntityCheckSwordClash::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckSwordClash_03(slot)
	call EntityCheckSwordClash_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityCheckWeaponHits(slot: bc)
;@ path: entity/collision
;@ EntityCheckWeaponHits_03 from any bank: hits from Link's weapons only (no contact damage).
EntityCheckWeaponHits::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityCheckWeaponHits_03(slot)
	call EntityCheckWeaponHits_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def EntityHitOtherEntities(slot: bc)
;@ path: entity/collision
;@ EntityHitOtherEntities_03 from any bank: the entity hits the other entities it touches.
EntityHitOtherEntities::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> EntityHitOtherEntities_03(slot)
	call EntityHitOtherEntities_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SpawnEntity(type: a) -> (de, carry)
;@ path: entity/spawn
;@ SpawnEntity_03 from any bank: a new entity of type `type` in the first free slot (de = the slot;
;@ carry set when none is free). The carry is kept across the bank switch back.
SpawnEntity::
;> set_rom_bank(0x03)
	push af
	ld a, $03
	ld [$2100], a
	pop af
;> slot, full = SpawnEntity_03(type)
	call SpawnEntity_03
;> set_rom_bank(wCurrentBank)              # (rr / rl l keep the carry)
	rr l
	call RestoreBank
	rl l
;> return slot, full
	ret


;@ def SpawnEntityFromSlot(type: a, last: e) -> (de, carry)
;@ path: entity/spawn
;@ SpawnEntityFromSlot_03 from any bank: like SpawnEntity, but only slots 0-`last` are used (de = the
;@ slot; carry set when none is free).
SpawnEntityFromSlot::
;> set_rom_bank(0x03)
	push af
	ld a, $03
	ld [$2100], a
	pop af
;> slot, full = SpawnEntityFromSlot_03(type, last)
	call SpawnEntityFromSlot_03
;> set_rom_bank(wCurrentBank)              # (rr / rl l keep the carry)
	rr l
	call RestoreBank
	rl l
;> return slot, full
	ret


;@ def SetEntitySpeedTowardsLink(slot: bc, speed: a)
;@ path: entity/movement
;@ SetEntitySpeedTowardsLink_03 from any bank: sets the entity's x / y speed to move towards Link at `speed` (the vector
;@ is also left in hMultiPurpose0 / 1).
SetEntitySpeedTowardsLink::
;> set_rom_bank(0x03)
	ld hl, $2100
	ld [hl], $03
;> SetEntitySpeedTowardsLink_03(slot, speed)
	call SetEntitySpeedTowardsLink_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def GetVectorTowardsLink(slot: bc, speed: a)
;@ path: entity/movement
;@ GetVectorTowardsLink_03 from any bank: the speed vector from the entity towards Link at `speed`: y in
;@ hMultiPurpose0, x in hMultiPurpose1.
GetVectorTowardsLink::
;> set_rom_bank(0x03)
	ld hl, $2100
	ld [hl], $03
;> GetVectorTowardsLink_03(slot, speed)
	call GetVectorTowardsLink_03
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def DrawEntity16x16(slot: bc, sprites: de)
;@ path: entity/draw
;@ Draws the active entity as two 8x16 sprites side by side. `sprites` holds 4 bytes per sprite variant
;@ (left tile, left attributes, right tile, right attributes); hActiveEntitySpriteVariant picks the
;@ entry ($FF = draw nothing). With the x flip bit set the two halves swap places. hActiveEntityTileOffset
;@ is added to both tiles; a half whose tile number ends in $F is hidden (x = $F0). The sprites go to
;@ the entity area of the OAM buffer at wOAMNextIndex; then FinishEntityDraw hands out the entries and
;@ adds the shadow. Skipped for entities outside the screen during a room transition.
;@ test: skip calls routines in another bank
DrawEntity16x16::
;> if hActiveEntitySpriteVariant == 0xFF: return
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z

;> SkipDrawIfOffscreen(slot)
	call SkipDrawIfOffscreen
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	push de
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, b
	ld hl, wOAMBuffer + $30
	add hl, de
;> mem[oam] = hActiveEntityDrawY
	push hl
	pop de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
;>@x1 mem[oam + 1] = u8(hActiveEntityX + (hActiveEntityFlipAttribute & 0x20) // 4 - wScreenShakeX)
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	rra
	rra
;=@x1
	ld hl, hActiveEntityX
	add [hl]
	sub c
	ld [de], a
	inc de
;>@v entry = sprites + hActiveEntitySpriteVariant * 4
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
;=@v
	rl b
	pop hl
	add hl, bc
;> tile = u8(mem[entry] + hActiveEntityTileOffset)
	ldh a, [hActiveEntityTileOffset]
	ld c, a
	ld a, [hli]
	add c
;> mem[oam + 2] = tile
	ld [de], a
;> if tile & 0x0F == 0x0F:                     # an empty half: moved off the screen
	and $0f
	cp $0f
	jr nz, jr_000_3c83

;>     mem[oam + 1] = 0xF0
	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3c83:
;> mem[oam + 3] = mem[entry + 1] ^ hActiveEntityFlipAttribute
	inc de
	ld a, [hli]
	push hl
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
;> mem[oam + 4] = hActiveEntityDrawY
	inc de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
;>@x2 mem[oam + 5] = u8(hActiveEntityX + ((hActiveEntityFlipAttribute & 0x20) ^ 0x20) // 4 - wScreenShakeX)
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	xor $20
	rra
;=@x2
	rra
	ld hl, hActiveEntityX
	sub c
	add [hl]
	ld [de], a
	inc de
;> tile = u8(mem[entry + 2] + hActiveEntityTileOffset)
	pop hl
	ldh a, [hActiveEntityTileOffset]
	ld c, a
	ld a, [hli]
	add c
;> mem[oam + 6] = tile
	ld [de], a
;> if tile & 0x0F == 0x0F:
	and $0f
	cp $0f
	jr nz, jr_000_3cb5

;>     mem[oam + 5] = 0xF0
	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3cb5:
;> mem[oam + 7] = mem[entry + 3] ^ hActiveEntityFlipAttribute
	inc de
	ld a, [hl]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
;> FinishEntityDraw()                          # falls through

;@ def FinishEntityDraw()
;@ path: entity/draw
;@ After an entity's sprites were written: ReserveEntityOAM_15 moves the OAM position past them and
;@ DrawEntityShadow_15 adds its shadow, ripple or grass (both in bank 15).
;@ test: skip calls routines in another bank
FinishEntityDraw::
;> slot = wActiveEntitySlot
	ld a, [wActiveEntitySlot]
	ld c, a
	ld b, $00
;> set_rom_bank(0x15)
	ld a, $15
	ld [$2100], a
;> ReserveEntityOAM_15(slot)
	call ReserveEntityOAM_15

jr_000_3cca:
;> DrawEntityShadow_15(slot)
	call DrawEntityShadow_15
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def DrawEntity8x16(slot: bc, sprites: de)
;@ path: entity/draw
;@ Draws the active entity as a single 8x16 sprite, centred on its x (x + 4). `sprites` holds 2 bytes
;@ per sprite variant (tile, attributes); hActiveEntitySpriteVariant picks the entry ($FF = draw
;@ nothing). In the side-view areas the sprite is raised by 4 pixels (also kept in
;@ hActiveEntityDrawY). No tile offset is added. Ends in FinishEntityDraw.
;@ test: skip calls routines in another bank
DrawEntity8x16::
;> if hActiveEntitySpriteVariant == 0xFF: return
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z

;> SkipDrawIfOffscreen(slot)
	call SkipDrawIfOffscreen
;> oam = wOAMBuffer + 0x30 + wOAMNextIndex
	push de
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld bc, wOAMBuffer + $30
	add hl, bc
;> y = hActiveEntityDrawY
	push hl
	pop de
	ld a, [wActiveEntitySlot]
	ld c, a
	ld b, $00
;> if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	ldh a, [hActiveEntityDrawY]
	jr z, jr_000_3cf5

;>     y = u8(y - 4)
	sub $04
;>     hActiveEntityDrawY = y
	ldh [hActiveEntityDrawY], a

jr_000_3cf5:
;> mem[oam] = y
	ld [de], a
	inc de
;> mem[oam + 1] = u8(hActiveEntityX + 4 - wScreenShakeX)
	ld a, [wScreenShakeX]
	ld h, a
	ldh a, [hActiveEntityX]
	add $04
	sub h
	ld [de], a
;>@e entry = sprites + hActiveEntitySpriteVariant * 2
	inc de
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
;=@e
	pop hl
	add hl, bc
;> mem[oam + 2] = mem[entry]
	ld a, [hli]
	ld [de], a
	inc de
;> mem[oam + 3] = mem[entry + 1] ^ hActiveEntityFlipAttribute
	ld a, [hli]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	inc de
;> return FinishEntityDraw()
	jr FinishEntityDraw

;@ def DrawEntityShadow(slot: bc)
;@ path: entity/draw
;@ DrawEntityShadow_15 from any bank: only the shadow, ripple or grass under the entity in `slot`.
;@ test: skip calls routines in another bank
DrawEntityShadow::
;> set_rom_bank(0x15)
	ld a, $15
	ld [$2100], a
;> DrawEntityShadow_15(slot)
;> set_rom_bank(wCurrentBank)
	jr jr_000_3cca

;@ def DrawEntitySpritesAtOAMStart(count: c, sprites: hl)
;@ path: entity/draw
;@ Like DrawEntitySprites, but the sprites are written to the very start of the OAM buffer (before the
;@ entity area), so they are always shown. Used for entities that must never flicker.
DrawEntitySpritesAtOAMStart::
;> pass                                        # (the asm hands `sprites` over on the stack)
	push hl
;> return DrawSpriteListToOAM(wOAMBuffer, count, sprites)
	ld hl, wOAMBuffer
	jr DrawSpriteListToOAM

;@ def DrawEntitySprites(count: c, sprites: hl)
;@ path: entity/draw
;@ Draws the active entity from a list of `count` sprites, 4 bytes each: y offset, x offset, tile,
;@ attributes (offsets from the entity's draw position). Written at wOAMNextIndex in the entity area
;@ of the OAM buffer. When hActiveEntitySpriteVariant is $FF nothing is drawn (c = the entity's slot
;@ on return).
DrawEntitySprites::
;> if hActiveEntitySpriteVariant == 0xFF: return SkipEntitySprites()
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	jr z, SkipEntitySprites

;> pass                                        # (the asm hands `sprites` over on the stack)
	push hl
;> return DrawSpriteListToOAM(wOAMBuffer + 0x30 + wOAMNextIndex, count, sprites)    # falls through
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, wOAMBuffer + $30
	add hl, de

;@ def DrawSpriteListToOAM(oam: hl, count: c, sprites: stack)
;@ path: entity/draw
;@ Writes `count` sprites of the active entity to the OAM buffer at `oam`. The sprite list (4 bytes per
;@ sprite: y offset, x offset, tile, attributes) is passed on the stack: the caller pushes it.
;@ y = hActiveEntityDrawY + y offset, x = hActiveEntityX + x offset - wScreenShakeX, tile +
;@ hActiveEntityTileOffset (a tile of $FF hides the sprite with x = 0), attributes ^
;@ hActiveEntityFlipAttribute. Then ReserveEntityOAM_15 hands out the entries. Skipped for entities
;@ outside the screen during a room transition.
;@ test: skip takes the sprite list from the stack
DrawSpriteListToOAM::
;> pass                                        # (`sprites` is popped off the stack here)
	push hl
	pop de
	pop hl
;> hMultiPurpose0 = count
	ld a, c
	ldh [hMultiPurpose0], a
;> SkipDrawIfOffscreen(wActiveEntitySlot)
	ld a, [wActiveEntitySlot]
	ld c, a
	call SkipDrawIfOffscreen
;> for i in range(hMultiPurpose0):
	ldh a, [hMultiPurpose0]
	ld c, a

jr_000_3d46:
;>     mem[oam] = u8(hActiveEntityDrawY + mem[sprites])
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld [de], a
	inc hl
	inc de
;>@sx     mem[oam + 1] = u8(hActiveEntityX + mem[sprites + 1] - wScreenShakeX)
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityX]
	add [hl]
	sub c
;=@sx
	ld [de], a
	inc hl
	inc de
;>     tile = mem[sprites + 2]
	ldh a, [hActiveEntityTileOffset]
	ld c, a
	ld a, [hli]
	push af
;>     mem[oam + 2] = u8(tile + hActiveEntityTileOffset)
	add c
	ld [de], a
	pop af
;>     if tile == 0xFF:                         # an unused sprite: moved off the screen
	cp $ff
	jr nz, jr_000_3d68

;>         mem[oam + 1] = 0
	dec de
	xor a
	ld [de], a
	inc de

jr_000_3d68:
;>     mem[oam + 3] = hActiveEntityFlipAttribute ^ mem[sprites + 3]
	pop bc
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
;>     oam += 4; sprites += 4
	inc de
	dec c
	jr nz, jr_000_3d46

;> set_rom_bank(0x15)
	ld a, [wActiveEntitySlot]
	ld c, a
	ld a, $15
	ld [$2100], a
;> ReserveEntityOAM_15(wActiveEntitySlot)
	call ReserveEntityOAM_15
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SkipEntitySprites() -> c
;@ path: entity/draw
;@ End of DrawEntitySprites when the entity is hidden (sprite variant $FF): nothing is drawn, c is
;@ set back to the entity's slot.
SkipEntitySprites::
;> return wActiveEntitySlot
	ld a, [wActiveEntitySlot]
	ld c, a
	ret


;@ def SkipDrawIfOffscreen(slot: bc)
;@ path: entity/draw
;@ During a room transition, an entity outside the visible area (x not in 1..$C0, draw y not in
;@ 1..$88, or a nonzero high byte of its x / y position) is not drawn: the return address is dropped,
;@ so the drawing routine that called this returns at once. Outside a transition it does nothing.
;@ test: skip drops its return address from the stack
SkipDrawIfOffscreen::
;> if wRoomTransitionState:
	push hl
	ld a, [wRoomTransitionState]
	and a
	jr z, jr_000_3dad

;>     if u8(hActiveEntityX - 1) >= 0xC0:
	ldh a, [hActiveEntityX]
	dec a
	cp $c0
	jr nc, jr_000_3dac

;>@off         return_from_caller()
;>     elif u8(hActiveEntityDrawY - 1) >= 0x88:
	ldh a, [hActiveEntityDrawY]
	dec a
	cp $88
	jr nc, jr_000_3dac

;>@off         return_from_caller()
;>     elif wEntityPosXHigh[slot]:
	ld hl, wEntityPosXHigh
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_000_3dac

;>@off         return_from_caller()
;>     elif wEntityPosYHigh[slot]:
	ld hl, wEntityPosYHigh
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_3dad

;>@off         return_from_caller()
jr_000_3dac:
;=@off
	pop af

jr_000_3dad:
;> return
	pop hl
	ret


;@ def ClearEntitySpeed(slot: bc)
;@ path: entity/movement
;@ Stops the entity in `slot`: its x and y speed are set to 0 (b, the high byte of the slot, is the 0
;@ that is stored).
;@ test: slot = rand(0, 15)
ClearEntitySpeed::
;> wEntitySpeedX[slot] = 0
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
;> wEntitySpeedY[slot] = 0
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ret


;@ def LoadEntityPosition(slot: bc)
;@ path: entity/draw
;@ Copies the position of the entity in `slot` to hActiveEntityX / hActiveEntityY; the draw y
;@ (hActiveEntityDrawY) is y minus its height above the ground (wEntityZ).
;@ test: slot = rand(0, 15)
LoadEntityPosition::
;> hActiveEntityX = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityY = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityY], a
;> hActiveEntityDrawY = u8(hActiveEntityY - wEntityZ[slot])
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
	ldh [hActiveEntityDrawY], a
	ret


;@ def ReserveOAMEntriesFar(count: a)
;@ path: entity/draw
;@ ReserveOAMEntries_15 from any bank: moves the OAM write position past `count` sprites.
;@ test: skip calls routines in another bank
ReserveOAMEntriesFar::
;> set_rom_bank(0x15)
	ld hl, $2100
	ld [hl], $15
;> ReserveOAMEntries_15(count)
	call ReserveOAMEntries_15
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def MiniMoldormInitFar(slot: bc)
;@ path: entity/init
;@ MiniMoldormInit (bank 4) from any bank: set-up of a new Mini Moldorm (entity $29), an entry
;@ of the entity init table in bank 3.
;@ test: slot = rand(0, 15)
MiniMoldormInitFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> MiniMoldormInit(slot)
	call MiniMoldormInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def MoldormInitFar(slot: bc)
;@ path: entity/init
;@ MoldormInit (bank 4) from any bank: set-up of a new Moldorm, an entry of the entity init table
;@ in bank 3.
MoldormInitFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> MoldormInit(slot)
	call MoldormInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def FacadeInitFar(slot: bc)
;@ path: entity/init
;@ FacadeInit (bank 4) from any bank: set-up of a new Facade, an entry of the entity init table in
;@ bank 3.
FacadeInitFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> FacadeInit(slot)
	call FacadeInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def SlimeEyeInitFar(slot: bc)
;@ path: entity/init
;@ SlimeEyeInit (bank 4) from any bank: set-up of a new Slime Eye, an entry of the entity init
;@ table in bank 3.
SlimeEyeInitFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> SlimeEyeInit(slot)
	call SlimeEyeInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def GenieInitFar(slot: bc)
;@ path: entity/init
;@ GenieInit (bank 4) from any bank: set-up of a new Genie (entity $5C), an entry of the entity init
;@ table in bank 3.
GenieInitFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> GenieInit(slot)
	call GenieInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def SlimeEelInitFar(slot: bc)
;@ path: entity/init
;@ SlimeEelInit (bank 5) from any bank: set-up of a new Slime Eel, an entry of the entity init table
;@ in bank 3.
SlimeEelInitFar::
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> SlimeEelInit(slot)
	call SlimeEelInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def DodongoSnakeInitFar(slot: bc)
;@ path: entity/init
;@ DodongoSnakeInit (bank 5) from any bank: set-up of a new Dodongo Snake, an entry of the entity
;@ init table in bank 3.
;@ test: slot = rand(0, 15)
DodongoSnakeInitFar::
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> DodongoSnakeInit(slot)
	call DodongoSnakeInit
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def HideEntityWithFullHealthFar(slot: bc)
;@ path: entity/init
;@ HideEntityWithFullHealth_05 (bank 5) from any bank: the entity is hidden for $40 frames with its
;@ health set to $FF.
;@ test: slot = rand(0, 15)
HideEntityWithFullHealthFar::
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> HideEntityWithFullHealth_05(slot)
	call HideEntityWithFullHealth_05
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def EvilEagleArenaSetupFar(slot: bc)
;@ path: entity/init
;@ EvilEagleArenaSetup (bank 5) from any bank: sets up the fight on top of Eagle's Tower again.
EvilEagleArenaSetupFar::
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> EvilEagleArenaSetup(slot)
	call EvilEagleArenaSetup
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def AnglerRoomHelperFar(slot: bc)
;@ path: entity/init
;@ AnglerRoomHelperEntityHandler (bank 5) from any bank: the invisible helper in the Angler Fish's
;@ room (falling rocks).
;@ test: slot = rand(0, 15)
AnglerRoomHelperFar::
;> set_rom_bank(0x05)
	ld hl, $2100
	ld [hl], $05
;> AnglerRoomHelperEntityHandler(slot)
	call AnglerRoomHelperEntityHandler
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def CheckLinkLeavesRoomFar()
;@ path: link/room_edge
;@ CollideLinkWithRoom (bank 2) from any bank, with the bank saved and restored through SwitchBank: checks
;@ whether Link has walked off the edge of the room (nothing while a dialog or the inventory is open).
CheckLinkLeavesRoomFar::
;> bank = wCurrentBank
	ld a, [wCurrentBank]
	push af
;> SwitchBank(0x02)
	ld a, $02
	call SwitchBank
;> CollideLinkWithRoom()
	call CollideLinkWithRoom
;> return SwitchBank(bank)
	pop af
	jp SwitchBank


;@ def GhiniMoveFar(slot: bc)
;@ path: entity/init
;@ The Ghini behaviour in bank 4 from any bank, entered at 04:5C5A inside GhiniCommon, after its hit
;@ checks: position and height update, hovering and the rest of its movement.
;@ test: skip enters bank 4 in the middle of GhiniCommon
GhiniMoveFar::
;> set_rom_bank(0x04)
	ld hl, $2100
	ld [hl], $04
;> pass                                        # GhiniCommon from 04:5C5A on (its movement part)
	call $5c5a
;> set_rom_bank(wCurrentBank)
	jp RestoreBank

;@ def BreakIntoPiecesFar(slot: bc)
;@ path: object/liftable
;@ BreakIntoPieces (bank 3) from any bank: the entity in `slot` is replaced by breaking pot pieces.
BreakIntoPiecesFar::
;> set_rom_bank(0x03)
	ld hl, $2100
	ld [hl], $03
;> BreakIntoPieces(slot)
	call BreakIntoPieces
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def DrawRupeesAndHeartsFar()
;@ path: hud/status_bar
;@ DrawRupeeCount and DrawHearts (bank 2) from any bank: queues the rupee count and the hearts of the
;@ status bar.
DrawRupeesAndHeartsFar::
;> set_rom_bank(0x02)
	ld hl, $2100
	ld [hl], $02
;> DrawRupeeCount()
	call DrawRupeeCount
;> DrawHearts()
	call DrawHearts
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SpawnChestContentsFrom3()
;@ path: item/chest
;@ SpawnChestContents (bank 2) for code in bank 3, which is switched back to afterwards: the item
;@ rises out of the opened chest.
SpawnChestContentsFrom3::
;> SwitchBank(0x02)
	ld a, $02
	call SwitchBank
;> SpawnChestContents()
	call SpawnChestContents
;> return SwitchBank(0x03)
	ld a, $03
	jp SwitchBank


;@ def DrawItemSlotsABFar()
;@ path: hud/status_bar
;@ DrawItemSlotsAB (bank 2) from any bank: queues the B and A item slots of the status bar.
DrawItemSlotsABFar::
;> set_rom_bank(0x02)
	ld hl, $2100
	ld [hl], $02
;> DrawItemSlotsAB()
	call DrawItemSlotsAB
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def GiveInventoryItemFar(item: d)
;@ path: item/inventory
;@ GiveInventoryItem (bank 3) from any bank: puts `item` into Link's inventory.
GiveInventoryItemFar::
;> set_rom_bank(0x03)
	ld hl, $2100
	ld [hl], $03
;> GiveInventoryItem(item)
	call GiveInventoryItem
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def DrawInstrumentWarpEffectFrom3(slot: bc)
;@ path: item/instruments
;@ DrawInstrumentWarpEffect (bank 6) for the instrument entity in bank 3, which is switched back to afterwards:
;@ draws the 16 animated sprites around Link while an instrument warps him out of the dungeon.
DrawInstrumentWarpEffectFrom3::
;> SwitchBank(0x06)
	ld a, $06
	call SwitchBank
;> DrawInstrumentWarpEffect(slot)
	call DrawInstrumentWarpEffect
;> return SwitchBank(0x03)
	ld a, $03
	jp SwitchBank


;@ def ClearAllEntitySlots()
;@ path: entity/slots
;@ Frees all 16 entity slots (wEntityStatus = 0).
ClearAllEntitySlots::
;> for i in range(16):
	ld e, $10
	ld hl, wEntityStatus

jr_000_3eb2:
;>     wEntityStatus[i] = 0
	xor a
	ld [hli], a
	dec e
	jr nz, jr_000_3eb2

	ret


;@ def AddPowerHitTrailVfx(slot: bc)
;@ path: entity/defeat
;@ For an entity sent flying by a hit with the Piece of Power (wEntityHitByPowerUp): every 4th frame
;@ (shifted by the slot number) leaves a visual effect of kind 8 at its draw position, shown for $0F
;@ frames.
AddPowerHitTrailVfx::
;> if not wEntityHitByPowerUp[slot]: return
	ld hl, wEntityHitByPowerUp
	add hl, bc
	ld a, [hl]
	and a
	ret z

;> if (hFrameCounter ^ slot) & 0x03: return
	ldh a, [hFrameCounter]
	xor c
	and $03
	ret nz

;> hMultiPurpose0 = hActiveEntityX
	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = hActiveEntityDrawY
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
;> vfx = AddTransientVfx(0x08)
	ld a, $08
	call AddTransientVfx
;> wVfxTimer[vfx] = 0x0F
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f
	ret


;@ def EndHitImmunityAtWall(slot: bc)
;@ path: entity/collision
;@ When an entity that is being knocked back runs into a wall in the main direction of the knock-back
;@ (wEntityCollisions bits 0-1 for a mostly horizontal one, bits 2-3 for a mostly vertical one), its
;@ wEntityIgnoreHitsTimer is cleared, so it can be hit again at once.
;@ test: slot = rand(0, 15)
EndHitImmunityAtWall::
;> dx = wEntityRecoilSpeedX[slot]
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld a, [hl]
;> if dx & 0x80:
	bit 7, a
	jr z, jr_000_3ee4

;>     dx = u8(-dx)
	cpl
	inc a

jr_000_3ee4:
;> hMultiPurpose0 = dx
	ldh [hMultiPurpose0], a
;> dy = wEntityRecoilSpeedY[slot]
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld a, [hl]
;> if dy & 0x80:
	bit 7, a
	jr z, jr_000_3ef1

;>     dy = u8(-dy)
	cpl
	inc a

jr_000_3ef1:
;> walls = 0x03 if dy < hMultiPurpose0 else 0x0C     # mostly sideways: the right / left wall bits
	ld e, $03
	ld hl, hMultiPurpose0
	cp [hl]
	jr c, jr_000_3efb

	ld e, $0c

jr_000_3efb:
;> if walls & wEntityCollisions[slot]:
	ld a, e
	ld hl, wEntityCollisions
	add hl, bc
	and [hl]
	jr z, jr_000_3f08

;>     wEntityIgnoreHitsTimer[slot] = 0
	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b

jr_000_3f08:
;> return
	ret


;@ path: boss/intro
;@ The line a dungeon boss says when the fight starts, one byte per dungeon (indexed by hMapId 0-8):
;@ dialog number for OpenDialog ($B0-$BC). StartBossMusic skips map 5, so its entry ($B6) is not
;@ used from here.
BossIntroDialogs::
	db $b0, $b4, $b1, $b2, $b3, $b6, $ba, $bc, $b8

;@ def StartBossMusic(slot: bc)
;@ path: boss/intro
;@ Called every frame by bosses and mini-bosses before the fight. Once no room transition or
;@ inventory is in the way and wBossMusicDelay has run out, it starts the boss music, only once:
;@ track $19, or $50 when the entity's option bit 2 is set (also put in hDefaultMusicTrackAlt so that
;@ it stays). If the screen fade is done by then (wTransitionSequenceCounter = 4), the boss's opening
;@ line is shown: dialog $DA for entity $87, $26 for entity $BC, else the one of the dungeon from
;@ BossIntroDialogs (none with option bit 2 or in map 5).
StartBossMusic::
;> if wRoomTransitionState | wInventoryAppearing: return
	ld hl, wInventoryAppearing
	ld a, [wRoomTransitionState]
	or [hl]
	ret nz

;> if wBossMusicDelay:
	ld a, [wBossMusicDelay]
	and a
	jr z, jr_000_3f25

;>     wBossMusicDelay -= 1
	dec a
	ld [wBossMusicDelay], a
;>     return
	ret


jr_000_3f25:
;> if wBossMusicStarted: return
	ld a, [wBossMusicStarted]
	and a
	ret nz

;> wBossMusicStarted = 1
	inc a
	ld [wBossMusicStarted], a
;> other = wEntityOptions1[slot] & 0x04
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $04
;> track = 0x50 if other else 0x19
	ld a, $19
	jr z, jr_000_3f3b

	ld a, $50

jr_000_3f3b:
;> wMusicTrackToPlay = track
	ld [wMusicTrackToPlay], a
;> hDefaultMusicTrackAlt = track
	ldh [hDefaultMusicTrackAlt], a
;> if wTransitionSequenceCounter != 4: return
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

;> if hActiveEntityType == 0x87:
	ldh a, [hActiveEntityType]
	cp $87
	jr nz, jr_000_3f50

;>     dialog = 0xDA
	ld a, $da
	jr jr_000_3f6e

jr_000_3f50:
;> elif hActiveEntityType == 0xBC:
	cp $bc
	jr nz, jr_000_3f58

;>     dialog = 0x26
	ld a, $26
	jr jr_000_3f6e

jr_000_3f58:
;>@m5 elif wEntityOptions1[slot] & 0x04 or hMapId == 5:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $04
	jr nz, jr_000_3f71

;=@m5
	ldh a, [hMapId]
	cp $05
	jr z, jr_000_3f71

;>@rt     return
;> else:
;>     dialog = BossIntroDialogs[hMapId]
	ld e, a
	ld d, b
	ld hl, BossIntroDialogs
	add hl, de
	ld a, [hl]

jr_000_3f6e:
;> OpenDialog(dialog)
	call OpenDialog

jr_000_3f71:
;=@rt
	ret


;@ path: entity/defeat
;@ Bit masks 1 << n for n = 0-7 (one byte each), used by MarkEntityDefeated.
RoomEntityBitMask2::
	db $01, $02, $04, $08, $10, $20, $40, $80

;@ def DefeatEntityWithDrop(slot: bc)
;@ path: entity/defeat
;@ Ends a defeated entity: mem[$C113] is set to 3, DropDefeatedEntityItem (bank 3) leaves its item,
;@ then DefeatEntity notes it as defeated and frees its slot.
DefeatEntityWithDrop::
;> mem[0xC113] = 3
	ld a, $03
	ld [$c113], a
;> set_rom_bank(0x03)
	ld [$2100], a
;> DropDefeatedEntityItem(slot)
	call DropDefeatedEntityItem
;> set_rom_bank(wCurrentBank)
	call RestoreBank
;> DefeatEntity(slot)                          # falls through

;@ def DefeatEntity(slot: bc)
;@ path: entity/defeat
;@ Remembers that the entity in `slot` was defeated, so it does not come back: its position in the
;@ room's entity list (wEntityLoadOrder; $FF = not from the list, nothing is noted) is added to
;@ wDefeatedEntities, and MarkEntityDefeated sets its bit for the room. Then the slot is freed.
;@ test: slot = rand(0, 15)
DefeatEntity::
;> pos = wEntityLoadOrder[slot]
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
;> if pos == 0xFF: return FreeEntitySlot(slot)
	cp $ff
	jr z, FreeEntitySlot

;> n = wDefeatedEntityCount
	push af
	ld a, [wDefeatedEntityCount]
	ld e, a
	ld d, b
;> wDefeatedEntityCount = n + 1
	inc a
	ld [wDefeatedEntityCount], a
;> wDefeatedEntities[n] = pos
	ld a, [hl]
	ld hl, wDefeatedEntities
	add hl, de
	ld [hl], a
	pop af
;> MarkEntityDefeated(slot, pos)               # falls through

;@ def MarkEntityDefeated(slot: bc, pos: a)
;@ path: entity/defeat
;@ For list positions 0-7: sets bit `pos` of the current room's byte in wRoomDefeatedEntityBits, so
;@ that entity is not loaded again. Then frees the slot.
;@ test: slot = rand(0, 15); pos = rand(0, 15)
MarkEntityDefeated::
;> if pos < 8:
	cp $08
	jr nc, FreeEntitySlot

;>     bit = mem[RoomEntityBitMask2 + pos]
	ld e, a
	ld d, b
	ld hl, RoomEntityBitMask2
	add hl, de
;>@or     wRoomDefeatedEntityBits[hMapRoom] |= bit
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
	add hl, de
;=@or
	or [hl]
	ld [hl], a
;> FreeEntitySlot(slot)                        # falls through

;@ def FreeEntitySlot(slot: bc)
;@ path: entity/slots
;@ Removes the entity in `slot` (wEntityStatus = 0).
;@ test: slot = rand(0, 15)
FreeEntitySlot::
;> wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


;@ def LoadBGChangeTilesA()
;@ path: gfx/bg_change
;@ A background change handler (from the hBGChangeRequest dispatch): copies the two tiles of
;@ BGChangeTilesA (bank 5, 16 bytes each) to VRAM $8460 and $8480, then CopyBGChangeTile2 ends the
;@ request.
LoadBGChangeTilesA::
;> set_rom_bank(0x05)
	ld a, $05
	ld [$2100], a
;> copy(0x8460, BGChangeTilesA, 0x10)
	ld hl, BGChangeTilesA
	ld de, $8460
	ld bc, $0010
	call CopyData
;> return CopyBGChangeTile2(BGChangeTilesA + 0x10)
	ld hl, BGChangeTilesA + $10
	jr CopyBGChangeTile2

;@ def LoadBGChangeTilesB()
;@ path: gfx/bg_change
;@ Like LoadBGChangeTilesA, with the two tiles of BGChangeTilesB.
LoadBGChangeTilesB::
;> set_rom_bank(0x05)
	ld a, $05
	ld [$2100], a
;> copy(0x8460, BGChangeTilesB, 0x10)
	ld hl, BGChangeTilesB
	ld de, $8460
	ld bc, $0010
	call CopyData
;> CopyBGChangeTile2(BGChangeTilesB + 0x10)    # falls through
	ld hl, BGChangeTilesB + $10

;@ def CopyBGChangeTile2(src: hl)
;@ path: gfx/bg_change
;@ Copies the second tile (16 bytes at `src`) to VRAM $8480, clears hBGChangeRequest and goes on with
;@ DrawLinkOAM, with bank $0C selected.
CopyBGChangeTile2::
;> copy(0x8480, src, 0x10)
	ld de, $8480
	ld bc, $0010
	call CopyData
;> hBGChangeRequest = 0
	xor a
	ldh [hBGChangeRequest], a
;> set_rom_bank(0x0C)
	ld a, $0c
	ld [$2100], a
;> return DrawLinkOAM()
	jp DrawLinkOAM


;@ path: unused
;@ 5 unused bytes ($FF) at the end of bank 0.
Padding3FFB::
	db $ff, $ff, $ff, $ff, $ff
