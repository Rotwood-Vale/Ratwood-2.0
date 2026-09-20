

/datum/species/human/void
	name = "Voidborn"
	id = "void"
	limbs_id = "human"
	desc = "Ancient beings of pure void and starlight. They are not of this world — faster, stronger, and more resilient than any mortal race. Time itself seems to bend around them."
	expanded_desc = "Voidborn are remnants of a long-dead stellar civilization. Their bodies are denser than lead yet lighter than air, their minds process reality at impossible speeds, and their flesh knits itself back together almost as fast as it is wounded. Looking at one for too long leaves afterimages that refuse to fade. When they die, space itself cracks."

	default_color = "#1a1a2e"
	/// Void hues come from get_skin_list(), so the greyscale bodies are tinted by skin tone.
	use_skintones = 1
	mutant_skin_option = TRUE

	skin_tone_wording = "Void Hue"
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	enflamed_icon = "widefire"
	default_features = MANDATORY_FEATURE_LIST
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_BREASTS = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		OFFSET_BREASTS_F = list(0,-1), \
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
	)

	// Combat
	armor = 45
	brutemod = 0.15
	burnmod = 0.15
	coldmod = 0.05
	heatmod = 0.05
	stunmod = 0.3
	speedmod = -0.65
	siemens_coeff = 0.1

	punchdamagelow = 25
	punchdamagehigh = 35
	punchstunthreshold = 45
	attack_verb = "strike"
	attack_sound = 'modular_fenysha_events/sound/fractal_attack.ogg'

	// Stats
	race_bonus = list(
		STATKEY_STR = 9,
		STATKEY_PER = 8,
		STATKEY_INT = 9,
		STATKEY_CON = 9,
		STATKEY_WIL = 9,
		STATKEY_SPD = 9,
		STATKEY_LCK = 7
	)

	// Skills
	inherent_skills = list(
		/datum/skill/combat/unarmed = 6,
		/datum/skill/combat/wrestling = 6,
		/datum/skill/combat/knives = 5,
		/datum/skill/combat/swords = 5,
		/datum/skill/combat/polearms = 5,
		/datum/skill/combat/bows = 5,
		/datum/skill/combat/crossbows = 5,
		/datum/skill/combat/whipsflails = 5,
		/datum/skill/misc/athletics = 6,
		/datum/skill/misc/climbing = 5,
		/datum/skill/misc/swimming = 5,
		/datum/skill/misc/sneaking = 5,
		/datum/skill/misc/stealing = 4,
		/datum/skill/misc/lockpicking = 4,
		/datum/skill/misc/tracking = 5,
		/datum/skill/misc/medicine = 5,
		/datum/skill/misc/reading = 6,
		/datum/skill/craft/crafting = 4,
		/datum/skill/craft/blacksmithing = 4,
		/datum/skill/craft/carpentry = 3,
		/datum/skill/craft/masonry = 3,
		/datum/skill/labor/farming = 3,
		/datum/skill/labor/fishing = 3,
		/datum/skill/labor/mining = 4
	)

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY, NO_UNDERWEAR, NOBLOOD)
	inherent_traits = list(
		TRAIT_NOBREATH,
		TRAIT_RESISTHEAT,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_PIERCEIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_NOHUNGER,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NOSLEEP,
		TRAIT_NOLIMBDISABLE,
		TRAIT_STRONG_GRABBER,
		TRAIT_CRITICAL_RESISTANCE
	)

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	inherent_factions = list("void")

	languages = list(/datum/language/common)

	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP
	deathsound = 'modular_fenysha_events/sound/fractal_scream3.ogg'
	exotic_blood = ""
	meat = /obj/item/reagent_containers/food/snacks/rogue/meat/steak

	possible_ages = list(AGE_IMMORTAL)
	max_age = 9999

	var/list/void_spell_paths = list(
		/obj/effect/proc_holder/spell/invoked/void_fold,
		/obj/effect/proc_holder/spell/invoked/projectile/void_lance,
		/obj/effect/proc_holder/spell/invoked/void_repulse,
		/obj/effect/proc_holder/spell/invoked/void_null_pulse,
		/obj/effect/proc_holder/spell/invoked/void_beckon,
		/obj/effect/proc_holder/spell/invoked/void_mandate
	)

var/list/void_speech_fx_times = list()

/datum/species/human/void/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	RegisterSignal(C, COMSIG_MOVABLE_MOVED, PROC_REF(on_void_moved))
	RegisterSignal(C, COMSIG_LIVING_DEATH, PROC_REF(on_void_death))
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_void_speech))

	// Hard-visible baseline before any filters
	C.invisibility = 0
	C.alpha = 255
	C.color = null
	C.transform = matrix()
	C.AddComponent(/datum/component/alien_examine)
	animate(C, alpha = 255, color = null, transform = matrix(), time = 0)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		// Race swaps keep the old tone, which isn't in the void palette. Rebuild the overlay stack after.
		var/list/hues = get_skin_list()
		var/list/valid_hues = list()
		for(var/hue in hues)
			valid_hues += hues[hue]
		H.skin_tone = sanitize_inlist(H.skin_tone, valid_hues, hues["starlight"])
		H.update_body()
		H.update_hair()
		H.update_body_parts()

	grant_void_spells(C)
	addtimer(CALLBACK(src, PROC_REF(setup_void_visuals), C), 2)

	to_chat(C, span_fractal_growth("The void within you awakens. Space folds politely around your presence."))

