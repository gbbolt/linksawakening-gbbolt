"""Every warp of the room data: the doors, stairs, holes and cave mouths that lead from one room to another."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _la  # noqa: E402

GROUP = 'overworld'


def room_cell(g, room):
    if g == 'ow':
        return {'asset': 'ow-room-{:02x}'.format(room), 'text': 'overworld ${:02X}'.format(room)}
    return {'asset': 'in-{}-{:02x}'.format(g.lower(), room), 'text': '{}${:02X}'.format(g, room)}


def build(ctx):
    rom = ctx.rom
    rd = _la.RoomData(rom)
    names = _la.Names(ctx)
    rows = []
    for g in ('ow', 'A', 'B'):
        for r in range(256):
            bank, addr = rd.address(g, r)
            if rom[_la.lin(bank, addr)] == 0xFF:
                continue
            d = rd.parse(g, r)
            label = names.at(bank, addr)
            for t, mp, room, x, y in d['warps']:
                dg = 'ow' if t == 0 else _la.group_of_map(mp)
                rows.append([room_cell(g, r), {'text': label, 'code': label} if label else '-', t,
                             '-' if t == 0 else '${:02X}'.format(mp), room_cell(dg, room), x, y])
    return [{'name': 'warps', 'type': 'table', 'title': 'Warps', 'subtitle': '{} warps'.format(len(rows)),
             'unit': 'OverworldRoomPointers',
             'columns': ['from room', 'room data', 'type', 'map', 'to room', 'x', 'y'], 'rows': rows,
             'doc': ['Every warp record of the room data ($E0-$E3 + 4 bytes, see OverworldRoomPointers): the room '
                     'it is in, its type (the low 2 bits: 0 leads to the overworld, 1 indoors, 2 into a side-view '
                     'area), the destination map and room, and where Link appears there (x, y in pixels). A room '
                     'holds up to four; which one a door uses depends on the door\'s place in the room. The rooms '
                     'that are joined by walking off the screen edge are not listed (the overworld rooms are '
                     'joined to their four neighbours, dungeon rooms to their neighbours of the 8 x 8 layout).'],
             'users': ['LoadRoom', 'OverworldRoomPointers', 'IndoorARoomPointers', 'IndoorBRoomPointers']}]
