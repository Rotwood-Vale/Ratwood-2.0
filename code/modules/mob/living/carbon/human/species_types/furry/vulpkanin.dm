/mob/living/carbon/human/species/vulpkanin
	race = /datum/species/vulpkanin

/datum/species/vulpkanin
	name = "Venardine"
	id = "vulpkanin"
	desc = "<b>维纳丁</b> <br>\
	维纳丁是一个形似狐狸的兽裔种族，大多数来自\
	与铁锤堡接壤的沃夫克海姆王国。不过也有一些维纳丁部落\
	起源于其他地方，尽管不来自沃夫克海姆，但仍被视为维纳丁。\
	维纳丁是一个机敏、狡黠且敏锐的民族。许多维纳丁利用他们的天性\
	来占其他种族的便宜，使他们以机智和魅力著称，\
	但也因此背负了骗子、欺诈者、诡计师和盗贼的恶名。<br>\
	(+1 感知, +1 智力, 侦探特质)"

	expanded_desc = "维纳丁是一个形似狐狸的兽裔种族，大多数来自\
	与铁锤堡接壤的沃夫克海姆王国。不过也有一些维纳丁部落\
	起源于其他地方，尽管不来自沃夫克海姆，但仍被视为维纳丁。\
	维纳丁是一个机敏、狡黠且敏锐的民族。许多维纳丁利用他们的天性\
	来占其他种族的便宜，使他们以机智和魅力著称，\
	但也因此背负了骗子、欺诈者、诡计师和盗贼的恶名。\
	<br><br> \
	由于他们的天性和名声，赛利克斯常常眷顾维纳丁及其后裔。\
	这些特质，加上维纳丁的孕期通常怀有双胞胎、三胞胎\
	甚至四胞胎，使得维纳丁部落在瓦尔格海姆的广阔森林中\
	主导了其他兽裔部落。这最终促成了沃夫克海姆王国的建立，\
	维纳丁人在其中实行统治和政治主导。\
	<br><br> \
	许多维纳丁人饱受漫游之志的驱使，成年后便踏上了探索世界的旅途，\
	多数人的旅程始于铁锤堡。这使维纳丁人在铁锤堡地区被广泛接受。\
	然而，他们的狐形特征往往让异国他乡之人警惕，因为许多铁锤堡掠夺者\
	也带有狐形特征，这是由于这两个民族及其王国之间的密切关系。\
	因此，在那些受到铁锤堡海盗掠夺威胁的地区，他们常常被猜疑和恐惧地看待。"

	default_color = "444"
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAIR,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	attack_verb = "slash"
	liked_food = GROSS | MEAT | FRIED
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	possible_ages = ALL_AGES_LIST
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mta.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fma.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
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
	inherent_traits = list(TRAIT_SLEUTH)
	race_bonus = list(STAT_PERCEPTION = 1, STAT_INTELLIGENCE = 1)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/vulpkanin,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/vulpkanin,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/vulpkanin,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/knotted,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
		)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/vulpkian,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/tail/vulpkanin,
		/datum/customizer/organ/snout/vulpkanin,
		/datum/customizer/organ/ears/vulpkanin,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/neck_feature/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/animal,
		/datum/customizer/organ/vagina/animal,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/bellysockstertiary,
		/datum/body_marking_set/belly,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/wolf,
		/datum/body_marking/plain,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/sock,
		/datum/body_marking/socklonger,
		/datum/body_marking/tips,
		/datum/body_marking/backspots,
		/datum/body_marking/front,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/harlequin,
		/datum/body_marking/harlequinreversed,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/gradient,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/waist,
		/datum/body_marking/diagonal_eyes,
		/datum/body_marking/wide_eyes,
		/datum/body_marking/stripes,
	)
	descriptor_choices = list(
		/datum/descriptor_choice/trait,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/fur,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one,
		/datum/descriptor_choice/prominent_two,
		/datum/descriptor_choice/prominent_three,
		/datum/descriptor_choice/prominent_four,
	)
	languages = list(
		/datum/language/common,
		/datum/language/canilunzt
	)

/datum/species/vulpkanin/check_roundstart_eligible()
	return TRUE

/datum/species/vulpkanin/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/vulpkanin/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/vulpkanin/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)

/datum/species/vulpkanin/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of mostly brightish, animal, matching colors
	switch(random)
		if(1)
			main_color = "fc7b21"
			second_color = "ffdbc1"
		if(2)
			main_color = "fd9c22"
			second_color = "fce4c5"
		if(3)
			main_color = "ffb824"
			second_color = "feebc2"
		if(4)
			main_color = "fbc32a"
			second_color = "ffedba"
		if(5)
			main_color = "fc5e21"
			second_color = "ffd2c0"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = "373330"
	return returned

/datum/species/vulpkanin/get_random_body_markings(list/passed_features)
	return assemble_body_markings_from_set(GLOB.body_marking_sets_by_type[/datum/body_marking_set/bellysockstertiary], passed_features, src)
