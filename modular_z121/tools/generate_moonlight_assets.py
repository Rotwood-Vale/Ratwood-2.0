from pathlib import Path
import sys
import math

from PIL import Image, ImageDraw

ROOT = Path(r"d:\SS13TEST\Ratwood-2.0-translation")
TOOLS_ROOT = ROOT / "tools"
sys.path.insert(0, str(TOOLS_ROOT))

from dmi import Dmi  # noqa: E402


WEAPON_DIR = ROOT / "modular" / "custom" / "assets" / "weapons"
SPELL_DIR = ROOT / "modular" / "custom" / "assets" / "spells" / "moonlight_greatsword"

WEAPON_DMI = WEAPON_DIR / "frostgreatsword.dmi"
WEAPON_PREVIEW = WEAPON_DIR / "frostgreatsword_preview.png"
ACTION_DMI = SPELL_DIR / "actions_spells.dmi"
ACTION_PREVIEW = SPELL_DIR / "actions_spells_preview.png"

TRANSPARENT = (0, 0, 0, 0)


def clamp(value, low=0, high=255):
    return max(low, min(high, int(value)))


def tint(color, mul=1.0, add=(0, 0, 0), alpha=None):
    r, g, b, a = color
    return (
        clamp(r * mul + add[0]),
        clamp(g * mul + add[1]),
        clamp(b * mul + add[2]),
        a if alpha is None else alpha,
    )


