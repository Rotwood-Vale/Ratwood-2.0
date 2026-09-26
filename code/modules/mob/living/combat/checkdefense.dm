/// Checks if a mob being attacked is able to block or dodge an attack
/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/attacker)
	testing("begin defense")
	if(!intenty || !attacker)
		CRASH("/mob/living/checkdefense called without passing a intent or attacker.")
	if(!cmode)
		return FALSE
	if(stat)
		return FALSE
	if(!mob_can_parry && !mob_can_dodge) //mob can do neither of these
		return FALSE
	if(attacker == src)
		return FALSE
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE

	var/datum/status_effect/swingdelay/disrupt/SW = has_status_effect(/datum/status_effect/swingdelay/disrupt)
	if(SW)
		if(!SW.is_disrupted())
			SW.attacked()
			swing_state = FALSE
			return FALSE

	if(client && used_intent)
		if(client.charging && used_intent.tranged && !used_intent.tshield)
			return FALSE

	if(has_status_effect(/datum/status_effect/debuff/vulnerable))
		if(!has_status_effect(/datum/status_effect/buff/weapon_binded) && !has_status_effect(/datum/status_effect/debuff/weapon_binded))
			if(ishuman(src) && mind && attacker?.mind)
				var/held = get_active_held_item()
				if(istype(held, /obj/item/rogueweapon))
					if(check_bait_subzone(zone_selected) == check_bait_subzone(attacker.zone_selected) && zone_selected != BODY_ZONE_CHEST)
						var/mob/living/carbon/human/HL = src
						if(HL.try_bind(held, attacker, TRUE))
							remove_status_effect(/datum/status_effect/debuff/vulnerable)
							return TRUE

	switch(d_intent)
		if(INTENT_PARRY)
			return attempt_parry(intenty, attacker)
		if(INTENT_DODGE)
			return attempt_dodge(intenty, attacker)

/mob/living/simple_animal/checkdefense(datum/intent/intenty, mob/living/attacker)
	if(intenty?.type == INTENT_GRAB && tame)
		return FALSE
	return ..()
