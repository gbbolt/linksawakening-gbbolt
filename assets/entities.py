"""The entities (enemies, characters, objects) that the rooms place: for each entity type a room it appears in,
and the sprite frames the game draws for it during its first seconds there, collected from the sprite table."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'entities'
FRAMES = 150                    # frames watched per entity
CROP_W, CROP_H = 48, 48         # the picture around the entity
MAX_FRAMES = 12
ENTITY_X, ENTITY_Y, ENTITY_TYPE, ENTITY_STATUS = 0xC200, 0xC210, 0xC3A0, 0xC280


def sprite_crop(m, cx, cy):
    """The sprites of OAM (not Link's) that lie around (cx, cy), on a transparent CROP_W x CROP_H picture whose
    bottom centre is a little below the entity's position."""
    mem = m.mem
    tall = mem[0xFF40] & 0x04
    h = 16 if tall else 8
    x0, y0 = cx - CROP_W // 2, cy + 12 - CROP_H
    img = [bytearray([255] * CROP_W) for _ in range(CROP_H)]
    obp = (mem[0xFF48], mem[0xFF49])
    for i in range(39, _la.LINK_OAM - 1, -1):
        sy, sx, t, at = mem[0xFE00 + 4 * i: 0xFE04 + 4 * i]
        sy -= 16
        sx -= 8
        if not (-20 <= sx - cx <= 12 and -28 <= sy - cy <= 4):     # only the sprites of this entity
            continue
        if tall:
            t &= 0xFE
        pal = obp[1 if at & 0x10 else 0]
        for ty in range(h):
            y = sy + ty - y0
            if not 0 <= y < CROP_H:
                continue
            r = (h - 1 - ty) if at & 0x40 else ty
            a = 0x8000 + 16 * t + 2 * r
            lo, hi = mem[a], mem[a + 1]
            for tx in range(8):
                x = sx + tx - x0
                if not 0 <= x < CROP_W:
                    continue
                bit = tx if at & 0x20 else 7 - tx
                c = ((hi >> bit) & 1) << 1 | ((lo >> bit) & 1)
                if c:
                    img[y][x] = (pal >> (2 * c)) & 3
    return img


def trim(frames):
    """Cut the common empty border off a list of same-size pictures."""
    ys = [y for y in range(CROP_H) if any(any(p != 255 for p in f[y]) for f in frames)]
    xs = [x for x in range(CROP_W) if any(f[y][x] != 255 for f in frames for y in range(CROP_H))]
    if not ys or not xs:
        return None
    return [[bytearray(f[y][xs[0]:xs[-1] + 1]) for y in range(ys[0], ys[-1] + 1)] for f in frames]


def build(ctx):
    rom = ctx.rom
    rd = _la.RoomData(rom)
    names = _la.Names(ctx)
    where = {}                                     # type -> (group, room, map, pos) of the first room with it
    for g in ('ow', 'A', 'B'):
        for r in range(256):
            for _, _, t in rd.entities(g, r):
                where.setdefault(t, (g, r))
    # the map each indoor room is entered on: a dungeon position or a map from the warps
    pos_of = {}
    for mp in list(range(9)) + [10]:
        base = _la.lin(0x14, 0x4200 + 64 * mp)
        for pos in range(64):
            room = rom[base + pos]
            if room:
                pos_of.setdefault((_la.group_of_map(mp), room), (mp, pos))
    world = _la.World(rom)
    cards, rows = [], []
    for t in sorted(where):
        g, r = where[t]
        world.reset()                       # each entity from the same fresh state
        if g == 'ow':
            ok = world.load(False, 0, r, settle=1)
        elif (g, r) in pos_of:
            mp, pos = pos_of[(g, r)]
            ok = world.load(True, mp, 0, pos=pos, settle=1)
        else:
            ok = world.load(True, 0x1F if g == 'A' else 0x10, r, settle=1)
        m = world.m
        frames, seen = [], set()
        for _ in range(FRAMES if ok else 0):
            m.run(1)
            slot = next((s for s in range(16) if m.mem[ENTITY_TYPE + s] == t and m.mem[ENTITY_STATUS + s]), None)
            if slot is None:
                continue
            pic = sprite_crop(m, m.mem[ENTITY_X + slot], m.mem[ENTITY_Y + slot])
            key = b''.join(bytes(rr) for rr in pic)
            if key in seen or all(p == 255 for p in key):
                continue
            seen.add(key)
            frames.append(pic)
            if len(frames) >= MAX_FRAMES:
                break
        if os.environ.get('XDEBUG'):
            print('type %02X %s room %02X ok %s frames %d mode %02X/%02X' % (
                t, g, r, ok, len(frames), m.mem[0xDB95], m.mem[0xDB96]), file=sys.stderr)
        frames = trim(frames) if frames else None
        label, bank, addr = names.entity_handler(t)
        name = names.entity_name(t)
        room_name = 'overworld room ${:02X}'.format(r) if g == 'ow' else 'indoor room {}${:02X}'.format(g, r)
        images = []
        if frames:
            for k, f in enumerate(frames):
                images.append({'type': 'image', 'width': len(f[0]), 'height': len(f), 'scale': 3,
                               'pixels': ctx.pixels(f), 'colors': list(COLORS), 'fixedColors': True,
                               'name': 'entity-{:02x}-frame-{}'.format(t, k)})
        handler = {'text': label, 'code': label} if label else '{:02X}:{:04X}'.format(bank, addr)
        rooms_with = sum(1 for gg in ('ow', 'A', 'B') for rr in range(256)
                         if any(tt == t for _, _, tt in rd.entities(gg, rr)))
        cards.append({'name': 'entity-{:02x}'.format(t), 'type': 'card', 'group': 'entities',
                      'title': '${:02X} {}'.format(t, name), 'unit': label,
                      'subtitle': '{} frame(s); in {} room(s)'.format(len(images), rooms_with),
                      'images': images,
                      'sections': [{'title': 'Entity', 'fields': [
                          ['Type', '${:02X}'.format(t)], ['Handler', handler],
                          ['Handler bank', '${:02X}'.format(bank)],
                          ['Rooms placing it', rooms_with],
                          ['Shown in', {'asset': 'ow-room-{:02x}'.format(r) if g == 'ow'
                                        else 'in-{}-{:02x}'.format(g.lower(), r), 'text': room_name}]]}],
                      'doc': ['Entity type ${:02X}: its handler is {} (bank ${:02X}, from the bank table at '
                              '$03:$4000 and EntityHandlers). The pictures are the different sprite frames the game '
                              'drew for it during its first {} frames in {}, taken from the sprite table (OAM) '
                              'around its position.'.format(t, label or 'not named yet', bank, FRAMES, room_name)],
                      'users': [x for x in (label, 'EntityHandlers') if x]})
        rows.append([{'asset': 'entity-{:02x}'.format(t), 'text': '${:02X}'.format(t)}, name, handler,
                     rooms_with, len(images),
                     {'image': images[0]} if images else '-'])
    table = {'name': 'entity-types', 'type': 'table', 'title': 'Entity types', 'unit': 'EntityHandlers',
             'subtitle': '{} types placed by rooms'.format(len(rows)),
             'columns': ['type', 'name', 'handler', 'rooms', 'frames', 'picture'], 'rows': rows,
             'doc': ['Every entity type that a room\'s entity list places (OverworldEntityPointers, '
                     'IndoorAEntityPointers, IndoorBEntityPointers), with its handler, the number of rooms placing '
                     'it and the sprite frames the game drew for it in the first room that has it.']}
    return [table] + cards
