/obj/item/baotha_crayon
	name = "saccharine crayon"
	desc = "A pink wax crayon, sickly sweet to the nose. Its strokes carry Baotha's blessing. Use it on an exposed lower abdomen to offer her fertility mark."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "chalk"
	color = "#ff8ad6"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.6
	var/marking = FALSE
	var/datum/tgui_alert/marking_offer

/obj/item/baotha_crayon/Destroy()
	QDEL_NULL(marking_offer)
	return ..()

/obj/item/baotha_crayon/dropped(mob/user, silent = FALSE)
	QDEL_NULL(marking_offer)
	return ..()

/obj/item/baotha_crayon/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_RELIC)

/obj/item/baotha_crayon/proc/marking_area_exposed(mob/living/carbon/human/target)
	if(target.sexcon?.bottom_exposed)
		return TRUE
	if(target.underwear || !is_human_part_visible(target, HIDECROTCH))
		return FALSE
	for(var/obj/item/covering in target.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
		if(!istype(covering) || (covering in target.held_items))
			continue
		if(covering.body_parts_covered_dynamic & GROIN)
			return FALSE
	return TRUE

/// Recheck after both the consent prompt and the drawing delay; either may outlive the original setup.
/obj/item/baotha_crayon/proc/can_mark(mob/living/carbon/human/target, mob/living/user)
	if(QDELETED(src) || !istype(target) || QDELETED(target) || !istype(user) || QDELETED(user))
		return FALSE
	if(!user.client || user.incapacitated())
		return FALSE
	if(!target.client || target.stat != CONSCIOUS || target.incapacitated(ignore_restraints = TRUE))
		to_chat(user, span_warning("The recipient must be awake and present to accept the mark."))
		return FALSE
	if(user.get_active_held_item() != src || (user != target && !user.Adjacent(target)) || !istype(user.a_intent, /datum/intent/use))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) || target.has_flaw(/datum/charflaw/marked_by_baotha))
		to_chat(user, span_warning("That body already bears Baotha's mark."))
		return FALSE
	if(!marking_area_exposed(target))
		to_chat(user, span_warning("I can't draw the mark; that area isn't exposed."))
		return FALSE
	return TRUE

/obj/item/baotha_crayon/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(.)
		return
	if(!ishuman(A) || !isliving(user) || !istype(user.a_intent, /datum/intent/use))
		return FALSE
	// Every handled attempt consumes the interaction, including refusals and interruptions.
	if(marking || user.doing || !can_mark(A, user))
		return TRUE
	marking = TRUE
	mark_person(A, user)
	if(!QDELETED(src))
		marking = FALSE
	return TRUE

/obj/item/baotha_crayon/proc/mark_person(mob/living/carbon/human/target, mob/living/user)
	var/client/drawer_client = user.client
	var/client/recipient_client = target.client
	// Native alerts have no timeout, so use the timed TGUI modal directly.
	var/datum/tgui_alert/offer = new(target, "Allow [user] to draw Baotha's permanent fertility mark on your lower abdomen?", "Baotha's Mark", list("Accept", "Decline"), 20 SECONDS, TRUE, GLOB.tgui_always_state)
	marking_offer = offer
	offer.ui_interact(target)
	while(!QDELETED(offer) && !offer.choice && !offer.closed && marking_attempt_active(user, target, drawer_client, recipient_client))
		stoplag(1)
	var/accepted = !QDELETED(offer) && offer.choice == "Accept"
	marking_offer = null
	qdel(offer)
	if(!accepted || !marking_attempt_active(user, target, drawer_client, recipient_client))
		return
	if(!can_mark(target, user) || user.doing)
		return
	user.visible_message(span_info("[user] begins drawing a pink sigil on [target]'s lower abdomen."), span_info("I begin drawing Baotha's mark..."))
	playsound(get_turf(target), 'sound/foley/scribble.ogg', 40, TRUE)
	if(!do_after(user, 10 SECONDS, target = target, extra_checks = CALLBACK(src, PROC_REF(marking_attempt_active), user, target, drawer_client, recipient_client)))
		return
	if(!marking_attempt_active(user, target, drawer_client, recipient_client) || !can_mark(target, user))
		return
	target.add_baotha_fertility_mark()
	target.grant_baotha_fertility_boon()
	if(target.sexcon)
		target.sexcon.set_arousal(max(target.sexcon.arousal, 50))
	target.visible_message(span_purple("Faint purple flames flicker across [target]'s lower abdomen, tracing the freshly drawn sigil before fading."), span_purple("A pleasant warmth spreads through my lower abdomen as the mark settles into my skin."))
	target.emote("groan", forced = TRUE)
	to_chat(target, span_purple("The warmth softens, leaving a gentle tingle beneath Baotha's mark."))

