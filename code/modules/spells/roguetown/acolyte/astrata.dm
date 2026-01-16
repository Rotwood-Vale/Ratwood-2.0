/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue
	name = "Fire Lance"
	desc = "Deals damage and ignites target, Deals extra damage to undead."
	overlay_state = "sacredflame"
	sound = 'sound/magic/bless.ogg'
	invocations = list("By fire, be cleansed!")//Not so sacred.
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = TRUE
	devotion_cost = 75
	projectile_type = /obj/projectile/magic/astratablast


/obj/projectile/magic/astratablast
	damage = 25
	name = "lance of holy fire"
	nodamage = FALSE
	damage_type = BURN
	speed = 0.3
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	flag = "magic"
	light_color = "#a98107"
	light_outer_range = 7
	tracer_type = /obj/effect/projectile/tracer/solar_beam
	var/fuck_that_guy_multiplier = 1.6//On par with divine blast against undead, more-or-less.
	var/biotype_we_look_for = MOB_UNDEAD

/obj/projectile/magic/astratablast/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(M.mob_biotypes & biotype_we_look_for || istype(M, /mob/living/simple_animal/hostile/rogue/skeleton))
			damage *= fuck_that_guy_multiplier
			M.adjust_fire_stacks(10)
			visible_message(span_warning("[target] erupts in flame upon being struck by [src]!"))
			M.ignite_mob()
		else
			M.adjust_fire_stacks(4)
			visible_message(span_warning("[src] ignites [target]!"))
			M.ignite_mob()
	return FALSE

/obj/effect/proc_holder/spell/invoked/ignition
	name = "Ignition"
	desc = "Ignite a flammable object at range."
	overlay_state = "sacredflame"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/heal.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/ignition/cast(list/targets, mob/user = usr)
	. = ..()
	// Spell interaction with ignitable objects (burn wooden things, light torches up)
	if(isobj(targets[1]))
		var/obj/O = targets[1]
		if(O.fire_act())
			user.visible_message("<font color='yellow'>[user] points at [O], igniting it with sacred flames!</font>")
			return TRUE
		else
			to_chat(user, span_warning("You point at [O], but it fails to catch fire."))
			return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/revive
	name = "Anastasis"
	desc = "Focus Astratas energy though a stationary psycross, reviving the target from death."
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 80
	/// Amount of PQ gained for reviving people
	var/revive_pq = PQ_GAIN_REVIVE

/obj/effect/proc_holder/spell/invoked/revive/start_recharge()
	// Because the cooldown for anastasis is so incredibly low, not having tech impacts them more heavily than other faiths
	var/tech_resurrection_modifier = SSchimeric_tech.get_resurrection_multiplier()
	if(tech_resurrection_modifier > 1)
		recharge_time = initial(recharge_time) * (tech_resurrection_modifier * 2.5)
	. = ..()

/obj/effect/proc_holder/spell/invoked/revive/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE
	testing("revived1")
	var/mob/living/target = targets[1]
	if(!target.check_revive(user))
		revert_cast()
		return FALSE
	if(GLOB.tod == "night")
		to_chat(user, span_warning("Let there be light."))
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		S.AOE_flash(user, range = 8)
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		target.visible_message(
			span_danger("[target] is unmade by holy light!"),
			span_userdanger("I'm unmade by holy light!")
		)
		target.gib()
		return TRUE
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	//GET OVER HERE!
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
	if(!target.mind.active)
		to_chat(user, "[target] will not return from afterlife.")
		revert_cast()
		return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		revert_cast()
		return FALSE
	testing("revived2")
	target.emote("breathgasp")
	target.Jitter(100)
	record_round_statistic(STATS_ASTRATA_REVIVALS)
	target.update_body()
	target.visible_message(span_notice("[target] is revived by holy light!"), span_green("I awake from the void."))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
	target.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/obj/effect/proc_holder/spell/invoked/revive/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross."))
		return FALSE
	return TRUE

// Global tracking for divine destruction state
// This is necessary for SOVL
GLOBAL_LIST_EMPTY(divine_destruction_mobs) // Tracks mobs undergoing divine destruction: list(mob) = list(timer_ids)

//============================================
// TIER 0 MIRACLES
//============================================

//T0. Removes cone vision for a dynamic duration.
/obj/effect/proc_holder/spell/self/astrata_gaze
	name = "Astratan Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, lasts longer during the dae and gives a perception bonus to those skilled and holy arts."
	overlay_state = "astrata_gaze"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/astrata_choir.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = list("Astrata show me true.")
	invocation_type = "shout"
	recharge_time = 120 SECONDS
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/astrata_gaze/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	H.apply_status_effect(/datum/status_effect/buff/astrata_gaze, user.get_skill_level(associated_skill))
	return TRUE

//T0. Ignites torches, ovens, undead, and candles.
/obj/effect/proc_holder/spell/invoked/ignition
	name = "Ignition"
	desc = "Ignite a flammable object at range."
	overlay_state = "sacredflame"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 15
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/heal.ogg'
	invocations = list()
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/ignition/cast(list/targets, mob/user = usr)
	. = ..()
	// Spell interaction with ignitable objects (burn wooden things, light torches up)
	if(isobj(targets[1]))
		var/obj/O = targets[1]
		if(O.fire_act())
			user.visible_message(span_astrata("[user] points at [O], igniting it with sacred flames!"))
			return TRUE
		else
			to_chat(user, span_warning("You point at [O], but it fails to catch fire."))
			return FALSE
	// Check if target is an undead mob
	if(ismob(targets[1]))
		var/mob/living/M = targets[1]
		if(M.mob_biotypes & MOB_UNDEAD)
			M.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/sunder)
			M.ignite_mob()
			user.visible_message(span_astratabig("[user] points at [M], igniting them with searing holy flames!"))
			return TRUE
	revert_cast()
	return FALSE

