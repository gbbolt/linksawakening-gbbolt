"""Where each music track plays: the overworld rooms and indoor maps of the area music tables, and the routines that
start a track themselves (scenes, bosses, characters, menus)."""
import glob
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _la  # noqa: E402

GROUP = 'sound'
LD_A = re.compile(r'^\s*ld a, \$([0-9a-fA-F]{2})\s*(;.*)?$')
START = re.compile(r'^\s*(?:(?:call|jp|jr)\s+(?:\w+,\s*)?(PlayMusic\w*|PlayRoomMusic\w*|\w*PlayMusic\w*)\b'
                   r'|ld \[(wMusicTrackToPlay|hDefaultMusicTrack|hNextDefaultMusicTrack)\], a)')
LABEL = re.compile(r'^([A-Za-z_]\w*)::')


def starters():
    """track -> [(unit, how)] from `ld a, $NN` right before a call of a music routine or a store to a music
    request byte."""
    import build as engine
    out = {}
    for f in sorted(glob.glob(os.path.join(engine.SRC, '*.asm'))):
        unit, last = None, None
        for line in open(f, encoding='utf-8', errors='replace'):
            m = LABEL.match(line)
            if m:
                unit, last = m.group(1), None
                continue
            m = LD_A.match(line)
            if m:
                last = int(m.group(1), 16)
                continue
            s = line.strip()
            if not s or s.startswith(';') or s.startswith('.'):
                continue
            m = START.match(line)
            if m and last is not None and unit:
                how = m.group(1) or m.group(2)
                lst = out.setdefault(last, [])
                if (unit, how) not in lst:
                    lst.append((unit, how))
            if not s.startswith('ld [') and not s.startswith('ldh ['):
                last = None
    return out


def build(ctx):
    import build as engine
    cfg = json.load(open(os.path.join(engine.SRC, 'sound.json'), encoding='utf-8'))
    names = cfg.get('names', {})
    ow = _la.table(ctx, 'OverworldMusicTracks', 256) or [0] * 256
    ind = _la.table(ctx, 'IndoorMusicTracks', 32) or [0] * 32
    st = starters()
    rows, recs = [], []
    for n in range(1, 0x61):
        name, where = names.get('music %d' % n, ['-', ''])
        rooms = [r for r in range(256) if ow[r] == n]
        maps = [mp for mp in range(32) if ind[mp] == n]
        code = st.get(n, [])
        if not rooms and not maps and not code and name == '-':
            continue
        room_cells = [{'asset': 'ow-room-{:02x}'.format(r), 'text': '{:02X}'.format(r)} for r in rooms[:24]]
        if len(rooms) > 24:
            room_cells.append('... {} rooms'.format(len(rooms)))
        rows.append([_la.music_cell(ctx, n), room_cells or '-',
                     ', '.join('${:02X}'.format(mp) for mp in maps) or '-',
                     [{'text': u, 'code': u} for u, _ in code[:10]] or '-'])
        recs.append({'track': n, 'name': name, 'where': where, 'overworld_rooms': rooms, 'indoor_maps': maps,
                     'started_by': [u for u, _ in code]})
    sfx = []
    for key, v in sorted(names.items()):
        kind, num = key.split()
        sfx.append({'kind': kind, 'number': int(num), 'name': v[0], 'where': v[1] if len(v) > 1 else ''})
    return [{'name': 'music-places', 'type': 'table', 'title': 'Where the music plays', 'unit': 'SelectAreaMusic',
             'subtitle': '{} tracks'.format(len(rows)),
             'columns': ['track', 'overworld rooms', 'indoor maps', 'started by'], 'rows': rows,
             'doc': ['For every music track: the overworld rooms whose entry in OverworldMusicTracks names it, the '
                     'indoor maps whose entry in IndoorMusicTracks names it (both read by SelectAreaMusic when Link '
                     'enters), and the routines that start it themselves - a track number loaded right before '
                     'PlayMusic, PlayRoomMusic or a store to wMusicTrackToPlay / hDefaultMusicTrack / '
                     'hNextDefaultMusicTrack. Click a room number for the room.'],
             'users': ['SelectAreaMusic', 'OverworldMusicTracks', 'IndoorMusicTracks', 'PlayMusic']},
            _la.export(ctx, 'music', 'Music tracks (download)', recs,
                       'Every music track with its name, where the game uses it, the overworld rooms and indoor maps '
                       'that play it and the routines that start it.'),
            _la.export(ctx, 'sounds', 'Music and sound effects (download)', sfx,
                       'Every music track and sound effect number (music, jingle = square-channel effects, wave, '
                       'noise) with its name and where the game uses it.')]
