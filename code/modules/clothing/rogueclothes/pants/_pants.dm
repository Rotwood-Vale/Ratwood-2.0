/datum/component/storage/concrete/roguetown/under
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

/datum/component/storage/concrete/roguetown/under/attackby(datum/source, obj/item/attacking_item, mob/user, params, storage_click)
	if(is_type_in_list(attacking_item, cant_hold))
		return FALSE
	return ..()

/datum/component/storage/concrete/roguetown/under/update_icon()
	. = ..()
	var/obj/our_parent = real_location()
	if(ismob(our_parent.loc))
		var/mob/parent_mob = our_parent.loc
		parent_mob.update_inv_pants()

/datum/component/storage/concrete/roguetown/under/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	// we only want aesthetically armor/cloak items, like tabards and shirts, to be addable
	if(!(storing.slot_flags & ITEM_SLOT_PANTS))
		return FALSE
	// don't allow recursive nesting, it must be empty
	if(length(storing.contents))
		return FALSE
	return ..()

/obj/item/clothing/under/roguetown
	slot_flags = ITEM_SLOT_PANTS
	fitted = NO_FEMALE_UNIFORM
	can_adjust = FALSE
	body_parts_covered = GROIN|LEGS
	icon = 'icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	equip_sound = 'sound/blank.ogg'
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	sleevetype = "leg"
	equip_delay_self = 30
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	r_sleeve_zone = BODY_ZONE_R_LEG
	l_sleeve_zone = BODY_ZONE_L_LEG
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	flags_inv = HIDECROTCH
	experimental_inhand = FALSE
	salvage_amount = 2
	grid_height = 32
	grid_width = 64

	var/attachment_component = /datum/component/storage/concrete/roguetown/under

	/// If TRUE, the pants themselves are not drawn, only the cosmetic pants slotted into them
	var/hide_base = FALSE

/obj/item/clothing/under/roguetown/Initialize(mapload)
	. = ..()
	if(attachment_component)
		AddComponent(attachment_component)

/obj/item/clothing/under/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("You can slot in pants with no armor as cosmetic.")
	. += span_notice("Middle-click to hide pants as long as you have a cosmetic pants.")
	. += span_notice("Middle-click to hide tail as long as there are no cosmetic pants in the slot")

/obj/item/clothing/under/roguetown/AdjustClothes(mob/user)
#ifdef MATURESERVER
	if(is_worn_or_stored_by(user))
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			icon_state = "[initial(icon_state)]_t"
			body_parts_covered = null
			slowdown += 2
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_pants()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
#else
	return
#endif
	
/obj/item/clothing/under/roguetown/MiddleClick(mob/user)
	var/mob/living/carbon/H = user
	if(!ishuman(user))
		return
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/under/storage_component = GetComponent(attachment_component)
		if(storage_component && length(storage_component.item_to_grid_coordinates))
			hide_base = !hide_base
			H.update_inv_pants()
			return
	if(flags_inv & HIDETAIL)
		flags_inv &= ~HIDETAIL
	else
		flags_inv |= HIDETAIL
	persist_inv_flags(HIDETAIL)	//AdjustClothes() calls ResetAdjust() directly, which wipes flags_inv
	H.update_inv_pants()

/obj/item/clothing/under/roguetown/ShiftRightClick(mob/user)
	if(attachment_component)
		var/datum/component/storage/storage_component = GetComponent(attachment_component)
		if(storage_component)
			storage_component.rmb_show(user)
			return TRUE
	return ..()

/obj/item/clothing/under/roguetown/get_examine_name(mob/user)
	var/default_examine_name = ..()
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			var/list/examine_strings = list()
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				examine_strings += thing.get_examine_name(user)
			default_examine_name += " ([examine_strings.Join(", ")])"
	return default_examine_name

/obj/item/clothing/under/roguetown/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
	var/mutable_appearance/standing = ..()
	// get attachment component and check if there's anything inside
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			if(hide_base)
				standing.alpha = 0
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				var/mutable_appearance/thing_appearance = thing.build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, clip_mask)
				thing_appearance.appearance_flags = RESET_COLOR|RESET_ALPHA
				thing_appearance.pixel_x += standing.pixel_x
				thing_appearance.pixel_y += standing.pixel_y
				standing.add_overlay(thing_appearance)
	return standing
