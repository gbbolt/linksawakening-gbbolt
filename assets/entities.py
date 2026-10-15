"""The entity types: enemies, bosses, characters and objects. For each: its sprite frames drawn from its own
sprite tables (found by watching which tables the game hands to the draw routines while the entity is in one of
its rooms), its health, what each weapon does to it, the damage it does, its drops and flags, the rooms that
place it and, for characters, the dialogs they open."""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'entities'
TYPES = 0xE9
FRAMES = 120                    # frames watched per entity
MAX_VARIANTS = 24
CROP = 48
ENTITY_X, ENTITY_Y, ENTITY_TYPE, ENTITY_STATUS = 0xC200, 0xC210, 0xC3A0, 0xC280
ACTIVE_TYPE = 0xFFEB            # hActiveEntityType
WEAPONS = [  # (column of EntityDamageClassTable, name)
    (0, 'sword'), (1, 'strong sword / L2 sword'), (2, 'strong L2 sword'), (5, 'arrow'), (6, 'hookshot'),
    (7, 'bomb'), (8, 'boomerang'), (9, 'magic powder'), (0x0A, 'Magic Rod'), (0x0B, 'thrown object'),
    (0x0C, 'bomb arrow')]
PHYSICS = [(7, 'harmless to touch'), (6, 'not hit by weapons of other entities'), (5, 'pickup'),
           (4, 'casts a shadow')]
OPTIONS = [(0, 'passes soft walls'), (1, 'not an enemy'), (2, 'dungeon boss'), (3, 'splashes'),
           (4, 'ignores the ground'), (5, 'recoil not stopped by walls'), (6, 'sword-proof'),
           (7, 'boss or mini-boss')]
TRADE = ['none', 'Yoshi Doll', 'Ribbon', 'Dog Food', 'Bananas', 'Stick', 'Honeycomb', 'Pineapple', 'Hibiscus',
         'Letter', 'Broom', 'Fishing Hook', 'Necklace', 'Scale', 'Magnifying Lens']
DRAWERS = {'DrawEntity16x16': 'pair', 'DrawEntity8x16': 'single', 'DrawEntitySprites': 'list',
           'DrawEntitySpritesAtOAMStart': 'list'}


def effect(v):
    if v == 0 or 0xF0 <= v <= 0xFC:
        return '-'
    return {0x40: 'kills', 0xFD: 'fairy', 0xFE: 'burns', 0xFF: 'stuns'}.get(v, str(v))


# ---------------------------------------------------------------- drawing from the sprite tables
def sprite_pixels(vram, tile, attr, obp):
    """16 rows of 8 shades (255 = clear) of an 8 x 16 sprite."""
    rows = []
    pal = obp[1 if attr & 0x10 else 0]
    t = tile & 0xFE
    for r in range(16):
        rr = 15 - r if attr & 0x40 else r
        a = 16 * t + 2 * rr
        lo, hi = vram[a], vram[a + 1]
        row = bytearray(8)
        for x in range(8):
            bit = x if attr & 0x20 else 7 - x
            c = ((hi >> bit) & 1) << 1 | ((lo >> bit) & 1)
            row[x] = (pal >> (2 * c)) & 3 if c else 255
        rows.append(row)
    return rows


def frame_sprites(kind, data, count):
    """[(x, y, tile, attr)] of one variant (offsets from the entity's position, top left of each sprite)."""
    if kind == 'pair':
        lt, la, rt, ra = data[:4]
        if lt == 0xFF:
            return []
        out = []
        left, right = (-8, 0) if not la & 0x20 else (0, -8)
        if lt & 0x0F != 0x0F:
            out.append((left, -16, lt, la))
        if rt & 0x0F != 0x0F:
            out.append((right, -16, rt, ra))
        return out
    if kind == 'single':
        return [] if data[0] == 0xFF else [(-4, -16, data[0], data[1])]
    out = []
    for k in range(count):
        dy, dx, t, at = data[4 * k:4 * k + 4]
        if t == 0xFF:
            continue
        out.append(((dx - 256 if dx >= 128 else dx) - 8, (dy - 256 if dy >= 128 else dy) - 16, t, at))
    return out


