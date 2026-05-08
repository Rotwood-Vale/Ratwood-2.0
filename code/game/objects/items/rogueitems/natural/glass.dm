/obj/item/natural/glass
	name = "glass"
	desc = "Windowpanes for construction work."
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "glasspane"
	dropshrink = 0.8
	grid_width = 64
	grid_height = 64
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 8
	throw_range = 5
	obj_flags = null
	max_integrity = 20
	w_class = WEIGHT_CLASS_BULKY
	bundletype = /obj/item/natural/bundle/glass
	sellprice = 6

/obj/item/natural/glass/heated
	name = "heated glass"
	desc = "A glowing gather of molten glass, workable with a blowing rod while hot."
	icon_state = "glasspane"
	color = "#ffb36a"
	w_class = WEIGHT_CLASS_SMALL
	bundletype = null
	var/datum/glass_blow_recipe/selected_recipe
	var/blow_progress = 0
	var/blows_required = 3

/obj/item/natural/glass/heated/proc/has_heat_protection(mob/living/user)
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	// Check glove slots for heat protection
	if(!H.gloves)
		return FALSE
	// Check if gloves have fire/heat protection
	if(H.gloves.resistance_flags & FIRE_PROOF)
		return TRUE
	if(H.gloves.heat_protection && H.gloves.max_heat_protection_temperature)
		return TRUE
	return FALSE

/obj/item/natural/glass/heated/attack_hand(mob/living/user)
	if(!user)
		return ..()
	
	if(user.get_active_held_item() == src)
		return ..()  // Already holding it, don't check again
	
	// Check if user has heat protection before picking up
	if(!has_heat_protection(user))
		user.visible_message(span_warning("[user] tries to grab the heated glass but quickly pulls back from the heat!"), \
							span_warning("I try to grab the heated glass, but it's too hot!"))
		to_chat(user, span_danger("The searing heat burns my hands!"))
		user.apply_damage(15, BURN, pick(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND))
		return TRUE
	
	return ..()

/obj/item/natural/glass/heated/Destroy()
	if(selected_recipe)
		QDEL_NULL(selected_recipe)
	return ..()

/obj/item/natural/glass/heated/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/rogueweapon/blowrod))
		var/obj/item/rogueweapon/blowrod/B = I
		if(B.attach_heated_glass(src, user))
			return TRUE
		return TRUE
	if(istype(I, /obj/item/rogueweapon/tongs))
		var/obj/item/rogueweapon/tongs/T = I
		if(T.hingot)
			to_chat(user, span_warning("[T] are already holding something!"))
			return TRUE
		if(!user.transferItemToLoc(src, T) && src.loc != T)
			src.forceMove(T)
		T.hingot = src
		T.hott = world.time
		addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/rogueweapon/tongs, make_unhot), T.hott), 10 SECONDS)
		T.update_icon()
		to_chat(user, span_notice("I carefully grasp [src] with the tongs."))
		return TRUE
	return ..()

/obj/item/natural/glass/attackby(obj/item, mob/living/user)
	if(item_flags & IN_STORAGE)
		return
	. = ..()

/obj/item/natural/glass/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(!..()) //was it caught by a mob?
		new /obj/item/natural/glass_shard(get_turf(src))
		pixel_x = rand(-3, 3)
		pixel_y = rand(-3, 3)
		new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
		playsound(src, 'sound/foley/glassbreak.ogg', 90, TRUE)
		qdel(src)

/obj/item/natural/glass/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, 4 SECONDS, target = src))
		var/stackcount = 0
		for(var/obj/item/natural/glass/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				new /obj/item/natural/glass(get_turf(user))
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/natural/bundle/glass/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 3)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 3)
				user.put_in_hands(B)
		for(var/obj/item/natural/glass/F in get_turf(src))
			playsound(get_turf(user.loc), 'sound/foley/dropsound/glass_drop.ogg', 90)
			qdel(F)

//................	Glass panes stack	............... //
/obj/item/natural/bundle/glass
	name = "stack of glass"
	desc = "A stack of fragile glass panes."
	icon = 'icons/roguetown/items/crafting.dmi'
	experimental_inhand = FALSE
	icon_state = "glasspane1"
	item_state = "glasspane"
	dropshrink = 0.8
	grid_width = 64
	grid_height = 64
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 15
	throwforce = 18
	throw_range = 2
	firefuel = null
	resistance_flags = null
	firemod = null
	w_class = WEIGHT_CLASS_HUGE
	stackname = "glass"
	stacktype = /obj/item/natural/glass
	maxamount = 3
	icon1 = "glasspane1"
	icon1step = 2
	icon2 = "glasspane2"
	icon2step = 3

/obj/item/natural/bundle/glass/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(!..()) //was it caught by a mob?
		new /obj/item/natural/glass_shard(get_turf(src))
		pixel_x = rand(-3, 3)
		pixel_y = rand(-3, 3)
		new /obj/item/natural/glass_shard(get_turf(src))
		new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
		playsound(src, 'sound/foley/glassbreak.ogg', 95, TRUE)
		qdel(src)

//................	Glass shard	............... //
/obj/item/natural/glass_shard
	name = "shard"
	desc = "A sharp shard of glass."
	icon = 'icons/roguetown/items/crafting.dmi'
	experimental_inhand = FALSE
	icon_state = "shard1"
	item_state = "shard"
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/stab)
	force = 3
	throwforce = 5
	resistance_flags = null
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	max_integrity = 40
	smeltresult = /obj/item/natural/glass/heated

/obj/item/natural/glass_shard/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, force)
	AddComponent(/datum/component/butchering, 150, 65)

/obj/item/natural/glass_shard/Crossed(mob/living/L)
	if(istype(L))
		playsound(loc, 'sound/foley/glass_step.ogg', HAS_TRAIT(L, TRAIT_LIGHT_STEP) ? 30 : 50, TRUE)
	return ..()

