"""All 640 dialogs of the game, decoded from the dialog tables of bank $1C and laid out in the 16-letter lines of
the dialog box."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import _la  # noqa: E402

GROUP = 'texts'
COUNT = 640                     # dialogs $000-$27F
POINTERS = 0x4001               # bank $1C: one word per dialog
BANKS = 0x46E1                  # bank $1C: one byte per dialog (bank in bits 0-4, bit 7: B does not skip)
LINE = 16                       # letters per line of the box
SPECIAL = {0x5E: "'"}


def decode(rom, bank, addr, limit=1200):
    a = _la.lin(bank, addr)
    out, end = [], None
    for k in range(limit):
        c = rom[a + k]
        if c in (0xFF, 0xFE):
            end = c
            break
        if c in SPECIAL:
            out.append(SPECIAL[c])
        elif 0x20 <= c < 0x7F:
            out.append(chr(c))
        else:
            out.append('{%02X}' % c)
    return out, end, k + 1


def lines(chars):
    """The text in box lines: every 16 characters start a new line (names count as 5 letters)."""
    rows, cur = [], []
    for ch in chars:
        if len(cur) == LINE:
            rows.append(''.join(cur).rstrip())
            cur = []
        cur.append(ch)
    if ''.join(cur).strip():
        rows.append(''.join(cur).rstrip())
    return [r.replace('#####', '[NAME]').replace('#', '[NAME]') for r in rows]


def build(ctx):
    rom = ctx.rom
    names = _la.Names(ctx)
    rows = []
    for i in range(COUNT):
        p = rom[_la.lin(0x1C, POINTERS + 2 * i)] | rom[_la.lin(0x1C, POINTERS + 2 * i + 1)] << 8
        flags = rom[_la.lin(0x1C, BANKS + i)]
        bank = flags & 0x1F
        if p < 0x4000:
            rows.append(['${:03X}'.format(i), '-', '-', '-', 'unused (no text)'])
            continue
        chars, end, size = decode(rom, bank, p)
        label = names.at(bank, p)
        loc = '{:02X}:{:04X}'.format(bank, p)
        text = '\n'.join(lines(chars)) or '(empty)'
        if end == 0xFE:
            text += '\n[two answers]'
        rows.append(['${:03X}'.format(i), {'text': label, 'code': label} if label else loc,
                     'no' if flags & 0x80 else 'yes', size, text])
    return [{'name': 'dialogs', 'type': 'table', 'title': 'Dialogs', 'unit': 'DialogPointers',
             'subtitle': '{} dialogs'.format(COUNT),
             'columns': ['dialog', 'text data', 'B skips', 'bytes', 'text'], 'rows': rows,
             'doc': ['Every dialog of the game as the dialog box shows it. A dialog number (OpenDialog: $000-$0FF, '
                     'OpenDialogTable1: $100-$1FF, OpenDialogTable2: $200-$27F) picks a text address from '
                     'DialogPointers and its bank from DialogBanks (bits 0-4; bit 7 set means the B button does '
                     'not hurry the text). The text is one byte per character, mostly ASCII; the box shows 16 '
                     'characters per line and 2 lines at a time, so the texts are padded with spaces to break the '
                     'lines. \' stands for the apostrophe (byte $5E), [NAME] for the player\'s name (byte $23 '
                     'types the next letter of it, five in a row), {XX} for other bytes (pictures of the trading '
                     'items and symbols, drawn from the font through DialogCharGlyphs). $FF ends a text, $FE ends '
                     'it with a choice of two answers.'],
             'users': ['DialogStateDrawChar', 'DialogTypeChar', 'OpenDialog', 'DialogPointers', 'DialogBanks']}]
