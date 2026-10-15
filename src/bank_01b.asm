; Disassembly of "la.gb"
; This file was created with:
; mgbdis v3.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $01b", ROMX[$4000], BANK[$1b]

;@ def MusicEntryPoints_1B()
;@ path: sound/music/engine
;@ The bank's three fixed entry points: $4000 InitMusic_1B, $4003 SilenceMusicAndNoise_1B and $4006
;@ UpdateMusic_1B. UpdateSound calls $4006 once a frame; the other two are not used (bank $1F sets the
;@ sound hardware up and stops the sound).
;@ test: skip three separate jump instructions
MusicEntryPoints_1B::
;> return InitMusic_1B()                    # $4000
	jp InitMusic_1B
;> # $4003: jp SilenceMusicAndNoise_1B; $4006: jp UpdateMusic_1B
	jp SilenceMusicAndNoise_1B
	jp UpdateMusic_1B


;@ def InitMusic_1B()
;@ path: sound/music/engine
;@ Clears the sound RAM $D300-$D3FF and switches the sound hardware on: master volume 7 on both sides,
;@ every channel to both speakers.
InitMusic_1B::
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

;@ def UpdateMusic_1B()
;@ path: sound/music/engine
;@ Bank $1B's music engine for one frame (entry $4006, called by UpdateSound before bank $1E's). A
;@ request in wMusicTrackToPlay is started if it is one of this bank's tracks; otherwise the music's
;@ two-step drum (noise effect 1) moves on. Then the song plays one frame, if it is this bank's.
;@ test: skip runs the whole music engine
UpdateMusic_1B::
;> request = wMusicTrackToPlay
	ld hl, wMusicTrackToPlay
	ld a, [hli]
;> if request:
	and a
	jr nz, .request

;>@req     wActiveMusicTrack = request
;>@req2     StartMusicRequest_1B(request)
;> else:
;>     UpdateDrumFF_1B()
	call UpdateDrumFF_1B

;> UpdateMusicChannels_1B()
.play
	call UpdateMusicChannels_1B
	ret


;> # (.notMine: the exit of StartMusicRequest_1B for other banks' tracks, wMusicFromBank1B = 0)
.notMine
	xor a
	ld [wMusicFromBank1B], a
	ret


;=@req
.request
	ld [hl], a
;=@req2
	call StartMusicRequest_1B
	jr .play

;@ def UpdateDrumFF_1B()
;@ path: sound/music/engine
;@ The two-step drum that the music's noise channel plays for note $FF (NoiseNote_1B requests it as
;@ noise effect 1): first NR41-NR44 = $3B, $80, $07, $C0 for 2 frames, then $00, $42, $02, $C0, which
;@ ends the effect after 4 more frames.
;@ test: wNoiseSfxToPlay = rng.choice([0, 1, 2]); wActiveNoiseSfx = rng.choice([0, 1, 1, 3]); wNoiseSfxTimer = rand(1, 3)
UpdateDrumFF_1B::
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
;@ The song headers of bank $1B: 32 words, entry n = song n of this bank. The music request numbers $01-$10 and $31-$40 map to the entries in order (StartMusicRequest_1B).
SongTable_1B::
	dw Music01, Music02, Music03, Music04, Music05, Music06, Music07, Music08
	dw Music09, Music0A, Music0B, Music0C, Music0D, Music0E, Music0F, Music10
	dw Music31, Music32, Music33, Music34, Music35, Music36, Music37, Music38
	dw Music39, Music3A, Music3B, Music3C, Music3D, Music3E, Music3F, Music40

;@ def GetSongHeader_1B(index: a, table: hl) -> hl
;@ path: sound/music/engine
;@ Entry `index` (1-based) of a word table: the song's header address (its high byte is also left in
;@ a, and e goes up by one).
;@ test: index = rand(1, 32); table = 0x4077
GetSongHeader_1B::
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


;@ def LoadWaveRAM_1B(src: hl)
;@ path: sound/music/engine
;@ Copies a 16-byte wave pattern into wave RAM ($FF30-$FF3F).
;@ test: src = rand(0x4000, 0x7FF0)
LoadWaveRAM_1B::
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


;@ def SilenceNoiseSfx_1B()
;@ path: sound/music/engine
;@ Ends whatever noise effect plays and silences the noise channel (envelope 0, restarted).
SilenceNoiseSfx_1B::
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
;> mem[0xD3A3] = 0
	ld [wSoundUnusedA3], a
;> rNR42 = 0x08                              # volume 0
	ld a, $08
	ldh [rNR42], a
;> rNR44 = 0x80                              # restart: silent
	ld a, $80
	ldh [rNR44], a
	ret


;@ def StopMusic_1B()
;@ path: sound/music/engine
;@ Stops the music (EndMusic_1B). A noise effect that plays on by itself (effects $05, $0C, $1A, $24,
;@ $2A, $2E and $3F) is left running; any other is silenced first.
;@ test: skip ends in EndMusic_1B, which resets the whole music state
StopMusic_1B::
;>@if if wActiveNoiseSfx not in (0x0C, 0x05, 0x1A, 0x24, 0x2A, 0x2E, 0x3F):
	ld a, [wActiveNoiseSfx]
	cp $0c
	jp z, EndMusic_1B

;=@if
	cp $05
	jp z, EndMusic_1B

;=@if
	cp $1a
	jp z, EndMusic_1B

;=@if
	cp $24
	jp z, EndMusic_1B

;=@if
	cp $2a
	jp z, EndMusic_1B

;=@if
	cp $2e
	jp z, EndMusic_1B

;=@if
	cp $3f
	jp z, EndMusic_1B

;>     SilenceNoiseSfx_1B()
	call SilenceNoiseSfx_1B
;> return EndMusic_1B()
	jp EndMusic_1B


;@ def StartMusicRequest_1B(request: a, track: hl)
;@ path: sound/music/engine
;@ A music request (track points at wActiveMusicTrack, which holds it): $FF stops the music. Tracks
;@ $01-$10 and $31-$40 are this bank's: they become songs 1-32 of SongTable_1B and start (StartSong_1B)
;@ with their panning, and wMusicFromBank1B is set. For any other track wMusicFromBank1B is cleared, so
;@ that bank $1E's engine takes the request.
;@ test: skip starts a whole song
StartMusicRequest_1B::
;> if request == 0xFF: return StopMusic_1B()
	cp $ff
	jr z, StopMusic_1B

;> wMusicTrackStartedBefore = wMusicTrackStarted
	ld a, [wMusicTrackStarted]
	ld [wMusicTrackStartedBefore], a
;> wMusicTrackStarted = request
	ld a, [hl]
	ld [wMusicTrackStarted], a
;> song = request
;> if request >= 0x11:
	cp $11
	jr nc, .high

	jr .mine

;>     if request < 0x21:                     # $11-$20: bank $1E
.high
	cp $21
	jr nc, .not11

;>         wMusicFromBank1B = 0; return       # (UpdateMusic_1B.notMine)
	jp UpdateMusic_1B.notMine


;>     if request < 0x31:                     # $21-$30: bank $1E
.not11
	cp $31
	jr nc, .not21

;>         wMusicFromBank1B = 0; return
	jp UpdateMusic_1B.notMine


;>     if request >= 0x41:                    # $41 and up: bank $1E
.not21
	cp $41
	jp nc, UpdateMusic_1B.notMine

;>         wMusicFromBank1B = 0; return
;>     song = request - 0x20                  # $31-$40 -> songs $11-$20
	add $e0

;> wMusicTrackToPlay = song
.mine
	dec hl
	ld [hli], a
	ld b, a
;> wMusicFromBank1B = 1
	ld a, $01
	ld [wMusicFromBank1B], a
;> wActiveMusicTrack = song
	ld a, b
	ld [hl], a
;> StartSong_1B(GetSongHeader_1B(song & 0x7F, SongTable_1B))
	ld b, a
	ld hl, SongTable_1B
	and $7f
	call GetSongHeader_1B
	call StartSong_1B
;> return SetSongPanning_1B()
	jp SetSongPanning_1B


;@ path: sound/music/data
;@ Panning of each song of bank $1B (SetSongPanning_1B), 6 bytes per song in song table order: mode (1 = fixed), frames per step, then four NR51 values. Every song here uses fixed panning, all channels on both sides ($FF).
SongPanning_1B::
	db $01, $00, $ff, $ff, $00, $00 ; track $01
	db $01, $00, $ff, $ff, $00, $00 ; track $02
	db $01, $00, $ff, $ff, $00, $00 ; track $03
	db $01, $00, $ff, $ff, $00, $00 ; track $04
	db $01, $00, $ff, $ff, $00, $00 ; track $05
	db $01, $00, $ff, $ff, $00, $00 ; track $06
	db $01, $00, $ff, $ff, $00, $00 ; track $07
	db $01, $00, $ff, $ff, $00, $00 ; track $08
	db $01, $00, $ff, $ff, $00, $00 ; track $09
	db $01, $00, $ff, $ff, $00, $00 ; track $0A
	db $01, $00, $ff, $ff, $00, $00 ; track $0B
	db $01, $00, $ff, $ff, $00, $00 ; track $0C
	db $01, $00, $ff, $ff, $00, $00 ; track $0D
	db $01, $00, $ff, $ff, $00, $00 ; track $0E
	db $01, $00, $ff, $ff, $00, $00 ; track $0F
	db $01, $00, $ff, $ff, $00, $00 ; track $10
	db $01, $00, $ff, $ff, $00, $00 ; track $31
	db $01, $00, $ff, $ff, $00, $00 ; track $32
	db $01, $00, $ff, $ff, $00, $00 ; track $33
	db $01, $00, $ff, $ff, $00, $00 ; track $34
	db $01, $00, $ff, $ff, $00, $00 ; track $35
	db $01, $00, $ff, $ff, $00, $00 ; track $36
	db $01, $00, $ff, $ff, $00, $00 ; track $37
	db $01, $00, $ff, $ff, $00, $00 ; track $38
	db $01, $00, $ff, $ff, $00, $00 ; track $39
	db $01, $00, $ff, $ff, $00, $00 ; track $3A
	db $01, $00, $ff, $ff, $00, $00 ; track $3B
	db $01, $00, $ff, $ff, $00, $00 ; track $3C
	db $01, $00, $ff, $ff, $00, $00 ; track $3D
	db $01, $00, $ff, $ff, $00, $00 ; track $3E
	db $01, $00, $ff, $ff, $00, $00 ; track $3F
	db $01, $00, $ff, $ff, $00, $00 ; track $40

;@ def RestoreWaveRAM_1B()
;@ path: sound/music/engine
;@ Part of WriteNote_1B for the wave channel: after a wave-channel effect (wWaveRamDirty set) the song's
;@ wave pattern goes back into wave RAM. Then the note's registers are written (WriteNoteRegisters_1B,
;@ inside WriteNote_1B).
;@ test: skip jumps back into the middle of WriteNote_1B
RestoreWaveRAM_1B::
;> if wWaveRamDirty:
	ld a, [wWaveRamDirty]
	and a
	jp z, WriteNoteRegisters_1B

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
;> return                                    # WriteNoteRegisters_1B goes on with the registers
	jp WriteNoteRegisters_1B


;@ def SetSongPanning_1B()
;@ path: sound/music/engine
;@ Copies the song's 6 panning bytes from SongPanning_1B into wMusicPanMode..wMusicPanValues (with the
;@ timer and step at 0) and sets NR51 to the first value.
;@ test: wActiveMusicTrack = rand(1, 32)
SetSongPanning_1B::
;> p = SongPanning_1B
	ld a, [wActiveMusicTrack]
	ld hl, SongPanning_1B

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


;@ def UpdatePanning_1B()
;@ path: sound/music/engine
;@ Songs with moving panning (wMusicPanMode other than 1): every wMusicPanPeriod frames NR51 steps on to
;@ the next of the four wMusicPanValues.
;@ test: wMusicPanMode = rng.choice([1, 0, 3]); wMusicPanPeriod = rand(1, 4); wMusicPanTimer = rand(0, 3)
UpdatePanning_1B::
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


;@ def CopyIndirectWord_1B(src: hl, dest: de) -> a
;@ path: sound/music/engine
;@ Copies the word that the pointer at src points to into dest (dest stays inside its 256-byte page) and
;@ returns its high byte.
;@ test: src = rng.choice([0xD310, 0xD320, 0xD330, 0xD340]); w = rand(0x4000, 0x7F00); mem[src] = w & 0xFF; mem[src + 1] = w >> 8
;@ test: dest = src + 4
CopyIndirectWord_1B::
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


;@ def CopyWord_1B(src: hl, dest: de) -> hl
;@ path: sound/music/engine
;@ Copies two bytes from src to dest (dest stays inside its page) and returns src moved past them.
;@ test: src = rand(0x4000, 0x7F00)
;@ test: dest = rng.choice([0xD301, 0xD310, 0xD320, 0xD330, 0xD340])
CopyWord_1B::
;> mem[dest] = mem[src]
	ld a, [hli]
	ld [de], a
;> mem[(dest & 0xFF00) | lo(dest + 1)] = mem[src + 1]
	inc e
	ld a, [hli]
	ld [de], a
;> return src + 2
	ret


;@ def StartSong_1B(header: hl)
;@ path: sound/music/engine
;@ Sets up a song from its 11-byte header: transpose, note length table and the pattern list of each
;@ channel. Every channel starts at the first pattern of its list with its note timer at 1, so the next
;@ update plays the first notes. The noise channel is silenced first unless one of the self-running noise
;@ effects plays (see StopMusic_1B).
;@ test: t = 0x4077 + 2 * rand(0, 31); header = mem[t] | mem[t + 1] << 8
StartSong_1B::
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

;>     SilenceNoiseSfx_1B()
	call SilenceNoiseSfx_1B

;> ResetMusicState_1B()
.reset
	call ResetMusicState_1B
;> wMusicTranspose = mem[header]
	ld de, wMusicTranspose
	ld b, $00
	ld a, [hli]
	ld [de], a
;> wMusicNoteLengths = mem16[header + 1]
	inc e
	call CopyWord_1B
;> mem16[wMusicChannel1] = mem16[header + 3]             # pattern lists
	ld de, wMusicChannel1
	call CopyWord_1B
;> mem16[wMusicChannel2] = mem16[header + 5]
	ld de, wMusicChannel2
	call CopyWord_1B
;> mem16[wMusicChannel3] = mem16[header + 7]
	ld de, wMusicChannel3
	call CopyWord_1B
;> mem16[wMusicChannel4] = mem16[header + 9]
	ld de, wMusicChannel4
	call CopyWord_1B
;> mem16[wMusicChannel1 + 4] = mem16[mem16[wMusicChannel1]]     # pattern pointer: the first pattern
	ld hl, wMusicChannel1
	ld de, wMusicChannel1 + $04
	call CopyIndirectWord_1B
;> mem16[wMusicChannel2 + 4] = mem16[mem16[wMusicChannel2]]
	ld hl, wMusicChannel2
	ld de, wMusicChannel2 + $04
	call CopyIndirectWord_1B
;> mem16[wMusicChannel3 + 4] = mem16[mem16[wMusicChannel3]]
	ld hl, wMusicChannel3
	ld de, wMusicChannel3 + $04
	call CopyIndirectWord_1B
;> mem16[wMusicChannel4 + 4] = mem16[mem16[wMusicChannel4]]
	ld hl, wMusicChannel4
	ld de, wMusicChannel4 + $04
	call CopyIndirectWord_1B
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


;> # (InstrumentLoadWave_1B: the wave branch of InstrumentCommand_1B - it keeps the wave pattern address
;> # in wMusicChannel3 + 6 and, unless a wave effect plays, loads it into wave RAM; then back there)
InstrumentLoadWave_1B:
	push hl
	ld a, e
	ld [wMusicChannel3 + $06], a
	ld a, d
	ld [wMusicChannel3 + $07], a
;> #
	ld a, [wActiveWaveSfx]
	and a
	jr nz, .keep

	xor a
	ldh [rNR30], a
	ld l, e
;> #
	ld h, d
	call LoadWaveRAM_1B

.keep
	pop hl
	jr InstrumentCommand_1B.next

;@ def InstrumentCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9D: the next 3 bytes become the channel's instrument (+6..+8). On the square and noise
;@ channels: envelope (NRx2), release (high nibble: when the release envelope comes - $80 at 1/2 of the
;@ note, $40 at 1/4, else 3/4; low nibble: which one, ReleaseEnvelopes_1B) and NRx1 duty with the effect
;@ type in the low nibble (1 vibrato, 5 wide vibrato, other values a fixed detune). On the wave channel:
;@ the address of a wave pattern, loaded into wave RAM right away, and the NR32 output level (bit 7: drop
;@ to half level 6 frames before the note ends). Then the pattern goes on.
;@ test: n = rand(1, 4); wMusicChannel = n; ch = 0xD300 + 0x10 * n; ptr = ch + 4
;@ test: p = rand_ram(8); mem[ptr] = p & 0xFF; mem[ptr + 1] = p >> 8; wActiveWaveSfx = rng.choice([0, 1])
;@ test: for c in range(ch + 0x10, 0xD350, 0x10): mem[c + 1] = 0
InstrumentCommand_1B::
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> b0 = ReadPointer_1B(ptr)
	call ReadPointer_1B
	ld e, a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> b1 = ReadPointer_1B(ptr)
	call ReadPointer_1B
	ld d, a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> b2 = ReadPointer_1B(ptr)
	call ReadPointer_1B
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
	jr z, InstrumentLoadWave_1B

;>     if not wActiveWaveSfx: rNR30 = 0; LoadWaveRAM_1B(b0 | b1 << 8)    # (InstrumentLoadWave_1B, after StartSong_1B)
;> AdvancePointer_1B(ptr)
.next
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jp ReadPattern_1B


;@ def AdvancePointer_1B(ptr: hl)
;@ path: sound/music/engine
;@ Adds 1 to the word at ptr.
;@ test: ptr = rand_ram(2)
AdvancePointer_1B::
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


;@ def AdvancePointer2_1B(ptr: hl)
;@ path: sound/music/engine
;@ Adds 2 to the word at ptr.
;@ test: ptr = rand_ram(2)
AdvancePointer2_1B::
;> p = mem16[ptr]
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
;> p = u16(p + 2)
	inc de
	inc de
;> mem16[ptr] = p                                  # AdvancePointer_1B.store
	jr AdvancePointer_1B.store

;@ def ReadPointer_1B(ptr: hl) -> a
;@ path: sound/music/engine
;@ Reads the byte that the pointer at ptr points to (also left in b).
;@ test: ptr = rand_ram(2)
ReadPointer_1B::
;> p = mem16[ptr]
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
;> return mem[p]
	ld a, [bc]
	ld b, a
	ret


;> # (SustainNoteSkip_1B: SustainNote_1B's way out for rests and channels an effect holds)
SustainNoteSkip_1B:
	pop hl
	jr SkipChannel_1B

;@ def SustainNote_1B(timer: hl)
;@ path: sound/music/engine
;@ A frame in the middle of a note: wave notes whose level byte has bit 7 set drop to half level 6 frames
;@ before the end; then, unless the note is a rest or an effect holds the channel, the note's effects
;@ (UpdateNoteEffects_1B) and the release envelopes of the square channels.
;@ test: n = rand(1, 4); wMusicChannel = n; ch = 0xD300 + 0x10 * n; timer = ch + 2
;@ test: mem[timer] = rng.choice([6, rand(1, 10)]); mem[ch + 0x0B] = rng.choice([0, 0, 1])
;@ test: mem[ch + 0x0F] = rng.choice([0, 0, 0x80]); mem[ch + 8] = rand(0, 255)
;@ test: for c in range(ch + 0x10, 0xD350, 0x10): mem[c + 1] = 0
SustainNote_1B::
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
	jr nz, SustainNoteSkip_1B

