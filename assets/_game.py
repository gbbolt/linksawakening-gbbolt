"""Shared helpers for the asset plugins: a Game Boy around the gbbolt SM83 interpreter, enough hardware to
run Link's Awakening from power-on - the MBC1 cartridge with its battery RAM, OAM DMA, the LCD's line
counter with the VBlank and STAT interrupts, the timer, the joypad. Time is counted in instructions, not
cycles: a line of the LCD lasts LINE_STEPS of them. Pictures come out as the four shades of the palette
registers of each line (screen() + COLORS)."""
import os
import subprocess
import sys

TOOLS = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'gbbolt', 'tools')
if TOOLS not in sys.path:
    sys.path.append(TOOLS)
from sm83 import CPU, MBC  # noqa: E402

FRAME_HZ = 4194304 / 70224
COLORS = ['#e0f8d0', '#88c070', '#346856', '#081820']        # the four shades, lightest first

A, B, SELECT, START, RIGHT, LEFT, UP, DOWN = 1, 2, 4, 8, 16, 32, 64, 128


class DMGCPU(CPU):
    def __init__(self, mem, mbc, hw):
        super().__init__(mem, mbc)
        self.hw = hw

    def rd(self, a):
        a &= 0xFFFF
        if a >= 0xFF00:
            return self.hw.io_read(a)
        return self.mem[a]

    def wr(self, a, v):
        a &= 0xFFFF
        v &= 0xFF
        if a < 0x8000:
            self.mbc.write(a, v)
        elif a >= 0xFF00:
            self.hw.io_write(a, v)
        elif 0xE000 <= a < 0xFE00:
            self.mem[a - 0x2000] = v
        else:
            self.mem[a] = v


