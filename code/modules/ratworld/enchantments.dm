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
	// Temporary bookkeeping for wearer-applied effects
	var/tmp/mob/living/rw_effects_owner = null
	var/tmp/rw_speed_mod_id = null
	var/tmp/rw_as_applied = null
	var/tmp/rw_cs_applied = null
	var/tmp/rw_cdr_applied = null
	var/tmp/rw_mdef_applied = null
	var/tmp/rw_luck_applied = null
	var/tmp/rw_heal_applied = null
	var/tmp/rw_pdr_applied = null
	var/tmp/rw_phys_power_pct_applied = null
	var/tmp/rw_phys_power_flat_applied = null
	var/tmp/rw_true_phys_dmg_pct_applied = null
	var/tmp/rw_armor_dmg_bonus_pct_applied = null
	var/tmp/rw_magic_power_pct_applied = null
	var/tmp/rw_true_magic_dmg_pct_applied = null
	var/tmp/rw_magic_penetration_pct_applied = null
	var/tmp/rw_undead_dmg_pct_applied = null
	var/tmp/rw_demon_dmg_pct_applied = null
	var/tmp/rw_goblin_dmg_pct_applied = null
	var/tmp/rw_buff_duration_pct_applied = null
	var/tmp/rw_debuff_duration_pct_applied = null
	var/tmp/rw_projectile_defense_pct_applied = null
	var/tmp/rw_stat_bonus_key = null
	var/tmp/rw_stat_bonus_applied = null

// Aggregate Ratworld enchant totals stored on living mobs
/mob/living
	var/rw_action_speed_pct_total = 0
	var/rw_cast_speed_pct_total = 0
	var/rw_cdr_pct_total = 0
	var/rw_magic_def_pct_total = 0
	var/rw_luck_pct_total = 0
	var/rw_outgoing_heal_add_total = 0
	var/rw_phys_dmg_reduction_pct_total = 0
	var/rw_phys_power_pct_total = 0
	var/rw_phys_power_flat_total = 0
	var/rw_true_phys_dmg_pct_total = 0
	var/rw_armor_dmg_bonus_pct_total = 0
	var/rw_magic_power_pct_total = 0
	var/rw_true_magic_dmg_pct_total = 0
	var/rw_magic_penetration_pct_total = 0
	var/rw_undead_dmg_pct_total = 0
	var/rw_demon_dmg_pct_total = 0
	var/rw_goblin_dmg_pct_total = 0
	var/rw_buff_duration_pct_total = 0
	var/rw_debuff_duration_pct_total = 0
	var/rw_projectile_defense_pct_total = 0

// (No max-health aggregation anymore; replaced by physical damage reduction aggregation)

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
			// No roller mob here; base rolls remain unbiased
			var/list/r = ratworld_roll_enchant_value_for_slot(id, slot_key, null)
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
	// Do not gate static item effects behind discovery; stats should always apply
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

// Equip handler: apply wearer-side effects
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
	if(!("rw_phys_dmg_reduction_pct_total" in L.vars) || !isnum(L.vars["rw_phys_dmg_reduction_pct_total"])) L.vars["rw_phys_dmg_reduction_pct_total"] = 0
	if(!("rw_phys_power_pct_total" in L.vars) || !isnum(L.vars["rw_phys_power_pct_total"])) L.vars["rw_phys_power_pct_total"] = 0
	if(!("rw_phys_power_flat_total" in L.vars) || !isnum(L.vars["rw_phys_power_flat_total"])) L.vars["rw_phys_power_flat_total"] = 0
	if(!("rw_true_phys_dmg_pct_total" in L.vars) || !isnum(L.vars["rw_true_phys_dmg_pct_total"])) L.vars["rw_true_phys_dmg_pct_total"] = 0
	if(!("rw_armor_dmg_bonus_pct_total" in L.vars) || !isnum(L.vars["rw_armor_dmg_bonus_pct_total"])) L.vars["rw_armor_dmg_bonus_pct_total"] = 0
	if(!("rw_magic_power_pct_total" in L.vars) || !isnum(L.vars["rw_magic_power_pct_total"])) L.vars["rw_magic_power_pct_total"] = 0
	if(!("rw_true_magic_dmg_pct_total" in L.vars) || !isnum(L.vars["rw_true_magic_dmg_pct_total"])) L.vars["rw_true_magic_dmg_pct_total"] = 0
	if(!("rw_magic_penetration_pct_total" in L.vars) || !isnum(L.vars["rw_magic_penetration_pct_total"])) L.vars["rw_magic_penetration_pct_total"] = 0
	if(!("rw_undead_dmg_pct_total" in L.vars) || !isnum(L.vars["rw_undead_dmg_pct_total"])) L.vars["rw_undead_dmg_pct_total"] = 0
	if(!("rw_demon_dmg_pct_total" in L.vars) || !isnum(L.vars["rw_demon_dmg_pct_total"])) L.vars["rw_demon_dmg_pct_total"] = 0
	if(!("rw_goblin_dmg_pct_total" in L.vars) || !isnum(L.vars["rw_goblin_dmg_pct_total"])) L.vars["rw_goblin_dmg_pct_total"] = 0
	if(!("rw_buff_duration_pct_total" in L.vars) || !isnum(L.vars["rw_buff_duration_pct_total"])) L.vars["rw_buff_duration_pct_total"] = 0
	if(!("rw_debuff_duration_pct_total" in L.vars) || !isnum(L.vars["rw_debuff_duration_pct_total"])) L.vars["rw_debuff_duration_pct_total"] = 0
	if(!("rw_projectile_defense_pct_total" in L.vars) || !isnum(L.vars["rw_projectile_defense_pct_total"])) L.vars["rw_projectile_defense_pct_total"] = 0

	// Percent-based and additive bonuses aggregated on wearer
	var/as_add = isnum(vals?["action_speed"]) ? vals["action_speed"] : 0
	var/cs_add = isnum(vals?["spell_casting_speed"]) ? vals["spell_casting_speed"] : 0
	var/cdr_add = isnum(vals?["cooldown_reduction_bonus"]) ? vals["cooldown_reduction_bonus"] : 0
	var/mdef_add = isnum(vals?["magical_defense"]) ? vals["magical_defense"] : 0
	var/pdr_add = isnum(vals?["physical_damage_reduction"]) ? vals["physical_damage_reduction"] : 0
	var/luck_add = isnum(vals?["luck"]) ? vals["luck"] : 0
	var/heal_add = isnum(vals?["outgoing_healing_add"]) ? vals["outgoing_healing_add"] : 0
	var/ppct_add = isnum(vals?["phys_power_bonus"]) ? vals["phys_power_bonus"] : 0
	var/pflat_add = isnum(vals?["phys_power"]) ? vals["phys_power"] : 0
	var/tphys_add = isnum(vals?["true_phys_damage"]) ? vals["true_phys_damage"] : 0
	var/admg_add = isnum(vals?["armor_damage_bonus"]) ? vals["armor_damage_bonus"] : 0
	var/mpow_add = isnum(vals?["magic_power_bonus"]) ? vals["magic_power_bonus"] : 0
	var/tmag_add = isnum(vals?["true_magical_damage"]) ? vals["true_magical_damage"] : 0
	var/mpen_add = isnum(vals?["magic_penetration"]) ? vals["magic_penetration"] : 0
	var/undead_add = isnum(vals?["undead_race_damage_bonus"]) ? vals["undead_race_damage_bonus"] : 0
	var/demon_add = isnum(vals?["demon_race_damage_bonus"]) ? vals["demon_race_damage_bonus"] : 0
	var/goblin_add = isnum(vals?["goblin_race_damage_bonus"]) ? vals["goblin_race_damage_bonus"] : 0
	var/buffdur_add = isnum(vals?["buff_duration_bonus"]) ? vals["buff_duration_bonus"] : 0
	var/debuffdur_add = isnum(vals?["debuff_duration_bonus"]) ? vals["debuff_duration_bonus"] : 0
	var/projdef_add = isnum(vals?["projectile_damage_defense"]) ? vals["projectile_damage_defense"] : 0

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
	if(pdr_add)
		L.vars["rw_phys_dmg_reduction_pct_total"] += pdr_add
		I.rw_pdr_applied = pdr_add
		applied_any = TRUE
	if(ppct_add) { L.vars["rw_phys_power_pct_total"] += ppct_add; I.rw_phys_power_pct_applied = ppct_add; applied_any = TRUE }
	if(pflat_add) { L.vars["rw_phys_power_flat_total"] += pflat_add; I.rw_phys_power_flat_applied = pflat_add; applied_any = TRUE }
	if(tphys_add) { L.vars["rw_true_phys_dmg_pct_total"] += tphys_add; I.rw_true_phys_dmg_pct_applied = tphys_add; applied_any = TRUE }
	if(admg_add) { L.vars["rw_armor_dmg_bonus_pct_total"] += admg_add; I.rw_armor_dmg_bonus_pct_applied = admg_add; applied_any = TRUE }
	if(mpow_add) { L.vars["rw_magic_power_pct_total"] += mpow_add; I.rw_magic_power_pct_applied = mpow_add; applied_any = TRUE }
	if(tmag_add) { L.vars["rw_true_magic_dmg_pct_total"] += tmag_add; I.rw_true_magic_dmg_pct_applied = tmag_add; applied_any = TRUE }
	if(mpen_add) { L.vars["rw_magic_penetration_pct_total"] += mpen_add; I.rw_magic_penetration_pct_applied = mpen_add; applied_any = TRUE }
	if(undead_add) { L.vars["rw_undead_dmg_pct_total"] += undead_add; I.rw_undead_dmg_pct_applied = undead_add; applied_any = TRUE }
	if(demon_add) { L.vars["rw_demon_dmg_pct_total"] += demon_add; I.rw_demon_dmg_pct_applied = demon_add; applied_any = TRUE }
	if(goblin_add) { L.vars["rw_goblin_dmg_pct_total"] += goblin_add; I.rw_goblin_dmg_pct_applied = goblin_add; applied_any = TRUE }
	if(buffdur_add) { L.vars["rw_buff_duration_pct_total"] += buffdur_add; I.rw_buff_duration_pct_applied = buffdur_add; applied_any = TRUE }
	if(debuffdur_add) { L.vars["rw_debuff_duration_pct_total"] += debuffdur_add; I.rw_debuff_duration_pct_applied = debuffdur_add; applied_any = TRUE }
	if(projdef_add) { L.vars["rw_projectile_defense_pct_total"] += projdef_add; I.rw_projectile_defense_pct_applied = projdef_add; applied_any = TRUE }

	// Flat +stat bonus (semi-rare) applied directly to base stats; excluded: LUC
	var/sid = I.vars?["rw_stat_bonus_id"]
	var/sv = I.vars?["rw_stat_bonus_value"]
	if(istext(sid) && isnum(sv) && sv)
		switch(sid)
			if("STR") { L.STASTR += sv; I.rw_stat_bonus_key = "STASTR"; I.rw_stat_bonus_applied = sv; applied_any = TRUE }
			if("SPD") { L.STASPD += sv; I.rw_stat_bonus_key = "STASPD"; I.rw_stat_bonus_applied = sv; applied_any = TRUE }
			if("INT") { L.STAINT += sv; I.rw_stat_bonus_key = "STAINT"; I.rw_stat_bonus_applied = sv; applied_any = TRUE }
			if("WIL") { L.STAWIL += sv; I.rw_stat_bonus_key = "STAWIL"; I.rw_stat_bonus_applied = sv; applied_any = TRUE }
			if("CON") { L.STACON += sv; I.rw_stat_bonus_key = "STACON"; I.rw_stat_bonus_applied = sv; applied_any = TRUE }

	// Clamp totals to design max_total where applicable
	var/list/design_ids = list(
		"action_speed" = "rw_action_speed_pct_total",
		"spell_casting_speed" = "rw_cast_speed_pct_total",
		"cooldown_reduction_bonus" = "rw_cdr_pct_total",
		"magical_defense" = "rw_magic_def_pct_total",
		"physical_damage_reduction" = "rw_phys_dmg_reduction_pct_total",
		"phys_power_bonus" = "rw_phys_power_pct_total",
		"phys_power" = "rw_phys_power_flat_total",
		"true_phys_damage" = "rw_true_phys_dmg_pct_total",
		"armor_damage_bonus" = "rw_armor_dmg_bonus_pct_total",
		"magic_power_bonus" = "rw_magic_power_pct_total",
		"true_magical_damage" = "rw_true_magic_dmg_pct_total",
		"magic_penetration" = "rw_magic_penetration_pct_total",
		"undead_race_damage_bonus" = "rw_undead_dmg_pct_total",
		"demon_race_damage_bonus" = "rw_demon_dmg_pct_total",
		"goblin_race_damage_bonus" = "rw_goblin_dmg_pct_total",
		"outgoing_healing_add" = "rw_outgoing_heal_add_total",
		"buff_duration_bonus" = "rw_buff_duration_pct_total",
		"debuff_duration_bonus" = "rw_debuff_duration_pct_total",
		"luck" = "rw_luck_pct_total"
	)
	for(var/id in design_ids)
		var/list/def = ratworld_get_enchant_def(id)
		if(!islist(def)) continue
		var/list/mx = def["max_total"]
		if(!islist(mx)) continue
		var/limit = mx["value"]
		if(!isnum(limit)) continue
		var/varname = design_ids[id]
		if(!(varname in L.vars)) continue
		var/current = L.vars[varname]
		if(isnum(current) && current > limit)
			L.vars[varname] = limit
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
	if(isnum(I.rw_pdr_applied)) { L.vars["rw_phys_dmg_reduction_pct_total"] -= I.rw_pdr_applied; I.rw_pdr_applied = null }
	if(isnum(I.rw_phys_power_pct_applied)) { L.vars["rw_phys_power_pct_total"] -= I.rw_phys_power_pct_applied; I.rw_phys_power_pct_applied = null }
	if(isnum(I.rw_phys_power_flat_applied)) { L.vars["rw_phys_power_flat_total"] -= I.rw_phys_power_flat_applied; I.rw_phys_power_flat_applied = null }
	if(isnum(I.rw_true_phys_dmg_pct_applied)) { L.vars["rw_true_phys_dmg_pct_total"] -= I.rw_true_phys_dmg_pct_applied; I.rw_true_phys_dmg_pct_applied = null }
	if(isnum(I.rw_armor_dmg_bonus_pct_applied)) { L.vars["rw_armor_dmg_bonus_pct_total"] -= I.rw_armor_dmg_bonus_pct_applied; I.rw_armor_dmg_bonus_pct_applied = null }
	if(isnum(I.rw_magic_power_pct_applied)) { L.vars["rw_magic_power_pct_total"] -= I.rw_magic_power_pct_applied; I.rw_magic_power_pct_applied = null }
	if(isnum(I.rw_true_magic_dmg_pct_applied)) { L.vars["rw_true_magic_dmg_pct_total"] -= I.rw_true_magic_dmg_pct_applied; I.rw_true_magic_dmg_pct_applied = null }
	if(isnum(I.rw_magic_penetration_pct_applied)) { L.vars["rw_magic_penetration_pct_total"] -= I.rw_magic_penetration_pct_applied; I.rw_magic_penetration_pct_applied = null }
	if(isnum(I.rw_undead_dmg_pct_applied)) { L.vars["rw_undead_dmg_pct_total"] -= I.rw_undead_dmg_pct_applied; I.rw_undead_dmg_pct_applied = null }
	if(isnum(I.rw_demon_dmg_pct_applied)) { L.vars["rw_demon_dmg_pct_total"] -= I.rw_demon_dmg_pct_applied; I.rw_demon_dmg_pct_applied = null }
	if(isnum(I.rw_goblin_dmg_pct_applied)) { L.vars["rw_goblin_dmg_pct_total"] -= I.rw_goblin_dmg_pct_applied; I.rw_goblin_dmg_pct_applied = null }
	if(isnum(I.rw_buff_duration_pct_applied)) { L.vars["rw_buff_duration_pct_total"] -= I.rw_buff_duration_pct_applied; I.rw_buff_duration_pct_applied = null }
	if(isnum(I.rw_debuff_duration_pct_applied)) { L.vars["rw_debuff_duration_pct_total"] -= I.rw_debuff_duration_pct_applied; I.rw_debuff_duration_pct_applied = null }
	if(isnum(I.rw_projectile_defense_pct_applied)) { L.vars["rw_projectile_defense_pct_total"] -= I.rw_projectile_defense_pct_applied; I.rw_projectile_defense_pct_applied = null }
	if(isnum(I.rw_luck_applied)) { L.vars["rw_luck_pct_total"] -= I.rw_luck_applied; I.rw_luck_applied = null }
	if(isnum(I.rw_heal_applied)) { L.vars["rw_outgoing_heal_add_total"] -= I.rw_heal_applied; I.rw_heal_applied = null }

	// Revert +stat bonus if applied
	if(istext(I.rw_stat_bonus_key) && isnum(I.rw_stat_bonus_applied))
		if(I.rw_stat_bonus_key == "STASTR") L.STASTR -= I.rw_stat_bonus_applied
		else if(I.rw_stat_bonus_key == "STASPD") L.STASPD -= I.rw_stat_bonus_applied
		else if(I.rw_stat_bonus_key == "STAINT") L.STAINT -= I.rw_stat_bonus_applied
		else if(I.rw_stat_bonus_key == "STAWIL") L.STAWIL -= I.rw_stat_bonus_applied
		else if(I.rw_stat_bonus_key == "STACON") L.STACON -= I.rw_stat_bonus_applied
		I.rw_stat_bonus_key = null
		I.rw_stat_bonus_applied = null

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

