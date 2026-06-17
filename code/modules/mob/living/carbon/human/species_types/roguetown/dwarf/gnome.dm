/mob/living/carbon/human/species/dwarf/gnome
	race = /datum/species/dwarf/gnome

/datum/species/dwarf/gnome
	name = "Gnome"
	id = "gnome"
	desc = "<b>侏儒</b><br>\
	侏儒是身材矮小精致的生灵，以思维敏捷和机智著称。<br>\
侏儒天生好奇心旺盛，倾向于奥术探索、工艺制造和教导他人。\
侏儒族以卓越的商贾和工匠技艺享有声誉，尽管他们迅捷的思维有时让世间其他种族觉得他们不够专注。<br>\
侏儒通常是矮人与某魔法种族（一般是精灵，当两族不争吵时）的混血后代，不过有些侏儒也带有妖精血脉。<br>\
尽管他们是混血且比一般矮人更小，大多数侏儒和矮人仍视彼此为同族。<br>\
	(+1 智力, +1 感知)"

	skin_tone_wording = "Skintone"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,YOUNGBEARD,STUBBLE,OLDGREY)
	possible_ages = ALL_AGES_LIST
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mgn.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fd.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	use_f = TRUE
	//use_m = TRUE
	custom_clothes = TRUE
	clothes_id = "dwarf"
	offset_features = list(
		OFFSET_ID = list(0,0), OFFSET_GLOVES = list(0,-4), OFFSET_WRISTS = list(0,-4),\
		OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,-5), OFFSET_HEAD = list(0,-5), \
		OFFSET_FACE = list(0,-5), OFFSET_BELT = list(0,-5), OFFSET_BACK = list(0,-4), \
		OFFSET_NECK = list(0,-5), OFFSET_MOUTH = list(0,-5), OFFSET_PANTS = list(0,0), \
		OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,-4), \
		OFFSET_BREASTS = list(0,-4), \

		OFFSET_ID_F = list(0,-4), OFFSET_GLOVES_F = list(0,-4), OFFSET_WRISTS_F = list(0,-4), OFFSET_HANDS_F = list(0,-4), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-5), OFFSET_HEAD_F = list(0,-5), \
		OFFSET_FACE_F = list(0,-5), OFFSET_BELT_F = list(0,-5), OFFSET_BACK_F = list(0,-5), \
		OFFSET_NECK_F = list(0,-5), OFFSET_MOUTH_F = list(0,-5), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES = list(0,-4), OFFSET_UNDIES_F = list(0,-4), \
		OFFSET_BREASTS_F = list(0,-4), \
		)
	race_bonus = list( STAT_INTELLIGENCE = 1, STAT_PERCEPTION = 1,)// STAT_CONSTITUTION = -1, ) //leaving off the negative con for now, if inteligence and perception is too strong together, I can put it back in
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
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human,
		)
	body_markings = list(
	)

/datum/species/dwarf/gnome/check_roundstart_eligible()
	return TRUE

/datum/species/dwarf/gnome/get_span_language(datum/language/message_language)
	if(!message_language)
		return
	if(message_language.type == /datum/language/dwarvish)
		return list(SPAN_DWARF)
//	if(message_language.type == /datum/language/common)
//		return list(SPAN_DWARF)
	return message_language.spans

/datum/species/dwarf/gnome/get_skin_list()
	return list(
		"Platinum" = SKIN_COLOR_PLATINUM,
		"Aurum" = SKIN_COLOR_AURUM,
		"Quicksilver" = SKIN_COLOR_QUICKSILVER,
		"Brass" = SKIN_COLOR_BRASS,
		"Iron" = SKIN_COLOR_IRON,
		"Malachite" = SKIN_COLOR_MALACHITE,
		"Obsidian" = SKIN_COLOR_OBSIDIAN,
		"Brimstone" = SKIN_COLOR_BRIMSTONE,
		"Jade" = SKIN_COLOR_JADE,
		"Ashen" = SKIN_COLOR_ASHEN,
		"Underdark" = SKIN_COLOR_UNDERDARK,
		"Almondvalle" = SKIN_COLOR_ALMONDVALLE,
		"Beach" = SKIN_COLOR_BEACH,
		"Shalvine Forests" = SKIN_COLOR_SHALVINE_FORESTS,
		"Lalve Steppes" = SKIN_COLOR_LALVE_STEPPES,
		"Palm" = SKIN_COLOR_PALM,
		"Naledi Coast" = SKIN_COLOR_NALEDI_COAST,
	)
/datum/species/dwarf/gnome/get_hairc_list()
	return sortList(list(
	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"brown - mud" = "362e25",
	"brown - oats" = "7a4e1e",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",

	"red - berry" = "b23434",
	"red - wine" = "b87f77",
	"red - sunset" = "bf6821",
	"red - blood" = "822b2b"
	))

/datum/species/dwarf/gnome/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/dwarf/dwarmm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/dwarf/dwarmf.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/dwarf/dwarmm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/dwarf/dwarmf.txt") )
	return randname

/datum/species/dwarf/gnome/random_surname()
	return "[pick(world.file2list("strings/rt/names/elf/elfwlast.txt"))]"
