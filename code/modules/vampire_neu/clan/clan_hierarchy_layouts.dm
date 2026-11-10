GLOBAL_LIST_EMPTY(vampire_clan_layout_cache)

/proc/vampire_clan_layout_node(id, parent, name, desc, rank_level, max_subordinates, can_assign_positions, position_color)
	return list(
		"id" = id,
		"parent" = parent,
		"name" = name,
		"desc" = desc,
		"rank_level" = rank_level,
		"max_subordinates" = max_subordinates,
		"can_assign_positions" = can_assign_positions,
		"position_color" = position_color,
	)

/proc/vampire_clan_public_layout()
	var/list/nodes = list(
		vampire_clan_layout_node("jarl", null, "The Jarl", "Sovereign of the hall. Every oath sworn within the clan ends at their feet.", 0, 10, TRUE, "#e02020"),
	)
	var/list/flanks = list("left" = "Left", "right" = "Right")
	for(var/flank in flanks)
		var/hersir_id = "[flank]_hersir"
		nodes += list(vampire_clan_layout_node(hersir_id, "jarl", "The [flanks[flank]] Hersir", "A sworn war-leader who holds the [flank] flank and commands the thralls upon it.", 1, 5, TRUE, "#a83232"))
		for(var/i in 1 to 3)
			nodes += list(vampire_clan_layout_node("[hersir_id]_thrall_[i]", hersir_id, "Thrall Warrior", "A bound warrior who fights wherever their Hersir commands.", 2, 5, FALSE, "#6e2a2a"))
	return list(
		"name" = "Basic Clan",
		"format" = CLAN_LAYOUT_FORMAT,
		"version" = CLAN_LAYOUT_VERSION,
		"nodes" = nodes,
	)

/proc/vampire_clan_layout_path(ckey)
	return "data/player_saves/[ckey[1]]/[ckey]/[CLAN_LAYOUT_SAVE_FILE]"

/proc/get_vampire_clan_layouts(ckey)
	if(!istext(ckey) || !length(ckey))
		return null
	var/list/slots = GLOB.vampire_clan_layout_cache[ckey]
	if(!islist(slots))
		slots = read_vampire_clan_layouts(ckey)
		GLOB.vampire_clan_layout_cache[ckey] = slots
	return slots

/proc/read_vampire_clan_layouts(ckey)
	var/list/slots = new /list(CLAN_LAYOUT_PERSONAL_SLOTS)
	var/path = vampire_clan_layout_path(ckey)
	if(!rustg_file_exists(path))
		return slots
	var/list/data = safe_json_decode(rustg_file_read(path))
	var/list/saved = islist(data) ? data["slots"] : null
	if(!islist(saved))
		return slots
	for(var/i in 1 to min(length(saved), CLAN_LAYOUT_PERSONAL_SLOTS))
		var/list/entry = saved[i]
		if(islist(entry) && islist(entry["nodes"]))
			slots[i] = entry
	return slots

/proc/write_vampire_clan_layouts(ckey, list/slots)
	rustg_file_write(json_encode(list("version" = CLAN_LAYOUT_VERSION, "slots" = slots)), vampire_clan_layout_path(ckey))

/datum/clan/proc/collect_hierarchy_layout_nodes(datum/clan_hierarchy_node/position, parent_id, list/nodes, list/node_ids)
	if(!position || node_ids[position])
		return

	var/node_id = "node_[length(nodes) + 1]"
	node_ids[position] = node_id
	nodes += list(vampire_clan_layout_node(node_id, parent_id, position.name, position.desc, position.rank_level, position.max_subordinates, position.can_assign_positions, position.position_color))

	for(var/datum/clan_hierarchy_node/subordinate as anything in position.subordinates)
		collect_hierarchy_layout_nodes(subordinate, node_id, nodes, node_ids)

/datum/clan/proc/export_hierarchy_layout(layout_name)
	if(!hierarchy_root)
		initialize_hierarchy()

	var/list/nodes = list()
	collect_hierarchy_layout_nodes(hierarchy_root, null, nodes, list())
	return list(
		"name" = layout_name,
		"format" = CLAN_LAYOUT_FORMAT,
		"version" = CLAN_LAYOUT_VERSION,
		"nodes" = nodes,
	)

/datum/clan/proc/discard_layout_positions(list/new_positions)
	for(var/datum/clan_hierarchy_node/position as anything in new_positions)
		qdel(position)

/datum/clan/proc/collect_hierarchy_nodes(datum/clan_hierarchy_node/position, list/collected)
	if(!position || (position in collected))
		return

	collected += position
	for(var/datum/clan_hierarchy_node/subordinate as anything in position.subordinates)
		collect_hierarchy_nodes(subordinate, collected)

