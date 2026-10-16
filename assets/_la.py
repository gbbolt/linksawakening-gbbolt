"""Shared helpers of the Link's Awakening asset plugins: getting the game from power-on into the world, letting
the game's own world loader build any room (so rooms come out exactly as the game draws them), and reading the
room and entity data of the ROM."""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import Machine, A, START  # noqa: E402

GAMEPLAY_TYPE = 0xDB95          # wGameplayType
GAMEPLAY_SUBTYPE = 0xDB96       # wGameplaySubtype
IS_INDOOR = 0xDBA5              # wIsIndoor
MAP_ID = 0xFFF7                 # hMapId
MAP_ROOM = 0xFFF6               # hMapRoom
DUNGEON_POS = 0xDBAE            # position of the room in the dungeon's 8 x 8 layout
DIALOG_STATE = 0xC19F           # wDialogState: nonzero while a text box is open
ROOM_OBJECTS = 0xD711           # the room's 10 x 8 objects, rows 16 bytes apart
WORLD = 0x0B                    # wGameplayType of the world (playing)
PLAYING = 0x07                  # its last step: the room is built and the game runs
LINK_OAM = 12                   # OAM entries 0-11 hold Link and his items; the entities' sprites follow
LOADED_ENTITY_TILESETS = 0xC193  # wLoadedEntityTilesets: the tile set in each of the 4 entity tile slots
ENTITY_TILE_BANKS = (1, 0x11, 0x0E, 0x12)   # EntityTilesBanks by bits 6-7 of a set (bank 0 reads as bank 1)
IS_SIDE_SCROLLING = 0xFFF9      # hIsSideScrolling: 2 in the side-view places


def lin(bank, addr):
    return addr if addr < 0x4000 else bank * 0x4000 + addr - 0x4000


# ---------------------------------------------------------------- the machine
def boot(rom):
    """A Machine that ran from power-on through the title screen and a new save file into the world
    (Link wakes up in Marin's house). Buttons are pressed only to get there; nothing of it is shown."""
    m = Machine(rom)
    mem = m.mem

    def until(cond, press, limit):
        for _ in range(limit):
            if cond():
                return
            if press:
                m.press(press, 4, 8)
            else:
                m.run(1)
        raise RuntimeError('boot: stuck in mode %02X/%02X' % (mem[GAMEPLAY_TYPE], mem[GAMEPLAY_SUBTYPE]))

    until(lambda: mem[GAMEPLAY_TYPE] == 0 and mem[GAMEPLAY_SUBTYPE] >= 8, None, 6000)   # the title screen
    m.run(30)
    until(lambda: mem[GAMEPLAY_TYPE] == 2, START, 40)          # the file menu
    m.run(30)
    until(lambda: mem[GAMEPLAY_TYPE] == 3, A, 40)              # a new file: name entry
    m.run(20)
    m.press(A, 4, 8)                                          # one letter
    until(lambda: mem[GAMEPLAY_TYPE] == 2, START, 40)          # name done, back to the menu
    m.run(30)
    until(lambda: mem[GAMEPLAY_TYPE] == WORLD, A, 40)          # start the game
    until(lambda: mem[GAMEPLAY_SUBTYPE] == PLAYING, None, 600)
    load_room(m, False, 0, 0xA2, settle=60)                  # once outside, so the screen has faded in
    return m


def load_room(m, indoor, map_id=0, room=0, pos=None, settle=6, limit=400, link=(0x50, 0x48)):
    """Let the game load a room the way a warp does: set the destination and restart the world mode at its
    first step; it loads the tiles, builds the room from its data, spawns its entities and draws it.
    Dungeons (maps $00-$0A) are entered by the room's position in the dungeon layout (pos).
    link: where Link enters (x, y in pixels)."""
    mem = m.mem
    target = room
    if indoor and pos is not None and map_id <= 0x0A:
        target = m.rom[lin(0x14, 0x4200 + 64 * map_id + pos)]
    g = group_of_map(map_id) if indoor else 'ow'
    # A side-view room is one a warp of type 2 leads to; that warp sets hIsSideScrolling, and with it the tile loader
    # copies the side-view tiles (SideViewTiles / DungeonSideViewTiles) instead of the room's top-down tile set.
    mem[IS_SIDE_SCROLLING] = 2 if indoor and (g, target) in side_view_rooms(m.rom) else 0
    mem[IS_INDOOR] = 1 if indoor else 0
    mem[MAP_ID] = map_id
    mem[MAP_ROOM] = room
    mem[0xDB9D], mem[0xDB9E] = link
    if pos is not None:
        mem[DUNGEON_POS] = pos
    mem[DIALOG_STATE] = 0
    mem[GAMEPLAY_TYPE] = WORLD
    mem[GAMEPLAY_SUBTYPE] = 0
    for _ in range(limit):
        m.run(1)
        if mem[GAMEPLAY_TYPE] == WORLD and mem[GAMEPLAY_SUBTYPE] == PLAYING:
            break
    else:
        return False
    # The entity tile slots a room keeps ($FF in its graphics set) hold what the rooms before it loaded when one
    # walks in; a warp-style load starts them empty. Fill them as the nearest room that sets them would have
    # (entity_sets_for), copying the tile sets into their slots the way tile set request 9 (LoadTileset09) does.
    own = room_entity_sets(m.rom, g, target)
    for k, s in enumerate(entity_sets_for(m.rom, g, target)):
        if own[k] == 0xFF and s != 0xFF:
            mem[LOADED_ENTITY_TILESETS + k] = s
            src = ENTITY_TILE_BANKS[s >> 6] * 0x4000 + ((s & 0x3F) << 8)
            mem[0x8400 + 0x100 * k:0x8500 + 0x100 * k] = m.rom[src:src + 0x100]
    m.run(settle)
    return True


