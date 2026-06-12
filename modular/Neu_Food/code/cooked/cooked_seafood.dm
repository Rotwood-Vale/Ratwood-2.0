// Cooked seafood. Not including special meals.
/obj/item/reagent_containers/food/snacks/rogue/fryfish
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood.dmi'
	trash = null
	list_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("鱼肉香" = 1)
	name = "熟鱼"
	faretype = FARE_POOR
	desc = "一条烤得焦香、酥脆恰到好处的鱼。"
	icon_state = "carpcooked"
	foodtype = MEAT
	warming = 5 MINUTES
	dropshrink = 0.6

/obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	name = "熟鲤鱼"
	desc = "一条烤得焦香酥脆的鲤鱼，味道温和、肉质结实。适合穷人果腹。"
	icon_state = "carpcooked"
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	name = "熟小丑鱼"
	desc = "一条熟透的小丑鱼，昔日鲜艳的色彩已然褪去。"
	icon_state = "clownfishcooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	name = "熟鮟鱇鱼"
	desc = "一条熟透的鮟鱇鱼，味道甜美浓厚，足以讨人喜欢。"
	icon_state = "anglercooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	name = "熟鳗鱼"
	desc = "一条熟透的鳗鱼。味道浓郁，肉质松软，是一道佳肴。"
	icon_state = "eelcooked"
	faretype = FARE_NEUTRAL
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/jelliedeel

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	name = "熟鳎鱼"
	desc = "一条熟透的鳎鱼，味道温和、肉质松软。适合穷人果腹。"
	icon_state = "solecooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)	
	if(istype(M, /obj/item/reagent_containers/food/snacks/butterslice))
		to_chat(user, "你开始给鳎鱼抹黄油。")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/buttersole(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))	
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	name = "熟鳕鱼"
	desc = "一条熟透的鳕鱼，味道温和、肉质松软，相当受欢迎。"
	icon_state = "codcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/cod/attackby(obj/item/I, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers))
		if(!I.reagents.has_reagent(/datum/reagent/consumable/ethanol/beer, 1))
			to_chat(user, "没有足够的麦酒可以浇在这条鳕鱼上。")
			return TRUE
		to_chat(user, "你开始把麦酒浇到热腾腾的鳕鱼上。")
		playsound(get_turf(user), 'modular/Creechers/sound/milking1.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!I.reagents.has_reagent(/datum/reagent/consumable/ethanol/beer, 1))
				to_chat(user, "没有足够的麦酒可以浇在这条鳕鱼上。")
				return TRUE
			I.reagents.remove_reagent(/datum/reagent/consumable/ethanol/beer, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/alecod(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	name = "熟龙虾"
	desc = "一只熟透的龙虾。味道浓郁甘甜，但肉并不多。单独吃时常被视作穷人食物，但加上黄油或胡椒后就是佳肴。"
	icon_state = "lobstercooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in src.loc
	if(!found_table)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/peppermill))
		var/obj/item/reagent_containers/peppermill/mill = I
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "黑胡椒不够，做不成任何东西。")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "你开始把黑胡椒抹到龙虾上。")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "黑胡椒不够，做不成任何东西。")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "你开始给龙虾抹黄油。")
			if(do_after(user,short_cooktime, target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal(loc)
				qdel(I)
				qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	name = "熟鲑鱼"
	desc = "一条熟透的鲑鱼。煮熟后就没那么吓人了。它的鱼肉丰腴油润，一旦加上香料就颇受欢迎。"
	icon_state = "salmoncooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)	
	if(istype(M, /obj/item/alch/mentha))
		to_chat(user, "你开始把薄荷碾碎撒到鲑鱼上。")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/dendorsalmon(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	if(istype(M, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		to_chat(user, "你开始把浆果碾碎撒到鲑鱼上。")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/berrysalmon(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
		
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))	
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	name = "熟鲽鱼"
	desc = "一条熟透的鲽鱼，味道温和而甘甜。深受富人喜爱。"
	icon_state = "plaicecooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)	
	if(istype(M, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced))
		to_chat(user, "你开始把洋葱铺到鲽鱼下面。")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/onionplaice(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))	
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	name = "熟弹涂鱼"
	desc = "一条熟透的弹涂鱼，带着鱼腥与泥土气息。很受流浪汉欢迎。"
	icon_state = "mudskippercooked"
	faretype = FARE_POOR
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	name = "熟海鲈鱼"
	desc = "一条熟透的海鲈鱼。肉质紧实，很适合搭配香料和酱汁。"
	icon_state = "seabasscooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/bass/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)	
	if(istype(M, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		to_chat(user, "你开始把蒜捣碎撒到鲈鱼上。")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/garlickbass(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))	
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	name = "熟太阳鱼"
	desc = "一条熟透的太阳鱼，肉质细嫩松软。"
	icon_state = "sunnycooked"
	faretype = FARE_POOR
	
/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	name = "熟蛤蜊"
	desc = "一只熟透的蛤蜊，味道甘甜而带海咸，常被拿来煮汤。"
	icon_state = "clamcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam/attackby(obj/item/I, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers))
		if(!I.reagents.has_reagent(/datum/reagent/consumable/milk, 1))
			to_chat(user, "没有足够的牛奶可以浇在这些蛤蜊上。")
			return TRUE
		to_chat(user, "你开始把牛奶浇到热腾腾的蛤蜊上。")
		playsound(get_turf(user), 'modular/Creechers/sound/milking1.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!I.reagents.has_reagent(/datum/reagent/consumable/milk, 1))
				to_chat(user, "没有足够的牛奶可以浇在这些蛤蜊上。")
				return TRUE
			I.reagents.remove_reagent(/datum/reagent/consumable/milk, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/milkclam(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	name = "熟虾"
	desc = "一只熟透的虾，肉质结实弹牙，带着天然咸鲜。"
	icon_state = "shrimpcooked"
	faretype = FARE_NEUTRAL
	name = "熟虾"
	tastes = list("虾仁香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	name = "熟蟹"
	desc = "一只熟透的螃蟹，味道甘甜浓郁。人们常费劲把它做成蟹饼。"
	icon_state = "crabcooked"
	faretype = FARE_NEUTRAL
	name = "熟蟹"
	tastes = list("蟹肉香" = 1)
