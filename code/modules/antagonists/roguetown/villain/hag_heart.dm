/obj/structure/roguemachine/hag_heart
	name = "Mossmother's Heart"
	desc = "A pulsing, grotesque organ made of moss, roots, and something unspeakable. It thrums with the Mossmother's ancient power. The hag draws her immortality from this artifact."
	icon = 'icons/roguetown/misc/machines.dmi'
	// Temporary fallback until a dedicated hag-heart sprite is added to machines.dmi.
	icon_state = "scomite"
	density = TRUE
	anchored = TRUE
	max_integrity = 150
	var/datum/antagonist/hag/bound_hag
	var/destroyed = FALSE

/obj/structure/roguemachine/hag_heart/Initialize(mapload)
	. = ..()
	GLOB.hag_hearts += src

/obj/structure/roguemachine/hag_heart/Destroy()
	GLOB.hag_hearts -= src
	if(!destroyed)
		on_destroyed()
	return ..()

/obj/structure/roguemachine/hag_heart/proc/on_damage()
	// Signal handler for when heart takes damage
	// Will add more logic in Phase 2 for ward mechanics
	return

/obj/structure/roguemachine/hag_heart/proc/on_destroyed()
	destroyed = TRUE
	visible_message(span_boldwarning("The Mossmother's Heart shatters! Its ancient power dissipates into the bog!"))
	//playsound(src, 'sound/magic/sunder.ogg', 100, TRUE) // TODO: Port Azure Peak audio assets
	// Phase 2: Will trigger final spite curse, make hag killable, notify coven

/obj/structure/roguemachine/hag_heart/proc/link_hag(datum/antagonist/hag/hag_datum)
	bound_hag = hag_datum

/obj/structure/roguemachine/hag_heart/proc/get_bound_hag()
	return bound_hag
