; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01e", ROMX[$4000], BANK[$1e]

;@ def MusicEntryInit_1E()
;@ path: sound/music/engine
;@ Entry point $4000 of this music bank (InitMusic_1E). Not used: bank $1F sets the sound hardware up.
;@ test: skip resets the whole sound state
MusicEntryInit_1E::
;> return InitMusic_1E()
	jp InitMusic_1E


;@ def MusicEntrySilence_1E()
;@ path: sound/music/engine
;@ Entry point $4003 of this music bank (SilenceMusicAndNoise_1E). Not used: bank $1F stops the sound.
;@ test: skip changes the sound hardware
MusicEntrySilence_1E::
;> return SilenceMusicAndNoise_1E()
	jp SilenceMusicAndNoise_1E


;@ def MusicEntryUpdate_1E()
;@ path: sound/music/engine
;@ Entry point $4006 of this music bank, called once a frame by UpdateMusic while one of its songs plays:
;@ plays the music on (UpdateMusic_1E).
;@ test: skip plays the music through its tables
MusicEntryUpdate_1E::
;> return UpdateMusic_1E()
	jp UpdateMusic_1E


;@ def InitMusic_1E()
;@ path: sound/music/engine
;@ Clears the sound RAM $D300-$D3FF and switches the sound hardware on: master volume 7 on both sides,
;@ every channel to both speakers.
InitMusic_1E::
;> fill(0xD300, 0, 0x100)                   # all of the sound RAM
	ld hl, wMusicTranspose
.clear
	ld [hl], $00
	inc l
	jr nz, .clear
;> rNR52 = 0x80                              # sound on
	ld a, $80
	ldh [rNR52], a
;> rNR50 = 0x77                              # full volume left and right
	ld a, $77
	ldh [rNR50], a
;> rNR51 = 0xFF                              # all channels on both sides
	ld a, $ff
	ldh [rNR51], a
	ret

;@ def UpdateMusic_1E()
;@ path: sound/music/engine
;@ Bank $1E's music engine for one frame (entry $4006, called by UpdateSound after bank $1B's). A request
;@ in wMusicTrackToPlay is started unless bank $1B has taken it (StartMusicRequest_1E); without a request
;@ the music's two-step drum moves on. Then the song plays one frame if it is this bank's, and all sound
;@ requests of the frame are cleared.
;@ test: skip runs the whole music engine
UpdateMusic_1E::
;> request = wMusicTrackToPlay
	ld hl, wMusicTrackToPlay
	ld a, [hli]
;> if request:
	and a
	jr nz, ClearSoundRequests_1E.request

;>     wActiveMusicTrack = request; StartMusicRequest_1E(request)    # (ClearSoundRequests_1E.request)
;> else:
;>     UpdateDrumFF_1E()
	call UpdateDrumFF_1E

;> UpdateMusicChannels_1E()
.play
	call UpdateMusicChannels_1E
;> return ClearSoundRequests_1E()               # falls through

;@ def ClearSoundRequests_1E()
;@ path: sound/music/engine
;@ The end of every sound engine frame: the music request and the three sound effect requests are done
;@ (bank $1F has started the effects by now).
ClearSoundRequests_1E::
;> wJingleToPlay = 0
	xor a
	ld [wJingleToPlay], a
;> wMusicTrackToPlay = 0
	ld [wMusicTrackToPlay], a
;> wWaveSfxToPlay = 0
	ld [wWaveSfxToPlay], a
;> wNoiseSfxToPlay = 0
	ld [wNoiseSfxToPlay], a
	ret


;> # (.request: the request branch of UpdateMusic_1E - wActiveMusicTrack = request, StartMusicRequest_1E,
;> # then on at UpdateMusic_1E.play)
.request
	ld [hl], a
	call StartMusicRequest_1E
	jr UpdateMusic_1E.play

;@ def UpdateDrumFF_1E()
;@ path: sound/music/engine
;@ The two-step drum that the music's noise channel plays for note $FF (NoiseNote_1E requests it as
;@ noise effect 1): first NR41-NR44 = $3B, $80, $07, $C0 for 2 frames, then $00, $42, $02, $C0, which
;@ ends the effect after 4 more frames.
;@ test: wNoiseSfxToPlay = rng.choice([0, 1, 2]); wActiveNoiseSfx = rng.choice([0, 1, 1, 3]); wNoiseSfxTimer = rand(1, 3)
UpdateDrumFF_1E::
;> if wNoiseSfxToPlay == 1:
	ld de, wNoiseSfxTimer
	ld hl, wNoiseSfxToPlay
	ld a, [hli]
	cp $01
	jr z, .start

;>@st1     wActiveNoiseSfx = 1
;>@st2     regs = [0x3B, 0x80, 0x07, 0xC0, 2]           # .hit
;> elif wActiveNoiseSfx == 1:
	ld a, [hl]
	cp $01
	jr z, .running

;>@dec     wNoiseSfxTimer -= 1
;>@ret     if wNoiseSfxTimer: return
;>@clr     wActiveNoiseSfx = 0
;>@dk     regs = [0x00, 0x42, 0x02, 0xC0, 4]           # .decay
;> else:
;>     return
	ret


;=@st1
.start
	ld a, $01
	ld [wActiveNoiseSfx], a
;=@st2
	ld hl, .hit
	jp .write


;=@dec
.running
	ld a, [de]
	dec a
	ld [de], a
;=@ret
	ret nz

;=@clr
	xor a
	ld [wActiveNoiseSfx], a
;=@dk
	ld hl, .decay
	jr .write

.hit
	db $3b, $80, $07, $c0, $02
.decay
	db $00, $42, $02, $c0, $04

;> n = 4
.write
	ld b, $04
	ld c, LOW(rNR41)

;> for i in range(n): mem[0xFF20 + i] = regs[i]     # NR41-NR44
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .copy

;> wNoiseSfxTimer = regs[4]                  # frames to the next step
	ld a, [hl]
	ld [de], a
	ret


;@ path: sound/music/data
;@ The song headers of bank $1E: 64 words, entry n = song n of this bank. The music request numbers $11-$30 and $41-$60 map to the entries in order (StartMusicRequest_1E).
SongTable_1E::
	dw Music11, Music12, Music13, Music14, Music15, Music16, Music17, Music18
	dw Music19, Music1A, Music1B, Music1C, Music1D, Music1E, Music1F, Music20
	dw Music21, Music22, Music23, Music24, Music25, Music26, Music27, Music28
	dw Music29, Music2A, Music2B, Music2C, Music2D, Music2E, Music2F, Music30
	dw Music41, Music42, Music43, Music44, Music45, Music46, Music47, Music48
	dw Music49, Music4A, Music4B, Music4C, Music4D, Music4E, Music4F, Music50
	dw Music13, Music14, Music53, Music54, Music55, Music56, Music57, Music58
	dw Music59, Music5A, Music5B, Music5C, Music5D, Music5E, Music5F, Music60

;@ def GetSongHeader_1E(index: a, table: hl) -> hl
;@ path: sound/music/engine
;@ Entry `index` (1-based) of a word table: the song's header address (its high byte is also left in
;@ a, and e goes up by one).
;@ test: index = rand(1, 64); table = 0x407F
GetSongHeader_1E::
;>@ret return mem16[table + 2 * (index - 1)]
	inc e
	dec a
	sla a
	ld c, a
	ld b, $00
	add hl, bc
;=@ret
	ld c, [hl]
	inc hl
	ld b, [hl]
;=@ret
	ld l, c
	ld h, b
	ld a, h
	ret


;@ def LoadWaveRAM_1E(src: hl)
;@ path: sound/music/engine
;@ Copies a 16-byte wave pattern into wave RAM ($FF30-$FF3F).
;@ test: src = rand(0x4000, 0x7FF0)
LoadWaveRAM_1E::
;> n = 16
	push bc
	ld c, $30

;> copy(0xFF30, src, n)
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, .copy

;> return
	pop bc
	ret


;@ def SilenceNoiseSfx_1E()
;@ path: sound/music/engine
;@ Ends whatever noise effect plays and silences the noise channel (envelope 0, restarted).
SilenceNoiseSfx_1E::
;> wActiveNoiseSfx = 0
	xor a
	ld [wActiveNoiseSfx], a
;> wMusicChannel4[0x0F] = 0                    # the music gets the channel back
	ld [wMusicChannel4 + $0F], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wNoiseSfxTimer = 0
	ld [wNoiseSfxTimer], a
;> wNoiseSfxLocked = 0
	ld [wNoiseSfxLocked], a
;> wSoundUnusedA3 = 0
	ld [wSoundUnusedA3], a
;> rNR42 = 0x08                              # volume 0
	ld a, $08
	ldh [rNR42], a
;> rNR44 = 0x80                              # restart: silent
	ld a, $80
	ldh [rNR44], a
	ret


;@ def StopMusic_1E()
;@ path: sound/music/engine
;@ Stops the music (EndMusic_1E). A noise effect that plays on by itself (effects $05, $0C, $1A, $24,
;@ $2A, $2E and $3F) is left running; any other is silenced first.
;@ test: skip ends in EndMusic_1E, which resets the whole music state
StopMusic_1E::
;>@if if wActiveNoiseSfx not in (0x05, 0x0C, 0x1A, 0x24, 0x2A, 0x2E, 0x3F):
	ld a, [wActiveNoiseSfx]
	cp $05
	jp z, EndMusic_1E

;=@if
	cp $0c
	jp z, EndMusic_1E

;=@if
	cp $1a
	jp z, EndMusic_1E

;=@if
	cp $24
	jp z, EndMusic_1E

;=@if
	cp $2a
	jp z, EndMusic_1E

;=@if
	cp $2e
	jp z, EndMusic_1E

;=@if
	cp $3f
	jp z, EndMusic_1E

;>     SilenceNoiseSfx_1E()
	call SilenceNoiseSfx_1E
;> return EndMusic_1E()
	jp EndMusic_1E


;@ def StartMusicRequest_1E(request: a, track: hl)
;@ path: sound/music/engine
;@ A music request (track points at wActiveMusicTrack): nothing to do if bank $1B took it
;@ (wMusicFromBank1B); $FF stops the music. Tracks $11-$30 and $41-$60 are this bank's: they become songs
;@ 1-64 of SongTable_1E ($11-$30 -> 1-$20, $41-$60 -> $21-$40) and start with their panning; the others
;@ are bank $1B's. The requests are cleared in every case but a song start.
;@ test: skip starts a whole song
StartMusicRequest_1E::
;> if wMusicFromBank1B: return ClearSoundRequests_1E()    # bank $1B plays it
	ld b, a
	ld a, [wMusicFromBank1B]
	and a
	jp nz, ClearSoundRequests_1E

;> if request == 0xFF: return StopMusic_1E()
	ld a, b
	cp $ff
	jr z, StopMusic_1E

;> if request < 0x11: return ClearSoundRequests_1E()      # bank $1B's
	cp $11
	jr nc, .high

	jp ClearSoundRequests_1E


;> if request < 0x21:
.high
	cp $21
	jr nc, .not11

;>     song = request - 0x10                     # $11-$20 -> 1-$10
	add $f0
	jr .mine

;> elif request < 0x31:
.not11
	cp $31
	jr nc, .not21

;>     song = request - 0x10                     # $21-$30 -> $11-$20
	add $f0
	jr .mine

;> elif request < 0x41: return ClearSoundRequests_1E()    # $31-$40: bank $1B's
.not21
	cp $41
	jp c, ClearSoundRequests_1E

;> else:
;>     song = request - 0x20                     # $41 and up -> $21 and up
	add $e0

;> wMusicTrackToPlay = song
.mine
	dec hl
	ld [hli], a
;> wActiveMusicTrack = song
	ld [hld], a
;> wMusicTrackStartedBefore = wMusicTrackStarted
	ld a, [wMusicTrackStarted]
	ld [wMusicTrackStartedBefore], a
;> wMusicTrackStarted = song                     # (here the bank's own song number)
	ld a, [hli]
	ld [wMusicTrackStarted], a
;> StartSong_1E(GetSongHeader_1E(song & 0x7F, SongTable_1E))
	ld b, a
	ld hl, SongTable_1E
	and $7f
	call GetSongHeader_1E
	call StartSong_1E
;> return SetSongPanning_1E()
	jp SetSongPanning_1E


;@ path: sound/music/data
;@ Panning of each song of bank $1E (SetSongPanning_1E), 6 bytes per song in song table order: mode (1 = fixed), frames per step, then four NR51 values. Every song here uses fixed panning, all channels on both sides ($FF).
SongPanning_1E::
	db $01, $00, $ff, $ff, $00, $00 ; track $11
	db $01, $00, $ff, $ff, $00, $00 ; track $12
	db $01, $00, $ff, $ff, $00, $00 ; track $13
	db $01, $00, $ff, $ff, $00, $00 ; track $14
	db $01, $00, $ff, $ff, $00, $00 ; track $15
	db $01, $00, $ff, $ff, $00, $00 ; track $16
	db $01, $00, $ff, $ff, $00, $00 ; track $17
	db $01, $00, $ff, $ff, $00, $00 ; track $18
	db $01, $00, $ff, $ff, $00, $00 ; track $19
	db $01, $00, $ff, $ff, $00, $00 ; track $1A
	db $01, $00, $ff, $ff, $00, $00 ; track $1B
	db $01, $00, $ff, $ff, $00, $00 ; track $1C
	db $01, $00, $ff, $ff, $00, $00 ; track $1D
	db $01, $00, $ff, $ff, $00, $00 ; track $1E
	db $01, $00, $ff, $ff, $00, $00 ; track $1F
	db $01, $00, $ff, $ff, $00, $00 ; track $20
	db $01, $00, $ff, $ff, $00, $00 ; track $21
	db $01, $00, $ff, $ff, $00, $00 ; track $22
	db $01, $00, $ff, $ff, $00, $00 ; track $23
	db $01, $00, $ff, $ff, $00, $00 ; track $24
	db $01, $00, $ff, $ff, $00, $00 ; track $25
	db $01, $00, $ff, $ff, $00, $00 ; track $26
	db $01, $00, $ff, $ff, $00, $00 ; track $27
	db $01, $00, $ff, $ff, $00, $00 ; track $28
	db $01, $00, $ff, $ff, $00, $00 ; track $29
	db $01, $00, $ff, $ff, $00, $00 ; track $2A
	db $01, $00, $ff, $ff, $00, $00 ; track $2B
	db $01, $00, $ff, $ff, $00, $00 ; track $2C
	db $01, $00, $ff, $ff, $00, $00 ; track $2D
	db $01, $00, $ff, $ff, $00, $00 ; track $2E
	db $01, $00, $ff, $ff, $00, $00 ; track $2F
	db $01, $00, $ff, $ff, $00, $00 ; track $30
	db $01, $00, $ff, $ff, $00, $00 ; track $41
	db $01, $00, $ff, $ff, $00, $00 ; track $42
	db $01, $00, $ff, $ff, $00, $00 ; track $43
	db $01, $00, $ff, $ff, $00, $00 ; track $44
	db $01, $00, $ff, $ff, $00, $00 ; track $45
	db $01, $00, $ff, $ff, $00, $00 ; track $46
	db $01, $00, $ff, $ff, $00, $00 ; track $47
	db $01, $00, $ff, $ff, $00, $00 ; track $48
	db $01, $00, $ff, $ff, $00, $00 ; track $49
	db $01, $00, $ff, $ff, $00, $00 ; track $4A
	db $01, $00, $ff, $ff, $00, $00 ; track $4B
	db $01, $00, $ff, $ff, $00, $00 ; track $4C
	db $01, $00, $ff, $ff, $00, $00 ; track $4D
	db $01, $00, $ff, $ff, $00, $00 ; track $4E
	db $01, $00, $ff, $ff, $00, $00 ; track $4F
	db $01, $00, $ff, $ff, $00, $00 ; track $50
	db $01, $00, $ff, $ff, $00, $00 ; track $51
	db $01, $00, $ff, $ff, $00, $00 ; track $52
	db $01, $00, $ff, $ff, $00, $00 ; track $53
	db $01, $00, $ff, $ff, $00, $00 ; track $54
	db $01, $00, $ff, $ff, $00, $00 ; track $55
	db $01, $00, $ff, $ff, $00, $00 ; track $56
	db $01, $00, $ff, $ff, $00, $00 ; track $57
	db $01, $00, $ff, $ff, $00, $00 ; track $58
	db $01, $00, $ff, $ff, $00, $00 ; track $59
	db $01, $00, $ff, $ff, $00, $00 ; track $5A
	db $01, $00, $ff, $ff, $00, $00 ; track $5B
	db $01, $00, $ff, $ff, $00, $00 ; track $5C
	db $01, $00, $ff, $ff, $00, $00 ; track $5D
	db $01, $00, $ff, $ff, $00, $00 ; track $5E
	db $01, $00, $ff, $ff, $00, $00 ; track $5F
	db $01, $00, $ff, $ff, $00, $00 ; track $60

;@ def RestoreWaveRAM_1E()
;@ path: sound/music/engine
;@ Part of WriteNote_1E for the wave channel: after a wave-channel effect (wWaveRamDirty set) the song's
;@ wave pattern goes back into wave RAM. Then the note's registers are written (WriteNoteRegisters_1E,
;@ inside WriteNote_1E).
;@ test: skip jumps back into the middle of WriteNote_1E
RestoreWaveRAM_1E::
;> if wWaveRamDirty:
	ld a, [wWaveRamDirty]
	and a
	jp z, WriteNoteRegisters_1E

;>     rNR30 = 0                              # wave DAC off while wave RAM is written
	xor a
	ldh [rNR30], a
;>     wWaveRamDirty = 0
	ld [wWaveRamDirty], a
;>     src = mem16[wMusicChannel3 + 6]        # the song's wave pattern
	push hl
	ld a, [wMusicChannel3 + $06]
	ld l, a
	ld a, [wMusicChannel3 + $07]
	ld h, a
	push bc
;>     n = 16
	ld c, $30

;>     copy(0xFF30, src, n)
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	ld a, c
	cp $40
	jr nz, .copy

;>     rNR30 = 0x80
	ld a, $80
	ldh [rNR30], a
	pop bc
	pop hl
;> return                                    # WriteNoteRegisters_1E goes on with the registers
	jp WriteNoteRegisters_1E


;@ def SetSongPanning_1E()
;@ path: sound/music/engine
;@ Copies the song's 6 panning bytes from SongPanning_1E into wMusicPanMode..wMusicPanValues (with the
;@ timer and step at 0) and sets NR51 to the first value.
;@ test: wActiveMusicTrack = rand(1, 64)
SetSongPanning_1E::
;> p = SongPanning_1E
	ld a, [wActiveMusicTrack]
	ld hl, SongPanning_1E

;> for _ in range(wActiveMusicTrack - 1):
.find
	dec a
	jr z, .found

;>@six     p += 6
	inc hl
	inc hl
	inc hl
;=@six
	inc hl
	inc hl
	inc hl
	jr .find

;> wMusicPanMode = mem[p]
.found
	ld bc, wMusicPanMode
	ld a, [hli]
	ld [bc], a
;> wMusicPanTimer = 0
	inc c
	xor a
	ld [bc], a
;> wMusicPanPeriod = mem[p + 1]
	inc c
	ld a, [hli]
	ld [bc], a
;> wMusicPanStep = 0
	inc c
	xor a
	ld [bc], a
;> wMusicPanValues[0] = mem[p + 2]
	inc c
	ld a, [hli]
	ld [bc], a
;> rNR51 = mem[p + 2]
	ldh [rNR51], a
;> wMusicPanValues[1] = mem[p + 3]
	inc c
	ld a, [hli]
	ld [bc], a
;> wMusicPanValues[2] = mem[p + 4]
	inc c
	ld a, [hli]
	ld [bc], a
;> wMusicPanValues[3] = mem[p + 5]
	inc c
	ld a, [hli]
	ld [bc], a
	ret


;@ def UpdatePanning_1E()
;@ path: sound/music/engine
;@ Songs with moving panning (wMusicPanMode other than 1): every wMusicPanPeriod frames NR51 steps on to
;@ the next of the four wMusicPanValues.
;@ test: wMusicPanMode = rng.choice([1, 0, 3]); wMusicPanPeriod = rand(1, 4); wMusicPanTimer = rand(0, 3)
UpdatePanning_1E::
;> if wMusicPanMode == 1: return
	ld hl, wMusicPanMode
	ld a, [hli]
	cp $01
	ret z

;> wMusicPanTimer += 1
	inc [hl]
;> if wMusicPanTimer != wMusicPanPeriod: return
	ld a, [hli]
	cp [hl]
	ret nz

;> wMusicPanTimer = 0
	dec l
	ld [hl], $00
;> wMusicPanStep += 1
	inc l
	inc l
	inc [hl]
;>@w rNR51 = wMusicPanValues[wMusicPanStep & 3]
	ld a, [hli]
	and $03
	ld c, l
	ld b, h
	and a
	jr z, .write

;=@w
	inc c
	cp $01
	jr z, .write

;=@w
	inc c
	cp $02
	jr z, .write

;=@w
	inc c

.write
	ld a, [bc]
	ldh [rNR51], a
	ret


;@ def CopyIndirectWord_1E(src: hl, dest: de) -> a
;@ path: sound/music/engine
;@ Copies the word that the pointer at src points to into dest (dest stays inside its 256-byte page) and
;@ returns its high byte.
;@ test: src = rng.choice([0xD310, 0xD320, 0xD330, 0xD340]); w = rand(0x4000, 0x7F00); mem[src] = w & 0xFF; mem[src + 1] = w >> 8
;@ test: dest = src + 4
CopyIndirectWord_1E::
;> p = mem16[src]
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
;> mem[dest] = mem[p]
	ld a, [bc]
	ld [de], a
;> mem[(dest & 0xFF00) | lo(dest + 1)] = mem[u16(p + 1)]
	inc e
	inc bc
	ld a, [bc]
	ld [de], a
;> return mem[u16(p + 1)]
	ret


;@ def CopyWord_1E(src: hl, dest: de) -> hl
;@ path: sound/music/engine
;@ Copies two bytes from src to dest (dest stays inside its page) and returns src moved past them.
;@ test: src = rand(0x4000, 0x7F00)
;@ test: dest = rng.choice([0xD301, 0xD310, 0xD320, 0xD330, 0xD340])
CopyWord_1E::
;> mem[dest] = mem[src]
	ld a, [hli]
	ld [de], a
;> mem[(dest & 0xFF00) | lo(dest + 1)] = mem[src + 1]
	inc e
	ld a, [hli]
	ld [de], a
;> return src + 2
	ret


;@ def StartSong_1E(header: hl)
;@ path: sound/music/engine
;@ Sets up a song from its 11-byte header: transpose, note length table and the pattern list of each
;@ channel. Every channel starts at the first pattern of its list with its note timer at 1, so the next
;@ update plays the first notes. The noise channel is silenced first unless one of the self-running noise
;@ effects plays (see StopMusic_1E).
;@ test: t = 0x407F + 2 * rand(0, 63); header = mem[t] | mem[t + 1] << 8
StartSong_1E::
;>@if if wActiveNoiseSfx not in (0x05, 0x0C, 0x1A, 0x24, 0x2A, 0x2E, 0x3F):
	ld a, [wActiveNoiseSfx]
	cp $05
	jr z, .reset

;=@if
	cp $0c
	jr z, .reset

;=@if
	cp $1a
	jr z, .reset

;=@if
	cp $24
	jr z, .reset

;=@if
	cp $2a
	jr z, .reset

;=@if
	cp $2e
	jr z, .reset

;=@if
	cp $3f
	jr z, .reset

;>     SilenceNoiseSfx_1E()
	call SilenceNoiseSfx_1E

;> ResetMusicState_1E()
.reset
	call ResetMusicState_1E
;> wMusicTranspose = mem[header]
	ld de, wMusicTranspose
	ld b, $00
	ld a, [hli]
	ld [de], a
;> wMusicNoteLengths = mem16[header + 1]
	inc e
	call CopyWord_1E
;> mem16[wMusicChannel1] = mem16[header + 3]             # pattern lists
	ld de, wMusicChannel1
	call CopyWord_1E
;> mem16[wMusicChannel2] = mem16[header + 5]
	ld de, wMusicChannel2
	call CopyWord_1E
;> mem16[wMusicChannel3] = mem16[header + 7]
	ld de, wMusicChannel3
	call CopyWord_1E
;> mem16[wMusicChannel4] = mem16[header + 9]
	ld de, wMusicChannel4
	call CopyWord_1E
;> mem16[wMusicChannel1 + 4] = mem16[mem16[wMusicChannel1]]     # pattern pointer: the first pattern
	ld hl, wMusicChannel1
	ld de, wMusicChannel1 + $04
	call CopyIndirectWord_1E
;> mem16[wMusicChannel2 + 4] = mem16[mem16[wMusicChannel2]]
	ld hl, wMusicChannel2
	ld de, wMusicChannel2 + $04
	call CopyIndirectWord_1E
;> mem16[wMusicChannel3 + 4] = mem16[mem16[wMusicChannel3]]
	ld hl, wMusicChannel3
	ld de, wMusicChannel3 + $04
	call CopyIndirectWord_1E
;> mem16[wMusicChannel4 + 4] = mem16[mem16[wMusicChannel4]]
	ld hl, wMusicChannel4
	ld de, wMusicChannel4 + $04
	call CopyIndirectWord_1E
;>@timers for ch in [wMusicChannel1, wMusicChannel2, wMusicChannel3, wMusicChannel4]:
	ld bc, $0410
	ld hl, wMusicChannel1 + $02

;>     mem[ch + 2] = 1                                      # note timer
.timers
	ld [hl], $01
;=@timers
	ld a, c
	add l
	ld l, a
	dec b
	jr nz, .timers

;> wMusicChannel1[0x0E] = 0                                 # frames since the note started
	xor a
	ld [wMusicChannel1 + $0E], a
;> wMusicChannel2[0x0E] = 0
	ld [wMusicChannel2 + $0E], a
;> wMusicChannel3[0x0E] = 0
	ld [wMusicChannel3 + $0E], a
	ret


;> # (InstrumentLoadWave_1E: the wave branch of InstrumentCommand_1E - unless a wave effect plays, the
;> # wave pattern goes into wave RAM right away; then back there)
InstrumentLoadWave_1E:
	push hl
	ld a, [wActiveWaveSfx]
	and a
	jr nz, .keep

	xor a
	ldh [rNR30], a
;> #
	ld l, e
	ld h, d
	call LoadWaveRAM_1E

.keep
	pop hl
	jr InstrumentCommand_1E.next

;@ def InstrumentCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9D: the next 3 bytes become the channel's instrument (+6..+8). On the square and noise
;@ channels: envelope (NRx2), release (high nibble: when the release envelope comes - $80 at 1/2 of the
;@ note, $40 at 1/4, else 3/4; low nibble: which one, ReleaseEnvelopes_1E) and NRx1 duty with the effect
;@ type in the low nibble (1 vibrato, other values a fixed detune). On the wave channel:
;@ the address of a wave pattern, loaded into wave RAM right away, and the NR32 output level (bit 7: drop
;@ to half level 6 frames before the note ends). Then the pattern goes on.
;@ test: n = rand(1, 4); wMusicChannel = n; ch = 0xD300 + 0x10 * n; ptr = ch + 4
;@ test: p = rand_ram(8); mem[ptr] = p & 0xFF; mem[ptr + 1] = p >> 8; wActiveWaveSfx = rng.choice([0, 1])
;@ test: for c in range(ch + 0x10, 0xD350, 0x10): mem[c + 1] = 0
InstrumentCommand_1E::
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> b0 = ReadPointer_1E(ptr)
	call ReadPointer_1E
	ld e, a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> b1 = ReadPointer_1E(ptr)
	call ReadPointer_1E
	ld d, a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> b2 = ReadPointer_1E(ptr)
	call ReadPointer_1E
	ld c, a
