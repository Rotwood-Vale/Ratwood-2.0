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

/// Wards protect the heart. While any ward remains standing, the heart cannot be damaged.
/obj/structure/roguemachine/hag_heart/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0, object_damage_multiplier = 1)
	if(length(GLOB.hag_wards))
		if(sound_effect)
			src.visible_message(span_notice("Magical energy still safeguards the heart. The wards must fall first."))
		return FALSE
	return ..()

/obj/structure/roguemachine/hag_heart/proc/on_destroyed()
	destroyed = TRUE
	visible_message(span_boldwarning("The Mossmother's Heart shatters! Its ancient power dissipates into the bog!"))
	priority_announce("A terrible crack echoes across the land. The Mossmother's Heart has been destroyed — the hag can now be slain for good.", "The Heart Falls")
	// Notify the bound hag directly
	if(bound_hag?.owner?.current)
		to_chat(bound_hag.owner.current, span_userdanger("My heart is gone. If I die now, I will not return."))

/obj/structure/roguemachine/hag_heart/proc/link_hag(datum/antagonist/hag/hag_datum)
	bound_hag = hag_datum

/obj/structure/roguemachine/hag_heart/proc/get_bound_hag()
	return bound_hag