/datum/species/human/void/on_species_loss(mob/living/carbon/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH, COMSIG_MOB_SAY))

	for(var/fname in list("void_wave", "void_glow", "void_fold", "void_collapse", "lance_charge", "repulse_wave", "null_pulse"))
		C.remove_filter(fname)

	C.faction -= "void"
	C.invisibility = 0
	C.alpha = 255
	C.color = null
	C.transform = matrix()
	qdel(C.GetComponent(/datum/component/alien_examine))
	animate(C, alpha = 255, color = null, transform = matrix(), time = 0)

	clear_void_spells(C)

/datum/species/human/void/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/human/void/proc/grant_void_spells(mob/living/carbon/C)
	if(!C)
		return
	for(var/path in void_spell_paths)
		if(locate(path) in C.mob_spell_list)
			continue
		var/obj/effect/proc_holder/spell/granted = new path()
		C.AddSpell(granted)

/datum/species/human/void/proc/clear_void_spells(mob/living/carbon/C)
	if(!C)
		return
	for(var/path in void_spell_paths)
		var/obj/effect/proc_holder/spell/found = locate(path) in C.mob_spell_list
		if(!found)
			continue
		C.RemoveSpell(found)

// ---------------------------------------------------------------------------
// Visuals
// ---------------------------------------------------------------------------

/datum/species/human/void/proc/setup_void_visuals(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return

	H.invisibility = 0
	if(H.alpha < 255)
		H.alpha = 255
		animate(H, alpha = 255, time = 0)

	H.remove_filter("void_wave")
	H.add_filter("void_wave", 1, list("type" = "wave", "size" = 0.6, "x" = 3, "y" = 3, "offset" = 0))
	var/filter = H.get_filter("void_wave")
	if(filter)
		animate(filter, offset = 30, time = 60, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 0, time = 60)

/datum/species/human/void/proc/on_void_moved(atom/movable/source, atom/old_loc, direction, forced)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = source
	if(!ishuman(H) || H.stat == DEAD)
		return
	if(prob(28))
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(H), H)
	if(prob(12))
		new /obj/effect/temp_visual/fractal_crack(get_turf(H))

// ---------------------------------------------------------------------------
// Speech — fractal spans + listener FX
// ---------------------------------------------------------------------------

/**
 * COMSIG_MOB_SAY argslist:
 *   SPEECH_MESSAGE 1
 *   SPEECH_SPANS   3
 *   SPEECH_LANGUAGE 5
 *   SPEECH_MODE     8
 */
/datum/species/human/void/proc/handle_void_speech(mob/living/carbon/speaker, list/speech_args)
	SIGNAL_HANDLER
	if(!islist(speech_args))
		return

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return

	speech_args[SPEECH_MESSAGE] = void_degrade_words(message)

	var/list/spans = speech_args[SPEECH_SPANS]
	if(!islist(spans))
		spans = list()
	spans |= void_pick_speech_span()
	speech_args[SPEECH_SPANS] = spans

	INVOKE_ASYNC(src, PROC_REF(void_speech_affect_hearers), speaker)

/datum/species/human/void/proc/void_pick_speech_span()
	var/list/treatments = list(
		"fractal_echo" = 35,
		"fractal_whisper" = 20,
		"fractal_growth" = 15,
		"fractal_depth" = 10,
		"fractal_faint_echo" = 10,
		"fractal_glyph" = 5,
		"fractal_squeeze" = 3,
		"fractal_far" = 2,
	)
	return pickweight(treatments)

/datum/species/human/void/proc/void_degrade_words(message)
	var/list/words = splittext(message, " ")
	if(!length(words))
		return message

	var/to_corrupt = rand(0, 2)
	for(var/i in 1 to to_corrupt)
		var/index = rand(1, length(words))
		var/word = words[index]
		if(!length(word) || findtext(word, "<"))
			continue
		words[index] = "<span class='fractal_glyph'>[word]</span>"

	return jointext(words, " ")

#define VOID_SPEECH_EFFECT_CD (4 SECONDS)

/datum/species/human/void/proc/void_speech_affect_hearers(mob/living/carbon/speaker)
	if(!speaker || QDELETED(speaker))
		return

	for(var/mob/living/L in get_hearers_in_view(7, speaker))
		if(L == speaker)
			continue
		if(!L.client)
			continue
		if(L.stat == DEAD)
			continue
		if("void" in L.faction)
			continue
		if("fractal" in L.faction)
			continue
		void_apply_speech_effect(L, speaker)

