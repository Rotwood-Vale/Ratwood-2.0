/*
	DEAD DROP CONTRACT
	Flinger-exclusive contraband job. The contract names a hidden location;
	a sealed parcel is waiting there. Give the contract to a non-Scum, let
	them fetch the parcel, bring it back to you, then hand the parcel to
	The Trader for your cut. The non-Scum sees none of that coin unless you
	choose to pay them - that's the deal.
*/

// =====================================================
// DEAD DROP PARCEL
// =====================================================

/obj/item/parcel/dead_drop
	name = "dead drop parcel"
	desc = "A tightly wrapped parcel. No markings, no address. Someone went to great lengths to make it look ordinary."
	icon_state = "ration_small"
	dropshrink = 1
	/// Weakref to the dead_drop_contract that commissioned this parcel.
	var/datum/weakref/contract_ref

/obj/item/parcel/dead_drop/Initialize(mapload)
	. = ..()
	invisibility = initial(invisibility) // Always visible - no quest proximity reveal
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/dead_drop/Destroy()
	var/obj/item/paper/scroll/dead_drop_contract/C = contract_ref?.resolve()
	if(C)
		C.parcel_ref = null // Break back-link so contract Destroy doesn't loop back to us
		qdel(C)
	return ..()

/obj/item/parcel/dead_drop/attack_self(mob/user)
	to_chat(user, span_warning("The parcel is sealed tight. It's meant to be delivered, not opened."))

/obj/item/parcel/dead_drop/examine(mob/user)
	. = ..()
	. += span_warning("Even without opening it, anyone can tell this isn't a legitimate delivery.")

// =====================================================
// DEAD DROP CONTRACT SCROLL
// =====================================================

/obj/item/paper/scroll/dead_drop_contract
	name = "dead drop contract"
	desc = "A contract for an off-the-books retrieval. Handle with care - and discretion."
	icon_state = "contractsigned"
	/// Weakref to the parcel waiting at the dead-drop location.
	var/datum/weakref/parcel_ref
	/// Human-readable name of the dead-drop area (written on the contract).
	var/drop_location_name = ""

/obj/item/paper/scroll/dead_drop_contract/Initialize(mapload)
	. = ..()
	open = TRUE

	var/static/list/drop_locations = list(
		list(/area/rogue/under/town/sewer,     "the Sewer Tunnels"),
		list(/area/rogue/under/town,           "the Town Basements"),
		list(/area/rogue/indoors/town/tavern,  "the back of the Tavern"),
		list(/area/rogue/indoors/town/bath,    "the Bathhouse lower level"),
		list(/area/rogue/indoors/town/shop,    "behind the Market Stalls"),
	)

	var/list/chosen = pick(drop_locations)
	var/chosen_area_type = chosen[1]
	drop_location_name = chosen[2]

	// Find a passable turf in the target area to stash the parcel
	var/area/A = locate(chosen_area_type) in world
	var/turf/spawn_turf = null
	if(A)
		for(var/turf/T in A)
			if(!T.density && prob(15))
				spawn_turf = T
				break
	if(!spawn_turf)
		spawn_turf = get_turf(src)

	var/obj/item/parcel/dead_drop/P = new(spawn_turf)
	P.contract_ref = WEAKREF(src)
	parcel_ref = WEAKREF(P)

	info  = "<b>CONTRACT OF RETRIEVAL</b><br>"
	info += "<i>Issued by The Trader. Contraband. Not for official eyes.</i>"
	info += "<hr/>"
	info += "Go to <b>[drop_location_name]</b>. "
	info += "You will find a sealed parcel. Take it and bring it to the Flinger who gave you this. "
	info += "Do not open it. Do not speak of it.<br><br>"
	info += "The Flinger will settle payment upon delivery. You have their word on it.<br><br>"
	info += "<i>Non-delivery will be remembered.</i>"

	update_icon_state()

/obj/item/paper/scroll/dead_drop_contract/Destroy()
	var/obj/item/parcel/dead_drop/P = parcel_ref?.resolve()
	if(P)
		P.contract_ref = null // Break back-link so parcel Destroy doesn't loop back to us
		qdel(P)
	return ..()

/obj/item/paper/scroll/dead_drop_contract/update_icon_state()
	if(open)
		icon_state = "contractsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "scroll"

/obj/item/paper/scroll/dead_drop_contract/examine(mob/user)
	. = ..()
	. += span_warning("This is clearly contraband. Anyone who finds you with it will know exactly what you're involved in.")
