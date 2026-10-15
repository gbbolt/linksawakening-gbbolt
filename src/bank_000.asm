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
;> LCDOff()
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

;> LCDOff()
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
;> LCDOff()
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
;@ advanced by one in Call_1DEE.
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
;>@lt                     Call_1CCC()
	call Call_1CCC

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
;>                 Call_1DEE(wRaisedBlockStep)
	call Call_1DEE
;>                 Call_1CCC()
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
;>     Bank02_6BB8()
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
;>     Bank02_6B92()
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
;>     Bank02_6B6C()
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
;>     Bank02_6B46()
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
;> slot = SpawnEntity(0xAF)                 # Call_3C01: new slot in de (no check whether it worked)
	ld a, $af
	call Call_3C01
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
;@ Plays the clink noise ($0C) and starts wClinkTimer.
PlayClinkNoise::
;> hNoiseSfx = 0x0C
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
;> Bank17_482A()
	call $482a
;> return EndGameModeFrame()
	jp EndGameModeFrame


;@ def UpdateEntitiesBank17()
;@ path: entity/engine
;@ Runs Call_3843 (the entity update) with bank 3 switched in, for code in bank $17, and switches
;@ bank $17 back in. UpdateEntitiesBank1 and UpdateEntitiesBank2 do the same for banks 1 and 2.
;@ test: skip switches ROM banks
UpdateEntitiesBank17::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> back = 0x17
	ld a, $17

jr_000_0b1a:
;> Call_3843()
	push af
	call Call_3843
	pop af
;> return SwitchBank(back)
	jp SwitchBank


;@ def UpdateEntitiesBank1()
;@ path: entity/engine
;@ Runs Call_3843 with bank 3 switched in, then switches bank 1 back in.
;@ test: skip switches ROM banks
UpdateEntitiesBank1::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> Call_3843()                              # (the end of UpdateEntitiesBank17)
;> return SwitchBank(0x01)
	ld a, $01
	jr jr_000_0b1a

;@ def UpdateEntitiesBank2()
;@ path: entity/engine
;@ Runs Call_3843 with bank 3 switched in, then switches bank 2 back in.
;@ test: skip switches ROM banks
UpdateEntitiesBank2::
;> set_rom_bank(0x03)
	ld a, $03
	ld [$2100], a
;> Call_3843()                              # (the end of UpdateEntitiesBank17)
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
;>             Bank01_5FA6()
	call $5fa6
;>             RestoreBank()
	call RestoreBank

.warpTimer
;>     if not wDialogState and mem[0xC1BC]: # a scripted warp counts down
	ld a, [wDialogState]
	and a
	jr nz, .afterTimers

	ld a, [$c1bc]
	and a
	jr z, .afterTimers

;>         hLinkInteractiveMotionBlocked = 2
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $02
;>         mem[0xC1BC] -= 1
	dec a
	ld [$c1bc], a
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
;> Bank02_5DD5()                            # caps the ammunition at the capacities, ...
	call $5dd5
;> wSwordHitboxX = 0
	xor a
	ld [wSwordHitboxX], a
;> wLinkSpriteDX = 0
	ld [wLinkSpriteDX], a
;> wLinkSpriteDY = 0
	ld [wLinkSpriteDY], a
;> mem[0xC11D] &= 0x7F                      # attributes of Link's two sprites: bit 7 (behind the background) off
	ld hl, $c11d
	res 7, [hl]
;> mem[0xC11E] &= 0x7F
	ld hl, $c11e
	res 7, [hl]
;> Bank02_5731()
	call $5731
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
;> Bank19_769B()
	call $769b
;> Call_3843()                              # all entities
	call Call_3843
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> Bank02_529A()
	call $529a
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
;>     Bank02_61ED(c, e)                    # does nothing unless the debug byte at $0004 is set
	call $61ed

.bank14
;> SwitchBank(0x14)
	ld a, $14
	call SwitchBank
;> Bank14_59B0()
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
;>             Bank02_781B()
	call $781b
;>             Call_1CCC()
	call Call_1CCC
;>             Call_3843()
	call Call_3843
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
	ldh a, [$ffb6]
	and a
	jr z, .checkDialog

	dec a
	ldh [$ffb6], a

.checkDialog
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return Call_149B()                   # only Link's sprite while a dialogue is open
	jp nz, Call_149B

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
	ld hl, $c50a
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
	ld [$c3cc], a
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
;@ While the room scrolls: only Link's sprites are updated (Call_149B, then Call_1CCC).
;@ test: skip
UpdateLinkInTransition::
;> Call_149B()
	call Call_149B
;> return Call_1CCC()
	jp Call_1CCC


;@ def LinkMotionBank19()
;@ path: link/motion
;@ Motion state 9: runs bank $19 $5CA9 (it blocks Link's controls and steps by hLinkMotionStep).
;@ test: skip jumps into bank $19
LinkMotionBank19::
;> SwitchBank(0x19)
	ld a, $19
	call SwitchBank
;> return Bank19_5CA9()
	jp $5ca9

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


Call_0D68::
	ld a, [$c50a]
	ld hl, wLinkFrozen
	or [hl]
	ld hl, wHookshotInUse
	or [hl]
	ret nz

	ld a, [wIsUsingPegasusBoots]
	and a
	jr z, jr_000_0dad

	ld a, [wItemA]
	cp $01
	jr z, jr_000_0d9b

	ld a, [wItemB]
	cp $01
	jr z, jr_000_0d9b

	ld a, [wItemA]
	cp $04
	jr z, jr_000_0d96

	ld a, [wItemB]
	cp $04
	jr nz, jr_000_0dab

jr_000_0d96:
	call Call_0F34
	jr jr_000_0dab

jr_000_0d9b:
	ld a, [wSwordAnimationState]
	dec a
	cp $04
	jr c, jr_000_0dab

	ld a, $05
	ld [wSwordAnimationState], a
	ld [wSwordAnimationStatePrev], a

jr_000_0dab:
	jr jr_000_0db4

jr_000_0dad:
	xor a
	ld [wIsUsingShield], a
	ld [wShieldLevelEquipped], a

jr_000_0db4:
	ld a, [wLinkSlowAnimation]
	and a
	jp nz, Jump_000_0ed0

	ld a, [wIsCarryingLiftedObject]
	and a
	jp nz, Jump_000_0ed0

	ld a, [wSwordAnimationState]
	and a
	jr z, jr_000_0dd3

	cp $03
	jr nz, jr_000_0dd3

	ld a, [wSwordStateTimer]
	cp $03
	jr nc, jr_000_0dd9

jr_000_0dd3:
	ldh a, [hLinkInteractiveMotionBlocked]
	and a
	jp nz, Jump_000_0ed0

jr_000_0dd9:
	ld a, [wItemB]
	cp $08
	jr nz, jr_000_0def

	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_000_0deb

	call Call_140C
	jr jr_000_0def

jr_000_0deb:
	xor a
	ld [wPegasusBootsChargeMeter], a

jr_000_0def:
	ld a, [wItemA]
	cp $08
	jr nz, jr_000_0e05

	ldh a, [hJoypadHeld]
	and $10
	jr z, jr_000_0e01

	call Call_140C
	jr jr_000_0e05

jr_000_0e01:
	xor a
	ld [wPegasusBootsChargeMeter], a

jr_000_0e05:
	ld a, [wItemA]
	cp $04
	jr nz, jr_000_0e26

	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a
	ldh a, [hJoypadHeld]
	and $10
	jr z, jr_000_0e26

	ld a, [wCanTalkToEntity]
	cp $01
	jr z, jr_000_0e26

	cp $02
	jr z, jr_000_0e26

	call Call_0F34

jr_000_0e26:
	ld a, [wItemB]
	cp $04
	jr nz, jr_000_0e3c

	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a
	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_000_0e3c

	call Call_0F34

jr_000_0e3c:
	ldh a, [hJoypadPressed]
	and $20
	jr z, jr_000_0e4f

	ld a, [wCanTalkToEntity]
	cp $02
	jr z, jr_000_0e4f

	ld a, [wItemB]
	call Call_0E7F

jr_000_0e4f:
	ldh a, [hJoypadPressed]
	and $10
	jr z, jr_000_0e66

	ld a, [wCanTalkToEntity]
	cp $01
	jr z, jr_000_0e66

	cp $02
	jr z, jr_000_0e66

	ld a, [wItemA]
	call Call_0E7F

jr_000_0e66:
	ldh a, [hJoypadHeld]
	and $20
	jr z, jr_000_0e72

	ld a, [wItemB]
	call Call_0F05

jr_000_0e72:
	ldh a, [hJoypadHeld]
	and $10
	jr z, jr_000_0e7e

	ld a, [wItemA]
	call Call_0F05

jr_000_0e7e:
	ret


Call_0E7F::
	ld c, a
	cp $01
	jp z, Jump_000_122f

	cp $04
	jp z, Jump_000_0ed1

	cp $02
	jp z, Jump_000_0f76

	cp $03
	jp z, Jump_000_1007

	cp $05
	jp z, Jump_000_1079

	cp $0d
	jp z, Jump_000_100e

	cp $06
	jp z, Jump_000_0efc

	cp $0a
	jp z, Jump_000_11d1

	cp $09
	jp z, $41e6

	cp $0c
	jp z, Jump_000_1151

	cp $0b
	jp z, Jump_000_0edb

	cp $07
	jr nz, jr_000_0ed0

	ld hl, wSwordAnimationState
	ld a, [wItemUsePoseTimer]
	or [hl]
	jr nz, jr_000_0ed0

	ld a, [wActiveProjectileCount]
	cp $02
	jr nc, jr_000_0ed0

	ld a, $8e
	ld [wItemUsePoseTimer], a

Jump_000_0ed0:
jr_000_0ed0:
	ret


Jump_000_0ed1:
	ld a, [wLinkPushingTimer]
	and a
	ret nz

	ld a, $16
	ldh [hNoiseSfx], a
	ret


Jump_000_0edb:
	ld a, [wDigState]
	ld hl, wIsLinkInTheAir
	or [hl]
	ret nz

	call $4c35
	jr nc, jr_000_0eee

	ld a, $07
	ldh [hJingle], a
	jr jr_000_0ef2

jr_000_0eee:
	ld a, $0e
	ldh [hNoiseSfx], a

jr_000_0ef2:
	ld a, $01
	ld [wDigState], a
	xor a
	ld [wDigCounter], a
	ret


Jump_000_0efc:
	ld a, [wHookshotInUse]
	and a
	ret nz

	call $423b
	ret


Call_0F05::
	cp $01
	ret nz

	ld hl, wSwordAnimationState
	ld a, [wCanTalkToEntity]
	and $03
	or [hl]
	ret nz

	ld a, [$c160]
	and a
	ret nz

	xor a
	ld [wSwordDirectionLocked], a
	ld a, $05
	ld [wSwordAnimationState], a
	ld [wSwordCollisionEnabled], a
	ret


ShieldHitboxDX::
	db $10, $00, $08, $08

ShieldHitboxWidth::
	db $03, $03, $08, $08

ShieldHitboxDY::
	db $08, $08, $00, $0d

ShieldHitboxHeight::
	db $08, $08, $03, $04

Call_0F34::
	ld a, $01
	ld [wIsUsingShield], a
	ld a, [wShieldLevel]
	ld [wShieldLevelEquipped], a

Call_0F3F::
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $0f24
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ld [wSwordHitboxX], a
	ld hl, $0f28
	add hl, de
	ld a, [hl]
	ld [wSwordHitboxWidth], a
	ld hl, $0f2c
	add hl, de
	ld a, [wLinkDrawY]
	add [hl]
	ld [wSwordHitboxY], a
	ld hl, $0f30
	add hl, de
	ld a, [hl]
	ld [wSwordHitboxHeight], a
	xor a
	ld [wSwordCollisionEnabled], a
	ret


BombPlaceDX::
	db $08, $f8, $00, $00

BombPlaceDY::
	db $00, $00, $fd, $04

Jump_000_0f76:
	ld a, [wBombsOnScreen]
	cp $01
	ret nc

	ld a, [wBombCount]
	and a
	jp z, PlayNoAmmoSound

	sub $01
	daa
	ld [wBombCount], a
	ld a, $02
	call Call_10EB
	ret c

	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $10
	ld a, [wBombArrowWindow]
	and a
	jp z, Jump_000_0fac

	xor a
	ld [wBombArrowWindow], a
	ld a, [$c1c2]
	ld c, a
	ld b, d
	ld hl, wEntityState
	add hl, bc
	ld [hl], $01
	ret


Jump_000_0fac:
	ld a, $06
	ld [wBombArrowWindow], a
	ld a, e
	ld [$c1c1], a
	ld a, $0c
	ld [wItemUsePoseTimer], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $a0
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], d
	ld hl, wEntityDyingTimer
	add hl, de
	ld [hl], $03
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_000_0fd6

	ld a, $09
	ldh [hJingle], a
	jr jr_000_0fdb

jr_000_0fd6:
	ld hl, wEntityZ
	add hl, de
	ld [hl], d

