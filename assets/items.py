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


ITEM_B, INVENTORY = 0xDB00, 0xDB02     # wItemB, wInventoryItems
LEVELS = {0xDB4E: 1, 0xDB44: 1, 0xDB43: 1}   # wSwordLevel, wShieldLevel, wPowerBraceletLevel
COUNTS = {0xDB4D: 0x10, 0xDB45: 0x10, 0xDB4C: 0x10}   # wBombCount, wArrowCount, wMagicPowderCount (BCD)
INVENTORY_ITEMS = {1: 'sword', 2: 'bombs', 3: 'Power Bracelet', 4: 'shield', 5: 'bow', 6: 'hookshot', 7: 'Fire Rod',
                   8: 'Pegasus Boots', 9: 'Ocarina', 0x0A: 'Roc\'s Feather', 0x0B: 'shovel', 0x0C: 'magic powder',
                   0x0D: 'boomerang'}
# folder -> the inventory pictures it gets: ('item', id) | ('toadstool',) | ('instruments',) | ('trade',) |
# ('hearts',) | ('dungeon',) | ('all',)
FOLDER_PICS = {
    'item/sword': [('item', 1)], 'link/sword': [('item', 1)], 'item/bomb': [('item', 2)],
    'link/lift': [('item', 3)], 'link/carry': [('item', 3)], 'item/bow': [('item', 5)],
    'item/hookshot': [('item', 6)], 'item/magic-rod': [('item', 7)], 'link/pegasus_boots': [('item', 8)],
    'link/dash': [('item', 8)], 'item/ocarina': [('item', 9)], 'link/ocarina': [('item', 9)],
    'link/jump': [('item', 0x0A)], 'item/shovel': [('item', 0x0B)], 'item/magic_powder': [('item', 0x0C)],
    'item/boomerang': [('item', 0x0D)], 'item/toadstool': [('toadstool',)], 'item/instrument': [('instruments',)],
    'item/instruments': [('instruments',)], 'item/trade': [('trade',)], 'item/heart-piece': [('hearts',)],
    'item/heart-container': [('hearts',)], 'item/keys': [('dungeon',)], 'item/inventory': [('all',)],
    'link/items': [('all',)], 'item/use': [('all',)], 'link/shield': [('item', 4)],
}


def inventory_pictures(rom):
    """The inventory screen as the game draws it with each item: {key: (picture, caption)}. Every picture is the
    part of the inventory (background only) that changes from the empty inventory of a new game when the item is
    given, so it is the item's own icon with its level or count. Each trade item is taken on its own (one at a time
    in the game)."""
    import pickle
    from _game import START
    world = _la.World(rom)
    m = world.m
    m.run(30)
    start = pickle.dumps(m)

    def shot(pokes, dungeon=False, reload=False, sprites=False):
        mm = pickle.loads(start)
        for a, v in pokes.items():
            mm.mem[a] = v
        if dungeon:
            _la.load_room(mm, True, 0, 0, pos=0x3B, settle=30)        # in Tail Cave: its items show
        elif reload:                    # a room load copies the tiles that go with the items (the trade item's)
            _la.load_room(mm, False, 0, 0xA2, settle=30)
        for a, v in pokes.items():      # again: entering a dungeon copies its saved item flags over them
            mm.mem[a] = v
        mm.press(START, 4, 90)
        return mm.screen(sprites)       # the items are background; the trade item is a sprite (the cursor
        # sprite, which jumps to an item, is left out otherwise)
    base = shot({})
    dbase = shot({}, True)
    rbase = shot({}, reload=True, sprites=True)

    def diff(img, ref, pad=0):
        cells = [(x, y) for y in range(0, 144, 8) for x in range(0, 160, 8)
                 if any(img[y + r][x:x + 8] != ref[y + r][x:x + 8] for r in range(8))]
        if not cells:
            return None
        x0, x1 = min(c[0] for c in cells), max(c[0] for c in cells) + 8
        y0, y1 = min(c[1] for c in cells), max(c[1] for c in cells) + 8
        x0, y0, x1, y1 = max(0, x0 - 8 * pad), max(0, y0 - 8 * pad), min(160, x1 + 8 * pad), min(144, y1 + 8 * pad)
        return [bytearray(img[y][x0:x1]) for y in range(y0, y1)]
    out = {}
    common = {**LEVELS, **COUNTS}
    for it, name in INVENTORY_ITEMS.items():
        p = diff(shot({**common, INVENTORY + 1: it}), base)      # slot 1: the cursor stays on slot 0
        if p:
            out[('item', it)] = (p, 'the {} in the inventory'.format(name))
    p = diff(shot({**common, INVENTORY + 1: 0x0C, 0xDB4B: 1}), base)
    if p:
        out[('toadstool',)] = (p, 'the Sleepy Toadstool in the inventory (in the magic powder\'s place)')
    p = diff(shot({0xDB65 + k: 2 for k in range(8)}), base, 0)
    if p:
        out[('instruments',)] = (p, 'the eight instruments in the inventory')
    trades = []
    for t in range(1, 15):
        p = diff(shot({0xDB0E: t}, reload=True, sprites=True), rbase)
        if p:
            trades.append(p)
    if trades:
        w = sum(len(p[0]) for p in trades) + 2 * (len(trades) - 1)
        h = max(len(p) for p in trades)
        img = [bytearray(w) for _ in range(h)]
        x = 0
        for p in trades:
            for y, row in enumerate(p):
                img[y][x:x + len(row)] = row
            x += len(p[0]) + 2
        out[('trade',)] = (img, 'the {} items of the trading sequence ($01-$0E) in the inventory'.format(len(trades)))
    p = diff(shot({0xDB5C: 3}), base)
    if p:
        out[('hearts',)] = (p, 'three pieces of heart in the inventory')
    p = diff(shot({0xDBCC: 1, 0xDBCD: 1, 0xDBCE: 1, 0xDBCF: 1, 0xDBD0: 3}, True), dbase)
    if p:
        out[('dungeon',)] = (p, 'map, compass, stone beak, nightmare key and 3 small keys in the inventory, in a dungeon')
    full = {**common, ITEM_B: 1, ITEM_B + 1: 4, 0xDB0E: 1, 0xDB5C: 3}
    for k in range(10):
        full[INVENTORY + k] = [2, 3, 5, 6, 7, 8, 9, 0x0A, 0x0B, 0x0C][k]
    for k in range(8):
        full[0xDB65 + k] = 2
    out[('all',)] = ([bytearray(r) for r in shot(full, reload=True, sprites=True)], 'the inventory with every item')
    return out


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
    pics = inventory_pictures(rom)
    from _game import COLORS
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
        images = []
        for key in FOLDER_PICS.get(path, []):
            if key in pics:
                img, cap = pics[key]
                images.append({'type': 'image', 'width': len(img[0]), 'height': len(img), 'packed': 'zlib',
                               'pixels': ctx.packed_pixels(img), 'colors': list(COLORS), 'fixedColors': True,
                               'scale': 3 if len(img[0]) <= 48 else 2, 'caption': cap})
        out.append({'name': 'items-' + path.replace('/', '-'), 'type': 'card', 'images': images, 'group': {'item': 'items', 'link': 'Link'}.get(path.split('/')[0], 'objects'),
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
