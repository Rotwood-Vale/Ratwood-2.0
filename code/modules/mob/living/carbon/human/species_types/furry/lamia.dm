/mob/living/carbon/human/species/lamia
	race = /datum/species/lamia

/datum/species/lamia
	name = "Lamia"
	id = "lamia"
	desc = "<b>Lamia</b><br>\
	The monstrous spawn of Abyssor, snake and humen conjoined together, the deepkin and merfolk. \
	Sirens, mermaids, nagas and many others fall into lamia categorization. While one could consider them to be of Dendor, he had no hand in their creation. \
	(+1 Strength, -1 Speed, Strong Kicks, Longstrider Trait, Venomous Trait)"

	expanded_desc = "The monstrous spawn of Abyssor, snake and humen conjoined together, the deepkin and merfolk. \
	Sirens, mermaids, nagas and many others fall into lamia categorization. While one could consider them to be of Dendor, he had no hand in their creation. \
	<br><br> \
	Lamia are widespread in the southern coastal regions, where their tribes have settled in aeons ago, much of their written and oral history is filled with accounts \
	of grand raids on coastal regions, for they have been terrorizing any race that has dared to settle near their waters. For this, they are widely shunned by the other races, \
	with the exception of Axians and some coast-dwelling Sisseans with whom they share their natural heartlands. Many a sailor has met their end at the claws of Lamias. \
	<br><br> \
	Yet... not all of them have stayed in the depths of the abyss, for some of the clans have moved far away from the coastal regions, settling in swamps, forests and even deserts, having spread themselves far and wide aeons ago."

	skin_tone_wording = "Brood"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, LIPS, HAIR, FACEHAIR, STUBBLE, LAMIAN_TAIL, OLDGREY)
	use_skintones = 1
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	possible_ages = ALL_AGES_LIST
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi' // lips
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi' //lips
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	clothes_id = "lamia"
	custom_clothes = TRUE
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
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
	inherent_traits = list(TRAIT_LONGSTRIDER, TRAIT_VENOMOUS, TRAIT_LAMIAN_TAIL, TRAIT_CALTROPIMMUNE)
	race_bonus = list(STAT_STRENGTH = 1, STAT_SPEED = -1)
	enflamed_icon = "widefire"
/* I have no idea how rendering works and I can't figure it out!!
	bodypart_overrides = list(
		BODY_ZONE_LAMIAN_TAIL = /obj/item/bodypart/lamian_tail,
		BODY_ZONE_L_LEG = /obj/item/bodypart/lamian_tail,
		BODY_ZONE_R_LEG = /obj/item/bodypart/lamian_tail
	)
*/
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/lamia_forked,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
//		ORGAN_SLOT_TAIL = /obj/item/organ/tail/lamian_tail,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
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
		/datum/customizer/organ/tail_feature/anthro,
		/datum/customizer/organ/snout/lamia,
		/datum/customizer/organ/ears/lamia,
		/datum/customizer/organ/frills/anthro, //add elf ears
		/datum/customizer/organ/testicles/anthro,
//		/datum/customizer/organ/tail/lamia,
		/datum/customizer/organ/horns/lamia,
		/datum/customizer/organ/penis/lamia, // only tapered or hemi tapered or tentacle
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
//		/datum/body_marking_set/lamian_tail // how the fuck do I get it to display over tail
	)

	languages = list(
		/datum/language/common,
		/datum/language/abyssal //we are hellenic in this bitch
	)

	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/plain,
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
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin_lamia,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one_wild,
		/datum/descriptor_choice/prominent_two_wild,
		/datum/descriptor_choice/prominent_three_wild,
		/datum/descriptor_choice/prominent_four_wild,
	)

	allowed_taur_types = list(
		/obj/item/bodypart/taur/lamia,
		/obj/item/bodypart/taur/lamiastriped,
		/obj/item/bodypart/taur/fatlamia,
		/obj/item/bodypart/taur/mermaid,
		/obj/item/bodypart/taur/orca,
		/obj/item/bodypart/taur/tentacle
	)
	forced_taur = TRUE

/datum/species/lamia/check_roundstart_eligible()
	return TRUE

/datum/species/lamia/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/lamia/on_species_gain(mob/living/carbon/C, datum/species/old_species) // one of those auto-appends a dot at the end of player speech
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/lamia/on_species_loss(mob/living/carbon/C) // one of those auto-appends a dot at the end of player speech
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/lamia/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/third_color
	var/random = rand(1,6)
	switch(random)
		if(1)
			main_color = "FFFFFF"
			second_color = "333333"
			third_color = "333333"
		if(2)
			main_color = "FFFFDD"
			second_color = "DD6611"
			third_color = "AA5522"
		if(3)
			main_color = "DD6611"
			second_color = "FFFFFF"
			third_color = "DD6611"
		if(4)
			main_color = "CCCCCC"
			second_color = "FFFFFF"
			third_color = "FFFFFF"
		if(5)
			main_color = "AA5522"
			second_color = "CC8833"
			third_color = "FFFFFF"
		if(6)
			main_color = "FFFFDD"
			second_color = "FFEECC"
			third_color = "FFDDBB"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = third_color
	return returned

/datum/species/lamia/get_skin_list() // nothing ever happens
	return list(
		"Ghost" = SKIN_COLOR_GHOST,
		"Grenzel Woods" = SKIN_COLOR_GRENZEL_WOODS,
		"Dandelion Creek" = SKIN_COLOR_DANDELION_CREEK,
		"Roseveil" = SKIN_COLOR_ROSEVEIL,
		"Azuregrove" = SKIN_COLOR_AZUREGROVE,
		"Arborshome" = SKIN_COLOR_ARBORSHOME,
		"Almondvalle" = SKIN_COLOR_ALMONDVALLE,
		"Walnut Woods" = SKIN_COLOR_WALNUT_WOODS,
		"Timberborn" = SKIN_COLOR_TIMBERBORN,
		"Lotus Coast" = SKIN_COLOR_LOTUS_COAST,
		"Etruscan Swamps" = SKIN_COLOR_ETRUSCAN_SWAMPS,
		"Shalvine Forests" = SKIN_COLOR_SHALVINE_FORESTS,
		"Lalvestine Thickets" = SKIN_COLOR_LALVE_STEPPES,
		"Ebon Coverts"	= SKIN_COLOR_NALEDI_COAST,
		"Ochre" = SKIN_COLOR_OCHRE,
		"Meadow" = SKIN_COLOR_MEADOW,
		"Olive" = SKIN_COLOR_OLIVE,
		"Green" = SKIN_COLOR_GREEN,
		"Moss" = SKIN_COLOR_MOSS,
		"Taiga" = SKIN_COLOR_TAIGA,
		"Bronze" = SKIN_COLOR_BRONZE,
		"Red" = SKIN_COLOR_RED,
		"Frost" = SKIN_COLOR_FROST,
		"Abyss" = SKIN_COLOR_ABYSS,
		"Abyssal" = SKIN_COLOR_ABYSSAL,
		"Teal" = SKIN_COLOR_TEAL,
		"Hadal" = SKIN_COLOR_HADAL,
		"Bone" = SKIN_COLOR_BONE,
	)

/datum/species/lamia/random_name(gender,unique,lastname)
	var/randname
	if(gender == MALE)
		randname = pick(world.file2list("strings/names/roguetown/lamiamale.txt"))
	if(gender == FEMALE)
		randname = pick(world.file2list("strings/names/roguetown/lamiafemale.txt"))
	return randname
