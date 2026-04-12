// Cocoa beans. Sure, let's stick all of it into one file, how bad can that be?
/obj/item/reagent_containers/food/snacks/rogue/cocoa_bean
	name = "cocoa beans"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_b"
	desc = "Cocoa beans, used for making chocolate. Need to be ground up first."
	bitesize = 1
	faretype = FARE_IMPOVERISHED
	mill_result = /obj/item/reagent_containers/powder/cocoa_powder
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/powder/cocoa_powder
	name = "cocoa powder"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_p"
	desc = "Cocoa powder, used for making chocolate, both solid and liquid. Needs sugar if you wish to make a chocolate bar."

/obj/item/reagent_containers/powder/cocoa_powder/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/container = I
	update_cooktime(user)
	if(!istype(container))
		return ..()
	if(isturf(loc)&& (!found_table))
		to_chat(user, span_notice("Need a table..."))
		return ..()
	if(istype(container, /obj/item/reagent_containers/food/snacks/sugar))
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
		to_chat(user, span_notice("Adding sugar and forming a mix..."))
		if(do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar(loc)
			qdel(container)
			qdel(src)
		return TRUE


/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar
	name = "Chocolate mass"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "cocoa_s"
	desc = "A fine mix of sugar and cocoa. Either nothing but the very first step on your new, sweet destiny, or, already the pan-ultimate step."
	tastes = list("bitterness" = 1, "sweetness" = 1)
	bitesize = 1
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate

/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/attackby(obj/item/I, mob/living/user, params)
    var/found_table = locate(/obj/structure/table) in (loc)
    var/obj/item/reagent_containers/container = I
    update_cooktime(user)
    if(!istype(container) && !istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins) && !istype(I, /obj/item/clothing/head/peaceflower))
        return ..()
    if(isturf(loc) && (!found_table))
        to_chat(user, span_notice("Need a table..."))
        return ..()
    
    // Handle milk
    if(container && container.reagents.has_reagent(/datum/reagent/consumable/milk, 10))
        playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
        to_chat(user, span_notice("Adding milk and mixing..."))
        if(do_after(user, short_cooktime, target = src))
            add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
            new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/milk(loc)
            qdel(container)
            qdel(src)
        return TRUE
    
    // Handle raisins
    if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
        playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
        to_chat(user, span_notice("Adding raisins and mixing..."))
        if(do_after(user, short_cooktime, target = src))
            add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
            new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/raisins(loc)
            qdel(I)
            qdel(src)
        return TRUE
    
    // Handle rosa
    if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals)) // originally meant to be peaceflower. doesn't want to work. Woe.
        playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
        to_chat(user, span_notice("Adding the petals and mixing..."))
        if(do_after(user, short_cooktime, target = src))
            add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
            new /obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/eora(loc)
            qdel(I)
            qdel(src)
        return TRUE

    return ..()

/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/milk
	name = "Chocolate mass with milk"
	desc = "A fine mix of sugar, cocoa and milk. You stand at the verge of greatness."
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate/milk
	icon_state = "cocoa_s"

/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/raisins
	name = "Chocolate mass with raisins"
	desc = "A fine mix of sugar, cocoa, and raisins. You stand the precipe of your fall.."
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate/raisin
	icon_state = "cocoa_r"

/obj/item/reagent_containers/food/snacks/rogue/cocoa_sugar/eora
	name = "Chocolate mass with petals"
	desc = "A fine mix of sugar, cocoa, and petals of an Eoran bud. Love is ready to grow, it only needs warmth."
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolate/eora
	icon_state = "cocoa_e"

//Chocolate bars.

/obj/item/reagent_containers/food/snacks/rogue/chocolate
	name = "dark chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_d"
	desc = "A bar of dark chocolate. Bitter, but still delicious."
	faretype = FARE_NEUTRAL
	rotprocess = null
	foodtype = SUGAR 
	tastes = list("bitterness" = 1,)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6 
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate/milk
	name = "milk chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_l"
	desc = "A bar of milk chocolate. Sweet and delicious."
	faretype = FARE_FINE
	rotprocess = null
	foodtype = SUGAR | DAIRY
	tastes = list("sweetness" = 2)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/obj/item/reagent_containers/food/snacks/rogue/chocolate/raisin
	name = "raisin chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_r"
	desc = "A bar of chocolate with raisins. Damning crime against good taste." // my code, my preferences.
	faretype = FARE_FINE
	rotprocess = null
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
	rotprocess = null
	foodtype = SUGAR | DAIRY 
	tastes = list("sweetness" = 2, "nuttiness" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	list_reagents = list(/datum/reagent/consumable/honey = 2, /datum/reagent/consumable/nutriment = SNACK_DECENT)

/obj/item/reagent_containers/food/snacks/rogue/chocolate/eora
	name = "rosa chocolate bar"
	icon = 'modular/Neu_Food/icons/others/chocolate.dmi'
	icon_state = "chocolate_e"
	desc = "A bar of chocolate with petals of a rosa flower mixed in. A symbol of love and longing, favored by those devoted to the Lady of The Hearth."
	faretype = FARE_FINE
	rotprocess = null
	foodtype = SUGAR | FRUIT
	tastes = list("sweetness" = 2, "rosa" = 1, "loving" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet

