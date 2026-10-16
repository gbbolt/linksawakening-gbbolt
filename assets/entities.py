"""The entity types: enemies, bosses, characters and objects. For each: its sprite frames drawn from its own
sprite tables (found by watching which tables the game hands to the draw routines while the entity is in one of
its rooms), its health, what each weapon does to it, the damage it does, its drops and flags, the rooms that
place it and, for characters, the dialogs they open."""
import base64
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'entities'
TYPES = 0xE9
MAX_VARIANTS = 24
CROP = 48
ENTITY_X, ENTITY_Y, ENTITY_TYPE, ENTITY_STATUS = 0xC200, 0xC210, 0xC3A0, 0xC280
ACTIVE_TYPE = 0xFFEB            # hActiveEntityType
SPRITE_VARIANT = 0xFFF1         # hActiveEntitySpriteVariant ($FF = not drawn)
TILE_OFFSET = 0xFFF5            # hActiveEntityTileOffset
FLIP_ATTR = 0xFFED              # hActiveEntityFlipAttribute (bit 4: palette OBP1)
OBP_STD = (0x1C, 0xE4)          # the sprite palettes of play (wOBJ0Palette, wOBJ1Palette), not a fade step
SETTLE = 45                     # frames after a room load until its entity tile sets are in VRAM
SURVEY_FRAMES = 110             # frames each room with entities runs while the draw routines are watched
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


def frame_sprites(kind, data, count, off=0, pal=0):
    """[(x, y, tile, attr)] of one variant (offsets from the entity's position, top left of each sprite).
    off: hActiveEntityTileOffset, added to the tiles by the pair and list routines; pal: the palette bit the
    entity XORs into the attributes (hActiveEntityFlipAttribute)."""
    if kind == 'pair':
        lt, la, rt, ra = data[:4]
        if lt == 0xFF:
            return []
        out = []
        lt, rt = (lt + off) & 0xFF, (rt + off) & 0xFF
        left, right = -8, 0          # the halves swap only with the entity's own x flip (not drawn here)
        if lt & 0x0F != 0x0F:
            out.append((left, -16, lt, la ^ pal))
        if rt & 0x0F != 0x0F:
            out.append((right, -16, rt, ra ^ pal))
        return out
    if kind == 'single':
        return [] if data[0] == 0xFF else [(-4, -16, data[0], data[1] ^ pal)]
    out = []
    for k in range(count):
        dy, dx, t, at = data[4 * k:4 * k + 4]
        if t == 0xFF:
            continue
        out.append(((dx - 256 if dx >= 128 else dx) - 8, (dy - 256 if dy >= 128 else dy) - 16, (t + off) & 0xFF,
                    at ^ pal))
    return out


def valid_variant(kind, data, count):
    """Does this record look like a sprite variant? The attribute bytes of this original Game Boy game use only
    bits 4-7 (palette, flips, priority) and list offsets stay near the entity; the first record that breaks this
    is data after the end of the table."""
    if len(data) < {'pair': 4, 'single': 2}.get(kind, 4 * count):
        return False
    if kind == 'pair':
        return data[0] == 0xFF or (data[1] & 0x0F == 0 and data[3] & 0x0F == 0)
    if kind == 'single':
        return data[0] == 0xFF or data[1] & 0x0F == 0
    for k in range(count):
        dy, dx, t, at = data[4 * k:4 * k + 4]
        if t == 0xFF:
            continue
        sy, sx = (dy - 256 if dy >= 128 else dy), (dx - 256 if dx >= 128 else dx)
        if at & 0x0F or not (-56 <= sy <= 56 and -56 <= sx <= 56):
            return False
    return True