// Semi-rare: roll an item +STAT bonus (excluded: Fortune/Luck). Any gear can roll. Not socketable.
/proc/ratworld_maybe_roll_item_stat_bonus(obj/item/I)
	if(!I) return
	// Eligible gear types
	if(!(istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/bow) || istype(I, /obj/item/clothing)))
		return
	// Do not re-roll if already has a bonus
	if(istext(I.vars?["rw_stat_bonus_id"])) return
	// ~12% overall chance to gain +stat; 5% of those are +2, otherwise +1
	if(!prob(12)) return
	var/val = prob(5) ? 2 : 1
	// Choose among STR, SPD, INT, WIL, CON (exclude LUC)
	var/list/cands = list("STR", "SPD", "INT", "WIL", "CON")
	var/sid = pick(cands)
	I.vars["rw_stat_bonus_id"] = sid
	I.vars["rw_stat_bonus_value"] = val

// Helper accessors for systems to consume aggregated wearer bonuses safely
/proc/ratworld_get_action_speed_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_action_speed_pct_total"]
	if(!isnum(v)) v = 0
	// Cap can be tuned per design; keep reasonable default
	v = clamp(v, -90, 100)
	return max(0.1, 1 + (v / 100))

/proc/ratworld_get_cast_speed_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_cast_speed_pct_total"]
	if(!isnum(v)) v = 0
	v = clamp(v, -90, 100)
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
	// Sheet cap is 75% resist -> min multiplier 0.25
	return clamp(1 - (v / 100), 0.25, 1)

