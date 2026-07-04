/// Hag curio tracker component - handles boons, curses, crafting stockpiles, and death/revive flow
/datum/component/hag_curio_tracker
	/// The world.time when the Hag was last resurrected by a heart.
	var/last_revive_time = -5 MINUTES
	/// Associated hag antagonist datum
	var/datum/antagonist/hag/hag_ref
	/// Associative list: [True Name String] = [/datum/hag_boon]
	var/alist/boon_registry = list()
	/// Materials the hag currently has stored in their component.
	var/list/stored_materials = list()
	/// How many of each type of material hags can store, and which ones they can store
	var/static/list/material_limits = list(
		/obj/item/alch/hag_moss/sorrow = 5,
		/obj/item/alch/hag_moss/fury = 5,
		/obj/item/alch/hag_moss/mercy = 5,
		/obj/item/alch/hag_moss/grief = 5,
		/obj/item/alch/hag_moss/envy = 5,
		/obj/item/alch/hag_moss/lullaby = 5,
		/obj/item/alch/hag_moss/pride = 5,
		/obj/item/roguekey/hag = 1,
		/obj/item/leechtick = 3,
		/obj/item/leechtick_bloated = 3,
	)
	var/hag_tier = 1
	var/static/list/curse_registry = list(
		/datum/hag_boon/curse/rotting_touch = list("cost" = 1, "min_tier" = 1),
		/datum/hag_boon/buff/curse/choking_moss = list("cost" = 40, "min_tier" = 1),
		/datum/hag_boon/buff/curse/waterlogged = list("cost" = 25, "min_tier" = 1),
		/datum/hag_boon/buff/curse/slumber = list("cost" = 20, "min_tier" = 1),
		/datum/hag_boon/trait/curse/ugly = list("cost" = 10, "min_tier" = 1),
		/datum/hag_boon/trait/curse/silver_weakness = list("cost" = 50, "min_tier" = 1),
		/datum/hag_boon/trait/curse/no_run = list("cost" = 60, "min_tier" = 2),
		/datum/hag_boon/trait/curse/critical_weakness = list("cost" = 75, "min_tier" = 2),
		/datum/hag_boon/trait/curse/no_spells = list("cost" = 100, "min_tier" = 3),
		/datum/hag_boon/trait/curse/mute = list("cost" = 100, "min_tier" = 3),
		/datum/hag_boon/trait/curse/no_defense = list("cost" = 100, "min_tier" = 3)
	)
	/// List of boon paths the hag has pre-prepared: [boon_path] = quantity
	var/list/prepared_boons = list()

/datum/component/hag_curio_tracker/Initialize(datum/antagonist/hag/hag_datum)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	hag_ref = hag_datum
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(handle_death))

/datum/component/hag_curio_tracker/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_LIVING_DEATH)
	return ..()

/datum/component/hag_curio_tracker/proc/grant_boon(true_name, boon_path = /datum/hag_boon, set_points)
	if(!true_name || !ispath(boon_path))
		return

	if(boon_registry[true_name])
		var/list/existing_boons = boon_registry[true_name]
		for(var/datum/hag_boon/existing in existing_boons)
			if(existing.type == boon_path)
				return
	else
		boon_registry[true_name] = list()
		var/mob/living/hag_mob = parent
		var/mob/living/victim = find_target(true_name)
		if(hag_mob && hag_mob.mind && victim)
			hag_mob.mind.i_know_person(victim)

	var/datum/hag_boon/B = new boon_path(true_name, src, set_points)
	var/list/name_list = boon_registry[true_name]
	name_list += B
	return B

/datum/component/hag_curio_tracker/proc/find_boon_by_type(true_name, typepath)
	if(!boon_registry[true_name])
		return null
	var/list/B_list = boon_registry[true_name]
	for(var/datum/hag_boon/B in B_list)
		if(istype(B, typepath))
			return B
	return null

/datum/component/hag_curio_tracker/proc/remove_boon_instance(datum/hag_boon/B)
	if(!B || !B.true_name)
		return FALSE

	var/list/name_list = boon_registry[B.true_name]
	if(!name_list || !(B in name_list))
		return FALSE

	name_list -= B
	qdel(B)
	if(!length(name_list))
		boon_registry -= B.true_name
	return TRUE

/datum/component/hag_curio_tracker/proc/remove_boon_by_type(true_name, typepath)
	var/datum/hag_boon/B = find_boon_by_type(true_name, typepath)
	if(!B)
		return FALSE
	return remove_boon_instance(B)

