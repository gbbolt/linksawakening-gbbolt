"""The screen layouts of BGMapPointers: every background the game draws from a list of draw commands (menus, the
island map, the intro, the ending and credits scenes, ...), each drawn by the game's own routines with the tile set
the code loads together with it."""
import os
import pickle
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'screens'
TILEMAP, BGMAP = 0xD6FE, 0xD6FF        # wTileMapToLoad, wBGMapToLoad
COUNT = 37
AFTER = 40                              # frames after the game draws a layout until its tiles are taken
SAME_TILES = {0x04: 0x03, 0x06: 0x05, 0x0C: 0x05, 0x1D: 0x1C,     # layouts shown with the tiles another one was
              0x1E: 0x20, 0x1F: 0x20, 0x21: 0x20, 0x22: 0x20}
# seen with (the file menu with saved files, the erase and copy screens use the tiles of the file menus; $1D is
# the same data as $1C; the five pictures of the memories ($20, $1E, $22, $21, $1F) all show over the tile set
# that MemoryScene1's scene loads with the first one)
UNKNOWN_TILES = {0x12, 0x23, 0x24}   # neither seen drawn nor loaded next to the request: drawn over
# the wrong tiles they would only show garbage
SET_TILEMAP = re.compile(r'^\s*ld \[wTileMapToLoad\], a')
SET_BGMAP = re.compile(r'^\s*ld \[wBGMapToLoad\], a')
LD_A = re.compile(r'^\s*ld a, \$([0-9a-fA-F]{2})\s*(;.*)?$')
LABEL = re.compile(r'^([A-Za-z_]\w*)::')


def requests():
    """For each layout: [(unit, tile set loaded with it or None)] from the code that requests it."""
    import glob
    import build as engine
    out = {}
    for f in sorted(glob.glob(os.path.join(engine.SRC, '*.asm'))):
        lines = open(f, encoding='utf-8', errors='replace').read().split('\n')
        unit, last_a, tiles = None, None, []         # tiles: (line, value)
        bgs = []
        for i, line in enumerate(lines):
            m = LABEL.match(line)
            if m:
                unit = m.group(1)
            m = LD_A.match(line)
            if m:
                last_a = int(m.group(1), 16)
                continue
            if SET_TILEMAP.match(line) and last_a is not None:
                tiles.append((i, last_a))
            elif SET_BGMAP.match(line) and last_a is not None:
                bgs.append((i, last_a, unit))
            elif line.strip() and not line.lstrip().startswith(';'):
                if re.match(r'^\s*(call|jp|jr|ret|ld a|xor a|inc a|dec a|pop af|and|or|add|sub|ldh a)', line):
                    last_a = None
        for i, n, unit in bgs:
            near = [(abs(j - i) + (0 if j < i else 40), v) for j, v in tiles if abs(j - i) < 150 and v]
            t = min(near)[1] if near else None
            out.setdefault(n, []).append((unit, t))
    return out


RETURN = 0xFEA0                        # an unused address: the routine returns there (not $0000: rst $00 jumps there)


def call(m, addr, a=0, limit=3000000):
    """Run the routine at addr like a call from the main loop (no interrupts), with the LCD lines going on."""
    cpu = m.cpu
    cpu.a = a
    cpu.ime = False
    cpu.push(RETURN)
    cpu.pc = addr
    n = 0
    while cpu.pc != RETURN and n < limit:
        cpu.step()
        n += 1
        if n % m.LINE_STEPS == 0:
            m._next_line()
    return cpu.pc == RETURN


