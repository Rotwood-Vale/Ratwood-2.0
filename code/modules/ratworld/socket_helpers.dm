/****************************************************
 * Ratworld socketing attribute reroll helpers
 ****************************************************/

// Map gem types to the list of enchant ids they can roll
// TODO: Adjust these mappings to match your Excel sheet exactly.
/proc/ratworld_get_gem_enchant_choices(obj/item/G)
	if(!G)
		return list()
	var/name_lower = lowertext(G.name)
	// Normalize playful gem names to families
	var/is_ruby = (findtext(name_lower, "ruby") || findtext(name_lower, "rontz"))
	var/is_sapphire = (findtext(name_lower, "sapphire") || findtext(name_lower, "saffira") || findtext(name_lower, "blue") || findtext(name_lower, "quartz"))
	var/is_emerald = (findtext(name_lower, "emerald") || findtext(name_lower, "gemerald") || findtext(name_lower, "green"))
	var/is_topaz = (findtext(name_lower, "topaz") || findtext(name_lower, "toper") || findtext(name_lower, "yellow"))
	var/is_diamond = (findtext(name_lower, "diamond") || findtext(name_lower, "dorpel"))
	var/is_amethyst = (findtext(name_lower, "amyth") || findtext(name_lower, "amythortz") || findtext(name_lower, "amethyst"))

	// Offensive physical-focused gems (ruby family)
	if(is_ruby)
		return list(
			"phys_power_bonus",
			"phys_power",
			"magic_power_bonus",
			"true_phys_damage",
			"true_magical_damage"
		)
	// Defensive and utility gems (sapphire family: sapphire/violet/blue/quartz)
	if(is_sapphire)
		return list(
			"magical_defense",
			"physical_damage_reduction",
			"projectile_damage_defense",
			"buff_duration_bonus",
			"debuff_duration_bonus"
		)
	// Race damage and luck-oriented gems (emerald family)
	if(is_emerald)
		return list(
			"undead_race_damage_bonus",
			"demon_race_damage_bonus",
			"goblin_race_damage_bonus",
			"luck"
		)
	// Action/cast speed and CDR (topaz family)
	if(is_topaz)
		return list(
			"action_speed",
			"cast_speed",
			"cooldown_reduction_bonus",
			"buff_duration_bonus"
		)
	// Magic offense/penetration (amethyst family)
	if(is_amethyst)
		return list(
			"magic_power_bonus",
			"true_magical_damage",
			"magic_penetration",
			"cast_speed",
			"cooldown_reduction_bonus"
		)
	// Generalist utility (diamond family)
	if(is_diamond)
		return list(
			"luck",
			"magic_penetration",
			"projectile_damage_defense",
			"buff_duration_bonus",
			"debuff_duration_bonus"
		)
	// Fallback: no choices
	return list()

// Normalize a gem's display label from its name
/proc/ratworld_socket_gem_label_for(obj/item/G)
	if(!G) return null
	var/lname = lowertext(G.name)
	if(findtext(lname, "amyth") || findtext(lname, "amythortz") || findtext(lname, "amethyst"))
		return "Amythortz"
	if(findtext(lname, "ruby") || findtext(lname, "rontz"))
		return "Ruby"
	if(findtext(lname, "sapphire") || findtext(lname, "saffira"))
		return "Sapphire"
	if(findtext(lname, "emerald") || findtext(lname, "gemerald"))
		return "Emerald"
	if(findtext(lname, "topaz") || findtext(lname, "toper"))
		return "Topaz"
	if(findtext(lname, "diamond") || findtext(lname, "dorpel"))
		return "Diamond"
	if(findtext(lname, "blortz") || findtext(lname, "quartz"))
		return "Quartz"
	// Fallback: first word capitalized
	var/list/parts = splittext(G.name, " ")
	if(islist(parts) && parts.len)
		var/t = parts[1]
		return uppertext(copytext(t,1,2)) + lowertext(copytext(t,2,0))
	return G.name

// Color code used for the star/label in UI and examine
/proc/ratworld_socket_gem_color_for(label)
	if(!istext(label)) return null
	var/ll = lowertext(label)
	if(ll == "amythortz" || ll == "amethyst") return "#8e44ad" // purple
	if(ll == "ruby") return "#c0392b" // red
	if(ll == "sapphire") return "#2980b9" // blue
	if(ll == "emerald") return "#27ae60" // green
	if(ll == "topaz") return "#f1c40f" // gold
	if(ll == "diamond") return "#ecf0f1" // near-white
	if(ll == "quartz") return "#95a5a6" // gray-blue
	return "#cccccc"