/datum/component/hag_curio_tracker/proc/receive_enchanted_item(mob/living/receiver, points = 1)
	if(!receiver)
		return FALSE
	var/t_name = receiver.real_name

	var/datum/hag_boon/item_debt/existing_debt = find_boon_by_type(t_name, /datum/hag_boon/item_debt)
	if(existing_debt)
		existing_debt.add_points(points)
		to_chat(parent, span_notice("The debt of [t_name] deepens. Their material pact now holds [existing_debt.points] points of power."))
	else
		var/datum/hag_boon/item_debt/D = grant_boon(t_name, /datum/hag_boon/item_debt)
		if(D)
			D.add_points(points)
			to_chat(parent, span_notice("[t_name] has accepted your gift, unwittingly binding their name to a debt of [points] points."))
	return TRUE

/datum/component/hag_curio_tracker/proc/get_limit(obj/item/I)
	for(var/path in material_limits)
		if(istype(I, path))
			return material_limits[path]
	return 0

/datum/component/hag_curio_tracker/proc/absorb_item(obj/item/I)
	var/limit = get_limit(I)
	if(!limit)
		return FALSE

	var/current = stored_materials[I.type] || 0
	if(current >= limit)
		return FALSE

	stored_materials[I.type] = current + 1
	qdel(I)
	return TRUE

/datum/component/hag_curio_tracker/proc/dump_materials(turf/T)
	if(!length(stored_materials))
		return FALSE

	var/total_dumped = 0
	var/max_dump = 10

	for(var/path in stored_materials)
		while(stored_materials[path] > 0 && total_dumped < max_dump)
			new path(T)
			stored_materials[path]--
			total_dumped++

		if(total_dumped >= max_dump)
			break

	return total_dumped > 0

/datum/component/hag_curio_tracker/proc/get_available_curses_data()
	var/list/data = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		if(details["min_tier"] > hag_tier)
			continue
		data += list(list(
			"name" = initial(path:name),
			"path" = "[path]",
			"cost" = details["cost"],
			"min_tier" = details["min_tier"]
		))
	return data

/datum/component/hag_curio_tracker/proc/transmute_boons_to_curse(true_name, list/boons, curse_path, points)
	if(!true_name || !ispath(curse_path, /datum/hag_boon) || !length(boons))
		return FALSE
	var/datum/hag_boon/curse_template = curse_path
	if(!initial(curse_template.hag_curse))
		return FALSE
	var/list/curse_details = curse_registry[curse_path]
	if(!islist(curse_details) || curse_details["min_tier"] > hag_tier)
		return FALSE
	if(find_boon_by_type(true_name, curse_path))
		return FALSE

	var/list/eligible_boons = list()
	for(var/datum/hag_boon/B in boons)
		if(B && B.true_name == true_name && B.transmutable && !B.hag_curse)
			eligible_boons += B
	if(!length(eligible_boons))
		return FALSE

	for(var/datum/hag_boon/B in eligible_boons)
		remove_boon_instance(B)

	if(!boon_registry[true_name])
		boon_registry[true_name] = list()
	var/list/name_list = boon_registry[true_name]

	var/datum/hag_boon/curse/C = new curse_path(true_name, src, points)
	name_list += C

	var/datum/hag_boon/curse_scar/scar = find_boon_by_type(true_name, /datum/hag_boon/curse_scar)
	if(scar)
		scar.points += points
	else
		var/mob/living/victim = find_target(true_name)
		if(victim)
			ADD_TRAIT(victim, TRAIT_CURSE_SCAR, "hag_curse")
		scar = new /datum/hag_boon/curse_scar(true_name, src, points)
		name_list += scar
	check_tier_upgrade()
	return TRUE

/datum/component/hag_curio_tracker/proc/check_tier_upgrade()
	var/scar_60_count = 0
	var/has_scar_20 = FALSE

	for(var/t_name in boon_registry)
		var/datum/hag_boon/curse_scar/S = find_boon_by_type(t_name, /datum/hag_boon/curse_scar)
		if(!S)
			continue
		if(S.points >= 60)
			scar_60_count++
		if(S.points >= 20)
			has_scar_20 = TRUE

	if(hag_tier == 1 && has_scar_20)
		hag_tier = 2
		to_chat(parent, span_boldnotice("Your connection to the Mossmother's roots deepens. You have reached Tier 2."))

	if(hag_tier == 2 && scar_60_count >= 2)
		hag_tier = 3
		to_chat(parent, span_boldnotice("The Mossmother sees you. You have reached Tier 3."))

