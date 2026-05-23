/mob/living/carbon/human/species/wildshape/bat
	name = "Bat"
	race = /datum/species/shapebat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/cat_skin
	wildshape_icon = 'icons/mob/animal.dmi'
	wildshape_icon_state = "bat"

/mob/living/carbon/human/species/wildshape/bat/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)

		src.STASTR = 1
		src.STACON = 2
		src.STAWIL = 8
		src.STAPER = 11
		src.STASPD = 18

		if(src.client.prefs?.wildshape_name)
			real_name = "bat ([stored_mob.real_name])"
		else
			real_name = "bat"

/mob/living/carbon/human/species/wildshape/proc/winged_form_fly(vertical_dir)
	if(pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	var/flying_up = (vertical_dir == UP)
	visible_message(span_notice("[src] begins to [flying_up ? "ascend" : "descend"]!"), span_notice("You take flight..."))
	if(do_after(src, 3 SECONDS, target = src))
		if(pulledby == null)
			zMove(vertical_dir, TRUE)
			to_chat(src, span_notice("I fly [flying_up ? "up" : "down"]."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/carbon/human/species/wildshape/bat/proc/fly_up()
	set category = "Winged Form"
	set name = "Fly Up"

	winged_form_fly(UP)

/mob/living/carbon/human/species/wildshape/bat/proc/fly_down()
	set category = "Winged Form"
	set name = "Fly Down"

	winged_form_fly(DOWN)

/datum/species/shapebat
	name = "bat"
	id = "shapebat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOFALLDAMAGE2,
		TRAIT_BRITTLE,
		TRAIT_DODGEEXPERT,
		TRAIT_ZJUMP
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapebat/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), 'sound/vo/mobs/bird/birdfly.ogg', 80, TRUE, -1)

/datum/species/shapebat/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/animal.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "bat"
	H.update_damage_overlays()
	return TRUE

/mob/living/carbon/human/species/wildshape/bat/put_in_hand_check(obj/item/I)
	to_chat(src, span_warning("My wings can't hold that!"))
	return FALSE

/mob/living/carbon/human/species/wildshape/bat/start_pulling(atom/movable/AM, state, force, supress_message, obj/item/item_override)
	if(ismob(AM))
		to_chat(src, span_warning("My wings can't grab that!"))
		return FALSE
	return ..()

/datum/species/shapebat/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.pass_flags |= PASSTABLE | PASSMOB
		H.movement_type |= FLYING
		H.flying = TRUE
		for(var/obj/item/held in H.held_items)
			if(held)
				H.dropItemToGround(held, TRUE)
		H.verbs |= list(
			/mob/living/carbon/human/species/wildshape/bat/proc/fly_up,
			/mob/living/carbon/human/species/wildshape/bat/proc/fly_down
		)

/datum/species/shapebat/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.pass_flags &= ~(PASSTABLE | PASSMOB)
	C.movement_type &= ~FLYING
	C.flying = FALSE
	C.verbs -= list(
		/mob/living/carbon/human/species/wildshape/bat/proc/fly_up,
		/mob/living/carbon/human/species/wildshape/bat/proc/fly_down
	)
	return ..()

/datum/species/shapebat/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

/mob/living/carbon/human/species/wildshape/crow
	name = "Crow"
	race = /datum/species/shapecrow
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/cat_skin
	wildshape_icon = 'icons/roguetown/mob/monster/crow.dmi'
	wildshape_icon_state = "crow_flying"

/mob/living/carbon/human/species/wildshape/crow/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)

		src.STASTR = 1
		src.STACON = 2
		src.STAWIL = 9
		src.STAPER = 12
		src.STASPD = 17

		if(src.client.prefs?.wildshape_name)
			real_name = "crow ([stored_mob.real_name])"
		else
			real_name = "crow"

	update_crow_stance()

/mob/living/carbon/human/species/wildshape/crow
	var/sitting = FALSE

/mob/living/carbon/human/species/wildshape/crow/Move(atom/newloc, direct)
	if(sitting)
		return FALSE
	return ..()

/mob/living/carbon/human/species/wildshape/crow/proc/update_crow_stance()
	icon_state = sitting ? "crow" : "crow_flying"
	regenerate_icons()

/mob/living/carbon/human/species/wildshape/crow/proc/fly_up()
	set category = "Winged Form"
	set name = "Fly Up"

	winged_form_fly(UP)

/mob/living/carbon/human/species/wildshape/crow/proc/fly_down()
	set category = "Winged Form"
	set name = "Fly Down"

	winged_form_fly(DOWN)

/mob/living/carbon/human/species/wildshape/crow/proc/change_stance()
	set category = "Winged Form"
	set name = "Change Stance"

	sitting = !sitting
	update_crow_stance()

/mob/living/carbon/human/species/wildshape/crow/proc/crow_caw()
	set category = "Winged Form"
	set name = "Caw"

	emote("caw", intentional = TRUE, animal = TRUE)

/datum/species/shapecrow
	name = "crow"
	id = "shapecrow"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOFALLDAMAGE2,
		TRAIT_BRITTLE,
		TRAIT_DODGEEXPERT,
		TRAIT_ZJUMP
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapecrow/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/bird/CROW_01.ogg', 'sound/vo/mobs/bird/CROW_02.ogg', 'sound/vo/mobs/bird/CROW_03.ogg'), 80, TRUE, -1)

/datum/species/shapecrow/regenerate_icons(mob/living/carbon/human/H)
	var/mob/living/carbon/human/species/wildshape/crow/C = H
	H.icon = 'icons/roguetown/mob/monster/crow.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = C.sitting ? "crow" : "crow_flying"
	H.update_damage_overlays()
	return TRUE

/mob/living/carbon/human/species/wildshape/crow/put_in_hand_check(obj/item/I)
	to_chat(src, span_warning("My wings can't hold that!"))
	return FALSE

/mob/living/carbon/human/species/wildshape/crow/start_pulling(atom/movable/AM, state, force, supress_message, obj/item/item_override)
	if(ismob(AM))
		to_chat(src, span_warning("My wings can't grab that!"))
		return FALSE
	return ..()

/datum/species/shapecrow/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.pass_flags |= PASSTABLE | PASSMOB
		H.movement_type |= FLYING
		H.flying = TRUE
		for(var/obj/item/held in H.held_items)
			if(held)
				H.dropItemToGround(held, TRUE)
		H.verbs |= list(
			/mob/living/carbon/human/species/wildshape/crow/proc/fly_up,
			/mob/living/carbon/human/species/wildshape/crow/proc/fly_down,
			/mob/living/carbon/human/species/wildshape/crow/proc/change_stance,
			/mob/living/carbon/human/species/wildshape/crow/proc/crow_caw
		)

/datum/species/shapecrow/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.pass_flags &= ~(PASSTABLE | PASSMOB)
	C.movement_type &= ~FLYING
	C.flying = FALSE
	C.verbs -= list(
		/mob/living/carbon/human/species/wildshape/crow/proc/fly_up,
		/mob/living/carbon/human/species/wildshape/crow/proc/fly_down,
		/mob/living/carbon/human/species/wildshape/crow/proc/change_stance,
		/mob/living/carbon/human/species/wildshape/crow/proc/crow_caw
	)
	return ..()

/datum/species/shapecrow/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE
