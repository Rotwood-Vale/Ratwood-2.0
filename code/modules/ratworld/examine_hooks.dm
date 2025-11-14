// Ratworld examine helpers to display rarity and enchantments on items

/proc/ratworld_build_examine_for_item(obj/item/I)
	if(!I) return null
	var/list/lines = list()
	var/r = I.vars?["rw_rarity"]
	if(isnum(r))
		// Use existing rarity formatter
		lines += ratworld_format_rarity_examine(r)
	// If undiscovered, hide enchant details until identified
	if(I.vars && ("rw_discovered" in I.vars) && !I.vars["rw_discovered"])
		lines += span_warning("Unidentified item — its properties are unknown. Use a Book of Identification.")
		return lines
	var/list/ids = I.vars?["rw_enchants"]
	if(islist(ids) && ids.len)
		lines += span_info("Enchantments:")
		// Infer slot key for percent formatting
		var/slot_key = ratworld_slot_key_for_item(I)
		var/list/vals = I.vars?["rw_enchant_vals"]
		for(var/id in ids)
			if(!istext(id)) continue
			var/list/def = ratworld_get_enchant_def(id)
			var/name = id
			if(islist(def) && def["name"]) name = def["name"]
			var/val = vals && isnum(vals[id]) ? vals[id] : null
			var/suffix = ""
			if(istext(slot_key))
				var/list/rng = ratworld_get_enchant_slot_range(id, slot_key)
				if(islist(rng) && rng["percent"]) suffix = "%"
			if(!isnull(val))
				var/sign = (val >= 0) ? "+" : ""
				lines += "- [name] [sign][val][suffix]"
			else
				lines += "- [name]"
	// Show +stat bonus if present
	var/sid = I.vars?["rw_stat_bonus_id"]
	var/sv = I.vars?["rw_stat_bonus_value"]
	if(istext(sid) && isnum(sv) && sv)
		var/sdisp = (sid == "STR") ? "Strength" : (sid == "SPD") ? "Speed" : (sid == "INT") ? "Intelligence" : (sid == "WIL") ? "Willpower" : (sid == "CON") ? "Constitution" : sid
		lines += "+[sv] [sdisp]"
	return lines
