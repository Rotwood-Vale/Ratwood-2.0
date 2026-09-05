/**
 * Admin narrate verbs that speak in the fractal module's visual language.
 *
 * Mirrors the three core narrate scopes (direct / local / global) from
 * randomverbs.dm, but routes the message through the same CSS classes
 * /datum/component/alien_examine and /datum/status_effect/fractal_infection use,
 * and can optionally fire the on-screen effects at the same targets.
 */

/// Chat treatments, in the order they are offered. Key is the label, value the class.
GLOBAL_LIST_INIT(fractal_narrate_effects, list(
	"None" = null,
	"Alien alphabet" = "fractal_glyph",
	"Echo" = "fractal_echo",
	"Echo - symmetric" = "fractal_echo_sym",
	"Echo - faint" = "fractal_faint_echo",
	"Growth (breathing echo)" = "fractal_growth",
	"3D depth" = "fractal_depth",
	"3D depth - growing" = "fractal_depth_grow",
	"Anaglyph" = "fractal_anaglyph",
	"Anaglyph - breathing" = "fractal_anaglyph_live",
	"Signal noise - burst" = "fractal_noise",
	"Signal noise - constant" = "fractal_noise_hard",
	"Letter spacing squeeze" = "fractal_squeeze",
	"Whisper (faded)" = "fractal_whisper",
	"Out of focus" = "fractal_faint_blur",
	"Depth of field - far" = "fractal_far",
	"Depth of field - near" = "fractal_near"
))

/// Effects painted through attr(data-text), which needs the line a second time.
GLOBAL_LIST_INIT(fractal_narrate_plaintext_effects, list(
	"fractal_noise",
	"fractal_noise_hard"
))

/// Examine box frames. Cumulative, matching the component's own escalation order.
GLOBAL_LIST_INIT(fractal_narrate_frames, list(
	"None" = null,
	"Plain examine box" = "",
	"Askew" = "fractal_askew",
	"Askew + drift" = "fractal_askew fractal_drift",
	"Askew + drift + corners" = "fractal_askew fractal_drift fractal_corners",
	"Askew + drift + corners + scanlines" = "fractal_askew fractal_drift fractal_corners fractal_scan",
	"Everything (count 6 look)" = "fractal_askew fractal_drift fractal_corners fractal_scan fractal_deep"
))

/// On-screen effects offered alongside the chat message.
GLOBAL_LIST_INIT(fractal_narrate_screen_effects, list(
	"None",
	"Mandelbrot - stage 1",
	"Mandelbrot - stage 2",
	"Mandelbrot - stage 3",
	"Mandelbrot - stage 4",
	"Mandelbrot - stage 5",
	"Maptext storm - light",
	"Maptext storm - heavy"
))



/// Builds the styled chat message. Returns null if the admin cancelled.
/proc/fractal_narrate_build(mob/user)
	var/msg = tgui_input_text(user, "Message:", "Fractal Narrate", multiline = TRUE, encode = FALSE)

	if(!msg)
		return null

	var/effect_label = tgui_input_list(user, "Text effect:", "Fractal Narrate", GLOB.fractal_narrate_effects, "None")

	if(isnull(effect_label))
		return null

	var/frame_label = tgui_input_list(user, "Box frame:", "Fractal Narrate", GLOB.fractal_narrate_frames, "None")

	if(isnull(frame_label))
		return null

	var/effect = GLOB.fractal_narrate_effects[effect_label]
	var/frame = GLOB.fractal_narrate_frames[frame_label]

	var/body = msg

	if(effect)
		if(effect in GLOB.fractal_narrate_plaintext_effects)
			body = "<span class='[effect]' data-text='[html_encode(msg)]'>[msg]</span>"
		else
			body = "<span class='[effect]'>[msg]</span>"

	if(isnull(frame))
		return body

	return "<div class='examine_block'><div class='fractal_examine [frame]'>[body]</div></div>"



