/datum/component/storage/concrete/roguetown/shoes
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

/datum/component/storage/concrete/roguetown/shoes/attackby(datum/source, obj/item/attacking_item, mob/user, params, storage_click)
	if(is_type_in_list(attacking_item, cant_hold))
		return FALSE
	return ..()

/datum/component/storage/concrete/roguetown/shoes/update_icon()
	. = ..()
	var/obj/our_parent = real_location()
	if(ismob(our_parent.loc))
		var/mob/parent_mob = our_parent.loc
		parent_mob.update_inv_shoes()

/datum/component/storage/concrete/roguetown/shoes/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check = FALSE, params, storage_click = FALSE)
	// only shoes can be added
	if(!(storing.slot_flags & ITEM_SLOT_SHOES))
		return FALSE
	// any sort of armoured item is forbidden, it's aesthetic only
	if(storing.armor?.stab > 0 || storing.armor?.blunt > 0)
		return FALSE
	// don't allow recursive nesting, it must be empty
	if(length(storing.contents))
		return FALSE
	return ..()

/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = ""
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0

	body_parts_covered = FEET
	slot_flags = ITEM_SLOT_SHOES

	permeability_coefficient = 0.5
	slowdown = SHOES_SLOWDOWN
	strip_delay = 1 SECONDS
	var/blood_state = BLOOD_STATE_NOT_BLOODY
	var/list/bloody_shoes = list(BLOOD_STATE_MUD = 0, BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	var/offset = 0
	var/equipped_before_drop = FALSE
	var/can_be_bloody = TRUE
	var/is_barefoot = FALSE
	var/stepnoise_flag = STEPNOISE_ALL // Currently only used by the heel modifier.
	bloody_icon_state = "shoeblood"
	sleeved_detail = null
	dropshrink = 0.8

	grid_width = 32
	grid_height = 64

	var/attachment_component = /datum/component/storage/concrete/roguetown/shoes

	var/hide_base = FALSE

/obj/item/clothing/shoes/ComponentInitialize()
	. = ..()
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(clean_blood))

/obj/item/clothing/shoes/MiddleClick(mob/user, params)
	if(!ishuman(user))
		return ..()
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/shoes/storage_component = GetComponent(attachment_component)
		if(storage_component && length(storage_component.item_to_grid_coordinates))
			hide_base = !hide_base
			var/mob/living/carbon/human/H = user
			H.update_inv_shoes()
			return
	return ..()

/obj/item/clothing/shoes/suicide_act(mob/living/carbon/user)
	if(rand(2)>1)
		user.visible_message(span_suicide("[user] begins tying \the [src] up waaay too tightly! It looks like [user.p_theyre()] trying to commit suicide!"))
		var/obj/item/bodypart/l_leg = user.get_bodypart(BODY_ZONE_L_LEG)
		var/obj/item/bodypart/r_leg = user.get_bodypart(BODY_ZONE_R_LEG)
		if(l_leg)
			l_leg.dismember()
		if(r_leg)
			r_leg.dismember()
		playsound(user, "desceration", 50, TRUE, -1)
		return BRUTELOSS
	else//didnt realize this suicide act existed (was in miscellaneous.dm) and didnt want to remove it, so made it a 50/50 chance. Why not!
		user.visible_message(span_suicide("[user] is bashing [user.p_their()] own head in with [src]! Ain't that a kick in the head?"))
		for(var/i = 0, i < 3, i++)
			sleep(3)
			playsound(user, 'sound/blank.ogg', 50, TRUE)
		return(BRUTELOSS)

/obj/item/clothing/shoes/worn_overlays(isinhands = FALSE)
	. = list()
//	if(!isinhands)
//		var/bloody = FALSE
//		if(HAS_BLOOD_DNA(src))
//			bloody = TRUE
//		else
//			bloody = bloody_shoes[BLOOD_STATE_HUMAN]

//		if(damaged_clothes)
//			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedshoe")
//		if(bloody)
//			. += mutable_appearance('icons/effects/blood.dmi', "shoeblood")

/obj/item/clothing/shoes/equipped(mob/user, slot)
	. = ..()
	if(offset && slot_flags & slotdefine2slotbit(slot))
		user.pixel_y += offset
		worn_y_dimension -= (offset * 2)
		user.update_inv_shoes()
		equipped_before_drop = TRUE

/obj/item/clothing/shoes/proc/restore_offsets(mob/user)
	equipped_before_drop = FALSE
	user.pixel_y -= offset
	worn_y_dimension = world.icon_size

/obj/item/clothing/shoes/dropped(mob/user)
	if(offset && equipped_before_drop)
		restore_offsets(user)
	. = ..()

/obj/item/clothing/shoes/update_damaged_state()
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/proc/clean_blood(datum/source, strength)
	if(strength < CLEAN_STRENGTH_BLOOD)
		return
	bloody_shoes = list(BLOOD_STATE_MUD = 0,BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	blood_state = BLOOD_STATE_NOT_BLOODY
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()

/obj/item/clothing/shoes/Initialize(mapload)
	. = ..()
	if(attachment_component)
		AddComponent(attachment_component)

/obj/item/clothing/gloves/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("You can slot in shoes with no armor as cosmetic.")

/obj/item/clothing/shoes/ShiftRightClick(mob/user)
	if(attachment_component)
		var/datum/component/storage/storage_component = GetComponent(attachment_component)
		if(storage_component)
			storage_component.rmb_show(user)
			return TRUE
	return ..()

/obj/item/clothing/shoes/get_examine_name(mob/user)
	var/default_examine_name = ..()
	if(attachment_component)
		var/datum/component/storage/concrete/roguetown/our_component = GetComponent(attachment_component)
		if(our_component && length(our_component.item_to_grid_coordinates))
			var/list/examine_strings = list()
			for(var/obj/item/thing as anything in our_component.item_to_grid_coordinates)
				examine_strings += thing.get_examine_name(user)
			default_examine_name += " ([examine_strings.Join(", ")])"
	return default_examine_name

/obj/item/clothing/shoes/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null)
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