/obj/effect/proc_holder/spell/invoked/seelie_dust
	name = "Seelie Dust"
	desc = "Blow a handful of magicked fae dust into your target's face, leaving them disorented for a while."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	releasedrain = 50
	recharge_time = 150 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/invoked/seelie_dust/cast(list/targets, mob/living/user)
	. = ..()
	user.emote("giggle")
	var/target = targets[1]
	if(isliving(target))
		var/obj/item/reagent_containers/powder/K = new /obj/item/reagent_containers/powder/SD(get_turf(target))
		K.reagents.trans_to(target, K.reagents.total_volume, transfered_by = user, method = "swallow")
		user.log_message("has drugged [key_name(target)] with Seelie dust", LOG_ATTACK)
		qdel(K)
	return TRUE

//Unfinished spells to be finished at a later date:
#if 0
/obj/effect/proc_holder/spell/targeted/static_room
	name = "Static"
	range = 12
	overlay_state = "necra"
	releasedrain = 30
	charge_max = 30 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation = "*laugh"
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/targeted/static_room/cast(list/targets, mob/user = usr)
	. = ..()
	for(var/mob/living/carbon/CA in targets)
		if(CA.has_status_effect(STATUS_EFFECT_STUN))
			for(CA in targets)
				if(CA.anti_magic_check())
					visible_message(span_warning("[src] fizzles on contact with [CA]!"))
					playsound(get_turf(CA), 'sound/magic/magic_nulled.ogg', 100)
					qdel(src)
					return BULLET_ACT_BLOCK
				if(isliving(CA))
					CA.electrocute_act(1, src)
				return TRUE
	return TRUE


//Because seelie glows constantly, this seemed unnecessary. May revisit if we can find a better execution
	
/obj/effect/proc_holder/spell/invoked/brighten
	name = "Light"
	overlay_state = "tamebeast"
	releasedrain = 30
	charge_max = 30 SECONDS
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/invoked/brighten/cast(list/targets, mob/user)
	. = ..()
	user.emote("giggle")
	var/target = targets[1]
	if(isliving(target) && !isseelie(target) && iscarbon(target))
		light(target)
		return TRUE

/obj/effect/proc_holder/spell/invoked/brighten/proc/light(mob/target)
	target.set_light(2, 1, 1, l_color = "#d4fcac")
	sleep(100)
	target.set_light(0)
#endif

/obj/effect/proc_holder/spell/invoked/summon_rat
	name = "Call Beast"
	desc = "Summon a small rodent to aid you."
	overlay_state = "dendor"
	releasedrain = 30
	recharge_time = 2 MINUTES
	range = 7
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/invoked/summon_rat/cast(list/targets, mob/user)
	. = ..()
	var/turf/T = get_turf(targets[1])
	user.emote("giggle")
	var/chance = rand(1,100)
	if(chance == 100)
		new /mob/living/simple_animal/hostile/retaliate/rogue/bigrat (T)
		user.log_message("has summoned a rous in an attempt to summon rat", LOG_GAME)
	else
		new /obj/item/reagent_containers/food/snacks/smallrat (T)
		user.log_message("has summoned a rat through the spell", LOG_GAME)
	return TRUE

/obj/effect/proc_holder/spell/invoked/strip
	name = "Strip Clothes"
	desc = "Enchant an object of clothing on your target, forcing it to remove itself."
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "slip"
	releasedrain = 80
	recharge_time = 6 MINUTES
	range = 1
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/invoked/strip/cast(list/targets, mob/user)
	. = ..()
	user.emote("giggle")
	var/mob/living/target = targets[1]
	if(iscarbon(target))
		var/obj/item/object = target.get_item_by_slot(pick(SLOT_GLOVES,SLOT_SHOES,SLOT_HEAD))
		if(!istype(object, /obj/item/clothing/head/roguetown/helmet))//Can't take helmets!	
			target.dropItemToGround(object)
		user.log_message("has stripped a piece of clothing from [key_name(target)] via spell", LOG_ATTACK)
		target.log_message("has had a piece of clothing stripped by [key_name(user)] via spell", LOG_ATTACK)
	return TRUE

/obj/effect/proc_holder/spell/invoked/drain_stam
	name = "Drain"
	overlay_state = "bloodsteal"
	releasedrain = 1
	recharge_time = 3 MINUTES
	range = 1
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout
	//random_target = TRUE
	//random_target_priority = TARGET_RANDOM
	cast_without_targets = TRUE

