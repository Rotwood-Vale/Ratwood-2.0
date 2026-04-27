/*
	SMUGGLER'S SATCHEL
	Flinger-exclusive plantable dead drop container.
	Fill it, plant it on any turf (4s bar), set a code word aloud. Anyone who
	knows the code can open it by saying it within 1 tile. Non-Scum see it as a
	nondescript bundle. The Flinger who planted it can retrieve it unopened.
	Vanishes once emptied.
*/

/datum/component/storage/concrete/roguetown/smuggler_satchel
	grid = TRUE
	screen_max_rows = 7
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_HUGE
	not_while_equipped = TRUE

/obj/item/storage/backpack/rogue/satchel/smuggler
	name = "smuggler's satchel"
	desc = "A worn satchel with double-stitched seams and a false bottom. Made to be left behind, not carried."
	icon_state = "satchel"
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = NONE
	resistance_flags = FIRE_PROOF
	max_integrity = 150
	component_type = /datum/component/storage/concrete/roguetown/smuggler_satchel
	/// TRUE once planted on a turf
	var/planted = FALSE
	/// Code required to open when planted
	var/code = null
	/// Weakref to the Flinger who planted it, so only they can retrieve it
	var/datum/weakref/planter_ref = null
	/// Weakref to a mob currently being prompted to speak the code, to prevent double-prompts
	var/datum/weakref/pending_user_ref = null

/obj/item/storage/backpack/rogue/satchel/smuggler/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!isturf(target) || !proximity_flag || planted)
		return ..()
	if(!istype(user, /mob/living/carbon/human))
		return ..()
	if(!HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
		to_chat(user, span_warning("You don't know what to do with this."))
		return ..()
	if(!length(src.contents))
		to_chat(user, span_warning("Fill the satchel with something before planting it."))
		return ..()

	to_chat(user, span_notice("You begin stashing the satchel..."))
	if(!do_after(user, 4 SECONDS, target = src))
		to_chat(user, span_warning("You stop."))
		return ..()
	if(QDELETED(src))
		return

	var/entered_code = input(user, "Set a code word for this stash.", "Set Code") as text|null
	if(!entered_code || QDELETED(src))
		return

	code = lowertext(trim(entered_code))
	planter_ref = WEAKREF(user)
	planted = TRUE
	name = "wrapped bundle"
	desc = "A battered bundle, tucked against the ground. Nothing about it invites attention."
	alpha = 100
	color = "#3a2e28"

	user.dropItemToGround(src, force = TRUE)
	src.forceMove(get_turf(target))
	to_chat(user, span_notice("Stashed."))

/obj/item/storage/backpack/rogue/satchel/smuggler/attack_hand(mob/user)
	if(!planted)
		return ..()
	if(!istype(user, /mob/living/carbon/human))
		return

	var/mob/planter = planter_ref?.resolve()
	if(planter && planter == user)
		var/choice = input(user, "Your stash.", "Smuggler's Satchel") as null|anything in list("Open", "Retrieve")
		if(!choice || QDELETED(src))
			return
		if(choice == "Retrieve")
			planted = FALSE
			code = null
			planter_ref = null
			name = initial(name)
			desc = initial(desc)
			alpha = initial(alpha)
			color = initial(color)
			if(!user.put_in_hands(src))
				forceMove(get_turf(user))
			to_chat(user, span_notice("You retrieve the satchel."))
			return
		open_storage(user)
		return

	// Non-planter: prompt to speak the code
	if(pending_user_ref?.resolve())
		return // someone else is already being prompted
	pending_user_ref = WEAKREF(user)
	visible_message(span_italics("A tick is heard, expecting something."))
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(on_user_say))

/obj/item/storage/backpack/rogue/satchel/smuggler/proc/on_user_say(mob/user, list/speech_args)
	UnregisterSignal(user, COMSIG_MOB_SAY)
	pending_user_ref = null
	if(QDELETED(src) || !planted)
		return
	if(get_dist(user, src) > 1)
		return // too far away, silent fail
	var/spoken = lowertext(trim(speech_args[SPEECH_MESSAGE]))
	if(spoken != code)
		return // wrong code, silent fail
	open_storage(user)

/obj/item/storage/backpack/rogue/satchel/smuggler/proc/open_storage(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.show_to(user)

/obj/item/storage/backpack/rogue/satchel/smuggler/examine(mob/user)
	if(planted)
		if(HAS_TRAIT(user, TRAIT_UNDERBELLY_SCUM))
			return list(span_notice("A hidden stash. Someone left it here."))
		return list(span_notice("A wrapped bundle on the ground. Doesn't look like much."))
	return ..()

/obj/item/storage/backpack/rogue/satchel/smuggler/Destroy()
	if(pending_user_ref)
		var/mob/M = pending_user_ref.resolve()
		if(M)
			UnregisterSignal(M, COMSIG_MOB_SAY)
		pending_user_ref = null
	return ..()

/obj/item/storage/backpack/rogue/satchel/smuggler/Exited(atom/movable/gone, direction)
	. = ..()
	if(planted && !length(contents))
		qdel(src)
