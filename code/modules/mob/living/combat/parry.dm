#define STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL -2

/mob/living/proc/attempt_parry(datum/intent/intenty, mob/living/attacker)
	if(!intenty.parriable_intent) // If the intent is unparriable whatsoever just skip all the math
		return FALSE
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS) || HAS_TRAIT(src, TRAIT_NODEF) || !mob_can_parry)
		return FALSE
	if(pulledby || pulling)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable) || has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(!can_see_cone(attacker))
		return FALSE
	var/paired_swing = src?.dualwield_twoswing
	if(!paired_swing && world.time < (last_parry + parrydelay))
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			return FALSE

	if(!paired_swing)
		last_parry = world.time
		if(!istype(rmb_intent, /datum/rmb_intent/riposte))
			var/parrytime = setparrytime
			changeNext_def(parrytime)

	var/prob2defend = attacker.mind ? 0 : attacker.defprob
	if(m_intent == MOVE_INTENT_RUN)
		prob2defend = max(prob2defend - 15, 0)

	var/stamina_drained = BASE_PARRY_STAMINA_DRAIN
	var/obj/item/mainhand = get_active_held_item()
	var/mainhand_defense = 0
	var/obj/item/offhand = get_inactive_held_item()
	var/offhand_defense = 0

	var/weapon_parry = FALSE
	var/highest_defense = 0
	var/obj/item/used_weapon = mainhand

	if(istype(offhand, /obj/item/rogueweapon/shield/buckler))
		var/obj/item/rogueweapon/shield/buckler/blocking_buckler = offhand
		blocking_buckler.bucklerskill(src)
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		var/obj/item/rogueweapon/shield/buckler/blocking_buckler = mainhand
		blocking_buckler.bucklerskill(src)

	if(mainhand?.can_parry)
		mainhand_defense += (get_skill_level(mainhand.associated_skill) * 20)
		mainhand_defense += (mainhand.wdefense_dynamic * 10)
	if(offhand?.can_parry)
		offhand_defense += (get_skill_level(offhand.associated_skill) * 20)
		offhand_defense += (offhand.wdefense_dynamic * 10)

	if(mainhand_defense >= offhand_defense)
		highest_defense += mainhand_defense
	else
		used_weapon = offhand
		highest_defense += offhand_defense

	var/defender_skill = 0
	var/attacker_skill = 0
	var/obj/item/clothing/wrists/roguetown/bracers/unarmed_bracers

	if(highest_defense <= (get_skill_level(/datum/skill/combat/unarmed) * 20))
		defender_skill = get_skill_level(/datum/skill/combat/unarmed)
		var/obj/B = get_item_by_slot(SLOT_WRISTS)
		if(istype(B, /obj/item/clothing/wrists/roguetown/bracers))
			prob2defend += (defender_skill * 35)
			unarmed_bracers = B
		else
			prob2defend += (defender_skill * 10)		// no bracers gonna be butts.
		weapon_parry = FALSE
	else
		if(used_weapon)
			defender_skill = get_skill_level(used_weapon.associated_skill)
		else
			defender_skill = get_skill_level(/datum/skill/combat/unarmed)
		prob2defend += highest_defense
		weapon_parry = TRUE

	if(intenty.masteritem)
		attacker_skill = attacker.get_skill_level(intenty.masteritem.associated_skill)

		if(intenty.sharpness_penalty)
			intenty.masteritem.remove_bintegrity(intenty.sharpness_penalty)

		prob2defend -= (attacker_skill * 20)
		if(!HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))	// Yet another Frei related clamp
			if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
				if((intenty.masteritem.wbalance == WBALANCE_SWIFT) && (attacker.STASPD > src.STASPD)) //enemy weapon is quick, so get a bonus based on spddiff
					var/spdmod = ((attacker.STASPD - src.STASPD) * 10)
					var/permod = ((src.STAPER - attacker.STAPER) * 5)
					var/intmod = ((src.STAINT - attacker.STAINT) * 3)
					if(mind)
						if(permod > 0)
							spdmod -= permod
						if(intmod > 0)
							spdmod -= intmod
					var/finalmod = spdmod
					if(mind)
						finalmod = clamp(spdmod, 0, 45)
					prob2defend -= finalmod
	else
		attacker_skill = attacker.get_skill_level(/datum/skill/combat/unarmed)
		prob2defend -= (attacker_skill * 20)

	// --- Weapon binding! ---

	if(has_status_effect(/datum/status_effect/buff/weapon_binded))
		prob2defend += 20
	if(!has_status_effect(/datum/status_effect/buff/weapon_binded) && !has_status_effect(/datum/status_effect/debuff/weapon_binded))
		var/mob/living/carbon/human/HL = src
		if(HL.try_bind(used_weapon, attacker))
			return TRUE	//Tentative, might be better if it only increased parry chance on the initial binding rather than a full block.

	// --- Weapon Binding End! ---

	if(HAS_TRAIT(src, TRAIT_GUIDANCE))
		prob2defend += 20

	if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
		prob2defend -= 20

	if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
		prob2defend -= 40

	var/datum/status_effect/debuff/magical_blindness/magic_blind = src.has_status_effect(/datum/status_effect/debuff/magical_blindness)
	if (magic_blind)
		prob2defend -= magic_blind.effect_strength * 5 // 5% parry chance loss per level

	if(ishuman(src))
		var/mob/living/carbon/human/oldie = src
		if(oldie.age == AGE_OLD && !HAS_TRAIT(oldie, TRAIT_MAGEARMOR))//Old martial characters get a bonus to parry. Mages do not, they get unique bonuses already for being old.
			prob2defend += 20

	// parrying while knocked down sucks ass
	if(!(mobility_flags & MOBILITY_STAND) && !has_status_effect(/datum/status_effect/buff/weapon_binded))
		prob2defend *= 0.65

	if(HAS_TRAIT(src, TRAIT_SENTINELOFWITS))
		if(ishuman(src))
			var/mob/living/carbon/human/SH = src
			var/sentinel = SH.calculate_sentinel_bonus()
			prob2defend += sentinel

	if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
		if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
			prob2defend -= 20

	prob2defend = clamp(prob2defend, 5, 90)
	if(HAS_TRAIT(attacker, TRAIT_HARDSHELL) && client) //Dwarf-merc specific limitation w/ their armor on in pvp
		prob2defend = clamp(prob2defend, 5, 70)
	if(!check_armor_skill())
		prob2defend = clamp(prob2defend, 5, 75) //Caps your max parry to 75 if using armor you're not trained in. Bad dexerity.
		stamina_drained = stamina_drained + 5 //More stamina usage for not being trained in the armor you're using.

	var/parry_status = FALSE
	var/text

	text += "Roll to parry... [HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"

	// Dual wield drawback (-5%)
	var/dualwield_penalty = HAS_TRAIT(src, TRAIT_DUALWIELDER) && src.can_dualwield(mainhand, offhand)
	if(dualwield_penalty)
		prob2defend = clamp(prob2defend - 5, 5, 90)
		text += " (-5%)"

	if(has_status_effect(/datum/status_effect/swingdelay/penalty))
		prob2defend -= 50

	if(prob(prob2defend))
		parry_status = TRUE

	if(parry_status)
		if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
			if(intenty.masteritem)
				if(intenty.masteritem.wbalance < WBALANCE_NORMAL && attacker.STASTR > src.STASTR) //enemy weapon is heavy, so get a bonus scaling on strdiff
					stamina_drained = stamina_drained + ( intenty.masteritem.wbalance * ((attacker.STASTR - src.STASTR) * STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL) )
	else
		text += span_warning(" The enemy defeated my parry!")
	if(src.client?.prefs.showrolls)
		to_chat(src, span_info("[text]"))

	// Failed parry cutoff here
	if(!parry_status)
		if(HAS_TRAIT(src, TRAIT_MAGEARMOR))
			if(magearmor == 0)
				magearmor = 1
				apply_status_effect(/datum/status_effect/buff/magearmor)
				to_chat(src, span_boldwarning("My mage armor absorbs the hit and dissipates!"))
				return TRUE
			else
				return FALSE
		if(HAS_TRAIT(src, TRAIT_SCALEARMOR))
			if(scalearmor == 0)
				scalearmor = 1
				apply_status_effect(/datum/status_effect/buff/scalearmor)
				to_chat(src, span_boldwarning("My scales absorb the hit and dissipate the force!"))
				return TRUE
			else
				return FALSE
		else
			return FALSE

	stamina_drained = max(stamina_drained, 5)

	var/exp_multi = 1

	if(!attacker.mind)
		exp_multi = exp_multi/2
	if(istype(attacker.rmb_intent, /datum/rmb_intent/weak))
		exp_multi = exp_multi/2

	var/obj/item/AB = intenty.masteritem
	var/attacker_skill_type

	if(AB)
		attacker_skill_type = AB.associated_skill
	else
		attacker_skill_type = /datum/skill/combat/unarmed

	if(weapon_parry == TRUE)
		if(!do_parry(used_weapon, stamina_drained, attacker)) //show message
			return FALSE
		//only gain experience if attacker and defender aren't using non-combat skills for their weapons
		if(ispath(attacker_skill_type, /datum/skill/combat) && ispath(used_weapon.associated_skill, /datum/skill/combat))
			if ((mobility_flags & MOBILITY_STAND))
				var/skill_target = attacker_skill
				if(!HAS_TRAIT(attacker, TRAIT_GOODTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if (can_train_combat_skill(src, used_weapon.associated_skill, skill_target))
					mind.add_sleep_experience(used_weapon.associated_skill, max(round(STAINT*exp_multi), 0), FALSE)

			//attacker skill gain
			if(attacker.mind)
				if ((mobility_flags & MOBILITY_STAND))
					var/skill_target = defender_skill
					if(!HAS_TRAIT(src, TRAIT_GOODTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
						skill_target -= SKILL_LEVEL_NOVICE
					if (can_train_combat_skill(attacker, attacker_skill_type, skill_target))
						attacker.mind.add_sleep_experience(attacker_skill_type, max(round(STAINT*exp_multi), 0), FALSE)

		if(prob(66) && AB)
			if((used_weapon.flags_1 & CONDUCT_1) && (AB.flags_1 & CONDUCT_1))
				fullscreen_redflash("whiteflash")
				attacker.fullscreen_redflash("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_step(src, dir)
				S.set_up(1, 1, front)
				S.start()
			else
				flash_fullscreen("blackflash2")
		else
			flash_fullscreen("blackflash2")

		var/dam2take = round((get_complex_damage(AB,attacker,used_weapon.blade_dulling)/2),1)
		if(dam2take)
			var/intdam = used_weapon.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(used_weapon == offhand)
				intdam = INTEG_PARRY_DECAY_NOSHARP
			if(istype(attacker.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS

			// Heavy weapons chew through shields — use higher of demolition_mod or intent intdamage_factor
			if(istype(used_weapon, /obj/item/rogueweapon/shield) && intenty)
				var/shield_mult = max(intenty.demolition_mod, intenty.intent_intdamage_factor)
				intdam *= shield_mult

			if(!has_status_effect(/datum/status_effect/buff/weapon_binded))
				used_weapon.take_damage(intdam, BRUTE, used_weapon.d_type)
				used_weapon.remove_bintegrity(sharp_loss, attacker)
			if(mind)
				dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
				changeMaxDodge(2)

		return TRUE

	if(weapon_parry == FALSE)
		if(!do_unarmed_parry(stamina_drained, attacker))
			testing("failparry")
			return FALSE
		//only gain experience if attacker isn't using a non-combat skill for their weapon
		if(ispath(attacker_skill_type, /datum/skill/combat))
			if((mobility_flags & MOBILITY_STAND))
				var/skill_target = attacker_skill
				if(!HAS_TRAIT(attacker, TRAIT_GOODTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(HAS_TRAIT(attacker, TRAIT_BADTRAINER))
					skill_target -= SKILL_LEVEL_NOVICE
				if(can_train_combat_skill(src, /datum/skill/combat/unarmed, skill_target))
					mind?.add_sleep_experience(/datum/skill/combat/unarmed, max(round(STAINT*exp_multi), 0), FALSE)

		if(unarmed_bracers)
			unarmed_bracers.take_damage(INTEG_PARRY_DECAY_NOSHARP, "slash", armor_penetration = 100)
		flash_fullscreen("blackflash2")
		if(mind)
			dodgetime = CLAMP(dodgetime - 2, 0, CLICK_CD_DODGE)
			changeMaxDodge(2)
		return TRUE

/mob/proc/do_parry(obj/item/weapon, parrydrain as num, mob/living/attacker)
	if(!ishuman(src))
		if(weapon)
			playsound(get_turf(src), pick(weapon.parrysound), 100, FALSE)
		return TRUE

	var/mob/living/carbon/human/blocker = src
	if(!blocker.stamina_add(parrydrain))
		to_chat(src, span_warning("I'm too tired to parry!"))
		return FALSE //crush through
	if(weapon)
		playsound(get_turf(src), pick(weapon.parrysound), 100, FALSE)
	if(client)
		record_round_statistic(STATS_PARRIES)
		log_combat(src, attacker, "parried", weapon, defense_log_note(attacker))
	if(istype(rmb_intent, /datum/rmb_intent/riposte))
		visible_message(span_boldwarning("<b>[src]</b> ripostes [attacker] with [weapon]!"))
	else
		visible_message(span_boldwarning("<b>[src]</b> parries [attacker] with [weapon]!"))
	if(!iscarbon(attacker))	//Non-carbon mobs never make it to the proper parry proc where the other calculations are done.
		if(weapon.max_blade_int)
			weapon.remove_bintegrity(SHARPNESS_ONHIT_DECAY, attacker)
			weapon.take_damage(INTEG_PARRY_DECAY, BRUTE, "slash")
		else
			weapon.take_damage(INTEG_PARRY_DECAY_NOSHARP, BRUTE, "slash")
	return TRUE

/mob/living/proc/do_unarmed_parry(parrydrain as num, mob/living/attacker)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.stamina_add(parrydrain))
			playsound(get_turf(src), pick(parry_sound), 100, FALSE)
			visible_message(span_warning("<b>[src]</b> parries [attacker]!"))
			if(client)
				record_round_statistic(STATS_PARRIES)
				log_combat(src, attacker, "parried", null, defense_log_note(attacker))
			return TRUE
		else
			to_chat(src, span_boldwarning("I'm too tired to parry!"))
			return FALSE
	else
		if(client)
			record_round_statistic(STATS_PARRIES)
			log_combat(src, attacker, "parried", null, defense_log_note(attacker))
		playsound(get_turf(src), pick(parry_sound), 100, FALSE)
		return TRUE

/mob/living/proc/pick_bind_sfx(wbalance)
	switch(wbalance)
		if(WBALANCE_NORMAL)
			return pick('sound/foley/binds/bind_normal1.ogg','sound/foley/binds/bind_normal2.ogg','sound/foley/binds/bind_normal3.ogg','sound/foley/binds/bind_normal4.ogg','sound/foley/binds/bind_normal5.ogg','sound/foley/binds/bind_normal6.ogg','sound/foley/binds/bind_normal7.ogg','sound/foley/binds/bind_normal8.ogg','sound/foley/binds/bind_normal9.ogg','sound/foley/binds/bind_normal10.ogg','sound/foley/binds/bind_normal11.ogg','sound/foley/binds/bind_normal12.ogg','sound/foley/binds/bind_normal13.ogg','sound/foley/binds/bind_normal14.ogg')
		if(WBALANCE_HEAVY)
			return pick('sound/foley/binds/bind_heavy1.ogg','sound/foley/binds/bind_heavy2.ogg','sound/foley/binds/bind_heavy3.ogg','sound/foley/binds/bind_heavy4.ogg','sound/foley/binds/bind_heavy5.ogg','sound/foley/binds/bind_heavy6.ogg','sound/foley/binds/bind_heavy7.ogg','sound/foley/binds/bind_heavy8.ogg','sound/foley/binds/bind_heavy9.ogg','sound/foley/binds/bind_heavy10.ogg','sound/foley/binds/bind_heavy11.ogg','sound/foley/binds/bind_heavy12.ogg')
		if(WBALANCE_SWIFT)
			return pick('sound/foley/binds/bind_swift1.ogg','sound/foley/binds/bind_swift2.ogg','sound/foley/binds/bind_swift3.ogg','sound/foley/binds/bind_swift4.ogg','sound/foley/binds/bind_swift5.ogg','sound/foley/binds/bind_swift6.ogg')
#undef STAM_DRAIN_PER_STR_DIFF_HEAVY_BAL
