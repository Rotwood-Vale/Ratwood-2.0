// ==========================================================
// Druid werewolf-like wildshape.
// No werewolf antag///mind datum stuff.
// No werewolf infection sorry
// Can control their inner fursona
// ==========================================================


// -------------------------------------
// Miracle spell itself
// -------------------------

/obj/effect/proc_holder/spell/self/druid_werewolf
	name = "Druid Verevolf Form"
	desc = "Take on the druidic lupine form of Dendor without bearing the mooncurse."
	overlay_state = "shapeshift"
	clothes_req = FALSE
	human_req = FALSE
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	cooldown_min = 50
	invocations = list("Treefather grant me the wolf form!")
	invocation_type = "shout"
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 100
	miracle = TRUE

	var/list/possible_werewolf_shapes = list(
		/mob/living/carbon/human/species/wildshape/druid_werewolf/male,
		/mob/living/carbon/human/species/wildshape/druid_werewolf/female
	)

/obj/effect/proc_holder/spell/self/druid_werewolf/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()

	if(!istype(user))
		revert_cast()
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("Your will is too broken to change form."))
		revert_cast()
		return FALSE

	// If already in any wildshape form, revert back.
	if(istype(user, /mob/living/carbon/human/species/wildshape))
		user.wildshape_untransform()
		return FALSE

	// This is not a true werewolf antag transform.
	// Do not!!!!!!!!! stack it on real werewolves.
	if(user.mind?.has_antag_datum(/datum/antagonist/werewolf))
		to_chat(user, span_warning("The mooncurse rejects Dendor's druidic shape."))
		revert_cast()
		return FALSE

	var/list/choices = list()
	var/list/shape_paths_by_name = list()

	for(var/mob/living/carbon/human/species/wildshape/druid_werewolf/shape_type as anything in possible_werewolf_shapes)
		var/shape_name = initial(shape_type.name)
		var/shape_icon_file = initial(shape_type.wildshape_icon)
		var/shape_icon_state = initial(shape_type.wildshape_icon_state)

		var/icon/shape_icon = icon(shape_icon_file, shape_icon_state)

		var/size_x = shape_icon.Width()
		var/size_y = shape_icon.Height()

		var/image/icon_img = image(shape_icon)
		icon_img.pixel_x = -(size_x / 2) + 16
		icon_img.pixel_y = -(size_y / 2) + 16

		choices[shape_name] = icon_img
		shape_paths_by_name[shape_name] = shape_type

	var/chosen_form = show_radial_menu(user, user, choices)

	if(!chosen_form)
		revert_cast()
		return FALSE

	var/chosen_shape_type = shape_paths_by_name[chosen_form]

	if(!chosen_shape_type)
		revert_cast()
		return FALSE
	to_chat(user, span_notice("Your body begins to twist into a druidic lupine shape..."))

	if(!do_after(user, 5 SECONDS, target = user))
		to_chat(user, span_warning("Your transformation is interrupted."))
		revert_cast()
		return FALSE

	user.Stun(50)
	user.Knockdown(50)

	INVOKE_ASYNC(
		user,
		TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation),
		chosen_shape_type
	)

	return TRUE


// ---------------------------------------------------------
// Druid Verevolf wildshape mob
// --------------------------------------------------

/mob/living/carbon/human/species/wildshape/druid_werewolf
	name = "Druid Verevolf"
	race = /datum/species/werewolf/druid
	footstep_type = FOOTSTEP_MOB_HEAVY

	wildshape_icon = 'icons/roguetown/mob/monster/werewolf.dmi'
	wildshape_icon_state = "wwolf_m"

	maxHealth = 220
	health = 220

	// Druid form stats.
	STASTR = 13
	STAPER = 8
	STAINT = 8
	STACON = 12
	STAWIL = 12
	STASPD = 12
	STALUC = 12

	var/druid_wolfname = "Druid Verevolf"
	var/druid_werewolf_setup_done = FALSE
	var/druid_werewolf_skills_done = FALSE

/mob/living/carbon/human/species/wildshape/druid_werewolf/male
	name = "Male Druid Verevolf"
	gender = MALE
	wildshape_icon_state = "wwolf_m"

/mob/living/carbon/human/species/wildshape/druid_werewolf/female
	name = "Female Druid Verevolf"
	gender = FEMALE
	wildshape_icon_state = "wwolf_f"


// ------------------------------------
// Form setup
// --------------------

/mob/living/carbon/human/species/wildshape/druid_werewolf/gain_inherent_skills()
	. = ..()
	setup_druid_werewolf_form()

/mob/living/carbon/human/species/wildshape/druid_werewolf/proc/setup_druid_werewolf_form()
	if(!druid_werewolf_setup_done)
		druid_werewolf_setup_done = TRUE

		// Force selected visual gender after transform.
		if(istype(src, /mob/living/carbon/human/species/wildshape/druid_werewolf/female))
			src.gender = FEMALE
		else
			src.gender = MALE

		src.generate_druid_wolf_name()
		src.apply_druid_werewolf_stats()
		src.apply_druid_werewolf_organs()

		regenerate_icons()

	// Skills/spells need mind, so this is separate from visual/stat setup.
	if(src.mind && !druid_werewolf_skills_done)
		druid_werewolf_skills_done = TRUE
		src.grant_druid_werewolf_skills()


// ----------------------------------------
// Stats
// ----------------

/mob/living/carbon/human/species/wildshape/druid_werewolf/proc/apply_druid_werewolf_stats()
	maxHealth = 220

	if(health > maxHealth)
		health = maxHealth

	STASTR = 13
	STAPER = 8
	STAINT = 8
	STACON = 12
	STAWIL = 12
	STASPD = 12
	STALUC = 12

	updatehealth()

