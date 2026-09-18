/datum/recipe/sauce
	abstract_type = /datum/recipe/sauce
	time = 30 SECONDS
	var/output_amount = 60

/datum/recipe/sauce/check_reagents(datum/reagents/available)
	for(var/R in reagents_list)
		if(available.get_reagent_amount(R) < reagents_list[R])
			return 0
	if((reagents_list ? reagents_list.len : 0) < available.reagent_list.len)
		return -1
	return 1

/datum/recipe/sauce/tomato
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food/snacks/sugar,
	)
	result = /datum/reagent/consumable/sauce/tomato

/datum/recipe/sauce/garlick_butter
	items = list(
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/powder/salt,
	)
	result = /datum/reagent/consumable/sauce/garlick_butter

/datum/recipe/sauce/gravy
	items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/powder/flour,
		/obj/item/reagent_containers/powder/salt,
	)
	reagents_list = list(/datum/reagent/water = 10)
	result = /datum/reagent/consumable/sauce/gravy

/datum/recipe/sauce/cajun_spicy
	items = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food/snacks/pepper,
	)
	reagents_list = list(/datum/reagent/consumable/sauce/cajun = 5)
	result = /datum/reagent/consumable/sauce/cajun_spicy

/datum/recipe/sauce/secret
	result = /datum/reagent/consumable/sauce/secret

/datum/recipe/sauce/secret/New()
	. = ..()
	var/list/possible = list(
		/obj/item/reagent_containers/food/snacks/pepper,
		/obj/item/reagent_containers/food/snacks/allspice,
		/obj/item/reagent_containers/food/snacks/sugar,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten,
		/obj/item/organ/brain,
		/obj/item/organ/eyes,
	)
	var/list/strange = possible.Copy(7)
	items = list(pick(strange))
	possible -= items
	while(items.len < 3)
		items += pick_n_take(possible)

/datum/controller/subsystem/cooking/proc/init_sauce_recipes()
	if(sauce_recipes.len)
		return
	for(var/R in subtypesof(/datum/recipe/sauce))
		if(is_abstract(R))
			continue
		sauce_recipes += new R()

/obj/item/paper/secret_sauce_recipe
	name = "secret sauce recipe"
	desc = "A stained parchment bearing a closely guarded culinary secret."

/obj/item/paper/secret_sauce_recipe/Initialize(mapload)
	. = ..()
	rebuild_info()

/obj/item/paper/secret_sauce_recipe/proc/rebuild_info()
	var/datum/recipe/sauce/secret/R = locate() in SScooking.sauce_recipes
	if(!R)
		return
	info = "<center><h2>Secret Sauce</h2></center><hr><p>Use one of each:</p><ul>"
	for(var/atom/path as anything in R.items)
		info += "<li>[initial(path.name)]</li>"
	info += "</ul>"
	updateinfolinks()
	update_icon()