/datum/component/hag_curio_tracker/proc/find_target(true_name)
	for(var/mob/living/L in GLOB.player_list)
		if(L.real_name == true_name)
			return L
	for(var/mob/living/L in GLOB.mob_living_list)
		if(L.real_name == true_name)
			return L
	return null

/// Returns TRUE when the named victim has at least one active non-curse boon and no curse scar.
/datum/component/hag_curio_tracker/proc/has_unscarred_active_boon(true_name)
	if(!true_name)
		return FALSE
	var/list/name_list = boon_registry[true_name]
	if(!islist(name_list) || !length(name_list))
		return FALSE

	var/datum/hag_boon/curse_scar/scar = find_boon_by_type(true_name, /datum/hag_boon/curse_scar)
	if(scar && scar.points > 0)
		return FALSE

	for(var/datum/hag_boon/B in name_list)
		if(B && B.hag_is_valid && !B.hag_curse && !istype(B, /datum/hag_boon/curse_scar))
			return TRUE
	return FALSE

/datum/component/hag_curio_tracker/proc/can_grant_boon(boon_path)
	if(!prepared_boons[boon_path] || prepared_boons[boon_path] <= 0)
		return FALSE
	return TRUE

/datum/component/hag_curio_tracker/proc/user_can_receive_boon(boon_path, name_to_check)
	if(find_boon_by_type(name_to_check, boon_path))
		to_chat(parent, span_warning("[name_to_check] already carries this pact!"))
		return FALSE

	var/mob/living/L = find_target(name_to_check)
	if(L && !antag_check(L))
		to_chat(parent, span_warning("[name_to_check] can't hold your ancient magycks, they are already blessed by another force."))
		return FALSE

	var/active_victims = 0
	for(var/v_name in boon_registry)
		var/has_real_boon = FALSE
		for(var/datum/hag_boon/B in boon_registry[v_name])
			if(B.hag_is_valid && !B.hag_curse && !istype(B, /datum/hag_boon/curse_scar))
				has_real_boon = TRUE
				break
		if(has_real_boon)
			active_victims++

	var/max_victims
	var/max_points
	switch(hag_tier)
		if(1)
			max_victims = 4
			max_points = 60
		if(2)
			max_victims = 5
			max_points = 85
		else
			max_victims = 6
			max_points = 110

	var/target_has_boon = FALSE
	if(boon_registry[name_to_check])
		for(var/datum/hag_boon/B in boon_registry[name_to_check])
			if(B.hag_is_valid && !B.hag_curse && !istype(B, /datum/hag_boon/curse_scar))
				target_has_boon = TRUE
				break

	if(!target_has_boon && active_victims >= max_victims)
		to_chat(parent, span_warning("Your spirit cannot tether more than [max_victims] blessed souls at this tier."))
		return FALSE

	var/current_total_points = 0
	var/trait_boon_count = 0

	if(boon_registry[name_to_check])
		for(var/datum/hag_boon/B in boon_registry[name_to_check])
			if(!B.hag_is_valid || (!B.hag_curse && !istype(B, /datum/hag_boon/curse_scar)))
				continue
			current_total_points += B.points
			if(B.hag_trait)
				trait_boon_count++

	var/datum/hag_boon/checking = boon_path
	if(initial(checking.hag_trait) && trait_boon_count >= 3)
		to_chat(parent, span_warning("[name_to_check]'s body cannot withstand more than 3 trait-altering boons!"))
		return FALSE

	var/new_boon_points = initial(checking.points)
	if((current_total_points + new_boon_points) > max_points)
		to_chat(parent, span_warning("This blessing is too heavy. [name_to_check] only has room for [max_points - current_total_points] more points of power."))
		return FALSE

	if(ispath(boon_path, /datum/hag_boon/spell))
		if(L && L.mind)
			var/datum/hag_boon/spell/spell_boon_path = boon_path
			var/target_spell_type = initial(spell_boon_path.spell_type)
			if(target_spell_type)
				for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
					if(S.type == target_spell_type)
						to_chat(parent, span_warning("[name_to_check] already possesses the knowledge this boon would grant."))
						return FALSE

	return TRUE

/datum/component/hag_curio_tracker/proc/antag_check(mob/living/carbon/C)
	if(!C.mind)
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/werewolf))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/hag))
		return FALSE
	if(C.mind.has_antag_datum(/datum/antagonist/skeleton))
		return FALSE
	return TRUE

