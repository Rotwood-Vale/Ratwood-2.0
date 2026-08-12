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
	if(!setbranding || !length(setbranding))
		. += span_warning("There is no branding symbol set yet.")
	else
		. += span_warning("It will imprint [setbranding].")

/obj/item/rogueweapon/surgery/cautery/branding/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(!user.cmode)
		if(heated)
			to_chat(user, span_warning("It is too hot to change the symbols!"))
			return
		var/inputty = stripped_input(user, "What would you like to set the brand?\nExample: a small drawing of a rous head", "Enter branding description", null, 64)
		if(inputty)
			setbranding = inputty
			to_chat(user, span_warning("I swap the [!branding_low_quality ? "iron" : "coal"] tip so it will imprint [setbranding]."))
		else
			to_chat(user, span_info("I clear the current branding symbol."))
			setbranding = null
	..()

/obj/item/rogueweapon/surgery/cautery/branding/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	if(!heated)
		return ..()
	if(!length(setbranding))
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
	var/list/zone_options = list()

	if(QDELETED(branding_part) || !istype(branding_part))
		to_chat(user, span_warning("They don't have this part..."))
		return TRUE

	// Construct a prompt for zone-specific branding code. If you change any of these strings, make sure they're changed in the switch case later.
	// Yes, I do want the user to always click the button for the selected part. I don't care if there's only 1 available.
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
				if(testes && testes.is_visible() && testes.ball_size >= DEFAULT_TESTICLES_SIZE) // only allow balls to be branded if average or bigger (slit types have internal balls)
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

	if(length(zone_options))
		zone_options += "Cancel"
	else // failsafe
		if(covered)
			to_chat(user, span_warning("That part is covered!"))
		else
			to_chat(user, span_warning("It doesn't seem like this part can be branded!"))
		return TRUE

	var/branding_text = setbranding // No switcheroos partway through.
	var/final_answer // String. The button the user clicks on when prompted which part to brand.

	// Prompt before do_after
	final_answer = tgui_alert(user, "What do you wish to brand?", "Please answer in [DisplayTimeText(10 SECONDS)]!", zone_options, 10 SECONDS)

	if(!final_answer || final_answer == "Cancel")
		return TRUE

	// Reject branding if disallowed by prefs. Doing it here hides less away from the user.
	if(!branding_self)
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

	// A part has been selected, now we start printing messages to chat and showing the do_after
	var/branding_delay = HAS_TRAIT(user, TRAIT_DUNGEONMASTER) ? 7 SECONDS : (HAS_TRAIT(user, TRAIT_KNOWNCRIMINAL) ? 9 SECONDS : 14 SECONDS) // criminals/dungeoneer burn faster, while non-criminals and towners take the longest time
	if(!branding_self) 
		if(branding_low_quality)
			if(!target.compliance)  // we can only brand ourselves OR the other character must be compliant
				to_chat(user, span_warning("[target]'s moving too much to let me brand [target.p_them()]!"))
				return TRUE
			branding_delay += 3 SECONDS // if they are compliant then there will still be an added delay
		user.visible_message(span_warning("[user] slowly wields [src] towards [target]'s [LOWER_TEXT(final_answer)]."))
		to_chat(target, span_userdanger("[user] is trying to brand me on the [LOWER_TEXT(final_answer)]!"))
	else
		if(!branding_low_quality)
			branding_delay -= 4 SECONDS // quicker to brand yourself using a good tool
		user.visible_message(span_warning("[user] slowly wields [src] onto [user.p_their()] [LOWER_TEXT(final_answer)]."))

	log_combat(user, target, "Branding attempt: \"[branding_text]\" on [final_answer] ([branding_delay]s)")

	if(!do_after(user, branding_delay, target = target))
		if(!QDELETED(target))
			log_combat(user, target, "Branding aborted: \"[branding_text]\" on [final_answer]")
		return TRUE
	if(!user.Adjacent(target) || user.stat >= UNCONSCIOUS)
		log_combat(user, target, "Branding aborted: \"[branding_text]\" on [final_answer]")
		return TRUE

	if(QDELETED(branding_part))
		log_combat(user, target, "Branding part destroyed: \"[branding_text]\" on [final_answer]")
		return TRUE

	// Attempt to re-get the part and place the brand
	var/description_recoil = target.stat < UNCONSCIOUS ? pick("recoils", "writhes", "thrashes", "suffers") : "lays still"
	var/apply_knockdown = TRUE	
	var/apply_message = TRUE
	switch(final_answer)
		if("Head", "Chest", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "Tauric Half")
			if(length(branding_part.branded_writing))
				to_chat(user, span_warning("I reburn over the existing marking."))
			branding_part.branded_writing = branding_text
			apply_knockdown = FALSE
		if("Hind")
			var/obj/item/bodypart/chest/buttocks = branding_part
			if(length(buttocks.branded_writing_on_buttocks))
				to_chat(user, span_warning("I reburn over the existing marking."))
			buttocks.branded_writing_on_buttocks = branding_text
		if("Stomach")
			var/obj/item/bodypart/chest/stomach = branding_part
			if(length(stomach.branded_writing_on_stomach))
				to_chat(user, span_warning("I reburn over the existing marking."))
			stomach.branded_writing_on_stomach = branding_text
		if("Neck")
			var/obj/item/bodypart/head/neck = branding_part
			if(length(neck.branded_writing_on_neck))
				to_chat(user, span_warning("I reburn over the existing marking."))
			neck.branded_writing_on_neck = branding_text
		if("Breasts")
			if(QDELETED(tits))
				return TRUE
			if(length(tits.branded_writing))
				to_chat(user, span_warning("I reburn over the existing marking."))
			tits.branded_writing = branding_text
		if("Dick")
			if(QDELETED(penis))
				return TRUE
			if(length(penis.branded_writing))
				to_chat(user, span_warning("I reburn over the existing marking."))
			penis.branded_writing = branding_text
		if("Vagina")
			if(QDELETED(vagina))
				return TRUE
			if(length(vagina.branded_writing))
				to_chat(user, span_warning("I reburn over the existing marking."))
			vagina.branded_writing = branding_text
		if("Testes")
			if(QDELETED(testes))
				return TRUE
			if(length(testes.branded_writing))
				to_chat(user, span_warning("I reburn over the existing marking."))
			testes.branded_writing = branding_text
		if("Mouth")
			user.visible_message(span_info("[target] [description_recoil] as \the [src] sears onto [target.p_their()] lips! The branding leaves an unrecognizable burn."))
			target.apply_status_effect(/datum/status_effect/mouth_branded)
			to_chat(target, span_userdanger("Your mouth has been seared!"))
			apply_message = FALSE
		else // ooooops we forgot to change things here
			to_chat(user, span_warning("There's a problem with branding this body part."))
			return TRUE

	target.branded = TRUE // makes examine check for branding marks
	target.apply_damage(branding_damage, BURN, branding_part)
	if(!branding_self && apply_knockdown)
		target.Knockdown(1 SECONDS)
	if(apply_message)
		user.visible_message(span_info("[target] [description_recoil] as \the [src] sears a mark on [target.p_their()] [LOWER_TEXT(final_answer)]! The fresh brand shows [span_boldwarning(branding_text)]."))
		to_chat(target, span_userdanger("You have been branded!"))
	
	target.emote(prob(50) ? "painscream" : "scream", forced = TRUE)
	target.Stun(40)
	target.fullscreen_redflash("redflash2")
	playsound(src.loc, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 5)
	update_heated(FALSE)
	if(cool_timer)
		deltimer(cool_timer)
	log_combat(user, target, "Branded successful: \"[branding_text]\" on [final_answer]")
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
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
	to_chat(owner, span_warning("My mouth... It BURNS!"))
	return ..()

/datum/status_effect/mouth_branded/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "mouth_branded")
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