/datum/species/human/void/proc/void_apply_speech_effect(mob/living/listener, mob/living/carbon/speaker)
	if(!listener?.client)
		return

	var/ref_id = REF(listener)
	var/last = void_speech_fx_times[ref_id] || 0
	if(world.time - last < VOID_SPEECH_EFFECT_CD)
		return
	void_speech_fx_times[ref_id] = world.time

	SEND_SOUND(listener, pick('modular_fenysha_events/sound/fractal_glitch1.ogg', 'modular_fenysha_events/sound/fractal_glitch2.ogg'))
	if(prob(55))
		shake_camera(listener, rand(1, 3), 1)
	if(prob(40))
		listener.blur_eyes(rand(1, 3))

	if(prob(35))
		to_chat(listener, span_fractal_whisper(pick(list(
			"The voice does not come from a mouth.",
			"You hear the words from more than one direction.",
			"The sentence continues after it has ended.",
			"Something in the voice is counting you.",
			"You are not sure those were words.",
			"The sound folds behind your eyes."
		))))

	if(prob(15))
		to_chat(listener, span_fractal_faint_echo(pick(list(
			"Look again.",
			"There is no center.",
			"It continues.",
			"You have already heard this."
		))))

	void_speech_screen(listener)
	void_speech_maptext(listener)

/datum/species/human/void/proc/void_speech_screen(mob/living/listener)
	if(!listener?.client)
		return
	var/datum/status_effect/fractal_screen/screen = listener.has_status_effect(/datum/status_effect/fractal_screen)
	if(!screen)
		screen = listener.apply_status_effect(/datum/status_effect/fractal_screen)
	if(!screen)
		return
	screen.infection_stage = rand(1, 3)
	screen.play_effect()

/datum/species/human/void/proc/void_speech_maptext(mob/living/listener)
	if(!listener?.client)
		return
	var/datum/status_effect/fractal_maptext/effect = listener.has_status_effect(/datum/status_effect/fractal_maptext)
	if(!effect)
		effect = listener.apply_status_effect(/datum/status_effect/fractal_maptext)
	if(!effect)
		return
	effect.intensity = rand(1, 2)
	effect.duration = max(effect.duration, 6 SECONDS)

#undef VOID_SPEECH_EFFECT_CD

// ---------------------------------------------------------------------------
// Life & combat
// ---------------------------------------------------------------------------

/datum/species/human/void/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(H.stat == DEAD)
		return

	if(H.alpha < 200)
		H.alpha = 255
		animate(H, alpha = 255, time = 0)

	if(H.health < H.maxHealth)
		H.adjustBruteLoss(-2.8)
		H.adjustFireLoss(-2.8)
		H.adjustToxLoss(-2.5)
		H.adjustOxyLoss(-4)
		H.adjustCloneLoss(-1.8)
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1.2)

	if(H.stamina < H.max_stamina)
		H.stamina_add(-9)

	if(H.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		H.adjust_blood_volume(5)

	if(prob(12))
		for(var/mob/living/L in view(5, H))
			if(L == H || ("void" in L.faction))
				continue
			shake_camera(L, 1, 0.4)

/datum/species/human/void/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE)
	damage = max(0, damage - 9)
	return ..(damage, damagetype, def_zone, blocked, H, forced, spread_damage)

// ---------------------------------------------------------------------------
// Death sequence
// ---------------------------------------------------------------------------

/datum/species/human/void/proc/on_void_death(mob/living/carbon/human/H, gibbed)
	SIGNAL_HANDLER
	if(gibbed || QDELETED(H))
		return
	INVOKE_ASYNC(src, PROC_REF(void_death_sequence), H)

