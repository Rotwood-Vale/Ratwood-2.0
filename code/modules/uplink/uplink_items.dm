// Minimal uplink catalog scaffolding

GLOBAL_LIST_EMPTY(uplink_items)       // registry of item typepaths (unused in MVP)
GLOBAL_LIST_EMPTY(uplink_categories)  // registry of category names

// Return an empty catalog by default; specific items can be added in other files (e.g., holiday)
/proc/get_uplink_items(datum/game_mode/gamemode, allow_sales = TRUE, allow_restricted = TRUE, other_filter = list())
	var/list/filtered_uplink_items = list()
	// Ensure at least one category exists for UI, but with no items
	LAZYSET(filtered_uplink_items["Discounted Gear"], null, null)
	// Remove null placeholder
	filtered_uplink_items["Discounted Gear"] = null
	return filtered_uplink_items

/**
 * Uplink Items
 * Base datum; subtypes can be defined elsewhere (e.g., holiday specials)
 */
/datum/uplink_item
	var/name = "item name"
	var/category = "item category"
	var/desc = "item description"
	var/item = null            // Path to the item to spawn (optional)
	var/refund_path = null     // Alternative path for refunds
	var/cost = 0
	var/refund_amount = 0
	var/refundable = FALSE
	var/surplus = 100
	var/cant_discount = FALSE
	var/limited_stock = -1
	var/list/include_modes = list()
	var/list/exclude_modes = list()
	var/list/restricted_roles = list()
	var/player_minimum
	var/purchase_log_vis = TRUE
	var/restricted = FALSE
	var/illegal_tech = FALSE

/datum/uplink_item/proc/get_discount()
	return pick(4;0.75,2;0.5,1;0.25)

/datum/uplink_item/proc/purchase(mob/user, datum/component/uplink/U)
	var/atom/A = spawn_item(item, user, U)
	if(purchase_log_vis && U.purchase_log)
		U.purchase_log.LogPurchase(A, src, cost)

/datum/uplink_item/proc/spawn_item(spawn_path, mob/user, datum/component/uplink/U)
	if(!spawn_path)
		return
	var/atom/A
	if(ispath(spawn_path))
		A = new spawn_path(get_turf(user))
	else
		A = spawn_path
	if(ishuman(user) && istype(A, /obj/item))
		var/mob/living/carbon/human/H = user
		if(H.put_in_hands(A))
			to_chat(H, "[A] materializes into your hands!")
			return A
	to_chat(user, "[A] materializes onto the floor.")
	return A