/obj/effect/proc_holder/spell/invoked/drain_stam/cast(list/targets, mob/user)
	. = ..()
	if(targets.len == 0)
		to_chat(user, span_warning("There is no one close enough to drain from!"))
	if(iscarbon(targets[1]))
		var/mob/living/target = targets[1]
		var/mob/living/carbon/human/caster = user
		if((target.energy > 100) && (caster.energy < (caster.max_energy - 60)) )
			to_chat(target, span_warning("I suddenly feel burdened and fatigued!"))
			to_chat(user, span_warning("I reinvigorate myself with [target]'s energy!"))
			user.log_message("has drained the stamina from [key_name(target)]", LOG_ATTACK)
			target.log_message("has had their stamina drained by [key_name(user)]", LOG_ATTACK)
			target.energy_add(-100)
			caster.energy_add(61)
			return TRUE
		else if(target.energy < 100)
			to_chat(user, span_warning("[target] is too exhausted to drain from!"))
			return FALSE
		else if(caster.energy >= (caster.max_energy - 60))
			to_chat(target, span_warning("I suddenly feel burdened and fatigued!"))
			to_chat(user, span_warning("I dont feel any more invigorated than I did..."))
			user.log_message("has drained the stamina from [key_name(target)]", LOG_ATTACK)
			target.log_message("has had their stamina drained by [key_name(user)]", LOG_ATTACK)
			target.energy_add(-100)
			return TRUE
		else
			to_chat(user, span_warning("I have no idea how I caused this to happen"))
			return FALSE
	else
		to_chat(user, span_warning("I cant drain energy from that!"))
	
	return FALSE
		

/obj/effect/proc_holder/spell/invoked/replenish
	name = "Replenish Nature"
	action_icon = 'icons/mob/actions/eoramiracles.dmi'
	overlay_state = "eorabed"
	releasedrain = 40
	recharge_time = 3 MINUTES
	range = 1
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/invoked/replenish/cast(list/targets, mob/user)
	. = ..()
	var/obj/structure/flora/roguegrass/bush/bushes = targets[1]
	if(isemptylist(bushes.looty))
		bushes.looty.Insert(1, pickweight(list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue=5,
						/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison=3,
						/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed=1)), /obj/item/natural/thorn, /obj/item/natural/fibers)
		to_chat(user, span_notice("The bush has been replenished"))
	else
		to_chat(user, span_notice("I can only replenish emptied bushes..."))
	return TRUE

/obj/effect/proc_holder/spell/targeted/roustame
	name = "Tame Rous"
	desc = "Calm a nearby Rous with magicked powder."
	range = 5
	overlay_state = "tamebeast"
	releasedrain = 30
	recharge_time = 3 MINUTES
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Feel my presence, and be calmed.")
	invocation_type = "whisper" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/targeted/roustame/cast(list/targets, mob/user = usr)
	. = ..()
	user.visible_message(span_green("[user] soothes the beast with Seelie dust."))
	var/tamed = FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/B in oview(2, user))
		if(!B.tame)
			B.tame = TRUE
			B.tamed()
			B.friends = list(user) //Makes the Rous not target the Seelie when on aggro
		B.enemies = list()
		B.aggressive = 0
		B.LoseTarget()
		if(B.ai_controller)
			B.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
			B.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
			B.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
			B.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
			B.ai_controller.CancelActions()
		tamed = B.tame
	user.log_message("has tamed a rous via the spell", LOG_GAME)
	return tamed

/obj/effect/proc_holder/spell/targeted/seelie_kiss
	name = "Regenerative Kiss"
	desc = "Blow a kiss at your target, forcing their body to mend itself at the cost of some nausea."
	overlay_state = "love"
	releasedrain = 0
	recharge_time = 4 MINUTES
	range = 1
	invocation_type = "none" //can be none, whisper, emote and shout

/obj/effect/proc_holder/spell/targeted/seelie_kiss/cast(list/targets, mob/user)
	. = ..()
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		var/obj/item/reagent_containers/powder/K = new /obj/item/reagent_containers/powder/SK(target.loc)
		K.reagents.trans_to(target, K.reagents.total_volume, transfered_by = user, method = "swallow")
		target.add_nausea(9)
		to_chat(target, span_notice("I suddenly feel reinvigorated!"))
		to_chat(user, span_notice("I have reinvigorated [target] with a kiss."))
		user.log_message("has blessed [key_name(target)] with a kiss spell, healing them a little", LOG_ATTACK)
		target.log_message("has been blessed by [key_name(user)] with a kiss spell, healing them a little", LOG_ATTACK)
		user.emote("kiss")
		qdel(K)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/projectile/splash
	name = "Water Splash"
	desc = "Fire forth a small bolt of water."
	overlay_state = "frost_bolt"
	range = 8
	projectile_type = /obj/projectile/magic/water
	releasedrain = 50
	chargedrain = 1
	chargetime = 5
	recharge_time = 3 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen

/obj/item/reagent_containers/powder/SK
	list_reagents = list(/datum/reagent/medicine/healthpot = 1, /datum/reagent/medicine/manapot = 1)

/obj/item/reagent_containers/powder/SD
	list_reagents = list(/datum/reagent/seelie_drugs = 10)

/obj/item/reagent_containers/glass/bucket/wooden/spell_water
	list_reagents = list(/datum/reagent/water = 40)