;>     if not mem[ch + 0x0F] & 0x80:                # no effect holds the channel
	ld a, l
	add $04
	ld l, a
	bit 7, [hl]
	jr nz, SustainNoteSkip_1B

;>         UpdateNoteEffects_1B(timer)
	pop hl
	call UpdateNoteEffects_1B
;>         UpdateReleaseEnvelopes_1B()
	push hl
	call UpdateReleaseEnvelopes_1B
	pop hl

;> return SkipChannel_1B(timer)                     # falls through (SustainNoteSkip_1B also goes there)

;@ def SkipChannel_1B(timer: hl)
;@ path: sound/music/engine
;@ Nothing more to do for this channel this frame.
;@ test: skip runs the remaining channels
SkipChannel_1B::
;> return NextChannel_1B(timer - 2)
	dec l
	dec l
	jp NextChannel_1B


;@ def NextPattern_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern byte $00: on to the next pattern of the channel's list. A list word with high byte $00 ends
;@ the song: the item fanfares (tracks $0F, $10, $25) start hLastMusicTrack again, anything else stops the
;@ music. A word with high byte $FF is followed by the address where the list goes on (the loop).
;@ test: skip runs the rest of the music frame
NextPattern_1B::
;> ch = ptr - 4
	dec l
	dec l
	dec l
	dec l
;> AdvancePointer2_1B(ch)                              # next word of the pattern list
	call AdvancePointer2_1B

;>@loop while True:
;>     hi_ = CopyIndirectWord_1B(ch, ch + 4)        # pattern pointer = the list word
.entry
	ld a, l
	add $04
	ld e, a
	ld d, h
	call CopyIndirectWord_1B
;>     if hi_ == 0:                                 # end of the song
	cp $00
	jr z, .end

;>@end1         if wMusicTrackStarted in (0x0F, 0x10, 0x25): return ResumeMusicAfterFanfare_1B()
;>@end2         wActiveMusicTrack = 0
;>@end3         StopMusic_1B()
;>@end4         return
;>     if hi_ != 0xFF:
	cp $ff
	jr z, .loop

;>         return NextNote_1B(ch + 2)
	inc l
	jp NextNote_1B


;>     AdvancePointer2_1B(ch)                       # $FFxx: the list goes on at the next word
.loop
	dec l
	push hl
	call AdvancePointer2_1B
;>     lo_ = ReadPointer_1B(ch)
	call ReadPointer_1B
	ld e, a
;>     AdvancePointer_1B(ch)
	call AdvancePointer_1B
;>     hi2 = ReadPointer_1B(ch)
	call ReadPointer_1B
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
	cp $0f
	jp z, ResumeMusicAfterFanfare_1B

;=@end1
	cp $10
	jp z, ResumeMusicAfterFanfare_1B

;=@end1
	cp $25
	jp z, ResumeMusicAfterFanfare_1B

;=@end2
	ld hl, wActiveMusicTrack
	ld [hl], $00
;=@end3
	call StopMusic_1B
;=@end4
	ret


;@ def LengthTableCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9E: the next 2 bytes are the address of a new note length table.
;@ test: skip goes on reading the pattern
LengthTableCommand_1B::
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> mem[0xD301] = ReadPointer_1B(ptr)                 # wMusicNoteLengths, low byte
	call ReadPointer_1B
	ld [wMusicNoteLengths], a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> mem[0xD302] = ReadPointer_1B(ptr)                 # high byte
	call ReadPointer_1B
	ld [wMusicNoteLengths + 1], a
;> return NextCommand_1B(ptr)
	jr NextCommand_1B

;@ def TransposeCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9F: the next byte becomes wMusicTranspose (added to every following note byte of all
;@ channels).
;@ test: skip goes on reading the pattern
TransposeCommand_1B::
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> wMusicTranspose = ReadPointer_1B(ptr)
	call ReadPointer_1B
	ld [wMusicTranspose], a
;> return NextCommand_1B(ptr)                       # falls through

;@ def NextCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Moves past the last byte of a command and reads on.
;@ test: skip goes on reading the pattern
NextCommand_1B::
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jr ReadPattern_1B

;@ def LoopStartCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9B n: the bytes up to the next $9C are played n times. The count goes into bits 0-6 of
;@ the channel's +F, the address after it into +C/+D (one loop at a time).
;@ test: skip goes on reading the pattern
LoopStartCommand_1B::
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> count = ReadPointer_1B(ptr)
	call ReadPointer_1B
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
;> return ReadPattern_1B(ptr)
	jr ReadPattern_1B

;@ def LoopEndCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9C: one pass of the loop is done; while passes are left the pattern goes back to the
;@ loop start, else on past the $9C.
;@ test: skip goes on reading the pattern
LoopEndCommand_1B::
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
;>     return ReadPattern_1B(ptr)
	jr ReadPattern_1B

;> return NextCommand_1B(ptr)
.done
	pop hl
	jr NextCommand_1B

;@ def UpdateMusicChannels_1B()
;@ path: sound/music/engine
;@ One frame of bank $1B's song, if one plays: the panning, then each of the 4 channels in turn.
;@ test: skip runs the whole song frame
UpdateMusicChannels_1B::
;> if wActiveMusicTrack == 0: return
	ld hl, wActiveMusicTrack
	ld a, [hl]
	and a
	ret z

;> if not wMusicFromBank1B: return                   # the song is bank $1E's
	ld a, [wMusicFromBank1B]
	and a
	ret z

;> UpdatePanning_1B()
	call UpdatePanning_1B
;> wMusicChannel = 1
	ld a, $01
	ld [wMusicChannel], a
;> return UpdateChannel_1B(wMusicChannel1)          # falls through
	ld hl, wMusicChannel1

;@ def UpdateChannel_1B(ch: hl)
;@ path: sound/music/engine
;@ A channel without a pattern list is skipped. Otherwise its note timer counts down; at 0 the next note
;@ is read.
;@ test: skip runs the rest of the music frame
UpdateChannel_1B::
;> timer = ch + 2
;> if mem[ch + 1] == 0: return SkipChannel_1B(timer)
	inc l
	ld a, [hli]
	and a
	jp z, SkipChannel_1B

;> mem[timer] = u8(mem[timer] - 1)
	dec [hl]
;> if mem[timer]: return SustainNote_1B(timer)
;> return NextNote_1B(timer)                        # falls through
	jp nz, SustainNote_1B

;@ def NextNote_1B(timer: hl)
;@ path: sound/music/engine
;@ The note is over: read the pattern on.
;@ test: skip runs the rest of the music frame
NextNote_1B::
;> return ReadPattern_1B(timer + 2)                 # falls through
	inc l
	inc l

;@ def ReadPattern_1B(ptr: hl)
;@ path: sound/music/engine
;@ Reads the channel's pattern at ptr (the channel's +4) - the music data format:
;@ $00 ends the pattern (NextPattern_1B); $9D a b c sets the instrument (InstrumentCommand_1B); $9E lo hi
;@ a new note length table; $9F t the transpose; $9B n ... $9C plays the bytes between n times; $99 / $9A
;@ wave decay on / off, $94 wave swell, $97 / $98 pitch drop on / off, $96 / $95 block / allow wave-channel
;@ effects. $A0-$AF sets the note length (the low nibble indexes the song's note length table) for this and
;@ the following notes and works out the release frame of the square channels. Then comes the note: $01 is
;@ a rest, even values $02-$90 index NoteFrequencies_1B (after the transpose is added: 2 per semitone,
;@ $02 = C2); on the noise channel the byte picks a drum of DrumSounds_1B ($FF: the two-step drum).
;@ test: skip runs the rest of the music frame
ReadPattern_1B::
;> ch = ptr - 4
;> b = ReadPointer_1B(ptr)
	call ReadPointer_1B
;> if b == 0x00: return NextPattern_1B(ptr)
	cp $00
	jp z, NextPattern_1B

;> if b == 0x9D: return InstrumentCommand_1B(ptr)
	cp $9d
	jp z, InstrumentCommand_1B

;> if b == 0x9E: return LengthTableCommand_1B(ptr)
	cp $9e
	jp z, LengthTableCommand_1B

;> if b == 0x9F: return TransposeCommand_1B(ptr)
	cp $9f
	jp z, TransposeCommand_1B

;> if b == 0x9B: return LoopStartCommand_1B(ptr)
	cp $9b
	jp z, LoopStartCommand_1B

;> if b == 0x9C: return LoopEndCommand_1B(ptr)
	cp $9c
	jp z, LoopEndCommand_1B

;> if b == 0x99: return WaveDecayOnCommand_1B(ptr)
	cp $99
	jp z, WaveDecayOnCommand_1B

;> if b == 0x9A: return WaveDecayOffCommand_1B(ptr)
	cp $9a
	jp z, WaveDecayOffCommand_1B

;> if b == 0x94: return WaveSwellCommand_1B(ptr)
	cp $94
	jp z, WaveSwellCommand_1B

;> if b == 0x97: return PitchDropOnCommand_1B(ptr)
	cp $97
	jp z, PitchDropOnCommand_1B

;> if b == 0x98: return PitchDropOffCommand_1B(ptr)
	cp $98
	jp z, PitchDropOffCommand_1B

;> if b == 0x96: return BlockWaveSfxCommand_1B(ptr)
	cp $96
	jp z, BlockWaveSfxCommand_1B

;> if b == 0x95: return AllowWaveSfxCommand_1B(ptr)
	cp $95
	jp z, AllowWaveSfxCommand_1B

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
;>     AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;>     b = ReadPointer_1B(ptr)
	call ReadPointer_1B

;> note = b
;> if wMusicChannel != 4:
.note
	ld a, [wMusicChannel]
	cp $04
	jr z, .notNoise

;>     wMusicVibrato[2 * (wMusicChannel - 1)] = 0   # the effects start again with the note
	push de
	ld de, wMusicVibrato
	call ChannelPairOffset_1B
	xor a
	ld [de], a
;>     wMusicVibrato[2 * (wMusicChannel - 1) + 1] = 0
	inc e
	ld [de], a
;>     wMusicPitchDrop[2 * (wMusicChannel - 1) + 1] = 0
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1B
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

;> AdvancePointer_1B(ptr)
.notNoise
	ld c, b
	ld b, $00
	call AdvancePointer_1B
;> if wMusicChannel == 4: return NoiseNote_1B(note, ptr)
	ld a, [wMusicChannel]
	cp $04
	jp z, NoiseNote_1B

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
;>@restplay     return PlayNote_1B(ptr)
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

;> src = NoteFrequencies_1B + note
.freq
	ld hl, NoteFrequencies_1B
	add hl, bc
;> mem[freq] = mem[src]
	ld a, [hli]
	ld [de], a
;> mem[freq + 1] = mem[src + 1]
	inc e
	ld a, [hl]
	ld [de], a
;> return PlayNote_1B(ptr)
	pop hl
	jp PlayNote_1B


;=@rest
.rest
	ld [hl], $01
;=@restplay
	pop hl
	jr PlayNote_1B

;@ def NoiseNote_1B(note: bc, ptr: hl)
;@ path: sound/music/engine
;@ The noise channel: note $FF plays the two-step drum (noise effect 1, UpdateDrumFF_1B) unless an effect
;@ holds the channel; any other note copies its 5-byte drum from DrumSounds_1B to the channel's +6..+A
;@ and plays it.
;@ test: skip the note timer reload pops the pointer pushed here
NoiseNote_1B::
;> if note == 0xFF:
	push hl
	ld a, c
	cp $ff
	jr z, .drumFF

;>@ff1     if not wMusicChannel4[0x0F] & 0x80:
;>@ff2         wNoiseSfxToPlay = 1
;>@ff3         UpdateDrumFF_1B()
;>@ff4     return ReloadNoteTimer_1B(ptr)
;> dest = wMusicChannel4 + 6
	ld de, wMusicChannel4 + $06
;> src = DrumSounds_1B + note
	ld hl, DrumSounds_1B
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

;> return InstrumentNote_1B(0x20, wMusicChannel4 + 4)   # NR41-NR44
	ld c, LOW(rNR41)
	ld hl, wMusicChannel4 + $04
	ld b, $00
	jr InstrumentNote_1B

;=@ff1
.drumFF
	ld a, [wMusicChannel4 + $0F]
	bit 7, a
	jp nz, ReloadNoteTimer_1B

;=@ff2
	ld a, $01
	ld [wNoiseSfxToPlay], a
;=@ff3
	call UpdateDrumFF_1B
;=@ff4
	jp ReloadNoteTimer_1B


;@ def PlayNote_1B(ptr: hl)
;@ path: sound/music/engine
;@ Starts the note on the channel's sound registers. The wave channel first restarts its DAC (unless an
;@ effect holds the channel) and uses its level byte (+8) with length 0.
;@ test: skip the note timer reload pops the pointer pushed here
PlayNote_1B::
;> if wMusicChannel == 1:
	push hl
	ld b, $00
	ld a, [wMusicChannel]
	cp $01
	jr z, .square1

;>@sq1     return InstrumentNote_1B(0x11, ptr)    # NR11-NR14
;> if wMusicChannel == 2:
	cp $02
	jr z, .square2

;>@sq2     return InstrumentNote_1B(0x16, ptr)    # NR21-NR24
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
;> return WriteNote_1B(reg, ptr + 5, 0, level)
	ld d, $00
	jr WriteNote_1B

;=@sq2
.square2
	ld c, LOW(rNR21)
	jr InstrumentNote_1B

;=@sq1
.square1
	ld c, LOW(rNR10)
	inc c

;@ def InstrumentNote_1B(reg: c, ptr: hl)
;@ path: sound/music/engine
;@ Square and noise channels: the duty / length byte from instrument byte +8 and the envelope from +6.
;@ test: skip the note timer reload pops the pointer pushed by the caller
InstrumentNote_1B::
;> env = mem[ptr + 2]                               # +6
	inc l
	inc l
	ld a, [hli]
	ld e, a
;> duty = mem[ptr + 4]                              # +8
	inc l
	ld a, [hli]
	ld d, a
;> return WriteNote_1B(reg, ptr + 5, duty, env)     # falls through

;@ def WriteNote_1B(reg: c, freq: hl, duty: d, env: e)
;@ path: sound/music/engine
;@ Writes the 4 registers of the note (a rest gets envelope $08: volume 0) unless an effect holds the
;@ channel; the wave channel first gets its wave pattern back after an effect (RestoreWaveRAM_1B). The
;@ note's frame count restarts and the note timer is loaded (ReloadNoteTimer_1B).
;@ test: skip the note timer reload pops the pointer pushed by the caller
WriteNote_1B::
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
	jr nz, ReloadNoteTimer_1B

;>     if wMusicChannel == 3: RestoreWaveRAM_1B()     # (it jumps there and comes back)
	ld a, [wMusicChannel]
	cp $03
	jp z, RestoreWaveRAM_1B

;>     mem[0xFF00 + reg] = duty                     # (b is 0)
WriteNoteRegisters_1B:
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
;> return ReloadNoteTimer_1B(freq - 5)              # falls through