jr_000_0fdb:
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], d
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], d
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], d
	ldh a, [hLinkDirection]
	ld c, a
	ld b, d
	ld hl, $0f6e
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $0f72
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ret


Jump_000_1007:
	ret


BoomerangDiagonalSpeedX::
	db $18, $e8, $00

BoomerangDiagonalSpeedY::
	db $e8, $18, $00

Jump_000_100e:
	ld a, [wActiveProjectileCount]
	and a
	ret nz

	ld a, $01
	call Call_10EB
	ret c

	ld hl, wEntityTimer
	add hl, de
	ld [hl], $28
	ld c, $04
	ld b, $00
	ldh a, [hJoypadHeld]

jr_000_1025:
	srl a
	jr nc, jr_000_102a

	inc b

jr_000_102a:
	dec c
	jr nz, jr_000_1025

	ld a, b
	cp $02
	jr c, jr_000_1058

	ldh a, [hJoypadHeld]
	and $03
	ld c, a
	ld b, $00
	ld hl, $1007
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ldh a, [hJoypadHeld]
	srl a
	srl a
	and $03
	ld c, a
	ld b, $00
	ld hl, $100a
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

jr_000_1058:
	ret


ProjectileStartDX::
	db $00, $00, $00, $00

ProjectileStartDY::
	db $00, $00, $00, $00

ProjectileSpeedX::
	db $20, $e0, $00, $00

ProjectileSpeedY::
	db $00, $00, $e0, $20
ArrowSpeedX::
	db $30, $d0, $00, $00, $40, $c0, $00, $00

ArrowSpeedY::
	db $00, $00, $d0, $30, $00, $00, $c0, $40

Jump_000_1079:
	ld a, [wArrowCooldown]
	and a
	ret nz

	ld a, [wActiveProjectileCount]
	cp $02
	jr nc, jr_000_10ea

	ld a, $10
	ld [wArrowCooldown], a
	ld a, [wArrowCount]
	and a
	jp z, PlayNoAmmoSound

	sub $01
	daa
	ld [wArrowCount], a
	call Call_1283
	ld a, $00
	call Call_10EB
	ret c

	ld a, e
	ld [$c1c2], a
	ld a, [wBombArrowWindow]
	and a
	jr z, jr_000_10bd

	ld a, [$c1c1]
	ld c, a
	ld b, d
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ld hl, wEntityState
	add hl, de
	ld [hl], $01
	xor a
	jr jr_000_10c3

jr_000_10bd:
	ld a, $0a
	ldh [hNoiseSfx], a
	ld a, $06

jr_000_10c3:
	ld [wBombArrowWindow], a
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00

Jump_000_10cb:
	ld a, [wActivePowerUp]
	cp $01
	jr nz, jr_000_10d6

	ld a, c
	add $04
	ld c, a

jr_000_10d6:
	ld hl, $1069
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $1071
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a

jr_000_10ea:
	ret


Call_10EB::
	call Call_3C01
	ret c

	ld a, $0c
	ld [wItemUsePoseTimer], a
	push bc
	ldh a, [hLinkDirection]
	ld c, a
	ld b, $00
	ld hl, $1059
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $105d
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hLinkPositionZ]
	inc a
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
	ld hl, $1061
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedX
	add hl, de
	ld [hl], a
	ld hl, $1065
	add hl, bc
	ld a, [hl]
	ld hl, wEntitySpeedY
	add hl, de
	ld [hl], a
	ldh a, [hLinkDirection]
	ld hl, wEntitySpriteVariant
	add hl, de
	ld [hl], a
	ld hl, wEntityDirection
	add hl, de
	ld [hl], a
	ld hl, $c5d0
	add hl, de
	ld [hl], a
	ld hl, $c4f0
	add hl, de
	ld [hl], $01
	pop bc
	scf
	ccf
	ret


MagicPowderDX::
	db $0e, $f2, $00, $00

MagicPowderDY::
	db $00, $00, $f4, $0c

Jump_000_1151:
	ld a, [wItemUsePoseTimer]
	and a
	ret nz

	ld a, [wHasToadstool]
	and a
	jr z, jr_000_116b

	ldh a, [hLinkPositionZ]
	and a
	ret nz

	ld a, $02
	ld [wLinkShowItemPose], a
	ld a, $2a
	ld [wLinkShowItemTimer], a
	ret


jr_000_116b:
	ld a, [wMagicPowderCount]
	and a
	jp z, PlayNoAmmoSound

	ld a, $08
	call Call_3C01
	ret c

	ld a, $05
	ldh [hJingle], a
	ld a, $0e
	ld [wItemUsePoseTimer], a
	ld a, [wMagicPowderCount]
	sub $01
	daa
	ld [wMagicPowderCount], a
	jr nz, jr_000_119e

	ld hl, wItemB
	ld a, [hl]
	cp $0c
	jr nz, jr_000_1196

	ld [hl], $00

jr_000_1196:
	inc hl
	ld a, [hl]
	cp $0c
	jr nz, jr_000_119e

	ld [hl], $00

jr_000_119e:
	push bc
	ldh a, [hLinkDirection]
	ld c, a
	ld hl, $1149
	add hl, bc
	ldh a, [hLinkX]
	add [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $114d
	add hl, bc
	ldh a, [hLinkY]
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $17
	pop bc
	ret


FeatherDashSpeedX::
	db $1c, $e4, $00, $00

FeatherDashSpeedY::
	db $00, $00, $e4, $1c

Jump_000_11d1:
	ld a, [wLinkGroundVfxPrev]
	cp $07
	ret z

	ld a, [wIsLinkInTheAir]
	and a
	ret nz

	ld a, $01
	ld [wIsLinkInTheAir], a
	xor a
	ld [wJumpAnimationFrame], a
	ld [wJumpAnimationCounter], a
	ld a, $0d
	ldh [hJingle], a
	ldh a, [hIsSideScrolling]
	and a
	jr z, Call_120F

	call Call_120F
	ldh a, [hJoypadHeld]
	and $03
	ld a, $ea
	jr z, jr_000_11fe

	ld a, $e8

jr_000_11fe:
	ldh [hLinkSpeedY], a
	xor a
	ldh [hLinkSpeedZ], a
	call ApplyLinkSpeed
	ld a, $02
	call SwitchBank
	call $6fb1
	ret


Call_120F::
	ld a, $20
	ldh [hLinkSpeedZ], a
	ld a, [wIsUsingPegasusBoots]
	and a
	ret z

	ldh a, [hLinkDirection]
	ld e, a
	ld d, b
	ld hl, $11c9
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $11cd
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	ret


SwordSwingNoises::
	db $02, $14, $15, $18

Jump_000_122f:
	ld a, [wSwordPokeTimer]
	ld hl, wSpinAttackTimer
	or [hl]
	ret nz

	ld a, $03
	ld [wSwordStateTimer], a
	ld a, $01
	ld [wSwordAnimationState], a
	ld [wSwordCollisionEnabled], a
	xor a
	ld [$c160], a
	ld [wSwordDirectionLocked], a
	call GetRandomByte
	and $03
	ld e, a
	ld d, $00
	ld hl, $122b
	add hl, de
	ld a, [hl]
	ldh [hNoiseSfx], a
	call Call_1283
	ld a, [wIsLinkInTheAir]
	and a
	jr nz, jr_000_1269

	call ResetSpinAttackAndDash
	call Call_1495

jr_000_1269:
	ld a, [wActiveProjectileCount]
	and a
	ret nz

	ld a, [$c5a9]
	and a
	ret z

	ld a, [wSwordLevel]
	cp $02
	ret nz

	ld a, $df
	call Call_10EB
	xor a
	ld [wItemUsePoseTimer], a
	ret


Call_1283::
	ldh a, [hJoypadHeld]
	and $0f
	ld e, a
	ld d, $00
	ld hl, $48b3
	add hl, de
	ld a, [hl]
	cp $0f
	jr z, jr_000_1295

	ldh [hLinkDirection], a

jr_000_1295:
	ret


SwordProbeDX::
	db $16, $fa, $08, $08, $16, $16, $08, $fa, $fa, $fa, $08, $16

SwordProbeDY::
	db $08, $08, $fa, $16
	db $08, $16, $16, $16, $08, $fa, $fa, $fa

Call_12AE::
	call Call_12B6
	ld a, $02
	jp SwitchBank


Call_12B6::
	ld a, [wLinkJumpSquashTimer]
	and a
	ret nz

	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_000_12c7

	ld a, [wSwordAnimationStatePrev]
	cp $05
	ret z

jr_000_12c7:
	ld a, [wSpinAttackTimer]
	and a
	jr z, jr_000_12d4

	ld a, [wSwordSpriteFrame]
	add $04
	jr jr_000_12d6

jr_000_12d4:
	ldh a, [hLinkDirection]

jr_000_12d6:
	ld e, a
	ld d, $00
	ld hl, $1296
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	sub $08
	and $f0
	ldh [hBGPosX], a
	swap a
	ld c, a
	ld hl, $12a2
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	sub $10
	and $f0
	ldh [hBGPosY], a
	or c
	ld e, a
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
	ret nz

	push de
	ld a, [hl]
	ldh [hRoomObjectType], a
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	pop de
	cp $d0
	jp c, Jump_000_1317

	cp $d4
	jp c, Jump_000_13c9

Jump_000_1317:
	cp $90
	jp nc, Jump_000_13c9

	cp $01
	jp z, Jump_000_13c9

	ld c, $00
	ld a, [wIsIndoor]
	and a
	ldh a, [hRoomObjectType]
	jr z, jr_000_1330

	cp $dd
	jr z, jr_000_133e

	ret


jr_000_1330:
	inc c
	cp $d3
	jr z, jr_000_133e

	cp $5c
	jr z, jr_000_133e

	cp $0a
	ret nz

	ld c, $ff

jr_000_133e:
	ld a, c
	ldh [hActiveEntitySpriteVariant], a
	call RemoveRoomObject
	ld a, [wIsUsingPegasusBoots]
	and a
	jr nz, jr_000_135a

	ld a, [wSwordAnimationStatePrev]
	cp $05
	jr nz, jr_000_135a

	xor a
	ld [wSwordCharge], a
	ld a, $0c
	ld [wSwordPokeTimer], a

jr_000_135a:
	ld a, $05
	call Call_10EB
	jr c, jr_000_1383

	xor a
	ld [wItemUsePoseTimer], a
	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
	ld hl, wEntitySpriteVariant
	add hl, de
	ldh a, [hActiveEntitySpriteVariant]
	ld [hl], a
	push de
	pop bc
	call Call_3803

jr_000_1383:
	call GetRandomByte
	and $07
	ret nz

	ldh a, [hRoomObjectType]
	cp $d3
	ret z

	call GetRandomByte
	rra
	ld a, $2e
	jr nc, jr_000_1398

	ld a, $2d

jr_000_1398:
	call Call_3C01
	ret c

	ld hl, wEntityX
	add hl, de
	ldh a, [hBGPosX]
	add $08
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ldh a, [hBGPosY]
	add $10
	ld [hl], a
	ld hl, wEntityDropTimer
	add hl, de
	ld [hl], $80
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $18
	ld hl, wEntitySpeedZ
	add hl, de
	ld [hl], $10
	ret


SwordClinkDX::
	db $12, $ee, $fc, $04, $04, $04, $ee, $12

Jump_000_13c9:
	ld c, a
	ld a, [wSwordPokeTimer]
	and a
	ret z

	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $13c1
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ldh [hMultiPurpose0], a
	ld hl, $13c5
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ldh [hMultiPurpose1], a
	ld a, $04
	ld [wClinkTimer], a
	call AddClinkVfx
	ld a, $10
	ld [wLinkJumpSquashTimer], a
	ld a, c
	and $f0
	cp $90
	jr z, jr_000_13ff

	ld a, $07
	ldh [hJingle], a
	ret


jr_000_13ff:
	ld a, $17
	ldh [hNoiseSfx], a
	ret


	db $20, $e0, $00, $00, $00, $00, $e0, $20

Call_140C::
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_000_141a

	ldh a, [hLinkMotionStep]
	and a
	ret nz

	ldh a, [hLinkDirection]
	and $02
	ret nz

jr_000_141a:
	ld a, [wIsUsingPegasusBoots]
	and a
	ret nz

	ldh a, [hLinkPositionZ]
	ld hl, wIsLinkInTheAir
	or [hl]
	ret nz

	ld a, [wLinkWalkingFrameCount]
	add $02
	ld [wLinkWalkingFrameCount], a
	call Call_145D
	ld a, [wPegasusBootsChargeMeter]
	inc a
	ld [wPegasusBootsChargeMeter], a
	cp $20
	ret nz

	ld [wIsUsingPegasusBoots], a
	xor a
	ld [wSpinAttackTimer], a
	ld [wSwordCharge], a
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $1404
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedX], a
	ld hl, $1408
	add hl, de
	ld a, [hl]
	ldh [hLinkSpeedY], a
	xor a
	ld [wSwordDirectionLocked], a
	ret


