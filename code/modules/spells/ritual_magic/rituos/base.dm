/obj/structure/ritualcircle
	name = "ritual circle"
	desc = ""
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "ritual_base"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/allow_dreamwalkers = FALSE

/obj/structure/ritualcircle/attack_hand(mob/living/user)
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("Only the rune of stirring calls to me now..."))
		return FALSE
	return TRUE

/obj/structure/ritualcircle/attack_right(mob/living/carbon/human/user)
	user.visible_message(span_warning("[user] begins wiping away the rune"))
	if(do_after(user, 15))
		playsound(loc, 'sound/foley/cloth_wipe (1).ogg', 100, TRUE)
		qdel(src)
