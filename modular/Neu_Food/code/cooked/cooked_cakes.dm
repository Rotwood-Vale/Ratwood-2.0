/*	.................   Cake   ................... */
/obj/item/reagent_containers/food/snacks/rogue/cake_base
	name = "cake base"
	desc = "With this sweet thing, you shall make them sing."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cake"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/cake_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Spreading fresh cheese on the cake..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Slathering the cake with delicious honey..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work it."))
	else
		return ..()

// -------------- SPIDER-HONEY CAKE (Zybantu) -----------------
/obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	name = "unbaked cake"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycakeuncook"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/hcake
	cooked_smell = /datum/pollutant/food/honey_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY | SUGAR
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/hcake
	name = "zybantine cake"
	desc = "Cake glazed with honey in the famous Zybantium fashion for a delicious sweet treat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "delicious honeyfrosting"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	name = "zybantine cake slice"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycakeslice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = SHELFLIFE_LONG
	
// -------------- CHEESECAKE -----------------

/obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	name = "unbaked cake of cheese"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecakeuncook"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/ccake
	cooked_smell = /datum/pollutant/food/cheese_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	foodtype = GRAIN | DAIRY | SUGAR
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/ccake
	name = "cheesecake"
	desc = "Humenity's favored creation."
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "creamy cheese"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	name = "cheesecake slice"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_FINE
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 2
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = SHELFLIFE_LONG
