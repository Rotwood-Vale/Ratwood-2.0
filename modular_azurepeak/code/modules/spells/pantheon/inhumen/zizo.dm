// T1: (fires a bone splinter at a target for brute and bleeding if you're not holding bones in your other hand, fires a significantly stronger bone lance if you are)

/obj/effect/proc_holder/spell/invoked/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	clothes_req = FALSE
	overlay_state = "profane"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Oblino!")
	invocation_type = "whisper"
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	hide_charge_effect = TRUE // Left handed magick babe

/obj/effect/proc_holder/spell/invoked/projectile/profane/miracle
	miracle = TRUE
	devotion_cost = 15
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/profane/fire_projectile(mob/living/user, atom/target)
	current_amount--

	var/obj/item/held_item = user.get_active_held_item()
	var/big_cast = FALSE
	if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if (bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/boney_bundle = held_item
		if (boney_bundle.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE

	var/obj/projectile/P = new projectile_type(user.loc)
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

	if (big_cast)
		user.visible_message(span_danger("[user] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl forth a vicious lance of profaned bone at [target]!"))
	else
		user.visible_message(span_danger("[user] directs forth a splinter of bone towards [target]!"), span_notice("I fling forth a shard of profaned bone at [target]!"))

	projectile_type = initial(projectile_type)

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	var/embed_prob = 10

/obj/projectile/magic/profane/major
	name = "profaned bone lance"
	damage = 35
	embed_prob = 30

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if (iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src] crumbles into dust..."))
	qdel(src)

// T2: just use lesser animate undead for now

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	miracle = TRUE
	devotion_cost = 75
	cabal_affine = TRUE
	to_spawn = 2

// T3: tames bio_type = undead mobs

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	miracle = TRUE
	devotion_cost = 100

// T3: Rituos (usable once per sleep cycle, allows you to choose any 1 arcane spell to use for the duration w/ an associated devotion cost. each time you change it, 1 of your limbs is skeletonized, if all of your limbs are skeletonized, you gain access to arcane magic. continuing to use rituos after being fully skeletonized gives you additional spellpoints). Gives you the MOB_UNDEAD flag (needed for skeletonize to work) on first use.

/obj/effect/proc_holder/spell/invoked/rituos
	name = "Rituos"
	desc = "Do a ritual for she of Z that skeletonises a part of your body and bestows upon you arcyne magycks until you next sleep. Once your whole body has become skeletonised you gain full access to the Arcyne, bolstering your knowledge of spells with each additional ritual."
	clothes_req = FALSE
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 2 MINUTES
	hide_charge_effect = TRUE
	/// List of limbs that don't get skeletonized. Chest has special handling once you are at that point
	var/static/list/excluded_bodyparts = list(/obj/item/bodypart/head, /obj/item/bodypart/chest)
	/// How many times Rituos has been casted
	var/rituos_counter = 0

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120
	associated_skill = /datum/skill/magic/holy

/// Checks if Rituos is complete or not. Requires that you have all 4 skeletonized limbs + 5 or more casts
/obj/effect/proc_holder/spell/invoked/rituos/proc/check_ritual_progress(mob/living/carbon/user)
	// Check the counter, you need 5+ completions to "finish" rituos
	if(rituos_counter < 5)
		return FALSE

	// Check the limbs, you need a full skeletonized body or else you can't succeed rituos
	for(var/obj/item/bodypart/skeletonized_limb in user.bodyparts)
		if(skeletonized_limb.type in excluded_bodyparts)
			continue
		if(!skeletonized_limb.skeletonized)
			return FALSE

	return TRUE

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/user)
	. = ..()
	if(!user || !user.mind)
		return FALSE

	if(user.mind.has_rituos)
		to_chat(user, span_warning("I have not the mental fortitude to enact the Lesser Work again. I must rest first..."))
		return FALSE

	// Find a bodypart to skeletonize
	var/list/potential_bodypart = list()
	for(var/obj/item/bodypart/limb as anything in user.bodyparts)
		if(limb.type in excluded_bodyparts)
			continue
		if(limb.skeletonized)
			continue
		potential_bodypart += limb

	if(!length(potential_bodypart) && rituos_counter < 4)
		to_chat(user, span_warning("I have no remaining limbs to offer to the ritual!"))
		return FALSE

	var/obj/item/bodypart/part_to_bonify
	if(rituos_counter == 4)
		part_to_bonify = locate(/obj/item/bodypart/chest) in user.bodyparts
	else
		part_to_bonify = pick(potential_bodypart)

	if(!part_to_bonify)
		to_chat(user, span_warning("I have no remaining limbs to offer to the ritual!"))
		return FALSE

	var/list/choices = list()
	var/list/spell_choices = GLOB.learnable_spells
	for(var/i = 1, i <= spell_choices.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = spell_choices[i]
		if(spell_item.spell_tier > 3) // Hardcap Rituos choice to T3 to avoid Court Mage spells access
			continue
		choices["[spell_item.name]"] = spell_item
	choices = sortList(choices)
	var/choice = input("Choose an arcyne expression of the Lesser Work") as null|anything in choices
	var/obj/effect/proc_holder/spell/item = choices[choice]

	if(!choice || !item)
		return FALSE

	if(!(user.mob_biotypes & MOB_UNDEAD))
		user.visible_message(span_warning("The pallor of the grave descends across [user]'s skin in a wave of arcyne energy..."), span_boldwarning("A deathly chill overtakes my body at my first culmination of the Lesser Work! I feel my heart slow down in my chest..."))
		user.mob_biotypes |= MOB_UNDEAD
		to_chat(user, span_smallred("I have forsaken the living. I am now closer to a deadite than a mortal... but I still yet draw breath and bleed."))

	part_to_bonify.skeletonize(FALSE)
	user.update_body_parts()
	user.visible_message(span_warning("Faint runes flare beneath [user]'s skin before [user.p_their()] flesh suddenly slides away from [user.p_their()] [part_to_bonify.name]!"), span_notice("I feel arcyne power surge throughout my frail mortal form, as the Rituos takes its terrible price from my [part_to_bonify.name]."))

	if(user.mind?.rituos_spell)
		to_chat(user, span_warning("My knowledge of [user.mind.rituos_spell.name] flees..."))
		user.mind.RemoveSpell(user.mind.rituos_spell)
		user.mind.rituos_spell = null

	user.mind.has_rituos = TRUE
	rituos_counter++

	var/post_rituos = check_ritual_progress(user)
	if(post_rituos)
		//everything but our head is skeletonized now, so grant them journeyman rank and 3 extra spellpoints to grief people with
		user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
		user.grant_language(/datum/language/undead)
		user.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		user.mind?.adjust_spellpoints(18)
		user.visible_message(span_boldwarning("[user]'s form swells with terrible power as they cast away almost all of the remnants of their mortal flesh, arcyne runes glowing upon their exposed bones..."), span_notice("I HAVE DONE IT! I HAVE COMPLETED HER LESSER WORK! I stand at the cusp of unspeakable power, but something is yet missing..."))
		ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
		ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
		ADD_TRAIT(user, TRAIT_ARCYNE_T3, "[type]")
		ADD_TRAIT(user, TRAIT_OVERTHERETIC, "[type]")
		if(prob(33))
			to_chat(user, span_small("...what have I done?"))
		user.mind?.RemoveSpell(src)
		return TRUE
	else
		to_chat(user, span_notice("The Lesser Work of Rituos floods my mind with stolen arcyne knowledge: I can now cast [item.name] until I next rest..."))
		user.mind.rituos_spell = item
		user.mind.AddSpell(new item)
		return TRUE


/obj/effect/proc_holder/spell/self/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Embrace the darkness!")
	invocation_type = "shout"
	sound = 'sound/magic/zizo_snuff.ogg'
	overlay_state = "rune2"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 30
	range = 2

/obj/effect/proc_holder/spell/self/zizo_snuff/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/checkrange = (range + user.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/obj/O in range(checkrange, user))
		O.extinguish()
	for(var/mob/M in range(checkrange, user))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE

// Heresiarch-exclusive: Perfect Reanimation. Anastasis but evil. Requires a heart and a zizocross structure to revive somebody.

/obj/effect/proc_holder/spell/invoked/evil_resurrect
	name = "Perfect Reanimation" //Wretch Heresiarch-exclusive variant of Anastasis
	desc = "Rip the target's soul out of Necra's grasp and revive them at a cost of a humanoid being's heart. The target's attributes will be temporarily reduced."
	overlay_state = "noc_revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 250
	var/revive_pq = PQ_GAIN_REVIVE
	var/required_structure = /obj/structure/fluff/psycross/zizocross
	var/required_items = list(/obj/item/organ/heart = 1)
	var/alt_required_items = list(/obj/item/organ/heart = 1)
	var/item_radius = 1
	var/debuff_type = /datum/status_effect/debuff/revived
	var/structure_range = 1

/obj/effect/proc_holder/spell/invoked/evil_resurrect/start_recharge()
	recharge_time = initial(recharge_time) * SSchimeric_tech.get_resurrection_multiplier()
	. = ..()

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/get_current_required_items()
	if(SSchimeric_tech.has_revival_cost_reduction() && length(alt_required_items))
		return alt_required_items
	return required_items

/obj/effect/proc_holder/spell/invoked/evil_resurrect/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]

		var/validation_result = validate_items(target)
		if(validation_result != "")
			to_chat(user, span_warning("[validation_result] on the floor next to or on top of [target]"))
			revert_cast()
			return FALSE

		var/found_structure = FALSE
		var/list/search_area = oview(structure_range, target)

		for(var/atom/A in search_area)
			// Check if the atom itself is the required structure type
			if(istype(A, required_structure))
				found_structure = TRUE
				break

			if(istype(A, /turf))
				var/turf/T = A
				for(var/obj/O in T.contents)
					if(istype(O, required_structure))
						found_structure = TRUE
						break // Found it in the turf, no need to check further
			if(found_structure)
				break

		if(!found_structure)
			var/atom/temp_structure = required_structure
			to_chat(user, span_warning("I need an unholy [initial(temp_structure.name)] near [target]."))
			revert_cast()
			return FALSE
		var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost.mind.transfer_to(target, TRUE)
		target.grab_ghost(force = TRUE)
		if(!target.check_revive(user))
			revert_cast()
			return FALSE
		if(target.mob_biotypes & MOB_UNDEAD) //no effect on undead
			to_chat(user, span_warning("[target] is undead. Nothing happens."))
			revert_cast()
			return FALSE
		target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
		if(!target.revive(full_heal = FALSE))
			to_chat(user, span_warning("Nothing happens."))
			revert_cast()
			return FALSE
		target.emote("agony")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] is reanimated by unholy magic!"), span_warning("My soul is snatched from Necra's grasp. Damnation continues."))
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		target.apply_status_effect(debuff_type)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		//Due to an increased cost and cooldown, these revival types heal quite a bit.
		target.apply_status_effect(/datum/status_effect/buff/healing, 14)
		consume_items(target)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/evil_resurrect/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		to_chat(user, span_warning("The miracle fizzles."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/validate_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	var/list/available_items = list()
	var/list/missing_items = list()

	// Scan for items in radius
	for(var/obj/item/I in range(item_radius, center))
		if(I.type in current_required_items)
			available_items[I.type] += 1

	// Check quantities and compile missing list
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]
		var/have = available_items[item_type] || 0

		if(have < needed) {
			var/obj/item/I = item_type
			var/amount_needed = needed - have
			missing_items += "[amount_needed] [initial(I.name)][amount_needed > 1 ? "s" : ""] "
		}

	if(length(missing_items))
		var/string = ""
		for(var/item in missing_items)
			string += item
		return "Missing components: [string]."
	return ""

/obj/effect/proc_holder/spell/invoked/evil_resurrect/proc/consume_items(atom/center)
	var/list/current_required_items = get_current_required_items()
	for(var/item_type in current_required_items)
		var/needed = current_required_items[item_type]

		for(var/obj/item/I in range(item_radius, center))
			if(needed <= 0)
				break
			if(I.type == item_type)
				needed--
				qdel(I)
