/************************************************************
 * Seelie tuning
 ************************************************************/
#define SEELIE_GLOW_OUTER_RANGE 3
#define SEELIE_GLOW_INNER_RANGE 1
#define SEELIE_GLOW_POWER 1
#define SEELIE_GLOW_COLOR "#d4fcac"
#define SEELIE_AURA_UPDATE_INTERVAL (1 SECONDS)

/mob/living/carbon/human/species/seelie
	race = /datum/species/seelie
	gender = FEMALE

/datum/species/seelie
	name = "Seelie"
	id = "seelie"
	desc = "<b>Seelie</b><br>\
	The smallest of fae-folk, Seelie are mysterious spirits of luck and mischief. \
	They drift where fortunes turn, blessing some and cursing others with the same smile.<br>\
	(+4 Perception, +2 Intelligence, +2 Fortune, +7 Speed, -6 Constitution, -1 Willpower)"

	skin_tone_wording = "Elemental Connection"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOFALLDAMAGE2, TRAIT_TINY)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/f/fm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/female/elf
	soundpack_f = /datum/voicepack/female/elf
	offset_features = list(
		OFFSET_ID = list(0, 1), OFFSET_GLOVES = list(0, 1), OFFSET_WRISTS = list(0, 1),\
		OFFSET_CLOAK = list(0, 1), OFFSET_FACEMASK = list(0, 1), OFFSET_HEAD = list(0, 1),\
		OFFSET_FACE = list(0, 1), OFFSET_BELT = list(0, 1), OFFSET_BACK = list(0, 1),\
		OFFSET_NECK = list(0, 1), OFFSET_MOUTH = list(0, 1), OFFSET_PANTS = list(0, 1),\
		OFFSET_SHIRT = list(0, 1), OFFSET_ARMOR = list(0, 1), OFFSET_HANDS = list(0, 1), OFFSET_UNDIES = list(0, 1), OFFSET_BREASTS = list(0, 1),\
		OFFSET_ID_F = list(0, -1), OFFSET_GLOVES_F = list(0, 0), OFFSET_WRISTS_F = list(0, 0), OFFSET_HANDS_F = list(0, 0),\
		OFFSET_CLOAK_F = list(0, 0), OFFSET_FACEMASK_F = list(0, -1), OFFSET_HEAD_F = list(0, -1),\
		OFFSET_FACE_F = list(0, -1), OFFSET_BELT_F = list(0, 0), OFFSET_BACK_F = list(0, -1),\
		OFFSET_NECK_F = list(0, -1), OFFSET_MOUTH_F = list(0, -1), OFFSET_PANTS_F = list(0, 0),\
		OFFSET_SHIRT_F = list(0, 0), OFFSET_ARMOR_F = list(0, 0), OFFSET_UNDIES_F = list(0, 0), OFFSET_BREASTS_F = list(0, 0),\
	)
	race_bonus = list(
		STAT_PERCEPTION = 4,
		STAT_INTELLIGENCE = 2,
		STAT_CONSTITUTION = -6,
		STAT_WILLPOWER = -1,
		STAT_SPEED = 7,
		STAT_FORTUNE = 2,
	)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elfw,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/seelie,
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
		/datum/customizer/organ/tail/anthro,
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/ears/anthro,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/frills/anthro,
		/datum/customizer/organ/wings/seelie,
		/datum/customizer/organ/neck_feature/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
	)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
		/datum/body_marking/wolf,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/bellyscale,
		/datum/body_marking/bellyscaleslim,
		/datum/body_marking/bellyscalesmooth,
		/datum/body_marking/bellyscaleslimsmooth,
		/datum/body_marking/buttscale,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tie,
		/datum/body_marking/tiesmall,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/drake_eyes,
		/datum/body_marking/tonage,
		/datum/body_marking/spotted,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_all,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)
	languages = list(
		/datum/language/common,
		/datum/language/faexin,
	)
	stress_examine = TRUE
	stress_desc = span_red("A tiny seelie, mischievous in nature.")

/datum/species/seelie/check_roundstart_eligible()
	return TRUE

/datum/species/seelie/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	passtable_on(C, SPECIES_TRAIT)
	C.pass_flags |= PASSMOB
	// This fork doesn't support default_scale_x/y, so apply scale through resize+update_transform.
	if(!istype(old_species, /datum/species/seelie))
		C.resize = 0.5
		C.update_transform()
	C.set_mob_offsets("pixie_hover", _x = 0, _y = 10)
	C.aura = TRUE
	C.seelie_next_aura_tick = 0
	C.seelie_glow_enabled = TRUE
	C.update_seelie_glow()
	if(ishuman(C))
		apply_luck_aura(C)