/datum/species/human/void/proc/void_death_sequence(mob/living/carbon/human/H)
	set waitfor = FALSE

	if(QDELETED(H))
		return

	var/turf/center = get_turf(H)
	if(!center)
		return

	// Stage 1
	H.visible_message(span_fractal_whisper("The air around [H] tightens. Space begins to creak."))
	playsound(center, 'modular_fenysha_events/sound/fractal_glitch1.ogg', 70, TRUE)

	for(var/mob/living/L in view(7, H))
		shake_camera(L, 2, 0.6)

	for(var/turf/T in range(1, center))
		new /obj/effect/temp_visual/fractal_crack(T)
	sleep(0.3 SECONDS)
	if(QDELETED(H))
		return

	for(var/turf/T in range(2, center))
		if(prob(70))
			new /obj/effect/temp_visual/fractal_crack(T)
	sleep(0.25 SECONDS)
	if(QDELETED(H))
		return

	// Stage 2
	H.visible_message(span_fractal_echo("[H]'s form buckles inward — limbs folding into geometries that should not fit!"))
	playsound(center, 'modular_fenysha_events/sound/fractal_glitch1.ogg', 90, TRUE)

	H.add_filter("void_collapse", 2, list("type" = "wave", "size" = 2, "x" = 10, "y" = 10, "offset" = 0))
	var/collapse_filter = H.get_filter("void_collapse")
	if(collapse_filter)
		animate(collapse_filter, size = 10, offset = 90, time = 1.5 SECONDS, flags = ANIMATION_PARALLEL)

	var/list/scales = list(0.85, 0.65, 0.4, 0.22, 0.1)
	for(var/s in scales)
		if(QDELETED(H))
			return
		var/matrix/M = matrix()
		M.Scale(s, s)
		animate(H, transform = M, color = "#9b59b6", alpha = max(60, 255 * s), time = 4, flags = ANIMATION_PARALLEL)
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(H), H)
		var/turf/step_turf = get_step(center, pick(GLOB.alldirs))
		if(step_turf)
			new /obj/effect/temp_visual/fractal_crack(step_turf)
		sleep(4)

	if(QDELETED(H))
		return

	// Stage 3
	H.visible_message(span_fractal_depth_grow("[H] collapses into a point of pure void. The world leans toward it."))
	playsound(center, 'modular_fenysha_events/sound/fractal_glitch1.ogg', 110, TRUE)

	for(var/mob/living/L in view(8, center))
		if(L == H)
			continue
		shake_camera(L, 4, 2)
		if(get_dist(L, center) <= 5 && !(("void" in L.faction)))
			step_towards(L, center)

	for(var/i in 1 to 12)
		if(QDELETED(H))
			return
		var/turf/T = locate(center.x + rand(-3, 3), center.y + rand(-3, 3), center.z)
		if(T)
			new /obj/effect/temp_visual/fractal_crack(T)
			if(prob(40))
				new /obj/effect/temp_visual/decoy/fading/halfsecond(T, H)
		sleep(1)

	if(QDELETED(H))
		return

	// Stage 4
	H.visible_message(span_fractal_noise("The point unfolds. Space tears open!"))
	to_chat(world, span_fractal_noise("[H] has folded out of reality."))
	playsound(center, 'modular_fenysha_events/sound/fractal_glitch1.ogg', 130, TRUE)
	playsound(center, 'modular_fenysha_events/sound/fractal_scream3.ogg', 80, TRUE)

	for(var/ring in 0 to 4)
		for(var/turf/T in range(ring, center))
			if(get_dist(T, center) != ring)
				continue
			new /obj/effect/temp_visual/fractal_crack(T)
			if(prob(35))
				new /obj/effect/temp_visual/void_spark(T)
		sleep(2)

	if(QDELETED(H))
		return

	for(var/mob/living/L in range(5, center))
		if(L == H)
			continue
		var/dist = get_dist(L, center)
		var/dmg = clamp(40 - (dist * 6), 10, 40)
		L.adjustBruteLoss(dmg)
		L.Knockdown(2.5 SECONDS)
		shake_camera(L, 5, 3)
		var/throw_dist = clamp(6 - dist, 2, 6)
		L.throw_at(get_edge_target_turf(L, get_dir(center, L)), throw_dist, 3)

	for(var/turf/T in range(3, center))
		if(prob(55))
			new /obj/effect/decal/fractal_scar(T)
		if(prob(30))
			new /obj/effect/temp_visual/void_spark(T)

	for(var/i in 1 to 6)
		new /obj/effect/temp_visual/decoy/fading/halfsecond(center, H)

	sleep(0.5 SECONDS)
	if(!QDELETED(H))
		H.remove_filter("void_collapse")
		H.remove_filter("void_wave")
		H.remove_filter("void_glow")
		qdel(H)

/datum/species/human/void/get_skin_list()
	return sortList(list(
		"void black" = "0a0a12",
		"starlight" = "1a1a2e",
		"nebula" = "2e1a3a",
		"deep space" = "0d0d1a",
		"cosmic violet" = "1f0f2f"
	))

/datum/species/human/void/get_hairc_list()
	return sortList(list(
		"void black" = "0a0707",
		"star white" = "e8e8ff",
		"nebula purple" = "6b3fa0",
		"cosmic blue" = "3a5fcd",
		"null" = "111111"
	))

// ---------------------------------------------------------------------------
// Effects
// ---------------------------------------------------------------------------

/obj/effect/decal/fractal_scar
	name = "fractal scar"
	desc = "Space here is permanently wrong. Looking at it too long makes the edges of your vision fold."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	color = "#6b3fa0"
	anchored = TRUE
	layer = ABOVE_NORMAL_TURF_LAYER
	alpha = 160

/obj/effect/decal/fractal_scar/Initialize(mapload)
	. = ..()
	add_filter("scar_wave", 1, list("type" = "wave", "size" = 1.5, "x" = 4, "y" = 4, "offset" = 0))
	var/f = get_filter("scar_wave")
	if(f)
		animate(f, offset = 60, time = 50, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 5, time = 50)
	START_PROCESSING(SSobj, src)

/obj/effect/decal/fractal_scar/process()
	if(prob(8))
		for(var/mob/living/L in range(1, src))
			if("void" in L.faction)
				continue
			L.adjust_blurriness(1)
			if(prob(20))
				to_chat(L, span_fractal_faint_blur("The scar in reality pulls at your thoughts..."))

/obj/effect/decal/fractal_scar/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/temp_visual/fractal_crack
	name = "fractal crack"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	color = "#9b59b6"
	duration = 1.8 SECONDS
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/effect/temp_visual/fractal_crack/Initialize(mapload)
	. = ..()
	add_filter("crack_wave", 1, list("type" = "wave", "size" = 4, "x" = 8, "y" = 8, "offset" = 0))
	var/f = get_filter("crack_wave")
	if(f)
		animate(f, size = 0, offset = 40, time = duration, flags = ANIMATION_PARALLEL)
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/void_spark
	name = "void spark"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	color = "#c39bd3"
	duration = 0.8 SECONDS
	layer = ABOVE_NORMAL_TURF_LAYER
	alpha = 220

