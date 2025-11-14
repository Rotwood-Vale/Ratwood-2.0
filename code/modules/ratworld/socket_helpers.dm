/****************************************************
 * Ratworld socketing attribute reroll helpers
 ****************************************************/

// Map gem types to the list of enchant ids they can roll
// TODO: Adjust these mappings to match your Excel sheet exactly.
/proc/ratworld_get_gem_enchant_choices(obj/item/G)
	if(!G)
		return list()
	var/name_lower = lowertext(G.name)
	// Offensive physical/magical damage gems (ruby)
	if(findtext(name_lower, "ruby"))
		return list(
			"phys_power_bonus",
			"phys_power",
			"magic_power_bonus",
			"true_phys_damage",
			"true_magical_damage"
		)
	// Defensive and utility gems (sapphire)
	if(findtext(name_lower, "sapphire"))
		return list(
			"magical_defense",
			"physical_damage_reduction",
			"projectile_damage_defense",
			"buff_duration_bonus",
			"debuff_duration_bonus"
		)
	// Race damage and luck-oriented gems (emerald)
	if(findtext(name_lower, "emerald"))
		return list(
			"undead_race_damage_bonus",
			"demon_race_damage_bonus",
			"goblin_race_damage_bonus",
			"luck"
		)
	// Fallback: no choices
	return list()

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

	// Ask the player which attribute they want from this gem
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

	// Replace an existing enchant if present, otherwise append
	enchant_ids = I.vars["rw_enchants"]
	if(!(chosen_id in enchant_ids))
		enchant_ids += chosen_id

	I.vars["rw_enchant_vals"][chosen_id] = value

	// Reapply item-side and wearer-side effects to reflect the new enchant
	ratworld_apply_enchantments(I)
	if(isliving(I.loc))
		var/mob/living/L = I.loc
		ratworld_apply_wearer_effects(I, L)
