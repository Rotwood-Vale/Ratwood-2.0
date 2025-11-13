// Ratworld enchantment system skeleton
// Provides a base datum, a global registry, and helpers to roll/apply enchantments to items.

// Base enchantment datum
/datum/ratworld/enchantment
	var/id = ""
	var/name = "Unnamed"
	var/tier = 1 // loosely aligned with rarity tiers, can be independent
	var/weight = 100 // roll weight
	var/description = null

/datum/ratworld/enchantment/proc/apply_to_item(obj/item/I)
	// Skeleton: no-op; concrete subtypes should adjust stats, hooks, or components
	return

/datum/ratworld/enchantment/proc/remove_from_item(obj/item/I)
	// Skeleton: no-op
	return

// Lazy registry of enchantments by id
var/global/list/GLOB_rw_enchants

// Per-item temporary bookkeeping for wearer-applied effects
/obj/item
	var/tmp/mob/living/rw_effects_owner = null
	var/tmp/rw_speed_mod_id = null
	var/tmp/rw_as_applied = null
	var/tmp/rw_cs_applied = null
	var/tmp/rw_cdr_applied = null
	var/tmp/rw_mdef_applied = null
	var/tmp/rw_luck_applied = null
	var/tmp/rw_heal_applied = null

/proc/ratworld_init_enchantments()
	if(GLOB_rw_enchants)
		return
	var/list/L = list()
	// Build registry from established enchant definitions so rolls use the proper pool
	for(var/id in GLOB.rw_enchant_defs)
		var/list/def = GLOB.rw_enchant_defs[id]
		if(!islist(def)) continue
		var/datum/ratworld/enchantment/E = new /datum/ratworld/enchantment
		E.id = "[id]"
		E.name = def?["name"] ? def["name"] : "[id]"
		// Optional per-enchant weight in defs; default to 100 if not present
		var/w = def?["weight"]
		E.weight = isnum(w) ? w : 100
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

	// Ensure generic handlers and persistent item-side effects are installed once
	ratworld_register_item_enchant_handlers(I)
	ratworld_apply_item_static_effects(I)

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
	// Install handlers and static effects (idempotent)
	ratworld_register_item_enchant_handlers(I)
	ratworld_apply_item_static_effects(I)
	// Ensure examine name-line is colored by rarity (dupe-safe via component dupe_mode)
	I.AddComponent(/datum/component/ratworld_rarity_namecolor)

// Register one-time equip/drop handlers for wearer-applied effects
/proc/ratworld_register_item_enchant_handlers(obj/item/I)
	if(!I) return
	if(I.vars?["rw_ench_handlers_registered"]) return
	// Attach a tiny component that manages equip/drop signals
	I.AddComponent(/datum/component/ratworld_enchant_handler)
	I.vars["rw_ench_handlers_registered"] = TRUE

// Component to manage signal hooks for enchant wearer effects
/datum/component/ratworld_enchant_handler

/datum/component/ratworld_enchant_handler/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	// Apply wearer effects when picked up into hands too (weapons/jewelry held but not slotted)
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/datum/component/ratworld_enchant_handler/Destroy()
	if(parent)
		UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_PICKUP, COMSIG_ITEM_DROPPED))
	return ..()

/datum/component/ratworld_enchant_handler/proc/on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(isitem(source) && isliving(equipper))
		ratworld_apply_wearer_effects(source, equipper)

/datum/component/ratworld_enchant_handler/proc/on_pickup(datum/source, mob/user)
	SIGNAL_HANDLER
	if(isitem(source) && isliving(user))
		ratworld_apply_wearer_effects(source, user)

/datum/component/ratworld_enchant_handler/proc/on_drop(datum/source, mob/user)
	SIGNAL_HANDLER
	if(isitem(source) && isliving(user))
		ratworld_revert_wearer_effects(source, user)