/// Asks for an on-screen effect. Returns the chosen label, or null if cancelled.
/proc/fractal_narrate_pick_screen(mob/user)
	return tgui_input_list(user, "On-screen effect:", "Fractal Narrate", GLOB.fractal_narrate_screen_effects, "None")



/// Applies the chosen on-screen effect to one mob.
/proc/fractal_narrate_apply_screen(mob/target, label)
	if(!label || label == "None" || !isliving(target))
		return

	var/mob/living/victim = target

	if(findtext(label, "Maptext storm"))
		var/datum/status_effect/fractal_maptext/effect = victim.has_status_effect(/datum/status_effect/fractal_maptext)

		if(!effect)
			effect = victim.apply_status_effect(/datum/status_effect/fractal_maptext)

		if(effect)
			effect.intensity = findtext(label, "heavy") ? 5 : 2

		return

	var/stage = text2num(copytext(label, length(label)))

	if(!stage)
		return

	var/datum/status_effect/fractal_screen/screen = victim.has_status_effect(/datum/status_effect/fractal_screen)

	if(!screen)
		screen = victim.apply_status_effect(/datum/status_effect/fractal_screen)

	if(!screen)
		return

	screen.infection_stage = stage
	screen.play_effect()



/client/proc/fenysha_narrate_direct(mob/M)
	set category = "-Special Verbs-"
	set name = "Fractal Narrate - Direct"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = tgui_input_list(usr, "Fractal narrate to whom?", "Active Players", GLOB.player_list)

	if(!M)
		return

	var/msg = fractal_narrate_build(usr)

	if(!msg)
		return

	var/screen_effect = fractal_narrate_pick_screen(usr)

	if(isnull(screen_effect))
		return

	to_chat(M, msg)
	fractal_narrate_apply_screen(M, screen_effect)

	log_admin("FractalDirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")

	var/logged = span_adminnotice("<b>FractalDirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):</b> [msg]<BR>")
	message_admins(logged)
	admin_ticket_log(M, logged)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Fractal Direct Narrate")



/client/proc/fenysha_narrate_local(atom/A)
	set category = "-Special Verbs-"
	set name = "Fractal Narrate - Local"

	if(!check_rights(R_ADMIN))
		return

	if(!A)
		A = usr

	var/range = tgui_input_number(usr, "Narrate to mobs within how many tiles:", "Range", 7, 30, 1)

	if(!range)
		return

	var/msg = fractal_narrate_build(usr)

	if(!msg)
		return

	var/screen_effect = fractal_narrate_pick_screen(usr)

	if(isnull(screen_effect))
		return

	for(var/mob/M in view(range, A))
		to_chat(M, msg)
		fractal_narrate_apply_screen(M, screen_effect)

	log_admin("FractalLocalNarrate: [key_name(usr)] at [AREACOORD(A)]: [msg]")
	message_admins(span_adminnotice("<b>FractalLocalNarrate: [key_name_admin(usr)] at [ADMIN_VERBOSEJMP(A)]:</b> [msg]<BR>"))

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Fractal Local Narrate")



/client/proc/fenysha_narrate_global()
	set category = "-Special Verbs-"
	set name = "Fractal Narrate - Global"

	if(!check_rights(R_ADMIN))
		return

	var/msg = fractal_narrate_build(usr)

	if(!msg)
		return

	var/screen_effect = fractal_narrate_pick_screen(usr)

	if(isnull(screen_effect))
		return

	to_chat(world, msg)

	if(screen_effect && screen_effect != "None")
		for(var/mob/M in GLOB.player_list)
			fractal_narrate_apply_screen(M, screen_effect)

	log_admin("FractalGlobalNarrate: [key_name(usr)] : [msg]")
	message_admins(span_adminnotice("[key_name_admin(usr)] Sent a fractal global narrate"))

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Fractal Global Narrate")
