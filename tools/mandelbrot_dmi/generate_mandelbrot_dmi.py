"""Generate a looping Mandelbrot .dmi for use as a fullscreen overlay.

Emits one icon state. The escape-time field is computed once, then each frame
rotates the colour/alpha phase by 1/frames of one band period. After `frames`
steps the phase has advanced exactly one full period, so the last frame's
successor is byte-identical to the first: the loop is seamless by construction
and does not rely on BYOND's rewind flag (rewind is always 0 here).

Alpha is driven by the same cyclic phase, producing opaque bands travelling
through an otherwise transparent field. RGB is zeroed wherever alpha is zero so
the flat regions compress well.

Frames are cheap here - only one escape field is ever computed, and each frame
is a palette lookup over it - so raising --frames costs sheet size, not time.

Requires only the standard library.
"""

import argparse
import math
import struct
import zlib


def escape_field(size, center_x, center_y, span, max_iter, bailout):
    """Smooth (continuous) escape counts. Interior pixels are None."""
    field = [None] * (size * size)
    half = span * 0.5
    step = span / size
    x0 = center_x - half
    y0 = center_y - half
    log2 = math.log(2.0)
    bail_sq = bailout * bailout

    for py in range(size):
        cy = y0 + py * step
        cy_sq = cy * cy
        row = py * size
        for px in range(size):
            cx = x0 + px * step

            # Main cardioid: q(q + x - 1/4) < y^2/4
            q = (cx - 0.25) ** 2 + cy_sq
            if q * (q + cx - 0.25) < 0.25 * cy_sq:
                continue
            # Period-2 bulb
            if (cx + 1.0) ** 2 + cy_sq < 0.0625:
                continue

            zx = 0.0
            zy = 0.0
            zx_sq = 0.0
            zy_sq = 0.0
            n = 0
            while n < max_iter and zx_sq + zy_sq <= bail_sq:
                zy = 2.0 * zx * zy + cy
                zx = zx_sq - zy_sq + cx
                zx_sq = zx * zx
                zy_sq = zy * zy
                n += 1

            if n >= max_iter:
                continue

            mag_sq = zx_sq + zy_sq
            if mag_sq <= 1.0:
                mag_sq = 1.0000001
            # Smooth iteration count
            nu = math.log(math.log(mag_sq) * 0.5 / log2) / log2
            field[row + px] = n + 1.0 - nu

    return field


def vignette_mask(size, inner, outer):
    """Radial falloff, 1.0 at the centre out to `inner`, 0.0 past `outer`."""
    mask = [0.0] * (size * size)
    half = size * 0.5
    for py in range(size):
        dy = (py + 0.5 - half) / half
        row = py * size
        for px in range(size):
            dx = (px + 0.5 - half) / half
            r = math.sqrt(dx * dx + dy * dy)
            if r <= inner:
                mask[row + px] = 1.0
            elif r >= outer:
                mask[row + px] = 0.0
            else:
                t = (r - inner) / (outer - inner)
                mask[row + px] = 1.0 - (t * t * (3.0 - 2.0 * t))
    return mask


def build_palette(steps, band_gamma, tint, hue_shift=0.0):
    """Cyclic colour + alpha ramp indexed by phase. Closed loop, so no seam.

    `hue_shift` slides the colour wheel independently of the alpha pulse. The
    two must be separable: the bands are only visible where the pulse peaks, and
    at that phase one colour channel sits at zero, so a tint alone cannot move
    the hue there.
    """
    tr, tg, tb = tint
    table = []
    for i in range(steps):
        f = i / steps
        ang = 2.0 * math.pi * f
        hue = ang + 2.0 * math.pi * hue_shift
        # Cosine palette; periodic in f by construction.
        r = 0.5 + 0.5 * math.cos(hue + 0.0)
        g = 0.5 + 0.5 * math.cos(hue + 2.094395)
        b = 0.5 + 0.5 * math.cos(hue + 4.188790)
        pulse = (0.5 - 0.5 * math.cos(ang)) ** band_gamma
        table.append((
            int(max(0.0, min(1.0, r * tr)) * 255.0 + 0.5),
            int(max(0.0, min(1.0, g * tg)) * 255.0 + 0.5),
            int(max(0.0, min(1.0, b * tb)) * 255.0 + 0.5),
            pulse,
        ))
    return table


def shade(field, mask, size, phase, period, palette, alpha_scale, interior_alpha):
    """Colour one escape field at one phase offset into RGBA bytes."""
    steps = len(palette)
    inv_period = 1.0 / period
    interior_byte = int(max(0.0, min(1.0, interior_alpha)) * 255.0 + 0.5)
    buf = bytearray(size * size * 4)

    for idx in range(size * size):
        mu = field[idx]
        if mu is None:
            a = int(interior_byte * mask[idx])
            if a:
                buf[idx * 4 + 3] = a
            continue
        m = mask[idx]
        if m <= 0.0:
            continue
        slot = int((mu * inv_period + phase) % 1.0 * steps)
        r, g, b, band = palette[slot]
        a = int(band * m * alpha_scale * 255.0 + 0.5)
        if a <= 0:
            continue
        o = idx * 4
        buf[o] = r
        buf[o + 1] = g
        buf[o + 2] = b
        buf[o + 3] = a if a < 255 else 255

    return bytes(buf)


def phase_state(args, mask, palette):
    """Static geometry, one full period of phase rotation. Seamless as-is."""
    cx, cy = args.center
    print("  escape field {0}x{0} ...".format(args.size))
    field = escape_field(args.size, cx, cy, args.span, args.max_iter, args.bailout)

    frames = []
    for i in range(args.frames):
        frames.append(shade(field, mask, args.size, i / args.frames, args.period,
                            palette, args.alpha, args.interior_alpha))
    return frames


