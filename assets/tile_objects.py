"""The objects the game assembles from each tile sheet: the 16 x 16 blocks rooms are built from (OverworldObjectTiles
and IndoorObjectTiles, with the tiles the room loader puts in VRAM, in every frame of their animated tiles), the
sprite frames of every entity (the sprite tables the draw routines are handed, as the entity survey saw them drawn),
Link's poses (LinkPoseTiles / LinkPoseAttributes) and the sprite layouts and tilemaps of the disassembly. Each
object is drawn as the game draws it - tile by tile with its flips and palette - and listed under every tile sheet
its tiles come from, with how many of the sheet's tiles some object uses.

Which sheet a tile in VRAM came from is followed while the game runs: every byte copied keeps the ROM address it was
read from, so a tile in VRAM knows its sheet and index even when two sheets hold the same pictures. Tiles without
that trail (the entity survey's VRAM, the tile loaders of the sprite layouts) are found by their contents, taking
the longest run of consecutive tiles that matches a sheet."""
import json
import os
import pickle
import sys
import types

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS, Machine, DMGCPU  # noqa: E402
import _la  # noqa: E402

GROUP = 'tile objects'
OBP = (0x1C, 0xE4)               # wOBJ0Palette / wOBJ1Palette during play
ANIM_FRAMES = 96                 # frames a room runs after loading: its animated tiles go through all their steps
WIDTH = 384                      # width of an object sheet in pixels
CLEAR = 255
REASONS = {
    'bg': 'drawn on the background by code (status bar, doors, effects), not by a block',
    'oam': 'drawn as a sprite by code that has no sprite table here',
    'loaded': 'loaded into VRAM, but nothing seen draws it (unused, or drawn only by code not run here)',
    'never': 'not loaded in any room or scene run here',
}


# ---------------------------------------------------------------- following tiles from the ROM into VRAM
class TraceCPU(DMGCPU):
    """The CPU with a shadow of memory: for each RAM / VRAM byte the linear ROM address its value was copied
    from (-1 = computed). A written value takes the origin of the most recent read of the same value."""
    def rd(self, a):
        a &= 0xFFFF
        v = self.hw.io_read(a) if a >= 0xFF00 else self.mem[a]
        if a < 0x4000:
            o = a
        elif a < 0x8000:
            o = self.mbc.rom_bank * 0x4000 + a - 0x4000
        else:
            o = self.shadow[a]
        r = self.recent
        r.append((v, o))
        if len(r) > 4:
            del r[0]
        return v

    def wr(self, a, v):
        DMGCPU.wr(self, a, v)
        a &= 0xFFFF
        if a >= 0x8000:
            v &= 0xFF
            o = -1
            for vv, oo in reversed(self.recent):
                if vv == v:
                    o = oo
                    break
            self.shadow[0xC000 + (a - 0xE000) if 0xE000 <= a < 0xFE00 else a] = o


class TraceMachine(Machine):
    def __init__(self, rom, coverage=False):
        super().__init__(rom, coverage)
        old = self.cpu
        cpu = TraceCPU(self.mem, self.mbc, self)
        for k in ('a', 'f', 'b', 'c', 'd', 'e', 'h', 'l', 'sp', 'pc', 'ime'):
            setattr(cpu, k, getattr(old, k))
        cpu.shadow = [-1] * 0x10000
        cpu.recent = []
        self.cpu = cpu
        self.on_frame = capture_frame


# ---------------------------------------------------------------- screens as the game shows them
MODES = {0: 'intro and title', 1: 'ending', 2: 'file menu', 3: 'name entry', 4: 'file delete', 5: 'file copy',
         6: 'save menu', 7: 'island map', 8: 'picture screen', 9: 'Marin on the beach', 0x0A: 'wall mural',
         0x0B: 'world'}
CAPTURE = {'on': False, 'every': 8, 'shots': [], 'seen': set(), 'sheets': None, 'tag': ''}


