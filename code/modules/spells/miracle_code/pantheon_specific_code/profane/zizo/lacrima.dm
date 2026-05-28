// T3 Lacrima (plunge your hand into someone's ribs to rip out their impure lux for your diabolical uses)

/datum/action/cooldown/spell/lacrima
	name = "Lacrima"
	desc = "Wreath your hand in inhumen energies.\n \
	USE on a mind-inhabited victim who is alyve, floored, whose lux is intact to plunge your hand into their chest, shattering their ribs and will alike in order to forcefully tear the lux from their chest.\n \
	DISARM on a PURE lux to convert it into IMPURE lux, in order to deprive it of those who need it or to fuel your wicked necromantic relics."
	overlay_state = "noc_revive"
	clothes_req = FALSE
	drawmessage = "I pray to ZIZO for but a sliver of Her power, wreathing my hand in inhumen energies!"
	dropmessage = "I allow the energies upon my hand to dissipate."
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 0
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/lacrima

/datum/action/cooldown/spell/lacrima/free
	miracle = FALSE

/obj/item/melee/touch_attack/lacrima
	name = "\improper lux ripper"
	desc = "ZIZO's will is to perverse the lux of the lyving. With but a mere shred of Her power, you will do exactly that."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use, INTENT_DISARM)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#ff0000"
	associated_skill = /datum/skill/magic/holy

/obj/item/melee/touch_attack/lacrima/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/lacrima/afterattack(mob/living/carbon/human/target, mob/living/carbon/human/user, proximity)
	switch(user.used_intent.type)
		if(/datum/intent/use)
			lux_rip(target, user)
		if(INTENT_DISARM)
			if(istype(target, /obj/item/reagent_containers/lux))
				perverse_lux(target, user)
			else
				to_chat(user, span_info("That's not pure lux."))

/obj/item/melee/touch_attack/lacrima/proc/lux_rip(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 100
	var/tear_time = 50

	if(target == user)
		to_chat(user, span_alert("I shouldn't rip out my own lux! I need that."))
		return
	if(!target.mind)
		to_chat(user, span_info("This one's lux is weak and insufficient. I need a victim with higher conscious!"))
		return
	if(!isliving(target))
		to_chat(user, span_info("Only lyving creachers may have their lux torn."))
		return
	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to be next to [target] to rip out their lux."))
		return
	if((target.mobility_flags & MOBILITY_STAND))
		to_chat(user, span_info("My target must be lying down to have their lux torn."))
		return
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.mob_biotypes & MOB_UNDEAD) //can't farm your skeletons
		to_chat(user, span_notice("This one's lux is already disturbed!"))
		return
	else
		to_chat(user, span_alert("I begin reaching my hand towards [target], preparing to tear their lux from their body..."))
		user.visible_message(span_alert("[user] reaches towards [target]'s chest, inhumen flames wreathing [user.p_their()] hand..."))
	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return
		if(chest)
			if(!HAS_TRAIT(target, TRAIT_NOPAIN))
				target.emote("painscream")
			chest.add_wound(/datum/wound/fracture/chest)
			target.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
			user.visible_message(span_alert("[user] plunges their fist into [target]'s ribcage, shattering it spectacularly!"))
	if(!do_after(user, tear_time, target = target) && chest.has_wound(/datum/wound/fracture/chest))
		return
	if(!HAS_TRAIT(target, TRAIT_NOPAIN))
		target.emote("painscream")
		target.add_stress(/datum/stressevent/myfuckingluxman)
	playsound(src, 'sound/items/blackmirror_needle.ogg', 60, FALSE, 3)
	user.visible_message(span_alert("[user] tears a glob of lux from [target]'s chest!"))
	new /obj/item/reagent_containers/lux_impure(target.loc)
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)
	target.apply_status_effect(/datum/status_effect/debuff/devitalised)
	qdel(src)

/datum/stressevent/myfuckingluxman
	desc = span_boldred("THE ESSENCE OF MY LYFE HAS BEEN DEFILED!!")
	stressadd = 30
	timer = 5 MINUTES

/obj/item/melee/touch_attack/lacrima/proc/perverse_lux(atom/target, mob/living/carbon/human/user)
	var/perverse_time = 20

	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to get closer."))
		return
	to_chat(user, span_alert("I begin molding the [target] in my hands, perversing it with inhumen energies..."))
	if(!do_after(user, perverse_time, target = target))
		return
	else
		qdel(target)
		qdel(src)
		user.put_in_hands(new /obj/item/reagent_containers/lux_impure, forced = TRUE)
