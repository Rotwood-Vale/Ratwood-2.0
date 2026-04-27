// A modified inquisitorial mask, dyed black, lined with zizo bane fumes.
// Load with zizo's bane, then attack an unmasked/unhelmed target's head to force-equip it.
// Starts a 3-second window - victim can pull it off in time, or gamble their CON.

/obj/item/clothing/mask/rogue/suffocator
	name = "suffocator"
	desc = "A modified inquisitorial mask, dyed pitch black. The inside is tacky - lined with something."
	icon_state = "physmask"
	color = "#000000"
	nudist_approved = TRUE
	unequip_delay_self = 25
	/// TRUE once zizo's bane has been pressed into the lining
	var/bane_loaded = FALSE
	/// TIMER_STOPPABLE handle so we can cancel on removal
	var/knockout_timer = null

/obj/item/clothing/mask/rogue/suffocator/examine(mob/user)
	. = ..()
	. += bane_loaded ? span_warning("The lining looks saturated with something.") : span_notice("The lining looks dry.")

/obj/item/clothing/mask/rogue/suffocator/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/zizo_bane))
		if(bane_loaded)
			to_chat(user, span_warning("It's already loaded."))
			return
		to_chat(user, span_notice("You press [I] into the lining of [src], saturating it with its fumes."))
		bane_loaded = TRUE
		qdel(I)
		return
	return ..()

/obj/item/clothing/mask/rogue/suffocator/attack(mob/living/M, mob/living/user)
	if(!bane_loaded || !istype(M, /mob/living/carbon/human))
		return ..()
	var/mob/living/carbon/human/H = M
	if(H.wear_mask || H.head)
		to_chat(user, span_warning("[H]'s face isn't exposed."))
		return
	user.visible_message(
		span_danger("[user] slams [src] onto [H]'s face!"),
		span_danger("You slam [src] onto [H]'s face!")
	)
	if(!H.equip_to_slot_if_possible(src, SLOT_WEAR_MASK, TRUE, TRUE))
		to_chat(user, span_warning("It won't sit right on [H]'s face."))

/obj/item/clothing/mask/rogue/suffocator/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != SLOT_WEAR_MASK || !bane_loaded)
		return
	playsound(user, pick('sound/misc/blackbagequip.ogg', 'sound/misc/blackbagequip2.ogg'), 100, TRUE, 4)
	user.playsound_local(src, 'sound/misc/blackbagloop.ogg', 100, FALSE)
	knockout_timer = addtimer(CALLBACK(src, PROC_REF(try_knockout), user), 3 SECONDS, TIMER_STOPPABLE)

/obj/item/clothing/mask/rogue/suffocator/dropped(mob/living/carbon/user)
	. = ..()
	if(knockout_timer)
		deltimer(knockout_timer)
		knockout_timer = null
		playsound(user, 'sound/misc/blackunbag.ogg', 100, TRUE, 4)

/obj/item/clothing/mask/rogue/suffocator/proc/try_knockout(mob/living/carbon/human/H)
	knockout_timer = null
	if(!istype(H) || QDELETED(H) || H.wear_mask != src)
		return
	// CON roll to resist — higher CON = better odds of shrugging it off
	if(prob(clamp((H.STACON - 8) * 5, 5, 70)))
		to_chat(H, span_notice("The fumes barely register. You fight through it."))
		return
	to_chat(H, span_userdanger("The fumes overwhelm you..."))
	H.visible_message(span_warning("[H] suddenly slumps, overcome by the mask's fumes!"))
	H.SetSleeping(90 SECONDS)
