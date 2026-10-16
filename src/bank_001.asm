; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

;@ def SaveMenuHandler()
;@ path: menu/save
;@ Game mode 6, the save menu that opens in play when A+B+Select+Start are held: runs the current step
;@ (wGameplaySubtype) from SaveMenuSteps.
;@ test: skip jumps through a table
SaveMenuHandler::
;> return SaveMenuSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/save
;@ The steps of the save menu (game mode 6), one routine address (dw) per value of wGameplaySubtype:
;@ 0 fade out the world, 1 load the menu tiles, 2 draw the menu screen, 3 fade in, 4 handle the cursor,
;@ 5 go back to the world (shared with the world map).
SaveMenuSteps::
	dw SaveMenuInit
	dw SaveMenuLoadTiles
	dw SaveMenuLoadScreen
	dw SaveMenuFadeIn
	dw SaveMenuInput
	dw ReturnToWorld
;@ def SaveMenuInit()
;@ path: menu/save
;@ Step 0: keeps drawing Link and fades the world out; when the fade is complete, resets the scroll
;@ offsets and requests the tile set of the menu.
;@ test: skip calls into the fade and the sprite code of bank 0
SaveMenuInit::
;> DrawLinkOAM()                       # draw Link
	call DrawLinkOAM
;> UpdateEntitiesBank1()                       # draw the entities
	call UpdateEntitiesBank1
;> FadePalettesToWhite()                       # one step of the fade out
	call FadePalettesToWhite
;> if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	jr nz, .done
;> hVolumeRight = 3
	ld a, $03
	ldh [hVolumeRight], a
;> hVolumeLeft = 0x30
	ld a, $30
	ldh [hVolumeLeft], a
;> IncrementGameplaySubtype()                    # next step
	call IncrementGameplaySubtype
;> wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;> wInventoryAppearing = 0
	ld [wInventoryAppearing], a
;> wSongMenuOpenTimer = 0
	ld [wSongMenuOpenTimer], a
;> wSongMenuCloseTimer = 0
	ld [wSongMenuCloseTimer], a
;> wSongMenuShown = 0
	ld [wSongMenuShown], a
;> wTileMapToLoad = 0x0F             # the menu tile set
	ld a, $0f
	ld [wTileMapToLoad], a
.done
	ret

;@ def SaveMenuLoadTiles()
;@ path: menu/save
;@ Step 1: requests tile set $0D and puts the cursor on the first choice.
SaveMenuLoadTiles::
;> wTileMapToLoad = 0x0D
	ld a, $0d
	ld [wTileMapToLoad], a
;> wMenuCursor = 0
	xor a
	ld [wMenuCursor], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def SaveMenuLoadScreen()
;@ path: menu/save
;@ Step 2: requests the menu screen ($0D), hides the window and resets the scroll and the fade.
SaveMenuLoadScreen::
;> wBGMapToLoad = 0x0D
	ld a, $0d
	ld [wBGMapToLoad], a
;> wWindowY = 0xFF                   # window off screen
	ld a, $ff
	ld [wWindowY], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wTransitionSequenceCounter = 0
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def SaveMenuFadeIn()
;@ path: menu/save
;@ Step 3: fades the menu screen in and moves on when the fade is complete.
;@ test: skip calls the fade code of bank 0
SaveMenuFadeIn::
;> FadePalettesIn()                       # one step of the fade in
	call FadePalettesIn
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret

;@ def SaveMenuInput()
;@ path: menu/save
;@ Step 4: moves the cursor between the two choices; A, B or Start confirms. Choice 0 (continue) goes
;@ on to step 5, which returns to the world; choice 1 saves and quits to the title (SaveMenuQuitToTitle).
;@ test: skip calls bank 0 code
SaveMenuInput::
;> UpdateSaveMenuCursor()
	call UpdateSaveMenuCursor
;> if not hJoypadPressed & 0xB0:     # A, B or Start
	ldh a, [hJoypadPressed]
	and $b0
;>     return
	jr z, InitLCDRegisters.done
;> hJingle = 0x13                    # confirm sound
	ld a, $13
	ldh [hJingle], a
;> if wMenuCursor == 1:
	ld a, [wMenuCursor]
	cp $01
;>     return SaveMenuQuitToTitle()
	jr z, SaveMenuQuitToTitle
;> IncrementGameplaySubtype()                    # step 5: back to the world
	call IncrementGameplaySubtype
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .done
;>     wItemButtonsDisabled = 0
	xor a
	ld [wItemButtonsDisabled], a
;>     wRoomEntitySetupDone = 0
	ld [wRoomEntitySetupDone], a
.done
	ret

;@ def UnusedSaveMenuContinue()
;@ path: unused
;@ Never reached (it follows a `ret`): blacks out the palettes, takes Link's position as the entrance
;@ position and restarts the game from the save data like the game over menu does.
;@ test: skip unreachable; calls the game start code
UnusedSaveMenuContinue::
;> wOBJ0Palette = 0
	xor a
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> rOBP0 = 0
	ldh [rOBP0], a
;> rOBP1 = 0
	ldh [rOBP1], a
;> wBGPalette = 0
	ld [wBGPalette], a
;> rBGP = 0
	ldh [rBGP], a
;> wMapEntrancePositionX = hLinkX
	ldh a, [hLinkX]
	ld [wMapEntrancePositionX], a
;> wMapEntrancePositionY = hLinkY
	ldh a, [hLinkY]
	ld [wMapEntrancePositionY], a
;> StartGameplay()                   # start the game from the save data
	call StartGameplay
;> wInvincibilityCounter = 0x80
	ld a, $80
	ld [wInvincibilityCounter], a
;> return
	ret

;@ def SaveMenuQuitToTitle()
;@ path: menu/save
;@ The save menu's "save and quit": stops the music, saves the game, clears the RAM and resets to the
;@ intro (game mode 0) with the screen on and the window hidden below it.
;@ test: skip saves to battery RAM and clears the RAM
SaveMenuQuitToTitle::
;> ResetSoundEngine()                       # stop the sound
	call ResetSoundEngine
;> SaveGame()
	call SaveGame
;> ClearHRAMPartAndWRAM()                       # clear the RAM
	call ClearHRAMPartAndWRAM
;> StartIntroMode()                   # back to game mode 0, the intro
	call StartIntroMode
;> InitLCDRegisters()                   # falls through into it

;@ def InitLCDRegisters()
;@ path: system/lcd
;@ Switches the screen on (rLCDC and wLCDControl $C7: background, sprites 8x16, window map $9C00), puts the
;@ window at x 7 and below the screen (y $80, hidden) and sets the sound volume to full on both sides.
;@ The end of SaveMenuQuitToTitle; Init calls it at power-on.
;@ test: skip writes the LCD registers
InitLCDRegisters::
;> rLCDC = 0xC7
	ld a, $c7
	ldh [rLCDC], a
;> wLCDControl = 0xC7
	ld [wLCDControl], a
;> rWX = 7
	ld a, $07
	ldh [rWX], a
;> wWindowY = 0x80
	ld a, $80
	ld [wWindowY], a
;> rWY = 0x80
	ldh [rWY], a
;> hVolumeRight = 7
	ld a, $07
	ldh [hVolumeRight], a
;> hVolumeLeft = 0x70
	ld a, $70
	ldh [hVolumeLeft], a
.done
	ret


;@ path: menu/save
;@ Sprite y position of the save menu cursor for each choice (wMenuCursor 0-1), one byte each.
SaveMenuCursorY::
	db $48, $58

;@ def UpdateSaveMenuCursor()
;@ path: menu/save
;@ Up, Down or Select toggles the save menu choice (with the cursor sound); then puts the cursor sprite
;@ (the arrow, tile $BE at x $24) at the chosen line in OAM entry 6.
UpdateSaveMenuCursor::
;> PlayCursorSoundOnMove()                    # cursor sound when Up, Down or Select is pressed
	ld hl, wMenuCursor
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x4C:         # Up, Down, Select
	ldh a, [hJoypadPressed]
	and $4c
	jr z, .draw
;>     wMenuCursor = (wMenuCursor + 1) & 1
	ld a, [hl]
	inc a
	and $01
	ld [hl], a
.draw
;>@y wOAMBuffer[24] = mem[SaveMenuCursorY + wMenuCursor]     # OAM entry 6: y
	ld e, [hl]
	ld d, $00
	ld hl, SaveMenuCursorY
	add hl, de
	ld a, [hl]
;=@y
	ld hl, wOAMBuffer + 24
	ld [hli], a
;> wOAMBuffer[25] = 0x24             # x
	ld a, $24
	ld [hli], a
;> wOAMBuffer[26] = 0xBE             # tile: the arrow
	ld a, $be
	ld [hli], a
;> wOAMBuffer[27] = 0                # attributes
	ld [hl], $00
	ret

;@ def UnusedFlashScreen()
;@ path: unused
;@ Nothing calls it. Unless hLinkCountdown is running, steps the background palette from black to
;@ white and back with busy loops (several frames of delay), then blacks it out.
;@ test: skip busy loops on the palette register
UnusedFlashScreen::
;> if hLinkCountdown == 0:
	ldh a, [hLinkCountdown]
	and a
	jp nz, .black
;>     for _ in range(0x70):
	ld e, $70
.loop1
;>         rBGP = 0x00                # then a delay of 30 nop instructions
	ld a, $00
	ldh [rBGP], a
	ds 30, $00
	dec e
	jr nz, .loop1
;>     for _ in range(0x30):
	ld e, $30
.loop2
;>         rBGP = 0x40
	ld a, $40
	ldh [rBGP], a
	dec e
	jr nz, .loop2
;>     for _ in range(0x30):
	ld e, $30
.loop3
;>         rBGP = 0x80
	ld a, $80
	ldh [rBGP], a
	dec e
	jr nz, .loop3
;>     for _ in range(0xFF):
	ld e, $ff
.loop4
;>         rBGP = 0xC0                # then a delay of 18 nop instructions
	ld a, $c0
	ldh [rBGP], a
	ds 18, $00
	dec e
	jr nz, .loop4
;>     for _ in range(0x30):
	ld e, $30
.loop5
;>         rBGP = 0x80
	ld a, $80
	ldh [rBGP], a
	dec e
	jr nz, .loop5
;>     for _ in range(0x30):
	ld e, $30
.loop6
;>         rBGP = 0x40
	ld a, $40
	ldh [rBGP], a
	dec e
	jr nz, .loop6
.black
;> wBGPalette = 0
	xor a
	ld [wBGPalette], a
;> rBGP = 0
	ldh [rBGP], a
	ret

;@ def GameOverHandler()
;@ path: menu/gameover
;@ Link's death sequence and the game over menu, run while Link is in his "passed out" motion state:
;@ dispatches on hLinkMotionStep through GameOverSteps.
;@ test: skip jumps through a table
GameOverHandler::
;> return GameOverSteps[hLinkMotionStep]()
	ldh a, [hLinkMotionStep]
	rst $00

;@ path: menu/gameover
;@ The steps of the death sequence (dw per value of hLinkMotionStep): 0 Link spins and falls,
;@ 1 load the game over tiles, 2 draw the game over screen, 3 wait and start the music, 4 the menu.
GameOverSteps::
	dw GameOverSpin
	dw GameOverLoadTiles
	dw GameOverLoadScreen
	dw GameOverWaitMusic
	dw GameOverMenu

;@ path: menu/gameover
;@ Link's sprite pose (hLinkAnimationState) during the death spin, indexed by hLinkCountdown / 8
;@ (24 bytes; the countdown starts at $BF, so the list is read from the end backwards): poses $06, $04,
;@ $0A, $00 repeated (Link turning around), then $6A (Link lying on the ground).
GameOverSpinLinkFrames::
	db $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a
	db $6a, $6a, $00, $00, $00, $0a, $04, $06, $00, $0a, $04, $06, $00, $0a, $04, $06
;@ path: menu/gameover
;@ Value written to $C3CD during the death spin, indexed by hLinkCountdown / 8 (28 bytes, entries
;@ 0-23 used): rises from $10 to $1C as the countdown runs out.
GameOverSpinValues::
	db $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1c, $1b, $1a, $19, $18, $17, $16
	db $15, $14, $13, $12, $11, $10, $10, $10, $10, $10, $10, $10

;@ def GameOverSpin()
;@ path: menu/gameover
;@ Step 0 of the death sequence. While hLinkCountdown runs, Link spins (pose from GameOverSpinLinkFrames)
;@ with the sprite palettes darkened. When it reaches 0: Link disappears, the game over tile set is
;@ requested, the death counter goes up by one (BCD, at most 999) and some effects are switched off.
;@ test: skip BCD counter in two variables
GameOverSpin::
;> wScreenShakeX = 0
	xor a
	ld [wScreenShakeX], a
;> wScreenShakeY = 0
	ld [wScreenShakeY], a
;> if hLinkCountdown:
	ldh a, [hLinkCountdown]
	and a
	jr nz, .spin
;>@f     hLinkAnimationState = mem[GameOverSpinLinkFrames + (hLinkCountdown >> 3)]
;>@v     wRoomDarkness = mem[GameOverSpinValues + (hLinkCountdown >> 3)]
;>@c     wRoomHasTorches = 1
;>@o0     wOBJ0Palette = 0x1C            # darker sprites
;>@o1     wOBJ1Palette = wBGPalette
;>@r     return
;> hLinkCountdown = 0x10                 # waited for in step 3
	ld a, $10
	ldh [hLinkCountdown], a
;> hLinkMotionStep = 1
	ld a, $01
	ldh [hLinkMotionStep], a
;> wTileMapToLoad = 0x0F
	ld a, $0f
	ld [wTileMapToLoad], a
;> hLinkAnimationState = 0xFF            # Link not drawn
	ld a, $ff
	ldh [hLinkAnimationState], a
;>@d bcd_write(0xDB57, 2, bcd_to_int(wDeathCount) + 1)     # one more death
	ld a, [wDeathCount]
	add $01
	daa
	ld [wDeathCount], a
	ld a, [wDeathCount + 1]
	adc $00
;=@d
	daa
	ld [wDeathCount + 1], a
;> if wDeathCount >= 0x1000:
	cp $10
	jr c, .counted
;>     wDeathCount = 0x0999
	ld a, $99
	ld [wDeathCount], a
	ld a, $09
	ld [wDeathCount + 1], a
.counted
;> wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;> wKillCounter = 0
	ld [wKillCounter], a
;> wActivePowerUp = 0
	ld [wActivePowerUp], a
;> wPowerUpHits = 0
	ld [wPowerUpHits], a
;> fill(0xC3CB, 0, 3)
	ld [wRoomHasTorches], a
	ld [wRoomDarknessShown], a
	ld [wRoomDarkness], a
;> return
	ret

.spin
;=@f
	rra
	rra
	rra
	and $3f
	ld e, a
	ld d, $00
;=@f
	ld hl, GameOverSpinLinkFrames
	add hl, de
	ld a, [hl]
	ldh [hLinkAnimationState], a
;=@v
	ldh a, [hLinkCountdown]
	rra
	rra
	rra
	and $1f
	ld e, a
;=@v
	ld hl, GameOverSpinValues
	add hl, de
	ld a, [hl]
	ld [wRoomDarkness], a
;=@c
	ld a, $01
	ld [wRoomHasTorches], a
;=@o0
	ld a, $1c
	ld [wOBJ0Palette], a
;=@o1
	ld a, [wBGPalette]
	ld [wOBJ1Palette], a
;=@r
	ret
;@ def GameOverLoadTiles()
;@ path: menu/gameover
;@ Step 1: requests tile set $0D (the menu font) and moves on.
GameOverLoadTiles::
;> wTileMapToLoad = 0x0D
	ld a, $0d
	ld [wTileMapToLoad], a
;> hLinkMotionStep += 1
	ld hl, hLinkMotionStep
	inc [hl]
	ret

;@ def GameOverLoadScreen()
;@ path: menu/gameover
;@ Step 2: sets the normal background palette, requests the game over screen ($0A), hides the window,
;@ resets the scroll and stores the dungeon's item flags back into the save data.
;@ test: skip calls another bank through bank 0
GameOverLoadScreen::
;> wBGPalette = 0xE4
	ld a, $e4
	ld [wBGPalette], a
;> wBGMapToLoad = 0x0A
	ld a, $0a
	ld [wBGMapToLoad], a
;> wWindowY = 0xFF
	ld a, $ff
	ld [wWindowY], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> hLinkMotionStep += 1
	ld hl, hLinkMotionStep
	inc [hl]
;> SaveDungeonItemFlags()                           # StoreDungeonItemFlags: dungeon item flags back to their slot
	call SaveDungeonItemFlags
	ret

;@ path: unused
;@ 16 bytes nothing reads: two rows of 8 small signed offsets ($00, $FE, $FD, $FE, $00, $02, $03, $02
;@ and $00, $04, $08, $0C, $10, $0C, $08, $04), shaped like a wobble.
UnusedGameOverTable::
	db $00, $fe, $fd, $fe, $00, $02, $03, $02, $00, $04
	db $08, $0c, $10, $0c, $08, $04

;@ def GameOverWaitMusic()
;@ path: menu/gameover
;@ Step 3: when the countdown set in step 0 runs out, starts the game over music (track 3) and moves on
;@ to the menu.
GameOverWaitMusic::
;> if hLinkCountdown == 0:
	ldh a, [hLinkCountdown]
	and a
	jr nz, .done
;>     hLinkMotionStep += 1
	ld hl, hLinkMotionStep
	inc [hl]
;>     wMusicTrackToPlay = 3
	ld a, $03
	ld [wMusicTrackToPlay], a
.done
	ret

;@ def GameOverMenu()
;@ path: menu/gameover
;@ Step 4, the game over menu with three choices: 0 saves and continues, 1 saves and quits to the
;@ intro, 2 continues without saving (wContinueWithoutSave keeps the room flags in RAM). Continuing
;@ clears the entities, blacks out the palettes and restarts play at the entrance Link last came
;@ through, invincible for a while.
;@ test: skip saves to battery RAM
GameOverMenu::
;> UpdateGameOverCursor()
	call UpdateGameOverCursor
;> if not hJoypadPressed & 0xB0:         # A, B or Start
	ldh a, [hJoypadPressed]
	and $b0
;>     return
	jr z, .done
;> if wMenuCursor == 1:
	ld a, [wMenuCursor]
	cp $01
	jr z, .quit
;>@q1     SaveGame()
;>@q2     StartIntroMode()
;>@q3     return
;> if wMenuCursor != 0:
	cp $00
	jr z, .save
;>     wContinueWithoutSave = wMenuCursor     # 2
	ld [wContinueWithoutSave], a
	jr .continue
;> else:
.save
;>     SaveGame()
	call SaveGame
.continue
;> fill(wEntityStatus, 0, 16)            # remove all entities
	xor a
	ld hl, wEntityStatus
	ld e, $10
.clear
	ld [hli], a
	dec e
	jr nz, .clear
;> wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> rOBP0 = 0
	ldh [rOBP0], a
;> rOBP1 = 0
	ldh [rOBP1], a
;> wBGPalette = 0
	ld [wBGPalette], a
;> rBGP = 0
	ldh [rBGP], a
;> wRaisedBlocksState = 0
	ld [wRaisedBlocksState], a
;> wIsSpinningInHole = 0
	ld [wIsSpinningInHole], a
;> wMapEntrancePositionX = hLinkX
	ldh a, [hLinkX]
	ld [wMapEntrancePositionX], a
;> wMapEntrancePositionY = hLinkY
	ldh a, [hLinkY]
	ld [wMapEntrancePositionY], a
;> StartGameplay()
	call StartGameplay
;> wInvincibilityCounter = 0x80
	ld a, $80
	ld [wInvincibilityCounter], a
;> return
	ret

.quit
;=@q1
	call SaveGame
;=@q2
	call StartIntroMode
;=@q3
.done
	ret

;@ path: menu/gameover
;@ Sprite y position of the game over menu cursor for each choice (wMenuCursor 0-2), one byte each.
GameOverCursorY::
	db $50, $60, $70

;@ def UpdateGameOverCursor()
;@ path: menu/gameover
;@ Down or Select moves the game over menu cursor down, Up moves it up (both wrap around, with the
;@ cursor sound); then puts the arrow sprite (tile $BE at x $24) at the chosen line in OAM entry 6.
;@ test: wMenuCursor = rand(0, 2)
UpdateGameOverCursor::
;> PlayCursorSoundOnMove()
	ld hl, wMenuCursor
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x48:             # Down, Select
	ldh a, [hJoypadPressed]
	and $48
	jr z, .notDown
;>     wMenuCursor = (wMenuCursor + 1) % 3
	ld a, [hl]
	inc a
	cp $03
	jr nz, .storeDown
	xor a
.storeDown
	ld [hl], a
.notDown
;> if hJoypadPressed & 0x04:             # Up
	ldh a, [hJoypadPressed]
	and $04
	jr z, .draw
;>     wMenuCursor = (wMenuCursor - 1) % 3
	ld a, [hl]
	dec a
	cp $ff
	jr nz, .storeUp
	ld a, $02
.storeUp
	ld [hl], a
.draw
;>@y wOAMBuffer[24] = mem[GameOverCursorY + wMenuCursor]
	ld e, [hl]
	ld d, $00
	ld hl, GameOverCursorY
	add hl, de
	ld a, [hl]
;=@y
	ld hl, wOAMBuffer + 24
	ld [hli], a
;> wOAMBuffer[25] = 0x24
	ld a, $24
	ld [hli], a
;> wOAMBuffer[26] = 0xBE
	ld a, $be
	ld [hli], a
;> wOAMBuffer[27] = 0
	ld [hl], $00
	ret

;@ def GameplayWorldHandler()
;@ path: world/load
;@ Game mode $0B, playing in the world: runs the current step of WorldSteps. Steps 0-6 load the map
;@ and the room after a warp, a continue or a new game; step 7 is the normal play loop in bank 0.
;@ test: skip jumps through a table
GameplayWorldHandler::
;> return WorldSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: world/load
;@ The steps of game mode $0B (dw per value of wGameplaySubtype): 0 pick the background layout,
;@ 1 place Link and load the room, 2 load the room's tiles, 3 load the tile set, 4 and 5 draw the room,
;@ 6 switch the window on and start the fade in, 7 play (the main play routine at WorldGameplayFrame in bank 0).
WorldSteps::
	dw WorldLoadPickLayout
	dw WorldLoadPlaceLink
	dw WorldLoadRoomTiles
	dw WorldLoadTileset
	dw WorldLoadDrawRoom
	dw WorldLoadDrawRoom2
	dw WorldLoadStartFadeIn
	dw WorldGameplayFrame

;@ path: world/load
;@ Minimap layout for each map (hMapId $00-$0C, one byte), copied to wMinimapLayout when a map is
;@ entered: only Eagle's Tower (map 6) uses a non-zero value ($30): its floors differ from the plain
;@ dungeon minimap (see DrawMinimapFrame).
MapMinimapLayouts::
	db $00, $00, $00, $00, $00, $00, $30, $00, $00, $00, $00, $00, $00

;@ def WorldLoadPickLayout()
;@ path: world/load
;@ Step 0: stops the sound effects, copies the current dungeon's five item flags (map, compass, stone
;@ beak, nightmare key, small keys) out of wDungeonItemFlags (zero outside the eight dungeons) and
;@ picks the background layout around the room: 7 for a dungeon with a minimap, 9 for other indoor maps
;@ (and Eagle's Tower side views), 2 for the overworld.
;@ test: skip calls the sound code and builds the minimap
WorldLoadPickLayout::
;> ResetSoundEngine()
	call ResetSoundEngine
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> if not wIsIndoor:
;>@o1     wBGMapToLoad = 2
;>@o2     hRandomPattern = (GetRandomByte() | hFrameCounter) & 3      # a random number 0-3
;>@o3     return
	ld a, [wIsIndoor]
	and a
	jr z, .overworld
;>@src src = wDungeonItemFlags + hMapId * 5
	ldh a, [hMapId]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
;=@src
	ld d, $00
	ld hl, wDungeonItemFlags
	add hl, de
;>@for for i in range(5):
	ld de, wDungeonHasMap
	ld c, $05
.copy
;>@v     mem[wDungeonHasMap + i] = mem[src + i] if hMapId < 8 else 0    # only the 8 dungeons
	ldh a, [hMapId]
	cp $0a
	ldh a, [hMapId]
	cp $08
	jr z, .none
	jr c, .flag
.none
;=@v
	xor a
	jr z, .store
.flag
;=@v
	ld a, [hli]
.store
	ld [de], a
;=@for
	inc de
	dec c
	jr nz, .copy
;>@lay wMinimapLayout = mem[MapMinimapLayouts + hMapId]
	ldh a, [hMapId]
	ld e, a
	ld d, $00
	ld hl, MapMinimapLayouts
	add hl, de
	ld a, [hl]
;=@lay
	ld [wMinimapLayout], a
;>@nm if hMapId == 8 or hMapId >= 0x0A or (hMapId == 6 and hIsSideScrolling):
	ld a, e
	cp $08
	jr z, .noMinimap
	cp $0a
	jr nc, .noMinimap
;=@nm
	cp $06
	jr nz, .minimap
	ldh a, [hIsSideScrolling]
	and a
	jr nz, .noMinimap
;>@b1     wBGMapToLoad = 9                    # (Eagle's Tower side views too)
;>@b2     return
.minimap
;> DrawMinimapFrame()                       # build the minimap draw commands
	call DrawMinimapFrame
;> wBGMapToLoad = 7
	ld a, $07
	ld [wBGMapToLoad], a
;> return
	ret

.overworld
;=@o1
	ld a, $02
	ld [wBGMapToLoad], a
;=@o2
	call GetRandomByte
	ld hl, hFrameCounter
	or [hl]
	and $03
	ldh [hRandomPattern], a
;=@o3
	ret

.noMinimap
;=@b1
	ld a, $09
	ld [wBGMapToLoad], a
;=@b2
	ret


;@ def WorldLoadPlaceLink()
;@ path: world/load
;@ Step 1: clears the play variables, puts Link at the entrance position (also his respawn point),
;@ lifts him into the air if he arrives by a warp from above, runs the room loader and spawns the
;@ companions. With the compass, entering a dungeon room that still holds its key starts the compass
;@ chime. Then requests the tile set of the area (6 indoors, 7 on the overworld).
;@ test: skip clears RAM and loads the room through other banks
WorldLoadPlaceLink::
;> ClearWRAM1300()                           # clear the play variables
	call ClearWRAM1300
;> wLinkMotionState = 0
	xor a
	ld [wLinkMotionState], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> hLinkX = wMapEntrancePositionX
	ld a, [wMapEntrancePositionX]
	ldh [hLinkX], a
;> wLinkRespawnX = wMapEntrancePositionX
	ld [wLinkRespawnX], a
;> hLinkY = wMapEntrancePositionY
	ld a, [wMapEntrancePositionY]
	ldh [hLinkY], a
;> wLinkRespawnY = wMapEntrancePositionY
	ld [wLinkRespawnY], a
;> hLinkPositionZ = wWarpTimer
	ld a, [wWarpTimer]
	ldh [hLinkPositionZ], a
;> if hLinkPositionZ:
	and a
	jr z, .onGround
;>     wIsLinkInTheAir = 2
	ld a, $02
	ld [wIsLinkInTheAir], a
.onGround
;> wRoomTransitionDirection = 4          # none
	ld a, $04
	ld [wRoomTransitionDirection], a
;> LoadRoom()
	call LoadRoom
;> LoadRoomEntities()
	call LoadRoomEntities
;> SpawnFollowers()                        # the companions following Link
	call SpawnFollowers
;> hAnimatedTilesFrameCount = 0xFF
	ld a, $ff
	ldh [hAnimatedTilesFrameCount], a
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .tileset
;>@pg     page = wIsIndoor + (1 if 6 <= hMapId < 0x1A else 0)
	ld d, a
	ldh a, [hMapId]
	cp $1a
	jr nc, .page
	cp $06
	jr c, .page
;=@pg
	inc d
.page
;>     kind = GetRoomInfo(page * 0x100 + hMapRoom)     # the room's entry in the table at 14:4500
	ldh a, [hMapRoom]
	ld e, a
	call GetRoomInfo
;>@k     if kind == 0x1A or kind == 0x19 or wRoomEvent & 0xE0 == 0x80:
	cp $1a
	jr z, .keyRoom
	cp $19
	jr z, .keyRoom
;=@k
	ld a, [wRoomEvent]
	and $e0
	cp $80
	jr nz, .tileset
.keyRoom
;>         if wDungeonHasCompass and not hRoomStatus & 0x10:
	ld a, [wDungeonHasCompass]
	and a
	jr z, .tileset
	ldh a, [hRoomStatus]
	and $10
	jr nz, .tileset
;>             wCompassChimeDelay = 0x0C
	ld a, $0c
	ld [wCompassChimeDelay], a
.tileset
;>@ts wTileMapToLoad = 6 if wIsIndoor else 7
	ld a, [wIsIndoor]
	and a
	ld a, $06
	jr nz, .store
	ld a, $07
.store
;=@ts
	ld [wTileMapToLoad], a
	ret


;@ def WorldLoadRoomTiles()
;@ path: world/load
;@ Step 2: loads the tiles of the room's graphics set (hWorldTileset $0F = load anew), clears the
;@ pending tile updates and requests tile set 9; then moves on (falls into IncrementGameplaySubtype).
;@ test: skip loads tiles from another bank
WorldLoadRoomTiles::
;> hWorldTileset = 0x0F
	ld a, $0f
	ldh [hWorldTileset], a
;> LoadRoomTilesets()
	call LoadRoomTilesets
;> hNeedsUpdatingBGTiles = 0
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;> hNeedsUpdatingEnemiesTiles = 0
	ldh [hNeedsUpdatingEnemiesTiles], a
;> wTileMapToLoad = 9
	ld a, $09
	ld [wTileMapToLoad], a
;> IncrementGameplaySubtype()           # falls through into it

;@ def IncrementGameplaySubtype()
;@ path: system/modes
;@ Moves the current game mode on to its next step (wGameplaySubtype + 1).
IncrementGameplaySubtype::
;> wGameplaySubtype += 1
	ld hl, wGameplaySubtype
	inc [hl]
	ret


;@ def WorldLoadTileset()
;@ path: world/load
;@ Step 3: requests tile set 1 (the room objects); if a raised-block change is pending
;@ (mem[0xD6FA]) restarts it, and a pressed floor switch also asks for the background change 3.
WorldLoadTileset::
;> wTileMapToLoad = 1
	ld a, $01
	ld [wTileMapToLoad], a
;> if mem[0xD6FA]:
	ld a, [$d6fa]
	and a
	jr z, .next
;>     wRaisedBlockStep = 5
	ld a, $05
	ld [wRaisedBlockStep], a
;>     if wFloorSwitchPressedTimer:
	ld a, [wFloorSwitchPressedTimer]
	and a
	jr z, .next
;>         hBGChangeRequest = 3
	ld a, $03
	ldh [hBGChangeRequest], a
.next
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldLoadDrawRoom()
;@ path: world/load
;@ Step 4: first part of drawing the room (DrawRupeesAndHeartsFar).
;@ test: skip draws the room through bank 0
WorldLoadDrawRoom::
;> DrawRupeesAndHeartsFar()
	call DrawRupeesAndHeartsFar
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldLoadDrawRoom2()
;@ path: world/load
;@ Step 5: second part of drawing the room (DrawItemSlotsABFar).
;@ test: skip draws the room through bank 0
WorldLoadDrawRoom2::
;> DrawItemSlotsABFar()
	call DrawItemSlotsABFar
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldLoadStartFadeIn()
;@ path: world/load
;@ Step 6: puts the window (the status bar) back and switches it on, keeps Link's motion state in
;@ wSavedLinkMotionState while motion state 4 holds him during the fade in, and starts the fade (skipped, with
;@ fixed palettes, when wRoomHasTorches is set). Ends in bank 2's room start code (SelectAreaMusicFar).
;@ test: skip writes LCDC and calls bank 2
WorldLoadStartFadeIn::
;> ResetWindow()                        # window at the bottom again
	call ResetWindow
;> wLCDControl = rLCDC | 0x20            # window on
	ldh a, [rLCDC]
	or $20
	ld [wLCDControl], a
;> rLCDC = wLCDControl
	ldh [rLCDC], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> wSavedLinkMotionState = wLinkMotionState
	ld a, [wLinkMotionState]
	ld [wSavedLinkMotionState], a
;> wLinkMotionState = 4
	ld a, $04
	ld [wLinkMotionState], a
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> if wRoomHasTorches:
	ld a, [wRoomHasTorches]
	and a
	jr z, .done
;>     wBGPalette = wRoomDarkPalette
	ld a, [wRoomDarkPalette]
	ld [wBGPalette], a
;>     wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;>     wOBJ1Palette = 0xE4
	ld a, $e4
	ld [wOBJ1Palette], a
;>     wTransitionSequenceCounter = 4       # no fade
	ld a, $04
	ld [wTransitionSequenceCounter], a
.done
;> return SelectAreaMusicFar()
	jp SelectAreaMusicFar


;@ path: unused
;@ Seven bytes of code nothing jumps to: `ldh a, [hJoypadPressed]` / `and $90` / `jp z, $45CB` (the `ret`
;@ of ReturnToFileSelect) - it would enter the file menu (EnterFileSelectWithMusic, which follows)
;@ only when A or Start is pressed.
UnusedFileMenuButtonCheck::
	db $f0, $cc, $e6, $90, $ca, $cb, $45

;@ def EnterFileSelectWithMusic(flag: a)
;@ path: menu/fileselect
;@ Enters the file menu like ReturnToFileSelect, but first stores `flag` (non-zero from the intro) in
;@ wFileSelectMusicPending so that the menu starts its music. ReturnToFileSelect (the entry point used
;@ when coming back from the other file menus) reads the name, health, heart containers and death
;@ counter of each of the three files from battery RAM (switched on before every read) and switches
;@ to game mode 2, the file menu, with black palettes and no scroll.
;@ test: skip reads battery RAM
EnterFileSelectWithMusic::
;> wFileSelectMusicPending = flag
	ld [wFileSelectMusicPending], a

ReturnToFileSelect:
;> for slot in range(3):                 # (unrolled; each slot's data is $385 bytes further)
;>@nm     copy(wSaveSlotNames + 5 * slot, 0xA454 + 0x385 * slot, 5)    # the name (wPlayerName)
	call EnableSRAM
	ld a, [$a454]
	ld [wSaveSlotNames], a
	call EnableSRAM
	ld a, [$a455]
	ld [wSaveSlotNames + 1], a
;=@nm
	call EnableSRAM
	ld a, [$a456]
	ld [wSaveSlotNames + 2], a
	call EnableSRAM
	ld a, [$a457]
	ld [wSaveSlotNames + 3], a
;=@nm
	call EnableSRAM
	ld a, [$a458]
	ld [wSaveSlotNames + 4], a
;>@hp     wSaveSlotHealth[slot] = mem[0xA45F + 0x385 * slot]       # (wHealth)
	call EnableSRAM
	ld a, [$a45f]
	ld [wSaveSlotHealth], a
;>@mh     wSaveSlotMaxHearts[slot] = mem[0xA460 + 0x385 * slot]    # (wMaxHearts)
	call EnableSRAM
	ld a, [$a460]
	ld [wSaveSlotMaxHearts], a
;>@dc     copy(wSaveSlotDeathCounts + 2 * slot, 0xA45C + 0x385 * slot, 2)    # (wDeathCount)
	call EnableSRAM
	ld a, [$a45c]
	ld [wSaveSlotDeathCounts], a
	call EnableSRAM
	ld a, [$a45d]
	ld [wSaveSlotDeathCounts + 1], a
;=@nm
	call EnableSRAM
	ld a, [$a7d9]
	ld [wSaveSlotNames + 5], a
	call EnableSRAM
	ld a, [$a7da]
	ld [wSaveSlotNames + 6], a
;=@nm
	call EnableSRAM
	ld a, [$a7db]
	ld [wSaveSlotNames + 7], a
	call EnableSRAM
	ld a, [$a7dc]
	ld [wSaveSlotNames + 8], a
;=@nm
	call EnableSRAM
	ld a, [$a7dd]
	ld [wSaveSlotNames + 9], a
;=@hp
	call EnableSRAM
	ld a, [$a7e4]
	ld [wSaveSlotHealth + 1], a
;=@mh
	call EnableSRAM
	ld a, [$a7e5]
	ld [wSaveSlotMaxHearts + 1], a
;=@dc
	call EnableSRAM
	ld a, [$a7e1]
	ld [wSaveSlotDeathCounts + 2], a
	call EnableSRAM
	ld a, [$a7e2]
	ld [wSaveSlotDeathCounts + 3], a
;=@nm
	call EnableSRAM
	ld a, [$ab5e]
	ld [wSaveSlotNames + 10], a
	call EnableSRAM
	ld a, [$ab5f]
	ld [wSaveSlotNames + 11], a
;=@nm
	call EnableSRAM
	ld a, [$ab60]
	ld [wSaveSlotNames + 12], a
	call EnableSRAM
	ld a, [$ab61]
	ld [wSaveSlotNames + 13], a
;=@nm
	call EnableSRAM
	ld a, [$ab62]
	ld [wSaveSlotNames + 14], a
;=@hp
	call EnableSRAM
	ld a, [$ab69]
	ld [wSaveSlotHealth + 2], a
;=@mh
	call EnableSRAM
	ld a, [$ab6a]
	ld [wSaveSlotMaxHearts + 2], a
;=@dc
	call EnableSRAM
	ld a, [$ab66]
	ld [wSaveSlotDeathCounts + 4], a
	call EnableSRAM
	ld a, [$ab67]
	ld [wSaveSlotDeathCounts + 5], a
;> wGameplayType = 2                     # the file menu
	ld a, $02
	ld [wGameplayType], a
;> wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;> hBaseScrollY = 0
	xor a
	ldh [hBaseScrollY], a
;> hBaseScrollX = 0
	ldh [hBaseScrollX], a
;> wBGPalette = 0
	ld a, $00
	ld [wBGPalette], a
;> wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
	ret


;@ path: save
;@ The inventory of the debug file that InitSaveFiles would write to save slot 1 (never, see there):
;@ 67 bytes copied over the slot's copy of $DB00-$DB42 (wItemB, wItemA, the inventory items 1-12,
;@ wHasFlippers..., and in wDungeonItemFlags map, compass, beak and nightmare key all 1 with 1-9
;@ small keys per dungeon).
DebugSaveData::
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $01, $01, $01, $01
	db $00, $01, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02
	db $01, $01, $01, $01, $03, $01, $01, $01, $01, $04, $01, $01, $01, $01, $05, $01
	db $01, $01, $01, $06, $01, $01, $01, $01, $07, $01, $01, $01, $01, $08, $01, $01
	db $01, $01, $09

;@ def InitSaveFiles()
;@ path: save
;@ Run at power-on: formats each of the three save slots that does not carry the marker bytes. Then,
;@ only if ROM byte $0003 were non-zero (it is 0 in this cartridge, so this never happens), it would
;@ turn slot 1 into a debug file named ZELDA: all items and upgrades, 10 hearts, 509 rupees, every
;@ instrument, all songs, the whole overworld map revealed, starting on the overworld (room $92).
;@ test: skip writes battery RAM
InitSaveFiles::
;> ValidateSaveSlot(0)
	ld de, $0000
	call ValidateSaveSlot
;> ValidateSaveSlot(0x385)
	ld de, $0385
	call ValidateSaveSlot
;> ValidateSaveSlot(0x70A)
	ld de, $070a
	call ValidateSaveSlot
;> if mem[0x0003] == 0:                  # always: the debug file below is never made
	ld a, [$0003]
	and a
;>     return
	jp z, .done
;>@cp for i in range(0x43):
	ld e, $00
	ld d, $00
	ld bc, $a405
.copy
;>     mem[0xA405 + i] = mem[DebugSaveData + i]     # over $DB00-$DB42
	ld hl, DebugSaveData
	add hl, de
	ld a, [hli]
	ld [bc], a
	inc bc
;=@cp
	inc e
	ld a, e
	cp $43
	jr nz, .copy
;> mem[0xA453] = 1                       # wSwordLevel
	ld a, $01
	ld [$a453], a
;> mem[0xA449] = 1                       # wShieldLevel
	ld a, $01
	ld [$a449], a
;> mem[0xA448] = 2                       # wPowerBraceletLevel
	ld a, $02
	ld [$a448], a
;> fill(0xA46A, 2, 9)                    # wDungeonFlags: every instrument obtained
	ld hl, $a46a
	ld e, $09
	ld a, $02
.flags
	ld [hli], a
	dec e
	jr nz, .flags
;> mem[0xA452] = 0x60                    # wBombCount
	ld a, $60
	ld [$a452], a
;> mem[0xA47D] = 0x60                    # wMaxArrows
	ld [$a47d], a
;> mem[0xA47C] = 0x60                    # wMaxBombs
	ld [$a47c], a
;> mem[0xA44A] = 0x60                    # wArrowCount
	ld [$a44a], a
;> mem[0xA47B] = 0x40                    # wMaxMagicPowder
	ld a, $40
	ld [$a47b], a
;> mem[0xA451] = 0x40                    # wMagicPowderCount
	ld [$a451], a
;> mem[0xA44C] = 0x89                    # $DB47
	ld a, $89
	ld [$a44c], a
;> mem[0xA414] = 0                       # $DB0F
	ld a, $00
	ld [$a414], a
;> mem[0xA44E] = 7                       # wOcarinaSongFlags: all three songs
	ld a, $07
	ld [$a44e], a
;> mem[0xA462] = 5                       # wRupeeCountHigh
	ld a, $05
	ld [$a462], a
;> mem[0xA463] = 9                       # wRupeeCountLow: 509 rupees
	ld a, $09
	ld [$a463], a
;> mem[0xA44D] = 1                       # $DB48
	ld a, $01
	ld [$a44d], a
;> mem[0xA45F] = 0x50                    # wHealth: 10 hearts
	ld a, $50
	ld [$a45f], a
;> mem[0xA460] = 10                      # wMaxHearts
	ld a, $0a
	ld [$a460], a
;>@zn copy(0xA454, b"ZELDA", 5)            # wPlayerName (characters $5B $46 $4D $45 $42)
	ld a, $5b
	ld [$a454], a
	ld a, $46
	ld [$a455], a
	ld a, $4d
	ld [$a456], a
;=@zn
	ld a, $45
	ld [$a457], a
	ld a, $42
	ld [$a458], a
;> mem[0xA45C] = 0                       # wDeathCount
	ld a, $00
	ld [$a45c], a
;> mem[0xA45D] = 0
	ld [$a45d], a
;> mem[0xA45B] = 0                       # wIsBowWowFollowingLink
	ld a, $00
	ld [$a45b], a
;> mem[0xA464] = 0                       # wSpawnIsIndoor: the overworld
	ld [$a464], a
;> mem[0xA465] = 0                       # wSpawnMapId
	ld a, $00
	ld [$a465], a
;> mem[0xA466] = 0x92                    # wSpawnRoom
	ld a, $92
	ld [$a466], a
;> mem[0xA467] = 0x48                    # wSpawnX
	ld a, $48
	ld [$a467], a
;> mem[0xA468] = 0x62                    # wSpawnY
	ld a, $62
	ld [$a468], a
;> fill(0xA105, 0x80, 0x100)             # every overworld room visited: the whole map shown
	ld hl, $a105
	ld a, $80
	ld e, $00
.visit
	ld [hli], a
	dec e
	jr nz, .visit
;> return
.done
	ret


;@ def ValidateSaveSlot(offset: de)
;@ path: save
;@ Checks the five marker bytes 1, 3, 5, 7, 9 at the start of a save slot ($A100 + offset; the slots
;@ are at offsets 0, $385 and $70A). If they are missing, writes them and clears the slot's $380 bytes
;@ of data (an empty file).
;@ test: skip reads and writes battery RAM
ValidateSaveSlot::
;>@chk if all(mem[0xA100 + offset + i] == 1 + 2 * i for i in range(5)):
	ld c, $01
	ld b, $05
	ld hl, $a100
	add hl, de
.check
;=@chk
	call EnableSRAM
	ld a, [hli]
	cp c
	jr nz, .format
;=@chk
	inc c
	inc c
	dec b
	jr nz, .check
;>     return
	jr .done
.format
;>@mk for i in range(5): mem[0xA100 + offset + i] = 1 + 2 * i
	ld hl, $a100
	add hl, de
	ld a, $01
.mark
	call EnableSRAM
	ld [hli], a
	inc a
;=@mk
	inc a
	cp $0b
	jr c, .mark
;>@cl fill(0xA105 + offset, 0, 0x380)
	ld de, $0380
.clear
	call EnableSRAM
	xor a
	ld [hli], a
	dec de
	ld a, e
;=@cl
	or d
	jr nz, .clear
.done
	ret


;@ def GameplayFileSelectHandler()
;@ path: menu/fileselect
;@ Game mode 2, the file menu (choose one of three save files, or copy / erase): notes which files
;@ exist, then runs the current step of FileSelectSteps.
;@ test: skip jumps through a table
GameplayFileSelectHandler::
;> UpdateSaveFilesExist()
	call UpdateSaveFilesExist
;> return FileSelectSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/fileselect
;@ The steps of the file menu (dw per value of wGameplaySubtype): 0-1 load the tiles, 2-3 draw the
;@ hearts of the files, 4 the death counters, 5 the names, 6 show the screen, 7 the menu, 8 act on the
;@ choice, 9 start the game.
FileSelectSteps::
	dw FileSelectInit
	dw FileSelectLoadTiles
	dw FileSelectDrawHearts12
	dw FileSelectDrawHearts3
	dw FileSelectDrawDeathCounts
	dw FileSelectDrawNames
	dw FileSelectShowScreen
	dw FileSelectMenu
	dw FileSelectChoose
	dw FileSelectStartGame

;@ def FileSelectInit()
;@ path: menu/fileselect
;@ Step 0: requests tile set 4 and sets the bottom-row choice (wEntityWorkRAM: 0 left, 1 right) to the left.
FileSelectInit::
;> wTileMapToLoad = 4
	ld a, $04
	ld [wTileMapToLoad], a
;> wEntityWorkRAM[0] = 0                   # bottom-row choice
	xor a
	ld [wEntityWorkRAM], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileSelectLoadTiles()
;@ path: menu/fileselect
;@ Step 1: requests tile set 8.
FileSelectLoadTiles::
;> wTileMapToLoad = 8
	ld a, $08
	ld [wTileMapToLoad], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileSelectDrawHearts12()
;@ path: menu/fileselect
;@ Step 2: queues the hearts of files 1 and 2.
;@ test: skip queues draw commands
FileSelectDrawHearts12::
;> DrawFileHearts1()
	call DrawFileHearts1
;> DrawFileHearts2()
	call DrawFileHearts2
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileSelectDrawHearts3()
;@ path: menu/fileselect
;@ Step 3: queues the hearts of file 3.
;@ test: skip queues draw commands
FileSelectDrawHearts3::
;> DrawFileHearts3()
	call DrawFileHearts3
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileSelectDrawDeathCounts()
;@ path: menu/fileselect
;@ Step 4: queues the death counter of each existing file (3 digits, at $98E7, $9947, $99A7: right of
;@ each file's line).
;@ test: skip queues draw commands
FileSelectDrawDeathCounts::
;> if wSaveFilesExist & 1:
	ld a, [wSaveFilesExist]
	and $01
	jr z, .file2
;>     DrawDeathCount(wSaveSlotDeathCounts[0] << 8 | wSaveSlotDeathCounts[1], 0x98E7)
	ld a, [wSaveSlotDeathCounts]
	ld h, a
	ld a, [wSaveSlotDeathCounts + 1]
	ld l, a
	ld de, $98e7
	call DrawDeathCount
.file2
;> if wSaveFilesExist & 2:
	ld a, [wSaveFilesExist]
	and $02
	jr z, .file3
;>     DrawDeathCount(wSaveSlotDeathCounts[2] << 8 | wSaveSlotDeathCounts[3], 0x9947)
	ld a, [wSaveSlotDeathCounts + 2]
	ld h, a
	ld a, [wSaveSlotDeathCounts + 3]
	ld l, a
	ld de, $9947
	call DrawDeathCount
.file3
;> if wSaveFilesExist & 4:
	ld a, [wSaveFilesExist]
	and $04
	jr z, .next
;>     DrawDeathCount(wSaveSlotDeathCounts[4] << 8 | wSaveSlotDeathCounts[5], 0x99A7)
	ld a, [wSaveSlotDeathCounts + 4]
	ld h, a
	ld a, [wSaveSlotDeathCounts + 5]
	ld l, a
	ld de, $99a7
	call DrawDeathCount
.next
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
	db $c9                              ; an unreachable `ret`

;@ def FileSelectDrawNames()
;@ path: menu/fileselect
;@ Step 5: queues the three file names (DrawAllFileNames, which also moves on).
;@ test: skip queues draw commands
FileSelectDrawNames::
;> return DrawAllFileNames()
	jp DrawAllFileNames


;@ def DrawFileName(pos: bc, name: de)
;@ path: menu/fileselect
;@ Queues two background draw commands for a 5-letter file name: the letters at VRAM address `pos`
;@ (character 0 = blank tile $7E, others through the font table of bank $1C) and a row of blank
;@ tiles in the line above (the place of the Japanese version's voicing marks; the code that drew them
;@ is still there but jumped over).
;@ test: skip reads the font table in another bank
DrawFileName::
;> cmd = wDrawCommand + wDrawCommandsSize
	push de
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
;> wDrawCommandsSize += 0x10
	add $10
	ld [wDrawCommandsSize], a
;> mem[cmd:cmd + 3] = [hi(pos), lo(pos), 0x04]     # 5 tiles across
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, $04
	ld [hli], a
;>@l for i in range(5):
	pop de
	push de
	ld a, $05
.letter
	ldh [hMultiPurpose0], a
;>@t     mem[cmd + 3 + i] = 0x7E if mem[name + i] == 0 else GetNameCharTile(mem[name + i] - 1)
	ld a, [de]
	and a
	ld a, $7e
	jr z, .put
	ld a, [de]
	dec a
;=@t
	push bc
	push hl
	ld c, a
	ld b, $00
	call GetNameCharTile
	pop hl
;=@t
	pop bc
.put
	ld [hli], a
;=@l
	inc de
	ldh a, [hMultiPurpose0]
	dec a
	jr nz, .letter
;>@a mem[cmd + 8:cmd + 11] = [hi(pos), lo(pos - 0x20), 0x04]    # the line above
	ld a, b
	ld [hli], a
	ld a, c
	sub $20
	ld [hli], a
	ld a, $04
;=@a
	ld [hli], a
;>@f fill(cmd + 11, 0x7E, 5)
	pop de
	ld a, $05
.mark
	ldh [hMultiPurpose0], a
	ld a, [de]
	and a
	jr .blank
	db $3d, $e6, $c0                    ; (skipped)
.blank
;=@f
	ld a, $7e
	jr .putMark
	db $1a, $e6, $80, $3e, $c8, $28, $01, $3c    ; (skipped)
.putMark
	ld [hli], a
	inc de
;=@f
	ldh a, [hMultiPurpose0]
	dec a
	jr nz, .mark
;> mem[cmd + 16] = 0                    # end of the queue
	xor a
	ld [hl], a
	ret


;@ def FileSelectShowScreen()
;@ path: menu/fileselect
;@ Step 6: starts the file menu music if it is pending, requests the file menu screen (layout 3 when no
;@ file exists, 4 with the copy / erase row) and sets the normal palettes.
FileSelectShowScreen::
;> if wFileSelectMusicPending:
	ld a, [wFileSelectMusicPending]
	and a
	jr z, .screen
;>     wFileSelectMusicPending = 0
	xor a
	ld [wFileSelectMusicPending], a
;>     wMusicTrackToPlay = 0x11
	ld a, $11
	ld [wMusicTrackToPlay], a
.screen
;>@s wBGMapToLoad = 4 if wSaveFilesExist else 3
	ld a, [wSaveFilesExist]
	and a
	ld a, $03
	jr z, .store
	ld a, $04
.store
;=@s
	ld [wBGMapToLoad], a
;> wBGPalette = 0xE4
	ld a, $e4
	ld [wBGPalette], a
;> wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0xE4
	ld a, $e4
	ld [wOBJ1Palette], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ path: menu/fileselect
;@ Sprite y position of the file menu's fairy cursor for each row (wSaveSlot 0-3: files 1-3, then the
;@ copy / erase row), one byte each. Also used by the copy and erase menus.
FileSelectCursorY::
	db $3b, $53, $6b, $83

;@ def FileSelectMenu()
;@ path: menu/fileselect
;@ Step 7: A or Start chooses (next step). Up / Down / Select move the fairy through the three files and,
;@ when a file exists, the bottom row, wrapping around. On the bottom row Left / Right switch between
;@ its two choices (wEntityWorkRAM), shown by a blinking arrow. Then draws the fairy.
;@ test: skip draws sprites through other routines
FileSelectMenu::
;> PlayCursorSoundOnMove()
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x90:             # A, Start
	ldh a, [hJoypadPressed]
	and $90
	jr z, .move
;>     return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
.move
;> if hJoypadPressed & 0x4C:             # Up, Down, Select
	ldh a, [hJoypadPressed]
	and $4c
	jr z, .row
;>     last = 3 if wSaveFilesExist else 2
	ld c, $02
	ld a, [wSaveFilesExist]
	and a
	jr z, .last
	inc c
.last
;>     if hJoypadPressed & 0x40 or not hJoypadPressed & 0x04:     # Select or Down
	ldh a, [hJoypadPressed]
	bit 6, a
	jr nz, .down
	bit 2, a
	jr nz, .up
.down
;>@d         wSaveSlot = wSaveSlot + 1 if wSaveSlot < last else 0
	ld a, [wSaveSlot]
	add $01
	inc c
	cp c
	jr c, .store
	xor a
;=@d
	jr .store
;>     else:
.up
;>         wSaveSlot = wSaveSlot - 1 if wSaveSlot > 0 else last
	ld a, [wSaveSlot]
	sub $01
	jr nc, .store
	ld a, c
.store
	ld [wSaveSlot], a
.row
;> if wSaveSlot == 3:                    # the copy / erase row
	ld a, [wSaveSlot]
	cp $03
	jr nz, DrawFileSelectCursor
;>     if hJoypadPressed & 0x03:         # Right, Left
	ldh a, [hJoypadPressed]
	and $03
	jr z, .blink
;>         PlayCursorSound()
	call PlayCursorSound
;>         wEntityWorkRAM[0] ^= 1
	ld a, [wEntityWorkRAM]
	xor $01
	ld [wEntityWorkRAM], a
.blink
;>     if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr nz, DrawFileSelectCursor
;>         x = 0x64 if wEntityWorkRAM[0] else 0x2C
	ld a, [wEntityWorkRAM]
	and a
	ld a, $2c
	jr z, .arrow
	ld a, $64
.arrow
;>@o         wOAMBuffer[8:12] = [0x88, x, 0xBE, 0]     # OAM entry 2: the arrow
	ld hl, wOAMBuffer + 8
	ld [hl], $88
	inc hl
	ld [hli], a
	ld a, $be
	ld [hli], a
;=@o
	xor a
	ld [hl], a
;> DrawFileSelectCursor()               # falls through into it

;@ def DrawFileSelectCursor()
;@ path: menu/fileselect
;@ Puts the fairy cursor (two sprites, tiles 0 and 2, at x $18 and $20) on the row of wSaveSlot in OAM
;@ entries 0-1; every 8 frames it is drawn mirrored, which makes its wings flap.
DrawFileSelectCursor::
;>@y y = mem[FileSelectCursorY + wSaveSlot]
	ld a, [wSaveSlot]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
;> if hFrameCounter & 0x08:
	ldh a, [hFrameCounter]
	and $08
	jr z, .mirrored
;>@a     wOAMBuffer[0:4] = [y, 0x18, 0x00, 0x00]
	ld a, [hl]
	ld hl, wOAMBuffer
	push af
	ld [hli], a
	ld a, $18
	ld [hli], a
;=@a
	ld a, $00
	ld [hli], a
	ld a, $00
	ld [hli], a
;>@b     wOAMBuffer[4:8] = [y, 0x20, 0x02, 0x00]
	pop af
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $02
	ld [hli], a
;=@b
	ld a, $00
	ld [hl], a
	ret
;> else:
.mirrored
;>@c     wOAMBuffer[0:4] = [y, 0x18, 0x02, 0x20]   # x-flipped
	ld a, [hl]
	ld hl, wOAMBuffer
	push af
	ld [hli], a
	ld a, $18
	ld [hli], a
;=@c
	ld a, $02
	ld [hli], a
	ld a, $20
	ld [hli], a
;>@e     wOAMBuffer[4:8] = [y, 0x20, 0x00, 0x20]
	pop af
	ld [hli], a
	ld a, $20
	ld [hli], a
	ld a, $00
	ld [hli], a
;=@e
	ld a, $20
	ld [hl], a
	ret


;@ def FileSelectChoose()
;@ path: menu/fileselect
;@ Step 8: acts on the choice. The bottom row goes to the erase or copy menu
;@ (FileSelectChooseBottomRow); an existing file is loaded (FileSelectLoadChosen); an empty file
;@ starts the name entry (game mode 3). Falls into PlayConfirmSound.
;@ test: skip jumps between units
FileSelectChoose::
;> if wSaveSlot == 3:
	ld a, [wSaveSlot]
	cp $03
;>     return FileSelectChooseBottomRow()
	jr z, FileSelectChooseBottomRow
;>@n name = wSaveSlotNames + wSaveSlot * 5
	ld a, [wSaveSlot]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
;=@n
	ld d, $00
	ld c, $05
	ld hl, wSaveSlotNames
	add hl, de
.check
;> if any(mem[name + i] for i in range(5)):
	ld a, [hli]
	and a
	jr nz, FileSelectLoadChosen
	dec c
	jr nz, .check
;>     return FileSelectLoadChosen()
;> wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;> wGameplayType = 3                     # name entry for a new file
	ld a, $03
	ld [wGameplayType], a
;> PlayConfirmSound()                    # falls through into it

;@ def PlayConfirmSound()
;@ path: menu/fileselect
;@ Plays the menu confirm sound (square channel effect $13).
PlayConfirmSound::
;> hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
	ret


;@ def FileSelectLoadChosen()
;@ path: menu/fileselect
;@ The chosen file exists: confirm sound, black palettes, tile set 5, then step 9 starts the game.
FileSelectLoadChosen::
;> PlayConfirmSound()
	call PlayConfirmSound
;> wBGPalette = 0
	ld a, $00
	ld [wBGPalette], a
;> wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> wTileMapToLoad = 5
	ld a, $05
	ld [wTileMapToLoad], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileSelectChooseBottomRow()
;@ path: menu/fileselect
;@ The copy / erase row: the left choice opens the erase menu (game mode 4), the right one the copy
;@ menu (game mode 5).
FileSelectChooseBottomRow::
;> wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;>@t wGameplayType = 5 if wEntityWorkRAM[0] else 4
	ld a, [wEntityWorkRAM]
	and a
	ld a, $04
	jr z, .store
	ld a, $05
.store
;=@t
	ld [wGameplayType], a
;> PlayConfirmSound()
	jp PlayConfirmSound


;@ path: save
;@ Battery RAM address of each save slot's copy of $DB00 (the inventory and progress part, where the
;@ name is at +$4F): one dw per slot 1-3. Used by the name entry to fill in a new file.
SaveSlotStateAddresses::
	dw $a405, $a78a, $ab0f

;@ path: save
;@ Battery RAM address of each save slot's data (the $380 bytes that are copied to and from
;@ $D800-$DB7F): one dw per slot 1-3.
SaveSlotDataAddresses::
	dw $a105, $a48a, $a80f

;@ path: save
;@ Battery RAM address of each whole save slot (the 5 marker bytes 1, 3, 5, 7, 9, then its data):
;@ one dw per slot 1-3. Used by the copy menu ($385 bytes per slot).
SaveSlotAddresses::
	dw $a100, $a485, $a80a

;@ def FileSelectStartGame()
;@ path: menu/fileselect
;@ Step 9: starts playing the chosen file.
;@ test: skip starts the game
FileSelectStartGame::
;> return StartGameplay()
	jp StartGameplay


;@ def GameplayFileNewHandler()
;@ path: menu/nameentry
;@ Game mode 3, entering the name of a new file: runs the current step of FileNewSteps.
;@ test: skip jumps through a table
GameplayFileNewHandler::
;> return FileNewSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/nameentry
;@ The steps of the name entry (dw per value of wGameplaySubtype): 0 load the tiles, 1 draw the screen,
;@ 2 enter the name.
FileNewSteps::
	dw FileNewInit
	dw FileNewLoadScreen
	dw FileNewNameEntry

;@ def FileNewInit()
;@ path: menu/nameentry
;@ Step 0: requests tile set 8 and puts both cursors at the start.
FileNewInit::
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> wTileMapToLoad = 8
	ld a, $08
	ld [wTileMapToLoad], a
;> mem[0xDBA8] = 0
	xor a
	ld [$dba8], a
;> wNameEntryCursor = 0
	ld [wNameEntryCursor], a
;> wNameEntryPosition = 0
	ld [wNameEntryPosition], a
	ret


;@ def FileNewLoadScreen()
;@ path: menu/nameentry
;@ Step 1: requests the name entry screen (layout 5) and queues the file's number (tile $AB + slot)
;@ at $9848.
FileNewLoadScreen::
;> wBGMapToLoad = 5
	ld a, $05
	ld [wBGMapToLoad], a
;>@c wDrawCommand[0:3] = [0x98, 0x48, 0x00]          # one tile at $9848
	ld hl, wDrawCommand
	ld a, $98
	ld [hli], a
	ld a, $48
	ld [hli], a
;=@c
	xor a
	ld [hli], a
;> wDrawCommand[3] = 0xAB + wSaveSlot             # the digit 1-3
	ld a, [wSaveSlot]
	add $ab
	ld [hli], a
;> wDrawCommand[4] = 0                            # end
	xor a
	ld [hl], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ path: menu/nameentry
;@ Offset of each save file's name in wSaveSlotNames (slots 1-3, one byte each: 0, 5, 10).
FileSlotNameOffsets::
	db $00, $05, $0a

;@ def FileNewNameEntry()
;@ path: menu/nameentry
;@ Step 2: shows the name as typed so far; the cursor moves over the letter grid and A / B type and
;@ delete. Start accepts: the name goes to battery RAM with 3 hearts and no deaths, and the file menu
;@ comes back. A file named ZELDA starts a special tune (track $60).
;@ test: skip writes battery RAM
FileNewNameEntry::
;>@nm name = wSaveSlotNames + mem[FileSlotNameOffsets + wSaveSlot]
	ld a, [wSaveSlot]
	ld e, a
	ld d, $00
	ld hl, FileSlotNameOffsets
	add hl, de
	ld e, [hl]
;=@nm
	ld hl, wSaveSlotNames
	add hl, de
	push hl
	pop de
;> DrawFileName(0x9849, name)
	ld bc, $9849
	call DrawFileName
;> if not hJoypadPressed & 0x80:         # Start
	ldh a, [hJoypadPressed]
	and $80
	jr z, .typing
;>@t1     NameEntryMoveCursor()
;>@t2     NameEntryInput()
;>@t3     return
;> PlayConfirmSound()
	call PlayConfirmSound
;>@st state = mem16[SaveSlotStateAddresses + 2 * wSaveSlot]   # the slot's copy of $DB00
	ld a, [wSaveSlot]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotStateAddresses
	add hl, de
;=@st
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
;> dest = state + 0x4F                  # wPlayerName
	ld de, $004f
	add hl, de
	push hl
;>@n2 name = wSaveSlotNames + wSaveSlot * 5
	ld a, [wSaveSlot]
	ld e, a
	sla a
	sla a
	add e
	ld e, a
;=@n2
	ld d, $00
	ld hl, wSaveSlotNames
	add hl, de
;>@z if mem[name:name + 5] == b"ZELDA":        # characters $5B $46 $4D $45 $42
	ld a, [hli]
	cp $5b
	jr nz, .copy
	ld a, [hli]
	cp $46
	jr nz, .copy
;=@z
	ld a, [hli]
	cp $4d
	jr nz, .copy
	ld a, [hli]
	cp $45
	jr nz, .copy
;=@z
	ld a, [hli]
	cp $42
	jr nz, .copy
;>     wMusicTrackToPlay = 0x60
	ld a, $60
	ld [wMusicTrackToPlay], a
.copy
;>@cp copy(dest, name, 5)               # (battery RAM switched on for each byte)
	ld hl, wSaveSlotNames
	add hl, de
	pop bc
	ld e, $05
.copyLoop
	call EnableSRAM
	ld a, [hli]
;=@cp
	ld [bc], a
	inc bc
	dec e
	jr nz, .copyLoop
;> mem[state + 0x5A] = 0x18             # wHealth: 3 hearts
	pop hl
	push hl
	ld de, $005a
	add hl, de
	ld [hl], $18
;> mem[state + 0x5B] = 3                # wMaxHearts
	pop hl
	push hl
	ld de, $005b
	add hl, de
	ld [hl], $03
;> mem[state + 0x57] = 0                # wDeathCount
	pop hl
	ld de, $0057
	add hl, de
	xor a
	ld [hli], a
;> mem[state + 0x58] = 0
	ld [hl], a
;> return ReturnToFileSelect()
	jp ReturnToFileSelect

.typing
;=@t1
	call NameEntryMoveCursor
;=@t2
	call NameEntryInput
;=@t3
	ret


;@ path: menu/nameentry
;@ Sprite y position of the letter cursor for each of the 64 places of the letter grid (wNameEntryCursor
;@ 0-63: 4 rows of 16; one byte each, $38/$48/$58/$68).
NameEntryCursorY::
	db $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
	db $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48
	db $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58, $58
	db $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68, $68
;@ path: menu/nameentry
;@ Sprite x position of the letter cursor for each of the 64 places of the letter grid (one byte each:
;@ $14 to $8C in steps of 8, the same for each row).
NameEntryCursorX::
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
	db $14, $1c, $24, $2c, $34, $3c, $44, $4c, $54, $5c, $64, $6c, $74, $7c, $84, $8c
;@ path: menu/nameentry
;@ Sprite x position of the marker under the name for each letter position (wNameEntryPosition 0-4).
NameEntryNameCursorX::
	db $4c, $54, $5c, $64, $6c

;@ path: menu/nameentry
;@ The character each of the 64 places of the letter grid types into the name (4 rows of 16, one byte
;@ each; 0 = nothing, a place without a letter). Name characters: A-Z = $42-$5B, a-z = $62-$7B.
NameEntryCharacters::
	db $42, $43, $44, $45, $46, $47, $48, $00, $00, $62, $63
	db $64, $65, $66, $67, $68, $49, $4a, $4b, $4c, $4d, $4e, $4f, $00, $00, $69, $6a
	db $6b, $6c, $6d, $6e, $6f, $50, $51, $52, $53, $54, $55, $56, $00, $00, $70, $71
	db $72, $73, $74, $75, $76, $57, $58, $59, $5a, $5b, $00, $00, $00, $00, $77, $78
	db $79, $7a, $7b, $00, $00

;@ def NameEntryMoveCursor()
;@ path: menu/nameentry
;@ Moves the letter cursor over the 4 x 16 grid with the D-pad (wrapping around; a held direction
;@ repeats after $18 frames, then every 3 frames) and puts the cursor sprite (tile $E0) in OAM entry 0.
;@ test: skip loops on the held keys
NameEntryMoveCursor::
;> keys = hJoypadPressed
	ldh a, [hJoypadPressed]
.keys
;>@w while True:                        # (goes round again only for a repeating held key)
	ldh [hMultiPurpose0], a
;>     if keys & 0x0C:                   # Up, Down
;>@ud1         PlayCursorSound()
;>@ud2         wNameEntryCursor = (wNameEntryCursor + (-16 if keys & 0x04 else 16)) % 64
;>@ud3         break
	ldh a, [hMultiPurpose0]
	and $0c
	jr nz, .upDown
;>     if keys & 0x03:                   # Right, Left
;>@lr1         PlayCursorSound()
;>@lr2         wNameEntryCursor = (wNameEntryCursor + (-1 if keys & 0x02 else 1)) % 64
;>@lr3         break
	ldh a, [hMultiPurpose0]
	and $03
	jr nz, .leftRight
;>     if not hJoypadHeld & 0x0F:
	ldh a, [hJoypadHeld]
	ld hl, wDpadRepeatCounter
	and $0f
	jr nz, .held
;>         wDpadRepeatCounter = 0
	xor a
	ld [hl], a
;>         break
	jr .done
.held
;>     wDpadRepeatCounter += 1
	ld a, [hl]
	inc a
	ld [hl], a
;>     if wDpadRepeatCounter != 0x18:
	cp $18
;>         break
	jr nz, .done
;>     wDpadRepeatCounter = 0x15         # from now on every 3 frames
	ld [hl], $15
;>     keys = hJoypadHeld                # treat the held keys as pressed
	ldh a, [hJoypadHeld]
;=@w
	jr .keys
.done
	jr .draw
.leftRight
;=@lr1
	call PlayCursorSound
;=@lr2
	bit 1, a
	jr nz, .left
	ld a, [wNameEntryCursor]
	add $01
	cp $40
	jr c, .store
;=@lr2
	xor a
	jr .store
.left
;=@lr2
	ld a, [wNameEntryCursor]
	sub $01
	cp $ff
	jr nz, .store
	ld a, $3f
	jr .store
.upDown
;=@ud1
	call PlayCursorSound
;=@ud2
	bit 2, a
	jr z, .down
	ld a, [wNameEntryCursor]
	sub $10
	jr nc, .store
	add $40
;=@ud2
	jr .store
.down
;=@ud2
	ld a, [wNameEntryCursor]
	add $10
	cp $40
	jr c, .store
	sub $40
.store
;=@ud2
	ld [wNameEntryCursor], a
;=@ud3
	jr .draw
.draw
;>@x x = mem[NameEntryCursorX + wNameEntryCursor]
	ld a, [wNameEntryCursor]
	ld hl, NameEntryCursorX
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
;>@y y = mem[NameEntryCursorY + wNameEntryCursor]
	ld a, [wNameEntryCursor]
	ld hl, NameEntryCursorY
	ld c, a
	ld b, $00
	add hl, bc
	ld d, [hl]
;>@o wOAMBuffer[0:4] = [y + 0x0B, x + 4, 0xE0, 0]
	ld hl, wOAMBuffer
	ld a, d
	add $0b
	ld [hli], a
	ld a, e
	add $04
;=@o
	ld [hli], a
	ld a, $e0
	ld [hli], a
	xor a
	ld [hl], a
	ret


;@ def NameEntryInput()
;@ path: menu/nameentry
;@ A types the letter under the cursor at the current name position and moves on (up to position 4);
;@ B moves back (down to 0). The marker under the name (tile $E0, OAM entry 1) blinks at the position.
;@ test: wSaveSlot = rand(0, 2); wNameEntryPosition = rand(0, 4)
NameEntryInput::
;> if hJoypadPressed & 0x30:             # A, B
	ldh a, [hJoypadPressed]
	and $30
	jr z, .marker
;>     if not hJoypadPressed & 0x20:     # A
	bit 5, a
	jr nz, .back
;>         PlayConfirmSound()
	call PlayConfirmSound
;>         NameEntryWriteLetter()
	call NameEntryWriteLetter
;>@a         wNameEntryPosition = min(wNameEntryPosition + 1, 4)
	ld a, [wNameEntryPosition]
	add $01
	cp $05
	jr c, .store
	ld a, $04
;=@a
	jr .store
;>     else:                             # B
.back
;>         PlayConfirmSound()
	call PlayConfirmSound
;>@b         wNameEntryPosition = max(wNameEntryPosition - 1, 0)
	ld a, [wNameEntryPosition]
	sub $01
	cp $ff
	jr nz, .store
	xor a
.store
;=@b
	ld [wNameEntryPosition], a
.marker
;>@x x = mem[NameEntryNameCursorX + wNameEntryPosition]
	ld a, [wNameEntryPosition]
	ld hl, NameEntryNameCursorX
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
;> if hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr z, .done
;>@o     wOAMBuffer[4:8] = [0x18 + 0x0B, x + 4, 0xE0, 0]
	ld hl, wOAMBuffer + 4
	ld a, $18
	add $0b
	ld [hli], a
	ld a, e
	add $04
;=@o
	ld [hli], a
	ld a, $e0
	ld [hli], a
	xor a
	ld [hl], a
.done
	ret


;@ def NameEntryWriteLetter()
;@ path: menu/nameentry
;@ Writes the character of the grid place under the cursor (NameEntryCharacters) into the new file's
;@ name at wNameEntryPosition.
;@ test: wSaveSlot = rand(0, 2); wNameEntryPosition = rand(0, 4)
NameEntryWriteLetter::
;>@c char = mem[NameEntryCharacters + wNameEntryCursor]
	ld a, [wNameEntryCursor]
	ld c, a
	ld b, $00
	ld hl, NameEntryCharacters
	add hl, bc
	ld a, [hl]
;=@c
	ld e, a
;>@w wSaveSlotNames[wSaveSlot * 5 + wNameEntryPosition] = char
	ld a, [wSaveSlot]
	ld c, a
	sla a
	sla a
	add c
	ld c, a
;=@w
	ld hl, wSaveSlotNames
	add hl, bc
	ld a, [wNameEntryPosition]
	ld c, a
	add hl, bc
;=@w
	ld [hl], e
	ret


;@ def GameplayFileDeleteHandler()
;@ path: menu/erase
;@ Game mode 4, the erase menu: notes which files exist, then runs the current step of FileDeleteSteps.
;@ test: skip jumps through a table
GameplayFileDeleteHandler::
;> UpdateSaveFilesExist()
	call UpdateSaveFilesExist
;> return FileDeleteSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/erase
;@ The steps of the erase menu (dw per value of wGameplaySubtype): 0 tiles, 1 screen, 2 names, 3-4 hearts,
;@ 5 death counters, 6 choose a file, 7 confirm.
FileDeleteSteps::
	dw FileDeleteInit
	dw FileDeleteLoadScreen
	dw DrawAllFileNames
	dw FileDeleteDrawHearts
	dw FileDeleteDrawHearts3
	dw FileDeleteDrawDeaths
	dw FileDeleteSelect
	dw FileDeleteConfirm

;@ def FileDeleteInit()
;@ path: menu/erase
;@ Step 0: requests tile set 8 and puts the cursor on file 1 and the QUIT / OK choice on QUIT.
FileDeleteInit::
;> wTileMapToLoad = 8
	ld a, $08
	ld [wTileMapToLoad], a
;> wSaveSlot = 0
	xor a
	ld [wSaveSlot], a
;> wEntityWorkRAM[0] = 0                    # 0 QUIT, 1 OK
	ld [wEntityWorkRAM], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileDeleteLoadScreen()
;@ path: menu/erase
;@ Step 1: requests the erase menu screen (layout 6).
FileDeleteLoadScreen::
;> wBGMapToLoad = 6
	ld a, $06
	ld [wBGMapToLoad], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def DrawAllFileNames()
;@ path: menu/fileselect
;@ Queues the names of the three files (at $98C5, $9925, $9985) and moves on to the next step.
;@ test: skip queues draw commands through the font table
DrawAllFileNames::
;> DrawFileName1()
	call DrawFileName1
;> DrawFileName2()
	call DrawFileName2
;> DrawFileName3()
	call DrawFileName3
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def FileDeleteDrawHearts()
;@ path: menu/erase
;@ Step 3: queues the hearts of files 1 and 2.
;@ test: skip queues draw commands
FileDeleteDrawHearts::
;> DrawFileHearts1()
	call DrawFileHearts1
;> DrawFileHearts2()
	call DrawFileHearts2
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileDeleteDrawHearts3()
;@ path: menu/erase
;@ Step 4: queues the hearts of file 3.
;@ test: skip queues draw commands
FileDeleteDrawHearts3::
;> DrawFileHearts3()
	call DrawFileHearts3
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileDeleteDrawDeaths()
;@ path: menu/erase
;@ Step 5: queues the death counters (the file menu's routine, which also moves on).
;@ test: skip queues draw commands
FileDeleteDrawDeaths::
;> return FileSelectDrawDeathCounts()
	jp FileSelectDrawDeathCounts

;@ def DrawFileName1()
;@ path: menu/fileselect
;@ Queues the name of file 1 at $98C5.
;@ test: skip reads the font table in another bank
DrawFileName1::
;> return DrawFileName(0x98C5, wSaveSlotNames)
	ld bc, $98c5
	ld de, wSaveSlotNames
	jp DrawFileName


;@ def DrawFileName2()
;@ path: menu/fileselect
;@ Queues the name of file 2 at $9925.
;@ test: skip reads the font table in another bank
DrawFileName2::
;> return DrawFileName(0x9925, wSaveSlotNames + 5)
	ld bc, $9925
	ld de, wSaveSlotNames + 5
	jp DrawFileName


;@ def DrawFileName3()
;@ path: menu/fileselect
;@ Queues the name of file 3 at $9985.
;@ test: skip reads the font table in another bank
DrawFileName3::
;> return DrawFileName(0x9985, wSaveSlotNames + 10)
	ld bc, $9985
	ld de, wSaveSlotNames + 10
	jp DrawFileName


;@ def DrawFileHearts1()
;@ path: menu/fileselect
;@ If file 1 exists, queues its row of hearts (DrawFileHearts with the row in hMultiPurpose4, the health
;@ in hMultiPurpose2 and the heart containers in hMultiPurpose3).
;@ test: skip queues draw commands
DrawFileHearts1::
;> if not wSaveFilesExist & 1:
	ld a, [wSaveFilesExist]
	and $01
;>     return
	jr z, .done
;> hMultiPurpose4 = 0
	ld a, $00
	ldh [hMultiPurpose4], a
;> hMultiPurpose2 = wSaveSlotHealth[0]
	ld a, [wSaveSlotHealth]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = wSaveSlotMaxHearts[0]
	ld a, [wSaveSlotMaxHearts]
	ldh [hMultiPurpose3], a
;> return DrawFileHearts()
	jp DrawFileHearts
.done
	ret


;@ def DrawFileHearts2()
;@ path: menu/fileselect
;@ If file 2 exists, queues its row of hearts.
;@ test: skip queues draw commands
DrawFileHearts2::
;> if not wSaveFilesExist & 2:
	ld a, [wSaveFilesExist]
	and $02
;>     return
	jr z, DrawFileHearts1.done
;> hMultiPurpose4 = 1
	ld a, $01
	ldh [hMultiPurpose4], a
;> hMultiPurpose2 = wSaveSlotHealth[1]
	ld a, [wSaveSlotHealth + 1]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = wSaveSlotMaxHearts[1]
	ld a, [wSaveSlotMaxHearts + 1]
	ldh [hMultiPurpose3], a
;> return DrawFileHearts()
	jp DrawFileHearts


;@ def DrawFileHearts3()
;@ path: menu/fileselect
;@ If file 3 exists, queues its row of hearts.
;@ test: skip queues draw commands
DrawFileHearts3::
;> if not wSaveFilesExist & 4:
	ld a, [wSaveFilesExist]
	and $04
;>     return
	jr z, DrawFileHearts1.done
;> hMultiPurpose4 = 2
	ld a, $02
	ldh [hMultiPurpose4], a
;> hMultiPurpose2 = wSaveSlotHealth[2]
	ld a, [wSaveSlotHealth + 2]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = wSaveSlotMaxHearts[2]
	ld a, [wSaveSlotMaxHearts + 2]
	ldh [hMultiPurpose3], a
;> return DrawFileHearts()
	jp DrawFileHearts


;@ path: menu/fileselect
;@ Background draw commands that blank out each file's name (to make the chosen one blink): 3 records
;@ of 8 bytes, one per file: two commands of 4 bytes each = VRAM address (high, low), $44 (bit 6:
;@ repeat one tile, 5 tiles), tile $7E (blank). The first blanks the line above the name
;@ ($98A5/$9905/$9965), the second the name itself ($98C5/$9925/$9985).
FileNameBlanks::
	db $98, $a5, $44, $7e, $98, $c5, $44, $7e
	db $99, $05, $44, $7e, $99, $25, $44, $7e
	db $99, $65, $44, $7e, $99, $85, $44, $7e

;@ def FileDeleteSelect()
;@ path: menu/erase
;@ Step 6: Up / Down / Select move the fairy over the three files and the bottom row (wrapping).
;@ A or Start on the bottom row (RETURN TO MENU) goes back to the file menu; on a file it asks for
;@ confirmation: next step, with QUIT / OK on the bottom line.
;@ test: skip queues draw commands
FileDeleteSelect::
;> PlayCursorSoundOnMove()
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x48:             # Down, Select
	ldh a, [hJoypadPressed]
	and $48
	jr z, .notDown
;>     wSaveSlot = (wSaveSlot + 1) & 3
	ld a, [wSaveSlot]
	inc a
	and $03
	ld [wSaveSlot], a
.notDown
;> if hJoypadPressed & 0x04:             # Up
	ldh a, [hJoypadPressed]
	and $04
	jr z, .notUp
;>@u     wSaveSlot = (wSaveSlot - 1) & 3
	ld a, [wSaveSlot]
	dec a
	cp $ff
	jr nz, .store
	ld a, $03
.store
;=@u
	ld [wSaveSlot], a
.notUp
;> if not hJoypadPressed & 0x90:         # A, Start
	ldh a, [hJoypadPressed]
	and $90
;>     return FileDeleteSelectIdle()
	jr z, FileDeleteSelectIdle
;> if wSaveSlot == 3:
	ld a, [wSaveSlot]
	cp $03
	jr nz, .file
;>     return ReturnToFileSelect()
	jp ReturnToFileSelect
.file
;> PlayConfirmSound()
	call PlayConfirmSound
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> return DrawQuitOkText()
	jr DrawQuitOkText

;@ path: menu/erase
;@ Background draw command (with its end byte) for the erase menu's bottom line: VRAM $99E4, $0D (14
;@ tiles across), then "  QUIT    OK  " in the menu font (A = $00 ... Z = $19, $7E blank), then 0.
QuitOkText::
	db $99, $e4, $0d, $7e, $7e, $10, $14, $08, $13, $7e, $7e, $7e, $7e, $0e, $0a, $7e, $7e, $00

;@ def DrawQuitOkText()
;@ path: menu/erase
;@ Puts QuitOkText at the start of the draw command queue.
DrawQuitOkText::
;>@c copy(wDrawCommand, QuitOkText, 0x12)
	ld hl, wDrawCommand
	ld de, QuitOkText
	ld c, $11
.copy
	ld a, [de]
	inc de
	ld [hli], a
;=@c
	dec c
	ld a, c
	cp $ff
	jr nz, .copy
	ret

;@ def FileDeleteSelectIdle()
;@ path: menu/erase
;@ The end of FileDeleteSelect when nothing is chosen: draws the fairy cursor.
;@ test: wCurrentBank = $01
FileDeleteSelectIdle::
;> DrawFileSelectCursor()
	call DrawFileSelectCursor
	ret

;@ def FileDeleteConfirm()
;@ path: menu/erase
;@ Step 7: Left / Right / Select pick QUIT or OK while the chosen file's name blinks. B goes back to
;@ choosing a file (RETURN TO MENU shown again). A or Start: QUIT returns to the file menu; OK erases
;@ the file's $380 bytes of data in battery RAM and then returns to the file menu.
;@ test: skip writes battery RAM
FileDeleteConfirm::
;> if hJoypadPressed & 0x20:             # B
	ldh a, [hJoypadPressed]
	bit 5, a
	jr nz, .back
;>@b1     DrawSelectedFileName()
;>@b2     DrawReturnToMenuText()
;>@b3     wGameplaySubtype -= 1
;>@b4     return
;> if not hJoypadPressed & 0x90:         # A, Start
	and $90
;>     return FileDeleteBlinkName()
	jr z, FileDeleteBlinkName
;> if wEntityWorkRAM[0] == 0:               # QUIT
	ld a, [wEntityWorkRAM]
	and a
;>     return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;> PlayConfirmSound()
	call PlayConfirmSound
;>@d data = mem16[SaveSlotDataAddresses + 2 * wSaveSlot]
	ld a, [wSaveSlot]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotDataAddresses
	add hl, de
;=@d
	ld a, [hli]
	ld h, [hl]
	ld l, a
;>@f fill(data, 0, 0x380)                # (battery RAM switched on for each byte)
	ld de, $0380
.erase
	call EnableSRAM
	xor a
	ld [hli], a
	dec de
	ld a, e
;=@f
	or d
	jr nz, .erase
;> return ReturnToFileSelect()
	jp ReturnToFileSelect
.back
;=@b1
	call DrawSelectedFileName
;=@b2
	call DrawReturnToMenuText
;=@b3
	ld hl, wGameplaySubtype
	dec [hl]
;=@b4
	ret

;@ path: menu/erase
;@ Background draw command (with its end byte) for the erase menu's bottom line: VRAM $99E4, $0D (14
;@ tiles across), then "RETURN TO MENU" in the menu font, then 0.
ReturnToMenuText::
	db $99, $e4, $0d, $11, $04, $13, $14, $11, $0d, $7e, $13, $0e, $7e, $0c, $04, $0d, $14, $00

;@ def DrawReturnToMenuText()
;@ path: menu/erase
;@ Appends ReturnToMenuText to the draw command queue.
DrawReturnToMenuText::
;>@x dest = wDrawCommand + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
;> wDrawCommandsSize += 0x11
	add $11
	ld [wDrawCommandsSize], a
;=@x
	ld d, $00
	ld hl, wDrawCommand
	add hl, de
;>@c copy(dest, ReturnToMenuText, 0x12)
	ld de, ReturnToMenuText
	ld c, $11
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
;=@c
	ld a, c
	cp $ff
	jr nz, .copy
	ret

;@ def FileDeleteBlinkName()
;@ path: menu/erase
;@ While the erase is being confirmed: moves the QUIT / OK arrow, draws the fairy and makes the chosen
;@ file's name blink (shown for 16 frames, blanked for 16).
;@ test: skip queues draw commands
FileDeleteBlinkName::
;> UpdateYesNoCursor()
	call UpdateYesNoCursor
;> DrawFileSelectCursor()
	call DrawFileSelectCursor
;> if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
;>     return HideSelectedFileName()
	jr z, HideSelectedFileName
;> DrawSelectedFileName()                # falls through into it

;@ def DrawSelectedFileName()
;@ path: menu/fileselect
;@ Queues the name of the file wSaveSlot points at (through DrawFileNameTable).
;@ test: skip jumps through a table
DrawSelectedFileName::
;> return DrawFileNameTable[wSaveSlot]()
	ld a, [wSaveSlot]
	rst $00

;@ path: menu/fileselect
;@ The name-drawing routine of each file (dw for files 1-3), used by DrawSelectedFileName.
DrawFileNameTable::
	dw DrawFileName1
	dw DrawFileName2
	dw DrawFileName3

;@ def HideSelectedFileName()
;@ path: menu/fileselect
;@ Puts the blanking commands of the file wSaveSlot points at (FileNameBlanks, 8 bytes) at the start
;@ of the draw command queue.
;@ test: wSaveSlot = rand(0, 2)
HideSelectedFileName::
;>@s src = FileNameBlanks + wSaveSlot * 8
	ld a, [wSaveSlot]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@s
	ld d, $00
	ld hl, FileNameBlanks
	add hl, de
;>@c copy(wDrawCommand, src, 8)
	ld de, wDrawCommand
	ld c, $08
.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@c
	dec c
	jr nz, .copy
;> wDrawCommand[8] = 0
	xor a
	ld [de], a
	ret

;@ def UpdateYesNoCursor()
;@ path: menu/fileselect
;@ Left / Right / Select switch wEntityWorkRAM between 0 and 1 (with the cursor sound); the arrow
;@ (tile $BE, OAM entry 3) blinks under the choice: x $28 for 0, $6C for 1. Used by the erase and copy
;@ confirmations.
UpdateYesNoCursor::
;> if hJoypadPressed & 0x43:             # Right, Left, Select
	ldh a, [hJoypadPressed]
	and $43
	jr z, .draw
;>     PlayCursorSound()
	call PlayCursorSound
;>     wEntityWorkRAM[0] ^= 1
	ld a, [wEntityWorkRAM]
	xor $01
	ld [wEntityWorkRAM], a
.draw
;> if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr nz, .done
;>@x     x = 0x6C if wEntityWorkRAM[0] == 1 else 0x28
	ld a, [wEntityWorkRAM]
	ld e, a
	ld a, $28
	dec e
	jr nz, .put
	ld a, $6c
.put
;>@o     wOAMBuffer[12:16] = [0x88, x, 0xBE, 0]
	ld hl, wOAMBuffer + 12
	ld [hl], $88
	inc hl
	ld [hli], a
	ld a, $be
	ld [hli], a
;=@o
	xor a
	ld [hl], a
.done
	ret

;@ path: menu/fileselect
;@ Background tiles of the digits 0-9 ($B0-$B9), indexed by the digit; used for the death counters.
DigitTiles::
	db $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9

;@ def DrawDeathCount(count: hl, pos: de)
;@ path: menu/fileselect
;@ Appends a draw command for a 3-digit death counter at VRAM `pos`: the hundreds from the low nibble
;@ of l, then the tens and ones from h (the two bytes of a wDeathCount, swapped).
;@ test: skip queues draw commands
DrawDeathCount::
;>@x cmd = wDrawCommand + wDrawCommandsSize
	push hl
	ld a, [wDrawCommandsSize]
	ld c, a
;> wDrawCommandsSize += 6
	add $06
	ld [wDrawCommandsSize], a
;=@x
	ld b, $00
	ld hl, wDrawCommand
	add hl, bc
;> mem[cmd:cmd + 3] = [hi(pos), lo(pos), 0x02]    # 3 tiles across
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, $02
	ld [hli], a
;>@h mem[cmd + 3] = mem[DigitTiles + (lo(count) & 0x0F)]   # hundreds
	pop bc
	push hl
	ld a, c
	and $0f
	ld e, a
	ld d, $00
;=@h
	ld hl, DigitTiles
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;>@t mem[cmd + 4] = mem[DigitTiles + (hi(count) >> 4)]     # tens
	push hl
	ld a, b
	and $f0
	swap a
	ld e, a
	ld d, $00
;=@t
	ld hl, DigitTiles
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;>@o mem[cmd + 5] = mem[DigitTiles + (hi(count) & 0x0F)]   # ones
	push hl
	ld a, b
	and $0f
	ld e, a
	ld d, $00
	ld hl, DigitTiles
;=@o
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;> mem[cmd + 6] = 0
	xor a
	ld [hl], a
	ret


;@ def GameplayFileCopyHandler()
;@ path: menu/copy
;@ Game mode 5, the copy menu: runs the current step of FileCopySteps. The source file is chosen in the
;@ left column (wSceneVar1), the destination in the right column (wSceneVar2), then QUIT / OK.
;@ test: skip jumps through a table
GameplayFileCopyHandler::
;> return FileCopySteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/copy
;@ The steps of the copy menu (dw per value of wGameplaySubtype): 0 tiles, 1 screen, 2 names of the
;@ left column, 3 names of the right column, 4 choose the source, 5 choose the destination, 6 confirm.
FileCopySteps::
	dw FileCopyInit
	dw FileCopyLoadScreen
	dw FileCopyDrawSourceNames
	dw FileCopyDrawDestNames
	dw FileCopySelectSource
	dw FileCopySelectDest
	dw FileCopyConfirm

;@ def FileCopyInit()
;@ path: menu/copy
;@ Step 0: requests tile set 8 and resets all choices.
FileCopyInit::
;> wTileMapToLoad = 8
	ld a, $08
	ld [wTileMapToLoad], a
;> wSaveSlot = 0
	xor a
	ld [wSaveSlot], a
;> wEntityWorkRAM[0] = 0                    # QUIT / OK
	ld [wEntityWorkRAM], a
;> wSceneVar1 = 0                        # source file
	ld [wSceneVar1], a
;> wSceneVar2 = 0                        # destination file
	ld [wSceneVar2], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileCopyLoadScreen()
;@ path: menu/copy
;@ Step 1: requests the copy menu screen (layout $0C).
FileCopyLoadScreen::
;> wBGMapToLoad = 0x0C
	ld a, $0c
	ld [wBGMapToLoad], a
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileCopyDrawSourceNames()
;@ path: menu/copy
;@ Step 2: queues the three names in the left column ($98C4, $9924, $9984).
;@ test: skip reads the font table in another bank
FileCopyDrawSourceNames::
;> DrawFileName(0x98C4, wSaveSlotNames)
	ld bc, $98c4
	ld de, wSaveSlotNames
	call DrawFileName
;> DrawFileName(0x9924, wSaveSlotNames + 5)
	ld bc, $9924
	ld de, wSaveSlotNames + 5
	call DrawFileName
;> DrawFileName(0x9984, wSaveSlotNames + 10)
	ld bc, $9984
	ld de, wSaveSlotNames + 10
	call DrawFileName
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileCopyDrawDestNames()
;@ path: menu/copy
;@ Step 3: queues the three names in the right column ($98CD, $992D, $998D).
;@ test: skip reads the font table in another bank
FileCopyDrawDestNames::
;> DrawFileName(0x98CD, wSaveSlotNames)
	ld bc, $98cd
	ld de, wSaveSlotNames
	call DrawFileName
;> DrawFileName(0x992D, wSaveSlotNames + 5)
	ld bc, $992d
	ld de, wSaveSlotNames + 5
	call DrawFileName
;> DrawFileName(0x998D, wSaveSlotNames + 10)
	ld bc, $998d
	ld de, wSaveSlotNames + 10
	call DrawFileName
;> IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def FileCopySelectSource()
;@ path: menu/copy
;@ Step 4: Up / Down / Select move the fairy over the left column's three files and the bottom row.
;@ A or Start on the bottom row returns to the file menu, on a file goes on to choosing the
;@ destination. The fairy is drawn at x $10 (falls into DrawFileCursorPair).
;@ test: skip draws sprites
FileCopySelectSource::
;> PlayCursorSoundOnMove()
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x48:             # Down, Select
	ldh a, [hJoypadPressed]
	and $48
	jr z, .notDown
;>     wSceneVar1 = (wSceneVar1 + 1) & 3
	ld a, [wSceneVar1]
	inc a
	and $03
	ld [wSceneVar1], a
.notDown
;> if hJoypadPressed & 0x04:             # Up
	ldh a, [hJoypadPressed]
	and $04
	jr z, .notUp
;>@u     wSceneVar1 = (wSceneVar1 - 1) & 3
	ld a, [wSceneVar1]
	dec a
	cp $ff
	jr nz, .store
	ld a, $03
.store
;=@u
	ld [wSceneVar1], a
.notUp
;> if hJoypadPressed & 0x90:             # A, Start
	ldh a, [hJoypadPressed]
	and $90
	jr z, .draw
;>     if wSceneVar1 == 3:
	ld a, [wSceneVar1]
	cp $03
;>         return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     PlayConfirmSound()
	call PlayConfirmSound
.draw
;>@d return DrawFileCursorPair(mem[FileSelectCursorY + wSceneVar1], wOAMBuffer, hFrameCounter & 8 == 0)
	ld a, [wSceneVar1]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
	ldh a, [hFrameCounter]
;=@d
	and $08
	ld a, [hl]
	ld hl, wOAMBuffer

;@ def DrawFileCursorPair(y: a, oam: hl, mirrored: zero)
;@ path: menu/copy
;@ Draws the fairy cursor (two sprites at x $10 and $18) at height `y` into two OAM entries at `oam`;
;@ the caller's zero flag (hFrameCounter & 8 == 0) selects the mirrored picture.
;@ test: oam = rand(0xC000, 0xDFF0)
DrawFileCursorPair::
;> if not mirrored:
	jr z, .mirrored
;>@a     mem[oam:oam + 4] = [y, 0x10, 0x00, 0x00]
	push af
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $00
	ld [hli], a
;=@a
	ld a, $00
	ld [hli], a
;>@b     mem[oam + 4:oam + 8] = [y, 0x18, 0x02, 0x00]
	pop af
	ld [hli], a
	ld a, $18
	ld [hli], a
	ld a, $02
	ld [hli], a
;=@b
	ld a, $00
	ld [hl], a
	ret
;> else:
.mirrored
;>@c     mem[oam:oam + 4] = [y, 0x10, 0x02, 0x20]      # x-flipped
	push af
	ld [hli], a
	ld a, $10
	ld [hli], a
	ld a, $02
	ld [hli], a
;=@c
	ld a, $20
	ld [hli], a
;>@e     mem[oam + 4:oam + 8] = [y, 0x18, 0x00, 0x20]
	pop af
	ld [hli], a
	ld a, $18
	ld [hli], a
	ld a, $00
	ld [hli], a
;=@e
	ld a, $20
	ld [hl], a
	ret

;@ def DrawCopySourceArrow()
;@ path: menu/copy
;@ Marks the chosen source file with an arrow (tile $BE at x $14) in OAM entry 0.
DrawCopySourceArrow::
;>@y y = mem[FileSelectCursorY + wSceneVar1]
	ld a, [wSceneVar1]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
	ld a, [hl]
;>@o wOAMBuffer[0:4] = [y + 5, 0x14, 0xBE, 0]
	ld hl, wOAMBuffer
	add $05
	ld [hli], a
	ld a, $14
	ld [hli], a
	ld a, $be
;=@o
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret

;@ path: menu/copy
;@ Background draw commands that blank out a name of the copy menu's left column (to make the source
;@ blink): 3 records of 8 bytes, one per file; each = two commands (VRAM address high, low, $44 =
;@ 5 times the same tile, tile $7E): the line above the name ($98A4/$9904/$9964) and the name.
FileCopySourceBlanks::
	db $98, $a4, $44, $7e, $98, $c4, $44, $7e
	db $99, $04, $44, $7e, $99, $24, $44, $7e
	db $99, $64, $44, $7e, $99, $84, $44, $7e

;@ path: menu/copy
;@ The same blanking commands for the right column (the destination): 3 records of 8 bytes at
;@ $98AD/$98CD, $990D/$992D, $996D/$998D.
FileCopyDestBlanks::
	db $98, $ad, $44, $7e, $98, $cd, $44, $7e
	db $99, $0d, $44, $7e, $99, $2d, $44, $7e
	db $99, $6d, $44, $7e, $99, $8d, $44, $7e

;@ def FileCopySelectDest()
;@ path: menu/copy
;@ Step 5: Up / Down / Select choose the destination in the right column (or the bottom row) while the
;@ source name blinks. B goes back to choosing the source; A or Start on the bottom row returns to the
;@ file menu, on a file asks QUIT / OK.
;@ test: skip queues draw commands
FileCopySelectDest::
;> PlayCursorSoundOnMove()
	call PlayCursorSoundOnMove
;> if hJoypadPressed & 0x48:             # Down, Select
	ldh a, [hJoypadPressed]
	and $48
	jr z, .notDown
;>     wSceneVar2 = (wSceneVar2 + 1) & 3
	ld a, [wSceneVar2]
	inc a
	and $03
	ld [wSceneVar2], a
.notDown
;> if hJoypadPressed & 0x04:             # Up
	ldh a, [hJoypadPressed]
	and $04
	jr z, .notUp
;>@u     wSceneVar2 = (wSceneVar2 - 1) & 3
	ld a, [wSceneVar2]
	dec a
	cp $ff
	jr nz, .store
	ld a, $03
.store
;=@u
	ld [wSceneVar2], a
.notUp
;> DrawCopySourceArrow()
	call DrawCopySourceArrow
;> if hJoypadPressed & 0x20:             # B
	ldh a, [hJoypadPressed]
	bit 5, a
	jr z, .notB
;>     wGameplaySubtype -= 1
	ld hl, wGameplaySubtype
	dec [hl]
;>     return DrawCopySourceName()
	jp DrawCopySourceName
.notB
;> if hJoypadPressed & 0x90:             # A, Start
	and $90
	jr z, .idle
;>     if wSceneVar2 == 3:
	ld a, [wSceneVar2]
	cp $03
;>         return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;>     PlayConfirmSound()
	call PlayConfirmSound
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     return DrawQuitOkText()
	jp DrawQuitOkText
.idle
;> DrawCopyDestCursor()
	call DrawCopyDestCursor
;> BlinkCopySourceName()                 # falls through into it

;@ def BlinkCopySourceName()
;@ path: menu/copy
;@ Every 16 frames alternately shows (DrawCopySourceName) and blanks (FileCopySourceBlanks, at the
;@ start of the draw queue) the source file's name.
;@ test: wSceneVar1 = rand(0, 2); hFrameCounter = rand(0, 255) | 0x10
BlinkCopySourceName::
;> if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
;>     return DrawCopySourceName()
	jr z, DrawCopySourceName
;>@s src = FileCopySourceBlanks + wSceneVar1 * 8
	ld a, [wSceneVar1]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@s
	ld d, $00
	ld hl, FileCopySourceBlanks
	add hl, de
;>@c copy(wDrawCommand, src, 8)
	ld de, wDrawCommand
	ld c, $08
.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@c
	dec c
	jr nz, .copy
;> wDrawCommand[8] = 0
	xor a
	ld [de], a
	ret

;@ def DrawCopySourceName()
;@ path: menu/copy
;@ Queues the source file's name in the left column.
;@ test: skip reads the font table in another bank
DrawCopySourceName::
;> if wSceneVar1 == 1:
	ld a, [wSceneVar1]
	cp $01
	jr z, .file2
;>@f2     return DrawFileName(0x9924, wSaveSlotNames + 5)
;> if wSceneVar1 == 2:
	cp $02
	jr z, .file3
;>@f3     return DrawFileName(0x9984, wSaveSlotNames + 10)
;> return DrawFileName(0x98C4, wSaveSlotNames)
	ld bc, $98c4
	ld de, wSaveSlotNames
	jp DrawFileName
.file2
;=@f2
	ld bc, $9924
	ld de, wSaveSlotNames + 5
	jp DrawFileName
.file3
;=@f3
	ld bc, $9984
	ld de, wSaveSlotNames + 10
	jp DrawFileName

;@ def DrawCopyDestCursor()
;@ path: menu/copy
;@ Draws the fairy cursor for the destination: on the bottom row at x $10 (DrawFileCursorPair), on a
;@ file at x $58 and $60, in OAM entries 2-3; mirrored every 8 frames.
;@ test: skip draws sprites
DrawCopyDestCursor::
;>@y y = mem[FileSelectCursorY + wSceneVar2]
	ld a, [wSceneVar2]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
;> if wSceneVar2 == 3:
	ld a, [wSceneVar2]
	cp $03
;>@r     return DrawFileCursorPair(y, wOAMBuffer + 8, hFrameCounter & 8 == 0)
	jp z, .bottomRow
;> if hFrameCounter & 0x08:
	ldh a, [hFrameCounter]
	and $08
	jr z, .mirrored
;>@a     wOAMBuffer[8:12] = [y, 0x58, 0x00, 0x00]
	ld a, [hl]
	ld hl, wOAMBuffer + 8
	push af
	ld [hli], a
	ld a, $58
	ld [hli], a
;=@a
	ld a, $00
	ld [hli], a
	ld a, $00
	ld [hli], a
;>@b     wOAMBuffer[12:16] = [y, 0x60, 0x02, 0x00]
	pop af
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $02
	ld [hli], a
;=@b
	ld a, $00
	ld [hl], a
	ret
;> else:
.mirrored
;>@c     wOAMBuffer[8:12] = [y, 0x58, 0x02, 0x20]
	ld a, [hl]
	ld hl, wOAMBuffer + 8
	push af
	ld [hli], a
	ld a, $58
	ld [hli], a
;=@c
	ld a, $02
	ld [hli], a
	ld a, $20
	ld [hli], a
;>@e     wOAMBuffer[12:16] = [y, 0x60, 0x00, 0x20]
	pop af
	ld [hli], a
	ld a, $60
	ld [hli], a
	ld a, $00
	ld [hli], a
;=@e
	ld a, $20
	ld [hl], a
	ret
.bottomRow
;=@r
	ldh a, [hFrameCounter]
	and $08
	ld a, [hl]
	ld hl, wOAMBuffer + 8
	jp DrawFileCursorPair
;@ def DrawCopyDestArrow()
;@ path: menu/copy
;@ Marks the chosen destination file with an arrow (tile $BE at x $5C) in OAM entry 2.
DrawCopyDestArrow::
;>@y y = mem[FileSelectCursorY + wSceneVar2]
	ld a, [wSceneVar2]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
	ld a, [hl]
;>@o wOAMBuffer[8:12] = [y + 5, 0x5C, 0xBE, 0]
	ld hl, wOAMBuffer + 8
	add $05
	ld [hli], a
	ld a, $5c
	ld [hli], a
	ld a, $be
;=@o
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret

;@ def FileCopyConfirm()
;@ path: menu/copy
;@ Step 6: QUIT / OK with both arrows shown while both names blink. A or Start: QUIT returns to the
;@ file menu; OK copies the whole source slot ($385 bytes: markers and data) over the destination slot
;@ in battery RAM, then returns to the file menu. B goes back to choosing the destination.
;@ test: skip writes battery RAM
FileCopyConfirm::
;> DrawCopySourceArrow()
	call DrawCopySourceArrow
;> DrawCopyDestArrow()
	call DrawCopyDestArrow
;> UpdateYesNoCursor()
	call UpdateYesNoCursor
;> if hJoypadPressed & 0x90:             # A, Start
	ldh a, [hJoypadPressed]
	and $90
	jr z, .notA
;>     if wEntityWorkRAM[0] == 0:           # QUIT
	ld a, [wEntityWorkRAM]
	and a
;>         return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;>     PlayConfirmSound()
	call PlayConfirmSound
;>@s     src = mem16[SaveSlotAddresses + 2 * wSceneVar1]
	ld a, [wSceneVar1]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotAddresses
	add hl, de
;=@s
	ld c, [hl]
	inc hl
	ld b, [hl]
;>@d     dest = mem16[SaveSlotAddresses + 2 * wSceneVar2]
	ld a, [wSceneVar2]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotAddresses
	add hl, de
;=@d
	ld a, [hl]
	inc hl
	ld h, [hl]
	ld l, a
;>@c     copy(dest, src, 0x385)            # (battery RAM switched on for each byte)
	ld de, $0385
.copy
	call EnableSRAM
	ld a, [bc]
	inc bc
	call EnableSRAM
;=@c
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .copy
;>     return ReturnToFileSelect()
	jp ReturnToFileSelect
.notA
;> if hJoypadPressed & 0x20:             # B
	ldh a, [hJoypadPressed]
	bit 5, a
	jr z, .blink
;>     wGameplaySubtype -= 1
	ld hl, wGameplaySubtype
	dec [hl]
;>     wEntityWorkRAM[0] = 0
	xor a
	ld [wEntityWorkRAM], a
;>     DrawReturnToMenuText()
	call DrawReturnToMenuText
;>     return DrawCopyDestName()
	jp DrawCopyDestName
.blink
;> BlinkCopySourceName()
	call BlinkCopySourceName
;> if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
;>     return DrawCopyDestName()
	jr z, DrawCopyDestName
;>@s2 src = FileCopyDestBlanks + wSceneVar2 * 8
	ld a, [wSceneVar2]
	rla
	rla
	rla
	and $f8
	ld e, a
;=@s2
	ld d, $00
	ld hl, FileCopyDestBlanks
	add hl, de
;>@c2 copy(wDrawCommand + 8, src, 8)    # after the source name's commands
	ld de, wDrawCommand + 8
	ld c, $08
.copyBlanks
	ld a, [hli]
	ld [de], a
	inc de
;=@c2
	dec c
	jr nz, .copyBlanks
;> mem[wDrawCommand + 16] = 0
	xor a
	ld [de], a
	ret

;@ def DrawCopyDestName()
;@ path: menu/copy
;@ Queues the destination file's name in the right column.
;@ test: skip reads the font table in another bank
DrawCopyDestName::
;> if wSceneVar2 == 1:
	ld a, [wSceneVar2]
	cp $01
	jr z, .file2
;>@f2     return DrawFileName(0x992D, wSaveSlotNames + 5)
;> if wSceneVar2 == 2:
	cp $02
	jr z, .file3
;>@f3     return DrawFileName(0x998D, wSaveSlotNames + 10)
;> return DrawFileName(0x98CD, wSaveSlotNames)
	ld bc, $98cd
	ld de, wSaveSlotNames
	jp DrawFileName
.file2
;=@f2
	ld bc, $992d
	ld de, wSaveSlotNames + 5
	jp DrawFileName
.file3
;=@f3
	ld bc, $998d
	ld de, wSaveSlotNames + 10
	jp DrawFileName

;@ path: menu/fileselect
;@ Health (eighths of a heart) a file starts with when its health is 0 (after a game over that was
;@ saved), indexed by the number of heart containers (wMaxHearts 0-14; one byte each): 3 hearts for
;@ up to 5 containers, 5 hearts for 6-9, 7 for 10-13, 10 for 14.
DefaultHealthByMaxHearts::
	db $18, $18, $18, $18, $18, $18, $28, $28, $28, $28, $38, $38, $38, $38, $50

;@ def StartGameplay()
;@ path: world/load
;@ Starts playing the chosen file (also after continuing from the game over menu): refills an empty
;@ health bar, loads the file's $380 bytes of data from battery RAM into wRoomStatus.. (unless the
;@ game over menu kept the RAM), switches to game mode $0B (the world) and clears the pending health
;@ and rupee changes. Link starts at the file's saved restart point, or for a new file in the house
;@ he wakes up in (room $A3 of map $10) with the starting capacities.
;@ test: skip reads battery RAM
StartGameplay::
;> hIsSideScrolling = 0
	xor a
	ldh [hIsSideScrolling], a
;> if wHealth == 0:
	ld a, [wHealth]
	and a
	jr nz, .load
;>@h     wHealth = mem[DefaultHealthByMaxHearts + wMaxHearts]
	ld a, [wMaxHearts]
	ld e, a
	ld d, $00
	ld hl, DefaultHealthByMaxHearts
	add hl, de
	ld a, [hl]
;=@h
	ld [wHealth], a
.load
;> keep = wContinueWithoutSave
	ld hl, wContinueWithoutSave
	ld a, [hl]
;> wContinueWithoutSave = 0
	ld [hl], $00
;> if not keep:
	and a
	jr nz, .play
;>@s     src = mem16[SaveSlotDataAddresses + 2 * wSaveSlot]
	ld a, [wSaveSlot]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotDataAddresses
	add hl, de
;=@s
	ld c, [hl]
	inc hl
	ld b, [hl]
;>@c     copy(wRoomStatus, src, 0x380)      # (battery RAM switched on for each byte)
	ld hl, wRoomStatus
	ld de, $0380
.copy
	call EnableSRAM
	ld a, [bc]
	inc bc
;=@c
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .copy
.play
;> wGameplayType = 0x0B                  # the world
	ld a, $0b
	ld [wGameplayType], a
;> wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;> wLinkMotionState = 0
	xor a
	ld [wLinkMotionState], a
;> hLinkMotionStep = 0
	ldh [hLinkMotionStep], a
;> wAddHealthBuffer = 0
	ld [wAddHealthBuffer], a
;> wSubtractHealthBuffer = 0
	ld [wSubtractHealthBuffer], a
;> wAddRupeeBufferLow = 0
	ld [wAddRupeeBufferLow], a
;> wAddRupeeBufferHigh = 0
	ld [wAddRupeeBufferHigh], a
;> wSubtractRupeeBufferLow = 0
	ld [wSubtractRupeeBufferLow], a
;> wSubtractRupeeBufferHigh = 0
	ld [wSubtractRupeeBufferHigh], a
;> if wIronBallRoom == 0:
	ld a, [wIronBallRoom]
	and a
	jr nz, .spawn
;>     wIronBallRoom = 0x16
	ld a, $16
	ld [wIronBallRoom], a
;>     wIronBallX = 0x50
	ld a, $50
	ld [wIronBallX], a
;>     wIronBallY = 0x27
	ld a, $27
	ld [wIronBallY], a
.spawn
;> if wSpawnX == 0:                      # a new file
	ld a, [wSpawnX]
	and a
	jr z, .newGame
;>@n1     wMaxArrows = 0x30
;>@n2     wMaxBombs = 0x30
;>@n3     wMaxMagicPowder = 0x20
;>@n4     mem[0xDB9C] = 0xA3
;>@n5     hMapRoom = 0xA3                  # the house where Link wakes up
;>@n6     wIsIndoor = 1
;>@n7     hMapId = 0x10
;>@n8     wMapEntrancePositionX = 0x50
;>@n9     wMapEntrancePositionY = 0x60
;>@na     hLinkAnimationState = 0
;>@nb     hLinkDirection = 3               # down
;>@nc     wIronBallRoom = 0x16
;>@nd     wIronBallX = 0x50
;>@ne     wIronBallY = 0x27
;>@nf     wBGMapToLoad = 2
;>@ng     return
;> wMapEntrancePositionX = wSpawnX
	ld [wMapEntrancePositionX], a
;> wMapEntrancePositionY = wSpawnY
	ld a, [wSpawnY]
	ld [wMapEntrancePositionY], a
;> hMapRoom = wSpawnRoom
	ld a, [wSpawnRoom]
	ldh [hMapRoom], a
;> mem[0xDB9C] = wSpawnRoom
	ld [$db9c], a
;> hMapId = wSpawnMapId
	ld a, [wSpawnMapId]
	ldh [hMapId], a
;> wIndoorRoom = wSpawnIndoorRoom
	ld a, [wSpawnIndoorRoom]
	ld [wIndoorRoom], a
;> hIsSideScrolling = 0
	xor a
	ldh [hIsSideScrolling], a
;> wIsIndoor = wSpawnIsIndoor & 1
	ld a, [wSpawnIsIndoor]
	and $01
	ld [wIsIndoor], a
;> if wIsIndoor:
	jr z, .done
;>     hLinkAnimationState = 4
	ld a, $04
	ldh [hLinkAnimationState], a
;>     hLinkDirection = 2                # up
	ld a, $02
	ldh [hLinkDirection], a
.done
;> wBGMapToLoad = 2
	ld a, $02
	ld [wBGMapToLoad], a
	ret
.newGame
;=@n1
	ld a, $30
	ld [wMaxArrows], a
;=@n2
	ld a, $30
	ld [wMaxBombs], a
;=@n3
	ld a, $20
	ld [wMaxMagicPowder], a
;=@n4
	ld a, $a3
	ld [$db9c], a
;=@n5
	ldh [hMapRoom], a
;=@n6
	ld a, $01
	ld [wIsIndoor], a
;=@n7
	ld a, $10
	ldh [hMapId], a
;=@n8
	ld a, $50
	ld [wMapEntrancePositionX], a
;=@n9
	ld a, $60
	ld [wMapEntrancePositionY], a
;=@na
	xor a
	ldh [hLinkAnimationState], a
;=@nb
	ld a, $03
	ldh [hLinkDirection], a
;=@nc
	ld a, $16
	ld [wIronBallRoom], a
;=@nd
	ld a, $50
	ld [wIronBallX], a
;=@ne
	ld a, $27
	ld [wIronBallY], a
;=@nf
	jr .done
;=@ng

;@ path: world/minimap
;@ High byte of the VRAM address of each frame command of the dungeon subscreen's minimap, in four
;@ layouts of 4 entries (index = 4 x layout, layout = bits 4-5 of wMinimapLayout); each layout lists
;@ three commands and ends with $FF. Read together with MinimapFrameLow, MinimapFrameMode and
;@ MinimapFrameTile (same index): one 4-byte background draw command per entry (VRAM high, low,
;@ mode = count - 1 with bit 7 vertical and bit 6 repeat one tile, tile).
;@ Layout 0: blank columns at $9D32 (9 tiles down), plus tile $BA at $9D09.
MinimapFrameHigh::
	db $9d, $9d, $9d, $ff, $9d, $9d, $9d, $ff, $9d, $9d, $9c, $ff, $9d, $9d, $9c, $ff
;@ path: world/minimap
;@ Low byte of the VRAM address of each minimap frame command (see MinimapFrameHigh; 16 bytes).
MinimapFrameLow::
	db $32, $32, $09, $ff, $2e, $2e, $09, $ff, $8a, $32, $e9, $ff, $8a, $2e, $e9, $ff
;@ path: world/minimap
;@ Mode byte of each minimap frame command (see MinimapFrameHigh; 16 bytes): $C8 = 9 tiles down
;@ repeating one tile, $48 = 9 tiles across repeating one tile, $00 = one tile.
MinimapFrameMode::
	db $c8, $c8, $00, $ff, $c8, $c8, $00, $ff, $48, $c8, $00, $ff, $48, $c8, $00, $ff
;@ path: world/minimap
;@ Tile of each minimap frame command (see MinimapFrameHigh; 16 bytes): $7F blank, $BA.
MinimapFrameTile::
	db $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff, $7f, $7f, $ba, $ff
;@ path: world/minimap
;@ High byte of the VRAM address of each extra single-tile minimap piece (68 bytes), used only when
;@ the layout (bits 4-5 of wMinimapLayout) is not 0: the list starts at index 8 x layout, + 4 when
;@ the variant (bits 0-1) is set for layouts 1-2, or + 11 x variant for layout 3, and ends where this
;@ table holds $FF. Read with MinimapFloorLow and MinimapFloorTile (same index); each entry becomes
;@ a draw command of one tile.
MinimapFloorHigh::
	db $00, $00, $00, $ff, $00, $00, $00, $ff, $9d, $9d, $ff, $00, $9d, $9d, $9d, $ff
	db $9d, $9c, $ff, $00, $9d, $9c, $9c, $ff, $9d, $9d, $9c, $9c, $ff, $00, $00, $00
	db $00, $00, $00, $9d, $9d, $9c, $9c, $9c, $9c, $ff, $00, $00, $00, $00, $9d, $9d
	db $9c, $9c, $9d, $9d, $9c, $9c, $ff, $00, $00, $9d, $9d, $9c, $9c, $9d, $9d, $9c
	db $9c, $9c, $9c, $ff

;@ path: world/minimap
;@ Low byte of the VRAM address of each extra minimap piece (see MinimapFloorHigh; 68 bytes).
MinimapFloorLow::
	db $00, $00, $00, $ff, $00, $00, $00, $ff, $0d, $12, $ff, $00
	db $0d, $11, $12, $ff, $92, $f2, $ff, $00, $92, $f1, $f2, $ff, $8d, $92, $ed, $f2
	db $ff, $00, $00, $00, $00, $00, $00, $8d, $92, $ed, $f2, $f1, $f2, $ff, $00, $00
	db $00, $00, $8d, $92, $ed, $f2, $91, $92, $f1, $f2, $ff, $00, $00, $8d, $92, $ed
	db $f2, $91, $92, $ec, $ed, $f1, $f2, $ff

;@ path: world/minimap
;@ Tile of each extra minimap piece (see MinimapFloorHigh; 68 bytes; tiles $E8-$EC).
MinimapFloorTile::
	db $00, $00, $00, $ff, $00, $00, $00, $ff
	db $e8, $e9, $ff, $00, $e8, $ec, $e8, $ff, $e8, $e9, $ff, $00, $e8, $ec, $e8, $ff
	db $e8, $ea, $e9, $eb, $ff, $00, $00, $00, $00, $00, $00, $e8, $ea, $e9, $eb, $ec
	db $e8, $ff, $00, $00, $00, $00, $e8, $ea, $e9, $eb, $ec, $e8, $ec, $e9, $ff, $00
	db $00, $e8, $ea, $e9, $eb, $ec, $e8, $ec, $ea, $ec, $e9, $ff

;@ path: world/minimap
;@ High byte of the VRAM address of the dungeon's level number on the subscreen, indexed by bit 5 of
;@ wMinimapLayout (2 bytes; with MinimapLevelLow: $9D0A normally, $9CEA when bit 5 is set).
MinimapLevelHigh::
	db $9d, $9c

;@ path: world/minimap
;@ Low byte of the VRAM address of the level number (see MinimapLevelHigh; 2 bytes).
MinimapLevelLow::
	db $0a, $ea
;@ path: world/minimap
;@ Background draw commands that clear the minimap area of the dungeon subscreen: 10 commands of
;@ 4 bytes (VRAM address high, low, $49 = 10 times the same tile, tile $7F blank) for the rows at
;@ $9CE9, $9D09 ... $9E09, then the end byte 0. Copied to $D651 by DrawMinimapFrame.
MinimapClearCommands::
	db $9c, $e9, $49, $7f, $9d, $09, $49, $7f, $9d, $29, $49, $7f, $9d, $49, $49, $7f
	db $9d, $69, $49, $7f, $9d, $89, $49, $7f, $9d, $a9, $49, $7f, $9d, $c9, $49, $7f
	db $9d, $e9, $49, $7f, $9e, $09, $49, $7f, $00

;@ def DrawMinimapFrame()
;@ path: world/minimap
;@ Builds, at $D651, the background draw commands of the dungeon subscreen around the minimap:
;@ the clearing commands, the frame of the layout chosen by wMinimapLayout, the extra pieces of that
;@ layout (Eagle's Tower), and the level number (tile $B1 + hMapId) followed by a blank.
;@ test: skip builds a command list through scratch variables
DrawMinimapFrame::
;>@cp copy(0xD651, MinimapClearCommands, 0x29)
	ld hl, MinimapClearCommands
	ld de, wDrawCommand + $4F
	ld c, $29
.copy
	ld a, [hli]
	inc de
;=@cp
	ld [de], a
	dec c
	jr nz, .copy
;> out = 0xD679                          # over the end byte
	push de
;>@z fill(addr(hMultiPurpose0), 0, 4)         # hMultiPurpose0-3
	xor a
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose1], a
	ldh [hMultiPurpose2], a
	ldh [hMultiPurpose3], a
	ld c, a
;=@z
	ld b, a
	ld e, a
	ld d, a
;>@i i = 4 * ((wMinimapLayout >> 4) & 3)
	ld a, [wMinimapLayout]
	swap a
	and $03
	ld e, a
	and a
	jr z, .frame
;=@i
.times4
	ld a, c
	add $04
	ld c, a
	dec e
	ld a, e
	and a
;=@i
	jr nz, .times4
	ld b, $00
.frame
	pop hl
.frameLoop
;>@f while True:
	push hl
;>@g     hMultiPurpose0 = mem[MinimapFrameHigh + i]
	ld hl, MinimapFrameHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = mem[MinimapFrameLow + i]
	ld hl, MinimapFrameLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;>     hMultiPurpose2 = mem[MinimapFrameMode + i]
	ld hl, MinimapFrameMode
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;>     hMultiPurpose3 = mem[MinimapFrameTile + i]
	ld hl, MinimapFrameTile
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
;>     StoreDrawCommand4(out)
	pop hl
	call StoreDrawCommand4
;>     i += 1
	push hl
	ld hl, MinimapFrameHigh
	inc bc
;>     out += 4
	add hl, bc
	ld a, [hl]
	pop hl
	inc hl
;>     if mem[MinimapFrameHigh + i] == 0xFF:
	cp $ff
;=@f
	jr nz, .frameLoop
;>         break
;> mem[out] = 0
	xor a
	ld [hl], a
;>@z2 fill(addr(hMultiPurpose0), 0, 4)
	xor a
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose1], a
	ldh [hMultiPurpose2], a
	ldh [hMultiPurpose3], a
	ld c, a
;=@z2
	ld b, a
	ld e, a
	ld d, a
;> layout = (wMinimapLayout >> 4) & 3
	ld a, [wMinimapLayout]
	swap a
	and $03
	ld e, a
	and a
;> if layout:
	jr z, .level
;>@j     i = 8 * layout
.times8
	ld b, $00
	ld a, c
	add $08
	ld c, a
	dec e
	ld a, e
;=@j
	and a
	jr nz, .times8
;>     if wMinimapLayout & 3:
	ld a, [wMinimapLayout]
	and $03
	jr z, .pieces
;>         if wMinimapLayout & 0x30 != 0x30:
	ld a, [wMinimapLayout]
	and $30
	cp $30
	jr z, .layout3
;>             i += 4
	ld a, c
	add $04
	ld c, a
	ld b, $00
	jr .pieces
;>         else:
.layout3
;>@k             i += 11 * (wMinimapLayout & 3)
	ld a, [wMinimapLayout]
	and $03
	ld e, a
.times11
	ld b, $00
	ld a, c
	add $0b
;=@k
	ld c, a
	dec e
	ld a, e
	and a
	jr nz, .times11
.pieces
;>@p     while True:
	push hl
;>         hMultiPurpose0 = mem[MinimapFloorHigh + i]
	ld hl, MinimapFloorHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = mem[MinimapFloorLow + i]
	ld hl, MinimapFloorLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;>         hMultiPurpose2 = 0             # one tile
	xor a
	ldh [hMultiPurpose2], a
;>         hMultiPurpose3 = mem[MinimapFloorTile + i]
	ld hl, MinimapFloorTile
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
;>         StoreDrawCommand4(out)
	pop hl
	call StoreDrawCommand4
;>         i += 1
	push hl
	ld hl, MinimapFloorHigh
	inc bc
;>         out += 4
	add hl, bc
	ld a, [hl]
	pop hl
	inc hl
;>         if mem[MinimapFloorHigh + i] == 0xFF:
	cp $ff
;=@p
	jr nz, .pieces
;>             break
.level
;>@jj j = 1 if wMinimapLayout & 0x20 else 0
	xor a
	ld b, a
	ld c, a
	ld a, [wMinimapLayout]
	bit 5, a
	jr z, .number
;=@jj
	inc bc
.number
;>@lv hMultiPurpose0 = mem[MinimapLevelHigh + j]
	push hl
	ld hl, MinimapLevelHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = mem[MinimapLevelLow + j]
	ld hl, MinimapLevelLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = 1                    # two tiles
	ld a, $01
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = 0xB1 + hMapId        # the level number
	ldh a, [hMapId]
	add $b1
	ldh [hMultiPurpose3], a
;> StoreDrawCommand4(out)
	pop hl
	call StoreDrawCommand4
;> mem[out + 4] = 0x7F                   # then a blank tile
	push hl
	pop hl
	inc hl
	ld a, $7f
	ld [hli], a
;> mem[out + 5] = 0
	xor a
	ld [hl], a
	ret


;@ def StoreDrawCommand4(out: hl) -> hl
;@ path: world/minimap
;@ Stores hMultiPurpose0-3 (a 4-byte draw command: VRAM high, low, mode, tile) at `out`; returns
;@ the address of its last byte.
;@ test: out = rand(0xC000, 0xDFF0)
StoreDrawCommand4::
;> mem[out] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld [hli], a
;> mem[out + 1] = hMultiPurpose1
	ldh a, [hMultiPurpose1]
	ld [hli], a
;> mem[out + 2] = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	ld [hli], a
;> mem[out + 3] = hMultiPurpose3
	ldh a, [hMultiPurpose3]
	ld [hl], a
;> return out + 3
	ret


;@ def GameplayWorldMapHandler()
;@ path: menu/worldmap
;@ Game mode 7, the map of Koholint island (opened with Select, or from a library book): resets the
;@ sprite allocation and runs the current step of WorldMapSteps.
;@ test: skip jumps through a table
GameplayWorldMapHandler::
;> wOAMNextIndex = 0
	xor a
	ld [wOAMNextIndex], a
;> return WorldMapSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: menu/worldmap
;@ The steps of the map screen (dw per value of wGameplaySubtype): 0 fade the world out, 1-2 load the
;@ tiles, 3 fade in, 4 move the cursor and show place names, 5 fade out and return to the world.
WorldMapSteps::
	dw WorldMapInit
	dw WorldMapLoadTiles
	dw WorldMapLoadTiles2
	dw WorldMapFadeIn
	dw WorldMapInput
	dw ReturnToWorld

;@ def WorldMapInit()
;@ path: menu/worldmap
;@ Step 0: keeps drawing Link and the entities while the world fades out. Then lowers the music volume,
;@ puts the map cursor on Link's overworld room, decides whether that room's place marker shows (see
;@ WorldMapRoomPlaces), switches the window off and requests the map screen (layout 8).
;@ test: skip calls the fade and sprite code
WorldMapInit::
;> DrawLinkOAM()                           # draw Link
	call DrawLinkOAM
;> UpdateEntitiesBank1()
	call UpdateEntitiesBank1
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	jr nz, .done
;> hVolumeRight = 3                      # music quieter
	ld a, $03
	ldh [hVolumeRight], a
;> hVolumeLeft = 0x30
	ld a, $30
	ldh [hVolumeLeft], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> hBaseScrollX = 0
	ldh [hBaseScrollX], a
;> wScrollXOffset = 0
	ld [wScrollXOffset], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wInventoryAppearing = 0
	ld [wInventoryAppearing], a
;> wWorldMapMarkerAppearTimer = 0
	ld [wWorldMapMarkerAppearTimer], a
;> wWorldMapMarkerHideTimer = 0
	ld [wWorldMapMarkerHideTimer], a
;> wWorldMapCursor = wOverworldRoom
	ld a, [wOverworldRoom]
	ld [wWorldMapCursor], a
;>@p place = mem[WorldMapRoomPlaces + wOverworldRoom]
	ld e, a
	ld d, $00
	ld hl, WorldMapRoomPlaces
	add hl, de
	ld a, [hl]
;>@k kind = (place >> 4 & 7) + 1 if place else 0         # the marker type
	and a
	jr z, .marker
	swap a
	and $07
	inc a
;> if kind == 1:                         # kind 1 only for a visited room (or from the book: never)
	cp $01
	jr nz, .marker
;>@k1     kind = 1 if not wMapScreenFromBook and wRoomStatus[wOverworldRoom] & 0x20 else 0
	ld a, [wMapScreenFromBook]
	and a
	ld a, $00
	jr nz, .marker
	ld hl, wRoomStatus
	add hl, de
;=@k1
	ld a, [hl]
	and $20
	ld a, $00
	jr z, .marker
	ld a, $01
.marker
;> wWorldMapMarkerType = kind
	ld [wWorldMapMarkerType], a
;> wWorldMapMarkerRoom = wWorldMapCursor
	ld a, [wWorldMapCursor]
	ld [wWorldMapMarkerRoom], a
;> wLCDControl = rLCDC & ~0x20           # window off
	ldh a, [rLCDC]
	and $df
	ld [wLCDControl], a
;> rLCDC = wLCDControl
	ldh [rLCDC], a
;> ClearRoomTransitionState()
	call ClearRoomTransitionState
;> wBGMapToLoad = 8
	ld a, $08
	ld [wBGMapToLoad], a
.done
	ret


;@ def WorldMapLoadTiles()
;@ path: menu/worldmap
;@ Step 1: requests tile set $0B.
WorldMapLoadTiles::
;> wTileMapToLoad = 0x0B
	ld a, $0b
	ld [wTileMapToLoad], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldMapLoadTiles2()
;@ path: menu/worldmap
;@ Step 2: requests tile set $0E.
WorldMapLoadTiles2::
;> wTileMapToLoad = 0x0E
	ld a, $0e
	ld [wTileMapToLoad], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldMapFadeIn()
;@ path: menu/worldmap
;@ Step 3: fades the map in; when done, moves on with the confirm sound.
;@ test: skip calls the fade code
WorldMapFadeIn::
;> FadePalettesIn()
	call FadePalettesIn
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     PlayConfirmSound()
	call PlayConfirmSound
.done
	ret


;@ def WorldMapInput()
;@ path: menu/worldmap
;@ Step 4. A shows the name of the place under the cursor in a dialogue box (at the top when the
;@ cursor is in the lower part of the island): a marked place if it may be shown, otherwise the name
;@ of the area (2 x 2 rooms, WorldMapRegionTexts; rooms $24 and $34 have text $76). B or Select
;@ (only Select with the debug switch) closes the map. With the debug switch (ROM byte $0003, 0 in
;@ this cartridge) holding B+Select warps Link to the room under the cursor. Then draws Link's
;@ marker, moves the cursor and draws the place marker.
;@ test: skip opens dialogues
WorldMapInput::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return WorldMapDraw()
	jp nz, WorldMapDraw
;> if hJoypadPressed & 0x10:             # A
	ldh a, [hJoypadPressed]
	and $10
	jr z, .notA
;>@p     place = mem[WorldMapRoomPlaces + wWorldMapCursor]
	ld a, [wWorldMapCursor]
	ld e, a
	ld d, $00
	ld hl, WorldMapRoomPlaces
	add hl, de
	ld a, [hl]
;>@c     if place and (place & 0xF0 or (not wMapScreenFromBook and wRoomStatus[wWorldMapCursor] & 0x20)):
	and a
	jr z, .region
	ld e, a
	and $f0
	jr nz, .named
	ld a, [wMapScreenFromBook]
;=@c
	and a
	jr nz, .region
	push de
	ld a, [wWorldMapCursor]
	ld e, a
	ld hl, wRoomStatus
;=@c
	add hl, de
	pop de
	ld a, [hl]
	and $20
	jr z, .region
.named
;>@n         text = mem[WorldMapPlaceTexts + place]
	ld d, $00
	ld hl, WorldMapPlaceTexts
	add hl, de
	ld a, [hl]
	jr .show
;>     elif wWorldMapCursor == 0x24 or wWorldMapCursor == 0x34:
.region
	ld a, [wWorldMapCursor]
	cp $24
	jr z, .special
	cp $34
	jr nz, .area
;>         text = 0x76
.special
	ld a, $76
	jr .show
;>     else:
.area
;>@a         text = mem[WorldMapRegionTexts + ((wWorldMapCursor >> 5) * 8 + ((wWorldMapCursor & 0x0F) >> 1))]
	rra
	and $07
	ld e, a
	ld a, [wWorldMapCursor]
	rra
	rra
;=@a
	and $38
	or e
	ld e, a
	ld d, $00
	ld hl, WorldMapRegionTexts
	add hl, de
;=@a
	ld a, [hl]
.show
;>     OpenDialog(text)
	call OpenDialog
;>@ds     wDialogState = 0x01 if wWorldMapCursor >= 0x70 else 0x81      # box at the top / bottom
	ld a, [wWorldMapCursor]
	cp $70
	ld a, $01
	jr nc, .state
	ld a, $81
.state
;=@ds
	ld [wDialogState], a
;>     return
	ret
.notA
;> if mem[0x0003] and hJoypadHeld == 0x60:     # debug only: B+Select warps to the cursor
	ld a, [$0003]
	and a
	jr z, .close
	ldh a, [hJoypadHeld]
	cp $60
	jr nz, .close
;>     wGameplayType = 0x0B
	ld a, $0b
	ld [wGameplayType], a
;>     StartWarpFadeOutWithNoise()
	call StartWarpFadeOutWithNoise
;>     wWarpType = 0                     # the overworld
	ld a, $00
	ld [wWarpType], a
;>     wWarpMap = 0
	ld [wWarpMap], a
;>     wWarpRoom = wWorldMapCursor
	ld a, [wWorldMapCursor]
	ld [wWarpRoom], a
;>     wWarpDestX = 0x48
	ld a, $48
	ld [wWarpDestX], a
;>     wWarpDestY = 0x52
	ld a, $52
	ld [wWarpDestY], a
;>@wp     wWarpDestPosition = (hLinkY - 8) & 0xF0 | hLinkX >> 4
	ldh a, [hLinkX]
	swap a
	and $0f
	ld e, a
	ldh a, [hLinkY]
	sub $08
;=@wp
	and $f0
	or e
	ld [wWarpDestPosition], a
;>     wGameplaySubtype = 7              # the world's play step
	ld a, $07
	ld [wGameplaySubtype], a
;>     return
	ret
.close
;> keys = 0x40 if mem[0x0003] else 0x60  # Select (debug) / B or Select
	ld e, $40
	ld a, [$0003]
	and a
	jr nz, .keys
	ld e, $60
.keys
;> if hJoypadPressed & keys:
	ldh a, [hJoypadPressed]
	and e
	jr z, WorldMapDraw
;>     wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>     wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> WorldMapDraw()                        # falls through into it

;@ def WorldMapDraw()
;@ path: menu/worldmap
;@ The map screen's sprites for this frame: Link's marker, the cursor (moved by the D-pad) and the
;@ place marker.
;@ test: skip draws sprites
WorldMapDraw::
;> DrawWorldMapLinkMarker()
	call DrawWorldMapLinkMarker
;> WorldMapMoveCursor()
	call WorldMapMoveCursor
;> DrawWorldMapPlaceMarker()
	call DrawWorldMapPlaceMarker
	ret


;@ def SceneReturnToWorld()
;@ path: event/scene
;@ Shared last step of the beach and picture scenes: draws the tower sprites once more (DrawTowerSprites)
;@ and falls into ReturnToWorld.
;@ test: skip calls scene code
SceneReturnToWorld::
;> DrawTowerSprites()                    # the tower sprites once more
	call DrawTowerSprites
;> ReturnToWorld()                       # falls through into it

;@ def ReturnToWorld()
;@ path: world/load
;@ Last step of the map screen and the menus: fades out; when done, restores the music volume and
;@ goes back to game mode $0B at step 2 (reload the room's tiles; tile set 6 indoors, 7 outside), with
;@ the room transition state cleared and the window reset.
;@ test: skip calls the fade code
ReturnToWorld::
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter != 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
;>     return
	jr nz, ResetWindow.done
;> wItemButtonsDisabled = 0
	xor a
	ld [wItemButtonsDisabled], a
;> wRoomEntitySetupDone = 0
	ld [wRoomEntitySetupDone], a
;> hBaseScrollX = 0
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wLinkFrozen = 0
	ld [wLinkFrozen], a
;> hVolumeRight = 7                      # full volume again
	ld a, $07
	ldh [hVolumeRight], a
;> hVolumeLeft = 0x70
	ld a, $70
	ldh [hVolumeLeft], a
;> wGameplayType = 0x0B
	ld a, $0b
	ld [wGameplayType], a
;> hSkipMusicSelection = 0x0B
	ldh [hSkipMusicSelection], a
;> wGameplaySubtype = 2
	ld a, $02
	ld [wGameplaySubtype], a
;>@t wTileMapToLoad = 6 if wIsIndoor else 7
	ld a, [wIsIndoor]
	and a
	ld a, $06
	jr nz, .store
	ld a, $07
.store
;=@t
	ld [wTileMapToLoad], a
;> ClearRoomTransitionState()            # falls through into it

;@ def ClearRoomTransitionState()
;@ path: world/load
;@ Clears the 12 bytes of room transition state from wRoomTransitionState on, then resets the window
;@ (falls into ResetWindow).
ClearRoomTransitionState::
;>@f fill(addr(wRoomTransitionState), 0, 12)
	ld hl, wRoomTransitionState
	ld e, $00
.clear
	xor a
	ld [hli], a
	inc e
;=@f
	ld a, e
	cp $0c
	jr nz, .clear
;> ResetWindow()                         # falls through into it

;@ def ResetWindow()
;@ path: world/load
;@ Puts the window (the status bar) back to its normal place: below the screen at the top ($80) and
;@ x 6; also sets $C150 to 8 and stops the inventory slide.
ResetWindow::
;> wWindowY = 0x80
	ld a, $80
	ld [wWindowY], a
;> rWX = 6
	ld a, $06
	ldh [rWX], a
;> wInventorySlideSpeed = 8
	ld a, $08
	ld [wInventorySlideSpeed], a
;> wInventoryAppearing = 0
	xor a
	ld [wInventoryAppearing], a
.done
	ret


;@ def DrawWorldMapLinkMarker()
;@ path: menu/worldmap
;@ Puts the marker of Link's position (tile $3E, OAM entry 39) on his overworld room's square of the
;@ map (8 pixels per room); it blinks by switching palettes every 8 frames.
DrawWorldMapLinkMarker::
;> wOAMBuffer[156] = ((wOverworldRoom >> 1) & 0x78) + 0x18      # y: row * 8
	ld hl, wOAMBuffer + 156
	ld a, [wOverworldRoom]
	rra
	and $78
	add $18
	ld [hli], a
;>@x wOAMBuffer[157] = ((swap(wOverworldRoom) >> 1) & 0x78) + 0x18     # x: column * 8
	ld a, [wOverworldRoom]
	swap a
	rra
	and $78
	add $18
	ld [hli], a
;> wOAMBuffer[158] = 0x3E
	ld [hl], $3e
	inc hl
;> wOAMBuffer[159] = (hFrameCounter << 1) & 0x10
	ldh a, [hFrameCounter]
	rla
	and $10
	ld [hl], a
	ret


;@ path: menu/worldmap
;@ Dialogue shown for each area of the island when the cursor is not on a nameable place: 64 bytes,
;@ one per area of 2 x 2 rooms (index = (room row / 2) * 8 + room column / 2), each a dialogue number
;@ (low byte; $62-$7B) for OpenDialog.
WorldMapRegionTexts::
	db $6c, $6c, $6c, $6b, $6c, $6c, $6c, $6c, $76, $76, $79, $79, $79, $79, $79, $79
	db $6a, $6a, $72, $7a, $78, $78, $71, $71, $6a, $6a, $72, $70, $78, $78, $71, $71
	db $6a, $6e, $69, $69, $69, $69, $77, $71, $6e, $6e, $69, $69, $69, $69, $77, $77
	db $7b, $7b, $6d, $62, $74, $74, $6f, $68, $73, $73, $73, $74, $74, $74, $75, $68
;@ path: menu/worldmap
;@ Dialogue number (low byte, for OpenDialog) of each place of the map, indexed by the place number of
;@ WorldMapRoomPlaces ($00-$4F, one byte each; 0 = none).
WorldMapPlaceTexts::
	db $00, $d9, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd
	db $00, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $00, $00, $00, $00, $00, $00, $00
	db $00, $7c, $67, $00, $00, $80, $65, $00, $64, $88, $00, $00, $00, $00, $00, $00
	db $00, $5e, $5f, $7f, $7e, $7d, $82, $84, $85, $86, $87, $81, $66, $83, $5e, $63
	db $00, $61, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: menu/worldmap
;@ The place shown on the map for each of the 256 overworld rooms (16 x 16, index = room number; one
;@ byte, 0 = no place). Bits 0-3 with bits 4-6 form the place number (index into WorldMapPlaceTexts);
;@ bits 4-6 + 1 give the kind of marker drawn on the map (WorldMapMarkerIcons 1-5 for $0x-$4x);
;@ places $01-$0F (kind 1) are shown and named only once the room has been visited (or always when
;@ the map is opened from the library book).
WorldMapRoomPlaces::
	db $00, $00, $00, $00, $00, $00, $3e, $00, $0e, $00, $39, $00, $00, $00, $17, $00
	db $18, $3d, $00, $00, $00, $00, $06, $0c, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $12, $00, $00, $00, $07, $00
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

;@ def ShowCurrentPlaceName()
;@ path: menu/worldmap
;@ Opens the dialogue naming the place of the current room (WorldMapRoomPlaces / WorldMapPlaceTexts).
;@ test: skip opens a dialogue
ShowCurrentPlaceName::
;>@p return OpenDialog(mem[WorldMapPlaceTexts + mem[WorldMapRoomPlaces + hMapRoom]])
	ldh a, [hMapRoom]
	ld e, a
	ld d, $00
	ld hl, WorldMapRoomPlaces
	add hl, de
	ld e, [hl]
;=@p
	ld hl, WorldMapPlaceTexts
	add hl, de
	ld a, [hl]
	jp OpenDialog


;@ path: menu/worldmap
;@ Map cursor step for the Right / Left keys, indexed by hJoypad & 3 (one signed byte: none, +1, -1;
;@ the column wraps around within the row).
WorldMapCursorDX::
	db $00, $01, $ff

;@ path: menu/worldmap
;@ Map cursor step for the Up / Down keys, indexed by (hJoypad >> 2) & 3 (one byte added to the room:
;@ none, -$10 one row up, +$10 one row down).
WorldMapCursorDY::
	db $00, $f0, $10

;@ def WorldMapMoveCursor()
;@ path: menu/worldmap
;@ Moves the map cursor one room with the D-pad (a held direction repeats; left / right wrap within the
;@ row). A room never visited stops it with an error sound, unless the map came from the library book
;@ or the debug toggle is on. Entering a room with a place starts its marker popup, leaving one makes
;@ the marker disappear. Not while a marker animates or a dialogue is open. Then draws the cursor
;@ frame (OAM entries 32-33) with four blinking arrows around it (entries 34-37).
;@ test: skip plays sounds and draws sprites
WorldMapMoveCursor::
;> old = wWorldMapCursor
	ld a, [wWorldMapCursor]
	ldh [hMultiPurpose0], a
;> if not (wWorldMapMarkerHideTimer or wWorldMapMarkerAppearTimer or wDialogState):
	ld a, [wWorldMapMarkerHideTimer]
	ld hl, wWorldMapMarkerAppearTimer
	or [hl]
	ld hl, wDialogState
	or [hl]
	jp nz, .draw
;>@k0     keys = hJoypadPressed
;>     if not hJoypadHeld & 0x0F:
	ldh a, [hJoypadHeld]
	ld c, a
	ld hl, wDpadRepeatCounter
	and $0f
	jr nz, .held
;>         wDpadRepeatCounter = 0
	xor a
	ld [hl], a
	jr .pressed
;>     else:
.held
;>         wDpadRepeatCounter += 1
	ld a, [hl]
	inc a
	ld [hl], a
;>         if wDpadRepeatCounter == 0x18:
	cp $18
	jr nz, .pressed
;>             wDpadRepeatCounter = 0x15
	ld [hl], $15
;>             keys = hJoypadHeld         # repeat the held direction (still in c)
	jr .move
.pressed
;=@k0
	ldh a, [hJoypadPressed]
	ld c, a
.move
;>@x     wWorldMapCursor = wWorldMapCursor & 0xF0 | (wWorldMapCursor + mem[WorldMapCursorDX + (keys & 3)]) & 0x0F
	ld a, c
	and $03
	ld e, a
	ld d, $00
	ld hl, WorldMapCursorDX
	add hl, de
;=@x
	ld a, [wWorldMapCursor]
	ld d, a
	and $f0
	ld e, a
	ld a, d
	add [hl]
;=@x
	and $0f
	or e
	ld [wWorldMapCursor], a
;>@y     wWorldMapCursor = u8(wWorldMapCursor + mem[WorldMapCursorDY + ((keys >> 2) & 3)])
	ld a, c
	rra
	rra
	and $03
	ld e, a
	ld d, $00
;=@y
	ld hl, WorldMapCursorDY
	add hl, de
	ld a, [wWorldMapCursor]
	add [hl]
	ld hl, hMultiPurpose0
	ld [wWorldMapCursor], a
;>     if wWorldMapCursor != old:
	cp [hl]
	jr z, .draw
;>@v         if not wMapScreenFromBook and wRoomStatus[wWorldMapCursor] == 0 and not wDebugToggle:
	ld e, a
	ld d, $00
	ld hl, wRoomStatus
	add hl, de
	ld a, [wMapScreenFromBook]
	and a
;=@v
	jr nz, .visited
	ld a, [hl]
	and $ff
	jr nz, .visited
	ld a, [wDebugToggle]
	and a
;=@v
	jr nz, .visited
;>             hJingle = 0x09            # error sound
	ld a, $09
	ldh [hJingle], a
;>             wWorldMapCursor = old
	ldh a, [hMultiPurpose0]
	ld [wWorldMapCursor], a
	jr .draw
;>         else:
.visited
;>             PlayCursorSound()
	call PlayCursorSound
;>@p             place = mem[WorldMapRoomPlaces + wWorldMapCursor]
	ld hl, WorldMapRoomPlaces
	add hl, de
	ld a, [hl]
;>             kind = ((place >> 4) & 7) + 1 if place else 0
	and a
	jr z, .noPlace
	swap a
	and $07
	inc a
	ld c, a
;>@k             if kind > 1 or (kind == 1 and not wMapScreenFromBook and wRoomStatus[wWorldMapCursor] & 0x20):
	cp $01
	jr nz, .place
	ld a, [wMapScreenFromBook]
	and a
	jr nz, .noPlace
	ld hl, wRoomStatus
;=@k
	add hl, de
	ld a, [hl]
	and $20
	jr z, .noPlace
.place
;>                 if wWorldMapMarkerType == 0:
	ld a, [wWorldMapMarkerType]
	and a
	jr nz, .setType
;>                     wWorldMapMarkerAppearTimer = 0x10
	ld a, $10
	ld [wWorldMapMarkerAppearTimer], a
.setType
;>                 wWorldMapMarkerType = kind
	ld a, c
	ld [wWorldMapMarkerType], a
;>                 wWorldMapMarkerRoom = wWorldMapCursor
	ld a, [wWorldMapCursor]
	ld [wWorldMapMarkerRoom], a
	jr .draw
;>             elif wWorldMapMarkerType:
.noPlace
	ld a, [wWorldMapMarkerType]
	and a
	jr z, .draw
;>                 wWorldMapMarkerType = 0
	xor a
	ld [wWorldMapMarkerType], a
;>                 wWorldMapMarkerHideTimer = 0x10
	ld a, $10
	ld [wWorldMapMarkerHideTimer], a
.draw
;>@yy y = ((wWorldMapCursor >> 1) & 0x78) + 0x14
	ld hl, wOAMBuffer + 128
	ld a, [wWorldMapCursor]
	rra
	and $78
	add $14
	ld e, a
;>@xx x = ((swap(wWorldMapCursor) >> 1) & 0x78) + 0x14
	ld a, [wWorldMapCursor]
	swap a
	rra
	and $78
	add $14
	ld d, a
;>@f1 wOAMBuffer[128:132] = [y, x, 0xF0, 0x00]          # the cursor frame, left half
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld [hl], $f0
	inc hl
;=@f1
	ld [hl], $00
	inc hl
;>@f2 wOAMBuffer[132:136] = [y, x + 8, 0xF0, 0x20]      # right half, mirrored
	ld a, e
	ld [hli], a
	ld a, d
	add $08
	ld [hli], a
	ld [hl], $f0
;=@f2
	inc hl
	ld [hl], $20
;> if not hFrameCounter & 0x10:           # the arrows blink
	ldh a, [hFrameCounter]
	and $10
	jr nz, .done
;>@a1     wOAMBuffer[136:140] = [y + 4, x - 10, 0xF6, 0x00]    # left arrow
	ld hl, wOAMBuffer + 136
	ld a, e
	add $04
	ld [hli], a
	ld a, d
	add $f6
;=@a1
	ld [hli], a
	ld a, $f6
	ld [hli], a
	ld a, $00
	ld [hli], a
;>@a2     wOAMBuffer[140:144] = [y + 4, x + 0x13, 0xF6, 0x20]  # right arrow
	ld a, e
	add $04
	ld [hli], a
	ld a, d
	add $13
	ld [hli], a
;=@a2
	ld a, $f6
	ld [hli], a
	ld a, $20
	ld [hli], a
;>@a3     wOAMBuffer[144:148] = [y - 10, x + 4, 0xF8, 0x00]    # up arrow
	ld a, e
	add $f6
	ld [hli], a
	ld a, d
	add $04
	ld [hli], a
;=@a3
	ld a, $f8
	ld [hli], a
	ld a, $00
	ld [hli], a
;>@a4     wOAMBuffer[148:152] = [y + 0x0B, x + 4, 0xF8, 0x40]  # down arrow (flipped)
	ld a, e
	add $0b
	ld [hli], a
	ld a, d
	add $04
	ld [hli], a
;=@a4
	ld a, $f8
	ld [hli], a
	ld a, $40
	ld [hli], a
.done
	ret


;@ path: menu/worldmap
;@ The place marker popup of the map screen as it grows: 4 frames (wWorldMapMarkerFrame 0-3, frame 0 =
;@ full size) of 8 sprites, 32 bytes per frame; each sprite 4 bytes: y offset, x offset (signed, from
;@ the popup's corner), tile ($F2 corner / $F4 edge), attributes (flips $20 / $40 / $60). Drawn by
;@ DrawWorldMapPlaceMarkerSprites.
WorldMapMarkerFrames::
	db $f8, $f8, $f2, $00, $f8, $00, $f4, $00, $f8, $08, $f4, $20, $f8, $10, $f2, $20
	db $08, $f8, $f2, $40, $08, $00, $f4, $40, $08, $08, $f4, $60, $08, $10, $f2, $60
	db $fa, $fa, $f2, $00, $fa, $02, $f4, $00, $fa, $06, $f4, $20, $fa, $0e, $f2, $20
	db $06, $fa, $f2, $40, $06, $02, $f4, $40, $06, $06, $f4, $60, $06, $0e, $f2, $60
	db $fc, $fc, $f2, $00, $fc, $04, $f4, $00, $fc, $04, $f4, $20, $fc, $0c, $f2, $20
	db $04, $fc, $f2, $40, $04, $04, $f4, $40, $04, $04, $f4, $60, $04, $0c, $f2, $60
	db $fe, $fe, $f2, $00, $fe, $04, $f4, $00, $fe, $04, $f4, $20, $fe, $0a, $f2, $20
	db $02, $fe, $f2, $40, $02, $04, $f4, $40, $02, $04, $f4, $60, $02, $0a, $f2, $60
;@ path: menu/worldmap
;@ The icon inside the map's place marker for each marker kind 1-5 (wWorldMapMarkerType - 1): 5
;@ records of 4 bytes = tile and attributes of the left sprite, tile and attributes of the right one
;@ (tiles $20-$2E).
WorldMapMarkerIcons::
	db $20, $00, $22, $00, $24, $00, $26, $00, $28, $00, $2a, $00, $2c, $00, $2e, $00
	db $2c, $00, $2e, $00

;@ path: menu/worldmap
;@ Sprite x position of the place marker popup for each screen quarter (index = 2 if the marked room
;@ is in the lower half + 1 if it is in the left half): the popup goes to the opposite side.
WorldMapPopupX::
	db $28, $78, $28, $78

;@ path: menu/worldmap
;@ Sprite y position of the place marker popup for each screen quarter (see WorldMapPopupX).
WorldMapPopupY::
	db $28, $28, $78, $78

;@ def DrawWorldMapPlaceMarker()
;@ path: menu/worldmap
;@ Draws the place marker popup, keeping entity slot 0's wEntityPhysicsFlags (borrowed by the sprite
;@ drawing).
;@ test: skip draws sprites
DrawWorldMapPlaceMarker::
;> saved = wEntityPhysicsFlags[0]
	ld a, [wEntityPhysicsFlags]
	push af
;> DrawWorldMapPlaceMarkerSprites()
	call DrawWorldMapPlaceMarkerSprites
;> wEntityPhysicsFlags[0] = saved
	pop af
	ld [wEntityPhysicsFlags], a
	ret


;@ def DrawWorldMapPlaceMarkerSprites()
;@ path: menu/worldmap
;@ Animates and draws the place marker popup: while wWorldMapMarkerAppearTimer / HideTimer run, the
;@ frame (timer / 4) grows or shrinks it; at full size the place's icon is drawn inside (OAM entries
;@ 12-13). The popup sits in the screen quarter opposite to the marked room.
;@ test: skip draws sprites through the entity sprite routine
DrawWorldMapPlaceMarkerSprites::
;> if wWorldMapMarkerHideTimer:
	ld a, [wWorldMapMarkerHideTimer]
	and a
	jr z, .notHiding
;>     wWorldMapMarkerHideTimer -= 1
	dec a
	ld [wWorldMapMarkerHideTimer], a
;>     frame = (~wWorldMapMarkerHideTimer >> 2) & 3      # growing smaller
	cpl
	jr .frame
;> elif wWorldMapMarkerAppearTimer:
.notHiding
	ld a, [wWorldMapMarkerAppearTimer]
	and a
	jr z, .still
;>     wWorldMapMarkerAppearTimer -= 1
	dec a
	ld [wWorldMapMarkerAppearTimer], a
;>@fr     frame = (wWorldMapMarkerAppearTimer >> 2) & 3
.frame
	rra
	rra
	and $03
	jr .draw
;> elif wWorldMapMarkerType == 0:
.still
	ld a, [wWorldMapMarkerType]
	and a
;>     return
	jp z, .done
;> else:
;>     frame = 0
	ld a, $00
.draw
;> wWorldMapMarkerFrame = frame
	ld [wWorldMapMarkerFrame], a
;> hActiveEntitySpriteVariant = frame
	ldh [hActiveEntitySpriteVariant], a
;> wOAMNextIndex = 0
	ld a, $00
	ld [wOAMNextIndex], a
;> wEntityPhysicsFlags[0] = 8            # 8 sprites
	ld a, $08
	ld [wEntityPhysicsFlags], a
;> wActiveEntitySlot = 0
	ld a, $00
	ld [wActiveEntitySlot], a
;> hActiveEntityFlipAttribute = 0
	ldh [hActiveEntityFlipAttribute], a
;>@q quarter = (2 if wWorldMapMarkerRoom >= 0x70 else 0) + (1 if wWorldMapMarkerRoom & 0x0F < 8 else 0)
	ld e, $00
	ld a, [wWorldMapMarkerRoom]
	cp $70
	jr c, .top
	ld e, $02
.top
;=@q
	and $0f
	cp $08
	jr nc, .right
	inc e
.right
;> hActiveEntityX = mem[WorldMapPopupX + quarter]
	ld d, $00
	ld hl, WorldMapPopupX
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = mem[WorldMapPopupY + quarter]
	ld hl, WorldMapPopupY
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>@s sprites = WorldMapMarkerFrames + wWorldMapMarkerFrame * 32
	ld a, [wWorldMapMarkerFrame]
	rla
	rla
	rla
	rla
	rla
;=@s
	and $e0
	ld e, a
	ld d, $00
	ld hl, WorldMapMarkerFrames
	add hl, de
;> wOAMNextIndex = 8
	ld a, $08
	ld [wOAMNextIndex], a
;> hActiveEntityTileOffset = 0
	xor a
	ldh [hActiveEntityTileOffset], a
;> DrawEntitySprites(sprites, 8)                 # draw 8 sprites at the popup position
	ld c, $08
	call DrawEntitySprites
;> if wWorldMapMarkerFrame != 0 or wWorldMapMarkerType - 1 >= 0x80:
	ld a, [wWorldMapMarkerFrame]
	cp $00
	jr nz, .done
	ld a, [wWorldMapMarkerType]
	dec a
	cp $80
;>     return
	jr nc, .done
;> hActiveEntitySpriteVariant = wWorldMapMarkerType - 1
	ldh [hActiveEntitySpriteVariant], a
;>@i1 wOAMBuffer[48:52] = [hActiveEntityDrawY, hActiveEntityX] + [mem[WorldMapMarkerIcons + 4 * hActiveEntitySpriteVariant], mem[WorldMapMarkerIcons + 4 * hActiveEntitySpriteVariant + 1]]
	ld de, wOAMBuffer + 48
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ldh a, [hActiveEntityX]
;=@i1
	ld [de], a
	inc de
	ldh a, [hActiveEntitySpriteVariant]
	ld c, a
	ld b, $00
	sla c
;=@i1
	rl b
	sla c
	rl b
	ld hl, WorldMapMarkerIcons
	add hl, bc
	ld a, [hli]
;=@i1
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
;>@i2 wOAMBuffer[52:56] = [hActiveEntityDrawY, hActiveEntityX + 8] + [mem[WorldMapMarkerIcons + 4 * hActiveEntitySpriteVariant + 2], mem[WorldMapMarkerIcons + 4 * hActiveEntitySpriteVariant + 3]]
	ldh a, [hActiveEntityDrawY]
	ld [de], a
	inc de
	ldh a, [hActiveEntityX]
	add $08
	ld [de], a
;=@i2
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
;> return
.done
	ret


;@ path: menu/fileselect
;@ Background draw commands for the hearts of each file in the file menus: 3 records of 21 bytes (one
;@ per file): two commands of 10 bytes = VRAM address (high, low), $06 (7 tiles across), seven blank
;@ tiles ($7E) for the two rows of up to 7 hearts ($98CB/$98EB, $992B/$994B, $998B/$99AB), then the
;@ end byte 0. DrawFileHearts copies one and fills in the hearts.
FileHeartsTemplates::
	db $98, $cb, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $98, $eb, $06, $7e, $7e, $7e
	db $7e, $7e, $7e, $7e, $00, $99, $2b, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $99
	db $4b, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $00, $99, $8b, $06, $7e, $7e, $7e
	db $7e, $7e, $7e, $7e, $99, $ab, $06, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $00

;@ def DrawFileHearts()
;@ path: menu/fileselect
;@ Appends the heart rows of file hMultiPurpose4 (0-2) to the draw queue: one heart tile ($AE) per
;@ heart container (hMultiPurpose3), 7 per row; full, partly full and empty hearts all use the same
;@ tile here. hMultiPurpose2 is the file's health in eighths of a heart.
;@ test: skip queues draw commands
DrawFileHearts::
;>@c cmd = wDrawCommand + wDrawCommandsSize
	ld a, [wDrawCommandsSize]
	ld e, a
	ld d, $00
;> wDrawCommandsSize += 0x14
	add $14
	ld [wDrawCommandsSize], a
;=@c
	ld hl, wDrawCommand
	add hl, de
	push de
;>@t copy(cmd, FileHeartsTemplates + 21 * hMultiPurpose4, 21)
	ld bc, FileHeartsTemplates
	ldh a, [hMultiPurpose4]
	and a
	jr z, .copy
	ld bc, FileHeartsTemplates + 21
	cp $01
;=@t
	jr z, .copy
	ld bc, FileHeartsTemplates + 42
.copy
	ld e, $15
.copyLoop
	ld a, [bc]
	inc bc
;=@t
	ld [hli], a
	dec e
	jr nz, .copyLoop
;> out = cmd + 3                         # the first tile of the first row
	pop de
	ld hl, wDrawCommand + 3
	add hl, de
;> n = 0
	ld c, $00
;> health = hMultiPurpose2
	ldh a, [hMultiPurpose2]
	and a
	jr z, .rest
;>@h while True:                         # the full hearts
	ldh [hMultiPurpose0], a
.full
;>     health -= 8
	ldh a, [hMultiPurpose0]
	sub $08
	ldh [hMultiPurpose0], a
;>     if health < 0:
;>@b         break
	jr c, .partial
;>@w     mem[out] = 0xAE; out += 1; n += 1
	ld a, $ae
	ld [hli], a
	inc c
;>@w2     if n == 7: out += 3                # skip to the second row's tiles
	ld a, c
	cp $07
	jr nz, .next
	ld a, l
	add $03
	ld l, a
.next
;=@h
	jr .full
.partial
;> if health + 8:                        # a partly full heart
	add $08
	jr z, .rest
;>@pp     mem[out] = 0xAE; out += 1
	ld a, $ae
	ld [hli], a
	jr .count
.rest
;>@e while n != hMultiPurpose3:           # the remaining (empty) hearts
	ldh a, [hMultiPurpose3]
	cp c
	jr z, .done
;>     mem[out] = 0xAE; out += 1
	ld a, $ae
	ld [hli], a
.count
;>     n += 1
	inc c
;>     if n == 7: out += 3
	ld a, c
	cp $07
	jr nz, .loop
	ld a, l
	add $03
	ld l, a
.loop
;=@e
	jr .rest
.done
	ret


;@ def UpdateSaveFilesExist()
;@ path: menu/fileselect
;@ Sets wSaveFilesExist: bit i for each file i whose name has a non-zero character.
UpdateSaveFilesExist::
;> wSaveFilesExist = 0
	xor a
	ld de, wSaveFilesExist
	ld [de], a
;>@l for c in range(15):                    # the 3 names, 5 characters each
	ld b, $01
	ld c, $00
	ld hl, wSaveSlotNames
.loop
;>     if wSaveSlotNames[c]:
	ld a, [hli]
	and a
	jr z, .next
;>         wSaveFilesExist |= 1 << (c // 5)
	ld a, [de]
	or b
	ld [de], a
.next
;=@l
	inc c
	ld a, c
	cp $05
	jr nz, .not5
	ld b, $02
.not5
;=@l
	cp $0a
	jr nz, .not10
	ld b, $04
.not10
	cp $0f
	jr nz, .loop
	ret


;@ def SaveGame()
;@ path: save
;@ Saves the game: refills an empty health bar, stores the current dungeon's item flags, then copies
;@ the $380 bytes from wRoomStatus on (rooms, inventory, progress) into the file's slot in battery RAM.
;@ test: skip writes battery RAM
SaveGame::
;> if wHealth == 0:
	ld a, [wHealth]
	and a
	jr nz, .store
;>@h     wHealth = mem[DefaultHealthByMaxHearts + wMaxHearts]
	ld a, [wMaxHearts]
	ld e, a
	ld d, $00
	ld hl, DefaultHealthByMaxHearts
	add hl, de
	ld a, [hl]
;=@h
	ld [wHealth], a
.store
;> SaveDungeonItemFlags()                           # StoreDungeonItemFlags in this bank
	call SaveDungeonItemFlags
;>@d dest = mem16[SaveSlotDataAddresses + 2 * wSaveSlot]
	ld a, [wSaveSlot]
	sla a
	ld e, a
	ld d, $00
	ld hl, SaveSlotDataAddresses
	add hl, de
;=@d
	ld a, [hli]
	ld h, [hl]
	ld l, a
;>@c copy(dest, wRoomStatus, 0x380)      # (battery RAM switched on for each byte)
	ld bc, wRoomStatus
	ld de, $0380
.copy
	call EnableSRAM
	ld a, [bc]
	inc bc
;=@c
	call EnableSRAM
	ld [hli], a
	dec de
	ld a, e
	or d
	jr nz, .copy
;> return
	ret

;@ def StoreDungeonItemFlags()
;@ path: save
;@ Indoors on maps 0-9, copies the current dungeon's five item flags (wDungeonHasMap ...
;@ wDungeonSmallKeys) back into wDungeonItemFlags. Keeps bc.
StoreDungeonItemFlags::
;>@i if wIsIndoor and hMapId < 0x0A:
	push bc
	ld a, [wIsIndoor]
	and a
	jr z, .done
	ldh a, [hMapId]
	cp $0a
;=@i
	jr nc, .done
;>@d     copy(wDungeonItemFlags + hMapId * 5, addr(wDungeonHasMap), 5)
	ld e, a
	sla a
	sla a
	add e
	ld e, a
	ld d, $00
;=@d
	ld hl, wDungeonItemFlags
	add hl, de
	ld de, wDungeonHasMap
	ld c, $05
.copy
	ld a, [de]
	inc de
;=@d
	ld [hli], a
	dec c
	jr nz, .copy
.done
	pop bc
	ret


;@ path: world/load
;@ X shift (low byte) for an entity of the next room while the screen scrolls, indexed by
;@ wRoomTransitionDirection (0 right, 1 left, 2 up, 3 down, 4 none; one byte each). With
;@ ScrollShiftXHigh this is a signed 16-bit shift: +160 to the right, -160 to the left.
ScrollShiftXLow::
	db $a0, $60, $00, $00, $00

;@ path: world/load
;@ X shift, high byte (see ScrollShiftXLow).
ScrollShiftXHigh::
	db $00, $ff, $00, $00, $00

;@ path: world/load
;@ Y shift (low byte) for an entity of the next room while the screen scrolls, indexed by
;@ wRoomTransitionDirection; with ScrollShiftYHigh: -128 upwards, +128 downwards.
ScrollShiftYLow::
	db $00, $00, $80, $80, $00

;@ path: world/load
;@ Y shift, high byte (see ScrollShiftYLow).
ScrollShiftYHigh::
	db $00, $00, $ff, $00, $00

;@ def PlaceEntityForRoomScroll(slot: de)
;@ path: world/load
;@ For an entity loaded while the screen scrolls into a new room: gives it the next load order number
;@ (hMultiPurposeD) and moves it by the scroll's width (ScrollShift tables), so that it sits in the
;@ new room as it scrolls in. Keeps bc.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
PlaceEntityForRoomScroll::
;> wEntityLoadOrder[slot] = hMultiPurposeD
	ld hl, wEntityLoadOrder
	add hl, de
	ldh a, [hMultiPurposeD]
	ld [hl], a
;> hMultiPurposeD += 1
	inc a
	ldh [hMultiPurposeD], a
;> dir = wRoomTransitionDirection
	push bc
	ld a, [wRoomTransitionDirection]
	ld c, a
	ld b, $00
;> hMultiPurpose0 = mem[ScrollShiftXLow + dir]
	ld hl, ScrollShiftXLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = mem[ScrollShiftXHigh + dir]
	ld hl, ScrollShiftXHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = mem[ScrollShiftYLow + dir]
	ld hl, ScrollShiftYLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = mem[ScrollShiftYHigh + dir]
	ld hl, ScrollShiftYHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
;>@x x = ((wEntityPosXHigh[slot] << 8) | wEntityX[slot]) + ((hMultiPurpose1 << 8) | hMultiPurpose0); wEntityX[slot] = lo(x); wEntityPosXHigh[slot] = hi(x)
	ld hl, wEntityX
	add hl, de
	ldh a, [hMultiPurpose0]
	add [hl]
	ld [hl], a
	rr c
;=@x
	ld hl, wEntityPosXHigh
	add hl, de
	ldh a, [hMultiPurpose1]
	rl c
	adc [hl]
	ld [hl], a
;>@y y = ((wEntityPosYHigh[slot] << 8) | wEntityY[slot]) + ((hMultiPurpose3 << 8) | hMultiPurpose2); wEntityY[slot] = lo(y); wEntityPosYHigh[slot] = hi(y)
	ld hl, wEntityY
	add hl, de
	ldh a, [hMultiPurpose2]
	add [hl]
	ld [hl], a
	rr c
;=@y
	ld hl, wEntityPosYHigh
	add hl, de
	ldh a, [hMultiPurpose3]
	rl c
	adc [hl]
	ld [hl], a
;> return
	pop bc
	ret


;@ def RememberRecentRoom()
;@ path: world/load
;@ Keeps the list of the last six rooms entered. When the current room is not in it, it replaces the
;@ oldest entry, and the room that drops out forgets which of its enemies were defeated (they come
;@ back the next time).
;@ test: wRecentRoomsIndex = rand(0, 5)
RememberRecentRoom::
;>@s if hMapRoom in wRecentRooms:
	ld c, $06
	ldh a, [hMapRoom]
	ld hl, wRecentRooms
.search
	cp [hl]
	jr z, .done
;=@s
	inc hl
	dec c
	jr nz, .search
;>     return
;> wRecentRoomsIndex = (wRecentRoomsIndex + 1) % 6
	ld a, [wRecentRoomsIndex]
	inc a
	cp $06
	jr nz, .store
	xor a
.store
	ld [wRecentRoomsIndex], a
;> old = wRecentRooms[wRecentRoomsIndex]
	ld e, a
	ld d, $00
	ld hl, wRecentRooms
	add hl, de
	ld e, [hl]
;> wRecentRooms[wRecentRoomsIndex] = hMapRoom
	ldh a, [hMapRoom]
	ld [hl], a
;> wRoomDefeatedEntityBits[old] = 0
	ld hl, wRoomDefeatedEntityBits
	add hl, de
	ld [hl], $00
.done
	ret


;@ path: unused
;@ 99 bytes of $FF that nothing uses (free space).
UnusedFreeSpace5C8D::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff

;@ def DisableSRAMAndClearOAM()
;@ path: system/memory
;@ Switches battery RAM off (writes $FF to the MBC's RAM enable register) and hides all 40 sprites of
;@ the OAM buffer (y = 0).
;@ test: skip writes the MBC register
DisableSRAMAndClearOAM::
;> mem[0x0000] = 0xFF                    # battery RAM off
	ld hl, $0000
	ld [hl], $ff
;>@l for i in range(40):
	ld b, $28
	xor a
	ld hl, wOAMBuffer
.loop
;>     wOAMBuffer[4 * i] = 0
	ld [hli], a
	inc hl
	inc hl
	inc hl
;=@l
	dec b
	jr nz, .loop
	ret


;@ def HideSpritesUnderWindow()
;@ path: gfx/oam
;@ Hides the sprites that the window would show through: while the inventory slides, every sprite
;@ below the window's top; while a dialogue box is open, the sprites of OAM entries 9-39 inside the box
;@ (box at the bottom when wDialogState bit 7 is set: y >= $58; otherwise at the top: y < $3E) - except,
;@ during dialogue $04F, the sprites with tiles $9A-$9F.
HideSpritesUnderWindow::
;> if wInventoryAppearing:
	ld a, [wInventoryAppearing]
	and a
	jr z, .dialog
;>@b     for i in range(40):
	ld hl, wOAMBuffer
	ld a, [wWindowY]
	add $08
	ld d, a
	ld e, $28
.below
;>         if wOAMBuffer[4 * i] >= u8(wWindowY + 8):
	ld a, [hl]
	cp d
	jr c, .keep
;>             wOAMBuffer[4 * i] = 0
	ld [hl], $00
.keep
;=@b
	inc hl
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, .below
;>     return
	ret
.dialog
;> if wWindowY == 0 or wDialogState == 0:
	ld a, [wWindowY]
	and a
	ret z
	ld a, [wDialogState]
	and a
;>     return
	ret z
;> limit = 0x58 if wDialogState & 0x80 else 0x3E
	ld d, $3e
	ld a, [wDialogState]
	and $80
	jr z, .limit
	ld d, $58
.limit
;>@s for i in range(9, 40):
	ld e, $1f
	ld hl, wOAMBuffer + 36
.sprite
;>@in     inside = wOAMBuffer[4 * i] >= limit if wDialogState & 0x80 else wOAMBuffer[4 * i] < limit
	ld a, [hl]
	cp d
	ld a, [wDialogState]
	bit 7, a
	jr nz, .compared
	ccf
.compared
;>@h     if inside and not (wDialogIndex == 0x4F and wDialogIndexHigh == 0 and 0x9A <= wOAMBuffer[4 * i + 2] < 0xA0):
	jr c, .next
	ld a, [wDialogIndex]
	cp $4f
	jr nz, .hide
	ld a, [wDialogIndexHigh]
	and a
;=@h
	jr nz, .hide
	inc hl
	inc hl
	ld a, [hld]
	dec hl
	cp $9a
;=@h
	jr c, .hide
	cp $a0
	jr c, .next
.hide
;>         wOAMBuffer[4 * i] = 0
	ld [hl], $00
.next
;=@s
	inc hl
	inc hl
	inc hl
	inc hl
	dec e
	jr nz, .sprite
;> return
	ret


;@ def SpawnFollowers()
;@ path: npc/followers
;@ After entering a room, creates the companions that follow Link next to him: the flying rooster
;@ (entity $D5), the ghost ($D4), Marin ($C1, SpawnMarinFollower) and BowWow ($6D, SpawnBowWowFollower).
;@ Not in side views, in the eight dungeons, on maps $13, $14 and $16, or in rooms $FD and $B1.
;@ test: skip spawns entities
SpawnFollowers::
;> if wIsIndoor:
	ld a, [wIsIndoor]
	and a
	jr z, .rooster
;>@n     if hIsSideScrolling or hMapId in (0x16, 0x14, 0x13) or hMapId < 0x0A or hMapRoom in (0xFD, 0xB1):
	ldh a, [hIsSideScrolling]
	and a
	ret nz
	ldh a, [hMapId]
	cp $16
	ret z
;=@n
	cp $14
	ret z
	cp $13
	ret z
	cp $0a
	ret c
;=@n
	ldh a, [hMapRoom]
	cp $fd
	ret z
	cp $b1
;>         return
	ret z
.rooster
;> if wIsRoosterFollowingLink == 1:
	ld a, [wIsRoosterFollowingLink]
	cp $01
	jr nz, .ghost
;>@r1     for slot in reversed(range(16)):  # remove a rooster still there
	ld e, $0f
	ld d, $00
.removeRooster
;>@r2         if wEntityType[slot] == 0xD5 and wEntityStatus[slot]:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $d5
	jr nz, .nextRooster
	ld hl, wEntityStatus
;=@r2
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextRooster
;>             wEntityStatus[slot] = 0
	ld [hl], d
.nextRooster
;=@r1
	dec e
	ld a, e
	cp $ff
	jr nz, .removeRooster
;>     slot, full = SpawnEntity(bc, 0xD5)
	ld a, $d5
	call SpawnEntity
;>     wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;>@ry     wEntityY[slot] = hLinkY + wLinkSpriteDY
	ldh a, [hLinkY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
.ghost
;> if wIsGhostFollowingLink == 1:
;>@g1     for slot in reversed(range(16)):  # remove a ghost still there
;>@g2         if wEntityType[slot] == 0xD4 and wEntityStatus[slot]:
;>@g3             wEntityStatus[slot] = 0
;>@g4     slot, full = SpawnEntity(bc, 0xD4)
;>@g5     wEntityX[slot] = hLinkX
;>@g6     wEntityY[slot] = hLinkY + wLinkSpriteDY
;>@g7     wEntityPrivate1[slot] += 1
;>@g8     hJingle = 0x2D
	ld a, [wIsGhostFollowingLink]
	cp $01
	jr z, .spawnGhost
;>@e elif wIsGhostFollowingLink == 2 and not wIsIndoor and hMapRoom >= 0x40 and wDungeonFlags[3] & 2:
	cp $02
	jr nz, SpawnMarinFollower
	ld a, [wIsIndoor]
	and a
	jr nz, SpawnMarinFollower
;=@e
	ldh a, [hMapRoom]
	cp $40
	jr c, SpawnMarinFollower
	ld a, [wDungeonFlags + 3]
	and $02
	jr z, SpawnMarinFollower
;>@w     wIsGhostFollowingLink = 0 if wPowerBraceletLevel >= 2 else 1
	ld a, [wPowerBraceletLevel]
	cp $02
	jr c, .follow
	xor a
	jr .setGhost
.follow
	ld a, $01
.setGhost
;=@w
	ld [wIsGhostFollowingLink], a
;> return SpawnMarinFollower()           # (also after spawning the ghost: falls through)
	jr SpawnMarinFollower
.spawnGhost
;=@g1
	ld e, $0f
	ld d, $00
.removeGhost
;=@g2
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $d4
	jr nz, .nextGhost
	ld hl, wEntityStatus
;=@g2
	add hl, de
	ld a, [hl]
	and a
	jr z, .nextGhost
;=@g3
	ld [hl], d
.nextGhost
;=@g1
	dec e
	ld a, e
	cp $ff
	jr nz, .removeGhost
;=@g4
	ld a, $d4
	call SpawnEntity
;=@g5
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;=@g6
	ldh a, [hLinkY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;=@g7
	ld hl, wEntityPrivate1
	add hl, de
	inc [hl]
;=@g8
	ld a, $2d
	ldh [hJingle], a

;@ def SpawnMarinFollower()
;@ path: npc/followers
;@ The part of SpawnFollowers for Marin (entity $C1): when she walks with Link, removes an old copy,
;@ creates her at Link's position with her position trail filled with his, and makes her follow. In
;@ room $A4 of map $11 Link is held for a moment ($79 frames). After the reunion she starts $20 / $10
;@ pixels off. Without Marin, goes on with BowWow (SpawnBowWowFollower).
;@ test: skip spawns entities
SpawnMarinFollower::
;> if not wIsMarinFollowingLink:
	ld a, [wIsMarinFollowingLink]
	and a
;>     return SpawnBowWowFollower()
	jp z, SpawnBowWowFollower
;>@m1 for slot in reversed(range(16)):
	ld e, $0f
	ld d, $00
.remove
;>@m2     if wEntityType[slot] == 0xC1 and wEntityStatus[slot]:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $c1
	jr nz, .next
	ld hl, wEntityStatus
;=@m2
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;>         wEntityStatus[slot] = 0
	ld [hl], d
.next
;=@m1
	dec e
	ld a, e
	cp $ff
	jr nz, .remove
;> slot, full = SpawnEntity(bc, 0xC1)
	ld a, $c1
	call SpawnEntity
;> wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> FillFollowerTrail_01(wFollowerTrailX, hLinkX)
	ld hl, wFollowerTrailX
	call FillFollowerTrail_01
;>@y wEntityY[slot] = hLinkY + wLinkSpriteDY
	ldh a, [hLinkY]
	ld hl, wLinkSpriteDY
	add [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;> FillFollowerTrail_01(wFollowerTrailY, wEntityY[slot])
	ld hl, wFollowerTrailY
	call FillFollowerTrail_01
;> wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
;> FillFollowerTrail_01(wFollowerTrailZ, hLinkPositionZ)
	ld hl, wFollowerTrailZ
	call FillFollowerTrail_01
;> wEntityPrivate4[slot] = 1
	ld hl, wEntityPrivate4
	add hl, de
	ld [hl], $01
;> wEntityTimer1[slot] = 0x0C
	ld hl, wEntityTimer1
	add hl, de
	ld [hl], $0c
;> if hMapRoom == 0xA4 and hMapId == 0x11:
	ldh a, [hMapRoom]
	cp $a4
	jr nz, .direction
	ldh a, [hMapId]
	cp $11
	jr nz, .direction
;>     hJingle = 0x08
	ld a, $08
	ldh [hJingle], a
;>     wLinkFrozen = 0x08
	ld [wLinkFrozen], a
;>     wEntityTimer2[slot] = 0x79
	ld hl, wEntityTimer2
	add hl, de
	ld [hl], $79
.direction
;> FillFollowerTrail_01(wFollowerTrailDir, hLinkDirection)
	ldh a, [hLinkDirection]
	ld hl, wFollowerTrailDir
	call FillFollowerTrail_01
;> if wMarinReunion:
	ld a, [wMarinReunion]
	and a
	jr z, .done
;>     wEntityX[slot] = hLinkX + 0x20
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	add $20
	ld [hl], a
;>     wEntityY[slot] = hLinkY + 0x10
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	add $10
	ld [hl], a
.done
	ret


;@ def FillFollowerTrail_01(table: hl, value: a)
;@ path: npc/followers
;@ Writes `value` into the 16 bytes at `table` (one of the follower trail arrays).
;@ test: table = rand(0xC000, 0xDFF0); value = rand(0, 255)
FillFollowerTrail_01::
;> fill(table, value, 16)
	ld c, $10
.fill
	ld [hli], a
	dec c
	jr nz, .fill
	ret


;@ def SpawnBowWowFollower()
;@ path: npc/followers
;@ The part of SpawnFollowers for BowWow (entity $6D): when he follows Link (state 1), removes an old
;@ copy and creates him at Link's position. Not in room $A7.
;@ test: skip spawns entities
SpawnBowWowFollower::
;> if hMapRoom == 0xA7:
	ldh a, [hMapRoom]
	cp $a7
;>     return
	ret z
;> if wIsBowWowFollowingLink == 1:
	ld a, [wIsBowWowFollowingLink]
	cp $01
	jr nz, .done
;>@b1     for slot in reversed(range(16)):
	ld e, $0f
	ld d, $00
.remove
;>@b2         if wEntityType[slot] == 0x6D and wEntityStatus[slot]:
	ld hl, wEntityType
	add hl, de
	ld a, [hl]
	cp $6d
	jr nz, .next
	ld hl, wEntityStatus
;=@b2
	add hl, de
	ld a, [hl]
	and a
	jr z, .next
;>             wEntityStatus[slot] = 0
	ld [hl], d
.next
;=@b1
	dec e
	ld a, e
	cp $ff
	jr nz, .remove
;>     slot, full = SpawnEntity(bc, 0x6D)
	ld a, $6d
	call SpawnEntity
;>     wEntityX[slot] = hLinkX
	ldh a, [hLinkX]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>     wEntityY[slot] = hLinkY
	ldh a, [hLinkY]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>     wEntityZ[slot] = hLinkPositionZ
	ldh a, [hLinkPositionZ]
	ld hl, wEntityZ
	add hl, de
	ld [hl], a
.done
	ret


;@ def StartIntroMode()
;@ path: title
;@ Goes back to game mode 0, the intro: stops the sound, blacks out all palettes, resets the scroll
;@ and the raised blocks, and makes Start ignored for $18 frames.
;@ test: skip resets the sound engine
StartIntroMode::
;> ResetSoundEngine()
	call ResetSoundEngine
;> wGameplayType = 0
	xor a
	ld [wGameplayType], a
;> wGameplaySubtype = 0
	ld [wGameplaySubtype], a
;> wOBJ0Palette = 0
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0
	ld [wOBJ1Palette], a
;> wBGPalette = 0
	ld [wBGPalette], a
;> rBGP = 0
	ldh [rBGP], a
;> rOBP0 = 0
	ldh [rOBP0], a
;> rOBP1 = 0
	ldh [rOBP1], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> hBaseScrollX = 0
	ldh [hBaseScrollX], a
;> wRaisedBlocksState = 0
	ld [wRaisedBlocksState], a
;> wRaisedBlockStep = 0
	ld [wRaisedBlockStep], a
;> hStartButtonDelay = 0x18
	ld a, $18
	ldh [hStartButtonDelay], a
	ret


;@ path: text/debug
;@ Address in bank $0F of the tile of each hex digit 0-F (16 dw: $5700, $5710 ... $5790 for 0-9, $5800
;@ ... $5850 for A-F), used by DrawDebugDialogIndex.
HexDigitTileAddresses::
	dw FontTiles + $700, FontTiles + $710, FontTiles + $720, FontTiles + $730, FontTiles + $740, FontTiles + $750, FontTiles + $760, FontTiles + $770
	dw FontTiles + $780, FontTiles + $790, Tiles0F5800, Tiles0F5800 + $10, Tiles0F5800 + $20, Tiles0F5800 + $30, Tiles0F5800 + $40, Tiles0F5800 + $50

;@ def DrawDebugDialogIndex()
;@ path: text/debug
;@ Animated-tiles routine of the text debugger room: shows wDebugDialogIndex as two hex digits by
;@ copying the digits' tiles from bank $0F into background tiles $6C and $6D ($96C0 / $96D0) and
;@ putting those tiles at $9909-$990A.
;@ test: skip copies from another bank into VRAM
DrawDebugDialogIndex::
;>@l CopyDataFromBank(0x0F, mem16[HexDigitTileAddresses + 2 * (wDebugDialogIndex & 0x0F)], 0x96D0, 0x10)   # low digit
	ld a, [wDebugDialogIndex]
	and $0f
	sla a
	ld e, a
	ld d, $00
	ld hl, HexDigitTileAddresses
;=@l
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $96d0
	ld bc, $0010
;=@l
	ld a, $0f
	call CopyDataFromBank
;>@h CopyDataFromBank(0x0F, mem16[HexDigitTileAddresses + 2 * (wDebugDialogIndex >> 4)], 0x96C0, 0x10)     # high digit
	ld a, [wDebugDialogIndex]
	swap a
	and $0f
	sla a
	ld e, a
	ld d, $00
;=@h
	ld hl, HexDigitTileAddresses
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $96c0
;=@h
	ld bc, $0010
	ld a, $0f
	call CopyDataFromBank
;> mem[0x9909] = 0x6C
	ld a, $6c
	ld [$9909], a
;> mem[0x990A] = 0x6D
	inc a
	ld [$990a], a
	ret


;@ def ShowDungeonNameText()
;@ path: world/dungeons
;@ Called by the main loop when the countdown at $FFB4 runs out: shows the name of the current dungeon
;@ (dialogue $56 + hMapId), unless Link is in a special motion state or the debug toggle is on.
;@ test: skip opens a dialogue
ShowDungeonNameText::
;> if wLinkMotionState == 0 and not wDebugToggle:
	ld a, [wLinkMotionState]
	cp $00
	jr nz, .done
	ld a, [wDebugToggle]
	and a
	jr nz, .done
;>     OpenDialog(hMapId + 0x56)
	ldh a, [hMapId]
	add $56
	call OpenDialog
.done
	ret


;@ def GameplayMarinBeachHandler()
;@ path: event/marin_beach
;@ Game mode 9: Link and Marin sit on the beach and look at the sea, seagulls fly past and Marin talks to
;@ Link. Counts the scene's two timers down (wMarinBeachTimer only while no dialogue is open), then runs the
;@ current step of MarinBeachSteps.
;@ test: skip jump table
GameplayMarinBeachHandler::
;> if not wDialogState and wMarinBeachTimer:
	ld a, [wDialogState]
	and a
	jr nz, .counter
	ld a, [wMarinBeachTimer]
	and a
	jr z, .counter
;>     wMarinBeachTimer -= 1
	dec a
	ld [wMarinBeachTimer], a
.counter
;> if wSceneCounter:
	ld a, [wSceneCounter]
	and a
	jr z, .dispatch
;>     wSceneCounter -= 1
	dec a
	ld [wSceneCounter], a
.dispatch
;> return MarinBeachSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: event/marin_beach
;@ The 14 steps of the beach scene (dw code addresses, indexed by wGameplaySubtype): fade out, load the
;@ tiles, set up the screen, fade in, scroll down to the beach, four rounds of Marin's talk (dialogues
;@ $1D8-$1DC; a "no" to her question goes back to step 5), the end, and the return to the world.
MarinBeachSteps::
	dw MarinBeachFadeOut       ; 0
	dw MarinBeachLoadTiles     ; 1
	dw MarinBeachInit          ; 2
	dw MarinBeachFadeIn        ; 3
	dw MarinBeachScrollDown    ; 4
	dw MarinBeachTalk1         ; 5
	dw MarinBeachPause1        ; 6
	dw MarinBeachTalk2         ; 7
	dw MarinBeachPause2        ; 8
	dw MarinBeachTalk3         ; 9
	dw MarinBeachCheckAnswer   ; 10
	dw MarinBeachTalk4         ; 11
	dw MarinBeachEnd           ; 12
	dw ReturnToWorld           ; 13

;@ def MarinBeachFadeOut()
;@ path: event/marin_beach
;@ Step 0: freezes Link and fades the room out to white; when the fade is done, clears the room
;@ transition and the scene sprites and asks for tile set $0F.
;@ test: skip calls the fade
MarinBeachFadeOut::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;>     ClearRoomTransitionState()
	call ClearRoomTransitionState
;>     ClearSceneObjects()
	call ClearSceneObjects
;>     wTileMapToLoad = 0x0F
	ld a, $0f
	ld [wTileMapToLoad], a
.done
	ret

;@ def MarinBeachLoadTiles()
;@ path: event/marin_beach
;@ Step 1: asks for the beach tile set ($13).
MarinBeachLoadTiles::
;> wTileMapToLoad = 0x13
	ld a, $13
	ld [wTileMapToLoad], a
;> wMenuCursor = 0
	xor a
	ld [wMenuCursor], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def MarinBeachInit()
;@ path: event/marin_beach
;@ Step 2: asks for the beach screen ($13), hides the window, starts the view scrolled up by $70 lines
;@ (hBaseScrollY $90), sets the sound timers and places the scene's sprites in the effect slots: two
;@ seagulls (type 1) that fly across - slot 0 from the top left, slot 1 from the right after $40 frames -
;@ and five birds (type 2) hovering in a row above the sea (slots 2-6).
MarinBeachInit::
;> wBGMapToLoad = 0x13
	ld a, $13
	ld [wBGMapToLoad], a
;> wWindowY = 0xFF
	ld a, $ff
	ld [wWindowY], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> wTransitionSequenceCounter = 0
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> hBaseScrollY = 0x90
	ld a, $90
	ldh [hBaseScrollY], a
;> wSeaWavesSoundTimer = 0x40
	ld a, $40
	ld [wSeaWavesSoundTimer], a
;> wSeagullCryTimer = 0xA0
	ld a, $a0
	ld [wSeagullCryTimer], a
;> wVfxY[0] = 0xE0
	ld a, $e0
	ld [wVfxY], a
;> wVfxX[0] = 0x00
	ld a, $00
	ld [wVfxX], a
;> wVfxType[0] = 0x01
	ld a, $01
	ld [wVfxType], a
;> wVfxSpeedY[0] = 0x0C
	ld a, $0c
	ld [wVfxSpeedY], a
;> wVfxSpeedX[0] = 0x08
	ld a, $08
	ld [wVfxSpeedX], a
;> wVfxTimer[0] = 0x00
	ld a, $00
	ld [wVfxTimer], a
;> wEntityWorkRAM3[0] = 0x00
	ld [wEntityWorkRAM3], a
;> wVfxY[1] = 0x20
	ld a, $20
	ld [wVfxY + 1], a
;> wVfxX[1] = 0xA0
	ld a, $a0
	ld [wVfxX + 1], a
;> wVfxType[1] = 0x01
	ld a, $01
	ld [wVfxType + 1], a
;> wVfxSpeedY[1] = 0x08
	ld a, $08
	ld [wVfxSpeedY + 1], a
;> wVfxSpeedX[1] = 0xF8
	ld a, $f8
	ld [wVfxSpeedX + 1], a
;> wVfxTimer[1] = 0x40
	ld a, $40
	ld [wVfxTimer + 1], a
;> wEntityWorkRAM3[1] = 0x24
	ld a, $24
	ld [wEntityWorkRAM3 + 1], a
;> wVfxY[2] = 0x48
	ld a, $48
	ld [wVfxY + 2], a
;> wVfxX[2] = 0x30
	ld a, $30
	ld [wVfxX + 2], a
;> wVfxType[2] = 0x02
	ld a, $02
	ld [wVfxType + 2], a
;> wVfxSpeedY[2] = 0x00
	ld a, $00
	ld [wVfxSpeedY + 2], a
;> wVfxSpeedX[2] = 0x00
	ld a, $00
	ld [wVfxSpeedX + 2], a
;> wVfxTimer[2] = 0x00
	ld a, $00
	ld [wVfxTimer + 2], a
;> wEntityWorkRAM3[2] = 0x02
	ld a, $02
	ld [wEntityWorkRAM3 + 2], a
;> wVfxY[3] = 0x3C
	ld a, $3c
	ld [wVfxY + 3], a
;> wVfxX[3] = 0x40
	ld a, $40
	ld [wVfxX + 3], a
;> wVfxType[3] = 0x02
	ld a, $02
	ld [wVfxType + 3], a
;> wVfxSpeedY[3] = 0x00
	ld a, $00
	ld [wVfxSpeedY + 3], a
;> wVfxSpeedX[3] = 0x00
	ld a, $00
	ld [wVfxSpeedX + 3], a
;> wVfxTimer[3] = 0x00
	ld a, $00
	ld [wVfxTimer + 3], a
;> wEntityWorkRAM3[3] = 0x00
	ld a, $00
	ld [wEntityWorkRAM3 + 3], a
;> wVfxY[4] = 0x40
	ld a, $40
	ld [wVfxY + 4], a
;> wVfxX[4] = 0x50
	ld a, $50
	ld [wVfxX + 4], a
;> wVfxType[4] = 0x02
	ld a, $02
	ld [wVfxType + 4], a
;> wVfxSpeedY[4] = 0x00
	ld a, $00
	ld [wVfxSpeedY + 4], a
;> wVfxSpeedX[4] = 0x00
	ld a, $00
	ld [wVfxSpeedX + 4], a
;> wVfxTimer[4] = 0x00
	ld a, $00
	ld [wVfxTimer + 4], a
;> wEntityWorkRAM3[4] = 0x00
	ld a, $00
	ld [wEntityWorkRAM3 + 4], a
;> wVfxY[5] = 0x3C
	ld a, $3c
	ld [wVfxY + 5], a
;> wVfxX[5] = 0x60
	ld a, $60
	ld [wVfxX + 5], a
;> wVfxType[5] = 0x02
	ld a, $02
	ld [wVfxType + 5], a
;> wVfxSpeedY[5] = 0x00
	ld a, $00
	ld [wVfxSpeedY + 5], a
;> wVfxSpeedX[5] = 0x00
	ld a, $00
	ld [wVfxSpeedX + 5], a
;> wVfxTimer[5] = 0x00
	ld a, $00
	ld [wVfxTimer + 5], a
;> wEntityWorkRAM3[5] = 0x00
	ld a, $00
	ld [wEntityWorkRAM3 + 5], a
;> wVfxY[6] = 0x44
	ld a, $44
	ld [wVfxY + 6], a
;> wVfxX[6] = 0x68
	ld a, $68
	ld [wVfxX + 6], a
;> wVfxType[6] = 0x02
	ld a, $02
	ld [wVfxType + 6], a
;> wVfxSpeedY[6] = 0x00
	ld a, $00
	ld [wVfxSpeedY + 6], a
;> wVfxSpeedX[6] = 0x00
	ld a, $00
	ld [wVfxSpeedX + 6], a
;> wVfxTimer[6] = 0x00
	ld a, $00
	ld [wVfxTimer + 6], a
;> wEntityWorkRAM3[6] = 0x00
	ld a, $00
	ld [wEntityWorkRAM3 + 6], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ path: event/marin_beach
;@ Fade-in palettes for the background and OBJ1 (16 bytes). MarinBeachFadeIn reads entry
;@ wMarinBeachFadeStep + (hFrameCounter & 3); each value is there four times, so the fade blends between
;@ neighbouring palettes from frame to frame.
MarinBeachBGPalettes::
	db $00, $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4

;@ path: event/marin_beach
;@ The same fade for OBJ0 (16 bytes, read with the same index as MarinBeachBGPalettes).
MarinBeachOBJ0Palettes::
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c

;@ def MarinBeachFadeIn()
;@ path: event/marin_beach
;@ Step 3: fades the beach in (one fade step every 8 frames, 12 steps), then goes on with the scroll of
;@ step 4 in the same frame.
;@ test: skip falls through into another unit
MarinBeachFadeIn::
;> if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .palette
;>     wMarinBeachFadeStep += 1
	ld a, [wMarinBeachFadeStep]
	inc a
	ld [wMarinBeachFadeStep], a
;>     if wMarinBeachFadeStep == 0x0C:
	cp $0c
	jr nz, .palette
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.palette
;> i = wMarinBeachFadeStep + (hFrameCounter & 3)
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wMarinBeachFadeStep]
	add e
	ld e, a
;> wBGPalette = mem[MarinBeachBGPalettes + i]
	ld d, $00
	ld hl, MarinBeachBGPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ1Palette = mem[MarinBeachBGPalettes + i]
	ld [wOBJ1Palette], a
;> wOBJ0Palette = mem[MarinBeachOBJ0Palettes + i]
	ld hl, MarinBeachOBJ0Palettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> return MarinBeachScrollDown()   # runs on into the next step's code

;@ def MarinBeachScrollDown()
;@ path: event/marin_beach
;@ Step 4 (and the end of every step 3 frame): scrolls the view down one line every 4 frames until
;@ hBaseScrollY wraps to 0, which shows the beach; then waits $80 frames (wMarinBeachTimer) before Marin
;@ speaks. Updates the scene each frame.
;@ test: skip calls the scene update
MarinBeachScrollDown::
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .draw
;>     hBaseScrollY = (hBaseScrollY + 1) & 0xFF
	ldh a, [hBaseScrollY]
	inc a
	ldh [hBaseScrollY], a
;>     if hBaseScrollY == 0:
	cp $00
	jr nz, .draw
;>         wMarinBeachTimer = 0x80
	ld a, $80
	ld [wMarinBeachTimer], a
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.draw
;> UpdateMarinBeach()
	call UpdateMarinBeach
	ret

;@ def MarinBeachTalk1()
;@ path: event/marin_beach
;@ Step 5: when wMarinBeachTimer has run out, Marin starts to talk (dialogue $1D8). While a dialogue is open,
;@ Marin keeps facing Link (wSceneCounter = 2).
;@ test: skip opens a dialogue
MarinBeachTalk1::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .talking
;>     if wMarinBeachTimer == 0:
	ld a, [wMarinBeachTimer]
	and a
	jr nz, .done
;>         OpenBeachDialog(0xD8)
	ld a, $d8
	call OpenBeachDialog
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
;>     return
	ret
.talking
;> wSceneCounter = 2
	ld a, $02
	ld [wSceneCounter], a
	ret

;@ def MarinBeachPause1()
;@ path: event/marin_beach
;@ Step 6: once the dialogue is closed, waits $C0 frames before the next one; Marin looks at the sea for
;@ the first $20 frames, then turns to Link (wSceneCounter = $80).
;@ test: skip calls the scene update
MarinBeachPause1::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     wSceneCounter = 0x80
	ld a, $80
	ld [wSceneCounter], a
;>     wMarinBeachTimer = 0xC0
	ld a, $c0
	ld [wMarinBeachTimer], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret

;@ def MarinBeachTalk2()
;@ path: event/marin_beach
;@ Step 7: when wMarinBeachTimer has run out, opens dialogue $1D9.
;@ test: skip opens a dialogue
MarinBeachTalk2::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if wMarinBeachTimer == 0:
	ld a, [wMarinBeachTimer]
	and a
	jr nz, .done
;>     OpenBeachDialog(0xD9)
	ld a, $d9
	call OpenBeachDialog
;>     return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
.done
	ret

;@ def MarinBeachPause2()
;@ path: event/marin_beach
;@ Step 8: the same pause as MarinBeachPause1.
;@ test: skip calls the scene update
MarinBeachPause2::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     wSceneCounter = 0x80
	ld a, $80
	ld [wSceneCounter], a
;>     wMarinBeachTimer = 0xC0
	ld a, $c0
	ld [wMarinBeachTimer], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret

;@ def MarinBeachTalk3()
;@ path: event/marin_beach
;@ Step 9: when wMarinBeachTimer has run out, opens dialogue $1DA, which ends with a question.
;@ test: skip opens a dialogue
MarinBeachTalk3::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if wMarinBeachTimer == 0:
	ld a, [wMarinBeachTimer]
	and a
	jr nz, .done
;>     OpenBeachDialog(0xDA)
	ld a, $da
	call OpenBeachDialog
;>     return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
.done
	ret

;@ def MarinBeachCheckAnswer()
;@ path: event/marin_beach
;@ Step 10: once the question is answered: the first answer goes on with dialogue $1DB; the other one
;@ opens dialogue $1DE and goes back to step 5, which asks again after 5 frames.
;@ test: skip opens a dialogue
MarinBeachCheckAnswer::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .talking
;>     if wDialogAnswer == 0:
	ld a, [wDialogAnswer]
	and a
	jr nz, .other
;>         OpenBeachDialog(0xDB)
	ld a, $db
	call OpenBeachDialog
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>         return
	ret
.other
;>     OpenBeachDialog(0xDE)
	ld a, $de
	call OpenBeachDialog
;>     wGameplaySubtype = 5
	ld a, $05
	ld [wGameplaySubtype], a
;>     wMarinBeachTimer = 5
	ld a, $05
	ld [wMarinBeachTimer], a
;>     return
	ret
.talking
;> wSceneCounter = 2
	ld a, $02
	ld [wSceneCounter], a
	ret

;@ def MarinBeachTalk4()
;@ path: event/marin_beach
;@ Step 11: once dialogue $1DB is closed, opens dialogue $1DC and waits $30 frames.
;@ test: skip opens a dialogue
MarinBeachTalk4::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> if not wDialogState:
	ld a, [wDialogState]
	and a
	jr nz, .done
;>     OpenBeachDialog(0xDC)
	ld a, $dc
	call OpenBeachDialog
;>     wMarinBeachTimer = 0x30
	ld a, $30
	ld [wMarinBeachTimer], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret

;@ def MarinBeachEnd()
;@ path: event/marin_beach
;@ Step 12: Marin keeps facing Link; when the last wait is over, stops the music, moves on to the return
;@ to the world (step 13), makes Marin follow Link from now on and removes the scene sprites.
;@ test: skip calls the sound engine
MarinBeachEnd::
;> UpdateMarinBeach()
	call UpdateMarinBeach
;> wSceneCounter = 2
	ld a, $02
	ld [wSceneCounter], a
;> if wMarinBeachTimer:
	ld a, [wMarinBeachTimer]
	and a
;>     return
	ret nz
;> ResetSoundEngine()
	call ResetSoundEngine
;> AdvanceSceneStep()
	call AdvanceSceneStep
;> wIsMarinFollowingLink = 1
	ld a, $01
	ld [wIsMarinFollowingLink], a
;> return ClearSceneObjects()   # runs on into it

;@ def ClearSceneObjects()
;@ path: event/marin_beach
;@ Frees all 16 effect slots (wVfxType = 0), which removes the scene's sprites.
ClearSceneObjects::
;>@l for i in range(16):
	ld e, $10
	ld hl, wVfxType
	xor a
.loop
;>     wVfxType[i] = 0
	ld [hli], a
;=@l
	dec e
	jr nz, .loop
	ret

;@ path: event/marin_beach
;@ Three frames of the two people on the sand, each two sprites side by side: 4 bytes = left tile, left
;@ attributes, right tile, right attributes (the right sprite 8 pixels further right). Marin looking at
;@ the sea (the right half is the left one mirrored), Marin turned to Link, and Link.
MarinBeachSprites::
	db $40, $00, $40, $20   ; Marin, looking at the sea
	db $46, $00, $48, $00   ; Marin, turned to Link
	db $42, $00, $44, $00   ; Link

;@ def UpdateMarinBeach()
;@ path: event/marin_beach
;@ Runs in every frame of the scene from the scroll on: moves and draws the birds (UpdateSceneObjects),
;@ plays the sound of the waves every $A0 frames and a seagull cry at random intervals ($60-$DF frames),
;@ and, once the view has scrolled far enough, draws Marin (x $58) and Link (x $48) on the sand at y $7C
;@ (OAM entries 12-15). Marin is turned to Link while wSceneCounter is 1-$5F.
;@ test: skip calls the bird update
UpdateMarinBeach::
;> UpdateSceneObjects()
	call UpdateSceneObjects
;> waves = wSeaWavesSoundTimer + 1
	ld a, [wSeaWavesSoundTimer]
	inc a
;> if waves == 0xA0:
	cp $a0
	jr nz, .storeWaves
;>     hNoiseSfx = 0x0F
	ld a, $0f
	ldh [hNoiseSfx], a
;>     waves = 0
	xor a
.storeWaves
;> wSeaWavesSoundTimer = waves
	ld [wSeaWavesSoundTimer], a
;> if wSeagullCryTimer == 0:
	ld a, [wSeagullCryTimer]
	and a
	jr nz, .countCry
;>     hJingle = 0x21
	ld a, $21
	ldh [hJingle], a
;>     wSeagullCryTimer = (GetRandomByte() & 0x7F) + 0x60
	call GetRandomByte
	and $7f
	add $60
	ld [wSeagullCryTimer], a
.countCry
;> wSeagullCryTimer -= 1
	dec a
	ld [wSeagullCryTimer], a
;> if (hBaseScrollY - 1) & 0xFF < 0xC0:
	ldh a, [hBaseScrollY]
	dec a
	cp $c0
;>     return
	ret c
;> frame = MarinBeachSprites
	ld de, MarinBeachSprites
;> if wSceneCounter and wSceneCounter < 0x60:
	ld a, [wSceneCounter]
	and a
	jr z, .marin
	cp $60
	jr nc, .marin
;>     frame = MarinBeachSprites + 4
	ld de, MarinBeachSprites + 4
.marin
;> hActiveEntityDrawY = 0x7C
	ld a, $7c
	ldh [hActiveEntityDrawY], a
;> hActiveEntityX = 0x58
	ld a, $58
	ldh [hActiveEntityX], a
;> DrawSceneSpritePair(wOAMBuffer + 0x30, frame)
	ld hl, wOAMBuffer + $30
	call DrawSceneSpritePair
;> hActiveEntityX = 0x48
	ld a, $48
	ldh [hActiveEntityX], a
;> DrawSceneSpritePair(wOAMBuffer + 0x38, MarinBeachSprites + 8)
	ld de, MarinBeachSprites + 8
	ld hl, wOAMBuffer + $38
	call DrawSceneSpritePair
	ret

;@ def DrawSceneSpritePair(oam: hl, frame: de)
;@ path: event/marin_beach
;@ Writes two OAM entries at `oam`: y = hActiveEntityDrawY - hBaseScrollY (also kept in
;@ hMultiPurposeG for the caller), x = hActiveEntityX and hActiveEntityX + 8, tiles and attributes
;@ from the 4-byte record at `frame` (the format of MarinBeachSprites).
;@ test: oam = rand(0xC000, 0xDFF0); frame = rand(0xC000, 0xDFF0)
DrawSceneSpritePair::
;> y = (hActiveEntityDrawY - hBaseScrollY) & 0xFF
	push bc
	ldh a, [hBaseScrollY]
	ld c, a
	ldh a, [hActiveEntityDrawY]
	sub c
;> hMultiPurposeG = y
	ldh [hMultiPurposeG], a
;> mem[oam] = y
	ld [hli], a
;> mem[oam + 1] = hActiveEntityX
	ldh a, [hActiveEntityX]
	ld [hli], a
;> mem[oam + 2] = mem[frame]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[oam + 3] = mem[frame + 1]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[oam + 4] = y
	ldh a, [hActiveEntityDrawY]
	sub c
	ld [hli], a
;> mem[oam + 5] = (hActiveEntityX + 8) & 0xFF
	ldh a, [hActiveEntityX]
	add $08
	ld [hli], a
;> mem[oam + 6] = mem[frame + 2]
	ld a, [de]
	inc de
	ld [hli], a
;> mem[oam + 7] = mem[frame + 3]
	ld a, [de]
	ld [hl], a
	pop bc
	ret

;@ def UpdateSceneObjects()
;@ path: event/marin_beach
;@ Moves and draws the scene's sprites in effect slots 8 down to 0: for each used slot, puts its position
;@ into hActiveEntityX / hActiveEntityDrawY, counts its timer down and runs its handler
;@ (UpdateSceneObject).
;@ test: skip calls the handlers
UpdateSceneObjects::
;>@l for i in range(8, -1, -1):
	ld c, $08
	ld b, $00
.loop
;>     if wVfxType[i]:
	ld hl, wVfxType
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
;>         hActiveEntityX = wVfxX[i]
	push af
	ld hl, wVfxX
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a
;>         hActiveEntityDrawY = wVfxY[i]
	ld hl, wVfxY
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>         if wVfxTimer[i]:
	ld hl, wVfxTimer
	add hl, bc
	ld a, [hl]
	and a
	jr z, .run
;>             wVfxTimer[i] -= 1
	dec [hl]
.run
;>         UpdateSceneObject(wVfxType[i], i)
	pop af
	call UpdateSceneObject
.next
;=@l
	dec c
	ld a, c
	cp $ff
	jr nz, .loop
	ret
;@ def UpdateSceneObject(type: a, slot: c)
;@ path: event/marin_beach
;@ Runs the handler of a scene sprite of effect type `type` (1 or 2) from SceneObjectHandlers.
;@ test: skip jump table
UpdateSceneObject::
;> return SceneObjectHandlers[type - 1](slot)
	dec a
	rst $00

;@ path: event/marin_beach
;@ Handlers of the beach scene's sprites by effect type - 1 (dw code addresses): 1 a seagull flying past,
;@ 2 a bird hovering above the sea.
SceneObjectHandlers::
	dw UpdateSeagull
	dw UpdateSeaBird

;@ path: event/marin_beach
;@ Addresses of the six seagull frames in BeachSeagullFrames (dw, by frame number 0-5).
BeachSeagullFramePointers::
	dw BeachSeagullFrames, BeachSeagullFrames + 4, BeachSeagullFrames + 8
	dw BeachSeagullFrames + 12, BeachSeagullFrames + 16, BeachSeagullFrames + 20

;@ path: event/marin_beach
;@ Six seagull frames of two sprites each (4 bytes: left tile, left attributes, right tile, right
;@ attributes; the right half is the left one mirrored): the wing beat, frame 3 with the wings held still.
BeachSeagullFrames::
	db $50, $00, $50, $20   ; 0
	db $52, $00, $52, $20   ; 1
	db $54, $00, $54, $20   ; 2
	db $56, $00, $56, $20   ; 3
	db $58, $00, $58, $20   ; 4
	db $5a, $00, $5a, $20   ; 5

;@ path: event/marin_beach
;@ The seagulls' flight, 108 frame numbers (0-5), one entry per 6 frames: glides (frame 3) alternate with
;@ series of wing beats. A seagull starts at the entry in its wEntityWorkRAM3 byte (slot 0 at 0, slot 1
;@ at $24).
BeachSeagullFrameSequence::
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $04, $05, $00, $01, $02, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05
	db $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05

;@ def UpdateSeagull(slot: bc)
;@ path: event/marin_beach
;@ Effect type 1, a seagull flying past: waits while its timer runs; then goes on to the next entry of
;@ BeachSeagullFrameSequence every 6 frames (wEntityWorkRAM3[slot] is the entry, wEntityWorkRAM3[$10 +
;@ slot] counts the frames), draws its two sprites at OAM entry 16 + 2 * slot and moves. Every 8 frames
;@ its y speed drops by one, down to -5, so the bird first comes down and then climbs away; once it is
;@ above the top of the screen while climbing (y >= $F0), the slot is freed.
;@ test: skip calls the sprite drawing
UpdateSeagull::
;> if wVfxTimer[slot]:
	ld hl, wVfxTimer
	add hl, bc
	ld a, [hl]
	and a
;>     return
	ret nz
;> wEntityWorkRAM3[0x10 + slot] += 1
	ld hl, wEntityWorkRAM3 + $10
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wEntityWorkRAM3[0x10 + slot] >= 6:
	cp $06
	jr c, .draw
;>     wEntityWorkRAM3[0x10 + slot] = 0
	ld [hl], b
;>     wEntityWorkRAM3[slot] += 1
	ld hl, wEntityWorkRAM3
	add hl, bc
	inc [hl]
.draw
;>@f frame = mem[BeachSeagullFrameSequence + wEntityWorkRAM3[slot]]
	ld hl, wEntityWorkRAM3
	add hl, bc
	ld e, [hl]
	ld d, b
	ld hl, BeachSeagullFrameSequence
	add hl, de
;=@f
	ld e, [hl]
;>@s sprites = mem16[BeachSeagullFramePointers + 2 * frame]
	sla e
	ld d, b
	ld hl, BeachSeagullFramePointers
	add hl, de
	ld a, [hli]
	ld d, [hl]
;=@s
	ld e, a
;>@d DrawSceneSpritePair(wOAMBuffer + 0x40 + 8 * slot, sprites)
	push de
	ld hl, wOAMBuffer + $40
	ld a, c
	rla
	rla
	rla
;=@d
	and $78
	ld e, a
	ld d, b
	add hl, de
	pop de
	call DrawSceneSpritePair
;> MoveSceneObject(slot)
	call MoveSceneObject
;>@v if hFrameCounter & 7 == 0 and wVfxSpeedY[slot] != 0xFB:
	ldh a, [hFrameCounter]
	and $07
	jr nz, .checkGone
	ld hl, wVfxSpeedY
	add hl, bc
	ld a, [hl]
;=@v
	cp $fb
	jr z, .checkGone
;>     wVfxSpeedY[slot] -= 1
	dec [hl]
.checkGone
;>@g if hMultiPurposeG >= 0xF0 and wVfxSpeedY[slot] & 0x80:
	ldh a, [hMultiPurposeG]
	cp $f0
	jr c, .done
	ld hl, wVfxSpeedY
	add hl, bc
	ld a, [hl]
;=@g
	and $80
	ret z
;>     wVfxType[slot] = 0
	ld hl, wVfxType
	add hl, bc
	ld [hl], b
.done
	ret

;@ path: event/marin_beach
;@ Addresses of the four hovering-bird frames in SeaBirdFrames (dw, by frame number 0-3).
SeaBirdFramePointers::
	dw SeaBirdFrames, SeaBirdFrames + 4, SeaBirdFrames + 8, SeaBirdFrames + 12

;@ path: event/marin_beach
;@ Four frames of the hovering birds, two sprites each (4 bytes: left tile, left attributes, right tile,
;@ right attributes; the right half is the left one mirrored). Frames 0-3 are the wing beat, frame 3 is
;@ also shown while a bird sinks.
SeaBirdFrames::
	db $4c, $00, $4c, $20   ; 0
	db $4e, $00, $4e, $20   ; 1
	db $5c, $00, $5c, $20   ; 2
	db $5e, $00, $5e, $20   ; 3

;@ path: event/marin_beach
;@ Speeds a hovering bird picks at random for x and for y (8 signed bytes in 4.4 fixed point: +1/16,
;@ -1/16 or +-2/16 pixel per frame).
SeaBirdRandomSpeeds::
	db $01, $ff, $01, $ff, $fe, $02, $01, $ff

;@ path: event/marin_beach
;@ Home x position of the hovering birds in slots 2-6 (5 bytes; the code reads it as SeaBirdHomeX - 2
;@ indexed by slot). Their home y is $48.
SeaBirdHomeX::
	db $4c, $52, $58, $5c, $60
;@ def UpdateSeaBird(slot: bc)
;@ path: event/marin_beach
;@ Effect type 2, a bird hovering above the sea: beats its wings (frames 0-3, one step every 8 frames)
;@ while rising and holds them still (frame 3) while sinking; draws its two sprites at OAM entry
;@ 16 + 2 * slot and moves. Every 64 frames (offset by 16 frames per slot) it picks new random x and y
;@ speeds from SeaBirdRandomSpeeds, and every $13 frames (wVfxDirection counts) it steps one pixel back
;@ toward its home position (SeaBirdHomeX, y $48), so it wobbles around that spot.
;@ test: skip calls the sprite drawing
UpdateSeaBird::
;> frame = 3
	ld hl, wVfxSpeedY
	add hl, bc
	ld a, [hl]
	ld e, $03
;> if wVfxSpeedY[slot] & 0x80:
	and $80
	jr z, .draw
;>     if hFrameCounter & 7 == 0:
	ld hl, wEntityWorkRAM3
	add hl, bc
	ldh a, [hFrameCounter]
	and $07
	jr nz, .frame
;>         wEntityWorkRAM3[slot] = (wEntityWorkRAM3[slot] + 1) & 3
	ld a, [hl]
	inc a
	and $03
	ld [hl], a
.frame
;>     frame = wEntityWorkRAM3[slot]
	ld e, [hl]
.draw
;>@d DrawSceneSpritePair(wOAMBuffer + 0x40 + 8 * slot, mem16[SeaBirdFramePointers + 2 * frame])
	sla e
	ld d, b
	ld hl, SeaBirdFramePointers
	add hl, de
	ld a, [hli]
	ld d, [hl]
;=@d
	ld e, a
	push de
	ld hl, wOAMBuffer + $40
	ld a, c
	rla
	rla
;=@d
	rla
	and $78
	ld e, a
	ld d, b
	add hl, de
	pop de
;=@d
	call DrawSceneSpritePair
;> MoveSceneObject(slot)
	call MoveSceneObject
;>@t t = (hFrameCounter + 16 * slot) & 0xFF
	ld a, c
	sla a
	sla a
	sla a
	sla a
	ld e, a
;=@t
	ldh a, [hFrameCounter]
	add e
;> hMultiPurposeH = t
	ldh [hMultiPurposeH], a
;> if t & 0x3F == 0:
	and $3f
	jr nz, .speedY
;>@rx     wVfxSpeedX[slot] = mem[SeaBirdRandomSpeeds + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, SeaBirdRandomSpeeds
	add hl, de
;=@rx
	ld a, [hl]
	ld hl, wVfxSpeedX
	add hl, bc
	ld [hl], a
.speedY
;> if (t + 0x40) & 0x3F == 0:   # the same frames as the x speed
	ldh a, [hMultiPurposeH]
	add $40
	and $3f
	jr nz, .home
;>@ry     wVfxSpeedY[slot] = mem[SeaBirdRandomSpeeds + (GetRandomByte() & 7)]
	call GetRandomByte
	and $07
	ld e, a
	ld d, b
	ld hl, SeaBirdRandomSpeeds
	add hl, de
;=@ry
	ld a, [hl]
	ld hl, wVfxSpeedY
	add hl, bc
	ld [hl], a
.home
;> wVfxDirection[slot] += 1
	ld hl, wVfxDirection
	add hl, bc
	ld a, [hl]
	inc a
	ld [hl], a
;> if wVfxDirection[slot] >= 0x13:
	cp $13
	jr c, .done
;>     wVfxDirection[slot] = 0
	ld [hl], b
;>@hx     wVfxX[slot] = (wVfxX[slot] + (1 if (wVfxX[slot] - mem[SeaBirdHomeX + (slot - 2)]) & 0x80 else -1)) & 0xFF
	ld hl, SeaBirdHomeX - 2
	add hl, bc
	ld d, [hl]
	ld hl, wVfxX
	add hl, bc
	ld a, [hl]
;=@hx
	sub d
	ld e, $01
	and $80
	jr nz, .stepX
	ld e, $ff
.stepX
;=@hx
	ld a, [hl]
	add e
	ld [hl], a
;>@hy     wVfxY[slot] = (wVfxY[slot] + (1 if (wVfxY[slot] - 0x48) & 0x80 else -1)) & 0xFF
	ld hl, wVfxY
	add hl, bc
	ld a, [hl]
	sub $48
	ld e, $01
	and $80
;=@hy
	jr nz, .stepY
	ld e, $ff
.stepY
	ld a, [hl]
	add e
	ld [hl], a
.done
	ret

;@ def MoveSceneObject(slot: bc)
;@ path: event/marin_beach
;@ Moves a scene sprite by its x and y speeds (MoveSceneObjectAxis; the y arrays lie $10 bytes after the
;@ x arrays).
;@ test: skip calls a helper twice
MoveSceneObject::
;> MoveSceneObjectAxis(slot)
	call MoveSceneObjectAxis
;> MoveSceneObjectAxis(slot + 0x10)
	push bc
	ld a, c
	add $10
	ld c, a
	call MoveSceneObjectAxis
;> return
	pop bc
	ret

;@ def MoveSceneObjectAxis(slot: bc)
;@ path: event/marin_beach
;@ Adds the signed speed wVfxSpeedX[slot] (4.4 fixed point: the high nibble pixels, the low nibble
;@ sixteenths) to the position wVfxX[slot] with its fraction in wVfxSubX[slot]. With slot + $10 the same
;@ code moves along y (wVfxSpeedY, wVfxY, wVfxSubY).
;@ test: slot = rand(0, 0x1F)
MoveSceneObjectAxis::
;> speed = wVfxSpeedX[slot]
	ld hl, wVfxSpeedX
	add hl, bc
	ld a, [hl]
	push af
;> total = wVfxSubX[slot] + ((speed << 4) & 0xF0)
	swap a
	and $f0
	ld hl, wVfxSubX
	add hl, bc
	add [hl]
;> wVfxSubX[slot] = total & 0xFF
	ld [hl], a
	rl d
;>@m wVfxX[slot] = (wVfxX[slot] + ((speed >> 4) | (0xF0 if speed & 0x80 else 0)) + (total >> 8)) & 0xFF
	ld hl, wVfxX
	add hl, bc
	pop af
	ld e, $00
	bit 7, a
	jr z, .positive
;=@m
	ld e, $f0
.positive
	swap a
	and $0f
	or e
	rr d
	adc [hl]
;=@m
	ld [hl], a
	ret

;@ def OpenBeachDialog(index: a)
;@ path: event/marin_beach
;@ Opens dialogue $100 + `index` (OpenDialogTable1) with Link's y position set to $60 for the call, since
;@ the dialogue box is placed by Link's position.
;@ test: skip opens a dialogue
OpenBeachDialog::
;> saved = hLinkY
	ld e, a
	ldh a, [hLinkY]
	push af
;> hLinkY = 0x60
	ld a, $60
	ldh [hLinkY], a
;> OpenDialogTable1(index)
	ld a, e
	call OpenDialogTable1
;> hLinkY = saved
	pop af
	ldh [hLinkY], a
	ret

;@ def GameplayPictureHandler()
;@ path: event/picture
;@ Game mode 8: a picture shown full screen until a button is pressed - the picture in room $DD, another
;@ one elsewhere, and in Eagle's Tower (hMapId 6) the scene of the tower sinking into the ground, which
;@ ends by itself. The state of the tower scene is kept in wEntityWorkRAM3[$10-$15]: $10 a timer, $11 how
;@ far the tower has sunk, $12 the dust frame, $13 the number of drops so far, $14 the dust timer, $15
;@ the shake timer. Runs the current step of PictureSteps.
;@ test: skip jump table
GameplayPictureHandler::
;> return PictureSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: event/picture
;@ The 10 steps of the picture mode (dw code addresses, indexed by wGameplaySubtype): fade out, load the
;@ tiles, show the screen, fade in, wait for a button (or start the tower scene), return to the world;
;@ for the tower: shake, sink in four drops, settle, return to the world.
PictureSteps::
	dw PictureFadeOut          ; 0
	dw PictureLoadTiles        ; 1
	dw PictureInit             ; 2
	dw PictureFadeIn           ; 3
	dw PictureWaitButton       ; 4
	dw ReturnToWorld           ; 5
	dw TowerShake              ; 6
	dw TowerSink               ; 7
	dw TowerSettle             ; 8
	dw SceneReturnToWorld      ; 9

;@ def PictureFadeOut()
;@ path: event/picture
;@ Step 0: freezes Link and fades the room out to white; when the fade is done, clears the room
;@ transition, turns the music down (except in Eagle's Tower) and asks for tile set $0F.
;@ test: skip calls the fade
PictureFadeOut::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     ClearRoomTransitionState()
	call ClearRoomTransitionState
;>     if hMapId != 6:
	ldh a, [hMapId]
	cp $06
	jr z, .next
;>         hVolumeRight = 3
	ld a, $03
	ldh [hVolumeRight], a
;>         hVolumeLeft = 0x30
	ld a, $30
	ldh [hVolumeLeft], a
.next
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;>     wTileMapToLoad = 0x0F
	ld a, $0f
	ld [wTileMapToLoad], a
.done
	ret

;@ def PictureLoadTiles()
;@ path: event/picture
;@ Step 1: asks for the picture's tile set: $21 for Eagle's Tower, $20 in room $DD, else $12.
PictureLoadTiles::
;> tiles = 0x21
	ld e, $21
;> if hMapId != 6:
	ldh a, [hMapId]
	cp $06
	jr z, .load
;>     tiles = 0x20 if hMapRoom == 0xDD else 0x12
	ldh a, [hMapRoom]
	cp $dd
	ld e, $12
	jr nz, .load
	ld e, $20
.load
;> wTileMapToLoad = tiles
	ld a, e
	ld [wTileMapToLoad], a
;> wMenuCursor = 0
	xor a
	ld [wMenuCursor], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def PictureInit()
;@ path: event/picture
;@ Step 2: asks for the picture's screen ($24 for Eagle's Tower, $23 in room $DD, else $12), hides the
;@ window, resets the scroll and the transition counters and clears the tower scene's state.
PictureInit::
;> screen = 0x24
	ld e, $24
;> if hMapId != 6:
	ldh a, [hMapId]
	cp $06
	jr z, .load
;>     screen = 0x23 if hMapRoom == 0xDD else 0x12
	ldh a, [hMapRoom]
	cp $dd
	ld e, $12
	jr nz, .load
	ld e, $23
.load
;> wBGMapToLoad = screen
	ld a, e
	ld [wBGMapToLoad], a
;> wWindowY = 0xFF
	ld a, $ff
	ld [wWindowY], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wTransitionSequenceCounter = 0
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>@c for i in range(8):
	ld e, $08
	ld hl, wEntityWorkRAM3 + $10
.clear
;>     wEntityWorkRAM3[0x10 + i] = 0
	ld [hli], a
;=@c
	dec e
	jr nz, .clear
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype

;@ def PictureFadeIn()
;@ path: event/picture
;@ Step 3: fades the picture in; when done, sets the tower scene's timer to $80 frames.
;@ test: skip calls the fade
PictureFadeIn::
;> DrawTowerSprites()
	call DrawTowerSprites
;> FadePalettesIn()
	call FadePalettesIn
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     wEntityWorkRAM3[0x10] = 0x80
	ld a, $80
	ld [wEntityWorkRAM3 + $10], a
.done
	ret

;@ def PictureWaitButton()
;@ path: event/picture
;@ Step 4: in Eagle's Tower goes on to the tower scene (step 6) at once; otherwise waits for A, B or Start,
;@ plays the sound $13 and goes on to the return to the world. AdvanceSceneStep, also used by the beach
;@ and mural scenes, moves to the next step and resets the transition counters.
;@ test: skip calls the tower drawing
PictureWaitButton::
;> if hMapId == 6:
	ldh a, [hMapId]
	cp $06
	jr nz, .wait
;>     DrawTowerSprites()
	call DrawTowerSprites
;>     wGameplaySubtype = 6
	ld a, $06
	ld [wGameplaySubtype], a
;>     return
	ret
.wait
;> if not hJoypadPressed & 0xB0:
	ldh a, [hJoypadPressed]
	and $b0
	jr z, AdvanceSceneStep.done
;>     return
;> hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
AdvanceSceneStep:
;> IncrementGameplaySubtype()   # AdvanceSceneStep starts here
	call IncrementGameplaySubtype
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
.done
	ret

;@ def TowerShake()
;@ path: event/picture
;@ Step 6: the tower picture shakes (wScreenShakeY 0 / -2, switching every 4 frames) for $80 frames, then
;@ waits $20 frames before the first drop.
;@ test: skip calls the tower drawing
TowerShake::
;> DrawTowerSprites()
	call DrawTowerSprites
;> wEntityWorkRAM3[0x10] -= 1
	ld a, [wEntityWorkRAM3 + $10]
	dec a
	ld [wEntityWorkRAM3 + $10], a
;> if wEntityWorkRAM3[0x10] == 0:
	jr nz, .shake
;>     wScreenShakeY = 0
	ld [wScreenShakeY], a
;>     wEntityWorkRAM3[0x10] = 0x20
	ld a, $20
	ld [wEntityWorkRAM3 + $10], a
;>     return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
.shake
;> wScreenShakeY = 0xFE if wEntityWorkRAM3[0x10] & 4 else 0
	ld e, $00
	and $04
	jr z, .set
	ld e, $fe
.set
	ld a, e
	ld [wScreenShakeY], a
;> return
	ret

;@ def TowerSink()
;@ path: event/picture
;@ Step 7: every $30 frames the tower drops 8 pixels with a crash, dust at its foot ($30 frames) and a short
;@ shake ($18 frames); after the fourth drop the scene waits $80 frames.
;@ test: skip calls the tower drawing
TowerSink::
;> DrawTowerSprites()
	call DrawTowerSprites
;> UpdateTowerShake()
	call UpdateTowerShake
;> wEntityWorkRAM3[0x10] -= 1
	ld a, [wEntityWorkRAM3 + $10]
	dec a
	ld [wEntityWorkRAM3 + $10], a
;> if wEntityWorkRAM3[0x10] == 0:
	jr nz, .done
;>     PlayClinkNoise()
	call PlayClinkNoise
;>     wEntityWorkRAM3[0x10] = 0x30
	ld a, $30
	ld [wEntityWorkRAM3 + $10], a
;>     wEntityWorkRAM3[0x14] = 0x30
	ld a, $30
	ld [wEntityWorkRAM3 + $14], a
;>     wEntityWorkRAM3[0x15] = 0x18
	ld a, $18
	ld [wEntityWorkRAM3 + $15], a
;>     wEntityWorkRAM3[0x11] += 8
	ld a, [wEntityWorkRAM3 + $11]
	add $08
	ld [wEntityWorkRAM3 + $11], a
;>     wEntityWorkRAM3[0x13] += 1
	ld a, [wEntityWorkRAM3 + $13]
	inc a
	ld [wEntityWorkRAM3 + $13], a
;>     if wEntityWorkRAM3[0x13] == 4:
	cp $04
	jr nz, .done
;>         wEntityWorkRAM3[0x10] = 0x80
	ld a, $80
	ld [wEntityWorkRAM3 + $10], a
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret
;@ def TowerSettle()
;@ path: event/picture
;@ Step 8: waits the last $80 frames, then goes on to the return to the world.
;@ test: skip calls the tower drawing
TowerSettle::
;> DrawTowerSprites()
	call DrawTowerSprites
;> UpdateTowerShake()
	call UpdateTowerShake
;> wEntityWorkRAM3[0x10] -= 1
	ld hl, wEntityWorkRAM3 + $10
	dec [hl]
;> if wEntityWorkRAM3[0x10]:
;>     return
	ret nz
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
	ret

;@ def UpdateTowerShake()
;@ path: event/picture
;@ While the shake timer wEntityWorkRAM3[$15] runs, shakes the picture (wScreenShakeY -2 / 0, switching
;@ every 4 frames); otherwise keeps it still.
UpdateTowerShake::
;> wScreenShakeY = 0
	xor a
	ld [wScreenShakeY], a
;> if wEntityWorkRAM3[0x15]:
	ld a, [wEntityWorkRAM3 + $15]
	and a
	jr z, .done
;>     wEntityWorkRAM3[0x15] -= 1
	dec a
	ld [wEntityWorkRAM3 + $15], a
;>     wScreenShakeY = 0 if wEntityWorkRAM3[0x15] & 4 else 0xFE
	ld e, $fe
	and $04
	jr z, .set
	ld e, $00
.set
	ld a, e
	ld [wScreenShakeY], a
.done
;> return
	ret

;@ path: event/picture
;@ Number of tower sprites drawn after 0-5 drops (6 bytes): the lowest rows disappear into the ground as
;@ the tower sinks.
TowerSpriteCounts::
	db $14, $14, $10, $10, $0c, $0c

;@ path: event/picture
;@ The top of Eagle's Tower, 20 sprites in five rows of four (4 bytes each: y offset, x offset, tile,
;@ attributes; attributes $10 = palette OBP1, $30 = OBP1 mirrored), drawn with DrawEntitySprites.
TowerSprites::
	db $00, $00, $cc, $10,  $00, $08, $ce, $10,  $00, $10, $dc, $10,  $00, $18, $cc, $30
	db $10, $00, $de, $10,  $10, $08, $e0, $10,  $10, $10, $e2, $10,  $10, $18, $de, $30
	db $20, $00, $e4, $10,  $20, $08, $e6, $10,  $20, $10, $e8, $10,  $20, $18, $e4, $30
	db $30, $00, $de, $10,  $30, $08, $e0, $10,  $30, $10, $e0, $30,  $30, $18, $de, $30
	db $40, $00, $de, $10,  $40, $08, $e0, $10,  $40, $10, $e0, $30,  $40, $18, $de, $30

;@ path: event/picture
;@ Three frames of the dust cloud at the foot of the tower, 6 sprites each in one row (4 bytes each: y
;@ offset, x offset, tile, attributes; the right half is the left one mirrored).
TowerDustSprites::
	db $48, $08, $f0, $00,  $48, $10, $f2, $00,  $48, $18, $f4, $00
	db $48, $20, $f4, $20,  $48, $28, $f2, $20,  $48, $30, $f0, $20
	db $48, $08, $f6, $00,  $48, $10, $f8, $00,  $48, $18, $fa, $00
	db $48, $20, $fa, $20,  $48, $28, $f8, $20,  $48, $30, $f6, $20
	db $48, $08, $fc, $00,  $48, $10, $fe, $00,  $48, $18, $ee, $00
	db $48, $20, $ee, $20,  $48, $28, $fe, $20,  $48, $30, $fc, $20

;@ path: event/picture
;@ Addresses of the three dust frames in TowerDustSprites (dw).
TowerDustFrames::
	dw TowerDustSprites, TowerDustSprites + 24, TowerDustSprites + 48

;@ def DrawTowerSprites()
;@ path: event/picture
;@ In Eagle's Tower only (hMapId 6): draws the dust cloud (x $38, 6 sprites, frame changing every 8
;@ frames) while the dust timer wEntityWorkRAM3[$14] runs, and the sinking top of the tower (x $48,
;@ y $20 + how far it has sunk), both moved by the screen shake. The dust frame index takes d from b,
;@ which is 0 here.
;@ test: skip draws sprites
DrawTowerSprites::
;> if hMapId != 6:
	ldh a, [hMapId]
	cp $06
;>     return
	ret nz
;> hActiveEntitySpriteVariant = 0
	xor a
	ldh [hActiveEntitySpriteVariant], a
;> hActiveEntityFlipAttribute = 0
	ldh [hActiveEntityFlipAttribute], a
;> hActiveEntityTileOffset = 0
	ldh [hActiveEntityTileOffset], a
;> hActiveEntityX = 0x38
	ld a, $38
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = (0x20 - wScreenShakeY) & 0xFF
	ld a, [wScreenShakeY]
	ld e, a
	ld a, $20
	sub e
	ldh [hActiveEntityDrawY], a
;> if wEntityWorkRAM3[0x14]:
	ld a, [wEntityWorkRAM3 + $14]
	and a
	jr z, .tower
;>     wEntityWorkRAM3[0x14] -= 1
	dec a
	ld [wEntityWorkRAM3 + $14], a
;>     if hFrameCounter & 7 == 0:
	ldh a, [hFrameCounter]
	and $07
	ld a, [wEntityWorkRAM3 + $12]
	jr nz, .store
;>         wEntityWorkRAM3[0x12] = (wEntityWorkRAM3[0x12] + 1) % 3
	inc a
	cp $03
	jr nz, .store
	xor a
.store
	ld [wEntityWorkRAM3 + $12], a
;>@dd     DrawEntitySpritesAtOAMStart(mem16[TowerDustFrames + 2 * wEntityWorkRAM3[0x12]], 6)
	rla
	and $06
	ld e, a
	ld d, b
	ld hl, TowerDustFrames
	add hl, de
;=@dd
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $06
	call DrawEntitySpritesAtOAMStart
.tower
;> hActiveEntityX = 0x48
	ld a, $48
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = (wEntityWorkRAM3[0x11] + 0x20 - wScreenShakeY) & 0xFF
	ld a, [wScreenShakeY]
	ld e, a
	ld a, [wEntityWorkRAM3 + $11]
	add $20
	sub e
	ldh [hActiveEntityDrawY], a
;> count = mem[TowerSpriteCounts + wEntityWorkRAM3[0x13]]
	ld a, [wEntityWorkRAM3 + $13]
	ld e, a
	ld d, $00
	ld hl, TowerSpriteCounts
	add hl, de
	ld c, [hl]
;> wOAMNextIndex = 0
	xor a
	ld [wOAMNextIndex], a
;> DrawEntitySprites(TowerSprites, count)
	ld hl, TowerSprites
	call DrawEntitySprites
	ret

;@ def GameplayMuralHandler()
;@ path: event/mural
;@ Game mode $0A: the mural of the Face Shrine shown full screen with its text. Runs the current step of
;@ MuralSteps.
;@ test: skip jump table
GameplayMuralHandler::
;> return MuralSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: event/mural
;@ The 6 steps of the mural mode (dw code addresses, indexed by wGameplaySubtype): fade out, load the
;@ screen, fade in, show the text, wait for a button, return to the world.
MuralSteps::
	dw MuralFadeOut            ; 0
	dw MuralLoadScreen         ; 1
	dw MuralFadeIn             ; 2
	dw MuralShowText           ; 3
	dw MuralWaitButton         ; 4
	dw ReturnToWorld           ; 5

;@ def MuralFadeOut()
;@ path: event/mural
;@ Step 0: freezes Link and fades the room out to white; when the fade is done, clears the room
;@ transition, turns the music down and asks for tile set $14.
;@ test: skip calls the fade
MuralFadeOut::
;> wLinkFrozen = 1
	ld a, $01
	ld [wLinkFrozen], a
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     ClearRoomTransitionState()
	call ClearRoomTransitionState
;>     hVolumeRight = 3
	ld a, $03
	ldh [hVolumeRight], a
;>     hVolumeLeft = 0x30
	ld a, $30
	ldh [hVolumeLeft], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;>     wTileMapToLoad = 0x14
	ld a, $14
	ld [wTileMapToLoad], a
.done
	ret

;@ def MuralLoadScreen()
;@ path: event/mural
;@ Step 1: asks for the mural screen ($15), hides the window and resets the scroll and the transition
;@ counters.
MuralLoadScreen::
;> wBGMapToLoad = 0x15
	ld a, $15
	ld [wBGMapToLoad], a
;> wWindowY = 0xFF
	ld a, $ff
	ld [wWindowY], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
;> wTransitionSequenceCounter = 0
	ld [wTransitionSequenceCounter], a
;> wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype
;@ def MuralFadeIn()
;@ path: event/mural
;@ Step 2: fades the mural in; when done, starts the frame count of the next step.
;@ test: skip calls the fade
MuralFadeIn::
;> FadePalettesIn()
	call FadePalettesIn
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>     wSceneCounter = 0
	xor a
	ld [wSceneCounter], a
.done
	ret

;@ def MuralShowText()
;@ path: event/mural
;@ Step 3: counts the frames in which no dialogue is open: at $80 opens the mural's text (dialogue $0E7),
;@ at 256 goes on to wait for a button.
;@ test: skip opens a dialogue
MuralShowText::
;> if wDialogState:
	ld a, [wDialogState]
	and a
;>     return
	ret nz
;> wSceneCounter = (wSceneCounter + 1) & 0xFF
	ld a, [wSceneCounter]
	inc a
	ld [wSceneCounter], a
;> if wSceneCounter == 0:
;>     return IncrementGameplaySubtype()
	jp z, IncrementGameplaySubtype
;> if wSceneCounter == 0x80:
	cp $80
	jr nz, .done
;>     OpenDialog(0xE7)
	ld a, $e7
	call OpenDialog
.done
	ret

;@ def MuralWaitButton()
;@ path: event/mural
;@ Step 4: on A, B or Start plays the sound $13 and goes on to the return to the world.
;@ test: skip calls AdvanceSceneStep
MuralWaitButton::
;> if hJoypadPressed & 0xB0:
	ldh a, [hJoypadPressed]
	and $b0
	jr z, .done
;>     hJingle = 0x13
	ld a, $13
	ldh [hJingle], a
;>     AdvanceSceneStep()
	call AdvanceSceneStep
.done
	ret

;@ path: title/screen
;@ The ripple of the title logo: 21 tables of 64 signed line offsets (one byte per screen line from line
;@ $10), added to the y scroll by IntroRasterEffect. Table 0 is flat; the others are waves of falling
;@ strength. IntroWavePointers picks one per wave step; tables 4, 6, 9 and 13 are not used.
IntroWaveTables::
	; table 0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	; table 1
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
	db $e0, $e0, $e0, $e0, $e0, $e2, $e5, $e8, $eb, $ee, $f1, $f4, $f7, $fa, $fd, $00
	db $03, $06, $09, $0c, $0f, $12, $15, $18, $1b, $1e, $21, $24, $27, $2a, $2d, $30
	db $33, $36, $39, $3c, $3f, $42, $45, $48, $33, $36, $39, $3c, $3f, $42, $45, $48
	; table 2
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0
	db $e2, $e4, $e6, $e8, $ea, $ec, $ee, $f0, $f2, $f4, $f6, $f8, $fa, $fc, $fe, $00
	db $02, $04, $06, $08, $0a, $0c, $0e, $10, $12, $14, $16, $18, $1a, $1c, $1d, $1e
	db $20, $22, $24, $26, $28, $2a, $2c, $2e, $20, $22, $24, $26, $28, $2a, $2c, $2e
	; table 3
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $df, $e0, $e2, $e3, $e5, $e6, $e8
	db $e9, $eb, $ec, $ee, $ef, $f1, $f2, $f4, $f5, $f7, $f8, $fa, $fb, $fd, $fe, $00
	db $01, $03, $04, $06, $07, $09, $0a, $0c, $0d, $0f, $10, $12, $13, $15, $16, $18
	db $19, $1b, $1c, $1e, $1f, $21, $22, $24, $19, $1b, $1c, $1e, $1f, $21, $22, $24
	; table 4
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e2, $e3, $e5, $e6, $e8, $e9
	db $eb, $ec, $ee, $f0, $f2, $f3, $f6, $f7, $f8, $f9, $fa, $fc, $fd, $fe, $ff, $00
	db $01, $03, $04, $06, $07, $09, $0a, $0c, $0d, $0f, $10, $12, $13, $15, $16, $18
	db $19, $1b, $1c, $1e, $1f, $21, $22, $22, $24, $25, $27, $29, $2b, $2c, $2e, $2f
	; table 5
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e1, $e2, $e4, $e5, $e6, $e8, $e9, $ea
	db $ec, $ed, $ee, $f0, $f1, $f2, $f4, $f5, $f6, $f8, $f9, $fa, $fc, $fe, $ff, $00
	db $01, $02, $04, $05, $06, $08, $09, $0a, $0c, $0d, $0e, $10, $11, $12, $14, $15
	db $16, $18, $19, $1a, $1c, $1d, $1e, $20, $22, $23, $24, $25, $27, $28, $2a, $2b
	; table 6
	db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e2, $e3, $e4, $e5, $e6, $e8, $e9, $ea, $ec
	db $ed, $ee, $ef, $f1, $f2, $f3, $f5, $f6, $f8, $f9, $fa, $fb, $fd, $fe, $ff, $00
	db $01, $02, $03, $05, $06, $07, $08, $0a, $0b, $0c, $0d, $0f, $10, $11, $12, $14
	db $15, $16, $17, $19, $1a, $1b, $1d, $1e, $20, $21, $22, $23, $25, $26, $27, $28
	; table 7
	db $f0, $f0, $f0, $f0, $f0, $f0, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $eb, $ec, $ed
	db $ee, $f0, $f1, $f2, $f3, $f4, $f6, $f7, $f8, $f9, $fb, $fc, $fd, $fe, $ff, $00
	db $01, $02, $03, $04, $06, $07, $08, $09, $0a, $0b, $0c, $0e, $10, $11, $12, $13
	db $14, $15, $16, $18, $19, $1a, $1b, $1c, $1d, $1f, $20, $21, $22, $23, $24, $25
	; table 8
	db $f0, $f0, $f0, $f0, $f0, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ee, $ef
	db $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0c, $0d, $0e, $0f, $10, $11
	db $12, $13, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $21, $22, $23
	; table 9
	db $f0, $f0, $f0, $f0, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef, $f0
	db $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10
	db $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $20
	; table 10
	db $f0, $f0, $f0, $e6, $e7, $e8, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef, $f0, $f0
	db $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff
	db $00, $01, $02, $03, $04, $05, $06, $07, $07, $08, $09, $0a, $0b, $0c, $0d, $0e
	db $0f, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1a, $1b, $1c, $1d
	; table 11
	db $f0, $f0, $e7, $e8, $e9, $ea, $eb, $ec, $ec, $ec, $ed, $ee, $ef, $f0, $f1, $f2
	db $f2, $f3, $f4, $f5, $f6, $f7, $f7, $f8, $f9, $fa, $fb, $fc, $fc, $fd, $fe, $ff
	db $00, $01, $02, $03, $04, $04, $05, $06, $07, $08, $09, $09, $0a, $0b, $0c, $0d
	db $0e, $0e, $0f, $10, $11, $12, $13, $14, $15, $16, $16, $17, $18, $19, $1a, $1b
	; table 12
	db $f0, $e9, $e9, $ea, $eb, $eb, $ec, $ed, $ee, $ee, $ef, $f0, $f0, $f1, $f2, $f3
	db $f4, $f4, $f5, $f6, $f7, $f8, $f8, $f9, $fa, $fb, $fc, $fc, $fd, $fe, $ff, $00
	db $00, $01, $02, $03, $03, $04, $05, $06, $06, $07, $08, $09, $0a, $0a, $0b, $0c
	db $0c, $0d, $0e, $0e, $10, $11, $12, $12, $13, $14, $15, $15, $16, $17, $18, $18
	; table 13
	db $eb, $ec, $ec, $ed, $ee, $ee, $ef, $f0, $f0, $f1, $f2, $f2, $f3, $f4, $f4, $f5
	db $f6, $f6, $f7, $f8, $f8, $f9, $fa, $fa, $fb, $fc, $fc, $fd, $fe, $fe, $ff, $00
	db $00, $01, $02, $02, $03, $04, $04, $05, $06, $06, $07, $08, $08, $09, $0a, $0a
	db $0b, $0c, $0c, $0d, $0e, $0e, $0f, $10, $10, $11, $12, $12, $13, $14, $14, $15
	; table 14
	db $ed, $ee, $ee, $ef, $f0, $f0, $f1, $f1, $f2, $f2, $f3, $f3, $f3, $f4, $f5, $f5
	db $f6, $f6, $f7, $f8, $f8, $f9, $f9, $fa, $fb, $fb, $fc, $fc, $fe, $ff, $ff, $00
	db $00, $01, $01, $02, $03, $03, $04, $04, $05, $06, $06, $07, $07, $08, $09, $09
	db $0a, $0a, $0b, $0c, $0c, $0d, $0d, $0e, $0f, $0f, $10, $10, $11, $12, $12, $13
	; table 15
	db $f0, $f1, $f1, $f2, $f2, $f3, $f3, $f4, $f4, $f5, $f5, $f6, $f6, $f7, $f7, $f8
	db $f8, $f9, $f9, $fa, $fa, $fb, $fb, $fc, $fc, $fd, $fd, $fe, $fe, $ff, $ff, $00
	db $00, $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $08
	db $08, $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0f, $0f, $10
	; table 16
	db $f3, $f4, $f4, $f4, $f5, $f5, $f6, $f6, $f6, $f7, $f7, $f8, $f8, $f8, $f9, $f9
	db $fa, $fa, $fa, $fb, $fb, $fc, $fc, $fc, $fd, $fd, $fe, $fe, $ff, $ff, $00, $00
	db $00, $01, $01, $02, $02, $03, $03, $03, $04, $04, $05, $05, $05, $06, $06, $07
	db $07, $07, $08, $08, $09, $09, $09, $0a, $0a, $0b, $0b, $0b, $0c, $0c, $0d, $0d
	; table 17
	db $f5, $f6, $f6, $f6, $f7, $f7, $f7, $f8, $f8, $f8, $f9, $f9, $f9, $fa, $fa, $fa
	db $fb, $fb, $fb, $fc, $fc, $fc, $fd, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff, $00
	db $00, $01, $01, $01, $02, $02, $02, $03, $03, $03, $04, $04, $04, $05, $05, $05
	db $06, $06, $06, $07, $07, $07, $08, $08, $08, $09, $09, $09, $0a, $0a, $0a, $0b
	; table 18
	db $fc, $fc, $fb, $fb, $fb, $fb, $fa, $fa, $fa, $fa, $fb, $fb, $fb, $fb, $fc, $fc
	db $fc, $fc, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $00, $00
	db $00, $00, $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $04, $04
	db $04, $04, $05, $05, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07, $08, $08
	; table 19
	db $fb, $fb, $fb, $fb, $fb, $fc, $fc, $fc, $fc, $fc, $fc, $fd, $fd, $fd, $fd, $fd
	db $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
	db $00, $00, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02, $02, $02, $03, $03
	db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $05, $05, $05, $05, $05, $05
	; table 20
	db $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
	db $fe, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03

;@ path: title/screen
;@ The wave table for each wave step 0-$10 (17 dw addresses into IntroWaveTables); step $10 is the flat
;@ table, the logo at rest.
IntroWavePointers::
	dw IntroWaveTables + $40 * 1, IntroWaveTables + $40 * 2, IntroWaveTables + $40 * 3, IntroWaveTables + $40 * 5
	dw IntroWaveTables + $40 * 7, IntroWaveTables + $40 * 8, IntroWaveTables + $40 * 10, IntroWaveTables + $40 * 11
	dw IntroWaveTables + $40 * 12, IntroWaveTables + $40 * 14, IntroWaveTables + $40 * 15, IntroWaveTables + $40 * 16
	dw IntroWaveTables + $40 * 17, IntroWaveTables + $40 * 18, IntroWaveTables + $40 * 19, IntroWaveTables + $40 * 20
	dw IntroWaveTables

;@ path: title/screen
;@ For each wave step 0-$10 (17 bytes): the number of lines (counted from screen line $10) that show the
;@ logo; the lines below it are hidden with the palette $55. The logo grows from $28 to $3A lines.
IntroWaveLimits::
	db $28, $2a, $2c, $2c, $2e, $2e, $30, $30, $31, $33, $33, $34, $35, $36, $38, $3a, $3a

;@ def IntroRasterEffect()
;@ path: title/screen
;@ Called by the VBlank handler from intro subtype 8 on: lets the title logo ripple into place. Every
;@ second frame the wave step wRasterDelay grows by one, up to $10. The step picks a table of line
;@ offsets (IntroWavePointers) and how many lines to show (IntroWaveLimits). From screen line $10 on,
;@ the routine waits for each line's HBlank and sets rSCY = hBaseScrollY + that line's offset; the lines
;@ past the limit get the palette $55, which hides them. After $39 lines it restores rSCY and rBGP. The
;@ byte after wRasterLine only serves as a short delay.
;@ test: skip waits for LCD lines
IntroRasterEffect::
;> wRasterLine = 0
	ld hl, wRasterLine
	xor a
	ld [hli], a
	ld [hli], a
	ld d, $00
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .tables
;>     wRasterDelay = min(wRasterDelay + 1, 0x10)
	ld a, [wRasterDelay]
	inc a
	cp $10
	jr c, .store
	ld a, $10
.store
	ld [wRasterDelay], a
.tables
;> hMultiPurpose0 = mem[IntroWaveLimits + wRasterDelay]
	ld a, [wRasterDelay]
	ld e, a
	ld hl, IntroWaveLimits
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> offsets = mem16[IntroWavePointers + 2 * wRasterDelay]
	sla e
	ld hl, IntroWavePointers
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ld c, a
;> while rLY != 0x10: pass
.waitLine
	ldh a, [rLY]
	cp $10
	jr nz, .waitLine
;>@l while True:
;>     while rSTAT & 3: pass
.hblank
	ldh a, [rSTAT]
	and $03
	jr nz, .hblank
;>     mem[addr(wRasterLine) + 1] = u8((mem[addr(wRasterLine) + 1] | 1) + 1)   # a short delay
.delay
	ld a, [wRasterLine + 1]
	inc a
	ld [wRasterLine + 1], a
	and $01
	jr nz, .delay
;>     line = lo(wRasterLine)
	ldh a, [hMultiPurpose0]
	ld l, a
	ld a, [wRasterLine]
	ld e, a
;>     mem[addr(wRasterLine)] = line + 1
	inc a
	ld [wRasterLine], a
;>     if line + 1 == 0x3A:
	cp $3a
	jr z, .end
;>         break
;>     if line + 1 >= hMultiPurpose0:
	cp l
	jr c, .wave
;>         rBGP = 0x55
	ld a, $55
	ldh [rBGP], a
;=@l
	jr .hblank
;>     else:
.wave
;>@sc         rSCY = (mem[offsets + line] + hBaseScrollY) & 0xFF
	ld hl, $0000
	add hl, de
	add hl, bc
	ld a, [hl]
	ld hl, hBaseScrollY
	add [hl]
;=@sc
	ldh [rSCY], a
;=@l
	jr .hblank
.end
;> rSCY = hBaseScrollY
	ldh a, [hBaseScrollY]
	ldh [rSCY], a
;> rBGP = wBGPalette
	ld a, [wBGPalette]
	ldh [rBGP], a
	ret


;@ def PlayCursorSoundOnMove()
;@ path: menu/cursor
;@ Plays the cursor sound (PlayCursorSound) when up, down or Select was just pressed.
;@ test: skip runs on into another unit
PlayCursorSoundOnMove::
;> if not hJoypadPressed & 0x4C:
	ldh a, [hJoypadPressed]
	and $4c
;>     return
	jr z, PlayCursorSound.done
;> return PlayCursorSound()   # runs on into it

;@ def PlayCursorSound()
;@ path: menu/cursor
;@ Plays the menu cursor sound (jingle $0A); a and the flags are kept.
PlayCursorSound::
;> hJingle = 0x0A
	push af
	ld a, $0a
	ldh [hJingle], a
	pop af
.done
	ret


;@ path: title/intro
;@ Background palettes of a lightning flash (4 bytes), indexed by (flash timer >> 1) & 3: the timer
;@ wEntityWorkRAM counts down from $1C, so the screen flickers between bright and normal.
IntroBGPalettes::
	db $c6, $c2, $c0, $c2

;@ def GameplayIntroHandler()
;@ path: title/intro
;@ Game mode 0, the intro: Link's boat in the storm, Marin finding him on the beach, and the title
;@ screen. Start skips to the title screen (subtype $0D; then $28 frames pass before Start counts again)
;@ and on the title screen (subtype $0B) opens the file select. In the storm (subtypes 0-4) the flash
;@ timer wEntityWorkRAM picks the background palette from IntroBGPalettes. Then runs the current step of
;@ IntroSteps.
;@ test: skip jump table
GameplayIntroHandler::
;> if hStartButtonDelay:
	ldh a, [hStartButtonDelay]
	and a
	jr z, .checkStart
;>     hStartButtonDelay -= 1
	dec a
	ldh [hStartButtonDelay], a
	jr .steps
.checkStart
;> elif hJoypadPressed & 0x80:
	ldh a, [hJoypadPressed]
	and $80
	jr z, .steps
;>     ResetSoundEngine()
	call ResetSoundEngine
;>     if wGameplaySubtype == 0x0B:
	ld a, [wGameplaySubtype]
	cp $0b
	jr z, .fileSelect
;>@fs         return EnterFileSelectWithMusic()
;>     hStartButtonDelay = 0x28
	ld a, $28
	ldh [hStartButtonDelay], a
;>     wBGMapToLoad = 0x11
	ld a, $11
	ld [wBGMapToLoad], a
;>     wGameplaySubtype = 0x0D
	ld a, $0d
	ld [wGameplaySubtype], a
;>     for i in range(5): wEntityStatus[i] = 0
	xor a
	ld [wEntityStatus], a
	ld [wEntityStatus + 1], a
	ld [wEntityStatus + 2], a
	ld [wEntityStatus + 3], a
	ld [wEntityStatus + 4], a
;>     rBGP = 0
	ldh [rBGP], a
;>     wBGPalette = 0
	ld [wBGPalette], a
;>     wRasterDelay = 0x10
	ld a, $10
	ld [wRasterDelay], a
;>     InitTitleTimers()
	call InitTitleTimers
;>     wMusicTrackToPlay = 0x0D
	ld a, $0d
	ld [wMusicTrackToPlay], a
;>     wSceneVarF = 0x0D
	ld [wSceneVarF], a
;>     QueueIntroSeaTiles()
	call QueueIntroSeaTiles
	jr .interrupts
.fileSelect
;=@fs
	jp EnterFileSelectWithMusic
;>     if False:   # never reached: these bytes would start the file select directly
;>         wGameplaySubtype = 0
	xor a
	ld [wGameplaySubtype], a
;>         hBaseScrollX = 0
	ldh [hBaseScrollX], a
;>         hBaseScrollY = 0
	ldh [hBaseScrollY], a
;>         rBGP = 0
	ldh [rBGP], a
;>         wBGPalette = 0
	ld [wBGPalette], a
;>         wGameplayType += 1
	ld hl, wGameplayType
	inc [hl]
.interrupts
;>     rIE = 0x01
	ld a, $01
	ldh [rIE], a
;>     rLYC = 0x4F
	ld a, $4f
	ldh [rLYC], a
;>     return
	ret
.steps
;> if wGameplaySubtype < 5:
	ld a, [wGameplaySubtype]
	cp $05
	jr nc, .dispatch
;>     if wEntityWorkRAM[0]:
	ld a, [wEntityWorkRAM]
	and a
	jr z, .palette
;>         wEntityWorkRAM[0] -= 1
	dec a
	ld [wEntityWorkRAM], a
.palette
;>@p     wBGPalette = mem[IntroBGPalettes + ((wEntityWorkRAM[0] >> 1) & 3)]
	rra
	nop
	and $03
	ld e, a
	ld d, $00
	ld hl, IntroBGPalettes
;=@p
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
.dispatch
;> return IntroSteps[wGameplaySubtype]()
	ld a, [wGameplaySubtype]
	rst $00

;@ path: title/intro
;@ The 14 steps of the intro (dw code addresses, indexed by wGameplaySubtype).
IntroSteps::
	dw IntroInit               ; 0
	dw IntroLoadTiles          ; 1
	dw IntroStormInit          ; 2
	dw IntroStorm              ; 3 the boat drifts in the storm
	dw IntroStormView2         ; 4 the second storm screen
	dw IntroLoadBeach          ; 5
	dw IntroBeachFadeIn        ; 6
	dw IntroBeach              ; 7 Marin finds Link, the view rises to the sky
	dw IntroDrawLogo           ; 8
	dw IntroWaitLogoWave       ; 9
	dw IntroDrawCopyright      ; 10
	dw IntroTitle              ; 11 the title screen
	dw IntroTitleFadeOut       ; 12
	dw IntroSkipToTitle        ; 13 (Start pressed)

;@ def IntroInit()
;@ path: title/intro
;@ Subtype 0: clears the work RAM at $C000-$D5FF (ClearWRAM1600), starts the intro music ($1A), asks
;@ for tile set 2, resets the frame counter, seeds the random numbers ($A2) and switches the window off.
;@ test: skip clears RAM
IntroInit::
;> ClearWRAM1600()
	call ClearWRAM1600
;> ResetSoundEngine()
	call ResetSoundEngine
;> PlayMusic(0x1A)
	ld a, $1a
	call PlayMusic
;> wTileMapToLoad = 2
	ld a, $02
	ld [wTileMapToLoad], a
;> hFrameCounter = 0
	xor a
	ldh [hFrameCounter], a
;> wRandomSeed = 0xA2
	ld a, $a2
	ld [wRandomSeed], a
;> wLCDControl = rLCDC & 0xDF
	ldh a, [rLCDC]
	and $df
	ld [wLCDControl], a
;> rLCDC = wLCDControl
	ldh [rLCDC], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def IntroLoadTiles()
;@ path: title/intro
;@ Subtype 1: asks for the storm tile set ($10).
IntroLoadTiles::
;> wTileMapToLoad = 0x10
	ld a, $10
	ld [wTileMapToLoad], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ def IntroStormInit()
;@ path: title/storm
;@ Subtype 2: asks for the storm screen ($0E), sets the palettes, turns on the LCD interrupt for the
;@ parallax bands of the sea (rIE 3, rLYC 0), clears the scene variables wEntityWorkRAM[0-$10] and
;@ puts Link's boat (entity 2, status 5) at x $C0, y $4E.
IntroStormInit::
;> UpdateIntroStormScroll()
	call UpdateIntroStormScroll
;> wBGMapToLoad = 0x0E
	ld a, $0e
	ld [wBGMapToLoad], a
;> wBGPalette = 0xC6
	ld a, $c6
	ld [wBGPalette], a
;> wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;> wOBJ1Palette = 0xE0
	ld a, $e0
	ld [wOBJ1Palette], a
;> rIE = 0x03
	ld a, $03
	ldh [rIE], a
;> rLYC = 0
	ld a, $00
	ldh [rLYC], a
;>@c for i in range(0x11):
	ld e, $11
	ld hl, wEntityWorkRAM
	xor a
.clear
;>     wEntityWorkRAM[i] = 0
	ld [hli], a
;=@c
	dec e
	jr nz, .clear
;> wEntityStatus[0] = 0
	ld [wEntityStatus], a
;> wEntityStatus[1] = 0
	ld [wEntityStatus + 1], a
;> wEntitySpriteVariant[0] = 0
	ld [wEntitySpriteVariant], a
;> wEntitySpriteVariant[1] = 0
	ld [wEntitySpriteVariant + 1], a
;> wEntitySpriteVariant[2] = 0
	ld [wEntitySpriteVariant + 2], a
;> hActiveEntityFlipAttribute = 0
	ldh [hActiveEntityFlipAttribute], a
;> wEntityStatus[2] = 5
	ld a, $05
	ld [wEntityStatus + 2], a
;> wEntityX[2] = 0xC0
	ld a, $c0
	ld [wEntityX + 2], a
;> wEntityY[2] = 0x4E
	ld a, $4e
	ld [wEntityY + 2], a
;> wEntityPhysicsFlags[0] = 0
	xor a
	ld [wEntityPhysicsFlags], a
;> wEntityPhysicsFlags[1] = 0
	ld [wEntityPhysicsFlags + 1], a
;> wEntityPhysicsFlags[2] = 0
	ld [wEntityPhysicsFlags + 2], a
;> wEntityPhysicsFlags[3] = 0
	ld [wEntityPhysicsFlags + 3], a
;> return IncrementGameplaySubtype()
	jp IncrementGameplaySubtype


;@ path: title/storm
;@ Background palettes of the fade to black after the lightning has struck the boat (9 bytes, one per
;@ 8 frames; the last one ends the storm).
IntroFlashBGPalettes::
	db $81, $40, $00, $00, $00, $00, $00, $00, $00

;@ path: title/storm
;@ The same fade for OBJ0 (9 bytes).
IntroFlashOBJ0Palettes::
	db $08, $08, $08, $04, $00, $00, $00, $00, $00

;@ def IntroStorm()
;@ path: title/storm
;@ Subtype 3, the storm: draws the rain and the entities. Once the lightning has struck the boat
;@ (wSceneVar2 counting up from 1), waits until $18, fades the screen to black (IntroFlashBGPalettes /
;@ IntroFlashOBJ0Palettes, one entry per 8 frames) and then moves on to the beach (subtype 5: tile set
;@ $11, the band scrolls reset). Before the strike: when the boat has drifted to x $50, shows the second
;@ storm screen (subtype 4, screen $0F); otherwise scrolls the view by one pixel every 8 frames (the
;@ entities keep their place on the sea, so they move left) and at six scroll positions starts a
;@ lightning bolt in entity slot 1 or 0.
IntroStorm::
;> DrawIntroRain()
	call DrawIntroRain
;> UpdateIntroEntities()
	call UpdateIntroEntities
;> if wSceneVar2:
	ld a, [wSceneVar2]
	and a
	jr z, .drift
;>     wSceneVar2 += 1
	inc a
	ld [wSceneVar2], a
;>     if wSceneVar2 < 0x18:
	cp $18
;>         return
	jr c, .done
;>     i = ((wSceneVar2 - 0x18) >> 3) & 0x0F
	sub $18
	rra
	rra
	rra
	and $0f
	ld e, a
;>     wBGPalette = mem[IntroFlashBGPalettes + i]
	ld d, $00
	ld hl, IntroFlashBGPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;>     wOBJ0Palette = mem[IntroFlashOBJ0Palettes + i]
	ld hl, IntroFlashOBJ0Palettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;>     if i == 8:
	ld a, e
	cp $08
	jp nz, .done
;>         wEntityStatus[0] = 0
	xor a
	ld [wEntityStatus], a
;>         wEntityStatus[1] = 0
	ld [wEntityStatus + 1], a
;>         wEntityStatus[2] = 0
	ld [wEntityStatus + 2], a
;>         wEntityState[0] = 0
	ld [wEntityState], a
;>         wGameplaySubtype = 5
	ld a, $05
	ld [wGameplaySubtype], a
;>         wSceneVarF = 5
	ld [wSceneVarF], a
;>         QueueIntroSeaTiles()
	call QueueIntroSeaTiles
;>         wTileMapToLoad = 0x11
	ld a, $11
	ld [wTileMapToLoad], a
;>         wSceneVar1 = 0xFF
	ld a, $ff
	ld [wSceneVar1], a
;>         hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;>         wIntroBandScrollX[0] = 0
	ld [wIntroBandScrollX], a
;>         wIntroBandScrollX[2] = 0
	ld [wIntroBandScrollX + 2], a
;>         wIntroBandScrollX[3] = 0
	ld [wIntroBandScrollX + 3], a
;>         wIntroBandScrollX[1] = 0x92
	ld a, $92
	ld [wIntroBandScrollX + 1], a
;>         rIE = 0x03
	ld a, $03
	ldh [rIE], a
.done
	ret
.drift
;> if wEntityX[2] == 0x50:
	ld a, [wEntityX + 2]
	cp $50
	jr nz, .scroll
;>     wGameplaySubtype = 4
	ld a, $04
	ld [wGameplaySubtype], a
;>     wBGMapToLoad = 0x0F
	ld a, $0f
	ld [wBGMapToLoad], a
;>     rIE = 0x01
	ld a, $01
	ldh [rIE], a
;>     hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;>     return
	ret
.scroll
;> UpdateIntroStormScroll()
	call UpdateIntroStormScroll
;> if hFrameCounter & 7:
	ldh a, [hFrameCounter]
	and $07
;>     return
	jp nz, IntroLightningFlash.done
;> hBaseScrollX += 1
	ld hl, hBaseScrollX
	inc [hl]
;> wEntityX[0] -= 1
	ld hl, wEntityX
	dec [hl]
;> wEntityX[1] -= 1
	inc hl
	dec [hl]
;> wEntityX[2] -= 1
	inc hl
	dec [hl]
;>@k kind = (0x10, 0x30, 0x38, 0x58, 0x5A, 0x69).index(hBaseScrollX)   # any other position: return
	ld c, $00
	ldh a, [hBaseScrollX]
	cp $10
	jr z, .spawn
	inc c
	cp $30
;=@k
	jr z, .spawn
	inc c
	cp $38
	jr z, .spawn
	inc c
	cp $58
;=@k
	jr z, .spawn
	inc c
	cp $5a
	jr z, .spawn
	inc c
	cp $69
;=@k
	jr nz, IntroLightningFlash.done
.spawn
;>@f for slot in (1, 0):
	ld e, $01
	ld d, $00
.find
;>     if wEntityStatus[slot] == 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
;>         return IntroSpawnLightning(slot, kind)
	jr z, IntroSpawnLightning
;=@f
	dec e
	ld a, e
	cp $ff
	jr nz, .find
;> return
	ret


;@ path: title/storm
;@ X positions of the six lightning bolts of the storm (6 bytes), by the scroll position that starts them.
IntroLightningX::
	db $28, $78, $60, $38, $68, $58

;@ path: title/storm
;@ Entity status (= bolt shape 1-4, see IntroLightningSprites) of the six lightning bolts (6 bytes).
IntroLightningKinds::
	db $04, $02, $01, $04, $03, $01

;@ def IntroSpawnLightning(slot: de, kind: c)
;@ path: title/storm
;@ Puts lightning bolt `kind` (0-5) into entity slot `slot`: its shape as the status, its x position,
;@ y $30, shown for $20 frames; then starts the flash (IntroLightningFlash).
;@ test: skip runs on into another unit
IntroSpawnLightning::
;>@s wEntityStatus[slot] = mem[IntroLightningKinds + kind]
	ld b, $00
	ld hl, IntroLightningKinds
	add hl, bc
	ld a, [hl]
	ld hl, wEntityStatus
	add hl, de
;=@s
	ld [hl], a
;>@x wEntityX[slot] = mem[IntroLightningX + kind]
	ld hl, IntroLightningX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;> wEntityY[slot] = 0x30
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
;> wEntityTimer[slot] = 0x20
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20
;> return IntroLightningFlash()   # runs on into it

;@ def IntroLightningFlash()
;@ path: title/storm
;@ Starts a lightning flash: the flash timer wEntityWorkRAM = $1C (GameplayIntroHandler takes the
;@ palettes from it) and the thunder (PlayClinkNoise).
;@ test: skip plays a sound
IntroLightningFlash::
;> wEntityWorkRAM[0] = 0x1C
	ld a, $1c
	ld [wEntityWorkRAM], a
;> PlayClinkNoise()
	call PlayClinkNoise
.done
	ret


;@ def IntroStormView2()
;@ path: title/storm
;@ Subtype 4, the second storm screen (screen $0F) for $A0 frames (wSceneVar1 counts): at $80 changes a
;@ block of 2x4 tiles (DrawStormView2Tiles), at $90 and every 128 frames a lightning flash; at $A0 back
;@ to the storm screen (subtype 3, screen $0E) with the lightning striking the boat (wSceneVar2 = 1).
IntroStormView2::
;> DrawIntroRain()
	call DrawIntroRain
;> wSceneVar1 += 1
	ld a, [wSceneVar1]
	inc a
	ld [wSceneVar1], a
;> if wSceneVar1 == 0x80:
	cp $80
	jr nz, .at90
;>     DrawStormView2Tiles()
	push af
	call DrawStormView2Tiles
	pop af
.at90
;> if wSceneVar1 == 0x90:
	cp $90
	jr nz, .atA0
;>     IntroLightningFlash()
	call IntroLightningFlash
.atA0
;> if wSceneVar1 == 0xA0:
	cp $a0
	jr nz, .random
;>     wGameplaySubtype = 3
	ld a, $03
	ld [wGameplaySubtype], a
;>     wBGMapToLoad = 0x0E
	ld a, $0e
	ld [wBGMapToLoad], a
;>     rIE = 0x03
	ld a, $03
	ldh [rIE], a
;>     wEntityStatus[0] = 0
	xor a
	ld [wEntityStatus], a
;>     wEntityStatus[1] = 0
	ld [wEntityStatus + 1], a
;>     wSceneVar2 = 1
	ld a, $01
	ld [wSceneVar2], a
;>     return
	ret
.random
;> if hFrameCounter & 0x7F == 0 and GetRandomByte() & 0 == 0:   # the second test always passes
	ldh a, [hFrameCounter]
	and $7f
	jr nz, .done
	call GetRandomByte
	and $00
	jr nz, .done
;>     IntroLightningFlash()
	call IntroLightningFlash
.done
	ret


;@ def IntroLoadBeach()
;@ path: title/beach
;@ Subtype 5: asks for the beach screen ($10).
IntroLoadBeach::
;> wBGMapToLoad = 0x10
	ld a, $10
	ld [wBGMapToLoad], a
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ path: title/beach
;@ Fade-in palettes of the beach for the background (16 bytes), read at entry fade step + (hFrameCounter
;@ & 3): each value is there about four times, so the fade blends from frame to frame.
IntroBeachBGPalettes::
	db $00, $00, $00, $00, $40, $40, $40, $80, $85, $85, $85, $c5, $c9, $c9, $c9, $c9
;@ path: title/beach
;@ The same fade for OBJ0 (16 bytes).
IntroBeachOBJ0Palettes::
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
;@ path: title/beach
;@ The same fade for OBJ1 (16 bytes).
IntroBeachOBJ1Palettes::
	db $00, $00, $00, $00, $40, $40, $40, $40, $90, $90, $90, $90, $e0, $e0, $e0, $e0

;@ def IntroBeachFadeIn()
;@ path: title/beach
;@ Subtype 6: wSceneVar1 counts down from $FF. At $A0 the LCD interrupt line moves to 2; from $33 on
;@ the beach fades in (the fade step, kept in wCreditsRole, goes up every 4 frames to $0C). At 0 Marin
;@ (entity 0, status 6) appears at the right edge (x $B0, y $68) and the beach scene begins (subtype 7).
;@ The sound of the waves plays throughout.
;@ test: skip plays sounds
IntroBeachFadeIn::
;> PlayIntroWaveSound()
	call PlayIntroWaveSound
;> if wSceneVar1 == 0xA0:
	ld a, [wSceneVar1]
	cp $a0
	jr nz, .count
;>     rLYC = 2
	push af
	ld a, $02
	ldh [rLYC], a
	pop af
.count
;> wSceneVar1 -= 1
	dec a
	ld [wSceneVar1], a
;> if wSceneVar1 == 0:
	jr nz, .fade
;>     wGameplaySubtype = 7
	ld a, $07
	ld [wGameplaySubtype], a
;>     wEntityStatus[0] = 6
	ld a, $06
	ld [wEntityStatus], a
;>     wEntityX[0] = 0xB0
	ld a, $b0
	ld [wEntityX], a
;>     wEntityY[0] = 0x68
	ld a, $68
	ld [wEntityY], a
;>     wEntityPrivateCounter[0] = 1
	ld a, $01
	ld [wEntityPrivateCounter], a
;>     return
	ret
.fade
;> if wSceneVar1 >= 0x34:
	cp $34
;>     return
	jr nc, .done
;> if wSceneVar1 & 3 == 0 and wCreditsRole != 0x0C:
	and $03
	jr nz, .palette
	ld a, [wCreditsRole]
	cp $0c
	jr z, .palette
;>     wCreditsRole += 1
	inc a
	ld [wCreditsRole], a
.palette
;> i = wCreditsRole + (hFrameCounter & 3)
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wCreditsRole]
	add e
	ld e, a
;> wBGPalette = mem[IntroBeachBGPalettes + i]
	ld d, $00
	ld hl, IntroBeachBGPalettes
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
;> wOBJ0Palette = mem[IntroBeachOBJ0Palettes + i]
	ld hl, IntroBeachOBJ0Palettes
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
;> wOBJ1Palette = mem[IntroBeachOBJ1Palettes + i]
	ld hl, IntroBeachOBJ1Palettes
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a
.done
	ret


;@ def IntroBeach()
;@ path: title/beach
;@ Subtype 7: runs the entities - Marin walks along the beach and finds Link, then the view rises to the
;@ sky (IntroMarin, IntroLink).
;@ test: skip calls the entities
IntroBeach::
;> UpdateIntroEntities()
	call UpdateIntroEntities
	ret


;@ def PlayIntroWaveSound()
;@ path: title/beach
;@ Plays the sound of the waves (noise $0F) every $A0 frames, until Link's entity (slot 1) has reached
;@ its state 2.
PlayIntroWaveSound::
;> if wEntityState[1] < 2:
	ld a, [wEntityState + 1]
	cp $02
	jr nc, .done
;>     waves = wSeaWavesSoundTimer + 1
	ld a, [wSeaWavesSoundTimer]
	inc a
;>     if waves == 0xA0:
	cp $a0
	jr nz, .store
;>         hNoiseSfx = 0x0F
	ld a, $0f
	ldh [hNoiseSfx], a
;>         waves = 0
	xor a
.store
;>     wSeaWavesSoundTimer = waves
	ld [wSeaWavesSoundTimer], a
.done
	ret


;@ path: title/screen
;@ The title logo, 7 draw commands of one BG row each (19 bytes: VRAM address high, low, $0F = 16 tiles
;@ in a row, then the tiles): rows $9A16-$9AD6, tiles $80-$EF.
IntroLogoRows::
	; row 0
	db $9a, $16, $0f, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f
	; row 1
	db $9a, $36, $0f, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f
	; row 2
	db $9a, $56, $0f, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af
	; row 3
	db $9a, $76, $0f, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf
	; row 4
	db $9a, $96, $0f, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf
	; row 5
	db $9a, $b6, $0f, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df
	; row 6
	db $9a, $d6, $0f, $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef

;@ path: title/screen
;@ The order in which IntroDrawLogo draws the logo rows (7 dw addresses into IntroLogoRows): from the
;@ middle row outwards.
IntroLogoRowOrder::
	dw IntroLogoRows + 19 * 3, IntroLogoRows + 19 * 2, IntroLogoRows + 19 * 4, IntroLogoRows + 19 * 1
	dw IntroLogoRows + 19 * 5, IntroLogoRows, IntroLogoRows + 19 * 6

;@ def IntroDrawLogo()
;@ path: title/screen
;@ Subtype 8: draws one row of the title logo per frame (IntroLogoRowOrder, counted in wSceneVar2); after
;@ the 7th goes on.
;@ test: wSceneVar2 = rand(0, 6)
IntroDrawLogo::
;>@s src = mem16[IntroLogoRowOrder + 2 * wSceneVar2]
	ld a, [wSceneVar2]
	sla a
	ld e, a
	ld d, $00
	ld hl, IntroLogoRowOrder
	add hl, de
;=@s
	ld a, [hli]
	ld d, [hl]
	ld e, a
;>@c copy(wDrawCommand, src, 0x13)
	ld hl, wDrawCommand
	ld c, $13
.copy
	ld a, [de]
	inc de
	ld [hli], a
	dec c
;=@c
	jr nz, .copy
;> wDrawCommand[0x13] = 0
	ld [hl], $00
;> wSceneVar2 += 1
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
;> if wSceneVar2 == 7:
	cp $07
	jr nz, .done
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret


;@ def IntroWaitLogoWave()
;@ path: title/screen
;@ Subtype 9: waits until the logo's ripple has settled (wave step wRasterDelay $10, see
;@ IntroRasterEffect), then plays the sound $19 and goes on.
IntroWaitLogoWave::
;> if wRasterDelay >= 0x10:
	ld a, [wRasterDelay]
	cp $10
	jr c, .done
;>     hNoiseSfx = 0x19
	ld a, $19
	ldh [hNoiseSfx], a
;>     IncrementGameplaySubtype()
	call IncrementGameplaySubtype
.done
	ret


;@ path: title/screen
;@ Draw command for the line under the logo (14 bytes: VRAM $9BB9, $09 = 10 tiles in a row, tiles
;@ $65-$6E, then the end mark 0).
IntroCopyrightCommand::
	db $9b, $b9, $09, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $00

;@ def IntroDrawCopyright()
;@ path: title/screen
;@ Subtype 10: draws the line under the logo, goes on to the title screen and sets its timers
;@ (InitTitleTimers).
;@ test: skip runs on into another unit
IntroDrawCopyright::
;>@c copy(wDrawCommand, IntroCopyrightCommand, 0x0E)
	ld de, IntroCopyrightCommand
	ld hl, wDrawCommand
	ld c, $0e
.copy
	ld a, [de]
	inc de
	ld [hli], a
;=@c
	dec c
	jr nz, .copy
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;> return InitTitleTimers()   # runs on into it

;@ def InitTitleTimers()
;@ path: title/screen
;@ Sets the title screen's counters: wSceneVar1 = $A0 (times 16 frames until the intro starts over),
;@ wSceneVar2 = 0 (the frame count), wSceneVar3 = $FF (the last sparkle position).
InitTitleTimers::
;> wSceneVar1 = 0xA0
	ld a, $a0
	ld [wSceneVar1], a
;> wSceneVar2 = 0
	xor a
	ld [wSceneVar2], a
;> wSceneVar3 = 0xFF
	ld a, $ff
	ld [wSceneVar3], a
	ret


;@ path: title/screen
;@ X positions of the eight places where a sparkle appears on the title screen (8 bytes, in turn).
IntroSparkleX::
	db $18, $18, $38, $40, $58, $60, $80, $88

;@ path: title/screen
;@ Y positions of the same eight places (8 bytes).
IntroSparkleY::
	db $20, $48, $44, $28, $44, $28, $28, $40

;@ def IntroTitle()
;@ path: title/screen
;@ Subtype 11, the title screen: every 64 frames a sparkle (status 8, $3F frames) appears at the next of
;@ the eight places in a free entity slot (1 or 0). After $A0 x 16 frames the music fades out and the
;@ intro goes on to start over.
IntroTitle::
;> UpdateIntroEntities()
	call UpdateIntroEntities
;> if hFrameCounter & 0x3F == 0:
	ldh a, [hFrameCounter]
	and $3f
	jr nz, .timer
;>@f     for slot in (1, 0):
	ld e, $01
	ld d, $00
.find
;>         if wEntityStatus[slot] == 0:
	ld hl, wEntityStatus
	add hl, de
	ld a, [hl]
	and a
	jr z, .spawn
;=@f
	dec e
	ld a, e
	cp $ff
	jr nz, .find
;=@f
	jr .timer
.spawn
;>             wEntityStatus[slot] = 8
	ld [hl], $08
;>             wEntityTimer[slot] = 0x3F
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $3f
;>             wSceneVar3 = (wSceneVar3 + 1) & 0xFF
	ld a, [wSceneVar3]
	inc a
	ld [wSceneVar3], a
;>             i = wSceneVar3 & 7
	and $07
	ld c, a
	ld b, $00
;>             wEntityX[slot] = mem[IntroSparkleX + i]
	ld hl, IntroSparkleX
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
;>             wEntityY[slot] = mem[IntroSparkleY + i]
	ld hl, IntroSparkleY
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a
;>             break
.timer
;> wSceneVar2 = (wSceneVar2 + 1) & 0xFF
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
;> if wSceneVar2 & 0x0F == 0:
	and $0f
	jr nz, .done
;>     wSceneVar1 -= 1
	ld a, [wSceneVar1]
	dec a
	ld [wSceneVar1], a
;>     if wSceneVar1 == 0:
	jr nz, .done
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>         wTransitionSequenceCounter = 0
	xor a
	ld [wTransitionSequenceCounter], a
;>         wTransitionFrameCounter = 0
	ld [wTransitionFrameCounter], a
;>         FadeOutVolume()
	call FadeOutVolume
.done
	ret


;@ def IntroTitleFadeOut()
;@ path: title/screen
;@ Subtype 12: fades to white, then starts the intro over (StartIntroMode).
;@ test: skip calls the fade
IntroTitleFadeOut::
;> FadePalettesToWhite()
	call FadePalettesToWhite
;> if wTransitionSequenceCounter == 4:
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, .done
;>     return StartIntroMode()
	jp StartIntroMode
.done
	ret


;@ def IntroSkipToTitle()
;@ path: title/screen
;@ Subtype 13, after Start was pressed during the intro: asks for the title tile set ($11; the screen $11
;@ was asked for by GameplayIntroHandler), goes to the title screen (subtype 11) and sets its palettes and
;@ scroll.
IntroSkipToTitle::
;> wTileMapToLoad = 0x11
	ld a, $11
	ld [wTileMapToLoad], a
;> wGameplaySubtype = 0x0B
	ld a, $0b
	ld [wGameplaySubtype], a
;> wBGPalette = 0xC9
	ld a, $c9
	ld [wBGPalette], a
;> wOBJ0Palette = 0x1C
	ld a, $1c
	ld [wOBJ0Palette], a
;> hBaseScrollX = 0
	xor a
	ldh [hBaseScrollX], a
;> hBaseScrollY = 0
	ldh [hBaseScrollY], a
	ret


;@ def DrawIntroRain()
;@ path: title/storm
;@ Draws the rain into OAM from entry 19 on: 16 drops (21 on the second storm screen) on a slanted grid
;@ that starts at a random place each frame - x steps of $1C, wrapping at $A0 to the next row ($98
;@ back, $25 down); each drop is tile $28 or one of $70-$76 at random.
;@ test: skip random numbers
DrawIntroRain::
;> hMultiPurpose1 = (GetRandomByte() & 0x18) + 0x10
	call GetRandomByte
	and $18
	add $10
	ldh [hMultiPurpose1], a
;> hMultiPurpose0 = (GetRandomByte() & 0x18) + 0x10
	call GetRandomByte
	and $18
	add $10
	ldh [hMultiPurpose0], a
;> oam = wOAMBuffer + 0x4C
	ld hl, wOAMBuffer + $4c
;> count = 0x15 if wGameplaySubtype == 4 else 0x10
	ld c, $10
	ld a, [wGameplaySubtype]
	cp $04
	jr nz, .loop
	ld c, $15
;>@l for i in range(count):
;>     mem[oam + 4 * i] = hMultiPurpose1
.loop
	ldh a, [hMultiPurpose1]
	ld [hli], a
;>     mem[oam + 4 * i + 1] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld [hli], a
;>@t     mem[oam + 4 * i + 2] = 0x28 if GetRandomByte() & 1 == 0 else (GetRandomByte() & 6) + 0x70
	call GetRandomByte
	and $01
	ld a, $28
	jr z, .tile
	call GetRandomByte
	and $06
;=@t
	add $70
.tile
	ld [hli], a
;>     mem[oam + 4 * i + 3] = 0
	ld a, $00
	ld [hli], a
;>     hMultiPurpose0 = (hMultiPurpose0 + 0x1C) & 0xFF
	ldh a, [hMultiPurpose0]
	add $1c
	ldh [hMultiPurpose0], a
;>     if hMultiPurpose0 >= 0xA0:
	cp $a0
	jr c, .next
;>         hMultiPurpose0 -= 0x98
	sub $98
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = (hMultiPurpose1 + 0x25) & 0xFF
	ldh a, [hMultiPurpose1]
	add $25
	ldh [hMultiPurpose1], a
.next
;=@l
	dec c
	jr nz, .loop
	ret


;@ path: title/storm
;@ Draw command used on the second storm screen (15 bytes): two columns of 4 tiles ($83 = 4 tiles going
;@ down) at VRAM $992B (tiles $1E-$24) and $992C (tiles $1F-$25), then the end mark 0.
StormView2Command::
	db $99, $2b, $83, $1e, $20, $22, $24
	db $99, $2c, $83, $1f, $21, $23, $25
	db $00

;@ def DrawStormView2Tiles()
;@ path: title/storm
;@ Copies StormView2Command into the draw command buffer (drawn at the next VBlank).
DrawStormView2Tiles::
;>@c copy(wDrawCommand, StormView2Command, 0x0F)
	ld de, wDrawCommand
	ld hl, StormView2Command
	ld c, $0f
.copy
	ld a, [hli]
	ld [de], a
	inc de
;=@c
	dec c
	jr nz, .copy
	ret


;@ def UpdateIntroEntities()
;@ path: title/entities
;@ Runs the intro's entities in slots 2, 1 and 0: for each used slot copies its x, y, sprite variant and
;@ state into the hActiveEntity variables and runs UpdateIntroEntity. Starts the OAM list from 0.
;@ test: skip calls the handlers
UpdateIntroEntities::
;> wOAMNextIndex = 0
	xor a
	ld [wOAMNextIndex], a
;>@l for slot in (2, 1, 0):
	ld c, $02
	ld b, $00
.loop
;>     wActiveEntitySlot = slot
	ld a, c
	ld [wActiveEntitySlot], a
;>     if wEntityStatus[slot]:
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, .next
;>         hActiveEntityX = wEntityX[slot]
	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a
;>         hActiveEntityDrawY = wEntityY[slot]
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
;>         hActiveEntitySpriteVariant = wEntitySpriteVariant[slot]
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
;>         hActiveEntityState = wEntityState[slot]
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a
;>         UpdateIntroEntity(slot)
	call UpdateIntroEntity
.next
;=@l
	dec c
	ld a, c
	cp $ff
	jr nz, .loop
	ret


;@ def UpdateIntroEntity(slot: bc)
;@ path: title/entities
;@ Runs one intro entity by its status: 5 Link's boat (IntroBoat), 6 Marin (IntroMarin), 7 Link on the
;@ beach (IntroLink), 8 a sparkle on the title screen (IntroSparkle); 1-4 a lightning bolt of that shape
;@ (DrawIntroLightning), shown until its timer runs out.
;@ test: skip calls the handlers
UpdateIntroEntity::
;> status = wEntityStatus[slot]
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
;> if status == 5:
;>     return IntroBoat(slot)
	cp $05
	jr z, IntroBoat
;> if status == 6:
;>     return IntroMarin(slot)
	cp $06
	jp z, IntroMarin
;> if status == 7:
;>     return IntroLink(slot)
	cp $07
	jp z, IntroLink
;> if status == 8:
;>     return IntroSparkle(slot)
	cp $08
	jp z, IntroSparkle
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .show
;>     wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;>     return
	ret
.show
;> wEntityTimer[slot] -= 1
	dec [hl]
;> DrawIntroLightning(slot)
	call DrawIntroLightning
	ret


;@ path: title/storm
;@ Link's boat, 6 sprites (4 bytes each: y offset, x offset, tile, attributes), written straight into OAM
;@ entries 0-5 by IntroBoat.
IntroBoatSprites::
	db $00, $00, $1c, $00,  $00, $08, $1e, $00
	db $10, $f8, $20, $00,  $10, $00, $22, $00,  $10, $08, $24, $00,  $10, $10, $26, $00

;@ path: title/storm
;@ The lightning bolt striking the boat, 4 sprites of tile $32 one above the other (same format as
;@ IntroBoatSprites), OAM entries 6-9.
IntroBoatBoltSprites::
	db $f8, $04, $32, $00,  $e8, $04, $32, $00,  $d8, $04, $32, $00,  $c8, $04, $32, $00

;@ path: title/storm
;@ How far the boat sinks into the waves (8 bytes, pixels down), one entry per 16 frames.
IntroBoatBob::
	db $02, $01, $00, $00, $00, $01, $02, $02

;@ def IntroBoat(slot: bc)
;@ path: title/storm
;@ Status 5, Link's boat: bobs on the waves (IntroBoatBob by the frame counter; still once the lightning
;@ has struck) and writes its six sprites straight into OAM entries 0-5; from $10 frames after the strike
;@ also the bolt hitting it (entries 6-9).
;@ test: slot = rand(0, 15)
IntroBoat::
;>@b bob = 0 if wSceneVar2 else (((hFrameCounter + 0xD0) & 0xFF) >> 4) & 7
	ld a, [wSceneVar2]
	and a
	ld a, $00
	jr nz, .bob
	ldh a, [hFrameCounter]
	add $d0
;=@b
	rra
	rra
	rra
	rra
	and $07
.bob
;>@y hActiveEntityDrawY = (hActiveEntityDrawY + mem[IntroBoatBob + bob]) & 0xFF
	ld e, a
	ld d, $00
	ld hl, IntroBoatBob
	add hl, de
	ld a, [hl]
	ld hl, hActiveEntityDrawY
;=@y
	add [hl]
	ld [hl], a
;>@d for i in range(6):
	ld hl, IntroBoatSprites
	ld de, wOAMBuffer
	push bc
	ld c, $06
.boat
;>     wOAMBuffer[4 * i] = (hActiveEntityDrawY + mem[IntroBoatSprites + (4 * i)]) & 0xFF
	ldh a, [hActiveEntityDrawY]
	add [hl]
	inc hl
	ld [de], a
	inc de
;>     wOAMBuffer[4 * i + 1] = (hActiveEntityX + mem[IntroBoatSprites + (4 * i + 1)]) & 0xFF
	ldh a, [hActiveEntityX]
	add [hl]
	inc hl
	ld [de], a
	inc de
;>     wOAMBuffer[4 * i + 2] = mem[IntroBoatSprites + (4 * i + 2)]
	ld a, [hli]
	ld [de], a
	inc de
;>     wOAMBuffer[4 * i + 3] = mem[IntroBoatSprites + (4 * i + 3)]
	ld a, [hli]
	ld [de], a
	inc de
;=@d
	dec c
	jr nz, .boat
;> if wSceneVar2 >= 0x10:
	ld a, [wSceneVar2]
	cp $10
	jr c, .done
;>@e     for i in range(4):
	ld hl, IntroBoatBoltSprites
	ld de, wOAMBuffer + $18
	ld c, $04
.bolt
;>         wOAMBuffer[0x18 + 4 * i] = (hActiveEntityDrawY + mem[IntroBoatBoltSprites + (4 * i)]) & 0xFF
	ldh a, [hActiveEntityDrawY]
	add [hl]
	inc hl
	ld [de], a
	inc de
;>         wOAMBuffer[0x18 + 4 * i + 1] = (hActiveEntityX + mem[IntroBoatBoltSprites + (4 * i + 1)]) & 0xFF
	ldh a, [hActiveEntityX]
	add [hl]
	inc hl
	ld [de], a
	inc de
;>         wOAMBuffer[0x18 + 4 * i + 2] = mem[IntroBoatBoltSprites + (4 * i + 2)]
	ld a, [hli]
	ld [de], a
	inc de
;>         wOAMBuffer[0x18 + 4 * i + 3] = mem[IntroBoatBoltSprites + (4 * i + 3)]
	ld a, [hli]
	ld [de], a
	inc de
;=@e
	dec c
	jr nz, .bolt
.done
;> return
	pop bc
	ret


;@ path: title/storm
;@ The four lightning bolt shapes (entity status 1-4), 6 sprites each (4 bytes: y offset, x offset, tile,
;@ attributes), drawn with DrawEntitySprites.
IntroLightningSprites::
	; bolt 0
	db $00, $00, $34, $00, $00, $08, $36, $00
	db $10, $00, $2c, $00, $20, $f8, $2c, $00
	db $28, $00, $2e, $20, $30, $f0, $2e, $00
	; bolt 1
	db $08, $00, $36, $20, $08, $08, $34, $20
	db $18, $00, $30, $00, $18, $08, $2c, $20
	db $28, $10, $2e, $20, $28, $10, $2e, $20
	; bolt 2
	db $00, $08, $34, $20, $00, $00, $36, $20
	db $10, $08, $2c, $20, $20, $10, $2c, $20
	db $28, $08, $2e, $00, $30, $18, $2e, $20
	; bolt 3
	db $08, $08, $36, $00, $08, $00, $34, $00
	db $18, $08, $30, $20, $18, $00, $2c, $00
	db $28, $f8, $2e, $00, $28, $f8, $2e, $00

;@ def DrawIntroLightning(slot: bc)
;@ path: title/storm
;@ Draws a lightning bolt of the shape given by its status (1-4): the 6 sprites at IntroLightningSprites
;@ + 24 * (status - 1) at the entity's position; then moves wOAMNextIndex on by 24 bytes.
;@ test: skip draws sprites
DrawIntroLightning::
;>@s sprites = IntroLightningSprites + 24 * (wEntityStatus[slot] - 1)
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	dec a
	sla a
	sla a
;=@s
	sla a
	ld e, a
	sla a
	add e
	ld e, a
	ld d, b
;=@s
	ld hl, IntroLightningSprites
	add hl, de
;> DrawEntitySprites(sprites, 6)
	ld c, $06
	call DrawEntitySprites
;> wOAMNextIndex += 0x18
	ld a, [wOAMNextIndex]
	add $18
	ld [wOAMNextIndex], a
	ret


;@ path: title/beach
;@ Marin's frames on the beach for DrawEntity16x16 (4 frames of 4 bytes: left tile, attributes, right
;@ tile, attributes): two walking frames, then two bent over Link.
IntroMarinFrames::
	db $00, $00, $02, $00
	db $04, $00, $06, $00
	db $08, $00, $0a, $00
	db $0c, $00, $0e, $00

;@ def IntroMarin(slot: bc)
;@ path: title/beach
;@ Status 6, Marin: keeps the waves sounding, draws her (DrawEntity16x16, IntroMarinFrames) and runs her
;@ state from IntroMarinStates.
;@ test: skip jump table
IntroMarin::
;> PlayIntroWaveSound()
	call PlayIntroWaveSound
;> wEntityPhysicsFlags[0] = 0
	xor a
	ld [wEntityPhysicsFlags], a
;> DrawEntity16x16(slot, IntroMarinFrames)
	ld de, IntroMarinFrames
	call DrawEntity16x16
;> wOAMNextIndex += 8
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a
;> return IntroMarinStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: title/beach
;@ Marin's states (5 dw code addresses, indexed by her entity state).
IntroMarinStates::
	dw IntroMarinWalk          ; 0
	dw IntroMarinStop          ; 1
	dw IntroMarinPan           ; 2
	dw IntroMarinPanSlow       ; 3
	dw IntroMarinKneel         ; 4

;@ def IntroMarinWalk(slot: bc)
;@ path: title/beach
;@ State 0: Marin walks left along the beach, one pixel every 4 frames (wEntityPrivateCounter counts),
;@ changing her walking frame every 8 frames, while the bands of the view scroll (ScrollIntroBeachFast).
;@ Left of x $48 she stops for $40 frames.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroMarinWalk::
;> ScrollIntroBeachFast()
	call ScrollIntroBeachFast
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 3) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
;> if hActiveEntityX < 0x48:
	ldh a, [hActiveEntityX]
	cp $48
	jr nc, .walk
;>     wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>     IncrementEntityState(slot)
	call IncrementEntityState
.walk
;> wEntityPrivateCounter[slot] -= 1
	ld hl, wEntityPrivateCounter
	add hl, bc
	dec [hl]
;> if wEntityPrivateCounter[slot] == 0:
	jr nz, .done
;>     wEntityPrivateCounter[slot] = 4
	ld [hl], $04
;>     wEntityX[slot] -= 1
	ld hl, wEntityX
	add hl, bc
	dec [hl]
.done
	ret


;@ def IntroMarinStop(slot: bc)
;@ path: title/beach
;@ State 1: Marin stands still for $40 frames; then Link appears lying on the sand to the right, outside
;@ the view (entity 1, status 7, x $FE, y $6E), and the frame counter starts from 0.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroMarinStop::
;> AnimateIntroSeaTiles()
	call AnimateIntroSeaTiles
;> SetEntitySpriteVariant(slot, 1)
	ld a, $01
	call SetEntitySpriteVariant
;> if GetEntityTimer(slot) == 0:
	call GetEntityTimer
	jr nz, .wait
;>     IncrementEntityState(slot)
	call IncrementEntityState
;>     wEntityStatus[1] = 7
	ld a, $07
	ld [wEntityStatus + 1], a
;>     wEntityX[1] = 0xFE
	ld a, $fe
	ld [wEntityX + 1], a
;>     wEntityY[1] = 0x6E
	ld a, $6e
	ld [wEntityY + 1], a
;>     wEntityState[1] = 0
	xor a
	ld [wEntityState + 1], a
;>     wEntityTimer[1] = 0
	ld [wEntityTimer + 1], a
;>     hFrameCounter = 0
	ldh [hFrameCounter], a
;>     return
	ret
.wait
;> wEntityTimer[slot] -= 1
	dec [hl]
	ret


;@ def IntroMarinPan(slot: bc)
;@ path: title/beach
;@ State 2: Marin walks on (frame every 4 frames) and the view pans right towards Link: one pixel every
;@ second frame, while Link's entity moves left by one pixel a frame. At scroll $20 and $22 the left
;@ columns of the background are redrawn (DrawBeachColumn1 / 2); at $30 the pan pauses for $40 frames.
;@ test: slot = rand(0, 15)
IntroMarinPan::
;> ScrollIntroBeachFast()
	call ScrollIntroBeachFast
;> wEntityX[1] -= 1
	ld a, [wEntityX + 1]
	dec a
	ld [wEntityX + 1], a
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .legs
;>     hBaseScrollX += 1
	ld hl, hBaseScrollX
	inc [hl]
	ld a, [hl]
;>     if hBaseScrollX == 0x30:
	cp $30
	jr nz, .at20
;>         wEntityTimer[slot] = 0x40
	call GetEntityTimer
	ld [hl], $40
;>         return IncrementEntityState(slot)
	jp IncrementEntityState
.at20
;>     if hBaseScrollX == 0x20:
	cp $20
	jr nz, .at22
;>         DrawBeachColumn1()
	call DrawBeachColumn1
	xor a
.at22
;>     elif hBaseScrollX == 0x22:
	cp $22
	jr nz, .legs
;>         DrawBeachColumn2()
	call DrawBeachColumn2
	xor a
.legs
;> SetEntitySpriteVariant(slot, (hFrameCounter >> 2) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


;@ def IntroMarinPanSlow(slot: bc)
;@ path: title/beach
;@ State 3: after the pause, the pan goes on more slowly (one pixel every 4 frames, Link's entity one
;@ pixel every 2 frames, ScrollIntroBeachSlow), with pauses of $30 frames at scroll $3A and $50 frames at
;@ $40. At $56 the scroll jumps to $A0, the band interrupt is switched off (rIE 1) and Marin goes on to
;@ kneel by Link ($E0 frames). The background columns are redrawn at $20 / $22 as before.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroMarinPanSlow::
;> if GetEntityTimer(slot):
	call GetEntityTimer
	jr nz, .wait
;>@w1     wEntityTimer[slot] -= 1
;>@w2     AnimateIntroSeaTiles()
;>@w3     return SetEntitySpriteVariant(slot, 1)
;> ScrollIntroBeachSlow()
	call ScrollIntroBeachSlow
;> if hFrameCounter & 1 == 0:
	ldh a, [hFrameCounter]
	and $01
	jr nz, .legs
;>     wEntityX[1] -= 1
	ld a, [wEntityX + 1]
	dec a
	ld [wEntityX + 1], a
;>     if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .legs
;>         hBaseScrollX += 1
	ld hl, hBaseScrollX
	inc [hl]
	ld a, [hl]
;>         if hBaseScrollX == 0x40:
	cp $40
	jr z, .at40
;>@t1             wEntityTimer[slot] = 0x50
;>         if hBaseScrollX == 0x3A:
	cp $3a
	jr nz, .at56
;>             wEntityTimer[slot] = 0x30
	call GetEntityTimer
	ld [hl], $30
	jr .at56
.at40
;=@t1
	call GetEntityTimer
	ld [hl], $50
.at56
;>         if hBaseScrollX == 0x56:
	ldh a, [hBaseScrollX]
	cp $56
	jr nz, .at20
;>             hBaseScrollX = 0xA0
	ld a, $a0
	ld [hl], a
;>             rSCX = 0xA0
	ldh [rSCX], a
;>             rIE = 0x01
	ld a, $01
	ldh [rIE], a
;>             wEntityTimer[slot] = 0xE0
	call GetEntityTimer
	ld [hl], $e0
;>             return IncrementEntityState(slot)
	jp IncrementEntityState
.at20
;>         if hBaseScrollX == 0x20:
	cp $20
	jr nz, .at22
;>             DrawBeachColumn1()
	call DrawBeachColumn1
	xor a
.at22
;>         elif hBaseScrollX == 0x22:
	cp $22
	jr nz, .legs
;>             DrawBeachColumn2()
	call DrawBeachColumn2
	xor a
.legs
;>@v SetEntitySpriteVariant(slot, (hFrameCounter >> 4) & 1)
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
;=@v
	call SetEntitySpriteVariant
	ret
.wait
;=@w1
	dec [hl]
;=@w2
	call AnimateIntroSeaTiles
;=@w3
	ld a, $01
	jp SetEntitySpriteVariant


;@ def IntroMarinKneel(slot: bc)
;@ path: title/beach
;@ State 4: Marin kneels by Link (frame 2). Every second frame her timer counts down; while it is in
;@ $90-$9F, $4A-$4F or $36-$3B she shows frame 3 and Link's entity frame 1.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroMarinKneel::
;> AnimateIntroSeaTiles()
	call AnimateIntroSeaTiles
;> if hFrameCounter & 1:
	ldh a, [hFrameCounter]
	and $01
;>     return
	jr nz, .done
;> SetEntitySpriteVariant(slot, 2)
	ld a, $02
	call SetEntitySpriteVariant
;> wEntitySpriteVariant[1] = 0
	ld a, $00
	ld [wEntitySpriteVariant + 1], a
;> t = wEntityTimer[slot]
	call GetEntityTimer
;> if t:
	jr z, .check
;>     wEntityTimer[slot] -= 1
	dec [hl]
.check
;>@c if 0x90 <= t < 0xA0 or 0x4A <= t < 0x50 or 0x36 <= t < 0x3C:
	cp $a0
	jr nc, .done
	cp $90
	jr nc, .pose
	cp $50
	jr nc, .done
;=@c
	cp $4a
	jr nc, .pose
	cp $3c
	jr nc, .done
	cp $36
	jr c, .done
.pose
;>     SetEntitySpriteVariant(slot, 3)
	ld a, $03
	call SetEntitySpriteVariant
;>     wEntitySpriteVariant[1] = 1
	ld a, $01
	ld [wEntitySpriteVariant + 1], a
.done
	ret


;@ path: title/screen
;@ The 8 frames of a title screen sparkle for DrawEntity16x16 (4 bytes each: left tile, attributes, right
;@ tile, attributes; attributes $20 = mirrored): it grows from tile $38 to $3C/$3E and shrinks again.
IntroSparkleFrames::
	db $38, $00, $38, $20,  $3a, $00, $3a, $20,  $3a, $00, $3a, $20,  $3c, $00, $3e, $00
	db $3c, $00, $3e, $00,  $3a, $00, $3a, $20,  $3a, $00, $3a, $20,  $38, $00, $38, $20

;@ def IntroSparkle(slot: bc)
;@ path: title/screen
;@ Status 8, a sparkle on the title screen: counts its timer down, then frees its slot; draws frame
;@ (timer >> 3) & 7 of IntroSparkleFrames.
;@ test: skip draws sprites
IntroSparkle::
;> wEntityTimer[slot] -= 1
	call GetEntityTimer
	dec [hl]
;> if wEntityTimer[slot] == 0:
	jr nz, .draw
;>     wEntityStatus[slot] = 0
	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
;>     return
	ret
.draw
;> hActiveEntitySpriteVariant = (wEntityTimer[slot] >> 3) & 7
	ld a, [hl]
	rra
	rra
	rra
	and $07
	ldh [hActiveEntitySpriteVariant], a
;> wEntityPhysicsFlags[0] = 0
	xor a
	ld [wEntityPhysicsFlags], a
;> DrawEntity16x16(slot, IntroSparkleFrames)
	ld de, IntroSparkleFrames
	call DrawEntity16x16
;> wOAMNextIndex += 8
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a
	ret


;@ path: title/beach
;@ Draw command used during the pan (17 bytes): rows 0-3 of BG columns 0-3 become tile $7D ($43 = one
;@ tile 4 times in a row), at VRAM $9800, $9820, $9840 and $9860; then the end mark 0.
BeachColumn1Command::
	db $98, $00, $43, $7d
	db $98, $20, $43, $7d
	db $98, $40, $43, $7d
	db $98, $60, $43, $7d
	db $00

;@ path: title/beach
;@ Draw command used during the pan (20 bytes): BG columns 4-7, row 0 the tiles $7D $7D $4C $4D, rows 1-3
;@ tile $7D; then the end mark 0.
BeachColumn2Command::
	db $98, $04, $03, $7d, $7d, $4c, $4d
	db $98, $24, $43, $7d
	db $98, $44, $43, $7d
	db $98, $64, $43, $7d
	db $00

;@ def DrawBeachColumn2()
;@ path: title/beach
;@ Copies BeachColumn2Command into the draw command buffer (the copy of DrawBeachColumn1).
;@ test: skip jumps into another unit
DrawBeachColumn2::
;> return DrawBeachColumn1.copy(BeachColumn2Command)
	ld hl, BeachColumn2Command
	jr DrawBeachColumn1.copy

;@ def DrawBeachColumn1()
;@ path: title/beach
;@ Copies BeachColumn1Command into the draw command buffer: always $18 bytes, which is more than the
;@ command needs (the end mark stops it).
DrawBeachColumn1::
;> src = BeachColumn1Command
	ld hl, BeachColumn1Command
.copy
;>@c copy(wDrawCommand, src, 0x18)
	ld de, wDrawCommand
	push bc
	ld c, $18
.loop
	ld a, [hli]
	ld [de], a
	inc de
;=@c
	dec c
	jr nz, .loop
;> return
	pop bc
	ret


;@ path: title/beach
;@ Link lying on the sand, 2 frames for DrawEntity16x16 (4 bytes: left tile, attributes, right tile,
;@ attributes): eyes closed, and the frame shown while Marin looks at him.
IntroLinkFrames::
	db $10, $00, $12, $00
	db $14, $00, $16, $00

;@ def IntroLink(slot: bc)
;@ path: title/beach
;@ Status 7, Link lying on the beach: drawn (DrawEntity16x16, IntroLinkFrames) while on screen
;@ (x < $F0); runs his state from IntroLinkStates.
;@ test: skip jump table
IntroLink::
;> if hActiveEntityX < 0xF0:
	ldh a, [hActiveEntityX]
	cp $f0
	jr nc, .state
;>     wEntityPhysicsFlags[0] = 0
	xor a
	ld [wEntityPhysicsFlags], a
;>     DrawEntity16x16(slot, IntroLinkFrames)
	ld de, IntroLinkFrames
	call DrawEntity16x16
;>     wOAMNextIndex += 8
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a
.state
;> return IntroLinkStates[hActiveEntityState](slot)
	ldh a, [hActiveEntityState]
	rst $00

;@ path: title/beach
;@ The states of Link's beach entity (4 dw code addresses): wait, wait, the view rises to the sky, wait.
IntroLinkStates::
	dw IntroLinkWait           ; 0
	dw IntroLinkWait2          ; 1
	dw IntroScrollToSky        ; 2
	dw IntroSkyWait            ; 3

;@ def IntroLinkWait(slot: bc)
;@ path: title/beach
;@ State 0: counts the timer down (from 0, so 256 frames), then sets it to $90 for the next state.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroLinkWait::
;> wEntityTimer[slot] = (wEntityTimer[slot] - 1) & 0xFF
	call GetEntityTimer
	dec [hl]
;> if wEntityTimer[slot] == 0:
	jr nz, .done
;>     wEntityTimer[slot] = 0x90
	ld [hl], $90
;>     IncrementEntityState(slot)
	call IncrementEntityState
.done
	ret


;@ def IntroLinkWait2(slot: bc)
;@ path: title/beach
;@ State 1: counts the timer down once every 4 frames, then goes on.
;@ test: slot = rand(0, 15)
IntroLinkWait2::
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;>     wEntityTimer[slot] -= 1
	call GetEntityTimer
	dec [hl]
;>     if wEntityTimer[slot] == 0:
	jr z, .next
;>@n         return IncrementEntityState(slot)
.done
;> return
	ret
.next
;=@n
	jp IncrementEntityState


;@ def IntroScrollToSky(slot: bc)
;@ path: title/beach
;@ State 2: the view rises from the beach to the sky. Every 4 frames (wSceneStep counts) Marin and Link
;@ move down one pixel (to y $A0 at most) and the view scrolls up one line; every 8 lines the next row of
;@ the sky is drawn above it (DrawIntroSkyRow, rows counted in wSceneFadeStep). At row $0B the title music
;@ (1) starts. After row $13 the music volume is set to 7 / $70 and Link's timer to $17 for the last wait.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
;@ test: wSceneFadeStep = rand(0, 0x13)
IntroScrollToSky::
;> if wSceneFadeStep == 0x13:
	ld a, [wSceneFadeStep]
	cp $13
	jr z, .rowsDone
;>@e1     IncrementEntityState(slot)
;>@e2     wEntityTimer[slot] = 0x17
;>@e3     hVolumeRight = 7
;>@e4     hVolumeLeft = 0x70
;>@e5     return
;> wSceneStep = (wSceneStep + 1) & 0xFF
	ld a, [wSceneStep]
	inc a
	ld [wSceneStep], a
;> if wSceneStep & 3:
	and $03
;>     return
	jr nz, .done
;> if wEntityY[0] < 0xA0:
	ld a, [wEntityY]
	cp $a0
	jr nc, .link
;>     wEntityY[0] += 1
	inc a
	ld [wEntityY], a
.link
;> if wEntityY[1] < 0xA0:
	ld a, [wEntityY + 1]
	cp $a0
	jr nc, .scroll
;>     wEntityY[1] += 1
	inc a
	ld [wEntityY + 1], a
.scroll
;> y = hBaseScrollY
	ldh a, [hBaseScrollY]
	push af
;> hBaseScrollY = (y - 1) & 0xFF
	dec a
	ldh [hBaseScrollY], a
	pop af
;> if y & 7:
	and $07
;>     return
	jr nz, .done
;> DrawIntroSkyRow()
	push bc
	call DrawIntroSkyRow
	pop bc
;> if wSceneFadeStep == 0x0B:
	ld a, [wSceneFadeStep]
	cp $0b
	jr nz, .done
;>     wMusicTrackToPlay = 1
	ld a, $01
	ld [wMusicTrackToPlay], a
.done
	ret
.rowsDone
;=@e1
	call IncrementEntityState
;=@e2
	call GetEntityTimer
	ld [hl], $17
;=@e3
	ld a, $07
	ldh [hVolumeRight], a
;=@e4
	ld a, $70
	ldh [hVolumeLeft], a
;=@e5
	ret


;@ def IntroSkyWait(slot: bc)
;@ path: title/beach
;@ State 3: counts the timer down once every 4 frames; then the intro goes on to the title logo (next
;@ subtype) and the scene variables and entities 0 and 1 are cleared.
;@ test: slot = rand(0, 15)
;@ test: wCurrentBank = $01
IntroSkyWait::
;> if hFrameCounter & 3 == 0:
	ldh a, [hFrameCounter]
	and $03
	jr nz, .done
;>     wEntityTimer[slot] -= 1
	call GetEntityTimer
	dec [hl]
;>     if wEntityTimer[slot] == 0:
	jr nz, .done
;>         IncrementGameplaySubtype()
	call IncrementGameplaySubtype
;>         wSceneVar2 = 0
	xor a
	ld [wSceneVar2], a
;>         wSceneVar3 = 0
	ld [wSceneVar3], a
;>         wSceneVar4 = 0
	ld [wSceneVar4], a
;>         wEntityStatus[0] = 0
	ld [wEntityStatus], a
;>         wEntityStatus[1] = 0
	ld [wEntityStatus + 1], a
.done
	ret


;@ path: title/beach
;@ The sky above the beach, 32 rows of 20 BG tiles (640 bytes), drawn row by row by DrawIntroSkyRow
;@ while the view rises; only rows 0-$12 are used (the rest is the plain tile $7C).
IntroSkyTilemap::
	; row 0
	db $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $4c, $4d, $7c, $7c
	; row 1
	db $7c, $7c, $7c, $7c, $44, $45, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $7d, $4c, $4d, $7c, $7c, $7c, $7c
	; row 2
	db $7c, $7c, $7c, $7c, $7c, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7c, $7c, $7c, $7c, $7c
	; row 3
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $46, $7d, $7d, $7d, $7d, $4b, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 4
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $5c, $5d, $5e, $5f, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 5
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $58, $59, $5a, $5b, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 6
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $54, $55, $56, $57, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 7
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $50, $51, $52, $53, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 8
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $2b, $2c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 9
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 10
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 11
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 12
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 13
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 14
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 15
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 16
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 17
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 18
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 19
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 20
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 21
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 22
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 23
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 24
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 25
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 26
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 27
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 28
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 29
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 30
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
	; row 31
	db $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c

;@ def DrawIntroSkyRow()
;@ path: title/beach
;@ Draws the next row of the sky as the view rises: row wSceneFadeStep of IntroSkyTilemap (20 tiles),
;@ as a draw command to the BG address in wSceneVarC:wSceneVarB - $9BF4 for row 0, then one BG row ($20)
;@ higher each time; then counts the row.
;@ test: wSceneFadeStep = rand(0, 31)
DrawIntroSkyRow::
;> if wSceneFadeStep == 0:
	ld a, [wSceneFadeStep]
	and a
	jr nz, .draw
;>     wSceneVarB = 0xF4
	ld a, $f4
	ld [wSceneVarB], a
;>     wSceneVarC = 0x9B
	ld a, $9b
	ld [wSceneVarC], a
.draw
;>@o offset = wSceneFadeStep * 20
	ld a, [wSceneFadeStep]
	ld e, a
	ld d, $00
	sla e
	rl d
	sla e
;=@o
	rl d
	ld a, e
	sla e
	rl d
	sla e
	rl d
;=@o
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
;> wDrawCommand[0] = wSceneVarC
	ld c, $00
	ld hl, wDrawCommand
	ld a, [wSceneVarC]
	ld [hli], a
;> wDrawCommand[1] = wSceneVarB
	ld a, [wSceneVarB]
	ld [hli], a
;> wDrawCommand[2] = 0x13
	ld a, $13
	ld [hli], a
;>@l for i in range(20):
;>     wDrawCommand[3 + i] = mem[IntroSkyTilemap + offset + i]
.loop
	push hl
	ld hl, IntroSkyTilemap
	add hl, de
	ld a, [hl]
	pop hl
	ld [hli], a
;=@l
	inc de
	inc c
	ld a, c
	cp $14
	jr nz, .loop
;> wDrawCommand[23] = 0
	ld [hl], $00
;> wSceneFadeStep += 1
	ld hl, wSceneFadeStep
	inc [hl]
;> borrow = wSceneVarB < 0x20
;> wSceneVarB = (wSceneVarB - 0x20) & 0xFF
	ld a, [wSceneVarB]
	sub $20
	ld [wSceneVarB], a
;> wSceneVarC = (wSceneVarC - borrow) & 0xFF
	ld a, [wSceneVarC]
	sbc $00
	ld [wSceneVarC], a
	ret


;@ path: title/storm
;@ Sources (in bank $10) of the four frames of the storm sea's 8 animated tiles (4 dw, $80 bytes each).
IntroSeaTilesA::
	dw Tiles105000, Tiles105000 + $80, Tiles105000 + $100, Tiles105000 + $180

;@ path: title/beach
;@ Sources (in bank $10) of the four frames of the beach sea's 8 animated tiles (4 dw).
IntroSeaTilesB::
	dw Tiles105000 + $200, Tiles105000 + $280, Tiles105000 + $300, Tiles105000 + $380
;@ path: title/intro
;@ The sea animation's frame (as a byte offset into IntroSeaTilesA / B: 0, 2, 4, 6) for each step of 16
;@ frames (8 bytes): forth and back.
IntroSeaTileOffsets::
	db $00, $02, $04, $06, $06, $04, $02, $00

;@ path: title/storm
;@ Up-and-down movement of the lowest band of the storm sea (8 bytes, pixels; used negated as the band's y
;@ scroll), one entry per 16 frames.
IntroSeaBob::
	db $03, $02, $01, $00, $00, $01, $02, $03

;@ def UpdateIntroStormScroll()
;@ path: title/storm
;@ Moves the storm's parallax bands (wIntroBandScrollX): band 0 one pixel every 8 frames, band 1 every
;@ 16, band 2 every 32, band 3 every 16, band 4 by $28/256 pixel a frame (fraction in wSceneVar4); lets
;@ the lowest band bob up and down (wIntroBandScrollY = -IntroSeaBob[...]) and animates the sea tiles.
;@ test: skip runs on into another unit
UpdateIntroStormScroll::
;> if hFrameCounter & 7 == 0:
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $07
	jr nz, .band1
;>     wIntroBandScrollX[0] += 1
	inc [hl]
.band1
;> if hFrameCounter & 0x0F == 0:
	inc hl
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .band2
;>     wIntroBandScrollX[1] += 1
	inc [hl]
.band2
;> if hFrameCounter & 0x1F == 0:
	inc hl
	ldh a, [hFrameCounter]
	and $1f
	jr nz, .band3
;>     wIntroBandScrollX[2] += 1
	inc [hl]
.band3
;> if hFrameCounter & 0x0F == 0:
	inc hl
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .band4
;>     wIntroBandScrollX[3] += 1
	inc [hl]
.band4
;> wSceneVar4 += 0x28
	inc hl
	ld a, [wSceneVar4]
	add $28
	ld [wSceneVar4], a
;> if wSceneVar4 < 0x28:   # the addition carried
	jr nc, .bob
;>     wIntroBandScrollX[4] += 1
	inc [hl]
.bob
;>@b wIntroBandScrollY = -mem[IntroSeaBob + ((((hFrameCounter + 0xFC) & 0xFF) >> 4) & 7)] & 0xFF
	ldh a, [hFrameCounter]
	add $fc
	rra
	rra
	rra
	rra
;=@b
	and $07
	ld e, a
	ld d, $00
	ld hl, IntroSeaBob
	add hl, de
	ld a, $00
;=@b
	sub [hl]
	ld [wIntroBandScrollY], a
;> return AnimateIntroSeaTiles()   # runs on into it

;@ def AnimateIntroSeaTiles()
;@ path: title/intro
;@ In frames 4-15 of every 16, asks the VBlank handler to copy the next quarter of the sea's animated
;@ tiles (QueueIntroSeaTiles).
;@ test: skip runs on into another unit
AnimateIntroSeaTiles::
;> if hFrameCounter & 0x0F < 4:
	ldh a, [hFrameCounter]
	and $0f
	cp $04
;>     return
	jr c, QueueIntroSeaTiles.done
;> return QueueIntroSeaTiles()   # runs on into it

;@ def QueueIntroSeaTiles()
;@ path: title/intro
;@ Asks the VBlank handler to copy 32 bytes (two tiles) of the sea animation from bank $10: the frame
;@ from IntroSeaTileOffsets by (hFrameCounter >> 4) & 7, out of IntroSeaTilesA (storm, to $8900) or, when
;@ wSceneVarF is set, IntroSeaTilesB (beach and title, to $9300); the quarter by hFrameCounter & 3. The
;@ request is the source address in wSceneTimer / wSceneTimer2 and the target in wSceneTimer3 /
;@ wSceneSlowTimer (the VBlank handler reads them as two words).
QueueIntroSeaTiles::
;>@fr frame = mem[IntroSeaTileOffsets + ((hFrameCounter >> 4) & 7)]
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $07
;=@fr
	ld e, a
	ld d, $00
	ld hl, IntroSeaTileOffsets
	add hl, de
	ld e, [hl]
;> table = IntroSeaTilesB if wSceneVarF else IntroSeaTilesA
	ld hl, IntroSeaTilesA
	ld a, [wSceneVarF]
	and a
	jr z, .table
	ld hl, IntroSeaTilesB
.table
;> src = mem16[table + frame]
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
;> dst_high = 0x93 if wSceneVarF else 0x89
	ld de, $8900
	ld a, [wSceneVarF]
	and a
	jr z, .target
	ld de, $9300
.target
;>@q quarter = (hFrameCounter & 3) << 5
	ldh a, [hFrameCounter]
	and $03
	sla a
	sla a
	sla a
	sla a
;=@q
	sla a
	ld e, a
;> src += quarter
	add l
	ld l, a
;> wSceneTimer = src & 0xFF
	ld a, l
	ld [wSceneTimer], a
;> wSceneTimer2 = src >> 8
	ld a, h
	ld [wSceneTimer2], a
;> wSceneTimer3 = quarter
	ld a, e
	ld [wSceneTimer3], a
;> wSceneSlowTimer = dst_high
	ld a, d
	ld [wSceneSlowTimer], a
.done
	ret


;@ def ScrollIntroBeachFast()
;@ path: title/beach
;@ Moves the beach's parallax bands while Marin walks: band 0 one pixel every 8 frames, bands 1-3 by
;@ $50, $58 and $B0 / 256 pixel a frame (fractions in wSceneVar4, wSceneVar5, wSceneVarD); then
;@ animates the sea tiles.
;@ test: skip jumps into another unit
ScrollIntroBeachFast::
;> if hFrameCounter & 7 == 0:
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $07
	jr nz, .band1
;>     wIntroBandScrollX[0] += 1
	inc [hl]
.band1
;> wSceneVar4 += 0x50
	ld hl, wIntroBandScrollX + 1
	ld a, [wSceneVar4]
	add $50
	ld [wSceneVar4], a
;> if wSceneVar4 < 0x50:   # the addition carried
	jr nc, .band2
;>     wIntroBandScrollX[1] += 1
	inc [hl]
.band2
;> wSceneVar5 += 0x58
	inc hl
	ld a, [wSceneVar5]
	add $58
	ld [wSceneVar5], a
;> if wSceneVar5 < 0x58:   # the addition carried
	jr nc, .band3
;>     wIntroBandScrollX[2] += 1
	inc [hl]
.band3
;> wSceneVarD += 0xB0
	inc hl
	ld a, [wSceneVarD]
	add $b0
	ld [wSceneVarD], a
;> if wSceneVarD < 0xB0:   # the addition carried
	jr nc, .sea
;>     wIntroBandScrollX[3] += 1
	inc [hl]
.sea
;> return AnimateIntroSeaTiles()
	jp AnimateIntroSeaTiles


;@ def ScrollIntroBeachSlow()
;@ path: title/beach
;@ The slower version of ScrollIntroBeachFast for the second part of the pan: band 0 every 16 frames,
;@ bands 1-3 by $28, $2C and $58 / 256 pixel a frame; then animates the sea tiles.
;@ test: skip jumps into another unit
ScrollIntroBeachSlow::
;> if hFrameCounter & 0x0F == 0:
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $0f
	jr nz, .band1
;>     wIntroBandScrollX[0] += 1
	inc [hl]
.band1
;> wSceneVar4 += 0x28
	ld hl, wIntroBandScrollX + 1
	ld a, [wSceneVar4]
	add $28
	ld [wSceneVar4], a
;> if wSceneVar4 < 0x28:   # the addition carried
	jr nc, .band2
;>     wIntroBandScrollX[1] += 1
	inc [hl]
.band2
;> wSceneVar5 += 0x2C
	inc hl
	ld a, [wSceneVar5]
	add $2c
	ld [wSceneVar5], a
;> if wSceneVar5 < 0x2C:   # the addition carried
	jr nc, .band3
;>     wIntroBandScrollX[2] += 1
	inc [hl]
.band3
;> wSceneVarD += 0x58
	inc hl
	ld a, [wSceneVarD]
	add $58
	ld [wSceneVarD], a
;> if wSceneVarD < 0x58:   # the addition carried
	jr nc, .sea
;>     wIntroBandScrollX[3] += 1
	inc [hl]
.sea
;> return AnimateIntroSeaTiles()
	jp AnimateIntroSeaTiles


;@ def TileJobInstruments()
;@ path: menu/inventory
;@ Background tile job 7 (hNeedsUpdatingBGTiles), run by the VBlank handler one stage per frame
;@ (hBGTilesLoadingStage): stages 0-7 copy the instrument tiles, 64 bytes each, from bank $0C $4D00 to
;@ $8D00 (CopyInstrumentTilesStage); stage 8 draws the slots of instruments 1-4 into BG map 1, stage 9
;@ those of 5-8 and ends the job.
;@ test: skip runs in VBlank
TileJobInstruments::
;> if hBGTilesLoadingStage < 8:
	ldh a, [hBGTilesLoadingStage]
	cp $08
;>     return CopyInstrumentTilesStage(hBGTilesLoadingStage)
	jp c, CopyInstrumentTilesStage
;> if hBGTilesLoadingStage == 8:
	jr nz, .last
;>     DrawInstruments1To4()
	call DrawInstruments1To4
;>     hBGTilesLoadingStage += 1
	ld hl, hBGTilesLoadingStage
	inc [hl]
;>     return
	ret
.last
;> DrawInstruments5To8()
	call DrawInstruments5To8
;> hNeedsUpdatingBGTiles = 0
	xor a
	ldh [hNeedsUpdatingBGTiles], a
;> hBGTilesLoadingStage = 0
	ldh [hBGTilesLoadingStage], a
	ret


;@ path: menu/inventory
;@ Low bytes of the BG map 1 addresses ($9Dxx) of the eight instrument slots (8 bytes, the top left tile
;@ of each 2x2 slot).
InstrumentSlotAddresses::
	db $0f, $51, $b1, $ef, $ec, $aa, $4a, $0c

;@ path: menu/inventory
;@ Tile in the bottom right corner of an empty instrument slot (8 bytes): the numbers 1-8 ($B1-$B8).
InstrumentNumberTiles::
	db $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8
;@ path: menu/inventory
;@ Top left tile of each instrument's 2x2 picture (8 bytes); the others are +1, +$10 and +$11.
InstrumentTiles::
	db $d0, $d2, $d4, $d6, $d8, $da, $dc, $de

;@ path: menu/inventory
;@ Steps between the four tiles of a slot in BG map 1 (3 bytes): +1 to the right, +$1F to the next
;@ row's left tile, +1 to the right.
InstrumentTileOffsets::
	db $01, $1f, $01

;@ def DrawInstruments5To8()
;@ path: menu/inventory
;@ Draws the slots of instruments 5-8 (the second half of DrawInstruments1To4).
;@ test: skip jumps into another unit
DrawInstruments5To8::
;> end = 8
	ld c, $08
;> first = 4
	ld e, $04
;> return DrawInstruments1To4.start(first, end)
	jr DrawInstruments1To4.start

;@ def DrawInstruments1To4()
;@ path: menu/inventory
;@ Draws the 2x2 tile slots of instruments 1-4 into BG map 1 ($9Dxx; DrawInstruments5To8 does 5-8): an
;@ obtained instrument (wDungeonFlags bit 1) shows its picture, a missing one three blank tiles ($7C) and
;@ its number in the bottom right corner.
DrawInstruments1To4::
;> end = 4
	ld c, $04
;> first = 0
	ld e, $00
.start
;> hMultiPurpose9 = end
	ld a, c
	ldh [hMultiPurpose9], a
	ld d, $00
;>@l for i in range(first, end):
.loop
;>     hMultiPurpose0 = 0
	xor a
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = 0
	ldh [hMultiPurpose1], a
;>     hMultiPurpose2 = 0
	ldh [hMultiPurpose2], a
;>     hMultiPurpose3 = 0
	ldh [hMultiPurpose3], a
;>     if wDungeonFlags[i] & 2 == 0:
	ld hl, wDungeonFlags
	add hl, de
	ld a, [hl]
	bit 1, a
	jp nz, .owned
;>@v         vram = 0x9D00 | mem[InstrumentSlotAddresses + i]
	ld c, $00
	ld b, c
	ld hl, InstrumentSlotAddresses
	add hl, de
	ld a, [hl]
	ld l, a
;=@v
	ld h, $9d
	push hl
;>         hMultiPurpose0 = 0x7C
	ld a, $7c
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = 0x7C
	ldh [hMultiPurpose1], a
;>         hMultiPurpose2 = 0x7C
	ldh [hMultiPurpose2], a
;>         hMultiPurpose3 = mem[InstrumentNumberTiles + i]
	ld hl, InstrumentNumberTiles
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose3], a
	pop hl
	jr .draw
;>     else:
.owned
;>@w         vram = 0x9D00 | mem[InstrumentSlotAddresses + i]
	ld c, $00
	ld b, c
	ld hl, InstrumentSlotAddresses
	add hl, de
	ld a, [hl]
	ld l, a
;=@w
	ld h, $9d
	push hl
;>         hMultiPurpose0 = mem[InstrumentTiles + i]
	ld hl, InstrumentTiles
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = mem[InstrumentTiles + i] + 1
	inc a
	ldh [hMultiPurpose1], a
;>         hMultiPurpose2 = mem[InstrumentTiles + i] + 0x10
	add $0f
	ldh [hMultiPurpose2], a
;>         hMultiPurpose3 = mem[InstrumentTiles + i] + 0x11
	inc a
	ldh [hMultiPurpose3], a
	pop hl
.draw
;>     mem[vram] = hMultiPurpose0
	ldh a, [hMultiPurpose0]
	ld [hl], a
;>     mem[vram + 1] = hMultiPurpose1
	call NextInstrumentTile
	ldh a, [hMultiPurpose1]
	ld [hl], a
;>     mem[vram + 0x20] = hMultiPurpose2
	inc c
	call NextInstrumentTile
	ldh a, [hMultiPurpose2]
	ld [hl], a
;>     mem[vram + 0x21] = hMultiPurpose3
	inc c
	call NextInstrumentTile
	ldh a, [hMultiPurpose3]
	ld [hl], a
;=@l
	inc e
	ld a, e
	ld hl, hMultiPurpose9
	cp [hl]
	jp nz, .loop
	ret


;@ def NextInstrumentTile(vram: hl, step: bc) -> hl
;@ path: menu/inventory
;@ Moves `vram` to the next tile of an instrument slot: + InstrumentTileOffsets[step].
;@ test: step = rand(0, 2)
NextInstrumentTile::
;>@r return (vram + mem[InstrumentTileOffsets + step]) & 0xFFFF
	push hl
	ld hl, InstrumentTileOffsets
	add hl, bc
	ld a, [hl]
	pop hl
	add l
;=@r
	ld l, a
	ld a, h
	adc $00
	ld h, a
	ret


;@ def CopyInstrumentTilesStage(stage: a)
;@ path: menu/inventory
;@ Stage 0-7 of the instrument tile job: copies 64 bytes (4 tiles) from bank $0C $4D00 + 64 * stage to
;@ $8D00 + 64 * stage, then counts the stage.
;@ test: skip switches ROM banks
CopyInstrumentTilesStage::
;>@o offset = stage * 64
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
;>@c CopyTilesFromBank0C(WorldTiles8C00 + 0x100 + offset, 0x8D00 + offset)
	ld hl, $8d00
	add hl, bc
	push hl
	pop de
	ld hl, WorldTiles8C00 + $100
	add hl, bc
;=@c
	call CopyTilesFromBank0C
;> hBGTilesLoadingStage += 1
	ldh a, [hBGTilesLoadingStage]
	inc a
	ldh [hBGTilesLoadingStage], a
	ret


;@ path: world/rooms
;@ The border of the room object area (41 bytes: 40 indexes into wRoomObjectsArea, $FF ends): row 0
;@ columns 0-$0B, columns 0 and $0B of rows 1-8, and row 9 columns 0-$0B.
RoomBorderObjects::
	db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $10, $1b, $20, $2b
	db $30, $3b, $40, $4b, $50, $5b, $60, $6b, $70, $7b, $80, $8b, $90, $91, $92, $93
	db $94, $95, $96, $97, $98, $99, $9a, $9b, $ff

;@ def FillRoomObjectsBorder()
;@ path: world/rooms
;@ Sets the border around the room's objects in wRoomObjectsArea to $FF (RoomBorderObjects), the end of
;@ tile set request 1 (drawing a room).
;@ test: wCurrentBank = $01
FillRoomObjectsBorder::
;>@l for index in mem[RoomBorderObjects:RoomBorderObjects + mem[RoomBorderObjects:RoomBorderObjects + 0x100].index(0xFF)]:   # the list, up to its $FF
	ld bc, RoomBorderObjects
.loop
	ld a, [bc]
	cp $ff
	jr z, .done
;>     wRoomObjectsArea[index] = 0xFF
	ld e, a
	ld d, $00
	ld hl, wRoomObjectsArea
	add hl, de
	ld [hl], $ff
;=@l
	inc bc
	jr .loop
.done
	ret


;@ def FillBGCheckerboard()
;@ path: gfx/bg
;@ Fills the first 20 columns of BG map 0 ($9800-$9BFF) with a checkerboard of the tiles $AE and $AF;
;@ the columns 20-31 are left alone.
;@ test: skip writes VRAM
FillBGCheckerboard::
;>@l for vram in range(0x9800, 0x9C00):
	ld bc, $0400
	ld hl, $9800
.loop
;>@t     tile = 0xAE + ((vram & 1) ^ ((vram >> 5) & 1))
	ld e, $00
	ld a, l
	and $20
	jr z, .even
	inc e
.even
	ld d, $ae
;=@t
	ld a, l
	and $01
	xor e
	jr z, .write
	inc d
.write
;>     if vram & 0x1F < 0x14:
	ld a, l
	and $1f
	cp $14
	jr nc, .next
;>         mem[vram] = tile
	ld [hl], d
.next
;=@l
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret


;@ def CopyDMARoutine()
;@ path: system/oam
;@ Copies the OAM DMA routine (DMARoutine, 10 bytes) to HRAM at $FFC0, from where the VBlank handler runs
;@ it (during an OAM DMA the CPU can only run code in HRAM).
;@ test: skip writes HRAM code
CopyDMARoutine::
;>@l for i in range(10):
	ld c, $c0
	ld b, $0a
	ld hl, DMARoutine
.loop
;>     mem[0xFFC0 + i] = mem[DMARoutine + i]
	ld a, [hli]
	ldh [c], a
	inc c
;=@l
	dec b
	jr nz, .loop
	ret


;@ def DMARoutine()
;@ path: system/oam
;@ The OAM DMA routine, run from its copy at $FFC0 (CopyDMARoutine): starts the copy of the OAM buffer
;@ ($C000) to OAM and waits until it is done ($28 loops = 160 cycles). Never run from here.
;@ test: skip runs from HRAM
DMARoutine::
;> rDMA = 0xC0
	ld a, $c0
	ldh [rDMA], a
;> for i in range(0x28): pass   # wait for the DMA
	ld a, $28
.wait
	dec a
	jr nz, .wait
	ret

;@ path: title/storm
;@ The 8 sprite tiles of the rain in the storm (2bpp, 128 bytes): thin diagonal streaks of different
;@ lengths. Tile set request $10 copies them to $8700 (tiles $70-$77, see DrawIntroRain).
IntroRainTiles::
	db $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $40, $40, $20, $20, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $80, $80, $40, $40, $20, $20, $10, $10, $08, $08, $04, $04, $02, $02, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;@ path: menu/worldmap
;@ For each dungeon (indoor maps 0-7): an address in BG map 1 (8 dw), used by DisabledDungeonMarker.
DungeonMarkerAddresses::
	dw $9e2d, $9e2c, $9e2b, $9e2d, $9e31, $9e2d, $9e2b, $9e2d

;@ def DisabledDungeonMarker()
;@ path: menu/worldmap
;@ Runs at the end of tile set request 1 (drawing a room), but is switched off: it returns at once
;@ because the ROM byte at $0004 is not 0. Otherwise, inside a dungeon (indoor maps 0-7), it would put
;@ tile $A3 ($7F in a side-scrolling room) at that dungeon's DungeonMarkerAddresses entry in BG map 1.
;@ test: skip reads the ROM
DisabledDungeonMarker::
;> if mem[0x0004]:
	ld a, [$0004]
	and a
;>     return
	ret nz
;> if wIsIndoor and hMapId < 8:
	ld a, [wIsIndoor]
	and a
	jr z, .done
	ldh a, [hMapId]
	cp $08
	jr nc, .done
;>@a     vram = mem16[DungeonMarkerAddresses + 2 * hMapId]
	sla a
	ld e, a
	ld d, $00
	ld hl, DungeonMarkerAddresses
	add hl, de
	ld a, [hli]
;=@a
	ld h, [hl]
	ld l, a
;>     mem[vram] = 0xA3
	ld [hl], $a3
;>     if hIsSideScrolling:
	ldh a, [hIsSideScrolling]
	and a
	jr z, .done
;>         mem[vram] = 0x7F
	ld [hl], $7f
.done
	ret


;@ path: menu/worldmap
;@ The world map screen: one BG tile per overworld room, 16 rows of 16 (256 bytes, by room number). Rooms
;@ not visited yet show tile $2C instead (DrawWorldMapRooms).
WorldMapTilemap::
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

;@ def DrawWorldMapRooms()
;@ path: menu/worldmap
;@ Tile set request $0E: writes the 256 rooms of the world map screen into BG map 0 from $9822, 16 tiles
;@ per row: a room's tile from WorldMapTilemap once it has been visited (wRoomStatus bit 7) - or always
;@ when a library book opened the map or in the ending (wGameplayType 1) - and tile $2C otherwise.
;@ test: skip writes VRAM
DrawWorldMapRooms::
;> vram = 0x9822
	ld de, $9822
	ld bc, $0000
;>@l for room in range(256):
.loop
;>@s     tile = mem[WorldMapTilemap + room] if wMapScreenFromBook or wGameplayType == 1 or wRoomStatus[room] & 0x80 else 0x2C
	ld a, [wMapScreenFromBook]
	and a
	jr nz, .shown
	ld a, [wGameplayType]
	cp $01
	jr z, .shown
;=@s
	ld hl, wRoomStatus
	add hl, bc
	ld a, [hl]
	and $80
	ld a, $2c
	jr z, .store
.shown
;=@s
	ld hl, WorldMapTilemap
	add hl, bc
	ld a, [hl]
.store
;>     mem[vram] = tile
	ld [de], a
;>     if room == 255:
	inc c
	jr z, .done
;>         break
;>@v     vram = vram + 1 if (vram + 1) & 0x1F != 0x12 else ((vram + 1) & 0xFFE0) + 0x22
	inc e
	ld a, e
	and $1f
	cp $12
	jr nz, .next
	ld a, e
;=@v
	and $e0
	add $22
	ld e, a
	ld a, d
	adc $00
	ld d, a
.next
;=@l
	jr .loop
.done
	ret


;@ path: unused
;@ Four tiles (2bpp, 64 bytes) that nothing reads.
UnusedTiles7F24::
	db $0f, $00, $1f, $00, $3f, $00, $3f, $11, $3f, $1f, $3f, $1f, $3f, $19, $3f, $11
	db $3f, $03, $ff, $1f, $ff, $40, $ff, $4a, $ff, $51, $ff, $5f, $fe, $5f, $7e, $1f
	db $3e, $1f, $3c, $1f, $3f, $1f, $3f, $1f, $3f, $1f, $3f, $1f, $3a, $1d, $39, $17
	db $33, $1f, $3b, $16, $39, $1f, $1c, $0b, $0f, $05, $07, $03, $03, $00, $00, $00
;@ path: gfx/tilesets
;@ Indoor tile pages, one byte per indoor map ($00-$1F, 32 bytes): the high byte of the $100-byte page in
;@ bank $0D that LoadTileset06 copies to $9100 (0 for maps that have none).
IndoorTilePages9100::
	db $4c, $62, $63, $66, $6b, $63, $65, $64, $60, $4c, $4d, $4c, $4c, $4c, $4e, $4e
	db $4e, $4d, $4d, $4f, $61, $63, $63, $00, $00, $00, $00, $00, $00, $4e, $4e, $4d
;@ path: gfx/tilesets
;@ Indoor tile pages, one byte per indoor map (32 bytes): the high byte of the $200-byte block in bank
;@ $0D that LoadTileset06 copies to $9200.
IndoorTilePages9200::
	db $40, $40, $6c, $40, $40, $6c, $40, $6e, $4a, $40, $46, $40, $40, $40, $48, $48
	db $48, $46, $48, $4a, $40, $46, $6c, $00, $00, $00, $00, $00, $00, $48, $48, $46
;@ path: gfx/tilesets
;@ Indoor tile pages, one byte per indoor map (32 bytes): the high byte of the $100-byte page in bank
;@ $12 that LoadTileset06 copies to $8F00.
IndoorTilePages8F00::
	db $79, $79, $77, $79, $79, $77, $78, $79, $79, $63, $7a, $00, $00, $00, $7b, $7b
	db $7b, $7a, $7b, $79, $7c, $7a, $77, $00, $00, $00, $00, $00, $00, $7c, $7b, $7a
;@ path: unused
;@ Free space at the end of bank 1 (60 bytes of $FF).
Bank01FreeSpace::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