def draw_weapon_state(active=False, behind=False, bloody=False, wielded=False):
    size = 64
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    px = img.load()

    moon_edge = (106, 233, 247, 255)
    moon_edge_bright = (192, 255, 255, 255)
    moon_mid = (79, 185, 234, 255)
    moon_dark = (55, 120, 187, 255)
    moon_core = (116, 215, 248, 255)
    steel_shadow = (47, 91, 149, 255)
    cross_dark = (44, 28, 22, 255)
    cross = (79, 50, 35, 255)
    bronze = (201, 167, 98, 255)
    leather = (136, 104, 75, 255)
    leather_dark = (92, 68, 48, 255)
    pommel = (194, 170, 114, 255)
    glow = (132, 247, 255, 74)
    blood = (133, 28, 47, 255)

    def put(x, y, color):
        if 0 <= x < size and 0 <= y < size:
            px[x, y] = color

    def blade_half_width(t):
        if t < 0.06:
            return 7
        if t < 0.22:
            return 8
        if t < 0.58:
            return 9
        if t < 0.82:
            return 8
        if t < 0.92:
            return 5
        return max(1, int(round(5 - ((t - 0.92) / 0.08) * 4)))

    def blade_inner_width(t):
        if t < 0.12:
            return 2
        if t < 0.26:
            return 3
        if t < 0.7:
            return 4
        if t < 0.88:
            return 3
        return max(1, int(round(3 - ((t - 0.88) / 0.12) * 2)))

    start = (21.5, 38.5)
    end = (55.0, 5.0)
    if wielded:
        start = (20.0, 40.0)
        end = (58.0, 3.0)
    dx = end[0] - start[0]
    dy = end[1] - start[1]
    length = math.hypot(dx, dy)
    nx = -dy / length
    ny = dx / length

    # Blade silhouette: broad moonlit slab inspired by the reference.
    for i in range(0, 45):
        t = i / 44
        cx = start[0] + dx * t
        cy = start[1] + dy * t
        half = blade_half_width(t)
        inner = blade_inner_width(t)
        for offset in range(-half - 3, half + 4):
            x = int(round(cx + nx * offset))
            y = int(round(cy + ny * offset))
            dist = abs(offset)
            if dist > half:
                if active and dist == half + 1:
                    put(x, y, glow)
                continue
            if dist == half:
                color = moon_edge_bright if active else moon_edge
            elif dist == half - 1:
                color = moon_edge
            elif dist <= inner // 2:
                color = moon_dark if active else moon_dark
            elif offset < 0:
                color = steel_shadow
            else:
                color = moon_mid
            if dist <= inner and offset > 0:
                color = moon_core
            if 0.16 < t < 0.84 and dist == inner + 1:
                color = moon_edge if not active else moon_edge_bright
            if 0.18 < t < 0.86 and dist <= 1:
                color = moon_dark if not active else tint(moon_dark, 1.15, add=(10, 18, 12))
            if t > 0.88 and dist < half:
                color = tint(color, 1.12)
            if t < 0.1 and offset < 0 and dist >= half - 1:
                color = steel_shadow
            put(x, y, color)

    # Blade tip and broad center shimmer.
    tip_pixels = [(56, 4), (55, 3), (54, 4), (55, 5), (57, 3)]
    if wielded:
        tip_pixels = [(59, 2), (58, 1), (57, 2), (58, 3), (56, 3)]
    for x, y in tip_pixels:
        put(x, y, moon_edge_bright if active else moon_edge)
    ridge_pixels = [(28, 33), (33, 28), (38, 23), (43, 18), (48, 13)]
    if wielded:
        ridge_pixels = [(27, 34), (33, 28), (39, 22), (45, 16), (51, 10)]
    for x, y in ridge_pixels:
        put(x, y, moon_edge_bright if active else moon_edge)

    # Broad base and moon seal near the guard.
    base_x0, base_x1 = (18, 28)
    base_y0, base_y1 = (34, 41)
    if wielded:
        base_x0, base_x1 = (17, 28)
        base_y0, base_y1 = (36, 43)
    for x in range(base_x0, base_x1):
        for y in range(base_y0, base_y1):
            if x + y < (58 if not wielded else 60):
                continue
            color = steel_shadow if x < 22 else moon_mid
            put(x, y, color)
    rune_pixels = [(22, 35), (23, 35), (24, 36), (23, 37), (24, 37), (25, 38)]
    if wielded:
        rune_pixels = [(21, 37), (22, 37), (23, 38), (22, 39), (23, 39), (24, 40)]
    for x, y in rune_pixels:
        put(x, y, moon_edge_bright if active else moon_edge)

    # Crossguard.
    cross_pixels = [
        (12, 40), (13, 39), (14, 38), (15, 37), (16, 36), (17, 35), (18, 34), (19, 34), (20, 33),
        (12, 41), (13, 41), (14, 40), (15, 39), (16, 38), (17, 38), (18, 37), (19, 36),
        (24, 35), (25, 36), (26, 37), (27, 38), (28, 39), (29, 40), (30, 41), (31, 42), (32, 43),
        (24, 36), (25, 37), (26, 38), (27, 39), (28, 40), (29, 41), (30, 42), (31, 43),
        (21, 39), (22, 40), (23, 41), (24, 42), (25, 43), (26, 44),
    ]
    if wielded:
        cross_pixels = [
            (10, 42), (11, 41), (12, 40), (13, 39), (14, 38), (15, 37), (16, 36), (17, 35), (18, 35), (19, 34),
            (10, 43), (11, 43), (12, 42), (13, 41), (14, 40), (15, 39), (16, 38), (17, 38), (18, 37),
            (23, 37), (24, 38), (25, 39), (26, 40), (27, 41), (28, 42), (29, 43), (30, 44), (31, 45), (32, 46),
            (23, 38), (24, 39), (25, 40), (26, 41), (27, 42), (28, 43), (29, 44), (30, 45), (31, 46),
            (20, 41), (21, 42), (22, 43), (23, 44), (24, 45), (25, 46), (26, 47),
        ]
    for x, y in cross_pixels:
        put(x, y, cross_dark if (x + y) % 3 == 0 else cross)
    bronze_pixels = [(18, 36), (19, 36), (20, 35), (21, 36), (22, 37), (23, 38), (24, 39)]
    if wielded:
        bronze_pixels = [(17, 37), (18, 37), (19, 36), (20, 37), (21, 38), (22, 39), (23, 40)]
    for x, y in bronze_pixels:
        put(x, y, bronze)

    # Grip.
    grip_start = (17.5, 43.0)
    grip_end = (5.5, 56.0)
    if wielded:
        grip_start = (16.5, 44.5)
        grip_end = (3.5, 58.0)
    gdx = grip_end[0] - grip_start[0]
    gdy = grip_end[1] - grip_start[1]
    glen = math.hypot(gdx, gdy)
    gnx = -gdy / glen
    gny = gdx / glen
    for i in range(0, 15):
        t = i / 14
        cx = grip_start[0] + gdx * t
        cy = grip_start[1] + gdy * t
        half = 3 if t < 0.86 else 4
        for offset in range(-half, half + 1):
            x = int(round(cx + gnx * offset))
            y = int(round(cy + gny * offset))
            color = leather if abs(offset) < half else leather_dark
            if i % 4 == 1 and abs(offset) <= 1:
                color = bronze
            put(x, y, color)

    # Pommel and collar.
    collar_pixels = [(16, 42), (17, 41), (18, 41), (19, 40), (20, 41), (19, 42)]
    if wielded:
        collar_pixels = [(15, 44), (16, 43), (17, 43), (18, 42), (19, 43), (18, 44)]
    for x, y in collar_pixels:
        put(x, y, bronze)
    pommel_pixels = [
        (2, 55), (3, 54), (3, 55), (3, 56), (4, 53), (4, 54), (4, 55), (4, 56), (4, 57),
        (5, 54), (5, 55), (5, 56), (6, 55), (6, 56), (5, 57), (4, 58),
    ]
    if wielded:
        pommel_pixels = [
            (1, 57), (2, 56), (2, 57), (2, 58), (3, 55), (3, 56), (3, 57), (3, 58), (3, 59),
            (4, 56), (4, 57), (4, 58), (5, 57), (5, 58), (4, 59), (3, 60),
        ]
    for x, y in pommel_pixels:
        put(x, y, pommel if (x + y) % 2 else cross)

    # Active moon aura.
    if active:
        aura_img = img.copy()
        aura_px = aura_img.load()
        for x in range(size):
            for y in range(size):
                if px[x, y][3] == 0:
                    continue
                for ox, oy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, -1), (-1, 1)):
                    nx2, ny2 = x + ox, y + oy
                    if 0 <= nx2 < size and 0 <= ny2 < size and aura_px[nx2, ny2][3] == 0:
                        aura_px[nx2, ny2] = glow
        img = aura_img
        px = img.load()

    # Blood accents.
    if bloody:
        for x, y in [(24, 33), (25, 33), (22, 36), (18, 39), (11, 47), (8, 50)]:
            put(x, y, blood)

    if behind:
        for x in range(size):
            for y in range(size):
                if px[x, y][3]:
                    px[x, y] = tint(px[x, y], 0.72, alpha=max(120, int(px[x, y][3] * 0.9)))

    return img


