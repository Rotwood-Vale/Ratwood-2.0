"""Generate `_jiggle` animation states for a sprite accessory DMI.

Body-overlay accessories (breasts, and anything else that should wobble) are
drawn as a single static state per size, e.g. `pair_5_ADJ`. The jiggle emote
asks the renderer for `pair_5_jiggle_ADJ` instead, so every static state needs
an animated sibling.

Hand-drawing those for 13 breast sizes x 3 accessory types x 2 layers x 4 dirs
is not realistic, so this tool derives them from the static art by nudging the
overlay a pixel at a time. The result is a placeholder an artist can redraw one
state at a time inside the same DMI -- rerunning this tool will overwrite them,
so pass --keep to protect states that have been drawn by hand.

Usage (from the repo root):
    python tools/jigglegen/generate_jiggle_states.py icons/mob/sprite_accessory/genitals/breasts.dmi

Frame timing here MUST stay in sync with BREAST_JIGGLE_CYCLE in
code/__DEFINES/DNA.dm -- the DM side counts whole loops to decide when to stop.
"""

import argparse
import os
import sys

from PIL import Image

sys.path.append(os.path.join(os.path.dirname(__file__), ".."))

from dmi import Dmi, State, LOOP_UNLIMITED, DIR_ORDER, EAST, SOUTH, WEST  # noqa: E402

SUFFIX = "jiggle"

# Layer suffixes the sprite accessory renderer appends to a state name.
# `pair_5_ADJ` is the base state, `pair_5_jiggle_ADJ` the animated one, so the
# marker has to be spliced in *before* the layer.
LAYERS = ("BEHIND", "ADJ", "FRONT", "FFRONT", "UNDER", "NECK")

# Per-frame offsets in screen space (+x east, +y north), applied to the whole
# overlay cell. Front and back views sway side to side; side views bob.
CYCLE_FACING = ((1, -1), (0, 0), (-1, -1), (0, 0))
CYCLE_SIDE = ((0, -1), (0, 1), (0, -1), (0, 0))
CYCLES = 2

# 1/10ths of a second, per frame. CYCLES * len(cycle) * MOTION_DELAY is one full
# loop, and must equal BREAST_JIGGLE_CYCLE in code/__DEFINES/DNA.dm -- the DM
# side counts loops to decide when to stop, and the state repeats forever so a
# long or endless jiggle does not need re-rendering every cycle.
MOTION_DELAY = 1


def cycle_for_dir(dir):
    return CYCLE_SIDE if dir in (EAST, WEST) else CYCLE_FACING


def offsets_for_dir(dir):
    return tuple(cycle_for_dir(dir)) * CYCLES


def shift(cell, dx, dy):
    if not dx and not dy:
        return cell.copy()
    out = Image.new("RGBA", cell.size, (0, 0, 0, 0))
    out.paste(cell, (dx, -dy))
    return out


def split_layer(name):
    """`pair_5_ADJ` -> ('pair_5', 'ADJ'). Returns None for unlayered states."""
    base, _, layer = name.rpartition("_")
    if not base or layer not in LAYERS:
        return None
    return base, layer


def jiggle_name(base, layer):
    return "%s_%s_%s" % (base, SUFFIX, layer)


def build(dmi, source, name):
    frames = len(offsets_for_dir(SOUTH))
    state = State(dmi, name, loop=LOOP_UNLIMITED, dirs=source.dirs)
    dirs = DIR_ORDER[:source.dirs]
    for frame in range(frames):
        for dir in dirs:
            dx, dy = offsets_for_dir(dir)[frame]
            state.frames.append(shift(source.get_frame(0, dir), dx, dy))
    state.delays = [MOTION_DELAY] * frames
    return state


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("dmi", help="DMI file to add jiggle states to, edited in place")
    parser.add_argument("--keep", action="append", default=[], metavar="STATE",
                        help="jiggle state to leave untouched (hand-drawn art); repeatable")
    parser.add_argument("--dry-run", action="store_true", help="report what would change and exit")
    args = parser.parse_args()

    dmi = Dmi.from_file(args.dmi)
    keep = set(args.keep)
    marker = "_%s_" % SUFFIX

    kept = []
    sources = []
    for state in dmi.states:
        if marker in state.name:
            if state.name in keep:
                kept.append(state)
            continue
        split = split_layer(state.name)
        if split:
            sources.append((state, split))

    existing = {state.name for state in dmi.states}
    generated, added, regenerated = [], 0, 0
    for source, (base, layer) in sources:
        name = jiggle_name(base, layer)
        if name in keep:
            continue
        regenerated += name in existing
        added += name not in existing
        generated.append(build(dmi, source, name))

    # Statics first, then hand-drawn keeps, then generated: a rerun reproduces
    # the same sheet layout instead of shuffling every cell.
    dmi.states = [s for s in dmi.states if marker not in s.name] + kept + generated

    total_cells = sum(len(s.frames) for s in dmi.states)
    print("%s: %d source states -> %d added, %d regenerated, %d kept" %
          (args.dmi, len(sources), added, regenerated, len(kept)))
    print("  %d states, %d cells total" % (len(dmi.states), total_cells))
    if len(dmi.states) > 512:
        sys.exit("  ERROR: over BYOND's 512 icon state limit")
    if args.dry_run:
        return
    dmi.to_file(args.dmi)
    print("  written")


if __name__ == "__main__":
    main()