Call_145D::
	ldh a, [hFrameCounter]
	and $07
	ld hl, hLinkPositionZ
	or [hl]
	ld hl, hLinkInteractiveMotionBlocked
	or [hl]
	ld hl, wIsLinkInTheAir
	or [hl]
	ret nz

	ldh a, [hLinkX]
	ldh [hMultiPurpose0], a
	ld a, [wLinkGroundType]
	cp $05
	jr z, jr_000_1488

	ld a, $07
	ldh [hNoiseSfx], a
	ldh a, [hLinkY]
	add $06
	ldh [hMultiPurpose1], a
	ld a, $0b
	jp AddTransientVfx


jr_000_1488:
	ldh a, [hLinkY]
	ldh [hMultiPurpose1], a
	ld a, $0e
	ldh [hJingle], a
	ld a, $0c
	jp AddTransientVfx


Call_1495::
	xor a
	ldh [hLinkSpeedX], a
	ldh [hLinkSpeedY], a
	ret


Call_149B::
	call $77fa

Call_149E::
	ld a, [wLinkMotionState]
	cp $01
	ret z

	ld a, [wSwordAnimationStatePrev]
	and a
	jr z, jr_000_14e2

	ld bc, $c010
	ld a, [wLinkDrawY]
	ld hl, wLinkSpriteDY
	add [hl]
	ldh [hMultiPurpose0], a
	ldh a, [hLinkX]
	ldh [hMultiPurpose1], a
	ld hl, hMultiPurpose3
	ld [hl], $00
	ld a, [wSwordCharge]
	cp $28
	jr c, jr_000_14cd

	ldh a, [hFrameCounter]
	rla
	rla
	and $10
	ld [hl], a

jr_000_14cd:
	ld a, [wSwordSpriteDY]
	ld h, a
	ld a, [wSwordSpriteDX]
	ld l, a
	ld a, [wSwordSpriteFrame]
	ldh [hMultiPurpose2], a
	ldh a, [hLinkY]
	cp $88
	ret nc

	jp Call_1540


jr_000_14e2:
	ld a, [wItemUsePoseTimer]
	push af
	bit 7, a
	jp z, Jump_000_151b

	ld a, $02
	call SwitchBank
	call $514b
	ld a, [wItemUsePoseTimer]
	and $7f
	cp $0c
	jr nz, jr_000_151b

	ld hl, wDialogState
	ld a, [wRoomTransitionState]
	or [hl]
	jr nz, jr_000_151b

	call Call_1283
	ld a, $04
	call Call_10EB
	jr c, jr_000_151b

	ld a, $0d
	ldh [hNoiseSfx], a
	ld a, $02
	call SwitchBank
	call $51c6

Jump_000_151b:
jr_000_151b:
	pop af
	ld [wItemUsePoseTimer], a
	ret


	db $08, $06, $0c, $0a, $ff, $04, $0a, $0c, $06, $08, $0a, $0c, $ff, $04, $0c, $0a
	db $20, $20, $60, $60, $00, $00, $40, $40, $00, $00, $00, $00, $40, $40, $20, $20

Call_1540::
	push hl
	ldh a, [hMultiPurpose0]
	add h
	ld [bc], a
	inc bc
	ldh a, [hMultiPurpose1]
	add l
	ld [bc], a
	inc bc
	ld hl, $1520
	ldh a, [hMultiPurpose2]
	sla a
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld [bc], a
	cp $ff
	jr nz, jr_000_1561

	dec bc
	ld a, $f0
	ld [bc], a
	inc bc

jr_000_1561:
	inc bc
	ld hl, $1530
	add hl, de
	ld a, [hl]
	ld hl, hMultiPurpose3
	or [hl]
	ld [bc], a
	inc bc
	pop hl
	ldh a, [hMultiPurpose0]
	add h
	ld [bc], a
	inc bc
	ldh a, [hMultiPurpose1]
	add l
	add $08
	ld [bc], a
	inc bc
	ld hl, $1521
	add hl, de
	ld a, [hl]
	ld [bc], a
	inc bc
	ld hl, $1531
	add hl, de
	ld a, [hl]
	ld hl, hMultiPurpose3
	or [hl]
	ld [bc], a
	ret


	db $10, $f0, $08, $08, $0c, $0c, $f0, $10

Call_1594::
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $158c
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	ld [$c179], a
	ld hl, $1590
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	ld [$c17a], a
	ld a, $02
	ld [$c178], a
	ret


LinkMotionMapFadeOut::
	call $780f
	ld a, [$c3c9]
	and a
	jr z, jr_000_15c3

	xor a
	ld [$c3c9], a
	jp StartWarpFadeOutWithNoise


jr_000_15c3:
	call FadePalettesToWhite
	xor a
	ld [wBumpShakeTimer], a
	inc a
	ld [wLinkShowItemPoseActive], a
	ld a, [wTransitionSequenceCounter]
	cp $04
	jp nz, Jump_000_172d

	xor a
	ldh [hBaseScrollX], a
	ldh [hBaseScrollY], a
	ldh [$ffb4], a
	ld e, $10
	ld hl, wEntityStatus

jr_000_15e2:
	ld [hli], a
	dec e
	jr nz, jr_000_15e2

	ld a, [$c509]
	and a
	jr z, jr_000_1606

	push af
	ld a, $04
	call SwitchBank
	pop af
	call $79fa
	ld hl, wIsThief
	inc [hl]
	ld hl, $db46
	inc [hl]
	ld a, $01
	ld [$d47e], a
	xor a
	ldh [hLinkAnimationState], a

jr_000_1606:
	ldh a, [hIsSideScrolling]
	ldh [hMultiPurposeD], a
	ld a, $0b
	ld [wGameplayType], a
	xor a
	ld [wGameplaySubtype], a
	ld [$c3cb], a
	ldh [hIsSideScrolling], a
	ld hl, wWarpType
	ld a, [wIsIndoor]
	ldh [hMultiPurposeF], a
	and a
	jr nz, jr_000_164d

	ld hl, wWarpDestPosition
	ld c, $00

jr_000_1628:
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
	ldh a, [hLinkY]
	sub $08
	and $f0
	or e
	cp [hl]
	jr z, jr_000_1640

	inc hl
	inc c
	ld a, c
	cp $04
	jr nz, jr_000_1628

jr_000_1640:
	ld a, c
	sla a
	sla a
	add c
	ld e, a
	ld d, $00
	ld hl, wWarpType
	add hl, de

jr_000_164d:
	push hl
	ld a, [hli]
	ld [wIsIndoor], a
	cp $02
	jr nz, jr_000_1660

	ldh [hIsSideScrolling], a
	dec a
	ld [wIsIndoor], a
	ld a, $01
	ldh [hLinkMotionStep], a

jr_000_1660:
	ld a, [hli]
	ldh [hMapId], a
	ld a, [wIsIndoor]
	and a
	ld a, [hli]
	ldh [hMapRoom], a
	jr nz, jr_000_1677

	ldh a, [hMultiPurposeF]
	and a
	jr z, jr_000_1675

	xor a
	ld [wActivePowerUp], a

jr_000_1675:
	jr jr_000_16d4

jr_000_1677:
	ld c, a
	ld a, $14
	call SwitchBank
	push hl
	ldh a, [hMapId]
	swap a
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $4200
	add hl, de
	ldh a, [hMapId]
	cp $06
	jr nz, jr_000_16a1

	ld a, [wDungeon7Flags]
	and $04
	jr z, jr_000_16a1

	ld hl, $44c0

jr_000_16a1:
	ld e, $00

jr_000_16a3:
	ld a, [hli]
	cp c
	jr z, jr_000_16ad

	inc e
	ld a, e
	cp $40
	jr nz, jr_000_16a3

jr_000_16ad:
	ld a, e
	ld [wIndoorRoom], a
	ldh a, [hMultiPurposeF]
	and a
	jr nz, jr_000_16d3

	xor a
	ld [wActivePowerUp], a
	ldh a, [hMapId]
	cp $0a
	jr nc, jr_000_16d3

	ld a, $02
	call SwitchBank
	call $6a9b
	ld a, $30
	ldh [$ffb4], a
	xor a
	ld [wRaisedBlocksState], a
	ld [wRaisedBlockStep], a

jr_000_16d3:
	pop hl

jr_000_16d4:
	ld a, [hli]
	ld [wMapEntrancePositionX], a
	ld a, [hl]
	ld [wMapEntrancePositionY], a
	pop hl
	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_000_172e

	ldh a, [hMultiPurposeD]
	and a
	jr nz, jr_000_172d

	ld a, [wIsIndoor]
	and a
	jr z, SetSpawnPoint

	ldh a, [hMapId]
	cp $0a
	jr nc, SetSpawnPoint

	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
	ld hl, $53e5
	add hl, de
	ld a, $14
	ld [$2100], a
	call SetSpawnPoint
	push de
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, $5412
	add hl, de
	ld a, [hl]
	pop de
	ld [de], a
	ret


SetSpawnPoint::
	ld a, $00
	ldh [hMultiPurpose0], a
	ld de, wSpawnIsIndoor

jr_000_171d:
	ld a, [hli]
	ld [de], a
	inc de
	ldh a, [hMultiPurpose0]
	inc a
	ldh [hMultiPurpose0], a
	cp $05
	jr nz, jr_000_171d

	ld a, [wIndoorRoom]
	ld [de], a

Jump_000_172d:
jr_000_172d:
	ret


jr_000_172e:
	xor a
	ldh [hLinkDirection], a
	ret


LinkMotionMapFadeIn::
	call $780f
	ld a, [$d474]
	and a
	jr z, jr_000_1750

	xor a
	ld [$d474], a
	ld a, $30
	ld [wTransitionGfxFrameCount], a
	ld a, $03
	ld [wTransitionGfx], a
	ld a, $04
	ld [wTransitionSequenceCounter], a
	jr jr_000_175a

jr_000_1750:
	call FadePalettesIn
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_000_1775

jr_000_175a:
	ld a, [wSavedLinkMotionState]
	cp $01
	jr z, jr_000_1763

	ld a, $00

jr_000_1763:
	ld [wLinkMotionState], a
	ld a, [$d47e]
	and a
	jr z, jr_000_1775

	xor a
	ld [$d47e], a
	ld a, $36
	call OpenDialog

jr_000_1775:
	ret


FadePalettesToWhite::
	ld hl, wTransitionFrameCounter
	inc [hl]
	ld a, [wTransitionFrameCounter]
	and $03
	jr nz, jr_000_17b6

	ld hl, wTransitionSequenceCounter
	ld a, [hl]
	cp $04
	jr z, jr_000_17b6

	inc [hl]
	xor a
	ldh [hMultiPurpose0], a

jr_000_178d:
	ldh a, [hMultiPurpose0]
	cp $03
	jr z, jr_000_17b6

	ld hl, wBGPalette
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	ld c, a
	ld b, $00

jr_000_179e:
	ld a, c
	and $03
	jr z, jr_000_17a4

	dec c

jr_000_17a4:
	rrc c
	rrc c
	inc b
	ld a, b
	cp $04
	jr nz, jr_000_179e

	ld a, c
	ld [hl], a
	ld hl, hMultiPurpose0
	inc [hl]
	jr jr_000_178d

jr_000_17b6:
	ret


	db $00, $01, $02, $03, $00, $03, $01, $00, $00, $01, $02, $03

FadePalettesIn::
	ld hl, wTransitionFrameCounter
	inc [hl]
	ld a, [wTransitionFrameCounter]
	and $03
	jr nz, jr_000_1812

	ld hl, wTransitionSequenceCounter
	ld a, [hl]
	inc [hl]
	cp $04
	jr z, jr_000_17b6

	xor a
	ldh [hMultiPurpose0], a

jr_000_17da:
	ldh a, [hMultiPurpose0]
	cp $03
	jr z, jr_000_1812

	ld hl, wBGPalette
	ld e, a
	ld d, $00
	add hl, de
	ld a, [hl]
	push hl
	ld c, a
	ld b, $00

jr_000_17ec:
	ldh a, [hMultiPurpose0]
	sla a
	sla a
	or b
	ld e, a
	ld hl, $17b7
	add hl, de
	ld a, c
	and $03
	cp [hl]
	jr z, jr_000_17ff

	inc c

jr_000_17ff:
	rrc c
	rrc c
	inc b
	ld a, b
	cp $04
	jr nz, jr_000_17ec

	ld a, c
	pop hl
	ld [hl], a
	ld hl, hMultiPurpose0
	inc [hl]
	jr jr_000_17da

jr_000_1812:
	ret


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
	db $b8, $ba, $2e, $2c, $ba, $b8, $bc, $be, $d0, $d2, $a0, $fc, $fc, $a0, $00, $00
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

UpdateLinkAnimationState::
	ld a, [wLinkWalkingFrameCount]
	sra a
	sra a
	sra a
	and $01
	ld d, a
	ldh a, [hLinkDirection]
	sla a
	or d
	ld c, a
	ld b, $00
	ld hl, $48f6
	ld a, [wLinkMotionState]
	cp $01
	jr nz, jr_000_1a17

	ldh a, [hLinkMotionStep]
	and a
	jr z, jr_000_1a15

	ld hl, $48fe

jr_000_1a15:
	jr jr_000_1a66

jr_000_1a17:
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_000_1a27

	ldh a, [hLinkMotionStep]
	cp $02
	jr nz, jr_000_1a27

	ld hl, $4906
	jr jr_000_1a66

jr_000_1a27:
	ld a, [wIsCarryingLiftedObject]
	cp $01
	jr z, jr_000_1a63

	ldh a, [hLinkInWater]
	and a
	jr nz, jr_000_1a39

	ld a, [wLinkPushingTimer]
	and a
	jr nz, jr_000_1a5e

jr_000_1a39:
	ld a, [wShieldLevelEquipped]
	and a
	jr nz, jr_000_1a44

	ld hl, $48be
	jr jr_000_1a66

jr_000_1a44:
	ld hl, $48c6
	cp $02
	jr nz, jr_000_1a4e

	ld hl, $48d6

jr_000_1a4e:
	ld a, [wIsUsingShield]
	and a
	jr z, jr_000_1a5c

	ld a, l
	add $08
	ld l, a
	ld a, h
	adc $00
	ld h, a

jr_000_1a5c:
	jr jr_000_1a66

jr_000_1a5e:
	ld hl, $48e6
	jr jr_000_1a66

jr_000_1a63:
	ld hl, $48ee

jr_000_1a66:
	add hl, bc
	ld a, [hl]
	ldh [hLinkAnimationState], a
	ret


jr_000_1a6b:
	ld a, [wDrawCommand]
	and a
	ret nz

	ld a, $10
	ld [$2100], a
	ld hl, $6500
	ld de, $9500
	ldh a, [hFrameCounter]
	and $0f
	jr z, jr_000_1a87

	cp $08
	ret nz

	ld l, $40
	ld e, l

jr_000_1a87:
	ldh a, [hFrameCounter]
	and $30
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld bc, $0040
	jp CopyData


	db $20, $60, $a0, $e0, $e0, $e0, $a0, $60

UpdateAnimatedTiles::
	ld a, [wGameplayType]
	cp $09
	jr z, jr_000_1a6b

	cp $00
	jr nz, jr_000_1adf

	ld a, [wDrawCommand]
	and a
	jp nz, Jump_000_1ade

	ldh a, [hFrameCounter]
	and $0f
	cp $04
	jr c, jr_000_1ade

	ld a, $10
	ld [$2100], a
	ld a, [wSceneTimer]
	ld l, a
	ld a, [wSceneTimer2]
	ld h, a
	ld a, [wSceneTimer3]
	ld e, a
	ld a, [wSceneSlowTimer]
	ld d, a
	ld bc, $0020
	call CopyData

Jump_000_1ade:
jr_000_1ade:
	ret


jr_000_1adf:
	ld a, [wGameplayType]
	cp $01
	jr nz, jr_000_1aec

	ldh a, [hBGChangeRequest]
	and a
	jr nz, jr_000_1b1b

	ret


jr_000_1aec:
	cp $0b
	jp c, Jump_000_1d14

	ld a, [wWindowY]
	cp $80
	jp nz, Jump_000_1d14

	ld a, [wInventoryAppearing]
	and a
	jp nz, Call_1CCC

	ld hl, wRoomTransitionState
	ld a, [wDrawCommand]
	or [hl]
	jp nz, Call_1CCC

	ld a, [wRaisedBlockStep]
	and a
	jr z, jr_000_1b16

	call Call_1DEE
	jp Call_1CCC


jr_000_1b16:
	ldh a, [hBGChangeRequest]
	and a
	jr z, jr_000_1b66

jr_000_1b1b:
	cp $01
	jp z, Jump_000_3fbd

	cp $02
	jp z, Jump_000_3fd3

	cp $03
	jp z, Jump_000_1dcf

	cp $04
	jp z, Jump_000_1dd6

	cp $08
	jp z, Jump_000_1d8c

	cp $09
	jp z, Call_1DBE

	cp $0a
	jp z, Call_1D54

	cp $0b
	jp z, Jump_000_1dad

	cp $0c
	jp z, Jump_000_1d5c

	cp $0d
	jp z, Jump_000_1d2d

	cp $0e
	jr z, jr_000_1b5e

	cp $0f
	jp z, Jump_000_1d1c

	cp $10
	jp z, Jump_000_1d15

	jp Call_1CCC


jr_000_1b5e:
	ld a, $17
	ld [$2100], a
	jp $4060


jr_000_1b66:
	ldh a, [hAnimatedTilesFrameCount]
	inc a
	ldh [hAnimatedTilesFrameCount], a

Call_1B6B::
	ldh a, [hAnimatedTilesGroup]
	rst $00

JumpTable_1B6E::
	dw Jump_1C5A
	dw Jump_1B90
	dw Jump_1BAA
	dw Jump_1BAE
	dw Jump_1BCD
	dw Jump_1BF1
	dw Jump_1BF5
	dw Jump_1C10
	dw Jump_1C21
	dw Jump_1C30
	dw Jump_1C3F
	dw Jump_1BB6
	dw Jump_1BB2
	dw Jump_1C4A
	dw Jump_1C56
	dw Jump_1C4E
	dw Jump_1C52

Jump_1B90::
	ldh a, [hAnimatedTilesFrameCount]
	and $07
	jp nz, Jump_1C5A

	ld a, $01
	ld [$2100], a
	call $5f62
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


Jump_000_1ba7:
	ld l, a
	jr jr_000_1be5

Jump_1BAA::
	ld h, $6b
	jr jr_000_1bb8

Jump_1BAE::
	ld h, $6c
	jr jr_000_1bb8

Jump_1BB2::
	ld h, $73
	jr jr_000_1bb8

Jump_1BB6::
	ld h, $6a

jr_000_1bb8:
	ldh a, [hAnimatedTilesFrameCount]
	and $0f
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


	db $00, $40, $80, $c0, $c0, $c0, $80, $40

Jump_1BCD::
	ldh a, [hAnimatedTilesFrameCount]
	and $07
	jp nz, Jump_1C5A

	ldh a, [hAnimatedTilesFrameCount]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $1bc5
	add hl, de
	ld l, [hl]
	ld h, $6d

Jump_000_1be5:
jr_000_1be5:
	ld de, $96c0

Jump_000_1be8:
	ld bc, $0040
	call CopyData
	jp Call_1CCC


Jump_1BF1::
	ld h, $6e
	jr jr_000_1bb8

Jump_1BF5::
	ldh a, [hAnimatedTilesFrameCount]
	and $07
	jp nz, Jump_1C5A

	ldh a, [hAnimatedTilesFrameCount]
	rra
	rra
	rra
	and $07
	ld e, a
	ld d, $00
	ld hl, $1bc5
	add hl, de
	ld l, [hl]
	ld h, $6f
	jp Jump_000_1be5


Jump_1C10::
	ldh a, [hAnimatedTilesFrameCount]
	inc a
	and $03
	jp nz, Jump_1BCD

	ld hl, $dcc0
	ld de, $90c0
	jp Jump_000_1be8


Jump_1C21::
	ld h, $70

jr_000_1c23:
	ldh a, [hAnimatedTilesFrameCount]
	and $07
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


Jump_1C30::
	ld h, $71

jr_000_1c32:
	ldh a, [hAnimatedTilesFrameCount]
	and $03
	jp nz, Jump_1C5A

	call Call_1C43
	jp Jump_000_1ba7


Jump_1C3F::
	ld h, $72
	jr jr_000_1c32

Call_1C43::
	ldh a, [hAnimatedTilesStep]
	add $40
	ldh [hAnimatedTilesStep], a
	ret


Jump_1C4A::
	ld h, $75
	jr jr_000_1c32

Jump_1C4E::
	ld h, $74
	jr jr_000_1c23

Jump_1C52::
	ld h, $77
	jr jr_000_1c23

Jump_1C56::
	ld h, $76
	jr jr_000_1c23

Jump_1C5A::
	ldh a, [hLinkAnimationState]
	cp $ff
	jp z, Call_1CCC

	ld hl, $1813
	sla a
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
	push hl
	ld hl, $1901
	add hl, bc
	ld a, [$c11d]
	and $9f
	or [hl]
	ld [$c11d], a
	inc hl
	ld a, [$c11e]
	and $9f
	or [hl]
	ld [$c11e], a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
	pop bc
	ld hl, $8000
	ld d, $20

jr_000_1ca0:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, jr_000_1ca0

	pop hl
	inc hl
	ld e, [hl]
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	sla e
	rl d
	ld hl, $5800
	add hl, de
	push hl
	pop bc
	ld hl, $8020
	ld d, $20

jr_000_1cc6:
	ld a, [bc]
	inc bc
	ld [hli], a
	dec d
	jr nz, jr_000_1cc6

Call_1CCC::
	ldh a, [hLinkAnimationState]
	inc a
	jr z, jr_000_1d14

	ld a, [wInvincibilityCounter]
	rla
	rla
	and $10
	ld [$c135], a
	ld hl, $c008
	ld a, [wLinkSpriteDY]
	ld c, a
	ld a, [wLinkDrawY]
	add c
	cp $88
	jr nc, jr_000_1d14

	push af
	ld [hli], a
	ld a, [wLinkSpriteDX]
	ld c, a
	ldh a, [hLinkX]
	add c
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, [$c135]
	ld d, a
	ld a, [$c11d]
	or d
	ld [hli], a
	pop af
	ld [hli], a
	ldh a, [hLinkX]
	add c
	add $08
	ld [hli], a
	ld a, $02
	ld [hli], a
	ld a, [$c135]
	ld d, a
	ld a, [$c11e]
	or d
	ld [hli], a

Jump_000_1d14:
jr_000_1d14:
	ret


Jump_000_1d15:
	ld hl, $4f00
	ld a, $0e
	jr jr_000_1d21

Jump_000_1d1c:
	ld a, $12
	ld hl, $6080

jr_000_1d21:
	ld [$2100], a
	ld de, $8400
	ld bc, $0040
	jp Jump_000_1e4d


Jump_000_1d2d:
	ld a, [wTradeSequenceItem]
	cp $02
	jp c, Jump_000_1e50

	sub $02
	ld d, a
	ld e, $00
	sra d
	rr e
	sra d
	rr e
	ld hl, $4400
	add hl, de
	ld de, $89a0
	ld bc, $0040
	ld a, $0c
	ld [$2100], a
	jp Jump_000_1e4d


Call_1D54::
	ld hl, $68c0
	ld de, $88e0
	jr jr_000_1dc4

Jump_000_1d5c:
	ld a, $11
	ld [$2100], a
	ld a, [wEntityWorkRAM]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $8d00
	add hl, de
	push hl
	ld hl, $5000

jr_000_1d7b:
	add hl, de
	pop de
	ld bc, $0040
	call CopyData
	xor a
	ldh [hBGChangeRequest], a
	ld a, $0c
	ld [$2100], a
	ret


Jump_000_1d8c:
	ld a, $13
	ld [$2100], a
	ld a, [wEntityWorkRAM]
	swap a
	and $f0
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
	rl d
	ld hl, $8d00
	add hl, de
	push hl
	ld hl, $4d00
	jr jr_000_1d7b

Jump_000_1dad:
	ld hl, $48e0
	ld de, $88e0
	ld a, $0c
	ld [$2100], a
	ld bc, $0020
	jp Jump_000_1e4d


Call_1DBE::
	ld hl, $68e0
	ld de, $8ca0

jr_000_1dc4:
	ld a, $0c
	ld [$2100], a
	ld bc, $0020
	jp Jump_000_1e4d


Jump_000_1dcf:
	ld hl, $7f00
	ld a, $12
	jr jr_000_1ddb

Jump_000_1dd6:
	ld hl, $4c40
	ld a, $0d

jr_000_1ddb:
	ld [$2100], a
	ld de, $9140
	jp Jump_000_1e4a


	db $40, $68, $40, $68, $00, $68, $80, $68, $00, $68

Call_1DEE::
	ld hl, $2100
	ld [hl], $0c
	ld hl, hLinkInteractiveMotionBlocked
	ld [hl], $01
	ld hl, wRaisedBlocksState
	ld e, [hl]
	ld d, $00
	inc a
	cp $03
	jr nz, jr_000_1e0d

	push af
	ld a, [wRaisedBlocksState]
	xor $02
	ld [wRaisedBlocksState], a
	pop af

jr_000_1e0d:
	ld [wRaisedBlockStep], a
	cp $04
	jr nz, jr_000_1e19

	ld hl, $1de4
	jr jr_000_1e20

jr_000_1e19:
	cp $08
	jr nz, jr_000_1e26

	ld hl, $1de8

jr_000_1e20:
	add hl, de
	ld de, $9040
	jr jr_000_1e3e

jr_000_1e26:
	cp $06
	jr nz, jr_000_1e2f

	ld hl, $1de4
	jr jr_000_1e3a

jr_000_1e2f:
	cp $0a
	jr nz, jr_000_1e47

	xor a
	ld [wRaisedBlockStep], a
	ld hl, $1dea

jr_000_1e3a:
	add hl, de
	ld de, $9080

jr_000_1e3e:
	ld bc, $0040
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp CopyData


jr_000_1e47:
	jp Call_1CCC


Jump_000_1e4a:
	ld bc, $0040