;@ def ReloadNoteTimer_1B(ptr: stack)
;@ path: sound/music/engine
;@ The note is set up: the timer is loaded from the note length and the next channel follows. ptr (the
;@ channel's +4) is the value PlayNote_1B / NoiseNote_1B pushed.
;@ test: skip pops the pattern pointer its caller pushed
ReloadNoteTimer_1B::
;> mem[ptr - 2] = mem[ptr - 1]                      # note timer = note length
	pop hl
	dec l
	ld a, [hld]
	ld [hld], a
;> return NextChannel_1B(ptr - 4)                   # falls through
	dec l

;@ def NextChannel_1B(ch: hl)
;@ path: sound/music/engine
;@ On to the next channel; after channel 4 the frame counts of channels 1-3 go up.
;@ test: skip runs the rest of the music frame
NextChannel_1B::
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
;> return UpdateChannel_1B(u16(ch + 0x10))
	ld a, $10
	add l
	ld l, a
	jp UpdateChannel_1B


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


;> # (PopHLReturn_1B: the common exit of the note effects - pop hl and return)
PopHLReturn_1B:
	pop hl
	ret


;@ def UpdateNoteEffects_1B(timer: hl)
;@ path: sound/music/engine
;@ The per-frame effects of a sounding note. Square and wave channels with an effect type (low nibble of
;@ instrument byte +8) get their frequency changed (ApplyFrequencyEffect_1B); then the pitch drop and
;@ the wave level effects (UpdateDropAndWaveEffects_1B). timer is pushed here and popped by the exit.
;@ test: skip the exit pops what the entry pushed, across several routines
UpdateNoteEffects_1B::
;> ch = timer - 2
;> kind = mem[ch + 8] & 0x0F
	push hl
	ld a, l
	add $06
	ld l, a
	ld a, [hl]
	and $0f
;> if kind:
	jr z, UpdateDropAndWaveEffects_1B

;>     wMusicEffect = kind
	ld [wMusicEffect], a
;>     if wMusicChannel == 1: return ApplyFrequencyEffect_1B(ch + 8, 0x13)   # NR13/NR14
	ld a, [wMusicChannel]
	ld c, $13
	cp $01
	jr z, ApplyFrequencyEffect_1B

;>     if wMusicChannel == 2: return ApplyFrequencyEffect_1B(ch + 8, 0x18)   # NR23/NR24
	ld c, $18
	cp $02
	jr z, ApplyFrequencyEffect_1B

;>     if wMusicChannel == 3: return ApplyFrequencyEffect_1B(ch + 8, 0x1D)   # NR33/NR34
	ld c, $1d
	cp $03
	jr z, ApplyFrequencyEffect_1B

;> return UpdateDropAndWaveEffects_1B(timer)        # falls through

;@ def UpdateDropAndWaveEffects_1B(timer: stack)
;@ path: sound/music/engine
;@ Square and wave channels with the pitch drop on (command $97) slide down (UpdatePitchDrop_1B); else the
;@ wave channel runs its decay or swell of the level. Ends by popping the timer UpdateNoteEffects_1B
;@ pushed (PopHLReturn_1B).
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdateDropAndWaveEffects_1B::
;> if wMusicChannel == 4: return
	ld a, [wMusicChannel]
	cp $04
	jp z, PopHLReturn_1B

;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1B
;> if mem[drop]:
	ld a, [de]
	and a
	jp z, .waveEffects

;>     if wMusicChannel == 1: return UpdatePitchDrop_1B(drop, 0x13)
	ld a, [wMusicChannel]
	ld c, $13
	cp $01
	jp z, UpdatePitchDrop_1B

;>     if wMusicChannel == 2: return UpdatePitchDrop_1B(drop, 0x18)
	ld c, $18
	cp $02
	jp z, UpdatePitchDrop_1B

;>     return UpdatePitchDrop_1B(drop, 0x1D)
	ld c, $1d
	jp UpdatePitchDrop_1B


;> if wMusicChannel != 3: return
.waveEffects
	ld a, [wMusicChannel]
	cp $03
	jp nz, PopHLReturn_1B

;> if wMusicWaveDecay: return UpdateWaveDecay_1B(wMusicWaveDecay)
	ld a, [wMusicWaveDecay]
	and a
	jp nz, UpdateWaveDecay_1B

;> if wMusicWaveSwell: return UpdateWaveSwell_1B(wMusicWaveSwell)
	ld a, [wMusicWaveSwell]
	and a
	jp nz, UpdateWaveSwell_1B

;> return
	jp PopHLReturn_1B


;@ def ApplyFrequencyEffect_1B(p: hl, reg: c)
;@ path: sound/music/engine
;@ The frequency effect of the note (p = the channel's +8): type 1 is the vibrato, type 5 the wide
;@ vibrato; any other type plays the note one frequency step lower (a slight detune), rewritten every
;@ frame without restarting the note.
;@ test: skip pops what UpdateNoteEffects_1B pushed
ApplyFrequencyEffect_1B::
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
;> if wMusicEffect == 1: return UpdateVibrato_1B()
	ld a, [wMusicEffect]
	cp $01
	jp z, UpdateVibrato_1B

;> if wMusicEffect == 5: return UpdateWideVibrato_1B()
	cp $05
	jp z, UpdateWideVibrato_1B

;> WriteEffectFrequency_1B(u16(freq - 1), reg)
	ld hl, -1
	pop de
	add hl, de
	call WriteEffectFrequency_1B
;> return UpdateDropAndWaveEffects_1B()
	jp UpdateDropAndWaveEffects_1B


;@ def UpdateReleaseEnvelopes_1B()
;@ path: sound/music/engine
;@ The release of the square channels: when a note (not a rest) with a release in instrument byte +7
;@ reaches its release frame, its envelope is switched to ReleaseEnvelopes_1B entry (+7 low nibble - 1)
;@ and the note restarted on the same frequency. Not while an effect holds the channel.
;@ test: wMusicChannel1[0x0B] = rng.choice([0, 0, 1]); wMusicChannel1[7] = rng.choice([0, 0x21, 0x83, 0x45])
;@ test: wMusicChannel1[0x0E] = rand(0, 4); wMusicReleaseFrame[0] = rand(0, 4); wMusicChannel1[0x0F] = rng.choice([0, 0x80])
;@ test: wMusicChannel2[0x0B] = rng.choice([0, 0, 1]); wMusicChannel2[7] = rng.choice([0, 0x21, 0x83, 0x45])
;@ test: wMusicChannel2[0x0E] = rand(0, 4); wMusicReleaseFrame[1] = rand(0, 4); wMusicChannel2[0x0F] = rng.choice([0, 0x80])
UpdateReleaseEnvelopes_1B::
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

;>         SetReleaseEnvelope_1B(env, 0x12, wMusicChannel1 + 0x0A)   # NR12, NR14
	call SetReleaseEnvelope_1B

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

;> SetReleaseEnvelope_1B(env, 0x17, wMusicChannel2 + 0x0A)       # NR22, NR24
	ld c, $17
	ld de, wMusicChannel2 + $0A
	call SetReleaseEnvelope_1B
	ret


;@ def SetReleaseEnvelope_1B(env: b, reg: c, hi: de)
;@ path: sound/music/engine
;@ Writes release envelope env (1-7) of ReleaseEnvelopes_1B to NRx2 (reg) and restarts the note with the
;@ frequency high byte at hi (NRx4 = reg + 2). (An env of 0 would read the byte 255 bytes
;@ after the table start.)
;@ test: env = rand(1, 7); reg = rng.choice([0x12, 0x17]); hi = rng.choice([0xD31A, 0xD32A])
SetReleaseEnvelope_1B::
;>@env mem[0xFF00 + reg] = mem[ReleaseEnvelopes_1B + u8(env - 1)]
	push bc
	dec b
	ld c, b
	ld b, $00
	ld hl, ReleaseEnvelopes_1B
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


;@ def ResumeMusicAfterFanfare_1B()
;@ path: sound/music/engine
;@ An item fanfare (track $0F or $10) is over: the track in hLastMusicTrack is requested again and the
;@ music update starts over with it.
;@ test: skip restarts the whole music update
ResumeMusicAfterFanfare_1B::
;> wMusicFromBank1B = 0
	xor a
	ld [wMusicFromBank1B], a
;> wMusicTrackToPlay = hLastMusicTrack
	ldh a, [hLastMusicTrack]
	ld [wMusicTrackToPlay], a
;> return UpdateMusic_1B()
	jp UpdateMusic_1B


;@ def BlockWaveSfxCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $96: wave-channel sound effects are not played until command $95.
;@ test: skip goes on reading the pattern
BlockWaveSfxCommand_1B::
;> wMusicBlocksWaveSfx = 1
	ld a, $01

.store
	ld [wMusicBlocksWaveSfx], a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jp ReadPattern_1B


;@ def AllowWaveSfxCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $95: wave-channel sound effects play again.
;@ test: skip goes on reading the pattern
AllowWaveSfxCommand_1B::
;> wMusicBlocksWaveSfx = 0; AdvancePointer_1B(ptr); return ReadPattern_1B(ptr)   # (BlockWaveSfxCommand_1B.store)
	xor a
	jr BlockWaveSfxCommand_1B.store

;@ def WaveDecayOnCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $99: from the next note on, every wave note decays (UpdateWaveDecay_1B).
;@ test: skip goes on reading the pattern
WaveDecayOnCommand_1B::
;> wMusicWaveDecay = 1
	ld a, $01

.store
	ld [wMusicWaveDecay], a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jp ReadPattern_1B


;@ def WaveDecayOffCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $9A: the wave notes keep their level again.
;@ test: skip goes on reading the pattern
WaveDecayOffCommand_1B::
;> wMusicWaveDecay = 0; AdvancePointer_1B(ptr); return ReadPattern_1B(ptr)   # (WaveDecayOnCommand_1B.store)
	xor a
	ld [wMusicWaveDecay], a
	jr WaveDecayOnCommand_1B.store

;@ def UpdateWaveDecay_1B(state: a)
;@ path: sound/music/engine
;@ The decay of a wave note: NR32 goes to half level at frame 3, a quarter at 5, off at 7, a quarter at 10
;@ (an echo) and off for good at 13, where the decay is done (state 2) until the next note.
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdateWaveDecay_1B::
;> if state == 2: return
	cp $02
	jp z, PopHLReturn_1B

;> wMusicWaveDecayFrame += 1; frame = wMusicWaveDecayFrame   # (IncrementByte_1B)
	ld bc, wMusicWaveDecayFrame
	call IncrementByte_1B
;> if frame == 3: level = 0x40                      # half
	ld c, $1c
	ld b, $40
	cp $03
	jr z, WriteWaveLevel_1B

;>@q elif frame in (5, 0x0A): level = 0x60            # a quarter
	ld b, $60
	cp $05
	jr z, WriteWaveLevel_1B

;=@q
	cp $0a
	jr z, WriteWaveLevel_1B

;> elif frame == 7: level = 0
	ld b, $00
	cp $07
	jr z, WriteWaveLevel_1B

;> elif frame == 0x0D:
	cp $0d
	jp nz, PopHLReturn_1B

;>     level = 0
;>     wMusicWaveDecay = 2
	ld a, $02
	ld [wMusicWaveDecay], a

;> else: return
;> rNR32 = level
WriteWaveLevel_1B:
	ld a, b
	ldh [c], a
;> return
	jp PopHLReturn_1B


;@ def IncrementByte_1B(p: bc) -> a
;@ path: sound/music/engine
;@ Adds 1 to the byte at p and returns it.
;@ test: p = rand_ram(1)
IncrementByte_1B::
;> mem[p] = u8(mem[p] + 1)
	ld a, [bc]
	inc a
	ld [bc], a
;> return mem[p]
	ret


;@ def PitchDropOnCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $97: from now on the channel's notes slide down quickly (UpdatePitchDrop_1B), until
;@ command $98.
;@ test: skip goes on reading the pattern
PitchDropOnCommand_1B::
;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1B
;> mem[drop] = 1
	ld a, $01

.store
	ld [de], a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jp ReadPattern_1B


;@ def PitchDropOffCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $98: the pitch drop is off again.
;@ test: skip goes on reading the pattern
PitchDropOffCommand_1B::
;> drop = wMusicPitchDrop + 2 * (wMusicChannel - 1)
	ld de, wMusicPitchDrop
	call ChannelPairOffset_1B
;> mem[drop] = 0; AdvancePointer_1B(ptr); return ReadPattern_1B(ptr)   # (PitchDropOnCommand_1B.store)
	xor a
	jr PitchDropOnCommand_1B.store

;@ def UpdatePitchDrop_1B(drop: de, reg: c)
;@ path: sound/music/engine
;@ The pitch drop: in the first frame the note's own frequency, after that the one written last, goes
;@ down by 100 every frame (written without restarting the note).
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdatePitchDrop_1B::
;> if not mem[drop + 1]:                            # first frame of the note
	inc e
	ld a, [de]
	and a
	jr nz, .continue

;>     mem[drop + 1] = 1
	inc a
	ld [de], a
;>     f = GetNoteFrequency_1B(timer)
	pop hl
	push hl
	call GetNoteFrequency_1B

;>@else else:
;>@cont     f = GetEffectFrequency_1B()
;> WriteEffectFrequency_1B(u16(f - 100), reg)
.drop
	ld hl, -100
	add hl, de
	call WriteEffectFrequency_1B
;> return
	jp PopHLReturn_1B


;=@else
;=@cont
.continue
	call GetEffectFrequency_1B
	jr .drop

;@ def GetNoteFrequency_1B(timer: hl) -> de
;@ path: sound/music/engine
;@ The frequency of the channel's note (+9, +A; 11 bits).
;@ test: n = rand(1, 3); timer = 0xD302 + 0x10 * n
GetNoteFrequency_1B::
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


;@ def WriteEffectFrequency_1B(f: hl, reg: c)
;@ path: sound/music/engine
;@ Writes a changed frequency to NRx3 / NRx4 (reg, reg + 1) without restarting the note, and keeps it in
;@ wMusicEffectFreq for the channel.
;@ test: wMusicChannel = rand(1, 3); f = rand(0, 0xFFFF); reg = rng.choice([0x13, 0x18, 0x1D])
WriteEffectFrequency_1B::
;> keep = wMusicEffectFreq + 2 * (wMusicChannel - 1)
	ld de, wMusicEffectFreq
	call ChannelPairOffset_1B
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


;@ def ChannelPairOffset_1B(base: de) -> de
;@ path: sound/music/engine
;@ base + 2 * (wMusicChannel - 1): the channel's pair of bytes in a table with 2 bytes per channel (the
;@ table stays inside its 256-byte page).
;@ test: wMusicChannel = rand(1, 3); base = rng.choice([0xD3A4, 0xD3B0, 0xD3B6, 0xD3D0])
ChannelPairOffset_1B::
;> return (base & 0xFF00) | lo(base + 2 * (wMusicChannel - 1))
	ld a, [wMusicChannel]
	dec a
	sla a
	add e
	ld e, a
	ret


;@ def GetEffectFrequency_1B() -> de
;@ path: sound/music/engine
;@ The frequency the channel's pitch effect wrote last (wMusicEffectFreq).
;@ test: wMusicChannel = rand(1, 3)
GetEffectFrequency_1B::
;> keep = wMusicEffectFreq + 2 * (wMusicChannel - 1)
	ld de, wMusicEffectFreq
	call ChannelPairOffset_1B
;>@k return mem[keep] | mem[keep + 1] << 8
	ld a, [de]
	ld l, a
	inc e
;=@k
	ld a, [de]
	ld d, a
	ld e, l
	ret


;@ def UpdateVibrato_1B(timer: stack, reg: c)
;@ path: sound/music/engine
;@ The vibrato (effect 1): it starts 24 frames into the note; from then on the note's frequency gets the
;@ offsets of VibratoOffsets_1B, one per frame, over and over (20 frames).
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdateVibrato_1B::
;> v = wMusicVibrato + 2 * (wMusicChannel - 1)     # frame counter, running flag
	pop de
	ld de, wMusicVibrato
	call ChannelPairOffset_1B
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

;> elif not mem[v + 1]: return UpdateDropAndWaveEffects_1B()
	ld a, [de]
	and a
	jp z, UpdateDropAndWaveEffects_1B

;> idx = mem[v] - 0x19
.apply
	dec e
	ld a, [de]
	sub $19
;> o = VibratoOffsets_1B + 2 * idx
	sla a
	ld l, a
	ld h, $00
	ld de, VibratoOffsets_1B
	add hl, de
;> offset = mem[o] << 8 | mem[o + 1]               # high byte first
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
;> f = GetNoteFrequency_1B(timer)
	pop hl
	push hl
	push de
	call GetNoteFrequency_1B
;> WriteEffectFrequency_1B(u16(f + offset), reg)
	ld h, d
	ld l, e
	pop de
	add hl, de
	call WriteEffectFrequency_1B
;> return UpdateDropAndWaveEffects_1B()
	jp UpdateDropAndWaveEffects_1B


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
;@ Vibrato (effect 1): 20 frequency offsets, one per frame, stored high byte first (UpdateVibrato_1B). Values 0, 0, 1, 1, 2, 2, 0, 0, -1, -1, -2, -2, 0, 1, 2, 1, 0, -1, -2, -1.
VibratoOffsets_1B::
	db $00, $00, $00, $00, $00, $01, $00, $01
	db $00, $02, $00, $02, $00, $00, $00, $00
	db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe
	db $00, $00, $00, $01, $00, $02, $00, $01
	db $00, $00, $ff, $ff, $ff, $fe, $ff, $ff

;@ def UpdateWideVibrato_1B(timer: stack, reg: c)
;@ path: sound/music/engine
;@ The wide vibrato (effect 5): a frame counter 1-32 that runs on across notes picks the offset from
;@ WideVibratoOffsets_1B (entry 1-32: entry 0 is never used, and the 32nd read takes the first two bytes
;@ of WaveSwellCommand_1B, $3E01).
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdateWideVibrato_1B::
;> w = wMusicWideVibrato + 2 * (wMusicChannel - 1)
	pop de
	ld de, wMusicWideVibrato
	call ChannelPairOffset_1B
;> mem[w] += 1
	ld a, [de]
	inc a
	ld [de], a
;> if mem[w] == 0x21: mem[w] = 1
	inc e
	cp $21
	jr z, .wrap

;>@o o = WideVibratoOffsets_1B + 2 * mem[w]
.apply
	dec e
	ld a, [de]
	sla a
	ld l, a
	ld h, $00
;=@o
	ld de, WideVibratoOffsets_1B
	add hl, de
;> offset = mem[o] << 8 | mem[o + 1]               # high byte first
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
;> f = GetNoteFrequency_1B(timer)
	pop hl
	push hl
	push de
	call GetNoteFrequency_1B
;> WriteEffectFrequency_1B(u16(f + offset), reg)
	ld h, d
	ld l, e
	pop de
	add hl, de
	call WriteEffectFrequency_1B
;> return UpdateDropAndWaveEffects_1B()
	jp UpdateDropAndWaveEffects_1B


;> # (.wrap: mem[w] = 1, then .apply)
.wrap
	dec e
	ld a, $01
	ld [de], a
	inc e
	jr .apply

;@ path: sound/music/data
;@ Wide vibrato (effect 5): 32 frequency offsets stored high byte first (UpdateWideVibrato_1B): +8, 0, -8, 0, +10, +2, -6, +2, +12, +4, -4, +4, +10, +2, -6, +2, +8, 0, -8, 0, +6, -2, -10, -2, +4, -4, -12, -4, +6, -2, -10, -2. The routine reads entries 1-32, so entry 0 is skipped and the last read takes the two bytes after the table (the first instruction of WaveSwellCommand_1B).
WideVibratoOffsets_1B::
	db $00, $08, $00, $00, $ff, $f8, $00, $00
	db $00, $0a, $00, $02, $ff, $fa, $00, $02
	db $00, $0c, $00, $04, $ff, $fc, $00, $04
	db $00, $0a, $00, $02, $ff, $fa, $00, $02
	db $00, $08, $00, $00, $ff, $f8, $00, $00
	db $00, $06, $ff, $fe, $ff, $f6, $ff, $fe
	db $00, $04, $ff, $fc, $ff, $f4, $ff, $fc
	db $00, $06, $ff, $fe, $ff, $f6, $ff, $fe

;@ def WaveSwellCommand_1B(ptr: hl)
;@ path: sound/music/engine
;@ Pattern command $94: from the next note on, every wave note swells in (UpdateWaveSwell_1B).
;@ test: skip goes on reading the pattern
WaveSwellCommand_1B::
;> wMusicWaveSwell = 1
	ld a, $01
	ld [wMusicWaveSwell], a
;> AdvancePointer_1B(ptr)
	call AdvancePointer_1B
;> return ReadPattern_1B(ptr)
	jp ReadPattern_1B


;@ def UpdateWaveSwell_1B(state: a)
;@ path: sound/music/engine
;@ The swell of a wave note: NR32 goes to a quarter at frame 3, half at 5 and full at 6, where the swell
;@ is done (state 2) until the next note.
;@ test: skip pops what UpdateNoteEffects_1B pushed
UpdateWaveSwell_1B::
;> if state == 2: return
	cp $02
	jp z, PopHLReturn_1B

;> wMusicWaveSwellFrame += 1; frame = wMusicWaveSwellFrame     # (IncrementByte_1B)
	ld bc, wMusicWaveSwellFrame
	call IncrementByte_1B
;> if frame == 3: return WriteWaveLevel_1B(0x60)   # a quarter
	ld c, $1c
	ld b, $60
	cp $03
	jp z, WriteWaveLevel_1B

;> if frame == 5: return WriteWaveLevel_1B(0x40)   # half
	ld b, $40
	cp $05
	jp z, WriteWaveLevel_1B

;> if frame != 6: return
	ld b, $20
	cp $06
	jp nz, PopHLReturn_1B

;> wMusicWaveSwell = 2
	ld a, $02
	ld [wMusicWaveSwell], a
;> return WriteWaveLevel_1B(0x20)                  # full
	jp WriteWaveLevel_1B


;@ path: sound/music/data
;@ Frequency register value of each note (2 bytes, NRx3 then NRx4 bits 0-2), indexed by the note byte: $02 = C2 (65 Hz) ... $90 = D8, one semitone per 2. Entry 0 is never played.
NoteFrequencies_1B::
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
;@ Drums of the noise channel, indexed by the note byte ($01, $06, $0B, ... in steps of 5): 5 bytes each - NR42 envelope, unused, NR41 length, NR43 noise, NR44 (bit 6: stop after the length). $01 is silence (NR42 = 0). Note $FF plays the two-step drum of UpdateDrumFF_1B instead.
DrumSounds_1B::
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

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 32 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. No song uses it.
NoteLengths32_1B::
	db $01, $02, $04, $08, $10, $20, $06, $0c, $18, $01, $01, $01, $01, $01, $30

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 48 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. No song uses it.
NoteLengths48_1B::
	db $01, $03, $06, $0c, $18, $30, $09, $12, $24, $02, $04, $08, $01, $01, $48

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 64 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $02.
NoteLengths64_1B::
	db $02, $04, $08, $10, $20, $40, $0c, $18, $30, $02, $05, $03, $01, $01, $60

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 80 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $0E, $0F, $10, $33, $34, $37, $39, $3B, $3E.
NoteLengths80_1B::
	db $03, $05, $0a, $14, $28, $50, $0f, $1e, $3c, $02, $08, $10, $02, $01, $78

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 96 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $01, $05, $06, $0C, $0D, $31, $34, $3D.
NoteLengths96_1B::
	db $03, $06, $0c, $18, $30, $60, $12, $24, $48, $03, $08, $10, $02, $04, $90

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 112 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $08, $34, $35, $36, $3D, $3F.
NoteLengths112_1B::
	db $03, $07, $0e, $1c, $38, $70, $15, $2a, $54, $04, $09, $12, $02, $01, $a8

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 128 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $03, $0A, $32, $38, $3C, $3D.
NoteLengths128_1B::
	db $04, $08, $10, $20, $40, $80, $18, $30, $60, $04, $02, $01, $01, $00, $c0

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 144 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $04, $3A, $3D, $40.
NoteLengths144_1B::
	db $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $05, $0c, $18, $18, $06, $d8

;@ path: sound/music/data
;@ Note length table (frames per length code $A0-$AE): $A5 = 160 frames (a whole note), $A0-$A4 = 1/32 to 1/2 of it, $A6-$A8 dotted 1/8, 1/4, 1/2, $A9-$AD short and triplet lengths, $AE dotted whole. Used by tracks $04, $07, $09, $0B.
NoteLengths160_1B::
	db $05, $0a, $14, $28, $50, $a0, $1e, $3c, $78, $05, $01, $01, $01, $01, $f0

;@ path: sound/music/data
;@ Release envelopes (NRx2 values) for square notes: instrument byte 2, low nibble n (1-7) picks entry n-1, written at the release frame of each note (UpdateReleaseEnvelopes_1B).
ReleaseEnvelopes_1B::
	db $10, $32, $22, $47, $81, $20, $00

;@ path: sound/music/songs
;@ A pattern list that repeats 32 rests of the longest length forever: the channel stays silent. Used by tracks $04, $0A, $32, $33, $34, $36, $38, $3A.
MusicSilentChannel_1B::
.m04Wave: ; wave pattern list (tracks $04, $0A, $32, $33, $34, $36, $38, $3A)
	dw .m04Pat1, $FFFF, MusicSilentChannel_1B
.m04Pat1: ; tracks $04, $0A, $32, $33, $34, $36, $38, $3A
	db $9b, $20, $ae, $01, $9c, $00

;@ path: sound/music/data
;@ A wave pattern (32 4-bit samples) no song uses.
MusicUnusedWave_1B::
	db $00, $22, $44, $55, $66, $66, $88, $88, $aa, $aa, $cc, $cc, $04, $84, $04, $84

;@ path: sound/music/songs
;@ Music track $10: not started by the game.
;@ Entry 16 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music10::
	db $00 ; transpose
	dw NoteLengths80_1B
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
	db $9d, $60, $21, $00, $96, $a2, $5c, $5e, $aa, $60, $62, $64, $ae, $66, $95, $00
.pat2:
	db $9d, $80, $21, $41, $a2, $4a, $4c, $aa, $4e, $50, $52, $ae, $54, $00
.pat3:
	db $9d
	dw MusicCommonData_1B.waveform5
	db $20, $99, $a2, $3c, $3e, $aa, $40, $42, $44, $9a, $a5, $46, $a4, $01, $00
.pat4:
	db $a3, $01, $aa, $15, $1a, $1a
	db $9b, $1e, $a0, $15, $9c, $a7, $01, $00

;@ path: sound/music/songs
;@ Music track $40: not started by the game.
;@ Entry 32 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music40::
	db $04 ; transpose
	dw NoteLengths144_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, .pat4, .pat4, .pat4, .pat4, .pat4, .pat4, .pat4
	dw .pat4, .pat6, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, .pat5, $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat3, .pat3, .pat3, .pat3, .pat3, .pat3, .pat3, .pat3
	dw .pat6, $FFFF, .wave
.pat1:
	db $9d, $31, $00, $40, $00
.pat2:
	db $9d, $30, $81, $80
	db $9b, $08, $a3, $01, $a2, $44, $46, $a3, $4a, $a2, $54, $5c, $a7, $5c, $a1, $58
	db $56, $a4, $58, $a2, $01, $58, $5c, $5e, $a3, $5c, $58, $a5, $4a, $a4, $7a, $a7
	db $6c, $a1, $6a, $6c, $a4, $70, $62, $66, $ae, $74, $9c, $00
.pat3:
	db $9d
	dw MusicCommonData_1B.waveform6
	db $40, $99
.pat4:
	db $9b, $02, $a2, $24, $2c, $32, $2c, $9c
	db $9b, $02, $24, $30, $36, $30, $9c, $24, $2e, $36, $2e, $22, $2e, $34, $2e, $2c
	db $32, $40, $3a, $3c, $36, $32, $2c
	db $9b, $02, $28, $2e, $36, $2e, $9c
	db $9b, $02, $28, $2e, $34, $2e, $9c
	db $9b, $04, $24, $2c, $32, $2c, $9c, $00
.pat5:
	db $9d, $61, $00, $80, $a4, $01, $97, $ac, $01, $ad, $2c, $2c, $ac, $2c, $aa, $2c
	db $98, $ac, $32, $ad, $32, $36, $ac, $3a, $aa, $36, $a3, $32, $40, $3a, $4a, $a4
	db $40, $ac, $40, $ad, $40, $42, $ac, $40, $aa, $3e, $a4, $38, $a3, $36, $a7, $40
	db $a4, $40, $a7, $01, $00
.pat6:
	db $9b, $0b, $a4, $01, $9c, $00

;@ path: sound/music/songs
;@ Music track $3C: not started by the game.
;@ Entry 28 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3C::
	db $00 ; transpose
	dw NoteLengths128_1B
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
	db $9d, $60, $00, $41, $a7, $01, $a1, $4e, $aa, $01, $ae, $50, $00
.pat2:
	db $9d, $40, $00, $01, $a7, $01, $a1, $64, $aa, $01, $ae, $66, $00
.pat3:
	db $9d
	dw .waveform1
	db $20, $a7, $01, $a1, $5a, $aa, $01, $ae, $5c, $00
.pat4:
	db $a7, $01, $a1, $01, $aa, $01, $a5, $01, $a1, $ff, $a2, $ff, $ff, $a1, $ff, $a2
	db $ff, $00
.pat5:
	db $9d, $22, $00, $80, $97
	db $9b, $20, $a1, $54, $6a, $62, $5c, $78, $70, $6a, $9c, $00
.pat6:
	db $9d, $81, $00, $40, $a6, $46, $a0, $46, $4a, $a6, $4e, $a1, $4a, $a3, $46, $54
	db $4e, $5e, $a4, $54, $a6, $54, $a0, $54, $56, $a6, $54, $a1, $52, $a4, $4c, $a3
	db $4a, $54, $a4, $46, $a5, $01, $01, $01
	db $9d, $61, $00, $80, $97, $a1, $36, $a6, $36, $a1, $36, $a6, $36, $a1, $36, $a2
	db $36, $36, $a1, $36, $a2, $36, $98, $00
.waveform1: ; wave pattern: 32 4-bit samples
	db $8a, $df, $da, $86, $31, $01, $36, $86, $8a, $df, $da, $86, $31, $01, $36, $86
.pat7:
	db $9d
	dw .waveform1
	db $20, $97
	db $9b, $02, $aa, $30, $01, $a0, $01, $a1, $01, $9c, $a6, $01, $aa, $30, $01, $a0
	db $01, $a1, $01
	db $9b, $02, $aa, $30, $01, $a0, $01, $9c, $a1, $01, $a3, $01
	db $9b, $02, $aa, $30, $01, $a0, $01, $a1, $01, $9c, $a6, $01, $aa, $30, $01, $a0
	db $01, $a1, $01
	db $9b, $02, $aa, $30, $01, $a0, $01, $9c, $a1, $01, $a6, $01, $aa, $30, $01, $a0
	db $01, $00
.pat8:
	db $9b, $07, $a1, $15, $15, $15, $15, $ff, $15, $15, $15, $15, $15, $15, $15, $ff
	db $15, $15, $1a, $9c
	db $9b, $02, $ff, $ff, $15, $15, $9c, $ff, $ff, $15, $ff, $15, $ff, $ff, $15, $00

;@ path: sound/music/songs
;@ Music track $37: not started by the game.
;@ Entry 23 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music37::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw .pat3, $FFFF, .wave
.pat1:
	db $9d, $43, $00, $80, $a7, $4c, $4c, $4c, $4c, $4a, $4a, $4a, $4a, $46, $46, $46
	db $46, $42, $46, $4a, $50, $00
.pat2:
	db $9d, $40, $21, $80, $a8, $5a, $a3, $01, $a2, $58, $a3, $5e, $a8, $50, $a2, $01
	db $a3, $5a, $a2, $42, $a3, $46, $a2, $4a, $a3, $4c, $a2, $4a, $a3, $4c, $a7, $40
	db $54, $ae, $50, $a2, $01, $00
.waveform2: ; wave pattern: 32 4-bit samples
	db $44, $44, $44, $42, $00, $00, $00, $00, $44, $44, $44, $42, $00, $00, $00, $00
.pat3:
	db $9d
	dw .waveform2
	db $20, $99, $a7, $4a, $4a, $46, $46, $46, $46, $42, $42, $42, $42, $40, $40, $3e
	db $3e, $44, $4a, $00

;@ def SilenceMusicAndNoise_1B()
;@ path: sound/music/engine
;@ Entry $4003 (not used by the game): ends any noise effect, silences the noise channel and stops the
;@ music (EndMusic_1B).
;@ test: skip resets the whole music state
SilenceMusicAndNoise_1B::
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
;> mem[0xD3A3] = 0
	ld [wSoundUnusedA3], a
;> mem[0xD3E5] = 0
	ld [wSoundUnusedE5], a
;> rNR42 = 0x08                              # volume 0
	ld a, $08
	ldh [rNR42], a
;> rNR44 = 0x80
	ld a, $80
	ldh [rNR44], a
;> return EndMusic_1B()                      # falls through

;@ def EndMusic_1B()
;@ path: sound/music/engine
;@ The music is over: all channels on both sides again, no song playing, and the music state reset.
;@ test: skip resets the whole music state
EndMusic_1B::
;> rNR51 = 0xFF
	ld a, $ff
	ldh [rNR51], a
;> wMusicPanMode = 3
	ld a, $03
	ld [wMusicPanMode], a
;> wActiveMusicTrack = 0
	xor a
	ld [wActiveMusicTrack], a
;> return ResetMusicState_1B()               # falls through

;@ def ResetMusicState_1B()
;@ path: sound/music/engine
;@ Clears the effect flags of the music channels and the state of the square- and wave-channel sound
;@ effects (they stop too), the wave and pitch effects, and silences square channels 1-2, the sweep and
;@ the wave channel. The noise channel is left alone.
ResetMusicState_1B::
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
;> mem[0xD395] = 0
	ld [wUnusedSfxStep], a
;> wWaveSfxStep = 0
	ld [wWaveSfxStep], a
;> wJingleTimer = 0
	ld [wJingleTimer], a
;> mem[0xD391] = 0
	ld [wUnusedSfxTimer], a
;> wWaveSfxTimer = 0
	ld [wWaveSfxTimer], a
;> wJingleLocked = 0
	ld [wJingleLocked], a
;> mem[0xD3C7] = 0
	ld [wUnusedSfxLocked], a
;> wWaveSfxLocked = 0
	ld [wWaveSfxLocked], a
;> mem[0xD3A0] = 0
	ld [wSoundUnusedA0], a
;> mem[0xD3A1] = 0
	ld [wSoundUnusedA1], a
;> mem[0xD3A2] = 0
	ld [wSoundUnusedA2], a
;> wMusicBlocksWaveSfx = 0
	ld [wMusicBlocksWaveSfx], a
;> mem[0xD3D6] = 0
	ld [wSfxFastVariant], a
;> mem[0xD3D7] = 0
	ld [wJingle22Count], a
;> mem[0xD3D8] = 0
	ld [wSoundUnusedD8], a
;> mem[0xD3DC] = 0
	ld [wWaveSfx1ECount], a
;> wWaveRamDirty = 0
	ld [wWaveRamDirty], a
;> mem[0xD3E2] = 0
	ld [wJingleSubStep], a
;> mem[0xD3E3] = 0
	ld [wSoundUnusedE3], a
;> mem[0xD3E4] = 0
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
;@ Unused space of bank $1B, filled with $FF.
Padding_1B_4E48::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
;@ Music track $38: not started by the game.
;@ Entry 24 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music38::
	db $00 ; transpose
	dw NoteLengths128_1B
	dw MusicSilentChannel_1B, MusicSilentChannel_1B, .wave, $0000
.wave: ; wave pattern list
	dw .pat1, $0000
.pat1:
	db $9d
	dw MusicCommonData_1B.waveform9
	db $01, $94, $a3, $4a, $a2, $4e, $a3, $52, $a2, $4e, $a7, $4a, $58, $52, $62, $a8
	db $58, $a3, $58, $a2, $5a, $a3, $58, $a2, $56, $a8, $50, $a7, $4e, $58, $a8, $4a
	db $9a, $00

;@ path: sound/music/songs
;@ Music track $01: not started by the game.
;@ Entry 1 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music01::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m01Pat8
.sq1Loop:
	dw .pat1, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat2
.sq2Loop:
	dw .pat3, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1B.m01Pat7, .pat4
.waveLoop:
	dw MusicCommonData_1B.m01Pat6, .pat5, $FFFF, .waveLoop
.pat1: ; tracks $01, $0D
	db $9d, $66, $81, $80, $a5, $01, $a2, $01, $5e, $a1, $5e, $62, $66, $68, $a3, $6c
	db $01, $01, $a1, $64, $6e, $72, $76, $a3, $7c, $01, $a7, $01, $a1, $64, $68, $a2
	db $6c, $64, $a3, $5a, $a7, $01
	db $9b, $02, $a1, $68, $6c, $a2, $6e, $9c, $01, $a7, $01
	db $9b, $02, $a1, $64, $68, $a2, $6c, $9c, $01, $a7, $01, $a1, $62, $66, $a2, $6a
	db $a1, $6a, $6c, $70, $74, $76, $7a, $a2, $74, $01, $a8, $01, $a5, $01, $00
.pat2:
	db $9d, $a0, $84, $80, $a4, $46, $a2, $01, $46, $46, $a1, $46, $46
	db $9b, $02, $a6, $46, $a1, $42, $a3, $46, $a2, $01, $46, $46, $a1, $46, $46, $9c
	db $a2, $46, $a1, $3c, $3c
	db $9b, $02, $a2, $3c, $a1, $3c, $3c, $9c, $a2, $3c, $3c, $00
.pat3: ; tracks $01, $0D
	db $9d, $80, $21, $40, $a2, $46, $01, $a7, $3c, $a1, $01, $46, $46, $4a, $4e, $50
	db $a4, $54, $a2, $01, $54, $54, $a1, $56, $5a, $a4, $5e, $a2, $01, $5e, $5e, $a1
	db $5a, $56, $a6, $5a, $a1, $56, $a4, $54, $a3, $54, $a6, $50, $a1, $54, $a4, $56
	db $a2, $54, $50, $a6, $4c, $a1, $50, $a4, $54, $a2, $50, $4c, $a6, $4a, $a1, $4e
	db $a4, $52, $a3, $58
	db $9d, $60, $81, $80, $a2, $54, $a1, $46, $46, $a2, $46, $a1, $46, $46, $a3, $46
	db $01, $a2, $01, $a1, $44, $44, $a2, $44, $a1, $44, $44, $a3, $44, $01, $00
.pat4:
	db $99, $a3, $4e, $a2, $01, $a1, $2e, $2e, $a2, $2e, $4e, $4e, $a1, $4e, $4e, $a6
	db $4a, $a1, $4a, $a2, $4a, $a1, $2a, $2a, $a2, $2a, $4a, $4a, $a1, $4a, $4a, $a6
	db $4c, $a1, $4c, $a2, $4c, $a1, $26, $26, $a2, $26, $4c, $4c, $a1, $4c, $4c, $a2
	db $4c, $a1, $44, $44
	db $9b, $02, $a2, $44, $a1, $44, $44, $9c, $a2, $24, $a1, $28, $2c, $00
.pat5: ; tracks $01, $0D
	db $99
	db $9b, $02, $a2, $2e, $a3, $46, $a2, $46, $9c
	db $9b, $02, $a2, $2a, $a3, $42, $a2, $42, $9c
	db $9b, $02, $a2, $26, $a3, $3e, $a2, $3e, $9c
	db $9b, $02, $a2, $34, $a3, $4c, $a2, $4c, $9c
	db $9b, $02, $a2, $30, $a3, $48, $a2, $48, $9c
	db $9b, $02, $a2, $2e, $a3, $46, $a2, $46, $9c, $a2, $32, $a3, $4a, $a2, $4a, $32
	db $4a, $5e, $32, $3c
	db $9b, $02, $a1, $50, $50, $a2, $50, $9c, $a1, $32, $32, $a2, $32, $a1, $32, $32
	db $a2, $3c
	db $9b, $02, $a1, $50, $50, $a2, $50, $9c, $a1, $24, $24, $24, $26, $28, $2c, $00

;@ path: sound/music/songs
;@ Music track $02: not started by the game.
;@ Entry 2 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music02::
	db $00 ; transpose
	dw NoteLengths64_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m02Pat9, MusicCommonData_1B.m02Pat13, .pat1, .pat1, .pat1, .pat1, .pat1, .pat1
	dw MusicCommonData_1B.m02Pat10, MusicCommonData_1B.m02Pat14, .pat1, .pat1, .pat1, .pat2, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m02Pat11, MusicCommonData_1B.m02Pat13, .pat3, .pat4, MusicCommonData_1B.m02Pat12, MusicCommonData_1B.m02Pat14, .pat4, .pat5
	dw $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m02Pat8, MusicCommonData_1B.m02Pat13, .pat6, .pat6, .pat6, .pat6, .pat6, .pat6
	dw MusicCommonData_1B.m01Pat6, MusicCommonData_1B.m02Pat14, .pat6, .pat6, .pat6, .pat7, $FFFF, .wave
.pat1:
	db $a7, $22, $a2, $22, $a3, $24, $22, $1e, $18, $00
.pat2:
	db $a7, $22, $a2, $22, $a3, $24, $22, $1e, $01, $00
.pat3:
	db $9b, $03, $a8, $01, $9c, $a4, $01, $00
.pat4:
	db $9b, $02, $a1, $01, $40, $42, $44, $a7, $46, $a2, $3a, $a4, $46, $a1, $01, $44
	db $46, $44, $a2, $40, $3c, $a7, $40, $a2, $32, $a8, $40, $9c, $00
.pat5:
	db $a3, $01, $00
.pat6:
	db $99, $a7, $32, $a2, $32, $a3, $34, $32, $2e, $28, $00
.pat7:
	db $99, $a7, $32, $a2, $32, $a3, $34, $32, $2e, $01, $00

;@ path: sound/music/songs
;@ Music track $03: not started by the game.
;@ Entry 3 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music03::
	db $00 ; transpose
	dw NoteLengths128_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat3, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat1, .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m03Pat5
.waveLoop:
	dw .pat4, .pat2, $FFFF, .waveLoop
.pat1:
	db $9d, $57, $00, $80, $00
.pat2:
	db $a2, $78, $7c, $a3, $7e, $01, $01, $a2, $78, $7c, $a3, $7e, $01, $01, $a2, $7c
	db $78, $6e, $a7, $74, $a3, $78, $01, $a8, $01, $a2, $78, $7c, $a3, $7e, $01, $01
	db $a2, $78, $7e, $a3, $88, $01, $01, $a2, $86, $82, $a4, $86, $01, $a8, $01, $00
.pat3:
	db $9d, $37, $00, $80, $a7, $01
	db $9b, $02, $a2, $40, $4e, $58, $5c, $a3, $60, $01, $9c, $a2, $48, $56, $5c, $6a
	db $a3, $6e, $01, $a2, $48, $56, $5c, $56, $44, $56, $5c, $56
	db $9b, $02, $a2, $40, $4e, $58, $5c, $a3, $60, $01, $9c, $a2, $36, $44, $4c, $52
	db $56, $5c, $64, $6a, $6e, $6a, $6e, $74, $8c, $00
.pat4:
	db $9d
	dw MusicCommonData_1B.waveform11
	db $20, $00

;@ path: sound/music/songs
;@ Music track $04: not started by the game.
;@ Entry 4 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music04::
	db $00 ; transpose
	dw NoteLengths144_1B
	dw .sq1, .sq2, MusicSilentChannel_1B, $0000
.sq1: ; square 1 pattern list
	dw .pat2, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat3, $FFFF, .sq2
.pat2:
	db $9d, $52, $00, $80, $99
	db $9b, $02, $a2, $40, $4e, $9c
	db $9b, $02, $40, $52, $9c
	db $9b, $02, $40, $56, $9c
	db $9b, $02, $40, $52, $9c
	db $9b, $02, $40, $4e, $9c
	db $9b, $02, $40, $50, $9c
	db $9b, $02, $44, $52, $9c, $4e, $36, $3a, $36
	db $9b, $02, $32, $40, $9c
	db $9b, $02, $32, $44, $9c
	db $9b, $02, $30, $44, $9c
	db $9b, $02, $3a, $48, $9c
	db $9b, $02, $2c, $3a, $9c, $2c, $38, $36, $32
	db $9d, $40, $00, $80, $a4, $36, $32
	db $9e
	dw NoteLengths160_1B
	db $a4, $30, $a7, $2c
	db $9d, $52, $00, $80, $a2, $36
	db $9e
	dw NoteLengths144_1B
	db $00
.pat3:
	db $9d, $56, $00, $80, $a3, $66, $58, $a7, $5c, $a1, $60, $62, $a2, $66, $66, $58
	db $58, $a7, $5c, $a1, $60, $62, $a2, $60, $66, $a7, $74, $a2, $70, $74, $70, $66
	db $a1, $62, $60, $a3, $5c
	db $9d, $42, $00, $80, $56
	db $9d, $56, $00, $80, $a1, $01, $60, $62, $66, $a3, $6a, $58, $a7, $56, $a1, $5c
	db $6a, $a2, $66, $66, $56, $56, $a7, $58, $a1, $58, $56, $a2, $52, $58, $a7, $60
	db $a2, $5c, $58, $50
	db $9b, $04, $4e, $66, $9c
	db $9e
	dw NoteLengths160_1B
	db $9b, $04, $a2, $66, $7e, $9c
	db $9e
	dw NoteLengths144_1B
	db $00

;@ path: sound/music/songs
;@ Music track $05: not started by the game.
;@ Entry 5 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music05::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1
.m31Sq1:
	dw .pat2, .pat3, .pat2, .pat4, $FFFF, .m31Sq1
.sq2: ; square 2 pattern list
	dw .pat5
.m31Sq2:
	dw .pat6, .pat7, .pat6, .pat8, $FFFF, .m31Sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m01Pat6, .pat9
.m31Wave:
	dw MusicCommonData_1B.m01Pat6, .pat10, .pat11, .pat10, .pat12, MusicCommonData_1B.m05Pat15, .pat13, MusicCommonData_1B.m01Pat6
	dw .pat14, $FFFF, .m31Wave
.pat1:
	db $9d, $45, $00, $80, $a3, $30, $aa, $30, $30, $30, $a3, $2c, $aa, $2c, $30, $32
	db $a3, $38, $aa, $38, $38, $38, $a3, $3c, $aa, $3c, $3c, $3c
	db $9d, $40, $21, $81, $a8, $40, $aa, $3c, $3c, $3c, $a8, $40, $a3, $01, $00
.pat2: ; tracks $05, $31
	db $9d, $45, $00, $80, $a3, $30, $aa, $32, $30, $2c, $a6, $30, $a1, $30, $30, $32
	db $36, $3a, $a6, $3c, $a1, $40, $40, $44, $48, $4a, $a3, $4e, $aa, $3c, $40, $44
	db $a6, $46, $a1, $38, $38, $3c, $40, $44, $aa, $46, $01, $46, $46, $44, $40, $46
	db $01, $3c, $3c, $3c, $38, $3c, $01, $3c, $3c, $38, $3c, $a2, $38, $a1, $38, $36
	db $a2, $38, $a1, $38, $3c, $a3, $40, $a2, $3c, $38, $00
.pat3: ; tracks $05, $31
	db $a2, $36, $a1, $36, $32, $a2, $36, $a1, $36, $38, $a3, $3c, $a2, $38, $36, $a3
	db $34, $a2, $34, $a1, $34, $36, $a2, $3a, $a1, $3a, $3c, $40, $44, $46, $4a, $a3
	db $44
	db $9d, $40, $21, $41, $aa, $32, $32, $32, $a3, $36, $01, $00
.pat4: ; tracks $05, $31
	db $9d, $45, $00, $80, $aa, $36, $34, $36, $3e, $40, $44, $46, $01, $46, $46, $44
	db $40
	db $9d, $70, $21, $80, $a6, $4e, $46, $a2, $40, $a3, $3e, $aa, $3e, $3a, $3e, $aa
	db $40, $44, $46, $4a, $46, $44, $a3, $46, $01
	db $9d, $50, $21, $81, $a3, $46, $a7, $40, $a1, $01, $46, $46, $4a, $4e, $50, $aa
	db $4a, $01, $46, $a4, $44, $a3, $3c, $aa, $40, $01, $36, $a3, $36, $32, $3a, $a2
	db $40, $a1, $40, $3e, $40, $44, $46, $4a, $a4, $4e, $aa, $4e, $01, $4a, $a4, $46
	db $a3, $01, $aa, $4a, $01, $50, $a4, $5a, $a3, $01, $01, $aa, $40, $40, $40, $a3
	db $40, $01
	db $9d, $40, $21, $40, $01, $aa, $4a, $4a, $4a, $a3, $4e, $01, $00
.pat5:
	db $9d, $55, $00, $80, $a3, $40, $aa, $40, $36, $40, $a3, $3c, $aa, $3c, $40, $44
	db $a3, $46, $aa, $46, $40, $46, $a3, $44, $aa, $44, $46, $4a
	db $9d, $50, $21, $81, $a8, $4e, $aa, $4a, $4a, $4a, $a8, $4e, $aa, $4a, $48, $44
	db $00
.pat6: ; tracks $05, $31
	db $9d, $65, $00, $80, $a3, $40, $a7, $36, $a1, $01, $40, $40, $44, $48, $4a, $a4
	db $4e, $aa, $01, $01, $4e, $4e, $50, $54, $a4, $58, $aa, $01, $01, $58, $58, $54
	db $50, $54, $01, $50, $a4, $4e, $aa, $4e, $50, $4e, $a2, $4a, $a1, $4a, $4e, $a4
	db $50, $a2, $4e, $4a, $00
.pat7: ; tracks $05, $31
	db $a2, $46, $a1, $46, $4a, $a4, $4e, $a2, $4a, $46, $44, $a1, $44, $48, $a4, $4c
	db $a3, $52, $a2, $4e
	db $9d, $60, $21, $01, $ad, $36, $36, $36, $aa, $3a, $3a, $3a, $a3, $3e, $01, $00
.pat8: ; tracks $05, $31
	db $9d, $45, $00, $80, $aa, $46, $44, $46, $4a, $46, $4a, $4e, $01, $4e, $4e, $4a
	db $46
	db $9d, $40, $00, $81, $a4, $4e, $66, $a8, $58
	db $9d, $70, $21, $41, $aa, $4e, $50, $54, $a3, $58, $a7, $4e, $a1, $01, $58, $58
	db $5c, $5e, $62, $aa, $5c, $01, $54, $a7, $4a, $a1, $4a, $4e, $54, $50, $4e, $4a
	db $aa, $4e, $01, $40, $a7, $40, $a1, $40, $3e, $40, $44, $46, $4a, $a4, $4e, $a3
	db $01, $aa, $4e, $4a, $4e, $aa, $5e, $01, $5c, $a3, $58, $aa, $01, $4e, $4e, $4e
	db $46, $58, $5a, $01, $5e, $a3, $62, $aa, $01, $62, $66, $68, $6c, $68, $a5, $66
	db $9d, $40, $21, $40, $a2, $01, $ad, $4e, $4e, $4e, $aa, $52, $52, $52, $a3, $56
	db $01, $00
.pat9:
	db $99, $a3, $40, $aa, $40, $40, $40, $a3, $3c, $aa, $3c, $3c, $3c, $a3, $38, $aa
	db $38, $38, $38, $3c, $3c, $3c, $3c, $38, $3c
	db $9b, $02, $a3, $40, $aa, $40, $40, $40, $a3, $40, $aa, $36, $36, $36, $9c, $00
.pat10: ; tracks $05, $31
	db $a3, $28, $aa, $28, $28, $24, $a3, $28, $28, $24, $aa, $24, $24, $20, $a3, $24
	db $24, $20, $aa, $20, $20, $1e, $a3, $20, $20, $2e, $aa, $2e, $2e, $2a, $a3, $2e
	db $2e, $00
.pat11: ; tracks $05, $31
	db $2a, $aa, $2a, $2a, $28, $a3, $2a, $aa, $2a, $2a, $2a, $a3, $28, $aa, $28, $28
	db $24, $a3, $28, $aa, $28, $28, $28
	db $9b, $02, $a3, $2c, $aa, $2c, $2c, $2c, $9c, $a3, $36, $aa, $40, $40, $40, $9a
	db $a3, $44, $99, $a2, $22, $26, $00
.pat12: ; tracks $05, $31
	db $a3, $2a, $aa, $42, $42, $40, $a3, $42, $aa, $42, $42, $42, $00
.pat13: ; tracks $05, $31
	db $9a, $a3, $40, $3e, $a4, $3c, $a3, $3a, $32, $99, $a3, $36, $00
.pat14: ; tracks $05, $31
	db $aa, $36, $4e, $4a, $46, $44, $40, $a3, $44, $40, $01, $20, $aa, $38, $40, $46
	db $a3, $50, $aa, $20, $20, $20, $a3, $1e, $aa, $36, $3c, $44, $a3, $4e, $aa, $36
	db $36, $36
	db $9b, $03, $a3, $28, $aa, $28, $28, $28, $9c, $a6, $28, $28, $a2, $24, $a3, $20
	db $aa, $20, $28, $2e, $a3, $38, $aa, $20, $20, $20, $a3, $2a, $aa, $2a, $32, $38
	db $a3, $42, $aa, $2a, $2a, $2a, $a3, $1e, $aa, $4a, $4a, $4a, $a3, $4a, $aa, $1e
	db $1e, $1e, $a3, $1e, $aa, $58, $58, $58, $5c, $38, $36, $32, $2e, $2c, $00
;@ path: sound/music/songs
;@ Music track $06: not started by the game.
;@ Entry 6 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music06::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m06Pat17, .pat1, .pat1
.sq1Loop:
	dw MusicCommonData_1B.m06Pat17, .pat2, .pat3, MusicCommonData_1B.m06Pat17, .pat2, MusicCommonData_1B.m06Pat21, MusicCommonData_1B.m02Pat9, .pat2
	dw MusicCommonData_1B.m06Pat18, .pat2, .pat3, MusicCommonData_1B.m02Pat13, MusicCommonData_1B.m06Pat22, MusicCommonData_1B.m06Pat17, .pat2, .pat2
	dw $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m01Pat8, .pat4
.sq2Loop:
	dw MusicCommonData_1B.m06Pat19, .pat5, MusicCommonData_1B.m01Pat8, MusicCommonData_1B.m01Pat8, MusicCommonData_1B.m06Pat20, .pat5, MusicCommonData_1B.m06Pat22, MusicCommonData_1B.m01Pat8
	dw .pat6, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat15, .pat7
.waveLoop:
	dw MusicCommonData_1B.m06Pat16, .pat8, .pat9, MusicCommonData_1B.m01Pat8, MusicCommonData_1B.m06Pat23, MusicCommonData_1B.m06Pat22, .pat9, MusicCommonData_1B.m06Pat22
	dw MusicCommonData_1B.m01Pat8, MusicCommonData_1B.m01Pat8, $FFFF, .waveLoop
.noise: ; noise pattern list
	dw .pat10
.noiseLoop:
	dw .pat11, .pat12, .pat13, .pat12, .pat14, $FFFF, .noiseLoop
.pat1:
	db $9d, $33, $00, $80
	db $9b, $04, $a2, $4e, $a1, $4e, $4e, $9c
	db $9b, $04, $a2, $52, $a1, $52, $52, $9c
	db $9b, $04, $a2, $54, $a1, $54, $54, $9c
	db $9b, $04, $a2, $52, $a1, $52, $52, $9c, $00
.pat2:
	db $9b, $04, $a1, $28, $36, $2e, $36, $9c
	db $9b, $04, $28, $3a, $32, $3a, $9c
	db $9b, $04, $28, $3c, $36, $3c, $9c
	db $9b, $04, $28, $3a, $32, $3a, $9c, $00
.pat3:
	db $9b, $04, $20, $36, $2e, $36, $9c
	db $9b, $04, $24, $32, $2c, $32, $9c
	db $9b, $02, $24, $36, $2e, $36, $9c
	db $9b, $02, $28, $3a, $32, $3a, $9c
	db $9b, $04, $2c, $3e, $36, $3e, $9c
	db $9b, $04, $28, $36, $2e, $36, $9c
	db $9b, $04, $2a, $38, $32, $38, $9c
	db $9b, $04, $28, $36, $2e, $36, $9c
	db $9b, $04, $22, $36, $2e, $36, $9c
	db $9b, $04, $2a, $38, $32, $38, $9c, $a1, $36, $40, $44, $4a, $a3, $4e, $a4, $01
	db $9d, $50, $26, $01, $a4, $4e, $4a, $46, $4a, $00
.pat4:
	db $9d, $40, $26, $41, $a3, $40, $a7, $36, $a2, $40, $a1, $40, $44, $46, $4a, $a5
	db $4e, $a3, $58, $a7, $4e, $a2, $58, $a1, $58, $5c, $5e, $62, $a5, $66, $00
.pat5:
	db $a6, $40, $a1, $36, $a7, $36, $a2, $40, $a1, $40, $44, $46, $4a, $a7, $4e, $a1
	db $52, $54, $a6, $52, $4e, $a2, $4a, $a6, $4e, $a1, $40, $a5, $58, $a2, $01, $4e
	db $5e, $5c, $5e, $62, $66, $a1, $58, $66, $a3, $70, $a2, $01, $66, $62, $5e, $62
	db $a1, $54, $62, $a3, $6c, $a2, $01, $62, $5e, $5c, $a6, $5e, $a1, $4e, $a3, $4e
	db $a2, $01, $ad, $4a, $4e, $4a, $a2, $46, $4a, $a5, $4e, $a6, $40, $a1, $36, $a7
	db $36, $a2, $40, $a1, $40, $44, $46, $4a, $a7, $4e, $a1, $50, $54, $a6, $50, $4e
	db $a2, $4a, $a6, $46, $a1, $40, $a7, $4e, $a2, $46, $58, $4e, $a7, $5e, $a2, $5c
	db $58, $5c, $5e, $62, $a2, $66, $a1, $62, $66, $a3, $68, $a2, $01, $a6, $6c, $68
	db $66, $5c, $a2, $5e, $a6, $62, $5e, $a2, $5c, $a5, $58, $70, $00
.pat6:
	db $9d, $56, $00, $80
	db $9b, $04, $a4, $01, $8c, $9c, $00
.pat7:
	db $9b, $1f, $a2, $40, $a1, $40, $40, $9c, $01, $1a, $16, $14, $00
.pat8:
	db $99
	db $9b, $02, $a3, $28, $a4, $28, $a3, $28, $9c, $28, $a4, $28, $a3, $36, $32, $a4
	db $32, $a2, $32, $36, $a3, $38, $a4, $38, $a3, $38, $3c, $a4, $3c, $a3, $3c, $2e
	db $2e, $32, $32, $36, $a4, $36, $a1, $36, $32, $2e, $2c, $a3, $28, $a4, $28, $a3
	db $28, $2a, $a4, $2a, $a3, $2a, $28, $a4, $28, $a3, $24, $22, $a4, $22, $a3, $22
	db $2a, $a4, $2a, $a3, $2a, $36, $01, $01, $9a, $1e, $00
.pat9:
	db $a6, $28, $36, $a2, $28, $a6, $24, $32, $a2, $24, $a6, $20, $2e, $a2, $20, $a6
	db $24, $32, $a2, $24, $00
.pat10:
	db $9b, $1f, $a2, $0b, $a1, $0b, $0b, $9c, $15, $15, $15, $15, $00
.pat11:
	db $9b, $0d, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15
	db $15, $15, $15, $15, $15, $9c, $00
.pat12:
	db $a1, $15, $15, $15, $15, $a3, $15, $a4, $01, $00
.pat13:
	db $9b, $17, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15
	db $15, $15, $15, $15, $15, $9c, $00
.pat14:
	db $9b, $0c, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15, $15, $a2, $15, $a1, $15
	db $15, $15, $15, $15, $15, $9c, $00

;@ path: sound/music/songs
;@ Music track $07: not started by the game.
;@ Entry 7 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music07::
	db $00 ; transpose
	dw NoteLengths160_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m05Pat15, .pat3, $FFFF, .wave
.pat1:
	db $9d, $44, $00, $80, $98
	db $9b, $02, $a3, $01, $a2, $46, $a1, $88, $88, $a3, $01, $a2, $44, $a1, $88, $88
	db $9c
	db $9d, $24, $00, $80, $a3, $01, $a2, $64, $62, $60, $64, $5e, $60, $5c, $60, $5a
	db $5c, $58, $56, $a4, $01, $97, $a1, $88, $88, $00
.pat2:
	db $9d, $50, $84, $00, $a6, $70, $a1, $66, $a2, $60, $58, $a3, $5a, $a1, $68, $62
	db $5a, $50, $a2, $4e, $a1, $66, $60, $a2, $58, $4e, $54, $a1, $50, $54, $a3, $4e
	db $9d, $24, $00, $00, $a2, $4c, $4e, $68, $66, $64, $66, $62, $64, $60, $62, $5e
	db $60, $a1, $5c, $5e, $5a, $5c, $a3, $01, $a7, $01, $00
.pat3:
	db $9b, $02, $99, $a2, $40, $4c, $56, $4c, $36, $4a, $54, $4a, $9c, $a5, $01, $01
	db $a7, $01, $00

;@ path: sound/music/songs
;@ Music track $08: not started by the game.
;@ Entry 8 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music08::
	db $00 ; transpose
	dw NoteLengths112_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m02Pat14, MusicCommonData_1B.m08Pat12, MusicCommonData_1B.m08Pat11, .pat2, MusicCommonData_1B.m08Pat10, .pat2, MusicCommonData_1B.m02Pat13, .pat1
	dw MusicCommonData_1B.m02Pat14, .pat1, MusicCommonData_1B.m06Pat22, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m08Pat11, .pat4, MusicCommonData_1B.m08Pat10, .pat5, .pat3, .pat3, MusicCommonData_1B.m06Pat22, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m01Pat6, MusicCommonData_1B.m06Pat22, .pat6, .pat7, .pat6, .pat7, MusicCommonData_1B.m06Pat22, $FFFF, .wave
.noise: ; noise pattern list
	dw .pat9, .pat8, .pat9, $FFFF, .noise
.pat1:
	db $9d, $33, $00, $80
	db $9b, $04, $a1, $58, $56, $54, $52, $50, $4e, $4c, $4a, $48, $4a, $4c, $4e, $50
	db $52, $54, $56, $9c, $00
.pat2:
	db $9b, $04, $a1, $46, $44, $9c, $00
.pat3:
	db $9d, $40, $81, $80, $a7, $58, $a2, $4e, $58, $5c, $60, $66, $a7, $64, $a2, $66
	db $a4, $68, $a7, $58, $a2, $4e, $58, $5c, $60, $66, $a7, $64, $a2, $66, $a4, $80
	db $00
.pat4:
	db $9b, $0c, $a1, $58, $56, $9c, $00
.pat5:
	db $9b, $04, $a1, $58, $56, $9c, $00
.pat6:
	db $99, $a3, $28, $a2, $36, $a3, $28, $a2, $28, $2a, $38, $a3, $28, $a2, $36, $a3
	db $28, $a2, $28, $24, $26, $00
.pat7:
	db $a3, $28, $a2, $36, $a3, $28, $a2, $28, $2a, $38, $a3, $28, $a2, $36, $a3, $28
	db $a2, $28, $36, $40, $00
.pat8:
	db $9b, $08, $a2, $29, $29, $29, $29, $a3, $ff, $a2, $29, $29, $9c, $00
.pat9:
	db $a3, $29, $a2, $29, $29, $a3, $ff, $a2, $29, $29, $a2, $29, $29, $29, $29, $a3
	db $ff, $a2, $29, $29, $00

;@ path: sound/music/songs
;@ Music track $09: not started by the game.
;@ Entry 9 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music09::
	db $00 ; transpose
	dw NoteLengths160_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m06Pat22
.sq1Loop:
	dw .pat1, .pat1, .pat2, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw .pat3
.sq2Loop:
	dw .pat4, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat22
.waveLoop:
	dw MusicCommonData_1B.m06Pat16, .pat5, .pat6, $FFFF, .waveLoop
.noise: ; noise pattern list
	dw .pat7, $FFFF, .noise
.pat1:
	db $9d, $23, $00, $80
	db $9b, $20, $a0, $5e, $62, $9c
	db $9b, $20, $62, $64, $9c, $00
.pat2:
	db $9b, $20, $5e, $54, $9c
	db $9b, $20, $5c, $52, $9c
	db $9b, $20, $5e, $50, $9c
	db $9b, $20, $5c, $52, $9c, $00
.pat3:
	db $9d, $81, $82, $00, $a2, $10, $1e, $a1, $24, $a2, $26, $a1, $28, $a7, $01, $a1
	db $0c, $0e, $a2, $10, $a1, $1e, $a2, $24, $26, $a1, $28, $a7, $01, $a1, $0c, $0e
	db $00
.pat4:
	db $9d, $40, $00, $81
	db $9b, $02, $a4, $58, $4e, $a8, $4e, $a0, $58, $56, $58, $5c, $5e, $5c, $5e, $62
	db $a6, $66, $68, $a2, $6c, $a8, $70, $a2, $70, $6c, $a6, $68, $62, $a2, $5a, $9c
	db $9d, $30, $00, $01, $a5, $58, $4e, $50, $52, $54, $54, $56, $56, $00
.pat5:
	db $99, $a2, $28, $36, $a1, $3c, $a2, $3e, $a1, $40, $a7, $01, $a1, $24, $26, $a2
	db $28, $a1, $36, $a2, $3c, $3e, $a1, $40, $a7, $01, $a1, $26, $28, $00
.pat6:
	db $a2, $2a, $38, $a1, $3e, $a2, $40, $a1, $42, $a7, $01, $a1, $26, $28, $a2, $2a
	db $a1, $38, $a2, $3e, $40, $a1, $42, $a7, $01, $a1, $24, $26, $00
.pat7:
	db $9b, $04, $a1, $29, $9c, $ff
	db $9b, $05, $29, $9c, $ff
	db $9b, $05, $29, $9c, $00

;@ path: sound/music/songs
;@ Music track $0A: not started by the game.
;@ Entry 10 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0A::
	db $04 ; transpose
	dw NoteLengths128_1B
	dw .sq1, .sq2, MusicSilentChannel_1B, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m0APat2, MusicCommonData_1B.m03Pat5
.sq1Loop:
	dw .pat1, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m0APat3, .pat1, $FFFF, .sq2
.pat1:
	db $a2, $5c, $3c, $4a, $52, $58, $5c, $5e, $40, $4e, $54, $5c, $5e, $62, $44, $52
	db $58, $70, $6c, $62, $36, $44, $4a, $5e, $5c, $5c, $40, $4e, $54, $58, $5c, $5e
	db $40, $4c, $54, $5c, $5e, $58, $32, $40, $46, $4c, $54, $52, $4a, $4e, $52, $54
	db $58, $5c, $3c, $4a, $52, $58, $5c, $5e, $40, $4e, $54, $5c, $5e, $62, $44, $52
	db $58, $74, $70, $70, $36, $44, $6e, $68, $66, $62, $40, $4e, $54, $5e, $5c, $5c
	db $32, $40, $46, $58, $5c, $54, $46, $54, $5c, $5e, $74, $70, $44, $52, $58, $5c
	db $6a, $66, $40, $4e, $54, $58, $66, $64, $32, $40, $46, $4c, $54, $62, $32, $3a
	db $40, $4a, $52, $a3, $62, $a2, $62, $a7, $7a, $32, $00

;@ path: sound/music/songs
;@ Music track $0B: not started by the game.
;@ Entry 11 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0B::
	db $00 ; transpose
	dw NoteLengths160_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m08Pat12
.sq1Loop:
	dw MusicCommonData_1B.m02Pat13, .pat1, MusicCommonData_1B.m02Pat14, .pat1, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m08Pat12
.sq2Loop:
	dw .pat2, .pat2, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1B.m08Pat12
.waveLoop:
	dw MusicCommonData_1B.m01Pat6, .pat3, .pat3, $FFFF, .waveLoop
.noise: ; noise pattern list
	dw .pat4, $FFFF, .noise
.pat1:
	db $9d, $44, $00, $80, $a2, $01, $a1, $36, $36, $a2, $34, $a3, $01, $a1, $36, $36
	db $a2, $38, $a3, $01, $a1, $36, $36, $a2, $34, $a3, $01, $a1, $36, $34, $a2, $36
	db $01, $00
.pat2:
	db $9d, $64, $00, $00
	db $9b, $02, $a2, $40, $36, $a1, $40, $44, $48, $4a, $a2, $4e, $a0, $56, $a1, $58
	db $a0, $01, $a2, $4e, $01, $9c, $00
.pat3:
	db $99, $a2, $28, $a1, $40, $40, $a2, $3e, $a1, $36, $36, $a2, $28, $a1, $40, $40
	db $a2, $42, $a1, $2a, $2a, $a2, $28, $a1, $40, $40, $a2, $3e, $a1, $36, $36, $a2
	db $28, $a1, $40, $3e, $a2, $40, $a1, $28, $28, $00
.pat4:
	db $a2, $29, $a1, $29, $29, $a2, $ff, $a1, $29, $29, $a1, $29, $29, $29, $29, $a2
	db $ff, $1a, $00
;@ path: sound/music/songs
;@ Music track $0C: not started by the game.
;@ Entry 12 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0C::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, MusicCommonData_1B.m0CPat6
.sq1Loop:
	dw MusicCommonData_1B.m02Pat13, .pat2, MusicCommonData_1B.m0CPat4, .pat2, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m0CPat5, MusicCommonData_1B.m02Pat13, .pat2, MusicCommonData_1B.m0CPat4, .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m03Pat5
.waveLoop:
	dw MusicCommonData_1B.m0CPat3, MusicCommonData_1B.m02Pat13, .pat2, MusicCommonData_1B.m0CPat4, .pat2, $FFFF, .waveLoop
.pat1:
	db $9d, $44, $00, $80, $00
.pat2:
	db $a2, $30, $34, $3a, $40, $48, $4c, $52, $58, $60, $64, $6a, $70, $78, $7c, $82
	db $88, $00
;@ path: sound/music/songs
;@ Music track $0D: not started by the game.
;@ Entry 13 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0D::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw Music01.pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw Music01.pat3, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m01Pat6, Music01.pat5, $FFFF, .wave

;@ path: sound/music/songs
;@ Music track $0E: not started by the game.
;@ Entry 14 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0E::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m02Pat13, MusicCommonData_1B.m0EPat6, .pat1, .pat1, MusicCommonData_1B.m0EPat7, .pat1, .pat1, MusicCommonData_1B.m0CPat4
	dw MusicCommonData_1B.m0EPat6, .pat1, .pat1, MusicCommonData_1B.m0EPat7, .pat1, .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat2, .pat3, .pat2, .pat3, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat16, .pat4, .pat4, MusicCommonData_1B.m0EPat5, .pat4, .pat4, $FFFF, .wave
.pat1:
	db $9b, $02, $a2, $1c, $20, $20, $9c, $1c, $20, $00
.pat2:
	db $9d, $70, $21, $40, $a7, $48, $a1, $44, $48, $a7, $4a, $a1, $48, $4a, $a7, $4c
	db $a1, $5c, $58, $a2, $4c, $64, $a3, $64, $00
.pat3:
	db $9d, $20, $21, $81, $a2, $4c, $64, $a8, $64, $a2, $64, $7c, $a8, $7c, $00
.pat4:
	db $99, $a7, $28, $28, $a3, $28, $00

;@ path: sound/music/songs
;@ Music track $0F: not started by the game.
;@ Entry 15 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music0F::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, .pat2, .pat4, $0000
.sq2: ; square 2 pattern list
	dw .pat3, .pat4, .pat2, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat15, MusicCommonData_1B.m0FPat5, .pat4, MusicCommonData_1B.m03Pat5, $0000
.pat1: ; tracks $0F, $3D
	db $9d, $26, $00, $80, $00
.pat2:
	db $a3, $01, $a1, $01, $00
.pat3:
	db $9d, $67, $00, $81, $00
.pat4:
	db $96, $a1, $70, $6e, $66, $60, $58, $56, $4e, $48, $74, $70, $6a, $62, $5c, $58
	db $52, $4a, $78, $74, $6e, $66, $60, $5c, $56, $4e, $7a, $78, $70, $6a, $62, $60
	db $58, $52, $a2, $36, $44, $4a, $4e, $56, $5c, $62, $66, $a8, $7e, $95, $00

;@ path: sound/music/songs
;@ Music track $31: not started by the game.
;@ Entry 17 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music31::
	db $00 ; transpose
	dw NoteLengths96_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, $FFFF, Music05.m31Sq1
.sq2: ; square 2 pattern list
	dw .pat2, $FFFF, Music05.m31Sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m01Pat6, .pat3, $FFFF, Music05.m31Wave
.pat1:
	db $9d, $70, $21, $81, $aa, $01, $36, $40, $a3, $48, $aa, $48, $48, $44, $a3, $48
	db $aa, $01, $3c, $46, $a3, $4e, $aa, $4e, $4e, $4a, $a3, $4e, $a3, $01
	db $9b, $02, $a3, $4c, $a2, $01, $a1, $4c, $4c, $9c, $a8, $4a
	db $9d, $40, $21, $80, $aa, $32, $30, $2c, $00
.pat2:
	db $9d, $90, $21, $81, $aa, $36, $40, $48, $a8, $4e, $aa, $3c, $46, $4e, $a8, $54
	db $aa, $4e, $54, $5e
	db $9b, $02, $a3, $5a, $a2, $01, $a1, $5a, $5a, $9c, $a8, $5c
	db $9d, $60, $21, $80, $aa, $44, $40, $3e, $00
.pat3:
	db $99, $aa, $01, $01, $4e, $9a, $a3, $58, $99, $aa, $40, $40, $3c, $9a, $a3, $40
	db $99, $aa, $01, $01, $54, $9a, $a3, $5e, $99, $aa, $46, $46, $42, $9a, $a3, $46
	db $01, $99, $aa, $2a, $28, $2a, $34, $32, $34, $3c, $3a, $3c, $42, $4c, $54, $56
	db $52, $56, $58, $56, $52, $a3, $4e, $aa, $1e, $1e, $1e, $00

;@ path: sound/music/songs
;@ Music track $32: not started by the game.
;@ Entry 18 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music32::
	db $00 ; transpose
	dw NoteLengths128_1B
	dw .sq1, .sq2, MusicSilentChannel_1B, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m32Pat3, .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m32Pat4, .pat2, $FFFF, .sq2
.pat1:
	db $a2, $32, $3a, $40, $3a, $32, $36, $3e, $44, $30, $36, $3e, $44, $22, $28, $30
	db $28, $2c, $32, $3a, $32, $1e, $26, $2c, $26, $28, $2c, $32, $36, $28, $30, $36
	db $3c, $00
.pat2:
	db $a4, $70, $a2, $01, $6e, $74, $a4, $66, $a2, $01, $70, $58, $5c, $60, $62, $60
	db $62, $a3, $56, $6a, $a5, $66, $a2, $01, $00

;@ path: sound/music/songs
;@ Music track $33: not started by the game.
;@ Entry 19 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music33::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, MusicSilentChannel_1B, $0000
.sq1: ; square 1 pattern list
	dw .pat2, .pat3, .pat1, .pat1, .pat2, .pat4, .pat1, .pat1
	dw .pat1, $FFFF, .sq1
.sq2: ; square 2 pattern list
	dw .pat6, .pat7, .pat5, .pat5, .pat6, .pat8, .pat5, .pat5
	dw .pat5, $FFFF, .sq2
.pat1:
	db $9b, $0c, $ad, $01, $01, $01, $01, $9c, $a5, $01, $00
.pat2:
	db $9d, $40, $41, $80
	db $9b, $02, $a3, $28, $32, $32, $9c, $00
.pat3:
	db $a3, $30, $26, $01, $00
.pat4:
	db $a3, $34, $2a, $01, $00
.pat5:
	db $9d, $42, $00, $80
	db $9b, $0c, $ad, $46, $44, $46, $01, $9c, $a5, $01, $00
.pat6:
	db $9d, $40, $41, $80
	db $9b, $02, $a3, $30, $3a, $3a, $9c, $00
.pat7:
	db $a3, $38, $2e, $a3, $01, $00
.pat8:
	db $a3, $3c, $32, $a3, $01, $00

;@ path: sound/music/songs
;@ Music track $34: not started by the game.
;@ Entry 20 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music34::
	db $00 ; transpose
	dw NoteLengths112_1B
	dw MusicSilentChannel_1B, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat2, .pat2, .pat3, MusicCommonData_1B.m0APat3, .pat4, MusicCommonData_1B.m0CPat6, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m34Pat9, .pat5, .pat6, MusicCommonData_1B.m06Pat15, .pat7, .pat8, .pat4, $0000
.pat1:
	db $9d, $43, $00, $80, $a4, $01, $a2, $01, $a1, $78, $74, $a2, $78, $a3, $01, $a1
	db $7a, $78, $a2, $7a, $a3, $01, $01, $00
.pat2:
	db $9d, $55, $00, $00
	db $9e
	dw NoteLengths80_1B
	db $9b, $02, $a1, $66, $68, $66, $64, $62, $64, $62, $64, $9c, $a2, $66, $7e, $66
	db $a1, $66, $68, $6a, $6c, $6a, $68, $a3, $66, $00
.pat3:
	db $9d, $35, $00, $40
	db $9b, $02, $a1, $66, $68, $66, $64, $62, $64, $62, $64, $9c, $a5, $01, $a3, $01
	db $00
.pat4:
	db $9e
	dw NoteLengths96_1B
	db $a0, $7e, $7a, $76, $72, $6e, $6a, $a3, $66, $01, $00
.pat5:
	db $a4, $01, $a2, $01, $99, $a3, $6c, $01, $6e, $01, $01, $00
.pat6:
	db $9e
	dw NoteLengths80_1B
	db $99
	db $9b, $02, $a2, $40, $4e, $36, $4e, $9c
	db $9b, $02, $42, $50, $38, $50, $9c
	db $9b, $02, $46, $54, $3c, $54, $9c, $4a, $58, $40, $58, $4a, $58, $48, $44, $00
.pat7:
	db $9b, $02, $a2, $40, $4e, $36, $4e, $9c, $a5, $01, $a3, $01, $00
.pat8:
	db $9e
	dw NoteLengths96_1B
	db $a1, $01, $00

;@ path: sound/music/songs
;@ Music track $35: not started by the game.
;@ Entry 21 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music35::
	db $00 ; transpose
	dw NoteLengths112_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m35Pat8, .pat1, MusicCommonData_1B.m35Pat9, .pat2, .pat2, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m35Pat8, .pat3, MusicCommonData_1B.m35Pat9, .pat4, .pat4, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m35Pat7, .pat5, .pat6, .pat6, $0000
.pat1:
	db $a4, $01, $a1, $26, $2a, $2e, $30, $34, $01, $34, $01, $a5, $36, $00
.pat2:
	db $a4, $01, $a2, $34, $38, $3c, $3e, $a7, $42, $a2, $46, $42, $3e, $3c, $38, $a4
	db $34, $a2, $3c, $3e, $42, $4c, $a7, $54, $a2, $56, $54, $50, $4c, $4a, $a7, $4c
	db $a1, $42, $42
	db $9b, $02, $a2, $4c, $a1, $42, $42, $9c, $a5, $4c, $00
.pat3:
	db $a5, $01, $a1, $40, $44, $48, $4a, $4e, $01, $4e, $01, $a4, $50, $00
.pat4:
	db $a5, $01, $a2, $4e, $52, $56, $58, $a7, $5c, $a2, $60, $5c, $58, $56, $52, $a4
	db $4e, $a2, $56, $58, $5c, $66, $a7, $6e, $a2, $70, $6e, $6a, $66, $64, $a7, $66
	db $a1, $5c, $5c
	db $9b, $02, $a2, $66, $a1, $5c, $5c, $9c, $a4, $66, $00
.pat5:
	db $9a, $a1, $24, $28, $2c, $2e, $32, $01, $32, $01, $ae, $34, $00
.pat6:
	db $a2, $32, $36, $3a, $3c, $a7, $40, $a2, $44, $40, $3c, $3a, $36, $a4, $32, $a2
	db $3a, $3c, $40, $4a, $a7, $52, $a2, $54, $52, $4e, $4a, $48, $a3, $4a, $a2, $01
	db $99, $a1, $40, $40
	db $9b, $02, $a2, $4a, $a1, $40, $40, $9c, $9a, $ae, $4a, $00

;@ path: sound/music/songs
;@ Music track $36: not started by the game.
;@ Entry 22 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music36::
	db $00 ; transpose
	dw NoteLengths112_1B
	dw MusicSilentChannel_1B, .sq2, .wave, $0000
.sq2: ; square 2 pattern list
	dw .pat1, .pat2, MusicCommonData_1B.m06Pat19, .pat2, .pat3, MusicCommonData_1B.m32Pat3, .pat4, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat15, .pat5, MusicCommonData_1B.m34Pat9, .pat5, .pat6, MusicCommonData_1B.m06Pat15, .pat7, $0000
.pat1:
	db $9d, $40, $26, $01, $00
.pat2:
	db $a1, $90, $a6, $90, $a1, $88, $a6, $88, $a1, $7e, $a6, $7e, $a1, $88, $a6, $88
	db $00
.pat3:
	db $a6, $4e, $a1, $4e, $a3, $48, $a6, $4a, $a1, $4a, $a3, $42, $a1, $4e, $a2, $4e
	db $a1, $52, $4e, $48, $40, $48, $a2, $4a, $90, $a3, $90, $a6, $4e, $a1, $4e, $a3
	db $48, $a6, $58, $a1, $58, $a3, $50, $a1, $4e, $a2, $4e, $a1, $52, $a2, $4e, $a1
	db $58, $60, $a2, $62, $90, $a3, $90, $00
.pat4:
	db $a6, $4e, $a1, $4e, $a3, $48, $a6, $4a, $a1, $4a, $a3, $42, $00
.pat5:
	db $99, $a1, $8e, $a6, $8e, $a1, $86, $a6, $86, $a1, $7c, $a6, $7c, $a1, $86, $a6
	db $86, $00
.pat6:
	db $9b, $02, $a2, $28, $a1, $30, $36, $a2, $1e, $a1, $30, $36, $a2, $2a, $a1, $32
	db $38, $a2, $20, $a1, $32, $38, $a2, $28, $a1, $30, $36, $a2, $1e, $a1, $30, $36
	db $a2, $2a, $8e, $8e, $1e, $9c, $00
.pat7:
	db $a2, $28, $a1, $30, $36, $a2, $1e, $a1, $30, $36, $a2, $2a, $a1, $32, $38, $a2
	db $20, $a1, $32, $38, $00

;@ path: sound/music/songs
;@ Music track $39: not started by the game.
;@ Entry 25 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music39::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m01Pat8, MusicCommonData_1B.m08Pat10, .pat1, MusicCommonData_1B.m39Pat14, .pat2
.sq1Loop:
	dw MusicCommonData_1B.m0EPat6, MusicCommonData_1B.m02Pat13, .pat3, MusicCommonData_1B.m39Pat17, MusicCommonData_1B.m06Pat21, .pat3, $FFFF, .sq1Loop
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m08Pat10, .pat4, .pat5, MusicCommonData_1B.m39Pat14, .pat6
.sq2Loop:
	dw MusicCommonData_1B.m39Pat15, .pat7, MusicCommonData_1B.m39Pat16, .pat7, $FFFF, .sq2Loop
.wave: ; wave pattern list
	dw MusicCommonData_1B.m05Pat15, .pat8, MusicCommonData_1B.m06Pat22, MusicCommonData_1B.m01Pat6, .pat9
.waveLoop:
	dw MusicCommonData_1B.m01Pat6, .pat10, .pat10, $FFFF, .waveLoop
.noise: ; noise pattern list
	dw .pat11, .pat12
.noiseLoop:
	dw .pat13, $FFFF, .noiseLoop
.pat1:
	db $a8, $01, $a1, $46, $48, $5e, $60, $a8, $01, $a1, $48, $4a, $60, $62, $a8, $01
	db $00
.pat2:
	db $9b, $05, $a1, $70, $72, $70, $6e, $9c, $70, $6e, $6c, $6a, $68, $66, $64, $62
	db $60, $5e, $5c, $5a, $00
.pat3:
	db $9b, $04, $a2, $50, $4a, $4a, $50, $4a, $4a, $50, $4a, $50, $4a, $9c, $00
.pat4:
	db $a5, $01
	db $9b, $08, $a1, $1e, $20, $9c, $a3, $1e, $ae, $01, $a5, $01, $00
.pat5:
	db $a1, $52, $54, $6a, $6c, $a8, $01, $a1, $54, $56, $6c, $6e, $a8, $01, $00
.pat6:
	db $9b, $05, $a1, $58, $5a, $58, $56, $9c, $58, $56, $54, $52, $50, $4e, $4c, $4a
	db $48, $46, $44, $42, $00
.pat7:
	db $9b, $04, $a2, $58, $01, $01, $56, $01, $01, $58, $01, $5a, $01, $9c, $00
.pat8:
	db $9a
	db $9b, $10, $a1, $28, $2a, $9c, $99, $a3, $2c, $ae, $01, $a5, $01, $00
.pat9:
	db $a5, $01, $99
	db $9b, $04, $a2, $40, $9c, $28, $28, $a1, $28, $28, $2a, $28, $00
.pat10:
	db $99
	db $9b, $04, $a1, $4a, $4a, $32, $32, $a2, $32, $a1, $4a, $4a, $32, $32, $a2, $32
	db $a1, $4a, $4a, $32, $32, $4a, $4a, $32, $32, $9c, $00
.pat11:
	db $9b, $04, $a5, $01, $9c, $a8, $01, $00
.pat12:
	db $9b, $04, $a5, $01, $9c, $00
.pat13:
	db $9b, $02, $a1, $15, $15, $15, $15, $a2, $01, $9c
	db $9b, $08, $a1, $15, $9c, $00

;@ path: sound/music/songs
;@ Music track $3A: not started by the game.
;@ Entry 26 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3A::
	db $00 ; transpose
	dw NoteLengths144_1B
	dw MusicSilentChannel_1B, .sq2, .wave, .noise
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m32Pat3, .pat1, .pat2, $FFFF, .sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat16, .pat3, $FFFF, .wave
.noise: ; noise pattern list
	dw .pat4, $FFFF, .noise
.pat1:
	db $a4, $01, $a7, $01, $ad, $5a, $5e, $5a, $a3, $58, $01, $a7, $01, $a1, $4a, $54
	db $a3, $4e, $01, $a7, $01, $ad, $42, $46, $42, $a3, $40, $01, $a7, $01, $00
.pat2:
	db $9d, $40, $21, $01, $ad, $4e, $50, $52, $a6, $54, $a1, $48, $a7, $54, $ad, $52
	db $54, $52, $a2, $4e, $4a, $a6, $4e, $a1, $40, $a4, $4e, $a2, $01, $ad, $4e, $50
	db $52, $a6, $54, $a1, $48, $a7, $54, $ad, $52, $54, $52, $a2, $4e, $4a, $a6, $4e
	db $a1, $40, $a8, $4e, $00
.pat3:
	db $99
	db $9b, $04, $a6, $28, $a1, $30, $a2, $36, $28, $2a, $32, $a3, $38, $a6, $28, $a1
	db $30, $a2, $36, $28, $1e, $2a, $a3, $32, $9c, $00
.pat4:
	db $9b, $03, $a2, $15, $ad, $15, $15, $15, $9c
	db $9b, $04, $a1, $15, $9c, $00

;@ path: sound/music/songs
;@ Music track $3B: not started by the game.
;@ Entry 27 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3B::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m39Pat15, .pat1, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m39Pat15, .pat2, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat16, .pat3, $0000
.pat1:
	db $a2, $52, $54, $56, $a8, $58, $00
.pat2:
	db $a2, $5c, $5e, $60, $a8, $62, $00
.pat3:
	db $99, $a2, $30, $32, $34, $9a, $a8, $36, $00

;@ path: sound/music/songs
;@ Music track $3D: not started by the game.
;@ Entry 29 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3D::
	db $00 ; transpose
	dw NoteLengths128_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m3DPat54, MusicCommonData_1B.m3DPat53, .pat1, .pat2, .pat3, .pat4, .pat5, MusicCommonData_1B.m3DPat59
	dw .pat6, .pat7, .pat8, MusicCommonData_1B.m3DPat57, MusicCommonData_1B.m3DPat58, MusicCommonData_1B.m06Pat22, .pat9, .pat10
	dw .pat10, .pat11, .pat10, .pat10, .pat11, .pat10, .pat10, .pat12
	dw .pat13, MusicCommonData_1B.m3DPat59, .pat14, MusicCommonData_1B.m3DPat60, .pat15, $0000
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m3DPat54, MusicCommonData_1B.m3DPat50, .pat16, MusicCommonData_1B.m3DPat49, .pat17, MusicCommonData_1B.m3DPat52, .pat16, MusicCommonData_1B.m3DPat48
	dw .pat18, .pat19, MusicCommonData_1B.m3DPat51, .pat20, MusicCommonData_1B.m3DPat59, .pat21, Music0F.pat1, MusicCommonData_1B.m0CPat6
	dw .pat8, MusicCommonData_1B.m03Pat5, MusicCommonData_1B.m3DPat58, MusicCommonData_1B.m06Pat22, .pat22, .pat23, .pat23, .pat24
	dw .pat23, .pat23, .pat24, .pat23, .pat23, .pat25, .pat26, MusicCommonData_1B.m3DPat59
	dw .pat27, MusicCommonData_1B.m3DPat60, .pat28, $0000
.wave: ; wave pattern list
	dw MusicCommonData_1B.m3DPat54, MusicCommonData_1B.m03Pat5, .pat29, .pat16, .pat30, .pat17, .pat31, MusicCommonData_1B.m06Pat15
	dw .pat2, .pat3, MusicCommonData_1B.m08Pat12, .pat32, .pat33, MusicCommonData_1B.m3DPat59, .pat34, MusicCommonData_1B.m06Pat15
	dw MusicCommonData_1B.m0FPat5, .pat8, MusicCommonData_1B.m3DPat56, MusicCommonData_1B.m3DPat58, MusicCommonData_1B.m06Pat22, .pat35, .pat36, .pat36
	dw .pat37, .pat36, .pat36, .pat37, .pat36, .pat36, .pat38, .pat39
	dw MusicCommonData_1B.m3DPat59, .pat40, MusicCommonData_1B.m3DPat60, .pat41, $0000
.noise: ; noise pattern list
	dw MusicCommonData_1B.m3DPat55, .pat42, MusicCommonData_1B.m3DPat59, .pat43, MusicCommonData_1B.m3DPat58, .pat44, .pat44, .pat44
	dw .pat44, .pat44, .pat44, .pat44, .pat44, .pat44, .pat44, .pat44
	dw .pat45, .pat45, .pat44, .pat44, .pat44, .pat44, .pat44, .pat44
	dw .pat44, .pat44, .pat45, .pat45, .pat44, .pat44, .pat44, .pat44
	dw .pat44, .pat44, .pat44, .pat44, .pat44, .pat46, MusicCommonData_1B.m3DPat59, .pat46
	dw .pat46, MusicCommonData_1B.m3DPat60, .pat47, $0000
.pat1:
	db $9d, $56, $00, $80, $00
.pat2:
	db $a1, $30, $3e, $44, $4c, $4e, $56, $5c, $64, $66, $64, $5c, $56, $4e, $4c, $44
	db $3e, $00
.pat3:
	db $a1, $40, $44, $48, $4e, $58, $5c, $60, $66, $70, $66, $60, $5c, $58, $4e, $48
	db $44, $40, $44, $48, $4e, $58, $5c, $60, $66, $a3, $70, $01, $00
.pat4:
	db $9d, $42, $00, $80, $a1, $36, $34, $36, $2c, $30, $34, $36, $3a, $3e, $3a, $3e
	db $36, $3a, $3e, $40, $44
	db $9d, $52, $00, $80, $4e, $4c, $4e, $44, $56, $52, $56, $4e
	db $9d, $62, $00, $80, $5c, $56, $4e, $66, $64, $5e, $56, $52, $a3, $4e, $00
.pat5:
	db $9d, $60, $21, $80, $a3, $52, $4e, $5c, $a7, $5c, $a3, $60, $a2, $5c, $58, $52
	db $a3, $56, $a2, $01, $58, $56, $52, $4e, $5c, $a3, $58, $a4, $01, $00
.pat6:
	db $9d, $52, $00, $80, $a3, $01
	db $9b, $02, $a1, $44, $4a, $52, $58, $60, $58, $52, $4a, $9c
	db $9b, $02, $36, $3e, $44, $4a, $52, $4a, $44, $3e, $9c, $40, $44, $48, $4e, $58
	db $4e, $48, $44, $40, $44, $48, $4e, $58, $4e, $48, $40, $3e, $42, $46, $4c, $56
	db $5a, $5e, $64, $6e, $64, $5e, $5a, $56, $4c, $46, $3e, $00
.pat7:
	db $9d, $47, $00, $80, $00
.pat8:
	db $a1, $1e, $22, $26, $2c, $32, $3a, $3e, $44, $4a, $52, $56, $5c, $62, $6a, $6e
	db $74, $a4, $7e, $00
.pat9:
	db $9d, $52, $00, $80, $a4, $01, $a3, $1e, $aa, $1e, $1e, $1e
	db $9d, $72, $00, $80, $a3, $22
	db $9b, $06, $aa, $22, $9c, $28, $28, $28
	db $9d, $92, $00, $80, $a3, $2c, $aa, $2c, $2c, $2c, $a3, $32, $aa, $32, $32, $3a
	db $a3, $3e, $aa, $36, $36, $36, $a3, $36
	db $9d, $92, $00, $40, $aa, $36, $3a, $3e, $00
.pat10:
	db $9d, $90, $21, $41, $a3, $30, $aa, $32, $30, $2c, $30, $01, $30, $32, $36, $3a
	db $a3, $3c, $aa, $44, $48, $44, $a3, $42, $aa, $3a, $3e, $42, $a3, $44, $aa, $5c
	db $62, $6a, $70, $38, $3c, $40, $3c, $38, $a3, $36, $aa, $36, $3a, $36, $a3, $32
	db $01
	db $9d, $77, $00, $80
	db $9b, $02, $aa, $52, $56, $58, $9c, $56, $4e, $48, $a3, $4e, $aa, $52, $56, $58
	db $58, $5c, $58, $56, $4e, $48, $a3, $4e
	db $9d, $70, $21, $41, $aa, $4a, $4e, $52, $52, $52, $52, $a3, $50, $aa, $50, $54
	db $50, $a3, $4e, $aa, $4e, $52, $4e, $a4, $4a, $00
.pat11:
	db $9d, $70, $00, $81, $a5, $01, $01, $a8, $4a, $aa, $4a, $4e, $4a, $a4, $48, $a3
	db $4a, $4e
	db $9d, $90, $26, $80, $aa, $50, $01, $54, $a4, $58, $aa, $50, $54, $58, $a8, $58
	db $aa, $58, $58, $58
	db $9b, $02, $01, $50, $50, $50, $4e, $50, $9c, $a3, $4e
	db $9d, $70, $21, $40, $aa, $3a, $01, $3a, $36, $01, $36, $32, $01, $32, $00
.pat12:
	db $9d, $80, $21, $41, $aa, $46, $44, $46, $4a, $46, $44
	db $9b, $04, $46, $9c, $44, $46, $4a, $46, $4a, $50, $5a, $62, $68, $5a, $5a, $62
	db $62, $62, $a3, $60, $00
.pat13:
	db $9d, $70, $21, $41, $a2, $48, $a1, $48, $48, $a3, $44, $a2, $44, $a1, $46, $4a
	db $00
.pat14:
	db $9d, $70, $21, $41, $a3, $50, $a2, $50, $a1, $50, $50, $a2, $5c, $58, $a3, $54
	db $a3, $60, $a2, $60, $a1, $5c, $60, $a2, $62, $66, $68, $62, $00
.pat15:
	db $a3, $66
	db $9d, $a0, $21, $40, $a2, $28, $a1, $28, $28, $a3, $28, $01, $00
.pat16:
	db $a2, $01, $60, $64, $a8, $66, $a2, $60, $64, $a8, $66, $a2, $64, $60, $56, $a7
	db $5c, $a5, $60, $a3, $01, $00
.pat17:
	db $a2, $60, $64, $a8, $66, $a2, $5c, $66, $a8, $70, $a2, $6e, $6a, $a5, $6e, $a4
	db $01, $a2, $01, $00
.pat18:
	db $a2, $60, $64, $a8, $66, $a2, $5c, $66, $a8, $70, $a2, $6e, $6a
	db $9d, $50, $00, $80, $6e, $00
.pat19:
	db $a5, $6e, $a4, $01, $00
.pat20:
	db $a8, $01, $a3, $7c, $78, $6e, $a7, $6e, $a5, $70, $a2, $82, $7e, $7c, $78, $6e
	db $6a, $6e, $78, $70, $a3, $01, $00
.pat21:
	db $a2, $70, $a4, $74, $a2, $01, $62, $6a, $74, $a8, $6e, $a2, $01, $66, $a5, $78
	db $a2, $01, $a7, $76, $88
	db $9d, $60, $00, $80, $a4, $86, $00
.pat22:
	db $9d, $62, $21, $80, $a3, $01, $01, $26, $aa, $26, $26, $26
	db $9d, $82, $21, $80, $a3, $28, $aa, $28, $28, $28, $32, $32, $32, $3a, $3a, $3a
	db $9d, $a2, $21, $80, $a3, $3e, $aa, $3e, $3e, $3e, $a3, $40, $aa, $40, $40, $40
	db $a3, $44, $aa, $4e, $4e, $4e, $a3, $4e, $aa, $4e, $4e, $4e, $00
.pat23:
	db $9d, $a0, $21, $41, $a3, $40, $36, $aa, $36, $01, $40, $44, $48, $4a, $a4, $4e
	db $aa, $01, $4e, $52, $54, $52, $4e, $a4, $4a, $aa, $01, $4a, $4e, $50, $4e, $4a
	db $a3, $48, $aa, $48, $4a, $48, $a3, $44
	db $9d, $57, $00, $80, $aa, $01, $70, $74
	db $9b, $02, $a3, $78, $70, $a4, $7e, $9c
	db $9d, $a0, $21, $41, $aa, $52, $56, $58, $58, $5c, $60, $a3, $62, $aa, $62, $66
	db $62, $a3, $60, $aa, $60, $62, $60, $a4, $5c, $00
.pat24:
	db $9d, $a0, $26, $81, $aa, $58, $01, $5c, $a4, $5e, $aa, $58, $01, $5c, $a3, $5e
	db $aa, $01, $01, $5e, $a6, $5c, $58, $a2, $4e, $a4, $54, $ae, $58, $aa, $58, $01
	db $5c, $a4, $5e, $aa, $58, $5c, $5e, $a8, $68, $aa, $68, $66, $5e, $a5, $62, $a3
	db $62
	db $9d, $a0, $21, $40, $aa, $4a, $4e, $4a, $48, $4a, $48, $44, $48, $44, $00
.pat25:
	db $9d, $a0, $21, $41, $a4, $58, $aa, $01, $58, $58, $58, $54, $58, $a4, $5a, $aa
	db $01, $5e, $62, $66, $68, $6c, $a3, $70, $00
.pat26:
	db $9d, $a0, $21, $00, $a2, $58, $a1, $4e, $58, $a3, $54, $a2, $54, $a1, $58, $5c
	db $00
.pat27:
	db $a3, $5e, $a2, $5e, $a1, $58, $5e, $a3, $62, $a1, $62, $66, $68, $6c
	db $9d, $a0, $00, $01, $a5, $70, $00
.pat28:
	db $9d, $a0, $21, $00, $a3, $78, $a2, $40, $a1, $40, $40, $a3, $40, $01, $00
.pat29:
	db $9d
	dw MusicCommonData_1B.waveform11
	db $20, $00
.pat30:
	db $9d
	dw MusicCommonData_1B.waveform10
	db $40, $00
.pat31:
	db $9b, $03, $a5, $01, $9c, $a3, $01, $a6, $01, $00
.pat32:
	db $a8, $01, $a2, $01, $00
.pat33:
	db $9d
	dw MusicCommonData_1B.waveform5
	db $20, $99, $a2, $48, $56, $5c, $66, $a4, $01, $a2, $3a, $48, $4e, $58, $01, $56
	db $a1, $52, $4e, $4c, $3e, $a2, $48, $56, $5c, $66, $a4, $01, $a2, $3a, $48, $4e
	db $58, $a3, $01, $00
.pat34:
	db $a3, $01
	db $9b, $02, $a2, $2c, $a3, $2c, $a2, $2c, $9c
	db $9b, $02, $a2, $1e, $a3, $1e, $a2, $1e, $9c
	db $9b, $02, $a2, $28, $a3, $28, $a2, $28, $9c
	db $9b, $02, $a2, $26, $a3, $26, $a2, $26, $9c, $00
.pat35:
	db $9d
	dw MusicCommonData_1B.waveform5
	db $20, $99
	db $9b, $06, $a3, $1e, $aa, $1e, $1e, $1e, $9c, $a3, $1e, $1e, $22, $26, $00
.pat36:
	db $99, $a3, $28, $aa, $28, $28, $24, $a3, $28, $aa, $28, $28, $28, $a3, $24, $aa
	db $3c, $3c, $3c, $9a, $a3, $3a, $22, $99
	db $9b, $02, $a3, $2c, $aa, $2c, $2c, $2c, $9c, $a3, $1e, $aa, $1e, $1e, $1e, $9a
	db $a3, $1e, $20, $99, $aa, $22, $40, $48, $52, $48, $40, $30, $3e, $44, $4e, $44
	db $3e, $3a, $40, $48, $52, $48, $40, $30, $3e, $44, $4e, $44, $30, $a3, $32, $aa
	db $32, $32, $32, $a3, $2a, $aa, $2a, $2a, $2a, $1e, $28, $2c, $36, $40, $44, $4e
	db $36, $3a, $3e, $3a, $36, $00
.pat37:
	db $38, $58, $5e, $68, $5e, $58, $50, $58, $5e, $68, $5e, $58
	db $9b, $02, $50, $54, $5c, $62, $5c, $54, $9c
	db $9b, $02, $4e, $54, $5c, $62, $5c, $54, $9c, $40, $48, $4e, $54, $4e, $48, $40
	db $48, $4e, $54, $4e, $40
	db $9b, $02, $99, $aa, $32, $40, $46, $50, $58, $5e, $9a, $a3, $68, $01, $9c, $99
	db $9b, $02, $aa, $2a, $42, $42, $42, $46, $4a, $9c, $a3, $4e, $1e, $22, $26, $00
.pat38:
	db $38, $40, $46, $50, $58, $5e, $9a, $a3, $68, $99, $aa, $38, $38, $38, $2a, $32
	db $38, $42, $4a, $50, $9a, $a3, $72, $99, $aa, $2a, $2a, $2a, $00
.pat39:
	db $9b, $02, $a2, $28, $1e, $9c
	db $9b, $02, $24, $1a, $9c, $00
.pat40:
	db $9b, $02, $a2, $20, $2e, $9c
	db $9b, $02, $24, $32, $9c
	db $9b, $02, $28, $1e, $9c
	db $9b, $02, $2a, $20, $9c, $00
.pat41:
	db $a3, $28, $a2, $28, $a1, $28, $28, $a3, $28, $01, $00
.pat42:
	db $9b, $14, $a5, $01, $9c, $a3, $01, $00
.pat43:
	db $9b, $06, $a5, $01, $9c, $a3, $01, $00
.pat44:
	db $9b, $03, $a3, $15, $aa, $1a, $1a, $1a, $9c, $aa, $15, $15, $15, $1a, $15, $15
	db $00
.pat45:
	db $9b, $08, $aa, $29, $29, $29, $1a, $29, $29, $9c, $00
.pat46:
	db $9b, $02, $a1, $1a, $1a, $a3, $1a, $9c
	db $9b, $04, $a1, $1a, $9c, $00
.pat47:
	db $a3, $1a, $a2, $1a, $a1, $1a, $1a, $a3, $1a, $01, $00

;@ path: sound/music/songs
;@ Music track $3E: not started by the game.
;@ Entry 30 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3E::
	db $00 ; transpose
	dw NoteLengths80_1B
	dw .sq1, .sq2, .wave, $0000
.sq1: ; square 1 pattern list
	dw .pat1, .pat2, .pat2, MusicCommonData_1B.m35Pat8, .pat2, MusicCommonData_1B.m3EPat4, .pat2, $FFFF, Music0E.sq1
.sq2: ; square 2 pattern list
	dw .pat1, .pat3, .pat3, MusicCommonData_1B.m35Pat8, .pat3, MusicCommonData_1B.m3EPat4, .pat3, $FFFF, Music0E.sq2
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat22, $FFFF, Music0E.wave
.pat1:
	db $9d, $40, $00, $40, $00
.pat2:
	db $a1, $34, $36, $34, $32, $30, $2e, $30, $32, $00
.pat3:
	db $a1, $48, $4a, $48, $46, $44, $42, $44, $46, $00

;@ path: sound/music/songs
;@ Music track $3F: not started by the game.
;@ Entry 31 of SongTable_1B. Header (11 bytes): transpose, note length table, the pattern list of each channel (square 1, square 2, wave, noise; 0 = silent); then the lists and patterns (format: see ReadPattern_1B).
Music3F::
	db $00 ; transpose
	dw NoteLengths112_1B
	dw .sq1, .sq2, .wave, .noise
.sq1: ; square 1 pattern list
	dw MusicCommonData_1B.m06Pat22, .pat1, .pat15, MusicCommonData_1B.m3FPat30, MusicCommonData_1B.m3FPat25, .pat2, MusicCommonData_1B.m3FPat26, .pat3
	dw MusicCommonData_1B.m3FPat24, .pat4, .pat5, .pat11, .pat12, .pat13, $FFFF, MusicCommonData_1B.m3FSq1
.sq2: ; square 2 pattern list
	dw MusicCommonData_1B.m06Pat22, .pat6, .pat15, MusicCommonData_1B.m3FPat30, MusicCommonData_1B.m3FPat23, .pat7, MusicCommonData_1B.m3FPat27, .pat8
	dw MusicCommonData_1B.m0FPat5, .pat14, .pat9, .pat10, .pat11, MusicCommonData_1B.m0FPat5, .pat12, .pat13
	dw $FFFF, MusicCommonData_1B.m3FSq1
.wave: ; wave pattern list
	dw MusicCommonData_1B.m06Pat22, MusicCommonData_1B.m3FPat28, .pat15, MusicCommonData_1B.m0FPat5, MusicCommonData_1B.m3FPat30, MusicCommonData_1B.m3FPat29, .pat16, .pat17
	dw MusicCommonData_1B.m06Pat15, .pat9, .pat10, .pat11, MusicCommonData_1B.m3FPat30, .pat13, $FFFF, MusicCommonData_1B.m3FSq1
.noise: ; noise pattern list
	dw .pat18, .pat19, .pat19, .pat19, .pat19, .pat20, .pat20, .pat20
	dw .pat20, .pat20, .pat20, .pat21, .pat22, $FFFF, MusicCommonData_1B.m3FNoise
.pat1:
	db $9d, $10, $00, $81, $a2, $01, $00
.pat2:
	db $a4, $90, $82, $86, $78, $00
.pat3:
	db $a4, $90, $82, $86, $01, $00
.pat4:
	db $9d, $b1, $82, $00, $a2, $10, $10
	db $9d, $71, $82, $80, $a1, $6e, $60, $6e, $78, $a3, $01
	db $9d, $b1, $82, $00, $a2, $01, $06, $10, $10
	db $9d, $71, $82, $80, $a1, $6e, $60, $6e, $78, $a3, $01
	db $9d, $b1, $82, $00, $a2, $01, $10, $18, $18
	db $9d, $71, $82, $80, $a1, $6a, $5c, $6a, $6e, $a3, $01
	db $9d, $b1, $82, $00, $a2, $01, $0e, $18, $18
	db $9d, $71, $82, $80, $a1, $6a, $5c, $6a, $6e
	db $9d, $80, $00, $00, $a3, $18, $14
	db $9d, $a1, $82, $00, $a2, $10, $10, $a4, $01, $a2, $01, $06, $10, $10, $a4, $01
	db $a3, $10
	db $9b, $03, $a2, $06, $06, $a4, $01, $a2, $01, $14, $9c, $00
.pat5:
	db $9d, $26, $00, $00, $a3, $01, $00
.pat6:
	db $9d, $40, $00, $41, $a2, $01, $00
.pat7:
	db $9b, $03, $a5, $01, $9c, $a4, $01, $a2, $01, $48, $4c, $a8, $4e, $a2, $48, $4c
	db $a8, $4e, $a2, $4c, $48, $3e, $a7, $44, $a8, $48, $a2, $01, $a8, $01, $00
.pat8:
	db $9b, $03, $a1, $60, $5c, $58, $4e, $48, $4e, $58, $5c, $9c, $60, $5c, $58, $4e
	db $48, $4e, $58, $60
	db $9b, $02, $5c, $56, $52, $4e, $44, $4e, $52, $56, $9c, $00
.pat9:
	db $9b, $02, $a1, $64, $5c, $56, $4e, $4c, $4e, $56, $5c, $9c, $00
.pat10:
	db $9b, $02, $6a, $64, $5c, $56, $52, $56, $5c, $64, $9c, $00
.pat11:
	db $a1, $06, $14, $1c, $1e, $26, $2c, $34, $36, $3e, $44, $4c, $4e, $56, $5c, $a2
	db $64, $66, $00
.pat12:
	db $9d, $77, $00, $80, $00
.pat13:
	db $a5, $8c, $00
.pat14:
	db $9d, $40, $00, $80, $00
.pat15:
	db $a2, $48, $4c, $a8, $4e, $a2, $48, $4c, $a8, $4e, $a2, $4c, $48, $a6, $3e, $a5
	db $56, $00
.pat16:
	db $9b, $03, $a5, $01, $9c, $a4, $01, $a2, $01, $a2, $36, $3a, $a4, $3e, $a3, $01
	db $a2, $36, $3a, $a4, $3e, $a3, $01, $a2, $3a, $a3, $36, $a7, $34, $a4, $36, $a8
	db $01, $00
.pat17:
	db $a2, $48, $4c, $a4, $4e, $a3, $01, $a2, $48, $4e, $a4, $58, $a3, $01, $a2, $56
	db $52, $a5, $56, $a2, $01, $00
.pat18:
	db $9b, $05, $a5, $01, $9c, $a4, $01, $a2, $01, $a6, $01, $00
.pat19:
	db $9b, $03, $a2, $15, $a9, $15, $ad, $01, $a9, $15, $ad, $01, $a9, $15, $9c
	db $9b, $04, $a1, $15, $9c, $00
.pat20:
	db $a2, $24, $a9, $1a, $ad, $01, $a9, $1a, $ad, $01, $a9, $1a, $a2, $1a, $a9, $1a
	db $ad, $01, $a9, $1a, $ad, $01, $a9, $1a, $a2, $24, $a9, $15, $ad, $01, $a9, $1a
	db $ad, $01, $a9, $1a
	db $9b, $04, $a1, $1a, $9c, $00
.pat21:
	db $a4, $24, $01, $00
.pat22:
	db $9b, $04, $a5, $01, $9c, $a7, $01, $00

;@ path: sound/music/songs
;@ Wave patterns (16 bytes = 32 4-bit samples) and short patterns of several songs of bank $1B, mostly a single instrument change ($9D) or a rest.
MusicCommonData_1B::
.waveform3: ; wave pattern: 32 4-bit samples
	db $66, $66, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00, $00, $00, $00, $00
.waveform4: ; wave pattern: 32 4-bit samples
	db $88, $88, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.waveform5: ; wave pattern: 32 4-bit samples
	db $88, $88, $88, $88, $88, $88, $88, $88, $00, $00, $00, $00, $00, $00, $00, $00
.waveform6: ; wave pattern: 32 4-bit samples
	db $88, $88, $88, $88, $00, $00, $00, $00, $88, $88, $88, $88, $00, $00, $00, $00
.waveform7: ; wave pattern: 32 4-bit samples
	db $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $00, $00, $00, $00, $00, $00, $00, $00
.waveform8: ; wave pattern: 32 4-bit samples
	db $06, $9b, $cd, $de, $ee, $ff, $ff, $fe, $06, $9b, $cd, $de, $ee, $ff, $ff, $fe
.waveform9: ; wave pattern: 32 4-bit samples
	db $7f, $ff, $57, $73, $55, $34, $42, $21, $7f, $ff, $57, $73, $55, $34, $42, $21
.waveform10: ; wave pattern: 32 4-bit samples
	db $33, $33, $33, $33, $00, $00, $00, $00, $33, $33, $33, $33, $00, $00, $00, $00
.waveform11: ; wave pattern: 32 4-bit samples
	db $11, $11, $11, $11, $00, $00, $00, $00, $11, $11, $11, $11, $00, $00, $00, $00
.waveform12: ; wave pattern: 32 4-bit samples
	db $44, $44, $44, $44, $00, $00, $00, $00, $44, $44, $44, $44, $00, $00, $00, $00
.m01Pat6: ; tracks $01, $02, $05, $08, $0B, $0D, $31, $39
	db $9d
	dw .waveform5
	db $20, $00
.m05Pat15: ; tracks $05, $07, $31, $39
	db $9d
	dw .waveform5
	db $40, $00
.m34Pat9: ; tracks $34, $36
	db $9d
	dw .waveform6
	db $21, $00
; (not used by any song)
	db $9d, $52, $6e, $40, $00
.m06Pat15: ; tracks $06, $0F, $34, $36, $3D, $3F
	db $9d
	dw .waveform6
	db $40, $99, $00
.m02Pat8:
	db $9d
	dw MusicCommonData_1B
	db $20, $00
.m01Pat7:
	db $9d
	dw .waveform7
	db $20, $00
.m0CPat3:
	db $9d
	dw .waveform12
	db $40, $99, $00
.m06Pat16: ; tracks $06, $09, $0E, $3A, $3B
	db $9d
	dw .waveform4
	db $21, $00
.m35Pat7:
	db $9d
	dw .waveform4
	db $25, $00
.m0EPat5:
	db $9d
	dw .waveform4
	db $40, $00
.m02Pat9: ; tracks $02, $06
	db $9d, $42, $00, $80, $00
.m02Pat10:
	db $9d, $53, $00, $80, $00
.m02Pat11:
	db $9d, $50, $83, $40, $00
.m02Pat12:
	db $9d, $60, $81, $80, $00
.m0EPat6: ; tracks $0E, $39
	db $9d, $71, $00, $40, $00
.m0EPat7:
	db $9d, $42, $00, $40, $00
.m06Pat17:
	db $9d, $33, $00, $40, $00
.m06Pat18:
	db $9d, $62, $00, $80, $00
.m06Pat19: ; tracks $06, $36
	db $9d, $60, $26, $01, $00
.m06Pat20:
	db $9d, $60, $26, $81, $00
.m08Pat10: ; tracks $08, $39
	db $9d, $40, $00, $80, $00
.m08Pat11:
	db $9d, $20, $00, $80, $00
.m32Pat3: ; tracks $32, $36, $3A
	db $9d, $43, $00, $80, $00
.m32Pat4:
	db $9d, $40, $21, $80, $00
.m35Pat8: ; tracks $35, $3E
	db $9d, $50, $00, $41, $00
.m35Pat9:
	db $9d, $60, $21, $41, $00
.m39Pat14:
	db $9d, $60, $00, $81, $00
.m39Pat15: ; tracks $39, $3B
	db $9d, $90, $21, $41, $00
.m39Pat16:
	db $9d, $b0, $21, $41, $00
.m39Pat17:
	db $9d, $91, $00, $40, $00
.m3DPat48:
	db $9d, $50, $26, $80, $00
.m3DPat49:
	db $9d, $30, $21, $80, $00
.m3DPat50:
	db $9d, $20, $21, $80, $00
.m3DPat51:
	db $9d, $60, $26, $80, $00
.m3DPat52:
	db $9d, $40, $26, $80, $00
.m3EPat4:
	db $9d, $60, $00, $40, $00
.m3FPat23:
	db $9d, $a0, $21, $41, $00
.m3FPat24:
	db $9d, $82, $82, $80, $00
.m3FPat25:
	db $9d, $77, $00, $80, $00
.m3FPat26:
	db $9d, $97, $00, $80, $00
.m3FPat27:
	db $9d, $51, $82, $80, $00
.m3FPat28:
	db $9d
	dw .waveform9
	db $01, $94, $00
.m3FPat29:
	db $9d
	dw .waveform8
	db $01, $94, $00
.m0CPat4: ; tracks $0C, $0E
	db $9f, $fe, $00
.m02Pat13: ; tracks $02, $06, $08, $0B, $0C, $0E, $39
	db $9f, $00, $00
.m06Pat21: ; tracks $06, $39
	db $9f, $02, $00
.m02Pat14: ; tracks $02, $08, $0B
	db $9f, $0a, $00
.m0APat2:
	db $9d, $10, $00, $80, $00
.m0APat3: ; tracks $0A, $34
	db $9d, $37, $00, $80, $00
.m0CPat5:
	db $9d, $43, $83, $80, $00
.m3DPat53:
	db $9b, $0b, $a5, $01, $9c, $a4, $01, $00
; (not used by any song)
	db $9b, $11, $a5, $01, $9c, $00
.m3DPat54:
	db $9b, $09, $a5, $01, $9c, $a4, $01, $00
.m3DPat55:
	db $9b, $09, $a5, $01, $9c, $a4, $01, $00
; (not used by any song)
	db $a5, $01, $01, $00
.m08Pat12: ; tracks $08, $0B, $3D, $3F
	db $a5, $01, $00
.m06Pat22: ; tracks $06, $08, $09, $39, $3D, $3E, $3F
	db $a5, $01, $01, $00
; (not used by any song)
	db $9b, $03, $a5, $01, $9c, $00
.m01Pat8: ; tracks $01, $06, $39
	db $9b, $04, $a5, $01, $9c, $00
.m06Pat23:
	db $9b, $10, $a5, $01, $9c, $00
; (not used by any song)
	db $a8, $01, $00
.m03Pat5: ; tracks $03, $0A, $0C, $0F, $3D
	db $a6, $01, $00
.m3DPat56:
	db $a7, $01, $00
.m0CPat6: ; tracks $0C, $34, $3D
	db $a1, $01, $00
.m0FPat5: ; tracks $0F, $3D, $3F
	db $a2, $01, $00
.m3DPat57:
	db $a4, $01, $00
.m3FPat30:
	db $a3, $01, $00
.m3FPat31:
	db $a5, $01, $00
.m3FSq1: ; square 1 pattern list
	dw .m08Pat12, $FFFF, .m3FSq1
.m3FNoise: ; noise pattern list
	dw .m3FPat31, $FFFF, .m3FNoise
.m3DPat58:
	db $9e
	dw NoteLengths96_1B
	db $00
.m3DPat59:
	db $9e
	dw NoteLengths112_1B
	db $00
.m3DPat60:
	db $9e
	dw NoteLengths144_1B
	db $00
;@ path: data/padding
;@ Unused space of bank $1B, filled with $FF.
Padding_1B_7028::
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
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
