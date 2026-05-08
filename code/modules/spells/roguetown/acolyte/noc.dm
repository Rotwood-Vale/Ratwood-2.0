// Noc Spells
// Blindness is a cancerous spells and should not be available to everyone.
// But I am not nuking it from Acolyte yet so it will be unavailable to mage.
// I repathed it to avoid it becoming available to mages again.
/obj/effect/proc_holder/spell/invoked/blindness
	name = "Blindness"
	desc = "Direct a mote of living darkness to temporarily blind another."
	overlay_state = "blindness"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	spell_tier = 2 // Combat spell
	invocations = list("Noc blinds thee of thy sins!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 15
	recharge_time = 15 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3

/obj/effect/proc_holder/spell/invoked/blindness/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[user] points at [target]'s eyes!"),span_warning("My eyes are covered in darkness!"))
		var/strength = min(user.get_skill_level(associated_skill) * 4, 4)
		target.blind_eyes(strength)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	overlay_state = "invisibility"
	desc = "Make another (or yourself) invisible for some time. Duration scales with the arcyne skill. Casting, attacking or being attacked will cancel the duration."
	releasedrain = 30
	chargedrain = 5
	chargetime = 5
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	spell_tier = 1
	invocation_type = "none"
	sound = 'sound/misc/fade.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	cost = 3 // Very useful

/obj/effect/proc_holder/spell/invoked/invisibility/miracle
	miracle = TRUE
	desc = "Make another (or yourself) invisible for some time. Duration scales with the holy skill. Casting, attacking or being attacked will cancel the duration."
	devotion_cost = 25
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur = max((5 * (user.get_skill_level(associated_skill))), 5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), 15 SECONDS)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/self/noc_spell_bundle
	name = "Arcyne Affinity"
	desc = "Allows you to learn a spell or two of a certain type once every cycle."
	miracle = TRUE
	devotion_cost = 200
	recharge_time = 50 MINUTES
	chargetime = 0
	chargedrain = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/chosen_bundle
	var/list/utility_bundle = list(	//Utility means exactly that. Nothing offensive and nothing that can affect another person negatively. (Barring Fetch)
		/obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/leap,
		/obj/effect/proc_holder/spell/invoked/mending,
		/obj/effect/proc_holder/spell/invoked/projectile/fetch,
		/obj/effect/proc_holder/spell/invoked/blink,
	)
	var/list/offensive_bundle = list(	//This is not meant to make them combat-capable. A weak offensive, and mostly defensive option.
		/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt, // PLACEHOLDER
		/obj/effect/proc_holder/spell/self/conjure_armor/miracle,
		/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle,
	)
	var/list/buff_bundle = list(	//Buffs! An Acolyte being a supportive caster is 100% what they already are, so this fits neatly. No debuffs -- every patron already has a plethora of those.
		/obj/effect/proc_holder/spell/invoked/hawks_eyes::name 			= /obj/effect/proc_holder/spell/invoked/hawks_eyes,
		/obj/effect/proc_holder/spell/invoked/giants_strength::name 	= /obj/effect/proc_holder/spell/invoked/giants_strength,
		/obj/effect/proc_holder/spell/invoked/longstrider::name 		= /obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/guidance::name 			= /obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/haste::name 				= /obj/effect/proc_holder/spell/invoked/haste,
		/obj/effect/proc_holder/spell/invoked/stoneskin::name 			= /obj/effect/proc_holder/spell/invoked/stoneskin,
		/obj/effect/proc_holder/spell/invoked/fortitude::name 			= /obj/effect/proc_holder/spell/invoked/fortitude, // Picking the most expensive options adds up to 12 points
	)

/obj/effect/proc_holder/spell/self/noc_spell_bundle/cast(list/targets, mob/user)
	if(!..())
		return FALSE
	if(!user || !user.mind)
		revert_cast()
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choice = alert(user, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Utility", "Offense", "Buffs")
		if(!choice)
			revert_cast()
			return FALSE
		chosen_bundle = choice
	switch(choice)
		if("Utility")
			if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
				var/secular_diagnose = new /obj/effect/proc_holder/spell/invoked/diagnose/secular
				user.mind?.AddSpell(secular_diagnose)
			add_spells(user, utility_bundle, grant_all = TRUE)
		if("Offense")
			add_spells(user, offensive_bundle, grant_all = TRUE)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		if("Buffs")
			add_spells(user, buff_bundle, choice_count = 4)
			ADD_TRAIT(user, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		else
			revert_cast()
			return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/noc_spell_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	if(!user || !user.mind || !islist(spells))
		return
	var/list/available = spells.Copy()
	for(var/spell_type in available)
		var/spell_path = available[spell_type]
		if(!spell_path)
			spell_path = spell_type
		if(!ispath(spell_path, /obj/effect/proc_holder/spell))
			available.Remove(spell_type)
			continue
		if(user.mind.has_spell(spell_path))
			available.Remove(spell_type)
	if(!available.len)
		return
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			if(!available.len)
				break
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in available
			if(isnull(choice))
				break
			var/picked_spell = available[choice]
			if(ispath(picked_spell, /obj/effect/proc_holder/spell) && !user.mind.has_spell(picked_spell))
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user.mind.AddSpell(new_spell)
			choice_count_visual--
			available.Remove(choice)
	else
		for(var/spell_type in available)
			var/spell_path = available[spell_type]
			if(!spell_path)
				spell_path = spell_type
			if(ispath(spell_path, /obj/effect/proc_holder/spell) && !user.mind.has_spell(spell_path))
				var/obj/effect/proc_holder/spell/new_spell = new spell_path
				user.mind.AddSpell(new_spell)

//15 PER peer-ahead.
/obj/effect/proc_holder/spell/invoked/noc_sight
	name = "Noc's Gaze"
	overlay_state = "noc_sight"
	desc = "Peer ahead."
	chargetime = 0
	chargedrain = 0
	clothes_req = FALSE
	recharge_time = 5 SECONDS
	devotion_cost = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("Noc guide my gaze.")
	invocation_type = "whisper"
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	miracle = TRUE


//Identical to peering ahead as if you had 15 PER. (the max)
/obj/effect/proc_holder/spell/invoked/noc_sight/cast(list/targets, mob/user)
	if(isturf(targets[1]) && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/turf/T = targets[1]
		var/_x = T.x-H.loc.x
		var/_y = T.y-H.loc.y
		var/ttime = 6
		var/dist = get_dist(H, T)
		if(dist > 7 || dist  <= 2)
			return
		H.hide_cone()
		var/offset = 5
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
		animate(H.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
		H.update_cone_show()
		return TRUE
	revert_cast()
	return FALSE
