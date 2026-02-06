/datum/talent_tree
	var/name = "Talent Tree"
	var/desc = "A talent tree"
	var/list/tree_nodes = list(/datum/talent_node) // List of talent node types that belong to this tree
	var/list/unlocked_talents = list()
	var/talent_points_available = 0
	var/talent_points_spent = 0
	var/max_talent_points = 50
	var/tree_identifier = "generic"

	// Generated layout data
	var/list/node_layers = list() // Layer -> list of nodes in that layer
	var/list/node_positions = list() // Node type -> list(x, y, layer)
	var/max_layer = 0

/datum/talent_tree/New()
	..()
	if(tree_nodes.len)
		generate_tree_layout()

/datum/talent_tree/Destroy()
	tree_nodes = null
	unlocked_talents = null
	node_layers = null
	node_positions = null
	return ..()

/datum/talent_tree/proc/generate_tree_layout()
	node_layers = list()
	node_positions = list()
	max_layer = 0

	// First pass: determine layers based on dependencies
	var/list/processed = list()
	var/list/current_layer = list()
	var/layer = 0

	// Find root nodes (no prerequisites)
	for(var/node_type in tree_nodes)
		var/datum/talent_node/node = new node_type
		if(!node.prerequisites.len)
			current_layer += node_type
		qdel(node)

	while(current_layer.len)
		node_layers["[layer]"] = current_layer.Copy()
		processed += current_layer
		var/list/next_layer = list()

		// Find nodes whose prerequisites are all in processed
		for(var/node_type in tree_nodes)
			if(node_type in processed)
				continue
			var/datum/talent_node/node = new node_type
			var/can_add = TRUE
			for(var/prereq in node.prerequisites)
				if(!(prereq in processed))
					can_add = FALSE
					break
			if(can_add)
				next_layer += node_type
			qdel(node)
		current_layer = next_layer
		layer++
	max_layer = layer - 1

	// Second pass: position nodes within layers
	position_nodes_in_layers()

/datum/talent_tree/proc/position_nodes_in_layers()
	var/layer_spacing = 120
	var/base_y = -50
	var/list/dependency_graph = build_dependency_graph()

	// Start with root layer
	var/list/root_nodes = node_layers["0"]
	var/node_spacing = 80
	var/total_width = (root_nodes.len - 1) * node_spacing
	var/start_x = -(total_width / 2)

	for(var/i = 1; i <= root_nodes.len; i++)
		var/node_type = root_nodes[i]
		var/x = start_x + ((i - 1) * node_spacing)
		var/y = base_y
		node_positions[node_type] = list("x" = x, "y" = y, "layer" = 0)

	// Position subsequent layers based on their prerequisites
	for(var/layer = 1; layer <= max_layer; layer++)
		var/list/layer_nodes = node_layers["[layer]"]
		if(!layer_nodes || !layer_nodes.len)
			continue

		// Group nodes by their prerequisite relationships
		var/list/positioned_nodes = list()
		var/list/remaining_nodes = layer_nodes.Copy()

		// First, position nodes that have single prerequisites
		for(var/node_type in remaining_nodes)
			var/datum/talent_node/node = new node_type
			if(node.prerequisites.len == 1)
				var/prereq = node.prerequisites[1]
				if(prereq in node_positions)
					var/list/prereq_pos = node_positions[prereq]
					var/x = prereq_pos["x"]
					var/y = base_y + (layer * layer_spacing)

					// Check for conflicts and adjust
					x = find_best_x_position(x, y, positioned_nodes, dependency_graph[node_type])

					node_positions[node_type] = list("x" = x, "y" = y, "layer" = layer)
					positioned_nodes += node_type
					remaining_nodes -= node_type
			qdel(node)

		// Then position nodes with multiple prerequisites
		for(var/node_type in remaining_nodes)
			var/datum/talent_node/node = new node_type
			if(node.prerequisites.len > 1)
				var/avg_x = 0
				var/valid_prereqs = 0

				for(var/prereq in node.prerequisites)
					if(prereq in node_positions)
						var/list/prereq_pos = node_positions[prereq]
						avg_x += prereq_pos["x"]
						valid_prereqs++

				if(valid_prereqs > 0)
					avg_x = avg_x / valid_prereqs
					var/y = base_y + (layer * layer_spacing)

					// Adjust position to avoid conflicts
					avg_x = find_best_x_position(avg_x, y, positioned_nodes, dependency_graph[node_type])

					node_positions[node_type] = list("x" = avg_x, "y" = y, "layer" = layer)
					positioned_nodes += node_type
					remaining_nodes -= node_type
			qdel(node)

		// Finally, position any remaining nodes using alternating placement
		var/side_multiplier = 1
		var/offset = 0
		for(var/node_type in remaining_nodes)
			// Find available space
			var/base_x = 0
			var/y = base_y + (layer * layer_spacing)

			// Alternate sides and increase offset
			var/x = base_x + (side_multiplier * (80 + offset))
			x = find_best_x_position(x, y, positioned_nodes, dependency_graph[node_type])

			node_positions[node_type] = list("x" = x, "y" = y, "layer" = layer)
			positioned_nodes += node_type

			// Alternate sides
			side_multiplier *= -1
			if(side_multiplier == 1)
				offset += 40

