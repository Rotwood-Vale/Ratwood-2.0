// Contains:
// Gavel Hammer
// Gavel Block

/obj/item/gavelhammer
	name = "法槌"
	desc = ""
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "gavelhammer"
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("猛砸", "痛打", "审判", "狠敲")
	resistance_flags = FLAMMABLE

/obj/item/gavelhammer/suicide_act(mob/user)
	user.visible_message(span_suicide("[user]用[src]判了自己死刑！看起来是在试图自杀！"))
	playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
	return (BRUTELOSS)

/obj/item/gavelblock
	name = "槌座"
	desc = ""
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "gavelblock"
	force = 2
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

/obj/item/gavelblock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/gavelhammer))
		playsound(loc, 'sound/blank.ogg', 100, TRUE)
		user.visible_message(span_warning("[user]用[I]敲击了[src]。"))
		user.changeNext_move(CLICK_CD_MELEE)
	else
		return ..()