// Static, item-owned effects that should persist regardless of equip (idempotent)
/proc/ratworld_apply_item_static_effects(obj/item/I)
	if(!I) return
	if(I.vars && ("rw_discovered" in I.vars) && !I.vars["rw_discovered"]) return
	if(!islist(I.vars?["rw_enchants"])) return
	if(!islist(I.vars?["rw_enchant_vals"])) return
	if(!islist(I.vars?["rw_item_static_applied"])) I.vars["rw_item_static_applied"] = list()

	var/list/applied = I.vars["rw_item_static_applied"]
	// Armor rating add: attach a bonus armor datum to the item's armor, once
	if(("armor_rating_add" in I.vars["rw_enchant_vals"]))
		if(!applied?["armor_rating_add"])
			var/val = I.vars["rw_enchant_vals"]["armor_rating_add"]
			if(isnum(val) && val)
				// Ensure armor is a datum
				if(islist(I.armor) || isnull(I.armor))
					I.armor = getArmor(arglist(I.armor))
				var/datum/armor/bonus = getArmor(val, val, val, val, val, val, val)
				I.vars["rw_bonus_armor"] = bonus
				I.armor = I.armor.attachArmor(bonus)
				applied["armor_rating_add"] = TRUE

	// Durability add: increase max_integrity by percentage and scale current integrity once
	if(("durability_add" in I.vars["rw_enchant_vals"]))
		if(!applied?["durability_add"]) // only once
			var/perc = I.vars["rw_enchant_vals"]["durability_add"]
			if(isnum(perc) && perc && isnum(I.max_integrity) && I.max_integrity > 0)
				var/oldMax = I.max_integrity
				var/ratio = (isnum(I.obj_integrity) && oldMax > 0) ? (I.obj_integrity / oldMax) : 1
				var/newMax = round(oldMax * (1 + (perc / 100)))
				I.max_integrity = max(1, newMax)
				if(isnum(I.obj_integrity))
					I.obj_integrity = clamp(round(I.max_integrity * ratio), 0, I.max_integrity)
				applied["durability_add"] = TRUE

