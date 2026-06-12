/* File for cooked pies and their sprites. This is for BIG PIE.
	Please do not add hand pie or something here.
*/
/obj/item/reagent_containers/food/snacks/rogue/pie
	name = "馅饼"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pies.dmi'
	desc = ""
	color = "#e7e2df"
	dropshrink = 0.8
	var/stunning = FALSE

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked
	icon_state = "馅饼香"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/pieslice
	slices_num = 5
	bitesize = 5
	slice_name = "馅饼切片"
	slice_batch = TRUE
	faretype = FARE_LAVISH //an entire pie! all to yourself!
	portable = FALSE
	warming = 10 MINUTES
	eat_effect = null
	foodtype = GRAIN | DAIRY
	chopping_sound = TRUE
	eat_effect = /datum/status_effect/buff/snackbuff
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/pie/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/reagent_containers/food/snacks/rogue/pie/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(T)
	if(reagents && reagents.total_volume)
		reagents.reaction(hit_atom, TOUCH)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(stunning)
			L.Paralyze(20) //splat!
		L.adjust_blurriness(1)
		L.visible_message(span_warning("[L]被[src]砸中了！"), span_danger("我被[src]砸中了！"))
	if(is_type_in_typecache(hit_atom, GLOB.creamable))
		hit_atom.AddComponent(/datum/component/creamed, src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/pie/CheckParts(list/parts_list)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		filling_color = M.filling_color
		update_snack_overlays(M)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/rogue/pieslice
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("馅饼香" = 1)
	name = "馅饼切片"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pies.dmi'
	desc = ""
	icon_state = "slice"
	filling_color = "#FFFFFF"
	faretype = FARE_FINE
	portable = FALSE
	foodtype = GRAIN | DAIRY
	warming = 5 MINUTES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	color = "#e7e2df"
	rotprocess = SHELFLIFE_LONG

// -------------- MEAT PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat // bae item
	name = "肉馅饼"
	desc = "一份美味的家制肉馅饼，用肉末制成。还需要切开。"
	eat_effect = /datum/status_effect/buff/snackbuff
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/meat
	icon_state = "meatpie"
	tastes = list("多汁肉馅与酥脆黄油面皮" = 1)
	filling_color = "#b43628"
	slice_name = "肉馅饼切片"

// -------------- FISH PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	name = "鱼馅饼"
	desc = "一份美味的家制鱼馅饼，用新鲜鱼肉制成。还需要切开。"
	icon_state = "fishpie"
	tastes = list("烤鱼馅与酥脆黄油面皮" = 1)
	filling_color = "#d44197"
	slice_name = "鱼馅饼切片"


// -------------- POT PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
	name = "炖馅饼"
	desc = "一份美味的家制馅饼。还需要切开。"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	tastes = list("多汁馅料与酥脆黄油面皮" = 1)
	filling_color = "#755430"
	foodtype = GRAIN | DAIRY | MEAT
	slice_name = "炖馅饼切片"

// -------------- BERRY PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	name = "浆果派"
	desc = "一份美味的家制浆果派，用野生浆果制成。还需要切开。"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	slices_num = 4
	tastes = list("酥脆黄油面皮" = 1, "甜浆果香" = 1)
	bitesize = 4
	filling_color = "#4a62cf"
	slice_name = "浆果派切片"

// -------------- POISON PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison
	name = "浆果派"
	desc = "一份美味的家制浆果派，用野生浆果制成。还需要切开。"
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/berrypoison = 12)
	bitesize = 4
	tastes = list("酥脆黄油面皮" = 1, "苦涩浆果香" =1)
	filling_color = "#4a62cf"
	slice_name = "浆果派切片"

// -------------- APPLE PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	name = "苹果派"
	desc = "一份美味的家制苹果派，用切片苹果制成。还需要切开。"
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	bitesize = 4
	tastes = list("烤苹果与酥脆黄油面皮" = 1)
	filling_color = "#947a4b"
	slice_name = "苹果派切片"

// -------------- CRAB PIE -----------------
/obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
	name = "蟹肉派"
	desc = "一份美味的家制蟹肉派，用甲壳类动物的肉制成。还需要切开。"
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	bitesize = 4
	tastes = list("酥脆黄油面皮" = 1, "浓郁蟹肉香" = 1)
	filling_color = "#f1e0cb"
	slice_name = "蟹肉派切片"
