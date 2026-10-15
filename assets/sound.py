"""The game's music tracks and sound effects: what each one is, where the game uses it, and its code and data."""
import json
import os

GROUP = 'sound'
HERE = os.path.dirname(os.path.abspath(__file__))
KINDS = [('music', 'Music', 'Music', 96),
         ('jingle', 'Square-channel effects', 'Jingle', 65),
         ('wave', 'Wave-channel effects', 'WaveSfx', 35),
         ('noise', 'Noise effects', 'NoiseSfx', 63)]


def code(ctx, label):
    return {'text': label, 'code': label} if label in ctx.syms else '-'


def build(ctx):
    cfg = json.load(open(os.path.join(HERE, '..', 'src', 'sound.json'), encoding='utf-8'))
    names = cfg.get('names', {})
    out = []
    for kind, title, prefix, count in KINDS:
        rows = []
        for n in range(1, count + 1):
            name, where = names.get('%s %d' % (kind, n), ['-', ''])
            if kind == 'music':
                bank = '$1B' if n <= 0x10 or 0x31 <= n <= 0x40 else '$1E'
                rows.append(['$%02X' % n, name, where, bank, code(ctx, 'Music%02X' % n),
                             {'sound': 'music %d' % n}])
            else:
                rows.append(['$%02X' % n, name, where, code(ctx, '%s%02X_Start' % (prefix, n)),
                             code(ctx, '%s%02X_Update' % (prefix, n)), {'sound': '%s %d' % (kind, n)}])
        if kind == 'music':
            cols = ['track', 'name', 'where', 'bank', 'song data', 'play']
            doc = ['Every music request number (wMusicTrackToPlay). Tracks $01-$10 and $31-$40 are played by the '
                   'engine in bank $1B, the others by the one in bank $1E; each song unit gives the format of its '
                   'header, pattern lists and patterns. The name says where the code starts it.']
            unit = 'SongTable_1B'
        else:
            cols = ['effect', 'name', 'where', 'start', 'update', 'play']
            doc = ['Every %s request number: the routine that starts it (from the start table) and the one '
                   'that plays it on each frame; the data unit next to them holds its register records.'
                   % title.lower().rstrip('s')]
            unit = {'jingle': 'JingleStarts', 'wave': 'WaveSfxStarts', 'noise': 'NoiseSfxStarts'}[kind]
        out.append({'name': 'sound-' + kind, 'type': 'table', 'title': title,
                    'subtitle': '%d %s' % (count, 'tracks' if kind == 'music' else 'effects'),
                    'unit': unit, 'columns': cols, 'rows': rows, 'doc': doc,
                    'users': ['UpdateSoundEffects', 'UpdateJingle', 'UpdateWaveSfx', 'UpdateNoiseSfx']})
    return out
