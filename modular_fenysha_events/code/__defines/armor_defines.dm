#define ARMOR_VOIDCOMBAT list("blunt" = 90, "slash" = 100, "stab" = 90, "piercing" = 90, "fire" = 100, "acid" = 100) // Almost invincible armor
#define ARMOR_VOIDMUTANT list("blunt" = 80, "slash" = 80, "stab" = 80, "piercing" = 80, "fire" = 50, "acid" = 100)

/// Bodypart feature slot used by the fractal infection's limb mutations.
#define BODYPART_FEATURE_FRACTAL_MUTATION "fractal_mutation"


#define span_fractal_glyph(str) ("<span class='fractal_glyph'>" + str + "</span>")
#define span_fractal_echo(str) ("<span class='fractal_echo'>" + str + "</span>")
#define span_fractal_echo_sym(str) ("<span class='fractal_echo_sym'>" + str + "</span>")
#define span_fractal_faint_echo(str) ("<span class='fractal_faint_echo'>" + str + "</span>")
#define span_fractal_growth(str) ("<span class='fractal_growth'>" + str + "</span>")
#define span_fractal_depth(str) ("<span class='fractal_depth'>" + str + "</span>")
#define span_fractal_depth_grow(str) ("<span class='fractal_depth_grow'>" + str + "</span>")
#define span_fractal_anaglyph(str) ("<span class='fractal_anaglyph'>" + str + "</span>")
#define span_fractal_anaglyph_live(str) ("<span class='fractal_anaglyph_live'>" + str + "</span>")
#define span_fractal_squeeze(str) ("<span class='fractal_squeeze'>" + str + "</span>")
#define span_fractal_whisper(str) ("<span class='fractal_whisper'>" + str + "</span>")
#define span_fractal_faint_blur(str) ("<span class='fractal_faint_blur'>" + str + "</span>")
#define span_fractal_far(str) ("<span class='fractal_far'>" + str + "</span>")
#define span_fractal_near(str) ("<span class='fractal_near'>" + str + "</span>")

// Noise classes need data-text for the CSS attr() paint — pass the same string twice.
#define span_fractal_noise(str) ("<span class='fractal_noise' data-text='" + html_encode(str) + "'>" + str + "</span>")
#define span_fractal_noise_hard(str) ("<span class='fractal_noise_hard' data-text='" + html_encode(str) + "'>" + str + "</span>")

// Optional: examine-box frames (same classes as fractal_narrate_frames)
#define span_fractal_examine(str) ("<div class='examine_block'><div class='fractal_examine'>" + str + "</div></div>")
#define span_fractal_examine_askew(str) ("<div class='examine_block'><div class='fractal_examine fractal_askew'>" + str + "</div></div>")
#define span_fractal_examine_drift(str) ("<div class='examine_block'><div class='fractal_examine fractal_askew fractal_drift'>" + str + "</div></div>")
#define span_fractal_examine_corners(str) ("<div class='examine_block'><div class='fractal_examine fractal_askew fractal_drift fractal_corners'>" + str + "</div></div>")
#define span_fractal_examine_scan(str) ("<div class='examine_block'><div class='fractal_examine fractal_askew fractal_drift fractal_corners fractal_scan'>" + str + "</div></div>")
#define span_fractal_examine_deep(str) ("<div class='examine_block'><div class='fractal_examine fractal_askew fractal_drift fractal_corners fractal_scan fractal_deep'>" + str + "</div></div>")