//============================================
// TIER 1 MIRACLES
//============================================

// Sacred Flame - Ranged holy fire beam that deals extra damage to undead
/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue
	name = "Sacred Flame"
	desc = "Launch a laser of holy fire at your target, setting them aflame. Deals increased damage to undead."
	overlay_state = "sacredflame"
	sound = 'sound/magic/bless.ogg'
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list()
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 50
	projectile_type = /obj/projectile/magic/astratablast

/obj/projectile/magic/astratablast
	damage = 25
	name = "ray of holy fire"
	nodamage = FALSE
	damage_type = BURN
	speed = 0.3
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	flag = "magic"
	light_color = "#a98107"
	light_outer_range = 7
	tracer_type = /obj/effect/projectile/tracer/solar_beam
	var/fuck_that_guy_multiplier = 2
	var/biotype_we_look_for = MOB_UNDEAD

/obj/projectile/magic/astratablast/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(M.mob_biotypes & biotype_we_look_for || istype(M, /mob/living/simple_animal/hostile/rogue/skeleton))
			damage *= fuck_that_guy_multiplier
			// Apply sunder firestacks to undead instead of regular fire
			M.adjust_fire_stacks(5, /datum/status_effect/fire_handler/fire_stacks/sunder)
			visible_message(span_warning("[target] erupts in searing holy flame upon being struck by [src]!"))
			M.ignite_mob()
		else
			M.adjust_fire_stacks(4) //2 pats to put it out
			visible_message(span_warning("[src] ignites [target]!"))
			M.ignite_mob()
	return FALSE

//============================================
// TIER 2 MIRACLES
//============================================

// Scorch - T2 weapon enhancement that adds pain and stress
/obj/effect/proc_holder/spell/self/scorch
	name = "Scorch"
	desc = "Enhance your weapon with divine fiery wrath. Your next strike will inflict great pain and terror upon your foe."
	overlay_state = "inflictpain"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("Feel Astrata's fiery wrath!")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/self/scorch/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/scorch, user.get_active_held_item())
	return TRUE

//============================================
// TIER 3 MIRACLES  
//============================================

// Sun's Shield - Fire resistance ability granted by ritual
/obj/effect/proc_holder/spell/self/suns_shield
	name = "Sun's Shield"
	desc = "Call upon Astrata's blessing to shield yourself and nearby divine followers from flame."
	overlay_state = "burning"
	recharge_time = 4 MINUTES
	invocations = list("By Her light, we are shielded!")
	invocation_type = "shout"
	sound = 'sound/magic/holyshield.ogg'

/obj/effect/proc_holder/spell/self/suns_shield/cast(list/targets, mob/living/user = usr)
	var/is_day = (GLOB.tod == "day")
	var/user_duration = is_day ? 2 MINUTES : 1 MINUTES
	var/ally_duration = user_duration / 2
	
	// Clear user's firestacks and extinguish them
	if(isliving(user))
		var/mob/living/L = user
		L.adjust_fire_stacks(-L.fire_stacks)
		var/datum/status_effect/fire_handler/fire_stacks/FS = L.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
		if(FS)
			FS.extinguish()
		
		// Extinguish all equipped clothing items
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			for(var/obj/item/I in H.get_equipped_items())
				I.extinguish()
	
	// Apply to user
	user.apply_status_effect(/datum/status_effect/buff/suns_shield, user_duration)
	to_chat(user, span_astratabig("Astrata's radiance flows through you, shielding you from flame!"))
	
	// Apply to nearby divine pantheon followers
	for(var/mob/living/carbon/target in view(3, get_turf(user)))
		if(target == user)
			continue
		if(!istype(target.patron, /datum/patron/divine))
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		
		target.apply_status_effect(/datum/status_effect/buff/suns_shield, ally_duration)
		to_chat(target, span_astrata("Astrata's blessing shields you from flame!"))
	
	return TRUE

// Anastasis - Revive a dead target or obliterate undead
/obj/effect/proc_holder/spell/invoked/revive
	name = "Anastasis"
	desc = "Call upon Her greatness to return lyfe to a dead target. Obliterates the undead."
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 160
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 80
	/// Amount of PQ gained for reviving people
	var/revive_pq = PQ_GAIN_REVIVE

