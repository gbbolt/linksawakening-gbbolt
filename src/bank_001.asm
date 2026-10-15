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
;> hWindowYUnused = 3
	ld a, $03
	ldh [$ffa9], a
;> hWindowXUnused = 0x30
	ld a, $30
	ldh [$ffaa], a
;> IncrementGameplaySubtype()                    # next step
	call IncrementGameplaySubtype
;> wScrollXOffset = 0
	xor a
	ld [wScrollXOffset], a
;> wInventoryAppearing = 0
	ld [wInventoryAppearing], a
;> mem[0xC1B8] = 0
	ld [wSongMenuOpenTimer], a
;> mem[0xC1B9] = 0
	ld [wSongMenuCloseTimer], a
;> mem[0xC1B5] = 0
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
	jr z, SaveMenuQuitToTitle.done
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
;>     mem[0xC50A] = 0
	xor a
	ld [$c50a], a
;>     mem[0xC116] = 0
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
;> hWindowYUnused = 7
	ld a, $07
	ldh [$ffa9], a
;> hWindowXUnused = 0x70
	ld a, $70
	ldh [$ffaa], a
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
;>@y wOAMBuffer[24] = SaveMenuCursorY[wMenuCursor]     # OAM entry 6: y
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
;>@f     hLinkAnimationState = GameOverSpinLinkFrames[hLinkCountdown >> 3]
;>@v     mem[0xC3CD] = GameOverSpinValues[hLinkCountdown >> 3]
;>@c     mem[0xC3CB] = 1
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
;> mem[0xD415] = 0
	ld [wKillCounter], a
;> mem[0xD47C] = 0
	ld [$d47c], a
;> mem[0xD47A] = 0
	ld [$d47a], a
;> fill(0xC3CB, 0, 3)
	ld [$c3cb], a
	ld [$c3cc], a
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
	ld [$c3cb], a
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
;> mem[0xD6FB] = 0
	ld [$d6fb], a
;> mem[0xD475] = 0
	ld [$d475], a
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
;>@y wOAMBuffer[24] = GameOverCursorY[wMenuCursor]
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
;@ 6 switch the window on and start the fade in, 7 play (the main play routine at $0B53 in bank 0).
WorldSteps::
	dw WorldLoadPickLayout
	dw WorldLoadPlaceLink
	dw WorldLoadRoomTiles
	dw WorldLoadTileset
	dw WorldLoadDrawRoom
	dw WorldLoadDrawRoom2
	dw WorldLoadStartFadeIn
	dw $0b53

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
;>@o2     mem[0xFFB9] = (GetRandomByte() | hFrameCounter) & 3      # a random number 0-3
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
;>@lay wMinimapLayout = MapMinimapLayouts[hMapId]
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
;> mem[0xFFA6] = 0xFF
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
;@ Step 4: first part of drawing the room (Call_3E6F).
;@ test: skip draws the room through bank 0
WorldLoadDrawRoom::
;> Call_3E6F()
	call Call_3E6F
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldLoadDrawRoom2()
;@ path: world/load
;@ Step 5: second part of drawing the room (Call_3E8A).
;@ test: skip draws the room through bank 0
WorldLoadDrawRoom2::
;> Call_3E8A()
	call Call_3E8A
;> IncrementGameplaySubtype()
	call IncrementGameplaySubtype
	ret


;@ def WorldLoadStartFadeIn()
;@ path: world/load
;@ Step 6: puts the window (the status bar) back and switches it on, keeps Link's motion state in
;@ mem[0xD463] while motion state 4 holds him during the fade in, and starts the fade (skipped, with
;@ fixed palettes, when $C3CB is set). Ends in bank 2's room start code (SelectAreaMusicFar).
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
;> mem[0xD463] = wLinkMotionState
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
;> if mem[0xC3CB]:
	ld a, [$c3cb]
	and a
	jr z, .done
;>     wBGPalette = mem[0xC5AD]
	ld a, [$c5ad]
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
;>     mem[0xA405 + i] = DebugSaveData[i]     # over $DB00-$DB42
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
;> wEntityWorkRAM = 0                   # bottom-row choice
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
;>         wEntityWorkRAM ^= 1
	ld a, [wEntityWorkRAM]
	xor $01
	ld [wEntityWorkRAM], a
.blink
;>     if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr nz, DrawFileSelectCursor
;>         x = 0x64 if wEntityWorkRAM else 0x2C
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
;>@y y = FileSelectCursorY[wSaveSlot]
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
;>@t wGameplayType = 5 if wEntityWorkRAM else 4
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
;>@nm name = wSaveSlotNames + FileSlotNameOffsets[wSaveSlot]
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
;>@st state = SaveSlotStateAddresses[wSaveSlot]   # the slot's copy of $DB00
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
;>@x x = NameEntryCursorX[wNameEntryCursor]
	ld a, [wNameEntryCursor]
	ld hl, NameEntryCursorX
	ld c, a
	ld b, $00
	add hl, bc
	ld e, [hl]
;>@y y = NameEntryCursorY[wNameEntryCursor]
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
;>@x x = NameEntryNameCursorX[wNameEntryPosition]
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
NameEntryWriteLetter::
;>@c char = NameEntryCharacters[wNameEntryCursor]
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
;> wEntityWorkRAM = 0                    # 0 QUIT, 1 OK
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
;> if wEntityWorkRAM == 0:               # QUIT
	ld a, [wEntityWorkRAM]
	and a
;>     return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;> PlayConfirmSound()
	call PlayConfirmSound
;>@d data = SaveSlotDataAddresses[wSaveSlot]
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
;>     wEntityWorkRAM ^= 1
	ld a, [wEntityWorkRAM]
	xor $01
	ld [wEntityWorkRAM], a
.draw
;> if not hFrameCounter & 0x10:
	ldh a, [hFrameCounter]
	and $10
	jr nz, .done
;>@x     x = 0x6C if wEntityWorkRAM == 1 else 0x28
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
;>@h mem[cmd + 3] = DigitTiles[lo(count) & 0x0F]   # hundreds
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
;>@t mem[cmd + 4] = DigitTiles[hi(count) >> 4]     # tens
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
;>@o mem[cmd + 5] = DigitTiles[hi(count) & 0x0F]   # ones
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
;> wEntityWorkRAM = 0                    # QUIT / OK
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
;>@d return DrawFileCursorPair(FileSelectCursorY[wSceneVar1], wOAMBuffer)    # mirrored when hFrameCounter & 8 == 0
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

;@ def DrawFileCursorPair(y: a, oam: hl)
;@ path: menu/copy
;@ Draws the fairy cursor (two sprites at x $10 and $18) at height `y` into two OAM entries at `oam`;
;@ the caller's zero flag (hFrameCounter & 8 == 0) selects the mirrored picture.
;@ test: skip depends on the caller's flags
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
;>@y y = FileSelectCursorY[wSceneVar1]
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
;>@y y = FileSelectCursorY[wSceneVar2]
	ld a, [wSceneVar2]
	ld e, a
	ld d, $00
	ld hl, FileSelectCursorY
	add hl, de
;> if wSceneVar2 == 3:
	ld a, [wSceneVar2]
	cp $03
;>@r     return DrawFileCursorPair(y, wOAMBuffer + 8)
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
;>@y y = FileSelectCursorY[wSceneVar2]
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
;>     if wEntityWorkRAM == 0:           # QUIT
	ld a, [wEntityWorkRAM]
	and a
;>         return ReturnToFileSelect()
	jp z, ReturnToFileSelect
;>     PlayConfirmSound()
	call PlayConfirmSound
