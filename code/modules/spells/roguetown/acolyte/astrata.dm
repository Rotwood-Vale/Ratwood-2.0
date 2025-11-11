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
	if(alert(target, "They are calling for you. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
		target.visible_message(span_notice("Nothing happens. They are not being let go."))
		return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		revert_cast()
		return FALSE
	testing("revived2")
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	//GET OVER HERE!
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
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

/atom/movable/screen/alert/status_effect/buff/astrata_gaze
	name = "Astratan's Gaze"
	desc = "She shines through me, illuminating all injustice."
	icon_state = "astrata_gaze"

/datum/status_effect/buff/astrata_gaze
	id = "astratagaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/astrata_gaze
	duration = 20 SECONDS

/datum/status_effect/buff/astrata_gaze/on_apply(assocskill)
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()
	var/per_bonus = 0
	if(assocskill)
		if(assocskill > SKILL_LEVEL_NOVICE)
			per_bonus++
		duration *= assocskill
	if(GLOB.tod == "day" || GLOB.tod == "dawn")
		per_bonus++
		duration *= 2
	if(per_bonus > 0)
		effectedstats = list(STATKEY_PER = per_bonus)
	to_chat(owner, span_info("She shines through me! I can perceive all clear as dae!"))
	. = ..()

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
