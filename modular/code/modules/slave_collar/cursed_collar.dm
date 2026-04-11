/obj/item/clothing/neck/roguetown/cursed_collar
	name = "cursed collar"
	always_show_examine_link = TRUE
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
	leashable = TRUE
	var/mob/living/carbon/human/victim = null
	var/datum/mind/collar_master = null
	var/silenced = FALSE
	var/applying = FALSE
	/// Round-persistent counter for non-self ejaculation events received by the current wearer.
	var/received_cum_count = 0

/obj/item/clothing/neck/roguetown/cursed_collar/examine(mob/user)
	. = ..()
	if(received_cum_count == 1)
		. += span_notice("1 tally mark is etched into the collar's metal surface.")
	else if(received_cum_count > 1)
		. += span_notice("[received_cum_count] tally marks are etched into the collar's metal surface.")

/obj/item/clothing/neck/roguetown/cursed_collar/proc/record_nonself_ejaculation(mob/living/carbon/human/source, mob/living/carbon/human/wearer)
	if(!source || !wearer)
		return FALSE
	if(source == wearer)
		return FALSE
	if(loc != wearer)
		return FALSE
	var/added = get_tally_increment_for_source(source)
	received_cum_count += added
	var/tally_msg = added == 1 ? "A metal scraping sound is briefly heard, a tally mark suddenly appears on [wearer]'s collar." : "A metal scraping sound is briefly heard, two tally marks suddenly appear on [wearer]'s collar."
	for(var/mob/M in viewers(1, wearer))
		to_chat(M, span_notice(tally_msg))
	return TRUE

/obj/item/clothing/neck/roguetown/cursed_collar/proc/get_tally_increment_for_source(mob/living/carbon/human/source)
	return tally_increment_for_ejaculation_source(source)

/obj/item/clothing/neck/roguetown/cursed_collar/proc/reset_received_cum_count()
	received_cum_count = 0

/obj/item/clothing/neck/roguetown/cursed_collar/attack(mob/living/carbon/human/C, mob/living/user)
	if(!istype(C))
		return ..()

	if(C.get_item_by_slot(SLOT_NECK))
		to_chat(user, span_warning("[C] is already wearing something around their neck!"))
		return

	var/obj/item/chastity/existing_chastity = C.chastity_device
	if(istype(existing_chastity) && existing_chastity.chastity_cursed)
		to_chat(user, span_warning("[C] is already bound by cursed chastity."))
		return

	var/datum/mind/master_mind = collar_master
	if(!master_mind)
		master_mind = user?.mind
		collar_master = master_mind
	if(!master_mind)
		to_chat(user, span_warning("The collar rejects binding without an imprinted master."))
		return

	if(applying)
		return

	var/surrender_mod = 1
	if(C.surrendering || C.compliance)
		surrender_mod = 0.5

	applying = TRUE
	if(do_mob(user, C, 50 * surrender_mod))
		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

		// Get or create collar master datum first
		var/datum/component/collar_master/CM = master_mind.GetComponent(/datum/component/collar_master)
		if(!CM)
			CM = master_mind.AddComponent(/datum/component/collar_master)

		// Try to equip
		if(!C.equip_to_slot_if_possible(src, SLOT_NECK, TRUE, TRUE))
			to_chat(user, span_warning("You fail to lock the collar around [C]'s neck!"))
			applying = FALSE
			return

		// Add pet to the master's list before sending collar signals
		if(!CM.add_pet(C))
			to_chat(user, span_warning("The collar fails to bind [C]."))
			C.dropItemToGround(src, force = TRUE)
			applying = FALSE
			return

		SEND_SIGNAL(C, COMSIG_CARBON_COLLAR_BOUND, collar_master, src)
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		log_combat(user, C, "tried to collar", addition="with [src]")
	applying = FALSE

