// Ratworld Inscription skill system
// Allows players to level up Inscription skill and purchase enhancement nodes
// to unlock the ability to apply enhancements to gear.

// Global node tree definition
var/global/list/GLOB.rw_inscription_nodes

/proc/ratworld_init_inscription_nodes()
	if(GLOB.rw_inscription_nodes)
		return
	GLOB.rw_inscription_nodes = list(
		// Example nodes: id, cost_xp, required_level, enhancement_id, tier
		// Enhancement_id should map to an entry in GLOB.rw_enchant_defs or similar
		"phys_power_bonus" = list(
			"id" = "phys_power_bonus",
			"cost_xp" = 100,
			"required_level" = 1,
			"enhancement_id" = "phys_power_bonus",
			"tier" = 1
		),
		"magic_power_bonus" = list(
			"id" = "magic_power_bonus",
			"cost_xp" = 150,
			"required_level" = 2,
			"enhancement_id" = "magic_power_bonus",
			"tier" = 2
		),
		// Add more nodes with tiers
	)

// Datum for persistent inscription skill data
/datum/ratworld/inscription_skill
	var/ckey
	var/xp = 0
	var/list/purchased_nodes = list()

/datum/ratworld/inscription_skill/New(_ckey)
	..()
	ckey = lowertext(_ckey)
	Load()

/datum/ratworld/inscription_skill/proc/get_path()
	var/ch = copytext(ckey, 1, 2)
	return "data/player_saves/[ch]/[ckey]/ratworld/inscription.json"

/datum/ratworld/inscription_skill/proc/Load()
	var/path = get_path()
	if(!fexists(path))
		return // No save file yet
	var/json = file2text(path)
	if(!json) return
	var/list/data = json_decode(json)
	if(!islist(data)) return
	xp = data["xp"] || 0
	purchased_nodes = data["purchased_nodes"] || list()

/datum/ratworld/inscription_skill/proc/Save()
	var/path = get_path()
	var/list/data = list(
		"xp" = xp,
		"purchased_nodes" = purchased_nodes
	)
	var/json = json_encode(data)
	fdel(path)
	text2file(json, path)

// Global cache of per-ckey inscription skill datums
var/global/list/GLOB.rw_inscription_skills = list()

/proc/ratworld_get_inscription_skill(ckey)
	ckey = lowertext(ckey)
	if(!(ckey in GLOB.rw_inscription_skills))
		GLOB.rw_inscription_skills[ckey] = new /datum/ratworld/inscription_skill(ckey)
	return GLOB.rw_inscription_skills[ckey]

// Mob vars for Inscription skill (transient, loaded from datum)
/mob/living
	var/tmp/rw_inscription_xp = 0
	var/tmp/list/rw_inscription_purchased_nodes = list()

// Load inscription data for this mob
/mob/living/proc/ratworld_load_inscription()
	var/ckey = src.ckey
	if(!ckey) return
	var/datum/ratworld/inscription_skill/S = ratworld_get_inscription_skill(ckey)
	rw_inscription_xp = S.xp
	rw_inscription_purchased_nodes = S.purchased_nodes.Copy()

// Save inscription data for this mob
/mob/living/proc/ratworld_save_inscription()
	var/ckey = src.ckey
	if(!ckey) return
	var/datum/ratworld/inscription_skill/S = ratworld_get_inscription_skill(ckey)
	S.xp = rw_inscription_xp
	S.purchased_nodes = rw_inscription_purchased_nodes.Copy()
	S.Save()

// Proc to get current Inscription level (e.g., based on XP)
/proc/inscription_get_level(mob/living/M)
	if(!isliving(M)) return 0
	// Simple level calculation: level = floor(sqrt(XP / 100)) + 1
	// Adjust formula as needed for balance
	var/xp = M.rw_inscription_xp
	return max(1, round(sqrt(xp / 100)) + 1)

// Proc to add XP to Inscription skill
/proc/inscription_add_xp(mob/living/M, amount)
	if(!isliving(M) || amount <= 0) return
	M.rw_inscription_xp += amount
	M.ratworld_save_inscription() // Save immediately
	// Optional: emit level-up message or event
	var/new_level = inscription_get_level(M)
	// TODO: handle level-up notifications if desired

// Proc to check if a node can be purchased
/proc/inscription_can_purchase_node(mob/living/M, node_id)
	if(!isliving(M) || !istext(node_id)) return FALSE
	ratworld_init_inscription_nodes()
	var/list/node = GLOB.rw_inscription_nodes[node_id]
	if(!islist(node)) return FALSE
	if(node_id in M.rw_inscription_purchased_nodes) return FALSE // Already purchased
	var/cost = node["cost_xp"]
	var/req_level = node["required_level"]
	if(M.rw_inscription_xp < cost) return FALSE
	if(inscription_get_level(M) < req_level) return FALSE
	return TRUE