def draw_frames(vram, obp, variants):
    """Pictures of the variants (lists of sprites), all on one canvas size."""
    sprites = [s for v in variants for s in v]
    if not sprites:
        return []
    x0 = min(s[0] for s in sprites)
    y0 = min(s[1] for s in sprites)
    x1 = max(s[0] for s in sprites) + 8
    y1 = max(s[1] for s in sprites) + 16
    if x1 - x0 > 96 or y1 - y0 > 96:
        return []
    out = []
    for v in variants:
        img = [bytearray([255] * (x1 - x0)) for _ in range(y1 - y0)]
        for x, y, t, at in reversed(v):          # the first sprite of a list lies on top
            px = sprite_pixels(vram, t, at, obp)
            for r in range(16):
                for c in range(8):
                    p = px[r][c]
                    if p != 255:
                        img[y - y0 + r][x - x0 + c] = p
        out.append(img)
    return out


def image_part(ctx, img, name, scale=3):
    return {'type': 'image', 'width': len(img[0]), 'height': len(img), 'scale': scale, 'name': name,
            'pixels': ctx.pixels(img), 'colors': list(COLORS), 'fixedColors': True}


# ---------------------------------------------------------------- watching the game draw
class DrawWatcher:
    def __init__(self, ctx, m):
        self.calls = {}
        self.addrs = {}
        for label, kind in DRAWERS.items():
            if label in ctx.syms:
                self.addrs[ctx.syms[label] & 0xFFFF] = (label, kind)
        self.m = m
        cpu = m.cpu
        orig = type(cpu).step
        calls, addrs, mem, mbc = self.calls, self.addrs, m.mem, m.mbc

        def step(cpu=cpu):
            hit = addrs.get(cpu.pc)
            if hit:
                t = mem[ACTIVE_TYPE]
                ptr = (cpu.d << 8 | cpu.e) if hit[1] in ('pair', 'single') else (cpu.h << 8 | cpu.l)
                if ptr < 0x8000:
                    lin = ptr if ptr < 0x4000 else mbc.rom_bank * 0x4000 + ptr - 0x4000
                    key = (t, hit[1], lin, cpu.c if hit[1] == 'list' else 0)
                    calls[key] = calls.get(key, 0) + 1
            orig(cpu)
        cpu.step = step

    def stop(self):
        del self.m.cpu.step


LD_TABLE = re.compile(r'^\s*ld (de|hl), (\w+)\s*(;.*)?$')
LD_C = re.compile(r'^\s*ld c, \$([0-9a-fA-F]{2})')
CALL_DRAW = re.compile(r'\b(call|jp)\s+(DrawEntity16x16|DrawEntity8x16|DrawEntitySprites|DrawEntitySpritesAtOAMStart)\b')


def static_tables(src, folder):
    """[(kind, table, count)]: the sprite tables the code of a folder hands to the draw routines (a table loaded
    into de or hl a few lines before the call; for the sprite lists the count loaded into c)."""
    out = []
    for n in src.folder_units(folder):
        body = src.units[n]['body']
        for i, line in enumerate(body):
            mm = CALL_DRAW.search(line)
            if not mm:
                continue
            routine = mm.group(2)
            reg = 'de' if routine in ('DrawEntity16x16', 'DrawEntity8x16') else 'hl'
            table, count = None, 0
            for prev in reversed(body[max(0, i - 10):i]):
                t = LD_TABLE.match(prev)
                if t and t.group(1) == reg and table is None:
                    table = t.group(2)
                c = LD_C.match(prev)
                if c and not count:
                    count = int(c.group(1), 16)
            u = src.units.get(table or '')
            if not u or table in [x[1] for x in out]:
                continue
            kind = DRAWERS[routine]
            if kind == 'list' and not count:
                continue
            out.append((kind, table, count))
    return out


# ---------------------------------------------------------------- dialogs and trade items in the code
OPEN = re.compile(r'\b(call|jp|jr)\s+(\w*OpenDialog\w*)', re.I)
LDA = re.compile(r'^\s*ld a, \$([0-9a-fA-F]{2})\s*$')


def handler_folder(src, label):
    p = src.path(label)
    parts = p.split('/')
    return '/'.join(parts[:2]) if len(parts) >= 2 else p