/obj/item/clothing/neck/roguetown/cursed_collar/attack_self(mob/user)
	. = ..()
	if(!user?.mind)
		return
	if(tgui_alert(user, "Become the master of this collar?", "Cursed Collar", list("Yes", "No")) != "Yes")
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

	if(applying)
		return

	if(!collar_master)
		return

	// Defer one tick so equip state is fully settled before prompt/lock logic.
	addtimer(CALLBACK(src, PROC_REF(handle_equip), user), 0.1 SECONDS)

/obj/item/clothing/neck/roguetown/cursed_collar/proc/handle_equip(mob/living/carbon/human/user)
	if(istype(user, /mob/living/carbon/human/dummy))
		return

	if(user?.mind && collar_master && user.mind == collar_master)
		to_chat(user, span_warning("The collar rejects self-binding. It must be fastened by another master."))
		user.dropItemToGround(src, force = TRUE)
		return

	if(!user.mind)
		user.visible_message(span_warning("\The [src] fails to lock around [user]'s neck."))
		user.dropItemToGround(src, force = TRUE)
		return

	var/obj/item/chastity/existing_chastity = user.chastity_device
	if(istype(existing_chastity) && existing_chastity.chastity_cursed)
		to_chat(user, span_warning("The collar recoils from the cursed chastity already binding you."))
		user.dropItemToGround(src, force = TRUE)
		return

	if(SEND_SIGNAL(user, COMSIG_CARBON_COLLAR_BIND_ATTEMPT, collar_master, src) & COMPONENT_COLLAR_BIND_BLOCK)
		to_chat(user, span_warning("The collar resists binding right now."))
		user.dropItemToGround(src, force = TRUE)
		return

	if(tgui_alert(user, "Submit to the collar's control?", "Cursed Collar", list("Yes!", "No")) != "Yes!")
		user.visible_message(span_warning("[user] resists the collar's control."))
		to_chat(user, span_warning("Your defiant will prevents the collar from binding to you!"))
		user.dropItemToGround(src, force = TRUE)
		return

	var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master)
	if(!CM)
		CM = collar_master.AddComponent(/datum/component/collar_master)
	if(!CM || !CM.add_pet(user))
		to_chat(user, span_warning("The collar fails to bind to you."))
		user.dropItemToGround(src, force = TRUE)
		return

	SEND_SIGNAL(user, COMSIG_CARBON_COLLAR_BOUND, collar_master, src)
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	user.visible_message(span_warning("Cursed collar around [user]'s neck clicks shut!"), \
							span_userdanger("Cursed collar around your neck clicks shut!"))
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)

	// Only send the gain signal once master is set
	addtimer(CALLBACK(src, PROC_REF(send_collar_signal), user), 2)

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	reset_received_cum_count()
	if(!user)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)

	// Use the stored collar_master reference directly instead of iterating the entire global list.
	// This avoids an O(n) scan over all active masters on every collar drop.
	if(collar_master)
		var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master)
		if(CM && (user in CM.my_pets))
			CM.remove_pet(user)

	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/cursed_collar/canStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	// Some strip call sites may not pass owner; infer from loc when possible.
	if(!owner && ishuman(loc))
		owner = loc

	if(stripper?.mind == collar_master)
		return TRUE

	return ..()

/obj/item/clothing/neck/roguetown/cursed_collar/doStrip(mob/living/carbon/human/stripper, mob/living/carbon/human/owner)
	if(!owner && ishuman(loc))
		owner = loc

	if(stripper?.mind == collar_master)
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		if(owner)
			SEND_SIGNAL(owner, COMSIG_CARBON_LOSE_COLLAR)
		return owner ? owner.dropItemToGround(src, force = TRUE) : FALSE

	return ..()

/obj/item/clothing/neck/roguetown/cursed_collar/proc/send_collar_signal(mob/living/carbon/human/user)
	if(!collar_master) // Don't send signal if no master
		SEND_SIGNAL(user, COMSIG_CARBON_LOSE_COLLAR)
		return
	SEND_SIGNAL(user, COMSIG_CARBON_GAIN_COLLAR, src)