;>@s     src = SaveSlotAddresses[wSceneVar1]
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
;>@d     dest = SaveSlotAddresses[wSceneVar2]
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
;>     wEntityWorkRAM = 0
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
;>@h     wHealth = DefaultHealthByMaxHearts[wMaxHearts]
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
;>@s     src = SaveSlotDataAddresses[wSaveSlot]
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
	ld de, $d650
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
;>@z fill(hMultiPurpose0, 0, 4)         # hMultiPurpose0-3
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
;>@g     hMultiPurpose0 = MinimapFrameHigh[i]
	ld hl, MinimapFrameHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>     hMultiPurpose1 = MinimapFrameLow[i]
	ld hl, MinimapFrameLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;>     hMultiPurpose2 = MinimapFrameMode[i]
	ld hl, MinimapFrameMode
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;>     hMultiPurpose3 = MinimapFrameTile[i]
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
;>     if MinimapFrameHigh[i] == 0xFF:
	cp $ff
;=@f
	jr nz, .frameLoop
;>         break
;> mem[out] = 0
	xor a
	ld [hl], a
;>@z2 fill(hMultiPurpose0, 0, 4)
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
;>         hMultiPurpose0 = MinimapFloorHigh[i]
	ld hl, MinimapFloorHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;>         hMultiPurpose1 = MinimapFloorLow[i]
	ld hl, MinimapFloorLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;>         hMultiPurpose2 = 0             # one tile
	xor a
	ldh [hMultiPurpose2], a
;>         hMultiPurpose3 = MinimapFloorTile[i]
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
;>         if MinimapFloorHigh[i] == 0xFF:
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
;>@lv hMultiPurpose0 = MinimapLevelHigh[j]
	push hl
	ld hl, MinimapLevelHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = MinimapLevelLow[j]
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
;>@p place = WorldMapRoomPlaces[wOverworldRoom]
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
;>@p     place = WorldMapRoomPlaces[wWorldMapCursor]
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
;>@n         text = WorldMapPlaceTexts[place]
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
;>@a         text = WorldMapRegionTexts[(wWorldMapCursor >> 5) * 8 + ((wWorldMapCursor & 0x0F) >> 1)]
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
;@ Shared last step of the beach and picture scenes: keeps their sprites drawn (the routine at $6750)
;@ and falls into ReturnToWorld.
;@ test: skip calls scene code
SceneReturnToWorld::
;> Call_6750()                           # (the scene sprites)
	call $6750
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
;> mem[0xC50A] = 0
	xor a
	ld [$c50a], a
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
;>@f fill(wRoomTransitionState, 0, 12)
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
;> mem[0xC150] = 8
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
;>@p return OpenDialog(WorldMapPlaceTexts[WorldMapRoomPlaces[hMapRoom]])
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
;>@x     wWorldMapCursor = wWorldMapCursor & 0xF0 | (wWorldMapCursor + WorldMapCursorDX[keys & 3]) & 0x0F
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
;>@y     wWorldMapCursor = u8(wWorldMapCursor + WorldMapCursorDY[(keys >> 2) & 3])
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
;>@p             place = WorldMapRoomPlaces[wWorldMapCursor]
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
;@ asset: sprites frames=4 count=8
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
;> hActiveEntityX = WorldMapPopupX[quarter]
	ld d, $00
	ld hl, WorldMapPopupX
	add hl, de
	ld a, [hl]
	ldh [hActiveEntityX], a
;> hActiveEntityDrawY = WorldMapPopupY[quarter]
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
;> mem[0xFFF5] = 0
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
;>@i1 wOAMBuffer[48:52] = [hActiveEntityDrawY, hActiveEntityX] + WorldMapMarkerIcons[4 * hActiveEntitySpriteVariant:][:2]
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
;>@i2 wOAMBuffer[52:56] = [hActiveEntityDrawY, hActiveEntityX + 8] + WorldMapMarkerIcons[4 * hActiveEntitySpriteVariant + 2:][:2]
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
;>@h     wHealth = DefaultHealthByMaxHearts[wMaxHearts]
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
;>@d dest = SaveSlotDataAddresses[wSaveSlot]
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
;>@d     copy(wDungeonItemFlags + hMapId * 5, wDungeonHasMap, 5)
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
;@ test: skip 16-bit position arithmetic through the carry
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
;> hMultiPurpose0 = ScrollShiftXLow[dir]
	ld hl, ScrollShiftXLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose0], a
;> hMultiPurpose1 = ScrollShiftXHigh[dir]
	ld hl, ScrollShiftXHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose1], a
;> hMultiPurpose2 = ScrollShiftYLow[dir]
	ld hl, ScrollShiftYLow
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose2], a
;> hMultiPurpose3 = ScrollShiftYHigh[dir]
	ld hl, ScrollShiftYHigh
	add hl, bc
	ld a, [hl]
	ldh [hMultiPurpose3], a
;>@x x = (wEntityPosXHigh[slot] << 8 | wEntityX[slot]) + (hMultiPurpose1 << 8 | hMultiPurpose0)
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
;>@y y = (wEntityPosYHigh[slot] << 8 | wEntityY[slot]) + (hMultiPurpose3 << 8 | hMultiPurpose2)
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
;>         if wOAMBuffer[4 * i] >= wWindowY + 8:
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
;>     slot = SpawnEntity(0xD5)
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
;>@g4     slot = SpawnEntity(0xD4)
;>@g5     wEntityX[slot] = hLinkX
;>@g6     wEntityY[slot] = hLinkY + wLinkSpriteDY
;>@g7     wEntityPrivate1[slot] += 1
;>@g8     hJingle = 0x2D
	ld a, [wIsGhostFollowingLink]
	cp $01
	jr z, .spawnGhost
;>@e elif wIsGhostFollowingLink == 2 and not wIsIndoor and hMapRoom >= 0x40 and mem[0xDB68] & 2:
	cp $02
	jr nz, SpawnMarinFollower
	ld a, [wIsIndoor]
	and a
	jr nz, SpawnMarinFollower
;=@e
	ldh a, [hMapRoom]
	cp $40
	jr c, SpawnMarinFollower
	ld a, [$db68]
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
;> slot = SpawnEntity(0xC1)
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
;@ test: hl = 0xD155; a = rand(0, 255)
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
;>     slot = SpawnEntity(0x6D)
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
	dw $5700, $5710, $5720, $5730, $5740, $5750, $5760, $5770
	dw $5780, $5790, $5800, $5810, $5820, $5830, $5840, $5850

;@ def DrawDebugDialogIndex()
;@ path: text/debug
;@ Animated-tiles routine of the text debugger room: shows wDebugDialogIndex as two hex digits by
;@ copying the digits' tiles from bank $0F into background tiles $6C and $6D ($96C0 / $96D0) and
;@ putting those tiles at $9909-$990A.
;@ test: skip copies from another bank into VRAM
DrawDebugDialogIndex::
;>@l copy_from_bank(0x0F, 0x96D0, HexDigitTileAddresses[wDebugDialogIndex & 0x0F], 0x10)   # low digit
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
;>@h copy_from_bank(0x0F, 0x96C0, HexDigitTileAddresses[wDebugDialogIndex >> 4], 0x10)     # high digit
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


ShowDungeonNameText::
	ld a, [wLinkMotionState]
	cp $00
	jr nz, jr_001_5fba

	ld a, [wDebugToggle]
	and a
	jr nz, jr_001_5fba

	ldh a, [hMapId]
	add $56
	call OpenDialog

jr_001_5fba:
	ret


GameplayMarinBeachHandler::
	db $fa, $9f, $c1, $a7, $20, $0a, $fa, $c7, $c3, $a7, $28, $04, $3d, $ea, $c7, $c3
	db $fa, $c4, $c3, $a7, $28, $04, $3d, $ea, $c4, $c3, $fa, $96, $db, $c7