/datum/talent_tree/proc/build_dependency_graph()
	var/list/graph = list()

	for(var/node_type in tree_nodes)
		var/datum/talent_node/node = new node_type
		graph[node_type] = list("dependencies" = list(), "dependents" = list())
		qdel(node)

	// Build dependency relationships
	for(var/node_type in tree_nodes)
		var/datum/talent_node/node = new node_type
		for(var/prereq in node.prerequisites)
			if(prereq in graph)
				graph[prereq]["dependents"] += node_type
				graph[node_type]["dependencies"] += prereq
		qdel(node)

	return graph

/datum/talent_tree/proc/find_best_x_position(target_x, y, list/existing_positions, list/relationships)
	var/min_distance = 60
	var/best_x = target_x
	var/conflict_found = TRUE
	var/attempts = 0
	var/offset = 0

	while(conflict_found && attempts < 20)
		conflict_found = FALSE

		for(var/existing_node in existing_positions)
			if(existing_node in node_positions)
				var/list/existing_pos = node_positions[existing_node]
				if(abs(existing_pos["y"] - y) < 30)
					if(abs(existing_pos["x"] - best_x) < min_distance)
						conflict_found = TRUE
						break

		if(conflict_found)
			attempts++
			offset += 30
			if(attempts % 2 == 1)
				best_x = target_x + offset
			else
				best_x = target_x - offset

	return best_x

/datum/talent_tree/proc/can_learn_talent(datum/talent_node/node)
	for(var/prereq in node.prerequisites)
		if(node.singular_requirement)
			if((prereq in unlocked_talents))
				return TRUE
		else
			if(!(prereq in unlocked_talents))
				return FALSE

	if(node.talent_cost > talent_points_available)
		return FALSE

	return TRUE

/datum/talent_tree/proc/learn_talent(node_type, mob/living/user)
	if(!(node_type in tree_nodes))
		return FALSE

	if(node_type in unlocked_talents)
		to_chat(user, span_warning("You have already learned this talent."))
		return FALSE

	var/datum/talent_node/node = new node_type

	if(!can_learn_talent(node))
		to_chat(user, span_warning("Prerequisites not met or insufficient talent points."))
		qdel(node)
		return FALSE

	if(node.spell_type)
		var/user_tier = get_user_spell_tier(user)
		if(node.spell_type.spell_tier > user_tier)
			to_chat(user, span_warning("This art is beyond you."))
			return FALSE

	talent_points_available -= node.talent_cost
	talent_points_spent += node.talent_cost
	unlocked_talents += node_type

	node.on_talent_learned(user)
	if(node.is_passive)
		to_chat(user, span_notice("You have learned the passive technique: [node.name]"))
	else
		if(node.spell_type)
			var/has_spell = FALSE
			for(var/obj/effect/proc_holder/spell/S in user.mind?.spell_list)
				if(istype(S, node.spell_type))
					has_spell = TRUE
					break

			if(!has_spell)
				var/obj/effect/proc_holder/spell/new_spell = new node.spell_type
				user.mind.AddSpell(new_spell)
				to_chat(user, span_notice("You have learned the spell: [node.name]"))
			else
				to_chat(user, span_notice("You have reinforced your knowledge of: [node.name]"))
		else
			to_chat(user, span_notice("You have learned the talent: [node.name]"))

	qdel(node)
	return TRUE
