// Ratworld item rarity definitions and utilities
// Provides structured rarity tiers for gear and gems, including attribute slot counts.
// Rarities (in order): Common, Magic, Rare, Epic, Legendary, Unique, Artifact, Ascendant (placeholder)

// Numeric constants (stable; never reorder without migration!)
#ifndef RW_RARITY_MACROS_DEFINED
#define RW_RARITY_MACROS_DEFINED
#define RW_RARITY_COMMON 1
#define RW_RARITY_MAGIC 2
#define RW_RARITY_RARE 3
#define RW_RARITY_EPIC 4
#define RW_RARITY_LEGENDARY 5
#define RW_RARITY_UNIQUE 6
#define RW_RARITY_ARTIFACT 7
#define RW_RARITY_ASCENDANT 8 // ??? endgame / chapter defining
#endif

// Attribute slot counts per design (Common has 0, Magic 1, Rare 2, Epic 3, Legendary 4, Unique 5, Artifact 6, Ascendant TBD -> 6 + special)
GLOBAL_LIST_INIT(rw_rarity_info, list(
	RW_RARITY_COMMON = list("name" = "Common", "attr_slots" = 0, "special" = FALSE),
	RW_RARITY_MAGIC = list("name" = "Magic", "attr_slots" = 1, "special" = FALSE),
	RW_RARITY_RARE = list("name" = "Rare", "attr_slots" = 2, "special" = FALSE),
	RW_RARITY_EPIC = list("name" = "Epic", "attr_slots" = 3, "special" = FALSE),
	RW_RARITY_LEGENDARY = list("name" = "Legendary", "attr_slots" = 4, "special" = FALSE),
	RW_RARITY_UNIQUE = list("name" = "Unique", "attr_slots" = 5, "special" = FALSE),
	RW_RARITY_ARTIFACT = list("name" = "Artifact", "attr_slots" = 6, "special" = TRUE),
	RW_RARITY_ASCENDANT = list("name" = "Ascendant", "attr_slots" = 7, "special" = TRUE, "ascendant" = TRUE)
))

// Weight table placeholder (tunable; Artifact+ extremely rare, Ascendant effectively disabled until enabled)
GLOBAL_LIST_INIT(rw_rarity_weights, list())

/proc/initialize_rw_rarity_weights()
	if(!GLOB.rw_rarity_weights.len)
		GLOB.rw_rarity_weights = list(
			RW_RARITY_COMMON = 1000,
			RW_RARITY_MAGIC = 350,
			RW_RARITY_RARE = 120,
			RW_RARITY_EPIC = 40,
			RW_RARITY_LEGENDARY = 12,
			RW_RARITY_UNIQUE = 4,
			RW_RARITY_ARTIFACT = 1,
			RW_RARITY_ASCENDANT = 0,
		)

// Returns rarity list datum

/proc/get_ratworld_rarity_info(var/rarity)
	return GLOB.rw_rarity_info?[rarity]

// Human-readable name
/proc/get_ratworld_rarity_name(rarity)
	var/list/info = get_ratworld_rarity_info(rarity)
	return info?info["name"]:"Unknown"

// Attribute slot count
/proc/get_ratworld_rarity_slot_count(rarity)
	var/list/info = get_ratworld_rarity_info(rarity)
	return info?info["attr_slots"]:0

// UI color mapping for rarity text
/proc/get_ratworld_rarity_color(rarity)
	switch(rarity)
		if(RW_RARITY_COMMON) return "#bfbfbf" // gray
		if(RW_RARITY_MAGIC) return "#6ec1ff" // light blue
		if(RW_RARITY_RARE) return "#d4b000" // darker yellow
		if(RW_RARITY_EPIC) return "#9b59b6" // purple
		if(RW_RARITY_LEGENDARY) return "#f39c12" // orange
		if(RW_RARITY_UNIQUE) return "#b8860b" // golden brown
		if(RW_RARITY_ARTIFACT) return "#e74c3c" // red
		if(RW_RARITY_ASCENDANT) return "#6c2bd9" // void purple
	return "#bfbfbf"

// Roll a rarity given weights (overrideable with custom list)

/proc/ratworld_roll_rarity(var/list/custom_weights)
	var/list/w = custom_weights ? custom_weights : GLOB.rw_rarity_weights
	return pickweight(w)

