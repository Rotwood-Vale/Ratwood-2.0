/obj/item/rogueweapon/surgery
	name = "surgical tool"
	desc = "Something that will tear your guts apart."
	icon = 'icons/roguetown/items/surgery.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 175
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = null

	grid_width = 32
	grid_height = 64

/obj/item/rogueweapon/surgery/Initialize(mapload)
	. = ..()
	item_flags |= SURGICAL_TOOL //let's not stab patients for fun

/obj/item/rogueweapon/surgery/scalpel
	name = "scalpel"
	desc = "A tool used to carve precisely into the flesh of the sickly."
	icon_state = "scalpel"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_SCALPEL
	smeltresult = null

/obj/item/rogueweapon/surgery/saw
	name = "saw"
	desc = "A tool used to carve through bone."
	icon_state = "bonesaw"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	force = 16
	throwforce = 16
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_CHOP
	tool_behaviour = TOOL_SAW
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat
	name = "forceps"
	desc = "A tool used to clamp down on soft tissue."
	icon_state = "forceps"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_HEMOSTAT
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat/first //Three different types now to allow multiple surgical sites at once.
	name = "\improper Tarsis forceps"

/obj/item/rogueweapon/surgery/hemostat/second
	name = "\improper Sisrat forceps"

/obj/item/rogueweapon/surgery/hemostat/third
	name = "\improper Medella forceps"

/obj/item/rogueweapon/surgery/retractor
	name = "speculum"
	desc = "A tool used to spread tissue open for surgical access."
	icon_state = "speculum"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_RETRACTOR
	smeltresult = null

/obj/item/rogueweapon/surgery/bonesetter
	name = "bone forceps"
	desc = "A tool used to clamp down on hard tissue."
	icon_state = "bonesetter"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_BONESETTER
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery
	name = "cautery iron"
	desc = "A tool used to cauterize wounds. Heat it up before use."
	icon_state = "cauteryiron"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 18
	throwforce = 18
	wdefense = 3
	wbalance = WBALANCE_HEAVY	//huh?
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	/// Timer to cool down
	var/cool_timer
	/// Whether or not we are heated up
	var/heated = FALSE
	// If we mark them as a slave (applies trait, needs pref toggle)
	var/enslave = FALSE
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery/examine(mob/user)
	. = ..()
	if(heated)
		. += span_warning("The tip is hot to the touch.")

/obj/item/rogueweapon/surgery/cautery/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)
	if(heated)
		icon_state = "[initial(icon_state)]_hot"

/obj/item/rogueweapon/surgery/cautery/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/heating = 0
	if(istype(A, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/forge = A
		if(forge.on)
			heating = 20
	if(heating)
		user.visible_message(span_info("[user] heats [src]."))
		fire_act(heating)
		return TRUE
	return ..()

/obj/item/rogueweapon/surgery/cautery/fire_act(added, maxstacks)
	. = ..()
	if(!heated)
		playsound(src, 'sound/items/firelight.ogg', 100, vary = TRUE)
	update_heated(TRUE)
	if(cool_timer)
		deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(update_heated), FALSE), added SECONDS, TIMER_STOPPABLE)

/obj/item/rogueweapon/surgery/cautery/get_temperature()
	if(heated)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/rogueweapon/surgery/cautery/proc/update_heated(new_heated)
	heated = new_heated
	if(heated)
		damtype = BURN
		tool_behaviour = TOOL_CAUTERY
	else
		damtype = BRUTE
		tool_behaviour = null
	update_icon()

/obj/item/rogueweapon/surgery/cautery/branding
	name = "branding iron"
	desc = "A iron that is well-writ upon flesh. Heat it up before use."
	icon_state = "brandingiron"
	possible_item_intents = list(/datum/intent/use)
	var/setbranding = null
	var/remove_existing_brand = FALSE
	var/branding_damage = 20
	var/branding_low_quality = FALSE
	var/branding_count = 0

/obj/item/rogueweapon/surgery/cautery/branding/slave
	name = "slaver branding iron"
	desc = "Used to claim ownership on lost property. Heat it up before use."

/obj/item/rogueweapon/surgery/cautery/branding/crude
	name = "crude branding stick"
	desc = "It's made of coal, string and a stick. Looks like I can brand myself with it at least two times before it snaps. Heat it up before use."
	icon_state = "brandingiron_crude"
	branding_damage = 10
	branding_low_quality = TRUE
	branding_count = 2

