"""Generate a seamlessly looping tinnitus tone for the shockwave's ear damage.

This fork has no ringing asset - tg's was stripped, and the place that wants it
(the ears organ, on_life) plays sound/blank.ogg as a placeholder while telling
the player "the ringing in my ears grows louder". This fills that hole.

The tone is a few high sines with a slow tremolo over them. Every component is
given a whole number of cycles across the clip, so the last sample runs back
into the first with no click - the same trick the mandelbrot loop uses. Volume
and fade are left to the game so one clip can serve every blast strength.

Writes a 16 bit mono WAV; .wav is already used elsewhere in sound/.
Requires only the standard library.
"""

import argparse
import math
import struct
import wave


def cycles(freq, seconds):
    """Nearest whole cycle count, so the component closes on itself."""
    return max(1, round(freq * seconds))


def rumble_partials(low, high, seconds, count, seed):
    """Band limited noise built from whole-cycle sines with scattered phases.

    Real noise cannot loop, but a sum of sinusoids that each close on themselves
    over the clip can, and with enough of them at scattered phases it reads as
    noise rather than a chord. This is the muffled half of blown-out hearing,
    the part a pure ring alone does not convey.
    """
    partials = []
    state = seed
    lo_c, hi_c = cycles(low, seconds), cycles(high, seconds)
    for i in range(count):
        # Cheap deterministic LCG, so regenerating gives the same asset.
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        whole = lo_c + (state % max(1, hi_c - lo_c))
        state = (state * 1103515245 + 12345) & 0x7FFFFFFF
        phase = (state / 0x7FFFFFFF) * 2.0 * math.pi
        partials.append((whole / seconds, phase))
    return partials


def envelope(t, seconds, attack, decay, tail, punch, punch_time):
    """Onset emphasis, then an exponential decay.

    `punch` is an extra kick over the first `punch_time`, so the moment it hits
    lands hard and then drops back to the ringing that follows. Normalisation
    afterwards means the punch sets the peak and the tail sits below it, which
    is what makes the start read as the impact.

    The last `tail` of the clip is ramped to true silence, because an exponential
    never actually reaches zero and cutting a tone mid-cycle clicks.
    """
    level = 1.0
    if attack > 0 and t < attack:
        level *= t / attack
    if punch > 0 and punch_time > 0:
        level *= 1.0 + punch * math.exp(-t / punch_time)
    level *= math.exp(-decay * t / seconds)
    remaining = seconds - t
    if remaining < tail:
        level *= remaining / tail
    return max(0.0, level)


def render(rate, seconds, tones, tremolo_hz, tremolo_depth, peak,
           rumble=None, rumble_gain=0.0, decay=0.0, attack=0.01, tail=0.25,
           punch=0.0, punch_time=0.25):
    frames = int(rate * seconds)

    # Snap every frequency to a whole number of cycles across the clip.
    snapped = [(cycles(freq, seconds) / seconds, gain) for freq, gain in tones]
    trem = cycles(tremolo_hz, seconds) / seconds

    total_gain = sum(gain for _, gain in snapped) or 1.0
    partials = rumble or []
    values = []

    for i in range(frames):
        t = i / rate
        value = 0.0
        for freq, gain in snapped:
            value += gain * math.sin(2.0 * math.pi * freq * t)
        value /= total_gain

        if partials:
            noise = 0.0
            for freq, phase in partials:
                noise += math.sin(2.0 * math.pi * freq * t + phase)
            value += rumble_gain * noise / math.sqrt(len(partials))

        # Tremolo is periodic over the clip too, so it does not click either.
        wobble = 1.0 - tremolo_depth + tremolo_depth * (
            0.5 + 0.5 * math.sin(2.0 * math.pi * trem * t))
        value *= wobble

        if decay > 0:
            value *= envelope(t, seconds, attack, decay, tail, punch, punch_time)
        values.append(value)

    # Normalise to the target peak rather than trusting the layer gains to sum
    # safely - adding a rumble layer on top of the tones will clip otherwise.
    loudest = max(abs(v) for v in values) or 1.0
    scale = peak / loudest
    samples = bytearray()
    for v in values:
        samples += struct.pack("<h", int(max(-1.0, min(1.0, v * scale)) * 32767))

    return bytes(samples), snapped, trem


def parse_args():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("output")
    ap.add_argument("--rate", type=int, default=22050)
    ap.add_argument("--seconds", type=float, default=8.0)
    ap.add_argument("--tones", default="4000:1.0,6300:0.45,2500:0.3",
                    help="comma list of hz:gain making up the ring")
    ap.add_argument("--tremolo", type=float, default=3.0,
                    help="hz of the slow swell under the tone")
    ap.add_argument("--tremolo-depth", type=float, default=0.35,
                    help="how much of the level the tremolo takes, 0..1")
    ap.add_argument("--peak", type=float, default=0.7,
                    help="peak amplitude 0..1, left low on purpose")
    ap.add_argument("--rumble", default="90:900",
                    help="low:high hz band for the muffled layer, blank for none")
    ap.add_argument("--rumble-gain", type=float, default=0.55,
                    help="level of the muffled layer against the ring")
    ap.add_argument("--rumble-partials", type=int, default=60)
    ap.add_argument("--seed", type=int, default=20260905)
    ap.add_argument("--decay", type=float, default=4.0,
                    help="exponential decay rate across the clip. 0 makes a "
                         "flat, seamlessly looping tone instead of a one shot.")
    ap.add_argument("--attack", type=float, default=0.01,
                    help="seconds of fade in, so the onset does not click")
    ap.add_argument("--tail", type=float, default=0.4,
                    help="seconds of ramp to true silence at the end")
    ap.add_argument("--punch", type=float, default=1.6,
                    help="extra level at the onset, on top of the body")
    ap.add_argument("--punch-time", type=float, default=0.3,
                    help="seconds the onset emphasis takes to fall away")
    return ap.parse_args()


def main():
    args = parse_args()
    tones = []
    for part in args.tones.split(","):
        freq, gain = part.split(":")
        tones.append((float(freq), float(gain)))

    partials = None
    if args.rumble:
        low, high = (float(v) for v in args.rumble.split(":"))
        partials = rumble_partials(low, high, args.seconds,
                                   args.rumble_partials, args.seed)

    data, snapped, trem = render(
        args.rate, args.seconds, tones,
        args.tremolo, args.tremolo_depth, args.peak,
        partials, args.rumble_gain,
        args.decay, args.attack, args.tail,
        args.punch, args.punch_time)

    with wave.open(args.output, "wb") as handle:
        handle.setnchannels(1)
        handle.setsampwidth(2)
        handle.setframerate(args.rate)
        handle.writeframes(data)

    print("wrote {0}".format(args.output))
    print("  {0} Hz mono, {1:.2f}s, {2} bytes".format(
        args.rate, args.seconds, len(data)))
    for freq, gain in snapped:
        print("    tone {0:.3f} Hz gain {1}  ({2:.0f} whole cycles)".format(
            freq, gain, freq * args.seconds))
    print("    tremolo {0:.3f} Hz  ({1:.0f} whole cycles)".format(
        trem, trem * args.seconds))
    if args.rumble:
        print("    rumble {0} Hz, {1} partials, gain {2}".format(
            args.rumble, args.rumble_partials, args.rumble_gain))
    print("    {0}".format(
        "decay {0} over the clip, one shot".format(args.decay) if args.decay > 0
        else "no decay, loops seamlessly"))
    if args.decay > 0 and args.punch > 0:
        print("    onset punch +{0} falling over {1}s".format(
            args.punch, args.punch_time))


if __name__ == "__main__":
    main()
