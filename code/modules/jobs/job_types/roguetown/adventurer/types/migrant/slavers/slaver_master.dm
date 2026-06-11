
/datum/advclass/slaver/master
	name = "兹班图裔 奴隶主"
	tutorial = "你是 兹班图裔 奴隶商队的首领。你自 兹班图的 西方荒漠来到大陆，希望靠训练与买卖那些不幸的劳工来积攒财富。 \
	在有些人眼中，这门行当卑劣可憎；但毫无疑问，在你回到 Zybantynian 沙海之前，它最能让你的钱袋鼓起来。"
	outfit = /datum/outfit/job/roguetown/slaver/master
	traits_applied = list(TRAIT_XENOPHOBIC, TRAIT_PERFECT_TRACKER, TRAIT_SLEUTH, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER)
	category_tags = list(CTAG_SLAVER_MASTER)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 1, // Small boon
	)

	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
	)


	subclass_languages = list(
		/datum/language/celestial
	)

	subclass_stashed_items = list( 
		"奴役工具包" = /obj/item/storage/roguebag/slaver/master,
		"铺盖卷" = /obj/item/bedroll,
		"整肉派" = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat,
	) // Gear to allow them to stay in the bog in case they are outlawed.

/datum/outfit/job/roguetown/slaver/master/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_info("我可以在说话前输入 ,c 来使用 萨玛格罗斯语。"))
	to_chat(H, span_info("我开局会携带一批用于捕奴与野外求生的物资。"))
	head = /obj/item/clothing/head/roguetown/helmet/sallet/zyb		// thematic as it is the same helmet jannisaries use. Maybe a retired soldier with hired goons?
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord		// an arming jacket won't hurt
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backl = /obj/item/storage/backpack/rogue/backpack
	beltl = /obj/item/flashlight/flare/torch/lantern/copper
	beltr = /obj/item/rogueweapon/whip/antique
	id = /obj/item/clothing/ring/active/nomag
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 2,
		/obj/item/needle = 1,
		/obj/item/rope/chain = 2, 
		/obj/item/flint = 1, 
		/obj/item/clothing/neck/roguetown/cursed_collar = 2,
		/obj/item/clothing/gloves/roguetown/nomagic = 2,
		/obj/item/rogueweapon/surgery/cautery/branding/slave = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1, // Buying slaves is expensive!
	)
	H.cmode_music = 'sound/music/combat_zybantine.ogg'

/obj/item/storage/roguebag/slaver/master
	populate_contents = list(
	/obj/item/rope/chain,
	/obj/item/rope/chain,
	/obj/item/rope/chain,
	/obj/item/clothing/neck/roguetown/cursed_collar,
	/obj/item/clothing/neck/roguetown/cursed_collar,
	/obj/item/clothing/neck/roguetown/collar/leather/nomagic,
	/obj/item/clothing/neck/roguetown/collar/leather/nomagic,
	/obj/item/clothing/gloves/roguetown/nomagic,
	)