MarinBeachSteps::
	db $f5, $5f
	db $17, $60, $23, $60, $5a, $61, $8d, $61, $a8, $61, $c6, $61, $dd, $61, $ef, $61
	db $06, $62, $18, $62, $46, $62, $5d, $62, $fd, $55

MarinBeachFadeOut::
	db $3e, $01, $ea, $67, $c1, $cd
	db $76, $17, $fa, $6b, $c1, $fe, $04, $20, $12, $cd, $45, $44, $af, $ea, $bf, $c1
	db $cd, $36, $56, $cd, $75, $62, $3e, $0f, $ea, $fe, $d6, $c9

MarinBeachLoadTiles::
	db $3e, $13, $ea, $fe
	db $d6, $af, $ea, $3f, $c1, $c3, $45, $44

MarinBeachInit::
	db $3e, $13, $ea, $ff, $d6, $3e, $ff, $ea
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
	db $56, $c5, $3e, $00, $ea, $26, $c5, $3e, $00, $ea, $06, $d2, $c3, $45, $44

MarinBeachBGPalettes::
	db $00
	db $00, $00, $00, $40, $40, $40, $40, $94, $94, $94, $94, $e4, $e4, $e4, $e4

MarinBeachOBJ0Palettes::
	db $00
	db $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c

MarinBeachFadeIn::
	db $f0
	db $e7, $e6, $07, $20, $0e, $fa, $c5, $c3, $3c, $ea, $c5, $c3, $fe, $0c, $20, $03
	db $cd, $45, $44, $f0, $e7, $e6, $03, $5f, $fa, $c5, $c3, $83, $5f, $16, $00, $21
	db $3a, $61, $19, $7e, $ea, $97, $db, $ea, $99, $db, $21, $4a, $61, $19, $7e, $ea
	db $98, $db

MarinBeachScrollDown::
	db $f0, $e7, $e6, $03, $20, $11, $f0, $97, $3c, $e0, $97, $fe, $00, $20
	db $08, $3e, $80, $ea, $c7, $c3, $cd, $45, $44, $cd, $8c, $62, $c9

MarinBeachTalk1::
	db $cd, $8c, $62
	db $fa, $9f, $c1, $a7, $20, $0f, $fa, $c7, $c3, $a7, $20, $08, $3e, $d8, $cd, $3c
	db $65, $cd, $45, $44, $c9, $3e, $02, $ea, $c4, $c3, $c9

MarinBeachPause1::
	db $cd, $8c, $62, $fa, $9f
	db $c1, $a7, $20, $0d, $3e, $80, $ea, $c4, $c3, $3e, $c0, $ea, $c7, $c3, $cd, $45
	db $44, $c9

MarinBeachTalk2::
	db $cd, $8c, $62, $fa, $c7, $c3, $a7, $20, $08, $3e, $d9, $cd, $3c, $65
	db $c3, $45, $44, $c9

MarinBeachPause2::
	db $cd, $8c, $62, $fa, $9f, $c1, $a7, $20, $0d, $3e, $80, $ea
	db $c4, $c3, $3e, $c0, $ea, $c7, $c3, $cd, $45, $44, $c9

MarinBeachTalk3::
	db $cd, $8c, $62, $fa, $c7
	db $c3, $a7, $20, $08, $3e, $da, $cd, $3c, $65, $c3, $45, $44, $c9

MarinBeachCheckAnswer::
	db $cd, $8c, $62
	db $fa, $9f, $c1, $a7, $20, $1f, $fa, $77, $c1, $a7, $20, $09, $3e, $db, $cd, $3c
	db $65, $cd, $45, $44, $c9, $3e, $de, $cd, $3c, $65, $3e, $05, $ea, $96, $db, $3e
	db $05, $ea, $c7, $c3, $c9, $3e, $02, $ea, $c4, $c3, $c9

MarinBeachTalk4::
	db $cd, $8c, $62, $fa, $9f
	db $c1, $a7, $20, $0d, $3e, $dc, $cd, $3c, $65, $3e, $30, $ea, $c7, $c3, $cd, $45
	db $44, $c9

MarinBeachEnd::
	db $cd, $8c, $62, $3e, $02, $ea, $c4, $c3, $fa, $c7, $c3, $a7, $c0, $cd
	db $d2, $27, $cd, $0f, $66, $3e, $01, $ea, $73, $db

ClearSceneObjects::
	db $1e, $10, $21, $10, $c5, $af
	db $22, $1d, $20, $fc, $c9

MarinBeachSprites::
	db $40, $00, $40, $20, $46, $00, $48, $00, $42, $00, $44
	db $00

UpdateMarinBeach::
	db $cd, $0c, $63, $fa, $14, $c1, $3c, $fe, $a0, $20, $05, $3e, $0f, $e0, $f4
	db $af, $ea, $14, $c1, $fa, $66, $d4, $a7, $20, $0e, $3e, $21, $e0, $f2, $cd, $ed
	db $27, $e6, $7f, $c6, $60, $ea, $66, $d4, $3d, $ea, $66, $d4, $f0, $97, $3d, $fe
	db $c0, $d8, $11, $80, $62, $fa, $c4, $c3, $a7, $28, $07, $fe, $60, $30, $03, $11
	db $84, $62, $3e, $7c, $e0, $ec, $3e, $58, $e0, $ee, $21, $30, $c0, $cd, $e9, $62
	db $3e, $48, $e0, $ee, $11, $88, $62, $21, $38, $c0, $cd, $e9, $62, $c9

DrawSceneSpritePair::
	db $c5, $f0
	db $97, $4f, $f0, $ec, $91, $e0, $e8, $22, $f0, $ee, $22, $1a, $13, $22, $1a, $13
	db $22, $f0, $ec, $91, $22, $f0, $ee, $c6, $08, $22, $1a, $13, $22, $1a, $77, $c1
	db $c9

UpdateSceneObjects::
	db $0e, $08, $06, $00, $21, $10, $c5, $09, $7e, $a7, $28, $1c, $f5, $21, $30
	db $c5, $09, $7e, $e0, $ee, $21, $40, $c5, $09, $7e, $e0, $ec, $21, $20, $c5, $09
	db $7e, $a7, $28, $01, $35, $f1, $cd, $3b, $63, $0d, $79, $fe, $ff, $20, $d6, $c9
UpdateSceneObject::
	db $3d, $c7

SceneObjectHandlers::
	db $d1, $63, $5b, $64

BeachSeagullFramePointers::
	db $4d, $63, $51, $63, $55, $63, $59, $63, $5d, $63
	db $61, $63

BeachSeagullFrames::
	db $50, $00, $50, $20, $52, $00, $52, $20, $54, $00, $54, $20, $56, $00
	db $56, $20, $58, $00, $58, $20, $5a, $00, $5a, $20

BeachSeagullFrameSequence::
	db $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $03, $03, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $04, $05, $00, $01, $02, $03
	db $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01
	db $02, $03, $04, $05, $00, $01, $02, $03, $04, $05, $00, $01, $02, $03, $04, $05
	db $00, $01, $02, $03, $04, $05

UpdateSeagull::
	db $21, $20, $c5, $09, $7e, $a7, $c0, $21, $10, $d2
	db $09, $7e, $3c, $77, $fe, $06, $38, $06, $70, $21, $00, $d2, $09, $34, $21, $00
	db $d2, $09, $5e, $50, $21, $65, $63, $19, $5e, $cb, $23, $50, $21, $41, $63, $19
	db $2a, $56, $5f, $d5, $21, $40, $c0, $79, $17, $17, $17, $e6, $78, $5f, $50, $19
	db $d1, $cd, $e9, $62, $cd, $06, $65, $f0, $e7, $e6, $07, $20, $0a, $21, $60, $c5
	db $09, $7e, $fe, $fb, $28, $01, $35, $f0, $e8, $fe, $f0, $38, $0d, $21, $60, $c5
	db $09, $7e, $e6, $80, $c8, $21, $10, $c5, $09, $70, $c9

