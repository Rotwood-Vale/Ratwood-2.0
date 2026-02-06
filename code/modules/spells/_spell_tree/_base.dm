/datum/talent_node
	var/name = "Talent"
	var/desc = "A talent"
	var/icon = 'icons/mob/actions/roguespells.dmi'
	var/icon_state = "spell_default"
	var/talent_cost = 1
	var/list/prerequisites = list()
	var/max_rank = 1
	var/current_rank = 0
	var/talent_tree_id = "generic"
	var/singular_requirement = FALSE
	var/obj/effect/proc_holder/spell/spell_type = null
	var/is_passive = FALSE
	var/node_x = 0
	var/node_y = 0

/datum/talent_node/proc/on_talent_learned(mob/user)
	return
