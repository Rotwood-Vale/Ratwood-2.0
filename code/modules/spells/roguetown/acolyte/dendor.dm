// Druid
/obj/effect/proc_holder/spell/targeted/blesscrop
	name = "Bless Crops"
	desc = "Bless a targeted soil plot or tree. Druidic Trickery increases stored charges. Revives dead plants, gives them nutrition and water if low & boosts their growth. Blessed seed powder can expend all charges to bless up to five nearby planted soils at once."
	range = 5
	selection_type = "range"
	overlay_state = "blesscrop"
	releasedrain = 15
	charge_type = "charges"
	recharge_time = 1
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 1
	cast_without_targets = FALSE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	invocations = list("The Treefather commands thee, be fruitful!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/max_bless_charges = 1
	var/charge_regen_elapsed = 0
	var/empty_refill_elapsed = 0
	var/empty_refill_active = FALSE
	var/active_sound = null
	/// Set TRUE after the first sync with a real user, so charges are topped up correctly at spawn.
	var/charges_initialized = FALSE

/obj/effect/proc_holder/spell/targeted/blesscrop/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/blesscrop/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		if(active_sound)
			user.playsound_local(user, active_sound, 100, vary = FALSE)
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return TRUE
	// Special case: targeting a lesser dryad triggers Dendor's Blessed Frenzy.
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser))
		if(!can_cast(caller))
			deactivate(caller)
			return TRUE
		var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad = target
		if(dryad.frenzy_timer)
			to_chat(caller, span_warning("The dryad's frenzy blessing has not yet subsided!"))
			return TRUE
		if(!charge_check(caller))
			return TRUE
		// Check whether the player is holding a bloomstone for a stronger frenzy.
		var/obj/item/act_item = caller.get_active_held_item()
		var/obj/item/inact_item = caller.get_inactive_held_item()
		var/bloomstone_boost = istype(act_item, /obj/item/alch/bloomstone) || istype(inact_item, /obj/item/alch/bloomstone)
		if(bloomstone_boost)
			var/obj/item/alch/bloomstone/bs = istype(act_item, /obj/item/alch/bloomstone) ? act_item : inact_item
			qdel(bs) // Consumes one charge (Destroy() decrements; stone survives until charges reach 0).
		dryad.apply_blessed_frenzy(bloomstone_boost)
		playsound(caller, sound, 100, TRUE)
		charge_counter--
		after_cast(list(target), caller)
		deactivate(caller)
		return TRUE
	if(ismob(target))
		to_chat(caller, span_warning("Bless Crops must be aimed at a tree, long log, or soil plot."))
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return TRUE
	if(perform(list(target), TRUE, user = ranged_ability_user))
		return TRUE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/Initialize(mapload)
	. = ..()
	charge_counter = 1
	max_bless_charges = 1

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/get_max_bless_charges(mob/user)
	if(!user)
		return max(1, max_bless_charges)
	return max(1, 1 + user.get_skill_level(associated_skill))

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/sync_bless_charges(mob/user)
	var/old_max = max_bless_charges
	max_bless_charges = get_max_bless_charges(user)
	if(!charges_initialized && user)
		// First sync with a real user — set charges to the skill-based maximum immediately.
		charges_initialized = TRUE
		charge_counter = max_bless_charges
	else if(!empty_refill_active)
		if(max_bless_charges > old_max)
			// Skill level increased — award the extra charges proportionally.
			charge_counter = min(charge_counter + (max_bless_charges - old_max), max_bless_charges)
		else
			charge_counter = clamp(charge_counter, 0, max_bless_charges)

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/start_empty_refill()
	if(empty_refill_active)
		return
	empty_refill_active = TRUE
	empty_refill_elapsed = 0
	charge_regen_elapsed = 0
	charge_counter = 0
	START_PROCESSING(SSfastprocess, src)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/spend_all_bless_charges()
	charge_counter = 0
	start_empty_refill()

