/* * * * * * * * * * * **
 *						*	-Cooking based on slapcrafting
 *		 NeuFood		*	-Uses defines to track nutrition
 *						*	-Meant to replace menu crafting completely for foods
 *						*
 * * * * * * * * * * * **/


/*	........   Templates / Base items   ................ */
/obj/item/reagent_containers // added vars used in neu cooking, might be used for other things too in the future. How it works is in each items attackby code.
	var/short_cooktime = 2 SECONDS
	var/long_cooktime = 3 SECONDS

/obj/item/reagent_containers/proc/update_cooktime(mob/user)
	if(user.mind)
		short_cooktime = (initial(short_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
		long_cooktime = (initial(long_cooktime) / get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking)))
	else
		short_cooktime = initial(short_cooktime)
		long_cooktime = initial(long_cooktime)

/obj/item/reagent_containers/food/snacks/rogue // base food type, for icons and cooktime, and to make it work with processes like pie making
	icon = 'modular/Neu_Food/icons/unused.dmi' // Still need a backup file lol
	desc = ""
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	foodtype = GRAIN
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	cooktime = 30 SECONDS
	var/process_step // used for pie making and other similar modular foods

/obj/item/reagent_containers/food/snacks/rogue/Initialize(mapload)
	. = ..()
	eatverb = pick("咬","咀嚼","小口啃","狼吞虎咽","大口咬")

/obj/item/reagent_containers/food/snacks/rogue/foodbase // root item for uncooked food thats disgusting when raw
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	bitesize = 3
	eat_effect = /datum/status_effect/debuff/uncookedfood

/obj/item/reagent_containers/food/snacks/rogue/foodbase/New() // disables the random placement on creation for this object MAYBE OBSOLETE?
	..()
	pixel_x = 0
	pixel_y = 0

/obj/item/reagent_containers/food/snacks/rogue/preserved // just convenient way to group food with long rotprocess
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks
	var/chopping_sound = FALSE // does it play a choppy sound when batch sliced?
	var/slice_sound = FALSE // does it play the slice sound when sliced?

/obj/item/reagent_containers/food/snacks/proc/changefood(path, mob/living/eater)
	if(!path || !eater)
		return
	var/turf/T = get_turf(eater)
	if(eater.dropItemToGround(src))
		qdel(src)
	var/obj/item/I = new path(T)
	eater.put_in_active_hand(I)

/obj/effect/decal/cleanable/food/mess // decal applied when throwing minced meat for example
	name = "污渍"
	desc = ""
	color = "#ab9d9d"
	icon_state = "tomato_floor1"
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/user, params)
	if(user.used_intent.blade_class == slice_bclass && W.wlength == WLENGTH_SHORT)
		if(slice_bclass == BCLASS_CHOP)
			user.visible_message(span_notice("[user]把[src]切碎了！"))
			slice(W, user)
			return 1
		else if(slice(W, user))
			return 1
	..()

/* added to proc
/obj/item/reagent_containers/food/snacks/proc/slice(obj/item/W, mob/user)
	if(slice_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
*/
/*	........   Kitchen tools / items   ................ */


/obj/item/rogueweapon/huntingknife/cleaver
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	item_state = "cleaver"
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE

/obj/item/book/rogue/yeoldecookingmanual // new book with some tips to learn
	name = "古旧烹饪之道"
	desc = "由第四代管家斯文德·胖胡子撰写"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "Neu_cooking.json"

/* * * * * * * * * * * * * * *	*
 *								*
 *		Powder & Salt			*
 *								*
 *								*
 * * * * * * * * * * * * * * * 	*/

// -------------- Flour -----------------
/obj/item/reagent_containers/powder/flour
	name = "面粉"
	desc = "怀揣这份志气，我们便能筑起帝国。"
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added

/obj/item/reagent_containers/powder/flour/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/flour/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R) || (water_added))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("需要一张桌子......"))
		return ..()
	if(!R.reagents.has_reagent(/datum/reagent/water, 10))
		to_chat(user, span_notice("还需要更多水才能和开。"))
		return TRUE
	to_chat(user, span_notice("加好水了，现在该揉面了......"))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		name = "湿面粉"
		desc = "在你手中，它注定会成就一番美味。"
		R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/powder/flour/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/dough_base(loc)
			qdel(src)
	else ..()


// -------------- SALT -----------------
/obj/item/reagent_containers/powder/salt
	name = "盐"
	desc = ""
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/salt/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/* -------------- RICE ----------------- */
/obj/item/reagent_containers/food/snacks/grown/rice
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 3
	var/water_added

/obj/item/reagent_containers/food/snacks/grown/rice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R) || (water_added))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, "<span class='notice'>需要一张桌子......</span>")
		return ..()
	if(!R.reagents.has_reagent(/datum/reagent/water, 10))
		to_chat(user, "<span class='notice'>还需要更多水才能淘洗。</span>")
		return TRUE
	to_chat(user, "<span class='notice'>加好水了，现在该用手淘洗了......</span>")
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user,2 SECONDS, target = src))
		user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
		name = "湿米"
		R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#d9d0cb"
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/rice/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user,3 SECONDS, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/ricewet(loc)
			qdel(src)
	else ..()

/* -------------- WET RICE ----------------- */
/obj/item/reagent_containers/food/snacks/rogue/ricewet
	name = "洗净的米"
	desc = ""
	gender = PLURAL
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	list_reagents = list(/datum/reagent/floure = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/powder/mineral
	name = "粗矿粉"
	desc = "研碎后的石粉，再加工一下就能制成矿盐。"
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	var/water_added

/obj/item/reagent_containers/powder/coarse_salt
	name = "粗盐"
	desc = "带着些许砂砾感的粗盐，还可以继续磨成更细的盐。"
	gender = PLURAL
	icon_state = "salt"
	list_reagents = list(/datum/reagent/floure = 1)
	volume = 1
	sellprice = 0
	color = "#999797"
	mill_result = /obj/item/reagent_containers/powder/salt

/obj/item/reagent_containers/powder/mineral/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/flour(get_turf(src))
	..()
	qdel(src)

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R) || (water_added))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("需要一张桌子......"))
		return ..()
	if(!R.reagents.has_reagent(/datum/reagent/water, 10))
		to_chat(user, span_notice("还需要更多水才能处理。"))
		return TRUE
	to_chat(user, span_notice("加好水了，现在该筛滤它了......"))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		name = "处理过的矿粉"
		desc = "还是相当粗糙，还得再筛一遍。"
		R.reagents.remove_reagent(/datum/reagent/water, 10)
		water_added = TRUE
		color = "#666262"
	return TRUE

/obj/item/reagent_containers/powder/mineral/attackby(obj/item/I, mob/user, params)
	if(!water_added)
		return ..()

	if(!istype(I, /obj/item/natural/cloth))
		return ..()

	user.visible_message(span_info("[user]正在筛滤矿粉......"))
	playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
	if(!do_after(user, 3 SECONDS, target = src))
		return ..()

	new /obj/item/reagent_containers/powder/coarse_salt(get_turf(loc))
	qdel(src)