class Machine:
    LINE_STEPS = 28                     # instructions per LCD line (114 cycles / ~4)

    def __init__(self, rom, coverage=False):
        self.rom = rom
        self.mem = bytearray(0x10000)
        self.mem[0:0x8000] = rom[0:0x8000]
        self.mbc = MBC(rom, self.mem)
        self.cpu = DMGCPU(self.mem, self.mbc, self)
        c = self.cpu
        c.a, c.f, c.b, c.c, c.d, c.e, c.h, c.l = 0x01, 0xB0, 0x00, 0x13, 0x00, 0xD8, 0x01, 0x4D
        c.sp, c.pc, c.ime = 0xFFFE, 0x0100, False
        self.buttons = 0
        self.line = 0
        self.line_steps = 0
        self.frame = 0
        self.halted = False
        self.serial = 0
        self.timer = 0
        self.coverage = set() if coverage else None
        self.ram_code = set()
        self.line_regs = [None] * 144
        m = self.mem
        for a, v in {0xFF40: 0x91, 0xFF41: 0x81, 0xFF47: 0xFC, 0xFF00: 0xCF, 0xFF0F: 0xE1}.items():
            m[a] = v
        self.on_frame = None
        self.sound = None                   # when recording: the sound register writes, frame by frame
        self._pending = []

    # ---- IO
    def io_read(self, a):
        m = self.mem
        if a == 0xFF00:
            sel = m[0xFF00] & 0x30
            v = 0x0F
            if not sel & 0x10:
                v &= ~(self.buttons >> 4) & 0x0F
            if not sel & 0x20:
                v &= ~self.buttons & 0x0F
            return 0xC0 | sel | v
        if a == 0xFF44:
            return self.line
        if a == 0xFF41:
            mode = 1 if self.line >= 144 else (2 if self.line_steps < 5 else 3 if self.line_steps < 15 else 0)
            return 0x80 | (m[0xFF41] & 0x78) | (4 if self.line == m[0xFF45] else 0) | mode
        if 0xFF4C <= a < 0xFF80:
            return 0xFF
        return m[a]

    def io_write(self, a, v):
        m = self.mem
        if self.sound is not None and 0xFF10 <= a <= 0xFF3F:
            self._pending.append((a, v))
        if a == 0xFF46:
            s = v << 8
            m[0xFE00:0xFEA0] = bytes(self.cpu.rd(s + i) for i in range(0xA0)) if s >= 0xE000 else m[s:s + 0xA0]
        elif a == 0xFF02:
            if v & 0x81 == 0x81:
                self.serial = 200            # instructions until the byte is through; nobody answers
        elif a == 0xFF44:
            return
        elif a == 0xFF04:
            v = 0
        m[a] = v

    # ---- time
    def _next_line(self):
        m = self.mem
        self.line_steps = 0
        if self.line < 144:
            if m[0xFF41] & 0x08:                     # HBlank interrupt at the end of the line
                m[0xFF0F] |= 2
        self.line += 1
        if self.line == 154:
            self.line = 0
        ly = self.line
        if ly == 144:
            m[0xFF0F] |= 1
            if m[0xFF41] & 0x10:
                m[0xFF0F] |= 2
            self.frame += 1
            if self.sound is not None:
                self.sound.append(self._pending)
                self._pending = []
            if self.on_frame:
                self.on_frame(self)
        if ly == m[0xFF45] and m[0xFF41] & 0x40:
            m[0xFF0F] |= 2
        if ly < 144:
            self.line_regs[ly] = (m[0xFF40], m[0xFF42], m[0xFF43], m[0xFF4A], m[0xFF4B],
                                  m[0xFF47], m[0xFF48], m[0xFF49])
            if m[0xFF41] & 0x20:
                m[0xFF0F] |= 2

    def _tick_timer(self, steps):
        m = self.mem
        tac = m[0xFF07]
        if not tac & 4:
            return
        self.timer += steps * {0: 1, 1: 64, 2: 16, 3: 4}[tac & 3]      # instructions ~ 4 cycles
        while self.timer >= 64:
            self.timer -= 64
            if m[0xFF05] == 0xFF:
                m[0xFF05] = m[0xFF06]
                m[0xFF0F] |= 4
            else:
                m[0xFF05] += 1

    def _interrupt(self):
        m, cpu = self.mem, self.cpu
        pend = m[0xFF0F] & m[0xFFFF] & 0x1F
        if not pend:
            return False
        if self.halted:
            self.halted = False
            cpu.pc = (cpu.pc + 1) & 0xFFFF
        if not cpu.ime:
            return False
        for bit in range(5):
            if pend & (1 << bit):
                m[0xFF0F] &= ~(1 << bit) & 0xFF
                cpu.ime = False
                cpu.push(cpu.pc)
                cpu.pc = 0x40 + 8 * bit
                return True
        return False

    def run(self, frames=1, max_steps=50000000):
        """Run until `frames` more frames have begun (VBlank)."""
        cpu, m = self.cpu, self.mem
        end = self.frame + frames
        cov = self.coverage
        steps = 0
        per_line = self.LINE_STEPS
        while self.frame < end:
            if self.halted:
                self.line_steps = per_line
            else:
                pc = cpu.pc
                op = m[pc]
                if cov is not None:
                    if pc < 0x4000:
                        cov.add(pc)
                    elif pc < 0x8000:
                        cov.add(self.mbc.rom_bank * 0x4000 + pc - 0x4000)
                    else:
                        self.ram_code.add(pc)
                if op == 0x76:
                    self.halted = True
                elif op == 0x10:
                    cpu.pc = (pc + 2) & 0xFFFF
                else:
                    cpu.step()
                self.line_steps += 1
                steps += 1
                if steps > max_steps:
                    raise RuntimeError('step limit')
            if self.serial:
                self.serial -= 1
                if not self.serial:
                    m[0xFF01] = 0xFF
                    m[0xFF02] &= 0x7F
                    m[0xFF0F] |= 8
            if m[0xFF07] & 4:
                self._tick_timer(1)
            if self.line_steps >= per_line:
                self._next_line()
            if m[0xFF0F] & m[0xFFFF] & 0x1F:
                self._interrupt()
        return steps

    def press(self, buttons, frames=6, after=10):
        self.buttons = buttons
        self.run(frames)
        self.buttons = 0
        self.run(after)

    # ---- the picture
    def screen(self, sprites=True):
        """160 x 144 shades (0 lightest .. 3 darkest), drawn with the LCD registers of each line."""
        v = bytes(self.mem[0x8000:0xA000])
        img = [bytearray(160) for _ in range(144)]
        bgc = [bytearray(160) for _ in range(144)]           # the BG colour number before the palette
        tiles = {}

        def tile_row(addr, r):
            key = (addr, r)
            px = tiles.get(key)
            if px is None:
                lo, hi = v[addr + 2 * r], v[addr + 2 * r + 1]
                px = tiles[key] = [((hi >> (7 - x)) & 1) << 1 | ((lo >> (7 - x)) & 1) for x in range(8)]
            return px

        m = self.mem
        for y in range(144):
            regs = self.line_regs[y] or (m[0xFF40], m[0xFF42], m[0xFF43], m[0xFF4A], m[0xFF4B],
                                         m[0xFF47], m[0xFF48], m[0xFF49])
            lcdc, scy, scx, wy, wx, bgp = regs[:6]
            if not lcdc & 0x80:
                continue
            row, bc = img[y], bgc[y]
            bgmap = 0x1C00 if lcdc & 0x08 else 0x1800
            winmap = 0x1C00 if lcdc & 0x40 else 0x1800
            win = lcdc & 0x20 and y >= wy and wx < 167
            signed = not lcdc & 0x10
            if not lcdc & 1:
                for x in range(160):
                    row[x] = bgp & 3
                continue
            for x in range(160):
                if win and x >= wx - 7:
                    mx, my, base = x - (wx - 7), y - wy, winmap
                else:
                    mx, my, base = (x + scx) & 0xFF, (y + scy) & 0xFF, bgmap
                t = v[base + (my >> 3) * 32 + (mx >> 3)]
                taddr = (0x1000 + 16 * (t - 256 if t >= 128 else t)) if signed else 16 * t
                c = tile_row(taddr, my & 7)[mx & 7]
                bc[x] = c
                row[x] = (bgp >> (2 * c)) & 3
        if sprites:
            lcdc = m[0xFF40]
            if lcdc & 0x02:
                tall = lcdc & 0x04
                h = 16 if tall else 8
                for i in range(39, -1, -1):
                    sy, sx, t, at = m[0xFE00 + 4 * i: 0xFE04 + 4 * i]
                    sy -= 16
                    sx -= 8
                    if tall:
                        t &= 0xFE
                    for ty in range(h):
                        y = sy + ty
                        if not 0 <= y < 144:
                            continue
                        regs = self.line_regs[y]
                        obp = (regs[7] if at & 0x10 else regs[6]) if regs else m[0xFF49 if at & 0x10 else 0xFF48]
                        r = (h - 1 - ty) if at & 0x40 else ty
                        px = tile_row(16 * t + (16 if r >= 8 else 0), r & 7)
                        for tx in range(8):
                            x = sx + tx
                            if not 0 <= x < 160:
                                continue
                            c = px[7 - tx if at & 0x20 else tx]
                            if not c or (at & 0x80 and bgc[y][x]):
                                continue
                            img[y][x] = (obp >> (2 * c)) & 3
        return img