Jump_000_1e4d:
	call CopyData

Jump_000_1e50:
	xor a
	ldh [hBGChangeRequest], a
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


	db $0c, $03, $08, $08, $0a, $0a, $05, $10, $36, $38, $3a, $3c, $02, $01, $08, $04
	db $fc, $04, $00, $00, $00, $00, $04, $00

Call_1E73::
	call Call_1E7B
	ld a, $02
	jp SwitchBank


Call_1E7B::
	ld hl, wIsUsingPegasusBoots
	ld a, [wIsCarryingLiftedObject]
	or [hl]
	ld hl, hLinkPositionZ
	or [hl]
	ld hl, wLinkMotionState
	or [hl]
	jp nz, Jump_000_20a5

	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $1e5b
	add hl, de
	ldh a, [hLinkX]
	add [hl]
	sub $08
	and $f0
	ldh [hBGPosX], a
	swap a
	ld c, a
	ld hl, $1e5f
	add hl, de
	ldh a, [hLinkY]
	add [hl]
	sub $10
	and $f0
	ldh [hBGPosY], a
	or c
	ld e, a
	ldh [hMultiPurpose1], a
	ld hl, wRoomObjects
	add hl, de
	ld a, h
	cp $d7
	jp nz, Jump_000_207c

	ld a, [hl]
	ldh [hMultiPurpose0], a
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	call GetObjectPhysics
	ldh [hMultiPurpose5], a
	ldh a, [hMultiPurpose0]
	cp $9a
	jr z, jr_000_1f10

	ldh a, [hMultiPurpose5]
	cp $00
	jp z, Jump_000_207c

	cp $01
	jr z, jr_000_1ef8

	cp $50
	jp z, Jump_000_207c

	cp $51
	jp z, Jump_000_207c

	cp $11
	jp c, Jump_000_207c

	cp $d4
	jp nc, Jump_000_207c

	cp $d0
	jr nc, jr_000_1ef8

	cp $7c
	jp nc, Jump_000_207c

jr_000_1ef8:
	ldh a, [hMultiPurpose0]
	ld e, a
	cp $6f
	jr z, jr_000_1f08

	cp $5e
	jr z, jr_000_1f08

	cp $d4
	jp nz, Jump_000_1fa1

jr_000_1f08:
	ld a, [wIsIndoor]
	and a
	ld a, e
	jp nz, Jump_000_1fa1

jr_000_1f10:
	ld e, a
	ldh a, [hLinkDirection]
	cp $02
	jp nz, Jump_000_1ffd

	ld a, $02
	ld [wCanTalkToEntity], a
	ldh a, [hJoypadPressed]
	and $30
	jp z, Jump_000_1ffd

	ld a, e
	cp $5e
	ld a, $8e
	jr z, jr_000_1f96

	ld a, e
	cp $6f
	jr z, jr_000_1f5b

	cp $d4
	jr z, jr_000_1f5b

	ld a, [wIsMarinFollowingLink]
	and a
	jr z, jr_000_1f42

	ld a, $78
	call OpenDialogTable2
	jp Jump_000_1ffd


jr_000_1f42:
	ld a, [wSwordLevel]
	and a
	ldh a, [hMapRoom]
	jr nz, jr_000_1f50

	ld e, $ff
	cp $a3
	jr z, jr_000_1f58

jr_000_1f50:
	ld e, $fc
	cp $fa
	jr z, jr_000_1f58

	ld e, $fd

jr_000_1f58:
	ld a, e
	jr jr_000_1f9c

jr_000_1f5b:
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld a, $14
	ld [$2100], a
	ld hl, $55ff
	add hl, de
	ld a, [wOcarinaSongFlags]
	ld e, a
	ld a, [hl]
	cp $a9
	jr nz, jr_000_1f78

	bit 0, e
	jr z, jr_000_1f78

	ld a, $af

jr_000_1f78:
	cp $af
	jr nz, jr_000_1f92

	bit 0, e
	jr nz, jr_000_1f92

	ldh a, [hBGPosX]
	swap a
	and $0f
	ld e, a
	ldh a, [hBGPosY]
	and $f0
	or e
	ld [$d473], a
	jp Jump_000_1ffd


jr_000_1f92:
	cp $83
	jr z, jr_000_1f9c

jr_000_1f96:
	call OpenDialogTable1
	jp Jump_000_1ffd


jr_000_1f9c:
	call OpenDialog
	jr jr_000_1ffd

Jump_000_1fa1:
	cp $a0
	jr nz, jr_000_1ffd

	ld a, [wRoomEvent]
	and $1f
	cp $0d
	jr z, jr_000_1ffd

	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_000_1ffd

	ld [wCanTalkToEntity], a
	ldh a, [hJoypadPressed]
	and $30
	jr z, jr_000_1ffd

	ldh a, [hIsSideScrolling]
	and a
	jr nz, jr_000_1fc8

	ldh a, [hLinkDirection]
	cp $02
	jr nz, jr_000_1ffd

jr_000_1fc8:
	ld a, $14
	ld [$2100], a
	ldh a, [hMapRoom]
	ld e, a
	ld a, [wIsIndoor]
	ld d, a
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_000_1fdf

	cp $06
	jr c, jr_000_1fdf

	inc d

jr_000_1fdf:
	ld hl, $4500
	add hl, de
	ld a, [hl]
	cp $20
	jr nz, jr_000_1ff3

	ld a, [wSwordLevel]
	cp $02
	ld a, $20
	jr c, jr_000_1ff3

	ld a, $1c

jr_000_1ff3:
	ldh [hMultiPurpose8], a
	ld a, $02
	ld [$2100], a
	call $41ba

Jump_000_1ffd:
jr_000_1ffd:
	ld a, [wItemB]
	cp $03
	jr nz, jr_000_200b

	ldh a, [hJoypadHeld]
	and $20
	jr nz, jr_000_201a

	ret


jr_000_200b:
	ld a, [wItemA]
	cp $03
	jp nz, Jump_000_20a5

	ldh a, [hJoypadHeld]
	and $10
	jp z, Jump_000_20a5

jr_000_201a:
	ld a, $02
	ld [$2100], a
	call $485e
	ld a, $01
	ldh [hLinkInteractiveMotionBlocked], a
	ldh a, [hLinkDirection]
	ld e, a
	ld d, $00
	ld hl, $1e63
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
	ld hl, $1e67
	add hl, de
	ldh a, [hJoypadHeld]
	and [hl]
	jr z, jr_000_207c

	ld hl, $1e6b
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDX], a
	ld hl, $1e6f
	add hl, de
	ld a, [hl]
	ld [wLinkSpriteDY], a
	ld hl, hLinkAnimationState
	inc [hl]
	ld e, $08
	ld a, [wActivePowerUp]
	cp $01
	jr nz, jr_000_205a

	ld e, $03

jr_000_205a:
	ld hl, $c15f
	inc [hl]
	ld a, [hl]
	cp e
	jr c, jr_000_207b

	xor a
	ldh [hMultiPurposeE], a
	ldh a, [hMultiPurpose0]
	cp $8e
	jr z, jr_000_2081

	cp $20
	jr z, jr_000_2081

	ld a, [wIsIndoor]
	and a
	jr nz, jr_000_207b

	ldh a, [hMultiPurpose0]
	cp $5c
	jr z, jr_000_208f

jr_000_207b:
	ret


Jump_000_207c:
jr_000_207c:
	xor a
	ld [$c15f], a
	ret


jr_000_2081:
	call LiftRoomObject
	ld a, $14
	ld [$2100], a
	call $55aa
	jp RestoreBank


jr_000_208f:
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
;> Call_14_59DE(pos)
	call Call_14_59DE
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SpawnLiftedObject()
;@ path: link/lift
;@ Creates the entity for an object Link has just lifted (type 5), in the lifted state, with the sprite
;@ variant from hMultiPurposeE (1 = a bush), and lets bank 3 place it over Link's head. Nothing happens when
;@ all entity slots are taken.
SpawnLiftedObject::
;> slot = Call_10EB(0x05)                   # a new entity of type 5; carry = no free slot
	ld a, $05
	call Call_10EB
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
DialogStateOpenBox::
;> set_rom_bank(0x14)
	ld a, $14
	ld [$2100], a
;> Call_14_5924()                           # (bank $14 $5924)
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
;> Call_17_7B57()                           # draws the answer cursor (bank $17 $7B57)
	jp $7b57

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
;> Call_17_7B07()
	jp $7b07


;@ def RunRoomTransition()
;@ path: world/transition
;@ Runs one frame of the scroll from one room to the next (Call_02_7B74, by wRoomTransitionState).
RunRoomTransition::
;> SwitchBank(2)
	ld a, $02
	call SwitchBank
;> Call_02_7B74()
	call Call_02_7B74
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
;@ Stops all music and sound effects (Call_1F_4003 in the sound bank), unless hSkipMusicSelection asks to
;@ keep the music running across this room change.
ResetSoundEngine::
;> if not hSkipMusicSelection:
	ldh a, [hSkipMusicSelection]
	and a
	jr nz, .done

;>     set_rom_bank(0x1F)
	ld a, $1f
	ld [$2100], a
;>     Call_1F_4003()
	call Call_1F_4003

.done
;> set_rom_bank(wCurrentBank)
	jp RestoreBank


;@ def SaveDungeonItemFlags()
;@ path: world/dungeon
;@ In a dungeon, copies the dungeon's item flags (map, compass, ...) from the working copy back into its
;@ entry in the save data (Call_01_5BCF).
SaveDungeonItemFlags::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> Call_01_5BCF()
	call Call_01_5BCF
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
;@ Fills BG map 0 with a checkerboard of tiles $AE / $AF (Call_01_7CF3).
FillBGMapCheckerboard::
;> SwitchBank(1)
	ld a, $01
	call SwitchBank
;> Call_01_7CF3()
	call Call_01_7CF3
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
;@ number at $01:$56B7; Call_01_5807).
OpenRoomDialog::
;> set_rom_bank(0x01)
	ld a, $01
	ld [$2100], a
;> Call_01_5807()
	call Call_01_5807
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
;> if wHasToadstool: Call_1D54()
	ld a, [wHasToadstool]
	and a
	jr z, .noToadstool

	call Call_1D54

.noToadstool
;> if not wIsIndoor or hMapId >= 0x0A:
	ld a, [wIsIndoor]
	and a
	jr z, .notDungeon

	ldh a, [hMapId]
	cp $0a
	jr c, .tradeItem

.notDungeon
;>     if wGoldenLeaves >= 6: Call_1DBE()
	ld a, [wGoldenLeaves]
	cp $06
	jr c, .tradeItem

	call Call_1DBE

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
;> Call_1B6B()
	call Call_1B6B
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
;> Call_01_7DC1()
	jp $7dc1


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
;@ Ends with Call_01_7CDE in bank 1.
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
	ld [$c1a2], a
;> mem[0xC1C6] = 0
	ld [$c1c6], a
;> mem[0xD6FA] = 0
	ld [$d6fa], a
;> mem[0xC50A] = 0
	ld [$c50a], a
;> hStairsState = 0
	ldh [hStairsState], a
;> mem[0xC113] = 0
	ld [$c113], a
;> mem[0xD460] = 0
	ld [$d460], a
;> wBossInRoom = 0
	ld [wBossInRoom], a
;> mem[0xC50E] = 0
	ld [$c50e], a
;> wMarinSinging = 0
	ld [wMarinSinging], a
;> wRoomEventJustDone = 0
	ld [wRoomEventJustDone], a
;> wCompassChimeDelay = 0
	ld [wCompassChimeDelay], a
;> mem[0xC3CD] = 0
	ld [$c3cd], a
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
	ld [$c190], a
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
;> Call_01_7CDE()
	call Call_01_7CDE
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

	ld [$c50e], a

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

	ld hl, $c1a5
	inc [hl]

.not_CF
;> if obj == 0xAB:
	cp $ab
	jr nz, .not_AB

;>     mem[0xC3CB] = 0
	xor a
	ld [$c3cb], a
;>     if hMapRoom != 0xC4:
	ldh a, [hMapRoom]
	cp $c4
	ldh a, [hMultiPurpose9]
	jr z, .not_AB

;>         mem[0xDBC9] += 1
	ld hl, $dbc9
	inc [hl]
;>         mem[0xC3CB] = obj
	ld [$c3cb], a
;>         mem[0xC3CD] += 4
	push af
	ld a, [$c3cd]
	add $04
	ld [$c3cd], a
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


OverworldMacroTree::
	dec bc
	ld a, [bc]
	add $11
	ld e, a
	and $0f
	jr nz, jr_000_3345

	ld a, e
	sub $10
	ld e, a

jr_000_3345:
	ld d, $00
	ld hl, wRoomObjectsArea
	add hl, de
	ldh a, [hMultiPurpose0]
	and a
	jr z, PlaceTree

	and $0f
	ld e, a

jr_000_3353:
	call PlaceTree
	dec bc
	ldh a, [hMultiPurpose0]
	and $40
	ld d, $f1
	jr z, jr_000_3361

	ld d, $0f

jr_000_3361:
	ld a, l
	add d
	ld l, a
	dec e
	jr nz, jr_000_3353

	inc bc
	ret


