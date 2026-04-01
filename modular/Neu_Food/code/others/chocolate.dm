// Cocoa beans. Sure, let's stick all of it into one file, how bad can that be?
/obj/item/reagent_containers/food/snacks/rogue/cocoa_bean
	name = "cocoa beans"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_b"
	desc = "Cocoa beans, used for making chocolate. Needs to be ground up first."
	bitesize = 1
	faretype = FARE_IMPOVERISHED
	mill_result = /obj/item/reagent_containers/powder/cocoa_powder
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/powder/cocoa_powder
	name = "cocoa powder"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_p"
	desc = "Cocoa powder, used for making chocolate, both solid and liquid. Needs sugar to be processed further."
	var/sugar_added
	var/cooked_type

/obj/item/reagent_containers/powder/cocoa_powder/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R) || sugar_added)
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Adding sugar..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				name = "cocoa-sugar mix"
				desc = "A fine mix of sugar and cocoa. Either nothing but the very first step on your new, sweet destiny, or, already the pan-ultimate step."
				set cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate // You will live WITHOUT a different fucking sprite for each and every possible combination and you VILL LIKE IT. 
				sugar_added = TRUE
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()
	return TRUE
// I hate coding I hate coding. I. HATE. CODING. 


/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return ..()
	if(!R.reagents.has_reagent(/datum/reagent/consumable/milk, 10))
		to_chat(user, span_notice("Needs more milk to work it."))
		return TRUE
	to_chat(user, span_notice("Adding milk.."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/splishy.ogg', 100, TRUE, -1)
	if(do_after(user, short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar_milk(loc)
		qdel(I)
		qdel(src)

	return TRUE
//I cry. God laughs.
/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar_milk
	name = "cocoa-sugar-milk mix"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_s"
	desc = "A fine mix of sugar, cocoa, and milk. Either nothing but the very first step on your new, sweet destiny, or, already the pan-ultimate step."
	tastes = list("bitterness" = 1, "sweetness" = 1)
	bitesize = 1
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate_milk

/obj/item/reagent_containers/powder/cocoa_powder/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/R = I
	update_cooktime(user)
	if(!istype(R))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Adding raisins..."))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar_raisins(loc) // yes yes, bloat, blah-blah, I KNOW. I'M FIGHTING FOR MY LIFE, MY SANITY HERE. I AM NOT A (GOOD) CODER. FORGIVE ME!
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar_raisins
	name = "cocoa-sugar-raisins mix"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_s"
	desc = "A fine mix of sugar, cocoa, and raisins. Either nothing but the very first step on your new, sweet destiny, or, already the pan-ultimate step." //my fucking code, my fucking tastes.
	tastes = list("bitterness" = 1, "sweetness" = 1)
	bitesize = 1
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate_raisin


//Chocolate bars.

/obj/item/reagent_containers/food/snacks/rogue/chocolate
	name = "dark chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_d"
	desc = "A bar of dark chocolate. Bitter, but still delicious."
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR 
	tastes = list("bitterness" = 1,)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6 
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate_milk
	name = "milk chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_l"
	desc = "A bar of milk chocolate. Sweet and delicious."
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | DAIRY
	tastes = list("sweetness" = 2)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate_raisin
	name = "raisin chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_r"
	desc = "A bar of chocolate with raisins. Sweet and chewy."
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | FRUIT 
	tastes = list("sweetness" = 2, "tartness" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)


/obj/item/reagent_containers/food/snacks/rogue/chocolate_honeynut // the stupidly expensive and luxurious item. you can't cook it, you can only buy it.
	name = "honey nut chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_h"
	desc = "A glorious bar of milk chocolate mixed with honey and rocknut, crafted with utmost care by Malumite Chocolatemaker Guilds of mountainous regions of Grenzelhoft. Snack worthy of a King, or a Grand Duke."
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_EXTREME
	foodtype = SUGAR | DAIRY 
	tastes = list("sweetness" = 2, "nuttiness" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/honey = 2, /datum/reagent/consumable/nutriment = SNACK_DECENT)
