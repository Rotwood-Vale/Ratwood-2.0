/datum/component/storage/concrete/roguetown/gloves
	screen_max_rows = 2
	screen_max_columns = 2
	max_w_class = WEIGHT_CLASS_GIGANTIC

	cant_hold = list(
		/obj/item/storage,
		/obj/item/rogueweapon,
		/obj/item/bomb,
		/obj/item/flashlight,
		/obj/item/recipe_book,
	)

	attack_hand_interact = FALSE
	silent = TRUE
	rustle_sound = null

	insert_preposition = "onto"
	allow_big_nesting = TRUE
	allow_nesting = TRUE
	intercept_parent_attack = FALSE
	intercept_parent_mousedrop = FALSE

/datum/component/storage/concrete/roguetown/gloves/attackby(datum/source, obj/item/attacking_item, mob/user, params, storage_click)
	if(is_type_in_list(attacking_item, cant_hold))
		return FALSE
	return ..()

/datum/component/storage/concrete/roguetown/gloves/update_icon()
	. = ..()
	var/obj/our_parent = real_location()
	if(ismob(our_parent.loc))
		var/mob/parent_mob = our_parent.loc
		parent_mob.update_inv_gloves()

/datum/component/storage/concrete/roguetown/gloves/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	// we only want aesthetically armor/cloak items, like tabards and shirts, to be addable
	if(!(storing.slot_flags & (ITEM_SLOT_GLOVES|ITEM_SLOT_WRISTS)))
		return FALSE
	// any sort of armoured item is forbidden, it's aesthetic only
	if(storing.armor?.stab > 0 || storing.armor?.blunt > 0)
		return FALSE
	// don't allow recursive nesting, it must be empty
	if(length(storing.contents))
		return FALSE
	return ..()

/obj/item/clothing/gloves/roguetown
	slot_flags = ITEM_SLOT_GLOVES
	body_parts_covered = HANDS
	body_parts_inherent = HANDS
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	bloody_icon_state = "bloodyhands"
	sleevetype = "shirt"
	siemens_coefficient = 1
	max_heat_protection_temperature = 361
	experimental_inhand = FALSE
	/// Flat unarmed damage bonus (for pure fists / wrestling only)
	var/unarmed_bonus = 0
	/// If TRUE, this glove counts as the "weapon" for the purposes of on-hit item effects (silver ignition, magic_item enchantments) when used to throw an unarmed strike. Reserved for wraps meant to fight barehanded, not everyday gloves.
	var/unarmed_weapon_effects = FALSE

	var/attachment_component = /datum/component/storage/concrete/roguetown/gloves

/obj/item/clothing/gloves/roguetown/Initialize(mapload)
	. = ..()
	if(attachment_component)
		AddComponent(attachment_component)

/obj/item/clothing/gloves/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("You can slot in gloves with no armor as cosmetic.")
	if(unarmed_bonus > 0)
		. += span_notice("Unarmed damage bonus: +[unarmed_bonus] (flat, applied after strength scaling).")

/**
 * Lets a worn glove act as the "weapon" for on-hit item effects (silver ignition, magic_item enchantments)
 * when it lands an unarmed strike, instead of only when wielded as a dedicated melee weapon.
 * Called from the unarmed attack resolution after damage is confirmed to land.
 */
/obj/item/clothing/gloves/roguetown/proc/apply_unarmed_weapon_effects(mob/living/user, obj/item/bodypart/affecting, datum/intent/intent, mob/living/victim, selzone)
	if(!unarmed_weapon_effects)
		return
	do_special_attack_effect(user, affecting, intent, victim, selzone)
	SEND_SIGNAL(src, COMSIG_ITEM_AFTERATTACK, victim, user, TRUE, null)

/obj/item/clothing/gloves/roguetown/ShiftRightClick(mob/user)
	if(attachment_component)
		var/datum/component/storage/storage_component = GetComponent(attachment_component)
		if(storage_component)
			storage_component.rmb_show(user)
			return TRUE
	return ..()

/obj/item/clothing/gloves/roguetown/get_examine_name(mob/user)
	var/default_examine_name = ..()
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			var/list/examine_strings = list()
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				examine_strings += thing.get_examine_name(user)
			default_examine_name += " ([examine_strings.Join(", ")])"
	return default_examine_name

/obj/item/clothing/gloves/roguetown/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
	var/mutable_appearance/standing = ..()
	// get attachment component and check if there's anything inside
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				var/mutable_appearance/thing_appearance = thing.build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, clip_mask)
				thing_appearance.appearance_flags = RESET_COLOR|RESET_ALPHA
				thing_appearance.pixel_x += standing.pixel_x
				thing_appearance.pixel_y += standing.pixel_y
				standing.add_overlay(thing_appearance)
	return standing