PlaceTree::
	ld a, [hl]
	cp $10
	ld a, $25
	jr c, jr_000_3372

	add $04

jr_000_3372:
	ld [hli], a
	ld a, [hl]
	cp $10
	ld a, $26
	jr c, jr_000_337c

	add $04

jr_000_337c:
	ld [hld], a
	ld a, l
	add $10
	ld l, a
	ld a, [hl]
	cp $8a
	jr nc, jr_000_3390

	cp $10
	ld a, $27
	jr c, jr_000_3392

	ld a, $2a
	jr jr_000_3392

jr_000_3390:
	ld a, $82

jr_000_3392:
	ld [hli], a
	ld a, [hl]
	cp $8a
	jr nc, jr_000_33a2

	cp $10
	ld a, $28
	jr c, jr_000_33a4

	ld a, $29
	jr jr_000_33a4

jr_000_33a2:
	ld a, $83

jr_000_33a4:
	ld [hl], a
	inc bc
	ret


PlaceObjectShape::
jr_000_33a7:
	push hl
	push de
	ld a, [bc]
	ld e, a
	ld d, $00
	add hl, de
	pop de
	ld a, [de]
	cp $e1
	jr z, jr_000_33bc

	cp $e2
	jr z, jr_000_33bc

	cp $e3
	jr nz, jr_000_33d6

jr_000_33bc:
	push af
	push hl
	push de
	ld a, l
	sub $11
	push af
	ld a, [wRoomDoorCount]
	ld e, a
	inc a
	ld [wRoomDoorCount], a
	ld d, $00
	ld hl, wWarpDestPosition
	add hl, de
	pop af
	ld [hl], a
	pop de
	pop hl
	pop af

jr_000_33d6:
	ld [hl], a
	inc de
	inc bc
	pop hl
	ld a, [bc]
	and a
	cp $ff
	jr nz, jr_000_33a7

	pop bc
	ret


MacroShapeF8::
	db $00, $01, $02, $10, $11, $12, $ff, $b6, $b7, $66, $67, $e3, $68

OverworldMacroF8::
	push bc
	call GetObjectRoomAddress
	ld bc, $33e2
	ld de, $33e9
	jp PlaceObjectShape


GetObjectRoomAddress::
	dec bc
	ld a, [bc]
	ld e, a
	ld d, $00
	ld hl, wRoomObjects
	add hl, de
	ret


MacroShapeF6::
	db $00, $01, $02, $03, $04, $10, $11, $12, $13, $14, $20, $21, $22, $23, $24, $ff
	db $55, $5a, $5a, $5a, $56, $57, $59, $59, $59, $58, $5b, $e2, $5b, $e2, $5b

OverworldMacroF6::
	push bc
	call GetObjectRoomAddress
	ld bc, $3406
	ld de, $3416
	jp PlaceObjectShape


MacroShapeF7::
	db $00, $01, $02, $10, $11, $12, $20, $21, $22, $ff, $55, $5a, $56, $57, $59, $58
	db $5b, $e2, $5b

OverworldMacroF7::
	push bc
	call GetObjectRoomAddress
	ld bc, $3432
	ld de, $343c
	jp PlaceObjectShape


MacroShapeF9::
	db $00, $01, $02, $10, $11, $12, $ff, $a4, $a5, $a6, $a7, $e3, $a8

OverworldMacroF9::
	push bc
	call GetObjectRoomAddress
	ld bc, $3452
	ld de, $3459
	jp PlaceObjectShape


MacroShapeFA::
	db $00, $01, $10, $11, $ff, $bb, $bc, $bd, $be, $09, $09, $09, $09

OverworldMacroFA::
	push bc
	call GetObjectRoomAddress
	ld bc, $346c
	ld de, $3471
	ldh a, [hRoomStatus]
	and $04
	jr z, jr_000_348c

	ld de, $3475

jr_000_348c:
	jp PlaceObjectShape


MacroShapeFB::
	db $00, $01, $10, $11, $ff, $b6, $b7, $cd, $ce

OverworldMacroFB::
	push bc
	call GetObjectRoomAddress
	ld bc, $348f
	ld de, $3494
	jp PlaceObjectShape


MacroShapeFC::
	db $00, $01, $02, $10, $11, $12, $1f, $20, $21, $22, $23, $30, $31, $32, $ff, $2b
	db $2c, $2d, $37, $e8, $38, $0a, $33, $2f, $34, $0a, $0a, $0a, $0a

OverworldMacroFC::
	push bc
	call GetObjectRoomAddress
	ld bc, $34a5
	ld de, $34b4
	jp PlaceObjectShape


MacroShapeFD::
	db $00, $01, $02, $10, $11, $12, $ff, $52, $52, $52, $5b, $e2, $5b

OverworldMacroFD::
	push bc
	call GetObjectRoomAddress
	ld bc, $34cf
	ld de, $34d6
	jp PlaceObjectShape


DoorKeyTopObjects::
	db $2d, $2e

DoorKeyTop::
	ld e, $00
	call RecordDoor
	ldh a, [hRoomStatus]
	and $04
	jp nz, DoorOpenTop

	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $34e9
	jp PlaceObjectShape


DoorKeyBottomObjects::
	db $2f, $30

DoorKeyBottom::
	ld e, $01
	call RecordDoor
	ldh a, [hRoomStatus]
	and $08
	jp nz, DoorOpenBottom

	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $3504
	jp PlaceObjectShape


DoorKeyLeftObjects::
	db $31, $32

DoorKeyLeft::
	ld e, $02
	call RecordDoor
	ldh a, [hRoomStatus]
	and $02
	jp nz, DoorOpenLeft

	push bc
	call GetObjectRoomAddress
	ld bc, $36cc
	ld de, $351f
	jp PlaceObjectShape


DoorKeyRightObjects::
	db $33, $34

DoorKeyRight::
	ld e, $03
	call RecordDoor
	ldh a, [hRoomStatus]
	and $01
	jp nz, DoorOpenRight

	push bc
	call GetObjectRoomAddress
	ld bc, $36cc
	ld de, $353a
	jp PlaceObjectShape


DoorShutterTop::
	ld e, $04
	call RecordDoor
	ld a, [wRoomShutterDoors]
	or $01
	ld [wRoomShutterDoors], a
	ld [wRoomShutterDoorsCopy], a
	jp DoorOpenTop


DoorShutterBottom::
	ld e, $05
	call RecordDoor
	ld a, [wRoomShutterDoors]
	or $02
	ld [wRoomShutterDoors], a
	ld [wRoomShutterDoorsCopy], a
	jp DoorOpenBottom


DoorShutterLeft::
	ld e, $06
	call RecordDoor
	ld a, [wRoomShutterDoors]
	or $04
	ld [wRoomShutterDoors], a
	ld [wRoomShutterDoorsCopy], a
	jp DoorOpenLeft


DoorShutterRight::
	ld e, $07
	call RecordDoor
	ld a, [wRoomShutterDoors]
	or $08
	ld [wRoomShutterDoors], a
	ld [wRoomShutterDoorsCopy], a
	jp DoorOpenRight


DoorOpenTopObjects::
	db $43, $44

DoorOpenTop::
	ld a, $04
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $35a1
	jp PlaceObjectShape


SetRoomStatusBits::
	push af
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_000_35c6

	cp $06
	jr c, jr_000_35c6

	inc d

jr_000_35c6:
	ld hl, $d900
	add hl, de
	pop af
	or [hl]
	ld [hl], a
	ldh [hRoomStatus], a
	ret


DoorOpenBottomObjects::
	db $8c, $08

DoorOpenBottom::
	ld a, $08
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $35d0
	jp PlaceObjectShape


DoorOpenLeftObjects::
	db $09, $0a

DoorOpenLeft::
	ld a, $02
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $36cc
	ld de, $35e4
	jp PlaceObjectShape


DoorOpenRightObjects::
	db $0b, $0c

DoorOpenRight::
	ld a, $01
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $36cc
	ld de, $35f8
	jp PlaceObjectShape


DoorBossTopObjects::
	db $a4, $a5

DoorBossTop::
	ld e, $08
	call RecordDoor
	ldh a, [hRoomStatus]
	and $04
	jp nz, DoorOpenTop

	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $360c
	jp PlaceObjectShape


RecordDoor::
	ld d, $00
	ld hl, wDoorPosition
	add hl, de
	dec bc
	ld a, [bc]
	ld [hl], a
	push af
	and $f0
	ld hl, wDoorY
	add hl, de
	ld [hl], a
	pop af
	swap a
	and $f0
	ld hl, wDoorX
	add hl, de
	ld [hl], a
	inc bc
	ret


IndoorMacroF9Objects::
	db $af, $b0

IndoorMacroF9::
	push bc
	call GetObjectRoomAddress
	ld bc, $36cc
	ld de, $3644
	jp PlaceObjectShape


IndoorMacroFAObjects::
	db $b1, $b2

IndoorMacroFA::
	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $3653
	jp PlaceObjectShape


IndoorMacroFBObjects::
	db $45, $46

IndoorMacroFB::
	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $3662
	jp PlaceObjectShape


IndoorMacroFCShape::
	db $00, $01, $02, $03, $10, $11, $12, $13, $20, $21, $22, $23, $ff, $b3, $b4, $b4
	db $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd

IndoorMacroFC::
	ld a, $08
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $3671
	ld de, $367e
	jp PlaceObjectShape


IndoorMacroFDObjects::
	db $c1, $c2

IndoorMacroFD::
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_000_36b7

	cp $06
	jr c, jr_000_36b7

	ldh a, [hMapRoom]
	cp $d3
	jr nz, jr_000_36b7

	ld a, [$db46]
	and a
	jr z, jr_000_36b7

	jp DoorShutterBottom


jr_000_36b7:
	ld a, $01
	call SetRoomStatusBits
	push bc
	call GetObjectRoomAddress
	ld bc, $36c9
	ld de, $369c
	jp PlaceObjectShape


ShapeHorizontalPair::
	db $00, $01, $ff

ShapeVerticalPair::
	db $00, $10, $ff

FillRoomObjects::
	ldh [hMultiPurposeH], a
	ld d, $80
	ld hl, wRoomObjects
	ld e, a

jr_000_36d7:
	ld a, l
	and $0f
	jr z, jr_000_36e1

	cp $0b
	jr nc, jr_000_36e1

	ld [hl], e

jr_000_36e1:
	inc hl
	dec d
	jr nz, jr_000_36d7

	ret