// Proc to purchase a node
/proc/inscription_purchase_node(mob/living/M, node_id)
	if(!inscription_can_purchase_node(M, node_id)) return FALSE
	var/list/node = GLOB.rw_inscription_nodes[node_id]
	var/cost = node["cost_xp"]
	M.rw_inscription_xp -= cost
	M.rw_inscription_purchased_nodes += node_id
	M.ratworld_save_inscription() // Save immediately
	// TODO: apply any immediate effects, or just unlock for later use
	return TRUE

// Helper to get list of available nodes for UI
/proc/inscription_get_available_nodes(mob/living/M)
	if(!isliving(M)) return list()
	ratworld_init_inscription_nodes()
	var/list/available = list()
	for(var/node_id in GLOB.rw_inscription_nodes)
		if(inscription_can_purchase_node(M, node_id))
			available += node_id
	return available

// Helper to get purchased nodes
/proc/inscription_get_purchased_nodes(mob/living/M)
	if(!isliving(M)) return list()
	return M.rw_inscription_purchased_nodes.Copy()

// Crystal items for inscription costs
/obj/item/ratworld_crystal
	name = "inscription crystal"
	desc = "A magical crystal used for inscription."
	icon = 'icons/roguetown/items/gems.dmi' // Assume exists or placeholder
	icon_state = "crystal"
	var/tier = 1

/obj/item/ratworld_crystal/brutality
	name = "brutality crystal"
	desc = "Crystal infused with brute force."
	tier = 1

/obj/item/ratworld_crystal/wisdom
	name = "wisdom crystal"
	desc = "Crystal infused with arcane knowledge."
	tier = 2

/obj/item/ratworld_crystal/resilience
	name = "resilience crystal"
	desc = "Crystal infused with enduring strength."
	tier = 3

/obj/item/ratworld_crystal/divine
	name = "divine crystal"
	desc = "Crystal infused with holy power."
	tier = 4

/obj/item/ratworld_crystal/prismatic
	name = "prismatic crystal"
	desc = "Crystal infused with chaotic energy."
	tier = 5

// Harness Power: Mage ability to extract crystals from dead mobs
/mob/living/proc/ratworld_harness_power(obj/item/corpse)
	if(!corpse || !istype(corpse, /obj/item)) return FALSE
	// Check if mage (placeholder: assume job or trait)
	if(!mind || mind.assigned_role != "Mage") return FALSE // Placeholder
	var/crystal_type
	var/mob_type = corpse.type // Placeholder for mob type check
	if(istype(corpse, /mob/living/simple_animal/hostile/retaliate/rogue/wolf) || istype(corpse, /mob/living/simple_animal/hostile/retaliate/rogue/direbear)) // Brutality: beasts
		crystal_type = /obj/item/ratworld_crystal/brutality
	else if(istype(corpse, /mob/living/carbon/human)) // Wisdom: bandits, skeletons (placeholder)
		crystal_type = /obj/item/ratworld_crystal/wisdom
	// Add more: Resilience for bosses, Divine for lich, Prismatic for player corpses
	else
		return FALSE
	var/obj/item/crystal = new crystal_type(get_turf(src))
	to_chat(src, "You harness the power, creating a [crystal.name].")
	qdel(corpse)
	return TRUE

// Proc to inscribe a scroll (placeholder: assume scroll item exists)
/proc/inscription_inscribe_scroll(obj/item/scroll, obj/item/crystal, node_id, mob/living/user)
	if(!scroll || !crystal || !user) return FALSE
	if(!istype(crystal, /obj/item/ratworld_crystal)) return FALSE
	var/obj/item/ratworld_crystal/C = crystal
	var/list/node = GLOB.rw_inscription_nodes[node_id]
	if(!node || !(node_id in user.rw_inscription_purchased_nodes)) return FALSE
	if(C.tier < node["tier"]) return FALSE
	// Apply enhancement to scroll (placeholder)
	scroll.vars["rw_enhancement"] = node["enhancement_id"]
	qdel(crystal)
	to_chat(user, "You inscribe the enhancement onto the scroll.")
	return TRUE

// Mage verb for Harness Power
/mob/living/verb/ratworld_harness_power_verb()
	set name = "Harness Power"
	set category = "Mage" // Assume mage category
	if(!mind || mind.assigned_role != "Mage") // Placeholder
		to_chat(src, "Only mages can harness power.")
		return
	var/obj/item/corpse = input(src, "Select a dead mob to harness:", "Harness Power") as obj in view(1)
	if(!corpse) return
	if(!ratworld_harness_power(corpse))
		to_chat(src, "You cannot harness power from this.")

// Admin verb to grant inscription XP
/client/proc/ratworld_admin_grant_inscription_xp()
	set name = "Grant Inscription XP"
	set category = "Ratworld"
	var/mob/living/target = input(src, "Select target mob:", "Grant XP") as null|anything in GLOB.player_list
	if(!target) return
	var/amount = input(src, "Amount of XP to grant:", "Grant XP") as num
	if(amount <= 0) return
	inscription_add_xp(target, amount)
	to_chat(src, "Granted [amount] Inscription XP to [target].")
	to_chat(target, "<span class='notice'>You feel your Inscription skill improve!</span>")