/obj/effect/temp_visual/void_spark/Initialize(mapload)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-12, 12)
	animate(src, alpha = 0, pixel_y = pixel_y + rand(8, 18), time = duration, easing = SINE_EASING)

//============================================================================
// SPELLS (invoked — same pattern as fractal infection abilities)
//============================================================================

/obj/effect/proc_holder/spell/invoked/void_fold
	name = "Fold Through"
	desc = "Cease being here. Begin being there. Distance is optional."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "shadowstep"

	range = 4
	recharge_time = 4 SECONDS
	chargetime = 0
	releasedrain = 100
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

	var/vanish_time = 4
	var/arrive_time = 3

/obj/effect/proc_holder/spell/invoked/void_fold/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/arrival = get_turf(targets[1])
	if(!arrival)
		return FALSE

	if(arrival.density || (locate(/mob/living) in arrival))
		arrival = get_step_towards(arrival, user)
	if(!arrival || arrival.density)
		to_chat(user, span_fractal_whisper("There is no space to unfold into."))
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_fold), user, arrival)
	return TRUE

/obj/effect/proc_holder/spell/invoked/void_fold/proc/do_fold(mob/living/user, turf/arrival)
	var/turf/departure = get_turf(user)
	if(!departure)
		return

	var/return_alpha = user.alpha
	if(return_alpha < 1)
		return_alpha = 255

	user.visible_message(span_fractal_echo("[user] begins to fold out of place..."))

	user.add_filter("void_fold", 2, list("type" = "wave", "size" = 1, "x" = 12, "y" = 12, "offset" = 0))
	var/folding = user.get_filter("void_fold")
	if(folding)
		animate(folding, size = 14, offset = 100, time = vanish_time, flags = ANIMATION_PARALLEL)

	animate(user, alpha = 0, color = "#9b59b6", time = vanish_time, flags = ANIMATION_PARALLEL)

	for(var/turf/T in range(1, departure))
		new /obj/effect/temp_visual/fractal_crack(T)
	new /obj/effect/temp_visual/void_spark(departure)

	for(var/i in 1 to vanish_time)
		if(QDELETED(user))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(user), user)
		if(prob(50))
			new /obj/effect/temp_visual/void_spark(get_turf(user))
		sleep(1)

	if(QDELETED(user))
		return

	user.forceMove(arrival)
	playsound(arrival, sound, 80, TRUE)
	playsound(departure, sound, 40, TRUE)

	animate(user, alpha = return_alpha, color = null, time = 0)

	folding = user.get_filter("void_fold")
	if(folding)
		animate(folding, size = 1, offset = 0, time = arrive_time, flags = ANIMATION_PARALLEL)

	for(var/turf/T in range(1, arrival))
		new /obj/effect/temp_visual/fractal_crack(T)
	new /obj/effect/temp_visual/void_spark(arrival)

	for(var/i in 1 to arrive_time)
		if(QDELETED(user))
			return
		new /obj/effect/temp_visual/decoy/fading/halfsecond(arrival, user)
		sleep(1)

	if(QDELETED(user))
		return

	user.remove_filter("void_fold")
	user.alpha = return_alpha
	user.color = null
	animate(user, alpha = return_alpha, color = null, time = 0)

/*
 * Stellar Lance — no cast() override; parent invoked/projectile fires it.
 */

/obj/projectile/beam/laser/hitscan/void_lance
	name = "stellar lance"
	damage = 38
	damage_type = BRUTE
	color = COLOR_ASSEMBLY_PURPLE
	light_color = COLOR_ASSEMBLY_PURPLE
	hitscan_light_color_override = COLOR_ASSEMBLY_PURPLE
	tracer_type = /obj/effect/projectile/tracer/wormhole
	muzzle_type = /obj/effect/projectile/muzzle/wormhole
	impact_type = /obj/effect/projectile/impact/wormhole
	impact_effect_type = null

/obj/projectile/beam/laser/hitscan/void_lance/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/turf/landing = get_turf(target)
	if(!landing)
		return

	playsound(landing, 'modular_fenysha_events/sound/fractal_glitch1.ogg', 70, TRUE)

	for(var/ring in 0 to 2)
		for(var/turf/T in range(ring, landing))
			if(get_dist(T, landing) != ring)
				continue
			new /obj/effect/temp_visual/fractal_crack(T)
			if(prob(40))
				new /obj/effect/temp_visual/void_spark(T)

	for(var/mob/living/L in range(2, landing))
		if(L == firer)
			continue
		L.adjustBruteLoss(14)
		L.Knockdown(1.2 SECONDS)
		shake_camera(L, 2, 1.5)

/obj/effect/proc_holder/spell/invoked/projectile/void_lance
	name = "Stellar Lance"
	desc = "A beam of folded light. Where it ends, space remembers the impact."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "force_dart"

	projectile_type = /obj/projectile/beam/laser/hitscan/void_lance
	range = 12
	recharge_time = 18 SECONDS
	chargetime = 0
	releasedrain = 20
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

