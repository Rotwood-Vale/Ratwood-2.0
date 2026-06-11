/datum/advclass/mercenary/newmoon
	name = "新月 咒剑士"
	tutorial = "Zybantia 的 新月 咒剑士，是 Lalvestine 某片未知地域中一座已然覆灭的 诺克 修道院残党， \
	那曾是 Zybantian 帝国境内“十杰”最后一处重要据点。 \
	在腐败之灾的重压下，他们的修院生活与虔诚信念迅速崩塌，被迫从孤绝苦修的日子里跌入普通佣兵的生涯；而 Noc 的赐福，在斩杀怪物与人类时倒是意外地好用。 \
	无论出于何种缘由，你如今来到了这片地界，向出价最高者献上自己的技艺。知识即力量。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/tabaxi,
		/datum/species/anthromorph,
		/datum/species/demihuman,
		/datum/species/elf/wood,
		/datum/species/tieberian
	)
	outfit = /datum/outfit/job/roguetown/mercenary/newmoon
	cmode_music = 'sound/music/combat_desertrider.ogg'
	class_select_category = CLASS_CAT_ZYBANTU
	subclass_languages = list(/datum/language/celestial)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	subclass_spellpoints = 8//We'll focus on this being a combination spellblade.
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
	)

	extra_context = "该分支仅限：Tabaxi | Wild-Kin | Half-Kin | Elves | Tiefling。"

/datum/outfit/job/roguetown/mercenary/newmoon
	allowed_patrons = list(/datum/patron/divine/noc)

/datum/outfit/job/roguetown/mercenary/newmoon/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/sword/sabre/newmoon
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	armor = /obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/noc

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/spellbook_unfinished/pre_arcyne = 1,
		/obj/item/roguegem/amethyst = 1,
		/obj/item/lockpick = 1,
		)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summonweapon)//Singular user of this, outside of scrolls.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)

//Their sabre. Peel capable when off. Does burn when on. OldRW rage inducing classic, returned.
//Now properly inflicts burn wounds, on top of the burn type damage. Very painful.
/obj/item/rogueweapon/sword/sabre/newmoon
	name = "寒雾军刀"
	desc = "一柄缭绕着亮蓝色冻雾的纤薄军刀。仅仅握住这把刀，都让人觉得手指快要被冻伤。"
	icon = 'icons/roguetown/weapons/32.dmi'
	icon_state = "nm_saber"
	force = 22//Dropped to 14 when on. Fire damage is a hell of a thing. -8, overall.
	max_integrity = 200//+50
	max_blade_int = 150//-50
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/strike)
	damtype = BRUTE
	light_color = LIGHT_COLOR_BLUE
	var/on = FALSE

/datum/intent/sword/freeze
	name = "冰封"
	icon_state = "insmoke"//Is it funny yet? Get it?
	attack_verb = list("冰封")
	animname = "chop"
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg')
	penfactor = 60
	swingdelay = 8//+2
//	damfactor = 1.2//Not with new wounds!!!!
	blade_class = BCLASS_BURN

/obj/item/rogueweapon/sword/sabre/newmoon/update_icon()
	if(on)
		icon_state = "nm_saber_freeze"
	else
		icon_state = "nm_saber"

/obj/item/rogueweapon/sword/sabre/newmoon/attack_self(mob/user)
	if(on)
		on = FALSE
		damtype = BRUTE
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/strike)
		force = 22
	else
		user.visible_message(span_warning("[user] 的刀刃亮起了幽蓝寒焰。"))
		on = TRUE
		damtype = BURN
		possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/freeze, /datum/intent/sword/strike)
		force = 14//Remember, BURN DAMAGE.
	playsound(user, pick('sound/magic/magic_nulled.ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()

//The clothing.
/obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	name = "新月 外袍"
	desc = "这件青绿色外袍轻便、华丽，却仍有相当的防护性。它是 新月 圣团的标志装束，胸前中央还缀着一枚 诺克 护符。"
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	armor = ARMOR_SPELLSINGER//Better than the old, but, whatever. By a bit.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/head/roguetown/roguehood/reinforced/newmoon
	color = "#78a3c9"

/obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	color = "#78a3c9"