SeaBirdFramePointers::
	db $3e, $64, $42, $64, $46
	db $64, $4a, $64

SeaBirdFrames::
	db $4c, $00, $4c, $20, $4e, $00, $4e, $20, $5c, $00, $5c, $20, $5e
	db $00, $5e, $20

SeaBirdRandomSpeeds::
	db $01, $ff, $01, $ff, $fe, $02, $01, $ff

SeaBirdHomeX::
	db $4c, $52, $58, $5c, $60
UpdateSeaBird::
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
	db $01, $e6, $80, $20, $02, $1e, $ff, $7e, $83, $77, $c9

MoveSceneObject::
	db $cd, $13, $65, $c5, $79
	db $c6, $10, $4f, $cd, $13, $65, $c1, $c9

MoveSceneObjectAxis::
	db $21, $50, $c5, $09, $7e, $f5, $cb, $37
	db $e6, $f0, $21, $70, $c5, $09, $86, $77, $cb, $12, $21, $30, $c5, $09, $f1, $1e
	db $00, $cb, $7f, $28, $02, $1e, $f0, $cb, $37, $e6, $0f, $b3, $cb, $1a, $8e, $77
	db $c9

OpenBeachDialog::
	db $5f, $f0, $99, $f5, $3e, $60, $e0, $99, $7b, $cd, $85, $21, $f1, $e0, $99
	db $c9

GameplayPictureHandler::
	db $fa, $96, $db, $c7

PictureSteps::
	db $64, $65, $91, $65, $ae, $65, $e0, $65, $f6, $65, $fd
	db $55, $1a, $66, $3e, $66, $7b, $66, $fa, $55

PictureFadeOut::
	db $3e, $01, $ea, $67, $c1, $cd, $76
	db $17, $fa, $6b, $c1, $fe, $04, $20, $1d, $cd, $36, $56, $f0, $f7, $fe, $06, $28
	db $08, $3e, $03, $e0, $a9, $3e, $30, $e0, $aa, $cd, $45, $44, $af, $ea, $bf, $c1
	db $3e, $0f, $ea, $fe, $d6, $c9

PictureLoadTiles::
	db $1e, $21, $f0, $f7, $fe, $06, $28, $0a, $f0, $f6
	db $fe, $dd, $1e, $12, $20, $02, $1e, $20, $7b, $ea, $fe, $d6, $af, $ea, $3f, $c1
	db $c3, $45, $44

PictureInit::
	db $1e, $24, $f0, $f7, $fe, $06, $28, $0a, $f0, $f6, $fe, $dd, $1e
	db $12, $20, $02, $1e, $23, $7b, $ea, $ff, $d6, $3e, $ff, $ea, $9a, $db, $af, $e0
	db $96, $e0, $97, $ea, $6b, $c1, $ea, $6c, $c1, $1e, $08, $21, $10, $d2, $22, $1d
	db $20, $fc, $c3, $45, $44

PictureFadeIn::
	db $cd, $50, $67, $cd, $c3, $17, $fa, $6b, $c1, $fe, $04
	db $20, $08, $cd, $45, $44, $3e, $80, $ea, $10, $d2, $c9

PictureWaitButton::
	db $f0, $f7, $fe, $06, $20
	db $09, $cd, $50, $67, $3e, $06, $ea, $96, $db, $c9, $f0, $cc, $e6, $b0, $28, $0e
	db $3e, $13, $e0, $f2, $cd, $45, $44, $af, $ea, $6b, $c1, $ea, $6c, $c1, $c9

TowerShake::
	db $cd
	db $50, $67, $fa, $10, $d2, $3d, $ea, $10, $d2, $20, $0b, $ea, $56, $c1, $3e, $20
	db $ea, $10, $d2, $c3, $45, $44, $1e, $00, $e6, $04, $28, $02, $1e, $fe, $7b, $ea
	db $56, $c1, $c9

TowerSink::
	db $cd, $50, $67, $cd, $91, $66, $fa, $10, $d2, $3d, $ea, $10, $d2
	db $20, $2d, $cd, $d7, $08, $3e, $30, $ea, $10, $d2, $3e, $30, $ea, $14, $d2, $3e
	db $18, $ea, $15, $d2, $fa, $11, $d2, $c6, $08, $ea, $11, $d2, $fa, $13, $d2, $3c
	db $ea, $13, $d2, $fe, $04, $20, $08, $3e, $80, $ea, $10, $d2, $cd, $45, $44, $c9
TowerSettle::
	db $cd, $50, $67, $cd, $91, $66, $21, $10, $d2, $35, $c0, $cd, $45, $44, $af, $ea
	db $6b, $c1, $ea, $6c, $c1, $c9

UpdateTowerDust::
	db $af, $ea, $56, $c1, $fa, $15, $d2, $a7, $28, $10
	db $3d, $ea, $15, $d2, $1e, $fe, $e6, $04, $28, $02, $1e, $00, $7b, $ea, $56, $c1
	db $c9

TowerSpriteCounts::
	db $14, $14, $10, $10, $0c, $0c

TowerSprites::
	db $00, $00, $cc, $10, $00, $08, $ce, $10, $00
	db $10, $dc, $10, $00, $18, $cc, $30, $10, $00, $de, $10, $10, $08, $e0, $10, $10
	db $10, $e2, $10, $10, $18, $de, $30, $20, $00, $e4, $10, $20, $08, $e6, $10, $20
	db $10, $e8, $10, $20, $18, $e4, $30, $30, $00, $de, $10, $30, $08, $e0, $10, $30
	db $10, $e0, $30, $30, $18, $de, $30, $40, $00, $de, $10, $40, $08, $e0, $10, $40
	db $10, $e0, $30, $40, $18, $de, $30

TowerDustSprites::
	db $48, $08, $f0, $00, $48, $10, $f2, $00, $48
	db $18, $f4, $00, $48, $20, $f4, $20, $48, $28, $f2, $20, $48, $30, $f0, $20, $48
	db $08, $f6, $00, $48, $10, $f8, $00, $48, $18, $fa, $00, $48, $20, $fa, $20, $48
	db $28, $f8, $20, $48, $30, $f6, $20, $48, $08, $fc, $00, $48, $10, $fe, $00, $48
	db $18, $ee, $00, $48, $20, $ee, $20, $48, $28, $fe, $20, $48, $30, $fc, $20

TowerDustFrames::
	db $02
	db $67, $1a, $67, $32, $67

DrawTowerSprites::
	db $f0, $f7, $fe, $06, $c0, $af, $e0, $f1, $e0, $ed, $e0
	db $f5, $3e, $38, $e0, $ee, $fa, $56, $c1, $5f, $3e, $20, $93, $e0, $ec, $fa, $14
	db $d2, $a7, $28, $27, $3d, $ea, $14, $d2, $f0, $e7, $e6, $07, $fa, $12, $d2, $20
	db $06, $3c, $fe, $03, $20, $01, $af, $ea, $12, $d2, $17, $e6, $06, $5f, $50, $21
	db $4a, $67, $19, $2a, $66, $6f, $0e, $06, $cd, $20, $3d, $3e, $48, $e0, $ee, $fa
	db $56, $c1, $5f, $fa, $11, $d2, $c6, $20, $93, $e0, $ec, $fa, $13, $d2, $5f, $16
	db $00, $21, $ac, $66, $19, $4e, $af, $ea, $c0, $c3, $21, $b2, $66, $cd, $26, $3d
	db $c9

GameplayMuralHandler::
	db $fa, $96, $db, $c7