// Apply attribute type swap + weakened reroll when a gem is socketed
/proc/ratworld_socket_apply_reroll(obj/item/G, obj/item/I, mob/living/user)
	var/list/choices
	var/chosen_id
	var/slot_key
	var/list/erange
	var/minv
	var/maxv
	var/normal_min
	var/normal_max
	var/reroll_range
	var/reroll_min
	var/reroll_max
	var/luck
	var/value
	var/list/enchant_ids

	if(!G || !I || !user)
		return

	choices = ratworld_get_gem_enchant_choices(G)
	if(!length(choices))
		return

	// Step 1: Choose which existing attribute to reroll (or None to add new)
	var/list/current_ids = list()
	if(islist(I.vars?["rw_enchants"]))
		for(var/id in I.vars["rw_enchants"])
			if(istext(id)) current_ids += id
	var/replace_target = null
	if(current_ids.len)
		var/list/pretty = list()
		for(var/id2 in current_ids)
			var/list/defp = ratworld_get_enchant_def(id2)
			var/nm = "[id2]"
			if(islist(defp) && defp?["name"]) nm = defp["name"]
			pretty[nm] = id2
		pretty["(Add New)"] = null
		var/selp = input(user, "Choose which attribute to reroll (or Add New):", "Socket Gem") in pretty
		replace_target = pretty[selp]

	// Step 2: Choose the new attribute from this gem
	chosen_id = input(user, "Choose an attribute to imbue:", "Socket Gem") in choices
	if(!chosen_id)
		return

	// Determine slot key for this item to read the correct min/max range
	slot_key = ratworld_slot_key_for_item(I)
	if(!istext(slot_key))
		return

	erange = ratworld_get_enchant_slot_range(chosen_id, slot_key)
	if(!islist(erange))
		return

	minv = erange["min"]
	maxv = erange["max"]
	if(isnull(minv) || isnull(maxv))
		return
	// Compute weakened reroll band within 10% - 50% of the item's normal range
	normal_min = minv
	normal_max = maxv
	reroll_range = normal_max - normal_min
	if(reroll_range < 0)
		reroll_range = 0
	reroll_min = normal_min + (reroll_range / 10)
	reroll_max = normal_min + (reroll_range / 2)
	if(reroll_min > reroll_max)
		var/tmp = reroll_min
		reroll_min = reroll_max
		reroll_max = tmp

	// Roll within reduced band using user's luck
	luck = user.ratworld_get_luck_total()
	value = ratworld_roll_enchant_value_with_luck(luck, reroll_min, reroll_max)

	// Ensure enchant id list exists
	if(!islist(I.vars["rw_enchants"]))
		I.vars["rw_enchants"] = list()
	if(!islist(I.vars["rw_enchant_vals"]))
		I.vars["rw_enchant_vals"] = list()

	// Replace the selected target if provided; otherwise add/ensure presence
	enchant_ids = I.vars["rw_enchants"]
	if(istext(replace_target) && (replace_target in enchant_ids))
		// Remove the old id when switching types
		if(replace_target != chosen_id)
			enchant_ids -= replace_target
		if(!(chosen_id in enchant_ids))
			enchant_ids += chosen_id
	else
		if(!(chosen_id in enchant_ids))
			enchant_ids += chosen_id

	// Sum into existing value so duplicate enchants combine cleanly
	if(isnum(I.vars["rw_enchant_vals"][chosen_id]))
		I.vars["rw_enchant_vals"][chosen_id] += value
	else
		I.vars["rw_enchant_vals"][chosen_id] = value

	// Record gem label/color for examine and stash UI
	var/glabel = ratworld_socket_gem_label_for(G)
	if(istext(glabel) && length(glabel))
		I.vars["rw_socket_gem"] = glabel
		I.vars["rw_socket_gem_color"] = ratworld_socket_gem_color_for(glabel)

	// Reapply item-side and wearer-side effects to reflect the new enchant
	ratworld_apply_enchantments(I)
	if(isliving(I.loc))
		var/mob/living/L = I.loc
		ratworld_apply_wearer_effects(I, L)