/*
 * Void Repulse
 */

/obj/effect/proc_holder/spell/invoked/void_repulse
	name = "Void Repulse"
	desc = "Push everything nearby away with a violent fold of space."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "lightning_sunder"

	range = 4
	recharge_time = 14 SECONDS
	chargetime = 0
	releasedrain = 40
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/void_repulse/cast(list/targets, mob/user = usr)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(do_repulse), user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/void_repulse/proc/do_repulse(mob/living/user)
	if(QDELETED(user))
		return

	var/turf/center = get_turf(user)
	if(!center)
		return

	user.visible_message(span_fractal_depth("[user] violently folds space outward!"))
	playsound(user, sound, 100, TRUE)

	user.add_filter("repulse_wave", 2, list("type" = "wave", "size" = 3, "x" = 10, "y" = 10, "offset" = 0))
	var/f = user.get_filter("repulse_wave")
	if(f)
		animate(f, size = 18, offset = 90, time = 10, flags = ANIMATION_PARALLEL)

	for(var/ring in 0 to 4)
		for(var/turf/T in range(ring, center))
			if(get_dist(T, center) != ring)
				continue
			new /obj/effect/temp_visual/fractal_crack(T)
			if(prob(25))
				new /obj/effect/temp_visual/void_spark(T)
		sleep(2)

	for(var/mob/living/L in view(4, user))
		if(L == user || ("void" in L.faction))
			continue
		var/throw_dir = get_dir(user, L)
		L.throw_at(get_edge_target_turf(L, throw_dir), 5, 3, user)
		L.Knockdown(2 SECONDS)
		L.adjustBruteLoss(12)
		shake_camera(L, 3, 2)

	sleep(4)
	if(!QDELETED(user))
		user.remove_filter("repulse_wave")

/*
 * Null Pulse
 */

/obj/effect/proc_holder/spell/invoked/void_null_pulse
	name = "Null Pulse"
	desc = "Collapse your form into pure void for a moment. Wounds close. Reality around you scars."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "heal"

	range = 1
	recharge_time = 25 SECONDS
	chargetime = 0
	releasedrain = 30
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/void_null_pulse/cast(list/targets, mob/user = usr)
	. = ..()
	if(!isliving(user))
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(do_null_pulse), user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/void_null_pulse/proc/do_null_pulse(mob/living/user)
	if(QDELETED(user))
		return

	var/turf/center = get_turf(user)
	if(!center)
		return

	var/return_alpha = user.alpha
	if(return_alpha < 1)
		return_alpha = 255

	user.visible_message(span_fractal_growth("[user]'s form collapses into a singularity of void and reforms whole."))
	playsound(user, sound, 80, TRUE)

	user.add_filter("null_pulse", 2, list("type" = "wave", "size" = 2, "x" = 10, "y" = 10, "offset" = 0))
	var/f = user.get_filter("null_pulse")
	if(f)
		animate(f, size = 12, offset = 90, time = 10, flags = ANIMATION_PARALLEL)

	var/matrix/collapse = matrix()
	collapse.Scale(0.35, 0.35)
	animate(user, transform = collapse, color = "#6b3fa0", time = 8, flags = ANIMATION_PARALLEL)
	new /obj/effect/temp_visual/decoy/fading/halfsecond(center, user)
	new /obj/effect/temp_visual/void_spark(center)

	for(var/turf/T in range(2, center))
		new /obj/effect/temp_visual/fractal_crack(T)

	sleep(10)
	if(QDELETED(user))
		return

	user.adjustBruteLoss(-45)
	user.adjustFireLoss(-45)
	user.adjustToxLoss(-35)
	user.adjustOxyLoss(-60)
	user.adjustCloneLoss(-25)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.stamina_add(-70)

	for(var/i in 1 to 4)
		new /obj/effect/temp_visual/decoy/fading/halfsecond(center, user)
		new /obj/effect/temp_visual/void_spark(center)

	animate(user, transform = matrix(), color = null, alpha = return_alpha, time = 6)
	sleep(6)
	if(QDELETED(user))
		return

	user.remove_filter("null_pulse")
	user.alpha = return_alpha
	user.color = null
	user.transform = matrix()
	animate(user, transform = matrix(), color = null, alpha = return_alpha, time = 0)

	if(prob(25))
		new /obj/effect/decal/fractal_scar(center)



/*
 * Void Beckon — call all nearby void-faction mobs to the caster and order them to follow
 */
/obj/effect/proc_holder/spell/invoked/void_beckon
	name = "Void Beckon"
	desc = "Fold space and call every void-kin nearby. They will come and follow."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "shadowstep"

	range = 1
	recharge_time = 18 SECONDS
	chargetime = 0
	releasedrain = 35
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

	var/beckon_radius = 15