/obj/effect/proc_holder/spell/invoked/revive/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		// Check for undead FIRST - obliterate them with holy light
		if(target.mob_biotypes & MOB_UNDEAD)
			// Range check - must be within 10 tiles and same z-level
			var/distance = get_dist(user, target)
			if(distance > 10)
				to_chat(user, span_danger("The undead is too far away! I must be closer to channel divine power to unmake them!"))
				revert_cast()
				return FALSE
			
			// Z-level check
			if(user.z != target.z)
				to_chat(user, span_danger("I must see the undead in front of me, not above or below!"))
				revert_cast()
				return FALSE
			
			// Check for powerful undead immunity (Vampire Lords and Liches)
			var/is_powerful_undead = FALSE
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				// Check for Vampire Lord (Methuselah generation)
				if(H.get_vampire_generation() >= GENERATION_METHUSELAH)
					is_powerful_undead = TRUE
				// Check for Lich
				if(HAS_TRAIT(H, TRAIT_COUNTERCOUNTERSPELL))
					is_powerful_undead = TRUE
					
			// Powerful undead resist unless caster is a Priest
			if(is_powerful_undead && !HAS_TRAIT(user, TRAIT_CHOSEN))
				to_chat(user, span_danger("This creature's unholy power is too great! Only an ordained Priest could unmake such a being!"))
				target.visible_message(span_astratabig("[target] resists the holy light bearing down on them, their ancient power deflecting the divine wrath!"))
				revert_cast()
				return FALSE
			
						// Range check for powerful undead - must be within 6 tiles
			if(is_powerful_undead)
				if(distance > 6)
					to_chat(user, span_danger("This ancient evil is too far away! I must be closer to channel enough divine power to unmake them!"))
					revert_cast()
					return FALSE

			// Start cinematic destruction sequence
			if(is_powerful_undead)
				to_chat(user, span_danger("You channel Astrata's might! [target] begins to burn with holy light!"))
				target.visible_message(span_astratabig("[target] is struck by astronomical holy light, their form beginning to burn with divine radiance!"))
			else
				to_chat(user, span_danger("[target] is caught in holy light!"))
				target.visible_message(span_astratabig("[target] begins to burn with holy light!"))
			
			user.say("Die before the Tyrant's Light!")
			
			// Call the cinematic destruction proc
			divine_destruction(target, is_powerful_undead)
			return TRUE
		// Block if excommunicated and caster is divine pantheon
		if(istype(user, /mob/living)) {
			var/mob/living/LU = user
			var/excomm_found = FALSE
			for(var/excomm_name in GLOB.excommunicated_players)
				var/clean_excomm = lowertext(trim(excomm_name))
				var/clean_target = lowertext(trim(target.real_name))
				if(clean_excomm == clean_target)
					excomm_found = TRUE
					break
			if(ispath(LU.patron?.type, /datum/patron/divine) && excomm_found) {
				to_chat(user, span_danger("The gods recoil from [target]! Divine fire scorches your hands as your plea is rejected!"))
				target.visible_message(span_danger("[target] is seared by divine wrath! The gods hate them!"))
				revert_cast()
				return FALSE
			}
		}
		var/mob/dead/observer/spirit = target.get_spirit()
		//GET OVER HERE!
		if(spirit)
			var/mob/dead/observer/ghost = spirit.ghostize()
			qdel(spirit)
			ghost.mind.transfer_to(target, TRUE)
		target.grab_ghost(force = FALSE)
		if(!target.check_revive(user))
			revert_cast()
			return FALSE
		if(GLOB.tod == "night")
			to_chat(user, span_astratabig("Let there be light."))
		for(var/obj/structure/fluff/psycross/S in oview(5, user))
			S.AOE_flash(user, range = 8)
		target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
		if(!target.revive(full_heal = FALSE))
			to_chat(user, span_warning("Nothing happens."))
			revert_cast()
			return FALSE
		testing("revived2")
		target.emote("breathgasp")
		target.Jitter(100)
		record_round_statistic(STATS_ASTRATA_REVIVALS)
		target.update_body()
		target.visible_message(span_astratabig("[target] is revived by holy light!"), span_green("I awake from the void."))
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		target.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/revive/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, span_warning("I need a holy cross."))
		return FALSE
	return TRUE



//============================================
// TIER 4 MIRACLES
//============================================