def draw_spell_icon(state):
    size = 32
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw = ImageDraw.Draw(img)
    ring = (91, 210, 255, 255)
    ring_soft = (85, 140, 220, 120)
    core = (192, 244, 255, 255)
    deep = (47, 74, 153, 255)
    fill = (78, 132, 220, 255)

    draw.ellipse((3, 3, 28, 28), outline=ring_soft, width=2)
    draw.ellipse((5, 5, 26, 26), outline=ring, width=2)

    if state == "moon_wave":
        points = [(8, 21), (13, 16), (16, 18), (20, 12), (24, 10), (21, 16), (17, 17), (14, 22)]
        draw.line(points, fill=core, width=3, joint="curve")
        draw.arc((7, 8, 23, 24), start=205, end=330, fill=fill, width=2)
        draw.arc((11, 11, 28, 28), start=210, end=315, fill=deep, width=2)
        draw.polygon([(23, 7), (26, 10), (22, 11)], fill=core)
    elif state == "moon_blessing":
        draw.arc((8, 7, 23, 22), start=210, end=20, fill=core, width=3)
        draw.arc((11, 9, 25, 23), start=215, end=25, fill=fill, width=2)
        draw.line((16, 10, 16, 23), fill=core, width=2)
        draw.line((10, 16, 22, 16), fill=core, width=2)
        draw.line((12, 12, 20, 20), fill=ring, width=1)
        draw.line((20, 12, 12, 20), fill=ring, width=1)

    return img