def tile_sheet(frames, size, columns):
    """Lay every frame of every state out row-major into one RGBA sheet."""
    rows = (len(frames) + columns - 1) // columns
    sheet_w = columns * size
    sheet_h = rows * size
    sheet = bytearray(sheet_w * sheet_h * 4)
    row_bytes = size * 4

    for i, frame in enumerate(frames):
        ox = (i % columns) * size
        oy = (i // columns) * size
        for y in range(size):
            src = y * row_bytes
            dst = ((oy + y) * sheet_w + ox) * 4
            sheet[dst:dst + row_bytes] = frame[src:src + row_bytes]

    return bytes(sheet), sheet_w, sheet_h


def dmi_description(size, states):
    """States are (name, frame_count, delay) in sheet order.

    rewind stays 0 throughout: every state is built to close on itself, so the
    ping-pong flag is neither needed nor wanted.
    """
    lines = [
        "# BEGIN DMI",
        "version = 4.0",
        "\twidth = {0}".format(size),
        "\theight = {0}".format(size),
    ]
    for name, count, delay in states:
        lines += [
            'state = "{0}"'.format(name),
            "\tdirs = 1",
            "\tframes = {0}".format(count),
            "\tdelay = " + ",".join(str(delay) for _ in range(count)),
            "\tloop = 0",
            "\trewind = 0",
            "\tmovement = 0",
        ]
    lines += ["# END DMI", ""]
    return "\n".join(lines)


def png_chunk(tag, data):
    return (struct.pack(">I", len(data)) + tag + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF))


def write_dmi(path, pixels, width, height, description):
    raw = bytearray()
    stride = width * 4
    for y in range(height):
        raw.append(0)  # filter type: none
        raw += pixels[y * stride:(y + 1) * stride]

    ztxt = b"Description\x00\x00" + zlib.compress(description.encode("latin-1"), 9)

    with open(path, "wb") as handle:
        handle.write(b"\x89PNG\r\n\x1a\n")
        handle.write(png_chunk(b"IHDR", struct.pack(
            ">IIBBBBB", width, height, 8, 6, 0, 0, 0)))
        handle.write(png_chunk(b"zTXt", ztxt))
        handle.write(png_chunk(b"IDAT", zlib.compress(bytes(raw), 9)))
        handle.write(png_chunk(b"IEND", b""))


def pair(text, cast=float):
    a, b = text.split(",")
    return cast(a), cast(b)


def parse_args():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("output")
    ap.add_argument("--size", type=int, default=480, help="frame edge in px")
    ap.add_argument("--frames", type=int, default=48,
                    help="frames in the loop. More is smoother; costs sheet "
                         "size but almost no render time.")
    ap.add_argument("--columns", type=int, default=4, help="frames per sheet row")
    ap.add_argument("--delay", type=int, default=1,
                    help="frame delay in deciseconds. frames * delay is the "
                         "loop length, so halve this when you double --frames "
                         "to keep the same speed at twice the smoothness.")
    ap.add_argument("--state-name", default="mandelbrot")
    ap.add_argument("--bailout", type=float, default=256.0)
    ap.add_argument("--period", type=float, default=28.0,
                    help="iterations per colour band; also the phase loop period")
    ap.add_argument("--palette-steps", type=int, default=512)
    ap.add_argument("--band-gamma", type=float, default=1.6,
                    help="higher = narrower, sharper opaque bands")
    ap.add_argument("--alpha", type=float, default=0.9, help="peak band opacity 0..1")
    ap.add_argument("--interior-alpha", type=float, default=0.0,
                    help="opacity of the set interior 0..1")
    ap.add_argument("--tint", default="0.65,1.0,0.85", help="rgb multiplier as r,g,b")
    ap.add_argument("--hue-shift", type=float, default=0.0,
                    help="rotates the band colour around the wheel, 0..1. Use "
                         "this rather than --tint to change hue: at the phase "
                         "where the bands are opaque one colour channel is "
                         "zero, so a tint cannot move the hue there.")
    ap.add_argument("--vignette", default="0.55,1.05",
                    help="radial falloff start,end in half-widths")
    # phase state
    ap.add_argument("--center", default="-0.75,0.1", help="phase-state centre as re,im")
    ap.add_argument("--span", type=float, default=0.9,
                    help="phase-state view width in complex units")
    ap.add_argument("--max-iter", type=int, default=384)
    return ap.parse_args()


def main():
    args = parse_args()
    args.center = pair(args.center)
    tint = tuple(float(v) for v in args.tint.split(","))
    v_inner, v_outer = pair(args.vignette)

    mask = vignette_mask(args.size, v_inner, v_outer)
    palette = build_palette(args.palette_steps, args.band_gamma, tint,
                            args.hue_shift)

    print("state {0!r}:".format(args.state_name))
    frames = phase_state(args, mask, palette)
    states = [(args.state_name, len(frames), args.delay)]

    sheet, w, h = tile_sheet(frames, args.size, args.columns)
    desc = dmi_description(args.size, states)

    print("writing {0} ({1}x{2}, {3} icons) ...".format(
        args.output, w, h, len(frames)))
    write_dmi(args.output, sheet, w, h, desc)

    print("  {0}: {1} frames, loop {2:.1f}s".format(
        args.state_name, len(frames), len(frames) * args.delay / 10.0))


if __name__ == "__main__":
    main()