class World:
    """A booted Machine that loads rooms; when a room's code stops the machine (some rooms crash when entered out
    of their story context), it goes back to the state after booting."""
    def __init__(self, rom):
        import pickle
        self.m = boot(rom)
        self.saved = pickle.dumps(self.m)

    def reset(self):
        import pickle
        self.m = pickle.loads(self.saved)

    def load(self, *args, **kw):
        import pickle
        try:
            return load_room(self.m, *args, **kw)
        except RuntimeError:
            self.m = pickle.loads(self.saved)
            return False


def room_picture(m, sprites=True, height=128):
    """The room area of the screen (160 x 128, above the status bar) as shades 0-3, with the entities'
    sprites but without Link."""
    if sprites:
        saved = bytes(m.mem[0xFE00:0xFE00 + 4 * LINK_OAM])
        m.mem[0xFE00:0xFE00 + 4 * LINK_OAM] = bytes(4 * LINK_OAM)
        img = m.screen(True)
        m.mem[0xFE00:0xFE00 + 4 * LINK_OAM] = saved
    else:
        img = m.screen(False)
    return [bytearray(r) for r in img[:height]]


def room_objects(m):
    """The 8 rows of 10 objects the loader built in RAM."""
    return [[m.mem[ROOM_OBJECTS + 16 * y + x] for x in range(10)] for y in range(8)]


# ---------------------------------------------------------------- the ROM's room data
GROUPS = {                      # room group -> (pointer bank, label prefix)
    'ow': (0x09, 'Overworld'),
    'A': (0x0A, 'IndoorA'),
    'B': (0x0B, 'IndoorB'),
}
ENTITY_TABLES = {'ow': 0x4000, 'A': 0x4200, 'B': 0x4400}       # in bank $16
TILESET_TABLES = {'A': 0x4040, 'B': 0x4140}                    # in bank $08 (indoor; one byte per room)
SPRITESET_IDS = {'ow': 0x4240, 'A': 0x4340, 'B': 0x4440}       # in bank $08
WARP_TYPES = {0: 'to the overworld', 1: 'indoors', 2: 'side view', 3: 'to the overworld (3)'}


def group_of_map(map_id):
    """Indoor maps $06-$19 keep their rooms in bank $0B (group B), the others in bank $0A (group A)."""
    return 'B' if 0x06 <= map_id < 0x1A else 'A'


