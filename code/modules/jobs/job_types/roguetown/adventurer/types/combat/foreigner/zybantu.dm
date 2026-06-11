//Nomad is a combination subclass.
//They choose between shield + spear, or miraclist flagellant. Flagellant stuff isn't done, but, whatever...
/datum/advclass/foreigner/dunewell
	name = "沙泉 游民"
	tutorial = "坐落于 兹班图的 沙海深处的 沙泉，是一片疯狂之地，也是信仰与异端并存的疆域。\
	多年以来，无数人为了那座古老 Psydonian 据点遗下的财富与废墟厮杀不休；从那里走出的人，大多也是那场轮回的一部分。\
	传教者与杀手，不过一体两面。你既然远行至 Ferentia，要么是想逃离这场轮回，要么就是准备再度投身其中。"
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/dnomad
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/horror.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(//Stats handled by loadout, beyond these two.
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(//Other skills handled by loadout.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"《Psydon 圣典》" = /obj/item/book/rogue/bibble/psy,
		"故土遗物" = /obj/item/clothing/neck/roguetown/psicross,
	)
	extra_context = "此子职业仅限 普赛顿ites 与 异民，玩法分为两条路线。\
	你可以选择武斗配装，获得：+2 感知 / +1 力量、熟练长矛、大师盾术。\
	也可以舍弃纯武斗，获得：+2 感知 / +1 速度、熟练神圣、大师长柄武器、T2 神迹。"

//This is gross, but it works. Better than a new define.
/datum/outfit/job/roguetown/adventurer/dnomad
	allowed_patrons = list(/datum/patron/inhumen/baotha, /datum/patron/inhumen/graggar,
	/datum/patron/inhumen/zizo, /datum/patron/inhumen/matthios, /datum/patron/old_god)

/datum/outfit/job/roguetown/adventurer/dnomad/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/mask/rogue/ragmask/nomad
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/nomad
	wrists = /obj/item/clothing/wrists/roguetown/splintarms/iron
	neck = /obj/item/clothing/neck/roguetown/coif/padded/nomad
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/splintlegs/iron
	gloves = /obj/item/clothing/gloves/roguetown/bandages
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/nomad
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/nomad
	cloak = /obj/item/clothing/cloak/cape/nomad
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/reagent_containers/glass/bottle/waterskin
	backpack_contents = list(/obj/item/rogueweapon/huntingknife = 1,
							/obj/item/rogueweapon/scabbard/sheath = 1)

	if(H.mind)
		var/nomad_purpose = list("逃离轮回 | 盾与矛","延续轮回 | 神迹行者")
		var/purpose_choice = input(H, "选择你的道路。", "你为何流浪") as anything in nomad_purpose
		switch(purpose_choice)
			if("逃离轮回 | 盾与矛")
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_STR, 1)//Total of 6 stats, as 1 STR/SPD counts for 2.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)//Only adventurer, as of adding, to have expert shields. Wild.
				r_hand = /obj/item/rogueweapon/spear/nomad
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				backr = /obj/item/rogueweapon/shield/iron/nomad
			if("延续轮回 | 神迹行者")
				var/datum/devotion/C = new /datum/devotion(H, H.patron)
				C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
				H.change_stat(STATKEY_PER, 2)
				H.change_stat(STATKEY_SPD, 1)//As above, 6 stats total.
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, 3, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				backl = /obj/item/storage/backpack/rogue/satchel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				if(H.patron?.type == /datum/patron/inhumen/zizo)
					H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
					H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)

//Just the nomad clothes.
/obj/item/clothing/cloak/cape/nomad
	color = CLOTHING_DARKDRAB

/obj/item/clothing/neck/roguetown/coif/padded/nomad
	color = CLOTHING_DARKDRAB

/obj/item/clothing/suit/roguetown/shirt/undershirt/nomad
	color = CLOTHING_DARKDRAB

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/nomad
	name = "游民披巾"
	desc = "厚实而护身，却依旧轻便透气。是 兹班图 游民的标志性衣装，带着鲜明的 沙泉 风味……"
	color = CLOTHING_DARKDRAB

/obj/item/clothing/head/roguetown/roguehood/shalal/nomad
	color = CLOTHING_DARKDRAB

/obj/item/clothing/mask/rogue/ragmask/nomad
	color = CLOTHING_DARKDRAB
