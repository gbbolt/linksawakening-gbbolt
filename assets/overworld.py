"""The overworld of Koholint: all 256 rooms built and drawn by the game's own room loader, put together as the
whole 16 x 16 map, and a sheet per room with its objects, entities and warps."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'overworld'


def packed(ctx, img, **fields):
    out = {'type': 'image', 'width': len(img[0]), 'height': len(img), 'packed': 'zlib',
           'pixels': ctx.packed_pixels(img), 'colors': list(COLORS), 'fixedColors': True}
    out.update(fields)
    return out


def warp_text(w):
    t, mp, room, x, y = w
    if t == 0:
        return 'overworld room ${:02X} (x {}, y {})'.format(room, x, y)
    return 'map ${:02X} room ${:02X} (x {}, y {}){}'.format(mp, room, x, y, ', side view' if t == 2 else '')


def build(ctx):
    rom = ctx.rom
    rd = _la.RoomData(rom)
    names = _la.Names(ctx)
    world = _la.World(rom)
    big = [bytearray(16 * 160) for _ in range(16 * 128)]
    marks, cards = [], []
    rows = []
    for r in range(256):
        world.load(False, 0, r)
        m = world.m
        pic = _la.room_picture(m)
        grid = _la.room_objects(m)
        x0, y0 = (r & 15) * 160, (r >> 4) * 128
        for y in range(128):
            big[y0 + y][x0:x0 + 160] = pic[y]
        d = rd.parse('ow', r)
        ents = rd.entities('ow', r)
        tileset = rd.tileset('ow', r)
        sprset = rd.spriteset('ow', r)
        room_label = names.at(d['bank'], d['addr']) or 'OverworldRoom{:02X}'.format(r)
        ent_label = names.at(0x16, rd.entity_list_addr('ow', r))
        ent_names = [names.entity_name(t) for _, _, t in ents]
        text = '{} - tile set ${:02X}, entity graphics set ${:02X}'.format(room_label, tileset, sprset)
        if ents:
            text += '; entities: ' + ', '.join(ent_names)
        for w in d['warps']:
            text += '; warp to ' + warp_text(w)
        marks.append({'x': x0, 'y': y0, 'w': 160, 'h': 128, 'label': 'Room ${:02X}'.format(r), 'text': text,
                      'link': 'ow-room-{:02x}'.format(r), 'linkText': 'room sheet'})
        rows.append([{'asset': 'ow-room-{:02x}'.format(r), 'text': '${:02X}'.format(r)},
                     {'text': room_label, 'code': room_label}, '${:02X}'.format(tileset),
                     '${:02X}'.format(sprset), '${:02X}'.format(d['anim']), '${:02X}'.format(d['floor']),
                     len(d['objects']), ', '.join(ent_names) or '-',
                     '; '.join(warp_text(w) for w in d['warps']) or '-'])
        sections = [{'title': 'Room', 'fields': [
            ['Room', '${:02X} (row {:X}, column {:X})'.format(r, r >> 4, r & 15)],
            ['Data', {'text': room_label, 'code': room_label}],
            ['Data bank', '${:02X}, {} bytes'.format(d['bank'], d['size'])],
            ['Area tile set', {'text': '${:02X}'.format(tileset), 'code': 'OverworldTilesetIds'}],
            ['Entity graphics set', {'text': '${:02X}'.format(sprset), 'code': 'OverworldSpritesetIds'}],
            ['Animated tiles', '${:02X}'.format(d['anim'])],
            ['Floor object', '${:02X}'.format(d['floor'])],
            ['Neighbours', ', '.join('{} ${:02X}'.format(n, rr) for n, rr in
                                     (('north', r - 16), ('south', r + 16), ('west', r - 1), ('east', r + 1))
                                     if 0 <= rr < 256 and (n in ('north', 'south') or rr >> 4 == r >> 4))],
        ]}]
        if ents:
            sections.append({'title': 'Entities', 'columns': ['x', 'y', 'type'],
                             'rows': [[x * 16, y * 16, names.entity_cell(t)] for x, y, t in ents]})
        if d['warps']:
            sections.append({'title': 'Warps', 'columns': ['type', 'map', 'room', 'x', 'y'],
                             'rows': [[w[0], '${:02X}'.format(w[1]), '${:02X}'.format(w[2]), w[3], w[4]]
                                      for w in d['warps']]})
        sections.append({'title': 'Object list (room data)', 'columns': ['x', 'y', 'object', 'strip'],
                         'rows': [[x, y, '${:02X}'.format(o), s or ''] for x, y, o, s in d['objects']]})
        sections.append({'title': 'Built object grid (10 x 8)', 'wide': True,
                         'columns': [str(x) for x in range(10)],
                         'rows': [['{:02X}'.format(o) for o in row] for row in grid]})
        cards.append({'name': 'ow-room-{:02x}'.format(r), 'type': 'card', 'group': 'overworld rooms',
                      'title': 'Overworld room ${:02X}'.format(r), 'unit': room_label,
                      'subtitle': '{} objects, {} entities{}'.format(len(d['objects']), len(ents),
                                                                     ', {} warp(s)'.format(len(d['warps']))
                                                                     if d['warps'] else ''),
                      'images': [packed(ctx, pic, scale=2, name='ow-room-pic-{:02x}'.format(r))],
                      'sections': sections,
                      'doc': ['Overworld room ${:02X} as the game builds it: its data {} (bank ${:02X}) gives the '
                              'objects, the entity list {} its entities. Drawn by the game\'s own loader a few '
                              'frames after entering, with the entities in their first frames and without '
                              'Link.'.format(r, room_label, d['bank'], ent_label or '-')],
                      'users': [room_label] + ([ent_label] if ent_label else [])})
    out = [packed(ctx, big, name='overworld-map', title='Overworld map', unit='OverworldRoomPointers',
                  subtitle='16 x 16 rooms, 2560 x 2048 pixels', scale=1, marks=marks,
                  doc=['The whole island as the game draws it: each of the 256 overworld rooms was built by the '
                       'game\'s own loader (the room data of OverworldRoomPointers, the area tile sets of '
                       'OverworldTilesetIds, the objects\' tiles of OverworldObjectTiles), with the entities of '
                       'OverworldEntityPointers as they appear a few frames after entering. Room $00 is the top '
                       'left corner, room $FF the bottom right. The rooms show their first layout, the one of a new '
                       'game; Link is left out. Click a room for its sheet.'],
                  users=['Call_2ED7', 'Call_09AA', 'OverworldRoomPointers', 'OverworldEntityPointers',
                         'OverworldTilesetIds', 'OverworldObjectTiles'])]
    out.append({'name': 'overworld-rooms', 'type': 'table', 'title': 'Overworld rooms', 'unit': 'OverworldRoomPointers',
                'subtitle': '256 rooms', 'columns': ['room', 'data', 'tile set', 'entity gfx', 'anim', 'floor',
                                                     'objects', 'entities', 'warps'],
                'rows': rows,
                'doc': ['Every overworld room with its data label, area tile set (OverworldTilesetIds), entity '
                        'graphics set (OverworldSpritesetIds), animated tiles and floor object (the first two '
                        'bytes of its data), the number of object entries, its entities '
                        '(OverworldEntityPointers) and its warps (doors and stairs into houses, caves and '
                        'dungeons).']})
    return out + cards
