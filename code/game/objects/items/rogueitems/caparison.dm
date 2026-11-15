/obj/item/caparison
	name = "caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. This one fits on a Saiga."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "caparison"
	var/caparison_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	var/caparison_state = "caparison"
	/// Taur body wearing this cloth, if any.
	var/obj/item/bodypart/taur/taur_wearer
	/// Removal action granted only while the cloth is fitted to a taur.
	var/datum/action/item_action/remove_taur_caparison/taur_remove_action
	var/detail_state
	var/list/detail_types
	var/list/symbol_types
	var/female_caparison_state = "caparison-f"
	gender = NEUTER
	var/list/valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/saiga)

/obj/item/caparison/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/human = M
		var/obj/item/bodypart/taur/taur = human.get_taur_tail()
		if(!taur || !taur.get_caparison_state(src))
			to_chat(user, span_warning("This caparison does not fit that body."))
			return
		if(taur.applied_caparison)
			to_chat(user, span_warning("[human] is already wearing a caparison."))
			return
		if(!do_after(user, 5 SECONDS, TRUE, human))
			return
		if(QDELETED(taur) || human.get_taur_tail() != taur || taur.applied_caparison)
			return
		if(!user.transferItemToLoc(src, human))
			return
		taur_wearer = taur
		taur.applied_caparison = src
		taur_remove_action = new(src)
		taur_remove_action.Grant(human)
		human.update_body_parts(redraw = TRUE)
		user.visible_message(span_notice("[user] fits [src] onto [human]."))
		return
	if(!issimple(M))
		to_chat(user, span_warning("\The [src] can only be used on animals!"))
		return
	if(!is_type_in_list(M, valid_animal_types))
		to_chat(user, span_warning("\The [src] cannot be used on [M]! It is only meant for specific animals."))
		return

	var/mob/living/simple_animal/animal = M
	if(animal.adult_growth)
		to_chat(user, span_warning("[animal] is a juvenile and cannot wear a caparison!"))
		return
	if(animal.ccaparison)
		to_chat(user, span_warning("[animal] is already wearing a caparison!"))
		return
	if(!animal.ssaddle)
		to_chat(user, span_warning("[animal] needs to be saddled before you can fit a caparison onto it!"))
		return

	user.visible_message(span_notice("[user] is fitting a caparison onto [animal]..."), span_notice("I start fitting a caparison onto [animal]..."))
	if(!do_after(user, 5 SECONDS, TRUE, animal))
		return

	animal.ccaparison = src
	forceMove(animal)
	animal.update_icon()
	user.visible_message(span_notice("[user] fits a caparison onto [animal]."), span_notice("I fit a caparison onto [animal]."))

/obj/item/caparison/rmb_self(mob/user)
	attack_right(user)

/obj/item/caparison/attack_right(mob/user)
	if(!length(detail_types))
		return

	var/list/possible_detail_types = list("None" = null) + detail_types.Copy()
	if(length(symbol_types))
		possible_detail_types += list("Symbol" = null)

	var/chosen_design = input(user, "Select a design.", "Caparison Design") as null|anything in possible_detail_types
	if(!chosen_design)
		return

	if(chosen_design == "Symbol")
		var/chosen_symbol = input(user, "Select a symbol.", "Caparison Design") as null|anything in symbol_types
		if(!chosen_symbol)
			return
		detail_state = symbol_types[chosen_symbol]
	else
		detail_state = detail_types[chosen_design]

	var/list/colors_to_pick = list()
	if(GLOB.lordprimary)
		colors_to_pick["Primary Keep Color"] = GLOB.lordprimary
	if(GLOB.lordsecondary)
		colors_to_pick["Secondary Keep Color"] = GLOB.lordsecondary
	var/list/color_map_list = GLOB.colorlist
	colors_to_pick += color_map_list.Copy()

	var/primary_color = input(user, "Select a primary color.", "Caparison Design") as null|anything in colors_to_pick
	if(!primary_color)
		return
	color = colors_to_pick[primary_color]

	if(chosen_design != "None")
		if(chosen_design != "Symbol")
			var/secondary_color = input(user, "Select a secondary color.", "Caparison Design") as null|anything in colors_to_pick
			if(!secondary_color)
				return
			detail_color = colors_to_pick[secondary_color]
		else
			detail_color = COLOR_WHITE

//////////////////////
// SUBTYPES - SAIGA //
//////////////////////

/obj/item/caparison/proc/remove_from_taur(move_to_floor = TRUE)
	var/obj/item/bodypart/taur/taur = taur_wearer
	if(!taur)
		return
	var/mob/living/carbon/human/human = taur.owner
	taur_wearer = null
	taur.applied_caparison = null
	QDEL_NULL(taur_remove_action)
	if(move_to_floor)
		forceMove(get_turf(human || taur))
	if(human && !QDELETED(human))
		human.update_body_parts(redraw = TRUE)

/obj/item/caparison/Moved(atom/oldloc, movement_dir, forced = FALSE)
	. = ..()
	if(taur_wearer && loc != taur_wearer.owner)
		remove_from_taur(FALSE)

/obj/item/caparison/Destroy()
	remove_from_taur(FALSE)
	return ..()

/obj/item/caparison/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/item_action/remove_taur_caparison))
		if(taur_wearer?.owner != user)
			return
		remove_from_taur()
		user.put_in_hands(src)
		return
	return ..()

/obj/item/caparison/psy
	name = "psydonite caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Psycrosses. This one fits on a Saiga."
	caparison_state = "psy_caparison"
	female_caparison_state = "psy_caparison-f"

/obj/item/caparison/astrata
	name = "astratan caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Astratan crosses. This one fits on a Saiga."
	caparison_state = "astra_caparison"
	female_caparison_state = "astra_caparison-f"

/obj/item/caparison/eora
	name = "eoran caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with Eoran hearts. This one fits on a Saiga."
	caparison_state = "eora_caparison"
	female_caparison_state = "eora_caparison-f"

/obj/item/caparison/azure
	name = "azurean caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with ducal colours. This one fits on a Saiga."
	caparison_state = "azure_caparison"
	female_caparison_state = "azure_caparison-f"

/obj/item/caparison/heartfelt
	name = "Heartfelt caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with the colours of Heartfelt. This one fits on a Saiga."
	caparison_state = "heartfelt_caparison"
	female_caparison_state = "heartfelt_caparison-f"

/////////////////////////
// SUBTYPES - FOGBEAST //
/////////////////////////

/obj/item/caparison/fogbeast
	name = "caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. This one fits on a Fogbeast."
	caparison_icon = 'icons/roguetown/mob/monster/fogbeast.dmi'
	valid_animal_types = list(/mob/living/simple_animal/hostile/retaliate/rogue/fogbeast)
	color = COLOR_WHITE
	detail_types = list("Quad" = "quad")
	symbol_types = list("Psycross" = "psycross", "Astrata" = "astrata")

/obj/item/caparison/fogbeast/azure
	name = "azurean caparison"
	desc = "A decorative piece of cloth meant to be used as a saddle decoration. It's adorned with ducal colours. This one fits on a Fogbeast."
	caparison_state = "azure_caparison"
	female_caparison_state = "azure_caparison"

/datum/action/item_action/remove_taur_caparison
	name = "Remove Caparison"
	desc = "Remove the decorative cloth from your taur body."