def draw_frames(vrams, obp, variants):
    """Pictures of the variants (lists of sprites), all on one canvas size; vrams: the tiles of each variant."""
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
    for vram, v in zip(vrams, variants):
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
    """Notes every call of the entity draw routines while a room runs: (entity type, routine kind, sprite table
    as a linear ROM address, sprite count) -> the number of calls, the variants drawn, and the VRAM tiles, tile
    offset and palette bit of the entity at its last call (by then the tile sets it asked for are loaded)."""
    def __init__(self, ctx, m, room):
        self.calls = {}
        addrs = {}
        for label, kind in DRAWERS.items():
            if label in ctx.syms:
                addrs[ctx.syms[label] & 0xFFFF] = (label, kind)
        self.m = m
        start = m.frame
        cpu = m.cpu
        orig = type(cpu).step
        calls, mem, mbc = self.calls, m.mem, m.mbc

        def step(cpu=cpu):
            hit = addrs.get(cpu.pc)
            if hit and mem[SPRITE_VARIANT] != 0xFF:
                kind = hit[1]
                ptr = (cpu.d << 8 | cpu.e) if kind in ('pair', 'single') else (cpu.h << 8 | cpu.l)
                if ptr < 0x8000:
                    lin = ptr if ptr < 0x4000 else mbc.rom_bank * 0x4000 + ptr - 0x4000
                    key = (mem[ACTIVE_TYPE], kind, lin, cpu.c if kind == 'list' else 0)
                    rec = calls.get(key)
                    if rec is None:
                        rec = calls[key] = {'n': 0, 'vars': set(), 'room': room}
                    rec['n'] += 1
                    rec['vars'].add(mem[SPRITE_VARIANT])
                    if 'vram' not in rec or m.frame - start >= rec['at']:
                        rec['vram'] = bytes(mem[0x8000:0x9000])
                        rec['at'] = m.frame - start
                        rec['off'] = 0 if kind == 'single' else mem[TILE_OFFSET]
                        rec['pal'] = mem[FLIP_ATTR] & 0x10
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
    # ---- watch every room with entities: which sprite tables each type is drawn from, with the tiles of the time
    world = _la.World(rom)
    store, samples, seen_samples, loaded = {}, {}, {}, set()
    targets = [(g, r) for g in ('ow', 'A', 'B') for r in range(256) if rd.entities(g, r)]
    cache = os.environ.get('ENTITY_SURVEY_CACHE')      # (development: reuse a survey while changing the drawing)
    if cache and os.path.exists(cache):
        import pickle
        store, samples, loaded = pickle.load(open(cache, 'rb'))
        targets = []
    for g, r in targets:
        world.reset()
        if g == 'ow':
            ok = world.load(False, 0, r, settle=1)
        elif (g, r) in pos_of:
            mp, pos = pos_of[(g, r)]
            ok = world.load(True, mp, 0, pos=pos, settle=1)
        else:
            ok = world.load(True, 0x1F if g == 'A' else 0x10, r, settle=1)
        if not ok:
            continue
        loaded.add((g, r))
        m = world.m
        watch = DrawWatcher(ctx, m, (g, r))
        for f in range(SURVEY_FRAMES):
            m.run(1)
            if f >= SETTLE and f % 6 == 0:
                for s in range(16):
                    t = m.mem[ENTITY_TYPE + s]
                    if not m.mem[ENTITY_STATUS + s] or len(samples.get(t, [])) >= 8:
                        continue
                    pic = oam_crop(m, m.mem[ENTITY_X + s], m.mem[ENTITY_Y + s])
                    key = b''.join(bytes(x) for x in pic)
                    if key not in seen_samples.setdefault(t, set()) and any(p != 255 for p in key):
                        seen_samples[t].add(key)
                        samples.setdefault(t, []).append(pic)
        watch.stop()
        for key, rec in watch.calls.items():
            store.setdefault(key, []).append(rec)
    if cache and targets:
        import pickle
        pickle.dump((store, samples, loaded), open(cache, 'wb'))

    by_variant = {}

    def tables_of(t, home):
        """{(kind, table start, count): (score, label, end, record)} - per table the record of a home room
        (a room whose entity list places the type) or else the room that drew it most."""
        out = {}
        for (tt, kind, lin, count), recs in store.items():
            if tt != t:
                continue
            tl, start, end = names.extent(lin)
            k = (kind, start, count)
            size = {'pair': 4, 'single': 2, 'list': 4 * max(count, 1)}[kind]
            for rec in recs:
                # the variants this record saw drawn: in its tiles they are right
                seen = rec['vars'] if kind != 'list' else {(lin - start) // size}
                vmap = by_variant.setdefault((t, k), {})
                for v in seen:
                    if v not in vmap or rec['n'] > vmap[v]['n']:
                        vmap[v] = rec
                score = rec['n'] + (1 << 20 if rec['room'] in home else 0)
                cur = out.get(k)
                total = (cur[4] if cur else 0) + rec['n']
                if cur is None or score > cur[0]:
                    out[k] = (score, tl, end, rec, total)
                else:
                    out[k] = cur[:4] + (total,)
        return out

    cards, all_rows, enemy_rows, boss_rows, npc_rows = [], [], [], [], []
    export = []
    saved_frames, saved_vram = [], {}     # the frames drawn, with their tiles: for the tile sheets' object pages
    for t in range(TYPES):
        label, bank, addr = names.entity_handler(t)
        name = names.entity_name(t)
        folder = handler_folder(src, label) if label else ''
        top = folder.split('/')[0] if folder else ''
        hg = group[t]
        boss = bool(options[t] & 0x80) or top == 'boss'
        images, sources = [], []
        where = rooms.get(t, [])
        found = sorted(tables_of(t, set(where)).items(), key=lambda kv: -kv[1][4])[:4]
        guessed = common = False
        drawn, seen_imgs = [], []
        if not found and folder:
            # not seen drawn anywhere: the tables its code hands to the draw routines, with the tiles of the room
            # of its folder (a part of a boss or a character that is spawned by another entity there); else only
            # the variants made of the sprite tiles every world room has (Link and the items, tiles $00-$3F)
            fr = folder_room.get(folder)
            vrec = next((rec for recs in store.values() for rec in recs if rec['room'] == fr), None) \
                if fr in loaded else None
            if vrec is None:
                vrec = next((rec for (tt, _, _, _), recs in store.items() for rec in recs if rec['room'][0] == 'ow'),
                            None)
                common = True
            for kind, tl, count in static_tables(src, folder) if vrec else []:
                try:
                    a = engine.sym_linear(tl, ctx.syms)
                except Exception:  # noqa: BLE001
                    continue
                _, start, end = names.extent(a)
                found.append(((kind, start, count), (0, tl, end, dict(vrec, off=0, pal=0), 0)))
                guessed = True
        for (kind, start, count), (_, tl, end, rec, _) in found[:6]:
            size = {'pair': 4, 'single': 2, 'list': 4 * max(count, 1)}[kind]
            nvar = max(1, min(MAX_VARIANTS, (end - start) // size))
            variants = []
            vmap = {} if guessed else by_variant.get((t, (kind, start, count)), {})
            # the 16-tile groups the variants seen drawn use: a variant never seen drawn is shown only if its tiles
            # lie in those groups or in the tiles every room shares ($00-$3F), else its tiles are not known
            seen_groups = set()
            for v, vr in vmap.items():
                data = rom[start + size * v:start + size * (v + 1)]
                if len(data) == size:
                    seen_groups |= {s[2] >> 4 for s in frame_sprites(kind, data, count, vr['off'], vr['pal'])}
            for v in range(nvar):
                data = rom[start + size * v:start + size * (v + 1)]
                if not valid_variant(kind, data, count):
                    break
                vr = vmap.get(v, rec)        # a variant seen drawn: with the tiles of the room that drew it
                sp = frame_sprites(kind, data, count, vr['off'], vr['pal'])
                if common and any(s[2] >= 0x40 for s in sp):
                    continue
                if vmap and v not in vmap and any(s[2] >> 4 not in seen_groups for s in sp):
                    continue
                if sp:
                    variants.append((v, sp, vr['vram']))
            pics = draw_frames([vram for _, _, vram in variants], OBP_STD, [sp for _, sp, _ in variants])
            if not pics:
                continue
            drawn.extend(pics)
            frame_recs = []
            for v, sp, vram in variants:
                key = hash(vram)
                saved_vram.setdefault(key, vram)
                frame_recs.append({'variant': v, 'sprites': sp, 'vram': key, 'seen': v in vmap})
            saved_frames.append({'type': t, 'name': name, 'card': 'entity-{:02x}'.format(t), 'table': tl,
                                 'kind': kind, 'guessed': guessed, 'frames': frame_recs})
            for (v, _, _), p in zip(variants, pics):
                if v in vmap:
                    seen_imgs.append(len(images))
                images.append(dict(image_part(ctx, p, 'entity-{:02x}-{}-{}'.format(t, len(sources), v)),
                                   caption='{} variant {}'.format(tl, v)))
            sources.append({'text': tl, 'code': tl} if tl else '?')
        # only a shadow drawn by the routines (the body comes from the entity's own OAM code): add the screen samples
        flat_only = all(len({p for row in pic for p in row if p != 255}) <= 1 for pic in drawn)
        if not images or flat_only:
            pics = trim(samples.get(t, []))
            if pics:
                seen_imgs = []
            for k, p in enumerate(pics or []):
                seen_imgs.append(len(images))
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
            ['Sprite tables', (sources + ([('(not seen drawn in a room: only the variants made of the sprite tiles '
                                            'every room shares)') if common else
                                           '(not seen drawn in a room: the tiles of the room of its code folder)']
                                          if guessed and sources else []))
             or ('- (frames sampled from the screen)' if images else '- (not drawn in any room)')],
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
                        'tables the game drew it from, with the tiles that were in VRAM when it drew it, in the '
                        'sprite palettes of play.'.format(t, label or '?', bank)],
                'users': [x for x in (label, 'EntityHandlers', 'EntityHealthGroupTable') if x]}
        cards.append(card)
        link = {'asset': card['name'], 'text': '${:02X}'.format(t)}
        # the table picture: of the frames seen drawn, the one with the most visible pixels (not a shadow or a spark)
        cand = [images[k] for k in seen_imgs] or images[:1]
        best = max(cand, key=lambda im: sum(1 for p in base64.b64decode(im['pixels']) if p != 255)) if cand else None
        pic = {'image': best} if best else '-'
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
    import pickle
    with open(ctx.file('frames.pkl')[0], 'wb') as f:
        pickle.dump({'tables': saved_frames, 'vram': saved_vram, 'obp': OBP_STD}, f)
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
    obp = OBP_STD
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