/obj/effect/proc_holder/spell/invoked/void_beckon/cast(list/targets, mob/user = usr)
	. = ..()
	if(!isliving(user))
		return FALSE
	INVOKE_ASYNC(src, PROC_REF(do_beckon), user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/void_beckon/proc/do_beckon(mob/living/user)
	if(QDELETED(user))
		return

	var/turf/center = get_turf(user)
	if(!center)
		return

	user.visible_message(span_fractal_echo("[user] folds space inward. Something answers from the dark..."))
	playsound(user, sound, 85, TRUE)

	// Visual pulse
	user.add_filter("void_beckon", 2, list("type" = "wave", "size" = 2, "x" = 8, "y" = 8, "offset" = 0))
	var/f = user.get_filter("void_beckon")
	if(f)
		animate(f, size = 14, offset = 80, time = 12, flags = ANIMATION_PARALLEL)

	for(var/ring in 0 to 3)
		for(var/turf/T in range(ring, center))
			if(get_dist(T, center) != ring)
				continue
			if(prob(55))
				new /obj/effect/temp_visual/fractal_crack(T)
			if(prob(25))
				new /obj/effect/temp_visual/void_spark(T)
		sleep(1)

	var/count = 0
	for(var/mob/living/M in range(beckon_radius, user))
		if(M == user)
			continue
		if(M.client)
			continue
		if(M.stat == DEAD)
			continue
		if(!M.faction || !("void" in M.faction))
			continue

		// --- Skeleton commanded type ---
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			skel.set_command("follow", user)
			count++
			continue

		// --- Modern AI controller ---
		if(M.ai_controller)
			var/datum/ai_controller/ai = M.ai_controller
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			ai.set_blackboard_key(BB_FOLLOW_TARGET, user)
			if(ai.ai_status == AI_STATUS_OFF)
				ai.set_ai_status(AI_STATUS_ON)
			ai.PauseAi(0)
			count++
			continue

		// --- Simple animals ---
		if(istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = M
			walk(S, 0)
			var/delay = 2
			if(istype(S, /mob/living/simple_animal/hostile) && S:move_to_delay)
				delay = S:move_to_delay
			if(get_dist(S, user) > 2)
				walk_towards(S, user, 0, delay)
			count++
			continue

		// --- Old NPC AI (humanoids with mode) ---
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode))
				H.target = null
				H.enemies = list()
				H.aggressive = 0
				H.wander = FALSE
				H.friends |= user
				if(get_dist(H, user) > 2)
					walk_towards(H, user, 0, 2)
				H.mode = NPC_AI_IDLE
				H.handle_ai()
				count++
			else
				// Fallback for non-AI humans of void faction
				walk(H, 0)
				if(get_dist(H, user) > 2)
					walk_towards(H, user, 0, 2)
				count++

	if(count > 0)
		to_chat(user, span_fractal_growth("[count] void-kin answer the call and begin to follow."))
	else
		to_chat(user, span_fractal_whisper("The void is silent. No kin nearby."))

	sleep(8)
	if(!QDELETED(user))
		user.remove_filter("void_beckon")


/*
 * Void Mandate — command all nearby void-faction mobs to attack a target
 */
/obj/effect/proc_holder/spell/invoked/void_mandate
	name = "Void Mandate"
	desc = "Issue a single command through the void. All nearby void-kin will attack the chosen target."
	action_icon = 'icons/mob/actions/roguespells.dmi'
	overlay_state = "force_dart"

	range = 8
	recharge_time = 16 SECONDS
	chargetime = 0
	releasedrain = 40
	chargedrain = 0
	chargedloop = null
	movement_interrupt = FALSE
	sound = 'modular_fenysha_events/sound/fractal_glitch1.ogg'
	invocation_type = "none"
	antimagic_allowed = TRUE

	var/command_radius = 15

