/datum/advclass/gronn/chieftain
	name = "Gronnic Chieftain"
	tutorial = "You are the leader of your tribe. Guide them to glory or try to survive."
	outfit = /datum/outfit/job/roguetown/gronn/chieftain
	category_tags = list(CTAG_GRONN_CHIEFTAIN)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_STEELHEARTED, TRAIT_OUTLANDER, TRAIT_GRONN_HORDE)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 3,
		STATKEY_INT = -1,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, //weapon pick bumps whatever you take to expert
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

	subclass_languages = list(
		/datum/language/gronnic,
	)

/datum/outfit/job/roguetown/gronn/chieftain/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/nomadhelmet
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/gorget		//You're the big honcho, may as well
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)

	//the only steel in the tribe hangs off the chieftain
	var/weapons = list("Battle Axe + Recurve Bow", "Double-head Greataxe", "Glaive", "Steel Warhammer + Shield")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Battle Axe + Recurve Bow")
			beltr = /obj/item/rogueweapon/stoneaxe/battle
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			l_hand = /obj/item/quiver/arrows
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
		if("Double-head Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Glaive")
			r_hand = /obj/item/rogueweapon/halberd/glaive
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Steel Warhammer + Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			backr = /obj/item/rogueweapon/shield/iron/steppesman
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
		else //In case they DC or don't choose close the panel, etc
			beltr = /obj/item/rogueweapon/stoneaxe/battle
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			l_hand = /obj/item/quiver/arrows
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/gronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/gronn)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/gronn/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/gronn/retreat)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersgronn)

	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.dna.species.soundpack_f = new /datum/voicepack/female/warrior()

	H.cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	if(!H.has_language(/datum/language/gronnic))
		H.grant_language(/datum/language/gronnic)
		to_chat(H, span_info("I can speak Gronnic with ,n before my speech."))

// Spells + Orders (Orders are ONLY for the Gronnic Chieftain)

/obj/effect/proc_holder/spell/self/convertrole/gronn
	name = "Take into the Horde"
	new_role = "Horde Rider"
	overlay_state = "recruit_brother"
	recruitment_faction = "Gronnic Horde"
	recruitment_message = "Ride with the Horde, %RECRUIT!"
	accept_message = "I ride with the Horde!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/gronn/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(HAS_TRAIT(recruit, TRAIT_GRONN_HORDE))
		to_chat(recruiter, span_warning("They already ride with us!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_GUARDSMAN))
		to_chat(recruiter, span_warning("They're already part of these lands's guard! They can't join the Horde!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_INQUISITION))
		to_chat(recruiter, span_warning("Their loyalty is to Psydon alone! They can't join the Horde!"))
		return FALSE
	if(recruit.job in list("Priest", "Priestess", "Templar", "Acolyte", "Martyr"))
		to_chat(recruiter, span_warning("Clergy cannot join the Horde! Their loyalty is to the Ten!"))
		return FALSE
	..()

/obj/effect/proc_holder/spell/invoked/order/gronn/proc/can_order(mob/living/target, mob/living/user)
	if(target == user)
		to_chat(user, span_alert("I cannot order myself!"))
		return 0
	if(HAS_TRAIT(target, TRAIT_GRONN_HORDE))
		return 1
	if(!(target.job in list("Horde Rider", "Gronnic Chieftain")))
		to_chat(user, span_alert("I cannot order one not of the Horde!"))
		return 0
	return 1

/obj/effect/proc_holder/spell/invoked/order/gronn
	name = "Horde Order"
	var/effect_to_apply
	var/message_varname

/obj/effect/proc_holder/spell/invoked/order/gronn/cast(list/targets, mob/living/user)
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

/obj/effect/proc_holder/spell/invoked/order/gronn/proc/on_success(mob/living/user, mob/living/target)
	return

/***************************************************************
 *  INDIVIDUAL HORDE ORDERS
 ***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/gronn/charge
	name = "Charge!"
	overlay_state = "charge"
	effect_to_apply = /datum/status_effect/buff/order/gronn/charge
	message_varname = "chargetext"

/datum/status_effect/buff/order/gronn/charge
	id = "gronn_charge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/gronn/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/datum/status_effect/buff/order/gronn/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("The Chieftain calls the charge!"))

/atom/movable/screen/alert/status_effect/buff/order/gronn/charge
	name = "Charge!"
	desc = "The Chieftain wills it - now is the time to ride them down!"
	icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/gronn/retreat
	name = "Scatter!"
	overlay_state = "movemovemove"
	effect_to_apply = /datum/status_effect/buff/order/gronn/retreat
	message_varname = "retreattext"

/datum/status_effect/buff/order/gronn/retreat
	id = "gronn_retreat"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/gronn/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 30 SECONDS

/datum/status_effect/buff/order/gronn/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("The Chieftain orders me to scatter!"))

/atom/movable/screen/alert/status_effect/buff/order/gronn/retreat
	name = "Scatter!"
	desc = "The Chieftain orders me to break off and get clear!"
	icon_state = "buff"

/***************************************************************
 *  ORDER SETUP PROC
 ***************************************************************/

/mob/living/carbon/human/mind/proc/setordersgronn()
	set name = "Rehearse Orders"
	set category = "Voice of Command"

	#define ORDER_INPUT(varname, prompt) \
		mind.varname = input("Send a message.", prompt) as text|null; \
		if(!mind.varname) { to_chat(src, "I must rehearse something for this order..."); return }

	ORDER_INPUT(chargetext, "Ride them down!!")
	ORDER_INPUT(retreattext, "Scatter!!")

	#undef ORDER_INPUT