// Magic Find-aware rarity roll: biases weights toward higher tiers based on wearer's Magic Find
// MF is aggregated on the wearer as rw_magic_find_pct_total. Effect is modest and capped.
/proc/ratworld_roll_rarity_with_mf(mob/living/roller, var/list/custom_weights)
	var/list/base = custom_weights ? custom_weights : GLOB.rw_rarity_weights
	if(!islist(base) || !base.len)
		return ratworld_roll_rarity(custom_weights)
	var/mf = 0
	if(isliving(roller))
		mf = roller.vars?["rw_magic_find_pct_total"]
		if(!isnum(mf)) mf = 0
	// Clamp MF influence to a sane range
	var/bias = clamp(mf / 100, 0, 1)
	var/list/w = list()
	// Apply tier-specific multipliers; reduce Common slightly, boost higher tiers progressively
	for(var/tier in base)
		var/mult = 1.0
		switch(tier)
			if(RW_RARITY_COMMON)     mult = 1 - (0.5 * bias)
			if(RW_RARITY_MAGIC)      mult = 1 + (0.10 * bias)
			if(RW_RARITY_RARE)       mult = 1 + (0.20 * bias)
			if(RW_RARITY_EPIC)       mult = 1 + (0.40 * bias)
			if(RW_RARITY_LEGENDARY)  mult = 1 + (0.60 * bias)
			if(RW_RARITY_UNIQUE)     mult = 1 + (0.80 * bias)
			if(RW_RARITY_ARTIFACT)   mult = 1 + (1.00 * bias)
			if(RW_RARITY_ASCENDANT)  mult = 1 + (1.20 * bias)
		var/val = base[tier]
		if(!isnum(val)) continue
		// Keep zero-weight tiers zero
		if(val <= 0)
			w[tier] = val
		else
			w[tier] = max(1, round(val * mult))
	return pickweight(w)

// Whether rarity has special effect field
/proc/ratworld_rarity_has_special(rarity)
	var/list/info = get_ratworld_rarity_info(rarity)
	return info && info["special"]

// Placeholder hook to attach special effect blueprint for Artifact/Ascendant
/proc/ratworld_generate_special_effect(rarity)
	if(!ratworld_rarity_has_special(rarity))
		return null
	if(rarity == RW_RARITY_ARTIFACT)
		// Return a descriptor; real implementation will attach an effect component later
		return list(id = "artifact_effect", desc = "Artifact radiates a forgotten power.")
	if(rarity == RW_RARITY_ASCENDANT)
		return list(id = "ascendant_effect", desc = "Reality bends faintly around this item.")
	return null

// Basic examine string builder for an item having a stored rarity var/rarity_tier
/proc/ratworld_format_rarity_examine(var/rarity_tier)
	var/name = get_ratworld_rarity_name(rarity_tier)
	var/list/info = get_ratworld_rarity_info(rarity_tier)
	var/text = "<span class='italics'>Rarity:</span> [name]"
	if(info && info["ascendant"]) text += " - <span class='danger'>ASCENDANT</span>"
	else if(info && info["special"]) text += " - <span class='notice'>Special</span>"
	return text

// Future: migration proc to adjust rarities across persisted items.
/proc/ratworld_rarity_migrate(var/list/item_data)
	// stub: ensure attr_slots matches current schema
	for(var/entry in item_data)
		if(islist(entry))
			var/list/E = entry
			if(E["rarity"])
				E["attr_slots"] = get_ratworld_rarity_slot_count(E["rarity"]) // sync
	return item_data

// Compute the minimal rarity tier that can accommodate a given number of enchantments
/proc/ratworld_min_rarity_for_enchants(var/count)
	if(!isnum(count) || count <= 0)
		return RW_RARITY_COMMON
	for(var/r in list(RW_RARITY_COMMON, RW_RARITY_MAGIC, RW_RARITY_RARE, RW_RARITY_EPIC, RW_RARITY_LEGENDARY, RW_RARITY_UNIQUE, RW_RARITY_ARTIFACT, RW_RARITY_ASCENDANT))
		if(get_ratworld_rarity_slot_count(r) >= count)
			return r
	return RW_RARITY_ASCENDANT