LoadRoomEntities::
	ld a, $01
	ld [$2100], a
	call $5c61
	ld a, $16
	ld [$2100], a
	xor a
	ldh [hMultiPurposeD], a
	ldh a, [hMapRoom]
	ld c, a
	ld b, $00
	sla c
	rl b
	ld hl, $4000
	ld a, [wIsIndoor]
	and a
	jr z, jr_000_3747

	ldh a, [hMapId]
	cp $06
	jr nz, jr_000_3738

	ld a, [wIronBallRoom]
	ld hl, hMapRoom
	cp [hl]
	jr nz, jr_000_3738

	ld a, $a8
	call Call_3C01
	ld a, [wIronBallX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld a, [wIronBallY]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
	call InitLoadedEntity
	ld hl, wEntityLoadOrder
	add hl, de
	ld [hl], $ff
	xor a
	ldh [hMultiPurposeD], a

jr_000_3738:
	ld hl, $4200
	ldh a, [hMapId]
	cp $1a
	jr nc, jr_000_3747

	cp $06
	jr c, jr_000_3747

	inc h
	inc h

jr_000_3747:
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a

jr_000_374c:
	ld a, [bc]
	cp $ff
	jr z, jr_000_3756

	call LoadRoomEntity
	jr jr_000_374c

jr_000_3756:
	call RestoreBank
	ret


RoomEntityBitMask::
	db $01, $02, $04, $08, $10, $20, $40, $80

LoadRoomEntity::
	ldh a, [hMultiPurposeD]
	cp $08
	jr nc, jr_000_377a

	ld e, a
	ld d, $00
	ld hl, $375a
	add hl, de
	ldh a, [hMapRoom]
	ld e, a
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
	add hl, de
	and [hl]
	jr nz, jr_000_378c

jr_000_377a:
	ld e, $00
	ld d, e

jr_000_377d:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	cp $00
	jr z, jr_000_3793

	inc e
	ld a, e
	cp $10
	jr nz, jr_000_377d

jr_000_378c:
	ld hl, hMultiPurposeD
	inc [hl]
	inc bc
	inc bc
	ret


jr_000_3793:
	ld [hl], $04
	ld a, [bc]
	and $f0
	ld hl, wEntityY
	add hl, de
	add $10
	ld [hl], a
	ld a, [bc]
	inc bc
	swap a
	and $f0
	ld hl, wEntityX
	add hl, de
	add $08
	ld [hl], a
	ld hl, wEntityType
	add hl, de
	ld a, [bc]
	inc bc
	ld [hl], a

InitLoadedEntity::
	ld a, $03
	ld [$2100], a
	call $6552
	ld a, $01
	ld [$2100], a
	call $5c0a
	ld a, $16
	ld [$2100], a
	ret


ApplyIndoorRoomTemplate::
	ld e, a
	ld a, $14
	ld [$2100], a
	ld a, e
	push bc
	call $5000
	pop bc
	ldh a, [hBGTilesRequestCopy]
	ld [$2100], a
	ret


LoadTileset0E::
	ld a, $01
	ld [$2100], a
	call $7ee8
	ret


Padding37E4::
	db $ff, $ff

Call_37E6::
	ld a, $14
	ld [$2100], a
	ld hl, $56ff
	add hl, de
	ld a, [hl]
	ld hl, $2100
	ld [hl], $05
	ret


Call_37F6::
	ld a, $19
	call SwitchBank
	call $77c6
	ld a, $03
	jp SwitchBank


Call_3803::
	ld a, $03
	ld [$2100], a
	call $5441
	jp RestoreBank


Call_380E::
	ld a, $14
	ld [$2100], a
	call $5964
	jp RestoreBank


Call_3819::
	ld a, $01
	call SwitchBank
	call $5d6b
	ld a, $02
	jp SwitchBank


Call_3826::
	ld a, $03
	ld [$2100], a
	call $48b0
	jp RestoreBank


Call_3831::
	ld a, $14
	ld [$2100], a
	call $5822
	ld a, $03
	ld [$2100], a
	ret


OAMStartOffsets::
	db $00, $08, $10, $18

Call_3843::
	ld hl, $c5a7
	ld a, [hl]
	and a
	jr z, jr_000_3851

	dec [hl]
	jr nz, jr_000_3851

	ld a, $10
	ldh [hWaveSfx], a

jr_000_3851:
	ld a, [wDialogState]
	and a
	jr nz, jr_000_3864

	ld a, [wLinkPoseLock]
	ld [wLinkShowItemPoseActive], a
	and a
	jr z, jr_000_3864

	dec a
	ld [wLinkPoseLock], a

jr_000_3864:
	ld a, [wLinkMotionState]
	cp $07
	ret z

	xor a
	ld [wOAMEntriesUsed], a
	ldh a, [hMapId]
	cp $0a
	ldh a, [hFrameCounter]
	jr c, jr_000_3877

	xor a

jr_000_3877:
	and $03
	ld e, a
	ld d, $00
	ld hl, $383f
	add hl, de
	ld a, [hl]
	ld [wOAMNextIndex], a
	ld a, [$c5a0]
	ld [$c5a1], a
	xor a
	ld [$c5a0], a
	ld [wRaccoonLoopsExit], a
	ldh [hLinkInWater], a
	ld [wLinkSlowAnimation], a
	ld [wNoEventJingle], a
	ld [wLinkOnPlatform], a
	ld [wCarriedEntityType], a
	ld [$d45e], a
	ld a, [wDialogState]
	and a
	jr nz, jr_000_38ab

	ld [wCanTalkToEntity], a

jr_000_38ab:
	ld a, $02
	call SwitchBank
	call $63e6
	ld b, $00
	ld c, $0f

jr_000_38b7:
	ld a, c
	ld [wActiveEntitySlot], a
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_38c8

	ldh [hActiveEntityStatus], a
	call Call_38DD

jr_000_38c8:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_000_38b7

Jump_38CE::
	ret


Call_38CF::
	ld a, $15
	ld [$2100], a
	call $4000
	ld a, $03
	ld [$2100], a
	ret


Call_38DD::
	ld hl, wEntityType
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityType], a
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ld a, $19
	call SwitchBank
	ldh a, [hActiveEntityType]
	cp $6a
	jr nz, jr_000_3902

	ldh a, [hLinkInWater]
	and a
	jr nz, jr_000_3908

jr_000_3902:
	ldh a, [hActiveEntityStatus]
	cp $07
	jr nz, jr_000_3910

jr_000_3908:
	call $7563
	call Call_3DBA
	jr jr_000_3916

jr_000_3910:
	call Call_3DBA
	call $7563

jr_000_3916:
	ld a, $14
	call SwitchBank
	call $5388
	ld a, $03
	call SwitchBank
	ldh a, [hActiveEntityStatus]
	cp $05
	jp z, Call_3945

	rst $00

JumpTable_392B::
	dw Jump_38CE

	db $7e, $55, $90, $4d, $26, $4d, $0a, $49, $45, $39, $bc, $4e, $92, $57, $49, $4e

Call_393D::
	call Call_3945
	ld a, $03
	jp SwitchBank


Call_3945::
	ldh a, [hActiveEntityType]
	ld e, a
	ld d, b
	ld hl, $4000
	add hl, de
	ld a, [hl]
	call SwitchBank
	ld a, e
	rst $00

JumpTable_3953::
	dw Call_03_6A4B
	dw BoomerangHandler
	dw Call_03_66BF
	dw Call_18_7B61
	dw Call_03_69C9
	dw LiftableObjectHandler
	dw PushedBlockHandler
	dw Call_07_7AE3
	dw Call_18_7930
	dw OctorokHandler
	dw Call_03_6A3D
	dw MoblinHandler
	dw Call_03_6AE7
	dw Call_06_79CD
	dw Call_04_7E82
	dw Call_06_7547
	dw Call_04_5C04
	dw Call_04_5BFF
	dw Call_04_5C04
	dw HeartContainerSprite
	dw Call_07_785E
	dw Call_06_797B
	dw Call_06_6641
	dw Call_06_6641
	dw Call_06_7470
	dw Call_06_673C
	dw StalfosHandler
	dw Call_06_7CFC
	dw Call_06_7CD0
	dw $0000
	dw EvasiveStalfosHandler
	dw Call_06_7F5F
	dw HardhatBeetleHandler
	dw Call_06_7727
	dw Call_06_65FB
	dw Call_06_7EB5
	dw IronMaskHandler
	dw BurningFlameSprites
	dw BurningFlameSprites
	dw Call_06_760B
	dw Call_19_6765
	dw Call_04_5A8B
	dw Call_04_6C34
	dw Call_15_75E5
	dw Call_07_76BC
	dw Call_03_5D7F
	dw Call_03_60C0
	dw Call_03_617D
	dw Call_03_5CD0
	dw Call_03_5BDC
	dw Call_03_5BCB
	dw Call_03_5BB0
	dw Call_03_5BA0
	dw Call_03_5A9C
	dw HeartContainerHandler
	dw Call_03_609D
	dw Call_03_5FEE
	dw Call_03_5DDA
	dw Call_03_5D92
	dw Call_03_6083
	dw Call_03_6029
	dw Call_03_5FFF
	dw MarinEntityHandler
	dw TarinEntityHandler
	dw WitchEntityHandler
	dw Call_06_6801
	dw Call_18_5E68
	dw SeashellMansionTreesHandler
	dw TalkingBonesHandler
	dw BouldersHandler
	dw LeverBlockDownHandler
	dw LeverBlockUpHandler
	dw LeverBlockRightHandler
	dw LeverBlockLeftHandler
	dw $0000
	dw EntityHandler_Type4B
	dw $0000
	dw Call_04_7682
	dw Call_04_7634
	dw Call_04_6E4F
	dw Call_06_7AB3
	dw Call_04_697A
	dw Call_04_67EF
	dw Call_04_67EF
	dw Call_04_5F59
	dw Call_04_7D97
	dw Call_04_7CA7
	dw Call_04_5DE9
	dw Call_04_5EF7
	dw Call_04_569D
	dw FacadeHandler
	dw SlimeEyeHandler
	dw GenieHandler
	dw Call_05_6C41
	dw Call_05_7B05
	dw Call_07_694D
	dw Call_05_67CD
	dw WarpHandler
	dw Call_05_6261
	dw EvilEagleEntityHandler
	dw SkyScrollEntityHandler
	dw AnglerFishEntityHandler
	dw CrystalSwitchHandler
	dw AnglerRoomHelperEntityHandler
	dw Call_15_7458
	dw LeverEntityHandler
	dw RaftOwnerEntityHandler
	dw TextDebuggerEntityHandler
	dw CuccoEntityHandler
	dw BowWowEntityHandler
	dw Call_06_6BB4
	dw DogHandler
	dw Call_06_6248
	dw Call_06_60C3
	dw Call_06_60C3
	dw Call_06_6248
	dw MamashaEntityHandler
	dw GrandmaUlriraEntityHandler
	dw ChristineEntityHandler
	dw Call_06_5CE8
	dw Call_06_5ABE
	dw Call_06_5C4E
	dw Call_06_5D5C
	dw Call_06_5EFD
	dw Call_06_62DE
	dw Call_06_63CD
	dw Call_06_642A
	dw Call_18_72C6
	dw Call_06_6A88
	dw Call_06_6C58
	dw Call_06_6ED4
	dw Call_06_7066
	dw Call_06_71C9
	dw Call_06_7339
	dw Call_06_7C19
	dw Call_06_56B5
	dw Call_06_53A1
	dw Call_06_5107
	dw TileGlintHandler
	dw TileGlintHandler
	dw LeverGateShiftXHandler
	dw LeverGateShiftYHandler
	dw CueBallHandler
	dw MaskedMimicHandler
	dw ThreeOfAKindHandler
	dw AntiKirbyHandler
	dw SmasherHandler
	dw MadBomberHandler
	dw Call_07_70AD
	dw RichardHandler
	dw Call_19_5AFD
	dw SideViewWarpTriggerHandler
	dw Call_07_7503
	dw Call_07_7444
	dw Call_07_7314
	dw Call_07_71B4
	dw Call_07_715E
	dw LiftableStatueHandler
	dw Call_07_7031
	dw Call_07_63F1
	dw Call_07_6525
	dw Call_07_666D
	dw Call_07_61FB
	dw Call_07_60BD
	dw Call_07_60BD
	dw Call_07_6198
	dw Call_07_5F54
	dw Call_07_5B47
	dw Call_07_5D87
	dw Call_07_597C
	dw Call_19_680A
	dw Call_19_680A
	dw Call_19_687E
	dw Call_07_55D5
	dw Call_07_53DC
	dw Call_07_52C6
	dw Call_07_5109
	dw HoleFillerHandler
	dw Call_15_751C
	dw HoneycombHandler
	dw TarinHoneycombHandler
	dw BearHandler
	dw PapahlHandler
	dw MermaidHandler
	dw FishermanUnderBridgeHandler
	dw Call_18_772B
	dw Call_18_77EA
	dw BushCrawlerHandler
	dw Call_18_6FA8
	dw Call_18_69C7
	dw Call_18_64A7
	dw Call_18_6362
	dw Call_18_627D
	dw Call_18_6176
	dw Call_18_5EB6
	dw MamuEntityHandler
	dw WalrusEntityHandler
	dw Call_15_73C9
	dw Call_15_734E
	dw ManboEntityHandler
	dw BunnyCallingMarinEntityHandler
	dw MusicalNoteEntityHandler
	dw MadBatterEntityHandler
	dw ZoraEntityHandler
	dw FishHandler
	dw Call_19_6B9B
	dw MermaidStatueEntityHandler
	dw Call_19_6E17
	dw AnimalD0EntityHandler
	dw AnimalD1EntityHandler
	dw AnimalD2EntityHandler
	dw AnimalD3EntityHandler
	dw Call_19_5D58
	dw Call_19_5918
	dw Call_19_5817
	dw Call_19_55F3
	dw Call_19_56E8
	dw Call_19_54C1
	dw Call_19_5344
	dw Call_19_52E4
	dw Call_19_518A
	dw BookHandler
	dw EggSongEventHandler
	dw SwordBeamHandler
	dw Call_15_768A
	dw Call_15_78AC
	dw FlameShooterHandler
	dw PokeyHandler
	dw MoblinKingHandler
	dw Call_06_7C19
	dw Call_15_5096
	dw CastleGateSwitchHandler
	dw EndingObjectHandler

EntityHitboxTable::
	db $08, $05, $08, $05, $08, $0a, $08, $0a, $08, $0a, $08, $0a, $08, $10, $04, $0a
	db $08, $02, $08, $02, $08, $13, $08, $13, $08, $06, $06, $08, $08, $07, $06, $0a
	db $08, $06, $10, $30, $08, $07, $04, $0a, $0c, $07, $fc, $04, $10, $10, $0c, $12
	db $08, $08, $02, $08, $10, $0c, $08, $10, $08, $07, $0c, $08, $08, $08, $02, $08

Call_3B65::
	ld hl, wEntityHitboxFlags
	add hl, bc
	ld a, [hl]
	and $7c
	ld e, a
	ld d, b
	ld hl, $3b25
	add hl, de
	push hl
	pop de
	push bc
	sla c
	sla c
	ld hl, wEntityHitbox
	add hl, bc
	ld c, $04

jr_000_3b7f:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_000_3b7f

	pop bc
	ret


Call_3B87::
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld [hl], a
	ret


Call_3B8D::
	ld hl, wEntityState
	add hl, bc
	inc [hl]
	ret


Call_3B93::
	ld a, $02
	ld [$2100], a
	call $78b5
	jp RestoreBank


Call_3B9E::
	ld a, $03
	ld [$2100], a
	call $7892
	jp RestoreBank


