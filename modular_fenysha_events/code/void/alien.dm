

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
	damage_overlay_type = "human"
	deathsound = 'modular_fenysha_events/sound/fractal_scream3.ogg'
	exotic_blood = ""
	meat = /obj/item/reagent_containers/food/snacks/rogue/meat/steak

	possible_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	max_age = 9999

	var/list/void_spell_paths = list(
		/obj/effect/proc_holder/spell/invoked/void_fold,
		/obj/effect/proc_holder/spell/invoked/projectile/void_lance,
		/obj/effect/proc_holder/spell/invoked/void_repulse,
		/obj/effect/proc_holder/spell/invoked/void_null_pulse
	)

/datum/species/human/void/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	RegisterSignal(C, COMSIG_MOVABLE_MOVED, PROC_REF(on_void_moved))
	RegisterSignal(C, COMSIG_LIVING_DEATH, PROC_REF(on_void_death))

	// Hard-visible baseline. No filters here — filters after icon build only.
	C.invisibility = 0
	C.alpha = 255
	C.color = null
	C.transform = matrix()
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

	// Soft ambient filter only after the sprite exists
	addtimer(CALLBACK(src, PROC_REF(setup_void_visuals), C), 2)

	to_chat(C, span_fractal_growth("The void within you awakens. Space folds politely around your presence."))

/datum/species/human/void/on_species_loss(mob/living/carbon/C, datum/species/new_species, pref_load)
	. = ..()
	UnregisterSignal(C, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_DEATH))

	for(var/fname in list("void_wave", "void_glow", "void_fold", "void_collapse", "lance_charge", "repulse_wave", "null_pulse"))
		C.remove_filter(fname)

	C.invisibility = 0
	C.alpha = 255
	C.color = null
	C.transform = matrix()
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
// Visuals — optional, non-destructive
// ---------------------------------------------------------------------------

/datum/species/human/void/proc/setup_void_visuals(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return

	H.invisibility = 0
	if(H.alpha < 255)
		H.alpha = 255
		animate(H, alpha = 255, time = 0)

	// Very light wave only. No outline (outline has caused blank sprites on some clients).
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
	to_chat(world, span_fractal_glyph(span_fractal_noise("[H] has folded out of reality.")))
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
// SPELLS
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
 * Stellar Lance — matches fractal_lance pattern exactly.
 * Do NOT override cast(); parent invoked/projectile handles aim + fire.
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

// No cast() override — parent fires the projectile. Charge VFX is optional fluff only.

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

/mob/living/carbon/human/species/void
	race = /datum/species/human/void