// Invoked Reverence - T4 pain/stress check that forces kneeling
/obj/effect/proc_holder/spell/invoked/invoked_reverence
	name = "Invoked Reverence"
	desc = "Channel divine majesty to inspire awe in the suffering. Those wracked with pain and terror will be moved to genuflect in Her presence."
	overlay_state = "createlight"
	releasedrain = 50
	chargedrain = 0
	chargetime = 2 SECONDS
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	invocations = list("WITNESS HER DIVINE RADIANCE!!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/invoked_reverence/cast(list/targets, mob/user = usr)
	if(!isliving(targets[1]))
		return FALSE
	
	var/mob/living/carbon/target = targets[1]
	
	// Get target's stress and pain
	var/target_stress = target.get_stress_amount()
	var/target_pain = 0
	
	if(iscarbon(target))
		// Get pain and convert to stress equivalent (100 pain = 1 stress)
		target_pain = target.get_complex_pain() / 100
	
	var/total_suffering = target_stress + target_pain
	
	// Visual effect
	target.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/divine_overlay = mutable_appearance('icons/effects/clan.dmi', "presence", -MUTATIONS_LAYER)
	divine_overlay.pixel_z = 1
	target.overlays_standing[MUTATIONS_LAYER] = divine_overlay
	target.apply_overlay(MUTATIONS_LAYER)
	
	// Check if target is not in combat mode and has low/no stress
	if(iscarbon(target) && total_suffering < 4)
		var/mob/living/carbon/C = target
		if(!C.cmode && target_stress <= 0)
			// Compare INT vs END
			var/caster_int = 0
			var/target_end = 0
			
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				caster_int = H.STAINT
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				target_end = H.STACON
			
			var/stat_difference = caster_int - target_end
			
			if(stat_difference >= 4)
				// Stage 2 effect from stats
				to_chat(target, span_astratabig("I cannot resist! My legs give out beneath me!"))
				target.visible_message(span_astrata("[target] is moved to kneel in reverent awe by [user]'s divine presence!"))
				target.Immobilize(5 SECONDS)
				target.set_resting(TRUE, TRUE)
				target.add_stress(/datum/stressevent/scorch)
				addtimer(CALLBACK(src, PROC_REF(remove_divine_overlay), target), 3 SECONDS)
				return TRUE
			else if(stat_difference >= 2)
				// Stage 1 effect from stats
				to_chat(target, span_astrata("The weight of divine majesty bears down on me!"))
				target.visible_message(span_warning("[user]'s invocation of reverence staggers [target]!"))
				target.Immobilize(3 SECONDS)
				target.add_stress(/datum/stressevent/scorch)
				addtimer(CALLBACK(src, PROC_REF(remove_divine_overlay), target), 3 SECONDS)
				return TRUE
	
	// Determine effect based on suffering threshold
	if(total_suffering < 4)
		// Not enough suffering - minor effect
		to_chat(target, span_userdanger("The divine presence washes over me, but I stand firm!"))
		target.visible_message(span_warning("[target] resists the invoked reverence!"))
		target.Immobilize(1 SECONDS)
	else if(total_suffering < 11)
		// Stage 1 - Hesitation and brief immobilization
		to_chat(target, span_astrata("The weight of divine majesty bears down on me!"))
		target.visible_message(span_warning("[user]'s invocation of reverence staggers [target]!"))
		target.Immobilize(3 SECONDS)
		target.add_stress(/datum/stressevent/scorch)  // Add more stress from being awed
	else if(total_suffering < 19)
		// Stage 2 - Forced to kneel
		to_chat(target, span_astratabig("I cannot resist! My legs give out beneath me!"))
		target.visible_message(span_astrata("[target] is moved to kneel in reverent awe by [user]'s divine presence!"))
		target.Immobilize(5 SECONDS)
		target.set_resting(TRUE, TRUE)
		target.add_stress(/datum/stressevent/scorch)
	else
		// Stage 3 - Severe kneeling with extended duration
		to_chat(target, span_astrataextreme("ASTRATA'S MAJESTY IS ABSOLUTE! I MUST GENUFLECT!"))
		target.visible_message(span_astratabig("[target] collapses before [user], overwhelmed by divine radiance!"))
		target.Immobilize(8 SECONDS)
		target.set_resting(TRUE, TRUE)
		target.AdjustKnockdown(20)  // Extra knockdown time
		target.add_stress(/datum/stressevent/scorch)
	
	// Remove overlay after a delay
	addtimer(CALLBACK(src, PROC_REF(remove_divine_overlay), target), 3 SECONDS)
	
	return TRUE


//============================================
// STATUS EFFECTS & SUPPORTING CODE
//============================================

//T0. Astratan Gaze Support Code
/atom/movable/screen/alert/status_effect/buff/astrata_gaze
	name = "Astratan's Gaze"
	desc = "She shines through me, illuminating all injustice."
	icon_state = "astrata_gaze"

/datum/status_effect/buff/astrata_gaze
	id = "astratagaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_gaze
	duration = 20 SECONDS

/datum/status_effect/buff/astrata_gaze/on_creation(mob/living/new_owner, slevel)
	var/per_bonus = 0
	duration = 20 SECONDS

	if(slevel > SKILL_LEVEL_NOVICE)
		per_bonus++

	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		per_bonus++
		duration *= 2

	duration *= slevel

	if(per_bonus)
		effectedstats = list(STATKEY_PER = per_bonus)

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()

	to_chat(owner, span_astrata("She shines through me! I can perceive all clear as dae!"))
	return ..()

/datum/status_effect/buff/astrata_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()

// =====================
// Immolation Component
// =====================
/datum/component/immolation
	var/mob/living/carbon/caster
	var/mob/living/carbon/partner
	var/duration = 360 SECONDS
	var/max_distance = 7
	var/self_damage
	var/base_damage
	var/damage_amplifier
	var/target_bonus = 0.75
	var/simple_mob_bonus = 2.5
	var/ispartner = FALSE
	var/immolate = FALSE
	can_transfer = TRUE
	var/damage_cooldown = 1 SECONDS // Damage applied every second
	var/next_damage = 0
	var/message_cooldown = 8 SECONDS
	var/next_message = 0

/datum/component/immolation/partner
	ispartner = TRUE
	immolate = TRUE

/datum/component/immolation/Initialize(mob/living/partner_mob, mob/living/carbon/caster_mob, var/holy_skill, var/is_astrata)
	if(!isliving(parent) || !iscarbon(partner_mob))
		return COMPONENT_INCOMPATIBLE

	// Prevent duplicate immolation
	if(parent.GetComponent(/datum/component/immolation))
		return COMPONENT_INCOMPATIBLE

	caster = caster_mob
	partner = partner_mob

	// Configure damage based on patron and skill
	base_damage = 8
	self_damage = 0.95
	damage_amplifier = 0.95

	if(holy_skill >= 3)
		self_damage -= 0.1 // 85%
		damage_amplifier += 0.15 // 110%
	if(is_astrata)
		self_damage -= 0.1 // 75%
		damage_amplifier += 0.15 // 125%

	// Set up processing and expiration
	START_PROCESSING(SSprocessing, src)
	RegisterSignal(parent, COMSIG_LIVING_MIRACLE_HEAL_APPLY, PROC_REF(on_heal))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))
	addtimer(CALLBACK(src, .proc/remove_immolation), duration)

	// Apply visual effect
	var/mob/living/L = parent
	if(parent == caster)
		L.apply_status_effect(/datum/status_effect/immolation, FALSE)
	else
		L.apply_status_effect(/datum/status_effect/immolation, TRUE)
	return ..()

/datum/component/immolation/proc/on_deletion()
	remove_immolation()

/datum/component/immolation/proc/on_heal()
	// Healing is removed.
	partner.remove_status_effect(/datum/status_effect/buff/healing)

/datum/component/immolation/process()
	if(!istype(partner) || !istype(caster) || partner.stat == DEAD || caster.stat != CONSCIOUS || get_dist(partner, caster) > max_distance)
		remove_immolation()
		return FALSE
	return TRUE

