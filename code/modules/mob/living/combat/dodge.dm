/mob/living/proc/attempt_dodge(datum/intent/attack_intent, mob/living/user)
	if(pulledby || pulling)
		return FALSE
	var/paired_swing = user?.dualwield_twoswing
	if(!paired_swing && world.time < last_dodge + dodgetime)
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/riposted))
		return FALSE
	if(has_status_effect(/datum/status_effect/debuff/exposed) || has_status_effect(/datum/status_effect/debuff/vulnerable))
		return FALSE
	if(!paired_swing)
		last_dodge = world.time
	if(src.loc == user.loc)
		return FALSE
	if(attack_intent)
		if(!attack_intent.dodgeable_intent)
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NODEF))
		return FALSE
	if(attack_intent?.dodgeable_intent)
		var/list/dirry = list()
		var/dx = x - user.x
		var/dy = y - user.y
		if(abs(dx) < abs(dy))
			if(dy > 0)
				dirry += NORTH
				dirry += WEST
				dirry += EAST
			else
				dirry += SOUTH
				dirry += WEST
				dirry += EAST
		else
			if(dx > 0)
				dirry += EAST
				dirry += SOUTH
				dirry += NORTH
			else
				dirry += WEST
				dirry += NORTH
				dirry += SOUTH
		var/turf/dodge_turf
		if(fixedeye)
			var/dodgedir = turn(dir, 180)
			var/turf/turfcheck = get_step(src, dodgedir)
			if(turfcheck)
				if(check_dodge_turf(turfcheck))
					dodge_turf = turfcheck
		if(!dodge_turf)
			for(var/dodge_dir in shuffle(dirry.Copy()))
				var/turf/turfcheck = get_step(src, dodge_dir)
				if(turfcheck)
					if(check_dodge_turf(turfcheck))
						dodge_turf = turfcheck
						break
		if(pulledby)
			return FALSE
		if(!dodge_turf)
			to_chat(src, span_boldwarning("There's nowhere to dodge to!"))
			return FALSE
		else
			if(do_dodge(user, dodge_turf))
				flash_fullscreen("blackflash2")
				user.aftermiss()
				return TRUE
			else
				return FALSE
	else
		return FALSE

/mob/living/proc/check_dodge_turf(turf/check_turf)
	if(!check_turf)
		return FALSE
	if(check_turf.density)
		return FALSE
	for(var/atom/movable/AM in check_turf.contents)
		if(AM.density)
			return FALSE
	return TRUE

/// origin is used for multi-step dodges like jukes
/mob/living/proc/get_dodge_destinations(mob/living/attacker, atom/origin = src)
	var/dodge_dir = get_dir(attacker, origin)
	if(!dodge_dir) // dir is 0, so we're on the same tile.
		return null
	var/list/dirry = list(turn(dodge_dir, -90), dodge_dir, turn(dodge_dir, 90))
	// pick a random dir
	var/list/turf/dodge_candidates = list()
	for(var/dir_to_check in dirry)
		var/turf/dodge_candidate = get_step(origin, dir_to_check)
		if(!dodge_candidate)
			continue
		if(dodge_candidate.density)
			continue
		var/has_impassable_atom = FALSE
		for(var/atom/movable/AM in dodge_candidate)
			if(!AM.CanPass(src, dodge_candidate))
				has_impassable_atom = TRUE
				break
		if(has_impassable_atom)
			continue
		dodge_candidates += dodge_candidate
	return dodge_candidates

/mob/living/proc/do_dodge(mob/living/attacker, turf/turfy)
	if(dodge_sanity)
		return FALSE
	if(stamina >= max_stamina) // Out of stamina? Out of dodge
		return FALSE
	var/obj/item/IL
	var/ourskill = 0
	var/theirskill = 0
	var/drained = 8
	var/drained_npc = 5
	var/mainh = get_active_held_item()
	var/offh = get_inactive_held_item()
	var/obj/item/attacking_item = attacker?.used_intent?.masteritem

	var/mob/living/carbon/human/human_dodger
	if(ishuman(src))
		human_dodger = src
		IL = human_dodger.get_active_held_item()
		if(IL && IL?.associated_skill)
			ourskill = get_skill_level(IL.associated_skill)
		else
			ourskill = get_skill_level(/datum/skill/combat/unarmed)

	var/prob2defend = attacker.defprob
	var/is_in_cone = can_see_cone(src)
	if(!is_in_cone)
		changeNext_def(CLAMP(dodgetime + 2, 0, CLICK_CD_DODGE))
		changeMaxDodge(-2)
	var/has_trait = human_dodger?.check_dodge_skill()
	if(human_dodger?.check_dodge_skill())
		prob2defend += (STASPD * 15)
	else
		prob2defend += (STASPD * 10)
	prob2defend -= (attacker.STASPD * 10)

	if(attacking_item)
		if(attacking_item.wbalance == WBALANCE_SWIFT && attacker.STASPD > STASPD) //nme weapon is quick, so they get a bonus based on spddiff
			prob2defend = prob2defend - ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		if(attacking_item.wbalance == WBALANCE_HEAVY && STASPD > attacker.STASPD) //nme weapon is slow, so its easier to dodge if we're faster
			prob2defend = prob2defend + ( attacking_item.wbalance * ((attacker.STASPD - STASPD) * 10) )
		prob2defend = prob2defend - (attacker.get_skill_level(attacking_item.associated_skill) * 10)

	if(!human_dodger)
		prob2defend = clamp(prob2defend, 5, 90)
		if(client?.prefs.showrolls)
			to_chat(src, span_info("Roll to dodge... [prob2defend]%"))
		if(!prob(prob2defend))
			return FALSE

	if(human_dodger)
		if(!human_dodger?.check_armor_skill() || human_dodger?.legcuffed)
			human_dodger.Knockdown(1)
			human_dodger.drop_all_held_items()
			return FALSE
		if(attacking_item) //the enemy attacked us with a weapon
			if(!attacking_item.associated_skill) //the enemy weapon doesn't have a skill because its improvised, so penalty to attack
				prob2defend = prob2defend + 10
			else
				prob2defend = prob2defend + (human_dodger.get_skill_level(attacking_item.associated_skill) * 10)
		else //the enemy attacked us unarmed or is nonhuman
			if(attacker?.used_intent?.unarmed)
				prob2defend = prob2defend - (attacker.get_skill_level(/datum/skill/combat/unarmed) * 10)
				prob2defend = prob2defend + (human_dodger.get_skill_level(/datum/skill/combat/unarmed) * 10)
				if(attacker.STASPD > STASPD) //unarmed is inherently swift
					prob2defend = prob2defend - ((attacker.STASPD - STASPD) * 10)

		var/ignore_DE_bonus = FALSE

		if(HAS_TRAIT(src, TRAIT_GUIDANCE))
			prob2defend += 20
			drained -= 5

		if(HAS_TRAIT(attacker, TRAIT_GUIDANCE))
			prob2defend -= 20
			ignore_DE_bonus = TRUE

		if(HAS_TRAIT(attacker, TRAIT_CURSE_RAVOX))
			prob2defend -= 40
			ignore_DE_bonus = TRUE

		var/datum/status_effect/debuff/magical_blindness/magic_blind = human_dodger.has_status_effect(/datum/status_effect/debuff/magical_blindness)
		if (magic_blind)
			prob2defend -= magic_blind.effect_strength * 5 // 5% dodge chance loss per level

		// dodging while knocked down sucks ass
		if(!(mobility_flags & MOBILITY_STAND))
			prob2defend *= 0.25
			ignore_DE_bonus = TRUE

		if(HAS_TRAIT(human_dodger, TRAIT_SENTINELOFWITS))
			var/sentinel = human_dodger.calculate_sentinel_bonus()
			prob2defend += sentinel

		if(HAS_TRAIT(attacker, TRAIT_ARMOUR_LIKED))
			if(HAS_TRAIT(attacker, TRAIT_FENCERDEXTERITY))
				prob2defend -= 10
				ignore_DE_bonus = TRUE
		
		if(!is_in_cone)
			ignore_DE_bonus = TRUE

		if(human_dodger.STASPD <= 9)
			ignore_DE_bonus = TRUE

		if(attacking_item && IL)	//Skilldiff applies extra stamloss, tentative
			drained += (attacker.get_skill_level(attacking_item.associated_skill) - human_dodger.get_skill_level(IL.associated_skill)) * 2

			if(istype(attacker.rmb_intent, /datum/rmb_intent/swift) && attacking_item.wbalance != WBALANCE_HEAVY)
				// We drain extra stam if we're being attacked by swift stance, inversely based on our dodgetime
				// This is quite tentative and the numbers can be whatever, but this is meant to make Swift a good option
				// Without allowing "just spam them down" to work all that well.
				if(dodgetime <= CLICK_CD_FAST)
					drained += (abs(round((CLICK_CD_HEAVY - dodgetime) / 2)))

		if(has_trait && human_dodger.mind && !ignore_DE_bonus)
			prob2defend = 90	//We cap it out if we have Dodge Expert as a Player.

		if(human_dodger.STASPD < STASPD)
			if(IL && IL.wbalance != WBALANCE_HEAVY)
				drained += (STASPD - human_dodger.STASPD)

		if(dodgetime <= CLICK_CD_DODGE && !ignore_DE_bonus && has_trait && human_dodger.mind)
			if(istype(mainh, /obj/item/rogueweapon/shield) || istype(offh, /obj/item/rogueweapon/shield))	//why do I have to pre-empt the worst of you
				max_dodge = MAX_DODGE_FLOOR
				changeNext_def(CLICK_CD_DODGE)
		prob2defend = clamp((prob2defend + max_dodge), 5, (90 + max_dodge))

		// Dual wield drawback (-5%)
		var/dualwield_penalty = HAS_TRAIT(src, TRAIT_DUALWIELDER) && human_dodger.can_dualwield(mainh, offh)
		if(dualwield_penalty)
			prob2defend = max(prob2defend - 5, 0)

		if(client?.prefs.showrolls)
			var/text = "Roll to dodge... [HAS_TRAIT(attacker, TRAIT_DECEIVING_MEEKNESS) ? "???" : prob2defend]%"

			if(dualwield_penalty)
				text += " (-5%)"

			to_chat(src, span_info(text))

		if(src.has_status_effect(/datum/status_effect/swingdelay/penalty))
			prob2defend -= 50

		var/dodge_status = FALSE
		if(prob(prob2defend))
			dodge_status = TRUE

		if(!dodge_status)
			return FALSE
		if(!attacker?.mind) // For NPC, reduce the drained to 5 stamina
			drained = drained_npc
		if(!human_dodger.stamina_add(max(drained,5)))
			to_chat(src, span_warning("I'm too tired to dodge!"))
			return FALSE

	// Should only show success cause it terminates earlier otherwise
	if(client)
		log_combat(src, attacker, "dodged", null, defense_log_note(attacker))
	dodge_sanity = TRUE
	playsound(src, 'sound/combat/dodge.ogg', 100, FALSE)
	throw_at(turfy, 1, 2, src, FALSE)
	if(drained > 0)
		visible_message(span_warning("<b>[src]</b> dodges [attacker]'s attack!"))
	else
		visible_message(span_warning("<b>[src]</b> easily dodges [attacker]'s attack!"))
	if(get_dist(src, attacker) <= attacker.used_intent?.reach)	//We are still in range of the attacker's weapon post-dodge
		var/probclip = 50
		var/obj/item/IS = get_active_held_item()
		var/obj/item/IU = attacker.get_active_held_item()
		if(IS)
			if(IS.wlength > WLENGTH_NORMAL)
				probclip += (IS.wlength - WLENGTH_NORMAL) * 10	//if wlength isn't standardised this might skyrocket it to >100%
			else
				probclip -= (WLENGTH_NORMAL - IS.wlength) * 10
		var/dist = (attacker.used_intent?.reach - get_dist(src, attacker)) - 1 //-1 because we already are in range and triggered this check to begin with.
		if(dist > 0)
			probclip += dist * 10
		if(STALUC != attacker.STALUC)
			var/lucmod = STALUC - attacker.STALUC
			probclip += lucmod * 10
		if(prob(probclip) && IS && IU)
			var/intdam = IS.max_blade_int ? INTEG_PARRY_DECAY : INTEG_PARRY_DECAY_NOSHARP
			var/sharp_loss = SHARPNESS_ONHIT_DECAY
			if(istype(attacker.rmb_intent, /datum/rmb_intent/strong))
				sharp_loss += STRONG_SHP_BONUS
				intdam += STRONG_INTG_BONUS

			IS.take_damage(intdam, BRUTE, IU.d_type)
			IS.remove_bintegrity(sharp_loss, src)

			attacker.visible_message(span_warning("<b>[attacker]</b> clips [src]'s weapon!"))
			playsound(attacker, 'sound/misc/weapon_clip.ogg', 100)

	var/ignore_penalty = FALSE
	if(fixedeye && goodluck(5))
		ignore_penalty = TRUE
	if(!ignore_penalty)
		var/max_mod = 0
		max_mod = ourskill - theirskill
		changeNext_def(clamp(dodgetime + 1, 0, CLICK_CD_DODGE))
		changeMaxDodge(-1 + ((max_mod < 0) ? max_mod : 0))

	dodge_sanity = FALSE
	return TRUE