MuralSteps::
	db $cc, $67, $f3, $67, $0b, $68, $1d, $68, $36, $68, $fd
	db $55

MuralFadeOut::
	db $3e, $01, $ea, $67, $c1, $cd, $76, $17, $fa, $6b, $c1, $fe, $04, $20, $17
	db $cd, $36, $56, $3e, $03, $e0, $a9, $3e, $30, $e0, $aa, $cd, $45, $44, $af, $ea
	db $bf, $c1, $3e, $14, $ea, $fe, $d6, $c9

MuralLoadScreen::
	db $3e, $15, $ea, $ff, $d6, $3e, $ff, $ea
	db $9a, $db, $af, $e0, $96, $e0, $97, $ea, $6b, $c1, $ea, $6c, $c1, $c3, $45, $44
MuralFadeIn::
	db $cd, $c3, $17, $fa, $6b, $c1, $fe, $04, $20, $07, $cd, $45, $44, $af, $ea, $c4
	db $c3, $c9

MuralShowText::
	db $fa, $9f, $c1, $a7, $c0, $fa, $c4, $c3, $3c, $ea, $c4, $c3, $ca, $45
	db $44, $fe, $80, $20, $05, $3e, $e7, $cd, $97, $21, $c9

MuralWaitButton::
	db $f0, $cc, $e6, $b0, $28
	db $07, $3e, $13, $e0, $f2, $cd, $0f, $66, $c9

IntroWaveTables::
	db $00, $00, $00, $00, $00, $00, $00
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
	ld hl, wRasterLine
	xor a
	ld [hli], a
	ld [hli], a
	ld d, $00
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_001_6dd2

	ld a, [wRasterDelay]
	inc a
	cp $10
	jr c, jr_001_6dcf

	ld a, $10

jr_001_6dcf:
	ld [wRasterDelay], a

jr_001_6dd2:
	ld a, [wRasterDelay]
	ld e, a
	ld hl, $6da6
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose0], a
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

	ldh a, [hMultiPurpose0]
	ld l, a
	ld a, [wRasterLine]
	ld e, a
	inc a
	ld [wRasterLine], a
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
	ld hl, hBaseScrollY
	add [hl]
	ldh [rSCY], a
	jr jr_001_6dec

jr_001_6e23:
	ldh a, [hBaseScrollY]
	ldh [rSCY], a
	ld a, [wBGPalette]
	ldh [rBGP], a
	ret


PlayCursorSoundOnMove::
	ldh a, [hJoypadPressed]
	and $4c
	jr z, jr_001_6e39

PlayCursorSound::
	push af
	ld a, $0a
	ldh [hJingle], a
	pop af

jr_001_6e39:
	ret


IntroBGPalettes::
	db $c6, $c2, $c0, $c2

GameplayIntroHandler::
	ldh a, [hStartButtonDelay]
	and a
	jr z, jr_001_6e48

	dec a
	ldh [hStartButtonDelay], a
	jr jr_001_6ead

jr_001_6e48:
	ldh a, [hJoypadPressed]
	and $80
	jr z, jr_001_6ead

	call ResetSoundEngine
	ld a, [wGameplaySubtype]
	cp $0b
	jr z, jr_001_6e90

	ld a, $28
	ldh [hStartButtonDelay], a
	ld a, $11
	ld [wBGMapToLoad], a
	ld a, $0d
	ld [wGameplaySubtype], a
	xor a
	ld [wEntityStatus], a
	ld [$c281], a
	ld [$c282], a
	ld [$c283], a
	ld [$c284], a
	ldh [rBGP], a
	ld [wBGPalette], a
	ld a, $10
	ld [wRasterDelay], a
	call Call_01_727D
	ld a, $0d
	ld [wMusicTrackToPlay], a
	ld [wSceneVarF], a
	call Call_01_7B11
	jr jr_001_6ea4

jr_001_6e90:
	jp EnterFileSelectWithMusic


	db $af, $ea, $96, $db, $e0, $96, $e0, $97, $e0, $47, $ea, $97, $db, $21, $95, $db
	db $34

jr_001_6ea4:
	ld a, $01
	ldh [rIE], a
	ld a, $4f
	ldh [rLYC], a
	ret


jr_001_6ead:
	ld a, [wGameplaySubtype]
	cp $05
	jr nc, jr_001_6ecd

	ld a, [wEntityWorkRAM]
	and a
	jr z, jr_001_6ebe

	dec a
	ld [wEntityWorkRAM], a

jr_001_6ebe:
	rra
	nop
	and $03
	ld e, a
	ld d, $00
	ld hl, $6e3a
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a

jr_001_6ecd:
	ld a, [wGameplaySubtype]
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
	call ClearWRAM1600
	call ResetSoundEngine
	ld a, $1a
	call PlayMusic
	ld a, $02
	ld [wTileMapToLoad], a
	xor a
	ldh [hFrameCounter], a
	ld a, $a2
	ld [wRandomSeed], a
	ldh a, [rLCDC]
	and $df
	ld [wLCDControl], a
	ldh [rLCDC], a
	jp IncrementGameplaySubtype


Jump_01_6F11::
	ld a, $10
	ld [wTileMapToLoad], a
	jp IncrementGameplaySubtype


Jump_01_6F19::
	call Call_01_7AC4
	ld a, $0e
	ld [wBGMapToLoad], a
	ld a, $c6
	ld [wBGPalette], a
	ld a, $1c
	ld [wOBJ0Palette], a
	ld a, $e0
	ld [wOBJ1Palette], a
	ld a, $03
	ldh [rIE], a
	ld a, $00
	ldh [rLYC], a
	ld e, $11
	ld hl, wEntityWorkRAM
	xor a

jr_001_6f3e:
	ld [hli], a
	dec e
	jr nz, jr_001_6f3e

	ld [wEntityStatus], a
	ld [$c281], a
	ld [wEntitySpriteVariant], a
	ld [$c3b1], a
	ld [$c3b2], a
	ldh [hActiveEntityFlipAttribute], a
	ld a, $05
	ld [$c282], a
	ld a, $c0
	ld [$c202], a
	ld a, $4e
	ld [$c212], a
	xor a
	ld [wEntityPhysicsFlags], a
	ld [$c341], a
	ld [$c342], a
	ld [$c343], a
	jp IncrementGameplaySubtype


	db $81, $40, $00, $00, $00, $00, $00, $00, $00, $08, $08, $08, $04, $00, $00, $00
	db $00, $00

Jump_01_6F84::
	call Call_01_732B
	call Call_01_739B
	ld a, [wSceneVar2]
	and a
	jr z, jr_001_6ff0

	inc a
	ld [wSceneVar2], a
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
	ld [wBGPalette], a
	ld hl, $6f7b
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ld a, e
	cp $08
	jp nz, Jump_001_6fef

	xor a
	ld [wEntityStatus], a
	ld [$c281], a
	ld [$c282], a
	ld [wEntityState], a
	ld a, $05
	ld [wGameplaySubtype], a
	ld [wSceneVarF], a
	call Call_01_7B11
	ld a, $11
	ld [wTileMapToLoad], a
	ld a, $ff
	ld [wSceneVar1], a
	xor a
	ldh [hBaseScrollX], a
	ld [wIntroBandScrollX], a
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
	ld [wGameplaySubtype], a
	ld a, $0f
	ld [wBGMapToLoad], a
	ld a, $01
	ldh [rIE], a
	xor a
	ldh [hBaseScrollX], a
	ret


