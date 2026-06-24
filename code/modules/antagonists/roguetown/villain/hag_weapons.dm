// Wyrd weapons with natural regeneration on natural tiles
/obj/item/rogueweapon/greataxe/steel/hag
	name = "gnarled axe"
	desc = "A large axe made out of gnarled, twisted wood. It's like it was grown that way, and you can swear you see the branches moving."
	icon_state = "hagaxe"
	smeltresult = null

/obj/item/rogueweapon/greataxe/steel/hag/Initialize(mapload)
	. = ..()
	// This makes the repair component recognize it, and tracks the "debt"
	AddComponent(/datum/component/hag_magical_item, /datum/hag_boon/item/hag_axe)

/obj/item/rogueweapon/sword/long/hag
	name = "gnarled sword"
	desc = "A long sword made out of gnarled, twisted wood. It's like it was grown that way, and you can swear you see the branches moving."
	icon_state = "hagsword"
	smeltresult = null

/obj/item/rogueweapon/sword/long/hag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hag_magical_item, /datum/hag_boon/item/hag_sword)

/obj/item/rogueweapon/halberd/hag
	name = "gnarled polearm"
	desc = "A large polearm made out of gnarled, twisted wood. It's like it was grown that way, and you can swear you see the branches moving."
	icon_state = "hagspear"
	smeltresult = null

/obj/item/rogueweapon/halberd/hag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hag_magical_item, /datum/hag_boon/item/hag_spear)

/obj/item/clothing/neck/roguetown/psicross/hag
	name = "wyrd cross"
	desc = "I can't really pin down what this is supposed to be. The silhouette's edges wave and warp whilst I look at it."
	icon_state = "wyrd_cross"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	/// What cross we're mimicking.
	var/mimic_type = null
	var/static/list/hag_radial_choices
	var/static/list/hag_path_map
	var/tonic_spent = FALSE

/obj/item/clothing/neck/roguetown/psicross/hag/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hag_magical_item, /datum/hag_boon/item/wyrd_cross)


/obj/item/clothing/neck/roguetown/psicross/hag/dropped(mob/user)
	. = ..()
	if(mimic_type)
		// Ensure the ground sprite is correct immediately upon dropping
		var/obj/item/clothing/neck/roguetown/psicross/C = mimic_type
		icon = initial(C.icon)
		icon_state = initial(C.icon_state)

/obj/item/clothing/neck/roguetown/psicross/hag/proc/can_use_wyrd_power(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		return TRUE

	var/datum/component/hag_magical_item_affinity/Keychain = user.GetComponent(/datum/component/hag_magical_item_affinity)
	if(Keychain && (initial(name) in Keychain.authorized_ids))
		return TRUE

	return FALSE

/obj/item/clothing/neck/roguetown/psicross/hag/MiddleClick(mob/living/user)
	. = ..()
	// Hags can use this
	if(!can_use_wyrd_power(user))
		return

	if(tonic_spent)
		to_chat(user, span_warning("The [src.name]'s magic is spent."))
		return

	if(!iscarbon(user))
		return

	to_chat(user, span_notice("You press the [src.name] against your neck, waiting for the needle to bite..."))

	if(do_after(user, 1 SECONDS, target = user))
		if(tonic_spent)
			return
		var/mob/living/carbon/C = user
		if(!C.reagents)
			return

		C.reagents.add_reagent(/datum/reagent/medicine/stronghealth, 30)
		tonic_spent = TRUE
		to_chat(user, span_notice("A soothing tonic flows from the [src.name] into your body."))

/obj/item/clothing/neck/roguetown/psicross/hag/verb/wyrd_mimic_radial()
	set name = "Shift Form"
	set category = "Object"
	set src in range(0)

	var/mob/living/user = usr

	// Only works for the person holding it
	if(!can_use_wyrd_power(user))
		return

	if(!hag_radial_choices)
		// Build the radial list on first use
		hag_radial_choices = list()
		hag_path_map = list()
		for(var/obj/item/clothing/neck/roguetown/psicross/P in typesof(/obj/item/clothing/neck/roguetown/psicross))
			if(P == /obj/item/clothing/neck/roguetown/psicross/hag)
				continue
			var/display_name = initial(P.name)
			hag_radial_choices += display_name
			hag_path_map[display_name] = P

	var/selection = input(user, "What form shall you take?", "Form") as null|anything in hag_radial_choices
	if(!selection)
		return

	if(!can_use_wyrd_power(user))
		return

	if(mimic_type == hag_path_map[selection])
		to_chat(user, span_notice("You're already in that form."))
		return

	var/target_path = hag_path_map[selection]
	mimic_type = target_path

	// Cast the path to a variable so we can safely pull 'initial' values
	var/obj/item/clothing/neck/roguetown/psicross/C = target_path

	// Visual Inheritance
	name = initial(C.name)
	desc = initial(C.desc)
	icon = initial(C.icon)
	icon_state = initial(C.icon_state)
	mob_overlay_icon = initial(C.mob_overlay_icon)

	// Mechanical Inheritance
	src.sellprice = initial(C.sellprice)
	src.resistance_flags = initial(C.resistance_flags)
	src.overarmor = initial(C.overarmor)
	src.armor = initial(C.armor)

	user.update_icons()
	to_chat(user, span_notice("The cross warps into the shape of [name]."))

/obj/item/clothing/neck/roguetown/psicross/hag/verb/wyrd_reset_form()
	set name = "Reset Form"
	set category = "Object"
	set src in range(0)

	var/mob/living/user = usr

	if(!can_use_wyrd_power(user))
		return

	if(!mimic_type)
		to_chat(user, span_notice("You already are in your base form."))
		return

	mimic_type = null
	name = initial(name)
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state)
	mob_overlay_icon = initial(mob_overlay_icon)
	src.sellprice = initial(sellprice)
	src.resistance_flags = initial(resistance_flags)
	src.overarmor = initial(overarmor)
	src.armor = initial(armor)

	user.update_icons()
	to_chat(user, span_notice("The cross warps back into its indecipherable, shifting form."))
