/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "A soft warm bed complete with sheets and pillows."
	icon_state = "bed"
	icon = 'icons/obj/objects.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	var/buildstacktype
	var/buildstackamount = 2
	var/bolts = TRUE
	buckleverb = "lay"
	var/broken_matress = FALSE
	var/broken_percentage = 0

/obj/structure/bed/proc/damage_bed(dam_value)
	if(sleepy <= 2) // the bed is already pretty awful and broken (i.e: straw bed/bedroll), so don't break it even further
		return
	broken_percentage += dam_value
	if(!broken_matress && (broken_percentage >= 100))
		broken_matress = TRUE
		sleepy = 1 //Worse than a bedroll, better than nothing
		visible_message(span_warning("\The [src] gives an violent snap. It looks broken!"))
		playsound(src, 'sound/misc/mat/bed break.ogg', 50, TRUE, ignore_walls = FALSE)
		desc += " The bed looks stained and has seen better daes."
	else if(broken_percentage >= 100) // clamp
		broken_percentage = 100
	else
		playsound(src, pick(list('sound/misc/mat/bed squeak (1).ogg','sound/misc/mat/bed squeak (2).ogg','sound/misc/mat/bed squeak (3).ogg')), 25, TRUE, ignore_walls = FALSE)
		if(broken_percentage > 10)
			playsound(src, 'sound/misc/mat/bed damage.ogg', broken_percentage>>2, TRUE, ignore_walls = FALSE)
			
/obj/structure/bed/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE, CALLBACK(src, PROC_REF(can_user_rotate)),CALLBACK(src, PROC_REF(can_be_rotated)),null)

/obj/structure/bed/proc/can_be_rotated(mob/user)
	return TRUE

/obj/structure/bed/proc/can_user_rotate(mob/user)
	var/mob/living/L = user

	if(istype(L))
		if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
			return FALSE
		else
			return TRUE
	else if(isobserver(user) && CONFIG_GET(flag/ghost_interaction))
		return TRUE
	return FALSE

/obj/structure/bed/setDir(newdir)
	..()
	handle_rotation(newdir)

/obj/structure/bed/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.setDir(direction)

/obj/structure/bed/proc/handle_layer()
	if(has_buckled_mobs() && dir == NORTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = OBJ_LAYER

/obj/structure/bed/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/bed/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bed/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct(TRUE)
	else
		return ..()

/obj/structure/bed/post_buckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()

/obj/structure/bed/post_unbuckle_mob(mob/living/M)
	. = ..()
	M.update_cone_show()