// --------------------------------
// Organs by selected form
// --------------

/mob/living/carbon/human/species/wildshape/druid_werewolf/proc/apply_druid_werewolf_organs()
	if(!internal_organs_slot)
		internal_organs_slot = list()

	if(istype(src, /mob/living/carbon/human/species/wildshape/druid_werewolf/female))
		internal_organs_slot[ORGAN_SLOT_PENIS] = null
		internal_organs_slot[ORGAN_SLOT_TESTICLES] = null
		internal_organs_slot[ORGAN_SLOT_VAGINA] = /obj/item/organ/vagina
		return

	internal_organs_slot[ORGAN_SLOT_VAGINA] = null
	internal_organs_slot[ORGAN_SLOT_PENIS] = /obj/item/organ/penis/knotted/big
	internal_organs_slot[ORGAN_SLOT_TESTICLES] = /obj/item/organ/testicles


/mob/living/carbon/human/species/wildshape/druid_werewolf/proc/grant_druid_werewolf_skills()
	if(!src.mind)
		return

	// True werewolf gets:
	// wrestling 5, unarmed 5, climbing 6, swimming 5.
	// Thouse yiffers can cast stuff but only 250 dev
	src.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	src.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	src.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	src.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	src.adjust_skillrank(/datum/skill/magic/holy, 5, TRUE)

	if(!src.mind.get_spell(/obj/effect/proc_holder/spell/self/claws/druid_werewolf))
		src.AddSpell(new /obj/effect/proc_holder/spell/self/claws/druid_werewolf)


/mob/living/carbon/human/species/wildshape/druid_werewolf/proc/generate_druid_wolf_name()
	var/new_wolfname = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

	druid_wolfname = new_wolfname
	name = new_wolfname
	real_name = new_wolfname

	return new_wolfname

/mob/living/carbon/human/species/wildshape/druid_werewolf/update_inv_gloves()
	remove_overlay(GLOVES_LAYER)
	remove_overlay(GLOVESLEEVE_LAYER)

/mob/living/carbon/human/species/wildshape/druid_werewolf/update_inv_shoes()
	remove_overlay(SHOES_LAYER)
	remove_overlay(SHOESLEEVE_LAYER)


// ----------------------------------------
// Anti-infection / anti-antag safety thing man
// --------------------------

/mob/living/carbon/human/species/wildshape/druid_werewolf/can_werewolf()
	return FALSE

/mob/living/carbon/human/species/wildshape/druid_werewolf/werewolf_check(werewolf_type = /datum/antagonist/werewolf/lesser)
	return null

/mob/living/carbon/human/species/wildshape/druid_werewolf/werewolf_infect_attempt()
	return null


// ================================
// Druid claw spell
// Uses normal werewolf claws.
// This spell only works while in Druid Verevolf form.
// Snowflake stuyff you may use it for your own virtue later i dont care
// ==========

/obj/effect/proc_holder/spell/self/claws/druid_werewolf
	name = "Lupine Claws"
	desc = "Unsheathe or retract your lupine claws."
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20
	ignore_cockblock = TRUE

	claw_type = /obj/item/rogueweapon/werewolf_claw

/obj/effect/proc_holder/spell/self/claws/druid_werewolf/cast(list/targets, mob/user)
	if(!istype(user, /mob/living/carbon/human/species/wildshape/druid_werewolf))
		to_chat(user, span_warning("You need a lupine form for this."))
		return FALSE

	return ..()


// =============================
// Druid Werewolf species
// Weaker than true werewolf species.
// =======================================

/datum/species/werewolf/druid
	name = "druid verevolf"
	id = "druid_werewolf"

	armor = 30

	inherent_traits = list(
		TRAIT_LONGSTRIDER,
		TRAIT_SILVER_WEAK,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_BREADY,
		TRAIT_HARDDISMEMBER,
		TRAIT_EXTREME_TEMPERATURE_IMMUNE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_BASHDOORS
	)

	inherent_biotypes = MOB_HUMANOID

	no_equip = list(
		SLOT_SHIRT,
		SLOT_HEAD,
		SLOT_WEAR_MASK,
		SLOT_ARMOR,
		SLOT_GLOVES,
		SLOT_SHOES,
		SLOT_PANTS,
		SLOT_CLOAK,
		SLOT_BELT,
		SLOT_BACK_R,
		SLOT_BACK_L,
		SLOT_S_STORE
	)

	nojumpsuit = 1
	sexes = 1

	offset_features = list(
		OFFSET_HANDS = list(0, 2),
		OFFSET_HANDS_F = list(0, 2)
	)

	soundpack_m = /datum/voicepack/werewolf
	soundpack_f = /datum/voicepack/werewolf
	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/werewolf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix
	)

	languages = list(
		/datum/language/beast
	)

	gibs_on_shapeshift = TRUE

/datum/species/werewolf/druid/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/werewolf.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)

	if(istype(H, /mob/living/carbon/human/species/wildshape/druid_werewolf))
		var/mob/living/carbon/human/species/wildshape/druid_werewolf/W = H

		if(W.wildshape_icon_state)
			H.icon_state = W.wildshape_icon_state
		else if(H.gender == FEMALE)
			H.icon_state = "wwolf_f"
		else
			H.icon_state = "wwolf_m"
	else if(H.gender == FEMALE)
		H.icon_state = "wwolf_f"
	else
		H.icon_state = "wwolf_m"

	H.update_damage_overlays()
	return TRUE