/obj/item/baotha_crayon/proc/marking_attempt_active(mob/living/user, mob/living/carbon/human/target, client/drawer_client, client/recipient_client)
	if(QDELETED(src) || QDELETED(user) || QDELETED(target))
		return FALSE
	if(!drawer_client || !recipient_client || user.client != drawer_client || target.client != recipient_client)
		return FALSE
	return user.get_active_held_item() == src && (user == target || user.Adjacent(target))

/// Shared with the rune: use the existing tattoo and short-body offsets.
/mob/living/carbon/human/proc/add_baotha_fertility_mark()
	var/mutable_appearance/marking_overlay = mutable_appearance('icons/roguetown/misc/baotha_marking.dmi', "marking_[gender == MALE ? "m" : "f"]", -BODY_LAYER)
	if(isdwarf(src) || isgoblinp(src) || iskobold(src) || iscritter(src))
		marking_overlay.pixel_y -= gender == MALE ? 6 : 4
	add_overlay(marking_overlay)
	update_body_parts()

/mob/living/carbon/human/proc/grant_baotha_fertility_boon()
	ADD_TRAIT(src, TRAIT_BAOTHA_FERTILITY_BOON, TRAIT_GENERIC)
	var/obj/item/organ/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)
	if(istype(vagina))
		vagina.fertility = TRUE

/obj/item/ritechalk
	name = "Ritual Chalk"
	icon_state = "chalk"
	desc = "Simple white chalk. A useful tool for rites."
	icon = 'icons/roguetown/misc/rituals.dmi'
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	dropshrink = 0.6

/obj/item/ritechalk/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("I don't know what I'm doing with this..."))
		return

	var/ritechoices = list()
	switch (user.patron?.type)
		if(/datum/patron/inhumen/graggar)
			ritechoices+="Rune of Violence"
		if(/datum/patron/inhumen/zizo)
			ritechoices+="Rune of ZIZO"
		if(/datum/patron/inhumen/matthios)
			ritechoices+="Rune of Transaction"
		if(/datum/patron/inhumen/baotha)
			ritechoices+="Rune of Hedonism"
		if(/datum/patron/divine/astrata)
			ritechoices+="Rune of Sun"
		if(/datum/patron/divine/noc)
			ritechoices+="Rune of Moon"
		if(/datum/patron/divine/dendor)
			ritechoices+="Rune of Beasts"
		if(/datum/patron/divine/malum)
			ritechoices+="Rune of Forge"
		if(/datum/patron/divine/xylix)
			ritechoices+="Rune of Trickery"
		if(/datum/patron/divine/necra)
			ritechoices+="Rune of Death"
		if(/datum/patron/divine/pestra)
			ritechoices+="Rune of Plague"
		if(/datum/patron/divine/eora)
			ritechoices+="Rune of Love"
		if(/datum/patron/divine/ravox)
			ritechoices+="Rune of Justice"
		if(/datum/patron/divine/abyssor)
			ritechoices+="Rune of Storm"
			ritechoices+="Rune of Stirring"
		if(/datum/patron/old_god)
			ritechoices+="Rune of Enduring"

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER) && !("Rune of Stirring" in ritechoices))
		ritechoices+="Rune of Stirring"

	var/runeselection = input(user, "Which rune shall I inscribe?", src) as null|anything in ritechoices
	var/turf/step_turf = get_step(get_turf(user), user.dir)
	switch(runeselection)
		if("Rune of Sun")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Radiance..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/astrata(step_turf)
		if("Rune of Moon")
			to_chat(user, span_cultsmall("I begin inscribing the rune of His Wisdom."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/noc(step_turf)
		if("Rune of Beasts")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Madness."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/dendor(step_turf)
		if("Rune of Forge")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Their Craft..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/malum(step_turf)
		if("Rune of Trickery")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Trickery..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/xylix(step_turf)
		if("Rune of Death")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Embrace..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/necra(step_turf)
		if("Rune of Plague")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Plague..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/pestra(step_turf)
		if("Rune of Love")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Love..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/eora(step_turf)
		if("Rune of Justice")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Justice..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/ravox(step_turf)
		if("Rune of Storm")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Storm..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor(step_turf)
		if("Rune of Stirring")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Dream..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/abyssor_alt_inactive(step_turf)
		if("Rune of ZIZO")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Her Knowledge..."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/zizo(step_turf)
		if("Rune of Transaction")
			to_chat(user,span_cultsmall("I begin inscribing the rune of His Transactions."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/matthios(step_turf)
		if("Rune of Violence")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Slaughter."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/graggar(step_turf)
		if("Rune of Hedonism")
			to_chat(user,span_cultsmall("I begin inscribing the rune of Addiction."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/baotha(step_turf)
		if("Rune of Enduring")
			to_chat(user,span_cultsmall("I begin inscribing His holy symbol."))
			if(do_after(user, 30, src))
				playsound(src, 'sound/foley/scribble.ogg', 40, TRUE)
				new /obj/structure/ritualcircle/psydon(step_turf)
