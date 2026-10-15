"""The menus and status screens as the game draws them: the file menu and the name entry, the status bar, the
inventory, the island map (with every room explored, and as a new game sees it) and the save menu."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import A, B, SELECT, START, Machine, image  # noqa: E402
import _la  # noqa: E402

GROUP = 'screens'
ROOM_STATUS = 0xD800            # wRoomStatus: one byte per overworld room, bit 7 = visited


def settle(m, cond, limit=600):
    for _ in range(limit):
        if cond():
            return True
        m.run(1)
    return False


def build(ctx):
    rom = ctx.rom
    mem_t = _la.GAMEPLAY_TYPE
    out = []
    # ---- the file menu and the name entry, on the way into a new game
    m = Machine(rom)
    mem = m.mem
    settle(m, lambda: mem[mem_t] == 0 and mem[_la.GAMEPLAY_SUBTYPE] >= 8, 6000)
    m.run(30)
    for _ in range(40):
        if mem[mem_t] == 2:
            break
        m.press(START, 4, 8)
    m.run(90)
    out.append(image(m.screen(), name='file-menu', title='File menu', scale=2, unit='ScreenLayout03',
                     doc=['The menu of the three save files as the game shows it after START on the title screen '
                          '(screen layout ScreenLayout03 with the file menu tiles of tile set request 4).'],
                     users=['ScreenLayout03', 'FileMenuTiles', 'FontTiles']))
    for _ in range(40):
        if mem[mem_t] == 3:
            break
        m.press(A, 4, 8)
    m.run(60)
    out.append(image(m.screen(), name='name-entry', title='Name entry', scale=2, unit='ScreenLayout05',
                     doc=['The name entry of a new save file (ScreenLayout05): the letters to pick and the five '
                          'places of the name.'], users=['ScreenLayout05', 'FontTiles']))
    # ---- in the world
    world = _la.World(rom)
    m = world.m
    mem = m.mem
    m.run(30)
    shot = m.screen()
    out.append(image([bytearray(r) for r in shot[128:]], name='status-bar', title='Status bar', scale=3,
                     unit='ScreenLayout02',
                     doc=['The status bar at the bottom of the screen (the window, drawn from ScreenLayout02 when an '
                          'overworld room is entered): the items on the B and A buttons, the rupees and the hearts '
                          'of a new game.'], users=['ScreenLayout02', 'CommonWorldTiles']))
    m.press(START, 4, 90)
    out.append(image(m.screen(), name='inventory', title='Inventory', scale=2,
                     doc=['The inventory that START opens during play, as at the start of a new game: the item slots '
                          'are still empty and the eight places of the instruments wait around the middle.']))
    m.press(START, 4, 90)
    settle(m, lambda: mem[mem_t] == _la.WORLD and mem[_la.GAMEPLAY_SUBTYPE] == _la.PLAYING)
    m.run(60)

    def open_map():
        for _ in range(6):
            m.press(SELECT, 4, 4)
            if settle(m, lambda: mem[mem_t] == 7 and mem[_la.GAMEPLAY_SUBTYPE] >= 4, 200):
                break
        m.run(40)

    def close_map():
        for _ in range(6):
            m.press(SELECT, 4, 4)
            if settle(m, lambda: mem[mem_t] == _la.WORLD and mem[_la.GAMEPLAY_SUBTYPE] == _la.PLAYING, 200):
                break
        m.run(60)
    # the island map: first as a new game sees it, then with every room explored
    open_map()
    out.append(image(m.screen(), name='island-map-new', title='Island map (new game)', scale=2,
                     doc=['The map of Koholint that SELECT opens on the overworld, at the start of a new game: the '
                          'rooms not visited yet are covered.']))
    close_map()
    for r in range(256):
        mem[ROOM_STATUS + r] |= 0x80
    open_map()
    out.append(image(m.screen(), name='island-map', title='Island map', scale=2,
                     doc=['The same map with every overworld room marked as visited (bit 7 of its byte in '
                          'wRoomStatus, $D800 + room), as the game draws it: the whole island.']))
    close_map()
    # the save menu: A + B + START + SELECT together
    m.press(A | B | START | SELECT, 6, 60)
    out.append(image(m.screen(), name='save-menu', title='Save menu', scale=2, unit='ScreenLayout0D',
                     doc=['The menu that pressing A, B, START and SELECT together opens during play '
                          '(ScreenLayout0D): back to the game, or save and quit.'],
                     users=['ScreenLayout0D', 'SaveMenuTiles']))
    return out