/obj/effect/proc_holder/spell/invoked/void_mandate/cast(list/targets, mob/user = usr)
	. = ..()
	if(!length(targets))
		return FALSE
	var/atom/target = targets[1]
	if(!target || QDELETED(target))
		return FALSE
	if(target == user)
		to_chat(user, span_fractal_whisper("The void does not turn against itself."))
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_mandate), user, target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/void_mandate/proc/do_mandate(mob/living/user, atom/target)
	if(QDELETED(user) || QDELETED(target))
		return

	var/turf/center = get_turf(user)
	if(!center)
		return

	user.visible_message(span_fractal_depth("[user] speaks a single word that does not exist. Space itself delivers the order."))
	playsound(user, sound, 90, TRUE)

	// Visual
	user.add_filter("void_mandate", 2, list("type" = "wave", "size" = 3, "x" = 10, "y" = 10, "offset" = 0))
	var/f = user.get_filter("void_mandate")
	if(f)
		animate(f, size = 16, offset = 90, time = 10, flags = ANIMATION_PARALLEL)

	for(var/turf/T in range(2, center))
		if(prob(60))
			new /obj/effect/temp_visual/fractal_crack(T)
		if(prob(30))
			new /obj/effect/temp_visual/void_spark(T)

	var/count = 0
	for(var/mob/living/M in range(command_radius, user))
		if(M == user)
			continue
		if(M.client)
			continue
		if(M.stat == DEAD)
			continue
		if(M == target)
			continue
		if(!M.faction || !("void" in M.faction))
			continue

		// --- Skeleton commanded type ---
		if(istype(M, /mob/living/carbon/human/species/skeleton/npc/summoned))
			var/mob/living/carbon/human/species/skeleton/npc/summoned/skel = M
			skel.set_command("attack", target)
			count++
			continue

		// --- Modern AI controller ---
		if(M.ai_controller)
			var/datum/ai_controller/ai = M.ai_controller
			ai.CancelActions()
			ai.clear_blackboard_key(BB_FOLLOW_TARGET)
			ai.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			ai.clear_blackboard_key(BB_TRAVEL_DESTINATION)
			ai.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)

			if(ismob(target))
				ai.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
			else
				// Object target
				ai.set_blackboard_key(BB_TRAVEL_DESTINATION, get_turf(target))
				// For non-simplemob AI we can optionally start a light attack assist
				if(!istype(M, /mob/living/simple_animal))
					INVOKE_ASYNC(src, PROC_REF(assist_object_attack), M, target)
			if(ai.ai_status == AI_STATUS_OFF)
				ai.set_ai_status(AI_STATUS_ON)
			ai.PauseAi(0)
			count++
			continue

		// --- Simple animals ---
		if(istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/S = M
			walk(S, 0)
			if(ismob(target))
				// Try to make them aggressive toward the target
				if(istype(S, /mob/living/simple_animal/hostile))
					var/mob/living/simple_animal/hostile/H = S
					H.GiveTarget(target)
				else
					walk_towards(S, target, 0, 2)
			else
				walk_to(S, get_turf(target), 0, 2)
			count++
			continue

		// --- Old NPC AI ---
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(!isnull(H.mode))
				H.aggressive = 1
				H.wander = TRUE
				H.friends = list()
				if(ismob(target))
					H.enemies[target] = TRUE
					H.retaliate(target)
				else
					H.target = target
					H.mode = NPC_AI_HUNT
					INVOKE_ASYNC(src, PROC_REF(assist_old_npc_object_attack), H, target)
				H.handle_ai()
				count++
			else
				// Basic fallback
				walk(H, 0)
				if(get_dist(H, target) > 1)
					walk_towards(H, target, 0, 2)
				count++

	if(count > 0)
		to_chat(user, span_fractal_growth("[count] void-kin receive the mandate and move to destroy [target]."))
	else
		to_chat(user, span_fractal_whisper("No void-kin hear the command."))

	sleep(6)
	if(!QDELETED(user))
		user.remove_filter("void_mandate")

// Light assist routines (simplified from mass_direct, no persistent tracking needed for player spells)

/obj/effect/proc_holder/spell/invoked/void_mandate/proc/assist_object_attack(mob/living/attacker, atom/target)
	set waitfor = FALSE
	if(!attacker || QDELETED(attacker) || !target || QDELETED(target))
		return
	var/attempts = 0
	while(attempts < 40 && attacker && !QDELETED(attacker) && target && !QDELETED(target))
		if(get_dist(attacker, target) <= 1)
			if(isliving(target))
				attacker.UnarmedAttack(target)
			else
				var/obj/item/weapon = attacker.get_active_held_item()
				if(weapon)
					attacker.UnarmedAttack(target)
				else
					target.attack_animal(attacker)
			sleep(1 SECONDS)
		else
			if(attacker.ai_controller)
				attacker.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, get_turf(target))
			sleep(0.6 SECONDS)
		attempts++

/obj/effect/proc_holder/spell/invoked/void_mandate/proc/assist_old_npc_object_attack(mob/living/carbon/human/attacker, atom/target)
	set waitfor = FALSE
	if(!attacker || QDELETED(attacker) || !target || QDELETED(target))
		return
	var/attempts = 0
	while(attempts < 40 && attacker && !QDELETED(attacker) && target && !QDELETED(target))
		if(get_dist(attacker, target) <= 1)
			var/obj/item/weapon = attacker.get_active_held_item()
			if(weapon)
				attacker.UnarmedAttack(target)
			else
				target.attack_animal(attacker)
			sleep(1 SECONDS)
		else
			attacker.start_pathing_to(get_turf(target))
			sleep(0.6 SECONDS)
		attempts++



/mob/living/carbon/human/species/void
	race = /datum/species/human/void

/mob/living/carbon/human/species/void/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	
/mob/living/carbon/human/species/void/after_creation()
	. = ..()
	job = "Void Collective"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/void)

/datum/outfit/job/roguetown/human/species/void/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stuff
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	H.STASTR = rand(15,20)
	H.STASPD = 11
	H.STACON = rand(14,20)
	H.STAWIL = 15
	H.STAPER = 15
	H.STAINT = 15

	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/black
	armor = /obj/item/clothing/suit/roguetown/armor/plate/voidarmor
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/void
	
	gloves = /obj/item/clothing/gloves/roguetown/leather/black

	belt = /obj/item/storage/belt/rogue/leather/suspenders/butler
	pants = /obj/item/clothing/under/roguetown/platelegs/blk/death
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo

	r_hand = /obj/item/gun/energy_beam/laser/hitscan
