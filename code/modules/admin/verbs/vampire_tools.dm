// Admin tools for Vampire system

/client/proc/vamp_grant_all_coven_powers(mob/living/carbon/human/H in GLOB.mob_list)
	set category = "-Admin-"
	set name = "Give All Vampire Powers"
	set desc = "Grant the target all covens at max level (all powers)."

	if(!check_rights(R_ADMIN))
		return

	if(!H)
		return

	var/granted = 0

	// Iterate all coven types and give/set to max level
	for(var/coven_type in subtypesof(/datum/coven))
		if(coven_type == /datum/coven)
			continue

		var/datum/coven/existing = H.get_coven(coven_type)
		if(existing)
			// Ensure existing coven is maxed
			existing.set_level(existing.max_level)
			granted++
			continue

		// Create at level 1, then bump to max to ensure proper initialization
		var/datum/coven/C = new coven_type(1)
		C.set_level(C.max_level)
		H.give_coven(C)
		granted++

	to_chat(H, span_boldnotice("All vampire covens granted at max level ([granted])."))
	message_admins(span_adminnotice("[key_name_admin(src)] granted ALL vampire covens at max level to [key_name_admin(H)]."))
	log_admin("[key_name(src)] granted ALL vampire covens at max level to [key_name(H)] (total [granted]).")
