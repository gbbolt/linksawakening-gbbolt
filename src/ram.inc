; Named RAM / IO addresses.
; Format: DEF name EQU $addr ;@ type description
;   type: u8 | u16 (little endian) | u8[N] | code[N] | const
; Lines without ";@" are plain constants.
DEF wCurrentBank EQU $DBAF ;@ u8 The ROM bank switched in at $4000-$7FFF
DEF wGameplayType EQU $DB95 ;@ u8 The game mode: intro, file menu, world, ... (dispatched at $0ACE)
DEF wGameplaySubtype EQU $DB96 ;@ u8 The step within the current game mode
DEF wEntityX EQU $C200 ;@ u8[16] Entity x position on screen (pixels), one byte per slot
DEF wEntityY EQU $C210 ;@ u8[16] Entity y position on screen (pixels), one byte per slot
DEF wEntityZ EQU $C310 ;@ u8[16] Entity height above the ground (pixels; drawn that much higher)
DEF wEntitySpeedX EQU $C240 ;@ u8[16] Entity horizontal speed (signed, 1/16 pixel per frame)
DEF wEntitySpeedY EQU $C250 ;@ u8[16] Entity vertical speed (signed, 1/16 pixel per frame)
DEF wEntityStatus EQU $C280 ;@ u8[16] Entity slot status (0 = free slot; others: dying, active, lifted, ...)
DEF wEntityState EQU $C290 ;@ u8[16] Entity handler state (step of its state machine)
DEF wEntityTimer EQU $C2E0 ;@ u8[16] Entity countdown timer, counts down by itself every frame
DEF wEntityType EQU $C3A0 ;@ u8[16] Entity type (index into the handler table EntityHandlers)
DEF wEntitySpriteVariant EQU $C3B0 ;@ u8[16] Entity sprite / animation frame chosen by its handler
DEF wActiveEntitySlot EQU $C123 ;@ u8 Slot number of the entity whose handler is running
DEF hFrameCounter EQU $FFE7 ;@ u8 Counts up once per frame
DEF hLinkX EQU $FF98 ;@ u8 Link's x position on screen (pixels)
DEF hLinkY EQU $FF99 ;@ u8 Link's y position on screen (pixels)
DEF hLinkSpeedX EQU $FF9A ;@ u8 Link's horizontal speed (signed)
DEF hLinkSpeedY EQU $FF9B ;@ u8 Link's vertical speed (signed)
DEF hActiveEntityStatus EQU $FFEA ;@ u8 Status of the entity being handled (copy of wEntityStatus)
DEF hActiveEntityType EQU $FFEB ;@ u8 Type of the entity being handled (copy of wEntityType)
DEF hActiveEntityX EQU $FFEE ;@ u8 X position of the entity being handled
DEF hActiveEntityY EQU $FFEF ;@ u8 Y position of the entity being handled
DEF hActiveEntityDrawY EQU $FFEC ;@ u8 Y position of the entity being handled, minus its height (where it is drawn)
DEF hActiveEntityState EQU $FFF0 ;@ u8 State of the entity being handled (copy of wEntityState)
DEF hActiveEntitySpriteVariant EQU $FFF1 ;@ u8 Sprite variant of the entity being handled ($FF = not drawn)
DEF wEntityPosXHigh EQU $C220 ;@ u8[16] High byte / sign of the entity x position (off-screen overflow)
DEF wEntityPosYHigh EQU $C230 ;@ u8[16] High byte / sign of the entity y position (off-screen overflow)
DEF wEntitySpeedXAcc EQU $C260 ;@ u8[16] Fraction accumulator for the x speed
DEF wEntitySpeedYAcc EQU $C270 ;@ u8[16] Fraction accumulator for the y speed
DEF wEntityPrivate1 EQU $C2B0 ;@ u8[16] Entity-specific variable 1 (each entity type uses it its own way)
DEF wEntityPrivate2 EQU $C2C0 ;@ u8[16] Entity-specific variable 2
DEF wEntityPrivate3 EQU $C2D0 ;@ u8[16] Entity-specific variable 3
DEF wEntityTimer1 EQU $C2F0 ;@ u8[16] Per-entity countdown timer 1
DEF wEntityTimer2 EQU $C300 ;@ u8[16] Per-entity countdown timer 2
DEF wEntitySpeedZ EQU $C320 ;@ u8[16] Entity vertical (height) speed, signed
DEF wEntitySpeedZAcc EQU $C330 ;@ u8[16] Fraction accumulator for the height speed
DEF wEntityPhysicsFlags EQU $C340 ;@ u8[16] Entity physics/display flags (low nibble = number of OAM sprites used)
DEF wEntityHitboxFlags EQU $C350 ;@ u8[16] Entity hitbox flags
DEF wEntityHealth EQU $C360 ;@ u8[16] Entity hit points
DEF wEntityDirection EQU $C380 ;@ u8[16] Entity facing direction (0 right, 1 left, 2 up, 3 down)
DEF wEntityPrivate5 EQU $C390 ;@ u8[16] Entity-specific variable 5
DEF wOAMNextIndex EQU $C3C0 ;@ u8 Offset of the next free OAM entry in the OAM buffer at $C030
DEF wEntityPrivateCounter EQU $C3D0 ;@ u8[16] Entity-specific frame counter (animation and step counting)
DEF wEntityRoom EQU $C3E0 ;@ u8[16] Room in which the entity was loaded
DEF wEntityIgnoreHitsTimer EQU $C410 ;@ u8[16] Frames during which the entity cannot be hit again
DEF wEntityFlashTimer EQU $C420 ;@ u8[16] Frames the entity keeps flashing after a hit
DEF wEntityOptions1 EQU $C430 ;@ u8[16] Entity option flags from its type's definition
DEF wEntityPrivate4 EQU $C440 ;@ u8[16] Entity-specific variable 4
DEF wEntityDropTimer EQU $C450 ;@ u8[16] Per-entity countdown (drop timer)
DEF hLinkPositionZ EQU $FFA2 ;@ u8 Link's height above the ground (jumping)
DEF hMapRoom EQU $FFF6 ;@ u8 The current room number
DEF hMultiPurpose0 EQU $FFD7 ;@ u8 Scratch byte 0 (meaning depends on the routine)
DEF hMultiPurpose1 EQU $FFD8 ;@ u8 Scratch byte 1
DEF hMultiPurpose2 EQU $FFD9 ;@ u8 Scratch byte 2
DEF hMultiPurpose3 EQU $FFDA ;@ u8 Scratch byte 3
DEF wEntityCollisions EQU $C2A0 ;@ u8[16] Walls the entity touched this frame (set by the background collision check)
DEF wEntityRecoilSpeedX EQU $C3F0 ;@ u8[16] Horizontal speed of the knockback after a hit
DEF wEntityRecoilSpeedY EQU $C400 ;@ u8[16] Vertical speed of the knockback after a hit
DEF hLinkDirection EQU $FF9E ;@ u8 Link's facing direction: 0 right, 1 left, 2 up, 3 down
DEF hJoypadHeld EQU $FFCB ;@ u8 Buttons held: bit 0 right, 1 left, 2 up, 3 down, 4 A, 5 B, 6 select, 7 start
DEF hJoypadPressed EQU $FFCC ;@ u8 Buttons newly pressed this frame (same bits as hJoypadHeld)
DEF hJingle EQU $FFF2 ;@ u8 Sound effect request for the square channel
DEF hWaveSfx EQU $FFF3 ;@ u8 Sound effect request for the wave channel
DEF hNoiseSfx EQU $FFF4 ;@ u8 Sound effect request for the noise channel
DEF wItemB EQU $DB00 ;@ u8 Item on the B button (inventory index)
DEF wItemA EQU $DB01 ;@ u8 Item on the A button (inventory index)
DEF wDialogState EQU $C19F ;@ u8 Dialogue box state (0 = no box open)
DEF hFrameInProgress EQU $FFFD ;@ u8 1 while the main loop works on a frame; the VBlank handler then skips its work (lag frame)
DEF hVBlankDone EQU $FFD1 ;@ u8 Set to 1 at the end of every VBlank interrupt; the main loop waits for it after `halt`
DEF wOAMBuffer EQU $C000 ;@ u8[160] Shadow copy of the sprite table (40 entries of y, x, tile, attributes), sent to OAM by DMA in VBlank
DEF hDMARoutine EQU $FFC0 ;@ code[10] The OAM DMA routine, copied to HRAM at boot (the CPU can only run from HRAM during DMA)
DEF hBaseScrollX EQU $FF96 ;@ u8 Background x scroll of the room (camera)
DEF hBaseScrollY EQU $FF97 ;@ u8 Background y scroll of the room (camera)
DEF wScreenShakeX EQU $C155 ;@ u8 Added to the x scroll (screen shake)
DEF wScreenShakeY EQU $C156 ;@ u8 Added to the y scroll (screen shake)
DEF wScrollXOffset EQU $C1BF ;@ u8 Extra x scroll added on top of hBaseScrollX and wScreenShakeX
DEF wLCDControl EQU $D6FD ;@ u8 Value for rLCDC, written back after a full background redraw
DEF wTileMapToLoad EQU $D6FE ;@ u8 Request for the main loop: load a whole tile set / screen (1-based index into the loader table at $04B3; 0 = none)
DEF wBGMapToLoad EQU $D6FF ;@ u8 Request for the main loop: draw one of the screen layouts of the table at $0457 (0 = none)
DEF wBGPalette EQU $DB97 ;@ u8 Background palette, copied to rBGP every frame
DEF wOBJ0Palette EQU $DB98 ;@ u8 Sprite palette 0, copied to rOBP0 every frame
DEF wOBJ1Palette EQU $DB99 ;@ u8 Sprite palette 1, copied to rOBP1 every frame
DEF wWindowY EQU $DB9A ;@ u8 Window y position, copied to rWY every frame ($80 = window hidden below the screen)
DEF wTransitionGfx EQU $C17F ;@ u8 Full-screen wave effect in progress (1-3 bank $14 wobble, $FE/$FF bank $17 effect; 0 = none)
DEF wTransitionGfxFrameCount EQU $C180 ;@ u8 Frame counter of the wave effect (runs up to $C0)
DEF hNeedsUpdatingBGTiles EQU $FF90 ;@ u8 Request for the VBlank handler to copy background tiles (1-2 tile set of the area, 3-6 single tile swaps, 7 bank 1, 8+ series)
DEF hNeedsUpdatingEnemiesTiles EQU $FF91 ;@ u8 Request for the VBlank handler to copy the tiles of an entity graphics set (slot in wEntityTilesSlotA)
DEF hBGTilesLoadingStage EQU $FF92 ;@ u8 Step of the background tile copy (one 64-byte piece per VBlank)
DEF hEnemiesTilesLoadingStage EQU $FF93 ;@ u8 Step of the entity tile copy (one 64-byte piece per VBlank)
DEF hWorldTileset EQU $FF94 ;@ u8 Tile set of the current area (picks the background tiles that are loaded)
DEF wNeedsUpdatingNPCTiles EQU $C10E ;@ u8 Second entity tile set request (slot in wEntityTilesSlotB), done after hNeedsUpdatingEnemiesTiles
DEF wNPCTilesLoadingStage EQU $C10F ;@ u8 Step of the second entity tile copy
DEF wEntityTilesSlotA EQU $C197 ;@ u8 Which of the 4 entity tile slots ($8400 + slot * $100) the first request fills
DEF wEntityTilesSlotB EQU $C10D ;@ u8 Which of the 4 entity tile slots the second request fills
DEF wLoadedEntityTilesets EQU $C193 ;@ u8[4] Entity graphics set loaded in each of the 4 entity tile slots (bits 0-5 page, bits 6-7 bank group)
DEF hBGTilesRequestCopy EQU $FFE8 ;@ u8 Copy of hNeedsUpdatingBGTiles taken at the start of VBlank
DEF wDrawCommandsSize EQU $D600 ;@ u8 Size of the queued background draw commands at wDrawCommand
DEF wDrawCommand EQU $D601 ;@ u8[96] Queue of background draw commands (address, length/mode, data; 0 ends), drawn in the next VBlank
DEF hMapId EQU $FFF7 ;@ u8 The current map: dungeon / indoor area number (overworld when wIsIndoor is 0)
DEF wIsIndoor EQU $DBA5 ;@ u8 1 inside (houses, caves, dungeons), 0 on the overworld
DEF hIsSideScrolling EQU $FFF9 ;@ u8 1 in the side-view areas (underground passages, side-view rooms)
DEF wLinkMotionState EQU $C11C ;@ u8 What Link is doing: 0 normal, 3 fading out for a warp, 7 dying (game over), others special motions
DEF wTransitionSequenceCounter EQU $C16B ;@ u8 Step of the screen fade (0-4; 4 = done)
DEF wTransitionFrameCounter EQU $C16C ;@ u8 Frame counter of the screen fade (a fade step every 4 frames)
DEF wRoomObjects EQU $D711 ;@ u8[160] Object (block type) of each 16x16 square of the room, rows of 16 bytes ($D711 = top-left square)
DEF wRoomTransitionState EQU $C124 ;@ u8 Nonzero while the screen scrolls to the next room
DEF wInventoryAppearing EQU $C14F ;@ u8 Nonzero while the inventory (subscreen) slides in or out
DEF hLinkAnimationState EQU $FF9D ;@ u8 Link's sprite pose (index into the Link tile table; $FF = Link not drawn)
DEF wLinkDrawY EQU $C145 ;@ u8 Link's y position on screen minus his height (where his sprite is drawn)
DEF hLinkInteractiveMotionBlocked EQU $FFA1 ;@ u8 Non-zero blocks Link's controls for this frame (1 = no walking, 2 = frozen); entities set it every frame of a cutscene
DEF hActiveEntityFlipAttribute EQU $FFED ;@ u8 OAM attribute bits XORed into the sprites of the entity being drawn (bit 4 palette, bit 5 x flip, bit 6 y flip)
DEF hRoomStatus EQU $FFF8 ;@ u8 Status flags of the current room (copy of its byte in wRoomStatus)
DEF hMultiPurposeE EQU $FFE5 ;@ u8 Scratch byte E
DEF hMultiPurposeF EQU $FFE6 ;@ u8 Scratch byte F
DEF wMusicTrackToPlay EQU $D368 ;@ u8 Music track request (the sound engine starts it and clears the byte)
DEF wDialogAnswer EQU $C177 ;@ u8 Choice made in the last question dialogue (0 = first answer)
DEF wPowerBraceletLevel EQU $DB43 ;@ u8 Power Bracelet level (0 none, 1, 2)
DEF wTradeSequenceItem EQU $DB0E ;@ u8 Current item of the trading sequence (0 none, 1 Yoshi doll ... $0E magnifying lens)
DEF wOcarinaSongFlags EQU $DB49 ;@ u8 Ocarina songs learnt: bit 2 Ballad of the Wind Fish (song 0), bit 1 song 1, bit 0 song 2 (Frog's Song of Soul)
DEF wSelectedSong EQU $DB4A ;@ u8 Song selected for the ocarina (0 Ballad of the Wind Fish, 1 Manbo's Mambo, 2 Frog's Song of Soul)
DEF wOcarinaSongState EQU $C166 ;@ u8 Set to 1 while Link has just played a song on the ocarina; $FF once an entity reacted to it
DEF wWarpType EQU $D401 ;@ u8 Warp record 0, byte 0: kind of destination (0 overworld, 1 indoors, 2 side view)
DEF wWarpMap EQU $D402 ;@ u8 Warp record 0, byte 1: destination map
DEF wWarpRoom EQU $D403 ;@ u8 Warp record 0, byte 2: destination room
DEF wWarpDestX EQU $D404 ;@ u8 Warp record 0, byte 3: Link's x position on arrival
DEF wWarpDestY EQU $D405 ;@ u8 Warp record 0, byte 4: Link's y position on arrival
DEF wWarpDestPosition EQU $D416 ;@ u8 Tile position where Link arrives (high nibble row, low nibble column)
DEF wRoomStatus EQU $D800 ;@ u8[768] Status flags of every room: 256 overworld rooms, then two groups of 256 indoor rooms; bits 4 and 5 mark events done in the room
DEF wCanTalkToEntity EQU $C1AD ;@ u8 Set to 1 while Link stands in talking position in front of a character
DEF hDefaultMusicTrack EQU $FFB0 ;@ u8 Music track of the current area, played again after special music
DEF wEntityGroundStatus EQU $C470 ;@ u8[16] What the entity stands on, set by the background collision check (2 and 3 get a ripple / grass overlay drawn under it)
DEF wOAMEntriesUsed EQU $C3C1 ;@ u8 Number of OAM bytes handed out to entities this frame (from $60 on, the start of the list rotates so sprites flicker instead of vanishing)
DEF wIsLinkInTheAir EQU $C146 ;@ u8 Nonzero while Link is in the air (jumping with the feather, falling from a ledge)
DEF wIsUsingPegasusBoots EQU $C14A ;@ u8 Nonzero while Link dashes with the Pegasus Boots
DEF wHookshotChainSlot EQU $C1A6 ;@ u8 Slot + 1 of the hookshot chain entity (set by the chain's handler every frame it is out)
DEF wEntityWorkRAM EQU $D000 ;@ u8[256] Work area of the room's boss or special character (Moldorm's trail of x positions, the Genie's shared speed and bottle slot, ...)
DEF wEntityWorkRAM2 EQU $D100 ;@ u8[256] Second work area (Moldorm's trail of y positions, ...)
DEF wIntroLCDSection EQU $C105 ;@ u8 Intro screen: which horizontal band the LCD interrupt handles next (each band has its own x scroll)
DEF wIntroBandScrollX EQU $C100 ;@ u8[5] Intro screen: x scroll of each horizontal band (parallax)
DEF wIntroBandScrollY EQU $C106 ;@ u8 Intro screen: y scroll used from the last band down
DEF wIsBowWowFollowingLink EQU $DB56 ;@ u8 BowWow's story state: 0 chained at Madam MeowMeow's house, $80 held in the Moblins' cave, 1 following Link on its chain
DEF wSegmentY EQU $D110 ;@ u8[16] Shared entity work table: y positions of trailing parts (BowWow's chain links, body segments)
DEF wBowWowAnchorX EQU $D150 ;@ u8 x of the point BowWow's chain is fixed to (its stake, or Link while it follows him)
DEF wBowWowAnchorY EQU $D151 ;@ u8 y of the point BowWow's chain is fixed to
DEF wBowWowTargetSlot EQU $D152 ;@ u8 Slot of the entity BowWow is lunging at to eat
DEF wBowWowSlot EQU $D154 ;@ u8 Entity slot BowWow occupies (set by its handler every frame)
DEF hLinkSpeedZ EQU $FFA3 ;@ u8 Link's height speed (signed, 1/16 pixel per frame; positive = up)
DEF wLinkSubpixelX EQU $C11A ;@ u8 Fraction (1/16 pixel, high nibble) of Link's x position; the next byte is the y fraction
DEF wLinkSubpixelY EQU $C11B ;@ u8 Fraction (1/16 pixel, high nibble) of Link's y position
DEF wLinkSubpixelZ EQU $C149 ;@ u8 Fraction (1/16 pixel, high nibble) of Link's height
DEF hRoomObjectType EQU $FFAF ;@ u8 Room object id the current routine examines or replaces
DEF wLiftDirection EQU $C15D ;@ u8 Direction Link faced when he lifted the object he carries
DEF wBGOriginHigh EQU $C12E ;@ u8 High byte of the BG map address of the screen's top-left tile
DEF wBGOriginLow EQU $C12F ;@ u8 Low byte of the BG map address of the screen's top-left tile
DEF wDialogBoxStep EQU $C16F ;@ u8 Row step (0-5) of the dialog box opening / closing animation
DEF wDialogCharIndex EQU $C170 ;@ u8 Low byte of the position of the next character in the dialog text
DEF wDialogCharIndexHigh EQU $C164 ;@ u8 High byte of the position of the next character in the dialog text
DEF wDialogCharSlot EQU $C171 ;@ u8 Place in the box (0-$1F: two lines of 16) for the next character
DEF wDialogScrollDelay EQU $C172 ;@ u8 Frames to wait before the next dialog step (scrolling, typing)
DEF wDialogIndex EQU $C173 ;@ u8 Low byte of the number of the dialog being shown
DEF wDialogIndexHigh EQU $C112 ;@ u8 High byte of the dialog number (0-2: which third of the dialog table)
DEF wDialogNameCharIndex EQU $C108 ;@ u8 Which letter (0-4) of the player name the next '#' prints
DEF wDialogSfx EQU $C5AB ;@ u8 Sound effect played while the text types out ($0F normal)
DEF wDialogCharBGHigh EQU $C175 ;@ u8 High byte of the BG map address of the character being typed
DEF wDialogCharBGLow EQU $C176 ;@ u8 Low byte of the BG map address of the character being typed
DEF wDialogNextChar EQU $C3C3 ;@ u8 The character after the one just typed ($FF end, $FE question)
DEF wDialogFullJinglePlayed EQU $C1CC ;@ u8 Set once the "box full" jingle played for this page
DEF wDialogKeepOpen EQU $C1AB ;@ u8 While non-zero, the end of a dialog does not close on a button press
DEF wDialogCooldown EQU $C134 ;@ u8 Frames after a dialog closes before Link can start another one
DEF wDialogBackground EQU $D500 ;@ u8[$6C] BG tiles hidden under the dialog box (6 rows of 18), restored when it closes
DEF wPlayerName EQU $DB4F ;@ u8[5] The player's name (5 characters, 0 = unused)
DEF wIsThief EQU $DB6E ;@ u8 Set after stealing from the shop: dialogs call the player THIEF
DEF wGoldenLeaves EQU $DB15 ;@ u8 Golden leaves found for Richard (0-5; 6 = all; $FF once handed over)
DEF wRichardQuest EQU $DB55 ;@ u8 Progress of Richard's request (2 = he has asked for the golden leaves)
DEF hBGChangeRequest EQU $FFA5 ;@ u8 Request for the main loop to change part of the room's background (index of a change routine, 0 = none)
DEF wLinkIsCarrying EQU $C3CF ;@ u8 Nonzero while Link holds an object above his head
DEF wEntityDropType EQU $C4E0 ;@ u8[16] Entity type the entity leaves behind when it is defeated (0 = the default drop)
DEF wEntityLoadOrder EQU $C460 ;@ u8[16] Position of the entity in its room's entity list ($FF = not from the list, so it is not remembered as defeated)
DEF wEntityDyingTimer EQU $C480 ;@ u8[16] Frames of the death animation left (set with status 1, dying)
DEF wAlternateBackgroundEnabled EQU $C500 ;@ u8 Nonzero: on the world screen the y scroll flips between 0 and $80 every frame (two backgrounds shown on alternate frames)
DEF wDebugPaused EQU $D6FC ;@ u8 Debug pause (only possible when the debug switch at $0003 is set): 1 = the game logic is not run
DEF wDebugToggle EQU $C17B ;@ u8 Bit 4 is toggled when the debug pause ends (debug switch only); Link's code checks it
DEF wRasterLine EQU $C17C ;@ u16 Raster effects: number of lines handled so far this frame
DEF wRasterDelay EQU $C17E ;@ u8 Raster effects: a short delay counter (counts on to the next even value each line)
DEF wWavePaletteStep EQU $C3CA ;@ u8 Wave effect: palette step of the fade at its end (0-$0C)
DEF hStartButtonDelay EQU $FFB5 ;@ u8 Title screen: frames left before the Start button is accepted
DEF hVolumeFadeOutTimer EQU $FFA8 ;@ u8 Counts down while the sound volume fades out (one step every 4 frames)
DEF hVolumeRight EQU $FFA9 ;@ u8 Sound master volume of the right output (0-7)
DEF hVolumeLeft EQU $FFAA ;@ u8 Sound master volume of the left output ($00-$70, high nibble)
DEF hVolumeFadeInTimer EQU $FFAB ;@ u8 Counts down while the sound volume fades back in (one step every 2 frames)
DEF wSceneVar1 EQU $D001 ;@ u8 Credits scenes (wEntityWorkRAM+1): fade step, row counter or sub-state, depending on the step
DEF wSceneVar2 EQU $D002 ;@ u8 Credits scenes (wEntityWorkRAM+2): scroll fraction, fade step or picture frame, depending on the step
DEF wSceneVar3 EQU $D003 ;@ u8 Credits scenes (wEntityWorkRAM+3): fraction accumulator or picture frame, depending on the step
DEF wSceneVar4 EQU $D004 ;@ u8 Credits scenes (wEntityWorkRAM+4): only cleared
DEF wSceneVar5 EQU $D005 ;@ u8 Credits scenes (wEntityWorkRAM+5): wave effect strength ($00 strongest ... $E0 weakest, in steps of $20), a fade step, or the credits roll's "same title" flag
DEF wSceneTimer EQU $D006 ;@ u8 Credits scenes: countdown, -1 every frame (how long a step waits)
DEF wSceneTimer2 EQU $D007 ;@ u8 Credits scenes: second countdown, -1 every frame
DEF wSceneTimer3 EQU $D008 ;@ u8 Credits scenes: third countdown, -1 every frame (how long a credits name stays)
DEF wSceneSlowTimer EQU $D009 ;@ u8 Credits scenes: countdown, -1 every 4 frames
DEF wSceneFadeStep EQU $D00A ;@ u8 Credits scenes: step of the palette fade (0-12) or entry of the credits roll
DEF wSceneVarB EQU $D00B ;@ u8 Credits scenes: frame counter, animation frame or step of the tile dissolve (0-$3F)
DEF wSceneVarC EQU $D00C ;@ u8 Credits scenes: speed or fade step, depending on the step
DEF wSceneVarD EQU $D00D ;@ u8 Credits scenes: animation step or scroll row, depending on the step
DEF wSceneStep EQU $D00E ;@ u8 Credits: step within the current credits subtype (each subtype dispatches on it)
DEF wSceneVarF EQU $D00F ;@ u8 Credits scenes: index into a bobbing table or a frame divider
DEF wCreditsRole EQU $D010 ;@ u8 Credits roll: role title being shown (index into CreditsRoleTitles; $FF = none)
DEF wCreditsName EQU $D011 ;@ u8 Credits roll: name being shown (index into CreditsNames)
DEF wCreditsRollStep EQU $D012 ;@ u8 Credits roll: 0 pick the entry, 1 fade in, 2 wait, 3 fade out, 4 send the last bird, 5 done
DEF wSceneVerySlowTimer EQU $D013 ;@ u8 Credits scenes: countdown, -1 every 16 frames
DEF wSeaWavesSoundTimer EQU $C114 ;@ u8 Counts frames up to $C0; each time it wraps the sea waves sound plays (noise $0F)
DEF wSeagullCryTimer EQU $D466 ;@ u8 Frames until the next seagull cry (square sound $21); reloaded with a random 80-207
DEF hMultiPurposeD EQU $FFE4 ;@ u8 Scratch byte D
DEF hMultiPurposeH EQU $FFE9 ;@ u8 Scratch byte H (meaning depends on the routine)
DEF wRoomObjectsArea EQU $D700 ;@ u8[256] Room object area: wRoomObjects is at +$11 (the bytes before it and around it are the border)
DEF wDeathCount EQU $DB57 ;@ u16 How many times Link has died in this file (the ending shows an extra scene when it is 0)
DEF wInvincibilityCounter EQU $DBC7 ;@ u8 Frames Link stays invincible
DEF wMenuCursor EQU $C13F ;@ u8 Cursor position in the save menu, the game over menu and the file menus (0 = first choice)
DEF wMapEntrancePositionX EQU $DB9D ;@ u8 Link's x position where he entered the current room (where he reappears)
DEF wMapEntrancePositionY EQU $DB9E ;@ u8 Link's y position where he entered the current room (where he reappears)
DEF hLinkCountdown EQU $FFB7 ;@ u8 Countdown for Link's current action (e.g. the death spin), decremented every frame
DEF hLinkMotionStep EQU $FF9C ;@ u8 Step within Link's current motion state (e.g. the steps of the death / game over sequence)
DEF hLinkDrawYAtFrameStart EQU $FFB3 ;@ u8 Link's y position minus his height, taken at the start of the frame
DEF wLinkCollisionFlags EQU $C133 ;@ u8 Sides on which Link ran into something solid this frame (set by his movement code)
DEF wLinkPushedTimer EQU $C13E ;@ u8 Frames Link keeps sliding with his speed after being bounced back (his controls do nothing meanwhile)
DEF wActivePowerUp EQU $D47C ;@ u8 1 while a Piece of Power makes Link stronger (fewer pulls to lift heavy objects), 0 otherwise
DEF wRoomEvent EQU $C18E ;@ u8 Event of the current room: low 5 bits = what triggers it, high 3 bits = what it does
DEF hSkipMusicSelection EQU $FFBC ;@ u8 Set to skip the next choice of area music after a room change (cleared when used)
DEF hNextDefaultMusicTrack EQU $FFB1 ;@ u8 Music track to start once the room transition ends (0 = keep the current one)
DEF hDefaultMusicTrackAlt EQU $FFBD ;@ u8 Track that replaces the area music (set to $49 while a Piece of Power / Acorn is active)
DEF hLastMusicTrack EQU $FFBF ;@ u8 Last music track started (the one to resume after a short tune)
DEF wIndoorAltMusic EQU $D46C ;@ u8 Nonzero: indoor rooms play track $18 instead of the map's own music (cleared on the overworld)
DEF wRestoreMusicAfterTransition EQU $C1CF ;@ u8 Set when the music must be restarted at the end of the room transition
DEF wSwordLevel EQU $DB4E ;@ u8 Sword level: 0 no sword yet, 1 sword, 2 Level-2 sword
DEF wLinkJumpSquashTimer EQU $C1C4 ;@ u8 Frames of the landing pose after a jump down a ledge
DEF hLinkPrevY EQU $FFA0 ;@ u8 Link's y position before this frame's move (restored when he runs into a wall)
DEF hLinkPrevX EQU $FF9F ;@ u8 Link's x position before this frame's move (restored when he runs into a wall)
DEF wLinkWalkingFrameCount EQU $C120 ;@ u8 Link's walking animation counter (bit 3 picks the walk frame); $FF while airborne
DEF wPegasusTurnButtons EQU $C19A ;@ u8 Direction buttons that made Link turn while dashing (the dash stops)
DEF wPegasusDustTimer EQU $C199 ;@ u8 Dust cloud timer while dashing with the Pegasus Boots
DEF wLinkGroundVfx EQU $C11F ;@ u8 Ground effect under Link this frame: 1 shallow water / tall grass ripple, 3 water, 7 sinking sand; slows the walk animation
DEF wLinkGroundVfxPrev EQU $C130 ;@ u8 wLinkGroundVfx of the previous frame
DEF wLinkSlowAnimation EQU $C117 ;@ u8 Nonzero: Link's walk animation runs every 4th frame only
DEF wIsCarryingLiftedObject EQU $C15C ;@ u8 Nonzero while Link holds a lifted object (pot, rock, ...) over his head
DEF wCarriedEntityType EQU $C5A8 ;@ u8 Entity type of the object Link carries ($D5 = the rooster)
DEF wSinkingSandCounter EQU $C1BB ;@ u8 Frames Link has stood in sinking sand (after $18 the walk animation slows down more)
DEF wPegasusBootsChargeMeter EQU $C14B ;@ u8 Charge of the Pegasus Boots while the button is held (the dash starts when full)
DEF wItemUsePoseTimer EQU $C19B ;@ u8 Bits 0-6: frames left in the pose of using an item; bit 7: the magic rod is drawn in Link's hand
DEF wIsUsingShield EQU $C15B ;@ u8 Nonzero while Link holds his shield up
DEF wShieldLevelEquipped EQU $C15A ;@ u8 Shield Link is carrying on a button: 0 none, 1 shield, 2 mirror shield (picks his walking poses)
DEF wLinkPushingTimer EQU $C144 ;@ u8 Frames Link shows the pushing pose after walking into a wall
DEF wLinkGroundType EQU $C181 ;@ u8 Collision type of the ground under Link's feet (5 shallow water, 6 hole, 7 / $0B deep water, 8 / 9 slopes, $50 / $51 sinking sand, $E0 spikes, $F0-$F7 conveyors)
DEF hObjectUnderLink EQU $FFB8 ;@ u8 Room object under Link's feet (set by the ground check)
DEF hLinkSquare EQU $FFFA ;@ u8 Index of the 16x16 square under Link's feet (high nibble row, low nibble column)
DEF hLinkSquarePrev EQU $FFFB ;@ u8 hLinkSquare of the previous frame
DEF wSpinAttackTimer EQU $C121 ;@ u8 Frames left of the spin attack (started when a fully charged sword is released)
DEF wSwordCharge EQU $C122 ;@ u8 Frames the sword button has been held (at $28 the sword is charged for a spin attack)
DEF wSwordAnimationState EQU $C137 ;@ u8 Sword swing state: 0 none, 1-3 swing frames, 4 end, 5 sword held out (charging)
DEF wSwordStateTimer EQU $C138 ;@ u8 Frames left in the current sword swing state
DEF wSwordAnimationStatePrev EQU $C16A ;@ u8 wSwordAnimationState of the previous frame
DEF wSwordPokeTimer EQU $C16D ;@ u8 Frames of the poke of a held-out sword against a wall
DEF wSwordCooldown EQU $C16E ;@ u8 Frames after a swing during which Link does not turn (set to 4 each frame of a swing)
DEF wSwordSpriteFrame EQU $C136 ;@ u8 Sword sprite frame drawn next to Link (index of the sword pose)
DEF wSwordSpriteDY EQU $C139 ;@ u8 Y offset of the sword sprite from Link
DEF wSwordSpriteDX EQU $C13A ;@ u8 X offset of the sword sprite from Link
DEF wLinkSpriteDY EQU $C13B ;@ u8 Y offset added to Link's sprite (sword swing lunge, slopes, water bobbing)
DEF wLinkSpriteDX EQU $C13C ;@ u8 X offset added to Link's sprite (sword swing lunge)
DEF wSwordHitboxX EQU $C140 ;@ u8 Sword hitbox: x of its center (0 = no hitbox)
DEF wSwordHitboxWidth EQU $C141 ;@ u8 Sword hitbox: half width
DEF wSwordHitboxY EQU $C142 ;@ u8 Sword hitbox: y of its center
DEF wSwordHitboxHeight EQU $C143 ;@ u8 Sword hitbox: half height
DEF wSwordCollisionEnabled EQU $C5B0 ;@ u8 Set while the sword hitbox may hit the room's objects (bushes, grass, walls)
DEF wSwordDirectionLocked EQU $C1AC ;@ u8 Cleared when the sword action ends
DEF wJumpAnimationFrame EQU $C152 ;@ u8 Frame of Link's jump animation (0-2)
DEF wJumpAnimationCounter EQU $C153 ;@ u8 Frame counter of the jump animation (next frame every 8 frames)
DEF wIsJumpingDownLedge EQU $C10A ;@ u8 Nonzero while Link jumps down a ledge (the jump cannot be steered)
DEF wIsSpinningInHole EQU $D475 ;@ u8 Nonzero while Link spins as he falls through a hole to the floor below
DEF wSwimStrokeTimer EQU $C183 ;@ u8 Frames left of a swimming stroke (A button): faster swimming while above $10
DEF wLinkMotionCounter EQU $C198 ;@ u8 Frame counter of Link's current scripted motion (revolving door, falling, ...)
DEF wLinkFrozen EQU $C167 ;@ u8 Nonzero while a scripted motion or effect holds Link (ocarina, falling, revolving door, ...); blocks the inventory and items
DEF wRoomTransitionDirection EQU $C125 ;@ u8 Direction of the room scroll: 0 right, 1 left, 2 up, 3 down
DEF wRoomScrollTargetX EQU $C12C ;@ u8 hBaseScrollX at which the room scroll ends
DEF wRoomScrollTargetY EQU $C12D ;@ u8 hBaseScrollY at which the room scroll ends
DEF wJingleAfterTransition EQU $C169 ;@ u8 Sound (square channel) to play once the room scroll ends
DEF wLinkPushCounter EQU $C191 ;@ u8 Frames Link has pushed against the same obstacle (doors, blocks)
DEF wBumpShakeTimer EQU $C157 ;@ u8 Frames of screen shake after dashing into a wall
DEF wBumpShakeAxis EQU $C158 ;@ u8 Axis of that shake: 0 horizontal, 4 vertical
DEF wSwordPokeCounter EQU $C1C3 ;@ u8 Frames Link has pushed the held-out sword against a wall (a poke at 12)
DEF wHoleCollisionType EQU $DBCB ;@ u8 Ground type of the hole Link fell into ($50 = sinking sand)
DEF wLinkRespawnX EQU $DBB1 ;@ u8 Link's x position where he reappears after falling into a hole or water
DEF wLinkRespawnY EQU $DBB2 ;@ u8 Link's y position where he reappears after falling into a hole or water
DEF wWarpTimer EQU $DBC8 ;@ u8 Frames before a warp started by Link's motion takes effect
DEF wSubtractHealthBuffer EQU $DB94 ;@ u8 Health still to be taken from Link (eighths of a heart), drained a little each frame
DEF wAddHealthBuffer EQU $DB93 ;@ u8 Health still to be given to Link (eighths of a heart), added a little each frame
DEF wHealth EQU $DB5A ;@ u8 Link's health in eighths of a heart
DEF wMaxHearts EQU $DB5B ;@ u8 Number of heart containers
DEF wRupeeCountHigh EQU $DB5D ;@ u8 Rupees, BCD hundreds digit
DEF wRupeeCountLow EQU $DB5E ;@ u8 Rupees, BCD tens and ones
DEF wAddRupeeBufferHigh EQU $DB8F ;@ u8 Rupees still to be added (high byte)
DEF wAddRupeeBufferLow EQU $DB90 ;@ u8 Rupees still to be added (low byte)
DEF wSubtractRupeeBufferHigh EQU $DB91 ;@ u8 Rupees still to be taken away (high byte)
DEF wSubtractRupeeBufferLow EQU $DB92 ;@ u8 Rupees still to be taken away (low byte)
DEF wHasFlippers EQU $DB0C ;@ u8 Nonzero once Link has the flippers (he can swim)
DEF wMedicineCount EQU $DB0D ;@ u8 Secret medicines carried (refill the health when Link would die)
DEF wLowHealth EQU $C163 ;@ u8 1 while Link's health is at or below the low-health threshold
DEF wLowHealthBeepTimer EQU $C110 ;@ u8 Frames until the next low-health beep
DEF hLinkInWater EQU $FFB2 ;@ u8 Nonzero while Link swims (deep water under him)
DEF wRaisedBlockStep EQU $D6F8 ;@ u8 Animation step of the raised / lowered blocks (crystal switch blocks)
DEF wLinkOnRaisedBlock EQU $D6F9 ;@ u8 Set while Link stands on a raised block
DEF wRaisedBlocksState EQU $D6FB ;@ u8 Which set of crystal-switch blocks is raised (0 or 2)
DEF wEntityHealthGroup EQU $C4D0 ;@ u8[16] Health / damage group of the entity (from EntityHealthGroupTable): picks its starting health and its row of EntityDamageClassTable
DEF wIsMarinFollowingLink EQU $DB73 ;@ u8 1 while Marin walks with Link
DEF wIsMarinInAnimalVillage EQU $DB74 ;@ u8 1 while Marin waits in Animal Village (after the Walrus is woken)
DEF wAntiKirbyInhaling EQU $D3E6 ;@ u8 Set to 1 by an Anti-Kirby while it inhales
DEF wContinueWithoutSave EQU $DBD1 ;@ u8 Set by the game over menu's "continue without saving": StartGameplay then keeps the room flags in RAM instead of reloading the saved ones (and clears it)
DEF wMusicTranspose EQU $D300 ;@ u8 Signed offset the song adds to every note byte (header byte 0, command $9F; 2 = one semitone)
DEF wMusicNoteLengths EQU $D301 ;@ u16 The song's note length table: 15 bytes, frames per length code $A0-$AE (header bytes 1-2, command $9E)
DEF wMusicReleaseFrame EQU $D307 ;@ u8[4] Per channel: the frame of the note at which channels 1-2 switch to their release envelope (set by each length code)
DEF wMusicChannel1 EQU $D310 ;@ u8[16] Music channel 1 (square 1): +0 pattern list pointer, +2 frames left of the note, +3 note length, +4 pattern pointer, +6..+8 instrument (envelope, release, duty + effect), +9 frequency, +B 1 = rest, +C loop start, +E frames since the note started, +F bit 7 = a sound effect has the channel, bits 0-6 loop count
DEF wMusicChannel2 EQU $D320 ;@ u8[16] Music channel 2 (square 2), laid out like wMusicChannel1
DEF wMusicChannel3 EQU $D330 ;@ u8[16] Music channel 3 (wave), laid out like wMusicChannel1; instrument +6..+7 = wave pattern address, +8 = output level (bit 7: drop to half 6 frames before the note ends)
DEF wMusicChannel4 EQU $D340 ;@ u8[16] Music channel 4 (noise), laid out like wMusicChannel1; +6..+A = the drum's registers (NR42, unused, NR41, NR43, NR44)
DEF wMusicChannel EQU $D350 ;@ u8 The music channel being updated (1-4)
DEF wMusicEffect EQU $D351 ;@ u8 Effect type of the channel being updated (low nibble of instrument byte +8): 1 vibrato, 5 wide vibrato, other non-zero values a fixed detune
DEF wMusicPanMode EQU $D355 ;@ u8 1 = the song's panning stays fixed; otherwise NR51 steps through four values (set to 3 when the music stops)
DEF wMusicPanTimer EQU $D356 ;@ u8 Frames since the last panning step
DEF wMusicPanPeriod EQU $D357 ;@ u8 Frames between panning steps
DEF wMusicPanStep EQU $D358 ;@ u8 Counts the panning steps; its low 2 bits pick the NR51 value
DEF wMusicPanValues EQU $D359 ;@ u8[4] The four NR51 values of the song's panning
DEF wJingleToPlay EQU $D360 ;@ u8 Square-channel sound effect to start (copied from hJingle by the main loop; cleared by the sound engine)
DEF wActiveJingle EQU $D361 ;@ u8 Square-channel sound effect playing (0 = none)
DEF wActiveMusicTrack EQU $D369 ;@ u8 Song playing, numbered inside its bank's song table (0 = none)
DEF wWaveSfxToPlay EQU $D370 ;@ u8 Wave-channel sound effect to start (copied from hWaveSfx by the main loop)
DEF wActiveWaveSfx EQU $D371 ;@ u8 Wave-channel sound effect playing (0 = none); the music leaves wave RAM alone while it is set
DEF wNoiseSfxToPlay EQU $D378 ;@ u8 Noise-channel sound effect to start (copied from hNoiseSfx; 1 = the music's own two-step drum)
DEF wActiveNoiseSfx EQU $D379 ;@ u8 Noise-channel sound effect playing (0 = none)
DEF wJingleTimer EQU $D390 ;@ u8 Frames until the square-channel effect's next step
DEF wWaveSfxTimer EQU $D392 ;@ u8 Frames until the wave-channel effect's next step
DEF wNoiseSfxTimer EQU $D393 ;@ u8 Frames until the noise-channel effect's next step
DEF wJingleStep EQU $D394 ;@ u8 Step counter of the square-channel effect
DEF wWaveSfxStep EQU $D396 ;@ u8 Step counter of the wave-channel effect
DEF wNoiseSfxStep EQU $D398 ;@ u8 Step counter of the noise-channel effect
DEF wMusicWaveDecay EQU $D39E ;@ u8 Wave channel decay after each note (command $99 on, $9A off): 1 running, 2 finished for this note
DEF wMusicWaveDecayFrame EQU $D39F ;@ u8 Frames since the wave note started, for the decay
DEF wMusicEffectFreq EQU $D3A4 ;@ u8[6] Per music channel 1-3: the frequency last written by a pitch effect (lo, hi)
DEF wMusicVibrato EQU $D3B0 ;@ u8[6] Per music channel 1-3: vibrato frame counter and 'running' flag (the vibrato starts 25 frames into the note)
DEF wMusicPitchDrop EQU $D3B6 ;@ u8[6] Per music channel 1-3: pitch drop on (command $97 on, $98 off) and 'started' flag
DEF wJingleLocked EQU $D3C6 ;@ u8 While set, new square-channel effects (except 1) are ignored
DEF wWaveSfxLocked EQU $D3C8 ;@ u8 While set, new wave-channel effects (except $14) are ignored
DEF wNoiseSfxLocked EQU $D3C9 ;@ u8 While set, new noise-channel effects are ignored
DEF wMusicTrackStarted EQU $D3CA ;@ u8 The music request number of the song started last
DEF wMusicTrackStartedBefore EQU $D3CB ;@ u8 The one before it
DEF wMusicBlocksWaveSfx EQU $D3CD ;@ u8 Set by the song (command $96, cleared by $95): wave-channel effects are not played meanwhile
DEF wMusicFromBank1B EQU $D3CE ;@ u8 1 while the song comes from bank $1B; bank $1E's engine plays (and updates) the song when it is 0
DEF wMusicWideVibrato EQU $D3D0 ;@ u8[6] Per music channel 1-3: frame counter of the wide vibrato (effect 5, bank $1B only)
DEF wMusicWaveSwell EQU $D3D9 ;@ u8 Wave channel swell after each note (command $94): 1 running, 2 finished
DEF wMusicWaveSwellFrame EQU $D3DA ;@ u8 Frames since the wave note started, for the swell
DEF wWaveRamDirty EQU $D3E7 ;@ u8 Set when a wave-channel effect ends: the music loads its wave pattern again at its next note
DEF wMusicSpeed EQU $C10B ;@ u8 0 = normal; 1 = the music is updated twice a frame; 2 = only every other frame
DEF hTileSwapFinishCount EQU $FFBB ;@ u8 VBlanks that still advance the tile swap sequence after a room transition (set to 2)
DEF wRoomEntitySetupDone EQU $C116 ;@ u8 Cleared when a room loads; a room's special character sets it after its one-time setup
DEF wSongShowTimer EQU $D210 ;@ u16 Frames since the start of a song performance (Mamu's song, Manbo's dance)
DEF wSongShowStepTimer EQU $D212 ;@ u8 Frames into the current step of a song performance's dance
DEF wSongShowStep EQU $D213 ;@ u8 Current step of a song performance's dance (index into the frame tables)
DEF wSongShowPlaying EQU $D215 ;@ u8 Nonzero while Mamu's song plays (the frogs then take their frames from Mamu)
DEF hBGPosY EQU $FFCD ;@ u8 Y position (pixels, before scrolling) whose background map address GetBGAddress computes
DEF hBGPosX EQU $FFCE ;@ u8 X position (pixels, before scrolling) whose background map address GetBGAddress computes
DEF hBGAddrHigh EQU $FFCF ;@ u8 Background map address computed by GetBGAddress, high byte
DEF hBGAddrLow EQU $FFD0 ;@ u8 Background map address computed by GetBGAddress, low byte
DEF hMultiPurpose4 EQU $FFDB ;@ u8 Scratch byte 4 (meaning depends on the routine)
DEF hMultiPurpose5 EQU $FFDC ;@ u8 Scratch byte 5
DEF hMultiPurpose6 EQU $FFDD ;@ u8 Scratch byte 6
DEF hMultiPurpose7 EQU $FFDE ;@ u8 Scratch byte 7
DEF hMultiPurpose8 EQU $FFDF ;@ u8 Scratch byte 8
DEF hMultiPurpose9 EQU $FFE0 ;@ u8 Scratch byte 9
DEF hMultiPurposeA EQU $FFE1 ;@ u8 Scratch byte A
DEF hMultiPurposeB EQU $FFE2 ;@ u8 Scratch byte B
DEF hMultiPurposeC EQU $FFE3 ;@ u8 Scratch byte C
DEF wArrowCooldown EQU $C14C ;@ u8 Frames before the bow can shoot again
DEF wBombArrowWindow EQU $C1C0 ;@ u8 Frames during which a bomb and an arrow combine into a bomb arrow
DEF wOcarinaNoteTimer EQU $C5A4 ;@ u8 Frame counter of Link's ocarina playing animation (wraps at $38)
DEF wOcarinaNotePhase EQU $C5A5 ;@ u8 Which way Link sways while playing the ocarina (0 / 1; flips every $38 frames)
DEF wOcarinaEndEffect EQU $C5A3 ;@ u8 Set to 3 when an ocarina song ends
DEF wLinkPoseLock EQU $C111 ;@ u8 Nonzero while Link keeps a special pose (ocarina, opened door, ...)
DEF wLinkOnPlatform EQU $C147 ;@ u8 Nonzero while Link stands on a moving platform (a boat, a lift)
DEF wDungeonFlags EQU $DB65 ;@ u8[8] Progress flags of each dungeon (index = indoor map id 0-7): bit 0 = its warp is open, bit 1 = its instrument obtained
DEF wRoomEventDone EQU $C18F ;@ u8 Set once the room's event has happened (enemies beaten, ...): the shutters open and stay open
DEF wBossMusicStarted EQU $C1BD ;@ u8 Set once the boss music has been started after wBossMusicDelay ran out
DEF wBossInRoom EQU $C1BE ;@ u8 1 while a boss or mini-boss (entity option bit 7) is loaded in the room
DEF wBossMusicDelay EQU $C165 ;@ u8 Frames left before the boss music starts (set to $20 when a boss is loaded)
DEF wShieldLevel EQU $DB44 ;@ u8 Shield Link owns: 0 none, 1 shield, 2 Mirror Shield
DEF wFinalNightmareForm EQU $D219 ;@ u8 Form of the final boss (type $E6), 0 at the start of the fight
DEF wTransitionDrawHigh EQU $C126 ;@ u8 BG map address (high byte - $98, 0-3) of the next strip of the new room to draw
DEF wTransitionDrawLow EQU $C127 ;@ u8 BG map address (low byte) of the next strip of the new room to draw
DEF wTransitionStripLength EQU $C128 ;@ u8 Objects per strip of the room scroll (8 for a column, 10 for a row); also the loop counter
DEF wTransitionStripsLeft EQU $C129 ;@ u8 Strips of the new room still to draw during the room scroll
DEF wTransitionObjectIndex EQU $C12A ;@ u8 Index in wRoomObjects of the first object of the next strip to draw
DEF wTransitionDrawDelay EQU $C12B ;@ u8 Frames to wait before drawing the next strip of the room scroll
DEF hLeverPullState EQU $FFBA ;@ u8 The lever (entity $69) Link pulls: 0 not held, 1 pulled further this frame, 2 held still
DEF wFloorSwitchPressedTimer EQU $C1CB ;@ u8 Set to $60 when Link has stood on a floor switch (object $AA) long enough; counts down
DEF wFloorSwitchStandFrames EQU $C1CA ;@ u8 Frames Link has stood on a floor switch (object $AA); at $18 it is pressed
DEF wSmasherBallSlot EQU $D201 ;@ u8 Slot of the Smasher's iron ball
DEF wSmasherSlot EQU $D202 ;@ u8 Slot of the Smasher (the ball checks hits against it)
DEF wEntityLiftStep EQU $C490 ;@ u8[16] Step of the lift animation while Link picks the entity up (reset to 0 when he starts)
DEF wActiveProjectileCount EQU $C14D ;@ u8 Number of Link's projectiles (boomerang, sword beams) out this frame; their handlers count themselves in
DEF wProjectileWeaponType EQU $C19E ;@ u8 Kind of weapon a projectile of Link's hits enemies with, set before the hit check (1 sword beam, 8 boomerang)
DEF wLinkShowItemPose EQU $C1A9 ;@ u8 Link holds something up over his head (kind 1-6, 0 = no); the kind's text (table at $0C3A) opens when wLinkShowItemTimer reaches 2
DEF wLinkShowItemTimer EQU $C1AA ;@ u8 Frames left of Link's item-showing pose
DEF wLinkShowItemPoseActive EQU $C1A8 ;@ u8 Copy of wLinkShowItemPose while the pose runs (characters wait while it is set)
DEF wHasToadstool EQU $DB4B ;@ u8 1 while Link carries the Sleepy Toadstool (it takes the magic powder's place, item $0C)
DEF wMagicPowderCount EQU $DB4C ;@ u8 Magic powder doses left (BCD)
DEF wClinkTimer EQU $C502 ;@ u8 Set to 4 when the sword clinks on something hard; counts down every frame (some enemies react while it runs)
DEF wVfxType EQU $C510 ;@ u8[16] Transient visual effect in each of the 16 effect slots (dust, splash, clink star, ...; 0 = free)
DEF wVfxTimer EQU $C520 ;@ u8[16] Frames each visual effect still shows (starts at $0F)
DEF wVfxX EQU $C530 ;@ u8[16] X position of each visual effect
DEF wVfxY EQU $C540 ;@ u8[16] Y position of each visual effect
DEF wVfxReplaceSlot EQU $C5C0 ;@ u8 Effect slot that is overwritten next when all 16 are busy (counts down from $0F)
DEF wNoEventJingle EQU $C19D ;@ u8 Nonzero: the room's event happens without the chime
DEF wRoomEventJustDone EQU $C5A6 ;@ u8 Set when the room's event has just happened (read and cleared by Link's code in bank 2)
DEF wDungeonItemFlags EQU $DB16 ;@ u8[45] Saved item flags of each map 0-8, five bytes per map: map, compass, stone beak, nightmare key, small keys (the current dungeon's copy is wDungeonHasMap..wDungeonSmallKeys)
DEF wDungeonHasMap EQU $DBCC ;@ u8 1 when Link has the current dungeon's map (copied from / back to wDungeonItemFlags)
DEF wDungeonHasCompass EQU $DBCD ;@ u8 1 when Link has the current dungeon's compass
DEF wDungeonHasStoneBeak EQU $DBCE ;@ u8 1 when Link has the current dungeon's stone beak
DEF wDungeonHasNightmareKey EQU $DBCF ;@ u8 1 when Link has the current dungeon's nightmare key
DEF wDungeonSmallKeys EQU $DBD0 ;@ u8 Number of small keys Link carries in the current dungeon
DEF wMinimapLayout EQU $DBB0 ;@ u8 Minimap layout of the current map (from MapMinimapLayouts; non-zero only in Eagle's Tower)
DEF wCompassChimeDelay EQU $D462 ;@ u8 Frames until the compass chime plays (set on entering a room whose key has not been taken yet, with the compass)
DEF wGelCount EQU $C1AE ;@ u8 Number of Gels handled this frame (each Gel adds itself; cleared every frame)
DEF wEntityHitbox EQU $D580 ;@ u8[64] Hitbox of each entity, 4 bytes per slot: x offset, half width, y offset, half height (pixels, from the entity position)
DEF wManboSplashTimer EQU $D214 ;@ u8 Frames left of the big splash near the end of Manbo's dance (the fishes jump and spray water)
DEF wSongShowSpare EQU $D217 ;@ u8 Cleared with the song performance variables; otherwise unused here
DEF wSongShowCountdown EQU $D218 ;@ u8 Counted down by Manbo while nonzero; cleared with the song performance variables
DEF wIndoorRoom EQU $DBAE ;@ u8 Link's room on the map grid of the current dungeon (row in bits 3-5, column in bits 0-2)
DEF wMinimapLinkCell EQU $D46B ;@ u8 Copy of wIndoorRoom: the cell where the dungeon map's blinking marker is drawn
DEF wRandomSeed EQU $C13D ;@ u8 The last random byte (GetRandomByte mixes it with the frame counter and rLY)
DEF hSavedIE EQU $FFD2 ;@ u8 rIE saved by DisableLCD while it waits for VBlank
DEF wBombsOnScreen EQU $C14E ;@ u8 Bombs on screen: recounted every frame (Link can lay one at a time)
DEF wHookshotInUse EQU $C1A4 ;@ u8 Set every frame while the hookshot is out (Link cannot use it again)
DEF wTradeSceneState EQU $DB7F ;@ u8 Progress of a trading-sequence scene: 1 the fisherman got the hook, 2 Tarin knocked the honeycomb down
DEF wTarinSlot EQU $D204 ;@ u8 Slot of Tarin in the honeycomb scene (the bees fly around him)
DEF wSaveSlotNames EQU $DB80 ;@ u8[15] Names of the three save files (5 characters each), read from battery RAM for the file menus
DEF wSaveSlotDeathCounts EQU $DC00 ;@ u8[6] Death counters of the three save files for the file menu, two bytes each (BCD tens/ones, then hundreds)
DEF wSaveSlotHealth EQU $DC06 ;@ u8[3] Health of each save file (eighths of a heart), for the file menu hearts
DEF wSaveSlotMaxHearts EQU $DC09 ;@ u8[3] Heart containers of each save file, for the file menu
DEF wFileSelectMusicPending EQU $D47B ;@ u8 Set when the file menu is entered from the intro: the menu's first step then starts the file menu music
DEF wSpawnIsIndoor EQU $DB5F ;@ u8 Saved restart point (where a loaded file starts): bit 0 = indoors
DEF wSpawnMapId EQU $DB60 ;@ u8 Saved restart point: map (hMapId)
DEF wSpawnRoom EQU $DB61 ;@ u8 Saved restart point: room (hMapRoom)
DEF wSpawnX EQU $DB62 ;@ u8 Saved restart point: Link's x position (0 = no restart point saved yet: a new game)
DEF wSpawnY EQU $DB63 ;@ u8 Saved restart point: Link's y position
DEF wSpawnIndoorRoom EQU $DB64 ;@ u8 Saved restart point: position in the dungeon's minimap grid (copied to $DBAE)
DEF wArrowCount EQU $DB45 ;@ u8 Arrows carried (BCD)
DEF wBombCount EQU $DB4D ;@ u8 Bombs carried (BCD)
DEF wMaxMagicPowder EQU $DB76 ;@ u8 Magic powder capacity (BCD; $20 at the start, $40 after the upgrade)
DEF wMaxBombs EQU $DB77 ;@ u8 Bomb capacity (BCD; $30 at the start, $60 after the upgrade)
DEF wMaxArrows EQU $DB78 ;@ u8 Arrow capacity (BCD; $30 at the start, $60 after the upgrade)
DEF wBoomerangTradedItem EQU $DB7D ;@ u8 Item Link gave the Goriya for the boomerang (0 = never traded, $0D = traded back again)
DEF wEntityPitX EQU $C4B0 ;@ u8[16] X of the pit the entity falls into (status 2 pulls it towards this point)
DEF wEntityPitY EQU $C4C0 ;@ u8[16] Y of the pit the entity falls into
DEF wIronBallRoom EQU $DB6F ;@ u8 Room where the heavy ball (entity type $A8) lies; set back to room $16 when it falls into a pit
DEF wIronBallX EQU $DB70 ;@ u8 X position of the heavy ball in wIronBallRoom
DEF wIronBallY EQU $DB71 ;@ u8 Y position of the heavy ball in wIronBallRoom
DEF wNoiseSfxCycle EQU $C5AC ;@ u8 Counts 0-$19 over and over (bank $14); PlayPeriodicNoiseSfx only plays when it is 0
DEF wSaveSlot EQU $DBA6 ;@ u8 The save file being used or pointed at in the file menus (0-2; 3 = the bottom row)
DEF wSaveFilesExist EQU $DBA7 ;@ u8 Bit i set when save file i has a name (bit 0 file 1, bit 1 file 2, bit 2 file 3)
DEF wTarinState EQU $DB48 ;@ u8 Tarin's story state: 0 at home (he leaves once Link has a sword), 1 cured from the raccoon spell (sleeps at home), 2 after a later event
DEF wRaccoonLoopsExit EQU $C10C ;@ u8 Set by the raccoon in the forest when Link walks up past it: the next exit upwards brings him back with the confusion jingle
DEF hAnimatedTilesFrameCount EQU $FFA6 ;@ u8 Frame counter of the animated background tiles (water, flowers, ...); 0 restarts them
DEF hAnimatedTilesStep EQU $FFA7 ;@ u8 Animation step of the animated background tiles
DEF wDungeon7Flags EQU $DB6B ;@ u8 Flags of dungeon 7 (map 6); bit 2: its rooms use the second layout (the table at $14:$44C0)
DEF wMarinSinging EQU $C3C8 ;@ u8 Set while Marin sings in Animal Village (the animals there gather and listen)
DEF wSavedLinkMotionState EQU $D463 ;@ u8 Link's motion state saved when a warp starts
DEF wSongListenerType EQU $D465 ;@ u8 Entity type of the character that plays along with Link's ocarina ($47: cannot be interrupted)
DEF wSongListenerSlot EQU $D461 ;@ u8 Entity slot of that character (its state is reset when the performance ends)
DEF wIsGhostFollowingLink EQU $DB79 ;@ u8 Set while the ghost follows Link (entity tile slot 0 then holds its tiles, set $D8)
DEF wIsRoosterFollowingLink EQU $DB7B ;@ u8 Set while the flying rooster follows Link (entity tile slot 0 then holds its tiles, set $DD)
DEF wMoblinKingFacing EQU $D227 ;@ u8 Side the Moblin King faces (0 right, 1 left); picks his head sprites
DEF wMoblinKingHeadFrame EQU $D228 ;@ u8 Head frame of the Moblin King (0 or 1, 1 = head bobbed up); $FF = no separate head (his whole-body poses)
DEF wSingingMarinSlot EQU $C50F ;@ u8 Entity slot of Marin while she sings in Animal Village (set by her handler)
DEF wNameEntryCursor EQU $DBA9 ;@ u8 Name entry: place of the letter cursor in the 4 x 16 letter grid (0-63)
DEF wNameEntryPosition EQU $DBAA ;@ u8 Name entry: position in the name where the next letter goes (0-4)
DEF wDpadRepeatCounter EQU $C182 ;@ u8 Frames a D-pad direction has been held in the menus; at $18 the press repeats (and it restarts from $15)
DEF wSelectHeldFrames EQU $D45F ;@ u8 Frames the Select button has been held alone (at 4 the world map opens)
DEF wDigState EQU $C1C7 ;@ u8 Shovel: 1 while Link digs, 2 once the square was dug up (0 = not digging)
DEF wDigCounter EQU $C1C8 ;@ u8 Frame counter of the digging animation (the square is dug at $10, the dig ends at $18)
DEF hStairsState EQU $FFAC ;@ u8 Staircase that appeared in the room: 0 none, 1 waiting for Link to step off it, 2 armed (stepping on it warps)
DEF hStairsX EQU $FFAD ;@ u8 X position of that staircase
DEF hStairsY EQU $FFAE ;@ u8 Y position of that staircase
DEF wRaftRented EQU $D477 ;@ u8 Set ($F1) once Link has paid the raft shop owner; cleared when he boards the raft
DEF wRoomLoadCounter EQU $D47F ;@ u8 Counts up every time a room is loaded
DEF wRoomDoorCount EQU $C19C ;@ u8 Number of entrance positions recorded in the list at wWarpDestPosition while the room loads
DEF hAnimatedTilesGroup EQU $FFA4 ;@ u8 Which animated background tiles the room uses (first byte of its object data)
DEF wRoomShutterDoors EQU $C18A ;@ u8 Shutter doors of the room (bits 0-3: top, bottom, left, right), noted while it loads
DEF wRoomShutterDoorsCopy EQU $C18B ;@ u8 Copy of wRoomShutterDoors made while the room loads
DEF wDoorPosition EQU $C1F0 ;@ u8[16] Room position (row<<4 | column) of each door of the room (slot = kind of door, 0-8)
DEF wDoorY EQU $C1E0 ;@ u8[16] Y (pixels, without the status bar) of each door of the room
DEF wDoorX EQU $C1D0 ;@ u8[16] X (pixels) of each door of the room
DEF wDefeatedEntityCount EQU $DBB5 ;@ u8 Number of entries in wDefeatedEntities (cleared when a dungeon room loads)
DEF wDefeatedEntities EQU $DBB6 ;@ u8[16] Room list positions of the entities defeated in the current room
DEF wRoomDefeatedEntityBits EQU $CF00 ;@ u8[256] Per room number: bit n set = entity n of the room's list was defeated and is not loaded again
DEF wFollowerTrailX EQU $D155 ;@ u8[16] Link's last 16 x positions, which a follower (Marin, Bow-Wow, ...) walks along
DEF wFollowerTrailY EQU $D175 ;@ u8[16] Link's last 16 y positions for the follower trail
DEF wFollowerTrailZ EQU $D195 ;@ u8[16] Link's last 16 heights for the follower trail
DEF wFollowerTrailDir EQU $D1B5 ;@ u8[16] Link's last 16 facing directions for the follower trail (the follower faces the same way)
DEF wFaceShrineHint EQU $DB7C ;@ u8 The random hint of the library's secret book ($00, $08, $10 or $18; bits 3-4 choose one of four texts), drawn once
DEF wMapScreenFromBook EQU $C5A2 ;@ u8 Set when a library book opened the map screen (game mode 7)
DEF wDebugWarpIndex EQU $D479 ;@ u8 Next destination of the (disabled) B + Select debug warp, 0-10
DEF wRestartMusicTimer EQU $C5AF ;@ u8 Frames until the last music track (hLastMusicTrack) is started again
DEF wVfxDirection EQU $C590 ;@ u8[16] Direction / variant of each visual effect (picks its sprites or speeds)
DEF hRandomPattern EQU $FFB9 ;@ u8 Random number 0-3 picked when the overworld map is loaded (chooses the path of the glinting tiles)
DEF wMarinReunion EQU $DB10 ;@ u8 Set by bank 2 (to wLowHealth + 1) before a fade-out; while nonzero the following Marin walks up to Link and speaks, then it is cleared
DEF wMarinReunionTimer EQU $D468 ;@ u8 Countdown between the steps of the following Marin's walk to Link (MarinReunionStates)
DEF wDebugDialogIndex EQU $C109 ;@ u8 Dialogue number chosen with the joypad in the text debugger (entity $6B)
DEF wEvilEagleAttack EQU $D205 ;@ u8 The Evil Eagle's next attack (0 swoop, 1/4 drop from above, 2/3 fly across and blow)
DEF wEvilEagleFightStarted EQU $D478 ;@ u8 Nonzero once the fight on top of Eagle's Tower has begun (set to 2)
DEF wSignpostMazeStep EQU $D472 ;@ u8 How many signs of the signpost maze Link has read in the right order (0-13)
DEF wSignpostReadPos EQU $D473 ;@ u8 Position (row and column nibbles) of the sign Link just read; 0 once handled
DEF wDoorAnimation EQU $C188 ;@ u8 Door animation running: 0 none, 1 a door opens, 2 a shutter closes
DEF wDoorAnimIndex EQU $C189 ;@ u8 Door being animated (0-3 locked doors, 4-7 shutters, 8 boss door)
DEF wOpenShuttersRequest EQU $C18C ;@ u8 Nonzero: open the room's shutter doors one after another
DEF wCloseShuttersRequest EQU $C18D ;@ u8 Nonzero: close the room's shutter doors one after another
DEF wDoorAnimFrame EQU $DBAC ;@ u8 Frame counter of the door animation
DEF wDashBumpFrames EQU $C178 ;@ u8 Frames left in which entities react to the point Link dashed into (set to 2)
DEF wDashBumpX EQU $C179 ;@ u8 X of the point in front of Link that a dash into a wall shakes
DEF wDashBumpY EQU $C17A ;@ u8 Y of that point
DEF wLinkOAMAttrLeft EQU $C11D ;@ u8 OAM attributes of the left half of Link's sprite (flip bits from LinkPoseAttributes; bit 7 = behind the background)
DEF wLinkOAMAttrRight EQU $C11E ;@ u8 OAM attributes of the right half of Link's sprite
DEF wLinkFlashAttr EQU $C135 ;@ u8 Palette bit ($10) ORed into Link's sprites; blinks while he is invincible
DEF wBombArrowBombSlot EQU $C1C1 ;@ u8 Slot of the bomb laid last (an arrow shot within wBombArrowWindow takes it along)
DEF wBombArrowArrowSlot EQU $C1C2 ;@ u8 Slot of the arrow shot last (a bomb laid within wBombArrowWindow joins it)
DEF wShopItemCarried EQU $C509 ;@ u8 Shop item Link carries without having paid (0 = none); leaving the shop with it makes him a thief
DEF wShowThiefMessage EQU $D47E ;@ u8 Set when Link left the shop with an item he did not pay for: the next fade-in opens dialogue $36
DEF wOverworldRoom EQU $DB54 ;@ u8 The overworld room Link is in, or was last in before going indoors (his position on the map screen)
DEF wWorldMapCursor EQU $DBB4 ;@ u8 Map screen: the room the cursor is on (high nibble row, low nibble column)
DEF wWorldMapMarkerFrame EQU $C1B0 ;@ u8 Map screen: animation frame of the place marker popup (0 = fully shown, 1-3 growing / shrinking)
DEF wWorldMapMarkerType EQU $C1B1 ;@ u8 Map screen: kind of place marker shown (0 none, 1-5 = icon of WorldMapMarkerIcons)
DEF wWorldMapMarkerAppearTimer EQU $C1B2 ;@ u8 Map screen: counts down while a place marker pops up
DEF wWorldMapMarkerHideTimer EQU $C1B3 ;@ u8 Map screen: counts down while a place marker disappears
DEF wWorldMapMarkerRoom EQU $C1B4 ;@ u8 Map screen: the room whose place marker is shown (decides the corner of the popup)
DEF wDelayedWaveSfxTimer EQU $C5A7 ;@ u8 Frames until wave sound effect $10 plays (counted down by UpdateEntities; 0 = none)
DEF wClashBoxX EQU $D5C0 ;@ u8 X offset (from the entity) of the box where Link's sword clashes with it instead of hurting it ($80 = none yet)
DEF wClashBoxHalfWidth EQU $D5C1 ;@ u8 Half width of the sword clash box
DEF wClashBoxY EQU $D5C2 ;@ u8 Y offset (from the entity) of the sword clash box
DEF wClashBoxHalfHeight EQU $D5C3 ;@ u8 Half height of the sword clash box
DEF wEntityWorkRAM3 EQU $D200 ;@ u8[256] Third work area (the Desert Lanmola's trail of heights, ...); its first bytes also serve as single variables (wSmasherBallSlot, ...)
DEF wLanmolaHoleX EQU $C1CD ;@ u8 X of the hole the Desert Lanmola came out of / dives into (sand spurts from it)
DEF wLanmolaHoleY EQU $C1CE ;@ u8 Y of the Desert Lanmola's hole
DEF wRoomEventShuttersClosed EQU $C190 ;@ u8 Nonzero once a room event has closed the shutters behind Link (they open when its trigger fires)
DEF wRoomEventCounter EQU $C1A2 ;@ u8 Counter that room event trigger 5 waits for (two torches lit); cleared when a room loads
DEF wMonkeysLeaving EQU $C168 ;@ u8 Set (to $63) when Kiki's monkeys have finished the bridge and run off
DEF wFinalNightmareHidden EQU $D21A ;@ u8 1 while the final boss's main body is not shown (between forms, while it teleports); hits are then ignored
DEF wFinalNightmareTargetX EQU $D21B ;@ u8 X position the final boss moves to (Agahnim's shadow teleporting)
DEF wFinalNightmareTargetY EQU $D21C ;@ u8 Y position the final boss moves to
DEF wFinalNightmareHits EQU $D220 ;@ u8 Hits the current form of the final boss has taken (powder on the gel, reflected balls on Agahnim's shadow, ...)
DEF hActiveEntityTileOffset EQU $FFF5 ;@ u8 Added to the tile numbers of the entity being drawn (cleared for every entity)
DEF wHeartPieces EQU $DB5C ;@ u8 Pieces of heart collected towards the next heart container (0-3; the fourth turns into a container)
DEF wKeyItemFlags EQU $DB11 ;@ u8[4] Set when Link gets the key of variant 1-4 of type $30 (Tail, Angler, Face, Bird Key)
DEF wLiftPullCounter EQU $C15F ;@ u8 Frames Link has pulled at an object with the Power Bracelet
DEF wRecentRoomsIndex EQU $CE80 ;@ u8 Slot of wRecentRooms that was filled last (0-5)
DEF wRecentRooms EQU $CE81 ;@ u8[6] The last six rooms entered; a room dropped from this list forgets its defeated enemies (wRoomDefeatedEntityBits)
DEF wPodobooCount EQU $C5A0 ;@ u8 Podoboos in the air this frame (each counts itself; cleared every frame)
DEF wPodobooCountPrev EQU $C5A1 ;@ u8 wPodobooCount of the previous frame (at most 2 podoboos leap at once)
DEF wHasInstrument2 EQU $DB66 ;@ u8 Progress flags of the second dungeon (Bottle Grotto); bit 1 set once its instrument is obtained
DEF wInventorySlideSpeed EQU $C150 ;@ s8 Pixels the window moves per frame while the inventory slides: -8 up (opening), +8 down (closing)
DEF wInventoryStaticDrawn EQU $C151 ;@ u8 Nonzero once the fixed parts of the sliding inventory are queued for drawing
DEF wInventoryRowsToDraw EQU $C154 ;@ u8 Inventory rows still to be drawn while it slides in (counts down from 11)
DEF wRupeeCountDelay EQU $C3CE ;@ u8 Frames before the rupee counter starts counting (set when a chest gives rupees)
DEF wSongMenuShown EQU $C1B5 ;@ u8 Nonzero while the ocarina song menu is shown in the inventory
DEF wSongMenuOpenTimer EQU $C1B8 ;@ u8 Frames left of the song menu opening
DEF wSongMenuCloseTimer EQU $C1B9 ;@ u8 Frames left of the song menu closing
DEF wSeashells EQU $DB0F ;@ u8 Secret seashells found (BCD, up to $99)
DEF wTowerPillarsDestroyed EQU $DB72 ;@ u8 How many of the pillars in Eagle's Tower (dungeon 7) have been destroyed (4 = the tower collapses)
DEF wHookshotOut EQU $C1C6 ;@ u8 2 while the hookshot is out, 0 once it is back at Link
DEF wRoomDarkness EQU $C3CD ;@ u8 How dark the room is drawn ($0C dark); each lit torch takes 4 off, each torch going out adds 4
DEF wUnusedSfxTimer EQU $D391 ;@ u8 A fourth effect timer between the square and wave ones; only ever cleared
DEF wUnusedSfxStep EQU $D395 ;@ u8 A fourth effect step counter; only ever cleared
DEF wSoundUnusedA0 EQU $D3A0 ;@ u8 Cleared when sounds stop and when a square-channel effect ends; nothing reads it
DEF wSoundUnusedA1 EQU $D3A1 ;@ u8 Cleared when sounds stop; nothing reads it
DEF wSoundUnusedA2 EQU $D3A2 ;@ u8 Cleared when sounds stop; nothing reads it
DEF wSoundUnusedA3 EQU $D3A3 ;@ u8 Cleared when a song starts and when sounds stop; nothing reads it
DEF wJingleRepeat EQU $D3BC ;@ u8 Repeat counter of the square-channel effect: set by its start, counted down by CountDownJingleRepeat each time its steps run through
DEF wUnusedSfxRepeat EQU $D3BD ;@ u8 A fourth effect repeat counter (CountDownSfxRepeat2); nothing sets it
DEF wWaveSfxRepeat EQU $D3BE ;@ u8 Repeat counter of the wave-channel effect (counted down by CountDownWaveSfxRepeat)
DEF wNoiseSfxRepeat EQU $D3BF ;@ u8 Repeat counter of the noise-channel effect (counted down by CountDownNoiseSfxRepeat); cleared when it ends
DEF wJingleFreq EQU $D3C0 ;@ u16 Square 1 frequency of the effect while it slides (the NR13 / NR14 value; SaveSquare1Freq, SlideSquare1)
DEF wSquare2SfxFreq EQU $D3C2 ;@ u16 Square 2 frequency of an effect while it slides (SaveSquare2Freq, SlideSquare2)
DEF wWaveSfxFreq EQU $D3C4 ;@ u16 Wave channel frequency of the effect while it slides (SaveWaveFreq, SlideWave)
DEF wUnusedSfxLocked EQU $D3C7 ;@ u8 A fourth effect lock flag; only ever cleared
DEF wSoundUnusedD8 EQU $D3D8 ;@ u8 Cleared when sounds stop; nothing reads it
DEF wJingleSubStep EQU $D3E2 ;@ u8 A second step counter some square-channel effects use; cleared when one starts
DEF wSoundUnusedE3 EQU $D3E3 ;@ u8 Cleared when sounds stop; nothing reads it
DEF wSoundUnusedE4 EQU $D3E4 ;@ u8 Cleared when sounds stop; nothing reads it
DEF wSoundUnusedE5 EQU $D3E5 ;@ u8 Cleared when the music starts or sounds stop; nothing reads it
DEF wHealthIsFull EQU $C5A9 ;@ u8 1 while Link's hearts are full (updated every frame)
DEF wTracyMedicineSales EQU $DB75 ;@ u8 Crazy Tracy's sales of the secret medicine, counted 0-7 (her eighth sale is special)
DEF wKillCounter EQU $D415 ;@ u8 Enemies defeated since the counter was last reset (a Piece of Power drops at a limit; Crazy Tracy's price depends on it)
DEF wLiftableObjectSlot EQU $C50C ;@ u8 Slot of the liftable object (rock, pot) handled last
DEF wInventoryItems EQU $DB02 ;@ u8[10] Items in the 10 inventory slots (two per row), after wItemB and wItemA
DEF wInventoryCursor EQU $DBA3 ;@ u8 Selected inventory slot (0-9)
DEF wInventoryCursorPrev EQU $C1B6 ;@ u8 wInventoryCursor at the start of the frame
DEF wInventoryCursorBlink EQU $C159 ;@ u8 Frame counter that blinks the inventory selector (hidden while bit 4 is set)
DEF wCloseInventoryAfterSongMenu EQU $C1BA ;@ u8 Set by Start in the song menu: close the inventory once the song menu has closed
DEF wNightmareChargeFrame EQU $D21D ;@ u8 Final boss: frame + 1 of the ball Agahnim's shadow charges in its hand (0 = none drawn)
DEF wNightmareFacing EQU $D21E ;@ u8 Final boss: direction of the current form toward Link (0 right, 1 left, 2 up, 3 down)
DEF wSfxFastVariant EQU $D3D6 ;@ u8 Set by Moldorm (and the bank $15 boss built like it) while it moves fast: square effect $38 and noise effect $1B then play their fast variant
DEF wJingle22Count EQU $D3D7 ;@ u8 How many times square effect $22 has started in a row; picks its pitch (1-12, then over again)
DEF wWaveSfx1ECount EQU $D3DC ;@ u8 Rounds left of wave effect $1E
DEF wWaveSfx1FCount EQU $D3DD ;@ u8 Round counter of wave effect $1F (it requests music track $59 after its last round)
DEF wWaveSfx20Count EQU $D3DE ;@ u8 Rounds left of wave effect $20
DEF wNoiseSfx34CountA EQU $D3DF ;@ u8 Repeats left of the first loop of noise effect $34
DEF wNoiseSfx34CountB EQU $D3E0 ;@ u8 Repeats left of the second loop of noise effect $34
DEF wWaveSfx22Count EQU $D3E1 ;@ u8 Round counter of wave effect $22
DEF wHoldNoiseSfx3E EQU $D3E8 ;@ u8 While set (by the Slime Eel), noise effect $3E holds its current step
DEF wRoomNoiseLoop EQU $C50E ;@ u8 Set ($E9) by a room with overworld object $E9; while set, noise effect $1E starts again whenever no noise effect plays