class RoomData:
    def __init__(self, rom):
        self.rom = rom

    def word(self, bank, addr):
        a = lin(bank, addr)
        return self.rom[a] | self.rom[a + 1] << 8

    def address(self, g, room):
        """(bank, address) of a room's data."""
        bank = GROUPS[g][0]
        p = self.word(bank, 0x4000 + 2 * room)
        if g == 'ow' and room >= 0x80:
            bank = 0x1A
        return bank, p

    def parse(self, g, room, addr=None):
        """The room's header and object list: {'anim', 'floor', 'template', 'objects', 'warps', 'size'}.
        objects: (x, y, object, 'strip' text or None) in 16-pixel cells; warps: (type, map, room, x, y)."""
        bank, p = addr or self.address(g, room)
        r = self.rom
        a = lin(bank, p)
        start = a
        out = {'bank': bank, 'addr': p, 'anim': r[a], 'objects': [], 'warps': []}
        if r[a] == 0xFE:                        # a room without objects
            out['floor'], out['template'], out['size'] = None, None, 1
            return out
        if g == 'ow':
            out['floor'], out['template'] = r[a + 1], None
        else:
            out['floor'], out['template'] = r[a + 1] & 0x0F, r[a + 1] >> 4
        a += 2
        for _ in range(400):
            b = r[a]
            if b == 0xFE:
                break
            if b & 0xFC == 0xE0:
                out['warps'].append((b & 3, r[a + 1], r[a + 2], r[a + 3], r[a + 4]))
                a += 5
            elif b & 0x80 and not b & 0x10:
                pos = r[a + 1]
                out['objects'].append((pos & 15, pos >> 4, r[a + 2],
                                       '{} x {}'.format('down' if b & 0x40 else 'across', b & 0x0F)))
                a += 3
            else:
                out['objects'].append((b & 15, b >> 4, r[a + 1], None))
                a += 2
        out['size'] = a + 1 - start
        return out

    def entities(self, g, room):
        """(x, y, type) of the room's entities (16-pixel cells)."""
        p = self.word(0x16, ENTITY_TABLES[g] + 2 * room)
        a = lin(0x16, p)
        out = []
        while self.rom[a] != 0xFF and len(out) < 16:
            yx, t = self.rom[a], self.rom[a + 1]
            out.append((yx & 15, yx >> 4, t))
            a += 2
        return out

    def entity_list_addr(self, g, room):
        return self.word(0x16, ENTITY_TABLES[g] + 2 * room)

    def tileset(self, g, room):
        if g == 'ow':
            r = 8 if room == 7 else room
            return self.rom[lin(8, 0x4000 + ((r >> 2) & 0xF8 | (r >> 1) & 7))]
        return self.rom[lin(8, TILESET_TABLES[g] + room)]

    def spriteset(self, g, room):
        return self.rom[lin(8, SPRITESET_IDS[g] + room)]


SPRITESETS = {'ow': 0x4540, 'A': 0x4788, 'B': 0x4788}   # bank $08: OverworldSpritesets, IndoorSpritesets
_LINKS = {}


def room_entity_sets(rom, g, room):
    """The 4 entity tile sets of a room's graphics set ($FF = keep what the slot holds)."""
    grp = rom[lin(8, SPRITESET_IDS[g] + room)]
    a = lin(8, SPRITESETS[g] + 4 * grp)
    return list(rom[a:a + 4])


def _room_links(rom):
    """(group, room) -> the rooms one walks in from: the overworld grid, the dungeon layouts and the warps."""
    if _LINKS:
        return _LINKS
    links = {}

    def link(a, b):
        links.setdefault(a, []).append(b)
        links.setdefault(b, []).append(a)
    for r in range(256):
        if r % 16 < 15:
            link(('ow', r), ('ow', r + 1))
        if r < 240:
            link(('ow', r), ('ow', r + 16))
    for mp in range(0x0B):
        base = lin(0x14, 0x4200 + 64 * mp)
        g = group_of_map(mp)
        for pos in range(64):
            if not rom[base + pos]:
                continue
            if pos % 8 < 7 and rom[base + pos + 1]:
                link((g, rom[base + pos]), (g, rom[base + pos + 1]))
            if pos < 56 and rom[base + pos + 8]:
                link((g, rom[base + pos]), (g, rom[base + pos + 8]))
    rd = RoomData(rom)
    for g in ('ow', 'A', 'B'):
        for r in range(256):
            try:
                warps = rd.parse(g, r)['warps']
            except IndexError:
                continue
            for t, mp, room, _, _ in warps:
                link((g, r), ('ow', room) if t == 0 else (group_of_map(mp), room))
    _LINKS.update(links)
    return _LINKS


_SIDE = set()


def side_view_rooms(rom):
    """(group, room) of every side-view room: the destinations of the warps of type 2."""
    if not _SIDE:
        rd = RoomData(rom)
        for g in ('ow', 'A', 'B'):
            for r in range(256):
                try:
                    warps = rd.parse(g, r)['warps']
                except IndexError:
                    continue
                _SIDE.update((group_of_map(mp), room) for t, mp, room, _, _ in warps if t == 2)
    return _SIDE


def entity_sets_for(rom, g, room):
    """The 4 entity tile sets a room shows: its own, and for the slots it keeps those of the nearest room (walking
    through the overworld grid, the dungeon layout or warps) that sets them."""
    sets = room_entity_sets(rom, g, room)
    if 0xFF not in sets:
        return sets
    links = _room_links(rom)
    seen, queue = {(g, room)}, [(g, room)]
    while queue and 0xFF in sets:
        nxt = []
        for node in queue:
            for nb in links.get(node, []):
                if nb in seen:
                    continue
                seen.add(nb)
                nxt.append(nb)
                other = room_entity_sets(rom, *nb)
                for k in range(4):
                    if sets[k] == 0xFF and other[k] != 0xFF:
                        sets[k] = other[k]
        queue = nxt
    return sets