// Equip handler: apply wearer-side effects (max health, etc.)
/proc/ratworld_ench_on_equip(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(!isitem(source)) return
	if(!isliving(equipper)) return
	ratworld_apply_wearer_effects(source, equipper)

// Drop handler: revert wearer-side effects applied by this item
/proc/ratworld_ench_on_drop(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!isitem(source)) return
	if(!isliving(user)) return
	ratworld_revert_wearer_effects(source, user)

// Compute and apply wearer-side aggregate effects for this item
/proc/ratworld_apply_wearer_effects(obj/item/I, mob/living/L)
	if(!I || !L) return
	if(I.vars && ("rw_discovered" in I.vars) && !I.vars["rw_discovered"]) return
	var/list/ids = I.vars?["rw_enchants"]
	var/list/vals = I.vars?["rw_enchant_vals"]
	if(!islist(ids) || !islist(vals)) return

	// Prevent double-application: if already applied to this same wearer, skip
	if(I.rw_effects_owner && I.rw_effects_owner == L)
		return
	// If applied to a different wearer, revert first
	if(I.rw_effects_owner && I.rw_effects_owner != L)
		var/mob/living/prev = I.rw_effects_owner
		if(prev)
			ratworld_revert_wearer_effects(I, prev)

	var/flat_hp = 0
	var/pct_hp = 0
	if("max_health_add" in ids || vals?["max_health_add"]) // tolerate legacy states
		var/v = vals?["max_health_add"]
		if(isnum(v)) flat_hp += v
	if("max_health_bonus" in ids || vals?["max_health_bonus"]) 
		var/b = vals?["max_health_bonus"]
		if(isnum(b)) pct_hp += b

	// Store applied amounts for clean reversal
	I.vars["rw_hp_flat_applied"] = flat_hp
	I.vars["rw_hp_pct_applied"] = pct_hp

	if(flat_hp || pct_hp)
		var/oldMax = L.getMaxHealth()
		var/newMax = oldMax
		if(flat_hp)
			newMax = newMax + flat_hp
		if(pct_hp)
			newMax = round(newMax * (1 + (pct_hp / 100)))
		newMax = max(1, newMax)
		// preserve current health ratio
		var/ratio = (oldMax > 0) ? (L.health / oldMax) : 1
		L.setMaxHealth(newMax)
		if(isnum(L.health))
			L.health = clamp(round(newMax * ratio), 1, newMax)
	I.rw_effects_owner = L

	// Track whether we applied any non-HP wearer effects to ensure owner marker is set
	var/applied_any = FALSE

	// Movement speed (speed_flat): apply a movespeed modifier tied to this item
	if(isnum(vals?["speed_flat"]))
		var/sv = vals["speed_flat"]
		if(sv)
			var/ms_id = "RW_SPEED:[REF(I)]"
			I.rw_speed_mod_id = ms_id
			// Modest speedup per point: -0.05 multiplicative slowdown each point (e.g., +4 => -0.20)
			var/mult = -(sv * 0.05)
			L.add_movespeed_modifier(ms_id, multiplicative_slowdown = mult)
			applied_any = TRUE

	// Initialize aggregate totals on the wearer if missing
	if(!("rw_action_speed_pct_total" in L.vars) || !isnum(L.vars["rw_action_speed_pct_total"])) L.vars["rw_action_speed_pct_total"] = 0
	if(!("rw_cast_speed_pct_total" in L.vars) || !isnum(L.vars["rw_cast_speed_pct_total"])) L.vars["rw_cast_speed_pct_total"] = 0
	if(!("rw_cdr_pct_total" in L.vars) || !isnum(L.vars["rw_cdr_pct_total"])) L.vars["rw_cdr_pct_total"] = 0
	if(!("rw_magic_def_pct_total" in L.vars) || !isnum(L.vars["rw_magic_def_pct_total"])) L.vars["rw_magic_def_pct_total"] = 0
	if(!("rw_luck_pct_total" in L.vars) || !isnum(L.vars["rw_luck_pct_total"])) L.vars["rw_luck_pct_total"] = 0
	if(!("rw_outgoing_heal_add_total" in L.vars) || !isnum(L.vars["rw_outgoing_heal_add_total"])) L.vars["rw_outgoing_heal_add_total"] = 0

	// Percent-based and additive bonuses aggregated on wearer
	var/as_add = isnum(vals?["action_speed"]) ? vals["action_speed"] : 0
	var/cs_add = isnum(vals?["spell_casting_speed"]) ? vals["spell_casting_speed"] : 0
	var/cdr_add = isnum(vals?["cooldown_reduction_bonus"]) ? vals["cooldown_reduction_bonus"] : 0
	var/mdef_add = isnum(vals?["magical_defense"]) ? vals["magical_defense"] : 0
	var/luck_add = isnum(vals?["luck"]) ? vals["luck"] : 0
	var/heal_add = isnum(vals?["outgoing_healing_add"]) ? vals["outgoing_healing_add"] : 0

	if(as_add)
		L.vars["rw_action_speed_pct_total"] += as_add
		I.rw_as_applied = as_add
		applied_any = TRUE
	if(cs_add)
		L.vars["rw_cast_speed_pct_total"] += cs_add
		I.rw_cs_applied = cs_add
		applied_any = TRUE
	if(cdr_add)
		L.vars["rw_cdr_pct_total"] += cdr_add
		I.rw_cdr_applied = cdr_add
		applied_any = TRUE
	if(mdef_add)
		L.vars["rw_magic_def_pct_total"] += mdef_add
		I.rw_mdef_applied = mdef_add
		applied_any = TRUE
	if(luck_add)
		L.vars["rw_luck_pct_total"] += luck_add
		I.rw_luck_applied = luck_add
		applied_any = TRUE
	if(heal_add)
		L.vars["rw_outgoing_heal_add_total"] += heal_add
		I.rw_heal_applied = heal_add
		applied_any = TRUE

	// Ensure we set the owner marker if we applied any effects even without HP changes
	if(applied_any && (!I.rw_effects_owner || I.rw_effects_owner != L))
		I.rw_effects_owner = L

// Revert wearer-side effects applied by this item
/proc/ratworld_revert_wearer_effects(obj/item/I, mob/living/L)
	if(!I || !L) return
	var/flat_hp = I.vars?["rw_hp_flat_applied"]
	var/pct_hp = I.vars?["rw_hp_pct_applied"]
	if(!isnum(flat_hp)) flat_hp = 0
	if(!isnum(pct_hp)) pct_hp = 0
	// Revert HP contributions if any
	if(flat_hp || pct_hp)
		var/oldMax = L.getMaxHealth()
		var/newMax = oldMax
		if(pct_hp)
			newMax = round(newMax / (1 + (pct_hp / 100)))
		if(flat_hp)
			newMax = newMax - flat_hp
		newMax = max(1, newMax)
		var/ratio = (oldMax > 0) ? (L.health / oldMax) : 1
		L.setMaxHealth(newMax)
		if(isnum(L.health))
			L.health = clamp(round(newMax * ratio), 1, newMax)
		// clear markers
		I.vars["rw_hp_flat_applied"] = null
		I.vars["rw_hp_pct_applied"] = null

	// Remove movespeed modifier if present
	var/ms_id = I.rw_speed_mod_id
	if(istext(ms_id))
		L.remove_movespeed_modifier(ms_id)
		I.rw_speed_mod_id = null

	// Revert aggregate totals applied from this item
	if(isnum(I.rw_as_applied)) { L.vars["rw_action_speed_pct_total"] -= I.rw_as_applied; I.rw_as_applied = null }
	if(isnum(I.rw_cs_applied)) { L.vars["rw_cast_speed_pct_total"] -= I.rw_cs_applied; I.rw_cs_applied = null }
	if(isnum(I.rw_cdr_applied)) { L.vars["rw_cdr_pct_total"] -= I.rw_cdr_applied; I.rw_cdr_applied = null }
	if(isnum(I.rw_mdef_applied)) { L.vars["rw_magic_def_pct_total"] -= I.rw_mdef_applied; I.rw_mdef_applied = null }
	if(isnum(I.rw_luck_applied)) { L.vars["rw_luck_pct_total"] -= I.rw_luck_applied; I.rw_luck_applied = null }
	if(isnum(I.rw_heal_applied)) { L.vars["rw_outgoing_heal_add_total"] -= I.rw_heal_applied; I.rw_heal_applied = null }

	if(I.rw_effects_owner == L)
		I.rw_effects_owner = null

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

// Helper accessors for systems to consume aggregated wearer bonuses safely
/proc/ratworld_get_action_speed_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_action_speed_pct_total"]
	if(!isnum(v)) v = 0
	return max(0.1, 1 + (v / 100))

/proc/ratworld_get_cast_speed_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_cast_speed_pct_total"]
	if(!isnum(v)) v = 0
	return max(0.1, 1 + (v / 100))

/proc/ratworld_get_cooldown_reduction_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_cdr_pct_total"]
	if(!isnum(v)) v = 0
	// e.g., 20% CDR => multiply cooldowns by 0.8
	return clamp(1 - (v / 100), 0.2, 1)

/proc/ratworld_get_magic_defense_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_magic_def_pct_total"]
	if(!isnum(v)) v = 0
	// e.g., 10% magic defense reduces magical damage by 10%
	return clamp(1 - (v / 100), 0.5, 1)

/proc/ratworld_get_luck_pct(mob/living/L)
	if(!isliving(L)) return 0
	var/v = L.vars?["rw_luck_pct_total"]
	return isnum(v) ? v : 0

/proc/ratworld_get_outgoing_heal_add(mob/living/L)
	if(!isliving(L)) return 0
	var/v = L.vars?["rw_outgoing_heal_add_total"]
	return isnum(v) ? v : 0

// Ensure wearer effects are applied for any enchanted items currently in contents (e.g., on login)
/mob/living/proc/ratworld_refresh_wearer_effects()
	for(var/obj/item/I as anything in contents)
		if(!I) continue
		if(I.vars && ("rw_discovered" in I.vars) && !I.vars["rw_discovered"]) continue
		if(!islist(I.vars?["rw_enchants"])) continue
		// Apply wearer effects if not already attributed to this mob
		if(!(I.rw_effects_owner && I.rw_effects_owner == src))
			ratworld_apply_wearer_effects(I, src)
