// Ratworld enchantment system skeleton
// Provides a base datum, a global registry, and helpers to roll/apply enchantments to items.

// Base enchantment datum
/datum/ratworld/enchantment
	var/id = ""
	var/name = "Unnamed"
	var/tier = 1 // loosely aligned with rarity tiers, can be independent
	var/weight = 100 // roll weight
	var/description = null
	
	// Called when an enchantment is applied to an item
	proc/apply_to_item(obj/item/I)
		// Skeleton: no-op; concrete subtypes should adjust stats, hooks, or components
		return
	
	// Called when an enchantment is removed from an item
	proc/remove_from_item(obj/item/I)
		// Skeleton: no-op
		return

// Lazy registry of enchantments by id
var/global/list/GLOB_rw_enchants

/proc/ratworld_init_enchantments()
	if(GLOB_rw_enchants)
		return
	var/list/L = list()
	// Examples — these do nothing yet beyond a label. Replace with concrete behavior later.
	var/datum/ratworld/enchantment/E
	E = new /datum/ratworld/enchantment
	E.id = "flaming"
	E.name = "Flaming"
	E.tier = 2
	E.weight = 50
	E.description = "Attacks sear with lingering heat."
	L[E.id] = E
	E = new /datum/ratworld/enchantment
	E.id = "sturdy"
	E.name = "Sturdy"
	E.tier = 1
	E.weight = 80
	E.description = "Slightly tougher and more resilient."
	L[E.id] = E
	E = new /datum/ratworld/enchantment
	E.id = "vorpal"
	E.name = "Vorpal"
	E.tier = 3
	E.weight = 20
	E.description = "Struck foes are felled by uncanny lethality."
	L[E.id] = E
	GLOB_rw_enchants = L

/proc/ratworld_get_enchant_registry()
	ratworld_init_enchantments()
	return GLOB_rw_enchants

/proc/ratworld_get_enchant(id)
	ratworld_init_enchantments()
	return istext(id) ? (GLOB_rw_enchants[id]) : null

// Roll up to N enchantments, unique by id, using weight table.
// Rarity may influence N externally.
/proc/ratworld_roll_enchant_ids(count = 1)
	ratworld_init_enchantments()
	count = max(0, round(count))
	var/list/ids = list()
	if(!count) return ids
	// Build a working weight list excluding chosen ids
	var/list/weights = list()
	for(var/id in GLOB_rw_enchants)
		var/datum/ratworld/enchantment/E = GLOB_rw_enchants[id]
		weights[id] = max(1, E.weight)
	while(ids.len < count && weights.len)
		var/picked = pickweight(weights)
		ids += picked
		weights -= picked
	return ids

// Attach enchantments to an item by id and call apply hooks. Ids are strings.
/proc/ratworld_attach_enchantments(obj/item/I, list/enchant_ids)
	if(!I || !islist(enchant_ids)) return
	I.vars["rw_enchants"] = list()
	// per-enchant rolled values map (id -> number). Optional.
	if(!("rw_enchant_vals" in I.vars) || !islist(I.vars["rw_enchant_vals"]))
		I.vars["rw_enchant_vals"] = list()
	for(var/id in enchant_ids)
		if(!istext(id)) continue
		var/datum/ratworld/enchantment/E = ratworld_get_enchant(id)
		if(!E) continue
		I.vars["rw_enchants"] += id
		E.apply_to_item(I)
		// If a per-slot range exists for this enchant, roll a value using caller-provided slot key if present
		// Expect caller to set I.vars["rw_slot_key"] temporarily when rolling (e.g., "CHEST"), else skip
		var/slot_key = I.vars?["rw_slot_key"]
		if(istext(slot_key))
			var/list/r = ratworld_roll_enchant_value_for_slot(id, slot_key)
			if(islist(r))
				I.vars["rw_enchant_vals"][id] = r["value"]

// Detach enchantments and call remove hooks.
/proc/ratworld_detach_enchantments(obj/item/I)
	if(!I) return
	var/list/ids = I.vars?["rw_enchants"]
	if(!islist(ids)) return
	for(var/id in ids)
		var/datum/ratworld/enchantment/E = ratworld_get_enchant(id)
		if(E) E.remove_from_item(I)
	I.vars["rw_enchants"] = null

// Convenience: roll based on rarity slot count as a starting point
/proc/ratworld_roll_and_attach_enchants(obj/item/I, rarity)
	if(!I) return
	var/count = get_ratworld_rarity_slot_count(rarity)
	if(count <= 0) return
	var/list/ids = ratworld_roll_enchant_ids(min(5, count))
	ratworld_attach_enchantments(I, ids)

// Apply enchantments from current rw_enchants list (e.g., after deserialize)
/proc/ratworld_apply_enchantments(obj/item/I)
	if(!I) return
	var/list/ids = I.vars?["rw_enchants"]
	if(!islist(ids) || !ids.len) return
	for(var/id in ids)
		var/datum/ratworld/enchantment/E = ratworld_get_enchant(id)
		if(E) E.apply_to_item(I)
	// After successful application, if item has a rarity and at least one enchant, tint to rarity color
	if(isnum(I.vars?["rw_rarity"]) && islist(ids) && ids.len)
		var/rc = get_ratworld_rarity_color(I.vars["rw_rarity"]) 
		if(istext(rc))
			I.color = rc

// Roll eligible enchant ids for a given slot key using basic weights
/proc/ratworld_roll_enchant_ids_for_slot(count = 1, slot_key)
	if(!istext(slot_key)) return list()
	ratworld_init_enchantments()
	var/list/candidates = list()
	for(var/id in GLOB_rw_enchants)
		var/list/def = ratworld_get_enchant_def(id)
		if(!islist(def)) continue
		var/list/slots = def["slots"]
		if(islist(slots) && slots[slot_key])
			var/datum/ratworld/enchantment/E = GLOB_rw_enchants[id]
			candidates[id] = max(1, E.weight)
	var/list/picked = list()
	count = max(0, round(count))
	while(picked.len < count && candidates.len)
		var/p = pickweight(candidates)
		picked += p
		candidates -= p
	return picked
