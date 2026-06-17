/mob/living/carbon/human/species/akula
	race = /datum/species/akula

/datum/species/akula
	name = "Axian"
	id = "akula"
	desc = "<b>阿克西安</b><br>\
	阿克西安人是骄傲的鲨形民族，其传承根植于海上贸易、逃税与海盗行当。\
	他们以精神坚韧、崇尚繁荣的商业活动闻名，却也因对贵族和税收深恶痛绝而声名狼藉，\
	这使他们成为歧视与猜疑的目标。<br>\
	(+1 体质, +1 意志, 水下呼吸, 海水饮用特质)"
	expanded_desc =	"阿克西安人是骄傲的鲨形民族，其传承根植于海上贸易、逃税与海盗行当。他们以精神坚韧、\
	崇尚繁荣的商业活动闻名，却也因对贵族和税收深恶痛绝而声名狼藉，这使他们成为歧视与猜疑的目标。\
	他们常常成为犯罪的替罪羊，任何异议迹象都会归咎于他们，在地区内出现叛乱活动时，往往最先被追捕。\
	此外，他们常被指控为马西奥斯信徒，其资产时常被投机取巧的阴谋家强行没收。\
	<br><br> \
	由于他们热衷于贸易、旅行以及被各王国驱逐，他们的足迹遍布世界各地，\
	时常踏足大多数人无法想象的地方。他们轻视那些他们视为\"定居者\"的人，\
	一生中频繁迁居，尤其是在最有利可图的时候。然而，许多阿克西安人若被困居一地，\
	有时会感到理智被逐渐蚕食。\
	<br><br> \
	阿克西安人曾统一于大艾诺亚共和国之下，但近来已四散各地。艾诺亚曾是海上霸主，\
	掌握着可与吉萨和兹班图人匹敌的关键贸易商品和航线。然而，大西塞亚起义后奴隶贸易的中断，\
	使共和国陷入经济与道德的混乱，许多领袖被指控信奉马西奥斯。这场动荡最终引发了残酷的艾诺亚十字军，\
	共和国分裂为数个残存邦国，由商业军阀和所谓海盗王统治。\
	然而，阿克西安人并未试图重拾旧日荣光，而是拥抱新的生活方式，在混乱中蓬勃发展。"
	species_traits = list(EYECOLOR,LIPS,STUBBLE,MUTCOLORS)
	inherent_traits = list(TRAIT_WATERBREATHING, TRAIT_SEA_DRINKER)
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mta.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fma.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
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
	race_bonus = list(STAT_WILLPOWER = 1, STAT_CONSTITUTION = 1)
	enflamed_icon = "widefire"
	attack_verb = "slash"
	attack_sound = 'sound/blank.ogg'
	miss_sound = 'sound/blank.ogg'
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/akula,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/akula,
		ORGAN_SLOT_SNOUT = /obj/item/organ/snout/akula,
		//ORGAN_SLOT_TESTICLES = /obj/item/organ/testicles,
		//ORGAN_SLOT_PENIS = /obj/item/organ/penis/tapered,
		//ORGAN_SLOT_BREASTS = /obj/item/organ/breasts,
		//ORGAN_SLOT_VAGINA = /obj/item/organ/vagina,
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
		/datum/customizer/organ/snout/akula,
		/datum/customizer/organ/tail/axian,
		/datum/customizer/organ/ears/axian,
		/datum/customizer/organ/horns/anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/belly,
		/datum/body_marking/bellyslim,
		/datum/body_marking/butt,
		/datum/body_marking/tonage,
		/datum/body_marking/tiger,
		/datum/body_marking/tiger/dark,
		/datum/body_marking/nose,
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
		/datum/descriptor_choice/scales,
		/datum/descriptor_choice/voice,
		/datum/descriptor_choice/prominent_one,
		/datum/descriptor_choice/prominent_two,
		/datum/descriptor_choice/prominent_three,
		/datum/descriptor_choice/prominent_four,
	)

	languages = list(
		/datum/language/common,
		/datum/language/abyssal
	)

/datum/species/akula/check_roundstart_eligible()
	return TRUE

/datum/species/akula/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/akula/get_random_body_markings(list/passed_features)
	return assemble_body_markings_from_set(GLOB.body_marking_sets_by_type[/datum/body_marking_set/belly], passed_features, src)

/datum/species/akula/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/random = rand(1,5)
	//Choose from a variety of sharkish colors, with a whiter secondary and tertiary
	switch(random)
		if(1)
			main_color = "668899"
			second_color = "BBCCDD"
		if(2)
			main_color = "334455"
			second_color = "DDDDEE"
		if(3)
			main_color = "445566"
			second_color = "DDDDEE"
		if(4)
			main_color = "666655"
			second_color = "DDDDEE"
		if(5)
			main_color = "444444"
			second_color = "DDDDEE"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = second_color
	return returned

/datum/species/akula/random_name(gender,unique,lastname)
	var/randname
	if(gender == MALE)
		randname = pick(world.file2list("strings/names/roguetown/axianmale.txt"))
	if(gender == FEMALE)
		randname = pick(world.file2list("strings/names/roguetown/axianfemale.txt"))
	if(prob(33))
		//Prefix
		var/prefix = pick(world.file2list("strings/names/roguetown/axianprefix.txt"))
		randname = "[prefix] [randname]"
	else
		//Suffix
		var/suffix = pick(world.file2list("strings/names/roguetown/axiansuffix.txt"))
		randname = "[randname] [suffix]"
	return randname

/datum/species/akula/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/akula/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