CHEST = 0xA0                    # the object of a closed chest
ROOM_INFO = 0x4500              # bank $14: one byte per room (overworld, group A, group B): a chest's content
CHEST_CONTENTS = ['Power Bracelet', 'shield', 'bow', 'hookshot', 'Fire Rod', 'Pegasus Boots', 'Ocarina',
                  'feather', 'shovel', 'magic powder', 'bombs', 'sword']
RUPEES = {0x1B: 50, 0x1C: 20, 0x1D: 100, 0x1E: 200, 0x1F: 500}


def chest_content(rom, g, room):
    return rom[lin(0x14, ROOM_INFO + {'ow': 0, 'A': 0x100, 'B': 0x200}[g] + room)]


def chest_content_name(c):
    if c < len(CHEST_CONTENTS):
        return CHEST_CONTENTS[c]
    if c in RUPEES:
        return '{} rupees'.format(RUPEES[c])
    if 0x0C <= c <= 0x15:
        return 'counter item ${:02X}'.format(c)
    if 0x16 <= c <= 0x1A:
        return 'dungeon item ${:02X}'.format(c)
    return 'content ${:02X}'.format(c)


def dialog_text(rom, n):
    """Dialog n as one line of text (box lines joined with spaces)."""
    p = rom[lin(0x1C, 0x4001 + 2 * n)] | rom[lin(0x1C, 0x4002 + 2 * n)] << 8
    bank = rom[lin(0x1C, 0x46E1 + n)] & 0x1F
    if p < 0x4000:
        return ''
    a, s = lin(bank, p), ''
    for k in range(1200):
        c = rom[a + k]
        if c in (0xFE, 0xFF):
            break
        if k and k % 16 == 0:
            s += ' '
        s += "'" if c == 0x5E else chr(c) if 0x20 <= c < 0x7F else ''
    return re.sub(' +', ' ', s.replace('#####', '[NAME]')).strip()


class ChestNames:
    """What each chest content is, from the dialog the game shows when it comes out (ChestItemTexts)."""
    def __init__(self, ctx):
        self.texts = table(ctx, 'ChestItemTexts', 0x22) or []
        self.rom = ctx.rom

    def text(self, c):
        return dialog_text(self.rom, self.texts[c]) if c < len(self.texts) else ''

    def name(self, c):
        t = self.text(c)
        if not t:
            return chest_content_name(c)
        first = re.split(r'(?<=[!.?])\s', t)[0]
        return first if len(first) < 70 else first[:67] + '...'


def export(ctx, name, title, records, text):
    """Write records (a list of flat-ish dicts) as <name>.json and <name>.csv next to the site and return a
    card that lists both files (group 'downloads')."""
    import csv
    import json
    jpath, jurl = ctx.file(name + '.json')
    with open(jpath, 'w', encoding='utf-8') as f:
        json.dump(records, f, indent=1, ensure_ascii=False)
    cpath, curl = ctx.file(name + '.csv')
    cols = []
    for r in records:
        for k in r:
            if k not in cols:
                cols.append(k)
    with open(cpath, 'w', encoding='utf-8', newline='') as f:
        w = csv.writer(f)
        w.writerow(cols)
        for r in records:
            w.writerow([json.dumps(v, ensure_ascii=False) if isinstance(v, (list, dict)) else v
                        for v in (r.get(k, '') for k in cols)])
    return {'name': 'download-' + name, 'type': 'card', 'group': 'downloads', 'title': title,
            'subtitle': '{} records'.format(len(records)),
            'sections': [{'title': 'Files', 'columns': ['file', 'format'],
                          'rows': [[{'text': jurl, 'href': jurl}, 'JSON'], [{'text': curl, 'href': curl}, 'CSV']]},
                         {'title': 'Columns', 'chips': cols, 'wide': True}],
            'doc': [text + ' The same records as JSON ({}) and CSV ({}; lists and objects in a cell are written as '
                    'JSON).'.format(jurl, curl)]}


_SOUND_NAMES = []


def music_cell(ctx, track):
    """A table cell that plays music track `track` (with its name from src/sound.json)."""
    if not track:
        return '-'
    if not _SOUND_NAMES:
        import json
        import build as engine
        try:
            cfg = json.load(open(os.path.join(engine.SRC, 'sound.json'), encoding='utf-8'))
            _SOUND_NAMES.append(cfg.get('names', {}))
        except Exception:  # noqa: BLE001
            _SOUND_NAMES.append({})
    name = _SOUND_NAMES[0].get('music %d' % track, ['', ''])[0]
    return {'sound': 'music %d' % track, 'text': '${:02X} {}'.format(track, name).strip()}


