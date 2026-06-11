
/obj/machinery/light/rogue/forge
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "石制锻炉"
	desc = "这座锻炉吟唱着战争与创造的诗篇。"
	icon_state = "forge0"
	base_state = "forge"
	density = TRUE
	anchored = TRUE
	on = FALSE
	climbable = TRUE
	climb_time = 0
	var/heat_time = 20 SECONDS

/obj/machinery/light/rogue/forge/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/rogueweapon/tongs) && on)
		var/obj/item/rogueweapon/tongs/T = W
		if(T.hingot)
			var/tyme = world.time
			T.hott = tyme
			addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), tyme), heat_time)
			T.update_icon()
			user.visible_message(span_info("[user]加热了锭。"))
			var/obj/item/rogueweapon/tongs/heldstuff = user.get_active_held_item()
			if(istype(heldstuff, /obj/item/rogueweapon/tongs/stone))
				heldstuff.obj_integrity -= 1
				if(heldstuff.obj_integrity <= 0)
					heldstuff.hingot.forceMove(get_turf(user))
					heldstuff.hingot = null
					heldstuff.hott = FALSE
					heldstuff.obj_break()
			return
	return ..()