def dialogs_of(src, folder):
    found = set()
    for n in src.folder_units(folder):
        last = None
        for line in src.units[n]['body']:
            m = LDA.match(line)
            if m:
                last = int(m.group(1), 16)
                continue
            o = OPEN.search(line)
            if o and last is not None:
                name = o.group(2)
                base = 0x100 if 'Table1' in name else 0x200 if 'Table2' in name else 0
                found.add(base + last)
                last = None
            elif line.strip() and not line.strip().startswith(';') and not line.strip().startswith('.'):
                if 'ld a,' in line:
                    last = None
    return sorted(found)


def trade_items_of(src, folder):
    found = set()
    for n in src.folder_units(folder):
        body = src.units[n]['body']
        for i, line in enumerate(body):
            if 'wTradeSequenceItem' in line and 'ld a, [' in line:
                for nxt in body[i + 1:i + 4]:
                    m = re.match(r'^\s*cp \$([0-9a-fA-F]{2})', nxt)
                    if m and int(m.group(1), 16) < len(TRADE):
                        found.add(int(m.group(1), 16))
    return sorted(found)


# ---------------------------------------------------------------- build
def build(ctx):
    rom = ctx.rom
    rd = _la.RoomData(rom)
    names = _la.Names(ctx)
    src = _la.Source()
    T = lambda label, n, size=1: _la.table(ctx, label, n, size) or [0] * n  # noqa: E731
    group = T('EntityHealthGroupTable', TYPES)
    physics = T('EntityPhysicsFlagsTable', TYPES)
    hitflags = T('EntityHitboxFlagsTable', TYPES)
    options = T('EntityOptionsTable', TYPES)
    health = T('EntityHealthTable', 49)
    contact = T('EntityContactDamageTable', 49)
    drops = T('EntityDropClassTable', 49)
    dmgclass = T('EntityDamageClassTable', 49 * 16)
    weapon = T('WeaponDamageTable', 16 * 8)
    hitboxes = _la.table(ctx, 'EntityHitboxTable', 16, 4) or []

    rooms = {}
    for g in ('ow', 'A', 'B'):
        for r in range(256):
            for _, _, t in rd.entities(g, r):
                lst = rooms.setdefault(t, [])
                if (g, r) not in lst:
                    lst.append((g, r))
    pos_of = {}
    for mp in list(range(9)) + [10]:
        base = _la.lin(0x14, 0x4200 + 64 * mp)
        for pos in range(64):
            room = rom[base + pos]
            if room:
                pos_of.setdefault((_la.group_of_map(mp), room), (mp, pos))

    def room_cell(g, r):
        if g == 'ow':
            return {'asset': 'ow-room-{:02x}'.format(r), 'text': 'overworld ${:02X}'.format(r)}
        return {'asset': 'in-{}-{:02x}'.format(g.lower(), r), 'text': '{}${:02X}'.format(g, r)}

    import build as engine
    folder_room = {}
    for t in range(TYPES):
        lb = names.entity_handler(t)[0]
        if lb and rooms.get(t):
            folder_room.setdefault(handler_folder(src, lb), rooms[t][0])
    world = _la.World(rom)
    cards, all_rows, enemy_rows, boss_rows, npc_rows = [], [], [], [], []
    export = []
    for t in range(TYPES):
        label, bank, addr = names.entity_handler(t)
        name = names.entity_name(t)
        folder = handler_folder(src, label) if label else ''
        top = folder.split('/')[0] if folder else ''
        hg = group[t]
        boss = bool(options[t] & 0x80) or top == 'boss'
        images, sources = [], []
        where = rooms.get(t, [])
        home = where[0] if where else folder_room.get(folder)
        world.reset()
        ok = False
        if home:
            g, r = home
            if g == 'ow':
                ok = world.load(False, 0, r, settle=1)
            elif (g, r) in pos_of:
                mp, pos = pos_of[(g, r)]
                ok = world.load(True, mp, 0, pos=pos, settle=1)
            else:
                ok = world.load(True, 0x1F if g == 'A' else 0x10, r, settle=1)
        m = world.m
        if True:
            watch = DrawWatcher(ctx, m)
            samples, seen = [], set()
            for _ in range(FRAMES if ok else 0):
                m.run(1)
                if len(samples) < 8:
                    slot = next((s for s in range(16) if m.mem[ENTITY_TYPE + s] == t and m.mem[ENTITY_STATUS + s]), None)
                    if slot is not None:
                        pic = oam_crop(m, m.mem[ENTITY_X + slot], m.mem[ENTITY_Y + slot])
                        key = b''.join(bytes(x) for x in pic)
                        if key not in seen and any(p != 255 for p in key):
                            seen.add(key)
                            samples.append(pic)
            watch.stop()
            vram = bytes(m.mem[0x8000:0x9000])
            obp = (m.mem[0xFF48], m.mem[0xFF49])
            tables = {}
            for (tt, kind, lin, count), n in watch.calls.items():
                if tt != t:
                    continue
                tl, start, end = names.extent(lin)
                key = (kind, start, count)
                tables[key] = (tables.get(key, (0, tl, end))[0] + n, tl, end)
            found = sorted(tables.items(), key=lambda kv: -kv[1][0])[:4]
            if not found and folder:
                for kind, tl, count in static_tables(src, folder):
                    try:
                        a = engine.sym_linear(tl, ctx.syms)
                    except Exception:  # noqa: BLE001
                        continue
                    _, start, end = names.extent(a)
                    found.append(((kind, start, count), (0, tl, end)))
            for (kind, start, count), (n, tl, end) in found[:6]:
                size = {'pair': 4, 'single': 2, 'list': 4 * max(count, 1)}[kind]
                nvar = max(1, min(MAX_VARIANTS, (end - start) // size))
                variants = [frame_sprites(kind, rom[start + size * v:start + size * (v + 1)], count)
                            for v in range(nvar)]
                pics = draw_frames(vram, obp, [v for v in variants if v])
                if not pics:
                    continue
                for k, p in enumerate(pics):
                    images.append(dict(image_part(ctx, p, 'entity-{:02x}-{}-{}'.format(t, len(sources), k)),
                                       caption='{} variant {}'.format(tl, k)))
                sources.append({'text': tl, 'code': tl} if tl else '?')
            if not images:
                pics = trim(samples)
                for k, p in enumerate(pics or []):
                    images.append(image_part(ctx, p, 'entity-{:02x}-sample-{}'.format(t, k)))
        hb = hitboxes[(hitflags[t] >> 2) & 0x0F] if hitboxes else None
        flags = [n for b, n in PHYSICS if physics[t] & (1 << b)] + [n for b, n in OPTIONS if options[t] & (1 << b)]
        effects = [effect(weapon[w * 8 + (dmgclass[hg * 16 + w] & 7)]) if hg < 49 else '?' for w, _ in WEAPONS]
        handler = {'text': label, 'code': label} if label else '{:02X}:{:04X}'.format(bank, addr)
        dlg = dialogs_of(src, folder) if folder and top in ('npc', 'event', 'minigame', 'object', 'item') else []
        trades = trade_items_of(src, folder) if folder and top in ('npc', 'event') else []
        room_cells = [room_cell(g, r) for g, r in where]
        sections = [{'title': 'Entity', 'fields': [
            ['Type', '${:02X}'.format(t)], ['Handler', handler], ['Folder', folder or '-'],
            ['Health group', '${:02X}'.format(hg)],
            ['Health', health[hg] if hg < 49 else '?'],
            ['Damage to Link', '{} / 8 heart'.format(contact[hg]) if hg < 49 else '?'],
            ['Drop class', drops[hg] if hg < 49 else '?'],
            ['Sprites', physics[t] & 0x0F],
            ['Hitbox', 'shape {}: x {:+d}, half width {}, y {:+d}, half height {}'.format(
                (hitflags[t] >> 2) & 0x0F, *[(v - 256 if v >= 128 and i % 2 == 0 else v) for i, v in enumerate(hb)])
             if hb else '-'],
            ['Flags', ', '.join(flags) or '-'],
            ['Sprite tables', sources or '- (frames sampled from the screen)' if images else '-'],
        ]}, {'title': 'Weapons', 'columns': ['weapon', 'effect'],
             'rows': [[n, e] for (_, n), e in zip(WEAPONS, effects)]}]
        if room_cells:
            sections.append({'title': 'Rooms', 'chips': room_cells, 'wide': True})
        if dlg:
            sections.append({'title': 'Dialogs', 'wide': True, 'columns': ['dialog', 'text'],
                             'rows': [[{'asset': 'dialogs', 'text': '${:03X}'.format(d)},
                                       _la.dialog_text(rom, d)[:120]] for d in dlg]})
        if trades:
            sections.append({'title': 'Trading sequence', 'chips': ['{} ({})'.format(TRADE[i], i) for i in trades]})
        card = {'name': 'entity-{:02x}'.format(t), 'type': 'card', 'group': 'entities',
                'title': '${:02X} {}'.format(t, name), 'unit': label,
                'subtitle': '{}{} frame(s); in {} room(s)'.format('boss; ' if boss else '', len(images), len(where)),
                'images': images, 'sections': sections,
                'doc': ['Entity type ${:02X}, handled by {} (bank ${:02X}; EntityHandlerBankTable and EntityHandlers). '
                        'Its properties come from the per-type tables of bank $03 (EntityHealthGroupTable, '
                        'EntityPhysicsFlagsTable, EntityHitboxFlagsTable, EntityOptionsTable) and, through its health '
                        'group, from EntityHealthTable, EntityContactDamageTable, EntityDropClassTable and '
                        'EntityDamageClassTable with WeaponDamageTable. The pictures are the variants of the sprite '
                        'tables the game drew it from, in the tiles of its first room.'.format(t, label or '?', bank)],
                'users': [x for x in (label, 'EntityHandlers', 'EntityHealthGroupTable') if x]}
        cards.append(card)
        link = {'asset': card['name'], 'text': '${:02X}'.format(t)}
        pic = {'image': images[0]} if images else '-'
        all_rows.append([link, name, handler, folder or '-', len(where), len(images), pic])
        stats = [health[hg] if hg < 49 else '?', contact[hg] if hg < 49 else '?', drops[hg] if hg < 49 else '?']
        if top in ('enemy',) or (top == 'boss' or boss):
            row = [link, name, pic] + stats + effects + [', '.join(flags) or '-']
            if boss:
                boss_rows.append(row + [room_cells or '-'])
            else:
                enemy_rows.append(row + [len(where)])
        if top == 'npc' or dlg and top != 'enemy':
            npc_rows.append([link, name, pic, room_cells or '-',
                             [{'asset': 'dialogs', 'text': '${:03X}'.format(d)} for d in dlg] or '-',
                             ', '.join(TRADE[i] for i in trades) or '-'])
        export.append({'type': t, 'name': name, 'handler': label, 'bank': bank, 'folder': folder,
                       'health_group': hg, 'health': stats[0], 'contact_damage_eighths': stats[1],
                       'drop_class': stats[2], 'physics_flags': physics[t], 'hitbox_flags': hitflags[t],
                       'options': options[t], 'weapons': {n: e for (_, n), e in zip(WEAPONS, effects)},
                       'rooms': [['overworld' if g == 'ow' else 'indoor' + g, r] for g, r in where],
                       'dialogs': dlg, 'trade_items': trades})
    weapon_cols = [n for _, n in WEAPONS]
    out = [{'name': 'entity-types', 'type': 'table', 'title': 'Entity types', 'unit': 'EntityHandlers',
            'subtitle': '{} types'.format(TYPES),
            'columns': ['type', 'name', 'handler', 'folder', 'rooms', 'frames', 'picture'], 'rows': all_rows,
            'doc': ['All {} entity types with their handler, the folder of its code, the number of rooms whose '
                    'entity list places it and the number of sprite frames drawn on its sheet.'.format(TYPES)]},
           {'name': 'enemies', 'type': 'table', 'title': 'Enemies', 'unit': 'EntityDamageClassTable',
            'subtitle': '{} enemy types'.format(len(enemy_rows)),
            'columns': ['type', 'name', 'picture', 'health', 'damage to Link (1/8 heart)', 'drop class'] + weapon_cols
            + ['flags', 'rooms'], 'rows': enemy_rows,
            'doc': ['The enemies (the types whose code lies in the enemy folders): starting health '
                    '(EntityHealthTable), the damage touching them does to Link in eighths of a heart '
                    '(EntityContactDamageTable; the Guardian Acorn halves it), the drop class '
                    '(EntityDropClassTable) and what each weapon does: the damage class of the type\'s health group '
                    'for that weapon (EntityDamageClassTable) picks the entry of WeaponDamageTable - a number is the '
                    'health it takes, "kills" takes all, "stuns", "burns", "fairy" turns the enemy into a fairy, '
                    '"-" nothing. The strong sword is a spin attack, a dash with the Pegasus Boots or a hit with '
                    'the Piece of Power active (SwordDamageEntity); the L2 sword counts one step stronger. Jumping '
                    'on enemies with Roc\'s Feather and the shield are handled by the enemies\' own code, not by '
                    'these tables.']},
           {'name': 'bosses', 'type': 'table', 'title': 'Bosses and mini-bosses', 'unit': 'EntityOptionsTable',
            'subtitle': '{} types'.format(len(boss_rows)),
            'columns': ['type', 'name', 'picture', 'health', 'damage to Link (1/8 heart)', 'drop class'] + weapon_cols
            + ['flags', 'arena rooms'], 'rows': boss_rows,
            'doc': ['The bosses and mini-bosses (bit 7 of EntityOptionsTable, or code in the boss folders), with the '
                    'same columns as the enemies and the rooms whose entity list places them - their arenas.']},
           {'name': 'npcs', 'type': 'table', 'title': 'Characters', 'unit': 'EntityHandlers',
            'subtitle': '{} types'.format(len(npc_rows)),
            'columns': ['type', 'name', 'picture', 'rooms', 'dialogs', 'trading sequence'], 'rows': npc_rows,
            'doc': ['The characters of the island (code in the npc folders, and other entities that open dialogs): '
                    'the rooms that place them, the dialogs their code opens (a dialog number loaded into a and '
                    'handed to OpenDialog, OpenDialogTable1 or OpenDialogTable2, or to their own dialog routine) '
                    'and the items of the trading sequence their code checks (wTradeSequenceItem).']}]
    out.append(_la.export(ctx, 'entities', 'Entity types (download)', export,
                          'Every entity type with its handler, health, contact damage, drop class, flag bytes, '
                          'what each weapon does to it, the rooms that place it and the dialogs its code opens.'))
    stats = [{'health_group': g, 'health': health[g], 'contact_damage_eighths': contact[g], 'drop_class': drops[g],
              'types': ['{:02X}'.format(t) for t in range(TYPES) if group[t] == g]}
             for g in range(49)]
    for row in stats:
        for w, n in WEAPONS:
            row[n] = effect(weapon[w * 8 + (dmgclass[row['health_group'] * 16 + w] & 7)])
    out.append(_la.export(ctx, 'enemy-stats', 'Enemy stats by health group (download)', stats,
                          'The 49 health groups of bank $03 (EntityHealthTable, EntityContactDamageTable, '
                          'EntityDropClassTable, EntityDamageClassTable with WeaponDamageTable) with the entity types '
                          'that use each.'))
    return out + cards


def oam_crop(m, cx, cy):
    """The sprites near an entity's position, taken from OAM (for entities without sprite tables)."""
    mem = m.mem
    tall = mem[0xFF40] & 0x04
    h = 16 if tall else 8
    x0, y0 = cx - CROP // 2, cy + 12 - CROP
    img = [bytearray([255] * CROP) for _ in range(CROP)]
    obp = (mem[0xFF48], mem[0xFF49])
    for i in range(39, _la.LINK_OAM - 1, -1):
        sy, sx, t, at = mem[0xFE00 + 4 * i: 0xFE04 + 4 * i]
        sy -= 16
        sx -= 8
        if not (-16 <= sx - cx <= 8 and -24 <= sy - cy <= 0):
            continue
        px = sprite_pixels(mem[0x8000:0x9000], t if tall else t, at, obp)
        for r in range(h):
            y = sy + r - y0
            if not 0 <= y < CROP:
                continue
            for c in range(8):
                x = sx + c - x0
                if 0 <= x < CROP and px[r][c] != 255:
                    img[y][x] = px[r][c]
    return img


def trim(frames):
    if not frames:
        return None
    H, W = len(frames[0]), len(frames[0][0])
    ys = [y for y in range(H) if any(any(p != 255 for p in f[y]) for f in frames)]
    xs = [x for x in range(W) if any(f[y][x] != 255 for f in frames for y in range(H))]
    if not ys or not xs:
        return None
    return [[bytearray(f[y][xs[0]:xs[-1] + 1]) for y in range(ys[0], ys[-1] + 1)] for f in frames]
