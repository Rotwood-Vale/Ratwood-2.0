/datum/advclass/wretch/swordhunter
	name = "Sword Hunter"
	tutorial = "Hailing from Xinyi, yours is a unique art: You seek the swords of worthy foes and add them to your collection, all in worship of Matthios."
	class_select_category = CLASS_CAT_WARRIOR
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES
	outfit = /datum/outfit/job/roguetown/wretch/swordhunter
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 1 
	cmode_music = 'sound/music/combat_swordsaint.ogg'
	subclass_languages = list(/datum/language/kazengunese)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 1
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/wretch/swordhunter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Hailing from Lingyue, yours is an unique art: You seek the swords of worthy foes and add them to your collection in worship of Matiosu."))
	H.set_patron(/datum/patron/inhumen/matthios)
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/kazengunese
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	armor = /obj/item/clothing/suit/roguetown/armor/basiceast/crafteast/outlaw
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	backl = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver/outlaw
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	neck = /obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	backr = /obj/item/storage/back/bladerack
	l_hand = /obj/item/rogueweapon/greatsword/miaodao
	r_hand = /obj/item/rogueweapon/scabbard/gwstrap // they will need it
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	wretch_select_bounty(H)
