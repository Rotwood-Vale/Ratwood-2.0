/obj/item/clothing/neck/roguetown/cursed_collar
	name = "cursed collar"
	desc = "A sinister looking collar with ruby studs. It seems to radiate a dark energy."
	// Credit regarding sprites to Necbro
	// https://github.com/StoneHedgeSS13/StoneHedge/commit/9ddc09d4cb91903beff6d523c91aef75312d5163
	icon = 'modular_stonehedge/icons/clothing/armor/neck.dmi'
	mob_overlay_icon = 'modular_stonehedge/icons/clothing/armor/onmob/neck.dmi'
	icon_state = "cursed_collar"
	item_state = "cursed_collar"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	resistance_flags = INDESTRUCTIBLE
	var/mob/living/carbon/human/victim = null
	var/datum/mind/collar_master = null
	var/silenced = FALSE
	var/applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/attack(mob/living/carbon/human/C, mob/living/user)
	if(!istype(C))
		return ..()
	
	// if(!C.mind)
	// 	to_chat(user, span_warning("[C] is too simple-minded to be collared!"))
	// 	return

	if(C.get_item_by_slot(SLOT_NECK))
		to_chat(user, span_warning("[C] is already wearing something around their neck!"))
		return

	if(!collar_master)
		collar_master = user.mind

	if(applying)
		return

	var/surrender_mod = 1
	if(C.surrendering)
		surrender_mod = 0.5

	applying = TRUE
	if(do_mob(user, C, 50 * surrender_mod))
		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

		// Get or create collar master datum first
		var/datum/component/collar_master/CM = user.mind.GetComponent(/datum/component/collar_master)
		if(!CM)
			CM = user.mind.AddComponent(/datum/component/collar_master)

		// Try to equip
		if(!C.equip_to_slot_if_possible(src, SLOT_NECK, TRUE, TRUE))
			to_chat(user, span_warning("You fail to lock the collar around [C]'s neck!"))
			applying = FALSE
			return

		// Add pet to the master's list before sending collar signals
		CM.add_pet(C)
		log_combat(user, C, "tried to collar", addition="with [src]")
	applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/attack_self(mob/user)
	. = ..()
	if(!user?.mind)
		return
	if(alert(user, "Become the master of this collar?", "Cursed Collar", "Yes", "No") != "Yes")
		return
	var/datum/component/collar_master/CM = user.mind.GetComponent(/datum/component/collar_master)
	if(!CM)
		user.mind.AddComponent(/datum/component/collar_master)
	collar_master = user.mind
	to_chat(user, span_userdanger("You feel the collar being imprinted with your will."))


/obj/item/clothing/neck/roguetown/cursed_collar/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != SLOT_NECK)
		return

	if(!collar_master)
		return
	
	CALLBACK(src, PROC_REF(handle_equip), user)

/obj/item/clothing/neck/roguetown/cursed_collar/proc/handle_equip(mob/living/carbon/human/user)
	if(istype(user, /mob/living/carbon/human/dummy))
		return

	if(!user.mind)
		user.visible_message(span_warning("\The [src] fails to lock around [user]'s neck."))
		user.dropItemToGround(src, force = TRUE)
		return

	if(alert(user, "Submit to the collar's control?", "Cursed Collar", "Yes!", "No") != "Yes!")
		user.visible_message(span_warning("[user] resists the collar's control."))
		to_chat(user, span_warning("Your defiant will prevents the collar from binding to you!"))
		user.dropItemToGround(src, force = TRUE)
		return

	// Now send the collar gain signal
	SEND_SIGNAL(user, COMSIG_CARBON_GAIN_COLLAR, src)
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	user.visible_message(span_warning("Cursed collar around [user]'s neck clicks shut!"), \
							span_userdanger("Cursed collar around your neck clicks shut!"))
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

	// Only send the gain signal once master is set
	addtimer(CALLBACK(src, PROC_REF(send_collar_signal), user), 2)

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!user)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)

	// Find and remove from any collar master's pet list
	for(var/datum/mind/M in GLOB.collar_masters)
		var/datum/component/collar_master/CM = M.GetComponent(/datum/component/collar_master)
		if(CM && (user in CM.my_pets))
			CM.remove_pet(user)
			break

	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/cursed_collar/canStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	if(!stripper.mind)
		return
	if(stripper.mind == collar_master)
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		SEND_SIGNAL(owner, COMSIG_CARBON_LOSE_COLLAR)
		return TRUE
	. = ..()

/obj/item/clothing/neck/roguetown/cursed_collar/proc/send_collar_signal(mob/living/carbon/human/user)
	if(!collar_master) // Don't send signal if no master
		SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_GAIN_COLLAR, src)

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user))
		SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)
