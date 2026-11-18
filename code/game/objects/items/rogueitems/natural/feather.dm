
/obj/item/natural/feather
	name = "feather"
	icon_state = "feather"
	possible_item_intents = list(/datum/intent/use)
	desc = "A fluffy feather. Can be used to write on paper, skin, fur and scales alike."
	force = 0
	throwforce = 0
	obj_flags = null
	firefuel = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = TRUE
	max_integrity = 20
	muteinmouth = TRUE
	spitoutmouth = FALSE
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75

//reproduces some code from pens so that we can utilize feathers for renaming objects

/obj/item/natural/feather/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = input(user, "What would you like to edit?", "Rename or change description?") as null|anything in list("Rename","Change description")
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "Rename")
			var/input = stripped_input(user,"What do you want to name \the [O.name]?", ,"", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(!input)
				return
			if(oldname == input)
				to_chat(user, span_notice("I changed \the [O.name] to... well... \the [O.name]."))
			else
				O.name = "[input] ([initial(O.name)])"
				to_chat(user, span_notice("\The [oldname] has been successfully been renamed to \the [input]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Change description")
			var/input = stripped_input(user,"Describe \the [O.name] here", ,"", 250)
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			O.desc = input
			to_chat(user, span_notice("I have successfully changed \the [O.name]'s description."))


// BODY WRITING \\
// Code adapted from branding code in surgery_tools_rogue.dm \\

// Maps a chosen button label to the backing bodypart/organ and body writing text var.
/obj/item/natural/feather/proc/get_body_writing_target_data(selection, obj/item/bodypart/writing_part, obj/item/organ/penis/penis, obj/item/organ/vagina/vagina, obj/item/organ/testicles/testes, obj/item/organ/breasts/tits)
	if(!selection)
		return null
	switch(selection)
		if("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Tauric Half")
			return list("holder" = writing_part, "text_var" = "body_writing")
		if("Hind")
			if(!istype(writing_part, /obj/item/bodypart/chest))
				return null
			return list("holder" = writing_part, "text_var" = "body_writing_on_buttocks")
		if("Stomach")
			if(!istype(writing_part, /obj/item/bodypart/chest))
				return null
			return list("holder" = writing_part, "text_var" = "body_writing_on_stomach")
		if("Neck")
			if(!istype(writing_part, /obj/item/bodypart/head))
				return null
			return list("holder" = writing_part, "text_var" = "body_writing_on_neck")
		if("Mouth")
			if(!istype(writing_part, /obj/item/bodypart/head))
				return null
			return list("holder" = writing_part, "text_var" = "body_writing_on_mouth")
		if("Breasts")
			if(QDELETED(tits))
				return null
			return list("holder" = tits, "text_var" = "body_writing")
		if("Dick")
			if(QDELETED(penis))
				return null
			return list("holder" = penis, "text_var" = "body_writing")
		if("Vagina")
			if(QDELETED(vagina))
				return null
			return list("holder" = vagina, "text_var" = "body_writing")
		if("Testes")
			if(QDELETED(testes))
				return null
			return list("holder" = testes, "text_var" = "body_writing")
	return null

// Builds available zone choices and caches any visible organs needed later.
/obj/item/natural/feather/proc/build_writing_zone_data(mob/living/carbon/human/target, precise_zone, body_zone, obj/item/bodypart/writing_part)
	var/list/zone_options = list()
	var/covered = FALSE
	var/obj/item/organ/penis/penis
	var/obj/item/organ/vagina/vagina
	var/obj/item/organ/testicles/testes
	var/obj/item/organ/breasts/tits

	switch(precise_zone)
		if(BODY_ZONE_PRECISE_GROIN)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_GROIN))
				zone_options += "Hind"
				penis = target.getorganslot(ORGAN_SLOT_PENIS)
				if(penis && penis.is_visible())
					zone_options += "Dick"
				vagina = target.getorganslot(ORGAN_SLOT_VAGINA)
				if(vagina && vagina.is_visible())
					zone_options += "Vagina"
				testes = target.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testes && testes.is_visible() && testes.ball_size >= DEFAULT_TESTICLES_SIZE)
					zone_options += "Testes"
		if(BODY_ZONE_PRECISE_STOMACH)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_STOMACH))
				zone_options += "Stomach"
			else
				covered = TRUE
		if(BODY_ZONE_PRECISE_NECK)
			if(get_location_accessible(target, BODY_ZONE_PRECISE_NECK))
				zone_options += "Neck"
			else
				covered = TRUE
		if(BODY_ZONE_PRECISE_MOUTH)
			if(!target.is_mouth_covered())
				zone_options += "Mouth"
			else
				covered = TRUE

	switch(body_zone)
		if(BODY_ZONE_CHEST)
			if(!length(zone_options) && !covered)
				tits = target.getorganslot(ORGAN_SLOT_BREASTS)
				if(tits && tits.is_visible())
					zone_options += "Breasts"
				zone_options += "Chest"
				if(get_location_accessible(target, BODY_ZONE_PRECISE_STOMACH))
					zone_options += "Stomach"
		if(BODY_ZONE_HEAD)
			if(!length(zone_options) && !covered)
				if(get_location_accessible(target, BODY_ZONE_HEAD, ignored_item = target.mouth))
					zone_options += "Head"
				if(!target.is_mouth_covered())
					zone_options += "Mouth"
				if(get_location_accessible(target, BODY_ZONE_PRECISE_NECK))
					zone_options += "Neck"
		if(BODY_ZONE_L_LEG)
			if(istype(writing_part, /obj/item/bodypart/taur))
				zone_options += "Tauric Half"
			else
				zone_options += "Left Leg"
		if(BODY_ZONE_R_LEG)
			if(istype(writing_part, /obj/item/bodypart/taur))
				zone_options += "Tauric Half"
			else
				zone_options += "Right Leg"
		if(BODY_ZONE_L_ARM)
			zone_options += "Left Arm"
		if(BODY_ZONE_R_ARM)
			zone_options += "Right Arm"

	return list(
		"options" = zone_options,
		"covered" = covered,
		"penis" = penis,
		"vagina" = vagina,
		"testes" = testes,
		"tits" = tits,
	)