;> mem[ptr + 2] = b0
	inc l
	inc l
	ld [hl], e
;> mem[ptr + 3] = b1
	inc l
	ld [hl], d
;> mem[ptr + 4] = b2
	inc l
	ld [hl], c
	dec l
	dec l
	dec l
	dec l
;> if wMusicChannel == 3:
	push hl
	ld hl, wMusicChannel
	ld a, [hl]
	pop hl
	cp $03
	jr z, InstrumentLoadWave_1E

;>     if not wActiveWaveSfx: rNR30 = 0; LoadWaveRAM_1E(b0 | b1 << 8)    # (InstrumentLoadWave_1E, after StartSong_1E)
;> AdvancePointer_1E(ptr)
.next
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jp ReadPattern_1E


;@ def AdvancePointer_1E(ptr: hl)
;@ path: sound/music/engine
;@ Adds 1 to the word at ptr.
;@ test: ptr = rand_ram(2)
AdvancePointer_1E::
;> p = mem16[ptr]
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
;> p = u16(p + 1)
	inc de

;> mem[ptr] = lo(p)
.store
	ld a, e
	ld [hli], a
;> mem[ptr + 1] = hi(p)
	ld a, d
	ld [hld], a
	pop de
	ret


;@ def AdvancePointer2_1E(ptr: hl)
;@ path: sound/music/engine
;@ Adds 2 to the word at ptr.
;@ test: ptr = rand_ram(2)
AdvancePointer2_1E::
;> p = mem16[ptr]
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
;> p = u16(p + 2)
	inc de
	inc de
;> mem16[ptr] = p                                  # AdvancePointer_1E.store
	jr AdvancePointer_1E.store

;@ def ReadPointer_1E(ptr: hl) -> a
;@ path: sound/music/engine
;@ Reads the byte that the pointer at ptr points to (also left in b).
;@ test: ptr = rand_ram(2)
ReadPointer_1E::
;> p = mem16[ptr]
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
;> return mem[p]
	ld a, [bc]
	ld b, a
	ret


;> # (SustainNoteSkip_1E: SustainNote_1E's way out for rests and channels an effect holds)
SustainNoteSkip_1E:
	pop hl
	jr SkipChannel_1E

;@ def SustainNote_1E(timer: hl)
;@ path: sound/music/engine
;@ A frame in the middle of a note: wave notes whose level byte has bit 7 set drop to half level 6 frames
;@ before the end; then, unless the note is a rest or an effect holds the channel, the note's effects
;@ (UpdateNoteEffects_1E) and the release envelopes of the square channels.
;@ test: n = rand(1, 4); wMusicChannel = n; ch = 0xD300 + 0x10 * n; timer = ch + 2
;@ test: mem[timer] = rng.choice([6, rand(1, 10)]); mem[ch + 0x0B] = rng.choice([0, 0, 1])
;@ test: mem[ch + 0x0F] = rng.choice([0, 0, 0x80]); mem[ch + 8] = rand(0, 255)
;@ test: for c in range(ch + 0x10, 0xD350, 0x10): mem[c + 1] = 0
;@ test: wCurrentBank = $1E
SustainNote_1E::
;> if wMusicChannel == 3:
	ld a, [wMusicChannel]
	cp $03
	jr nz, .effects

;>     if wMusicChannel3[8] & 0x80:
	ld a, [wMusicChannel3 + $08]
	bit 7, a
	jr z, .effects

;>         if mem[timer] == 6:
	ld a, [hl]
	cp $06
	jr nz, .effects

;>             rNR32 = 0x40                         # half level
	ld a, $40
	ldh [rNR32], a

;> ch = timer - 2
.effects
	push hl
;> if mem[ch + 0x0B] == 0:                          # not a rest
	ld a, l
	add $09
	ld l, a
	ld a, [hl]
	and a
	jr nz, SustainNoteSkip_1E

;>     if not mem[ch + 0x0F] & 0x80:                # no effect holds the channel
	ld a, l
	add $04
	ld l, a
	bit 7, [hl]
	jr nz, SustainNoteSkip_1E

;>         UpdateNoteEffects_1E(timer)
	pop hl
	call UpdateNoteEffects_1E
;>         UpdateReleaseEnvelopes_1E()
	push hl
	call UpdateReleaseEnvelopes_1E
	pop hl

;> return SkipChannel_1E(timer)                     # falls through (SustainNoteSkip_1E also goes there)

;@ def SkipChannel_1E(timer: hl)
;@ path: sound/music/engine
;@ Nothing more to do for this channel this frame.
;@ test: skip runs the remaining channels
SkipChannel_1E::
;> return NextChannel_1E(timer - 2)
	dec l
	dec l
	jp NextChannel_1E


;@ def NextPattern_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern byte $00: on to the next pattern of the channel's list. A list word with high byte $00 ends
;@ the song: the fanfare track $25 starts hLastMusicTrack again, anything else stops the
;@ music. A word with high byte $FF is followed by the address where the list goes on (the loop).
;@ test: skip runs the rest of the music frame
NextPattern_1E::
;> ch = ptr - 4
	dec l
	dec l
	dec l
	dec l
;> AdvancePointer2_1E(ch)                              # next word of the pattern list
	call AdvancePointer2_1E

;>@loop while True:
;>     hi_ = CopyIndirectWord_1E(ch, ch + 4)        # pattern pointer = the list word
.entry
	ld a, l
	add $04
	ld e, a
	ld d, h
	call CopyIndirectWord_1E
;>     if hi_ == 0:                                 # end of the song
	cp $00
	jr z, .end

;>@end1         if wMusicTrackStarted == 0x15: return ResumeMusicAfterFanfare_1E()   # track $25 (song $15 here)
;>@end2         wActiveMusicTrack = 0
;>@end3         StopMusic_1E()
;>@end4         return
;>     if hi_ != 0xFF:
	cp $ff
	jr z, .loop

;>         return NextNote_1E(ch + 2)
	inc l
	jp NextNote_1E


;>     AdvancePointer2_1E(ch)                       # $FFxx: the list goes on at the next word
.loop
	dec l
	push hl
	call AdvancePointer2_1E
;>     lo_ = ReadPointer_1E(ch)
	call ReadPointer_1E
	ld e, a
;>     AdvancePointer_1E(ch)
	call AdvancePointer_1E
;>     hi2 = ReadPointer_1E(ch)
	call ReadPointer_1E
	ld d, a
	pop hl
;>     mem[ch] = lo_
	ld a, e
	ld [hli], a
;>     mem[ch + 1] = hi2
	ld a, d
	ld [hld], a
;=@loop
	jr .entry

;=@end1
.end
	ld a, [wMusicTrackStarted]
	cp $15
	jp z, ResumeMusicAfterFanfare_1E

;=@end2
	ld hl, wActiveMusicTrack
	ld [hl], $00
;=@end3
	call StopMusic_1E
;=@end4
	ret


;@ def LengthTableCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9E: the next 2 bytes are the address of a new note length table.
;@ test: skip goes on reading the pattern
LengthTableCommand_1E::
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> mem[0xD301] = ReadPointer_1E(ptr)                 # wMusicNoteLengths, low byte
	call ReadPointer_1E
	ld [wMusicNoteLengths], a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> mem[0xD302] = ReadPointer_1E(ptr)                 # high byte
	call ReadPointer_1E
	ld [wMusicNoteLengths + 1], a
;> return NextCommand_1E(ptr)
	jr NextCommand_1E

;@ def TransposeCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9F: the next byte becomes wMusicTranspose (added to every following note byte of all
;@ channels).
;@ test: skip goes on reading the pattern
TransposeCommand_1E::
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> wMusicTranspose = ReadPointer_1E(ptr)
	call ReadPointer_1E
	ld [wMusicTranspose], a
;> return NextCommand_1E(ptr)                       # falls through

;@ def NextCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Moves past the last byte of a command and reads on.
;@ test: skip goes on reading the pattern
NextCommand_1E::
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jr ReadPattern_1E

;@ def LoopStartCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9B n: the bytes up to the next $9C are played n times. The count goes into bits 0-6 of
;@ the channel's +F, the address after it into +C/+D (one loop at a time).
;@ test: skip goes on reading the pattern
LoopStartCommand_1E::
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> count = ReadPointer_1E(ptr)
	call ReadPointer_1E
;> flags = ptr + 0x0B                                # the channel's +F
	push hl
	ld a, l
	add $0b
	ld l, a
;> mem[flags] |= count
	ld c, [hl]
	ld a, b
	or c
	ld [hl], a
;> start = flags - 2                                 # +D
	ld b, h
	ld c, l
	dec c
	dec c
	pop hl
;> p = u16(mem16[ptr] + 1)
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
;> mem16[ptr] = p                                   # past the count
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
;> mem[start] = hi(p)                                # loop start = p
	ld a, d
	ld [bc], a
;> mem[start - 1] = lo(p)
	dec c
	ld a, e
	ld [bc], a
;> return ReadPattern_1E(ptr)
	jr ReadPattern_1E

;@ def LoopEndCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9C: one pass of the loop is done; while passes are left the pattern goes back to the
;@ loop start, else on past the $9C.
;@ test: skip goes on reading the pattern
LoopEndCommand_1E::
;> flags = ptr + 0x0B
	push hl
	ld a, l
	add $0b
	ld l, a
;> mem[flags] = u8(mem[flags] - 1)
	ld a, [hl]
	dec [hl]
;> if mem[flags] & 0x7F:
	ld a, [hl]
	and $7f
	jr z, .done

;>     start = ptr + 8                              # +C/+D
	ld b, h
	ld c, l
	dec c
	dec c
	dec c
	pop hl
;>     mem[ptr] = mem[start]
	ld a, [bc]
	ld [hli], a
;>     mem[ptr + 1] = mem[start + 1]
	inc c
	ld a, [bc]
	ld [hld], a
;>     return ReadPattern_1E(ptr)
	jr ReadPattern_1E

;> return NextCommand_1E(ptr)
.done
	pop hl
	jr NextCommand_1E

;@ def UpdateMusicChannels_1E()
;@ path: sound/music/engine
;@ One frame of bank $1E's song, if one plays: the panning, then each of the 4 channels in turn. A song
;@ of bank $1B ends here with the requests cleared.
;@ test: skip runs the whole song frame
UpdateMusicChannels_1E::
;> if wActiveMusicTrack == 0: return
	ld hl, wActiveMusicTrack
	ld a, [hl]
	and a
	ret z

;> if wMusicFromBank1B: return ClearSoundRequests_1E()   # the song is bank $1B's
	ld a, [wMusicFromBank1B]
	and a
	jp nz, ClearSoundRequests_1E

;> UpdatePanning_1E()
	call UpdatePanning_1E
;> wMusicChannel = 1
	ld a, $01
	ld [wMusicChannel], a
;> return UpdateChannel_1E(wMusicChannel1)          # falls through
	ld hl, wMusicChannel1

;@ def UpdateChannel_1E(ch: hl)
;@ path: sound/music/engine
;@ A channel without a pattern list is skipped. Otherwise its note timer counts down; at 0 the next note
;@ is read.
;@ test: skip runs the rest of the music frame
UpdateChannel_1E::
;> timer = ch + 2
;> if mem[ch + 1] == 0: return SkipChannel_1E(timer)
	inc l
	ld a, [hli]
	and a
	jp z, SkipChannel_1E

;> mem[timer] = u8(mem[timer] - 1)
	dec [hl]
;> if mem[timer]: return SustainNote_1E(timer)
;> return NextNote_1E(timer)                        # falls through
	jp nz, SustainNote_1E

;@ def NextNote_1E(timer: hl)
;@ path: sound/music/engine
;@ The note is over: read the pattern on.
;@ test: skip runs the rest of the music frame
NextNote_1E::
;> return ReadPattern_1E(timer + 2)                 # falls through
	inc l
	inc l

;@ def ReadPattern_1E(ptr: hl)
;@ path: sound/music/engine
;@ Reads the channel's pattern at ptr (the channel's +4) - the music data format:
;@ $00 ends the pattern (NextPattern_1E); $9D a b c sets the instrument (InstrumentCommand_1E); $9E lo hi
;@ a new note length table; $9F t the transpose; $9B n ... $9C plays the bytes between n times; $99 / $9A
;@ wave decay on / off (off also ends the swell), $94 wave swell, $97 / $98 pitch drop on / off, $96 / $95 block / allow wave-channel
;@ effects. $A0-$AF sets the note length (the low nibble indexes the song's note length table) for this and
;@ the following notes and works out the release frame of the square channels. Then comes the note: $01 is
;@ a rest, even values $02-$90 index NoteFrequencies_1E (after the transpose is added: 2 per semitone,
;@ $02 = C2); on the noise channel the byte picks a drum of DrumSounds_1E ($FF: the two-step drum).
;@ test: skip runs the rest of the music frame
ReadPattern_1E::
;> ch = ptr - 4
;> b = ReadPointer_1E(ptr)
	call ReadPointer_1E
;> if b == 0x00: return NextPattern_1E(ptr)
	cp $00
	jp z, NextPattern_1E

;> if b == 0x9D: return InstrumentCommand_1E(ptr)
	cp $9d
	jp z, InstrumentCommand_1E

;> if b == 0x9E: return LengthTableCommand_1E(ptr)
	cp $9e
	jp z, LengthTableCommand_1E

;> if b == 0x9F: return TransposeCommand_1E(ptr)
	cp $9f
	jp z, TransposeCommand_1E

;> if b == 0x9B: return LoopStartCommand_1E(ptr)
	cp $9b
	jp z, LoopStartCommand_1E

;> if b == 0x9C: return LoopEndCommand_1E(ptr)
	cp $9c
	jp z, LoopEndCommand_1E

;> if b == 0x99: return WaveDecayOnCommand_1E(ptr)
	cp $99
	jp z, WaveDecayOnCommand_1E

;> if b == 0x9A: return WaveEffectsOffCommand_1E(ptr)
	cp $9a
	jp z, WaveEffectsOffCommand_1E

;> if b == 0x94: return WaveSwellCommand_1E(ptr)
	cp $94
	jp z, WaveSwellCommand_1E

;> if b == 0x97: return PitchDropOnCommand_1E(ptr)
	cp $97
	jp z, PitchDropOnCommand_1E

;> if b == 0x98: return PitchDropOffCommand_1E(ptr)
	cp $98
	jp z, PitchDropOffCommand_1E

;> if b == 0x96: return BlockWaveSfxCommand_1E(ptr)
	cp $96
	jp z, BlockWaveSfxCommand_1E

;> if b == 0x95: return AllowWaveSfxCommand_1E(ptr)
	cp $95
	jp z, AllowWaveSfxCommand_1E

;> if (b & 0xF0) == 0xA0:                             # a note length
	and $f0
	cp $a0
	jr nz, .note

;>     idx = b & 0x0F
	ld a, b
	and $0f
	ld c, a
	ld b, $00
	push hl
;>     table = wMusicNoteLengths
	ld de, wMusicNoteLengths
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld h, a
;>     length = mem[u16(table + idx)]
	add hl, bc
	ld a, [hl]
	pop hl
	push hl
	ld d, a
;>     rel = mem[ch + 7] & 0xF0                     # instrument byte 2: when the release comes
;>     if rel:
;>@r1         if rel & 0x80: frame = length >> 1    # at 1/2 of the note
;>@r2         elif rel & 0x40: frame = length >> 2  # at 1/4
;>@r3         else: frame = (length >> 2) + (length >> 1)    # at 3/4
;>@r4         if frame == 0: frame = 2
;>@r5         wMusicReleaseFrame[wMusicChannel - 1] = frame
	inc l
	inc l
	inc l
	ld a, [hl]
	and $f0
	jr nz, .release

;>     else:
;>         pass                                     # the release frame stays
	ld a, d
	jr .store

;=@r1
.release
	ld e, a
	ld a, d
	push af
	srl a
	sla e
	jr c, .frame

;=@r2
	ld d, a
	srl a
	sla e
	jr c, .frame

;=@r3
	add d

;=@r4
.frame
	ld c, a
	and a
	jr nz, .save

	ld c, $02

;=@r5
.save
	ld de, wMusicChannel
	ld a, [de]
	dec a
	ld e, a
	ld d, $00
;=@r5
	ld hl, wMusicReleaseFrame
	add hl, de
	ld [hl], c
	pop af

;>     mem[ch + 3] = length                         # note length (also for the following notes)
.store
	pop hl
	dec l
	ld [hli], a
;>     AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;>     b = ReadPointer_1E(ptr)
	call ReadPointer_1E

;> note = b
;> if wMusicChannel != 4:
.note
	ld a, [wMusicChannel]
	cp $04
	jr z, .notNoise

;>     wMusicVibrato[2 * (wMusicChannel - 1)] = 0   # the effects start again with the note
	push de
	ld de, wMusicVibrato
	call ChannelPairOffset_1E
	xor a
	ld [de], a
;>     wMusicVibrato[2 * (wMusicChannel - 1) + 1] = 0
	inc e
	ld [de], a
;>     wMusicPitchDrop[2 * (wMusicChannel - 1) + 1] = 0
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1E
	inc e
	xor a
	ld [de], a
;>     if wMusicChannel == 3:
	ld a, [wMusicChannel]
	cp $03
	jr nz, .noWave

;>         if wMusicWaveDecay:
	ld de, wMusicWaveDecay
	ld a, [de]
	and a
	jr z, .noDecay

;>             wMusicWaveDecay = 1
	ld a, $01
	ld [de], a
;>             wMusicWaveDecayFrame = 0
	xor a
	ld [wMusicWaveDecayFrame], a

;>         if wMusicWaveSwell:
.noDecay
	ld de, wMusicWaveSwell
	ld a, [de]
	and a
	jr z, .noWave

;>             wMusicWaveSwell = 1
	ld a, $01
	ld [de], a
;>             wMusicWaveSwellFrame = 0
	xor a
	ld [wMusicWaveSwellFrame], a

.noWave
	pop de

;> AdvancePointer_1E(ptr)
.notNoise
	ld c, b
	ld b, $00
	call AdvancePointer_1E
;> if wMusicChannel == 4: return NoiseNote_1E(note, ptr)
	ld a, [wMusicChannel]
	cp $04
	jp z, NoiseNote_1E

;> freq = ch + 9                                    # frequency (+9, +A)
	push hl
	ld a, l
	add $05
	ld l, a
	ld e, l
	ld d, h
;> rest = ch + 0x0B
	inc l
	inc l
;> if note == 1:                                    # a rest
	ld a, c
	cp $01
	jr z, .rest

;>@rest     mem[rest] = 1
;>@restplay     return PlayNote_1E(ptr)
;> mem[rest] = 0
	ld [hl], $00
;> if wMusicTranspose:
	ld a, [wMusicTranspose]
	and a
	jr z, .freq

;>     t = wMusicTranspose - 0x100 if wMusicTranspose & 0x80 else wMusicTranspose
	ld l, a
	ld h, $00
	bit 7, l
	jr z, .add

	ld h, $ff

;>     note = u16(note + t)
.add
	add hl, bc
	ld b, h
	ld c, l

;> src = NoteFrequencies_1E + note
.freq
	ld hl, NoteFrequencies_1E
	add hl, bc
;> mem[freq] = mem[src]
	ld a, [hli]
	ld [de], a
;> mem[freq + 1] = mem[src + 1]
	inc e
	ld a, [hl]
	ld [de], a
;> return PlayNote_1E(ptr)
	pop hl
	jp PlayNote_1E


;=@rest
.rest
	ld [hl], $01
;=@restplay
	pop hl
	jr PlayNote_1E

;@ def NoiseNote_1E(note: bc, ptr: hl)
;@ path: sound/music/engine
;@ The noise channel: note $FF plays the two-step drum (noise effect 1, UpdateDrumFF_1E) unless an effect
;@ holds the channel; any other note copies its 5-byte drum from DrumSounds_1E to the channel's +6..+A
;@ and plays it.
;@ test: skip the note timer reload pops the pointer pushed here
NoiseNote_1E::
;> if note == 0xFF:
	push hl
	ld a, c
	cp $ff
	jr z, .drumFF

;>@ff1     if not wMusicChannel4[0x0F] & 0x80:
;>@ff2         wNoiseSfxToPlay = 1
;>@ff3         UpdateDrumFF_1E()
;>@ff4     return ReloadNoteTimer_1E(ptr)
;> dest = wMusicChannel4 + 6
	ld de, wMusicChannel4 + $06
;> src = DrumSounds_1E + note
	ld hl, DrumSounds_1E
	add hl, bc

;>@copy for i in range(5):
;>     mem[dest + i] = mem[src + i]
.copy
	ld a, [hli]
	ld [de], a
;=@copy
	inc e
	ld a, e
	cp $4b
	jr nz, .copy

;> return InstrumentNote_1E(0x20, wMusicChannel4 + 4)   # NR41-NR44
	ld c, LOW(rNR41)
	ld hl, wMusicChannel4 + $04
	ld b, $00
	jr InstrumentNote_1E

;=@ff1
.drumFF
	ld a, [wMusicChannel4 + $0F]
	bit 7, a
	jp nz, ReloadNoteTimer_1E

;=@ff2
	ld a, $01
	ld [wNoiseSfxToPlay], a
;=@ff3
	call UpdateDrumFF_1E
;=@ff4
	jp ReloadNoteTimer_1E


;@ def PlayNote_1E(ptr: hl)
;@ path: sound/music/engine
;@ Starts the note on the channel's sound registers. The wave channel first restarts its DAC (unless an
;@ effect holds the channel) and uses its level byte (+8) with length 0.
;@ test: skip the note timer reload pops the pointer pushed here
PlayNote_1E::
;> if wMusicChannel == 1:
	push hl
	ld b, $00
	ld a, [wMusicChannel]
	cp $01
	jr z, .square1

;>@sq1     return InstrumentNote_1E(0x11, ptr)    # NR11-NR14
;> if wMusicChannel == 2:
	cp $02
	jr z, .square2

;>@sq2     return InstrumentNote_1E(0x16, ptr)    # NR21-NR24
;> if not wMusicChannel3[0x0F] & 0x80:             # the wave channel, unless an effect holds it
	ld c, LOW(rNR30)
	ld a, [wMusicChannel3 + $0F]
	bit 7, a
	jr nz, .taken

;>     rNR30 = 0                                    # restart the wave DAC
	xor a
	ldh [c], a
;>     rNR30 = 0x80
	ld a, $80
	ldh [c], a

;> reg = 0x1B                                       # NR31-NR34
.taken
	inc c
;> level = mem[ptr + 4]                             # +8: the NR32 level
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	ld e, a
;> return WriteNote_1E(reg, ptr + 5, 0, level)
	ld d, $00
	jr WriteNote_1E

;=@sq2
.square2
	ld c, LOW(rNR21)
	jr InstrumentNote_1E

;=@sq1
.square1
	ld c, LOW(rNR10)
	inc c

;@ def InstrumentNote_1E(reg: c, ptr: hl)
;@ path: sound/music/engine
;@ Square and noise channels: the duty / length byte from instrument byte +8 and the envelope from +6.
;@ test: skip the note timer reload pops the pointer pushed by the caller
InstrumentNote_1E::
;> env = mem[ptr + 2]                               # +6
	inc l
	inc l
	ld a, [hli]
	ld e, a
;> duty = mem[ptr + 4]                              # +8
	inc l
	ld a, [hli]
	ld d, a
;> return WriteNote_1E(reg, ptr + 5, duty, env)     # falls through

;@ def WriteNote_1E(reg: c, freq: hl, duty: d, env: e)
;@ path: sound/music/engine
;@ Writes the 4 registers of the note (a rest gets envelope $08: volume 0) unless an effect holds the
;@ channel; the wave channel first gets its wave pattern back after an effect (RestoreWaveRAM_1E). The
;@ note's frame count restarts and the note timer is loaded (ReloadNoteTimer_1E).
;@ test: skip the note timer reload pops the pointer pushed by the caller
WriteNote_1E::
;> ch = freq - 9
;> rest = mem[ch + 0x0B]
	push hl
	inc l
	inc l
	ld a, [hli]
;> if rest: env = 8
	and a
	jr z, .sound

	ld e, $08

;> mem[ch + 0x0E] = 0                               # frames since the note started
.sound
	inc l
	inc l
	ld [hl], $00
;> flags = mem[ch + 0x0F]
	inc l
	ld a, [hl]
	pop hl
;> if not flags & 0x80:                             # no effect holds the channel
	bit 7, a
	jr nz, ReloadNoteTimer_1E

;>     if wMusicChannel == 3: RestoreWaveRAM_1E()     # (it jumps there and comes back)
	ld a, [wMusicChannel]
	cp $03
	jp z, RestoreWaveRAM_1E

;>     mem[0xFF00 + reg] = duty                     # (b is 0)
WriteNoteRegisters_1E:
	ld a, d
	or b
	ldh [c], a
;>     mem[0xFF00 + reg + 1] = env
	inc c
	ld a, e
	ldh [c], a
;>     mem[0xFF00 + reg + 2] = mem[freq]
	inc c
	ld a, [hli]
	ldh [c], a
;>     mem[0xFF00 + reg + 3] = mem[freq + 1] | 0x80   # start the note
	inc c
	ld a, [hl]
	or $80
	ldh [c], a
;> return ReloadNoteTimer_1E(freq - 5)              # falls through