jr_001_7009:
	call Call_01_7AC4
	ldh a, [hFrameCounter]
	and $07
	jp nz, Jump_001_7089

	ld hl, hBaseScrollX
	inc [hl]
	ld hl, wEntityX
	dec [hl]
	inc hl
	dec [hl]
	inc hl
	dec [hl]
	ld c, $00
	ldh a, [hBaseScrollX]
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
	ld hl, wEntityStatus
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
	ld hl, wEntityStatus
	add hl, de
	ld [hl], a
	ld hl, $7053
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, wEntityY
	add hl, de
	ld [hl], $30
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $20

Call_01_7081::
	ld a, $1c
	ld [wEntityWorkRAM], a
	call PlayClinkNoise

Jump_001_7089:
jr_001_7089:
	ret


Jump_01_708A::
	call Call_01_732B
	ld a, [wSceneVar1]
	inc a
	ld [wSceneVar1], a
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
	ld [wGameplaySubtype], a
	ld a, $0e
	ld [wBGMapToLoad], a
	ld a, $03
	ldh [rIE], a
	xor a
	ld [wEntityStatus], a
	ld [$c281], a
	ld a, $01
	ld [wSceneVar2], a
	ret


jr_001_70c3:
	ldh a, [hFrameCounter]
	and $7f
	jr nz, jr_001_70d3

	call GetRandomByte
	and $00
	jr nz, jr_001_70d3

	call Call_01_7081

jr_001_70d3:
	ret


Jump_01_70D4::
	ld a, $10
	ld [wBGMapToLoad], a
	call IncrementGameplaySubtype
	ret


	db $00, $00, $00, $00, $40, $40, $40, $80, $85, $85, $85, $c5, $c9, $c9, $c9, $c9
	db $00, $00, $00, $00, $04, $04, $04, $04, $18, $18, $18, $18, $1c, $1c, $1c, $1c
	db $00, $00, $00, $00, $40, $40, $40, $40, $90, $90, $90, $90, $e0, $e0, $e0, $e0

Jump_01_710D::
	call Call_01_7179
	ld a, [wSceneVar1]
	cp $a0
	jr nz, jr_001_711d

	push af
	ld a, $02
	ldh [rLYC], a
	pop af

jr_001_711d:
	dec a
	ld [wSceneVar1], a
	jr nz, jr_001_713d

	ld a, $07
	ld [wGameplaySubtype], a
	ld a, $06
	ld [wEntityStatus], a
	ld a, $b0
	ld [wEntityX], a
	ld a, $68
	ld [wEntityY], a
	ld a, $01
	ld [wEntityPrivateCounter], a
	ret


jr_001_713d:
	cp $34
	jr nc, jr_001_7174

	and $03
	jr nz, jr_001_7150

	ld a, [wCreditsRole]
	cp $0c
	jr z, jr_001_7150

	inc a
	ld [wCreditsRole], a

jr_001_7150:
	ldh a, [hFrameCounter]
	and $03
	ld e, a
	ld a, [wCreditsRole]
	add e
	ld e, a
	ld d, $00
	ld hl, $70dd
	add hl, de
	ld a, [hl]
	ld [wBGPalette], a
	ld hl, $70ed
	add hl, de
	ld a, [hl]
	ld [wOBJ0Palette], a
	ld hl, $70fd
	add hl, de
	ld a, [hl]
	ld [wOBJ1Palette], a

jr_001_7174:
	ret


Jump_01_7175::
	call Call_01_739B
	ret


Call_01_7179::
	ld a, [$c291]
	cp $02
	jr nc, jr_001_7190

	ld a, [wSeaWavesSoundTimer]
	inc a
	cp $a0
	jr nz, jr_001_718d

	ld a, $0f
	ldh [hNoiseSfx], a
	xor a

jr_001_718d:
	ld [wSeaWavesSoundTimer], a

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
	ld a, [wSceneVar2]
	sla a
	ld e, a
	ld d, $00
	ld hl, $7216
	add hl, de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wDrawCommand
	ld c, $13

jr_001_7238:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_001_7238

	ld [hl], $00
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
	cp $07
	jr nz, jr_001_724e

	call IncrementGameplaySubtype

jr_001_724e:
	ret


Jump_01_724F::
	ld a, [wRasterDelay]
	cp $10
	jr c, jr_001_725d

	ld a, $19
	ldh [hNoiseSfx], a
	call IncrementGameplaySubtype

jr_001_725d:
	ret


	db $9b, $b9, $09, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $00

Jump_01_726C::
	ld de, $725e
	ld hl, wDrawCommand
	ld c, $0e

jr_001_7274:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, jr_001_7274

	call IncrementGameplaySubtype

Call_01_727D::
	ld a, $a0
	ld [wSceneVar1], a
	xor a
	ld [wSceneVar2], a
	ld a, $ff
	ld [wSceneVar3], a
	ret


	db $18, $18, $38, $40, $58, $60, $80, $88, $20, $48, $44, $28, $44, $28, $28, $40

Jump_01_729C::
	call Call_01_739B
	ldh a, [hFrameCounter]
	and $3f
	jr nz, jr_001_72e1

	ld e, $01
	ld d, $00

jr_001_72a9:
	ld hl, wEntityStatus
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
	ld hl, wEntityTimer
	add hl, de
	ld [hl], $3f
	ld a, [wSceneVar3]
	inc a
	ld [wSceneVar3], a
	and $07
	ld c, a
	ld b, $00
	ld hl, $728c
	add hl, bc
	ld a, [hl]
	ld hl, wEntityX
	add hl, de
	ld [hl], a
	ld hl, $7294
	add hl, bc
	ld a, [hl]
	ld hl, wEntityY
	add hl, de
	ld [hl], a

jr_001_72e1:
	ld a, [wSceneVar2]
	inc a
	ld [wSceneVar2], a
	and $0f
	jr nz, jr_001_7302

	ld a, [wSceneVar1]
	dec a
	ld [wSceneVar1], a
	jr nz, jr_001_7302

	call IncrementGameplaySubtype
	xor a
	ld [wTransitionSequenceCounter], a
	ld [wTransitionFrameCounter], a
	call FadeOutVolume

jr_001_7302:
	ret


Jump_01_7303::
	call FadePalettesToWhite
	ld a, [wTransitionSequenceCounter]
	cp $04
	jr nz, jr_001_7310

	jp StartIntroMode


jr_001_7310:
	ret


Jump_01_7311::
	ld a, $11
	ld [wTileMapToLoad], a
	ld a, $0b
	ld [wGameplaySubtype], a
	ld a, $c9
	ld [wBGPalette], a
	ld a, $1c
	ld [wOBJ0Palette], a
	xor a
	ldh [hBaseScrollX], a
	ldh [hBaseScrollY], a
	ret


Call_01_732B::
	call GetRandomByte
	and $18
	add $10
	ldh [hMultiPurpose1], a
	call GetRandomByte
	and $18
	add $10
	ldh [hMultiPurpose0], a
	ld hl, $c04c
	ld c, $10
	ld a, [wGameplaySubtype]
	cp $04
	jr nz, jr_001_734b

	ld c, $15

jr_001_734b:
	ldh a, [hMultiPurpose1]
	ld [hli], a
	ldh a, [hMultiPurpose0]
	ld [hli], a
	call GetRandomByte
	and $01
	ld a, $28
	jr z, jr_001_7361

	call GetRandomByte
	and $06
	add $70

jr_001_7361:
	ld [hli], a
	ld a, $00
	ld [hli], a
	ldh a, [hMultiPurpose0]
	add $1c
	ldh [hMultiPurpose0], a
	cp $a0
	jr c, jr_001_7379

	sub $98
	ldh [hMultiPurpose0], a
	ldh a, [hMultiPurpose1]
	add $25
	ldh [hMultiPurpose1], a

jr_001_7379:
	dec c
	jr nz, jr_001_734b

	ret


	db $99, $2b, $83, $1e, $20, $22, $24, $99, $2c, $83, $1f, $21, $23, $25, $00

Call_01_738C::
	ld de, wDrawCommand
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
	ld [wOAMNextIndex], a
	ld c, $02
	ld b, $00

jr_001_73a3:
	ld a, c
	ld [wActiveEntitySlot], a
	ld hl, wEntityStatus
	add hl, bc
	ld a, [hl]
	and a
	jr z, jr_001_73ce

	ld hl, wEntityX
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityX], a
	ld hl, wEntityY
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityDrawY], a
	ld hl, wEntitySpriteVariant
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntitySpriteVariant], a
	ld hl, wEntityState
	add hl, bc
	ld a, [hl]
	ldh [hActiveEntityState], a
	call Call_01_73D5

jr_001_73ce:
	dec c
	ld a, c
	cp $ff
	jr nz, jr_001_73a3

	ret


Call_01_73D5::
	ld hl, wEntityStatus
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

	call GetEntityTimer
	jr nz, jr_001_73f8

	ld hl, wEntityStatus
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
	ld a, [wSceneVar2]
	and a
	ld a, $00
	jr nz, jr_001_743f

	ldh a, [hFrameCounter]
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
	ld hl, hActiveEntityDrawY
	add [hl]
	ld [hl], a
	ld hl, $73fd
	ld de, wOAMBuffer
	push bc
	ld c, $06

jr_001_7455:
	ldh a, [hActiveEntityDrawY]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ldh a, [hActiveEntityX]
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

	ld a, [wSceneVar2]
	cp $10
	jr c, jr_001_748e

	ld hl, $7415
	ld de, $c018
	ld c, $04

jr_001_7479:
	ldh a, [hActiveEntityDrawY]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ldh a, [hActiveEntityX]
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
	ld hl, wEntityStatus
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
	call DrawEntitySprites
	ld a, [wOAMNextIndex]
	add $18
	ld [wOAMNextIndex], a
	ret


	db $00, $00, $02, $00, $04, $00, $06, $00, $08, $00, $0a, $00, $0c, $00, $0e, $00

Jump_001_7524:
	call Call_01_7179
	xor a
	ld [wEntityPhysicsFlags], a
	ld de, $7514
	call DrawEntity16x16
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_01_753C::
	dw Jump_01_7546
	dw Jump_01_7570
	dw Jump_01_759B
	dw Jump_01_75D6
	dw Jump_01_7646

Jump_01_7546::
	call Call_01_7B5F
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ldh a, [hActiveEntityX]
	cp $48
	jr nc, jr_001_7561

	call GetEntityTimer
	ld [hl], $40
	call IncrementEntityState

jr_001_7561:
	ld hl, wEntityPrivateCounter
	add hl, bc
	dec [hl]
	jr nz, jr_001_756f

	ld [hl], $04
	ld hl, wEntityX
	add hl, bc
	dec [hl]

jr_001_756f:
	ret


Jump_01_7570::
	call Call_01_7B09
	ld a, $01
	call SetEntitySpriteVariant
	call GetEntityTimer
	jr nz, jr_001_7599

	call IncrementEntityState
	ld a, $07
	ld [$c281], a
	ld a, $fe
	ld [$c201], a
	ld a, $6e
	ld [$c211], a
	xor a
	ld [$c291], a
	ld [$c2e1], a
	ldh [hFrameCounter], a
	ret


jr_001_7599:
	dec [hl]
	ret


Jump_01_759B::
	call Call_01_7B5F
	ld a, [$c201]
	dec a
	ld [$c201], a
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_001_75cc

	ld hl, hBaseScrollX
	inc [hl]
	ld a, [hl]
	cp $30
	jr nz, jr_001_75bc

	call GetEntityTimer
	ld [hl], $40
	jp IncrementEntityState


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
	ldh a, [hFrameCounter]
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


Jump_01_75D6::
	call GetEntityTimer
	jr nz, jr_001_763d

	call Call_01_7B92
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_001_7631

	ld a, [$c201]
	dec a
	ld [$c201], a
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_001_7631

	ld hl, hBaseScrollX
	inc [hl]
	ld a, [hl]
	cp $40
	jr z, jr_001_7605

	cp $3a
	jr nz, jr_001_760a

	call GetEntityTimer
	ld [hl], $30
	jr jr_001_760a

jr_001_7605:
	call GetEntityTimer
	ld [hl], $50

jr_001_760a:
	ldh a, [hBaseScrollX]
	cp $56
	jr nz, jr_001_7621

	ld a, $a0
	ld [hl], a
	ldh [rSCX], a
	ld a, $01
	ldh [rIE], a
	call GetEntityTimer
	ld [hl], $e0
	jp IncrementEntityState


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
	ldh a, [hFrameCounter]
	rra
	rra
	rra
	rra
	and $01
	call SetEntitySpriteVariant
	ret


jr_001_763d:
	dec [hl]
	call Call_01_7B09
	ld a, $01
	jp SetEntitySpriteVariant


Jump_01_7646::
	call Call_01_7B09
	ldh a, [hFrameCounter]
	and $01
	jr nz, jr_001_7681

	ld a, $02
	call SetEntitySpriteVariant
	ld a, $00
	ld [$c3b1], a
	call GetEntityTimer
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
	call SetEntitySpriteVariant
	ld a, $01
	ld [$c3b1], a

jr_001_7681:
	ret


	db $38, $00, $38, $20, $3a, $00, $3a, $20, $3a, $00, $3a, $20, $3c, $00, $3e, $00
	db $3c, $00, $3e, $00, $3a, $00, $3a, $20, $3a, $00, $3a, $20, $38, $00, $38, $20

Jump_001_76a2:
	call GetEntityTimer
	dec [hl]
	jr nz, jr_001_76ae

	ld hl, wEntityStatus
	add hl, bc
	ld [hl], b
	ret


jr_001_76ae:
	ld a, [hl]
	rra
	rra
	rra
	and $07
	ldh [hActiveEntitySpriteVariant], a
	xor a
	ld [wEntityPhysicsFlags], a
	ld de, $7682
	call DrawEntity16x16
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a
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
	ld de, wDrawCommand
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
	ldh a, [hActiveEntityX]
	cp $f0
	jr nc, jr_001_7724

	xor a
	ld [wEntityPhysicsFlags], a
	ld de, $7704
	call DrawEntity16x16
	ld a, [wOAMNextIndex]
	add $08
	ld [wOAMNextIndex], a

jr_001_7724:
	ldh a, [hActiveEntityState]
	rst $00

JumpTable_01_7727::
	dw Jump_01_772F
	dw Jump_01_773B
	dw Jump_01_774B
	dw Jump_01_77A1

Jump_01_772F::
	call GetEntityTimer
	dec [hl]
	jr nz, jr_001_773a

	ld [hl], $90
	call IncrementEntityState

jr_001_773a:
	ret


Jump_01_773B::
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_001_7747

	call GetEntityTimer
	dec [hl]
	jr z, jr_001_7748

jr_001_7747:
	ret


jr_001_7748:
	jp IncrementEntityState


Jump_01_774B::
	ld a, [wSceneFadeStep]
	cp $13
	jr z, jr_001_7790

	ld a, [wSceneStep]
	inc a
	ld [wSceneStep], a
	and $03
	jr nz, jr_001_778f

	ld a, [wEntityY]
	cp $a0
	jr nc, jr_001_7768

	inc a
	ld [wEntityY], a

jr_001_7768:
	ld a, [$c211]
	cp $a0
	jr nc, jr_001_7773

	inc a
	ld [$c211], a

jr_001_7773:
	ldh a, [hBaseScrollY]
	push af
	dec a
	ldh [hBaseScrollY], a
	pop af
	and $07
	jr nz, jr_001_778f

	push bc
	call Call_01_7A41
	pop bc
	ld a, [wSceneFadeStep]
	cp $0b
	jr nz, jr_001_778f

	ld a, $01
	ld [wMusicTrackToPlay], a

