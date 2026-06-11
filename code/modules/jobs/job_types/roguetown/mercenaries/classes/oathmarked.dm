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
	name = "誓印哨卫"
	tutorial = "你是誓印者中的哨卫，受训使用你们教团独有的长柄兵器，并习惯披挂板甲作战。"
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
	extra_context = "该分支仅限：Drakian"// | Middle-Aged & Old"
	subclass_stashed_items = list(//They come prepared. We really should just give this to all mercs.
		"服役文书" = /obj/item/merctoken
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
	name = "誓印行刑者"
	tutorial = "你是誓印者中的行刑者，受训使用你们教团独有的大剑，并习惯披挂板甲作战。"
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
	name = "誓印长杆战锤"
	desc = "一根加固长杆，前端装着钢制锤头，背面则是专为凿穿板甲而设的尖镐。 \
	上方还伸出一枚突刺头。显然，这是一件专为诛杀更高贵敌手而生的武器。"
	icon_state = "polehammerb"//Temp. A reuse, but unused elsewhere.
	minstr = 12//+1
	minstr_req = TRUE//You MUST have the required strength. No exceptions.
	max_blade_int = 200
	sellprice = 120

/obj/item/rogueweapon/eaglebeak/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>这是一柄誓印者的长杆战锤，诞生于更久远的年代，由 Hadrûnzhar 主导设计。\
		那是一位湮没于数百年时光中的领主，也是最初的誓约守护者。它的用途很简单：<br>\
		用锤击碎乌合之众，用镐诛杀叛徒，用枪尖一并贯穿两者。</small>"

/datum/intent/mace/warhammer/pick/ranged
	penfactor = 40//-40% less.
	damfactor = 0.8//-10% less.
	reach = 2
	clickcd = CLICK_CD_HEAVY

/obj/item/rogueweapon/greatsword/grenz/oathmarked
	name = "誓印焰纹巨剑"
	desc = "一柄平衡得惊人的巨刃，按极为高大的身形打造，沉重得近乎超出常理。 \
	这要么出自名匠之手，要么出自一个闲得过分的人。无论如何，这必是贵胄之刃。"
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
		. += "<small>这是一柄誓印者的焰纹巨剑，诞生于更久远的年代，由 Hadrûnzhar 主导设计。\
		那是一位湮没于数百年时光中的领主，也是最初的誓约守护者。它的用途很简单：<br>\
		这是一柄配得上王者的利刃，代替那位贵胄之手承载誓约的暴烈。</small>"

//Armour
/obj/item/clothing/gloves/roguetown/plate/oathmarked
	name = "誓印臂铠"
	desc = "以熏黑钢板锻成的一对板甲臂铠。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplategloves"//Temp.
	item_state = "bplategloves"
	max_integrity = ARMOR_INT_SIDE_IRON + 50//275. 25 less than standard steel.

/obj/item/clothing/suit/roguetown/armor/plate/full/oathmarked
	name = "誓印板甲"
	desc = "一套历经风霜的熏黑钢板甲，样式足以配得上贵胄。虽因锻造工艺而稍显脆弱，却依旧提供不俗防护。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplate"//Temp.
	item_state = "bplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON + 50//425. 75 less than standard steel plate.

/obj/item/clothing/under/roguetown/platelegs/oathmarked
	name = "誓印腿甲"
	desc = "一副用于保护双腿的加固护甲，以熏黑钢板打造而成。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplatelegs"//Temp.
	item_state = "bplatelegs"
	max_integrity = ARMOR_INT_LEG_IRON_PLATE + 50//350. 50 less than standard steel chausses.

/obj/item/clothing/shoes/roguetown/boots/armor/oathmarked
	name = "誓印战靴"
	desc = "由成组熏黑钢板锻成的战靴，用来保护你脆弱的脚趾。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplateboots"//Temp.
	item_state = "bplateboots"

/obj/item/clothing/head/roguetown/helmet/heavy/oathmarked
	name = "誓印头盔"
	desc = "一顶古老头盔，外形近似现代黑钢阿米特盔，只是没有面甲。看上去价格不菲，但显然并不是真正的黑钢……"
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
	name = "阿斯特拉塔 誓印护符"
	desc = "一枚属于暴君的护符。无论佩戴者是否真心信奉其教义，誓印者终究仍以她之名侍奉。 \
	而这一枚护符还承载着白银的祝福。"

/obj/item/clothing/neck/roguetown/psicross/silver/astrata/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>Hadrûnzhar，他家族中最杰出的一位。作为一名 Drakian，他超然于诸多族内纷争之上。\
		他曾给予自己的誓印者唯一的使命：<br>\
		毁灭一切损害 Astrata 高贵秩序之物，将左手 magyks 的污秽自世间彻底根除。</small>"

/obj/item/clothing/cloak/cape/oathmarked
	name = "誓印披风"
	desc = "一件按巨大身形裁制的披风。"
	icon_state = "bkcape"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'

/obj/item/clothing/cloak/cape/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>Hadrûnzhar 以张扬作风与突如其来的暴烈脾性而闻名。\
		这件披风本是用来羞辱那些心怀怨恨的誓印者，如今却象征着更宏大的东西。\
		那便是希望，希望有朝一日他会归来。\
		正如他当年消失在 Eressioth 的领域之中那般，如今所有 Drakian，无论是否知情，都在祈祷他重返人世。</small>"

//The RP tome.
/obj/item/book/rogue/secret/oathmarked
	name = "誓印秘典"
	desc = "一本古怪的典籍。其措辞令人看着都觉得刺眼，书页上则覆满尘埃。"
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	bookfile = "oathmarked.json"

/obj/item/book/rogue/secret/oathmarked/examine(mob/user)
	. = ..()
	if(isdracon(user))
		. += "<small>这本古老秘典，是在 Hadrûnzhar 消失后由他最亲近之人所撰。\
		其中列明了所有誓印者都注定必须遵循的准则。\
		正如另一个时代里的 Hadrûnzhar 那样，在他从已知世界滑离而去之前。</small>"
