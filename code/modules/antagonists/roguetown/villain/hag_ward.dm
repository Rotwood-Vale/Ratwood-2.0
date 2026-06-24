/**
 * Hag Ward — /obj/structure/roguemachine/hag_ward
 *
 * Placed in the bog to bar non-scarred players from accessing the hag's hut.
 * - Indestructible by normal means (max_integrity = 0).
 * - Each ward picks a random required reagent on initialization.
 * - Only TRAIT_CURSE_SCAR holders can examine the ward to learn its reagent.
 * - Destroyed by pouring the correct reagent into it via a container.
 * - Registers/deregisters in GLOB.hag_wards; the heartroot tree checks this list
 *   to gate hut travel for scarred mortals.
 * - When the last ward falls, all hags are notified.
 */

/obj/structure/roguemachine/hag_ward
	name = "Strange Ward"
	desc = "A strange overgrown ward. Gnarled roots and bleached bone twist into an unsettling sigil. You feel vaguely repelled."
	icon = 'icons/roguetown/items/hag/hag_ward.dmi'
	icon_state = "ward"
	density = TRUE
	max_integrity = 0 // Indestructible by normal combat
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_x = -16
	var/datum/reagent/required_reagent = null
	var/units_needed = 90

	var/static/list/possible_reagents = list(
		/datum/reagent/medicine/antidote,
		/datum/reagent/medicine/strong_antidote,
		/datum/reagent/berrypoison,
		/datum/reagent/strongstampoison,
		/datum/reagent/medicine/healthpot,
		/datum/reagent/medicine/stronghealth,
		/datum/reagent/medicine/manapot,
		/datum/reagent/medicine/strongmana,
		/datum/reagent/medicine/stampot,
	)

/obj/structure/roguemachine/hag_ward/Initialize(mapload)
	. = ..()
	GLOB.hag_wards += src
	create_reagents(100)
	required_reagent = pick(possible_reagents)

/obj/structure/roguemachine/hag_ward/Destroy()
	GLOB.hag_wards -= src
	if(length(GLOB.hag_wards))
		src.visible_message(span_warning("The roots surrounding the ward still look strong. This wasn't the last of them."))
	else
		src.visible_message(span_warning("You feel a faint hum as birds scatter from the heart of the bog. Something has changed."))
		notify_hags_wards_fallen()
	return ..()

/// Notifies all active hags that every ward has been destroyed.
/obj/structure/roguemachine/hag_ward/proc/notify_hags_wards_fallen()
	for(var/obj/structure/roguemachine/hag_heart/heart in GLOB.hag_hearts)
		if(!heart.bound_hag?.owner?.current)
			continue
		to_chat(heart.bound_hag.owner.current, \
			span_userdanger("Your wards have all been shattered! The path to your hut is now open to any who walk the roots!"))

/obj/structure/roguemachine/hag_ward/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_CURSE_SCAR) || GLOB.hag_rite_active)
		var/datum/reagent/R = required_reagent
		. += "<br>[span_boldwarning("The scar on your skin pulses. The roots of this ward crave [units_needed] units of [initial(R.name)].")]"
	else
		. += "<br>[span_notice("It seems to be feeding on something in the air, but you can't tell what.")]"

/obj/structure/roguemachine/hag_ward/attackby(obj/item/I, mob/user, params)
	// Only curse-scarred players can interact with the ward
	if(!HAS_TRAIT(user, TRAIT_CURSE_SCAR))
		return ..()

	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		if(!container.reagents.has_reagent(required_reagent))
			to_chat(user, span_warning("The roots recoil from the liquid! It's not what they crave."))
			return
		var/amount_to_transfer = min(container.reagents.get_reagent_amount(required_reagent), units_needed)
		var/removed = container.reagents.trans_to(src, amount_to_transfer, transfered_by = user)
		if(removed)
			units_needed -= removed
			to_chat(user, span_notice("The ward greedily drinks the [initial(required_reagent:name)]. Only [max(0, units_needed)] units remain."))
			if(units_needed <= 0)
				src.visible_message(span_warning("The [src] shrivels and rots away as the roots retreat into the soil!"))
				qdel(src)
		return
	return ..()