// Physical damage reduction multiplier (caps at 16% reduction)
/proc/ratworld_get_phys_defense_mult(mob/living/L)
	if(!isliving(L)) return 1
	var/v = L.vars?["rw_phys_dmg_reduction_pct_total"]
	if(!isnum(v)) v = 0
	v = min(v, 16)
	return clamp(1 - (v / 100), 0.84, 1)

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

// Build a concise Applied Effects panel section line-by-line
/mob/living/proc/ratworld_statpanel_applied_effects()
	// Vertical list; only show acquired (non-zero) totals
	var/list/show = list(
		"Action Speed" = vars?["rw_action_speed_pct_total"],
		"Cast Speed" = vars?["rw_cast_speed_pct_total"],
		"Cooldown Reduction" = vars?["rw_cdr_pct_total"],
		"Magical Defense" = vars?["rw_magic_def_pct_total"],
		"Physical Damage Reduction" = vars?["rw_phys_dmg_reduction_pct_total"],
		"Phys Power Flat" = vars?["rw_phys_power_flat_total"],
		"Phys Power Bonus" = vars?["rw_phys_power_pct_total"],
		"True Phys Damage" = vars?["rw_true_phys_dmg_pct_total"],
		"Magic Power Bonus" = vars?["rw_magic_power_pct_total"],
		"True Magical Damage" = vars?["rw_true_magic_dmg_pct_total"],
		"Magic Penetration" = vars?["rw_magic_penetration_pct_total"],
		"Undead Damage Bonus" = vars?["rw_undead_dmg_pct_total"],
		"Demon Damage Bonus" = vars?["rw_demon_dmg_pct_total"],
		"Goblin Damage Bonus" = vars?["rw_goblin_dmg_pct_total"],
		"Buff Duration Bonus" = vars?["rw_buff_duration_pct_total"],
		"Debuff Duration Bonus" = vars?["rw_debuff_duration_pct_total"],
		"Projectile Defense" = vars?["rw_projectile_defense_pct_total"],
		"Luck" = vars?["rw_luck_pct_total"],
		"Outgoing Heal Add" = vars?["rw_outgoing_heal_add_total"]
	)
	var/any = FALSE
	stat("Applied Stats:")
	for(var/label in show)
		var/val = show[label]
		if(!isnum(val) || val == 0) continue
		var/is_percent = TRUE
		if(findtext(label, "Flat") || findtext(label, "Heal Add")) is_percent = FALSE
		var/suffix = is_percent ? "%" : ""
		stat("- [label]", "[round(val, 0.1)][suffix]")
		any = TRUE
	if(!any)
		stat("- None")

