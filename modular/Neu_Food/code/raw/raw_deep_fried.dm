/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	name = "未完成的炸肉排"
	desc = "已拍松的肉片，还差裹上面包屑，再下热油锅。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "nitzel_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_meat

/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往炸肉排上打入一枚蛋。"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋炸肉排"
			desc = "打过鸡蛋的炸肉排坯子，还在等面包屑和热油锅。"
			icon_state = "nitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给炸肉排裹上面包屑。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹屑炸肉排"
			desc = "已经裹好面包屑的炸肉排坯子，就等下锅了。"
			icon_state = "nitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
			update_icon()
			qdel(I)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	name = "蛛肉炸排坯"
	desc = "拍松的蜘蛛肉片，还差裹上面包屑，再下热油锅。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "schnitzel_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_meat

// copy paste code to shame my ancestors (some1 refactor this)
/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往蛛肉炸排上打入一枚蛋。"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋蛛肉炸排"
			desc = "打过鸡蛋的蛛肉炸排坯子，还在等面包屑和热油锅。"
			icon_state = "schnitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给蛛肉炸排裹上面包屑。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹屑蛛肉炸排"
			desc = "已经裹好面包屑的蛛肉炸排坯子，就等下锅了。"
			icon_state = "schnitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
			update_icon()
			qdel(I)
			return
	return ..()

// Squire's delight (deep fried butter)
/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	name = "未完成的侍从之悦"
	desc = "一条裹了鸡蛋的黄油，还差面包屑和热油锅。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "squiresdelight_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_butter

/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 1)
			return
		to_chat(user, span_notice("给黄油裹上面包屑。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹屑侍从之悦"
			desc = "一条裹好面包屑的黄油，就等下锅油炸。"
			icon_state = "squiresdelight_step2"
			process_step = 2
			deep_fried_type = /obj/item/reagent_containers/food/snacks/squiresdelight
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	name = "未完成的嫩炸鸟肉"
	desc = "已拍松的禽肉，还差裹上面包屑，再下热油锅。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "chickentender_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_chicken

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往炸鸟肉上打入一枚蛋。"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "裹蛋嫩炸鸟肉"
			desc = "打过鸡蛋的炸鸟肉坯子，还在等面包屑和热油锅。"
			icon_state = "chickentender_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("给炸鸟肉裹上面包屑。"))
		if(do_after(user, short_cooktime, target = src))
			name = "裹屑嫩炸鸟肉"
			desc = "已经裹好面包屑的炸鸟肉坯子，就等下锅了。"
			icon_state = "chickentender_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
			update_icon()
			qdel(I)
			return
	return ..()
