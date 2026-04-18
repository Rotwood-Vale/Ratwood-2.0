/mob/living/carbon/human/species/shadekin
	race = /datum/species/shadekin

/datum/species/shadekin
	name = "Shadekin"
	id = "shadekin"
	desc = "<b>Shadekin</b><br>\
	Mysterious beings of shadow and twilight, the Shadekin are enigmatic creatures whose origins \
	are lost to the mists of time. They are intrinsically tied to darkness itself, drawing sustenance \
	and power from the absence of light. Their bodies, while appearing solid, seem to shimmer and \
	shift at the edges, as if the shadows cling to them of their own accord. \
	Shadekin are naturally curious and often mischievous, driven by an insatiable desire to observe \
	the world of mortals from the safety of shadow. They are fragile beings however, taking greater harm \
	from physical blows and fire than most races. In darkness they find solace, their wounds mending \
	and their spirits restored. When exposed to prolonged light they grow weary, and when their \
	shadow energy is spent they fall into a deep slumber wherever they stand. <br>\
	(Light: +20% Brute/Burn taken | Dim: Normal | Dark: -20% Brute/Burn taken, Passive Healing, Dark Sight)"

	skin_tone_wording = "Shadow Hue"

	species_traits = list(EYECOLOR, HAIR, LIPS)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT

	brutemod = 1
	burnmod = 1

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,0), OFFSET_HEAD = list(0,0), \
		OFFSET_FACE = list(0,0), OFFSET_BELT = list(0,0), OFFSET_BACK = list(0,0), \
		OFFSET_NECK = list(0,0), OFFSET_MOUTH = list(0,0), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,0), OFFSET_UNDIES = list(0,0), \
		OFFSET_ID_F = list(0,0), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,0), OFFSET_HEAD_F = list(0,0), \
		OFFSET_FACE_F = list(0,0), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,0), \
		OFFSET_NECK_F = list(0,0), OFFSET_MOUTH_F = list(0,0), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,0), \
		)

	inherent_traits = list(TRAIT_DARKVISION)

	race_bonus = list(STAT_SPEED = 1, STAT_PERCEPTION = 1)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/shadekin,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)

	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		)

	body_marking_sets = list(
		/datum/body_marking_set/none,
	)

	body_markings = list()

	languages = list(
		/datum/language/common,
	)

	stress_examine = TRUE
	stress_desc = span_red("A shadow creature... unnerving.")

/datum/species/shadekin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	// Initialize shadekin component for dark healing, void walk tracking, etc.
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!H.GetComponent(/datum/component/shadekin_energy))
			H.AddComponent(/datum/component/shadekin_energy)

/datum/species/shadekin/after_creation(mob/living/carbon/C)
	..()

/datum/species/shadekin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	// Remove shadow energy component
	var/datum/component/shadekin_energy/comp = C.GetComponent(/datum/component/shadekin_energy)
	if(comp)
		qdel(comp)
		
/datum/species/shadekin/check_roundstart_eligible()
	return TRUE

/datum/species/shadekin/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/shadekin/get_skin_list()
	return list(
		"Void" = "#1a1a2e",
		"Twilight" = "#2d1b4e",
		"Dusk" = "#1b2d4e",
		"Eclipse" = "#0d0d0d",
		"Nightshade" = "#1a0a2e",
		"Murk" = "#2e2e1a",
		"Ash" = "#3d3d3d",
		"Storm" = "#2a2a3a",
		"Umbra" = "#0a0a1e",
		"Gloom" = "#1e1e2a",
	)

/datum/species/shadekin/get_hairc_list()
	return sortList(list(
		"shadow - void" = "0d0d1a",
		"shadow - twilight" = "1a0d2e",
		"shadow - dusk" = "0d1a2e",
		"shadow - eclipse" = "050505",
		"shadow - silver" = "a0a0b0",
	))

/datum/species/shadekin/random_name(gender,unique,lastname)
	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/shadekinm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/shadekinf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/shadekinm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/shadekinf.txt") )
	return randname

/datum/species/shadekin/random_surname()
	return " [pick(world.file2list("strings/rt/names/other/shadekinlast.txt"))]"

/// Override apply_damage to dynamically adjust brutemod/burnmod based on light level.
/// Light (lumcount >= 0.5): 1.2x damage taken (vulnerable in light)
/// Dim (0.2 <= lumcount < 0.5): 1.0x damage taken (normal)
/// Dark (lumcount < 0.2): 0.8x damage taken (resilient in shadow)
/datum/species/shadekin/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, mob/living/carbon/human/H, forced = FALSE, spread_damage = FALSE)
	var/turf/T = get_turf(H)
	if(T)
		var/lum = T.get_lumcount()
		if(lum >= 0.5) // Bright light - vulnerable
			brutemod = 1.2
			burnmod = 1.2
		else if(lum >= 0.2) // Dim light - normal
			brutemod = 1.0
			burnmod = 1.0
		else // Darkness - resistant
			brutemod = 0.8
			burnmod = 0.8
	else
		brutemod = 1.0
		burnmod = 1.0
	// Call parent apply_damage which will use the now-updated brutemod/burnmod
	. = ..()
	// Reset to default after calculation
	brutemod = 1
	burnmod = 1

/// Night vision eyes for Shadekin - grants permanent dark sight
/obj/item/organ/eyes/night_vision/shadekin
	name = "shadow eyes"
	desc = "Eyes that see through the darkness as if it were day."
	see_in_dark = 12
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
