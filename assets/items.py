"""Link's items and weapons: what each does (the code of its folder), its tables of speeds, offsets, hit boxes and
timings, what the weapons do to each damage class, and the physics of the room objects that decide what bombs,
the hookshot, lifting and walking do with each block."""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _la  # noqa: E402

GROUP = 'items'
PREFIXES = ('item/', 'link/', 'object/physics', 'object/liftable', 'object/lift', 'entity/physics')
DATA = re.compile(r'^\s*(db|dw)\b')
WEAPON_ROWS = ['sword L1', 'sword L1 strong / L2', 'sword L2 strong', 'weapon 3', 'weapon 4', 'arrow', 'hookshot',
               'bomb', 'boomerang', 'magic powder', 'Magic Rod', 'thrown object', 'bomb arrow', 'weapon $0D',
               'weapon $0E', 'weapon $0F']


def is_data(u):
    lines = [x for x in u['body'] if x.strip() and not x.strip().startswith(';')]
    return bool(lines) and all(DATA.match(x) for x in lines)


def values(rom, start, end, limit=96):
    b = rom[start:min(end, start + limit)]
    out = ' '.join('{}'.format(v - 256 if v >= 0x80 else v) for v in b)
    return out + (' ... ({} bytes)'.format(end - start) if end - start > limit else '')


def build(ctx):
    import build as engine
    rom = ctx.rom
    src = _la.Source()
    names = _la.Names(ctx)
    folders = {}
    for n, u in src.units.items():
        if u['path'].startswith(PREFIXES):
            folders.setdefault(u['path'], []).append(n)
    out = []
    # what the weapons do to the damage classes
    wd = _la.table(ctx, 'WeaponDamageTable', 16 * 8) or [0] * 128
    out.append({'name': 'weapon-damage', 'type': 'table', 'title': 'Weapon damage', 'unit': 'WeaponDamageTable',
                'subtitle': '16 weapons x 8 damage classes',
                'columns': ['weapon'] + ['class {}'.format(c) for c in range(8)],
                'rows': [[WEAPON_ROWS[w]] + [effect(wd[8 * w + c]) for c in range(8)] for w in range(16)],
                'doc': ['What each weapon does to an entity of each damage class (WeaponDamageTable; an entity\'s '
                        'class for a weapon comes from EntityDamageClassTable through its health group, see the '
                        'enemies): a number is the health it takes, "kills" takes all of it, "stuns", "burns", '
                        '"fairy" turns the entity into a fairy, "-" does nothing. The strong sword is a spin attack, '
                        'a Pegasus dash or a hit with the Piece of Power active.']})
    # the folders: their code (what the item does) and their tables
    all_rows = []
    for path in sorted(folders):
        code, data = [], []
        for n in folders[path]:
            u = src.units[n]
            if is_data(u):
                try:
                    a = engine.sym_linear(n, ctx.syms)
                except Exception:  # noqa: BLE001
                    a = None
                if a is None:
                    continue
                _, start, end = names.extent(a)
                data.append([{'text': n, 'code': n}, u['doc'] or '-', end - start, values(rom, a, end)])
                all_rows.append({'folder': path, 'label': n, 'bytes': end - start,
                                 'values': [v - 256 if v >= 0x80 else v for v in rom[a:end]], 'doc': u['doc']})
            else:
                code.append([{'text': n, 'code': n}, u['doc'] or '-'])
        sections = []
        if code:
            sections.append({'title': 'What the code does', 'wide': True, 'columns': ['routine', 'description'],
                             'rows': code})
        if data:
            sections.append({'title': 'Tables', 'wide': True,
                             'columns': ['table', 'description', 'bytes', 'values (signed)'], 'rows': data})
        if not sections:
            continue
        out.append({'name': 'items-' + path.replace('/', '-'), 'type': 'card', 'group': {'item': 'items', 'link': 'Link'}.get(path.split('/')[0], 'objects'),
                    'title': path, 'unit': (folders[path] or [None])[0],
                    'subtitle': '{} routine(s), {} table(s)'.format(len(code), len(data)), 'sections': sections,
                    'doc': ['The code and data of the folder {}: each routine with its description and each table '
                            'with its values as signed bytes (speeds and offsets in pixels or sub-pixels per frame, '
                            'in the order the description gives - usually right, left, up, down).'.format(path)],
                    'users': folders[path][:8]})
    # object physics
    ow = _la.table(ctx, 'OverworldObjectPhysics', 256) or [0] * 256
    ind = _la.table(ctx, 'IndoorObjectPhysics', 256) or [0] * 256
    mentions = {}
    for n, u in src.units.items():
        for line in [u['doc']] + [x for x in u['body'] if x.lstrip().startswith(';')]:
            if 'physics' not in line:
                continue
            for mm in re.finditer(r'physics\s+((?:\$[0-9A-Fa-f]{2}(?:\s*-\s*\$[0-9A-Fa-f]{2})?(?:\s*/\s*|\s*,\s*|'
                                  r'\s+or\s+|\s+and\s+)?)+)', line):
                for r in re.finditer(r'\$([0-9A-Fa-f]{2})(?:\s*-\s*\$([0-9A-Fa-f]{2}))?', mm.group(1)):
                    lo = int(r.group(1), 16)
                    hi = int(r.group(2), 16) if r.group(2) else lo
                    for v in range(lo, min(hi, 0xFF) + 1):
                        s = mentions.setdefault(v, [])
                        if n not in s:
                            s.append(n)
    rows, recs = [], []
    for v in sorted(set(ow) | set(ind)):
        o = [i for i in range(256) if ow[i] == v]
        d = [i for i in range(256) if ind[i] == v]
        rows.append(['${:02X}'.format(v), ' '.join('{:02X}'.format(i) for i in o) or '-',
                     ' '.join('{:02X}'.format(i) for i in d) or '-',
                     [{'text': n, 'code': n} for n in mentions.get(v, [])[:6]] or '-'])
        recs.append({'physics': v, 'overworld_objects': o, 'indoor_objects': d, 'code': mentions.get(v, [])})
    out.append({'name': 'object-physics', 'type': 'table', 'title': 'Object physics', 'unit': 'OverworldObjectPhysics',
                'subtitle': '{} kinds'.format(len(rows)),
                'columns': ['physics', 'overworld objects', 'indoor objects', 'code that names it'], 'rows': rows,
                'doc': ['The physics kind of every room object (OverworldObjectPhysics and IndoorObjectPhysics of '
                        'bank $08, read by GetObjectPhysics): $00 is floor, $01 solid, and the other kinds are what '
                        'Link, the entities and the weapons react to - water, pits, ledges, stairs, partial walls, '
                        'bombable walls ($99-$9C, BombBlastObject), hookshot targets ($60), conveyors ($F0-$F7) and '
                        'more. The last column lists the routines and tables whose description names the kind; open '
                        'them for what happens there.']})
    out.append(_la.export(ctx, 'object-physics', 'Object physics (download)', recs,
                          'Every physics kind with the overworld and indoor objects that have it.'))
    out.append(_la.export(ctx, 'item-tables', 'Item and Link tables (download)', all_rows,
                          'Every data table in the item, Link and object-physics folders with its values as signed '
                          'bytes.'))
    return out


def effect(v):
    if v == 0 or 0xF0 <= v <= 0xFC:
        return '-'
    return {0x40: 'kills', 0xFD: 'fairy', 0xFE: 'burns', 0xFF: 'stuns'}.get(v, str(v))