def find_chests(grid):
    return [(x, y) for y, row in enumerate(grid) for x, o in enumerate(row) if o == CHEST]


# ---------------------------------------------------------------- the source: unit folders and code
class Source:
    """The units of the disassembly's source files: folder (;@ path), first line of the description and
    the body lines (to find what a handler's code does, e.g. which dialogs it opens)."""
    LABEL = re.compile(r'^([A-Za-z_]\w*)::')

    def __init__(self):
        import glob
        import build as engine
        self.units = {}
        for f in sorted(glob.glob(os.path.join(engine.SRC, '*.asm'))):
            head, cur = [], None
            for line in open(f, encoding='utf-8', errors='replace'):
                line = line.rstrip('\n')
                mm = self.LABEL.match(line)
                if mm:
                    path = next((h[9:].strip() for h in head if h.startswith(';@ path:')), '')
                    doc = ' '.join(h[3:].strip() for h in head if h.startswith(';@ ') and not re.match(
                        r';@ (path|def|test|asset|reads|writes|sig)\b', h))
                    cur = self.units[mm.group(1)] = {'path': path, 'doc': doc, 'body': [], 'file': os.path.basename(f)}
                    head = []
                elif line.startswith(';@'):
                    head.append(line)
                elif cur is not None:
                    cur['body'].append(line)

    def path(self, name):
        u = self.units.get(name)
        return u['path'] if u else ''

    def folder_units(self, folder):
        return [n for n, u in self.units.items() if u['path'] == folder or u['path'].startswith(folder + '/')]


def table(ctx, label, count, size=1):
    """count records of size bytes at a label (None when the label does not exist)."""
    try:
        import build as engine
        a = engine.sym_linear(label, ctx.syms)
    except Exception:  # noqa: BLE001
        return None
    if a is None:
        return None
    return [bytes(ctx.rom[a + size * i:a + size * (i + 1)]) if size > 1 else ctx.rom[a + i] for i in range(count)]


# ---------------------------------------------------------------- names from the disassembly
GENERIC = re.compile(r'^(Call|Jump|jr|JumpTable|Data|data|Unknown)_')


class Names:
    """Labels of the disassembly by ROM location (for links and entity names)."""
    def __init__(self, ctx):
        self.ctx = ctx
        self.by_lin = {}
        try:
            import build as engine
            for name in ctx.syms:
                if '.' in name:
                    continue
                try:
                    a = engine.sym_linear(name, ctx.syms)
                except Exception:  # noqa: BLE001
                    continue
                if a is not None:
                    self.by_lin.setdefault(a, name)
        except Exception:  # noqa: BLE001
            pass

    def at(self, bank, addr):
        return self.by_lin.get(lin(bank, addr))

    def extent(self, a):
        """(label, start, end) of the labelled block holding linear address a (end = the next label)."""
        import bisect
        if not hasattr(self, '_sorted'):
            self._sorted = sorted(self.by_lin)
        i = bisect.bisect_right(self._sorted, a) - 1
        if i < 0:
            return None, a, a + 1
        start = self._sorted[i]
        end = self._sorted[i + 1] if i + 1 < len(self._sorted) else start + 0x4000
        end = min(end, (start // 0x4000 + 1) * 0x4000)
        return self.by_lin[start], start, end

    def entity_handler(self, t):
        rom = self.ctx.rom
        bank = rom[lin(3, 0x4000 + t)]
        addr = rom[0x3953 + 2 * t] | rom[0x3954 + 2 * t] << 8
        return self.at(bank, addr), bank, addr

    def entity_name(self, t):
        label, _, _ = self.entity_handler(t)
        if not label or GENERIC.match(label):
            return 'Entity ${:02X}'.format(t)
        n = re.sub(r'(Handler|Entity|Init)$', '', label)
        n = re.sub(r'^Entity', '', n) or label
        return re.sub(r'(?<=[a-z0-9])(?=[A-Z])', ' ', n)

    def entity_cell(self, t):
        label, _, _ = self.entity_handler(t)
        text = '${:02X} {}'.format(t, self.entity_name(t))
        return {'text': text, 'code': label} if label else text

    def code(self, bank, addr, text=None):
        label = self.at(bank, addr)
        t = text or label or '{:02X}:{:04X}'.format(bank, addr)
        return {'text': t, 'code': label} if label else t