// Helpers to compute outgoing damage contributions per clarified design
// Physical: final_base = (base + phys_power_flat*5) * (1 + phys_power_pct/100)
// Returns list(normal = portion (subject to armor), true = portion (bypasses armor))
/proc/ratworld_split_phys_damage(mob/living/attacker, base)
	if(!isliving(attacker)) return list("normal" = base, "true" = 0)
	var/flat = attacker.vars?["rw_phys_power_flat_total"]; if(!isnum(flat)) flat = 0
	var/pct = attacker.vars?["rw_phys_power_pct_total"]; if(!isnum(pct)) pct = 0
	var/truepct = attacker.vars?["rw_true_phys_dmg_pct_total"]; if(!isnum(truepct)) truepct = 0
	var/final_base = (base + (flat * 5)) * (1 + (pct / 100))
	var/true_part = max(0, final_base * (truepct / 100))
	var/normal_part = max(0, final_base - true_part)
	return list("normal" = normal_part, "true" = true_part)

// Magic: final_base = base * (1 + magic_power_pct/100). True magic is portion of final_base.
// Magic pen reduces target's magical defense (subtractive). If target has 0 mdef, pen amplifies by +pen%.
/proc/ratworld_compute_magic_multiplier(mob/living/attacker, mob/living/target)
	var/pow = attacker?.vars?["rw_magic_power_pct_total"]; if(!isnum(pow)) pow = 0
	var/base_mult = 1 + (pow / 100)
	var/mdef = target?.vars?["rw_magic_def_pct_total"]; if(!isnum(mdef)) mdef = 0
	var/pen = attacker?.vars?["rw_magic_penetration_pct_total"]; if(!isnum(pen)) pen = 0
	pen = clamp(pen, 0, 30) // per sheet
	mdef = clamp(mdef, 0, 75)
	var/effective_mdef = max(0, mdef - pen)
	var/def_mult = 1 - (effective_mdef / 100)
	if(mdef <= 0 && pen > 0)
		def_mult = 1 + (pen / 100)
	return base_mult * def_mult

// Magic true portion helper
/proc/ratworld_get_true_magic_pct(mob/living/attacker)
	var/t = attacker?.vars?["rw_true_magic_dmg_pct_total"]
	return isnum(t) ? t : 0