/datum/component/immolation/partner/process()
	if(!..()) // Parent handles removal checks
		return

	if(world.time < next_damage)
		return
	next_damage = world.time + damage_cooldown

	// Get all living mobs in 2 tiles range
	var/list/targets = list()
	for(var/mob/living/L in view(2, partner))
		if(L == partner || L == caster || L.stat == DEAD)
			continue
		targets += L

	var/num_targets = targets.len
	var/damage_modifier = damage_amplifier + (target_bonus * (num_targets - 1))
	var/total_damage = base_damage * damage_modifier
	var/damage_per_target = num_targets > 0 ? total_damage / num_targets : 0

	// Apply damage to targets
	for(var/mob/living/target in targets)
		// Apply to random limb for carbons
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/static/list/valid_limbs = list(
				BODY_ZONE_CHEST,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)

			// Get all existing limbs that are valid
			var/list/obj/item/bodypart/possible_limbs = list()
			for(var/zone in valid_limbs)
				var/obj/item/bodypart/BP = C.get_bodypart(zone)
				if(BP)
					possible_limbs += BP

			if(possible_limbs.len)
				// Select random limb
				var/obj/item/bodypart/BP = pick(possible_limbs)
				BP.receive_damage(damage_per_target)

				if(world.time > next_message)
					C.visible_message(span_danger("[C]'s [BP.name] is cut by holy flames!"))
					next_message = world.time + message_cooldown
				target.update_damage_overlays()

				// Dismember limb if damage exceeds max
				if(BP.brute_dam >= BP.max_damage)
					BP.dismember()
					C.visible_message(span_danger("[C]'s [BP.name] is dismembered violently by cutting flames!"))
		else
			// Simple brute damage for non-carbons
			target.adjustBruteLoss(damage_per_target * simple_mob_bonus)
			if(world.time > next_message)
				target.visible_message(span_danger("[target] is cut by holy flames!"))
				next_message = world.time + message_cooldown

	// Apply self-damage to caster
	if(num_targets > 0)
		partner.adjustBruteLoss(base_damage * self_damage)
	else
		partner.adjustBruteLoss(1) // Minimal damage when no targets

/datum/component/immolation/proc/remove_immolation()
	var/mob/living/L = parent
	if(L)
		L.remove_status_effect(/datum/status_effect/immolation)
		UnregisterSignal(L, list(
			COMSIG_LIVING_MIRACLE_HEAL_APPLY,
			COMSIG_PARENT_QDELETING
		))

	if(partner)
		partner.remove_status_effect(/datum/status_effect/immolation)
		var/datum/component/immolation/other = partner.GetComponent(/datum/component/immolation)
		if(other)
			other.partner = null
			qdel(other)

	partner = null
	STOP_PROCESSING(SSprocessing, src)
	qdel(src)

// =====================
// Immolation Spell
// =====================
/obj/effect/proc_holder/spell/invoked/immolation
	name = "Immolation"
	desc = "Ignite a target in holy flames, burning those that surround them. Fire burns brighter within devout Astratans."
	overlay_state = "immolation"
	range = 2
	chargetime = 0.5 SECONDS
	invocations = list("By sacred fire, be cleansed!")
	sound = 'sound/magic/fireball.ogg'
	recharge_time = 600 SECONDS
	miracle = TRUE
	devotion_cost = 60
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/immolation/cast(list/targets, mob/living/user)
	var/mob/living/carbon/target = targets[1]

	var/datum/component/immolation/existing = user.GetComponent(/datum/component/immolation)
	if(existing)
		to_chat(user, span_warning("You are already channeling someone"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	// Channeling requirement
	user.visible_message(span_danger("[user] begins lighting [target] ablaze with strange, divine fire!"))
	if(!do_after(user, 1 SECONDS, target = target))
		to_chat(user, span_warning("Astratan might requires unwavering focus to channel!"))
		revert_cast()
		return FALSE

	// Get caster properties
	var/holy_skill = target.get_skill_level(associated_skill)
	var/is_astrata = (istype(target.patron, /datum/patron/divine/astrata))

	// Apply component
	user.AddComponent(/datum/component/immolation, target, user, holy_skill, is_astrata)
	target.AddComponent(/datum/component/immolation/partner, target, user, holy_skill, is_astrata)

	// Visual feedback
	user.visible_message(span_notice("Holy flames erupt from [user]'s hands and engulf [target]!"))
	if(!is_astrata)
		target.visible_message(span_danger("[target] lights ablaze with sacred fire. Fire cutting like a blade in a small area around them."))
	else
		target.visible_message(span_danger("[target] lights ablaze with a grand, roaring pyre of divinity. Fire slashing violently like a blade in a small area around them."))
	return TRUE

// =====================
// Immolation Status Effect
// =====================
#define IMMOLATION_FILTER "immolation_glow"

/datum/status_effect/immolation
	id = "immolation"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/immolation
	var/outline_colour = "#FF4500"
	var/flaming_hot = FALSE

/atom/movable/screen/alert/status_effect/immolation
	name = "Immolated"
	desc = "Holy flames consume you! Anyone will be cut down for stepping near."
	icon_state = "immolation"

/datum/status_effect/immolation/on_creation(mob/living/new_owner, light_ablaze)
	flaming_hot = light_ablaze
	. = ..()
	if(!flaming_hot)
		linked_alert.desc = "I'm channeling Immolation onto someone to burn all those that step near, I must remain close to them."

/datum/status_effect/immolation/on_apply()
	if(!owner.get_filter(IMMOLATION_FILTER))
		owner.add_filter(IMMOLATION_FILTER, 2, list(
			"type" = "outline",
			"color" = outline_colour,
			"alpha" = 60,
			"size" = 2,
		))
	if(flaming_hot)
		new/obj/effect/dummy/lighting_obj/moblight/fire(owner)
		var/fire_icon = "Generic_mob_burning"
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		new_fire_overlay.color = list(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		new_fire_overlay.appearance_flags = RESET_COLOR
		owner.overlays_standing[FIRE_LAYER] = new_fire_overlay
		owner.apply_overlay(FIRE_LAYER)
	return TRUE

/datum/status_effect/immolation/on_remove()
	owner.remove_filter(IMMOLATION_FILTER)
	if(flaming_hot)
		for(var/obj/effect/dummy/lighting_obj/moblight/fire/F in owner)
			qdel(F)
			owner.remove_overlay(FIRE_LAYER)

#undef IMMOLATION_FILTER

//Choosing between Lance/Spear
/obj/effect/proc_holder/spell/self/astratan_path
	name = "Path of Order"
	overlay_state = "order"//Temp.
	desc = "Astrata blesses your mind, allowing you to choose <b>Her</b> method of bringing order."
	miracle = TRUE
	devotion_cost = 100
	recharge_time = 10 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/astratan_path/cast(list/targets, mob/user)
	. = ..()
	var/choice = alert(user, "YOUR MARTIAL ARM, M'LORD?", "TAKE UP STRENGTH", "Lance", "Spear")
	switch(choice)
		if("Lance")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue))//No stacking.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/astratan_spear))//No, thanks.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/self/astratan_spear)
		if("Spear")
			if(user.mind?.has_spell(/obj/effect/proc_holder/spell/self/astratan_spear))//No stacking. Again. As funny as a dozen of these were.
				revert_cast()
			else
				user.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/astratan_spear)
				if(user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue))//Nope.
					user.mind?.RemoveSpell(/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt/sacred_flame_rogue)
		else
			revert_cast()

