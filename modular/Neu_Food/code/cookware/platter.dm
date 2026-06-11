/obj/item/cooking/platter
	name = "盘子"
	desc = "用来盛放配得上王侯的美餐。"
	icon = 'modular/Neu_Food/icons/cookware/platter.dmi'
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	icon_state = "platter"
	resistance_flags = NONE
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 32
	sellprice = 0
	obj_flags = UNIQUE_RENAME


/obj/item/cooking/platter/examine()
	. = ..()
	. += span_info("可以用羽毛笔重命名。盛装或完成食物时会覆盖名称。")

/*
NEW SYSTEM
What it does:
	- The platter stays intact, adds object on top of it.
	- Examining the platter tells you what is on the platter
	- Adds food overlay to the platre
	- Can remove item with right click
	- Using it will eat the food on it
	- Use initial[name] to revert platter back to being its original name once the food is removed
*/
/*	..................   Food platter   ................... */
/obj/item/cooking/platter/attackby(obj/item/I, mob/user, params)

	if(istype(I, /obj/item/kitchen/fork))
		if(do_after(user, 0.5 SECONDS))
			attack(user, user, user.zone_selected)

	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/))
		if(isturf(loc)&& (found_table))
			if (contents.len == 0)
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_info("我把[I.name]放在了[name]上。"))
				I.forceMove(src)
				var/obj/item/reagent_containers/food/snacks/S = I
				if(S?.faretype < FARE_LAVISH)
					S.faretype++ //Things are tastier on plates.
				update_icon()
			else
				to_chat(user, span_info("[initial(name)]上已经有东西了！先把它拿开。"))
		else
			return ..()


/obj/item/cooking/platter/attack(mob/living/M, mob/living/user, def_zone)
	if(contents.len > 0)
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.attack(M,user,def_zone)
		update_icon()


/obj/item/cooking/platter/update_icon()
	if(contents.len > 0)
		var/matrix/M = new
		M.Scale(0.8,0.8)
		contents[1].transform = M
		contents[1].pixel_y = 3

		contents[1].vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		vis_contents += contents[1]
		name = "[contents[1].name]拼盘"
		desc = contents[1].desc
		//Need something better than this in future like a buff
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	else
		vis_contents = 0
		name = initial(name)
		desc = initial(desc)


/obj/item/cooking/platter/attack_right(mob/user)
	if(user.get_active_held_item())
		to_chat(user, span_info("我手上拿着东西，没法这样做！"))
		return

	if(contents.len >0)
		contents[1].vis_flags = 0
		//No need to change scale since and pixel_y I think all food already resets that when you grab it
		contents[1].icon_state = initial(contents[1].icon_state)
		//sometimes food puts an item in its place!!
		if(istype(contents[1],  /obj/item/reagent_containers/food/snacks/))
			var/obj/item/reagent_containers/food/snacks/S = contents[1]
			S.bonus_reagents = list()
			if(S?.faretype > FARE_IMPOVERISHED)
				S.faretype-- //Less tasty off the plate.
		to_chat(user, span_info("我把[contents[1].name]从[initial(name)]上取了下来。"))
		if(!usr.put_in_hands(contents[1]))
			var/atom/movable/S = contents[1]
			S.forceMove(get_turf(src))

	update_icon()

/obj/item/cooking/platter/decrepit
	name = "破旧拼盘"
	desc = "锻打成盘的青铜器皿，边缘仍沾着一抹湿红；那是泼洒的梅洛酒、肉汁，还是鲜血？"
	icon_state = "aplatter"
	color = "#bb9696"
	sellprice = 0

/obj/item/cooking/platter/copper
	name = "铜拼盘"
	desc = "用铜片制成的拼盘。据说与酸性食物搭配时会带出些许金属味。"
	icon_state = "platter_copper"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 8

/obj/item/cooking/platter/pewter
	name = "锡拼盘"
	desc = "一只几乎能被误认成银器的锡盘。"
	icon_state = "platter_tin"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 11

/obj/item/cooking/platter/silver
	name = "银拼盘"
	desc = "一只华贵的银盘，贵族们常以此彰显身份。"
	icon_state = "platter_silver"
	sellprice = 48
	is_silver = TRUE

/obj/item/cooking/platter/gold
	name = "金拼盘"
	desc = "一只华贵的金盘，贵族们常以此彰显身份。"
	icon_state = "platter_gold"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 60

/obj/item/cooking/platter/carved
	name = "雕饰拼盘"
	desc = "你本不该看到这个。"
	icon_state = "aplatter"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 0

/obj/item/cooking/platter/carved/jade
	name = "玉拼盘"
	desc = "一只由玉石雕成的华美拼盘。"
	icon_state = "platter_jade"
	sellprice = 60

/obj/item/cooking/platter/carved/onyxa
	name = "缟玛瑙拼盘"
	desc = "一只由缟玛瑙雕成的华美拼盘。"
	icon_state = "platter_onyxa"
	sellprice = 40

/obj/item/cooking/platter/carved/shell
	name = "贝壳拼盘"
	desc = "一只由贝壳雕成的华美拼盘。"
	icon_state = "platter_shell"
	sellprice = 20

/obj/item/cooking/platter/carved/rose
	name = "玫瑰石拼盘"
	desc = "一只由玫瑰石雕成的华美拼盘。"
	icon_state = "platter_rose"
	sellprice = 25

/obj/item/cooking/platter/carved/amber
	name = "琥珀拼盘"
	desc = "一只由琥珀雕成的华美拼盘。"
	icon_state = "platter_amber"
	sellprice = 60

/obj/item/cooking/platter/carved/opal
	name = "欧泊拼盘"
	desc = "一只由欧泊雕成的华美拼盘。"
	icon_state = "platter_opal"
	sellprice = 90

/obj/item/cooking/platter/carved/coral
	name = "心石拼盘"
	desc = "一只由心石雕成的华美拼盘。"
	icon_state = "platter_coral"
	sellprice = 70

/obj/item/cooking/platter/carved/turq
	name = "蔚蓝石拼盘"
	desc = "一只由蔚蓝石雕成的华美拼盘。"
	icon_state = "platter_turq"
	sellprice = 85
