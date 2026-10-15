"""The opening as the game plays it from power-on: the storm at sea, Link clinging to the mast, the
shipwreck, Marin finding him on the beach, the Wind Fish's egg on the mountain and the title screen."""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from _game import FRAME_HZ, Machine, image, record_sound, write_png, write_video  # noqa: E402

GROUP = 'screens'
TITLE_HOLD = 360                    # frames of the settled title screen at the end of the video
MAX_FRAMES = 5000
STEPS = {                           # steps of the intro mode (wGameplaySubtype while wGameplayType is 0)
    3: 'Storm at sea',
    4: 'Link at the mast',
    5: 'Shipwreck flash',
    6: 'Shipwreck flash',
    7: 'Beach and mountain',
    8: 'Title screen',
}
STILLS = [(3, 250, 'storm', 'The storm'), (4, 60, 'mast', 'Link at the mast'),
          (7, 420, 'beach', 'The beach'), (7, 1700, 'egg', 'The egg on the mountain')]


def build(ctx):
    m = Machine(ctx.rom)
    record_sound(m)
    ram = ctx.vars
    sub_addr = ram.get('wGameplaySubtype', 0xDB96)
    frames, steps = [], []
    title_at = None
    while len(frames) < MAX_FRAMES:
        m.run(1)
        frames.append(m.screen())
        steps.append(m.mem[sub_addr])
        if title_at is None and steps[-1] >= 8:
            title_at = len(frames)
        if title_at is not None and len(frames) >= title_at + TITLE_HOLD:
            break
    m.sound = m.sound[:len(frames)]
    # the lanes under the video: one per step of the intro
    lanes = {}
    run_start, run_step = 0, steps[0]
    for i, s in enumerate(steps + [None]):
        if s != run_step:
            name = STEPS.get(min(run_step, 8))
            if name:
                spans = lanes.setdefault(name, [])
                if spans and spans[-1][1] == run_start - 1:
                    spans[-1][1] = i - 1
                else:
                    spans.append([run_start, i - 1])
            run_start, run_step = i, s
    vpath, url = ctx.file('opening.mp4')
    write_video(frames, vpath, sound=m.sound)
    title = frames[-1]
    ppath, poster = ctx.file('opening.png')
    write_png(ppath, title, scale=3)
    out = [{'name': 'opening', 'type': 'video', 'title': 'Opening',
            'subtitle': '{} frames, {:.0f} s'.format(len(frames), len(frames) / FRAME_HZ),
            'file': url, 'poster': poster, 'width': 160, 'height': 144, 'fps': FRAME_HZ,
            'lanes': [{'name': n, 'spans': sp} for n, sp in lanes.items()],
            'doc': ['What the game shows from power-on until the title screen, played by its own code with no '
                    'button pressed, with its own music: a ship in a thunderstorm at night, Link clinging to the '
                    'mast in the rain, lightning striking the ship, then Link washed up on a beach where Marin '
                    'finds him, and the view rising over the forest to the egg on the mountain top before the '
                    'title comes in. Left alone on the title screen the game later starts the opening again.',
                    'The lanes show the steps of the intro mode (wGameplaySubtype while wGameplayType is 0).'],
            'users': ['wGameplayType', 'wGameplaySubtype']}]
    out.append(image(title, name='title-screen', title='Title screen', scale=2,
                     doc=['The title screen as the game draws it at the end of its opening. START leads to the '
                          'menu of saved games.']))
    seen = {}
    for i, s in enumerate(steps):
        seen.setdefault(s, i)
    for step, offset, name, title_ in STILLS:
        if step in seen and seen[step] + offset < len(frames):
            f = seen[step] + offset
            out.append(image(frames[f], name='opening-' + name, title=title_, scale=2,
                             subtitle='frame {}'.format(f + 1)))
    return out