//Summoning the spear.
/obj/effect/proc_holder/spell/self/astratan_spear
	name = "Summon Spear"
	overlay_state = "astra_spear"//Temp.
	desc = "An ancient miracle, honed by those who'd served as Astrata's martial arm in the second era. \
	With such, you may beseech Astrata for a mote of Her power."
	clothes_req = FALSE
	sound = 'sound/magic/blade_burst.ogg'
	invocations = list("Lady of Order, guide my hand!")
	invocation_type = "shout"
	recharge_time = 30 SECONDS
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 100//See below as to why. Slowdown and funny damage.
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/obj/item/rogueweapon/conjured_spear = null

/obj/effect/proc_holder/spell/self/astratan_spear/cast(list/targets, mob/living/user = usr)
	if(src.conjured_spear)
		qdel(conjured_spear)
	var/obj/item/rogueweapon/R = new /obj/item/rogueweapon/light_spear(user.drop_location())
	R.AddComponent(/datum/component/conjured_item)
	user.put_in_hands(R)
	src.conjured_spear = R
	return TRUE

//The spear itself. A summoned weapon you charge(throw for now) for an AoE effect.
/obj/item/rogueweapon/light_spear
	name = "lightning spear"
	desc = "A spear of light, pulled from Her domain. Throw far. Strike true."
	icon_state = "astratan_spear"//Martyr sword without the hilt, for now. Temp.
	icon = 'icons/roguetown/weapons/64.dmi'
	w_class = WEIGHT_CLASS_GIGANTIC
	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 2
	possible_item_intents = list(INTENT_GENERIC)
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	mob_throw_hit_sound = 'sound/magic/lightning.ogg'
	throwforce = 15//The damage does not typically come from the impact. This is here as a fallback.
	thrown_bclass = BCLASS_PIERCE//As above.
	thrown_damage_flag = "piercing"//Let it have some fun against boots, gloves, clothing, etc. C'mon...
	throw_speed = 2
	bigboy = 1
	var/step_delay = 10//Delay for the strike. Adjust sleep in the damage proc if changing.
	var/strike_damage = 25//Target damage. 25 on center, 19 on outer.

/obj/item/rogueweapon/light_spear/attack_self()
	qdel(src)

/obj/item/rogueweapon/light_spear/afterattack()
	qdel(src)

/obj/item/rogueweapon/light_spear/attack_hand()
	qdel(src)

/obj/item/rogueweapon/light_spear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	//Make it look worse than it is, initially. For show. As long as they don't stick around...
	if(iscarbon(hit_atom))
		var/mob/living/carbon/human/H = hit_atom
		H.electrocute_act(1, src, 1, SHOCK_NOSTUN)

	var/turf/centerpoint = get_turf(hit_atom)
	src.alpha = 0//Hide it on impact. Hee hoo.

	new /obj/effect/temp_visual/trap/thunderstrike(centerpoint)
	addtimer(CALLBACK(src, PROC_REF(astratan_spear_damage), centerpoint, 1), wait = step_delay)

	for(var/turf/effect_layer_one in range(1, centerpoint))
		if(!(effect_layer_one in view(centerpoint)))
			continue
		if(get_dist(centerpoint, effect_layer_one) != 1)
			continue
		new /obj/effect/temp_visual/trap/thunderstrike/layer_one(effect_layer_one)
		addtimer(CALLBACK(src, PROC_REF(astratan_spear_damage), effect_layer_one, 0.75), wait = step_delay)

	return TRUE

/obj/item/rogueweapon/light_spear/proc/astratan_spear_damage(var/turf/effect_layer, damage_mod)
	new /obj/effect/temp_visual/thunderstrike_actual(effect_layer)
	playsound(effect_layer, 'sound/magic/lightning.ogg', 50)
	for(var/mob/living/L in effect_layer.contents)
		if(L.mob_biotypes & MOB_UNDEAD)
			strike_damage += 15
		L.electrocute_act(strike_damage * damage_mod, src, 1, SHOCK_NOSTUN)
		L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 3 SECONDS)
	sleep(10)
	qdel(src)
