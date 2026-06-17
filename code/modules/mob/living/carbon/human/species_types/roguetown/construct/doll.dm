/mob/living/carbon/human/species/construct/metal/porcelain
	race = /datum/species/construct/metal/porcelain
	construct = 1

/datum/species/construct/metal/porcelain
	name = "Doll"
	id = "doll"
	use_titles = TRUE
	race_titles = list("Homunculus", "Mannequin", "Marionette", "Puppet")
	desc = "<b>瓷偶</b><br>\
	艺术与工艺的巅顶之作，最初是为贵妇和富家千金提供陪伴而造。\
	它们被制作成富人的玩具或新奇装饰，不眠、不食、不流血。然而，\
	由于它们的暗黑魔法与异端起源（其更强悍的表亲也是如此），它们被造得极其\
	脆弱，以促使其服从而杜绝这些忧沉造物谋杀主人的任何可能。\
	久而久之，它们凭借智识才能被视为宝贵的资产与顾问角色，\
	是什么赋予了它们这份天赋则无人知晓。是主人想要更引人入胜的交谈？领主想要更\
	高效的文书？无论如何，谁知道那双玻璃制成的眼睛究竟映照着什么……<br> \
	<span style='color: #cc0f0f;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>-2 力量</span> |<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'> +2 智力 | +1 速度</b></span> </br> \
	<span style='color: #cc0f0f;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b><span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>无需进食, 失眠症, 无血液。极其脆弱。</span></b></br>"


	construct = 1
	skin_tone_wording = "Material"
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,NOBLOOD)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = 1
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/ingot/steel
	disliked_food = NONE
	liked_food = NONE
	inherent_traits = list(TRAIT_NOHUNGER, TRAIT_BLOODLOSS_IMMUNE, TRAIT_NOBREATH, TRAIT_NOSLEEP, TRAIT_CRITICAL_WEAKNESS,
	TRAIT_BEAUTIFUL, TRAIT_EASYDISMEMBER, TRAIT_LIMBATTACHMENT, TRAIT_NOMETABOLISM, TRAIT_NOPAIN, TRAIT_ZOMBIE_IMMUNE)
	banned_traits = list(TRAIT_CRITICAL_RESISTANCE)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mcom.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fcom.dmi'
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
	race_bonus = list(STAT_INTELLIGENCE = 2, STAT_SPEED = 1, STAT_STRENGTH = -2)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/ears/demihuman,
		/datum/customizer/organ/horns/demihuman,
		/datum/customizer/organ/tail/demihuman,
		/datum/customizer/organ/snout/anthro,
		/datum/customizer/organ/wings/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
	)
	body_markings = list(
	    /datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tall_eyes,
		/datum/body_marking/blank_face,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly,
		/datum/body_marking/waist,
		/datum/body_marking/diagonal_eyes,
		/datum/body_marking/wide_eyes,
		/datum/body_marking/stripes,
	)

/datum/species/construct/metal/porcelain/check_roundstart_eligible()
	return TRUE

/datum/species/construct/metal/porcelain/get_skin_list()
	return list(
		"Porcelain" = DOLL_PORCELAIN,
		"Sienna" = DOLL_SIENNA,
		"Lotus" = DOLL_KAZENGUN,
		"Scarlet" = DOLL_SCARLET_REACH,
		"Walnut" = DOLL_WALNUT,
		"Gloom" = DOLL_GLOOMHAVEN,
		"Ebon" = DOLL_EBON,
	)

/datum/species/construct/metal/porcelain/get_skin_list_tooltip()
	return list(
		"Porcelain <span style='border: 1px solid #161616; background-color: #[DOLL_PORCELAIN];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_PORCELAIN,
		"Sienna <span style='border: 1px solid #161616; background-color: #[DOLL_SIENNA];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_SIENNA,
		"Lotus <span style='border: 1px solid #161616; background-color: #[DOLL_KAZENGUN];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_KAZENGUN,
		"Scarlet Reach <span style='border: 1px solid #161616; background-color: #[DOLL_SCARLET_REACH];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_SCARLET_REACH,
		"Walnut <span style='border: 1px solid #161616; background-color: #[DOLL_WALNUT];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_WALNUT,
		"Gloom <span style='border: 1px solid #161616; background-color: #[DOLL_GLOOMHAVEN];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_GLOOMHAVEN,
		"Ebon <span style='border: 1px solid #161616; background-color: #[DOLL_EBON];'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>" = DOLL_EBON,
	)

/datum/species/construct/metal/porcelain/get_hairc_list()
	return sortList(list(

	"black - midnight" = "1d1b2b",

	"red - blood" = "822b2b"

	))
