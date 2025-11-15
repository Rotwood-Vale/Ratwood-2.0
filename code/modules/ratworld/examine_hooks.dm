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
	var/list/vals = I.vars?["rw_enchant_vals"]
	// Show +STAT rarity line first, in blue with a star
	if(islist(I.vars?["rw_stat_bonuses"]))
		var/list/bon = I.vars["rw_stat_bonuses"]
		var/list/parts = list()
		for(var/sid in bon)
			var/sv = bon[sid]
			if(!isnum(sv) || !sv) continue
			var/sdisp = (sid == "STR") ? "Strength" : (sid == "SPD") ? "Speed" : (sid == "INT") ? "Intelligence" : (sid == "WIL") ? "Willpower" : (sid == "CON") ? "Constitution" : sid
			parts += "+[sv] [sdisp]"
		if(parts.len)
			var/line = "★ " + jointext(parts, ", ")
			lines += "<span style='color:#4da6ff'>[line]</span>"
	if(islist(ids) && ids.len)
		lines += span_info("Enchantments:")
		// Infer slot key for percent formatting
		var/slot_key = ratworld_slot_key_for_item(I)
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

	// Show special attribute if present
	var/sp = I.vars?["rw_special_id"]
	if(istext(sp))
		var/label = sp
		if(sp == "crushing_blow") label = "Crushing Blow"
		else if(sp == "deadly_strike") label = "Deadly Strike"
		else if(sp == "slows_target") label = "Slows Target"
		else if(sp == "astratas_light") label = "Astrata's Light"
		else if(sp == "thorns") label = "Thorns"
		else if(sp == "indestructible") label = "Indestructible"
		else if(sp == "cannot_be_slowed") label = "Cannot be Slowed"
		else if(sp == "midas_touch") label = "Midas Touch"
		else if(sp == "magic_find") label = "Magic Find"
		var/ch = I.vars?["rw_special_chance"]
		var/val = I.vars?["rw_special_value"]
		var/s = "- [label]"
		if(isnum(ch) && ch > 0) s += " ([ch]% chance)"
		if(sp == "magic_find" && isnum(val) && val) s += " (+[val]% rarity)"
		if(sp == "slows_target" && isnum(val) && val) s += " (-[val] SPD for 5s)"
		// Golden highlight for special attributes
		lines += "<span style='color:#f2d94c'>[s]</span>"
	return lines