/datum/species/seelie/after_creation(mob/living/carbon/C)
	..()
	to_chat(C, span_info("I can speak Faexin with ,p before my speech."))
	C.verbs |= /mob/living/carbon/human/proc/Turnlight
	C.verbs |= /mob/living/carbon/proc/switchaura

/datum/species/seelie/on_species_loss(mob/living/carbon/C, datum/species/new_species)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	passtable_off(C, SPECIES_TRAIT)
	C.pass_flags &= ~PASSMOB
	// Revert Seelie scaling when species is removed.
	if(!istype(new_species, /datum/species/seelie))
		C.resize = 2
		C.update_transform()
	C.seelie_next_aura_tick = 0
	C.seelie_glow_enabled = FALSE
	C.reset_offsets("pixie_hover")
	C.set_light(0, 0, null)
	// Clean up aura effects from nearby mobs.
	for(var/mob/living/carbon/human/victim in range(1, C))
		victim.remove_status_effect(/datum/status_effect/buff/seelie/happy)
		victim.remove_status_effect(/datum/status_effect/buff/seelie/sad)
	C.verbs -= /mob/living/carbon/human/proc/Turnlight
	C.verbs -= /mob/living/carbon/proc/switchaura

/datum/species/seelie/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/seelie/get_skin_list()
	return list(
		"Water" = SKIN_COLOR_AQUARELA,
		"Soil" = SKIN_COLOR_LAMA,
		"Rock" = SKIN_COLOR_ROCKHILL,
		"Air" = SKIN_COLOR_CALVUS,
		"Fire" = SKIN_COLOR_SANGUE,
		"Flora" = SKIN_COLOR_AMAZONIA,
		"Lightning" = SKIN_COLOR_PLANETAR,
	)

/datum/species/seelie/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",
	))

/datum/species/seelie/random_name(gender, unique, lastname)
	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick(world.file2list("strings/rt/names/other/fairyf.txt"))
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick(world.file2list("strings/rt/names/other/fairyf.txt"))
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick(world.file2list("strings/rt/names/other/fairyf.txt"))
		if(gender == FEMALE)
			randname = pick(world.file2list("strings/rt/names/other/fairyf.txt"))
	return randname

/datum/species/seelie/random_surname()
	return " [pick(world.file2list("strings/rt/names/other/fairyf.txt"))]"