// Rebuild options after do_after so limb/coverage changes cannot apply to stale selections.
/obj/item/natural/feather/proc/rebuild_body_writing_selection_data(mob/living/carbon/human/target, precise_zone)
	var/body_zone = check_zone(precise_zone)
	var/obj/item/bodypart/writing_part = target.get_bodypart(body_zone)
	if(QDELETED(writing_part) || !istype(writing_part))
		return null
	var/list/zone_data = build_writing_zone_data(target, precise_zone, body_zone, writing_part)
	zone_data["body_zone"] = body_zone
	zone_data["writing_part"] = writing_part
	return zone_data

// Applies body writing to the target data.
/obj/item/natural/feather/proc/apply_body_writing_to_target_data(mob/living/user, list/target_data, writing_text)
	if(!length(target_data))
		return FALSE
	var/obj/item/holder = target_data["holder"]
	if(QDELETED(holder))
		return FALSE
	var/text_var = target_data["text_var"]
	if(length(holder.vars[text_var]))
		to_chat(user, span_warning("I write over the existing marking."))
	holder.vars[text_var] = writing_text
	return TRUE

// Keeps the cheap body written flag in sync after apply operations.
/obj/item/natural/feather/proc/target_has_any_body_writing(mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
		if(length(bodypart.body_writing))
			return TRUE
		if(istype(bodypart, /obj/item/bodypart/chest))
			var/obj/item/bodypart/chest/chest = bodypart
			if(length(chest.body_writing_on_buttocks) || length(chest.body_writing_on_stomach))
				return TRUE
		else if(istype(bodypart, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/head = bodypart
			if(length(head.body_writing_on_neck))
				return TRUE
			if(length(head.body_writing_on_mouth))
				return TRUE
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		if(("body_writing" in organ.vars) && length(organ.vars["body_writing"]))
			return TRUE
	return FALSE

// Keeps the do_after announcement text centralized.
/obj/item/natural/feather/proc/send_writing_attempt_messages(mob/living/user, mob/living/carbon/human/target, final_answer, writing_self)
	if(!writing_self)
		user.visible_message(span_warning("[user] starts to write on [target]'s [LOWER_TEXT(final_answer)]."))
		to_chat(target, span_userdanger("[user] is trying to write on my [LOWER_TEXT(final_answer)]!"))
	else
		user.visible_message(span_warning("[user] starts writing on [user.p_their()] [LOWER_TEXT(final_answer)]."))

// Sends a message confirming body writing has completed.
/obj/item/natural/feather/proc/send_writing_result_messages(mob/living/user, mob/living/carbon/human/target, final_answer, writing_text)
	user.visible_message(span_info("[user] writes  on [target]'s [LOWER_TEXT(final_answer)]! The fresh ink shows [span_beautiful_fem(writing_text)]."))
	to_chat(target, span_userdanger("Someone wrote on your body!"))

// Single entry point for action-phase combat logs.
/obj/item/natural/feather/proc/log_body_writing_action(mob/living/user, mob/living/carbon/human/target, action_type, final_answer, writing_text, writing_delay)
	switch(action_type)
		if("attempt")
			log_combat(user, target, "Body writing attempt: \"[writing_text]\" on [final_answer] ([writing_delay]s)")
		if("aborted")
			log_combat(user, target, "Body writing aborted: \"[writing_text]\" on [final_answer]")
		if("part_destroyed")
			log_combat(user, target, "Body writing part destroyed: \"[writing_text]\" on [final_answer]")
		if("success")
			log_combat(user, target, "Body writing successful: \"[writing_text]\" on [final_answer]")

// The actual body writing function.
/obj/item/natural/feather/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(!ishuman(A))
		return ..()
	var/mob/living/carbon/human/target = A
	var/precise_zone = user.zone_selected // We need this up here to stay consistent past the do_after.
	var/body_zone = check_zone(precise_zone)
	var/obj/item/bodypart/writing_part = target.get_bodypart(body_zone)
	var/writing_self = user == target
	if(!get_location_accessible(target, precise_zone, ignored_item = precise_zone == BODY_ZONE_HEAD ? target.mouth : null))
		to_chat(user, span_warning("That part is obstructed by clothing."))
		return TRUE

	// Get the area we want to write on, and then prompt the user for what to write/whether we should write on that zone.
	if(QDELETED(writing_part) || !istype(writing_part))
		to_chat(user, span_warning("They don't have this part..."))
		return TRUE

	var/list/zone_data = build_writing_zone_data(target, precise_zone, body_zone, writing_part)
	var/list/zone_options = zone_data["options"]
	var/covered = zone_data["covered"]
	var/obj/item/organ/penis/penis = zone_data["penis"]
	var/obj/item/organ/vagina/vagina = zone_data["vagina"]
	var/obj/item/organ/testicles/testes = zone_data["testes"]
	var/obj/item/organ/breasts/tits = zone_data["tits"]

	if(length(zone_options))
		zone_options = zone_options.Copy()
		zone_options += "Cancel"
	else // failsafe
		if(covered)
			to_chat(user, span_warning("That part is covered!"))
		else
			to_chat(user, span_warning("It doesn't seem like this part can be written on!"))
		return TRUE

	var/final_answer // String. The button the user clicks on when prompted which part to write on.

	// Prompt before do_after.
	final_answer = tgui_alert(user, "What do you wish to write on?", "Please answer in [DisplayTimeText(10 SECONDS)]!", zone_options, 10 SECONDS)

	if(!final_answer || final_answer == "Cancel")
		return TRUE

	var/writing_text = "" // The text to actually write. The user will be prompted for it.
	var/inputty = stripped_input(user, "What would you like to write?\nExample: stupid mutt", "Enter what to write", null, 64)
	if(inputty)
		writing_text = inputty

	// Reject writing if the target has disconnected.
	if(!writing_self && !target.client)
		to_chat(user, span_warning("You can't write on [target] right now."))
		return TRUE

	// Reject writing if there is nothing to write.
	if(!length(writing_text))
		to_chat(user, span_warning("You can't write nothing."))
		return TRUE

	// A part has been selected and the text to write has been entered. Now, we start printing messages to chat and showing the do_after.
	var/writing_delay = 6 SECONDS
	if(writing_self)
		writing_delay -= 4 SECONDS
	send_writing_attempt_messages(user, target, final_answer, writing_self)

	// Log the start of the body writing attempt.
	log_body_writing_action(user, target, "attempt", final_answer, writing_text, writing_delay)

	// All of the things that can go wrong during the do_after.
	if(!do_after(user, writing_delay, target = target))
		if(!QDELETED(target))
			log_body_writing_action(user, target, "aborted", final_answer, writing_text, writing_delay)
		return TRUE
	if(!user.Adjacent(target) || user.stat >= UNCONSCIOUS)
		log_body_writing_action(user, target, "aborted", final_answer, writing_text, writing_delay)
		return TRUE
	if(QDELETED(writing_part))
		log_body_writing_action(user, target, "part_destroyed", final_answer, writing_text, writing_delay)
		return TRUE

	// Rebuild options after do_after so limb/coverage changes cannot apply to stale selections.
	var/list/live_zone_data = rebuild_body_writing_selection_data(target, precise_zone)
	if(!length(live_zone_data))
		to_chat(user, span_warning("They no longer have that part."))
		return TRUE

	writing_part = live_zone_data["writing_part"]
	penis = live_zone_data["penis"]
	vagina = live_zone_data["vagina"]
	testes = live_zone_data["testes"]
	tits = live_zone_data["tits"]
	zone_options = live_zone_data["options"]

	// Make sure the body part is still there.
	if(!(final_answer in zone_options))
		to_chat(user, span_warning("That body part is no longer available."))
		return TRUE

	// Attempt to re-get the part and apply the writing.
	var/list/selected_target_data = get_body_writing_target_data(final_answer, writing_part, penis, vagina, testes, tits)

	if(!apply_body_writing_to_target_data(user, selected_target_data, writing_text))
		to_chat(user, span_warning("There was a problem with writing on this body part."))
		return TRUE

	target.bodywritten = target_has_any_body_writing(target)
	send_writing_result_messages(user, target, final_answer, writing_text)
	playsound(src.loc, 'sound/items/write.ogg', 100, FALSE, extrarange = 2)
	log_body_writing_action(user, target, "success", final_answer, writing_text, writing_delay)
	return TRUE
