/* * * * * * * * * * * * * * *	*
 *								*
 *		Butter & Cheese			*
 *								*
 *								*
 * * * * * * * * * * * * * * * 	*/

/*	........   Salting milk (for butter & cheesemaking)   ................ */
/datum/reagent/consumable/milk/salted
	taste_description = "咸牛奶"

/obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, params) // add cook time to containers & salted milk for butter churning
	..()
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk, 15))
			to_chat(user, span_warning("牛奶不足。"))
			return
		to_chat(user, span_warning("往牛奶里加盐。"))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk, 15)
			reagents.add_reagent(/datum/reagent/consumable/milk/salted, 15)
			qdel(I)

/*	............   Churning butter   ................ */
/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/spoon))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, 15))
			to_chat(user, span_warning("咸牛奶不足。"))
			return
		user.visible_message(span_info("[user]搅拌起黄油..."))
		playsound(get_turf(user), 'modular/Neu_Food/sound/churn.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 15)
			new /obj/item/reagent_containers/food/snacks/butter(drop_location())
		return
	..()

// -------------- BUTTER -----------------
/obj/item/reagent_containers/food/snacks/butter
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	name = "黄油条"
	desc = ""
	icon_state = "butter6"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION)
	foodtype = DAIRY
	faretype = FARE_IMPOVERISHED
	slice_path = /obj/item/reagent_containers/food/snacks/butterslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	eating_slice = TRUE

/obj/item/reagent_containers/food/snacks/butter/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		to_chat(user, span_notice("把鸡蛋磕在黄油上。"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			new /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight(drop_location())
			qdel(I)
			qdel(src)
			return
	return ..()


/obj/item/reagent_containers/food/snacks/butter/update_icon()
	if(slices_num)
		icon_state = "butter[slices_num]"
	else
		icon_state = "butter_slice"

/obj/item/reagent_containers/food/snacks/butterslice
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "butter_slice"
	name = "黄油"
	desc = ""
	faretype = FARE_IMPOVERISHED
	foodtype = DAIRY
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)

/obj/item/reagent_containers/food/snacks/butterslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("拌入糖来制作糖霜..."))
			if(do_after(user, long_cooktime, target = src))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
				new /obj/item/reagent_containers/food/snacks/rogue/frosting(drop_location())
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	return ..()


/*	............   Making fresh cheese   ................ */
/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/natural/cloth))
		if(reagents.has_reagent(/datum/reagent/consumable/milk/salted, 5))
			user.visible_message(span_info("[user]滤出新鲜的奶酪..."))
			playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 5)
				new /obj/item/reagent_containers/food/snacks/rogue/cheese(drop_location())
			return
	..()


/*	............   Making cheese wheel   ................ */
/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			user.visible_message(span_info("[user]开始把鲜奶酪包进布里..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel(loc)
				qdel(I)
				qdel(src)
			return
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel
	name = "未完成的奶酪轮"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheesewheel_1"
	w_class = WEIGHT_CLASS_BULKY
	process_step = 1
	var/mature_proc = .proc/maturing_done

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc) && found_table)
			if(process_step == 4)
				return
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				process_step++
				qdel(I)
				switch(process_step)
					if(2)
						icon_state = "cheesewheel_2"
					if(3)
						icon_state = "cheesewheel_3"
					if(4)
						name = "熟成中的奶酪轮"
						icon_state = "cheesewheel_end"
						desc = "正在缓慢凝固，最好再静置一会儿。"
						addtimer(CALLBACK(src, mature_proc), 5 MINUTES)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel/proc/maturing_done()
	playsound(src.loc, 'modular/Neu_Food/sound/rustle2.ogg', 100, TRUE, -1)
	var/obj/item/reagent_containers/food/snacks/rogue/cheddar/cheese = new(loc)
	var/obj/item/natural/cloth/cloth = new(loc)
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		moveToNullspace() //To free the hand up
		H.put_in_hands(cheese)
		H.put_in_hands(cloth)
	qdel(src)


// -------------- CHEESE -----------------
/obj/item/reagent_containers/food/snacks/rogue/cheese
	name = "鲜奶酪"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "freshcheese"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = FRESHCHEESE_NUTRITION)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("奶酪" = 1)
	faretype = FARE_POOR
	foodtype = GRAIN
	eat_effect = null
	rotprocess = SHELFLIFE_DECENT
	become_rot_type = null
	slice_path = null

/obj/item/reagent_containers/food/snacks/rogue/cheddar
	name = "奶酪轮"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheesewheel"
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = FRESHCHEESE_NUTRITION*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("奶酪" = 1)
	faretype = FARE_POOR
	eat_effect = null
	rotprocess = SHELFLIFE_LONG
	slices_num = 6
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	eating_slice = TRUE
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/cheddar/aged
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/cheddar/aged
	name = "熟成奶酪轮"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge
	name = "奶酪角"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheese_wedge"
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	faretype = FARE_POOR
	tastes = list("奶酪" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_LONG
	slices_num = 3
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	eating_slice = TRUE
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged

/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge/aged
	name = "熟成奶酪角"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese_wedge"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/cheddarslice
	name = "奶酪片"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "cheese_slice"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("奶酪" = 1)
	eat_effect = null
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_SHORT
	slices_num = null
	slice_path = null
	become_rot_type = null

/obj/item/reagent_containers/food/snacks/rogue/cheddarslice/aged
	name = "熟成奶酪片"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "blue_cheese_slice"
	faretype = FARE_FINE
	become_rot_type = null
	rotprocess = null


// -------------- FROSTING -----------------
/obj/item/reagent_containers/food/snacks/rogue/frosting
	name = "糖霜"
	desc = "黄油与糖混合打发成的美味糖霜"
	icon = 'modular/Neu_Food/icons/others/dairy.dmi'
	icon_state = "frosting"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("甜糖霜"=1)
	faretype = FARE_NEUTRAL
	foodtype = DAIRY | SUGAR
	eat_effect = /datum/status_effect/buff/sweet