/datum/species/seelie/proc/on_middle_click(mob/living/carbon/human/target, mob/ripper)
	if(isseelie(ripper) || target.pulledby != ripper)
		return FALSE
	if(!has_wings(target))
		to_chat(ripper, span_notice("[target] is missing their wings."))
		return FALSE
	ripper.visible_message(span_danger("[ripper] begins to rip [target]'s wings..."), span_danger("I begin to rip [target]'s wings..."), ignored_mobs = target)
	to_chat(target, span_userdanger("[ripper] begins to rip your wings off..."))
	if(!do_mob(ripper, target, 8 SECONDS))
		return TRUE
	if(target.pulledby != ripper)
		to_chat(ripper, span_notice("I have to keep ahold of [target] to rip their wings off!"))
		return TRUE
	if(!has_wings(target))
		to_chat(ripper, span_notice("[target] is already missing their wings."))
		return FALSE
	var/obj/item/organ/wings/seelie/wing = target.getorganslot(ORGAN_SLOT_WINGS)
	wing.Remove(target)
	wing.forceMove(target.drop_location())
	ripper.put_in_hands(wing)
	target.update_body_parts(TRUE)
	var/obj/item/bodypart/BP = target.get_bodypart(BODY_ZONE_PRECISE_NECK)
	BP?.add_wound(/datum/wound/fracture/neck)
	target.apply_damage(70, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
	target.set_heartattack(TRUE)
	target.visible_message(span_danger("[target] clutches at [target.p_their()] chest as if [target.p_their()] heart stopped!"))
	if(!isdead(target))
		playsound(target, 'sound/vo/female/gen/scream (2).ogg', 140)
		var/const/seelie_scream_range = 4
		target.audible_message(
			span_userdanger("[target] screams in agony, inflicting a curse on you for the vile deed done to [target.p_them()]!"),
			null,
			seelie_scream_range,
			span_danger("You scream in agony, inflicting a curse on those around you as punishment for their vile deeds!")
		)
		for(var/mob/living/carbon/C in view(seelie_scream_range, target))
			if(C == target)
				continue
			C.adjustEarDamage(0, 35)
			C.confused += 40
			C.Jitter(50)
			C.apply_status_effect(/datum/status_effect/debuff/seelie_wing_curse)
	return TRUE

/datum/species/seelie/proc/has_wings(mob/living/carbon/human/owner)
	return !!owner?.getorganslot(ORGAN_SLOT_WINGS)

/datum/species/seelie/proc/regenerate_wings(mob/living/carbon/human/owner)
	owner.set_heartattack(FALSE)
	var/obj/item/organ/wings/wing = owner.getorganslot(ORGAN_SLOT_WINGS)
	if(!wing)
		var/wing_type = owner.dna.species.organs[ORGAN_SLOT_WINGS]
		var/obj/item/organ/wings/new_wings = new wing_type()
		new_wings.Insert(owner)

/datum/species/seelie/proc/fairy_hover(mob/living/carbon/human/owner)
	if(!owner.resting && !owner.wallpressed)
		animate(owner, pixel_y = owner.base_pixel_y + 12, time = 0.5 SECONDS, easing = SINE_EASING)
		animate(pixel_y = owner.base_pixel_y + 8, time = 0.5 SECONDS, easing = SINE_EASING)

/datum/species/seelie/spec_life(mob/living/carbon/human/owner)
	. = ..()
	if(is_seelie_floating(owner))
		owner.set_mob_offsets("pixie_hover", _x = 0, _y = 10)
		fairy_hover(owner)
	else
		owner.reset_offsets("pixie_hover")
	if(owner.seelie_glow_enabled && (!owner.light_power || owner.light_color != SEELIE_GLOW_COLOR))
		owner.update_seelie_glow()
	if(!owner.IsSleeping() && world.time >= owner.seelie_next_aura_tick)
		owner.seelie_next_aura_tick = world.time + SEELIE_AURA_UPDATE_INTERVAL
		apply_luck_aura(owner)

/datum/species/seelie/proc/apply_luck_aura(mob/living/carbon/human/owner)
	var/desired_effect = owner.aura ? /datum/status_effect/buff/seelie/happy : /datum/status_effect/buff/seelie/sad
	var/undesired_effect = owner.aura ? /datum/status_effect/buff/seelie/sad : /datum/status_effect/buff/seelie/happy
	owner.remove_status_effect(undesired_effect)
	owner.apply_status_effect(desired_effect)
	for(var/mob/living/carbon/human/victim in range(1, owner))
		if(victim == owner || isseelie(victim))
			continue
		victim.remove_status_effect(undesired_effect)
		victim.apply_status_effect(desired_effect)

/datum/species/seelie/proc/is_seelie_floating(mob/living/carbon/human/owner)
	return !owner.incapacitated(ignore_restraints = TRUE) && (owner.mobility_flags & MOBILITY_STAND) && has_wings(owner) && !owner.buckled

/datum/species/seelie/is_floor_hazard_immune(mob/living/carbon/human/owner)
	return is_seelie_floating(owner)

/mob/living/carbon/human/proc/Turnlight()
	set name = "Seelie Glow"
	set category = "Seelie"
	if(!isseelie(src))
		return
	seelie_glow_enabled = !seelie_glow_enabled
	update_seelie_glow()
	if(!seelie_glow_enabled)
		to_chat(src, span_notice("I stop glowing."))
	else
		to_chat(src, span_notice("I begin to glow once more."))

/mob/living/carbon/proc/update_seelie_glow()
	if(seelie_glow_enabled)
		set_light(l_outer_range = SEELIE_GLOW_OUTER_RANGE, l_inner_range = SEELIE_GLOW_INNER_RANGE, l_power = SEELIE_GLOW_POWER, l_color = SEELIE_GLOW_COLOR)
	else
		set_light(0, 0, null)

/mob/living/carbon/proc/switchaura()
	set name = "Luck Aura"
	set category = "Seelie"
	if(!isseelie(src))
		return
	aura = !aura
	seelie_next_aura_tick = 0
	if(aura)
		to_chat(src, span_warning("My aura is now one of blessing."))
		log_message("[key_name(src)] has switched their aura to apply good luck.", LOG_GAME)
	else
		to_chat(src, span_warning("My aura is now one of misery."))
		log_message("[key_name(src)] has switched their aura to apply bad luck.", LOG_GAME)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/datum/species/seelie/seelie_species = H.dna?.species
		if(istype(seelie_species))
			seelie_species.apply_luck_aura(H)

#undef SEELIE_AURA_UPDATE_INTERVAL
#undef SEELIE_GLOW_COLOR
#undef SEELIE_GLOW_POWER
#undef SEELIE_GLOW_INNER_RANGE
#undef SEELIE_GLOW_OUTER_RANGE
