"""The character set of the dialogs: every character code with the glyph the dialog box draws for it."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import COLORS  # noqa: E402
import _la  # noqa: E402

GROUP = 'texts'
FONT = (0x0F, 0x5000)
GLYPHS = 0x45E1                 # bank $1C: DialogCharGlyphs


def glyph(rom, n):
    a = _la.lin(*FONT) + 16 * n
    return [bytearray(((rom[a + 2 * y + 1] >> (7 - x)) & 1) << 1 | ((rom[a + 2 * y] >> (7 - x)) & 1)
                      for x in range(8)) for y in range(8)]


def build(ctx):
    rom = ctx.rom
    table = rom[_la.lin(0x1C, GLYPHS):_la.lin(0x1C, GLYPHS) + 256]
    # the sheet: 16 x 16 codes, each glyph in a 10 x 10 cell
    img = [bytearray([255] * 160) for _ in range(160)]
    marks, rows = [], []
    for code in range(256):
        g = table[code]
        if not g and code != 0x20:
            continue
        cx, cy = (code & 15) * 10 + 1, (code >> 4) * 10 + 1
        for y, row in enumerate(glyph(rom, g)):
            img[cy + y][cx:cx + 8] = row
        ch = chr(code) if 0x21 <= code < 0x7F else ''
        marks.append({'x': cx, 'y': cy, 'w': 8, 'h': 8, 'label': 'code ${:02X}'.format(code),
                      'text': '{}glyph ${:02X}'.format("'{}' - ".format(ch) if ch else '', g)})
        rows.append(['${:02X}'.format(code), ch or '-', '${:02X}'.format(g),
                     {'image': {'type': 'image', 'width': 8, 'height': 8, 'scale': 3,
                                'pixels': ctx.pixels(glyph(rom, g)), 'colors': list(COLORS), 'fixedColors': True}}])
    sheet = {'name': 'charset', 'type': 'image', 'title': 'Dialog character set', 'unit': 'DialogCharGlyphs',
             'width': 160, 'height': 160, 'pixels': ctx.pixels(img), 'colors': list(COLORS), 'fixedColors': True,
             'scale': 3, 'marks': marks, 'subtitle': '{} codes with a glyph'.format(len(rows)),
             'doc': ['The glyph the dialog box draws for each character code ($00 top left, $FF bottom right; one '
                     'row per high nibble): DialogTypeChar takes the glyph number from DialogCharGlyphs and copies '
                     'that 16-byte tile of the font (FontTiles, bank $0F at $5000) into the box. The codes '
                     '$20-$7E are ASCII (^ shows an apostrophe), the codes from $80 on symbols, arrows and the '
                     'pictures of the trading items.'],
             'users': ['DialogTypeChar', 'DialogCharGlyphs', 'FontTiles']}
    table_asset = {'name': 'charset-table', 'type': 'table', 'title': 'Dialog characters', 'unit': 'DialogCharGlyphs',
                   'columns': ['code', 'ASCII', 'glyph', 'picture'], 'rows': rows,
                   'doc': ['Each character code of the dialog texts with its glyph number in the font and the '
                           'glyph itself.']}
    return [sheet, table_asset]