/obj/item/rogueweapon/surgery/cautery/branding/examine(mob/user)
	. = ..()
	if(remove_existing_brand)
		. += span_warning("It is set to remove existing brands.")
	else
		if(!setbranding || !length(setbranding))
			. += span_warning("There is no branding symbol set yet.")
		if(enslave)
			. += span_warning("It will imprint [setbranding], a permanent mark of ownership")
		else
			. += span_warning("It will imprint [setbranding]")

/obj/item/rogueweapon/surgery/cautery/branding/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(!user.cmode)
		if(heated)
			to_chat(user, span_warning("It is too hot to change the symbols!"))
			return
		var/list/options = list("Set symbol", "Toggle permanent slave mark", "Toggle remove existing brand", "Cancel")
		var/choice = tgui_input_list(user, "What would you like to do with the branding iron?", "Branding Iron", options, null, 10 SECONDS)
		switch(choice)
			if("Set symbol")
				var/inputty = stripped_input(user, "What would you like to set the brand?\nExample: a small drawing of a rous head", "Enter branding description", null, 64)
				if(inputty)
					setbranding = inputty
					to_chat(user, span_warning("I swap the [!branding_low_quality ? "iron" : "coal"] tip so it will imprint [setbranding]."))
				else
					to_chat(user, span_info("I clear the current branding symbol."))
					setbranding = null
			if("Toggle permanent slave mark")
				enslave = !enslave
				if(enslave)
					to_chat(user, span_warning("I set the iron to leave a permanent mark of slavery."))
				else
					to_chat(user, span_info("I set the iron to leave a simple brand only."))
			if("Toggle remove existing brand")
				remove_existing_brand = !remove_existing_brand
				if(remove_existing_brand)
					to_chat(user, span_warning("I set the iron to burn away existing brands."))
				else
					to_chat(user, span_info("I set the iron to imprint new brands."))
	..()
