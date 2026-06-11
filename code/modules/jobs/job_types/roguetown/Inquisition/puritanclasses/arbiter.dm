//The Arbiter. It leans entirely into the martial miracle setup.
//They get the full set, as a pseudo-flagellant.
//Think of it like the radical, obsessive faith guy. Old puritan.
//Middling skills. Half-half stats. A niche. Outside of their miracles.
/datum/advclass/puritan/arbiter
	name = "裁决官"
	tutorial = "不同于 Ordinator 或 Inspector，Arbiter 所承担的是截然不同的职责。 \
	你出身于战斗祭司之列，至今仍在被腐败侵蚀的土地上作战，对那份腐朽之触有着异乎寻常的感应。 \
	借助稀有而危险的大能神迹，你能嗅出污秽，再把异端一个接一个送上火刑架。"
	outfit = /datum/outfit/job/roguetown/puritan/arbiter
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_PURITAN)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_MEDIUMARMOR,
		TRAIT_SILVER_BLESSED,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_INQUISITION,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER
		)//-1 stats over Ordinator/Inspector, if counting STR/SPD as 2 each. +1 over in a respective area when selecting their sect.
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/puritan/arbiter/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim
	cloak = /obj/item/clothing/cloak/cape/inquisitor
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/arbiter
	belt = /obj/item/storage/belt/rogue/leather/arbiter
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/arbiter
	backr =  /obj/item/storage/backpack/rogue/satchel/otavan
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltl = /obj/item/quiver/bolts
	mask = /obj/item/clothing/mask/rogue/sack/psy/arbiter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	id = /obj/item/clothing/ring/signet/silver
	backpack_contents = list(
		/obj/item/storage/keyring/puritan = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/paper/inqslip/arrival/inq = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_3) //Capped to T1 miracles.
	if(H.mind)//The entire spread of greater miracles, barring the lux bolt. For obvious reasons.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_retribution)//Rebuke, but blood cost and worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inspire)//CtA, but blood cost and... kind of worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inviolability)//A shield against the undead.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.

