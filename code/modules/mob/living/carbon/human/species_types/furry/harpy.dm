/mob/living/carbon/human/species/harpy
	race = /datum/species/harpy

/datum/species/harpy
	name = "Harpy"
	id = "harpy"
	desc = "<b>Harpy</b><br>\
	Harpies, or less ceremoniously known as 'magpies,' resemble the half-kin in appearance at first glance. \
	One would rightfully assume they are similar in nature- with accuracy even, much to the harpies' chagrin. \
	Harpies have been uplifted and reconnected to divinity by Eora, having developed culture of music and song which caught the attention of such a goddess. \
	Their songs and voices may be their own, or proud mimicking other voices they've heard with unnatural accuracy. \
	\
	<span style='color: #cc0f0f;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>-3 CON | -2 STR</span> |<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'> +1 PER | +1 INT | +2 SPD</b></span> </br> \
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>Flight | Innate Singing | Strong Bites</b></span> </br> \
	<span style='color: #cc0f0f;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>Can't wear boots</span> | <span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>Slight Fall Damage Reduction </span></b>"
	
	expanded_desc = "<b>Harpy</b><br>\
	Harpies, or less ceremoniously known as magpies, resemble the half-kin in appearance at first glance. \
	One would rightfully assume they are similar in nature- with accuracy even, much to the harpies chagrin. \
	Harpies have been uplifted and reconnected to divinity by Eora, having developed culture of music and song which caught the attention of such a goddess. \
	Their songs and voices may be their own, or proud mimicking other voices theyve heard with unnatural accuracy. \
	\
	Whilst harpies may fly, their freedom is weighed by corruption of fleshcrafting to this day. Complete open-air freedom is still foreign to them. \
	Harpies tend to live and gather in colonies at the tops of great sequoia forests and in nearby cliffs. Due to their laden flight, they must employ use of updrafts and proximity to large objects or structures to bolster their limited range and air-dancing performances. \
	Their serene songs and blissful music can be heard echoing far below, guiding travelers and thieves both to respite... or treasure. For as lifted into grace as they might be, these magpies earn such a nickname from instinctual Matthiosan greed and love for anything that shines. \
	Yet if one can work past that distrust and compensate them well, harpies make for unparalleled couriers. </br>"
	skin_tone_wording = "Ancestry"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, LIPS, HAIR, HARPY, OLDGREY, MUTCOLORS)
	default_features = MANDATORY_FEATURE_LIST

	possible_ages = ALL_AGES_LIST
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/harpy.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/harpy.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	stress_examine = TRUE
	stress_desc = span_red("Farking birdbrains...")

	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)

	race_bonus = list(STAT_CONSTITUTION = -3, STAT_STRENGTH = -2, STAT_PERCEPTION = 1, STAT_INTELLIGENCE = 1, STAT_SPEED = 2)
	inherent_traits = list(TRAIT_CALTROPIMMUNE, TRAIT_NOFALLDAMAGE1, TRAIT_STRONGBITE) // hahahahahh 
	inherent_skills = list(
		/datum/skill/misc/music = 3,
	)

	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/harpy,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/harpy,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/harpy,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/harpy,
		ORGAN_SLOT_VOICE = /obj/item/organ/vocal_cords/harpy,
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
		/datum/customizer/organ/ears/harpy,
		/datum/customizer/organ/tail/harpy,
		/datum/customizer/organ/wings/harpy,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/anthro,
		/datum/customizer/organ/snout/harpy,
		/datum/customizer/organ/neck_feature/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/socks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/harpy_feet_claws,
		/datum/body_marking_set/harpy_leg,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_harpy,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)
	
/datum/species/harpy/check_roundstart_eligible()
	return TRUE

/datum/species/harpy/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/harpy/on_species_gain(mob/living/carbon/C, datum/species/old_species) // one of those auto-appends a dot at the end of player speech
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/harpy/on_species_loss(mob/living/carbon/C) // one of those auto-appends a dot at the end of player speech
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/harpy/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/random = rand(1,8)
	//Choose from a variety of mostly brightish, animal, matching colors
	switch(random)
		if(1)
			main_color = ORANGE_FUR
		if(2)
			main_color = LIGHTGREY_FUR
		if(3)
			main_color = DARKGREY_FUR
		if(4)
			main_color = LIGHTORANGE_FUR
		if(5)
			main_color = LIGHTBROWN_FUR
		if(6)
			main_color = WHITEBROWN_FUR
		if(7)
			main_color = DARKBROWN_FUR
		if(8)
			main_color = BLACK_FUR
	returned["mcolor"] = main_color
	returned["mcolor2"] = main_color
	returned["mcolor3"] = main_color
	return returned

/datum/species/harpy/get_skin_list()
	return list(
		"Grenzelhoft" = SKIN_COLOR_GRENZELHOFT,
		"Hammerhold" = SKIN_COLOR_HAMMERHOLD,
		"Avar" = SKIN_COLOR_AVAR,
		"Otava" = SKIN_COLOR_OTAVA,
		"Etrusca" = SKIN_COLOR_ETRUSCA,
		"Gronn" = SKIN_COLOR_GRONN,
		"Giza" = SKIN_COLOR_GIZA,
		"Shalvistine" = SKIN_COLOR_SHALVISTINE,
		"Lalvestine" = SKIN_COLOR_LALVESTINE,
		"Kazengun" = SKIN_COLOR_KAZENGUN,
		"Naledi" = SKIN_COLOR_NALEDI
	)

/datum/species/harpy/get_skin_list_tooltip()
	return list(
		"Grenzelhoft <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_GRENZELHOFT];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_GRENZELHOFT,
		"Hammerhold <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_HAMMERHOLD];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_HAMMERHOLD,
		"Avar <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_AVAR];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_AVAR,
		"Otava <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_OTAVA];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_OTAVA,
		"Etrusca <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_ETRUSCA];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_ETRUSCA,
		"Gronn <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_GRONN];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_GRONN,
		"Giza <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_GIZA];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_GIZA,
		"Shalvistine <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_SHALVISTINE];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_SHALVISTINE,
		"Lalvestine <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_LALVESTINE];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_LALVESTINE,
		"Kazengun <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_KAZENGUN];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_KAZENGUN,
		"Naledi <span style='border: 1px solid #161616; background-color: #[SKIN_COLOR_NALEDI];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = SKIN_COLOR_NALEDI
	)

/obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin
	slot_flags = null
	name = "harpy's feet skin"
	desc = ""
	icon_state = null
	body_parts_covered = FEET|LEGS
	body_parts_inherent = FEET|LEGS
	armor = list("blunt" = 90, "slash" = 90, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 75
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/skin_armor/harpy_skin/obj_destruction()
	visible_message("The skin on the feet is torn!", span_bloody("<b>THE SKIN ON MY FEET IS TORN!!</b>"))
