//PUZZLE BOXES

//easy


/obj/item/mundane/puzzlebox/easy
	name = "\improper 木制谜盒"
	desc = "一个谜盒。"
	icon = 'modular_azurepeak/icons/obj/items/mundanities.dmi'
	icon_state = "wood_box"
	var/fluff_desc = "哇。"
	var/list/finished_ckeys = list()
	var/dice_roll = null
	var/alert = null
	sellprice = 5

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/easy/Initialize(mapload)
	. = ..()
	dice_roll = rand(6,15)
	fluff_desc = pick("坦白说，它看起来相当令人沮丧。","我能看见侧面刻着普赛顿送出Syon彗星的雕纹。","看起来似乎没那么难。","它又脏又无聊。","为什么我会想花上几个小时摆弄这玩意？","我大概能找个流浪汉把它解开。","看起来像是给傻子做的。")
	desc += "[fluff_desc]"


/obj/item/mundane/puzzlebox/easy/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("我已经试过解开[src]了。"))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "我的手指摩挲着盒子的外壁。它看起来难度适中。我要试着解开它吗？", "ROGUETOWN", "是", "否") != "是")
		return
	if(do_after(user,70, target = src))
		if((dice_roll) <= user.STAINT)
			to_chat(user, span_notice("我相当轻松地解开了[src]。我感到颇为满足。"))
			user.add_stress(/datum/stressevent/puzzle_easy)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("我解不开[src]。啧！我恼火地把它丢在一边。"))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


//medium

/obj/item/mundane/puzzlebox/medium
	name = "\improper 乌木谜盒"
	icon = 'modular_azurepeak/icons/obj/items/mundanities.dmi'
	icon_state = "ebon_box"
	var/fluff_desc = null
	var/list/finished_ckeys = list()
	var/dice_roll = null
	var/alert = null
	sellprice = 15

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/medium/Initialize(mapload)
	. = ..()
	dice_roll = rand(6,20)
	fluff_desc = pick("它的表面闪着抛光乌木的光泽。","我能看见侧面刻着一位雪精灵。","看起来足以难住一般人。","真希望我的性格能像这盒子一样。","为什么我会想花上几个小时摆弄这玩意？","我大概能把它卖给某个巫师学徒。","它看起来......还算像样。")
	desc += "[fluff_desc]"

/obj/item/mundane/puzzlebox/medium/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("我已经试过解开[src]了。"))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "我的手指摩挲着盒子的外壁。它看起来难度适中。我要试着解开它吗？", "ROGUETOWN", "是", "否") != "是")
		return
	if(do_after(user,70, target = src))
		if((dice_roll) <= user.STAINT)
			to_chat(user, span_notice("我相当轻松地解开了[src]。我感到颇为满足。"))
			user.add_stress(/datum/stressevent/puzzle_medium)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("我解不开[src]。我恼火地把它丢在一边。"))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


//impossible. before you look at this and screech - even the highest int bonus jobs in the game start with a 0% chance assuming worst roll from this to beat this thing
//the only job that can 'consistently' crack this is archivist, who starts with a 30%-ish chance, assuming worst roll from this. but then ur stuck playing archivist so ??? stat-packs help, but you'll still end up worse off tbh


/obj/item/mundane/puzzlebox/impossible //literally nearly impossible to solve - if you do, you get a fairly lengthy buff and a stat boost.
	name = "\improper 皇家谜盒"
	icon = 'modular_azurepeak/icons/obj/items/mundanities.dmi'
	icon_state = "grimace_box"
	var/fluff_desc = null
	var/list/finished_ckeys = list()
	var/dice_roll = null
	sellprice = 150

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/impossible/Initialize(mapload)
	. = ..()
	dice_roll = rand(11,20)
	fluff_desc = pick("坦白说，它看起来几乎不可能解开。","它中央刻着阿斯特拉塔将异端逐出世间的图案。","毫无疑问，这玩意让人相当迷惑。","它看起来充满奥秘，几乎不可能解开。","为什么我觉得自己试上几个小时也不会成功？","就连无聊透顶的档案员大概也会在这玩意前犯难。","它看起来几乎不可能解开。")
	desc += "[fluff_desc]"

/obj/item/mundane/puzzlebox/impossible/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("我已经试过解开[src]了。"))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "我的手指摩挲着盒子的外壁。它看起来几乎不可能解开。我要试着解开它吗？", "ROGUETOWN", "是", "否") != "是")
		return
	if(do_after(user,100, target = src))
		if((dice_roll) + 4 <= user.STAINT)
			to_chat(user, span_notice("经过长久思索，我解开了[src]！"))
			user.add_stress(/datum/stressevent/puzzle_impossible)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)
			to_chat(user, span_notice("当我打开[src]时，一阵酥麻从头顶流窜到脚底。一块蔚蓝色水晶碎片滚了出来。我伸手一抓，它却消失无踪，而我忽然感到精神振奋。"))
			user.STAINT += rand(1,5)
			user.STASTR += rand(1,5)
			user.STASPD += rand(1,5)
			user.STACON += rand(1,5)
			user.STAWIL += rand(1,5)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
			playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("我甚至无从开始解开[src]。我感觉自己蠢透了，只好把它搁到一边。"))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