def captures(ctx):
    """layout -> (VRAM tiles $8000-$97FF, LCDC) as they were AFTER frames after the game itself drew that layout
    (DrawRequestedBGMap) - by then its scene has loaded the tile sets that go with it. The game is played from
    power-on through its opening and the title into the file menu and the name entry, and in the world the
    island map is opened."""
    from _game import Machine, A, START, SELECT
    rom, out = ctx.rom, {}
    drq = ctx.syms['DrawRequestedBGMap'] & 0xFFFF

    def watch(m):
        pending = []
        cpu = m.cpu
        orig = type(cpu).step

        def step(cpu=cpu):
            if cpu.pc == drq:
                pending.append((m.frame + AFTER, m.mem[BGMAP]))
            orig(cpu)
        cpu.step = step

        def on_frame(mm):
            for due, n in list(pending):
                if mm.frame >= due:
                    pending.remove((due, n))
                    out.setdefault(n, (bytes(mm.mem[0x8000:0x9800]), mm.mem[0xFF40], bytes(mm.mem[0x9800:0xA000])))
        m.on_frame = on_frame

    m = Machine(rom)
    watch(m)
    for _ in range(6000):
        m.run(1)
        if m.mem[_la.GAMEPLAY_TYPE] == 0 and m.mem[_la.GAMEPLAY_SUBTYPE] >= 8:
            break
    m.run(60)
    # the title screen ($11) is on: its layout is drawn outside DrawRequestedBGMap's entry
    out.setdefault(0x11, (bytes(m.mem[0x8000:0x9800]), m.mem[0xFF40], bytes(m.mem[0x9800:0xA000])))
    for btn, mode in ((START, 2), (A, 3)):
        for _ in range(40):
            if m.mem[_la.GAMEPLAY_TYPE] == mode:
                break
            m.press(btn, 4, 8)
        m.run(AFTER + 20)
    world = _la.World(rom)
    m = world.m
    watch(m)
    m.run(30)
    for _ in range(6):
        m.press(SELECT, 4, 4)
        if m.mem[_la.GAMEPLAY_TYPE] == 7:
            break
    m.run(AFTER + 40)
    return out


