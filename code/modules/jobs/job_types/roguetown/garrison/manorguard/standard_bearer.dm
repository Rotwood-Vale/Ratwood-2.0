//Carries the ducal standard.
//When carrying it, he's granted a few unique traits.
//Bonuses, relaying location, etc.
//The stats are middling, as a result. Really bad, honestly.
//No armour trait, but gets crit resist. STAY STANDING!!!
/datum/advclass/manorguard/standard_bearer
	name = "军旗手"
	tutorial = "你是军士长的副手，出征时由你擎举城堡的军旗。\
	只要你能将旗帜安然护住，战友们便知道该向你集结。"
	outfit = /datum/outfit/job/roguetown/manorguard/standard_bearer
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_STANDARD_BEARER)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,//You're on a budget here, buddy! Stab sure, stab often!
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,//SWING THAT THING.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,//OR THOSE ARMS, I GUESS.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 1//Haha... no... unless...?

/datum/outfit/job/roguetown/manorguard/standard_bearer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	pants = /obj/item/clothing/under/roguetown/splintlegs
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/mace/cudgel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("长枪","长柄斧")
		var/weapon_choice = input(H, "选择你的武器。", "拿起武器") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("长枪")
				r_hand = /obj/item/rogueweapon/spear/keep_standard
			if("长柄斧")
				r_hand = /obj/item/rogueweapon/spear/keep_standard/poleaxe

//These are really hacky, but it works.
//One proc to moodbuff.
/mob/proc/standard_position()
	set name = "立旗"
	set category = "军旗"
	emote("standard_position", intentional = TRUE)
	stamina_add(rand(15,35))

/datum/emote/living/standard_position
	key = "standard_position"
	message = "把军旗立了起来！"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

/datum/emote/living/standard_position/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//SCORE SOME GOALS!!!
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in viewers(7,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					to_chat(L, span_monkeyhive("军旗正在呼唤我！"))
					L.add_stress(/datum/stressevent/keep_standard_lesser)

//Another to call out.
/mob/proc/standard_rally()
	set name = "集结"
	set category = "军旗"
	emote("standard_rally", intentional = TRUE)
	stamina_add(rand(15,35))

/datum/emote/living/standard_rally
	key = "standard_rally"
	message = "把军旗高高立起！"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

//This is also SUPER hacky and GROSS.
//It makes use of loud message, effectively, just gutted.
/datum/emote/living/standard_rally/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//COME ON!!!
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in orange(75,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					var/strz
					var/strdir
					if(L.z != user.z)
						var/zdiff = abs(L.z - user.z)
						if(L.z > user.z)
							switch(zdiff)
								if(1)
									strz = "下方"
								if(2 to 999)
									strz = "更下方"
						if(L.z < user.z)
							switch(zdiff)
								if(1)
									strz = "上方"
								if(2 to 999)
									strz = "更上方"
					var/dir = get_dir(L, user)
					strdir = dir2text(dir)
					var/fullmsg = span_warning("军旗发出尖啸，从[strz ? "<b>[strz]</b>" : ""][strdir ? "[strz ? "与" : ""]<b>[strdir]</b>" : ""]牵动着我的心神。")
					to_chat(L, fullmsg)

//Another, to give energy and a very poor heal to nearby retinue.
//This looks strong, but it's mostly fluff. Very weak heal. Decent energy return.
//Better results just drinking red and blue, but makes the standard bearer a solid addition to the squad.
//Well, beyond their weapon and such, I suppose, at least...
/mob/proc/standard_recuperate()
	set name = "整队"
	set category = "军旗"
	emote("standard_recuperate", intentional = TRUE)
	stamina_add(rand(15,35))
	energy_add(-200)//Law of exchange, or something.

/datum/emote/living/standard_recuperate
	key = "standard_recuperate"
	message = "把军旗稳稳立定！"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

/datum/emote/living/standard_recuperate/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//RELAX, LADS!!
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in viewers(7,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					to_chat(L, span_monkeyhive("军旗抚平了我疲惫的心神。我感觉恢复了些精神。"))
					L.apply_status_effect(/datum/status_effect/buff/healing, 0.2)//As much as a bard's lowest strength healing song. Poor. Very poor.
					if(L.energy < L.max_energy)
						L.energy_add(100)//Consider that the average player's is going to be 1k+. Enough to facilitate sprinting away from fighting, at 0.

//Steady ahead, lads.
//This gives light step and luck. Why? Mire walking, if needed. At the cost of your energy.
/mob/proc/standard_steady()
	set name = "稳进"
	set category = "军旗"
	emote("standard_steady", intentional = TRUE)
	stamina_add(rand(15,35))
	energy_add(-300)//Ooough... help me!!!!

/datum/emote/living/standard_steady
	key = "standard_steady"
	message = "把军旗稳稳立起！"
	emote_type = EMOTE_VISIBLE
	show_runechat = TRUE

/datum/emote/living/standard_steady/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 8 SECONDS))//You really should just slow down. Take in the sights.
		playsound(user.loc, 'sound/combat/shieldraise.ogg', 100, FALSE, -1)
		if(.)
			for(var/mob/living/carbon/human/L in viewers(7,user))
				if(HAS_TRAIT(L, TRAIT_GUARDSMAN))
					to_chat(L, span_monkeyhive("军旗指引我们步伐稳准而轻巧，不易触发陷阱与机关。"))
					L.apply_status_effect(/datum/status_effect/buff/standard_steady)

/atom/movable/screen/alert/status_effect/buff/standard_steady
	name = "稳进"
	desc = "军旗正引导着我的步伐。我能更稳地落脚，行走时也比平常轻快许多……"
	icon_state = "buff"

/datum/status_effect/buff/standard_steady
	id = "standard_steady"
	alert_type = /atom/movable/screen/alert/status_effect/buff/standard_steady
	effectedstats = list(STATKEY_LCK = 1)
	duration = 2 MINUTES

/datum/status_effect/buff/standard_steady/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, id)

/datum/status_effect/buff/standard_steady/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, id)