// food cans

/obj/item/reagent_containers/food/snacks/canned
	name = "波纹铁罐"
	desc = "波纹马口铁里封着罐头食物。"
	icon = 'modular_azurepeak/icons/obj/items/tincans.dmi'
	icon_state = "acan_s"
	sellprice = 70
	var/can_sealed = 1
	var/menu_item = 1
	tastes = null
	bitesize = 1
	list_reagents = null
	bitesize = 5
	rotprocess = null
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'

/obj/item/reagent_containers/food/snacks/canned/Initialize(mapload)


	menu_item = pick(1,2,3,4,5) //get the meal. rand does not work for this and i have no idea why.
	switch(menu_item)
		if(1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/drug/space_drugs = 2, /datum/reagent/berrypoison = 1)
			tastes = list("salty bitter syrup" = 2, "bad mushrooms" = 1)
		if(2)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE, /datum/reagent/medicine/stronghealth = 1, /datum/reagent/water/salty = 3)
			tastes = list("overpoweringly salty rous meat" = 2)
		if(3)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE, /datum/reagent/medicine/stronghealth = 3, /datum/reagent/water/salty = 3)
			tastes = list("cabbit meat" = 1, "thin stew" = 1)
		if(4)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE, /datum/reagent/medicine/stronghealth = 3, /datum/reagent/medicine/strongmana = 3, /datum/reagent/water/salty = 3)
			tastes = list("salt" = 2, "saiga meat" = 1, "vegetables" = 1)
		if(5)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/medicine/stronghealth = 6, /datum/reagent/medicine/strongmana = 6)
			tastes = list("hearty meat stew" = 1, "fresh vegetables" = 1)
	. = ..()


/obj/item/reagent_containers/food/snacks/canned/proc/name_desc() //rename and new description upon opening
	name = "盐罐"
	desc += " 它已经被打开了，里面露出一团散发咸味的糊状物。不知为何，看起来依旧能放到天荒地老。"


/obj/item/reagent_containers/food/snacks/canned/attackby(obj/A, mob/living/user, loc, params)

	if(src.can_sealed == 0)
		to_chat(user, span_warning("它已经打开了！"))

	if(src.can_sealed == 1)

//		if(A.type in subtypesof(/obj/item/rogueweapon/huntingknife)) //knife
		if(istype(A, /obj/item/rogueweapon/huntingknife))
			to_chat(user, span_notice("我把刀刃嵌进去，开始撬开容器的顶部......"))
			playsound(src.loc, 'sound/items/canned_food_open.ogg', 75, TRUE)
			if(do_after(user,50, target = src))
				update_icon()
				src.name_desc()
				src.can_sealed = 0
				update_icon()
				to_chat(user, span_notice("当我扯下盐罐脆薄的顶部时，一股咸味食物的气味扑进了我的鼻腔。"))
				return

//		if(A.type in subtypesof(/obj/item/natural/stone)) //in case someone wants to bash it open with a BOULDER i guess
		if(istype(A, /obj/item/natural/stone))
			to_chat(user, span_notice("我开始乱七八糟地把罐头砸开......"))
			playsound(src.loc, 'sound/items/canned_food_open.ogg', 75, TRUE)
			if(do_after(user,70, target = src))
				src.name_desc()
				src.can_sealed = 0
				update_icon()
				to_chat(user, span_notice("当我把盐罐砸开时，一股咸味食物的气味扑进了我的鼻腔。"))
				return

		else
			to_chat(user, span_warning("我没法用这个打开[src]......"))
			return FALSE


/obj/item/reagent_containers/food/snacks/canned/update_icon()

	if(can_sealed == 0)
		icon_state = "acan"

	else
		icon_state = "acan_s"




/obj/item/reagent_containers/food/snacks/canned/attack(mob/living/M, mob/living/user, def_zone)

	if(src.can_sealed == 1)
		return

	if(bitecount == 4)
		to_chat(user, span_warning("空了。"))
		sellprice = 10 //u ate da FOOD
		return
	..()

/obj/item/reagent_containers/food/snacks/canned/On_Consume()

	if(bitecount == 4) //if it empty, throw up da empty sprite
		icon_state = "acan_e"
		name = "空盐罐"
		desc = "只剩波纹马口铁与散发恶臭的黏糊残渣。"