def capture_frame(m):
    """Called at the start of each VBlank: every few frames, what the screen shows and which tiles it uses."""
    c = CAPTURE
    if not c['on'] or m.frame % c['every'] or not m.mem[0xFF40] & 0x80:
        return
    pic = m.screen()
    flat = b''.join(bytes(r) for r in pic)
    key = hash(flat)
    if key in c['seen'] or max(flat.count(bytes([k])) for k in range(4)) > 0.97 * len(flat):
        return
    c['seen'].add(key)
    mem = m.mem
    tiles = set()
    for row in range(18):
        y = 8 * row + 4
        regs = m.line_regs[y] or (mem[0xFF40], mem[0xFF42], mem[0xFF43], mem[0xFF4A], mem[0xFF4B])
        lcdc, scy, scx, wy, wx = regs[:5]
        if not lcdc & 0x80 or not lcdc & 1:
            continue
        for col in range(21):
            x = min(8 * col, 159)
            if lcdc & 0x20 and y >= wy and wx < 167 and x >= wx - 7:
                base, mx, my = (0x9C00 if lcdc & 0x40 else 0x9800), x - (wx - 7), y - wy
            else:
                base, mx, my = (0x9C00 if lcdc & 0x08 else 0x9800), (x + scx) & 0xFF, (y + scy) & 0xFF
            t = mem[base + 32 * (my >> 3) + (mx >> 3)]
            tiles.add(bg_addr(t, lcdc) // 16)
    bg = set(tiles)
    lcdc = mem[0xFF40]
    obj = []                    # (tile, sprite palette) of the sprites on screen
    if lcdc & 2:
        for i in range(40):
            y, x, t, at = mem[0xFE00 + 4 * i:0xFE04 + 4 * i]
            if 0 < y < 160 and 0 < x < 168:
                for tt in ((t & 0xFE, t | 1) if lcdc & 4 else (t,)):
                    tiles.add(tt)
                    obj.append((tt, mem[0xFF49 if at & 0x10 else 0xFF48]))
    sheets, shadow = c['sheets'], m.cpu.shadow
    known = {i: sheets.traced(shadow, 0x8000 + 16 * i) for i in tiles}
    shot = {'mode': mem[0xDB95], 'sub': mem[0xDB96], 'frame': m.frame, 'tag': c['tag'], 'pic': pic,
            'known': known, 'bg': bg, 'obj': obj}
    if any(v is None for v in known.values()):
        shot['vram'] = bytes(mem[0x8000:0x9800])
    c['shots'].append(shot)


# the machines are pickled (World.reset): the classes and the frame hook must be found by module name
_mod = types.ModuleType(__name__)
_mod.__dict__.update({'TraceCPU': TraceCPU, 'TraceMachine': TraceMachine, 'capture_frame': capture_frame})
sys.modules.setdefault(__name__, _mod)


def traced_world(rom):
    saved = _la.Machine
    _la.Machine = TraceMachine
    try:
        return _la.World(rom)
    finally:
        _la.Machine = saved


# ---------------------------------------------------------------- the tile sheets
class Sheets:
    def __init__(self, ctx):
        from site_gen import resolve_value
        self.rom = ctx.rom
        self.list = []                  # (name, start, tiles, folder, tall)
        for u in ctx.project.parsed.units:
            a = u.asset
            if not a or a.get('type') != 'tiles':
                continue
            n = resolve_value(ctx.project, a['length']) if 'length' in a else u.end - u.start
            self.list.append((u.name, u.start, n // 16, u.path or '', 'tall' in a))
        self.by_name = {s[0]: i for i, s in enumerate(self.list)}
        self.at = {}                    # linear address of a tile -> (sheet, tile)
        self.index = {}                 # tile bytes -> [(sheet, tile)]
        for i, (_, start, n, _, _) in enumerate(self.list):
            for k in range(n):
                a = start + 16 * k
                self.at.setdefault(a, (i, k))
                self.index.setdefault(bytes(self.rom[a:a + 16]), []).append((i, k))

    def tile(self, si, k):
        a = self.list[si][1] + 16 * k
        return bytes(self.rom[a:a + 16])

    def traced(self, shadow, addr):
        """(sheet, tile) of the VRAM tile at addr when all its 16 bytes came in order from a sheet's tile."""
        o = shadow[addr]
        if o < 0 or o not in self.at:
            return None
        for k in range(1, 16):
            if shadow[addr + k] != o + k:
                return None
        return self.at[o]

    def match(self, tiles, known=None):
        """For a run of VRAM tiles (16-byte strings, in VRAM order): per tile the list of (sheet, tile) it holds -
        the known origin, else the candidates of the longest run of consecutive tiles equal to a sheet's."""
        n = len(tiles)
        best, length = [None] * n, [0] * n
        done = {}
        for i in range(n):
            if known and known[i] is not None:
                best[i], length[i] = [known[i]], 1 << 20
                continue
            cands = self.index.get(tiles[i], ())
            if not cands or len(cands) > 48:            # blank and common tiles: from their neighbours' runs
                continue
            for si, k in cands:
                key = (si, k - i)
                if done.get(key, -1) > i:
                    continue
                ns = self.list[si][2]
                f = 1
                while i + f < n and k + f < ns and tiles[i + f] == self.tile(si, k + f):
                    f += 1
                b = 0
                while i - b > 0 and k - b > 0 and tiles[i - b - 1] == self.tile(si, k - b - 1):
                    b += 1
                done[key] = i + f
                run = f + b
                for j in range(i - b, i + f):
                    o = (si, k + j - i)
                    if run > length[j]:
                        best[j], length[j] = [o], run
                    elif run == length[j] and o not in best[j]:
                        best[j].append(o)
        return best


# ---------------------------------------------------------------- pictures
def tile_rows(data, a, rows=8):
    out = []
    for r in range(rows):
        lo, hi = data[a + 2 * r], data[a + 2 * r + 1]
        out.append([((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1) for x in range(8)])
    return out


def draw_sprites(vram, sprites, tall=True, obp=OBP):
    """[(x, y, tile, attr)] -> (picture rows, x0, y0); vram from $8000; the first sprite lies on top."""
    h = 16 if tall else 8
    x0 = min(s[0] for s in sprites)
    y0 = min(s[1] for s in sprites)
    w = max(s[0] for s in sprites) + 8 - x0
    hh = max(s[1] for s in sprites) + h - y0
    img = [bytearray([CLEAR] * w) for _ in range(hh)]
    for x, y, t, at in reversed(sprites):
        t = t & 0xFE if tall else t
        px = tile_rows(vram, 16 * t, h)
        pal = obp[1 if at & 0x10 else 0]
        for r in range(h):
            rr = h - 1 - r if at & 0x40 else r
            for c in range(8):
                cc = 7 - c if at & 0x20 else c
                v = px[rr][cc]
                if v:
                    img[y - y0 + r][x - x0 + c] = (pal >> (2 * v)) & 3
    return img


def bg_addr(t, lcdc):
    return 16 * t if lcdc & 0x10 else 0x1000 + 16 * (t - 256 if t >= 128 else t)


def draw_bg(vram, cells, width, lcdc, bgp):
    """Tile numbers row by row (width per row) -> picture; vram from $8000."""
    hgt = (len(cells) + width - 1) // width
    img = [bytearray(8 * width) for _ in range(8 * hgt)]
    for i, t in enumerate(cells):
        px = tile_rows(vram, bg_addr(t, lcdc))
        x, y = 8 * (i % width), 8 * (i // width)
        for r in range(8):
            row = img[y + r]
            for c in range(8):
                row[x + c] = (bgp >> (2 * px[r][c])) & 3
    return img


def flow(groups, width=WIDTH, gap=6, inner=2):
    """Lay groups of frames out left to right in rows. groups: [(frames, mark)]; returns (rows, marks)."""
    placed, x, y, rowh = [], 0, 0, 0
    for frames, mark in groups:
        gw = sum(len(f[0]) for f in frames) + inner * (len(frames) - 1)
        if x and x + gw > width:                     # the group goes on a new row
            x, y, rowh = 0, y + rowh + gap, 0
        boxes = []
        for f in frames:
            fw, fh = len(f[0]), len(f)
            if boxes and x + fw > width:             # a group wider than the sheet wraps
                x, y, rowh = 0, y + rowh + inner, 0
            placed.append((x, y, f))
            boxes.append((x, y, fw, fh))
            rowh = max(rowh, fh)
            x += fw + inner
        x += gap - inner
        if mark is not None:
            bx0 = min(b[0] for b in boxes)
            by0 = min(b[1] for b in boxes)
            bx1 = max(b[0] + b[2] for b in boxes)
            by1 = max(b[1] + b[3] for b in boxes)
            placed.append((None, None, dict(mark, x=bx0, y=by0, w=bx1 - bx0, h=by1 - by0)))
    W = max([p[0] + len(p[2][0]) for p in placed if p[0] is not None] + [8])
    H = max([p[1] + len(p[2]) for p in placed if p[0] is not None] + [8])
    img = [bytearray([CLEAR] * W) for _ in range(H)]
    marks = []
    for px, py, f in placed:
        if px is None:
            marks.append(f)
            continue
        for r, row in enumerate(f):
            img[py + r][px:px + len(row)] = row
    return img, marks


def stack(parts, gap=10):
    """Pictures (with their marks) one under the other."""
    W = max(len(p[0][0]) for p in parts)
    img, marks, y = [], [], 0
    for k, (pic, mk) in enumerate(parts):
        if k:
            img += [bytearray([CLEAR] * W) for _ in range(gap)]
            y += gap
        for row in pic:
            img.append(bytearray(row) + bytearray([CLEAR] * (W - len(row))))
        marks += [dict(m, y=m['y'] + y) for m in mk]
        y += len(pic)
    return img, marks


def tile_place(k, tall):
    """Where tile k of a sheet sits in the sheet picture: 16 tiles a row; 8 x 16 sprite tiles as pairs."""
    if tall:
        pair = k // 2
        return 9 * (pair % 16), 17 * (pair // 16) + 8 * (k & 1)
    return 9 * (k % 16), 9 * (k // 16)


def sheet_strip(sheets, si, used, pals=None):
    """The sheet itself (in each tile's palette, as is without one), the tiles no object uses checkered out."""
    _, start, n, _, tall = sheets.list[si]
    height = 17 * ((n + 31) // 32) - 1 if tall else 9 * ((n + 15) // 16) - 1
    img = [bytearray([CLEAR] * (16 * 9 - 1)) for _ in range(height)]
    rom = sheets.rom
    for k in range(n):
        px = tile_rows(rom, start + 16 * k)
        x, y = tile_place(k, tall)
        pal = pals[k] if pals and pals[k] is not None else 0xE4
        for r in range(8):
            for c in range(8):
                v = (pal >> (2 * px[r][c])) & 3
                if k not in used and (r + c) & 1:
                    v = CLEAR
                img[y + r][x + c] = v
    return img


# ---------------------------------------------------------------- the build
def build(ctx):
    rom = ctx.rom
    sheets = Sheets(ctx)
    names = _la.Names(ctx)
    objects = []            # {'label', 'text', 'link', 'frames': [rows], 'uses': {sheet: set(tiles)}, 'kind', 'pieces'}
    loaded = {}             # sheet -> tiles seen in VRAM
    by_code = {}            # sheet -> {tile: 'bg' | 'oam'}

    def note_loaded(origins):
        for o in origins:
            for si, k in o or ():
                loaded.setdefault(si, set()).add(k)

    def add(kind, label, text, frames, uses, pieces, link=None, table=None):
        if not frames:
            return
        objects.append({'kind': kind, 'label': label, 'text': text, 'link': link, 'frames': frames,
                        'uses': uses, 'pieces': pieces, 'table': table})
        if kind in ('block', 'tilemap'):
            for si, ks in uses.items():
                PALS['bg'].update((si, k) for k in ks)
        for fp in pieces:
            for p in fp:
                if kind in ('sprite', 'link', 'oam') and p[2] is not None:
                    note_pal((sheets.by_name[p[2]], p[3]), OBP[p[6]])

    def use(uses, origin):
        for si, k in origin or ():
            uses.setdefault(si, set()).add(k)

    PALS.update(obj={}, bg=set())
    # ---- power-on to the world on a traced machine: the screens on the way are captured
    CAPTURE.update(on=True, shots=[], seen=set(), sheets=sheets, tag='')
    try:
        world = traced_world(rom)
    finally:
        CAPTURE['on'] = False
    # ---- the rooms' blocks
    blocks(ctx, rom, sheets, world, add, use, note_loaded, by_code)
    # ---- Link's poses
    link_poses(ctx, rom, sheets, add)
    # ---- the entities' sprite frames (from the entity survey)
    entity_frames(ctx, sheets, add, use, note_loaded)
    # ---- the sprite layouts and tilemaps of the disassembly
    layouts(ctx, rom, sheets, add, use, note_loaded)
    # ---- the other screens: menus, the island map, the ending, ...
    other_modes(world)
    scenes(sheets, objects, add, note_loaded)
    return pages(ctx, sheets, names, objects, loaded, by_code)


def other_modes(world):
    """Start the game modes that are not on the way into the world from a world state and capture them."""
    from _game import A, START, SELECT
    plans = [('inventory', None, [(START, 4, 120)]), ('island map', None, [(SELECT, 4, 160)])]
    plans += [(MODES[mode], mode, frames) for mode, frames in OTHER_MODES]
    for tag, mode, steps in plans:
        world.reset()
        m = world.m
        m.run(20)
        CAPTURE.update(on=True, tag=tag)
        try:
            if mode is None:
                for buttons, hold, after in steps:
                    m.press(buttons, hold, after)
            else:
                m.mem[_la.GAMEPLAY_TYPE], m.mem[_la.GAMEPLAY_SUBTYPE] = mode, 0
                for f in range(steps):          # A now and then moves the text boxes of the scene on
                    m.buttons = A if f % 48 < 2 else 0
                    m.run(1)
        except RuntimeError:
            pass
        finally:
            CAPTURE['on'] = False
            m.buttons = 0


OTHER_MODES = [(1, 24000), (6, 200), (8, 300), (9, 2400), (0x0A, 900)]
MAX_SCREENS = 120
PALS = {'obj': {}, 'bg': set()}     # (sheet, tile) -> {sprite palette: times seen}; (sheet, tile) seen on the background


def note_pal(st, obp, n=1):
    c = PALS['obj'].setdefault(st, {})
    c[obp] = c.get(obp, 0) + n


def tile_palettes(sheets):
    """Per sprite sheet the palette each tile is drawn with most often (None: a background tile, shown as is);
    tiles never seen as sprites take the sheet's most common palette, else OBP0."""
    out = {}
    for si, (name, _, n, _, tall) in enumerate(sheets.list):
        counts = [PALS['obj'].get((si, k)) for k in range(n)]
        if not tall and not any(counts):
            continue
        total = {}
        for c in counts:
            for p, v in (c or {}).items():
                total[p] = total.get(p, 0) + v
        fallback = max(total, key=total.get) if total else OBP[0]
        has_bg = not tall and any((si, k) in PALS['bg'] for k in range(n))
        pals = []
        for k, c in enumerate(counts):
            if c:
                pals.append(max(c, key=c.get))
            elif has_bg:                    # a sheet of background and sprite tiles: the rest shown as is
                pals.append(None)
            else:
                pals.append(fallback)
        out[name] = pals
    return out


def scenes(sheets, objects, add, note_loaded):
    """The captured screens that show tiles no other object uses: picked greedily (most new tiles first)."""
    covered = set()
    for ob in objects:
        for si, ks in ob['uses'].items():
            covered |= {(si, k) for k in ks}
    cache, cands = {}, []
    for s in CAPTURE['shots']:
        pairs = set()
        mo = None
        if 'vram' in s:
            h = hash(s['vram'])
            if h not in cache:
                v = s['vram']
                cache[h] = sheets.match([v[16 * i:16 * i + 16] for i in range(384)])
            mo = cache[h]
        org = {}
        for i, o in s['known'].items():
            org[i] = [o] if o is not None else (mo[i] or []) if mo is not None else []
            pairs.update(org[i])
        note_loaded([[p] for p in pairs])
        for i, obp in s.get('obj', ()):
            for p in org.get(i, ()):
                note_pal(p, obp)
        for i in s.get('bg', ()):
            PALS['bg'].update(org.get(i, ()))
        cands.append((s, pairs))
    import heapq
    heap = [(-len(p - covered), k) for k, (_, p) in enumerate(cands)]
    heapq.heapify(heap)
    chosen = []
    while heap and len(chosen) < MAX_SCREENS:
        neg, k = heapq.heappop(heap)
        gain = cands[k][1] - covered
        if not gain:
            continue
        if -neg != len(gain):                # stale: put it back with its current gain
            heapq.heappush(heap, (-len(gain), k))
            continue
        chosen.append((k, gain))
        covered |= gain
    for k, gain in sorted(chosen):
        s, pairs = cands[k]
        new_sheets = {si for si, _ in gain}
        uses = {}
        for si, t in pairs:
            if si in new_sheets:
                uses.setdefault(si, set()).add(t)
        what = s['tag'] or MODES.get(s['mode'], 'game mode ${:02X}'.format(s['mode']))
        add('screen', 'Screen: {}'.format(what),
            'as the game showed it (game mode ${:02X} {}, step ${:02X}, frame {})'.format(
                s['mode'], MODES.get(s['mode'], ''), s['sub'], s['frame']),
            [[bytearray(r) for r in s['pic']]], uses, [], table=None)


TABLES = {False: ('OverworldObjectTiles', 0xF5), True: ('IndoorObjectTiles', 0xEC)}


def blocks(ctx, rom, sheets, world, add, use, note_loaded, by_code):
    """Load one room of every tile set (and animation) the rooms use; draw the blocks those rooms are built of."""
    gen = ctx.gen_dir
    rooms = []
    try:
        for r in json.load(open(os.path.join(gen, 'overworld_overworld-rooms.json'), encoding='utf-8')):
            rooms.append(('ow', 0, r['room'], r['tileset'], r['anim'], r['grid']))
        for r in json.load(open(os.path.join(gen, 'indoors_indoor-rooms.json'), encoding='utf-8')):
            rooms.append((r['group'], r['map'], r['room'], r['tileset'], r['anim'], r['grid']))
    except (OSError, ValueError, KeyError):
        return
    side = _la.side_view_rooms(rom)
    pos_of = {}
    for mp in list(range(9)) + [10]:
        base = _la.lin(0x14, 0x4200 + 64 * mp)
        for pos in range(64):
            if rom[base + pos]:
                pos_of.setdefault((mp, _la.group_of_map(mp), rom[base + pos]), pos)
    configs = {}
    for g, mp, room, ts, anim, grid in rooms:
        key = (g, mp if g != 'ow' else 0, ts, anim, (g, room) in side)
        c = configs.setdefault(key, {'rooms': [], 'objects': set()})
        c['rooms'].append((g, mp, room))
        c['objects'].update(o for row in grid for o in row)
    tables = {}
    for indoor, (label, count) in TABLES.items():
        a = _la.table(ctx, label, count, 4)
        tables[indoor] = a or []
    seen = {}                       # (indoor, object, pixels) -> index in found
    found = []
    limit = int(os.environ.get('TILE_OBJECTS_CONFIGS', '0'))      # (development: only the first few)
    for key in sorted(configs, key=str)[:limit or None]:
        g, mp, ts, anim, sv = key
        c = configs[key]
        ok = False
        for rg, rmp, room in c['rooms'][:3]:
            world.reset()
            if rg == 'ow':
                ok = world.load(False, 0, room)
            elif (rmp, rg, room) in pos_of:
                ok = world.load(True, rmp, 0, pos=pos_of[(rmp, rg, room)])
            else:
                ok = world.load(True, rmp, room)
            if ok and world.m.mem[_la.MAP_ROOM] == room:
                break
            ok = False
        if not ok:
            continue
        m = world.m
        mem, cpu = m.mem, m.cpu
        lcdc, bgp = mem[0xFF40], mem[0xFF47]
        indoor = g != 'ow'
        # the tiles of the background and their animation steps
        states, oam_tiles, map_tiles, oam_pal = [], set(), set(), {}
        for f in range(ANIM_FRAMES):
            m.run(1)
            states.append(bytes(mem[0x8800:0x9800]))
            if mem[0xFF40] & 2:
                for i in range(40):
                    y, _, t, at = mem[0xFE00 + 4 * i:0xFE04 + 4 * i]
                    if 0 < y < 160:
                        if i >= _la.LINK_OAM:
                            oam_tiles.update((t & 0xFE, t | 1))
                        for tt in (t & 0xFE, t | 1):
                            key = (tt, mem[0xFF49 if at & 0x10 else 0xFF48])
                            oam_pal[key] = oam_pal.get(key, 0) + 1
        last = bytes(mem[0x8000:0x9800])
        shadow = list(cpu.shadow[0x8000:0x9800])
        win_y = mem[0xFF4A]
        for row in range(18):
            for col in range(20):
                map_tiles.add(mem[0x9800 + 32 * row + col])
                if (mem[0xFF40] & 0x20) and 8 * row >= win_y:
                    map_tiles.add(mem[(0x9C00 if mem[0xFF40] & 0x40 else 0x9800) + 32 * ((8 * row - win_y) // 8) + col])
        changed = [t for t in range(256) if len({s[16 * t:16 * t + 16] for s in states}) > 1]
        anim_states = []
        for s in states:
            sig = b''.join(s[16 * t:16 * t + 16] for t in changed)
            if sig not in [a[0] for a in anim_states]:
                anim_states.append((sig, s))
        # origins of the VRAM tiles ($8000-$97FF): traced, else by contents
        vt = [last[16 * i:16 * i + 16] for i in range(384)]
        known = [sheets.traced(shadow, 16 * i) for i in range(384)]
        origin = sheets.match(vt, known)
        note_loaded(origin)
        # the animated tiles' steps come from their own ROM pages: take each step's origins by contents
        anim_origin = {}
        for sig, s in anim_states:
            tl = [s[16 * t:16 * t + 16] for t in range(256)]
            mo = sheets.match(tl)
            for t in changed:
                anim_origin.setdefault(t, []).append(mo[t])
            note_loaded([mo[t] for t in changed])

        def vt_index(t):            # BG tile number -> index in the $8000-$97FF tiles
            return bg_addr(t, lcdc) // 16

        objs = tables[indoor]
        for o in sorted(c['objects']):
            if o >= len(objs):
                continue
            tl, tr, bl, br = objs[o]
            cells = [tl, tr, bl, br]
            idx = [vt_index(t) for t in cells]
            anim_k = [k for k, i in enumerate(idx) if i - 128 in changed]
            nfr = len(anim_states) if anim_k else 1
            frames, uses, pieces = [], {}, []
            for fi in range(nfr):
                vr = bytearray(last)
                if anim_k:
                    vr[0x800:0x1800] = anim_states[fi][1]
                frames.append(draw_bg(vr, cells, 2, lcdc, bgp))
                fp = []
                for k, i in enumerate(idx):
                    orig = anim_origin[i - 128][fi] if k in anim_k else origin[i]
                    use(uses, orig)
                    o0 = orig[0] if orig else None
                    fp.append([8 * (k & 1), 8 * (k >> 1), sheets.list[o0[0]][0] if o0 else None,
                               o0[1] if o0 else None, 0, 0, 0])
                pieces.append(fp)
            # several frames with the same picture (an animation step its tiles do not take part in)
            uniq = []
            for f in frames:
                if f not in uniq:
                    uniq.append(f)
            pix = tuple(b''.join(bytes(r) for r in f) for f in uniq)
            where = ('overworld tile set ${:02X}'.format(ts) if not indoor else
                     'map ${:02X}, tile set ${:02X}{}'.format(mp, ts, ', side view' if sv else ''))
            if anim:
                where += ', animated tiles ${:02X}'.format(anim)
            k = (indoor, o, pix)
            if k in seen:
                found[seen[k]]['where'].append(where)
                continue
            seen[k] = len(found)
            found.append({'indoor': indoor, 'object': o, 'frames': uniq, 'uses': uses, 'pieces': pieces,
                          'where': [where]})
        # tiles drawn without a block: on the maps (beyond the room's objects) and in OAM
        block_tiles = set()
        for o in c['objects']:
            if o < len(objs):
                block_tiles.update(objs[o])
        for t in map_tiles - block_tiles:
            for si, k in origin[vt_index(t)] or ():
                by_code.setdefault(si, {}).setdefault(k, 'bg')
        for t in oam_tiles:
            for si, k in origin[t] or ():
                by_code.setdefault(si, {}).setdefault(k, 'oam')
        for (t, obp), n in oam_pal.items():
            for st in origin[t] or ():
                note_pal(st, obp, n)
        for t in map_tiles:
            PALS['bg'].update(origin[vt_index(t)] or ())
    for b in found:
        label, _ = TABLES[b['indoor']]
        add('block', '{} object ${:02X}'.format('Indoor' if b['indoor'] else 'Overworld', b['object']),
            '{} entry ${:02X}{}; seen with {}'.format(label, b['object'],
                                                      ' ({} animation steps)'.format(len(b['frames']))
                                                      if len(b['frames']) > 1 else '',
                                                      '; '.join(b['where'][:4]) +
                                                      (' and {} more'.format(len(b['where']) - 4)
                                                       if len(b['where']) > 4 else '')),
            b['frames'], b['uses'], b['pieces'], table=label)


def link_poses(ctx, rom, sheets, add):
    """Link's poses: two 8 x 16 halves per pose, the tiles LinkSpriteTiles + 16 x tile, flips from
    LinkPoseAttributes (UpdateLinkTiles copies them into sprite tiles 0-3, DrawLinkOAM places them)."""
    tiles = _la.table(ctx, 'LinkPoseTiles', 2 * 119)
    attrs = _la.table(ctx, 'LinkPoseAttributes', 2 * 119)
    si = sheets.by_name.get('LinkSpriteTiles')
    if not tiles or not attrs or si is None:
        return
    start = sheets.list[si][1]
    for p in range(119):
        vram = bytearray(0x1000)
        sprites, pieces, uses = [], [], {}
        for half in range(2):
            t = tiles[2 * p + half]
            vram[0x20 * half:0x20 * half + 0x20] = rom[start + 16 * t:start + 16 * t + 0x20]
            at = attrs[2 * p + half]
            sprites.append((8 * half, 0, 2 * half, at))
            uses.setdefault(si, set()).update((t, t + 1))
            pieces.append([8 * half, 0, 'LinkSpriteTiles', t, at >> 5 & 1, at >> 6 & 1, at >> 4 & 1])
            pieces.append([8 * half, 8, 'LinkSpriteTiles', t + 1, at >> 5 & 1, at >> 6 & 1, at >> 4 & 1])
        add('link', 'Link pose ${:02X}'.format(p),
            'LinkPoseTiles ${:02X}, ${:02X} / LinkPoseAttributes ${:02X}, ${:02X}'.format(
                tiles[2 * p], tiles[2 * p + 1], attrs[2 * p], attrs[2 * p + 1]),
            [draw_sprites(vram, sprites)], uses, [pieces], table='LinkPoseTiles')


def entity_frames(ctx, sheets, add, use, note_loaded):
    path = os.path.join(ctx.gen_dir, 'entities_frames.pkl')
    if not os.path.exists(path):        # (failing keeps this plugin from being cached without the entities)
        raise RuntimeError('entities_frames.pkl is missing: the entities plugin has not drawn its frames yet')
    data = pickle.load(open(path, 'rb'))
    vrams = data['vram']
    origin_of = {}
    for rec in data['tables']:
        frames, uses, pieces = [], {}, []
        for fr in rec['frames']:
            vram = vrams[fr['vram']]
            if fr['vram'] not in origin_of:
                o = sheets.match([vram[16 * i:16 * i + 16] for i in range(256)])
                origin_of[fr['vram']] = o
                note_loaded(o)
            org = origin_of[fr['vram']]
            sp = fr['sprites']
            if not sp:
                continue
            frames.append(draw_sprites(vram, sp))
            fp = []
            for x, y, t, at in sp:
                for half in range(2):
                    o = org[(t & 0xFE) + half]
                    use(uses, o)
                    o0 = o[0] if o else None
                    fp.append([x, y + 8 * half, sheets.list[o0[0]][0] if o0 else None, o0[1] if o0 else None,
                               at >> 5 & 1, at >> 6 & 1, at >> 4 & 1])
            pieces.append(fp)
        add('sprite', '${:02X} {}'.format(rec['type'], rec['name']),
            '{}, variants {}{}'.format(rec['table'] or '?', ', '.join(str(f['variant']) for f in rec['frames']),
                                       ' (the code\'s tables, not seen drawn)' if rec.get('guessed') else ''),
            frames, uses, pieces, link=rec['card'], table=rec['table'])


def layouts(ctx, rom, sheets, add, use, note_loaded):
    """The `oam` and `tilemap` data blocks that name their tile loader (tiles=...)."""
    from site_gen import resolve_value
    vram_of = {}
    for u in ctx.project.parsed.units:
        a = u.asset
        if not a or a.get('type') not in ('oam', 'tilemap') or 'tiles' not in a:
            continue
        spec = a['tiles'].split('|')[0]
        if spec not in vram_of:
            try:
                v = ctx.tileset(spec)
            except Exception:  # noqa: BLE001
                v = None
            o = sheets.match([v[16 * i:16 * i + 16] for i in range(384)]) if v else None
            vram_of[spec] = (v, o)
            if o:
                note_loaded(o)
        vram, org = vram_of[spec]
        if not vram:
            continue
        start = u.start
        if a['type'] == 'tilemap':
            w, h = int(a.get('width', 20)), int(a.get('height', 18))
            cells = list(rom[start:start + w * h])
            import build as engine
            mode = str(a.get('addressing', engine.GAME.get('tile_addressing', '8000')))
            lcdc = 0x00 if mode == '8800' else 0x10
            uses, fp = {}, []
            for i, t in enumerate(cells):
                o = org[bg_addr(t, lcdc) // 16]
                use(uses, o)
                o0 = o[0] if o else None
                fp.append([8 * (i % w), 8 * (i // w), sheets.list[o0[0]][0] if o0 else None,
                           o0[1] if o0 else None, 0, 0, 0])
            add('tilemap', u.name, 'tilemap {} x {} tiles'.format(w, h),
                [draw_bg(vram, cells, w, lcdc, 0xE4)], uses, [fp], table=u.name)
            continue
        n = resolve_value(ctx.project, a['length']) if 'length' in a else 0
        if not n:
            continue
        raw = rom[start:start + n]
        ents = [list(raw[i:i + 4]) for i in range(0, len(raw) - 3, 4)]
        per = max(1, resolve_value(ctx.project, a['frame']) // 4) if a.get('frame') else len(ents)
        tall = 'tall' in a
        frames, uses, pieces = [], {}, []
        for i in range(0, len(ents), per):
            sp = []
            for y, x, t, at in ents[i:i + per]:
                if [y, x, t, at] == [255, 255, 255, 255]:
                    continue
                if 'signed' in a:
                    y, x = (y - 256 if y >= 128 else y), (x - 256 if x >= 128 else x)
                sp.append((x, y, t, at))
            if not sp:
                continue
            frames.append(draw_sprites(vram, sp, tall))
            fp = []
            for x, y, t, at in sp:
                for half in range(2 if tall else 1):
                    o = org[((t & 0xFE) if tall else t) + half]
                    use(uses, o)
                    o0 = o[0] if o else None
                    fp.append([x, y + 8 * half, sheets.list[o0[0]][0] if o0 else None, o0[1] if o0 else None,
                               at >> 5 & 1, at >> 6 & 1, at >> 4 & 1])
            pieces.append(fp)
        add('oam', u.name, 'sprite layout, {} frame(s)'.format(len(frames)), frames, uses, pieces, table=u.name)


KIND_TEXT = {'block': 'blocks', 'link': 'Link\'s poses', 'sprite': 'entity sprite frames', 'oam': 'sprite layouts',
             'tilemap': 'tilemaps', 'screen': 'screens'}
KINDS = ('block', 'link', 'sprite', 'oam', 'tilemap', 'screen')


def pages(ctx, sheets, names, objects, loaded, by_code):
    out, rows, recs = [], [], []
    tpals = tile_palettes(sheets)
    per_sheet = {}
    for i, ob in enumerate(objects):
        for si in ob['uses']:
            per_sheet.setdefault(si, []).append(i)
    cats = {}
    for si, (name, start, n, folder, tall) in enumerate(sheets.list):
        idx = per_sheet.get(si, [])
        used = set()
        for i in idx:
            used |= {k for k in objects[i]['uses'][si] if k < n}
        reasons = {}
        for k in range(n):
            if k in used:
                continue
            r = by_code.get(si, {}).get(k) or ('loaded' if k in loaded.get(si, ()) else 'never')
            reasons.setdefault(r, []).append(k)
        cat = cats.setdefault(folder or '-', [0, 0, 0])
        cat[0] += 1
        cat[1] += n
        cat[2] += len(used)
        unused_text = '; '.join('{}: {}'.format(REASONS[r], ranges(ks)) for r, ks in sorted(reasons.items()))
        title = '{} objects'.format(name)
        sub = '{} object(s); {} of {} tiles used'.format(len(idx), len(used), n)
        kinds = {}
        for i in idx:
            kinds[objects[i]['kind']] = kinds.get(objects[i]['kind'], 0) + 1
        rows.append([{'asset': name, 'text': name}, folder or '-', n, len(used),
                     '{:.0f}%'.format(100.0 * len(used) / n) if n else '-',
                     {'asset': 'objects-' + name, 'text': ', '.join('{} {}'.format(v, KIND_TEXT[k])
                                                                     for k, v in sorted(kinds.items()))}
                     if idx else '-', unused_text or '-'])
        strip = sheet_strip(sheets, si, used, tpals.get(name))
        strip_marks = [{'x': tile_place(k, tall)[0], 'y': tile_place(k, tall)[1], 'w': 8, 'h': 8,
                        'label': 'tile ${:02X}'.format(k), 'text': REASONS[r]}
                       for r, ks in reasons.items() for k in ks]
        parts = [(strip, strip_marks)]
        for kind in KINDS:
            groups = []
            for i in idx:
                ob = objects[i]
                if ob['kind'] != kind:
                    continue
                own = sorted(k for k in ob['uses'][si] if k < n)
                mark = {'label': ob['label'], 'text': '{} - tiles {} of {}'.format(ob['text'], ranges(own), name)}
                if ob['link']:
                    mark.update(link=ob['link'], linkText='entity sheet')
                groups.append((ob['frames'], mark))
            if groups:
                parts.append(flow(groups))
        img, marks = stack(parts)
        doc = ['The objects the game assembles from the tiles of {}: {}. Each is drawn tile by tile as the game '
               'draws it, with its flips and palette (sprites in the palettes of play, colour 0 clear; blocks in '
               'the background palette), and in each of its frames (the variants of a sprite table, the steps of '
               'animated tiles). Screens are what the game showed (menus, scenes, the status bar) where they '
               'use tiles no table-made object covers. The sheet itself is at the top, sprite tiles in the '
               'palette the game draws them with most often; its tiles no object uses are checkered.'
               .format(name, ', '.join('{} {}'.format(v, KIND_TEXT[k]) for k, v in sorted(kinds.items()))
                       or 'none found')]
        if reasons:
            doc.append('Tiles no object uses: ' + unused_text + '.')
        if idx:
            out.append({'name': 'objects-' + name, 'type': 'image', 'title': title, 'unit': name,
                        'subtitle': sub, 'width': len(img[0]), 'height': len(img), 'scale': 2, 'packed': 'zlib',
                        'pixels': ctx.packed_pixels(img), 'colors': list(COLORS), 'fixedColors': True,
                        'marks': marks, 'doc': doc,
                        'users': sorted({objects[i]['table'] for i in idx if objects[i]['table']})[:12]})
    for ob in objects:
        recs.append({'kind': ob['kind'], 'label': ob['label'], 'table': ob['table'], 'text': ob['text'],
                     'sheets': sorted(sheets.list[si][0] for si in ob['uses']),
                     'frames': ob['pieces']})
    total = [sum(c[0] for c in cats.values()), sum(c[1] for c in cats.values()), sum(c[2] for c in cats.values())]
    cat_rows = [[f, c[0], c[1], c[2], '{:.0f}%'.format(100.0 * c[2] / c[1]) if c[1] else '-']
                for f, c in sorted(cats.items())]
    cat_rows.append(['all', total[0], total[1], total[2], '{:.0f}%'.format(100.0 * total[2] / total[1])
                     if total[1] else '-'])
    out.insert(0, {'name': 'tile-object-coverage', 'type': 'table', 'title': 'Tile sheets: objects and coverage',
                   'subtitle': '{} of {} tiles used by an object'.format(total[2], total[1]),
                   'columns': ['sheet', 'folder', 'tiles', 'used', 'share', 'objects', 'tiles no object uses'],
                   'rows': rows, 'tilePalettes': tpals,
                   'doc': ['Every tile sheet with the objects the game assembles from it (blocks of the rooms, '
                           'entity sprite frames, Link\'s poses, sprite layouts, tilemaps, and screens where they '
                           'show tiles nothing else uses) and how many of its tiles at least one of them uses. A '
                           'tile no object uses is named by what was found about it: drawn by code straight onto '
                           'the background or into a sprite, loaded into VRAM but not drawn by anything that ran '
                           'here, or never loaded.',
                           'The tile sheets of sprites are drawn in the sprite palette each tile is seen drawn with '
                           'most often (the sprite tables and the sprites on screen); tiles never seen drawn take '
                           'the sheet\'s most common palette, or OBP0.']})
    out.insert(1, {'name': 'tile-object-folders', 'type': 'table', 'title': 'Tile sheet coverage by folder',
                   'subtitle': '{:.0f}% of all tiles'.format(100.0 * total[2] / total[1]) if total[1] else '',
                   'columns': ['folder', 'sheets', 'tiles', 'used by an object', 'share'], 'rows': cat_rows,
                   'doc': ['The share of the tiles of each folder of tile sheets that at least one assembled '
                           'object uses.']})
    out.append(_la.export(ctx, 'tile-objects', 'Objects of the tile sheets (download)', recs,
                          'Every assembled object: its kind (block, entity sprite frame, Link pose, sprite layout, '
                          'tilemap), the table entry it comes from and, per frame, its pieces as [x, y, sheet, '
                          'tile, x flip, y flip, palette] - 8 x 8 pieces, x and y in pixels from the object\'s '
                          'origin (sheet null: a tile not found in any sheet).'))
    return out


def ranges(ks):
    ks = sorted(ks)
    out, i = [], 0
    while i < len(ks):
        j = i
        while j + 1 < len(ks) and ks[j + 1] == ks[j] + 1:
            j += 1
        out.append('${:02X}'.format(ks[i]) if i == j else '${:02X}-${:02X}'.format(ks[i], ks[j]))
        i = j + 1
    return ', '.join(out) or '-'
