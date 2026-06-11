//Healer-bards. Boring, but it exists.
//Not intended for proper combat.
//Knives exist the same way it does on Arbalist, as a 'just in case'.
/datum/advclass/psyaltrist
	name = "圣咏师"
	tutorial = "你曾在大教堂唱诗班与 psyaltrist 们身边修习一段时日。如今，你日复一日地把音乐之艺用于实务，为至圣审判庭效力。"
	outfit = /datum/outfit/job/roguetown/psyaltrist
	subclass_social_rank = SOCIAL_RANK_PEASANT
	traits_applied = list(TRAIT_EMPATH, TRAIT_DODGEEXPERT)
	category_tags = list(CTAG_INQUISITION)
	subclass_languages = list(/datum/language/otavan)
	subclass_stats = list(//This does not follow the typical 8 stat setup.
		STATKEY_STR = 1,
		STATKEY_LCK = 1,
		STATKEY_WIL = 1,
		STATKEY_CON = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/psyaltrist/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/leather/chapeau
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	neck = /obj/item/clothing/neck/roguetown/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/signet/silver
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1,
	/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger = 1,
	/obj/item/rogueweapon/scabbard/sheath = 1)

	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_inspire)//CtA, but blood cost and... kind of worse.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/psydonic_sacrosanctity)//To get your blood back, m'lord.
		var/instruments = list("手风琴","风笛", "班卓琴","鼓","长笛","吉他","口琴","竖琴","手摇风琴","口簧琴","鲁特琴","圣咏琴","三味线","小号","中提琴","歌咏护符")
		var/instrument_choice = tgui_input_list(H, "选择你的乐器。", "拿起家伙", instruments)
		H.set_blindness(0)
		switch(instrument_choice)
			if("手风琴")
				backr = /obj/item/rogue/instrument/accord
			if("风笛")
				backr = /obj/item/rogue/instrument/bagpipe
			if("班卓琴")
				backr = /obj/item/rogue/instrument/banjo
			if("鼓")
				backr = /obj/item/rogue/instrument/drum
			if("长笛")
				backr = /obj/item/rogue/instrument/flute
			if("吉他")
				backr = /obj/item/rogue/instrument/guitar
			if("口琴")
				backr = /obj/item/rogue/instrument/harmonica
			if("竖琴")
				backr = /obj/item/rogue/instrument/harp
			if("手摇风琴")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("口簧琴")
				backr = /obj/item/rogue/instrument/jawharp
			if("鲁特琴")
				backr = /obj/item/rogue/instrument/lute
			if("圣咏琴")
				backr = /obj/item/rogue/instrument/psyaltery
			if("三味线")
				backr = /obj/item/rogue/instrument/shamisen
			if("小号")
				backr = /obj/item/rogue/instrument/trumpet
			if("中提琴")
				backr = /obj/item/rogue/instrument/viola
			if("歌咏护符")
				backr = /obj/item/rogue/instrument/vocals
		var/weapons = list("Psydonic 长鞭", "Psydonic 刺剑")
		var/weapon_choice = tgui_input_list(H, "选择你的武器。", "执起 Psydon 兵刃", weapons)
		switch(weapon_choice)
			if("Psydonic 长鞭")
				H.put_in_hands(new /obj/item/rogueweapon/whip/psywhip_lesser(get_turf(H)), forced = TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
			if("Psydonic 刺剑")
				H.put_in_hands(new /obj/item/rogueweapon/sword/rapier/psy(get_turf(H)), forced = TRUE)
				H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)

/datum/outfit/job/roguetown/psyaltrist
	job_bitflag = BITFLAG_HOLY_WARRIOR