Call_3BA9::
	ld a, $03
	ld [$2100], a
	call $7caa
	jp RestoreBank


Call_3BB4::
	ld a, $03
	ld [$2100], a
	call $6e3d
	jp RestoreBank


Call_3BBF::
	ld a, $03
	ld [$2100], a
	call $6c87
	jp RestoreBank


Call_3BCA::
	ld a, $03
	ld [$2100], a
	call $6bf9
	jp RestoreBank


Call_3BD5::
	ld a, $03
	ld [$2100], a
	call $6c93
	jp RestoreBank


Call_3BE0::
	ld a, $03
	ld [$2100], a
	call $73ef
	jp RestoreBank


Call_3BEB::
	ld a, $03
	ld [$2100], a
	call $6e40
	jp RestoreBank


Call_3BF6::
	ld a, $03
	ld [$2100], a
	call $75a6
	jp RestoreBank


Call_3C01::
	push af
	ld a, $03
	ld [$2100], a
	pop af
	call $64f8
	rr l
	call RestoreBank
	rl l
	ret


Call_3C13::
	push af
	ld a, $03
	ld [$2100], a
	pop af
	call $64fa
	rr l
	call RestoreBank
	rl l
	ret


Call_3C25::
	ld hl, $2100
	ld [hl], $03
	call $7e99
	jp RestoreBank


Call_3C30::
	ld hl, $2100
	ld [hl], $03
	call $7e17
	jp RestoreBank


Call_3C3B::
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z

	call Call_3D87
	push de
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, b
	ld hl, $c030
	add hl, de
	push hl
	pop de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	rra
	rra
	ld hl, hActiveEntityX
	add [hl]
	sub c
	ld [de], a
	inc de
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	pop hl
	add hl, bc
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	add c
	ld [de], a
	and $0f
	cp $0f
	jr nz, jr_000_3c83

	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3c83:
	inc de
	ld a, [hli]
	push hl
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	inc de
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityFlipAttribute]
	and $20
	xor $20
	rra
	rra
	ld hl, hActiveEntityX
	sub c
	add [hl]
	ld [de], a
	inc de
	pop hl
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	add c
	ld [de], a
	and $0f
	cp $0f
	jr nz, jr_000_3cb5

	dec de
	ld a, $f0
	ld [de], a
	inc de

jr_000_3cb5:
	inc de
	ld a, [hl]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a

jr_000_3cbc:
	ld a, [wActiveEntitySlot]
	ld c, a
	ld b, $00
	ld a, $15
	ld [$2100], a
	call $796d

jr_000_3cca:
	call $79a5
	jp RestoreBank


Call_3CD0::
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	ret z

	call Call_3D87
	push de
	ld a, [wOAMNextIndex]
	ld l, a
	ld h, $00
	ld bc, $c030
	add hl, bc
	push hl
	pop de
	ld a, [wActiveEntitySlot]
	ld c, a
	ld b, $00
	ldh a, [hIsSideScrolling]
	and a
	ldh a, [hActiveEntityDrawY]
	jr z, jr_000_3cf5

	sub $04
	ldh [hActiveEntityDrawY], a

jr_000_3cf5:
	ld [de], a
	inc de
	ld a, [wScreenShakeX]
	ld h, a
	ldh a, [hActiveEntityX]
	add $04
	sub h
	ld [de], a
	inc de
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld hl, hActiveEntityFlipAttribute
	xor [hl]
	ld [de], a
	inc de
	jr jr_000_3cbc

Call_3D19::
	ld a, $15
	ld [$2100], a
	jr jr_000_3cca

Call_3D20::
	push hl
	ld hl, wOAMBuffer
	jr jr_000_3d36

Call_3D26::
	ldh a, [hActiveEntitySpriteVariant]
	inc a
	jr z, jr_000_3d82

	push hl
	ld a, [wOAMNextIndex]
	ld e, a
	ld d, $00
	ld hl, $c030
	add hl, de

jr_000_3d36:
	push hl
	pop de
	pop hl
	ld a, c
	ldh [hMultiPurpose0], a
	ld a, [wActiveEntitySlot]
	ld c, a
	call Call_3D87
	ldh a, [hMultiPurpose0]
	ld c, a

jr_000_3d46:
	ldh a, [hActiveEntityDrawY]
	add [hl]
	ld [de], a
	inc hl
	inc de
	push bc
	ld a, [wScreenShakeX]
	ld c, a
	ldh a, [hActiveEntityX]
	add [hl]
	sub c
	ld [de], a
	inc hl
	inc de
	ldh a, [$fff5]
	ld c, a
	ld a, [hli]
	push af
	add c
	ld [de], a
	pop af
	cp $ff
	jr nz, jr_000_3d68

	dec de
	xor a
	ld [de], a
	inc de

jr_000_3d68:
	pop bc
	inc de
	ldh a, [hActiveEntityFlipAttribute]
	xor [hl]
	inc hl
	ld [de], a
	inc de
	dec c
	jr nz, jr_000_3d46

	ld a, [wActiveEntitySlot]
	ld c, a
	ld a, $15
	ld [$2100], a
	call $796d
	jp RestoreBank


jr_000_3d82:
	ld a, [wActiveEntitySlot]
	ld c, a
	ret


Call_3D87::
	push hl
	ld a, [wRoomTransitionState]
	and a
	jr z, jr_000_3dad

	ldh a, [hActiveEntityX]
	dec a
	cp $c0
	jr nc, jr_000_3dac

	ldh a, [hActiveEntityDrawY]
	dec a
	cp $88
	jr nc, jr_000_3dac

	ld hl, wEntityPosXHigh
	add hl, bc
	ld a, [hl]
	and a
	jr nz, jr_000_3dac

	ld hl, wEntityPosYHigh
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_000_3dad

jr_000_3dac:
	pop af

jr_000_3dad:
	pop hl
	ret


Call_3DAF::
	ld hl, wEntitySpeedX
	add hl, bc
	ld [hl], b
	ld hl, wEntitySpeedY
	add hl, bc
	ld [hl], b
	ret


Call_3DBA::
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityY], a
	ld hl, wEntityZ
	add hl, bc
	sub [hl]
	ldh [hActiveEntityDrawY], a
	ret


Call_3DD0::
	ld hl, $2100
	ld [hl], $15
	call $7974
	jp RestoreBank


Trampoline3DDB::
	db $21, $00, $21, $36, $04, $cd, $10, $5a, $c3, $c0, $07

Trampoline3DE6::
	db $21, $00, $21, $36, $04
	db $cd, $80, $56, $c3, $c0, $07

Trampoline3DF1::
	db $21, $00, $21, $36, $04, $cd, $4d, $50, $c3, $c0
	db $07

Trampoline3DFC::
	db $21, $00, $21, $36, $04, $cd, $b5, $49, $c3, $c0, $07

Trampoline3E07::
	db $21, $00, $21, $36
	db $04, $cd, $00, $40, $c3, $c0, $07

Trampoline3E12::
	db $21, $00, $21, $36, $05, $cd, $2b, $6c, $c3
	db $c0, $07

Trampoline3E1D::
	db $21, $00, $21, $36, $05, $cd, $76, $67, $c3, $c0, $07

Trampoline3E28::
	db $21, $00, $21
	db $36, $05, $cd, $4f, $62, $c3, $c0, $07

Trampoline3E33::
	db $21, $00, $21, $36, $05, $cd, $59, $59
	db $c3, $c0, $07

Trampoline3E3E::
	db $21, $00, $21, $36, $05, $cd, $9f, $54, $c3, $c0, $07

Call_3E49::
	ld a, [wCurrentBank]
	push af
	ld a, $02
	call SwitchBank
	call $6fb1
	pop af
	jp SwitchBank


Trampoline3E59::
	db $21, $00, $21, $36, $04, $cd, $5a, $5c, $c3, $c0, $07

Call_3E64::
	ld hl, $2100
	ld [hl], $03
	call $5464
	jp RestoreBank


Call_3E6F::
	ld hl, $2100
	ld [hl], $02
	call $5fd1
	call $6117
	jp RestoreBank


Call_3E7D::
	ld a, $02
	call SwitchBank
	call $41ba
	ld a, $03
	jp SwitchBank


Call_3E8A::
	ld hl, $2100
	ld [hl], $02
	call $61e7
	jp RestoreBank


Call_3E95::
	ld hl, $2100
	ld [hl], $03
	call $6497
	jp RestoreBank


Call_3EA0::
	ld a, $06
	call SwitchBank
	call $7940
	ld a, $03
	jp SwitchBank


Call_3EAD::
	ld e, $10
	ld hl, wEntityStatus

jr_000_3eb2:
	xor a
	ld [hli], a
	dec e
	jr nz, jr_000_3eb2

	ret


Call_3EB8::
	ld hl, $c4a0
	add hl, bc
	ld a, [hl]
	and a
	ret z

	ldh a, [hFrameCounter]
	xor c
	and $03
	ret nz

	ldh a, [hActiveEntityX]
	ldh [hMultiPurpose0], a
	ldh a, [hActiveEntityDrawY]
	ldh [hMultiPurpose1], a
	ld a, $08
	call AddTransientVfx
	ld hl, wVfxTimer
	add hl, de
	ld [hl], $0f
	ret


Call_3ED9::
	ld hl, wEntityRecoilSpeedX
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_000_3ee4

	cpl
	inc a

jr_000_3ee4:
	ldh [hMultiPurpose0], a
	ld hl, wEntityRecoilSpeedY
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, jr_000_3ef1

	cpl
	inc a

jr_000_3ef1:
	ld e, $03
	ld hl, hMultiPurpose0
	cp [hl]
	jr c, jr_000_3efb

	ld e, $0c

jr_000_3efb:
	ld a, e
	ld hl, wEntityCollisions
	add hl, bc
	and [hl]
	jr z, jr_000_3f08

	ld hl, wEntityIgnoreHitsTimer
	add hl, bc
	ld [hl], b

jr_000_3f08:
	ret


DungeonMapDialogs::
	db $b0, $b4, $b1, $b2, $b3, $b6, $ba, $bc, $b8

Call_3F12::
	ld hl, wInventoryAppearing
	ld a, [wRoomTransitionState]
	or [hl]
	ret nz

	ld a, [wBossMusicDelay]
	and a
	jr z, jr_000_3f25

	dec a
	ld [wBossMusicDelay], a
	ret


jr_000_3f25:
	ld a, [wBossMusicStarted]
	and a
	ret nz

	inc a
	ld [wBossMusicStarted], a
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $04
	ld a, $19
	jr z, jr_000_3f3b

	ld a, $50

jr_000_3f3b:
	ld [wMusicTrackToPlay], a
	ldh [hDefaultMusicTrackAlt], a
	ld a, [wTransitionSequenceCounter]
	cp $04
	ret nz

	ldh a, [hActiveEntityType]
	cp $87
	jr nz, jr_000_3f50

	ld a, $da
	jr jr_000_3f6e

jr_000_3f50:
	cp $bc
	jr nz, jr_000_3f58

	ld a, $26
	jr jr_000_3f6e

jr_000_3f58:
	ld hl, wEntityOptions1
	add hl, bc
	ld a, [hl]
	and $04
	jr nz, jr_000_3f71

	ldh a, [hMapId]
	cp $05
	jr z, jr_000_3f71

	ld e, a
	ld d, b
	ld hl, $3f09
	add hl, de
	ld a, [hl]

jr_000_3f6e:
	call OpenDialog

jr_000_3f71:
	ret


RoomEntityBitMask2::
	db $01, $02, $04, $08, $10, $20, $40, $80

Call_3F7A::
	ld a, $03
	ld [$c113], a
	ld [$2100], a
	call $562f
	call RestoreBank

Call_3F88::
	ld hl, wEntityLoadOrder
	add hl, bc
	ld a, [hl]
	cp $ff
	jr z, Call_3FB7

	push af
	ld a, [wDefeatedEntityCount]
	ld e, a
	ld d, b
	inc a
	ld [wDefeatedEntityCount], a
	ld a, [hl]
	ld hl, wDefeatedEntities
	add hl, de
	ld [hl], a
	pop af

Call_3FA2::
	cp $08
	jr nc, Call_3FB7

	ld e, a
	ld d, b
	ld hl, $3f72
	add hl, de
	ldh a, [hMapRoom]
	ld e, a
	ld d, b
	ld a, [hl]
	ld hl, wRoomDefeatedEntityBits
	add hl, de
	or [hl]
	ld [hl], a

Call_3FB7::
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


Jump_000_3fbd:
	ld a, $05
	ld [$2100], a
	ld hl, $5919
	ld de, $8460
	ld bc, $0010
	call CopyData
	ld hl, $5929
	jr jr_000_3fe7

Jump_000_3fd3:
	ld a, $05
	ld [$2100], a
	ld hl, $5939
	ld de, $8460
	ld bc, $0010
	call CopyData
	ld hl, $5949

jr_000_3fe7:
	ld de, $8480
	ld bc, $0010
	call CopyData
	xor a
	ldh [hBGChangeRequest], a
	ld a, $0c
	ld [$2100], a
	jp Call_1CCC


	db $ff, $ff, $ff, $ff, $ff