def bg_picture(mem, base, cells, lcdc, keep=False):
    """keep: cells the layout leaves alone show what the screen had there (its scene's own background); else blank."""
    x0 = min(c % 32 for c in cells)
    y0 = min(c // 32 for c in cells)
    x1 = max(c % 32 for c in cells) + 1
    y1 = max(c // 32 for c in cells) + 1
    img = [bytearray(8 * (x1 - x0)) for _ in range(8 * (y1 - y0))]
    cells = set(cells)
    for ty in range(y0, y1):
        for tx in range(x0, x1):
            if not keep and 32 * ty + tx not in cells:       # not written by the layout: left blank
                continue
            t = mem[base + 32 * ty + tx]
            a = 0x8000 + 16 * t if lcdc & 0x10 else 0x9000 + 16 * (t - 256 if t >= 128 else t)
            for r in range(8):
                lo, hi = mem[a + 2 * r], mem[a + 2 * r + 1]
                row = img[8 * (ty - y0) + r]
                for x in range(8):
                    row[8 * (tx - x0) + x] = ((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1)
    return img, (x0, y0)


def build(ctx):
    rom = ctx.rom
    syms = ctx.syms
    names = _la.Names(ctx)
    req = requests()
    world = _la.World(rom)
    start = pickle.dumps(world.m)
    ptrs = _la.table(ctx, 'BGMapPointers', COUNT, 2) or []
    out, rows = [], []
    caps = captures(ctx)
    static_t = {n: next((tt for _, tt in req.get(n, []) if tt), None) for n in range(COUNT)}
    for n in range(1, COUNT):
        p = ptrs[n][0] | ptrs[n][1] << 8 if n < len(ptrs) else 0
        who = req.get(n, [])
        src_n = n if n in caps else SAME_TILES.get(n, n)
        cap = caps.get(src_n)
        t = static_t[src_n] if cap is None else static_t[n] if src_n != n else None
        runs = []
        for fill in (None, 0x00, 0xFF):
            m = pickle.loads(start)
            if t:
                call(m, syms['RunTileMapLoader'], a=t)
            if fill is not None:
                m.mem[0x9800:0xA000] = bytes([fill]) * 0x800
            elif cap is not None and (src_n == n or not t):     # the cells it leaves alone as the game had them
                m.mem[0x9800:0xA000] = cap[2]
            m.mem[BGMAP] = n
            ok = call(m, syms['DrawRequestedBGMap'])
            runs.append((m, ok))
        real = runs[0][0]
        a0, a1 = runs[1][0].mem, runs[2][0].mem
        written = [i for i in range(0x800) if a0[0x9800 + i] == a1[0x9800 + i]]
        label = names.at(8, p) if p >= 0x4000 else None
        users = sorted(set(u for u, _ in who if u))
        unit_cells = [{'text': u, 'code': u} for u in users]
        if not written or not runs[0][1]:
            rows.append(['${:02X}'.format(n), {'text': label, 'code': label} if label else '${:04X}'.format(p),
                         unit_cells or '-', '-', 'not drawn (built at run time)' if p >= 0x8000 else 'not drawn'])
            continue
        hi = [i for i in written if i >= 0x400]
        base, cells = (0x9C00, [i - 0x400 for i in hi]) if len(hi) > len(written) // 2 else \
            (0x9800, [i for i in written if i < 0x400])
        lcdc = real.mem[0xFF40]
        if cap is not None:                     # the tiles the game had loaded when it showed this layout
            real.mem[0x8000:0x9800] = cap[0]
            lcdc = cap[1]
        img, (x0, y0) = bg_picture(real.mem, base, cells, lcdc, keep=cap is not None and (src_n == n or not t))
        cs = set(cells)
        flat = b''.join(bytes(img[8 * (c // 32 - y0) + r][8 * (c % 32 - x0):8 * (c % 32 - x0) + 8])
                        for c in cs for r in range(8))        # the pixels of the cells the layout writes
        if cap is None and n in UNKNOWN_TILES:
            rows.append(['${:02X}'.format(n), {'text': label, 'code': label} if label else '${:04X}'.format(p),
                         unit_cells or '-', '-', 'not drawn: the tile set its scene loads with it is not known'])
            continue
        if max(flat.count(bytes([k])) for k in range(4)) > 0.95 * len(flat):
            rows.append(['${:02X}'.format(n), {'text': label, 'code': label} if label else '${:04X}'.format(p),
                         unit_cells or '-', '${:02X}'.format(t) if t else '-',
                         'not drawn: its tiles are loaded by its scene, not found next to the request'])
            continue
        name = 'layout-{:02x}'.format(n)
        part = {'name': name, 'type': 'image', 'width': len(img[0]), 'height': len(img), 'scale': 2,
                'packed': 'zlib', 'pixels': ctx.packed_pixels(img), 'colors': list(COLORS), 'fixedColors': True,
                'title': 'Screen layout ${:02X}'.format(n), 'unit': label or 'BGMapPointers',
                'subtitle': '{} tiles drawn; map ${:04X}, from column {}, row {}'.format(len(cells), base, x0, y0),
                'doc': ['Screen layout ${:02X} of BGMapPointers ({}, bank $08): its draw commands as '
                        'DrawRequestedBGMap draws them{}. Requested by {}. The picture shows the part of the '
                        'background map the commands write (cells inside it they leave alone stay blank), in the '
                        'plain shades of the tiles.'.format(n, label or '${:04X}'.format(p),
                                        ', over tile set ${:02X} of TileMapLoaders'.format(t) if t else
                                        ', with the tiles its scene had loaded when the game showed it'
                                        if cap is not None else '',
                                        ', '.join(users) or 'no code found')],
                'users': (users + ['BGMapPointers', 'DrawRequestedBGMap'])[:10]}
        out.append(part)
        rows.append([{'asset': name, 'text': '${:02X}'.format(n)},
                     {'text': label, 'code': label} if label else '${:04X}'.format(p), unit_cells or '-',
                     '${:02X}'.format(t) if t else '-', {'image': dict(part, scale=1)}])
    out.insert(0, {'name': 'screen-layouts', 'type': 'table', 'title': 'Screen layouts', 'unit': 'BGMapPointers',
                   'subtitle': '{} layouts'.format(COUNT - 1),
                   'columns': ['layout', 'data', 'requested by', 'tile set', 'picture'], 'rows': rows,
                   'doc': ['Every entry of BGMapPointers: the screen layout (a list of background draw commands in '
                           'bank $08), the code that requests it through wBGMapToLoad, the tile set the same code '
                           'loads with it (wTileMapToLoad, TileMapLoaders) and the layout as the game\'s own '
                           'DrawRequestedBGMap draws it. Entry 7 is a list the game builds in RAM.']})
    return out