/obj/effect/proc_holder/spell/targeted/blesscrop/charge_check(mob/user, silent = FALSE)
	if(!silent || charges_initialized)
		sync_bless_charges(user)
	if(empty_refill_active || charge_counter <= 0)
		if(!empty_refill_active)
			start_empty_refill()
		if(!silent)
			to_chat(user, span_warning("[name] is exhausted and must recover before it can be used again."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/start_recharge()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/process()
	if(empty_refill_active)
		empty_refill_elapsed += 2
		if(empty_refill_elapsed >= 30 SECONDS)
			empty_refill_active = FALSE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			charge_counter = max_bless_charges
			if(action)
				action.UpdateButtonIcon()
			STOP_PROCESSING(SSfastprocess, src)
		return
	if(charge_counter < max_bless_charges)
		charge_regen_elapsed += 2
		while(charge_regen_elapsed >= 10 SECONDS && charge_counter < max_bless_charges)
			charge_regen_elapsed -= 10 SECONDS
			charge_counter++
		if(action)
			action.UpdateButtonIcon()
		if(charge_counter >= max_bless_charges)
			charge_counter = max_bless_charges
			STOP_PROCESSING(SSfastprocess, src)
		return
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/after_cast(list/targets, mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	if(charge_counter <= 0)
		start_empty_refill()
	else
		empty_refill_active = FALSE
		empty_refill_elapsed = 0
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/revert_cast(mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	empty_refill_active = FALSE
	empty_refill_elapsed = 0
	if(charge_counter < max_bless_charges)
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/cast(list/targets,mob/user = usr)
	. = ..()
	var/atom/target_atom = targets?.len ? targets[1] : null
	var/turf/target_turf = get_turf(target_atom)
	sync_bless_charges(user)
	if(!target_turf)
		target_turf = get_turf(user)
	var/list/target_long_logs = list()
	for(var/obj/item/grown/log/tree/log in target_turf)
		if(log.type == /obj/item/grown/log/tree)
			target_long_logs += log
	var/obj/item/alch/blessedseedpowder/blessed_seed_powder = user.get_active_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = user.get_inactive_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = null
	// Also accept a Harvest Bloomstone as a one-charge powder substitute.
	var/obj/item/alch/bloomstone/held_bloomstone = null
	if(!blessed_seed_powder)
		var/obj/item/act_item = user.get_active_held_item()
		var/obj/item/inact_item = user.get_inactive_held_item()
		if(istype(act_item, /obj/item/alch/bloomstone))
			held_bloomstone = act_item
		else if(istype(inact_item, /obj/item/alch/bloomstone))
			held_bloomstone = inact_item
	// seed_source is either a blessed seed powder or a bloomstone acting as one.
	var/obj/item/seed_source = blessed_seed_powder || held_bloomstone
	// Detect a held bucket or mortar containing holy water for log blessing.
	var/obj/item/reagent_containers/water_container = null
	for(var/obj/item/held in list(user.get_active_held_item(), user.get_inactive_held_item()))
		if(held?.reagents && (istype(held, /obj/item/reagent_containers/glass/bucket) || istype(held, /obj/item/reagent_containers/glass/mortar)))
			if(held.reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 2)
				water_container = held
				break

	// Targeted long-log blessing: consume blessed seed powder + all holy water in held mortar/bucket,
	// and bless up to 6 long logs on the targeted tile.
	if(target_long_logs.len || istype(target_atom, /obj/item/grown/log/tree))
		if(istype(target_atom, /obj/item/grown/log/tree) && target_atom.type != /obj/item/grown/log/tree)
			to_chat(user, span_warning("Only long logs can be blessed by this rite."))
			return FALSE
		if(!target_long_logs.len)
			to_chat(user, span_warning("There are no large logs at that location to sanctify."))
			return FALSE
		if(!seed_source)
			to_chat(user, span_warning("I need blessed seed powder or a harvest bloomstone in-hand to sanctify logs."))
			return FALSE
		if(!water_container)
			to_chat(user, span_warning("I need a stone mortar or bucket with blessed water in-hand to sanctify logs."))
			return FALSE
		var/blessed_amt = water_container.reagents.get_reagent_amount(/datum/reagent/water/blessed)
		if(blessed_amt < 1)
			to_chat(user, span_warning("My container has no blessed water to fuel the blessing."))
			return FALSE
		var/blessed_logs = 0
		for(var/obj/item/grown/log/tree/log in target_long_logs)
			if(!log.bless_log())
				continue
			blessed_logs++
			if(blessed_logs >= 6)
				break
		if(blessed_logs <= 0)
			to_chat(user, span_warning("There are no unblessed long logs here to sanctify."))
			return FALSE
		water_container.reagents.remove_reagent(/datum/reagent/water/blessed, blessed_amt)
		qdel(seed_source)
		visible_message(span_green("[usr] sanctifies the long logs with Dendor's favor!"))
		return TRUE

	// Soil plots are now blessed one-by-one unless blessed seed powder is used to bypass it.
	var/obj/structure/soil/target_soil = null
	if(istype(target_atom, /obj/structure/soil))
		target_soil = target_atom
	else
		target_soil = locate(/obj/structure/soil) in target_turf
	if(target_soil)
		if(target_soil.blessed_time > 0 && !seed_source)
			to_chat(user, span_warning("That soil is already blessed. It can be blessed again in [DisplayTimeText(target_soil.blessed_time)]."))
			revert_cast(user)
			return FALSE
		if(seed_source)
			var/amount_blessed = 0
			for(var/obj/structure/soil/soil in range(4, user))
				if(!soil.plant)
					continue
				soil.bless_soil()
				amount_blessed++
				if(amount_blessed >= 5)
					break
			if(amount_blessed <= 0)
				to_chat(user, span_warning("There are no nearby planted soil plots for the powder to bless."))
				return FALSE
			qdel(seed_source)
			spend_all_bless_charges()
			visible_message(span_green("[usr] scatters blessed seed powder and Dendor's favor refreshes nearby crops!"))
			return TRUE
		target_soil.bless_soil()
		visible_message(span_green("[usr] blesses [target_soil] with Dendor's favor!"))
		return TRUE

	// Non-soil target mode: bless exactly what was targeted.
	// Evil trees are dense+opaque, so the click may land on the turf — check both.
	var/obj/structure/flora/roguetree/target_tree = null
	if(istype(target_atom, /obj/structure/flora/roguetree))
		target_tree = target_atom
	else
		target_tree = locate(/obj/structure/flora/roguetree) in target_turf
	if(target_tree)
		if(seed_source && get_dist(user, target_tree) > 1)
			to_chat(user, span_warning("I must be right next to the tree to convert it with Dendor's blessing."))
			return FALSE
		if(seed_source && target_tree.reinvigorate_tree(user))
			if(seed_source == user.get_active_held_item() || seed_source == user.get_inactive_held_item())
				qdel(seed_source)
			visible_message(span_green("[usr] invokes Dendor's favor upon [target_tree]."))
			return TRUE
		if(target_tree.bless_tree(user))
			visible_message(span_green("[usr] invokes Dendor's favor upon [target_tree]."))
			return TRUE
	if(istype(target_atom, /obj/structure/flora/newtree))
		var/obj/structure/flora/newtree/tree = target_atom
		if(tree.bless_tree(user))
			visible_message(span_green("[usr] invokes Dendor's favor upon [tree]."))
			return TRUE

	to_chat(user, span_warning("That target cannot receive this blessing."))
	return FALSE

//At some point, this spell should Awaken beasts, allowing a ghost to possess them. Not for this PR though.
/obj/effect/proc_holder/spell/targeted/beasttame
	name = "Tame Beast"
	desc = "Pacifies a targeted tameable beast with Dendor's blessing, permanently soothing its anger. Has 2 charges; each restores in 10 seconds, or 1 minute if both are spent."
	range = 5
	selection_type = "range"
	overlay_state = "tamebeast"
	releasedrain = 30
	charge_type = "charges"
	recharge_time = 1
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 1
	cast_without_targets = FALSE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Be still and calm, brotherbeast.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/beast_tameable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders")
	var/charge_regen_elapsed = 0
	var/empty_refill_elapsed = 0
	var/empty_refill_active = FALSE

/obj/effect/proc_holder/spell/targeted/beasttame/Initialize(mapload)
	. = ..()
	charge_counter = 2

/obj/effect/proc_holder/spell/targeted/beasttame/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/beasttame/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/beasttame/charge_check(mob/user, silent = FALSE)
	if(empty_refill_active || charge_counter <= 0)
		if(!empty_refill_active)
			empty_refill_active = TRUE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			START_PROCESSING(SSfastprocess, src)
		if(!silent)
			to_chat(user, span_warning("[name] is exhausted and must recover before it can be used again."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return TRUE
	if(!isliving(target))
		to_chat(caller, span_warning("Tame Beast must be aimed at a living beast."))
		return TRUE
	if(!istype(target, /mob/living/simple_animal))
		to_chat(caller, span_warning("This creature cannot be tamed."))
		return TRUE
	var/mob/living/simple_animal/animal = target
	if((animal.mob_biotypes & MOB_UNDEAD) || !faction_check(animal.faction, beast_tameable_factions))
		to_chat(caller, span_warning("This beast is not of a tameable kind."))
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return TRUE
	perform(list(target), TRUE, user = ranged_ability_user)
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/cast(list/targets, mob/user = usr)
	. = ..()
	var/mob/living/simple_animal/animal = targets?.len ? targets[1] : null
	if(!animal || QDELETED(animal))
		return FALSE
	visible_message(span_green("[user] soothes the beastblood with Dendor's whisper."))
	animal.tamed(TRUE)
	if(istype(animal, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/retaliate_animal = animal
		retaliate_animal.aggressive = FALSE
	if(animal.ai_controller)
		animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
		animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
	to_chat(user, span_green("With Dendor's blessing, you soothe [animal]'s anger."))
	return TRUE

/obj/effect/proc_holder/spell/targeted/beasttame/after_cast(list/targets, mob/user = usr)
	. = ..()
	if(charge_counter <= 0)
		empty_refill_active = TRUE
		empty_refill_elapsed = 0
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)
		deactivate(user)
	else
		empty_refill_active = FALSE
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)
		if(active)
			add_ranged_ability(user, null, TRUE)
	if(action)
		action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/beasttame/process()
	if(empty_refill_active)
		empty_refill_elapsed += 2
		if(empty_refill_elapsed >= 60 SECONDS)
			empty_refill_active = FALSE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			charge_counter = 2
			if(action)
				action.UpdateButtonIcon()
			STOP_PROCESSING(SSfastprocess, src)
		return
	if(charge_counter < 2)
		charge_regen_elapsed += 2
		while(charge_regen_elapsed >= 10 SECONDS && charge_counter < 2)
			charge_regen_elapsed -= 10 SECONDS
			charge_counter++
		if(action)
			action.UpdateButtonIcon()
		if(charge_counter >= 2)
			STOP_PROCESSING(SSfastprocess, src)
		return
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom
	name = "Fungal Illumination"
	desc = "Summons glowing mushrooms that shock people that try moving into them. Dendorites are immune."
	range = 1
	action_icon_state = "glowshroom"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	overlay_state = "blesscrop"
	releasedrain = 30
	recharge_time = 30 SECONDS
	chargetime = 1 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Treefather light the way.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	devotion_cost = 30

/obj/effect/proc_holder/spell/targeted/conjure_glowshroom/cast(list/targets, mob/user = usr)
	. = ..()

	to_chat(user, span_notice("I begin enriching the soil around me!"))
	if(!do_after(user, 0.5 SECONDS, progress = TRUE))
		revert_cast()
		return FALSE

	// Spawn a 3x1 line across the tile in front of the caster.
	var/turf/center_turf = get_step(user, user.dir)
	var/list/spawn_turfs = list(get_step(center_turf, turn(user.dir, 90)), center_turf, get_step(center_turf, turn(user.dir, -90)))
	for(var/turf/spawn_turf as anything in spawn_turfs)
		if(!istype(spawn_turf))
			continue
		if(!isclosedturf(spawn_turf) && !locate(/obj/structure/glowshroom) in spawn_turf)
			new /obj/structure/glowshroom(spawn_turf)
	return TRUE

/obj/effect/proc_holder/spell/targeted/conjure_vines
	name = "Vine Sprout"
	desc = "Summon vines nearby."
	overlay_state = "blesscrop"
	releasedrain = 90
	invocations = list("Treefather, bring forth vines.")
	invocation_type = "shout"
	devotion_cost = 30
	range = 1
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/items/dig_shovel.ogg'
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE

/obj/effect/proc_holder/spell/targeted/conjure_vines/cast(list/targets, mob/user = usr)
	. = ..()
	var/turf/target_turf = get_step(user, user.dir)
	var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
	var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
	if(!locate(/obj/structure/vine/dendor) in target_turf)
		new /obj/structure/vine/dendor(target_turf)
	if(!locate(/obj/structure/vine/dendor) in target_turf_two)
		new /obj/structure/vine/dendor(target_turf_two)
	if(!locate(/obj/structure/vine/dendor) in target_turf_three)
		new /obj/structure/vine/dendor(target_turf_three)

	return TRUE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon
	name = "Call of the Moon"
	desc = "Draw upon the the secrets of the hidden firmament to converse with the mooncursed."
	overlay_state = "howl"
	antimagic_allowed = FALSE
	recharge_time = 600
	ignore_cockblock = TRUE
	use_language = TRUE
	var/first_cast = FALSE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon/cast(mob/living/carbon/human/user)
	// only usable at night
	if (!GLOB.tod == "night")
		to_chat(user, span_warning("I must wait for the hidden moon to rise before I may call upon it."))
		revert_cast()
		return
	// if they don't have beast language somehow, give it to them
	if (!user.has_language(/datum/language/beast))
		user.grant_language(/datum/language/beast)
		to_chat(user, span_boldnotice("The vestige of the hidden moon high above reveals His truth: the knowledge of beast-tongue was in me all along."))

	if (!first_cast)
		to_chat(user, span_boldwarning("So it is murmured in the Earth and Air: the Call of the Moon is sacred, and to share knowledge gleaned from it with those not of Him is a SIN."))
		to_chat(user, span_boldwarning("Ware thee well, child of Dendor."))
		first_cast = TRUE
	. = ..()

/obj/effect/proc_holder/spell/invoked/spiderspeak
	name = "Spider Speak"
	desc = "Makes spiders not attack the target."
	overlay_state = "tamebeast"
	releasedrain = 15
	chargedrain = 0
	chargetime = 1 SECONDS
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/churn.ogg'
	invocations = list("Spiders of Psydonia, allow me to pass safely!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	recharge_time = 4 SECONDS
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/spiderspeak/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.visible_message("<font color='yellow'>[user] infuses [target] with swirling strands of spectral webs!</font>")
		target.visible_message("<font color='yellow'>You feel your tongue shift strangely, producing odd clicking noises.</font>")
		target.apply_status_effect(/datum/status_effect/buff/spider_speak)
		return TRUE
	revert_cast()
	return FALSE

// --- T4 Miracle: Sanctify Tree -----------------------------------------------
/obj/effect/proc_holder/spell/invoked/sanctify_tree
	name = "Sanctify Tree"
	desc = "Channel Dendor's most sacred blessing to consecrate a living, unburnt tree into a sanctified tree of the Treefather — a nexus of druidic power."
	invocation_type = "shout"
	overlay_state = "blesscrop"
	range = 1
	recharge_time = 60 SECONDS
	associated_skill = /datum/skill/magic/holy
	sound = 'sound/ambience/noises/mystical (4).ogg'
	invocations = list("Treefather, consecrate this living tree into your eternal embrace!")
	miracle = TRUE
	devotion_cost = 250

/obj/effect/proc_holder/spell/invoked/sanctify_tree/cast(list/targets, mob/living/user)
	. = ..()

	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return FALSE

	var/atom/target_atom = targets[1]
	var/obj/structure/flora/newtree/target = null

	// Use for-in-list idiom: the loop var gets the correct static type regardless of source type.
	for(var/obj/structure/flora/newtree/NT_target in list(target_atom))
		if(!NT_target.burnt)
			target = NT_target
		break  // only check the first (and only) element
	if(!target && target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
		for(var/obj/structure/flora/newtree/NT in target_atom.loc)
			if(!NT.burnt)
				target = NT
				break

	// If no living newtree found, search for an unsanctified wise tree to bless instead.
	var/obj/structure/flora/roguetree/wise/wise_target = null
	if(!target)
		for(var/obj/structure/flora/roguetree/wise/WT in list(target_atom))
			if(!istype(WT, /obj/structure/flora/roguetree/wise/sanctified))
				wise_target = WT
				break
		if(!wise_target && target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
			for(var/obj/structure/flora/roguetree/wise/WT in target_atom.loc)
				if(!istype(WT, /obj/structure/flora/roguetree/wise/sanctified))
					wise_target = WT
					break

	if(!target && !wise_target)
		to_chat(H, span_warning("I must target a living tree directly adjacent to me. Old trees, burnt trees, and already-sanctified trees cannot be consecrated."))
		return FALSE

	// For newtree consecration, block if a full sanctified tree (not sanctified_wise) is within 10 tiles.
	if(target)
		for(var/obj/structure/flora/roguetree/wise/sanctified/ST in range(10, target))
			if(istype(ST, /obj/structure/flora/roguetree/wise/sanctified/wise))
				continue  // sanctified wise trees do not block grove anchor placement
			to_chat(H, span_warning("A sanctified tree already stands nearby. The Treefather will not allow another grove anchor so close."))
			return FALSE

	var/atom/cast_target = target || wise_target
	H.visible_message(
		span_notice("[H] presses both hands to the bark of [cast_target] and begins a long, reverent invocation."),
		span_notice("I press my hands to the bark and channel the Treefather's blessing into the tree...")
	)

	if(!do_after(H, 10 SECONDS, target = cast_target))
		to_chat(H, span_warning("The consecration ritual was interrupted — the blessing fades & must be restarted."))
		return FALSE

	// ---- Newtree → full sanctified tree ----
	if(target)
		if(QDELETED(target) || target.burnt)
			to_chat(H, span_warning("The tree is no longer a valid target for sanctification."))
			return FALSE

		var/turf/T = get_turf(target)

		// Clean up branches and leaves from the old newtree.
		// Mirrors the wise tree conversion in create_wise_tree.dm.
		for(var/turf/adjacent in range(1, T))
			for(var/obj/structure/flora/newbranch/B in adjacent)
				qdel(B)
			for(var/obj/structure/flora/newleaf/L in adjacent)
				qdel(L)
		var/turf/above = get_step_multiz(T, UP)
		if(istype(above, /turf/open/transparent/openspace))
			for(var/obj/structure/flora/newtree/upper_tree in above)
				qdel(upper_tree)

		qdel(target)

		var/obj/structure/flora/roguetree/wise/sanctified/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H]'s hands blaze with golden light as [new_tree] is consecrated and transfigured into a sanctified tree of Dendor!"),
			span_notice("I feel the Treefather's power flow through me as [new_tree] is sanctified.")
		)
		SEND_SIGNAL(H, COMSIG_TREE_TRANSFORMED)
		if(H.mind)
			H.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
		return TRUE

	// ---- Wise tree → sanctified wise tree ----
	if(wise_target)
		if(QDELETED(wise_target) || istype(wise_target, /obj/structure/flora/roguetree/wise/sanctified))
			to_chat(H, span_warning("The sacred tree is no longer a valid target for blessing."))
			return FALSE

		var/turf/T = get_turf(wise_target)
		qdel(wise_target)

		var/obj/structure/flora/roguetree/wise/sanctified/wise/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H]'s hands blaze with golden light as [new_tree] is consecrated — the ancient tree is touched by the Treefather forever!"),
			span_notice("I feel the Treefather's power flow through me as the ancient tree is sanctified.")
		)
		SEND_SIGNAL(H, COMSIG_TREE_TRANSFORMED)
		if(H.mind)
			H.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
		return TRUE

	return FALSE

//==============================================================================
// Soulbind & dryad control spells (granted by Cat 7 soulbind ritual)
//==============================================================================

/// Summon (or unsummon) a lesser dryad bound to this player.
/// First cast: spawns the lesser dryad adjacent to the caster and tags it.
/// Second cast (if already summoned): qdels the dryad, returning it to the grove.
/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad
	name = "Summon Lesser Dryad"
	desc = "Call forth a lesser dryad from the grove to serve as your guardian. Cast again to send it back."
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 60
	recharge_time = 60 SECONDS
	chargetime = 1 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	associated_skill = /datum/skill/magic/holy
	invocations = list("Treefather, lend me your guardian.")
	invocation_type = "whisper"
	/// Reference to the currently summoned lesser dryad.
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/conjured_dryad = null
	/// TRUE while the player is intentionally unsummoning the dryad.
	var/manual_unsummon = FALSE
	/// Absolute world.time when summon is allowed again after dryad death.
	var/death_cooldown_until = 0

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/Destroy()
	if(conjured_dryad && !QDELETED(conjured_dryad))
		UnregisterSignal(conjured_dryad, COMSIG_QDELETING)
	conjured_dryad = null
	return ..()

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/cast(list/targets, mob/user = usr)
	// Swap invocation text so the caster says the right chant for summon vs unsummon.
	invocations = (conjured_dryad && !QDELETED(conjured_dryad)) \
		? list("My protector, I send thee back to the grove!") \
		: list("Treefather, lend me your guardian.")
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(world.time < death_cooldown_until)
		to_chat(H, span_warning("The bond to my soul-bound tree is unstable. I must wait [DisplayTimeText(death_cooldown_until - world.time)] before summoning another dryad."))
		revert_cast()
		return FALSE

	// If already summoned, unsummon
	if(conjured_dryad && !QDELETED(conjured_dryad))
		manual_unsummon = TRUE
		conjured_dryad.visible_message(span_boldwarning("[conjured_dryad] dissolves back into the grove."))
		qdel(conjured_dryad)
		manual_unsummon = FALSE
		conjured_dryad = null
		to_chat(H, span_notice("My dryad returns to the grove."))
		return TRUE

	// Summon the lesser dryad
	var/turf/spawn_turf = null
	for(var/D in GLOB.alldirs)
		var/turf/adj = get_step(get_turf(H), D)
		if(adj && !isclosedturf(adj))
			spawn_turf = adj
			break
	if(!spawn_turf)
		to_chat(H, span_warning("There is no room to summon the dryad here."))
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = new(spawn_turf, H)
	conjured_dryad = D
	D.summoner_spell = src
	// Immediately follow the summoner on spawn.
	D.follow_target = H
	// Register cleanup if the dryad dies on its own
	RegisterSignal(D, COMSIG_QDELETING, PROC_REF(on_dryad_deleted))
	to_chat(H, span_green("A lesser dryad emerges from the roots, answering my call."))
	D.visible_message(span_notice("[D] takes form beside [H]."))
	return TRUE

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/proc/on_dryad_deleted(datum/source)
	if(!manual_unsummon)
		death_cooldown_until = max(death_cooldown_until, world.time + 2 MINUTES)
	conjured_dryad = null
	UnregisterSignal(source, COMSIG_QDELETING)

/// Triggers the lesser dryad's surge by activating a targeting cursor and clicking a location.
/obj/effect/proc_holder/spell/targeted/lesser_dryad_special
	name = "Dryad Surge"
	desc = "Activate, then middle-click a turf or creature to command your lesser dryad to surge there with thorns and vines."
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	releasedrain = 50
	recharge_time = 1 MINUTES
	chargetime = 0 SECONDS
	max_targets = 1
	cast_without_targets = FALSE
	associated_skill = /datum/skill/magic/holy
	invocations = list("Tangle my enemies and sting their feet. Grove, arise!")
	invocation_type = "shout"
	range = 10

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/InterceptClickOn(mob/living/caller, params, atom/target)
	// Turfs are not intercepted by the parent targeted-spell logic; handle them directly.
	if(!isturf(target))
		. = ..()
		if(.)
			return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		deactivate(caller)
		return TRUE
	// Always normalise to the turf so surging onto an empty tile works.
	perform(list(get_turf(target) || target), TRUE, user = ranged_ability_user)
	deactivate(caller)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/cast(list/targets, mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/atom/target = targets?.len ? targets[1] : null
	if(!target)
		return FALSE
	var/mob/living/carbon/human/H = user

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in view(14, H))
		if(dryad.conjurer_ckey == H.ckey)
			D = dryad
			break
	if(!D)
		to_chat(H, span_warning("My dryad is not nearby."))
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf || isclosedturf(target_turf))
		to_chat(H, span_warning("The dryad cannot reach that location."))
		return FALSE

	if(D.ai_controller)
		D.ai_controller.CancelActions()
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
	// For old-style AI mobs, clear the enemies list, lose current target, and set
	// non-aggressive so the dryad doesn't re-acquire an enemy mid-transit.
	D.enemies = list()
	D.target = null
	D.LoseTarget()
	D.aggressive = FALSE
	D.Goto(target_turf, D.move_to_delay, 1)
	addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, H, 12), 0.5 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/proc/try_execute_surge(mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D, turf/target_turf, mob/living/carbon/human/user, attempts_left)
	if(QDELETED(D) || QDELETED(user) || !target_turf)
		return
	if(get_dist(D, target_turf) > 1)
		if(attempts_left <= 0)
			to_chat(user, span_warning("My dryad cannot reach the commanded target."))
			return
		D.Goto(target_turf, D.move_to_delay, 1)
		addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, user, attempts_left - 1), 0.5 SECONDS)
		return
	if(!D.dryad_surge(target_turf))
		to_chat(user, span_warning("My dryad's power has not yet recovered."))

/mob/living/proc/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/mob/living/carbon/human/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/// Minion order subtype for controlling the lesser dryad companion.
/// Uses the standard minion_order cast+click targeting (same as primordials):
/// cast and click yourself to follow, a tile to guard there, or an enemy to attack.
/// Overrides process_minions() to drive the dryad's old-style simple_animal AI vars
/// (follow_target / guard_turf / enemies / target) instead of ai_controller blackboard keys.
/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad
	name = "Order Dryad"
	desc = "Command your lesser dryad. Cast and click yourself to follow, a tile to guard there, or an enemy to attack."
	faction_ordering = FALSE

/obj/effect/proc_holder/spell/invoked/minion_order/lesser_dryad/process_minions(order_type, turf/target_location, mob/living/target, faction_tag)
	var/mob/living/carbon/human/caster = usr
	if(!caster?.mind)
		return
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in oview(order_range, caster))
		if(faction_tag in dryad.faction)
			D = dryad
			break
	if(!D)
		to_chat(caster, span_warning("No dryad is nearby to command."))
		return
	switch(order_type)
		if("goto")
			D.follow_target = null
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.guard_turf = target_location
			walk(D, 0)
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] moves to guard that position."))
		if("follow")
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.lastattacker_weakref = null
			D.ignore_owner_defense_until = world.time + 2 SECONDS
			D.follow_target = caster
			D.guard_turf = null
			D.aggressive = FALSE
			D.toggle_ai(AI_IDLE)
			walk_towards(D, caster, D.move_to_delay)
			if(!("neutral" in D.faction))
				D.faction += "neutral"
			to_chat(caster, span_notice("[D.name] will follow me."))
		if("attack")
			D.follow_target = null
			D.guard_turf = null
			walk(D, 0)
			D.enemies = list(target)
			D.target = target
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			D.toggle_ai(AI_ON)
			D.Goto(get_turf(target), D.move_to_delay, 0)
			to_chat(caster, span_notice("[D.name] charges at [target.name]!"))
		if("toggle_stance")
			// Clicking the dryad itself — toggle between follow and stand-ground.
			if("neutral" in D.faction)
				D.follow_target = null
				D.guard_turf = get_turf(D)
				D.faction -= "neutral"
				to_chat(caster, span_notice("[D.name] holds its ground."))
			else
				D.follow_target = caster
				D.guard_turf = null
				D.enemies = list()
				D.target = null
				D.LoseTarget()
				D.lastattacker_weakref = null
				D.ignore_owner_defense_until = world.time + 2 SECONDS
				D.toggle_ai(AI_IDLE)
				D.faction += "neutral"
				walk_towards(D, caster, D.move_to_delay)
				to_chat(caster, span_notice("[D.name] will follow me."))
		if("aggressive")
			// Clicking an ally — send dryad to their tile as a guard position.
			D.follow_target = null
			D.enemies = list()
			D.target = null
			D.LoseTarget()
			D.guard_turf = get_turf(target)
			walk(D, 0)
			D.aggressive = FALSE
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] moves toward [target.name]."))

