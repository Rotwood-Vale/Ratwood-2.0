#define SEELIE_ACTION_ICON 'icons/mob/actions/seeliespells_keep.dmi'

/obj/effect/proc_holder/spell/invoked/seelie_dust
	name = "Seelie Dust"
	action_icon = SEELIE_ACTION_ICON
	overlay_state = "createlight"
	releasedrain = 50
	recharge_time = 150 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/seelie_dust/cast(list/targets, mob/living/user)
	. = ..()
	if(!length(targets) || !isliving(targets[1]))
		to_chat(user, span_warning("No valid target!"))
		return FALSE
	user.emote("giggle")
	var/mob/living/target = targets[1]
	target.apply_status_effect(/datum/status_effect/buff/seelie_drugs)
	target.adjustToxLoss(15)
	target.visible_message(span_danger("[user] dusts [target] with some kind of powder!"))
	user.log_message("has drugged [key_name(target)] with Seelie dust", LOG_ATTACK)
	return TRUE

/obj/effect/proc_holder/spell/invoked/summon_rat
	name = "Call Beast"
	action_icon = SEELIE_ACTION_ICON
	overlay_state = "dendor"
	releasedrain = 30
	recharge_time = 90 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none"

/obj/effect/proc_holder/spell/invoked/summon_rat/cast(list/targets, mob/user)
	. = ..()
	var/turf/T = length(targets) ? get_turf(targets[1]) : get_turf(user)
	if(!T)
		return FALSE
	user.emote("giggle")
	if(prob(1))
		new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat(T)
		user.log_message("has summoned a rous in an attempt to summon rat", LOG_GAME)
	else
		new /obj/item/reagent_containers/food/snacks/smallrat(T)
		user.log_message("has summoned a rat through the spell", LOG_GAME)
	return TRUE

/obj/effect/proc_holder/spell/targeted/roustame
	name = "Tame Rous"
	action_icon = SEELIE_ACTION_ICON
	range = 5
	overlay_state = "tamebeast"
	releasedrain = 30
	recharge_time = 1 MINUTES
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Feel my presence, and be calmed.")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/targeted/roustame/cast(list/targets, mob/user = usr)
	. = ..()
	user.visible_message(span_green("[user] soothes the beast with Seelie dust."))
	var/list/tamed_rouses = list()
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/B in targets)
		tamed_rouses += B
	// Fallback: keep close-range behavior for clickless casts when no explicit target is selected.
	if(!tamed_rouses.len)
		for(var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/B in oview(2, user))
			tamed_rouses += B
	if(!tamed_rouses.len)
		to_chat(user, span_warning("You must target a valid rous!"))
		return FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/B in tamed_rouses)
		if(!B.tame)
			B.tamed(user)
			B.faction += list("neutral")
		B.enemies = list()
		B.aggressive = FALSE
		B.LoseTarget()
		if(B.ai_controller)
			B.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			B.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			B.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
	user.log_message("has tamed [length(tamed_rouses)] rous via the spell", LOG_GAME)
	return TRUE

/obj/effect/proc_holder/spell/targeted/seelie_kiss
	name = "Regenerative Kiss"
	action_icon = SEELIE_ACTION_ICON
	overlay_state = "heal"
	releasedrain = 0
	recharge_time = 90 SECONDS
	range = 1
	invocation_type = "none"

/obj/effect/proc_holder/spell/targeted/seelie_kiss/cast(list/targets, mob/user)
	. = ..()
	if(!length(targets) || !iscarbon(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.adjustBruteLoss(-10)
	target.adjustFireLoss(-10)
	target.add_nausea(9)
	target.updatehealth()
	to_chat(target, span_notice("I suddenly feel reinvigorated!"))
	to_chat(user, span_notice("I have reinvigorated [target] with a kiss."))
	user.log_message("has blessed [key_name(target)] with a kiss spell, healing them a little", LOG_ATTACK)
	target.log_message("has been blessed by [key_name(user)] with a kiss spell, healing them a little", LOG_ATTACK)
	user.emote("kiss")
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/splash
	name = "Water Splash"
	action_icon = SEELIE_ACTION_ICON
	overlay_state = "bloodlightning"
	range = 8
	projectile_type = /obj/projectile/bullet/bolt/water
	releasedrain = 50
	chargedrain = 1
	chargetime = 5
	recharge_time = 35 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen

/obj/effect/proc_holder/spell/invoked/projectile/animate_object
	name = "Animate Object"
	action_icon = SEELIE_ACTION_ICON
	overlay_state = "bigpsy"
	sound = 'sound/magic/lightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/animate
	releasedrain = 55
	chargedrain = 1
	chargetime = 15
	recharge_time = 5 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/projectile/repel/seelie
	action_icon = SEELIE_ACTION_ICON

#undef SEELIE_ACTION_ICON