def record_sound(m):
    m.sound, m._pending = [], []


def rgb_bytes(img, colors=COLORS):
    rgb = [bytes(int(c[k:k + 2], 16) for k in (1, 3, 5)) for c in colors]
    return b''.join(rgb[p] for row in img for p in row)


def write_video(frames, path, sound=None, scale=3, fps=FRAME_HZ):
    """frames: [img]; sound: the frames' sound register writes (Machine.sound)."""
    h, w = len(frames[0]), len(frames[0][0])
    wav = None
    cmd = ['ffmpeg', '-y', '-loglevel', 'error', '-f', 'rawvideo', '-pix_fmt', 'rgb24',
           '-s', '{}x{}'.format(w, h), '-r', str(fps), '-i', '-']
    if sound:
        import audio
        wav = path[:-4] + '.wav'
        audio.write_wav(audio.render_writes(sound, fps), wav)
        cmd += ['-i', wav]
    cmd += ['-vf', 'scale=iw*{0}:ih*{0}:flags=neighbor'.format(scale), '-c:v', 'libx264',
            '-pix_fmt', 'yuv420p', '-crf', '18', '-preset', 'veryfast', '-movflags', '+faststart']
    if sound:
        cmd += ['-c:a', 'aac', '-b:a', '128k', '-shortest']
    cmd.append(path)
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    for img in frames:
        proc.stdin.write(rgb_bytes(img))
    proc.stdin.close()
    if proc.wait():
        raise RuntimeError('ffmpeg failed for ' + os.path.basename(path))
    if wav and os.path.exists(wav):
        os.remove(wav)


def image(img, colors=COLORS, **fields):
    """An 'image' asset part in the four shades."""
    import base64
    out = {'type': 'image', 'width': len(img[0]), 'height': len(img),
           'pixels': base64.b64encode(b''.join(bytes(r) for r in img)).decode(),
           'colors': list(colors), 'fixedColors': True}
    out.update(fields)
    return out


def write_png(path, img, colors=COLORS, scale=1):
    import struct
    import zlib
    rgb = [bytes(int(c[k:k + 2], 16) for k in (1, 3, 5)) for c in colors]
    h, w = len(img), len(img[0])
    raw = b''.join(b'\0' + b''.join(rgb[p] * scale for p in row) for row in img for _ in range(scale))

    def chunk(t, d):
        return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d))
    open(path, 'wb').write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w * scale, h * scale, 8, 2, 0, 0, 0))
                           + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b''))
