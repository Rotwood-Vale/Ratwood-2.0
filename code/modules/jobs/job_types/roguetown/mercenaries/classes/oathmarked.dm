//Drakians, marked by their oath to serving nobility.
//They've incredibly restrictive RP requirements. Such as not being able to be hired by peasantry.
//In fact, they're xenophobic. They shouldn't be liked, but not to the same degree that Black Oak is hated.
//...
//Two classes. Sentinel. Executor.
//Sentinel sits as a polearm wielding ward.
//Executor sits as the two-handed 'fuck off' sword guy.
//Both play into their species' inherent strength bonus.
//...
//The Oathmarked are an ancient order of drakian, dedicated to serving nobility and eradicating that which would destroy the natural order of Astrata's tyranny.
//These guys are in need of actual sprites, too, aside from that. Otherwise, they're probably fine. I guess.
/datum/advclass/mercenary/oathmarked
	name = "Oathmarked Sentinel"
	tutorial = "You're a sentinel of the Oathmarked. Trained in use of your order's unique polearms and plate wearing."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dracon
	)
//	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD)//For later, maybe. But they're like lobsters.
	outfit = /datum/outfit/job/roguetown/mercenary/oathmarked
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_XENOPHOBIC, TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_SCALEARMOR)
	subclass_social_rank = SOCIAL_RANK_MINOR_NOBLE
	cmode_music = 'sound/music/cmode/nobility/combat_courtmage.ogg'
	subclass_stats = list(//8 stat spread. Very strong. +1CON/WILL from their ring.
		STATKEY_STR = 3,//16STR, with a statpack. Wildly strong. 14STR otherwise, at softcap.
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -3//Very, very slow. Is this a horrible idea? Yeah. But it'll be funny.
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,//Imperial is not your mother tongue.
	)
	extra_context = "This subclass is limited to: Drakian"// | Middle-Aged & Old"
	subclass_stashed_items = list(//They come prepared. We really should just give this to all mercs.
		"Writ of Service" = /obj/item/merctoken
	)

/datum/outfit/job/roguetown/mercenary/oathmarked/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/eaglebeak/oathmarked//Very, very strong. IT HAS PICK. Swap to a glaive if you'd rather.
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltl = /obj/item/flashlight/flare/torch/lantern
	head = /obj/item/clothing/head/roguetown/helmet/heavy/oathmarked
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/oathmarked
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	gloves = /obj/item/clothing/gloves/roguetown/plate/oathmarked
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	cloak = /obj/item/clothing/cloak/cape/oathmarked
	pants = /obj/item/clothing/under/roguetown/platelegs/oathmarked
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/oathmarked
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver/astrata/oathmarked
	id = /obj/item/clothing/ring/oathmarked
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/book/rogue/secret/oathmarked = 1,
		)
	H.merctype = 16
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/advclass/mercenary/oathmarked/executor
	name = "Oathmarked Executor"
	tutorial = "You're an executor of the Oathmarked. Trained in use of your order's unique swords and plate wearing."
	outfit = /datum/outfit/job/roguetown/mercenary/oathmarked/executor
	subclass_stats = list(//8 stat spread. Very strong. +1CON/WILL from their ring.
		STATKEY_STR = 2,//15STR, with a statpack. 13STR otherwise.
		STATKEY_PER = 3,
		STATKEY_INT = 3,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,//Imperial is not your mother tongue.
	)

/datum/outfit/job/roguetown/mercenary/oathmarked/executor/pre_equip(mob/living/carbon/human/H)
	..()
	r_hand = /obj/item/rogueweapon/greatsword/grenz/oathmarked//A greatsword with peel. Bridges the gap between an estoc and standard zwei.

//Oathmarked's equipment.
/obj/item/rogueweapon/eaglebeak/oathmarked
	force = 12//Two-hand this.
	force_wielded = 32
	gripped_intents = list(/datum/intent/spear/thrust/eaglebeak, /datum/intent/spear/bash/eaglebeak,
	/datum/intent/mace/smash/eaglebeak, /datum/intent/mace/warhammer/pick/ranged)
	name = "oathmarked's polehammer"
	desc = "A reinforced pole affixed with a head of steel. On the opposite side, a pick, intended to punch through plate. \
	Above? A thrusting head. A weapon to kill more noble foes, evidently."
	icon_state = "polehammerb"//Temp. A reuse, but unused elsewhere.
	minstr = 12//+1
	minstr_req = TRUE//You MUST have the required strength. No exceptions.
	max_blade_int = 200
	sellprice = 120

/obj/item/rogueweapon/eaglebeak/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>An oathmarked's polehammer. Designed in an earlier era, under the direction of Hadrûnzhar. \
		A lord lost to centuries. The original keeper of the oath. The purpose was simple: <br>\
		A hammer to break the rabble. A pick to slay the traitors. A head to pierce both.</small>"