//T2. Scorch Support Code
/datum/status_effect/scorch
	id = "scorch"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/scorch
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/scorch/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/scorch/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/scorch/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	
	// Get the bodypart that was hit
	var/obj/item/bodypart/affecting = living_target.get_bodypart(ran_zone(user.zone_selected))
	if(!affecting)
		affecting = living_target.get_bodypart(BODY_ZONE_CHEST)
	
	// Apply the Scorch wound - this only adds pain, no bleeding
	var/datum/wound/scorch/W = new()
	affecting.add_wound(W)
	
	// Estimate damage from the weapon for wound upgrade (pain calculation only)
	var/estimated_damage = 20  // Default
	if(istype(source, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/weapon = source
		estimated_damage = weapon.force
	
	W.upgrade(estimated_damage, 0)  // 0 armor for full pain effect
	
	// Add stress event
	living_target.add_stress(/datum/stressevent/scorch)
	
	living_target.visible_message(span_warning("Divine light erupts from [user]'s strike against [living_target]!"), \
		span_userdanger("Searing pain floods through me from [user]'s strike!"))
	
	qdel(src)

/datum/status_effect/scorch/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	
	// Get the bodypart that was hit
	var/obj/item/bodypart/affecting = H.get_bodypart(ran_zone(M.zone_selected))
	if(!affecting)
		affecting = H.get_bodypart(BODY_ZONE_CHEST)
	
	// Apply the wound (pain only)
	var/datum/wound/scorch/W = new()
	affecting.add_wound(W)
	W.upgrade(10, 0)  // Unarmed strike - less damage, less pain
	
	// Add stress event
	H.add_stress(/datum/stressevent/scorch)
	
	H.visible_message(span_warning("Divine light erupts from [M]'s strike against [H]!"), \
		span_userdanger("Searing pain floods through me from [M]'s strike!"))
	
	qdel(src)

/atom/movable/screen/alert/status_effect/buff/scorch
	name = "Scorch"
	desc = "My weapon glows with divine wrath. My next strike will bring pain and terror."
	icon_state = "strike"

//T3. Sun's shield Support Code
/datum/status_effect/buff/suns_shield
	id = "suns_shield"
	alert_type = /atom/movable/screen/alert/status_effect/buff/suns_shield
	effectedstats = null

/datum/status_effect/buff/suns_shield/on_creation(mob/living/new_owner, set_duration)
	if(set_duration)
		duration = set_duration
	return ..()
	
/datum/status_effect/buff/suns_shield/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOFIRE, "[type]")
	to_chat(owner, span_astrata("I am shielded from flame by Astrata's light!"))

/datum/status_effect/buff/suns_shield/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOFIRE, "[type]")
	to_chat(owner, span_warning("Astrata's flame shield fades."))

/atom/movable/screen/alert/status_effect/buff/suns_shield
	name = "Sun's Shield"
	desc = "Astrata's blessing shields me from flame."
	icon_state = "immolation"

//T3. Anastasis Support Code
/obj/effect/proc_holder/spell/invoked/revive/proc/divine_destruction(mob/living/target, is_powerful = FALSE)
	if(!target)
		return
	
	// Add increasingly bright glow filter
	target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 2, "color" = "#FFD70080"))
	
	// Prevent movement and actions - powerful undead get longer sequence
	var/destruction_time = is_powerful ? 90 SECONDS : 30 SECONDS
	target.Stun(destruction_time)
	
	// Make them immune to all damage during the destruction sequence
	target.status_flags |= GODMODE
	
	// Track timer IDs for potential calcification override in global list
	GLOB.divine_destruction_mobs[target] = list()
	
	// Register signal handler for calcification override
	RegisterSignal(target, COMSIG_LIVING_CALCIFICATION_OVERRIDE, PROC_REF(handle_calcification_override))
	
	// Message sequence - different timings based on power
	// 0 seconds - initial
	to_chat(target, span_astrataextreme("Astrata's light burns into my very being, I am being unmade!"))
	
	if(is_powerful)
		// Full 90 second sequence for powerful undead
		// 15 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 1), 15 SECONDS, TIMER_STOPPABLE)
		
		// 30 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 2), 30 SECONDS, TIMER_STOPPABLE)
		
		// 45 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 3), 45 SECONDS, TIMER_STOPPABLE)
		
		// 60 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 4), 60 SECONDS, TIMER_STOPPABLE)
		
		// 75 seconds - final goodbye
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 5), 75 SECONDS, TIMER_STOPPABLE)
		
		// 90 seconds - KABOOM
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_finale), target, is_powerful), 90 SECONDS, TIMER_STOPPABLE)
	else
		// 30 second sequence for normal undead
		// 10 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 1), 10 SECONDS, TIMER_STOPPABLE)
		
		// 20 seconds
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_message), target, 3), 20 SECONDS, TIMER_STOPPABLE)
		
		// 30 seconds - KABOOM
		GLOB.divine_destruction_mobs[target] += addtimer(CALLBACK(src, PROC_REF(divine_destruction_finale), target, is_powerful), 30 SECONDS, TIMER_STOPPABLE)

/obj/effect/proc_holder/spell/invoked/revive/proc/divine_destruction_message(mob/living/target, stage)
	if(!target || target.stat == DEAD)
		return
	
	// Check if calcification has overridden divine destruction
	if(!(target in GLOB.divine_destruction_mobs))
		return
	
	// Clean up old moblight if it exists
	var/obj/effect/dummy/lighting_obj/moblight/old_light = locate() in target
	if(old_light)
		qdel(old_light)
	
	switch(stage)
		if(1)
			to_chat(target, span_astrata("The light grows brighter! I can feel it searing through me!"))
			target.visible_message(span_astrata("[target] glows brighter with holy light, their form beginning to crack!"))
			target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 3, "color" = "#FFD700CC"))
			target.mob_light("#FFD700", 3, 1.5)
		if(2)
			to_chat(target, span_astrata("The radiance is overwhelming! My unholy essence is being torn apart!"))
			target.visible_message(span_astrata("[target] burns ever brighter, cracks of golden light spreading across their body!"))
			target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 4, "color" = "#FFD700FF"))
			target.mob_light("#FFD700", 4, 2)
		if(3)
			to_chat(target, span_astratabig("I CANNOT ESCAPE! THE LIGHT IS EVERYTHING!"))
			target.visible_message(span_astrata("[target] is now blazing with divine radiance, barely visible through the golden glow!"))
			target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 6, "color" = "#FFFFFF"))
			target.mob_light("#FFFFFF", 6, 2.5)
		if(4)
			to_chat(target, span_astratabig("MY FORM FRACTURES! I AM BEING UNMADE!"))
			target.visible_message(span_astrata("[target] is now a pillar of searing golden light!"))
			target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 8, "color" = "#FFFFFF"))
			target.mob_light("#FFFFFF", 8, 3)
		if(5)
			to_chat(target, span_astrataextreme("ASTRATA'S WRATH IS ABSOLUTE! I AM—"))
			target.visible_message(span_astratabig("[target]'s form is barely holding together, light pouring from every crack!"))
			target.add_filter("divine_glow", 1, list("type" = "outline", "size" = 10, "color" = "#FFFFFF"))
			target.mob_light("#FFFFFF", 10, 4)