jr_001_778f:
	ret


jr_001_7790:
	call IncrementEntityState
	call GetEntityTimer
	ld [hl], $17
	ld a, $07
	ldh [hVolumeRight], a
	ld a, $70
	ldh [hVolumeLeft], a
	ret


Jump_01_77A1::
	ldh a, [hFrameCounter]
	and $03
	jr nz, jr_001_77c0

	call GetEntityTimer
	dec [hl]
	jr nz, jr_001_77c0

	call IncrementGameplaySubtype
	xor a
	ld [wSceneVar2], a
	ld [wSceneVar3], a
	ld [wSceneVar4], a
	ld [wEntityStatus], a
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
	ld a, [wSceneFadeStep]
	and a
	jr nz, jr_001_7a51

	ld a, $f4
	ld [wSceneVarB], a
	ld a, $9b
	ld [wSceneVarC], a

jr_001_7a51:
	ld a, [wSceneFadeStep]
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
	ld hl, wDrawCommand
	ld a, [wSceneVarC]
	ld [hli], a
	ld a, [wSceneVarB]
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
	ld hl, wSceneFadeStep
	inc [hl]
	ld a, [wSceneVarB]
	sub $20
	ld [wSceneVarB], a
	ld a, [wSceneVarC]
	sbc $00
	ld [wSceneVarC], a
	ret


	db $00, $50, $80, $50, $00, $51, $80, $51, $00, $52, $80, $52, $00, $53, $80, $53
	db $00, $02, $04, $06, $06, $04, $02, $00, $03, $02, $01, $00, $00, $01, $02, $03

Call_01_7AC4::
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_001_7ace

	inc [hl]

jr_001_7ace:
	inc hl
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_001_7ad6

	inc [hl]

jr_001_7ad6:
	inc hl
	ldh a, [hFrameCounter]
	and $1f
	jr nz, jr_001_7ade

	inc [hl]

jr_001_7ade:
	inc hl
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_001_7ae6

	inc [hl]

jr_001_7ae6:
	inc hl
	ld a, [wSceneVar4]
	add $28
	ld [wSceneVar4], a
	jr nc, jr_001_7af2

	inc [hl]

jr_001_7af2:
	ldh a, [hFrameCounter]
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
	ld [wIntroBandScrollY], a

Call_01_7B09::
	ldh a, [hFrameCounter]
	and $0f
	cp $04
	jr c, jr_001_7b5e

Call_01_7B11::
	ldh a, [hFrameCounter]
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
	ld a, [wSceneVarF]
	and a
	jr z, jr_001_7b2d

	ld hl, $7aac

jr_001_7b2d:
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $8900
	ld a, [wSceneVarF]
	and a
	jr z, jr_001_7b3d

	ld de, $9300

jr_001_7b3d:
	ldh a, [hFrameCounter]
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
	ld [wSceneTimer], a
	ld a, h
	ld [wSceneTimer2], a
	ld a, e
	ld [wSceneTimer3], a
	ld a, d
	ld [wSceneSlowTimer], a

jr_001_7b5e:
	ret


Call_01_7B5F::
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $07
	jr nz, jr_001_7b69

	inc [hl]

jr_001_7b69:
	ld hl, $c101
	ld a, [wSceneVar4]
	add $50
	ld [wSceneVar4], a
	jr nc, jr_001_7b77

	inc [hl]

jr_001_7b77:
	inc hl
	ld a, [wSceneVar5]
	add $58
	ld [wSceneVar5], a
	jr nc, jr_001_7b83

	inc [hl]

jr_001_7b83:
	inc hl
	ld a, [wSceneVarD]
	add $b0
	ld [wSceneVarD], a
	jr nc, jr_001_7b8f

	inc [hl]

jr_001_7b8f:
	jp Call_01_7B09


Call_01_7B92::
	ld hl, wIntroBandScrollX
	ldh a, [hFrameCounter]
	and $0f
	jr nz, jr_001_7b9c

	inc [hl]

jr_001_7b9c:
	ld hl, $c101
	ld a, [wSceneVar4]
	add $28
	ld [wSceneVar4], a
	jr nc, jr_001_7baa

	inc [hl]

jr_001_7baa:
	inc hl
	ld a, [wSceneVar5]
	add $2c
	ld [wSceneVar5], a
	jr nc, jr_001_7bb6

	inc [hl]

jr_001_7bb6:
	inc hl
	ld a, [wSceneVarD]
	add $58
	ld [wSceneVarD], a
	jr nc, jr_001_7bc2

	inc [hl]

jr_001_7bc2:
	jp Call_01_7B09


Call_01_7BC5::
	ldh a, [hBGTilesLoadingStage]
	cp $08
	jp c, Jump_001_7c87

	jr nz, jr_001_7bd6

	call Call_01_7C00
	ld hl, hBGTilesLoadingStage
	inc [hl]
	ret


jr_001_7bd6:
	call Call_01_7BFA
	xor a
	ldh [hNeedsUpdatingBGTiles], a
	ldh [hBGTilesLoadingStage], a
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
	ldh [hMultiPurpose9], a
	ld d, $00

Jump_001_7c09:
	xor a
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose1], a
	ldh [hMultiPurpose2], a
	ldh [hMultiPurpose3], a
	ld hl, wDungeonFlags
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
	ldh [hMultiPurpose0], a
	ldh [hMultiPurpose1], a
	ldh [hMultiPurpose2], a
	ld hl, $7be7
	add hl, de
	ld a, [hl]
	ldh [hMultiPurpose3], a
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
	ldh [hMultiPurpose0], a
	inc a
	ldh [hMultiPurpose1], a
	add $0f
	ldh [hMultiPurpose2], a
	inc a
	ldh [hMultiPurpose3], a
	pop hl

jr_001_7c58:
	ldh a, [hMultiPurpose0]
	ld [hl], a
	call Call_01_7C79
	ldh a, [hMultiPurpose1]
	ld [hl], a
	inc c
	call Call_01_7C79
	ldh a, [hMultiPurpose2]
	ld [hl], a
	inc c
	call Call_01_7C79
	ldh a, [hMultiPurpose3]
	ld [hl], a
	inc e
	ld a, e
	ld hl, hMultiPurpose9
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
	call CopyTilesFromBank0C
	ldh a, [hBGTilesLoadingStage]
	inc a
	ldh [hBGTilesLoadingStage], a
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
	ld hl, wRoomObjectsArea
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


CopyDMARoutine::
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


DMARoutine::
	db $3e, $c0, $e0, $46, $3e, $28, $3d, $20, $fd, $c9

UnusedDiagonalTiles::
	db $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $40, $40, $20, $20
	db $10, $10, $08, $08, $04, $04, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

DungeonMarkerAddresses::
	db $2d, $9e, $2c, $9e, $2b, $9e
	db $2d, $9e, $31, $9e, $2d, $9e, $2b, $9e, $2d, $9e

UnusedMarkDungeonOnMap::
	ld a, [$0004]
	and a
	ret nz

	ld a, [wIsIndoor]
	and a
	jr z, jr_001_7de7

	ldh a, [hMapId]
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
	ldh a, [hIsSideScrolling]
	and a
	jr z, jr_001_7de7

	ld [hl], $7f

jr_001_7de7:
	ret


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

Call_01_7EE8::
	ld de, $9822
	ld bc, $0000

jr_001_7eee:
	ld a, [wMapScreenFromBook]
	and a
	jr nz, jr_001_7f06

	ld a, [wGameplayType]
	cp $01
	jr z, jr_001_7f06

	ld hl, wRoomStatus
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
