/* File for raw pie and pie making recipes
 * This account for the "BIG PIE", please do not creep this file or the .dmi for small pie.
 * Not datumized yet cuz of how difficult it is to account for various pies.
 * And I don't wanna copypaste what Vanderlin has
*/

/*	........   Pie making   ................ */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	name = "派底"
	desc = "一切美味馅派的根基。"
	icon = 'modular/Neu_Food/icons/raw/raw_pies.dmi'
	icon_state = "piebottom"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	process_step = 1
	var/applepie
	var/fishy
	var/meaty
	var/potpie
	var/berrypie
	var/poisoning
	var/crabby
	var/substitute //There may be a better way to do this
	cooked_smell = /datum/pollutant/food/pie_base

/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom/update_icon()
	. = ..()
	var/mutable_appearance/piebottom = mutable_appearance(icon, "pieuncooked")
	var/mutable_appearance/roofeat = mutable_appearance(icon, "meatpie_raw")
	var/mutable_appearance/roofish = mutable_appearance(icon, "fishpie_raw")
	if (process_step == 2 && applepie)
		var/mutable_appearance/apple1 = mutable_appearance(icon, "fill_apple1")
		add_overlay(apple1)
//	if (process_step == 2 && potpie)  TESTING DOING POTPIE ANOTHER WAY
//		var/mutable_appearance/pot1 = mutable_appearance(icon, "fill_egg1")
//		add_overlay(pot1)
	if (process_step == 2 && meaty)
		var/mutable_appearance/meat1 = mutable_appearance(icon, "fill_meat1")
		add_overlay(meat1)
	if (process_step == 2 && fishy)
		var/mutable_appearance/fish1 = mutable_appearance(icon, "fill_fish1")
		add_overlay(fish1)
	if (process_step == 2 && berrypie)
		var/mutable_appearance/berry1 = mutable_appearance(icon, "fill_berry1")
		add_overlay(berry1)
	if (process_step == 2 && crabby)
		var/mutable_appearance/crabby1 = mutable_appearance(icon, "fill_crab1")
		add_overlay(crabby1)
	if (process_step == 3 && applepie)
		var/mutable_appearance/apple2 = mutable_appearance(icon, "fill_apple2")
		add_overlay(apple2)
//	if (process_step == 3 && potpie)
//		var/mutable_appearance/pot2 = mutable_appearance(icon, "fill_egg2")
//		add_overlay(pot2)
	if (process_step == 3 && meaty)
		var/mutable_appearance/meat2 = mutable_appearance(icon, "fill_meat2")
		add_overlay(meat2)
	if (process_step == 3 && fishy)
		var/mutable_appearance/fish2 = mutable_appearance(icon, "fill_fish2")
		add_overlay(fish2)
	if (process_step == 3 && berrypie)
		var/mutable_appearance/berry2 = mutable_appearance(icon, "fill_berry2")
		add_overlay(berry2)
	if (process_step == 3 && crabby)
		var/mutable_appearance/crabby2 = mutable_appearance(icon, "fill_crab2")
		add_overlay(crabby2)
	if (process_step == 4 && applepie)
		var/mutable_appearance/apple3 = mutable_appearance(icon, "fill_apple3")
		add_overlay(apple3)
//	if (process_step == 4 && potpie)
//		var/mutable_appearance/pot3 = mutable_appearance(icon, "fill_egg3")
//		add_overlay(pot3)
	if (process_step == 4 && meaty)
		var/mutable_appearance/meat3 = mutable_appearance(icon, "fill_meat3")
		add_overlay(meat3)
	if (process_step == 4 && fishy)
		var/mutable_appearance/fish3 = mutable_appearance(icon, "fill_fish3")
		add_overlay(fish3)
	if (process_step == 4 && berrypie)
		var/mutable_appearance/berry3 = mutable_appearance(icon, "fill_berry3")
		add_overlay(berry3)
	if (process_step == 4 && crabby)
		var/mutable_appearance/crabby3 = mutable_appearance(icon, "fill_crab3")
		add_overlay(crabby3)
	else if (process_step == 5)
		cut_overlays()
		add_overlay(piebottom)
		if (fishy)
			cut_overlays()
			fishy = FALSE
			add_overlay(roofish)
		if (meaty)
			cut_overlays()
			meaty = FALSE
			add_overlay(roofeat)


/obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作鱼派……"))
			name = "未完成的鱼派"
			process_step += 1
			fishy = TRUE
			update_icon()
			qdel(I)
			return
		if(fishy && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往鱼派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(fishy && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("鱼派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作肉派……"))
			name = "未完成的肉派"
			process_step += 1
			meaty = TRUE
			update_icon()
			qdel(I)
			return
		if(meaty && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往肉派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(meaty && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("肉派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced)  || istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/pot1 = mutable_appearance(icon, "fill_pot1")
			add_overlay(pot1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/pot2 = mutable_appearance(icon, "fill_pot2")
			add_overlay(pot2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/pot3 = mutable_appearance(icon, "fill_pot3")
			add_overlay(pot3)
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/egg) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/egg1 = mutable_appearance(icon, "fill_egg1")
			add_overlay(egg1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/egg2 = mutable_appearance(icon, "fill_egg2")
			add_overlay(egg2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/egg3 = mutable_appearance(icon, "fill_egg3")
			add_overlay(egg3)
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/bacon) || istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry) || istype(I, /obj/item/reagent_containers/food/snacks/fat) )
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浓馅派……"))
			name = "未完成的浓馅派"
			process_step += 1
			potpie = TRUE
			var/mutable_appearance/animal1 = mutable_appearance(icon, "fill_fish1")
			add_overlay(animal1)
			qdel(I)
			return
		if(potpie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浓馅派里添馅。还得再加一些。"))
			process_step += 1
			var/mutable_appearance/animal2 = mutable_appearance(icon, "fill_fish2")
			add_overlay(animal2)
			qdel(I)
			return
		if(potpie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浓馅派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			var/mutable_appearance/animal3 = mutable_appearance(icon, "fill_fish3")
			add_overlay(animal3)
			qdel(I)
			return


		var/mutable_appearance/animal1 = mutable_appearance(icon, "fill_fish1")
		add_overlay(animal1)




	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作蟹派……你觉得剩下的某一份蟹肉或许可用卷心菜丝代替。"))
			name = "未完成的蟹派"
			process_step += 1
			crabby = TRUE
			update_icon()
			qdel(I)
			return
		if(crabby && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往蟹派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(crabby && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("蟹派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced))
		if (process_step > 4 || process_step == 1)
			return
		if (substitute == TRUE)
			to_chat(user, span_notice("这只派里的卷心菜已经太多了。"))
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(crabby && process_step >= 2 && process_step <= 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("用卷心菜代替这份蟹派中的一部分蟹肉……"))
			process_step += 1
			substitute = TRUE
			update_icon()
			qdel(I)
			return
		

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作苹果派……"))
			name = "未完成的苹果派"
			process_step += 1
			applepie = TRUE
			update_icon()
			qdel(I)
			return
		if(applepie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往苹果派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(applepie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("苹果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浆果派……"))
			name = "未完成的浆果派"
			process_step += 1
			berrypie = TRUE
			poisoning = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浆果派里添馅。还得再加一些。"))
			process_step += 1
			poisoning = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浆果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			poisoning = TRUE
			update_icon()
			qdel(I)
			return

	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		if (process_step > 4)
			return
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		if(process_step == 1 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("开始制作浆果派……"))
			name = "未完成的浆果派"
			process_step += 1
			berrypie = TRUE
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 2 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("往浆果派里添馅。还得再加一些。"))
			process_step += 1
			update_icon()
			qdel(I)
			return
		if(berrypie && process_step == 3 && do_after(user,short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			to_chat(user, span_notice("浆果派馅料已添得满满当当，但还缺一层派盖。"))
			process_step += 1
			update_icon()
			qdel(I)
			return

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/piedough))
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		if(fishy && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生鱼派"
			icon_state = "fishpie_raw"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
			cooked_smell = /datum/pollutant/food/fish_pie
			filling_color = "#d44197"
			process_step += 1
			update_icon()
			qdel(I)
		else if(meaty && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生肉派"
			icon_state = "meatpie_raw"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/meat
			cooked_smell = /datum/pollutant/food/meat_pie
			filling_color = "#b43628"
			process_step += 1
			update_icon()
			qdel(I)
		else if(potpie && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生浓馅派"
			filling_color = "#755430"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
			cooked_smell = /datum/pollutant/food/pot_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(applepie && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生苹果派"
			filling_color = "#947a4b"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
			cooked_smell = /datum/pollutant/food/apple_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(poisoning && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生浆果派"
			filling_color = "#4a62cf"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison
			cooked_smell = /datum/pollutant/food/berry_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(berrypie && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生浆果派"
			filling_color = "#4a62cf"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
			cooked_smell = /datum/pollutant/food/berry_pie
			process_step += 1
			update_icon()
			qdel(I)
		else if(crabby && process_step == 4 && do_after(user,short_cooktime, target = src))
			name = "生蟹派"
			filling_color = "#f1e0cb"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
			cooked_smell = /datum/pollutant/food/crab_pie
			process_step += 1
			update_icon()
			qdel(I)
	else
		return ..()
	return ..()