/datum/intent/mace/warhammer/pick/ranged
	penfactor = 40//-40% less.
	damfactor = 0.8//-10% less.
	reach = 2
	clickcd = CLICK_CD_HEAVY

/obj/item/rogueweapon/greatsword/grenz/oathmarked
	name = "oathmarked's flamberge"
	desc = "An incredibly well balanced blade, designed for a rather large frame. Heavy beyond any reasonable measure. \
	The work of a master smith, or one with far too much time to spare. The blade of a noble, surely."
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/zwei, /datum/intent/sword/peel/big, /datum/intent/sword/strike/bad)
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "oathflamberge"//Temp.
	max_blade_int = 220
	max_integrity = 200
	wdefense = 6
	minstr = 11//+2
	minstr_req = TRUE//You MUST have the required strength. No exceptions.

/obj/item/rogueweapon/greatsword/grenz/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>An oathmarked's flamberge. Designed in an earlier era, under the direction of Hadrûnzhar. \
		A lord lost to centuries. The original keeper of the oath. The purpose was simple: <br>\
		A blade fit for a king, to bear the oath's violence in place of the lordling's hand.</small>"

//Armour
/obj/item/clothing/gloves/roguetown/plate/oathmarked
	name = "oathmarked gauntlets"
	desc = "Plate gauntlets made out of blackened steel."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplategloves"//Temp.
	item_state = "bplategloves"
	max_integrity = ARMOR_INT_SIDE_IRON + 50//275. 25 less than standard steel.

/obj/item/clothing/suit/roguetown/armor/plate/full/oathmarked
	name = "oathmarked armor"
	desc = "Weathered, blackened steel plate armor. Fit for a noble. Weaker as a result of the smithing process, though no less protective."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplate"//Temp.
	item_state = "bplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON + 50//425. 75 less than standard steel plate.

/obj/item/clothing/under/roguetown/platelegs/oathmarked
	name = "oathmarked chausses"
	desc = "Reinforced armor to protect the legs, fashioned out of blackened steel plate."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplatelegs"//Temp.
	item_state = "bplatelegs"
	max_integrity = ARMOR_INT_LEG_IRON_PLATE + 50//350. 50 less than standard steel chausses.

/obj/item/clothing/shoes/roguetown/boots/armor/oathmarked
	name = "oathmarked boots"
	desc = "Boots forged of a set of blackened steel plates to protect your fragile toes."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplateboots"//Temp.
	item_state = "bplateboots"

/obj/item/clothing/head/roguetown/helmet/heavy/oathmarked
	name = "oathmarked helmet"
	desc = "An ancient helm, similar in design to a modern blacksteel armet. Albeit without the visor. Expensive looking, but certainly not blacksteel..."
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplatehelm_nv"//Temp.
	item_state = "bplatehelm_nv"
	block2add = FOV_BEHIND
	body_parts_covered = HEAD|HAIR|EARS
	flags_inv = HIDEEARS|HIDEHAIR
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON + 50//350. 50 less than a standard steel helm.
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/neck/roguetown/psicross/silver/astrata/oathmarked
	name = "oathmarked amulet of Astrata"
	desc = "An amulet of the Tyrant. Whether or not the bearer believes in the creed, the Oathmarked serve in Her name all the same. \
	This specific amulet bears the blessing of silver."

/obj/item/clothing/neck/roguetown/psicross/silver/astrata/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>Hadrûnzhar, the best of his house. A drakian that stood above the squabbles of inter-drakian conflict. \
		He'd given his Oathmarked a singular purpose: <br>\
		To destroy all that would harm Astrata's noble order. To eradicate the taint of left-handed magyks from the world.</small>"

/obj/item/clothing/cloak/cape/oathmarked
	name = "oathmarked cape"
	desc = "A cape fit for an enormous frame."
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/cloak/cape/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>Hadrûnzhar was known for his showboating and sudden violent outbursts. \
		Once meant to be a symbol of mockery, for resentful Oathmarked, this cape now represents something greater. \
		Hope. Hope that one dae he may return. \
		For just as he'd vanished into Eressioth's demesne, all drakian, knowing or otherwise, pray for his return.</small>"

//The RP tome.
/obj/item/book/rogue/secret/oathmarked
	name = "Oathmarked Tome"
	desc = "An odd tome. The verbage hurts to look at, while the pages sit covered in dust."
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	bookfile = "oathmarked.json"

/obj/item/book/rogue/secret/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>Ancient, written by Hadrûnzhar's closest after he'd vanished. \
		It sets out the guidelines that all Oathmarked are doomed to follow. \
		Just as Hadrûnzhar had in another era, before he'd slipped out of the knowing world.</small>"