// Stops someone being marked as owned if they already are. Needs to be removed before it can proceed (does not affect normal branding)
/obj/item/rogueweapon/surgery/cautery/branding/proc/target_has_active_ownership_mark(mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE
	return target.has_active_ownership_mark()

/obj/item/rogueweapon/surgery/cautery/branding/proc/get_active_ownership_brand_info(mob/living/carbon/human/target)
	if(!istype(target))
		return list("name" = "", "owner" = null)
	return target.get_active_ownership_brand_info()

/obj/item/rogueweapon/surgery/cautery/branding/proc/update_slave_mark_trait(mob/living/carbon/human/target)
	if(!istype(target))
		return
	target.update_owned_slave_trait()

// Maps a chosen button label to the backing bodypart/organ and brand text var
/obj/item/rogueweapon/surgery/cautery/branding/proc/get_brand_target_data(selection, obj/item/bodypart/branding_part, obj/item/organ/penis/penis, obj/item/organ/vagina/vagina, obj/item/organ/testicles/testes, obj/item/organ/breasts/tits)
	if(!selection)
		return null
	switch(selection)
		if("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Tauric Half")
			return list("holder" = branding_part, "text_var" = "branded_writing")
		if("Hind")
			if(!istype(branding_part, /obj/item/bodypart/chest))
				return null
			return list("holder" = branding_part, "text_var" = "branded_writing_on_buttocks")
		if("Stomach")
			if(!istype(branding_part, /obj/item/bodypart/chest))
				return null
			return list("holder" = branding_part, "text_var" = "branded_writing_on_stomach")
		if("Neck")
			if(!istype(branding_part, /obj/item/bodypart/head))
				return null
			return list("holder" = branding_part, "text_var" = "branded_writing_on_neck")
		if("Breasts")
			if(QDELETED(tits))
				return null
			return list("holder" = tits, "text_var" = "branded_writing")
		if("Dick")
			if(QDELETED(penis))
				return null
			return list("holder" = penis, "text_var" = "branded_writing")
		if("Vagina")
			if(QDELETED(vagina))
				return null
			return list("holder" = vagina, "text_var" = "branded_writing")
		if("Testes")
			if(QDELETED(testes))
				return null
			return list("holder" = testes, "text_var" = "branded_writing")
	return null

// Builds available zone choices and caches any visible organs needed later
/obj/item/rogueweapon/surgery/cautery/branding/proc/build_branding_zone_data(mob/living/carbon/human/target, precise_zone, body_zone, obj/item/bodypart/branding_part)
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
				zone_options += "Head"
				if(!target.is_mouth_covered())
					zone_options += "Mouth"
				if(get_location_accessible(target, BODY_ZONE_PRECISE_NECK))
					zone_options += "Neck"
		if(BODY_ZONE_L_LEG)
			if(istype(branding_part, /obj/item/bodypart/taur))
				zone_options += "Tauric Half"
			else
				zone_options += "Left Leg"
		if(BODY_ZONE_R_LEG)
			if(istype(branding_part, /obj/item/bodypart/taur))
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

// Remove mode cannot act on mouth burns, so keep those out of the prompt
/obj/item/rogueweapon/surgery/cautery/branding/proc/filter_zone_options_for_brand_removal(list/zone_options, obj/item/bodypart/branding_part, obj/item/organ/penis/penis, obj/item/organ/vagina/vagina, obj/item/organ/testicles/testes, obj/item/organ/breasts/tits)
	var/list/removable_options = list()
	for(var/zone_option in zone_options)
		if(zone_option == "Mouth")
			continue
		if(has_removable_brand_at_selection(zone_option, branding_part, penis, vagina, testes, tits))
			removable_options += zone_option
	return removable_options

/obj/item/rogueweapon/surgery/cautery/branding/proc/rebuild_branding_selection_data(mob/living/carbon/human/target, precise_zone)
	var/body_zone = check_zone(precise_zone)
	var/obj/item/bodypart/branding_part = target.get_bodypart(body_zone)
	if(QDELETED(branding_part) || !istype(branding_part))
		return null
	var/list/zone_data = build_branding_zone_data(target, precise_zone, body_zone, branding_part)
	zone_data["body_zone"] = body_zone
	zone_data["branding_part"] = branding_part
	return zone_data

/obj/item/rogueweapon/surgery/cautery/branding/proc/holder_has_enslavement_mark(obj/item/holder)
	if(istype(holder, /obj/item/bodypart))
		var/obj/item/bodypart/bodypart_holder = holder
		return bodypart_holder.enslavement_mark
	if(istype(holder, /obj/item/organ))
		var/obj/item/organ/organ_holder = holder
		return organ_holder.enslavement_mark
	return FALSE

/obj/item/rogueweapon/surgery/cautery/branding/proc/set_holder_ownership_data(obj/item/holder, should_enslave, mob/living/user)
	if(istype(holder, /obj/item/bodypart))
		var/obj/item/bodypart/bodypart_holder = holder
		bodypart_holder.enslavement_mark = should_enslave
		if(should_enslave)
			bodypart_holder.brand_owner_name = user.real_name
			bodypart_holder.brand_owner = user
		else
			bodypart_holder.brand_owner_name = ""
			bodypart_holder.brand_owner = null
		return
	if(istype(holder, /obj/item/organ))
		var/obj/item/organ/organ_holder = holder
		organ_holder.enslavement_mark = should_enslave
		if(should_enslave)
			organ_holder.brand_owner_name = user.real_name
			organ_holder.brand_owner = user
		else
			organ_holder.brand_owner_name = ""
			organ_holder.brand_owner = null

/obj/item/rogueweapon/surgery/cautery/branding/proc/has_removable_brand_at_selection(selection, obj/item/bodypart/branding_part, obj/item/organ/penis/penis, obj/item/organ/vagina/vagina, obj/item/organ/testicles/testes, obj/item/organ/breasts/tits)
	var/list/target_data = get_brand_target_data(selection, branding_part, penis, vagina, testes, tits)
	if(!length(target_data))
		return FALSE
	var/obj/item/holder = target_data["holder"]
	if(QDELETED(holder))
		return FALSE
	var/text_var = target_data["text_var"]
	var/existing_text = holder.vars[text_var]
	if(isnull(existing_text))
		existing_text = ""
	return length(existing_text) || holder_has_enslavement_mark(holder)

/obj/item/rogueweapon/surgery/cautery/branding/proc/apply_brand_to_target_data(mob/living/user, list/target_data, branding_text, should_enslave)
	if(!length(target_data))
		return FALSE
	var/obj/item/holder = target_data["holder"]
	if(QDELETED(holder))
		return FALSE
	var/text_var = target_data["text_var"]
	if(length(holder.vars[text_var]))
		to_chat(user, span_warning("I reburn over the existing marking."))
	holder.vars[text_var] = branding_text
	set_holder_ownership_data(holder, should_enslave, user)
	return TRUE

/obj/item/rogueweapon/surgery/cautery/branding/proc/clear_brand_from_target_data(list/target_data, mob/living/user)
	if(!length(target_data))
		return FALSE
	var/obj/item/holder = target_data["holder"]
	if(QDELETED(holder))
		return FALSE
	var/text_var = target_data["text_var"]
	var/existing_text = holder.vars[text_var]
	if(isnull(existing_text))
		existing_text = ""
	if(!length(existing_text) && !holder_has_enslavement_mark(holder))
		return FALSE
	holder.vars[text_var] = ""
	set_holder_ownership_data(holder, FALSE, user)
	return TRUE

/obj/item/rogueweapon/surgery/cautery/branding/proc/selection_applies_knockdown(selection)
	switch(selection)
		if("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Tauric Half")
			return FALSE
	return TRUE

// Keeps the cheap branded flag in sync after apply/remove operations
/obj/item/rogueweapon/surgery/cautery/branding/proc/target_has_any_branding(mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE
	for(var/obj/item/bodypart/bodypart as anything in target.bodyparts)
		if(length(bodypart.branded_writing) || bodypart.enslavement_mark)
			return TRUE
		if(istype(bodypart, /obj/item/bodypart/chest))
			var/obj/item/bodypart/chest/chest = bodypart
			if(length(chest.branded_writing_on_buttocks) || length(chest.branded_writing_on_stomach))
				return TRUE
		else if(istype(bodypart, /obj/item/bodypart/head))
			var/obj/item/bodypart/head/head = bodypart
			if(length(head.branded_writing_on_neck))
				return TRUE
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		if(organ.enslavement_mark)
			return TRUE
		if("branded_writing" in organ.vars && length(organ.vars["branded_writing"]))
			return TRUE
	return FALSE

// Keeps the do_after announcement text centralized for both modes
/obj/item/rogueweapon/surgery/cautery/branding/proc/send_branding_attempt_messages(mob/living/user, mob/living/carbon/human/target, final_answer, branding_self)
	if(!branding_self)
		if(remove_existing_brand)
			user.visible_message(span_warning("[user] slowly wields [src] towards [target]'s [LOWER_TEXT(final_answer)] to burn away an old mark."))
			to_chat(target, span_userdanger("[user] is trying to burn away a brand on my [LOWER_TEXT(final_answer)]!"))
		else
			user.visible_message(span_warning("[user] slowly wields [src] towards [target]'s [LOWER_TEXT(final_answer)]."))
			to_chat(target, span_userdanger("[user] is trying to brand me on the [LOWER_TEXT(final_answer)]!"))
	else
		if(remove_existing_brand)
			user.visible_message(span_warning("[user] slowly wields [src] onto [user.p_their()] [LOWER_TEXT(final_answer)] to burn away an old mark."))
		else
			user.visible_message(span_warning("[user] slowly wields [src] onto [user.p_their()] [LOWER_TEXT(final_answer)]."))

/obj/item/rogueweapon/surgery/cautery/branding/proc/send_branding_result_messages(mob/living/user, mob/living/carbon/human/target, description_recoil, final_answer, branding_text)
	if(remove_existing_brand)
		user.visible_message(span_info("[target] [description_recoil] as \the [src] sears away a brand on [target.p_their()] [LOWER_TEXT(final_answer)]!"))
		to_chat(target, span_userdanger("A brand has been burned away!"))
	else
		user.visible_message(span_info("[target] [description_recoil] as \the [src] sears a mark on [target.p_their()] [LOWER_TEXT(final_answer)]! The fresh brand shows [span_boldwarning(branding_text)]."))
		to_chat(target, span_userdanger("You have been branded!"))

// Single entry point for action-phase combat logs
/obj/item/rogueweapon/surgery/cautery/branding/proc/log_branding_action(mob/living/user, mob/living/carbon/human/target, action_type, final_answer, branding_text, branding_delay, ownership_state, enslave)
	switch(action_type)
		if("attempt")
			if(remove_existing_brand)
				log_combat(user, target, "Brand removal attempt on [final_answer] ([branding_delay]s), ownership before: [ownership_state]")
			else
				log_combat(user, target, "Branding attempt: \"[branding_text]\" on [final_answer] ([branding_delay]s), requested slave mark: [enslave], ownership before: [ownership_state]")
		if("aborted")
			if(remove_existing_brand)
				log_combat(user, target, "Brand removal aborted on [final_answer], ownership at abort: [ownership_state]")
			else
				log_combat(user, target, "Branding aborted: \"[branding_text]\" on [final_answer], ownership at abort: [ownership_state]")
		if("part_destroyed")
			if(remove_existing_brand)
				log_combat(user, target, "Brand removal failed (part destroyed) on [final_answer], ownership at abort: [ownership_state]")
			else
				log_combat(user, target, "Branding part destroyed: \"[branding_text]\" on [final_answer], ownership at abort: [ownership_state]")
		if("success")
			if(remove_existing_brand)
				log_combat(user, target, "Brand removal successful on [final_answer], ownership after: [ownership_state]")
			else
				log_combat(user, target, "Branded successful: \"[branding_text]\" on [final_answer], ownership after: [ownership_state]")

/obj/item/rogueweapon/surgery/cautery/branding/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(!heated)
		return ..()
	if(!remove_existing_brand && !length(setbranding))
		to_chat(user, span_warning("There is nothing to brand, add some symbols before using again."))
		return TRUE
	if(!ishuman(A))
		to_chat(user, span_warning("I cannot brand [A]."))
		return TRUE
	var/mob/living/carbon/human/target = A
	var/precise_zone = user.zone_selected // We need this up here to stay consistent past the do_after.
	var/body_zone = check_zone(precise_zone) 
	var/obj/item/bodypart/branding_part = target.get_bodypart(body_zone)
	var/branding_self = user == target
	if(!get_location_accessible(target, user.zone_selected))
		to_chat(user, span_warning("That part is obstructed by clothing."))
		return TRUE

	// Get the area we want to brand, and then prompt the user for what to brand/whether we should brand that zone.
	if(QDELETED(branding_part) || !istype(branding_part))
		to_chat(user, span_warning("They don't have this part..."))
		return TRUE

	var/list/zone_data = build_branding_zone_data(target, precise_zone, body_zone, branding_part)
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
			to_chat(user, span_warning("It doesn't seem like this part can be branded!"))
		return TRUE

	if(remove_existing_brand)
		var/list/removable_options = filter_zone_options_for_brand_removal(zone_data["options"], branding_part, penis, vagina, testes, tits)
		if(!length(removable_options))
			to_chat(user, span_warning("There are no removable brands on any accessible body part."))
			return TRUE
		removable_options += "Cancel"
		zone_options = removable_options

	var/branding_text = remove_existing_brand ? null : setbranding // No switcheroos partway through.
	var/final_answer // String. The button the user clicks on when prompted which part to brand.

	// Prompt before do_after
	final_answer = tgui_alert(user, "What do you wish to [remove_existing_brand ? "remove" : "brand"]?", "Please answer in [DisplayTimeText(10 SECONDS)]!", zone_options, 10 SECONDS)

	if(!final_answer || final_answer == "Cancel")
		return TRUE

	// Reject branding if disallowed by prefs. Doing it here hides less away from the user.
	if(!branding_self && !remove_existing_brand)
		switch(final_answer)
			if("Breasts", "Dick", "Vagina", "Testes")
				if(!target.client)
					to_chat(user, span_warning("[target] can't receive a brand here right now."))
					log_combat(user, target, "Branding on offline mob blocked: \"[branding_text]\" on [final_answer]")
					return TRUE
				if(!target.client.prefs?.sensitive_brands)
					to_chat(user, span_warning("[target] has sensitive brands disabled."))
					to_chat(target, span_warning("A branding attempt on my [LOWER_TEXT(final_answer)] was blocked by preferences."))
					log_combat(user, target, "Branding prefblocked: \"[branding_text]\" on [final_answer]")
					return TRUE
			if("Head")
				if(!target.client)
					to_chat(user, span_warning("[target] can't receive a brand here right now."))
					log_combat(user, target, "Branding on offline mob blocked: \"[branding_text]\" on [final_answer]")
					return TRUE
				if(!target.client.prefs?.facial_brands)
					to_chat(user, span_warning("[target] has facial brands disabled."))
					to_chat(target, span_warning("A branding attempt on my [LOWER_TEXT(final_answer)] was blocked by preferences."))
					log_combat(user, target, "Branding prefblocked: \"[branding_text]\" on [final_answer]")
					return TRUE

	if(!remove_existing_brand && enslave && target_has_active_ownership_mark(target))
		to_chat(user, span_warning("I cannot mark them as owned, they already have a mark of ownership! I need to burn that away first..."))
		return TRUE

	// A part has been selected, now we start printing messages to chat and showing the do_after
	var/branding_delay = HAS_TRAIT(user, TRAIT_DUNGEONMASTER) ? 7 SECONDS : (HAS_TRAIT(user, TRAIT_KNOWNCRIMINAL) ? 9 SECONDS : 14 SECONDS) // criminals/dungeoneer burn faster, while non-criminals and towners take the longest time
	if(!branding_self) 
		if(branding_low_quality)
			if(!target.compliance)  // we can only brand ourselves OR the other character must be compliant
				to_chat(user, span_warning("[target]'s moving too much to let me [remove_existing_brand ? "burn away old marks from" : "brand"] [target.p_them()]!"))
				return TRUE
			branding_delay += 3 SECONDS // if they are compliant then there will still be an added delay
	else
		if(!branding_low_quality)
			branding_delay -= 4 SECONDS // quicker to brand yourself using a good tool
	send_branding_attempt_messages(user, target, final_answer, branding_self)

	var/ownership_state_before = target_has_active_ownership_mark(target) ? "owned" : "not owned"
	log_branding_action(user, target, "attempt", final_answer, branding_text, branding_delay, ownership_state_before, enslave)

	if(!do_after(user, branding_delay, target = target))
		if(!QDELETED(target))
			log_branding_action(user, target, "aborted", final_answer, branding_text, branding_delay, ownership_state_before, enslave)
		return TRUE
	if(!user.Adjacent(target) || user.stat >= UNCONSCIOUS)
		log_branding_action(user, target, "aborted", final_answer, branding_text, branding_delay, ownership_state_before, enslave)
		return TRUE

	if(QDELETED(branding_part))
		log_branding_action(user, target, "part_destroyed", final_answer, branding_text, branding_delay, ownership_state_before, enslave)
		return TRUE

	// Rebuild options after do_after so limb/coverage changes cannot apply to stale selections
	var/list/live_zone_data = rebuild_branding_selection_data(target, precise_zone)
	if(!length(live_zone_data))
		to_chat(user, span_warning("They no longer have that part."))
		return TRUE
	branding_part = live_zone_data["branding_part"]
	penis = live_zone_data["penis"]
	vagina = live_zone_data["vagina"]
	testes = live_zone_data["testes"]
	tits = live_zone_data["tits"]
	zone_options = live_zone_data["options"]
	if(remove_existing_brand)
		zone_options = filter_zone_options_for_brand_removal(zone_options, branding_part, penis, vagina, testes, tits)
	if(!(final_answer in zone_options))
		to_chat(user, span_warning("That body part is no longer available for [remove_existing_brand ? "brand removal" : "branding"]."))
		return TRUE

	// Attempt to re-get the part and place the brand
	var/description_recoil = target.stat < UNCONSCIOUS ? pick("recoils", "writhes", "thrashes", "suffers") : "lays still"
	var/apply_knockdown = selection_applies_knockdown(final_answer)
	var/apply_message = TRUE
	var/list/selected_target_data = get_brand_target_data(final_answer, branding_part, penis, vagina, testes, tits)
	if(remove_existing_brand)
		if(final_answer == "Mouth")
			to_chat(user, span_warning("That burn cannot be removed this way."))
			return TRUE
		if(!clear_brand_from_target_data(selected_target_data, user))
			to_chat(user, span_warning("There is no existing brand to remove there."))
			return TRUE
	else
		switch(final_answer)
			if("Mouth")
				user.visible_message(span_info("[target] [description_recoil] as \the [src] sears onto [target.p_their()] lips! The branding leaves an unrecognizable burn."))
				target.apply_status_effect(/datum/status_effect/mouth_branded)
				to_chat(target, span_userdanger("Your mouth has been seared!"))
				apply_message = FALSE
			else
				if(!apply_brand_to_target_data(user, selected_target_data, branding_text, enslave))
					to_chat(user, span_warning("There's a problem with branding this body part."))
					return TRUE

	if(length(selected_target_data))
		branding_part = selected_target_data["holder"]

	target.branded = target_has_any_branding(target) // makes examine check for branding marks
	update_slave_mark_trait(target)
	var/ownership_state_after = target_has_active_ownership_mark(target) ? "owned" : "not owned"
	target.apply_damage(branding_damage, BURN, branding_part)
	if(!branding_self && apply_knockdown)
		target.Knockdown(1 SECONDS)
	if(apply_message)
		send_branding_result_messages(user, target, description_recoil, final_answer, branding_text)
	
	target.emote(prob(50) ? "painscream" : "scream", forced = TRUE)
	target.Stun(40)
	target.fullscreen_redflash("redflash2")
	playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
	update_heated(FALSE)
	if(cool_timer)
		deltimer(cool_timer)
	log_branding_action(user, target, "success", final_answer, branding_text, branding_delay, ownership_state_after, enslave)
	if(branding_count > 0)
		branding_count--
		if(branding_count == 0)
			to_chat(user, span_warning("\The [src] snaps in your hands, it's broken!"))
			playsound(user, 'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
	return TRUE

/datum/status_effect/mouth_branded
	id = "mouth_branded"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = -1
	alert_type = /atom/movable/screen/alert/status_effect/mouth_branded

/atom/movable/screen/alert/status_effect/mouth_branded
	name = "Burned Mouth"
	desc = "I can't feel my lips!"

/datum/status_effect/mouth_branded/on_apply()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_warning("My mouth... It BURNS!"))
	return ..()

/datum/status_effect/mouth_branded/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, TRAIT_STATUS_EFFECT(id))
	if(owner.stat == CONSCIOUS)
		to_chat(owner, span_userdanger("I can barely feel my lips again."))

/obj/item/rogueweapon/surgery/hammer
	name = "examination hammer"
	desc = "A small hammer used to check a patient's reactions and diagnose their condition."
	icon_state = "kneehammer"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 10
	throwforce = 8
	wdefense = 3
	wbalance = -1
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/surgery/hammer/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	if(medskill < SKILL_LEVEL_NOVICE)
		return ..()
	if(ishuman(A))
		if(A == user)
			user.visible_message("<span class='info'>[user] begins smacking themself with a small hammer.</span>")
		else
			user.visible_message("<span class='info'>[user] begins to smack [A] with a small hammer.</span>")
		if(do_after(user, ((medskill > SKILL_LEVEL_EXPERT) ? 1 SECONDS : 2.5 SECONDS), target = A))
			A.visible_message("<span class='info'>[A] jerks their knee after the hammer strikes!</span>")
			if(prob(1))
				playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)
			var/mob/living/carbon/human/human_target = A
			human_target.check_for_injuries(user)
	return ..()

////////////////////
//Improvised Tools//
////////////////////

//All are subtypes of the regular tools with worse behavior success chances.
/obj/item/rogueweapon/surgery/saw/improv
	name = "improvised saw"
	desc = "A tool used to carve through bone crudely, but better than nothing."
	icon_state = "bonesaw_wood"
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_SAW
	sharpness = IS_BLUNT

/obj/item/rogueweapon/surgery/hemostat/improv
	name = "improvised clamp"
	desc = "A tool used to clamp down on soft tissue. A poor alternative to metal but better than nothing."
	icon_state = "forceps_wood"
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT

/obj/item/rogueweapon/surgery/retractor/improv
	name = "improvised retractor"
	desc = "A tool used to spread tissue open for surgical access in a tentative manner."
	icon_state = "speculum_wood"
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR

/obj/item/rogueweapon/surgery/scalpel/improv
	name = "improvised Scalpel"
	desc = "A crude stone blade, it will cut but the precision is to be desired"
	icon_state = "scalpel_wood"
	force = 8
	throwforce = 8
	wdefense = 2
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_SCALPEL
	sharpness = IS_SHARP
