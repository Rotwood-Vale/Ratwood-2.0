/*
	DEAD DROP CONTRACT
	Flinger-exclusive contraband job. The contract carries a riddle pointing
	to a parcel stashed at a dead-drop spot somewhere in the world. Hand the
	contract off to a non-Scum and let them puzzle out where the parcel sits.
	Whoever picks the parcel up first (and isn't Scum) is the only one who
	can deliver it to The Trader, who pays them a small finder's fee and
	stamps the contract redeemed. The Flinger then walks the redeemed
	contract back to The Trader for the real cut. No farming yourself.
*/

// =====================================================
// DEAD DROP LANDMARK
// =====================================================

GLOBAL_LIST_EMPTY(dead_drop_spots)

/obj/effect/landmark/dead_drop_spot
	name = "dead drop spot"
	invisibility = INVISIBILITY_OBSERVER
	/// One-line riddle baked into the contract. No place names - let them puzzle it out.
	var/clue = "where the rats know better than to look"

/obj/effect/landmark/dead_drop_spot/Initialize(mapload)
	. = ..()
	GLOB.dead_drop_spots += src

/obj/effect/landmark/dead_drop_spot/Destroy()
	GLOB.dead_drop_spots -= src
	return ..()

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
	/// ckey of the first non-Scum mob to pick this up. Only they can hand it to The Trader.
	var/bound_ckey

/obj/item/parcel/dead_drop/Initialize(mapload)
	. = ..()
	invisibility = INVISIBILITY_OBSERVER
	QDEL_NULL(proximity_monitor)
	proximity_monitor = new(src, 1)

/obj/item/parcel/dead_drop/HasProximity(mob/nearby)
	if(!istype(nearby))
		return
	var/obj/item/paper/scroll/dead_drop_contract/C = contract_ref?.resolve()
	if(!C || get_turf(C) != get_turf(nearby))
		return
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = get_turf(src), icon_state = "hidden", layer = 18)
	I.plane = 18
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay_view(I, 5 SECONDS)
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/dead_drop/Destroy()
	var/obj/item/paper/scroll/dead_drop_contract/C = contract_ref?.resolve()
	if(C)
		C.parcel_ref = null // The contract outlives us; The Trader still needs to redeem it.
	return ..()

/obj/item/parcel/dead_drop/pickup(mob/user)
	..()
	if(bound_ckey || !user?.ckey)
		return
	if(HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
		return
	bound_ckey = user.ckey
	to_chat(user, span_warning("The weight of the parcel settles in your hand. It's your problem now."))

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
	/// TRUE once The Trader has received the parcel; the Flinger can now cash this in.
	var/ready_to_redeem = FALSE

/obj/item/paper/scroll/dead_drop_contract/Initialize(mapload)
	. = ..()
	open = TRUE

	var/turf/spawn_turf
	var/clue_text

	if(length(GLOB.dead_drop_spots))
		var/list/free_spots = list()
		for(var/obj/effect/landmark/dead_drop_spot/spot in GLOB.dead_drop_spots)
			if(locate(/obj/item/parcel/dead_drop) in get_turf(spot))
				continue
			free_spots += spot
		var/obj/effect/landmark/dead_drop_spot/chosen = length(free_spots) ? pick(free_spots) : pick(GLOB.dead_drop_spots)
		spawn_turf = get_turf(chosen)
		clue_text = chosen.clue
	else if(length(GLOB.quest_landmarks_list))
		// Fallback so the system works on maps that haven't had dead drop spots placed yet.
		var/obj/effect/landmark/quest_spawner/fallback = pick(GLOB.quest_landmarks_list)
		spawn_turf = fallback.get_safe_spawn_turf()
		clue_text = "where the brave go looking for trouble"

	if(!spawn_turf)
		spawn_turf = get_turf(src)
		clue_text = "right under the nose of the one who hired you"

	var/obj/item/parcel/dead_drop/P = new(spawn_turf)
	P.contract_ref = WEAKREF(src)
	parcel_ref = WEAKREF(P)

	info  = "<b>CONTRACT OF RETRIEVAL</b><br>"
	info += "<i>Issued by The Trader. Contraband. Not for official eyes.</i>"
	info += "<hr/>"
	info += "There's a parcel stashed somewhere out there. Bring it back to The Trader and you'll be paid a finder's fee on the spot. The one who hired you pockets the rest of the deal in their own time.<br><br>"
	info += "<b>The drop:</b> <i>[clue_text]</i><br><br>"
	info += "Don't open it. Don't talk about it. Don't lose it.<br><br>"
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
	if(ready_to_redeem)
		. += span_notice("The Trader's mark magically appeared, and is fresh on the bottom. This one's good for turning in.")
	. += span_warning("This is clearly contraband. Anyone who finds you with it will know exactly what you're involved in.")
