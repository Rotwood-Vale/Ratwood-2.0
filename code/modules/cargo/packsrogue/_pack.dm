/datum/supply_pack
	var/name = "Crate"
	var/group = ""
	/// Foreign trade cultural stock: units per ship manifest roll (trade_ship.dm's
	/// roll_cultural_stock reads these off packs listed in a realm's cultural_stock_pool).
	var/ship_qty_min = 0
	var/ship_qty_max = 0
	var/hidden = FALSE
	var/contraband = FALSE
	var/cost = 700 // Minimum cost, or infinite points are possible.
	var/access = FALSE
	var/access_any = FALSE
	var/list/contains = null
	var/crate_name = "crate"
	var/desc = ""//no desc by default
	var/crate_type = /obj/structure/closet/crate
	var/no_name_quantity = FALSE // If TRUE, do not display the name as "[Name] x [Amount]".
	var/not_in_public = FALSE // If true, this pack will not be listed in the public goldface.
	var/mandated_public_profit = 0 // If set, this pack will always additional cost this much percentage on top of the base cost when in the public vendor. All of the forced profit
	// can be withdrawn by the owner.
	var/dangerous = FALSE // Should we message admins?
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	var/DropPodOnly = FALSE//only usable by the Bluespace Drop Pod via the express cargo console
	var/admin_spawned = FALSE
	var/small_item = FALSE //Small items can be grouped into a single crate.

/datum/supply_pack/New()
	..()
	var/lim = round(cost * 0.1)
	cost = rand(cost-lim, cost+lim)
	if(cost < 1)
		cost = 1

/datum/supply_pack/proc/generate(atom/A)
	var/obj/structure/closet/crate/C = new crate_type(A)
	C.name = crate_name
	if(access)
		C.req_access = list(access)
	if(access_any)
		C.req_one_access = access_any

	fill(C)
	return C

/datum/supply_pack/proc/fill(obj/structure/closet/crate/C)
	if (admin_spawned)
		for(var/item in contains)
			var/atom/A = new item(C)
			A.flags_1 |= ADMIN_SPAWNED_1
	else
		for(var/item in contains)
			new item(C)