def save_dmi(states, size, out_path):
    dmi = Dmi(size, size)
    for state_name, image in states:
        state = dmi.state(state_name)
        state.frame(image)
    dmi.to_file(out_path)


def make_preview(states, cell_size, scale, out_path):
    margin = 8
    cols = 2 if len(states) > 1 else 1
    rows = (len(states) + cols - 1) // cols
    width = cols * cell_size * scale + margin * (cols + 1)
    height = rows * cell_size * scale + margin * (rows + 1) + rows * 18
    preview = Image.new("RGBA", (width, height), (22, 26, 34, 255))
    draw = ImageDraw.Draw(preview)

    for idx, (label, image) in enumerate(states):
        col = idx % cols
        row = idx // cols
        ox = margin + col * (cell_size * scale + margin)
        oy = margin + row * (cell_size * scale + margin + 18)
        tile = 8
        for y in range(0, cell_size * scale, tile):
            for x in range(0, cell_size * scale, tile):
                fill = (78, 84, 92, 255) if ((x // tile) + (y // tile)) % 2 == 0 else (120, 126, 134, 255)
                draw.rectangle((ox + x, oy + y, ox + x + tile - 1, oy + y + tile - 1), fill=fill)
        preview.alpha_composite(image.resize((cell_size * scale, cell_size * scale), Image.Resampling.NEAREST), (ox, oy))
        draw.text((ox, oy + cell_size * scale + 2), label, fill=(236, 238, 242, 255))

    preview.save(out_path)


def main():
    WEAPON_DIR.mkdir(parents=True, exist_ok=True)
    SPELL_DIR.mkdir(parents=True, exist_ok=True)

    weapon_states = [
        ("frostgreatsword", draw_weapon_state()),
        ("frostgreatsword1", draw_weapon_state(wielded=True)),
        ("frostgreatsword_active", draw_weapon_state(active=True)),
        ("frostgreatsword_active1", draw_weapon_state(active=True, wielded=True)),
        ("frostgreatsword_behind", draw_weapon_state(behind=True)),
        ("frostgreatsword1_behind", draw_weapon_state(behind=True, wielded=True)),
        ("frostgreatsword_active_behind", draw_weapon_state(active=True, behind=True)),
        ("frostgreatsword_active1_behind", draw_weapon_state(active=True, behind=True, wielded=True)),
        ("frostgreatsword_b", draw_weapon_state(bloody=True)),
        ("frostgreatsword_b1", draw_weapon_state(bloody=True, wielded=True)),
        ("frostgreatsword_active_b", draw_weapon_state(active=True, bloody=True)),
        ("frostgreatsword_active_b1", draw_weapon_state(active=True, bloody=True, wielded=True)),
        ("frostgreatsword_b_behind", draw_weapon_state(behind=True, bloody=True)),
        ("frostgreatsword_b1_behind", draw_weapon_state(behind=True, bloody=True, wielded=True)),
        ("frostgreatsword_active_b_behind", draw_weapon_state(active=True, behind=True, bloody=True)),
        ("frostgreatsword_active_b1_behind", draw_weapon_state(active=True, behind=True, bloody=True, wielded=True)),
    ]
    save_dmi(weapon_states, 64, WEAPON_DMI)
    make_preview(weapon_states[:6], 64, 3, WEAPON_PREVIEW)

    action_states = [
        ("moon_wave", draw_spell_icon("moon_wave")),
        ("moon_blessing", draw_spell_icon("moon_blessing")),
    ]
    save_dmi(action_states, 32, ACTION_DMI)
    make_preview(action_states, 32, 4, ACTION_PREVIEW)

    print(f"Wrote {WEAPON_DMI}")
    print(f"Wrote {WEAPON_PREVIEW}")
    print(f"Wrote {ACTION_DMI}")
    print(f"Wrote {ACTION_PREVIEW}")


if __name__ == "__main__":
    main()
