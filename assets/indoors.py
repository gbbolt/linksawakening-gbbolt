"""The indoor rooms: every dungeon put together from its 8 x 8 layout, and all houses, caves, shops and side-view
rooms, each room built and drawn by the game's own room loader; a sheet per room with its objects, entities and
warps."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'indoors'
DUNGEONS = ['Tail Cave', 'Bottle Grotto', 'Key Cavern', "Angler's Tunnel", "Catfish's Maw", 'Face Shrine',
            "Eagle's Tower", 'Turtle Rock', "Wind Fish's Egg", None, 'Caves']
CHESTS = []
LAYOUTS = 0x4200               # bank $14: 64 bytes per map $00-$0A, the room at each of the 8 x 8 positions
EMPTY = 255


def packed(ctx, img, colors=None, **fields):
    out = {'type': 'image', 'width': len(img[0]), 'height': len(img), 'packed': 'zlib',
           'pixels': ctx.packed_pixels(img), 'colors': list(colors or COLORS), 'fixedColors': True}
    out.update(fields)
    return out


def layout(rom, mp):
    base = _la.lin(0x14, LAYOUTS + 64 * mp)
    return list(rom[base:base + 64])


def all_warps(rd):
    """(group, room) -> set of maps that warps lead to."""
    dest = {}
    sources = [('ow', r) for r in range(256)] + [(g, r) for g in 'AB' for r in range(256)]
    for g, r in sources:
        try:
            d = rd.parse(g, r)
        except IndexError:
            continue
        if d['bank'] and rd.rom[_la.lin(d['bank'], d['addr'])] == 0xFF:
            continue
        for t, mp, room, _, _ in d['warps']:
            if t == 0:
                continue
            dest.setdefault((_la.group_of_map(mp), room), set()).add(mp)
    return dest


def room_sheet(ctx, rd, names, g, mp, room, pic, grid, where):
    d = rd.parse(g, room)
    ents = rd.entities(g, room)
    label = names.at(d['bank'], d['addr']) or 'Indoor{}Room{:02X}'.format(g, room)
    ent_label = names.at(0x16, rd.entity_list_addr(g, room))
    tileset, sprset = rd.tileset(g, room), rd.spriteset(g, room)
    sections = [{'title': 'Room', 'fields': [
        ['Room', '${:02X} of group {} (map ${:02X})'.format(room, g, mp)],
        ['Where', where],
        ['Data', {'text': label, 'code': label}],
        ['Data bank', '${:02X}, {} bytes'.format(d['bank'], d['size'])],
        ['Tile set', {'text': '${:02X}'.format(tileset), 'code': 'Indoor{}TilesetIds'.format(g)}],
        ['Entity graphics set', {'text': '${:02X}'.format(sprset), 'code': 'Indoor{}SpritesetIds'.format(g)}],
        ['Animated tiles', '${:02X}'.format(d['anim'])],
        ['Room template', d['template']],
        ['Floor object', '${:02X}'.format(d['floor'])],
    ]}]
    chests = _la.find_chests(grid)
    if chests:
        c = _la.chest_content(rd.rom, g, room)
        sections[0]['fields'].append(['Chest', '{} (content ${:02X}) at {}'.format(
            _la.chest_content_name(c), c, ', '.join('({}, {})'.format(x, y) for x, y in chests))])
        CHESTS.append([{'asset': 'in-{}-{:02x}'.format(g.lower(), room), 'text': '{}${:02X}'.format(g, room)},
                       where, ', '.join('({}, {})'.format(x, y) for x, y in chests), '${:02X}'.format(c),
                       _la.chest_content_name(c)])
    if ents:
        sections.append({'title': 'Entities', 'columns': ['x', 'y', 'type'],
                         'rows': [[x * 16, y * 16, names.entity_cell(t)] for x, y, t in ents]})
    if d['warps']:
        sections.append({'title': 'Warps', 'columns': ['type', 'map', 'room', 'x', 'y'],
                         'rows': [[w[0], '${:02X}'.format(w[1]) if w[0] else 'overworld', '${:02X}'.format(w[2]),
                                   w[3], w[4]] for w in d['warps']]})
    sections.append({'title': 'Object list (room data)', 'columns': ['x', 'y', 'object', 'strip'],
                     'rows': [[x, y, '${:02X}'.format(o), s or ''] for x, y, o, s in d['objects']]})
    sections.append({'title': 'Built object grid (10 x 8)', 'wide': True, 'columns': [str(x) for x in range(10)],
                     'rows': [['{:02X}'.format(o) for o in row] for row in grid]})
    name = 'in-{}-{:02x}'.format(g.lower(), room)
    return {'name': name, 'type': 'card', 'group': 'indoor rooms', 'unit': label,
            'title': 'Indoor room {}${:02X}'.format(g, room),
            'subtitle': '{}; {} objects, {} entities'.format(where, len(d['objects']), len(ents)),
            'images': [packed(ctx, pic, scale=2, name=name + '-pic')], 'sections': sections,
            'doc': ['Room ${:02X} of indoor group {} as the game builds it when entered on map ${:02X}: its data {} '
                    '(bank ${:02X}) gives the room template, the floor and the objects, the entity list {} its '
                    'entities. Drawn by the game\'s own loader a few frames after entering, without '
                    'Link.'.format(room, g, mp, label, d['bank'], ent_label or '-')],
            'users': [label] + ([ent_label] if ent_label else [])}, label


def build(ctx):
    rom = ctx.rom
    rd = _la.RoomData(rom)
    names = _la.Names(ctx)
    world = _la.World(rom)
    CHESTS.clear()
    out, cards = [], []
    done = set()
    # ---- the dungeons, from their 8 x 8 layouts
    for mp, title in enumerate(DUNGEONS):
        if title is None:
            continue
        lay = layout(rom, mp)
        g = _la.group_of_map(mp)
        img = [bytearray([EMPTY] * (8 * 160)) for _ in range(8 * 128)]
        marks = []
        for pos, room in enumerate(lay):
            if not room:
                continue
            if not world.load(True, mp, 0, pos=pos) or world.m.mem[_la.MAP_ROOM] != room:
                continue
            m = world.m
            pic = _la.room_picture(m)
            x0, y0 = (pos & 7) * 160, (pos >> 3) * 128
            for y in range(128):
                img[y0 + y][x0:x0 + 160] = pic[y]
            where = '{}, position {}, {}'.format(title, pos & 7, pos >> 3) if mp < 10 else 'caves, position {}, {}'.format(
                pos & 7, pos >> 3)
            key = (g, room)
            if key not in done:
                done.add(key)
                card, label = room_sheet(ctx, rd, names, g, mp, room, pic, _la.room_objects(m), where)
                cards.append(card)
            else:
                label = names.at(*rd.address(g, room))
            marks.append({'x': x0, 'y': y0, 'w': 160, 'h': 128, 'label': 'Room {}${:02X}'.format(g, room),
                          'text': '{} - position {}, {}'.format(label, pos & 7, pos >> 3),
                          'link': 'in-{}-{:02x}'.format(g.lower(), room), 'linkText': 'room sheet'})
        rows = [y for y in range(8) if any(lay[8 * y:8 * y + 8])]
        cols = [x for x in range(8) if any(lay[8 * y + x] for y in range(8))]
        y0, y1, x0, x1 = rows[0] * 128, (rows[-1] + 1) * 128, cols[0] * 160, (cols[-1] + 1) * 160
        crop = [bytearray(r[x0:x1]) for r in img[y0:y1]]
        for mk in marks:
            mk['x'] -= x0
            mk['y'] -= y0
        num = 'map ${:02X}'.format(mp)
        out.append(packed(ctx, crop, COLORS,
                          name='dungeon-{:02x}'.format(mp), scale=1, marks=marks,
                          title='{} ({})'.format(title, num) if mp < 10 else 'Caves ({})'.format(num),
                          unit='Indoor{}RoomPointers'.format(g),
                          subtitle='{} rooms'.format(len(marks)),
                          doc=['{} as the game draws it: each room at its place of the 8 x 8 layout of the map '
                               '(bank $14, $4200 + 64 x map: the room number at each position, read by the loader '
                               'LoadRoom with the position in $DBAE), built by the game\'s own loader with its '
                               'entities as they appear a few frames after entering. Side-view rooms show as the '
                               'game draws them from above. Link is left out; click a room for its '
                               'sheet.'.format(title if mp < 10 else 'The caves of map $0A')],
                          users=['LoadRoom', 'Indoor{}RoomPointers'.format(g), 'Indoor{}EntityPointers'.format(g)]))
    # ---- every other room: houses, caves, shops, side views
    dest = all_warps(rd)
    for g in 'AB':
        extra = []
        for room in range(256):
            if (g, room) in done:
                continue
            bank, addr = rd.address(g, room)
            if rom[_la.lin(bank, addr)] == 0xFF:
                continue                                   # the unused pointer into the free space
            maps = sorted(mp for mp in dest.get((g, room), ()) if mp >= 0x0B)
            mp = maps[0] if maps else (0x1F if g == 'A' else 0x10)
            if not world.load(True, mp, room) or world.m.mem[_la.MAP_ROOM] != room:
                continue
            m = world.m
            pic = _la.room_picture(m)
            where = 'map ${:02X}'.format(mp) + ('' if maps else ' (no warp leads here)')
            card, label = room_sheet(ctx, rd, names, g, mp, room, pic, _la.room_objects(m), where)
            cards.append(card)
            done.add((g, room))
            extra.append((room, mp, label, pic, bool(maps)))
        cols = 8
        nrow = (len(extra) + cols - 1) // cols
        img = [bytearray([EMPTY] * (cols * 164)) for _ in range(nrow * 132)]
        marks = []
        for k, (room, mp, label, pic, reached) in enumerate(extra):
            x0, y0 = (k % cols) * 164 + 2, (k // cols) * 132 + 2
            for y in range(128):
                img[y0 + y][x0:x0 + 160] = pic[y]
            marks.append({'x': x0, 'y': y0, 'w': 160, 'h': 128, 'label': 'Room {}${:02X}'.format(g, room),
                          'text': '{} - map ${:02X}{}'.format(label, mp, '' if reached else ', no warp leads here'),
                          'link': 'in-{}-{:02x}'.format(g.lower(), room), 'linkText': 'room sheet'})
        out.append(packed(ctx, img, COLORS,
                          name='indoor-{}-rooms'.format(g.lower()), scale=1, marks=marks,
                          title='Houses, caves and side views ({})'.format(g), unit='Indoor{}RoomPointers'.format(g),
                          subtitle='{} rooms of group {}'.format(len(extra), g),
                          doc=['The rooms of indoor group {} that are not part of a dungeon layout: houses, shops, '
                               'caves, wells and the side-view passages, in room number order, each built by the '
                               'game\'s own loader on the map that the warps into it name (bank ${:02X}, '
                               'Indoor{}RoomPointers).'.format(g, 0x0A if g == 'A' else 0x0B, g)],
                          users=['LoadRoom', 'Indoor{}RoomPointers'.format(g)]))
    out.append({'name': 'indoor-chests', 'type': 'table', 'title': 'Chests indoors', 'subtitle': '{} rooms'.format(len(CHESTS)),
                'columns': ['room', 'where', 'chest at (x, y)', 'content', 'item'], 'rows': CHESTS,
                'doc': ['Every indoor room whose built object grid holds a closed chest (object $A0), with what the '
                        'chest gives: the room\'s byte in the room table of bank $14 ($4500 + $100 x group + room), '
                        'handed to the rising item (EntityInit_ChestItem): $00-$0B the items of '
                        'ChestItemInventoryIds, $0C-$15 counters, $16-$1A dungeon items, $1B-$1F rupees '
                        '(ChestRupeesLow / ChestRupeesHigh). Rooms whose chest only appears after an event '
                        '(enemies beaten, a switch) are not listed.'],
                'users': ['CheckLiftAndRead', 'EntityInit_ChestItem', 'ChestItemInventoryIds']})
    return out + cards
