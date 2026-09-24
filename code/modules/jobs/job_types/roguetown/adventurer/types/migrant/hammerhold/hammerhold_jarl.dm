/datum/advclass/hammerhold/jarl
	name = "Hammerholdian Jarl"
	tutorial = "You are a warrior-lord from Hammerhold and the leader of your warband. Guide them to glory and wealth or try to survive."
	outfit = /datum/outfit/job/roguetown/hammerhold/jarl
	category_tags = list(CTAG_HAMMERHOLD_JARL)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_HAMMERHOLD_WARBAND)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, //weapon pick bumps whatever you take to expert
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER, //You are sea raiders.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //Basic self-sufficiency, especially if starting solo.
	)

	subclass_languages = list(
		/datum/language/hammerholdian,
	)

/datum/outfit/job/roguetown/hammerhold/jarl/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/darkcloak/bear
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/platelegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/gronn
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/flashlight/flare/torch/lantern
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1, //Some money as a treat. Hire an Atgervi.
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	//whatever meager pieces of blacksteel gear hammerhold has, I imagine it goes to their leaders
	var/weapons = list("Blacksteel Greataxe", "Great Mace", "Blacksteel Axe + Steel Shield", "Blacksteel Warhammer + Steel Shield")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Blacksteel Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/blacksteel
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel //no blacksteel grand mace exists
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Blacksteel Axe + Steel Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle/blacksteel
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		if("Blacksteel Warhammer + Steel Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer/blacksteel
			backr = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/greataxe/blacksteel
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/hammerhold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hammerhold/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hammerhold/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hammerhold/retreat)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordershammerhold)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/combat_fullplate.ogg'

	if(!H.has_language(/datum/language/hammerholdian))
		H.grant_language(/datum/language/hammerholdian)
		to_chat(H, span_info("I can speak Hammerholdian with ,h before my speech."))

// Spells + Orders (Orders are ONLY for the Hammerholdian Jarl)

/obj/effect/proc_holder/spell/self/convertrole/hammerhold
	name = "Swear to the Warband"
	new_role = "Warband Sworn"
	overlay_state = "recruit_brother"
	recruitment_faction = "Hammerholdian Warband"
	recruitment_message = "Swear yourself to the Warband, %RECRUIT!"
	accept_message = "I am sworn!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/hammerhold/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(HAS_TRAIT(recruit, TRAIT_HAMMERHOLD_WARBAND))
		to_chat(recruiter, span_warning("They're already sworn to us!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_GUARDSMAN))
		to_chat(recruiter, span_warning("They're already part of these lands's guard! They can't join the Warband!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_INQUISITION))
		to_chat(recruiter, span_warning("Their loyalty is to Psydon alone! They can't join the Warband!"))
		return FALSE
	if(recruit.job in list("Priest", "Priestess", "Templar", "Acolyte", "Martyr"))
		to_chat(recruiter, span_warning("Clergy cannot join the Warband! Their loyalty is to the Ten!"))
		return FALSE
	..()

/obj/effect/proc_holder/spell/invoked/order/hammerhold/proc/can_order(mob/living/target, mob/living/user)
	if(target == user)
		to_chat(user, span_alert("I cannot order myself!"))
		return 0
	if(HAS_TRAIT(target, TRAIT_HAMMERHOLD_WARBAND))
		return 1
	if(!(target.job in list("Warband Sworn", "Hammerholdian Jarl")))
		to_chat(user, span_alert("I cannot order one not of the Warband!"))
		return 0
	return 1

/obj/effect/proc_holder/spell/invoked/order/hammerhold
	name = "Warband Order"
	var/effect_to_apply
	var/message_varname

/obj/effect/proc_holder/spell/invoked/order/hammerhold/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	var/msg = user.mind.vars[message_varname]

	if(!msg)
		to_chat(user, span_alert("I must say something to give an order!"))
		return

	var/allowed = can_order(target, user)
	if(!allowed)
		return

	user.say("[msg]")
	target.apply_status_effect(effect_to_apply)
	on_success(user, target)
	return TRUE

/obj/effect/proc_holder/spell/invoked/order/hammerhold/proc/on_success(mob/living/user, mob/living/target)
	return

/***************************************************************
 *  INDIVIDUAL WARBAND ORDERS
 ***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/hammerhold/bolster
	name = "Hold the Shield Wall!"
	overlay_state = "bolster"
	effect_to_apply = /datum/status_effect/buff/order/hammerhold/bolster
	message_varname = "bolstertext"

/datum/status_effect/buff/order/hammerhold/bolster
	id = "hammerhold_bolster"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hammerhold/bolster
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 3)
	duration = 1 MINUTES

/datum/status_effect/buff/order/hammerhold/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("The Jarl orders the shield wall to hold!"))

/atom/movable/screen/alert/status_effect/buff/order/hammerhold/bolster
	name = "Hold the Shield Wall!"
	desc = "The Jarl inspires me to endure and hold my ground!"
	icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/hammerhold/charge
	name = "Charge!"
	overlay_state = "charge"
	effect_to_apply = /datum/status_effect/buff/order/hammerhold/charge
	message_varname = "chargetext"

/datum/status_effect/buff/order/hammerhold/charge
	id = "hammerhold_charge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hammerhold/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/datum/status_effect/buff/order/hammerhold/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("The Jarl calls the charge!"))

/atom/movable/screen/alert/status_effect/buff/order/hammerhold/charge
	name = "Charge!"
	desc = "The Jarl wills it - now is the time to break them!"
	icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/hammerhold/retreat
	name = "Fall Back!"
	overlay_state = "movemovemove"
	effect_to_apply = /datum/status_effect/buff/order/hammerhold/retreat
	message_varname = "retreattext"

/datum/status_effect/buff/order/hammerhold/retreat
	id = "hammerhold_retreat"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hammerhold/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 30 SECONDS

/datum/status_effect/buff/order/hammerhold/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("The Jarl orders me to fall back!"))

/atom/movable/screen/alert/status_effect/buff/order/hammerhold/retreat
	name = "Fall Back!"
	desc = "The Jarl orders me to fall back and regroup!"
	icon_state = "buff"

/***************************************************************
 *  ORDER SETUP PROC
 ***************************************************************/

/mob/living/carbon/human/mind/proc/setordershammerhold()
	set name = "Rehearse Orders"
	set category = "Voice of Command"

	#define ORDER_INPUT(varname, prompt) \
		mind.varname = input("Send a message.", prompt) as text|null; \
		if(!mind.varname) { to_chat(src, "I must rehearse something for this order..."); return }

	ORDER_INPUT(bolstertext, "Hold the wall!!")
	ORDER_INPUT(chargetext, "Break them!!")
	ORDER_INPUT(retreattext, "Fall back!!")

	#undef ORDER_INPUT
