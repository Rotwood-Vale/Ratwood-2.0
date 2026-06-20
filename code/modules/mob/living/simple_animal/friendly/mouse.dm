/mob/living/simple_animal/mouse
	name = "老鼠"
	desc = ""
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("吱吱！","吱吱！！","吱吱？")
	speak_emote = list("吱吱叫")
	emote_hear = list("吱吱叫。")
	emote_see = list("转圈跑。", "抖了抖。")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "拍扁了"
	response_harm_simple = "拍扁"
	density = FALSE
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	var/body_color //brown, gray and white, leave blank for random
	gold_core_spawnable = FRIENDLY_SPAWN

/mob/living/simple_animal/mouse/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/blank.ogg'=1), 100)
	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"


/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.icon_dead = "mouse_[body_color]_splat"
	death()

/mob/living/simple_animal/mouse/death(gibbed, toast)
	if(!ckey)
		..(1)
		if(!gibbed)
			var/obj/item/reagent_containers/food/snacks/deadmouse/M = new(loc)
			M.icon_state = icon_dead
			M.name = name
			if(toast)
				M.add_atom_colour("#3A3A3A", FIXED_COLOUR_PRIORITY)
				M.desc = ""
		qdel(src)
	else
		..(gibbed)

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, span_notice("[icon2html(src, M)] 吱吱！"))
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "汤姆"
	desc = ""
	response_help_continuous = "抚摸了"
	response_help_simple = "抚摸"
	response_disarm_continuous = "轻轻推开了"
	response_disarm_simple = "轻轻推开"
	response_harm_continuous = "拍扁了"
	response_harm_simple = "拍扁"
	gold_core_spawnable = NO_SPAWN

/obj/item/reagent_containers/food/snacks/deadmouse
	name = "死老鼠"
	desc = ""
	icon = 'icons/mob/animal.dmi'
	icon_state = "mouse_gray_dead"
	bitesize = 3
	eatverb = "吞食"
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/consumable/nutriment/vitamin = 2)
	foodtype = GROSS | MEAT | RAW
	grind_results = list(/datum/reagent/blood = 20, /datum/reagent/liquidgibs = 5)

/obj/item/reagent_containers/food/snacks/deadmouse/examine(mob/user)
	. = ..()
	if (reagents?.has_reagent(/datum/reagent/yuck) || reagents?.has_reagent(/datum/reagent/fuel))
		. += span_warning("它滴着燃油，散发着难闻的气味。")

/obj/item/reagent_containers/food/snacks/deadmouse/attackby(obj/item/I, mob/user, params)
	if(I.get_sharpness() && user.used_intent.type == INTENT_HARM)
		if(isturf(loc))
			new /obj/item/reagent_containers/food/snacks/rogue/meat/steak(loc)
			to_chat(user, span_notice("我屠宰了[src]。"))
			qdel(src)
		else
			to_chat(user, span_warning("我需要把[src]放在平面上才能屠宰！"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/deadmouse/afterattack(obj/target, mob/living/user, proximity_flag)
	if(proximity_flag && reagents && target.is_open_container())
		// is_open_container will not return truthy if target.reagents doesn't exist
		var/datum/reagents/target_reagents = target.reagents
		var/trans_amount = reagents.maximum_volume - reagents.total_volume * (4 / 3)
		if(target_reagents.has_reagent(/datum/reagent/fuel) && target_reagents.trans_to(src, trans_amount))
			to_chat(user, span_notice("我把[src]浸入[target]中。"))
			reagents.trans_to(target, reagents.total_volume)
		else
			to_chat(user, span_warning("那是个糟糕的主意。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/deadmouse/on_grind()
	reagents.clear_reagents()
