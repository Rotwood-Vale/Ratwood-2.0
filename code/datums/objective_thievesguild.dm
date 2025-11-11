// Thieves' Guild Objective - No = assignments

/datum/objective/thieves_guild_objective
    name = "Thieves' Guild Objective"
    explanation_text = "Complete your Thieves' Guild task."
    var/target_item_path
    var/target_item_name
    var/is_mammon
    var/mammon_amount
    var/is_assassinate
    var/assassinate_target
    triumph_count = 5

/datum/objective/thieves_guild_objective/proc/setup_steal_objective()
    var/list/items
    items = list(
        list("Staff of the Shepherd", /obj/item/rogueweapon/woodstaff/aries),
        list("Crown of Rotwood Vale", /obj/item/clothing/head/roguetown/crown/serpcrown),
        list("Bell Ringer", /obj/item/rogueweapon/mace/church),
        list("Pepper Mill", /obj/item/reagent_containers/peppermill),
        list("Sword of the Mad Duke", /obj/item/rogueweapon/sword/rapier/lord),
        list("Judgement", /obj/item/rogueweapon/sword/long/judgement),
        list("Holy Book", /obj/item/book/rogue/bookofpriests),
		list("The Master Key", /obj/item/roguekey/lord),
        list("Book of Law", /obj/item/book/rogue/law),
        list("Garrison houndstone", /obj/item/scomstone/bad/garrison)
    )
    var/selected
    selected = pick(items)
    if(selected)
        target_item_name = selected[1]
        target_item_path = selected[2]
        is_mammon = FALSE
        is_assassinate = FALSE
        return TRUE
    else
        return FALSE

/datum/objective/thieves_guild_objective/proc/setup_mammon_objective()
	is_mammon = TRUE
	is_assassinate = FALSE
	mammon_amount = 1000
	return TRUE

/datum/objective/thieves_guild_objective/proc/setup_assassinate_objective()
    is_mammon = FALSE
    is_assassinate = TRUE
    var/list/valid_roles
    valid_roles = list("Grand Duke", "Prince", "Priest", "Priestess", "Councillor", "Acolyte", "Inquisitor", "Merchant", "Town Elder", "Guildmaster", "Steward", "Clerk")
    var/list/strong_combat_roles
    strong_combat_roles = list("Knight", "Marshal", "Knight Captain", "Man at Arms", "Sergeant", "Warden", "Watchman", "Squire", "Dungeoneer", "Mercenary", "Veteran")
    var/list/candidates
    candidates = list()
    var/list/available_roles = list()
    for(var/client/C in GLOB.clients)
        var/mob/living/carbon/human/H
        H = C.mob
        if(!istype(H, /mob/living/carbon/human/))
            continue
        if(!H.mind || !H.mind.assigned_role)
            continue
        var/assigned_role = H.mind.assigned_role
        var/role_name = get_role_name(assigned_role)
        available_roles += "[H.real_name] ([role_name])"
        var/in_valid_roles = (role_name in valid_roles)
        var/in_strong_combat_roles = (role_name in strong_combat_roles)
        var/is_alive = (H.stat != DEAD)
        if(in_valid_roles && !in_strong_combat_roles && is_alive)
            candidates += H
        else
            continue
    if(candidates.len)
        assassinate_target = pick(candidates)
        return TRUE
    else
        is_assassinate = FALSE
        return FALSE

/datum/objective/thieves_guild_objective/New(owner)
    ..()
    if(owner)
        src.owner = owner
        var/roll
        roll = rand(1, 3) // Restore random objective assignment
        var/assigned
        assigned = FALSE
        if(roll == 1)
            assigned = src.setup_steal_objective()
        else if(roll == 2)
            assigned = src.setup_mammon_objective()
        else
            assigned = src.setup_assassinate_objective()
        if(!assigned)
            // If assassination fails (no valid targets), fall back to steal
            assigned = src.setup_steal_objective()
        if(!assigned)
            // If steal also fails, fall back to mammon
            assigned = src.setup_mammon_objective()
    update_explanation_text()

/datum/objective/thieves_guild_objective/proc/get_assassinate_explanation()
    if(assassinate_target && istype(assassinate_target, /mob/living))
        var/mob/living/target
        target = assassinate_target
        if(target.mind && target.mind.assigned_role)
            return "Ensure <b>[target.real_name]</b> ([target.mind.assigned_role]) stays dead until the end of the round."
    return "Ensure your assigned target stays dead until the end of the round."

/datum/objective/thieves_guild_objective/update_explanation_text()
    ..()
    if(is_assassinate)
        explanation_text = src.get_assassinate_explanation()
    else if(is_mammon)
        explanation_text = "Have at least <b>[mammon_amount] mammon</b> on your person at the end of the round."
    else
        explanation_text = "Steal and keep <b>[target_item_name]</b> in your possession until the end of the round."

/datum/objective/thieves_guild_objective/proc/is_target_dead()
    if(assassinate_target && istype(assassinate_target, /mob/living))
        var/mob/living/target
        target = assassinate_target
        if(target.mind && target.stat != null && target.stat == DEAD)
            return TRUE
    return FALSE

/datum/objective/thieves_guild_objective/proc/check_assassinate_completion()
    if(src.is_target_dead())
        return TRUE
    return FALSE

// Helper proc to get all items a mob is carrying, including inside containers
/proc/get_all_mob_items(mob/M)
	var/list/all_items = list()
	if(!M) return all_items
	for(var/obj/item/I in M.contents)
		all_items += I
		if(I.contents && I.contents.len)
			all_items += get_all_item_contents(I)
	return all_items

/proc/get_all_item_contents(obj/item/I)
	var/list/all_items = list()
	for(var/obj/item/subI in I.contents)
		all_items += subI
		if(subI.contents && subI.contents.len)
			all_items += get_all_item_contents(subI)
	return all_items

/datum/objective/thieves_guild_objective/proc/check_steal_completion()
	if(owner.current)
		for(var/obj/item/I in get_all_mob_items(owner.current))
			if(istype(I, target_item_path))
				return TRUE
	return FALSE

/datum/objective/thieves_guild_objective/check_completion()
	if(!owner)
		return FALSE
	if(!owner.current)
		return FALSE
	if(is_assassinate)
		return src.check_assassinate_completion()
	if(is_mammon)
		var/total_mammon = get_mammons_in_atom(owner.current)
		if(owner.current && owner.current.client)
			to_chat(owner.current, "[span_notice("Mammon objective check: you have [total_mammon] mammon counted in all containers.")]")
		return total_mammon >= mammon_amount
	if(target_item_path)
		for(var/obj/item/I in get_all_mob_items(owner.current))
			if(istype(I, target_item_path))
				return TRUE
	return FALSE

/proc/get_role_name(var/role)
	if(istype(role, /datum/job))
		var/datum/job/J = role
		return J.title
	return "[role]"