//==============================================================================
// Conjure Floral Seed — granted by Cat 10 Floral Conjuration ritual.
// Instant-cast self spell. Prompts the caster to choose a bush or flower seed,
// then places a conjured copy in their hand. Conjured seeds vanish if dropped.
//==============================================================================
/obj/effect/proc_holder/spell/self/conjure_floral_seed
	name = "Conjure Floral Seed"
	desc = "Conjure a flower or bush seed into your hand using Dendor's power. Seeds dissolve if dropped. Flower seeds can be changed in-hand to subtypes. 30 second cooldown."
	overlay_state = "blesscrop"
	action_icon_state = "blessing"
	action_icon = 'icons/mob/actions/genericmiracles.dmi'
	chargetime = 0 SECONDS
	recharge_time = 20 SECONDS
	associated_skill = /datum/skill/magic/druidic
	invocations = list("From the deep soil, a fragile life springs! Treefather, grant me your seed.")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/self/conjure_floral_seed/cast(mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	var/list/options = list("Flower seeds", "Bush seed")
	var/choice = input(H, "Which seed do you conjure?", "Conjure Floral Seed") as null|anything in options
	if(isnull(choice) || QDELETED(H))
		return
	var/obj/item/seed
	if(choice == "Bush seed")
		seed = new /obj/item/seeds/bush/conjured(get_turf(H))
	else
		seed = new /obj/item/seeds/flower/conjured(get_turf(H))
	if(!H.put_in_hands(seed))
		// put_in_hands returns null/FALSE when both hands are full — seed lands at feet.
		to_chat(H, span_warning("My hands are full — the conjured seed falls to my feet and dissolves!"))
		// The conjured seed would qdel on Dropped, but it already spawned on floor:
		// force it away since Dropped() only fires on hand-drop, not on initial spawn.
		qdel(seed)
		return
	to_chat(H, span_notice("A [seed.name] materialises in my hand, thrumming with the Treefather's life."))