/// Consume a prepared boon to check availability
/datum/component/hag_curio_tracker/proc/consume_prepared_boon(boon_path)
	if(!can_grant_boon(boon_path))
		return FALSE
	prepared_boons[boon_path] = max((prepared_boons[boon_path] || 0) - 1, 0)
	return TRUE

/// Absorb enchanted moss to prepare boons for manifestation
/datum/component/hag_curio_tracker/proc/absorb_enchanted_moss(obj/item/alch/hag_moss/enchanted/M)
	if(!M.boon_path)
		return FALSE

	prepared_boons[M.boon_path] = (prepared_boons[M.boon_path] || 0) + 1
	to_chat(parent, span_notice("The [M] dissolves into your spirit, preparing a blessing of [initial(M.boon_path:name)]."))
	qdel(M)
	return TRUE

/// Prevents immediate post-revive root travel.
/datum/component/hag_curio_tracker/proc/hag_teleport_check()
	if(world.time < last_revive_time + 5 MINUTES)
		return FALSE
	return TRUE

/// Handles death signal and schedules the revive attempt.
/datum/component/hag_curio_tracker/proc/handle_death(mob/living/carbon/L, gibbed)
	SIGNAL_HANDLER
	if(!L)
		return
	L.visible_message(span_boldnotice("The corpse of [L.name] starts to dissolve into the soil."))
	addtimer(CALLBACK(src, PROC_REF(move_hag), L), 10 SECONDS)

/// Moves the dead hag to a heart turf or applies final death.
/datum/component/hag_curio_tracker/proc/move_hag(mob/living/L)
	if(!L)
		return

	if(!length(GLOB.hag_hearts))
		ADD_TRAIT(L, TRAIT_DNR, "hag_final_death")
		L.visible_message(span_danger("The roots that once sustained [L.name] wither and turn to ash! There is no sanctuary for the hag left."))
		to_chat(L, span_userdanger("Your connection to the Mossmother's hearts has been severed. This is the end."))
		playsound(L, 'sound/magic/slimesquish.ogg', 100, TRUE)
		execute_final_spite()
		return

	var/obj/structure/roguemachine/hag_heart/heart = pick(GLOB.hag_hearts)
	var/turf/heart_turf = get_turf(heart)
	if(!heart_turf)
		return

	to_chat(L, span_userdanger("Death's cold grip is denied by the Mossmother's roots! The heart prepares to revive you."))
	L.forceMove(heart_turf)
	addtimer(CALLBACK(src, PROC_REF(revive_hag), L), 90 SECONDS)

/// Revives the hag at the heart location.
/datum/component/hag_curio_tracker/proc/revive_hag(mob/living/L)
	if(!L || QDELETED(L) || L.stat != DEAD)
		return
	L.grab_ghost(force = TRUE)
	L.revive(full_heal = TRUE, admin_revive = FALSE)
	playsound(L, 'sound/magic/slimesquish.ogg', 100, TRUE)
	last_revive_time = world.time

/// Called on final hag death to resolve all registered pacts.
/datum/component/hag_curio_tracker/proc/execute_final_spite()
	var/list/valid_curses = list()
	for(var/path in curse_registry)
		var/list/details = curse_registry[path]
		if(details["cost"] > 10)
			valid_curses += path

	var/list/registry_snapshot = boon_registry.Copy()
	for(var/t_name in registry_snapshot)
		var/datum/hag_boon/curse_scar/S = find_boon_by_type(t_name, /datum/hag_boon/curse_scar)
		var/list/name_list = boon_registry[t_name]
		if(!islist(name_list))
			continue

		if(S && S.points > 10)
			var/mob/living/L = find_target(t_name)
			if(L)
				to_chat(L, span_notice("The heavy weight of your curse lifts as a distant, pained shriek echoes in your mind."))

			for(var/datum/hag_boon/B in name_list.Copy())
				if(B.hag_curse)
					remove_boon_instance(B)
		else
			var/mob/living/victim = find_target(t_name)
			if(!victim)
				continue
			to_chat(victim, span_userdanger("With her dying breath, the Hag weaves a final, spiteful knot into your soul!"))
			if(!length(valid_curses))
				continue
			var/list/curse_pool = list()
			for(var/curse_path in valid_curses)
				if(!find_boon_by_type(t_name, curse_path))
					curse_pool += curse_path
			if(!length(curse_pool))
				continue
			for(var/i in 1 to min(2, length(curse_pool)))
				var/curse_path = pick(curse_pool)
				curse_pool -= curse_path
				grant_boon(t_name, curse_path, 100)