/datum/outfit/job/roguetown/puritan/arbiter/choose_loadout(mob/living/carbon/human/H)
	. = ..()//Just as with the stats, this has a mixture of weapon choice between Ordinators and Inspectors. A less-used weapon list.
	var/weapons = list("Psydonic 阔剑", "Daybreak（鞭）", "Stigmata（长戟）", "Consecratia（连枷）")
	var/weapon_choice = input(H,"寻得你的真理。", "以祂之名执兵。") as anything in weapons
	switch(weapon_choice)
		if("Psydonic 阔剑")
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/psy/preblessed(H), TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Daybreak（鞭）")
			H.put_in_hands(new /obj/item/rogueweapon/whip/antique/psywhip(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Stigmata（长戟）")
			H.put_in_hands(new /obj/item/rogueweapon/halberd/psyhalberd/relic(H), TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/gwstrap(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Consecratia（连枷）")
			H.put_in_hands(new /obj/item/rogueweapon/flail/sflail/psyflail/relic(H), TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
	//Now, for their 'sect'. They can either choose a heavy gambeson and +1SPD, or inquisitor coat and +1STR.
	var/sect = list("古派 - Gilbranze、棉甲与速度", "新派 - 白银、外袍与力量")
	var/sect_choice = input(H,"择定你的教派。", "我们是谁？") as anything in sect
	switch(sect_choice)
		if("古派 - Gilbranze、棉甲与速度")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/arbiter, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/arbiter, SLOT_ARMOR, TRUE)
			H.change_stat(STATKEY_SPD, 1)//We'll probably drop this.
		if("新派 - 白银、外袍与力量")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/arbiter/vice, SLOT_HEAD, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter/vice, SLOT_GLOVES, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/arbiter, SLOT_ARMOR, TRUE)
			H.change_stat(STATKEY_STR, 1)//As above. But for now we'll see if it's ok.

/*
Below are the Arbiter's funny things.
Reused from OldRW. But cool. Soulful, even.
Here because they're unused elsewhere.
*/
/obj/item/storage/belt/rogue/leather/arbiter
	name = "织带腰具"
	desc = "一条皮带，搭配若干 奥塔万 风格的织带与小袋。<br>\
	这种样式由早年某位 Arbiter 首创，历经一两百年后，仍被那些有相同需求的人沿用至今。"
	icon_state = "overseerbelt"
	item_state = "overseerbelt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	w_class = WEIGHT_CLASS_BULKY
	dropshrink = null

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq/arbiter
	name = "裁决官棉甲"
	desc = "一件厚实的衬垫棉甲，足以抵御那些赤手空拳的“无辜者”。\
	它散发着火药与硫磺的刺鼻气味，那正是圣化仪式里常见的味道。"
	icon_state = "overseerjacket"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat/arbiter
	name = "裁决官布面甲"
	desc = "一件厚重而加固的布面甲外袍，外覆得体的酒红色织料，内衬银质甲片。\
	没人会对它无动于衷，因为迟早，他们都会认得它。"
	icon_state = "viceseercoat"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	boobed = TRUE
	is_silver = TRUE
	dropshrink = null

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter
	name = "裁决官手套"
	desc = "厚实沉重的皮革手套，上头缀着醒目的亮色饰带。"
	icon_state = "overseergloves"
	item_state = "overseergloves"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

/obj/item/clothing/gloves/roguetown/otavan/psygloves/arbiter/vice
	icon_state = "viceseergloves"
	item_state = "viceseergloves"
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/arbiter
	name = "裁决官面具"
	desc = "一副标志性的吉尔青铜面具，描绘着祂的面容，正如祂一般悲泣不止。"
	icon_state = "overseermask"
	item_state = "overseermask"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	flags_inv = HIDEFACE
	body_parts_covered = FACE|HEAD|HAIR|EARS|NOSE
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	sewrepair = TRUE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/aaslag
	var/active_item = FALSE
	dropshrink = null

/obj/item/clothing/head/roguetown/helmet/arbiter/vice
	desc = "一副极具辨识度的银面具，描绘着祂的面容，正如祂自己那般垂泪。"
	icon_state = "viceseermask"
	item_state = "viceseermask"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	dropshrink = null

//The intent of the trait was to frighten heretics, if they saw the user with it present.
//Alas...
/obj/item/clothing/head/roguetown/helmet/arbiter/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		active_item = TRUE
//		ADD_TRAIT(user, TRAIT_ARBITER, TRAIT_GENERIC)
		to_chat(user, span_red("当这副面具覆上你的脸，一切迟疑的审判都会被豁免。除了异端，又有谁敢质疑你的意志？"))
	return

/obj/item/clothing/head/roguetown/helmet/arbiter/dropped(mob/living/user)
	..()
	if(!active_item)
		return
	active_item = FALSE
//	REMOVE_TRAIT(user, TRAIT_ARBITER, TRAIT_GENERIC)
	to_chat(user, span_red("仿佛骤然清醒过来一般，你开始意识到，自己的举止或许还是该稳当些……"))

/obj/item/clothing/mask/rogue/sack/psy/arbiter
	name = "裁决官兜帽"
	desc = "若还有别的路可走，你本不会遮住自己的脸。你这么做并非毫无缘由。\
	可他们真的会懂吗？当真会吗？"
	icon_state = "overseerhood"
	item_state = "overseerhood"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS
	body_parts_covered = FACE|EARS|MOUTH|NECK
	slot_flags = ITEM_SLOT_MASK
	sewrepair = TRUE
	dropshrink = null

/obj/item/clothing/under/roguetown/heavy_leather_pants/arbiter
	name = "厚长裤"
	desc = "一条厚实、颜色洗得发灰的长裤。"
	icon_state = "overseerpants"
	item_state = "overseerpants"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	dropshrink = null

/obj/item/clothing/suit/roguetown/shirt/undershirt/arbiter
	icon_state = "overseershirt"
	icon = 'icons/roguetown/clothing/special/overseer/overseer.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	sleeved = 'icons/roguetown/clothing/special/overseer/onmob/overseer.dmi'
	color = null
	dropshrink = null