;@ def ReloadNoteTimer_1E(ptr: stack)
;@ path: sound/music/engine
;@ The note is set up: the timer is loaded from the note length and the next channel follows. ptr (the
;@ channel's +4) is the value PlayNote_1E / NoiseNote_1E pushed.
;@ test: skip pops the pattern pointer its caller pushed
ReloadNoteTimer_1E::
;> mem[ptr - 2] = mem[ptr - 1]                      # note timer = note length
	pop hl
	dec l
	ld a, [hld]
	ld [hld], a
;> return NextChannel_1E(ptr - 4)                   # falls through
	dec l

;@ def NextChannel_1E(ch: hl)
;@ path: sound/music/engine
;@ On to the next channel; after channel 4 the frame counts of channels 1-3 go up.
;@ test: skip runs the rest of the music frame
NextChannel_1E::
;> if wMusicChannel == 4:
	ld de, wMusicChannel
	ld a, [de]
	cp $04
	jr z, .done

;>@d1     wMusicChannel1[0x0E] += 1
;>@d2     wMusicChannel2[0x0E] += 1
;>@d3     wMusicChannel3[0x0E] += 1
;>@dret     return
;> wMusicChannel += 1
	inc a
	ld [de], a
;> return UpdateChannel_1E(u16(ch + 0x10))
	ld a, $10
	add l
	ld l, a
	jp UpdateChannel_1E


;=@d1
.done
	ld hl, wMusicChannel1 + $0E
	inc [hl]
;=@d2
	ld hl, wMusicChannel2 + $0E
	inc [hl]
;=@d3
	ld hl, wMusicChannel3 + $0E
	inc [hl]
;=@dret
	ret


;> # (PopHLReturn_1E: the common exit of the note effects - pop hl and return)
PopHLReturn_1E:
	pop hl
	ret


;@ def UpdateNoteEffects_1E(timer: hl)
;@ path: sound/music/engine
;@ The per-frame effects of a sounding note. Square and wave channels with an effect type (low nibble of
;@ instrument byte +8) get their frequency changed (ApplyFrequencyEffect_1E); then the pitch drop and
;@ the wave level effects (UpdateDropAndWaveEffects_1E). timer is pushed here and popped by the exit.
;@ test: skip the exit pops what the entry pushed, across several routines
UpdateNoteEffects_1E::
;> ch = timer - 2
;> kind = mem[ch + 8] & 0x0F
	push hl
	ld a, l
	add $06
	ld l, a
	ld a, [hl]
	and $0f
;> if kind:
	jr z, UpdateDropAndWaveEffects_1E

;>     wMusicEffect = kind
	ld [wMusicEffect], a
;>     if wMusicChannel == 1: return ApplyFrequencyEffect_1E(ch + 8, 0x13)   # NR13/NR14
	ld a, [wMusicChannel]
	ld c, $13
	cp $01
	jr z, ApplyFrequencyEffect_1E

;>     if wMusicChannel == 2: return ApplyFrequencyEffect_1E(ch + 8, 0x18)   # NR23/NR24
	ld c, $18
	cp $02
	jr z, ApplyFrequencyEffect_1E

;>     if wMusicChannel == 3: return ApplyFrequencyEffect_1E(ch + 8, 0x1D)   # NR33/NR34
	ld c, $1d
	cp $03
	jr z, ApplyFrequencyEffect_1E

;> return UpdateDropAndWaveEffects_1E(timer)        # falls through

;@ def UpdateDropAndWaveEffects_1E(timer: stack)
;@ path: sound/music/engine
;@ Square and wave channels with the pitch drop on (command $97) slide down (UpdatePitchDrop_1E); else the
;@ wave channel runs its decay or swell of the level. Ends by popping the timer UpdateNoteEffects_1E
;@ pushed (PopHLReturn_1E).
;@ test: skip pops what UpdateNoteEffects_1E pushed
UpdateDropAndWaveEffects_1E::
;> if wMusicChannel == 4: return
	ld a, [wMusicChannel]
	cp $04
	jp z, PopHLReturn_1E

;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1E
;> if mem[drop]:
	ld a, [de]
	and a
	jp z, .waveEffects

;>     if wMusicChannel == 1: return UpdatePitchDrop_1E(drop, 0x13)
	ld a, [wMusicChannel]
	ld c, $13
	cp $01
	jp z, UpdatePitchDrop_1E

;>     if wMusicChannel == 2: return UpdatePitchDrop_1E(drop, 0x18)
	ld c, $18
	cp $02
	jp z, UpdatePitchDrop_1E

;>     return UpdatePitchDrop_1E(drop, 0x1D)
	ld c, $1d
	jp UpdatePitchDrop_1E


;> if wMusicChannel != 3: return
.waveEffects
	ld a, [wMusicChannel]
	cp $03
	jp nz, PopHLReturn_1E

;> if wMusicWaveDecay: return UpdateWaveDecay_1E(wMusicWaveDecay)
	ld a, [wMusicWaveDecay]
	and a
	jp nz, UpdateWaveDecay_1E

;> if wMusicWaveSwell: return UpdateWaveSwell_1E(wMusicWaveSwell)
	ld a, [wMusicWaveSwell]
	and a
	jp nz, UpdateWaveSwell_1E

;> return
	jp PopHLReturn_1E


;@ def ApplyFrequencyEffect_1E(p: hl, reg: c)
;@ path: sound/music/engine
;@ The frequency effect of the note (p = the channel's +8): type 1 is the vibrato; any other type plays the
;@ note one frequency step lower (a slight detune), rewritten every frame without restarting the note.
;@ (Bank $1B's wide vibrato, type 5, is a detune here.)
;@ test: skip pops what UpdateNoteEffects_1E pushed
ApplyFrequencyEffect_1E::
;> freq = (mem[p + 1] | mem[p + 2] << 8) & 0x0FFF  # the note's frequency (+9, +A)
	inc l
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0f
	ld d, a
;> frames = mem[p + 6]                              # +E: frames since the note started
	push de
	ld a, l
	add $04
	ld l, a
	ld b, [hl]
;> if wMusicEffect == 1: return UpdateVibrato_1E()
	ld a, [wMusicEffect]
	cp $01
	jp z, UpdateVibrato_1E

;> WriteEffectFrequency_1E(u16(freq - 1), reg)
	ld hl, -1
	pop de
	add hl, de
	call WriteEffectFrequency_1E
;> return UpdateDropAndWaveEffects_1E()
	jp UpdateDropAndWaveEffects_1E


;@ def UpdateReleaseEnvelopes_1E()
;@ path: sound/music/engine
;@ The release of the square channels: when a note (not a rest) with a release in instrument byte +7
;@ reaches its release frame, its envelope is switched to ReleaseEnvelopes_1E entry (+7 low nibble - 1)
;@ and the note restarted on the same frequency. Not while an effect holds the channel.
;@ test: wMusicChannel1[0x0B] = rng.choice([0, 0, 1]); wMusicChannel1[7] = rng.choice([0, 0x21, 0x83, 0x45])
;@ test: wMusicChannel1[0x0E] = rand(0, 4); wMusicReleaseFrame[0] = rand(0, 4); wMusicChannel1[0x0F] = rng.choice([0, 0x80])
;@ test: wMusicChannel2[0x0B] = rng.choice([0, 0, 1]); wMusicChannel2[7] = rng.choice([0, 0x21, 0x83, 0x45])
;@ test: wMusicChannel2[0x0E] = rand(0, 4); wMusicReleaseFrame[1] = rand(0, 4); wMusicChannel2[0x0F] = rng.choice([0, 0x80])
;@ test: wCurrentBank = $1E
UpdateReleaseEnvelopes_1E::
;> if not wMusicChannel1[0x0B] and wMusicChannel1[7]:     # channel 1: no rest, a release
	ld a, [wMusicChannel1 + $0B]
	and a
	jr nz, .channel2

	ld a, [wMusicChannel1 + $07]
	and a
	jr z, .channel2

;>     env = wMusicChannel1[7] & 0x0F
	and $0f
	ld b, a
;>@if1     if wMusicChannel1[0x0E] == wMusicReleaseFrame[0] and not wMusicChannel1[0x0F] & 0x80:
	ld hl, wMusicReleaseFrame
	ld a, [wMusicChannel1 + $0E]
	cp [hl]
	jr nz, .channel2

;=@if1
	ld c, $12
	ld de, wMusicChannel1 + $0A
	ld a, [wMusicChannel1 + $0F]
	bit 7, a
	jr nz, .channel2

;>         SetReleaseEnvelope_1E(env, 0x12, wMusicChannel1 + 0x0A)   # NR12, NR14
	call SetReleaseEnvelope_1E

;> if wMusicChannel2[0x0B]: return                  # channel 2 the same way
.channel2
	ld a, [wMusicChannel2 + $0B]
	and a
	ret nz

;> if not wMusicChannel2[7]: return
	ld a, [wMusicChannel2 + $07]
	and a
	ret z

;> env = wMusicChannel2[7] & 0x0F
	and $0f
	ld b, a
;> if wMusicChannel2[0x0E] != wMusicReleaseFrame[1]: return
	ld hl, wMusicReleaseFrame + 1
	ld a, [wMusicChannel2 + $0E]
	cp [hl]
	ret nz

;> if wMusicChannel2[0x0F] & 0x80: return
	ld a, [wMusicChannel2 + $0F]
	bit 7, a
	ret nz

;> SetReleaseEnvelope_1E(env, 0x17, wMusicChannel2 + 0x0A)       # NR22, NR24
	ld c, $17
	ld de, wMusicChannel2 + $0A
	call SetReleaseEnvelope_1E
	ret


;@ def SetReleaseEnvelope_1E(env: b, reg: c, hi: de)
;@ path: sound/music/engine
;@ Writes release envelope env (1-7) of ReleaseEnvelopes_1E to NRx2 (reg) and restarts the note with the
;@ frequency high byte at hi (NRx4 = reg + 2). (An env of 0 would read the byte 255 bytes
;@ after the table start.)
;@ test: env = rand(1, 7); reg = rng.choice([0x12, 0x17]); hi = rng.choice([0xD31A, 0xD32A])
SetReleaseEnvelope_1E::
;>@env mem[0xFF00 + reg] = mem[ReleaseEnvelopes_1E + u8(env - 1)]
	push bc
	dec b
	ld c, b
	ld b, $00
	ld hl, ReleaseEnvelopes_1E
	add hl, bc
;=@env
	ld a, [hl]
	pop bc
	ldh [c], a
;> mem[0xFF00 + reg + 2] = mem[hi] | 0x80             # restart the note
	inc c
	inc c
	ld a, [de]
	or $80
	ldh [c], a
	ret


;@ def ResumeMusicAfterFanfare_1E()
;@ path: sound/music/engine
;@ The fanfare track $25 is over: the track in hLastMusicTrack is requested again and the
;@ music update starts over with it.
;@ test: skip restarts the whole music update
ResumeMusicAfterFanfare_1E::
;> wMusicFromBank1B = 0
	xor a
	ld [wMusicFromBank1B], a
;> wMusicTrackToPlay = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
;> return UpdateMusic_1E()
	jp UpdateMusic_1E


;@ def BlockWaveSfxCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $96: wave-channel sound effects are not played until command $95.
;@ test: skip goes on reading the pattern
BlockWaveSfxCommand_1E::
;> wMusicBlocksWaveSfx = 1
	ld a, $01

.store
	ld [wMusicBlocksWaveSfx], a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jp ReadPattern_1E


;@ def AllowWaveSfxCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $95: wave-channel sound effects play again.
;@ test: skip goes on reading the pattern
AllowWaveSfxCommand_1E::
;> wMusicBlocksWaveSfx = 0; AdvancePointer_1E(ptr); return ReadPattern_1E(ptr)   # (BlockWaveSfxCommand_1E.store)
	xor a
	jr BlockWaveSfxCommand_1E.store

;@ def WaveDecayOnCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $99: from the next note on, every wave note decays (UpdateWaveDecay_1E).
;@ test: skip goes on reading the pattern
WaveDecayOnCommand_1E::
;> wMusicWaveDecay = 1
	ld a, $01

.store
	ld [wMusicWaveDecay], a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jp ReadPattern_1E


;@ def WaveEffectsOffCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9A: the wave notes keep their level again; here it ends the swell ($94) as well as the
;@ decay.
;@ test: skip goes on reading the pattern
WaveEffectsOffCommand_1E::
;> wMusicWaveSwell = 0
	xor a
	ld [wMusicWaveSwell], a
;> wMusicWaveSwellFrame = 0
	ld [wMusicWaveSwellFrame], a
;> wMusicWaveDecay = 0; AdvancePointer_1E(ptr); return ReadPattern_1E(ptr)   # (WaveDecayOnCommand_1E.store)
	jr WaveDecayOnCommand_1E.store

;@ def UpdateWaveDecay_1E(state: a)
;@ path: sound/music/engine
;@ The decay of a wave note: NR32 goes to half level at frame 3, a quarter at 5, off at 7, a quarter at 10
;@ (an echo) and off for good at 13, where the decay is done (state 2) until the next note.
;@ test: skip pops what UpdateNoteEffects_1E pushed
UpdateWaveDecay_1E::
;> if state == 2: return
	cp $02
	jp z, PopHLReturn_1E

;> wMusicWaveDecayFrame += 1; frame = wMusicWaveDecayFrame   # (IncrementByte_1E)
	ld bc, wMusicWaveDecayFrame
	call IncrementByte_1E
;> if frame == 3: level = 0x40                      # half
	ld c, $1c
	ld b, $40
	cp $03
	jr z, WriteWaveLevel_1E

;>@q elif frame in (5, 0x0A): level = 0x60            # a quarter
	ld b, $60
	cp $05
	jr z, WriteWaveLevel_1E

;=@q
	cp $0a
	jr z, WriteWaveLevel_1E

;> elif frame == 7: level = 0
	ld b, $00
	cp $07
	jr z, WriteWaveLevel_1E

;> elif frame == 0x0D:
	cp $0d
	jp nz, PopHLReturn_1E

;>     level = 0
;>     wMusicWaveDecay = 2
	ld a, $02
	ld [wMusicWaveDecay], a

;> else: return
;> rNR32 = level
WriteWaveLevel_1E:
	ld a, b
	ldh [c], a
;> return
	jp PopHLReturn_1E


;@ def IncrementByte_1E(p: bc) -> a
;@ path: sound/music/engine
;@ Adds 1 to the byte at p and returns it.
;@ test: p = rand_ram(1)
IncrementByte_1E::
;> mem[p] = u8(mem[p] + 1)
	ld a, [bc]
	inc a
	ld [bc], a
;> return mem[p]
	ret


;@ def WaveSwellCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $94: from the next note on, every wave note swells in (UpdateWaveSwell_1E).
;@ test: skip goes on reading the pattern
WaveSwellCommand_1E::
;> wMusicWaveSwell = 1
	ld a, $01
	ld [wMusicWaveSwell], a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jp ReadPattern_1E


;@ def UpdateWaveSwell_1E(state: a)
;@ path: sound/music/engine
;@ The swell of a wave note: NR32 goes to a quarter at frame 3, half at 5 and full at 6, where the swell
;@ is done (state 2) until the next note.
;@ test: skip pops what UpdateNoteEffects_1E pushed
UpdateWaveSwell_1E::
;> if state == 2: return
	cp $02
	jp z, PopHLReturn_1E

;> wMusicWaveSwellFrame += 1; frame = wMusicWaveSwellFrame     # (IncrementByte_1E)
	ld bc, wMusicWaveSwellFrame
	call IncrementByte_1E
;> if frame == 3: return WriteWaveLevel_1E(0x60)   # a quarter
	ld c, $1c
	ld b, $60
	cp $03
	jp z, WriteWaveLevel_1E

;> if frame == 5: return WriteWaveLevel_1E(0x40)   # half
	ld b, $40
	cp $05
	jp z, WriteWaveLevel_1E

;> if frame != 6: return
	ld b, $20
	cp $06
	jp nz, PopHLReturn_1E

;> wMusicWaveSwell = 2
	ld a, $02
	ld [wMusicWaveSwell], a
;> return WriteWaveLevel_1E(0x20)                  # full
	jp WriteWaveLevel_1E


;@ def PitchDropOnCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $97: from now on the channel's notes slide down quickly (UpdatePitchDrop_1E), until
;@ command $98.
;@ test: skip goes on reading the pattern
PitchDropOnCommand_1E::
;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1E
;> mem[drop] = 1
	ld a, $01

.store
	ld [de], a
;> AdvancePointer_1E(ptr)
	call AdvancePointer_1E
;> return ReadPattern_1E(ptr)
	jp ReadPattern_1E


;@ def PitchDropOffCommand_1E(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $98: the pitch drop is off again.
;@ test: skip goes on reading the pattern
PitchDropOffCommand_1E::
;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1E
;> mem[drop] = 0; AdvancePointer_1E(ptr); return ReadPattern_1E(ptr)   # (PitchDropOnCommand_1E.store)
	xor a
	jr PitchDropOnCommand_1E.store

;@ def UpdatePitchDrop_1E(drop: de, reg: c, channel)
;@ path: sound/music/engine
;@ The pitch drop: in the first frame the note's own frequency, after that the one written last, goes
;@ down by 100 every frame (written without restarting the note).
;@ test: skip pops what UpdateNoteEffects_1E pushed
UpdatePitchDrop_1E::
;> if not mem[drop + 1]:                            # first frame of the note
	inc e
	ld a, [de]
	and a
	jr nz, .continue

;>     mem[drop + 1] = 1
	inc a
	ld [de], a
;>     f = GetNoteFrequency_1E(channel)   # the channel record UpdateNoteEffects_1E pushed
	pop hl
	push hl
	call GetNoteFrequency_1E

;>@else else:
;>@cont     f = GetEffectFrequency_1E()
;> WriteEffectFrequency_1E(u16(f - 100), reg)
.drop
	ld hl, -100
	add hl, de
	call WriteEffectFrequency_1E
;> return
	jp PopHLReturn_1E


;=@else
;=@cont
.continue
	call GetEffectFrequency_1E
	jr .drop

;@ def GetNoteFrequency_1E(timer: hl) -> de
;@ path: sound/music/engine
;@ The frequency of the channel's note (+9, +A; 11 bits).
;@ test: n = rand(1, 3); timer = 0xD302 + 0x10 * n
GetNoteFrequency_1E::
;>@r return (mem[timer + 7] | mem[timer + 8] << 8) & 0x0FFF
	ld a, $07
	add l
	ld l, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
;=@r
	and $0f
	ld d, a
	ret


;@ def WriteEffectFrequency_1E(f: hl, reg: c)
;@ path: sound/music/engine
;@ Writes a changed frequency to NRx3 / NRx4 (reg, reg + 1) without restarting the note, and keeps it in
;@ wMusicEffectFreq for the channel.
;@ test: wMusicChannel = rand(1, 3); f = rand(0, 0xFFFF); reg = rng.choice([0x13, 0x18, 0x1D])
WriteEffectFrequency_1E::
;> keep = wMusicEffectFreq + 2 * (wMusicChannel - 1)
	ld de, wMusicEffectFreq
	call ChannelPairOffset_1E
;> mem[0xFF00 + reg] = lo(f)
	ld a, l
	ldh [c], a
;> mem[keep] = lo(f)
	ld [de], a
;> mem[0xFF00 + reg + 1] = hi(f) & 0x0F
	inc c
	inc e
	ld a, h
	and $0f
	ldh [c], a
;> mem[keep + 1] = hi(f) & 0x0F
	ld [de], a
	ret


;@ def ChannelPairOffset_1E(base: de) -> de
;@ path: sound/music/engine
;@ base + 2 * (wMusicChannel - 1): the channel's pair of bytes in a table with 2 bytes per channel (the
;@ table stays inside its 256-byte page).
;@ test: wMusicChannel = rand(1, 3); base = rng.choice([0xD3A4, 0xD3B0, 0xD3B6, 0xD3D0])
ChannelPairOffset_1E::
;> return (base & 0xFF00) | lo(base + 2 * (wMusicChannel - 1))
	ld a, [wMusicChannel]
	dec a
	sla a
	add e
	ld e, a
	ret


;@ def GetEffectFrequency_1E() -> de
;@ path: sound/music/engine
;@ The frequency the channel's pitch effect wrote last (wMusicEffectFreq).
;@ test: wMusicChannel = rand(1, 3)
GetEffectFrequency_1E::
;> keep = wMusicEffectFreq + 2 * (wMusicChannel - 1)
	ld de, wMusicEffectFreq
	call ChannelPairOffset_1E
;>@k return mem[keep] | mem[keep + 1] << 8
	ld a, [de]
	ld l, a
	inc e
;=@k
	ld a, [de]
	ld d, a
	ld e, l
	ret


;@ def UpdateVibrato_1E(timer: stack, reg: c)
;@ path: sound/music/engine
;@ The vibrato (effect 1): it starts 24 frames into the note; from then on the note's frequency gets the
;@ offsets of VibratoOffsets_1E, one per frame, over and over (20 frames).
;@ test: skip pops what UpdateNoteEffects_1E pushed
UpdateVibrato_1E::
;> v = wMusicVibrato + 2 * (wMusicChannel - 1)     # frame counter, running flag
	pop de
	ld de, wMusicVibrato
	call ChannelPairOffset_1E
;> mem[v] += 1
	ld a, [de]
	inc a
	ld [de], a
;> if mem[v] == 0x19: mem[v + 1] = 1               # 25th frame: it starts
	inc e
	cp $19
	jr z, .start

;> elif mem[v] == 0x2D: mem[v] = 0x19              # after 20 frames: again from the top
	cp $2d
	jr z, .wrap

;> elif not mem[v + 1]: return UpdateDropAndWaveEffects_1E()
	ld a, [de]
	and a
	jp z, UpdateDropAndWaveEffects_1E

;> idx = mem[v] - 0x19
.apply
	dec e
	ld a, [de]
	sub $19
;> o = VibratoOffsets_1E + 2 * idx
	sla a
	ld l, a
	ld h, $00
	ld de, VibratoOffsets_1E
	add hl, de
;> offset = mem[o] << 8 | mem[o + 1]               # high byte first
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
;> f = GetNoteFrequency_1E(timer)
	pop hl
	push hl
	push de
	call GetNoteFrequency_1E
;> WriteEffectFrequency_1E(u16(f + offset), reg)
	ld h, d
	ld l, e
	pop de
	add hl, de
	call WriteEffectFrequency_1E
;> return UpdateDropAndWaveEffects_1E()
	jp UpdateDropAndWaveEffects_1E


;> # (.wrap: mem[v] = $19; .start: mem[v + 1] = 1 - then .apply)
.wrap
	dec e
	ld a, $19
	ld [de], a
	inc e
	jr .apply

;> #
.start
	ld a, $01
	ld [de], a
	jr .apply

;@ path: sound/music/data
;@ Vibrato (effect 1): 20 frequency offsets, one per frame, stored high byte first (UpdateVibrato_1E). Values 0, 0, 1, 1, 2, 2, 0, 0, -1, -1, -2, -2, 0, 1, 2, 1, 0, -1, -2, -1.
VibratoOffsets_1E::
	db $00, $00, $00, $00, $00, $01, $00, $01
	db $00, $02, $00, $02, $00, $00, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe
	db $00, $00, $00, $01, $00, $02, $00, $01
	db $00, $00, $ff, $ff, $ff, $fe, $ff, $ff

;@ path: sound/music/data
;@ Frequency register value of each note (2 bytes, NRx3 then NRx4 bits 0-2), indexed by the note byte: $02 = C2 (65 Hz) ... $90 = D8, one semitone per 2. Entry 0 is never played.
NoteFrequencies_1E::
	dw $0F00, $002C, $009C, $0106, $016B, $01C9, $0223, $0277
	dw $02C6, $0312, $0356, $039B, $03DA, $0416, $044E, $0483
	dw $04B5, $04E5, $0511, $053B, $0563, $0589, $05AC, $05CE
	dw $05ED, $060A, $0627, $0642, $065B, $0672, $0689, $069E
	dw $06B2, $06C4, $06D6, $06E7, $06F7, $0706, $0714, $0721
	dw $072D, $0739, $0744, $074F, $0759, $0762, $076B, $0774
	dw $077B, $0783, $078A, $0790, $0797, $079D, $07A2, $07A7
	dw $07AC, $07B1, $07B6, $07BA, $07BE, $07C1, $07C5, $07C8
	dw $07CB, $07CE, $07D1, $07D4, $07D6, $07D9, $07DB, $07DD
	dw $07DF

;@ path: sound/music/data
;@ Drums of the noise channel, indexed by the note byte ($01, $06, $0B, ... in steps of 5): 5 bytes each - NR42 envelope, unused, NR41 length, NR43 noise, NR44 (bit 6: stop after the length). $01 is silence (NR42 = 0). Note $FF plays the two-step drum of UpdateDrumFF_1E instead.
DrumSounds_1E::
	db $00 ; (offset 0)
	db $00, $00, $00, $00, $c0 ; drum $01
	db $09, $00, $38, $34, $c0 ; drum $06
	db $19, $00, $38, $33, $c0 ; drum $0B
	db $46, $00, $13, $10, $c0 ; drum $10
	db $23, $00, $20, $40, $80 ; drum $15
	db $51, $00, $20, $07, $80 ; drum $1A
	db $a1, $00, $00, $18, $80 ; drum $1F
	db $f2, $00, $00, $18, $80 ; drum $24
	db $81, $00, $3a, $10, $c0 ; drum $29
	db $80, $00, $00, $10, $c0 ; drum $2E
	db $57, $00, $00, $60, $80 ; drum $33
	db $10, $00, $00, $10, $80 ; drum $38

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 32 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. No song uses it.
NoteLengths32_1E::
	db $01, $02, $04, $08, $10, $20, $06, $0c, $18, $01, $01, $01, $01, $01, $30

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 48 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $19, $23, $2A, $54.
NoteLengths48_1E::
	db $01, $03, $06, $0c, $18, $30, $09, $12, $24, $02, $04, $08, $01, $01, $48

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 64 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $1B, $1D, $23, $53, $5F.
NoteLengths64_1E::
	db $02, $04, $08, $10, $20, $40, $0c, $18, $30, $02, $05, $03, $01, $01, $60

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 80 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $14, $15, $17, $1E, $1F, $22, $2B, $50, $52, $54, $57, $5C.
NoteLengths80_1E::
	db $03, $05, $0a, $14, $28, $50, $0f, $1e, $3c, $02, $08, $10, $02, $01, $78

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 96 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $1A, $1C, $1E, $24, $26, $27, $2C, $49, $4F, $53, $55, $59, $5A, $5E.
NoteLengths96_1E::
	db $03, $06, $0c, $18, $30, $60, $12, $24, $48, $03, $08, $10, $02, $04, $90

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 112 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $11, $16, $18, $1A, $23, $25, $29, $2E, $2F, $41, $42, $43, $44, $45, $46, $47, $48, $4A, $4B, $4C, $4E, $5B, $60.
NoteLengths112_1E::
	db $03, $07, $0e, $1c, $38, $70, $15, $2a, $54, $04, $09, $12, $02, $01, $a8

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 128 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $13, $1A, $20, $21, $25, $2D, $4D, $4E, $51, $58, $5D.
NoteLengths128_1E::
	db $04, $08, $10, $20, $40, $80, $18, $30, $60, $04, $02, $01, $01, $00, $c0
;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 144 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $12, $28, $56.
NoteLengths144_1E::
	db $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $05, $0c, $18, $18, $06, $d8

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 160 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $30.
NoteLengths160_1E::
	db $05, $0a, $14, $28, $50, $a0, $1e, $3c, $78, $05, $01, $01, $01, $01, $f0

;@ path: sound/music/data
;@ Release envelopes (NRx2 values) for square notes: instrument byte 2, low nibble n (1-7) picks entry n-1, written at the release frame of each note (UpdateReleaseEnvelopes_1E).
ReleaseEnvelopes_1E::
	db $10, $32, $22, $47, $60, $20, $00

;@ path: sound/music/songs
;@ A pattern list that repeats 32 rests of the longest length forever: the channel stays silent. Used by tracks $14, $17, $1C, $1E, $1F, $20, $21, $22, $24, $26, $28, $29, $2A, $2C, $2D, $2E, $41, $52, $56, $58, $59, $5C, $5D, $5E.
MusicSilentChannel_1E::
.m14Sq1: ; square 1 pattern list (tracks $14, $17, $1C, $1E, $1F, $20, $21, $22, $24, $26, $28, $29, $2A, $2C, $2D, $2E, $41, $52, $56, $58, $59, $5C, $5D, $5E)
	dw .m14Pat1, $FFFF, MusicSilentChannel_1E
.m14Pat1: ; tracks $14, $17, $1C, $1E, $1F, $20, $21, $22, $24, $26, $28, $29, $2A, $2C, $2D, $2E, $41, $52, $56, $58, $59, $5C, $5D, $5E
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $49: Power-up.
;@ Where: SelectAreaMusic while a piece of power or acorn works; Collect_PieceOfPower.
;@ Entry 41 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music49::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw Music27.m49Sq1, Music27.m49Sq2, Music27.m49Wave, Music27.m49Noise

;@ path: sound/music/songs
;@ Music track $27: Piece of power.
;@ Where: Collect_PieceOfPower.
;@ Entry 23 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music27::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw .pat1
.m49Sq1: ; square 1 pattern list
	dw .m49Pat1, $FFFF, .m49Sq1
.sq2: ; square 2 pattern list
	dw .pat2
.m49Sq2: ; square 2 pattern list
	dw .m49Pat2, $FFFF, .m49Sq2
.wave: ; wave pattern list
	dw .pat3
.m49Wave: ; wave pattern list
	dw .m49Pat3, $FFFF, .m49Wave
.noise: ; noise pattern list
	dw .pat4
.m49Noise: ; noise pattern list
	dw .m49Pat4, $FFFF, .m49Noise
.pat1:
	db $a5, $01, $a8, $01, $aa, $01, $00
.m49Pat1:
	db $9d, $10, $00, $80
	db $9b, $04, $a1, $7c, $76, $6e, $64, $9c
	db $9b, $04, $7e, $78, $70, $66, $9c
	db $9b, $04, $7c, $76, $6e, $64, $9c
	db $9b, $04, $78, $72, $6a, $60, $9c, $00
.pat2:
	db $9d, $60, $81, $41, $aa, $01, $56, $60, $6a, $60, $66, $a5, $64, $a3, $01, $00
.m49Pat2:
	db $9d, $34, $00, $00
	db $9b, $03, $a1, $7c, $76, $6e, $64, $9c
	db $9d, $43, $00, $00, $7c, $76, $6e, $64
	db $9d, $62, $00, $00, $7e, $78, $70, $66
	db $9d, $43, $00, $00, $7e, $78, $70, $66
	db $9d, $34, $00, $00
	db $9b, $02, $7e, $78, $70, $66, $9c
	db $9b, $02, $7c, $76, $6e, $64, $9c
	db $9d, $43, $00, $00, $7c, $76, $6e, $64
	db $9d, $62, $00, $00, $7c, $76, $6e, $64
	db $9d, $82, $00, $00, $78, $72, $6a, $60
	db $9d, $62, $00, $00, $78, $72, $6a, $60
	db $9d, $43, $00, $00
	db $9b, $02, $78, $72, $6a, $60, $9c, $00
.waveform1: ; wave pattern: 32 4-bit samples
	db $66, $66, $66, $66, $00, $00, $00, $00, $66, $66, $66, $66, $00, $00, $00, $00
.waveform2: ; wave pattern: 32 4-bit samples
	db $00, $22, $44, $55, $66, $66, $88, $88, $aa, $aa, $cc, $cc, $04, $84, $04, $84
.pat3:
	db $a5, $01, $a8, $01, $00
.m49Pat3:
	db $9d
	dw .waveform1
	db $20, $99
	db $9b, $20, $a2, $04, $1c, $9c, $00
.pat4:
	db $a5, $01, $a8, $01, $00
.m49Pat4:
	db $9b, $20, $a2, $1a, $a1, $1a, $1a, $9c, $00

;@ path: sound/music/songs
;@ Music track $50: Boss.
;@ Where: LanmolaHandler and other bosses (hDefaultMusicTrack).
;@ Entry 48 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music50::
	db $02 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw .pat5, .pat6, .pat7, .pat6, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2, .pat5, .pat3, .pat6, .pat4, .pat7, .pat3, .pat6
	dw $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat8, $FFFF, .wave
.noise: ; noise pattern list
	dw .pat9, $FFFF, .noise
.pat1:
	db $9d, $43, $00, $03, $a0, $01, $00
.pat2:
	db $9d, $43, $00, $00, $00
.pat3:
	db $9d, $71, $00, $00, $00
.pat4:
	db $9d, $91, $00, $00, $00
.pat5:
	db $9b, $02, $a1, $48, $4c, $4e, $a6, $5c, $a1, $48, $4c, $4e, $a6, $5a, $a3, $01
	db $9c, $00
.pat6:
	db $9b, $02, $a1, $4c, $50, $52, $a6, $60, $a1, $4c, $50, $52, $a6, $5e, $a3, $01
	db $9c, $00
.pat7:
	db $9b, $02, $a1, $50, $54, $56, $a6, $64, $a1, $50, $54, $56, $a6, $62, $a3, $01
	db $9c, $00
.pat8:
	db $9d
	dw Music27.waveform2
	db $20, $99
	db $9b, $02, $a2, $30, $18, $18, $30, $18, $18, $30, $18, $9c
	db $9b, $02, $34, $1c, $1c, $34, $1c, $1c, $34, $1c, $9c
	db $9b, $02, $38, $20, $20, $38, $20, $20, $38, $20, $9c
	db $9b, $02, $34, $1c, $1c, $34, $1c, $1c, $34, $1c, $9c, $00
.pat9:
	db $9b, $02, $a1, $1a, $1a, $1a, $a6, $1a, $9c, $a1, $1a, $15, $15, $15, $00

;@ def SilenceMusicAndNoise_1E()
;@ path: sound/music/engine
;@ Entry $4003 (not used by the game): ends any noise effect, silences the noise channel and stops the
;@ music (EndMusic_1E).
;@ test: skip resets the whole music state
SilenceMusicAndNoise_1E::
;> wActiveNoiseSfx = 0
	xor a
	ld [wActiveNoiseSfx], a
;> wMusicChannel4[0x0F] = 0
	ld [wMusicChannel4 + $0F], a
;> wNoiseSfxStep = 0
	ld [wNoiseSfxStep], a
;> wNoiseSfxTimer = 0
	ld [wNoiseSfxTimer], a
;> wNoiseSfxLocked = 0
	ld [wNoiseSfxLocked], a
;> wSoundUnusedA3 = 0
	ld [wSoundUnusedA3], a
;> wSoundUnusedE5 = 0
	ld [wSoundUnusedE5], a
;> rNR42 = 0x08                              # volume 0
	ld a, $08
	ldh [rNR42], a
;> rNR44 = 0x80
	ld a, $80
	ldh [rNR44], a
;> return EndMusic_1E()                      # falls through

;@ def EndMusic_1E()
;@ path: sound/music/engine
;@ The music is over: all channels on both sides again, no song playing, and the music state reset.
;@ test: skip resets the whole music state
EndMusic_1E::
;> rNR51 = 0xFF
	ld a, $ff
	ldh [rNR51], a
;> wMusicPanMode = 3
	ld a, $03
	ld [wMusicPanMode], a
;> wActiveMusicTrack = 0
	xor a
	ld [wActiveMusicTrack], a
;> return ResetMusicState_1E()               # falls through

;@ def ResetMusicState_1E()
;@ path: sound/music/engine
;@ Clears the effect flags of the music channels and the state of the square- and wave-channel sound
;@ effects (they stop too), the wave and pitch effects, and silences square channels 1-2, the sweep and
;@ the wave channel. The noise channel is left alone.
ResetMusicState_1E::
;> wActiveJingle = 0
	xor a
	ld [wActiveJingle], a
;> wActiveWaveSfx = 0
	ld [wActiveWaveSfx], a
;> wMusicChannel1[0x0F] = 0                     # the channels belong to the music again
	ld [wMusicChannel1 + $0F], a
;> wMusicChannel2[0x0F] = 0
	ld [wMusicChannel2 + $0F], a
;> wMusicChannel3[0x0F] = 0
	ld [wMusicChannel3 + $0F], a
;> wMusicWaveDecay = 0
	ld [wMusicWaveDecay], a
;> wMusicWaveDecayFrame = 0
	ld [wMusicWaveDecayFrame], a
;> wMusicWaveSwell = 0
	ld [wMusicWaveSwell], a
;> wMusicWaveSwellFrame = 0
	ld [wMusicWaveSwellFrame], a
;>@pd for i in range(6): wMusicPitchDrop[i] = 0
	ld [wMusicPitchDrop], a
	ld [wMusicPitchDrop + 1], a
	ld [wMusicPitchDrop + 2], a
;=@pd
	ld [wMusicPitchDrop + 3], a
	ld [wMusicPitchDrop + 4], a
	ld [wMusicPitchDrop + 5], a
;> wJingleStep = 0
	ld [wJingleStep], a
;> wUnusedSfxStep = 0
	ld [wUnusedSfxStep], a
;> wWaveSfxStep = 0
	ld [wWaveSfxStep], a
;> wJingleTimer = 0
	ld [wJingleTimer], a
;> wUnusedSfxTimer = 0
	ld [wUnusedSfxTimer], a
;> wWaveSfxTimer = 0
	ld [wWaveSfxTimer], a
;> wJingleLocked = 0
	ld [wJingleLocked], a
;> wUnusedSfxLocked = 0
	ld [wUnusedSfxLocked], a
;> wWaveSfxLocked = 0
	ld [wWaveSfxLocked], a
;> wSoundUnusedA0 = 0
	ld [wSoundUnusedA0], a
;> wSoundUnusedA1 = 0
	ld [wSoundUnusedA1], a
;> wSoundUnusedA2 = 0
	ld [wSoundUnusedA2], a
;> wMusicBlocksWaveSfx = 0
	ld [wMusicBlocksWaveSfx], a
;> wSfxFastVariant = 0
	ld [wSfxFastVariant], a
;> wJingle22Count = 0
	ld [wJingle22Count], a
;> wSoundUnusedD8 = 0
	ld [wSoundUnusedD8], a
;> wWaveSfx1ECount = 0
	ld [wWaveSfx1ECount], a
;> wWaveRamDirty = 0
	ld [wWaveRamDirty], a
;> wJingleSubStep = 0
	ld [wJingleSubStep], a
;> wSoundUnusedE3 = 0
	ld [wSoundUnusedE3], a
;> wSoundUnusedE4 = 0
	ld [wSoundUnusedE4], a
;> rNR12 = 0x08                              # square channels: volume 0
	ld a, $08
	ldh [rNR12], a
;> rNR22 = 0x08
	ldh [rNR22], a
;> rNR14 = 0x80                              # restarted: silent
	ld a, $80
	ldh [rNR14], a
;> rNR24 = 0x80
	ldh [rNR24], a
;> rNR10 = 0                                 # no sweep
	xor a
	ldh [rNR10], a
;> rNR30 = 0                                 # wave DAC off
	ldh [rNR30], a
	ret


;@ path: data/padding
;@ Unused space of bank $1E, filled with $FF.
Padding_1E_4DA4::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

;@ path: sound/music/songs
;@ Music track $1A: requested in bank $01.
;@ Entry 10 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1A::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat22, .pat1, MusicCommonData_1E.m1APat30, .pat2, MusicCommonData_1E.m1APat29, MusicCommonData_1E.m1APat24, .pat3, MusicCommonData_1E.m1APat21
	dw MusicCommonData_1E.m1APat16, .pat10, .pat10, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat31, MusicCommonData_1E, MusicCommonData_1E.m1APat21, .pat11
	dw .pat12, $0000
.sq2: ; square 2 pattern list
	dw .pat4, MusicCommonData_1E.m1APat30, MusicCommonData_1E.m1APat20, .pat5, MusicCommonData_1E.m1APat29, .pat6, MusicCommonData_1E.m1APat19, .pat10
	dw MusicCommonData_1E.m1APat21, .pat10, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat31, MusicCommonData_1E.m1APat18, .pat11, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat23
	dw .pat12, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat26, .pat7, MusicCommonData_1E.m1APat30, .pat8, MusicCommonData_1E.m1APat29, MusicCommonData_1E.m1APat25, .pat9, MusicCommonData_1E.m1APat27
	dw MusicCommonData_1E.m1APat15, .pat10, MusicCommonData_1E.m1APat28, .pat10, $FFFF, MusicCommonData_1E.m1AWave
.pat1:
	db $9b, $02, $a2, $12, $2a, $12, $18, $30, $9c, $16, $2e, $16, $1c, $34, $16, $2e
	db $14, $2c
	db $9b, $02, $a2, $12, $2a, $12, $18, $30, $9c, $1a, $32, $1a, $20, $38, $1a, $32
	db $18, $30
	db $9b, $02, $16, $2e, $16, $1c, $34, $9c, $22, $3a, $22, $28, $40, $00
.pat2:
	db $a2, $16, $2e, $16, $1c, $34, $00
.pat3:
	db $a2, $22, $3a, $22, $28, $40, $a2, $2e, $46, $2e, $34, $4c, $a5, $01, $00
.pat4:
	db $9d, $97, $86, $80, $a7, $42, $a4, $34, $a6, $01, $a1, $38, $3a, $3e, $a3, $40
	db $a4, $58, $a7, $01, $42, $a4, $34, $a6, $01, $a1, $38, $3a, $4c, $a3, $4a, $a4
	db $48, $a7, $01
	db $9d, $b7, $86, $80, $a7, $46, $a4, $38, $a6, $01, $a1, $3e, $40, $42, $a3, $44
	db $a7, $5c, $00
.pat5:
	db $a3, $32, $a7, $4a, $00
.pat6:
	db $9d, $89, $86, $81, $a3, $48, $a7, $60, $a8, $80, $01, $a2, $01, $00
.pat7:
	db $9b, $02, $a2, $04, $1c, $04, $0a, $22, $9c, $08, $20, $08, $0e, $26, $08, $20
	db $06, $1e
	db $9b, $02, $04, $1c, $04, $0a, $22, $9c, $0c, $24, $0c, $12, $2a, $0c, $24, $0a
	db $22
	db $9b, $02, $08, $20, $08, $0e, $26, $9c, $14, $2c, $14, $1a, $32, $00
.pat8:
	db $a2, $08, $20, $08, $0e, $26, $00
.pat9:
	db $a2, $14, $2c, $14, $1a, $32, $a2, $20, $38, $20, $26, $3e, $a5, $01, $00
.pat10: ; tracks $1A, $1E
	db $a1, $48, $50, $54, $5c, $60, $68, $6c, $74, $00
.pat11:
	db $a3, $3c, $2e, $01, $a1, $2e, $32, $36, $38, $a3, $01, $38, $2a, $a1, $2a, $2e
	db $32, $36, $a2, $01, $6c, $5e, $24, $16, $5e, $a1, $5e, $62, $66, $a6, $68, $a2
	db $68, $5a, $20, $12, $5a, $a1, $5a, $5e, $62, $66, $a2, $01, $84, $76, $3c, $2e
	db $76, $a1, $76, $7a, $7e, $a6, $80, $a2, $80, $72, $38, $2a, $72, $a1, $72, $76
	db $7a, $7e, $a2, $38, $66, $58, $38, $20, $58, $a1, $58, $5c, $5e, $62, $a2, $36
	db $62, $54, $6c, $a1, $36, $3c, $44, $4a, $4e, $54, $5c, $62, $a2, $32, $5e, $50
	db $32, $4a, $50, $a1, $50, $54, $58, $5c, $a2, $2e, $5c, $4e, $66, $a1, $2e, $36
	db $3c, $44, $46, $4e, $54, $5c, $a2, $2a, $58, $a1, $4a, $50, $58, $62, $a2, $26
	db $54, $a1, $46, $a0, $01, $a1, $4c, $a0, $01, $a1, $54, $a0, $01, $a1, $5e, $a4
	db $01, $00
.pat12:
	db $9e
	dw NoteLengths112_1E
	db $a1, $32, $3c, $46
	db $9b, $02, $0c, $01, $01, $9c, $3c, $40, $44, $46, $4a, $01, $0c, $3c, $46, $50
	db $0c, $01, $01, $0c, $01, $46, $50, $5a, $01, $0c, $0c, $01, $0c, $01, $00

;@ path: sound/music/songs
;@ Music track $11: File select.
;@ Where: FileSelectShowScreen.
;@ Entry 1 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music11::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat14
.sq1Loop:
	dw MusicCommonData_1E.m11Pat5, .pat2, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m11Pat6, .pat1, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat26, .pat3, $FFFF, .wave
.noise: ; noise pattern list
	dw .pat4, $FFFF, .noise
.pat1:
	db $a2, $46, $01, $a7, $3c, $a1, $46, $01, $46, $4a, $4e, $50, $a4, $54, $01, $a2
	db $5e, $01, $a7, $54, $a1, $5e, $01, $5e, $62, $66, $68, $a4, $6c, $01, $00
.pat2:
	db $a2, $2a, $01, $a7, $20, $a1, $2a, $01, $2a, $2e, $32, $38, $3e, $a6, $01, $a5
	db $01, $a2, $42, $01, $a3, $38, $a1, $42, $38, $32, $2a, $2e, $a6, $01, $a8, $01
	db $00
.pat3:
	db $9b, $02, $99, $a2, $16, $16, $01, $16, $9c
	db $9b, $02, $12, $12, $01, $12, $9c
	db $9b, $02, $0e, $0e, $01, $0e, $9c
	db $9b, $02, $12, $12, $01, $12, $9c, $00
.pat4:
	db $9b, $07, $a2, $1a, $a1, $1a, $1a, $9c
	db $9b, $04, $1a, $9c
	db $9b, $06, $a2, $1a, $a1, $1a, $1a, $9c
	db $9b, $08, $1a, $9c, $00

;@ path: sound/music/songs
;@ Music track $5D: Nightmare intro.
;@ Where: NightmareIntroStart.
;@ Entry 61 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5D::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw MusicSilentChannel_1E, .sq2, MusicSilentChannel_1E, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m5DPat2, Music23.m5DPat1, $FFFF, .sq2

;@ path: sound/music/songs
;@ Music track $23: Nightmare.
;@ Where: NightmareIntroCueMusic.
;@ Entry 19 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music23::
	db $00 ; transpose
	dw NoteLengths64_1E
	dw .sq1, .sq2, .wave, .noise
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m11Pat5, .pat1, MusicCommonData_1E.m23Pat37, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat30, MusicCommonData_1E.m1APat15
.sq2Loop:
	dw MusicCommonData_1E.m23Pat29, .pat10, .pat14, .pat14, .pat14, .pat15, .pat10, .pat14
	dw .pat14, .pat14, .pat15, $FFFF, .sq2Loop2
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m23Pat28, .pat2, MusicCommonData_1E.m23Pat37, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat30, MusicCommonData_1E.m1APat15
.sq1Loop:
	dw MusicCommonData_1E.m23Pat31, .pat4, .pat5, MusicCommonData_1E.m1APat16, .pat5, MusicCommonData_1E.m23Pat31, .pat6, .pat5
	dw MusicCommonData_1E.m23Pat31, .pat7, .pat5, MusicCommonData_1E.m23Pat31, .pat4, .pat5, MusicCommonData_1E.m1APat16, .pat5
	dw MusicCommonData_1E.m23Pat31, .pat6, .pat5, MusicCommonData_1E.m23Pat31, .pat7, .pat5, MusicCommonData_1E.m23Pat35, MusicCommonData_1E.m23Pat31
	dw .pat8, .pat5, MusicCommonData_1E.m1APat16, .pat5, MusicCommonData_1E.m23Pat30, MusicCommonData_1E.m23Pat33, .pat11, MusicCommonData_1E.m23Pat36
	dw .pat11, MusicCommonData_1E.m23Pat34, .pat12, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m23Pat30, .pat13, MusicCommonData_1E.m23Pat31, .pat4
	dw .pat5, MusicCommonData_1E.m1APat16, .pat5, MusicCommonData_1E.m23Pat31, .pat6, .pat5, MusicCommonData_1E.m23Pat31, .pat7
	dw .pat5, MusicCommonData_1E.m23Pat31, .pat4, .pat5, MusicCommonData_1E.m1APat16, .pat5, MusicCommonData_1E.m23Pat31, .pat6
	dw .pat5, MusicCommonData_1E.m23Pat31, .pat7, .pat5, MusicCommonData_1E.m23Pat35, MusicCommonData_1E.m23Pat31, .pat8, .pat5
	dw MusicCommonData_1E.m1APat16, .pat5, MusicCommonData_1E.m23Pat30, MusicCommonData_1E.m23Pat33, .pat11, MusicCommonData_1E.m23Pat36, .pat11, MusicCommonData_1E.m23Pat34
	dw .pat12, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m11Pat5, .pat13, $FFFF, .sq1Loop2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat25, .pat3, MusicCommonData_1E.m23Pat37, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat30, MusicCommonData_1E.m1APat15
.waveLoop:
	dw MusicCommonData_1E.m23Pat32, .pat9, .pat16, MusicCommonData_1E.m1APat25, .pat17, MusicCommonData_1E.m23Pat32, .pat9, .pat16
	dw MusicCommonData_1E.m1APat25, .pat17, $FFFF, .waveLoop2
.noise: ; noise pattern list
	dw .pat18, MusicCommonData_1E.m23Pat37, Music19.m23Pat27, MusicCommonData_1E.m1APat30, .pat19
.noiseLoop:
	dw .pat20, $FFFF, .noiseLoop
.pat1:
	db $a2, $4e, $4c, $4a, $48, $4e, $50, $52, $54, $a3, $01, $00
.m5DPat1:
	db $9b, $06, $a0, $48, $46, $9c
	db $9b, $0a, $46, $44, $9c
	db $9d, $68, $00, $81
	db $9b, $06, $44, $42, $9c
	db $9b, $0a, $42, $40, $9c
	db $9d, $a8, $00, $81
	db $9b, $06, $a0, $4c, $4a, $9c
	db $9b, $0a, $4a, $48, $9c
	db $9d, $78, $00, $81
	db $9b, $06, $48, $46, $9c
	db $9b, $0a, $46, $44, $9c, $00
.pat2:
	db $a2, $54, $52, $50, $4e, $54, $56, $58, $5a, $a3, $01, $00
.pat3:
	db $99, $a2, $5a, $58, $56, $54, $5a, $5c, $5e, $60, $a3, $01, $00
.pat4:
	db $a1, $40, $44, $01, $a5, $46, $a7, $01, $a1, $40, $44, $01, $46, $a2, $01, $4c
	db $00
.pat5:
	db $9d, $92, $00, $c0, $a1, $10, $01, $10, $28, $01, $1a, $1c, $01, $10, $01, $12
	db $01, $12, $04, $01, $00
.pat6:
	db $a1, $01, $a2, $5e, $a1, $01, $5e, $01, $a9, $5e, $a0, $01, $a4, $5e, $a2, $01
	db $00
.pat7:
	db $a1, $01, $a2, $64, $a1, $01, $64, $01, $a9, $64, $a0, $01, $a4, $64, $a2, $01
	db $00
.pat8:
	db $a1, $40, $44, $01, $a5, $46, $a4, $01, $a1, $01, $40, $44, $46, $50, $4e, $00
.pat9:
	db $9b, $14, $99, $a1, $32, $32, $01, $32, $4a, $01, $3c, $3e, $01, $32, $01, $34
	db $01, $34, $26, $01, $9c, $00
.pat10:
	db $a1, $04
	db $9b, $7f, $02, $9c, $a1, $04
	db $9b, $7f, $02, $9c, $a1, $04
	db $9b, $3f, $02, $9c, $00
.pat11:
	db $a1, $52, $52, $52, $50, $a3, $01, $a1, $4e, $01, $01, $4c, $a3, $01, $00
.pat12:
	db $a1, $52, $52, $52, $50, $a8, $01, $00
.pat13:
	db $a1, $46, $46, $01, $46, $01, $46, $01, $50, $01, $50, $a2, $50, $97, $a1, $01
	db $36, $2c, $24, $98, $00
.pat14:
	db $a1, $10
	db $9b, $0f, $0e, $9c, $00
.pat15:
	db $a1, $3c, $3c, $01, $3c, $01, $3c, $01, $3c, $01, $46, $a2, $46, $97, $a1, $01
	db $2c, $24, $1e, $98, $00
.pat16:
	db $9b, $03, $a1, $3e, $3e, $01, $3e, $56, $01, $48, $4a, $01, $3e, $01, $40, $01
	db $40, $32, $01, $9c, $00
.pat17:
	db $a1, $32, $32, $01, $32, $01, $32, $01, $3c, $01, $3c, $3c, $01, $a3, $01, $00
.pat18:
	db $a5, $01, $a3, $01, $00
.pat19:
	db $a6, $01, $00
.pat20:
	db $9b, $02, $a1, $1a, $1a, $1a, $15, $9c, $1a, $1a, $15, $1a, $1a, $1a, $1a, $1a
	db $00
.sq1Loop2: ; square 1 pattern list
	dw .pat21, .pat21, .pat22, $FFFF, .sq1Loop
.sq2Loop2: ; square 2 pattern list
	dw .pat23, .pat23, .pat24, $FFFF, .sq2Loop
.waveLoop2: ; wave pattern list
	dw MusicCommonData_1E.m23Pat32, .pat25, .pat25, .pat26, $FFFF, .waveLoop
.pat21:
	db $9d, $c4, $83, $80, $a1, $04
	db $9b, $1f, $02, $9c, $0a
	db $9b, $1f, $08, $9c, $00
.pat22:
	db $a1, $10
	db $9b, $0d, $0e, $9c, $10, $12
	db $9b, $0f, $14, $9c, $10
	db $9b, $0e, $0e, $9c, $10, $12
	db $9b, $07, $14, $9c, $16, $a4, $01, $00
.pat23:
	db $9d, $84, $86, $80
	db $9b, $02, $a1, $10, $10, $01, $10, $28, $01, $1a, $1c, $01, $10, $01, $12, $01
	db $12, $04, $01, $9c
	db $9b, $02, $16, $16, $01, $16, $2e, $01, $20, $22, $01, $16, $01, $18, $01, $18
	db $0c, $01, $9c, $00
.pat24:
	db $a1, $1c, $1c, $01, $1c, $34, $01, $26, $2a, $01, $1c
	db $9b, $02, $01, $1e, $9c, $12, $01, $22, $22, $01, $22, $3a, $01, $2c, $2e, $01
	db $22
	db $9b, $02, $01, $24, $9c, $18, $01, $1c, $1c, $01, $1c, $34, $01, $26, $2a, $01
	db $1c
	db $9b, $02, $01, $1e, $9c, $12, $01, $a2, $22, $22, $3a, $a1, $24, $26, $01, $26
	db $a6, $3e, $a1, $26, $0e, $26, $00
.pat25:
	db $9b, $02, $99, $a1, $32, $32, $01, $32, $4a, $01, $3c, $3e, $01, $32, $01, $34
	db $01, $34, $26, $01, $9c
	db $9b, $02, $38, $38, $01, $38, $50, $01, $42, $44, $01, $38, $01, $3a, $01, $3a
	db $2e, $01, $9c, $00
.pat26:
	db $a1, $3e, $3e, $01, $3e, $56, $01, $48, $4c, $01, $3e, $01, $40, $01, $40, $34
	db $01, $44, $44, $01, $44, $5c, $01, $4e, $50, $01, $44, $01, $46, $01, $46, $3a
	db $01, $3e, $3e, $01, $3e, $56, $01, $48, $4c, $01, $3e, $01, $40, $01, $40, $34
	db $01, $a2, $44, $44, $5c, $a1, $46, $48, $01, $48, $a6, $60, $a1, $48, $30, $48
	db $00

;@ path: sound/music/songs
;@ Music track $12: Indoor map $08.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $08.
;@ Entry 2 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music12::
	db $00 ; transpose
	dw NoteLengths144_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m11Pat5, .pat1, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat19, .pat2, MusicCommonData_1E.m12Pat22, .pat3, MusicCommonData_1E.m12Pat19, .pat4, .pat2, MusicCommonData_1E.m12Pat22
	dw .pat3, MusicCommonData_1E.m12Pat19, .pat4, MusicCommonData_1E.m12Pat20, .pat5, MusicCommonData_1E.m12Pat19, .pat4, MusicCommonData_1E.m12Pat18
	dw .pat6, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1E.m23Pat32, .pat7, .pat7, MusicCommonData_1E.m1APat25, .pat9, MusicCommonData_1E.m23Pat32, .pat8, .pat8
	dw $FFFF, .waveLoop
.pat1:
	db $9b, $10, $a5, $01, $9c, $a3, $01, $a1, $0c, $18, $24, $30, $3c, $48, $54, $60
	db $a5, $01, $a3, $01, $00
.pat2:
	db $9b, $02, $a2, $6a, $70, $6e, $74, $ae, $01, $9c, $00
.pat3:
	db $a1, $3a, $40, $3e, $44, $a4, $50, $01, $a8, $01, $00
.pat4:
	db $a8, $01, $a2, $01, $a1, $78, $76
	db $9b, $0d, $a0, $78, $76, $9c, $78, $a3, $01, $00
.pat5:
	db $a1, $6a, $70, $78, $76, $a5, $7e, $a8, $01, $00
.pat6:
	db $a3, $01
	db $9b, $0d, $a0, $78, $76, $9c, $78, $a5, $01, $00
.pat7:
	db $99, $a2, $0a, $01, $a4, $01, $a6, $01, $a1, $0a, $0a, $a6, $01, $a8, $01, $a2
	db $0a, $0a, $a4, $01, $a6, $01, $a1, $0a, $a2, $0a, $01, $a8, $01, $a2, $0a, $01
	db $a4, $01, $a6, $01, $a1, $0a, $a2, $0a, $01, $a8, $01
.pat8:
	db $99, $a2, $0a, $0a, $a4, $01, $a6, $01, $a1, $0a, $0a, $0a, $a8, $01, $a2, $0a
	db $00
.pat9:
	db $9a, $a1, $0a, $10, $18, $16, $a5, $1e, $a4, $01, $a1, $20, $18, $10, $0a, $00
.sq1Loop: ; square 1 pattern list
	dw MusicCommonData_1E.m12Pat21, .pat10, MusicCommonData_1E.m23Pat31, .pat11, MusicCommonData_1E.m12Pat19, MusicCommonData_1E.m12Pat23, .pat12, MusicCommonData_1E.m11Pat5
	dw .pat1, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, $FFFF, .sq1
.sq2Loop: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat21, .pat13, MusicCommonData_1E.m23Pat31, .pat14, MusicCommonData_1E.m12Pat23, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m12Pat19, .pat2
	dw MusicCommonData_1E.m12Pat22, .pat3, MusicCommonData_1E.m12Pat19, .pat4, .pat2, MusicCommonData_1E.m12Pat22, .pat3, MusicCommonData_1E.m12Pat19
	dw .pat4, MusicCommonData_1E.m12Pat20, .pat5, MusicCommonData_1E.m12Pat19, .pat4, MusicCommonData_1E.m12Pat18, .pat6, $FFFF, .sq2
.waveLoop: ; wave pattern list
	dw MusicCommonData_1E.m1APat26, .pat15, MusicCommonData_1E.m1APat25, .pat16, MusicCommonData_1E.m12Pat23, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m23Pat32, .pat7
	dw .pat7, MusicCommonData_1E.m1APat25, .pat9, MusicCommonData_1E.m23Pat32, .pat8, .pat8, $FFFF, .wave
.pat10:
	db $a2, $18, $1c, $a4, $1e, $a3, $01, $a2, $18, $1c, $a7, $1e, $a2, $28, $26, $18
	db $a4, $1c, $ae, $01, $a2, $18, $1c, $a4, $1e, $a3, $01, $a2, $18, $1c, $a7, $1e
	db $a2, $26, $30, $2e, $a4, $2e, $01, $a5, $01, $00
.pat11:
	db $a1, $30, $32, $a4, $34, $a2, $01, $a1, $30, $32, $34, $a6, $01, $a3, $40, $a1
	db $3e, $3c, $48, $4a, $a4, $4c, $a1, $4e, $01, $48, $4a, $4c, $4e, $a2, $01, $a3
	db $58, $a1, $56, $54, $52, $54, $56, $48, $4a, $01, $a7, $01, $00
.pat12:
	db $a7, $01, $a1, $78, $76
	db $9b, $09, $a0, $78, $76, $9c, $00
.pat13:
	db $a2, $22, $26, $a4, $28, $a3, $01, $a2, $22, $26, $a7, $28, $a2, $32, $30, $22
	db $a4, $24, $ae, $01, $a2, $22, $26, $a4, $28, $a3, $01, $a2, $22, $26, $a7, $28
	db $a2, $30, $3a, $38, $a4, $36, $01, $a5, $01, $00
.pat14:
	db $a1, $3a, $3c, $a4, $3e, $a2, $01, $a1, $3a, $3c, $3e, $a6, $01, $a3, $4a, $a1
	db $48, $46, $52, $54, $a4, $56, $a1, $58, $01, $52, $54, $56, $58, $a2, $01, $a3
	db $4a, $a1, $60, $5e, $6a, $6c, $6e, $60, $62, $01, $a7, $01, $00
.pat15:
	db $9b, $02, $99, $a2, $0a, $0a, $a8, $01, $9c
	db $9b, $02, $a2, $06, $06, $a8, $01, $9c
	db $9b, $02, $a2, $0a, $0a, $01, $0a, $01, $0a, $a1, $0a, $0a, $0a, $0a, $9c
	db $9b, $02, $a2, $1a, $1a, $01, $1a, $01, $1a, $a1, $1a, $1a, $1a, $1a, $9c, $00
.pat16:
	db $9b, $04, $a1, $0a, $9c, $22
	db $9b, $07, $0a, $9c
	db $9b, $04, $0a, $9c, $22
	db $9b, $07, $0a, $9c
	db $9b, $04, $0a, $9c, $22
	db $9b, $07, $0a, $9c
	db $9b, $04, $0a, $9c, $22
	db $9b, $07, $0a, $9c, $22, $24, $26, $18, $1a, $01, $a7, $01, $00

;@ path: sound/music/songs
;@ Music track $5A: Dungeon 8.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $07.
;@ Entry 58 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5A::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat15
.sq1Loop:
	dw MusicCommonData_1E.m5APat8, .pat1, .pat2, .pat1, MusicCommonData_1E.m1APat21, .pat3, .pat4, .pat4
	dw .pat4, .pat4, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat21, .pat1, .pat2, MusicCommonData_1E.m5APat10, .pat1, .pat3, MusicCommonData_1E.m5APat9, .pat4
	dw .pat4, MusicCommonData_1E.m5APat10, .pat4, MusicCommonData_1E.m1APat21, .pat4, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat25, .pat7, .pat5, .pat6, $FFFF, .wave
.pat1:
	db $9b, $04, $a2, $48, $4c, $54, $58, $9c, $00
.pat2:
	db $9b, $04, $44, $48, $50, $54, $9c, $00
.pat3:
	db $9b, $04, $4a, $4e, $56, $5a, $9c, $00
.pat4:
	db $9b, $02, $4c, $50, $56, $5c, $9c, $00
.pat5:
	db $99, $a7, $18, $a2, $18, $a5, $01, $a7, $01, $a2, $16, $a7, $14, $a2, $14, $a5
	db $01, $a7, $01, $a2, $14, $a7, $0a, $a2, $0a, $a5, $01, $a7, $01, $a2, $0a, $02
	db $02, $01, $02, $a5, $01, $a7, $01, $00
.pat6:
	db $9b, $04, $a2, $04, $9c, $ae, $01, $01, $a4, $01, $a2, $18, $00
.pat7:
	db $9b, $0c, $a5, $01, $9c, $00
;@ path: sound/music/songs
;@ Music track $14 (also $52): Dungeon 1.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $00.
;@ Entry 4, 50 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music14::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list (tracks $14, $52)
	dw MusicCommonData_1E.m1APat22, MusicCommonData_1E.m23Pat33, .pat3, .pat4, MusicCommonData_1E.m14Pat18, MusicCommonData_1E.m23Pat36, .pat3, .pat4
	dw MusicCommonData_1E.m14Pat17, MusicCommonData_1E.m14Pat22, .pat3, MusicCommonData_1E.m14Pat21, .pat3, MusicCommonData_1E.m14Pat16, MusicCommonData_1E.m14Pat20, .pat3
	dw MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m1APat22, MusicCommonData_1E.m23Pat33, .pat3, .pat4, MusicCommonData_1E.m14Pat18, MusicCommonData_1E.m23Pat36
	dw .pat3, .pat4, MusicCommonData_1E.m14Pat17, MusicCommonData_1E.m14Pat22, .pat3, MusicCommonData_1E.m14Pat21, .pat3, MusicCommonData_1E.m14Pat16
	dw MusicCommonData_1E.m14Pat20, .pat3, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m12Pat19, .pat6, MusicCommonData_1E.m14Pat13, .pat7
	dw MusicCommonData_1E.m14Pat14, .pat8, MusicCommonData_1E.m12Pat19, .pat8, .pat8, MusicCommonData_1E.m12Pat18, .pat8, MusicCommonData_1E.m12Pat19
	dw .pat9, MusicCommonData_1E.m14Pat13, .pat10, MusicCommonData_1E.m14Pat14, .pat8, MusicCommonData_1E.m12Pat19, .pat8, .pat8
	dw MusicCommonData_1E.m12Pat18, .pat8, MusicCommonData_1E.m23Pat36, MusicCommonData_1E.m12Pat19, .pat6, MusicCommonData_1E.m14Pat13, .pat7, MusicCommonData_1E.m14Pat14
	dw .pat8, MusicCommonData_1E.m12Pat19, .pat8, .pat8, MusicCommonData_1E.m12Pat18, .pat8, MusicCommonData_1E.m12Pat19, .pat9
	dw MusicCommonData_1E.m14Pat13, .pat10, MusicCommonData_1E.m14Pat14, .pat8, MusicCommonData_1E.m12Pat19, .pat8, .pat8, MusicCommonData_1E.m12Pat18
	dw .pat8, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m14Pat15, .pat2, MusicCommonData_1E.m12Pat20, .pat11, $FFFF, .sq2
.wave: ; wave pattern list (tracks $14, $52)
	dw MusicCommonData_1E.m14Pat19, .pat5, .pat12, MusicCommonData_1E.m23Pat32, .pat2, .pat11, $FFFF, .wave
.pat2: ; tracks $14, $52
	db $a2, $18, $1c, $1e, $14, $18, $1a, $00
.pat3: ; tracks $14, $52
	db $a3, $30, $34, $36, $a4, $44, $18, $a3, $01, $00
.pat4: ; tracks $14, $52
	db $30, $34, $36, $a4, $42, $18, $a3, $01, $30, $34, $36, $a4, $40, $18, $a3, $01
	db $30, $34, $36, $a4, $42, $18, $a3, $01, $00
.pat5: ; tracks $14, $52
	db $9b, $18, $99, $a3, $18, $18, $a5, $01, $a3, $01, $18, $9c, $00
.pat6: ; tracks $14, $52
	db $9b, $0c, $a1, $24, $2c, $9c, $00
.pat7: ; tracks $14, $52
	db $9b, $04, $24, $2c, $9c, $00
.pat8: ; tracks $14, $52
	db $9b, $04, $22, $2a, $9c, $00
.pat9: ; tracks $14, $52
	db $9b, $0c, $20, $28, $9c, $00
.pat10: ; tracks $14, $52
	db $9b, $04, $20, $28, $9c, $00
.pat11: ; tracks $14, $52
	db $a2, $01, $ae, $0c, $a5, $01, $a7, $01, $00
.pat12: ; tracks $14, $52
	db $9b, $08, $99, $a3, $18, $18, $01, $18, $01, $a4, $30, $a3, $18, $9c, $00

;@ path: sound/music/songs
;@ Music track $15: Dungeon 2.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $01.
;@ Entry 5 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music15::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m12Pat18, .pat1, MusicCommonData_1E.m12Pat19, .pat1, .pat1, .pat2, MusicCommonData_1E.m14Pat13, .pat3
	dw .pat3, .pat3, MusicCommonData_1E.m23Pat33, .pat3, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat18, .pat4, .pat4, MusicCommonData_1E.m12Pat19, .pat4, MusicCommonData_1E.m12Pat18, .pat4, MusicCommonData_1E.m12Pat18
	dw .pat5, .pat5, MusicCommonData_1E.m12Pat19, .pat5, MusicCommonData_1E.m12Pat18, .pat5, MusicCommonData_1E.m12Pat18, .pat6
	dw .pat6, MusicCommonData_1E.m12Pat19, .pat6, MusicCommonData_1E.m12Pat18, .pat6, MusicCommonData_1E.m12Pat18, .pat7, .pat7
	dw MusicCommonData_1E.m12Pat19, .pat7, MusicCommonData_1E.m12Pat18, .pat7, MusicCommonData_1E.m12Pat18, .pat4, MusicCommonData_1E.m12Pat19, .pat4
	dw MusicCommonData_1E.m14Pat13, .pat4, MusicCommonData_1E.m12Pat18, .pat4, MusicCommonData_1E.m12Pat18, .pat5, MusicCommonData_1E.m12Pat19, .pat5
	dw MusicCommonData_1E.m14Pat13, .pat5, MusicCommonData_1E.m12Pat18, .pat5, MusicCommonData_1E.m12Pat18, .pat6, MusicCommonData_1E.m12Pat19, .pat6
	dw MusicCommonData_1E.m14Pat13, .pat6, MusicCommonData_1E.m12Pat18, .pat6, MusicCommonData_1E.m12Pat18, .pat7, MusicCommonData_1E.m12Pat19, .pat7
	dw MusicCommonData_1E.m14Pat13, .pat7, MusicCommonData_1E.m12Pat18, .pat7, MusicCommonData_1E.m12Pat18, .pat4, MusicCommonData_1E.m12Pat19, .pat4
	dw MusicCommonData_1E.m14Pat13, .pat4, MusicCommonData_1E.m12Pat18, .pat4, MusicCommonData_1E.m12Pat18, .pat5, MusicCommonData_1E.m12Pat19, .pat5
	dw MusicCommonData_1E.m14Pat13, .pat5, MusicCommonData_1E.m12Pat18, .pat5, MusicCommonData_1E.m12Pat18, .pat6, MusicCommonData_1E.m12Pat19, .pat6
	dw MusicCommonData_1E.m14Pat13, .pat6, MusicCommonData_1E.m12Pat18, .pat6, MusicCommonData_1E.m12Pat18, .pat7, MusicCommonData_1E.m12Pat19, .pat7
	dw MusicCommonData_1E.m14Pat13, .pat7, MusicCommonData_1E.m12Pat18, .pat7, MusicCommonData_1E.m12Pat18, .pat8, MusicCommonData_1E.m14Pat13, .pat8
	dw MusicCommonData_1E.m12Pat19, .pat9, MusicCommonData_1E.m14Pat13, .pat9, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat19, .pat10
	dw MusicCommonData_1E.m23Pat36, .pat10, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, $FFFF, .sq2
.wave: ; wave pattern list
	dw Music16.m15Pat15, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m1APat26, .pat11, MusicCommonData_1E.m1APat27
	dw .pat12, MusicCommonData_1E.m15Pat17, .pat14, MusicCommonData_1E.m1APat27, .pat12, MusicCommonData_1E.m15Pat17, .pat14, MusicCommonData_1E.m15Pat16
	dw MusicCommonData_1E.m15Pat17, .pat13, MusicCommonData_1E.m1APat28, .pat14, MusicCommonData_1E.m15Pat16, $FFFF, .wave
.pat1:
	db $a5, $01, $a3, $01
	db $9b, $04, $a2, $54, $9c, $ae, $01
	db $9b, $04, $a2, $52, $9c, $ae, $01
	db $9b, $04, $a2, $58, $9c, $ae, $01
	db $9b, $04, $a2, $56, $9c, $a3, $01, $00
.pat2:
	db $a8, $01, $a2, $01, $5e, $a8, $01, $a2, $01, $60, $00
.pat3:
	db $9b, $03, $a2, $02, $08, $04, $0c, $9c
	db $9d, $a2, $83, $c0, $02, $08, $04, $0c
	db $9d, $c2, $83, $c0, $02, $08, $04, $0c
	db $9d, $81, $83, $c0
	db $9b, $03, $02, $08, $04, $0c, $9c, $00
.pat4:
	db $9b, $04, $a2, $60, $9c, $00
.pat5:
	db $9b, $04, $5e, $9c, $00
.pat6:
	db $9b, $04, $64, $9c, $00
.pat7:
	db $9b, $04, $62, $9c, $00
.pat8:
	db $9b, $04, $6a, $9c, $00
.pat9:
	db $9b, $04, $6c, $9c, $00
.pat10:
	db $a2, $30, $34, $36, $44, $a5, $01, $a2, $01, $42, $34, $42, $a5, $01, $01, $00
.pat11:
	db $99, $a2, $18, $1c, $1e, $2c, $ae, $01, $a2, $18, $1c, $1e, $2a, $ae, $01, $a2
	db $1c, $20, $22, $30, $ae, $01, $a2, $1c, $20, $22, $2e, $ae, $01, $a2, $26, $2a
	db $2c, $3a, $a4, $01, $a2, $28, $2c, $2e, $3c
	db $9b, $09, $a4, $01, $9c, $00
.pat12:
	db $a3, $01, $a2, $60, $64, $66, $74, $a3, $01
.pat13:
	db $a5, $01
	db $9b, $03, $a2, $5a, $60, $5e, $62, $9c, $00
.pat14:
	db $a2, $5a, $60, $5e, $62, $00

;@ path: sound/music/songs
;@ Music track $16: Dungeon 3.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $02.
;@ Entry 6 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music16::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, .pat3, MusicCommonData_1E.m1APat22, .pat3, MusicCommonData_1E.m1APat19, .pat3, MusicCommonData_1E.m1APat22, .pat3
	dw MusicCommonData_1E.m16Pat8, .pat4, MusicCommonData_1E.m1APat21, .pat3, .pat3, MusicCommonData_1E.m15Pat16, MusicCommonData_1E.m16Pat7, MusicCommonData_1E.m16Pat7
	dw MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat21, .pat3, MusicCommonData_1E.m1APat22, .pat3, MusicCommonData_1E.m1APat19, .pat3, MusicCommonData_1E.m1APat22
	dw .pat3, MusicCommonData_1E.m16Pat8, .pat5, MusicCommonData_1E.m16Pat9, .pat3, MusicCommonData_1E.m1APat22, .pat3, MusicCommonData_1E.m1APat19
	dw .pat3, MusicCommonData_1E.m16Pat7, MusicCommonData_1E.m16Pat7, MusicCommonData_1E.m16Pat9, .pat6, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat22, .pat1, MusicCommonData_1E.m1APat22, .pat2, MusicCommonData_1E.m1APat21, .pat3, MusicCommonData_1E.m1APat22, .pat3
	dw MusicCommonData_1E.m1APat21, .pat3, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat21, .pat3, MusicCommonData_1E.m16Pat9, .pat3
	dw MusicCommonData_1E.m1APat22, .pat3, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat17, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m14Pat19, .pat1, .m15Pat15, $FFFF, .wave
.pat1:
	db $a4, $18, $a3, $1c, $1e, $a5, $16
	db $9b, $04, $01, $9c, $a4, $18, $a3, $1c, $1e, $a5, $24
	db $9b, $04, $01, $9c, $00
.pat2:
	db $a4, $60, $a3, $64, $66, $a4, $74, $5e, $a3, $62, $64, $a4, $72, $6e, $a3, $72
	db $74, $a4, $82, $70, $a3, $74, $76, $a4, $84, $00
.m15Pat15: ; tracks $15, $16, $4E
	db $9b, $09, $a5, $01, $9c, $00
.pat3:
	db $aa, $48, $54, $56, $60, $56, $54, $00
.pat4:
	db $a1, $01, $ad, $01, $a3, $01, $74, $72, $01, $74, $72, $a4, $01, $a2, $74, $72
	db $00
.pat5:
	db $a1, $01, $ad, $01, $01, $a3, $01, $7a, $78, $01, $7a, $78, $a4, $01, $a2, $7a
	db $78, $00
.pat6:
	db $a0, $01, $01
	db $9b, $03, $a3, $48, $3c, $9c
	db $9b, $03, $46, $3a, $9c
	db $9b, $03, $3e, $32, $9c
	db $9b, $06, $40, $34, $9c, $ae, $01, $00

;@ path: sound/music/songs
;@ Music track $17: Dungeon 4.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $03.
;@ Entry 7 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music17::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m16Pat9, .pat2, MusicCommonData_1E.m1APat22, .pat3, MusicCommonData_1E.m1APat19, .pat4, $FFFF, .sq2
.pat1: ; tracks $17, $26
	db $a3, $01, $a2, $48, $4c, $4e, $5c, $01, $6c, $6c, $a4, $01, $a2, $01, $48, $4c
	db $4e, $5a, $01, $6a, $6a, $a4, $01, $a2, $01, $4c, $50, $52, $60, $01, $70, $70
	db $a4, $01, $a2, $01, $4c, $50, $52, $5e, $01, $6e, $6e, $a4, $01, $a2, $01, $56
	db $5a, $5c, $6a, $01, $76, $a3, $01, $a2, $58, $5c, $5e, $6c, $01, $78, $a3, $01
	db $a2, $60, $64, $84, $82, $80, $7e, $ae, $01, $00
.pat2: ; tracks $17, $26
	db $a2, $48, $4c, $4e, $5c, $a7, $01, $a2, $78, $a4, $78, $a2, $48, $4c, $4e, $5a
	db $a7, $01, $a2, $76, $a4, $76, $a2, $4c, $50, $52, $60, $a7, $01, $a2, $7c, $a4
	db $7c, $a2, $4c, $50, $52, $5e, $a7, $01, $a2, $7a, $a4, $7a, $00
.pat3: ; tracks $17, $26
	db $a2, $56, $5a, $5c, $6a, $a7, $01, $a2, $82, $58, $5c, $5e, $6c, $a7, $01, $a2
	db $84, $00
.pat4: ; tracks $17, $26
	db $60, $64, $66, $8c, $8a, $88, $86, $84, $ae, $01, $00

;@ path: sound/music/songs
;@ Music track $13 (also $51): Indoor map $14.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $14.
;@ Entry 3, 49 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music13::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw .sq1, .sq2, .wave, $0000
.sq2: ; square 2 pattern list (tracks $13, $51)
	dw MusicCommonData_1E.m13Pat7, .pat1, MusicCommonData_1E.m13Pat8, .pat2, MusicCommonData_1E.m13Pat9, .pat3, MusicCommonData_1E.m13Pat8, .pat4
	dw $FFFF, .sq2
.sq1: ; square 1 pattern list (tracks $13, $51)
	dw MusicCommonData_1E
.sq1Loop:
	dw MusicCommonData_1E.m13Pat6, .pat1, $FFFF, .sq1Loop
.wave: ; wave pattern list (tracks $13, $51)
	dw MusicCommonData_1E.m1APat25, .pat5, $FFFF, .wave
.pat1: ; tracks $13, $51
	db $a2, $2c, $26, $20, $1a, $14, $0e, $08, $04, $02, $08, $0e, $14, $1a, $20, $26
	db $2c, $00
.pat2: ; tracks $13, $51
	db $2e, $26, $20, $1a, $16, $0e, $08, $04, $02, $08, $0e, $16, $1a, $20, $26, $2e
	db $00
.pat3: ; tracks $13, $51
	db $30, $26, $20, $1a, $18, $0e, $08, $04, $02, $08, $0e, $18, $1a, $20, $26, $30
	db $00
.pat4: ; tracks $13, $51
	db $2e, $26, $20, $1a, $16, $0e, $08, $04, $02, $08, $0e, $16, $1a, $20, $26, $2e
	db $00
.pat5: ; tracks $13, $51
	db $99, $a8, $01, $a2, $01, $02, $02, $01, $a8, $01, $a5, $01, $01, $00

;@ path: sound/music/songs
;@ Music track $18: Heart container.
;@ Where: HeartContainerHandler; SelectAreaMusic while wIndoorAltMusic is set.
;@ Entry 8 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music18::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, $0000, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E
.sq1Loop:
	dw MusicCommonData_1E.m13Pat6, .pat1, .pat1, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat21, .pat1, MusicCommonData_1E.m16Pat9, .pat2
.sq2Loop:
	dw MusicCommonData_1E.m1APat22, .pat1, MusicCommonData_1E.m1APat24, .pat2, $FFFF, .sq2Loop
.pat1:
	db $a1, $48, $44, $3e, $38, $30, $2c, $26, $20, $18, $20, $26, $2c, $30, $38, $3e
	db $44, $00
.pat2:
	db $4c, $48, $44, $3e, $38, $30, $2c, $26, $20, $26, $2c, $34, $3e, $44, $4c, $50
	db $00

;@ path: sound/music/songs
;@ Music track $19: requested in bank $04.
;@ Entry 9 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music19::
	db $00 ; transpose
	dw NoteLengths48_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m19Pat13, .pat6, MusicCommonData_1E.m19Pat12, .pat1, MusicCommonData_1E.m12Pat20, .pat2, MusicCommonData_1E.m19Pat12, .pat1
	dw MusicCommonData_1E.m12Pat17, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m19Pat13, .pat5, MusicCommonData_1E.m19Pat12, .pat3, MusicCommonData_1E.m12Pat20, .pat4, MusicCommonData_1E.m23Pat34, MusicCommonData_1E.m19Pat12
	dw .pat3, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m23Pat33, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat14, MusicCommonData_1E.m14Pat19, .pat7, MusicCommonData_1E.m23Pat32, .pat8, MusicCommonData_1E.m14Pat19, .pat7, MusicCommonData_1E.m12Pat17
	dw $FFFF, .wave
.noise: ; noise pattern list
	dw .m23Pat27, .pat9, .pat9, .pat10, .pat9, .pat9, .pat11, $FFFF, .noise
.pat1:
	db $9b, $02, $a2, $22, $22, $22, $20, $a4, $01, $a7, $1e, $1c, $a3, $01, $9c
	db $9b, $02, $a2, $26, $26, $26, $24, $a4, $01, $a7, $22, $20, $a3, $01, $9c, $00
.pat2:
	db $a7, $48, $46, $a2, $48, $4a, $4c, $a1, $4e, $01, $00
.pat3:
	db $9b, $02, $a2, $30, $30, $30, $2e, $a4, $01, $a7, $2c, $2a, $a3, $01, $9c
	db $9b, $02, $a2, $34, $34, $34, $32, $a4, $01, $a7, $30, $2e, $a3, $01, $9c, $00
.pat4:
	db $a7, $52, $50, $a2, $52, $54, $56, $a1, $58, $01, $00
.pat5: ; tracks $19, $1C
	db $a1, $6c, $6a, $68, $66, $64, $62, $60, $5e, $5c, $5a, $58, $56, $54, $52, $50
	db $4e, $00
.pat6: ; tracks $19, $1C
	db $a1, $66, $64, $62, $60, $5e, $5c, $5a, $58, $56, $54, $52, $50, $4e, $4c, $4a
	db $48, $00
.pat7:
	db $9b, $10, $99, $a2, $18, $0e, $9c
	db $9b, $10, $04, $1c, $9c, $00
.pat8:
	db $9a, $a7, $32, $30, $a2, $32, $34, $36, $99, $38, $00
.m23Pat27: ; tracks $19, $23
	db $a5, $01, $00
.pat9:
	db $9b, $04, $a2, $15, $15, $ff, $01, $9c
	db $9b, $02, $15, $15, $ff, $15, $9c, $1a, $ff, $15, $ff
	db $9b, $04, $ff, $9c, $00
.pat10:
	db $9b, $02, $ff, $1a, $1a, $9c
	db $9b, $04, $ff, $9c, $00
.pat11:
	db $1a, $1a, $01, $15, $15, $01, $ff, $ff
	db $9b, $04, $15, $9c
	db $9b, $04, $1a, $9c, $00
;@ path: sound/music/songs
;@ Music track $1B: Instrument.
;@ Where: Collect_Instrument, WarpAppear.
;@ Entry 11 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1B::
	db $00 ; transpose
	dw NoteLengths64_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, MusicCommonData_1E.m16Pat7, MusicCommonData_1E.m1APat15, .pat1, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat19, .pat1, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat28, MusicCommonData_1E.m1APat15, .pat1, $0000
.pat1:
	db $9b, $02, $a1, $90, $8a, $82, $7c, $78, $72, $6a, $64, $60, $5a, $52, $4c, $48
	db $42, $3a, $34, $8e, $88, $82, $7a, $76, $70, $6a, $62, $5e, $58, $52, $4a, $46
	db $40, $3a, $32, $9c, $2e, $28, $22, $1a, $16, $10, $0a, $02, $a6, $48, $56, $5c
	db $64, $01, $a2, $60, $a1, $68, $6e, $a5, $78, $01, $00

;@ path: sound/music/songs
;@ Music track $1C: not requested directly.
;@ Entry 12 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1C::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2Loop, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, Music19.pat6, MusicCommonData_1E
.sq2:
	dw .pat1, $FFFF, .sq2
.sq2Loop: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat21, MusicCommonData_1E.m1CPat2, Music19.pat5, $FFFF, .sq2
.pat1: ; tracks $1C, $1D
	db $a2, $28, $30, $36, $3e, $a3, $6e, $01, $a2, $60, $28, $30, $36, $60, $64, $66
	db $6a, $26, $34, $a3, $6a, $5c, $74, $a2, $52, $4c, $44, $3e, $3a, $34, $2c, $26
	db $22, $28, $30, $36, $a3, $66, $01, $a2, $58, $22, $28, $30, $58, $5c, $60, $64
	db $1e, $2c, $a3, $64, $56, $6e, $a2, $4c, $44, $3e, $36, $34, $2c, $26, $1e, $00

;@ path: sound/music/songs
;@ Music track $1D: No sword yet.
;@ Where: SelectAreaMusic while Link has no sword; bank $06.
;@ Entry 13 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1D::
	db $00 ; transpose
	dw NoteLengths64_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, Music1C.pat1, MusicCommonData_1E.m23Pat33, .pat4, .pat3, .pat5, MusicCommonData_1E.m23Pat33, .pat6
	dw $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1DPat8, .pat7, MusicCommonData_1E.m15Pat17, .pat7, $FFFF, .wave
.pat1:
	db $9d, $32, $83, $80
	db $9b, $04, $a2, $48, $01, $48, $48, $9c
	db $9b, $04, $44, $01, $44, $44, $9c
	db $9b, $04, $40, $01, $40, $40, $9c
	db $9b, $04, $3e, $01, $3e, $3e, $9c
	db $9b, $04, $30, $01, $30, $30, $9c
	db $9b, $04, $2c, $01, $2c, $2c, $9c
	db $9b, $07, $2e, $01, $2e, $2e, $9c, $2c, $01, $2c, $2c, $00
.pat2:
	db $9d, $67, $86, $80
	db $9f, $e8, $00
.pat3:
	db $9d, $47, $86, $80
	db $9f, $e8, $00
.pat4:
	db $a2, $10, $18, $1e, $26, $a3, $56, $a2, $58, $5c, $a3, $60, $a2, $10, $1e, $28
	db $30, $5c, $58, $5c, $06, $1e, $58, $a3, $56, $a2, $52, $4e, $06, $0e, $14, $1e
	db $a4, $4e, $a2, $0c, $16, $1a, $1e, $54, $5e, $62, $a3, $66, $a2, $16, $0c, $24
	db $2e, $3c, $62, $5e, $a7, $62, $a2, $70, $0a, $16, $1a, $28, $a7, $6e, $a2, $7a
	db $08, $14, $1a, $26, $00
.pat5:
	db $a2, $28, $30, $36, $3e, $a3, $6e, $01, $a2, $60, $28, $30, $36, $01, $86, $78
	db $90, $a2, $8c, $4c, $4e, $52, $a3, $56, $a2, $58, $a4, $5c, $a2, $3e, $3a, $34
	db $3e, $44, $3a, $40, $48, $4e, $a3, $4e, $01, $a2, $40, $22, $28, $30, $40, $44
	db $48, $4c, $30, $34, $36, $3e, $a3, $4e, $a2, $52, $a7, $56, $a2, $01, $48, $4e
	db $56, $58, $5c, $00
.pat6:
	db $a4, $48, $a2, $10, $18, $1e, $26, $28, $30, $36, $3e, $48, $4c, $4e, $52, $a7
	db $44, $a2, $5c, $26, $2c, $30, $34, $36, $6e, $66, $74, $8c, $26, $2c, $36, $a7
	db $76, $a2, $8e, $3c, $46, $4a, $a3, $4e, $a2, $16, $0c, $24, $2e, $3c, $4a, $46
	db $a7, $4a, $a2, $58, $22, $24, $28, $2e, $a7, $56, $a2, $62, $38, $3e, $44, $4a
	db $00
.pat7:
	db $9b, $04, $99, $a2, $40, $01, $40, $40, $9c
	db $9b, $04, $3e, $01, $3e, $3e, $9c
	db $9b, $04, $3a, $01, $3a, $3a, $9c
	db $9b, $04, $30, $01, $30, $30, $9c
	db $9b, $04, $28, $01, $28, $28, $9c
	db $9b, $04, $26, $01, $26, $26, $9c
	db $9b, $04, $24, $01, $24, $24, $9c
	db $9b, $02, $22, $01, $22, $22, $9c
	db $9b, $02, $20, $01, $20, $20, $9c, $00

;@ path: sound/music/songs
;@ Music track $1E: requested in bank $06.
;@ Entry 14 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1E::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m13Pat6, MusicCommonData_1E, .pat1, MusicCommonData_1E.m1APat21, .pat1, .pat2, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m1APat29
	dw MusicCommonData_1E.m13Pat6, Music1A.pat10, Music1A.pat10, Music1A.pat10, MusicCommonData_1E.m12Pat17, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m23Pat30, .pat1, MusicCommonData_1E.m11Pat5, MusicCommonData_1E.m23Pat36, .pat1, MusicCommonData_1E.m1APat22, MusicCommonData_1E.m23Pat33, .pat2
	dw MusicCommonData_1E.m1APat24, MusicCommonData_1E.m1APat29, Music1A.pat10, MusicCommonData_1E.m1APat19, Music1A.pat10, MusicCommonData_1E.m16Pat9, Music1A.pat10, MusicCommonData_1E.m12Pat17
	dw $0000
.pat1:
	db $a1, $2e, $34, $3c, $44, $46, $4c, $54, $5c, $2c, $32, $3a, $42, $44, $42, $3a
	db $32, $00
.pat2:
	db $a1, $38, $3e, $46, $4e, $50, $56, $5e, $66, $00

;@ path: sound/music/songs
;@ Music track $4B: Dungeon 5.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $04.
;@ Entry 43 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4B::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m4BPat10, .pat4, MusicCommonData_1E.m4BPat11, .pat5, MusicCommonData_1E.m4BPat10, .pat6, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m13Pat7, .pat1, MusicCommonData_1E.m13Pat7, .pat1, MusicCommonData_1E.m13Pat7, .pat2, MusicCommonData_1E.m13Pat7, .pat1
	dw MusicCommonData_1E.m13Pat7, .pat1, MusicCommonData_1E.m13Pat7, .pat1, MusicCommonData_1E.m13Pat7, .pat2, MusicCommonData_1E.m13Pat8, .pat3
	dw MusicCommonData_1E.m13Pat7, .pat2, MusicCommonData_1E.m13Pat8, .pat3, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m15Pat17, .pat7, MusicCommonData_1E.m15Pat17, .pat8, MusicCommonData_1E.m15Pat17, .pat9, $FFFF, .wave
.pat1:
	db $a2, $02, $0e, $04, $0c, $01, $04
	db $9d, $92, $00, $c0, $02, $0e, $04, $0c, $01, $04
	db $9d, $b2, $00, $c0, $02, $0e, $04, $0c, $01, $04
	db $9d, $92, $00, $c0, $02, $0e, $04, $0c, $01, $04, $00
.pat2:
	db $9b, $02, $02, $0e, $04, $0c, $01, $04, $9c
	db $9d, $92, $00, $c0, $02, $0e, $04, $0c, $01, $04
	db $9d, $b2, $00, $c0, $02, $0e, $04, $0c, $01, $04, $00
.pat3:
	db $02, $0e, $04, $0c, $01, $04
	db $9d, $92, $00, $c0, $02, $0e, $04, $0c, $01, $04
	db $9d, $62, $00, $c0
	db $9b, $02, $02, $0e, $04, $0c, $01, $04, $9c, $00
.pat4:
	db $ae, $01, $01
	db $9b, $02, $a1, $32, $32, $32, $32, $34, $32, $a2, $32, $ae, $01, $a8, $01, $a2
	db $01, $4a, $a1, $32, $32, $a7, $01, $a5, $01, $ae, $01, $9c, $00
.pat5:
	db $a1, $01, $50, $54, $56, $64, $a3, $5e, $a1, $5e, $62, $01, $ae, $01, $a4, $01
	db $a1, $68, $62, $5e, $5c, $ae, $01, $a9, $2c, $a0, $01, $a1, $2c, $a7, $01, $a5
	db $01, $a1, $62, $5e, $52, $50, $a5, $01, $01, $a4, $01, $a2, $30, $a1, $32, $01
	db $00
.pat6:
	db $a1, $2c, $2c, $2c, $2c, $2e, $2c, $a2, $2c, $ae, $01, $a5, $01, $a1, $22, $22
	db $22, $22, $24, $22, $a2, $22, $a5, $01, $ae, $01, $00
.pat7:
	db $99, $ae, $01, $01
	db $9b, $02, $a1, $2e, $2e, $2e, $2e, $30, $2e, $a2, $2e, $ae, $01, $a8, $01, $a2
	db $01, $46, $a1, $2e, $2e, $a7, $01, $ae, $01, $a5, $01, $9c, $00
.pat8:
	db $9b, $0c, $a8, $01, $9c, $00
.pat9:
	db $a1, $24, $24, $24, $24, $26, $24, $24, $01, $a5, $01, $ae, $01, $a1, $1a, $1a
	db $1a, $1a, $34, $1a, $1a, $01, $a5, $01, $ae, $01, $00

;@ path: sound/music/songs
;@ Music track $1F: Indoor map $16.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $16.
;@ Entry 15 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music1F::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, MusicSilentChannel_1E
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1FPat14, MusicCommonData_1E.m16Pat9, .pat1, .pat1
.sq1Loop:
	dw MusicCommonData_1E.m1APat22, .pat1, .pat2, .pat3, .pat4, MusicCommonData_1E.m16Pat9, .pat5, MusicCommonData_1E.m1APat22
	dw .pat6, MusicCommonData_1E.m14Pat18, .pat7, MusicCommonData_1E.m1APat22, .pat8, MusicCommonData_1E.m16Pat9, .pat9, MusicCommonData_1E.m1APat22
	dw .pat10, MusicCommonData_1E.m14Pat18, .pat11, .pat12, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17
.sq2Loop:
	dw MusicCommonData_1E.m5DPat2, .pat13, $FFFF, .sq2Loop
.pat1:
	db $a3, $28, $32, $30, $32, $38, $32, $30, $32, $00
.m58Pat1:
	db $9b, $02, $a2, $28, $32, $30, $32, $38, $32, $30, $32, $9c, $00
.pat2: ; tracks $1F, $58
	db $2a, $32, $30, $32, $38, $32, $30, $32, $00
.pat3: ; tracks $1F, $58
	db $2a, $36, $32, $36, $3c, $36, $32, $36, $00
.pat4: ; tracks $1F, $58
	db $28, $38, $36, $38, $40, $38, $36, $38, $00
.pat5: ; tracks $1F, $58
	db $32, $38, $36, $38, $42, $38, $36, $38, $00
.pat6: ; tracks $1F, $58
	db $2a, $36, $32, $36, $3c, $36, $32, $36, $00
.pat7: ; tracks $1F, $58
	db $2e, $36, $32, $36, $3c, $36, $32, $36, $00
.pat8: ; tracks $1F, $58
	db $2e, $38, $36, $38, $40, $38, $36, $38, $00
.pat9: ; tracks $1F, $58
	db $2a, $38, $36, $38, $42, $38, $36, $38, $00
.pat10: ; tracks $1F, $58
	db $2c, $36, $32, $36, $3e, $36, $32, $36, $00
.pat11: ; tracks $1F, $58
	db $28, $36, $32, $36, $40, $36, $32, $36, $00
.m58Pat2:
	db $30, $36, $3c, $42, $48, $4e, $54, $5a, $58, $54, $4e, $48, $40, $3c, $36, $30
	db $00
.pat12:
	db $30, $36, $3c, $42, $48, $4e, $54, $5a, $00
.pat13:
	db $9b, $02, $a3, $4a, $4e, $ae, $50, $9c, $a5, $4e, $48, $ae, $4a, $a4, $01, $a3
	db $4a, $4e, $ae, $50, $a3, $4e, $50, $a5, $54, $a4, $01, $a3, $46, $4e, $a5, $54
	db $a4, $5a, $ae, $58, $a4, $01, $a5, $54, $54, $56, $56, $58, $58, $01, $01, $00

;@ path: sound/music/songs
;@ Music track $58: Dungeon 6.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $05.
;@ Entry 56 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music58::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m16Pat7
.sq1Loop:
	dw MusicCommonData_1E.m13Pat6, Music1F.m58Pat1, Music1F.pat2, Music1F.pat2, Music1F.pat3, Music1F.pat3, Music1F.pat4, Music1F.pat4
	dw Music1F.pat5, Music1F.pat5, Music1F.pat6, Music1F.pat6, Music1F.pat7, Music1F.pat7, Music1F.pat8, Music1F.pat8
	dw Music1F.pat9, Music1F.pat9, Music1F.pat10, Music1F.pat10, Music1F.pat11, Music1F.pat11, Music1F.m58Pat2, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m16Pat9, Music1F.m58Pat1, Music1F.pat2, MusicCommonData_1E.m1APat22, Music1F.pat2, MusicCommonData_1E.m1APat19, Music1F.pat3, MusicCommonData_1E.m14Pat17
	dw Music1F.pat3, MusicCommonData_1E.m1APat22, Music1F.pat4, MusicCommonData_1E.m16Pat9, Music1F.pat4, Music1F.pat5, MusicCommonData_1E.m1APat22, Music1F.pat5
	dw MusicCommonData_1E.m1APat19, Music1F.pat6, MusicCommonData_1E.m16Pat9, Music1F.pat6, MusicCommonData_1E.m1APat21, Music1F.pat7, MusicCommonData_1E.m16Pat9, Music1F.pat7
	dw MusicCommonData_1E.m1APat22, Music1F.pat8, MusicCommonData_1E.m1APat21, Music1F.pat8, MusicCommonData_1E.m16Pat9, Music1F.pat9, MusicCommonData_1E.m1APat22, Music1F.pat9
	dw MusicCommonData_1E.m1APat19, Music1F.pat10, MusicCommonData_1E.m14Pat17, Music1F.pat10, Music1F.pat11, MusicCommonData_1E.m14Pat16, Music1F.pat11, MusicCommonData_1E.m1APat19
	dw Music1F.m58Pat2, $FFFF, .sq2

;@ path: sound/music/songs
;@ Music track $21: Side-scrolling rooms.
;@ Where: SelectAreaMusic: side-view rooms of maps below $0A.
;@ Entry 17 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music21::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw MusicSilentChannel_1E, .sq2, MusicSilentChannel_1E, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m21Pat2, .pat1, MusicCommonData_1E.m12Pat17, $FFFF, .sq2
.pat1:
	db $a2, $02, $0e, $0c, $a7, $01, $a6, $01, $a1, $02, $a2, $02, $0e, $a1, $0c, $18
	db $00

;@ path: sound/music/songs
;@ Music track $22: requested in bank $06.
;@ Entry 18 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music22::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2Loop, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, MusicCommonData_1E.m16Pat7, MusicCommonData_1E
.sq2:
	dw .pat1, $FFFF, .sq2
.sq2Loop: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat19, $FFFF, .sq2
.pat1:
	db $a3, $32, $46, $58, $66, $70, $01, $a3, $2e, $42, $54, $62, $6c, $01, $00

;@ path: sound/music/songs
;@ Music track $24: not requested directly.
;@ Entry 20 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music24::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, MusicCommonData_1E, .pat1, .pat3
.sq1Loop:
	dw .pat4, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m16Pat9, .pat1
.sq2Loop:
	dw .pat2, $FFFF, .sq2Loop
.pat1:
	db $a1, $8e, $8c, $84, $7c, $76, $74, $6c, $64, $00
.pat2:
	db $9b, $03, $a7, $74, $01, $9c, $a2, $74, $74, $a4, $01, $00
.pat3:
	db $a4, $01, $a6, $01
	db $9b, $02, $a7, $54, $01, $9c, $a2, $54, $54, $a4, $01, $00
.pat4:
	db $9b, $03, $a7, $54, $01, $9c, $a2, $54, $54, $a4, $01, $00

;@ path: sound/music/songs
;@ Music track $53: Indoor map $13.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $13.
;@ Entry 51 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music53::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m13Pat6, MusicCommonData_1E, .pat1, MusicCommonData_1E.m53Pat5, MusicCommonData_1E.m1APat21, .pat4, MusicCommonData_1E.m1APat29, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m4BPat10, .pat1, MusicCommonData_1E, MusicCommonData_1E.m53Pat5, MusicCommonData_1E.m1APat18, .pat3, MusicCommonData_1E.m1APat29, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E, MusicCommonData_1E.m15Pat16, MusicCommonData_1E.m53Pat5, MusicCommonData_1E.m1DPat8, .pat2, MusicCommonData_1E.m1APat29, $FFFF, .wave
.pat1:
	db $a1, $8e, $8c, $84, $7c, $76, $74, $6c, $64, $00
.pat2:
	db $9b, $02, $a3, $01, $a6, $88, $a1, $01, $ae, $01, $01, $01, $a5, $01, $9c, $a3
	db $01, $a6, $88, $a1, $01, $ae, $01, $01, $00
.pat3:
	db $9d, $61, $86, $80
	db $9b, $02, $a3, $64, $68, $6a, $82, $a5, $01, $a3, $01, $80, $7c, $6a, $a5, $01
	db $9c, $a3, $64, $68, $6a, $01, $01, $68, $64, $58, $5e, $64, $a8, $01, $a3, $68
	db $6a, $6e, $70, $88, $ae, $01, $01, $00
.pat4:
	db $9b, $04, $a2, $54, $5c, $4c, $52, $54, $52, $4c, $44, $9c
	db $9b, $04, $52, $58, $48, $50, $52, $58, $60, $68, $9c
	db $9b, $04, $50, $58, $46, $4c, $50, $4c, $46, $40, $9c
	db $9b, $03, $52, $58, $48, $50, $52, $58, $60, $68, $9c, $52, $58, $48, $50, $00

;@ path: sound/music/songs
;@ Music track $26: Caves.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): maps $09-$0D, $11, $1F.
;@ Entry 22 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music26::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat21, Music17.pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat22, MusicCommonData_1E.m26Pat1, $FFFF, .sq2Loop
.sq2Loop: ; square 2 pattern list
	dw Music17.pat2, Music17.pat3, Music17.pat4, $FFFF, .sq2Loop

;@ path: sound/music/songs
;@ Music track $5B: Dungeon 7.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $06.
;@ Entry 59 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5B::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E
.sq1Loop:
	dw MusicCommonData_1E.m5APat8, .pat10, .pat10, .pat10, .pat10, .pat10, .pat10, MusicCommonData_1E.m5APat8
	dw .pat10, .pat10, MusicCommonData_1E.m13Pat6, .pat8, MusicCommonData_1E.m5APat8, .pat10, .pat9, MusicCommonData_1E.m12Pat17
	dw MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, $FFFF, .sq1Loop
.wave: ; wave pattern list
	dw .pat14, MusicCommonData_1E.m1DPat8, .pat3, MusicCommonData_1E.m15Pat17, .pat3, MusicCommonData_1E.m1DPat8, .pat1, MusicCommonData_1E.m1APat28
	dw .pat1, MusicCommonData_1E.m1DPat8, .pat2, MusicCommonData_1E.m15Pat17, .pat4, MusicCommonData_1E.m1DPat8, .pat5, MusicCommonData_1E.m15Pat17
	dw .pat6, MusicCommonData_1E.m1APat28, .pat7, $FFFF, .wave
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat21, .pat11, .pat11, .pat11, .pat11, .pat11, .pat11, MusicCommonData_1E.m1APat21
	dw .pat11, .pat11, .pat8, .pat11, MusicCommonData_1E.m16Pat9, .pat9, MusicCommonData_1E.m1APat21, .pat12
	dw MusicCommonData_1E.m5APat8, .pat13, $FFFF, .sq2
.pat1:
	db $a3, $50, $64, $62, $6e, $a4, $01, $a2, $01, $64, $62, $50, $a3, $4e, $60, $5e
	db $6c, $a5, $01, $00
.pat2:
	db $a3, $4c, $5c, $5a, $6a, $a5, $01, $a3, $4a, $5a, $58, $68, $a5, $01, $a3, $48
	db $58, $56, $66, $a5, $01, $a3, $4a, $5a, $58, $68, $a5, $01, $00
.pat3:
	db $99, $a3, $4c, $5c, $5a, $6a, $a5, $01, $a3, $4a, $5a, $58, $68, $a5, $01, $00
.pat4:
	db $9a, $a2, $30, $34, $36, $44, $48, $4c, $4e, $5c, $a5, $01, $00
.pat5:
	db $a2, $30, $34, $36, $42, $48, $4c, $4e, $5a, $a5, $01, $00
.pat6:
	db $a2, $34, $38, $3a, $48, $4c, $50, $52, $60, $a5, $01, $00
.pat7:
	db $a2, $34, $38, $3a, $46, $4c, $50, $52, $5e, $a5, $01, $00
.pat8:
	db $9b, $02, $a2, $01, $38, $3c, $38, $3c, $a7, $01, $9c
	db $9b, $02, $a2, $01, $36, $3c, $36, $3c, $a7, $01, $9c
	db $9b, $02, $a2, $01, $38, $3c, $3e, $46, $a7, $01, $9c
	db $9b, $02, $a2, $01, $36, $3c, $3e, $4e, $a7, $01, $9c, $00
.pat9:
	db $9b, $02, $3e, $36, $3e, $40, $46, $48, $46, $44, $9c
	db $9b, $02, $32, $38, $40, $42, $48, $4a, $48, $42, $9c, $00
.pat10:
	db $a2, $44, $4c, $4a, $4c
	db $9d, $20, $00, $80
	db $9b, $03, $a2, $44, $4c, $4a, $4c, $9c
	db $9b, $03, $42, $48, $4a, $48, $9c
	db $9d, $10, $00, $80, $42, $48, $4a, $48, $00
.pat11:
	db $a2, $44, $4c, $4a, $4c
	db $9d, $37, $00, $80, $44, $4c, $4a, $4c
	db $9d, $53, $00, $80, $44, $4c, $4a, $4c
	db $9d, $64, $00, $80, $44, $4c, $4a, $4c
	db $9d, $53, $00, $80, $42, $48, $4a, $48
	db $9d, $37, $00, $80, $42, $48, $4a, $48
	db $9d, $27, $00, $80
	db $9b, $02, $42, $48, $4a, $48, $9c, $00
.pat12:
	db $a2, $01, $30, $34, $36, $44, $48, $4c, $4e, $60, $64, $66, $74, $a4, $01, $a2
	db $01, $30, $34, $36, $42, $48, $4c, $4e, $60, $64, $66, $72, $a4, $01, $a2, $01
	db $34, $38, $3a, $48, $4c, $50, $52, $64, $68, $6a, $78, $a4, $01, $a2, $01, $00
.pat13:
	db $34, $38, $3a, $46, $4c, $50, $52, $64, $68, $6a, $76, $a4, $01, $00
.pat14:
	db $9b, $18, $a5, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $4C: requested in bank $07.
;@ Entry 44 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4C::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m1APat20, .pat1, MusicCommonData_1E.m4CPat7, .pat2, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m1APat20, .pat3, MusicCommonData_1E.m4CPat7, .pat4, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1E.m1APat25, .pat5, MusicCommonData_1E.m23Pat32, .pat6, $0000
.pat1:
	db $a1, $01, $a4, $01, $a3, $1c, $20, $a8, $22, $a3, $01, $22, $26, $a7, $2a, $a2
	db $2e, $00
.pat2:
	db $ae, $1a, $00
.pat3:
	db $a1, $01, $a4, $01, $a3, $2e, $30, $a8, $34, $a3, $01, $34, $38, $a7, $3a, $a2
	db $3e, $00
.pat4:
	db $ae, $42, $00
.pat5:
	db $9b, $02, $99, $a1, $0e, $9a, $a5, $0e, $a3, $0e, $a6, $01, $9c, $00
.pat6:
	db $a1, $01, $ae, $14, $00

;@ path: sound/music/songs
;@ Music track $4D: Marin at the beach.
;@ Where: MarinBeachMusic.
;@ Entry 45 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4D::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m13Pat6, MusicCommonData_1E, .pat1, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m16Pat8, .pat1
.sq1Loop: ; square 1 pattern list
	dw .pat2, $FFFF, MusicCommonData_1E.m1AWave
.wave: ; wave pattern list
	dw MusicCommonData_1E.m15Pat16, MusicCommonData_1E.m1APat28, .pat3, $FFFF, MusicCommonData_1E.m1AWave
.pat1: ; tracks $4D, $4E
	db $a1, $80, $78, $72, $6a, $68, $60, $5a, $50, $00
.pat2:
	db $a1, $54, $5c, $62, $6a, $6c, $74, $7a, $82, $00
.pat3:
	db $99, $a2, $54, $54, $00

;@ path: sound/music/songs
;@ Music track $4E: Marin at the beach (answer).
;@ Where: MarinBeachAnswer.
;@ Entry 46 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4E::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m4BPat10, .pat2, .pat3
.sq2Loop:
	dw MusicCommonData_1E.m1APat31, MusicCommonData_1E.m4EPat10, .pat4, MusicCommonData_1E, MusicCommonData_1E.m13Pat6, Music4D.pat1, MusicCommonData_1E.m16Pat7, MusicCommonData_1E.m1APat17
	dw .pat1, .pat9, MusicCommonData_1E.m4BPat10, .pat6, MusicCommonData_1E.m1APat21, .pat7, MusicCommonData_1E.m1APat15, $FFFF, .sq2Loop
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m13Pat6, MusicCommonData_1E, .pat2, MusicCommonData_1E.m1APat17
.sq1Loop:
	dw MusicCommonData_1E.m1APat31, .pat5, MusicCommonData_1E.m16Pat8, Music4D.pat1, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17
	dw MusicCommonData_1E, MusicCommonData_1E.m13Pat6, .pat6, MusicCommonData_1E.m1APat15, MusicCommonData_1E.m1APat17, MusicCommonData_1E, $FFFF, .sq1Loop
.wave: ; wave pattern list
	dw MusicCommonData_1E.m15Pat16, MusicCommonData_1E.m16Pat7
.waveLoop:
	dw MusicCommonData_1E.m15Pat17, MusicCommonData_1E.m1APat31, MusicCommonData_1E, Music16.m15Pat15, .pat8, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m1APat17, MusicCommonData_1E.m15Pat16
	dw MusicCommonData_1E.m16Pat7, $FFFF, .waveLoop
.pat1:
	db $9d, $c2, $83, $c0, $00
.pat2:
	db $a1, $44, $48, $4c, $50, $56, $5c, $60, $64, $00
.pat3:
	db $68, $6e, $00
.pat4:
	db $9d, $b1, $83, $80, $a6, $01, $64, $68, $6a
	db $9d, $81, $83, $80, $a2, $3e, $42, $44, $4c, $52, $a1, $01
	db $9d, $b1, $83, $80, $a6, $64, $68, $6a
	db $9d, $81, $83, $80, $a2, $30, $3e, $44, $4c, $50
	db $9d, $b1, $83, $80, $68, $64, $5a, $60
	db $9d, $81, $83, $80, $3a, $42, $64, $50, $a7, $01, $a2, $34, $3c, $42, $48, $4c
	db $9d, $b1, $83, $80, $64, $68, $6a
	db $9d, $81, $83, $80, $a2, $3e, $42, $44, $4c, $52
	db $9d, $b1, $83, $80, $60, $6a, $74
	db $9d, $81, $83, $80, $a2, $30, $3e, $44, $4c, $56
	db $9d, $b1, $83, $80, $72, $6e, $72
	db $9d, $81, $83, $80, $a2, $3a, $42, $48, $50, $52, $5a, $60, $68, $78, $01, $90
	db $01, $00
.pat5:
	db $9b, $11, $a4, $01, $9c, $00
.pat6:
	db $a1, $1c, $22, $2a, $30, $38, $3a, $42, $48, $50, $48, $42, $3a, $38, $30, $2a
	db $22, $18, $26, $2c, $34, $3e, $44, $00
.pat7:
	db $4c, $56, $60, $a9, $01, $00
.pat8:
	db $a9, $01, $a3, $01, $a3, $80, $7c, $72, $a7, $72, $a4, $74, $a7, $01, $a3, $86
	db $82, $72, $a7, $72, $a3, $74, $a2, $01, $a3, $74, $a3, $78, $01, $a2, $66, $6c
	db $78, $a4, $72, $a7, $01, $a2, $6a, $a4, $7c, $01, $a2, $01, $a7, $7a, $8c, $a3
	db $8a, $00
.pat9:
	db $9d, $c2, $83, $c0, $a3, $80, $7c, $72, $a2, $72
	db $9d, $72, $00, $80, $26, $34
	db $9d, $c2, $83, $c0, $74
	db $9d, $72, $00, $80, $a1, $3e, $42, $44, $4c, $56, $5a, $5c, $6a, $34, $42, $50
	db $60
	db $9d, $c2, $83, $c0, $a3, $86, $82, $72, $a2, $72
	db $9d, $72, $00, $80, $3e, $4c
	db $9d, $c2, $83, $c0, $74
	db $9d, $72, $00, $80, $a1, $56, $5a, $5c, $64
	db $9d, $c2, $83, $c0, $a3, $74, $78
	db $9d, $72, $00, $80, $a1, $4e, $54, $5a, $60
	db $9d, $c2, $83, $c0, $a2, $66, $6c, $78, $72
	db $9d, $72, $00, $80, $a1, $01, $52, $5a, $60, $6a, $72, $78, $7e, $a3, $82
	db $9d, $c2, $83, $c0, $a2, $6a, $7c
	db $9d, $72, $00, $80, $a1, $2c, $34, $3a, $42, $44, $4c, $52, $5a, $4c, $52, $5a
	db $5c, $52, $5a, $5c, $64
	db $9d, $c2, $83, $c0, $a7, $7a, $8c, $a3, $8a
; (the pattern goes on in the next unit)

;@ path: sound/music/songs
;@ Music track $4F: not requested directly.
;@ Entry 47 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4F::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, .waveLoop, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m12Pat19, .pat3, MusicCommonData_1E.m1APat16, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m14Pat15
.wave:
	dw .pat1
.sq1Loop: ; square 1 pattern list
	dw .pat2, $0000
.waveLoop: ; wave pattern list
	dw MusicCommonData_1E.m15Pat17, MusicCommonData_1E, $FFFF, .wave
.pat1:
	db $a1, $52, $5a, $60, $68, $6a, $72, $78, $80, $00
.pat2:
	db $a3, $01, $a1, $8a, $90, $01, $01, $00
.pat3:
	db $9b, $02, $a1, $3a, $42, $48, $42, $9c, $00

;@ path: sound/music/songs
;@ Music track $5C: Evil Eagle's arena.
;@ Where: EvilEagleArenaSetup.
;@ Entry 60 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5C::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m11Pat5, Music54.m5CPat2, MusicCommonData_1E.m23Pat30, Music54.m5CPat2, Music54.m5CPat2, MusicCommonData_1E.m11Pat5, Music54.m5CPat2, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat19, Music54.m5CPat1, MusicCommonData_1E.m14Pat13, MusicCommonData_1E.m1CPat2, Music54.m5CPat1, MusicCommonData_1E.m23Pat36, Music54.m5CPat1, MusicCommonData_1E.m12Pat19
	dw MusicCommonData_1E.m5CPat3, Music54.m5CPat1, MusicCommonData_1E.m23Pat33, $FFFF, .sq2

;@ path: sound/music/songs
;@ Music track $54: Evil Eagle.
;@ Where: GrimCreeperCallEagleState.
;@ Entry 52 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music54::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1E.m11Pat5, .m5CPat2, MusicCommonData_1E.m23Pat30, .m5CPat2, MusicCommonData_1E.m1APat20, .m5CPat2, .m5CPat2, .m5CPat2
	dw .m5CPat2, .m5CPat2, MusicCommonData_1E.m23Pat37, $FFFF, Music19.sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1E.m12Pat19, .m5CPat1, MusicCommonData_1E.m14Pat13, MusicCommonData_1E.m1CPat2, .m5CPat1, MusicCommonData_1E.m23Pat29, MusicCommonData_1E.m23Pat36, .m5CPat1
	dw MusicCommonData_1E.m5CPat3, .m5CPat1, MusicCommonData_1E.m14Pat13, MusicCommonData_1E.m23Pat33, .pat1, MusicCommonData_1E.m14Pat15, MusicCommonData_1E.m1CPat2, .pat1
	dw MusicCommonData_1E.m23Pat29, MusicCommonData_1E.m23Pat36, .pat1, MusicCommonData_1E.m23Pat33, MusicCommonData_1E.m23Pat37, $FFFF, Music19.sq2
.wave: ; wave pattern list
	dw MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m12Pat17, MusicCommonData_1E.m1APat14, MusicCommonData_1E.m23Pat37, $FFFF, Music19.wave
.noise: ; noise pattern list
	dw .pat2, MusicCommonData_1E.m23Pat37, $FFFF, Music19.noise
.m5CPat1: ; tracks $54, $5C
	db $9b, $02, $a1, $06, $0c, $12, $1a, $1e, $24, $2a, $32, $9c, $00
.pat1:
	db $9b, $02, $a1, $1e, $24, $2a, $32, $36, $3c, $42, $4a, $9c, $00
.m5CPat2: ; tracks $54, $5C
	db $99, $a2, $06, $06, $a8, $01, $00
.pat2:
	db $9b, $07, $a5, $01, $9c, $00

;@ path: sound/music/songs
;@ Wave patterns (16 bytes = 32 4-bit samples) and short patterns of several songs of bank $1E, mostly a single instrument change ($9D) or a rest.
MusicCommonData_1E::
.m1APat13: ; tracks $13, $18, $1A, $1C, $1E, $22, $24, $4D, $4E, $4F, $51, $53, $5B
	db $a1, $01, $a9, $01, $00
.m1APat14: ; tracks $11, $12, $15, $19, $1A, $23, $4E, $54
	db $a5, $01, $00
.m15Pat16: ; tracks $15, $16, $4D, $4E, $53
	db $a4, $01, $00
; (not used by any song)
	db $a5, $01, $a8, $01, $00
.m12Pat17: ; tracks $12, $14, $15, $19, $1E, $1F, $21, $4E, $52, $54, $5B
	db $a5, $01, $01, $00
.m16Pat7: ; tracks $16, $1B, $22, $4E, $58
	db $a2, $01, $00
.m1APat15: ; tracks $1A, $1B, $23, $4E, $5A
	db $a6, $01, $00
.m1APat16: ; tracks $1A, $23, $4F
	db $a1, $01, $00
.m1APat17: ; tracks $16, $1A, $1E, $4E
	db $a0, $01, $00
.m1AWave: ; wave pattern list
	dw .m1APat14, $FFFF, .m1AWave
; (not used by any song)
	db $99, $00
.waveform3: ; wave pattern: 32 4-bit samples
	db $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
.waveform4: ; wave pattern: 32 4-bit samples
	db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.waveform5: ; wave pattern: 32 4-bit samples
	db $99, $99, $99, $99, $00, $00, $00, $00, $99, $99, $99, $99, $00, $00, $00, $00
.waveform6: ; wave pattern: 32 4-bit samples
	db $44, $44, $44, $44, $00, $00, $00, $00, $44, $44, $44, $44, $00, $00, $00, $00
.m5APat8: ; tracks $5A, $5B
	db $9d, $10, $00, $80, $00
.m13Pat6: ; tracks $13, $18, $1E, $4D, $4E, $51, $53, $58, $5B
	db $9d, $20, $00, $80, $00
.m12Pat18: ; tracks $12, $14, $15, $52
	db $9d, $24, $83, $c0, $00
.m16Pat8: ; tracks $16, $4D, $4E
	db $9d, $46, $86, $80, $00
.m14Pat13: ; tracks $14, $15, $52, $54, $5C
	db $9d, $81, $83, $c0, $00
.m14Pat14: ; tracks $14, $52
	db $9d, $a2, $83, $c0, $00
.m4EPat10:
	db $9d, $91, $83, $80, $00
.m12Pat19: ; tracks $12, $14, $15, $4F, $52, $54, $5C
	db $9d, $52, $83, $c0, $00
.m4BPat10: ; tracks $4B, $4E, $53
	db $9d, $62, $00, $80, $00
.m5APat9:
	db $9d, $82, $00, $80, $00
.m13Pat7: ; tracks $13, $4B, $51
	db $9d, $62, $00, $c0, $00
.m13Pat8: ; tracks $13, $4B, $51
	db $9d, $92, $00, $c0, $00
.m13Pat9: ; tracks $13, $51
	db $9d, $b2, $00, $c0, $00
.m14Pat15: ; tracks $14, $4F, $52, $54
	db $9d, $c1, $83, $00, $00
.m1APat18: ; tracks $1A, $53
	db $9d, $45, $00, $80, $00
.m5APat10:
	db $9d, $53, $00, $80, $00
.m19Pat12:
	db $9d, $93, $00, $00, $00
.m1APat19: ; tracks $16, $17, $1A, $1B, $1E, $22, $58
	db $9d, $64, $00, $80, $00
.m23Pat28:
	db $9d, $84, $86, $80, $00
; (not used by any song)
	db $9d, $b4, $86, $80, $00, $9d, $e4, $86, $80, $00
.m11Pat5: ; tracks $11, $12, $1E, $23, $54, $5C
	db $9d, $75, $86, $80, $00
.m14Pat16: ; tracks $14, $52, $58
	db $9d, $a5, $00, $80, $00
.m23Pat29: ; tracks $23, $54
	db $9d, $f5, $86, $80, $00
.m23Pat30: ; tracks $1E, $23, $54, $5C
	db $9d, $a5, $86, $80, $00
.m21Pat2:
	db $9d, $a5, $46, $80, $00
.m14Pat17: ; tracks $14, $52, $58
	db $9d, $85, $00, $80, $00
.m1APat20: ; tracks $1A, $4C, $54
	db $9d, $e7, $86, $80, $00
; (not used by any song)
	db $9d, $17, $00, $80, $00
.m1APat21: ; tracks $16, $17, $18, $1A, $1B, $1C, $1E, $22, $24, $26, $4E, $53, $58, $5A, $5B
	db $9d, $27, $00, $80, $00
.m16Pat9: ; tracks $16, $17, $18, $1E, $1F, $24, $58, $5B
	db $9d, $37, $00, $80, $00
.m1APat22: ; tracks $14, $16, $17, $18, $1A, $1E, $1F, $26, $52, $58
	db $9d, $47, $00, $80, $00
.m1APat23:
	db $9d, $86, $00, $c0, $00
.m14Pat18: ; tracks $14, $1F, $52
	db $9d, $66, $00, $80, $00
.m1APat24: ; tracks $18, $1A, $1E
	db $9d, $87, $00, $80, $00
.m12Pat20: ; tracks $12, $14, $19, $52
	db $9d, $48, $00, $80, $00
.m5DPat2: ; tracks $1F, $5D
	db $9d, $38, $00, $81, $00
.m11Pat6:
	db $9d, $48, $86, $80, $00
.m12Pat21:
	db $9d, $48, $00, $00, $00
.m4BPat11:
	db $9d, $58, $00, $00, $00
.m23Pat31: ; tracks $12, $23
	db $9d, $a8, $86, $c0, $00
.m12Pat22: ; tracks $12, $16
	db $9d, $88, $00, $00, $00
.m4CPat7:
	db $9d, $1f, $00, $00, $00
.m19Pat13:
	db $9d, $5f, $00, $80, $00
.m1APat25: ; tracks $12, $13, $1A, $23, $4C, $51, $5A
	db $9d
	dw .waveform3
	db $20, $00
.m23Pat32: ; tracks $12, $14, $19, $23, $4C, $52
	db $9d
	dw .waveform4
	db $20, $00
.m14Pat19: ; tracks $14, $16, $19, $52
	db $9d
	dw .waveform4
	db $40, $00
.m1APat26: ; tracks $11, $12, $15, $1A
	db $9d
	dw .waveform5
	db $20, $00
.m1DPat8: ; tracks $1D, $53, $5B
	db $9d
	dw .waveform5
	db $40, $00
.m15Pat17: ; tracks $15, $1D, $4B, $4E, $4F, $5B
	db $9d
	dw .waveform5
	db $60, $00
.m1APat27: ; tracks $15, $1A
	db $9d
	dw .waveform6
	db $40, $00
.m1APat28: ; tracks $15, $1A, $1B, $4D, $5B
	db $9d
	dw .waveform6
	db $60, $00
.m23Pat33: ; tracks $14, $15, $19, $1D, $1E, $23, $52, $54, $5C
	db $9f, $00, $00
.m1FPat14:
	db $9f, $18, $00
; (not used by any song)
	db $9f, $16, $00
.m14Pat20: ; tracks $14, $52
	db $9f, $0e, $00
.m14Pat21: ; tracks $14, $52
	db $9f, $0c, $00
.m14Pat22: ; tracks $14, $52
	db $9f, $0a, $00
.m23Pat34: ; tracks $19, $23
	db $9f, $08, $00
.m23Pat35:
	db $9f, $06, $00
.m23Pat36: ; tracks $14, $15, $1E, $23, $52, $54, $5C
	db $9f, $04, $00
.m5CPat3: ; tracks $54, $5C
	db $9f, $02, $00
.m26Pat1:
	db $9f, $d0, $00
.m1CPat2: ; tracks $1C, $54, $5C
	db $9f, $fe, $00
.m23Pat37: ; tracks $23, $54
	db $9e
	dw NoteLengths48_1E
	db $00
.m53Pat5:
	db $9e
	dw NoteLengths64_1E
	db $00
.m1APat29: ; tracks $1A, $1E, $53
	db $9e
	dw NoteLengths96_1E
	db $00
.m1APat30: ; tracks $1A, $23
	db $9e
	dw NoteLengths112_1E
	db $00
.m1APat31: ; tracks $1A, $4E
	db $9e
	dw NoteLengths128_1E
	db $00
.m12Pat23:
	db $9e
	dw NoteLengths144_1E
	db $00

;@ path: data/padding
;@ Unused space of bank $1E, filled with $FF.
Padding_1E_6EB8::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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

;@ path: sound/music/songs
;@ Music track $41: not requested directly.
;@ Entry 33 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music41::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, MusicSilentChannel_1E, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, Music42.m41Pat4, Music42.m41Pat5, $0000
.wave: ; wave pattern list
	dw .pat2, Music42.m41Pat4, Music42.m41Pat3, Music42.m41Pat5, $0000
.pat1:
	db $9d, $20, $00, $81, $a2, $01, $a9, $01, $00
.pat2:
	db $9d
	dw Music28.waveform8
	db $01, $94, $00

;@ path: sound/music/songs
;@ Music track $42: not requested directly.
;@ Entry 34 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music42::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, .m41Pat4, .m41Pat5, $0000
.sq2: ; square 2 pattern list (tracks $42, $43)
	dw .pat2, $0000
.wave: ; wave pattern list (tracks $42, $43, $44, $45, $46, $47)
	dw .pat3, .m41Pat4, .m41Pat3, .m41Pat5, $0000
.pat1:
	db $9d, $20, $00, $81, $a2, $01, $a9, $01, $ae, $01, $00
.pat2: ; tracks $42, $43
	db $9d, $47, $00, $80, $96
	db $9b, $0a, $a3, $74, $66, $6a, $78, $9c
	db $9b, $02, $6e, $60, $66, $6e, $70, $60, $6a, $70, $9c, $74, $62, $6a, $74, $7a
	db $68, $6e, $74, $70, $60, $66, $70, $6a, $5e, $64, $76
	db $9b, $02, $74, $66, $6a, $78, $9c, $95, $00
.pat3: ; tracks $42, $43, $44, $45, $46, $47
	db $9d
	dw Music28.waveform8
	db $01, $ae, $01, $94, $00
.m41Pat3: ; tracks $41, $42, $43, $44, $45, $46, $47
	db $9d
	dw Music20.waveform7
	db $01, $94, $00
.m41Pat4: ; tracks $41, $42, $43, $44, $45, $46, $47
	db $96, $a2, $01, $30, $34, $a8, $36, $a2, $30, $34, $a8, $36, $a2, $34, $30, $26
	db $a7, $2c, $a5, $30, $a3, $01, $a2, $30, $34, $a8, $36, $a2, $2c, $36, $a8, $40
	db $a2, $3e, $3a, $a5, $3e, $01, $a2, $01, $00
.m41Pat5: ; tracks $41, $42, $43, $44, $45, $46, $47
	db $a3, $01, $64, $60, $56, $a7, $56, $a5, $58, $a2, $6a, $66, $64, $60, $56, $52
	db $56, $60, $a7, $58, $a2, $58, $a4, $5c, $a2, $01, $4a, $52, $5c, $a8, $56, $a2
	db $01, $4e, $a8, $60, $a7, $01, $5e, $70, $6e, $01, $a4, $01, $a5, $01, $95, $00

;@ path: sound/music/songs
;@ Music track $43: not requested directly.
;@ Entry 35 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music43::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw Music42.sq2, .sq2, Music42.wave, $0000
.sq2: ; square 2 pattern list (tracks $43, $44, $45, $47)
	dw .pat1, .pat2, .pat3, .pat3, .pat4, $0000
.pat1: ; tracks $43, $44, $45, $47
	db $9d, $71, $82, $80, $96
	db $9b, $04, $a2, $4e, $56, $64, $5c, $9c
.pat2:
	db $9b, $04, $52, $58, $66, $60, $9c
	db $9b, $04, $4e, $56, $64, $60, $9c, $00
.pat3: ; tracks $43, $44, $45, $46, $47, $4A
	db $9b, $02, $a2, $48, $4e, $60, $56, $9c
	db $9b, $02, $48, $52, $60, $58, $9c, $00
.pat4: ; tracks $43, $44, $45, $46, $47, $4A
	db $9b, $02, $44, $4a, $58, $52, $9c
	db $9b, $02, $44, $4a, $56, $50, $9c
	db $9b, $02, $40, $48, $56, $4e, $9c
	db $9b, $02, $40, $46, $52, $4c, $9c
	db $9b, $04, $4e, $56, $64, $5c, $9c, $95, $00

;@ path: sound/music/songs
;@ Music track $44: not requested directly.
;@ Entry 36 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music44::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, Music43.sq2, Music42.wave, $0000
.sq1: ; square 1 pattern list (tracks $44, $45)
	dw .pat1, .pat2, .pat2, .pat3, $0000
.pat1: ; tracks $44, $45, $46, $47
	db $9d, $87, $00, $80, $96, $a5, $8c, $8c, $00
.pat2: ; tracks $44, $45, $46, $47
	db $9d, $87, $00, $80, $a5, $8c, $8c
	db $9d, $37, $00, $80
	db $9b, $02, $a3, $74, $66, $6a, $78, $9c, $00
.pat3: ; tracks $44, $45
	db $9d, $76, $00, $80
	db $9b, $02, $a4, $90, $86, $90, $88, $9c, $8c, $88, $86, $8c, $90, $88, $8e, $88
	db $9d, $87, $00, $80, $a5, $8c, $8c, $00

;@ path: sound/music/songs
;@ Music track $45: not requested directly.
;@ Entry 37 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music45::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw Music44.sq1, Music43.sq2, Music42.wave, .noise
.noise: ; noise pattern list (tracks $45, $46)
	dw .pat1, $0000
.pat1: ; tracks $45, $46
	db $9b, $0a, $a1, $1f, $1f, $1f, $1f, $a2, $1f, $a3, $24, $a2, $1f, $a3, $24, $a1
	db $1f, $1f, $1f, $1f, $a3, $24, $a1, $1f, $1f, $1f, $1f, $a3, $24, $9c, $00
;@ path: sound/music/songs
;@ Music track $46: not requested directly.
;@ Entry 38 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music46::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, Music42.wave, Music45.noise
.sq1: ; square 1 pattern list
	dw Music44.pat1, Music44.pat2, Music44.pat2, .pat4, Music43.pat3, Music43.pat3, Music43.pat4, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat2, .pat3, $0000
.pat1:
	db $9d, $19, $45, $40, $96
	db $9b, $02, $a3, $1e, $2c, $26, $2c, $9c
.pat2:
	db $9b, $02, $22, $30, $28, $30, $9c
	db $9b, $02, $1e, $2c, $26, $2c, $9c, $00
.pat3: ; tracks $46, $47
	db $9b, $02, $a3, $18, $26, $1e, $26, $18, $28, $22, $28, $9c, $2c, $22, $1a, $22
	db $2c, $20, $1a, $20, $28, $1e, $18, $1e, $28, $1c, $16, $1c
	db $9b, $02, $1e, $2c, $26, $2c, $9c, $00
.pat4:
	db $9d, $61, $82, $80, $00

;@ path: sound/music/songs
;@ Music track $47: not requested directly.
;@ Entry 39 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music47::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw Music43.sq2, .sq2, Music42.wave, .noise
.sq2: ; square 2 pattern list
	dw Music44.pat1, Music44.pat2, Music44.pat2, .pat1, Music46.pat3, $0000
.noise: ; noise pattern list
	dw .pat2, .pat2, .pat2, .pat2, .pat2, .pat2, .pat2, .pat2
	dw .pat2, .pat2, .pat3, .pat2, .pat3, .pat2, .pat2, .pat2
	dw .pat2, .pat2, .pat2, .pat2, $0000
.pat1:
	db $9d, $19, $45, $40, $00
.pat2:
	db $9b, $03, $a2, $1a, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c, $a2
	db $1a, $1a, $00
.pat3:
	db $9b, $02, $a1, $1f, $1f, $1f, $1f, $a2, $1f, $a3, $24, $a2, $1f, $a3, $24, $00

;@ path: sound/music/songs
;@ Music track $20: not requested directly.
;@ Entry 16 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music20::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat3, $0000
.wave: ; wave pattern list
	dw .pat2, $0000
.pat1:
	db $9d, $20, $00, $41, $a1, $01, $a0, $01, $00
.pat2:
	db $9d
	dw .waveform7
	db $01, $94
.pat3:
	db $a2, $60, $64, $a8, $66, $a2, $60, $64, $a4, $66, $a2, $64, $a6, $60, $a3, $56
	db $ae, $6e, $9a
	db $9b, $20, $a5, $01, $9c, $00
.waveform7: ; wave pattern: 32 4-bit samples
	db $01, $35, $66, $53, $10, $02, $46, $8a, $01, $35, $66, $53, $10, $02, $46, $8a

;@ path: sound/music/songs
;@ Music track $28: not requested directly.
;@ Entry 24 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music28::
	db $00 ; transpose
	dw NoteLengths144_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat3, $0000
.wave: ; wave pattern list
	dw .pat2, $0000
.pat1:
	db $9d, $20, $00, $41, $a1, $01, $a0, $01, $00
.waveform8: ; wave pattern: 32 4-bit samples
	db $06, $9b, $cd, $de, $ee, $ff, $ff, $fe, $06, $9b, $cd, $de, $ee, $ff, $ff, $fe
.pat2:
	db $9d
	dw .waveform8
	db $01, $94
.pat3:
	db $a1, $30, $34, $a4, $36, $a3, $01, $a1, $30, $34, $a2, $36, $34, $a6, $30, $a3
	db $26, $a2, $01, $a5, $3e
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $29: not requested directly.
;@ Entry 25 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music29::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat1, .pat2, $FFFF, Music30.m29Sq2
.wave: ; wave pattern list
	dw .pat3, $FFFF, Music30.m29Sq2
.pat1:
	db $9d, $81, $00, $80, $a1, $74, $66, $6a, $78
	db $9d, $a6, $00, $80, $a4, $74, $00
.pat2:
	db $9d, $82, $00, $80, $a2, $74, $66, $a6, $6a
	db $9d, $85, $00, $80, $a3, $78
	db $9d, $a6, $00, $80, $ae, $74, $00
.pat3:
	db $9d
	dw Music2C.waveform11
	db $23, $99
	db $9b, $02, $a1, $6a, $5c, $60, $6e, $a4, $6a, $9c, $a2, $6a, $5c, $a6, $60, $a3
	db $6e, $ae, $6a
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $2A: not requested directly.
;@ Entry 26 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2A::
	db $18 ; transpose
	dw NoteLengths48_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat3, $0000
.wave: ; wave pattern list
	dw .pat2, $0000
.pat1:
	db $9d, $10, $00, $80, $a3, $01, $a1, $01, $00
.waveform9: ; wave pattern: 32 4-bit samples
	db $46, $79, $98, $64, $43, $10, $01, $34, $46, $79, $98, $64, $43, $10, $01, $34
.pat2:
	db $9d
	dw .waveform9
	db $20, $99
.pat3:
	db $a3, $62, $60, $58, $52, $a6, $4a, $48, $4a, $52, $58, $ab, $60, $58, $52, $4a
	db $a2, $48, $4a, $52, $58, $60, $58, $52, $4a, $48, $4a, $52, $58
	db $9b, $02, $5e, $56, $50, $48, $46, $48, $50, $56, $9c, $58, $50, $4a, $42, $40
	db $42, $4a, $50, $ab, $54, $4c, $46, $3e, $a6, $3c, $3e, $a3, $46, $4c, $aa, $01
	db $a2, $50
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $2B: not requested directly.
;@ Entry 27 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2B::
	db $00 ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, Music30.m29Sq2
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, Music30.m29Sq2
.wave: ; wave pattern list
	dw .pat3, $FFFF, Music30.m29Sq2
.pat1:
	db $9d, $81, $00, $80, $a1, $01, $a2, $6e
	db $9d, $c1, $00, $80, $a2, $6e, $a6, $01, $a4, $01
	db $9d, $a2, $00, $80, $a2, $01, $a3, $64, $6a, $74, $6a, $78
	db $9d, $a7, $00, $80, $ae, $8c, $00
.pat2:
	db $9d, $61, $00, $80, $a2, $6e
	db $9d, $a1, $00, $80, $a2, $6e
	db $9d, $e5, $00, $80, $a8, $6e
	db $9d, $a2, $00, $80, $a3, $60, $66, $6e, $72, $6e, $82
	db $9d, $a7, $00, $80, $ae, $86, $00
.waveform10: ; wave pattern: 32 4-bit samples
	db $66, $00, $66, $00, $66, $00, $66, $00, $66, $00, $66, $00, $66, $00, $66, $00
.pat3:
	db $9d
	dw .waveform10
	db $23, $99, $a1, $64, $64, $64, $64, $a8, $64, $a2, $56, $5a, $5c, $78, $64, $6a
	db $68, $60, $64, $6e, $78, $82, $ae, $7c, $00

;@ path: sound/music/songs
;@ Music track $2C: not requested directly.
;@ Entry 28 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2C::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat2, .pat1, .pat3, .pat1, .pat3, .pat1, .pat2
	dw .pat1, .pat3, .pat1, .pat4, .pat6, $0000
.wave: ; wave pattern list
	dw .pat5, $0000
.pat1:
	db $9d, $21, $00, $80, $a1, $78
	db $9d, $41, $00, $80, $a1, $78
	db $9d, $71, $00, $80, $a1, $78
	db $9d, $a1, $00, $80, $a1, $78, $00
.pat2:
	db $9d, $a1, $00, $80, $a2, $78
	db $9d, $c3, $00, $80, $a3, $78
	db $9d, $82, $00, $80, $a2, $78
.pat3:
	db $9d, $d2, $00, $80, $a3, $78, $00
.pat4:
	db $9d, $e3, $00, $80, $ae, $78, $00
.waveform11: ; wave pattern: 32 4-bit samples
	db $00, $0c, $00, $0c, $00, $0c, $00, $0c, $06, $06, $06, $06, $06, $06, $06, $06
.pat5:
	db $9d
	dw .waveform11
	db $20, $99
	db $9b, $02, $a1, $86, $86, $86, $86, $a2, $86, $a3, $86, $a2, $86, $a3, $86, $a1
	db $86, $86, $86, $86, $a3, $86, $a1, $86, $86, $86, $86, $a3, $86, $9c, $9a
.pat6:
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $2D: not requested directly.
;@ Entry 29 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2D::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw MusicSilentChannel_1E, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat3, $FFFF, Music30.m29Sq2
.wave: ; wave pattern list
	dw .pat2, $FFFF, Music30.m29Sq2
.pat1:
	db $9d, $20, $00, $80, $a2, $01, $a9, $01, $00
.waveform12: ; wave pattern: 32 4-bit samples
	db $88, $88, $88, $84, $00, $00, $00, $00, $88, $88, $88, $84, $00, $00, $00, $00
.pat2:
	db $9d
	dw .waveform12
	db $00, $94
.pat3:
	db $a2, $48, $4c, $a8, $4e, $a2, $48, $4c, $a3, $4e, $4c, $48, $a0, $01, $a3, $3e
	db $a1, $01, $a5, $56, $00

;@ path: sound/music/songs
;@ Music track $2E: not requested directly.
;@ Entry 30 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2E::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw MusicSilentChannel_1E, .sq2, MusicSilentChannel_1E, .noise
.sq2: ; square 2 pattern list
	dw .pat1, .pat1, .pat2, .pat1, .pat1, .pat2, $FFFF, Music30.m29Sq2
.noise: ; noise pattern list
	dw .pat3, .pat3, .pat4, $0000
.pat1:
	db $9d, $a1, $00, $80, $97, $a2, $36
	db $9d, $61, $00, $80, $a9, $2c, $ad, $01, $a9, $2c, $ad, $01, $a9, $2c, $00
.pat2:
	db $a1, $2c
	db $9d, $a1, $00, $80, $a1, $36
	db $9d, $61, $00, $80, $a1, $2c, $2c
	db $9d, $a1, $00, $80, $a2, $36, $36, $00
.pat3:
	db $9b, $02, $a2, $ff, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c, $a1
	db $15, $ff, $15, $15, $a2, $ff, $ff, $00
.pat4:
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $2F: Marin.
;@ Where: EntityInit_Marin, WalrusAskMarin.
;@ Entry 31 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music2F::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .waveLoop, $0000
.sq1: ; square 1 pattern list
	dw .pat1
.wave:
	dw .pat3, .pat4, .pat5, $FFFF, .wave
.sq2: ; square 2 pattern list
	dw .pat2, .pat4, .pat5, $FFFF, .sq2
.waveLoop: ; wave pattern list
	dw .pat6, $FFFF, .wave
.pat1:
	db $9d, $20, $00, $80, $a1, $01, $a9, $01, $00
.pat2: ; tracks $2F, $4A
	db $9d, $60, $21, $80
.pat3:
	db $a2, $01, $60, $64, $a8, $66, $a2, $60, $64, $a8, $66, $a2, $64, $60, $56, $a7
	db $5c, $a5, $60, $a3, $01, $00
.pat4:
	db $a2, $60, $64, $a8, $66, $a2, $5c, $66, $a8, $70, $a2, $6e, $6a, $a5, $6e, $01
	db $a7, $01, $00
.pat5: ; tracks $2F, $4A
	db $a3, $7c, $78, $6e, $a7, $6e, $a5, $70, $a2, $82, $7e, $7c, $78, $6e, $6a, $6e
	db $78, $a7, $70, $a2, $70, $a4, $74, $a2, $01, $62, $6a, $74, $a8, $6e, $a2, $01
	db $66, $a5, $78, $a2, $01, $a7, $76, $88, $86, $01, $a5, $01, $00
.pat6:
	db $9d
	dw MusicCommonData_1E.waveform6
	db $60, $a3, $01, $a1, $01, $00

;@ path: sound/music/songs
;@ Music track $4A: not requested directly.
;@ Entry 42 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music4A::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw Music43.pat2, Music43.pat2, Music43.pat3, Music43.pat3, Music43.pat4, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw Music2F.pat2, .pat2, Music2F.pat5, $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat3, $FFFF, .wave
.pat1:
	db $9d, $19, $42, $40, $a7, $01, $a2, $01, $00
.pat2:
	db $a2, $30, $34, $a8, $36, $a2, $2c, $36, $a8, $40, $a2, $3e, $3a, $ae, $3e, $a4
	db $01, $a7, $01, $00
.waveform13: ; wave pattern: 32 4-bit samples
	db $01, $37, $9a, $bb, $bb, $bb, $a6, $21, $01, $37, $9a, $bb, $bb, $bb, $a6, $21
.pat3:
	db $9d
	dw .waveform13
	db $40
	db $9b, $08, $a5, $01, $9c, $a8, $01, $a3, $6a, $66, $a6, $5c, $a1, $01, $a7, $5c
	db $a8, $60, $a3, $01, $a1, $70, $01, $6e, $01, $6a, $01, $66, $01, $5c, $01, $58
	db $01, $5c, $01, $66, $01, $a6, $60, $01, $a2, $60, $a7, $62, $a3, $01, $a1, $52
	db $01, $58, $01, $62, $01, $a4, $5c, $a7, $01, $a2, $56, $a8, $66, $a7, $01, $a3
	db $64, $a2, $01, $a3, $5e, $a2, $01, $a3, $5c, $a4, $01, $a5, $01, $00

;@ path: sound/music/songs
;@ Music track $30: Manbo's mambo.
;@ Where: ManboStartSong.
;@ Entry 32 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music30::
	db $00 ; transpose
	dw NoteLengths160_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw .pat1, $0000
.sq2: ; square 2 pattern list
	dw .pat2, $0000
.wave: ; wave pattern list
	dw .pat3, $0000
.noise: ; noise pattern list
	dw .pat4, $0000
.pat1:
	db $9d, $62, $00, $00, $a1, $1e, $22, $24, $a6, $26, $a1, $26, $28, $2a, $a6, $2c
	db $a1, $2c, $30, $32, $34, $a3, $36, $97, $3c, $98
	db $9d, $41, $00, $80
	db $9b, $06, $a2, $78, $a1, $7e, $a2, $74, $7e, $78, $7e, $a1, $78, $a2, $74, $7e
	db $9c
	db $9d, $61, $00, $40, $a6, $70, $a1, $70, $6c, $a2, $74, $70, $70, $a1, $70, $a2
	db $6c, $74, $88, $88, $84, $a7, $88, $97, $a3, $2c, $98, $00
.pat2:
	db $9d, $81, $00, $40, $a1, $3e, $40, $42, $a6, $44, $a1, $44, $46, $48, $a6, $4a
	db $a1, $4a, $4e, $52, $54, $a4, $56, $ae, $01, $97, $a1, $01, $a2, $4a, $a1, $4a
	db $a2, $40, $a1, $30, $30, $98, $a6, $30, $a1, $30, $2c, $a2, $32, $30, $30, $a1
	db $30, $a2, $2c, $32, $a6, $30, $a1, $30, $2c, $a2, $32, $a2, $30, $97, $4a, $a1
	db $4a, $a2, $40, $a1, $30, $30, $98, $a6, $36, $a1, $36, $32, $a2, $3a, $36, $36
	db $a1, $36, $a2, $32, $3a, $a6, $36, $a1, $36, $32, $a2, $3a, $a2, $36, $97, $4a
	db $a1, $4a, $a2, $40, $a1, $30, $30, $98, $a6, $10, $a1, $10, $0c, $a2, $14, $10
	db $10, $a1, $10, $a2, $0c, $14, $10, $10, $0c, $a7, $10
	db $9d, $a1, $00, $80, $97, $a3, $3c, $98, $00
.pat3:
	db $9d
	dw Music28.waveform8
	db $20, $99, $a1, $4e, $52, $54, $a6, $56, $a1, $56, $58, $5a, $a6, $5c, $a1, $5c
	db $60, $62, $64, $a4, $66
	db $9b, $02, $a6, $28, $a1, $28, $24, $a2, $2c, $28, $28, $a1, $28, $a2, $24, $2c
	db $a6, $28, $a1, $28, $24, $a2, $2c, $28, $a6, $01, $a3, $01, $9c, $a6, $30, $a1
	db $30, $2c, $a2, $32, $30, $30, $a1, $30, $a2, $2c, $32, $a6, $30, $a1, $30, $2c
	db $a2, $32, $30, $a6, $01, $a3, $01, $a6, $40, $a1, $40, $3c, $a2, $44, $40, $40
	db $a1, $40, $a2, $3c, $44, $40, $40, $3c, $a7, $40, $a3, $01, $00
.pat4:
	db $a5, $01, $a3, $01, $ff
	db $9b, $06, $a1, $1a, $15, $15, $1a, $15, $15, $ff, $1a, $1a, $15, $15, $1a, $15
	db $15, $ff, $ff, $9c, $a6, $ff, $a1, $ff, $ff, $a2, $ff, $ff, $ff, $a1, $ff, $a2
	db $ff, $ff, $ff, $ff, $ff, $a7, $ff, $a3, $ff, $00
.m29Sq2: ; square 2 pattern list
	dw .m29Pat4, $FFFF, .m29Sq2
.m29Pat4:
	db $9b, $20, $ae, $01, $9c, $00
.m25Noise: ; noise pattern list
	dw .m25Pat1, $FFFF, .m25Noise
.m25Pat1:
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $48: Indoor map $1E.
;@ Where: SelectAreaMusic, IndoorMusicTracks (by hMapId): map $1E.
;@ Entry 40 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music48::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat3
.waveLoop:
	dw .pat4, $FFFF, .waveLoop
.pat1:
	db $9d, $42, $82, $80
	db $9b, $02, $a2, $40, $4e, $5c, $60, $a4, $01, $a2, $40, $52, $60, $62, $a4, $01
	db $9c, $a2, $40, $4e, $5c, $60, $a4, $01, $a2, $40, $4c, $5c, $5e, $a4, $01, $a2
	db $44, $52, $60, $62, $a4, $01, $a2, $42, $48, $4e, $54, $52, $a7, $01, $a2, $44
	db $4c, $52, $58, $a4, $01, $a2, $4a, $50, $56, $5c, $a4, $01, $a2, $48, $4e, $56
	db $5c, $a4, $01, $a2, $48, $4e, $56, $58, $a4, $01, $a2, $44, $4a, $52, $58, $a4
	db $01, $a2, $44, $4c, $52, $58, $a4, $01, $a2, $48, $4e, $56, $4e, $46, $4c, $52
	db $4c, $44, $4a, $52, $4a, $44, $4a, $50, $4a, $00
.pat2:
	db $9d, $50, $44, $80
	db $9b, $02, $a4, $66, $58, $5c, $a3, $01, $a2, $60, $62, $9c, $a3, $60, $66, $a4
	db $74, $a3, $01, $70, $74, $70, $66, $a2, $62, $60, $a4, $5c, $01, $a2, $01, $60
	db $62, $66, $a4, $6a, $58, $56, $a3, $01, $a2, $5c, $6a, $a4, $66, $56, $58, $a3
	db $01, $a2, $58, $56, $a3, $52, $58, $a4, $60, $a3, $01, $5c, $58, $50, $a4, $4e
	db $ae, $01, $00
.waveform14: ; wave pattern: 32 4-bit samples
	db $11, $11, $11, $10, $00, $00, $00, $00, $11, $11, $11, $10, $00, $00, $00, $00
.pat3: ; tracks $48, $55
	db $9d
	dw .waveform14
	db $20, $a2, $01, $00
.pat4:
	db $9b, $02, $a4, $66, $58, $5c, $a3, $01, $a2, $60, $62, $9c, $a3, $60, $66, $a7
	db $74, $01, $a3, $70, $74, $70, $66, $a2, $62, $60, $a7, $5c, $a4, $01, $a2, $01
	db $01, $60, $62, $66, $a4, $6a, $58, $a7, $56, $01, $a2, $5c, $6a, $a4, $66, $56
	db $a7, $58, $01, $a2, $58, $56, $a3, $52, $58, $a7, $60, $01, $a3, $5c, $58, $50
	db $a7, $4e, $a2, $01, $ae, $01, $00

;@ path: sound/music/songs
;@ Music track $55: The rooster's grave.
;@ Where: RoosterGraveWaitForSong.
;@ Entry 53 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music55::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat2, .pat1, .pat3, .pat1, .pat4, .pat1, .pat3, .pat1
	dw $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat5, $FFFF, .sq2
.wave: ; wave pattern list
	dw Music48.pat3
.waveLoop:
	dw .pat6, $FFFF, .waveLoop
.pat1:
	db $9b, $02, $ac, $7c, $7e, $9c
	db $9b, $02, $82, $84, $9c, $00
.pat2:
	db $9d, $10, $00, $00, $00
.pat3:
	db $9d, $20, $00, $00, $00
.pat4:
	db $9d, $30, $00, $00, $00
.pat5:
	db $9d, $1a, $81, $40
.pat6:
	db $9b, $20, $a2, $62, $6c, $76, $78, $9c, $00

;@ path: sound/music/songs
;@ Music track $56: requested in bank $19.
;@ Entry 54 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music56::
	db $00 ; transpose
	dw NoteLengths144_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw .pat1, .pat3
.sq1Loop:
	dw .pat4, .pat6, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2, .pat3
.sq2Loop:
	dw .pat5, $FFFF, .sq2Loop
.pat1:
	db $9d, $42, $00, $80, $a1, $01, $00
.pat2:
	db $9d, $81, $00, $80, $00
.pat3:
	db $a5, $01, $a2, $01, $97, $a0, $2e, $30, $3e, $40, $46, $40, $38, $30, $32, $34
	db $3c, $44, $4a, $44, $3c, $34, $36, $38, $40, $48, $4e, $48, $40, $38, $3a, $3c
	db $44, $4c, $52, $4c, $44, $3c, $3e, $40, $48, $50, $56, $50, $48, $40, $42, $44
	db $4c, $54, $5a, $54, $4c, $44, $46, $48, $50, $58, $5e, $58, $50, $48, $4a, $4c
	db $54, $5c, $62, $5c, $54, $4c, $4e, $50, $58, $60, $66, $60, $58, $50, $52, $54
	db $5c, $64, $6a, $64, $5c, $54
	db $9b, $02, $56, $58, $60, $68, $6e, $68, $60, $58, $56, $50, $48, $40, $48, $50
	db $9c, $56, $58, $60, $68, $6e, $68, $60, $58, $68, $60, $58, $56, $60, $58, $56
	db $50, $58, $56, $50, $48, $56, $50, $48, $40, $50, $48, $40, $38, $48, $40, $3e
	db $38, $40, $3e, $38, $30, $a5, $28, $98, $00
.pat4:
	db $9d, $10, $00, $80, $00
.pat5:
	db $9d, $1a, $81, $40
.pat6:
	db $9b, $20, $aa, $62, $6c, $76, $78, $9c, $00

;@ path: sound/music/songs
;@ Music track $57: The rooster indoors.
;@ Where: RoosterIndoors.
;@ Entry 55 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music57::
	db $0e ; transpose
	dw NoteLengths80_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat3, $FFFF, .wave
.pat1:
	db $9d, $62, $00, $40
	db $9b, $20, $a3, $32, $a2, $3a, $a3, $40, $a2, $48, $a8, $44, $a3, $2c, $a2, $36
	db $a3, $3c, $a2, $44, $a8, $40, $9c, $00
.pat2:
	db $9d, $50, $21, $80, $ae, $01, $01, $a8, $58, $a3, $01, $a2, $4e, $a3, $52, $a2
	db $40, $a5, $44, $a2, $01, $a3, $52, $a2, $5c, $a8, $58, $a3, $01, $a2, $4e, $a3
	db $52, $a2, $40, $a5, $44, $a2, $01, $a3, $40, $a2, $52, $ae, $4a, $01, $00
.pat3:
	db $9d
	dw Music27.waveform1
	db $40
	db $9b, $20, $a5, $01, $a1, $5c, $01, $a7, $74, $a5, $01, $a1, $58, $01, $a7, $70
	db $9c, $00

;@ path: sound/music/songs
;@ Music track $25: Heart container fanfare.
;@ Where: Collect_HeartContainer; starts hLastMusicTrack again.
;@ Entry 21 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music25::
	db $00 ; transpose
	dw NoteLengths128_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw .pat2, $FFFF, Music18.sq1
.sq2: ; square 2 pattern list
	dw .pat3, $FFFF, Music18.sq2
.wave: ; wave pattern list
	dw .pat4, $FFFF, Music30.m29Sq2
.noise: ; noise pattern list
	dw .pat5, $FFFF, Music30.m25Noise
.pat2:
	db $9d, $80, $81, $00, $96, $a1, $52, $5c, $66, $60, $6a, $74
	db $9d, $80, $00, $00, $a4, $6e, $01
	db $9e
	dw NoteLengths112_1E
	db $00
.pat3:
	db $9d, $40, $81, $40, $a1, $42, $4c, $56, $50, $5a, $64
	db $9d, $40, $00, $40, $a4, $5e, $01
	db $9e
	dw NoteLengths112_1E
	db $00
.waveform15: ; wave pattern: 32 4-bit samples
	db $aa, $aa, $aa, $a8, $00, $00, $00, $00, $aa, $aa, $aa, $a8, $00, $00, $00, $00
.pat4:
	db $9d
	dw .waveform15
	db $20, $99, $a1, $30, $3a, $44, $3e, $48, $52, $9a, $a4, $4c, $01
	db $9e
	dw NoteLengths112_1E
	db $00
.pat5:
	db $9b, $06, $a1, $1a, $9c
	db $9b, $10, $a0, $15, $9c
	db $9e
	dw NoteLengths112_1E
	db $00

;@ path: sound/music/songs
;@ Music track $59: Credits.
;@ Where: CreditsSetUp; wave effect $1F requests it after the Wind Fish scene.
;@ Entry 57 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music59::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, .noise
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw .pat2, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat3, $FFFF, .sq2
.noise: ; noise pattern list
	dw .pat4, $FFFF, .noise
.pat1:
	db $9d, $10, $00, $80, $a1, $01, $00
.pat2:
	db $ac, $90, $86, $8e, $84, $8c, $82, $8a, $80, $88, $7e, $86, $78, $84, $76, $82
	db $74, $80, $72, $ac, $86, $78, $84, $76, $82, $74, $80, $72, $ad, $7c, $7a, $72
	db $6c, $68, $64, $62, $5a, $54, $50, $ad, $64, $62, $5a, $54, $50, $ae, $01, $ad
	db $7a, $72, $ad, $7a, $72, $a5, $01, $01, $ad, $62, $64, $72, $6c, $62, $64, $72
	db $6c, $a5, $01, $01, $00
.pat3:
	db $9d, $39, $00, $00, $ac, $90, $86, $8e, $84, $8c, $82, $8a, $80, $88, $7e, $86
	db $78, $84, $76, $82, $74, $80, $72
	db $9d, $20, $00, $40, $ac, $86, $78, $84, $76, $82, $74, $80, $72
	db $9d, $29, $00, $00, $ad, $7c, $7a, $72, $6c, $68, $64, $62, $5a, $54, $50
	db $9d, $20, $00, $40, $ad, $64, $62, $5a, $54, $50, $ae, $01
	db $9d, $29, $00, $00, $ad, $7a, $72
	db $9d, $20, $00, $40, $ad, $7a, $72, $a5, $01, $01
	db $9d, $29, $00, $00, $ad, $62, $64, $72, $6c
	db $9d, $20, $00, $40, $ad, $62, $64, $72, $6c, $a5, $01, $01, $00
.pat4:
	db $9b, $20, $a3, $38, $9c, $00

;@ path: sound/music/songs
;@ Music track $5E: StunEntity, banks $05 and $15.
;@ Entry 62 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5E::
	db $00 ; transpose
	dw NoteLengths96_1E
	dw .sq1, .sq2, MusicSilentChannel_1E, $0000
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw .pat3, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2
.sq2Loop:
	dw .pat4, .pat3, .pat5, .pat3, .pat6, .pat3, .pat5, .pat3
	dw $FFFF, .sq2Loop
.pat1:
	db $9d, $20, $00, $43, $a7, $01, $a1, $01, $a0, $01, $00
.pat2:
	db $a7, $01, $00
.pat3:
	db $a1, $20, $22, $20, $22, $00
.pat4:
	db $9d, $20, $00, $40, $00
.pat5:
	db $9d, $30, $00, $40, $00
.pat6:
	db $9d, $40, $00, $40, $00

;@ path: sound/music/songs
;@ Music track $5F: not requested directly.
;@ Entry 63 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music5F::
	db $00 ; transpose
	dw NoteLengths64_1E
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw .pat3, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2
.sq2Loop:
	dw .pat3, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw .pat4
.waveLoop:
	dw .pat3, $FFFF, .waveLoop
.pat1:
	db $9d, $10, $00, $40, $a5, $01, $01, $a8, $01, $aa, $01, $00
.pat2:
	db $9d, $20, $00, $00, $a5, $01, $01, $a8, $01, $00
.pat3:
	db $a1, $8e, $8a, $88, $80, $7a, $76, $72, $70, $68, $62, $5e, $5a, $58, $50, $4a
	db $46, $42, $40, $38, $32, $2e, $2a, $2e, $32, $38, $40, $42, $46, $4a, $50, $58
	db $5a, $5e, $62, $68, $70, $72, $76, $7a, $80, $88, $8a, $8e, $8a, $86, $80, $78
	db $76, $72, $6e, $68, $60, $5e, $5a, $56, $50, $48, $46, $42, $3e, $38, $30, $34
	db $38, $3e, $42, $46, $48, $34, $50, $56, $5a, $5e, $60, $34, $68, $6e, $72, $76
	db $76, $72, $6c, $64, $62, $5e, $5a, $54, $4c, $4a, $46, $42, $3c, $34, $32, $2e
	db $32, $34, $3c, $42, $46, $4a, $4c, $54, $5a, $5e, $62, $64, $6c, $72, $76, $7a
	db $7c, $84, $8a, $00
.pat4:
	db $9d
	dw Music48.waveform14
	db $20, $a5, $01, $01, $a8, $01, $a3, $01, $00
;@ path: sound/music/songs
;@ Music track $60: Name entry.
;@ Where: FileNewNameEntry.
;@ Entry 64 of SongTable_1E. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1E).
Music60::
	db $00 ; transpose
	dw NoteLengths112_1E
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw .pat1
.sq1Loop:
	dw .pat5, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2
.sq2Loop:
	dw .pat6, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw .pat3
.waveLoop:
	dw .pat7, $FFFF, .waveLoop
.noise: ; noise pattern list
	dw .pat4
.noiseLoop:
	dw .pat8, $FFFF, .noiseLoop
.pat1:
	db $9d, $60, $00, $41, $a7, $01, $aa, $4e, $ae, $50, $00
.pat2:
	db $9d, $40, $00, $01, $a7, $01, $aa, $64, $ae, $66, $00
.waveform16: ; wave pattern: 32 4-bit samples
	db $8a, $df, $da, $86, $31, $01, $36, $86, $8a, $df, $da, $86, $31, $01, $36, $86
.pat3:
	db $9d
	dw .waveform16
	db $20, $a7, $01, $aa, $5a, $ae, $5c, $00
.pat4:
	db $a7, $01, $aa, $01, $a5, $01, $a1, $ff, $a2, $ff, $ff, $a1, $ff, $a2, $ff, $00
.pat5:
	db $9d, $41, $00, $80
	db $9b, $07, $a6, $82, $82, $a3, $82, $a2, $82, $a3, $82, $9c
	db $9d, $61, $00, $80, $97, $a2, $44, $a6, $44, $a1, $44, $44, $a3, $44, $a2, $44
	db $a1, $44, $a2, $44, $98, $00
.pat6:
	db $9d, $60, $21, $41, $a3, $46, $a7, $3c, $a1, $01, $46, $46, $4a, $4c, $50, $a8
	db $54, $aa, $54, $56, $5a, $ad, $01, $a8, $5e, $aa, $5e, $5a, $56, $ad, $01, $a6
	db $5a, $a1, $56, $a4, $54, $a3, $54, $a2, $50, $a1, $50, $54, $a4, $56, $a2, $54
	db $50, $a2, $4c, $a1, $4c, $50, $a4, $54, $a2, $50, $4c, $a2, $4a, $a1, $4a, $4e
	db $a4, $52, $a3, $58
	db $9d, $62, $00, $40, $a2, $54, $a6, $54, $a1, $54, $54, $a3, $54, $a2, $54, $a1
	db $54, $a2, $54, $00
.waveform17: ; wave pattern: 32 4-bit samples
	db $00, $11, $22, $33, $44, $55, $67, $89, $00, $00, $00, $05, $00, $00, $00, $05
.pat7:
	db $9d
	dw .waveform17
	db $20, $99, $a2, $5e, $a1, $4c, $a2, $54, $5e, $5c, $4c, $54, $5c, $a1, $4c, $a2
	db $5a, $a1, $4c, $a2, $54, $5a, $58, $4c, $54, $58, $a1, $4c, $a2, $56, $a1, $46
	db $a2, $4c, $56, $5a, $4a, $50, $5a, $a1, $4a, $a2, $5a, $a1, $4c, $a2, $54, $5a
	db $5a, $a1, $4c, $54, $a2, $5a, $a1, $4c, $54, $5a, $a2, $56, $a1, $48, $a2, $50
	db $56, $50, $3e, $48, $50, $a1, $52, $a2, $54, $a1, $46, $a2, $4c, $54, $5e, $a1
	db $4c, $54, $a2, $5e, $a1, $5c, $5e, $60, $a2, $62, $a1, $52, $a2, $58, $62, $5e
	db $52, $58, $5e, $a1, $58, $a2, $5c, $a6, $5c, $a1, $5c, $5c, $a3, $5c, $a2, $5c
	db $a1, $5c, $a2, $5c, $00
.pat8:
	db $9b, $07, $a1, $15, $15, $1a, $15, $15, $15, $ff, $15, $15, $15, $1a, $15, $15
	db $15, $1a, $ff, $9c, $a2, $ff, $a6, $ff, $a1, $ff, $ff, $a3, $ff, $a2, $ff, $a1
	db $ff, $a2, $ff, $00

;@ path: data/padding
;@ Unused space of bank $1E, filled with $FF.
Padding_1E_7F9A::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff
