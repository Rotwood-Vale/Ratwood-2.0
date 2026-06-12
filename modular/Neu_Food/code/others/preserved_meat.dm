// -------------- SALUMOI (dwarven smoked sausage) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/salami
	name = "烟熏香肠"
	desc = "一种盐腌香肠，据说放上十年都不会坏。传说矮人商队正是拿这种“旅粮”夹在面包片里，做出了最早的三明治。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salumoi5"
	eat_effect = null
	fried_type = null
	slices_num = 5
	bitesize = 5
	eating_slice = TRUE
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	tastes = list("盐腌肉香" = 1)
	rotprocess = null
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/update_icon()
	if(slices_num)
		icon_state = "salumoi[slices_num]"
	else
		icon_state = "salumoi_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	eat_effect = null
	slices_num = 0
	name = "烟熏香肠片"
	icon_state = "salumoi_slice"
	faretype = FARE_NEUTRAL
	fried_type = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	bitesize = 2
	tastes = list("盐腌肉香" = 1)

// -------------- COPPIETTE (dried meat) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	eat_effect = null
	name = "风干肉条"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "jerk5"
	desc = "风干的肉糜条，做法与烟熏香肠相近。嚼起来更费劲些，但总比硬饼干柔软，也没那么干。"
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("盐腌肉香" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)

/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "jerk4"
	if(bitecount == 2)
		icon_state = "jerk3"
	if(bitecount == 3)
		icon_state = "jerk2"
	if(bitecount == 4)
		icon_state = "jerk1"

// -------------- SALO (salted fat) -----------------
/obj/item/reagent_containers/food/snacks/fat/salo
	name = "盐腌肥膘"
	desc = "一整块盐腌猪肥膘，切片即食。瘦肉匮乏时，这是农户储藏间里的老伙计；配点水下肚还挺香。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salo4"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/fat/salo/slice
	faretype = FARE_IMPOVERISHED
	slices_num = 4
	eating_slice = TRUE
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null

/obj/item/reagent_containers/food/snacks/fat/salo/update_icon()
	if(slices_num)
		icon_state = "salo[slices_num]"
	else
		icon_state = "saloslice"

/obj/item/reagent_containers/food/snacks/fat/salo/slice
	name = "盐腌肥膘片"
	icon_state = "saloslice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

// -------------- DRIED FISH FILET -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	name = "风干鱼柳"
	desc = "一片咸得比活鱼还狠的水产肉片。沿海旅人几乎都会备上它，只是记得多带点水。"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "dried_fish_filet"
	eat_effect = null
	fried_type = null
	bitesize = 3
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	tastes = list("咸鱼香" = 1)
	rotprocess = null