/obj/effect/proc_holder/spell/invoked/revive/proc/divine_destruction_finale(mob/living/target, is_powerful = FALSE)
	if(!target)
		return
	
	// Check if calcification has overridden divine destruction
	if(!(target in GLOB.divine_destruction_mobs))
		return
	
	if(is_powerful)
		target.visible_message(span_astrataextreme("[target] ERUPTS in a catastrophic explosion of holy light!"))
	else
		target.visible_message(span_astratabig("[target] EXPLODES in a burst of divine radiance!"))
	
	playsound(get_turf(target), 'sound/misc/holyexplosion.ogg', 150, FALSE, 7)
	
	// Flash everyone nearby
	for(var/mob/M in viewers(target, 7))
		M.flash_fullscreen("whiteflash")
	
	// Remove filter and all moblights, then gib
	target.remove_filter("divine_glow")
	for(var/obj/effect/dummy/lighting_obj/moblight/L in target)
		qdel(L)
	
	// Clean up tracking variables
	GLOB.divine_destruction_mobs -= target
	
	// Unregister calcification signal
	UnregisterSignal(target, COMSIG_LIVING_CALCIFICATION_OVERRIDE)
	
	target.gib()

// Calcification Override for Divine Destruction
// FOR WHEN SKELETONS WANT TO BE EXTRA FUNNY
/obj/effect/proc_holder/spell/invoked/revive/proc/handle_calcification_override(mob/living/target)
	SIGNAL_HANDLER
	
	if(!target)
		return
	
	// Cancel all divine destruction timers
	if(target in GLOB.divine_destruction_mobs)
		for(var/timer_id in GLOB.divine_destruction_mobs[target])
			deltimer(timer_id)
		GLOB.divine_destruction_mobs -= target
	
	// Unregister the signal since we're handling it now
	UnregisterSignal(target, COMSIG_LIVING_CALCIFICATION_OVERRIDE)
	
	// Remove old filter and moblights
	target.remove_filter("divine_glow")
	for(var/obj/effect/dummy/lighting_obj/moblight/L in target)
		qdel(L)
	
	// Add RED calcification glow
	target.add_filter("calcification_glow", 1, list("type" = "outline", "size" = 8, "color" = "#FF0000"))
	target.mob_light("#FF0000", 10, 4)
	
	// Keep them stunned for the full 15 seconds
	target.Stun(15 SECONDS)
	
	// Give them booming voice (thaumaturgy effect) - max potency
	target.apply_status_effect(/datum/status_effect/thaumaturgy, 4)
	
	// Messages
	to_chat(target, span_big(span_userdanger("I REFUSE TO BE UNMADE! MY BONES WILL BECOME MY VENGEANCE!")))
	target.visible_message(span_big(span_danger("[target]'s holy light suddenly turns to BURNING RED as they begin to vibrate with terrible energy!")))
	
	// 15 second explosion sequence with messages
	// 5 seconds
	addtimer(CALLBACK(src, PROC_REF(calcification_message), target, 1), 5 SECONDS)
	
	// 10 seconds
	addtimer(CALLBACK(src, PROC_REF(calcification_message), target, 2), 10 SECONDS)
	
	// 14 seconds - cleanup
	addtimer(CALLBACK(src, PROC_REF(calcification_finale), target), 14 SECONDS)

/obj/effect/proc_holder/spell/invoked/revive/proc/calcification_message(mob/living/target, stage)
	if(!target || target.stat == DEAD)
		return
	
	switch(stage)
		if(1)
			to_chat(target, span_big(span_userdanger("THE CALCIFICATION INTENSIFIES! I FEEL MY BONES CRACKING WITH POWER!")))
			target.visible_message(span_big(span_danger("[target] glows even BRIGHTER with crimson energy, cracks spreading across their form!")))
			target.add_filter("calcification_glow", 1, list("type" = "outline", "size" = 12, "color" = "#FF0000"))
		if(2)
			to_chat(target, span_big(span_userdanger("WITNESS THE POWER OF UNDEATH! I AM BECOME DEATH!")))
			target.visible_message(span_big(span_danger("[target] is now a BLAZING PILLAR OF RED LIGHT!")))
			target.add_filter("calcification_glow", 1, list("type" = "outline", "size" = 15, "color" = "#FF0000"))

/obj/effect/proc_holder/spell/invoked/revive/proc/calcification_finale(mob/living/target)
	if(!target)
		return
	
	// Epic explosion message
	target.visible_message(span_big(span_userdanger("[target] DETONATES in a CATACLYSMIC EXPLOSION OF BONE AND FURY!")))
	
	// Remove filter and moblights
	target.remove_filter("calcification_glow")
	for(var/obj/effect/dummy/lighting_obj/moblight/L in target)
		qdel(L)
	
	// Clean up state
	GLOB.divine_destruction_mobs -= target

//T4. Invoked Reverence Support Code
/obj/effect/proc_holder/spell/invoked/invoked_reverence/proc/remove_divine_overlay(mob/living/target)
	if(target)
		target.remove_overlay(MUTATIONS_LAYER)