/datum/clan/proc/apply_hierarchy_layout(list/layout, mob/living/carbon/human/importing_user)
	if(!islist(layout))
		return "The layout could not be read."

	if(layout["format"] && layout["format"] != CLAN_LAYOUT_FORMAT)
		return "The layout is in an unknown format."

	var/list/nodes = layout["nodes"]
	if(!islist(nodes) || !length(nodes))
		return "The layout has no positions."

	if(length(nodes) > CLAN_LAYOUT_MAX_NODES)
		return "The layout has too many positions. Limit: [CLAN_LAYOUT_MAX_NODES]."

	var/list/node_lookup = list()
	var/list/parent_lookup = list()
	var/list/new_positions = list()
	var/datum/clan_hierarchy_node/new_root
	var/root_count = 0

	for(var/node_entry in nodes)
		if(!islist(node_entry))
			discard_layout_positions(new_positions)
			return "The layout has a malformed position."

		var/list/node_data = node_entry
		var/node_id = node_data["id"]
		if(!istext(node_id) || !length(node_id) || node_lookup[node_id])
			discard_layout_positions(new_positions)
			return "The layout has a position without a unique id."

		var/position_name = node_data["name"]
		if(!istext(position_name) || !length(position_name))
			position_name = "Position"
		position_name = copytext_char(strip_html_simple(position_name), 1, 51)

		var/position_desc = node_data["desc"]
		if(!istext(position_desc))
			position_desc = ""
		position_desc = copytext_char(strip_html_simple(position_desc), 1, 201)

		var/rank_value = node_data["rank_level"]
		var/rank_level = isnum(rank_value) ? rank_value : text2num("[rank_value]")
		if(isnull(rank_level))
			rank_level = 1
		rank_level = clamp(round(rank_level), 0, 10)

		var/max_value = node_data["max_subordinates"]
		var/max_subordinates = isnum(max_value) ? max_value : text2num("[max_value]")
		if(isnull(max_subordinates))
			max_subordinates = 5
		max_subordinates = clamp(round(max_subordinates), 1, 100)

		var/datum/clan_hierarchy_node/new_position = new /datum/clan_hierarchy_node(position_name, position_desc, rank_level)
		new_position.max_subordinates = max_subordinates
		new_position.position_color = sanitize_hexcolor(node_data["position_color"], 6, TRUE, "#ffffff")
		new_position.can_assign_positions = node_data["can_assign_positions"] ? TRUE : FALSE

		node_lookup[node_id] = new_position
		new_positions += new_position

		var/parent_id = node_data["parent"]
		if(isnull(parent_id) || parent_id == "")
			root_count++
			new_root = new_position
		else
			parent_lookup[node_id] = "[parent_id]"

	if(root_count != 1)
		discard_layout_positions(new_positions)
		return "The layout must have exactly one leading position."

	new_root.rank_level = 0
	new_root.can_assign_positions = TRUE

	for(var/node_id in node_lookup)
		var/datum/clan_hierarchy_node/new_position = node_lookup[node_id]
		if(new_position == new_root)
			continue

		var/datum/clan_hierarchy_node/parent_position = node_lookup[parent_lookup[node_id]]
		if(!parent_position || !parent_position.add_subordinate(new_position))
			discard_layout_positions(new_positions)
			return "The layout has a position whose superior is missing or full."

	var/list/reachable = list()
	collect_hierarchy_nodes(new_root, reachable)
	if(length(reachable) != length(new_positions))
		discard_layout_positions(new_positions)
		return "The layout has positions cut off from the leader."

	var/mob/living/carbon/human/leader_to_restore = (istype(clan_leader) && clan_leader.clan == src) ? clan_leader : importing_user

	var/list/old_positions = all_positions ? all_positions.Copy() : list()
	for(var/datum/clan_hierarchy_node/old_position as anything in old_positions)
		qdel(old_position)

	all_positions = new_positions
	hierarchy_root = new_root
	clear_hierarchy_selections()

	if(istype(leader_to_restore) && leader_to_restore.clan == src)
		hierarchy_root.assign_member(leader_to_restore)

	return "The clan now follows \"[html_encode(layout["name"] || "the chosen layout")]\": [length(new_positions)] positions."

/datum/clan/proc/clear_hierarchy_selections()
	for(var/mob/living/carbon/human/member in clan_members)
		var/datum/clan_menu_interface/menu = member.clan_menu_interface
		if(!menu)
			continue
		menu.selected_position = null
		if(menu.hierarchy_interface)
			menu.hierarchy_interface.selected_position = null
