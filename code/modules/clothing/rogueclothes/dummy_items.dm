/*
* basically there just to store the abstract items, those used for climbing and flying,
* where they are used to prevent interaction by taking up a slot
* and providing a bit better controls, I guess
*/

/obj/item/clothing/wall_grab
	name = "wall"
	item_state = "grabbing"
	icon_state = "grabbing"
	icon = 'icons/mob/roguehudgrabs.dmi'
	max_integrity = 10
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_effect = TRUE

/obj/item/clothing/wall_grab/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)
	var/turf/openspace = user.loc
	openspace.zFall(user) // slop?

/obj/item/clothing/wall_grab/intercept_zImpact(atom/movable/AM, levels = 1) // with this shit it doesn't generate "X falls through open space". thank u guppyluxx
    . = ..()
    . |= FALL_NO_MESSAGE

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons
	name = "talons"
	desc = "Harpy talons. Birds of prey and all..."
	experimental_inhand = FALSE
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "harpy_talon" // coder kitbash 5 minute sprite ugh
	drop_sound = 'sound/blank.ogg'
	gripped_intents = list(/datum/intent/wing/cut, /datum/intent/wing/shred, /datum/intent/wing/grab, /datum/intent/wing/pick)
	associated_skill = /datum/skill/combat/unarmed
	w_class = WEIGHT_CLASS_HUGE
	wlength = WLENGTH_GREAT
	twohands_required = TRUE
	force = 20
	max_blade_int = 200
	max_integrity = 250
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_effect = FALSE
	pickup_sound = 'sound/blank.ogg'

	var/repair_amount = 5 //The amount of integrity the tattoos will repair themselves
	var/repair_time = 250 //The amount of time between each repair
	var/last_repair //last time the tattoos got repaired

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity < max_integrity)
		START_PROCESSING(SSobj, src)
		return

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/process()
	if(obj_integrity >= max_integrity) 
		STOP_PROCESSING(SSobj, src)
		src.visible_message(span_notice("[src] are in a much better shape now, enough resting!"), vision_distance = 1)
		return
	else if(world.time > src.last_repair + src.repair_time)
		src.last_repair = world.time
		obj_integrity = min(obj_integrity + src.repair_amount, src.max_integrity)
	..()

///obj/item/rogueweapon/huntingknife/equipped(mob/user, slot, initial = FALSE) // idk if I should remove the sound, I think it's p neat even if a bit gamey

/datum/intent/wing/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 8
	item_d_type = "slash"

/datum/intent/wing/shred
	name = "shred"
	icon_state = "inchop"
	attack_verb = list("shreds")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	damfactor = 1.5
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/datum/intent/wing/grab
	name = "talon grab"
	icon_state = "ingrab"
	attack_verb = list("digs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 90
	clickcd = 15
	swingdelay = 0
	damfactor = 1.3
	blade_class = BCLASS_PICK

/datum/intent/wing/pick
	name = "talon pick"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 75
	clickcd = 14
	swingdelay = 12
	damfactor = 1.1
	blade_class = BCLASS_PICK

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/equipped(mob/user, slot, initial)
	. = ..()
	wielded = TRUE

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/attack_self(mob/user)
	if(user.pulling)
		var/mob/living/passenger = user.pulling
		user.stop_pulling()
		passenger.remove_status_effect(/datum/status_effect/debuff/harpy_passenger)
		return

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/dropped(mob/living/carbon/human/user)
	. = ..()
	src.moveToNullspace()
	if(user.pulling)
		var/mob/living/passenger = user.pulling
		user.stop_pulling(TRUE)
		passenger.remove_status_effect(/datum/status_effect/debuff/harpy_passenger)
	user.remove_status_effect(/datum/status_effect/debuff/harpy_flight)

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/intercept_zImpact(atom/movable/AM, levels = 1) // with this shit it doesn't generate "X falls through open space". thank u guppyluxx
    . = ..()
    . |= FALL_NO_MESSAGE

/obj/item/rogueweapon/huntingknife/idagger/harpy_talons/attack(mob/living/target, mob/living/carbon/human/user)
	if(user.used_intent.type == /datum/intent/wing/grab)
		if(isliving(target))
			if(target != user)
				if(user.pulling)
					user.stop_pulling(TRUE)
					return ..() // remove ..() if problems arise
				if(target.checkdefense(user.used_intent, user))
					return FALSE
				user.start_pulling(target, state = 1, supress_message = TRUE, item_override = src) // STATE = 1 OH GOD!! GRAB STATE PASSIVE = 0, AGRO = 1
				/*
				if(user.grab_state < AGRESSIVE)
				if(user.pulling)
					target.grippedby(user, FALSE)
				*/
				if(user.pulling)
					to_chat(user, span_bloody("I am carrying [target] with my talons!! Ha ha ha!!"))
					var/obj/item/grabbing/I = user.get_inactive_held_item()
					if(istype(I, /obj/item/grabbing/))
						I.icon_state = null
					target.apply_status_effect(/datum/status_effect/debuff/harpy_passenger)
					user.buckle_mob(target, TRUE, TRUE, FALSE, 0, 0)
					user.buckle_mob(target, TRUE, TRUE, FALSE, 0, 0) // brute forcing this shit vro..
					return ..() // remove ..() if problems arise
	else
		return ..()

/obj/item/harpy_leg
	name = "harpy's leg"
	item_state = "grabbing"
	icon_state = "grabbing"
	icon = 'icons/mob/roguehudgrabs.dmi'
	drop_sound = 'sound/blank.ogg'
	experimental_inhand = FALSE
	max_integrity = 10
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_effect = TRUE

/obj/item/harpy_leg/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/harpy_leg/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/harpy_leg/intercept_zImpact(atom/movable/AM, levels = 1) // with this shit it doesn't generate "X falls through open space". thank u guppyluxx
    . = ..()
    . |= FALL_NO_MESSAGE
